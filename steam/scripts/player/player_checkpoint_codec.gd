class_name ShelterPlayerCheckpointCodec
extends RefCounted

const PlayerProfileSchema := preload("res://scripts/persistence/player_profile_schema.gd")

const FORMAT_ID := "shelter.player-checkpoint"
const SCHEMA_VERSION := 1
const FIRST_ORDER_ID := "order.first_warm_delivery"
const FIRST_ORDER_TITLE := "Первая тёплая поставка"
const CHAIN_TEMPLATE_ID := "chain.warm_food_delivery_intro"
const CHAIN_RUN_ID := "run.first_day.first_warm_delivery"
const ROUTE_ID := "route.oat_farm_intro"
const TRANSPORT_ID := "transport.basket_bicycle"
const MEMORY_ID := "memory.first_warm_delivery"
const MEMORY_TEXT := "Помнит первую тёплую поставку"

const TOP_LEVEL_FIELDS := [
    "format_id", "schema_version", "journey", "first_day_history",
    "active_order", "active_chain", "day2", "resources", "world",
]
const JOURNEY_FIELDS := ["phase", "checkpoint_kind", "checkpoint_sequence", "workflow_cursor", "active_day"]
const HISTORY_FIELDS := [
    "order_id", "delivery_confirmed", "postcard_visible", "reward_available",
    "chain_complete", "postcard_life_moment_seen", "first_reward_equipped",
    "first_memory_added", "next_day_hint_available", "dachshund", "packing_note_visible",
]
const DACHSHUND_HISTORY_FIELDS := ["slippers_equipped", "memory_id", "memory_text"]
const ORDER_FIELDS := [
    "id", "title", "status", "status_history", "delivery_state",
    "delivery_confirmed", "completed", "postcard_created", "reward_created", "equip_task_created",
]
const CHAIN_FIELDS := [
    "template_id", "run_id", "state", "state_history", "current_step", "route_id", "transport_id",
]
const DAY2_FIELDS := [
    "return_moment_seen", "yesterday_postcard_visible", "dachshund_slippers_visible",
    "dachshund_memory_inspectable", "packing_note_visible", "second_order_available",
    "return_has_no_urgent_prompt", "absence_penalty_applied",
    "labrador_packing_care_moment_seen", "second_delivery_completed",
    "second_feedback_visible", "curiosity_question_available", "curiosity_is_optional_hint",
    "quiet_end_state_reached",
]
const RESOURCE_CONTAINER_FIELDS := [
    "storage", "transport_payload", "kitchen", "packing_table", "delivery_van_endpoint", "delivered",
]
const RESOURCE_FIELDS := ["oat_crate", "pumpkin_crate", "protein_packet", "packaging_bag", "food_mix", "food_bag"]
const WORLD_FIELDS := [
    "route_started", "route_payload_returned", "transport_state", "transport_has_payload",
    "van_loaded", "delivery_confirmed", "delivery_complete", "postcard_visible",
    "reward_available", "slippers_equip_requested", "slippers_equipped",
]
const FORBIDDEN_FIELDS := [
    "task_queue", "current_task", "current_step_index", "step_time", "elapsed_seconds",
    "timing_scale", "next_task_number", "event_log", "events", "next_event_number",
    "dog_assignments", "active_research", "active_fixture_id", "active_save_file",
    "debug_speed_multiplier", "runtime_start_fixture", "runtime_load_local_save",
    "connector", "connector_control", "state_connector", "state_connector_control",
    "capture", "capture_history", "capture_dir", "x", "y",
]

const KINDS := [
    "first_day_offered",
    "first_day_route_confirmed",
    "first_day_payload_returned",
    "first_day_oat_stored",
    "first_day_resources_available",
    "first_day_oat_in_kitchen",
    "first_day_pumpkin_in_kitchen",
    "first_day_inputs_in_kitchen",
    "first_day_food_mix_ready",
    "first_day_food_mix_at_packing",
    "first_day_inputs_at_packing",
    "first_day_food_bag_ready",
    "first_day_ready_to_dispatch",
    "first_day_dispatch_confirmed",
    "first_day_delivery_response",
    "first_day_equip_confirmed",
    "first_day_complete",
]

