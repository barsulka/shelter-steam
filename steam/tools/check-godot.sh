#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEFAULT_GODOT_BIN="$HOME/Library/Application Support/Steam/steamapps/common/Godot Engine/Godot.app/Contents/MacOS/Godot"
GODOT_BIN="${GODOT_BIN:-$DEFAULT_GODOT_BIN}"

if [[ ! -x "$GODOT_BIN" ]]; then
    echo "Godot binary not found or not executable: $GODOT_BIN" >&2
    echo "Set GODOT_BIN to a Godot 4.x editor binary." >&2
    exit 1
fi

"$GODOT_BIN" --version
"$GODOT_BIN" --headless --path "$ROOT_DIR" --import
"$GODOT_BIN" --headless --path "$ROOT_DIR" --quit-after 2
"$GODOT_BIN" --headless --path "$ROOT_DIR" --check-only --script res://scripts/main.gd
"$GODOT_BIN" --headless --path "$ROOT_DIR" --check-only --script res://scripts/launcher.gd
"$GODOT_BIN" --headless --path "$ROOT_DIR" --check-only --script res://scripts/dev_tools/godot_state_connector.gd
"$GODOT_BIN" --headless --path "$ROOT_DIR" --check-only --script res://scripts/spikes/desktop_window_probe.gd
"$GODOT_BIN" --headless --path "$ROOT_DIR" --check-only --script res://scripts/tech_demos/companion_field_demo.gd
"$GODOT_BIN" --headless --path "$ROOT_DIR" --check-only --script res://scripts/tech_demos/dog_rig_spike.gd
"$GODOT_BIN" --headless --path "$ROOT_DIR" --check-only --script res://scripts/prototypes/vertical_slice/vertical_slice_demo.gd
"$GODOT_BIN" --headless --path "$ROOT_DIR" --scene res://scenes/launcher.tscn -- --launcher-auto-quit
"$GODOT_BIN" --headless --path "$ROOT_DIR" --scene res://scenes/spikes/desktop_window_probe.tscn -- --spike-auto-quit
"$GODOT_BIN" --headless --path "$ROOT_DIR" --scene res://scenes/tech_demos/companion_field_demo.tscn -- --demo-auto-quit
"$GODOT_BIN" --headless --path "$ROOT_DIR" --scene res://scenes/tech_demos/companion_field_demo.tscn -- --demo-auto-quit --demo-seconds=1.2 --demo-companion --demo-dog-runtime --demo-perf
"$GODOT_BIN" --headless --path "$ROOT_DIR" --scene res://scenes/tech_demos/dog_rig_spike.tscn -- --dog-rig-auto-quit
"$GODOT_BIN" --headless --path "$ROOT_DIR" --scene res://scenes/tech_demos/dog_rig_spike.tscn -- --dog-rig-stress --dog-rig-auto-quit
"$GODOT_BIN" --headless --path "$ROOT_DIR" --scene res://scenes/tech_demos/dog_rig_spike.tscn -- --dog-rig-pipeline --dog-rig-auto-quit
"$GODOT_BIN" --headless --path "$ROOT_DIR" --scene res://scenes/tech_demos/dog_rig_spike.tscn -- --dog-rig-hybrid --dog-rig-auto-quit
"$GODOT_BIN" --headless --path "$ROOT_DIR" --scene res://scenes/tech_demos/dog_rig_spike.tscn -- --dog-rig-hybrid-companion --dog-rig-auto-quit
"$GODOT_BIN" --headless --path "$ROOT_DIR" --scene res://scenes/prototypes/vertical_slice/vertical_slice_demo.tscn -- --vertical-auto-play --vertical-fast --vertical-auto-quit --vertical-seconds=10
