extends Node

const AdapterScene := preload("res://scenes/prototypes/vertical_slice/labrador_visual_adapter.tscn")
const PlayerBootScene := preload("res://scenes/player/player_boot.tscn")
const TEST_PROFILE := "user://player-tests/r48-05a-labrador-visual"
const TRACE_FIRST_DAY := "res://.runtime/labrador_r48_05a/visual_trace_first_day.jsonl"
const TRACE_DAY2 := "res://.runtime/labrador_r48_05a/visual_trace_day2.jsonl"
const STATE_HEIGHT_MINIMUMS := {"general":{"216":80,"144":52,"96":35},"kitchen_E":{"216":74,"144":49,"96":33},"packing_F":{"216":79,"144":53,"96":35},"focus_G":{"216":73,"144":49,"96":32}}
const STATE_MARGIN_MINIMUMS := {"native_224":4,"216":4,"144":3,"96":2}
const CONTACTING_FOREPAW_LAYER := "dog.leg.fore.near"
const PERMITTED_PAW_TIP_SOURCE_PX := 12
const PERMITTED_PAW_TIP_NATIVE_PX := 5

var _failures: Array[String] = []
var _capture_root := ""
var _capture_files: Array[String] = []
var _capture_keys: Dictionary = {}
var _capture_records: Array[Dictionary] = []
var _motion_counts: Dictionary = {}
var _motion_samples: Dictionary = {}
var _motion_metrics: Dictionary = {}
var _subject_height_readback: Dictionary = {}
var _identity_bbox_readbacks: Dictionary = {}
var _contact_readbacks: Dictionary = {}
var _mask_audit_readbacks: Dictionary = {}
var _turn_records: Array[Dictionary] = []
var _desktop_capture_status := "NOT_ATTEMPTED"
var _actual_player_window_readback: Dictionary = {}
var _proportional_context_status := "NOT_ATTEMPTED"


func _ready() -> void:
    _run.call_deferred()


func _run() -> void:
    var requested_capture := _capture_output_arg()
    if requested_capture != "":
        await _run_capture(requested_capture)
        _remove_tree(ProjectSettings.globalize_path(TEST_PROFILE))
        if _failures.is_empty():
            print("labrador_r48_05a_capture=passed files=%d" % _capture_files.size())
            get_tree().quit(0)
        else:
            for failure in _failures:
                push_error(failure)
            print("labrador_r48_05a_capture=failed count=%d" % _failures.size())
            get_tree().quit(1)
        return
    await _test_exact_selectors_and_presentation()
    await _test_player_boot_owned_first_day_and_day2()
    _remove_tree(ProjectSettings.globalize_path(TEST_PROFILE))
    if _failures.is_empty():
        print("labrador_r48_05a_visual_test=passed selectors=A-G cursors=33 legacy_unbound=3")
        get_tree().quit(0)
    else:
        for failure in _failures:
            push_error(failure)
        print("labrador_r48_05a_visual_test=failed count=%d" % _failures.size())
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


func _run_capture(output_dir: String) -> void:
    _capture_root = ProjectSettings.globalize_path(output_dir) if output_dir.begins_with("res://") or output_dir.begins_with("user://") else output_dir
    for generated_file in ["runtime_selector_snapshots.jsonl", "trace_excerpt.jsonl", "capture_manifest.json", "HASHES.sha256"]:
        var generated_path := _capture_root.path_join(generated_file)
        if FileAccess.file_exists(generated_path):
            DirAccess.remove_absolute(generated_path)
    for relative in ["captures/first_day", "captures/day2", "captures/quiet", "captures/synthetic_sides", "captures/mask_audit", "captures/turns", "captures/cancellation_recovery", "captures/motion", "captures/motion_strips", "captures/silhouettes", "captures/previews/216", "captures/previews/144", "captures/previews/96", "captures/desktop_composited", "captures/proportional", "logs"]:
        _remove_tree(_capture_root.path_join(relative))
        DirAccess.make_dir_recursive_absolute(_capture_root.path_join(relative))
    _remove_tree(ProjectSettings.globalize_path(TEST_PROFILE))
    DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(TRACE_FIRST_DAY).get_base_dir())

    var first_boot := await _capture_create_boot(false)
    if first_boot == null:
        return
    var first_runtime: Control = first_boot.call("player_runtime") as Control
    first_runtime.set_process(false)
    first_runtime.call("test_labrador_set_capture_ui_hidden", true)
    first_runtime.call("test_labrador_enable_trace", ProjectSettings.globalize_path(TRACE_FIRST_DAY))
    await _capture_synthetic_sides(first_runtime)
    await _capture_packing_mask_audit(first_runtime)
    await _capture_turn_directions(first_runtime)
    await _capture_cancellation_recovery(first_runtime)
    first_runtime.call("test_labrador_restore_runtime_observation")
    await get_tree().process_frame
    await _capture_proportional_context(first_runtime)
    await _capture_desktop_composited()
    await _capture_journey(first_runtime, "first_day", 17)
    first_boot.queue_free()
    await get_tree().process_frame

    var day2_boot := await _capture_create_boot(true)
    if day2_boot == null:
        return
    var day2_runtime: Control = day2_boot.call("player_runtime") as Control
    day2_runtime.set_process(false)
    day2_runtime.call("test_labrador_set_capture_ui_hidden", true)
    day2_runtime.call("test_labrador_enable_trace", ProjectSettings.globalize_path(TRACE_DAY2))
    await _capture_journey(day2_runtime, "day2", 33)
    day2_runtime.call("test_labrador_restore_runtime_observation")
    await get_tree().process_frame
    await _capture_named(day2_runtime, "quiet", "A_quiet_cooperative", day2_runtime.call("test_labrador_visual_snapshot") as Dictionary)
    day2_boot.queue_free()
    await get_tree().process_frame

    _write_motion_strips()
    _write_trace_excerpt()
    _write_capture_manifest()


func _capture_create_boot(begin_day2: bool) -> Control:
    var boot := PlayerBootScene.instantiate()
    var configured: Dictionary = boot.call("configure_player_boot", {"profile_base_dir":TEST_PROFILE, "test_mode":true}) as Dictionary
    _expect(bool(configured.get("ok", false)), "capture PlayerBoot configures")
    if not bool(configured.get("ok", false)):
        boot.queue_free()
        return null
    add_child(boot)
    await get_tree().process_frame
    if begin_day2:
        var lifecycle := boot.call("lifecycle_snapshot") as Dictionary
        _expect(str(lifecycle.get("action", "")) == "begin_day2_return", "capture PlayerBoot offers Day 2")
        var activation: Dictionary = boot.call("activate_lifecycle_action") as Dictionary
        _expect(bool(activation.get("ok", false)), "capture PlayerBoot activates Day 2")
        await get_tree().process_frame
    _expect(int((boot.call("lifecycle_snapshot") as Dictionary).get("runtime_child_count", 0)) == 1, "capture has one PlayerBoot-owned runtime")
    await get_tree().process_frame
    await get_tree().process_frame
    var window_size := DisplayServer.window_get_size()
    var window_position := DisplayServer.window_get_position()
    var screen_index := DisplayServer.window_get_current_screen()
    var usable_rect := DisplayServer.screen_get_usable_rect(screen_index)
    var bottom_delta := usable_rect.end.y - (window_position.y + window_size.y)
    _expect(window_size.y == 224, "actual PlayerBoot companion window keeps accepted 224 px height")
    _expect(usable_rect.size.x <= 0 or window_size.x == usable_rect.size.x, "actual PlayerBoot companion window uses full usable display width")
    _expect(usable_rect.size.y <= 0 or bottom_delta == 0, "actual PlayerBoot companion window is bottom-hugging")
    _expect(get_viewport().get_visible_rect().size.is_equal_approx(Vector2(window_size)), "capture uses the actual PlayerBoot window layout")
    if _actual_player_window_readback.is_empty():
        _actual_player_window_readback = {
            "window_size_px": [window_size.x, window_size.y],
            "window_position_px": [window_position.x, window_position.y],
            "screen_index": screen_index,
            "screen_usable_rect_px": [usable_rect.position.x, usable_rect.position.y, usable_rect.size.x, usable_rect.size.y],
            "full_usable_width": usable_rect.size.x > 0 and window_size.x == usable_rect.size.x,
            "bottom_edge_delta_px": bottom_delta,
            "bottom_hugging": usable_rect.size.y > 0 and bottom_delta == 0,
            "window_contract_mutated": false,
        }
    return boot


func _capture_journey(runtime: Control, journey: String, end_sequence: int) -> void:
    var safety := 0
    while safety < 12000:
        var sample := runtime.call("test_labrador_visual_snapshot") as Dictionary
        await _capture_sample(runtime, journey, sample)
        var observation := sample.get("observation", {}) as Dictionary
        var sequence := int((observation.get("journey", {}) as Dictionary).get("checkpoint_sequence", 0))
        if sequence >= end_sequence:
            break
        var step: Dictionary = runtime.call("test_labrador_step_player_visual") as Dictionary
        _expect(bool(step.get("ok", false)), "%s capture step remains safe" % journey)
        await get_tree().process_frame
        await get_tree().process_frame
        safety += 1
    _expect(safety < 12000, "%s capture reaches cursor %d" % [journey, end_sequence])


func _capture_sample(runtime: Control, journey: String, sample: Dictionary) -> void:
    _append_capture_record(journey, sample)
    var render := sample.get("render", {}) as Dictionary
    var observation := sample.get("observation", {}) as Dictionary
    var task := observation.get("task", {}) as Dictionary
    var selector := str(render.get("selector", ""))
    var lane := str(render.get("lane", ""))
    var key := ""
    if lane == "legacy_unbound":
        key = "legacy_unbound_%s" % str(render.get("reason", "unknown"))
    elif selector == "C":
        var elapsed := float((observation.get("phase", {}) as Dictionary).get("elapsed_seconds", 0.0))
        if elapsed > 0.0 or str(render.get("subphase", "")) != "start":
            key = "C_%s_%s" % [str(task.get("type", "station")), str(render.get("subphase", "phase"))]
    elif selector != "":
        key = selector
    if key != "":
        var unique := "%s:%s" % [journey, key]
        if not _capture_keys.has(unique):
            _capture_keys[unique] = true
            await _capture_named(runtime, journey, key, sample)

    if selector == "C" and str(task.get("type", "")) in ["CookTask", "PackTask"]:
        var motion_key := "%s_%s" % [journey, str(task.get("type", ""))]
        var count := int(_motion_counts.get(motion_key, 0))
        if count < 7:
            _motion_counts[motion_key] = count + 1
            var motion_sample := {
                "timestamp_seconds": float((observation.get("phase", {}) as Dictionary).get("elapsed_seconds", 0.0)),
                "root_world_x": float((observation.get("actor", {}) as Dictionary).get("world_x", 0.0)) + float(render.get("station_offset_x", 0.0)),
                "root_screen_x": float((sample.get("screen_root", Vector2.ZERO) as Vector2).x),
                "subphase": str(render.get("subphase", "")),
                "frame": "captures/motion/%s_%02d.png" % [motion_key, count],
            }
            if not _motion_samples.has(motion_key):
                _motion_samples[motion_key] = []
            (_motion_samples[motion_key] as Array).append(motion_sample)
            await _capture_named(runtime, "motion", "%s_%02d" % [motion_key, count], sample, false)


