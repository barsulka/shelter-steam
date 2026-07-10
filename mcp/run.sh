#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

if [[ ! -f .env ]]; then
    echo "Missing .env. Copy .env.example to .env and fill CONTROL_PLANE_API_KEY." >&2
    exit 1
fi

set -a
source .env
set +a

TUNNEL_PROFILE="${TUNNEL_PROFILE:-shelter-test}"
TUNNEL_HEALTH_LISTEN_ADDR="${TUNNEL_HEALTH_LISTEN_ADDR:-127.0.0.1:8080}"
TUNNEL_CLIENT="${TUNNEL_CLIENT:-$ROOT_DIR/tunnel-client}"
if [[ ! -x "$TUNNEL_CLIENT" ]]; then
    TUNNEL_CLIENT="$(command -v tunnel-client || true)"
fi
if [[ -z "$TUNNEL_CLIENT" || ! -x "$TUNNEL_CLIENT" ]]; then
    echo "Could not find executable tunnel-client. Put it at ./tunnel-client or in PATH." >&2
    exit 1
fi

if [[ -z "${CONTROL_PLANE_API_KEY:-}" ]]; then
    echo "CONTROL_PLANE_API_KEY is required. See .env.example." >&2
    exit 1
fi
if [[ "${CONTROL_PLANE_API_KEY:-}" == "sk-..." ]]; then
    echo "CONTROL_PLANE_API_KEY still contains the .env.example placeholder." >&2
    exit 1
fi
if [[ "${CONTROL_PLANE_TUNNEL_ID:-}" == "tunnel_..." ]]; then
    echo "CONTROL_PLANE_TUNNEL_ID still contains the .env.example placeholder." >&2
    exit 1
fi
if [[ -z "${CONTROL_PLANE_TUNNEL_ID:-}" ]]; then
    cat >&2 <<'EOF'
CONTROL_PLANE_TUNNEL_ID is required.

Create or inspect a tunnel at:
  https://platform.openai.com/settings/organization/tunnels

Then put the tunnel id into .env.
EOF
    exit 1
fi
export CONTROL_PLANE_TUNNEL_ID

if [[ -z "${SHELTER_STEAM_ROOT:-}" ]]; then
    echo "SHELTER_STEAM_ROOT is required. See .env.example." >&2
    exit 1
fi
if [[ "${SHELTER_STEAM_ROOT:-}" == "/absolute/path/to/shelter/shelter/steam" ]]; then
    echo "SHELTER_STEAM_ROOT still contains the .env.example placeholder." >&2
    exit 1
fi
if [[ ! -x "$SHELTER_STEAM_ROOT/tools/dev-vertical-slice.sh" || ! -x "$SHELTER_STEAM_ROOT/launch.sh" ]]; then
    echo "SHELTER_STEAM_ROOT must point to the Shelter steam project with launch.sh and tools/dev-vertical-slice.sh." >&2
    exit 1
fi

install_filesystem_mcp_if_needed() {
    if [[ "${SHELTER_MCP_FILESYSTEM:-}" =~ ^(0|false|off|no|disabled)$ ]]; then
        return
    fi

    filesystem_cmd="${SHELTER_MCP_FILESYSTEM_COMMAND:-$(command -v mcp-server-filesystem || true)}"
    if [[ -z "$filesystem_cmd" ]]; then
        if ! command -v npm >/dev/null 2>&1; then
            echo "mcp-server-filesystem is missing and npm is not installed." >&2
            exit 1
        fi
        npm install -g @modelcontextprotocol/server-filesystem
        filesystem_cmd="$(command -v mcp-server-filesystem || true)"
    fi
    if [[ -z "$filesystem_cmd" || ! -x "$filesystem_cmd" ]]; then
        echo "mcp-server-filesystem is missing after install. Check npm global bin PATH or set SHELTER_MCP_FILESYSTEM_COMMAND." >&2
        exit 1
    fi

    if [[ -z "${SHELTER_MCP_FILESYSTEM_ROOTS:-}" ]]; then
        echo "SHELTER_MCP_FILESYSTEM_ROOTS is required for filesystem proxy. Set SHELTER_MCP_FILESYSTEM=0 to disable fs_* tools." >&2
        exit 1
    fi
    if [[ "${SHELTER_MCP_FILESYSTEM_ROOTS:-}" == "/absolute/path/to/shelter" ]]; then
        echo "SHELTER_MCP_FILESYSTEM_ROOTS still contains the .env.example placeholder." >&2
        exit 1
    fi

    IFS=',' read -r -a filesystem_roots <<< "$SHELTER_MCP_FILESYSTEM_ROOTS"
    first_root="${filesystem_roots[0]}"
    first_root="${first_root#"${first_root%%[![:space:]]*}"}"
    first_root="${first_root%"${first_root##*[![:space:]]}"}"
    if [[ -z "$first_root" || ! -d "$first_root" ]]; then
        echo "First SHELTER_MCP_FILESYSTEM_ROOTS entry must be an existing directory." >&2
        exit 1
    fi

    if ! "$filesystem_cmd" "$first_root" </dev/null >/dev/null; then
        echo "mcp-server-filesystem preflight failed." >&2
        exit 1
    fi
    export SHELTER_MCP_FILESYSTEM_COMMAND="$filesystem_cmd"
}

install_filesystem_mcp_if_needed

mkdir -p "$ROOT_DIR/.runtime/bin"
MCP_BIN="${SHELTER_MCP_BIN:-$ROOT_DIR/.runtime/bin/shelter-mcp}"
go build -o "$MCP_BIN" ./cmd/shelter-mcp

"$TUNNEL_CLIENT" init \
    --sample sample_mcp_stdio_local \
    --profile "$TUNNEL_PROFILE" \
    --tunnel-id "$CONTROL_PLANE_TUNNEL_ID" \
    --mcp-command "$MCP_BIN" \
    --health-listen-addr "$TUNNEL_HEALTH_LISTEN_ADDR" \
    --open-web-ui \
    --force

"$TUNNEL_CLIENT" doctor --profile "$TUNNEL_PROFILE" --explain
"$TUNNEL_CLIENT" run --profile "$TUNNEL_PROFILE"
