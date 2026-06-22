#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_GODOT_BIN="$HOME/Library/Application Support/Steam/steamapps/common/Godot Engine/Godot.app/Contents/MacOS/Godot"
GODOT_BIN="${GODOT_BIN:-$DEFAULT_GODOT_BIN}"
DEV_VERTICAL_SLICE="$ROOT_DIR/tools/dev-vertical-slice.sh"

CONNECTOR_PORT="${STATE_CONNECTOR_PORT:-8765}"
CONNECTOR_INTERVAL="${STATE_CONNECTOR_INTERVAL:-5}"
LOCAL_BASE_URL="http://127.0.0.1:$CONNECTOR_PORT"

CLOUDFLARED_BIN="${CLOUDFLARED_BIN:-cloudflared}"
PUBLIC_HEALTH_TIMEOUT_SECONDS="${PUBLIC_HEALTH_TIMEOUT:-${TUNNEL_PUBLIC_HEALTH_TIMEOUT:-300}}"

BARSULKA_HOST="${BARSULKA_TUNNEL_HOST:-barsulka.eboshim.site}"
BARSULKA_SSH_TARGET="${BARSULKA_TUNNEL_SSH_TARGET:-root@$BARSULKA_HOST}"
BARSULKA_REMOTE_BIND_HOST="${BARSULKA_TUNNEL_BIND_HOST:-0.0.0.0}"
BARSULKA_REMOTE_PORT="${BARSULKA_TUNNEL_PORT:-28765}"
BARSULKA_BASE_URL="${BARSULKA_TUNNEL_URL:-http://$BARSULKA_HOST:$BARSULKA_REMOTE_PORT}"

RUNTIME_DIR="$ROOT_DIR/.runtime/godot_state_connector"
TOKEN_FILE="$RUNTIME_DIR/launch_token"
PID_FILE="$RUNTIME_DIR/launch_godot.pid"
GAME_LOG="$RUNTIME_DIR/launch_godot.log"
CLOUDFLARED_URL_FILE="$RUNTIME_DIR/launch_cloudflared_url"
CLOUDFLARED_PID_FILE="$RUNTIME_DIR/launch_cloudflared.pid"
BARSULKA_URL_FILE="$RUNTIME_DIR/launch_barsulka_url"
BARSULKA_PID_FILE="$RUNTIME_DIR/launch_barsulka.pid"
BARSULKA_LOG="$RUNTIME_DIR/launch_barsulka.log"

mode="start"
provider=""
action=""
want_launcher="false"
passthrough_args=()
game_pid=""
cloudflared_pid=""
cloudflared_log=""
barsulka_pid=""
started_game="false"
started_cloudflared="false"
started_barsulka="false"
preserve_game_on_exit="false"
public_url=""

