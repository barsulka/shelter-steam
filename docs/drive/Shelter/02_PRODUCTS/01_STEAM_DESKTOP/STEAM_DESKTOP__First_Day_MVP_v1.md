# STEAM_DESKTOP — First Day MVP v1

Дата: 2026-07-05
Роль документа: Game Design / MVP Scope Contract
Статус: draft v1
Продукт: Steam/Desktop idle always-on-top strip
Roadmap task: R-20 — First Day MVP Contract v1
Роль-владелец: Game Designer / Systems Designer

---

## 0. Назначение

Этот документ фиксирует первый playable day для Steam/Desktop Shelter.

Цель First Day MVP — не показать всю будущую игру, а доказать первый цельный игровой день:

```text
игрок открывает маленький собачий кооператив
-> собаки делают первую тёплую поставку
-> игрок понимает физический flow ресурсов и действий
-> приходит благодарность
-> одна собака получает личную память/маленькую награду
-> появляется мягкий повод вернуться завтра
```

Документ основан на full-dispatch runtime review:

```text
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Runtime_Capture_Review__First_Delivery_Dispatch_v1.md
```

И закрывает design step R-20. После него можно готовить R-21 Codex brief.

---

## 1. Product promise первого дня

Первый день должен дать игроку простое чувство:

> “У меня есть маленький собачий кооператив. Они не просто производят корм — они вместе сделали первое доброе дело, получили тёплый ответ и чуть-чуть изменились.”

Ключевые ощущения:

- спокойно;
- понятно;
- физически видно;
- собаки живые, а не worker units;
- игрок помогает кооперативу, а не управляет каждой лапой;
- финал дня эмоциональный, а не только `chain_complete=true`.

---

## 2. MVP scope summary

### In scope

First Day MVP включает:

1. Две стартовые собаки.
2. Один стартовый маршрут: Овсяная ферма.
3. Одну production chain: Первая тёплая поставка.
4. Один player-confirmed route start.
5. Один player-confirmed dispatch.
6. Физически видимые resource steps: return, unload, carry, kitchen, packing, van load.
7. Одну открытку / благодарность после доставки.
8. Одну личную награду: Удобные тапочки для Таксы.
9. Одну личную память: “Помнит первую тёплую поставку”.
10. Один мягкий post-delivery tease на следующий день / House of Curiosity.
11. Workbench/state evidence достаточный для проверки loop, dog identity и post-delivery moment.

### Out of scope

First Day MVP НЕ включает:

- полную экономику;
- вторую production chain;
- полноценный research tree;
- полноценный House of Curiosity loop;
- dog room decoration;
- mood/energy/comfort as pressure systems;
- friendship system;
- monetization;
- real charity reporting;
- cross-product sync;
- Browser Extension mechanics;
- production art acceptance;
- final balance numbers;
- paid gacha / paid reroll / FOMO.

---

## 3. First Day structure

Первый день состоит из пяти beats.

```text
Beat 1 — В кооперативе первый рабочий день
Beat 2 — Первая поездка за ресурсами
Beat 3 — Собаки вместе готовят поставку
Beat 4 — Игрок отправляет первую поставку
Beat 5 — Открытка, тапочки, память и завтрашний намёк
```

### Beat 1 — В кооперативе первый рабочий день

Player fantasy:

> “Здесь живут две собаки. Они готовы сделать первую тёплую поставку.”

Player-facing state:

- видна короткая main strip;
- есть Road Sign, Basket Bicycle, Storage, Kitchen, Packing Table, Delivery Van Endpoint;
- две собаки находятся в кооперативе;
- заказ “Первая тёплая поставка” доступен;
- игроку понятно первое намерение: начать поездку.

Player action:

```text
Подтвердить первую поездку
```

Dog actions:

- Такса готовится к дороге;
- Лабрадор остаётся в кооперативе как спокойный помощник.

### Beat 2 — Первая поездка за ресурсами

Player fantasy:

> “Такса быстро съездила на овсяную ферму и привезла первые ящики.”

Runtime chain:

```text
player_confirmed_trip
-> trip_task_created
-> transport_left_strip
-> trip_timer_started
-> trip_timer_complete
-> transport_returned
-> payload_visible
```

Required dog/player meaning:

- поездка не должна выглядеть как мгновенное появление ресурсов;
- driver dog matters;
- route edge and transport must remain semantically visible.

### Beat 3 — Собаки вместе готовят поставку

Player fantasy:

> “Кооператив оживает: ящики разгружают, несут на кухню, смешивают, фасуют и готовят к отправке.”

