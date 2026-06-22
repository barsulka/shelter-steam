class_name ShelterLauncher
extends Control

const WINDOW_ID := DisplayServer.MAIN_WINDOW_ID
const LAUNCHER_SIZE := Vector2i(820, 560)
const MIN_SIZE := Vector2i(700, 460)

const LAUNCH_TARGETS := {
    "vertical_slice": {
        "title": "Vertical Slice",
        "description": "Первый loop: маршрут, выгрузка, кухня, фасовка, доставка, тапочки.",
        "scene": "res://scenes/prototypes/vertical_slice/vertical_slice_demo.tscn",
        "engine_args": [],
        "user_args": [],
    },
    "play": {
        "title": "Companion strip",
        "description": "Нижняя полоса Shelter с настройками окна.",
        "scene": "res://scenes/tech_demos/companion_field_demo.tscn",
        "engine_args": [],
        "user_args": ["--demo-companion", "--demo-transparent", "--demo-open-settings"],
    },
    "dog_runtime": {
        "title": "Dog runtime strip",
        "description": "Полоса с Бубликом, задачей переноса и performance HUD.",
        "scene": "res://scenes/tech_demos/companion_field_demo.tscn",
        "engine_args": ["--print-fps"],
        "user_args": ["--demo-companion", "--demo-transparent", "--demo-dog-runtime", "--demo-perf"],
    },
    "dog_lab": {
        "title": "Dog rig lab",
        "description": "Лаборатория рига и гибридной анимации собак.",
        "scene": "res://scenes/tech_demos/dog_rig_spike.tscn",
        "engine_args": ["--print-fps"],
        "user_args": ["--dog-rig-hybrid", "--dog-rig-print-perf"],
    },
    "window_probe": {
        "title": "Window probe",
        "description": "Проверка прозрачности, always-on-top и click-through.",
        "scene": "res://scenes/spikes/desktop_window_probe.tscn",
        "engine_args": [],
        "user_args": ["--spike-companion", "--spike-borderless", "--spike-interactive-polygon"],
    },
    "dog_runtime_smoke": {
        "title": "Dog runtime smoke",
        "description": "Internal launcher smoke target.",
        "scene": "res://scenes/tech_demos/companion_field_demo.tscn",
        "engine_args": ["--headless"],
        "user_args": ["--demo-auto-quit", "--demo-seconds=0.4", "--demo-companion", "--demo-dog-runtime", "--demo-perf"],
    },
    "vertical_slice_smoke": {
        "title": "Vertical Slice smoke",
        "description": "Internal launcher smoke target.",
        "scene": "res://scenes/prototypes/vertical_slice/vertical_slice_demo.tscn",
        "engine_args": ["--headless"],
        "user_args": ["--vertical-auto-play", "--vertical-fast", "--vertical-auto-quit", "--vertical-seconds=10"],
    },
}

var _status_label: Label
var _auto_quit := false
var _direct_target := ""


func _ready() -> void:
    _read_user_args()
    _apply_window_settings()
    _build_ui()

    if _direct_target != "":
        call_deferred("_launch_target", _direct_target)
        return

    if _auto_quit:
        await get_tree().process_frame
        get_tree().quit(0)


func _read_user_args() -> void:
    for arg in OS.get_cmdline_user_args():
        if arg == "--launcher-auto-quit":
            _auto_quit = true
        elif arg.begins_with("--launcher-direct="):
            _direct_target = arg.replace("--launcher-direct=", "").strip_edges()


func _apply_window_settings() -> void:
    get_viewport().transparent_bg = false
    get_window().content_scale_size = LAUNCHER_SIZE
    get_window().content_scale_factor = 1.0

    DisplayServer.window_set_title("Shelter Launcher", WINDOW_ID)
    DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED, WINDOW_ID)
    DisplayServer.window_set_min_size(MIN_SIZE, WINDOW_ID)
    DisplayServer.window_set_size(LAUNCHER_SIZE, WINDOW_ID)
    DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_ALWAYS_ON_TOP, false, WINDOW_ID)
    DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false, WINDOW_ID)
    DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_TRANSPARENT, false, WINDOW_ID)
    DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_MOUSE_PASSTHROUGH, false, WINDOW_ID)
    DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED, WINDOW_ID)

    var screen := DisplayServer.window_get_current_screen(WINDOW_ID)
    var usable_rect := DisplayServer.screen_get_usable_rect(screen)
    if usable_rect.size.x > 0 and usable_rect.size.y > 0:
        var position := usable_rect.position + ((usable_rect.size - LAUNCHER_SIZE) / 2)
        DisplayServer.window_set_position(position, WINDOW_ID)


