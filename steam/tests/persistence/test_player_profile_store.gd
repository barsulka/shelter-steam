extends Node

const PlayerProfileSchema := preload("res://scripts/persistence/player_profile_schema.gd")
const PlayerProfileStore := preload("res://scripts/persistence/player_profile_store.gd")

var _schema := PlayerProfileSchema.new()
var _failures: Array[String] = []
var _base_dir := "user://player-tests/r48-02a-default"
var _phase := "full"
var _failpoint := ""
var _expected_status := ""


func _ready() -> void:
    _read_args()
    _run.call_deferred()


func _run() -> void:
    if not _is_safe_test_path(_base_dir):
        _fail("test base is outside isolated prefix")
        _finish()
        return
    var global_test := ProjectSettings.globalize_path(_base_dir).simplify_path()
    var global_production := ProjectSettings.globalize_path(PlayerProfileStore.PRODUCTION_BASE_DIR).simplify_path()
    if global_test == global_production or global_test.begins_with(global_production + "/"):
        _fail("test base overlaps production profile")
        _finish()
        return

    match _phase:
        "restart-write":
            _clean_base()
            var store := PlayerProfileStore.new(_base_dir, true)
            _expect_ok(store.store_profile(_fields(91), PlayerProfileStore.CREATE_AUTHORITY), "restart write")
        "restart-read":
            var store := PlayerProfileStore.new(_base_dir, true)
            var inspection := store.inspect_profile_candidates()
            _expect(str(inspection.get("status", "")) == "primary_available", "restart read selects primary")
            var loaded := store.load_profile_candidate("primary")
            _expect_ok(loaded, "restart read load")
            if bool(loaded.get("ok", false)):
                _expect(int((loaded["envelope"] as Dictionary).get("checkpoint_sequence", -1)) == 91, "restart sequence survives process")
            _clean_base()
        "cleanup":
            _clean_base()
        "assert-absent":
            _expect(not DirAccess.dir_exists_absolute(ProjectSettings.globalize_path(_base_dir)), "exact test run root is absent")
        "kill-baseline":
            _clean_base()
            var store := PlayerProfileStore.new(_base_dir, true)
            _expect_ok(store.store_profile(_fields(92), PlayerProfileStore.CREATE_AUTHORITY), "kill baseline write")
        "kill-update":
            var store := PlayerProfileStore.new(_base_dir, true)
            _expect(_failpoint != "", "kill update requires a failpoint")
            _expect_ok(store.configure_test_failpoint(_failpoint, true), "configure terminating failpoint")
            store.store_profile(_fields(93), PlayerProfileStore.UPDATE_AUTHORITY)
            _fail("terminating failpoint returned to test runner")
        "kill-create":
            _clean_base()
            var store := PlayerProfileStore.new(_base_dir, true)
            _expect(_failpoint != "", "kill create requires a failpoint")
            _expect_ok(store.configure_test_failpoint(_failpoint, true), "configure terminating create failpoint")
            store.store_profile(_fields(94), PlayerProfileStore.CREATE_AUTHORITY)
            _fail("terminating create failpoint returned to test runner")
        "kill-inspect":
            var store := PlayerProfileStore.new(_base_dir, true)
            _expect(_failpoint != "", "kill inspection requires expected failpoint")
            var marker_path := "%s/%s" % [_base_dir, PlayerProfileStore.TEST_FAILPOINT_MARKER]
            _expect(FileAccess.file_exists(marker_path), "terminating failpoint wrote reach marker")
            if FileAccess.file_exists(marker_path):
                _expect(FileAccess.get_file_as_string(marker_path) == _failpoint, "reach marker identifies exact named failpoint")
            var inspection := store.inspect_profile_candidates()
            if _expected_status != "":
                _expect(str(inspection.get("status", "")) == _expected_status, "killed transaction has expected deterministic status")
            else:
                _expect(str(inspection.get("selected_source", "")) != "", "valid profile candidate survives killed update")
            if str(inspection.get("selected_source", "")) != "":
                _expect_ok(store.load_profile_candidate(str(inspection["selected_source"])), "surviving candidate loads after killed update")
            _clean_base()
        _:
            _clean_base()
            _test_schema_and_canonical_bytes()
            _test_schema_rejections()
            _test_store_matrix()
            _test_recovery_matrix()
            _test_failure_matrix()
            _test_quarantine_retention()
            _clean_base()
    _finish()


