#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEFAULT_GODOT_BIN="$HOME/Library/Application Support/Steam/steamapps/common/Godot Engine/Godot.app/Contents/MacOS/Godot"
GODOT_BIN="${GODOT_BIN:-$DEFAULT_GODOT_BIN}"
MODE="${1:-visible}"

if [[ ! -x "$GODOT_BIN" ]]; then
    echo "Godot binary not found or not executable: $GODOT_BIN" >&2
    echo "Set GODOT_BIN to a Godot 4.x editor binary." >&2
    exit 1
fi

case "$MODE" in
    smoke)
        exec "$GODOT_BIN" --headless --path "$ROOT_DIR" --scene res://scenes/spikes/desktop_window_probe.tscn -- --spike-auto-quit
        ;;
    companion)
        exec "$GODOT_BIN" --path "$ROOT_DIR" --scene res://scenes/spikes/desktop_window_probe.tscn -- --spike-companion --spike-borderless --spike-interactive-polygon
        ;;
    visible)
        exec "$GODOT_BIN" --path "$ROOT_DIR" --scene res://scenes/spikes/desktop_window_probe.tscn
        ;;
    *)
        echo "Usage: tools/dev-window-spike.sh [visible|companion|smoke]" >&2
        exit 2
        ;;
esac
