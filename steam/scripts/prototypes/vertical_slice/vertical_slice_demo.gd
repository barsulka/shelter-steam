class_name ShelterVerticalSliceDemo
extends Control

const StateConnector := preload("res://scripts/dev_tools/godot_state_connector.gd")
const GameSystemsRuntime := preload("res://scripts/game_systems/game_systems_runtime.gd")
const PlayerCheckpointCodec := preload("res://scripts/player/player_checkpoint_codec.gd")

const WINDOW_ID := DisplayServer.MAIN_WINDOW_ID
const COMPANION_SIZE := Vector2i(1120, 224)
const NORMAL_SIZE := Vector2i(1280, 360)
const MIN_SIZE := Vector2i(720, 180)
const WINDOW_MARGIN := 32
const TICK_SECONDS := 0.05
const PERFORMANCE_TICK_SECONDS := 0.5
const MAX_TICK_STEPS_PER_FRAME := 4
const WORLD_WIDTH := 1740.0
const AUTHORED_WORLD_WIDTH := 1536.0
const NON_AUTHORED_TAIL_STITCH_X := 1532.0
const MOUSE_PASSTHROUGH_PADDING := 6.0
const DEFAULT_TIMING_SCALE := 0.72
const FAST_TIMING_SCALE := 0.16
const CAPTURE_FRAME_INTERVAL := 0.25
const DEFAULT_CAPTURE_DIR := "../docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_VERTICAL_SLICE_ART_QA_CAPTURE_v2"
const FIRST_DAY_NEXT_DAY_HINT_TEXT := "Завтра можно придумать, как паковать ещё аккуратнее."
const FIRST_ORDER_ID := "order.first_warm_delivery"
const FIRST_ORDER_TITLE := "Первая тёплая поставка"
const SECOND_ORDER_ID := "order.second_warm_delivery_careful_pack"
const SECOND_ORDER_TITLE := "Аккуратная тёплая поставка"
const WARM_DELIVERY_CHAIN_ID := "chain.warm_food_delivery_intro"
const FIRST_CHAIN_RUN_ID := "run.first_day.first_warm_delivery"
const SECOND_CHAIN_RUN_ID := "run.day2.second_warm_delivery"
const SECOND_DAY_FIXTURE_ID := "second_day_after_first_delivery"
const DAY2_CURIOSITY_QUESTION := "Как паковать мягче?"
const DAY2_COMPLETION_BEAT_SECONDS := 0.8
const CONTROL_CAPTURE_DIR := "res://.runtime/godot_state_connector/control_capture"
const CONTROL_VIDEO_CAPTURE_SECONDS := 10.0
const CONTROL_VIDEO_CAPTURE_FPS := 2.0
const CONTROL_VIDEO_CAPTURE_FRAME_INTERVAL := 1.0 / CONTROL_VIDEO_CAPTURE_FPS

const ZOOM_LEVELS := [0.75, 1.0, 1.25, 1.5]
const ZOOM_LABELS := ["75", "100", "125", "150"]

const ASSET_PATHS := {
    "road_sign": "res://assets/prototypes/vertical_slice/semantic/utility_props/road_sign.png",
    "basket_bicycle": "res://assets/prototypes/vertical_slice/semantic/utility_props/basket_bicycle.png",
    "storage": "res://assets/prototypes/vertical_slice/semantic/buildings/storage.png",
    "kitchen": "res://assets/prototypes/vertical_slice/semantic/buildings/kitchen.png",
    "delivery_van_endpoint": "res://assets/prototypes/vertical_slice/semantic/utility_props/delivery_van_endpoint.png",
    "food_mix_and_food_bag_composite": "res://assets/prototypes/vertical_slice/semantic/resources/food_mix_and_food_bag_composite.png",
}

const AUTHORED_WORLD_LAYER_DIR := "res://assets/prototypes/vertical_slice/authored/world/layers"
const AUTHORED_LABRADOR_LAYER_ROOT := "res://assets/prototypes/vertical_slice/authored/dogs/labrador_intro"
const AUTHORED_WORLD_BASELINE_Y := 211.0
const LABRADOR_SOURCE_ROOT := Vector2(256.0, 280.0)
const LABRADOR_SOURCE_TO_WORLD := 0.24
const LABRADOR_IDENTITY_HEIGHT_PX := 225.0
const LABRADOR_TRACE_PATH := "res://.runtime/labrador_r48_05a/visual_trace.jsonl"
const PACKING_FRONT_SPAN_MASK_STATION_ID := "object.packing_table"
const PACKING_FRONT_SPAN_MASK_SELECTORS := ["D", "F", "G", "EXIT"]
const PACKING_FRONT_SPAN_MASK_HALF_WIDTH_WORLD := 72.0
const PACKING_FRONT_SPAN_MASK_TOP_FROM_BASELINE := -76.0
const PACKING_FRONT_SPAN_MASK_BOTTOM_FROM_BASELINE := 16.0
const LABRADOR_TAIL_PIVOTS := {
    "right": Vector2(94.0, 170.0),
    "left": Vector2(418.0, 170.0),
    "turn_mid": Vector2(363.0, 170.0),
}

const ANCHOR_DEFS := {
    "road_sign": {
        "key": "object.road_sign",
        "label": "Road Sign",
        "taxonomy": "Utility Prop",
        "x": 130.0,
        "max_size": Vector2(82.0, 80.0),
    },
    "storage": {
        "key": "object.storage",
        "label": "Storage",
        "taxonomy": "Building",
        "x": 440.0,
        "max_size": Vector2(148.0, 96.0),
    },
    "kitchen": {
        "key": "object.kitchen",
        "label": "Kitchen",
        "taxonomy": "Building",
        "x": 760.0,
        "max_size": Vector2(126.0, 92.0),
    },
    "packing_table": {
        "key": "object.packing_table",
        "label": "Packing Table",
        "taxonomy": "Utility Prop",
        "x": 1090.0,
        "max_size": Vector2(146.0, 58.0),
        "placeholder": true,
    },
    "delivery_van_endpoint": {
        "key": "object.delivery_van_endpoint",
        "label": "Delivery Van",
        "taxonomy": "Utility Prop",
        "x": 1450.0,
        "max_size": Vector2(154.0, 86.0),
    },
}

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

const RESOURCE_ORDER := [
    "oat_crate",
    "pumpkin_crate",
    "protein_packet",
    "packaging_bag",
    "food_mix",
    "food_bag",
]

const RESOURCE_DEFS := {
    "oat_crate": {
        "key": "resource.oat_crate",
        "name": "Oat Crate",
        "short": "Oat",
        "taxonomy": "Resource",
        "color": Color(0.79, 0.67, 0.42, 1.0),
    },
    "pumpkin_crate": {
        "key": "resource.pumpkin_crate",
        "name": "Pumpkin Crate",
        "short": "Pumpkin",
        "taxonomy": "Resource",
        "color": Color(0.91, 0.54, 0.24, 1.0),
    },
    "protein_packet": {
        "key": "resource.protein_packet",
        "name": "Protein Packet",
        "short": "Protein",
        "taxonomy": "Resource",
        "color": Color(0.68, 0.70, 0.62, 1.0),
    },
    "packaging_bag": {
        "key": "resource.packaging_bag",
        "name": "Packaging Bag",
        "short": "Pack",
        "taxonomy": "Resource",
        "color": Color(0.73, 0.82, 0.78, 1.0),
    },
    "food_mix": {
        "key": "resource.food_mix",
        "name": "Food Mix",
        "short": "Mix",
        "taxonomy": "Resource",
        "color": Color(0.72, 0.50, 0.30, 1.0),
    },
    "food_bag": {
        "key": "resource.food_bag",
        "name": "Food Bag",
        "short": "Food Bag",
        "taxonomy": "Resource",
        "color": Color(0.58, 0.74, 0.50, 1.0),
    },
}

const TASK_TYPE_DEFS := {
    "TripTask": "route.oat_farm_intro + transport.basket_bicycle + dog.dachshund_intro",
    "UnloadTask": "transport payload -> object.storage",
    "CarryTask": "visible resource handoff between objects",
    "CookTask": "object.kitchen creates resource.food_mix",
    "PackTask": "object.packing_table creates resource.food_bag",
    "LoadVanTask": "resource.food_bag -> object.delivery_van_endpoint",
    "DeliveryTask": "player-confirmed order.first_warm_delivery delivery",
    "EquipItemTask": "equipment.comfortable_slippers -> dog.dachshund_intro",
    "IdleTask": "non-blocking dog life when no required task is available",
}

var _textures: Dictionary = {}
var _authored_world_layers: Array[Dictionary] = []
var _authored_labrador_layers: Dictionary = {}
var _labrador_render_state: Dictionary = {
    "lane": "suppressed",
    "selector": "",
}
var _dogs: Dictionary = {}
var _tokens: Dictionary = {}
var _storage_inventory: Dictionary = {}
var _kitchen_inputs: Dictionary = {}
var _packing_inputs: Dictionary = {}

var _task_queue: Array[Dictionary] = []
var _current_task: Dictionary = {}
var _current_step_index := -1
var _step_time := 0.0
var _next_task_number := 1

var _elapsed := 0.0
var _camera_x := 0.0
var _zoom_index := 1
var _target_screen := 0
var _companion_mode := true
var _transparent_window := true
var _always_on_top := true
var _click_through_empty := true
var _show_performance_hud := true
var _show_debug_overlay := true
var _show_semantic_labels := true
var _compact_ui := false
var _view_mode := "qa"
var _ui_hidden := false
var _auto_play := false
var _fast_mode := false
var _auto_quit := false
var _auto_quit_seconds := 12.0
var _timing_scale := DEFAULT_TIMING_SCALE
var _auto_action_gate := 0.0
var _capture_mode := false
var _capture_smoke := false
var _first_day_visible_capture := false
var _first_day_art_ux_capture := false
var _day2_visible_capture := false
var _capture_dir := DEFAULT_CAPTURE_DIR
var _captured_files: Array[String] = []
var _captured_moments: Dictionary = {}
var _capture_busy := false
var _pending_captures: Array[Dictionary] = []
var _capture_frame_time := 0.0
var _capture_frame_index := 0
var _capture_moment_frame_index := 0
var _capture_finish_started := false
var _capture_initializing := false
var _labrador_capture_silhouette := false

var _tick_accumulator := 0.0
var _perf_accumulator := 0.0

var _route_started := false
var _trip_payload_visible := false
var _kitchen_carries_enqueued := false
var _cook_enqueued := false
var _packing_carries_enqueued := false
var _pack_enqueued := false
var _load_van_enqueued := false
var _van_loaded := false
var _delivery_confirmed := false
var _delivery_complete := false
var _postcard_visible := false
var _postcard_claimed := false
var _reward_available := false
var _equip_task_created := false
var _slippers_equipped := false
var _first_day_postcard_life_moment_seen := false
var _first_day_first_memory_added := false
var _first_day_next_day_hint_available := false
var _chain_complete := false
var _runtime_dispatch_confirmation_followup := false
var _first_day_history: Dictionary = {}
var _day2_history: Dictionary = {}
var _active_order: Dictionary = {}
var _active_chain: Dictionary = {}
var _day2: Dictionary = {}
var _day2_completion_beat_remaining := -1.0

var _transport_x := 230.0
var _transport_visible := true
var _transport_state := "parked"
var _transport_has_payload := false
var _delivery_state := "waiting_for_food_bag"
var _order_state := "route_suggested"
var _last_event := "ready"
var _event_log: Array[String] = []
var _state_connector_enabled := false
var _state_connector_tunnel_mode := false
var _state_connector_control_enabled := false
var _state_connector_http_enabled := true
var _state_connector_file_enabled := true
var _state_connector_bind_host := "127.0.0.1"
var _state_connector_port := 8765
var _state_connector_token := ""
var _state_connector_snapshot_file := "res://.runtime/godot_state_connector/state_snapshot.json"
var _state_connector_interval_seconds := 5.0
var _state_connector_window_visible := true
var _state_connector_has_restore_window_geometry := false
var _state_connector_restore_window_position := Vector2i.ZERO
var _state_connector_restore_window_size := Vector2i.ZERO
var _state_connector_hidden_window_position := Vector2i(-100000, -100000)
var _state_connector: Node
var _systems_runtime := GameSystemsRuntime.new()
var _runtime_start_fixture := ""
var _runtime_load_local_save := false
var _player_session_configured := false
var _player_session_started := false
var _player_startup_intent := ""
var _player_checkpoint_codec := PlayerCheckpointCodec.new()
var _player_import_checkpoint: Dictionary = {}
var _player_checkpoint_commit_sink: Callable
var _player_checkpoint_kind := ""
var _player_checkpoint_sequence := 0
var _player_last_committed_checkpoint: Dictionary = {}
var _player_staged_checkpoint: Dictionary = {}
var _player_reconstructed_intents: Array[Dictionary] = []
var _player_checkpoint_barrier_failed := false
var _player_checkpoint_commit_in_progress := false
var _user_args_read := false
var _control_capture_files: Dictionary = {}
var _control_latest_screenshot: Dictionary = {}
var _control_latest_screenshot_file_id := ""
var _control_video_running := false
var _control_video_capture_id := ""
var _control_video_started_at := ""
var _control_video_finished_at := ""
var _control_video_elapsed := 0.0
var _control_video_next_frame_at := 0.0
var _control_video_frame_index := 0
var _control_video_target_frames := 0
var _control_video_frames: Array[Dictionary] = []
var _control_video_last_error := ""

@onready var _labrador_visual_adapter: ShelterLabradorVisualAdapter = $LabradorVisualAdapter

var _order_card: PanelContainer
var _route_card: PanelContainer
var _dog_card: PanelContainer
var _postcard_card: PanelContainer
var _debug_card: PanelContainer
var _performance_label: Label
var _status_label: Label
var _visibility_button: Button
var _semantic_button: Button
var _send_route_button: Button
var _confirm_delivery_button: Button
var _claim_reward_button: Button
var _equip_slippers_button: Button
var _order_label: Label
var _route_label: Label
var _dog_label: Label
var _postcard_label: Label
var _debug_label: Label


func _ready() -> void:
    _player_session_started = true
    mouse_filter = Control.MOUSE_FILTER_STOP
    if _player_session_configured:
        _force_clean_player_configuration()
    else:
        _read_user_args()
    _load_textures()
    _systems_runtime.reset_runtime_state()
    _reset_world_state()
    var player_import_result := {"ok": true}
    if _player_session_configured and _player_startup_intent in ["continue", "begin_day2_return"]:
        player_import_result = import_player_safe_checkpoint(_player_import_checkpoint)
        if not bool(player_import_result.get("ok", false)):
            push_error("Player checkpoint import failed: %s" % str(player_import_result))
            set_process(false)
            return
    else:
        _apply_requested_runtime_start_state()
    _update_labrador_visual(0.0)
    _build_ui()
    _apply_window_settings()
    _update_ui()
    _start_timers()
    if not (_player_session_configured and _player_startup_intent in ["continue", "begin_day2_return"]):
        _emit_event("order_created")

    if _player_session_configured and _player_startup_intent == "fresh_session":
        _commit_player_checkpoint("first_day_offered")
    elif _player_session_configured and _player_startup_intent == "begin_day2_return":
        _begin_persisted_day2_return()
    elif _player_session_configured and _player_startup_intent == "continue":
        _materialize_player_pending_intents(_player_checkpoint_kind)
        if _player_checkpoint_kind == "day2_delivery_response":
            _day2_completion_beat_remaining = DAY2_COMPLETION_BEAT_SECONDS

    var report := _build_report()
    for line in report:
        print(line)

    if _auto_play:
        _auto_action_gate = 0.15

    if _capture_mode:
        _prepare_capture_directories()
        _begin_capture_initial_sequence.call_deferred()

    _setup_state_connector()

    if _auto_quit:
        _start_auto_quit_timeout()


func configure_player_session(configuration: Dictionary) -> Dictionary:
    if _player_session_started or is_inside_tree():
        return {
            "ok": false,
            "error": "player_session_already_started",
        }

    var startup_intent := str(configuration.get("startup_intent", "")).strip_edges()
    if startup_intent not in ["fresh_session", "continue", "begin_day2_return"]:
        return {
            "ok": false,
            "error": "unsupported_startup_intent",
        }

    var commit_sink: Variant = configuration.get("checkpoint_commit_sink")
    if not commit_sink is Callable or not (commit_sink as Callable).is_valid():
        return {
            "ok": false,
            "error": "checkpoint_commit_sink_required",
        }
    var checkpoint: Dictionary = {}
    if startup_intent in ["continue", "begin_day2_return"]:
        if not configuration.get("checkpoint") is Dictionary:
            return {"ok": false, "error": "continue_checkpoint_required"}
        checkpoint = (configuration["checkpoint"] as Dictionary).duplicate(true)
        var checkpoint_validation := _player_checkpoint_codec.validate_checkpoint(checkpoint)
        if not bool(checkpoint_validation.get("ok", false)):
            return {"ok": false, "error": "continue_checkpoint_invalid", "validation": checkpoint_validation}

    _player_session_configured = true
    _player_startup_intent = startup_intent
    _player_checkpoint_commit_sink = commit_sink as Callable
    _player_import_checkpoint = checkpoint
    _force_clean_player_configuration()
    return {
        "ok": true,
        "startup_intent": _player_startup_intent,
    }


func export_player_safe_checkpoint() -> Dictionary:
    if not _player_session_configured or _player_checkpoint_kind == "":
        return {"ok": false, "error": "player_checkpoint_unavailable"}
    var checkpoint := _player_last_committed_checkpoint.duplicate(true)
    if checkpoint.is_empty():
        checkpoint = _build_player_checkpoint(_player_checkpoint_kind, _player_checkpoint_sequence)
    var validation := _player_checkpoint_codec.validate_checkpoint(checkpoint)
    if not bool(validation.get("ok", false)):
        return {"ok": false, "error": "runtime_checkpoint_invalid", "validation": validation, "checkpoint": checkpoint}
    return {"ok": true, "checkpoint": checkpoint.duplicate(true), "validation": validation}


func import_player_safe_checkpoint(checkpoint: Dictionary) -> Dictionary:
    if not _player_session_configured or _player_startup_intent not in ["continue", "begin_day2_return"]:
        return {"ok": false, "error": "checkpoint_import_not_configured"}
    if is_inside_tree() and _player_checkpoint_kind != "":
        return {"ok": false, "error": "checkpoint_import_after_runtime_start"}
    var validation := _player_checkpoint_codec.validate_checkpoint(checkpoint)
    if not bool(validation.get("ok", false)):
        return {"ok": false, "error": "checkpoint_contract_invalid", "validation": validation}
    var normalized_checkpoint := (validation["checkpoint"] as Dictionary).duplicate(true)
    _apply_player_checkpoint(normalized_checkpoint)
    _player_checkpoint_kind = str(validation["checkpoint_kind"])
    _player_checkpoint_sequence = int(validation["checkpoint_sequence"])
    _player_last_committed_checkpoint = normalized_checkpoint
    _emit_event("player_checkpoint_restored", {
        "tag": "system_restore",
        "payload": {
            "checkpoint_kind": _player_checkpoint_kind,
            "checkpoint_sequence": _player_checkpoint_sequence,
        },
    })
    return {
        "ok": true,
        "checkpoint_kind": _player_checkpoint_kind,
        "checkpoint_sequence": _player_checkpoint_sequence,
        "pending_intents": _player_checkpoint_codec.pending_intents(_player_checkpoint_kind),
    }


func retry_player_checkpoint_commit() -> Dictionary:
    if not _player_checkpoint_barrier_failed or _player_staged_checkpoint.is_empty():
        return {"ok": false, "error": "no_failed_checkpoint_commit"}
    return _persist_staged_player_checkpoint()


func _begin_persisted_day2_return() -> Dictionary:
    if _player_checkpoint_kind != "first_day_complete" or _player_checkpoint_sequence != 17:
        return {"ok": false, "error": "day2_transition_precondition_failed"}
    var previous := _player_last_committed_checkpoint.duplicate(true)
    var day2_checkpoint := _player_checkpoint_codec.build_golden_checkpoint("day2_offered")
    if day2_checkpoint.is_empty():
        return {"ok": false, "error": "day2_transition_checkpoint_missing"}
    _apply_player_checkpoint(day2_checkpoint)
    _player_checkpoint_kind = "first_day_complete"
    _player_checkpoint_sequence = 17
    _player_last_committed_checkpoint = previous
    var result := _commit_player_checkpoint("day2_offered")
    return result


func player_checkpoint_snapshot() -> Dictionary:
    return {
        "configured": _player_session_configured,
        "startup_intent": _player_startup_intent,
        "checkpoint_kind": _player_checkpoint_kind,
        "checkpoint_sequence": _player_checkpoint_sequence,
        "barrier_failed": _player_checkpoint_barrier_failed,
        "commit_in_progress": _player_checkpoint_commit_in_progress,
        "staged_kind": str((_player_staged_checkpoint.get("journey", {}) as Dictionary).get("checkpoint_kind", "")),
        "completion_beat_active": _day2_completion_beat_remaining >= 0.0,
        "pending_intents": _player_pending_intent_snapshots(),
        "reconstructed_intents": _player_reconstructed_intents.duplicate(true),
    }


func test_player_event_snapshots() -> Array[Dictionary]:
    if not _player_session_configured:
        return []
    return _systems_runtime.event_snapshots(500)


func test_labrador_visual_snapshot() -> Dictionary:
    var render_world_x := float(_labrador_render_state.get("actor_world_x", (_dogs.get("labrador_intro", {}) as Dictionary).get("x", 0.0)))
    render_world_x += float(_labrador_render_state.get("station_offset_x", 0.0))
    var viewport_size := _viewport_size()
    var zoom := _zoom()
    return {
        "observation": _labrador_visual_observation(),
        "render": _labrador_render_state.duplicate(true),
        "runtime_count": 1,
        "labrador_count": 1 if _dogs.has("labrador_intro") else 0,
        "screen_root": Vector2(_world_to_screen_x(render_world_x), _field_baseline()),
        "zoom": zoom,
        "viewport_size": viewport_size,
        "corridor_framing": {
            "world_min_x": 0.0,
            "authored_world_max_x": AUTHORED_WORLD_WIDTH,
            "non_authored_tail_min_x": AUTHORED_WORLD_WIDTH,
            "world_max_x": WORLD_WIDTH,
            "screen_min_x": _world_to_screen_x(0.0),
            "authored_screen_max_x": _world_to_screen_x(AUTHORED_WORLD_WIDTH),
            "screen_max_x": _world_to_screen_x(WORLD_WIDTH),
            "tail_stitch_overlap_world_units": AUTHORED_WORLD_WIDTH - NON_AUTHORED_TAIL_STITCH_X,
            "authored_tail_claim": false,
        },
        "labrador_scale_readback": {
            "source_to_world": LABRADOR_SOURCE_TO_WORLD,
            "uniform_positive_scale": LABRADOR_SOURCE_TO_WORLD > 0.0,
            "screen_scale": LABRADOR_SOURCE_TO_WORLD * zoom,
            "identity_subject_height_px": LABRADOR_IDENTITY_HEIGHT_PX * LABRADOR_SOURCE_TO_WORLD * zoom,
        },
        "packing_front_span_mask": _packing_front_span_mask_snapshot(),
        "proportional_context": {
            "labrador_screen_x": _world_to_screen_x(render_world_x),
            "kitchen_screen_x": _world_to_screen_x(_anchor_x("kitchen")),
            "packing_table_screen_x": _world_to_screen_x(_anchor_x("packing_table")),
            "delivery_van_screen_x": _world_to_screen_x(_anchor_x("delivery_van_endpoint")),
        },
    }


func test_labrador_observe_snapshot(snapshot: Dictionary, delta: float = TICK_SECONDS) -> Dictionary:
    _labrador_render_state = _labrador_visual_adapter.observe_runtime(snapshot, delta)
    queue_redraw()
    return _labrador_render_state.duplicate(true)


func test_labrador_restore_runtime_observation() -> Dictionary:
    _labrador_visual_adapter.reset_visual_epoch("test_fixture_finished")
    _update_labrador_visual(0.0)
    queue_redraw()
    return _labrador_render_state.duplicate(true)


func test_labrador_step_player_visual() -> Dictionary:
    if not _player_session_configured:
        return {"ok": false, "error": "test_player_session_required"}
    if _player_checkpoint_kind in ["first_day_complete", "quiet_cooperative"]:
        return {"ok": true, "complete": true, "snapshot": test_labrador_visual_snapshot()}
    if _current_task.is_empty() and _task_queue.is_empty():
        match _player_checkpoint_kind:
            "first_day_offered", "day2_offered":
                _start_route_pressed()
            "first_day_ready_to_dispatch", "day2_ready_to_dispatch":
                _confirm_delivery_pressed()
            "first_day_delivery_response":
                _equip_slippers_pressed()
    _on_tick()
    return {
        "ok": not _player_checkpoint_barrier_failed,
        "complete": false,
        "snapshot": test_labrador_visual_snapshot(),
    }


func test_labrador_center_camera() -> Dictionary:
    var world_x := float(_labrador_render_state.get("actor_world_x", (_dogs.get("labrador_intro", {}) as Dictionary).get("x", 0.0)))
    world_x += float(_labrador_render_state.get("station_offset_x", 0.0))
    _camera_x = _clamped_camera_x(world_x - (_visible_world_width() * 0.5))
    queue_redraw()
    return {"ok": true, "camera_x": _camera_x, "world_x": world_x}


func test_labrador_set_capture_ui_hidden(hidden: bool) -> Dictionary:
    _apply_view_mode("player_prototype")
    _ui_hidden = hidden
    _update_ui()
    queue_redraw()
    return {"ok": true, "ui_hidden": _ui_hidden, "semantic_labels": _show_semantic_labels, "debug_overlay": _show_debug_overlay}


func test_labrador_set_capture_silhouette(enabled: bool) -> Dictionary:
    _labrador_capture_silhouette = enabled
    queue_redraw()
    return {"ok": true, "silhouette": _labrador_capture_silhouette}


func test_labrador_enable_trace(path: String) -> Dictionary:
    _labrador_visual_adapter.configure_trace(true, path)
    return {"ok": true, "path": path}


func test_labrador_trace_entries() -> Array[Dictionary]:
    return _labrador_visual_adapter.trace_entries()


func _update_labrador_visual(delta: float) -> void:
    if _labrador_visual_adapter == null or not _dogs.has("labrador_intro"):
        return
    _labrador_render_state = _labrador_visual_adapter.observe_runtime(_labrador_visual_observation(), delta)


func _labrador_visual_observation() -> Dictionary:
    var dog := _dogs.get("labrador_intro", {}) as Dictionary
    var task: Dictionary = {}
    var phase: Dictionary = {}
    if (
        not _current_task.is_empty()
        and str(_current_task.get("assigned_dog_id", "")) == "labrador_intro"
    ):
        task = {
            "id": str(_current_task.get("id", "")),
            "type": str(_current_task.get("type", "")),
            "status": str(_current_task.get("status", "")),
            "order_id": str(_current_task.get("order_id", _active_order_id())),
            "assigned_dog_id": "dog.labrador_intro",
            "source_object_id": _object_key_from_internal(str(_current_task.get("source_object_id", ""))),
            "target_object_id": _object_key_from_internal(str(_current_task.get("target_object_id", ""))),
        }
        phase = _state_current_phase_snapshot(_current_task)
    return {
        "actor": {
            "id": "dog.labrador_intro",
            "internal_id": "labrador_intro",
            "visible": bool(dog.get("visible", true)),
            "current_task": str(dog.get("current_task", "")),
            "current_visible_state": str(dog.get("state", "idle")),
            "world_x": float(dog.get("x", 0.0)),
            "move_start_x": float(dog.get("move_start_x", dog.get("x", 0.0))),
            "move_target_x": float(dog.get("move_target_x", dog.get("x", 0.0))),
        },
        "task": task,
        "phase": phase,
        "active_order": {
            "id": _active_order_id(),
            "delivery_state": _delivery_state,
            "delivery_confirmed": _delivery_confirmed,
            "van_world_x": _anchor_x("delivery_van_endpoint"),
        } if not _active_order.is_empty() else {},
        "active_chain": _active_chain.duplicate(true),
        "journey": {
            "phase": str((_player_last_committed_checkpoint.get("journey", {}) as Dictionary).get("phase", "prototype")),
            "checkpoint_sequence": _player_checkpoint_sequence,
            "barrier_failed": _player_checkpoint_barrier_failed,
        },
        "first_day_history": _first_day_history.duplicate(true),
        "day2_history": _day2_history.duplicate(true),
        "recent_events": _systems_runtime.event_snapshots(80),
    }


func test_advance_player_to_next_checkpoint(max_ticks: int = 2000) -> Dictionary:
    if not _player_session_configured:
        return {"ok": false, "error": "test_player_session_required"}
    var starting_sequence := _player_checkpoint_sequence
    match _player_checkpoint_kind:
        "first_day_offered":
            _start_route_pressed()
        "first_day_ready_to_dispatch":
            _confirm_delivery_pressed()
        "first_day_delivery_response":
            _equip_slippers_pressed()
        "first_day_complete":
            return {"ok": false, "error": "checkpoint_graph_complete"}
        "day2_offered":
            _start_route_pressed()
        "day2_ready_to_dispatch":
            _confirm_delivery_pressed()
        "quiet_cooperative":
            return {"ok": false, "error": "checkpoint_graph_complete"}
    var ticks := 0
    while _player_checkpoint_sequence == starting_sequence and ticks < max_ticks:
        _on_tick()
        ticks += 1
        if _player_checkpoint_barrier_failed:
            return {"ok": false, "error": "checkpoint_barrier_failed", "snapshot": player_checkpoint_snapshot()}
    if _player_checkpoint_sequence != starting_sequence + 1:
        return {"ok": false, "error": "next_checkpoint_not_reached", "ticks": ticks, "snapshot": player_checkpoint_snapshot()}
    return {"ok": true, "ticks": ticks, "snapshot": player_checkpoint_snapshot()}


func test_start_player_pending_task() -> Dictionary:
    if not _player_session_configured:
        return {"ok": false, "error": "player_session_required"}
    if not _current_task.is_empty():
        return {
            "ok": true,
            "checkpoint_sequence": _player_checkpoint_sequence,
            "task_type": str(_current_task.get("type", "")),
            "task_status": str(_current_task.get("status", "")),
        }
    if _task_queue.is_empty():
        return {"ok": false, "error": "pending_player_task_required"}
    var sequence := _player_checkpoint_sequence
    _try_start_next_task()
    if _current_task.is_empty():
        return {"ok": false, "error": "pending_player_task_not_started"}
    return {
        "ok": true,
        "checkpoint_sequence": sequence,
        "task_type": str(_current_task.get("type", "")),
        "task_status": str(_current_task.get("status", "")),
    }


func test_progress_player_pending_task_in_flight() -> Dictionary:
    var started := test_start_player_pending_task()
    if not bool(started.get("ok", false)):
        return started
    var sequence := _player_checkpoint_sequence
    if _current_task.is_empty():
        return {"ok": false, "error": "pending_player_task_not_active"}
    _on_tick()
    if _player_checkpoint_sequence != sequence:
        return {"ok": false, "error": "task_completed_before_inflight_evidence"}
    if _current_task.is_empty() or _step_time <= 0.0:
        return {"ok": false, "error": "task_did_not_progress_in_flight"}
    return {
        "ok": true,
        "checkpoint_sequence": sequence,
        "task_type": str(_current_task.get("type", "")),
        "task_status": str(_current_task.get("status", "")),
        "step_index": _current_step_index,
        "step_time_milliseconds": int(round(_step_time * 1000.0)),
    }


func test_labrador_advance_to_next_checkpoint_visual_trace(max_ticks: int = 5000) -> Dictionary:
    if not _player_session_configured:
        return {"ok": false, "error": "test_player_session_required"}
    var starting_sequence := _player_checkpoint_sequence
    match _player_checkpoint_kind:
        "first_day_offered":
            _start_route_pressed()
        "first_day_ready_to_dispatch":
            _confirm_delivery_pressed()
        "first_day_delivery_response":
            _equip_slippers_pressed()
        "first_day_complete":
            return {"ok": false, "error": "checkpoint_graph_complete"}
        "day2_offered":
            _start_route_pressed()
        "day2_ready_to_dispatch":
            _confirm_delivery_pressed()
        "quiet_cooperative":
            return {"ok": false, "error": "checkpoint_graph_complete"}
    var samples: Array[Dictionary] = []
    samples.append(test_labrador_visual_snapshot())
    var ticks := 0
    while _player_checkpoint_sequence == starting_sequence and ticks < max_ticks:
        _on_tick()
        samples.append(test_labrador_visual_snapshot())
        ticks += 1
        if _player_checkpoint_barrier_failed:
            return {"ok": false, "error": "checkpoint_barrier_failed", "samples": samples}
    if _player_checkpoint_sequence != starting_sequence + 1:
        return {"ok": false, "error": "next_checkpoint_not_reached", "ticks": ticks, "samples": samples}
    return {
        "ok": true,
        "ticks": ticks,
        "starting_sequence": starting_sequence,
        "ending_sequence": _player_checkpoint_sequence,
        "samples": samples,
    }