func _capture_named(runtime: Control, group: String, key: String, sample: Dictionary, make_previews: bool = true) -> void:
    runtime.call("test_labrador_center_camera")
    await get_tree().process_frame
    await get_tree().process_frame
    var image := get_viewport().get_texture().get_image()
    if image == null or image.is_empty():
        _failures.append("capture image unavailable: %s/%s" % [group, key])
        return
    var relative := "captures/%s/%s.png" % [group, key]
    var absolute := _capture_root.path_join(relative)
    var error := image.save_png(absolute)
    _expect(error == OK, "capture saved: %s" % relative)
    if error == OK:
        _capture_files.append(relative)
    if not make_previews:
        return
    var preview_images: Dictionary = {}
    for height in [216, 144, 96]:
        var preview := image.duplicate()
        var width := maxi(1, int(round(float(preview.get_width()) * float(height) / float(preview.get_height()))))
        preview.resize(width, height, Image.INTERPOLATE_LANCZOS)
        preview_images[height] = preview
        var preview_relative := "captures/previews/%d/%s_%s.png" % [height, group, key]
        var preview_error: Error = preview.save_png(_capture_root.path_join(preview_relative))
        _expect(preview_error == OK, "preview saved: %s" % preview_relative)
        if preview_error == OK:
            _capture_files.append(preview_relative)
    var captured_render := sample.get("render", {}) as Dictionary
    if str(captured_render.get("lane", "")).begins_with("authored"):
        runtime.call("test_labrador_set_capture_silhouette", true)
        await get_tree().process_frame
        await get_tree().process_frame
        var silhouette := get_viewport().get_texture().get_image()
        runtime.call("test_labrador_set_capture_silhouette", false)
        await get_tree().process_frame
        if silhouette == null or silhouette.is_empty():
            _failures.append("silhouette image unavailable: %s/%s" % [group, key])
            return
        var silhouette_relative := "captures/silhouettes/%s_%s.png" % [group, key]
        var silhouette_error: Error = silhouette.save_png(_capture_root.path_join(silhouette_relative))
        _expect(silhouette_error == OK, "silhouette saved: %s" % silhouette_relative)
        if silhouette_error == OK:
            _capture_files.append(silhouette_relative)
        var native_bounds := _difference_bounds(image, silhouette)
        var target_bounds: Dictionary = {}
        for height in [216, 144, 96]:
            var silhouette_preview := silhouette.duplicate()
            var width := maxi(1, int(round(float(silhouette_preview.get_width()) * float(height) / float(silhouette_preview.get_height()))))
            silhouette_preview.resize(width, height, Image.INTERPOLATE_LANCZOS)
            var silhouette_preview_relative := "captures/previews/%d/%s_%s_silhouette.png" % [height, group, key]
            var silhouette_preview_error: Error = silhouette_preview.save_png(_capture_root.path_join(silhouette_preview_relative))
            _expect(silhouette_preview_error == OK, "silhouette preview saved: %s" % silhouette_preview_relative)
            if silhouette_preview_error == OK:
                _capture_files.append(silhouette_preview_relative)
            target_bounds[str(height)] = _difference_bounds(preview_images[height] as Image, silhouette_preview)
        var state_family := _height_state_family(captured_render)
        var state_minimums := (STATE_HEIGHT_MINIMUMS[state_family] as Dictionary).duplicate(true)
        var bbox_readback := {
            "selector": str(captured_render.get("selector", "")),
            "state_family": state_family,
            "minimums_px": state_minimums,
            "native_224": _bounds_with_margins(native_bounds, image.get_width(), image.get_height()),
            "targets": {
                "216": _bounds_with_margins(target_bounds["216"] as Dictionary, (preview_images[216] as Image).get_width(), 216),
                "144": _bounds_with_margins(target_bounds["144"] as Dictionary, (preview_images[144] as Image).get_width(), 144),
                "96": _bounds_with_margins(target_bounds["96"] as Dictionary, (preview_images[96] as Image).get_width(), 96),
            },
        }
        _identity_bbox_readbacks["%s/%s" % [group, key]] = bbox_readback
        if group == "first_day" and key == "A":
            var player_fit_zoom := float(image.get_width()) / 1740.0
            var projected_source_height := 225.0 * 0.24 * player_fit_zoom
            var no_crop_mathematically_possible := projected_source_height <= float(image.get_height())
            _subject_height_readback = {
                "method": "clean_vs_identity_silhouette_changed_pixel_bbox",
                "source_layout": [image.get_width(), image.get_height()],
                "source_layout_resampled": true,
                "source_non_shadow_identity_height_px": 225,
                "player_fit_zoom": player_fit_zoom,
                "projected_full_identity_height_px": projected_source_height,
                "viewport_height_px": image.get_height(),
                "projected_height_overflow_px": maxf(0.0, projected_source_height - float(image.get_height())),
                "no_crop_mathematically_possible_at_locked_root": no_crop_mathematically_possible,
                "native_bbox_touches_top_edge": int(native_bounds.get("y", -1)) == 0,
                "technical_stop_code": "" if no_crop_mathematically_possible else "STOP_UNSUPPORTED_ACTOR_ENVELOPE",
                "native_224": bbox_readback["native_224"],
                "targets": bbox_readback["targets"],
                "minimums_px": (STATE_HEIGHT_MINIMUMS["general"] as Dictionary).duplicate(true),
                "minimum_top_bottom_margins_px": STATE_MARGIN_MINIMUMS.duplicate(true),
            }
            for height in [216, 144, 96]:
                var minimum := int((STATE_HEIGHT_MINIMUMS["general"] as Dictionary)[str(height)])
                _expect(int((target_bounds[str(height)] as Dictionary).get("height_px", 0)) >= minimum, "measured Labrador height at %d clears %d px" % [height, minimum])


func _height_state_family(render: Dictionary) -> String:
    match str(render.get("selector", "")):
        "E":
            return "kitchen_E"
        "F":
            return "packing_F"
        "G":
            return "focus_G"
        _:
            return "general"


func _bounds_with_margins(bounds: Dictionary, width: int, height: int) -> Dictionary:
    var result := bounds.duplicate(true)
    var x := int(bounds.get("x", 0))
    var y := int(bounds.get("y", 0))
    var bbox_width := int(bounds.get("width_px", 0))
    var bbox_height := int(bounds.get("height_px", 0))
    result["left_margin_px"] = x
    result["top_margin_px"] = y
    result["right_margin_px"] = width - (x + bbox_width)
    result["bottom_margin_px"] = height - (y + bbox_height)
    result["complete_bbox_inside_frame"] = (
        bbox_width > 0
        and bbox_height > 0
        and x > 0
        and y > 0
        and x + bbox_width < width
        and y + bbox_height < height
    )
    return result


func _difference_bounds(clean: Image, silhouette: Image) -> Dictionary:
    if clean == null or silhouette == null or clean.get_size() != silhouette.get_size():
        return {"x":0, "y":0, "width_px":0, "height_px":0}
    var min_x := clean.get_width()
    var min_y := clean.get_height()
    var max_x := -1
    var max_y := -1
    for y in clean.get_height():
        for x in clean.get_width():
            var a := clean.get_pixel(x, y)
            var b := silhouette.get_pixel(x, y)
            var changed := maxf(maxf(absf(a.r - b.r), absf(a.g - b.g)), maxf(absf(a.b - b.b), absf(a.a - b.a))) > 0.04
            if not changed:
                continue
            min_x = mini(min_x, x)
            min_y = mini(min_y, y)
            max_x = maxi(max_x, x)
            max_y = maxi(max_y, y)
    if max_x < min_x or max_y < min_y:
        return {"x":0, "y":0, "width_px":0, "height_px":0}
    return {
        "x": min_x,
        "y": min_y,
        "width_px": max_x - min_x + 1,
        "height_px": max_y - min_y + 1,
    }


func _capture_synthetic_sides(runtime: Control) -> void:
    for station in [
        {"id":"object.kitchen", "task":"CookTask", "work_state":"helping_kitchen", "on_start":"start_cooking", "work_selector":"E", "duration":0.8496},
        {"id":"object.packing_table", "task":"PackTask", "work_state":"packing", "on_start":"start_packing", "work_selector":"F", "duration":0.72},
    ]:
        for side in ["from_left", "from_right"]:
            runtime.call("test_labrador_restore_runtime_observation")
            var start_x := 400.0 if side == "from_left" else 1400.0
            var target_x := 760.0 if str(station["id"]) == "object.kitchen" else 1090.0
            var task_id := "capture.%s.%s" % [str(station["task"]), side]
            var c := _station_snapshot(task_id, str(station["task"]), str(station["id"]), 0, "moving_to_source", "walking", "", 0.12 if side == "from_right" else 0.50, start_x, target_x, "order.first_warm_delivery")
            runtime.call("test_labrador_observe_snapshot", c, 0.05)
            await get_tree().process_frame
            await _capture_named(runtime, "synthetic_sides", "%s_%s_C" % [str(station["task"]), side], runtime.call("test_labrador_visual_snapshot") as Dictionary)
            c["phase"]["elapsed_seconds"] = 0.99 * 0.324
            runtime.call("test_labrador_observe_snapshot", c, 0.05)
            var work := _station_snapshot(task_id, str(station["task"]), str(station["id"]), 1, "in_progress", str(station["work_state"]), str(station["on_start"]), 0.0, start_x, target_x, "order.first_warm_delivery")
            runtime.call("test_labrador_observe_snapshot", work, 0.05)
            await get_tree().process_frame
            await _capture_named(runtime, "synthetic_sides", "%s_%s_D" % [str(station["task"]), side], runtime.call("test_labrador_visual_snapshot") as Dictionary)
            work["phase"]["elapsed_seconds"] = 0.40 * float(station["duration"])
            runtime.call("test_labrador_observe_snapshot", work, 0.05)
            await get_tree().process_frame
            var work_sample := runtime.call("test_labrador_visual_snapshot") as Dictionary
            await _capture_named(runtime, "synthetic_sides", "%s_%s_%s" % [str(station["task"]), side, str(station["work_selector"])], work_sample)
            _record_contact_readback(str(station["id"]), side, work_sample)


