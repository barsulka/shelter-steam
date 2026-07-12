# STEAM_DESKTOP — Codex Brief — Runtime Safe Checkpoints And Continue v1

Дата: 2026-07-12

Статус: completed / PASS

Роль-владелец постановки: Producer / Game Designer / Project Manager

Roadmap task: R48-02B

Decision: D-023

Architecture: ADR-0002 / ADR-0003

Рекомендуемый уровень рассуждений Codex: **очень высокий**

---

## 0. Цель

Подключить завершённый `PlayerProfileEnvelopeV1` store к единственному существующему Godot runtime и впервые сделать обычный player-facing `Continue` рабочим:

```text
fresh ordinary launch
→ one First Day runtime
→ semantic safe checkpoints autosave
→ process closes during a gate or automatic task
→ ordinary relaunch
→ Continue / explicit recovery when available
→ the same causal First Day resumes from the last committed checkpoint
```

Эта wave:

- определяет и реализует строгий `PlayerCheckpointV1`;
- подключает runtime checkpoint export/import без использования dev snapshot schema;
- сохраняет только semantic safe checkpoints, не exact in-flight state;
- связывает PlayerBoot, PlayerProfileStore и один Vertical Slice runtime;
- закрывает joint R48-01 + R48-02 technical Continue gate для First Day checkpoints;
- приводит fresh First Day reserve к принятому D-023 `Protein Packet x2` / `Packaging Bag x2`.
- устраняет текущий отдельный player reward-claim click: First Day delivery response сразу делает тапочки доступными, а единственным post-delivery gameplay confirmation остаётся `Надеть тапочки`.

Эта wave **не** создаёт Day 2. Если загружен fully-complete First Day checkpoint, R48-02B восстанавливает спокойный First Day complete hold. Это честное промежуточное technical behavior, а не принятый D-023 first-return journey: одноразовый persisted First Day → Day 2 transition и полное ordinary-return closure остаются отдельной R48-03 wave.

---

## 1. Обязательные источники

### Rules / role / current state

```text
PROJECTS_RULES.md
AGENTS.md
README.md
steam/AGENTS.md
steam/README.md
docs/drive/Shelter/00_START_HERE/000_ROLE_CODEX.md
docs/drive/Shelter/00_START_HERE/05_DOCUMENTATION_GOVERNANCE.md
docs/repo/status/CODEX_CURRENT_STATUS.md
docs/drive/Shelter/04_DEVELOPMENT/CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md
```

### Architecture

```text
docs/repo/adr/README.md
docs/repo/adr/0001-use-godot-for-steam-desktop.md
docs/repo/adr/0002-game-state-as-source-of-truth.md
docs/repo/adr/0003-player-profile-persistence-boundary-and-recovery.md
docs/repo/dev/player-profile-persistence.md
```

Read every other Accepted ADR relevant to runtime state, persistence, startup and process behavior.

### Product / game contract

```text
docs/drive/Shelter/00_START_HERE/02_DECISIONS.md                 # D-023; D-022 boundary
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__First_48_Hours_Playable_Scope_Lock_v1.md
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__First_48_Hours_Playable_Roadmap_v1.md
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__First_Day_MVP_v1.md
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Task_Flow_Contract_v1.md
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Object_Contract_v1.md
```

### Completed prerequisite briefs

```text
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Playable_Main_Scene_And_Launch_Surfaces_v1.md
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Player_Save_Store_Schema_And_Recovery_v1.md
```

### Existing implementation

Inspect current equivalents of:

```text
steam/project.godot
steam/scenes/player/player_boot.tscn
steam/scripts/player/player_boot.gd
steam/scenes/prototypes/vertical_slice/vertical_slice_demo.tscn
steam/scripts/prototypes/vertical_slice/vertical_slice_demo.gd
steam/scripts/persistence/player_profile_schema.gd
steam/scripts/persistence/player_profile_store.gd
steam/tests/launch_surfaces/**
steam/tests/persistence/**
steam/tools/test-player-profile-store.sh
steam/resources/game_systems/fixtures/first_day_empty_coop.json       # legacy x1/x1 task-causality oracle only; never checkpoint/reserve golden
steam/resources/game_systems/fixtures/second_day_after_first_delivery.json # D-022 regression oracle only
```

Fixtures and current dev portable state are evidence/archaeology inputs only. They MUST NOT be copied, loaded or normalized as a player checkpoint.

---

## 2. Accepted responsibility split

### 2.1 Vertical Slice runtime

The existing Vertical Slice runtime remains the only gameplay authority. It owns:

- task/resource/order/dog state and transitions;
- checkpoint eligibility after a complete runtime transaction;
- semantic `PlayerCheckpointV1` export;
- strict checkpoint import into one reset runtime;
- deterministic reconstruction of the next player gate or automatic task from a semantic cursor;
- checkpoint sequence advancement.
- a commit barrier that does not start the next task/gate transition until the current safe checkpoint receives a successful synchronous persistence acknowledgement.

It MUST NOT perform file I/O or inspect primary/backup/temp paths.

### 2.2 PlayerProfileStore

The completed R48-02A store remains limited to:

- envelope validation/integrity;
- exact `user://player/default/` paths;
- transactional storage;
- candidate inspection and explicit recovery.

It MUST NOT infer checkpoint fields, select a gameplay cursor, advance sequence, start Day 2 or call runtime task methods.

### 2.3 PlayerCheckpointCodec

Add one bounded codec/validator responsible only for the exact nested `PlayerCheckpointV1` allowlist, enums, bounds and cross-field invariants.

The codec:

- receives a semantic Dictionary emitted by runtime;
- validates/normalizes only integer-safe checkpoint data;
- validates the envelope mirror fields against the payload;
- reports `checkpoint_contract_valid` separately from `envelope_valid`;
- has no `_process`, file I/O, runtime task execution or wall-clock behavior.

It MUST NOT accept the current dev runtime `state`, task steps, floats or fixture payload as `PlayerCheckpointV1`.

### 2.4 PlayerBoot

PlayerBoot owns startup orchestration only:

- inspect envelope candidates;
- load the selected envelope read-only;
- validate its checkpoint through the codec;
- show the one bounded lifecycle action when Continue or recovery is available;
- instantiate exactly one Vertical Slice runtime;
- configure `fresh_session` or `continue` before child `_ready`;
- receive immutable safe-checkpoint signals and call the store;
- expose bounded startup/recovery errors without silently starting fresh.

PlayerBoot MUST NOT contain task/resource/order logic and MUST NOT calculate a checkpoint by reading UI nodes.

No project-wide gameplay autoload is required. If implementation proposes an autoload instead of a boot-owned RefCounted store/codec, stop for Technical review because that changes lifetime/authority beyond the minimum shape.

---

## 3. PlayerCheckpointV1 exact contract

### 3.1 Identity and outer mirror

The envelope remains:

```text
format_id = shelter.player-profile-envelope
schema_version = 1
payload_format_id = shelter.player-checkpoint
payload_schema_version = 1
```

The nested payload exact top-level allowlist is:

```text
format_id
schema_version
journey
first_day_history
active_order
active_chain
day2
resources
world
```

Exact payload identity:

```text
format_id = shelter.player-checkpoint
schema_version = 1
```

Envelope/payload mirrors MUST match exactly:

```text
envelope.journey_phase == payload.journey.phase
envelope.checkpoint_kind == payload.journey.checkpoint_kind
envelope.checkpoint_sequence == payload.journey.checkpoint_sequence
```

Mismatch is `checkpoint_contract_invalid`; it is never repaired from either side.

### 3.2 Integer-only rule

Every payload number is an integer inside the ADR-0003 safe range. `PlayerCheckpointV1` contains no native float.

Forbidden examples:

```text
elapsed_seconds
step_time
timing_scale
dog x/y
transport x/y
animation progress
task step duration
wall-clock elapsed time
```

If a future checkpoint needs a fractional accepted semantic value, it uses an explicitly named fixed-point integer such as `*_milliseconds` or a separately versioned decimal string. This wave has no such field.

### 3.3 `journey`

Exact fields:

```text
phase
checkpoint_kind
checkpoint_sequence
workflow_cursor
active_day
```