const ORDER_HISTORIES := [
    ["route_suggested"],
    ["route_suggested", "trip_active"],
    ["route_suggested", "trip_active", "resources_available"],
    ["route_suggested", "trip_active", "resources_available", "production_in_progress"],
    ["route_suggested", "trip_active", "resources_available", "production_in_progress", "packed"],
    ["route_suggested", "trip_active", "resources_available", "production_in_progress", "packed", "loaded"],
    ["route_suggested", "trip_active", "resources_available", "production_in_progress", "packed", "loaded", "sent"],
    ["route_suggested", "trip_active", "resources_available", "production_in_progress", "packed", "loaded", "sent", "completed"],
]

const CHAIN_HISTORIES := [
    ["not_started"],
    ["not_started", "payload_returned"],
    ["not_started", "payload_returned", "stored", "inputs_to_kitchen"],
    ["not_started", "payload_returned", "stored", "inputs_to_kitchen", "cooking", "food_mix_ready", "moving_to_packing"],
    ["not_started", "payload_returned", "stored", "inputs_to_kitchen", "cooking", "food_mix_ready", "moving_to_packing", "packing_ready"],
    ["not_started", "payload_returned", "stored", "inputs_to_kitchen", "cooking", "food_mix_ready", "moving_to_packing", "packing_ready", "packing", "food_bag_ready"],
    ["not_started", "payload_returned", "stored", "inputs_to_kitchen", "cooking", "food_mix_ready", "moving_to_packing", "packing_ready", "packing", "food_bag_ready", "ready_to_dispatch"],
    ["not_started", "payload_returned", "stored", "inputs_to_kitchen", "cooking", "food_mix_ready", "moving_to_packing", "packing_ready", "packing", "food_bag_ready", "ready_to_dispatch", "dispatched"],
    ["not_started", "payload_returned", "stored", "inputs_to_kitchen", "cooking", "food_mix_ready", "moving_to_packing", "packing_ready", "packing", "food_bag_ready", "ready_to_dispatch", "dispatched", "completed"],
]

var _profile_schema := PlayerProfileSchema.new()


func checkpoint_kinds() -> Array[String]:
    var result: Array[String] = []
    result.assign(KINDS)
    return result


func sequence_for_kind(kind: String) -> int:
    return KINDS.find(kind) + 1


func kind_for_sequence(sequence: int) -> String:
    if sequence < 1 or sequence > KINDS.size():
        return ""
    return str(KINDS[sequence - 1])


func next_kind(kind: String) -> String:
    return kind_for_sequence(sequence_for_kind(kind) + 1)


func build_golden_checkpoint(kind: String) -> Dictionary:
    var sequence := sequence_for_kind(kind)
    if sequence == 0:
        return {}
    return {
        "format_id": FORMAT_ID,
        "schema_version": SCHEMA_VERSION,
        "journey": {
            "phase": "first_day_complete_hold" if sequence == 17 else "first_day",
            "checkpoint_kind": kind,
            "checkpoint_sequence": sequence,
            "workflow_cursor": kind,
            "active_day": 1,
        },
        "first_day_history": _history_for_sequence(sequence),
        "active_order": _order_for_sequence(sequence),
        "active_chain": _chain_for_sequence(sequence),
        "day2": _empty_day2(),
        "resources": _resources_for_sequence(sequence),
        "world": _world_for_sequence(sequence),
    }


func validate_checkpoint(checkpoint: Dictionary, envelope_mirror: Dictionary = {}) -> Dictionary:
    var type_result := _validate_json_shape(checkpoint, 1)
    if not bool(type_result.get("ok", false)):
        return type_result
    var fields_result := _exact_fields(checkpoint, TOP_LEVEL_FIELDS, "checkpoint_fields")
    if not bool(fields_result.get("ok", false)):
        return fields_result
    if str(checkpoint.get("format_id", "")) != FORMAT_ID or checkpoint.get("schema_version") != SCHEMA_VERSION:
        return _error("checkpoint_identity_invalid")
    if not checkpoint.get("journey") is Dictionary:
        return _error("journey_not_dictionary")
    var journey := checkpoint["journey"] as Dictionary
    var journey_fields := _exact_fields(journey, JOURNEY_FIELDS, "journey_fields")
    if not bool(journey_fields.get("ok", false)):
        return journey_fields
    var kind := str(journey.get("checkpoint_kind", ""))
    var sequence := sequence_for_kind(kind)
    if sequence == 0:
        return _error("unknown_checkpoint_kind")
    if journey.get("checkpoint_sequence") != sequence or str(journey.get("workflow_cursor", "")) != kind:
        return _error("checkpoint_sequence_cursor_mismatch")
    if not envelope_mirror.is_empty():
        if str(envelope_mirror.get("journey_phase", "")) != str(journey.get("phase", "")):
            return _error("envelope_journey_phase_mismatch")
        if str(envelope_mirror.get("checkpoint_kind", "")) != kind:
            return _error("envelope_checkpoint_kind_mismatch")
        if envelope_mirror.get("checkpoint_sequence") != sequence:
            return _error("envelope_checkpoint_sequence_mismatch")
    var expected := build_golden_checkpoint(kind)
    if checkpoint != expected:
        return _error("checkpoint_golden_state_mismatch", {"checkpoint_kind": kind})
    var canonical := _profile_schema.canonicalize(checkpoint)
    if not bool(canonical.get("ok", false)):
        return _error("checkpoint_not_canonicalizable")
    return {
        "ok": true,
        "checkpoint_contract_valid": true,
        "playable_profile": true,
        "checkpoint": checkpoint.duplicate(true),
        "checkpoint_kind": kind,
        "checkpoint_sequence": sequence,
        "checkpoint_digest": str(canonical["json"]).sha256_text(),
        "pending_intents": pending_intents(kind),
    }