func _test_schema_and_canonical_bytes() -> void:
    var canonical := _schema.canonicalize({
        "€": "Euro Sign",
        "\r": "Carriage Return",
        "דּ": "Hebrew Letter Dalet With Dagesh",
        "1": "One",
        "😀": "Emoji: Grinning Face",
        "\u0080": "Control",
        "ö": "Latin Small Letter O With Diaeresis",
    })
    _expect_ok(canonical, "UTF-16 key canonicalization")
    _expect(
        str(canonical.get("json", "")) == "{\"\\r\":\"Carriage Return\",\"1\":\"One\",\"\":\"Control\",\"ö\":\"Latin Small Letter O With Diaeresis\",\"€\":\"Euro Sign\",\"😀\":\"Emoji: Grinning Face\",\"דּ\":\"Hebrew Letter Dalet With Dagesh\"}",
        "keys sort by unsigned UTF-16 units"
    )

    var strings := _schema.canonicalize({"string": "€$\u000f\nA'B\"\\\\\"/"})
    _expect_ok(strings, "RFC string escaping")
    _expect(str(strings.get("json", "")) == "{\"string\":\"€$\\u000f\\nA'B\\\"\\\\\\\\\\\"/\"}", "RFC string escaping bytes")

    var integers := _schema.canonicalize({"max": PlayerProfileSchema.MAX_SAFE_INTEGER, "min": -PlayerProfileSchema.MAX_SAFE_INTEGER, "zero": 0})
    _expect_ok(integers, "integer boundaries")
    _expect(str(integers.get("json", "")) == "{\"max\":9007199254740991,\"min\":-9007199254740991,\"zero\":0}", "integer canonical spelling")

    var sealed := _schema.seal_envelope(_fields(1, {"count": 1, "nested": [true, null, "ok"]}))
    _expect_ok(sealed, "seal envelope")
    if bool(sealed.get("ok", false)):
        var raw := str(sealed["json"])
        _expect(not raw.ends_with("\n"), "sealed bytes have no trailing newline")
        _expect(raw.to_utf8_buffer() == sealed["bytes"], "sealed bytes are exact UTF-8")
        var decoded := _schema.decode_and_validate_bytes(sealed["bytes"] as PackedByteArray)
        _expect_ok(decoded, "sealed envelope round trip")
        var integrity := (sealed["envelope"] as Dictionary)["integrity"] as Dictionary
        _expect(str(integrity["algorithm"]) == "sha256", "integrity algorithm")
        _expect(str(integrity["digest"]).length() == 64, "integrity digest length")
        _expect(str(integrity["digest"]) == "6762afe8205b129400aa8fe060c5597d870f49de953fc4785fd4d23c268743ba", "top-level integrity omission golden digest")