func _capture_packing_mask_audit(runtime: Control) -> void:
    for side in ["from_left", "from_right"]:
        runtime.call("test_labrador_restore_runtime_observation")
        var start_x := 400.0 if side == "from_left" else 1400.0
        var target_x := 1090.0
        var task_id := "capture.mask.%s" % side
        var approach := _station_snapshot(task_id, "PackTask", "object.packing_table", 0, "moving_to_source", "walking", "", 0.50, start_x, target_x, "order.first_warm_delivery")
        runtime.call("test_labrador_observe_snapshot", approach, 0.05)
        await get_tree().process_frame
        var sample := runtime.call("test_labrador_visual_snapshot") as Dictionary
        await _capture_named(runtime, "mask_audit", "PackTask_%s_C_mask_inactive" % side, sample)
        _record_mask_audit("PackTask/%s/C_negative" % side, sample, false)

        approach["phase"]["elapsed_seconds"] = 0.99 * 0.324
        runtime.call("test_labrador_observe_snapshot", approach, 0.05)
        var work := _station_snapshot(task_id, "PackTask", "object.packing_table", 1, "in_progress", "packing", "start_packing", 0.99 * 0.18, start_x, target_x, "order.first_warm_delivery")
        runtime.call("test_labrador_observe_snapshot", work, 0.05)
        await get_tree().process_frame
        sample = runtime.call("test_labrador_visual_snapshot") as Dictionary
        await _capture_named(runtime, "mask_audit", "PackTask_%s_D_mask_active" % side, sample)
        _record_mask_audit("PackTask/%s/D_positive" % side, sample, true)

        work["phase"]["elapsed_seconds"] = 0.40 * 0.72
        runtime.call("test_labrador_observe_snapshot", work, 0.05)
        await get_tree().process_frame
        sample = runtime.call("test_labrador_visual_snapshot") as Dictionary
        await _capture_named(runtime, "mask_audit", "PackTask_%s_F_mask_active" % side, sample)
        _record_mask_audit("PackTask/%s/F_positive" % side, sample, true)

        var care := _station_snapshot(task_id, "PackTask", "object.packing_table", 1, "in_progress", "packing", "start_packing", 0.55, start_x, target_x, "order.second_warm_delivery_careful_pack")
        care["recent_events"] = [{"type":"labrador_packing_care_moment", "payload":{"order_id":"order.second_warm_delivery_careful_pack", "task_id":task_id}}]
        runtime.call("test_labrador_observe_snapshot", care, 0.05)
        await get_tree().process_frame
        sample = runtime.call("test_labrador_visual_snapshot") as Dictionary
        await _capture_named(runtime, "mask_audit", "PackTask_%s_G_mask_active" % side, sample)
        _record_mask_audit("PackTask/%s/G_positive" % side, sample, true)

        var contact_held_exit := _station_snapshot(task_id, "PackTask", "object.packing_table", 2, "completing", "packing", "", 0.02, start_x, target_x, "order.second_warm_delivery_careful_pack")
        runtime.call("test_labrador_observe_snapshot", contact_held_exit, 0.05)
        await get_tree().process_frame
        sample = runtime.call("test_labrador_visual_snapshot") as Dictionary
        await _capture_named(runtime, "mask_audit", "PackTask_%s_EXIT_contact_held_mask_active" % side, sample)
        _record_mask_audit("PackTask/%s/EXIT_positive" % side, sample, true)

        runtime.call("test_labrador_observe_snapshot", _base_snapshot(), 0.05)
        await get_tree().process_frame
        sample = runtime.call("test_labrador_visual_snapshot") as Dictionary
        await _capture_named(runtime, "mask_audit", "PackTask_%s_released_A_mask_inactive" % side, sample)
        _record_mask_audit("PackTask/%s/released_A_negative" % side, sample, false)

    runtime.call("test_labrador_restore_runtime_observation")
    var kitchen_approach := _station_snapshot("capture.mask.kitchen", "CookTask", "object.kitchen", 0, "moving_to_source", "walking", "", 0.99, 400.0, 760.0, "order.first_warm_delivery")
    runtime.call("test_labrador_observe_snapshot", kitchen_approach, 0.05)
    var kitchen_work := _station_snapshot("capture.mask.kitchen", "CookTask", "object.kitchen", 1, "in_progress", "helping_kitchen", "start_cooking", 0.99 * 0.18, 400.0, 760.0, "order.first_warm_delivery")
    runtime.call("test_labrador_observe_snapshot", kitchen_work, 0.05)
    await get_tree().process_frame
    var kitchen_sample := runtime.call("test_labrador_visual_snapshot") as Dictionary
    await _capture_named(runtime, "mask_audit", "CookTask_D_mask_inactive", kitchen_sample)
    _record_mask_audit("CookTask/D_negative", kitchen_sample, false)
    kitchen_work["phase"]["elapsed_seconds"] = 0.40 * 0.8496
    runtime.call("test_labrador_observe_snapshot", kitchen_work, 0.05)
    await get_tree().process_frame
    kitchen_sample = runtime.call("test_labrador_visual_snapshot") as Dictionary
    await _capture_named(runtime, "mask_audit", "CookTask_E_mask_inactive", kitchen_sample)
    _record_mask_audit("CookTask/E_negative", kitchen_sample, false)


func _record_mask_audit(key: String, sample: Dictionary, expected_active: bool) -> void:
    var mask := sample.get("packing_front_span_mask", {}) as Dictionary
    var overlap := _front_span_overlap_readback(sample, 0.0)
    var active := bool(mask.get("active", false))
    _expect(active == expected_active, "%s has exact selector-scoped mask state" % key)
    if expected_active:
        _expect(str(mask.get("authority", "")) == "derived_non_persisted_presentation" and not bool(mask.get("gameplay_authority", true)), "%s mask is derived presentation-only" % key)
        _expect(not bool(mask.get("global_z_reorder", true)) and not bool(mask.get("source_mutation", true)), "%s mask keeps source and global z unchanged" % key)
        _expect(bool(overlap.get("forbidden_overlap_absent", false)), "%s has zero forbidden screen/source overlap" % key)
        _expect(bool(overlap.get("paw_tip_policy_pass", false)), "%s keeps optional paw-tip overlap <=5 native px" % key)
    else:
        _expect(bool(mask.get("ordinary_front_span_ownership_restored", false)), "%s restores ordinary authored foreground ownership" % key)
    _mask_audit_readbacks[key] = {
        "expected_active": expected_active,
        "mask": mask,
        "overlap": overlap,
    }


func _record_contact_readback(station_id: String, side: String, sample: Dictionary) -> void:
    var render := sample.get("render", {}) as Dictionary
    var observation := sample.get("observation", {}) as Dictionary
    var actor := observation.get("actor", {}) as Dictionary
    var pose: Vector4 = render.get("base_pose", Vector4.ZERO)
    var focus: Vector2 = render.get("focus_pose", Vector2.ZERO)
    var facing := str(render.get("facing_source", "right"))
    var direction := 1.0 if facing == "right" else -1.0
    var zoom := float(sample.get("zoom", 0.0))
    var station_center_world := 760.0 if station_id == "object.kitchen" else 1090.0
    var contact_plane_source := [400.0, 188.0, 660.0, 255.0] if station_id == "object.kitchen" else [405.0, 176.0, 636.0, 252.0]
    var root_world := float(render.get("actor_world_x", actor.get("world_x", 0.0))) + float(render.get("station_offset_x", 0.0))
    var plane_world := {
        "left_x": station_center_world + (float(contact_plane_source[0]) - 512.0) * 0.24,
        "top_y_from_baseline": (float(contact_plane_source[1]) - 300.0) * 0.24,
        "right_x": station_center_world + (float(contact_plane_source[2]) - 512.0) * 0.24,
        "bottom_y_from_baseline": (float(contact_plane_source[3]) - 300.0) * 0.24,
    }
    var muzzle_x := root_world + direction * 217.0 * 0.24
    var muzzle_y_from_baseline := (145.0 - 280.0) * 0.24 + pose.x + focus.x
    var paw_source := Vector2(371.0, 277.0) if facing == "right" else Vector2(171.0, 277.0)
    var paw_x := root_world + (paw_source.x - 256.0) * 0.24 + pose.y * direction
    var paw_y_from_baseline := (paw_source.y - 280.0) * 0.24 + pose.x * 0.2 + pose.w + focus.y
    var muzzle_gap_px := absf(muzzle_x - station_center_world) * zoom
    var paw_inside := (
        paw_x >= float(plane_world["left_x"])
        and paw_x <= float(plane_world["right_x"])
        and paw_y_from_baseline >= float(plane_world["top_y_from_baseline"])
        and paw_y_from_baseline <= float(plane_world["bottom_y_from_baseline"])
    )
    var muzzle_inside := (
        muzzle_x >= float(plane_world["left_x"])
        and muzzle_x <= float(plane_world["right_x"])
        and muzzle_y_from_baseline >= float(plane_world["top_y_from_baseline"])
        and muzzle_y_from_baseline <= float(plane_world["bottom_y_from_baseline"])
    )
    var foreground_overlap := _front_span_overlap_readback(sample, 0.0)
    if station_id == "object.packing_table" and side == "from_right":
        foreground_overlap["bounded_registration_probe"] = {
            "accepted_source_root_translation_limit_px": 12.0,
            "accepted_world_translation_limit": 2.88,
            "minus_2_88_world": _front_span_overlap_readback(sample, -2.88),
            "plus_2_88_world": _front_span_overlap_readback(sample, 2.88),
            "first_source_alpha_clear_shift_world": -15.95,
            "clear_shift_probe": _front_span_overlap_readback(sample, -15.95),
            "next_0_01_world_probe": _front_span_overlap_readback(sample, -15.94),
            "muzzle_gap_at_clear_shift_px": absf((muzzle_x - station_center_world) - 15.95) * zoom,
        }
    var readback_key := "%s/%s" % [station_id, side]
    _contact_readbacks[readback_key] = {
        "facing": facing,
        "uniform_positive_scale": 0.24,
        "station_center_world_x": station_center_world,
        "root_world_x": root_world,
        "work_offset_world": absf(root_world - station_center_world),
        "contact_plane_world": plane_world,
        "muzzle_alpha_world": [muzzle_x, muzzle_y_from_baseline],
        "muzzle_alpha_gap_to_station_center_px": muzzle_gap_px,
        "muzzle_gap_lte_4_px": muzzle_gap_px <= 4.0,
        "muzzle_inside_contact_plane": muzzle_inside,
        "working_paw_world": [paw_x, paw_y_from_baseline],
        "working_paw_inside_contact_plane": paw_inside,
        "station_base_drawn_before_actor": true,
        "station_front_owner_runtime_art_present": false,
        "foreground_occlusion": foreground_overlap,
    }


