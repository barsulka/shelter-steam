# STEAM_DESKTOP — Core Gameplay Loop Validation v1

Дата: 2026-06-30
Роль документа: Game Design / Systems Design Audit
Статус: draft v1
Продукт: Steam/Desktop idle always-on-top strip
Roadmap task: R-15.5 — Core Gameplay Loop Validation
Роль-владелец: Game Designer / Systems Designer

Основано на:

- `docs/drive/Shelter/00_START_HERE/03_PROJECT_PHILOSOPHY.md`
- `docs/drive/Shelter/00_START_HERE/04_SHELTER_STRESS_TESTS.md`
- `STEAM_DESKTOP__Dog_Progression_Model_v1.md`
- `STEAM_DESKTOP__Ability_Source_Loop_v1.md`
- `STEAM_DESKTOP__Ability_Catalog_v1.md`
- `STEAM_DESKTOP__Dog_Life_Model_v1.md`
- `STEAM_DESKTOP__Building_System_v1.md`
- `STEAM_DESKTOP__Production_Chains_v1.md`
- `STEAM_DESKTOP__Laboratory_Research_Tree_v1.md`
- `STEAM_DESKTOP__Economy_Balance_Foundations_v1.md`

---

## 0. Назначение

Этот документ проверяет R-09..R-15 через Shelter Stress Tests.

Цель не в том, чтобы добавить новые механики.

Цель — проверить, что созданный systems foundation всё ещё описывает именно Shelter:

> производственный собачий кооператив, где жизнь собак делает production core живым, а не заменяет его.

---

## 1. Summary verdict

**PASS with watchpoints.**

R-09..R-15 формируют coherent production co-op core:

- dogs are system-forming;
- production, routes, delivery, buildings and research remain core;
- dog life enriches the core but does not replace it;
- economy is not only stockpile;
- research unlocks life/routines, not only bonuses;
- buildings are places where dogs act, not passive machines.

Main watchpoints:

1. Room windows must not become The Sims-like household simulator.
2. Helper effects must not become hidden stat optimization.
3. Economy of life must remain tied to production co-op, not become abstract vibes.
4. Workbench must not turn design into player-facing spreadsheet.
5. Future implementation must preserve visible dog actions and cause-and-effect.

---

## 2. Release Gate Checklist — R-09..R-15

| Test | Result | Notes |
|---|---|---|
| Excel Test | PASS | Systems require dog actions, story, rooms, routes and visible cause-and-effect. |
| Factory Test | PASS | Removing dog character/life would damage core meaning. |
| The Sims / Tamagotchi Test | PASS / WATCH | Production core remains primary, but room windows need scope control. |
| Dog Test | PASS | Dogs cannot be replaced by generic units without breaking progression, habits and co-op identity. |
| Charity Identity Test | PASS / WATCH | Delivery/help framing is meaningful, but real charity mechanics remain later and must avoid guilt. |
| D-020 Test | PASS | Systems are framed through richer co-op life before bonuses. |
| Production Core Test | PASS | Production, routes, delivery, buildings and research remain core. |
| Idle Test | PASS / WATCH | Philosophy is correct; needs future runtime validation. |
| Warmth Test | PASS | Systems increase warmth through habits, rooms, support, postcards and comfort. |
| Layer Test | PASS | Roadmap now labels core/depth/atmosphere/tooling. |
| Time Allocation Test | PASS / WATCH | Core is currently prioritized; atmosphere must stay scoped. |
| Love Test | PASS | Systems aim for memorable dog stories over stockpile bragging. |
| Memory Test | PASS | Dog habits, room stories and deliveries create memory hooks. |
| Screenshot Test | PASS / WATCH | Room-window direction can create screenshot stories; needs Art/UX validation. |

---

## 3. Excel Test

Question:

> If these systems were replaced by an Excel table, would Shelter lose meaning?

Verdict: **PASS**

Evidence:

- Dog Progression defines identity, traits, learned habits and current activities.
- Ability Source Loop requires dog history, work, mentorship, care and inspiration.
- Ability Catalog uses character traits and helper effects, not raw stat list.
- Dog Life Model frames activities as dog-life fragments.
- Building System frames buildings as anchors + room windows where dogs act.
- Production Chains require visible dog actions across places.
- Economy & Balance defines economy of life, not only resources.

Risk:

- Helper effects could later become hidden stat modifiers.

Mitigation:

- Every helper effect must explain which character expression it supports and in what activity context.

---

## 4. Factory Test

Question:

> If comfort, stories and dog character are removed, does almost the same game remain?

Verdict: **PASS**

Evidence:

- Production chain depends on dogs as visible agents.
- Dog habits and traits affect route, packing, care, research and room activities.
- Buildings are places, not machines.
- Research is House of Curiosity, not tech bonus tree.

Risk:

- Implementation may simplify buildings into `input -> output` stations.

Mitigation:

- Codex briefs must preserve dog action ownership and visible cause-and-effect.

---

## 5. The Sims / Tamagotchi Test

Question:

> If production is removed and only dog life remains, is it still Shelter?

Verdict: **PASS / WATCH**

Evidence:

- D-020 explicitly says production is core.
- R-12 and R-15 keep routes, production, delivery, buildings and research as core systems.
- Dog Life Model is marked depth with core-facing constraints.
- Rooms enrich production co-op; they do not replace it.

Watchpoint:

- Dog rooms, tea after route, library and interior scenes are attractive enough to drift into life-sim scope.

Mitigation:

- Use Layer Test before implementing room/decor/social features.
- Core production loop must stay playable and valuable without deep interior systems.

---

## 6. Dog Test

Question:

> Can dogs be replaced by humans, robots or colored cubes without breaking mechanics?

Verdict: **PASS**

Evidence:

- Dog identity and traits are core.
- Learned habits depend on dog history.
- Dog rooms and House of Curiosity create dog-specific activity states.
- Production chains are flows of dog actions.

Risk:

- If UI exposes only efficiency values, dog meaning can vanish.

Mitigation:

- Player-facing UI should use dog language: habits, routines, help, comfort, route memories.

---

## 7. Charity Identity Test

Question:

> If shelter/help framing is removed, does the game remain the same?

Verdict: **PASS / WATCH**

Evidence:

- Delivery/postcard/help is part of production closure.
- D-020 and product rules prohibit guilt pressure.
- Delivery quality is framed as warmth/story, not commercial output.

Watchpoint:

- Real charity mechanics are not designed yet.

Mitigation:

- Future charity docs must pass D-020 and no-guilt tests.

---

## 8. D-020 Test

Question:

> Do systems make the co-op richer as a place for life?

Verdict: **PASS**

Evidence:

- R-15 defines wealth as richer co-op life, not stockpile.
- R-13 research unlocks new life/routines.
- R-12 buildings create places.
- R-11 traits/habits build character.

Risk:

- Future balancing could prioritize throughput over co-op richness.

Mitigation:

- R-15 balance vocabulary prefers rhythm, flow, warmth, reliability and co-op depth.

---

## 9. Production Core Test

Question:

> Do systems strengthen the production co-op?

Verdict: **PASS**

Evidence:

Core remains:

- routes;
- resource trips;
- physical unload;
- Storage;
- Kitchen;
- Packing;
- Delivery;
- dog progression;
- House of Curiosity;
- economy/balance.

Depth systems support the core:

- rooms;
- habits;
- research routines;
- comfort;
- stories.

---

## 10. Idle Test

Question:

> Can the game be left open and be pleasant to watch?

Verdict: **PASS / WATCH**

Design passes:

- idle means life flows and player gently guides;
- no guilt, FOMO or absence punishment;
- dog actions and room windows support observation.

Runtime not yet validated:

- real pacing;
- animation density;
- desktop companion feeling;
- idle rhythm.

Mitigation:

- Need future visible runtime review after systems begin implementation.

---

## 11. Warmth Test

Question:

> Do systems make the co-op warmer?

Verdict: **PASS**

Evidence:

- Dog rooms, rest, tea, mentorship, postcards, comfort and stories all enrich warmth.
- Economy protects warmth from becoming stat-only.
- Research and buildings are framed as life places.

Risk:

- Warmth systems could become mandatory optimization.

Mitigation:

- Comfort/decor should remain depth or atmosphere unless explicitly promoted to core.

---

## 12. Layer Test

Verdict: **PASS**

Current classification:

| System | Layer |
|---|---|
| Dogs | Core |
| Routes | Core |
| Production Chains | Core |
| Delivery | Core |
| Dog Progression | Core |
| Buildings | Core |
| House of Curiosity | Core -> Depth |
| Dog Life Model | Depth with core-facing constraints |
| Rooms | Depth |
| Postcards | Depth / Identity |
| Tiny gestures | Atmosphere |
| Workbench | Internal tooling |

Risk:

- Rooms and atmosphere are emotionally appealing and can steal scope.

Mitigation:

- Layer label required before implementation.

---

## 13. Love / Memory / Screenshot Tests

Verdict: **PASS / WATCH**

Desired player memories:

- “My dachshund learned to check the basket.”
- “The labrador now helps new dogs unload crates.”
- “Two dogs studied soft packing in the House of Curiosity.”
- “The first warm delivery got a postcard.”

Risk:

- If progression rewards are shown mainly as numbers, player remembers stockpile instead.

Mitigation:

- Dog Card, room windows, postcard/archive and Workbench/player-facing views must show stories/habits clearly.

---

## 14. Overall conclusion

R-09..R-15 pass the first Shelter Stress Test.

The current systems foundation is coherent:

```text
production co-op core
+ dog identity/progression
+ room/detail depth
+ research as life unlocks
+ economy of things and life
```

This matches D-020.

Proceed to R-16 only if Workbench remains internal tooling and does not become a second independent simulation or spreadsheet-first design surface.

---

## 15. Required guardrails for R-16

R-16 Workbench must:

- inspect live Godot runtime, not simulate independently;
- expose dog actions, habits, rooms, chains and events, not only numbers;
- include economy-of-life events, not only inventory;
- support stress-test validation;
- avoid becoming player-facing spreadsheet UI.

R-16 must not:

- invent new mechanics;
- mutate gameplay without accepted briefs;
- replace design documents;
- optimize for metrics before preserving Shelter identity.

---

## 16. Acceptance criteria

R-15.5 is complete when:

1. Shelter Stress Tests are applied to R-09..R-15.
2. Overall verdict is stated.
3. Pass/watch/fail areas are listed.
4. Guardrails for R-16 are defined.
5. Current roadmap can move to Workbench requirements.

Status: **complete at v1 audit level**.

---

## 17. Next recommended document

Next Game Designer task:

```text
STEAM_DESKTOP__Game_Design_Systems_Workbench_Requirements_v1.md
```

Purpose:

Define what Workbench must inspect from live Godot state to help Game Designer validate Shelter systems without creating a second simulation or spreadsheet-first design surface.

---

## 18. Changelog

### 2026-06-30 — v1 created

- Created Core Gameplay Loop Validation v1.
- Applied Shelter Stress Tests to R-09..R-15.
- Confirmed current systems foundation passes with watchpoints.
- Added R-16 guardrails.
