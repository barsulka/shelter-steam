#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="${BASH_SOURCE[0]%/*}"
if [[ "$SCRIPT_DIR" == "${BASH_SOURCE[0]}" ]]; then
    SCRIPT_DIR="."
fi
AUTHORITY_VALIDATOR="$SCRIPT_DIR/validate-d024-responsive-presentation.py"

read_authority_contract_sha256() {
    local output
    local pattern='^d024_authority_contract=PASS scheme=raw-bytes-between-markers-v1 sha256=([0-9a-f]{64})$'
    output="$("$AUTHORITY_VALIDATOR" --authority-only)"
    if [[ ! "$output" =~ $pattern ]]; then
        echo "D-024 authority validator returned malformed output" >&2
        exit 1
    fi
    printf '%s' "${BASH_REMATCH[1]}"
}

AUTHORITY_CONTRACT_SHA256="$(read_authority_contract_sha256)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
REPO_DIR="$(cd "$ROOT_DIR/.." && pwd)"
REAL_HOME="${SHELTER_REAL_HOME:-$HOME}"
GODOT_OBSERVER="$ROOT_DIR/tools/observe-godot-process.py"
OUTPUT_DIR="${D024_CAPTURE_DIR:-$REPO_DIR/docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_R48_05A_D024_RESPONSIVE_PRESENTATION_RUNTIME_CAPTURE_v1}"
RUN_HOME="${D024_RUN_HOME:-/tmp/shelter-d024-runtime-home}"
MODE="${1:-capture}"
PARTIAL_BASELINE_FILE_COUNT=32
PARTIAL_BASELINE_TREE_SHA256="4ca49b1d9cd0616d434eb534464087c75cebcd4972122356ad9197ec59cdd378"
STAGE_DIR=""
ROLLBACK_DIR=""
CAPTURE_ACTIVE=0
PROMOTION_COMPLETE=0

if [[ ! -x "$GODOT_OBSERVER" ]]; then
    echo "Godot process supervisor not found or not executable: $GODOT_OBSERVER" >&2
    exit 1
fi

if [[ -f "$OUTPUT_DIR/HASHES.sha256" ]]; then
    echo "D-024 responsive presentation runtime capture v1 is sealed and immutable" >&2
    exit 3
fi

mkdir -p "$RUN_HOME"

verify_observed_result() {
    python3 - "$1" <<'PY'
import json
import sys
from pathlib import Path

result = json.loads(Path(sys.argv[1]).read_text())
if result.get("process_verdict") != "PASS":
    raise SystemExit("D-024 observed child process verdict is not PASS")
if result.get("diagnostic_verdict") != "PASS":
    raise SystemExit("D-024 observed child diagnostic verdict is not PASS")
if result.get("capture_manifest_seal_eligible") is not True:
    raise SystemExit("D-024 observed child is capture/manifest/seal ineligible")
PY
}

run_observed() {
    local summary_log="$1"
    local result_path="$2"
    shift 2
    "$GODOT_OBSERVER" "$@" 2>&1 | tee "$summary_log"
    verify_observed_result "$result_path"
}

evidence_file_count() {
    find "$1" -type f | wc -l | tr -d ' '
}

evidence_tree_sha256() {
    (
        cd "$1"
        find . -type f -print0 | LC_ALL=C sort -z | xargs -0 shasum -a 256
    ) | shasum -a 256 | awk '{print $1}'
}

verify_partial_baseline() {
    local evidence_dir="$1"
    local label="$2"
    local file_count
    local tree_sha256

    if [[ ! -d "$evidence_dir" || -L "$evidence_dir" ]]; then
        echo "D-024 $label baseline is missing, not a directory, or a symlink: $evidence_dir" >&2
        return 1
    fi
    if [[ -e "$evidence_dir/HASHES.sha256" ]]; then
        echo "D-024 $label baseline unexpectedly contains a seal: $evidence_dir" >&2
        return 1
    fi
    file_count="$(evidence_file_count "$evidence_dir")"
    if [[ "$file_count" != "$PARTIAL_BASELINE_FILE_COUNT" ]]; then
        echo "D-024 $label baseline file-count drift: $file_count != $PARTIAL_BASELINE_FILE_COUNT" >&2
        return 1
    fi
    tree_sha256="$(evidence_tree_sha256 "$evidence_dir")"
    if [[ "$tree_sha256" != "$PARTIAL_BASELINE_TREE_SHA256" ]]; then
        echo "D-024 $label baseline tree drift: $tree_sha256" >&2
        return 1
    fi
}