func _test_schema_rejections() -> void:
    _expect(not bool(_schema.canonicalize({"float": 1.0}).get("ok", true)), "programmatic float rejected")
    _expect(not bool(_schema.canonicalize({"large": PlayerProfileSchema.MAX_SAFE_INTEGER + 1}).get("ok", true)), "unsafe integer rejected")
    _expect(not bool(_schema.seal_envelope(_fields(2, {"nested": {"connector_token": "secret"}})).get("ok", true)), "forbidden token key rejected")
    _expect(not bool(_schema.seal_envelope(_fields(2, {"nested": {"external_url": "https://example.invalid"}})).get("ok", true)), "URL suffix rejected")

    var unknown := _fields(2)
    unknown["unexpected"] = true
    _expect(not bool(_schema.seal_envelope(unknown).get("ok", true)), "unknown outer field rejected")
    var missing := _fields(2)
    missing.erase("checkpoint_kind")
    _expect(not bool(_schema.seal_envelope(missing).get("ok", true)), "missing required field rejected")

    var deep: Variant = {"value": 1}
    for _index in range(PlayerProfileSchema.MAX_DEPTH + 2):
        deep = {"next": deep}
    _expect(not bool(_schema.seal_envelope(_fields(2, deep as Dictionary)).get("ok", true)), "depth bound enforced")

    var too_many: Array = []
    too_many.resize(PlayerProfileSchema.MAX_CONTAINER_ENTRIES + 1)
    too_many.fill(0)
    _expect(not bool(_schema.seal_envelope(_fields(2, {"many": too_many})).get("ok", true)), "container bound enforced")

    var oversized_string := "x".repeat(PlayerProfileSchema.MAX_STRING_BYTES + 1)
    _expect(not bool(_schema.seal_envelope(_fields(2, {"text": oversized_string})).get("ok", true)), "string bound enforced")
    var file_size_payload := {
        "a": "a".repeat(220_000),
        "b": "b".repeat(220_000),
        "c": "c".repeat(220_000),
        "d": "d".repeat(220_000),
        "e": "e".repeat(220_000),
    }
    _expect(not bool(_schema.seal_envelope(_fields(2, file_size_payload)).get("ok", true)), "complete file size bound enforced")

    var node_groups: Array = []
    for _group_index in range(13):
        var group: Array = []
        group.resize(4_000)
        group.fill(0)
        node_groups.append(group)
    _expect(not bool(_schema.seal_envelope(_fields(2, {"groups": node_groups})).get("ok", true)), "total node bound enforced")

    var sealed := _schema.seal_envelope(_fields(3))
    _expect_ok(sealed, "raw rejection baseline")
    if not bool(sealed.get("ok", false)):
        return
    var raw := str(sealed["json"])
    for replacement in ["1.0", "1e0", "01", "-0", "+1"]:
        var altered := raw.replace("\"schema_version\":1", "\"schema_version\":%s" % replacement)
        _expect(not bool(_schema.decode_and_validate_text(altered).get("ok", true)), "numeric spelling rejected: %s" % replacement)
    _expect(not bool(_schema.decode_and_validate_text(raw + "\n").get("ok", true)), "whitespace rejected")
    _expect(not bool(_schema.decode_and_validate_text(raw.left(-1) + ",}").get("ok", true)), "trailing comma rejected")
    var duplicate := raw.replace("\"profile_id\":\"default\"", "\"profile_id\":\"default\",\"profile_id\":\"default\"")
    _expect(not bool(_schema.decode_and_validate_text(duplicate).get("ok", true)), "duplicate property rejected by canonical round trip")
    for escaped_unicode in ["\\ud800", "\\udc00", "\\ud800\\u0041"]:
        var malformed_unicode := raw.replace("\"content_build_version\":\"build-test\"", "\"content_build_version\":\"%s\"" % escaped_unicode)
        _expect(not bool(_schema.decode_and_validate_text(malformed_unicode).get("ok", true)), "unpaired UTF-16 surrogate rejected: %s" % escaped_unicode)

    var invalid_utf8 := sealed["bytes"] as PackedByteArray
    var marker := raw.find("build-test")
    if marker >= 0:
        invalid_utf8[marker] = 0xFF
        _expect(str(_schema.decode_and_validate_bytes(invalid_utf8).get("error", "")) == "invalid_utf8", "invalid UTF-8 rejected")

    var future := raw.replace("\"schema_version\":1", "\"schema_version\":2")
    var future_result := _schema.decode_and_validate_text(future)
    _expect(str(future_result.get("classification", "")) == "incompatible", "future schema classified incompatible")
    var malformed_future := raw.replace("\"schema_version\":1", "\"schema_version\":2.0")
    _expect(str(_schema.decode_and_validate_text(malformed_future).get("classification", "")) == "corrupt", "non-integer future spelling is corrupt, not terminal incompatible")
    var duplicate_future := raw.replace("\"schema_version\":1", "\"schema_version\":1,\"schema_version\":2")
    _expect(str(_schema.decode_and_validate_text(duplicate_future).get("classification", "")) == "corrupt", "duplicate future identity is corrupt, not terminal incompatible")


