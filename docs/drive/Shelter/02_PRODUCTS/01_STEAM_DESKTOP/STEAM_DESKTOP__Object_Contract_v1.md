# STEAM_DESKTOP — Object Contract v1

Дата: 2026-06-28  
Обновлено: 2026-07-11
Роль документа: Game Design / Domain Model / Dev-facing Object Contract  
Статус: active v1 / D-022 Day 2 scenario addendum accepted
Продукт: Steam/Desktop idle always-on-top strip  
Обязателен для: Game Designer, Art Director, Codex  
Основано на: `STEAM_DESKTOP__Vertical_Slice_Contract_v1.md`, D-009, D-010, D-011, D-012, D-013

## 0. Purpose

`Vertical Slice Contract v1` фиксирует, что должно произойти в первом играбельном срезе.

Этот документ фиксирует, что представляет собой каждый объект Vertical Slice и за что он отвечает.

Цель — убрать неоднозначность между геймдизайном, разработкой и арт-дирекшеном.

Если ответственность объекта не описана здесь, Codex MUST NOT добавлять её самостоятельно.

## 1. Contract Language

- **MUST** — обязательно для Vertical Slice.
- **MUST NOT** — запрещено для Vertical Slice.
- **SHOULD** — желательно, если не ломает scope.
- **MAY** — допустимо, но не требуется.

Если реализация требует новой ответственности объекта, разработка MUST вернуть вопрос Game Designer / Producer.

## 2. Global Object Rules

### 2.1 Physicality

Любой объект, влияющий на заказ, MUST иметь видимое состояние в мире или быть представлен через видимое действие.

Ресурс MUST NOT существовать только как число, если он участвует в текущем заказе.

### 2.2 Single Responsibility

Каждый объект MUST иметь одну основную игровую ответственность.

- Road Sign запускает поездку.
- Storage принимает, хранит и выдаёт ресурсы.
- Kitchen готовит Food Mix.
- Packing Table делает Food Bag.
- Delivery Van Endpoint отправляет готовую поставку.
- Dog выполняет физические задачи.
- Transport уезжает и возвращается с грузом.
- Order задаёт мягкую цель.
- Task описывает атомарную работу.

Объекты MUST NOT брать на себя чужую ответственность ради ускорения реализации.

### 2.3 No Hidden Production

Если объект производит результат, игрок SHOULD видеть:

- входящие ресурсы;
- рабочее состояние;
- выходящий результат.

### 2.4 No Scope Expansion

Vertical Slice objects MUST NOT автоматически расширяться в будущие системы.

- Storage MUST NOT становиться полной экономикой склада.
- Kitchen MUST NOT становиться деревом рецептов.
- Road Sign MUST NOT становиться большой картой мира.
- Dog Card MUST NOT становиться RPG character sheet.
- Packing Table MUST NOT становиться полной мастерской декора.

## 3. Object Categories

Vertical Slice использует следующие категории объектов:

1. **World Anchor** — физический объект на полоске, вокруг которого строится действие.
2. **Character** — собака-житель, выполняющая задачи.
3. **Transport** — средство off-screen поездки.
4. **Resource** — физический предмет или промежуточный результат, который участвует в заказе.
5. **Order** — мягкая цель поставки.
6. **Task** — атомарная работа.
7. **UI Card** — компактное представление состояния/выбора.

Art taxonomy из D-011 обязательна:

- Building;
- Utility Prop;
- Dog Action Sprite.

## 4. Vertical Slice Object List

### World Anchors

- Road Sign / Road Edge
- Storage
- Kitchen
- Packing Table
- Delivery Van Endpoint

### Characters

- Dachshund
- Labrador

### Transport

- Basket Bicycle

### Resources

- Oat Crate
- Pumpkin Crate
- Protein Packet
- Packaging Bag
- Food Mix
- Food Bag

### Orders

- First Warm Delivery
- Second Warm Delivery / Careful Pack (accepted Day 2 fixture scenario only)

### Tasks

- TripTask
- UnloadTask
- CarryTask
- CookTask
- PackTask
- LoadVanTask
- DeliveryTask
- IdleTask

### UI Cards

- Order Card
- Route Card
- Dog Card
- Postcard Card
- Hide / Show UI

Storage/Kitchen/Packing/Van cards MAY exist if needed for clarity, but are not core player actions.

---

## 5. Road Sign / Road Edge

**Category:** World Anchor / Utility Prop.  
**Role:** physical start and return point for off-screen resource trips.  
**Purpose:** connect visible Steam strip with off-screen farm routes without turning Steam into visible crop farming.

