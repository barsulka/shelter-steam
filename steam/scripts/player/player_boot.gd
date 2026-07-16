class_name ShelterPlayerBoot
extends Control

const VERTICAL_SLICE_SCENE := preload("res://scenes/prototypes/vertical_slice/vertical_slice_demo.tscn")
const PlayerProfileStore := preload("res://scripts/persistence/player_profile_store.gd")
const PlayerProfileSchema := preload("res://scripts/persistence/player_profile_schema.gd")
const PlayerCheckpointCodec := preload("res://scripts/player/player_checkpoint_codec.gd")

const STARTUP_INTENT_FRESH_SESSION := "fresh_session"
const STARTUP_INTENT_CONTINUE := "continue"
const CONTENT_BUILD_VERSION := "r48-internal-1"
const OBSERVER_CONTROL_FLAG := "--shelter-observer-control-v1"
const OBSERVER_CONTROL_REQUEST_PATH := "user://d029-observer-control/quit.request"
const OBSERVER_CONTROL_REQUEST_TEXT := "SHELTER_CONTROL_QUIT\n"
const OBSERVER_CONTROL_ACK := "shelter_project_quit_ack=true"

const COPY_SAVE_FAILURE := "Не удалось сохранить. Мир остановлен на безопасном месте."
const COPY_INVALID_PROFILE := "Не удалось безопасно открыть сохранение. Оно осталось без изменений."
const COPY_INCOMPATIBLE_PROFILE := "Эта версия игры не может безопасно открыть сохранение. Оно осталось без изменений."

var _startup_intent := STARTUP_INTENT_FRESH_SESSION
var _runtime: Control
var _store: RefCounted
var _codec := PlayerCheckpointCodec.new()
var _store_base_dir := PlayerProfileStore.PRODUCTION_BASE_DIR
var _store_test_mode := false
var _test_store_failpoint := ""
var _boot_configuration_locked := false
var _loaded_checkpoint: Dictionary = {}
var _recovery_source := ""
var _last_persisted_sequence := 0
var _last_persisted_digest := ""
var _lifecycle_status := "starting"
var _lifecycle_action := ""
var _lifecycle_action_in_progress := false
var _lifecycle_panel: PanelContainer
var _lifecycle_label: Label
var _lifecycle_button: Button
var _observer_control_enabled := false
var _observer_control_consumed := false
var _observer_control_timer: Timer
var _graceful_shutdown_started := false
var _graceful_shutdown_source := ""


func configure_player_boot(configuration: Dictionary) -> Dictionary:
    if _boot_configuration_locked or is_inside_tree():
        return {"ok": false, "error": "player_boot_already_started"}
    var base_dir := str(configuration.get("profile_base_dir", PlayerProfileStore.PRODUCTION_BASE_DIR)).trim_suffix("/")
    var test_mode := bool(configuration.get("test_mode", false))
    if test_mode and not base_dir.begins_with(PlayerProfileStore.TEST_BASE_PREFIX):
        return {"ok": false, "error": "test_profile_root_invalid"}
    if not test_mode and base_dir != PlayerProfileStore.PRODUCTION_BASE_DIR:
        return {"ok": false, "error": "production_profile_root_invalid"}
    _store_base_dir = base_dir
    _store_test_mode = test_mode
    if configuration.has("store_failpoint"):
        if not test_mode:
            return {"ok": false, "error": "store_failpoint_requires_test_mode"}
        _test_store_failpoint = str(configuration["store_failpoint"])
    return {"ok": true}


func _ready() -> void:
    _boot_configuration_locked = true
    get_tree().auto_accept_quit = false
    _configure_observer_control()
    _store = PlayerProfileStore.new(_store_base_dir, _store_test_mode)
    if _store_test_mode and _test_store_failpoint != "":
        var failpoint_result: Dictionary = _store.call("configure_test_failpoint", _test_store_failpoint, false) as Dictionary
        if not bool(failpoint_result.get("ok", false)):
            _show_error(COPY_INVALID_PROFILE, "test_store_failpoint_invalid")
            return
    _prepare_startup()


func _notification(what: int) -> void:
    if what == NOTIFICATION_WM_CLOSE_REQUEST:
        _begin_graceful_shutdown("wm_close")