func _front_span_overlap_readback(sample: Dictionary, root_shift_world: float) -> Dictionary:
    var render := sample.get("render", {}) as Dictionary
    var facing := str(render.get("facing_source", "right"))
    var pose: Vector4 = render.get("base_pose", Vector4.ZERO)
    var focus: Vector2 = render.get("focus_pose", Vector2.ZERO)
    var zoom := float(sample.get("zoom", 0.0))
    var screen_root: Vector2 = sample.get("screen_root", Vector2.ZERO)
    var viewport_size: Vector2 = sample.get("viewport_size", Vector2.ZERO)
    var front := Image.load_from_file(ProjectSettings.globalize_path("res://assets/prototypes/vertical_slice/authored/world/layers/13__world.fence.front_span.png"))
    var mask_snapshot := sample.get("packing_front_span_mask", {}) as Dictionary
    var mask_active := bool(mask_snapshot.get("active", false)) and is_zero_approx(root_shift_world)
    var mask_rect := _rect_from_array(mask_snapshot.get("source_rect", []) as Array) if mask_active else Rect2()
    var layer_ids := [
        "dog.leg.hind.far",
        "dog.leg.fore.far",
        "dog.tail",
        "dog.torso",
        "dog.marking.chest",
        "dog.detail.chest_fur",
        "dog.leg.hind.near",
        "dog.leg.fore.near",
        "dog.head",
        "dog.ear.far",
        "dog.ear.near",
        "dog.muzzle",
        "dog.eye.open",
        "dog.eye.blink",
        "dog.equipment.collar",
    ]
    var layers := {}
    var forbidden_screen_total := 0
    var forbidden_source_total := 0
    var allowed_paw_tip_screen_total := 0
    var raw_screen_total := 0
    var raw_source_total := 0
    for layer_id in layer_ids:
        var layer_path := _labrador_layer_path(facing, layer_id)
        var layer := Image.load_from_file(ProjectSettings.globalize_path(layer_path)) if layer_path != "" else Image.new()
        if layer == null or layer.is_empty() or front == null or front.is_empty() or zoom <= 0.0:
            layers[layer_id] = {"error":"runtime layer or foreground image unavailable"}
            continue
        var offsets := _labrador_layer_offsets(layer_id, facing, pose, focus)
        var offset_x := float(offsets[0]) + root_shift_world
        var offset_y := float(offsets[1])
        var render_scale := 0.24 * zoom
        var pivot_screen := screen_root + Vector2(offset_x, offset_y) * zoom
        var min_x := maxi(0, int(floor(pivot_screen.x - 256.0 * render_scale)) - 2)
        var max_x := mini(int(viewport_size.x), int(ceil(pivot_screen.x + 256.0 * render_scale)) + 2)
        var min_y := maxi(0, int(floor(pivot_screen.y - 280.0 * render_scale)) - 2)
        var max_y := mini(int(viewport_size.y), int(ceil(pivot_screen.y + 40.0 * render_scale)) + 2)
        var forbidden_screen := 0
        var allowed_paw_tip_screen := 0
        var raw_screen := 0
        var screen_min_x := int(viewport_size.x)
        var screen_min_y := int(viewport_size.y)
        var screen_max_x := -1
        var screen_max_y := -1
        for y in range(min_y, max_y):
            for x in range(min_x, max_x):
                var source_x := (float(x) + 0.5 - pivot_screen.x) / render_scale + 256.0
                var source_y := (float(y) + 0.5 - pivot_screen.y) / render_scale + 280.0
                if source_x < 0.0 or source_x >= float(layer.get_width()) or source_y < 0.0 or source_y >= float(layer.get_height()):
                    continue
                if layer.get_pixel(int(source_x), int(source_y)).a <= 0.04:
                    continue
                var front_x := (float(x) + 0.5) / zoom
                var front_y := 211.0 + (float(y) + 0.5 - screen_root.y) / zoom
                if front_x < 0.0 or front_x >= float(front.get_width()) or front_y < 0.0 or front_y >= float(front.get_height()):
                    continue
                if front.get_pixel(int(front_x), int(front_y)).a <= 0.04:
                    continue
                raw_screen += 1
                if mask_active and mask_rect.has_point(Vector2(front_x, front_y)):
                    continue
                var paw_tip: bool = layer_id == CONTACTING_FOREPAW_LAYER and source_y >= float(layer.get_height() - PERMITTED_PAW_TIP_SOURCE_PX)
                if paw_tip:
                    allowed_paw_tip_screen += 1
                else:
                    forbidden_screen += 1
                    screen_min_x = mini(screen_min_x, x)
                    screen_min_y = mini(screen_min_y, y)
                    screen_max_x = maxi(screen_max_x, x)
                    screen_max_y = maxi(screen_max_y, y)
        var forbidden_source := 0
        var raw_source := 0
        for source_y in layer.get_height():
            for source_x in layer.get_width():
                if layer.get_pixel(source_x, source_y).a <= 0.04:
                    continue
                var world_x := (screen_root.x / zoom) + root_shift_world + (float(source_x) - 256.0) * 0.24 + float(offsets[0])
                var world_y := 211.0 + (float(source_y) - 280.0) * 0.24 + offset_y
                var front_source_x := int(round(world_x))
                var front_source_y := int(round(world_y))
                if front_source_x < 0 or front_source_x >= front.get_width() or front_source_y < 0 or front_source_y >= front.get_height():
                    continue
                if front.get_pixel(front_source_x, front_source_y).a <= 0.04:
                    continue
                raw_source += 1
                if mask_active and mask_rect.has_point(Vector2(float(front_source_x) + 0.5, float(front_source_y) + 0.5)):
                    continue
                var paw_tip: bool = layer_id == CONTACTING_FOREPAW_LAYER and source_y >= layer.get_height() - PERMITTED_PAW_TIP_SOURCE_PX
                if not paw_tip:
                    forbidden_source += 1
        var bbox := {"x":0, "y":0, "width_px":0, "height_px":0}
        if screen_max_x >= screen_min_x and screen_max_y >= screen_min_y:
            bbox = {
                "x": screen_min_x,
                "y": screen_min_y,
                "width_px": screen_max_x - screen_min_x + 1,
                "height_px": screen_max_y - screen_min_y + 1,
            }
        layers[layer_id] = {
            "runtime_rendered": layer_id != "dog.equipment.collar",
            "raw_front_span_screen_pixels": raw_screen,
            "raw_front_span_source_alpha_pixels": raw_source,
            "forbidden_screen_pixels": forbidden_screen,
            "forbidden_source_alpha_pixels": forbidden_source,
            "allowed_lower_paw_tip_screen_pixels": allowed_paw_tip_screen,
            "forbidden_screen_bbox": bbox,
        }
        forbidden_screen_total += forbidden_screen
        forbidden_source_total += forbidden_source
        allowed_paw_tip_screen_total += allowed_paw_tip_screen
        raw_screen_total += raw_screen
        raw_source_total += raw_source
    return {
        "occluder": "world.fence.front_span",
        "occluder_is_station_replacement_art": false,
        "root_shift_world": root_shift_world,
        "mask_active": mask_active,
        "mask_snapshot": mask_snapshot,
        "raw_before_mask": {
            "screen_pixels": raw_screen_total,
            "source_alpha_pixels": raw_source_total,
        },
        "forbidden_screen_pixels": forbidden_screen_total,
        "forbidden_source_alpha_pixels": forbidden_source_total,
        "allowed_lower_paw_tip_screen_pixels": allowed_paw_tip_screen_total,
        "permitted_contacting_forepaw_layer": CONTACTING_FOREPAW_LAYER,
        "permitted_paw_tip_source_px": PERMITTED_PAW_TIP_SOURCE_PX,
        "permitted_paw_tip_native_screen_px": PERMITTED_PAW_TIP_NATIVE_PX,
        "paw_tip_policy_pass": allowed_paw_tip_screen_total <= PERMITTED_PAW_TIP_NATIVE_PX,
        "forbidden_overlap_absent": forbidden_screen_total == 0 and forbidden_source_total == 0,
        "overlay_classes": {
            "task_overlay": {"rendered":false, "forbidden_screen_pixels":0, "forbidden_source_alpha_pixels":0},
            "effect_overlay": {"rendered":false, "forbidden_screen_pixels":0, "forbidden_source_alpha_pixels":0},
            "object_overlay": {"rendered":false, "forbidden_screen_pixels":0, "forbidden_source_alpha_pixels":0},
        },
        "layers": layers,
    }


func _rect_from_array(values: Array) -> Rect2:
    if values.size() != 4:
        return Rect2()
    return Rect2(float(values[0]), float(values[1]), float(values[2]), float(values[3]))


func _labrador_layer_offsets(layer_id: String, facing: String, pose: Vector4, focus: Vector2) -> Array[float]:
    var direction := 1.0 if facing == "right" else -1.0
    var offset_x := 0.0
    var offset_y := 0.0
    if layer_id.begins_with("dog.leg.fore"):
        offset_x += pose.y * direction
        offset_y += pose.x * 0.2
        if layer_id == "dog.leg.fore.near":
            offset_y += pose.w + focus.y
    elif layer_id.begins_with("dog.leg.hind"):
        offset_x += pose.z * direction
        offset_y += pose.x * 0.2
    elif layer_id in ["dog.head", "dog.ear.far", "dog.ear.near", "dog.muzzle", "dog.eye.open", "dog.eye.blink"]:
        offset_y += pose.x + focus.x
    else:
        offset_y += pose.x
    return [offset_x, offset_y]


func _labrador_layer_path(facing: String, layer_id: String) -> String:
    var directory := "res://assets/prototypes/vertical_slice/authored/dogs/labrador_intro/%s/layers" % facing
    for file_name in DirAccess.get_files_at(directory):
        if file_name.ends_with("__%s.png" % layer_id):
            return directory.path_join(file_name)
    return ""


func _capture_turn_directions(runtime: Control) -> void:
    runtime.call("test_labrador_restore_runtime_observation")
    var right_to_left := _station_snapshot("capture.turn.right_to_left", "CookTask", "object.kitchen", 0, "moving_to_source", "walking", "", 0.02, 1400.0, 760.0, "order.first_warm_delivery")
    await _capture_turn_sequence(runtime, right_to_left, "right_to_left", ["right", "turn_mid", "left"])
    right_to_left["phase"]["elapsed_seconds"] = 0.45 * 0.324
    runtime.call("test_labrador_observe_snapshot", right_to_left, 0.05)

    var left_to_right := _station_snapshot("capture.turn.left_to_right", "CookTask", "object.kitchen", 0, "moving_to_source", "walking", "", 0.02, 400.0, 760.0, "order.first_warm_delivery")
    await _capture_turn_sequence(runtime, left_to_right, "left_to_right", ["left", "turn_mid", "right"])
    left_to_right["phase"]["elapsed_seconds"] = 0.45 * 0.324
    runtime.call("test_labrador_observe_snapshot", left_to_right, 0.05)


func _capture_turn_sequence(runtime: Control, snapshot: Dictionary, direction: String, expected_facings: Array) -> void:
    var roots: Array[float] = []
    var facings: Array[String] = []
    var progresses := [0.02, 0.20, 0.36]
    for index in progresses.size():
        snapshot["phase"]["elapsed_seconds"] = float(progresses[index]) * 0.324
        var render := runtime.call("test_labrador_observe_snapshot", snapshot, 0.05) as Dictionary
        await get_tree().process_frame
        var sample := runtime.call("test_labrador_visual_snapshot") as Dictionary
        roots.append(float((sample.get("screen_root", Vector2.ZERO) as Vector2).x))
        facings.append(str(render.get("facing_source", "")))
        await _capture_named(runtime, "turns", "%s_%02d_%s" % [direction, index, str(expected_facings[index])], sample)
    var root_locked := absf(roots.max() - roots.min()) <= 0.01
    _expect(facings == expected_facings, "%s physical turn uses exact authored sequence" % direction)
    _expect(root_locked, "%s physical turn keeps root locked" % direction)
    _turn_records.append({
        "direction": direction,
        "progress_samples": progresses,
        "facing_sequence": facings,
        "root_screen_x_samples": roots,
        "root_locked": root_locked,
        "negative_scale": false,
    })


