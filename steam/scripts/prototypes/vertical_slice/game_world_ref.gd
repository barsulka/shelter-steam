class_name ShelterGameWorldRef
extends RefCounted

signal state_changed
signal task_completed(task: Dictionary)
signal event_emitted(event_name: String, elapsed: float)

const DOG_DEFS := {
    "dachshund_intro": {
        "key": "dog.dachshund_intro",
        "name": "Такса",
        "public_name": "Такса",
        "trait": "Быстрые лапки",
        "role": "первый водитель",
        "body": "dachshund",
        "start_x": 190.0,
        "color": Color(0.76, 0.46, 0.22, 1.0),
        "secondary": Color(0.93, 0.72, 0.48, 1.0),
    },
    "labrador_intro": {
        "key": "dog.labrador_intro",
        "name": "Лабрадор",
        "public_name": "Лабрадор",
        "trait": "Аккуратный помощник",
        "role": "спокойный помощник",
        "body": "labrador",
        "start_x": 360.0,
        "color": Color(0.88, 0.70, 0.38, 1.0),
        "secondary": Color(0.98, 0.88, 0.58, 1.0),
    },
}

const RESOURCE_ORDER := ["oat_crate", "pumpkin_crate", "protein_packet", "packaging_bag", "food_mix", "food_bag"]

const RESOURCE_DEFS := {
    "oat_crate": {"key": "resource.oat_crate", "name": "Oat Crate", "short": "Oat", "taxonomy": "Resource", "color": Color(0.79, 0.67, 0.42, 1.0)},
    "pumpkin_crate": {"key": "resource.pumpkin_crate", "name": "Pumpkin Crate", "short": "Pumpkin", "taxonomy": "Resource", "color": Color(0.91, 0.54, 0.24, 1.0)},
    "protein_packet": {"key": "resource.protein_packet", "name": "Protein Packet", "short": "Protein", "taxonomy": "Resource", "color": Color(0.68, 0.70, 0.62, 1.0)},
    "packaging_bag": {"key": "resource.packaging_bag", "name": "Packaging Bag", "short": "Pack", "taxonomy": "Resource", "color": Color(0.73, 0.82, 0.78, 1.0)},
    "food_mix": {"key": "resource.food_mix", "name": "Food Mix", "short": "Mix", "taxonomy": "Resource", "color": Color(0.72, 0.50, 0.30, 1.0)},
    "food_bag": {"key": "resource.food_bag", "name": "Food Bag", "short": "Food Bag", "taxonomy": "Resource", "color": Color(0.58, 0.74, 0.50, 1.0)},
}

var dogs: Dictionary = {}
var tokens: Dictionary = {}
var storage_inventory: Dictionary = {}
var kitchen_inputs: Dictionary = {}
var packing_inputs: Dictionary = {}

var task_queue: Array[Dictionary] = []
var current_task: Dictionary = {}
var current_step_index := -1
var step_time := 0.0
var next_task_number := 1

var elapsed := 0.0
var timing_scale := 0.72

var route_started := false
var trip_payload_visible := false
var kitchen_carries_enqueued := false
var cook_enqueued := false
var packing_carries_enqueued := false
var pack_enqueued := false
var load_van_enqueued := false
var van_loaded := false
var delivery_confirmed := false
var delivery_complete := false
var postcard_visible := false
var postcard_claimed := false
var reward_available := false
var equip_task_created := false
var slippers_equipped := false
var chain_complete := false

var transport_x := 230.0
var transport_visible := true
var transport_state := "parked"
var transport_has_payload := false
var delivery_state := "waiting_for_food_bag"
var order_state := "route_suggested"

var last_event := "ready"


