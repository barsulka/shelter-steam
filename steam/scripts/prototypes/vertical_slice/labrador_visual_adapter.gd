class_name ShelterLabradorVisualAdapter
extends Node

const ACTOR_ID := "dog.labrador_intro"
const RUNTIME_AUTHORITY := "godot_state" # runtime_authority: read-only gameplay source
const SECOND_ORDER_ID := "order.second_warm_delivery_careful_pack"
const CARE_EVENT := "labrador_packing_care_moment"
const LEGACY_UNBOUND_TASKS := ["UnloadTask", "CarryTask", "LoadVanTask"]
const PACKING_STATION_ID := "object.packing_table"
const PACKING_FRONT_SPAN_MASK_SELECTORS := ["D", "F", "G"]
const TURN_END_PROGRESS := 0.44
const TURN_MID_BEGIN_PROGRESS := 0.10
const TURN_MID_END_PROGRESS := 0.34
const STATION_BINDINGS := {
    "object.kitchen": {
        "task_type": "CookTask",
        "dog_state": "helping_kitchen",
        "on_start": "start_cooking",
        "selector": "E",
        "clip": "base_kitchen_work",
        "approach": 104.16,
        "contact": 62.88,
        "work": 54.24,
    },
    "object.packing_table": {
        "task_type": "PackTask",
        "dog_state": "packing",
        "on_start": "start_packing",
        "selector": "F",
        "clip": "base_packing_work",
        "approach": 104.16,
        "contact": 60.0,
        "work": 50.88,
    },
}

@export var base_pose := Vector4.ZERO
@export var blink_amount := 0.0
@export var tail_rotation := 0.0
@export var focus_pose := Vector2.ZERO

@onready var _base_player: AnimationPlayer = $BaseAnimationPlayer
@onready var _blink_player: AnimationPlayer = $BlinkAnimationPlayer
@onready var _tail_player: AnimationPlayer = $TailAnimationPlayer
@onready var _focus_player: AnimationPlayer = $FocusAnimationPlayer

var _last_rendered_facing := "right"
var _requested_facing := "right"
var _facing_source := "right"
var _last_task_id := ""
var _last_phase_index := -1
var _last_selector := ""
var _last_lane := "suppressed"
var _task_facing := ""
var _turn_required := false
var _task_turn_had_required := false
var _contact_task_id := ""
var _care_task_id := ""
var _epoch_key := ""
var _presentation_time := 0.0
var _trace_enabled := false
var _trace_path := ""
var _trace_once: Dictionary = {}
var _trace_entries: Array[Dictionary] = []
var _render_state: Dictionary = {
    "lane": "suppressed",
    "selector": "",
    "runtime_authority": RUNTIME_AUTHORITY,
}


func configure_trace(enabled: bool, path: String = "") -> void:
    _trace_enabled = enabled
    _trace_path = path
    _trace_once.clear()
    _trace_entries.clear()
    if not _trace_enabled or _trace_path == "":
        return
    DirAccess.make_dir_recursive_absolute(_trace_path.get_base_dir())
    if FileAccess.file_exists(_trace_path):
        DirAccess.remove_absolute(_trace_path)


func reset_visual_epoch(reason: String) -> void:
    _reset_presentation(reason)
    _epoch_key = ""


