class_name ShelterPlayerProfileStore
extends RefCounted

const PlayerProfileSchema := preload("res://scripts/persistence/player_profile_schema.gd")

const PRODUCTION_BASE_DIR := "user://player/default"
const TEST_BASE_PREFIX := "user://player-tests/"
const TEST_FAILPOINT_MARKER := ".failpoint-reached"
const CREATE_AUTHORITY := "create_profile"
const UPDATE_AUTHORITY := "update_profile"
const RECOVERY_AUTHORITY := "recover_profile"

var _schema := PlayerProfileSchema.new()
var _base_dir := PRODUCTION_BASE_DIR
var _primary_path := ""
var _temp_path := ""
var _backup_path := ""
var _quarantine_dir := ""
var _test_mode := false
var _configuration_error := ""
var _test_failpoint := ""
var _terminate_on_test_failpoint := false


func _init(base_dir: String = PRODUCTION_BASE_DIR, test_mode: bool = false) -> void:
    _base_dir = base_dir.trim_suffix("/")
    _test_mode = test_mode
    _primary_path = "%s/profile.json" % _base_dir
    _temp_path = "%s/profile.tmp" % _base_dir
    _backup_path = "%s/profile.bak" % _base_dir
    _quarantine_dir = "%s/quarantine" % _base_dir
    _configuration_error = _validate_configuration()


func paths() -> Dictionary:
    return {
        "base_dir": _base_dir,
        "primary": _primary_path,
        "temp": _temp_path,
        "backup": _backup_path,
        "quarantine": _quarantine_dir,
    }


func configure_test_failpoint(failpoint: String, terminate_process: bool = false) -> Dictionary:
    if not _test_mode or _configuration_error != "":
        return _result_error("test_failpoint_forbidden")
    _test_failpoint = failpoint
    _terminate_on_test_failpoint = terminate_process
    return {"ok": true, "failpoint": _test_failpoint}


func inspect_profile_candidates() -> Dictionary:
    var configuration_result := _configuration_result()
    if not bool(configuration_result.get("ok", false)):
        return configuration_result

    var candidates := {
        "primary": _inspect_candidate("primary", _primary_path),
        "backup": _inspect_candidate("backup", _backup_path),
        "temp": _inspect_candidate("temp", _temp_path),
    }
    var primary := candidates["primary"] as Dictionary
    var backup := candidates["backup"] as Dictionary
    var temp := candidates["temp"] as Dictionary
    var status := "no_valid_profile"
    var selected_source := ""

    if str(primary["classification"]) == "valid":
        status = "primary_available"
        selected_source = "primary"
    elif str(primary["classification"]) == "incompatible":
        status = "incompatible_primary"
    elif str(backup["classification"]) == "valid":
        status = "backup_available"
        selected_source = "backup"
    elif str(backup["classification"]) == "incompatible":
        status = "incompatible_backup"
    elif str(temp["classification"]) == "valid":
        status = "temp_available"
        selected_source = "temp"

    var warnings: Array[String] = []
    if status == "primary_available":
        for source in ["backup", "temp"]:
            var candidate := candidates[source] as Dictionary
            if str(candidate["classification"]) not in ["absent", "valid"]:
                warnings.append("%s_%s" % [source, str(candidate["classification"])])

    return {
        "ok": true,
        "status": status,
        "selected_source": selected_source,
        "candidates": candidates,
        "warnings": warnings,
        "backup_available": str(backup["classification"]) == "valid",
        "temp_available": str(temp["classification"]) == "valid",
        "envelope_valid": selected_source != "",
        "checkpoint_contract_valid": false,
        "playable_profile": false,
    }


func has_valid_envelope() -> bool:
    var inspection := inspect_profile_candidates()
    return bool(inspection.get("ok", false)) and str(inspection.get("selected_source", "")) != ""


