class_name CompanionFieldDemo
extends Control

const WINDOW_ID := DisplayServer.MAIN_WINDOW_ID
const NORMAL_SIZE := Vector2i(1120, 360)
const COMPANION_SIZE := Vector2i(1120, 220)
const MIN_SIZE := Vector2i(720, 160)
const SETTINGS_BASE_SIZE := Vector2i(440, 560)
const WINDOW_MARGIN := 32
const FIELD_LAYOUT_PATH := "res://resources/tech_demos/companion_field_layout.json"
const GROUND_TEXTURE_PATH := "res://assets/tech_demos/placeholder_art/tx_tileset_ground.png"
const VILLAGE_PROPS_TEXTURE_PATH := "res://assets/tech_demos/placeholder_art/tx_village_props.png"
const MINI_BEAR_TEXTURE_PATH := "res://assets/tech_demos/placeholder_art/animals/MiniBear.png"
const MINI_BIRD_TEXTURE_PATH := "res://assets/tech_demos/placeholder_art/animals/MiniBird.png"
const MINI_BOAR_TEXTURE_PATH := "res://assets/tech_demos/placeholder_art/animals/MiniBoar.png"
const MINI_BUNNY_TEXTURE_PATH := "res://assets/tech_demos/placeholder_art/animals/MiniBunny.png"
const MINI_DEER_1_TEXTURE_PATH := "res://assets/tech_demos/placeholder_art/animals/MiniDeer1.png"
const MINI_DEER_2_TEXTURE_PATH := "res://assets/tech_demos/placeholder_art/animals/MiniDeer2.png"
const MINI_FOX_TEXTURE_PATH := "res://assets/tech_demos/placeholder_art/animals/MiniFox.png"
const MINI_WOLF_TEXTURE_PATH := "res://assets/tech_demos/placeholder_art/animals/MiniWolf.png"
const ZOOM_LEVELS := [0.5, 1.0, 1.5, 2.0]
const ZOOM_LABELS := ["50", "100", "150", "200"]
const DEFAULT_GAME_ZOOM_INDEX := 1
const DEFAULT_CONTROLS_SCALE_INDEX := 2
const SETTINGS_PATH := "user://companion_field_demo.cfg"
const SETTINGS_SECTION := "companion_field"
const GROUND_DIRT_HEIGHT := 34.0
const GROUND_GRASS_HEIGHT := 6.0
const CELL_OVERLAY_TOP_OFFSET := 8.0
const CELL_OVERLAY_HEIGHT := 22.0
const MOUSE_PASSTHROUGH_PADDING := 6.0
const ANIMAL_TICK_SECONDS := 0.05
const PERFORMANCE_TICK_SECONDS := 0.5
const GROUND_TILE_SOURCE := Rect2(0.0, 0.0, 96.0, 96.0)

var _zoom_index := DEFAULT_GAME_ZOOM_INDEX
var _controls_scale_index := DEFAULT_CONTROLS_SCALE_INDEX
var _cell_size := 32.0
var _total_cells := 0
var _camera_x := 0.0
var _pan_speed := 50.0
var _target_screen := 0
var _companion_mode := true
var _always_on_top := true
var _transparent_window := true
var _click_through_empty := true
var _show_performance_hud := true
var _field_hidden := false
var _auto_quit := false
var _auto_quit_seconds := 0.5
var _open_settings_on_start := false
var _selected_object_id := ""
var _move_mode := false
var _moving_instance_id := ""
var _move_grab_cell_offset := 0
var _hover_cell_index := -1
var _last_event := "ready"
var _dragging := false
var _drag_start := Vector2.ZERO
var _drag_start_camera_x := 0.0
var _drag_moved := false
var _animal_motion_time := 0.0

var _zones: Array[Dictionary] = []
var _zone_by_id: Dictionary = {}
var _building_types: Dictionary = {}
var _building_instances: Array[Dictionary] = []
var _instance_by_id: Dictionary = {}
var _ground_texture: Texture2D
var _village_props_texture: Texture2D
var _mini_bear_texture: Texture2D
var _mini_bird_texture: Texture2D
var _mini_boar_texture: Texture2D
var _mini_bunny_texture: Texture2D
var _mini_deer_1_texture: Texture2D
var _mini_deer_2_texture: Texture2D
var _mini_fox_texture: Texture2D
var _mini_wolf_texture: Texture2D

var _settings_button: Button
var _visibility_button: Button
var _status_label: Label
var _performance_label: Label
var _settings_window: Window
var _settings_margin: MarginContainer
var _settings_layout: VBoxContainer
var _screen_option: OptionButton
var _zoom_option: OptionButton
var _controls_scale_option: OptionButton
var _pan_label: Label
var _pan_slider: HSlider
var _screen_label: Label
var _always_on_top_check: CheckBox
var _transparent_check: CheckBox
var _click_through_check: CheckBox
var _performance_check: CheckBox
var _companion_check: CheckBox


func _ready() -> void:
    mouse_filter = Control.MOUSE_FILTER_STOP
    _load_placeholder_textures()
    _load_field_layout()
    _load_saved_settings()
    _read_user_args()
    _build_overlay()
    _build_settings_window()
    _apply_window_settings()
    _update_settings_values()
    _update_status()
    queue_redraw()

    await get_tree().process_frame
    _apply_mouse_passthrough()
    _start_animal_motion()
    _start_performance_hud()

    var report := _build_report()
    for line in report:
        print(line)

    if _open_settings_on_start and DisplayServer.get_name() != "headless":
        _show_settings()

    if _auto_quit:
        await get_tree().create_timer(_auto_quit_seconds).timeout
        get_tree().quit(0)


func _notification(what: int) -> void:
    if what == NOTIFICATION_RESIZED:
        _camera_x = _clamped_camera_x(_camera_x)
        _apply_controls_scale()
        _apply_mouse_passthrough()
        _update_status()
        queue_redraw()


func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventKey:
        var key_event := event as InputEventKey
        if not key_event.pressed:
            return

        match key_event.keycode:
            KEY_ESCAPE:
                _cancel_move_mode()
                get_viewport().set_input_as_handled()
            KEY_LEFT:
                _pan(-1.0)
                get_viewport().set_input_as_handled()
            KEY_RIGHT:
                _pan(1.0)
                get_viewport().set_input_as_handled()
            KEY_UP:
                _set_zoom_index(_zoom_index + 1)
                get_viewport().set_input_as_handled()
            KEY_DOWN:
                _set_zoom_index(_zoom_index - 1)
                get_viewport().set_input_as_handled()
            KEY_S:
                _show_settings()
                get_viewport().set_input_as_handled()


func _gui_input(event: InputEvent) -> void:
    if _field_hidden:
        return

    if event is InputEventMouseButton:
        var button_event := event as InputEventMouseButton
        _hover_cell_index = _cell_at_screen_position(button_event.position)

        if button_event.button_index == MOUSE_BUTTON_WHEEL_UP and button_event.pressed:
            _set_zoom_index(_zoom_index + 1)
            accept_event()
        elif button_event.button_index == MOUSE_BUTTON_WHEEL_DOWN and button_event.pressed:
            _set_zoom_index(_zoom_index - 1)
            accept_event()
        elif button_event.button_index == MOUSE_BUTTON_LEFT:
            if _move_mode:
                if not button_event.pressed:
                    _handle_click(button_event.position)
                accept_event()
                return

            if button_event.pressed:
                _dragging = true
                _drag_start = button_event.position
                _drag_start_camera_x = _camera_x
                _drag_moved = false
            else:
                if _dragging and not _drag_moved:
                    _handle_click(button_event.position)
                _dragging = false
            accept_event()
    elif event is InputEventMouseMotion:
        var motion_event := event as InputEventMouseMotion
        _hover_cell_index = _cell_at_screen_position(motion_event.position)

        if _move_mode:
            queue_redraw()
            accept_event()
            return

        if not _dragging:
            return

        var delta_x := motion_event.position.x - _drag_start.x

        if absf(delta_x) >= 3.0:
            _drag_moved = true
            _camera_x = _clamped_camera_x(_drag_start_camera_x - (delta_x / _zoom()))
            _last_event = "drag pan"
            _apply_mouse_passthrough()
            _update_status()
            queue_redraw()
            accept_event()


func _draw() -> void:
    if _field_hidden:
        return

    var baseline := _field_baseline()

    _draw_zone_ground(baseline)
    _draw_placeholder_props()
    _draw_move_mode_cells()

    for instance in _building_instances:
        if _move_mode and str(instance.get("id", "")) == _moving_instance_id:
            continue

        _draw_building_instance(instance)

    _draw_moving_building()

    _draw_placeholder_animals()
    _draw_selected_panel()