find_transient_sibling() {
    local output_parent="$1"
    local output_base="$2"
    find "$output_parent" -maxdepth 1 -type d \
        \( -name ".$output_base.stage.*" -o -name ".$output_base.rollback.*" \) \
        -print -quit
}

prepare_staged_evidence() {
    local output_parent
    local output_base
    local stale_sibling
    local run_tag

    verify_partial_baseline "$OUTPUT_DIR" "canonical"
    output_parent="$(cd "$(dirname "$OUTPUT_DIR")" && pwd)"
    output_base="$(basename "$OUTPUT_DIR")"
    stale_sibling="$(find_transient_sibling "$output_parent" "$output_base")"
    if [[ -n "$stale_sibling" ]]; then
        echo "D-024 stale transient evidence sibling blocks capture: $stale_sibling" >&2
        return 1
    fi

    STAGE_DIR="$(mktemp -d "$output_parent/.$output_base.stage.XXXXXX")"
    run_tag="${STAGE_DIR##*.stage.}"
    ROLLBACK_DIR="$output_parent/.$output_base.rollback.$run_tag"
    if [[ -e "$ROLLBACK_DIR" ]]; then
        echo "D-024 rollback sibling collision: $ROLLBACK_DIR" >&2
        return 1
    fi

    cp -R "$OUTPUT_DIR/." "$STAGE_DIR/"
    verify_partial_baseline "$STAGE_DIR" "staged copy"
    echo "d024_staged_evidence=$STAGE_DIR"
}

restore_canonical_from_rollback() {
    if [[ -z "$ROLLBACK_DIR" || ! -d "$ROLLBACK_DIR" ]]; then
        return 0
    fi

    if [[ -e "$OUTPUT_DIR" ]]; then
        if [[ -e "$STAGE_DIR" ]]; then
            echo "D-024 cannot retain failed promoted stage; stage path already exists: $STAGE_DIR" >&2
            return 1
        fi
        mv "$OUTPUT_DIR" "$STAGE_DIR"
    fi
    mv "$ROLLBACK_DIR" "$OUTPUT_DIR"
    verify_partial_baseline "$OUTPUT_DIR" "restored canonical"
}

capture_exit_trap() {
    local status="$1"
    trap - EXIT INT TERM HUP

    if [[ "$CAPTURE_ACTIVE" -eq 1 && "$PROMOTION_COMPLETE" -ne 1 ]]; then
        if ! restore_canonical_from_rollback; then
            echo "D-024 rollback restoration failed" >&2
            exit 90
        fi
        if ! verify_partial_baseline "$OUTPUT_DIR" "post-failure canonical"; then
            echo "D-024 canonical baseline changed during failed capture" >&2
            exit 91
        fi
        if [[ -n "$STAGE_DIR" && -d "$STAGE_DIR" ]]; then
            echo "d024_failed_stage=$STAGE_DIR" >&2
        fi
    fi
    exit "$status"
}

