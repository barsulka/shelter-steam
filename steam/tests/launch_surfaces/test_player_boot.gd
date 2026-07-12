extends Node

const PLAYER_BOOT_SCENE := preload("res://scenes/player/player_boot.tscn")

var _failures: Array[String] = []
var _base_dir := "user://player-tests/r48-launch-surface-default"


func _ready() -> void:
    _run.call_deferred()


func _run() -> void:
    _read_args()
    if not _base_dir.begins_with("user://player-tests/"):
        _failures.append("launch test root must stay under user://player-tests")
        _finish()
        return
    _clean_base()
    var boot := PLAYER_BOOT_SCENE.instantiate()
    var boot_configuration: Dictionary = boot.call("configure_player_boot", {
        "profile_base_dir": _base_dir,
        "test_mode": true,
    }) as Dictionary
    _expect(bool(boot_configuration.get("ok", false)), "PlayerBoot must accept isolated pre-tree test profile configuration")
    add_child(boot)
    await get_tree().process_frame
    await get_tree().process_frame

    _expect(boot.get_child_count() == 1, "PlayerBoot must own exactly one gameplay runtime")
    var runtime: Control = boot.call("player_runtime") as Control
    _expect(runtime != null, "PlayerBoot must expose its configured gameplay runtime")

    if runtime != null:
        _expect(runtime.name == "VerticalSliceDemo", "PlayerBoot must instantiate the existing VerticalSliceDemo")
        var snapshot: Dictionary = runtime.call("launch_configuration_snapshot") as Dictionary
        _expect(bool(snapshot.get("player_session_configured", false)), "player session must be configured")
        _expect(bool(snapshot.get("player_session_started", false)), "configured player session must start")
        _expect(str(snapshot.get("startup_intent", "")) == "fresh_session", "startup intent must be fresh_session")
        _expect(not bool(snapshot.get("user_args_read", true)), "player runtime must not read process user args")
        _expect(str(snapshot.get("view_mode", "")) == "player_prototype", "player presentation must be selected")
        _expect(bool(snapshot.get("compact_ui", false)), "player presentation must use compact UI")
        _expect(not bool(snapshot.get("debug_overlay", true)), "debug overlay must be disabled")
        _expect(not bool(snapshot.get("semantic_labels", true)), "semantic labels must be disabled")
        _expect(not bool(snapshot.get("performance_hud", true)), "performance HUD must be disabled")
        _expect(not bool(snapshot.get("auto_play", true)), "player route must not auto-play")
        _expect(not bool(snapshot.get("fast_mode", true)), "player route must stay at normal speed")
        _expect(
            is_equal_approx(
                float(snapshot.get("timing_scale", 0.0)),
                float(snapshot.get("default_timing_scale", -1.0))
            ),
            "player route must retain the normal prototype timing scale"
        )
        _expect(is_equal_approx(float(snapshot.get("runtime_speed_multiplier", 0.0)), 1.0), "runtime debug speed must stay at 1x")
        _expect(not bool(snapshot.get("capture_mode", true)), "player route must not enable capture mode")
        _expect(str(snapshot.get("runtime_start_fixture", "unexpected")) == "", "player route must not load a fixture")
        _expect(not bool(snapshot.get("runtime_load_local_save", true)), "player route must not load the dev save")
        _expect(not bool(snapshot.get("state_connector_enabled", true)), "player route must not start the connector")
        _expect(not bool(snapshot.get("state_connector_control_enabled", true)), "player route must not start connector control")
        _expect(not bool(snapshot.get("debug_card_visible", true)), "debug card must be hidden")
        _expect(not bool(snapshot.get("performance_label_visible", true)), "performance label must be hidden")
        _expect(not bool(snapshot.get("status_label_visible", true)), "QA status label must be hidden")
        _expect(str(snapshot.get("window_title", "")) == "Shelter", "player window title must be clean")

        var late_result: Dictionary = runtime.call("configure_player_session", {
            "startup_intent": "fresh_session",
        }) as Dictionary
        _expect(not bool(late_result.get("ok", true)), "player configuration must be rejected after runtime start")
        _expect(str(late_result.get("error", "")) == "player_session_already_started", "late configuration must fail explicitly")

    boot.queue_free()
    await get_tree().process_frame

    _clean_base()

    _finish()


func _finish() -> void:

    if _failures.is_empty():
        print("launch_surfaces_test=passed")
        get_tree().quit(0)
        return

    for failure in _failures:
        push_error("launch_surfaces_test failure: %s" % failure)
    get_tree().quit(1)


func _read_args() -> void:
    for arg in OS.get_cmdline_user_args():
        if arg.begins_with("--launch-test-base="):
            _base_dir = arg.trim_prefix("--launch-test-base=").trim_suffix("/")


func _clean_base() -> void:
    var path := ProjectSettings.globalize_path(_base_dir).simplify_path()
    if DirAccess.dir_exists_absolute(path):
        _remove_tree(path)


func _remove_tree(path: String) -> void:
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
