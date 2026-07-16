extends Node

const PlayerBootScene := preload("res://scenes/player/player_boot.tscn")
const Store := preload("res://scripts/persistence/player_profile_store.gd")
const Schema := preload("res://scripts/persistence/player_profile_schema.gd")
const Codec := preload("res://scripts/player/player_checkpoint_codec.gd")

var _codec := Codec.new()
var _phase := "full"
var _base_dir := "user://player-tests/r48-02b-default"
var _target_sequence := 1
var _failures: Array[String] = []


func _ready() -> void:
    _read_args()
    _run.call_deferred()


func _run() -> void:
    if not _safe_test_root():
        _fail("unsafe test root")
        _finish()
        return
    match _phase:
        "cleanup":
            _clean_base()
        "write":
            _clean_base()
            await _write_profile_to_sequence(_target_sequence, false)
        "snapshot-inflight":
            _clean_base()
            await _write_profile_to_sequence(_target_sequence, true)
            if _failures.is_empty():
                print("player_continue_inflight_snapshot=authored sequence=%d" % _target_sequence)
        "snapshot-failed-barrier":
            await _author_failed_barrier_snapshot(_target_sequence)
            if _failures.is_empty():
                print("player_continue_failed_barrier_snapshot=authored sequence=%d" % _target_sequence)
        "snapshot-completion-beat":
            await _author_completion_beat_snapshot()
            if _failures.is_empty():
                print("player_continue_completion_beat_snapshot=authored sequence=32")
        "read":
            await _read_profile_at_sequence(_target_sequence, false)
        "advance":
            await _read_profile_at_sequence(_target_sequence, true)
        "recovery":
            _clean_base()
            await _test_recovery_and_invalid_startup()
            _clean_base()
        "save-retry":
            _clean_base()
            await _test_save_failure_retry()
            _clean_base()
        "automatic-save-retry":
            _clean_base()
            await _write_profile_to_sequence(8, false)
            await _test_automatic_completion_save_failure_retry()
            _clean_base()
        "sequence-rules":
            _clean_base()
            await _write_profile_to_sequence(8, false)
            await _test_sequence_rules()
            _clean_base()
        "retry-cursor":
            await _test_retry_cursor(_target_sequence)
        _:
            _clean_base()
            await _write_profile_to_sequence(17, false)
            await _read_profile_at_sequence(17, false)
            _clean_base()
    _finish()


func _write_profile_to_sequence(target: int, start_inflight: bool) -> void:
    var boot := PlayerBootScene.instantiate()
    _expect_ok(boot.call("configure_player_boot", {"profile_base_dir": _base_dir, "test_mode": true}) as Dictionary, "configure isolated boot")
    add_child(boot)
    await get_tree().process_frame
    await get_tree().process_frame
    var runtime: Variant = boot.call("player_runtime")
    _expect(runtime != null, "fresh startup creates one runtime")
    if runtime == null:
        return
    runtime.set_process(false)
    while int((runtime.call("player_checkpoint_snapshot") as Dictionary).get("checkpoint_sequence", 0)) < target:
        var current_sequence := int((runtime.call("player_checkpoint_snapshot") as Dictionary).get("checkpoint_sequence", 0))
        if current_sequence == 17:
            boot.queue_free()
            await get_tree().process_frame
            boot = PlayerBootScene.instantiate()
            _expect_ok(boot.call("configure_player_boot", {"profile_base_dir": _base_dir, "test_mode": true}) as Dictionary, "configure Day 2 return boot")
            add_child(boot)
            await get_tree().process_frame
            _expect_ok(boot.call("activate_lifecycle_action") as Dictionary, "activate persisted Day 2 return")
            await get_tree().process_frame
            runtime = boot.call("player_runtime")
            _expect(runtime != null, "Day 2 return creates one runtime")
            if runtime == null:
                return
            runtime.set_process(false)
        else:
            _expect_ok(runtime.call("test_advance_player_to_next_checkpoint", 5000) as Dictionary, "advance to target cursor")
        if not _failures.is_empty():
            return
    var snapshot := runtime.call("player_checkpoint_snapshot") as Dictionary
    _expect(int(snapshot.get("checkpoint_sequence", 0)) == target, "target cursor persisted")
    if start_inflight:
        var in_flight := runtime.call("test_progress_player_pending_task_in_flight") as Dictionary
        _expect_ok(in_flight, "progress interrupted automatic task in-flight")
        _expect(int(in_flight.get("step_time_milliseconds", 0)) > 0, "interrupted task has elapsed in-flight work")
        _expect(str(in_flight.get("task_type", "")) == str((_codec.pending_intents(_codec.kind_for_sequence(target))[0] as Dictionary).get("type", "")), "interrupted task family matches pending intent")
        var after_start := runtime.call("player_checkpoint_snapshot") as Dictionary
        _expect(int(after_start.get("checkpoint_sequence", 0)) == target, "in-flight task does not create checkpoint")
    var store := Store.new(_base_dir, true)
    var loaded := store.load_profile_candidate("primary")
    _expect_ok(loaded, "primary exists after write")
    if bool(loaded.get("ok", false)):
        _expect(int((loaded["envelope"] as Dictionary)["checkpoint_sequence"]) == target, "stored primary exact target")


