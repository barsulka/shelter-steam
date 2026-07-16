extends Node

const DemoScene := preload("res://scenes/prototypes/vertical_slice/vertical_slice_demo.tscn")
const EPSILON := 0.001

var _failures: Array[String] = []


func _ready() -> void:
    _run.call_deferred()


func _run() -> void:
    var mechanical_dir := _mechanical_output_arg()
    if mechanical_dir != "":
        await _run_mechanical_evidence(mechanical_dir)
        if _failures.is_empty():
            print("d024_mechanical_evidence=passed")
            get_tree().quit(0)
        else:
            for failure in _failures:
                push_error(failure)
            get_tree().quit(1)
        return

    var capture_dir := _capture_output_arg()
    if capture_dir != "":
        await _run_capture(capture_dir)
        if _failures.is_empty():
            print("d024_responsive_presentation_capture=passed")
            get_tree().quit(0)
        else:
            for failure in _failures:
                push_error(failure)
            get_tree().quit(1)
        return

    var demo := DemoScene.instantiate()
    add_child(demo)
    await get_tree().process_frame
    await get_tree().process_frame

    _test_static_runtime_contract(demo)
    _test_responsive_math(demo)
    _test_ordinary_player_cleanup_and_hide_show(demo)
    _test_pan_threshold_exterior_and_zero_output(demo)
    _test_passthrough_and_dev_observability(demo)

    demo.queue_free()
    await get_tree().process_frame
    if _failures.is_empty():
        print("d024_responsive_presentation_test=passed viewports=2992,3456,3840 corpus=43+43")
        get_tree().quit(0)
        return
    for failure in _failures:
        push_error(failure)
    print("d024_responsive_presentation_test=failed count=%d" % _failures.size())
    get_tree().quit(1)


func _capture_output_arg() -> String:
    for arg in OS.get_cmdline_user_args():
        if arg.begins_with("--d024-capture-dir="):
            return arg.replace("--d024-capture-dir=", "").strip_edges()
    return ""


func _mechanical_output_arg() -> String:
    for arg in OS.get_cmdline_user_args():
        if arg.begins_with("--d024-mechanical-evidence-dir="):
            return arg.replace("--d024-mechanical-evidence-dir=", "").strip_edges()
    return ""


func _run_mechanical_evidence(output_dir: String) -> void:
    var absolute_root := ProjectSettings.globalize_path(output_dir)
    var error := DirAccess.make_dir_recursive_absolute(absolute_root)
    _expect(error == OK, "mechanical evidence directory creation succeeds")
    var demo := DemoScene.instantiate()
    add_child(demo)
    await get_tree().process_frame
    await get_tree().process_frame

    var responsive: Array[Dictionary] = []
    for width in [2992.0, 3456.0, 3840.0]:
        var default_snapshot := demo.call("test_d024_contract_for_viewport", Vector2(width, 224.0), false, false) as Dictionary
        default_snapshot["framing"] = "default"
        responsive.append(default_snapshot)
        var right_snapshot := demo.call("test_d024_contract_for_viewport", Vector2(width, 224.0), true, true) as Dictionary
        right_snapshot["framing"] = "right_end"
        responsive.append(right_snapshot)

    var presentation: Array[Dictionary] = []
    var ordinary_visible := demo.call("test_d024_set_player_framing", false, false) as Dictionary
    ordinary_visible["state"] = "ordinary_ui_visible"
    presentation.append(ordinary_visible)
    var ordinary_hidden := demo.call("test_d024_toggle_ui_hidden") as Dictionary
    ordinary_hidden["state"] = "ordinary_ui_hidden"
    presentation.append(ordinary_hidden)
    var ordinary_restored := demo.call("test_d024_toggle_ui_hidden") as Dictionary
    ordinary_restored["state"] = "ordinary_ui_restored"
    presentation.append(ordinary_restored)
    demo.call("_apply_view_mode", "qa")
    var dev := demo.call("test_d024_presentation_snapshot") as Dictionary
    dev["state"] = "explicit_dev_diagnostics"
    presentation.append(dev)

    _write_json_file(absolute_root.path_join("responsive_contract_snapshots.json"), responsive)
    _write_json_file(absolute_root.path_join("presentation_mode_snapshots.json"), presentation)
    demo.queue_free()
    await get_tree().process_frame


