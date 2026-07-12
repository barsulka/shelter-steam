# STEAM_DESKTOP — Task Flow Contract v1

Дата: 2026-06-28  
Обновлено: 2026-07-12
Роль документа: Game Design / Systems Design / Dev-facing Task Flow Contract  
Статус: active v1 / D-022 Day 2 + D-023 player-journey synchronization accepted
Продукт: Steam/Desktop idle always-on-top strip  
Обязателен для: Game Designer, Codex  
Основано на: `STEAM_DESKTOP__Vertical_Slice_Contract_v1.md`, `STEAM_DESKTOP__Object_Contract_v1.md`, D-009, D-010, D-011, D-012, D-013

## 0. Purpose

`Vertical Slice Contract v1` фиксирует, что должно произойти в первом играбельном срезе.

`Object Contract v1` фиксирует, какие объекты существуют и за что они отвечают.

Этот документ фиксирует, как именно мир превращает player intent в последовательность задач собак и объектов.

Цель документа:

- определить task sequence первого Vertical Slice;
- зафиксировать, кто создаёт каждую задачу;
- определить, когда задача может стартовать;
- определить, какая собака берёт задачу;
- определить, какие события создаются после завершения;
- определить, что считается blocked state;
- запретить shortcuts, которые ломают физичность мира.

## 1. Contract Language

- **MUST** — обязательно для Vertical Slice.
- **MUST NOT** — запрещено для Vertical Slice.
- **SHOULD** — желательно, если не ломает scope.
- **MAY** — допустимо, но не требуется.

Если Codex / developer видит, что для реализации task flow нужно принять новое игровое решение, разработка MUST остановиться и вернуть вопрос Game Designer / Producer.

## 2. Core Rule

Player chooses intention.  
World creates tasks.  
Dogs perform tasks.  
Objects change state only after visible task completion.

Игрок MUST NOT вручную запускать каждую микрозадачу.

Объекты MUST NOT менять ключевое состояние без связанного task event.

Ресурсы MUST NOT телепортироваться между объектами.

## 3. Required Task Types

Vertical Slice MUST support these task types:

1. TripTask
2. UnloadTask
3. CarryTask
4. CookTask
5. PackTask
6. LoadVanTask
7. DeliveryTask
8. EquipItemTask or equivalent reward/equip flow
9. IdleTask

Tasks MAY be implemented as data, state machine entries, commands, queue items or Godot nodes, but the design meaning MUST remain the same.

## 4. Common Task Model

Every non-idle task SHOULD have:

```text
id
type
status
source_object_id
target_object_id
assigned_dog_id optional
transport_id optional
resource_id optional
order_id required for order-bound scenarios; optional otherwise
created_by
blocks_order_progress: true/false
completion_event
failure_or_block_reason optional
```

For the accepted First Day and Day 2 delivery scenarios, `order_id` is REQUIRED on every task and task/capture event in the active chain. It MUST equal the current `active_order.id`. A task MAY omit `order_id` only outside an order-bound scenario.

### 4.1 Required statuses

```text
queued
assigned
moving_to_source
in_progress
moving_to_target
completing
complete
blocked
cancelled_debug_only
```

`cancelled_debug_only` MAY exist for developer tools. It MUST NOT be part of normal player flow.

### 4.2 Status meaning

- `queued` — task exists but no dog/object has started it.
- `assigned` — task has an assigned dog/object and can begin movement/work.
- `moving_to_source` — dog is walking to source object or transport.
- `in_progress` — dog/object is doing visible work or timer-backed work.
- `moving_to_target` — dog is carrying item to target.
- `completing` — final placement / handoff / animation is resolving.
- `complete` — task has published its completion event.
- `blocked` — task cannot proceed yet, but this is not a player-facing error.

## 5. Task Ownership

### 5.1 Road Sign owns TripTask creation

Road Sign MUST create TripTask only after player confirms route.

TripTask MUST be linked to:

- route: Oat Farm intro;
- transport: Basket Bicycle;
- driver: Dachshund;
- order: current `active_order.id`.