Types/rules:

```text
phase: first_day | first_day_complete_hold
checkpoint_kind: one exact value from section 4
checkpoint_sequence: exact cursor ordinal from section 4, currently 1..17
workflow_cursor: exact cursor paired with checkpoint_kind
active_day: exact integer 1
```

R48-02B intentionally supports only First Day and First Day complete hold as playable phases. `day2`, D-022 completed proof and D-023 `quiet_cooperative` are not silently accepted through generic strings. R48-03 must extend the checkpoint contract deliberately before it writes a Day 2 profile. If that extension cannot remain compatible with payload schema v1, it must choose an explicit payload version/migration rather than weakening v1 validation.

### 3.4 `first_day_history`

Exact fields and meanings are the canonical D-023/D-022 history surface:

```text
order_id
delivery_confirmed
postcard_visible
reward_available
chain_complete
postcard_life_moment_seen
first_reward_equipped
first_memory_added
next_day_hint_available
dachshund
packing_note_visible
```

`dachshund` exact fields:

```text
slippers_equipped
memory_id
memory_text
```

Rules:

- `order_id` is exactly `order.first_warm_delivery`;
- booleans are literal booleans;
- `memory_id` is `null` or exactly `memory.first_warm_delivery`;
- `memory_text` is empty or exactly `Помнит первую тёплую поставку`;
- a partial First Day checkpoint may contain false/empty history facts;
- `first_day_complete_hold` requires every canonical completed fact true and the exact memory values;
- history cannot claim equipped slippers while `world.slippers_equipped=false`.

For cursors 1..16, `first_day_history` is only a monotonic projection of already committed First Day facts. It never controls task execution and never substitutes for `active_order`, `active_chain`, resources or `workflow_cursor`. A fact may change only `false/empty → true/exact value`; it never becomes false again. Cursor 17 is the first fully complete history. The generic next-visit hint and Packing Table note become available only after slippers equip at cursor 17, not at delivery response. R48-03 later freezes/archives this completed history before creating a separate Day 2 active order/chain.

### 3.5 `active_order`

Exact fields:

```text
id
title
status
status_history
delivery_state
delivery_confirmed
completed
postcard_created
reward_created
equip_task_created
```

First Day constants:

```text
id = order.first_warm_delivery
title = Первая тёплая поставка
```

Allowed status values are only the actual accepted First Day path values needed by section 4:

```text
route_suggested
trip_active
resources_available
production_in_progress
packed
loaded
sent
completed
```

`status_history` is a nonempty ordered de-duplicated cursor-specific causal history using only those values. It MUST end with `status`; it cannot skip a required player gate or claim a later stage than `workflow_cursor`. The codec MUST define one exact expected status/history value for every section 4 cursor and MUST NOT infer or repair a history from current status alone.

Allowed delivery states:

```text
waiting_for_food_bag
ready_to_send
sending
delivered
```

### 3.6 `active_chain`

Exact fields:

```text
template_id
run_id
state
state_history
current_step
route_id
transport_id
```

Constants:

```text
template_id = chain.warm_food_delivery_intro
run_id = run.first_day.first_warm_delivery
route_id = route.oat_farm_intro
transport_id = transport.basket_bicycle
```

Allowed chain state/current-step pairs are a closed mapping derived from the First Day task flow and section 4. `state_history` is a nonempty ordered de-duplicated cursor-specific history ending at `state`.

The codec MUST reject unknown state/current-step combinations. It MUST NOT accept task step indices as a substitute for semantic chain state. Every section 4 cursor has one exact expected state/history/current-step triple; import does not synthesize a missing prefix.

### 3.7 `day2`

R48-02B keeps the exact Day 2 surface present so the player checkpoint shape does not borrow a dev fixture later, but every field MUST remain the canonical pre-Day2 value in this wave:

```text
return_moment_seen = false
yesterday_postcard_visible = false
dachshund_slippers_visible = false
dachshund_memory_inspectable = false
packing_note_visible = false
second_order_available = false
return_has_no_urgent_prompt = true
absence_penalty_applied = false
labrador_packing_care_moment_seen = false
second_delivery_completed = false
second_feedback_visible = false
curiosity_question_available = false
curiosity_is_optional_hint = false
quiet_end_state_reached = false
```

Any Day 2 true value in an R48-02B playable checkpoint is rejected. R48-03 owns the contract extension and transition.

### 3.8 `resources`

Exact fields:

```text
storage
transport_payload
kitchen
packing_table
delivery_van_endpoint
delivered
```

Each container has the same exact resource-key allowlist:

```text
oat_crate
pumpkin_crate
protein_packet
packaging_bag
food_mix
food_bag
```

Every value is an integer count. First Day bounds:

```text
oat_crate: 0..1
pumpkin_crate: 0..1
protein_packet: 0..2
packaging_bag: 0..2
food_mix: 0..1
food_bag: 0..1
```

Cross-field conservation is mandatory:

- fresh First Day begins with Protein Packet `2` and Packaging Bag `2` in Storage;
- the active First Day order consumes exactly one of each;
- one Protein Packet and one Packaging Bag remain in Storage after their First Day carry;
- Oat/Pumpkin enter only after the visible route payload and then move through `transport_payload` → Storage → Kitchen;
- `first_day_payload_returned` has Oat `1` and Pumpkin `1` in `transport_payload`;
- `first_day_oat_stored` has Oat `1` in Storage and Pumpkin `1` in `transport_payload`;
- `first_day_resources_available` has both in Storage, empty `transport_payload` and `world.transport_has_payload=false`;
- Food Mix exists only after CookTask completion and is consumed by PackTask;
- Food Bag exists only after PackTask completion, then moves to Van, then delivered;
- the sum for each tracked resource must match the exact cursor template; arbitrary count combinations are invalid.

The runtime may use stack or instance-level presentation internally, but the checkpoint stores semantic counts only. If representing the accepted `x2 → x1` reserve visibly requires a narrow token-instance/stack correction, that correction may occur only inside the existing Vertical Slice presentation/state adapter and must preserve Object Contract ownership. The save must not encode UI token IDs.

Legacy inventory dictionaries are not copied blindly. The wave MUST make their semantic consumption honest inside the existing runtime, or export/import through exact cursor templates while maintaining immediate semantic round-trip. Preferred narrow alignment:

- pickup from Storage/Kitchen/Packing decrements the actual semantic source container;
- CookTask completion consumes Oat, Pumpkin and one Protein Packet and creates Food Mix x1 in Kitchen;
- PackTask completion consumes Food Mix and one Packaging Bag and creates Food Bag x1 at Packing Table;
- LoadVanTask moves Food Bag from Packing Table to Van;
- DeliveryTask moves it from Van to delivered;
- hidden legacy tokens or stale input dictionaries cannot be counted as present resources.

If these conservation fixes break accepted task/object causality or cannot preserve existing D-022 regression, stop rather than allowing codec/export to report invented counts.

The actual runtime must also clear its transport-payload semantic flag only after the second visible UnloadTask commits. The current legacy `_transport_has_payload` value may not remain true after `transport_payload` reaches zero.

### 3.9 `world`

Exact fields:

```text
route_started
route_payload_returned
transport_state
transport_has_payload
van_loaded
delivery_confirmed
delivery_complete
postcard_visible
reward_available
slippers_equip_requested
slippers_equipped
```

Allowed `transport_state`:

```text
parked
waiting_for_unload
```

`route_payload_returned` is the historical fact that the route visibly returned its accepted payload; it becomes true at cursor 3 and remains true. Current cargo presence is represented only by `resources.transport_payload` and `transport_has_payload`. `world` contains causal semantic facts only. It contains no position, current dog pose, timer, current task, queue or UI visibility. Every combination is cross-validated against `workflow_cursor`, resources, order, chain and history.

### 3.10 Explicitly forbidden checkpoint content

In addition to the ADR-0003 recursive dev-key denylist, `PlayerCheckpointV1` rejects at any depth:

