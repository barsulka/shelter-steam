#!/usr/bin/env bash
set -euo pipefail

STEAM_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
DEFAULT_GODOT_BIN="$HOME/Library/Application Support/Steam/steamapps/common/Godot Engine/Godot.app/Contents/MacOS/Godot"
GODOT_BIN="${GODOT_BIN:-$DEFAULT_GODOT_BIN}"

if [[ ! -x "$GODOT_BIN" ]]; then
    echo "Godot binary not found or not executable: $GODOT_BIN" >&2
    exit 1
fi

"$STEAM_DIR/tests/launch_surfaces/test_launch_scripts.sh"

test_log="$(mktemp -t shelter-player-boot-test.XXXXXX.log)"
run_id="r48-launch-$$"
test_base="user://player-tests/$run_id"
trap 'rm -f "$test_log"' EXIT

"$GODOT_BIN" --headless --path "$STEAM_DIR" --scene res://tests/launch_surfaces/player_boot_test_runner.tscn -- \
    --launch-test-base="$test_base" \
    --runtime-load-fixture=second_day_after_first_delivery \
    --runtime-load-save \
    --state-connector-control \
    --state-connector-token=must-not-be-read \
    --vertical-qa \
    --vertical-fast \
    --vertical-auto-play \
    --vertical-capture >"$test_log" 2>&1

if ! rg -q '^launch_surfaces_test=passed$' "$test_log"; then
    cat "$test_log" >&2
    exit 1
fi
if rg -n 'SCRIPT ERROR|Parse Error|ERROR:' "$test_log" >/dev/null; then
    cat "$test_log" >&2
    exit 1
fi

global_test_root="$HOME/Library/Application Support/Godot/app_userdata/Shelter/player-tests/$run_id"
if [[ -e "$global_test_root" ]]; then
    echo "Launch-surface test did not remove its exact isolated root: $global_test_root" >&2
    exit 1
fi

echo "launch surface Godot tests passed"