verify_no_touch_state() {
    local actual_sha256
    local expected_sha256
    local target

    "$AUTHORITY_VALIDATOR" >/dev/null
    while read -r expected_sha256 target; do
        actual_sha256="$(shasum -a 256 "$target" | awk '{print $1}')"
        if [[ "$actual_sha256" != "$expected_sha256" ]]; then
            echo "D-024 no-touch hash drift: $target ($actual_sha256)" >&2
            return 1
        fi
    done <<EOF
2620fdb6f2f57331e49859ab9530a7476ab6449a3a52cfb986a3d4f787cf17f2 $ROOT_DIR/tools/validate-d024-responsive-presentation.py
14a37141f418cc38e998d47a2ae678b5ade1c5ebf1a3d3022b4ffd577d1744b8 $ROOT_DIR/tests/vertical_slice_visual/test_labrador_visual_binding.gd
1880d4fe829708d8aba3dbc2e7d9cc43c669e151fb94a1dd818e6ce505a91502 $ROOT_DIR/tools/observe-godot-process.py
ae242d6e90d9be5baa783a1836c1188370bcfc66580d19b6391232a1e47ef44f $ROOT_DIR/tests/tools/test_observe_godot_process.py
199c02075aec761a27ddf9e1a3a896252dfa0ae3be9d92ff7601a0feb75e10a2 $ROOT_DIR/tools/test-player-checkpoints.sh
9cbb7a76050f47911ea286623bd4fd2dfc7b088597ad3d65e477c0687f7cd385 $ROOT_DIR/tools/test-player-day2-return.sh
632ebbdb6f43f0ce5b20ca71e90d8dc8335badf203154f3b6ed8c476b062b15b $ROOT_DIR/tests/launch_surfaces/run.sh
1fa0af9b0c02aa89d6a7745dabda483041ea252e6a9d039ddb0c7f7b4f582f04 $ROOT_DIR/tools/test-player-profile-store.sh
ac20117305bc2daeb80626a6b0a70705d476635c3ce5d5c4d99af190bd7989c0 $ROOT_DIR/tools/test-player-continue.sh
fa4a13db9f2ee9ddca46e03451cc9114e3daf82d71fc269e8b9a2781777951d5 $ROOT_DIR/tests/persistence/test_player_profile_store.gd
da8abbe8fcfe3c792235fba3eb71bf1a45f414c465f6972bb6c4486c10773f8f $ROOT_DIR/tests/player_continue/test_player_continue.gd
025e4e55ecc39ca48ad89803e9ff5eaf857e80f20baa9a83a2218a8aab763051 $ROOT_DIR/scripts/prototypes/vertical_slice/vertical_slice_demo.gd
5428a6d3e319b21ca0a40612cbabdd13fbf59cef147a0e9f08ed3f67b059219f $ROOT_DIR/scripts/persistence/player_profile_store.gd
dac832c2d861a16ad74ba4fb5bdaebaa045b5f63984b9a5be74d45f348fb60fd $ROOT_DIR/scripts/player/player_boot.gd
c09235f051a686fd358fb86baa697f3fb7ce80ef2781207bf55f3bded9cf8104 $ROOT_DIR/tests/launch_surfaces/test_player_boot.gd
EOF
}

verify_previous_evidence() {
    local pack
    for pack in \
        "$REPO_DIR/docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_R48_05A_LABRADOR_RUNTIME_CAPTURE_v1" \
        "$REPO_DIR/docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_R48_05A_LABRADOR_RUNTIME_CAPTURE_v2" \
        "$REPO_DIR/docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_R48_05A_LABRADOR_RUNTIME_CAPTURE_v3" \
        "$REPO_DIR/docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_R48_05A_LABRADOR_RUNTIME_CAPTURE_v4" \
        "$REPO_DIR/docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_R48_05A_LABRADOR_RUNTIME_CAPTURE_v5" \
        "$REPO_DIR/docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_R48_05A_SOURCE_RECONCILED_RUNTIME_CAPTURE_v1"
    do
        if [[ -f "$pack/HASHES.sha256" ]]; then
            (
                cd "$pack"
                shasum -a 256 -c HASHES.sha256 >/dev/null
            )
        fi
    done
}