func _configure_observer_control() -> void:
    _observer_control_enabled = OS.get_cmdline_user_args().count(OBSERVER_CONTROL_FLAG) == 1
    if not _observer_control_enabled:
        return
    _observer_control_timer = Timer.new()
    _observer_control_timer.wait_time = 0.05
    _observer_control_timer.one_shot = false
    _observer_control_timer.timeout.connect(_poll_observer_control_request)
    add_child(_observer_control_timer)
    _observer_control_timer.start()


func _poll_observer_control_request() -> void:
    if not _observer_control_enabled or _observer_control_consumed or _graceful_shutdown_started:
        return
    if not FileAccess.file_exists(OBSERVER_CONTROL_REQUEST_PATH):
        return
    _observer_control_consumed = true
    if _observer_control_timer != null:
        _observer_control_timer.stop()
    var payload := FileAccess.get_file_as_bytes(OBSERVER_CONTROL_REQUEST_PATH)
    var remove_error := DirAccess.remove_absolute(ProjectSettings.globalize_path(OBSERVER_CONTROL_REQUEST_PATH))
    if remove_error != OK:
        push_error("shelter_observer_control=FAIL reason=request_remove_failed code=%d" % remove_error)
        return
    if payload != OBSERVER_CONTROL_REQUEST_TEXT.to_utf8_buffer():
        push_error("shelter_observer_control=FAIL reason=malformed_request")
        return
    _begin_graceful_shutdown("observer_control")


func _begin_graceful_shutdown(source: String) -> Dictionary:
    if _graceful_shutdown_started:
        return {"ok": true, "status": "already_started", "source": _graceful_shutdown_source}
    if _runtime != null:
        var checkpoint_snapshot := _runtime.call("player_checkpoint_snapshot") as Dictionary
        if bool(checkpoint_snapshot.get("commit_in_progress", false)):
            push_error("shelter_project_quit=FAIL reason=checkpoint_commit_in_progress")
            return {"ok": false, "error": "checkpoint_commit_in_progress"}
        _runtime.process_mode = Node.PROCESS_MODE_DISABLED
        print(
            "shelter_project_quit_persistence=durable checkpoint_sequence=%d barrier_failed=%s"
            % [
                int(checkpoint_snapshot.get("checkpoint_sequence", 0)),
                str(bool(checkpoint_snapshot.get("barrier_failed", false))).to_lower(),
            ]
        )
    _graceful_shutdown_started = true
    _graceful_shutdown_source = source
    _lifecycle_action = ""
    _lifecycle_action_in_progress = true
    if _observer_control_timer != null:
        _observer_control_timer.stop()
    print("shelter_project_quit_source=%s" % source)
    print(OBSERVER_CONTROL_ACK)
    _finish_graceful_shutdown.call_deferred()
    return {"ok": true, "status": "acknowledged", "source": source}


func _finish_graceful_shutdown() -> void:
    await get_tree().process_frame
    get_tree().quit(0)


func clear_test_store_failpoint() -> Dictionary:
    if not _store_test_mode or _store == null:
        return {"ok": false, "error": "test_store_unavailable"}
    _test_store_failpoint = ""
    return _store.call("configure_test_failpoint", "", false) as Dictionary


func configure_test_store_failpoint(failpoint: String) -> Dictionary:
    if not _store_test_mode or _store == null:
        return {"ok": false, "error": "test_store_unavailable"}
    _test_store_failpoint = failpoint
    return _store.call("configure_test_failpoint", failpoint, false) as Dictionary


