class_name DogRigSpike
extends Control

const WINDOW_SIZE := Vector2i(960, 360)
const STRESS_WINDOW_SIZE := Vector2i(1180, 720)
const PIPELINE_WINDOW_SIZE := Vector2i(1180, 520)
const HYBRID_WINDOW_SIZE := Vector2i(1180, 520)
const HYBRID_COMPANION_SIZE := Vector2i(1120, 220)
const DOG_DNA_PATH := "res://resources/tech_demos/dog_dna_examples.json"
const CYCLE_SECONDS := 10.5
const AUTO_QUIT_SECONDS := 1.0
const GROUND_Y := 250.0
const STRESS_DOG_IDS := ["DOG-PROT-001", "DOG-PROT-002", "DOG-PROT-003"]

var _auto_quit := false
var _auto_quit_seconds := AUTO_QUIT_SECONDS
var _print_perf := false
var _stress_mode := false
var _pipeline_mode := false
var _hybrid_mode := false
var _hybrid_companion_mode := false
var _requested_dog_id := "DOG-PROT-001"
var _active_dog: Dictionary = {}
var _dog_by_id: Dictionary = {}
var _rigs: Array[Dictionary] = []
var _elapsed := 0.0
var _perf_elapsed := 0.0

var _status_label: Label
var _dog_label: Label
var _perf_label: Label


func _ready() -> void:
    _read_user_args()
    _load_dog_dna()

    if _hybrid_companion_mode:
        get_window().title = "Shelter Dog Rig Hybrid Companion Perf v3"
        get_window().size = HYBRID_COMPANION_SIZE
    elif _hybrid_mode:
        get_window().title = "Shelter Dog Rig Hybrid Runtime v3"
        get_window().size = HYBRID_WINDOW_SIZE
    elif _pipeline_mode:
        get_window().title = "Shelter Dog Rig Animation Pipeline Comparison v2"
        get_window().size = PIPELINE_WINDOW_SIZE
    else:
        get_window().title = "Shelter Dog Rig Morphology Stress v1" if _stress_mode else "Shelter Dog Rig Spike v0"
        get_window().size = STRESS_WINDOW_SIZE if _stress_mode else WINDOW_SIZE

    _build_scene()
    _print_start_report()
    set_process(true)

    if _auto_quit:
        await get_tree().create_timer(_auto_quit_seconds).timeout
        get_tree().quit(0)


func _process(delta: float) -> void:
    _elapsed += delta
    _perf_elapsed += delta

    for rig in _rigs:
        if str(rig.get("pipeline", "procedural")) == "hybrid":
            _update_hybrid_rig(rig, _elapsed)
        elif str(rig.get("pipeline", "procedural")) == "authored":
            _update_authored_rig(rig, _elapsed)
        else:
            _update_rig(rig, _elapsed)

    if _perf_elapsed >= 0.5:
        _perf_elapsed = 0.0
        _update_perf_label()

    queue_redraw()


func _draw() -> void:
    draw_rect(Rect2(Vector2.ZERO, size), Color(0.09, 0.105, 0.095, 1.0), true)

    if _hybrid_companion_mode:
        _draw_hybrid_companion()
    elif _hybrid_mode:
        _draw_hybrid_lanes()
    elif _pipeline_mode:
        _draw_pipeline_lanes()
    elif _stress_mode:
        _draw_stress_lanes()
        _draw_readability_preview()
    else:
        _draw_ground_band(GROUND_Y, size.x, Color(0.28, 0.24, 0.18, 1.0))
        _draw_single_preview()


func _draw_ground_band(ground_y: float, width: float, dirt_color: Color) -> void:
    draw_rect(Rect2(0.0, ground_y, width, 70.0), dirt_color, true)
    draw_rect(Rect2(0.0, ground_y - 8.0, width, 8.0), Color(0.35, 0.48, 0.28, 1.0), true)
    draw_line(Vector2(0.0, ground_y), Vector2(width, ground_y), Color(0.82, 0.72, 0.48, 1.0), 2.0)


func _draw_stress_lanes() -> void:
    for rig in _rigs:
        var ground_y := float(rig.get("ground_y", GROUND_Y))
        _draw_ground_band(ground_y, size.x, Color(0.26, 0.23, 0.18, 1.0))
        draw_line(Vector2(0.0, ground_y + 68.0), Vector2(size.x, ground_y + 68.0), Color(0.18, 0.17, 0.14, 1.0), 1.0)


func _draw_pipeline_lanes() -> void:
    for rig in _rigs:
        var ground_y := float(rig.get("ground_y", GROUND_Y))
        _draw_ground_band(ground_y, size.x, Color(0.26, 0.23, 0.18, 1.0))
        draw_line(Vector2(0.0, ground_y + 68.0), Vector2(size.x, ground_y + 68.0), Color(0.18, 0.17, 0.14, 1.0), 1.0)

    draw_line(Vector2(590.0, 96.0), Vector2(590.0, 410.0), Color(0.42, 0.36, 0.25, 0.8), 2.0)
    draw_string(ThemeDB.fallback_font, Vector2(24.0, 458.0), "Pipeline comparison: procedural runtime vs minimal AnimationPlayer-authored pose clips", HORIZONTAL_ALIGNMENT_LEFT, -1.0, 16.0, Color(0.86, 0.80, 0.68, 1.0))
    draw_string(ThemeDB.fallback_font, Vector2(24.0, 482.0), "Authored version uses clips for local pose drivers; phrase timing, DNA loading, and socket visibility still need runtime code.", HORIZONTAL_ALIGNMENT_LEFT, -1.0, 13.0, Color(0.72, 0.69, 0.60, 1.0))


func _draw_hybrid_lanes() -> void:
    for rig in _rigs:
        var ground_y := float(rig.get("ground_y", GROUND_Y))
        _draw_ground_band(ground_y, size.x, Color(0.26, 0.23, 0.18, 1.0))
        draw_line(Vector2(0.0, ground_y + 68.0), Vector2(size.x, ground_y + 68.0), Color(0.18, 0.17, 0.14, 1.0), 1.0)

    draw_line(Vector2(590.0, 96.0), Vector2(590.0, 410.0), Color(0.42, 0.36, 0.25, 0.8), 2.0)
    draw_string(ThemeDB.fallback_font, Vector2(24.0, 458.0), "Hybrid Runtime v3: authored base clips + procedural Dog DNA/personality/socket overlays", HORIZONTAL_ALIGNMENT_LEFT, -1.0, 16.0, Color(0.86, 0.80, 0.68, 1.0))
    draw_string(ThemeDB.fallback_font, Vector2(24.0, 482.0), "Hybrid lane keeps AnimationPlayer base poses, then runtime adds head/tail/ear personality, object swing, DNA dimensions, and socket state.", HORIZONTAL_ALIGNMENT_LEFT, -1.0, 13.0, Color(0.72, 0.69, 0.60, 1.0))


func _draw_hybrid_companion() -> void:
    _draw_ground_band(166.0, size.x, Color(0.26, 0.23, 0.18, 1.0))
    draw_string(ThemeDB.fallback_font, Vector2(18.0, 24.0), "Hybrid companion-like perf strip: 3 hybrid dogs, short window, perf HUD/print", HORIZONTAL_ALIGNMENT_LEFT, -1.0, 15.0, Color(0.86, 0.80, 0.68, 1.0))
    draw_string(ThemeDB.fallback_font, Vector2(18.0, 44.0), "This is not the production companion demo; it is a constrained dog-runtime performance context.", HORIZONTAL_ALIGNMENT_LEFT, -1.0, 12.0, Color(0.72, 0.69, 0.60, 1.0))


func _draw_single_preview() -> void:
    var dog := _active_dog
    var preview_x := 118.0
    for preview in [
        {"label": "216", "scale": 1.0},
        {"label": "144", "scale": 0.67},
        {"label": "96", "scale": 0.44}
    ]:
        _draw_morphology_silhouette(dog, Vector2(preview_x, 320.0), float(preview.scale))
        draw_string(ThemeDB.fallback_font, Vector2(preview_x - 16.0, 348.0), str(preview.label), HORIZONTAL_ALIGNMENT_LEFT, -1.0, 12.0, Color(0.75, 0.69, 0.55, 1.0))
        preview_x += 72.0