func observe_runtime(snapshot: Dictionary, delta: float = 0.05) -> Dictionary:
    _presentation_time += maxf(delta, 0.0)
    var next_epoch := _snapshot_epoch(snapshot)
    if _epoch_key == "":
        _epoch_key = next_epoch
    elif next_epoch != _epoch_key:
        _reset_presentation("runtime_epoch_changed")
        _epoch_key = next_epoch

    var task := snapshot.get("task", {}) as Dictionary
    var task_id := str(task.get("id", ""))
    if _last_task_id != "" and task_id != _last_task_id:
        if _last_lane.begins_with("authored"):
            _trace_marker("visual.cancel_safe", snapshot, "task_mismatch")
        _discard_task_caches()

    _update_care_latch(snapshot)
    var selection := select_visual_binding(snapshot)
    _apply_selection(snapshot, selection)
    _render_state = selection.duplicate(true)
    _render_state.merge({
        "runtime_authority": RUNTIME_AUTHORITY,
        "actor_world_x": float((snapshot.get("actor", {}) as Dictionary).get("world_x", 0.0)),
        "requested_facing": _requested_facing,
        "last_rendered_facing": _last_rendered_facing,
        "facing_source": _facing_source,
        "base_clip": str(selection.get("base_clip", "")),
        "base_pose": base_pose,
        "blink_amount": blink_amount,
        "tail_rotation": tail_rotation,
        "focus_pose": focus_pose,
        "packing_front_span_mask_active": _packing_front_span_mask_active(selection),
        "packing_front_span_mask_owner": "derived_non_persisted_presentation",
        "packing_front_span_mask_policy": "packing_contact_local_existing_source_segmentation",
        "source_px_to_world_unit": 0.24,
        "uniform_positive_scale": true,
        "gameplay_output_count": 0,
        "transfer_semantics": false,
    }, true)
    _trace_selection(snapshot, selection)

    _last_task_id = task_id
    _last_phase_index = int((snapshot.get("phase", {}) as Dictionary).get("index", -1))
    _last_selector = str(selection.get("selector", ""))
    _last_lane = str(selection.get("lane", "suppressed"))
    return _render_state.duplicate(true)


func select_visual_binding(snapshot: Dictionary) -> Dictionary:
    var actor := snapshot.get("actor", {}) as Dictionary
    var task := snapshot.get("task", {}) as Dictionary
    var phase := snapshot.get("phase", {}) as Dictionary
    var order := snapshot.get("active_order", {}) as Dictionary
    var actor_id := str(actor.get("id", ""))
    var task_id := str(task.get("id", ""))
    var task_type := str(task.get("type", ""))
    var assignee := str(task.get("assigned_dog_id", ""))
    var actor_task := str(actor.get("current_task", ""))

    if actor_id != ACTOR_ID or not bool(actor.get("visible", false)):
        return _suppressed("actor_not_visible")
    if bool((snapshot.get("journey", {}) as Dictionary).get("barrier_failed", false)):
        return _suppressed("save_barrier_failed")
    if task_id != "" and (assignee not in [ACTOR_ID, "labrador_intro"] or actor_task != task_id):
        return _suppressed("stale_task_or_assignee")

    # legacy_unbound is the only primitive Labrador lane and is deliberately
    # limited to existing transfer tasks. It claims no authored coverage.
    if task_id != "" and task_type in LEGACY_UNBOUND_TASKS:
        return {
            "lane": "legacy_unbound",
            "selector": "legacy_unbound",
            "reason": task_type,
            "station_offset_x": 0.0,
            "focus_enabled": false,
        }

    if task_id == "":
        if str(order.get("delivery_state", "")) == "ready_to_send" and not bool(order.get("delivery_confirmed", false)):
            return {
                "lane": "authored",
                "selector": "B",
                "base_clip": "base_wait",
                "station_offset_x": 0.0,
                "focus_enabled": false,
            }
        if str(actor.get("current_visible_state", "")) == "idle" and actor_task == "":
            return {
                "lane": "authored",
                "selector": "A",
                "base_clip": "base_idle",
                "station_offset_x": 0.0,
                "focus_enabled": false,
                "quiet_variant": _is_quiet_variant(snapshot),
            }
        return _suppressed("unbound_empty_task_state")

    var station_id := _exact_station_id(task)
    if station_id == "":
        return _suppressed("semantic_selector_outside_A_to_G")
    var binding := STATION_BINDINGS[station_id] as Dictionary
    var phase_index := int(phase.get("index", -1))
    var task_status := str(task.get("status", ""))
    var dog_state := str(phase.get("dog_state", actor.get("current_visible_state", "")))

    if phase_index == 0 and task_status == "moving_to_source" and dog_state == "walking":
        return {
            "lane": "authored",
            "selector": "C",
            "base_clip": "base_approach",
            "station_id": station_id,
            "station_offset_x": 0.0,
            "focus_enabled": false,
        }

    var exact_work := (
        phase_index == 1
        and task_status == "in_progress"
        and dog_state == str(binding["dog_state"])
        and str(phase.get("on_start", "")) == str(binding["on_start"])
    )
    if exact_work:
        if _last_task_id == task_id and _last_phase_index == 0:
            _contact_task_id = task_id
        var progress := _phase_progress(phase)
        if _contact_task_id == task_id and progress < 0.18:
            return {
                "lane": "authored",
                "selector": "D",
                "base_clip": "base_contact",
                "station_id": station_id,
                "station_offset_x": 0.0,
                "focus_enabled": false,
            }
        _contact_task_id = ""
        var selector := str(binding["selector"])
        var focus_enabled := false
        if selector == "F" and _exact_care_focus(task):
            selector = "G" # selector_G: exact Day-2 task/order/event match only
            focus_enabled = true
        return {
            "lane": "authored",
            "selector": selector,
            "base_selector": str(binding["selector"]),
            "base_clip": str(binding["clip"]),
            "station_id": station_id,
            "station_offset_x": 0.0,
            "focus_enabled": focus_enabled,
        }

    if phase_index == 2 and task_status == "completing" and _last_task_id == task_id and _last_selector in ["D", "E", "F", "G"]:
        return {
            "lane": "authored_exit",
            "selector": "EXIT",
            "origin_selector": _last_selector,
            "base_clip": "base_contact",
            "station_id": station_id,
            "station_offset_x": 0.0,
            "focus_enabled": false,
        }

    return _suppressed("semantic_selector_outside_A_to_G")


