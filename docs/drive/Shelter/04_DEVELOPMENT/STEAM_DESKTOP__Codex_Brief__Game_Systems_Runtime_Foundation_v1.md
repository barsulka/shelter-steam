# STEAM_DESKTOP — Codex Brief — Game Systems Runtime Foundation v1

Дата: 2026-06-30
Статус: draft for Codex
Роль-владелец постановки: Game Designer / Systems Designer
Рекомендуемый уровень рассуждений Codex: очень высокий

---

## 0. Цель задачи

Собрать в Godot подкапотную runtime-основу игровых систем Shelter Steam/Desktop, чтобы Game Designer мог проверять уже принятые design contracts на живом runtime, а не только в документах.

Задача не про player-facing polish и не про новые механики.

Задача про:

- structured game state;
- runtime state machines;
- dev-only inspection API;
- dev-only control API for accepted test actions;
- JSON save/export/import for test fixtures;
- debug speed multiplier;
- event log;
- сохранение Godot как единственного source of truth.

Главная формула:

> Design contracts v1 are written. Now we need runtime substrate to test them.

---

## 1. Обязательные источники

Codex обязан прочитать перед началом:

### Project / process

- `PROJECTS_RULES.md`
- `AGENTS.md`
- `README.md`
- `docs/repo/status/CODEX_STATUS.md`
- `docs/drive/Shelter/00_START_HERE/03_PROJECT_PHILOSOPHY.md`
- `docs/drive/Shelter/00_START_HERE/04_SHELTER_STRESS_TESTS.md`
- `docs/drive/Shelter/00_START_HERE/02_DECISIONS.md` — D-017, D-018, D-019, D-020

### Existing connector docs

- `docs/repo/api/godot-state-connector.openapi.yaml`
- `docs/repo/dev/godot-state-connector.md`
- existing Godot State Connector / Control Connector implementation in repo

### Steam/Desktop systems contracts

- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Dog_Progression_Model_v1.md`
- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Ability_Source_Loop_v1.md`
- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Ability_Catalog_v1.md`
- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Dog_Life_Model_v1.md`
- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Building_System_v1.md`
- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Production_Chains_v1.md`
- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Laboratory_Research_Tree_v1.md`
- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Economy_Balance_Foundations_v1.md`
- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Core_Gameplay_Loop_Validation_v1.md`
- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Game_Design_Systems_Workbench_Requirements_v1.md`

---

## 2. Scope

### 2.1 Implement runtime foundation

Implement a structured in-Godot game systems runtime foundation for:

- dogs;
- dog identity / traits / habits / helper effects;
- dog current activity and movement state;
- buildings;
- anchors;
- rooms;
- room assignments;
- activities;
- production chains;
- routes;
- House of Curiosity / research rooms;
- economy of things;
- economy of life as event/state placeholders;
- event log.

This does not need final game balance.

This does need stable ids, structured state and testable transitions.

### 2.2 Expand `/state`

Expand the existing Godot State Connector `/state` so Game Designer can inspect the runtime foundation.

Required top-level groups, if feasible:

```text
game
dogs
routes
production_chains
buildings
rooms
house_of_curiosity
economy
events
debug
```

If a group is not implemented yet, expose it as an empty structured object/array with `implemented: false` or equivalent explicit marker, not by silently omitting it.

### 2.3 Add dev-only API actions

Add narrow, explicit dev-only API actions needed for design testing.

Required capabilities:

- set debug speed multiplier;
- export current state as JSON;
- import/load test state from JSON;
- list available test fixtures;
- load named test fixture;
- start accepted test route;
- assign dog to accepted activity/room;
- start accepted House of Curiosity research node;
- advance or tick debug time only through accepted debug-time surface, if architecturally safe.

All actions must be dev-only and token-protected according to existing connector rules.

Do not add generic arbitrary command execution.

Do not add player-facing cheats.

### 2.4 JSON save/export/import

Add JSON state export/import suitable for Game Designer testing.

Requirements:

- export current runtime state to JSON;
- import JSON state into local prototype runtime;
- preserve stable ids;
- include schema version;
- include migration/compatibility note if schema changes;
- provide at least 3 test fixtures.

Suggested fixtures:

```text
first_day_empty_coop.json
warm_food_delivery_mid_chain.json
house_of_curiosity_learning_session.json
```

Fixtures should live in a clear repo location chosen by Codex, documented after implementation.

### 2.5 Debug speed multiplier

Add dev-mode game speed multiplier:

```text
1x / 2x / 3x / 5x / 10x
```

Requirements:

- visible in `/state.debug`;
- controllable through dev API;
- affects simulation/game systems timers consistently;
- does not break connector/capture endpoints;
- clearly dev-only;
- default is 1x.

### 2.6 Event log

Add structured event log for design inspection.

Event tags should support at least:

- dog_action;
- movement;
- route;
- production_chain;
- building;
- room;
- research;
- economy;
- habit_progression;
- helper_effect;
- blocked_state;
- debug.

Event shape should include:

```text
id
time
tag/type
dog_ids
place/building/room ids when relevant
chain/research ids when relevant
message/summary
payload
```