func load_profile_candidate(source: String) -> Dictionary:
    var configuration_result := _configuration_result()
    if not bool(configuration_result.get("ok", false)):
        return configuration_result
    var path := _source_path(source)
    if path == "":
        return _result_error("unknown_candidate_source")
    var candidate := _inspect_candidate(source, path)
    if str(candidate.get("classification", "")) != "valid":
        return _result_error("candidate_not_valid", {
            "source": source,
            "candidate": candidate,
        })
    var decoded := _schema.decode_and_validate_bytes(FileAccess.get_file_as_bytes(path))
    if not bool(decoded.get("ok", false)):
        return _result_error("candidate_changed_during_load", {"source": source})
    return {
        "ok": true,
        "status": "loaded_envelope",
        "source": source,
        "envelope": decoded["envelope"],
        "envelope_valid": true,
        "checkpoint_contract_valid": false,
        "playable_profile": false,
    }


func store_profile(envelope_fields: Dictionary, explicit_authority: String) -> Dictionary:
    var configuration_result := _configuration_result()
    if not bool(configuration_result.get("ok", false)):
        return configuration_result
    if explicit_authority not in [CREATE_AUTHORITY, UPDATE_AUTHORITY]:
        return _result_error("store_authority_required")
    if _trigger_failpoint("before_validation"):
        return _injected_failure("before_validation")

    var inspection := inspect_profile_candidates()
    if not bool(inspection.get("ok", false)):
        return inspection
    var candidates := inspection["candidates"] as Dictionary
    var primary := candidates["primary"] as Dictionary
    var backup := candidates["backup"] as Dictionary
    var temp := candidates["temp"] as Dictionary
    var primary_class := str(primary["classification"])
    var backup_class := str(backup["classification"])
    var temp_class := str(temp["classification"])

    if primary_class in ["corrupt", "incompatible"]:
        return _result_error("primary_requires_explicit_recovery", {"candidate": primary})
    if primary_class == "valid" and explicit_authority != UPDATE_AUTHORITY:
        return _result_error("profile_already_exists")
    if primary_class == "absent" and backup_class not in ["absent", "valid"]:
        return _result_error("backup_requires_explicit_recovery", {"candidate": backup})
    if primary_class == "absent" and backup_class == "valid" and explicit_authority != UPDATE_AUTHORITY:
        return _result_error("profile_recovery_required")
    if primary_class == "absent" and backup_class == "absent" and temp_class in ["valid", "incompatible"]:
        return _result_error("profile_recovery_required", {"candidate": temp})
    if primary_class == "absent" and backup_class == "absent" and explicit_authority != CREATE_AUTHORITY:
        return _result_error("no_existing_profile")

    var sealed := _schema.seal_envelope(envelope_fields)
    if not bool(sealed.get("ok", false)):
        return _result_error("outgoing_envelope_invalid", {"validation": sealed})
    var ensure_result := _ensure_directories()
    if not bool(ensure_result.get("ok", false)):
        return ensure_result

    var temp_write := _write_temp_candidate(sealed["bytes"] as PackedByteArray)
    if not bool(temp_write.get("ok", false)):
        return temp_write

    if primary_class == "valid":
        var primary_bytes := FileAccess.get_file_as_bytes(_primary_path)
        var backup_write := _write_validated_copy(_backup_path, primary_bytes, "backup")
        if not bool(backup_write.get("ok", false)):
            return backup_write
        if _trigger_failpoint("after_backup_write"):
            return _injected_failure("after_backup_write")
        var remove_error := DirAccess.remove_absolute(ProjectSettings.globalize_path(_primary_path))
        if remove_error != OK:
            return _result_error("primary_remove_failed", {"code": remove_error})
        if _trigger_failpoint("after_primary_remove"):
            return _injected_failure("after_primary_remove")

    var promote_error := DirAccess.rename_absolute(
        ProjectSettings.globalize_path(_temp_path),
        ProjectSettings.globalize_path(_primary_path)
    )
    if promote_error != OK:
        return _result_error("primary_promotion_failed", {"code": promote_error})
    if _trigger_failpoint("after_primary_promotion"):
        return _injected_failure("after_primary_promotion")

    var promoted := _inspect_candidate("primary", _primary_path)
    if str(promoted["classification"]) != "valid":
        return _result_error("promoted_primary_invalid", {"candidate": promoted})
    return {
        "ok": true,
        "status": "stored",
        "source": "primary",
        "envelope": sealed["envelope"],
        "envelope_valid": true,
        "checkpoint_contract_valid": false,
        "playable_profile": false,
    }


