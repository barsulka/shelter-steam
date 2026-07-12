extends Node

const Codec := preload("res://scripts/player/player_checkpoint_codec.gd")
const RuntimeScene := preload("res://scenes/prototypes/vertical_slice/vertical_slice_demo.tscn")
const PlayerBootScene := preload("res://scenes/player/player_boot.tscn")
const Store := preload("res://scripts/persistence/player_profile_store.gd")
const Schema := preload("res://scripts/persistence/player_profile_schema.gd")

var _codec := Codec.new()
var _failures: Array[String] = []
var _last_sequence := 17
var _stored: Dictionary = {}


func _ready() -> void:
    _run.call_deferred()


func _run() -> void:
    _test_codec_graph()
    _test_fixture_oracle()
    await _test_runtime_transition_and_day2()
    await _test_legacy_profile_upgrade()
    if _failures.is_empty():
        print("player_day2_return_test=passed cursors=33")
        get_tree().quit(0)
    else:
        for failure in _failures:
            push_error(failure)
        print("player_day2_return_test=failed count=%d" % _failures.size())
        get_tree().quit(1)


func _test_codec_graph() -> void:
    var kinds := _codec.all_checkpoint_kinds()
    _expect(kinds.size() == 33, "exact 33-cursor graph")
    for sequence in range(1, 34):
        var kind := _codec.kind_for_sequence(sequence)
        var checkpoint := _codec.build_golden_checkpoint(kind)
        var validation := _codec.validate_checkpoint(checkpoint)
        _expect(bool(validation.get("ok", false)), "cursor %d validates" % sequence)
        _expect(int(validation.get("checkpoint_sequence", 0)) == sequence, "cursor %d ordinal" % sequence)
    var legacy := _codec.build_legacy_golden_checkpoint("first_day_complete")
    var legacy_validation := _codec.validate_checkpoint(legacy)
    _expect(bool(legacy_validation.get("ok", false)), "legacy v1 First Day remains readable")
    _expect(int((legacy_validation.get("checkpoint", {}) as Dictionary).get("schema_version", 0)) == 2, "legacy normalizes to v2 in memory")
    _expect(not bool(_codec.validate_checkpoint(legacy, {
        "payload_format_id": Codec.FORMAT_ID,
        "payload_schema_version": 2,
        "journey_phase": "first_day_complete_hold",
        "checkpoint_kind": "first_day_complete",
        "checkpoint_sequence": 17,
    }).get("ok", true)), "v2 envelope cannot claim a v1 payload")
    var current_first_day := _codec.build_golden_checkpoint("first_day_complete")
    _expect(not bool(_codec.validate_checkpoint(current_first_day, {
        "payload_format_id": Codec.FORMAT_ID,
        "payload_schema_version": 1,
        "journey_phase": "first_day_complete_hold",
        "checkpoint_kind": "first_day_complete",
        "checkpoint_sequence": 17,
    }).get("ok", true)), "v1 envelope cannot claim a v2 payload")
    var offered := _codec.build_golden_checkpoint("day2_offered")
    var resources := offered["resources"] as Dictionary
    var storage := resources["storage"] as Dictionary
    _expect(int(storage["protein_packet"]) == 1 and int(storage["packaging_bag"]) == 1, "transition preserves x1/x1 remainder")
    var quiet := _codec.build_golden_checkpoint("quiet_cooperative")
    _expect((quiet["active_order"] as Dictionary).is_empty(), "quiet active order empty")
    _expect((quiet["active_chain"] as Dictionary).is_empty(), "quiet active chain empty")
    _expect(bool((quiet["day2_history"] as Dictionary)["completed"]), "quiet archives completed Day 2")


