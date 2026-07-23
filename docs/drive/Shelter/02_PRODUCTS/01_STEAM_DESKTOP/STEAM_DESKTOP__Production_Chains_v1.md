# STEAM_DESKTOP — Production Chains v1

Дата: 2026-06-30
Роль документа: Game Design / Systems Design Contract
Статус: draft v1
Продукт: Steam/Desktop idle always-on-top strip
Roadmap task: R-12 — Buildings & Production Chains
Роль-владелец: Game Designer / Systems Designer

Основано на:

- `STEAM_DESKTOP__Building_System_v1.md`
- `STEAM_DESKTOP__Dog_Life_Model_v1.md`
- `STEAM_DESKTOP__Dog_Progression_Model_v1.md`
- `STEAM_DESKTOP__Ability_Source_Loop_v1.md`
- `STEAM_DESKTOP__Ability_Catalog_v1.md`
- D-009/D-013 and the implemented Vertical Slice regression baseline
- `STEAM_DESKTOP__Task_Flow_Contract_v1.md`
- `STEAM_DESKTOP__Object_Contract_v1.md`
- D-009, D-010, D-013, D-018, D-019

---

## 0. Назначение

Этот документ описывает production chains Steam/Desktop Shelter как **цепочки действий собак между местами**, а не как автоматические фабричные рецепты.

Главный принцип:

> Production chain в Shelter — это история помощи, которую собаки физически собирают, готовят, оформляют и отправляют.

Игрок должен видеть не только результат, но и путь:

```text
собака съездила
-> собака вернулась
-> собака разгрузила
-> собака отнесла
-> собака помогла приготовить
-> собака аккуратно упаковала
-> собака загрузила
-> игрок отправил
```

---

## 1. Production chain philosophy

### 1.1 Dogs are active agents

Use player-facing/design language:

```text
Dogs prepare Food Mix in Kitchen.
Dogs pack Food Bag at Packing Table.
Dogs load Food Bag into Van.
```

Avoid player-facing language:

```text
Kitchen produces Food Mix.
Packing Table consumes Food Mix.
Van endpoint consumes Food Bag.
```

Technical implementation may use compact internal verbs, but game design must preserve dog agency.

### 1.2 Production is not only output

Every chain step can produce up to four outputs:

1. material output;
2. dog growth output;
3. relationship output;
4. co-op/world state output.

Example:

```text
Pack Food Bag
-> material: Food Bag
-> dog growth: packing experience
-> relationship: mentor helps novice
-> co-op: delivery is ready and feels cared for
```

### 1.3 No invisible conversion

Core production steps must not silently convert resources.

If a resource changes state, one of these should happen:

- dog carries it;
- dog places it;
- dog works with it;
- room/station visibly changes;
- output appears after visible activity.

---

## 2. Chain layers

Each production chain has three layers.

### 2.1 Material layer

What resources move or transform:

```text
Oat Crate + Pumpkin Crate + Packaging Bag -> Food Mix -> Food Bag -> Delivery
```

### 2.2 Dog-life layer

What dogs do:

```text
travel, unload, carry, cook, pack, load, support, tidy, rest
```

### 2.3 Place layer

Where it happens:

```text
Road Sign -> Storage -> Kitchen -> Packing Area -> Delivery Van Endpoint
```

All three layers should be inspectable eventually through Workbench.

---

## 3. Chain card template

```text
Chain name:
Player-facing fantasy:
Purpose:
Places involved:
Required dogs / optional dogs:
Material inputs:
Material outputs:
Dog-life activities:
Step list:
Growth outputs:
Relationship outputs:
Co-op outputs:
Failure / blocked states:
Acceptable shortcuts:
Forbidden shortcuts:
Workbench fields later:
```

---

## 4. First chain: Warm Food Delivery

### 4.1 Chain name

`Первая тёплая поставка` / Warm Food Delivery.

### 4.2 Player-facing fantasy

Собаки вместе собирают тёплую поставку корма и отправляют её в приют.

### 4.3 Purpose