func recover_profile_candidate(source: String, explicit_authority: String) -> Dictionary:
    var configuration_result := _configuration_result()
    if not bool(configuration_result.get("ok", false)):
        return configuration_result
    if explicit_authority != RECOVERY_AUTHORITY:
        return _result_error("recovery_authority_required")
    if source not in ["backup", "temp"]:
        return _result_error("unsupported_recovery_source")

    var inspection := inspect_profile_candidates()
    if not bool(inspection.get("ok", false)):
        return inspection
    var expected_status := "%s_available" % source
    if str(inspection.get("status", "")) != expected_status or str(inspection.get("selected_source", "")) != source:
        return _result_error("recovery_source_not_selected", {"inspection": inspection})

    var source_path := _source_path(source)
    var source_bytes := FileAccess.get_file_as_bytes(source_path)
    var source_validation := _schema.decode_and_validate_bytes(source_bytes)
    if not bool(source_validation.get("ok", false)):
        return _result_error("recovery_source_changed")

    var candidates := inspection["candidates"] as Dictionary
    for invalid_source in ["primary", "backup"]:
        if invalid_source == source:
            continue
        var candidate := candidates[invalid_source] as Dictionary
        if str(candidate["classification"]) == "corrupt":
            var quarantine_result := _quarantine_invalid_candidate(invalid_source, candidate)
            if not bool(quarantine_result.get("ok", false)):
                return quarantine_result
            var invalid_path := _source_path(invalid_source)
            if FileAccess.file_exists(invalid_path):
                var remove_invalid := DirAccess.remove_absolute(ProjectSettings.globalize_path(invalid_path))
                if remove_invalid != OK:
                    return _result_error("invalid_candidate_remove_failed", {"source": invalid_source})

    if source == "backup":
        var temp_write := _write_temp_candidate(source_bytes)
        if not bool(temp_write.get("ok", false)):
            return temp_write

    if FileAccess.file_exists(_primary_path):
        var remove_primary := DirAccess.remove_absolute(ProjectSettings.globalize_path(_primary_path))
        if remove_primary != OK:
            return _result_error("primary_remove_failed", {"code": remove_primary})
    var promote_error := DirAccess.rename_absolute(
        ProjectSettings.globalize_path(_temp_path),
        ProjectSettings.globalize_path(_primary_path)
    )
    if promote_error != OK:
        return _result_error("recovery_promotion_failed", {"code": promote_error})
    var promoted := _inspect_candidate("primary", _primary_path)
    if str(promoted["classification"]) != "valid":
        return _result_error("recovered_primary_invalid")
    return {
        "ok": true,
        "status": "recovered_from_%s" % source,
        "source": "primary",
        "envelope_valid": true,
        "checkpoint_contract_valid": false,
        "playable_profile": false,
    }


func _write_temp_candidate(bytes: PackedByteArray) -> Dictionary:
    var file := FileAccess.open(_temp_path, FileAccess.WRITE)
    if file == null:
        return _result_error("temp_open_failed", {"code": FileAccess.get_open_error()})
    file.store_buffer(bytes)
    if _trigger_failpoint("after_temp_write"):
        file = null
        return _injected_failure("after_temp_write")
    file.flush()
    if file.get_error() != OK:
        return _result_error("temp_flush_failed", {"code": file.get_error()})
    if _trigger_failpoint("after_temp_flush"):
        file = null
        return _injected_failure("after_temp_flush")
    file = null
    var validation := _schema.decode_and_validate_bytes(FileAccess.get_file_as_bytes(_temp_path))
    if not bool(validation.get("ok", false)):
        return _result_error("temp_readback_invalid", {"validation": validation})
    if _trigger_failpoint("after_temp_readback"):
        return _injected_failure("after_temp_readback")
    return {"ok": true}


