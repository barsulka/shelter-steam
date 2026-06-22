class_name ShelterGameSystemsRuntime
extends RefCounted

const RUNTIME_SCHEMA_VERSION := "shelter.game_systems_runtime.v0.1"
const FIXTURE_DIR := "res://resources/game_systems/fixtures"
const LOCAL_SAVE_FILE := "res://.runtime/game_systems_runtime/local_save.json"
const SPEED_PRESETS := [1, 2, 3, 5, 10]
const HOUSE_OF_CURIOSITY_ID := "building.house_of_curiosity"

var debug_speed_multiplier := 1
var active_fixture_id := ""
var active_save_file := ""
var dog_assignments: Dictionary = {}
var active_research: Dictionary = {}
var _events: Array[Dictionary] = []
var _next_event_number := 1


func reset_runtime_state() -> void:
    debug_speed_multiplier = 1
    active_fixture_id = ""
    active_save_file = ""
    dog_assignments.clear()
    active_research.clear()
    _events.clear()
    _next_event_number = 1


func simulation_delta(real_delta: float) -> float:
    return real_delta * float(debug_speed_multiplier)


func set_debug_speed_multiplier(multiplier: int) -> Dictionary:
    if not (multiplier in SPEED_PRESETS):
        return {
            "ok": false,
            "error": "unsupported_speed_multiplier",
            "supported_multipliers": SPEED_PRESETS,
            "requested_multiplier": multiplier,
        }

    debug_speed_multiplier = multiplier
    return {
        "ok": true,
        "speed_multiplier": debug_speed_multiplier,
        "supported_multipliers": SPEED_PRESETS,
    }


func emit_event(elapsed_seconds: float, event_type: String, details := {}) -> Dictionary:
    var event_id := "event.%05d" % _next_event_number
    _next_event_number += 1

    var event := {
        "id": event_id,
        "time": snappedf(elapsed_seconds, 0.001),
        "tag": str(details.get("tag", _default_tag_for_event(event_type))),
        "type": event_type,
        "dog_ids": _string_array(details.get("dog_ids", [])),
        "place_ids": _string_array(details.get("place_ids", [])),
        "building_ids": _string_array(details.get("building_ids", [])),
        "room_ids": _string_array(details.get("room_ids", [])),
        "chain_ids": _string_array(details.get("chain_ids", [])),
        "research_ids": _string_array(details.get("research_ids", [])),
        "message": str(details.get("message", _message_for_event(event_type))),
        "payload": details.get("payload", {}),
    }
    _events.append(event)
    return event


func event_snapshots(limit := 80) -> Array[Dictionary]:
    var result: Array[Dictionary] = []
    var start_index := maxi(_events.size() - limit, 0)
    for index in range(start_index, _events.size()):
        result.append((_events[index] as Dictionary).duplicate(true))
    return result


func event_lines(limit := 5) -> Array[String]:
    var result: Array[String] = []
    var start_index := maxi(_events.size() - limit, 0)
    for index in range(start_index, _events.size()):
        var event := _events[index] as Dictionary
        result.append("%.2f %s" % [float(event.get("time", 0.0)), str(event.get("type", ""))])
    return result


func last_event_type() -> String:
    if _events.is_empty():
        return "ready"
    return str((_events[_events.size() - 1] as Dictionary).get("type", "ready"))


func assign_dog(dog_id: String, assignment: Dictionary) -> Dictionary:
    if dog_id == "":
        return {"ok": false, "error": "missing_dog_id"}

    var normalized := assignment.duplicate(true)
    normalized["dog_id"] = dog_id
    normalized["assigned_at"] = Time.get_datetime_string_from_system(true)
    dog_assignments[dog_id] = normalized
    return {
        "ok": true,
        "dog_id": dog_id,
        "assignment": normalized,
    }


func start_research(node_id: String, room_id: String, dog_ids: Array) -> Dictionary:
    if node_id == "":
        return {"ok": false, "error": "missing_research_node_id"}
    if room_id == "":
        room_id = "room.house_of_curiosity.classroom"

    active_research = {
        "id": node_id,
        "room_id": room_id,
        "state": "in_progress",
        "progress": 0.0,
        "dependencies": _research_dependencies(node_id),
        "unlocks": _research_unlocks(node_id),
        "dog_contributors": _string_array(dog_ids),
        "source_events": [],
        "started_at": Time.get_datetime_string_from_system(true),
    }
    return {
        "ok": true,
        "active_research": active_research.duplicate(true),
    }


func advance_research_progress(delta_seconds: float) -> void:
    if active_research.is_empty():
        return
    var progress := clampf(float(active_research.get("progress", 0.0)) + (delta_seconds / 120.0), 0.0, 1.0)
    active_research["progress"] = progress
    if progress >= 1.0:
        active_research["state"] = "complete"


func build_state(context: Dictionary) -> Dictionary:
    var game := _game_state(context)
    var dogs := _dog_states(context)
    var routes := _route_states(context)
    var chains := _production_chain_states(context)
    var buildings := _building_states(context)
    var rooms := _room_states(buildings)
    var house := _house_of_curiosity_state(context)
    var economy := _economy_state(context)
    var events := event_snapshots()
    var debug := _debug_state(context)

    return {
        "game": game,
        "dogs": dogs,
        "routes": routes,
        "production_chains": chains,
        "buildings": buildings,
        "rooms": rooms,
        "house_of_curiosity": house,
        "economy": economy,
        "events": events,
        "debug": debug,
        "stress_test_signals": _stress_test_signals(dogs, chains, events, rooms),
    }


func export_state(portable_state: Dictionary) -> Dictionary:
    return {
        "schema_version": RUNTIME_SCHEMA_VERSION,
        "exported_at": Time.get_datetime_string_from_system(true),
        "source": "steam_vertical_slice_runtime",
        "runtime": {
            "debug_speed_multiplier": debug_speed_multiplier,
            "active_fixture_id": active_fixture_id,
            "active_save_file": active_save_file,
            "dog_assignments": dog_assignments.duplicate(true),
            "active_research": active_research.duplicate(true),
            "events": event_snapshots(500),
            "next_event_number": _next_event_number,
        },
        "state": portable_state.duplicate(true),
    }