func _prepare_startup() -> void:
    var inspection: Dictionary = _store.call("inspect_profile_candidates") as Dictionary
    if not bool(inspection.get("ok", false)):
        _show_error(COPY_INVALID_PROFILE, "profile_inspection_failed")
        return
    var status := str(inspection.get("status", ""))
    if status == "primary_available":
        var loaded := _load_valid_checkpoint("primary")
        if not bool(loaded.get("ok", false)):
            _show_checkpoint_error(loaded)
            return
        _offer_continue(loaded["checkpoint"] as Dictionary)
        return
    if status in ["backup_available", "temp_available"]:
        var source := str(inspection.get("selected_source", ""))
        var loaded := _load_valid_checkpoint(source)
        if not bool(loaded.get("ok", false)):
            _show_checkpoint_error(loaded)
            return
        _loaded_checkpoint = (loaded["checkpoint"] as Dictionary).duplicate(true)
        _recovery_source = source
        _show_lifecycle("Найдено безопасное сохранение.", "Восстановить и продолжить", "recover")
        return
    if status == "incompatible_primary":
        _show_error(COPY_INCOMPATIBLE_PROFILE, "incompatible_profile")
        return
    if status == "no_valid_profile" and _all_candidates_absent(inspection):
        _start_runtime(STARTUP_INTENT_FRESH_SESSION, {})
        return
    _show_error(COPY_INVALID_PROFILE, "invalid_profile")


func _all_candidates_absent(inspection: Dictionary) -> bool:
    var candidates := inspection.get("candidates", {}) as Dictionary
    for source in ["primary", "backup", "temp"]:
        var candidate := candidates.get(source, {}) as Dictionary
        if str(candidate.get("classification", "")) != "absent":
            return false
    return true


func _load_valid_checkpoint(source: String) -> Dictionary:
    var load_result: Dictionary = _store.call("load_profile_candidate", source) as Dictionary
    if not bool(load_result.get("ok", false)):
        return {"ok": false, "error": "profile_candidate_load_failed", "load_result": load_result}
    var envelope := load_result.get("envelope", {}) as Dictionary
    var checkpoint := envelope.get("payload", {}) as Dictionary
    var validation := _codec.validate_checkpoint(checkpoint, {
        "payload_format_id": envelope.get("payload_format_id"),
        "payload_schema_version": envelope.get("payload_schema_version"),
        "journey_phase": envelope.get("journey_phase"),
        "checkpoint_kind": envelope.get("checkpoint_kind"),
        "checkpoint_sequence": envelope.get("checkpoint_sequence"),
    })
    if not bool(validation.get("ok", false)):
        return {"ok": false, "error": "checkpoint_contract_invalid", "validation": validation}
    return {
        "ok": true,
        "checkpoint": (validation["checkpoint"] as Dictionary).duplicate(true),
        "validation": validation,
        "envelope": envelope.duplicate(true),
    }


func _offer_continue(checkpoint: Dictionary) -> void:
    _loaded_checkpoint = checkpoint.duplicate(true)
    var validation := _codec.validate_checkpoint(_loaded_checkpoint)
    _last_persisted_sequence = int(validation["checkpoint_sequence"])
    _last_persisted_digest = str(validation["checkpoint_digest"])
    var phase := str((_loaded_checkpoint["journey"] as Dictionary)["phase"])
    if phase == "first_day_complete_hold":
        _show_lifecycle("Кооператив спокойно ждёт возвращения.", "Продолжить", "begin_day2_return")
    elif phase == "quiet_cooperative":
        _show_lifecycle("Кооператив отдыхает. Можно вернуться, когда удобно.", "Вернуться в кооператив", "continue")
    else:
        _show_lifecycle("Сохранение готово.", "Продолжить", "continue")


func activate_lifecycle_action() -> Dictionary:
    if _graceful_shutdown_started:
        return {"ok": false, "error": "graceful_shutdown_in_progress"}
    if _lifecycle_action == "" or _lifecycle_action_in_progress:
        return {"ok": false, "error": "lifecycle_action_unavailable"}
    _lifecycle_action_in_progress = true
    var action := _lifecycle_action
    var result := {"ok": false, "error": "unknown_lifecycle_action"}
    match action:
        "continue":
            result = _start_runtime(STARTUP_INTENT_CONTINUE, _loaded_checkpoint)
        "begin_day2_return":
            result = _start_runtime("begin_day2_return", _loaded_checkpoint)
        "recover":
            result = _recover_and_continue()
        "retry_save":
            if _runtime != null:
                result = _runtime.call("retry_player_checkpoint_commit") as Dictionary
                if bool(result.get("ok", false)):
                    _clear_lifecycle()
    _lifecycle_action_in_progress = false
    return result