func reset() -> void:
    dogs.clear()
    for dog_id in DOG_DEFS.keys():
        var dog_def: Dictionary = DOG_DEFS[dog_id]
        dogs[dog_id] = {
            "id": dog_id,
            "x": float(dog_def["start_x"]),
            "visible": true,
            "state": "idle",
            "carried_resource": "",
            "equipment": "",
            "current_task": "",
            "task_label": "IdleTask",
        }

    tokens.clear()
    storage_inventory = {"protein_packet": 1, "packaging_bag": 1}
    kitchen_inputs.clear()
    packing_inputs.clear()
    _create_resource_token("protein_packet", "storage", false)
    _create_resource_token("packaging_bag", "storage", false)

    transport_x = 130.0 + 92.0
    transport_visible = true
    transport_state = "parked"
    transport_has_payload = false
    delivery_state = "waiting_for_food_bag"
    order_state = "route_suggested"
    route_started = false
    trip_payload_visible = false
    kitchen_carries_enqueued = false
    cook_enqueued = false
    packing_carries_enqueued = false
    pack_enqueued = false
    load_van_enqueued = false
    van_loaded = false
    delivery_confirmed = false
    delivery_complete = false
    postcard_visible = false
    postcard_claimed = false
    reward_available = false
    equip_task_created = false
    slippers_equipped = false
    chain_complete = false
    task_queue.clear()
    current_task.clear()
    current_step_index = -1
    step_time = 0.0
    next_task_number = 1
    elapsed = 0.0
    last_event = "ready"


func tick(delta: float) -> void:
    elapsed += delta
    _advance_current_task(delta)
    _try_start_next_task()
    _update_idle_dogs()


func anchor_x(anchor_id: String) -> float:
    if anchor_id == "basket_bicycle" or anchor_id == "transport_payload":
        return transport_x
    if anchor_id == "road_sign":
        return 130.0
    if anchor_id == "storage":
        return 440.0
    if anchor_id == "kitchen":
        return 760.0
    if anchor_id == "packing_table":
        return 1090.0
    if anchor_id == "delivery_van_endpoint":
        return 1450.0
    if anchor_id == "offscreen_left":
        return -160.0
    if DOG_DEFS.has(anchor_id):
        return float((DOG_DEFS[anchor_id] as Dictionary)["start_x"])
    return 0.0


func resolve_world_x(value: Variant) -> float:
    if typeof(value) == TYPE_FLOAT or typeof(value) == TYPE_INT:
        return float(value)
    var key := str(value)
    return anchor_x(key)


func start_route() -> void:
    if route_started:
        return
    route_started = true
    order_state = "trip_active"
    _emit_event("player_confirmed_trip")
    _enqueue_task(_create_trip_task())


func confirm_delivery() -> void:
    if not van_loaded or delivery_confirmed:
        return
    delivery_confirmed = true
    delivery_state = "sending"
    order_state = "sent"
    _emit_event("player_confirmed_delivery")
    _enqueue_task(_create_delivery_task())


func claim_reward() -> void:
    if not postcard_visible or postcard_claimed:
        return
    postcard_claimed = true
    reward_available = true
    order_state = "reward_claimed"
    _emit_event("reward_created")


func equip_slippers() -> void:
    if not reward_available or equip_task_created or slippers_equipped:
        return
    equip_task_created = true
    _enqueue_task(_create_equip_task())


func set_transport_x(x: float) -> void:
    transport_x = x


func set_dog_x(dog_id: String, x: float) -> void:
    if dogs.has(dog_id):
        (dogs[dog_id] as Dictionary)["x"] = x


func set_dog_visible(dog_id: String, visible: bool) -> void:
    if dogs.has(dog_id):
        (dogs[dog_id] as Dictionary)["visible"] = visible


func _create_resource_token(resource_id: String, location: String, from_payload: bool) -> void:
    tokens[resource_id] = {
        "id": resource_id,
        "resource_id": resource_id,
        "location": location,
        "visible": true,
        "carried_by": "",
        "from_payload": from_payload,
    }


func _create_trip_payload() -> void:
    if trip_payload_visible:
        return
    trip_payload_visible = true
    transport_has_payload = true
    _create_resource_token("oat_crate", "transport_payload", true)
    _create_resource_token("pumpkin_crate", "transport_payload", true)
    _emit_event("payload_visible")


func _pickup_resource_for_task(task: Dictionary) -> void:
    var resource_id := str(task.get("resource_id", ""))
    var dog_id := str(task.get("assigned_dog_id", ""))
    if resource_id == "" or dog_id == "" or not tokens.has(resource_id) or not dogs.has(dog_id):
        return

    var source := str(task.get("source_object_id", ""))
    if source == "storage":
        _decrement_inventory(storage_inventory, resource_id)

    var token: Dictionary = tokens[resource_id]
    token["location"] = "carried"
    token["carried_by"] = dog_id
    token["visible"] = true

    var dog: Dictionary = dogs[dog_id]
    dog["carried_resource"] = resource_id
    dog["state"] = "carrying_item"