func _read_profile_at_sequence(expected: int, advance_once: bool) -> void:
    var boot := PlayerBootScene.instantiate()
    _expect_ok(boot.call("configure_player_boot", {"profile_base_dir": _base_dir, "test_mode": true}) as Dictionary, "configure restart boot")
    add_child(boot)
    await get_tree().process_frame
    var lifecycle := boot.call("lifecycle_snapshot") as Dictionary
    _expect(not bool(lifecycle.get("runtime_exists", true)), "runtime does not tick behind lifecycle choice")
    var expected_action_text := "Вернуться в кооператив" if expected == 33 else "Продолжить"
    _expect(str(lifecycle.get("button_text", "")) == expected_action_text, "exact lifecycle action copy")
    _expect(str(lifecycle.get("action", "")) == ("begin_day2_return" if expected == 17 else "continue"), "single bounded lifecycle action")
    _expect_ok(boot.call("activate_lifecycle_action") as Dictionary, "activate lifecycle action")
    await get_tree().process_frame
    var runtime: Variant = boot.call("player_runtime")
    _expect(runtime != null, "continue creates exactly one runtime")
    if runtime == null:
        return
    runtime.set_process(false)
    var snapshot := runtime.call("player_checkpoint_snapshot") as Dictionary
    var restored_expected := 18 if expected == 17 else expected
    _expect(int(snapshot.get("checkpoint_sequence", 0)) == restored_expected, "restart restores/returns to exact cursor")
    _expect(str(snapshot.get("checkpoint_kind", "")) == _codec.kind_for_sequence(restored_expected), "restart restores exact kind")
    var expected_intents := _codec.pending_intents(_codec.kind_for_sequence(restored_expected))
    _expect((snapshot.get("reconstructed_intents", []) as Array) == expected_intents, "restart reconstructs exact pending intents")
    if expected_intents.is_empty():
        _expect((snapshot.get("pending_intents", []) as Array).is_empty(), "player-owned gate or terminal cursor starts no task")
    var exported := runtime.call("export_player_safe_checkpoint") as Dictionary
    _expect_ok(exported, "restart exports checkpoint")
    if bool(exported.get("ok", false)):
        _expect((exported["checkpoint"] as Dictionary) == _codec.build_golden_checkpoint(_codec.kind_for_sequence(restored_expected)), "restart semantic state exact")
    if advance_once and restored_expected < 33:
        _expect_ok(runtime.call("test_advance_player_to_next_checkpoint") as Dictionary, "advance once after restart")
        var advanced := runtime.call("player_checkpoint_snapshot") as Dictionary
        _expect(int(advanced.get("checkpoint_sequence", 0)) == restored_expected + 1, "first post-restart commit increments exactly once")
        var store := Store.new(_base_dir, true)
        var loaded := store.load_profile_candidate("primary")
        _expect_ok(loaded, "advanced primary loads")
        if bool(loaded.get("ok", false)):
            _expect(int((loaded["envelope"] as Dictionary)["checkpoint_sequence"]) == restored_expected + 1, "advanced primary persisted")
            _expect(((loaded["envelope"] as Dictionary)["payload"] as Dictionary) == _codec.build_golden_checkpoint(_codec.kind_for_sequence(restored_expected + 1)), "advanced primary equals exact next semantic checkpoint")
    elif advance_once:
        var terminal := runtime.call("test_advance_player_to_next_checkpoint") as Dictionary
        _expect(str(terminal.get("error", "")) == "checkpoint_graph_complete", "terminal checkpoint has no successor")