func import_runtime_metadata(payload: Dictionary) -> void:
    var runtime := payload.get("runtime", {}) as Dictionary
    debug_speed_multiplier = int(runtime.get("debug_speed_multiplier", 1))
    if not (debug_speed_multiplier in SPEED_PRESETS):
        debug_speed_multiplier = 1
    active_fixture_id = str(runtime.get("active_fixture_id", ""))
    active_save_file = str(runtime.get("active_save_file", ""))
    dog_assignments = (runtime.get("dog_assignments", {}) as Dictionary).duplicate(true)
    active_research = (runtime.get("active_research", {}) as Dictionary).duplicate(true)
    _events.clear()
    var imported_events := runtime.get("events", []) as Array
    for item in imported_events:
        if item is Dictionary:
            _events.append((item as Dictionary).duplicate(true))
    _next_event_number = maxi(int(runtime.get("next_event_number", _events.size() + 1)), _events.size() + 1)


func parse_state_text(text: String) -> Dictionary:
    var json := JSON.new()
    var error := json.parse(text)
    if error != OK:
        return {
            "ok": false,
            "error": "invalid_json",
            "line": json.get_error_line(),
            "message": json.get_error_message(),
        }
    if not (json.data is Dictionary):
        return {
            "ok": false,
            "error": "json_root_must_be_object",
        }
    return {
        "ok": true,
        "payload": json.data as Dictionary,
    }


func normalize_import_payload(payload: Dictionary) -> Dictionary:
    if payload.has("json"):
        var parsed := parse_state_text(str(payload.get("json", "")))
        if not bool(parsed.get("ok", false)):
            return parsed
        return normalize_import_payload(parsed["payload"] as Dictionary)

    if payload.has("schema_version") and payload.has("state"):
        return {
            "ok": true,
            "payload": payload,
        }

    if payload.has("state"):
        return {
            "ok": true,
            "payload": {
                "schema_version": RUNTIME_SCHEMA_VERSION,
                "runtime": payload.get("runtime", {}),
                "state": payload.get("state", {}),
            },
        }

    return {
        "ok": true,
        "payload": {
            "schema_version": RUNTIME_SCHEMA_VERSION,
            "runtime": payload.get("runtime", {}),
            "state": payload,
        },
    }


func list_fixtures() -> Dictionary:
    var fixtures: Array[Dictionary] = []
    var dir := DirAccess.open(FIXTURE_DIR)
    if dir == null:
        return {
            "ok": false,
            "error": "fixture_dir_unavailable",
            "fixture_dir": ProjectSettings.globalize_path(FIXTURE_DIR),
            "fixtures": fixtures,
        }

    dir.list_dir_begin()
    var file_name := dir.get_next()
    while file_name != "":
        if not dir.current_is_dir() and file_name.ends_with(".json"):
            var loaded := load_fixture(file_name)
            if bool(loaded.get("ok", false)):
                var payload := loaded["payload"] as Dictionary
                fixtures.append({
                    "id": str(payload.get("id", file_name.trim_suffix(".json"))),
                    "file": file_name,
                    "title": str(payload.get("title", file_name)),
                    "description": str(payload.get("description", "")),
                    "schema_version": str(payload.get("schema_version", "")),
                })
            else:
                fixtures.append({
                    "id": file_name.trim_suffix(".json"),
                    "file": file_name,
                    "error": str(loaded.get("error", "invalid_fixture")),
                })
        file_name = dir.get_next()
    dir.list_dir_end()

    fixtures.sort_custom(func(a: Dictionary, b: Dictionary) -> bool: return str(a.get("id", "")) < str(b.get("id", "")))
    return {
        "ok": true,
        "fixture_dir": ProjectSettings.globalize_path(FIXTURE_DIR),
        "fixtures": fixtures,
    }


func load_fixture(fixture_name: String) -> Dictionary:
    var safe_name := _safe_fixture_file_name(fixture_name)
    if safe_name == "":
        return {
            "ok": false,
            "error": "invalid_fixture_name",
            "fixture": fixture_name,
        }

    var path := "%s/%s" % [FIXTURE_DIR, safe_name]
    if not FileAccess.file_exists(path):
        return {
            "ok": false,
            "error": "fixture_not_found",
            "fixture": fixture_name,
            "path": ProjectSettings.globalize_path(path),
        }

    var text := FileAccess.get_file_as_string(path)
    var parsed := parse_state_text(text)
    if not bool(parsed.get("ok", false)):
        parsed["fixture"] = fixture_name
        return parsed

    var payload := parsed["payload"] as Dictionary
    active_fixture_id = str(payload.get("id", safe_name.trim_suffix(".json")))
    return {
        "ok": true,
        "fixture": active_fixture_id,
        "path": ProjectSettings.globalize_path(path),
        "payload": payload,
    }


func write_local_save(export_payload: Dictionary) -> Dictionary:
    var path := ProjectSettings.globalize_path(LOCAL_SAVE_FILE)
    var dir_error := DirAccess.make_dir_recursive_absolute(path.get_base_dir())
    if dir_error != OK:
        return {
            "ok": false,
            "error": "save_dir_failed",
            "path": path,
            "code": dir_error,
        }

    var file := FileAccess.open(LOCAL_SAVE_FILE, FileAccess.WRITE)
    if file == null:
        return {
            "ok": false,
            "error": "save_write_failed",
            "path": path,
        }
    file.store_string(JSON.stringify(export_payload, "  ") + "\n")
    file.close()
    active_save_file = path
    return {
        "ok": true,
        "path": path,
        "schema_version": str(export_payload.get("schema_version", "")),
    }


func load_local_save() -> Dictionary:
    var path := ProjectSettings.globalize_path(LOCAL_SAVE_FILE)
    if not FileAccess.file_exists(LOCAL_SAVE_FILE):
        return {
            "ok": false,
            "error": "save_not_found",
            "path": path,
        }

    var parsed := parse_state_text(FileAccess.get_file_as_string(LOCAL_SAVE_FILE))
    if not bool(parsed.get("ok", false)):
        parsed["path"] = path
        return parsed

    active_save_file = path
    return {
        "ok": true,
        "path": path,
        "payload": parsed["payload"],
    }


func erase_local_save() -> Dictionary:
    var path := ProjectSettings.globalize_path(LOCAL_SAVE_FILE)
    if FileAccess.file_exists(LOCAL_SAVE_FILE):
        var error := DirAccess.remove_absolute(path)
        if error != OK:
            return {
                "ok": false,
                "error": "save_erase_failed",
                "path": path,
                "code": error,
            }
    active_save_file = ""
    return {
        "ok": true,
        "path": path,
        "erased": true,
    }


