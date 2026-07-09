# STEAM_DESKTOP — Game Systems Roadmap v1

Дата: 2026-06-30
Роль документа: Game Systems Roadmap / Completed Systems Contract Roadmap
Статус: completed reference / history
Read policy: do not use as current active roadmap; read when inspecting R-09..R-16 systems contracts or Workbench origins.
Продукт: Steam/Desktop idle always-on-top strip
Роль-владелец: Game Designer / Systems Designer

## 0. Назначение

Этот документ фиксирует новую critical path ветку Game Designer после первого Steam Vertical Slice.

Producer decision: текущий Vertical Slice считается достаточно доказанным на уровне **gameplay proof** — product/game contracts, task chain, resource flow, player agency, D-010 trait/equipment separation and playable prototype. Финальный **visual proof** / readability / dog silhouettes / placeholder quality / strip composition / production art remains Art Director responsibility and does not block Game Designer systems work.

Этот roadmap не утверждает, что Vertical Slice полностью завершён как visual/product slice. Он фиксирует, что Game Designer может двигаться дальше в systems design без ожидания final visual acceptance.

## 1. Current foundation

As of 2026-06-30:

- Vertical Slice has Product Contract / Object Contract / Task Flow Contract / Scope Lock / Playtest Checklist.
- Codex implemented the first playable Vertical Slice prototype.
- Godot State Connector exists.
- Godot Control Connector exists.
- Viewport Capture API exists.
- Art QA capture packs exist.
- Godot is accepted as the source of truth for live game state.

Producer interpretation:

- Gameplay proof exists enough for Game Designer to continue systems work.
- Visual proof remains open and should be resolved by Art Director without blocking Game Designer systems roadmap.
- Internal systems tooling should build on the real running Godot runtime, not on a standalone simulator.

## 2. Scope boundary

Game Designer owns systems work:

- dog progression;
- ability source loops;
- ability catalog;
- buildings and production chains as game systems;
- laboratory and research tree;
- activities catalog;
- economy and balance foundations;
- Game Design Systems Workbench requirements as design/tooling contract.

Game Designer does not own final visual acceptance:

- readability verdict 96 / 144 / 216 px;
- visual hierarchy;
- dog silhouettes as final art;
- placeholder quality as art quality;
- UI look;
- production art;
- art bible;
- asset prompts;
- strip composition as visual design, except gameplay constraints.

Art Director owns visual acceptance and usability/readability of the Steam strip.

Codex owns implementation of accepted briefs and connector/tooling contracts.

## 3. Core tooling principle

No standalone game simulator.

Godot remains the only source of truth for runtime game state.

Game Design Systems Workbench should evolve as:

- Godot runtime state;
- State Connector `/state`;
- Control Connector / control page;
- Viewport Capture API;
- design-facing inspector views over real runtime data;
- gradually richer schema as Game Designer defines systems.

External tools may inspect, visualize and compare live Godot state. They must not become a second independent gameplay model.

## 4. D-020 operating filters

Перед началом каждого нового systems-документа Game Designer должен явно ответить:

1. Как эта система делает жизнь кооператива богаче?
2. К какому слою она относится: ядро, углубление или атмосфера?
3. Не пытается ли эта система заменить production core бытовым симулятором?
4. Не превращает ли она Shelter в factory spreadsheet, где растут только числа?

D-020 фильтр применяется ко всем задачам R-09..R-16.

## 5. Roadmap tasks

### R-09 — Dog Progression Model

Статус: done.

Слой D-020: ядро.

Приоритет: highest.

Цель: определить системную модель развития собаки без превращения собак в generic stat units.

Вопросы:

- Какие слои есть у собаки: identity, innate traits, acquired abilities, equipment, preferences, activity experience, mood/energy later, room/decor influence later?
- Что является постоянным, что изменяемым, что временным?
- Как D-010 применяется к progression?
- Что игрок развивает, а что уважает как личность собаки?
- Какие элементы должны попасть в `/state.dogs[]` в будущем?