func _test_recovery_and_invalid_startup() -> void:
    await _setup_recovery_source("backup")
    await _assert_recovery_action("backup")
    _clean_base()
    await _setup_recovery_source("temp")
    await _assert_recovery_action("temp")
    _clean_base()

    await _setup_recovery_source("backup")
    await _assert_recovery_cancellation("backup")
    _clean_base()

    for source in ["backup", "temp"]:
        await _setup_checkpoint_invalid_recovery_source(source)
        await _assert_invalid_recovery_source(source)
        _clean_base()

    await _setup_corrupt_no_selectable_profile()
    await _assert_corrupt_no_selectable_profile()
    _clean_base()

    var invalid := _codec.build_golden_checkpoint("first_day_offered")
    (((invalid["resources"] as Dictionary)["storage"] as Dictionary))["protein_packet"] = 1
    _expect_ok(_store_checkpoint(invalid), "store envelope-valid checkpoint-invalid primary")
    var invalid_boot := PlayerBootScene.instantiate()
    _expect_ok(invalid_boot.call("configure_player_boot", {"profile_base_dir": _base_dir, "test_mode": true}) as Dictionary, "configure invalid checkpoint boot")
    add_child(invalid_boot)
    await get_tree().process_frame
    var invalid_state := invalid_boot.call("lifecycle_snapshot") as Dictionary
    _expect(str(invalid_state.get("copy", "")) == "Не удалось безопасно открыть сохранение. Оно осталось без изменений.", "invalid checkpoint calm copy")
    _expect(not bool(invalid_state.get("runtime_exists", true)), "invalid checkpoint never starts fresh")
    _clean_base()

    _expect_ok(_store_checkpoint(_codec.build_golden_checkpoint("first_day_offered")), "store incompatible baseline")
    var paths := (Store.new(_base_dir, true) as RefCounted).call("paths") as Dictionary
    var primary_path := str(paths["primary"])
    var backup_path := str(paths["backup"])
    _copy_file(primary_path, backup_path)
    var raw := FileAccess.get_file_as_string(primary_path)
    raw = raw.replace("\"schema_version\":1", "\"schema_version\":2")
    var file := FileAccess.open(primary_path, FileAccess.WRITE)
    file.store_string(raw)
    file.close()
    var future_boot := PlayerBootScene.instantiate()
    _expect_ok(future_boot.call("configure_player_boot", {"profile_base_dir": _base_dir, "test_mode": true}) as Dictionary, "configure future checkpoint boot")
    add_child(future_boot)
    await get_tree().process_frame
    var future_state := future_boot.call("lifecycle_snapshot") as Dictionary
    _expect(str(future_state.get("copy", "")) == "Эта версия игры не может безопасно открыть сохранение. Оно осталось без изменений.", "future profile calm copy")
    _expect(not bool(future_state.get("runtime_exists", true)), "future primary is terminal despite backup")


func _test_save_failure_retry() -> void:
    var boot := PlayerBootScene.instantiate()
    _expect_ok(boot.call("configure_player_boot", {
        "profile_base_dir": _base_dir,
        "test_mode": true,
        "store_failpoint": "before_validation",
    }) as Dictionary, "configure save-failure boot")
    add_child(boot)
    await get_tree().process_frame
    var lifecycle := boot.call("lifecycle_snapshot") as Dictionary
    _expect(str(lifecycle.get("copy", "")) == "Не удалось сохранить. Мир остановлен на безопасном месте.", "exact save-failure calm copy")
    _expect(str(lifecycle.get("button_text", "")) == "Повторить сохранение", "exact retry action")
    var runtime: Variant = boot.call("player_runtime")
    _expect(runtime != null, "failed first save keeps one stable runtime")
    if runtime != null:
        var blocked := runtime.call("player_checkpoint_snapshot") as Dictionary
        _expect(int(blocked.get("checkpoint_sequence", -1)) == 0, "failed first save commits no cursor")
        _expect(bool(blocked.get("barrier_failed", false)), "failed first save holds barrier")
    _expect_ok(boot.call("clear_test_store_failpoint") as Dictionary, "clear injected store failure")
    _expect_ok(boot.call("activate_lifecycle_action") as Dictionary, "explicit save retry")
    await get_tree().process_frame
    var after := boot.call("lifecycle_snapshot") as Dictionary
    _expect(str(after.get("action", "")) == "", "successful retry clears action")
    if runtime != null:
        var committed := runtime.call("player_checkpoint_snapshot") as Dictionary
        _expect(int(committed.get("checkpoint_sequence", 0)) == 1, "retry persists initial cursor exactly once")
        _expect(not bool(committed.get("barrier_failed", true)), "retry releases causal barrier")