func checkpoint_digest(checkpoint: Dictionary) -> Dictionary:
    var validation := validate_checkpoint(checkpoint)
    if not bool(validation.get("ok", false)):
        return validation
    return {"ok": true, "digest": str(validation["checkpoint_digest"])}


func pending_intents(kind: String) -> Array[Dictionary]:
    match kind:
        "first_day_offered":
            return []
        "first_day_route_confirmed":
            return [_intent("TripTask", "", "road_sign", "road_sign", "object.road_sign", "trip_returned_with_payload", "dachshund_intro")]
        "first_day_payload_returned":
            return [
                _intent("UnloadTask", "oat_crate", "basket_bicycle", "storage", "TripTask", "resource_added_to_storage"),
                _intent("UnloadTask", "pumpkin_crate", "basket_bicycle", "storage", "TripTask", "resource_added_to_storage"),
            ]
        "first_day_oat_stored":
            return [_intent("UnloadTask", "pumpkin_crate", "basket_bicycle", "storage", "TripTask", "resource_added_to_storage")]
        "first_day_resources_available":
            return [
                _intent("CarryTask", "oat_crate", "storage", "kitchen", "object.storage", "resource_delivered"),
                _intent("CarryTask", "pumpkin_crate", "storage", "kitchen", "object.storage", "resource_delivered"),
                _intent("CarryTask", "protein_packet", "storage", "kitchen", "object.storage", "resource_delivered"),
            ]
        "first_day_oat_in_kitchen":
            return [
                _intent("CarryTask", "pumpkin_crate", "storage", "kitchen", "object.storage", "resource_delivered"),
                _intent("CarryTask", "protein_packet", "storage", "kitchen", "object.storage", "resource_delivered"),
            ]
        "first_day_pumpkin_in_kitchen":
            return [_intent("CarryTask", "protein_packet", "storage", "kitchen", "object.storage", "resource_delivered")]
        "first_day_inputs_in_kitchen":
            return [_intent("CookTask", "", "kitchen", "kitchen", "object.kitchen", "food_mix_created")]
        "first_day_food_mix_ready":
            return [
                _intent("CarryTask", "food_mix", "kitchen", "packing_table", "object.kitchen", "resource_delivered"),
                _intent("CarryTask", "packaging_bag", "storage", "packing_table", "object.storage", "resource_delivered"),
            ]
        "first_day_food_mix_at_packing":
            return [_intent("CarryTask", "packaging_bag", "storage", "packing_table", "object.storage", "resource_delivered")]
        "first_day_inputs_at_packing":
            return [_intent("PackTask", "", "packing_table", "packing_table", "object.packing_table", "food_bag_created")]
        "first_day_food_bag_ready":
            return [_intent("LoadVanTask", "food_bag", "packing_table", "delivery_van_endpoint", "object.delivery_van_endpoint", "van_loaded")]
        "first_day_dispatch_confirmed":
            return [_intent("DeliveryTask", "", "", "", "player_confirmed_delivery", "delivery_complete")]
        "first_day_equip_confirmed":
            return [_intent("EquipItemTask", "equipment.comfortable_slippers", "postcard_card", "dachshund_intro", "player_equips_reward", "reward_equipped", "dachshund_intro")]
        _:
            return []