func _read_user_args() -> void:
    for arg in OS.get_cmdline_user_args():
        if arg == "--demo-auto-quit":
            _auto_quit = true
        elif arg.begins_with("--demo-seconds="):
            _auto_quit_seconds = maxf(arg.replace("--demo-seconds=", "").to_float(), 0.1)
        elif arg == "--demo-normal":
            _companion_mode = false
        elif arg == "--demo-companion":
            _companion_mode = true
        elif arg == "--demo-click-through":
            _click_through_empty = true
        elif arg == "--demo-perf":
            _show_performance_hud = true
        elif arg == "--demo-no-perf":
            _show_performance_hud = false
        elif arg == "--demo-open-settings":
            _open_settings_on_start = true
        elif arg == "--demo-transparent":
            _transparent_window = true
        elif arg == "--demo-no-transparent":
            _transparent_window = false
        elif arg == "--demo-no-always-on-top":
            _always_on_top = false
        elif arg.begins_with("--demo-screen="):
            _target_screen = maxi(arg.replace("--demo-screen=", "").to_int(), 0)
        elif arg.begins_with("--demo-zoom="):
            _zoom_index = _label_to_scale_index(arg.replace("--demo-zoom=", ""), _zoom_index)
        elif arg.begins_with("--demo-controls-scale="):
            _controls_scale_index = _label_to_scale_index(arg.replace("--demo-controls-scale=", ""), _controls_scale_index)


func _load_placeholder_textures() -> void:
    _ground_texture = _load_png_texture(GROUND_TEXTURE_PATH)
    _village_props_texture = _load_png_texture(VILLAGE_PROPS_TEXTURE_PATH)
    _mini_bear_texture = _load_png_texture(MINI_BEAR_TEXTURE_PATH)
    _mini_bird_texture = _load_png_texture(MINI_BIRD_TEXTURE_PATH)
    _mini_boar_texture = _load_png_texture(MINI_BOAR_TEXTURE_PATH)
    _mini_bunny_texture = _load_png_texture(MINI_BUNNY_TEXTURE_PATH)
    _mini_deer_1_texture = _load_png_texture(MINI_DEER_1_TEXTURE_PATH)
    _mini_deer_2_texture = _load_png_texture(MINI_DEER_2_TEXTURE_PATH)
    _mini_fox_texture = _load_png_texture(MINI_FOX_TEXTURE_PATH)
    _mini_wolf_texture = _load_png_texture(MINI_WOLF_TEXTURE_PATH)


func _load_png_texture(path: String) -> Texture2D:
    var resource := ResourceLoader.load(path)
    if resource is Texture2D:
        return resource as Texture2D

    var bytes := FileAccess.get_file_as_bytes(path)
    if bytes.is_empty():
        push_warning("Could not read placeholder texture: %s" % path)
        return null

    var image := Image.new()
    var error := image.load_png_from_buffer(bytes)

    if error != OK:
        push_warning("Could not load placeholder texture: %s (%s)" % [path, error])
        return null

    return ImageTexture.create_from_image(image)


func _start_animal_motion() -> void:
    if DisplayServer.get_name() == "headless":
        return

    var timer := Timer.new()
    timer.wait_time = ANIMAL_TICK_SECONDS
    timer.autostart = true
    timer.timeout.connect(_on_animal_tick)
    add_child(timer)


func _on_animal_tick() -> void:
    if _field_hidden:
        return

    _animal_motion_time += ANIMAL_TICK_SECONDS
    _apply_mouse_passthrough()
    queue_redraw()


func _start_performance_hud() -> void:
    if DisplayServer.get_name() == "headless":
        return

    var timer := Timer.new()
    timer.wait_time = PERFORMANCE_TICK_SECONDS
    timer.autostart = true
    timer.timeout.connect(_on_performance_tick)
    add_child(timer)
    _update_performance_hud()


func _on_performance_tick() -> void:
    _update_performance_hud()
    _apply_mouse_passthrough()


func _load_field_layout() -> void:
    var text := FileAccess.get_file_as_string(FIELD_LAYOUT_PATH)
    var parsed: Variant = JSON.parse_string(text)

    if typeof(parsed) != TYPE_DICTIONARY:
        push_error("Could not parse companion field layout: %s" % FIELD_LAYOUT_PATH)
        return

    var layout := parsed as Dictionary
    _cell_size = float(layout.get("cell_size", 32.0))
    _zones.clear()
    _zone_by_id.clear()
    _building_instances.clear()
    _instance_by_id.clear()
    _building_types = layout.get("building_types", {})
    _total_cells = 0
    var player_state := layout.get("player_state", {}) as Dictionary
    var unlocked_cells_by_zone := player_state.get("zone_unlocked_cells", {}) as Dictionary

    var raw_zones: Array = layout.get("zones", [])
    for raw_zone in raw_zones:
        if typeof(raw_zone) != TYPE_DICTIONARY:
            continue

        var zone := (raw_zone as Dictionary).duplicate(true)
        var zone_id := str(zone.get("id", ""))
        if unlocked_cells_by_zone.has(zone_id):
            var base_cells := int(zone.get("base_cells", zone.get("cells", 0)))
            var max_cells := int(zone.get("max_cells", base_cells))
            zone["unlocked_cells"] = clampi(int(unlocked_cells_by_zone[zone_id]), base_cells, max_cells)

        var cell_count := _zone_unlocked_cells(zone)
        zone["start_cell"] = _total_cells
        zone["end_cell"] = _total_cells + cell_count - 1
        _total_cells += cell_count
        _zones.append(zone)
        _zone_by_id[zone_id] = zone

    var raw_instances: Array = layout.get("building_instances", [])
    for raw_instance in raw_instances:
        if typeof(raw_instance) != TYPE_DICTIONARY:
            continue

        var instance := (raw_instance as Dictionary).duplicate(true)
        _building_instances.append(instance)
        _instance_by_id[str(instance.get("id", ""))] = instance


func _load_saved_settings() -> void:
    var config := ConfigFile.new()
    if config.load(SETTINGS_PATH) != OK:
        return

    _zoom_index = _coerced_scale_index(
        config.get_value(SETTINGS_SECTION, "game_zoom_index", DEFAULT_GAME_ZOOM_INDEX),
        DEFAULT_GAME_ZOOM_INDEX
    )
    _controls_scale_index = _coerced_scale_index(
        config.get_value(SETTINGS_SECTION, "controls_scale_index", DEFAULT_CONTROLS_SCALE_INDEX),
        DEFAULT_CONTROLS_SCALE_INDEX
    )
    _show_performance_hud = bool(config.get_value(SETTINGS_SECTION, "show_performance_hud", true))


func _save_settings() -> void:
    var config := ConfigFile.new()
    config.set_value(SETTINGS_SECTION, "game_zoom_index", _zoom_index)
    config.set_value(SETTINGS_SECTION, "controls_scale_index", _controls_scale_index)
    config.set_value(SETTINGS_SECTION, "show_performance_hud", _show_performance_hud)

    var error := config.save(SETTINGS_PATH)
    if error != OK:
        push_warning("Could not save companion field demo settings: %s" % error)


func _label_to_scale_index(label: String, fallback: int) -> int:
    var clean_label := label.strip_edges()
    for i in ZOOM_LABELS.size():
        if ZOOM_LABELS[i] == clean_label:
            return i

    return _coerced_scale_index(clean_label.to_int(), fallback)


func _coerced_scale_index(value: Variant, fallback: int) -> int:
    var index := int(value)
    if index < 0 or index >= ZOOM_LEVELS.size():
        return fallback

    return index


func _build_overlay() -> void:
    _settings_button = Button.new()
    _settings_button.text = "Settings"
    _settings_button.pressed.connect(_show_settings)
    add_child(_settings_button)

    _visibility_button = Button.new()
    _visibility_button.text = "Hide"
    _visibility_button.pressed.connect(_toggle_field_hidden)
    add_child(_visibility_button)

    _status_label = Label.new()
    add_child(_status_label)

    _performance_label = Label.new()
    _performance_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
    _performance_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
    _performance_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
    _performance_label.add_theme_color_override("font_color", Color(0.89, 0.97, 0.88, 1.0))
    _performance_label.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.9))
    _performance_label.add_theme_constant_override("shadow_offset_x", 1)
    _performance_label.add_theme_constant_override("shadow_offset_y", 1)
    add_child(_performance_label)