func _commit_player_checkpoint(kind: String) -> Dictionary:
    if not _player_session_configured:
        return {"ok": false, "error": "player_checkpoint_not_configured"}
    if _player_checkpoint_commit_in_progress:
        return {"ok": false, "error": "checkpoint_commit_in_progress"}
    var expected_sequence := _player_checkpoint_codec.sequence_for_kind(kind)
    if expected_sequence == 0:
        return {"ok": false, "error": "unknown_checkpoint_kind"}
    if expected_sequence != _player_checkpoint_sequence + 1:
        return {
            "ok": false,
            "error": "checkpoint_sequence_jump",
            "current_sequence": _player_checkpoint_sequence,
            "expected_sequence": expected_sequence,
        }
    var checkpoint := _build_player_checkpoint(kind, expected_sequence)
    var validation := _player_checkpoint_codec.validate_checkpoint(checkpoint)
    if not bool(validation.get("ok", false)):
        _player_checkpoint_barrier_failed = true
        return {"ok": false, "error": "runtime_checkpoint_invalid", "validation": validation}
    _player_staged_checkpoint = checkpoint.duplicate(true)
    return _persist_staged_player_checkpoint()


func _persist_staged_player_checkpoint() -> Dictionary:
    if _player_staged_checkpoint.is_empty():
        return {"ok": false, "error": "staged_checkpoint_missing"}
    _player_checkpoint_commit_in_progress = true
    var applying_after_failed_barrier := _player_checkpoint_barrier_failed
    var staged := _player_staged_checkpoint.duplicate(true)
    var previous := _player_last_committed_checkpoint.duplicate(true)
    var sink_result: Dictionary = _player_checkpoint_commit_sink.call(staged.duplicate(true)) as Dictionary
    _player_checkpoint_commit_in_progress = false
    if not bool(sink_result.get("ok", false)):
        if not previous.is_empty():
            _apply_player_checkpoint(previous)
            _player_checkpoint_kind = str((previous["journey"] as Dictionary)["checkpoint_kind"])
            _player_checkpoint_sequence = int((previous["journey"] as Dictionary)["checkpoint_sequence"])
        _player_staged_checkpoint = staged
        _player_checkpoint_barrier_failed = true
        _task_queue.clear()
        _current_task.clear()
        _update_ui()
        return {"ok": false, "error": "checkpoint_persistence_failed", "store_result": sink_result}

    if applying_after_failed_barrier:
        _apply_player_checkpoint(staged)
    var journey := staged["journey"] as Dictionary
    _player_checkpoint_kind = str(journey["checkpoint_kind"])
    _player_checkpoint_sequence = int(journey["checkpoint_sequence"])
    _player_last_committed_checkpoint = staged.duplicate(true)
    _player_staged_checkpoint.clear()
    _player_checkpoint_barrier_failed = false
    _on_player_checkpoint_committed(_player_checkpoint_kind)
    _materialize_player_pending_intents(_player_checkpoint_kind, true)
    _update_ui()
    queue_redraw()
    return {
        "ok": true,
        "checkpoint_kind": _player_checkpoint_kind,
        "checkpoint_sequence": _player_checkpoint_sequence,
        "store_result": sink_result,
    }


func _build_player_checkpoint(kind: String, sequence: int) -> Dictionary:
    var phase := "first_day"
    var active_day := 1
    if kind == "first_day_complete":
        phase = "first_day_complete_hold"
    elif kind == "quiet_cooperative":
        phase = "quiet_cooperative"
        active_day = 2
    elif kind.begins_with("day2_"):
        phase = "day2"
        active_day = 2
    return {
        "format_id": PlayerCheckpointCodec.FORMAT_ID,
        "schema_version": PlayerCheckpointCodec.SCHEMA_VERSION,
        "journey": {
            "phase": phase,
            "checkpoint_kind": kind,
            "checkpoint_sequence": sequence,
            "workflow_cursor": kind,
            "active_day": active_day,
            "transition_version": 1 if active_day == 2 else 0,
            "day2_initialized": active_day == 2,
        },
        "first_day_history": _first_day_history.duplicate(true),
        "day2_history": _day2_history.duplicate(true),
        "active_order": _active_order.duplicate(true),
        "active_chain": _active_chain.duplicate(true),
        "day2": _day2.duplicate(true),
        "resources": _player_checkpoint_resources(),
        "world": {
            "route_started": _route_started,
            "route_payload_returned": _trip_payload_visible,
            "transport_state": _transport_state,
            "transport_has_payload": _transport_has_payload,
            "van_loaded": _van_loaded,
            "delivery_confirmed": _delivery_confirmed,
            "delivery_complete": _delivery_complete,
            "postcard_visible": _postcard_visible,
            "reward_available": _reward_available,
            "slippers_equip_requested": _equip_task_created,
            "slippers_equipped": _slippers_equipped,
        },
    }


func _player_checkpoint_resources() -> Dictionary:
    var resources := {}
    for container in PlayerCheckpointCodec.RESOURCE_CONTAINER_FIELDS:
        var counts := {}
        for resource_id in PlayerCheckpointCodec.RESOURCE_FIELDS:
            counts[resource_id] = 0
        resources[container] = counts
    for resource_id in PlayerCheckpointCodec.RESOURCE_FIELDS:
        (resources["storage"] as Dictionary)[resource_id] = int(_storage_inventory.get(resource_id, 0))
        (resources["kitchen"] as Dictionary)[resource_id] = int(_kitchen_inputs.get(resource_id, 0))
        (resources["packing_table"] as Dictionary)[resource_id] = int(_packing_inputs.get(resource_id, 0))
        if not _tokens.has(resource_id):
            continue
        var token := _tokens[resource_id] as Dictionary
        var location := str(token.get("location", ""))
        if location == "transport_payload":
            (resources["transport_payload"] as Dictionary)[resource_id] = 1
        elif location == "kitchen":
            (resources["kitchen"] as Dictionary)[resource_id] = maxi(int((resources["kitchen"] as Dictionary)[resource_id]), 1)
        elif location == "packing_table":
            (resources["packing_table"] as Dictionary)[resource_id] = maxi(int((resources["packing_table"] as Dictionary)[resource_id]), 1)
        elif location == "delivery_van_endpoint":
            (resources["delivery_van_endpoint"] as Dictionary)[resource_id] = 1
        elif location == "delivered_to_shelter":
            (resources["delivered"] as Dictionary)[resource_id] = 1
    return resources


func _apply_player_checkpoint(checkpoint: Dictionary) -> void:
    var staged := _player_staged_checkpoint.duplicate(true)
    var barrier_failed := _player_checkpoint_barrier_failed
    _reset_world_state()
    _player_staged_checkpoint = staged
    _player_checkpoint_barrier_failed = barrier_failed
    var journey := checkpoint["journey"] as Dictionary
    var resources := checkpoint["resources"] as Dictionary
    var world := checkpoint["world"] as Dictionary
    _player_checkpoint_kind = str(journey["checkpoint_kind"])
    _player_checkpoint_sequence = int(journey["checkpoint_sequence"])
    _first_day_history = (checkpoint["first_day_history"] as Dictionary).duplicate(true)
    _day2_history = (checkpoint.get("day2_history", {"completed": false, "order": {}, "chain": {}}) as Dictionary).duplicate(true)
    _active_order = (checkpoint["active_order"] as Dictionary).duplicate(true)
    _active_chain = (checkpoint["active_chain"] as Dictionary).duplicate(true)
    _day2 = (checkpoint["day2"] as Dictionary).duplicate(true)
    _storage_inventory = (resources["storage"] as Dictionary).duplicate(true)
    _kitchen_inputs = (resources["kitchen"] as Dictionary).duplicate(true)
    _packing_inputs = (resources["packing_table"] as Dictionary).duplicate(true)
    _tokens.clear()
    for container in PlayerCheckpointCodec.RESOURCE_CONTAINER_FIELDS:
        var counts := resources[container] as Dictionary
        for resource_id in PlayerCheckpointCodec.RESOURCE_FIELDS:
            if int(counts.get(resource_id, 0)) <= 0:
                continue
            var location := str(container)
            if container == "delivery_van_endpoint":
                location = "delivery_van_endpoint"
            elif container == "delivered":
                location = "delivered_to_shelter"
            _create_resource_token(resource_id, location, container == "transport_payload")
            if container == "delivered":
                var delivered_token := _tokens[resource_id] as Dictionary
                delivered_token["visible"] = false
                delivered_token["semantic_state"] = "delivered"
                delivered_token["delivery_id"] = SECOND_ORDER_ID if int(journey["active_day"]) == 2 else FIRST_ORDER_ID
    _route_started = bool(world["route_started"])
    _trip_payload_visible = bool(world["route_payload_returned"])
    _transport_state = str(world["transport_state"])
    _transport_has_payload = bool(world["transport_has_payload"])
    _transport_visible = true
    _transport_x = _anchor_x("road_sign") + 92.0
    _van_loaded = bool(world["van_loaded"])
    _delivery_confirmed = bool(world["delivery_confirmed"])
    _delivery_complete = bool(world["delivery_complete"])
    _postcard_visible = bool(world["postcard_visible"])
    _postcard_claimed = _postcard_visible
    _reward_available = bool(world["reward_available"])
    _equip_task_created = bool(world["slippers_equip_requested"])
    _slippers_equipped = bool(world["slippers_equipped"])
    _order_state = str(_active_order.get("status", "completed" if str(journey["phase"]) == "quiet_cooperative" else ""))
    _delivery_state = str(_active_order.get("delivery_state", "delivered" if str(journey["phase"]) == "quiet_cooperative" else ""))
    _chain_complete = bool(_first_day_history["chain_complete"])
    _first_day_postcard_life_moment_seen = bool(_first_day_history["postcard_life_moment_seen"])
    _first_day_first_memory_added = bool(_first_day_history["first_memory_added"])
    _first_day_next_day_hint_available = bool(_first_day_history["next_day_hint_available"])
    if int(journey["active_day"]) == 2:
        _kitchen_carries_enqueued = _player_checkpoint_sequence >= 22
        _cook_enqueued = _player_checkpoint_sequence >= 25
        _packing_carries_enqueued = _player_checkpoint_sequence >= 26
        _pack_enqueued = _player_checkpoint_sequence >= 28
        _load_van_enqueued = _player_checkpoint_sequence >= 29
    else:
        _kitchen_carries_enqueued = _player_checkpoint_sequence >= 5
        _cook_enqueued = _player_checkpoint_sequence >= 8
        _packing_carries_enqueued = _player_checkpoint_sequence >= 9
        _pack_enqueued = _player_checkpoint_sequence >= 11
        _load_van_enqueued = _player_checkpoint_sequence >= 12
    if _slippers_equipped:
        var dachshund := _dogs["dachshund_intro"] as Dictionary
        dachshund["equipment"] = "Удобные тапочки"
        dachshund["state"] = "equipped_with_slippers"
    _task_queue.clear()
    _current_task.clear()
    _current_step_index = -1
    _step_time = 0.0


func _materialize_player_pending_intents(kind: String, emit_creation_events: bool = false) -> void:
    _task_queue.clear()
    _player_reconstructed_intents = _player_checkpoint_codec.pending_intents(kind)
    for intent in _player_reconstructed_intents:
        var task := _task_from_player_intent(intent)
        if task.is_empty():
            push_error("Could not reconstruct player checkpoint intent: %s" % str(intent))
            _player_checkpoint_barrier_failed = true
            _task_queue.clear()
            return
        if emit_creation_events:
            _enqueue_task(task)
        else:
            _task_queue.append(task)


func _on_player_checkpoint_committed(kind: String) -> void:
    match kind:
        "first_day_route_confirmed", "day2_route_confirmed":
            _emit_event("player_confirmed_trip", {"payload": {"order_id": _active_order_id()}})
        "first_day_dispatch_confirmed", "day2_dispatch_confirmed":
            _emit_event("player_confirmed_delivery", {"payload": {"order_id": _active_order_id()}})
        "day2_offered":
            _emit_event("day2_return_moment_seen", {
                "tag": "story",
                "payload": {"order_id": SECOND_ORDER_ID, "transition_version": 1},
            })
        "day2_delivery_response":
            _emit_event("day2_progress_note_revealed", {"payload": {"order_id": SECOND_ORDER_ID}})
            _day2_completion_beat_remaining = DAY2_COMPLETION_BEAT_SECONDS
        "quiet_cooperative":
            _emit_event("day2_curiosity_question_revealed", {
                "tag": "story",
                "payload": {"order_id": SECOND_ORDER_ID, "question": DAY2_CURIOSITY_QUESTION, "optional_hint": true},
            })


func _task_from_player_intent(intent: Dictionary) -> Dictionary:
    var type := str(intent["type"])
    var task: Dictionary = {}
    match type:
        "TripTask":
            task = _create_trip_task()
        "UnloadTask":
            task = _create_unload_task(str(intent["resource_id"]))
        "CarryTask":
            task = _create_carry_task(str(intent["resource_id"]), str(intent["source_object_id"]), str(intent["target_object_id"]))
        "CookTask":
            task = _create_cook_task()
        "PackTask":
            task = _create_pack_task()
        "LoadVanTask":
            task = _create_load_van_task()
        "DeliveryTask":
            task = _create_delivery_task()
        "EquipItemTask":
            task = _create_equip_task()
        _:
            return {}
    for field in ["resource_id", "source_object_id", "target_object_id", "order_id", "created_by", "completion_event", "blocks_order_progress"]:
        if intent.has(field):
            task[field] = intent[field]
    if intent.has("assigned_dog_id"):
        task["assigned_dog_id"] = intent["assigned_dog_id"]
    task["status"] = "queued"
    return task


func _player_pending_intent_snapshots() -> Array[Dictionary]:
    var snapshots: Array[Dictionary] = []
    var tasks: Array[Dictionary] = []
    if not _current_task.is_empty():
        tasks.append(_current_task)
    tasks.append_array(_task_queue)
    for task in tasks:
        var snapshot := {}
        for field in ["type", "resource_id", "source_object_id", "target_object_id", "order_id", "created_by", "completion_event", "status", "blocks_order_progress", "assigned_dog_id"]:
            if task.has(field):
                snapshot[field] = task[field]
        snapshots.append(snapshot)
    return snapshots


func launch_configuration_snapshot() -> Dictionary:
    return {
        "player_session_configured": _player_session_configured,
        "player_session_started": _player_session_started,
        "startup_intent": _player_startup_intent,
        "user_args_read": _user_args_read,
        "view_mode": _view_mode,
        "compact_ui": _compact_ui,
        "debug_overlay": _show_debug_overlay,
        "semantic_labels": _show_semantic_labels,
        "performance_hud": _show_performance_hud,
        "auto_play": _auto_play,
        "fast_mode": _fast_mode,
        "timing_scale": _timing_scale,
        "default_timing_scale": DEFAULT_TIMING_SCALE,
        "runtime_speed_multiplier": _systems_runtime.debug_speed_multiplier,
        "capture_mode": _capture_mode,
        "runtime_start_fixture": _runtime_start_fixture,
        "runtime_load_local_save": _runtime_load_local_save,
        "state_connector_enabled": _state_connector_enabled,
        "state_connector_control_enabled": _state_connector_control_enabled,
        "debug_card_visible": _debug_card != null and _debug_card.visible,
        "performance_label_visible": _performance_label != null and _performance_label.visible,
        "status_label_visible": _status_label != null and _status_label.visible,
        "window_title": get_window().title if is_inside_tree() else "",
    }


func _force_clean_player_configuration() -> void:
    _auto_play = false
    _fast_mode = false
    _auto_quit = false
    _timing_scale = DEFAULT_TIMING_SCALE
    _capture_mode = false
    _capture_smoke = false
    _first_day_visible_capture = false
    _first_day_art_ux_capture = false
    _day2_visible_capture = false
    _capture_initializing = false
    _runtime_start_fixture = ""
    _runtime_load_local_save = false
    _state_connector_enabled = false
    _state_connector_tunnel_mode = false
    _state_connector_control_enabled = false
    _state_connector_http_enabled = true
    _state_connector_file_enabled = true
    _apply_view_mode("player_prototype")


func _notification(what: int) -> void:
    if what == NOTIFICATION_RESIZED:
        _camera_x = _clamped_camera_x(_camera_x)
        _layout_ui()
        _apply_mouse_passthrough()
        queue_redraw()


func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventKey:
        var key_event := event as InputEventKey
        if not key_event.pressed:
            return

        match key_event.keycode:
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
            KEY_H:
                _toggle_ui_hidden()
                get_viewport().set_input_as_handled()
            KEY_D:
                _show_debug_overlay = not _show_debug_overlay
                _update_ui()
                get_viewport().set_input_as_handled()
            KEY_L:
                _show_semantic_labels = not _show_semantic_labels
                _update_ui()
                queue_redraw()
                get_viewport().set_input_as_handled()


func _draw() -> void:
    var baseline := _field_baseline()

    _draw_authored_world_back(baseline)
    _draw_non_authored_corridor_tail(baseline)
    _draw_world_anchors(baseline)
    _draw_transport(baseline)
    _draw_dog_action_lanes(baseline)
    _draw_packing_front_span_underlay(baseline)
    _draw_dogs(baseline)
    _draw_authored_world_front(baseline)
    _draw_resource_tokens(baseline)
    _draw_first_day_readability_cues(baseline)
    _draw_world_state_labels(baseline)


func _read_user_args() -> void:
    _user_args_read = true
    for arg in OS.get_cmdline_user_args():
        if arg == "--vertical-auto-play":
            _auto_play = true
        elif arg == "--vertical-fast":
            _fast_mode = true
            _timing_scale = FAST_TIMING_SCALE
        elif arg == "--vertical-capture":
            _capture_mode = true
            _auto_play = true
            _fast_mode = true
            _timing_scale = FAST_TIMING_SCALE
            _auto_quit = false
            _capture_initializing = true
        elif arg == "--vertical-first-day-visible-capture":
            _capture_mode = true
            _first_day_visible_capture = true
            _auto_play = true
            _fast_mode = true
            _timing_scale = FAST_TIMING_SCALE
            _auto_quit = false
            _capture_initializing = true
        elif arg == "--vertical-first-day-art-ux-capture":
            _capture_mode = true
            _first_day_visible_capture = true
            _first_day_art_ux_capture = true
            _auto_play = true
            _fast_mode = false
            _timing_scale = DEFAULT_TIMING_SCALE
            _auto_quit = false
            _capture_initializing = true
        elif arg == "--vertical-day-2-visible-capture":
            _capture_mode = true
            _day2_visible_capture = true
            _auto_play = true
            _fast_mode = false
            _timing_scale = DEFAULT_TIMING_SCALE
            _auto_quit = false
            _capture_initializing = true
            _runtime_start_fixture = SECOND_DAY_FIXTURE_ID
        elif arg == "--vertical-capture-smoke":
            _capture_mode = true
            _capture_smoke = true
            _auto_play = true
            _fast_mode = true
            _timing_scale = FAST_TIMING_SCALE
            _auto_quit = false
            _capture_initializing = true
        elif arg.begins_with("--vertical-capture-dir="):
            _capture_dir = arg.replace("--vertical-capture-dir=", "").strip_edges()
        elif arg == "--vertical-qa":
            _apply_view_mode("qa")
        elif arg == "--vertical-player-prototype":
            _apply_view_mode("player_prototype")
        elif arg == "--vertical-auto-quit":
            _auto_quit = true
        elif arg.begins_with("--vertical-seconds="):
            _auto_quit_seconds = maxf(arg.replace("--vertical-seconds=", "").to_float(), 1.0)
        elif arg == "--vertical-normal":
            _companion_mode = false
            _transparent_window = false
            _always_on_top = false
        elif arg == "--vertical-no-transparent":
            _transparent_window = false
        elif arg == "--vertical-no-always-on-top":
            _always_on_top = false
        elif arg == "--vertical-no-click-through":
            _click_through_empty = false
        elif arg == "--vertical-no-perf":
            _show_performance_hud = false
        elif arg == "--vertical-no-debug":
            _show_debug_overlay = false
        elif arg == "--vertical-no-labels":
            _show_semantic_labels = false
        elif arg.begins_with("--vertical-screen="):
            _target_screen = maxi(arg.replace("--vertical-screen=", "").to_int(), 0)
        elif arg.begins_with("--vertical-zoom="):
            _zoom_index = _label_to_zoom_index(arg.replace("--vertical-zoom=", ""), _zoom_index)
        elif arg == "--state-connector":
            _state_connector_enabled = true
        elif arg == "--state-connector-tunnel":
            _state_connector_enabled = true
            _state_connector_tunnel_mode = true
            _state_connector_bind_host = "0.0.0.0"
        elif arg == "--state-connector-control":
            _state_connector_enabled = true
            _state_connector_control_enabled = true
        elif arg == "--state-connector-control-tunnel":
            _state_connector_enabled = true
            _state_connector_control_enabled = true
            _state_connector_tunnel_mode = true
            _state_connector_bind_host = "0.0.0.0"
        elif arg == "--state-connector-no-http":
            _state_connector_enabled = true
            _state_connector_http_enabled = false
        elif arg == "--state-connector-no-file":
            _state_connector_enabled = true
            _state_connector_file_enabled = false
        elif arg.begins_with("--state-connector-bind="):
            _state_connector_enabled = true
            _state_connector_bind_host = arg.replace("--state-connector-bind=", "").strip_edges()
        elif arg.begins_with("--state-connector-port="):
            _state_connector_enabled = true
            _state_connector_port = maxi(arg.replace("--state-connector-port=", "").to_int(), 1)
        elif arg.begins_with("--state-connector-token="):
            _state_connector_enabled = true
            _state_connector_token = arg.replace("--state-connector-token=", "").strip_edges()
        elif arg.begins_with("--state-connector-file="):
            _state_connector_enabled = true
            _state_connector_snapshot_file = arg.replace("--state-connector-file=", "").strip_edges()
        elif arg.begins_with("--state-connector-interval="):
            _state_connector_enabled = true
            _state_connector_interval_seconds = maxf(arg.replace("--state-connector-interval=", "").to_float(), 0.5)
        elif arg.begins_with("--runtime-load-fixture="):
            _runtime_start_fixture = arg.replace("--runtime-load-fixture=", "").strip_edges()
        elif arg == "--runtime-load-save":
            _runtime_load_local_save = true


func _load_textures() -> void:
    _textures.clear()
    for asset_id in ASSET_PATHS.keys():
        var path := str(ASSET_PATHS[asset_id])
        var texture := load(path) as Texture2D
        if texture == null:
            push_warning("Could not load Vertical Slice texture: %s" % path)
        _textures[asset_id] = texture
    _load_authored_world_layers()
    _load_authored_labrador_layers()


func _load_authored_world_layers() -> void:
    _authored_world_layers.clear()
    var files := DirAccess.get_files_at(AUTHORED_WORLD_LAYER_DIR)
    files.sort()
    for file_name in files:
        if not file_name.ends_with(".png"):
            continue
        var texture := load("%s/%s" % [AUTHORED_WORLD_LAYER_DIR, file_name]) as Texture2D
        if texture == null:
            push_error("Could not load authored world layer: %s" % file_name)
            continue
        _authored_world_layers.append({
            "file": file_name,
            "index": int(file_name.get_slice("__", 0)),
            "texture": texture,
        })


func _load_authored_labrador_layers() -> void:
    _authored_labrador_layers.clear()
    for facing in ["right", "left", "turn_mid"]:
        var directory := "%s/%s/layers" % [AUTHORED_LABRADOR_LAYER_ROOT, facing]
        var files := DirAccess.get_files_at(directory)
        files.sort()
        var layers: Array[Dictionary] = []
        for file_name in files:
            if not file_name.ends_with(".png"):
                continue
            var texture := load("%s/%s" % [directory, file_name]) as Texture2D
            if texture == null:
                push_error("Could not load authored Labrador layer: %s/%s" % [facing, file_name])
                continue
            layers.append({
                "file": file_name,
                "id": file_name.get_slice("__", 1).trim_suffix(".png"),
                "texture": texture,
            })
        _authored_labrador_layers[facing] = layers


func _reset_world_state() -> void:
    _dogs.clear()
    for dog_id in DOG_DEFS.keys():
        var dog_def := DOG_DEFS[dog_id] as Dictionary
        _dogs[dog_id] = {
            "id": dog_id,
            "x": float(dog_def["start_x"]),
            "visible": true,
            "state": "idle",
            "carried_resource": "",
            "equipment": "",
            "current_task": "",
            "task_label": "IdleTask",
        }

    _tokens.clear()
    _storage_inventory = {
        "protein_packet": 2,
        "packaging_bag": 2,
    }
    _kitchen_inputs.clear()
    _packing_inputs.clear()

    _create_resource_token("protein_packet", "storage", false)
    _create_resource_token("packaging_bag", "storage", false)

    _transport_x = _anchor_x("road_sign") + 92.0
    _transport_visible = true
    _transport_state = "parked"
    _transport_has_payload = false
    _delivery_state = "waiting_for_food_bag"
    _order_state = "route_suggested"
    _route_started = false
    _trip_payload_visible = false
    _kitchen_carries_enqueued = false
    _cook_enqueued = false
    _packing_carries_enqueued = false
    _pack_enqueued = false
    _load_van_enqueued = false
    _van_loaded = false
    _delivery_confirmed = false
    _delivery_complete = false
    _postcard_visible = false
    _postcard_claimed = false
    _reward_available = false
    _equip_task_created = false
    _slippers_equipped = false
    _first_day_postcard_life_moment_seen = false
    _first_day_first_memory_added = false
    _first_day_next_day_hint_available = false
    _chain_complete = false
    _runtime_dispatch_confirmation_followup = false
    _day2_completion_beat_remaining = -1.0
    _first_day_history = _empty_first_day_history()
    _day2_history = {"completed": false, "order": {}, "chain": {}}
    _active_order = {
        "id": FIRST_ORDER_ID,
        "title": FIRST_ORDER_TITLE,
        "status": "route_suggested",
        "status_history": ["route_suggested"],
        "delivery_state": "waiting_for_food_bag",
        "delivery_confirmed": false,
        "completed": false,
        "postcard_created": false,
        "reward_created": false,
        "equip_task_created": false,
    }
    _active_chain = {
        "template_id": WARM_DELIVERY_CHAIN_ID,
        "run_id": FIRST_CHAIN_RUN_ID,
        "state": "not_started",
        "state_history": ["not_started"],
        "current_step": "choose_route",
        "route_id": "route.oat_farm_intro",
        "transport_id": "transport.basket_bicycle",
    }
    _day2 = _empty_day2_state()
    _task_queue.clear()
    _current_task.clear()
    _current_step_index = -1
    _step_time = 0.0
    _next_task_number = 1
    _elapsed = 0.0
    _last_event = "ready"
    _event_log.clear()


func _empty_first_day_history() -> Dictionary:
    return {
        "order_id": FIRST_ORDER_ID,
        "delivery_confirmed": false,
        "postcard_visible": false,
        "reward_available": false,
        "chain_complete": false,
        "postcard_life_moment_seen": false,
        "first_reward_equipped": false,
        "first_memory_added": false,
        "next_day_hint_available": false,
        "dachshund": {
            "slippers_equipped": false,
            "memory_id": null,
            "memory_text": "",
        },
        "packing_note_visible": false,
    }


func _empty_day2_state() -> Dictionary:
    return {
        "return_moment_seen": false,
        "yesterday_postcard_visible": false,
        "dachshund_slippers_visible": false,
        "dachshund_memory_inspectable": false,
        "packing_note_visible": false,
        "second_order_available": false,
        "return_has_no_urgent_prompt": true,
        "absence_penalty_applied": false,
        "labrador_packing_care_moment_seen": false,
        "second_delivery_completed": false,
        "second_feedback_visible": false,
        "curiosity_question_available": false,
        "curiosity_is_optional_hint": false,
        "quiet_end_state_reached": false,
    }


func _is_day2_active() -> bool:
    return str(_active_order.get("id", "")) == SECOND_ORDER_ID


func _is_day2_context() -> bool:
    return _is_day2_active() or bool(_day2_history.get("completed", false))


func _active_order_id() -> String:
    return str(_active_order.get("id", ""))


func _set_active_order_status(status: String) -> void:
    var previous := str(_active_order.get("status", _order_state))
    _active_order["status"] = status
    _order_state = status
    var history: Array = _active_order.get("status_history", []) as Array
    var changed := history.is_empty() or str(history[history.size() - 1]) != status
    if changed:
        history.append(status)
    _active_order["status_history"] = history
    if changed and _is_day2_active():
        _emit_event("active_order_status_changed", {
            "tag": "production_chain",
            "payload": {
                "order_id": _active_order_id(),
                "from": previous,
                "to": status,
            },
        })


func _set_active_delivery_state(state: String) -> void:
    _active_order["delivery_state"] = state
    _delivery_state = state


func _set_active_order_flag(key: String, value: bool) -> void:
    _active_order[key] = value


func _set_active_chain_state(state: String, current_step: String) -> void:
    var previous := str(_active_chain.get("state", "not_started"))
    _active_chain["state"] = state
    _active_chain["current_step"] = current_step
    var history: Array = _active_chain.get("state_history", []) as Array
    var changed := history.is_empty() or str(history[history.size() - 1]) != state
    if changed:
        history.append(state)
    _active_chain["state_history"] = history
    if changed and _is_day2_active():
        _emit_event("active_chain_state_changed", {
            "tag": "production_chain",
            "payload": {
                "order_id": _active_order_id(),
                "run_id": str(_active_chain.get("run_id", SECOND_CHAIN_RUN_ID)),
                "from": previous,
                "to": state,
                "current_step": current_step,
            },
        })


func _reveal_day2_return_moment() -> void:
    if not _is_day2_active() or bool(_day2.get("return_moment_seen", false)):
        return
    _day2["return_moment_seen"] = true
    _emit_event("day2_return_moment_seen", {
        "tag": "story",
        "dog_ids": ["dog.dachshund_intro", "dog.labrador_intro"],
        "place_ids": ["object.packing_table", "object.delivery_van_endpoint"],
        "building_ids": ["object.packing_table", "object.delivery_van_endpoint"],
        "chain_ids": [WARM_DELIVERY_CHAIN_ID],
        "message": "Кооператив спокойно встречает возвращение: вчерашняя открытка, тапочки, память и заметка остаются на месте",
        "payload": {
            "order_id": SECOND_ORDER_ID,
            "return_has_no_urgent_prompt": true,
            "absence_penalty_applied": false,
        },
    })


func _reveal_day2_progress_note() -> void:
    if not _is_day2_active() or bool(_day2.get("second_feedback_visible", false)):
        return
    _day2["second_feedback_visible"] = true
    _emit_event("day2_progress_note_revealed", {
        "tag": "story",
        "place_ids": ["object.delivery_van_endpoint"],
        "building_ids": ["object.delivery_van_endpoint"],
        "chain_ids": [WARM_DELIVERY_CHAIN_ID],
        "message": "На существующей доске появилась спокойная заметка о второй доставке",
        "payload": {
            "order_id": SECOND_ORDER_ID,
            "note_id": "note.day2.second_delivery_progress",
        },
    })
    _day2_completion_beat_remaining = DAY2_COMPLETION_BEAT_SECONDS


func _advance_day2_completion_beat(delta: float) -> void:
    if _day2_completion_beat_remaining < 0.0:
        return
    _day2_completion_beat_remaining = maxf(_day2_completion_beat_remaining - delta, 0.0)
    if _day2_completion_beat_remaining > 0.0:
        return
    _day2_completion_beat_remaining = -1.0
    _reveal_day2_curiosity_question()


func _reveal_day2_curiosity_question() -> void:
    if not _is_day2_active() or bool(_day2.get("curiosity_question_available", false)):
        return
    if not bool(_day2.get("second_feedback_visible", false)):
        return
    _day2["curiosity_question_available"] = true
    _day2["curiosity_is_optional_hint"] = true
    _day2["quiet_end_state_reached"] = true
    if _player_session_configured:
        _day2_history = {
            "completed": true,
            "order": _active_order.duplicate(true),
            "chain": _active_chain.duplicate(true),
        }
        _active_order.clear()
        _active_chain.clear()
        var commit_result := _commit_player_checkpoint("quiet_cooperative")
        if not bool(commit_result.get("ok", false)):
            return
    if not _player_session_configured:
        _emit_event("day2_curiosity_question_revealed", {
        "tag": "story",
        "place_ids": ["object.packing_table"],
        "building_ids": ["object.packing_table"],
        "chain_ids": [WARM_DELIVERY_CHAIN_ID],
        "message": DAY2_CURIOSITY_QUESTION,
        "payload": {
            "order_id": SECOND_ORDER_ID,
            "question": DAY2_CURIOSITY_QUESTION,
            "optional_hint": true,
        },
        })
    if _capture_mode:
        _begin_capture_finish_sequence()
    elif _auto_quit:
        get_tree().quit(0)


func _apply_requested_runtime_start_state() -> void:
    if _runtime_start_fixture != "":
        var fixture_result := _systems_runtime.load_fixture(_runtime_start_fixture)
        if bool(fixture_result.get("ok", false)):
            var payload := fixture_result.get("payload", {}) as Dictionary
            var import_result := _apply_runtime_import_payload(payload)
            if not bool(import_result.get("ok", false)):
                push_error("Runtime fixture import failed: %s" % str(import_result))
        else:
            push_error("Runtime fixture load failed: %s" % str(fixture_result))

    if _runtime_load_local_save:
        var save_result := _systems_runtime.load_local_save()
        if bool(save_result.get("ok", false)):
            var save_payload := save_result.get("payload", {}) as Dictionary
            var import_result := _apply_runtime_import_payload(save_payload)
            if not bool(import_result.get("ok", false)):
                push_error("Runtime local save import failed: %s" % str(import_result))
            else:
                _systems_runtime.active_save_file = str(save_result.get("path", _systems_runtime.local_save_path()))
        else:
            push_error("Runtime local save load failed: %s" % str(save_result))