func _test_automatic_completion_save_failure_retry() -> void:
    var boot := PlayerBootScene.instantiate()
    _expect_ok(boot.call("configure_player_boot", {"profile_base_dir": _base_dir, "test_mode": true}) as Dictionary, "configure automatic failure boot")
    add_child(boot)
    await get_tree().process_frame
    _expect_ok(boot.call("activate_lifecycle_action") as Dictionary, "continue automatic failure baseline")
    await get_tree().process_frame
    var runtime: Variant = boot.call("player_runtime")
    _expect(runtime != null, "automatic failure runtime exists")
    if runtime == null:
        return
    runtime.set_process(false)
    _expect_ok(boot.call("configure_test_store_failpoint", "before_validation") as Dictionary, "inject automatic completion save failure")
    var failed := runtime.call("test_advance_player_to_next_checkpoint_expecting_persistence_failure", 5000) as Dictionary
    _expect_expected_checkpoint_persistence_failure(failed, 8, "automatic completion")
    var blocked := runtime.call("player_checkpoint_snapshot") as Dictionary
    _expect(int(blocked.get("checkpoint_sequence", 0)) == 8, "automatic completion failure rolls back to durable cursor")
    _expect(bool(blocked.get("barrier_failed", false)), "automatic completion failure holds barrier")
    _expect_ok(boot.call("clear_test_store_failpoint") as Dictionary, "clear automatic completion failure")
    _expect_ok(runtime.call("retry_player_checkpoint_commit") as Dictionary, "explicit retry automatic completion")
    var committed := runtime.call("player_checkpoint_snapshot") as Dictionary
    _expect(int(committed.get("checkpoint_sequence", 0)) == 9, "automatic completion retry commits exact next cursor")
    var exported := runtime.call("export_player_safe_checkpoint") as Dictionary
    _expect_ok(exported, "automatic completion retry exports durable checkpoint")
    if bool(exported.get("ok", false)):
        _expect((exported["checkpoint"] as Dictionary) == _codec.build_golden_checkpoint(_codec.kind_for_sequence(9)), "automatic completion retry equals exact next golden checkpoint")


func _author_failed_barrier_snapshot(sequence: int) -> void:
    var boot := PlayerBootScene.instantiate()
    _expect_ok(boot.call("configure_player_boot", {"profile_base_dir": _base_dir, "test_mode": true}) as Dictionary, "configure failed barrier boot")
    add_child(boot)
    await get_tree().process_frame
    if sequence == 17:
        _expect_ok(boot.call("configure_test_store_failpoint", "before_validation") as Dictionary, "inject authored transition save failure")
    var activation := boot.call("activate_lifecycle_action") as Dictionary
    _expect_ok(activation, "continue failed barrier baseline")
    await get_tree().process_frame
    var runtime: Variant = boot.call("player_runtime")
    _expect(runtime != null, "failed barrier runtime exists")
    if runtime == null:
        return
    runtime.set_process(false)
    _expect(int((runtime.call("player_checkpoint_snapshot") as Dictionary).get("checkpoint_sequence", 0)) == sequence, "failed barrier starts at requested cursor")
    if sequence != 17:
        _expect_ok(boot.call("configure_test_store_failpoint", "before_validation") as Dictionary, "inject authored player gate save failure")
        var failed := runtime.call("test_advance_player_to_next_checkpoint_expecting_persistence_failure", 5000) as Dictionary
        _expect_expected_checkpoint_persistence_failure(failed, sequence, "authored player gate snapshot")
    var blocked := runtime.call("player_checkpoint_snapshot") as Dictionary
    _expect(int(blocked.get("checkpoint_sequence", 0)) == sequence, "failed player gate keeps previous durable cursor")
    _expect(bool(blocked.get("barrier_failed", false)), "failed player gate holds causal barrier")
    _expect((blocked.get("pending_intents", []) as Array).is_empty(), "failed player gate starts no unacknowledged automatic task")