```text
task_queue
current_task
current_step_index
step_time
elapsed_seconds
timing_scale
next_task_number
event_log
events
next_event_number
dog_assignments
active_research
active_fixture_id
active_save_file
debug_speed_multiplier
runtime_start_fixture
runtime_load_local_save
connector/control/capture fields
arbitrary dog/transport coordinates
```

The player checkpoint is a semantic replay boundary, not the dev portable-state payload with some fields removed.

---

## 4. Exact safe checkpoint set

### 4.1 Commit rule

A checkpoint is eligible only after one runtime transaction is fully committed:

1. its durable state/resource/player-decision/reward side effects have happened exactly once;
2. any deterministic follow-up task intent has been derived;
3. the current task is empty; any live queued follow-up intents are already derived, but the checkpoint represents them only through the semantic cursor;
4. no step `on_start`/`on_complete` callback is executing;
5. the snapshot validates through `PlayerCheckpointV1` before it is emitted.

The runtime MUST NOT save from inside an operation before the operation and its cursor advancement are both committed.

### 4.2 First Day checkpoints

The only R48-02B safe checkpoint kinds/cursors are:

| Sequence meaning | `checkpoint_kind` / `workflow_cursor` | Resume behavior |
| --- | --- | --- |
| Fresh runtime ready | `first_day_offered` | wait indefinitely for trip confirmation |
| Trip decision committed | `first_day_route_confirmed` | reconstruct TripTask from its beginning; never ask for trip confirmation again |
| Trip complete, visible payload committed | `first_day_payload_returned` | reconstruct canonical Oat → Pumpkin UnloadTask intents |
| Oat unload complete | `first_day_oat_stored` | reconstruct remaining Pumpkin UnloadTask |
| Pumpkin unload complete / both resources available | `first_day_resources_available` | reconstruct canonical Oat → Pumpkin → Protein Storage → Kitchen CarryTask intents |
| Oat delivered to Kitchen | `first_day_oat_in_kitchen` | reconstruct remaining Pumpkin → Protein CarryTask intents |
| Pumpkin delivered to Kitchen | `first_day_pumpkin_in_kitchen` | reconstruct remaining Protein Packet CarryTask while preserving Storage remainder x1 |
| Protein Packet delivered to Kitchen | `first_day_inputs_in_kitchen` | reconstruct CookTask |
| Food Mix created | `first_day_food_mix_ready` | reconstruct canonical Food Mix → Packaging Bag CarryTask intents to Packing Table |
| Food Mix delivered to Packing Table | `first_day_food_mix_at_packing` | reconstruct remaining Packaging Bag CarryTask while preserving Storage remainder x1 |
| Packaging Bag delivered to Packing Table | `first_day_inputs_at_packing` | reconstruct PackTask |
| Food Bag created | `first_day_food_bag_ready` | reconstruct LoadVanTask |
| Food Bag visibly loaded | `first_day_ready_to_dispatch` | wait indefinitely for dispatch confirmation |
| Dispatch decision committed | `first_day_dispatch_confirmed` | reconstruct DeliveryTask from its beginning; never ask for dispatch confirmation again |
| Delivery complete / postcard + reward-ready response committed | `first_day_delivery_response` | wait for the single slippers-equip action; no delivery or reward-claim replay |
| Equip decision committed | `first_day_equip_confirmed` | reconstruct EquipItemTask; never ask for equip confirmation again |
| Equip task + all First Day facts committed | `first_day_complete` | restore calm First Day complete hold; do not create Day 2 in this wave |

The table order is normative and binds the exact sequence ordinal:

```text
1  first_day_offered
2  first_day_route_confirmed
3  first_day_payload_returned
4  first_day_oat_stored
5  first_day_resources_available
6  first_day_oat_in_kitchen
7  first_day_pumpkin_in_kitchen
8  first_day_inputs_in_kitchen
9  first_day_food_mix_ready
10 first_day_food_mix_at_packing
11 first_day_inputs_at_packing
12 first_day_food_bag_ready
13 first_day_ready_to_dispatch
14 first_day_dispatch_confirmed
15 first_day_delivery_response
16 first_day_equip_confirmed
17 first_day_complete
```

The codec rejects an otherwise valid cursor with any other sequence, including forged `first_day_offered/999`, skipped ordinals and cursor/sequence reordering. Idempotent retry/recovery preserves the same ordinal. R48-03 must deliberately extend or version this ordinal graph; it cannot append guessed Day 2 values in this wave.

There is no player checkpoint between a separate reward claim and slippers readiness. In the ordinary player path, First Day DeliveryTask completion atomically commits Postcard/life moment, creates/makes Comfortable Slippers available and presents `Надеть тапочки`. The old `Получить тапочки` click MUST NOT remain a required or visible player progression action. A dev/capture compatibility helper may remain only if it cannot appear in player mode or create a fourth player decision. R48-04B still owns final onboarding copy/cue polish, not the already accepted `3 + 2` input count.

### 4.3 Not safe checkpoints

Never emit a new checkpoint for:

- task movement or animation progress;
- transport/dog position;
- a partial pickup/carry/place step;
- a step callback before its resource mutation completes;
- focus/minimize notifications;
- periodic wall-clock intervals;
- connector snapshot/export;
- UI inspection, Postcard/Dog Card viewing or the optional question;
- dev speed/fixture/control changes.

### 4.4 Bounded replay guarantee

If the process closes during an automatic task, Continue restores the immediately preceding cursor and reconstructs that one interrupted task from its beginning plus only the still-untouched deterministic follow-up intents for the cursor. It MUST NOT replay a player confirmation or an already completed task.

This is the maximum replay boundary for R48-02B. Replaying the entire route-to-van chain from `first_day_route_confirmed` after a late crash is not acceptable.

---

## 5. Runtime export/import contract

### 5.1 Public API shape

The existing Vertical Slice runtime gains a narrow player API equivalent to:

```text
configure_player_session({
  startup_intent: "fresh_session" | "continue",
  checkpoint: <validated PlayerCheckpointV1 or absent for fresh>,
  checkpoint_commit_sink: <player-only synchronous Callable>
})

export_player_safe_checkpoint() -> Dictionary
import_player_safe_checkpoint(checkpoint: Dictionary) -> Dictionary
retry_player_checkpoint_commit() -> Dictionary
```

Exact method names may follow current conventions, but responsibilities and ordering are mandatory.

The injected commit sink is a narrow acknowledgement boundary, not filesystem ownership inside gameplay. It receives one immutable validated checkpoint and returns a bounded result synchronously. Runtime never sees profile paths/candidates; PlayerBoot never edits gameplay fields.

### 5.2 Fresh initialization

Fresh player initialization MUST:

- reset one existing runtime;
- create `Protein Packet x2` and `Packaging Bag x2` semantic inventory;
- create no Oat/Pumpkin/Food Mix/Food Bag;
- create no profile by loading `first_day_empty_coop` fixture;
- enter `first_day_offered`;
- emit sequence `1` only after the complete fresh state validates;
- keep `Начать поездку` disabled/behind the commit barrier until sequence `1` is durably acknowledged;
- never read OS dev arguments in player mode.

### 5.3 Import ordering

Continue configuration occurs before child `_ready` exactly like R48-01A player configuration.

The runtime MUST:

1. receive an already envelope-valid and checkpoint-valid immutable Dictionary;
2. independently validate the checkpoint at its public import boundary;
3. reset to a known clean player runtime;
4. apply semantic facts/resources/history/order/chain/world;
5. reconstruct deterministic tokens/presentation from semantic counts;
6. reconstruct the exact deterministic pending task intents for `workflow_cursor`, or wait at the player gate; no task step/progress is imported;
7. set the runtime sequence to the imported sequence;
8. enter the tree and start ticking only after import succeeds.

Import failure MUST leave no partially running gameplay child. PlayerBoot shows a bounded failure state and never falls back to fresh automatically.

### 5.4 Import does not replay history

Import MUST NOT emit historical gameplay events such as:

```text
player_confirmed_trip
resource_added_to_storage
resource_delivered_to_kitchen
food_mix_created
food_bag_created
player_confirmed_delivery
delivery_complete
reward_created
reward_equipped
```

Those facts are materialized from the checkpoint. A single observability event such as `player_checkpoint_restored` may be emitted after successful import, tagged as system/restore rather than gameplay causality.