Runtime chain:

```text
unload tasks created
-> resources added to storage
-> carry tasks to kitchen
-> kitchen inputs ready
-> food mix created
-> carry tasks to packing table
-> packing inputs ready
-> food bag created
-> load van task created
-> van loaded
```

Required dog-owned visible actions:

- собака подходит к payload;
- собака разгружает ящик;
- собака несёт ресурс;
- собака участвует в Kitchen step;
- собака участвует в Packing step;
- собака несёт Food Bag к фургону.

Allowed simplification:

- некоторые steps могут быть semantic placeholders на первом MVP, если Workbench clearly emits high-level dog action events.

Forbidden shortcut:

- ресурс не должен просто увеличиться в Storage без route/return/unload evidence;
- Kitchen не должна produce Food Bag directly;
- Packing Table нельзя пропустить.

### Beat 4 — Игрок отправляет первую поставку

Player fantasy:

> “Фургон загружен. Теперь это уже решение игрока: отправить первую помощь.”

Player action:

```text
Подтвердить отправку
```

Runtime chain:

```text
van_loaded
-> ready_to_dispatch
-> player_confirmed_delivery
-> delivery_task_created
-> delivery_complete
```

Design rule:

- отправка не автоматическая;
- нет guilt pressure;
- текст должен звучать спокойно: “Отправить первую тёплую поставку”, не “срочно помоги, иначе плохо”.

### Beat 5 — Открытка, тапочки, память и завтрашний намёк

Player fantasy:

> “Собаки получили тёплую благодарность. Это стало маленькой памятью первого дня.”

Runtime chain:

```text
postcard_created
-> reward_created
-> reward_equipped
-> learned_habit: Помнит первую тёплую поставку
```

Required emotional completion:

- postcard is not only a flag;
- dog reacts / notices / carries / reads / sniffs / places postcard;
- reward is personal and attached to a dog;
- day ends with a small reason to continue tomorrow.

Preferred post-delivery life moment:

```text
Такса приносит открытку к карточке/доске.
Лабрадор спокойно садится рядом.
Такса получает Удобные тапочки.
В Dog Card появляется: “Помнит первую тёплую поставку”.
Появляется мягкий hint: “Завтра можно придумать, как паковать ещё аккуратнее.”
```

---

## 4. Starting dogs

First Day MVP uses exactly two dogs.

### 4.1 Такса — первый водитель

Runtime id:

```text
dog.dachshund_intro
```

Role fantasy:

```text
маленькая быстрая водительница первой поездки
```

Identity:

```text
type: dachshund
shape_archetype: long_small
baseline_role: первый водитель
personality: любопытная, смелая
```

Innate trait:

```text
Быстрые лапки
```

First Day responsibilities:

- стартовая поездка на Овсяную ферму;
- участие в разгрузке / коротких переносах;
- recipient of first personal reward;
- носитель первой памяти.

First Day progression:

```text
activity_experience.travel increases
activity_experience.unloading/carrying may increase
learned_habit: Помнит первую тёплую поставку
equipment: Удобные тапочки
helper_effect: movement / comfort movement
```

Design note:

- тапочки усиливают “быстрые лапки”, но не заменяют innate trait;
- Такса не становится “оптимальным юнитом”, она получает маленькую личную историю.

### 4.2 Лабрадор — спокойный помощник

Runtime id:

```text
dog.labrador_intro
```

Role fantasy:

```text
спокойный заботливый помощник, который делает первую поставку аккуратной
```

Identity:

```text
type: labrador
shape_archetype: large_soft
baseline_role: спокойный помощник
personality: аккуратная, заботливая
```

Innate trait:

```text
Аккуратный помощник
```

First Day responsibilities:

- помогает разгружать;
- помогает носить ресурсы;
- участвует в Kitchen/Packing/Van loading steps;
- делает поставку аккуратной / neatly_packed;
- может быть вторым участником post-delivery life moment.

Possible First Day hint:

```text
Лабрадор замечает: “В следующий раз можно завязать мешочек ещё ровнее.”
```

This can foreshadow future habit:

```text
Ровный узелок
```

But `Ровный узелок` is NOT required to unlock in First Day MVP.

---

## 5. First route and order

### 5.1 Route

Route:

```text
Овсяная ферма / route.oat_farm_intro
```

Route role:

- first external resource trip;
- demonstrates D-013: Steam gets raw resources through off-screen dog trips, not visible crop farming.

Inputs returned:

```text
Oat Crate
Pumpkin Crate
```

