extends Node

const AdapterScene := preload("res://scenes/prototypes/vertical_slice/labrador_visual_adapter.tscn")
const PlayerBootScene := preload("res://scenes/player/player_boot.tscn")
const TEST_PROFILE := "user://player-tests/r48-05a-source-reconciled"
const H_LEFT := 279.144385026738
const H_RIGHT := 1384.090909090909
const H_TRAVERSE_SECONDS := 19.0 * 0.82
const SOURCE_TO_RUNTIME := 1740.0 / 2992.0

var _failures: Array[String] = []
var _capture_root := ""
var _capture_files: Array[String] = []
var _selector_records: Array[Dictionary] = []
var _h_records: Array[Dictionary] = []
var _normal_path_records: Array[Dictionary] = []


func _ready() -> void:
    _run.call_deferred()


func _run() -> void:
    var capture_dir := _capture_output_arg()
    if capture_dir != "":
        await _run_capture(capture_dir)
    else:
        await _test_exact_selectors_and_h_matrix()
        await _test_player_boot_first_day_day2_quiet()
    _remove_tree(ProjectSettings.globalize_path(TEST_PROFILE))
    if _failures.is_empty():
        if capture_dir == "":
            print("labrador_r48_05a_visual_test=passed selectors=A-H cursors=33 legacy_unbound=3")
        else:
            print("labrador_r48_05a_capture=passed files=%d" % _capture_files.size())
        get_tree().quit(0)
        return
    for failure in _failures:
        push_error(failure)
    print("labrador_r48_05a_%s=failed count=%d" % ["capture" if capture_dir != "" else "visual_test", _failures.size()])
    get_tree().quit(1)


func _capture_output_arg() -> String:
    for arg in OS.get_cmdline_user_args():
        if arg.begins_with("--r48-05a-capture-dir="):
            return arg.replace("--r48-05a-capture-dir=", "").strip_edges()
    return ""


func _capture_git_commit_arg() -> String:
    for arg in OS.get_cmdline_user_args():
        if arg.begins_with("--r48-05a-git-commit="):
            return arg.replace("--r48-05a-git-commit=", "").strip_edges()
    return "unknown"