func _build_settings_window() -> void:
    _settings_window = Window.new()
    _settings_window.title = "Shelter Field Settings"
    _settings_window.visible = false
    _settings_window.force_native = true
    _settings_window.always_on_top = true
    _settings_window.unresizable = false
    _settings_window.close_requested.connect(func() -> void: _settings_window.hide())
    add_child(_settings_window)

    var panel := PanelContainer.new()
    panel.set_anchors_preset(Control.PRESET_FULL_RECT)
    _settings_window.add_child(panel)

    _settings_margin = MarginContainer.new()
    panel.add_child(_settings_margin)

    var scroll := ScrollContainer.new()
    scroll.set_anchors_preset(Control.PRESET_FULL_RECT)
    scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
    _settings_margin.add_child(scroll)

    _settings_layout = VBoxContainer.new()
    _settings_layout.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    scroll.add_child(_settings_layout)

    _screen_label = Label.new()
    _settings_layout.add_child(_screen_label)

    _screen_option = OptionButton.new()
    _screen_option.item_selected.connect(_on_screen_selected)
    _settings_layout.add_child(_screen_option)

    _companion_check = CheckBox.new()
    _companion_check.text = "Companion mode"
    _companion_check.toggled.connect(_on_companion_toggled)
    _settings_layout.add_child(_companion_check)

    _always_on_top_check = CheckBox.new()
    _always_on_top_check.text = "Always on top"
    _always_on_top_check.toggled.connect(_on_always_on_top_toggled)
    _settings_layout.add_child(_always_on_top_check)

    _transparent_check = CheckBox.new()
    _transparent_check.text = "Transparent background"
    _transparent_check.toggled.connect(_on_transparent_toggled)
    _settings_layout.add_child(_transparent_check)

    _click_through_check = CheckBox.new()
    _click_through_check.text = "Click-through empty space"
    _click_through_check.toggled.connect(_on_click_through_toggled)
    _settings_layout.add_child(_click_through_check)

    _performance_check = CheckBox.new()
    _performance_check.text = "Performance HUD"
    _performance_check.toggled.connect(_on_performance_toggled)
    _settings_layout.add_child(_performance_check)

    var zoom_label := Label.new()
    zoom_label.text = "Game zoom"
    _settings_layout.add_child(zoom_label)

    _zoom_option = OptionButton.new()
    for i in ZOOM_LABELS.size():
        _zoom_option.add_item(ZOOM_LABELS[i], i)
    _zoom_option.item_selected.connect(_on_zoom_selected)
    _settings_layout.add_child(_zoom_option)

    var controls_scale_label := Label.new()
    controls_scale_label.text = "Controls scale"
    _settings_layout.add_child(controls_scale_label)

    _controls_scale_option = OptionButton.new()
    for i in ZOOM_LABELS.size():
        _controls_scale_option.add_item(ZOOM_LABELS[i], i)
    _controls_scale_option.item_selected.connect(_on_controls_scale_selected)
    _settings_layout.add_child(_controls_scale_option)

    _pan_label = Label.new()
    _settings_layout.add_child(_pan_label)

    _pan_slider = HSlider.new()
    _pan_slider.min_value = 10.0
    _pan_slider.max_value = 120.0
    _pan_slider.step = 1.0
    _pan_slider.value = _pan_speed
    _pan_slider.value_changed.connect(_on_pan_speed_changed)
    _settings_layout.add_child(_pan_slider)

    var place_button := Button.new()
    place_button.text = "Apply placement"
    place_button.pressed.connect(_apply_window_settings)
    _settings_layout.add_child(place_button)

    var reset_button := Button.new()
    reset_button.text = "Reset camera"
    reset_button.pressed.connect(_reset_camera)
    _settings_layout.add_child(reset_button)

    var quit_button := Button.new()
    quit_button.text = "Выход"
    quit_button.pressed.connect(func() -> void: get_tree().quit(0))
    _settings_layout.add_child(quit_button)


func _apply_window_settings() -> void:
    var screen_count: int = maxi(DisplayServer.get_screen_count(), 1)
    _target_screen = clampi(_target_screen, 0, screen_count - 1)

    var target_size := _target_window_size()
    var usable_rect := DisplayServer.screen_get_usable_rect(_target_screen)

    get_viewport().transparent_bg = _transparent_window
    get_window().content_scale_size = target_size
    get_window().content_scale_factor = 1.0

    DisplayServer.window_set_title("Shelter Companion Field Demo", WINDOW_ID)
    DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED, WINDOW_ID)
    DisplayServer.window_set_min_size(MIN_SIZE, WINDOW_ID)
    DisplayServer.window_set_size(target_size, WINDOW_ID)
    DisplayServer.window_set_current_screen(_target_screen, WINDOW_ID)
    DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED, WINDOW_ID)
    DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_ALWAYS_ON_TOP, _always_on_top, WINDOW_ID)
    DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, _companion_mode, WINDOW_ID)
    DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_TRANSPARENT, _transparent_window, WINDOW_ID)
    DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_MOUSE_PASSTHROUGH, false, WINDOW_ID)

    if usable_rect.size.x > 0 and usable_rect.size.y > 0:
        var target_position := Vector2i(usable_rect.position.x, usable_rect.position.y + usable_rect.size.y - target_size.y)

        if not _companion_mode:
            target_position = usable_rect.position + Vector2i(80, 120)

        DisplayServer.window_set_position(target_position, WINDOW_ID)

    _last_event = "window applied"
    _camera_x = _clamped_camera_x(_camera_x)
    _apply_controls_scale()
    _apply_mouse_passthrough()
    _update_screen_options()
    _update_settings_values()
    _update_status()

    if _settings_window != null and _settings_window.visible:
        call_deferred("_center_settings_window_on_screen")

    queue_redraw()


func _target_window_size() -> Vector2i:
    var target_size := COMPANION_SIZE if _companion_mode else NORMAL_SIZE
    var usable_rect := DisplayServer.screen_get_usable_rect(_target_screen)

    if usable_rect.size.x <= 0 or usable_rect.size.y <= 0:
        return target_size

    if _companion_mode:
        return Vector2i(maxi(MIN_SIZE.x, usable_rect.size.x), clampi(target_size.y, MIN_SIZE.y, usable_rect.size.y))

    var max_width: int = maxi(MIN_SIZE.x, usable_rect.size.x - (WINDOW_MARGIN * 2))
    var max_height: int = maxi(MIN_SIZE.y, usable_rect.size.y - (WINDOW_MARGIN * 2))

    return Vector2i(
        clampi(target_size.x, MIN_SIZE.x, max_width),
        clampi(target_size.y, MIN_SIZE.y, max_height)
    )


func _apply_controls_scale() -> void:
    var scale := _ui_scale()
    var window_size := Vector2(DisplayServer.window_get_size(WINDOW_ID))
    var viewport_width := maxf(window_size.x, size.x)
    var viewport_height := maxf(window_size.y, size.y)

    if _settings_button != null:
        _settings_button.visible = not _field_hidden
        _settings_button.position = Vector2(12.0, 12.0) * scale
        _settings_button.custom_minimum_size = Vector2(104.0, 32.0) * scale
        _apply_theme_scale(_settings_button, 13)

    if _visibility_button != null:
        var button_size := Vector2(76.0, 32.0) * scale
        _visibility_button.text = "Show" if _field_hidden else "Hide"
        _visibility_button.position = Vector2(
            viewport_width - button_size.x - (12.0 * scale),
            viewport_height - button_size.y - (12.0 * scale)
        )
        _visibility_button.custom_minimum_size = button_size
        _visibility_button.size = button_size
        _apply_theme_scale(_visibility_button, 13)

    if _status_label != null:
        _status_label.visible = not _field_hidden
        _status_label.position = Vector2(132.0, 16.0) * scale
        var reserved_right := (388.0 * scale) if _show_performance_hud else (12.0 * scale)
        var status_width := maxf(320.0 * scale, viewport_width - _status_label.position.x - reserved_right)
        _status_label.custom_minimum_size = Vector2(status_width, 32.0 * scale)
        _apply_theme_scale(_status_label, 13)

    if _performance_label != null:
        var performance_size := Vector2(360.0, 82.0) * scale
        _performance_label.visible = _show_performance_hud and not _field_hidden
        _performance_label.position = Vector2(
            viewport_width - performance_size.x - (12.0 * scale),
            12.0 * scale
        )
        _performance_label.custom_minimum_size = performance_size
        _performance_label.size = performance_size
        _apply_theme_scale(_performance_label, 11)

    if _settings_margin != null:
        var margin := _scaled_int(12)
        _settings_margin.add_theme_constant_override("margin_left", margin)
        _settings_margin.add_theme_constant_override("margin_top", margin)
        _settings_margin.add_theme_constant_override("margin_right", margin)
        _settings_margin.add_theme_constant_override("margin_bottom", margin)

    if _settings_layout != null:
        _settings_layout.add_theme_constant_override("separation", _scaled_int(10))
        _apply_theme_scale_tree(_settings_layout)

    if _settings_window != null:
        _settings_window.size = _settings_window_size()


func _apply_theme_scale_tree(node: Node) -> void:
    if node is Control:
        _apply_theme_scale(node as Control)

    for child in node.get_children():
        _apply_theme_scale_tree(child)


func _apply_theme_scale(control: Control, base_font_size := 14) -> void:
    control.add_theme_font_size_override("font_size", _scaled_int(base_font_size))

    if control is Button or control is CheckBox or control is OptionButton:
        control.custom_minimum_size.y = _scaled_float(34.0)
    elif control is Label:
        control.custom_minimum_size.y = _scaled_float(24.0)
    elif control is HSlider:
        control.custom_minimum_size.y = _scaled_float(32.0)


func _settings_window_size() -> Vector2i:
    var desired_size := _scaled_v2i(SETTINGS_BASE_SIZE)
    var usable_rect := DisplayServer.screen_get_usable_rect(_target_screen)

    if usable_rect.size.x <= 0 or usable_rect.size.y <= 0:
        return desired_size

    return Vector2i(
        mini(desired_size.x, maxi(360, usable_rect.size.x - (WINDOW_MARGIN * 2))),
        mini(desired_size.y, maxi(420, usable_rect.size.y - (WINDOW_MARGIN * 2)))
    )


func _scaled_v2i(value: Vector2i) -> Vector2i:
    return Vector2i(_scaled_int(value.x), _scaled_int(value.y))


func _scaled_int(value: int) -> int:
    return maxi(1, roundi(float(value) * _ui_scale()))


func _scaled_float(value: float) -> float:
    return value * _ui_scale()


func _apply_mouse_passthrough() -> void:
    if _field_hidden:
        DisplayServer.window_set_mouse_passthrough(_visibility_button_polygon(), WINDOW_ID)
        return

    if _move_mode:
        DisplayServer.window_set_mouse_passthrough(PackedVector2Array(), WINDOW_ID)
        return

    if not _transparent_window or not _click_through_empty:
        DisplayServer.window_set_mouse_passthrough(PackedVector2Array(), WINDOW_ID)
        return

    DisplayServer.window_set_mouse_passthrough(_interactive_mouse_polygon(), WINDOW_ID)