func _draw_readability_preview() -> void:
    draw_string(ThemeDB.fallback_font, Vector2(24.0, 608.0), "readability preview: 216 / 144 / 96 px silhouettes", HORIZONTAL_ALIGNMENT_LEFT, -1.0, 14.0, Color(0.86, 0.80, 0.68, 1.0))

    var start_x := 88.0
    var dog_index := 0
    for dog_id in STRESS_DOG_IDS:
        var dog: Dictionary = _dog_by_id.get(dog_id, {})
        var dog_name := str(dog.get("public_name", dog_id))
        draw_string(ThemeDB.fallback_font, Vector2(start_x + dog_index * 355.0, 630.0), dog_name, HORIZONTAL_ALIGNMENT_LEFT, -1.0, 12.0, Color(0.66, 0.78, 0.62, 1.0))

        var preview_x := start_x + dog_index * 355.0 + 20.0
        for preview in [
            {"label": "216", "scale": 1.0},
            {"label": "144", "scale": 0.67},
            {"label": "96", "scale": 0.44}
        ]:
            _draw_morphology_silhouette(dog, Vector2(preview_x, 682.0), float(preview.scale))
            draw_string(ThemeDB.fallback_font, Vector2(preview_x - 14.0, 710.0), str(preview.label), HORIZONTAL_ALIGNMENT_LEFT, -1.0, 11.0, Color(0.75, 0.69, 0.55, 1.0))
            preview_x += 72.0

        dog_index += 1


func _draw_morphology_silhouette(dog: Dictionary, baseline: Vector2, preview_scale: float) -> void:
    var morphology: Dictionary = dog.get("morphology", {})
    var body_length := 64.0
    var body_height := 30.0
    var leg_length := 34.0
    var head_radius := 16.0

    match str(morphology.get("body_length", "medium")):
        "long":
            body_length = 78.0
        "short":
            body_length = 56.0
        _:
            body_length = 64.0

    match str(morphology.get("body_volume", "medium")):
        "sturdy", "barrel":
            body_height = 38.0
            head_radius = 18.0
        "slim":
            body_height = 25.0
        _:
            body_height = 30.0

    match str(morphology.get("leg_length", "medium")):
        "short":
            leg_length = 22.0
        "medium_long":
            leg_length = 40.0
        _:
            leg_length = 34.0

    body_length *= preview_scale
    body_height *= preview_scale
    leg_length *= preview_scale
    head_radius *= preview_scale

    var color := Color(0.03, 0.03, 0.025, 0.72)
    var center := baseline + Vector2(0.0, -leg_length - body_height * 0.55)
    draw_circle(center, body_height * 0.55, color)
    draw_rect(Rect2(center.x - body_length * 0.5, center.y - body_height * 0.38, body_length, body_height * 0.76), color, true)
    draw_circle(center + Vector2(body_length * 0.52, -body_height * 0.15), head_radius, color)
    draw_line(center + Vector2(-body_length * 0.48, -body_height * 0.06), center + Vector2(-body_length * 0.78, -body_height * 0.35), color, maxf(3.0 * preview_scale, 1.0))
    draw_line(center + Vector2(body_length * 0.24, body_height * 0.35), center + Vector2(body_length * 0.24, body_height * 0.35 + leg_length), color, maxf(5.0 * preview_scale, 1.0))
    draw_line(center + Vector2(-body_length * 0.24, body_height * 0.35), center + Vector2(-body_length * 0.24, body_height * 0.35 + leg_length), color, maxf(5.0 * preview_scale, 1.0))
    draw_circle(center + Vector2(body_length * 0.76, 3.0 * preview_scale), 7.5 * preview_scale, Color(0.70, 0.54, 0.28, 0.86))


func _read_user_args() -> void:
    for arg in OS.get_cmdline_user_args():
        if arg == "--dog-rig-auto-quit":
            _auto_quit = true
        elif arg.begins_with("--dog-rig-seconds="):
            _auto_quit_seconds = maxf(arg.replace("--dog-rig-seconds=", "").to_float(), 0.1)
        elif arg == "--dog-rig-print-perf":
            _print_perf = true
        elif arg == "--dog-rig-stress":
            _stress_mode = true
        elif arg == "--dog-rig-pipeline":
            _pipeline_mode = true
        elif arg == "--dog-rig-hybrid":
            _hybrid_mode = true
        elif arg == "--dog-rig-hybrid-companion":
            _hybrid_companion_mode = true
            _hybrid_mode = true
            _print_perf = true
        elif arg.begins_with("--dog-id="):
            _requested_dog_id = arg.replace("--dog-id=", "")


func _load_dog_dna() -> void:
    var file := FileAccess.open(DOG_DNA_PATH, FileAccess.READ)
    if file == null:
        push_error("Dog DNA file is missing: %s" % DOG_DNA_PATH)
        _active_dog = {}
        return

    var parsed = JSON.parse_string(file.get_as_text())
    if typeof(parsed) != TYPE_DICTIONARY:
        push_error("Dog DNA file is not a JSON object: %s" % DOG_DNA_PATH)
        _active_dog = {}
        return

    for dog in parsed.get("dogs", []):
        if typeof(dog) == TYPE_DICTIONARY:
            _dog_by_id[str(dog.get("dog_id", ""))] = dog

    _active_dog = _dog_by_id.get(_requested_dog_id, _dog_by_id.get("DOG-PROT-001", {}))


func _build_scene() -> void:
    mouse_filter = Control.MOUSE_FILTER_STOP

    _status_label = Label.new()
    _status_label.position = Vector2(24.0, 18.0)
    _status_label.size = Vector2(720.0, 42.0)
    _status_label.add_theme_color_override("font_color", Color(0.9, 0.86, 0.76, 1.0))
    add_child(_status_label)

    _dog_label = Label.new()
    _dog_label.position = Vector2(24.0, 58.0)
    _dog_label.size = Vector2(820.0, 44.0)
    _dog_label.add_theme_color_override("font_color", Color(0.66, 0.78, 0.62, 1.0))
    add_child(_dog_label)

    _perf_label = Label.new()
    _perf_label.position = Vector2(790.0, 18.0)
    _perf_label.size = Vector2(360.0, 64.0)
    _perf_label.add_theme_color_override("font_color", Color(0.78, 0.76, 0.68, 1.0))
    add_child(_perf_label)

    if _hybrid_companion_mode:
        _build_hybrid_companion_rigs()
    elif _hybrid_mode:
        _build_hybrid_rigs()
    elif _pipeline_mode:
        _build_pipeline_rigs()
    elif _stress_mode:
        _build_stress_rigs()
    else:
        _build_single_rig()

    _update_perf_label()


func _build_single_rig() -> void:
    _rigs.append(_create_rig(_active_dog, {
        "ground_y": GROUND_Y,
        "scale": 1.0,
        "start_x": 170.0,
        "pickup_x": 360.0,
        "delivery_x": 695.0,
        "phase_offset": 0.0,
        "label_position": Vector2(24.0, 104.0)
    }))
    _update_dog_label()


func _build_stress_rigs() -> void:
    var lanes := [
        {"dog_id": "DOG-PROT-001", "ground_y": 190.0, "phase_offset": 0.0},
        {"dog_id": "DOG-PROT-002", "ground_y": 365.0, "phase_offset": 0.42},
        {"dog_id": "DOG-PROT-003", "ground_y": 540.0, "phase_offset": 0.84}
    ]

    for lane in lanes:
        var dog: Dictionary = _dog_by_id.get(str(lane.dog_id), {})
        _rigs.append(_create_rig(dog, {
            "ground_y": float(lane.ground_y),
            "scale": 0.72,
            "start_x": 145.0,
            "pickup_x": 420.0,
            "delivery_x": 780.0,
            "phase_offset": float(lane.phase_offset),
            "label_position": Vector2(24.0, float(lane.ground_y) - 72.0)
        }))

    _dog_label.text = "Morphology stress: Bublik / Knopka / Mishka share one runtime grammar"


func _build_pipeline_rigs() -> void:
    var bublik: Dictionary = _dog_by_id.get("DOG-PROT-001", {})
    var procedural := _create_rig(bublik, {
        "ground_y": 260.0,
        "scale": 0.84,
        "start_x": 85.0,
        "pickup_x": 265.0,
        "delivery_x": 470.0,
        "phase_offset": 0.0,
        "label_position": Vector2(24.0, 120.0)
    })
    procedural["pipeline"] = "procedural"
    procedural["approach_label"] = "Target A: procedural node transforms"
    _rigs.append(procedural)

    var authored := _create_rig(bublik, {
        "ground_y": 260.0,
        "scale": 0.84,
        "start_x": 665.0,
        "pickup_x": 845.0,
        "delivery_x": 1050.0,
        "phase_offset": 0.0,
        "label_position": Vector2(612.0, 120.0)
    })
    authored["pipeline"] = "authored"
    authored["approach_label"] = "Target B: AnimationPlayer pose clips"
    _setup_authored_animation(authored)
    _rigs.append(authored)

    _dog_label.text = "Animation Pipeline Comparison v2: Bublik procedural vs Bublik authored AnimationPlayer"
    _status_label.text = "same phrase: idle -> look -> walk -> pickup -> carry -> deliver -> wag"


