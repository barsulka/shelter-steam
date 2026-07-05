#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPO_DIR="$(cd "$ROOT_DIR/.." && pwd)"
DEFAULT_GODOT_BIN="$HOME/Library/Application Support/Steam/steamapps/common/Godot Engine/Godot.app/Contents/MacOS/Godot"
GODOT_BIN="${GODOT_BIN:-$DEFAULT_GODOT_BIN}"
MODE="${1:-interactive}"
EXTRA_ARGS=("${@:2}")
CAPTURE_DIR="$REPO_DIR/docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_VERTICAL_SLICE_ART_QA_CAPTURE_v2"
SMOKE_CAPTURE_DIR="$CAPTURE_DIR/_capture_smoke_tmp"
CONNECTOR_PORT="${STATE_CONNECTOR_PORT:-8765}"
CONNECTOR_SMOKE_PORT="${STATE_CONNECTOR_SMOKE_PORT:-18765}"
CONNECTOR_CONTROL_SMOKE_PORT="${STATE_CONNECTOR_CONTROL_SMOKE_PORT:-18766}"
CONNECTOR_RUNTIME_SMOKE_PORT="${STATE_CONNECTOR_RUNTIME_SMOKE_PORT:-18767}"
CONNECTOR_RUNTIME_SAVE_SMOKE_PORT="${STATE_CONNECTOR_RUNTIME_SAVE_SMOKE_PORT:-18768}"
CONNECTOR_INTERVAL="${STATE_CONNECTOR_INTERVAL:-5}"
CONNECTOR_RUNTIME_DIR="$ROOT_DIR/.runtime/godot_state_connector"
CONNECTOR_SNAPSHOT_FILE="$CONNECTOR_RUNTIME_DIR/state_snapshot.json"
WORKBENCH_CAPTURE_VERSION="shelter.workbench_capture.v0"

workbench_capture_usage() {
    cat <<'EOF'
Usage:
  tools/dev-vertical-slice.sh workbench-capture [options]

Options:
  --scenario=first_delivery_from_empty|first_delivery_with_dispatch_confirmation|warm_food_delivery_mid_chain|house_of_curiosity_learning_session
  --fixture=fixture_id
  --game-seconds=180
  --sample-every-game-seconds=10
  --speed=1|2|3|5|10|100
  --output-dir=.runtime/workbench_capture_runs/<run_id>
  --keep-running
  --port=8765
  --token=...

The harness uses live Godot connector/control endpoints as the source of truth.
It writes manifest.json, snapshots.jsonl, events.jsonl, stress_signals.jsonl,
final_state.json and run.log under the selected output directory.
EOF
}