Driver:

```text
Такса
```

Transport:

```text
Basket Bicycle
```

### 5.2 Order

Order:

```text
Первая тёплая поставка / order.first_warm_delivery
```

Player-facing purpose:

```text
Собрать и отправить первый тёплый мешочек корма.
```

Completion criteria:

```text
order.delivery_confirmed: true
order.postcard_visible: true
order.reward_available: true
game.chain_complete: true
production_chain.state: completed
```

Emotional completion criteria:

```text
postcard_life_moment_seen: true
first_memory_added_to_dog: true
first_reward_equipped_or_claimed: true
next_day_hint_available: true
```

These emotional fields may be implemented as runtime events or state flags in R-21.

---

## 6. First Day player actions

First Day MVP should have few meaningful player actions.

### Required player actions

1. Start/confirm first route.
2. Confirm delivery dispatch.
3. Notice/accept postcard and reward moment.

### Optional player actions

- inspect Dog Card after reward;
- inspect order/postcard card;
- toggle QA/player prototype view in dev only;
- maybe click “continue tomorrow” / close first-day moment.

### Not allowed in First Day MVP

- assigning every micro-task manually;
- choosing from many routes;
- choosing many recipes;
- managing multiple production queues;
- optimizing equipment loadouts;
- paid acceleration;
- repeatable random reward reroll;
- guilt pressure.

---

## 7. First soft bottleneck

First Day needs one soft bottleneck. It should not be a failure.

Accepted First Day bottleneck:

```text
Delivery is ready, but it waits for player confirmation.
```

Meaning:

- dogs finished their part;
- player gets a calm meaningful agency moment;
- the co-op waits, not panics.

Player-facing language:

```text
Фургон готов. Можно отправить первую тёплую поставку.
```

Do not use:

```text
СРОЧНО
FAILED
Dogs waiting because you did nothing
```

Secondary possible bottleneck for later, not required in MVP:

```text
Packing could be neater next time.
```

This should become a hint toward House of Curiosity or future `Ровный узелок`, not a penalty.

---

## 8. Postcard / gratitude moment

### 8.1 Purpose

The postcard is the first proof that Shelter is not just production.

It turns delivery into a warm memory.

### 8.2 First Day postcard behavior

Minimum:

- postcard appears after delivery completion;
- postcard is associated with first order;
- state/event shows it exists.

Preferred MVP behavior:

- one dog notices or brings postcard;
- postcard card appears near Dog Card / co-op board;
- short gratitude text appears;
- dog memory is added after postcard moment;
- reward is created from gratitude, not from loot chest.

### 8.3 Tone

Allowed tone:

```text
Спасибо за первую тёплую поставку. Мешочек приехал аккуратно и вовремя.
```

Avoid:

```text
Without you they would have suffered.
Donate now.
You failed to help enough.
```

### 8.4 Workbench evidence needed

R-21 should expose at least one of:

```text
postcard_created
postcard_noticed_by_dog
postcard_placed_on_board
first_gratitude_moment_seen
```

---

## 9. First reward / memory

### 9.1 Reward

First reward:

```text
Удобные тапочки
```

Recipient:

```text
Такса
```

Reason:

- directly reinforces `Быстрые лапки` without replacing it;
- is warm, visible, personal and low-pressure;
- demonstrates D-010 separation: innate trait vs equipment.

### 9.2 Memory

First memory:

```text
Помнит первую тёплую поставку
```

Layer:

```text
learned_habit / story memory / first-day memory
```

Status:

- active after first delivery completion;
- should be visible in Dog Card / Workbench;
- should not be treated as a hard power upgrade.

### 9.3 Reward rules

First reward must:

- be deterministic;
- not be randomized;
- not be paid;
- not be rerollable;
- not create a rarity tier;
- not imply that non-equipped dogs are bad.

---

## 10. House of Curiosity role in First Day

House of Curiosity is present as a future promise, not a full First Day system.

### In scope

First Day may include a soft post-delivery hint:

```text
Лабрадор смотрит на мешочек: “В следующий раз можно завязать ещё ровнее.”
```

or:

```text
На доске любопытства появляется первая заметка: “Как паковать мягче?”
```

This hint may unlock or reveal:

```text
House of Curiosity tease
```

### Out of scope

First Day MVP does not need:

- active research tree;
- research assignment;
- classroom flow;
- library flow;
- research balance;
- multiple branches;
- long-term unlock chain.

### Rationale

First Day should teach one complete delivery loop first. Research becomes the next reason to return, not a second tutorial packed into day one.