func render_state() -> Dictionary:
    return _render_state.duplicate(true)


func _packing_front_span_mask_active(selection: Dictionary) -> bool:
    if not str(selection.get("lane", "suppressed")).begins_with("authored"):
        return false
    if str(selection.get("station_id", "")) != PACKING_STATION_ID:
        return false
    var selector := str(selection.get("selector", ""))
    if selector in PACKING_FRONT_SPAN_MASK_SELECTORS:
        return true
    return (
        selector == "EXIT"
        and str(selection.get("origin_selector", "")) in PACKING_FRONT_SPAN_MASK_SELECTORS
    )


func trace_entries() -> Array[Dictionary]:
    return _trace_entries.duplicate(true)


func _apply_selection(snapshot: Dictionary, selection: Dictionary) -> void:
    var lane := str(selection.get("lane", "suppressed"))
    var selector := str(selection.get("selector", ""))
    if selector != _last_selector or lane != _last_lane:
        _presentation_time = 0.0
    if not lane.begins_with("authored"):
        base_pose = Vector4.ZERO
        focus_pose = Vector2.ZERO
        blink_amount = 0.0
        tail_rotation = 0.0
        _facing_source = _last_rendered_facing
        return

    var task := snapshot.get("task", {}) as Dictionary
    var phase := snapshot.get("phase", {}) as Dictionary
    var actor := snapshot.get("actor", {}) as Dictionary
    var progress := _phase_progress(phase)
    var station_id := str(selection.get("station_id", ""))
    if selector == "C":
        _prepare_station_facing(task, actor)
        var subphase := _locomotion_subphase(progress)
        selection["base_clip"] = str(subphase["clip"])
        selection["subphase"] = str(subphase["name"])
        _sample(_base_player, str(subphase["clip"]), float(subphase["progress"]))
        var approach_progress := progress
        if _task_turn_had_required:
            approach_progress = 0.0 if progress < TURN_END_PROGRESS else inverse_lerp(TURN_END_PROGRESS, 1.0, progress)
        var actor_world_x := float(actor.get("world_x", 0.0))
        var station_world_x := float(actor.get("move_target_x", actor_world_x))
        selection["station_offset_x"] = station_world_x - actor_world_x + _station_side_sign() * lerpf(
            _station_value(station_id, "approach"),
            _station_value(station_id, "contact"),
            approach_progress
        )
    elif selector == "D":
        _resolve_station_facing(task, actor)
        var contact_progress := clampf(progress / 0.18, 0.0, 1.0)
        _sample(_base_player, "base_contact", contact_progress)
        selection["station_offset_x"] = _station_side_sign() * lerpf(
            _station_value(station_id, "approach"),
            _station_value(station_id, "contact"),
            contact_progress
        )
        _finish_turn_if_needed()
    elif selector in ["E", "F", "G"]:
        _resolve_station_facing(task, actor)
        _sample(_base_player, str(selection["base_clip"]), progress)
        selection["station_offset_x"] = _station_side_sign() * _station_value(station_id, "work")
        _finish_turn_if_needed()
    elif selector == "EXIT":
        _resolve_station_facing(task, actor)
        _sample(_base_player, "base_contact", 1.0 - progress)
        selection["station_offset_x"] = _station_side_sign() * _station_value(station_id, "work") * (1.0 - progress)
        _finish_turn_if_needed()
    else:
        if selector == "B":
            _requested_facing = "right" if float((snapshot.get("active_order", {}) as Dictionary).get("van_world_x", 0.0)) >= float(actor.get("world_x", 0.0)) else "left"
            _apply_free_turn()
        else:
            _requested_facing = _last_rendered_facing
            _facing_source = _last_rendered_facing
        _sample_loop(_base_player, str(selection["base_clip"]), _presentation_time)

    _sample_loop(_blink_player, "blink_calm", _presentation_time)
    _sample_loop(_tail_player, "tail_calm", _presentation_time)
    if bool(selection.get("focus_enabled", false)):
        _sample(_focus_player, "focus_care", progress)
    else:
        _sample(_focus_player, "focus_off", 0.0)


