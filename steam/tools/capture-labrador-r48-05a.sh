#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPO_DIR="$(cd "$ROOT_DIR/.." && pwd)"
DEFAULT_GODOT_BIN="$HOME/Library/Application Support/Steam/steamapps/common/Godot Engine/Godot.app/Contents/MacOS/Godot"
GODOT_BIN="${GODOT_BIN:-$DEFAULT_GODOT_BIN}"
IMMUTABLE_V1_DIR="$REPO_DIR/docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_R48_05A_LABRADOR_RUNTIME_CAPTURE_v1"
IMMUTABLE_V2_DIR="$REPO_DIR/docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_R48_05A_LABRADOR_RUNTIME_CAPTURE_v2"
IMMUTABLE_V3_DIR="$REPO_DIR/docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_R48_05A_LABRADOR_RUNTIME_CAPTURE_v3"
IMMUTABLE_V4_DIR="$REPO_DIR/docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_R48_05A_LABRADOR_RUNTIME_CAPTURE_v4"
OUTPUT_DIR="${R48_05A_CAPTURE_DIR:-$REPO_DIR/docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_R48_05A_LABRADOR_RUNTIME_CAPTURE_v5}"
MODE="${1:-capture}"

if [[ ! -x "$GODOT_BIN" ]]; then
    echo "Godot binary not found or not executable: $GODOT_BIN" >&2
    exit 1
fi

if [[ "$OUTPUT_DIR" == "$IMMUTABLE_V1_DIR" || "$OUTPUT_DIR" == "$IMMUTABLE_V2_DIR" || "$OUTPUT_DIR" == "$IMMUTABLE_V3_DIR" || "$OUTPUT_DIR" == "$IMMUTABLE_V4_DIR" ]]; then
    echo "R48-05A v1/v2/v3/v4 capture packs are immutable; use the v5 output path" >&2
    exit 3
fi

verify_immutable_history() {
    local immutable_dir
    for immutable_dir in "$IMMUTABLE_V1_DIR" "$IMMUTABLE_V2_DIR" "$IMMUTABLE_V3_DIR" "$IMMUTABLE_V4_DIR"; do
        (
            cd "$immutable_dir"
            shasum -a 256 -c HASHES.sha256 >/dev/null
        )
    done
}

run_visual_tests() {
    "$GODOT_BIN" --headless --path "$ROOT_DIR" \
        --scene res://tests/vertical_slice_visual/labrador_visual_test_runner.tscn
}

run_validators() {
    python3 "$ROOT_DIR/tools/validate-labrador-r48-05a.py"
    local manifest_validator="$HOME/.codex/skills/shelter-dog-animation-pipeline/scripts/validate_dog_animation_manifest.py"
    local runtime_validator="$HOME/.codex/skills/shelter-dog-animation-pipeline/scripts/validate_dog_runtime_binding.py"
    if [[ -f "$manifest_validator" && -f "$runtime_validator" ]]; then
        python3 "$manifest_validator" --manifest "$ROOT_DIR/resources/prototypes/vertical_slice/labrador_r48_05a_binding_v1.json"
        python3 "$runtime_validator" --manifest "$ROOT_DIR/resources/prototypes/vertical_slice/labrador_r48_05a_binding_v1.json"
    fi
}

case "$MODE" in
    validate)
        verify_immutable_history
        run_visual_tests
        run_validators
        ;;
    capture)
        verify_immutable_history
        mkdir -p "$OUTPUT_DIR"
        run_visual_tests
        git_commit="$(git -C "$REPO_DIR" rev-parse HEAD)"
        "$GODOT_BIN" --path "$ROOT_DIR" \
            --scene res://tests/vertical_slice_visual/labrador_visual_test_runner.tscn -- \
            --r48-05a-capture-dir="$OUTPUT_DIR" \
            --r48-05a-git-commit="$git_commit"
        run_validators
        (
            cd "$OUTPUT_DIR"
            find . -type f ! -name HASHES.sha256 -print0 | sort -z | xargs -0 shasum -a 256
        ) >"$OUTPUT_DIR/HASHES.sha256"
        echo "labrador_r48_05a_capture_pack=$OUTPUT_DIR"
        ;;
    *)
        echo "Usage: tools/capture-labrador-r48-05a.sh [capture|validate]" >&2
        exit 2
        ;;
esac
