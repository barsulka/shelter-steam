class_name ShelterPlayerProfileSchema
extends RefCounted

const FORMAT_ID := "shelter.player-profile-envelope"
const SCHEMA_VERSION := 1
const PROFILE_ID := "default"
const PAYLOAD_FORMAT_ID := "shelter.player-checkpoint"
const PAYLOAD_SCHEMA_VERSION := 2
const SUPPORTED_PAYLOAD_SCHEMA_VERSIONS := [1, 2]
const INTEGRITY_ALGORITHM := "sha256"

const MAX_FILE_BYTES := 1_048_576
const MAX_DEPTH := 32
const MAX_NODES := 50_000
const MAX_CONTAINER_ENTRIES := 4_096
const MAX_STRING_BYTES := 262_144
const MAX_SAFE_INTEGER := 9_007_199_254_740_991

const OUTER_FIELDS := [
    "format_id",
    "schema_version",
    "content_build_version",
    "profile_id",
    "journey_phase",
    "checkpoint_kind",
    "checkpoint_sequence",
    "payload_format_id",
    "payload_schema_version",
    "payload",
    "written_at_metadata",
    "integrity",
]
const WRITTEN_AT_FIELDS := ["source", "iso8601_utc"]
const INTEGRITY_FIELDS := ["algorithm", "digest"]
const FORBIDDEN_PAYLOAD_KEYS := [
    "active_fixture_id",
    "active_save_file",
    "debug_speed_multiplier",
    "connector",
    "connector_control",
    "state_connector",
    "state_connector_control",
    "connector_token",
    "connector_url",
    "capture",
    "capture_history",
    "capture_dir",
    "runtime_load_fixture",
    "runtime_load_save",
    "runtime_save_path",
]


func seal_envelope(fields: Dictionary) -> Dictionary:
    if fields.has("integrity"):
        return _error("integrity_must_be_store_generated", "corrupt")

    var candidate := fields.duplicate(true)
    candidate["integrity"] = {
        "algorithm": INTEGRITY_ALGORITHM,
        "digest": "0".repeat(64),
    }
    var normalized_result := _normalize_and_validate_envelope(candidate, false)
    if not bool(normalized_result.get("ok", false)):
        return normalized_result

    var normalized := normalized_result["envelope"] as Dictionary
    var digest_input := normalized.duplicate(true)
    digest_input.erase("integrity")
    var digest_result := canonicalize(digest_input)
    if not bool(digest_result.get("ok", false)):
        return digest_result
    normalized["integrity"] = {
        "algorithm": INTEGRITY_ALGORITHM,
        "digest": str(digest_result["json"]).sha256_text(),
    }

    var final_result := canonicalize(normalized)
    if not bool(final_result.get("ok", false)):
        return final_result
    var final_bytes := str(final_result["json"]).to_utf8_buffer()
    if final_bytes.size() > MAX_FILE_BYTES:
        return _error("file_too_large", "corrupt")
    return {
        "ok": true,
        "classification": "valid",
        "envelope": normalized,
        "json": str(final_result["json"]),
        "bytes": final_bytes,
        "envelope_valid": true,
        "checkpoint_contract_valid": false,
        "playable_profile": false,
    }


func decode_and_validate_bytes(bytes: PackedByteArray) -> Dictionary:
    if bytes.is_empty():
        return _error("empty_file", "corrupt")
    if bytes.size() > MAX_FILE_BYTES:
        return _error("file_too_large", "corrupt")
    var text := bytes.get_string_from_utf8()
    if text.to_utf8_buffer() != bytes:
        return _error("invalid_utf8", "corrupt")
    return decode_and_validate_text(text)