func _prepare_station_facing(task: Dictionary, actor: Dictionary) -> void:
    var task_id := str(task.get("id", ""))
    if _last_task_id != task_id or _last_phase_index != 0 or _task_facing == "":
        var start_x := float(actor.get("move_start_x", actor.get("world_x", 0.0)))
        var target_x := float(actor.get("move_target_x", actor.get("world_x", 0.0)))
        if target_x > start_x + 0.01:
            _task_facing = "right"
        elif target_x < start_x - 0.01:
            _task_facing = "left"
        else:
            _task_facing = _last_rendered_facing
        _requested_facing = _task_facing
        _turn_required = _requested_facing != _last_rendered_facing
        _task_turn_had_required = _turn_required


func _resolve_station_facing(task: Dictionary, actor: Dictionary) -> void:
    if _task_facing == "":
        _prepare_station_facing(task, actor)
    _requested_facing = _task_facing


func _locomotion_subphase(progress: float) -> Dictionary:
    if _turn_required:
        if progress < TURN_END_PROGRESS:
            if progress < TURN_MID_BEGIN_PROGRESS:
                _facing_source = _last_rendered_facing
            elif progress < TURN_MID_END_PROGRESS:
                _facing_source = "turn_mid"
            else:
                _facing_source = _requested_facing
            return {"name":"turn", "clip":"base_turn", "progress":progress / TURN_END_PROGRESS}
        _finish_turn_if_needed()
        if progress < 0.58:
            return {"name":"start", "clip":"base_locomotion_start", "progress":inverse_lerp(TURN_END_PROGRESS, 0.58, progress)}
        if progress < 0.84:
            return {"name":"walk", "clip":"base_locomotion_walk", "progress":inverse_lerp(0.58, 0.84, progress)}
        return {"name":"stop", "clip":"base_locomotion_stop", "progress":inverse_lerp(0.84, 1.0, progress)}
    _facing_source = _requested_facing
    if progress < 0.22:
        return {"name":"start", "clip":"base_locomotion_start", "progress":progress / 0.22}
    if progress < 0.78:
        return {"name":"walk", "clip":"base_locomotion_walk", "progress":inverse_lerp(0.22, 0.78, progress)}
    return {"name":"stop", "clip":"base_locomotion_stop", "progress":inverse_lerp(0.78, 1.0, progress)}


