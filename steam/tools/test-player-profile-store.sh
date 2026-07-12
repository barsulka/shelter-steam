#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEFAULT_GODOT_BIN="$HOME/Library/Application Support/Steam/steamapps/common/Godot Engine/Godot.app/Contents/MacOS/Godot"
GODOT_BIN="${GODOT_BIN:-$DEFAULT_GODOT_BIN}"
RUN_ID="${PLAYER_PROFILE_TEST_RUN_ID:-r48-02a-$$}"
RUN_ROOT="user://player-tests/$RUN_ID"
FULL_BASE="$RUN_ROOT/full"
RESTART_BASE="$RUN_ROOT/restart"
KILL_BASE_PREFIX="$RUN_ROOT/kill"
OWN_RUN_ROOT=0
LOG_FILES=()

if [[ ! "$RUN_ID" =~ ^[A-Za-z0-9][A-Za-z0-9._-]*$ ]] || [[ "$RUN_ID" == "." || "$RUN_ID" == ".." ]]; then
    echo "Invalid isolated player-profile test run id: $RUN_ID" >&2
    exit 1
fi

if [[ ! -x "$GODOT_BIN" ]]; then
    echo "Godot binary not found or not executable: $GODOT_BIN" >&2
    exit 1
fi

cleanup_on_exit() {
    local exit_code=$?
    trap - EXIT
    set +e
    if [[ $OWN_RUN_ROOT -eq 1 ]]; then
        local cleanup_log
        cleanup_log="$(mktemp -t shelter-profile-cleanup.XXXXXX.log)"
        LOG_FILES+=("$cleanup_log")
        "$GODOT_BIN" --headless --path "$ROOT_DIR" \
            --scene res://tests/persistence/player_profile_store_test_runner.tscn -- \
            --persistence-test-phase=cleanup \
            --persistence-test-base="$RUN_ROOT" >"$cleanup_log" 2>&1
        local cleanup_status=$?
        if [[ $cleanup_status -ne 0 ]] \
            || ! rg -q '^player_profile_store_test=passed phase=cleanup$' "$cleanup_log" \
            || rg -n 'SCRIPT ERROR|Parse Error|ERROR:' "$cleanup_log" >/dev/null; then
            cat "$cleanup_log" >&2
            echo "Failed to clean exact owned player-profile test root: $RUN_ROOT" >&2
            if [[ $exit_code -eq 0 ]]; then
                exit_code=1
            fi
        fi
    fi
    if [[ ${#LOG_FILES[@]} -gt 0 ]]; then
        rm -f -- "${LOG_FILES[@]}"
    fi
    exit "$exit_code"
}

trap 'exit 130' INT TERM
trap cleanup_on_exit EXIT

run_phase() {
    local phase="$1"
    local base="$2"
    local log_file="$3"
    local failpoint="${4:-}"
    local expected_status="${5:-}"
    local -a args=(
        --headless --path "$ROOT_DIR"
        --scene res://tests/persistence/player_profile_store_test_runner.tscn --
        --persistence-test-phase="$phase"
        --persistence-test-base="$base"
    )
    if [[ -n "$failpoint" ]]; then
        args+=(--persistence-test-failpoint="$failpoint")
    fi
    if [[ -n "$expected_status" ]]; then
        args+=(--persistence-test-expected-status="$expected_status")
    fi
    "$GODOT_BIN" "${args[@]}" >"$log_file" 2>&1
    if ! rg -q "^player_profile_store_test=passed phase=$phase$" "$log_file"; then
        cat "$log_file" >&2
        exit 1
    fi
    if rg -n 'SCRIPT ERROR|Parse Error|ERROR:' "$log_file" >/dev/null; then
        cat "$log_file" >&2
        exit 1
    fi
}

run_killed_update() {
    local failpoint="$1"
    local base="$KILL_BASE_PREFIX-$failpoint"
    local baseline_log
    local kill_log
    local inspect_log
    baseline_log="$(mktemp -t shelter-profile-kill-baseline.XXXXXX.log)"
    kill_log="$(mktemp -t shelter-profile-kill-update.XXXXXX.log)"
    inspect_log="$(mktemp -t shelter-profile-kill-inspect.XXXXXX.log)"
    LOG_FILES+=("$baseline_log" "$kill_log" "$inspect_log")

    run_phase kill-baseline "$base" "$baseline_log"
    set +e
    "$GODOT_BIN" --headless --path "$ROOT_DIR" \
        --scene res://tests/persistence/player_profile_store_test_runner.tscn -- \
        --persistence-test-phase=kill-update \
        --persistence-test-base="$base" \
        --persistence-test-failpoint="$failpoint" >"$kill_log" 2>&1
    local kill_status=$?
    set -e
    if [[ $kill_status -ne 137 ]] || rg -n 'SCRIPT ERROR|Parse Error|ERROR:' "$kill_log" >/dev/null; then
        cat "$kill_log" >&2
        echo "Expected clean SIGKILL reach at failpoint: $failpoint (status=$kill_status)" >&2
        rm -f "$baseline_log" "$kill_log" "$inspect_log"
        exit 1
    fi
    run_phase kill-inspect "$base" "$inspect_log" "$failpoint"
    rm -f "$baseline_log" "$kill_log" "$inspect_log"
}

run_killed_create() {
    local failpoint="$1"
    local expected_status="$2"
    local base="$KILL_BASE_PREFIX-create-$failpoint"
    local kill_log
    local inspect_log
    kill_log="$(mktemp -t shelter-profile-kill-create.XXXXXX.log)"
    inspect_log="$(mktemp -t shelter-profile-kill-create-inspect.XXXXXX.log)"
    LOG_FILES+=("$kill_log" "$inspect_log")

    set +e
    "$GODOT_BIN" --headless --path "$ROOT_DIR" \
        --scene res://tests/persistence/player_profile_store_test_runner.tscn -- \
        --persistence-test-phase=kill-create \
        --persistence-test-base="$base" \
        --persistence-test-failpoint="$failpoint" >"$kill_log" 2>&1
    local kill_status=$?
    set -e
    if [[ $kill_status -ne 137 ]] || rg -n 'SCRIPT ERROR|Parse Error|ERROR:' "$kill_log" >/dev/null; then
        cat "$kill_log" >&2
        echo "Expected clean create SIGKILL reach at failpoint: $failpoint (status=$kill_status)" >&2
        rm -f "$kill_log" "$inspect_log"
        exit 1
    fi
    run_phase kill-inspect "$base" "$inspect_log" "$failpoint" "$expected_status"
    rm -f "$kill_log" "$inspect_log"
}

full_log="$(mktemp -t shelter-profile-store-full.XXXXXX.log)"
write_log="$(mktemp -t shelter-profile-store-write.XXXXXX.log)"
read_log="$(mktemp -t shelter-profile-store-read.XXXXXX.log)"
preflight_log="$(mktemp -t shelter-profile-preflight.XXXXXX.log)"
cleanup_log="$(mktemp -t shelter-profile-cleanup.XXXXXX.log)"
absent_log="$(mktemp -t shelter-profile-absent.XXXXXX.log)"
LOG_FILES+=("$full_log" "$write_log" "$read_log" "$preflight_log" "$cleanup_log" "$absent_log")

# Claim only a fresh exact run-id root. A caller-selected existing root is never
# treated as ours and therefore is never deleted by the trap.
run_phase assert-absent "$RUN_ROOT" "$preflight_log"
OWN_RUN_ROOT=1

run_phase full "$FULL_BASE" "$full_log"
run_phase restart-write "$RESTART_BASE" "$write_log"
run_phase restart-read "$RESTART_BASE" "$read_log"

run_killed_create before_validation no_valid_profile
run_killed_create after_temp_write no_valid_profile
run_killed_create after_temp_flush temp_available
run_killed_create after_temp_readback temp_available
run_killed_create after_primary_promotion primary_available

for failpoint in \
    before_validation \
    after_temp_write \
    after_temp_flush \
    after_temp_readback \
    after_backup_write \
    after_primary_remove \
    after_primary_promotion; do
    run_killed_update "$failpoint"
done

run_phase cleanup "$RUN_ROOT" "$cleanup_log"
run_phase assert-absent "$RUN_ROOT" "$absent_log"
OWN_RUN_ROOT=0

echo "player profile store tests passed (full + restart + killed create/update matrices)"