func local_save_path() -> String:
    return ProjectSettings.globalize_path(LOCAL_SAVE_FILE)


func _game_state(context: Dictionary) -> Dictionary:
    var game := (context.get("game", {}) as Dictionary).duplicate(true)
    game["runtime_schema_version"] = RUNTIME_SCHEMA_VERSION
    game["debug_speed_multiplier"] = debug_speed_multiplier
    game["active_fixture_id"] = active_fixture_id
    return game


func _dog_states(context: Dictionary) -> Array[Dictionary]:
    var result: Array[Dictionary] = []
    var dog_defs := context.get("dog_defs", {}) as Dictionary
    var dogs := context.get("dogs", {}) as Dictionary
    var recent_events := event_snapshots(40)
    for internal_id in dog_defs.keys():
        var dog_def := dog_defs[internal_id] as Dictionary
        var dog := dogs.get(internal_id, {}) as Dictionary
        var dog_key := str(dog_def.get("key", internal_id))
        var assignment := dog_assignments.get(dog_key, dog_assignments.get(internal_id, {})) as Dictionary
        result.append({
            "id": dog_key,
            "internal_id": str(internal_id),
            "display_name": str(dog_def.get("public_name", dog_def.get("name", internal_id))),
            "identity": {
                "type": str(dog_def.get("body", "")),
                "shape_archetype": "long_small" if str(internal_id) == "dachshund_intro" else "large_soft",
                "personality_direction": str(dog_def.get("role", "")),
                "baseline_role": str(dog_def.get("role", "")),
            },
            "character_traits": _character_traits_for_dog(str(internal_id)),
            "innate_traits": [
                {
                    "id": "trait.fast_paws" if str(internal_id) == "dachshund_intro" else "trait.careful_helper",
                    "display_name": str(dog_def.get("trait", "")),
                    "layer": "innate",
                    "tags": _trait_tags_for_dog(str(internal_id)),
                },
            ],
            "learned_habits": _learned_habits_for_dog(str(internal_id), dog),
            "helper_effects": _helper_effects_for_dog(str(internal_id), dog),
            "equipment": _equipment_for_dog(str(internal_id), dog),
            "preferences": _preferences_for_dog(str(internal_id)),
            "activity_experience": _activity_experience_for_dog(str(internal_id), context),
            "current_activity": _current_activity_for_dog(str(internal_id), dog_key, dog, context, assignment),
            "movement_state": _movement_state_for_dog(dog),
            "current_place": _current_place_for_dog(str(internal_id), dog, context, assignment),
            "current_anchor": _current_anchor_for_dog(str(internal_id), context),
            "current_room": str(assignment.get("room_id", "")) if not assignment.is_empty() else null,
            "assignment": assignment if not assignment.is_empty() else null,
            "recent_events": _events_for_dog(dog_key, recent_events),
        })
    return result


func _route_states(context: Dictionary) -> Array[Dictionary]:
    var flags := context.get("flags", {}) as Dictionary
    var transport := context.get("transport", {}) as Dictionary
    return [
        {
            "id": "route.oat_farm_intro",
            "display_name": "Овсяная ферма",
            "state": "active" if bool(flags.get("route_started", false)) and str(transport.get("state", "")) == "away" else ("returned" if bool(flags.get("trip_payload_visible", false)) else "available"),
            "accepted_test_route": true,
            "driver_dog_id": "dog.dachshund_intro",
            "transport_id": "transport.basket_bicycle",
            "from": "object.road_sign",
            "to": "external.oat_farm_intro",
            "outputs": ["resource.oat_crate", "resource.pumpkin_crate"],
            "recent_events": _events_by_tags(["route"], 20),
        },
    ]


func _production_chain_states(context: Dictionary) -> Array[Dictionary]:
    var flags := context.get("flags", {}) as Dictionary
    var inventories := context.get("inventories", {}) as Dictionary
    var storage := inventories.get("storage", {}) as Dictionary
    var kitchen := inventories.get("kitchen_inputs", {}) as Dictionary
    var packing := inventories.get("packing_table_inputs", {}) as Dictionary
    var tokens := context.get("tokens", {}) as Dictionary
    var state := _warm_food_chain_state(context)
    var required_inputs := _required_inputs_for_chain_state(state)
    var available_inputs := _available_chain_inputs(storage, kitchen, packing, tokens)
    return [
        {
            "id": "chain.warm_food_delivery_intro",
            "display_name": "Первая тёплая поставка",
            "state": state,
            "current_step": _warm_food_current_step(state),
            "places": [
                "object.road_sign",
                "transport.basket_bicycle",
                "object.storage",
                "object.kitchen",
                "object.packing_table",
                "object.delivery_van_endpoint",
            ],
            "dogs_involved": _dogs_involved_in_chain(context),
            "required_inputs": required_inputs,
            "available_inputs": available_inputs,
            "outputs": _chain_outputs(flags, tokens),
            "blocked_reason": _chain_blocked_reason(context, state, required_inputs, available_inputs),
            "quality_state": "neatly_packed" if bool(flags.get("pack_enqueued", false)) else "not_evaluated",
            "player_confirmation_required": bool(flags.get("van_loaded", false)) and not bool(flags.get("delivery_confirmed", false)),
            "recent_events": _events_by_tags(["production_chain", "route", "movement"], 30),
        },
    ]


func _building_states(context: Dictionary) -> Array[Dictionary]:
    var anchors := context.get("anchors", {}) as Dictionary
    var result: Array[Dictionary] = []
    for anchor_id in anchors.keys():
        var anchor := anchors[anchor_id] as Dictionary
        result.append({
            "id": str(anchor.get("key", anchor_id)),
            "internal_id": str(anchor_id),
            "type": _building_type(str(anchor_id), str(anchor.get("taxonomy", ""))),
            "display_name": str(anchor.get("label", anchor_id)),
            "main_strip_anchor_state": _anchor_state(str(anchor_id), context),
            "rooms": _rooms_for_anchor(str(anchor_id), context),
            "stations": _stations_for_anchor(str(anchor_id)),
            "assigned_dogs": _assigned_dogs_for_place(str(anchor.get("key", anchor_id))),
            "current_life_activities": _life_activities_for_place(str(anchor.get("key", anchor_id))),
            "queue_state": {
                "queue_ids": _queue_ids_for_anchor(str(anchor_id), context),
            },
            "unlocked_routines": _unlocked_routines_for_anchor(str(anchor_id)),
            "blocked_reason": null,
            "recent_events": _events_for_place(str(anchor.get("key", anchor_id)), 20),
        })

    result.append(_house_of_curiosity_building(context))
    return result


