#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEFAULT_GODOT_BIN="$HOME/Library/Application Support/Steam/steamapps/common/Godot Engine/Godot.app/Contents/MacOS/Godot"
GODOT_BIN="${GODOT_BIN:-$DEFAULT_GODOT_BIN}"
MODE="${1:-all}"

if [[ ! -x "$GODOT_BIN" ]]; then
    echo "Godot binary not found or not executable: $GODOT_BIN" >&2
    echo "Set GODOT_BIN to a Godot 4.x editor binary." >&2
    exit 1
fi

case "$MODE" in
    all|interactive)
        exec "$GODOT_BIN" --path "$ROOT_DIR" --scene res://scenes/tech_demos/companion_field_demo.tscn -- --demo-companion --demo-transparent --demo-open-settings
        ;;
    smoke)
        exec "$GODOT_BIN" --headless --path "$ROOT_DIR" --scene res://scenes/tech_demos/companion_field_demo.tscn -- --demo-auto-quit
        ;;
    normal)
        exec "$GODOT_BIN" --path "$ROOT_DIR" --scene res://scenes/tech_demos/companion_field_demo.tscn -- --demo-normal --demo-no-transparent --demo-no-always-on-top
        ;;
    companion)
        exec "$GODOT_BIN" --path "$ROOT_DIR" --scene res://scenes/tech_demos/companion_field_demo.tscn -- --demo-companion --demo-transparent
        ;;
    click-through)
        exec "$GODOT_BIN" --path "$ROOT_DIR" --scene res://scenes/tech_demos/companion_field_demo.tscn -- --demo-companion --demo-transparent --demo-click-through
        ;;
    perf)
        exec "$GODOT_BIN" --print-fps --path "$ROOT_DIR" --scene res://scenes/tech_demos/companion_field_demo.tscn -- --demo-companion --demo-transparent --demo-perf
        ;;
    *)
        echo "Usage: tools/run-companion-field-demo.sh [all|interactive|companion|normal|click-through|perf|smoke]" >&2
        exit 2
        ;;
esac