run_headless_checks() {
    local evidence_dir="$1"
    local process_dir="$evidence_dir/process"
    mkdir -p "$evidence_dir/validation" "$evidence_dir/tests" "$evidence_dir/readback" "$process_dir"

    "$ROOT_DIR/tools/validate-d024-responsive-presentation.py" \
        | tee "$evidence_dir/validation/d024_validator.txt"

    run_observed \
        "$evidence_dir/validation/godot_import.txt" \
        "$process_dir/import/target/process-result.json" \
        import --output-dir "$process_dir/import" --home "$RUN_HOME"
    run_observed \
        "$evidence_dir/validation/godot_vertical_slice_check.txt" \
        "$process_dir/vertical-slice-check/target/process-result.json" \
        script-check --output-dir "$process_dir/vertical-slice-check" --home "$RUN_HOME" \
        --target vertical-slice
    run_observed \
        "$evidence_dir/validation/godot_d024_test_check.txt" \
        "$process_dir/d024-test-check/target/process-result.json" \
        script-check --output-dir "$process_dir/d024-test-check" --home "$RUN_HOME" \
        --target d024-test

    run_observed \
        "$evidence_dir/tests/d024_responsive_presentation_test.txt" \
        "$process_dir/d024-mechanical/target/process-result.json" \
        scene-test --output-dir "$process_dir/d024-mechanical" --home "$RUN_HOME" \
        --target d024
    run_observed \
        "$evidence_dir/tests/labrador_a_h_regression.txt" \
        "$process_dir/labrador-mechanical/target/process-result.json" \
        scene-test --output-dir "$process_dir/labrador-mechanical" --home "$RUN_HOME" \
        --target labrador

    SHELTER_GODOT_HOME="$RUN_HOME" \
        SHELTER_GODOT_OBSERVE_ROOT="$process_dir/player-checkpoints" \
        "$ROOT_DIR/tools/test-player-checkpoints.sh" 2>&1 \
        | tee "$evidence_dir/tests/player_checkpoints.txt"
    SHELTER_GODOT_HOME="$RUN_HOME" \
        SHELTER_GODOT_OBSERVE_ROOT="$process_dir/player-profile-store" \
        "$ROOT_DIR/tools/test-player-profile-store.sh" 2>&1 \
        | tee "$evidence_dir/tests/player_profile_store.txt"
    SHELTER_GODOT_HOME="$RUN_HOME" \
        SHELTER_GODOT_OBSERVE_ROOT="$process_dir/player-day2-return" \
        "$ROOT_DIR/tools/test-player-day2-return.sh" 2>&1 \
        | tee "$evidence_dir/tests/player_day2_return.txt"
    SHELTER_GODOT_HOME="$RUN_HOME" \
        SHELTER_GODOT_OBSERVE_ROOT="$process_dir/player-continue" \
        "$ROOT_DIR/tools/test-player-continue.sh" 2>&1 \
        | tee "$evidence_dir/tests/player_continue_33_cursor.txt"
    SHELTER_GODOT_HOME="$RUN_HOME" \
        SHELTER_GODOT_OBSERVE_ROOT="$process_dir/launch-surfaces" \
        "$ROOT_DIR/tests/launch_surfaces/run.sh" 2>&1 \
        | tee "$evidence_dir/tests/launch_surfaces.txt"

    local manifest_validator="$REAL_HOME/.codex/skills/shelter-dog-animation-pipeline/scripts/validate_dog_animation_manifest.py"
    local runtime_validator="$REAL_HOME/.codex/skills/shelter-dog-animation-pipeline/scripts/validate_dog_runtime_binding.py"
    if [[ ! -f "$manifest_validator" || ! -f "$runtime_validator" ]]; then
        echo "Mandatory Shelter dog-animation-pipeline validators are unavailable" >&2
        exit 1
    fi
    python3 "$manifest_validator" \
        --manifest "$ROOT_DIR/resources/prototypes/vertical_slice/labrador_r48_05a_binding_v1.json" \
        | tee "$evidence_dir/validation/animation_manifest_validator.txt"
    python3 "$runtime_validator" \
        --manifest "$ROOT_DIR/resources/prototypes/vertical_slice/labrador_r48_05a_binding_v1.json" \
        | tee "$evidence_dir/validation/runtime_binding_validator.txt"

    (
        cd "$PACKAGE_DIR"
        shasum -a 256 -c HASHES.sha256
    ) >"$evidence_dir/validation/source_package_hashes.txt"

    find "$ROOT_DIR/assets/prototypes/vertical_slice/authored" -type f -name '*.png' | sort | wc -l \
        >"$evidence_dir/readback/authored_png_count.txt"
    find "$ROOT_DIR/assets/prototypes/vertical_slice/authored" -type f -name '*.png.import' | sort | wc -l \
        >"$evidence_dir/readback/authored_import_count.txt"
    shasum -a 256 \
        "$ROOT_DIR/assets/prototypes/vertical_slice/authored/world/responsive/meadow_tile_rgba_748x224.png" \
        "$ROOT_DIR/assets/prototypes/vertical_slice/authored/world/responsive/fence_boundary_marker_rgba.png" \
        "$ROOT_DIR/scenes/prototypes/vertical_slice/vertical_slice_demo.tscn" \
        "$ROOT_DIR/project.godot" \
        "$ROOT_DIR/scripts/player/player_boot.gd" \
        "$ROOT_DIR/tests/launch_surfaces/test_player_boot.gd" \
        "$ROOT_DIR/scripts/prototypes/vertical_slice/labrador_visual_adapter.gd" \
        "$ROOT_DIR/resources/prototypes/vertical_slice/labrador_r48_05a_binding_v1.json" \
        >"$evidence_dir/readback/runtime_and_no_touch_hashes.txt"
}