func _test_exact_selectors_and_h_matrix() -> void:
    var adapter := AdapterScene.instantiate()
    add_child(adapter)
    await get_tree().process_frame

    var state: Dictionary = adapter.call("observe_runtime", _base_snapshot(), 0.05) as Dictionary
    _expect(str(state.get("selector", "")) == "A", "A maps exact non-H idle")
    _expect(str(state.get("pose_id", "")) == "idle_neutral_right", "A uses accepted idle composite")
    _expect(is_equal_approx(float(state.get("source_px_to_world_unit", 0.0)), 0.24), "Labrador runtime scale is exact positive 0.24")
    _expect(is_equal_approx(float(state.get("source_world_to_runtime", 0.0)), SOURCE_TO_RUNTIME), "source world coefficient is exact 1740/2992")

    var wait := _base_snapshot()
    wait["active_order"]["delivery_state"] = "ready_to_send"
    state = adapter.call("observe_runtime", wait, 0.05) as Dictionary
    _expect(str(state.get("selector", "")) == "B", "B wins at ready_to_send")
    _expect(str(state.get("pose_id", "")) == "wait_calm_left", "B uses accepted calm wait composite")

    adapter.call("reset_visual_epoch", "station_from_left")
    var cook_right := _station_snapshot("task.cook.right", "CookTask", "object.kitchen", 0, "moving_to_source", "walking", "", 0.05, 400.0, 776.661096256684, "order.first_warm_delivery")
    state = adapter.call("observe_runtime", cook_right, 0.05) as Dictionary
    _expect(str(state.get("selector", "")) == "C" and str(state.get("subphase", "")) == "start", "C begins with authored start")
    _expect(str(state.get("pose_id", "")) == "locomotion_start_right", "C from-left uses authored right start")
    cook_right["phase"]["elapsed_seconds"] = 0.5 * 0.324
    cook_right["actor"]["world_x"] = lerpf(400.0, 776.661096256684, 0.5)
    state = adapter.call("observe_runtime", cook_right, 0.05) as Dictionary
    _expect(str(state.get("subphase", "")) == "walk" and str(state.get("pose_id", "")).begins_with("walk_support_"), "C contains authored walk support")
    cook_right["phase"]["elapsed_seconds"] = 0.9 * 0.324
    cook_right["actor"]["world_x"] = lerpf(400.0, 776.661096256684, 0.9)
    state = adapter.call("observe_runtime", cook_right, 0.05) as Dictionary
    _expect(str(state.get("subphase", "")) == "stop" and str(state.get("pose_id", "")) == "locomotion_stop_right", "C ends with authored stop")

    cook_right["phase"]["elapsed_seconds"] = 0.99 * 0.324
    cook_right["actor"]["world_x"] = 776.661096256684
    adapter.call("observe_runtime", cook_right, 0.05)
    var cook_work := _station_snapshot("task.cook.right", "CookTask", "object.kitchen", 1, "in_progress", "helping_kitchen", "start_cooking", 0.0, 400.0, 776.661096256684, "order.first_warm_delivery")
    state = adapter.call("observe_runtime", cook_work, 0.05) as Dictionary
    _expect(str(state.get("selector", "")) == "D", "D maps exact approach/contact transition")
    _expect(str(state.get("pose_id", "")) in ["approach_right", "contact_align_right"], "D uses accepted contact composites")
    cook_work["phase"]["elapsed_seconds"] = 0.3 * 0.8496
    state = adapter.call("observe_runtime", cook_work, 0.05) as Dictionary
    _expect(str(state.get("selector", "")) == "E" and str(state.get("pose_id", "")) == "kitchen_work_right", "E maps exact Kitchen work")
    _expect(is_equal_approx(_render_root(cook_work, state), 696.697860962567), "Kitchen from-left work root is exact")
    _expect(not bool(state.get("packing_front_span_mask_active", true)), "Kitchen/Packing source-reconciled trial uses zero guessed front mask")

    adapter.call("reset_visual_epoch", "station_from_right")
    var cook_left := _station_snapshot("task.cook.left", "CookTask", "object.kitchen", 0, "moving_to_source", "walking", "", 0.02, 1100.0, 776.661096256684, "order.first_warm_delivery")
    state = adapter.call("observe_runtime", cook_left, 0.05) as Dictionary
    _expect(str(state.get("subphase", "")) == "turn", "right-to-left physical turn begins")
    cook_left["phase"]["elapsed_seconds"] = 0.18 * 0.324
    state = adapter.call("observe_runtime", cook_left, 0.05) as Dictionary
    _expect(str(state.get("facing_source", "")) == "turn_mid" and str(state.get("pose_id", "")) == "turn_right_to_left_mid", "right-to-left uses physical midpoint composite")
    cook_left["phase"]["elapsed_seconds"] = 0.45 * 0.324
    state = adapter.call("observe_runtime", cook_left, 0.05) as Dictionary
    _expect(str(state.get("last_rendered_facing", "")) == "left", "right-to-left physical turn completes")

    var reverse := _station_snapshot("task.cook.reverse", "CookTask", "object.kitchen", 0, "moving_to_source", "walking", "", 0.02, 400.0, 776.661096256684, "order.first_warm_delivery")
    adapter.call("observe_runtime", reverse, 0.05)
    reverse["phase"]["elapsed_seconds"] = 0.18 * 0.324
    state = adapter.call("observe_runtime", reverse, 0.05) as Dictionary
    _expect(str(state.get("facing_source", "")) == "turn_mid" and str(state.get("pose_id", "")) == "turn_left_to_right_mid", "left-to-right uses physical midpoint composite")

    adapter.call("reset_visual_epoch", "packing_F")
    var pack := _station_snapshot("task.pack.first", "PackTask", "object.packing_table", 1, "in_progress", "packing", "start_packing", 0.3, 700.0, 1023.529411764706, "order.first_warm_delivery")
    state = adapter.call("observe_runtime", pack, 0.05) as Dictionary
    _expect(str(state.get("selector", "")) == "F" and str(state.get("pose_id", "")) == "packing_work_right", "F maps ordinary Packing work")
    _expect(is_equal_approx(_render_root(pack, state), 943.856951871658), "Packing from-left work root is exact")

    adapter.call("reset_visual_epoch", "packing_G")
    var care := _station_snapshot("task.pack.day2", "PackTask", "object.packing_table", 1, "in_progress", "packing", "start_packing", 0.3, 1400.0, 1023.529411764706, "order.second_warm_delivery_careful_pack")
    care["recent_events"] = [{"type":"labrador_packing_care_moment", "payload":{"order_id":"order.second_warm_delivery_careful_pack", "task_id":"task.pack.day2"}}]
    state = adapter.call("observe_runtime", care, 0.05) as Dictionary
    _expect(str(state.get("selector", "")) == "G" and str(state.get("pose_id", "")) == "packing_focus_left", "G requires exact Day-2 task/order/event and authored focus")
    _expect(is_equal_approx(_render_root(care, state), 1102.620320855615), "Packing from-right work root is exact")
    adapter.call("reset_visual_epoch", "negative_G")
    var negative_g := care.duplicate(true)
    negative_g["recent_events"] = [{"type":"labrador_packing_care_moment", "payload":{"order_id":"order.second_warm_delivery_careful_pack", "task_id":"task.other"}}]
    state = adapter.call("observe_runtime", negative_g, 0.05) as Dictionary
    _expect(str(state.get("selector", "")) == "F" and str(state.get("pose_id", "")) == "packing_work_left", "negative G mismatch stays F")

    for task_type in ["UnloadTask", "CarryTask", "LoadVanTask"]:
        adapter.call("reset_visual_epoch", "legacy_%s" % task_type)
        state = adapter.call("observe_runtime", _legacy_snapshot(task_type), 0.05) as Dictionary
        _expect(str(state.get("lane", "")) == "legacy_unbound" and str(state.get("reason", "")) == task_type, "%s remains legacy_unbound" % task_type)
        _expect(int(state.get("gameplay_output_count", -1)) == 0 and not bool(state.get("transfer_semantics", true)), "%s gains zero transfer output" % task_type)

    var unsupported := _station_snapshot("task.unsupported", "ResearchTask", "object.kitchen", 0, "moving_to_source", "walking", "", 0.1, 400.0, 776.661096256684, "order.first_warm_delivery")
    state = adapter.call("observe_runtime", unsupported, 0.05) as Dictionary
    _expect(str(state.get("lane", "")) == "suppressed", "selector outside A-H fails closed")

    await _test_h_matrix(adapter)
    adapter.queue_free()
    await get_tree().process_frame