func _room_states(buildings: Array[Dictionary]) -> Array[Dictionary]:
    var result: Array[Dictionary] = []
    for building in buildings:
        for room in (building.get("rooms", []) as Array):
            if room is Dictionary:
                var room_copy := (room as Dictionary).duplicate(true)
                room_copy["building_id"] = str(building.get("id", ""))
                result.append(room_copy)
    return result


func _house_of_curiosity_state(context: Dictionary) -> Dictionary:
    var rooms := _house_rooms(context)
    return {
        "id": HOUSE_OF_CURIOSITY_ID,
        "display_name": "House of Curiosity / Дом любопытства",
        "implemented": true,
        "implementation_level": "runtime_scaffold",
        "rooms": rooms,
        "active_research": active_research.duplicate(true) if not active_research.is_empty() else null,
        "assigned_dogs": _assigned_dogs_for_house(),
        "self_learning_state": "slow_background_learning",
        "progress": float(active_research.get("progress", 0.0)) if not active_research.is_empty() else 0.0,
        "dependencies": active_research.get("dependencies", []) if not active_research.is_empty() else [],
        "unlocks": active_research.get("unlocks", []) if not active_research.is_empty() else [],
        "recent_events": _events_by_tags(["research", "room"], 30),
    }


func _economy_state(context: Dictionary) -> Dictionary:
    var inventories := context.get("inventories", {}) as Dictionary
    var tokens := context.get("tokens", {}) as Dictionary
    return {
        "things": {
            "physical_inventory": inventories.duplicate(true),
            "active_inputs": _active_inputs(inventories),
            "active_outputs": _active_outputs(tokens),
            "tokens": tokens.duplicate(true),
        },
        "life": {
            "dog_time_allocation": _dog_time_allocation(context),
            "inspiration_events": _events_by_tags(["research"], 20),
            "comfort_events": _events_by_types(["reward_created", "reward_equipped"], 20),
            "story_events": _events_by_types(["postcard_created", "delivery_complete"], 20),
            "relationship_events": _events_by_tags(["helper_effect"], 20),
        },
        "cadence": {
            "route_cadence": "prototype_fast" if bool((context.get("flags", {}) as Dictionary).get("route_started", false)) else null,
            "delivery_cadence": "first_delivery" if bool((context.get("flags", {}) as Dictionary).get("delivery_complete", false)) else null,
            "blocked_state_frequency": _events_by_tags(["blocked_state"], 500).size(),
        },
    }


func _debug_state(context: Dictionary) -> Dictionary:
    var debug := (context.get("debug", {}) as Dictionary).duplicate(true)
    debug["runtime_schema_version"] = RUNTIME_SCHEMA_VERSION
    debug["speed_multiplier"] = debug_speed_multiplier
    debug["supported_speed_multipliers"] = SPEED_PRESETS
    debug["fixtures_dir"] = ProjectSettings.globalize_path(FIXTURE_DIR)
    debug["local_save_file"] = local_save_path()
    debug["active_fixture_id"] = active_fixture_id
    debug["active_save_file"] = active_save_file
    debug["event_count"] = _events.size()
    return debug


func _stress_test_signals(dogs: Array[Dictionary], chains: Array[Dictionary], events: Array[Dictionary], rooms: Array[Dictionary]) -> Dictionary:
    return {
        "dog_action_events_recent": _count_events_by_tag(events, "dog_action"),
        "production_events_recent": _count_events_by_tag(events, "production_chain"),
        "story_events_recent": _count_events_by_types(events, ["postcard_created", "delivery_complete", "reward_created"]),
        "raw_inventory_growth_recent": _count_events_by_types(events, ["resource_added_to_storage:oat_crate", "resource_added_to_storage:pumpkin_crate", "food_mix_created", "food_bag_created"]),
        "blocked_states_recent": _count_events_by_tag(events, "blocked_state"),
        "room_activity_events_recent": _count_events_by_tag(events, "room"),
        "dogs_without_identity_fields": _dogs_without_identity_fields(dogs),
        "chains_with_invisible_conversion": _chains_with_invisible_conversion(chains),
        "rooms_visible_to_workbench": rooms.size(),
    }


func _default_tag_for_event(event_type: String) -> String:
    if event_type.contains("trip") or event_type.contains("transport") or event_type.contains("route"):
        return "route"
    if event_type.contains("carry") or event_type.contains("moving") or event_type.contains("left_strip") or event_type.contains("returned"):
        return "movement"
    if event_type.contains("cook") or event_type.contains("pack") or event_type.contains("food") or event_type.contains("van") or event_type.contains("delivery"):
        return "production_chain"
    if event_type.contains("storage") or event_type.contains("kitchen") or event_type.contains("packing"):
        return "building"
    if event_type.contains("research") or event_type.contains("curiosity"):
        return "research"
    if event_type.contains("assign") or event_type.contains("room"):
        return "room"
    if event_type.contains("reward") or event_type.contains("slippers"):
        return "helper_effect"
    if event_type.contains("blocked"):
        return "blocked_state"
    if event_type.contains("debug") or event_type.contains("runtime"):
        return "debug"
    return "dog_action"


func _message_for_event(event_type: String) -> String:
    return event_type.replace("_", " ")


func _string_array(value: Variant) -> Array[String]:
    var result: Array[String] = []
    if value is Array:
        for item in value:
            if item != null and str(item) != "":
                result.append(str(item))
    elif value != null and str(value) != "":
        result.append(str(value))
    return result


func _safe_fixture_file_name(raw_name: String) -> String:
    var name := raw_name.strip_edges()
    if name == "":
        return ""
    if name.contains("/") or name.contains("\\") or name.contains(".."):
        return ""
    if not name.ends_with(".json"):
        name = "%s.json" % name
    return name


func _character_traits_for_dog(internal_id: String) -> Array[String]:
    if internal_id == "dachshund_intro":
        return ["Любопытная", "Смелая"]
    return ["Аккуратная", "Заботливая"]


func _trait_tags_for_dog(internal_id: String) -> Array[String]:
    if internal_id == "dachshund_intro":
        return ["travel", "short_carry", "movement"]
    return ["packing", "unloading", "care"]