func _build_ui() -> void:
    var background := ColorRect.new()
    background.set_anchors_preset(Control.PRESET_FULL_RECT)
    background.color = Color(0.09, 0.105, 0.095, 1.0)
    add_child(background)

    var root_margin := MarginContainer.new()
    root_margin.set_anchors_preset(Control.PRESET_FULL_RECT)
    root_margin.add_theme_constant_override("margin_left", 28)
    root_margin.add_theme_constant_override("margin_top", 24)
    root_margin.add_theme_constant_override("margin_right", 28)
    root_margin.add_theme_constant_override("margin_bottom", 24)
    add_child(root_margin)

    var layout := VBoxContainer.new()
    layout.add_theme_constant_override("separation", 18)
    root_margin.add_child(layout)

    var title := Label.new()
    title.text = "Shelter"
    title.add_theme_font_size_override("font_size", 34)
    title.add_theme_color_override("font_color", Color(0.94, 0.89, 0.76, 1.0))
    layout.add_child(title)

    var subtitle := Label.new()
    subtitle.text = "Запусти нужный режим одной кнопкой."
    subtitle.add_theme_font_size_override("font_size", 16)
    subtitle.add_theme_color_override("font_color", Color(0.76, 0.82, 0.74, 1.0))
    layout.add_child(subtitle)

    var target_grid := GridContainer.new()
    target_grid.columns = 2
    target_grid.add_theme_constant_override("h_separation", 14)
    target_grid.add_theme_constant_override("v_separation", 14)
    target_grid.size_flags_vertical = Control.SIZE_EXPAND_FILL
    layout.add_child(target_grid)

    _add_launch_button(target_grid, "vertical_slice")
    _add_launch_button(target_grid, "play")
    _add_launch_button(target_grid, "dog_runtime")
    _add_launch_button(target_grid, "dog_lab")
    _add_launch_button(target_grid, "window_probe")

    _status_label = Label.new()
    _status_label.text = "Готово."
    _status_label.add_theme_font_size_override("font_size", 13)
    _status_label.add_theme_color_override("font_color", Color(0.70, 0.78, 0.68, 1.0))
    layout.add_child(_status_label)


func _add_launch_button(parent: Container, target_id: String) -> void:
    var target := LAUNCH_TARGETS[target_id] as Dictionary
    var button := Button.new()
    button.text = "%s\n%s" % [str(target["title"]), str(target["description"])]
    button.alignment = HORIZONTAL_ALIGNMENT_LEFT
    button.text_overrun_behavior = TextServer.OVERRUN_NO_TRIMMING
    button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    button.custom_minimum_size = Vector2(360.0, 108.0)
    button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    button.size_flags_vertical = Control.SIZE_EXPAND_FILL
    button.add_theme_font_size_override("font_size", 16)
    button.pressed.connect(_launch_target.bind(target_id))
    parent.add_child(button)


func _launch_target(target_id: String) -> void:
    if not LAUNCH_TARGETS.has(target_id):
        _set_status("Не знаю такой режим: %s" % target_id, true)
        return

    var target := LAUNCH_TARGETS[target_id] as Dictionary
    var args := PackedStringArray()
    args.append_array(target.get("engine_args", []) as Array)
    args.append("--path")
    args.append(ProjectSettings.globalize_path("res://"))
    args.append("--scene")
    args.append(str(target["scene"]))

    var user_args := target.get("user_args", []) as Array
    if not user_args.is_empty():
        args.append("--")
        for user_arg in user_args:
            args.append(str(user_arg))

    var pid := OS.create_process(OS.get_executable_path(), args)
    if pid <= 0:
        _set_status("Не удалось запустить %s." % str(target["title"]), true)
        return

    _set_status("Запущено: %s." % str(target["title"]), false)
    await get_tree().create_timer(0.2).timeout
    get_tree().quit(0)


func _set_status(text: String, is_error: bool) -> void:
    if _status_label == null:
        return

    _status_label.text = text
    _status_label.add_theme_color_override(
        "font_color",
        Color(0.98, 0.58, 0.45, 1.0) if is_error else Color(0.70, 0.78, 0.68, 1.0)
    )