func _test_h_matrix(adapter: Node) -> void:
    adapter.call("reset_visual_epoch", "H_first_day")
    var h := _h_snapshot(1, "first_day_offered")
    var state: Dictionary = adapter.call("observe_runtime", h, 0.0) as Dictionary
    _record_h_case("positive_first_day_offered", state)
    _expect(str(state.get("selector", "")) == "H" and str(state.get("h_phase", "")) == "dwell_left", "H positive at durable First Day offered cursor 1")
    _expect(is_equal_approx(_render_root(h, state), H_LEFT), "H starts at exact converted left endpoint")
    state = adapter.call("observe_runtime", h, 4.51) as Dictionary
    _expect(str(state.get("h_phase", "")) == "start_right" and str(state.get("pose_id", "")) == "locomotion_start_right", "H exact 4.5-second left dwell then start")
    state = adapter.call("observe_runtime", h, 0.19) as Dictionary
    _expect(str(state.get("h_phase", "")) == "walk_right", "H exact 0.18-second start then walk")
    state = adapter.call("observe_runtime", h, H_TRAVERSE_SECONDS) as Dictionary
    _expect(str(state.get("h_phase", "")) == "stop_right" and is_equal_approx(_render_root(h, state), H_RIGHT), "H 19 cycles reach exact right endpoint")
    state = adapter.call("observe_runtime", h, 0.25) as Dictionary
    _expect(str(state.get("h_phase", "")) == "dwell_right", "H exact 0.24-second stop then right dwell")
    state = adapter.call("observe_runtime", h, 8.01) as Dictionary
    _expect(str(state.get("h_phase", "")) == "turn_right_to_left" and str(state.get("pose_id", "")) == "turn_right_to_left_mid", "H exact 8-second dwell then physical turn")
    state = adapter.call("observe_runtime", h, 0.45) as Dictionary
    _expect(str(state.get("h_phase", "")) == "start_left", "H exact 0.44-second turn then return start")
    _expect(int(state.get("h_cycle_count", 0)) == 19, "H retains exactly 19 walk cycles")
    _expect(is_equal_approx(float(state.get("h_cycle_distance_runtime_units", 0.0)), 58.155080213904), "H retains exact cycle distance")
    _expect(is_equal_approx(float(state.get("h_speed_runtime_units_per_second", 0.0)), 70.920829529151), "H retains exact calm speed")

    adapter.call("reset_visual_epoch", "H_day2")
    state = adapter.call("observe_runtime", _h_snapshot(18, "day2_offered"), 0.0) as Dictionary
    _record_h_case("positive_day2_offered", state)
    _expect(str(state.get("selector", "")) == "H", "H positive at durable Day 2 offered cursor 18")
    adapter.call("reset_visual_epoch", "H_quiet")
    state = adapter.call("observe_runtime", _h_snapshot(33, "quiet_cooperative"), 0.0) as Dictionary
    _record_h_case("positive_quiet_cooperative", state)
    _expect(str(state.get("selector", "")) == "H", "H positive at restart-stable Quiet Cooperative cursor 33")

    var b_wins := _h_snapshot(1, "first_day_offered")
    b_wins["active_order"]["delivery_state"] = "ready_to_send"
    state = adapter.call("observe_runtime", b_wins, 0.05) as Dictionary
    _record_h_case("negative_ready_to_send_yields_B", state)
    _expect(str(state.get("selector", "")) == "B", "H yields to B at ready_to_send")
    for negative in ["queued_task", "trip", "delivery", "restore", "save_failure", "save_commit", "stale_predicate"]:
        adapter.call("reset_visual_epoch", "H_negative_%s" % negative)
        var snapshot := _h_snapshot(1, "first_day_offered")
        match negative:
            "queued_task":
                snapshot["presentation_guard"]["labrador_task_count"] = 1
            "trip":
                snapshot["presentation_guard"]["trip_task_exists"] = true
            "delivery":
                snapshot["presentation_guard"]["delivery_or_trip_active"] = true
            "restore":
                snapshot["journey"]["restore_incomplete"] = true
            "save_failure":
                snapshot["journey"]["barrier_failed"] = true
            "save_commit":
                snapshot["journey"]["commit_in_progress"] = true
            "stale_predicate":
                snapshot["active_order"]["id"] = "order.stale"
        state = adapter.call("observe_runtime", snapshot, 0.05) as Dictionary
        _record_h_case("negative_%s" % negative, state)
        if negative in ["restore", "save_failure", "save_commit"]:
            _expect(str(state.get("lane", "")) == "suppressed", "H %s fails closed by durable-state suppression" % negative)
        else:
            _expect(str(state.get("selector", "")) == "A", "H %s fails closed to A" % negative)

    adapter.call("reset_visual_epoch", "H_player_gate")
    h = _h_snapshot(1, "first_day_offered")
    adapter.call("observe_runtime", h, 0.05)
    adapter.call("cancel_h_for_player_gate", h, "test_player_route_gate")
    state = adapter.call("observe_runtime", h, 0.0) as Dictionary
    _record_h_case("cancelled_before_player_gate", state)
    _expect(str(state.get("selector", "")) == "A" and str(state.get("reason", "")) == "player_gate_cancelled_h", "player gate cancels H before authoritative transition")
    adapter.call("reset_visual_epoch", "H_recovery")
    var failed := _h_snapshot(1, "first_day_offered")
    failed["journey"]["barrier_failed"] = true
    adapter.call("observe_runtime", failed, 0.05)
    state = adapter.call("observe_runtime", _h_snapshot(1, "first_day_offered"), 0.05) as Dictionary
    _record_h_case("recovery_rebuilt_from_durable_state", state)
    _expect(str(state.get("selector", "")) == "H" and is_equal_approx(_render_root(_h_snapshot(1, "first_day_offered"), state), H_LEFT), "H retry/recovery rebuilds from exact left endpoint without stale cache")
    _expect(int(state.get("gameplay_output_count", -1)) == 0 and not bool(state.get("transfer_semantics", true)), "H produces zero gameplay/transfer output")