func _learned_habits_for_dog(internal_id: String, dog: Dictionary) -> Array[Dictionary]:
    if internal_id == "labrador_intro":
        return [
            {
                "id": "habit.neat_knot",
                "display_name": "Ровный узелок",
                "implementation_level": "fixture_scaffold",
                "active": active_fixture_id == "house_of_curiosity_learning_session",
            },
        ]
    if str(dog.get("equipment", "")) != "":
        return [
            {
                "id": "habit.first_warm_delivery_memory",
                "display_name": "Помнит первую тёплую поставку",
                "implementation_level": "runtime_event_scaffold",
                "active": true,
            },
        ]
    return []


func _helper_effects_for_dog(internal_id: String, dog: Dictionary) -> Array[Dictionary]:
    if str(dog.get("equipment", "")) == "":
        return []
    return [
        {
            "id": "helper.comfortable_slippers",
            "display_name": str(dog.get("equipment", "")),
            "context": "movement",
            "source": "equipment",
        },
    ]


func _equipment_for_dog(_internal_id: String, dog: Dictionary) -> Array[Dictionary]:
    var equipment_name := str(dog.get("equipment", ""))
    if equipment_name == "":
        return []
    return [
        {
            "id": "equipment.comfortable_slippers",
            "display_name": equipment_name,
            "slot": "paws",
        },
    ]


func _preferences_for_dog(internal_id: String) -> Dictionary:
    if internal_id == "dachshund_intro":
        return {
            "travel": 0.8,
            "packing": 0.3,
            "tree_care": 0.2,
        }
    return {
        "travel": 0.4,
        "packing": 0.8,
        "unloading": 0.7,
    }


func _activity_experience_for_dog(internal_id: String, context: Dictionary) -> Dictionary:
    var events := event_snapshots(500)
    var travel := _count_events_by_types(events, ["transport_returned", "trip_timer_complete"])
    var unloading := _count_events_contains(events, "resource_added_to_storage")
    var carrying := _count_events_contains(events, "resource_delivered")
    var cooking := _count_events_by_types(events, ["food_mix_created"])
    var packing := _count_events_by_types(events, ["food_bag_created"])
    if internal_id == "dachshund_intro":
        return {
            "travel": travel,
            "unloading": unloading,
            "carrying": carrying,
            "cooking": 0,
            "packing": 0,
        }
    return {
        "travel": 0,
        "unloading": unloading,
        "carrying": carrying,
        "cooking": cooking,
        "packing": packing,
    }


func _current_activity_for_dog(internal_id: String, dog_key: String, dog: Dictionary, context: Dictionary, assignment: Dictionary) -> Dictionary:
    var current_task := context.get("current_task", {}) as Dictionary
    var assigned_internal := str(current_task.get("assigned_dog_id", ""))
    if assigned_internal == internal_id:
        return {
            "activity_id": _activity_id_from_task(current_task),
            "task_id": str(current_task.get("id", "")),
            "activity_group": _activity_group_from_task(current_task, dog),
            "activity_detail": _activity_detail_from_task(current_task, dog),
            "source_object": _object_key(str(current_task.get("source_object_id", ""))),
            "target_object": _object_key(str(current_task.get("target_object_id", ""))),
            "carried_resource": _resource_key(str(dog.get("carried_resource", ""))),
            "current_visible_phase": str(current_task.get("status", "")),
            "blocked_reason": str(current_task.get("failure_or_block_reason", "")) if current_task.has("failure_or_block_reason") else null,
            "assignment_source": "system_assigned",
            "location": _current_place_for_dog(internal_id, dog, context, assignment),
        }
    if not assignment.is_empty():
        return {
            "activity_id": str(assignment.get("activity_id", "activity.assignment")),
            "task_id": null,
            "activity_group": str(assignment.get("activity_group", "learning")),
            "activity_detail": str(assignment.get("activity_detail", "assigned_room_activity")),
            "source_object": null,
            "target_object": str(assignment.get("room_id", "")),
            "carried_resource": null,
            "current_visible_phase": "assigned",
            "blocked_reason": null,
            "assignment_source": "dev_assigned",
            "location": str(assignment.get("room_id", "")),
        }
    return {
        "activity_id": "activity.idle",
        "task_id": null,
        "activity_group": "idle",
        "activity_detail": str(dog.get("state", "idle")),
        "source_object": null,
        "target_object": null,
        "carried_resource": null,
        "current_visible_phase": str(dog.get("state", "idle")),
        "blocked_reason": null,
        "assignment_source": "idle",
        "location": _current_place_for_dog(internal_id, dog, context, assignment),
    }


func _movement_state_for_dog(dog: Dictionary) -> Dictionary:
    var state := str(dog.get("state", "idle"))
    return {
        "state": state,
        "world_x": float(dog.get("x", 0.0)),
        "visible": bool(dog.get("visible", true)),
        "is_moving": state in ["walking", "moving_to_transport", "leaving_with_transport", "returning_with_transport", "carrying_item"],
        "carried_resource": _resource_key(str(dog.get("carried_resource", ""))),
    }


func _current_place_for_dog(internal_id: String, dog: Dictionary, context: Dictionary, assignment: Dictionary) -> String:
    if not assignment.is_empty() and str(assignment.get("room_id", "")) != "":
        return str(assignment.get("room_id", ""))
    var current_task := context.get("current_task", {}) as Dictionary
    if str(current_task.get("assigned_dog_id", "")) == internal_id:
        var target := str(current_task.get("target_object_id", ""))
        var source := str(current_task.get("source_object_id", ""))
        if str(current_task.get("status", "")).begins_with("moving_to_target") and target != "":
            return _object_key(target)
        if source != "":
            return _object_key(source)
    if not bool(dog.get("visible", true)):
        return "external.route"
    return "main_strip"


func _current_anchor_for_dog(internal_id: String, context: Dictionary) -> Variant:
    var current_task := context.get("current_task", {}) as Dictionary
    if str(current_task.get("assigned_dog_id", "")) != internal_id:
        return null
    var target: Variant = _object_key(str(current_task.get("target_object_id", "")))
    return target


func _events_for_dog(dog_key: String, events: Array[Dictionary]) -> Array[Dictionary]:
    var result: Array[Dictionary] = []
    for event in events:
        if dog_key in (event.get("dog_ids", []) as Array):
            result.append(event.duplicate(true))
    return result


func _activity_id_from_task(task: Dictionary) -> String:
    return "activity.%s" % str(task.get("type", "task")).to_snake_case()