func _place_resource_for_task(task: Dictionary) -> void:
    var resource_id := str(task.get("resource_id", ""))
    var dog_id := str(task.get("assigned_dog_id", ""))
    var target := str(task.get("target_object_id", ""))
    if resource_id == "" or not tokens.has(resource_id):
        return

    var token: Dictionary = tokens[resource_id]
    token["location"] = target
    token["carried_by"] = ""
    token["visible"] = true

    if dog_id != "" and dogs.has(dog_id):
        var dog: Dictionary = dogs[dog_id]
        dog["carried_resource"] = ""

    match str(task.get("type", "")):
        "UnloadTask":
            _increment_inventory(storage_inventory, resource_id)
            _emit_event("resource_added_to_storage:%s" % resource_id)
        "CarryTask":
            if target == "kitchen":
                _increment_inventory(kitchen_inputs, resource_id)
                _emit_event("resource_delivered_to_kitchen:%s" % resource_id)
            elif target == "packing_table":
                _increment_inventory(packing_inputs, resource_id)
                _emit_event("resource_delivered_to_packing_table:%s" % resource_id)
        "LoadVanTask":
            delivery_state = "ready_to_send"
            _emit_event("van_loaded")


func _complete_cooking() -> void:
    _hide_token("oat_crate")
    _hide_token("pumpkin_crate")
    _hide_token("protein_packet")
    _create_resource_token("food_mix", "kitchen", false)
    _emit_event("food_mix_created")


func _complete_packing() -> void:
    _hide_token("food_mix")
    _hide_token("packaging_bag")
    _create_resource_token("food_bag", "packing_table", false)
    _emit_event("food_bag_created")


func _complete_equipment() -> void:
    var dog: Dictionary = dogs["dachshund_intro"]
    dog["equipment"] = "Удобные тапочки"
    dog["state"] = "equipped_with_slippers"
    slippers_equipped = true
    _emit_event("reward_equipped")


func _hide_token(resource_id: String) -> void:
    if not tokens.has(resource_id):
        return
    var token: Dictionary = tokens[resource_id]
    token["visible"] = false
    token["location"] = "consumed"
    token["carried_by"] = ""


func _maybe_enqueue_kitchen_carries() -> void:
    if kitchen_carries_enqueued:
        return
    if _inventory_count(storage_inventory, "oat_crate") <= 0:
        return
    if _inventory_count(storage_inventory, "pumpkin_crate") <= 0:
        return
    if _inventory_count(storage_inventory, "protein_packet") <= 0:
        return
    kitchen_carries_enqueued = true
    order_state = "resources_available"
    _enqueue_task(_create_carry_task("oat_crate", "storage", "kitchen"))
    _enqueue_task(_create_carry_task("pumpkin_crate", "storage", "kitchen"))
    _enqueue_task(_create_carry_task("protein_packet", "storage", "kitchen"))


func _maybe_enqueue_cook_or_pack_work() -> void:
    if not cook_enqueued:
        var kitchen_ready := (
            _inventory_count(kitchen_inputs, "oat_crate") > 0
            and _inventory_count(kitchen_inputs, "pumpkin_crate") > 0
            and _inventory_count(kitchen_inputs, "protein_packet") > 0
        )
        if kitchen_ready:
            cook_enqueued = true
            _emit_event("kitchen_inputs_ready")
            _enqueue_task(_create_cook_task())
            return

    if not pack_enqueued:
        var packing_ready := (
            _inventory_count(packing_inputs, "food_mix") > 0
            and _inventory_count(packing_inputs, "packaging_bag") > 0
        )
        if packing_ready:
            pack_enqueued = true
            _emit_event("packing_inputs_ready")
            _enqueue_task(_create_pack_task())


func _maybe_enqueue_packing_carries() -> void:
    if packing_carries_enqueued:
        return
    packing_carries_enqueued = true
    _enqueue_task(_create_carry_task("food_mix", "kitchen", "packing_table"))
    _enqueue_task(_create_carry_task("packaging_bag", "storage", "packing_table"))