func _write_validated_copy(path: String, bytes: PackedByteArray, label: String) -> Dictionary:
    var file := FileAccess.open(path, FileAccess.WRITE)
    if file == null:
        return _result_error("%s_open_failed" % label, {"code": FileAccess.get_open_error()})
    file.store_buffer(bytes)
    file.flush()
    if file.get_error() != OK:
        return _result_error("%s_flush_failed" % label, {"code": file.get_error()})
    file = null
    var validation := _schema.decode_and_validate_bytes(FileAccess.get_file_as_bytes(path))
    if not bool(validation.get("ok", false)):
        return _result_error("%s_readback_invalid" % label, {"validation": validation})
    return {"ok": true}


func _quarantine_invalid_candidate(source: String, candidate: Dictionary) -> Dictionary:
    if _trigger_failpoint("before_quarantine"):
        return _injected_failure("before_quarantine")
    var ensure_result := _ensure_directories()
    if not bool(ensure_result.get("ok", false)):
        return ensure_result
    for index in range(3, 1, -1):
        var older := "%s/%s.%d.json" % [_quarantine_dir, source, index - 1]
        var newer := "%s/%s.%d.json" % [_quarantine_dir, source, index]
        if FileAccess.file_exists(newer):
            DirAccess.remove_absolute(ProjectSettings.globalize_path(newer))
        if FileAccess.file_exists(older):
            var rotate_error := DirAccess.rename_absolute(
                ProjectSettings.globalize_path(older),
                ProjectSettings.globalize_path(newer)
            )
            if rotate_error != OK:
                return _result_error("quarantine_rotation_failed", {"source": source})
    var raw_bytes := FileAccess.get_file_as_bytes(_source_path(source))
    var diagnostic := {
        "byte_size": raw_bytes.size(),
        "classification": str(candidate.get("classification", "corrupt")),
        "error": _redacted_error_category(str(candidate.get("error", "invalid_candidate"))),
        "raw_sha256": _sha256_bytes(raw_bytes),
        "source": source,
    }
    var canonical := _schema.canonicalize(diagnostic)
    if not bool(canonical.get("ok", false)):
        return _result_error("quarantine_diagnostic_invalid")
    var target := "%s/%s.1.json" % [_quarantine_dir, source]
    var file := FileAccess.open(target, FileAccess.WRITE)
    if file == null:
        return _result_error("quarantine_open_failed")
    file.store_buffer(str(canonical["json"]).to_utf8_buffer())
    file.flush()
    if file.get_error() != OK:
        return _result_error("quarantine_flush_failed")
    file = null
    if _trigger_failpoint("after_quarantine_write"):
        return _injected_failure("after_quarantine_write")
    return {"ok": true, "path": target}


func _redacted_error_category(error: String) -> String:
    var category := error.get_slice(":", 0)
    if category.is_empty() or category.length() > 64:
        return "invalid_candidate"
    for index in range(category.length()):
        var character := category[index]
        if not ((character >= "a" and character <= "z") or (character >= "0" and character <= "9") or character == "_"):
            return "invalid_candidate"
    return category