### Contains

Road Sign MAY contain:

- available route list;
- selected route;
- selected transport;
- selected driver dog;
- current trip state;
- calm trip timer/state indicator.

Road Sign MUST NOT contain:

- full world map;
- route economy spreadsheet;
- paid reroll;
- ads;
- Browser Extension UI.

### Consumes

Road Sign consumes player intent:

- route selection;
- send confirmation.

Road Sign does not consume resources.

### Produces

Road Sign produces:

- TripTask;
- trip state;
- return payload spawn point.

### Visible States

- idle;
- route_available;
- trip_preparing;
- trip_active;
- trip_returning;
- unload_available.

### Player Interaction

Player MUST be able to:

- click Road Sign;
- open Route Card;
- start the first route.

Player MUST NOT manually control transport after sending.

### Automatic Behaviour

Road Sign MUST:

- anchor dog movement before departure;
- show calm trip state while transport is away;
- anchor return position;
- make returned cargo visible.

### Not Responsible For

Road Sign is not responsible for:

- storing resources;
- producing food;
- assigning all future tasks;
- managing long-term route progression;
- showing real charity data;
- cross-product sync.

---

## 6. Storage

**Category:** World Anchor / Building.  
**Role:** physical place where resources enter the co-op and wait for use.  
**Purpose:** make resource arrival and availability visible.

### Contains

Storage contains:

- starting supplies;
- resources unloaded from transport;
- resources waiting for production;
- outgoing CarryTask sources.

Vertical Slice starting supplies:

- Protein Packet x1;
- Packaging Bag x1.

The accepted `second_day_after_first_delivery` fixture also starts with exactly the same two units as deterministic existing stock:

- Protein Packet x1;
- Packaging Bag x1.

For Day 2 this is a static fixture precondition after immutable First Day history. Storage MUST NOT generate, refill or replenish these resources, and no save/economy/route-reward rule is implied.

After trip unload:

- Oat Crate x1;
- Pumpkin Crate x1.

### Consumes

Storage consumes resources only when a dog visibly places them into Storage.

Storage MUST NOT receive Oat Crate or Pumpkin Crate at the moment the trip timer ends.

### Produces

Storage produces:

- resource availability;
- CarryTasks from Storage to Kitchen or Packing Table;
- visible stored-resource state.

### Visible States

- has_starting_supplies;
- receiving_resources;
- ready_for_production;
- resource_being_taken;
- waiting_for_output_tasks.

### Player Interaction

Player MAY click Storage to inspect current resources.

Player MUST NOT manually drag resources out of Storage.

### Automatic Behaviour

Storage MUST:

- accept resources after UnloadTask completion;
- expose available resources for CarryTask;
- visually update when resources are added or removed.

### Not Responsible For

Storage is not responsible for:

- generating resources;
- deciding route rewards;
- cooking;
- packing;
- order completion;
- long-term inventory economy.

---

## 7. Kitchen

**Category:** World Anchor / Building.  
**Role:** production object that turns food ingredients into Food Mix.  
**Purpose:** show the first visible transformation in the production chain.

### Contains

Kitchen contains:

- delivered Oat Crate input;
- delivered Pumpkin Crate input;
- delivered Protein Packet input;
- current CookTask;
- Food Mix output.

### Consumes

Kitchen consumes:

- Oat Crate x1;
- Pumpkin Crate x1;
- Protein Packet x1.

Inputs count as consumed only when delivered through visible CarryTasks.

### Produces

Kitchen produces:

- Food Mix x1.

Food Mix SHOULD appear as a visible object, container, bowl, dish or clear output state.

### Visible States

- idle;
- waiting_for_inputs;
- inputs_ready;
- cooking;
- output_ready;
- output_taken.

### Player Interaction

Player MAY click Kitchen to inspect current state.

Player MUST NOT play a cooking mini-game in Vertical Slice.

### Automatic Behaviour

Kitchen MUST:

- wait until all inputs arrive;
- start CookTask automatically when inputs are ready and dog is available;
- create Food Mix after CookTask completes;
- expose Food Mix for CarryTask to Packing Table.

### Not Responsible For

Kitchen is not responsible for:

- choosing recipes;
- managing full recipe tree;
- packing final bags;
- delivering orders;
- storing long-term food resources.

---

## 8. Packing Table

**Category:** World Anchor / Utility Prop.  
**Role:** work surface that turns Food Mix and Packaging Bag into Food Bag.  
**Purpose:** make final preparation visible without creating another building.

