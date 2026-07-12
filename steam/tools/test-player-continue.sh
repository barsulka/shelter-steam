#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEFAULT_GODOT_BIN="$HOME/Library/Application Support/Steam/steamapps/common/Godot Engine/Godot.app/Contents/MacOS/Godot"
GODOT_BIN="${GODOT_BIN:-$DEFAULT_GODOT_BIN}"
RUN_ID="${PLAYER_CONTINUE_TEST_RUN_ID:-r48-02b-$$}"
RUN_ROOT="user://player-tests/$RUN_ID"
LOG_FILES=()

if [[ ! "$RUN_ID" =~ ^[A-Za-z0-9][A-Za-z0-9._-]*$ ]] || [[ "$RUN_ID" == "." || "$RUN_ID" == ".." ]]; then
    echo "Invalid isolated player-continue test run id: $RUN_ID" >&2
    exit 1
fi
if [[ ! -x "$GODOT_BIN" ]]; then
    echo "Godot binary not found or not executable: $GODOT_BIN" >&2
    exit 1
fi

cleanup() {
    local code=$?
    trap - EXIT
    set +e
    local log
    log="$(mktemp -t shelter-continue-cleanup.XXXXXX.log)"
    "$GODOT_BIN" --headless --path "$ROOT_DIR" \
        --scene res://tests/player_continue/player_continue_test_runner.tscn -- \
        --continue-test-phase=cleanup --continue-test-base="$RUN_ROOT" >"$log" 2>&1
    if ! rg -q '^player_continue_test=passed phase=cleanup sequence=1$' "$log"; then
        cat "$log" >&2
        [[ $code -ne 0 ]] || code=1
    fi
    rm -f -- "$log" "${LOG_FILES[@]:-}"
    exit "$code"
}
trap 'exit 130' INT TERM
trap cleanup EXIT

run_phase() {
    local phase="$1"
    local base="$2"
    local sequence="$3"
    local log
    log="$(mktemp -t shelter-continue-${phase}.XXXXXX.log)"
    LOG_FILES+=("$log")
    "$GODOT_BIN" --headless --path "$ROOT_DIR" \
        --scene res://tests/player_continue/player_continue_test_runner.tscn -- \
        --continue-test-phase="$phase" --continue-test-base="$base" \
        --continue-test-sequence="$sequence" >"$log" 2>&1
    local error_lines
    error_lines="$(rg -n 'SCRIPT ERROR|Parse Error|ERROR:' "$log" || true)"
    if [[ "$phase" == "automatic-save-retry" || "$phase" == "retry-cursor" ]]; then
        error_lines="$(printf '%s\n' "$error_lines" \
            | rg -v 'ERROR: Player checkpoint commit failed after task:' || true)"
    fi
    if ! rg -q "^player_continue_test=passed phase=$phase sequence=$sequence$" "$log" \
        || [[ -n "$error_lines" ]]; then
        cat "$log" >&2
        exit 1
    fi
}

for sequence in $(seq 1 33); do
    base="$RUN_ROOT/cursor-$sequence"
    run_phase write "$base" "$sequence"
    run_phase read "$base" "$sequence"
    if [[ "$sequence" == 17 ]]; then
        run_phase read "$base" 18
    elif [[ "$sequence" == 1 || "$sequence" == 13 || "$sequence" == 15 || "$sequence" == 18 || "$sequence" == 30 || "$sequence" == 32 || "$sequence" == 33 ]]; then
        run_phase read "$base" "$sequence"
    fi
    run_phase advance "$base" "$( [[ "$sequence" == 17 ]] && echo 18 || echo "$sequence" )"
done