func _build_ui() -> void:
    _order_card = _make_panel()
    add_child(_order_card)
    var order_layout := _panel_layout(_order_card)
    _order_label = _make_label("", 12)
    order_layout.add_child(_order_label)
    _confirm_delivery_button = _make_button("Подтвердить отправку")
    _confirm_delivery_button.pressed.connect(_confirm_delivery_pressed)
    order_layout.add_child(_confirm_delivery_button)

    _route_card = _make_panel()
    add_child(_route_card)
    var route_layout := _panel_layout(_route_card)
    _route_label = _make_label("", 12)
    route_layout.add_child(_route_label)
    _send_route_button = _make_button("Отправить")
    _send_route_button.pressed.connect(_start_route_pressed)
    route_layout.add_child(_send_route_button)

    _dog_card = _make_panel()
    add_child(_dog_card)
    var dog_layout := _panel_layout(_dog_card)
    _dog_label = _make_label("", 12)
    dog_layout.add_child(_dog_label)
    _equip_slippers_button = _make_button("Надеть тапочки")
    _equip_slippers_button.pressed.connect(_equip_slippers_pressed)
    dog_layout.add_child(_equip_slippers_button)

    _postcard_card = _make_panel(Color(0.20, 0.18, 0.14, 0.94), Color(0.79, 0.66, 0.43, 1.0))
    add_child(_postcard_card)
    var postcard_layout := _panel_layout(_postcard_card)
    _postcard_label = _make_label("", 13)
    postcard_layout.add_child(_postcard_label)
    _claim_reward_button = _make_button("Получить тапочки")
    _claim_reward_button.pressed.connect(_claim_reward_pressed)
    postcard_layout.add_child(_claim_reward_button)

    _debug_card = _make_panel(Color(0.10, 0.12, 0.12, 0.88), Color(0.45, 0.58, 0.52, 1.0))
    add_child(_debug_card)
    var debug_layout := _panel_layout(_debug_card)
    _debug_label = _make_label("", 10)
    debug_layout.add_child(_debug_label)

    _status_label = Label.new()
    _status_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
    _status_label.add_theme_color_override("font_color", Color(0.94, 0.91, 0.78, 1.0))
    _status_label.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.85))
    _status_label.add_theme_constant_override("shadow_offset_x", 1)
    _status_label.add_theme_constant_override("shadow_offset_y", 1)
    add_child(_status_label)

    _performance_label = Label.new()
    _performance_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
    _performance_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
    _performance_label.add_theme_color_override("font_color", Color(0.90, 0.97, 0.88, 1.0))
    _performance_label.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.85))
    _performance_label.add_theme_constant_override("shadow_offset_x", 1)
    _performance_label.add_theme_constant_override("shadow_offset_y", 1)
    add_child(_performance_label)

    _visibility_button = _make_button("Hide UI")
    _visibility_button.pressed.connect(_toggle_ui_hidden)
    add_child(_visibility_button)

    _semantic_button = _make_button("Labels")
    _semantic_button.pressed.connect(_toggle_semantic_labels)
    add_child(_semantic_button)

    _layout_ui()


func _make_panel(bg := Color(0.13, 0.16, 0.14, 0.94), border := Color(0.57, 0.72, 0.55, 1.0)) -> PanelContainer:
    var panel := PanelContainer.new()
    panel.mouse_filter = Control.MOUSE_FILTER_STOP
    var style := StyleBoxFlat.new()
    style.bg_color = bg
    style.border_color = border
    style.set_border_width_all(1)
    style.corner_radius_top_left = 6
    style.corner_radius_top_right = 6
    style.corner_radius_bottom_left = 6
    style.corner_radius_bottom_right = 6
    panel.add_theme_stylebox_override("panel", style)
    return panel


func _panel_layout(panel: PanelContainer) -> VBoxContainer:
    var margin := MarginContainer.new()
    margin.add_theme_constant_override("margin_left", 8)
    margin.add_theme_constant_override("margin_top", 7)
    margin.add_theme_constant_override("margin_right", 8)
    margin.add_theme_constant_override("margin_bottom", 7)
    panel.add_child(margin)

    var layout := VBoxContainer.new()
    layout.add_theme_constant_override("separation", 4)
    margin.add_child(layout)
    return layout


func _make_label(text: String, font_size: int) -> Label:
    var label := Label.new()
    label.text = text
    label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    label.text_overrun_behavior = TextServer.OVERRUN_NO_TRIMMING
    label.add_theme_font_size_override("font_size", font_size)
    label.add_theme_color_override("font_color", Color(0.94, 0.96, 0.90, 1.0))
    return label


func _make_button(text: String) -> Button:
    var button := Button.new()
    button.text = text
    button.add_theme_font_size_override("font_size", 12)
    button.custom_minimum_size = Vector2(82.0, 28.0)
    return button


func _layout_ui() -> void:
    if _order_card == null:
        return

    var viewport_size := _viewport_size()
    var margin := 8.0
    var card_y := 8.0
    var card_h := 92.0

    var order_w := 250.0
    var route_w := 222.0
    var dog_w := 224.0
    var debug_w := 318.0
    var debug_h := 124.0
    var available_w := viewport_size.x - (margin * 2.0)

    if _compact_ui:
        order_w = minf(214.0, available_w * 0.28)
        route_w = minf(176.0, available_w * 0.23)
        dog_w = minf(178.0, available_w * 0.23)
        debug_w = 0.0
        card_h = 60.0
    elif available_w < 920.0:
        order_w = maxf(202.0, available_w * 0.31)
        route_w = maxf(186.0, available_w * 0.27)
        dog_w = maxf(194.0, available_w * 0.28)
        debug_w = minf(284.0, available_w * 0.38)
        card_h = 104.0

    _order_card.position = Vector2(margin, card_y)
    _order_card.size = Vector2(order_w, card_h)

    _route_card.position = Vector2(_order_card.position.x + order_w + margin, card_y)
    _route_card.size = Vector2(route_w, card_h)

    _dog_card.position = Vector2(_route_card.position.x + route_w + margin, card_y)
    _dog_card.size = Vector2(dog_w, card_h)

    _debug_card.size = Vector2(debug_w, debug_h)
    _debug_card.position = Vector2(maxf(margin, viewport_size.x - debug_w - margin), card_y)

    var postcard_w := minf(430.0, available_w)
    _postcard_card.size = Vector2(postcard_w, 118.0)
    _postcard_card.position = Vector2((viewport_size.x - postcard_w) * 0.5, 14.0)

    _status_label.position = Vector2(margin + 4.0, viewport_size.y - 29.0)
    _status_label.size = Vector2(minf(780.0, available_w - 200.0), 22.0)
    _status_label.add_theme_font_size_override("font_size", 12)

    _performance_label.position = Vector2(maxf(margin, viewport_size.x - 360.0 - margin), viewport_size.y - 54.0)
    _performance_label.size = Vector2(360.0, 44.0)
    _performance_label.add_theme_font_size_override("font_size", 10)

    _visibility_button.size = Vector2(82.0, 30.0)
    _visibility_button.position = Vector2(viewport_size.x - 92.0, viewport_size.y - 39.0)

    _semantic_button.size = Vector2(76.0, 30.0)
    _semantic_button.position = Vector2(viewport_size.x - 176.0, viewport_size.y - 39.0)


func _apply_window_settings() -> void:
    var screen_count: int = maxi(DisplayServer.get_screen_count(), 1)
    _target_screen = clampi(_target_screen, 0, screen_count - 1)

    var target_size := _target_window_size()
    var usable_rect := DisplayServer.screen_get_usable_rect(_target_screen)

    get_viewport().transparent_bg = _transparent_window
    get_window().content_scale_size = target_size
    get_window().content_scale_factor = 1.0

    var window_title := "Shelter" if _player_session_configured else "Shelter Vertical Slice Prototype"
    DisplayServer.window_set_title(window_title, WINDOW_ID)
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

    _camera_x = _clamped_camera_x(_camera_x)
    _layout_ui()
    _apply_mouse_passthrough()
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


func _start_timers() -> void:
    _on_performance_tick()


func _process(delta: float) -> void:
    _tick_accumulator += delta
    var tick_budget := MAX_TICK_STEPS_PER_FRAME
    while _tick_accumulator >= TICK_SECONDS and tick_budget > 0:
        _tick_accumulator -= TICK_SECONDS
        _on_tick()
        tick_budget -= 1
    # Bound catch-up after long stalls so a backgrounded frame cannot run an unbounded tick burst.
    if tick_budget == 0 and _tick_accumulator >= TICK_SECONDS:
        _tick_accumulator = fmod(_tick_accumulator, TICK_SECONDS)

    _perf_accumulator += delta
    if _perf_accumulator >= PERFORMANCE_TICK_SECONDS:
        _perf_accumulator -= PERFORMANCE_TICK_SECONDS
        _on_performance_tick()


func _start_auto_quit_timeout() -> void:
    await get_tree().create_timer(_auto_quit_seconds).timeout
    if _chain_complete:
        get_tree().quit(0)
        return

    print("vertical_slice_complete=false")
    push_error("Vertical Slice auto-run did not complete before timeout.")
    get_tree().quit(1)


func _on_tick() -> void:
    if _player_session_configured and (_player_checkpoint_barrier_failed or _player_checkpoint_commit_in_progress):
        _update_labrador_visual(0.0)
        _update_ui()
        return
    var simulation_delta := _systems_runtime.simulation_delta(TICK_SECONDS)
    _elapsed += simulation_delta
    _systems_runtime.advance_research_progress(simulation_delta)
    _advance_current_task(simulation_delta)
    _try_start_next_task()
    _update_idle_dogs()
    _run_auto_play(simulation_delta)
    _run_runtime_dispatch_confirmation_followup()
    _advance_day2_completion_beat(simulation_delta)
    _update_labrador_visual(simulation_delta)

    if not _current_task.is_empty() or _auto_play or _capture_mode or _control_video_running:
        _update_ui()
        queue_redraw()

    _maybe_capture_timeline(TICK_SECONDS)
    _maybe_capture_control_video(TICK_SECONDS)


func _on_performance_tick() -> void:
    if _performance_label == null:
        return

    var fps := Performance.get_monitor(Performance.TIME_FPS)
    var draw_calls := Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME)
    var nodes := Performance.get_monitor(Performance.OBJECT_NODE_COUNT)
    var memory_mb := Performance.get_monitor(Performance.MEMORY_STATIC) / (1024.0 * 1024.0)
    _performance_label.text = "FPS %.0f | draw %.0f | nodes %.0f | mem %.1f MB" % [fps, draw_calls, nodes, memory_mb]


func _run_auto_play(delta: float) -> void:
    if not _auto_play:
        return
    if _capture_initializing:
        return

    _auto_action_gate = maxf(_auto_action_gate - delta, 0.0)
    if _auto_action_gate > 0.0:
        return

    if not _route_started:
        _start_route_pressed()
        _auto_action_gate = 0.2
    elif _van_loaded and not _delivery_confirmed:
        var confirm_moment := "03_day2_van_ready" if _day2_visible_capture else _capture_moment_id("09b_van_ready_confirm_delivery", "12_van_ready_confirm_delivery", "12_van_ready_object_state")
        if _capture_mode and not _captured_moments.has(confirm_moment):
            _schedule_capture(confirm_moment)
            _auto_action_gate = 0.25
            return
        _confirm_delivery_pressed()
        _auto_action_gate = 0.2
    elif _postcard_visible and not _postcard_claimed:
        _claim_reward_pressed()
        _auto_action_gate = 0.2
    elif _reward_available and not _equip_task_created:
        _equip_slippers_pressed()
        _auto_action_gate = 0.2


func _run_runtime_dispatch_confirmation_followup() -> void:
    if not _runtime_dispatch_confirmation_followup:
        return
    if not _delivery_confirmed:
        _runtime_dispatch_confirmation_followup = false
        return
    if _chain_complete:
        _runtime_dispatch_confirmation_followup = false
        return
    if not _current_task.is_empty():
        return

    if _postcard_visible and not _postcard_claimed:
        _claim_reward_pressed()
    elif _reward_available and not _equip_task_created:
        _equip_slippers_pressed()


func _update_idle_dogs() -> void:
    for dog_id in _dogs.keys():
        var dog := _dogs[dog_id] as Dictionary
        if str(dog.get("current_task", "")) != "":
            continue
        if not bool(dog.get("visible", true)):
            continue

        dog["task_label"] = "IdleTask"
        if str(dog.get("state", "")) in ["carrying_item", "unloading", "helping_kitchen", "packing", "loading", "celebrating"]:
            continue

        dog["state"] = "idle"


func _start_route_pressed() -> void:
    if _route_started or (_player_session_configured and (_player_checkpoint_barrier_failed or _player_checkpoint_commit_in_progress)):
        return

    if _is_day2_active():
        _set_active_order_status("route_suggested")
        _set_active_chain_state("route_selected", "create_trip_task")
        _set_active_order_status("missing_resources")
        _set_active_chain_state("trip_active", "trip_to_oat_farm")
    else:
        _set_active_order_status("trip_active")
    _route_started = true
    if _player_session_configured:
        _commit_player_checkpoint("day2_route_confirmed" if _is_day2_active() else "first_day_route_confirmed")
    else:
        _emit_event("player_confirmed_trip")
        _enqueue_task(_create_trip_task())
    _update_ui()


func _confirm_delivery_pressed() -> void:
    if not _van_loaded or _delivery_confirmed or (_player_session_configured and (_player_checkpoint_barrier_failed or _player_checkpoint_commit_in_progress)):
        return

    _delivery_confirmed = true
    _set_active_order_flag("delivery_confirmed", true)
    if _player_session_configured:
        _set_active_delivery_state("sending")
        _set_active_order_status("sent")
        _set_active_chain_state("dispatched", "delivery")
        _commit_player_checkpoint("day2_dispatch_confirmed" if _is_day2_active() else "first_day_dispatch_confirmed")
    else:
        _emit_event("player_confirmed_delivery")
        _enqueue_task(_create_delivery_task())
        _set_active_delivery_state("sending")
        _set_active_order_status("sent")
        _set_active_chain_state("dispatched", "delivery")
    _update_ui()


func _claim_reward_pressed() -> void:
    if not _postcard_visible or _postcard_claimed:
        return

    _postcard_claimed = true
    _reward_available = true
    _set_active_order_flag("reward_created", true)
    _set_active_order_status("reward_claimed")
    _emit_event("reward_created")
    _emit_event("dog_received_reward", {
        "tag": "dog_action",
        "dog_ids": ["dog.dachshund_intro"],
        "place_ids": ["ui.postcard_card"],
        "building_ids": ["ui.postcard_card"],
        "chain_ids": ["chain.warm_food_delivery_intro"],
        "message": "Такса получила первые удобные тапочки за тёплую поставку",
        "payload": {
            "reward_id": "equipment.comfortable_slippers",
            "order_id": "order.first_warm_delivery",
            "moment_id": "first_day_reward_received",
        },
    })
    _sync_first_day_history_from_runtime()
    _update_ui()


func _equip_slippers_pressed() -> void:
    if not _reward_available or _equip_task_created or _slippers_equipped or (_player_session_configured and (_player_checkpoint_barrier_failed or _player_checkpoint_commit_in_progress)):
        return

    _equip_task_created = true
    _set_active_order_flag("equip_task_created", true)
    if _player_session_configured:
        _commit_player_checkpoint("first_day_equip_confirmed")
    else:
        _enqueue_task(_create_equip_task())
    _update_ui()


func _toggle_ui_hidden() -> void:
    _ui_hidden = not _ui_hidden
    _visibility_button.text = "Show UI" if _ui_hidden else "Hide UI"
    _update_ui()
    _apply_mouse_passthrough()


func _toggle_semantic_labels() -> void:
    _show_semantic_labels = not _show_semantic_labels
    _semantic_button.text = "Labels" if _show_semantic_labels else "No labels"
    _update_ui()
    queue_redraw()


func _apply_view_mode(mode: String) -> void:
    _view_mode = mode
    match mode:
        "player_prototype":
            _compact_ui = true
            _show_debug_overlay = false
            _show_semantic_labels = false
            _show_performance_hud = false
        _:
            _view_mode = "qa"
            _compact_ui = false
            _show_debug_overlay = true
            _show_semantic_labels = true
            _show_performance_hud = true

    _ui_hidden = false
    if _order_label != null:
        _update_ui()
    queue_redraw()


func _enqueue_task(task: Dictionary) -> void:
    _task_queue.append(task)
    var type := str(task.get("type", "Task"))
    var task_event_details := {
        "payload": {
            "order_id": str(task.get("order_id", _active_order_id())),
            "task_id": str(task.get("id", "")),
            "task_type": type,
        },
    }
    _emit_event("task_created", task_event_details)
    match type:
        "TripTask":
            _emit_event("trip_task_created", task_event_details)
        "UnloadTask":
            _emit_event("unload_task_created:%s" % str(task.get("resource_id", "")))
        "CarryTask":
            _emit_event("carry_task_created:%s:%s->%s" % [
                str(task.get("resource_id", "")),
                str(task.get("source_object_id", "")),
                str(task.get("target_object_id", "")),
            ])
        "CookTask":
            _emit_event("cook_task_created")
        "PackTask":
            _emit_event("pack_task_created")
        "LoadVanTask":
            _emit_event("load_van_task_created")
        "DeliveryTask":
            _emit_event("delivery_task_created", task_event_details)


func _try_start_next_task() -> void:
    if _player_session_configured and (_player_checkpoint_barrier_failed or _player_checkpoint_commit_in_progress):
        return
    if not _current_task.is_empty() or _task_queue.is_empty():
        return

    _current_task = _task_queue.pop_front()
    _assign_task_dog(_current_task)
    _current_step_index = -1
    _step_time = 0.0
    _record_task_started(_current_task)
    _advance_to_next_step()


func _record_task_started(task: Dictionary) -> void:
    if not _is_day2_active():
        return
    match str(task.get("type", "")):
        "TripTask":
            _set_active_order_status("missing_resources")
            _set_active_chain_state("trip_active", "depart_or_return")
        "UnloadTask":
            _set_active_chain_state("unloading", "unload_to_storage")
        "CarryTask":
            var source := str(task.get("source_object_id", ""))
            var target := str(task.get("target_object_id", ""))
            if source == "storage" and target == "kitchen":
                _set_active_chain_state("inputs_to_kitchen", "carry_ingredients_to_kitchen")
            elif target == "packing_table":
                _set_active_chain_state("moving_to_packing", "carry_inputs_to_packing")
        "LoadVanTask":
            _set_active_chain_state("loading_van", "load_food_bag_into_van")


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

    var dog := _dogs[dog_id] as Dictionary
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
    if _current_task.is_empty():
        return

    if _current_step_index < 0:
        _advance_to_next_step()
        return

    var steps := _current_task.get("steps", []) as Array
    if _current_step_index >= steps.size():
        _complete_current_task()
        return

    var step := steps[_current_step_index] as Dictionary
    _step_time += delta
    _apply_step_motion(step)

    if _step_time >= _step_duration(step):
        _run_step_operation(str(step.get("on_complete", "")), _current_task)
        _advance_to_next_step()


func _advance_to_next_step() -> void:
    var steps := _current_task.get("steps", []) as Array
    _current_step_index += 1
    _step_time = 0.0

    if _current_step_index >= steps.size():
        _complete_current_task()
        return

    var step := steps[_current_step_index] as Dictionary
    _set_current_task_status(str(step.get("status", "in_progress")))
    _prepare_step_motion(step)
    _run_step_operation(str(step.get("on_start", "")), _current_task)


func _set_current_task_status(status: String) -> void:
    _current_task["status"] = status
    var dog_id := str(_current_task.get("assigned_dog_id", ""))
    if dog_id != "" and _dogs.has(dog_id):
        var dog := _dogs[dog_id] as Dictionary
        dog["task_label"] = "%s:%s" % [str(_current_task.get("type", "Task")), status]


func _prepare_step_motion(step: Dictionary) -> void:
    var dog_id := str(_current_task.get("assigned_dog_id", ""))
    if dog_id != "" and _dogs.has(dog_id):
        var dog := _dogs[dog_id] as Dictionary
        dog["state"] = str(step.get("dog_state", dog.get("state", "idle")))
        if step.has("move_dog_to"):
            dog["move_start_x"] = float(dog.get("x", 0.0))
            dog["move_target_x"] = _resolve_world_x(step["move_dog_to"])

    if step.has("move_transport_to"):
        _current_task["transport_move_start_x"] = _transport_x
        _current_task["transport_move_target_x"] = _resolve_world_x(step["move_transport_to"])


func _apply_step_motion(step: Dictionary) -> void:
    var duration := _step_duration(step)
    var t := clampf(_step_time / duration, 0.0, 1.0)

    var dog_id := str(_current_task.get("assigned_dog_id", ""))
    if dog_id != "" and _dogs.has(dog_id) and step.has("move_dog_to"):
        var dog := _dogs[dog_id] as Dictionary
        dog["x"] = lerpf(float(dog.get("move_start_x", dog.get("x", 0.0))), float(dog.get("move_target_x", dog.get("x", 0.0))), t)

    if step.has("move_transport_to"):
        _transport_x = lerpf(
            float(_current_task.get("transport_move_start_x", _transport_x)),
            float(_current_task.get("transport_move_target_x", _transport_x)),
            t
        )
        if dog_id != "" and _dogs.has(dog_id):
            var transport_dog := _dogs[dog_id] as Dictionary
            transport_dog["x"] = _transport_x - 24.0


func _step_duration(step: Dictionary) -> float:
    return maxf(float(step.get("duration", 0.1)) * _timing_scale, 0.02)


func _complete_current_task() -> void:
    if _current_task.is_empty():
        return

    _current_task["status"] = "complete"
    var dog_id := str(_current_task.get("assigned_dog_id", ""))
    if dog_id != "" and _dogs.has(dog_id):
        var dog := _dogs[dog_id] as Dictionary
        dog["current_task"] = ""
        dog["task_label"] = "IdleTask"
        if str(dog.get("carried_resource", "")) == "":
            dog["state"] = "idle"

    var completed_task := _current_task.duplicate(true)
    _current_task.clear()
    _current_step_index = -1
    _step_time = 0.0

    _handle_task_completed(completed_task)


func _handle_task_completed(task: Dictionary) -> void:
    if _player_session_configured:
        _handle_player_task_completed(task)
        return
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
            _van_loaded = true
            _set_active_delivery_state("ready_to_send")
            _set_active_order_status("loaded")
            _set_active_chain_state("ready_to_dispatch", "player_confirms_dispatch")
            _emit_event("van_ready_object_state_visible", {
                "tag": "story",
                "dog_ids": ["dog.labrador_intro"],
                "place_ids": ["object.delivery_van_endpoint"],
                "building_ids": ["object.delivery_van_endpoint"],
                "chain_ids": ["chain.warm_food_delivery_intro"],
                "message": "Фургон показывает готовность через открытый кузов и видимый Food Bag",
                "payload": {
                    "order_id": _active_order_id(),
                    "resource_id": "resource.food_bag",
                    "moment_id": "day2_van_ready_object_state" if _is_day2_active() else "first_day_van_ready_object_state",
                },
            })
        "DeliveryTask":
            _delivery_complete = true
            _set_active_order_flag("completed", true)
            _set_active_order_status("completed")
            _set_active_delivery_state("delivered")
            _mark_food_bag_delivered()
            if _is_day2_active():
                _day2["second_delivery_completed"] = true
                _set_active_chain_state("completed", "complete")
                _chain_complete = true
                _reveal_day2_progress_note()
                print("vertical_slice_complete=true")
            else:
                _postcard_visible = true
                _set_active_order_flag("postcard_created", true)
                _emit_event("postcard_created")
                _record_first_day_post_delivery_moment()
        "EquipItemTask":
            _chain_complete = true
            _set_active_chain_state("completed", "complete")
            _record_first_day_post_delivery_moment()
            _sync_first_day_history_from_runtime()
            print("vertical_slice_complete=true")
            if _capture_mode:
                _begin_capture_finish_sequence()
            elif _auto_quit:
                get_tree().quit(0)


func _handle_player_task_completed(task: Dictionary) -> void:
    var type := str(task.get("type", ""))
    var resource_id := str(task.get("resource_id", ""))
    var target := str(task.get("target_object_id", ""))
    var checkpoint_kind := ""
    var day2_player := _is_day2_active()
    match type:
        "TripTask":
            checkpoint_kind = "day2_payload_returned" if day2_player else "first_day_payload_returned"
        "UnloadTask":
            if resource_id == "oat_crate":
                checkpoint_kind = "day2_oat_stored" if day2_player else "first_day_oat_stored"
            elif resource_id == "pumpkin_crate":
                _transport_has_payload = false
                _transport_state = "parked"
                _set_active_order_status("resources_available")
                _set_active_chain_state("stored", "storage_ready")
                _set_active_chain_state("inputs_to_kitchen", "carry_ingredients_to_kitchen")
                checkpoint_kind = "day2_resources_available" if day2_player else "first_day_resources_available"
        "CarryTask":
            if target == "kitchen":
                if resource_id == "oat_crate":
                    checkpoint_kind = "day2_oat_in_kitchen" if day2_player else "first_day_oat_in_kitchen"
                elif resource_id == "pumpkin_crate":
                    checkpoint_kind = "day2_pumpkin_in_kitchen" if day2_player else "first_day_pumpkin_in_kitchen"
                elif resource_id == "protein_packet":
                    checkpoint_kind = "day2_inputs_in_kitchen" if day2_player else "first_day_inputs_in_kitchen"
            elif target == "packing_table":
                if resource_id == "food_mix":
                    checkpoint_kind = "day2_food_mix_at_packing" if day2_player else "first_day_food_mix_at_packing"
                elif resource_id == "packaging_bag":
                    _set_active_chain_state("packing_ready", "packing_table_ready")
                    checkpoint_kind = "day2_inputs_at_packing" if day2_player else "first_day_inputs_at_packing"
        "CookTask":
            _set_active_order_status("production_in_progress")
            _set_active_chain_state("moving_to_packing", "carry_inputs_to_packing")
            checkpoint_kind = "day2_food_mix_ready" if day2_player else "first_day_food_mix_ready"
        "PackTask":
            _set_active_order_status("packed")
            checkpoint_kind = "day2_food_bag_ready" if day2_player else "first_day_food_bag_ready"
        "LoadVanTask":
            _van_loaded = true
            _set_active_delivery_state("ready_to_send")
            _set_active_order_status("loaded")
            _set_active_chain_state("ready_to_dispatch", "player_confirms_dispatch")
            checkpoint_kind = "day2_ready_to_dispatch" if day2_player else "first_day_ready_to_dispatch"
        "DeliveryTask":
            _delivery_complete = true
            _set_active_order_flag("completed", true)
            _set_active_order_status("completed")
            _set_active_delivery_state("delivered")
            _mark_food_bag_delivered()
            if day2_player:
                _day2["second_delivery_completed"] = true
                _set_active_chain_state("completed", "complete")
                _chain_complete = true
                _day2["second_feedback_visible"] = true
                checkpoint_kind = "day2_delivery_response"
            else:
                _postcard_visible = true
                _postcard_claimed = true
                _reward_available = true
                _set_active_order_flag("postcard_created", true)
                _set_active_order_flag("reward_created", true)
                _emit_event("postcard_created")
                _emit_event("reward_created")
                _record_first_day_post_delivery_moment()
                checkpoint_kind = "first_day_delivery_response"
        "EquipItemTask":
            _chain_complete = true
            _set_active_chain_state("completed", "complete")
            _record_first_day_post_delivery_moment()
            _sync_first_day_history_from_runtime()
            checkpoint_kind = "first_day_complete"
    if checkpoint_kind == "":
        push_error("No player checkpoint mapping for completed task: %s" % str(task))
        _player_checkpoint_barrier_failed = true
        return
    var commit_result := _commit_player_checkpoint(checkpoint_kind)
    if not bool(commit_result.get("ok", false)):
        push_error("Player checkpoint commit failed after task: %s" % str(commit_result))
    if bool(commit_result.get("ok", false)) and checkpoint_kind == "first_day_complete":
        print("vertical_slice_complete=true")


func _run_step_operation(operation: String, task: Dictionary) -> void:
    if operation == "":
        return

    match operation:
        "transport_preparing":
            _transport_state = "preparing"
        "transport_left":
            _transport_state = "away"
            _transport_visible = false
            _set_dog_visible(str(task.get("assigned_dog_id", "")), false)
            _emit_event("transport_left_strip")
            _emit_task_dog_action("dog_departed_with_bicycle", task, "Такса уехала за первой тёплой поставкой", {
                "activity_detail": "route_departure",
                "transport_id": "transport.basket_bicycle",
            })
        "trip_timer_started":
            _transport_state = "away"
            _emit_event("trip_timer_started")
        "trip_timer_complete":
            _emit_event("trip_timer_complete")
        "transport_return_start":
            _transport_state = "returning"
            _transport_x = _resolve_world_x("offscreen_left")
            _transport_visible = true
            _set_dog_visible(str(task.get("assigned_dog_id", "")), true)
        "transport_returned":
            _transport_state = "waiting_for_unload"
            _emit_event("transport_returned")
            _emit_task_dog_action("dog_returned_with_payload", task, "Такса вернулась с корзиной продуктов", {
                "activity_detail": "route_return_with_payload",
                "transport_id": "transport.basket_bicycle",
                "resources": ["resource.oat_crate", "resource.pumpkin_crate"],
            })
        "create_trip_payload":
            _create_trip_payload()
        "pickup_resource":
            _pickup_resource_for_task(task)
        "place_resource":
            _place_resource_for_task(task)
        "start_cooking":
            _set_active_order_status("production_in_progress")
            _set_active_chain_state("cooking", "prepare_food_mix")
            _emit_task_dog_action("dog_started_cooking", task, "Лабрадор начал готовить food mix", {
                "activity_detail": "cooking_food_mix",
            })
        "complete_cooking":
            _complete_cooking()
        "start_packing":
            _set_active_order_status("production_in_progress")
            _set_active_chain_state("packing", "pack_food_bag")
            if _is_day2_active() and not bool(_day2.get("labrador_packing_care_moment_seen", false)):
                _day2["labrador_packing_care_moment_seen"] = true
                _emit_event("labrador_packing_care_moment", {
                    "tag": "dog_action",
                    "dog_ids": ["dog.labrador_intro"],
                    "place_ids": ["object.packing_table"],
                    "building_ids": ["object.packing_table"],
                    "chain_ids": [WARM_DELIVERY_CHAIN_ID],
                    "message": "Лабрадор помогает упаковать аккуратнее; это забота, не quality score или profit bonus",
                    "payload": {
                        "order_id": SECOND_ORDER_ID,
                        "task_id": str(task.get("id", "")),
                        "task_status": str(task.get("status", "")),
                        "assigned_dog_id": "dog.labrador_intro",
                    },
                })
            _emit_task_dog_action("dog_started_packing", task, "Лабрадор начал собирать Food Bag", {
                "activity_detail": "packing_food_bag",
            })
        "complete_packing":
            _complete_packing()
        "start_delivery":
            if not _is_day2_active():
                _set_active_delivery_state("leaving_or_sending")
        "complete_delivery":
            _emit_event("delivery_complete")
        "complete_equipment":
            _complete_equipment()


func _create_trip_task() -> Dictionary:
    return _new_task("TripTask", {
        "source_object_id": "road_sign",
        "target_object_id": "road_sign",
        "assigned_dog_id": "dachshund_intro",
        "transport_id": "basket_bicycle",
        "route_id": "route.oat_farm_intro",
        "order_id": _active_order_id(),
        "completion_event": "trip_returned_with_payload",
        "steps": [
            {
                "status": "moving_to_source",
                "duration": 0.78,
                "move_dog_to": "basket_bicycle",
                "dog_state": "moving_to_transport",
            },
            {
                "status": "in_progress",
                "duration": 0.44,
                "dog_state": "preparing_transport",
                "on_start": "transport_preparing",
            },
            {
                "status": "in_progress",
                "duration": 0.86,
                "move_dog_to": "offscreen_left",
                "move_transport_to": "offscreen_left",
                "dog_state": "leaving_with_transport",
                "on_complete": "transport_left",
            },
            {
                "status": "in_progress",
                "duration": 1.55,
                "dog_state": "away_on_trip",
                "on_start": "trip_timer_started",
                "on_complete": "trip_timer_complete",
            },
            {
                "status": "in_progress",
                "duration": 0.88,
                "move_dog_to": "basket_bicycle",
                "move_transport_to": "basket_bicycle",
                "dog_state": "returning_with_transport",
                "on_start": "transport_return_start",
                "on_complete": "transport_returned",
            },
            {
                "status": "completing",
                "duration": 0.36,
                "dog_state": "unloading_or_waiting",
                "on_complete": "create_trip_payload",
            },
        ],
    })


func _create_unload_task(resource_id: String) -> Dictionary:
    return _new_task("UnloadTask", {
        "source_object_id": "basket_bicycle",
        "target_object_id": "storage",
        "resource_id": resource_id,
        "completion_event": "resource_added_to_storage",
        "steps": [
            {
                "status": "moving_to_source",
                "duration": 0.54,
                "move_dog_to": "transport_payload",
                "dog_state": "moving_to_cargo",
            },
            {
                "status": "in_progress",
                "duration": 0.30,
                "dog_state": "unloading",
                "on_start": "pickup_resource",
            },
            {
                "status": "moving_to_target",
                "duration": 0.78,
                "move_dog_to": "storage",
                "dog_state": "carrying_item",
            },
            {
                "status": "completing",
                "duration": 0.30,
                "dog_state": "unloading",
                "on_complete": "place_resource",
            },
        ],
    })