run_native_capture() {
    local evidence_dir="$1"
    local process_dir="$evidence_dir/process"
    run_observed \
        "$evidence_dir/tests/d024_native_capture.txt" \
        "$process_dir/d024-native-capture/target/process-result.json" \
        scene-capture --output-dir "$process_dir/d024-native-capture" --home "$RUN_HOME" \
        --target d024 --capture-dir "$evidence_dir"
    run_observed \
        "$evidence_dir/tests/labrador_native_capture.txt" \
        "$process_dir/labrador-native-capture/target/process-result.json" \
        scene-capture --output-dir "$process_dir/labrador-native-capture" --home "$RUN_HOME" \
        --target labrador --capture-dir "$evidence_dir"
}

run_ordinary_player_smoke() {
    local evidence_dir="$1"
    local log="$evidence_dir/tests/ordinary_play_temp_home.txt"
    local process_dir="$evidence_dir/process/ordinary-player"
    run_observed \
        "$log" \
        "$process_dir/target/process-result.json" \
        ordinary-player --output-dir "$process_dir" --home "$RUN_HOME"
    echo "ordinary_play_temp_home=PASS" >>"$log"
}

write_manifest_and_seal() {
    local evidence_dir="$1"
    local git_commit
    local brief_file_sha256_at_capture
    local authority_contract_sha256_recheck
    git_commit="$(git -C "$REPO_DIR" rev-parse HEAD)"

    # Retire only the obsolete unsealed blocker records after every native and
    # mechanical check has succeeded. The existing mechanical logs and JSON
    # snapshots remain as supporting evidence alongside the real-framebuffer
    # Godot self-captures.
    rm -f \
        "$evidence_dir/environment/NATIVE_MACOS_APPLICATION_REGISTRATION_BLOCKER.md" \
        "$evidence_dir/mechanical_manifest.json" \
        "$evidence_dir/readback/unsealed_evidence_files_sha256.txt"
    rmdir "$evidence_dir/environment" 2>/dev/null || true

    shasum -a 256 \
        "$REPO_DIR/AGENTS.md" \
        "$ROOT_DIR/AGENTS.md" \
        "$REPO_DIR/docs/drive/Shelter/00_START_HERE/02_DECISIONS.md" \
        "$REPO_DIR/docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__D024_Responsive_Meadow_Marker_And_Player_Presentation_Cleanup_v1.md" \
        "$REPO_DIR/docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Art_Source_Responsive_Meadow_Left_Cluster_Amendment_v1__PM_Activation_Status.md" \
        "$REPO_DIR/docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Art_Source_Responsive_Meadow_Left_Cluster_Amendment_v1__PM_User_Source_Acceptance.md" \
        "$PACKAGE_DIR/HASHES.sha256" \
        "$REPO_DIR/docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Labrador_P0_Accepted_Action_Manifest_v1.md" \
        >"$evidence_dir/readback/authority_hashes.txt"
    shasum -a 256 \
        "$ROOT_DIR/assets/prototypes/vertical_slice/authored/world/responsive/meadow_tile_rgba_748x224.png" \
        "$ROOT_DIR/assets/prototypes/vertical_slice/authored/world/responsive/meadow_tile_rgba_748x224.png.import" \
        "$ROOT_DIR/assets/prototypes/vertical_slice/authored/world/responsive/fence_boundary_marker_rgba.png" \
        "$ROOT_DIR/assets/prototypes/vertical_slice/authored/world/responsive/fence_boundary_marker_rgba.png.import" \
        "$ROOT_DIR/resources/prototypes/vertical_slice/d024_responsive_presentation_v1.json" \
        "$ROOT_DIR/scripts/prototypes/vertical_slice/vertical_slice_demo.gd" \
        "$ROOT_DIR/tests/vertical_slice_visual/d024_responsive_presentation_test_runner.tscn" \
        "$ROOT_DIR/tests/vertical_slice_visual/test_d024_responsive_presentation.gd" \
        "$ROOT_DIR/tests/vertical_slice_visual/test_labrador_visual_binding.gd" \
        "$ROOT_DIR/tools/validate-d024-responsive-presentation.py" \
        "$ROOT_DIR/tools/observe-godot-process.py" \
        "$ROOT_DIR/tests/tools/test_observe_godot_process.py" \
        "$ROOT_DIR/tools/capture-d024-responsive-presentation.sh" \
        "$ROOT_DIR/tools/test-player-checkpoints.sh" \
        "$ROOT_DIR/tools/test-player-day2-return.sh" \
        "$ROOT_DIR/tests/launch_surfaces/run.sh" \
        "$ROOT_DIR/tools/test-player-profile-store.sh" \
        "$ROOT_DIR/tools/test-player-continue.sh" \
        "$ROOT_DIR/tests/persistence/test_player_profile_store.gd" \
        "$ROOT_DIR/tests/player_continue/test_player_continue.gd" \
        "$ROOT_DIR/scripts/persistence/player_profile_store.gd" \
        "$ROOT_DIR/scripts/player/player_boot.gd" \
        "$ROOT_DIR/tests/launch_surfaces/test_player_boot.gd" \
        >"$evidence_dir/readback/d024_implementation_hashes.txt"
    shasum -a 256 \
        "$REPO_DIR/docs/repo/status/CODEX_CURRENT_STATUS.md" \
        "$REPO_DIR/docs/repo/status/CODEX_STATUS.md" \
        "$REPO_DIR/docs/drive/Shelter/04_DEVELOPMENT/CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md" \
        "$REPO_DIR/docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__D024_Responsive_Meadow_Marker_And_Player_Presentation_Cleanup_v1.md" \
        >"$evidence_dir/readback/post_pass_docs_unchanged_hashes.txt"

    brief_file_sha256_at_capture="$(shasum -a 256 \
        "$REPO_DIR/docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__D024_Responsive_Meadow_Marker_And_Player_Presentation_Cleanup_v1.md" \
        | awk '{print $1}')"
    authority_contract_sha256_recheck="$(read_authority_contract_sha256)"
    if [[ "$authority_contract_sha256_recheck" != "$AUTHORITY_CONTRACT_SHA256" ]]; then
        echo "D-024 authority contract changed during capture; refusing to seal" >&2
        exit 1
    fi
    cat >"$evidence_dir/capture_manifest.json" <<EOF
{
  "schema": "shelter.d024-runtime-evidence.v1",
  "date": "2026-07-14",
  "git_commit": "$git_commit",
  "technical_result": "PASS / TECHNICAL_MECHANICAL_ONLY",
  "runtime_art_review": "PENDING",
  "user_acceptance": "PENDING",
  "macos_native": "PASS",
  "authority_contract_scheme": "raw-bytes-between-markers-v1",
  "authority_contract_sha256": "$AUTHORITY_CONTRACT_SHA256",
  "brief_file_sha256_at_capture": "$brief_file_sha256_at_capture",
  "source_acceptance_sha256": "eab92cb51a84361ba48036fed760ebbcdbfac59afe8b3b7d824dd42e84856079",
  "source_package_hashes_sha256": "220a9532f54b8f8ae813f32ac02ef28e35a5d2bde6ded318ecb08a43319e43bf",
  "a_h_manifest_sha256": "d8f1a9fc9226588097eb7bdfc162b6eff520ef42605b369ba25f906daa52ae56",
  "runtime_corpus": {"png": 43, "import_sidecars": 43},
  "notes": [
    "No production player profile was used; all player checks ran under an isolated temporary HOME.",
    "Game imagery is captured by Godot from a real GUI framebuffer; no external desktop capture is required.",
    "Runtime Art and final user review remain external pending gates."
  ]
}
EOF
    cat >"$evidence_dir/README.md" <<'EOF'
# D-024 Responsive Presentation Runtime Capture v1

Technical/mechanical evidence for the accepted D-024 runtime correction.

- Result: `PASS / TECHNICAL_MECHANICAL_ONLY`.
- Runtime Art review: `PENDING`.
- Final user acceptance: `PENDING`.
- macOS native capture/passthrough: `PASS`.
- Authored runtime corpus: exact `43 PNG + 43 .import`; the existing 41 pairs remain untouched.
- The two new PNGs are byte-identical to the accepted source exports.
- Production player profile was not mutated; regression and ordinary launch used an isolated temporary HOME.

The responsive matrix contains 2992/3456/3840 default and right-end RGBA,
black and checker diagnostics. `ah_runtime/` contains current A–H, station,
turn, journey, normal-path and trace evidence from the same runtime.
EOF
    git -C "$REPO_DIR" diff --check >"$evidence_dir/readback/git_diff_check.txt"
    git -C "$REPO_DIR" diff --cached --name-only >"$evidence_dir/readback/staged_paths.txt"
    git -C "$REPO_DIR" status --short >"$evidence_dir/readback/git_status_short.txt"
    (
        cd "$evidence_dir"
        find . -type f ! -name HASHES.sha256 -print0 | LC_ALL=C sort -z | xargs -0 shasum -a 256
    ) >"$evidence_dir/HASHES.sha256"
}

