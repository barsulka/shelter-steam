extends Node

const Codec := preload("res://scripts/player/player_checkpoint_codec.gd")
const Schema := preload("res://scripts/persistence/player_profile_schema.gd")
const RuntimeScene := preload("res://scenes/prototypes/vertical_slice/vertical_slice_demo.tscn")

var _codec := Codec.new()
var _failures: Array[String] = []
var _stored_checkpoints: Dictionary = {}
var _last_sequence := 0
var _fail_sequence := -1


func _ready() -> void:
    _run.call_deferred()


func _run() -> void:
    _test_codec_matrix()
    await _test_natural_runtime_matrix()
    await _test_import_export_matrix()
    await _test_commit_barrier_retry()
    if _failures.is_empty():
        print("player_checkpoint_test=passed cursors=17")
        get_tree().quit(0)
    else:
        for failure in _failures:
            push_error(failure)
        print("player_checkpoint_test=failed count=%d" % _failures.size())
        get_tree().quit(1)


func _test_codec_matrix() -> void:
    var kinds := _codec.checkpoint_kinds()
    _expect(kinds.size() == 17, "exact seventeen cursor kinds")
    for sequence in range(1, 18):
        var kind := _codec.kind_for_sequence(sequence)
        var checkpoint := _codec.build_golden_checkpoint(kind)
        var validation := _codec.validate_checkpoint(checkpoint)
        _expect_ok(validation, "golden cursor %d validates" % sequence)
        _expect(int(validation.get("checkpoint_sequence", 0)) == sequence, "cursor ordinal %d exact" % sequence)
        _expect(str(validation.get("checkpoint_kind", "")) == kind, "cursor kind %d exact" % sequence)
        _expect(str(validation.get("checkpoint_digest", "")).length() == 64, "cursor digest %d" % sequence)
        var mirror := {
            "journey_phase": (checkpoint["journey"] as Dictionary)["phase"],
            "checkpoint_kind": kind,
            "checkpoint_sequence": sequence,
        }
        _expect_ok(_codec.validate_checkpoint(checkpoint, mirror), "cursor mirror %d" % sequence)
        var intents := _codec.pending_intents(kind)
        for intent in intents:
            _expect(str(intent.get("order_id", "")) == Codec.FIRST_ORDER_ID, "intent order id exact at cursor %d" % sequence)
            _expect(str(intent.get("status", "")) == "queued", "intent status exact at cursor %d" % sequence)
            _expect(bool(intent.get("blocks_order_progress", false)), "intent blocks progress at cursor %d" % sequence)
            _expect(str(intent.get("type", "")) != "", "intent task family present at cursor %d" % sequence)

    var deep_copy_source := _codec.build_golden_checkpoint("first_day_inputs_in_kitchen")
    var deep_copy_validation := _codec.validate_checkpoint(deep_copy_source)
    deep_copy_source["format_id"] = "mutated.after.validation"
    _expect(str((deep_copy_validation.get("checkpoint", {}) as Dictionary).get("format_id", "")) == Codec.FORMAT_ID, "validated checkpoint is a deep copy")
    var intent_copy := _codec.pending_intents("first_day_payload_returned")
    (intent_copy[0] as Dictionary)["type"] = "MutatedTask"
    _expect(str((_codec.pending_intents("first_day_payload_returned")[0] as Dictionary).get("type", "")) == "UnloadTask", "pending intent result is isolated")

    var unknown := _codec.build_golden_checkpoint("first_day_offered")
    unknown["unexpected"] = true
    _expect(not bool(_codec.validate_checkpoint(unknown).get("ok", true)), "unknown top-level field rejected")
    var float_payload := _codec.build_golden_checkpoint("first_day_offered")
    (float_payload["journey"] as Dictionary)["active_day"] = 1.0
    _expect(str(_codec.validate_checkpoint(float_payload).get("error", "")) == "checkpoint_float_forbidden", "native float rejected")
    var forbidden := _codec.build_golden_checkpoint("first_day_offered")
    (forbidden["world"] as Dictionary)["current_task"] = {}
    _expect(str(_codec.validate_checkpoint(forbidden).get("error", "")) == "checkpoint_forbidden_field", "task state rejected")
    var wrong_resource := _codec.build_golden_checkpoint("first_day_inputs_in_kitchen")
    (((wrong_resource["resources"] as Dictionary)["storage"] as Dictionary))["protein_packet"] = 2
    _expect(str(_codec.validate_checkpoint(wrong_resource).get("error", "")) == "checkpoint_golden_state_mismatch", "resource conservation fails closed")
    var wrong_history := _codec.build_golden_checkpoint("first_day_delivery_response")
    (wrong_history["first_day_history"] as Dictionary)["next_day_hint_available"] = true
    _expect(not bool(_codec.validate_checkpoint(wrong_history).get("ok", true)), "premature hint rejected")
    var wrong_mirror := _codec.build_golden_checkpoint("first_day_ready_to_dispatch")
    _expect(
        str(_codec.validate_checkpoint(wrong_mirror, {"journey_phase": "first_day", "checkpoint_kind": "first_day_ready_to_dispatch", "checkpoint_sequence": 99}).get("error", "")) == "envelope_checkpoint_sequence_mismatch",
        "envelope mirror mismatch rejected"
    )
    _expect(
        str(_codec.validate_checkpoint(wrong_mirror, {"journey_phase": "day2", "checkpoint_kind": "first_day_ready_to_dispatch", "checkpoint_sequence": 13}).get("error", "")) == "envelope_journey_phase_mismatch",
        "envelope phase mirror mismatch rejected"
    )
    _expect(
        str(_codec.validate_checkpoint(wrong_mirror, {"journey_phase": "first_day", "checkpoint_kind": "first_day_offered", "checkpoint_sequence": 13}).get("error", "")) == "envelope_checkpoint_kind_mismatch",
        "envelope kind mirror mismatch rejected"
    )
    var sequence_zero := _codec.build_golden_checkpoint("first_day_offered")
    (sequence_zero["journey"] as Dictionary)["checkpoint_sequence"] = 0
    _expect(str(_codec.validate_checkpoint(sequence_zero).get("error", "")) == "checkpoint_sequence_cursor_mismatch", "sequence zero rejected")

    for identity_case in [
        ["format_id", "unknown.checkpoint", "checkpoint_identity_invalid"],
        ["schema_version", 2, "checkpoint_identity_invalid"],
    ]:
        var identity := _codec.build_golden_checkpoint("first_day_offered")
        identity[str(identity_case[0])] = identity_case[1]
        _expect(str(_codec.validate_checkpoint(identity).get("error", "")) == str(identity_case[2]), "checkpoint identity mismatch rejected")

    for section in ["journey", "first_day_history", "active_order", "active_chain", "day2", "resources", "world"]:
        var nested_unknown := _codec.build_golden_checkpoint("first_day_offered")
        (nested_unknown[section] as Dictionary)["unexpected_nested_field"] = true
        _expect(not bool(_codec.validate_checkpoint(nested_unknown).get("ok", true)), "unknown nested field rejected in %s" % section)
    var dachshund_unknown := _codec.build_golden_checkpoint("first_day_complete")
    (((dachshund_unknown["first_day_history"] as Dictionary)["dachshund"] as Dictionary))["unexpected_nested_field"] = true
    _expect(not bool(_codec.validate_checkpoint(dachshund_unknown).get("ok", true)), "unknown Dachshund history field rejected")
    var resource_unknown := _codec.build_golden_checkpoint("first_day_offered")
    (((resource_unknown["resources"] as Dictionary)["storage"] as Dictionary))["unexpected_resource"] = 1
    _expect(not bool(_codec.validate_checkpoint(resource_unknown).get("ok", true)), "unknown resource field rejected")

    for forbidden_key in Codec.FORBIDDEN_FIELDS:
        var forbidden_case := _codec.build_golden_checkpoint("first_day_offered")
        (forbidden_case["world"] as Dictionary)[forbidden_key] = 1
        _expect(str(_codec.validate_checkpoint(forbidden_case).get("error", "")) == "checkpoint_forbidden_field", "forbidden runtime field rejected: %s" % forbidden_key)
    for forbidden_suffix in ["access_token", "local_url"]:
        var suffix_case := _codec.build_golden_checkpoint("first_day_offered")
        (suffix_case["world"] as Dictionary)[forbidden_suffix] = "secret"
        _expect(str(_codec.validate_checkpoint(suffix_case).get("error", "")) == "checkpoint_forbidden_field", "forbidden suffix rejected: %s" % forbidden_suffix)

    var oversized := _codec.build_golden_checkpoint("first_day_offered")
    (oversized["journey"] as Dictionary)["active_day"] = Schema.MAX_SAFE_INTEGER + 1
    _expect(str(_codec.validate_checkpoint(oversized).get("error", "")) == "checkpoint_integer_out_of_range", "oversized integer rejected")
    var wrong_integer_type := _codec.build_golden_checkpoint("first_day_offered")
    (wrong_integer_type["journey"] as Dictionary)["active_day"] = "1"
    _expect(not bool(_codec.validate_checkpoint(wrong_integer_type).get("ok", true)), "integer string rejected")
    var wrong_resource_type := _codec.build_golden_checkpoint("first_day_offered")
    (((wrong_resource_type["resources"] as Dictionary)["storage"] as Dictionary))["protein_packet"] = true
    _expect(not bool(_codec.validate_checkpoint(wrong_resource_type).get("ok", true)), "resource boolean rejected")
    var nested_float := _codec.build_golden_checkpoint("first_day_offered")
    ((nested_float["active_order"] as Dictionary)["status_history"] as Array).append(1.0)
    _expect(str(_codec.validate_checkpoint(nested_float).get("error", "")) == "checkpoint_float_forbidden", "nested float rejected before normalization")

    for field in Codec.DAY2_FIELDS:
        var day2_drift := _codec.build_golden_checkpoint("first_day_offered")
        var day2 := day2_drift["day2"] as Dictionary
        day2[field] = not bool(day2[field])
        _expect(not bool(_codec.validate_checkpoint(day2_drift).get("ok", true)), "Day 2 field drift rejected: %s" % field)

    var order_prefix := _codec.build_golden_checkpoint("first_day_ready_to_dispatch")
    ((order_prefix["active_order"] as Dictionary)["status_history"] as Array).pop_back()
    _expect(not bool(_codec.validate_checkpoint(order_prefix).get("ok", true)), "order history prefix drift rejected")
    var order_extra := _codec.build_golden_checkpoint("first_day_ready_to_dispatch")
    ((order_extra["active_order"] as Dictionary)["status_history"] as Array).append("completed")
    _expect(not bool(_codec.validate_checkpoint(order_extra).get("ok", true)), "order history extra transition rejected")
    var chain_prefix := _codec.build_golden_checkpoint("first_day_food_bag_ready")
    ((chain_prefix["active_chain"] as Dictionary)["state_history"] as Array).pop_back()
    _expect(not bool(_codec.validate_checkpoint(chain_prefix).get("ok", true)), "chain history prefix drift rejected")
    var chain_step := _codec.build_golden_checkpoint("first_day_food_bag_ready")
    (chain_step["active_chain"] as Dictionary)["current_step"] = "delivery"
    _expect(not bool(_codec.validate_checkpoint(chain_step).get("ok", true)), "chain current step drift rejected")
    var history_drift := _codec.build_golden_checkpoint("first_day_complete")
    (history_drift["first_day_history"] as Dictionary)["first_reward_equipped"] = false
    _expect(not bool(_codec.validate_checkpoint(history_drift).get("ok", true)), "immutable history drift rejected")
    var premature_note := _codec.build_golden_checkpoint("first_day_delivery_response")
    (premature_note["first_day_history"] as Dictionary)["packing_note_visible"] = true
    _expect(not bool(_codec.validate_checkpoint(premature_note).get("ok", true)), "premature Packing note rejected")
    var non_monotonic_history := _codec.build_golden_checkpoint("first_day_equip_confirmed")
    (non_monotonic_history["first_day_history"] as Dictionary)["postcard_visible"] = false
    _expect(not bool(_codec.validate_checkpoint(non_monotonic_history).get("ok", true)), "non-monotonic partial history rejected")


