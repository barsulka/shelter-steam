# STEAM_DESKTOP — Task Flow Contract v1

Дата: 2026-06-28  
Роль документа: Game Design / Systems Design / Dev-facing Task Flow Contract  
Статус: draft v1  
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
order_id optional
created_by
blocks_order_progress: true/false
completion_event
failure_or_block_reason optional
```

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
- order: First Warm Delivery.

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
Protein Packet x1
Packaging Bag x1
```

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
TripTask(route.oat_farm_intro, dog.dachshund_intro, transport.basket_bicycle)
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
trip_returned_with_payload(route.oat_farm_intro, payload: Oat Crate x1, Pumpkin Crate x1)
```

TripTask MUST create:

```text
UnloadTask(Oat Crate, Basket Bicycle -> Storage)
UnloadTask(Pumpkin Crate, Basket Bicycle -> Storage)
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
resource_added_to_storage(Oat Crate)
resource_added_to_storage(Pumpkin Crate)
```

Storage inventory MUST update only after `resource_added_to_storage`.

After both Oat Crate and Pumpkin Crate are in Storage, Order MAY transition:

```text
missing_resources -> resources_available
```

System MUST create required CarryTasks for Kitchen inputs:

```text
CarryTask(Oat Crate, Storage -> Kitchen)
CarryTask(Pumpkin Crate, Storage -> Kitchen)
CarryTask(Protein Packet, Storage -> Kitchen)
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
resource_delivered_to_kitchen(Oat Crate)
resource_delivered_to_kitchen(Pumpkin Crate)
resource_delivered_to_kitchen(Protein Packet)
```

Kitchen MUST wait until all three required inputs are delivered.

Kitchen MUST NOT start CookTask before all inputs arrive.

### 8.6 CookTask flow

When Kitchen inputs are ready, system MUST create:

```text
CookTask(Kitchen -> Food Mix)
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
food_mix_created(Food Mix x1, source: Kitchen)
```

Kitchen MUST expose Food Mix for transport to Packing Table.

System MUST create:

```text
CarryTask(Food Mix, Kitchen -> Packing Table)
CarryTask(Packaging Bag, Storage -> Packing Table)
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
complete: publish resource_delivered_to_packing_table(Food Mix)
```

Packaging Bag CarryTask MUST proceed:

```text
queued
assigned
moving_to_source: dog walks to Storage
in_progress: dog picks up Packaging Bag
moving_to_target: dog carries Packaging Bag to Packing Table
completing: dog places Packaging Bag on Packing Table
complete: publish resource_delivered_to_packing_table(Packaging Bag)
```

Packing Table MUST wait until Food Mix and Packaging Bag are both delivered.

### 8.8 PackTask flow

When Packing Table inputs are ready, system MUST create:

```text
PackTask(Packing Table -> Food Bag)
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
food_bag_created(Food Bag x1, source: Packing Table)
```

System MUST create:

```text
LoadVanTask(Food Bag, Packing Table -> Delivery Van Endpoint)
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
van_loaded(Food Bag x1, order.first_warm_delivery)
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
DeliveryTask(order.first_warm_delivery)
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
delivery_complete(order.first_warm_delivery)
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