for sequence in 2 3 4 5 6 7 8 9 10 11 12 14 16 19 20 21 22 23 24 25 26 27 28 29 31; do
    base="$RUN_ROOT/inflight-$sequence"
    log="$(mktemp -t shelter-continue-kill.XXXXXX.log)"
    LOG_FILES+=("$log")
    "$GODOT_BIN" --headless --path "$ROOT_DIR" \
        --scene res://tests/player_continue/player_continue_test_runner.tscn -- \
        --continue-test-phase=hold-inflight --continue-test-base="$base" \
        --continue-test-sequence="$sequence" >"$log" 2>&1 &
    pid=$!
    ready=0
    for _attempt in $(seq 1 200); do
        if rg -q "^player_continue_inflight_ready sequence=$sequence$" "$log"; then
            ready=1
            break
        fi
        if ! kill -0 "$pid" 2>/dev/null; then
            break
        fi
        sleep 0.05
    done
    if [[ $ready -ne 1 ]]; then
        cat "$log" >&2
        kill "$pid" 2>/dev/null || true
        wait "$pid" 2>/dev/null || true
        exit 1
    fi
    kill -9 "$pid"
    wait "$pid" 2>/dev/null || true
    run_phase advance "$base" "$sequence"
done

base="$RUN_ROOT/completion-beat-32"
run_phase write "$base" 32
log="$(mktemp -t shelter-continue-completion-beat-kill.XXXXXX.log)"
LOG_FILES+=("$log")
"$GODOT_BIN" --headless --path "$ROOT_DIR" \
    --scene res://tests/player_continue/player_continue_test_runner.tscn -- \
    --continue-test-phase=hold-completion-beat --continue-test-base="$base" \
    --continue-test-sequence=32 >"$log" 2>&1 &
pid=$!
ready=0
for _attempt in $(seq 1 200); do
    if rg -q '^player_continue_completion_beat_ready sequence=32$' "$log"; then
        ready=1
        break
    fi
    if ! kill -0 "$pid" 2>/dev/null; then
        break
    fi
    sleep 0.05
done
if [[ $ready -ne 1 ]]; then
    cat "$log" >&2
    kill "$pid" 2>/dev/null || true
    wait "$pid" 2>/dev/null || true
    exit 1
fi
kill -9 "$pid"
wait "$pid" 2>/dev/null || true
run_phase advance "$base" 32

for sequence in 1 13 15 17 18 25 30; do
    base="$RUN_ROOT/failed-barrier-$sequence"
    run_phase write "$base" "$sequence"
    log="$(mktemp -t shelter-continue-failed-barrier.XXXXXX.log)"
    LOG_FILES+=("$log")
    "$GODOT_BIN" --headless --path "$ROOT_DIR" \
        --scene res://tests/player_continue/player_continue_test_runner.tscn -- \
        --continue-test-phase=hold-failed-barrier --continue-test-base="$base" \
        --continue-test-sequence="$sequence" >"$log" 2>&1 &
    pid=$!
    ready=0
    for _attempt in $(seq 1 200); do
        if rg -q "^player_continue_failed_barrier_ready sequence=$sequence$" "$log"; then
            ready=1
            break
        fi
        if ! kill -0 "$pid" 2>/dev/null; then
            break
        fi
        sleep 0.05
    done
    if [[ $ready -ne 1 ]]; then
        cat "$log" >&2
        kill "$pid" 2>/dev/null || true
        wait "$pid" 2>/dev/null || true
        exit 1
    fi
    kill -9 "$pid"
    wait "$pid" 2>/dev/null || true
    run_phase read "$base" "$sequence"
done

run_phase recovery "$RUN_ROOT/recovery" 1
run_phase save-retry "$RUN_ROOT/save-retry" 1
run_phase automatic-save-retry "$RUN_ROOT/automatic-save-retry" 1
run_phase sequence-rules "$RUN_ROOT/sequence-rules" 1

for sequence in 17 18 25 30 31 32; do
    base="$RUN_ROOT/retry-$sequence"
    run_phase write "$base" "$sequence"
    run_phase retry-cursor "$base" "$sequence"
done

echo "player_continue_test=passed cursors=33 restart_advance_matrix=true forced_kill_matrix=true failed_barrier_restart_matrix=true"