func _build_hybrid_rigs() -> void:
    var bublik: Dictionary = _dog_by_id.get("DOG-PROT-001", {})
    var procedural := _create_rig(bublik, {
        "ground_y": 260.0,
        "scale": 0.84,
        "start_x": 85.0,
        "pickup_x": 265.0,
        "delivery_x": 470.0,
        "phase_offset": 0.0,
        "label_position": Vector2(24.0, 120.0)
    })
    procedural["pipeline"] = "procedural"
    procedural["approach_label"] = "Baseline: procedural runtime"
    _rigs.append(procedural)

    var hybrid := _create_rig(bublik, {
        "ground_y": 260.0,
        "scale": 0.84,
        "start_x": 665.0,
        "pickup_x": 845.0,
        "delivery_x": 1050.0,
        "phase_offset": 0.0,
        "label_position": Vector2(612.0, 120.0)
    })
    hybrid["pipeline"] = "hybrid"
    hybrid["approach_label"] = "Hybrid: AnimationPlayer base + procedural overlays"
    _setup_authored_animation(hybrid)
    _rigs.append(hybrid)

    _dog_label.text = "Hybrid Runtime v3: Bublik procedural baseline vs Bublik hybrid"
    _status_label.text = "hybrid split: authored base clips; runtime DNA/personality/socket/object layers"


func _build_hybrid_companion_rigs() -> void:
    var lanes := [
        {"dog_id": "DOG-PROT-001", "start_x": 80.0, "pickup_x": 210.0, "delivery_x": 340.0, "phase_offset": 0.0, "label_x": 18.0},
        {"dog_id": "DOG-PROT-002", "start_x": 420.0, "pickup_x": 550.0, "delivery_x": 680.0, "phase_offset": 0.33, "label_x": 368.0},
        {"dog_id": "DOG-PROT-003", "start_x": 760.0, "pickup_x": 890.0, "delivery_x": 1020.0, "phase_offset": 0.66, "label_x": 718.0}
    ]

    for lane in lanes:
        var dog: Dictionary = _dog_by_id.get(str(lane.dog_id), {})
        var rig := _create_rig(dog, {
            "ground_y": 166.0,
            "scale": 0.52,
            "start_x": float(lane.start_x),
            "pickup_x": float(lane.pickup_x),
            "delivery_x": float(lane.delivery_x),
            "phase_offset": float(lane.phase_offset),
            "label_position": Vector2(float(lane.label_x), 68.0)
        })
        rig["pipeline"] = "hybrid"
        rig["approach_label"] = "Hybrid companion perf"
        _setup_authored_animation(rig)
        _rigs.append(rig)

    _dog_label.text = "Hybrid companion-like perf: Bublik / Knopka / Mishka"
    _status_label.text = "short strip constraints; authored base clips + procedural overlays"


func _create_rig(dog: Dictionary, options: Dictionary) -> Dictionary:
    var morphology: Dictionary = dog.get("morphology", {})
    var root := Node2D.new()
    root.name = "DogRig_%s" % str(morphology.get("skeleton_family", "standard_medium"))
    root.scale = Vector2.ONE * float(options.get("scale", 1.0))
    add_child(root)

    var rig := {
        "dog": dog,
        "root": root,
        "ground_y": float(options.get("ground_y", GROUND_Y)),
        "scale": float(options.get("scale", 1.0)),
        "start_x": float(options.get("start_x", 170.0)),
        "pickup_x": float(options.get("pickup_x", 360.0)),
        "delivery_x": float(options.get("delivery_x", 695.0)),
        "phase_offset": float(options.get("phase_offset", 0.0)),
        "clip": "idle_neutral"
    }

    rig["back_upper_leg"] = _make_part(root, "BackUpperLeg", Color(0.46, 0.26, 0.13, 1.0))
    rig["back_lower_leg"] = _make_part(root, "BackLowerLeg", Color(0.38, 0.20, 0.10, 1.0))
    rig["front_upper_leg"] = _make_part(root, "FrontUpperLeg", Color(0.55, 0.32, 0.17, 1.0))
    rig["front_lower_leg"] = _make_part(root, "FrontLowerLeg", Color(0.43, 0.23, 0.11, 1.0))

    var tail := Line2D.new()
    tail.name = "Tail"
    tail.width = 12.0
    tail.default_color = Color(0.55, 0.32, 0.17, 1.0)
    tail.begin_cap_mode = Line2D.LINE_CAP_ROUND
    tail.end_cap_mode = Line2D.LINE_CAP_ROUND
    root.add_child(tail)
    rig["tail"] = tail

    rig["body"] = _make_part(root, "Body", Color(0.55, 0.32, 0.17, 1.0))
    rig["chest_mark"] = _make_part(root, "WhiteChest", Color(0.86, 0.77, 0.58, 1.0))
    rig["head"] = _make_part(root, "Head", Color(0.55, 0.32, 0.17, 1.0))
    rig["muzzle"] = _make_part(root, "Muzzle", Color(0.86, 0.77, 0.58, 1.0))
    rig["ear_left"] = _make_part(root, "EarLeft", Color(0.34, 0.18, 0.09, 1.0))
    rig["ear_right"] = _make_part(root, "EarRight", Color(0.34, 0.18, 0.09, 1.0))

    var collar := Line2D.new()
    collar.name = "SoftGreenCollar"
    collar.width = 5.0
    collar.default_color = Color(0.30, 0.58, 0.38, 1.0)
    collar.begin_cap_mode = Line2D.LINE_CAP_ROUND
    collar.end_cap_mode = Line2D.LINE_CAP_ROUND
    (rig.head as Polygon2D).add_child(collar)
    rig["collar"] = collar

    var mouth_socket := Node2D.new()
    mouth_socket.name = "MouthHarnessSocket"
    (rig.head as Polygon2D).add_child(mouth_socket)
    rig["mouth_socket"] = mouth_socket

    var carried_bag := _make_bag("CarriedFoodBag")
    mouth_socket.add_child(carried_bag)
    carried_bag.visible = false
    rig["carried_bag"] = carried_bag

    var pickup_bag := _make_bag("PickupFoodBag")
    add_child(pickup_bag)
    rig["pickup_bag"] = pickup_bag

    var delivered_bag := _make_bag("DeliveredFoodBag")
    add_child(delivered_bag)
    delivered_bag.visible = false
    rig["delivered_bag"] = delivered_bag

    var lane_label := Label.new()
    lane_label.position = options.get("label_position", Vector2(24.0, 78.0))
    lane_label.size = Vector2(980.0, 58.0)
    lane_label.add_theme_color_override("font_color", Color(0.66, 0.78, 0.62, 1.0))
    add_child(lane_label)
    rig["lane_label"] = lane_label

    _apply_dog_dna_to_rig(rig)
    return rig