### Contains

Packing Table contains:

- delivered Food Mix;
- delivered Packaging Bag;
- current PackTask;
- Food Bag output;
- existing packing-note world cue as a presentation anchor only.

### Consumes

Packing Table consumes:

- Food Mix x1;
- Packaging Bag x1.

### Produces

Packing Table produces:

- Food Bag x1.

Food Bag MUST become visible before delivery loading.

### Visible States

- idle;
- waiting_for_mix;
- waiting_for_packaging;
- inputs_ready;
- packing;
- output_ready;
- output_taken.

### Player Interaction

Player MAY click Packing Table to inspect state.

Player MUST NOT manually pack items in Vertical Slice.

### Automatic Behaviour

Packing Table MUST:

- wait for Food Mix and Packaging Bag;
- run PackTask when inputs are ready;
- produce visible Food Bag;
- expose Food Bag for LoadVanTask;
- in the accepted Day 2 scenario, render the optional question on its existing note cue only after the active Order publishes `day2_curiosity_question_revealed(order_id)`.

### Not Responsible For

Packing Table is not responsible for:

- being a building/room;
- full decor workshop functionality;
- toy crafting;
- future care pack crafting;
- order completion logic;
- owning Day 2 response/research state.

---

## 9. Delivery Van Endpoint

**Category:** World Anchor / Utility Prop.  
**Role:** physical endpoint for loading and sending completed delivery.  
**Purpose:** close the production loop with a visible act of help.

### Contains

Delivery Van Endpoint contains:

- loaded Food Bag;
- linked active Order state;
- delivery ready state;
- existing Van-side postcard-board world cue as a presentation anchor only.

### Consumes

Delivery Van Endpoint consumes:

- Food Bag x1 through visible LoadVanTask.

### Produces

Delivery Van Endpoint produces:

- DeliveryTask;
- `delivery_complete(active_order.id)`;
- First Day Postcard trigger for `order.first_warm_delivery` only.

### Visible States

- idle;
- waiting_for_food_bag;
- loading;
- ready_to_send;
- leaving_or_sending;
- delivered;
- postcard_ready.

### Player Interaction

Player MUST be able to confirm delivery when ready.

Player MUST NOT send delivery before Food Bag is loaded.

### Automatic Behaviour

Delivery Van Endpoint MUST:

- become ready only after Food Bag is visibly loaded;
- wait for player confirmation;
- resolve delivery calmly;
- for `order.first_warm_delivery`, trigger the existing Postcard Card / Comfortable Slippers flow;
- for `order.second_warm_delivery_careful_pack`, emit only the physical `delivery_complete(order_id)` and render the Order-owned progress-note state on the existing board cue after `day2_progress_note_revealed(order_id)`.

The Day 2 branch MUST NOT emit `postcard_created`, `reward_created` or create EquipItemTask. The board cue renders state; it does not own the response, create a reward surface or become a new UI/object system.

### Not Responsible For

Delivery Van Endpoint is not responsible for:

- real charity reporting;
- payment/donation processing;
- route travel rewards;
- production tasks before loading.

---

## 10. Dachshund

**Category:** Character / Dog.  
**Role:** first driver dog.  
**Purpose:** teach player that dogs travel for resources and are characters, not units.

### Contains

Dachshund contains:

- identity placeholder;
- breed/type: dachshund;
- innate trait: Быстрые лапки;
- equipment slot;
- current task;
- current visible state.

### Consumes

Dachshund consumes tasks, not resources.

Dachshund MAY carry resources as part of tasks, but does not store them permanently.

### Produces

Dachshund produces:

- visible trip action;
- visible dog movement;
- emotional continuity;
- after reward, visible equipment state for Comfortable Slippers.

### Visible States

- idle;
- moving_to_transport;
- preparing_transport;
- leaving_with_transport;
- away_on_trip;
- returning_with_transport;
- unloading_or_waiting;
- carrying_item;
- celebrating;
- equipped_with_slippers.

### Player Interaction

Player MUST be able to:

- select Dachshund as route driver;
- open Dog Card;
- equip Comfortable Slippers after reward.

### Automatic Behaviour

Dachshund MUST:

- walk to transport before departure;
- leave with Basket Bicycle;
- return with Basket Bicycle;
- participate in visible work after return if available.

### Not Responsible For

Dachshund is not responsible for:

- being optimized as a stat block;
- changing innate trait;
- manual player-controlled movement;
- combat;
- route reward generation.