Pending task intents are materialized through a silent reconstruction path, not the normal `_enqueue_task()` event path: their original `task_created` is historical and MUST NOT be re-emitted merely by import. Task IDs are process-local observability identifiers and are not persisted identity; reconstructed intents receive deterministic process-local IDs without becoming gameplay authority.

Every reconstructed intent preserves the original Task/Object contract, not a generic `resume` creator. Exact common fields are:

```text
type
resource_id            # exact resource or absent when task has none
source_object_id       # exact source or absent
target_object_id       # exact target or absent
order_id = order.first_warm_delivery
created_by
completion_event
status = queued
blocks_order_progress = true
```

Exact task templates:

| Type | Resource | Source → target | `created_by` | `completion_event` | Assignment |
| --- | --- | --- | --- | --- | --- |
| `TripTask` | absent | `road_sign → road_sign` | `object.road_sign` | `trip_returned_with_payload` | exact `dachshund_intro`; retain `route.oat_farm_intro` + `basket_bicycle` |
| `UnloadTask` | `oat_crate` or `pumpkin_crate` | `basket_bicycle → storage` | `TripTask` | `resource_added_to_storage` | existing scheduler |
| `CarryTask` | row-specific resource | row-specific `storage/kitchen → kitchen/packing_table` | `object.storage/object.kitchen/object.packing_table` | `resource_delivered` | existing scheduler |
| `CookTask` | absent | `kitchen → kitchen` | `object.kitchen` | `food_mix_created` | existing scheduler |
| `PackTask` | absent | `packing_table → packing_table` | `object.packing_table` | `food_bag_created` | existing scheduler |
| `LoadVanTask` | `food_bag` | `packing_table → delivery_van_endpoint` | `object.delivery_van_endpoint` | `van_loaded` | existing scheduler |
| `DeliveryTask` | absent | absent | `player_confirmed_delivery` | `delivery_complete` | no dog assignment |
| `EquipItemTask` | `equipment.comfortable_slippers` | `postcard_card → dachshund_intro` | `player_equips_reward` | `reward_equipped` | exact `dachshund_intro` |

Restoration does not create a new responsibility: Trip remains Road Sign/player-intent owned, physical resource tasks remain their existing objects/tasks, Delivery remains player-confirmed Van delivery, and Equip remains the accepted Dachshund reward flow. Apart from the exact Trip/Equip binding above, dog choice continues through the existing scheduler/Task Flow rules; the checkpoint codec does not persist or invent a new assignment system.

The current unconditional fresh `_ready()` `order_created` emission and fresh initial-checkpoint emission MUST be suppressed on Continue. Restoring an already existing active order materializes it silently; only a genuinely fresh profile emits the First Day order creation once.

New events occur only for work that actually runs after restore. Because safe-checkpoint restore replays one interrupted automatic task from its beginning, its transient start/pickup/presentation events — and a completion observability event emitted immediately before a crash but before durable cursor acknowledgement — MAY appear again in the new process. These transient events MUST NOT own gameplay effects, rewards or player decisions.

The exactly-once guarantee applies to durably committed semantic effects: player confirmations, resource location/count, order/chain progression, delivery completion, Postcard/reward/equip/history facts and cursor advancement. If a role requires globally exactly-once event delivery or stable event IDs across processes, R48-02B must stop for a separately accepted persisted-outbox/event-identity contract.

### 5.5 Idempotency

- importing the same checkpoint twice into two fresh runtime processes yields the same normalized semantic state and the same ordered reconstructed pending-task intents;
- import into an already started/in-tree runtime is rejected;
- exporting immediately after import yields the same checkpoint payload and sequence;
- the first new committed cursor advances sequence exactly by one;
- no resource, player decision, reward, history fact or order status is duplicated;
- no import path calls `load_fixture`, dev save import or connector control.

### 5.6 Persistence commit barrier

Every new safe cursor enters a checkpoint commit barrier before scheduler progression:

1. runtime stages the semantic transaction and constructs the next sequence checkpoint; the new cursor/player confirmation is not yet player-visible committed;
2. runtime blocks `_try_start_next_task`, new player-gate progression, success presentation/redraw and any further causal mutation;
3. runtime calls the injected checkpoint sink synchronously;
4. PlayerBoot validates sequence/payload and performs the store transaction;
5. only an `ok=true` acknowledgement changes the staged cursor into committed runtime truth, emits any committed player-confirmation receipt, updates its progression cue/presentation and releases the barrier;
6. failure leaves the runtime calmly paused at the staged cursor and exposes only a bounded save-error + explicit Retry/recovery action.

The previous committed scene may remain visible beneath the error, but the staged trip/dispatch/equip success cue or automatic-task completion presentation MUST NOT be shown before ACK. Retry is user-explicit or test-explicit; it is never a per-frame/timer loop. A successful retry of the same `(sequence, payload)` commits it and releases the barrier without incrementing sequence again.

If the sink remains failed and the player closes the app or the process crashes, the previous durable cursor is restored on next launch. The staged confirmation may therefore need to be given again, but the player was never shown it as successfully committed. Clean close cannot claim or synthesize success from the staged cursor.

This barrier is required so a later crash cannot fall back across several already-completed automatic tasks merely because their autosaves failed.

---

## 6. Checkpoint sequence and autosave

### 6.1 Sequence ownership

The runtime owns sequence semantics:

- fresh `first_day_offered` = `1`;
- each newly committed safe cursor increments by exactly one;
- non-safe state changes do not increment;
- imported sequence is preserved;
- next committed safe cursor is imported sequence + 1;
- sequence never derives from time, event count, task id or file contents.

Overflow at `9007199254740991` is fail-closed and requires a future schema decision.

### 6.2 Duplicate/reordered writes

PlayerBoot keeps the last successfully persisted `(sequence, checkpoint digest)` for the current runtime.

`checkpoint digest` is exactly lowercase SHA-256 of the ADR-0003 integer-subset canonical UTF-8 bytes of the nested `PlayerCheckpointV1` payload alone. It excludes envelope fields such as `written_at_metadata` and envelope `integrity`, so the same semantic checkpoint has the same digest across an idempotent retry.

Rules:

- higher sequence + valid next cursor → update profile;
- same sequence + byte-equivalent checkpoint payload → idempotent no-op, no file rewrite;
- same sequence + different payload → reject `checkpoint_sequence_conflict`;
- lower sequence → reject `checkpoint_sequence_regression`;
- jumping more than one sequence in one runtime session → reject and stop autosave;
- after process restart, comparison begins from the loaded primary/recovered envelope.

`written_at_metadata` may change only for an actual new persisted sequence and remains diagnostic-only.

`content_build_version` is copied from one nonempty internal application build-version setting or constant fixed by this implementation wave; it is never calculated from wall clock. If `application/config/version` is used, the brief allows adding the missing non-shipping internal value to `project.godot` inside the declared scope. Changing this metadata does not migrate or reinterpret a checkpoint.

### 6.3 Autosave triggers

Autosave is event-driven only:

- once for the validated fresh `first_day_offered` checkpoint;
- after every section 4 committed safe cursor;
- after explicit successful recovery before Continue starts, using the recovered stored envelope without rewriting its checkpoint;
- on clean close only when a previously emitted valid checkpoint is newer than the last successful store.

There is no periodic autosave timer, focus-return save, minimize save or wall-clock cadence.

A close notification MUST NOT export current in-flight state. If no new eligible checkpoint exists, it performs no gameplay snapshot write and lets the last-known-good checkpoint stand.

Store failure leaves the stable player scene responsive but causal runtime progression paused at the commit barrier. It surfaces a bounded non-secret persistence error and does not mutate runtime truth. It MUST NOT retry in a per-frame loop.

---

## 7. PlayerBoot lifecycle behavior

### 7.1 No profile candidates

If primary/backup/temp are all absent:

- start one fresh First Day runtime directly;
- create the profile only from the emitted validated `first_day_offered` checkpoint;
- expose no route progression action until that first profile write succeeds;
- do not count this startup as a gameplay confirmation;
- if first save fails, do not pretend a durable profile exists.

