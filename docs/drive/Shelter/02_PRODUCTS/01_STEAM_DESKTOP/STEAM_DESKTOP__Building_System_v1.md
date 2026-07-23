# STEAM_DESKTOP — Building System v1

Дата: 2026-06-30
Роль документа: Game Design / Systems Design Contract
Статус: draft v1
Продукт: Steam/Desktop idle always-on-top strip
Roadmap task: R-12 — Buildings & Production Chains
Роль-владелец: Game Designer / Systems Designer

Основано на:

- `STEAM_DESKTOP__Dog_Life_Model_v1.md`
- `STEAM_DESKTOP__Dog_Progression_Model_v1.md`
- `STEAM_DESKTOP__Ability_Source_Loop_v1.md`
- `STEAM_DESKTOP__Ability_Catalog_v1.md`
- `STEAM_DESKTOP__Game_Design_Roadmap_v2.md` for current activation boundaries
- current room-panel visual is an open user/Art input; superseded screenshot
  notes remain in Git history
- D-009, D-010, D-018, D-019

---

## 0. Назначение

Этот документ задаёт системную модель зданий Steam/Desktop Shelter.

Главный принцип:

> В Shelter здания ничего не делают сами. Они создают места, где собаки живут, работают, учатся, отдыхают и помогают друг другу.

Здание — не пассивный станок и не spreadsheet-node. Здание — это точка жизни кооператива.

---

## 1. Core model: Anchor + Room Window

Каждое значимое здание имеет два слоя.

### 1.1 Main strip anchor

Main strip anchor — компактное представление здания / объекта в always-on-top полоске.

Anchor показывает:

- где собаки подходят;
- куда несут ресурсы;
- где начинается activity;
- какой building сейчас busy/ready/blocked;
- что важно для production chain;
- маленькие ambient gestures.

Main strip anchor не обязан и не должен показывать всю внутреннюю жизнь.

### 1.2 Room / Detail window

Room window открывается по клику на здание, будку или производственный anchor.

Room window показывает:

- внутренние комнаты;
- assigned dogs;
- текущие activities;
- room upgrades;
- decoration;
- learning/training;
- rest/social moments;
- production details;
- queues and state in readable form.

Room window может быть богаче main strip и ближе к room-grid / room-detail references.

### 1.3 Why this solves interface constraint

Main strip остаётся читаемой и спокойной.

Room windows дают место для richer dog-life theatre:

- собака сидит за партой;
- другая собака стоит у доски;
- третья читает в библиотеке;
- две собаки помогают в лаборатории;
- кто-то работает в производственной комнате;
- кто-то отдыхает в жилой комнате.

Эта жизнь не перегружает main strip, потому что живёт в detail layer.

---

## 2. Terminology

### 2.1 Building

Building — player-facing structure that can be placed/unlocked/upgraded and can open a room window.

Examples:

- Dog House;
- Storage;
- Kitchen;
- Packing Building / Packing Table area;
- Laboratory;
- Delivery Van Endpoint / Dispatch Office;
- Garden / Inspiration Tree corner.

### 2.2 Anchor

Anchor — strip-scale physical point where dogs interact.

Examples:

- Road Sign;
- Storage front area;
- Kitchen counter;
- Packing Table;
- Van loading point.

### 2.3 Room

Room — interior subspace inside a building.

Examples:

- classroom;
- library;
- lab table;
- mixing room;
- packing room;
- dog living room;
- rest corner.

### 2.4 Station

Station — functional interaction point inside a room or at an anchor.

Examples:

- desk;
- board;
- table;
- crate spot;
- reading cushion;
- workbench.

### 2.5 Utility Prop

Utility Prop — functional object that supports activities but is not necessarily a full building.

Examples:

- Packing Table;
- Road Sign;
- Basket Bicycle;
- Notice Board;
- Inspiration Tree;
- small cart.

Utility Props can be anchors, room stations, or both.

---

## 3. Building design template

Every building should answer these questions.

```text
Name:
Player-facing fantasy:
Main strip anchor role:
Room window role:
What dogs do here:
Why dogs come here:
What production happens here:
What learning/progression happens here:
What care/social/rest can happen here:
Which character traits express here:
Which helper effects matter here:
Rooms / stations:
Inputs:
Outputs:
Queues / assignments:
Upgrade axes:
What should be visible in main strip:
What should be visible only in room window:
Forbidden shortcuts:
Workbench fields later:
```

---

## 4. System rules

### 4.1 Dogs produce here

Use this framing:

```text
Dogs cook in Kitchen.
Dogs pack at Packing Table.
Dogs study in Laboratory.
Dogs rest in Dog House.
Dogs dispatch deliveries at Van Endpoint.
```

Avoid:

```text
Kitchen produces Food Mix by itself.
Laboratory researches by itself.
Packing Table produces Food Bag by itself.
```

### 4.2 Building progress unlocks possibilities

Building upgrades should unlock:

- more comfortable activities;
- better room layout;
- new stations;
- new training opportunities;
- better queues;
- safer routines;
- more dogs participating;
- warmer visual/room state.

Building upgrades SHOULD NOT simply be `+10% output` forever.

### 4.3 Main strip stays readable

Any building feature must answer:

- is this visible in strip?
- is this visible only in room window?
- is this Workbench/internal only?

If a feature needs rich interior theatre, it belongs to room window.

### 4.4 Room windows are not mandatory micromanagement

Room windows let player observe and gently guide.

They MUST NOT require constant clicking.

Dogs should continue living/working if window is closed.

### 4.5 Idle meaning

Idle in Shelter means:

> Dog life flows on its own; the player can observe it and gently guide it.

Buildings and rooms must support this meaning.

---

## 5. First building catalog

### 5.1 Dog House / Собачья будка

Player-facing fantasy:

- Дом, где живут собаки.

Main strip anchor role:

- cozy home anchor;
- dogs enter/exit;
- visible rest/social gestures;
- access point to dog rooms.

Room window role:

- grid/list of dog rooms;
- each dog can have a personal room;
- decoration and comfort live here;
- dog personality expression;
- rest and social moments.

What dogs do here:

- rest;
- sleep;
- play;
- sit together;
- show finds;
- recover after long work;
- reveal preferences.

Production:

- none directly.

Progression:

- comfort-based strengths;
- relationship/trust moments;
- preference discovery;
- cozy helper effects.

Traits:

- Уют;
- Забота;
- Щедрость;
- Спокойствие.

Rooms/stations:

- personal room;
- shared rest corner;
- toy spot;
- decoration slots.

Forbidden:

- making room decor mandatory power min-max;
- guilt pressure if dog room is not decorated;
- paid comfort pressure.

### 5.2 Road Sign / Route Edge

Player-facing fantasy:

- Место дороги, откуда собаки уезжают и куда возвращаются.

Main strip anchor role:

- route selection;
- travel start;
- departure/return;
- payload arrival.

Room window role:

- optional route planning board later;
- route familiarity details;
- driver/passenger assignment;
- travel memories/finds.

What dogs do here:

- check basket;
- prepare bicycle;
- wait for driver;
- depart;
- return;
- show small route find.

Production:

- raw resources arrive through routes.

Progression:

- route familiarity;
- travel habits;
- curiosity/find opportunities;
- driver identity.

Traits:

- Скорость;
- Любопытство;
- Надёжность;
- Находчивость.

Rooms/stations:

- Road Sign;
- basket check spot;
- route board later.

Forbidden:

- resources appearing directly in Storage without visible return/unload;
- paid route reroll;
- route pressure timers.

### 5.3 Storage / Кладовая

Player-facing fantasy:

- Место, где встречают ресурсы и раскладывают всё по местам.

Main strip anchor role:

- unload target;
- resource entry point;
- carry source;
- visible crate placement.

Room window role:

- storage shelves;
- sorting room;
- queue of resources;
- dogs assigned to sorting/carrying;
- tidy/housekeeping activities.

What dogs do here:

- unload crates;
- sort;
- carry resources out;
- tidy shelves;
- help another dog with heavy crate.

Production:

- stores inputs for production chains.

Progression:

- unloading experience;
- carrying experience;
- housekeeping habits;
- reliability/accuracy traits.

Traits:

- Надёжность;
- Аккуратность;
- Хозяйственность;
- Забота.

Rooms/stations:

- unload spot;
- shelf room;
- sorting table;
- small cart station.

Forbidden:

- inventory-only resources;
- invisible storage updates;
- cold warehouse spreadsheet UI as player-facing primary.

### 5.4 Kitchen / Кухня

Player-facing fantasy:

- Место, где собаки готовят тёплую основу поставки.

Main strip anchor role:

- visible input delivery;
- cooking work state;
- Food Mix output.

Room window role:

- mixing room;
- recipe corner;
- helper dogs;
- training in careful preparation;
- cozy cooking routines.

What dogs do here:

- bring ingredients;
- mix;
- follow recipe;
- wait calmly;
- learn careful methods;
- support long cooking task.

Production:

- ingredients -> Food Mix.

Progression:

- cooking activity experience;
- patience/careful production habits;
- recipe familiarity.

Traits:

- Терпение;
- Аккуратность;
- Уют;
- Внимательность.

Rooms/stations:

- mixing table;
- recipe board;
- ingredient spot;
- warm waiting corner.

Forbidden:

- Kitchen creates Food Bag directly;
- Kitchen works without dogs for player-facing loop;
- cold factory framing.

### 5.5 Packing Area / Packing Table

Player-facing fantasy:

- Место красивого завершения поставки.

Main strip anchor role:

- Food Mix arrives;
- Packaging Bag arrives;
- dogs pack Food Bag;
- output goes to Van.

Room window role:

- packing room;
- label/letter corner;
- training table;
- postcard moment;
- careful finishing routines.

What dogs do here:

- tie bags;
- attach labels;
- prepare postcard;
- help novice dog;
- make delivery feel cared for.

Production:

- Food Mix + Packaging Bag -> Food Bag.

Progression:

- packing experience;
- `Ровный узелок`;
- attention/care habits;
- delivery presentation improvements.

Traits:

- Аккуратность;
- Терпение;
- Внимательность;
- Забота.

Rooms/stations:

- Packing Table;
- label station;
- postcard corner;
- ribbon shelf.

Forbidden:

- skipping Packing Table;
- making postcard discussion a busy main-strip scene;
- turning labels into guilt/charity pressure.

### 5.6 Delivery Van Endpoint / Dispatch

Player-facing fantasy:

- Место отправки помощи.

Main strip anchor role:

- Food Bag load target;
- delivery readiness;
- player confirms send;
- van leaves/returns later.

Room window role:

- dispatch board;
- delivery history;
- postcard archive;
- route/delivery planning later.

What dogs do here:

- load Food Bag;
- wait by van;
- wave off delivery;
- read/receive postcard later.

Production:

- completes delivery loop.

Progression:

- delivery familiarity;
- team completion moments;
- postcard/story events.

Traits:

- Надёжность;
- Щедрость;
- Забота;
- Уют.

Rooms/stations:

- van loading spot;
- dispatch board;
- postcard archive.

Forbidden:

- auto-send without player confirmation in early loop;
- guilt pressure;
- real charity claim without approved reporting system.

### 5.7 Laboratory / Learning House

Player-facing fantasy:

- Место любопытства, обучения и мягких экспериментов.

Main strip anchor role:

- small visible building/anchor;
- dogs may enter/exit;
- research ready indicator.

Room window role:

- laboratory room;
- classroom;
- library;
- research board;
- dog assignments;
- self-learning dog activities.

What dogs do here:

- study;
- stand near board;
- read in library;
- try new routine;
- help research;
- teach another dog.

Production:

- no direct item production by default;
- unlocks methods/opportunities.

Progression:

- research insights;
- training opportunities;
- learned habits;
- curiosity/inspiration expression.

Traits:

- Любопытство;
- Вдохновение;
- Внимательность;
- Терпение.

Rooms/stations:

- lab table;
- classroom board;
- library cushion;
- notes board.

Assignment model:

- dogs assigned to lab/classroom can speed up research or reveal better opportunities;
- if no dog is assigned, research can still progress slowly or dogs may self-learn passively, depending on future balance;
- active dog help improves pace but is not mandatory punishment.

Forbidden:

- cold sci-fi tone;
- combat research;
- research as instant dog rewrite;
- mandatory min-max assignments.

### 5.8 Garden / Inspiration Tree Corner

Player-facing fantasy:

- Место спокойствия, ухода и вдохновения.

Main strip anchor role:

- small tree/plant corner;
- dog care gesture;
- fruit/inspiration ready hint.

Room window role:

- garden room/corner;
- tree details;
- fruit history;
- dogs who cared for it;
- inspiration opportunities.

What dogs do here:

- water;
- sit nearby;
- sniff leaves;
- bring ribbon;
- share fruit inspiration.

Production:

- not core food-resource farming.

Progression:

- inspiration fruit;
- care-based strengths;
- tree relationship;
- ability source loop.

Traits:

- Уют;
- Забота;
- Терпение;
- Любопытство;
- Вдохновение.

Forbidden:

- becoming Steam visible crop farming core;
- gacha tree;
- paid fruit reroll;
- constant checking pressure.

---

## 6. Production chain model

Production chain should be described as dog actions across places.

### 6.1 First chain

```text
Road Sign / Route Edge
-> dogs travel and return
-> Storage receives visible crates through unload
-> dogs carry ingredients to Kitchen
-> dogs prepare Food Mix in Kitchen
-> dogs carry Food Mix to Packing Area
-> dogs pack Food Bag
-> dogs load Food Bag into Delivery Van Endpoint
-> player confirms dispatch
-> postcard/reward moment
```

### 6.2 Correct wording

Use:

```text
Dogs prepare Food Mix in Kitchen.
Dogs pack Food Bag at Packing Table.
Dogs load the Van.
```

Avoid:

```text
Kitchen produces Food Mix.
Packing Table produces Food Bag.
Van consumes Food Bag.
```

Technical docs may use compact verbs, but player-facing/design language should keep dogs as active agents.

---

## 7. Upgrade axes

Buildings can progress through multiple axes.

### 7.1 Capacity

- more rooms;
- more stations;
- more dogs can participate;
- more queue slots.

### 7.2 Comfort

- better rest;
- calmer work;
- better dog-life gestures;
- supports care/comfort traits.

### 7.3 Method

- new routines;
- new training opportunities;
- safer production;
- better handoff.

### 7.4 Readiness

- smoother task start;
- less blocked time;
- better queue clarity;
- better preparation.

### 7.5 Story / memory

- room history;
- dog preference reveal;
- postcard archive;
- route memories;
- tree care history.

### 7.6 Visual/decor

- decoration;
- identity;
- cozy expression.

Important:

Decor may support comfort and expression, but must not become mandatory min-max power.

---

## 8. Assignment model

Buildings may allow dog assignment, but assignments must be soft.

### 8.1 Assignment types

- worker/helper;
- learner;
- mentor;
- resting dog;
- self-learning dog;
- social visitor;
- idle resident.

### 8.2 Assignment effects

Assigned dogs MAY:

- speed up work gently;
- reduce blocked time;
- unlock training opportunities;
- create relationship moments;
- improve quality/reliability;
- produce better insight;
- make room feel alive.

Assigned dogs MUST NOT:

- be required for every tiny action;
- create punishing min-max slots;
- turn rooms into worker spreadsheets;
- imply dogs are exploited.

### 8.3 Empty room behavior

An empty or unassigned room should not feel broken.

Possible behavior:

- passive slow progress;
- no progress but no punishment;
- self-learning dog may wander in;
- room waits calmly.

---

## 9. Room window reference direction

Reference folder:

```text
docs/drive/Shelter/03_DESIGN/01_REFERENCES/screenshots/room_window_references/
```

Use these references structurally for:

- room grid;
- room detail window;
- building click -> room inspect;
- multiple rooms inside one building/system;
- characters visibly doing activities inside rooms;
- rooms as upgrade/decor/progression surfaces.

Do not use them as:

- final tone;
- horror/gothic target;
- combat/PvP pattern;
- aggressive UI model.

---

## 10. Workbench direction

Future Workbench should inspect buildings as places, not only production nodes.

Possible future state fields:

```text
buildings[]
  id
  type
  main_strip_anchor_state
  rooms[]
    id
    room_type
    assigned_dogs[]
    current_life_activities[]
    stations[]
    comfort_level
    queue_state
    upgrade_state
    unlocked_methods
    recent_events[]
  inputs
  outputs
  blocked_reason
  production_chain_role
```

This is not an immediate Codex task.

---

## 11. Out of scope

This document does not define:

- final room UI layout;
- final art style;
- final building art prompts;
- exact upgrade costs;
- full production chain list;
- lab research tree;
- economy balance;
- Codex implementation brief;
- State Connector schema change.

---

## 12. Open questions

1. Which buildings exist in First Day MVP after Vertical Slice?
2. Should Dog House be the first room-window system, or Laboratory?
3. How many rooms can a building have before UI becomes heavy?
4. Should production room windows pause, slow or continue live simulation?
5. Should dogs physically enter building anchors before appearing in room windows?
6. How should main strip show that a dog is inside a room?
7. Which building upgrades are capacity vs comfort vs method vs story?
8. Which room states must be visible in Workbench first?
9. Should room windows be modal or side panels?
10. How to keep room decoration from becoming power min-max?

---

## 13. Acceptance criteria

R-12 Building System is complete enough to move to Production Chains when:

1. Building is defined as anchor + room/detail window.
2. Building is framed as place where dogs act, not passive machine.
3. First building catalog exists.
4. Dog House, Road Sign, Storage, Kitchen, Packing, Delivery, Laboratory and Garden/Tree are covered.
5. Production chain language keeps dogs as active agents.
6. Upgrade axes are defined beyond pure speed/output.
7. Assignment model is soft and non-punitive.
8. Room-window references are linked.
9. Workbench direction is sketched without immediate Codex task.
10. Open questions are listed.

---

## 14. Next recommended document

Next Game Designer task:

```text
STEAM_DESKTOP__Production_Chains_v1.md
```

Production Chains should now be designed as flows of dog actions across places and rooms.

---

## 15. Changelog

### 2026-06-30 — v1 created

- Created Building System v1.
- Defined core model: main strip anchor + room/detail window.
- Fixed principle: buildings do not produce by themselves; dogs act inside/around buildings.
- Added first building catalog and room-window direction.
- Added upgrade axes, assignment model and Workbench fields.