---

## 11. Labrador

**Category:** Character / Dog.  
**Role:** calm helper for unloading, carrying and production support.  
**Purpose:** show that the co-op is shared work, not one dog acting alone.

### Contains

Labrador contains:

- identity placeholder;
- breed/type: labrador;
- innate trait: Аккуратный помощник;
- current task;
- current visible state.

### Consumes

Labrador consumes tasks, not resources.

Labrador MAY carry resources as part of tasks, but does not store them permanently.

### Produces

Labrador produces:

- visible unloading help;
- visible carry actions;
- calm co-op feeling;
- production support actions.

### Visible States

- idle;
- watching_road;
- moving_to_cargo;
- unloading;
- carrying_crate;
- helping_kitchen;
- carrying_bag;
- resting;
- celebrating.

### Player Interaction

Player MAY open Dog Card.

Player does not need to manually assign Labrador to each microtask in Vertical Slice.

### Automatic Behaviour

Labrador SHOULD be preferred for:

- UnloadTask;
- CarryTask;
- kitchen support;
- Food Bag carry if visually appropriate.

For `order.second_warm_delivery_careful_pack`, the existing PackTask MUST be assigned deterministically to Labrador. Its `labrador_packing_care_moment(order_id)` cue/event occurs only in PackTask `in_progress`; no second/overlay task, habit, quality state or numerical bonus is created.

### Not Responsible For

Labrador is not responsible for:

- route driving in Vertical Slice;
- complex personality system;
- fatigue simulation;
- room/decor systems;
- combat or stats min-max.

---

## 12. Basket Bicycle

**Category:** Transport / Utility Prop.  
**Role:** first route transport.  
**Purpose:** physically show that resources come from off-screen farm friends.

### Contains

Basket Bicycle contains:

- transport state;
- assigned driver;
- return payload visual.

### Consumes

Basket Bicycle consumes:

- TripTask assignment;
- time/trip state.

### Produces

Basket Bicycle produces:

- leaving visual;
- away state;
- returning visual;
- visible cargo payload.

### Visible States

- parked;
- preparing;
- leaving;
- away;
- returning;
- waiting_for_unload;
- unloaded.

### Player Interaction

Player selects/uses Basket Bicycle through Route Card.

Player MUST NOT directly steer or control it.

### Automatic Behaviour

Basket Bicycle MUST:

- leave the strip with Dachshund;
- remain unavailable while away;
- return with visible payload;
- wait until cargo is unloaded.

### Not Responsible For

Basket Bicycle is not responsible for:

- choosing route rewards;
- storing resources after unload;
- upgrading into trailer in Vertical Slice;
- being a shop or garage.

---

## 13. Resources

**Category:** Resource.  
**Role:** physical materials and outputs in the first order.  
**Purpose:** make the production loop causal and visible.

### Resource Types

#### Oat Crate

- Source: Oat Farm trip.
- Enters world: visible cargo on return.
- Target: Storage, then Kitchen.
- Used by: Kitchen.

#### Pumpkin Crate

- Source: Oat Farm trip.
- Enters world: visible cargo on return.
- Target: Storage, then Kitchen.
- Used by: Kitchen.

#### Protein Packet

- Source: starting Storage supply.
- Target: Kitchen.
- Used by: Kitchen.

#### Packaging Bag

- Source: starting Storage supply.
- Target: Packing Table.
- Used by: Packing Table.

#### Food Mix

- Source: Kitchen output.
- Target: Packing Table.
- Used by: Packing Table.

#### Food Bag

- Source: Packing Table output.
- Target: Delivery Van Endpoint.
- Used by: Delivery.

### Global Resource Rules

Resources MUST:

- have a physical world representation when involved in the active order;
- be carried or visibly transferred by dogs;
- update target object state only after visible placement.

Resources MUST NOT:

- teleport directly from trip to inventory;
- exist only as UI numbers;
- complete an order without visible movement.

---

## 14. Order objects

### 14.1 First Warm Delivery

**Category:** Order.  
**Role:** first soft goal.  
**Purpose:** guide the player through the first complete co-op loop.

#### Contains

First Warm Delivery contains:

- friendly title;
- non-guilt description;
- required resources;
- required final output;
- progress state;
- reward trigger.

Required resources:

- Oat Crate x1;
- Pumpkin Crate x1;
- Protein Packet x1;
- Packaging Bag x1.

Required final output:

- Food Bag x1.

Reward:

- Postcard;
- Comfortable Slippers.