func _record_h_case(label: String, state: Dictionary) -> void:
    _h_records.append({
        "case": label,
        "selector": str(state.get("selector", "")),
        "lane": str(state.get("lane", "")),
        "reason": str(state.get("reason", "")),
        "phase": str(state.get("h_phase", "")),
        "pose_id": str(state.get("pose_id", "")),
        "root_world_x": float(state.get("actor_world_x", 0.0)) + float(state.get("station_offset_x", 0.0)),
        "gameplay_output_count": int(state.get("gameplay_output_count", -1)),
        "transfer_semantics": bool(state.get("transfer_semantics", true))
    })


func _test_player_boot_first_day_day2_quiet() -> void:
    _remove_tree(ProjectSettings.globalize_path(TEST_PROFILE))
    var first_boot := PlayerBootScene.instantiate()
    _expect(bool((first_boot.call("configure_player_boot", {"profile_base_dir":TEST_PROFILE, "test_mode":true}) as Dictionary).get("ok", false)), "isolated First Day PlayerBoot configures")
    add_child(first_boot)
    await get_tree().create_timer(0.12).timeout
    _expect(int((first_boot.call("lifecycle_snapshot") as Dictionary).get("runtime_child_count", 0)) == 1, "First Day has one PlayerBoot-owned runtime")
    var runtime: Control = first_boot.call("player_runtime") as Control
    _expect(runtime != null and runtime.get_parent() == first_boot, "First Day runtime parent remains PlayerBoot")
    runtime.set_process(false)
    var initial := runtime.call("test_labrador_visual_snapshot") as Dictionary
    _expect(str((initial.get("render", {}) as Dictionary).get("selector", "")) == "H", "ordinary First Day offered cursor renders H")
    var corridor := initial.get("corridor_framing", {}) as Dictionary
    _expect(is_equal_approx(float(corridor.get("authored_world_max_x", 0.0)), 1740.0) and bool(corridor.get("full_authored_corridor", false)), "ordinary player uses full authored 1740 runtime corridor")
    _expect(is_equal_approx(float(corridor.get("source_world_width_px", 0.0)), 2992.0), "ordinary player records 2992 source width")
    var first_selectors := {"H": true}
    var first_legacy: Dictionary = {}
    for _sequence in range(1, 17):
        var advance := runtime.call("test_labrador_advance_to_next_checkpoint_visual_trace", 5000) as Dictionary
        _expect(bool(advance.get("ok", false)), "First Day advances one safe cursor: %s" % str(advance.get("error", "")))
        _collect_path_samples("first_day", advance.get("samples", []) as Array, first_selectors, first_legacy)
    for selector in ["A", "B", "C", "D", "E", "F", "H"]:
        _expect(first_selectors.has(selector), "ordinary First Day reaches selector %s" % selector)
    _expect(not first_selectors.has("G"), "ordinary First Day never reaches G")
    for task_type in ["UnloadTask", "CarryTask", "LoadVanTask"]:
        _expect(first_legacy.has(task_type), "ordinary First Day preserves %s legacy_unbound" % task_type)
    first_boot.queue_free()
    await get_tree().process_frame

    var day2_boot := PlayerBootScene.instantiate()
    _expect(bool((day2_boot.call("configure_player_boot", {"profile_base_dir":TEST_PROFILE, "test_mode":true}) as Dictionary).get("ok", false)), "isolated Day 2 PlayerBoot configures")
    add_child(day2_boot)
    await get_tree().process_frame
    _expect(str((day2_boot.call("lifecycle_snapshot") as Dictionary).get("action", "")) == "begin_day2_return", "ordinary restart offers Day 2 return")
    _expect(bool((day2_boot.call("activate_lifecycle_action") as Dictionary).get("ok", false)), "ordinary Day 2 return activates")
    await get_tree().create_timer(0.12).timeout
    _expect(int((day2_boot.call("lifecycle_snapshot") as Dictionary).get("runtime_child_count", 0)) == 1, "Day 2 has one PlayerBoot-owned runtime")
    runtime = day2_boot.call("player_runtime") as Control
    runtime.set_process(false)
    initial = runtime.call("test_labrador_visual_snapshot") as Dictionary
    _expect(str((initial.get("render", {}) as Dictionary).get("selector", "")) == "H", "ordinary Day 2 offered cursor renders H")
    var day2_selectors := {"H": true}
    var day2_legacy: Dictionary = {}
    for _sequence in range(18, 33):
        var advance := runtime.call("test_labrador_advance_to_next_checkpoint_visual_trace", 5000) as Dictionary
        _expect(bool(advance.get("ok", false)), "Day 2 advances one safe cursor: %s" % str(advance.get("error", "")))
        _collect_path_samples("day2", advance.get("samples", []) as Array, day2_selectors, day2_legacy)
    for selector in ["A", "B", "C", "D", "E", "F", "G", "H"]:
        _expect(day2_selectors.has(selector), "ordinary Day 2 reaches selector %s" % selector)
    var quiet := runtime.call("test_labrador_visual_snapshot") as Dictionary
    _expect(str((quiet.get("render", {}) as Dictionary).get("selector", "")) == "H", "cursor 33 Quiet Cooperative renders restart-stable H")
    _expect(int(quiet.get("runtime_count", 0)) == 1 and int(quiet.get("labrador_count", 0)) == 1, "one runtime and one Labrador remain through Quiet Cooperative")
    day2_boot.queue_free()
    await get_tree().process_frame