func _create_carry_task(resource_id: String, source_object_id: String, target_object_id: String) -> Dictionary:
    return _new_task("CarryTask", {
        "source_object_id": source_object_id,
        "target_object_id": target_object_id,
        "resource_id": resource_id,
        "completion_event": "resource_delivered",
        "steps": [
            {
                "status": "moving_to_source",
                "duration": 0.52,
                "move_dog_to": source_object_id,
                "dog_state": "walking",
            },
            {
                "status": "in_progress",
                "duration": 0.26,
                "dog_state": "carrying_item",
                "on_start": "pickup_resource",
            },
            {
                "status": "moving_to_target",
                "duration": 0.76,
                "move_dog_to": target_object_id,
                "dog_state": "carrying_item",
            },
            {
                "status": "completing",
                "duration": 0.28,
                "dog_state": "carrying_item",
                "on_complete": "place_resource",
            },
        ],
    })


func _create_cook_task() -> Dictionary:
    return _new_task("CookTask", {
        "source_object_id": "kitchen",
        "target_object_id": "kitchen",
        "completion_event": "food_mix_created",
        "steps": [
            {
                "status": "moving_to_source",
                "duration": 0.45,
                "move_dog_to": "kitchen",
                "dog_state": "walking",
            },
            {
                "status": "in_progress",
                "duration": 1.18,
                "dog_state": "helping_kitchen",
                "on_start": "start_cooking",
            },
            {
                "status": "completing",
                "duration": 0.26,
                "dog_state": "helping_kitchen",
                "on_complete": "complete_cooking",
            },
        ],
    })


func _create_pack_task() -> Dictionary:
    return _new_task("PackTask", {
        "source_object_id": "packing_table",
        "target_object_id": "packing_table",
        "completion_event": "food_bag_created",
        "steps": [
            {
                "status": "moving_to_source",
                "duration": 0.45,
                "move_dog_to": "packing_table",
                "dog_state": "walking",
            },
            {
                "status": "in_progress",
                "duration": 1.00,
                "dog_state": "packing",
                "on_start": "start_packing",
            },
            {
                "status": "completing",
                "duration": 0.25,
                "dog_state": "packing",
                "on_complete": "complete_packing",
            },
        ],
    })


func _create_load_van_task() -> Dictionary:
    return _new_task("LoadVanTask", {
        "source_object_id": "packing_table",
        "target_object_id": "delivery_van_endpoint",
        "resource_id": "food_bag",
        "completion_event": "van_loaded",
        "steps": [
            {
                "status": "moving_to_source",
                "duration": 0.52,
                "move_dog_to": "packing_table",
                "dog_state": "walking",
            },
            {
                "status": "in_progress",
                "duration": 0.26,
                "dog_state": "carrying_item",
                "on_start": "pickup_resource",
            },
            {
                "status": "moving_to_target",
                "duration": 0.82,
                "move_dog_to": "delivery_van_endpoint",
                "dog_state": "carrying_item",
            },
            {
                "status": "completing",
                "duration": 0.34,
                "dog_state": "loading",
                "on_complete": "place_resource",
            },
        ],
    })


func _create_delivery_task() -> Dictionary:
    return _new_task("DeliveryTask", {
        "order_id": _active_order_id(),
        "completion_event": "delivery_complete",
        "steps": [
            {
                "status": "in_progress",
                "duration": 0.92,
                "on_start": "start_delivery",
            },
            {
                "status": "complete",
                "duration": 0.18,
                "on_complete": "complete_delivery",
            },
        ],
    })


func _create_equip_task() -> Dictionary:
    return _new_task("EquipItemTask", {
        "source_object_id": "postcard_card",
        "target_object_id": "dachshund_intro",
        "resource_id": "equipment.comfortable_slippers",
        "completion_event": "reward_equipped",
        "steps": [
            {
                "status": "moving_to_source",
                "duration": 0.20,
                "move_dog_to": "road_sign",
                "dog_state": "walking",
            },
            {
                "status": "in_progress",
                "duration": 0.58,
                "dog_state": "celebrating",
            },
            {
                "status": "completing",
                "duration": 0.22,
                "dog_state": "celebrating",
                "on_complete": "complete_equipment",
            },
        ],
    })


func _new_task(type: String, data: Dictionary) -> Dictionary:
    var task := data.duplicate(true)
    task["id"] = "%s_%03d" % [type, _next_task_number]
    task["type"] = type
    task["status"] = "queued"
    task["created_by"] = _task_creator(type)
    task["blocks_order_progress"] = type != "IdleTask"
    if type != "IdleTask" and not task.has("order_id"):
        task["order_id"] = _active_order_id()
    _next_task_number += 1
    return task


func _task_creator(type: String) -> String:
    match type:
        "TripTask":
            return "object.road_sign"
        "UnloadTask":
            return "TripTask"
        "CarryTask":
            return "object.storage/object.kitchen/object.packing_table"
        "CookTask":
            return "object.kitchen"
        "PackTask":
            return "object.packing_table"
        "LoadVanTask":
            return "object.delivery_van_endpoint"
        "DeliveryTask":
            return "player_confirmed_delivery"
        "EquipItemTask":
            return "player_equips_reward"
        _:
            return "prototype_scheduler"


func _create_resource_token(resource_id: String, location: String, from_payload: bool) -> void:
    _tokens[resource_id] = {
        "id": resource_id,
        "resource_id": resource_id,
        "location": location,
        "visible": true,
        "carried_by": "",
        "from_payload": from_payload,
    }


func _create_trip_payload() -> void:
    if _trip_payload_visible:
        return

    _trip_payload_visible = true
    _transport_has_payload = true
    _create_resource_token("oat_crate", "transport_payload", true)
    _create_resource_token("pumpkin_crate", "transport_payload", true)
    _set_active_chain_state("payload_returned", "unload_to_storage")
    _emit_event("trip_returned_with_payload", {
        "tag": "route",
        "dog_ids": ["dog.dachshund_intro"],
        "place_ids": ["transport.basket_bicycle", "object.road_sign"],
        "building_ids": ["object.road_sign"],
        "chain_ids": [WARM_DELIVERY_CHAIN_ID],
        "payload": {
            "order_id": _active_order_id(),
            "route_id": "route.oat_farm_intro",
            "payload": ["oat_crate", "pumpkin_crate"],
            "payload_resource_ids": ["resource.oat_crate", "resource.pumpkin_crate"],
        },
    })
    _emit_event("payload_visible")


func _pickup_resource_for_task(task: Dictionary) -> void:
    var resource_id := str(task.get("resource_id", ""))
    var dog_id := str(task.get("assigned_dog_id", ""))
    if resource_id == "" or dog_id == "" or not _tokens.has(resource_id) or not _dogs.has(dog_id):
        return

    var source := str(task.get("source_object_id", ""))
    if source == "storage":
        _decrement_inventory(_storage_inventory, resource_id)
    elif source == "kitchen":
        _decrement_inventory(_kitchen_inputs, resource_id)
    elif source == "packing_table":
        _decrement_inventory(_packing_inputs, resource_id)

    var token := _tokens[resource_id] as Dictionary
    token["location"] = "carried"
    token["carried_by"] = dog_id
    token["visible"] = true

    var dog := _dogs[dog_id] as Dictionary
    dog["carried_resource"] = resource_id
    dog["state"] = "carrying_item"
    _emit_task_dog_action("dog_picked_up_resource", task, _dog_action_resource_message(task, "picked_up"), {
        "activity_detail": "resource_pickup",
    })


func _place_resource_for_task(task: Dictionary) -> void:
    var resource_id := str(task.get("resource_id", ""))
    var dog_id := str(task.get("assigned_dog_id", ""))
    var target := str(task.get("target_object_id", ""))
    if resource_id == "" or not _tokens.has(resource_id):
        return

    var token := _tokens[resource_id] as Dictionary
    token["location"] = target
    token["carried_by"] = ""
    token["visible"] = true

    if dog_id != "" and _dogs.has(dog_id):
        var dog := _dogs[dog_id] as Dictionary
        dog["carried_resource"] = ""

    match str(task.get("type", "")):
        "UnloadTask":
            _increment_inventory(_storage_inventory, resource_id)
            _emit_event("resource_added_to_storage", {
                "tag": "movement",
                "payload": {
                    "order_id": _active_order_id(),
                    "resource_id": resource_id,
                    "resource_key": _resource_key_from_internal(resource_id),
                },
            })
            _emit_event("resource_added_to_storage:%s" % resource_id)
            _emit_task_dog_action("dog_delivered_resource", task, _dog_action_resource_message(task, "delivered"), {
                "activity_detail": "unload_to_storage",
            })
            if not _token_at("oat_crate", "transport_payload") and not _token_at("pumpkin_crate", "transport_payload"):
                _transport_has_payload = false
                _transport_state = "parked"
        "CarryTask":
            if target == "kitchen":
                _increment_inventory(_kitchen_inputs, resource_id)
                _emit_event("resource_delivered_to_kitchen", {
                    "tag": "movement",
                    "payload": {
                        "order_id": _active_order_id(),
                        "resource_id": resource_id,
                        "resource_key": _resource_key_from_internal(resource_id),
                    },
                })
                _emit_event("resource_delivered_to_kitchen:%s" % resource_id)
                _emit_task_dog_action("dog_delivered_resource", task, _dog_action_resource_message(task, "delivered"), {
                    "activity_detail": "carry_to_kitchen",
                })
            elif target == "packing_table":
                _increment_inventory(_packing_inputs, resource_id)
                _emit_event("resource_delivered_to_packing_table", {
                    "tag": "movement",
                    "payload": {
                        "order_id": _active_order_id(),
                        "resource_id": resource_id,
                        "resource_key": _resource_key_from_internal(resource_id),
                    },
                })
                _emit_event("resource_delivered_to_packing_table:%s" % resource_id)
                _emit_task_dog_action("dog_delivered_resource", task, _dog_action_resource_message(task, "delivered"), {
                    "activity_detail": "carry_to_packing_table",
                })
        "LoadVanTask":
            _set_active_delivery_state("ready_to_send")
            _emit_event("van_loaded", {
                "tag": "movement",
                "payload": {
                    "order_id": _active_order_id(),
                    "resource_id": "food_bag",
                    "resource_key": "resource.food_bag",
                },
            })
            _emit_task_dog_action("dog_loaded_van", task, "Лабрадор загрузил Food Bag в фургон", {
                "activity_detail": "load_delivery_van",
            })


func _complete_cooking() -> void:
    _kitchen_inputs["oat_crate"] = 0
    _kitchen_inputs["pumpkin_crate"] = 0
    _kitchen_inputs["protein_packet"] = 0
    _hide_token("oat_crate")
    _hide_token("pumpkin_crate")
    _hide_token("protein_packet")
    _create_resource_token("food_mix", "kitchen", false)
    _set_active_chain_state("food_mix_ready", "carry_inputs_to_packing")
    _emit_event("food_mix_created", {
        "tag": "production_chain",
        "payload": {
            "order_id": _active_order_id(),
            "resource_id": "food_mix",
            "resource_key": "resource.food_mix",
        },
    })
    _emit_task_dog_action("dog_created_food_mix", _current_task, "Лабрадор приготовил food mix", {
        "activity_detail": "food_mix_created",
        "resource_id": "resource.food_mix",
    })


func _complete_packing() -> void:
    _packing_inputs["food_mix"] = 0
    _packing_inputs["packaging_bag"] = 0
    _hide_token("food_mix")
    _hide_token("packaging_bag")
    _create_resource_token("food_bag", "packing_table", false)
    _set_active_chain_state("food_bag_ready", "load_food_bag_into_van")
    _emit_event("food_bag_created", {
        "tag": "production_chain",
        "payload": {
            "order_id": _active_order_id(),
            "resource_id": "food_bag",
            "resource_key": "resource.food_bag",
        },
    })
    _emit_event("packing_table_food_bag_state_visible", {
        "tag": "story",
        "dog_ids": ["dog.labrador_intro"],
        "place_ids": ["object.packing_table"],
        "building_ids": ["object.packing_table"],
        "chain_ids": ["chain.warm_food_delivery_intro"],
        "message": "Packing table показывает готовый Food Bag как физический объект",
        "payload": {
            "order_id": _active_order_id(),
            "resource_id": "resource.food_bag",
            "moment_id": "first_day_packing_table_food_bag_state",
        },
    })
    _emit_task_dog_action("dog_created_food_bag", _current_task, "Лабрадор собрал Food Bag для первой поставки", {
        "activity_detail": "food_bag_created",
        "resource_id": "resource.food_bag",
    })


func _complete_equipment() -> void:
    var dog := _dogs["dachshund_intro"] as Dictionary
    dog["equipment"] = "Удобные тапочки"
    dog["state"] = "equipped_with_slippers"
    _slippers_equipped = true
    _emit_event("reward_equipped")
    _emit_event("dog_equipped_first_reward", {
        "tag": "dog_action",
        "dog_ids": ["dog.dachshund_intro"],
        "place_ids": ["ui.postcard_card"],
        "building_ids": ["ui.postcard_card"],
        "chain_ids": ["chain.warm_food_delivery_intro"],
        "message": "Такса надела первые удобные тапочки",
        "payload": {
            "reward_id": "equipment.comfortable_slippers",
            "order_id": "order.first_warm_delivery",
            "moment_id": "first_day_reward_equipped",
        },
    })
    _emit_event("first_reward_world_marker_shown", {
        "tag": "story",
        "dog_ids": ["dog.dachshund_intro"],
        "place_ids": ["dog.dachshund_intro"],
        "building_ids": [],
        "chain_ids": ["chain.warm_food_delivery_intro"],
        "message": "В мире появился prototype-маркер, что Удобные тапочки принадлежат Таксе",
        "payload": {
            "reward_id": "equipment.comfortable_slippers",
            "recipient_dog_id": "dog.dachshund_intro",
            "moment_id": "first_day_reward_world_marker",
        },
    })
    _emit_event("slippers_equipped_world_state_visible", {
        "tag": "story",
        "dog_ids": ["dog.dachshund_intro"],
        "place_ids": ["dog.dachshund_intro"],
        "building_ids": [],
        "chain_ids": ["chain.warm_food_delivery_intro"],
        "message": "Удобные тапочки видны как личный предмет на лапах Таксы",
        "payload": {
            "reward_id": "equipment.comfortable_slippers",
            "recipient_dog_id": "dog.dachshund_intro",
            "moment_id": "first_day_slippers_equipped_world_state",
        },
    })
    _sync_first_day_history_from_runtime()


func _hide_token(resource_id: String) -> void:
    if not _tokens.has(resource_id):
        return

    var token := _tokens[resource_id] as Dictionary
    token["visible"] = false
    token["location"] = "consumed"
    token["carried_by"] = ""


func _mark_food_bag_delivered() -> void:
    if not _tokens.has("food_bag"):
        return

    var token := _tokens["food_bag"] as Dictionary
    token["visible"] = false
    token["location"] = "delivered_to_shelter"
    token["carried_by"] = ""
    token["semantic_state"] = "delivered"
    token["delivery_id"] = _active_order_id()
    token["delivered_at_seconds"] = snappedf(_elapsed, 0.001)


func _record_first_day_post_delivery_moment() -> void:
    if not _first_day_postcard_life_moment_seen:
        _first_day_postcard_life_moment_seen = true
        _emit_event("dog_noticed_postcard", {
            "tag": "dog_action",
            "dog_ids": ["dog.dachshund_intro", "dog.labrador_intro"],
            "place_ids": ["ui.postcard_card", "object.delivery_van_endpoint"],
            "building_ids": ["ui.postcard_card", "object.delivery_van_endpoint"],
            "chain_ids": ["chain.warm_food_delivery_intro"],
            "message": "Собаки заметили открытку после первой тёплой поставки",
            "payload": {
                "order_id": "order.first_warm_delivery",
                "moment_id": "first_day_post_delivery_postcard",
            },
        })
        _emit_event("postcard_world_marker_shown", {
            "tag": "story",
            "dog_ids": ["dog.dachshund_intro", "dog.labrador_intro"],
            "place_ids": ["ui.postcard_card", "object.delivery_van_endpoint"],
            "building_ids": ["ui.postcard_card", "object.delivery_van_endpoint"],
            "chain_ids": ["chain.warm_food_delivery_intro"],
            "message": "Открытка получила видимый marker на main strip",
            "payload": {
                "order_id": "order.first_warm_delivery",
                "moment_id": "first_day_postcard_world_marker",
            },
        })
        _emit_event("postcard_board_state_visible", {
            "tag": "story",
            "dog_ids": ["dog.dachshund_intro", "dog.labrador_intro"],
            "place_ids": ["object.delivery_van_endpoint"],
            "building_ids": ["object.delivery_van_endpoint"],
            "chain_ids": ["chain.warm_food_delivery_intro"],
            "message": "Открытка появилась на доске в мире, а собаки сделали короткую паузу",
            "payload": {
                "order_id": "order.first_warm_delivery",
                "moment_id": "first_day_postcard_board_state",
            },
        })

    if not _first_day_first_memory_added:
        _first_day_first_memory_added = true
        _emit_event("first_day_memory_added", {
            "tag": "helper_effect",
            "dog_ids": ["dog.dachshund_intro"],
            "place_ids": ["ui.postcard_card"],
            "building_ids": ["ui.postcard_card"],
            "chain_ids": ["chain.warm_food_delivery_intro"],
            "message": "Такса запомнила первую тёплую поставку",
            "payload": {
                "memory_id": "memory.first_warm_delivery",
                "memory_text": "Помнит первую тёплую поставку",
                "order_id": "order.first_warm_delivery",
            },
        })

    var hint_boundary_reached := _slippers_equipped and (not _player_session_configured or _player_checkpoint_sequence >= 16)
    if not _first_day_next_day_hint_available and hint_boundary_reached:
        _first_day_next_day_hint_available = true
        _emit_event("next_day_hint_available", {
            "tag": "story",
            "dog_ids": ["dog.dachshund_intro", "dog.labrador_intro"],
            "place_ids": ["ui.postcard_card"],
            "building_ids": ["ui.postcard_card"],
            "chain_ids": ["chain.warm_food_delivery_intro"],
            "message": "В состоянии доступна мягкая подсказка следующего дня",
            "payload": {
                "hint_id": "hint.first_day_next_day",
                "hint_text": FIRST_DAY_NEXT_DAY_HINT_TEXT,
                "order_id": "order.first_warm_delivery",
            },
        })
        _emit_event("next_day_hint_world_marker_shown", {
            "tag": "story",
            "dog_ids": ["dog.dachshund_intro", "dog.labrador_intro"],
            "place_ids": ["object.packing_table"],
            "building_ids": ["object.packing_table"],
            "chain_ids": ["chain.warm_food_delivery_intro"],
            "message": "На main strip появилась мягкая заметка следующего дня",
            "payload": {
                "hint_id": "hint.first_day_next_day",
                "hint_text": FIRST_DAY_NEXT_DAY_HINT_TEXT,
                "moment_id": "first_day_next_day_world_marker",
            },
        })
        _emit_event("next_day_note_object_visible", {
            "tag": "story",
            "dog_ids": ["dog.dachshund_intro", "dog.labrador_intro"],
            "place_ids": ["object.packing_table"],
            "building_ids": ["object.packing_table"],
            "chain_ids": ["chain.warm_food_delivery_intro"],
            "message": "Мягкая подсказка следующего дня видна как маленькая заметка у packing table",
            "payload": {
                "hint_id": "hint.first_day_next_day",
                "order_id": "order.first_warm_delivery",
                "moment_id": "first_day_next_day_note_object",
            },
        })
    _sync_first_day_history_from_runtime()


func _sync_first_day_history_from_runtime() -> void:
    if _is_day2_active():
        return
    _first_day_history = {
        "order_id": FIRST_ORDER_ID,
        "delivery_confirmed": _delivery_confirmed,
        "postcard_visible": _postcard_visible,
        "reward_available": _reward_available,
        "chain_complete": _chain_complete,
        "postcard_life_moment_seen": _first_day_postcard_life_moment_seen,
        "first_reward_equipped": _slippers_equipped,
        "first_memory_added": _first_day_first_memory_added,
        "next_day_hint_available": _first_day_next_day_hint_available,
        "dachshund": {
            "slippers_equipped": _slippers_equipped,
            "memory_id": "memory.first_warm_delivery" if _first_day_first_memory_added else null,
            "memory_text": "Помнит первую тёплую поставку" if _first_day_first_memory_added else "",
        },
        "packing_note_visible": _first_day_next_day_hint_available,
    }


func _maybe_enqueue_kitchen_carries() -> void:
    if _kitchen_carries_enqueued:
        return

    if _inventory_count(_storage_inventory, "oat_crate") <= 0:
        return
    if _inventory_count(_storage_inventory, "pumpkin_crate") <= 0:
        return
    if _inventory_count(_storage_inventory, "protein_packet") <= 0:
        return

    _kitchen_carries_enqueued = true
    _set_active_chain_state("stored", "storage_ready")
    _set_active_order_status("resources_available")
    _enqueue_task(_create_carry_task("oat_crate", "storage", "kitchen"))
    _enqueue_task(_create_carry_task("pumpkin_crate", "storage", "kitchen"))
    _enqueue_task(_create_carry_task("protein_packet", "storage", "kitchen"))
    _set_active_chain_state("inputs_to_kitchen", "carry_ingredients_to_kitchen")


func _maybe_enqueue_cook_or_pack_work() -> void:
    if not _cook_enqueued:
        var kitchen_ready := (
            _inventory_count(_kitchen_inputs, "oat_crate") > 0
            and _inventory_count(_kitchen_inputs, "pumpkin_crate") > 0
            and _inventory_count(_kitchen_inputs, "protein_packet") > 0
        )
        if kitchen_ready:
            _cook_enqueued = true
            _emit_event("kitchen_inputs_ready")
            _enqueue_task(_create_cook_task())
            return

    if not _pack_enqueued:
        var packing_ready := (
            _inventory_count(_packing_inputs, "food_mix") > 0
            and _inventory_count(_packing_inputs, "packaging_bag") > 0
        )
        if packing_ready:
            _pack_enqueued = true
            _emit_event("packing_inputs_ready")
            _set_active_chain_state("packing_ready", "packing_table_ready")
            _enqueue_task(_create_pack_task())


func _maybe_enqueue_packing_carries() -> void:
    if _packing_carries_enqueued:
        return

    _packing_carries_enqueued = true
    _enqueue_task(_create_carry_task("food_mix", "kitchen", "packing_table"))
    _enqueue_task(_create_carry_task("packaging_bag", "storage", "packing_table"))
    _set_active_chain_state("moving_to_packing", "carry_inputs_to_packing")


func _maybe_enqueue_load_van() -> void:
    if _load_van_enqueued:
        return

    _load_van_enqueued = true
    _set_active_order_status("packed")
    _enqueue_task(_create_load_van_task())


func _increment_inventory(inventory: Dictionary, resource_id: String) -> void:
    inventory[resource_id] = int(inventory.get(resource_id, 0)) + 1


func _decrement_inventory(inventory: Dictionary, resource_id: String) -> void:
    inventory[resource_id] = maxi(int(inventory.get(resource_id, 0)) - 1, 0)


func _inventory_count(inventory: Dictionary, resource_id: String) -> int:
    return int(inventory.get(resource_id, 0))


func _set_dog_visible(dog_id: String, visible: bool) -> void:
    if dog_id == "" or not _dogs.has(dog_id):
        return

    var dog := _dogs[dog_id] as Dictionary
    dog["visible"] = visible


func _update_ui() -> void:
    if _order_label == null:
        return

    _layout_ui()

    if _compact_ui:
        _order_label.text = "%s\n%s" % [_presentation_order_title(), _next_action_text()]
        _route_label.text = "Овсяная ферма\nТакса + велосипед"
        _dog_label.text = "Такса\nEquip: %s\nMemory: %s" % [_dachshund_equipment_text(), _dachshund_memory_text()]
        _order_label.add_theme_font_size_override("font_size", 10)
        _route_label.add_theme_font_size_override("font_size", 10)
        _dog_label.add_theme_font_size_override("font_size", 10)
    else:
        _order_label.text = "%s\n%s\nСледующее: %s" % [
            _presentation_order_title(),
            _order_state_text(),
            _next_action_text(),
        ]
        _route_label.text = "Овсяная ферма\nВодитель: Такса\nТранспорт: велосипед\nПривезём: овёс + тыква"
        _dog_label.text = "Dog Card: Такса\nTrait: Быстрые лапки\nEquipment: %s\nMemory: %s" % [_dachshund_equipment_text(), _dachshund_memory_text()]
        _order_label.add_theme_font_size_override("font_size", 12)
        _route_label.add_theme_font_size_override("font_size", 12)
        _dog_label.add_theme_font_size_override("font_size", 12)
    _postcard_label.text = "Открытка\nСпасибо за первую поставку. Кооператив только начинает путь, но уже сделал доброе дело.\nНаграда: Удобные тапочки"
    _debug_label.text = _debug_text()
    _status_label.text = "Vertical Slice | task=%s | event=%s | labels=%s" % [
        _current_task_label(),
        _last_event,
        "on" if _show_semantic_labels else "off",
    ]

    var checkpoint_blocked := _player_session_configured and (_player_checkpoint_barrier_failed or _player_checkpoint_commit_in_progress or _player_checkpoint_sequence == 0)
    _send_route_button.disabled = _route_started or checkpoint_blocked
    _confirm_delivery_button.visible = _van_loaded and not _delivery_confirmed
    _confirm_delivery_button.disabled = checkpoint_blocked
    _claim_reward_button.visible = not _player_session_configured and _postcard_visible and not _postcard_claimed
    _equip_slippers_button.visible = _reward_available and not _equip_task_created and not _slippers_equipped
    _equip_slippers_button.disabled = checkpoint_blocked

    var base_ui_visible := not _ui_hidden
    _order_card.visible = base_ui_visible
    _route_card.visible = base_ui_visible
    _dog_card.visible = base_ui_visible
    _debug_card.visible = base_ui_visible and _show_debug_overlay and not _compact_ui
    _postcard_card.visible = base_ui_visible and _postcard_visible
    _status_label.visible = base_ui_visible and not _compact_ui
    _performance_label.visible = base_ui_visible and _show_performance_hud
    _semantic_button.visible = base_ui_visible and not _compact_ui
    _visibility_button.visible = true
    _visibility_button.text = "Show UI" if _ui_hidden else "Hide UI"
    _semantic_button.text = "Labels" if _show_semantic_labels else "No labels"

    _apply_mouse_passthrough()


func _order_state_text() -> String:
    match _order_state:
        "offered":
            return "Спокойная вторая поставка доступна без срока и потерь."
        "route_suggested":
            return "Соберём один мешок корма спокойно и по шагам."
        "trip_active":
            return "Такса в дороге, маршрут идёт спокойно."
        "resources_available":
            return "Ингредиенты уже в кладовой после выгрузки."
        "production_in_progress":
            return "Собаки готовят и переносят ресурсы."
        "packed":
            return "Food Bag готов к погрузке."
        "loaded":
            return "Food Bag загружен. Можно отправлять."
        "sent":
            return "Поставка отправляется."
        "completed":
            return "Поставка завершена."
        "reward_claimed":
            return "Награда получена. Осталось надеть её таксе."
        _:
            return "Кооператив работает."


func _next_action_text() -> String:
    if bool(_day2_history.get("completed", false)):
        return "кооператив спокойно отдыхает"
    if not _route_started:
        return "отправить таксу на Овсяную ферму"
    if _van_loaded and not _delivery_confirmed:
        return "подтвердить отправку"
    if _postcard_visible and not _postcard_claimed:
        return "получить тапочки с открытки"
    if _reward_available and not _slippers_equipped:
        return "надеть тапочки таксе"
    if _chain_complete:
        if _is_day2_active():
            return "тихий конец достигнут" if bool(_day2.get("quiet_end_state_reached", false)) else "спокойная заметка о доставке появилась"
        return "первый loop завершён"
    return "наблюдать за работой собак"


func _presentation_order_title() -> String:
    if _active_order.is_empty() and bool(_day2_history.get("completed", false)):
        return "Кооператив отдыхает"
    return str(_active_order.get("title", FIRST_ORDER_TITLE))


func _dachshund_equipment_text() -> String:
    var dog := _dogs.get("dachshund_intro", {}) as Dictionary
    var equipment := str(dog.get("equipment", ""))
    if equipment == "":
        return "Пусто"
    return equipment


func _dachshund_memory_text() -> String:
    var dachshund_history := _first_day_history.get("dachshund", {}) as Dictionary
    var text := str(dachshund_history.get("memory_text", ""))
    if text != "":
        return text
    if _first_day_first_memory_added:
        return "Помнит первую тёплую поставку"
    return "Пока нет"


func _debug_text() -> String:
    var lines: Array[String] = []
    lines.append("contract keys: route.oat_farm_intro / %s" % _active_order_id())
    lines.append("Storage: %s" % _inventory_debug(_storage_inventory))
    lines.append("Kitchen inputs: %s" % _inventory_debug(_kitchen_inputs))
    lines.append("Packing inputs: %s" % _inventory_debug(_packing_inputs))
    lines.append("Delivery: %s" % _delivery_state)
    lines.append("Runtime speed: %sx" % _systems_runtime.debug_speed_multiplier)
    lines.append("Events:")

    for line in _systems_runtime.event_lines(5):
        lines.append("  %s" % line)

    return "\n".join(lines)


func _inventory_debug(inventory: Dictionary) -> String:
    var parts: Array[String] = []
    for resource_id in RESOURCE_ORDER:
        var count := int(inventory.get(resource_id, 0))
        if count > 0:
            parts.append("%s=%d" % [resource_id, count])
    if parts.is_empty():
        return "-"
    return ", ".join(parts)


func _current_task_label() -> String:
    if _current_task.is_empty():
        return "IdleTask"
    return "%s/%s" % [str(_current_task.get("type", "Task")), str(_current_task.get("status", "queued"))]


func _draw_authored_world_back(baseline: float) -> void:
    for layer in _authored_world_layers:
        if int(layer.get("index", -1)) <= 12:
            _draw_authored_world_layer(layer, baseline)


func _draw_authored_world_front(baseline: float) -> void:
    for layer in _authored_world_layers:
        if int(layer.get("index", -1)) == 13:
            if not _packing_front_span_mask_active():
                _draw_authored_world_layer(layer, baseline)
                continue
            var texture := layer.get("texture", null) as Texture2D
            if texture == null:
                continue
            var full_rect := Rect2(Vector2.ZERO, texture.get_size())
            var mask_rect := full_rect.intersection(_packing_front_span_mask_source_rect())
            if not mask_rect.has_area():
                _draw_authored_world_layer(layer, baseline)
                continue
            for region in _front_span_regions_outside_mask(full_rect, mask_rect):
                _draw_authored_world_layer_region(layer, baseline, region)


func _draw_packing_front_span_underlay(baseline: float) -> void:
    if not _packing_front_span_mask_active():
        return
    for layer in _authored_world_layers:
        if int(layer.get("index", -1)) != 13:
            continue
        var texture := layer.get("texture", null) as Texture2D
        if texture == null:
            return
        var mask_rect := Rect2(Vector2.ZERO, texture.get_size()).intersection(_packing_front_span_mask_source_rect())
        if mask_rect.has_area():
            _draw_authored_world_layer_region(layer, baseline, mask_rect)
        return


func _packing_front_span_mask_active() -> bool:
    if not bool(_labrador_render_state.get("packing_front_span_mask_active", false)):
        return false
    if str(_labrador_render_state.get("packing_front_span_mask_owner", "")) != "derived_non_persisted_presentation":
        return false
    if str(_labrador_render_state.get("station_id", "")) != PACKING_FRONT_SPAN_MASK_STATION_ID:
        return false
    return str(_labrador_render_state.get("selector", "")) in PACKING_FRONT_SPAN_MASK_SELECTORS


func _packing_front_span_mask_source_rect() -> Rect2:
    var actor_world_x := float(_labrador_render_state.get("actor_world_x", (_dogs.get("labrador_intro", {}) as Dictionary).get("x", 0.0)))
    actor_world_x += float(_labrador_render_state.get("station_offset_x", 0.0))
    return Rect2(
        Vector2(
            actor_world_x - PACKING_FRONT_SPAN_MASK_HALF_WIDTH_WORLD,
            AUTHORED_WORLD_BASELINE_Y + PACKING_FRONT_SPAN_MASK_TOP_FROM_BASELINE
        ),
        Vector2(
            PACKING_FRONT_SPAN_MASK_HALF_WIDTH_WORLD * 2.0,
            PACKING_FRONT_SPAN_MASK_BOTTOM_FROM_BASELINE - PACKING_FRONT_SPAN_MASK_TOP_FROM_BASELINE
        )
    )


func _packing_front_span_mask_snapshot() -> Dictionary:
    var active := _packing_front_span_mask_active()
    var source_rect := _packing_front_span_mask_source_rect() if active else Rect2()
    return {
        "active": active,
        "owner": "VerticalSliceDemo.parent_draw_slot",
        "authority": "derived_non_persisted_presentation",
        "strategy": "existing_source_local_segment_under_actor",
        "source_layer": "world.fence.front_span",
        "station_id": str(_labrador_render_state.get("station_id", "")),
        "selector": str(_labrador_render_state.get("selector", "")),
        "source_rect": [source_rect.position.x, source_rect.position.y, source_rect.size.x, source_rect.size.y],
        "global_z_reorder": false,
        "source_mutation": false,
        "gameplay_authority": false,
        "ordinary_front_span_ownership_restored": not active,
        "permitted_contacting_paw_tip_source_px": 12,
        "permitted_contacting_paw_tip_native_px": 5,
    }