usage() {
    cat <<EOF
Usage:
  ./launch.sh                         start or attach to the playable Vertical Slice with local HTTP control
  ./launch.sh --url                   print local URLs for an already running game; starts nothing
  ./launch.sh --exit                  stop tunnels, local HTTP connector, and the Godot game
  ./launch.sh --shutdown              alias for --exit

  ./launch.sh --cloudflared           print the already running Cloudflare URL; starts nothing
  ./launch.sh --cloudflared --start   start or reuse the local game, then start cloudflared
  ./launch.sh --cloudflared --stop    stop a cloudflared process started by this launcher

  ./launch.sh --barsulka              print the already running barsulka.eboshim.site URL; starts nothing
  ./launch.sh --barsulka --start      start or reuse the local game, then start the SSH reverse tunnel
  ./launch.sh --barsulka --stop       stop Barsulka tunnel and local HTTP connector; keeps Godot running

  ./launch.sh --launcher              open the legacy visual launcher without the connector
  ./launch.sh -- --runtime-load-save  start the connector game from the dev local runtime save

Behavior:
  - The normal game launch always uses the local Godot connector/control server.
  - --url, --cloudflared, and --barsulka without --start are lookup-only commands.
  - --barsulka --start starts the local game first when no local connector is running.
  - --cloudflared --start starts the local game first when no local connector is running.
  - --exit and --shutdown are soft full shutdowns: tunnels first, then local connector, then Godot.
  - --barsulka --stop intentionally stops the local HTTP connector but leaves the Godot game process alive.
  - The dev token is written only to:
      $TOKEN_FILE
  - Runtime tunnel metadata is written only under:
      $RUNTIME_DIR
  - Keep the terminal open for any process this script starts.

Environment:
  STATE_CONNECTOR_PORT=8765
  STATE_CONNECTOR_INTERVAL=5
  STATE_CONNECTOR_TOKEN=...               optional; generated when absent
  CLOUDFLARED_BIN=cloudflared
  PUBLIC_HEALTH_TIMEOUT=300
  TUNNEL_SKIP_PUBLIC_CHECK=1              skip public /health wait for cloudflared
  BARSULKA_TUNNEL_HOST=barsulka.eboshim.site
  BARSULKA_TUNNEL_SSH_TARGET=root@barsulka.eboshim.site
  BARSULKA_TUNNEL_BIND_HOST=0.0.0.0
  BARSULKA_TUNNEL_PORT=28765

Examples:
  ./launch.sh
  ./launch.sh --url
  ./launch.sh --exit
  ./launch.sh --shutdown
  ./launch.sh -- --runtime-load-fixture=warm_food_delivery_mid_chain
  ./launch.sh -- --runtime-load-save
  ./launch.sh --barsulka --start
  ./launch.sh --barsulka
  ./launch.sh --barsulka --stop
  ./launch.sh --cloudflared --start
  ./launch.sh --cloudflared
EOF
}

make_token() {
    if [[ -n "${STATE_CONNECTOR_TOKEN:-}" ]]; then
        printf '%s\n' "$STATE_CONNECTOR_TOKEN"
        return
    fi

    if command -v uuidgen >/dev/null 2>&1; then
        uuidgen
        return
    fi

    if command -v openssl >/dev/null 2>&1; then
        openssl rand -hex 24
        return
    fi

    date "+%Y%m%d%H%M%S$RANDOM"
}

read_saved_token() {
    if [[ ! -s "$TOKEN_FILE" ]]; then
        return 1
    fi

    tr -d '\r\n' < "$TOKEN_FILE"
}

write_saved_token() {
    mkdir -p "$RUNTIME_DIR"
    umask 077
    printf '%s\n' "$STATE_CONNECTOR_TOKEN" > "$TOKEN_FILE"
}

pid_file_is_alive() {
    local pid_file="$1"
    local pid

    if [[ ! -s "$pid_file" ]]; then
        return 1
    fi

    pid="$(tr -d '[:space:]' < "$pid_file")"
    [[ -n "$pid" ]] && kill -0 "$pid" 2>/dev/null
}

kill_pid_file_process() {
    local pid_file="$1"
    local label="$2"
    local pid

    if [[ ! -s "$pid_file" ]]; then
        return 1
    fi

    pid="$(tr -d '[:space:]' < "$pid_file")"
    if [[ -z "$pid" ]] || ! kill -0 "$pid" 2>/dev/null; then
        rm -f "$pid_file"
        return 1
    fi

    echo "Stopping $label pid $pid..."
    kill "$pid" 2>/dev/null || true
    wait "$pid" 2>/dev/null || true
    rm -f "$pid_file"
    return 0
}

local_health_is_up() {
    local body
    body="$(curl -fsS --max-time 2 "$LOCAL_BASE_URL/health" 2>/dev/null || true)"
    [[ "$body" == *'"schema_version": "shelter.godot_state_connector.v0.2"'* ]]
}

control_page_is_reachable() {
    local token="$1"
    [[ -n "$token" ]] && curl -fsS --max-time 2 "$LOCAL_BASE_URL/control?token=$token" >/dev/null 2>&1
}

resolve_existing_token() {
    local candidate

    candidate="$(read_saved_token 2>/dev/null || true)"
    if control_page_is_reachable "$candidate"; then
        printf '%s\n' "$candidate"
        return 0
    fi

    candidate="${STATE_CONNECTOR_TOKEN:-}"
    if control_page_is_reachable "$candidate"; then
        printf '%s\n' "$candidate"
        return 0
    fi

    return 1
}