func _maybe_enqueue_load_van() -> void:
    if load_van_enqueued:
        return
    load_van_enqueued = true
    order_state = "packed"
    _enqueue_task(_create_load_van_task())


func _increment_inventory(inventory: Dictionary, resource_id: String) -> void:
    inventory[resource_id] = int(inventory.get(resource_id, 0)) + 1


func _decrement_inventory(inventory: Dictionary, resource_id: String) -> void:
    inventory[resource_id] = maxi(int(inventory.get(resource_id, 0)) - 1, 0)


func _inventory_count(inventory: Dictionary, resource_id: String) -> int:
    return int(inventory.get(resource_id, 0))


func _update_idle_dogs() -> void:
    for dog_id in dogs.keys():
        var dog: Dictionary = dogs[dog_id]
        if str(dog.get("current_task", "")) != "":
            continue
        if not bool(dog.get("visible", true)):
            continue
        dog["task_label"] = "IdleTask"
        if str(dog.get("state", "")) in ["carrying_item", "unloading", "helping_kitchen", "packing", "loading", "celebrating"]:
            continue
        dog["state"] = "idle"


func _enqueue_task(task: Dictionary) -> void:
    task_queue.append(task)


func _try_start_next_task() -> void:
    if not current_task.is_empty() or task_queue.is_empty():
        return
    current_task = task_queue.pop_front()
    _assign_task_dog(current_task)
    current_step_index = -1
    step_time = 0.0
    _advance_to_next_step()


func _assign_task_dog(task: Dictionary) -> void:
    if str(task.get("type", "")) == "DeliveryTask":
        return
    var dog_id := str(task.get("assigned_dog_id", ""))
    if dog_id == "":
        dog_id = _choose_dog_for_task(task)
        task["assigned_dog_id"] = dog_id
    if dog_id == "":
        task["status"] = "blocked"
        task["failure_or_block_reason"] = "waiting_for_free_dog"
        return
    var dog: Dictionary = dogs[dog_id]
    dog["current_task"] = str(task.get("id", ""))
    dog["task_label"] = str(task.get("type", "Task"))


func _choose_dog_for_task(task: Dictionary) -> String:
    var type := str(task.get("type", ""))
    var resource_id := str(task.get("resource_id", ""))
    if type == "TripTask":
        return "dachshund_intro"
    if type == "UnloadTask":
        return "labrador_intro" if resource_id == "oat_crate" else "dachshund_intro"
    if type == "CarryTask" or type == "LoadVanTask":
        if resource_id in ["oat_crate", "pumpkin_crate", "food_bag"]:
            return "labrador_intro"
        return "dachshund_intro"
    if type == "CookTask" or type == "PackTask":
        return "labrador_intro"
    if type == "EquipItemTask":
        return "dachshund_intro"
    return "labrador_intro"


func _advance_current_task(delta: float) -> void:
    if current_task.is_empty():
        return
    if current_step_index < 0:
        _advance_to_next_step()
        return

    var steps: Array = current_task.get("steps", []) as Array
    if current_step_index >= steps.size():
        _complete_current_task()
        return

    var step: Dictionary = steps[current_step_index] as Dictionary
    step_time += delta
    _apply_step_motion(step)

    if step_time >= _step_duration(step):
        _run_step_operation(str(step.get("on_complete", "")), current_task)
        _advance_to_next_step()


func _advance_to_next_step() -> void:
    var steps: Array = current_task.get("steps", []) as Array
    current_step_index += 1
    step_time = 0.0

    if current_step_index >= steps.size():
        _complete_current_task()
        return

    var step: Dictionary = steps[current_step_index] as Dictionary
    _set_current_task_status(str(step.get("status", "in_progress")))
    _prepare_step_motion(step)
    _run_step_operation(str(step.get("on_start", "")), current_task)


func _set_current_task_status(status: String) -> void:
    current_task["status"] = status
    var dog_id := str(current_task.get("assigned_dog_id", ""))
    if dog_id != "" and dogs.has(dog_id):
        var dog: Dictionary = dogs[dog_id]
        dog["task_label"] = "%s:%s" % [str(current_task.get("type", "Task")), status]