func _test_natural_runtime_matrix() -> void:
    _stored_checkpoints.clear()
    _last_sequence = 0
    _fail_sequence = -1
    var runtime := RuntimeScene.instantiate()
    var configured: Dictionary = runtime.call("configure_player_session", {
        "startup_intent": "fresh_session",
        "checkpoint_commit_sink": Callable(self, "_memory_sink"),
    }) as Dictionary
    _expect_ok(configured, "fresh runtime configures")
    add_child(runtime)
    await get_tree().process_frame
    runtime.set_process(false)
    for sequence in range(1, 18):
        var exported: Dictionary = runtime.call("export_player_safe_checkpoint") as Dictionary
        _expect_ok(exported, "natural cursor %d exports" % sequence)
        if bool(exported.get("ok", false)):
            var checkpoint := exported["checkpoint"] as Dictionary
            _expect(checkpoint == _codec.build_golden_checkpoint(_codec.kind_for_sequence(sequence)), "natural cursor %d equals normative matrix" % sequence)
        if sequence < 17:
            var advanced: Dictionary = runtime.call("test_advance_player_to_next_checkpoint") as Dictionary
            _expect_ok(advanced, "natural cursor %d advances once" % sequence)
    _expect(_last_sequence == 17, "natural runtime persisted all seventeen cursors")
    _expect(_stored_checkpoints.size() == 17, "one durable payload per cursor")
    runtime.queue_free()
    await get_tree().process_frame