func _author_completion_beat_snapshot() -> void:
    var boot := PlayerBootScene.instantiate()
    _expect_ok(boot.call("configure_player_boot", {"profile_base_dir": _base_dir, "test_mode": true}) as Dictionary, "configure completion-beat boot")
    add_child(boot)
    await get_tree().process_frame
    _expect_ok(boot.call("activate_lifecycle_action") as Dictionary, "continue sequence 32 completion beat")
    var runtime: Variant = boot.call("player_runtime")
    _expect(runtime != null, "completion-beat runtime exists")
    if runtime == null:
        return
    runtime.set_process(false)
    var snapshot := runtime.call("player_checkpoint_snapshot") as Dictionary
    _expect(int(snapshot.get("checkpoint_sequence", 0)) == 32, "completion beat starts from durable sequence 32")
    _expect(bool(snapshot.get("completion_beat_active", false)), "completion beat is present in the authored process-boundary snapshot")


func _test_sequence_rules() -> void:
    var boot := PlayerBootScene.instantiate()
    _expect_ok(boot.call("configure_player_boot", {"profile_base_dir": _base_dir, "test_mode": true}) as Dictionary, "configure sequence-rules boot")
    add_child(boot)
    await get_tree().process_frame
    _expect_ok(boot.call("activate_lifecycle_action") as Dictionary, "continue for sequence rules")
    await get_tree().process_frame
    var current := _codec.build_golden_checkpoint("first_day_inputs_in_kitchen")
    var idempotent := boot.call("_persist_runtime_checkpoint", current) as Dictionary
    _expect(str(idempotent.get("status", "")) == "idempotent_noop", "same sequence + digest is no-op")
    var lower := boot.call("_persist_runtime_checkpoint", _codec.build_golden_checkpoint("first_day_pumpkin_in_kitchen")) as Dictionary
    _expect(str(lower.get("error", "")) == "checkpoint_sequence_regression", "lower sequence rejected")
    var jump := boot.call("_persist_runtime_checkpoint", _codec.build_golden_checkpoint("first_day_food_mix_at_packing")) as Dictionary
    _expect(str(jump.get("error", "")) == "checkpoint_sequence_jump", "sequence jump rejected")
    var conflict := current.duplicate(true)
    (((conflict["resources"] as Dictionary)["storage"] as Dictionary))["protein_packet"] = 2
    var conflict_result := boot.call("_persist_runtime_checkpoint", conflict) as Dictionary
    _expect(str(conflict_result.get("error", "")) == "checkpoint_contract_invalid", "same-sequence payload conflict rejected before store")