func _interactive_mouse_polygon() -> PackedVector2Array:
    var window_size := Vector2(DisplayServer.window_get_size(WINDOW_ID))
    var window_width := maxf(size.x, window_size.x)
    var window_height := maxf(size.y, window_size.y)
    var base_top := clampf(_field_baseline() - (GROUND_GRASS_HEIGHT * _zoom()) - MOUSE_PASSTHROUGH_PADDING, 0.0, window_height)
    var intervals: Array[Dictionary] = []

    if _settings_button != null:
        var settings_rect := Rect2(
            _settings_button.global_position - (Vector2.ONE * MOUSE_PASSTHROUGH_PADDING),
            _settings_button.size + (Vector2.ONE * MOUSE_PASSTHROUGH_PADDING * 2.0)
        )
        _add_mouse_interval(intervals, settings_rect.position.x, settings_rect.end.x, settings_rect.position.y, window_width, base_top)

    if _visibility_button != null:
        var visibility_rect := _visibility_button_rect()
        _add_mouse_interval(intervals, visibility_rect.position.x, visibility_rect.end.x, visibility_rect.position.y, window_width, base_top)

    if _performance_label != null and _performance_label.visible:
        var performance_rect := Rect2(_performance_label.global_position, _performance_label.size).grow(MOUSE_PASSTHROUGH_PADDING)
        _add_mouse_interval(intervals, performance_rect.position.x, performance_rect.end.x, performance_rect.position.y, window_width, base_top)

    for instance in _building_instances:
        if _move_mode and str(instance.get("id", "")) == _moving_instance_id:
            continue

        var building_rect := _building_screen_rect(instance).grow(MOUSE_PASSTHROUGH_PADDING)
        _add_mouse_interval(intervals, building_rect.position.x, building_rect.end.x, building_rect.position.y, window_width, base_top)

    for placeholder_rect in _placeholder_screen_rects():
        var expanded_rect := placeholder_rect.grow(MOUSE_PASSTHROUGH_PADDING)
        _add_mouse_interval(intervals, expanded_rect.position.x, expanded_rect.end.x, expanded_rect.position.y, window_width, base_top)

    if _move_mode:
        var moving_instance := _instance_by_id.get(_moving_instance_id, {}) as Dictionary
        if not moving_instance.is_empty():
            var candidate_start := _candidate_start_cell()
            if candidate_start < 0:
                candidate_start = _instance_world_cell(moving_instance)

            var moving_rect := _building_screen_rect(moving_instance, candidate_start).grow(MOUSE_PASSTHROUGH_PADDING)
            _add_mouse_interval(intervals, moving_rect.position.x, moving_rect.end.x, moving_rect.position.y, window_width, base_top)

    var merged := _merged_mouse_intervals(intervals)
    var points := PackedVector2Array()
    points.append(Vector2(0.0, base_top))

    var cursor_x := 0.0
    for interval in merged:
        var x1 := float(interval["x1"])
        var x2 := float(interval["x2"])
        var top := float(interval["top"])

        if x1 > cursor_x:
            points.append(Vector2(x1, base_top))

        points.append(Vector2(x1, top))
        points.append(Vector2(x2, top))
        points.append(Vector2(x2, base_top))
        cursor_x = x2

    if cursor_x < window_width:
        points.append(Vector2(window_width, base_top))

    points.append(Vector2(window_width, window_height))
    points.append(Vector2(0.0, window_height))

    return points


func _visibility_button_polygon() -> PackedVector2Array:
    var rect := _visibility_button_rect()
    return PackedVector2Array([
        rect.position,
        Vector2(rect.end.x, rect.position.y),
        rect.end,
        Vector2(rect.position.x, rect.end.y),
    ])


func _visibility_button_rect() -> Rect2:
    if _visibility_button == null:
        return Rect2()

    return Rect2(_visibility_button.global_position, _visibility_button.size).grow(MOUSE_PASSTHROUGH_PADDING)


func _add_mouse_interval(
        intervals: Array[Dictionary],
        raw_x1: float,
        raw_x2: float,
        raw_top: float,
        window_width: float,
        base_top: float
) -> void:
    var x1 := clampf(raw_x1, 0.0, window_width)
    var x2 := clampf(raw_x2, 0.0, window_width)

    if x2 <= x1:
        return

    intervals.append({
        "x1": x1,
        "x2": x2,
        "top": clampf(raw_top, 0.0, base_top),
    })


func _merged_mouse_intervals(intervals: Array[Dictionary]) -> Array[Dictionary]:
    intervals.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
        return float(a["x1"]) < float(b["x1"])
    )

    var merged: Array[Dictionary] = []
    for interval in intervals:
        if merged.is_empty():
            merged.append(interval.duplicate())
            continue

        var last := merged[merged.size() - 1]
        if float(interval["x1"]) > float(last["x2"]) + 1.0:
            merged.append(interval.duplicate())
            continue

        last["x2"] = maxf(float(last["x2"]), float(interval["x2"]))
        last["top"] = minf(float(last["top"]), float(interval["top"]))

    return merged


func _build_report() -> Array[String]:
    var screen := DisplayServer.window_get_current_screen(WINDOW_ID)
    var lines: Array[String] = []

    lines.append("demo=companion_field")
    lines.append("display_server=%s" % DisplayServer.get_name())
    lines.append("os=%s" % OS.get_name())
    lines.append("screen_count=%s" % DisplayServer.get_screen_count())
    lines.append("screen_index=%s" % screen)
    lines.append("screen_size=%s" % DisplayServer.screen_get_size(screen))
    lines.append("screen_usable_rect=%s" % DisplayServer.screen_get_usable_rect(screen))
    lines.append("screen_scale=%s" % DisplayServer.screen_get_scale(screen))
    lines.append("screen_dpi=%s" % DisplayServer.screen_get_dpi(screen))
    lines.append("window_size=%s" % DisplayServer.window_get_size(WINDOW_ID))
    lines.append("window_position=%s" % DisplayServer.window_get_position(WINDOW_ID))
    lines.append("content_scale_size=%s" % get_window().content_scale_size)
    lines.append("flag_always_on_top=%s" % DisplayServer.window_get_flag(DisplayServer.WINDOW_FLAG_ALWAYS_ON_TOP, WINDOW_ID))
    lines.append("flag_borderless=%s" % DisplayServer.window_get_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, WINDOW_ID))
    lines.append("flag_transparent=%s" % DisplayServer.window_get_flag(DisplayServer.WINDOW_FLAG_TRANSPARENT, WINDOW_ID))
    lines.append("click_through_empty=%s" % _click_through_empty)
    lines.append("performance_hud=%s" % _show_performance_hud)
    lines.append("game_zoom=%s" % ZOOM_LABELS[_zoom_index])
    lines.append("controls_scale=%s" % ZOOM_LABELS[_controls_scale_index])
    lines.append("field_cells=%s" % _total_cells)
    lines.append("field_world_width=%.1f" % _world_width())
    lines.append("camera_x=%.1f" % _camera_x)
    lines.append("pan_speed=%.1f" % _pan_speed)

    return lines


func _draw_zone_ground(baseline: float) -> void:
    var visible_start := _camera_x - _cell_size
    var visible_end := _camera_x + _visible_world_width() + _cell_size

    for zone in _zones:
        var zone_start_world := float(zone.get("start_cell", 0)) * _cell_size
        var zone_width := float(_zone_unlocked_cells(zone)) * _cell_size
        var zone_end_world := zone_start_world + zone_width

        if zone_end_world < visible_start or zone_start_world > visible_end:
            continue

        var screen_left := _world_to_screen(Vector2(zone_start_world, 0.0)).x
        var screen_right := _world_to_screen(Vector2(zone_end_world, 0.0)).x
        _draw_textured_ground_zone(zone, baseline, screen_left, screen_right)


func _draw_textured_ground_zone(zone: Dictionary, baseline: float, screen_left: float, screen_right: float) -> void:
    if _ground_texture == null:
        draw_rect(
            Rect2(Vector2(screen_left, baseline - (GROUND_GRASS_HEIGHT * _zoom())), Vector2(screen_right - screen_left, (GROUND_GRASS_HEIGHT + GROUND_DIRT_HEIGHT) * _zoom())),
            _zone_ground_color(zone),
            true
        )
        return

    var start_cell := maxi(int(zone.get("start_cell", 0)), (floori(_camera_x / (_cell_size * 2.0)) * 2) - 2)
    var end_cell := mini(int(zone.get("end_cell", -1)), ceili((_camera_x + _visible_world_width()) / _cell_size) + 1)
    var tile_size := Vector2(_cell_size * 2.0, GROUND_GRASS_HEIGHT + GROUND_DIRT_HEIGHT) * _zoom()
    var tile_top := baseline - (GROUND_GRASS_HEIGHT * _zoom())
    var tint := _zone_asset_tint(zone)

    for cell in range(start_cell, end_cell + 1, 2):
        var cell_left := _world_to_screen(Vector2(float(cell) * _cell_size, 0.0)).x
        var rect := Rect2(Vector2(cell_left, tile_top), tile_size)
        draw_texture_rect_region(_ground_texture, rect, GROUND_TILE_SOURCE, tint)

    draw_rect(
        Rect2(Vector2(screen_left, baseline + (GROUND_DIRT_HEIGHT * _zoom()) - maxf(1.0, 2.0 * _zoom())), Vector2(screen_right - screen_left, maxf(1.0, 2.0 * _zoom()))),
        Color(0.13, 0.09, 0.05, 0.42),
        true
    )


