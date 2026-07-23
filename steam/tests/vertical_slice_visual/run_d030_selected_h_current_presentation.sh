#!/bin/bash
set -euo pipefail

if [[ $# -ne 0 ]]; then
    echo "usage: $0" >&2
    exit 64
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
STEAM_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
REPO_DIR="$(cd "$STEAM_DIR/.." && pwd)"
VALIDATOR="$SCRIPT_DIR/test_d030_selected_h_current_presentation.py"
OBSERVER="$STEAM_DIR/tools/observe-godot-process.py"
AUTHORITY_VALIDATOR="$STEAM_DIR/tools/validate-d024-responsive-presentation.py"
D024_PACK="$REPO_DIR/docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_R48_05A_D024_RESPONSIVE_PRESENTATION_RUNTIME_CAPTURE_v1"

RUN_ROOT="$(mktemp -d "$REPO_DIR/tmp/d030-current-presentation-XXXXXXXX")"
STAGE_ROOT="$(mktemp -d "/private/tmp/shelter-d030-current-presentation-XXXXXXXX")"
OBSERVER_HOME="$STAGE_ROOT/home"
OBSERVER_OUTPUT="$STAGE_ROOT/observer"
PYCACHE_ROOT="$RUN_ROOT/pycache"
MATRIX_ROOT="$OBSERVER_HOME/Library/Application Support/Godot/app_userdata/Shelter/d030-selected-h-current-presentation-v1"
MATRIX_RECORD="$MATRIX_ROOT/matrix.json"
RETAINED_OBSERVER="$RUN_ROOT/observer"
RETAINED_MATRIX_ROOT="$RUN_ROOT/current-profile"
RETAINED_MATRIX_RECORD="$RETAINED_MATRIX_ROOT/matrix.json"
VALIDATION_RESULT="$RUN_ROOT/validation-result.json"
mkdir -p "$OBSERVER_HOME" "$PYCACHE_ROOT"
printf '%s\n' "$STAGE_ROOT" >"$RUN_ROOT/supervisor-stage-path.txt"

PROTECTED_PATHS=(
    "$STEAM_DIR/tests/vertical_slice_visual/d024_responsive_presentation_test_runner.tscn"
    "$STEAM_DIR/tests/vertical_slice_visual/test_d024_responsive_presentation.gd"
    "$STEAM_DIR/tools/validate-d024-responsive-presentation.py"
    "$STEAM_DIR/tools/capture-d024-responsive-presentation.sh"
    "$STEAM_DIR/tools/observe-godot-process.py"
    "$D024_PACK/HASHES.sha256"
)
PROTECTED_EXPECTED=(
    "e699c9a4a9c2039b895777481c4d8756708801b28f86a6b7386e9ea760aaf645"
    "6dc93e9e7610d43a64a495637a3b0388ba6518408cf91e98142013707417abb8"
    "2618815935c32349c2365b12267dd63b6138dc403ff85ea1dcddf54c4c281a4c"
    "2df209f50fe3a83d5b4ecd2375bd216245b79231d01e075e243d327df7e03cd0"
    "1880d4fe829708d8aba3dbc2e7d9cc43c669e151fb94a1dd818e6ce505a91502"
    "707a094c242cb31f39206f6d6e60ae675c24e8f43ebf6e77e22d2f0b70a47d06"
)

write_protected_hashes() {
    local output="$1"
    : >"$output"
    local index
    for index in "${!PROTECTED_PATHS[@]}"; do
        local path="${PROTECTED_PATHS[$index]}"
        local expected="${PROTECTED_EXPECTED[$index]}"
        if [[ ! -f "$path" ]]; then
            echo "protected_path_missing=$path" >&2
            return 1
        fi
        local actual
        actual="$(shasum -a 256 "$path" | awk '{print $1}')"
        if [[ "$actual" != "$expected" ]]; then
            echo "protected_path_hash_mismatch=$path expected=$expected actual=$actual" >&2
            return 1
        fi
        printf '%s  %s\n' "$actual" "${path#$REPO_DIR/}" >>"$output"
    done
}

write_protected_hashes "$RUN_ROOT/protected-pre.sha256"
PYTHONPYCACHEPREFIX="$PYCACHE_ROOT" python3 "$AUTHORITY_VALIDATOR" --authority-only \
    | tee "$RUN_ROOT/d024-authority-pre.txt"

if [[ "$(wc -l <"$D024_PACK/HASHES.sha256" | tr -d ' ')" != "2066" ]]; then
    echo "d024_ledger_entry_count_mismatch" >&2
    exit 1
fi
(
    cd "$D024_PACK"
    shasum -a 256 -c HASHES.sha256
) >"$RUN_ROOT/d024-ledger-check.txt"
echo "d024_ledger_integrity=PASS entries=2066"

PYTHONPYCACHEPREFIX="$PYCACHE_ROOT" python3 "$VALIDATOR" self-test \
    | tee "$RUN_ROOT/validator-self-test.txt"

set +e
PYTHONPYCACHEPREFIX="$PYCACHE_ROOT" python3 "$OBSERVER" ordinary-player \
    --output-dir "$OBSERVER_OUTPUT" \
    --home "$OBSERVER_HOME"
observer_rc=$?
set -e
printf '%s\n' "$observer_rc" >"$RUN_ROOT/observer-supervisor.rc"
if [[ "$observer_rc" -ne 0 ]]; then
    echo "d030_current_profile_observer=FAIL supervisor_rc=$observer_rc run_root=$RUN_ROOT" >&2
    exit "$observer_rc"
fi

if [[ ! -f "$MATRIX_RECORD" ]]; then
    echo "d030_current_profile_matrix_missing=$MATRIX_RECORD" >&2
    exit 1
fi

PYTHONPYCACHEPREFIX="$PYCACHE_ROOT" python3 "$VALIDATOR" validate \
    --matrix "$MATRIX_RECORD" \
    --process-result "$OBSERVER_OUTPUT/target/process-result.json" \
    --stdout "$OBSERVER_OUTPUT/target/stdout.log" \
    --stderr "$OBSERVER_OUTPUT/target/stderr.log" \
    --observer-home "$OBSERVER_HOME" \
    --output "$RUN_ROOT/validation-stage.json" \
    | tee "$RUN_ROOT/validator-stage.txt"

cp -R "$OBSERVER_OUTPUT" "$RETAINED_OBSERVER"
cp -R "$MATRIX_ROOT" "$RETAINED_MATRIX_ROOT"
find "$OBSERVER_OUTPUT" "$MATRIX_ROOT" -type f -print0 \
    | LC_ALL=C sort -z \
    | xargs -0 shasum -a 256 \
    | awk '{print $1}' >"$RUN_ROOT/stage-payload-hashes.txt"
find "$RETAINED_OBSERVER" "$RETAINED_MATRIX_ROOT" -type f -print0 \
    | LC_ALL=C sort -z \
    | xargs -0 shasum -a 256 \
    | awk '{print $1}' >"$RUN_ROOT/retained-payload-hashes.txt"
if ! cmp -s "$RUN_ROOT/stage-payload-hashes.txt" "$RUN_ROOT/retained-payload-hashes.txt"; then
    echo "supervisor_stage_copy_readback=FAIL stage_root=$STAGE_ROOT" >&2
    exit 1
fi
(
    cd "$RUN_ROOT"
    find observer current-profile -type f -print0 \
        | LC_ALL=C sort -z \
        | xargs -0 shasum -a 256
) >"$RUN_ROOT/retained-payload.sha256"

PYTHONPYCACHEPREFIX="$PYCACHE_ROOT" python3 "$VALIDATOR" validate \
    --matrix "$RETAINED_MATRIX_RECORD" \
    --process-result "$RETAINED_OBSERVER/target/process-result.json" \
    --stdout "$RETAINED_OBSERVER/target/stdout.log" \
    --stderr "$RETAINED_OBSERVER/target/stderr.log" \
    --observer-home "$OBSERVER_HOME" \
    --output "$VALIDATION_RESULT" \
    | tee "$RUN_ROOT/validator-retained.txt"
echo "supervisor_stage_copy_readback=PASS"
case "$STAGE_ROOT" in
    /private/tmp/shelter-d030-current-presentation-????????)
        ;;
    *)
        echo "supervisor_stage_cleanup_path_invalid=$STAGE_ROOT" >&2
        exit 1
        ;;
esac
mv "$STAGE_ROOT" "$RUN_ROOT/supervisor-stage"
echo "supervisor_stage_relocated_to_repo_tmp=PASS"

PYTHONPYCACHEPREFIX="$PYCACHE_ROOT" python3 "$AUTHORITY_VALIDATOR" --authority-only \
    | tee "$RUN_ROOT/d024-authority-post.txt"
write_protected_hashes "$RUN_ROOT/protected-post.sha256"
if ! cmp -s "$RUN_ROOT/protected-pre.sha256" "$RUN_ROOT/protected-post.sha256"; then
    echo "protected_path_pre_post_drift=FAIL" >&2
    exit 1
fi

echo "protected_path_pre_post_drift=PASS"
echo "d030_current_profile_author_result=READY_FOR_INDEPENDENT_MECHANICAL_VERIFICATION"
echo "checkpoint_2_authorized=false"
echo "run_root=$RUN_ROOT"
echo "matrix_record=$RETAINED_MATRIX_RECORD"
echo "validation_result=$VALIDATION_RESULT"