func _test_import_export_matrix() -> void:
    for sequence in range(1, 18):
        _last_sequence = sequence
        _fail_sequence = -1
        var checkpoint := _codec.build_golden_checkpoint(_codec.kind_for_sequence(sequence))
        var runtime := RuntimeScene.instantiate()
        var configured: Dictionary = runtime.call("configure_player_session", {
            "startup_intent": "continue",
            "checkpoint": checkpoint,
            "checkpoint_commit_sink": Callable(self, "_memory_sink"),
        }) as Dictionary
        _expect_ok(configured, "continue config %d" % sequence)
        add_child(runtime)
        await get_tree().process_frame
        runtime.set_process(false)
        var exported: Dictionary = runtime.call("export_player_safe_checkpoint") as Dictionary
        _expect_ok(exported, "immediate export after import %d" % sequence)
        if bool(exported.get("ok", false)):
            _expect((exported["checkpoint"] as Dictionary) == checkpoint, "import/export semantic identity %d" % sequence)
        var snapshot := runtime.call("player_checkpoint_snapshot") as Dictionary
        var reconstructed := snapshot.get("reconstructed_intents", []) as Array
        _expect(reconstructed == _codec.pending_intents(_codec.kind_for_sequence(sequence)), "exact reconstructed intent contract %d" % sequence)
        runtime.queue_free()
        await get_tree().process_frame