func decode_and_validate_text(text: String) -> Dictionary:
    var bytes := text.to_utf8_buffer()
    if bytes.is_empty():
        return _error("empty_file", "corrupt")
    if bytes.size() > MAX_FILE_BYTES:
        return _error("file_too_large", "corrupt")
    var numeric_lexical_result := _validate_raw_integer_tokens(text)
    if not bool(numeric_lexical_result.get("ok", false)):
        return numeric_lexical_result

    var parser := JSON.new()
    var parse_error := parser.parse(text)
    if parse_error != OK:
        return _error("invalid_json", "corrupt", {
            "line": parser.get_error_line(),
            "message": parser.get_error_message(),
        })
    if not parser.data is Dictionary:
        return _error("envelope_not_dictionary", "corrupt")

    var generic_normalized := _normalize_value(parser.data, {"nodes": 0}, 1, true, false)
    if not bool(generic_normalized.get("ok", false)):
        return generic_normalized
    var canonical_input := generic_normalized["value"] as Dictionary
    var generic_canonical := canonicalize(canonical_input)
    if not bool(generic_canonical.get("ok", false)):
        return generic_canonical
    if str(generic_canonical["json"]) != text:
        return _error("noncanonical_document", "corrupt")

    var normalized_result := _normalize_and_validate_envelope(canonical_input, false)
    if not bool(normalized_result.get("ok", false)):
        return normalized_result
    var normalized := normalized_result["envelope"] as Dictionary

    var integrity := normalized["integrity"] as Dictionary
    var digest_input := normalized.duplicate(true)
    digest_input.erase("integrity")
    var digest_result := canonicalize(digest_input)
    if not bool(digest_result.get("ok", false)):
        return digest_result
    var expected_digest := str(digest_result["json"]).sha256_text()
    if str(integrity["digest"]) != expected_digest:
        return _error("integrity_mismatch", "corrupt")

    return {
        "ok": true,
        "classification": "valid",
        "envelope": normalized,
        "json": text,
        "bytes": bytes,
        "envelope_valid": true,
        "checkpoint_contract_valid": false,
        "playable_profile": false,
    }


func _validate_raw_integer_tokens(text: String) -> Dictionary:
    var in_string := false
    var escaped := false
    var index := 0
    while index < text.length():
        var character := text[index]
        if in_string:
            if escaped:
                escaped = false
            elif character == "\\":
                escaped = true
            elif character == "\"":
                in_string = false
            index += 1
            continue
        if character == "\"":
            in_string = true
            index += 1
            continue
        if character == "-" or (character >= "0" and character <= "9"):
            var end := index + 1
            while end < text.length() and text[end] not in [",", "]", "}", " ", "\t", "\r", "\n"]:
                end += 1
            var token := text.substr(index, end - index)
            if not _is_lexical_integer(token):
                # The raw token is untrusted and may later be represented in a
                # redacted quarantine diagnostic. Preserve only its category.
                return _error("forbidden_number_token", "corrupt")
            index = end
            continue
        index += 1
    return {"ok": true}


func _is_lexical_integer(token: String) -> bool:
    if token == "0":
        return true
    var start := 0
    if token.begins_with("-"):
        start = 1
    if start >= token.length() or token[start] == "0":
        return false
    for index in range(start, token.length()):
        var character := token[index]
        if character < "0" or character > "9":
            return false
    return true


func canonicalize(value: Variant) -> Dictionary:
    var state := {
        "nodes": 0,
    }
    var result := _canonicalize_value(value, state, 1)
    if not bool(result.get("ok", false)):
        return result
    var json := str(result["json"])
    if json.to_utf8_buffer().size() > MAX_FILE_BYTES:
        return _error("file_too_large", "corrupt")
    return {
        "ok": true,
        "json": json,
        "nodes": int(state["nodes"]),
    }