### 7.2 Valid primary

If the selected primary has a valid envelope and valid playable First Day checkpoint:

- for incomplete `phase=first_day`, show one calm lifecycle action: `Продолжить`;
- for `phase=first_day_complete_hold`, show `Вернуться в кооператив`, never `Продолжить`;
- do not instantiate/tick gameplay behind the choice;
- on action, configure one runtime with `startup_intent=continue` and the checkpoint before `_ready`;
- never start a second fresh runtime first.

R48-02B evidence names both cases `First Day checkpoint resume`. It MUST NOT call complete-hold reopening the ordinary D-023 Continue, because that exact first ordinary Continue belongs to R48-03 and creates Day 2.

### 7.3 Valid backup or temp

If R48-02A read-only precedence returns `backup_available` or `temp_available`:

- validate the selected checkpoint before offering recovery;
- show one calm `Восстановить и продолжить` lifecycle action;
- on action, call the exact explicit store recovery authority;
- re-inspect and reload the promoted primary;
- revalidate the checkpoint;
- only then instantiate one runtime.

No recovery mutation occurs merely because the application launched.

### 7.4 Invalid/incompatible profile

If the selected envelope is incompatible, its checkpoint contract is invalid, recovery candidate checkpoint is invalid, or no candidate is safely selectable:

- do not start fresh silently;
- do not overwrite/quarantine/delete automatically;
- show a bounded calm error/status surface;
- keep raw paths, profile contents, local URLs and tokens out of player copy/logs;
- leave destructive reset/migration UI outside this wave.

An envelope-valid primary with a checkpoint-invalid payload remains terminal for automatic startup. PlayerBoot MUST NOT bypass it with backup because R48-02A envelope precedence selected the primary.

Exact calm lifecycle/error copy:

```text
Save failure:
Не удалось сохранить. Мир остановлен на безопасном месте.
Action: Повторить сохранение

Invalid/corrupt checkpoint:
Не удалось безопасно открыть сохранение. Оно осталось без изменений.

Future/incompatible profile:
Эта версия игры не может безопасно открыть сохранение. Оно осталось без изменений.
```

At most one lifecycle/recovery/error action is pending at a time. Repeated activation while that action is staged/in progress is ignored. It does not pulse, expire, auto-retry or imply urgency. `Продолжить`, `Вернуться в кооператив`, `Восстановить и продолжить` and `Повторить сохранение` are application lifecycle/recovery actions outside the exact First Day three-confirmation gameplay budget.

### 7.5 New Game protection

R48-02B does not need to expose a destructive New Game action when a profile exists.

Mandatory rule:

- no startup path calls `store_profile(..., create_profile)` over a valid/recoverable/incompatible profile;
- no New Game action silently deletes or replaces primary/backup/temp;
- if a New Game affordance is shown, it may only return `confirmation_required` without mutation in this wave;
- actual destructive reset and final confirmation copy require a separately accepted bounded UI/store contract.

This satisfies D-023 protection without inventing irreversible UI.

### 7.6 R48-03 boundary

`Вернуться в кооператив` restores `first_day_complete` as `first_day_complete_hold` and remains there. It MUST NOT:

- load `second_day_after_first_delivery`;
- create the second order/chain;
- mutate Protein/Packaging remainder;
- emit Day 2 return events;
- use elapsed closed-app time as a trigger.

R48-03 later replaces this one startup branch with the accepted idempotent transition and immediate persisted Day 2 checkpoint.

---

## 8. Explicit out of scope

- First Day → Day 2 transition;
- loading any fixture from player path;
- Day 2 checkpoint production or Quiet Cooperative archival transition;
- exact in-flight task/timer/position resume;
- wall-clock/calendar/offline simulation;
- background/minimize policy changes;
- onboarding copy/layout/cue polish beyond removing the forbidden separate reward-claim progression click;
- production dog animation, authored world or Kitchen room;
- new order/resource/task/reward/route/station;
- multiple profiles, cloud/Steam save, encryption or anti-cheat;
- migration from dev `.runtime` saves;
- generic save UI, settings UI or destructive reset UI;
- connector/MCP persistence endpoints;
- security/tooling refactor unrelated to the player journey.

---

## 9. Expected implementation shape

Preferred narrow split:

```text
PlayerBoot
  candidate inspection + lifecycle choice + autosave orchestration
  owns store/codec instances, not gameplay

PlayerCheckpointCodec
  exact nested schema + cross-field validation
  no filesystem, UI or simulation

VerticalSliceDemo
  single runtime authority
  safe-cursor commit/export/import/reconstruction

PlayerProfileStore
  existing envelope/transaction/recovery foundation
  no gameplay interpretation
```

Do not add a second save-aware simulation, a duplicate First Day scene or a fixture-backed Continue route.

Process tests MAY inject a `PlayerProfileStore`/base-directory dependency into PlayerBoot only through a pre-tree programmatic configuration seam or a dedicated test scene. Injection MUST occur before `_ready`, use a strict `user://player-tests/<run-id>/` descendant and never be accepted from `play.sh`, OS player CLI arguments, connector/control or environment-derived fixture semantics.

---

## 10. Exact initial write scope

Before writing, inspect `git status`, preserve all concurrent changes and declare ownership to the coordinating session.

Allowed implementation scope:

```text
steam/scenes/player/player_boot.tscn
steam/scripts/player/player_boot.gd
steam/scripts/player/player_checkpoint_codec.gd               # new
steam/scripts/player/*.gd.uid                                  # generated sidecar if Godot creates it
steam/scripts/prototypes/vertical_slice/vertical_slice_demo.gd
steam/scripts/persistence/player_profile_store.gd              # only bounded integration/result helpers if proven necessary
steam/scripts/persistence/player_profile_schema.gd             # only checkpoint-valid/playable result plumbing; no envelope rule change
steam/project.godot                                            # only if a required non-gameplay boot setting cannot live in PlayerBoot; no autoload by default
steam/tests/player_checkpoints/**                              # new
steam/tests/player_continue/**                                 # new
steam/tests/launch_surfaces/run.sh                             # bounded isolated-store regression correction
steam/tests/launch_surfaces/test_player_boot.gd                # bounded pre-tree store injection for tests
steam/tools/test-player-checkpoints.sh                         # optional thin runner
steam/tools/test-player-continue.sh                            # optional thin runner
steam/tools/check-godot.sh                                    # replace unsafe default-main persistence smoke with isolated runner
steam/README.md
docs/repo/dev/player-profile-persistence.md
docs/repo/status/CODEX_CURRENT_STATUS.md
docs/repo/status/CODEX_STATUS.md
docs/drive/Shelter/04_DEVELOPMENT/CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md
```

Explicitly excluded:

```text
steam/resources/game_systems/fixtures/**
steam/scripts/game_systems/game_systems_runtime.gd
steam/scripts/dev_tools/**
steam/play.sh
steam/dev.sh
steam/launch.sh
steam/tools/dev-vertical-slice.sh
steam/.runtime/**
.codex/config.toml
product/game/art contracts
ADR files
```

If implementation needs `game_systems_runtime.gd`, fixture edits, an autoload or an envelope-schema change, stop and return the exact reason before expanding scope.

The starting `x2/x2` and semantic token/stack correction, if needed, are owned only by `vertical_slice_demo.gd`; do not mutate the D-022 `x1/x1` Day 2 fixture.

---

## 11. Acceptance criteria

### Checkpoint schema

- [x] Exact `PlayerCheckpointV1` allowlists/enums/bounds/cross-field invariants are implemented.
- [x] Payload uses only integer-safe canonical data and contains no native float.
- [x] Envelope mirror fields and payload journey fields match exactly.
- [x] Dev portable state, task queue/current task, timers, positions, events and fixture metadata are rejected.
- [x] Invalid state/resource/history/order/chain combinations fail closed.

### Runtime authority and replay