func _prepare_step_motion(step: Dictionary) -> void:
    var dog_id := str(current_task.get("assigned_dog_id", ""))
    if dog_id != "" and dogs.has(dog_id):
        var dog: Dictionary = dogs[dog_id]
        dog["state"] = str(step.get("dog_state", dog.get("state", "idle")))
        if step.has("move_dog_to"):
            dog["move_start_x"] = float(dog.get("x", 0.0))
            dog["move_target_x"] = resolve_world_x(step["move_dog_to"])

    if step.has("move_transport_to"):
        current_task["transport_move_start_x"] = transport_x
        current_task["transport_move_target_x"] = resolve_world_x(step["move_transport_to"])


func _apply_step_motion(step: Dictionary) -> void:
    var duration := _step_duration(step)
    var t := clampf(step_time / duration, 0.0, 1.0)

    var dog_id := str(current_task.get("assigned_dog_id", ""))
    if dog_id != "" and dogs.has(dog_id) and step.has("move_dog_to"):
        var dog: Dictionary = dogs[dog_id]
        dog["x"] = lerpf(float(dog.get("move_start_x", dog.get("x", 0.0))), float(dog.get("move_target_x", dog.get("x", 0.0))), t)

    if step.has("move_transport_to"):
        transport_x = lerpf(
            float(current_task.get("transport_move_start_x", transport_x)),
            float(current_task.get("transport_move_target_x", transport_x)),
            t
        )
        if dog_id != "" and dogs.has(dog_id):
            var transport_dog: Dictionary = dogs[dog_id]
            transport_dog["x"] = transport_x - 24.0


func _step_duration(step: Dictionary) -> float:
    return maxf(float(step.get("duration", 0.1)) * timing_scale, 0.02)


func _complete_current_task() -> void:
    if current_task.is_empty():
        return

    current_task["status"] = "complete"
    var dog_id := str(current_task.get("assigned_dog_id", ""))
    if dog_id != "" and dogs.has(dog_id):
        var dog: Dictionary = dogs[dog_id]
        dog["current_task"] = ""
        dog["task_label"] = "IdleTask"
        if str(dog.get("carried_resource", "")) == "":
            dog["state"] = "idle"

    var completed_task := current_task.duplicate(true)
    current_task.clear()
    current_step_index = -1
    step_time = 0.0

    task_completed.emit(completed_task)
    _handle_task_completed(completed_task)


func _handle_task_completed(task: Dictionary) -> void:
    var type := str(task.get("type", ""))
    match type:
        "TripTask":
            _enqueue_task(_create_unload_task("oat_crate"))
            _enqueue_task(_create_unload_task("pumpkin_crate"))
        "UnloadTask":
            _maybe_enqueue_kitchen_carries()
        "CarryTask":
            _maybe_enqueue_cook_or_pack_work()
        "CookTask":
            _maybe_enqueue_packing_carries()
        "PackTask":
            _maybe_enqueue_load_van()
        "LoadVanTask":
            van_loaded = true
            delivery_state = "ready_to_send"
            order_state = "loaded"
        "DeliveryTask":
            delivery_complete = true
            postcard_visible = true
            order_state = "completed"
            delivery_state = "delivered"
            _emit_event("postcard_created")
        "EquipItemTask":
            chain_complete = true
            _emit_event("chain_complete")


func _run_step_operation(operation: String, task: Dictionary) -> void:
    if operation == "":
        return
    match operation:
        "transport_preparing":
            transport_state = "preparing"
        "transport_left":
            transport_state = "away"
            transport_visible = false
            set_dog_visible(str(task.get("assigned_dog_id", "")), false)
            _emit_event("transport_left_strip")
        "trip_timer_started":
            transport_state = "away"
            _emit_event("trip_timer_started")
        "trip_timer_complete":
            _emit_event("trip_timer_complete")
        "transport_return_start":
            transport_state = "returning"
            transport_x = resolve_world_x("offscreen_left")
            transport_visible = true
            set_dog_visible(str(task.get("assigned_dog_id", "")), true)
        "transport_returned":
            transport_state = "waiting_for_unload"
            _emit_event("transport_returned")
        "create_trip_payload":
            _create_trip_payload()
        "pickup_resource":
            _pickup_resource_for_task(task)
        "place_resource":
            _place_resource_for_task(task)
        "start_cooking":
            order_state = "production_in_progress"
        "complete_cooking":
            _complete_cooking()
        "start_packing":
            order_state = "production_in_progress"
        "complete_packing":
            _complete_packing()
        "start_delivery":
            delivery_state = "leaving_or_sending"
        "complete_delivery":
            _emit_event("delivery_complete")
        "complete_equipment":
            _complete_equipment()