func _normalize_and_validate_envelope(raw: Dictionary, from_parser: bool) -> Dictionary:
    var identity_classification := _classify_identity(raw)
    if identity_classification != "":
        return _error(identity_classification, "incompatible")

    var normalized_result := _normalize_value(raw, {"nodes": 0}, 1, from_parser, false)
    if not bool(normalized_result.get("ok", false)):
        return normalized_result
    var envelope := normalized_result["value"] as Dictionary

    var fields_result := _require_exact_fields(envelope, OUTER_FIELDS, "outer_fields")
    if not bool(fields_result.get("ok", false)):
        return fields_result

    if str(envelope.get("format_id", "")) != FORMAT_ID:
        return _error("incompatible_format_id", "incompatible")
    if not _is_exact_int(envelope.get("schema_version")) or int(envelope["schema_version"]) != SCHEMA_VERSION:
        return _error("incompatible_schema_version", "incompatible")
    if str(envelope.get("profile_id", "")) != PROFILE_ID:
        return _error("invalid_profile_id", "corrupt")
    if str(envelope.get("payload_format_id", "")) != PAYLOAD_FORMAT_ID:
        return _error("incompatible_payload_format_id", "incompatible")
    if not _is_exact_int(envelope.get("payload_schema_version")) or int(envelope["payload_schema_version"]) not in SUPPORTED_PAYLOAD_SCHEMA_VERSIONS:
        return _error("incompatible_payload_schema_version", "incompatible")

    for field in ["content_build_version", "journey_phase", "checkpoint_kind"]:
        if not envelope.get(field) is String or str(envelope[field]).is_empty():
            return _error("invalid_%s" % field, "corrupt")
    if str(envelope["content_build_version"]).to_utf8_buffer().size() > 256:
        return _error("content_build_version_too_long", "corrupt")
    if not _is_exact_int(envelope.get("checkpoint_sequence")):
        return _error("invalid_checkpoint_sequence", "corrupt")
    var checkpoint_sequence := int(envelope["checkpoint_sequence"])
    if checkpoint_sequence < 0 or checkpoint_sequence > MAX_SAFE_INTEGER:
        return _error("checkpoint_sequence_out_of_range", "corrupt")
    if not envelope.get("payload") is Dictionary:
        return _error("payload_not_dictionary", "corrupt")

    var written_at: Variant = envelope.get("written_at_metadata")
    if not written_at is Dictionary:
        return _error("written_at_metadata_not_dictionary", "corrupt")
    var written_fields := _require_exact_fields(written_at as Dictionary, WRITTEN_AT_FIELDS, "written_at_fields")
    if not bool(written_fields.get("ok", false)):
        return written_fields
    if str((written_at as Dictionary).get("source", "")) != "system_utc_diagnostic_only":
        return _error("invalid_written_at_source", "corrupt")
    var written_at_text: Variant = (written_at as Dictionary).get("iso8601_utc")
    if not written_at_text is String or str(written_at_text).is_empty() or str(written_at_text).to_utf8_buffer().size() > 64:
        return _error("invalid_written_at_iso8601", "corrupt")

    var integrity: Variant = envelope.get("integrity")
    if not integrity is Dictionary:
        return _error("integrity_not_dictionary", "corrupt")
    var integrity_fields := _require_exact_fields(integrity as Dictionary, INTEGRITY_FIELDS, "integrity_fields")
    if not bool(integrity_fields.get("ok", false)):
        return integrity_fields
    if str((integrity as Dictionary).get("algorithm", "")) != INTEGRITY_ALGORITHM:
        return _error("invalid_integrity_algorithm", "corrupt")
    var digest := str((integrity as Dictionary).get("digest", ""))
    if digest.length() != 64 or not digest.is_valid_hex_number(false) or digest != digest.to_lower():
        return _error("invalid_integrity_digest", "corrupt")

    var forbidden_result := _validate_payload_keys(envelope["payload"] as Dictionary)
    if not bool(forbidden_result.get("ok", false)):
        return forbidden_result
    return {
        "ok": true,
        "classification": "valid",
        "envelope": envelope,
    }


func _classify_identity(raw: Dictionary) -> String:
    if raw.has("format_id") and raw["format_id"] is String and str(raw["format_id"]) != FORMAT_ID:
        return "incompatible_format_id"
    if raw.has("schema_version") and _numeric_identity_differs(raw["schema_version"], SCHEMA_VERSION):
        return "incompatible_schema_version"
    if raw.has("payload_format_id") and raw["payload_format_id"] is String and str(raw["payload_format_id"]) != PAYLOAD_FORMAT_ID:
        return "incompatible_payload_format_id"
    if raw.has("payload_schema_version"):
        var payload_version: Variant = raw["payload_schema_version"]
        if payload_version is int and int(payload_version) not in SUPPORTED_PAYLOAD_SCHEMA_VERSIONS:
            return "incompatible_payload_schema_version"
        if payload_version is float and is_finite(float(payload_version)) and floor(float(payload_version)) == float(payload_version) and int(payload_version) not in SUPPORTED_PAYLOAD_SCHEMA_VERSIONS:
            return "incompatible_payload_schema_version"
    return ""


func _numeric_identity_differs(value: Variant, expected: int) -> bool:
    if value is int:
        return int(value) != expected
    if value is float and is_finite(float(value)) and floor(float(value)) == float(value):
        return int(value) != expected
    return false