func _collect_path_samples(journey: String, samples: Array, selectors: Dictionary, legacy: Dictionary) -> void:
    for sample_value in samples:
        var sample := sample_value as Dictionary
        var render := sample.get("render", {}) as Dictionary
        var selector := str(render.get("selector", ""))
        if selector != "":
            selectors[selector] = true
        var base_selector := str(render.get("base_selector", ""))
        if base_selector != "":
            selectors[base_selector] = true
        if str(render.get("lane", "")) == "legacy_unbound":
            legacy[str(render.get("reason", ""))] = true
        if _normal_path_records.size() < 400:
            _normal_path_records.append({
                "journey": journey,
                "selector": selector,
                "lane": str(render.get("lane", "")),
                "pose_id": str(render.get("pose_id", "")),
                "root_world_x": float(render.get("actor_world_x", 0.0)) + float(render.get("station_offset_x", 0.0)),
                "checkpoint_sequence": int(((sample.get("observation", {}) as Dictionary).get("journey", {}) as Dictionary).get("checkpoint_sequence", 0)),
                "gameplay_output_count": int(render.get("gameplay_output_count", -1))
            })


func _run_capture(output_dir: String) -> void:
    _capture_root = ProjectSettings.globalize_path(output_dir) if output_dir.begins_with("res://") or output_dir.begins_with("user://") else output_dir
    DirAccess.make_dir_recursive_absolute(_capture_root)
    for directory in ["captures/full_layout", "captures/selectors", "captures/stations", "captures/turns", "captures/alpha", "captures/journeys"]:
        DirAccess.make_dir_recursive_absolute(_capture_root.path_join(directory))
    await _test_exact_selectors_and_h_matrix()
    if not _failures.is_empty():
        return
    await _capture_selector_matrix()
    await _capture_normal_journeys()
    _write_jsonl("runtime_selector_snapshots.jsonl", _selector_records)
    _write_jsonl("h_trace.jsonl", _h_records)
    _write_jsonl("normal_path_summary.jsonl", _normal_path_records)
    _write_capture_manifest()


func _capture_selector_matrix() -> void:
    _remove_tree(ProjectSettings.globalize_path(TEST_PROFILE))
    var boot := PlayerBootScene.instantiate()
    _expect(bool((boot.call("configure_player_boot", {"profile_base_dir":TEST_PROFILE, "test_mode":true}) as Dictionary).get("ok", false)), "capture PlayerBoot configures")
    add_child(boot)
    await get_tree().create_timer(0.12).timeout
    var runtime: Control = boot.call("player_runtime") as Control
    runtime.set_process(false)
    runtime.call("test_labrador_set_capture_ui_hidden", true)
    DisplayServer.window_set_size(Vector2i(2992, 224))
    await get_tree().process_frame
    await get_tree().process_frame

    var states := {
        "A": _base_snapshot(),
        "B": _base_snapshot(),
        "C": _station_snapshot("capture.C", "CookTask", "object.kitchen", 0, "moving_to_source", "walking", "", 0.55, 400.0, 776.661096256684, "order.first_warm_delivery"),
        "E": _station_snapshot("capture.E", "CookTask", "object.kitchen", 1, "in_progress", "helping_kitchen", "start_cooking", 0.4, 400.0, 776.661096256684, "order.first_warm_delivery"),
        "F": _station_snapshot("capture.F", "PackTask", "object.packing_table", 1, "in_progress", "packing", "start_packing", 0.4, 700.0, 1023.529411764706, "order.first_warm_delivery"),
        "G": _station_snapshot("capture.G", "PackTask", "object.packing_table", 1, "in_progress", "packing", "start_packing", 0.4, 1400.0, 1023.529411764706, "order.second_warm_delivery_careful_pack"),
        "H": _h_snapshot(1, "first_day_offered")
    }
    (states["B"] as Dictionary)["active_order"]["delivery_state"] = "ready_to_send"
    (states["G"] as Dictionary)["recent_events"] = [{"type":"labrador_packing_care_moment", "payload":{"order_id":"order.second_warm_delivery_careful_pack", "task_id":"capture.G"}}]

    await _capture_runtime_state(runtime, states["A"] as Dictionary, "captures/selectors/A_idle.png", "A")
    await _capture_runtime_state(runtime, states["B"] as Dictionary, "captures/selectors/B_wait.png", "B")
    await _capture_runtime_state(runtime, states["C"] as Dictionary, "captures/selectors/C_locomotion.png", "C")
    var d_pre := _station_snapshot("capture.D", "CookTask", "object.kitchen", 0, "moving_to_source", "walking", "", 0.99, 400.0, 776.661096256684, "order.first_warm_delivery")
    runtime.call("test_labrador_observe_snapshot", d_pre, 0.05)
    var d := _station_snapshot("capture.D", "CookTask", "object.kitchen", 1, "in_progress", "helping_kitchen", "start_cooking", 0.0, 400.0, 776.661096256684, "order.first_warm_delivery")
    await _capture_runtime_state(runtime, d, "captures/selectors/D_contact.png", "D")
    await _capture_runtime_state(runtime, states["E"] as Dictionary, "captures/selectors/E_kitchen.png", "E")
    await _capture_runtime_state(runtime, states["F"] as Dictionary, "captures/selectors/F_packing.png", "F")
    await _capture_runtime_state(runtime, states["G"] as Dictionary, "captures/selectors/G_focus.png", "G")
    await _capture_runtime_state(runtime, states["H"] as Dictionary, "captures/selectors/H_dwell.png", "H")

    runtime.call("test_labrador_restore_runtime_observation")
    for side in ["from_left", "from_right"]:
        var start_x := 400.0 if side == "from_left" else 1100.0
        var kitchen := _station_snapshot("capture.kitchen.%s" % side, "CookTask", "object.kitchen", 1, "in_progress", "helping_kitchen", "start_cooking", 0.4, start_x, 776.661096256684, "order.first_warm_delivery")
        await _capture_runtime_state(runtime, kitchen, "captures/stations/kitchen_%s.png" % side, "E")
        var packing := _station_snapshot("capture.packing.%s" % side, "PackTask", "object.packing_table", 1, "in_progress", "packing", "start_packing", 0.4, start_x, 1023.529411764706, "order.first_warm_delivery")
        await _capture_runtime_state(runtime, packing, "captures/stations/packing_%s.png" % side, "F")

    for direction in ["right_to_left", "left_to_right"]:
        runtime.call("test_labrador_restore_runtime_observation")
        var start_x := 1100.0 if direction == "right_to_left" else 400.0
        var turn := _station_snapshot("capture.turn.%s" % direction, "CookTask", "object.kitchen", 0, "moving_to_source", "walking", "", 0.18, start_x, 776.661096256684, "order.first_warm_delivery")
        await _capture_runtime_state(runtime, turn, "captures/turns/%s.png" % direction, "C")

    runtime.call("test_labrador_restore_runtime_observation")
    var h := _h_snapshot(1, "first_day_offered")
    var h_steps := [0.0, 4.51, 0.19, 4.1, 4.1, 4.1, 3.3, 0.25, 8.01, 0.45]
    for index in h_steps.size():
        var state := runtime.call("test_labrador_observe_snapshot", h, float(h_steps[index])) as Dictionary
        _h_records.append({
            "index": index,
            "selector": str(state.get("selector", "")),
            "phase": str(state.get("h_phase", "")),
            "pose_id": str(state.get("pose_id", "")),
            "elapsed_seconds": float(state.get("h_elapsed_seconds", 0.0)),
            "root_world_x": float(state.get("actor_world_x", 0.0)) + float(state.get("station_offset_x", 0.0)),
            "gameplay_output_count": int(state.get("gameplay_output_count", -1))
        })
        if index in [0, 1, 2, 6, 7, 8, 9]:
            await _save_viewport("captures/selectors/H_motion_%02d_%s.png" % [index, str(state.get("h_phase", ""))])

    var native := get_viewport().get_texture().get_image()
    _save_image(native, "captures/full_layout/full_layout_native_2992x224.png")
    for height in [216, 144, 96]:
        var scaled := native.duplicate()
        var width := roundi(2992.0 * float(height) / 224.0)
        scaled.resize(width, height, Image.INTERPOLATE_LANCZOS)
        _save_image(scaled, "captures/full_layout/full_layout_%d.png" % height)
    _save_alpha_composites(native)
    boot.queue_free()
    await get_tree().process_frame