func _test_commit_barrier_retry() -> void:
    _stored_checkpoints.clear()
    _last_sequence = 0
    _fail_sequence = 2
    var runtime := RuntimeScene.instantiate()
    _expect_ok(runtime.call("configure_player_session", {
        "startup_intent": "fresh_session",
        "checkpoint_commit_sink": Callable(self, "_memory_sink"),
    }) as Dictionary, "barrier runtime config")
    add_child(runtime)
    await get_tree().process_frame
    runtime.set_process(false)
    var failed: Dictionary = runtime.call("test_advance_player_to_next_checkpoint") as Dictionary
    _expect(not bool(failed.get("ok", true)), "injected persistence failure blocks advancement")
    var blocked := runtime.call("player_checkpoint_snapshot") as Dictionary
    _expect(int(blocked.get("checkpoint_sequence", 0)) == 1, "failed cursor rolls back to previous durable state")
    _expect(bool(blocked.get("barrier_failed", false)), "barrier remains failed")
    _expect((blocked.get("pending_intents", []) as Array).is_empty(), "no automatic task starts behind failed ACK")
    _fail_sequence = -1
    var retried: Dictionary = runtime.call("retry_player_checkpoint_commit") as Dictionary
    _expect_ok(retried, "explicit retry succeeds")
    var committed := runtime.call("player_checkpoint_snapshot") as Dictionary
    _expect(int(committed.get("checkpoint_sequence", 0)) == 2, "retry commits same staged next cursor")
    _expect(not bool(committed.get("barrier_failed", true)), "retry releases barrier")
    runtime.queue_free()
    await get_tree().process_frame


func _memory_sink(checkpoint: Dictionary) -> Dictionary:
    var validation := _codec.validate_checkpoint(checkpoint)
    if not bool(validation.get("ok", false)):
        return validation
    var sequence := int(validation["checkpoint_sequence"])
    if sequence == _fail_sequence:
        return {"ok": false, "error": "injected_store_failure"}
    if _last_sequence > 0 and sequence != _last_sequence + 1:
        return {"ok": false, "error": "sequence_not_next"}
    _last_sequence = sequence
    _stored_checkpoints[sequence] = checkpoint.duplicate(true)
    return {"ok": true, "status": "memory_persisted"}


func _expect_ok(result: Dictionary, message: String) -> void:
    _expect(bool(result.get("ok", false)), "%s: %s" % [message, str(result)])


func _expect(condition: bool, message: String) -> void:
    if not condition:
        _failures.append(message)