func _normalize_value(
        value: Variant,
        state: Dictionary,
        depth: int,
        allow_parser_floats: bool,
        payload_context: bool
) -> Dictionary:
    if depth > MAX_DEPTH:
        return _error("maximum_depth_exceeded", "corrupt")
    state["nodes"] = int(state["nodes"]) + 1
    if int(state["nodes"]) > MAX_NODES:
        return _error("maximum_nodes_exceeded", "corrupt")

    if value == null or value is bool:
        return {"ok": true, "value": value}
    if value is int:
        var integer := int(value)
        if integer < -MAX_SAFE_INTEGER or integer > MAX_SAFE_INTEGER:
            return _error("integer_out_of_range", "corrupt")
        return {"ok": true, "value": integer}
    if value is float:
        if not allow_parser_floats:
            return _error("programmatic_float_forbidden", "corrupt")
        var number := float(value)
        if not is_finite(number) or floor(number) != number or absf(number) > float(MAX_SAFE_INTEGER):
            return _error("non_integer_number_forbidden", "corrupt")
        return {"ok": true, "value": int(number)}
    if value is String:
        var string_result := _validate_string(str(value))
        if not bool(string_result.get("ok", false)):
            return string_result
        return {"ok": true, "value": str(value)}
    if value is Array:
        var array := value as Array
        if array.size() > MAX_CONTAINER_ENTRIES:
            return _error("container_too_large", "corrupt")
        var normalized_array: Array = []
        for item in array:
            var item_result := _normalize_value(item, state, depth + 1, allow_parser_floats, payload_context)
            if not bool(item_result.get("ok", false)):
                return item_result
            normalized_array.append(item_result["value"])
        return {"ok": true, "value": normalized_array}
    if value is Dictionary:
        var dictionary := value as Dictionary
        if dictionary.size() > MAX_CONTAINER_ENTRIES:
            return _error("container_too_large", "corrupt")
        var normalized_dictionary := {}
        for key in dictionary.keys():
            if not key is String:
                return _error("dictionary_key_not_string", "corrupt")
            var key_result := _validate_string(str(key))
            if not bool(key_result.get("ok", false)):
                return key_result
            var child_result := _normalize_value(dictionary[key], state, depth + 1, allow_parser_floats, payload_context)
            if not bool(child_result.get("ok", false)):
                return child_result
            normalized_dictionary[str(key)] = child_result["value"]
        return {"ok": true, "value": normalized_dictionary}
    return _error("unsupported_json_type", "corrupt")


func _validate_payload_keys(payload: Dictionary) -> Dictionary:
    var stack: Array = [payload]
    while not stack.is_empty():
        var value: Variant = stack.pop_back()
        if value is Dictionary:
            for key in (value as Dictionary).keys():
                var key_text := str(key)
                if key_text in FORBIDDEN_PAYLOAD_KEYS or key_text.ends_with("_token") or key_text.ends_with("_url"):
                    # Never reflect the rejected key into an error. Store errors can
                    # be persisted as redacted quarantine diagnostics, and a key
                    # name is itself untrusted profile content.
                    return _error("forbidden_payload_key", "corrupt")
                stack.append((value as Dictionary)[key])
        elif value is Array:
            for item in value as Array:
                stack.append(item)
    return {"ok": true}