func _test_retry_cursor(sequence: int) -> void:
    var boot := PlayerBootScene.instantiate()
    _expect_ok(boot.call("configure_player_boot", {"profile_base_dir": _base_dir, "test_mode": true}) as Dictionary, "configure retry cursor boot")
    add_child(boot)
    await get_tree().process_frame
    if sequence == 17:
        _expect_ok(boot.call("configure_test_store_failpoint", "before_validation") as Dictionary, "inject authored transition retry failure")
    _expect_ok(boot.call("activate_lifecycle_action") as Dictionary, "activate retry cursor lifecycle")
    await get_tree().process_frame
    var runtime: Variant = boot.call("player_runtime")
    _expect(runtime != null, "retry cursor runtime exists")
    if runtime == null:
        return
    runtime.set_process(false)
    if sequence != 17:
        _expect_ok(boot.call("configure_test_store_failpoint", "before_validation") as Dictionary, "inject authored retry cursor failure")
        var failed := runtime.call("test_advance_player_to_next_checkpoint_expecting_persistence_failure", 5000) as Dictionary
        _expect_expected_checkpoint_persistence_failure(failed, sequence, "retry cursor")
    _expect(bool((runtime.call("player_checkpoint_snapshot") as Dictionary).get("barrier_failed", false)), "retry cursor barrier is held")
    _expect_ok(boot.call("clear_test_store_failpoint") as Dictionary, "clear retry cursor failpoint")
    _expect_ok(runtime.call("retry_player_checkpoint_commit") as Dictionary, "explicit retry persists staged cursor")
    var expected_next := sequence + 1
    _expect(int((runtime.call("player_checkpoint_snapshot") as Dictionary).get("checkpoint_sequence", 0)) == expected_next, "retry commits exact next cursor")
    var exported := runtime.call("export_player_safe_checkpoint") as Dictionary
    _expect_ok(exported, "retry cursor exports durable checkpoint")
    if bool(exported.get("ok", false)):
        _expect((exported["checkpoint"] as Dictionary) == _codec.build_golden_checkpoint(_codec.kind_for_sequence(expected_next)), "retry cursor equals exact next golden checkpoint")
    var event_types: Array[String] = []
    for event in runtime.call("test_player_event_snapshots") as Array:
        event_types.append(str((event as Dictionary).get("type", "")))
    var required_event := {
        17: "day2_return_moment_seen",
        18: "player_confirmed_trip",
        30: "player_confirmed_delivery",
        31: "day2_progress_note_revealed",
        32: "day2_curiosity_question_revealed",
    }.get(sequence, "") as String
    if required_event != "":
        _expect(required_event in event_types, "retry emits required post-ACK event: %s" % required_event)
    if sequence == 18:
        _expect("trip_task_created" in event_types, "route retry emits TripTask creation")
    if sequence == 30:
        _expect("delivery_task_created" in event_types, "dispatch retry emits DeliveryTask creation")
    if sequence == 31:
        _expect_ok(runtime.call("test_advance_player_to_next_checkpoint", 5000) as Dictionary, "delivery-response retry restarts completion beat")
        _expect(int((runtime.call("player_checkpoint_snapshot") as Dictionary).get("checkpoint_sequence", 0)) == 33, "completion beat reaches Quiet Cooperative after retry")


func _expect_expected_checkpoint_persistence_failure(result: Dictionary, starting_sequence: int, label: String) -> void:
    var expected_sequence := starting_sequence + 1
    var expected_kind := _codec.kind_for_sequence(expected_sequence)
    var expected_golden := _codec.build_golden_checkpoint(expected_kind)
    var durable_kind := _codec.kind_for_sequence(starting_sequence)
    var durable_golden := _codec.build_golden_checkpoint(durable_kind)
    _expect(bool(result.get("ok", false)), "%s expected persistence failure is accepted only by the test seam" % label)
    _expect(str(result.get("status", "")) == "expected_checkpoint_persistence_failure_observed", "%s structured expected failure discriminator" % label)
    _expect(bool(result.get("test_only_exact_match", false)), "%s exact armed test-only match" % label)
    _expect(bool(result.get("expectation_cleared", false)), "%s one-shot expectation is cleared" % label)
    var transition_result := result.get("transition_result", {}) as Dictionary
    _expect(str(transition_result.get("error", "")) == "checkpoint_barrier_failed", "%s public transition stops at the failed persistence barrier" % label)
    var failure_result := result.get("failure_result", {}) as Dictionary
    _expect(str(failure_result.get("error", "")) == "checkpoint_persistence_failed", "%s exact outer persistence failure" % label)
    var store_result := failure_result.get("store_result", {}) as Dictionary
    _expect(str(store_result.get("error", "")) == "injected_failure:before_validation", "%s exact nested injected failure" % label)
    _expect(str(store_result.get("failpoint", "")) == "before_validation", "%s exact nested failpoint identity" % label)
    _expect(int(result.get("durable_checkpoint_sequence", -1)) == starting_sequence, "%s previous durable sequence is retained" % label)
    _expect(str(result.get("durable_checkpoint_kind", "")) == durable_kind, "%s previous durable kind is retained" % label)
    _expect((result.get("durable_checkpoint", {}) as Dictionary) == durable_golden, "%s previous durable checkpoint remains exact golden" % label)
    _expect(bool(result.get("barrier_failed", false)), "%s failed persistence barrier remains active" % label)
    _expect(int(result.get("staged_checkpoint_sequence", -1)) == expected_sequence, "%s staged sequence is exact next" % label)
    _expect(str(result.get("staged_checkpoint_kind", "")) == expected_kind, "%s staged kind is exact next" % label)
    _expect((result.get("staged_checkpoint", {}) as Dictionary) == expected_golden, "%s staged checkpoint is exact full next golden" % label)