func _apply_free_turn() -> void:
    if _requested_facing == _last_rendered_facing:
        _facing_source = _last_rendered_facing
        return
    var progress := clampf(_presentation_time / 0.324, 0.0, 1.0)
    _turn_required = true
    if progress < TURN_END_PROGRESS:
        if progress < TURN_MID_BEGIN_PROGRESS:
            _facing_source = _last_rendered_facing
        elif progress < TURN_MID_END_PROGRESS:
            _facing_source = "turn_mid"
        else:
            _facing_source = _requested_facing
        _sample(_base_player, "base_turn", progress / TURN_END_PROGRESS)
    else:
        _finish_turn_if_needed()


func _finish_turn_if_needed() -> void:
    _last_rendered_facing = _requested_facing
    _facing_source = _last_rendered_facing
    _turn_required = false


func _sample(player: AnimationPlayer, clip: String, normalized: float) -> void:
    if player == null or clip == "" or not player.has_animation(clip):
        return
    if player.current_animation != clip:
        player.play(clip)
    var animation := player.get_animation(clip)
    player.seek(clampf(normalized, 0.0, 1.0) * animation.length, true)


func _sample_loop(player: AnimationPlayer, clip: String, elapsed: float) -> void:
    if player == null or not player.has_animation(clip):
        return
    var animation := player.get_animation(clip)
    _sample(player, clip, fposmod(maxf(elapsed, 0.0), animation.length) / animation.length)


func _exact_station_id(task: Dictionary) -> String:
    var source := str(task.get("source_object_id", ""))
    var target := str(task.get("target_object_id", ""))
    var task_type := str(task.get("type", ""))
    if source != target or not STATION_BINDINGS.has(source):
        return ""
    return source if task_type == str((STATION_BINDINGS[source] as Dictionary)["task_type"]) else ""


func _exact_care_focus(task: Dictionary) -> bool:
    return (
        str(task.get("order_id", "")) == SECOND_ORDER_ID
        and str(task.get("id", "")) != ""
        and _care_task_id == str(task.get("id", ""))
    )


func _update_care_latch(snapshot: Dictionary) -> void:
    var task := snapshot.get("task", {}) as Dictionary
    var task_id := str(task.get("id", ""))
    if task_id == "" or task_id != _last_task_id:
        _care_task_id = ""
    if str(task.get("order_id", "")) != SECOND_ORDER_ID:
        return
    for raw_event in snapshot.get("recent_events", []) as Array:
        if not raw_event is Dictionary:
            continue
        var event := raw_event as Dictionary
        var payload := event.get("payload", {}) as Dictionary
        if (
            str(event.get("type", "")) == CARE_EVENT
            and str(payload.get("order_id", "")) == SECOND_ORDER_ID
            and str(payload.get("task_id", "")) == task_id
        ):
            _care_task_id = task_id


func _is_quiet_variant(snapshot: Dictionary) -> bool:
    return (
        (snapshot.get("active_order", {}) as Dictionary).is_empty()
        and (snapshot.get("active_chain", {}) as Dictionary).is_empty()
        and bool((snapshot.get("day2_history", {}) as Dictionary).get("completed", false))
    )


func _phase_progress(phase: Dictionary) -> float:
    var duration := float(phase.get("duration_seconds", 0.0))
    if duration <= 0.0:
        return 0.0
    return clampf(float(phase.get("elapsed_seconds", 0.0)) / duration, 0.0, 1.0)


func _station_value(station_id: String, field: String) -> float:
    if not STATION_BINDINGS.has(station_id):
        return 0.0
    return float((STATION_BINDINGS[station_id] as Dictionary).get(field, 0.0))


func _station_side_sign() -> float:
    return -1.0 if _task_facing == "right" else 1.0


func _snapshot_epoch(snapshot: Dictionary) -> String:
    var journey := snapshot.get("journey", {}) as Dictionary
    return "%s:%s:%s" % [
        str(journey.get("checkpoint_sequence", 0)),
        str(journey.get("barrier_failed", false)),
        str((snapshot.get("active_order", {}) as Dictionary).get("id", "")),
    ]


func _suppressed(reason: String) -> Dictionary:
    return {
        "lane": "suppressed",
        "selector": "",
        "reason": reason,
        "station_offset_x": 0.0,
        "focus_enabled": false,
    }


