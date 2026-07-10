#!/bin/sh
set -eu

MCP_ROOT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
REPO_ROOT=$(CDPATH= cd -- "$MCP_ROOT/.." && pwd)
MCP_BIN=${SHELTER_MCP_BIN:-"$MCP_ROOT/.runtime/bin/shelter-mcp"}

mkdir -p "$(dirname -- "$MCP_BIN")"

cd "$MCP_ROOT"
go build -o "$MCP_BIN" ./cmd/shelter-mcp

export SHELTER_MCP_REPO_ROOT=${SHELTER_MCP_REPO_ROOT:-"$REPO_ROOT"}

# STDIO is the default transport. Pass --http 127.0.0.1:8090 only for explicit
# local debugging; this launcher never starts a tunnel or installs packages.
exec "$MCP_BIN" "$@"
