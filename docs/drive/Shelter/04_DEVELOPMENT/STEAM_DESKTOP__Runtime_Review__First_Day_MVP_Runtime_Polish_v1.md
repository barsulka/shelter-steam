# STEAM_DESKTOP — Runtime Review — First Day MVP Runtime Polish v1

Дата: 2026-07-05
Роль: Game Designer / Systems Designer
Статус: accepted at runtime-evidence level

## 0. Контекст

Проверка выполнена после Codex-задачи:

```text
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__First_Day_MVP_Runtime_Polish_v1.md
```

Цель проверки: подтвердить, что First Day MVP runtime evidence теперь доказывает не только техническое завершение первой поставки, но и минимальный эмоциональный first-day closure: открытка, память, награда и мягкий next-day hint.

Это не visual / player-feel acceptance. 100x capture остаётся dev-only state/causality proof.

## 1. Проверенные runs

### Codex smoke run

```text
steam/.runtime/workbench_capture_runs/_smoke_first_day_mvp_runtime_polish/
```

Proof:

```text
snapshot_count: 42
events_written: 106
stress_signal_sample_count: 42
exit_status: success
```

### Independent MCP review run

```text
steam/.runtime/workbench_capture_runs/first_day_mvp_runtime_polish_review_v0/
```

Proof:

```text
snapshot_count: 42
events_written: 106
stress_signal_sample_count: 42
exit_status: success
```

## 2. Main verdict

```text
First Day MVP Runtime Polish v1: PASS
First Day runtime evidence: PASS
Workbench proof quality: PASS
Visual / warmth / player feel: NOT TESTED
```

Codex completed the R-21 runtime/evidence goals without expanding product scope.

## 3. Confirmed first_day_mvp_proof

Both smoke and independent MCP run confirm:

```text
order.delivery_confirmed: true
order.postcard_visible: true
order.reward_available: true
game.chain_complete: true
production_chain.state: completed
production_chain.completed: true
```

New first-day proof confirms:

```text
first_day.postcard_life_moment_seen: true
first_day.first_reward_equipped: true
first_day.first_memory_added: true
first_day.next_day_hint_available: true
```

Required event proof exists:

```text
event.dog_noticed_postcard: true
event.dog_received_reward: true
event.first_day_memory_added: true
event.next_day_hint_available: true
event.dog_equipped_first_reward: true
```

Food Bag semantic proof:

```text
food_bag.not_in_delivery_van: true
food_bag.hidden_after_delivery: true
food_bag.semantic_delivered: true
food_bag.location: delivered_to_shelter
```

Legacy chain proof:

```text
legacy.trip.complete: true
legacy.unload_to_storage.complete: true
legacy.cook_food_mix.complete: true
legacy.pack_food_bag.complete: true
legacy.delivery.complete: true
legacy.equip_comfortable_slippers.complete: true
```

Debug cleanup proof:

```text
debug_time_advanced.events_tagged_debug: true
debug_time_advanced.not_production_chain: true
```

## 4. What improved

### 4.1 Event log now reads as dog-owned work

High-level dog action events now show the First Day as dog activity, not only inventory/timer transitions.

Examples:

```text
dog_departed_with_bicycle
dog_returned_with_payload
dog_picked_up_resource
dog_delivered_resource
dog_started_cooking
dog_created_food_mix
dog_started_packing
dog_created_food_bag
dog_loaded_van
dog_noticed_postcard
dog_received_reward
dog_equipped_first_reward
```

This directly addresses the R-19 watchpoint: production evidence was stronger than dog-action evidence.

### 4.2 Debug noise is cleaned

Debug tick events remain present, but now have:

```text
tag: debug
```

and are no longer counted as production_chain activity. This makes `events.jsonl` and stress signals more useful for Game Designer review.

### 4.3 First Day has emotional closure in runtime state

`game.first_day` now carries the MVP closure flags:

```text
postcard_life_moment_seen
first_reward_equipped
first_memory_added
next_day_hint_available
memory_text
next_day_hint_text
```

This means the first day now has runtime evidence for:

```text
postcard noticed
memory added
reward received/equipped
soft reason to return tomorrow
```

### 4.4 Food Bag semantic is resolved

Final Food Bag state no longer looks like an undelivered bag sitting in the van.

Confirmed final state:

```text
location: delivered_to_shelter
visible: false
semantic_state: delivered
delivery_van_endpoint.food_bag: 0
```

### 4.5 Legacy production_chain no longer contradicts authoritative production_chains

The old legacy list now agrees with the completed flow. This removes a review-tool ambiguity found in R-19.

## 5. Stress signals after polish

Final signals:

```text
blocked_states_recent: 0
chains_with_invisible_conversion: 0
dog_action_events_recent: 28
dogs_without_identity_fields: 0
production_events_recent: 13
raw_inventory_growth_recent: 4
room_activity_events_recent: 0
rooms_visible_to_workbench: 9
story_events_recent: 6
```

Interpretation:

- PASS: no invisible conversion signal.
- PASS: dog identity still present.
- PASS: dog-action evidence is now strong enough for First Day proof.
- PASS: story events now appear as part of delivery closure.
- WATCH: room activity remains zero, but this is expected because House of Curiosity is a post-delivery tease, not a first-day system.

## 6. Remaining watchpoints

### 6.1 Visual/player feel still untested

The run is 100x JSON capture. It does not prove:

- calm pacing at real speed;
- animation warmth;
- readability of dog/resource/van/postcard states;
- emotional impact of the postcard moment;
- whether the first-day hint feels natural.

### 6.2 Postcard moment is runtime-scaffolded, not final UX

The runtime evidence is now correct, but UI/Art still needs later review:

```text
how postcard appears
how dogs react visibly
where memory/reward are shown
how next-day hint is presented
```

### 6.3 House of Curiosity remains tease only

This is consistent with First Day MVP v1. Do not expand it into full research before a separate design step.

## 7. R-21 verdict

```text
R-21 First Systems Implementation Slice v1: accepted at runtime-evidence level
```

R-21 fulfilled the brief:

- debug event noise cleaned;
- dog action events added;
- post-delivery dog/life moment added;
- Food Bag semantic resolved;
- legacy chain mismatch fixed;
- Workbench manifest proof expanded;
- existing full-dispatch path preserved.

## 8. Recommended next steps

### Next best product/design step

Prepare the next roadmap step as either:

1. **R-22 — First Day Player-Feel / Visual Review Pack v1**

   Purpose: run real-speed or low-speed visible capture/review and check whether the First Day actually feels warm/readable.

2. **R-22 — First Day MVP State/UX Contract v1**

   Purpose: define exact player-facing postcard/reward/Dog Card/hint UX before more implementation.

Recommended order:

```text
First Day visible capture/review -> UX contract -> next Codex visual/UX slice
```

Do not start full House of Curiosity implementation yet.

## 9. Sources

Runtime bundles:

```text
steam/.runtime/workbench_capture_runs/_smoke_first_day_mvp_runtime_polish/
steam/.runtime/workbench_capture_runs/first_day_mvp_runtime_polish_review_v0/
```

Key artifacts:

```text
manifest.json
run.log
events.jsonl
stress_signals.jsonl
final_state.json
```

Design source:

```text
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__First_Day_MVP_v1.md
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__First_Day_MVP_Runtime_Polish_v1.md
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Runtime_Capture_Review__First_Delivery_Dispatch_v1.md
```