func _discard_task_caches() -> void:
    _last_task_id = ""
    _last_phase_index = -1
    _task_facing = ""
    _turn_required = false
    _task_turn_had_required = false
    _contact_task_id = ""
    _care_task_id = ""


func _reset_presentation(reason: String) -> void:
    _discard_task_caches()
    _last_selector = ""
    _last_lane = "suppressed"
    _last_rendered_facing = "right"
    _requested_facing = "right"
    _facing_source = "right"
    _presentation_time = 0.0
    base_pose = Vector4.ZERO
    blink_amount = 0.0
    tail_rotation = 0.0
    focus_pose = Vector2.ZERO
    if _trace_enabled:
        _trace_record({"marker":"visual.epoch_reset", "reason":reason})


func _trace_selection(snapshot: Dictionary, selection: Dictionary) -> void:
    var selector := str(selection.get("selector", ""))
    var task_id := str((snapshot.get("task", {}) as Dictionary).get("id", ""))
    var progress := _phase_progress(snapshot.get("phase", {}) as Dictionary)
    if selector == "C":
        _trace_once_marker("%s:C:enter" % task_id, "visual.phase_enter", snapshot)
        if progress >= 0.40:
            _trace_once_marker("%s:C:loop_enter" % task_id, "visual.loop_enter", snapshot)
        if progress >= 0.62:
            _trace_once_marker("%s:C:loop_boundary" % task_id, "visual.loop_boundary", snapshot)
        if progress >= 0.82:
            _trace_once_marker("%s:C:loop_exit" % task_id, "visual.loop_exit", snapshot)
            _trace_once_marker("%s:C:cancel_safe" % task_id, "visual.cancel_safe", snapshot)
    elif selector == "D":
        _trace_once_marker("%s:D:phase_complete" % task_id, "visual.phase_complete", snapshot)
        _trace_once_marker("%s:D:contact_begin" % task_id, "visual.contact_begin", snapshot)
    elif selector in ["E", "F", "G"]:
        _trace_once_marker("%s:work:loop_enter" % task_id, "visual.loop_enter", snapshot)
        if progress >= 0.5:
            _trace_once_marker("%s:work:loop_boundary" % task_id, "visual.loop_boundary", snapshot)
    elif selector == "EXIT":
        _trace_once_marker("%s:exit:loop_exit" % task_id, "visual.loop_exit", snapshot)
        _trace_once_marker("%s:exit:contact_end" % task_id, "visual.contact_end", snapshot)
        _trace_once_marker("%s:exit:cancel_safe" % task_id, "visual.cancel_safe", snapshot)
        if progress >= 0.8:
            _trace_once_marker("%s:exit:phase_complete" % task_id, "visual.phase_complete", snapshot)


func _trace_once_marker(key: String, marker: String, snapshot: Dictionary) -> void:
    if _trace_once.has(key):
        return
    _trace_once[key] = true
    _trace_marker(marker, snapshot)


func _trace_marker(marker: String, snapshot: Dictionary, reason: String = "") -> void:
    var task := snapshot.get("task", {}) as Dictionary
    var phase := snapshot.get("phase", {}) as Dictionary
    var entry := {
        "marker": marker,
        "reason": reason,
        "task_id": str(task.get("id", "")),
        "task_type": str(task.get("type", "")),
        "order_id": str(task.get("order_id", "")),
        "phase_index": int(phase.get("index", -1)),
        "phase_elapsed_seconds": float(phase.get("elapsed_seconds", 0.0)),
        "selector": str(_render_state.get("selector", _last_selector)),
        "runtime_authority": RUNTIME_AUTHORITY,
        "gameplay_output_count": 0,
    }
    _trace_record(entry)


func _trace_record(entry: Dictionary) -> void:
    _trace_entries.append(entry.duplicate(true))
    if not _trace_enabled or _trace_path == "":
        return
    var mode := FileAccess.READ_WRITE if FileAccess.file_exists(_trace_path) else FileAccess.WRITE
    var file := FileAccess.open(_trace_path, mode)
    if file == null:
        return
    file.seek_end()
    file.store_line(JSON.stringify(entry))
