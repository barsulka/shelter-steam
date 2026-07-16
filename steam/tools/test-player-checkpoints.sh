#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OBSERVER="$ROOT_DIR/tools/observe-godot-process.py"
OBSERVE_ROOT="${SHELTER_GODOT_OBSERVE_ROOT:-$(mktemp -d -t shelter-player-checkpoints-observe.XXXXXX)}"
RUN_HOME="${SHELTER_GODOT_HOME:-$(mktemp -d -t shelter-player-checkpoints-home.XXXXXX)}"
RESULT="$OBSERVE_ROOT/player-checkpoints/target/process-result.json"

mkdir -p "$OBSERVE_ROOT" "$RUN_HOME"
trap 'echo "godot_process_diagnostics=$OBSERVE_ROOT" >&2' ERR

"$OBSERVER" scene-test \
    --output-dir "$OBSERVE_ROOT/player-checkpoints" \
    --home "$RUN_HOME" \
    --target player-checkpoints
python3 - "$RESULT" <<'PY'
import json
import sys
from pathlib import Path

result = json.loads(Path(sys.argv[1]).read_text())
if result.get("process_verdict") != "PASS" or result.get("diagnostic_verdict") != "PASS":
    raise SystemExit("player checkpoint process/diagnostic verdict mismatch")
if result.get("capture_manifest_seal_eligible") is not True:
    raise SystemExit("player checkpoint result is evidence-ineligible")
PY

echo "player_checkpoint_test=passed cursors=17"
echo "godot_process_diagnostics=$OBSERVE_ROOT"