func _recover_and_continue() -> Dictionary:
    var recovery: Dictionary = _store.call("recover_profile_candidate", _recovery_source, PlayerProfileStore.RECOVERY_AUTHORITY) as Dictionary
    if not bool(recovery.get("ok", false)):
        _show_error(COPY_INVALID_PROFILE, "recovery_failed")
        return recovery
    var loaded := _load_valid_checkpoint("primary")
    if not bool(loaded.get("ok", false)):
        _show_checkpoint_error(loaded)
        return loaded
    var checkpoint := loaded["checkpoint"] as Dictionary
    var validation := loaded["validation"] as Dictionary
    _last_persisted_sequence = int(validation["checkpoint_sequence"])
    _last_persisted_digest = str(validation["checkpoint_digest"])
    var phase := str((checkpoint["journey"] as Dictionary)["phase"])
    return _start_runtime("begin_day2_return" if phase == "first_day_complete_hold" else STARTUP_INTENT_CONTINUE, checkpoint)


func _start_runtime(intent: String, checkpoint: Dictionary) -> Dictionary:
    if _runtime != null:
        return {"ok": false, "error": "player_runtime_already_exists"}
    var runtime := VERTICAL_SLICE_SCENE.instantiate() as Control
    if runtime == null:
        _show_error(COPY_INVALID_PROFILE, "runtime_instantiation_failed")
        return {"ok": false, "error": "runtime_instantiation_failed"}
    var configuration := {
        "startup_intent": intent,
        "checkpoint_commit_sink": Callable(self, "_persist_runtime_checkpoint"),
    }
    if intent in [STARTUP_INTENT_CONTINUE, "begin_day2_return"]:
        configuration["checkpoint"] = checkpoint.duplicate(true)
    var configuration_result: Dictionary = runtime.call("configure_player_session", configuration) as Dictionary
    if not bool(configuration_result.get("ok", false)):
        runtime.queue_free()
        _show_error(COPY_INVALID_PROFILE, "runtime_configuration_failed")
        return configuration_result
    _runtime = runtime
    _startup_intent = intent
    _clear_lifecycle()
    add_child(_runtime)
    _lifecycle_status = "runtime_active"
    return {"ok": true, "startup_intent": intent}


func _persist_runtime_checkpoint(checkpoint: Dictionary) -> Dictionary:
    var validation := _codec.validate_checkpoint(checkpoint)
    if not bool(validation.get("ok", false)):
        _show_save_failure()
        return {"ok": false, "error": "checkpoint_contract_invalid", "validation": validation}
    var normalized_checkpoint := (validation["checkpoint"] as Dictionary).duplicate(true)
    var sequence := int(validation["checkpoint_sequence"])
    var digest := str(validation["checkpoint_digest"])
    if sequence == _last_persisted_sequence:
        if digest == _last_persisted_digest:
            return {"ok": true, "status": "idempotent_noop", "checkpoint_sequence": sequence}
        _show_save_failure()
        return {"ok": false, "error": "checkpoint_sequence_conflict"}
    if sequence < _last_persisted_sequence:
        _show_save_failure()
        return {"ok": false, "error": "checkpoint_sequence_regression"}
    if _last_persisted_sequence > 0 and sequence != _last_persisted_sequence + 1:
        _show_save_failure()
        return {"ok": false, "error": "checkpoint_sequence_jump"}
    var journey := checkpoint["journey"] as Dictionary
    var fields := {
        "format_id": PlayerProfileSchema.FORMAT_ID,
        "schema_version": PlayerProfileSchema.SCHEMA_VERSION,
        "content_build_version": CONTENT_BUILD_VERSION,
        "profile_id": PlayerProfileSchema.PROFILE_ID,
        "journey_phase": journey["phase"],
        "checkpoint_kind": journey["checkpoint_kind"],
        "checkpoint_sequence": sequence,
        "payload_format_id": PlayerProfileSchema.PAYLOAD_FORMAT_ID,
        "payload_schema_version": int(normalized_checkpoint["schema_version"]),
        "payload": normalized_checkpoint,
        "written_at_metadata": {
            "source": "system_utc_diagnostic_only",
            "iso8601_utc": Time.get_datetime_string_from_system(true),
        },
    }
    var authority := PlayerProfileStore.UPDATE_AUTHORITY if _last_persisted_sequence > 0 else PlayerProfileStore.CREATE_AUTHORITY
    var store_result: Dictionary = _store.call("store_profile", fields, authority) as Dictionary
    if not bool(store_result.get("ok", false)):
        _show_save_failure()
        return store_result
    _last_persisted_sequence = sequence
    _last_persisted_digest = digest
    if _lifecycle_action == "retry_save":
        _clear_lifecycle()
    return {"ok": true, "status": "persisted", "checkpoint_sequence": sequence, "checkpoint_digest": digest}