#### Consumes

Order consumes completion events, not resources directly.

Resources are consumed by Kitchen, Packing Table and Delivery Van Endpoint.

#### Produces

Order produces:

- suggested next action;
- completion state;
- Postcard;
- Comfortable Slippers reward.

#### Visible States

- offered;
- missing_resources;
- route_suggested;
- resources_available;
- production_in_progress;
- packed;
- loaded;
- sent;
- completed;
- reward_claimed.

#### Player Interaction

Player MUST be able to open Order Card.

Order Card MUST gently suggest the next action.

#### Not Responsible For

Order is not responsible for:

- spawning resources directly;
- performing tasks;
- showing guilt pressure;
- long-term quest system;
- real charity promise.

### 14.2 Second Warm Delivery / Careful Pack

**Category:** Order.
**Role:** accepted Day 2 same-chain variation and owner of its non-reward completion response state.
**Id:** `order.second_warm_delivery_careful_pack`.
**Purpose:** prove that the familiar Warm Food Delivery loop can repeat with one careful-packing beat while First Day remains visible.

#### Contains

The active Order contains:

```text
id: order.second_warm_delivery_careful_pack
title: Аккуратная тёплая поставка
status: offered | route_suggested | missing_resources | resources_available | production_in_progress | packed | loaded | sent | completed
delivery_state: idle | ready_to_send | sending | delivered
delivery_confirmed: false at fixture load
completed: false at fixture load
postcard_created: false throughout Day 2
reward_created: false throughout Day 2
equip_task_created: false throughout Day 2
```

The status order is exact:

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

`sent` begins only after player confirmation creates DeliveryTask and sets `delivery_confirmed=true`. `completed` begins only after `delivery_complete(order_id)`.

#### Historical boundary

`first_day_history` is a separate immutable fixture/capture container and MUST preserve the First Day completed order, postcard, reward, chain, life-moment, equipped slippers, Dachshund memory, next-day hint and packing-note facts. The active Day 2 Order MUST NOT reuse those historical flags as its active state.

The only active chain run is:

```text
active_chain.template_id: chain.warm_food_delivery_intro
active_chain.run_id: run.day2.second_warm_delivery
active_chain.route_id: route.oat_farm_intro
active_chain.transport_id: transport.basket_bicycle
```

This is existing-chain reuse, not a new chain family. Legacy flags MAY only project the active state one way and MUST NOT overwrite history.

Its state sequence is:

```text
not_started -> route_selected -> trip_active -> payload_returned -> unloading -> stored
-> inputs_to_kitchen -> cooking -> food_mix_ready -> moving_to_packing -> packing_ready
-> packing -> food_bag_ready -> loading_van -> ready_to_dispatch -> dispatched -> completed
```

`active_chain.current_step` starts as `none` and exposes the exact active step.

#### Consumes

The Order consumes task/object completion events tagged with its exact `order_id`; it never consumes resources directly or performs production work.

#### Produces

The active Order produces:

- suggested next action and exact status progression;
- completion state only after DeliveryTask emits `delivery_complete(order_id)`;
- `day2_progress_note_revealed(order_id)`;
- after the progress note is visible, `day2_curiosity_question_revealed(order_id)`;
- calm quiet-end state.

The active Order owns this non-reward response state. The existing Van-side postcard-board cue renders the progress note; the existing Packing Table note cue renders `Как паковать мягче?`. Neither anchor owns the response or gains production responsibility.

#### Required task/object behavior

- Every task/event in the run MUST carry `order_id=order.second_warm_delivery_careful_pack`.
- Existing Road Sign, Basket Bicycle, Storage, Kitchen, Packing Table and Delivery Van Endpoint responsibilities remain unchanged.
- PackTask is the existing type, assigned to `dog.labrador_intro` for this run, and emits the careful-packing cue only in `in_progress`.
- The second order MUST NOT produce Postcard Card, Comfortable Slippers, `postcard_created`, `reward_created` or EquipItemTask.
- First Warm Delivery retains its existing postcard/reward/equip behavior without change.

#### Not Responsible For

The Day 2 Order is not responsible for:

- spawning or replenishing Protein Packet / Packaging Bag;
- generating route cargo;
- performing tasks or moving resources;
- save/persistence/calendar/day rollover;
- research, habit, quality, economy, reward or UI systems;
- new route, chain, resource, station, room or production responsibility.

---

## 15. Task Contract

**Category:** Task.  
**Role:** atomic work unit that turns player intent into physical dog/world actions.