func _new_task(type: String, data: Dictionary) -> Dictionary:
    var task := data.duplicate(true)
    task["id"] = "%s_%03d" % [type, next_task_number]
    task["type"] = type
    task["status"] = "queued"
    task["created_by"] = _task_creator(type)
    task["blocks_order_progress"] = type != "IdleTask"
    next_task_number += 1
    return task


func _task_creator(type: String) -> String:
    match type:
        "TripTask": return "object.road_sign"
        "UnloadTask": return "TripTask"
        "CarryTask": return "object.storage/object.kitchen/object.packing_table"
        "CookTask": return "object.kitchen"
        "PackTask": return "object.packing_table"
        "LoadVanTask": return "object.delivery_van_endpoint"
        "DeliveryTask": return "player_confirmed_delivery"
        "EquipItemTask": return "player_equips_reward"
        _: return "prototype_scheduler"


func _create_trip_task() -> Dictionary:
    return _new_task("TripTask", {
        "source_object_id": "road_sign",
        "target_object_id": "road_sign",
        "assigned_dog_id": "dachshund_intro",
        "transport_id": "basket_bicycle",
        "route_id": "route.oat_farm_intro",
        "order_id": "order.first_warm_delivery",
        "completion_event": "trip_returned_with_payload",
        "steps": [
            {"status": "moving_to_source", "duration": 0.78, "move_dog_to": "basket_bicycle", "dog_state": "moving_to_transport"},
            {"status": "in_progress", "duration": 0.44, "dog_state": "preparing_transport", "on_start": "transport_preparing"},
            {"status": "in_progress", "duration": 0.86, "move_dog_to": "offscreen_left", "move_transport_to": "offscreen_left", "dog_state": "leaving_with_transport", "on_complete": "transport_left"},
            {"status": "in_progress", "duration": 1.55, "dog_state": "away_on_trip", "on_start": "trip_timer_started", "on_complete": "trip_timer_complete"},
            {"status": "in_progress", "duration": 0.88, "move_dog_to": "basket_bicycle", "move_transport_to": "basket_bicycle", "dog_state": "returning_with_transport", "on_start": "transport_return_start", "on_complete": "transport_returned"},
            {"status": "completing", "duration": 0.36, "dog_state": "unloading_or_waiting", "on_complete": "create_trip_payload"},
        ],
    })


func _create_unload_task(resource_id: String) -> Dictionary:
    return _new_task("UnloadTask", {
        "source_object_id": "basket_bicycle",
        "target_object_id": "storage",
        "resource_id": resource_id,
        "completion_event": "resource_added_to_storage",
        "steps": [
            {"status": "moving_to_source", "duration": 0.54, "move_dog_to": "transport_payload", "dog_state": "moving_to_cargo"},
            {"status": "in_progress", "duration": 0.30, "dog_state": "unloading", "on_start": "pickup_resource"},
            {"status": "moving_to_target", "duration": 0.78, "move_dog_to": "storage", "dog_state": "carrying_item"},
            {"status": "completing", "duration": 0.30, "dog_state": "unloading", "on_complete": "place_resource"},
        ],
    })


func _create_carry_task(resource_id: String, source_object_id: String, target_object_id: String) -> Dictionary:
    return _new_task("CarryTask", {
        "source_object_id": source_object_id,
        "target_object_id": target_object_id,
        "resource_id": resource_id,
        "completion_event": "resource_delivered",
        "steps": [
            {"status": "moving_to_source", "duration": 0.52, "move_dog_to": source_object_id, "dog_state": "walking"},
            {"status": "in_progress", "duration": 0.26, "dog_state": "carrying_item", "on_start": "pickup_resource"},
            {"status": "moving_to_target", "duration": 0.76, "move_dog_to": target_object_id, "dog_state": "carrying_item"},
            {"status": "completing", "duration": 0.28, "dog_state": "carrying_item", "on_complete": "place_resource"},
        ],
    })