func _intent(type: String, resource_id: String, source: String, target: String, created_by: String, completion_event: String, assigned_dog_id: String = "") -> Dictionary:
    var result := {
        "type": type,
        "resource_id": resource_id,
        "source_object_id": source,
        "target_object_id": target,
        "order_id": FIRST_ORDER_ID,
        "created_by": created_by,
        "completion_event": completion_event,
        "status": "queued",
        "blocks_order_progress": true,
    }
    if assigned_dog_id != "":
        result["assigned_dog_id"] = assigned_dog_id
    return result


func _order_for_sequence(sequence: int) -> Dictionary:
    var history_index := 0
    if sequence >= 2:
        history_index = 1
    if sequence >= 5:
        history_index = 2
    if sequence >= 9:
        history_index = 3
    if sequence >= 12:
        history_index = 4
    if sequence >= 13:
        history_index = 5
    if sequence >= 14:
        history_index = 6
    if sequence >= 15:
        history_index = 7
    var history: Array = ORDER_HISTORIES[history_index].duplicate()
    var delivery_state := "waiting_for_food_bag"
    var delivery_confirmed := false
    var completed := false
    var postcard_created := false
    var reward_created := false
    var equip_task_created := false
    if sequence == 13:
        delivery_state = "ready_to_send"
    elif sequence == 14:
        delivery_state = "sending"
        delivery_confirmed = true
    elif sequence >= 15:
        delivery_state = "delivered"
        delivery_confirmed = true
        completed = true
        postcard_created = true
        reward_created = true
        equip_task_created = sequence >= 16
    return {
        "id": FIRST_ORDER_ID,
        "title": FIRST_ORDER_TITLE,
        "status": str(history[history.size() - 1]),
        "status_history": history,
        "delivery_state": delivery_state,
        "delivery_confirmed": delivery_confirmed,
        "completed": completed,
        "postcard_created": postcard_created,
        "reward_created": reward_created,
        "equip_task_created": equip_task_created,
    }


func _chain_for_sequence(sequence: int) -> Dictionary:
    var index := 0
    if sequence >= 3:
        index = 1
    if sequence >= 5:
        index = 2
    if sequence >= 9:
        index = 3
    if sequence >= 11:
        index = 4
    if sequence >= 12:
        index = 5
    if sequence >= 13:
        index = 6
    if sequence >= 14:
        index = 7
    if sequence >= 17:
        index = 8
    var states := ["not_started", "payload_returned", "inputs_to_kitchen", "moving_to_packing", "packing_ready", "food_bag_ready", "ready_to_dispatch", "dispatched", "completed"]
    var steps := ["choose_route", "unload_to_storage", "carry_ingredients_to_kitchen", "carry_inputs_to_packing", "packing_table_ready", "load_food_bag_into_van", "player_confirms_dispatch", "delivery", "complete"]
    return {
        "template_id": CHAIN_TEMPLATE_ID,
        "run_id": CHAIN_RUN_ID,
        "state": str(states[index]),
        "state_history": (CHAIN_HISTORIES[index] as Array).duplicate(),
        "current_step": str(steps[index]),
        "route_id": ROUTE_ID,
        "transport_id": TRANSPORT_ID,
    }


func _history_for_sequence(sequence: int) -> Dictionary:
    if sequence < 15:
        return _history(false, false, false, false, false, false, false, false)
    if sequence < 17:
        return _history(true, true, true, false, true, false, true, false)
    return _history(true, true, true, true, true, true, true, true)


func _history(delivery_confirmed: bool, postcard_visible: bool, reward_available: bool, chain_complete: bool, postcard_seen: bool, equipped: bool, memory_added: bool, hint_available: bool) -> Dictionary:
    return {
        "order_id": FIRST_ORDER_ID,
        "delivery_confirmed": delivery_confirmed,
        "postcard_visible": postcard_visible,
        "reward_available": reward_available,
        "chain_complete": chain_complete,
        "postcard_life_moment_seen": postcard_seen,
        "first_reward_equipped": equipped,
        "first_memory_added": memory_added,
        "next_day_hint_available": hint_available,
        "dachshund": {
            "slippers_equipped": equipped,
            "memory_id": MEMORY_ID if memory_added else null,
            "memory_text": MEMORY_TEXT if memory_added else "",
        },
        "packing_note_visible": hint_available,
    }


func _empty_day2() -> Dictionary:
    var result := {}
    for field in DAY2_FIELDS:
        result[field] = field == "return_has_no_urgent_prompt"
    return result