expected_d024_capture_paths() {
    local framing
    local height
    local variant
    local width

    for width in 2992 3456 3840; do
        for framing in default right_end; do
            for variant in black checker rgba; do
                printf './captures/responsive/viewport_%sx224__%s__%s.png\n' \
                    "$width" "$framing" "$variant"
            done
        done
    done
    printf '%s\n' \
        './captures/presentation/dev_mode_diagnostics.png' \
        './captures/presentation/ordinary_ui_hidden.png' \
        './captures/presentation/ordinary_ui_visible.png'
    for height in 144 216 96; do
        printf './captures/native_readability/clean_%s.png\n' "$height"
        printf './captures/native_readability/silhouette_%s.png\n' "$height"
    done
}

verify_sealed_evidence() {
    local authority_contract_sha256_recheck
    local brief_file_sha256_current
    local capture_paths
    local evidence_dir="$1"
    local expected_paths
    local ledger_paths

    if [[ ! -d "$evidence_dir" || -L "$evidence_dir" ]]; then
        echo "D-024 sealed evidence is missing, not a directory, or a symlink: $evidence_dir" >&2
        return 1
    fi
    if [[ ! -s "$evidence_dir/HASHES.sha256" || ! -s "$evidence_dir/capture_manifest.json" ]]; then
        echo "D-024 sealed evidence is missing a non-empty manifest or ledger: $evidence_dir" >&2
        return 1
    fi

    capture_paths="$(
        cd "$evidence_dir"
        find ./captures -type f -name '*.png' -print | LC_ALL=C sort
    )"
    expected_paths="$(expected_d024_capture_paths | LC_ALL=C sort)"
    if [[ "$capture_paths" != "$expected_paths" ]]; then
        echo "D-024 capture matrix is not the exact required 27-PNG set" >&2
        return 1
    fi

    authority_contract_sha256_recheck="$(read_authority_contract_sha256)"
    if [[ "$authority_contract_sha256_recheck" != "$AUTHORITY_CONTRACT_SHA256" ]]; then
        echo "D-024 authority contract changed before evidence verification" >&2
        return 1
    fi
    brief_file_sha256_current="$(shasum -a 256 \
        "$REPO_DIR/docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__D024_Responsive_Meadow_Marker_And_Player_Presentation_Cleanup_v1.md" \
        | awk '{print $1}')"
    python3 - \
        "$evidence_dir/capture_manifest.json" \
        "$AUTHORITY_CONTRACT_SHA256" \
        "$brief_file_sha256_current" <<'PY'