- [x] Fresh player runtime begins with D-023 `Protein Packet x2` and `Packaging Bag x2` without loading a fixture.
- [x] First Day consumes one of each and preserves remainder x1/x1.
- [x] Oat/Pumpkin transport payload counts move through the exact visible UnloadTask sequence; the transport payload flag clears only after both are stored.
- [x] Delivery response makes slippers available atomically; player mode has no separate `Получить тапочки` progression click, so First Day remains exactly trip + dispatch + equip.
- [x] Partial `first_day_history` is monotonic committed-fact projection only; next-visit hint/Packing note remain false until cursor 17.
- [x] Every section 4 cursor is emitted only after a complete transaction.
- [x] Restore reconstructs only the exact ordered pending-task intents for the cursor or a player gate.
- [x] Reconstructed intents retain exact type/resource/source/target/order/creator/completion fields and existing Task/Object/dog-assignment ownership.
- [x] A confirmed trip/dispatch/equip is never requested again after its checkpoint.
- [x] An already durable task/resource/player-decision/reward effect is never replayed; permitted transient observability replay cannot drive gameplay.
- [x] Import emits no fake historical gameplay causality.
- [x] Immediate export after import is semantically identical and keeps sequence.

### Autosave and Continue

- [x] Fresh startup creates the first profile only from `first_day_offered` checkpoint.
- [x] Fresh route action remains blocked until the initial profile checkpoint is durably acknowledged.
- [x] Incomplete First Day offers `Продолжить`; complete hold offers `Вернуться в кооператив`; both start exactly one runtime after the action.
- [x] Backup/temp recovery requires explicit action and revalidation before Continue.
- [x] Lifecycle/recovery/save-error surfaces use the exact calm copy, one pending action, no pulse/expiry/auto-retry and do not count toward the three gameplay confirmations.
- [x] Autosave occurs only on safe-cursor events, not periodically or on focus/minimize.
- [x] Close during every automatic task restores its preceding cursor, replays at most the interrupted task and preserves only untouched deterministic follow-ups.
- [x] Process restart at every player gate preserves the decision and waits correctly.
- [x] Same/lower/conflicting sequence writes are rejected or idempotent as section 6 requires.
- [x] Checkpoint conflict comparison uses the exact canonical nested-payload SHA-256, not timestamp/envelope bytes.
- [x] Every cursor is durably acknowledged before the scheduler advances to the next causal transaction.
- [x] Trip/dispatch/equip and automatic completion success presentation remains staged/invisible until persistence ACK; failed ACK shows only prior durable presentation plus save-error/Retry.
- [x] Storage failure pauses causal progression at the exact cursor, does not mutate runtime truth and creates no per-frame retry loop.

### Safety / isolation

- [x] Player path reads no fixtures, dev saves, `.runtime` or connector snapshots.
- [x] Fixture/control/debug/speed arguments remain isolated from player mode.
- [x] Closed-app duration changes no checkpoint or gameplay state.
- [x] Invalid/incompatible checkpoint never becomes silent fresh start.
- [x] New Game cannot overwrite a valid/recoverable/incompatible profile.
- [x] Tests never inspect, create or remove `user://player/default` except one explicit manual/internal acceptance profile under owner control.
- [x] Automated process tests inject only an isolated pre-tree test store/root and prove player CLI cannot select it.

### Scope boundary

- [x] `Вернуться в кооператив` restores fully complete First Day hold and does not claim ordinary D-023 Continue or create Day 2.
- [x] Existing First Day task/resource/order causality remains green.
- [x] D-022 Day 2 fixture/regression remains unchanged and green through dev route.
- [x] No new gameplay input, reward, route, task or offline/calendar behavior is introduced.

---

## 12. Required tests and evidence

### 12.1 Codec/schema tests

Cover:

- every exact safe cursor golden payload;
- every top-level/nested unknown field;
- wrong identity/version/mirror values;
- all forbidden floats/positions/timers/task/event/dev fields;
- integer bounds and wrong count types;
- resource conservation failures;
- invalid history/order/chain/day2 combinations;
- non-monotonic partial history and premature next-visit hint/Packing note;
- invalid status/state history prefixes;
- reconstructed intent field/creator/assignment drift;
- sequence zero, regression, jump and same-sequence conflict;
- deep-copy/immutability behavior.

### 12.2 Import/export tests

For every section 4 cursor:

1. construct the state naturally through the real runtime or a bounded internal test seam;
2. export and validate checkpoint;
3. start a fresh process/runtime with Continue import;
4. assert normalized state equality;
5. assert exact ordered pending-task intents or player gate;
6. advance through one next transaction;
7. assert sequence +1, no duplicated durable effects and only the explicitly permitted interrupted-task transient observability replay.

Do not satisfy this matrix by loading a fixture into player mode.

### 12.3 Process-restart matrix

Required cases:

- before trip confirmation;
- immediately after trip confirmation;
- forced termination during every Trip/Unload/Carry/Cook/Pack/LoadVan/Delivery/Equip task;
- ready-to-dispatch indefinite wait;
- immediately after dispatch confirmation;
- delivery response;
- immediately after equip confirmation;
- fully complete First Day hold;
- repeated incomplete-First-Day `Продолжить` without progress;
- repeated complete-hold `Вернуться в кооператив` without progress;
- exact lifecycle/recovery/error copy and one-action/no-auto-retry states;
- repeated close/reopen at the same gate.

For each case assert:

- expected selected profile source;
- exact sequence/cursor;
- no required player decision repeated after it was committed;
- at most one automatic task replayed;
- inventory/order/history/durable-event-effect invariants;
- no Day 2 transition;
- no closed-time effect.

### 12.4 Recovery/startup matrix

Integrate the completed R48-02A cases with checkpoint validity:

- valid primary + valid checkpoint;
- envelope-valid primary + invalid checkpoint;
- valid backup + valid checkpoint;
- valid backup + invalid checkpoint;
- valid temp + valid checkpoint;
- incompatible primary plus valid backup;
- no candidates;
- corrupt candidates with no selectable recovery;
- store failure after runtime checkpoint emission;
- explicit retry after store failure, proving no intermediate task/gate advanced;
- close/crash after failed staged trip/dispatch/equip, proving previous durable cursor restores and no unacknowledged success was presented;
- recovery action cancelled/no action.

Inspection must remain read-only until the explicit lifecycle action.

### 12.5 Existing regressions

At minimum run:

```text
steam/tests/launch_surfaces/run.sh
steam/tools/test-player-profile-store.sh
steam/tools/check-godot.sh
```

Additionally:

- new dedicated checkpoint/Continue runners;
- F5/`steam/play.sh` native first-start then restart/Continue proof;
- positive dev First Day and Day 2 fixture routes;
- negative player fixture/control/debug/speed leakage proof;
- real process restart, not only in-memory import twice;
- `git diff --check` and no-index whitespace checks for new files;
- proof that test roots are removed and evidence is ignored/untracked.

### 12.6 Evidence honesty

Evidence must state:

- exact Godot/build/OS;
- whether profile is isolated test or one explicit manual internal profile;
- selected source and sequence/cursor before/after restart;
- no claim of Day 2 continuation, Quiet Cooperative, production art or shipping readiness;
- no secrets, tokenized local URLs or raw corrupt profile contents.

---

## 13. Stop conditions

Stop before or during implementation if:

- any accepted safe cursor cannot be reconstructed without storing current task steps, timers or floats;
- the runtime cannot enforce a persistence acknowledgement barrier before starting the next causal transaction;
- one task completion cannot be made atomic with cursor advancement;
- import would need to replay a player confirmation or historical irreversible event;
- roles require globally exactly-once cross-process observability events without a separately accepted persisted outbox/event-identity contract;
- resource conservation cannot prove D-023 `x2/x2 → x1/x1` without changing Object/Task Flow semantics;
- a valid profile can be overwritten through fresh startup or New Game;
- PlayerBoot needs task/order/resource logic;
- PlayerProfileStore needs gameplay meaning or `_process`;
- player path must load a fixture/dev save/connector snapshot;
- exact in-flight resume, calendar or offline progression appears;
- the intermediate complete-hold reopening must be mislabeled ordinary D-023 Continue or create Day 2 to pass R48-02B tests;
- an envelope-valid but checkpoint-invalid primary would be silently bypassed;
- recovery mutates files before explicit user action;
- project-wide autoload or `game_systems_runtime.gd` becomes necessary without scope review;
- an unexpected concurrent edit appears in any owned file;
- the implementation requires a new enduring technical rule not covered by ADR-0002/0003.