func _capture_normal_journeys() -> void:
    _remove_tree(ProjectSettings.globalize_path(TEST_PROFILE))
    var first_boot := PlayerBootScene.instantiate()
    _expect(bool((first_boot.call("configure_player_boot", {"profile_base_dir":TEST_PROFILE, "test_mode":true}) as Dictionary).get("ok", false)), "capture First Day configures")
    add_child(first_boot)
    await get_tree().create_timer(0.12).timeout
    var runtime: Control = first_boot.call("player_runtime") as Control
    runtime.set_process(false)
    runtime.call("test_labrador_set_capture_ui_hidden", true)
    await _save_viewport("captures/journeys/first_day_offered_H.png")
    for _sequence in range(1, 17):
        var advance := runtime.call("test_labrador_advance_to_next_checkpoint_visual_trace", 5000) as Dictionary
        _expect(bool(advance.get("ok", false)), "capture First Day advances")
        var selectors: Dictionary = {}
        var legacy: Dictionary = {}
        _collect_path_samples("first_day", advance.get("samples", []) as Array, selectors, legacy)
    await _save_viewport("captures/journeys/first_day_complete.png")
    first_boot.queue_free()
    await get_tree().process_frame

    var day2_boot := PlayerBootScene.instantiate()
    _expect(bool((day2_boot.call("configure_player_boot", {"profile_base_dir":TEST_PROFILE, "test_mode":true}) as Dictionary).get("ok", false)), "capture Day 2 configures")
    add_child(day2_boot)
    await get_tree().process_frame
    _expect(bool((day2_boot.call("activate_lifecycle_action") as Dictionary).get("ok", false)), "capture Day 2 activates")
    await get_tree().create_timer(0.12).timeout
    runtime = day2_boot.call("player_runtime") as Control
    runtime.set_process(false)
    runtime.call("test_labrador_set_capture_ui_hidden", true)
    await _save_viewport("captures/journeys/day2_offered_H.png")
    for _sequence in range(18, 33):
        var advance := runtime.call("test_labrador_advance_to_next_checkpoint_visual_trace", 5000) as Dictionary
        _expect(bool(advance.get("ok", false)), "capture Day 2 advances")
        var selectors: Dictionary = {}
        var legacy: Dictionary = {}
        _collect_path_samples("day2", advance.get("samples", []) as Array, selectors, legacy)
    await _save_viewport("captures/journeys/quiet_cooperative_H.png")
    day2_boot.queue_free()
    await get_tree().process_frame