func _inspect_candidate(source: String, path: String) -> Dictionary:
    if not FileAccess.file_exists(path):
        return _candidate_result(source, path, "absent", "")
    var bytes := FileAccess.get_file_as_bytes(path)
    var decoded := _schema.decode_and_validate_bytes(bytes)
    if bool(decoded.get("ok", false)):
        var result := _candidate_result(source, path, "valid", "")
        result["byte_size"] = bytes.size()
        result["envelope_valid"] = true
        return result
    var classification := str(decoded.get("classification", "corrupt"))
    if classification != "incompatible":
        classification = "corrupt"
    var invalid := _candidate_result(source, path, classification, str(decoded.get("error", "invalid_candidate")))
    invalid["byte_size"] = bytes.size()
    return invalid


func _candidate_result(source: String, path: String, classification: String, error: String) -> Dictionary:
    return {
        "source": source,
        "path": path,
        "classification": classification,
        "error": error,
        "envelope_valid": classification == "valid",
        "checkpoint_contract_valid": false,
        "playable_profile": false,
    }


func _ensure_directories() -> Dictionary:
    var base_error := DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(_base_dir))
    if base_error != OK:
        return _result_error("base_directory_create_failed", {"code": base_error})
    var quarantine_error := DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(_quarantine_dir))
    if quarantine_error != OK:
        return _result_error("quarantine_directory_create_failed", {"code": quarantine_error})
    return {"ok": true}


func _validate_configuration() -> String:
    if not _base_dir.begins_with("user://"):
        return "base_directory_must_be_user"
    var base_path := ProjectSettings.globalize_path(_base_dir).simplify_path()
    var production_path := ProjectSettings.globalize_path(PRODUCTION_BASE_DIR).simplify_path()
    if _test_mode:
        if not _base_dir.begins_with(TEST_BASE_PREFIX):
            return "test_directory_outside_isolated_prefix"
        var test_root := ProjectSettings.globalize_path(TEST_BASE_PREFIX.trim_suffix("/")).simplify_path()
        if not base_path.begins_with(test_root + "/"):
            return "test_directory_outside_isolated_prefix"
        if base_path == production_path or base_path.begins_with(production_path + "/"):
            return "test_directory_overlaps_production_profile"
    elif _base_dir != PRODUCTION_BASE_DIR or base_path != production_path:
        return "production_directory_must_be_default_profile"
    return ""


func _configuration_result() -> Dictionary:
    if _configuration_error != "":
        return _result_error(_configuration_error)
    return {"ok": true}


func _source_path(source: String) -> String:
    match source:
        "primary":
            return _primary_path
        "backup":
            return _backup_path
        "temp":
            return _temp_path
        _:
            return ""


func _trigger_failpoint(name: String) -> bool:
    if not _test_mode or _test_failpoint != name:
        return false
    if _terminate_on_test_failpoint:
        if not _write_test_failpoint_marker(name):
            return true
        OS.kill(OS.get_process_id())
    return true


func _write_test_failpoint_marker(name: String) -> bool:
    var directory_error := DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(_base_dir))
    if directory_error != OK:
        return false
    var marker_path := "%s/%s" % [_base_dir, TEST_FAILPOINT_MARKER]
    var marker := FileAccess.open(marker_path, FileAccess.WRITE)
    if marker == null:
        return false
    marker.store_string(name)
    marker.flush()
    var marker_error := marker.get_error()
    marker = null
    return marker_error == OK and FileAccess.get_file_as_string(marker_path) == name


func _sha256_bytes(bytes: PackedByteArray) -> String:
    var context := HashingContext.new()
    var start_error := context.start(HashingContext.HASH_SHA256)
    if start_error != OK:
        return ""
    var update_error := context.update(bytes)
    if update_error != OK:
        return ""
    return context.finish().hex_encode()


func _injected_failure(name: String) -> Dictionary:
    return _result_error("injected_failure:%s" % name, {"failpoint": name})


func _result_error(code: String, details: Dictionary = {}) -> Dictionary:
    var result := {
        "ok": false,
        "error": code,
        "envelope_valid": false,
        "checkpoint_contract_valid": false,
        "playable_profile": false,
    }
    for key in details.keys():
        result[key] = details[key]
    return result