func _front_span_regions_outside_mask(full_rect: Rect2, mask_rect: Rect2) -> Array[Rect2]:
    var regions: Array[Rect2] = []
    var top := Rect2(full_rect.position, Vector2(full_rect.size.x, mask_rect.position.y - full_rect.position.y))
    var bottom := Rect2(Vector2(full_rect.position.x, mask_rect.end.y), Vector2(full_rect.size.x, full_rect.end.y - mask_rect.end.y))
    var left := Rect2(Vector2(full_rect.position.x, mask_rect.position.y), Vector2(mask_rect.position.x - full_rect.position.x, mask_rect.size.y))
    var right := Rect2(Vector2(mask_rect.end.x, mask_rect.position.y), Vector2(full_rect.end.x - mask_rect.end.x, mask_rect.size.y))
    for region in [top, bottom, left, right]:
        if region.has_area():
            regions.append(region)
    return regions


func _draw_authored_world_layer(layer: Dictionary, baseline: float) -> void:
    var texture := layer.get("texture", null) as Texture2D
    if texture == null:
        return
    var zoom := _zoom()
    var source_origin := Vector2(_world_to_screen_x(0.0), baseline - AUTHORED_WORLD_BASELINE_Y * zoom)
    draw_set_transform(source_origin, 0.0, Vector2(zoom, zoom))
    draw_texture(texture, Vector2.ZERO)
    draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)


func _draw_authored_world_layer_region(layer: Dictionary, baseline: float, source_rect: Rect2) -> void:
    var texture := layer.get("texture", null) as Texture2D
    if texture == null or not source_rect.has_area():
        return
    var zoom := _zoom()
    var source_origin := Vector2(_world_to_screen_x(0.0), baseline - AUTHORED_WORLD_BASELINE_Y * zoom)
    draw_set_transform(source_origin, 0.0, Vector2(zoom, zoom))
    draw_texture_rect_region(texture, source_rect, source_rect, Color.WHITE, false, true)
    draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)


func _draw_non_authored_corridor_tail(baseline: float) -> void:
    # The source canvas ends at x=1536. This bounded primitive continues the
    # already-existing runtime corridor to x=1740 without stretching or
    # claiming authored pixels. Four world units only underlay the soft edge.
    var zoom := _zoom()
    var left := _world_to_screen_x(NON_AUTHORED_TAIL_STITCH_X)
    var right := _world_to_screen_x(WORLD_WIDTH)
    if right <= left:
        return
    var ground := PackedVector2Array([
        Vector2(left, baseline - 30.0 * zoom),
        Vector2(right, baseline - 25.0 * zoom),
        Vector2(right, baseline + 4.0 * zoom),
        Vector2(left, baseline + 4.0 * zoom),
    ])
    draw_colored_polygon(ground, Color(0.37, 0.29, 0.20, 1.0))
    draw_line(
        Vector2(left, baseline - 30.0 * zoom),
        Vector2(right, baseline - 25.0 * zoom),
        Color(0.40, 0.48, 0.29, 1.0),
        maxf(2.0, 6.0 * zoom)
    )


func _draw_ground(baseline: float) -> void:
    var viewport_size := _viewport_size()
    draw_rect(Rect2(0.0, baseline, viewport_size.x, viewport_size.y - baseline), Color(0.25, 0.21, 0.14, 0.86), true)
    draw_rect(Rect2(0.0, baseline - (7.0 * _zoom()), viewport_size.x, 7.0 * _zoom()), Color(0.38, 0.52, 0.30, 0.94), true)

    var road_y := baseline - (14.0 * _zoom())
    for anchor_id in ["road_sign", "storage", "kitchen", "packing_table", "delivery_van_endpoint"]:
        var x := _world_to_screen_x(_anchor_x(anchor_id))
        draw_circle(Vector2(x, road_y), 4.0 * _zoom(), Color(0.63, 0.56, 0.40, 0.72))


func _draw_route_path(baseline: float) -> void:
    var path_y := baseline - (18.0 * _zoom())
    var start_x := _world_to_screen_x(_anchor_x("road_sign"))
    var end_x := _world_to_screen_x(_anchor_x("delivery_van_endpoint"))
    draw_line(Vector2(start_x, path_y), Vector2(end_x, path_y), Color(0.56, 0.48, 0.32, 0.60), maxf(1.0, 2.0 * _zoom()))


func _draw_world_anchors(baseline: float) -> void:
    _draw_anchor_texture("road_sign", "road_sign", baseline)
    _draw_anchor_texture("storage", "storage", baseline)
    _draw_anchor_texture("kitchen", "kitchen", baseline)
    _draw_packing_table_placeholder(baseline)
    _draw_anchor_texture("delivery_van_endpoint", "delivery_van_endpoint", baseline)


func _draw_anchor_texture(anchor_id: String, texture_id: String, baseline: float) -> void:
    var anchor := ANCHOR_DEFS[anchor_id] as Dictionary
    var texture := _textures.get(texture_id, null) as Texture2D
    var center_x := _world_to_screen_x(float(anchor["x"]))
    var max_size := (anchor["max_size"] as Vector2) * _zoom()
    var bottom_y := baseline - (9.0 * _zoom())

    if texture == null:
        var fallback_rect := Rect2(center_x - max_size.x * 0.5, bottom_y - max_size.y, max_size.x, max_size.y)
        draw_rect(fallback_rect, Color(0.34, 0.42, 0.34, 0.85), true)
        draw_rect(fallback_rect, Color(0.80, 0.88, 0.70, 0.95), false, maxf(1.0, 1.5 * _zoom()))
        return

    var source_size := texture.get_size()
    var scale := minf(max_size.x / source_size.x, max_size.y / source_size.y)
    var target_size := source_size * scale
    var rect := Rect2(Vector2(center_x - target_size.x * 0.5, bottom_y - target_size.y), target_size)
    draw_texture_rect(texture, rect, false, Color(1.0, 1.0, 1.0, 0.96))


func _draw_packing_table_placeholder(baseline: float) -> void:
    var center_x := _world_to_screen_x(_anchor_x("packing_table"))
    var scale := _zoom()
    var table_size := Vector2(154.0, 52.0) * scale
    var rect := Rect2(center_x - table_size.x * 0.5, baseline - table_size.y - (13.0 * scale), table_size.x, table_size.y)
    draw_rect(rect, Color(0.42, 0.28, 0.17, 0.94), true)
    draw_rect(Rect2(rect.position + Vector2(0.0, -4.0) * scale, Vector2(rect.size.x, 12.0 * scale)), Color(0.64, 0.47, 0.29, 0.98), true)
    draw_rect(Rect2(rect.position + Vector2(12.0, 41.0) * scale, Vector2(8.0, 25.0) * scale), Color(0.30, 0.20, 0.13, 0.92), true)
    draw_rect(Rect2(rect.end - Vector2(20.0, 11.0) * scale, Vector2(8.0, 25.0) * scale), Color(0.30, 0.20, 0.13, 0.92), true)

    var has_food_mix := int(_packing_inputs.get("food_mix", 0)) > 0 or _token_at("food_mix", "packing_table")
    var has_packaging := int(_packing_inputs.get("packaging_bag", 0)) > 0 or _token_at("packaging_bag", "packing_table")
    var bag_ready := _token_at("food_bag", "packing_table") or _van_loaded or _delivery_confirmed or _delivery_complete

    if has_food_mix:
        var bowl_center := rect.position + Vector2(43.0, 28.0) * scale
        draw_circle(bowl_center, 15.0 * scale, Color(0.72, 0.50, 0.30, 0.94))
        draw_circle(bowl_center + Vector2(0.0, -4.0) * scale, 10.0 * scale, Color(0.86, 0.66, 0.42, 0.92))
        draw_line(bowl_center + Vector2(-17.0, -2.0) * scale, bowl_center + Vector2(17.0, -2.0) * scale, Color(0.34, 0.20, 0.12, 0.78), maxf(1.0, 1.3 * scale))

    if has_packaging:
        var folded := Rect2(rect.position + Vector2(84.0, 20.0) * scale, Vector2(28.0, 23.0) * scale)
        draw_rect(folded, Color(0.73, 0.82, 0.78, 0.92), true)
        draw_line(folded.position + Vector2(4.0, 5.0) * scale, folded.end - Vector2(4.0, 5.0) * scale, Color(0.36, 0.47, 0.40, 0.75), maxf(1.0, scale))
        draw_line(folded.position + Vector2(folded.size.x - 4.0 * scale, 5.0 * scale), folded.position + Vector2(4.0 * scale, folded.size.y - 5.0 * scale), Color(0.36, 0.47, 0.40, 0.75), maxf(1.0, scale))

    if bag_ready:
        var bag := Rect2(rect.position + Vector2(112.0, 12.0) * scale, Vector2(32.0, 36.0) * scale)
        draw_rect(bag, Color(0.58, 0.74, 0.50, 0.96), true)
        draw_rect(Rect2(bag.position + Vector2(10.0, -6.0) * scale, Vector2(12.0, 8.0) * scale), Color(0.70, 0.84, 0.60, 0.96), true)
        draw_line(bag.position + Vector2(6.0, 12.0) * scale, bag.position + Vector2(bag.size.x - 6.0 * scale, 12.0 * scale), Color(0.22, 0.36, 0.22, 0.78), maxf(1.0, scale))
        draw_circle(bag.position + Vector2(16.0, 24.0) * scale, 4.0 * scale, Color(0.84, 0.92, 0.67, 0.88))
    elif has_food_mix and has_packaging:
        draw_line(rect.position + Vector2(67.0, 33.0) * scale, rect.position + Vector2(84.0, 33.0) * scale, Color(0.92, 0.82, 0.55, 0.88), maxf(1.0, 2.0 * scale))

    draw_rect(rect, Color(0.86, 0.76, 0.52, 0.95), false, maxf(1.0, 2.0 * scale))


func _draw_transport(baseline: float) -> void:
    if not _transport_visible:
        return

    var texture := _textures.get("basket_bicycle", null) as Texture2D
    var center_x := _world_to_screen_x(_transport_x)
    var max_size := Vector2(82.0, 70.0) * _zoom()
    var bottom_y := baseline - (13.0 * _zoom())

    if texture != null:
        var source_size := texture.get_size()
        var scale := minf(max_size.x / source_size.x, max_size.y / source_size.y)
        var target_size := source_size * scale
        draw_texture_rect(texture, Rect2(Vector2(center_x - target_size.x * 0.5, bottom_y - target_size.y), target_size), false)
    else:
        draw_rect(Rect2(center_x - 38.0 * _zoom(), bottom_y - 30.0 * _zoom(), 76.0 * _zoom(), 30.0 * _zoom()), Color(0.54, 0.40, 0.26, 0.94), true)

    var scale := _zoom()
    if _transport_state == "preparing":
        draw_line(Vector2(center_x - 30.0 * scale, bottom_y - 45.0 * scale), Vector2(center_x + 23.0 * scale, bottom_y - 54.0 * scale), Color(0.74, 0.88, 0.96, 0.72), maxf(1.0, 1.5 * scale))
        draw_circle(Vector2(center_x + 31.0 * scale, bottom_y - 55.0 * scale), 4.0 * scale, Color(0.74, 0.88, 0.96, 0.82))
    elif _transport_state == "returning":
        draw_line(Vector2(center_x - 47.0 * scale, bottom_y - 9.0 * scale), Vector2(center_x - 68.0 * scale, bottom_y - 5.0 * scale), Color(0.82, 0.74, 0.54, 0.42), maxf(1.0, scale))
        draw_line(Vector2(center_x - 42.0 * scale, bottom_y - 20.0 * scale), Vector2(center_x - 62.0 * scale, bottom_y - 17.0 * scale), Color(0.82, 0.74, 0.54, 0.36), maxf(1.0, scale))

    if _transport_has_payload:
        var crate_a := Rect2(center_x + 6.0 * scale, bottom_y - 61.0 * scale, 19.0 * scale, 16.0 * scale)
        var crate_b := Rect2(center_x + 25.0 * scale, bottom_y - 58.0 * scale, 17.0 * scale, 14.0 * scale)
        draw_rect(crate_a, Color(0.79, 0.67, 0.42, 0.94), true)
        draw_rect(crate_b, Color(0.91, 0.54, 0.24, 0.94), true)
        draw_rect(crate_a, Color(0.22, 0.14, 0.08, 0.72), false, maxf(1.0, scale))
        draw_rect(crate_b, Color(0.22, 0.14, 0.08, 0.72), false, maxf(1.0, scale))
        draw_line(crate_a.position + Vector2(0.0, crate_a.size.y * 0.42), crate_a.position + Vector2(crate_a.size.x, crate_a.size.y * 0.42), Color(0.22, 0.14, 0.08, 0.52), maxf(1.0, scale))


func _draw_resource_tokens(baseline: float) -> void:
    for resource_id in RESOURCE_ORDER:
        if not _tokens.has(resource_id):
            continue

        var token := _tokens[resource_id] as Dictionary
        if not bool(token.get("visible", true)):
            continue

        var position := _token_screen_position(token, baseline)
        _draw_resource_token(resource_id, position)


func _draw_resource_token(resource_id: String, position: Vector2) -> void:
    var resource_def := RESOURCE_DEFS[resource_id] as Dictionary
    var color := resource_def["color"] as Color
    var token_size := _resource_token_size(resource_id) * _zoom()
    var rect := Rect2(position - (token_size * 0.5), token_size)

    if resource_id in ["food_mix", "food_bag"]:
        var composite := _textures.get("food_mix_and_food_bag_composite", null) as Texture2D
        if composite != null:
            var source_size := composite.get_size()
            var scale := minf(token_size.x / source_size.x, token_size.y / source_size.y)
            var target_size := source_size * scale
            draw_texture_rect(composite, Rect2(position - (target_size * 0.5), target_size), false, Color(1.0, 1.0, 1.0, 0.70))

    if resource_id == "food_mix":
        draw_circle(position, token_size.y * 0.42, color)
        draw_circle(position + Vector2(0.0, -2.0 * _zoom()), token_size.y * 0.25, color.lightened(0.18))
        draw_line(position + Vector2(-13.0, -2.0) * _zoom(), position + Vector2(13.0, -2.0) * _zoom(), Color(0.37, 0.23, 0.13, 0.76), maxf(1.0, 1.5 * _zoom()))
    elif resource_id == "food_bag":
        draw_rect(rect, color, true)
        draw_rect(Rect2(rect.position + Vector2(token_size.x * 0.34, -5.0 * _zoom()), Vector2(token_size.x * 0.32, 7.0 * _zoom())), color.lightened(0.18), true)
        draw_line(rect.position + Vector2(token_size.x * 0.22, token_size.y * 0.30), rect.position + Vector2(token_size.x * 0.78, token_size.y * 0.30), Color(0.22, 0.36, 0.22, 0.78), maxf(1.0, _zoom()))
    elif resource_id == "packaging_bag":
        draw_rect(rect, color, true)
        draw_line(rect.position + Vector2(4.0, 6.0) * _zoom(), rect.end - Vector2(4.0, 6.0) * _zoom(), Color(0.35, 0.45, 0.39, 0.80), maxf(1.0, _zoom()))
        draw_line(rect.position + Vector2(rect.size.x - 4.0 * _zoom(), 6.0 * _zoom()), rect.position + Vector2(4.0 * _zoom(), rect.size.y - 6.0 * _zoom()), Color(0.35, 0.45, 0.39, 0.80), maxf(1.0, _zoom()))
    elif resource_id == "protein_packet":
        draw_rect(rect, color, true)
        draw_rect(rect.grow(-4.0 * _zoom()), color.darkened(0.20), false, maxf(1.0, _zoom()))
        draw_circle(position, 4.0 * _zoom(), Color(0.88, 0.90, 0.80, 0.92))
    else:
        draw_rect(rect, color, true)
        var stripe_color := Color(0.20, 0.14, 0.10, 0.65)
        draw_line(rect.position + Vector2(0.0, token_size.y * 0.34), rect.position + Vector2(token_size.x, token_size.y * 0.34), stripe_color, maxf(1.0, _zoom()))
        if resource_id == "pumpkin_crate":
            draw_circle(position, 8.0 * _zoom(), color.lightened(0.22))
        elif resource_id == "oat_crate":
            draw_line(position + Vector2(-12.0, 7.0) * _zoom(), position + Vector2(12.0, -7.0) * _zoom(), color.lightened(0.24), maxf(1.0, _zoom()))
        draw_rect(rect, Color(0.20, 0.14, 0.10, 0.86), false, maxf(1.0, 1.5 * _zoom()))

    if _show_semantic_labels:
        var font := ThemeDB.fallback_font
        draw_string(font, position + Vector2(-token_size.x * 0.52, token_size.y * 0.78), str(resource_def["short"]), HORIZONTAL_ALIGNMENT_LEFT, -1.0, 9.0 * _zoom(), Color(0.96, 0.94, 0.84, 1.0))


func _resource_token_size(resource_id: String) -> Vector2:
    match resource_id:
        "food_mix":
            return Vector2(50.0, 30.0)
        "food_bag":
            return Vector2(46.0, 42.0)
        "packaging_bag":
            return Vector2(42.0, 34.0)
        "protein_packet":
            return Vector2(42.0, 30.0)
        _:
            return Vector2(46.0, 36.0)


func _draw_dogs(baseline: float) -> void:
    var dachshund := _dogs["dachshund_intro"] as Dictionary
    if bool(dachshund.get("visible", true)):
        _draw_dog("dachshund_intro", dachshund, baseline)

    var labrador := _dogs["labrador_intro"] as Dictionary
    if not bool(labrador.get("visible", true)):
        return
    var lane := str(_labrador_render_state.get("lane", "suppressed"))
    if lane.begins_with("authored"):
        _draw_authored_labrador(baseline)
    elif lane == "legacy_unbound":
        _draw_dog("labrador_intro", labrador, baseline)


func _draw_authored_labrador(baseline: float) -> void:
    var facing := str(_labrador_render_state.get("facing_source", "right"))
    if not _authored_labrador_layers.has(facing):
        return
    var zoom := _zoom()
    var world_x := float(_labrador_render_state.get("actor_world_x", (_dogs["labrador_intro"] as Dictionary).get("x", 0.0)))
    world_x += float(_labrador_render_state.get("station_offset_x", 0.0))
    var actor_root_screen := Vector2(_world_to_screen_x(world_x), baseline)
    var render_scale := LABRADOR_SOURCE_TO_WORLD * zoom
    var pose: Vector4 = _labrador_render_state.get("base_pose", Vector4.ZERO)
    var focus: Vector2 = _labrador_render_state.get("focus_pose", Vector2.ZERO)
    var blink := float(_labrador_render_state.get("blink_amount", 0.0))
    var facing_direction := -1.0 if facing == "left" else 1.0

    for layer in _authored_labrador_layers[facing] as Array:
        var layer_id := str((layer as Dictionary).get("id", ""))
        if layer_id == "dog.equipment.collar":
            continue
        if layer_id == "dog.eye.open" and blink >= 0.5:
            continue
        if layer_id == "dog.eye.blink" and blink < 0.5:
            continue

        var offset_world := Vector2.ZERO
        var rotation := 0.0
        var pivot_source := LABRADOR_SOURCE_ROOT
        if layer_id != "dog.shadow.local":
            if layer_id.begins_with("dog.leg.fore"):
                offset_world.x += pose.y * facing_direction
                offset_world.y += pose.x * 0.2
                if layer_id == "dog.leg.fore.near":
                    offset_world.y += pose.w + focus.y
            elif layer_id.begins_with("dog.leg.hind"):
                offset_world.x += pose.z * facing_direction
                offset_world.y += pose.x * 0.2
            elif layer_id == "dog.tail":
                offset_world.y += pose.x
                pivot_source = LABRADOR_TAIL_PIVOTS[facing] as Vector2
                rotation = float(_labrador_render_state.get("tail_rotation", 0.0))
            elif layer_id in ["dog.head", "dog.ear.far", "dog.ear.near", "dog.muzzle", "dog.eye.open", "dog.eye.blink"]:
                offset_world.y += pose.x + focus.x
            else:
                offset_world.y += pose.x

        var pivot_world := (pivot_source - LABRADOR_SOURCE_ROOT) * LABRADOR_SOURCE_TO_WORLD
        var pivot_screen := actor_root_screen + (pivot_world + offset_world) * zoom
        draw_set_transform(pivot_screen, rotation, Vector2(render_scale, render_scale))
        var identity_silhouette := _labrador_capture_silhouette and layer_id != "dog.shadow.local"
        var modulate := Color(0.025, 0.025, 0.025, 1.0) if identity_silhouette else Color.WHITE
        draw_texture((layer as Dictionary).get("texture", null) as Texture2D, -pivot_source, modulate)

    draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)


func _draw_dog_action_lanes(baseline: float) -> void:
    for dog_id in ["dachshund_intro", "labrador_intro"]:
        var dog := _dogs[dog_id] as Dictionary
        if not bool(dog.get("visible", true)):
            continue

        var state := str(dog.get("state", "idle"))
        if state == "idle":
            continue

        var x := _world_to_screen_x(float(dog.get("x", 0.0)))
        var scale := _zoom()
        var lane_y := baseline - (33.0 * scale)
        var lane_color := _dog_action_color(state)
        draw_circle(Vector2(x, lane_y), 32.0 * scale, Color(lane_color.r, lane_color.g, lane_color.b, 0.14))
        draw_line(Vector2(x - 32.0 * scale, lane_y + 24.0 * scale), Vector2(x + 32.0 * scale, lane_y + 24.0 * scale), Color(lane_color.r, lane_color.g, lane_color.b, 0.55), maxf(1.0, 2.0 * scale))


func _draw_dog(dog_id: String, dog: Dictionary, baseline: float) -> void:
    var dog_def := DOG_DEFS[dog_id] as Dictionary
    var center := Vector2(_world_to_screen_x(float(dog.get("x", 0.0))), baseline - (34.0 * _zoom()))
    var base_color := dog_def["color"] as Color
    var secondary := dog_def["secondary"] as Color
    var state := str(dog.get("state", "idle"))
    var scale := _zoom()

    var body_length := 76.0 if dog_id == "dachshund_intro" else 68.0
    var body_height := 19.0 if dog_id == "dachshund_intro" else 34.0
    var leg_height := 9.0 if dog_id == "dachshund_intro" else 18.0
    var head_radius := 13.0 if dog_id == "dachshund_intro" else 16.0

    var bob := 0.0
    if state in ["walking", "moving_to_transport", "carrying_item", "returning_with_transport", "leaving_with_transport", "preparing_transport"]:
        var bob_frequency := 12.5 if dog_id == "dachshund_intro" else 5.8
        var bob_height := 2.4 if dog_id == "dachshund_intro" else 1.1
        bob = sin(_elapsed * bob_frequency) * bob_height * scale
    elif dog_id == "dachshund_intro" and _slippers_equipped:
        bob = sin(_elapsed * 2.4) * 0.8 * scale

    center.y += bob
    if dog_id == "dachshund_intro" and state == "preparing_transport":
        center.x += 3.0 * scale
        center.y += 2.0 * scale
    var body_rect := Rect2(
        center.x - (body_length * 0.5 * scale),
        center.y - (body_height * 0.5 * scale),
        body_length * scale,
        body_height * scale
    )
    draw_rect(body_rect, base_color, true)
    draw_circle(Vector2(body_rect.position.x, center.y), body_height * 0.5 * scale, base_color)
    draw_circle(Vector2(body_rect.end.x, center.y), body_height * 0.5 * scale, base_color)
    draw_circle(center + Vector2(body_length * 0.58 * scale, -7.0 * scale), head_radius * scale, base_color)
    draw_circle(center + Vector2(body_length * 0.78 * scale, -4.0 * scale), 4.0 * scale, secondary)

    for i in 4:
        var leg_x := center.x - (body_length * 0.35 * scale) + (i * body_length * 0.23 * scale)
        draw_rect(Rect2(leg_x, center.y + body_height * 0.32 * scale, 4.0 * scale, leg_height * scale), base_color.darkened(0.18), true)

    if dog_id == "dachshund_intro" and _slippers_equipped:
        for i in 4:
            var slipper_x := center.x - (body_length * 0.35 * scale) + (i * body_length * 0.23 * scale)
            var slipper_rect := Rect2(slipper_x - 3.0 * scale, center.y + (body_height * 0.32 + leg_height - 1.0) * scale, 11.0 * scale, 5.0 * scale)
            draw_rect(slipper_rect, Color(0.67, 0.79, 0.82, 1.0), true)
            draw_rect(slipper_rect, Color(0.14, 0.22, 0.24, 0.76), false, maxf(1.0, scale))

    var tail_start := center + Vector2(-body_length * 0.55 * scale, -5.0 * scale)
    var tail_end := tail_start + Vector2(-15.0 * scale, -8.0 * scale + sin(_elapsed * 7.0) * 3.0 * scale)
    draw_line(tail_start, tail_end, base_color.darkened(0.12), maxf(2.0, 3.0 * scale))

    _draw_dog_object_language(dog_id, center, body_rect, body_length, body_height, leg_height, state, scale, base_color, secondary)

    draw_rect(body_rect.grow(1.5 * scale), Color(0.08, 0.06, 0.04, 0.70), false, maxf(1.0, scale))
    if _show_semantic_labels:
        _draw_dog_action_badge(center, state, scale)
        _draw_dog_role_marker(dog_id, center, scale)

    if _show_semantic_labels:
        var label := "%s | %s" % [str(dog_def["public_name"]), _dog_action_label(state)]
        draw_string(ThemeDB.fallback_font, center + Vector2(-42.0 * scale, -35.0 * scale), label, HORIZONTAL_ALIGNMENT_LEFT, -1.0, 10.0 * scale, Color(0.96, 0.93, 0.78, 1.0))


func _draw_dog_object_language(
        dog_id: String,
        center: Vector2,
        body_rect: Rect2,
        body_length: float,
        body_height: float,
        leg_height: float,
        state: String,
        scale: float,
        base_color: Color,
        secondary: Color
) -> void:
    if dog_id == "dachshund_intro":
        var strap_start := body_rect.position + Vector2(body_rect.size.x * 0.28, body_rect.size.y * 0.28)
        var strap_end := body_rect.position + Vector2(body_rect.size.x * 0.62, body_rect.size.y * 0.72)
        draw_line(strap_start, strap_end, Color(0.16, 0.11, 0.08, 0.62), maxf(1.0, 2.0 * scale))

        if state in ["moving_to_transport", "preparing_transport", "leaving_with_transport", "returning_with_transport"] or (not _route_started and _transport_visible):
            var bike_center := Vector2(_world_to_screen_x(_transport_x), center.y - 18.0 * scale)
            draw_line(center + Vector2(body_length * 0.45, -5.0) * scale, bike_center + Vector2(-20.0, -6.0) * scale, Color(0.68, 0.84, 0.92, 0.66), maxf(1.0, 1.5 * scale))
            draw_line(center + Vector2(body_length * 0.37, 8.0) * scale, bike_center + Vector2(-26.0, 9.0) * scale, Color(0.30, 0.22, 0.16, 0.58), maxf(1.0, scale))

        if _slippers_equipped:
            var paw_y := center.y + (body_height * 0.32 + leg_height + 4.0) * scale
            draw_line(Vector2(center.x - 35.0 * scale, paw_y), Vector2(center.x + 34.0 * scale, paw_y), Color(0.70, 0.88, 0.92, 0.34), maxf(1.0, 2.0 * scale))
            draw_circle(center + Vector2(28.0, 3.0) * scale, 4.0 * scale, Color(0.82, 0.95, 0.98, 0.60))
    else:
        var chest := Rect2(center + Vector2(-16.0, -10.0) * scale, Vector2(24.0, 25.0) * scale)
        draw_rect(chest, Color(0.78, 0.84, 0.68, 0.48), true)
        draw_line(chest.position + Vector2(4.0, 2.0) * scale, chest.position + Vector2(chest.size.x - 4.0 * scale, 2.0 * scale), Color(0.34, 0.42, 0.30, 0.62), maxf(1.0, scale))

        if state in ["carrying_item", "unloading", "loading"]:
            draw_line(center + Vector2(12.0, body_height * 0.14) * scale, center + Vector2(31.0, -2.0) * scale, base_color.darkened(0.20), maxf(2.0, 3.0 * scale))
            draw_line(center + Vector2(7.0, body_height * 0.14 + 6.0) * scale, center + Vector2(31.0, 8.0) * scale, base_color.darkened(0.20), maxf(2.0, 3.0 * scale))
        elif state in ["helping_kitchen", "packing"]:
            draw_circle(center + Vector2(27.0, -2.0) * scale, 4.0 * scale, secondary.lightened(0.12))
            draw_line(center + Vector2(17.0, 8.0) * scale, center + Vector2(31.0, 4.0) * scale, base_color.darkened(0.20), maxf(2.0, 3.0 * scale))


func _draw_dog_action_badge(center: Vector2, state: String, scale: float) -> void:
    if state == "idle":
        return

    var badge_center := center + Vector2(0.0, -32.0 * scale)
    var color := _dog_action_color(state)
    draw_circle(badge_center, 10.0 * scale, Color(color.r, color.g, color.b, 0.92))
    draw_circle(badge_center, 10.0 * scale, Color(0.08, 0.06, 0.04, 0.75), false, maxf(1.0, scale))

    if state in ["carrying_item", "unloading", "loading"]:
        draw_rect(Rect2(badge_center + Vector2(-5.0, -4.0) * scale, Vector2(10.0, 8.0) * scale), Color(0.96, 0.90, 0.68, 0.95), true)
        draw_line(badge_center + Vector2(-12.0, 8.0) * scale, badge_center + Vector2(12.0, 8.0) * scale, Color(0.96, 0.90, 0.68, 0.95), maxf(1.0, scale))
    elif state in ["helping_kitchen", "packing"]:
        draw_line(badge_center + Vector2(-6.0, 3.0) * scale, badge_center + Vector2(6.0, 3.0) * scale, Color(0.98, 0.91, 0.74, 0.95), maxf(1.0, 2.0 * scale))
        draw_circle(badge_center + Vector2(0.0, 0.0), 4.5 * scale, Color(0.98, 0.91, 0.74, 0.95))
    elif state in ["moving_to_transport", "leaving_with_transport", "returning_with_transport"]:
        draw_line(badge_center + Vector2(-6.0, 0.0) * scale, badge_center + Vector2(5.0, 0.0) * scale, Color(0.98, 0.91, 0.74, 0.95), maxf(1.0, 2.0 * scale))
        draw_line(badge_center + Vector2(5.0, 0.0) * scale, badge_center + Vector2(0.0, -5.0) * scale, Color(0.98, 0.91, 0.74, 0.95), maxf(1.0, 2.0 * scale))
        draw_line(badge_center + Vector2(5.0, 0.0) * scale, badge_center + Vector2(0.0, 5.0) * scale, Color(0.98, 0.91, 0.74, 0.95), maxf(1.0, 2.0 * scale))
    else:
        draw_circle(badge_center, 3.8 * scale, Color(0.98, 0.91, 0.74, 0.95))


func _draw_dog_role_marker(dog_id: String, center: Vector2, scale: float) -> void:
    if dog_id == "dachshund_intro":
        var marker := center + Vector2(-8.0, -47.0) * scale
        _draw_world_badge(marker, "водитель", Color(0.22, 0.42, 0.58, 0.88), Color(0.78, 0.90, 0.98, 0.95), 70.0, 8.5)
        var wheel_center := marker + Vector2(-26.0, -1.0) * scale
        draw_circle(wheel_center, 5.5 * scale, Color(0.96, 0.96, 0.88, 0.92), false, maxf(1.0, 1.3 * scale))
        draw_circle(wheel_center + Vector2(13.0, 0.0) * scale, 5.5 * scale, Color(0.96, 0.96, 0.88, 0.92), false, maxf(1.0, 1.3 * scale))
        draw_line(wheel_center + Vector2(0.0, -5.5) * scale, wheel_center + Vector2(13.0, -5.5) * scale, Color(0.96, 0.96, 0.88, 0.92), maxf(1.0, scale))
        if not _route_started and _transport_visible:
            var transport_center := Vector2(_world_to_screen_x(_transport_x), center.y - 8.0 * scale)
            draw_line(center + Vector2(34.0, -22.0) * scale, transport_center + Vector2(-24.0, -22.0) * scale, Color(0.62, 0.82, 0.96, 0.58), maxf(1.0, scale))
    elif dog_id == "labrador_intro":
        var marker := center + Vector2(0.0, -54.0) * scale
        _draw_world_badge(marker, "помощник", Color(0.38, 0.47, 0.30, 0.88), Color(0.88, 0.95, 0.72, 0.95), 76.0, 8.5)
        var carry_center := marker + Vector2(-30.0, 0.0) * scale
        draw_rect(Rect2(carry_center - Vector2(4.0, 3.0) * scale, Vector2(8.0, 6.0) * scale), Color(0.96, 0.92, 0.72, 0.92), true)
        draw_line(carry_center + Vector2(-9.0, 7.0) * scale, carry_center + Vector2(9.0, 7.0) * scale, Color(0.96, 0.92, 0.72, 0.92), maxf(1.0, scale))


func _draw_first_day_readability_cues(baseline: float) -> void:
    var scale := _zoom()
    _draw_route_ready_cue(baseline, scale)
    _draw_payload_returned_cue(baseline, scale)
    _draw_van_dispatch_cue(baseline, scale)
    _draw_postcard_world_cue(baseline, scale)
    _draw_reward_world_cue(baseline, scale)
    _draw_next_day_world_cue(baseline, scale)
    _draw_day2_packing_care_cue(baseline, scale)