func _create_cook_task() -> Dictionary:
    return _new_task("CookTask", {
        "source_object_id": "kitchen",
        "target_object_id": "kitchen",
        "completion_event": "food_mix_created",
        "steps": [
            {"status": "moving_to_source", "duration": 0.45, "move_dog_to": "kitchen", "dog_state": "walking"},
            {"status": "in_progress", "duration": 1.18, "dog_state": "helping_kitchen", "on_start": "start_cooking"},
            {"status": "completing", "duration": 0.26, "dog_state": "helping_kitchen", "on_complete": "complete_cooking"},
        ],
    })


func _create_pack_task() -> Dictionary:
    return _new_task("PackTask", {
        "source_object_id": "packing_table",
        "target_object_id": "packing_table",
        "completion_event": "food_bag_created",
        "steps": [
            {"status": "moving_to_source", "duration": 0.45, "move_dog_to": "packing_table", "dog_state": "walking"},
            {"status": "in_progress", "duration": 1.00, "dog_state": "packing", "on_start": "start_packing"},
            {"status": "completing", "duration": 0.25, "dog_state": "packing", "on_complete": "complete_packing"},
        ],
    })


func _create_load_van_task() -> Dictionary:
    return _new_task("LoadVanTask", {
        "source_object_id": "packing_table",
        "target_object_id": "delivery_van_endpoint",
        "resource_id": "food_bag",
        "completion_event": "van_loaded",
        "steps": [
            {"status": "moving_to_source", "duration": 0.52, "move_dog_to": "packing_table", "dog_state": "walking"},
            {"status": "in_progress", "duration": 0.26, "dog_state": "carrying_item", "on_start": "pickup_resource"},
            {"status": "moving_to_target", "duration": 0.82, "move_dog_to": "delivery_van_endpoint", "dog_state": "carrying_item"},
            {"status": "completing", "duration": 0.34, "dog_state": "loading", "on_complete": "place_resource"},
        ],
    })


func _create_delivery_task() -> Dictionary:
    return _new_task("DeliveryTask", {
        "order_id": "order.first_warm_delivery",
        "completion_event": "delivery_complete",
        "steps": [
            {"status": "in_progress", "duration": 0.92, "on_start": "start_delivery"},
            {"status": "complete", "duration": 0.18, "on_complete": "complete_delivery"},
        ],
    })


func _create_equip_task() -> Dictionary:
    return _new_task("EquipItemTask", {
        "source_object_id": "postcard_card",
        "target_object_id": "dachshund_intro",
        "resource_id": "equipment.comfortable_slippers",
        "completion_event": "reward_equipped",
        "steps": [
            {"status": "moving_to_source", "duration": 0.20, "move_dog_to": "road_sign", "dog_state": "walking"},
            {"status": "in_progress", "duration": 0.58, "dog_state": "celebrating"},
            {"status": "completing", "duration": 0.22, "dog_state": "celebrating", "on_complete": "complete_equipment"},
        ],
    })


func _emit_event(event_name: String) -> void:
    last_event = event_name
    event_emitted.emit(event_name, elapsed)


func has_current_task(type: String, status := "") -> bool:
    if current_task.is_empty():
        return false
    if str(current_task.get("type", "")) != type:
        return false
    if status != "" and str(current_task.get("status", "")) != status:
        return false
    return true


func has_carry_task(source: String, target: String, resource_id := "") -> bool:
    if not has_current_task("CarryTask"):
        return false
    if str(current_task.get("source_object_id", "")) != source:
        return false
    if str(current_task.get("target_object_id", "")) != target:
        return false
    if resource_id != "" and str(current_task.get("resource_id", "")) != resource_id:
        return false
    return true


func token_at(resource_id: String, location: String) -> bool:
    if not tokens.has(resource_id):
        return false
    return str((tokens[resource_id] as Dictionary).get("location", "")) == location