Результат:

`STEAM_DESKTOP__Dog_Progression_Model_v1.md`

### R-10 — Ability Source Loop

Статус: done.

Слой D-020: ядро.

Приоритет: high.

Цель: описать, как собака получает способности через деятельность, опыт, обучение, события, маршруты, здания and gentle long-term progression.

Важно: способности не должны быть paid gacha, reroll pressure or min-max punishment.

Результат:

`STEAM_DESKTOP__Ability_Source_Loop_v1.md`

### R-11 — Ability Catalog

Статус: done.

Слой D-020: ядро -> углубление.

Приоритет: high.

Цель: создать первый каталог способностей собак: innate traits, acquired abilities, equipment-linked bonuses, activity preferences and situational modifiers.

Уточнение v1: каталог оформлен как Character Traits & Helper Effects Catalog. Основной термин — `черты характера`; equipment/food/fruit/building/research modifiers отделены как `вспомогалки`.

Результат:

`STEAM_DESKTOP__Ability_Catalog_v1.md`

### R-12 — Buildings & Production Chains

Статус: done.

Слой D-020: ядро.

Приоритет: high.

Цель: описать здания, functional props and production chains как game systems: levels, queues, inputs, outputs, upgrades, responsibilities, unlocks.

Важно: это не visual building design and not asset prompt work.

Результаты разделены на два документа:

- `STEAM_DESKTOP__Building_System_v1.md` — done;
- `STEAM_DESKTOP__Production_Chains_v1.md` — done.

### R-13 — Laboratory / Research Tree

Статус: done.

Слой D-020: ядро -> углубление.

Приоритет: medium / high.

Цель: определить роль лаборатории и research tree без sci-fi/combat tone.

Вопросы:

- Что исследуется?
- Как исследования открываются?
- Какие ресурсы нужны?
- Как исследования связаны с dogs, activities, buildings, recipes and production chains?
- Как избежать ощущения холодной фабрики или spreadsheet-first progression?

Результат:

`STEAM_DESKTOP__Laboratory_Research_Tree_v1.md`

Уточнение v1: player-facing concept reframed from `Laboratory` into one building `House of Curiosity / Дом любопытства` with multiple rooms acting as disguised research branches.

### R-14 — Activities Catalog

Статус: done.

Слой D-020: углубление, with ядро-facing constraints.

Приоритет: high.

Цель: описать виды деятельности собак как systems layer: поездки, выгрузка, переноска, готовка, фасовка, упаковка, ремонт, уход, отдых, исследование, декорирование, social/cozy actions.

Уточнение v1: задача оформлена шире как Dog Life Model / Life in the Co-op. Activities Catalog является частью модели жизни собачьего кооператива, а не только списком технических задач.

Важно: это gameplay/system catalog, not animation list and not asset prompt pack.

Результат:

`STEAM_DESKTOP__Dog_Life_Model_v1.md`

### R-15 — Economy & Balance Foundations

Статус: done.

Слой D-020: ядро.

Приоритет: medium / high.

Цель: определить foundations for economy and balance without locking final numbers too early.

Вопросы:

- Какие параметры нужны для баланса?
- Где возникают bottlenecks?
- Какие ресурсы progression-critical, а какие optional/cozy?
- Как сохранить idle rhythm без FOMO and pressure?
- Какие значения должны стать inspectable through State Connector / Workbench?

Результат:

`STEAM_DESKTOP__Economy_Balance_Foundations_v1.md`

### R-15.5 — Core Gameplay Loop Validation

Статус: done.

Слой D-020: validation / governance.

Приоритет: high.

Цель: коротко проверить, что ядро Shelter после R-09..R-15 остаётся производственным собачьим кооперативом, а не factory spreadsheet и не бытовым симулятором.

Результат:

`STEAM_DESKTOP__Core_Gameplay_Loop_Validation_v1.md`

### R-16 — Game Design Systems Workbench

Статус: done at requirements-contract level.

Слой D-020: инструмент / internal design tooling.