This is the baseline chain proving Shelter’s core production fantasy:

```text
external resource trip
-> physical unload
-> ingredient preparation
-> careful packing
-> player-confirmed delivery
-> warm feedback
```

### 4.4 Places involved

- Road Sign / Route Edge;
- Basket Bicycle;
- Storage;
- Kitchen;
- Packing Area / Packing Table;
- Delivery Van Endpoint;
- Postcard / reward feedback.

### 4.5 Required dogs / optional dogs

Minimum:

- one driver dog;
- one helper dog.

Optional later:

- unloading helper;
- kitchen helper;
- packing helper;
- support dog;
- mentor dog.

### 4.6 Material inputs

From route:

- Oat Crate;
- Pumpkin Crate.

From initial or later production:

- Packaging Bag.

### 4.7 Material outputs

- Food Mix;
- Food Bag;
- Completed Delivery;
- Postcard / reward moment.

---

## 5. Warm Food Delivery step list

### Step 1 — Choose route

Place:

- Road Sign / Route Edge.

Dog-life activity:

- check route;
- prepare basket;
- driver gets ready.

Material output:

- none yet.

Growth output:

- travel preparation experience.

Character traits expressed:

- Надёжность;
- Любопытство;
- Скорость.

Forbidden:

- route starts as abstract menu with no dog movement.

### Step 2 — Depart

Place:

- Road Sign / Basket Bicycle.

Dog-life activity:

- driver dog goes to bicycle;
- bicycle leaves strip.

Material output:

- trip active.

Growth output:

- travel experience after completion.

Forbidden:

- dog disappears instantly without physical departure.

### Step 3 — Return with payload

Place:

- Road Sign / strip edge.

Dog-life activity:

- bicycle returns;
- payload visible.

Material output:

- returned payload available for unload.

Forbidden:

- resources appear in Storage before return/unload.

### Step 4 — Unload to Storage

Place:

- Storage anchor.

Dog-life activity:

- dog takes Oat Crate / Pumpkin Crate;
- dog carries to Storage;
- dog places resource.

Material output:

- Oat and Pumpkin available in Storage after placement.

Growth output:

- unloading experience;
- carrying experience;
- possible reliability/accuracy habit source.

Forbidden:

- TripTask directly adds resource to inventory.

### Step 5 — Carry ingredients to Kitchen

Place:

- Storage -> Kitchen.

Dog-life activity:

- helper dog takes ingredient;
- physically carries it;
- places it at Kitchen.

Material output:

- Kitchen input delivered.

Growth output:

- carrying experience;
- station familiarity.

Forbidden:

- Kitchen starts without physical input delivery.

### Step 6 — Prepare Food Mix

Place:

- Kitchen anchor / Kitchen room later.

Dog-life activity:

- dog helps mix ingredients;
- optional support dog waits nearby;
- Kitchen shows work state.

Material output:

- Food Mix.

Growth output:

- cooking/helping experience;
- patience/careful production opportunity.

Forbidden:

- Kitchen creates Food Bag directly.

### Step 7 — Carry Food Mix to Packing Area

Place:

- Kitchen -> Packing Table.

Dog-life activity:

- dog carries Food Mix;
- places it on Packing Table.

Material output:

- Packing input delivered.

Growth output:

- carrying experience;
- packing station familiarity.

Forbidden:

- Food Mix silently transforms or teleports.

### Step 8 — Add Packaging Bag

Place:

- Storage / Packing Area.

Dog-life activity:

- dog brings or prepares Packaging Bag.

Material output:

- Packing Table has packaging input.

Growth output:

- attention/packing preparation experience.

Acceptable shortcut for early prototype:

- Packaging Bag can be pre-available at Packing Table if documented.

Forbidden:

- skipping packaging concept entirely in final chain design.

### Step 9 — Pack Food Bag

Place:

- Packing Table / Packing Room later.

Dog-life activity:

- dog packs Food Mix;
- ties bag;
- optionally attaches label/postcard element.

Material output:

- Food Bag.

Growth output:

- packing experience;
- possible `Ровный узелок` / `Не забывает ярлычок` source.

Character traits expressed:

- Аккуратность;
- Терпение;
- Внимательность;
- Забота.

Forbidden:

- Packing Table skipped.

### Step 10 — Load Food Bag into Van

Place:

- Packing Area -> Delivery Van Endpoint.

Dog-life activity:

- dog carries Food Bag;
- loads it into Van.

Material output:

- Delivery ready.

Growth output:

- delivery preparation experience;
- team completion moment.

Forbidden:

- Van ready before visible load.

### Step 11 — Player confirms dispatch

Place:

- Delivery Van Endpoint / Dispatch.

Dog-life activity:

- dogs wait near Van;
- player sends delivery.

Material output:

- Completed Delivery.

Growth output:

- delivery completion memory.

Co-op output:

- postcard/reward can appear.

Forbidden:

- auto-send without player confirmation in early loop;
- guilt pressure text.

### Step 12 — Postcard and reward

Place:

- Postcard card / Delivery history later.

Dog-life activity:

- dogs receive/read/notice warm feedback.

Material output:

- reward/equipment can be granted.

Growth output:

- story memory;
- possible trust/comfort later.

Forbidden:

- postcard before delivery completion;
- pressure language.

---

## 6. Chain state model

Each chain should expose a readable state.

Suggested states:

```text
not_started
route_selected
trip_active
payload_returned
unloading
stored
inputs_to_kitchen
cooking
food_mix_ready
moving_to_packing
packing_ready
packing
food_bag_ready
loading_van
ready_to_dispatch
dispatched
postcard_available
completed
blocked
```

Blocked state should include reason:

```text
missing_input
missing_dog
dog_busy
station_busy
output_slot_full
waiting_for_player_confirmation
asset_placeholder_only
```

---

## 7. Blocked states and gentle recovery

Shelter should avoid harsh failure.

Blocked means:

> Something is waiting calmly.

Examples:

- Kitchen waits for Pumpkin Crate.
- Packing Table waits for Packaging Bag.
- Dog waits for another dog to finish carrying.
- Van waits for Food Bag.

Blocked state should be visible and calm, not alarming.

Allowed UI language:

```text
Ждём тыкву.
Мешочек ещё не готов.
Такса сейчас в дороге.
```

Avoid:

```text
ERROR
FAILED
URGENT
DOG INEFFICIENT
```

---

## 8. Parallelism rules

### 8.1 Early slice

First chain can be mostly linear.

### 8.2 Later systems

Later chains may allow:

- multiple dogs carrying different inputs;
- one dog cooking while another prepares packaging;
- support dog reducing blocked friction;
- room-window assignments improving speed/reliability;
- self-learning dogs creating future opportunities while production continues.

### 8.3 Limits

Parallelism must not require constant micromanagement.

Player sets intent / priorities, not every micro-action.

---

## 9. Quality model

Production can have quality without becoming min-max pressure.

Possible quality outputs:

- plain good delivery;
- neatly packed delivery;
- extra warm delivery;
- carefully labeled delivery;
- dog-favorite delivery memory.

Quality may affect:

- postcard text variant;
- optional bonus;
- dog habit progress;
- co-op comfort;
- delivery history.

Quality should not block core delivery.

Low quality must not feel like failure.

---

## 10. Future chain families

These are directions, not current scope commitments.

### 10.1 Food chains

- Warm Food Delivery;
- special recipe deliveries;
- softer food for older dogs;
- seasonal comfort food.

### 10.2 Comfort chains

- blanket preparation;
- toy repair;
- room decoration crafting;
- cozy light / cushion chain.

### 10.3 Learning chains

- research method -> training opportunity;
- classroom routine -> learned habit;
- library reading -> self-learning progress;
- mentor session -> dog confidence.

### 10.4 Inspiration chains

- tree care -> fruit;
- fruit -> inspiration moment;
- inspiration -> learned habit opportunity;
- shared inspiration -> cooperative habit.

### 10.5 Delivery chains