func _draw_route_ready_cue(baseline: float, scale: float) -> void:
    var road_sign := Vector2(_world_to_screen_x(_anchor_x("road_sign")), baseline - 83.0 * scale)
    var bicycle := Vector2(_world_to_screen_x(_transport_x), baseline - 72.0 * scale)
    if not _route_started:
        var route_slip := Rect2(road_sign + Vector2(-16.0, -31.0) * scale, Vector2(34.0, 24.0) * scale)
        draw_rect(route_slip, Color(0.86, 0.78, 0.56, 0.92), true)
        draw_rect(route_slip, Color(0.32, 0.24, 0.16, 0.78), false, maxf(1.0, scale))
        draw_line(route_slip.position + Vector2(6.0, 7.0) * scale, route_slip.position + Vector2(27.0, 7.0) * scale, Color(0.33, 0.27, 0.16, 0.70), maxf(1.0, scale))
        draw_line(route_slip.position + Vector2(9.0, 15.0) * scale, route_slip.position + Vector2(24.0, 15.0) * scale, Color(0.33, 0.27, 0.16, 0.54), maxf(1.0, scale))
        draw_line(road_sign + Vector2(19.0, -2.0) * scale, bicycle + Vector2(-22.0, 3.0) * scale, Color(0.66, 0.84, 0.96, 0.42), maxf(1.0, 1.5 * scale))
        if _show_semantic_labels:
            _draw_arrow(road_sign + Vector2(20.0, 5.0) * scale, bicycle + Vector2(-18.0, 2.0) * scale, Color(0.66, 0.84, 0.96, 0.72), maxf(1.0, 2.0 * scale))
            _draw_world_badge(road_sign + Vector2(10.0, -23.0) * scale, "Овсяная ферма", Color(0.20, 0.32, 0.39, 0.86), Color(0.72, 0.89, 0.98, 0.95), 116.0, 8.2)
    elif _transport_state in ["away", "returning", "waiting_for_unload"] or _trip_payload_visible:
        draw_circle(road_sign + Vector2(13.0, -26.0) * scale, 8.0 * scale, Color(0.78, 0.92, 0.72, 0.72))
        draw_line(road_sign + Vector2(8.0, -26.0) * scale, road_sign + Vector2(12.0, -21.0) * scale, Color(0.24, 0.36, 0.30, 0.88), maxf(1.0, 2.0 * scale))
        draw_line(road_sign + Vector2(12.0, -21.0) * scale, road_sign + Vector2(20.0, -31.0) * scale, Color(0.24, 0.36, 0.30, 0.88), maxf(1.0, 2.0 * scale))
        if _show_semantic_labels:
            _draw_world_badge(road_sign + Vector2(18.0, -23.0) * scale, "маршрут пройден", Color(0.24, 0.36, 0.30, 0.78), Color(0.78, 0.92, 0.72, 0.90), 116.0, 8.2)


func _draw_payload_returned_cue(baseline: float, scale: float) -> void:
    if not _trip_payload_visible or not _transport_visible:
        return

    var center := Vector2(_world_to_screen_x(_transport_x), baseline - 76.0 * scale)
    draw_circle(center, 34.0 * scale, Color(0.95, 0.78, 0.38, 0.14))
    draw_circle(center, 34.0 * scale, Color(0.95, 0.78, 0.38, 0.62), false, maxf(1.0, 1.5 * scale))
    if _show_semantic_labels:
        _draw_world_badge(center + Vector2(6.0, -31.0) * scale, "груз вернулся", Color(0.42, 0.31, 0.18, 0.84), Color(0.96, 0.82, 0.52, 0.94), 106.0, 8.2)
        _draw_arrow(center + Vector2(28.0, 18.0) * scale, Vector2(_world_to_screen_x(_anchor_x("storage")) - 54.0 * scale, baseline - 58.0 * scale), Color(0.92, 0.78, 0.46, 0.54), maxf(1.0, scale))


func _draw_van_dispatch_cue(baseline: float, scale: float) -> void:
    if not _van_loaded:
        return

    var van_center := Vector2(_world_to_screen_x(_anchor_x("delivery_van_endpoint")), baseline - 78.0 * scale)
    var color := Color(0.54, 0.78, 0.52, 0.78)
    if _delivery_confirmed and not _delivery_complete:
        color = Color(0.64, 0.74, 0.86, 0.62)
    elif _delivery_complete:
        color = Color(0.68, 0.82, 0.68, 0.66)
    draw_circle(van_center, 42.0 * scale, Color(color.r, color.g, color.b, 0.14))
    draw_circle(van_center, 42.0 * scale, color, false, maxf(1.0, 1.7 * scale))
    var hatch := Rect2(van_center + Vector2(-64.0, -24.0) * scale, Vector2(52.0, 38.0) * scale)
    draw_rect(hatch, Color(0.23, 0.30, 0.34, 0.78), true)
    draw_line(hatch.position + Vector2(0.0, 0.0), hatch.position + Vector2(-13.0, -15.0) * scale, Color(0.68, 0.75, 0.78, 0.86), maxf(1.0, 2.0 * scale))
    if not _delivery_confirmed:
        var bag := Rect2(hatch.position + Vector2(16.0, 7.0) * scale, Vector2(23.0, 27.0) * scale)
        draw_rect(bag, Color(0.58, 0.74, 0.50, 0.96), true)
        draw_rect(Rect2(bag.position + Vector2(7.0, -5.0) * scale, Vector2(9.0, 7.0) * scale), Color(0.70, 0.84, 0.60, 0.96), true)
        draw_line(bag.position + Vector2(4.0, 10.0) * scale, bag.position + Vector2(bag.size.x - 4.0 * scale, 10.0 * scale), Color(0.22, 0.36, 0.22, 0.78), maxf(1.0, scale))
    else:
        draw_line(hatch.position + Vector2(13.0, 18.0) * scale, hatch.position + Vector2(40.0, 18.0) * scale, Color(0.72, 0.80, 0.84, 0.45), maxf(1.0, scale))
    if _show_semantic_labels:
        if not _delivery_confirmed:
            _draw_world_badge(van_center + Vector2(0.0, -42.0) * scale, "фургон готов", Color(0.22, 0.40, 0.24, 0.86), Color(0.82, 0.95, 0.70, 0.96), 106.0, 8.4)
        elif not _delivery_complete:
            _draw_world_badge(van_center + Vector2(0.0, -42.0) * scale, "отправляется", Color(0.24, 0.33, 0.44, 0.82), Color(0.78, 0.88, 0.98, 0.92), 104.0, 8.4)
        else:
            _draw_world_badge(van_center + Vector2(0.0, -42.0) * scale, "доставлено", Color(0.24, 0.33, 0.44, 0.82), Color(0.78, 0.88, 0.98, 0.92), 88.0, 8.4)


func _draw_postcard_world_cue(baseline: float, scale: float) -> void:
    if not _postcard_board_visible():
        return

    var board_center := Vector2(_world_to_screen_x(_anchor_x("delivery_van_endpoint") + 112.0), baseline - 43.0 * scale)
    var board_size := Vector2(96.0, 48.0) * scale
    var rect := Rect2(board_center - board_size * 0.5, board_size)
    draw_rect(rect, Color(0.60, 0.45, 0.30, 0.92), true)
    draw_rect(rect, Color(0.28, 0.18, 0.12, 0.84), false, maxf(1.0, 1.5 * scale))
    var postcard := Rect2(rect.position + Vector2(15.0, 8.0) * scale, Vector2(65.0, 31.0) * scale)
    draw_rect(postcard, Color(0.92, 0.84, 0.64, 0.98), true)
    draw_rect(postcard, Color(0.32, 0.22, 0.15, 0.70), false, maxf(1.0, scale))
    draw_circle(postcard.position + Vector2(52.0, 8.0) * scale, 3.0 * scale, Color(0.72, 0.46, 0.38, 0.86))
    draw_line(postcard.position + Vector2(9.0, 11.0) * scale, postcard.position + Vector2(42.0, 11.0) * scale, Color(0.36, 0.22, 0.14, 0.66), maxf(1.0, scale))
    draw_line(postcard.position + Vector2(10.0, 21.0) * scale, postcard.position + Vector2(46.0, 21.0) * scale, Color(0.36, 0.22, 0.14, 0.50), maxf(1.0, scale))
    if _show_semantic_labels:
        var postcard_label := "вчерашняя открытка" if _is_day2_context() else "открытка"
        _draw_world_badge(board_center + Vector2(0.0, -36.0) * scale, postcard_label, Color(0.42, 0.30, 0.20, 0.82), Color(0.96, 0.82, 0.60, 0.94), 126.0 if _is_day2_context() else 78.0, 8.4)

    if _is_day2_context() and bool(_day2.get("second_feedback_visible", false)):
        var progress_note := Rect2(rect.position + Vector2(54.0, 20.0) * scale, Vector2(36.0, 22.0) * scale)
        draw_rect(progress_note, Color(0.68, 0.80, 0.61, 0.98), true)
        draw_rect(progress_note, Color(0.20, 0.32, 0.20, 0.82), false, maxf(1.0, scale))
        draw_line(progress_note.position + Vector2(6.0, 7.0) * scale, progress_note.position + Vector2(30.0, 7.0) * scale, Color(0.20, 0.32, 0.20, 0.68), maxf(1.0, scale))
        draw_line(progress_note.position + Vector2(8.0, 14.0) * scale, progress_note.position + Vector2(27.0, 14.0) * scale, Color(0.20, 0.32, 0.20, 0.52), maxf(1.0, scale))
        if _show_semantic_labels:
            _draw_world_badge(board_center + Vector2(30.0, 34.0) * scale, "2-я доставка готова", Color(0.22, 0.38, 0.24, 0.86), Color(0.82, 0.95, 0.72, 0.96), 136.0, 8.2)

    if _first_day_postcard_life_moment_seen:
        for dog_id in ["dachshund_intro", "labrador_intro"]:
            if not _dogs.has(dog_id):
                continue
            var dog := _dogs[dog_id] as Dictionary
            if not bool(dog.get("visible", true)):
                continue
            var dog_center := Vector2(_world_to_screen_x(float(dog.get("x", 0.0))), baseline - 70.0 * scale)
            draw_circle(dog_center, 4.0 * scale, Color(0.98, 0.91, 0.68, 0.88))
            draw_circle(dog_center + Vector2(8.0, -7.0) * scale, 2.6 * scale, Color(0.98, 0.91, 0.68, 0.72))
            draw_line(dog_center + Vector2(10.0, -1.0) * scale, board_center + Vector2(-28.0, -5.0) * scale, Color(0.96, 0.82, 0.56, 0.30), maxf(1.0, scale))


func _draw_reward_world_cue(baseline: float, scale: float) -> void:
    if not _slippers_equipped or not _dogs.has("dachshund_intro"):
        return

    var dog := _dogs["dachshund_intro"] as Dictionary
    if not bool(dog.get("visible", true)):
        return

    var dog_center := Vector2(_world_to_screen_x(float(dog.get("x", 0.0))), baseline - 34.0 * scale)
    var marker_center := dog_center + Vector2(22.0, -68.0) * scale
    draw_circle(dog_center + Vector2(10.0, 20.0) * scale, 22.0 * scale, Color(0.72, 0.90, 0.96, 0.16))
    _draw_slippers_icon(dog_center + Vector2(19.0, 22.0) * scale, scale * 1.25, Color(0.68, 0.84, 0.88, 0.96))
    if _show_semantic_labels:
        _draw_world_badge(marker_center, "тапочки Таксы", Color(0.22, 0.36, 0.40, 0.88), Color(0.74, 0.91, 0.96, 0.96), 116.0, 8.2)
        _draw_slippers_icon(marker_center + Vector2(-42.0, 0.0) * scale, scale, Color(0.68, 0.84, 0.88, 0.96))
        draw_line(marker_center + Vector2(18.0, 9.0) * scale, dog_center + Vector2(10.0, 8.0) * scale, Color(0.72, 0.90, 0.96, 0.42), maxf(1.0, scale))


func _draw_next_day_world_cue(baseline: float, scale: float) -> void:
    if not _packing_note_visible():
        return

    var show_day2_question := _is_day2_context() and bool(_day2.get("curiosity_question_available", false))
    var note_center := Vector2(_world_to_screen_x(_anchor_x("packing_table") + 112.0), baseline - 47.0 * scale)
    var note_size := Vector2(214.0 if _show_semantic_labels or show_day2_question else 82.0, 48.0) * scale
    var rect := Rect2(note_center - note_size * 0.5, note_size)
    draw_rect(rect, Color(0.74, 0.80, 0.62, 0.92), true)
    draw_rect(rect, Color(0.20, 0.30, 0.20, 0.82), false, maxf(1.0, 1.5 * scale))
    var fold := PackedVector2Array([
        rect.end - Vector2(15.0, 0.0) * scale,
        rect.end,
        rect.end - Vector2(0.0, 15.0) * scale,
    ])
    draw_colored_polygon(fold, Color(0.58, 0.68, 0.56, 0.92))
    if show_day2_question:
        draw_string(ThemeDB.fallback_font, rect.position + Vector2(10.0, 25.0) * scale, DAY2_CURIOSITY_QUESTION, HORIZONTAL_ALIGNMENT_LEFT, rect.size.x - 20.0 * scale, 8.2 * scale, Color(0.24, 0.32, 0.20, 1.0))
    elif _show_semantic_labels:
        if _is_day2_active():
            draw_string(ThemeDB.fallback_font, rect.position + Vector2(10.0, 17.0) * scale, "Заметка: паковать", HORIZONTAL_ALIGNMENT_LEFT, rect.size.x - 20.0 * scale, 8.2 * scale, Color(0.24, 0.32, 0.20, 1.0))
            draw_string(ThemeDB.fallback_font, rect.position + Vector2(10.0, 32.0) * scale, "ещё аккуратнее.", HORIZONTAL_ALIGNMENT_LEFT, rect.size.x - 20.0 * scale, 8.2 * scale, Color(0.24, 0.32, 0.20, 1.0))
        else:
            draw_string(ThemeDB.fallback_font, rect.position + Vector2(10.0, 17.0) * scale, "Завтра: паковать", HORIZONTAL_ALIGNMENT_LEFT, rect.size.x - 20.0 * scale, 8.2 * scale, Color(0.24, 0.32, 0.20, 1.0))
            draw_string(ThemeDB.fallback_font, rect.position + Vector2(10.0, 32.0) * scale, "ещё аккуратнее.", HORIZONTAL_ALIGNMENT_LEFT, rect.size.x - 20.0 * scale, 8.2 * scale, Color(0.24, 0.32, 0.20, 1.0))
    else:
        draw_line(rect.position + Vector2(10.0, 14.0) * scale, rect.position + Vector2(56.0, 14.0) * scale, Color(0.24, 0.32, 0.20, 0.58), maxf(1.0, scale))
        draw_line(rect.position + Vector2(12.0, 25.0) * scale, rect.position + Vector2(48.0, 25.0) * scale, Color(0.24, 0.32, 0.20, 0.46), maxf(1.0, scale))
        draw_circle(rect.position + Vector2(61.0, 34.0) * scale, 3.0 * scale, Color(0.24, 0.32, 0.20, 0.48))


func _draw_day2_packing_care_cue(baseline: float, scale: float) -> void:
    if not _is_day2_active() or not _has_current_task("PackTask", "in_progress"):
        return
    if str(_current_task.get("assigned_dog_id", "")) != "labrador_intro":
        return
    var center := Vector2(_world_to_screen_x(_anchor_x("packing_table")), baseline - 54.0 * scale)
    draw_circle(center, 30.0 * scale, Color(0.94, 0.84, 0.55, 0.12))
    draw_arc(center, 24.0 * scale, -2.8, -0.35, 18, Color(0.96, 0.86, 0.58, 0.86), maxf(1.0, 1.8 * scale))
    for offset in [Vector2(-18.0, -26.0), Vector2(0.0, -33.0), Vector2(18.0, -26.0)]:
        draw_line(center + offset * scale, center + (offset + Vector2(0.0, -8.0)) * scale, Color(0.96, 0.88, 0.62, 0.82), maxf(1.0, 1.5 * scale))
    if _show_semantic_labels:
        _draw_world_badge(center + Vector2(0.0, -48.0) * scale, "бережно", Color(0.38, 0.30, 0.18, 0.86), Color(0.98, 0.88, 0.62, 0.96), 74.0, 8.4)


func _postcard_board_visible() -> bool:
    return _postcard_visible or bool(_first_day_history.get("postcard_visible", false))


func _packing_note_visible() -> bool:
    return _first_day_next_day_hint_available or bool(_first_day_history.get("packing_note_visible", false)) or bool(_day2.get("packing_note_visible", false))


func _draw_world_badge(center: Vector2, text: String, fill: Color, outline: Color, width: float, font_size: float) -> void:
    var scale := _zoom()
    var rect := Rect2(center.x - width * 0.5 * scale, center.y - 9.0 * scale, width * scale, 18.0 * scale)
    draw_rect(rect, fill, true)
    draw_rect(rect, outline, false, maxf(1.0, scale))
    draw_string(ThemeDB.fallback_font, rect.position + Vector2(5.0, 13.0) * scale, text, HORIZONTAL_ALIGNMENT_LEFT, rect.size.x - 10.0 * scale, font_size * scale, Color(0.98, 0.96, 0.84, 1.0))


func _draw_slippers_icon(center: Vector2, scale: float, color: Color) -> void:
    draw_rect(Rect2(center + Vector2(-7.0, -3.5) * scale, Vector2(12.0, 5.0) * scale), color, true)
    draw_rect(Rect2(center + Vector2(1.0, 2.0) * scale, Vector2(12.0, 5.0) * scale), color.darkened(0.08), true)
    draw_rect(Rect2(center + Vector2(-7.0, -3.5) * scale, Vector2(12.0, 5.0) * scale), Color(0.14, 0.22, 0.24, 0.74), false, maxf(1.0, scale))
    draw_rect(Rect2(center + Vector2(1.0, 2.0) * scale, Vector2(12.0, 5.0) * scale), Color(0.14, 0.22, 0.24, 0.74), false, maxf(1.0, scale))


func _draw_arrow(from_pos: Vector2, to_pos: Vector2, color: Color, width: float) -> void:
    if from_pos.distance_to(to_pos) < 1.0:
        return

    var direction := (to_pos - from_pos).normalized()
    var side := Vector2(-direction.y, direction.x)
    draw_line(from_pos, to_pos, color, width)
    var arrow_points := PackedVector2Array()
    arrow_points.append(to_pos)
    arrow_points.append(to_pos - direction * 10.0 * _zoom() + side * 5.0 * _zoom())
    arrow_points.append(to_pos - direction * 10.0 * _zoom() - side * 5.0 * _zoom())
    draw_colored_polygon(arrow_points, color)


func _dog_action_color(state: String) -> Color:
    if state in ["carrying_item", "unloading", "loading"]:
        return Color(0.54, 0.77, 0.56, 1.0)
    if state in ["helping_kitchen", "packing"]:
        return Color(0.76, 0.58, 0.34, 1.0)
    if state in ["moving_to_transport", "leaving_with_transport", "returning_with_transport"]:
        return Color(0.50, 0.68, 0.84, 1.0)
    if state in ["celebrating", "equipped_with_slippers"]:
        return Color(0.74, 0.68, 0.88, 1.0)
    return Color(0.78, 0.72, 0.52, 1.0)


func _dog_action_label(state: String) -> String:
    match state:
        "moving_to_transport":
            return "к велосипеду"
        "preparing_transport":
            return "готовит поездку"
        "leaving_with_transport":
            return "уезжает"
        "returning_with_transport":
            return "возвращается"
        "unloading":
            return "выгружает"
        "carrying_item":
            return "несёт"
        "helping_kitchen":
            return "готовит"
        "packing":
            return "фасует"
        "loading":
            return "грузит"
        "celebrating":
            return "радуется"
        "equipped_with_slippers":
            return "в тапочках"
        _:
            return "IdleTask"


func _draw_world_state_labels(baseline: float) -> void:
    if not _show_semantic_labels:
        return

    var font := ThemeDB.fallback_font
    for anchor_id in ["road_sign", "storage", "kitchen", "packing_table", "delivery_van_endpoint"]:
        var anchor := ANCHOR_DEFS[anchor_id] as Dictionary
        var x := _world_to_screen_x(float(anchor["x"]))
        var label := "%s\n%s" % [str(anchor["label"]), str(anchor["taxonomy"])]
        draw_string(font, Vector2(x - 54.0 * _zoom(), baseline - 110.0 * _zoom()), label, HORIZONTAL_ALIGNMENT_LEFT, -1.0, 10.0 * _zoom(), Color(0.91, 0.88, 0.70, 1.0))

    if _delivery_state == "ready_to_send":
        var delivery_x := _world_to_screen_x(_anchor_x("delivery_van_endpoint"))
        draw_string(font, Vector2(delivery_x - 58.0 * _zoom(), baseline - 130.0 * _zoom()), "ready: player confirmation", HORIZONTAL_ALIGNMENT_LEFT, -1.0, 11.0 * _zoom(), Color(0.78, 0.95, 0.70, 1.0))


func _token_screen_position(token: Dictionary, baseline: float) -> Vector2:
    var resource_id := str(token.get("resource_id", ""))
    var location := str(token.get("location", ""))
    var x := 0.0
    var y := baseline - (56.0 * _zoom())

    match location:
        "carried":
            var dog_id := str(token.get("carried_by", ""))
            var dog := _dogs.get(dog_id, {"x": 0.0}) as Dictionary
            x = _world_to_screen_x(float(dog.get("x", 0.0)) + 22.0)
            y = baseline - (50.0 * _zoom())
        "transport_payload":
            x = _world_to_screen_x(_transport_x + _resource_payload_offset(resource_id))
            y = baseline - (76.0 * _zoom())
        "storage":
            x = _world_to_screen_x(_anchor_x("storage") + _resource_storage_offset(resource_id))
            y = baseline - (56.0 * _zoom())
        "kitchen":
            x = _world_to_screen_x(_anchor_x("kitchen") + _resource_station_offset(resource_id))
            y = baseline - (78.0 * _zoom())
        "packing_table":
            x = _world_to_screen_x(_anchor_x("packing_table") + _resource_station_offset(resource_id))
            y = baseline - (70.0 * _zoom())
        "delivery_van_endpoint":
            x = _world_to_screen_x(_anchor_x("delivery_van_endpoint") - 38.0)
            y = baseline - (62.0 * _zoom())
        _:
            x = _world_to_screen_x(_anchor_x("storage"))

    return Vector2(x, y)


func _resource_payload_offset(resource_id: String) -> float:
    return -18.0 if resource_id == "oat_crate" else 20.0


func _resource_storage_offset(resource_id: String) -> float:
    var index := RESOURCE_ORDER.find(resource_id)
    if index < 0:
        index = 0
    return -58.0 + (float(index % 4) * 30.0)


func _resource_station_offset(resource_id: String) -> float:
    match resource_id:
        "food_mix":
            return -24.0
        "food_bag":
            return 26.0
        "packaging_bag":
            return 28.0
        _:
            var index := RESOURCE_ORDER.find(resource_id)
            return -38.0 + (float(maxi(index, 0)) * 20.0)


func _anchor_x(anchor_id: String) -> float:
    if anchor_id == "basket_bicycle" or anchor_id == "transport_payload":
        return _transport_x
    if ANCHOR_DEFS.has(anchor_id):
        return float((ANCHOR_DEFS[anchor_id] as Dictionary)["x"])
    if anchor_id == "offscreen_left":
        return -160.0
    if DOG_DEFS.has(anchor_id):
        return float((DOG_DEFS[anchor_id] as Dictionary)["start_x"])
    return 0.0


func _resolve_world_x(value: Variant) -> float:
    if typeof(value) == TYPE_FLOAT or typeof(value) == TYPE_INT:
        return float(value)

    var key := str(value)
    if key == "offscreen_left":
        return -160.0
    if key == "basket_bicycle" or key == "transport_payload":
        return _transport_x
    return _anchor_x(key)


func _world_to_screen_x(world_x: float) -> float:
    return (world_x - _camera_x) * _zoom()


func _visible_world_width() -> float:
    return _viewport_size().x / _zoom()


func _field_baseline() -> float:
    return maxf(148.0, _viewport_size().y - 36.0)


func _viewport_size() -> Vector2:
    var window_size := DisplayServer.window_get_size(WINDOW_ID)
    return Vector2(maxf(size.x, float(window_size.x)), maxf(size.y, float(window_size.y)))


func _zoom() -> float:
    if _view_mode == "player_prototype":
        return _viewport_size().x / WORLD_WIDTH
    return float(ZOOM_LEVELS[_zoom_index])


func _set_zoom_index(index: int) -> void:
    _zoom_index = clampi(index, 0, ZOOM_LEVELS.size() - 1)
    _camera_x = _clamped_camera_x(_camera_x)
    _apply_mouse_passthrough()
    queue_redraw()


func _pan(direction: float) -> void:
    _camera_x = _clamped_camera_x(_camera_x + (direction * 92.0 / _zoom()))
    _apply_mouse_passthrough()
    queue_redraw()


func _clamped_camera_x(raw_camera_x: float) -> float:
    return clampf(raw_camera_x, 0.0, maxf(WORLD_WIDTH - _visible_world_width(), 0.0))


func _label_to_zoom_index(label: String, fallback: int) -> int:
    var clean_label := label.strip_edges()
    for i in ZOOM_LABELS.size():
        if ZOOM_LABELS[i] == clean_label:
            return i
    var raw_index := clean_label.to_int()
    if raw_index >= 0 and raw_index < ZOOM_LEVELS.size():
        return raw_index
    return fallback


func _apply_mouse_passthrough() -> void:
    if not _transparent_window or not _click_through_empty:
        DisplayServer.window_set_mouse_passthrough(PackedVector2Array(), WINDOW_ID)
        return

    DisplayServer.window_set_mouse_passthrough(_interactive_mouse_polygon(), WINDOW_ID)


func _interactive_mouse_polygon() -> PackedVector2Array:
    var viewport_size := _viewport_size()
    var field_top := clampf(_field_baseline() - (126.0 * _zoom()) - MOUSE_PASSTHROUGH_PADDING, 0.0, viewport_size.y)
    var intervals: Array[Dictionary] = []

    _add_mouse_interval(intervals, 0.0, viewport_size.x, field_top, viewport_size.x, field_top)

    for control in _interactive_controls():
        if control == null or not control.visible:
            continue
        var rect := Rect2(control.global_position, control.size).grow(MOUSE_PASSTHROUGH_PADDING)
        _add_mouse_interval(intervals, rect.position.x, rect.end.x, rect.position.y, viewport_size.x, field_top)

    var merged := _merged_mouse_intervals(intervals)
    var points := PackedVector2Array()
    points.append(Vector2(0.0, field_top))

    var cursor_x := 0.0
    for interval in merged:
        var x1 := float(interval["x1"])
        var x2 := float(interval["x2"])
        var top := float(interval["top"])

        if x1 > cursor_x:
            points.append(Vector2(x1, field_top))

        points.append(Vector2(x1, top))
        points.append(Vector2(x2, top))
        points.append(Vector2(x2, field_top))
        cursor_x = x2

    if cursor_x < viewport_size.x:
        points.append(Vector2(viewport_size.x, field_top))

    points.append(Vector2(viewport_size.x, viewport_size.y))
    points.append(Vector2(0.0, viewport_size.y))
    return points


func _interactive_controls() -> Array[Control]:
    return [
        _order_card,
        _route_card,
        _dog_card,
        _postcard_card,
        _debug_card,
        _visibility_button,
        _semantic_button,
    ]


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


func _emit_event(event_name: String, details_override: Dictionary = {}) -> void:
    var details := _event_details(event_name)
    details = _merge_event_details(details, details_override)
    var event := _systems_runtime.emit_event(_elapsed, event_name, details)
    _last_event = str(event.get("type", event_name))
    var line := "%.2f %s" % [float(event.get("time", _elapsed)), event_name]
    _event_log.append(line)
    print("vertical_slice_event=%s" % event_name)


func _merge_event_details(base: Dictionary, override: Dictionary) -> Dictionary:
    var merged := base.duplicate(true)
    if override.is_empty():
        return merged

    for key in override.keys():
        if str(key) == "payload" and override[key] is Dictionary:
            var payload := (merged.get("payload", {}) as Dictionary).duplicate(true)
            for payload_key in (override[key] as Dictionary).keys():
                payload[payload_key] = (override[key] as Dictionary)[payload_key]
            merged["payload"] = payload
        else:
            merged[key] = override[key]
    return merged


func _emit_task_dog_action(event_name: String, task: Dictionary, message: String, payload_override: Dictionary = {}) -> void:
    if task.is_empty():
        return

    _emit_event(event_name, _task_dog_action_details(task, message, payload_override))


func _task_dog_action_details(task: Dictionary, message: String, payload_override: Dictionary = {}) -> Dictionary:
    var dog_ids: Array[String] = []
    var dog_key: Variant = _dog_key_from_internal(str(task.get("assigned_dog_id", "")))
    if dog_key != null:
        dog_ids.append(str(dog_key))

    var place_ids: Array[String] = []
    var source_key: Variant = _object_key_from_internal(str(task.get("source_object_id", "")))
    var target_key: Variant = _object_key_from_internal(str(task.get("target_object_id", "")))
    if source_key != null:
        place_ids.append(str(source_key))
    if target_key != null and not (str(target_key) in place_ids):
        place_ids.append(str(target_key))

    var payload := {
        "task_id": str(task.get("id", "")),
        "task_type": str(task.get("type", "")),
        "order_id": str(task.get("order_id", _active_order_id())),
    }
    var resource_id := str(task.get("resource_id", ""))
    if resource_id != "":
        payload["internal_resource_id"] = resource_id
        payload["resource_id"] = _resource_key_from_internal(resource_id)
    for payload_key in payload_override.keys():
        payload[payload_key] = payload_override[payload_key]

    return {
        "tag": "dog_action",
        "dog_ids": dog_ids,
        "place_ids": place_ids,
        "building_ids": place_ids,
        "chain_ids": ["chain.warm_food_delivery_intro"],
        "message": message,
        "payload": payload,
    }


func _dog_action_resource_message(task: Dictionary, action: String) -> String:
    var dog_label := "Собака"
    var dog_id := str(task.get("assigned_dog_id", ""))
    if _dogs.has(dog_id):
        var dog := _dogs[dog_id] as Dictionary
        dog_label = str((DOG_DEFS[dog_id] as Dictionary).get("public_name", dog.get("id", dog_id)))

    var resource_label := str(task.get("resource_id", "resource"))
    if RESOURCE_DEFS.has(resource_label):
        resource_label = str((RESOURCE_DEFS[resource_label] as Dictionary).get("name", resource_label))

    if action == "picked_up":
        return "%s взяла %s" % [dog_label, resource_label]
    return "%s доставила %s" % [dog_label, resource_label]


func _prepare_capture_directories() -> void:
    DirAccess.make_dir_recursive_absolute(_capture_root())
    DirAccess.make_dir_recursive_absolute(_capture_screenshot_dir())
    DirAccess.make_dir_recursive_absolute(_capture_video_dir())
    DirAccess.make_dir_recursive_absolute(_capture_log_dir())
    DirAccess.make_dir_recursive_absolute(_capture_frame_dir())
    if _first_day_art_ux_capture:
        DirAccess.make_dir_recursive_absolute(_capture_frame_dir("postcard_slippers"))
    print("vertical_slice_capture_dir=%s" % _capture_root())


func _begin_capture_initial_sequence() -> void:
    _capture_initializing = true
    if _day2_visible_capture:
        _apply_view_mode("player_prototype")
        await get_tree().process_frame
        await get_tree().process_frame
        _schedule_capture("01_day2_return_moment")
        await _wait_for_capture_idle()
        _capture_initializing = false
        _auto_action_gate = 0.12
        return

    _apply_view_mode("qa")
    await get_tree().process_frame
    await get_tree().process_frame
    _schedule_capture("01_initial_strip_qa_labels_on")
    await _wait_for_capture_idle()

    _apply_view_mode("player_prototype")
    await get_tree().process_frame
    await get_tree().process_frame
    _schedule_capture("02_initial_strip_player_prototype")
    await _wait_for_capture_idle()

    if _first_day_visible_capture:
        _schedule_capture("03_route_prep_dachshund_bicycle" if _first_day_art_ux_capture else "03_first_route_ready")
        await _wait_for_capture_idle()

    _capture_initializing = false
    _auto_action_gate = 0.12