func _setup_authored_animation(rig: Dictionary) -> void:
    var root := rig.root as Node2D
    var drivers := {
        "body": _make_driver(root, "BodyDriver"),
        "head": _make_driver(root, "HeadDriver"),
        "front_upper_leg": _make_driver(root, "FrontUpperLegDriver"),
        "front_lower_leg": _make_driver(root, "FrontLowerLegDriver"),
        "back_upper_leg": _make_driver(root, "BackUpperLegDriver"),
        "back_lower_leg": _make_driver(root, "BackLowerLegDriver"),
        "ear_left": _make_driver(root, "EarLeftDriver"),
        "ear_right": _make_driver(root, "EarRightDriver"),
        "tail": _make_driver(root, "TailDriver"),
        "bag": _make_driver(root, "BagDriver")
    }
    rig["drivers"] = drivers

    var player := AnimationPlayer.new()
    player.name = "AuthoredClipPlayer"
    player.root_node = NodePath("..")
    root.add_child(player)
    rig["animation_player"] = player

    var library := AnimationLibrary.new()
    library.add_animation("idle_neutral", _make_authored_clip([
        {"path": "BodyDriver:position", "keys": [[0.0, Vector2.ZERO], [0.6, Vector2(0.0, -1.2)], [1.2, Vector2.ZERO]]},
        {"path": "BodyDriver:rotation", "keys": [[0.0, 0.0], [1.2, 0.0]]},
        {"path": "HeadDriver:position", "keys": [[0.0, Vector2.ZERO], [1.2, Vector2.ZERO]]},
        {"path": "HeadDriver:rotation", "keys": [[0.0, -0.05], [0.6, 0.02], [1.2, -0.05]]},
        {"path": "TailDriver:rotation", "keys": [[0.0, -0.18], [0.6, -0.31], [1.2, -0.18]]},
        {"path": "EarLeftDriver:rotation", "keys": [[0.0, 0.0], [1.2, 0.0]]},
        {"path": "EarRightDriver:rotation", "keys": [[0.0, 0.25], [1.2, 0.25]]},
        {"path": "BagDriver:position", "keys": [[0.0, Vector2(18.0, 10.0)], [1.2, Vector2(18.0, 10.0)]]},
        {"path": "BagDriver:rotation", "keys": [[0.0, 0.0], [1.2, 0.0]]}
    ], 1.2, true))
    library.add_animation("head_look", _make_authored_clip([
        {"path": "BodyDriver:position", "keys": [[0.0, Vector2.ZERO], [0.8, Vector2.ZERO]]},
        {"path": "HeadDriver:position", "keys": [[0.0, Vector2.ZERO], [0.8, Vector2(0.0, 1.0)]]},
        {"path": "HeadDriver:rotation", "keys": [[0.0, -0.05], [0.8, 0.24]]},
        {"path": "TailDriver:rotation", "keys": [[0.0, -0.22], [0.8, -0.30]]}
    ], 0.8, false))
    library.add_animation("walk_empty", _make_authored_clip([
        {"path": "BodyDriver:position", "keys": [[0.0, Vector2.ZERO], [0.2, Vector2(0.0, -4.0)], [0.4, Vector2.ZERO], [0.6, Vector2(0.0, -4.0)], [0.8, Vector2.ZERO]]},
        {"path": "BodyDriver:rotation", "keys": [[0.0, -0.025], [0.4, 0.025], [0.8, -0.025]]},
        {"path": "HeadDriver:position", "keys": [[0.0, Vector2.ZERO], [0.8, Vector2.ZERO]]},
        {"path": "HeadDriver:rotation", "keys": [[0.0, 0.02], [0.4, 0.08], [0.8, 0.02]]},
        {"path": "FrontUpperLegDriver:rotation", "keys": [[0.0, -0.28], [0.4, 0.28], [0.8, -0.28]]},
        {"path": "FrontLowerLegDriver:rotation", "keys": [[0.0, 0.18], [0.4, -0.18], [0.8, 0.18]]},
        {"path": "BackUpperLegDriver:rotation", "keys": [[0.0, 0.26], [0.4, -0.26], [0.8, 0.26]]},
        {"path": "BackLowerLegDriver:rotation", "keys": [[0.0, -0.16], [0.4, 0.16], [0.8, -0.16]]},
        {"path": "EarLeftDriver:rotation", "keys": [[0.0, -0.08], [0.4, 0.08], [0.8, -0.08]]},
        {"path": "EarRightDriver:rotation", "keys": [[0.0, 0.18], [0.4, 0.34], [0.8, 0.18]]},
        {"path": "TailDriver:rotation", "keys": [[0.0, -0.30], [0.4, -0.12], [0.8, -0.30]]}
    ], 0.8, true))
    library.add_animation("walk_carry_medium", _make_authored_clip([
        {"path": "BodyDriver:position", "keys": [[0.0, Vector2(0.0, 1.0)], [0.2, Vector2(0.0, -2.5)], [0.4, Vector2(0.0, 1.0)], [0.6, Vector2(0.0, -2.5)], [0.8, Vector2(0.0, 1.0)]]},
        {"path": "BodyDriver:rotation", "keys": [[0.0, 0.02], [0.8, 0.02]]},
        {"path": "HeadDriver:position", "keys": [[0.0, Vector2(0.0, 4.0)], [0.8, Vector2(0.0, 4.0)]]},
        {"path": "HeadDriver:rotation", "keys": [[0.0, 0.28], [0.4, 0.34], [0.8, 0.28]]},
        {"path": "FrontUpperLegDriver:rotation", "keys": [[0.0, -0.22], [0.4, 0.20], [0.8, -0.22]]},
        {"path": "FrontLowerLegDriver:rotation", "keys": [[0.0, 0.13], [0.4, -0.13], [0.8, 0.13]]},
        {"path": "BackUpperLegDriver:rotation", "keys": [[0.0, 0.20], [0.4, -0.20], [0.8, 0.20]]},
        {"path": "BackLowerLegDriver:rotation", "keys": [[0.0, -0.12], [0.4, 0.12], [0.8, -0.12]]},
        {"path": "TailDriver:rotation", "keys": [[0.0, -0.26], [0.4, -0.16], [0.8, -0.26]]},
        {"path": "BagDriver:position", "keys": [[0.0, Vector2(18.0, 9.0)], [0.4, Vector2(18.0, 13.0)], [0.8, Vector2(18.0, 9.0)]]},
        {"path": "BagDriver:rotation", "keys": [[0.0, -0.08], [0.4, 0.08], [0.8, -0.08]]}
    ], 0.8, true))
    library.add_animation("pickup_pose", _make_authored_clip([
        {"path": "BodyDriver:position", "keys": [[0.0, Vector2.ZERO], [0.6, Vector2(0.0, 2.0)]]},
        {"path": "BodyDriver:rotation", "keys": [[0.0, 0.0], [0.6, 0.035]]},
        {"path": "HeadDriver:position", "keys": [[0.0, Vector2.ZERO], [0.6, Vector2(0.0, 8.0)]]},
        {"path": "HeadDriver:rotation", "keys": [[0.0, 0.12], [0.6, 0.42]]},
        {"path": "FrontUpperLegDriver:rotation", "keys": [[0.0, 0.0], [0.6, -0.10]]},
        {"path": "TailDriver:rotation", "keys": [[0.0, -0.24], [0.6, -0.34]]}
    ], 0.6, false))
    library.add_animation("deliver_pose", _make_authored_clip([
        {"path": "BodyDriver:position", "keys": [[0.0, Vector2(0.0, 1.0)], [0.6, Vector2.ZERO]]},
        {"path": "HeadDriver:position", "keys": [[0.0, Vector2(0.0, 5.0)], [0.6, Vector2(0.0, 3.0)]]},
        {"path": "HeadDriver:rotation", "keys": [[0.0, 0.34], [0.6, 0.18]]},
        {"path": "TailDriver:rotation", "keys": [[0.0, -0.22], [0.6, -0.12]]},
        {"path": "BagDriver:rotation", "keys": [[0.0, 0.05], [0.6, -0.05]]}
    ], 0.6, false))
    library.add_animation("tail_wag", _make_authored_clip([
        {"path": "BodyDriver:position", "keys": [[0.0, Vector2.ZERO], [0.8, Vector2.ZERO]]},
        {"path": "HeadDriver:rotation", "keys": [[0.0, 0.03], [0.8, 0.03]]},
        {"path": "TailDriver:rotation", "keys": [[0.0, -0.38], [0.2, 0.05], [0.4, -0.38], [0.6, 0.05], [0.8, -0.38]]},
        {"path": "EarLeftDriver:rotation", "keys": [[0.0, -0.04], [0.4, 0.06], [0.8, -0.04]]},
        {"path": "EarRightDriver:rotation", "keys": [[0.0, 0.21], [0.4, 0.31], [0.8, 0.21]]}
    ], 0.8, true))
    player.add_animation_library("", library)
    player.play("idle_neutral")
    rig["authored_clip"] = "idle_neutral"


func _make_driver(root: Node2D, node_name: String) -> Node2D:
    var driver := Node2D.new()
    driver.name = node_name
    root.add_child(driver)
    return driver


func _make_authored_clip(track_specs: Array, length: float, loop_clip: bool) -> Animation:
    var animation := Animation.new()
    animation.length = length
    if loop_clip:
        animation.loop_mode = Animation.LOOP_LINEAR

    for spec in track_specs:
        var track_index := animation.add_track(Animation.TYPE_VALUE)
        animation.track_set_path(track_index, NodePath(str(spec.path)))
        for key in spec.keys:
            animation.track_insert_key(track_index, float(key[0]), key[1])

    return animation


func _make_part(root: Node2D, part_name: String, color: Color) -> Polygon2D:
    var part := Polygon2D.new()
    part.name = part_name
    part.color = color
    root.add_child(part)
    return part


