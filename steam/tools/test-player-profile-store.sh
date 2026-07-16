#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OBSERVER="$ROOT_DIR/tools/observe-godot-process.py"
OBSERVE_ROOT="${SHELTER_GODOT_OBSERVE_ROOT:-$(mktemp -d -t shelter-profile-store-observe.XXXXXX)}"
RUN_HOME="${SHELTER_GODOT_HOME:-$(mktemp -d -t shelter-profile-store-home.XXXXXX)}"
RUN_ID="${PLAYER_PROFILE_TEST_RUN_ID:-r48-02a-$$}"
RUN_ROOT="user://player-tests/$RUN_ID"
FULL_BASE="$RUN_ROOT/full"
RESTART_BASE="$RUN_ROOT/restart"
SNAPSHOT_BASE_PREFIX="$RUN_ROOT/snapshot"
RUN_COUNTER=0

if [[ ! "$RUN_ID" =~ ^[A-Za-z0-9][A-Za-z0-9._-]*$ ]] || [[ "$RUN_ID" == "." || "$RUN_ID" == ".." ]]; then
    echo "Invalid isolated player-profile test run id: $RUN_ID" >&2
    exit 1
fi

mkdir -p "$OBSERVE_ROOT" "$RUN_HOME"
trap 'echo "godot_process_diagnostics=$OBSERVE_ROOT" >&2' ERR

verify_result() {
    python3 - "$1" <<'PY'
import json
import sys
from pathlib import Path

result = json.loads(Path(sys.argv[1]).read_text())
if result.get("process_verdict") != "PASS" or result.get("diagnostic_verdict") != "PASS":
    raise SystemExit("profile-store process/diagnostic verdict mismatch")
if result.get("capture_manifest_seal_eligible") is not True:
    raise SystemExit("profile-store result is evidence-ineligible")
PY
}

run_phase() {
    local phase="$1"
    local base="$2"
    local failpoint="${3:-}"
    local expected_status="${4:-}"
    local output
    local -a args
    RUN_COUNTER=$((RUN_COUNTER + 1))
    output="$OBSERVE_ROOT/$(printf '%04d' "$RUN_COUNTER")-$phase"
    args=(
        scene-test
        --output-dir "$output"
        --home "$RUN_HOME"
        --target profile-store
        --phase "$phase"
        --test-base "$base"
    )
    if [[ -n "$failpoint" ]]; then
        args+=(--failpoint "$failpoint")
    fi
    if [[ -n "$expected_status" ]]; then
        args+=(--expected-status "$expected_status")
    fi
    "$OBSERVER" "${args[@]}"
    verify_result "$output/target/process-result.json"
}

run_snapshot_update() {
    local failpoint="$1"
    local base="$SNAPSHOT_BASE_PREFIX-update-$failpoint"
    run_phase snapshot-baseline "$base"
    run_phase snapshot-update "$base" "$failpoint"
    # This is a fresh process inspecting the exact authored intermediate tree.
    run_phase snapshot-inspect "$base" "$failpoint"
}

run_snapshot_create() {
    local failpoint="$1"
    local expected_status="$2"
    local base="$SNAPSHOT_BASE_PREFIX-create-$failpoint"
    run_phase snapshot-create "$base" "$failpoint"
    # This is a fresh process proving deterministic create recovery status.
    run_phase snapshot-inspect "$base" "$failpoint" "$expected_status"
}

# Claim only a fresh exact run-id root. A caller-selected existing root is never
# treated as ours and therefore is never removed by this wrapper.
run_phase assert-absent "$RUN_ROOT"

run_phase full "$FULL_BASE"
run_phase restart-write "$RESTART_BASE"
run_phase restart-read "$RESTART_BASE"

run_snapshot_create before_validation no_valid_profile
run_snapshot_create after_temp_write no_valid_profile
run_snapshot_create after_temp_flush temp_available
run_snapshot_create after_temp_readback temp_available
run_snapshot_create after_primary_promotion primary_available

for failpoint in \
    before_validation \
    after_temp_write \
    after_temp_flush \
    after_temp_readback \
    after_backup_write \
    after_primary_remove \
    after_primary_promotion; do
    run_snapshot_update "$failpoint"
done

run_phase cleanup "$RUN_ROOT"
run_phase assert-absent "$RUN_ROOT"

echo "player profile store tests passed (full + restart + nonfatal authored create/update snapshot matrices)"
echo "godot_process_diagnostics=$OBSERVE_ROOT"
