# STEAM_DESKTOP — Codex Brief — Persisted Day 1 To Day 2 Return v1

Дата: 2026-07-12

Статус: completed / PASS

Владельцы постановки: Producer / Game Designer / Project Manager

Владелец реализации: Codex

Roadmap task: R48-03

Decision: D-023

Рекомендуемый уровень рассуждений Codex: **очень высокий**

---

## 0. Цель

Превратить уже завершённый First Day checkpoint в настоящий одноразовый player return:

```text
fully-complete First Day profile
→ app/process closes
→ ordinary player launch
→ player chooses Continue / return
→ runtime performs one idempotent persisted transition
→ Day 2 return tableau
→ same proven second Warm Delivery
→ restart-safe Day 2 checkpoints
→ progress note → optional question
→ restart-stable Quiet Cooperative
```

Player path никогда не загружает `second_day_after_first_delivery`. Fixture остаётся dev oracle и regression source, но не implementation source.

Эта wave закрывает только persisted First Day → Day 2 journey continuity. Она не добавляет calendar/offline progression, Day 3, repeatable orders, background-performance acceptance, final onboarding polish, authored world art, living Labrador animation или Kitchen room surface.

---

## 1. Обязательные источники

### Rules / role / current truth

```text
PROJECTS_RULES.md
AGENTS.md
steam/AGENTS.md
steam/README.md
docs/drive/Shelter/00_START_HERE/000_ROLE_CODEX.md
docs/repo/status/CODEX_CURRENT_STATUS.md
docs/drive/Shelter/04_DEVELOPMENT/CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md
```

### Accepted architecture

```text
docs/repo/adr/README.md
docs/repo/adr/0001-use-godot-for-steam-desktop.md
docs/repo/adr/0002-game-state-as-source-of-truth.md
docs/repo/adr/0003-player-profile-persistence-boundary-and-recovery.md
```

### Product / game contracts

```text
docs/drive/Shelter/00_START_HERE/02_DECISIONS.md — D-022, D-023
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__First_48_Hours_Playable_Scope_Lock_v1.md
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__First_48_Hours_Playable_Roadmap_v1.md — R48-03
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__First_Day_MVP_v1.md
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__First_Week_Direction_v1.md
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Task_Flow_Contract_v1.md
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Object_Contract_v1.md
```

### Implementation baselines

```text
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Runtime_Safe_Checkpoints_And_Continue_v1.md
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Day_2_Return_And_Second_Warm_Delivery_v1.md
steam/scripts/player/player_boot.gd
steam/scripts/player/player_checkpoint_codec.gd
steam/scripts/persistence/player_profile_schema.gd
steam/scripts/persistence/player_profile_store.gd
steam/scripts/prototypes/vertical_slice/vertical_slice_demo.gd
steam/resources/game_systems/fixtures/second_day_after_first_delivery.json
```

---

## 2. Authority and ownership

### 2.1 Runtime

The existing `VerticalSliceDemo` runtime remains the only gameplay authority. It owns:

- transition precondition validation;
- semantic First Day history freeze;
- exact Day 2 active order/chain initialization;
- task/resource progression;
- Day 2 feedback and Quiet Cooperative transition;
- selection and export of safe checkpoints.

No second simulation, transition service, fixture loader or UI-owned state machine is added.

### 2.2 PlayerBoot

`PlayerBoot` owns ordinary startup/recovery navigation and durable checkpoint acknowledgements. For a valid fully-complete First Day profile it:

1. offers the ordinary return action;
2. configures one runtime before `_ready` with a specific `begin_day2_return` startup intent plus the validated First Day checkpoint;
3. lets runtime stage sequence 18;
4. persists sequence 18 before Day 2 presentation/progression becomes committed;
5. shows a calm Retry if the transition checkpoint cannot be persisted.

It never constructs Day 2 gameplay state itself.

### 2.3 PlayerProfileStore

The store remains I/O/validation/recovery only. It never chooses the transition, creates stock, increments sequence or derives a day from elapsed time.

---

## 3. Return trigger and preconditions

The only R48-03 transition trigger is the first ordinary player return action after loading a valid `first_day_complete_hold / first_day_complete / sequence 17` profile in a new PlayerBoot process.

Required preconditions:

```text
journey.phase = first_day_complete_hold
journey.active_day = 1
journey.checkpoint_kind = first_day_complete
journey.checkpoint_sequence = 17
first_day_history = exact fully-complete canonical history
active First Day order/chain = exact completed canonical values
no task/current task/in-flight progress exists in checkpoint payload
resources.storage.protein_packet = 1
resources.storage.packaging_bag = 1
all other active resource containers are empty except delivered First Day Food Bag history projection
```

