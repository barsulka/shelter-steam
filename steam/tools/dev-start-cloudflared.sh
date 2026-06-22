#!/usr/bin/env bash
set -euo pipefail

# Compatibility dev helper.
#
# The official human-facing flow is:
#   ./launch.sh              # start Godot + local connector/control server
#   ./launch.sh --url        # print local URLs for the already running game
#   ./launch.sh --cloudflared --start
#   ./launch.sh --cloudflared
#
# This helper exists only for people who still look in tools/. It never starts
# Godot; it only starts cloudflared for an already running launch.sh process.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
    exec "$ROOT_DIR/launch.sh" --help
fi

exec "$ROOT_DIR/launch.sh" --cloudflared --start "$@"