func _test_store_matrix() -> void:
    _reset_store()
    var store := PlayerProfileStore.new(_base_dir, true)
    var absent := store.inspect_profile_candidates()
    _expect(str(absent.get("status", "")) == "no_valid_profile", "absent profile explicit")
    _expect(not store.has_valid_envelope(), "absent envelope false")
    _expect(not bool(PlayerProfileStore.new(PlayerProfileStore.PRODUCTION_BASE_DIR, true).inspect_profile_candidates().get("ok", true)), "test mode rejects production path")
    _expect(not bool(PlayerProfileStore.new("user://another-profile", false).inspect_profile_candidates().get("ok", true)), "production mode rejects non-default namespace")
    _expect(not bool(PlayerProfileStore.new("user://player-tests/../../escaped-profile", true).inspect_profile_candidates().get("ok", true)), "test mode rejects canonical traversal escape")

    _expect_ok(store.store_profile(_fields(10), PlayerProfileStore.CREATE_AUTHORITY), "first save")
    _expect(str(store.inspect_profile_candidates().get("status", "")) == "primary_available", "valid primary selected")
    var loaded := store.load_profile_candidate("primary")
    _expect_ok(loaded, "valid primary load")
    _expect(bool(loaded.get("envelope_valid", false)), "envelope validity reported")
    _expect(not bool(loaded.get("checkpoint_contract_valid", true)), "checkpoint contract not claimed")
    _expect(not bool(loaded.get("playable_profile", true)), "playable profile not claimed")

    var paths := store.paths()
    var before_bytes := FileAccess.get_file_as_bytes(str(paths["primary"]))
    var before_time := FileAccess.get_modified_time(str(paths["primary"]))
    store.inspect_profile_candidates()
    store.load_profile_candidate("primary")
    _expect(FileAccess.get_file_as_bytes(str(paths["primary"])) == before_bytes, "inspection/load do not mutate bytes")
    _expect(FileAccess.get_modified_time(str(paths["primary"])) == before_time, "inspection/load do not mutate timestamp")

    _write_text(str(paths["backup"]), "broken-backup")
    _write_text(str(paths["temp"]), "broken-temp")
    var warned := store.inspect_profile_candidates()
    _expect(str(warned.get("status", "")) == "primary_available", "valid primary overrides invalid backup/temp")
    _expect((warned.get("warnings", []) as Array).size() == 2, "invalid backup/temp reported as warnings")

    _expect_ok(store.store_profile(_fields(11), PlayerProfileStore.UPDATE_AUTHORITY), "update valid profile")
    var primary_loaded := store.load_profile_candidate("primary")
    var backup_loaded := store.load_profile_candidate("backup")
    _expect(int((primary_loaded.get("envelope", {}) as Dictionary).get("checkpoint_sequence", -1)) == 11, "updated primary sequence")
    _expect(int((backup_loaded.get("envelope", {}) as Dictionary).get("checkpoint_sequence", -1)) == 10, "backup is previous valid primary")

    _reset_store()
    store = PlayerProfileStore.new(_base_dir, true)
    paths = store.paths()
    _write_valid(str(paths["temp"]), _fields(12))
    _expect(not bool(store.store_profile(_fields(13), PlayerProfileStore.CREATE_AUTHORITY).get("ok", true)), "create does not overwrite recoverable temp")
    _expect(str(store.inspect_profile_candidates().get("status", "")) == "temp_available", "recoverable temp remains selected")


