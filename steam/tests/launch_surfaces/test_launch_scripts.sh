#!/usr/bin/env bash
set -euo pipefail

STEAM_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
TMP_DIR="$(mktemp -d -t shelter-launch-surfaces.XXXXXX)"
trap 'rm -rf "$TMP_DIR"' EXIT

MOCK_BIN="$TMP_DIR/mock-command.sh"
cat >"$MOCK_BIN" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
printf '%s\n' "$@" >"$MOCK_ARGV_FILE"
exit "${MOCK_EXIT_CODE:-0}"
EOF
chmod +x "$MOCK_BIN"

assert_argv() {
    local expected_file="$1"
    if ! diff -u "$expected_file" "$MOCK_ARGV_FILE"; then
        echo "unexpected delegated argv" >&2
        exit 1
    fi
}

export MOCK_ARGV_FILE="$TMP_DIR/argv.txt"

GODOT_BIN="$MOCK_BIN" "$STEAM_DIR/play.sh"
cat >"$TMP_DIR/expected.txt" <<EOF
--path
$STEAM_DIR
EOF
assert_argv "$TMP_DIR/expected.txt"

rm -f "$MOCK_ARGV_FILE"
if GODOT_BIN="$MOCK_BIN" "$STEAM_DIR/play.sh" --runtime-load-fixture=second_day_after_first_delivery >/dev/null 2>&1; then
    echo "play.sh unexpectedly accepted a developer argument" >&2
    exit 1
fi
if [[ -e "$MOCK_ARGV_FILE" ]]; then
    echo "play.sh invoked Godot after rejecting a developer argument" >&2
    exit 1
fi

set +e
MOCK_EXIT_CODE=23 GODOT_BIN="$MOCK_BIN" "$STEAM_DIR/play.sh" >/dev/null 2>&1
play_status=$?
set -e
if [[ "$play_status" -ne 23 ]]; then
    echo "play.sh did not return the Godot child status" >&2
    exit 1
fi

SHELTER_DEV_VERTICAL_SLICE="$MOCK_BIN" SHELTER_LEGACY_LAUNCH="$MOCK_BIN" "$STEAM_DIR/dev.sh"
printf 'player-prototype\n' >"$TMP_DIR/expected.txt"
assert_argv "$TMP_DIR/expected.txt"

SHELTER_DEV_VERTICAL_SLICE="$MOCK_BIN" SHELTER_LEGACY_LAUNCH="$MOCK_BIN" "$STEAM_DIR/dev.sh" qa --vertical-normal
printf 'qa\n--vertical-normal\n' >"$TMP_DIR/expected.txt"
assert_argv "$TMP_DIR/expected.txt"

SHELTER_DEV_VERTICAL_SLICE="$MOCK_BIN" SHELTER_LEGACY_LAUNCH="$MOCK_BIN" "$STEAM_DIR/dev.sh" day2
printf 'player-prototype\n--runtime-load-fixture=second_day_after_first_delivery\n' >"$TMP_DIR/expected.txt"
assert_argv "$TMP_DIR/expected.txt"

SHELTER_DEV_VERTICAL_SLICE="$MOCK_BIN" SHELTER_LEGACY_LAUNCH="$MOCK_BIN" "$STEAM_DIR/dev.sh" connector --url
printf '%s\n' '--url' >"$TMP_DIR/expected.txt"
assert_argv "$TMP_DIR/expected.txt"

SHELTER_DEV_VERTICAL_SLICE="$MOCK_BIN" SHELTER_LEGACY_LAUNCH="$MOCK_BIN" "$STEAM_DIR/dev.sh" capture --scenario=first_delivery_from_empty
printf 'workbench-capture\n--scenario=first_delivery_from_empty\n' >"$TMP_DIR/expected.txt"
assert_argv "$TMP_DIR/expected.txt"

SHELTER_DEV_VERTICAL_SLICE="$MOCK_BIN" SHELTER_LEGACY_LAUNCH="$MOCK_BIN" "$STEAM_DIR/dev.sh" smoke
printf 'smoke\n' >"$TMP_DIR/expected.txt"
assert_argv "$TMP_DIR/expected.txt"

if SHELTER_DEV_VERTICAL_SLICE="$MOCK_BIN" SHELTER_LEGACY_LAUNCH="$MOCK_BIN" "$STEAM_DIR/dev.sh" unknown >/dev/null 2>&1; then
    echo "dev.sh unexpectedly accepted an unknown mode" >&2
    exit 1
fi

echo "launch script routing tests passed"