func _capture_runtime_state(runtime: Control, snapshot: Dictionary, relative_path: String, expected_selector: String) -> void:
    var state := runtime.call("test_labrador_observe_snapshot", snapshot, 0.05) as Dictionary
    await get_tree().process_frame
    _expect(str(state.get("selector", "")) == expected_selector, "capture state reaches selector %s" % expected_selector)
    _selector_records.append({
        "label": expected_selector,
        "selector": str(state.get("selector", "")),
        "lane": str(state.get("lane", "")),
        "pose_id": str(state.get("pose_id", "")),
        "root_world_x": float(state.get("actor_world_x", 0.0)) + float(state.get("station_offset_x", 0.0)),
        "runtime_authority": str(state.get("runtime_authority", "")),
        "gameplay_output_count": int(state.get("gameplay_output_count", -1)),
        "transfer_semantics": bool(state.get("transfer_semantics", true)),
        "capture": relative_path
    })
    await _save_viewport(relative_path)


func _save_viewport(relative_path: String) -> void:
    await get_tree().process_frame
    var image := get_viewport().get_texture().get_image()
    _save_image(image, relative_path)


func _save_image(image: Image, relative_path: String) -> void:
    var absolute := _capture_root.path_join(relative_path)
    DirAccess.make_dir_recursive_absolute(absolute.get_base_dir())
    var error := image.save_png(absolute)
    _expect(error == OK, "capture writes %s" % relative_path)
    if error == OK and relative_path not in _capture_files:
        _capture_files.append(relative_path)


func _save_alpha_composites(source: Image) -> void:
    var rgba := source.duplicate()
    rgba.convert(Image.FORMAT_RGBA8)
    var black := Image.create(rgba.get_width(), rgba.get_height(), false, Image.FORMAT_RGBA8)
    black.fill(Color.BLACK)
    black.blend_rect(rgba, Rect2i(Vector2i.ZERO, rgba.get_size()), Vector2i.ZERO)
    _save_image(black, "captures/alpha/player_over_black.png")
    var checker := Image.create(rgba.get_width(), rgba.get_height(), false, Image.FORMAT_RGBA8)
    checker.fill(Color(0.18, 0.18, 0.18, 1.0))
    var cell := 24
    for y in range(0, checker.get_height(), cell):
        for x in range(0, checker.get_width(), cell):
            if ((x / cell) + (y / cell)) as int % 2 == 0:
                checker.fill_rect(Rect2i(x, y, mini(cell, checker.get_width() - x), mini(cell, checker.get_height() - y)), Color(0.62, 0.62, 0.62, 1.0))
    checker.blend_rect(rgba, Rect2i(Vector2i.ZERO, rgba.get_size()), Vector2i.ZERO)
    _save_image(checker, "captures/alpha/player_over_checker.png")


func _write_capture_manifest() -> void:
    var selectors: Dictionary = {}
    for record in _selector_records:
        selectors[str(record.get("selector", ""))] = true
    for required in ["A", "B", "C", "D", "E", "F", "G", "H"]:
        _expect(selectors.has(required), "capture manifest contains selector %s" % required)
    var manifest := {
        "schema_version": "shelter.r48_05a.source_reconciled_runtime_capture/v1",
        "captured_at_utc": Time.get_datetime_string_from_system(true),
        "git_commit": _capture_git_commit_arg(),
        "brief_sha256": "9fcaab17580f23b7a3d884440b802aa9c38f9181b84739bd0ba9dffcfa0159b1",
        "technical_result": "PASS" if _failures.is_empty() else "BLOCKED",
        "runtime_art_pass": false,
        "runtime_art_review": "PENDING_INDEPENDENT_ART_AND_USER_REVIEW",
        "world": {
            "runtime_width": 1740,
            "authored_runtime_width": 1740,
            "source_width_px": 2992,
            "source_height_px": 224,
            "source_baseline_y_px": 211,
            "source_world_to_runtime": SOURCE_TO_RUNTIME,
            "static_layer_indices": [0,1,2,3,4,5,6,7,8,9,11,12,13,14,15,16],
            "layer_10_runtime_imported": false,
            "bicycle_render_slots": 1,
            "mill_runtime_authority": "static_decorative_zero_interaction"
        },
        "labrador": {
            "identity_composite_count": 24,
            "runtime_scale": 0.24,
            "negative_scale": false,
            "runtime_count": 1,
            "render_lane_count": 1,
            "selectors": ["A","B","C","D","E","F","G","H"],
            "H_route_runtime_units": [H_LEFT, H_RIGHT],
            "H_cycles_per_traverse": 19,
            "H_gameplay_output_count": 0
        },
        "regressions": {
            "normal_path_record_count": _normal_path_records.size(),
            "legacy_unbound": ["UnloadTask", "CarryTask", "LoadVanTask"],
            "transfer_acceptance_cells": 0,
            "production_profile_mutated": false
        },
        "capture_environment": {
            "os": OS.get_name(),
            "godot_version": Engine.get_version_info(),
            "display_server": DisplayServer.get_name(),
            "screen_count": DisplayServer.get_screen_count(),
            "screen_index": DisplayServer.window_get_current_screen(),
            "window_size": DisplayServer.window_get_size()
        },
        "capture_files": _capture_files,
        "selector_snapshot_count": _selector_records.size(),
        "h_trace_record_count": _h_records.size()
    }
    _write_json("capture_manifest.json", manifest)
    var readme := FileAccess.open(_capture_root.path_join("README.md"), FileAccess.WRITE)
    if readme == null:
        _failures.append("capture README target unavailable")
    else:
        readme.store_string("# STEAM R48-05A source-reconciled runtime capture v1\n\nTechnical/mechanical evidence only. Runtime Art review and final user acceptance remain pending. Selector H is derived/non-persisted and produces zero gameplay output. R48-05B transfer remains out of scope.\n")
        _capture_files.append("README.md")