func _draw_placeholder_props() -> void:
    if _village_props_texture == null:
        return

    for spec in _placeholder_prop_specs():
        var rect := _placeholder_screen_rect(spec)
        if not _is_rect_visible(rect):
            continue

        var source := spec.get("source", Rect2()) as Rect2
        draw_texture_rect_region(
            _village_props_texture,
            rect,
            source,
            Color(1.0, 1.0, 1.0, 0.94)
        )


func _draw_placeholder_animals() -> void:
    for spec in _placeholder_animal_specs():
        var rect := _placeholder_screen_rect(spec)
        if not _is_rect_visible(rect):
            continue

        var texture := spec.get("texture", null) as Texture2D
        if texture == null:
            continue

        var source := _placeholder_animal_source(spec)
        draw_texture_rect_region(
            texture,
            rect,
            source,
            Color(1.0, 1.0, 1.0, 0.96)
        )


func _placeholder_screen_rects() -> Array[Rect2]:
    var rects: Array[Rect2] = []

    for spec in _placeholder_prop_specs():
        rects.append(_placeholder_screen_rect(spec))

    for spec in _placeholder_animal_specs():
        rects.append(_placeholder_screen_rect(spec))

    return rects


func _placeholder_screen_rect(spec: Dictionary) -> Rect2:
    var cell := _placeholder_cell(spec)
    var size_world := spec.get("size", Vector2(32.0, 32.0)) as Vector2
    var bottom_offset := float(spec.get("bottom_offset", 0.0))
    var left := _world_to_screen(Vector2(cell * _cell_size, 0.0)).x
    var bottom := _field_baseline() - (bottom_offset * _zoom())
    var size_screen := size_world * _zoom()

    return Rect2(Vector2(left, bottom - size_screen.y), size_screen)


func _placeholder_cell(spec: Dictionary) -> float:
    var start_cell := float(spec.get("cell", 0.0))
    var range_cells := float(spec.get("range_cells", 0.0))
    if range_cells <= 0.0:
        return start_cell

    var speed := float(spec.get("speed_cells_per_second", 0.35))
    var phase := float(spec.get("phase", 0.0))
    var progress := fposmod((_animal_motion_time * speed) + phase, range_cells)

    return start_cell + progress


func _placeholder_animal_source(spec: Dictionary) -> Rect2:
    var frames := spec.get("frames", []) as Array
    if not frames.is_empty():
        var fps := float(spec.get("fps", 6.0))
        var phase := float(spec.get("phase", 0.0))
        var frame_index := floori((_animal_motion_time * fps) + phase) % frames.size()
        return frames[frame_index] as Rect2

    return spec.get("source", Rect2()) as Rect2


func _placeholder_prop_specs() -> Array[Dictionary]:
    return [
        {"cell": 2.4, "size": Vector2(64.0, 64.0), "source": Rect2(42.0, 19.0, 45.0, 45.0)},
        {"cell": 7.2, "size": Vector2(46.0, 60.0), "source": Rect2(195.0, 29.0, 27.0, 35.0)},
        {"cell": 11.2, "size": Vector2(136.0, 64.0), "source": Rect2(453.0, 89.0, 85.0, 39.0)},
        {"cell": 23.0, "size": Vector2(126.0, 132.0), "source": Rect2(32.0, 165.0, 87.0, 91.0)},
        {"cell": 49.0, "size": Vector2(96.0, 132.0), "source": Rect2(704.0, 230.0, 64.0, 90.0)},
        {"cell": 64.0, "size": Vector2(138.0, 72.0), "source": Rect2(387.0, 320.0, 90.0, 28.0)},
        {"cell": 90.0, "size": Vector2(70.0, 74.0), "source": Rect2(42.0, 19.0, 45.0, 45.0)},
        {"cell": 112.0, "size": Vector2(158.0, 182.0), "source": Rect2(693.0, 471.0, 120.0, 138.0)},
        {"cell": 146.0, "size": Vector2(174.0, 184.0), "source": Rect2(832.0, 447.0, 153.0, 162.0)},
        {"cell": 178.0, "size": Vector2(100.0, 68.0), "source": Rect2(254.0, 95.0, 68.0, 33.0)},
    ]


func _placeholder_animal_specs() -> Array[Dictionary]:
    return [
        {"cell": 5.0, "range_cells": 34.0, "speed_cells_per_second": 0.85, "phase": 3.0, "fps": 12.0, "size": Vector2(60.0, 52.0), "bottom_offset": 64.0, "texture": _mini_bird_texture, "frames": [Rect2(3.0, 22.0, 10.0, 6.0), Rect2(19.0, 22.0, 10.0, 9.0), Rect2(35.0, 22.0, 10.0, 8.0), Rect2(51.0, 22.0, 10.0, 6.0)]},
        {"cell": 14.0, "range_cells": 28.0, "speed_cells_per_second": 0.54, "phase": 6.0, "fps": 10.0, "size": Vector2(88.0, 62.0), "texture": _mini_bunny_texture, "frames": [Rect2(10.0, 23.0, 12.0, 8.0), Rect2(42.0, 23.0, 12.0, 8.0), Rect2(74.0, 24.0, 12.0, 7.0), Rect2(106.0, 23.0, 12.0, 8.0)]},
        {"cell": 33.5, "range_cells": 34.0, "speed_cells_per_second": 0.48, "phase": 18.0, "fps": 10.0, "size": Vector2(112.0, 75.0), "texture": _mini_fox_texture, "frames": [Rect2(6.0, 51.0, 18.0, 12.0), Rect2(37.0, 51.0, 19.0, 11.0), Rect2(70.0, 52.0, 18.0, 11.0), Rect2(103.0, 53.0, 17.0, 10.0)]},
        {"cell": 57.0, "range_cells": 32.0, "speed_cells_per_second": 0.38, "phase": 10.0, "fps": 9.0, "size": Vector2(114.0, 70.0), "texture": _mini_boar_texture, "frames": [Rect2(7.0, 52.0, 18.0, 11.0), Rect2(39.0, 52.0, 18.0, 11.0), Rect2(72.0, 53.0, 17.0, 10.0), Rect2(103.0, 54.0, 18.0, 9.0)]},
        {"cell": 82.0, "range_cells": 30.0, "speed_cells_per_second": 0.30, "phase": 16.0, "fps": 9.0, "size": Vector2(88.0, 104.0), "texture": _mini_deer_1_texture, "frames": [Rect2(9.0, 48.0, 14.0, 15.0), Rect2(37.0, 48.0, 19.0, 13.0), Rect2(72.0, 49.0, 16.0, 14.0), Rect2(104.0, 50.0, 15.0, 13.0)]},
        {"cell": 111.0, "range_cells": 34.0, "speed_cells_per_second": 0.32, "phase": 24.0, "fps": 9.0, "size": Vector2(96.0, 110.0), "texture": _mini_deer_2_texture, "frames": [Rect2(9.0, 44.0, 15.0, 19.0), Rect2(37.0, 45.0, 19.0, 16.0), Rect2(72.0, 46.0, 16.0, 17.0), Rect2(104.0, 47.0, 16.0, 16.0)]},
        {"cell": 140.0, "range_cells": 38.0, "speed_cells_per_second": 0.44, "phase": 14.0, "fps": 10.0, "size": Vector2(124.0, 76.0), "texture": _mini_wolf_texture, "frames": [Rect2(6.0, 51.0, 20.0, 12.0), Rect2(38.0, 50.0, 20.0, 12.0), Rect2(69.0, 51.0, 21.0, 10.0), Rect2(102.0, 52.0, 20.0, 11.0)]},
        {"cell": 172.0, "range_cells": 20.0, "speed_cells_per_second": 0.26, "phase": 8.0, "fps": 8.0, "size": Vector2(140.0, 78.0), "texture": _mini_bear_texture, "frames": [Rect2(5.0, 50.0, 22.0, 13.0), Rect2(34.0, 51.0, 25.0, 12.0), Rect2(65.0, 51.0, 28.0, 10.0), Rect2(99.0, 52.0, 24.0, 11.0), Rect2(133.0, 52.0, 22.0, 11.0), Rect2(165.0, 50.0, 22.0, 13.0)]},
    ]


func _is_rect_visible(rect: Rect2) -> bool:
    return rect.end.x >= 0.0 and rect.position.x <= size.x and rect.end.y >= 0.0 and rect.position.y <= size.y


