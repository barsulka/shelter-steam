# STEAM_DESKTOP — Game Design Systems Workbench Requirements v1

Дата: 2026-06-30
Роль документа: Game Design / Tooling Requirements Contract
Статус: draft v1
Продукт: Steam/Desktop idle always-on-top strip
Roadmap task: R-16 — Game Design Systems Workbench
Роль-владелец: Game Designer / Systems Designer

Основано на:

- `docs/drive/Shelter/00_START_HERE/03_PROJECT_PHILOSOPHY.md`
- `docs/drive/Shelter/00_START_HERE/04_SHELTER_STRESS_TESTS.md`
- `STEAM_DESKTOP__Core_Gameplay_Loop_Validation_v1.md`
- `STEAM_DESKTOP__Economy_Balance_Foundations_v1.md`
- `STEAM_DESKTOP__Production_Chains_v1.md`
- `STEAM_DESKTOP__Building_System_v1.md`
- `STEAM_DESKTOP__Laboratory_Research_Tree_v1.md`
- `docs/repo/api/godot-state-connector.openapi.yaml`
- D-017, D-018, D-019, D-020

---

## 0. Назначение

Этот документ определяет требования Game Designer к Game Design Systems Workbench.

Workbench — это internal design tool поверх реально запущенной Godot-игры.

Он нужен, чтобы Game Designer мог наблюдать, проверять и анализировать:

- dog progression;
- dog character / habits / helper effects;
- production chains;
- buildings, anchors and rooms;
- House of Curiosity / research;
- economy of things and economy of life;
- idle rhythm;
- Shelter Stress Tests.

Workbench не является player-facing UI.

Workbench не является standalone simulator.

---

## 1. Non-negotiable principles

### 1.1 Godot runtime is source of truth

Workbench MUST observe live Godot runtime state through accepted connector surfaces.

Workbench MUST NOT simulate Shelter independently.

If Workbench and Godot disagree, Godot wins and Workbench/schema must be fixed.

### 1.2 No second game model

Workbench MUST NOT contain an independent gameplay model for:

- dog progression;
- production chain state;
- economy values;
- research progression;
- room activity;
- idle logic.

It may visualize, filter, compare and annotate live data.

### 1.3 Internal tool, not player UI

Workbench may be table-heavy and JSON-heavy.

Player-facing UI must remain warm, compact and dog-life oriented.

Workbench views MUST NOT be copied into player UI without Art Director / UX / Producer review.

### 1.4 Stress-test aware

Workbench should help detect:

- factory spreadsheet drift;
- tamagotchi / life-sim drift;
- dog-as-skin risk;
- invisible production;
- over-micromanagement;
- idle guilt/FOMO risk.

---

## 2. Existing connector foundation

Existing foundation includes:

- `GET /health`;
- `GET /schema`;
- `GET /state`;
- `GET /control`;
- `GET /control/capabilities`;
- window show/hide/toggle controls;
- screenshot capture;
- short PNG frame-sequence capture;
- connector stop;
- token-protected dev surface.

Existing OpenAPI contract:

```text
docs/repo/api/godot-state-connector.openapi.yaml
```

R-16 expands requirements. It does not directly assign Codex implementation.

Future implementation requires separate Codex briefs in:

```text
docs/drive/Shelter/04_DEVELOPMENT/
```

per D-017.

---

## 3. Workbench view families

### 3.1 World Overview

Purpose:

- answer what the co-op is currently doing.

Should show:

- elapsed time;
- current chain state;
- active route/trip;
- active dogs;
- idle/resting dogs;
- active buildings/rooms;
- blocked states;
- recent events.

Stress tests supported:

- Idle Test;
- Production Core Test;
- Excel Test.

### 3.2 Dogs View

Purpose:

- inspect dogs as characters, not stat bundles.

Should show per dog:

- identity;
- innate traits / character traits;
- learned habits;
- helper effects;
- equipment;
- preferences;
- activity experience;
- current activity;
- current place / room;
- recent dog events;
- growth opportunities.