Accepted ids are:

```text
First Day: order.first_warm_delivery
Day 2 scenario: order.second_warm_delivery_careful_pack
```

This parameterization does not change route, transport, driver or object responsibility.

### 5.2 TripTask owns return payload and UnloadTask creation

TripTask MUST NOT add resources to Storage directly.

After transport returns, TripTask MUST create visible payload and then create UnloadTasks.

### 5.3 Storage owns resource availability after UnloadTask completion

Storage inventory MUST update only after UnloadTask completes placement.

Storage MAY create or request CarryTasks when Order needs resources.

### 5.4 Kitchen owns CookTask readiness

Kitchen MUST create or request CookTask only after all required inputs are delivered.

Kitchen MUST NOT create Food Mix before CookTask completes.

### 5.5 Packing Table owns PackTask readiness

Packing Table MUST create or request PackTask only after Food Mix and Packaging Bag are delivered.

Packing Table MUST NOT create Food Bag before PackTask completes.

### 5.6 Delivery Van Endpoint owns DeliveryTask readiness

Delivery Van Endpoint MUST become ready only after Food Bag is loaded by LoadVanTask.

DeliveryTask MUST require player confirmation.

### 5.7 Order observes progress, does not perform work

Order MUST observe required state changes.

Order MUST NOT spawn resources directly.

Order MUST NOT complete itself without DeliveryTask completion.

## 6. Dog Assignment Rules

Vertical Slice dog assignment MUST be simple and deterministic enough for prototype.

### 6.1 Driver assignment

TripTask MUST assign Dachshund as driver.

Player MAY confirm the assignment through Route Card, but no alternative driver is required for Vertical Slice.

### 6.2 Unload assignment

UnloadTasks SHOULD prefer Labrador if Labrador is idle or can safely finish current IdleTask.

If Labrador is unavailable, Dachshund MAY perform UnloadTask after returning.

### 6.3 Carry assignment

CarryTasks SHOULD prefer:

1. dog already near source;
2. Labrador for crates / Food Bag;
3. Dachshund if Labrador is busy and task is blocking progression.

### 6.4 Cook / Pack assignment

CookTask MAY use Labrador or Dachshund.

PackTask MAY use Labrador or Dachshund.

The visual requirement is more important than perfect role matching: a dog must visibly help the station work.

Exception for the accepted Day 2 scenario: its existing PackTask MUST be assigned deterministically to `dog.labrador_intro`. The careful-packing cue/event MUST occur only while that PackTask is `in_progress`. This does not create a second task, overlay task, assignment system, habit, quality state or bonus.

### 6.5 Idle assignment

IdleTask fills downtime.

IdleTask MUST yield to required Vertical Slice tasks.

A dog MAY finish a very short idle animation before taking a work task, but this MUST NOT make progression feel broken.

## 7. Priority Rules

Task priority MUST follow this order:

1. Finish current carry/unload if item is already in paws.
2. Complete UnloadTasks from returned transport.
3. Complete CarryTasks required by active order inputs.
4. Complete CookTask when Kitchen inputs are ready.
5. Complete CarryTask from Kitchen to Packing Table.
6. Complete CarryTask for Packaging Bag to Packing Table.
7. Complete PackTask.
8. Complete LoadVanTask.
9. Wait for player delivery confirmation.
10. Complete DeliveryTask.
11. Complete reward/equipment flow.
12. IdleTask.

A dog carrying an item MUST NOT abandon that item for another task except debug recovery.

## 8. Full Vertical Slice Task Chain

This is the required first-order task chain.

D-023 changes only section 8.1 starting reserve from `x1/x1` to `x2/x2`; sections 8.2–8.11 First Day task causality remains unchanged with `active_order.id = order.first_warm_delivery`. Their task/event examples are parameterized by `active_order.id`. Section 8.12 remains the D-022 Day 2 scenario contract with `active_order.id = order.second_warm_delivery_careful_pack` and narrowly changes only Day 2 assignment/feedback behavior.

### 8.1 Initial State

World MUST start with:

```text
Order: First Warm Delivery / offered or missing_resources
Road Sign: route_available
Storage: has_starting_supplies
Kitchen: waiting_for_inputs
Packing Table: idle or waiting_for_mix
Delivery Van Endpoint: idle or waiting_for_food_bag
Dachshund: idle near Road Sign / Storage
Labrador: idle near Storage / Kitchen
Basket Bicycle: parked near Road Sign
```

Storage MUST contain:

```text
Protein Packet x2
Packaging Bag x2
```

The First Day chain consumes one unit of each. The remaining `Protein Packet x1` and `Packaging Bag x1` persist for Day 2 under D-023. Storage does not generate or refill them.

Storage MUST NOT contain:

```text
Oat Crate
Pumpkin Crate
Food Mix
Food Bag
```

### 8.2 Player starts route

Player action:

```text
open Road Sign / Route Card
confirm Oat Farm intro route
send Dachshund with Basket Bicycle
```

System MUST create:

```text
TripTask(route.oat_farm_intro, dog.dachshund_intro, transport.basket_bicycle, order_id: active_order.id)
```

### 8.3 TripTask flow

TripTask MUST proceed:

```text
queued
assigned
moving_to_source: Dachshund walks to Basket Bicycle
in_progress: Dachshund prepares / reaches transport
in_progress: Basket Bicycle leaves strip
in_progress: away timer / calm trip state
in_progress: Basket Bicycle returns
completing: visible payload appears
complete: publish trip_returned_with_payload
```

Completion event:

```text
trip_returned_with_payload(route.oat_farm_intro, payload: Oat Crate x1, Pumpkin Crate x1, order_id: active_order.id)
```

TripTask MUST create:

```text
UnloadTask(Oat Crate, Basket Bicycle -> Storage, order_id: active_order.id)
UnloadTask(Pumpkin Crate, Basket Bicycle -> Storage, order_id: active_order.id)
```

TripTask MUST NOT:

- add Oat Crate to Storage;
- add Pumpkin Crate to Storage;
- complete Order requirements directly.

### 8.4 UnloadTask flow

Each UnloadTask MUST proceed:

```text
queued
assigned
moving_to_source: dog walks to returned cargo
in_progress: dog takes cargo
moving_to_target: dog carries cargo to Storage
completing: dog places cargo into Storage
complete: publish resource_added_to_storage
```

Completion events:

```text
resource_added_to_storage(Oat Crate, order_id: active_order.id)
resource_added_to_storage(Pumpkin Crate, order_id: active_order.id)
```

Storage inventory MUST update only after `resource_added_to_storage`.

After both Oat Crate and Pumpkin Crate are in Storage, Order MAY transition:

```text
missing_resources -> resources_available
```

System MUST create required CarryTasks for Kitchen inputs:

```text
CarryTask(Oat Crate, Storage -> Kitchen, order_id: active_order.id)
CarryTask(Pumpkin Crate, Storage -> Kitchen, order_id: active_order.id)
CarryTask(Protein Packet, Storage -> Kitchen, order_id: active_order.id)
```

### 8.5 CarryTask to Kitchen flow

Each CarryTask to Kitchen MUST proceed:

```text
queued
assigned
moving_to_source: dog walks to Storage
in_progress: dog picks up resource
moving_to_target: dog carries resource to Kitchen
completing: dog places resource into Kitchen
complete: publish resource_delivered_to_kitchen
```

Completion events:

```text
resource_delivered_to_kitchen(Oat Crate, order_id: active_order.id)
resource_delivered_to_kitchen(Pumpkin Crate, order_id: active_order.id)
resource_delivered_to_kitchen(Protein Packet, order_id: active_order.id)
```

Kitchen MUST wait until all three required inputs are delivered.

Kitchen MUST NOT start CookTask before all inputs arrive.

### 8.6 CookTask flow

When Kitchen inputs are ready, system MUST create:

```text
CookTask(Kitchen -> Food Mix, order_id: active_order.id)
```

CookTask MUST proceed:

```text
queued
assigned
moving_to_source: dog walks to Kitchen
in_progress: dog performs cooking/helping animation
completing: Kitchen output state appears
complete: publish food_mix_created
```

Completion event:

```text
food_mix_created(Food Mix x1, source: Kitchen, order_id: active_order.id)
```

Kitchen MUST expose Food Mix for transport to Packing Table.

System MUST create:

```text
CarryTask(Food Mix, Kitchen -> Packing Table, order_id: active_order.id)
CarryTask(Packaging Bag, Storage -> Packing Table, order_id: active_order.id)
```

### 8.7 CarryTask to Packing Table flow

Food Mix CarryTask MUST proceed:

```text
queued
assigned
moving_to_source: dog walks to Kitchen
in_progress: dog picks up Food Mix
moving_to_target: dog carries Food Mix to Packing Table
completing: dog places Food Mix on Packing Table
complete: publish resource_delivered_to_packing_table(Food Mix, order_id: active_order.id)
```

Packaging Bag CarryTask MUST proceed:

```text
queued
assigned
moving_to_source: dog walks to Storage
in_progress: dog picks up Packaging Bag
moving_to_target: dog carries Packaging Bag to Packing Table
completing: dog places Packaging Bag on Packing Table
complete: publish resource_delivered_to_packing_table(Packaging Bag, order_id: active_order.id)
```

Packing Table MUST wait until Food Mix and Packaging Bag are both delivered.

### 8.8 PackTask flow

When Packing Table inputs are ready, system MUST create:

```text
PackTask(Packing Table -> Food Bag, order_id: active_order.id)
```

PackTask MUST proceed:

```text
queued
assigned
moving_to_source: dog walks to Packing Table
in_progress: dog packs / ties / labels bag
completing: Food Bag appears
complete: publish food_bag_created
```

Completion event:

```text
food_bag_created(Food Bag x1, source: Packing Table, order_id: active_order.id)
```

System MUST create:

```text
LoadVanTask(Food Bag, Packing Table -> Delivery Van Endpoint, order_id: active_order.id)
```

### 8.9 LoadVanTask flow

LoadVanTask MUST proceed:

```text
queued
assigned
moving_to_source: dog walks to Packing Table
in_progress: dog picks up Food Bag
moving_to_target: dog carries Food Bag to Delivery Van Endpoint
completing: dog loads Food Bag into Delivery Van Endpoint
complete: publish van_loaded
```

Completion event:

```text
van_loaded(Food Bag x1, order_id: active_order.id)
```

Delivery Van Endpoint MUST transition:

```text
waiting_for_food_bag -> ready_to_send
```

Order MAY transition:

```text
packed -> loaded
```

### 8.10 DeliveryTask flow

Player action required:

```text
confirm delivery
```

After player confirmation, system MUST create:

```text
DeliveryTask(order_id: active_order.id)
```

DeliveryTask MUST proceed:

```text
ready
player_confirmed
in_progress: van leaves / delivery resolves calmly
complete: publish delivery_complete
```

Completion event:

```text
delivery_complete(order_id: active_order.id)
```

System MUST create or show:

```text
Postcard Card
Comfortable Slippers reward
```

### 8.11 Reward / Equip flow

Postcard Card MUST show warm feedback and Comfortable Slippers reward.

Player action:

```text
equip Comfortable Slippers to Dachshund
```

System MUST update Dog Card:

```text
Dachshund innate trait: Быстрые лапки
Dachshund equipment: Удобные тапочки
```

Reward flow MUST demonstrate D-010 separation.

### 8.12 Day 2 same-chain reuse

Fixture/scenario:

```text
fixture: second_day_after_first_delivery
scenario: second_warm_delivery_after_first_day
```

#### 8.12.1 Historical and active state boundary

The fixture MUST keep completed First Day facts in immutable `first_day_history` and MUST initialize exactly one fresh `active_order` and one fresh `active_chain`:

```text
first_day_history.order_id: order.first_warm_delivery
first_day_history.delivery_confirmed: true
first_day_history.postcard_visible: true
first_day_history.reward_available: true
first_day_history.chain_complete: true
first_day_history.postcard_life_moment_seen: true
first_day_history.first_reward_equipped: true
first_day_history.first_memory_added: true
first_day_history.next_day_hint_available: true
first_day_history.dachshund.slippers_equipped: true
first_day_history.dachshund.memory_id: memory.first_warm_delivery
first_day_history.dachshund.memory_text: Помнит первую тёплую поставку
first_day_history.packing_note_visible: true

active_order.id: order.second_warm_delivery_careful_pack
active_order.status: offered
active_order.delivery_state: idle
active_order.delivery_confirmed: false
active_order.completed: false
active_order.postcard_created: false
active_order.reward_created: false
active_order.equip_task_created: false

active_chain.template_id: chain.warm_food_delivery_intro
active_chain.run_id: run.day2.second_warm_delivery
active_chain.state: not_started
active_chain.current_step: none
active_chain.route_id: route.oat_farm_intro
active_chain.transport_id: transport.basket_bicycle
```

Legacy top-level order/chain flags MAY exist only as one-way projections of `active_order` / `active_chain`; they MUST NOT overwrite or stand in for `first_day_history`. This boundary is fixture/runtime/capture-only and MUST NOT add save, migration, calendar, rollover or persistence behavior.

The active chain MUST progress exactly:

```text
not_started
-> route_selected
-> trip_active
-> payload_returned
-> unloading
-> stored
-> inputs_to_kitchen
-> cooking
-> food_mix_ready
-> moving_to_packing
-> packing_ready
-> packing
-> food_bag_ready
-> loading_van
-> ready_to_dispatch
-> dispatched
-> completed
```

`active_chain.current_step` MUST expose the exact current step and starts as `none`.

#### 8.12.2 Deterministic inputs

At Day 2 fixture load, Storage MUST contain exactly:

```text
Protein Packet x1
Packaging Bag x1
```

It MUST NOT contain Oat Crate, Pumpkin Crate, Food Mix or Food Bag. No cargo/token is pre-created. The two supplies are static existing-stock fixture preconditions, not replenishment, generator, timer, route reward, resource economy or save state.

#### 8.12.3 Exact order progression

The active order MUST progress in this exact order:

```text
offered
-> route_suggested
-> missing_resources
-> resources_available
-> production_in_progress
-> packed
-> loaded
-> sent
-> completed
```

Rules:

1. Fixture return tableau sets `day2.return_moment_seen=true`; the order remains `offered` and no task starts automatically.
2. `player_confirmed_trip(order_id)` creates the order-tagged TripTask. The route step moves through `route_suggested` to `missing_resources`.
3. Oat/Pumpkin MUST exist as returned cargo. Only both order-tagged `resource_added_to_storage` events permit `resources_available`, then `production_in_progress`.
4. Existing CarryTask, CookTask, PackTask and LoadVanTask causal boundaries remain unchanged. The Day 2 PackTask is assigned to Labrador and emits `labrador_packing_care_moment(order_id)` only in `in_progress`.
5. `van_loaded(Food Bag x1, order_id)` permits `loaded` and `delivery_state=ready_to_send`.
6. `player_confirmed_delivery(order_id)` creates DeliveryTask and sets `active_order.delivery_confirmed=true`, `sent` / `delivery_state=sending`. `sent` MUST NOT reveal note, question, reward or quiet end.
7. Only `delivery_complete(order_id)` permits `completed` / `delivery_state=delivered`, `active_order.completed=true` and `day2.second_delivery_completed=true`.

Every Day 2 task and required capture event MUST carry:

```text
order_id: order.second_warm_delivery_careful_pack
```

TripTask, LoadVanTask and DeliveryTask therefore use the active order id rather than a First-Day constant. First Day regression remains tagged `order.first_warm_delivery`.

#### 8.12.4 Day 2 completion exception

After Day 2 `delivery_complete`:

1. Active Order observes the exact event and publishes `day2_progress_note_revealed(order_id)`.
2. The existing Van-side postcard-board cue renders the small progress note and sets `day2.second_feedback_visible=true`.
3. Only after that note is visible, Active Order publishes `day2_curiosity_question_revealed(order_id)`.
4. The existing Packing Table note cue renders `Как паковать мягче?`, sets `day2.curiosity_question_available=true` and `day2.curiosity_is_optional_hint=true`, then the scenario reaches `day2.quiet_end_state_reached=true`.

For `order.second_warm_delivery_careful_pack`, DeliveryTask MUST NOT emit `postcard_created`, `reward_created` or create EquipItemTask. For `order.first_warm_delivery`, sections 8.10–8.11 remain unchanged: Postcard Card and Comfortable Slippers reward/equip flow still occur.

#### 8.12.5 D-023 post-proof Quiet Cooperative

D-022 fixture evidence may end with the completed Day 2 order/chain still exposed as the active completed state. The ordinary D-023 player journey subsequently MUST archive that completed result into immutable journey history, clear active-order/active-chain slots and enter Quiet Cooperative. Only existing non-progression IdleTask behavior may continue; no new order, task chain, resource, reward or progression is created.

## 9. Blocked State Rules

Blocked state is a normal waiting condition, not an error.

Blocked task MUST be calm and understandable in debug/player-facing UI if shown.

### 9.1 Valid blocked reasons

```text
waiting_for_free_dog
waiting_for_resource_at_source
waiting_for_target_available
waiting_for_inputs
waiting_for_player_confirmation
waiting_for_previous_task_completion
```

### 9.2 Invalid blocked reasons for Vertical Slice

Vertical Slice MUST NOT block on:

- missing monetization;
- missing external account;
- missing Browser Extension;
- paid timer;
- real shelter data;
- optional rare reward;
- long-term economy level.

### 9.3 Player-facing blocked text

If blocked state is shown to player, tone MUST remain soft.

Allowed:

- “Ждём свободную собаку.”
- “Нужно дождаться ящика в кладовой.”
- “Сначала привезём ингредиенты.”

Forbidden:

- “Ошибка.”
- “Недостаточно ресурсов! Купите...”
- “Срочно!”
- “Приют ждёт.”

## 10. Idle Behaviour Rules

IdleTask exists to keep the strip alive.

IdleTask MUST NOT become a separate progression system in Vertical Slice.

Allowed idle behaviours:

- dog watches road;
- dog sits near Storage;
- dog stretches;
- dog wags tail;
- dog briefly looks at another dog;
- dog rests near Kitchen.

IdleTask MUST yield to required tasks.

IdleTask SHOULD not create new resources, rewards or progression.

## 11. Timing Rules

Vertical Slice timing is prototype timing, not final balance.

Timing MUST support readable physical actions.

Timing MUST NOT be tuned for monetization, pressure or retention tricks.

Trip duration SHOULD be long enough to show idle life, but short enough for first slice testing.

For prototype, route and production timings MAY be compressed.

However, compression MUST NOT remove required visible steps.

## 12. Event List

Vertical Slice implementation SHOULD expose or log these events for debug clarity:

```text
order_created
player_confirmed_trip
trip_task_created
transport_left_strip
trip_timer_started
trip_timer_complete
transport_returned
payload_visible
unload_task_created
resource_added_to_storage
carry_task_created
resource_delivered_to_kitchen
kitchen_inputs_ready
cook_task_created
food_mix_created
resource_delivered_to_packing_table
packing_inputs_ready
pack_task_created
food_bag_created
load_van_task_created
van_loaded
player_confirmed_delivery
delivery_task_created
delivery_complete
postcard_created
reward_created
reward_equipped
```

Every order-bound event MUST include `order_id`. The accepted Day 2 scenario additionally MUST expose:

```text
labrador_packing_care_moment(order_id)
day2_progress_note_revealed(order_id)
day2_curiosity_question_revealed(order_id)
```

For Day 2, the required parameterized event chain is:

```text
player_confirmed_trip(order_id)
trip_task_created(order_id)
trip_returned_with_payload(route_id, payload, order_id)
resource_added_to_storage(resource_id, order_id)
resource_delivered_to_kitchen(resource_id, order_id)
food_mix_created(resource_id=food_mix, order_id)
resource_delivered_to_packing_table(resource_id, order_id)
labrador_packing_care_moment(order_id)
food_bag_created(resource_id=food_bag, order_id)
van_loaded(resource_id=food_bag, order_id)
player_confirmed_delivery(order_id)
delivery_task_created(order_id)
delivery_complete(order_id)
day2_progress_note_revealed(order_id)
day2_curiosity_question_revealed(order_id)
```

Dev-only debug UI MAY show these events.

Player UI SHOULD show only the meaningful calm states, not an event log.

## 13. Forbidden Shortcuts

The following shortcuts MUST NOT be used in Vertical Slice implementation:

1. TripTask directly adds Oat/Pumpkin to Storage.
2. Returned payload is invisible.
3. Storage updates before dog places cargo.
4. Kitchen starts before inputs are delivered.
5. Kitchen creates Food Bag directly.
6. Packing Table is skipped.
7. Food Bag is invisible.
8. Van becomes ready before Food Bag is loaded.
9. Delivery completes without player confirmation.
10. Postcard appears before DeliveryTask completion.
11. Comfortable Slippers are added as a generic stat without Dog Card separation.
12. IdleTask blocks required production tasks.
13. Player must manually approve every microtask.
14. Any task uses guilt, urgency or monetization pressure.

## 14. Minimal AI / Scheduler Contract

Vertical Slice does not require complex AI.

Scheduler MAY be simple.

Scheduler MUST be able to:

- keep task queue;
- assign Dachshund to TripTask;
- assign Labrador or Dachshund to UnloadTask;
- assign available dog to CarryTask;
- assign available dog to CookTask / PackTask / LoadVanTask;
- avoid interrupting a dog carrying an item;
- let IdleTask run only when no required task is available.

Scheduler MUST NOT require:

- pathfinding perfection;
- fatigue system;
- skill optimization;
- multiple route planning;
- production balancing;
- dog personality simulation.

## 15. Acceptance Check

Task Flow Contract is satisfied when:

1. Every required Vertical Slice task type exists in implementation or prototype data.
2. Every task has a clear creator.
3. Every task has clear start conditions.
4. Every task has clear completion event.
5. Resource state changes happen only after visible task completion.
6. Dogs perform the work automatically after player intent.
7. The player does not need to confirm microtasks.
8. Blocked states do not look like errors.
9. Idle behaviour does not block progression.
10. The full first-order chain can run from route confirmation to slippers equipped.
11. The fixture-only Day 2 chain can run from immutable First Day history and `offered` through the exact active-order statuses to `completed` without mutating First Day facts.
12. Day 2 uses the same physical task/object chain, carries the second order id on every task/event, assigns the existing PackTask to Labrador, and ends with non-reward note/question feedback only after `delivery_complete`.

## 16. Next Recommended Document

After this task flow contract, the next design task SHOULD be:

`STEAM_DESKTOP__Codex_Implementation_Brief__Vertical_Slice_v1`

Purpose:

Condense Vertical Slice Contract, Object Contract and Task Flow Contract into one direct implementation brief for Codex:

- exact target;
- files likely to touch;
- non-negotiable gameplay rules;
- implementation order;
- checks;
- documentation updates expected after coding.

## 17. Changelog

### 2026-07-12 — D-023 player-journey synchronization

- Changed only the First Day starting reserve to `Protein Packet x2` and `Packaging Bag x2`; existing task causality and per-order consumption remain unchanged.
- Defined the post-proof transition from completed Day 2 evidence state to history-backed Quiet Cooperative with empty active slots.

### 2026-07-11 — D-022 Day 2 scenario addendum

- Preserved the First Day chain and parameterized order-bound tasks/events by `active_order.id`.
- Added immutable First Day history versus active Day 2 state, deterministic existing-stock fixture inputs, exact status ordering and Labrador-owned PackTask.
- Added the limited Day 2 non-reward completion path using the existing Van-side board and Packing Table note anchors; First Day postcard/slippers behavior remains unchanged.
