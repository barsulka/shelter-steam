# STEAM_DESKTOP — Acceptance Report — Game Systems Runtime Foundation v1

Дата: 2026-06-30
Роль проверки: Game Designer as feature customer
Статус: partial acceptance — static/document/snapshot review passed; live customer test required before full acceptance

Source brief:

`docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Game_Systems_Runtime_Foundation_v1.md`

Codex status:

`docs/repo/status/CODEX_STATUS.md` — `2026-06-30 - Steam Game Systems Runtime Foundation v1`

Reviewed evidence:

- `docs/repo/status/CODEX_STATUS.md`
- `docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Checklist__Game_Systems_Runtime_Foundation_v1.md`
- `docs/repo/dev/godot-state-connector.md`
- `docs/repo/api/godot-state-connector.openapi.yaml`
- `steam/resources/game_systems/fixtures/*.json`
- `steam/scripts/game_systems/game_systems_runtime.gd`
- `steam/.runtime/godot_state_connector/state_snapshot.json`

---

## 1. Customer verdict

**Not fully accepted yet.**

The feature appears to be implemented in the right architecture and covers most of the requested scope. It passes static review and Codex-reported automated/localhost checks.

However, as the customer who needs to use this for real game-design work, I cannot sign full acceptance until I personally complete one live design-test session through the running connector.

Required for full acceptance:

- running connector URL;
- token;
- ability to call `/state` and `/control/runtime/*` endpoints;
- ability to load fixtures, set speed, export/import JSON, assign dog, start research/route and inspect event log.

---

## 2. What appears completed

### 2.1 Runtime foundation

Status: **PASS by static evidence**

Evidence:

- `steam/scripts/game_systems/game_systems_runtime.gd` exists.
- Runtime exposes structured groups: `dogs`, `routes`, `production_chains`, `buildings`, `rooms`, `house_of_curiosity`, `economy`, `events`, `debug`.
- Local snapshot confirms these groups exist in live/file snapshot state.

### 2.2 `/state` expansion

Status: **PASS by OpenAPI + snapshot**

Evidence:

- OpenAPI v0.2 requires top-level groups in `StateSnapshot`.
- Snapshot shows structured `buildings`, `rooms`, House of Curiosity, events and debug-like runtime scaffold.

### 2.3 Dog state detail

Status: **PASS / WATCH**

Positive evidence:

- Runtime code exposes dog identity, character traits, innate traits, learned habits, helper effects, equipment, preferences, activity experience, current activity, movement state, current place/anchor/room, assignment and recent events.
- Fixture and snapshot show specific activity details such as `learning + sitting_at_practice_table` in House of Curiosity.

Watchpoint:

- Need live check that `learning + reading_book`, `learning + sitting_at_desk`, `movement + walking_to_house_of_curiosity` can be set/observed distinctly, not only represented in code examples.

### 2.4 Speed multiplier

Status: **PASS by static evidence; live behavior pending**

Evidence:

- Runtime supports `1 / 2 / 3 / 5 / 10`.
- OpenAPI exposes `POST /control/runtime/speed`.
- Dev docs provide curl example.
- Checklist says speed set and `/state.debug` verification passed.

Pending live check:

- verify that chain transitions and research progress actually accelerate consistently at 2x/3x/5x/10x.
- verify no event loss or broken state at 10x.

### 2.5 JSON save/export/import

Status: **PASS by static evidence; live edit/import pending**

Evidence:

- Runtime supports export/import, local save write/load/erase.
- OpenAPI exposes endpoints.
- Fixtures exist and parse.
- Checklist says export/import and restart-from-save passed.

Pending live check:

- export state;
- modify dog assignment manually in JSON;
- import;
- verify `/state` reflects edited state;
- save;
- restart/load save;
- verify persistence.

### 2.6 Test fixtures

Status: **PASS**

Fixtures present:

- `first_day_empty_coop.json`
- `warm_food_delivery_mid_chain.json`
- `house_of_curiosity_learning_session.json`

Notes:

- Fixtures are useful starting points.
- `house_of_curiosity_learning_session` specifically validates room assignment / research scaffold.

### 2.7 Event log

Status: **PASS / WATCH**

Positive evidence:

- Runtime has structured event log with ids, time, tags, dogs, places, rooms, chains, research ids and payload.
- Fixture includes `fixture_research_started` event.
- Snapshot shows events attached to House of Curiosity.

Watchpoint:

- Need live check that routine actions emit enough event detail to explain causality.
- Need to verify event log can support the future “Почему?” explanation layer.

### 2.8 Dev API actions

Status: **PASS by OpenAPI**

Endpoints present:

- fixture list/load;
- speed;
- state export/import/clear;
- save write/load/erase;
- route start;
- dog assign;
- research start;
- debug tick.

Security notes:

- OpenAPI and docs state endpoints are token-protected.
- Codex reports masked 404 without token.

---

## 3. Known gaps from customer perspective

### 3.1 No live customer session yet

This is the main gap.

Codex proved smoke checks. I still need to prove that I, as Game Designer, can use the feature without Codex assistance.

### 3.2 “Why?” explanation is not implemented

This was not in the original Codex brief, so it is not a failure.

But as customer, I now consider it a likely next requirement:

```text
Why is this dog doing this?
```

Desired answer should cite state-machine reasons:

- assignment;
- room;
- active research;
- character/trait/preference;
- current chain;
- route or room state.