func _write_json_file(path: String, payload: Variant) -> void:
    var file := FileAccess.open(path, FileAccess.WRITE)
    _expect(file != null, "mechanical evidence file opens: %s" % path)
    if file != null:
        file.store_string(JSON.stringify(payload, "  ") + "\n")


func _run_capture(capture_dir: String) -> void:
    var absolute_root := ProjectSettings.globalize_path(capture_dir)
    for relative in ["captures/responsive", "captures/presentation", "captures/native_readability", "snapshots"]:
        var error := DirAccess.make_dir_recursive_absolute(absolute_root.path_join(relative))
        _expect(error == OK, "capture directory creation succeeds: %s" % relative)

    var snapshots: Array[Dictionary] = []
    for width in [2992, 3456, 3840]:
        for framing in ["default", "right_end"]:
            var record := await _capture_runtime_frame(
                Vector2i(width, 224),
                true,
                framing == "right_end",
                false,
                false,
                absolute_root.path_join("captures/responsive/viewport_%dx224__%s__rgba.png" % [width, framing]),
                false,
                true
            )
            record["capture_id"] = "responsive_%d_%s" % [width, framing]
            snapshots.append(record)

    snapshots.append(await _capture_runtime_frame(
        Vector2i(2992, 224), false, false, false, false,
        absolute_root.path_join("captures/presentation/ordinary_ui_visible.png")
    ))
    snapshots.append(await _capture_runtime_frame(
        Vector2i(2992, 224), false, false, true, false,
        absolute_root.path_join("captures/presentation/ordinary_ui_hidden.png")
    ))
    snapshots.append(await _capture_runtime_frame(
        Vector2i(1280, 360), false, false, false, true,
        absolute_root.path_join("captures/presentation/dev_mode_diagnostics.png")
    ))

    for height in [216, 144, 96]:
        snapshots.append(await _capture_runtime_frame(
            Vector2i(1120, height), false, false, true, false,
            absolute_root.path_join("captures/native_readability/clean_%d.png" % height)
        ))
        snapshots.append(await _capture_runtime_frame(
            Vector2i(1120, height), false, false, true, false,
            absolute_root.path_join("captures/native_readability/silhouette_%d.png" % height),
            true
        ))

    var snapshot_file := FileAccess.open(absolute_root.path_join("snapshots/responsive_runtime_snapshots.json"), FileAccess.WRITE)
    _expect(snapshot_file != null, "responsive snapshot ledger opens")
    if snapshot_file != null:
        snapshot_file.store_string(JSON.stringify(snapshots, "  ") + "\n")


func _capture_runtime_frame(
        viewport_size: Vector2i,
        use_zoom_max: bool,
        camera_at_right: bool,
        ui_hidden: bool,
        dev_mode: bool,
        output_path: String,
        silhouette: bool = false,
        diagnostics: bool = false
) -> Dictionary:
    var viewport := SubViewport.new()
    viewport.size = viewport_size
    viewport.transparent_bg = true
    viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
    add_child(viewport)
    var demo := DemoScene.instantiate()
    viewport.add_child(demo)
    await get_tree().process_frame
    await get_tree().process_frame
    if dev_mode:
        demo.call("_apply_view_mode", "qa")
    else:
        demo.call("test_d024_set_player_framing", use_zoom_max, camera_at_right)
        if ui_hidden:
            demo.call("test_d024_toggle_ui_hidden")
    if silhouette:
        demo.call("test_labrador_set_capture_silhouette", true)
    await get_tree().process_frame
    await get_tree().process_frame
    var image := viewport.get_texture().get_image()
    if image == null:
        _expect(false, "capture framebuffer is unavailable: %s" % output_path)
        var blocked_snapshot := demo.call("test_d024_presentation_snapshot") as Dictionary
        blocked_snapshot["capture_path"] = output_path
        blocked_snapshot["capture_size"] = viewport_size
        blocked_snapshot["capture_status"] = "FRAMEBUFFER_UNAVAILABLE"
        demo.queue_free()
        viewport.queue_free()
        await get_tree().process_frame
        return blocked_snapshot
    var save_error := image.save_png(output_path)
    _expect(save_error == OK, "capture writes %s" % output_path)
    if diagnostics:
        _save_alpha_diagnostic(image, output_path.replace("__rgba.png", "__black.png"), false)
        _save_alpha_diagnostic(image, output_path.replace("__rgba.png", "__checker.png"), true)
    var snapshot := demo.call("test_d024_presentation_snapshot") as Dictionary
    snapshot["capture_path"] = output_path
    snapshot["capture_size"] = viewport_size
    snapshot["dev_mode"] = dev_mode
    snapshot["silhouette"] = silhouette
    demo.queue_free()
    viewport.queue_free()
    await get_tree().process_frame
    return snapshot