func _make_bag(node_name: String) -> Node2D:
    var root := Node2D.new()
    root.name = node_name

    var bag := Polygon2D.new()
    bag.name = "FoodBagShape"
    bag.color = Color(0.70, 0.54, 0.28, 1.0)
    bag.polygon = PackedVector2Array([
        Vector2(-16.0, -16.0),
        Vector2(16.0, -14.0),
        Vector2(18.0, 16.0),
        Vector2(-18.0, 15.0)
    ])
    root.add_child(bag)

    var tie := Line2D.new()
    tie.name = "Tie"
    tie.width = 4.0
    tie.default_color = Color(0.38, 0.24, 0.13, 1.0)
    tie.points = PackedVector2Array([Vector2(-10.0, -8.0), Vector2(10.0, -7.0)])
    root.add_child(tie)

    return root


func _apply_dog_dna_to_rig(rig: Dictionary) -> void:
    var dog: Dictionary = rig.dog
    var morphology: Dictionary = dog.get("morphology", {})
    var appearance: Dictionary = dog.get("appearance", {})

    var body_length := 120.0
    var body_height := 54.0
    var leg_length := 62.0
    var head_size := Vector2(50.0, 42.0)
    var muzzle_size := Vector2(28.0, 18.0)
    var tail_length := 44.0

    match str(morphology.get("body_length", "medium")):
        "long":
            body_length = 142.0
        "short":
            body_length = 104.0
        _:
            body_length = 120.0

    match str(morphology.get("body_volume", "medium")):
        "sturdy", "barrel":
            body_height = 66.0
        "slim":
            body_height = 44.0
        _:
            body_height = 54.0

    match str(morphology.get("leg_length", "medium")):
        "short":
            leg_length = 40.0
        "medium_short":
            leg_length = 52.0
        "medium_long":
            leg_length = 72.0
        "long":
            leg_length = 80.0
        _:
            leg_length = 62.0

    match str(morphology.get("head_shape", "wedge_soft")):
        "blocky_soft":
            head_size = Vector2(58.0, 46.0)
            muzzle_size = Vector2(32.0, 20.0)
        "soft_square":
            head_size = Vector2(52.0, 42.0)
            muzzle_size = Vector2(30.0, 18.0)
        _:
            head_size = Vector2(50.0, 42.0)
            muzzle_size = Vector2(28.0, 18.0)

    tail_length = 52.0 if str(morphology.get("tail", "curled_medium")).contains("fluffy") else 44.0

    rig["body_length"] = body_length
    rig["body_height"] = body_height
    rig["leg_length"] = leg_length
    rig["head_size"] = head_size
    rig["muzzle_size"] = muzzle_size
    rig["tail_length"] = tail_length

    var coat := _coat_color(str(appearance.get("base_coat", "warm_brown")))
    var secondary := _coat_color(str(appearance.get("secondary_coat", "cream")))
    (rig.body as Polygon2D).color = coat
    (rig.head as Polygon2D).color = coat
    (rig.front_upper_leg as Polygon2D).color = coat.lightened(0.06)
    (rig.back_upper_leg as Polygon2D).color = coat.darkened(0.08)
    (rig.front_lower_leg as Polygon2D).color = coat.darkened(0.14)
    (rig.back_lower_leg as Polygon2D).color = coat.darkened(0.18)
    (rig.ear_left as Polygon2D).color = coat.darkened(0.22)
    (rig.ear_right as Polygon2D).color = coat.darkened(0.22)
    (rig.tail as Line2D).default_color = coat
    (rig.muzzle as Polygon2D).color = secondary
    (rig.chest_mark as Polygon2D).color = secondary

    _rebuild_part_shapes(rig)
    _update_rig_label(rig)


func _coat_color(coat: String) -> Color:
    match coat:
        "dark_brown":
            return Color(0.26, 0.15, 0.09, 1.0)
        "cream":
            return Color(0.86, 0.77, 0.58, 1.0)
        "golden":
            return Color(0.72, 0.50, 0.25, 1.0)
        "white_warm":
            return Color(0.88, 0.82, 0.68, 1.0)
        "black_soft":
            return Color(0.14, 0.13, 0.12, 1.0)
        _:
            return Color(0.55, 0.32, 0.17, 1.0)


func _rebuild_part_shapes(rig: Dictionary) -> void:
    var body_length := float(rig.body_length)
    var body_height := float(rig.body_height)
    var leg_length := float(rig.leg_length)
    var head_size: Vector2 = rig.head_size
    var muzzle_size: Vector2 = rig.muzzle_size
    var tail_length := float(rig.tail_length)

    (rig.body as Polygon2D).polygon = _ellipse_polygon(Vector2.ZERO, body_length * 0.5, body_height * 0.5, 22)
    (rig.chest_mark as Polygon2D).polygon = PackedVector2Array([
        Vector2(body_length * 0.18, -body_height * 0.30),
        Vector2(body_length * 0.36, -body_height * 0.16),
        Vector2(body_length * 0.31, body_height * 0.28),
        Vector2(body_length * 0.12, body_height * 0.22)
    ])
    (rig.head as Polygon2D).polygon = _ellipse_polygon(Vector2.ZERO, head_size.x * 0.5, head_size.y * 0.5, 18)
    (rig.muzzle as Polygon2D).polygon = _ellipse_polygon(Vector2.ZERO, muzzle_size.x * 0.5, muzzle_size.y * 0.5, 14)
    (rig.front_upper_leg as Polygon2D).polygon = _limb_polygon(16.0, leg_length * 0.58)
    (rig.front_lower_leg as Polygon2D).polygon = _limb_polygon(13.0, leg_length * 0.46)
    (rig.back_upper_leg as Polygon2D).polygon = _limb_polygon(17.0, leg_length * 0.56)
    (rig.back_lower_leg as Polygon2D).polygon = _limb_polygon(14.0, leg_length * 0.46)
    (rig.ear_left as Polygon2D).polygon = PackedVector2Array([Vector2(-6.0, 4.0), Vector2(0.0, -32.0), Vector2(15.0, 4.0)])
    (rig.ear_right as Polygon2D).polygon = PackedVector2Array([Vector2(-8.0, 4.0), Vector2(3.0, -30.0), Vector2(16.0, 6.0)])
    (rig.tail as Line2D).points = PackedVector2Array([
        Vector2.ZERO,
        Vector2(-tail_length * 0.38, -12.0),
        Vector2(-tail_length * 0.74, -6.0),
        Vector2(-tail_length, -20.0)
    ])
    (rig.collar as Line2D).points = PackedVector2Array([Vector2(-20.0, 12.0), Vector2(18.0, 14.0)])


func _ellipse_polygon(center: Vector2, radius_x: float, radius_y: float, steps: int) -> PackedVector2Array:
    var points := PackedVector2Array()
    for index in range(steps):
        var angle := TAU * float(index) / float(steps)
        points.append(center + Vector2(cos(angle) * radius_x, sin(angle) * radius_y))
    return points


func _limb_polygon(width: float, height: float) -> PackedVector2Array:
    var half_width := width * 0.5
    return PackedVector2Array([
        Vector2(-half_width, 0.0),
        Vector2(half_width, 0.0),
        Vector2(half_width * 0.78, height),
        Vector2(-half_width * 0.92, height)
    ])