func _test_recovery_matrix() -> void:
    _reset_store()
    var store := PlayerProfileStore.new(_base_dir, true)
    var paths := store.paths()
    _write_valid(str(paths["backup"]), _fields(20))
    var backup_only := store.inspect_profile_candidates()
    _expect(str(backup_only.get("status", "")) == "backup_available", "absent primary selects backup read-only")
    _expect(FileAccess.file_exists(str(paths["backup"])), "backup inspection preserves file")

    _write_text(str(paths["primary"]), "corrupt connector_token https://secret.invalid")
    var corrupt_primary := store.inspect_profile_candidates()
    _expect(str(corrupt_primary.get("status", "")) == "backup_available", "corrupt primary selects backup")
    _expect_ok(store.recover_profile_candidate("backup", PlayerProfileStore.RECOVERY_AUTHORITY), "recover backup")
    _expect(str(store.inspect_profile_candidates().get("status", "")) == "primary_available", "backup recovery promotes primary")
    _assert_quarantine_safe(str(paths["quarantine"]))

    _reset_store()
    store = PlayerProfileStore.new(_base_dir, true)
    paths = store.paths()
    _write_valid(str(paths["backup"]), _fields(21))
    _write_future(str(paths["primary"]), _fields(22))
    _write_valid(str(paths["temp"]), _fields(220))
    var incompatible_primary := store.inspect_profile_candidates()
    _expect(str(incompatible_primary.get("status", "")) == "incompatible_primary", "future primary is terminal")
    _expect(bool(incompatible_primary.get("temp_available", false)), "future primary reports temp metadata without selecting it")
    _expect(not bool(store.recover_profile_candidate("backup", PlayerProfileStore.RECOVERY_AUTHORITY).get("ok", true)), "future primary not silently downgraded")

    _reset_store()
    store = PlayerProfileStore.new(_base_dir, true)
    paths = store.paths()
    _write_text(str(paths["primary"]), "corrupt")
    _write_text(str(paths["backup"]), "also-corrupt")
    _write_valid(str(paths["temp"]), _fields(23))
    var temp_selected := store.inspect_profile_candidates()
    _expect(str(temp_selected.get("status", "")) == "temp_available", "valid temp selected after corrupt primary/backup")
    _expect_ok(store.recover_profile_candidate("temp", PlayerProfileStore.RECOVERY_AUTHORITY), "recover temp")
    _expect(str(store.inspect_profile_candidates().get("status", "")) == "primary_available", "temp recovery promotes primary")

    _reset_store()
    store = PlayerProfileStore.new(_base_dir, true)
    paths = store.paths()
    _write_text(str(paths["primary"]), "corrupt")
    _write_future(str(paths["backup"]), _fields(24))
    _write_valid(str(paths["temp"]), _fields(25))
    _expect(str(store.inspect_profile_candidates().get("status", "")) == "incompatible_backup", "incompatible backup blocks temp")

    _reset_store()
    store = PlayerProfileStore.new(_base_dir, true)
    paths = store.paths()
    _write_text(str(paths["primary"]), "bad")
    _write_text(str(paths["backup"]), "bad")
    _write_text(str(paths["temp"]), "bad")
    _expect(str(store.inspect_profile_candidates().get("status", "")) == "no_valid_profile", "all invalid is explicit no valid profile")


func _test_failure_matrix() -> void:
    var first_save_expectations := {
        "before_validation": "no_valid_profile",
        "after_temp_write": "temp_available",
        "after_temp_flush": "temp_available",
        "after_temp_readback": "temp_available",
        "after_primary_promotion": "primary_available",
    }
    for failpoint in first_save_expectations.keys():
        _reset_store()
        var first_store := PlayerProfileStore.new(_base_dir, true)
        _expect_ok(first_store.configure_test_failpoint(str(failpoint)), "configure first-save failpoint")
        var first_result := first_store.store_profile(_fields(29), PlayerProfileStore.CREATE_AUTHORITY)
        _expect(not bool(first_result.get("ok", true)), "first-save failpoint triggers: %s" % failpoint)
        var first_inspection := PlayerProfileStore.new(_base_dir, true).inspect_profile_candidates()
        _expect(str(first_inspection.get("status", "")) == str(first_save_expectations[failpoint]), "first-save deterministic result: %s" % failpoint)

    var failpoints := [
        "before_validation",
        "after_temp_write",
        "after_temp_flush",
        "after_temp_readback",
        "after_backup_write",
        "after_primary_remove",
        "after_primary_promotion",
    ]
    for failpoint in failpoints:
        _reset_store()
        var store := PlayerProfileStore.new(_base_dir, true)
        _expect_ok(store.store_profile(_fields(30), PlayerProfileStore.CREATE_AUTHORITY), "failure baseline %s" % failpoint)
        _expect_ok(store.configure_test_failpoint(failpoint), "configure failpoint %s" % failpoint)
        var result := store.store_profile(_fields(31), PlayerProfileStore.UPDATE_AUTHORITY)
        _expect(not bool(result.get("ok", true)), "failpoint triggers: %s" % failpoint)
        var inspection := PlayerProfileStore.new(_base_dir, true).inspect_profile_candidates()
        _expect(str(inspection.get("selected_source", "")) != "", "valid copy survives failpoint: %s" % failpoint)

    for failpoint in ["before_quarantine", "after_quarantine_write"]:
        _reset_store()
        var store := PlayerProfileStore.new(_base_dir, true)
        var paths := store.paths()
        _write_text(str(paths["primary"]), "corrupt")
        _write_valid(str(paths["backup"]), _fields(32))
        _expect_ok(store.configure_test_failpoint(failpoint), "configure quarantine failpoint")
        var result := store.recover_profile_candidate("backup", PlayerProfileStore.RECOVERY_AUTHORITY)
        _expect(not bool(result.get("ok", true)), "quarantine failpoint triggers")
        var inspection := PlayerProfileStore.new(_base_dir, true).inspect_profile_candidates()
        _expect(bool(inspection.get("backup_available", false)), "valid backup survives quarantine failpoint")