func _test_fixture_oracle() -> void:
    var fixture_text := FileAccess.get_file_as_string("res://resources/game_systems/fixtures/second_day_after_first_delivery.json")
    var parsed: Variant = JSON.parse_string(fixture_text)
    _expect(parsed is Dictionary, "D-022 fixture parses as an object")
    if not parsed is Dictionary:
        return
    var state := (parsed as Dictionary).get("state", {}) as Dictionary
    var offered := _codec.build_golden_checkpoint("day2_offered")
    _expect((state.get("first_day_history", {}) as Dictionary) == (offered["first_day_history"] as Dictionary), "real return preserves the exact fixture First Day history")
    _expect((state.get("active_order", {}) as Dictionary) == (offered["active_order"] as Dictionary), "real return matches the fixture active order")
    _expect((state.get("active_chain", {}) as Dictionary) == (offered["active_chain"] as Dictionary), "real return matches the fixture active chain")
    var expected_day2 := (state.get("day2", {}) as Dictionary).duplicate(true)
    expected_day2["return_moment_seen"] = true
    _expect(expected_day2 == (offered["day2"] as Dictionary), "real return differs from fixture only by the observed return moment")
    var inventories := state.get("inventories", {}) as Dictionary
    var offered_resources := offered["resources"] as Dictionary
    _expect(_nonzero_resources(inventories.get("storage", {}) as Dictionary) == _nonzero_resources(offered_resources["storage"] as Dictionary), "fixture and real return share the exact x1/x1 Storage remainder")
    _expect(_nonzero_resources(inventories.get("kitchen_inputs", {}) as Dictionary) == _nonzero_resources(offered_resources["kitchen"] as Dictionary), "fixture and real return share empty Kitchen inputs")
    _expect(_nonzero_resources(inventories.get("packing_table_inputs", {}) as Dictionary) == _nonzero_resources(offered_resources["packing_table"] as Dictionary), "fixture and real return share empty Packing Table inputs")
    _expect((state.get("task_queue", []) as Array).is_empty(), "fixture starts no automatic Day 2 task")
    _expect(_codec.pending_intents("day2_offered").is_empty(), "real return starts no automatic Day 2 task")


func _nonzero_resources(resources: Dictionary) -> Dictionary:
    var result := {}
    for resource_id in resources.keys():
        var count := int(resources[resource_id])
        if count > 0:
            result[resource_id] = count
    return result


func _test_runtime_transition_and_day2() -> void:
    var runtime := RuntimeScene.instantiate()
    var configured: Dictionary = runtime.call("configure_player_session", {
        "startup_intent": "begin_day2_return",
        "checkpoint": _codec.build_golden_checkpoint("first_day_complete"),
        "checkpoint_commit_sink": Callable(self, "_memory_sink"),
    }) as Dictionary
    _expect(bool(configured.get("ok", false)), "Day 2 return configures")
    add_child(runtime)
    await get_tree().process_frame
    runtime.set_process(false)
    var first_export: Dictionary = runtime.call("export_player_safe_checkpoint") as Dictionary
    _expect(bool(first_export.get("ok", false)), "transition exports")
    _expect(int(((first_export.get("checkpoint", {}) as Dictionary)["journey"] as Dictionary)["checkpoint_sequence"]) == 18, "transition durably reaches 18")
    var transition_events := runtime.call("test_player_event_snapshots") as Array
    _expect(_event_index(transition_events, "day2_return_moment_seen") >= 0, "transition emits return moment after ACK")
    _expect(_event_index(transition_events, "resource_added_to_storage") < 0, "transition emits no storage refill event")
    for sequence in range(18, 34):
        var exported: Dictionary = runtime.call("export_player_safe_checkpoint") as Dictionary
        _expect(bool(exported.get("ok", false)), "Day 2 cursor %d exports" % sequence)
        if bool(exported.get("ok", false)):
            _expect((exported["checkpoint"] as Dictionary) == _codec.build_golden_checkpoint(_codec.kind_for_sequence(sequence)), "Day 2 cursor %d equals golden" % sequence)
        if sequence < 33:
            var advanced: Dictionary = runtime.call("test_advance_player_to_next_checkpoint", 5000) as Dictionary
            _expect(bool(advanced.get("ok", false)), "Day 2 cursor %d advances: %s" % [sequence, str(advanced)])
    _expect(_last_sequence == 33, "Day 2 reaches Quiet Cooperative")
    _expect(_stored.size() == 16, "exact 16 Day 2 writes")
    var events := runtime.call("test_player_event_snapshots") as Array
    for required in ["player_confirmed_trip", "trip_task_created", "player_confirmed_delivery", "delivery_task_created", "day2_progress_note_revealed", "day2_curiosity_question_revealed"]:
        _expect(_event_index(events, required) >= 0, "required organic event emitted: %s" % required)
    _expect(_event_index(events, "player_confirmed_trip") < _event_index(events, "trip_task_created"), "trip confirmation precedes TripTask creation")
    _expect(_event_index(events, "player_confirmed_delivery") < _event_index(events, "delivery_task_created"), "dispatch confirmation precedes DeliveryTask creation")
    _expect(_event_index(events, "day2_progress_note_revealed") < _event_index(events, "day2_curiosity_question_revealed"), "progress note precedes curiosity question")
    for event in events:
        if str((event as Dictionary).get("type", "")) in ["task_created", "trip_task_created", "delivery_task_created"]:
            var payload := (event as Dictionary).get("payload", {}) as Dictionary
            _expect(str(payload.get("order_id", "")) == Codec.SECOND_ORDER_ID, "organic task event carries second order id")
    runtime.queue_free()
    await get_tree().process_frame