func _activity_group_from_task(task: Dictionary, dog: Dictionary) -> String:
    var type := str(task.get("type", ""))
    var state := str(dog.get("state", ""))
    if type == "TripTask":
        return "route"
    if type in ["CarryTask", "UnloadTask", "LoadVanTask"] or state in ["walking", "carrying_item", "loading", "unloading"]:
        return "movement"
    if type in ["CookTask", "PackTask"]:
        return "production"
    if type == "EquipItemTask":
        return "helper_effect"
    return "activity"


func _activity_detail_from_task(task: Dictionary, dog: Dictionary) -> String:
    var type := str(task.get("type", ""))
    var state := str(dog.get("state", ""))
    match type:
        "TripTask":
            if state == "away_on_trip":
                return "traveling_to_oat_farm"
            if state == "returning_with_transport":
                return "returning_with_basket_bicycle"
            return "walking_to_basket_bicycle"
        "UnloadTask":
            return "unloading_to_storage"
        "CarryTask":
            return "carrying_%s" % str(task.get("resource_id", "resource"))
        "CookTask":
            return "preparing_food_mix"
        "PackTask":
            return "packing_food_bag"
        "LoadVanTask":
            return "loading_delivery_van"
        "EquipItemTask":
            return "receiving_comfortable_slippers"
        _:
            return state


func _warm_food_chain_state(context: Dictionary) -> String:
    var flags := context.get("flags", {}) as Dictionary
    var current_task := context.get("current_task", {}) as Dictionary
    var task_type := str(current_task.get("type", ""))
    if bool(flags.get("chain_complete", false)):
        return "completed"
    if bool(flags.get("postcard_visible", false)):
        return "postcard_available"
    if bool(flags.get("delivery_confirmed", false)):
        return "dispatched"
    if bool(flags.get("van_loaded", false)):
        return "ready_to_dispatch"
    if task_type == "LoadVanTask":
        return "loading_van"
    if bool(flags.get("pack_enqueued", false)) and not bool(flags.get("load_van_enqueued", false)):
        return "packing"
    if bool(flags.get("packing_carries_enqueued", false)) and not bool(flags.get("pack_enqueued", false)):
        return "moving_to_packing"
    if bool(flags.get("cook_enqueued", false)) and not bool(flags.get("packing_carries_enqueued", false)):
        return "cooking"
    if bool(flags.get("kitchen_carries_enqueued", false)) and not bool(flags.get("cook_enqueued", false)):
        return "inputs_to_kitchen"
    if bool(flags.get("trip_payload_visible", false)):
        return "payload_returned"
    if bool(flags.get("route_started", false)):
        return "trip_active"
    return "not_started"


func _warm_food_current_step(state: String) -> String:
    match state:
        "not_started":
            return "choose_route"
        "trip_active":
            return "depart_or_return"
        "payload_returned":
            return "unload_to_storage"
        "inputs_to_kitchen":
            return "carry_ingredients_to_kitchen"
        "cooking":
            return "prepare_food_mix"
        "moving_to_packing":
            return "carry_food_mix_to_packing"
        "packing":
            return "pack_food_bag"
        "loading_van":
            return "load_food_bag_into_van"
        "ready_to_dispatch":
            return "player_confirms_dispatch"
        "dispatched":
            return "delivery"
        "postcard_available":
            return "postcard_and_reward"
        "completed":
            return "complete"
        _:
            return state


func _required_inputs_for_chain_state(state: String) -> Array[String]:
    if state in ["cooking", "inputs_to_kitchen"]:
        return ["resource.oat_crate", "resource.pumpkin_crate", "resource.protein_packet"]
    if state in ["moving_to_packing", "packing"]:
        return ["resource.food_mix", "resource.packaging_bag"]
    if state in ["loading_van", "ready_to_dispatch"]:
        return ["resource.food_bag"]
    return []


func _available_chain_inputs(storage: Dictionary, kitchen: Dictionary, packing: Dictionary, tokens: Dictionary) -> Array[String]:
    var result: Array[String] = []
    for resource_id in ["oat_crate", "pumpkin_crate", "protein_packet"]:
        if int(storage.get(resource_id, 0)) > 0:
            result.append(_resource_key(resource_id))
    for resource_id in ["oat_crate", "pumpkin_crate", "protein_packet"]:
        if int(kitchen.get(resource_id, 0)) > 0:
            result.append(_resource_key(resource_id))
    for resource_id in ["food_mix", "packaging_bag"]:
        if int(packing.get(resource_id, 0)) > 0:
            result.append(_resource_key(resource_id))
    for resource_id in tokens.keys():
        var token := tokens[resource_id] as Dictionary
        if bool(token.get("visible", true)) and str(token.get("location", "")) != "consumed":
            var key: Variant = _resource_key(str(resource_id))
            if not (key in result):
                result.append(key)
    return result


func _chain_outputs(flags: Dictionary, tokens: Dictionary) -> Array[String]:
    var result: Array[String] = []
    if tokens.has("food_mix"):
        result.append("resource.food_mix")
    if tokens.has("food_bag"):
        result.append("resource.food_bag")
    if bool(flags.get("delivery_complete", false)):
        result.append("delivery.first_warm_delivery")
    if bool(flags.get("postcard_visible", false)):
        result.append("story.postcard.first_warm_delivery")
    return result


func _chain_blocked_reason(_context: Dictionary, state: String, required_inputs: Array[String], available_inputs: Array[String]) -> Variant:
    if state == "ready_to_dispatch":
        return "waiting_for_player_confirmation"
    for required in required_inputs:
        if not (required in available_inputs):
            return "missing_input"
    return null


func _dogs_involved_in_chain(context: Dictionary) -> Array[String]:
    var result: Array[String] = []
    var dogs := context.get("dogs", {}) as Dictionary
    for internal_id in dogs.keys():
        var dog := dogs[internal_id] as Dictionary
        if str(dog.get("current_task", "")) != "" or str(dog.get("equipment", "")) != "":
            result.append("dog.dachshund_intro" if str(internal_id) == "dachshund_intro" else "dog.labrador_intro")
    if result.is_empty():
        result = ["dog.dachshund_intro", "dog.labrador_intro"]
    return result


func _building_type(anchor_id: String, taxonomy: String) -> String:
    match anchor_id:
        "road_sign":
            return "route_edge"
        "storage":
            return "storage"
        "kitchen":
            return "kitchen"
        "packing_table":
            return "packing_area"
        "delivery_van_endpoint":
            return "dispatch"
        _:
            return taxonomy.to_snake_case()