func _update_rig(rig: Dictionary, total_time: float) -> void:
    var cycle_time := fmod(total_time + float(rig.phase_offset), CYCLE_SECONDS)
    var dog: Dictionary = rig.dog
    var profile: Dictionary = dog.get("animation_profile", {})
    var phase := cycle_time * _profile_float(profile, "step_frequency", 1.0)

    var clip := "idle_neutral"
    var dog_x := float(rig.start_x)
    var head_look := 0.0
    var carry_object := false
    var show_pickup_bag := true
    var show_delivered_bag := false
    var happy := false

    if cycle_time < 1.0:
        clip = "idle_neutral"
    elif cycle_time < 1.8:
        clip = "head_look"
        head_look = smoothstep(0.0, 1.0, (cycle_time - 1.0) / 0.8)
    elif cycle_time < 4.0:
        clip = "walk_empty"
        dog_x = lerpf(float(rig.start_x), float(rig.pickup_x) - 60.0, smoothstep(0.0, 1.0, (cycle_time - 1.8) / 2.2))
        head_look = 0.35
    elif cycle_time < 4.7:
        clip = "pickup_pose"
        dog_x = float(rig.pickup_x) - 60.0
        head_look = 1.0
        show_pickup_bag = cycle_time < 4.42
        carry_object = cycle_time >= 4.42
    elif cycle_time < 8.0:
        clip = "walk_carry_medium"
        dog_x = lerpf(float(rig.pickup_x) - 60.0, float(rig.delivery_x), smoothstep(0.0, 1.0, (cycle_time - 4.7) / 3.3))
        head_look = 0.75
        carry_object = true
        show_pickup_bag = false
    elif cycle_time < 8.7:
        clip = "deliver_pose"
        dog_x = float(rig.delivery_x)
        head_look = 0.75
        carry_object = cycle_time < 8.45
        show_pickup_bag = false
        show_delivered_bag = cycle_time >= 8.45
    else:
        clip = "tail_wag"
        dog_x = lerpf(float(rig.delivery_x), float(rig.delivery_x) - 65.0, smoothstep(0.0, 1.0, (cycle_time - 8.7) / 1.8))
        happy = true
        show_pickup_bag = false
        show_delivered_bag = true

    rig["clip"] = clip
    (rig.pickup_bag as Node2D).visible = show_pickup_bag
    (rig.carried_bag as Node2D).visible = carry_object
    (rig.delivered_bag as Node2D).visible = show_delivered_bag

    _update_rig_pose(rig, total_time, phase, dog_x, head_look, carry_object, happy, clip)
    _update_rig_label(rig)

    if not _stress_mode and not _pipeline_mode:
        _status_label.text = "clip: %s | socket: %s | layers: tail_wag + head_look + ear_bounce" % [
            clip,
            "food_bag attached" if carry_object else "empty"
        ]


func _update_rig_pose(rig: Dictionary, total_time: float, phase: float, dog_x: float, head_look: float, carry_object: bool, happy: bool, clip: String) -> void:
    var dog: Dictionary = rig.dog
    var profile: Dictionary = dog.get("animation_profile", {})
    var body_length := float(rig.body_length)
    var body_height := float(rig.body_height)
    var leg_length := float(rig.leg_length)
    var head_size: Vector2 = rig.head_size
    var motion_amount := 1.0 if clip.begins_with("walk") else 0.0
    var carry_effort := 1.0 if carry_object else 0.0
    var preset_bounce := _preset_bounce(profile)
    var body_bob := sin(phase * TAU * 1.7) * 4.0 * motion_amount * _profile_float(profile, "head_bob_amount", 1.0) * preset_bounce
    var walk_sway := sin(phase * TAU * 0.85) * 0.035 * motion_amount

    var root := rig.root as Node2D
    root.position = Vector2(dog_x, float(rig.ground_y) - (leg_length + 30.0) * float(rig.scale) + body_bob)
    root.rotation = walk_sway

    var body := rig.body as Polygon2D
    var chest_mark := rig.chest_mark as Polygon2D
    body.position = Vector2.ZERO
    body.rotation = 0.02 * carry_effort
    chest_mark.position = body.position
    chest_mark.rotation = body.rotation

    var head := rig.head as Polygon2D
    var muzzle := rig.muzzle as Polygon2D
    var mouth_socket := rig.mouth_socket as Node2D
    var head_base := Vector2(body_length * 0.52, -body_height * 0.16)
    head.position = head_base + Vector2(0.0, 4.0 * carry_effort)
    head.rotation = lerpf(-0.05, 0.24 + 0.08 * carry_effort, head_look) + sin(phase * TAU * 0.5) * 0.035 * _profile_float(profile, "look_around_frequency", 1.0) * 0.35
    muzzle.position = head.position + Vector2(head_size.x * 0.40, 4.0).rotated(head.rotation)
    muzzle.rotation = head.rotation - 0.03
    mouth_socket.position = Vector2(head_size.x * 0.68, 7.0 + carry_effort * 4.0)
    mouth_socket.rotation = -head.rotation * 0.45

    var carried_bag := rig.carried_bag as Node2D
    carried_bag.position = Vector2(18.0, 10.0 + sin(phase * TAU) * 3.0 * carry_effort)
    carried_bag.rotation = sin(phase * TAU * 0.8) * 0.12 * _object_swing_amount(profile)

    var pickup_bag := rig.pickup_bag as Node2D
    pickup_bag.position = Vector2(float(rig.pickup_x), float(rig.ground_y) - 26.0)
    pickup_bag.scale = Vector2.ONE * float(rig.scale)

    var delivered_bag := rig.delivered_bag as Node2D
    delivered_bag.position = Vector2(float(rig.delivery_x) + 46.0, float(rig.ground_y) - 26.0)
    delivered_bag.scale = Vector2.ONE * float(rig.scale)

    var front_x := body_length * 0.28
    var back_x := -body_length * 0.30
    var hip_y := body_height * 0.34
    var step := sin(phase * TAU * 2.0)
    var opposite_step := sin(phase * TAU * 2.0 + PI)

    var front_upper_leg := rig.front_upper_leg as Polygon2D
    var front_lower_leg := rig.front_lower_leg as Polygon2D
    front_upper_leg.position = Vector2(front_x, hip_y)
    front_upper_leg.rotation = step * 0.33 * motion_amount * preset_bounce - 0.08 * carry_effort
    front_lower_leg.position = front_upper_leg.position + Vector2(4.0, leg_length * 0.48).rotated(front_upper_leg.rotation)
    front_lower_leg.rotation = -step * 0.24 * motion_amount * preset_bounce

    var back_upper_leg := rig.back_upper_leg as Polygon2D
    var back_lower_leg := rig.back_lower_leg as Polygon2D
    back_upper_leg.position = Vector2(back_x, hip_y)
    back_upper_leg.rotation = opposite_step * 0.30 * motion_amount * preset_bounce
    back_lower_leg.position = back_upper_leg.position + Vector2(-2.0, leg_length * 0.46).rotated(back_upper_leg.rotation)
    back_lower_leg.rotation = -opposite_step * 0.22 * motion_amount * preset_bounce

    var ear_left := rig.ear_left as Polygon2D
    var ear_right := rig.ear_right as Polygon2D
    ear_left.position = head.position + Vector2(-12.0, -head_size.y * 0.40).rotated(head.rotation)
    ear_right.position = head.position + Vector2(14.0, -head_size.y * 0.36).rotated(head.rotation)
    ear_left.rotation = head.rotation + sin(phase * TAU * 1.7) * 0.10 * _profile_float(profile, "ear_bounce_amount", 1.0)
    ear_right.rotation = head.rotation + 0.25 + sin(phase * TAU * 1.7 + PI * 0.4) * 0.13 * _profile_float(profile, "ear_bounce_amount", 1.0)

    var wag_base := 0.18 if happy else 0.06
    var tail_wag := sin(total_time * TAU * _profile_float(profile, "tail_wag_frequency", 1.0)) * wag_base * _profile_float(profile, "tail_wag_amplitude", 1.0)
    var tail := rig.tail as Line2D
    tail.position = Vector2(-body_length * 0.52, -body_height * 0.06)
    tail.rotation = -0.25 + tail_wag


func _update_authored_rig(rig: Dictionary, total_time: float) -> void:
    var cycle_time := fmod(total_time + float(rig.phase_offset), CYCLE_SECONDS)
    var clip := "idle_neutral"
    var dog_x := float(rig.start_x)
    var carry_object := false
    var show_pickup_bag := true
    var show_delivered_bag := false

    if cycle_time < 1.0:
        clip = "idle_neutral"
    elif cycle_time < 1.8:
        clip = "head_look"
    elif cycle_time < 4.0:
        clip = "walk_empty"
        dog_x = lerpf(float(rig.start_x), float(rig.pickup_x) - 60.0, smoothstep(0.0, 1.0, (cycle_time - 1.8) / 2.2))
    elif cycle_time < 4.7:
        clip = "pickup_pose"
        dog_x = float(rig.pickup_x) - 60.0
        show_pickup_bag = cycle_time < 4.42
        carry_object = cycle_time >= 4.42
    elif cycle_time < 8.0:
        clip = "walk_carry_medium"
        dog_x = lerpf(float(rig.pickup_x) - 60.0, float(rig.delivery_x), smoothstep(0.0, 1.0, (cycle_time - 4.7) / 3.3))
        carry_object = true
        show_pickup_bag = false
    elif cycle_time < 8.7:
        clip = "deliver_pose"
        dog_x = float(rig.delivery_x)
        carry_object = cycle_time < 8.45
        show_pickup_bag = false
        show_delivered_bag = cycle_time >= 8.45
    else:
        clip = "tail_wag"
        dog_x = lerpf(float(rig.delivery_x), float(rig.delivery_x) - 65.0, smoothstep(0.0, 1.0, (cycle_time - 8.7) / 1.8))
        show_pickup_bag = false
        show_delivered_bag = true

    var player := rig.animation_player as AnimationPlayer
    if str(rig.get("authored_clip", "")) != clip:
        player.play(clip)
        rig["authored_clip"] = clip

    rig["clip"] = clip
    (rig.pickup_bag as Node2D).visible = show_pickup_bag
    (rig.carried_bag as Node2D).visible = carry_object
    (rig.delivered_bag as Node2D).visible = show_delivered_bag

    _update_authored_rig_pose(rig, dog_x, carry_object)
    _update_rig_label(rig)