resolve_cloudflared() {
    local resolved

    resolved="$(command -v "$CLOUDFLARED_BIN" 2>/dev/null || true)"
    if [[ -n "$resolved" ]]; then
        CLOUDFLARED_BIN="$resolved"
        return 0
    fi

    for candidate in /opt/homebrew/bin/cloudflared /usr/local/bin/cloudflared; do
        if [[ -x "$candidate" ]]; then
            CLOUDFLARED_BIN="$candidate"
            return 0
        fi
    done

    return 1
}

public_health_check() {
    local url="$1"
    local host
    local ip

    if curl -fsS --max-time 8 "$url/health" >/dev/null 2>&1; then
        return 0
    fi

    if [[ "$url" != https://* ]]; then
        return 1
    fi

    host="${url#https://}"
    host="${host%%/*}"
    ip="$(nslookup "$host" 1.1.1.1 2>/dev/null | awk '/^Address: / && $2 !~ /#/ { print $2; exit }')"
    if [[ -z "$ip" ]]; then
        return 1
    fi

    curl -fsS --max-time 8 --resolve "$host:443:$ip" "$url/health" >/dev/null 2>&1
}

barsulka_health_is_up() {
    curl -fsS --max-time 5 "$BARSULKA_BASE_URL/health" >/dev/null 2>&1
}

cleanup() {
    if [[ "$started_cloudflared" == "true" ]] && [[ -n "$cloudflared_pid" ]] && kill -0 "$cloudflared_pid" 2>/dev/null; then
        kill "$cloudflared_pid" 2>/dev/null || true
        wait "$cloudflared_pid" 2>/dev/null || true
    fi

    if [[ "$started_barsulka" == "true" ]] && [[ -n "$barsulka_pid" ]] && kill -0 "$barsulka_pid" 2>/dev/null; then
        kill "$barsulka_pid" 2>/dev/null || true
        wait "$barsulka_pid" 2>/dev/null || true
    fi

    if [[ "$started_game" == "true" ]] && [[ "$preserve_game_on_exit" != "true" ]] && [[ -n "$game_pid" ]] && kill -0 "$game_pid" 2>/dev/null; then
        kill "$game_pid" 2>/dev/null || true
        wait "$game_pid" 2>/dev/null || true
    fi

    if [[ "$started_game" == "true" ]]; then
        rm -f "$TOKEN_FILE" "$PID_FILE"
    fi

    if [[ "$started_cloudflared" == "true" ]]; then
        rm -f "$CLOUDFLARED_URL_FILE" "$CLOUDFLARED_PID_FILE"
    fi

    if [[ "$started_barsulka" == "true" ]]; then
        rm -f "$BARSULKA_URL_FILE" "$BARSULKA_PID_FILE"
    fi

    if [[ -n "$cloudflared_log" ]]; then
        rm -f "$cloudflared_log"
    fi
}

terminate() {
    preserve_game_on_exit="false"
    exit 130
}

wait_for_local_health() {
    echo "Waiting for local connector: $LOCAL_BASE_URL/health"
    for _ in $(seq 1 160); do
        if local_health_is_up; then
            return 0
        fi

        if [[ "$started_game" == "true" ]] && ! kill -0 "$game_pid" 2>/dev/null; then
            echo "Godot exited before the connector became healthy." >&2
            sed -n '1,220p' "$GAME_LOG" >&2 || true
            return 1
        fi

        sleep 0.25
    done

    echo "Connector did not answer at $LOCAL_BASE_URL/health." >&2
    if [[ -s "$GAME_LOG" ]]; then
        sed -n '1,220p' "$GAME_LOG" >&2 || true
    fi
    return 1
}

start_game() {
    if [[ ! -x "$GODOT_BIN" ]]; then
        echo "Godot binary not found or not executable: $GODOT_BIN" >&2
        echo "Set GODOT_BIN to a Godot 4.x editor binary." >&2
        exit 1
    fi

    if [[ ! -x "$DEV_VERTICAL_SLICE" ]]; then
        echo "Vertical Slice dev helper is not executable: $DEV_VERTICAL_SLICE" >&2
        exit 1
    fi

    mkdir -p "$RUNTIME_DIR"
    STATE_CONNECTOR_TOKEN="$(make_token)"
    export STATE_CONNECTOR_TOKEN
    export STATE_CONNECTOR_PORT="$CONNECTOR_PORT"
    export STATE_CONNECTOR_INTERVAL="$CONNECTOR_INTERVAL"
    write_saved_token

    : > "$GAME_LOG"
    echo "Starting Shelter Vertical Slice with local connector/control..."
    echo "Godot log: $GAME_LOG"
    game_args=(connector-control)
    if (( ${#passthrough_args[@]} > 0 )); then
        game_args+=("${passthrough_args[@]}")
    fi
    "$DEV_VERTICAL_SLICE" "${game_args[@]}" >"$GAME_LOG" 2>&1 &
    game_pid="$!"
    started_game="true"
    printf '%s\n' "$game_pid" > "$PID_FILE"

    wait_for_local_health
    if ! control_page_is_reachable "$STATE_CONNECTOR_TOKEN"; then
        echo "Connector is healthy, but the control page is not reachable with the launch token." >&2
        sed -n '1,220p' "$GAME_LOG" >&2 || true
        exit 1
    fi
}

ensure_game() {
    if local_health_is_up; then
        if ! STATE_CONNECTOR_TOKEN="$(resolve_existing_token)"; then
            echo "A Shelter connector is already running on $LOCAL_BASE_URL, but this launcher cannot access its control token." >&2
            echo "Stop that process, or provide its token with STATE_CONNECTOR_TOKEN=..." >&2
            exit 1
        fi
        export STATE_CONNECTOR_TOKEN
        echo "Using existing Shelter game process at $LOCAL_BASE_URL"
        return
    fi

    start_game
}

require_existing_game() {
    if ! local_health_is_up; then
        echo "No running Shelter connector at $LOCAL_BASE_URL/health." >&2
        echo "Start the game first with: ./launch.sh" >&2
        exit 1
    fi

    if ! STATE_CONNECTOR_TOKEN="$(resolve_existing_token)"; then
        echo "A Shelter connector is running on $LOCAL_BASE_URL, but this launcher cannot access its control token." >&2
        echo "Stop that process, or provide its token with STATE_CONNECTOR_TOKEN=..." >&2
        exit 1
    fi
    export STATE_CONNECTOR_TOKEN
}

print_local_urls() {
    cat <<EOF

Local Shelter URLs:
  $LOCAL_BASE_URL/health
  $LOCAL_BASE_URL/schema?token=$STATE_CONNECTOR_TOKEN
  $LOCAL_BASE_URL/state?token=$STATE_CONNECTOR_TOKEN
  $LOCAL_BASE_URL/control?token=$STATE_CONNECTOR_TOKEN

EOF
}

print_public_urls() {
    local label="$1"
    local url="$2"

    cat <<EOF
$label Shelter URLs for ChatGPT:
  $url/health
  $url/schema?token=$STATE_CONNECTOR_TOKEN
  $url/state?token=$STATE_CONNECTOR_TOKEN
  $url/control?token=$STATE_CONNECTOR_TOKEN

Prompt for ChatGPT:
  Open Shelter Godot control page:
  $url/control?token=$STATE_CONNECTOR_TOKEN

EOF
}

print_existing_cloudflared_urls() {
    local saved_url

    if [[ ! -s "$CLOUDFLARED_URL_FILE" ]]; then
        echo "No saved live cloudflared URL found." >&2
        echo "Start cloudflared in another terminal with: ./launch.sh --cloudflared --start" >&2
        exit 1
    fi

    saved_url="$(tr -d '\r\n' < "$CLOUDFLARED_URL_FILE")"
    if [[ -z "$saved_url" ]]; then
        echo "Saved cloudflared URL file is empty: $CLOUDFLARED_URL_FILE" >&2
        exit 1
    fi

    if ! public_health_check "$saved_url"; then
        echo "Saved cloudflared URL is not healthy: $saved_url/health" >&2
        echo "Start a fresh tunnel with: ./launch.sh --cloudflared --start" >&2
        exit 1
    fi

    print_public_urls "Cloudflare" "$saved_url"
}

start_cloudflared() {
    if [[ -s "$CLOUDFLARED_URL_FILE" ]]; then
        public_url="$(tr -d '\r\n' < "$CLOUDFLARED_URL_FILE")"
        if [[ -n "$public_url" ]] && public_health_check "$public_url"; then
            echo "cloudflared is already running."
            print_public_urls "Cloudflare" "$public_url"
            return 0
        fi
    fi

    if ! resolve_cloudflared; then
        echo "cloudflared not found: $CLOUDFLARED_BIN" >&2
        echo "Install it with: brew install cloudflared" >&2
        exit 127
    fi

    cloudflared_log="$(mktemp -t shelter-launch-cloudflared.XXXXXX.log)"
    echo "Starting Cloudflare quick tunnel to the already running local connector..."
    "$CLOUDFLARED_BIN" tunnel --url "$LOCAL_BASE_URL" >"$cloudflared_log" 2>&1 &
    cloudflared_pid="$!"
    started_cloudflared="true"
    printf '%s\n' "$cloudflared_pid" > "$CLOUDFLARED_PID_FILE"

    for _ in $(seq 1 160); do
        public_url="$(grep -Eo 'https://[-a-zA-Z0-9.]+\.trycloudflare\.com' "$cloudflared_log" | head -n 1 || true)"
        if [[ -n "$public_url" ]]; then
            break
        fi

        if ! kill -0 "$cloudflared_pid" 2>/dev/null; then
            echo "cloudflared exited before publishing a URL." >&2
            sed -n '1,160p' "$cloudflared_log" >&2 || true
            exit 1
        fi

        sleep 0.25
    done

    if [[ -z "$public_url" ]]; then
        echo "Could not find a trycloudflare.com URL in cloudflared output." >&2
        sed -n '1,160p' "$cloudflared_log" >&2 || true
        exit 1
    fi

    if [[ "${TUNNEL_SKIP_PUBLIC_CHECK:-}" != "1" ]]; then
        echo "Waiting for public /health: $public_url/health"
        public_health_ready="false"
        public_health_started_at="$(date +%s)"

        while true; do
            if public_health_check "$public_url"; then
                public_health_ready="true"
                break
            fi

            if ! kill -0 "$cloudflared_pid" 2>/dev/null; then
                echo "cloudflared exited before public /health became available." >&2
                sed -n '1,160p' "$cloudflared_log" >&2 || true
                exit 1
            fi

            now="$(date +%s)"
            elapsed="$((now - public_health_started_at))"
            if [[ "$elapsed" -ge "$PUBLIC_HEALTH_TIMEOUT_SECONDS" ]]; then
                break
            fi

            sleep 2
        done

        if [[ "$public_health_ready" != "true" ]]; then
            echo "Public /health did not answer within ${PUBLIC_HEALTH_TIMEOUT_SECONDS}s: $public_url/health" >&2
            echo "Local connector is still available at: $LOCAL_BASE_URL/health" >&2
            echo "You can retry or use TUNNEL_SKIP_PUBLIC_CHECK=1." >&2
            exit 1
        fi
    fi

    mkdir -p "$RUNTIME_DIR"
    printf '%s\n' "$public_url" > "$CLOUDFLARED_URL_FILE"
    print_public_urls "Cloudflare" "$public_url"
}

stop_cloudflared() {
    if kill_pid_file_process "$CLOUDFLARED_PID_FILE" "cloudflared"; then
        rm -f "$CLOUDFLARED_URL_FILE"
        echo "cloudflared stopped."
        return
    fi

    rm -f "$CLOUDFLARED_URL_FILE"
    echo "No cloudflared process from this launcher is running."
}

stop_cloudflared_for_exit() {
    stop_cloudflared

    local pids
    pids="$(pgrep -f "cloudflared.*tunnel --url ${LOCAL_BASE_URL}" || true)"
    if [[ -n "$pids" ]]; then
        echo "$pids" | while read -r pid; do
            if [[ -n "$pid" ]] && kill -0 "$pid" 2>/dev/null; then
                echo "Stopping cloudflared pid $pid..."
                kill "$pid" 2>/dev/null || true
            fi
        done
    fi

    rm -f "$CLOUDFLARED_URL_FILE" "$CLOUDFLARED_PID_FILE"
}

print_existing_barsulka_urls() {
    local saved_url="$BARSULKA_BASE_URL"

    if [[ -s "$BARSULKA_URL_FILE" ]]; then
        saved_url="$(tr -d '\r\n' < "$BARSULKA_URL_FILE")"
    fi

    if ! barsulka_health_is_up; then
        echo "Barsulka tunnel is not healthy: $saved_url/health" >&2
        echo "Start it with: ./launch.sh --barsulka --start" >&2
        exit 1
    fi

    print_public_urls "Barsulka" "$saved_url"
}

start_barsulka() {
    if barsulka_health_is_up; then
        mkdir -p "$RUNTIME_DIR"
        printf '%s\n' "$BARSULKA_BASE_URL" > "$BARSULKA_URL_FILE"
        echo "Barsulka tunnel is already running."
        print_public_urls "Barsulka" "$BARSULKA_BASE_URL"
        return 0
    fi

    mkdir -p "$RUNTIME_DIR"
    : > "$BARSULKA_LOG"

    echo "Starting SSH reverse tunnel:"
    echo "  local:  $LOCAL_BASE_URL"
    echo "  public: $BARSULKA_BASE_URL"
    echo "  ssh:    $BARSULKA_SSH_TARGET"
    ssh -NT \
        -o BatchMode=yes \
        -o ExitOnForwardFailure=yes \
        -o ServerAliveInterval=30 \
        -o ServerAliveCountMax=3 \
        -R "$BARSULKA_REMOTE_BIND_HOST:$BARSULKA_REMOTE_PORT:127.0.0.1:$CONNECTOR_PORT" \
        "$BARSULKA_SSH_TARGET" >"$BARSULKA_LOG" 2>&1 &
    barsulka_pid="$!"
    started_barsulka="true"
    printf '%s\n' "$barsulka_pid" > "$BARSULKA_PID_FILE"
    printf '%s\n' "$BARSULKA_BASE_URL" > "$BARSULKA_URL_FILE"

    for _ in $(seq 1 120); do
        if barsulka_health_is_up; then
            print_public_urls "Barsulka" "$BARSULKA_BASE_URL"
            return 0
        fi

        if ! kill -0 "$barsulka_pid" 2>/dev/null; then
            echo "SSH reverse tunnel exited before $BARSULKA_BASE_URL/health became available." >&2
            sed -n '1,160p' "$BARSULKA_LOG" >&2 || true
            exit 1
        fi

        sleep 0.5
    done

    echo "Barsulka tunnel did not become healthy: $BARSULKA_BASE_URL/health" >&2
    echo "SSH tunnel is still running as pid $barsulka_pid; check remote GatewayPorts/firewall if public access fails." >&2
    sed -n '1,160p' "$BARSULKA_LOG" >&2 || true
    exit 1
}

stop_barsulka_tunnel() {
    local pids

    kill_pid_file_process "$BARSULKA_PID_FILE" "Barsulka SSH tunnel" || true

    pids="$(pgrep -f "ssh .*${BARSULKA_REMOTE_PORT}:127.0.0.1:${CONNECTOR_PORT}.*${BARSULKA_SSH_TARGET}" || true)"
    if [[ -n "$pids" ]]; then
        echo "$pids" | while read -r pid; do
            if [[ -n "$pid" ]] && kill -0 "$pid" 2>/dev/null; then
                echo "Stopping Barsulka SSH tunnel pid $pid..."
                kill "$pid" 2>/dev/null || true
            fi
        done
    fi

    rm -f "$BARSULKA_URL_FILE" "$BARSULKA_PID_FILE"
}

stop_local_connector_http() {
    local response_file
    local status

    if ! local_health_is_up; then
        echo "Local connector is already stopped: $LOCAL_BASE_URL/health"
        return 0
    fi

    if ! STATE_CONNECTOR_TOKEN="$(resolve_existing_token)"; then
        echo "Cannot stop local connector: token for $LOCAL_BASE_URL is unavailable." >&2
        exit 1
    fi
    export STATE_CONNECTOR_TOKEN

    response_file="$(mktemp -t shelter-local-connector-stop.XXXXXX.json)"
    status="$(curl -sS -o "$response_file" -w "%{http_code}" -X POST "$LOCAL_BASE_URL/control/connector/http/stop?token=$STATE_CONNECTOR_TOKEN" || true)"
    if [[ "$status" != "200" ]]; then
        echo "Local connector stop failed with HTTP $status:" >&2
        cat "$response_file" >&2 || true
        rm -f "$response_file"
        exit 1
    fi

    cat "$response_file"
    rm -f "$response_file"
    echo ""

    for _ in $(seq 1 40); do
        if ! local_health_is_up; then
            echo "Local connector stopped; Godot process is expected to keep running."
            return 0
        fi
        sleep 0.25
    done

    echo "Local connector still answers after stop command: $LOCAL_BASE_URL/health" >&2
    exit 1
}

stop_local_connector_http_for_exit() {
    local response_file
    local status

    if ! local_health_is_up; then
        echo "Local connector is already stopped: $LOCAL_BASE_URL/health"
        return 0
    fi

    if ! STATE_CONNECTOR_TOKEN="$(resolve_existing_token)"; then
        echo "Cannot stop local connector gracefully: token for $LOCAL_BASE_URL is unavailable."
        return 1
    fi
    export STATE_CONNECTOR_TOKEN

    response_file="$(mktemp -t shelter-local-connector-exit.XXXXXX.json)"
    status="$(curl -sS -o "$response_file" -w "%{http_code}" -X POST "$LOCAL_BASE_URL/control/connector/http/stop?token=$STATE_CONNECTOR_TOKEN" || true)"
    if [[ "$status" != "200" ]]; then
        echo "Local connector graceful stop failed with HTTP $status:"
        cat "$response_file" || true
        rm -f "$response_file"
        return 1
    fi

    cat "$response_file"
    rm -f "$response_file"
    echo ""

    for _ in $(seq 1 40); do
        if ! local_health_is_up; then
            echo "Local connector stopped."
            return 0
        fi
        sleep 0.25
    done

    echo "Local connector still answers after graceful stop request: $LOCAL_BASE_URL/health"
    return 1
}

stop_matching_godot_processes() {
    local stopped="false"
    local pid
    local command

    while read -r pid command; do
        if [[ -z "$pid" ]] || [[ "$pid" == "$$" ]]; then
            continue
        fi

        if [[ "$command" == *"--path $ROOT_DIR"* ]] \
            && [[ "$command" == *"vertical_slice_demo.tscn"* ]] \
            && [[ "$command" == *"--state-connector-port=$CONNECTOR_PORT"* ]]; then
            if kill -0 "$pid" 2>/dev/null; then
                echo "Stopping Godot game pid $pid..."
                kill "$pid" 2>/dev/null || true
                stopped="true"
            fi
        fi
    done < <(ps -axo pid=,command=)

    [[ "$stopped" == "true" ]]
}

stop_godot_game_for_exit() {
    if kill_pid_file_process "$PID_FILE" "Godot game"; then
        rm -f "$TOKEN_FILE" "$PID_FILE"
        echo "Godot game stopped."
        return 0
    fi

    if stop_matching_godot_processes; then
        rm -f "$TOKEN_FILE" "$PID_FILE"
        echo "Godot game stopped."
        return 0
    fi

    rm -f "$PID_FILE"
    echo "No Godot game process from this launcher is running."
}

exit_all() {
    stop_cloudflared_for_exit
    stop_barsulka_tunnel
    stop_local_connector_http_for_exit || true
    stop_godot_game_for_exit
    rm -f "$TOKEN_FILE" "$CLOUDFLARED_URL_FILE" "$CLOUDFLARED_PID_FILE" "$BARSULKA_URL_FILE" "$BARSULKA_PID_FILE"
    echo "Shelter launcher shutdown complete."
}

stop_barsulka() {
    stop_barsulka_tunnel
    stop_local_connector_http
}

monitor_started_processes() {
    if [[ "$started_game" != "true" ]] && [[ "$started_cloudflared" != "true" ]] && [[ "$started_barsulka" != "true" ]]; then
        return
    fi

    echo "Keep this terminal open. Press Ctrl+C here to stop processes started by this launcher."
    while true; do
        if [[ "$started_game" == "true" ]] && ! kill -0 "$game_pid" 2>/dev/null; then
            echo "Godot exited."
            wait "$game_pid" 2>/dev/null || true
            exit 0
        fi

        if [[ "$started_cloudflared" == "true" ]] && ! kill -0 "$cloudflared_pid" 2>/dev/null; then
            echo "cloudflared exited."
            wait "$cloudflared_pid" 2>/dev/null || true
            exit 0
        fi

        if [[ "$started_barsulka" == "true" ]] && ! kill -0 "$barsulka_pid" 2>/dev/null; then
            echo "Barsulka SSH tunnel exited."
            wait "$barsulka_pid" 2>/dev/null || true
            exit 0
        fi

        if [[ "$started_game" == "true" ]] && ! local_health_is_up; then
            echo "Local connector stopped responding at $LOCAL_BASE_URL/health; preserving Godot process."
            preserve_game_on_exit="true"
            exit 0
        fi

        sleep 1
    done
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --url)
            mode="url"
            ;;
        --exit|--shutdown)
            mode="exit"
            ;;
        --cloudflared)
            mode="provider"
            provider="cloudflared"
            ;;
        --barsulka)
            mode="provider"
            provider="barsulka"
            ;;
        --start)
            action="start"
            ;;
        --stop)
            action="stop"
            ;;
        --launcher)
            want_launcher="true"
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        --)
            shift
            passthrough_args=("$@")
            break
            ;;
        *)
            echo "Unknown option: $1" >&2
            usage >&2
            exit 2
            ;;
    esac
    shift