This should become a future Workbench feature, not necessarily part of Runtime Foundation v1.

### 3.3 Scenario Runner is not explicit

Fixtures and dev actions exist, but a higher-level scenario runner is not yet defined.

This is not a v1 failure.

Future need:

- one command/button for predefined design experiments;
- example: `dog_goes_to_library`, `three_dogs_unload`, `route_then_tea`, `soft_packing_training`.

### 3.4 State Diff is not implemented

Export/import exists, but designer-friendly before/after diff is not present.

Not a v1 failure.

Likely future Workbench feature.

### 3.5 Stress Dashboard is only signal scaffold

Runtime exposes stress signals in code, but full dashboard is not yet a usable reviewer page.

Not a v1 failure, because the brief requested runtime foundation, not final dashboard.

---

## 4. Acceptance criteria review

| Brief criterion | Status | Notes |
|---|---|---|
| Godot remains source of truth | PASS | Consistent in docs/code/status. |
| No standalone simulator | PASS | No separate simulator introduced. |
| Structured runtime groups | PASS | Present in OpenAPI/code/snapshot. |
| `/state` exposes groups | PASS | OpenAPI + snapshot confirm. |
| Speed multiplier 1/2/3/5/10 | PASS / LIVE PENDING | Static yes, live behavior pending. |
| JSON export/import | PASS / LIVE PENDING | Static yes, live edit/import pending. |
| 3 fixtures | PASS | Present and readable. |
| Dev API actions | PASS | OpenAPI confirms. |
| Event log | PASS / WATCH | Present; causality richness needs live test. |
| Existing connector endpoints work | PASS by Codex checks | Need no additional concern. |
| OpenAPI updated | PASS | v0.2 present. |
| Docs updated | PASS | Dev docs/status/checklist updated. |
| CODEX_STATUS updated | PASS | Status block present. |
| No final player UI/new scope | PASS | Dev-only. |

---

## 5. Required live customer test

To finish acceptance, run a live session and perform these checks.

### 5.1 Inputs needed

Need from user/Codex:

```text
/state URL
/control URL
token
```

or Barsulka URL with token.

### 5.2 Test script

1. Open `/health` without token.
2. Open `/state` with token.
3. Confirm top-level groups.
4. `GET /control/runtime/fixtures`.
5. Load `house_of_curiosity_learning_session`.
6. Confirm Labrador assignment in `/state.dogs[]`, `/state.rooms[]`, `/state.house_of_curiosity`.
7. Set speed to `5` and confirm `/state.debug.speed_multiplier`.
8. Run bounded debug tick and confirm research progress changes.
9. Assign Dachshund to `room.house_of_curiosity.library` with `learning + reading_book`.
10. Confirm dog activity detail appears distinctly.
11. Start `research.basket_check` in classroom.
12. Confirm active research changed and event log appended.
13. Export state.
14. Modify exported JSON to move a dog to another room/activity.
15. Import modified JSON.
16. Confirm state changed.
17. Write save.
18. Load save / restart from save if possible.
19. Confirm state persists.
20. Trigger route start and confirm chain/events update.
21. Capture screenshot and state around one moment if public connector supports capture.

Full acceptance requires these checks to pass without Codex editing code during the test.

---

## 6. Customer decision

Current decision:

**Partial acceptance. Do not request a rebuild yet. Live connector URL was provided, but this ChatGPT runtime could not resolve `barsulka.eboshim.site`, so final live acceptance is still blocked.**

Additional evidence from local snapshot dated 2026-07-01:

- `steam/.runtime/godot_state_connector/state_snapshot.json` is updating.
- Snapshot schema is `shelter.godot_state_connector.v0.2`.
- `control_enabled=true` and runtime endpoints are present in snapshot metadata.
- `/state` contains dogs, buildings, rooms, House of Curiosity, economy, events, routes, production chains, debug and stress_test_signals.
- Current snapshot confirms default first-day state, not a completed live acceptance scenario.

Live URL issue:

- Attempted to open the provided Barsulka URL from assistant tools.
- Result: hostname resolution failed in this environment.
- Direct checkout access can read snapshots, but does not itself execute HTTP POST commands against the connector.

If live test passes, Runtime Foundation v1 can be accepted.

If live test reveals friction, create a focused follow-up brief, likely one of:

- Workbench Scenario Runner v0;
- Workbench State Diff v0;
- Workbench Why Explanation v0;
- Workbench Stress Dashboard v0.

---

## 7. What I need next

Please provide one of:

1. Running connector public URL + token; or
2. Local `/state` export after running the runtime-foundation smoke and at least one fixture interaction; or
3. Instruction to prepare a follow-up Codex brief based only on static review.

Preferred:

```text
cd steam
./launch.sh
./launch.sh --barsulka --start
./launch.sh --barsulka
```

Then send the printed `/state?token=...` and `/control?token=...` URLs.

---

## 8. Changelog

### 2026-07-01 — live URL attempt added

- Attempted to use provided Barsulka control URL.
- Assistant environment could not resolve `barsulka.eboshim.site`.
- Read the updated local snapshot directly from the checkout and confirmed v0.2 runtime groups are present.
- Full acceptance remains blocked on actual HTTP control access or user-provided command outputs.

### 2026-06-30 — v1 created

- Created customer acceptance report for Game Systems Runtime Foundation v1.
- Static/document/snapshot review passed.
- Full acceptance blocked on live customer test through connector.
