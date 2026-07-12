#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEV_VERTICAL_SLICE="${SHELTER_DEV_VERTICAL_SLICE:-$ROOT_DIR/tools/dev-vertical-slice.sh}"
LEGACY_LAUNCH="${SHELTER_LEGACY_LAUNCH:-$ROOT_DIR/launch.sh}"
MODE="${1:-player}"
if (( $# > 0 )); then
    shift
fi

usage() {
    cat <<'EOF'
Usage: ./dev.sh [mode] [mode arguments]

Core modes:
  player       existing player-prototype dev scene (default)
  qa           QA/interactive Vertical Slice
  day2         Day 2 fixture in player-prototype presentation
  connector    legacy connector/control launcher
  capture      existing Workbench capture harness
  smoke        existing Vertical Slice smoke

Specialized pass-through modes:
  interactive, perf, normal, autoplay, connector-smoke,
  connector-control-smoke, runtime-foundation-smoke,
  first-day-visible-capture, first-day-art-ux-capture,
  day-2-visible-capture, capture-smoke

Legacy connector/tunnel lifecycle:
  ./dev.sh connector --barsulka --start
  ./dev.sh connector --url
  ./dev.sh connector --exit

Use ./play.sh for the ordinary game. Developer flags belong here only.
EOF
}

case "$MODE" in
    player)
        exec "$DEV_VERTICAL_SLICE" player-prototype "$@"
        ;;
    qa)
        exec "$DEV_VERTICAL_SLICE" qa "$@"
        ;;
    day2)
        exec "$DEV_VERTICAL_SLICE" player-prototype --runtime-load-fixture=second_day_after_first_delivery "$@"
        ;;
    connector)
        exec "$LEGACY_LAUNCH" "$@"
        ;;
    capture)
        exec "$DEV_VERTICAL_SLICE" workbench-capture "$@"
        ;;
    smoke)
        exec "$DEV_VERTICAL_SLICE" smoke "$@"
        ;;
    interactive|perf|normal|autoplay|connector-smoke|connector-control-smoke|runtime-foundation-smoke|first-day-visible-capture|first-day-art-ux-capture|day-2-visible-capture|capture-smoke)
        exec "$DEV_VERTICAL_SLICE" "$MODE" "$@"
        ;;
    help|-h|--help)
        usage
        ;;
    *)
        echo "Unknown dev mode: $MODE" >&2
        usage >&2
        exit 2
        ;;
esac