func _write_json(relative_path: String, value: Variant) -> void:
    var file := FileAccess.open(_capture_root.path_join(relative_path), FileAccess.WRITE)
    if file == null:
        _failures.append("cannot write evidence %s" % relative_path)
        return
    file.store_string(JSON.stringify(value, "  "))
    if relative_path not in _capture_files:
        _capture_files.append(relative_path)


func _write_jsonl(relative_path: String, records: Array) -> void:
    var file := FileAccess.open(_capture_root.path_join(relative_path), FileAccess.WRITE)
    if file == null:
        _failures.append("cannot write evidence %s" % relative_path)
        return
    for record in records:
        file.store_line(JSON.stringify(record))
    if relative_path not in _capture_files:
        _capture_files.append(relative_path)


func _base_snapshot() -> Dictionary:
    return {
        "actor": {"id":"dog.labrador_intro", "visible":true, "current_task":"", "current_visible_state":"idle", "world_x":H_LEFT, "move_start_x":H_LEFT, "move_target_x":H_LEFT},
        "task": {},
        "phase": {},
        "active_order": {"id":"order.first_warm_delivery", "status":"route_suggested", "delivery_state":"waiting_for_food_bag", "delivery_confirmed":false, "van_world_x":1395.431149732620},
        "active_chain": {"run_id":"run.first_day.first_warm_delivery"},
        "journey": {"phase":"first_day", "checkpoint_sequence":1, "barrier_failed":false, "commit_in_progress":false, "restore_incomplete":false},
        "presentation_guard": {"player_session_configured":false, "durable_readback_complete":false, "restore_incomplete":false, "authoritative_transition_active":false, "durable_cursor":1, "checkpoint_kind":"first_day_offered", "route_started":false, "trip_task_exists":false, "delivery_or_trip_active":false, "labrador_task_count":0, "task_queue_count":0},
        "first_day_history": {},
        "day2_history": {"completed":false},
        "recent_events": []
    }


func _h_snapshot(cursor: int, checkpoint_kind: String) -> Dictionary:
    var snapshot := _base_snapshot()
    snapshot["presentation_guard"]["player_session_configured"] = true
    snapshot["presentation_guard"]["durable_readback_complete"] = true
    snapshot["presentation_guard"]["durable_cursor"] = cursor
    snapshot["presentation_guard"]["checkpoint_kind"] = checkpoint_kind
    snapshot["journey"]["checkpoint_sequence"] = cursor
    if cursor == 18:
        snapshot["active_order"]["id"] = "order.second_warm_delivery_careful_pack"
        snapshot["active_order"]["status"] = "offered"
        snapshot["active_chain"]["run_id"] = "run.day2.second_warm_delivery"
        snapshot["journey"]["phase"] = "day2"
    elif cursor == 33:
        snapshot["active_order"] = {}
        snapshot["active_chain"] = {}
        snapshot["day2_history"] = {"completed":true}
        snapshot["journey"]["phase"] = "quiet_cooperative"
    return snapshot


func _station_snapshot(task_id: String, task_type: String, station_id: String, phase_index: int, status: String, dog_state: String, on_start: String, progress: float, move_start_x: float, move_target_x: float, order_id: String) -> Dictionary:
    var snapshot := _base_snapshot()
    var actor_progress := progress if phase_index == 0 else 1.0
    snapshot["actor"] = {"id":"dog.labrador_intro", "visible":true, "current_task":task_id, "current_visible_state":dog_state, "world_x":lerpf(move_start_x, move_target_x, actor_progress), "move_start_x":move_start_x, "move_target_x":move_target_x}
    snapshot["task"] = {"id":task_id, "type":task_type, "status":status, "order_id":order_id, "assigned_dog_id":"dog.labrador_intro", "source_object_id":station_id, "target_object_id":station_id}
    var duration := 0.324
    if phase_index == 1:
        duration = 0.8496 if task_type == "CookTask" else 0.72
    elif phase_index == 2:
        duration = 0.1872 if task_type == "CookTask" else 0.18
    snapshot["phase"] = {"index":phase_index, "status":status, "dog_state":dog_state, "elapsed_seconds":progress * duration, "duration_seconds":duration, "on_start":on_start, "on_complete":""}
    snapshot["active_order"]["id"] = order_id
    snapshot["presentation_guard"]["labrador_task_count"] = 1
    snapshot["journey"]["checkpoint_sequence"] = 25 if order_id == "order.second_warm_delivery_careful_pack" else 8
    return snapshot


func _legacy_snapshot(task_type: String) -> Dictionary:
    var snapshot := _base_snapshot()
    snapshot["actor"]["current_task"] = "task.legacy"
    snapshot["actor"]["current_visible_state"] = "carrying_item"
    snapshot["task"] = {"id":"task.legacy", "type":task_type, "status":"in_progress", "order_id":"order.first_warm_delivery", "assigned_dog_id":"dog.labrador_intro", "source_object_id":"object.storage", "target_object_id":"object.kitchen"}
    snapshot["phase"] = {"index":1, "status":"in_progress", "dog_state":"carrying_item", "elapsed_seconds":0.1, "duration_seconds":0.2}
    return snapshot


func _render_root(snapshot: Dictionary, state: Dictionary) -> float:
    return float((snapshot.get("actor", {}) as Dictionary).get("world_x", 0.0)) + float(state.get("station_offset_x", 0.0))


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


func _expect(condition: bool, message: String) -> void:
    if not condition:
        _failures.append(message)