func _draw_move_mode_cells() -> void:
    if not _move_mode:
        return

    var moving_instance := _instance_by_id.get(_moving_instance_id, {}) as Dictionary
    if moving_instance.is_empty():
        return

    var moving_type_id := str(moving_instance.get("type", ""))
    var start_cell := maxi(0, floori(_camera_x / _cell_size))
    var end_cell := mini(_total_cells - 1, ceili((_camera_x + _visible_world_width()) / _cell_size) + 1)

    for cell in range(start_cell, end_cell + 1):
        var zone := _zone_for_cell(cell)
        if zone.is_empty() or not _zone_allows_type(zone, moving_type_id):
            continue

        var occupied := _is_cell_occupied(cell, _moving_instance_id)
        var color := Color(0.78, 0.12, 0.06, 0.80) if occupied else Color(0.46, 0.46, 0.46, 0.80)
        _draw_cell_marker(cell, color)

    var candidate_start := _candidate_start_cell()
    if candidate_start < 0:
        return

    var valid := _can_place_instance_at(_moving_instance_id, candidate_start)
    var footprint_color := Color(0.42, 0.92, 0.24, 0.82) if valid else Color(0.94, 0.12, 0.04, 0.82)
    var footprint_cells := _instance_cell_count(moving_instance)
    for cell in range(candidate_start, candidate_start + footprint_cells):
        if cell >= 0 and cell < _total_cells:
            _draw_cell_marker(cell, footprint_color, 2.0)


func _draw_cell_marker(cell: int, color: Color, outline_width := 1.0) -> void:
    var rect := _cell_screen_rect(cell).grow(-1.0 * _zoom())
    draw_rect(rect, color, true)
    draw_rect(rect, color.lightened(0.30), false, maxf(1.0, outline_width * _zoom()))


func _draw_building_instance(instance: Dictionary) -> void:
    var instance_id := str(instance.get("id", ""))
    var type_data := _building_type(instance)
    if type_data.is_empty():
        return

    var rect := _building_screen_rect(instance)
    var selected := instance_id == _selected_object_id
    var color := _type_color(type_data)

    if selected and not _move_mode:
        draw_rect(rect.grow(7.0 * _zoom()), Color(1.0, 0.87, 0.40, 0.24), true)
        draw_rect(rect.grow(7.0 * _zoom()), Color(1.0, 0.80, 0.25, 0.95), false, maxf(2.0, 3.0 * _zoom()))

    _draw_building_shape(rect, type_data, color, false)


func _draw_moving_building() -> void:
    if not _move_mode:
        return

    var instance := _instance_by_id.get(_moving_instance_id, {}) as Dictionary
    if instance.is_empty():
        return

    var candidate_start := _candidate_start_cell()
    if candidate_start < 0:
        candidate_start = _instance_world_cell(instance)

    var type_data := _building_type(instance)
    var rect := _building_screen_rect(instance, candidate_start)
    _draw_building_shape(rect, type_data, Color(1.0, 1.0, 1.0, 0.86), true)


func _draw_building_shape(rect: Rect2, type_data: Dictionary, color: Color, ghost := false) -> void:
    match str(type_data.get("shape", "")):
        "asset_prop":
            _draw_asset_prop_building(rect, type_data, ghost)
        "gate":
            _draw_gate(rect, color, ghost)
        "town_hall":
            _draw_town_hall(rect, color, ghost)
        "fountain":
            _draw_fountain(rect, color, ghost)
        "trash_bin":
            _draw_trash_bin(rect, color, ghost)
        _:
            draw_rect(rect, color, true)
            draw_rect(rect, Color(0.12, 0.10, 0.08, color.a), false, maxf(1.0, 2.0 * _zoom()))


func _draw_asset_prop_building(rect: Rect2, type_data: Dictionary, ghost: bool) -> void:
    var source := _rect_from_array(type_data.get("asset_source", []), Rect2())
    if source.size.x <= 0.0 or source.size.y <= 0.0 or _village_props_texture == null:
        draw_rect(rect, _type_color(type_data), true)
        draw_rect(rect, Color(0.12, 0.10, 0.08, 1.0), false, maxf(1.0, 2.0 * _zoom()))
        return

    var source_aspect := source.size.x / source.size.y
    var target_size := Vector2(rect.size.x, rect.size.x / source_aspect)
    if target_size.y > rect.size.y:
        target_size = Vector2(rect.size.y * source_aspect, rect.size.y)

    var target := Rect2(
        Vector2(rect.position.x + ((rect.size.x - target_size.x) * 0.5), rect.end.y - target_size.y),
        target_size
    )
    var tint := Color(1.0, 1.0, 1.0, 0.88) if ghost else Color(1.0, 1.0, 1.0, 0.98)

    draw_texture_rect_region(_village_props_texture, target, source, tint)

    if ghost:
        draw_rect(target, Color(1.0, 1.0, 1.0, 0.46), true)
        draw_rect(target, Color(1.0, 1.0, 1.0, 0.90), false, maxf(1.0, 2.0 * _zoom()))


func _draw_gate(rect: Rect2, color: Color, ghost: bool) -> void:
    var outline := Color(0.18, 0.16, 0.14, color.a)
    var tower_width := rect.size.x * 0.30
    draw_rect(Rect2(rect.position + Vector2(rect.size.x * 0.08, rect.size.y * 0.18), Vector2(tower_width, rect.size.y * 0.82)), color, true)
    draw_rect(Rect2(rect.position + Vector2(rect.size.x * 0.62, rect.size.y * 0.18), Vector2(tower_width, rect.size.y * 0.82)), color.darkened(0.08), true)
    draw_rect(Rect2(rect.position + Vector2(rect.size.x * 0.22, rect.size.y * 0.42), Vector2(rect.size.x * 0.56, rect.size.y * 0.58)), color.darkened(0.12), true)
    draw_rect(Rect2(rect.position + Vector2(rect.size.x * 0.40, rect.size.y * 0.64), Vector2(rect.size.x * 0.20, rect.size.y * 0.36)), Color(0.08, 0.07, 0.06, color.a), true)
    draw_rect(rect, outline, false, maxf(1.0, 2.0 * _zoom()))

    if ghost:
        draw_rect(rect, Color(1.0, 1.0, 1.0, 0.24), true)


func _draw_town_hall(rect: Rect2, color: Color, ghost: bool) -> void:
    var body := Rect2(rect.position + Vector2(0.0, rect.size.y * 0.35), Vector2(rect.size.x, rect.size.y * 0.65))
    var roof := PackedVector2Array([
        rect.position + Vector2(-8.0 * _zoom(), rect.size.y * 0.38),
        rect.position + Vector2(rect.size.x * 0.50, 0.0),
        rect.position + Vector2(rect.size.x + 8.0 * _zoom(), rect.size.y * 0.38),
    ])
    draw_colored_polygon(roof, color.darkened(0.18))
    draw_rect(body, color, true)
    draw_rect(Rect2(body.position + Vector2(body.size.x * 0.42, body.size.y * 0.48), Vector2(body.size.x * 0.16, body.size.y * 0.52)), Color(0.13, 0.09, 0.07, color.a), true)

    for i in 3:
        var window_x := body.position.x + body.size.x * (0.18 + float(i) * 0.28)
        draw_rect(Rect2(Vector2(window_x, body.position.y + body.size.y * 0.22), Vector2(12.0, 16.0) * _zoom()), Color(0.98, 0.84, 0.48, color.a), true)

    draw_rect(rect, Color(0.20, 0.12, 0.08, color.a), false, maxf(1.0, 2.0 * _zoom()))

    if ghost:
        draw_rect(rect, Color(1.0, 1.0, 1.0, 0.22), true)


func _draw_fountain(rect: Rect2, color: Color, ghost: bool) -> void:
    var basin := Rect2(rect.position + Vector2(rect.size.x * 0.08, rect.size.y * 0.62), Vector2(rect.size.x * 0.84, rect.size.y * 0.28))
    draw_rect(basin, color.darkened(0.12), true)
    draw_rect(basin, Color(0.18, 0.22, 0.24, color.a), false, maxf(1.0, 2.0 * _zoom()))
    draw_circle(rect.position + Vector2(rect.size.x * 0.50, rect.size.y * 0.50), rect.size.y * 0.22, Color(0.42, 0.72, 0.92, color.a))
    draw_circle(rect.position + Vector2(rect.size.x * 0.50, rect.size.y * 0.32), rect.size.y * 0.10, Color(0.62, 0.86, 0.98, color.a))
    draw_line(rect.position + Vector2(rect.size.x * 0.50, rect.size.y * 0.24), rect.position + Vector2(rect.size.x * 0.50, rect.size.y * 0.68), Color(0.68, 0.88, 1.0, color.a), maxf(1.0, 3.0 * _zoom()))

    if ghost:
        draw_rect(rect, Color(1.0, 1.0, 1.0, 0.22), true)


func _draw_trash_bin(rect: Rect2, color: Color, ghost: bool) -> void:
    var bin_rect := Rect2(rect.position + Vector2(rect.size.x * 0.22, rect.size.y * 0.22), Vector2(rect.size.x * 0.56, rect.size.y * 0.72))
    draw_rect(bin_rect, color, true)
    draw_rect(Rect2(bin_rect.position + Vector2(-2.0 * _zoom(), -6.0 * _zoom()), Vector2(bin_rect.size.x + 4.0 * _zoom(), 6.0 * _zoom())), color.lightened(0.18), true)
    draw_line(bin_rect.position + Vector2(bin_rect.size.x * 0.34, 6.0 * _zoom()), bin_rect.position + Vector2(bin_rect.size.x * 0.34, bin_rect.size.y - 4.0 * _zoom()), Color(0.10, 0.13, 0.12, color.a), maxf(1.0, 1.5 * _zoom()))
    draw_line(bin_rect.position + Vector2(bin_rect.size.x * 0.66, 6.0 * _zoom()), bin_rect.position + Vector2(bin_rect.size.x * 0.66, bin_rect.size.y - 4.0 * _zoom()), Color(0.10, 0.13, 0.12, color.a), maxf(1.0, 1.5 * _zoom()))
    draw_rect(bin_rect, Color(0.08, 0.09, 0.08, color.a), false, maxf(1.0, 2.0 * _zoom()))

    if ghost:
        draw_rect(rect, Color(1.0, 1.0, 1.0, 0.24), true)