func _write_motion_strips() -> void:
    var expected := ["first_day_CookTask", "first_day_PackTask", "day2_CookTask", "day2_PackTask"]
    for motion_key in expected:
        var samples := _motion_samples.get(motion_key, []) as Array
        _expect(samples.size() >= 5, "%s has at least five even timestamp samples" % motion_key)
        if samples.is_empty():
            continue
        var even_timestamps := true
        var timestamp_interval := -1.0
        var visible_intervals := 0
        var max_root_interval := 0.0
        for index in range(1, samples.size()):
            var previous := samples[index - 1] as Dictionary
            var current := samples[index] as Dictionary
            var delta_time := float(current.get("timestamp_seconds", 0.0)) - float(previous.get("timestamp_seconds", 0.0))
            if timestamp_interval < 0.0:
                timestamp_interval = delta_time
            elif not is_equal_approx(delta_time, timestamp_interval):
                even_timestamps = false
            var root_interval := absf(float(current.get("root_world_x", 0.0)) - float(previous.get("root_world_x", 0.0)))
            max_root_interval = maxf(max_root_interval, root_interval)
            if root_interval > 0.01:
                visible_intervals += 1
        var full_path := absf(float((samples[-1] as Dictionary).get("root_world_x", 0.0)) - float((samples[0] as Dictionary).get("root_world_x", 0.0)))
        var max_interval_ratio := max_root_interval / maxf(full_path, 0.001)
        _expect(even_timestamps, "%s timestamps are even" % motion_key)
        _expect(visible_intervals >= 5, "%s root motion is visible across at least five consecutive samples" % motion_key)
        _expect(max_interval_ratio <= 0.35, "%s max interval is <=35%% of full path" % motion_key)

        var first_frame := Image.load_from_file(_capture_root.path_join(str((samples[0] as Dictionary).get("frame", ""))))
        if first_frame == null or first_frame.is_empty():
            _failures.append("motion strip first frame unavailable: %s" % motion_key)
            continue
        first_frame.convert(Image.FORMAT_RGBA8)
        var strip := Image.create(first_frame.get_width() * samples.size(), first_frame.get_height(), false, Image.FORMAT_RGBA8)
        strip.fill(Color(0.0, 0.0, 0.0, 0.0))
        var frame_paths: Array[String] = []
        for index in samples.size():
            var frame_relative := str((samples[index] as Dictionary).get("frame", ""))
            var frame := Image.load_from_file(_capture_root.path_join(frame_relative))
            if frame == null or frame.is_empty():
                _failures.append("motion strip frame unavailable: %s" % frame_relative)
                continue
            frame.convert(Image.FORMAT_RGBA8)
            strip.blit_rect(frame, Rect2i(Vector2i.ZERO, frame.get_size()), Vector2i(index * first_frame.get_width(), 0))
            frame_paths.append(frame_relative)
        var strip_relative := "captures/motion_strips/%s_1x_even.png" % motion_key
        var strip_error: Error = strip.save_png(_capture_root.path_join(strip_relative))
        _expect(strip_error == OK, "motion strip saved: %s" % strip_relative)
        if strip_error == OK:
            _capture_files.append(strip_relative)
        _motion_metrics[motion_key] = {
            "speed": "1x_normal",
            "timestamps_seconds": samples.map(func(entry: Dictionary) -> float: return float(entry.get("timestamp_seconds", 0.0))),
            "timestamp_interval_seconds": timestamp_interval,
            "even_timestamps": even_timestamps,
            "root_world_x_samples": samples.map(func(entry: Dictionary) -> float: return float(entry.get("root_world_x", 0.0))),
            "full_path_world_units": full_path,
            "visible_root_intervals": visible_intervals,
            "max_root_interval_world_units": max_root_interval,
            "max_interval_ratio": max_interval_ratio,
            "subphases": samples.map(func(entry: Dictionary) -> String: return str(entry.get("subphase", ""))),
            "full_player_context": true,
            "frame_paths": frame_paths,
            "strip_path": strip_relative,
        }


func _capture_desktop_composited() -> void:
    await get_tree().process_frame
    await get_tree().process_frame
    var player_image := get_viewport().get_texture().get_image()
    if player_image == null or player_image.is_empty():
        _failures.append("desktop composite player image unavailable")
        return
    player_image.convert(Image.FORMAT_RGBA8)
    var checker := Image.create(player_image.get_width(), player_image.get_height(), false, Image.FORMAT_RGBA8)
    checker.fill(Color(0.22, 0.24, 0.27, 1.0))
    var tile := 16
    for y in range(0, checker.get_height(), tile):
        for x in range(0, checker.get_width(), tile):
            if (int(x / tile) + int(y / tile)) % 2 == 0:
                checker.fill_rect(Rect2i(x, y, mini(tile, checker.get_width() - x), mini(tile, checker.get_height() - y)), Color(0.31, 0.34, 0.38, 1.0))
    checker.blend_rect(player_image, Rect2i(Vector2i.ZERO, player_image.get_size()), Vector2i.ZERO)
    var checker_relative := "captures/desktop_composited/player_alpha_over_checker.png"
    var checker_error: Error = checker.save_png(_capture_root.path_join(checker_relative))
    _expect(checker_error == OK, "deterministic transparency composite saved")
    if checker_error == OK:
        _capture_files.append(checker_relative)

    var window_size := DisplayServer.window_get_size()
    var screen_index := DisplayServer.window_get_current_screen()
    var screen_position := DisplayServer.screen_get_position(screen_index)
    var window_position := DisplayServer.window_get_position()
    var desktop_relative := "captures/desktop_composited/macos_desktop_window.png"
    var desktop_absolute := _capture_root.path_join(desktop_relative)
    var full_display_relative := "captures/desktop_composited/macos_desktop_full_display.png"
    var full_display_absolute := _capture_root.path_join(full_display_relative)
    var command_output: Array = []
    var capture_code := OS.execute("/usr/sbin/screencapture", ["-x", "-D", str(screen_index + 1), full_display_absolute], command_output, true)
    var full_display := Image.load_from_file(full_display_absolute) if capture_code == 0 else null
    var relative_position := window_position - screen_position
    var crop_rect := Rect2i(relative_position, window_size)
    var exact_crop := full_display != null and not full_display.is_empty() and Rect2i(Vector2i.ZERO, full_display.get_size()).encloses(crop_rect)
    if exact_crop:
        var window_composite := full_display.get_region(crop_rect)
        window_composite.save_png(desktop_absolute)
    var actual_saved := exact_crop and FileAccess.file_exists(desktop_absolute)
    _expect(actual_saved, "macOS desktop-composited transparent window capture saved")
    if actual_saved:
        _capture_files.append(full_display_relative)
        _capture_files.append(desktop_relative)
        _desktop_capture_status = "ACTUAL_PLAYERBOOT_BOTTOM_EDGE_FULL_DISPLAY_PLACEMENT_PROOF__EXACT_WINDOW_CROP_IS_REGION_READBACK_NOT_FULL_DISPLAY_PROOF__DETERMINISTIC_ALPHA_CHECKER"
    else:
        _desktop_capture_status = "OS_CAPTURE_FAILED__CHECKER_ONLY"


func _capture_proportional_context(runtime: Control) -> void:
    var sample := runtime.call("test_labrador_visual_snapshot") as Dictionary
    var viewport_size: Vector2 = sample.get("viewport_size", Vector2.ZERO)
    var context := sample.get("proportional_context", {}) as Dictionary
    var ordered := [
        float(context.get("labrador_screen_x", -1.0)),
        float(context.get("kitchen_screen_x", -1.0)),
        float(context.get("packing_table_screen_x", -1.0)),
        float(context.get("delivery_van_screen_x", -1.0)),
    ]
    _expect(ordered[0] >= 0.0 and ordered[3] <= viewport_size.x, "proportional context keeps Labrador, Kitchen, Packing and Van inside actual window")
    _expect(ordered[0] < ordered[1] and ordered[1] < ordered[2] and ordered[2] < ordered[3], "proportional context preserves Labrador/Kitchen/Packing/Van ordering")
    await _capture_named(runtime, "proportional", "labrador_van_kitchen_packing_actual_window", sample, false)
    _proportional_context_status = "ACTUAL_PLAYERBOOT_WINDOW__LABRADOR_KITCHEN_PACKING_VAN__NO_LABELS__NO_TRANSFER"


func _capture_cancellation_recovery(runtime: Control) -> void:
    runtime.call("test_labrador_restore_runtime_observation")
    var approach := _station_snapshot("capture.cancel.cook", "CookTask", "object.kitchen", 0, "moving_to_source", "walking", "", 0.50, 400.0, 760.0, "order.first_warm_delivery")
    runtime.call("test_labrador_observe_snapshot", approach, 0.05)
    await _capture_named(runtime, "cancellation_recovery", "before_contact_C", runtime.call("test_labrador_visual_snapshot") as Dictionary)

    var stale := approach.duplicate(true)
    stale["actor"]["current_task"] = "capture.cancel.other"
    runtime.call("test_labrador_observe_snapshot", stale, 0.05)
    await _capture_named(runtime, "cancellation_recovery", "stale_task_suppressed", runtime.call("test_labrador_visual_snapshot") as Dictionary)

    var recovered_idle := _base_snapshot()
    runtime.call("test_labrador_observe_snapshot", recovered_idle, 0.05)
    await _capture_named(runtime, "cancellation_recovery", "cancel_before_contact_recovered_A", runtime.call("test_labrador_visual_snapshot") as Dictionary)

    var care := _station_snapshot("capture.cancel.day2", "PackTask", "object.packing_table", 1, "in_progress", "packing", "start_packing", 0.55, 1450.0, 1090.0, "order.second_warm_delivery_careful_pack")
    care["recent_events"] = [{"type":"labrador_packing_care_moment", "payload":{"order_id":"order.second_warm_delivery_careful_pack", "task_id":"capture.cancel.day2"}}]
    runtime.call("test_labrador_observe_snapshot", care, 0.05)
    await _capture_named(runtime, "cancellation_recovery", "loop_boundary_G", runtime.call("test_labrador_visual_snapshot") as Dictionary)

    var failed := care.duplicate(true)
    failed["journey"]["barrier_failed"] = true
    runtime.call("test_labrador_observe_snapshot", failed, 0.05)
    await _capture_named(runtime, "cancellation_recovery", "save_failure_suppressed", runtime.call("test_labrador_visual_snapshot") as Dictionary)

    var retry := care.duplicate(true)
    retry["recent_events"] = []
    retry["journey"]["checkpoint_sequence"] = 26
    runtime.call("test_labrador_observe_snapshot", retry, 0.05)
    await _capture_named(runtime, "cancellation_recovery", "save_retry_recovered_F", runtime.call("test_labrador_visual_snapshot") as Dictionary)


func _append_capture_record(journey: String, sample: Dictionary) -> void:
    var observation := sample.get("observation", {}) as Dictionary
    var render := sample.get("render", {}) as Dictionary
    var record := {
        "journey": journey,
        "actor": observation.get("actor", {}),
        "task": observation.get("task", {}),
        "phase": observation.get("phase", {}),
        "active_order": observation.get("active_order", {}),
        "active_chain": observation.get("active_chain", {}),
        "checkpoint": observation.get("journey", {}),
        "lane": render.get("lane", ""),
        "selector": render.get("selector", ""),
        "base_selector": render.get("base_selector", ""),
        "subphase": render.get("subphase", ""),
        "facing_source": render.get("facing_source", ""),
        "requested_facing": render.get("requested_facing", ""),
        "last_rendered_facing": render.get("last_rendered_facing", ""),
        "station_offset_x": render.get("station_offset_x", 0.0),
        "packing_front_span_mask_active": render.get("packing_front_span_mask_active", false),
        "packing_front_span_mask_owner": render.get("packing_front_span_mask_owner", ""),
        "runtime_authority": render.get("runtime_authority", ""),
        "gameplay_output_count": render.get("gameplay_output_count", -1),
        "transfer_semantics": render.get("transfer_semantics", true),
    }
    _capture_records.append(record)
    var path := _capture_root.path_join("runtime_selector_snapshots.jsonl")
    var mode := FileAccess.READ_WRITE if FileAccess.file_exists(path) else FileAccess.WRITE
    var file := FileAccess.open(path, mode)
    if file != null:
        file.seek_end()
        file.store_line(JSON.stringify(record))