The trigger does not inspect wall clock, file timestamp, timezone, app-close duration, focus state or OS suspend duration.

Early First Day restart keeps the existing R48-02B cursor and never creates Day 2.

---

## 4. Transition transaction

The runtime performs one staged semantic transaction:

1. freeze exact `first_day_history`;
2. preserve Postcard, equipped slippers, Dog Card memory and Packing Table note presentation facts;
3. verify the persisted `Protein Packet x1` and `Packaging Bag x1` remainder;
4. archive the completed First Day active execution facts as history-only authority;
5. create exactly one Day 2 active order:

```text
id = order.second_warm_delivery_careful_pack
title = Аккуратная тёплая поставка
status = offered
delivery_state = idle
delivery_confirmed = false
completed = false
postcard_created = false
reward_created = false
equip_task_created = false
```

6. create exactly one Day 2 active chain:

```text
template_id = chain.warm_food_delivery_intro
run_id = run.day2.second_warm_delivery
state = not_started
current_step = none
route_id = route.oat_farm_intro
transport_id = transport.basket_bicycle
```

7. initialize exact Day 2 return flags with `return_moment_seen=true` and no urgency/absence penalty;
8. set transition marker/version in the checkpoint-owned journey state;
9. stage sequence 18 `day2_offered`;
10. block Day 2 cues/tasks until persistence ACK;
11. after ACK, reveal the calm return tableau and familiar `Начать поездку` action.

No resource is created, refilled, rewarded or emitted during transition. There is no `resource_added_to_storage` transition event. The x1/x1 remainder keeps its First Day provenance.

Repeated import/restart of sequence 18 restores it and never repeats steps 1–8 as a new transition.

---

## 5. Checkpoint contract extension

### 5.1 Compatibility

Existing playable First Day payload schema v1 remains readable. R48-03 introduces payload schema v2 deliberately because Quiet Cooperative requires immutable completed Day 2 history while `active_order` / `active_chain` are empty.

Rules:

- outer `PlayerProfileEnvelopeV1` remains version 1;
- payload format id remains `shelter.player-checkpoint`;
- payload schema v1 is accepted only for the existing First Day cursor graph;
- payload schema v2 adds exact `day2_history` and supports the complete First Day + Day 2 graph;
- a valid v1 First Day checkpoint is normalized in memory to v2 without mutating the stored source during inspection;
- the next successful new checkpoint write stores v2;
- migration never repairs invalid/future/corrupt input;
- v1 and v2 validation remain strict, allowlisted and separately tested.

### 5.2 `day2_history`

Payload v2 adds exactly:

```text
day2_history.completed: bool
day2_history.order: empty dictionary until Quiet Cooperative, then exact completed Day 2 order
day2_history.chain: empty dictionary until Quiet Cooperative, then exact completed Day 2 chain
```

At `quiet_cooperative`:

- `day2_history.completed=true`;
- order/chain contain immutable copies of the exact completed Day 2 histories;
- `active_order={}`;
- `active_chain={}`.

No completed history controls execution.

### 5.3 Journey phases

Payload v2 exact phases:

```text
first_day
first_day_complete_hold
day2
quiet_cooperative
```

Exact transition metadata is part of `journey`:

```text
transition_version = 0 for First Day
transition_version = 1 for Day 2 and Quiet Cooperative
day2_initialized = false for First Day
day2_initialized = true for Day 2 and Quiet Cooperative
```

No timestamp or calendar field is added.

---

## 6. Exact Day 2 safe cursor graph

R48-03 appends these normative ordinals after First Day sequence 17:

```text
18 day2_offered
19 day2_route_confirmed
20 day2_payload_returned
21 day2_oat_stored
22 day2_resources_available
23 day2_oat_in_kitchen
24 day2_pumpkin_in_kitchen
25 day2_inputs_in_kitchen
26 day2_food_mix_ready
27 day2_food_mix_at_packing
28 day2_inputs_at_packing
29 day2_food_bag_ready
30 day2_ready_to_dispatch
31 day2_dispatch_confirmed
32 day2_delivery_response
33 quiet_cooperative
```

Semantics:

| Cursor | Committed meaning | Pending intent / player gate |
| --- | --- | --- |
| `day2_offered` | Return tableau persisted; order offered; x1/x1 remainder | wait for familiar route confirmation |
| `day2_route_confirmed` | Route confirmation committed | reconstruct Day 2 TripTask |
| `day2_payload_returned` | Oat/Pumpkin visible on Bicycle | two UnloadTasks |
| `day2_oat_stored` | Oat committed to Storage | remaining Pumpkin UnloadTask |
| `day2_resources_available` | both route resources stored | three Kitchen CarryTasks |
| `day2_oat_in_kitchen` | Oat carry committed | Pumpkin + Protein carries |
| `day2_pumpkin_in_kitchen` | Pumpkin carry committed | Protein carry |
| `day2_inputs_in_kitchen` | all inputs committed | CookTask |
| `day2_food_mix_ready` | Food Mix created | Food Mix + Packaging carries |
| `day2_food_mix_at_packing` | Food Mix at Packing Table | Packaging carry |
| `day2_inputs_at_packing` | packing inputs committed | Labrador PackTask |
| `day2_food_bag_ready` | Food Bag created | LoadVanTask |
| `day2_ready_to_dispatch` | Food Bag visibly loaded | wait indefinitely for dispatch confirmation |
| `day2_dispatch_confirmed` | dispatch confirmation committed | DeliveryTask |
| `day2_delivery_response` | delivery complete + progress note visible | bounded automatic question/quiet transition |
| `quiet_cooperative` | question visible, completed result archived, active slots empty | no progression intent |

Every reconstructed Day 2 task/event carries `order.second_warm_delivery_careful_pack`. The Labrador careful cue remains observable only during the reconstructed/existing PackTask `in_progress`; it is not a new checkpoint, task or state authority.

---

## 7. Day 2 canonical state and causality

The player transition must remain equivalent to the D-022 fixture/scenario contract:

```text
order:
offered → route_suggested → missing_resources → resources_available
→ production_in_progress → packed → loaded → sent → completed

chain:
not_started → route_selected → trip_active → payload_returned → unloading
→ stored → inputs_to_kitchen → cooking → food_mix_ready
→ moving_to_packing → packing_ready → packing → food_bag_ready
→ loading_van → ready_to_dispatch → dispatched → completed
```

Required causal boundaries:

- `resources_available` only after both route resources are in Storage;
- no confirmation for carry/cook/pack/load;
- `player_confirmed_delivery` precedes DeliveryTask creation and `sent`;
- `delivery_complete` alone causes `completed`;
- progress note precedes optional question;
- no Day 2 Postcard, reward or EquipItemTask;
- Quiet Cooperative contains no active order/chain and creates no Day 3.

---

## 8. Player lifecycle copy

Fully complete First Day profile:

```text
label: Кооператив спокойно ждёт возвращения.
action: Продолжить
```

Day 2 active profile:

```text
label: Сохранение готово.
action: Продолжить
```

Quiet Cooperative profile:

```text
label: Кооператив отдыхает. Можно вернуться, когда удобно.
action: Вернуться в кооператив
```

Save failure keeps the existing calm retry contract. No copy may imply elapsed calendar time, missed work, urgency or obligation.

---

## 9. Expected change areas

Initial write scope:

```text
steam/scripts/player/player_checkpoint_codec.gd
steam/scripts/player/player_boot.gd
steam/scripts/persistence/player_profile_schema.gd
steam/scripts/prototypes/vertical_slice/vertical_slice_demo.gd
steam/tests/player_checkpoints/**
steam/tests/player_continue/**
steam/tests/day2_return/**                         # new
steam/tools/test-player-checkpoints.sh
steam/tools/test-player-continue.sh
steam/tools/test-player-day2-return.sh             # new
steam/tools/check-godot.sh
steam/README.md
docs/repo/dev/player-profile-persistence.md
this brief
roadmap/current/status closeout docs
```

The fixture JSON remains unchanged unless regression proves an actual D-022 oracle error. Do not copy fixture loading or fixture-only metadata into player code.

Do not touch `.codex/config.toml`, MCP, connector/OpenAPI, production art, dog pipeline, room assets, platform/export settings or unrelated documents.

---

## 10. Acceptance / Definition of Done

