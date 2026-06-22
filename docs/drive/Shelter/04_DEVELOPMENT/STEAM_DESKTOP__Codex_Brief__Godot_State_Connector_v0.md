# STEAM_DESKTOP — Codex Brief — Godot State Connector v0

Дата: 2026-06-29
Роль документа: Codex Implementation Brief / Internal Game Design Tool
Статус: accepted / ready for Codex
Продукт: Steam/Desktop idle always-on-top strip
Recommended Codex reasoning level: **очень высокий**

## 0. Purpose

Создать первый dev-only connector, через который внешние инструменты и ChatGPT-сессии смогут читать live state запущенного Godot-прототипа Shelter.

Это **не отдельный systems simulator** и не замена Godot-логики. Godot остаётся единственным источником симуляции, task flow, ресурсов, собак, очередей и событий. Connector только экспортирует состояние из живой Godot-сцены в простой read-only формат.

Цель v0 — дать Game Designer / Producer / Codex / ChatGPT способ inspect-ить состояние игры через live read-only запросы и периодический file snapshot:

- через локальный HTTP endpoint;
- через JSON snapshot-файл как fallback для локального файлсервера;
- позже, при явном включении, через tunnel-ready URL, если ChatGPT-сессии удобнее открыть ссылку.

## 1. Producer approval note

Producer approval: accepted on 2026-06-29.

Этот brief заменяет направление старого `Systems Simulator v0`.

Причина замены: standalone simulator вне Godot запрещён. Нужен connector к реальному Godot-state, чтобы не разводить две независимые модели мира.

Old brief archived as superseded:

```text
docs/drive/Shelter/99_ARCHIVE/STEAM_DESKTOP__Codex_Brief__Systems_Simulator_v0__SUPERSEDED_BY_GODOT_STATE_CONNECTOR.md
```

This document is now ready for Codex implementation.

## 2. Mandatory sources

Codex must read before implementation:

- `PROJECTS_RULES.md`
- `AGENTS.md`
- `README.md`
- `steam/AGENTS.md`
- `steam/README.md`
- `docs/repo/status/CODEX_STATUS.md`
- `docs/drive/Shelter/00_START_HERE/02_DECISIONS.md`, especially D-010, D-014, D-017 and D-018
- `docs/drive/Shelter/00_START_HERE/000_ROLE_CODEX.md`
- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Game_Systems_Roadmap_v1.md`
- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Vertical_Slice_Scope_Lock_v1.md`
- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Task_Flow_Contract_v1.md`
- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Object_Contract_v1.md`
- `docs/repo/dev/steam-vertical-slice-prototype.md`
- `docs/drive/Shelter/99_ARCHIVE/STEAM_DESKTOP__Codex_Brief__Systems_Simulator_v0__SUPERSEDED_BY_GODOT_STATE_CONNECTOR.md` only as superseded context, not as implementation direction

If any path moved, find the current equivalent through local repository search.

## 3. Core rule

Godot is the source of truth.

Connector v0 must:

- read state from the running Godot scene / prototype;
- expose snapshots;
- avoid changing gameplay state;
- avoid implementing a separate task scheduler, balance model, production chain, dog system or resource simulation outside Godot.

External tools may display, analyze and compare snapshots. They must not simulate Shelter gameplay independently.

## 4. Scope

Build a local dev-only Godot State Connector v0.

Required capabilities:

- run only when explicitly enabled by dev flag or dev command;
- export a JSON state snapshot on a configurable cadence;
- default file snapshot cadence: **5 seconds**, to avoid unnecessary filesystem churn and background load;
- provide a local HTTP read-only endpoint;
- provide a JSON file snapshot fallback;
- document how ChatGPT can access the state by opening a link or reading the snapshot file through local-file access;
- keep the connector separate from player-facing UI and production gameplay.

Suggested transport modes:

1. **Local HTTP mode**
   - Default dev mode.
   - Bind to `127.0.0.1` by default.
   - Endpoints:
     - `GET /health`
     - `GET /schema`
     - `GET /state`

2. **File snapshot mode**
   - Godot writes a JSON snapshot at a predictable dev path.
   - Intended as fallback for ChatGPT local-file access.
   - Default write interval: 5 seconds.
   - Write interval must be configurable from dev launch flags or environment-backed launch script settings.
   - Snapshot should be overwritten, not appended forever.
   - Avoid generated log growth.

3. **Tunnel-ready HTTP mode**
   - Optional and explicitly enabled.
   - Same read-only endpoints, but safe to expose through a user-managed tunnel.
   - Must require an ephemeral token or similarly simple access guard.
   - Must be documented as dev-only and temporary.

## 5. Required snapshot content

`/state` and the JSON snapshot file should include, if available in the current Godot prototype:

- connector metadata:
  - schema version;
  - build/dev mode;
  - timestamp;
  - tick / elapsed time;
  - scene name;
  - connector transport mode;
- order state:
  - active order id;
  - order status;
  - next expected player action if known;
- dogs:
  - id;
  - display name;
  - role tags;
  - innate traits;
  - learned abilities placeholder if present;
  - equipment;
  - current task;
  - current visible state;
  - availability / fatigue placeholder if present;
- tasks and queues:
  - task id;
  - type;
  - status;
  - source object;
  - target object;
  - assigned dog;
  - resource;
  - blocked reason if any;
  - current phase if present;
- buildings / stations:
  - Road Sign;
  - Storage;
  - Kitchen;
  - Packing Table;
  - Delivery Van Endpoint;
  - station state;
  - queue ids;