func _write_trace_excerpt() -> void:
    var target := FileAccess.open(_capture_root.path_join("trace_excerpt.jsonl"), FileAccess.WRITE)
    if target == null:
        _failures.append("trace excerpt target unavailable")
        return
    var written := 0
    for source_path in [ProjectSettings.globalize_path(TRACE_FIRST_DAY), ProjectSettings.globalize_path(TRACE_DAY2)]:
        if not FileAccess.file_exists(source_path):
            continue
        var source := FileAccess.open(source_path, FileAccess.READ)
        while source != null and not source.eof_reached() and written < 180:
            var line := source.get_line()
            if line != "":
                target.store_line(line)
                written += 1
    _expect(written > 0, "persistent trace excerpt contains markers")


func _write_capture_manifest() -> void:
    var selector_counts := {}
    for record in _capture_records:
        var selector := str(record.get("selector", ""))
        if selector != "":
            selector_counts[selector] = int(selector_counts.get(selector, 0)) + 1
    _expect(_motion_metrics.size() == 4, "capture contains four 1x even-timestamp motion strips")
    _expect(not _subject_height_readback.is_empty(), "capture contains exact 216/144/96 subject-height readback")
    _expect(_turn_records.size() == 2, "capture contains both root-locked physical turn directions")
    _expect(_desktop_capture_status.begins_with("ACTUAL_PLAYERBOOT"), "capture contains actual bottom-edge PlayerBoot desktop composite")
    _expect(not _actual_player_window_readback.is_empty(), "capture records actual PlayerBoot window truth")
    _expect(_proportional_context_status.begins_with("ACTUAL_PLAYERBOOT"), "capture contains one actual proportional Labrador/stations/Van frame")
    var actual_window_size := _actual_player_window_readback.get("window_size_px", [0, 0]) as Array
    var actual_width := float(actual_window_size[0]) if actual_window_size.size() == 2 else 0.0
    var no_crop_possible := bool(_subject_height_readback.get("no_crop_mathematically_possible_at_locked_root", false))
    var bbox_gate := true
    var bbox_gate_failures: Array[String] = []
    for readback_key in _identity_bbox_readbacks:
        var readback := _identity_bbox_readbacks[readback_key] as Dictionary
        var native := readback.get("native_224", {}) as Dictionary
        var targets := readback.get("targets", {}) as Dictionary
        var native_ok := bool(native.get("complete_bbox_inside_frame", false)) and int(native.get("top_margin_px", 0)) >= 4 and int(native.get("bottom_margin_px", 0)) >= 4
        if not native_ok:
            bbox_gate = false
            bbox_gate_failures.append("%s/native_224" % readback_key)
        for height in [216, 144, 96]:
            var target := targets.get(str(height), {}) as Dictionary
            var state_minimums := readback.get("minimums_px", STATE_HEIGHT_MINIMUMS["general"]) as Dictionary
            var minimum_height := int(state_minimums.get(str(height), 0))
            var minimum_margin := int(STATE_MARGIN_MINIMUMS[str(height)])
            var target_ok := (
                bool(target.get("complete_bbox_inside_frame", false))
                and int(target.get("height_px", 0)) >= minimum_height
                and int(target.get("top_margin_px", 0)) >= minimum_margin
                and int(target.get("bottom_margin_px", 0)) >= minimum_margin
            )
            if not target_ok:
                bbox_gate = false
                bbox_gate_failures.append("%s/%d" % [readback_key, height])
    var contact_gate := _contact_readbacks.size() == 4
    var contact_gate_failures: Array[String] = []
    var foreground_gate := true
    var foreground_gate_failures: Array[String] = []
    for readback_key in _contact_readbacks:
        var readback := _contact_readbacks[readback_key] as Dictionary
        var contact_ok := (
            bool(readback.get("muzzle_gap_lte_4_px", false))
            and bool(readback.get("muzzle_inside_contact_plane", false))
            and bool(readback.get("working_paw_inside_contact_plane", false))
        )
        if not contact_ok:
            contact_gate = false
            contact_gate_failures.append(str(readback_key))
        var foreground := readback.get("foreground_occlusion", {}) as Dictionary
        if not bool(foreground.get("forbidden_overlap_absent", false)):
            foreground_gate = false
            foreground_gate_failures.append(str(readback_key))
    var mask_gate := _mask_audit_readbacks.size() == 14
    var mask_gate_failures: Array[String] = []
    var mask_positive_count := 0
    var mask_negative_count := 0
    for readback_key in _mask_audit_readbacks:
        var audit := _mask_audit_readbacks[readback_key] as Dictionary
        var expected_active := bool(audit.get("expected_active", false))
        var mask := audit.get("mask", {}) as Dictionary
        var overlap := audit.get("overlap", {}) as Dictionary
        if expected_active:
            mask_positive_count += 1
            var positive_ok := (
                bool(mask.get("active", false))
                and str(mask.get("authority", "")) == "derived_non_persisted_presentation"
                and not bool(mask.get("global_z_reorder", true))
                and not bool(mask.get("source_mutation", true))
                and bool(overlap.get("forbidden_overlap_absent", false))
                and int(overlap.get("forbidden_screen_pixels", -1)) == 0
                and int(overlap.get("forbidden_source_alpha_pixels", -1)) == 0
                and int(overlap.get("allowed_lower_paw_tip_screen_pixels", 999)) <= PERMITTED_PAW_TIP_NATIVE_PX
            )
            if not positive_ok:
                mask_gate = false
                mask_gate_failures.append(str(readback_key))
        else:
            mask_negative_count += 1
            if bool(mask.get("active", true)) or not bool(mask.get("ordinary_front_span_ownership_restored", false)):
                mask_gate = false
                mask_gate_failures.append(str(readback_key))
    if mask_positive_count != 8 or mask_negative_count != 6:
        mask_gate = false
        mask_gate_failures.append("expected_8_positive_6_negative_cells")
    var hard_gates_pass := no_crop_possible and bbox_gate and contact_gate and foreground_gate and mask_gate
    var technical_result := "PASS" if hard_gates_pass else "BLOCKED"
    var technical_stop_code := "" if hard_gates_pass else "STOP_UNSUPPORTED_ACTOR_ENVELOPE"
    var blocker_reason := "none"
    if not no_crop_possible or not bbox_gate:
        blocker_reason = "exact_0_24_full_width_identity_failed_locked_root_height_bbox_or_margin_gate"
    elif not contact_gate:
        blocker_reason = "exact_0_24_station_contact_failed_muzzle_or_working_paw_gate"
    elif not foreground_gate:
        blocker_reason = "exact_0_24_from_right_packing_torso_intersects_authored_world_front_span_and_bounded_contact_registration_cannot_clear_it"
    elif not mask_gate:
        blocker_reason = "selector_scoped_packing_front_span_mask_failed_exact_overlap_or_negative_cell_policy"
    var manifest := {
        "schema_version": "shelter.r48_05a.runtime_capture/v5",
        "milestone": "R48-05A / P0-B + P0-D",
        "captured_at_utc": Time.get_datetime_string_from_system(true),
        "git_commit": _capture_git_commit_arg(),
        "working_tree_expected_dirty": true,
        "technical_result": technical_result,
        "technical_stop_code": technical_stop_code,
        "technical_blocker": {
            "active": not hard_gates_pass,
            "reason": blocker_reason,
            "no_touch_alternatives_rejected": ["PlayerBoot_window_height_change", "scale_or_root_guess", "global_authored_world_front_owner_reorder", "source_asset_rewrite", "contact_breaking_station_shift"],
        },
        "godot_version": Engine.get_version_info().get("string", "unknown"),
        "runtime_authority": "godot_state",
        "player_owner": "PlayerBoot",
        "runtime_count": 1,
        "labrador_count": 1,
        "normal_timing_scale": 0.72,
        "phase0_duration_seconds": 0.324,
        "framing": {
            "player_layout_px": actual_window_size,
            "corridor_world_x": [0, 1740],
            "authored_world_x": [0, 1536],
            "non_authored_tail_world_x": [1536, 1740],
            "non_authored_tail_authored_claim": false,
            "tail_stitch_underlay_world_x": [1532, 1536],
            "source_stretch": false,
            "player_fit_zoom": actual_width / 1740.0,
            "authored_screen_max_x": 1536.0 * actual_width / 1740.0,
            "corridor_screen_max_x": actual_width,
            "transparent_horizontal_camera_gap": false,
        },
        "labrador_scale": {
            "previous_trial_uniform_scale": 0.24,
            "art_owner_locked_uniform_scale": 0.24,
            "runtime_uniform_positive_scale": 0.24,
            "negative_scale": false,
            "non_uniform_scale": false,
        },
        "source_authority_sha256": FileAccess.get_sha256(ProjectSettings.globalize_path("res://../docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Labrador_P0_Accepted_Action_Manifest_v1.md")),
        "art_resolution_authority_sha256": FileAccess.get_sha256(ProjectSettings.globalize_path("res://../docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_R48_05A_LABRADOR_RUNTIME_CAPTURE_v4/OWNER_REVIEW.md")),
        "binding_sha256": FileAccess.get_sha256(ProjectSettings.globalize_path("res://resources/prototypes/vertical_slice/labrador_r48_05a_binding_v1.json")),
        "station_binding_sha256": FileAccess.get_sha256(ProjectSettings.globalize_path("res://resources/prototypes/vertical_slice/labrador_r48_05a_station_anchors_v1.json")),
        "source_package_hashes_sha256": FileAccess.get_sha256(ProjectSettings.globalize_path("res://../docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Playable_World_Labrador_Source_Package_v1/HASHES.sha256")),
        "selector_counts": selector_counts,
        "capture_files": _capture_files,
        "selector_snapshot_count": _capture_records.size(),
        "subject_height_readback": _subject_height_readback,
        "identity_bbox_readbacks": _identity_bbox_readbacks,
        "contact_readbacks": _contact_readbacks,
        "packing_front_span_mask": {
            "property_owner": "LabradorVisualAdapter derives active state; VerticalSliceDemo parent draw slot owns local source segmentation",
            "runtime_authority": "godot_state_read_only",
            "positive_selectors": ["D", "F", "G", "EXIT_contact_held"],
            "positive_cell_count": mask_positive_count,
            "negative_cell_count": mask_negative_count,
            "allowed_paw_tip_source_px": PERMITTED_PAW_TIP_SOURCE_PX,
            "allowed_paw_tip_native_screen_px": PERMITTED_PAW_TIP_NATIVE_PX,
            "forbidden_screen_px": 0,
            "forbidden_source_alpha_px": 0,
            "global_z_reorder": false,
            "source_mutation": false,
            "readbacks": _mask_audit_readbacks,
        },
        "hard_gate_readback": {
            "complete_bbox_height_margin_gate": bbox_gate,
            "bbox_failures": bbox_gate_failures,
            "muzzle_working_paw_contact_gate": contact_gate,
            "contact_failures": contact_gate_failures,
            "foreground_only_lower_paw_tip_gate": foreground_gate,
            "foreground_failures": foreground_gate_failures,
            "selector_scoped_mask_gate": mask_gate,
            "mask_failures": mask_gate_failures,
        },
        "motion_strips": _motion_metrics,
        "motion_strip_count": _motion_metrics.size(),
        "turn_records": _turn_records,
        "actual_player_window": _actual_player_window_readback,
        "desktop_composited_capture_status": _desktop_capture_status,
        "desktop_full_display_is_placement_proof": true,
        "desktop_exact_window_crop_is_full_display_proof": false,
        "proportional_context_status": _proportional_context_status,
        "synthetic_side_capture_status": "READ_ONLY_PRESENTATION_FIXTURES__NO_GAMEPLAY_MUTATION",
        "cancellation_recovery_capture_status": "READ_ONLY_PRESENTATION_FIXTURES__NO_GAMEPLAY_MUTATION",
        "silhouette_status": "NATIVE_PLAYER_LAYOUT__AUTHORING_LAYERS_BLACK_MODULATE__NO_GAMEPLAY_MUTATION",
        "preview_status": "DECLARED_FULL_PLAYER_LAYOUT_RESAMPLE_WITH_EXACT_CLEAN_VS_SILHOUETTE_HEIGHT_READBACK",
        "mechanical_validation": "SEPARATE",
        "runtime_art_approval": "PENDING_OWNER_REVIEW",
        "runtime_art_pass_self_approved": false,
        "transfer_acceptance_cells": 0,
    }
    var file := FileAccess.open(_capture_root.path_join("capture_manifest.json"), FileAccess.WRITE)
    if file == null:
        _failures.append("capture manifest target unavailable")
        return
    file.store_string(JSON.stringify(manifest, "  "))


