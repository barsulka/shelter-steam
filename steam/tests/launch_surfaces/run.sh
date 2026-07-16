#!/usr/bin/env bash
set -euo pipefail

STEAM_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
OBSERVER="$STEAM_DIR/tools/observe-godot-process.py"
OBSERVE_ROOT="${SHELTER_GODOT_OBSERVE_ROOT:-$(mktemp -d -t shelter-launch-surfaces-observe.XXXXXX)}"
RUN_HOME="${SHELTER_GODOT_HOME:-$(mktemp -d -t shelter-launch-surfaces-home.XXXXXX)}"
RESULT="$OBSERVE_ROOT/launch-surfaces/target/process-result.json"

"$STEAM_DIR/tests/launch_surfaces/test_launch_scripts.sh"

mkdir -p "$OBSERVE_ROOT" "$RUN_HOME"
trap 'echo "godot_process_diagnostics=$OBSERVE_ROOT" >&2' ERR

"$OBSERVER" scene-test \
    --output-dir "$OBSERVE_ROOT/launch-surfaces" \
    --home "$RUN_HOME" \
    --target launch-surfaces
python3 - "$RESULT" <<'PY'
import json
import sys
from pathlib import Path

result = json.loads(Path(sys.argv[1]).read_text())
if result.get("process_verdict") != "PASS" or result.get("diagnostic_verdict") != "PASS":
    raise SystemExit("launch-surface process/diagnostic verdict mismatch")
if result.get("capture_manifest_seal_eligible") is not True:
    raise SystemExit("launch-surface result is evidence-ineligible")
PY

run_hash="$(printf '%s' "$OBSERVE_ROOT/launch-surfaces/target" | shasum -a 256 | awk '{print substr($1,1,12)}')"
global_test_root="$RUN_HOME/Library/Application Support/Godot/app_userdata/Shelter/player-tests/r48-launch-$run_hash"
if [[ -e "$global_test_root" ]]; then
    echo "Launch-surface test did not remove its exact isolated root: $global_test_root" >&2
    exit 1
fi

echo "launch surface Godot tests passed"
echo "godot_process_diagnostics=$OBSERVE_ROOT"