func _maybe_capture_timeline(delta: float) -> void:
    if not _capture_mode:
        return

    _capture_frame_time += delta
    if _capture_frame_time >= CAPTURE_FRAME_INTERVAL:
        _capture_frame_time = 0.0
        _capture_frame_index += 1
        _schedule_capture("frame_%04d" % _capture_frame_index, true)

    if _capture_smoke and _captured_files.size() >= 4:
        _write_capture_log()
        get_tree().quit(0)
        return

    if _day2_visible_capture:
        if _has_current_task("PackTask", "in_progress") and str(_current_task.get("assigned_dog_id", "")) == "labrador_intro":
            _schedule_capture("02_day2_labrador_packing_care")
        if _van_loaded and not _delivery_confirmed:
            _schedule_capture("03_day2_van_ready")
        if _delivery_confirmed and _has_current_task("DeliveryTask") and not _delivery_complete:
            _schedule_capture("04_day2_player_confirmed_dispatch")
        if bool(_day2.get("second_feedback_visible", false)) and not bool(_day2.get("curiosity_question_available", false)):
            _schedule_capture("05_day2_second_delivery_progress_note")
        if bool(_day2.get("quiet_end_state_reached", false)):
            _schedule_capture("06_day2_curiosity_question_quiet_end")
        return

    if _first_day_visible_capture and _has_current_task("TripTask", "in_progress") and _current_step_has("move_transport_to", "offscreen_left"):
        _schedule_capture("04_dog_departure_bicycle")
    if _trip_payload_visible:
        _schedule_capture(_capture_moment_id("03_bicycle_return_payload", "05_bicycle_return_payload", "05_bicycle_return_payload_objects"))
    if _has_current_task("UnloadTask", "moving_to_target") or _has_current_task("UnloadTask", "completing"):
        _schedule_capture(_capture_moment_id("04_unload_to_storage", "06_unload_to_storage"))
    if _has_carry_task("storage", "kitchen"):
        _schedule_capture(_capture_moment_id("05_storage_to_kitchen_carry", "07_storage_to_kitchen_carry", "07_storage_to_kitchen_carry_object"))
    if _has_current_task("CookTask", "in_progress") or _token_at("food_mix", "kitchen"):
        _schedule_capture(_capture_moment_id("06_kitchen_food_mix", "08_kitchen_food_mix"))
    if _has_carry_task("kitchen", "packing_table", "food_mix"):
        _schedule_capture(_capture_moment_id("07_food_mix_to_packing_table", "09_food_mix_to_packing_table"))
    if _token_at("food_bag", "packing_table"):
        _schedule_capture(_capture_moment_id("08_packing_table_food_bag", "10_packing_table_food_bag", "10_packing_table_food_bag_state"))
    if _has_current_task("LoadVanTask", "moving_to_target") or _has_current_task("LoadVanTask", "completing"):
        _schedule_capture(_capture_moment_id("09_food_bag_to_van", "11_food_bag_to_van"))
    if _van_loaded and not _delivery_confirmed:
        _schedule_capture(_capture_moment_id("09b_van_ready_confirm_delivery", "12_van_ready_confirm_delivery", "12_van_ready_object_state"))
    if _postcard_visible:
        _schedule_capture(_capture_moment_id("10_postcard_reward", "13_delivery_complete_postcard_moment", "13_delivery_complete_postcard_board"))
    if _first_day_art_ux_capture and (_postcard_visible or _reward_available or _slippers_equipped):
        _capture_moment_frame_index += 1
        _schedule_capture("postcard_slippers_%04d" % _capture_moment_frame_index, true, 0, "postcard_slippers")
    if _first_day_visible_capture and _first_day_postcard_life_moment_seen:
        _schedule_capture("14_dogs_notice_postcard_hidden_ui" if _first_day_art_ux_capture else "14_dog_noticed_postcard", false, 0, "", _first_day_art_ux_capture)
    if _slippers_equipped:
        _schedule_capture(_capture_moment_id("11_dog_card_slippers", "15_dog_card_memory_slippers", "15_slippers_equip_dachshund_hidden_ui"), false, 0, "", _first_day_art_ux_capture)
    if _first_day_visible_capture and _first_day_next_day_hint_available:
        _schedule_capture("16_next_day_note_hidden_ui" if _first_day_art_ux_capture else "16_next_day_hint", false, 0, "", _first_day_art_ux_capture)


func _begin_capture_finish_sequence() -> void:
    if _capture_finish_started:
        return

    _capture_finish_started = true
    if _day2_visible_capture:
        _schedule_capture("06_day2_curiosity_question_quiet_end")
        _finish_day2_capture_sequence.call_deferred()
        return
    _schedule_capture(_capture_moment_id("11_dog_card_slippers", "15_dog_card_memory_slippers", "15_slippers_equip_dachshund_hidden_ui"), false, 0, "", _first_day_art_ux_capture)
    if _first_day_visible_capture:
        _schedule_capture("16_next_day_note_hidden_ui" if _first_day_art_ux_capture else "16_next_day_hint", false, 0, "", _first_day_art_ux_capture)
    _finish_capture_sequence.call_deferred()


func _finish_capture_sequence() -> void:
    await get_tree().process_frame
    await get_tree().process_frame

    _apply_view_mode("player_prototype")
    _ui_hidden = true
    _update_ui()
    queue_redraw()
    _schedule_capture(_capture_moment_id("12_ui_hidden_world_visible", "17_ui_hidden_world_visible"))
    await get_tree().create_timer(0.35).timeout
    _schedule_capture(_capture_moment_id("13_readability_preview_216", "18_readability_preview_216"), false, 216)
    _schedule_capture(_capture_moment_id("14_readability_preview_144", "19_readability_preview_144"), false, 144)
    _schedule_capture(_capture_moment_id("15_readability_preview_96", "20_readability_preview_96"), false, 96)
    await _wait_for_capture_idle()

    _ui_hidden = false
    _apply_view_mode("qa")
    _update_ui()
    queue_redraw()
    await get_tree().create_timer(0.45).timeout

    await _wait_for_capture_idle()

    _write_capture_log()
    get_tree().quit(0)


func _finish_day2_capture_sequence() -> void:
    await get_tree().process_frame
    await get_tree().process_frame
    await _wait_for_capture_idle()
    _write_capture_log()
    get_tree().quit(0)


func _schedule_capture(moment_id: String, video_frame := false, preview_height := 0, frame_group := "", force_ui_hidden := false) -> void:
    if not _capture_mode:
        return
    if not video_frame and _captured_moments.has(moment_id):
        return

    if not video_frame:
        _captured_moments[moment_id] = true

    _pending_captures.append({
        "moment_id": moment_id,
        "video_frame": video_frame,
        "preview_height": preview_height,
        "frame_group": frame_group,
        "force_ui_hidden": force_ui_hidden,
    })
    if not _capture_busy:
        _process_next_capture.call_deferred()


func _capture_moment_id(default_id: String, first_day_id: String, art_ux_id := "") -> String:
    if _first_day_art_ux_capture and art_ux_id != "":
        return art_ux_id
    return first_day_id if _first_day_visible_capture else default_id


func _process_next_capture() -> void:
    if _capture_busy or _pending_captures.is_empty():
        return

    _capture_busy = true
    var item := _pending_captures.pop_front() as Dictionary
    var moment_id := str(item["moment_id"])
    var video_frame := bool(item["video_frame"])
    var preview_height := int(item.get("preview_height", 0))
    var frame_group := str(item.get("frame_group", ""))
    var force_ui_hidden := bool(item.get("force_ui_hidden", false))
    var previous_ui_hidden := _ui_hidden
    if force_ui_hidden and not _ui_hidden:
        _ui_hidden = true
        _update_ui()
        queue_redraw()
    await get_tree().process_frame
    await get_tree().process_frame

    var image := get_viewport().get_texture().get_image()
    if image == null or image.is_empty():
        push_error("Could not capture viewport image for %s" % moment_id)
        if force_ui_hidden:
            _ui_hidden = previous_ui_hidden
            _update_ui()
            queue_redraw()
        _capture_busy = false
        if not _pending_captures.is_empty():
            _process_next_capture.call_deferred()
        return

    var file_name := "%s.png" % moment_id
    var path := "%s/%s" % [_capture_frame_dir(frame_group) if video_frame else _capture_screenshot_dir(), file_name]
    if preview_height > 0 and image.get_height() > 0:
        var preview_width := maxi(1, int(round(float(image.get_width()) * (float(preview_height) / float(image.get_height())))))
        image.resize(preview_width, preview_height, Image.INTERPOLATE_LANCZOS)
    var error := image.save_png(path)
    if error != OK:
        push_error("Could not save capture %s: %s" % [path, error])
    else:
        _captured_files.append(path)
        print("vertical_slice_capture=%s" % path)

    if force_ui_hidden:
        _ui_hidden = previous_ui_hidden
        _update_ui()
        queue_redraw()

    _capture_busy = false
    if not _pending_captures.is_empty():
        _process_next_capture.call_deferred()


func _wait_for_capture_idle() -> void:
    while _capture_busy or not _pending_captures.is_empty():
        await get_tree().process_frame


func _write_capture_log() -> void:
    var lines: Array[String] = []
    lines.append("Steam Vertical Slice capture log")
    lines.append("capture_dir=%s" % _capture_root())
    var profile := "vertical_slice_art_qa"
    if _day2_visible_capture:
        profile = "day2_return_and_second_warm_delivery_v1"
    elif _first_day_art_ux_capture:
        profile = "first_day_art_ux_visual_language_pass_v1"
    elif _first_day_visible_capture:
        profile = "first_day_mvp_visible_review_v2"
    lines.append("capture_profile=%s" % profile)
    lines.append("timing=%s" % ("fast" if _fast_mode else "normal"))
    lines.append("labels=%s" % ("on" if _show_semantic_labels else "off"))
    lines.append("")
    lines.append("Captured files:")
    for path in _captured_files:
        lines.append("- %s" % path)
    lines.append("")
    lines.append("Events:")
    for event in _event_log:
        lines.append("- %s" % event)

    var file := FileAccess.open("%s/capture_run_log.txt" % _capture_log_dir(), FileAccess.WRITE)
    if file != null:
        file.store_string("\n".join(lines) + "\n")
        file.close()


func _control_capture_root() -> String:
    return ProjectSettings.globalize_path(CONTROL_CAPTURE_DIR)


func _control_capture_file_id(prefix: String) -> String:
    var stamp := Time.get_datetime_string_from_system(true)
    stamp = stamp.replace(":", "").replace("-", "").replace("T", "_")
    return "%s_%s_%06d.png" % [prefix, stamp, Time.get_ticks_usec() % 1000000]


func _save_control_viewport_png(file_id: String) -> Dictionary:
    var dir := _control_capture_root()
    var dir_error := DirAccess.make_dir_recursive_absolute(dir)
    if dir_error != OK:
        return {
            "ok": false,
            "error": "capture_dir_failed",
            "error_code": dir_error,
        }

    var image := get_viewport().get_texture().get_image()
    if image == null or image.is_empty():
        return {
            "ok": false,
            "error": "capture_viewport_unavailable",
        }

    var path := "%s/%s" % [dir, file_id]
    var error := image.save_png(path)
    if error != OK:
        return {
            "ok": false,
            "error": "capture_save_failed",
            "error_code": error,
        }

    var captured_at := Time.get_datetime_string_from_system(true)
    _control_capture_files[file_id] = {
        "disk_path": path,
        "content_type": "image/png",
        "created_at": captured_at,
    }
    return {
        "ok": true,
        "file_id": file_id,
        "content_type": "image/png",
        "width": image.get_width(),
        "height": image.get_height(),
        "captured_at": captured_at,
    }


func _capture_state_connector_screenshot(command: String) -> Dictionary:
    if _control_latest_screenshot_file_id != "":
        if _control_capture_files.has(_control_latest_screenshot_file_id):
            var old_meta := _control_capture_files[_control_latest_screenshot_file_id] as Dictionary
            var old_path := str(old_meta.get("disk_path", ""))
            if old_path != "" and FileAccess.file_exists(old_path):
                DirAccess.remove_absolute(old_path)
        _control_capture_files.erase(_control_latest_screenshot_file_id)

    var result := _save_control_viewport_png(_control_capture_file_id("screenshot"))
    result["command"] = command
    result["capture_type"] = "screenshot"
    if bool(result.get("ok", false)):
        _control_latest_screenshot = result.duplicate(true)
        _control_latest_screenshot_file_id = str(result.get("file_id", ""))
    return result


func _start_state_connector_video_capture(command: String) -> Dictionary:
    if _control_video_running:
        var already_running := _state_connector_video_capture_status(command)
        already_running["changed"] = false
        already_running["already_running"] = true
        return already_running

    _clear_control_video_capture_memory()
    _control_video_capture_id = _control_capture_file_id("frame_sequence").trim_suffix(".png")
    _control_video_started_at = Time.get_datetime_string_from_system(true)
    _control_video_finished_at = ""
    _control_video_elapsed = 0.0
    _control_video_next_frame_at = 0.0
    _control_video_frame_index = 0
    _control_video_target_frames = int(round(CONTROL_VIDEO_CAPTURE_SECONDS * CONTROL_VIDEO_CAPTURE_FPS))
    _control_video_frames.clear()
    _control_video_last_error = ""
    _control_video_running = true

    var status := _state_connector_video_capture_status(command)
    status["changed"] = true
    return status


func _clear_control_video_capture_memory() -> void:
    for frame in _control_video_frames:
        if frame is Dictionary:
            var fid := str((frame as Dictionary).get("file_id", ""))
            if _control_capture_files.has(fid):
                var meta := _control_capture_files[fid] as Dictionary
                var disk_path := str(meta.get("disk_path", ""))
                if disk_path != "" and FileAccess.file_exists(disk_path):
                    DirAccess.remove_absolute(disk_path)
                _control_capture_files.erase(fid)
    _control_video_frames.clear()


func _maybe_capture_control_video(delta: float) -> void:
    if not _control_video_running:
        return

    _control_video_elapsed += delta
    if _control_video_frame_index < _control_video_target_frames and _control_video_elapsed + 0.001 >= _control_video_next_frame_at:
        _control_video_frame_index += 1
        _control_video_next_frame_at = float(_control_video_frame_index) * CONTROL_VIDEO_CAPTURE_FRAME_INTERVAL
        _capture_control_video_frame(_control_video_frame_index)

    if _control_video_frame_index >= _control_video_target_frames:
        _control_video_running = false
        _control_video_finished_at = Time.get_datetime_string_from_system(true)


func _capture_control_video_frame(frame_number: int) -> void:
    var file_id := "%s_frame_%04d.png" % [_control_video_capture_id, frame_number]
    var result := _save_control_viewport_png(file_id)
    if not bool(result.get("ok", false)):
        _control_video_last_error = str(result.get("error", "capture_failed"))
        return

    result["index"] = frame_number
    result["elapsed_seconds"] = snappedf(_control_video_elapsed, 0.001)
    _control_video_frames.append(result)


func _state_connector_video_capture_status(command: String) -> Dictionary:
    var progress := 0.0
    if _control_video_target_frames > 0:
        progress = float(_control_video_frame_index) / float(_control_video_target_frames)

    var payload := {
        "ok": true,
        "command": command,
        "capture_type": "frame_sequence",
        "recording_format": "png_sequence",
        "movie_file_available": false,
        "running": _control_video_running,
        "capture_id": _control_video_capture_id,
        "started_at": _control_video_started_at,
        "finished_at": _control_video_finished_at,
        "duration_seconds": CONTROL_VIDEO_CAPTURE_SECONDS,
        "fps": CONTROL_VIDEO_CAPTURE_FPS,
        "frame_interval_seconds": CONTROL_VIDEO_CAPTURE_FRAME_INTERVAL,
        "target_frames": _control_video_target_frames,
        "requested_frames": _control_video_frame_index,
        "frame_count": _control_video_frames.size(),
        "progress": progress,
        "frames": _control_video_frames.duplicate(true),
        "movie_maker_runtime_toggle_supported": false,
    }
    if _control_video_last_error != "":
        payload["last_error"] = _control_video_last_error
    return payload


func _capture_state_connector_file(payload: Dictionary) -> Dictionary:
    var file_id := str(payload.get("file_id", ""))
    if file_id == "" or not _control_capture_files.has(file_id):
        return {
            "ok": false,
            "error": "capture_file_not_found",
        }

    var meta := _control_capture_files[file_id] as Dictionary
    var disk_path := str(meta.get("disk_path", ""))
    if disk_path == "" or not FileAccess.file_exists(disk_path):
        return {
            "ok": false,
            "error": "capture_file_missing_on_disk",
        }

    var bytes := FileAccess.get_file_as_bytes(disk_path)
    if bytes.is_empty():
        return {
            "ok": false,
            "error": "capture_file_empty",
        }

    return {
        "ok": true,
        "file_id": file_id,
        "content_type": str(meta.get("content_type", "image/png")),
        "bytes": bytes,
    }


func _has_current_task(type: String, status := "") -> bool:
    if _current_task.is_empty():
        return false
    if str(_current_task.get("type", "")) != type:
        return false
    if status != "" and str(_current_task.get("status", "")) != status:
        return false
    return true


func _current_step_has(key: String, value: String) -> bool:
    if _current_task.is_empty() or _current_step_index < 0:
        return false
    var steps := _current_task.get("steps", []) as Array
    if _current_step_index >= steps.size():
        return false
    var step := steps[_current_step_index] as Dictionary
    return str(step.get(key, "")) == value


func _has_carry_task(source: String, target: String, resource_id := "") -> bool:
    if not _has_current_task("CarryTask"):
        return false
    if str(_current_task.get("source_object_id", "")) != source:
        return false
    if str(_current_task.get("target_object_id", "")) != target:
        return false
    if resource_id != "" and str(_current_task.get("resource_id", "")) != resource_id:
        return false
    return str(_current_task.get("status", "")) in ["in_progress", "moving_to_target", "completing"]


func _token_at(resource_id: String, location: String) -> bool:
    if not _tokens.has(resource_id):
        return false
    var token := _tokens[resource_id] as Dictionary
    return bool(token.get("visible", true)) and str(token.get("location", "")) == location


func _capture_root() -> String:
    return ProjectSettings.globalize_path(_capture_dir)


func _capture_screenshot_dir() -> String:
    return "%s/captures/screenshots" % _capture_root()


func _capture_video_dir() -> String:
    return "%s/captures/video" % _capture_root()


func _capture_frame_dir(frame_group := "") -> String:
    if _day2_visible_capture:
        return "%s/day2_return_and_second_delivery_frames_1x" % _capture_video_dir()
    if _first_day_art_ux_capture:
        if frame_group == "postcard_slippers":
            return "%s/postcard_slippers_moment_1x" % _capture_video_dir()
        return "%s/first_day_mvp_visible_loop_frames_1x" % _capture_video_dir()
    if _first_day_visible_capture:
        return "%s/first_day_mvp_visible_loop_frames" % _capture_video_dir()
    return "%s/vertical_slice_full_loop_short_frames" % _capture_video_dir()


func _capture_log_dir() -> String:
    return "%s/captures/logs" % _capture_root()


func _runtime_context() -> Dictionary:
    return {
        "game": _state_game_snapshot(),
        "first_day_history": _first_day_history,
        "active_order": _active_order,
        "active_chain": _active_chain,
        "day2": _day2,
        "dog_defs": DOG_DEFS,
        "dogs": _dogs,
        "anchors": ANCHOR_DEFS,
        "tokens": _tokens,
        "inventories": {
            "storage": _storage_inventory,
            "kitchen_inputs": _kitchen_inputs,
            "packing_table_inputs": _packing_inputs,
            "delivery_van_endpoint": {
                "food_bag": 1 if _token_at("food_bag", "delivery_van_endpoint") else 0,
            },
        },
        "current_task": _current_task,
        "task_queue": _task_queue,
        "flags": _runtime_flags(),
        "transport": {
            "x": _transport_x,
            "visible": _transport_visible,
            "state": _transport_state,
            "has_payload": _transport_has_payload,
        },
        "anchor_states": {
            "road_sign": _road_sign_state(),
            "storage": _storage_state(),
            "kitchen": _kitchen_state(),
            "packing_table": _packing_table_state(),
            "delivery_van_endpoint": _delivery_state,
        },
        "debug": _state_debug_snapshot(),
    }


func _runtime_flags() -> Dictionary:
    return {
        "route_started": _route_started,
        "trip_payload_visible": _trip_payload_visible,
        "kitchen_carries_enqueued": _kitchen_carries_enqueued,
        "cook_enqueued": _cook_enqueued,
        "packing_carries_enqueued": _packing_carries_enqueued,
        "pack_enqueued": _pack_enqueued,
        "load_van_enqueued": _load_van_enqueued,
        "van_loaded": _van_loaded,
        "delivery_confirmed": _delivery_confirmed,
        "delivery_complete": _delivery_complete,
        "postcard_visible": _postcard_visible,
        "postcard_claimed": _postcard_claimed,
        "reward_available": _reward_available,
        "equip_task_created": _equip_task_created,
        "slippers_equipped": _slippers_equipped,
        "first_day_postcard_life_moment_seen": _first_day_postcard_life_moment_seen,
        "first_day_first_memory_added": _first_day_first_memory_added,
        "first_day_next_day_hint_available": _first_day_next_day_hint_available,
        "chain_complete": _chain_complete,
    }


func _runtime_portable_state() -> Dictionary:
    return {
        "elapsed_seconds": _elapsed,
        "timing_scale": _timing_scale,
        "next_task_number": _next_task_number,
        "current_step_index": _current_step_index,
        "step_time": _step_time,
        "dogs": _dogs.duplicate(true),
        "tokens": _tokens.duplicate(true),
        "inventories": {
            "storage": _storage_inventory.duplicate(true),
            "kitchen_inputs": _kitchen_inputs.duplicate(true),
            "packing_table_inputs": _packing_inputs.duplicate(true),
        },
        "task_queue": _task_queue.duplicate(true),
        "current_task": _current_task.duplicate(true),
        "first_day_history": _first_day_history.duplicate(true),
        "active_order": _active_order.duplicate(true),
        "active_chain": _active_chain.duplicate(true),
        "day2": _day2.duplicate(true),
        "flags": _runtime_flags(),
        "transport": {
            "x": _transport_x,
            "visible": _transport_visible,
            "state": _transport_state,
            "has_payload": _transport_has_payload,
        },
        "order": {
            "state": _order_state,
            "delivery_state": _delivery_state,
        },
    }


func _apply_runtime_import_payload(raw_payload: Dictionary) -> Dictionary:
    var normalized := _systems_runtime.normalize_import_payload(raw_payload)
    if not bool(normalized.get("ok", false)):
        return normalized

    var payload := normalized.get("payload", {}) as Dictionary
    var state := payload.get("state", {}) as Dictionary
    var import_result := _systems_runtime.import_runtime_metadata(payload)
    if not bool(import_result.get("ok", false)):
        return import_result
    _apply_runtime_portable_state(state)
    _repair_imported_runtime_state()
    _update_ui()
    _apply_mouse_passthrough()
    queue_redraw()
    return {
        "ok": true,
        "schema_version": str(payload.get("schema_version", "")),
        "active_order_id": _active_order_id(),
        "active_chain_run_id": str(_active_chain.get("run_id", "")),
        "chain_state": _systems_runtime.build_state(_runtime_context())["production_chains"][0]["state"],
    }


func _apply_runtime_portable_state(state: Dictionary) -> void:
    if state.is_empty():
        return

    _elapsed = float(state.get("elapsed_seconds", _elapsed))
    _timing_scale = float(state.get("timing_scale", _timing_scale))
    _next_task_number = maxi(int(state.get("next_task_number", _next_task_number)), 1)
    _current_step_index = int(state.get("current_step_index", _current_step_index))
    _step_time = float(state.get("step_time", _step_time))

    if state.has("dogs") and state["dogs"] is Dictionary:
        _dogs = (state["dogs"] as Dictionary).duplicate(true)
    if state.has("tokens") and state["tokens"] is Dictionary:
        _tokens = (state["tokens"] as Dictionary).duplicate(true)

    var inventories := state.get("inventories", {}) as Dictionary
    if inventories.has("storage"):
        _storage_inventory = (inventories["storage"] as Dictionary).duplicate(true)
    if inventories.has("kitchen_inputs"):
        _kitchen_inputs = (inventories["kitchen_inputs"] as Dictionary).duplicate(true)
    if inventories.has("packing_table_inputs"):
        _packing_inputs = (inventories["packing_table_inputs"] as Dictionary).duplicate(true)

    if state.has("task_queue") and state["task_queue"] is Array:
        _task_queue.clear()
        for queued_task in state["task_queue"] as Array:
            if queued_task is Dictionary:
                _task_queue.append((queued_task as Dictionary).duplicate(true))
    if state.has("current_task") and state["current_task"] is Dictionary:
        _current_task = (state["current_task"] as Dictionary).duplicate(true)
    if state.has("first_day_history") and state["first_day_history"] is Dictionary:
        _first_day_history = (state["first_day_history"] as Dictionary).duplicate(true)
    if state.has("active_order") and state["active_order"] is Dictionary:
        _active_order = (state["active_order"] as Dictionary).duplicate(true)
    if state.has("active_chain") and state["active_chain"] is Dictionary:
        _active_chain = (state["active_chain"] as Dictionary).duplicate(true)
    if state.has("day2") and state["day2"] is Dictionary:
        _day2 = (state["day2"] as Dictionary).duplicate(true)

    var flags := state.get("flags", {}) as Dictionary
    _route_started = bool(flags.get("route_started", _route_started))
    _trip_payload_visible = bool(flags.get("trip_payload_visible", _trip_payload_visible))
    _kitchen_carries_enqueued = bool(flags.get("kitchen_carries_enqueued", _kitchen_carries_enqueued))
    _cook_enqueued = bool(flags.get("cook_enqueued", _cook_enqueued))
    _packing_carries_enqueued = bool(flags.get("packing_carries_enqueued", _packing_carries_enqueued))
    _pack_enqueued = bool(flags.get("pack_enqueued", _pack_enqueued))
    _load_van_enqueued = bool(flags.get("load_van_enqueued", _load_van_enqueued))
    _van_loaded = bool(flags.get("van_loaded", _van_loaded))
    _delivery_confirmed = bool(flags.get("delivery_confirmed", _delivery_confirmed))
    _delivery_complete = bool(flags.get("delivery_complete", _delivery_complete))
    _postcard_visible = bool(flags.get("postcard_visible", _postcard_visible))
    _postcard_claimed = bool(flags.get("postcard_claimed", _postcard_claimed))
    _reward_available = bool(flags.get("reward_available", _reward_available))
    _equip_task_created = bool(flags.get("equip_task_created", _equip_task_created))
    _slippers_equipped = bool(flags.get("slippers_equipped", _slippers_equipped))
    _first_day_postcard_life_moment_seen = bool(flags.get("first_day_postcard_life_moment_seen", _first_day_postcard_life_moment_seen))
    _first_day_first_memory_added = bool(flags.get("first_day_first_memory_added", _first_day_first_memory_added))
    _first_day_next_day_hint_available = bool(flags.get("first_day_next_day_hint_available", _first_day_next_day_hint_available))
    _chain_complete = bool(flags.get("chain_complete", _chain_complete))

    var transport := state.get("transport", {}) as Dictionary
    _transport_x = float(transport.get("x", _transport_x))
    _transport_visible = bool(transport.get("visible", _transport_visible))
    _transport_state = str(transport.get("state", _transport_state))
    _transport_has_payload = bool(transport.get("has_payload", _transport_has_payload))

    var order := state.get("order", {}) as Dictionary
    _order_state = str(order.get("state", _order_state))
    _delivery_state = str(order.get("delivery_state", _delivery_state))
    if not _active_order.is_empty():
        _order_state = str(_active_order.get("status", _order_state))
        _delivery_state = str(_active_order.get("delivery_state", _delivery_state))
        _delivery_confirmed = bool(_active_order.get("delivery_confirmed", _delivery_confirmed))
        _delivery_complete = bool(_active_order.get("completed", _delivery_complete))
        _postcard_visible = bool(_active_order.get("postcard_created", _postcard_visible))
        _reward_available = bool(_active_order.get("reward_created", _reward_available))
        _equip_task_created = bool(_active_order.get("equip_task_created", _equip_task_created))
    if _is_day2_active():
        _chain_complete = str(_active_chain.get("state", "")) == "completed"
    _runtime_dispatch_confirmation_followup = false


func _repair_imported_runtime_state() -> void:
    for dog_id in DOG_DEFS.keys():
        if not _dogs.has(dog_id):
            var dog_def := DOG_DEFS[dog_id] as Dictionary
            _dogs[dog_id] = {
                "id": dog_id,
                "x": float(dog_def["start_x"]),
                "visible": true,
                "state": "idle",
                "carried_resource": "",
                "equipment": "",
                "current_task": "",
                "task_label": "IdleTask",
            }
    if _is_day2_active():
        _reveal_day2_return_moment()
    if _current_task.is_empty() and _task_queue.is_empty():
        if _route_started and _trip_payload_visible and not _kitchen_carries_enqueued:
            _maybe_enqueue_kitchen_carries()
        elif _kitchen_carries_enqueued and not _cook_enqueued:
            _maybe_enqueue_cook_or_pack_work()
        elif _cook_enqueued and _token_at("food_mix", "kitchen") and not _packing_carries_enqueued:
            _maybe_enqueue_packing_carries()
        elif _pack_enqueued and _token_at("food_bag", "packing_table") and not _load_van_enqueued:
            _maybe_enqueue_load_van()


func _event_details(event_name: String) -> Dictionary:
    var details := {
        "payload": {
            "raw_event": event_name,
            "order_id": _active_order_id(),
        },
    }
    var dog_ids: Array[String] = []
    var place_ids: Array[String] = []
    var building_ids: Array[String] = []
    var chain_ids: Array[String] = ["chain.warm_food_delivery_intro"]

    if not _current_task.is_empty():
        var dog_key: Variant = _dog_key_from_internal(str(_current_task.get("assigned_dog_id", "")))
        if dog_key != null:
            dog_ids.append(str(dog_key))
        var source_key: Variant = _object_key_from_internal(str(_current_task.get("source_object_id", "")))
        var target_key: Variant = _object_key_from_internal(str(_current_task.get("target_object_id", "")))
        if source_key != null:
            place_ids.append(str(source_key))
            building_ids.append(str(source_key))
        if target_key != null and not (str(target_key) in place_ids):
            place_ids.append(str(target_key))
            building_ids.append(str(target_key))

    if event_name.contains("research") or event_name.contains("curiosity"):
        details["research_ids"] = [_systems_runtime.active_research.get("id", "research.runtime_scaffold")]
    if event_name.contains("room") or event_name.contains("assign"):
        details["room_ids"] = ["room.house_of_curiosity.classroom"]
    if event_name.contains("runtime") or event_name.contains("debug"):
        chain_ids = []

    details["dog_ids"] = dog_ids
    details["place_ids"] = place_ids
    details["building_ids"] = building_ids
    details["chain_ids"] = chain_ids
    return details


func _setup_state_connector() -> void:
    if not _state_connector_enabled:
        return

    _state_connector = StateConnector.new()
    add_child(_state_connector)
    _state_connector.configure({
        "snapshot_provider": Callable(self, "_build_state_connector_snapshot"),
        "bind_host": _state_connector_bind_host,
        "port": _state_connector_port,
        "http_enabled": _state_connector_http_enabled,
        "file_enabled": _state_connector_file_enabled,
        "snapshot_file": _state_connector_snapshot_file,
        "snapshot_interval_seconds": _state_connector_interval_seconds,
        "tunnel_mode": _state_connector_tunnel_mode,
        "token": _state_connector_token,
        "control_enabled": _state_connector_control_enabled,
        "control_handler": Callable(self, "_handle_state_connector_control"),
    })
    var error: int = _state_connector.start_connector()
    if error != OK:
        push_error("Vertical Slice could not start Godot State Connector (%s)" % error)


func _handle_state_connector_control(command: String, _payload: Dictionary) -> Dictionary:
    match command:
        "control.status":
            return _state_connector_control_status()
        "ui.hide":
            return _set_state_connector_window_visible(false, command)
        "ui.show":
            return _set_state_connector_window_visible(true, command)
        "ui.toggle":
            return _set_state_connector_window_visible(not _state_connector_window_visible, command)
        "connector.http.stop":
            return _stop_state_connector_http(command)
        "capture.screenshot":
            return _capture_state_connector_screenshot(command)
        "capture.video.start":
            return _start_state_connector_video_capture(command)
        "capture.video.status":
            return _state_connector_video_capture_status(command)
        "capture.file":
            return _capture_state_connector_file(_payload)
        "runtime.fixtures.list":
            return _control_runtime_fixtures_list(command)
        "runtime.fixture.load":
            return _control_runtime_fixture_load(command, _payload)
        "runtime.speed.set":
            return _control_runtime_speed_set(command, _payload)
        "runtime.state.export":
            return _control_runtime_state_export(command)
        "runtime.state.import":
            return _control_runtime_state_import(command, _payload)
        "runtime.state.clear":
            return _control_runtime_state_clear(command)
        "runtime.save.write":
            return _control_runtime_save_write(command)
        "runtime.save.load":
            return _control_runtime_save_load(command)
        "runtime.save.erase":
            return _control_runtime_save_erase(command)
        "runtime.route.start":
            return _control_runtime_route_start(command)
        "runtime.delivery.confirm":
            return _control_runtime_delivery_confirm(command)
        "runtime.dog.assign":
            return _control_runtime_dog_assign(command, _payload)
        "runtime.research.start":
            return _control_runtime_research_start(command, _payload)
        "runtime.debug.tick":
            return _control_runtime_debug_tick(command, _payload)
        _:
            return {
                "ok": false,
                "error": "unsupported_control_command",
                "command": command,
            }


func _state_connector_control_status() -> Dictionary:
    var window_position := DisplayServer.window_get_position(WINDOW_ID)
    var window_size := DisplayServer.window_get_size(WINDOW_ID)
    return {
        "ui_visible": _state_connector_window_visible,
        "window_visible": _state_connector_window_visible,
        "window_mode": DisplayServer.window_get_mode(WINDOW_ID),
        "window_position": {
            "x": window_position.x,
            "y": window_position.y,
        },
        "window_size": {
            "x": window_size.x,
            "y": window_size.y,
        },
        "in_game_hud_visible": not _ui_hidden,
        "view_mode": _view_mode,
        "runtime_speed_multiplier": _systems_runtime.debug_speed_multiplier,
        "runtime_local_save_file": _systems_runtime.local_save_path(),
        "restore_geometry_available": _state_connector_has_restore_window_geometry,
    }


func _set_state_connector_window_visible(visible: bool, command: String) -> Dictionary:
    if visible == _state_connector_window_visible:
        if visible:
            _apply_state_connector_window_show()
        else:
            _apply_state_connector_window_hide()
        var unchanged_status := _state_connector_control_status()
        unchanged_status["ok"] = true
        unchanged_status["changed"] = false
        unchanged_status["applied"] = true
        unchanged_status["command"] = command
        return unchanged_status

    if visible:
        _apply_state_connector_window_show()
        _state_connector_window_visible = true
        _layout_ui()
        _apply_mouse_passthrough()
        queue_redraw()
    else:
        _save_state_connector_window_geometry()
        _apply_state_connector_window_hide()
        _state_connector_window_visible = false

    var status := _state_connector_control_status()
    status["ok"] = true
    status["changed"] = true
    status["applied"] = true
    status["command"] = command
    return status


