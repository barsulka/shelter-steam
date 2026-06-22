#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEFAULT_GODOT_BIN="$HOME/Library/Application Support/Steam/steamapps/common/Godot Engine/Godot.app/Contents/MacOS/Godot"
GODOT_BIN="${GODOT_BIN:-$DEFAULT_GODOT_BIN}"
MODE="${1:-interactive}"

if [[ ! -x "$GODOT_BIN" ]]; then
    echo "Godot binary not found or not executable: $GODOT_BIN" >&2
    echo "Set GODOT_BIN to a Godot 4.x editor binary." >&2
    exit 1
fi

case "$MODE" in
    all|interactive)
        exec "$GODOT_BIN" --path "$ROOT_DIR" --scene res://scenes/tech_demos/dog_rig_spike.tscn
        ;;
    smoke)
        exec "$GODOT_BIN" --headless --path "$ROOT_DIR" --scene res://scenes/tech_demos/dog_rig_spike.tscn -- --dog-rig-auto-quit
        ;;
    stress)
        exec "$GODOT_BIN" --print-fps --path "$ROOT_DIR" --scene res://scenes/tech_demos/dog_rig_spike.tscn -- --dog-rig-stress --dog-rig-print-perf
        ;;
    stress-smoke)
        exec "$GODOT_BIN" --headless --path "$ROOT_DIR" --scene res://scenes/tech_demos/dog_rig_spike.tscn -- --dog-rig-stress --dog-rig-auto-quit
        ;;
    pipeline)
        exec "$GODOT_BIN" --print-fps --path "$ROOT_DIR" --scene res://scenes/tech_demos/dog_rig_spike.tscn -- --dog-rig-pipeline --dog-rig-print-perf
        ;;
    pipeline-smoke)
        exec "$GODOT_BIN" --headless --path "$ROOT_DIR" --scene res://scenes/tech_demos/dog_rig_spike.tscn -- --dog-rig-pipeline --dog-rig-auto-quit
        ;;
    hybrid)
        exec "$GODOT_BIN" --print-fps --path "$ROOT_DIR" --scene res://scenes/tech_demos/dog_rig_spike.tscn -- --dog-rig-hybrid --dog-rig-print-perf
        ;;
    hybrid-smoke)
        exec "$GODOT_BIN" --headless --path "$ROOT_DIR" --scene res://scenes/tech_demos/dog_rig_spike.tscn -- --dog-rig-hybrid --dog-rig-auto-quit
        ;;
    hybrid-companion-perf)
        exec "$GODOT_BIN" --print-fps --path "$ROOT_DIR" --scene res://scenes/tech_demos/dog_rig_spike.tscn -- --dog-rig-hybrid-companion --dog-rig-print-perf
        ;;
    hybrid-companion-smoke)
        exec "$GODOT_BIN" --headless --path "$ROOT_DIR" --scene res://scenes/tech_demos/dog_rig_spike.tscn -- --dog-rig-hybrid-companion --dog-rig-auto-quit
        ;;
    bublik)
        exec "$GODOT_BIN" --path "$ROOT_DIR" --scene res://scenes/tech_demos/dog_rig_spike.tscn -- --dog-id=DOG-PROT-001
        ;;
    knopka)
        exec "$GODOT_BIN" --path "$ROOT_DIR" --scene res://scenes/tech_demos/dog_rig_spike.tscn -- --dog-id=DOG-PROT-002
        ;;
    mishka)
        exec "$GODOT_BIN" --path "$ROOT_DIR" --scene res://scenes/tech_demos/dog_rig_spike.tscn -- --dog-id=DOG-PROT-003
        ;;
    *)
        echo "Usage: tools/dev-dog-rig.sh [interactive|smoke|stress|stress-smoke|pipeline|pipeline-smoke|hybrid|hybrid-smoke|hybrid-companion-perf|hybrid-companion-smoke|bublik|knopka|mishka]" >&2
        exit 2
        ;;
esac