workbench_make_token() {
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

workbench_health_is_up() {
    local base_url="$1"
    local body

    body="$(curl -fsS --max-time 2 "$base_url/health" 2>/dev/null || true)"
    [[ "$body" == *'"schema_version": "shelter.godot_state_connector.v0.2"'* ]]
}

workbench_control_is_reachable() {
    local base_url="$1"
    local token="$2"

    [[ -n "$token" ]] && curl -fsS --max-time 2 "$base_url/control?token=$token" >/dev/null 2>&1
}

workbench_redacted_command_line() {
    local command="./tools/dev-vertical-slice.sh workbench-capture"
    local arg
    local redacted
    local redact_next="false"

    if (( ${#EXTRA_ARGS[@]} > 0 )); then
        for arg in "${EXTRA_ARGS[@]}"; do
            if [[ "$redact_next" == "true" ]]; then
                redacted="<redacted>"
                redact_next="false"
            elif [[ "$arg" == "--token" ]]; then
                redacted="--token"
                redact_next="true"
            elif [[ "$arg" == --token=* ]]; then
                redacted="--token=<redacted>"
            else
                redacted="$arg"
            fi
            command="$command $redacted"
        done
    fi

    printf '%s\n' "$command"
}

if [[ ! -x "$GODOT_BIN" ]]; then
    echo "Godot binary not found or not executable: $GODOT_BIN" >&2
    echo "Set GODOT_BIN to a Godot 4.x editor binary." >&2
    exit 1
fi

case "$MODE" in
    all|interactive)
        if (( ${#EXTRA_ARGS[@]} > 0 )); then
            exec "$GODOT_BIN" --path "$ROOT_DIR" --scene res://scenes/prototypes/vertical_slice/vertical_slice_demo.tscn -- "${EXTRA_ARGS[@]}"
        fi
        exec "$GODOT_BIN" --path "$ROOT_DIR" --scene res://scenes/prototypes/vertical_slice/vertical_slice_demo.tscn
        ;;
    qa)
        scene_args=(--vertical-qa)
        if (( ${#EXTRA_ARGS[@]} > 0 )); then
            scene_args+=("${EXTRA_ARGS[@]}")
        fi
        exec "$GODOT_BIN" --path "$ROOT_DIR" --scene res://scenes/prototypes/vertical_slice/vertical_slice_demo.tscn -- "${scene_args[@]}"
        ;;
    player-prototype)
        scene_args=(--vertical-player-prototype)
        if (( ${#EXTRA_ARGS[@]} > 0 )); then
            scene_args+=("${EXTRA_ARGS[@]}")
        fi
        exec "$GODOT_BIN" --path "$ROOT_DIR" --scene res://scenes/prototypes/vertical_slice/vertical_slice_demo.tscn -- "${scene_args[@]}"
        ;;
    perf)
        if (( ${#EXTRA_ARGS[@]} > 0 )); then
            exec "$GODOT_BIN" --print-fps --path "$ROOT_DIR" --scene res://scenes/prototypes/vertical_slice/vertical_slice_demo.tscn -- "${EXTRA_ARGS[@]}"
        fi
        exec "$GODOT_BIN" --print-fps --path "$ROOT_DIR" --scene res://scenes/prototypes/vertical_slice/vertical_slice_demo.tscn
        ;;
    normal)
        scene_args=(--vertical-normal)
        if (( ${#EXTRA_ARGS[@]} > 0 )); then
            scene_args+=("${EXTRA_ARGS[@]}")
        fi
        exec "$GODOT_BIN" --path "$ROOT_DIR" --scene res://scenes/prototypes/vertical_slice/vertical_slice_demo.tscn -- "${scene_args[@]}"
        ;;
    autoplay)
        scene_args=(--vertical-auto-play)
        if (( ${#EXTRA_ARGS[@]} > 0 )); then
            scene_args+=("${EXTRA_ARGS[@]}")
        fi
        exec "$GODOT_BIN" --path "$ROOT_DIR" --scene res://scenes/prototypes/vertical_slice/vertical_slice_demo.tscn -- "${scene_args[@]}"
        ;;
    connector)
        mkdir -p "$CONNECTOR_RUNTIME_DIR"
        scene_args=(--state-connector --state-connector-port="$CONNECTOR_PORT" --state-connector-interval="$CONNECTOR_INTERVAL")
        if (( ${#EXTRA_ARGS[@]} > 0 )); then
            scene_args+=("${EXTRA_ARGS[@]}")
        fi
        exec "$GODOT_BIN" --path "$ROOT_DIR" --scene res://scenes/prototypes/vertical_slice/vertical_slice_demo.tscn -- "${scene_args[@]}"
        ;;
    connector-control)
        mkdir -p "$CONNECTOR_RUNTIME_DIR"
        token_arg=()
        if [[ -n "${STATE_CONNECTOR_TOKEN:-}" ]]; then
            token_arg=(--state-connector-token="$STATE_CONNECTOR_TOKEN")
        fi
        scene_args=(--state-connector-control --state-connector-port="$CONNECTOR_PORT" --state-connector-interval="$CONNECTOR_INTERVAL")
        if (( ${#token_arg[@]} > 0 )); then
            scene_args+=("${token_arg[@]}")
        fi
        if (( ${#EXTRA_ARGS[@]} > 0 )); then
            scene_args+=("${EXTRA_ARGS[@]}")
        fi
        exec "$GODOT_BIN" --path "$ROOT_DIR" --scene res://scenes/prototypes/vertical_slice/vertical_slice_demo.tscn -- "${scene_args[@]}"
        ;;
    connector-tunnel)
        mkdir -p "$CONNECTOR_RUNTIME_DIR"
        token_arg=()
        if [[ -n "${STATE_CONNECTOR_TOKEN:-}" ]]; then
            token_arg=(--state-connector-token="$STATE_CONNECTOR_TOKEN")
        fi
        scene_args=(--state-connector-tunnel --state-connector-port="$CONNECTOR_PORT" --state-connector-interval="$CONNECTOR_INTERVAL")
        if (( ${#token_arg[@]} > 0 )); then
            scene_args+=("${token_arg[@]}")
        fi
        if (( ${#EXTRA_ARGS[@]} > 0 )); then
            scene_args+=("${EXTRA_ARGS[@]}")
        fi
        exec "$GODOT_BIN" --path "$ROOT_DIR" --scene res://scenes/prototypes/vertical_slice/vertical_slice_demo.tscn -- "${scene_args[@]}"
        ;;
    connector-control-tunnel)
        mkdir -p "$CONNECTOR_RUNTIME_DIR"
        token_arg=()
        if [[ -n "${STATE_CONNECTOR_TOKEN:-}" ]]; then
            token_arg=(--state-connector-token="$STATE_CONNECTOR_TOKEN")
        fi
        scene_args=(--state-connector-control-tunnel --state-connector-port="$CONNECTOR_PORT" --state-connector-interval="$CONNECTOR_INTERVAL")
        if (( ${#token_arg[@]} > 0 )); then
            scene_args+=("${token_arg[@]}")
        fi
        if (( ${#EXTRA_ARGS[@]} > 0 )); then
            scene_args+=("${EXTRA_ARGS[@]}")
        fi
        exec "$GODOT_BIN" --path "$ROOT_DIR" --scene res://scenes/prototypes/vertical_slice/vertical_slice_demo.tscn -- "${scene_args[@]}"
        ;;
    smoke)
        exec "$GODOT_BIN" --headless --path "$ROOT_DIR" --scene res://scenes/prototypes/vertical_slice/vertical_slice_demo.tscn -- --vertical-auto-play --vertical-fast --vertical-auto-quit --vertical-seconds=10
        ;;
    connector-smoke)
        rm -rf "$CONNECTOR_RUNTIME_DIR"
        mkdir -p "$CONNECTOR_RUNTIME_DIR"
        log_file="$(mktemp -t shelter-state-connector-log.XXXXXX)"
        health_json="$(mktemp -t shelter-state-connector-health.XXXXXX.json)"
        schema_json="$(mktemp -t shelter-state-connector-schema.XXXXXX.json)"
        state_json="$(mktemp -t shelter-state-connector-state.XXXXXX.json)"
        cleanup_connector_smoke() {
            if [[ -n "${godot_pid:-}" ]] && kill -0 "$godot_pid" 2>/dev/null; then
                kill "$godot_pid" 2>/dev/null || true
                wait "$godot_pid" 2>/dev/null || true
            fi
            rm -f "$log_file" "$health_json" "$schema_json" "$state_json"
        }
        trap cleanup_connector_smoke EXIT

        "$GODOT_BIN" --headless --path "$ROOT_DIR" --scene res://scenes/prototypes/vertical_slice/vertical_slice_demo.tscn -- --vertical-auto-play --vertical-fast --state-connector --state-connector-port="$CONNECTOR_SMOKE_PORT" --state-connector-interval="$CONNECTOR_INTERVAL" >"$log_file" 2>&1 &
        godot_pid="$!"

        for _ in $(seq 1 80); do
            if curl -fsS "http://127.0.0.1:$CONNECTOR_SMOKE_PORT/health" >"$health_json" 2>/dev/null; then
                break
            fi
            if ! kill -0 "$godot_pid" 2>/dev/null; then
                sed -n '1,220p' "$log_file" >&2
                exit 1
            fi
            sleep 0.1
        done

        if [[ ! -s "$health_json" ]]; then
            sed -n '1,220p' "$log_file" >&2
            echo "connector-smoke could not reach /health on port $CONNECTOR_SMOKE_PORT" >&2
            exit 1
        fi

        curl -fsS "http://127.0.0.1:$CONNECTOR_SMOKE_PORT/schema" >"$schema_json"
        curl -fsS "http://127.0.0.1:$CONNECTOR_SMOKE_PORT/state" >"$state_json"
        control_status="$(curl -sS -o /dev/null -w "%{http_code}" "http://127.0.0.1:$CONNECTOR_SMOKE_PORT/control" || true)"
        if [[ "$control_status" != "404" ]]; then
            sed -n '1,220p' "$log_file" >&2
            echo "connector-smoke expected read-only /control to be masked 404, got $control_status" >&2
            exit 1
        fi

        python3 - "$health_json" "$schema_json" "$state_json" "$CONNECTOR_SNAPSHOT_FILE" "$CONNECTOR_INTERVAL" <<'PY'
import json
import pathlib
import sys

health_path, schema_path, state_path, snapshot_path = [pathlib.Path(value) for value in sys.argv[1:5]]
expected_interval = float(sys.argv[5])
health = json.loads(health_path.read_text())
schema = json.loads(schema_path.read_text())
state = json.loads(state_path.read_text())
snapshot = json.loads(snapshot_path.read_text())

assert health["ok"] is True
assert schema["ok"] is True
assert state["schema_version"] == "shelter.godot_state_connector.v0.2"
assert snapshot["schema_version"] == state["schema_version"]
assert snapshot["connector"]["snapshot_interval_seconds"] == expected_interval
assert state["order"]["id"] == "order.first_warm_delivery"
assert any(dog["id"] == "dog.dachshund_intro" for dog in state["dogs"])
assert any(building["id"] == "object.storage" for building in state["buildings"])
assert "storage" in state["resources"]["inventories"]
assert isinstance(state["tasks"], list)
assert isinstance(state["events"], list)
PY

        for _ in $(seq 1 120); do
            if curl -fsS "http://127.0.0.1:$CONNECTOR_SMOKE_PORT/state" >"$state_json" 2>/dev/null; then
                if python3 - "$state_json" <<'PY'
import json
import pathlib
import sys
state = json.loads(pathlib.Path(sys.argv[1]).read_text())
raise SystemExit(0 if state["game"]["chain_complete"] else 1)
PY
                then
                    break
                fi
            fi
            if ! kill -0 "$godot_pid" 2>/dev/null; then
                sed -n '1,220p' "$log_file" >&2
                echo "connector-smoke Godot process exited before chain_complete=true" >&2
                exit 1
            fi
            sleep 0.1
        done

        if ! python3 - "$state_json" <<'PY'
import json
import pathlib
import sys
state = json.loads(pathlib.Path(sys.argv[1]).read_text())
assert state["game"]["chain_complete"] is True
dachshund = next(dog for dog in state["dogs"] if dog["id"] == "dog.dachshund_intro")
assert any(item["id"] == "equipment.comfortable_slippers" for item in dachshund["equipment"])
assert any(trait["id"] == "trait.fast_paws" for trait in dachshund["innate_traits"])
assert state["order"]["slippers_equipped"] is True
PY
        then
            sed -n '1,220p' "$log_file" >&2
            echo "connector-smoke did not observe final live /state with D-010 equipment separation" >&2
            exit 1
        fi
        trap - EXIT
        cleanup_connector_smoke
        echo "connector-smoke passed on http://127.0.0.1:$CONNECTOR_SMOKE_PORT/state"
        ;;
    connector-control-smoke)
        rm -rf "$CONNECTOR_RUNTIME_DIR"
        mkdir -p "$CONNECTOR_RUNTIME_DIR"
        control_token="${STATE_CONNECTOR_TOKEN:-connector-control-smoke-token}"
        log_file="$(mktemp -t shelter-state-connector-control-log.XXXXXX)"
        health_json="$(mktemp -t shelter-state-connector-control-health.XXXXXX.json)"
        schema_json="$(mktemp -t shelter-state-connector-control-schema.XXXXXX.json)"
        state_json="$(mktemp -t shelter-state-connector-control-state.XXXXXX.json)"
        capabilities_json="$(mktemp -t shelter-state-connector-control-capabilities.XXXXXX.json)"
        control_html="$(mktemp -t shelter-state-connector-control-page.XXXXXX.html)"
        command_json="$(mktemp -t shelter-state-connector-control-command.XXXXXX.json)"
        unauthorized_json="$(mktemp -t shelter-state-connector-control-unauthorized.XXXXXX.json)"
        cleanup_connector_control_smoke() {
            if [[ -n "${godot_pid:-}" ]] && kill -0 "$godot_pid" 2>/dev/null; then
                kill "$godot_pid" 2>/dev/null || true
                wait "$godot_pid" 2>/dev/null || true
            fi
            rm -f "$log_file" "$health_json" "$schema_json" "$state_json" "$capabilities_json" "$control_html" "$command_json" "$unauthorized_json"
        }
        trap cleanup_connector_control_smoke EXIT

        "$GODOT_BIN" --headless --path "$ROOT_DIR" --scene res://scenes/prototypes/vertical_slice/vertical_slice_demo.tscn -- --vertical-auto-play --vertical-fast --state-connector-control --state-connector-port="$CONNECTOR_CONTROL_SMOKE_PORT" --state-connector-token="$control_token" --state-connector-interval="$CONNECTOR_INTERVAL" >"$log_file" 2>&1 &
        godot_pid="$!"

        for _ in $(seq 1 80); do
            if curl -fsS "http://127.0.0.1:$CONNECTOR_CONTROL_SMOKE_PORT/health" >"$health_json" 2>/dev/null; then
                break
            fi
            if ! kill -0 "$godot_pid" 2>/dev/null; then
                sed -n '1,220p' "$log_file" >&2
                exit 1
            fi
            sleep 0.1
        done

        if [[ ! -s "$health_json" ]]; then
            sed -n '1,220p' "$log_file" >&2
            echo "connector-control-smoke could not reach /health on port $CONNECTOR_CONTROL_SMOKE_PORT" >&2
            exit 1
        fi

        unauthorized_status="$(curl -sS -o "$unauthorized_json" -w "%{http_code}" -X POST "http://127.0.0.1:$CONNECTOR_CONTROL_SMOKE_PORT/control/ui/hide" || true)"
        if [[ "$unauthorized_status" != "404" ]]; then
            sed -n '1,220p' "$log_file" >&2
            echo "connector-control-smoke expected masked 404 without token, got $unauthorized_status" >&2
            cat "$unauthorized_json" >&2 || true
            exit 1
        fi

        curl -fsS "http://127.0.0.1:$CONNECTOR_CONTROL_SMOKE_PORT/schema?token=$control_token" >"$schema_json"
        curl -fsS "http://127.0.0.1:$CONNECTOR_CONTROL_SMOKE_PORT/state?token=$control_token" >"$state_json"
        curl -fsS "http://127.0.0.1:$CONNECTOR_CONTROL_SMOKE_PORT/control/capabilities?token=$control_token" >"$capabilities_json"
        curl -fsS "http://127.0.0.1:$CONNECTOR_CONTROL_SMOKE_PORT/control?token=$control_token" >"$control_html"

        python3 - "$health_json" "$schema_json" "$state_json" "$capabilities_json" "$control_html" "$CONNECTOR_INTERVAL" <<'PY'
import json
import pathlib
import sys

health_path, schema_path, state_path, capabilities_path, html_path = [pathlib.Path(value) for value in sys.argv[1:6]]
expected_interval = float(sys.argv[6])
health = json.loads(health_path.read_text())
schema = json.loads(schema_path.read_text())
state = json.loads(state_path.read_text())
capabilities = json.loads(capabilities_path.read_text())
html = html_path.read_text()

assert health["ok"] is True
assert "control_enabled" not in health["connector"]
assert "control" not in health["connector"]
assert "token=" not in json.dumps(health["endpoints"])
assert schema["ok"] is True
assert schema["control_enabled"] is True
assert schema["read_only"] is False
assert state["schema_version"] == "shelter.godot_state_connector.v0.2"
assert state["connector"]["control_enabled"] is True
assert state["connector"]["snapshot_interval_seconds"] == expected_interval
assert state["game"]["control_enabled"] is True
assert state["game"]["window_visible"] is True
assert capabilities["ok"] is True
assert capabilities["enabled"] is True
assert any(command["id"] == "ui.hide" for command in capabilities["commands"])
assert any(command["id"] == "capture.screenshot" for command in capabilities["commands"])
assert any(command["id"] == "capture.video.start" for command in capabilities["commands"])
assert any(command["id"] == "capture.video.status" for command in capabilities["commands"])
assert "Toggle" in html
assert "Screenshot" in html
assert "Record 10s" in html
assert "Hide Game" not in html
assert "Show Game" not in html
assert "/control/ui/hide" not in html
assert "/control/ui/show" not in html
assert "/control/ui/toggle" in html
assert "/control/capture/screenshot" in html
assert "/control/capture/video/start" in html
PY

        curl -fsS -X POST "http://127.0.0.1:$CONNECTOR_CONTROL_SMOKE_PORT/control/ui/hide?token=$control_token" >"$command_json"
        python3 - "$command_json" "$CONNECTOR_CONTROL_SMOKE_PORT" "$control_token" <<'PY'
import json
import pathlib
import subprocess
import sys

command_path = pathlib.Path(sys.argv[1])
port = sys.argv[2]
token = sys.argv[3]
command = json.loads(command_path.read_text())
assert command["ok"] is True
assert command["command"] == "ui.hide"
assert command["ui_visible"] is False

health = json.loads(subprocess.check_output(["curl", "-fsS", f"http://127.0.0.1:{port}/health"], text=True))
assert health["ok"] is True

state = json.loads(subprocess.check_output(["curl", "-fsS", f"http://127.0.0.1:{port}/state?token={token}"], text=True))
assert state["game"]["window_visible"] is False
PY

        curl -fsS -X POST "http://127.0.0.1:$CONNECTOR_CONTROL_SMOKE_PORT/control/ui/show?token=$control_token" >"$command_json"
        python3 - "$command_json" "$CONNECTOR_CONTROL_SMOKE_PORT" "$control_token" <<'PY'
import json
import pathlib
import subprocess
import sys

command_path = pathlib.Path(sys.argv[1])
port = sys.argv[2]
token = sys.argv[3]
command = json.loads(command_path.read_text())
assert command["ok"] is True
assert command["command"] == "ui.show"
assert command["ui_visible"] is True

state = json.loads(subprocess.check_output(["curl", "-fsS", f"http://127.0.0.1:{port}/state?token={token}"], text=True))
assert state["game"]["window_visible"] is True
PY

        trap - EXIT
        cleanup_connector_control_smoke
        echo "connector-control-smoke passed on http://127.0.0.1:$CONNECTOR_CONTROL_SMOKE_PORT/control"
        ;;
    runtime-foundation-smoke)
        rm -rf "$CONNECTOR_RUNTIME_DIR"
        mkdir -p "$CONNECTOR_RUNTIME_DIR"
        runtime_token="${STATE_CONNECTOR_TOKEN:-runtime-foundation-smoke-token}"
        log_file="$(mktemp -t shelter-runtime-foundation-log.XXXXXX)"
        tmp_dir="$(mktemp -d -t shelter-runtime-foundation.XXXXXX)"
        cleanup_runtime_foundation_smoke() {
            for pid in "${godot_pid:-}" "${save_godot_pid:-}"; do
                if [[ -n "$pid" ]] && kill -0 "$pid" 2>/dev/null; then
                    kill "$pid" 2>/dev/null || true
                    wait "$pid" 2>/dev/null || true
                fi
            done
            rm -rf "$tmp_dir" "$log_file"
        }
        trap cleanup_runtime_foundation_smoke EXIT

        "$GODOT_BIN" --headless --path "$ROOT_DIR" --scene res://scenes/prototypes/vertical_slice/vertical_slice_demo.tscn -- --vertical-fast --state-connector-control --state-connector-port="$CONNECTOR_RUNTIME_SMOKE_PORT" --state-connector-token="$runtime_token" --state-connector-interval="$CONNECTOR_INTERVAL" >"$log_file" 2>&1 &
        godot_pid="$!"

        for _ in $(seq 1 80); do
            if curl -fsS "http://127.0.0.1:$CONNECTOR_RUNTIME_SMOKE_PORT/health" >"$tmp_dir/health.json" 2>/dev/null; then
                break
            fi
            if ! kill -0 "$godot_pid" 2>/dev/null; then
                sed -n '1,220p' "$log_file" >&2
                exit 1
            fi
            sleep 0.1
        done

        unauthorized_status="$(curl -sS -o "$tmp_dir/unauthorized.json" -w "%{http_code}" -X POST "http://127.0.0.1:$CONNECTOR_RUNTIME_SMOKE_PORT/control/runtime/speed" || true)"
        if [[ "$unauthorized_status" != "404" ]]; then
            echo "runtime-foundation-smoke expected masked 404 without token, got $unauthorized_status" >&2
            cat "$tmp_dir/unauthorized.json" >&2 || true
            exit 1
        fi

        curl -fsS "http://127.0.0.1:$CONNECTOR_RUNTIME_SMOKE_PORT/control/runtime/fixtures?token=$runtime_token" >"$tmp_dir/fixtures.json"
        curl -fsS -X POST "http://127.0.0.1:$CONNECTOR_RUNTIME_SMOKE_PORT/control/runtime/speed?token=$runtime_token" -H 'Content-Type: application/json' --data '{"multiplier":5}' >"$tmp_dir/speed.json"
        curl -fsS "http://127.0.0.1:$CONNECTOR_RUNTIME_SMOKE_PORT/state?token=$runtime_token" >"$tmp_dir/state_speed.json"
        curl -fsS -X POST "http://127.0.0.1:$CONNECTOR_RUNTIME_SMOKE_PORT/control/runtime/fixture/load?token=$runtime_token" -H 'Content-Type: application/json' --data '{"fixture":"house_of_curiosity_learning_session"}' >"$tmp_dir/load_fixture.json"
        curl -fsS "http://127.0.0.1:$CONNECTOR_RUNTIME_SMOKE_PORT/state?token=$runtime_token" >"$tmp_dir/state_fixture.json"
        curl -fsS -X POST "http://127.0.0.1:$CONNECTOR_RUNTIME_SMOKE_PORT/control/runtime/state/export?token=$runtime_token" >"$tmp_dir/export.json"
        python3 - "$tmp_dir/export.json" "$tmp_dir/import_payload.json" <<'PY'
import json
import pathlib
import sys

export_response = json.loads(pathlib.Path(sys.argv[1]).read_text())
state = export_response["state"]
state["runtime"]["debug_speed_multiplier"] = 2
pathlib.Path(sys.argv[2]).write_text(json.dumps(state), encoding="utf-8")
PY
        curl -fsS -X POST "http://127.0.0.1:$CONNECTOR_RUNTIME_SMOKE_PORT/control/runtime/state/clear?token=$runtime_token" >"$tmp_dir/clear.json"
        curl -fsS -X POST "http://127.0.0.1:$CONNECTOR_RUNTIME_SMOKE_PORT/control/runtime/state/import?token=$runtime_token" -H 'Content-Type: application/json' --data-binary "@$tmp_dir/import_payload.json" >"$tmp_dir/import.json"
        curl -fsS -X POST "http://127.0.0.1:$CONNECTOR_RUNTIME_SMOKE_PORT/control/runtime/save/write?token=$runtime_token" >"$tmp_dir/save_write.json"
        curl -fsS -X POST "http://127.0.0.1:$CONNECTOR_RUNTIME_SMOKE_PORT/control/runtime/route/start?token=$runtime_token" >"$tmp_dir/route.json"
        curl -fsS -X POST "http://127.0.0.1:$CONNECTOR_RUNTIME_SMOKE_PORT/control/runtime/dog/assign?token=$runtime_token" -H 'Content-Type: application/json' --data '{"dog_id":"dog.labrador_intro","room_id":"room.house_of_curiosity.library","activity_group":"learning","activity_detail":"reading_book"}' >"$tmp_dir/assign.json"
        curl -fsS -X POST "http://127.0.0.1:$CONNECTOR_RUNTIME_SMOKE_PORT/control/runtime/research/start?token=$runtime_token" -H 'Content-Type: application/json' --data '{"node_id":"research.basket_check","room_id":"room.house_of_curiosity.classroom","dog_ids":["dog.dachshund_intro"]}' >"$tmp_dir/research.json"
        curl -fsS -X POST "http://127.0.0.1:$CONNECTOR_RUNTIME_SMOKE_PORT/control/runtime/debug/tick?token=$runtime_token" -H 'Content-Type: application/json' --data '{"seconds":1.5}' >"$tmp_dir/tick.json"
        curl -fsS "http://127.0.0.1:$CONNECTOR_RUNTIME_SMOKE_PORT/state?token=$runtime_token" >"$tmp_dir/final_state.json"

        if kill -0 "$godot_pid" 2>/dev/null; then
            kill "$godot_pid" 2>/dev/null || true
            wait "$godot_pid" 2>/dev/null || true
        fi
        godot_pid=""

        save_token="${runtime_token}-save"
        "$GODOT_BIN" --headless --path "$ROOT_DIR" --scene res://scenes/prototypes/vertical_slice/vertical_slice_demo.tscn -- --runtime-load-save --state-connector-control --state-connector-port="$CONNECTOR_RUNTIME_SAVE_SMOKE_PORT" --state-connector-token="$save_token" --state-connector-interval="$CONNECTOR_INTERVAL" >"$tmp_dir/save-load.log" 2>&1 &
        save_godot_pid="$!"
        for _ in $(seq 1 80); do
            if curl -fsS "http://127.0.0.1:$CONNECTOR_RUNTIME_SAVE_SMOKE_PORT/state?token=$save_token" >"$tmp_dir/state_after_save_load.json" 2>/dev/null; then
                break
            fi
            if ! kill -0 "$save_godot_pid" 2>/dev/null; then
                sed -n '1,220p' "$tmp_dir/save-load.log" >&2
                exit 1
            fi
            sleep 0.1
        done
        curl -fsS -X POST "http://127.0.0.1:$CONNECTOR_RUNTIME_SAVE_SMOKE_PORT/control/runtime/save/erase?token=$save_token" >"$tmp_dir/save_erase.json"

        python3 - "$tmp_dir" <<'PY'
import json
import pathlib
import sys

root = pathlib.Path(sys.argv[1])
def load(name):
    return json.loads((root / name).read_text())

fixtures = load("fixtures.json")
assert fixtures["ok"] is True
assert {item["id"] for item in fixtures["fixtures"]} >= {
    "first_day_empty_coop",
    "warm_food_delivery_mid_chain",
    "house_of_curiosity_learning_session",
}
assert load("speed.json")["speed_multiplier"] == 5
assert load("state_speed.json")["debug"]["speed_multiplier"] == 5
fixture_state = load("state_fixture.json")
assert fixture_state["house_of_curiosity"]["active_research"]["id"] == "research.soft_packing"
assert load("clear.json")["ok"] is True
assert load("import.json")["ok"] is True
assert load("save_write.json")["ok"] is True
assert load("route.json")["route_started"] is True
assert load("assign.json")["ok"] is True
assert load("research.json")["active_research"]["id"] == "research.basket_check"
assert load("tick.json")["ok"] is True
final_state = load("final_state.json")
assert final_state["house_of_curiosity"]["active_research"]["id"] == "research.basket_check"
assert any(event["tag"] == "debug" for event in final_state["events"])
state_after_save_load = load("state_after_save_load.json")
assert state_after_save_load["debug"]["active_save_file"]
assert load("save_erase.json")["ok"] is True
PY

        trap - EXIT
        cleanup_runtime_foundation_smoke
        echo "runtime-foundation-smoke passed on http://127.0.0.1:$CONNECTOR_RUNTIME_SMOKE_PORT/control"
        ;;
    workbench-capture)
        workbench_scenario="first_delivery_from_empty"
        workbench_fixture=""
        workbench_game_seconds="180"
        workbench_sample_every_game_seconds="10"
        workbench_speed="100"
        workbench_output_dir=""
        workbench_keep_running="false"
        workbench_port="$CONNECTOR_PORT"
        workbench_token="${STATE_CONNECTOR_TOKEN:-}"

        if (( ${#EXTRA_ARGS[@]} > 0 )); then
            for arg in "${EXTRA_ARGS[@]}"; do
                case "$arg" in
                    --scenario=*)
                        workbench_scenario="${arg#--scenario=}"
                        ;;
                    --fixture=*)
                        workbench_fixture="${arg#--fixture=}"
                        ;;
                    --game-seconds=*)
                        workbench_game_seconds="${arg#--game-seconds=}"
                        ;;
                    --sample-every-game-seconds=*)
                        workbench_sample_every_game_seconds="${arg#--sample-every-game-seconds=}"
                        ;;
                    --speed=*)
                        workbench_speed="${arg#--speed=}"
                        ;;
                    --output-dir=*)
                        workbench_output_dir="${arg#--output-dir=}"
                        ;;
                    --keep-running)
                        workbench_keep_running="true"
                        ;;
                    --port=*)
                        workbench_port="${arg#--port=}"
                        ;;
                    --token=*)
                        workbench_token="${arg#--token=}"
                        ;;
                    -h|--help)
                        workbench_capture_usage
                        exit 0
                        ;;
                    *)
                        echo "Unknown workbench-capture option: $arg" >&2
                        workbench_capture_usage >&2
                        exit 2
                        ;;
                esac
            done
        fi

        case "$workbench_scenario" in
            first_delivery_from_empty)
                if [[ -z "$workbench_fixture" ]]; then
                    workbench_fixture="first_day_empty_coop"
                fi
                ;;
            first_delivery_with_dispatch_confirmation)
                if [[ -z "$workbench_fixture" ]]; then
                    workbench_fixture="first_day_empty_coop"
                fi
                ;;
            warm_food_delivery_mid_chain)
                if [[ -z "$workbench_fixture" ]]; then
                    workbench_fixture="warm_food_delivery_mid_chain"
                fi
                ;;
            house_of_curiosity_learning_session)
                if [[ -z "$workbench_fixture" ]]; then
                    workbench_fixture="house_of_curiosity_learning_session"
                fi
                ;;
            *)
                echo "Unsupported workbench scenario: $workbench_scenario" >&2
                exit 2
                ;;
        esac

        case "$workbench_speed" in
            1|2|3|5|10|100)
                ;;
            *)
                echo "Unsupported workbench speed: $workbench_speed (expected 1, 2, 3, 5, 10, or 100)" >&2
                exit 2
                ;;
        esac

        python3 - "$workbench_game_seconds" "$workbench_sample_every_game_seconds" <<'PY'
import sys

game_seconds = float(sys.argv[1])
sample_every = float(sys.argv[2])
if game_seconds <= 0:
    raise SystemExit("--game-seconds must be > 0")
if sample_every <= 0:
    raise SystemExit("--sample-every-game-seconds must be > 0")
PY

        if [[ -z "$workbench_output_dir" ]]; then
            workbench_timestamp="$(date -u +%Y%m%dT%H%M%SZ)"
            workbench_output_dir=".runtime/workbench_capture_runs/${workbench_timestamp}__${workbench_scenario}"
        fi

        case "$workbench_output_dir" in
            /*)
                workbench_output_dir_abs="$workbench_output_dir"
                ;;
            *)
                workbench_output_dir_abs="$ROOT_DIR/$workbench_output_dir"
                ;;
        esac

        mkdir -p "$workbench_output_dir_abs"
        workbench_base_url="http://127.0.0.1:$workbench_port"
        workbench_run_id="$(basename "$workbench_output_dir_abs")"
        workbench_command_line="$(workbench_redacted_command_line)"
        workbench_log_file="$workbench_output_dir_abs/run.log"
        workbench_godot_log="$(mktemp -t shelter-workbench-capture-godot.XXXXXX.log)"
        workbench_started_godot="false"
        workbench_godot_pid=""

        cleanup_workbench_capture() {
            if [[ "$workbench_started_godot" == "true" ]] && [[ "$workbench_keep_running" != "true" ]] && [[ -n "$workbench_godot_pid" ]] && kill -0 "$workbench_godot_pid" 2>/dev/null; then
                kill "$workbench_godot_pid" 2>/dev/null || true
                wait "$workbench_godot_pid" 2>/dev/null || true
            fi
            if [[ "$workbench_keep_running" != "true" ]]; then
                rm -f "$workbench_godot_log"
            fi
        }
        trap cleanup_workbench_capture EXIT

        : > "$workbench_log_file"
        {
            echo "Workbench capture harness version: $WORKBENCH_CAPTURE_VERSION"
            echo "Base URL: $workbench_base_url"
            echo "Scenario: $workbench_scenario"
            echo "Fixture: $workbench_fixture"
            echo "Game seconds: $workbench_game_seconds"
            echo "Sample every game seconds: $workbench_sample_every_game_seconds"
            echo "Speed multiplier: $workbench_speed"
        } >> "$workbench_log_file"

        if workbench_health_is_up "$workbench_base_url"; then
            if ! workbench_control_is_reachable "$workbench_base_url" "$workbench_token"; then
                echo "A Shelter connector is already running at $workbench_base_url, but workbench-capture cannot access its control token." >&2
                echo "Pass the token with --token=... or choose a free --port=..." >&2
                exit 1
            fi
            echo "Reusing existing Shelter connector at $workbench_base_url" >> "$workbench_log_file"
        else
            if [[ -z "$workbench_token" ]]; then
                workbench_token="$(workbench_make_token)"
            fi
            mkdir -p "$CONNECTOR_RUNTIME_DIR"
            echo "Starting headless Godot connector/control for workbench capture..." >> "$workbench_log_file"
            "$GODOT_BIN" --headless --path "$ROOT_DIR" --scene res://scenes/prototypes/vertical_slice/vertical_slice_demo.tscn -- --vertical-fast --state-connector-control --state-connector-port="$workbench_port" --state-connector-token="$workbench_token" --state-connector-interval="$CONNECTOR_INTERVAL" >"$workbench_godot_log" 2>&1 &
            workbench_godot_pid="$!"
            workbench_started_godot="true"

            for _ in $(seq 1 160); do
                if workbench_health_is_up "$workbench_base_url"; then
                    break
                fi
                if ! kill -0 "$workbench_godot_pid" 2>/dev/null; then
                    sed -n '1,220p' "$workbench_godot_log" >&2
                    exit 1
                fi
                sleep 0.1
            done

            if ! workbench_health_is_up "$workbench_base_url"; then
                sed -n '1,220p' "$workbench_godot_log" >&2
                echo "workbench-capture could not reach /health on port $workbench_port" >&2
                exit 1
            fi
            if ! workbench_control_is_reachable "$workbench_base_url" "$workbench_token"; then
                sed -n '1,220p' "$workbench_godot_log" >&2
                echo "workbench-capture could not reach /control with its generated token" >&2
                exit 1
            fi
        fi

        WORKBENCH_BASE_URL="$workbench_base_url" \
        WORKBENCH_TOKEN="$workbench_token" \
        WORKBENCH_RUN_ID="$workbench_run_id" \
        WORKBENCH_SCENARIO_ID="$workbench_scenario" \
        WORKBENCH_FIXTURE_ID="$workbench_fixture" \
        WORKBENCH_GAME_SECONDS="$workbench_game_seconds" \
        WORKBENCH_SAMPLE_EVERY_GAME_SECONDS="$workbench_sample_every_game_seconds" \
        WORKBENCH_SPEED="$workbench_speed" \
        WORKBENCH_OUTPUT_DIR="$workbench_output_dir_abs" \
        WORKBENCH_SCRIPT_VERSION="$WORKBENCH_CAPTURE_VERSION" \
        WORKBENCH_REPO_ROOT="$REPO_DIR" \
        WORKBENCH_STEAM_ROOT="$ROOT_DIR" \
        WORKBENCH_COMMAND_LINE="$workbench_command_line" \
        WORKBENCH_KEEP_RUNNING="$workbench_keep_running" \
        WORKBENCH_STARTED_GODOT="$workbench_started_godot" \
        python3 - <<'PY'
import datetime as _datetime
import json
import math
import os
import pathlib
import time
import urllib.error
import urllib.parse
import urllib.request

base_url = os.environ["WORKBENCH_BASE_URL"].rstrip("/")
token = os.environ["WORKBENCH_TOKEN"]
run_id = os.environ["WORKBENCH_RUN_ID"]
scenario_id = os.environ["WORKBENCH_SCENARIO_ID"]
fixture_id = os.environ["WORKBENCH_FIXTURE_ID"]
requested_game_seconds = float(os.environ["WORKBENCH_GAME_SECONDS"])
sample_every_game_seconds = float(os.environ["WORKBENCH_SAMPLE_EVERY_GAME_SECONDS"])
speed_multiplier = int(os.environ["WORKBENCH_SPEED"])
output_dir = pathlib.Path(os.environ["WORKBENCH_OUTPUT_DIR"])
script_version = os.environ["WORKBENCH_SCRIPT_VERSION"]
repo_root = os.environ["WORKBENCH_REPO_ROOT"]
steam_root = os.environ["WORKBENCH_STEAM_ROOT"]
command_line = os.environ["WORKBENCH_COMMAND_LINE"]
keep_running = os.environ["WORKBENCH_KEEP_RUNNING"] == "true"
started_godot = os.environ["WORKBENCH_STARTED_GODOT"] == "true"

manifest_path = output_dir / "manifest.json"
snapshots_path = output_dir / "snapshots.jsonl"
events_path = output_dir / "events.jsonl"
stress_path = output_dir / "stress_signals.jsonl"
final_state_path = output_dir / "final_state.json"
run_log_path = output_dir / "run.log"

def utc_now():
    return _datetime.datetime.now(_datetime.timezone.utc).replace(microsecond=0).isoformat().replace("+00:00", "Z")

def append_log(message):
    with run_log_path.open("a", encoding="utf-8") as handle:
        handle.write(f"{utc_now()} {message}\n")

def control_url(path):
    separator = "&" if "?" in path else "?"
    return f"{base_url}{path}{separator}{urllib.parse.urlencode({'token': token})}"

def request(method, path, payload=None):
    data = None
    headers = {}
    if payload is not None:
        data = json.dumps(payload, ensure_ascii=False).encode("utf-8")
        headers["Content-Type"] = "application/json"
    req = urllib.request.Request(control_url(path), data=data, headers=headers, method=method)
    try:
        with urllib.request.urlopen(req, timeout=30) as response:
            text = response.read().decode("utf-8")
    except urllib.error.HTTPError as exc:
        body = exc.read().decode("utf-8", errors="replace")
        raise RuntimeError(f"{method} {path} failed with HTTP {exc.code}: {body}") from exc
    return json.loads(text)

def require_ok(response, label):
    if not response.get("ok", False):
        raise RuntimeError(f"{label} failed: {json.dumps(response, ensure_ascii=False)}")

def write_jsonl(path, item):
    with path.open("a", encoding="utf-8") as handle:
        handle.write(json.dumps(item, ensure_ascii=False, separators=(",", ":")))
        handle.write("\n")

def advance_game_time(game_seconds):
    debug_seconds_remaining = game_seconds / float(speed_multiplier)
    tick_results = []
    while debug_seconds_remaining > 1e-9:
        chunk = min(30.0, debug_seconds_remaining)
        if chunk < 0.05:
            chunk = 0.05
        response = request("POST", "/control/runtime/debug/tick", {"seconds": chunk})
        require_ok(response, "runtime.debug.tick")
        tick_results.append({
            "requested_seconds": response.get("requested_seconds", chunk),
            "effective_simulation_seconds": response.get("effective_simulation_seconds"),
            "chain_state": response.get("chain_state"),
        })
        debug_seconds_remaining -= chunk
    return tick_results

def first_warm_delivery_chain(state):
    for chain in state.get("production_chains", []):
        if chain.get("id") == "chain.warm_food_delivery_intro":
            return chain
    return {}

def resource_token(state, internal_resource_id):
    resources = state.get("resources", {}) or {}
    for token in resources.get("tokens", []) or []:
        if token.get("internal_resource_id") == internal_resource_id:
            return token
    economy_token = (((state.get("economy", {}) or {}).get("things", {}) or {}).get("tokens", {}) or {}).get(internal_resource_id)
    if isinstance(economy_token, dict):
        return economy_token
    return {}

def legacy_chain_statuses(state):
    statuses = {}
    for stage in state.get("production_chain", []) or []:
        if isinstance(stage, dict):
            statuses[str(stage.get("id", ""))] = str(stage.get("status", ""))
    return statuses

def is_ready_to_confirm_dispatch(state):
    order = state.get("order", {}) or {}
    chain = first_warm_delivery_chain(state)
    return (
        order.get("id") == "order.first_warm_delivery"
        and order.get("delivery_state") == "ready_to_send"
        and order.get("van_loaded") is True
        and order.get("delivery_confirmed") is False
        and chain.get("state") == "ready_to_dispatch"
        and chain.get("current_step") == "player_confirms_dispatch"
        and chain.get("blocked_reason") == "waiting_for_player_confirmation"
        and chain.get("player_confirmation_required") is True
    )

def dispatch_capture_proof(state):
    order = state.get("order", {}) or {}
    game = state.get("game", {}) or {}
    chain = first_warm_delivery_chain(state)
    event_types = [event.get("type") for event in state.get("events", [])]
    return {
        "order.delivery_confirmed": order.get("delivery_confirmed") is True,
        "order.postcard_visible": order.get("postcard_visible") is True,
        "order.reward_available": order.get("reward_available") is True,
        "game.chain_complete": game.get("chain_complete") is True,
        "production_chain.state": chain.get("state", ""),
        "production_chain.completed": chain.get("state") == "completed",
        "event.player_confirmed_delivery": "player_confirmed_delivery" in event_types,
        "event.postcard_created": "postcard_created" in event_types,
        "event.reward_created": "reward_created" in event_types,
    }

def first_day_mvp_proof(state):
    proof = dispatch_capture_proof(state)
    game = state.get("game", {}) or {}
    first_day = game.get("first_day", {}) or {}
    events = state.get("events", []) or []
    event_types = [event.get("type") for event in events]
    event_tags = {event.get("type"): event.get("tag") for event in events}
    food_bag = resource_token(state, "food_bag")
    resources = state.get("resources", {}) or {}
    inventories = resources.get("inventories", {}) or {}
    van_inventory = inventories.get("delivery_van_endpoint", {}) or {}
    legacy_statuses = legacy_chain_statuses(state)
    dog_action_events = [
        event for event in events
        if event.get("tag") == "dog_action"
        and str(event.get("type", "")).startswith("dog_")
    ]
    debug_time_events = [
        event for event in events
        if str(event.get("type", "")).startswith("debug_time_advanced")
    ]
    stress_signals = state.get("stress_test_signals", {}) or {}
    proof.update({
        "first_day.postcard_life_moment_seen": first_day.get("postcard_life_moment_seen") is True,
        "first_day.first_reward_equipped": first_day.get("first_reward_equipped") is True,
        "first_day.first_memory_added": first_day.get("first_memory_added") is True,
        "first_day.next_day_hint_available": first_day.get("next_day_hint_available") is True,
        "event.dog_noticed_postcard": "dog_noticed_postcard" in event_types,
        "event.dog_received_reward": "dog_received_reward" in event_types,
        "event.first_day_memory_added": "first_day_memory_added" in event_types,
        "event.next_day_hint_available": "next_day_hint_available" in event_types,
        "event.dog_equipped_first_reward": "dog_equipped_first_reward" in event_types,
        "dog_action.high_level_count_ok": len(dog_action_events) >= 8,
        "stress.dog_action_events_recent_positive": int(stress_signals.get("dog_action_events_recent", 0)) > 0,
        "food_bag.not_in_delivery_van": food_bag.get("location") != "delivery_van_endpoint" and int(van_inventory.get("food_bag", 0)) == 0,
        "food_bag.hidden_after_delivery": food_bag.get("visible") is False,
        "food_bag.semantic_delivered": food_bag.get("semantic_state") == "delivered",
        "food_bag.location": food_bag.get("location", ""),
        "legacy.trip.complete": legacy_statuses.get("trip") == "complete",
        "legacy.unload_to_storage.complete": legacy_statuses.get("unload_to_storage") == "complete",
        "legacy.cook_food_mix.complete": legacy_statuses.get("cook_food_mix") == "complete",
        "legacy.pack_food_bag.complete": legacy_statuses.get("pack_food_bag") == "complete",
        "legacy.delivery.complete": legacy_statuses.get("delivery") == "complete",
        "legacy.equip_comfortable_slippers.complete": legacy_statuses.get("equip_comfortable_slippers") == "complete",
        "debug_time_advanced.events_tagged_debug": bool(debug_time_events) and all(event.get("tag") == "debug" for event in debug_time_events),
        "debug_time_advanced.not_production_chain": all(event.get("tag") != "production_chain" for event in debug_time_events),
        "event_tags.dog_noticed_postcard": event_tags.get("dog_noticed_postcard", ""),
        "event_tags.first_day_memory_added": event_tags.get("first_day_memory_added", ""),
        "event_tags.next_day_hint_available": event_tags.get("next_day_hint_available", ""),
    })
    return proof

output_dir.mkdir(parents=True, exist_ok=True)
for path in (snapshots_path, events_path, stress_path):
    path.write_text("", encoding="utf-8")

created_at = utc_now()
known_warnings = [
    "Accelerated capture validates state transitions and causality, not desktop calmness, animation warmth, visual readability or player feel.",
]
if speed_multiplier == 100:
    known_warnings.append("100x is dev-only capture/testing acceleration and must not be treated as a player-facing or normal feel-test speed.")
if keep_running:
    known_warnings.append("--keep-running was set; the connector process may remain active after the harness exits.")
if not started_godot:
    known_warnings.append("The harness reused an existing local connector and did not own the runtime lifecycle.")

append_log("Listing runtime fixtures")
fixtures_response = request("GET", "/control/runtime/fixtures")
require_ok(fixtures_response, "runtime.fixtures.list")
fixture_ids = {str(item.get("id", "")) for item in fixtures_response.get("fixtures", [])}
if fixture_id not in fixture_ids:
    raise RuntimeError(f"fixture {fixture_id!r} is not listed by the live runtime")

append_log(f"Loading fixture {fixture_id}")
load_response = request("POST", "/control/runtime/fixture/load", {"fixture": fixture_id})
require_ok(load_response, "runtime.fixture.load")

append_log(f"Setting speed multiplier to {speed_multiplier}x")
speed_response = request("POST", "/control/runtime/speed", {"multiplier": speed_multiplier})
require_ok(speed_response, "runtime.speed.set")

setup_actions = [
    {"action": "fixture.load", "fixture_id": fixture_id},
    {"action": "runtime.speed.set", "speed_multiplier": speed_multiplier},
]
if scenario_id in {"first_delivery_from_empty", "first_delivery_with_dispatch_confirmation", "warm_food_delivery_mid_chain"}:
    append_log("Starting accepted test route")
    route_response = request("POST", "/control/runtime/route/start")
    require_ok(route_response, "runtime.route.start")
    setup_actions.append({
        "action": "runtime.route.start",
        "route_id": route_response.get("route_id"),
        "route_started": route_response.get("route_started"),
    })
elif scenario_id == "house_of_curiosity_learning_session":
    setup_actions.append({
        "action": "preserve_fixture_research_state",
        "research_id": "research.soft_packing",
    })

expected_snapshot_count = int(math.ceil(requested_game_seconds / sample_every_game_seconds))
current_game_time = 0.0
seen_event_keys = set()
events_written = 0
stress_lines_written = 0
last_state = None
debug_tick_seconds_per_sample = sample_every_game_seconds / float(speed_multiplier)
dispatch_ready_observed = False
dispatch_confirmation_response = None

append_log(f"Capturing {expected_snapshot_count} samples")
for sample_index in range(1, expected_snapshot_count + 1):
    remaining_game_seconds = requested_game_seconds - current_game_time
    game_delta = min(sample_every_game_seconds, remaining_game_seconds)
    ticks = advance_game_time(game_delta)
    current_game_time = min(requested_game_seconds, current_game_time + game_delta)
    state = request("GET", "/state")
    last_state = state
    sample_wall_time = utc_now()
    snapshot_record = {
        "run_id": run_id,
        "sample_index": sample_index,
        "sample_game_time": current_game_time,
        "sample_wall_time": sample_wall_time,
        "scenario_id": scenario_id,
        "fixture_id": fixture_id,
        "debug_ticks": ticks,
        "state": state,
    }
    write_jsonl(snapshots_path, snapshot_record)

    for event in state.get("events", []):
        event_key = str(event.get("id", "")) or json.dumps(event, sort_keys=True, ensure_ascii=False)
        if event_key in seen_event_keys:
            continue
        seen_event_keys.add(event_key)
        write_jsonl(events_path, {
            "run_id": run_id,
            "sample_index": sample_index,
            "sample_game_time": current_game_time,
            "sample_wall_time": sample_wall_time,
            "scenario_id": scenario_id,
            "fixture_id": fixture_id,
            "event": event,
        })
        events_written += 1

    if "stress_test_signals" in state:
        write_jsonl(stress_path, {
            "run_id": run_id,
            "sample_index": sample_index,
            "sample_game_time": current_game_time,
            "sample_wall_time": sample_wall_time,
            "scenario_id": scenario_id,
            "fixture_id": fixture_id,
            "stress_test_signals": state.get("stress_test_signals", {}),
        })
        stress_lines_written += 1

    if (
        scenario_id == "first_delivery_with_dispatch_confirmation"
        and dispatch_confirmation_response is None
        and is_ready_to_confirm_dispatch(state)
    ):
        dispatch_ready_observed = True
        append_log(f"Sample {sample_index} reached ready_to_dispatch; confirming dispatch through runtime.delivery.confirm")
        dispatch_confirmation_response = request("POST", "/control/runtime/delivery/confirm")
        require_ok(dispatch_confirmation_response, "runtime.delivery.confirm")
        setup_actions.append({
            "action": "runtime.delivery.confirm",
            "sample_index": sample_index,
            "sample_game_time": current_game_time,
            "delivery_confirmed": dispatch_confirmation_response.get("delivery_confirmed"),
            "chain_state": dispatch_confirmation_response.get("chain_state"),
        })

if last_state is None:
    last_state = request("GET", "/state")

final_state_path.write_text(json.dumps(last_state, ensure_ascii=False, indent=2), encoding="utf-8")

dispatch_proof = None
first_day_proof = None
if scenario_id == "first_delivery_with_dispatch_confirmation":
    if not dispatch_ready_observed or dispatch_confirmation_response is None:
        raise RuntimeError("first_delivery_with_dispatch_confirmation did not observe ready_to_dispatch before confirmation")
    dispatch_proof = dispatch_capture_proof(last_state)
    first_day_proof = first_day_mvp_proof(last_state)
    failed_dispatch_proof = [
        key for key, value in dispatch_proof.items()
        if key != "production_chain.state" and value is not True
    ]
    if failed_dispatch_proof:
        raise RuntimeError(f"dispatch confirmation capture did not reach final proof values: {failed_dispatch_proof}; proof={json.dumps(dispatch_proof, ensure_ascii=False)}")
    failed_first_day_proof = [
        key for key, value in first_day_proof.items()
        if isinstance(value, bool) and value is not True
    ]
    if failed_first_day_proof:
        raise RuntimeError(f"first-day MVP capture did not reach final proof values: {failed_first_day_proof}; proof={json.dumps(first_day_proof, ensure_ascii=False)}")

snapshot_count = sum(1 for _ in snapshots_path.open("r", encoding="utf-8"))
if snapshot_count != expected_snapshot_count:
    raise RuntimeError(f"expected {expected_snapshot_count} snapshots, wrote {snapshot_count}")

manifest = {
    "run_id": run_id,
    "created_at": created_at,
    "script_version": script_version,
    "repo_root": repo_root,
    "steam_root": steam_root,
    "fixture_id": fixture_id,
    "scenario_id": scenario_id,
    "requested_game_seconds": requested_game_seconds,
    "sample_every_game_seconds": sample_every_game_seconds,
    "speed_multiplier": speed_multiplier,
    "debug_tick_seconds_per_sample": debug_tick_seconds_per_sample,
    "snapshot_count": snapshot_count,
    "events_written": events_written,
    "stress_signal_sample_count": stress_lines_written,
    "state_schema_version": last_state.get("schema_version", ""),
    "runtime_schema_version": (last_state.get("debug", {}) or {}).get("runtime_schema_version", ""),
    "output_files": {
        "manifest": "manifest.json",
        "snapshots": "snapshots.jsonl",
        "events": "events.jsonl",
        "stress_signals": "stress_signals.jsonl",
        "final_state": "final_state.json",
        "run_log": "run.log",
    },
    "command_line": command_line,
    "setup_actions": setup_actions,
    "dispatch_confirmation_proof": dispatch_proof,
    "first_day_mvp_proof": first_day_proof,
    "exit_status": "success",
    "known_warnings": known_warnings,
}
manifest_path.write_text(json.dumps(manifest, ensure_ascii=False, indent=2), encoding="utf-8")
append_log(f"Capture complete: {snapshot_count} snapshots, {events_written} events")
print(str(output_dir))
PY

        if [[ "$workbench_keep_running" == "true" ]] && [[ "$workbench_started_godot" == "true" ]]; then
            disown "$workbench_godot_pid" 2>/dev/null || true
            echo "workbench-capture left Godot running as pid $workbench_godot_pid"
        fi
        echo "workbench-capture output: $workbench_output_dir_abs"
        ;;
    capture)
        rm -rf "$CAPTURE_DIR/captures/screenshots" "$CAPTURE_DIR/captures/video/vertical_slice_full_loop_short_frames" "$CAPTURE_DIR/captures/logs"
        exec "$GODOT_BIN" --path "$ROOT_DIR" --scene res://scenes/prototypes/vertical_slice/vertical_slice_demo.tscn -- --vertical-capture --vertical-capture-dir="$CAPTURE_DIR"
        ;;
    capture-smoke)
        rm -rf "$SMOKE_CAPTURE_DIR"
        "$GODOT_BIN" --path "$ROOT_DIR" --scene res://scenes/prototypes/vertical_slice/vertical_slice_demo.tscn -- --vertical-capture-smoke --vertical-capture-dir="$SMOKE_CAPTURE_DIR"
        png_count="$(find "$SMOKE_CAPTURE_DIR/captures" -name '*.png' -type f 2>/dev/null | wc -l | tr -d ' ')"
        if [[ "$png_count" -lt 3 ]]; then
            echo "capture-smoke expected at least 3 PNG files, found $png_count" >&2
            exit 1
        fi
        rm -rf "$SMOKE_CAPTURE_DIR"
        echo "capture-smoke wrote $png_count PNG files in a temporary capture directory"
        ;;
    *)
        echo "Usage: tools/dev-vertical-slice.sh [interactive|all|qa|player-prototype|perf|normal|autoplay|connector|connector-control|connector-tunnel|connector-control-tunnel|smoke|connector-smoke|connector-control-smoke|runtime-foundation-smoke|workbench-capture|capture|capture-smoke] [--runtime-load-fixture=name|--runtime-load-save]" >&2
        exit 2
        ;;
esac