- [x] Valid sequence 17 profile plus ordinary return action persists sequence 18 before Day 2 becomes active.
- [x] Player path does not call fixture/dev-save/connector/control code.
- [x] Transition is independent of wall clock and app-close duration.
- [x] First Day history is exact, immutable and separately inspectable after transition.
- [x] Postcard, equipped slippers, Dog Card memory and Packing note persist independently.
- [x] Day 2 begins with exact persisted Protein x1 / Packaging x1 remainder and no transition resource creation.
- [x] Exactly one Day 2 order and one chain exist; repeated restart creates no duplicate order/chain/event/stock.
- [x] Every Day 2 task/event carries the second order id.
- [x] All sequences 18–33 validate, import in a fresh process and advance by exactly one where progression exists.
- [x] Route and dispatch are the only required Day 2 player confirmations.
- [x] Save ACK failure at transition, automatic work, route and dispatch preserves the previous durable cursor and retries idempotently.
- [x] Kill/restart during every Day 2 task family replays only the interrupted task from its accepted safe cursor.
- [x] Real player transition normalized state matches the D-022 fixture oracle at Day 2 offered.
- [x] Existing D-022 52-assertion scenario remains green.
- [x] Existing First Day seventeen-cursor and causal regressions remain green.
- [x] v1 First Day profiles remain readable and upgrade only through an explicit successful v2 write.
- [x] Invalid/future/corrupt profiles remain fail-closed and unchanged.
- [x] Day 2 completion reaches progress note, optional question and persisted Quiet Cooperative.
- [x] Quiet Cooperative has immutable completed Day 2 history, empty active slots, no Day 3 and restart-stable presentation.
- [x] No production profile/test artifacts remain after tests.
- [x] Roadmap/current/status docs report R48-03 truthfully; no R48-04 claim is made.

---

## 11. Required tests and evidence

1. Codec tests for v1/v2 identity, migration normalization, all 33 cursors and forbidden cross-phase combinations.
2. Fresh First Day → sequence 17 → process exit → ordinary return → durable sequence 18.
3. Transition persistence failure/retry and crash-before-ACK proof.
4. Full Day 2 cursor restore/advance matrix.
5. Real forced-kill matrix for Trip/Unload/Carry/Cook/Pack/Load/Delivery and completion-beat replay.
6. Repeated process restart at sequence 18, mid-Day2, sequence 32 and sequence 33.
7. Resource conservation proof with no transition `resource_added_to_storage` event.
8. Normalized sequence-18 vs fixture oracle comparison excluding dev-only fixture metadata/events.
9. Exact two-confirmation Day 2 input proof.
10. Quiet Cooperative archive/empty-active/no-Day3 proof.
11. Existing profile-store, launch-surface, First Day checkpoint/Continue, First Day runtime and D-022 Day 2 regressions.
12. `bash -n`, Godot parse/full project check, `git diff --check`, ignored evidence and clean test/profile roots.

Evidence must use isolated `user://player-tests/<run-id>` roots. A single optional manual native profile may be created only for explicit lifecycle proof and its exact root must be removed afterward.

---

## 11.1. Completion evidence — 2026-07-12

- Implemented payload schema v2 with explicit read-only normalization of legacy First Day v1 profiles.
- Implemented the ordinary persisted sequence `17 → 18`, the complete Day 2 cursor graph through sequence 33 and restart-stable Quiet Cooperative with archived Day 2 history and empty active slots.
- Verified all 33 cursors, every fresh-process restore/advance edge, all automatic task-family SIGKILL cases, the sequence-32 completion beat, save-failure barriers and explicit Retry at transition/route/work/dispatch/response boundaries.
- Verified organic order-tagged task-creation events, feedback ordering, exact `x1/x1` conservation and no transition storage-add event.
- Compared the real sequence-18 state to the unchanged D-022 fixture oracle and reran the native D-022 visible/assertion capture: six screenshots, 80 frames and no failed scenario assertion.
- Re-ran player-profile transaction/recovery kill matrices, First Day checkpoint regression and the full Godot project smoke.
- Test roots were removed; production player profile was not created or modified by this wave.

Next gate: prepare and accept R48-04A separately. This closeout does not claim background-cadence or onboarding completion.

---

## 12. Stop conditions

Stop before mutation or return the conflict if implementation requires:

- loading `second_day_after_first_delivery` from player path;
- creating/refilling Protein or Packaging during transition;
- treating First Day history as active Day 2 authority;
- a second runtime/simulation;
- wall-clock, timezone, offline catch-up or calendar rollover;
- more than route + dispatch Day 2 confirmations;
- changing D-022 order/chain/event causality;
- Day 2 postcard/reward/equip/habit/research/quality/economy;
- Day 3 or repeatable orders;
- permissive payload validation or silent profile repair;
- weakening persistence acknowledgement/idempotency rules;
- exact in-flight position/timer persistence;
- production art/animation/room work;
- mutation of `.codex/config.toml` or unrelated concurrent changes.

---

## 13. Closeout requirements

After PASS:

- mark this brief `completed / PASS` and record evidence;
- mark R48-03 complete in the First 48 Hours roadmap;
- make R48-04A the next brief gate without implying it is accepted/implemented;
- update `CODEX_CURRENT_STATUS.md`, `CODEX_STATUS.md`, `CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md` and relevant Current Memory;
- record exact changed files/checks/blockers;
- stage/commit/push only when explicitly requested or as part of the user-authorized continuous plan execution.
