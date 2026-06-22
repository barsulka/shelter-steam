# STEAM_DESKTOP — Codex Brief — Systems Simulator v0

Дата: 2026-06-29
Роль документа: Codex Implementation Brief / Internal Game Design Tool
Статус: ready for Codex
Продукт: Steam/Desktop idle always-on-top strip
Recommended Codex reasoning level: **очень высокий**

## 0. Purpose

Создать первый внутренний Systems Simulator для Game Designer.

Это не игровой клиент и не player-facing feature. Это локальный dev/design инструмент для проверки будущих систем Steam/Desktop Shelter: собак, задач, очередей, зданий, ресурсов, исследований, production chains, timing and balance hypotheses.

Цель v0 — дать Game Designer лабораторию, где можно видеть состояние мира, запускать симуляцию, ускорять время, менять параметры и анализировать события без ожидания полноценной игровой реализации.

## 1. Mandatory sources

Codex must read before implementation:

- `PROJECTS_RULES.md`
- `AGENTS.md`
- `README.md`
- `docs/repo/status/CODEX_STATUS.md`
- `docs/drive/Shelter/00_START_HERE/02_DECISIONS.md`, especially D-010, D-014, D-017 and D-018
- `docs/drive/Shelter/00_START_HERE/000_ROLE_CODEX.md`
- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Game_Systems_Roadmap_v1.md`
- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Vertical_Slice_Scope_Lock_v1.md`
- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Task_Flow_Contract_v1.md`
- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Object_Contract_v1.md`
- `docs/repo/dev/steam-vertical-slice-prototype.md`

If any path moved, find the current equivalent through local repository search.

## 2. Scope

Build a local internal simulator v0 with a lightweight interface.

Preferred direction:

- local-only tool;
- simple backend + simple HTML frontend, or another lightweight approach if clearly simpler;
- no production service;
- no real account, networking, cloud, DB, auth or external API;
- no player-facing integration;
- no monetization / charity reporting logic.

The simulator should support the first useful model of:

- world state;
- dogs;
- buildings / stations;
- resources;
- tasks;
- queues;
- production chains;
- basic research placeholders;
- simulation clock;
- event log;
- editable parameters.

## 3. Suggested implementation approach

Codex may choose the simplest local implementation that fits the repo, but should prefer small, inspectable code and no heavy dependencies.

Allowed approaches:

- Go local HTTP server + static HTML/JS frontend;
- Python stdlib local HTTP server + static HTML/JS frontend;
- pure static HTML/JS simulator if backend is not needed for v0;
- another lightweight local tool if justified.

Avoid heavy frameworks unless there is a strong reason.

Suggested repo location:

```text
tools/systems_simulator/
```

Suggested docs:

```text
docs/repo/dev/systems-simulator.md
```

If Codex chooses another location, document why.

## 4. Required v0 capabilities

### 4.1 State view

Show current simulation state:

- current time / tick;
- dogs and current dog state;
- tasks and queues;
- buildings/stations;
- resource inventory;
- active production chains;
- event log.

### 4.2 Dogs

Represent at least a few test dogs with:

- id;
- display name;
- role tags;
- innate traits;
- learned abilities placeholder;
- equipment placeholder;
- current task;
- fatigue / availability placeholder if useful.

Respect D-010: innate traits and equipment must be separate layers.

### 4.3 Tasks and queues

Represent task lifecycle:

- pending;
- assigned;
- moving;
- working;
- complete;
- blocked / waiting if needed.

Tasks should include at least:

- trip;
- unload;
- carry;
- cook;
- pack;
- load delivery;
- idle.

### 4.4 Buildings / stations

Represent at least:

- Road Sign;
- Storage;
- Kitchen;
- Packing Table;
- Delivery Van Endpoint.

The tool may later expand to Lab, Workshop, Dog rooms and other buildings, but v0 should stay small.

### 4.5 Resources

Represent at least:

- Oat Crate;
- Pumpkin Crate;
- Protein Packet;
- Packaging Bag;
- Food Mix;
- Food Bag.

### 4.6 Simulation controls

Provide controls to:

- start / pause simulation;
- step one tick;
- run fast for N ticks;
- reset to seed state;
- change at least a few parameters such as task durations, dog speed modifiers or queue priority.

### 4.7 Event log

Show events such as:

- task created;
- task assigned;
- dog started moving;
- resource delivered;
- production completed;
- task blocked;
- delivery completed.

## 5. Out of scope

Do not implement in v0:

- full game client;
- Godot integration;
- real save system;
- real backend service;
- database;
- auth;
- cloud deployment;
- real charity reporting;
- monetization;
- Browser Extension UX;
- production art;
- UI polish;
- full balancing model;
- complete research tree;
- final dog progression model before Game Designer docs exist.

## 6. Acceptance criteria

v0 is acceptable if:

1. Tool can be launched locally with a documented command.
2. UI opens locally and shows state, dogs, tasks, resources, buildings and event log.
3. Simulation can start/pause/step/reset.
4. At least one full Vertical Slice-like chain can be simulated logically from trip to delivery.
5. D-010 separation of innate trait and equipment is visible in simulator state.
6. Parameters can be changed without editing code for at least a few key values.
7. Event log makes task flow and blockers inspectable.
8. Tool is clearly marked internal / non-player-facing.
9. No heavy dependency or production service is added without justification.
10. Documentation explains how to run and extend the simulator.
11. Existing project checks are not broken.
12. `docs/repo/status/CODEX_STATUS.md` is updated.

## 7. Stop conditions

Codex must stop and ask Producer / Game Designer if:

- simulator scope starts turning into player-facing UI;
- implementation requires deciding dog progression rules not yet specified by Game Designer;
- implementation requires deciding final balance numbers as product truth;
- Codex needs to add production dependencies or long-running services;
- tool needs a database, auth, cloud deploy or external API;
- unclear whether a mechanic belongs to simulator v0 or future game design;
- documents conflict on current accepted systems direction.

Codex must ask Art Director only if simulator work starts touching visual style or player-facing UI. For a plain internal tool, Art Director approval is not required.

## 8. Checks

At minimum:

- run the simulator local command or smoke command;
- run any language-specific tests or lint if added;
- run existing relevant repo checks if affected;
- ensure no generated junk, logs, local DB files or build artifacts are committed unless intentionally documented.

## 9. Documentation updates

After implementation Codex must update:

- `docs/repo/status/CODEX_STATUS.md`
- `docs/repo/dev/systems-simulator.md`
- relevant README / launch instructions if a new command is added.

Status must include:

- summary;
- changed files;
- launch command;
- checks run;
- assumptions;
- blockers;
- next recommended step.

## 10. Final note

The Systems Simulator is a design laboratory. It must help Game Designer reason about systems without turning the actual game into spreadsheet-first gameplay.