func _save_alpha_diagnostic(source: Image, output_path: String, checker: bool) -> void:
    var background := Image.create(source.get_width(), source.get_height(), false, Image.FORMAT_RGBA8)
    background.fill(Color(0.0, 0.0, 0.0, 1.0))
    if checker:
        var tile_size := 16
        for y in range(0, source.get_height(), tile_size):
            for x in range(0, source.get_width(), tile_size):
                if (int(x / tile_size) + int(y / tile_size)) % 2 == 0:
                    background.fill_rect(
                        Rect2i(x, y, mini(tile_size, source.get_width() - x), mini(tile_size, source.get_height() - y)),
                        Color(0.38, 0.38, 0.38, 1.0)
                    )
    background.blend_rect(source, Rect2i(Vector2i.ZERO, source.get_size()), Vector2i.ZERO)
    var error := background.save_png(output_path)
    _expect(error == OK, "alpha diagnostic writes %s" % output_path)


func _test_static_runtime_contract(demo: Node) -> void:
    var snapshot := demo.call("test_d024_presentation_snapshot") as Dictionary
    _expect(bool(snapshot.get("ready", false)), "D-024 config and both textures load")
    _expect(str(snapshot.get("config_schema", "")) == "shelter.d024-responsive-presentation.v1", "D-024 config schema is exact")
    _expect(_near(float(snapshot.get("world_width", 0.0)), 1740.0), "runtime world width remains 1740")
    _expect(_near(float(snapshot.get("source_world_width", 0.0)), 2992.0), "source world width remains 2992")
    _expect(_near(float(snapshot.get("source_world_to_runtime", 0.0)), 1740.0 / 2992.0), "one-shot source transform remains 1740/2992")
    _expect(int(snapshot.get("meadow_load_count", 0)) == 1, "meadow texture loads exactly once")
    _expect(int(snapshot.get("marker_load_count", 0)) == 1, "marker texture loads exactly once")
    _expect(int(snapshot.get("marker_draw_count", 0)) == 1, "marker has one draw slot")
    _expect(not bool(snapshot.get("marker_interactive", true)), "marker is non-interactive")