Приоритет: high, but dependent on design docs for schema expansion.

Цель: развивать внутреннюю лабораторию гейм-дизайна поверх реально запущенной Godot-игры.

Принцип:

> Godot runtime is the source of truth. Workbench observes and controls accepted dev surfaces; it does not simulate Shelter independently.

Workbench grows through:

- State Connector schema expansion;
- Control Connector page improvements;
- Viewport Capture API;
- `/state` fields for dogs, traits, abilities, equipment, activities, buildings, queues, resources, research, economy and event log;
- design-facing inspection views;
- future strictly whitelisted control actions only when accepted through briefs.

Existing active / implemented briefs and docs:

- `docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Godot_State_Connector_v0.md`
- `docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Godot_Control_Connector_v0.md`
- `docs/repo/api/godot-state-connector.openapi.yaml`
- `docs/repo/dev/godot-state-connector.md`

Future Codex work for Workbench must be assigned through new brief files in `docs/drive/Shelter/04_DEVELOPMENT/` per D-017.

## 5. Current order

1. R-09 — Dog Progression Model. Done: `STEAM_DESKTOP__Dog_Progression_Model_v1.md`.
2. R-10 — Ability Source Loop. Done: `STEAM_DESKTOP__Ability_Source_Loop_v1.md`.
3. R-11 — Ability Catalog. Done: `STEAM_DESKTOP__Ability_Catalog_v1.md`.
4. R-14 — Activities Catalog / Dog Life Model. Done: `STEAM_DESKTOP__Dog_Life_Model_v1.md`.
5. R-12 — Buildings & Production Chains. Done: `STEAM_DESKTOP__Building_System_v1.md` and `STEAM_DESKTOP__Production_Chains_v1.md`.
6. R-13 — Laboratory / Research Tree. Done: `STEAM_DESKTOP__Laboratory_Research_Tree_v1.md`.
7. R-15 — Economy & Balance Foundations. Done: `STEAM_DESKTOP__Economy_Balance_Foundations_v1.md`.
8. R-15.5 — Core Gameplay Loop Validation. Done: `STEAM_DESKTOP__Core_Gameplay_Loop_Validation_v1.md`.
9. R-16 — Game Design Systems Workbench. Done at requirements-contract level: `STEAM_DESKTOP__Game_Design_Systems_Workbench_Requirements_v1.md`.

R-16 is active as direction, but each Codex expansion must wait for a brief with clear scope and should not invent game-design systems ahead of R-09..R-15.

## 6. Layer summary

| Task | Status | D-020 layer |
|---|---|---|
| R-09 Dog Progression Model | done | Ядро |
| R-10 Ability Source Loop | done | Ядро |
| R-11 Ability Catalog | done | Ядро -> углубление |
| R-14 Dog Life Model | done | Углубление, constrained by ядро |
| R-12 Buildings & Production Chains | done | Ядро |
| R-13 House of Curiosity / Research | done | Ядро -> углубление |
| R-15 Economy & Balance Foundations | done | Ядро |
| R-15.5 Core Gameplay Loop Validation | done | Validation / governance |
| R-16 Workbench | done at requirements-contract level | Internal tooling |

## 7. Handoff to Art Director

Art Director continues owning:

- Vertical Slice visual acceptance;
- Capture Pack review;
- readability 216 / 144 / 96;
- dog/action silhouettes;
- placeholder quality;
- UI visual hierarchy;
- strip composition;
- Dog Shape Pack v1;
- production art pipeline.

Game Designer can provide gameplay constraints but should not block systems work waiting for final visual proof.

## 8. Changelog

### 2026-06-30 — R-16 requirements completed

- Created `STEAM_DESKTOP__Game_Design_Systems_Workbench_Requirements_v1.md`.
- Defined Workbench as internal design tool over live Godot runtime.
- Added view families, state schema direction, stress-test support and first Codex brief candidates.
- R-09..R-16 Game Systems roadmap is complete at v1 design-contract level.

### 2026-06-30 — R-15.5 completed

