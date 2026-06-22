class_name DesktopWindowProbe
extends Control

const WINDOW_ID := DisplayServer.MAIN_WINDOW_ID
const DEFAULT_SIZE := Vector2i(960, 360)
const COMPANION_SIZE := Vector2i(960, 160)
const MIN_SIZE := Vector2i(480, 120)

@onready var _probe_panel: Control = %ProbePanel
@onready var _report_label: Label = %ReportLabel

var _auto_quit := false
var _auto_quit_seconds := 0.5
var _always_on_top := true
var _borderless := false
var _transparent := true
var _no_focus := false
var _whole_window_mouse_passthrough := false
var _interactive_polygon := false
var _interactive_polygon_points := 0
var _companion_layout := false


func _ready() -> void:
    _read_user_args()
    _apply_window_settings()

    await get_tree().process_frame

    if _interactive_polygon:
        _apply_interactive_polygon()

    await get_tree().create_timer(0.1).timeout

    var report := _build_report()
    _report_label.text = "\n".join(report)

    for line in report:
        print(line)

    if _auto_quit:
        await get_tree().create_timer(_auto_quit_seconds).timeout
        get_tree().quit(0)


func _read_user_args() -> void:
    for arg in OS.get_cmdline_user_args():
        if arg == "--spike-auto-quit":
            _auto_quit = true
        elif arg.begins_with("--spike-seconds="):
            _auto_quit_seconds = maxf(arg.replace("--spike-seconds=", "").to_float(), 0.1)
        elif arg == "--spike-companion":
            _companion_layout = true
        elif arg == "--spike-borderless":
            _borderless = true
        elif arg == "--spike-no-focus":
            _no_focus = true
        elif arg == "--spike-no-always-on-top":
            _always_on_top = false
        elif arg == "--spike-no-transparent":
            _transparent = false
        elif arg == "--spike-mouse-passthrough":
            _whole_window_mouse_passthrough = true
        elif arg == "--spike-interactive-polygon":
            _interactive_polygon = true


func _apply_window_settings() -> void:
    var target_size := COMPANION_SIZE if _companion_layout else DEFAULT_SIZE
    var screen := DisplayServer.window_get_current_screen(WINDOW_ID)
    var usable_rect := DisplayServer.screen_get_usable_rect(screen)

    get_viewport().transparent_bg = _transparent

    DisplayServer.window_set_title("Shelter Window Spike", WINDOW_ID)
    DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED, WINDOW_ID)
    DisplayServer.window_set_min_size(MIN_SIZE, WINDOW_ID)
    DisplayServer.window_set_size(target_size, WINDOW_ID)
    DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED, WINDOW_ID)
    DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_ALWAYS_ON_TOP, _always_on_top, WINDOW_ID)
    DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, _borderless, WINDOW_ID)
    DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_TRANSPARENT, _transparent, WINDOW_ID)
    DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_NO_FOCUS, _no_focus, WINDOW_ID)
    DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_MOUSE_PASSTHROUGH, _whole_window_mouse_passthrough, WINDOW_ID)

    if _companion_layout and usable_rect.size.x > 0 and usable_rect.size.y > 0:
        var bottom_left := Vector2i(
            usable_rect.position.x + 48,
            usable_rect.position.y + usable_rect.size.y - target_size.y - 64
        )
        DisplayServer.window_set_position(bottom_left, WINDOW_ID)


func _apply_interactive_polygon() -> void:
    var panel_rect := Rect2i(
        Vector2i(_probe_panel.global_position.round()),
        Vector2i(_probe_panel.size.round())
    )
    var polygon := PackedVector2Array([
        panel_rect.position,
        Vector2i(panel_rect.position.x + panel_rect.size.x, panel_rect.position.y),
        panel_rect.position + panel_rect.size,
        Vector2i(panel_rect.position.x, panel_rect.position.y + panel_rect.size.y),
    ])

    DisplayServer.window_set_mouse_passthrough(polygon, WINDOW_ID)
    _interactive_polygon_points = polygon.size()


func _build_report() -> Array[String]:
    var screen := DisplayServer.window_get_current_screen(WINDOW_ID)
    var lines: Array[String] = []

    lines.append("display_server=%s" % DisplayServer.get_name())
    lines.append("os=%s" % OS.get_name())
    lines.append("window_transparency_feature=%s" % DisplayServer.has_feature(DisplayServer.FEATURE_WINDOW_TRANSPARENCY))
    lines.append("window_transparency_available=%s" % DisplayServer.is_window_transparency_available())
    lines.append("project_per_pixel_transparency_allowed=%s" % ProjectSettings.get_setting("display/window/per_pixel_transparency/allowed", false))
    lines.append("project_window_size_transparent=%s" % ProjectSettings.get_setting("display/window/size/transparent", false))
    lines.append("viewport_transparent_bg=%s" % get_viewport().transparent_bg)
    lines.append("window_mode=%s" % DisplayServer.window_get_mode(WINDOW_ID))
    lines.append("window_size=%s" % DisplayServer.window_get_size(WINDOW_ID))
    lines.append("window_position=%s" % DisplayServer.window_get_position(WINDOW_ID))
    lines.append("window_can_draw=%s" % DisplayServer.window_can_draw(WINDOW_ID))
    lines.append("window_focused=%s" % DisplayServer.window_is_focused(WINDOW_ID))
    lines.append("flag_always_on_top=%s" % DisplayServer.window_get_flag(DisplayServer.WINDOW_FLAG_ALWAYS_ON_TOP, WINDOW_ID))
    lines.append("flag_borderless=%s" % DisplayServer.window_get_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, WINDOW_ID))
    lines.append("flag_transparent=%s" % DisplayServer.window_get_flag(DisplayServer.WINDOW_FLAG_TRANSPARENT, WINDOW_ID))
    lines.append("flag_no_focus=%s" % DisplayServer.window_get_flag(DisplayServer.WINDOW_FLAG_NO_FOCUS, WINDOW_ID))
    lines.append("flag_mouse_passthrough=%s" % DisplayServer.window_get_flag(DisplayServer.WINDOW_FLAG_MOUSE_PASSTHROUGH, WINDOW_ID))
    lines.append("interactive_polygon_requested=%s" % _interactive_polygon)
    lines.append("interactive_polygon_points=%s" % _interactive_polygon_points)
    lines.append("screen_count=%s" % DisplayServer.get_screen_count())
    lines.append("screen_index=%s" % screen)
    lines.append("screen_scale=%s" % DisplayServer.screen_get_scale(screen))
    lines.append("screen_dpi=%s" % DisplayServer.screen_get_dpi(screen))
    lines.append("screen_refresh_rate=%s" % DisplayServer.screen_get_refresh_rate(screen))
    lines.append("screen_usable_rect=%s" % DisplayServer.screen_get_usable_rect(screen))
    lines.append("native_window_handle=%s" % DisplayServer.window_get_native_handle(DisplayServer.WINDOW_HANDLE, WINDOW_ID))
    lines.append("native_window_view=%s" % DisplayServer.window_get_native_handle(DisplayServer.WINDOW_VIEW, WINDOW_ID))

    return lines