func _resources_for_sequence(sequence: int) -> Dictionary:
    var result := {}
    for container in RESOURCE_CONTAINER_FIELDS:
        result[container] = _empty_resource_container()
    var storage := result["storage"] as Dictionary
    storage["protein_packet"] = 2 if sequence <= 7 else 1
    storage["packaging_bag"] = 2 if sequence <= 10 else 1
    if sequence == 3:
        (result["transport_payload"] as Dictionary)["oat_crate"] = 1
        (result["transport_payload"] as Dictionary)["pumpkin_crate"] = 1
    elif sequence == 4:
        storage["oat_crate"] = 1
        (result["transport_payload"] as Dictionary)["pumpkin_crate"] = 1
    elif sequence == 5:
        storage["oat_crate"] = 1
        storage["pumpkin_crate"] = 1
    elif sequence == 6:
        (result["kitchen"] as Dictionary)["oat_crate"] = 1
        storage["pumpkin_crate"] = 1
    elif sequence == 7:
        (result["kitchen"] as Dictionary)["oat_crate"] = 1
        (result["kitchen"] as Dictionary)["pumpkin_crate"] = 1
    elif sequence == 8:
        (result["kitchen"] as Dictionary)["oat_crate"] = 1
        (result["kitchen"] as Dictionary)["pumpkin_crate"] = 1
        (result["kitchen"] as Dictionary)["protein_packet"] = 1
    elif sequence == 9:
        (result["kitchen"] as Dictionary)["food_mix"] = 1
    elif sequence == 10:
        (result["packing_table"] as Dictionary)["food_mix"] = 1
    elif sequence == 11:
        (result["packing_table"] as Dictionary)["food_mix"] = 1
        (result["packing_table"] as Dictionary)["packaging_bag"] = 1
    elif sequence == 12:
        (result["packing_table"] as Dictionary)["food_bag"] = 1
    elif sequence in [13, 14]:
        (result["delivery_van_endpoint"] as Dictionary)["food_bag"] = 1
    elif sequence >= 15:
        (result["delivered"] as Dictionary)["food_bag"] = 1
    return result


func _empty_resource_container() -> Dictionary:
    var result := {}
    for resource_id in RESOURCE_FIELDS:
        result[resource_id] = 0
    return result


func _world_for_sequence(sequence: int) -> Dictionary:
    return {
        "route_started": sequence >= 2,
        "route_payload_returned": sequence >= 3,
        "transport_state": "waiting_for_unload" if sequence in [3, 4] else "parked",
        "transport_has_payload": sequence in [3, 4],
        "van_loaded": sequence >= 13,
        "delivery_confirmed": sequence >= 14,
        "delivery_complete": sequence >= 15,
        "postcard_visible": sequence >= 15,
        "reward_available": sequence >= 15,
        "slippers_equip_requested": sequence >= 16,
        "slippers_equipped": sequence >= 17,
    }


func _validate_json_shape(value: Variant, depth: int) -> Dictionary:
    if depth > 32:
        return _error("checkpoint_depth_exceeded")
    if value == null or value is bool or value is String:
        return {"ok": true}
    if value is int:
        var integer := int(value)
        if integer < -PlayerProfileSchema.MAX_SAFE_INTEGER or integer > PlayerProfileSchema.MAX_SAFE_INTEGER:
            return _error("checkpoint_integer_out_of_range")
        return {"ok": true}
    if value is float:
        return _error("checkpoint_float_forbidden")
    if value is Array:
        for item in value as Array:
            var child := _validate_json_shape(item, depth + 1)
            if not bool(child.get("ok", false)):
                return child
        return {"ok": true}
    if value is Dictionary:
        for key in (value as Dictionary).keys():
            if not key is String:
                return _error("checkpoint_key_not_string")
            var key_text := str(key)
            if key_text in FORBIDDEN_FIELDS or key_text.ends_with("_token") or key_text.ends_with("_url"):
                return _error("checkpoint_forbidden_field")
            var child := _validate_json_shape((value as Dictionary)[key], depth + 1)
            if not bool(child.get("ok", false)):
                return child
        return {"ok": true}
    return _error("checkpoint_unsupported_type")


func _exact_fields(value: Dictionary, expected: Array, prefix: String) -> Dictionary:
    if value.size() != expected.size():
        return _error("%s_mismatch" % prefix)
    for field in expected:
        if not value.has(field):
            return _error("%s_missing" % prefix)
    return {"ok": true}


func _error(code: String, details: Dictionary = {}) -> Dictionary:
    var result := {
        "ok": false,
        "error": code,
        "checkpoint_contract_valid": false,
        "playable_profile": false,
    }
    for key in details.keys():
        result[key] = details[key]
    return result