func _update_authored_rig_pose(rig: Dictionary, dog_x: float, carry_object: bool) -> void:
    var drivers: Dictionary = rig.drivers
    var body_length := float(rig.body_length)
    var body_height := float(rig.body_height)
    var leg_length := float(rig.leg_length)
    var head_size: Vector2 = rig.head_size

    var body_driver := drivers.body as Node2D
    var head_driver := drivers.head as Node2D
    var bag_driver := drivers.bag as Node2D
    var root := rig.root as Node2D
    root.position = Vector2(dog_x, float(rig.ground_y) - (leg_length + 30.0) * float(rig.scale) + body_driver.position.y)
    root.rotation = body_driver.rotation * 0.35

    var body := rig.body as Polygon2D
    var chest_mark := rig.chest_mark as Polygon2D
    body.position = Vector2.ZERO
    body.rotation = body_driver.rotation
    chest_mark.position = body.position
    chest_mark.rotation = body.rotation

    var head := rig.head as Polygon2D
    var muzzle := rig.muzzle as Polygon2D
    var mouth_socket := rig.mouth_socket as Node2D
    var head_base := Vector2(body_length * 0.52, -body_height * 0.16)
    head.position = head_base + head_driver.position
    head.rotation = head_driver.rotation
    muzzle.position = head.position + Vector2(head_size.x * 0.40, 4.0).rotated(head.rotation)
    muzzle.rotation = head.rotation - 0.03
    mouth_socket.position = Vector2(head_size.x * 0.68, 7.0 + (4.0 if carry_object else 0.0))
    mouth_socket.rotation = -head.rotation * 0.45

    var carried_bag := rig.carried_bag as Node2D
    carried_bag.position = bag_driver.position
    carried_bag.rotation = bag_driver.rotation

    var pickup_bag := rig.pickup_bag as Node2D
    pickup_bag.position = Vector2(float(rig.pickup_x), float(rig.ground_y) - 26.0)
    pickup_bag.scale = Vector2.ONE * float(rig.scale)

    var delivered_bag := rig.delivered_bag as Node2D
    delivered_bag.position = Vector2(float(rig.delivery_x) + 46.0, float(rig.ground_y) - 26.0)
    delivered_bag.scale = Vector2.ONE * float(rig.scale)

    var front_x := body_length * 0.28
    var back_x := -body_length * 0.30
    var hip_y := body_height * 0.34

    var front_upper_leg := rig.front_upper_leg as Polygon2D
    var front_lower_leg := rig.front_lower_leg as Polygon2D
    front_upper_leg.position = Vector2(front_x, hip_y)
    front_upper_leg.rotation = (drivers.front_upper_leg as Node2D).rotation
    front_lower_leg.position = front_upper_leg.position + Vector2(4.0, leg_length * 0.48).rotated(front_upper_leg.rotation)
    front_lower_leg.rotation = (drivers.front_lower_leg as Node2D).rotation

    var back_upper_leg := rig.back_upper_leg as Polygon2D
    var back_lower_leg := rig.back_lower_leg as Polygon2D
    back_upper_leg.position = Vector2(back_x, hip_y)
    back_upper_leg.rotation = (drivers.back_upper_leg as Node2D).rotation
    back_lower_leg.position = back_upper_leg.position + Vector2(-2.0, leg_length * 0.46).rotated(back_upper_leg.rotation)
    back_lower_leg.rotation = (drivers.back_lower_leg as Node2D).rotation

    var ear_left := rig.ear_left as Polygon2D
    var ear_right := rig.ear_right as Polygon2D
    ear_left.position = head.position + Vector2(-12.0, -head_size.y * 0.40).rotated(head.rotation)
    ear_right.position = head.position + Vector2(14.0, -head_size.y * 0.36).rotated(head.rotation)
    ear_left.rotation = head.rotation + (drivers.ear_left as Node2D).rotation
    ear_right.rotation = head.rotation + (drivers.ear_right as Node2D).rotation

    var tail := rig.tail as Line2D
    tail.position = Vector2(-body_length * 0.52, -body_height * 0.06)
    tail.rotation = (drivers.tail as Node2D).rotation


func _update_hybrid_rig(rig: Dictionary, total_time: float) -> void:
    var cycle_time := fmod(total_time + float(rig.phase_offset), CYCLE_SECONDS)
    var clip := "idle_neutral"
    var dog_x := float(rig.start_x)
    var carry_object := false
    var show_pickup_bag := true
    var show_delivered_bag := false
    var happy := false

    if cycle_time < 1.0:
        clip = "idle_neutral"
    elif cycle_time < 1.8:
        clip = "head_look"
    elif cycle_time < 4.0:
        clip = "walk_empty"
        dog_x = lerpf(float(rig.start_x), float(rig.pickup_x) - 60.0, smoothstep(0.0, 1.0, (cycle_time - 1.8) / 2.2))
    elif cycle_time < 4.7:
        clip = "pickup_pose"
        dog_x = float(rig.pickup_x) - 60.0
        show_pickup_bag = cycle_time < 4.42
        carry_object = cycle_time >= 4.42
    elif cycle_time < 8.0:
        clip = "walk_carry_medium"
        dog_x = lerpf(float(rig.pickup_x) - 60.0, float(rig.delivery_x), smoothstep(0.0, 1.0, (cycle_time - 4.7) / 3.3))
        carry_object = true
        show_pickup_bag = false
    elif cycle_time < 8.7:
        clip = "deliver_pose"
        dog_x = float(rig.delivery_x)
        carry_object = cycle_time < 8.45
        show_pickup_bag = false
        show_delivered_bag = cycle_time >= 8.45
    else:
        clip = "tail_wag"
        dog_x = lerpf(float(rig.delivery_x), float(rig.delivery_x) - 65.0, smoothstep(0.0, 1.0, (cycle_time - 8.7) / 1.8))
        happy = true
        show_pickup_bag = false
        show_delivered_bag = true

    var player := rig.animation_player as AnimationPlayer
    if str(rig.get("authored_clip", "")) != clip:
        player.play(clip)
        rig["authored_clip"] = clip

    rig["clip"] = clip
    (rig.pickup_bag as Node2D).visible = show_pickup_bag
    (rig.carried_bag as Node2D).visible = carry_object
    (rig.delivered_bag as Node2D).visible = show_delivered_bag

    var profile: Dictionary = (rig.dog as Dictionary).get("animation_profile", {})
    var phase := cycle_time * _profile_float(profile, "step_frequency", 1.0)
    _update_hybrid_rig_pose(rig, total_time, phase, dog_x, carry_object, happy, clip)
    _update_rig_label(rig)