func _draw_selected_panel() -> void:
    if _selected_object_id.is_empty():
        return

    var instance := _instance_by_id.get(_selected_object_id, {}) as Dictionary
    if instance.is_empty():
        return

    var type_data := _building_type(instance)
    var rect := _building_screen_rect(instance)
    var scale := _ui_scale()
    var panel_size := Vector2(180.0, 56.0) * scale
    var panel_pos := Vector2(rect.get_center().x - panel_size.x * 0.5, rect.position.y - panel_size.y - (12.0 * scale))
    panel_pos.x = clampf(panel_pos.x, 8.0 * scale, maxf(8.0 * scale, size.x - panel_size.x - (8.0 * scale)))
    panel_pos.y = maxf(54.0 * scale, panel_pos.y)

    var panel_rect := Rect2(panel_pos, panel_size)
    draw_rect(panel_rect, Color(0.13, 0.16, 0.14, 0.94), true)
    draw_rect(panel_rect, Color(0.58, 0.72, 0.56, 1.0), false, 2.0)

    var font := get_theme_default_font()
    var hint := "fixed" if _is_instance_fixed(instance) else "click to move"
    draw_string(font, panel_pos + (Vector2(12.0, 22.0) * scale), str(type_data.get("name", instance.get("id", ""))), HORIZONTAL_ALIGNMENT_LEFT, -1.0, _scaled_int(14), Color(0.93, 0.96, 0.90, 1.0))
    draw_string(font, panel_pos + (Vector2(12.0, 42.0) * scale), hint, HORIZONTAL_ALIGNMENT_LEFT, -1.0, _scaled_int(12), Color(0.70, 0.79, 0.68, 1.0))


func _handle_click(position: Vector2) -> void:
    if _move_mode:
        var candidate_start := _candidate_start_cell()
        if candidate_start >= 0 and _can_place_instance_at(_moving_instance_id, candidate_start):
            _place_moving_instance(candidate_start)
        else:
            _last_event = "blocked placement"

        _update_status()
        queue_redraw()
        return

    for instance in _building_instances:
        if _building_screen_rect(instance).has_point(position):
            var instance_id := str(instance.get("id", ""))
            var type_data := _building_type(instance)
            _selected_object_id = instance_id

            if _is_instance_fixed(instance):
                _last_event = "selected fixed %s" % type_data.get("name", instance_id)
            else:
                _start_move_mode(instance_id, position)

            _update_status()
            queue_redraw()
            return

    _selected_object_id = ""
    _last_event = "empty click"
    _update_status()
    queue_redraw()


func _pan(direction: float) -> void:
    var previous := _camera_x
    _camera_x = _clamped_camera_x(_camera_x + (direction * _pan_speed / _zoom()))
    _last_event = "pan edge" if is_equal_approx(previous, _camera_x) else "pan"
    _apply_mouse_passthrough()
    _update_status()
    queue_redraw()


func _set_zoom_index(value: int) -> void:
    var previous := _zoom_index
    var center_world := _camera_x + (_visible_world_width() * 0.5)
    _zoom_index = clampi(value, 0, ZOOM_LEVELS.size() - 1)
    _camera_x = _clamped_camera_x(center_world - (_visible_world_width() * 0.5))
    _last_event = "zoom edge" if previous == _zoom_index else "zoom %s" % ZOOM_LABELS[_zoom_index]
    _apply_mouse_passthrough()
    _update_settings_values()
    _update_status()
    queue_redraw()

    if previous != _zoom_index:
        _save_settings()


func _set_controls_scale_index(value: int) -> void:
    var previous := _controls_scale_index
    _controls_scale_index = clampi(value, 0, ZOOM_LEVELS.size() - 1)
    _last_event = "controls edge" if previous == _controls_scale_index else "controls %s" % ZOOM_LABELS[_controls_scale_index]
    _apply_controls_scale()
    _apply_mouse_passthrough()
    _update_settings_values()
    _update_status()
    queue_redraw()

    if previous != _controls_scale_index:
        _save_settings()

    if _settings_window != null and _settings_window.visible:
        _center_settings_window_on_screen()


func _start_move_mode(instance_id: String, pointer_position: Vector2) -> void:
    var instance := _instance_by_id.get(instance_id, {}) as Dictionary
    if instance.is_empty() or _is_instance_fixed(instance):
        return

    var pointer_cell := _cell_at_screen_position(pointer_position)
    var instance_start := _instance_world_cell(instance)
    _move_grab_cell_offset = clampi(pointer_cell - instance_start, 0, maxi(_instance_cell_count(instance) - 1, 0))
    _moving_instance_id = instance_id
    _move_mode = true
    _hover_cell_index = pointer_cell
    _selected_object_id = instance_id
    _last_event = "moving %s" % _building_type(instance).get("name", instance_id)
    _apply_mouse_passthrough()


func _cancel_move_mode() -> void:
    if not _move_mode:
        return

    _move_mode = false
    _moving_instance_id = ""
    _move_grab_cell_offset = 0
    _hover_cell_index = -1
    _last_event = "move cancelled"
    _apply_mouse_passthrough()
    _update_status()
    queue_redraw()


func _place_moving_instance(candidate_start: int) -> void:
    var instance := _instance_by_id.get(_moving_instance_id, {}) as Dictionary
    if instance.is_empty():
        _cancel_move_mode()
        return

    var target_zone := _zone_for_cell(candidate_start)
    instance["zone"] = str(target_zone.get("id", ""))
    instance["cell"] = candidate_start - int(target_zone.get("start_cell", 0))
    _move_mode = false
    _moving_instance_id = ""
    _move_grab_cell_offset = 0
    _last_event = "placed %s" % _building_type(instance).get("name", instance.get("id", ""))
    _apply_mouse_passthrough()


func _reset_camera() -> void:
    _camera_x = _clamped_camera_x((_world_width() - _visible_world_width()) * 0.5)
    _selected_object_id = ""
    _move_mode = false
    _moving_instance_id = ""
    _last_event = "camera reset"
    _apply_mouse_passthrough()
    _update_status()
    queue_redraw()


func _toggle_field_hidden() -> void:
    _field_hidden = not _field_hidden

    if _field_hidden:
        _selected_object_id = ""
        _move_mode = false
        _moving_instance_id = ""
        _move_grab_cell_offset = 0
        _last_event = "field hidden"

        if _settings_window != null and _settings_window.visible:
            _settings_window.hide()
    else:
        _last_event = "field shown"

    _apply_controls_scale()
    _apply_mouse_passthrough()
    _update_performance_hud()
    _update_status()
    queue_redraw()


func _show_settings() -> void:
    if _field_hidden:
        return

    _update_screen_options()
    _update_settings_values()
    _center_settings_window_on_screen()


func _center_settings_window_on_screen() -> void:
    if _settings_window == null:
        return

    var window_size := _settings_window_size()
    var usable_rect := DisplayServer.screen_get_usable_rect(_target_screen)
    _settings_window.size = window_size
    _settings_window.min_size = Vector2i(360, mini(420, window_size.y))
    _settings_window.current_screen = _target_screen

    if usable_rect.size.x > 0 and usable_rect.size.y > 0:
        _settings_window.position = usable_rect.position + Vector2i(
            (usable_rect.size.x - window_size.x) / 2,
            (usable_rect.size.y - window_size.y) / 2
        )

    _settings_window.popup()
    print("settings_window_size=%s" % _settings_window.size)
    print("settings_window_position=%s" % _settings_window.position)


func _on_screen_selected(index: int) -> void:
    _target_screen = index
    _apply_window_settings()


func _on_companion_toggled(enabled: bool) -> void:
    _companion_mode = enabled
    _apply_window_settings()


func _on_always_on_top_toggled(enabled: bool) -> void:
    _always_on_top = enabled
    _apply_window_settings()


func _on_transparent_toggled(enabled: bool) -> void:
    _transparent_window = enabled
    _apply_window_settings()


func _on_click_through_toggled(enabled: bool) -> void:
    _click_through_empty = enabled
    _last_event = "click-through %s" % ("on" if enabled else "off")
    _apply_mouse_passthrough()
    _update_status()


func _on_performance_toggled(enabled: bool) -> void:
    _show_performance_hud = enabled
    _last_event = "perf hud %s" % ("on" if enabled else "off")
    _apply_controls_scale()
    _update_performance_hud()
    _apply_mouse_passthrough()
    _update_settings_values()
    _update_status()
    _save_settings()


func _on_zoom_selected(index: int) -> void:
    _set_zoom_index(index)


func _on_controls_scale_selected(index: int) -> void:
    _set_controls_scale_index(index)


func _on_pan_speed_changed(value: float) -> void:
    _pan_speed = value
    _update_settings_values()
    _update_status()