Return the exact conflict to Technical/Producer/Game Design as appropriate. Do not weaken validation, enlarge replay or add guessed defaults.

---

## 14. Documentation/status closeout after implementation

After a successful implementation wave:

- update `steam/README.md` with fresh/Continue/recovery behavior and exact non-goals;
- update `docs/repo/dev/player-profile-persistence.md` with `PlayerCheckpointV1`, cursor table and restart semantics;
- update Codex current/detailed status and implementation current context;
- mark R48-02B completed only after the full process-restart matrix passes;
- mark the R48-01/R48-02 technical First Day Continue gate closed, while explicitly keeping D-023 ordinary first-return/Day 2 journey open until R48-03;
- make R48-03 the next brief/preflight task;
- do not claim organic Day 2, full two-session playable, Quiet Cooperative, Kitchen, living Labrador or production visuals.

Every status entry must list exact changed files, checks, evidence paths and remaining limitations.

---

## 15. Role preflight and implementation authorization

Role preflight completed / PASS on 2026-07-12:

1. **Technical/Codex — PASS:** all seventeen cursors have deterministic task-step-free reconstruction, integer-only payloads, exact resource templates and a persistence acknowledgement barrier.
2. **Game Designer — PASS:** the matrix preserves physical causality, exact `3` First Day inputs, reward/equip meaning, `x2/x2 → x1/x1` conservation and non-authoritative monotonic partial history.
3. **Producer — PASS:** lifecycle/recovery/error copy, complete-hold wording, no-obligation behavior, explicit recovery and withheld destructive New Game are accepted for this wave.
4. **Project Manager/root — PASS:** one sequential integrator owns the bounded implementation scope; root retains status/roadmap closeout ownership.

During implementation preflight, the existing launch/check runners were found to start PlayerBoot against the production `user://player/default` namespace. Scope was therefore narrowly expanded to the three test/tool files listed in section 10 so automated regression always injects an isolated store before tree entry and never creates a production profile. This does not authorize player CLI save flags or fixture semantics.

No new user choice is required. Implementation is authorized only inside section 10. It MUST NOT add Day 2 transition, exact in-flight resume, offline progression or destructive reset scope.

---

## 16. Normative First Day golden cursor matrix

This appendix is normative for preflight and implementation. It deliberately preserves the actual First Day metadata spine after only the accepted changes in this brief: D-023 reserve/conservation alignment, delivery-response reward readiness, semantic transport cleanup and persistence barrier.

It does **not** invent `route_selected` / First Day chain `trip_active` metadata. In the actual runtime, First Day chain remains `not_started/choose_route` after route confirmation and moves to `payload_returned/unload_to_storage` only when the payload exists. Changing that oddity is a separate Game Design/Technical metadata decision, not a checkpoint implementation choice.

Cursor 1 `active_order.status=route_suggested` plus chain C0 is a legacy compatibility presentation, not a route confirmation and not a separate order-accept action. Only cursor 2 together with `world.route_started=true` records the first required gameplay decision.

### 16.1 Common constants and notation

Every row uses:

```text
active_order.id = order.first_warm_delivery
active_order.title = Первая тёплая поставка
active_chain.template_id = chain.warm_food_delivery_intro
active_chain.run_id = run.first_day.first_warm_delivery
active_chain.route_id = route.oat_farm_intro
active_chain.transport_id = transport.basket_bicycle
active_day = 1
day2 = exact all-false/pre-Day2 surface from section 3.7
```

Order-history aliases are literal arrays:

```text
O0 = [route_suggested]
O1 = [route_suggested, trip_active]
O2 = [route_suggested, trip_active, resources_available]
O3 = [route_suggested, trip_active, resources_available, production_in_progress]
O4 = [route_suggested, trip_active, resources_available, production_in_progress, packed]
O5 = [route_suggested, trip_active, resources_available, production_in_progress, packed, loaded]
O6 = [route_suggested, trip_active, resources_available, production_in_progress, packed, loaded, sent]
O7 = [route_suggested, trip_active, resources_available, production_in_progress, packed, loaded, sent, completed]
```

Chain aliases are exact `(state, state_history, current_step)` triples:

```text
C0 = (not_started, [not_started], choose_route)
C1 = (payload_returned, [not_started, payload_returned], unload_to_storage)
C2 = (inputs_to_kitchen, [not_started, payload_returned, stored, inputs_to_kitchen], carry_ingredients_to_kitchen)
C3 = (moving_to_packing, [not_started, payload_returned, stored, inputs_to_kitchen, cooking, food_mix_ready, moving_to_packing], carry_inputs_to_packing)
C4 = (packing_ready, [not_started, payload_returned, stored, inputs_to_kitchen, cooking, food_mix_ready, moving_to_packing, packing_ready], packing_table_ready)
C5 = (food_bag_ready, [not_started, payload_returned, stored, inputs_to_kitchen, cooking, food_mix_ready, moving_to_packing, packing_ready, packing, food_bag_ready], load_food_bag_into_van)
C6 = (ready_to_dispatch, [not_started, payload_returned, stored, inputs_to_kitchen, cooking, food_mix_ready, moving_to_packing, packing_ready, packing, food_bag_ready, ready_to_dispatch], player_confirms_dispatch)
C7 = (dispatched, [not_started, payload_returned, stored, inputs_to_kitchen, cooking, food_mix_ready, moving_to_packing, packing_ready, packing, food_bag_ready, ready_to_dispatch, dispatched], delivery)
C8 = (completed, [not_started, payload_returned, stored, inputs_to_kitchen, cooking, food_mix_ready, moving_to_packing, packing_ready, packing, food_bag_ready, ready_to_dispatch, dispatched, completed], complete)
```

Order flag tuple is:

```text
OF = (delivery_state, delivery_confirmed, completed, postcard_created, reward_created, equip_task_created)
```

Exact order flag aliases:

```text
OF0 = (waiting_for_food_bag, false, false, false, false, false)
OF1 = (ready_to_send, false, false, false, false, false)
OF2 = (sending, true, false, false, false, false)
OF3 = (delivered, true, true, true, true, false)
OF4 = (delivered, true, true, true, true, true)
```

World tuple is:

```text
W = (route_started, route_payload_returned, transport_state, transport_has_payload,
     van_loaded, delivery_confirmed, delivery_complete, postcard_visible,
     reward_available, slippers_equip_requested, slippers_equipped)
```

Exact world aliases:

```text
W0 = (false, false, parked, false, false, false, false, false, false, false, false)
W1 = (true,  false, parked, false, false, false, false, false, false, false, false)
W2 = (true,  true,  waiting_for_unload, true,  false, false, false, false, false, false, false)
W3 = (true,  true,  parked, false, false, false, false, false, false, false, false)
W4 = (true,  true,  parked, false, true,  false, false, false, false, false, false)
W5 = (true,  true,  parked, false, true,  true,  false, false, false, false, false)
W6 = (true,  true,  parked, false, true,  true,  true,  true,  true,  false, false)
W7 = (true,  true,  parked, false, true,  true,  true,  true,  true,  true,  false)
W8 = (true,  true,  parked, false, true,  true,  true,  true,  true,  true,  true)
```

History aliases are complete exact surfaces:

```text
H0 = {
  order_id: order.first_warm_delivery,
  delivery_confirmed: false, postcard_visible: false, reward_available: false,
  chain_complete: false, postcard_life_moment_seen: false,
  first_reward_equipped: false, first_memory_added: false,
  next_day_hint_available: false,
  dachshund: {slippers_equipped: false, memory_id: null, memory_text: ""},
  packing_note_visible: false
}

H1 = {
  order_id: order.first_warm_delivery,
  delivery_confirmed: true, postcard_visible: true, reward_available: true,
  chain_complete: false, postcard_life_moment_seen: true,
  first_reward_equipped: false, first_memory_added: true,
  next_day_hint_available: false,
  dachshund: {
    slippers_equipped: false,
    memory_id: memory.first_warm_delivery,
    memory_text: "Помнит первую тёплую поставку"
  },
  packing_note_visible: false
}

H2 = {
  order_id: order.first_warm_delivery,
  delivery_confirmed: true, postcard_visible: true, reward_available: true,
  chain_complete: true, postcard_life_moment_seen: true,
  first_reward_equipped: true, first_memory_added: true,
  next_day_hint_available: true,
  dachshund: {
    slippers_equipped: true,
    memory_id: memory.first_warm_delivery,
    memory_text: "Помнит первую тёплую поставку"
  },
  packing_note_visible: true
}
```