func _show_save_failure() -> void:
    _show_lifecycle(COPY_SAVE_FAILURE, "Повторить сохранение", "retry_save")


func _show_checkpoint_error(result: Dictionary) -> void:
    var validation := result.get("validation", {}) as Dictionary
    var error := str(validation.get("error", result.get("error", "")))
    if error.begins_with("incompatible_"):
        _show_error(COPY_INCOMPATIBLE_PROFILE, "incompatible_checkpoint")
    else:
        _show_error(COPY_INVALID_PROFILE, "invalid_checkpoint")


func _show_error(text: String, status: String) -> void:
    _show_lifecycle(text, "", "")
    _lifecycle_status = status


func _show_lifecycle(text: String, button_text: String, action: String) -> void:
    _clear_lifecycle()
    _lifecycle_panel = PanelContainer.new()
    _lifecycle_panel.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
    _lifecycle_panel.custom_minimum_size = Vector2(430.0, 112.0)
    var margin := MarginContainer.new()
    margin.add_theme_constant_override("margin_left", 16)
    margin.add_theme_constant_override("margin_top", 12)
    margin.add_theme_constant_override("margin_right", 16)
    margin.add_theme_constant_override("margin_bottom", 12)
    _lifecycle_panel.add_child(margin)
    var layout := VBoxContainer.new()
    layout.add_theme_constant_override("separation", 8)
    margin.add_child(layout)
    _lifecycle_label = Label.new()
    _lifecycle_label.text = text
    _lifecycle_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    _lifecycle_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    layout.add_child(_lifecycle_label)
    if button_text != "":
        _lifecycle_button = Button.new()
        _lifecycle_button.text = button_text
        _lifecycle_button.pressed.connect(_on_lifecycle_button_pressed)
        layout.add_child(_lifecycle_button)
    add_child(_lifecycle_panel)
    move_child(_lifecycle_panel, get_child_count() - 1)
    _lifecycle_action = action
    _lifecycle_status = action if action != "" else "error"


func _clear_lifecycle() -> void:
    if _lifecycle_panel != null and is_instance_valid(_lifecycle_panel):
        _lifecycle_panel.queue_free()
    _lifecycle_panel = null
    _lifecycle_label = null
    _lifecycle_button = null
    _lifecycle_action = ""


func _on_lifecycle_button_pressed() -> void:
    activate_lifecycle_action()


func player_runtime() -> Control:
    return _runtime


func startup_intent() -> String:
    return _startup_intent


func lifecycle_snapshot() -> Dictionary:
    return {
        "status": _lifecycle_status,
        "action": _lifecycle_action,
        "action_in_progress": _lifecycle_action_in_progress,
        "copy": _lifecycle_label.text if _lifecycle_label != null else "",
        "button_text": _lifecycle_button.text if _lifecycle_button != null else "",
        "runtime_exists": _runtime != null,
        "runtime_child_count": 1 if _runtime != null else 0,
        "last_persisted_sequence": _last_persisted_sequence,
        "last_persisted_digest": _last_persisted_digest,
        "profile_base_dir": _store_base_dir if _store_test_mode else "user://player/default",
    }


func graceful_shutdown_snapshot() -> Dictionary:
    return {
        "control_enabled": _observer_control_enabled,
        "control_polling": (
            _observer_control_timer != null
            and not _observer_control_timer.is_stopped()
        ),
        "control_consumed": _observer_control_consumed,
        "shutdown_started": _graceful_shutdown_started,
        "shutdown_source": _graceful_shutdown_source,
    }