### Required Task Types

#### TripTask

Purpose: send Dachshund and Basket Bicycle to route.

Creates:

- away state;
- return payload;
- UnloadTasks after return.

#### UnloadTask

Purpose: move returned cargo from transport to Storage.

Storage inventory updates only after this task completes.

#### CarryTask

Purpose: move a resource from one object to another.

Examples:

- Storage → Kitchen;
- Kitchen → Packing Table;
- Packing Table → Delivery Van Endpoint.

#### CookTask

Purpose: Kitchen transforms inputs into Food Mix.

#### PackTask

Purpose: Packing Table transforms Food Mix + Packaging Bag into Food Bag.

#### LoadVanTask

Purpose: move Food Bag to Delivery Van Endpoint.

#### DeliveryTask

Purpose: resolve delivery after player confirmation.

#### IdleTask

Purpose: keep dogs alive between work tasks.

IdleTask MUST NOT block required production tasks.

### Task Fields

Each task SHOULD have:

- id;
- type;
- assigned dog;
- source object;
- target object;
- carried resource, optional;
- animation tag;
- status;
- priority;
- `order_id` for every order-bound task.

Every accepted Day 2 task and capture event MUST use the active order id. TripTask, LoadVanTask and DeliveryTask MUST NOT retain a hardcoded First Day order id in the Day 2 run.

### Task Statuses

- queued;
- assigned;
- moving_to_source;
- in_progress;
- moving_to_target;
- completing;
- complete;
- blocked.

Blocked MUST be handled calmly and must not look like an error to the player.

---

## 16. UI Card Contract

### Order Card

Purpose: show current soft goal and next suggested action.

MUST NOT use guilt language.

### Route Card

Purpose: start first route.

MUST show:

- route name;
- selected dog;
- selected transport;
- expected resource categories;
- Send action.

### Dog Card

Purpose: show dog identity and D-010 trait separation.

Dachshund Dog Card MUST show:

- innate trait: Быстрые лапки;
- equipment: Удобные тапочки after reward.

### Postcard Card

Purpose: warm delivery feedback and reward reveal.

MUST be non-coercive.

### Hide / Show UI

Purpose: let the player keep the world alive while reducing interface clutter.

World state MUST continue while UI is hidden.

---

## 17. Art Responsibilities

### Buildings

Only these Vertical Slice objects are Buildings:

- Storage;
- Kitchen.

### Utility Props

These Vertical Slice objects are Utility Props:

- Road Sign / Road Edge;
- Packing Table;
- Delivery Van Endpoint;
- Basket Bicycle.

Utility Props MUST NOT become houses, shops, rooms or decorative cottages.

### Dog Action Sprites

Dog action readability is required for:

- dog walking;
- dog leaving/returning with bicycle;
- dog unloading crate;
- dog carrying crate;
- dog helping at kitchen;
- dog packing/handling bag;
- dog carrying Food Bag;
- reward/equipment moment.

Dog action SHOULD read before decorative detail.

---

## 18. Implementation Boundary

Codex MAY choose internal code structure, but MUST preserve this domain model.

Codex MUST NOT merge object responsibilities in a way that changes design meaning.

Examples of forbidden shortcuts:

- TripTask directly adds resources to Storage.
- Kitchen directly creates Food Bag without Packing Table.
- Delivery completes without visible Food Bag load.
- Dog Card treats innate trait and equipment as the same stat list.
- Packing Table is implemented visually as a building/room.

## 19. Acceptance Check

Object Contract is satisfied when:

1. Every Vertical Slice object has one clear responsibility.
2. Every required object can be mapped to implementation data/code.
3. Every resource-changing event has a responsible object.
4. Every physical movement has a responsible Task.
5. Art taxonomy is unambiguous for every visible object.
6. Codex can implement first-order loop without inventing new product responsibilities.

## 20. Next Recommended Document

After this object contract, the next design task SHOULD be:

`STEAM_DESKTOP__Task_Flow_Contract_v1`

Purpose:

Define exact task sequencing, task ownership, priority rules and blocked-state behavior for the first vertical slice.

## 21. Changelog

### 2026-07-11 — D-022 Day 2 scenario addendum

- Added the accepted second Order object while preserving every First Warm Delivery responsibility.
- Defined deterministic fixture stock as existing stock rather than replenishment, parameterized object/task events by active order id and fixed Labrador as Day 2 PackTask assignee.
- Assigned non-reward response state to Active Order and kept the existing Van-side board and Packing Table note as presentation anchors only.