func _test_quarantine_retention() -> void:
    _reset_store()
    for index in range(5):
        var store := PlayerProfileStore.new(_base_dir, true)
        var paths := store.paths()
        _write_text(str(paths["primary"]), "corrupt-%d" % index)
        _write_valid(str(paths["backup"]), _fields(40 + index))
        _expect_ok(store.recover_profile_candidate("backup", PlayerProfileStore.RECOVERY_AUTHORITY), "quarantine retention recovery")
    var quarantine_path := "%s/quarantine" % _base_dir
    var files := _directory_files(quarantine_path)
    var primary_files := files.filter(func(path: String) -> bool: return path.begins_with("primary."))
    _expect(primary_files.size() == 3, "quarantine retains exactly three primary diagnostics")
    _assert_quarantine_safe(quarantine_path)

    # A forbidden key can itself contain sensitive material. The validation
    # category may be retained, but the raw key must never reach quarantine.
    _reset_store()
    var store := PlayerProfileStore.new(_base_dir, true)
    var paths := store.paths()
    _write_valid(str(paths["backup"]), _fields(50))
    var sensitive_key := "https://private.example/secret-value_token"
    var raw_fields := _fields(51, {sensitive_key: "also-secret"})
    var raw_envelope := raw_fields.duplicate(true)
    raw_envelope["integrity"] = {"algorithm": "sha256", "digest": "0".repeat(64)}
    var raw_canonical := _schema.canonicalize(raw_envelope)
    _expect_ok(raw_canonical, "prepare forbidden-key candidate without schema sealing")
    if bool(raw_canonical.get("ok", false)):
        _write_text(str(paths["primary"]), str(raw_canonical["json"]))
        _expect_ok(store.recover_profile_candidate("backup", PlayerProfileStore.RECOVERY_AUTHORITY), "forbidden-key candidate recovery")
        _assert_quarantine_safe(str(paths["quarantine"]))
        var diagnostic: Variant = JSON.parse_string(FileAccess.get_file_as_string("%s/primary.1.json" % str(paths["quarantine"])))
        _expect(diagnostic is Dictionary and str((diagnostic as Dictionary).get("error", "")) == "forbidden_payload_key", "quarantine retains only bounded forbidden-key category")


func _fields(sequence: int, payload: Dictionary = {"marker": "test"}) -> Dictionary:
    return {
        "format_id": PlayerProfileSchema.FORMAT_ID,
        "schema_version": PlayerProfileSchema.SCHEMA_VERSION,
        "content_build_version": "build-test",
        "profile_id": PlayerProfileSchema.PROFILE_ID,
        "journey_phase": "test_phase",
        "checkpoint_kind": "test_checkpoint",
        "checkpoint_sequence": sequence,
        "payload_format_id": PlayerProfileSchema.PAYLOAD_FORMAT_ID,
        "payload_schema_version": PlayerProfileSchema.PAYLOAD_SCHEMA_VERSION,
        "payload": payload.duplicate(true),
        "written_at_metadata": {
            "source": "system_utc_diagnostic_only",
            "iso8601_utc": "2026-07-12T00:00:00Z",
        },
    }


func _write_valid(path: String, fields: Dictionary) -> void:
    var sealed := _schema.seal_envelope(fields)
    _expect_ok(sealed, "prepare valid candidate")
    if bool(sealed.get("ok", false)):
        _write_bytes(path, sealed["bytes"] as PackedByteArray)