func _anchor_state(anchor_id: String, context: Dictionary) -> Dictionary:
    var legacy_states := context.get("anchor_states", {}) as Dictionary
    return {
        "state": str(legacy_states.get(anchor_id, "available")),
        "visible_on_main_strip": true,
        "implemented": true,
    }


func _rooms_for_anchor(anchor_id: String, _context: Dictionary) -> Array[Dictionary]:
    match anchor_id:
        "storage":
            return [_room("room.storage.shelf_room", "shelf_room", "object.storage")]
        "kitchen":
            return [_room("room.kitchen.mixing_room", "mixing_room", "object.kitchen")]
        "packing_table":
            return [_room("room.packing.soft_packing_corner", "packing_room", "object.packing_table")]
        _:
            return []


func _room(id: String, room_type: String, place_id: String) -> Dictionary:
    return {
        "id": id,
        "room_type": room_type,
        "assigned_dogs": _assigned_dogs_for_room(id),
        "current_life_activities": _life_activities_for_place(place_id),
        "stations": [],
        "comfort_level": "not_evaluated",
        "queue_state": {},
        "upgrade_state": {"implemented": false},
        "unlocked_routines": [],
        "blocked_reason": null,
        "recent_events": _events_for_place(id, 20),
        "implementation_level": "runtime_scaffold",
    }


func _stations_for_anchor(anchor_id: String) -> Array[Dictionary]:
    match anchor_id:
        "storage":
            return [{"id": "station.storage.shelf", "type": "storage"}]
        "kitchen":
            return [{"id": "station.kitchen.mixing_table", "type": "mixing"}]
        "packing_table":
            return [{"id": "station.packing.table", "type": "packing"}]
        "road_sign":
            return [{"id": "station.route.road_sign", "type": "route_start"}]
        "delivery_van_endpoint":
            return [{"id": "station.dispatch.van", "type": "dispatch"}]
        _:
            return []


func _queue_ids_for_anchor(anchor_id: String, context: Dictionary) -> Array[String]:
    var result: Array[String] = []
    var current_task := context.get("current_task", {}) as Dictionary
    if _task_touches_anchor(current_task, anchor_id):
        result.append(str(current_task.get("id", "")))
    for task in (context.get("task_queue", []) as Array):
        if task is Dictionary and _task_touches_anchor(task as Dictionary, anchor_id):
            result.append(str((task as Dictionary).get("id", "")))
    return result


func _task_touches_anchor(task: Dictionary, anchor_id: String) -> bool:
    if task.is_empty():
        return false
    if str(task.get("source_object_id", "")) == anchor_id or str(task.get("target_object_id", "")) == anchor_id:
        return true
    if anchor_id == "road_sign" and str(task.get("type", "")) == "TripTask":
        return true
    if anchor_id == "delivery_van_endpoint" and str(task.get("type", "")) == "DeliveryTask":
        return true
    return false


func _unlocked_routines_for_anchor(anchor_id: String) -> Array[String]:
    if anchor_id == "packing_table" and not active_research.is_empty() and str(active_research.get("id", "")) == "research.soft_packing":
        return ["routine.soft_packing"]
    return []


func _house_of_curiosity_building(context: Dictionary) -> Dictionary:
    return {
        "id": HOUSE_OF_CURIOSITY_ID,
        "internal_id": "house_of_curiosity",
        "type": "house_of_curiosity",
        "display_name": "House of Curiosity / Дом любопытства",
        "main_strip_anchor_state": {
            "state": "learning_available",
            "visible_on_main_strip": false,
            "implemented": true,
            "implementation_level": "runtime_scaffold",
        },
        "rooms": _house_rooms(context),
        "stations": [],
        "assigned_dogs": _assigned_dogs_for_house(),
        "current_life_activities": _life_activities_for_place(HOUSE_OF_CURIOSITY_ID),
        "queue_state": {},
        "unlocked_routines": active_research.get("unlocks", []) if not active_research.is_empty() else [],
        "blocked_reason": null,
        "recent_events": _events_by_tags(["research", "room"], 30),
    }


func _house_rooms(_context: Dictionary) -> Array[Dictionary]:
    var room_specs := [
        ["room.house_of_curiosity.classroom", "classroom"],
        ["room.house_of_curiosity.library", "library"],
        ["room.house_of_curiosity.notes_room", "notes_room"],
        ["room.house_of_curiosity.soft_methods_workshop", "soft_methods_workshop"],
        ["room.house_of_curiosity.observation_corner", "observation_corner"],
        ["room.house_of_curiosity.trial_table", "trial_table"],
    ]
    var result: Array[Dictionary] = []
    for spec in room_specs:
        var room_id := str(spec[0])
        result.append({
            "id": room_id,
            "room_type": str(spec[1]),
            "assigned_dogs": _assigned_dogs_for_room(room_id),
            "current_life_activities": _life_activities_for_place(room_id),
            "stations": _house_stations_for_room(room_id),
            "self_learning_state": "available",
            "progress_state": _room_progress_state(room_id),
            "queue_state": {},
            "unlocked_routines": _room_unlocks(room_id),
            "blocked_reason": null,
            "recent_events": _events_for_place(room_id, 20),
            "implementation_level": "runtime_scaffold",
        })
    return result


func _house_stations_for_room(room_id: String) -> Array[Dictionary]:
    if room_id.ends_with("classroom"):
        return [{"id": "station.curiosity.classroom_board", "type": "checklist_board"}]
    if room_id.ends_with("library"):
        return [{"id": "station.curiosity.library_shelf", "type": "bookshelf"}]
    if room_id.ends_with("soft_methods_workshop"):
        return [{"id": "station.curiosity.soft_packing_practice", "type": "practice_table"}]
    return []


func _room_progress_state(room_id: String) -> Dictionary:
    if not active_research.is_empty() and str(active_research.get("room_id", "")) == room_id:
        return {
            "active_research_id": str(active_research.get("id", "")),
            "state": str(active_research.get("state", "")),
            "progress": float(active_research.get("progress", 0.0)),
        }
    return {
        "active_research_id": null,
        "state": "idle",
        "progress": 0.0,
    }


func _room_unlocks(room_id: String) -> Array:
    if not active_research.is_empty() and str(active_research.get("room_id", "")) == room_id:
        return active_research.get("unlocks", []) as Array
    return []