The event log is for dev/design inspection, not final player UI.

---

## 3. Out of scope

Codex must NOT:

- invent new gameplay systems not present in contracts;
- change player-facing product scope;
- create a standalone simulator;
- create a separate source of truth outside Godot;
- add final player UI for these systems;
- solve final balance numbers;
- add monetization or charity claims;
- add gacha/reroll/pay-to-speed mechanics;
- replace dog actions with invisible resource conversion;
- remove visible cause-and-effect from existing Vertical Slice;
- change visual direction / art style.

If a design contract is ambiguous, stop and ask Game Designer/Producer.

---

## 4. Required state model direction

Codex may choose concrete implementation architecture, but state exposed through `/state` should be understandable to Game Designer.

### 4.1 Dog state

Expose per dog:

```text
id
display_name
identity
character_traits
innate_traits
learned_habits
helper_effects
equipment
preferences
activity_experience
current_activity
movement_state
current_place/current_anchor/current_room
assignment
recent_events
```

### 4.2 Activity state

Represent current activity as more than one flat label.

Needed examples:

```text
activity_group: learning
activity_detail: reading_book
location: house_of_curiosity.library
```

```text
activity_group: learning
activity_detail: sitting_at_desk
location: house_of_curiosity.classroom
```

```text
activity_group: movement
activity_detail: walking_to_house_of_curiosity
from: dog_house
to: house_of_curiosity
```

This is important because Game Designer needs to verify that different dog-life states are not collapsed into one vague `learning` state.

### 4.3 Production chain state

Expose:

```text
id
state
current_step
places
dogs_involved
required_inputs
available_inputs
outputs
blocked_reason
quality_state
player_confirmation_required
recent_events
```

### 4.4 Buildings and rooms state

Expose:

```text
building id/type
main_strip_anchor_state
rooms
stations
assigned_dogs
current_life_activities
queue_state
unlocked_routines
blocked_reason
recent_events
```

### 4.5 House of Curiosity state

Use player-facing concept `House of Curiosity / Дом любопытства`, not primary “Laboratory” language.

Expose rooms/branches such as:

- classroom;
- library;
- notes room;
- soft methods workshop;
- observation corner;
- trial table.

Expose:

```text
active_research
assigned_dogs
self_learning_state
progress
dependencies
unlocks
recent_events
```

### 4.6 Economy state

Expose both:

```text
economy.things
```

and:

```text
economy.life
```

`economy.things` may include physical inventory, active inputs, active outputs.

`economy.life` may include early placeholders/events for dog time allocation, inspiration events, comfort events, story events, relationship events.

---

## 5. Acceptance criteria

Task is accepted when:

1. Godot remains the single source of truth.
2. No standalone simulator is created.
3. Runtime state includes structured dogs, buildings/rooms, production chains, routes, research/House of Curiosity, economy and event log at least as v1 scaffold.
4. `/state` exposes the new structured state.
5. Dev speed multiplier supports 1x/2x/3x/5x/10x and is visible in state.
6. JSON export/import exists for local prototype test state.
7. At least 3 test fixtures exist and are documented.
8. Dev API exposes narrow accepted actions for loading fixtures, assigning dogs, starting test routes/research and setting speed.
9. Event log records key runtime transitions.
10. Existing connector endpoints continue to work.
11. OpenAPI docs are updated if endpoints/schema change.
12. Relevant repo docs are updated.
13. `docs/repo/status/CODEX_STATUS.md` is updated with summary, changed files, tests and known limitations.
14. No final player UI or new product scope is introduced.

---

## 6. Suggested implementation sequence

1. Read required docs.
2. Inspect existing Godot runtime/connector architecture.
3. Design internal state structs/resources/classes with stable ids.
4. Add game systems runtime scaffold without breaking Vertical Slice.
5. Expand `/state` schema.
6. Add event log.
7. Add speed multiplier.
8. Add JSON export/import and fixtures.
9. Add narrow dev API actions.
10. Update OpenAPI and docs.
11. Run tests / smoke checks.
12. Update `CODEX_STATUS.md`.

---

## 7. Stop conditions

Stop and ask before proceeding if:

- implementation would require changing accepted gameplay contracts;
- existing Vertical Slice architecture conflicts with runtime foundation in a non-trivial way;
- JSON import/export creates unsafe overwrite behavior beyond local dev mode;
- speed multiplier breaks core Godot timing or capture systems;
- state schema cannot represent dog activity detail without design clarification;
- Workbench requirements conflict with current connector security constraints;
- any shortcut would remove visible dog action / physical cause-and-effect.

---

## 8. Final response expected from Codex

Codex should report:

- files changed;
- new endpoints / changed endpoints;
- save fixture paths;
- how to run;
- how to inspect `/state`;
- how to set speed multiplier;
- how to export/import test state;
- tests run;
- known limitations;
- what docs were updated.

---

## 9. Changelog

### 2026-06-30 — v1 created

- Created Codex brief for Game Systems Runtime Foundation.
- Scope includes structured runtime state, dev API, JSON save/import/export, fixtures, speed multiplier and event log.
