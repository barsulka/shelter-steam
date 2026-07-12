#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEFAULT_GODOT_BIN="$HOME/Library/Application Support/Steam/steamapps/common/Godot Engine/Godot.app/Contents/MacOS/Godot"
GODOT_BIN="${GODOT_BIN:-$DEFAULT_GODOT_BIN}"
LOG_FILE="$(mktemp -t shelter-player-day2-return.XXXXXX.log)"
trap 'rm -f "$LOG_FILE"' EXIT

"$GODOT_BIN" --headless --path "$ROOT_DIR" \
    --scene res://tests/day2_return/player_day2_return_test_runner.tscn >"$LOG_FILE" 2>&1

if ! rg -q '^player_day2_return_test=passed cursors=33$' "$LOG_FILE" \
    || rg -n 'SCRIPT ERROR|Parse Error|ERROR:' "$LOG_FILE" >/dev/null; then
    cat "$LOG_FILE" >&2
    exit 1
fi

echo "player_day2_return_test=passed cursors=33"