func _setup_recovery_source(source: String) -> void:
    _expect_ok(_store_checkpoint(_codec.build_golden_checkpoint("first_day_ready_to_dispatch")), "store recovery baseline")
    var store := Store.new(_base_dir, true)
    var paths := store.paths()
    var target := str(paths["backup"] if source == "backup" else paths["temp"])
    var rename_error := DirAccess.rename_absolute(ProjectSettings.globalize_path(str(paths["primary"])), ProjectSettings.globalize_path(target))
    _expect(rename_error == OK, "move primary to %s recovery source" % source)


func _setup_checkpoint_invalid_recovery_source(source: String) -> void:
    var invalid := _codec.build_golden_checkpoint("first_day_ready_to_dispatch")
    (((invalid["resources"] as Dictionary)["storage"] as Dictionary))["protein_packet"] = 2
    _expect_ok(_store_checkpoint(invalid), "store envelope-valid checkpoint-invalid recovery candidate")
    var paths := Store.new(_base_dir, true).paths()
    var target := str(paths["backup"] if source == "backup" else paths["temp"])
    var rename_error := DirAccess.rename_absolute(ProjectSettings.globalize_path(str(paths["primary"])), ProjectSettings.globalize_path(target))
    _expect(rename_error == OK, "move invalid checkpoint to %s" % source)


func _setup_corrupt_no_selectable_profile() -> void:
    var paths := Store.new(_base_dir, true).paths()
    DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(_base_dir))
    for source in ["primary", "backup", "temp"]:
        var file := FileAccess.open(str(paths[source]), FileAccess.WRITE)
        _expect(file != null, "open corrupt %s candidate" % source)
        if file != null:
            file.store_string("{not-json-%s" % source)
            file.close()


func _assert_recovery_action(source: String) -> void:
    var boot := PlayerBootScene.instantiate()
    _expect_ok(boot.call("configure_player_boot", {"profile_base_dir": _base_dir, "test_mode": true}) as Dictionary, "configure %s recovery boot" % source)
    add_child(boot)
    await get_tree().process_frame
    var paths := Store.new(_base_dir, true).paths()
    _expect(not FileAccess.file_exists(str(paths["primary"])), "inspection does not promote %s" % source)
    var lifecycle := boot.call("lifecycle_snapshot") as Dictionary
    _expect(str(lifecycle.get("button_text", "")) == "Восстановить и продолжить", "exact recovery action copy")
    _expect(not bool(lifecycle.get("runtime_exists", true)), "recovery waits for explicit action")
    _expect_ok(boot.call("activate_lifecycle_action") as Dictionary, "explicit recovery succeeds")
    await get_tree().process_frame
    _expect(FileAccess.file_exists(str(paths["primary"])), "explicit recovery promotes primary")
    _expect(boot.call("player_runtime") != null, "recovery starts one runtime after revalidation")


func _assert_recovery_cancellation(source: String) -> void:
    var boot := PlayerBootScene.instantiate()
    _expect_ok(boot.call("configure_player_boot", {"profile_base_dir": _base_dir, "test_mode": true}) as Dictionary, "configure %s cancellation boot" % source)
    add_child(boot)
    await get_tree().process_frame
    var paths := Store.new(_base_dir, true).paths()
    var source_path := str(paths[source])
    var before := FileAccess.get_file_as_bytes(source_path)
    await get_tree().process_frame
    _expect(not FileAccess.file_exists(str(paths["primary"])), "cancelled recovery does not promote primary")
    _expect(FileAccess.file_exists(source_path), "cancelled recovery preserves source")
    _expect(FileAccess.get_file_as_bytes(source_path) == before, "cancelled recovery mutates no source bytes")
    _expect(boot.call("player_runtime") == null, "cancelled recovery starts no runtime")
    boot.queue_free()
    await get_tree().process_frame