- resources:
  - Oat Crate;
  - Pumpkin Crate;
  - Protein Packet;
  - Packaging Bag;
  - Food Mix;
  - Food Bag;
  - locations / inventories;
- production chain:
  - high-level chain progress from trip to delivery;
  - waiting/blocking states;
- event log:
  - recent events such as task created, task assigned, dog started moving, resource delivered, production completed, task blocked, delivery completed;
- debug/performance:
  - FPS / frame time if already available;
  - node count or other cheap counters if already available.

Missing fields may be `null`, empty arrays or documented as not currently implemented. Do not invent final systems that do not exist in Godot yet.

## 6. ChatGPT access requirements

The connector should support at least two practical ChatGPT access paths:

1. **Open link path**
   - User / Codex starts Godot connector.
   - User gives ChatGPT a local or tunneled URL.
   - ChatGPT opens `/state` or a small read-only inspector URL.

2. **Local file path**
   - Godot writes snapshot JSON.
   - ChatGPT reads the file through local-file access.

The brief does not require deciding the final ChatGPT product workflow. v0 only needs enough transport flexibility to test which access mode is reliable.

## 7. Out of scope

Do not implement in v0:

- standalone simulator outside Godot;
- duplicate task scheduler outside Godot;
- duplicate resource economy outside Godot;
- separate balance engine outside Godot;
- production service;
- database;
- cloud deployment;
- auth system beyond simple ephemeral dev token for tunnel-ready mode;
- account system;
- write/control commands over the connector;
- remote mutation of game state;
- player-facing UI;
- monetization;
- charity reporting;
- Browser Extension UX;
- production art;
- full balancing model;
- final dog progression model before Game Designer docs exist.

## 8. Expected implementation zones

Suggested zones:

```text
steam/scripts/dev_tools/
steam/tools/
docs/repo/dev/
docs/repo/status/CODEX_STATUS.md
steam/README.md
```

Possible implementation forms:

- a dev-only Godot node or autoload-like helper attached to the Vertical Slice prototype when a launch flag is present;
- a Godot `HTTPServer` / `TCPServer`-based minimal read-only endpoint if feasible in current Godot version;
- file snapshot writer from Godot using regular Godot file APIs;
- optional small static read-only inspector page if it only visualizes Godot snapshots and contains no simulation logic.

If Codex chooses a different implementation location, document why.

## 9. Security / access boundaries

Default mode should be conservative:

- bind HTTP to localhost by default;
- read-only endpoints only;
- no command endpoint in v0;
- no game-state mutation;
- no secrets, credentials or local env files committed;
- no persistent auth material in repo.

Tunnel-ready mode may be added only if:

- it is explicitly enabled by launch flag;
- token is generated or passed locally at launch;
- token is not committed;
- docs explain that tunnel URLs are temporary dev access, not production service.

If implementing tunnel-ready mode requires a real external service or dependency, stop and ask Producer / Codex owner.

## 10. Acceptance criteria

v0 is acceptable if:

1. Godot prototype can be launched with a documented dev connector command.
2. Connector is disabled in normal player/prototype launch unless explicitly enabled.
3. `/health` reports the connector is alive.
4. `/schema` reports the current snapshot schema.
5. `/state` returns valid JSON from the running Godot scene.
6. JSON snapshot file is written and refreshed at a configurable cadence, defaulting to 5 seconds.
7. Snapshot includes dogs, tasks, buildings/stations, resources, active order/chain progress and recent events to the extent available in the current Godot Vertical Slice prototype.
8. D-010 separation of innate traits and equipment is visible in exported dog state.
9. No standalone simulator, duplicate scheduler or duplicate economy model is created outside Godot.
10. No endpoint mutates game state in v0.
11. Documentation explains local HTTP access, file snapshot access and tunnel-ready considerations for ChatGPT.
12. Existing project checks are not broken.
13. `docs/repo/status/CODEX_STATUS.md` is updated.

## 11. Stop conditions

Codex must stop and ask Producer / Game Designer if:

- implementation starts becoming a standalone simulator;
- implementation requires deciding dog progression rules not yet specified by Game Designer;
- implementation requires deciding final balance numbers as product truth;
- connector needs write/control commands in v0;
- connector needs cloud deployment, real auth, account system or persistent external service;
- tunnel mode requires adding a production dependency;
- unclear whether a field belongs to current Godot state or future game design;
- documents conflict on current accepted systems direction.

Codex must ask Art Director only if connector work starts touching visual style or player-facing UI. A plain internal read-only inspector does not require Art Director approval.

## 12. Checks

At minimum:

- run the documented Godot connector launch command;
- verify `/health`, `/schema` and `/state`;
- verify snapshot file exists and updates;
- verify the default snapshot interval is 5 seconds or explicitly documented when overridden;
- validate exported JSON with a simple parser;
- run existing relevant Steam/Godot checks;
- run `git diff --check`;
- ensure no generated junk, tunnel config, logs, tokens or local snapshot files are committed unless intentionally documented and safe.

## 13. Documentation updates after implementation

After implementation Codex must update:

- `docs/repo/status/CODEX_STATUS.md`
- `docs/repo/dev/godot-state-connector.md`
- `steam/README.md` or another relevant launch instruction document

Status must include:

- summary;
- changed files;
- launch command;
- HTTP endpoints;
- snapshot file path;
- checks run;
- assumptions;
- blockers;
- next recommended step.

## 14. Final note

Godot State Connector v0 is an observability bridge, not a gameplay system.

Its job is to let design and AI collaborators inspect the real running prototype without splitting Shelter into “Godot game” and “spreadsheet simulator” versions of reality.