Resource notation lists only nonzero values. All omitted allowed keys in all containers are exactly zero:

```text
S = resources.storage
T = resources.transport_payload
K = resources.kitchen
P = resources.packing_table
V = resources.delivery_van_endpoint
D = resources.delivered
```

Pending intents are ordered and reconstructed silently. `none:<gate>` means there is no task intent and runtime waits at that gate.

### 16.2 Literal matrix

| Seq | Phase / kind | Order `(status, history, flags)` | Chain | Nonzero resources | World | History | Silent ordered pending intents |
| ---: | --- | --- | --- | --- | --- | --- | --- |
| 1 | `first_day / first_day_offered` | `(route_suggested, O0, OF0)` | C0 | `S{protein_packet:2, packaging_bag:2}` | W0 | H0 | `none:trip_confirmation` |
| 2 | `first_day / first_day_route_confirmed` | `(trip_active, O1, OF0)` | C0 | `S{protein_packet:2, packaging_bag:2}` | W1 | H0 | `TripTask` |
| 3 | `first_day / first_day_payload_returned` | `(trip_active, O1, OF0)` | C1 | `T{oat_crate:1,pumpkin_crate:1}; S{protein_packet:2,packaging_bag:2}` | W2 | H0 | `UnloadTask(oat_crate) → UnloadTask(pumpkin_crate)` |
| 4 | `first_day / first_day_oat_stored` | `(trip_active, O1, OF0)` | C1 | `T{pumpkin_crate:1}; S{oat_crate:1,protein_packet:2,packaging_bag:2}` | W2 | H0 | `UnloadTask(pumpkin_crate)` |
| 5 | `first_day / first_day_resources_available` | `(resources_available, O2, OF0)` | C2 | `S{oat_crate:1,pumpkin_crate:1,protein_packet:2,packaging_bag:2}` | W3 | H0 | `CarryTask(oat_crate,S→K) → CarryTask(pumpkin_crate,S→K) → CarryTask(protein_packet,S→K)` |
| 6 | `first_day / first_day_oat_in_kitchen` | `(resources_available, O2, OF0)` | C2 | `K{oat_crate:1}; S{pumpkin_crate:1,protein_packet:2,packaging_bag:2}` | W3 | H0 | `CarryTask(pumpkin_crate,S→K) → CarryTask(protein_packet,S→K)` |
| 7 | `first_day / first_day_pumpkin_in_kitchen` | `(resources_available, O2, OF0)` | C2 | `K{oat_crate:1,pumpkin_crate:1}; S{protein_packet:2,packaging_bag:2}` | W3 | H0 | `CarryTask(protein_packet,S→K)` |
| 8 | `first_day / first_day_inputs_in_kitchen` | `(resources_available, O2, OF0)` | C2 | `K{oat_crate:1,pumpkin_crate:1,protein_packet:1}; S{protein_packet:1,packaging_bag:2}` | W3 | H0 | `CookTask` |
| 9 | `first_day / first_day_food_mix_ready` | `(production_in_progress, O3, OF0)` | C3 | `K{food_mix:1}; S{protein_packet:1,packaging_bag:2}` | W3 | H0 | `CarryTask(food_mix,K→P) → CarryTask(packaging_bag,S→P)` |
| 10 | `first_day / first_day_food_mix_at_packing` | `(production_in_progress, O3, OF0)` | C3 | `P{food_mix:1}; S{protein_packet:1,packaging_bag:2}` | W3 | H0 | `CarryTask(packaging_bag,S→P)` |
| 11 | `first_day / first_day_inputs_at_packing` | `(production_in_progress, O3, OF0)` | C4 | `P{food_mix:1,packaging_bag:1}; S{protein_packet:1,packaging_bag:1}` | W3 | H0 | `PackTask` |
| 12 | `first_day / first_day_food_bag_ready` | `(packed, O4, OF0)` | C5 | `P{food_bag:1}; S{protein_packet:1,packaging_bag:1}` | W3 | H0 | `LoadVanTask(food_bag,P→V)` |
| 13 | `first_day / first_day_ready_to_dispatch` | `(loaded, O5, OF1)` | C6 | `V{food_bag:1}; S{protein_packet:1,packaging_bag:1}` | W4 | H0 | `none:dispatch_confirmation` |
| 14 | `first_day / first_day_dispatch_confirmed` | `(sent, O6, OF2)` | C7 | `V{food_bag:1}; S{protein_packet:1,packaging_bag:1}` | W5 | H0 | `DeliveryTask` |
| 15 | `first_day / first_day_delivery_response` | `(completed, O7, OF3)` | C7 | `D{food_bag:1}; S{protein_packet:1,packaging_bag:1}` | W6 | H1 | `none:slippers_equip_confirmation` |
| 16 | `first_day / first_day_equip_confirmed` | `(completed, O7, OF4)` | C7 | `D{food_bag:1}; S{protein_packet:1,packaging_bag:1}` | W7 | H1 | `EquipItemTask(comfortable_slippers→dachshund)` |
| 17 | `first_day_complete_hold / first_day_complete` | `(completed, O7, OF4)` | C8 | `D{food_bag:1}; S{protein_packet:1,packaging_bag:1}` | W8 | H2 | `none:first_day_complete_hold` |

### 16.3 Matrix validation rule

For every row the codec MUST require the exact phase, ordinal, kind/cursor, order alias, flag alias, chain alias, resource template, world alias, history alias and ordered pending intents shown above.

It MUST NOT:

- accept a superset/subset resource count;
- infer a missing history entry;
- preserve stale legacy Kitchen/Packing inputs after consumption;
- leave transport cargo/flag present after row 4;
- call normal task-enqueue event emission during reconstruction;
- advance from one row to a non-adjacent row;
- convert an unknown combination to the nearest row.

Any mismatch is `checkpoint_contract_invalid`. The correct response is fail-closed preflight/implementation feedback, not a guessed repair.

---

## 17. Implementation outcome

R48-02B completed / PASS on 2026-07-12.

Implemented:

- strict `PlayerCheckpointV1` codec with the exact seventeen-row golden matrix and canonical nested-payload digest;
- D-023 fresh `x2/x2` reserve, honest `x2/x2 → x1/x1` conservation and visible transport-payload semantics;
- exact First Day player input path `trip → dispatch → equip`, with the obsolete separate reward-claim hidden from player mode;
- synchronous staged-to-durable acknowledgement barrier and explicit calm save Retry;
- pre-`_ready` Continue import, silent deterministic pending-intent reconstruction and at-most-one interrupted-task replay;
- PlayerBoot lifecycle handling for fresh, incomplete Continue, complete-hold return, backup/temp recovery and invalid/incompatible state;
- isolated automated profile roots across checkpoint, process-restart and launch regression tools.

Verified:

- all seventeen cursors validate, restore in a fresh process and advance with exact `sequence + 1` for cursors 1–16;
- SIGKILL after real in-flight progress in Trip/Unload/Carry/Cook/Pack/Load/Delivery/Equip restores and replays only the interrupted task;
- initial, automatic and trip/dispatch/equip acknowledgement failures preserve the previous durable cursor and recover through explicit Retry;
- codec negative, candidate/recovery, sequence conflict, launch isolation, R48-02A store, full Godot, First Day and D-022 Day 2 regression matrices pass;
- one explicit native profile proved first start and second-launch lifecycle behavior, then its exact profile root was removed;
- automated test roots and the production profile path are absent after acceptance.

This closes only the technical First Day checkpoint-resume gate. It does not implement the D-023 ordinary completed-First-Day `Continue → Day 2` transition; that remains R48-03.