---

## 11. Main strip vs detail/room windows

### Main strip must show

- route start;
- dog/transport departure and return;
- payload arrival;
- resource movement;
- Kitchen/Packing/Van state;
- delivery readiness;
- postcard/reward cue.

### Detail windows may show later

- Dog Card details;
- postcard content;
- room/life interior;
- House of Curiosity tease/details.

### First Day rule

The player should understand the core loop from the main strip without opening deep room windows.

Dog Card/postcard inspect can enrich the moment, but must not be required to understand that the first delivery is complete.

---

## 12. Workbench/state requirements for R-21

R-21 implementation should make First Day review easier.

Minimum new or cleaned evidence:

### 12.1 Clean event log

Debug ticks must not pollute production event count.

Preferred:

```text
debug_time_advanced -> tag: debug
```

or separate stream.

### 12.2 High-level dog action events

Add events like:

```text
dog_departed_with_bicycle
dog_returned_with_payload
dog_started_unload
dog_picked_up_resource
dog_delivered_resource
dog_started_cooking
dog_created_food_mix
dog_started_packing
dog_created_food_bag
dog_loaded_van
dog_noticed_postcard
dog_received_reward
```

### 12.3 Post-delivery life state

Expose at least:

```text
first_day.postcard_life_moment_seen
first_day.first_reward_equipped
first_day.first_memory_added
first_day.next_day_hint_available
```

or equivalent under accepted runtime schema.

### 12.4 Delivered food bag semantic

Resolve final food bag ambiguity.

Current issue:

```text
order delivered=true
but delivery_van_endpoint still contains food_bag: 1
```

R-21 should choose one semantic:

1. Food Bag remains as `delivered_marker` visibly associated with van.
2. Food Bag moves to `sent` / `delivered` / `offscreen_shelter` location.
3. Food Bag token disappears and receipt/postcard becomes visible output.

Preferred design:

```text
Food Bag moves to sent/offscreen_shelter; postcard/receipt becomes the visible completion artifact.
```

### 12.5 Legacy production_chain cleanup

Primary state:

```text
production_chains[]
```

should remain source for design review.

Legacy `production_chain` should either match completion or be explicitly marked legacy/non-authoritative.

---

## 13. First Day acceptance criteria

First Day MVP is accepted at design-contract level when:

1. The first day has a clear player fantasy.
2. Starting dogs and roles are defined.
3. First route and order are defined.
4. Player actions are minimal and meaningful.
5. Dog-owned visible actions are defined.
6. First delivery has technical and emotional completion.
7. First reward and memory are personal and D-010-compatible.
8. First bottleneck is soft and non-punitive.
9. House of Curiosity is scoped as post-delivery tease, not full first-day research system.
10. Out-of-scope boundaries are explicit.
11. R-21 implementation scope can be derived without inventing product decisions.

Status: **complete for R-20 v1**.

---

## 14. R-21 recommended Codex brief

Next development task should be a Codex brief, not an implementation chat instruction.

Recommended title:

```text
STEAM_DESKTOP__Codex_Brief__First_Day_MVP_Runtime_Polish_v1.md
```

Recommended scope:

- clean debug event noise;
- add high-level dog action events for First Day;
- add post-delivery dog/life moment state/events;
- resolve delivered Food Bag semantic;
- clean or mark legacy production_chain mismatch;
- preserve existing first delivery full-dispatch proof;
- update Workbench capture checks to assert emotional completion, not only chain completion.

Recommended Codex reasoning level:

```text
очень высокий
```

Reason:

This touches runtime semantics, Workbench evidence, event taxonomy, first-day player meaning and accepted MVP design contract. Codex must implement contract without inventing new gameplay or broad control surfaces.

---

## 15. Stop conditions for R-21

Codex must stop and return a question if implementation requires:

- adding new dogs beyond Такса and Лабрадор;
- changing first route/order meaning;
- turning House of Curiosity into full first-day research system;
- adding mood/energy penalties;
- adding monetization, rewards randomness or reroll;
- changing final art/UI style;
- removing visible dog-owned production steps;
- replacing dog/life events with pure inventory conversions;
- broadening dev controls beyond accepted first-day testing paths.

---

## 16. Changelog

### 2026-07-05 — v1 created

- Created First Day MVP v1 contract after R-19 runtime capture review.
- Locked first day around two dogs, one route, one delivery, one postcard, one personal reward and one next-day hint.
- Defined First Day beats, in/out scope, dog roles, player actions, first soft bottleneck and R-21 implementation direction.
