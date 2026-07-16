#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OBSERVER="$ROOT_DIR/tools/observe-godot-process.py"
OBSERVE_ROOT="${SHELTER_GODOT_OBSERVE_ROOT:-$(mktemp -d -t shelter-player-continue-observe.XXXXXX)}"
RUN_HOME="${SHELTER_GODOT_HOME:-$(mktemp -d -t shelter-player-continue-home.XXXXXX)}"
RUN_ID="${PLAYER_CONTINUE_TEST_RUN_ID:-r48-02b-$$}"
RUN_ROOT="user://player-tests/$RUN_ID"
RUN_COUNTER=0

if [[ ! "$RUN_ID" =~ ^[A-Za-z0-9][A-Za-z0-9._-]*$ ]] || [[ "$RUN_ID" == "." || "$RUN_ID" == ".." ]]; then
    echo "Invalid isolated player-continue test run id: $RUN_ID" >&2
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
    raise SystemExit("player-continue process/diagnostic verdict mismatch")
if result.get("capture_manifest_seal_eligible") is not True:
    raise SystemExit("player-continue result is evidence-ineligible")
PY
}

run_phase() {
    local phase="$1"
    local base="$2"
    local sequence="$3"
    local output
    RUN_COUNTER=$((RUN_COUNTER + 1))
    output="$OBSERVE_ROOT/$(printf '%04d' "$RUN_COUNTER")-$phase-$sequence"
    "$OBSERVER" scene-test \
        --output-dir "$output" \
        --home "$RUN_HOME" \
        --target player-continue \
        --phase "$phase" \
        --test-base "$base" \
        --sequence "$sequence"
    verify_result "$output/target/process-result.json"
}

for sequence in $(seq 1 33); do
    base="$RUN_ROOT/cursor-$sequence"
    run_phase write "$base" "$sequence"
    run_phase read "$base" "$sequence"
    if [[ "$sequence" == 17 ]]; then
        run_phase read "$base" 18
    elif [[ "$sequence" == 1 || "$sequence" == 13 || "$sequence" == 15 || "$sequence" == 18 || "$sequence" == 30 || "$sequence" == 32 || "$sequence" == 33 ]]; then
        run_phase read "$base" "$sequence"
    fi
    run_phase advance "$base" "$( [[ "$sequence" == 17 ]] && echo 18 || echo "$sequence" )"
done

for sequence in 2 3 4 5 6 7 8 9 10 11 12 14 16 19 20 21 22 23 24 25 26 27 28 29 31; do
    base="$RUN_ROOT/inflight-$sequence"
    run_phase snapshot-inflight "$base" "$sequence"
    # Fresh verifier advances from the exact durable process-boundary state.
    run_phase advance "$base" "$sequence"
done

base="$RUN_ROOT/completion-beat-32"
run_phase write "$base" 32
run_phase snapshot-completion-beat "$base" 32
run_phase advance "$base" 32

for sequence in 1 13 15 17 18 25 30; do
    base="$RUN_ROOT/failed-barrier-$sequence"
    run_phase write "$base" "$sequence"
    run_phase snapshot-failed-barrier "$base" "$sequence"
    # Fresh verifier proves that the previous durable cursor was preserved.
    run_phase read "$base" "$sequence"
done

run_phase recovery "$RUN_ROOT/recovery" 1
run_phase save-retry "$RUN_ROOT/save-retry" 1
run_phase automatic-save-retry "$RUN_ROOT/automatic-save-retry" 1
run_phase sequence-rules "$RUN_ROOT/sequence-rules" 1

for sequence in 17 18 25 30 31 32; do
    base="$RUN_ROOT/retry-$sequence"
    run_phase write "$base" "$sequence"
    run_phase retry-cursor "$base" "$sequence"
done

run_phase cleanup "$RUN_ROOT" 1

echo "player_continue_test=passed cursors=33 restart_advance_matrix=true authored_snapshot_matrix=true failed_barrier_restart_matrix=true"
echo "godot_process_diagnostics=$OBSERVE_ROOT"