func _update_hybrid_rig_pose(rig: Dictionary, total_time: float, phase: float, dog_x: float, carry_object: bool, happy: bool, clip: String) -> void:
    var dog: Dictionary = rig.dog
    var profile: Dictionary = dog.get("animation_profile", {})
    var drivers: Dictionary = rig.drivers
    var body_length := float(rig.body_length)
    var body_height := float(rig.body_height)
    var leg_length := float(rig.leg_length)
    var head_size: Vector2 = rig.head_size
    var motion_amount := 1.0 if clip.begins_with("walk") else 0.0
    var preset_bounce := _preset_bounce(profile)

    var body_driver := drivers.body as Node2D
    var head_driver := drivers.head as Node2D
    var bag_driver := drivers.bag as Node2D
    var dna_bob := sin(phase * TAU * 1.7) * 1.7 * motion_amount * _profile_float(profile, "head_bob_amount", 1.0) * preset_bounce
    var root := rig.root as Node2D
    root.position = Vector2(dog_x, float(rig.ground_y) - (leg_length + 30.0) * float(rig.scale) + body_driver.position.y + dna_bob)
    root.rotation = body_driver.rotation * 0.35

    var body := rig.body as Polygon2D
    var chest_mark := rig.chest_mark as Polygon2D
    body.position = Vector2.ZERO
    body.rotation = body_driver.rotation + (0.012 if carry_object else 0.0)
    chest_mark.position = body.position
    chest_mark.rotation = body.rotation

    var head := rig.head as Polygon2D
    var muzzle := rig.muzzle as Polygon2D
    var mouth_socket := rig.mouth_socket as Node2D
    var head_base := Vector2(body_length * 0.52, -body_height * 0.16)
    var look_overlay := sin(total_time * TAU * _profile_float(profile, "look_around_frequency", 1.0) * 0.28) * 0.045
    head.position = head_base + head_driver.position
    head.rotation = head_driver.rotation + look_overlay
    muzzle.position = head.position + Vector2(head_size.x * 0.40, 4.0).rotated(head.rotation)
    muzzle.rotation = head.rotation - 0.03
    mouth_socket.position = Vector2(head_size.x * 0.68, 7.0 + (4.0 if carry_object else 0.0))
    mouth_socket.rotation = -head.rotation * 0.45

    var carried_bag := rig.carried_bag as Node2D
    var swing_strength := _object_swing_amount(profile)
    carried_bag.position = bag_driver.position + Vector2(0.0, sin(phase * TAU) * 2.2 * swing_strength)
    carried_bag.rotation = bag_driver.rotation + sin(phase * TAU * 0.8) * 0.08 * swing_strength

    var pickup_bag := rig.pickup_bag as Node2D
    pickup_bag.position = Vector2(float(rig.pickup_x), float(rig.ground_y) - 26.0)
    pickup_bag.scale = Vector2.ONE * float(rig.scale)

    var delivered_bag := rig.delivered_bag as Node2D
    delivered_bag.position = Vector2(float(rig.delivery_x) + 46.0, float(rig.ground_y) - 26.0)
    delivered_bag.scale = Vector2.ONE * float(rig.scale)

    var front_x := body_length * 0.28
    var back_x := -body_length * 0.30
    var hip_y := body_height * 0.34

    var front_upper_leg := rig.front_upper_leg as Polygon2D
    var front_lower_leg := rig.front_lower_leg as Polygon2D
    front_upper_leg.position = Vector2(front_x, hip_y)
    front_upper_leg.rotation = (drivers.front_upper_leg as Node2D).rotation * preset_bounce
    front_lower_leg.position = front_upper_leg.position + Vector2(4.0, leg_length * 0.48).rotated(front_upper_leg.rotation)
    front_lower_leg.rotation = (drivers.front_lower_leg as Node2D).rotation * preset_bounce

    var back_upper_leg := rig.back_upper_leg as Polygon2D
    var back_lower_leg := rig.back_lower_leg as Polygon2D
    back_upper_leg.position = Vector2(back_x, hip_y)
    back_upper_leg.rotation = (drivers.back_upper_leg as Node2D).rotation * preset_bounce
    back_lower_leg.position = back_upper_leg.position + Vector2(-2.0, leg_length * 0.46).rotated(back_upper_leg.rotation)
    back_lower_leg.rotation = (drivers.back_lower_leg as Node2D).rotation * preset_bounce

    var ear_left := rig.ear_left as Polygon2D
    var ear_right := rig.ear_right as Polygon2D
    var ear_amount := _profile_float(profile, "ear_bounce_amount", 1.0)
    ear_left.position = head.position + Vector2(-12.0, -head_size.y * 0.40).rotated(head.rotation)
    ear_right.position = head.position + Vector2(14.0, -head_size.y * 0.36).rotated(head.rotation)
    ear_left.rotation = head.rotation + (drivers.ear_left as Node2D).rotation + sin(phase * TAU * 1.5) * 0.045 * ear_amount
    ear_right.rotation = head.rotation + (drivers.ear_right as Node2D).rotation + sin(phase * TAU * 1.5 + PI * 0.4) * 0.055 * ear_amount

    var wag_base := 0.12 if happy else 0.035
    var tail_overlay := sin(total_time * TAU * _profile_float(profile, "tail_wag_frequency", 1.0)) * wag_base * _profile_float(profile, "tail_wag_amplitude", 1.0)
    var tail := rig.tail as Line2D
    tail.position = Vector2(-body_length * 0.52, -body_height * 0.06)
    tail.rotation = (drivers.tail as Node2D).rotation + tail_overlay


func _profile_float(profile: Dictionary, key: String, fallback: float) -> float:
    return float(profile.get(key, fallback))


func _preset_bounce(profile: Dictionary) -> float:
    match str(profile.get("motion_preset", "curious_helper")):
        "happy_bouncy":
            return 1.24
        "calm_worker":
            return 0.72
        _:
            return 1.0


func _object_swing_amount(profile: Dictionary) -> float:
    match str(profile.get("carrying_effort", "medium")):
        "high":
            return 0.7
        "low":
            return 0.55
        _:
            return 1.0


func _update_rig_label(rig: Dictionary) -> void:
    var dog: Dictionary = rig.dog
    var dog_id := str(dog.get("dog_id", "unknown"))
    var dog_name := str(dog.get("public_name", "Dog"))
    var morphology: Dictionary = dog.get("morphology", {})
    var profile: Dictionary = dog.get("animation_profile", {})
    var socket_state := "attached" if (rig.carried_bag as Node2D).visible else "empty"
    var approach := str(rig.get("approach_label", "Dog Runtime"))
    (rig.lane_label as Label).text = "%s\n%s / %s | skeleton: %s | preset: %s | clip: %s | bag: %s" % [
        approach,
        dog_id,
        dog_name,
        str(morphology.get("skeleton_family", "standard_medium")),
        str(profile.get("motion_preset", "curious_helper")),
        str(rig.get("clip", "idle_neutral")),
        socket_state
    ]


func _update_dog_label() -> void:
    var dog_id := str(_active_dog.get("dog_id", "unknown"))
    var dog_name := str(_active_dog.get("public_name", "Dog"))
    var morphology: Dictionary = _active_dog.get("morphology", {})
    var profile: Dictionary = _active_dog.get("animation_profile", {})
    _dog_label.text = "%s / %s | skeleton_family: %s | preset: %s" % [
        dog_id,
        dog_name,
        str(morphology.get("skeleton_family", "standard_medium")),
        str(profile.get("motion_preset", "curious_helper"))
    ]


func _update_perf_label() -> void:
    var fps := Performance.get_monitor(Performance.TIME_FPS)
    var node_count := Performance.get_monitor(Performance.OBJECT_NODE_COUNT)
    var draw_calls := Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME)
    _perf_label.text = "perf: %.0f fps\nnodes: %d\ndraw calls: %d" % [fps, int(node_count), int(draw_calls)]

    if (_stress_mode or _pipeline_mode or _hybrid_mode) and (_auto_quit or _print_perf):
        var prefix := "hybrid_companion" if _hybrid_companion_mode else "hybrid" if _hybrid_mode else "pipeline" if _pipeline_mode else "stress"
        print("%s_perf_fps=%.0f node_count=%d draw_calls=%d" % [prefix, fps, int(node_count), int(draw_calls)])


func _print_start_report() -> void:
    if _hybrid_companion_mode:
        print("Dog Rig Hybrid Companion Perf v3")
    elif _hybrid_mode:
        print("Dog Rig Hybrid Runtime v3")
    elif _pipeline_mode:
        print("Dog Rig Animation Pipeline Comparison v2")
    else:
        print("Dog Rig Morphology Stress v1" if _stress_mode else "Dog Rig Spike v0")

    if _hybrid_companion_mode:
        print("Hybrid companion-like dogs: DOG-PROT-001, DOG-PROT-002, DOG-PROT-003")
    elif _hybrid_mode:
        print("Comparison: procedural Bublik vs hybrid Bublik")
    elif _pipeline_mode:
        print("Comparison: procedural Bublik vs AnimationPlayer-authored Bublik")
    elif _stress_mode:
        print("Active dogs: %s" % ", ".join(STRESS_DOG_IDS))
    else:
        print("Active dog: %s" % str(_active_dog.get("dog_id", "unknown")))
    print("Rig approach: Godot nodes + manual part transforms")
    print("Clips: idle_neutral, walk_empty, walk_carry_medium, pickup_pose, deliver_pose")
    print("Simulated additive layers: tail_wag, head_look, ear_bounce")
    print("Object socket: MouthHarnessSocket -> CarriedFoodBag")