func _update_screen_options() -> void:
    if _screen_option == null:
        return

    _screen_option.clear()

    var screen_count: int = maxi(DisplayServer.get_screen_count(), 1)
    for screen_index in screen_count:
        var rect := DisplayServer.screen_get_usable_rect(screen_index)
        var display_scale := DisplayServer.screen_get_scale(screen_index)
        _screen_option.add_item("Display %d | scale %.1f | %s" % [screen_index, display_scale, rect], screen_index)

    _target_screen = clampi(_target_screen, 0, screen_count - 1)
    _screen_option.select(_target_screen)


func _update_settings_values() -> void:
    if _zoom_option == null:
        return

    _companion_check.button_pressed = _companion_mode
    _always_on_top_check.button_pressed = _always_on_top
    _transparent_check.button_pressed = _transparent_window
    _click_through_check.button_pressed = _click_through_empty
    _performance_check.button_pressed = _show_performance_hud
    _zoom_option.select(_zoom_index)
    _controls_scale_option.select(_controls_scale_index)
    _pan_label.text = "Pan speed %.0f" % _pan_speed
    var screen_scale := DisplayServer.screen_get_scale(_target_screen)
    var screen_dpi := DisplayServer.screen_get_dpi(_target_screen)
    _screen_label.text = "Screens: %d | display scale %.1f | dpi %.0f" % [
        DisplayServer.get_screen_count(),
        screen_scale,
        screen_dpi,
    ]


func _update_status() -> void:
    if _status_label == null:
        return

    _status_label.text = "game %s | controls %s | camera %.0f/%.0f | %s" % [
        ZOOM_LABELS[_zoom_index],
        ZOOM_LABELS[_controls_scale_index],
        _camera_x,
        _max_camera_x(),
        _last_event,
    ]


func _update_performance_hud() -> void:
    if _performance_label == null:
        return

    _performance_label.visible = _show_performance_hud and not _field_hidden
    if not _performance_label.visible:
        return

    var fps := Performance.get_monitor(Performance.TIME_FPS)
    var frame_ms := Performance.get_monitor(Performance.TIME_PROCESS) * 1000.0
    var physics_ms := Performance.get_monitor(Performance.TIME_PHYSICS_PROCESS) * 1000.0
    var memory_mb := _bytes_to_mib(Performance.get_monitor(Performance.MEMORY_STATIC))
    var vram_mb := _bytes_to_mib(Performance.get_monitor(Performance.RENDER_VIDEO_MEM_USED))
    var texture_mb := _bytes_to_mib(Performance.get_monitor(Performance.RENDER_TEXTURE_MEM_USED))
    var draw_calls := Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME)
    var objects := Performance.get_monitor(Performance.OBJECT_COUNT)
    var nodes := Performance.get_monitor(Performance.OBJECT_NODE_COUNT)

    _performance_label.text = "FPS %.0f | frame %.2f ms | physics %.2f ms\nmem %s | vram %s | tex %s\ndraw %.0f | obj %.0f | nodes %.0f" % [
        fps,
        frame_ms,
        physics_ms,
        memory_mb,
        vram_mb,
        texture_mb,
        draw_calls,
        objects,
        nodes,
    ]


func _bytes_to_mib(bytes: float) -> String:
    return "%.1f MB" % (bytes / 1048576.0)


func _can_place_instance_at(instance_id: String, start_cell: int) -> bool:
    var instance := _instance_by_id.get(instance_id, {}) as Dictionary
    if instance.is_empty():
        return false

    var type_data := _building_type(instance)
    var target_zone := _zone_for_cell(start_cell)
    var footprint_cells := _instance_cell_count(instance)

    if target_zone.is_empty() or not _zone_allows_type(target_zone, str(instance.get("type", ""))):
        return false

    if start_cell < int(target_zone.get("start_cell", 0)):
        return false

    if start_cell + footprint_cells - 1 > int(target_zone.get("end_cell", -1)):
        return false

    for cell in range(start_cell, start_cell + footprint_cells):
        if _is_cell_occupied(cell, instance_id):
            return false

    return not type_data.is_empty()


func _candidate_start_cell() -> int:
    if _hover_cell_index < 0:
        return -1

    return clampi(_hover_cell_index - _move_grab_cell_offset, 0, maxi(_total_cells - 1, 0))


func _is_cell_occupied(cell: int, ignored_instance_id := "") -> bool:
    for instance in _building_instances:
        if str(instance.get("id", "")) == ignored_instance_id:
            continue

        var start_cell := _instance_world_cell(instance)
        var end_cell := start_cell + _instance_cell_count(instance) - 1
        if cell >= start_cell and cell <= end_cell:
            return true

    return false


func _building_screen_rect(instance: Dictionary, override_start_cell := -1) -> Rect2:
    var type_data := _building_type(instance)
    var start_cell := override_start_cell if override_start_cell >= 0 else _instance_world_cell(instance)
    var width := float(_instance_cell_count(instance)) * _cell_size
    var height := float(type_data.get("height", 72.0))
    var top_left := _world_to_screen(Vector2(float(start_cell) * _cell_size, height))

    return Rect2(top_left, Vector2(width, height) * _zoom())


func _cell_screen_rect(cell: int) -> Rect2:
    var screen_x := _world_to_screen(Vector2(float(cell) * _cell_size, 0.0)).x
    var top_left := Vector2(screen_x, _field_baseline() + (CELL_OVERLAY_TOP_OFFSET * _zoom()))
    return Rect2(top_left, Vector2(_cell_size, CELL_OVERLAY_HEIGHT) * _zoom())


func _cell_at_screen_position(position: Vector2) -> int:
    var world_x := (position.x / _zoom()) + _camera_x
    return clampi(floori(world_x / _cell_size), 0, maxi(_total_cells - 1, 0))


func _instance_world_cell(instance: Dictionary) -> int:
    var zone_id := str(instance.get("zone", ""))
    var zone := _zone_by_id.get(zone_id, {}) as Dictionary
    return int(zone.get("start_cell", 0)) + int(instance.get("cell", 0))


func _instance_cell_count(instance: Dictionary) -> int:
    return int(_building_type(instance).get("cells", 1))


func _is_instance_fixed(instance: Dictionary) -> bool:
    if bool(instance.get("fixed", false)):
        return true

    return bool(_building_type(instance).get("fixed", false))


func _building_type(instance: Dictionary) -> Dictionary:
    return _building_types.get(str(instance.get("type", "")), {}) as Dictionary


func _type_color(type_data: Dictionary) -> Color:
    return _color_from_array(type_data.get("color", [1.0, 1.0, 1.0, 1.0]), Color(1.0, 1.0, 1.0, 1.0))


func _zone_for_cell(cell: int) -> Dictionary:
    for zone in _zones:
        if cell >= int(zone.get("start_cell", 0)) and cell <= int(zone.get("end_cell", -1)):
            return zone

    return {}


func _zone_allows_type(zone: Dictionary, type_id: String) -> bool:
    if not bool(zone.get("buildable", false)):
        return false

    var type_data := _building_types.get(type_id, {}) as Dictionary
    var allowed_zones: Array = type_data.get("allowed_zones", [])
    return allowed_zones.has(str(zone.get("id", "")))


func _zone_unlocked_cells(zone: Dictionary) -> int:
    return int(zone.get("unlocked_cells", zone.get("cells", zone.get("base_cells", 0))))


func _zone_ground_color(zone: Dictionary) -> Color:
    return _color_from_array(zone.get("ground_color", [0.52, 0.42, 0.28, 1.0]), Color(0.52, 0.42, 0.28, 1.0))


func _zone_asset_tint(zone: Dictionary) -> Color:
    match str(zone.get("id", "")):
        "city":
            return Color(0.82, 0.82, 0.86, 1.0)
        "backyard_gate", "city_gate":
            return Color(1.02, 0.96, 0.82, 1.0)
        "countryside", "backyard":
            return Color(1.0, 0.94, 0.82, 1.0)
        _:
            return Color(1.0, 1.0, 1.0, 1.0)


func _rect_from_array(value: Variant, fallback: Rect2) -> Rect2:
    if typeof(value) != TYPE_ARRAY:
        return fallback

    var values := value as Array
    if values.size() < 4:
        return fallback

    return Rect2(
        Vector2(float(values[0]), float(values[1])),
        Vector2(float(values[2]), float(values[3]))
    )


func _color_from_array(value: Variant, fallback: Color) -> Color:
    if typeof(value) != TYPE_ARRAY:
        return fallback

    var channels := value as Array
    if channels.size() < 3:
        return fallback

    var alpha := float(channels[3]) if channels.size() >= 4 else fallback.a
    return Color(float(channels[0]), float(channels[1]), float(channels[2]), alpha)


func _world_to_screen(world_position: Vector2) -> Vector2:
    return Vector2(
        (world_position.x - _camera_x) * _zoom(),
        _field_baseline() - (world_position.y * _zoom())
    )


func _field_baseline() -> float:
    return maxf(size.y - (GROUND_DIRT_HEIGHT * _zoom()), 96.0)


func _visible_world_width() -> float:
    return size.x / _zoom()


func _max_camera_x() -> float:
    return maxf(_world_width() - _visible_world_width(), 0.0)


func _clamped_camera_x(value: float) -> float:
    return clampf(value, 0.0, _max_camera_x())


func _zoom() -> float:
    return ZOOM_LEVELS[_zoom_index]


func _ui_scale() -> float:
    return ZOOM_LEVELS[_controls_scale_index]


func _world_width() -> float:
    return float(_total_cells) * _cell_size