done

if [[ "$mode" == "provider" ]] && [[ -z "$action" ]]; then
    action="url"
fi

if [[ "$want_launcher" == "true" ]]; then
    if [[ ! -x "$GODOT_BIN" ]]; then
        echo "Godot binary not found or not executable: $GODOT_BIN" >&2
        echo "Set GODOT_BIN to a Godot 4.x editor binary." >&2
        exit 1
    fi

    if (( ${#passthrough_args[@]} > 0 )); then
        exec "$GODOT_BIN" --path "$ROOT_DIR" --scene res://scenes/launcher.tscn -- "${passthrough_args[@]}"
    fi
    exec "$GODOT_BIN" --path "$ROOT_DIR" --scene res://scenes/launcher.tscn
fi

trap cleanup EXIT
trap terminate INT TERM

case "$mode" in
    start)
        ensure_game
        print_local_urls
        monitor_started_processes
        ;;
    url)
        require_existing_game
        print_local_urls
        ;;
    exit)
        exit_all
        ;;
    provider)
        case "$provider:$action" in
            cloudflared:url)
                require_existing_game
                print_existing_cloudflared_urls
                ;;
            cloudflared:start)
                ensure_game
                start_cloudflared
                monitor_started_processes
                ;;
            cloudflared:stop)
                stop_cloudflared
                ;;
            barsulka:url)
                require_existing_game
                print_existing_barsulka_urls
                ;;
            barsulka:start)
                ensure_game
                start_barsulka
                monitor_started_processes
                ;;
            barsulka:stop)
                stop_barsulka
                ;;
            *)
                echo "Unsupported provider/action: $provider $action" >&2
                usage >&2
                exit 2
                ;;
        esac
        ;;
esac