func _test_responsive_math(demo: Node) -> void:
    for width in [2992.0, 3456.0, 3840.0]:
        var default_state := demo.call("test_d024_contract_for_viewport", Vector2(width, 224.0), false, false) as Dictionary
        _expect(_near(float(default_state.get("camera_x", -1.0)), 0.0), "%d default camera starts at zero" % int(width))
        _expect(_near(float(default_state.get("reserve_fraction", 0.0)), 0.15), "%d default reserve is exactly 15 percent" % int(width))
        _expect(int((default_state.get("tile_range", []) as Array).size()) == 2, "%d has explicit visible X tile range" % int(width))

        var right_state := demo.call("test_d024_contract_for_viewport", Vector2(width, 224.0), true, true) as Dictionary
        _expect(float(right_state.get("zoom", 0.0)) >= float(right_state.get("zoom_min", 0.0)), "%d zoom never falls below z_min" % int(width))
        _expect(_near(float(right_state.get("reserve_fraction", 0.0)), 0.15), "%d right clamp keeps 15 percent reserve" % int(width))
        var marker := right_state.get("marker", {}) as Dictionary
        _expect(float(marker.get("positive_uniform_scale", 0.0)) > 0.0, "%d marker scale is positive" % int(width))
        _expect(float(marker.get("opaque_body_screen_min_x", 0.0)) > float(right_state.get("field_boundary_screen_x", 0.0)), "%d marker opaque body is exterior" % int(width))

    var width_2992 := demo.call("test_d024_contract_for_viewport", Vector2(2992.0, 224.0), true, true) as Dictionary
    var width_3456 := demo.call("test_d024_contract_for_viewport", Vector2(3456.0, 224.0), true, true) as Dictionary
    _expect(_near(float(width_2992.get("camera_max", 0.0)), 82.8571428571, 0.01), "2992 right camera max is 82.8571")
    _expect(_near(float(width_3456.get("camera_max", 0.0)), 82.8571428571, 0.01), "3456 right camera max is 82.8571")

    var width_3840_default := demo.call("test_d024_contract_for_viewport", Vector2(3840.0, 224.0), false, false) as Dictionary
    var default_y := width_3840_default.get("material_y", []) as Array
    _expect(_near(float(width_3840_default.get("zoom_fit_max", 0.0)), 1.888122605364, 0.00001), "3840 z_fit cap is exact")
    _expect(_near(float(default_y[0]), 0.0, 0.01) and _near(float(default_y[1]), 222.545, 0.02), "3840 default material rows fit y=[0,222.545]")
    var width_3840_right := demo.call("test_d024_contract_for_viewport", Vector2(3840.0, 224.0), true, true) as Dictionary
    var right_y := width_3840_right.get("material_y", []) as Array
    _expect(_near(float(width_3840_right.get("zoom", 0.0)), 1.888122605364, 0.00001), "3840 runtime zoom is capped by vertical fit")
    _expect(_near(float(width_3840_right.get("camera_max", 0.0)), 11.2987, 0.01), "3840 right camera max is 11.2987")
    _expect(_near(float(right_y[0]), 0.0, 0.01) and _near(float(right_y[1]), 224.0, 0.01), "3840 capped material rows fit y=[0,224]")


func _test_ordinary_player_cleanup_and_hide_show(demo: Node) -> void:
    var snapshot := demo.call("test_d024_set_player_framing", false, false) as Dictionary
    _expect(str(snapshot.get("view_mode", "")) == "player_prototype", "ordinary player mode is explicit")
    _expect(not bool(snapshot.get("visibility_button_visible", true)), "persistent Hide/Show button is absent in ordinary mode")
    _expect(not bool(snapshot.get("debug_card_visible", true)), "debug card is absent in ordinary mode")
    _expect(not bool(snapshot.get("status_label_visible", true)), "status label is absent in ordinary mode")
    _expect(not bool(snapshot.get("performance_label_visible", true)), "performance HUD is absent in ordinary mode")
    _expect(not bool(snapshot.get("semantic_button_visible", true)), "semantic button is absent in ordinary mode")
    _expect(not bool(snapshot.get("semantic_labels", true)), "semantic labels are absent in ordinary mode")
    _expect(bool(snapshot.get("ui_within_field", false)), "ordinary UI remains inside gameplay field")

    var h_event := InputEventKey.new()
    h_event.pressed = true
    h_event.keycode = KEY_H
    demo.call("_unhandled_input", h_event)
    snapshot = demo.call("test_d024_presentation_snapshot") as Dictionary
    _expect(bool(snapshot.get("ui_hidden", false)), "KEY_H hides ordinary UI")
    _expect(not bool(snapshot.get("visibility_button_visible", true)), "hidden ordinary UI still has no Show UI button")
    demo.call("_unhandled_input", h_event)
    snapshot = demo.call("test_d024_presentation_snapshot") as Dictionary
    _expect(not bool(snapshot.get("ui_hidden", true)), "KEY_H restores ordinary UI")