func _canonicalize_value(value: Variant, state: Dictionary, depth: int) -> Dictionary:
    if depth > MAX_DEPTH:
        return _error("maximum_depth_exceeded", "corrupt")
    state["nodes"] = int(state["nodes"]) + 1
    if int(state["nodes"]) > MAX_NODES:
        return _error("maximum_nodes_exceeded", "corrupt")

    if value == null:
        return {"ok": true, "json": "null"}
    if value is bool:
        return {"ok": true, "json": "true" if bool(value) else "false"}
    if value is int:
        var integer := int(value)
        if integer < -MAX_SAFE_INTEGER or integer > MAX_SAFE_INTEGER:
            return _error("integer_out_of_range", "corrupt")
        return {"ok": true, "json": str(integer)}
    if value is float:
        return _error("float_forbidden", "corrupt")
    if value is String:
        return _escape_string(str(value))
    if value is Array:
        var array := value as Array
        if array.size() > MAX_CONTAINER_ENTRIES:
            return _error("container_too_large", "corrupt")
        var array_parts: Array[String] = []
        for item in array:
            var item_result := _canonicalize_value(item, state, depth + 1)
            if not bool(item_result.get("ok", false)):
                return item_result
            array_parts.append(str(item_result["json"]))
        return {"ok": true, "json": "[" + ",".join(array_parts) + "]"}
    if value is Dictionary:
        var dictionary := value as Dictionary
        if dictionary.size() > MAX_CONTAINER_ENTRIES:
            return _error("container_too_large", "corrupt")
        var keys: Array[String] = []
        for key in dictionary.keys():
            if not key is String:
                return _error("dictionary_key_not_string", "corrupt")
            var key_result := _validate_string(str(key))
            if not bool(key_result.get("ok", false)):
                return key_result
            keys.append(str(key))
        keys.sort_custom(_utf16_less)
        var object_parts: Array[String] = []
        for key in keys:
            var escaped_key := _escape_string(key)
            if not bool(escaped_key.get("ok", false)):
                return escaped_key
            var value_result := _canonicalize_value(dictionary[key], state, depth + 1)
            if not bool(value_result.get("ok", false)):
                return value_result
            object_parts.append("%s:%s" % [str(escaped_key["json"]), str(value_result["json"])])
        return {"ok": true, "json": "{" + ",".join(object_parts) + "}"}
    return _error("unsupported_json_type", "corrupt")


func _escape_string(value: String) -> Dictionary:
    var validation := _validate_string(value)
    if not bool(validation.get("ok", false)):
        return validation
    var output := "\""
    for index in range(value.length()):
        var codepoint := value.unicode_at(index)
        match codepoint:
            0x08:
                output += "\\b"
            0x09:
                output += "\\t"
            0x0A:
                output += "\\n"
            0x0C:
                output += "\\f"
            0x0D:
                output += "\\r"
            0x22:
                output += "\\\""
            0x5C:
                output += "\\\\"
            _:
                if codepoint < 0x20:
                    output += "\\u%04x" % codepoint
                else:
                    output += String.chr(codepoint)
    output += "\""
    return {"ok": true, "json": output}


func _validate_string(value: String) -> Dictionary:
    if value.to_utf8_buffer().size() > MAX_STRING_BYTES:
        return _error("string_too_large", "corrupt")
    for index in range(value.length()):
        var codepoint := value.unicode_at(index)
        if codepoint < 0 or codepoint > 0x10FFFF or (codepoint >= 0xD800 and codepoint <= 0xDFFF):
            return _error("invalid_unicode", "corrupt")
    return {"ok": true}


func _utf16_less(a: String, b: String) -> bool:
    var a_units := _utf16_units(a)
    var b_units := _utf16_units(b)
    var shared := mini(a_units.size(), b_units.size())
    for index in range(shared):
        if int(a_units[index]) != int(b_units[index]):
            return int(a_units[index]) < int(b_units[index])
    return a_units.size() < b_units.size()


func _utf16_units(value: String) -> Array[int]:
    var units: Array[int] = []
    for index in range(value.length()):
        var codepoint := value.unicode_at(index)
        if codepoint <= 0xFFFF:
            units.append(codepoint)
        else:
            var adjusted := codepoint - 0x10000
            units.append(0xD800 + (adjusted >> 10))
            units.append(0xDC00 + (adjusted & 0x3FF))
    return units


func _require_exact_fields(value: Dictionary, expected: Array, error_prefix: String) -> Dictionary:
    if value.size() != expected.size():
        return _error("%s_mismatch" % error_prefix, "corrupt")
    for field in expected:
        if not value.has(field):
            return _error("%s_missing:%s" % [error_prefix, str(field)], "corrupt")
    return {"ok": true}


func _is_exact_int(value: Variant) -> bool:
    return value is int


func _error(code: String, classification: String, details: Dictionary = {}) -> Dictionary:
    var result := {
        "ok": false,
        "error": code,
        "classification": classification,
        "envelope_valid": false,
        "checkpoint_contract_valid": false,
        "playable_profile": false,
    }
    for key in details.keys():
        result[key] = details[key]
    return result