func _write_future(path: String, fields: Dictionary) -> void:
    var sealed := _schema.seal_envelope(fields)
    _expect_ok(sealed, "prepare future candidate baseline")
    if bool(sealed.get("ok", false)):
        var future := str(sealed["json"]).replace("\"schema_version\":1", "\"schema_version\":2")
        _write_text(path, future)


func _write_text(path: String, text: String) -> void:
    _write_bytes(path, text.to_utf8_buffer())


func _write_bytes(path: String, bytes: PackedByteArray) -> void:
    DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(path.get_base_dir()))
    var file := FileAccess.open(path, FileAccess.WRITE)
    if file == null:
        _fail("could not write test candidate: %s" % path)
        return
    file.store_buffer(bytes)
    file.flush()


func _assert_quarantine_safe(path: String) -> void:
    for file_name in _directory_files(path):
        var text := FileAccess.get_file_as_string("%s/%s" % [path, file_name])
        _expect(not text.contains("connector_token"), "quarantine omits token content")
        _expect(not text.contains("https://"), "quarantine omits URL content")
        var parsed: Variant = JSON.parse_string(text)
        _expect(parsed is Dictionary, "quarantine diagnostic is JSON")
        if parsed is Dictionary:
            _expect(str((parsed as Dictionary).get("raw_sha256", "")).length() == 64, "quarantine diagnostic has SHA-256")


func _directory_files(path: String) -> Array[String]:
    var files: Array[String] = []
    var directory := DirAccess.open(path)
    if directory == null:
        return files
    directory.include_hidden = true
    directory.include_navigational = false
    directory.list_dir_begin()
    var entry := directory.get_next()
    while entry != "":
        if not directory.current_is_dir():
            files.append(entry)
        entry = directory.get_next()
    directory.list_dir_end()
    files.sort()
    return files


func _reset_store() -> void:
    _remove_tree(_base_dir)


func _clean_base() -> void:
    _remove_tree(_base_dir)


func _remove_tree(path: String) -> void:
    if not _is_safe_test_path(path):
        _fail("refused cleanup outside test prefix")
        return
    var directory := DirAccess.open(path)
    if directory == null:
        return
    directory.include_hidden = true
    directory.include_navigational = false
    directory.list_dir_begin()
    var entry := directory.get_next()
    while entry != "":
        var child := "%s/%s" % [path, entry]
        if directory.current_is_dir():
            _remove_tree(child)
        else:
            DirAccess.remove_absolute(ProjectSettings.globalize_path(child))
        entry = directory.get_next()
    directory.list_dir_end()
    DirAccess.remove_absolute(ProjectSettings.globalize_path(path))


func _is_safe_test_path(path: String) -> bool:
    if not path.begins_with(PlayerProfileStore.TEST_BASE_PREFIX):
        return false
    var test_root := ProjectSettings.globalize_path(PlayerProfileStore.TEST_BASE_PREFIX.trim_suffix("/")).simplify_path()
    var candidate := ProjectSettings.globalize_path(path).simplify_path()
    return candidate.begins_with(test_root + "/")


func _read_args() -> void:
    for arg in OS.get_cmdline_user_args():
        if arg.begins_with("--persistence-test-base="):
            _base_dir = arg.trim_prefix("--persistence-test-base=").trim_suffix("/")
        elif arg.begins_with("--persistence-test-phase="):
            _phase = arg.trim_prefix("--persistence-test-phase=")
        elif arg.begins_with("--persistence-test-failpoint="):
            _failpoint = arg.trim_prefix("--persistence-test-failpoint=")
        elif arg.begins_with("--persistence-test-expected-status="):
            _expected_status = arg.trim_prefix("--persistence-test-expected-status=")


func _expect_ok(result: Dictionary, label: String) -> void:
    if not bool(result.get("ok", false)):
        _fail("%s: %s" % [label, str(result)])


func _expect(condition: bool, message: String) -> void:
    if not condition:
        _fail(message)


func _fail(message: String) -> void:
    _failures.append(message)


func _finish() -> void:
    if _failures.is_empty():
        print("player_profile_store_test=passed phase=%s" % _phase)
        get_tree().quit(0)
        return
    for failure in _failures:
        push_error("player_profile_store_test failure: %s" % failure)
    get_tree().quit(1)