func _save_state_connector_window_geometry() -> void:
    _state_connector_restore_window_position = DisplayServer.window_get_position(WINDOW_ID)
    _state_connector_restore_window_size = DisplayServer.window_get_size(WINDOW_ID)
    _state_connector_has_restore_window_geometry = true


func _apply_state_connector_window_hide() -> void:
    DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_ALWAYS_ON_TOP, false, WINDOW_ID)
    DisplayServer.window_set_mouse_passthrough(PackedVector2Array(), WINDOW_ID)
    get_window().hide()
    DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MINIMIZED, WINDOW_ID)
    DisplayServer.window_set_position(_state_connector_hidden_window_position, WINDOW_ID)


func _apply_state_connector_window_show() -> void:
    get_window().show()
    DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED, WINDOW_ID)
    DisplayServer.window_set_current_screen(_target_screen, WINDOW_ID)
    if _state_connector_has_restore_window_geometry:
        DisplayServer.window_set_size(_state_connector_restore_window_size, WINDOW_ID)
        DisplayServer.window_set_position(_state_connector_restore_window_position, WINDOW_ID)
    DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_ALWAYS_ON_TOP, _always_on_top, WINDOW_ID)
    DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, _companion_mode, WINDOW_ID)
    DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_TRANSPARENT, _transparent_window, WINDOW_ID)


func _stop_state_connector_http(command: String) -> Dictionary:
    call_deferred("_deferred_stop_state_connector_http")
    return {
        "ok": true,
        "changed": true,
        "command": command,
        "connector_http_enabled": false,
        "game_process_running": true,
    }


func _deferred_stop_state_connector_http() -> void:
    if _state_connector != null and _state_connector.has_method("stop_http_server"):
        _state_connector.call("stop_http_server")


func _control_runtime_fixtures_list(command: String) -> Dictionary:
    var result := _systems_runtime.list_fixtures()
    result["command"] = command
    return result


func _control_runtime_fixture_load(command: String, payload: Dictionary) -> Dictionary:
    var fixture_name := str(payload.get("fixture", payload.get("id", ""))).strip_edges()
    if fixture_name == "":
        return {
            "ok": false,
            "command": command,
            "error": "missing_fixture",
        }
    var fixture := _systems_runtime.load_fixture(fixture_name)
    if not bool(fixture.get("ok", false)):
        fixture["command"] = command
        return fixture

    _reset_world_state()
    var import_result := _apply_runtime_import_payload(fixture.get("payload", {}) as Dictionary)
    import_result["command"] = command
    import_result["fixture"] = fixture.get("fixture", fixture_name)
    _emit_event("runtime_fixture_loaded:%s" % str(import_result["fixture"]))
    return import_result


func _control_runtime_speed_set(command: String, payload: Dictionary) -> Dictionary:
    var multiplier := int(payload.get("multiplier", payload.get("speed", 1)))
    var result := _systems_runtime.set_debug_speed_multiplier(multiplier)
    result["command"] = command
    if bool(result.get("ok", false)):
        _emit_event("debug_speed_multiplier_set:%sx" % multiplier)
    return result


func _control_runtime_state_export(command: String) -> Dictionary:
    var export_payload := _systems_runtime.export_state(_runtime_portable_state())
    return {
        "ok": true,
        "command": command,
        "schema_version": export_payload["schema_version"],
        "state": export_payload,
        "json": JSON.stringify(export_payload, "  "),
    }


func _control_runtime_state_import(command: String, payload: Dictionary) -> Dictionary:
    var result := _apply_runtime_import_payload(payload)
    result["command"] = command
    if bool(result.get("ok", false)):
        _emit_event("runtime_state_imported")
    return result


func _control_runtime_state_clear(command: String) -> Dictionary:
    _systems_runtime.reset_runtime_state()
    _reset_world_state()
    _emit_event("runtime_state_cleared")
    _update_ui()
    queue_redraw()
    return {
        "ok": true,
        "command": command,
        "state": "first_day_default",
        "local_save_file": _systems_runtime.local_save_path(),
    }


func _control_runtime_save_write(command: String) -> Dictionary:
    var export_payload := _systems_runtime.export_state(_runtime_portable_state())
    var result := _systems_runtime.write_local_save(export_payload)
    result["command"] = command
    if bool(result.get("ok", false)):
        _emit_event("runtime_save_written")
    return result


func _control_runtime_save_load(command: String) -> Dictionary:
    var loaded := _systems_runtime.load_local_save()
    if not bool(loaded.get("ok", false)):
        loaded["command"] = command
        return loaded
    var result := _apply_runtime_import_payload(loaded.get("payload", {}) as Dictionary)
    result["command"] = command
    result["path"] = loaded.get("path", "")
    _systems_runtime.active_save_file = str(loaded.get("path", _systems_runtime.local_save_path()))
    if bool(result.get("ok", false)):
        _emit_event("runtime_save_loaded")
    return result


func _control_runtime_save_erase(command: String) -> Dictionary:
    var result := _systems_runtime.erase_local_save()
    result["command"] = command
    if bool(result.get("ok", false)):
        _emit_event("runtime_save_erased")
    return result


func _control_runtime_route_start(command: String) -> Dictionary:
    if not _route_started:
        _start_route_pressed()
    return {
        "ok": true,
        "command": command,
        "route_id": "route.oat_farm_intro",
        "route_started": _route_started,
        "chain_state": _systems_runtime.build_state(_runtime_context())["production_chains"][0]["state"],
    }


func _control_runtime_delivery_confirm(command: String) -> Dictionary:
    var validation := _runtime_delivery_confirm_validation()
    if not bool(validation.get("valid", false)):
        return {
            "ok": false,
            "command": command,
            "error": "dispatch_confirmation_invalid_state",
            "validation": validation,
        }

    _confirm_delivery_pressed()
    _runtime_dispatch_confirmation_followup = not _is_day2_active()
    return {
        "ok": true,
        "command": command,
        "order_id": _active_order_id(),
        "route_id": "route.oat_farm_intro",
        "chain_id": "chain.warm_food_delivery_intro",
        "delivery_confirmed": _delivery_confirmed,
        "post_dispatch_followup_enabled": _runtime_dispatch_confirmation_followup,
        "order_state": _order_state,
        "delivery_state": _delivery_state,
        "chain_state": _systems_runtime.build_state(_runtime_context())["production_chains"][0]["state"],
    }


func _runtime_delivery_confirm_validation() -> Dictionary:
    var runtime_state := _systems_runtime.build_state(_runtime_context())
    var chains := runtime_state.get("production_chains", []) as Array
    var chain: Dictionary = {}
    if not chains.is_empty() and chains[0] is Dictionary:
        chain = chains[0] as Dictionary

    var problems: Array[String] = []
    if not (_active_order_id() in [FIRST_ORDER_ID, SECOND_ORDER_ID]):
        problems.append("unexpected_order")
    if str(chain.get("id", "")) != "chain.warm_food_delivery_intro":
        problems.append("unexpected_chain")
    if not _route_started:
        problems.append("route_not_started")
    if not _van_loaded:
        problems.append("van_not_loaded")
    if _delivery_confirmed:
        problems.append("delivery_already_confirmed")
    if _delivery_state != "ready_to_send":
        problems.append("delivery_state_not_ready_to_send")
    if _order_state != "loaded":
        problems.append("order_not_loaded")
    if str(chain.get("state", "")) != "ready_to_dispatch":
        problems.append("chain_not_ready_to_dispatch")
    if str(chain.get("current_step", "")) != "player_confirms_dispatch":
        problems.append("chain_not_waiting_for_player_dispatch_step")
    if str(chain.get("blocked_reason", "")) != "waiting_for_player_confirmation":
        problems.append("chain_not_waiting_for_player_confirmation")
    if not bool(chain.get("player_confirmation_required", false)):
        problems.append("player_confirmation_not_required")

    return {
        "valid": problems.is_empty(),
        "problems": problems,
        "order_id": _active_order_id(),
        "route_id": "route.oat_farm_intro",
        "chain_id": str(chain.get("id", "")),
        "order_state": _order_state,
        "delivery_state": _delivery_state,
        "van_loaded": _van_loaded,
        "delivery_confirmed": _delivery_confirmed,
        "chain_state": str(chain.get("state", "")),
        "current_step": str(chain.get("current_step", "")),
        "blocked_reason": chain.get("blocked_reason", null),
        "player_confirmation_required": bool(chain.get("player_confirmation_required", false)),
    }


func _control_runtime_dog_assign(command: String, payload: Dictionary) -> Dictionary:
    var dog_id := _normalize_dog_id(str(payload.get("dog_id", payload.get("dog", ""))))
    var room_id := str(payload.get("room_id", payload.get("room", "room.house_of_curiosity.classroom")))
    var activity_group := str(payload.get("activity_group", "learning"))
    var activity_detail := str(payload.get("activity_detail", "assigned_room_activity"))
    var assignment := {
        "activity_id": str(payload.get("activity_id", "activity.%s.%s" % [activity_group, activity_detail])),
        "activity_group": activity_group,
        "activity_detail": activity_detail,
        "room_id": room_id,
        "place_id": str(payload.get("place_id", "building.house_of_curiosity")),
    }
    var result := _systems_runtime.assign_dog(dog_id, assignment)
    result["command"] = command
    if bool(result.get("ok", false)):
        _emit_event("runtime_dog_assigned:%s:%s" % [dog_id, room_id])
    return result


func _control_runtime_research_start(command: String, payload: Dictionary) -> Dictionary:
    var node_id := str(payload.get("node_id", payload.get("research_id", "research.soft_packing")))
    var room_id := str(payload.get("room_id", "room.house_of_curiosity.soft_methods_workshop"))
    var dog_ids := payload.get("dog_ids", ["dog.labrador_intro"]) as Array
    var result := _systems_runtime.start_research(node_id, room_id, dog_ids)
    result["command"] = command
    if bool(result.get("ok", false)):
        _emit_event("runtime_research_started:%s" % node_id)
    return result


func _control_runtime_debug_tick(command: String, payload: Dictionary) -> Dictionary:
    var requested_seconds := clampf(float(payload.get("seconds", 1.0)), 0.05, 30.0)
    var remaining := requested_seconds
    while remaining > 0.001:
        var step := minf(TICK_SECONDS, remaining)
        var simulation_delta := _systems_runtime.simulation_delta(step)
        _elapsed += simulation_delta
        _systems_runtime.advance_research_progress(simulation_delta)
        _advance_current_task(simulation_delta)
        _try_start_next_task()
        _update_idle_dogs()
        _run_auto_play(simulation_delta)
        _run_runtime_dispatch_confirmation_followup()
        _advance_day2_completion_beat(simulation_delta)
        remaining -= step
    _update_ui()
    queue_redraw()
    _emit_event("debug_time_advanced:%.2f" % requested_seconds, {
        "tag": "debug",
        "chain_ids": [],
        "dog_ids": [],
        "place_ids": [],
        "building_ids": [],
        "message": "Dev-only runtime debug tick advanced simulation time",
        "payload": {
            "requested_seconds": requested_seconds,
            "effective_simulation_seconds": requested_seconds * float(_systems_runtime.debug_speed_multiplier),
        },
    })
    return {
        "ok": true,
        "command": command,
        "requested_seconds": requested_seconds,
        "effective_simulation_seconds": requested_seconds * float(_systems_runtime.debug_speed_multiplier),
        "elapsed_seconds": _elapsed,
        "chain_state": _systems_runtime.build_state(_runtime_context())["production_chains"][0]["state"],
    }


func _normalize_dog_id(raw_dog_id: String) -> String:
    var dog_id := raw_dog_id.strip_edges()
    if dog_id == "dachshund_intro":
        return "dog.dachshund_intro"
    if dog_id == "labrador_intro":
        return "dog.labrador_intro"
    if dog_id == "":
        return "dog.labrador_intro"
    return dog_id


func _build_state_connector_snapshot() -> Dictionary:
    var runtime_state := _systems_runtime.build_state(_runtime_context())
    runtime_state["first_day_history"] = _first_day_history.duplicate(true)
    runtime_state["day2_history"] = _day2_history.duplicate(true)
    runtime_state["active_order"] = _state_active_order_snapshot()
    runtime_state["active_chain"] = _state_active_chain_snapshot()
    runtime_state["day2"] = _day2.duplicate(true)
    runtime_state["order"] = _state_order_snapshot()
    runtime_state["tasks"] = _state_task_snapshots()
    runtime_state["resources"] = _state_resource_snapshot()
    runtime_state["production_chain"] = _state_chain_snapshot()
    return runtime_state


func _state_game_snapshot() -> Dictionary:
    return {
        "product": "steam_desktop",
        "scene": "res://scenes/prototypes/vertical_slice/vertical_slice_demo.tscn",
        "prototype": "steam_vertical_slice",
        "elapsed_seconds": _elapsed,
        "tick_seconds": TICK_SECONDS,
        "timing_scale": _timing_scale,
        "view_mode": _view_mode,
        "auto_play": _auto_play,
        "fast_mode": _fast_mode,
        "chain_complete": _chain_complete,
        "first_day": _state_first_day_snapshot(),
        "day2": _day2.duplicate(true),
        "day2_history": _day2_history.duplicate(true),
        "control_enabled": _state_connector_control_enabled,
        "ui_visible": _state_connector_window_visible,
        "window_visible": _state_connector_window_visible,
        "ui_hidden": _ui_hidden,
    }


func _state_first_day_snapshot() -> Dictionary:
    if bool(_first_day_history.get("chain_complete", false)):
        var dachshund := _first_day_history.get("dachshund", {}) as Dictionary
        return {
            "order_id": str(_first_day_history.get("order_id", FIRST_ORDER_ID)),
            "postcard_life_moment_seen": bool(_first_day_history.get("postcard_life_moment_seen", false)),
            "first_reward_available": bool(_first_day_history.get("reward_available", false)),
            "first_reward_equipped": bool(_first_day_history.get("first_reward_equipped", false)),
            "first_memory_added": bool(_first_day_history.get("first_memory_added", false)),
            "memory_id": dachshund.get("memory_id", null),
            "memory_text": str(dachshund.get("memory_text", "")),
            "next_day_hint_available": bool(_first_day_history.get("next_day_hint_available", false)),
            "next_day_hint_id": "hint.first_day_next_day" if bool(_first_day_history.get("next_day_hint_available", false)) else null,
            "next_day_hint_text": FIRST_DAY_NEXT_DAY_HINT_TEXT if bool(_first_day_history.get("next_day_hint_available", false)) else "",
        }
    return {
        "order_id": FIRST_ORDER_ID,
        "postcard_life_moment_seen": _first_day_postcard_life_moment_seen,
        "first_reward_available": _reward_available,
        "first_reward_equipped": _slippers_equipped,
        "first_memory_added": _first_day_first_memory_added,
        "memory_id": "memory.first_warm_delivery" if _first_day_first_memory_added else null,
        "memory_text": "Помнит первую тёплую поставку" if _first_day_first_memory_added else "",
        "next_day_hint_available": _first_day_next_day_hint_available,
        "next_day_hint_id": "hint.first_day_next_day" if _first_day_next_day_hint_available else null,
        "next_day_hint_text": FIRST_DAY_NEXT_DAY_HINT_TEXT if _first_day_next_day_hint_available else "",
    }


func _state_legacy_connector_snapshot() -> Dictionary:
    return {
        "game": _state_game_snapshot(),
        "order": _state_order_snapshot(),
        "dogs": _state_dog_snapshots(),
        "tasks": _state_task_snapshots(),
        "buildings": _state_building_snapshots(),
        "resources": _state_resource_snapshot(),
        "production_chain": _state_chain_snapshot(),
        "events": _state_event_snapshots(),
        "debug": _state_debug_snapshot(),
    }


func _state_order_snapshot() -> Dictionary:
    if _active_order.is_empty() and bool(_day2_history.get("completed", false)):
        return {
            "id": "",
            "title": "Кооператив отдыхает",
            "status": "quiet_cooperative",
            "delivery_state": "delivered",
            "next_expected_player_action": _next_action_text(),
            "route_started": _route_started,
            "delivery_confirmed": _delivery_confirmed,
            "postcard_visible": _postcard_visible,
            "reward_available": false,
            "slippers_equipped": _slippers_equipped,
            "completed": true,
        }
    return {
        "id": _active_order_id(),
        "title": str(_active_order.get("title", FIRST_ORDER_TITLE)),
        "status": str(_active_order.get("status", _order_state)),
        "delivery_state": str(_active_order.get("delivery_state", _delivery_state)),
        "next_expected_player_action": _next_action_text(),
        "route_started": _route_started,
        "van_loaded": _van_loaded,
        "delivery_confirmed": bool(_active_order.get("delivery_confirmed", _delivery_confirmed)),
        "postcard_visible": bool(_active_order.get("postcard_created", _postcard_visible)),
        "reward_available": bool(_active_order.get("reward_created", _reward_available)),
        "slippers_equipped": _slippers_equipped,
        "completed": bool(_active_order.get("completed", false)),
    }


func _state_active_order_snapshot() -> Dictionary:
    if _active_order.is_empty():
        return {}
    var snapshot := _active_order.duplicate(true)
    snapshot["id"] = _active_order_id()
    snapshot["title"] = str(_active_order.get("title", FIRST_ORDER_TITLE))
    snapshot["status"] = str(_active_order.get("status", _order_state))
    snapshot["delivery_state"] = str(_active_order.get("delivery_state", _delivery_state))
    snapshot["delivery_confirmed"] = bool(_active_order.get("delivery_confirmed", _delivery_confirmed))
    snapshot["completed"] = bool(_active_order.get("completed", _delivery_complete))
    snapshot["postcard_created"] = bool(_active_order.get("postcard_created", _postcard_visible))
    snapshot["reward_created"] = bool(_active_order.get("reward_created", _reward_available))
    snapshot["equip_task_created"] = bool(_active_order.get("equip_task_created", _equip_task_created))
    snapshot["route_started"] = _route_started
    snapshot["van_loaded"] = _van_loaded
    return snapshot


func _state_active_chain_snapshot() -> Dictionary:
    if _active_chain.is_empty():
        return {}
    var snapshot := _active_chain.duplicate(true)
    snapshot["template_id"] = str(_active_chain.get("template_id", WARM_DELIVERY_CHAIN_ID))
    snapshot["run_id"] = str(_active_chain.get("run_id", FIRST_CHAIN_RUN_ID))
    snapshot["state"] = str(_active_chain.get("state", "not_started"))
    snapshot["current_step"] = str(_active_chain.get("current_step", "none"))
    snapshot["route_id"] = str(_active_chain.get("route_id", "route.oat_farm_intro"))
    snapshot["transport_id"] = str(_active_chain.get("transport_id", "transport.basket_bicycle"))
    return snapshot


func _state_dog_snapshots() -> Array[Dictionary]:
    var result: Array[Dictionary] = []
    for dog_id in ["dachshund_intro", "labrador_intro"]:
        var dog_def := DOG_DEFS[dog_id] as Dictionary
        var dog := _dogs.get(dog_id, {}) as Dictionary
        var equipment_items: Array[Dictionary] = []
        var equipment_name := str(dog.get("equipment", ""))
        if equipment_name != "":
            equipment_items.append({
                "id": "equipment.comfortable_slippers",
                "display_name": equipment_name,
            })

        result.append({
            "id": str(dog_def["key"]),
            "internal_id": dog_id,
            "display_name": str(dog_def["public_name"]),
            "role_tags": [str(dog_def["role"])],
            "innate_traits": [
                {
                    "id": "trait.fast_paws" if dog_id == "dachshund_intro" else "trait.careful_helper",
                    "display_name": str(dog_def["trait"]),
                    "layer": "innate",
                },
            ],
            "learned_abilities": [],
            "learned_abilities_note": "not implemented in Vertical Slice prototype",
            "equipment": equipment_items,
            "current_task": str(dog.get("current_task", "")),
            "current_task_label": str(dog.get("task_label", "IdleTask")),
            "current_visible_state": str(dog.get("state", "idle")),
            "carried_resource": str(dog.get("carried_resource", "")),
            "visible": bool(dog.get("visible", true)),
            "availability": "busy" if str(dog.get("current_task", "")) != "" else "available",
            "fatigue": null,
            "world_x": float(dog.get("x", 0.0)),
        })
    return result


func _state_task_snapshots() -> Array[Dictionary]:
    var result: Array[Dictionary] = []
    if not _current_task.is_empty():
        result.append(_state_task_snapshot(_current_task, "current"))
    for task in _task_queue:
        result.append(_state_task_snapshot(task as Dictionary, "queued"))
    if result.is_empty():
        result.append({
            "id": "IdleTask",
            "type": "IdleTask",
            "status": "idle",
            "queue_state": "implicit",
            "created_by": "prototype_scheduler",
            "blocks_order_progress": false,
            "current_phase": null,
        })
    return result


func _state_task_snapshot(task: Dictionary, queue_state: String) -> Dictionary:
    var snapshot := task.duplicate(true)
    snapshot.erase("steps")
    snapshot["queue_state"] = queue_state
    var internal_assigned_dog_id := str(task.get("assigned_dog_id", ""))
    snapshot["internal_assigned_dog_id"] = internal_assigned_dog_id
    snapshot["assigned_dog_id"] = _dog_key_from_internal(internal_assigned_dog_id)
    snapshot["assigned_dog"] = snapshot["assigned_dog_id"]
    snapshot["source_object"] = _object_key_from_internal(str(task.get("source_object_id", "")))
    snapshot["target_object"] = _object_key_from_internal(str(task.get("target_object_id", "")))
    snapshot["resource"] = _resource_key_from_internal(str(task.get("resource_id", "")))
    snapshot["current_phase"] = _state_current_phase_snapshot(task) if queue_state == "current" else null
    return snapshot


func _state_current_phase_snapshot(task: Dictionary) -> Dictionary:
    var steps := task.get("steps", []) as Array
    if _current_step_index < 0 or _current_step_index >= steps.size():
        return {
            "index": _current_step_index,
            "status": str(task.get("status", "")),
            "elapsed_seconds": _step_time,
            "duration_seconds": 0.0,
        }

    var step := steps[_current_step_index] as Dictionary
    return {
        "index": _current_step_index,
        "status": str(step.get("status", task.get("status", ""))),
        "dog_state": str(step.get("dog_state", "")),
        "elapsed_seconds": _step_time,
        "duration_seconds": _step_duration(step),
        "on_start": str(step.get("on_start", "")),
        "on_complete": str(step.get("on_complete", "")),
    }


func _state_building_snapshots() -> Array[Dictionary]:
    return [
        _state_building_snapshot("road_sign", _road_sign_state()),
        _state_building_snapshot("storage", _storage_state()),
        _state_building_snapshot("kitchen", _kitchen_state()),
        _state_building_snapshot("packing_table", _packing_table_state()),
        _state_building_snapshot("delivery_van_endpoint", _delivery_state),
    ]


func _state_building_snapshot(anchor_id: String, station_state: String) -> Dictionary:
    var anchor := ANCHOR_DEFS[anchor_id] as Dictionary
    return {
        "id": str(anchor["key"]),
        "internal_id": anchor_id,
        "display_name": str(anchor["label"]),
        "taxonomy": str(anchor["taxonomy"]),
        "state": station_state,
        "queue_ids": _queue_ids_for_object(anchor_id),
    }


func _road_sign_state() -> String:
    if not _route_started:
        return "route_available"
    if _transport_state == "waiting_for_unload":
        return "unload_available"
    return _transport_state


func _storage_state() -> String:
    if _has_current_task("UnloadTask"):
        return "receiving_resources"
    if _kitchen_carries_enqueued:
        return "waiting_for_output_tasks"
    if _inventory_count(_storage_inventory, "oat_crate") > 0 and _inventory_count(_storage_inventory, "pumpkin_crate") > 0:
        return "ready_for_production"
    return "has_starting_supplies"


func _kitchen_state() -> String:
    if _has_current_task("CookTask", "in_progress"):
        return "cooking"
    if _token_at("food_mix", "kitchen"):
        return "output_ready"
    if (
        _inventory_count(_kitchen_inputs, "oat_crate") > 0
        and _inventory_count(_kitchen_inputs, "pumpkin_crate") > 0
        and _inventory_count(_kitchen_inputs, "protein_packet") > 0
    ):
        return "inputs_ready"
    return "waiting_for_inputs"


func _packing_table_state() -> String:
    if _has_current_task("PackTask", "in_progress"):
        return "packing"
    if _token_at("food_bag", "packing_table"):
        return "output_ready"
    if (
        _inventory_count(_packing_inputs, "food_mix") > 0
        and _inventory_count(_packing_inputs, "packaging_bag") > 0
    ):
        return "inputs_ready"
    if _packing_carries_enqueued:
        return "waiting_for_packaging"
    return "waiting_for_mix"


func _queue_ids_for_object(object_id: String) -> Array[String]:
    var result: Array[String] = []
    if _task_touches_object(_current_task, object_id):
        result.append(str(_current_task.get("id", "")))
    for task in _task_queue:
        var task_dict := task as Dictionary
        if _task_touches_object(task_dict, object_id):
            result.append(str(task_dict.get("id", "")))
    return result


func _task_touches_object(task: Dictionary, object_id: String) -> bool:
    if task.is_empty():
        return false
    if str(task.get("source_object_id", "")) == object_id or str(task.get("target_object_id", "")) == object_id:
        return true
    if object_id == "road_sign" and str(task.get("type", "")) == "TripTask":
        return true
    if object_id == "delivery_van_endpoint" and str(task.get("type", "")) == "DeliveryTask":
        return true
    return false


func _state_resource_snapshot() -> Dictionary:
    return {
        "known_resources": _known_resource_snapshots(),
        "inventories": {
            "storage": _inventory_snapshot(_storage_inventory),
            "kitchen_inputs": _inventory_snapshot(_kitchen_inputs),
            "packing_table_inputs": _inventory_snapshot(_packing_inputs),
            "delivery_van_endpoint": {
                "food_bag": 1 if _token_at("food_bag", "delivery_van_endpoint") else 0,
            },
        },
        "tokens": _state_token_snapshots(),
    }


func _known_resource_snapshots() -> Array[Dictionary]:
    var result: Array[Dictionary] = []
    for resource_id in RESOURCE_ORDER:
        var resource_def := RESOURCE_DEFS[resource_id] as Dictionary
        result.append({
            "id": str(resource_def["key"]),
            "internal_id": resource_id,
            "display_name": str(resource_def["name"]),
            "taxonomy": str(resource_def["taxonomy"]),
        })
    return result


func _inventory_snapshot(inventory: Dictionary) -> Dictionary:
    var result: Dictionary = {}
    for resource_id in RESOURCE_ORDER:
        result[resource_id] = int(inventory.get(resource_id, 0))
    return result


func _state_token_snapshots() -> Array[Dictionary]:
    var result: Array[Dictionary] = []
    for resource_id in RESOURCE_ORDER:
        if not _tokens.has(resource_id):
            continue
        var token := _tokens[resource_id] as Dictionary
        var snapshot := {
            "id": str(token.get("id", resource_id)),
            "resource": _resource_key_from_internal(resource_id),
            "internal_resource_id": resource_id,
            "location": str(token.get("location", "")),
            "visible": bool(token.get("visible", true)),
            "carried_by": _dog_key_from_internal(str(token.get("carried_by", ""))),
            "from_payload": bool(token.get("from_payload", false)),
        }
        if token.has("semantic_state"):
            snapshot["semantic_state"] = str(token.get("semantic_state", ""))
        if token.has("delivery_id"):
            snapshot["delivery_id"] = str(token.get("delivery_id", ""))
        if token.has("delivered_at_seconds"):
            snapshot["delivered_at_seconds"] = float(token.get("delivered_at_seconds", 0.0))
        result.append(snapshot)
    return result


func _state_chain_snapshot() -> Array[Dictionary]:
    var storage_done := (
        (_inventory_count(_storage_inventory, "oat_crate") > 0 and _inventory_count(_storage_inventory, "pumpkin_crate") > 0)
        or _kitchen_carries_enqueued
        or _cook_enqueued
        or _packing_carries_enqueued
        or _pack_enqueued
        or _load_van_enqueued
        or _van_loaded
        or _delivery_confirmed
        or _delivery_complete
        or _postcard_visible
        or _chain_complete
    )
    var kitchen_carry_done := _cook_enqueued or _packing_carries_enqueued or _pack_enqueued or _load_van_enqueued or _van_loaded or _delivery_confirmed or _delivery_complete or _postcard_visible or _chain_complete
    var cooking_done := _token_at("food_mix", "kitchen") or _packing_carries_enqueued or _pack_enqueued or _load_van_enqueued or _van_loaded or _delivery_confirmed or _delivery_complete or _postcard_visible or _chain_complete
    var packing_carry_done := _pack_enqueued or _load_van_enqueued or _van_loaded or _delivery_confirmed or _delivery_complete or _postcard_visible or _chain_complete
    var packing_done := _token_at("food_bag", "packing_table") or _load_van_enqueued or _van_loaded or _delivery_confirmed or _delivery_complete or _postcard_visible or _chain_complete
    var stages: Array[Dictionary] = [
        {"id": "trip", "status": _stage_status(_route_started, _trip_payload_visible, "waiting_for_player_route_confirmation")},
        {"id": "unload_to_storage", "status": _stage_status(_trip_payload_visible, storage_done)},
        {"id": "carry_to_kitchen", "status": _stage_status(_kitchen_carries_enqueued, kitchen_carry_done)},
        {"id": "cook_food_mix", "status": _stage_status(_cook_enqueued, cooking_done)},
        {"id": "carry_to_packing_table", "status": _stage_status(_packing_carries_enqueued, packing_carry_done)},
        {"id": "pack_food_bag", "status": _stage_status(_pack_enqueued, packing_done)},
        {"id": "load_delivery_van", "status": _stage_status(_load_van_enqueued, _van_loaded)},
        {"id": "player_confirm_delivery", "status": "complete" if _delivery_confirmed else ("waiting_for_player_confirmation" if _van_loaded else "waiting")},
        {"id": "delivery", "status": _stage_status(_delivery_confirmed, _delivery_complete)},
    ]
    if not _is_day2_active():
        stages.append({"id": "postcard_reward", "status": _stage_status(_postcard_visible, _reward_available)})
        stages.append({"id": "equip_comfortable_slippers", "status": _stage_status(_equip_task_created, _slippers_equipped)})
    return stages


func _stage_status(started: bool, complete: bool, waiting_text := "waiting") -> String:
    if complete:
        return "complete"
    if started:
        return "in_progress"
    return waiting_text


func _state_event_snapshots() -> Array[Dictionary]:
    return _systems_runtime.event_snapshots(80)


func _state_debug_snapshot() -> Dictionary:
    return {
        "last_event": _last_event,
        "current_task_label": _current_task_label(),
        "performance": {
            "fps": Performance.get_monitor(Performance.TIME_FPS),
            "draw_calls": Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME),
            "node_count": Performance.get_monitor(Performance.OBJECT_NODE_COUNT),
            "static_memory_mb": Performance.get_monitor(Performance.MEMORY_STATIC) / (1024.0 * 1024.0),
        },
        "connector_enabled": _state_connector_enabled,
        "runtime_speed_multiplier": _systems_runtime.debug_speed_multiplier,
    }


func _dog_key_from_internal(dog_id: String) -> Variant:
    if dog_id == "" or not DOG_DEFS.has(dog_id):
        return null
    return str((DOG_DEFS[dog_id] as Dictionary)["key"])


func _object_key_from_internal(object_id: String) -> Variant:
    if object_id == "":
        return null
    if ANCHOR_DEFS.has(object_id):
        return str((ANCHOR_DEFS[object_id] as Dictionary)["key"])
    if object_id == "basket_bicycle":
        return "transport.basket_bicycle"
    if object_id == "postcard_card":
        return "ui.postcard_card"
    return object_id


func _resource_key_from_internal(resource_id: String) -> Variant:
    if resource_id == "":
        return null
    if RESOURCE_DEFS.has(resource_id):
        return str((RESOURCE_DEFS[resource_id] as Dictionary)["key"])
    return resource_id


func _build_report() -> Array[String]:
    var screen := DisplayServer.window_get_current_screen(WINDOW_ID)
    return [
        "demo=steam_vertical_slice",
        "display_server=%s" % DisplayServer.get_name(),
        "os=%s" % OS.get_name(),
        "screen_count=%s" % DisplayServer.get_screen_count(),
        "screen_index=%s" % screen,
        "screen_usable_rect=%s" % DisplayServer.screen_get_usable_rect(screen),
        "window_size=%s" % DisplayServer.window_get_size(WINDOW_ID),
        "flag_always_on_top=%s" % DisplayServer.window_get_flag(DisplayServer.WINDOW_FLAG_ALWAYS_ON_TOP, WINDOW_ID),
        "flag_borderless=%s" % DisplayServer.window_get_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, WINDOW_ID),
        "flag_transparent=%s" % DisplayServer.window_get_flag(DisplayServer.WINDOW_FLAG_TRANSPARENT, WINDOW_ID),
        "click_through_empty=%s" % _click_through_empty,
        "timing_scale=%.2f" % _timing_scale,
        "task_types=%s" % ", ".join(TASK_TYPE_DEFS.keys()),
        "active_order_id=%s" % _active_order_id(),
        "active_chain_run_id=%s" % str(_active_chain.get("run_id", "")),
    ]