func _test_exact_selectors_and_presentation() -> void:
    var adapter := AdapterScene.instantiate()
    add_child(adapter)
    await get_tree().process_frame

    var idle := _base_snapshot()
    var state: Dictionary = adapter.call("observe_runtime", idle, 0.05) as Dictionary
    _expect(str(state.get("selector", "")) == "A", "A maps exact idle")
    _expect(str(state.get("lane", "")) == "authored", "A uses authored lane")
    _expect(is_equal_approx(float(state.get("source_px_to_world_unit", 0.0)), 0.24), "Labrador uses Art-owner accepted uniform source scale 0.24")

    var quiet := idle.duplicate(true)
    quiet["active_order"] = {}
    quiet["active_chain"] = {}
    quiet["day2_history"] = {"completed": true}
    state = adapter.call("observe_runtime", quiet, 0.05) as Dictionary
    _expect(str(state.get("selector", "")) == "A" and bool(state.get("quiet_variant", false)), "Quiet Cooperative is A-only")

    var wait := idle.duplicate(true)
    wait["active_order"] = {"id":"order.first_warm_delivery", "delivery_state":"ready_to_send", "delivery_confirmed":false, "van_world_x":1450.0}
    state = adapter.call("observe_runtime", wait, 0.05) as Dictionary
    _expect(str(state.get("selector", "")) == "B", "B maps exact calm wait")

    adapter.call("reset_visual_epoch", "right_direction_test")
    adapter.call("observe_runtime", idle, 0.0)
    var cook_right := _station_snapshot("task.cook.right", "CookTask", "object.kitchen", 0, "moving_to_source", "walking", "", 0.05, 400.0, 760.0, "order.first_warm_delivery")
    state = adapter.call("observe_runtime", cook_right, 0.05) as Dictionary
    _expect(str(state.get("selector", "")) == "C" and str(state.get("subphase", "")) == "start", "C starts without turn")
    cook_right["phase"]["elapsed_seconds"] = 0.50 * 0.324
    cook_right["actor"]["world_x"] = lerpf(400.0, 760.0, 0.50)
    state = adapter.call("observe_runtime", cook_right, 0.05) as Dictionary
    _expect(str(state.get("subphase", "")) == "walk", "C enters walk")
    cook_right["phase"]["elapsed_seconds"] = 0.90 * 0.324
    cook_right["actor"]["world_x"] = lerpf(400.0, 760.0, 0.90)
    state = adapter.call("observe_runtime", cook_right, 0.05) as Dictionary
    _expect(str(state.get("subphase", "")) == "stop", "C enters stop/contact approach")
    _expect(float(state.get("station_offset_x", 0.0)) < 0.0, "Kitchen from-left uses negative approach offset")

    adapter.call("reset_visual_epoch", "left_direction_test")
    adapter.call("observe_runtime", idle, 0.0)
    var cook_left := _station_snapshot("task.cook.left", "CookTask", "object.kitchen", 0, "moving_to_source", "walking", "", 0.02, 1000.0, 760.0, "order.first_warm_delivery")
    state = adapter.call("observe_runtime", cook_left, 0.05) as Dictionary
    _expect(str(state.get("subphase", "")) == "turn" and str(state.get("facing_source", "")) == "right", "physical turn begins on previous side")
    var turn_locked_offset := float(state.get("station_offset_x", 0.0))
    cook_left["phase"]["elapsed_seconds"] = 0.18 * 0.324
    state = adapter.call("observe_runtime", cook_left, 0.05) as Dictionary
    _expect(str(state.get("facing_source", "")) == "turn_mid", "physical turn uses turn_mid")
    _expect(is_equal_approx(float(state.get("station_offset_x", 1.0)), turn_locked_offset), "right-to-left turn keeps presentation root locked")
    cook_left["phase"]["elapsed_seconds"] = 0.45 * 0.324
    state = adapter.call("observe_runtime", cook_left, 0.05) as Dictionary
    _expect(str(state.get("facing_source", "")) == "left" and str(state.get("last_rendered_facing", "")) == "left", "physical turn completes on requested side")
    _expect(bool(state.get("uniform_positive_scale", false)), "all facing sets keep positive uniform scale")

    var reverse := _station_snapshot("task.cook.reverse", "CookTask", "object.kitchen", 0, "moving_to_source", "walking", "", 0.02, 400.0, 760.0, "order.first_warm_delivery")
    state = adapter.call("observe_runtime", reverse, 0.05) as Dictionary
    _expect(str(state.get("facing_source", "")) == "left", "left-to-right turn begins on authored left side")
    var reverse_locked_offset := float(state.get("station_offset_x", 0.0))
    reverse["phase"]["elapsed_seconds"] = 0.18 * 0.324
    state = adapter.call("observe_runtime", reverse, 0.05) as Dictionary
    _expect(str(state.get("facing_source", "")) == "turn_mid" and is_equal_approx(float(state.get("station_offset_x", 1.0)), reverse_locked_offset), "left-to-right turn uses root-locked turn_mid")
    reverse["phase"]["elapsed_seconds"] = 0.45 * 0.324
    state = adapter.call("observe_runtime", reverse, 0.05) as Dictionary
    _expect(str(state.get("facing_source", "")) == "right" and str(state.get("last_rendered_facing", "")) == "right", "left-to-right turn completes on authored right side")

    cook_left["phase"]["elapsed_seconds"] = 0.99 * 0.324
    adapter.call("observe_runtime", cook_left, 0.05)
    var cook_work := _station_snapshot("task.cook.left", "CookTask", "object.kitchen", 1, "in_progress", "helping_kitchen", "start_cooking", 0.0, 1000.0, 760.0, "order.first_warm_delivery")
    state = adapter.call("observe_runtime", cook_work, 0.05) as Dictionary
    _expect(str(state.get("selector", "")) == "D", "D maps exact phase-0 to phase-1 transition")
    _expect(not bool(state.get("packing_front_span_mask_active", true)), "Kitchen D keeps authored foreground ownership")
    _expect(float(state.get("station_offset_x", 0.0)) > 0.0, "Kitchen from-right contact uses positive offset")
    cook_work["phase"]["elapsed_seconds"] = 0.30 * 0.8496
    state = adapter.call("observe_runtime", cook_work, 0.05) as Dictionary
    _expect(str(state.get("selector", "")) == "E", "E maps exact Kitchen work")
    _expect(not bool(state.get("packing_front_span_mask_active", true)), "Kitchen E keeps authored foreground ownership")
    _expect(is_equal_approx(float(state.get("station_offset_x", 0.0)), 54.24), "Kitchen right-side work offset starts source-derived +54.24")
    var kitchen_pose: Vector4 = state.get("base_pose", Vector4.ZERO)

    adapter.call("reset_visual_epoch", "packing_test")
    var pack := _station_snapshot("task.pack.first", "PackTask", "object.packing_table", 1, "in_progress", "packing", "start_packing", 0.30, 760.0, 1090.0, "order.first_warm_delivery")
    state = adapter.call("observe_runtime", pack, 0.05) as Dictionary
    _expect(str(state.get("selector", "")) == "F", "F maps ordinary Packing work")
    _expect(bool(state.get("packing_front_span_mask_active", false)), "Packing F derives contact-local front-span mask")
    _expect(is_equal_approx(float(state.get("station_offset_x", 0.0)), -50.88), "Packing left-side work offset starts source-derived -50.88")
    var packing_pose: Vector4 = state.get("base_pose", Vector4.ZERO)
    _expect(not kitchen_pose.is_equal_approx(packing_pose), "Kitchen E and Packing F have visibly distinct base poses")

    adapter.call("reset_visual_epoch", "care_test")
    var care := _station_snapshot("task.pack.day2", "PackTask", "object.packing_table", 1, "in_progress", "packing", "start_packing", 0.30, 1450.0, 1090.0, "order.second_warm_delivery_careful_pack")
    care["recent_events"] = [{"type":"labrador_packing_care_moment", "payload":{"order_id":"order.second_warm_delivery_careful_pack", "task_id":"task.pack.day2"}}]
    state = adapter.call("observe_runtime", care, 0.05) as Dictionary
    _expect(str(state.get("selector", "")) == "G" and bool(state.get("focus_enabled", false)), "G requires exact Day-2 task/order/event")
    _expect(bool(state.get("packing_front_span_mask_active", false)), "Packing G derives contact-local front-span mask")
    _expect(is_equal_approx(float(state.get("station_offset_x", 0.0)), 50.88), "Packing right-side work offset starts source-derived +50.88")
    _expect(not (state.get("focus_pose", Vector2.ZERO) as Vector2).is_zero_approx(), "Day-2 G adds a readable focus pose over F")

    adapter.call("reset_visual_epoch", "motion_distribution_test")
    adapter.call("observe_runtime", idle, 0.0)
    var roots: Array[float] = []
    var distributed_subphases: Dictionary = {}
    for index in 7:
        var progress := float(index) / 6.0
        var distributed := _station_snapshot("task.cook.distributed", "CookTask", "object.kitchen", 0, "moving_to_source", "walking", "", progress, 760.0, 760.0, "order.first_warm_delivery")
        state = adapter.call("observe_runtime", distributed, 0.05) as Dictionary
        roots.append(760.0 + float(state.get("station_offset_x", 0.0)))
        distributed_subphases[str(state.get("subphase", ""))] = true
    var full_path := absf(roots[-1] - roots[0])
    var max_interval := 0.0
    var visible_intervals := 0
    for index in range(1, roots.size()):
        var interval := absf(roots[index] - roots[index - 1])
        max_interval = maxf(max_interval, interval)
        if interval > 0.01:
            visible_intervals += 1
    _expect(is_equal_approx(full_path, 41.28), "C root follows exact 104.16-to-62.88 source anchor path")
    _expect(visible_intervals >= 5 and max_interval / full_path <= 0.35, "C root/weight motion spans at least five samples with max interval <=35%")
    for subphase in ["start", "walk", "stop"]:
        _expect(distributed_subphases.has(subphase), "distributed motion retains readable %s" % subphase)

    adapter.call("reset_visual_epoch", "negative_care_test")
    var negative := care.duplicate(true)
    negative["recent_events"] = [{"type":"labrador_packing_care_moment", "payload":{"order_id":"order.second_warm_delivery_careful_pack", "task_id":"task.other"}}]
    state = adapter.call("observe_runtime", negative, 0.05) as Dictionary
    _expect(str(state.get("selector", "")) == "F" and not bool(state.get("focus_enabled", true)), "negative G mismatch stays F")

    for task_type in ["UnloadTask", "CarryTask", "LoadVanTask"]:
        adapter.call("reset_visual_epoch", "legacy_%s" % task_type)
        var legacy := _legacy_snapshot(task_type)
        state = adapter.call("observe_runtime", legacy, 0.05) as Dictionary
        _expect(str(state.get("lane", "")) == "legacy_unbound" and str(state.get("reason", "")) == task_type, "%s remains legacy_unbound" % task_type)
        _expect(not bool(state.get("packing_front_span_mask_active", true)), "%s cannot activate Packing mask" % task_type)

    var unsupported := _station_snapshot("task.unsupported", "ResearchTask", "object.kitchen", 0, "moving_to_source", "walking", "", 0.1, 400.0, 760.0, "order.first_warm_delivery")
    state = adapter.call("observe_runtime", unsupported, 0.05) as Dictionary
    _expect(str(state.get("lane", "")) == "suppressed", "selector outside A-G fails closed")
    _expect(not bool(state.get("packing_front_span_mask_active", true)), "selector outside A-G cannot activate Packing mask")
    _expect(int(state.get("gameplay_output_count", -1)) == 0 and not bool(state.get("transfer_semantics", true)), "adapter produces no gameplay/transfer output")

    adapter.call("reset_visual_epoch", "cancellation_recovery_test")
    adapter.call("observe_runtime", cook_right, 0.05)
    var stale := cook_right.duplicate(true)
    stale["actor"]["current_task"] = "task.other"
    state = adapter.call("observe_runtime", stale, 0.05) as Dictionary
    _expect(str(state.get("lane", "")) == "suppressed" and str(state.get("reason", "")) == "stale_task_or_assignee", "task mismatch immediately suppresses stale authored pose")
    state = adapter.call("observe_runtime", idle, 0.05) as Dictionary
    _expect(str(state.get("selector", "")) == "A" and is_zero_approx(float(state.get("station_offset_x", 1.0))), "cancel before contact recovers to clean A")

    adapter.call("reset_visual_epoch", "save_failure_recovery_test")
    adapter.call("observe_runtime", care, 0.05)
    var failed := care.duplicate(true)
    failed["journey"]["barrier_failed"] = true
    state = adapter.call("observe_runtime", failed, 0.05) as Dictionary
    _expect(str(state.get("lane", "")) == "suppressed" and str(state.get("reason", "")) == "save_barrier_failed" and not bool(state.get("focus_enabled", true)), "save failure suppresses authored pose and stale focus")
    var retry := care.duplicate(true)
    retry["recent_events"] = []
    retry["journey"]["checkpoint_sequence"] = 26
    state = adapter.call("observe_runtime", retry, 0.05) as Dictionary
    _expect(str(state.get("selector", "")) == "F" and not bool(state.get("focus_enabled", true)) and (state.get("focus_pose", Vector2.ONE) as Vector2).is_zero_approx(), "rollback/retry rebuilds F without stale G focus")

    adapter.queue_free()
    await get_tree().process_frame