- food delivery;
- care kit delivery;
- toy package delivery;
- blanket delivery;
- thank-you postcard archive.

---

## 11. Relationship to rooms

Room windows enrich production chains.

Examples:

- Kitchen room can show helper dog working at mixing station.
- Packing room can show one dog at table and another at label corner.
- Laboratory can show research dog, classroom dog and library dog.
- Dog House can show recovering/resting dog while another dog works.

Room activities may modify chain outcomes:

- speed;
- reliability;
- quality;
- training opportunity;
- relationship output;
- comfort output.

But chain must remain understandable from main strip.

Room window improves depth; it should not hide core chain state.

---

## 12. Relationship to Workbench

Future Workbench should inspect production chains as flows.

Possible fields:

```text
production_chains[]
  id
  name
  state
  current_step
  places[]
  dogs_involved[]
  required_inputs[]
  available_inputs[]
  outputs[]
  blocked_reason
  visible_world_event_log[]
  dog_growth_events[]
  relationship_events[]
  quality_state
  player_confirmation_required
```

Example:

```json
{
  "id": "chain.warm_food_delivery_intro",
  "state": "packing",
  "current_step": "pack_food_bag",
  "places": ["storage", "kitchen", "packing_area", "delivery_van"],
  "dogs_involved": ["dog.dachshund_intro", "dog.labrador_intro"],
  "required_inputs": ["food_mix", "packaging_bag"],
  "available_inputs": ["food_mix", "packaging_bag"],
  "blocked_reason": null,
  "quality_state": "neatly_packed",
  "player_confirmation_required": false
}
```

This is not an immediate Codex brief.

---

## 13. Design rules

1. Production chains are flows of dog actions.
2. Resource transformation must have visible cause-and-effect.
3. Buildings create places; dogs do the work.
4. Main strip must reveal core chain state.
5. Room windows may enrich but must not hide chain state.
6. Blocked states are calm waits, not failures.
7. Quality is warmth/story, not punishment.
8. Parallelism supports life, not micromanagement.
9. Player confirms meaningful delivery moments, not every task.
10. Production should create dog growth and story where possible.

---

## 14. Out of scope

This document does not define:

- exact balance numbers;
- final timings;
- full economy;
- full research tree;
- all future chain recipes;
- final UI layout;
- Codex implementation brief;
- State Connector schema change;
- art requirements.

---

## 15. Open questions

1. What is the second production chain after Warm Food Delivery?
2. Should comfort chains appear before special food chains?
3. How many chain states should be player-facing vs Workbench-only?
4. Should quality tiers be explicit or only reflected in story/postcard text?
5. Which chain outputs should feed dog learned habits first?
6. How do room assignments affect chain outcomes without becoming min-max slots?
7. Should chain queues be per building, per room, or global priority list?
8. How should player set production intent without micro-managing every step?
9. What is the first chain that uses Laboratory?
10. What is the first chain that uses Inspiration Tree?

---

## 16. Acceptance criteria

R-12 Production Chains is complete enough to close R-12 when:

1. Production chain philosophy is defined.
2. Material/dog-life/place layers are separated.
3. Chain card template exists.
4. Warm Food Delivery is fully described.
5. Chain state model exists.
6. Blocked states are calm and non-punitive.
7. Parallelism rules are defined.
8. Quality model is framed as warmth/story, not punishment.
9. Future chain families are sketched.
10. Workbench direction is sketched without immediate Codex task.

---

## 17. Next recommended document

Next Game Designer task after R-12:

```text
STEAM_DESKTOP__Laboratory_Research_Tree_v1.md
```

Reason:

Laboratory now has a clear place in the system: it is a building/room system that unlocks methods, training opportunities and softer production routines, not a cold upgrade factory.

---

## 18. Changelog

### 2026-06-30 — v1 created

- Created Production Chains v1.
- Defined production chains as flows of dog actions across places.
- Fully described first Warm Food Delivery chain.
- Added chain state model, blocked-state rules, quality model, future chain families and Workbench direction.