func _test_legacy_profile_upgrade() -> void:
    var base := "user://player-tests/r48-03-legacy-upgrade"
    _remove_tree(ProjectSettings.globalize_path(base))
    var legacy := _codec.build_legacy_golden_checkpoint("first_day_complete")
    var journey := legacy["journey"] as Dictionary
    var fields := {
        "format_id": Schema.FORMAT_ID,
        "schema_version": Schema.SCHEMA_VERSION,
        "content_build_version": "r48-03-test",
        "profile_id": Schema.PROFILE_ID,
        "journey_phase": journey["phase"],
        "checkpoint_kind": journey["checkpoint_kind"],
        "checkpoint_sequence": journey["checkpoint_sequence"],
        "payload_format_id": Schema.PAYLOAD_FORMAT_ID,
        "payload_schema_version": 1,
        "payload": legacy,
        "written_at_metadata": {"source": "system_utc_diagnostic_only", "iso8601_utc": "2026-07-12T00:00:00Z"},
    }
    var store := Store.new(base, true)
    _expect(bool(store.store_profile(fields, Store.CREATE_AUTHORITY).get("ok", false)), "legacy v1 profile stores")
    var boot := PlayerBootScene.instantiate()
    _expect(bool((boot.call("configure_player_boot", {"profile_base_dir": base, "test_mode": true}) as Dictionary).get("ok", false)), "legacy boot configures")
    add_child(boot)
    await get_tree().process_frame
    _expect(str((boot.call("lifecycle_snapshot") as Dictionary).get("action", "")) == "begin_day2_return", "legacy complete profile offers Day 2 return")
    _expect(bool((boot.call("activate_lifecycle_action") as Dictionary).get("ok", false)), "legacy return persists v2")
    await get_tree().process_frame
    var loaded := store.load_profile_candidate("primary")
    _expect(bool(loaded.get("ok", false)), "upgraded primary loads")
    if bool(loaded.get("ok", false)):
        var envelope := loaded["envelope"] as Dictionary
        _expect(int(envelope["payload_schema_version"]) == 2, "successful transition upgrades payload to v2")
        _expect(int(envelope["checkpoint_sequence"]) == 18, "successful transition writes sequence 18")
    boot.queue_free()
    await get_tree().process_frame
    _remove_tree(ProjectSettings.globalize_path(base))


func _remove_tree(path: String) -> void:
    if not DirAccess.dir_exists_absolute(path):
        return
    var directory := DirAccess.open(path)
    if directory == null:
        return
    directory.list_dir_begin()
    var name := directory.get_next()
    while name != "":
        if name not in [".", ".."]:
            var child := path.path_join(name)
            if directory.current_is_dir():
                _remove_tree(child)
            else:
                DirAccess.remove_absolute(child)
        name = directory.get_next()
    directory.list_dir_end()
    DirAccess.remove_absolute(path)


func _memory_sink(checkpoint: Dictionary) -> Dictionary:
    var validation := _codec.validate_checkpoint(checkpoint)
    if not bool(validation.get("ok", false)):
        return validation
    var sequence := int(validation["checkpoint_sequence"])
    if sequence != _last_sequence + 1:
        return {"ok": false, "error": "sequence_not_next"}
    _last_sequence = sequence
    _stored[sequence] = checkpoint.duplicate(true)
    return {"ok": true, "status": "memory_persisted"}


func _event_index(events: Array, event_type: String) -> int:
    for index in range(events.size()):
        if str((events[index] as Dictionary).get("type", "")) == event_type:
            return index
    return -1


func _expect(condition: bool, message: String) -> void:
    if not condition:
        _failures.append(message)