Stress tests supported:

- Dog Test;
- Love Test;
- Memory Test.

### 3.3 Production Chains View

Purpose:

- inspect physical cause-and-effect in production.

Should show:

- active chain id;
- current step;
- state;
- required inputs;
- available inputs;
- dogs involved;
- places involved;
- blocked reason;
- quality state;
- last visible event;
- player confirmation required.

Stress tests supported:

- Production Core Test;
- Excel Test;
- Factory Test.

### 3.4 Buildings & Rooms View

Purpose:

- inspect buildings as places where dogs act.

Should show:

- building id/type;
- main strip anchor state;
- rooms;
- stations;
- assigned dogs;
- current room activities;
- queues;
- unlocked routines;
- comfort/story state;
- blocked reasons.

Stress tests supported:

- Factory Test;
- The Sims / Tamagotchi Test;
- Layer Test.

### 3.5 House of Curiosity View

Purpose:

- inspect research as room-based learning.

Should show:

- rooms/branches;
- assigned dogs;
- active research;
- self-learning state;
- dependencies;
- output type;
- unlocked activities/routines/helpers/stories;
- dog contributors.

Stress tests supported:

- D-020 Test;
- Production Core Test;
- The Sims / Tamagotchi Test.

### 3.6 Economy View

Purpose:

- inspect economy of things and economy of life together.

Should show:

- physical inventory;
- chain inputs/outputs;
- bottlenecks;
- route cadence;
- delivery cadence;
- dog time allocation;
- activity experience flow;
- inspiration events;
- comfort events;
- story events;
- relationship/mentorship events, if implemented.

Stress tests supported:

- Excel Test;
- D-020 Test;
- Factory Test.

### 3.7 Event Log View

Purpose:

- make dog-life and production causality inspectable.

Should show chronological events with tags:

- dog action;
- production step;
- route event;
- building/room event;
- research event;
- habit/progression event;
- helper effect event;
- story/postcard event;
- blocked/resolved event.

Event log is essential for debugging Shelter identity.

### 3.8 Stress Test Dashboard

Purpose:

- help Game Designer manually check Shelter Stress Tests against runtime.

Should show signals for:

- dog activity diversity;
- dog idle vs work time;
- visible production events;
- number of story/habit events;
- blocked state frequency;
- room activity distribution;
- raw inventory growth vs dog-life events;
- production chain completion cadence.

This dashboard does not auto-judge the game. It provides evidence for human review.

---

## 4. Proposed `/state` schema expansion direction

This is a design requirement direction, not an implementation brief.

### 4.1 Top-level state groups

Future `/state` SHOULD eventually expose:

```text
game
connector
dogs
routes
production_chains
buildings
rooms
house_of_curiosity
economy
events
stress_test_signals
debug
```

### 4.2 Dogs state

Minimum useful future shape:

```json
{
  "id": "dog.dachshund_intro",
  "display_name": "Такса",
  "identity": {},
  "character_traits": [],
  "innate_traits": [],
  "learned_habits": [],
  "helper_effects": [],
  "equipment": [],
  "preferences": {},
  "activity_experience": {},
  "current_activity": {},
  "current_place": null,
  "recent_events": []
}
```

### 4.3 Production chain state

```json
{
  "id": "chain.warm_food_delivery_intro",
  "state": "packing",
  "current_step": "pack_food_bag",
  "places": [],
  "dogs_involved": [],
  "required_inputs": [],
  "available_inputs": [],
  "outputs": [],
  "blocked_reason": null,
  "quality_state": "neatly_packed",
  "player_confirmation_required": false
}
```

### 4.4 Buildings / rooms state

```json
{
  "id": "building.house_of_curiosity",
  "type": "house_of_curiosity",
  "anchor_state": {},
  "rooms": [
    {
      "id": "room.library",
      "room_type": "library",
      "assigned_dogs": [],
      "current_life_activities": [],
      "stations": [],
      "queue_state": {},
      "unlocked_routines": [],
      "recent_events": []
    }
  ]
}
```

