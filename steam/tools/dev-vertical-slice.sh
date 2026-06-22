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
        echo "Usage: tools/dev-vertical-slice.sh [interactive|all|qa|player-prototype|perf|normal|autoplay|connector|connector-control|connector-tunnel|connector-control-tunnel|smoke|connector-smoke|connector-control-smoke|runtime-foundation-smoke|capture|capture-smoke] [--runtime-load-fixture=name|--runtime-load-save]" >&2
        exit 2
        ;;
esac