func _assert_invalid_recovery_source(source: String) -> void:
    var boot := PlayerBootScene.instantiate()
    _expect_ok(boot.call("configure_player_boot", {"profile_base_dir": _base_dir, "test_mode": true}) as Dictionary, "configure invalid %s recovery boot" % source)
    add_child(boot)
    await get_tree().process_frame
    var state := boot.call("lifecycle_snapshot") as Dictionary
    _expect(str(state.get("copy", "")) == "Не удалось безопасно открыть сохранение. Оно осталось без изменений.", "checkpoint-invalid %s calm copy: %s" % [source, str(state)])
    _expect(str(state.get("action", "")) == "", "checkpoint-invalid %s offers no recovery action: %s" % [source, str(state)])
    _expect(not bool(state.get("runtime_exists", true)), "checkpoint-invalid %s starts no runtime" % source)


func _assert_corrupt_no_selectable_profile() -> void:
    var boot := PlayerBootScene.instantiate()
    _expect_ok(boot.call("configure_player_boot", {"profile_base_dir": _base_dir, "test_mode": true}) as Dictionary, "configure corrupt profile boot")
    add_child(boot)
    await get_tree().process_frame
    var state := boot.call("lifecycle_snapshot") as Dictionary
    _expect(str(state.get("copy", "")) == "Не удалось безопасно открыть сохранение. Оно осталось без изменений.", "all-corrupt candidates show calm copy")
    _expect(str(state.get("action", "")) == "", "all-corrupt candidates offer no fallback action")
    _expect(not bool(state.get("runtime_exists", true)), "all-corrupt candidates never start fresh")


func _store_checkpoint(checkpoint: Dictionary) -> Dictionary:
    var journey := checkpoint["journey"] as Dictionary
    var fields := {
        "format_id": Schema.FORMAT_ID,
        "schema_version": Schema.SCHEMA_VERSION,
        "content_build_version": "r48-continue-test",
        "profile_id": Schema.PROFILE_ID,
        "journey_phase": journey["phase"],
        "checkpoint_kind": journey["checkpoint_kind"],
        "checkpoint_sequence": journey["checkpoint_sequence"],
        "payload_format_id": Schema.PAYLOAD_FORMAT_ID,
        "payload_schema_version": Schema.PAYLOAD_SCHEMA_VERSION,
        "payload": checkpoint,
        "written_at_metadata": {"source": "system_utc_diagnostic_only", "iso8601_utc": "2026-07-12T00:00:00Z"},
    }
    return Store.new(_base_dir, true).store_profile(fields, Store.CREATE_AUTHORITY)


func _copy_file(source: String, target: String) -> void:
    var input := FileAccess.get_file_as_bytes(source)
    var output := FileAccess.open(target, FileAccess.WRITE)
    if output == null:
        _fail("copy target open failed")
        return
    output.store_buffer(input)
    output.flush()
    output.close()


func _read_args() -> void:
    for arg in OS.get_cmdline_user_args():
        if arg.begins_with("--continue-test-phase="):
            _phase = arg.trim_prefix("--continue-test-phase=")
        elif arg.begins_with("--continue-test-base="):
            _base_dir = arg.trim_prefix("--continue-test-base=").trim_suffix("/")
        elif arg.begins_with("--continue-test-sequence="):
            _target_sequence = arg.trim_prefix("--continue-test-sequence=").to_int()


func _safe_test_root() -> bool:
    if not _base_dir.begins_with(Store.TEST_BASE_PREFIX):
        return false
    var base := ProjectSettings.globalize_path(_base_dir).simplify_path()
    var production := ProjectSettings.globalize_path(Store.PRODUCTION_BASE_DIR).simplify_path()
    return base != production and not base.begins_with(production + "/")


func _clean_base() -> void:
    var absolute := ProjectSettings.globalize_path(_base_dir)
    if DirAccess.dir_exists_absolute(absolute):
        _remove_tree(absolute)


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


func _expect_ok(result: Dictionary, message: String) -> void:
    _expect(bool(result.get("ok", false)), "%s: %s" % [message, str(result)])


func _expect(condition: bool, message: String) -> void:
    if not condition:
        _fail(message)


func _fail(message: String) -> void:
    _failures.append(message)


func _finish() -> void:
    if _failures.is_empty():
        print("player_continue_test=passed phase=%s sequence=%d" % [_phase, _target_sequence])
        get_tree().quit(0)
    else:
        for failure in _failures:
            push_error(failure)
        print("player_continue_test=failed phase=%s count=%d" % [_phase, _failures.size()])
        get_tree().quit(1)