import json
import sys
from pathlib import Path

manifest = json.loads(Path(sys.argv[1]).read_text())
if manifest.get("authority_contract_scheme") != "raw-bytes-between-markers-v1":
    raise SystemExit("D-024 manifest authority scheme mismatch")
if manifest.get("authority_contract_sha256") != sys.argv[2]:
    raise SystemExit("D-024 manifest authority digest mismatch")
if manifest.get("brief_file_sha256_at_capture") != sys.argv[3]:
    raise SystemExit("D-024 manifest whole-brief provenance mismatch")
PY

    (
        cd "$evidence_dir"
        shasum -a 256 -c HASHES.sha256 >/dev/null
    )
    expected_paths="$(
        cd "$evidence_dir"
        find . -type f ! -name HASHES.sha256 -print | LC_ALL=C sort
    )"
    ledger_paths="$(
        cd "$evidence_dir"
        sed -E 's/^[0-9a-f]{64}[[:space:]]+[*]?//' HASHES.sha256 | LC_ALL=C sort
    )"
    if [[ "$expected_paths" != "$ledger_paths" ]]; then
        echo "D-024 evidence ledger is incomplete or contains unexpected paths" >&2
        return 1
    fi
    verify_no_touch_state
}

promote_staged_evidence() {
    verify_sealed_evidence "$STAGE_DIR"
    verify_partial_baseline "$OUTPUT_DIR" "pre-promotion canonical"
    if [[ -e "$ROLLBACK_DIR" ]]; then
        echo "D-024 rollback sibling collision before promotion: $ROLLBACK_DIR" >&2
        return 1
    fi

    mv "$OUTPUT_DIR" "$ROLLBACK_DIR"
    mv "$STAGE_DIR" "$OUTPUT_DIR"
    verify_sealed_evidence "$OUTPUT_DIR"
    rm -rf "$ROLLBACK_DIR"
    PROMOTION_COMPLETE=1
    echo "d024_promoted_evidence=$OUTPUT_DIR"
}

PACKAGE_DIR="$REPO_DIR/docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Art_Source_Responsive_Meadow_Left_Cluster_Amendment_v1"

case "$MODE" in
    validate)
        verify_previous_evidence
        tmp_evidence="$(mktemp -d -t shelter-d024-validation.XXXXXX)"
        run_headless_checks "$tmp_evidence"
        echo "d024_validation_diagnostics=$tmp_evidence"
        ;;
    capture)
        CAPTURE_ACTIVE=1
        trap 'capture_exit_trap $?' EXIT
        trap 'exit 130' INT
        trap 'exit 143' TERM
        trap 'exit 129' HUP
        verify_previous_evidence
        verify_no_touch_state
        prepare_staged_evidence
        run_headless_checks "$STAGE_DIR"
        run_native_capture "$STAGE_DIR"
        run_ordinary_player_smoke "$STAGE_DIR"
        write_manifest_and_seal "$STAGE_DIR"
        promote_staged_evidence
        trap - EXIT INT TERM HUP
        echo "d024_responsive_presentation_capture_pack=$OUTPUT_DIR"
        ;;
    *)
        echo "Usage: tools/capture-d024-responsive-presentation.sh [capture|validate]" >&2
        exit 2
        ;;
esac