func _assigned_dogs_for_house() -> Array[String]:
    var result: Array[String] = []
    for dog_id in dog_assignments.keys():
        var assignment := dog_assignments[dog_id] as Dictionary
        if str(assignment.get("room_id", "")).begins_with("room.house_of_curiosity"):
            result.append(str(dog_id))
    return result


func _assigned_dogs_for_room(room_id: String) -> Array[String]:
    var result: Array[String] = []
    for dog_id in dog_assignments.keys():
        var assignment := dog_assignments[dog_id] as Dictionary
        if str(assignment.get("room_id", "")) == room_id:
            result.append(str(dog_id))
    return result


func _assigned_dogs_for_place(place_id: String) -> Array[String]:
    var result: Array[String] = []
    for dog_id in dog_assignments.keys():
        var assignment := dog_assignments[dog_id] as Dictionary
        if str(assignment.get("place_id", "")) == place_id:
            result.append(str(dog_id))
    return result


func _life_activities_for_place(place_id: String) -> Array[Dictionary]:
    var result: Array[Dictionary] = []
    for dog_id in dog_assignments.keys():
        var assignment := dog_assignments[dog_id] as Dictionary
        if str(assignment.get("room_id", "")) == place_id or str(assignment.get("place_id", "")) == place_id:
            result.append({
                "dog_id": str(dog_id),
                "activity_group": str(assignment.get("activity_group", "learning")),
                "activity_detail": str(assignment.get("activity_detail", "assigned_activity")),
            })
    return result


func _active_inputs(inventories: Dictionary) -> Array[String]:
    var result: Array[String] = []
    for inventory_id in inventories.keys():
        var inventory := inventories[inventory_id] as Dictionary
        for resource_id in inventory.keys():
            if int(inventory.get(resource_id, 0)) > 0:
                result.append("%s:%s" % [str(inventory_id), _resource_key(str(resource_id))])
    return result


func _active_outputs(tokens: Dictionary) -> Array[String]:
    var result: Array[String] = []
    for resource_id in tokens.keys():
        var token := tokens[resource_id] as Dictionary
        if bool(token.get("visible", true)):
            result.append(_resource_key(str(resource_id)))
    return result


func _dog_time_allocation(context: Dictionary) -> Dictionary:
    var result := {}
    var dogs := context.get("dogs", {}) as Dictionary
    for internal_id in dogs.keys():
        var dog := dogs[internal_id] as Dictionary
        var key := "dog.dachshund_intro" if str(internal_id) == "dachshund_intro" else "dog.labrador_intro"
        var state := str(dog.get("state", "idle"))
        result[key] = "work" if state not in ["idle", "equipped_with_slippers"] else "idle"
    return result


func _events_by_tags(tags: Array, limit: int) -> Array[Dictionary]:
    var result: Array[Dictionary] = []
    for event in event_snapshots(500):
        if event.get("tag", "") in tags:
            result.append(event)
    return result.slice(maxi(result.size() - limit, 0), result.size())


func _events_by_types(types: Array, limit: int) -> Array[Dictionary]:
    var result: Array[Dictionary] = []
    for event in event_snapshots(500):
        if event.get("type", "") in types:
            result.append(event)
    return result.slice(maxi(result.size() - limit, 0), result.size())


func _events_for_place(place_id: String, limit: int) -> Array[Dictionary]:
    var result: Array[Dictionary] = []
    for event in event_snapshots(500):
        var places := event.get("place_ids", []) as Array
        var buildings := event.get("building_ids", []) as Array
        var rooms := event.get("room_ids", []) as Array
        if place_id in places or place_id in buildings or place_id in rooms:
            result.append(event)
    return result.slice(maxi(result.size() - limit, 0), result.size())


func _count_events_by_tag(events: Array[Dictionary], tag: String) -> int:
    var count := 0
    for event in events:
        if str(event.get("tag", "")) == tag:
            count += 1
    return count


func _count_events_by_types(events: Array[Dictionary], types: Array) -> int:
    var count := 0
    for event in events:
        if str(event.get("type", "")) in types:
            count += 1
    return count


func _count_events_contains(events: Array[Dictionary], needle: String) -> int:
    var count := 0
    for event in events:
        if str(event.get("type", "")).contains(needle):
            count += 1
    return count


func _dogs_without_identity_fields(dogs: Array[Dictionary]) -> int:
    var count := 0
    for dog in dogs:
        if (dog.get("identity", {}) as Dictionary).is_empty() or (dog.get("innate_traits", []) as Array).is_empty():
            count += 1
    return count


func _chains_with_invisible_conversion(chains: Array[Dictionary]) -> int:
    var count := 0
    for chain in chains:
        if str(chain.get("state", "")) != "not_started" and (chain.get("dogs_involved", []) as Array).is_empty():
            count += 1
    return count


func _research_dependencies(node_id: String) -> Array[String]:
    match node_id:
        "research.soft_packing":
            return ["object.packing_table"]
        "research.basket_check":
            return ["route.oat_farm_intro"]
        _:
            return []


func _research_unlocks(node_id: String) -> Array[String]:
    match node_id:
        "research.soft_packing":
            return ["routine.soft_packing", "habit_opportunity.neat_knot"]
        "research.basket_check":
            return ["activity.route_preparation", "habit_opportunity.checks_basket"]
        _:
            return ["visibility.workbench_research_state"]


func _object_key(object_id: String) -> Variant:
    match object_id:
        "":
            return null
        "road_sign":
            return "object.road_sign"
        "storage":
            return "object.storage"
        "kitchen":
            return "object.kitchen"
        "packing_table":
            return "object.packing_table"
        "delivery_van_endpoint":
            return "object.delivery_van_endpoint"
        "basket_bicycle":
            return "transport.basket_bicycle"
        "transport_payload":
            return "transport.basket_bicycle.payload"
        "postcard_card":
            return "ui.postcard_card"
        _:
            return object_id


func _resource_key(resource_id: String) -> Variant:
    match resource_id:
        "":
            return null
        "oat_crate":
            return "resource.oat_crate"
        "pumpkin_crate":
            return "resource.pumpkin_crate"
        "protein_packet":
            return "resource.protein_packet"
        "packaging_bag":
            return "resource.packaging_bag"
        "food_mix":
            return "resource.food_mix"
        "food_bag":
            return "resource.food_bag"
        _:
            return resource_id