- Created project-wide `04_SHELTER_STRESS_TESTS.md`.
- Created `STEAM_DESKTOP__Core_Gameplay_Loop_Validation_v1.md`.
- Applied Shelter Stress Tests to R-09..R-15.
- Current systems foundation passes with watchpoints.
- R-16 `Game Design Systems Workbench` becomes the next active Game Designer task.

### 2026-06-30 — R-15 completed

- Created `STEAM_DESKTOP__Economy_Balance_Foundations_v1.md`.
- R-15 status changed to done.
- Economy is framed as economy of things + economy of life under D-020.
- R-15.5 `Core Gameplay Loop Validation` becomes the next active Game Designer task.

### 2026-06-30 — D-020 filters added to roadmap

- Added D-020 operating filters for every new systems document.
- Added D-020 layer labels to roadmap tasks.
- Added R-15.5 `Core Gameplay Loop Validation` after R-15 and before R-16.
- Added layer summary table.

### 2026-06-30 — R-13 completed

- Created `STEAM_DESKTOP__Laboratory_Research_Tree_v1.md`.
- Reframed Laboratory into `House of Curiosity / Дом любопытства`.
- Fixed one-building / multi-room model: rooms act as disguised research branches.
- R-15 `Economy & Balance Foundations` becomes the next active Game Designer task.

### 2026-06-30 — R-12 completed

- Created `STEAM_DESKTOP__Building_System_v1.md`.
- Created `STEAM_DESKTOP__Production_Chains_v1.md`.
- R-12 split into Building System and Production Chains and is now complete at v1 systems-contract level.
- Building System defines buildings as main strip anchors + room/detail windows.
- Production Chains defines chains as flows of dog actions across places.
- R-13 `Laboratory / Research Tree` becomes the next active Game Designer task.

### 2026-06-30 — R-14 completed

- Created `STEAM_DESKTOP__Dog_Life_Model_v1.md`.
- R-14 status changed to done.
- R-14 was intentionally reframed from narrow Activities Catalog into Dog Life Model / Life in the Co-op.
- R-12 `Buildings & Production Chains` becomes the next active Game Designer task.

### 2026-06-30 — R-11 completed

- Created `STEAM_DESKTOP__Ability_Catalog_v1.md`.
- R-11 status changed to done.
- The catalog uses `черты характера` as the core design term and separates `вспомогалки` from dog character.
- R-14 `Activities Catalog` becomes the next active Game Designer task.

### 2026-06-30 — R-10 completed

- Created `STEAM_DESKTOP__Ability_Source_Loop_v1.md`.
- R-10 status changed to done.
- R-11 `Ability Catalog` becomes the next active Game Designer task.

### 2026-06-30 — R-09 completed

- Created `STEAM_DESKTOP__Dog_Progression_Model_v1.md`.
- R-09 status changed to done.
- R-10 `Ability Source Loop` becomes the next active Game Designer task.

### 2026-06-30 — v2 aligns with live Godot Workbench direction

- Replaced GS-01..GS-10 numbering with R-09..R-16 as requested by Game Designer.
- Explicitly accepted that Game Designer critical path moves to systems design.
- Replaced standalone simulator direction with Game Design Systems Workbench over live Godot runtime.
- Added State Connector / Control Connector / Viewport Capture API as existing foundation.
- Clarified that Workbench observes and controls accepted dev surfaces, but does not simulate Shelter independently.

### 2026-06-29 — Godot State Connector replaces Systems Simulator

- Standalone Systems Simulator direction cancelled.
- Godot State Connector v0 accepted as active Codex brief.
- Old Systems Simulator brief archived as superseded.
- Reason: Godot must remain the source of truth for live game state; no second independent simulation model.

### 2026-06-29 — v1 created

- Opened Game Systems Roadmap after Producer accepted split between gameplay proof and visual proof.
- Moved Game Designer critical path from Vertical Slice visual acceptance to systems design.
- Added Systems Simulator as initial Codex/tooling branch for Game Designer.