func _test_player_boot_owned_first_day_and_day2() -> void:
    _remove_tree(ProjectSettings.globalize_path(TEST_PROFILE))
    var first_boot := PlayerBootScene.instantiate()
    var configured: Dictionary = first_boot.call("configure_player_boot", {"profile_base_dir":TEST_PROFILE, "test_mode":true}) as Dictionary
    _expect(bool(configured.get("ok", false)), "First Day PlayerBoot test profile configures")
    add_child(first_boot)
    await get_tree().process_frame
    var first_lifecycle := first_boot.call("lifecycle_snapshot") as Dictionary
    _expect(int(first_lifecycle.get("runtime_child_count", 0)) == 1, "First Day has exactly one PlayerBoot-owned runtime")
    var first_runtime: Control = first_boot.call("player_runtime") as Control
    _expect(first_runtime != null and first_runtime.get_parent() == first_boot, "First Day runtime parent is PlayerBoot")
    first_runtime.set_process(false)
    DisplayServer.window_set_size(Vector2i(1120, 224))
    await get_tree().process_frame
    var layout := first_runtime.call("test_labrador_visual_snapshot") as Dictionary
    var viewport_size: Vector2 = layout.get("viewport_size", Vector2.ZERO)
    var corridor := layout.get("corridor_framing", {}) as Dictionary
    _expect(is_zero_approx(float(corridor.get("screen_min_x", -1.0))), "player framing maps corridor x=0 to the left edge")
    _expect(is_equal_approx(float(corridor.get("screen_max_x", 0.0)), viewport_size.x), "player framing maps corridor x=1740 to the full right edge")
    _expect(float(corridor.get("authored_screen_max_x", 0.0)) < viewport_size.x and not bool(corridor.get("authored_tail_claim", true)), "authored x=0..1536 and honest non-authored tail remain distinct")
    var scale_readback := layout.get("labrador_scale_readback", {}) as Dictionary
    _expect(is_equal_approx(float(scale_readback.get("source_to_world", 0.0)), 0.24) and bool(scale_readback.get("uniform_positive_scale", false)), "player Labrador scale is uniform positive 0.24")
    var player_subject_height := 225.0 * 0.24 * 2992.0 / 1740.0
    for target in [{"height":216.0,"minimum":80.0}, {"height":144.0,"minimum":52.0}, {"height":96.0,"minimum":35.0}]:
        var projected_height := player_subject_height * float(target["height"]) / 224.0
        _expect(projected_height >= float(target["minimum"]), "projected Labrador height at %d clears %.0f px" % [int(target["height"]), float(target["minimum"])])

    var first_selectors: Dictionary = {}
    var first_legacy: Dictionary = {}
    var first_subphases: Dictionary = {}
    var saw_324 := false
    for _sequence in range(1, 17):
        var advance: Dictionary = first_runtime.call("test_labrador_advance_to_next_checkpoint_visual_trace", 5000) as Dictionary
        _expect(bool(advance.get("ok", false)), "First Day visual trace advances: %s" % str(advance.get("error", "")))
        for sample in advance.get("samples", []) as Array:
            var render := (sample as Dictionary).get("render", {}) as Dictionary
            var observation := (sample as Dictionary).get("observation", {}) as Dictionary
            var selector := str(render.get("selector", ""))
            if selector != "":
                first_selectors[selector] = true
            if str(render.get("lane", "")) == "legacy_unbound":
                first_legacy[str(render.get("reason", ""))] = true
            if selector == "C":
                first_subphases[str(render.get("subphase", ""))] = true
                var duration := float((observation.get("phase", {}) as Dictionary).get("duration_seconds", 0.0))
                if is_equal_approx(duration, 0.324):
                    saw_324 = true
    for selector in ["A", "B", "C", "D", "E", "F"]:
        _expect(first_selectors.has(selector), "ordinary First Day reaches selector %s" % selector)
    _expect(not first_selectors.has("G"), "ordinary First Day never reaches G")
    for task_type in ["UnloadTask", "CarryTask", "LoadVanTask"]:
        _expect(first_legacy.has(task_type), "ordinary First Day preserves %s legacy_unbound" % task_type)
    for subphase in ["start", "walk", "stop"]:
        _expect(first_subphases.has(subphase), "normal 0.324-second phrase contains %s" % subphase)
    _expect(saw_324, "ordinary player timing remains exactly 0.324 seconds")

    first_boot.queue_free()
    await get_tree().process_frame

    var day2_boot := PlayerBootScene.instantiate()
    configured = day2_boot.call("configure_player_boot", {"profile_base_dir":TEST_PROFILE, "test_mode":true}) as Dictionary
    _expect(bool(configured.get("ok", false)), "Day 2 PlayerBoot test profile configures")
    add_child(day2_boot)
    await get_tree().process_frame
    var lifecycle := day2_boot.call("lifecycle_snapshot") as Dictionary
    _expect(str(lifecycle.get("action", "")) == "begin_day2_return", "PlayerBoot offers bounded Day 2 return")
    _expect(bool((day2_boot.call("activate_lifecycle_action") as Dictionary).get("ok", false)), "PlayerBoot activates Day 2 return")
    await get_tree().process_frame
    _expect(int((day2_boot.call("lifecycle_snapshot") as Dictionary).get("runtime_child_count", 0)) == 1, "Day 2 has exactly one PlayerBoot-owned runtime")
    var day2_runtime: Control = day2_boot.call("player_runtime") as Control
    day2_runtime.set_process(false)
    var day2_selectors: Dictionary = {}
    for _sequence in range(18, 33):
        var advance: Dictionary = day2_runtime.call("test_labrador_advance_to_next_checkpoint_visual_trace", 5000) as Dictionary
        _expect(bool(advance.get("ok", false)), "Day 2 visual trace advances: %s" % str(advance.get("error", "")))
        for sample in advance.get("samples", []) as Array:
            var render := (sample as Dictionary).get("render", {}) as Dictionary
            var selector := str(render.get("selector", ""))
            if selector != "":
                day2_selectors[selector] = true
            var base_selector := str(render.get("base_selector", ""))
            if base_selector != "":
                day2_selectors[base_selector] = true
    for selector in ["A", "B", "C", "D", "E", "F", "G"]:
        _expect(day2_selectors.has(selector), "ordinary Day 2 reaches selector %s" % selector)
    var quiet := day2_runtime.call("test_labrador_visual_snapshot") as Dictionary
    var quiet_render := quiet.get("render", {}) as Dictionary
    _expect(str(quiet_render.get("selector", "")) == "A" and bool(quiet_render.get("quiet_variant", false)), "cursor 33 is restart-stable A-only Quiet Cooperative")
    _expect(int(quiet.get("runtime_count", 0)) == 1 and int(quiet.get("labrador_count", 0)) == 1, "one runtime and one Labrador remain")

    day2_boot.queue_free()
    await get_tree().process_frame


func _base_snapshot() -> Dictionary:
    return {
        "actor": {"id":"dog.labrador_intro", "visible":true, "current_task":"", "current_visible_state":"idle", "world_x":360.0, "move_start_x":360.0, "move_target_x":360.0},
        "task": {},
        "phase": {},
        "active_order": {"id":"order.first_warm_delivery", "delivery_state":"waiting_for_food_bag", "delivery_confirmed":false, "van_world_x":1450.0},
        "active_chain": {"run_id":"run.first_day.first_warm_delivery"},
        "journey": {"phase":"first_day", "checkpoint_sequence":1, "barrier_failed":false},
        "first_day_history": {},
        "day2_history": {"completed":false},
        "recent_events": [],
    }


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
    snapshot["journey"]["checkpoint_sequence"] = 25 if order_id == "order.second_warm_delivery_careful_pack" else 8
    return snapshot


func _legacy_snapshot(task_type: String) -> Dictionary:
    var snapshot := _base_snapshot()
    snapshot["actor"]["current_task"] = "task.legacy"
    snapshot["actor"]["current_visible_state"] = "carrying_item"
    snapshot["task"] = {"id":"task.legacy", "type":task_type, "status":"in_progress", "order_id":"order.first_warm_delivery", "assigned_dog_id":"dog.labrador_intro", "source_object_id":"object.storage", "target_object_id":"object.kitchen"}
    snapshot["phase"] = {"index":1, "status":"in_progress", "dog_state":"carrying_item", "elapsed_seconds":0.1, "duration_seconds":0.2}
    return snapshot


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