### 4.5 Economy state

```json
{
  "things": {
    "physical_inventory": {},
    "active_inputs": [],
    "active_outputs": []
  },
  "life": {
    "dog_time_allocation": {},
    "inspiration_events": [],
    "comfort_events": [],
    "story_events": [],
    "relationship_events": []
  },
  "cadence": {
    "route_cadence": null,
    "delivery_cadence": null,
    "blocked_state_frequency": null
  }
}
```

### 4.6 Stress-test signals

```json
{
  "dog_action_events_recent": 12,
  "production_events_recent": 8,
  "story_events_recent": 2,
  "raw_inventory_growth_recent": 5,
  "blocked_states_recent": 1,
  "room_activity_events_recent": 3,
  "dogs_without_identity_fields": 0,
  "chains_with_invisible_conversion": 0
}
```

Signals are evidence, not automatic verdicts.

---

## 5. Allowed dev controls

R-16 primarily needs observability.

Allowed future controls MAY include only narrow, explicitly approved dev actions:

- pause/resume debug time;
- speed presets for debug;
- capture screenshot;
- capture short frame sequence;
- focus/follow dog in debug view;
- filter dashboard view;
- select accepted local test scenario in dev mode;
- reset local prototype state only if a future brief explicitly accepts it.

Controls MUST NOT:

- mutate real player progression;
- silently change gameplay contracts;
- create hidden production shortcuts;
- bypass D-017 briefs;
- become player-facing without Producer/UX review.

---

## 6. First implementation candidates

These are candidates for future Codex briefs, not tasks assigned by this document.

### Candidate A — State Schema Expansion v1

Goal:

- add structured dogs, production_chains, buildings/rooms and events to `/state`.

Priority:

- highest for Workbench usefulness.

### Candidate B — Design Dashboard HTML v0

Goal:

- extend control page or create dev-only dashboard showing key `/state` groups.

Priority:

- high after schema exists.

### Candidate C — Event Log v0

Goal:

- expose chronological event log for production/dog/room/research/economy events.

Priority:

- high for stress testing.

### Candidate D — Stress Signals v0

Goal:

- expose simple counters/signals for Shelter Stress Test review.

Priority:

- medium; useful after event log.

### Candidate E — Capture + State Bundle v0

Goal:

- capture screenshot/frame sequence plus nearby `/state` snapshot as one review bundle.

Priority:

- medium/high for cross-role review.

---

## 7. Codex brief requirements

Any Codex Workbench task must include:

- exact source docs;
- scope;
- out of scope;
- endpoint/schema changes;
- dev-only/security constraints;
- acceptance criteria;
- required docs update;
- stop conditions;
- no gameplay invention clause.

Recommended Codex reasoning level for Workbench schema tasks:

```text
очень высокий
```

Reason:

Workbench touches architecture, API contract, dev tooling and design semantics.

---

## 8. Acceptance criteria for R-16

R-16 is complete enough at requirements level when:

1. Workbench is defined as internal tool over live Godot runtime.
2. No standalone simulator / second game model is allowed.
3. View families are defined.
4. Future `/state` schema direction is sketched.
5. Stress Test support is included.
6. Allowed controls are bounded.
7. First Codex brief candidates are listed without assigning implementation prematurely.
8. Codex brief requirements are defined.

Status: complete at requirements-contract level.

---

## 9. Next recommended action

Prepare first Codex brief only after Producer confirms R-16 direction.

Recommended first brief:

```text
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Game_Design_Workbench_State_Schema_v1.md
```

Recommended scope:

- expand `/state` schema with structured dogs, production chain, buildings/rooms and event log based on already accepted systems docs;
- no gameplay changes;
- no standalone simulator;
- no player-facing UI.

---

## 10. Changelog

### 2026-06-30 — v1 created

- Created Game Design Systems Workbench Requirements v1.
- Defined Workbench as internal design tool over live Godot runtime.
- Added view families, schema direction, allowed dev controls, first Codex brief candidates and R-16 acceptance criteria.