func _test_pan_threshold_exterior_and_zero_output(demo: Node) -> void:
    demo.call("test_d024_set_player_framing", true, false)
    var baseline := float((demo.call("test_d024_presentation_snapshot") as Dictionary).get("baseline", 224.0))
    var start := Vector2(500.0, baseline - 4.0)
    var events_before := (demo.get("_event_log") as Array).size()
    var checkpoint_before := demo.call("player_checkpoint_snapshot") as Dictionary

    var below_threshold := demo.call("test_d024_simulate_pan", start, start + Vector2(-7.9, 0.0)) as Dictionary
    _expect(bool(below_threshold.get("candidate", false)), "in-field ground starts pan candidate when range exists")
    _expect(not bool(below_threshold.get("consumed", true)), "movement below 8 px does not pan")
    _expect(not bool(below_threshold.get("release_consumed", true)), "sub-threshold release is not consumed as pan")
    _expect(_near(float(below_threshold.get("camera_before", 0.0)), float(below_threshold.get("camera_after", -1.0))), "sub-threshold motion leaves camera unchanged")

    var active_drag := demo.call("test_d024_simulate_pan", start, start + Vector2(-12.0, 0.0)) as Dictionary
    _expect(bool(active_drag.get("consumed", false)) and bool(active_drag.get("release_consumed", false)), "8 px threshold produces pan and release-no-click consumption")
    _expect(float(active_drag.get("camera_after", 0.0)) > float(active_drag.get("camera_before", 0.0)), "leftward drag advances camera")

    var snapshot := demo.call("test_d024_presentation_snapshot") as Dictionary
    var exterior_start := Vector2(float(snapshot.get("field_boundary_screen_x", 0.0)) + 2.0, baseline - 4.0)
    var exterior := demo.call("test_d024_simulate_pan", exterior_start, exterior_start + Vector2(-20.0, 0.0)) as Dictionary
    _expect(not bool(exterior.get("candidate", true)), "exterior marker space cannot start pan")
    _expect((demo.get("_event_log") as Array).size() == events_before, "pan emits zero gameplay events")
    var checkpoint_after := demo.call("player_checkpoint_snapshot") as Dictionary
    _expect(int(checkpoint_after.get("checkpoint_sequence", 0)) == int(checkpoint_before.get("checkpoint_sequence", 0)), "pan emits zero checkpoint output")


func _test_passthrough_and_dev_observability(demo: Node) -> void:
    var default_snapshot := demo.call("test_d024_set_player_framing", false, false) as Dictionary
    var default_viewport: Vector2 = default_snapshot.get("viewport_size", Vector2.ZERO)
    _expect(_near(float(default_snapshot.get("camera_max", -1.0)), 0.0), "default framing has no pan range")
    _expect(float(default_snapshot.get("passthrough_max_x", 0.0)) <= float(default_snapshot.get("field_boundary_screen_x", 0.0)) + EPSILON, "controls-only passthrough excludes exterior")
    _expect(float(default_snapshot.get("passthrough_max_y", 0.0)) < default_viewport.y, "no-pan passthrough captures the control envelope, not ground")
    demo.call("test_d024_toggle_ui_hidden")
    var hidden_default := demo.call("test_d024_presentation_snapshot") as Dictionary
    _expect(int(hidden_default.get("passthrough_point_count", -1)) == 0, "no-pan hidden UI passes the whole window through")
    demo.call("test_d024_toggle_ui_hidden")

    var zoomed := demo.call("test_d024_set_player_framing", true, false) as Dictionary
    _expect(float(zoomed.get("camera_max", 0.0)) > 0.0, "zoomed framing exposes bounded pan range")
    _expect(float(zoomed.get("passthrough_max_x", 0.0)) <= float(zoomed.get("field_boundary_screen_x", 0.0)) + EPSILON, "ground passthrough capture ends at field boundary")

    demo.call("_apply_view_mode", "qa")
    var dev_snapshot := demo.call("test_d024_presentation_snapshot") as Dictionary
    _expect(bool(dev_snapshot.get("debug_card_visible", false)), "explicit dev mode retains diagnostic card")
    _expect(bool(dev_snapshot.get("visibility_button_visible", false)), "explicit dev mode retains prototype visibility control")


func _near(actual: float, expected: float, tolerance: float = EPSILON) -> bool:
    return absf(actual - expected) <= tolerance


func _expect(condition: bool, message: String) -> void:
    if not condition:
        _failures.append(message)
