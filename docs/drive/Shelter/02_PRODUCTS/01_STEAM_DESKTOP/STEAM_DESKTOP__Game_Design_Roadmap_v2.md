# STEAM_DESKTOP — Game Design Roadmap v2

Дата: 2026-07-01  
Обновлено: 2026-07-12
Роль документа: Game Design Roadmap / Active Working Plan  
Статус: active current roadmap  
Read policy: use as the current Steam/Desktop game-design roadmap; older roadmap docs are history/reference.  
Продукт: Steam/Desktop idle always-on-top strip  
Роль-владелец: Game Designer / Systems Designer

---

## 0. Назначение

Этот roadmap фиксирует следующий гейм-дизайнерский путь после завершения R-09..R-16 на уровне v1 design contracts и после частичной приёмки `Game Systems Runtime Foundation v1`.

Главная смена фокуса:

```text
от написания системных документов
к проверке живого runtime, снятию состояния, анализу ритма и подготовке First Day MVP v1
```

Этот документ не заменяет продуктовую библию и не утверждает новые механики сверх уже принятых документов. Он задаёт порядок ближайших работ Game Designer.

---

## 0.1 Current navigation

Current active roadmap:

```text
STEAM_DESKTOP__Game_Design_Roadmap_v2.md
```

Current active task:

```text
No new executable Game Design task is accepted after R-29 closeout.
```

Current product status:

```text
First Day MVP locked at prototype/product-language level.
D-022 Day 2 same-chain Warm Food Delivery variation is complete at prototype/product-language/runtime-evidence level.
R-29 is closed / PASS.
```

Do not use as active roadmap:

```text
STEAM_DESKTOP__Game_Design_Roadmap_v1.md — history / redirected to systems branch.
STEAM_DESKTOP__Game_Systems_Roadmap_v1.md — completed systems-contract reference.
STEAM_DESKTOP__Game_Systems_Roadmap_v1.remaining_snapshot.md — archive snapshot.
```

---

## 1. Восстановленная основа

Текущая Steam/Desktop основа:

- продукт — горизонтальный собачий производственный кооператив в always-on-top полоске;
- Godot — источник истины для live runtime;
- Workbench — internal design tool поверх live Godot, не standalone simulator;
- Visual proof Vertical Slice остаётся в зоне Art Director и не блокирует Game Designer systems work;
- R-09..R-16 выполнены на уровне v1 design-contract / requirements-contract.

Ключевые принятые рамки:

- собаки — персонажи, не worker units;
- production core остаётся ядром;
- жизнь собак делает production core живым, но не заменяет его;
- Steam не делает классический visible crop farming;
- ресурсы приходят через off-screen поездки собак и физическую разгрузку;
- доброта, отсутствие guilt pressure, отсутствие гачи, paid reroll, боёв и агрессивного FOMO обязательны.

---

## 2. Current status — что уже есть

### 2.1 Game Design

Готовы v1 documents:

- `STEAM_DESKTOP__Dog_Progression_Model_v1.md`
- `STEAM_DESKTOP__Ability_Source_Loop_v1.md`
- `STEAM_DESKTOP__Ability_Catalog_v1.md`
- `STEAM_DESKTOP__Dog_Life_Model_v1.md`
- `STEAM_DESKTOP__Building_System_v1.md`
- `STEAM_DESKTOP__Production_Chains_v1.md`
- `STEAM_DESKTOP__Laboratory_Research_Tree_v1.md`
- `STEAM_DESKTOP__Economy_Balance_Foundations_v1.md`
- `STEAM_DESKTOP__Core_Gameplay_Loop_Validation_v1.md`
- `STEAM_DESKTOP__Game_Design_Systems_Workbench_Requirements_v1.md`

`Core Gameplay Loop Validation v1` verdict:

```text
PASS with watchpoints
```

### 2.2 Runtime / Codex

`Game Systems Runtime Foundation v1` имеет partial acceptance:

- static review passed;
- document review passed;
- local snapshot review passed;
- full live customer acceptance still pending.

Уже есть:

- `/state` schema v0.2;
- structured groups: dogs, routes, production_chains, buildings, rooms, house_of_curiosity, economy, events, debug;
- fixtures:
  - `first_day_empty_coop.json`
  - `warm_food_delivery_mid_chain.json`
  - `house_of_curiosity_learning_session.json`
- dev-only speed multiplier: `1 / 2 / 3 / 5 / 10`;
- export/import JSON;
- bounded debug tick;
- local snapshot file:
  - `steam/.runtime/godot_state_connector/state_snapshot.json`

### 2.3 Blocker / tooling gap

ChatGPT Work and Codex read local docs and runtime snapshot files directly from the current checkout.

ChatGPT currently cannot reliably:

- open Atlas agent browser;
- operate the running browser control page;
- send token-protected HTTP POST commands to the live connector from this environment;
- perform full live customer acceptance directly through public Barsulka URL when name resolution fails.

Therefore the next tooling step should be file-based runtime capture over live Godot.

---

## 3. Product direction — к чему идём

Target for the next phase:

> A designer-testable First Day MVP loop where the game can be run, accelerated, sampled into JSONL/state bundles, reviewed by Game Designer, then turned into focused implementation and balance decisions.

The next visible product proof should answer:

1. Does Warm Food Delivery remain readable as a flow of dog actions?
2. Are dogs inspectable as characters, not stat bundles?
3. Does House of Curiosity enrich the co-op without turning into a separate life sim?
4. Are economy-of-things and economy-of-life observable together?
5. Does idle progression produce kind, understandable moments rather than empty waiting or spreadsheet drift?
6. Which First Day systems are core enough for implementation v1, and which must stay depth/atmosphere?

---

## 4. Roadmap tasks

### R-17 — Runtime Foundation Acceptance via File-Based Evidence

Статус: done / accepted through file-based runtime evidence.

Цель:

- завершить приёмку Runtime Foundation v1 без зависимости от Atlas/browser control;
- получить repeatable evidence pack из live Godot runtime через файлы в `.runtime`.

Нужный результат:

- `Acceptance_Report__Game_Systems_Runtime_Foundation_v1` updated или новая follow-up acceptance note;
- evidence bundle с manifest, JSONL snapshots, final state and event log;
- Game Designer verdict: accepted / accepted with follow-up / needs Codex fix.

### R-18 — Workbench Runtime Capture Harness v0

Статус: done / implemented and accepted for Game Designer state-review.

Цель:

- добавить dev-only CLI/script, который запускает live Godot runtime, загружает fixture/scenario, двигает debug time and writes state snapshots to `.runtime`.

Important:

- harness uses Godot runtime as source of truth;
- no standalone simulator;
- output is local ignored files for ChatGPT/local-file review;
- 100x-style review should be implemented as bounded debug time advancement and sampling, not as final game speed or feel validation.

Expected output example:

```text
steam/.runtime/workbench_capture_runs/<run_id>/manifest.json
steam/.runtime/workbench_capture_runs/<run_id>/snapshots.jsonl
steam/.runtime/workbench_capture_runs/<run_id>/events.jsonl
steam/.runtime/workbench_capture_runs/<run_id>/final_state.json
```

### R-19 — Snapshot-Based Design Review Pack v1

Статус: done / first full-dispatch runtime review recorded.

Цель:

- Game Designer reads capture output and writes a structured review.

Review questions:

- What changed every 10 game seconds?
- Which dogs were working, idle, assigned, blocked or learning?
- Did event log explain causality?
- Did production chain advance through visible dog-owned states?
- Did economy-of-life events exist or remain empty?
- Did stress signals detect factory/spreadsheet drift?
- Which runtime fields are missing for real design decisions?

Result:

```text
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Runtime_Capture_Review__<scenario>_v1.md
```

### R-20 — First Day MVP Contract v1

Статус: done / First Day MVP v1 design contract recorded.

Цель:

- превратить existing systems contracts into a concrete First Day MVP contract.

The contract should decide:

- first 2–3 dogs and their character roles;
- first route order;
- first delivery cadence target;
- first bottleneck;
- first House of Curiosity unlock;
- first dog habit opportunity;
- first helper/equipment reward;
- what stays main strip vs room window;
- what stays prototype-only / Workbench-only.

Result:

```text
STEAM_DESKTOP__First_Day_MVP_v1.md
```

### R-21 — First Systems Implementation Slice v1

Статус: done / accepted at runtime-evidence level.

Цель:

- implement the smallest playable systems polish after First Day MVP contract.

Accepted result:

```text
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Runtime_Review__First_Day_MVP_Runtime_Polish_v1.md
```

R-21 accepted:

- clean debug event noise;
- high-level dog action events;
- post-delivery dog/life moment;
- delivered Food Bag semantic;
- legacy production_chain consistency;
- expanded Workbench `first_day_mvp_proof`.

### R-22 — First Day Visible / Player-Feel Review Pack v1

Статус: done / visible review recorded, PASS with watchpoints.

Цель:

- проверить First Day MVP не через 100x JSON proof, а через real-speed / low-speed visible capture and human review;
- answer whether the first day reads as a calm dog co-op and not only as a correct state machine.

Output:

```text
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Visible_Review__First_Day_MVP_v1.md
```

Проверить:

- видны ли собаки как персонажи;
- читаются ли route / unload / carry / kitchen / packing / van states;
- не доминирует ли UI/debug над strip;
- ощущается ли открытка как тёплый момент;
- понятна ли награда `Удобные тапочки`;
- не выглядит ли next-day hint как tutorial pressure;
- где нужны Art Director / UX follow-ups.

### R-23 — First Day UX / Visual Readability Fix Contract v1

Статус: done / visible readability fix reviewed, PASS.

Цель:

- turn R-22 visible review watchpoints into a focused UX/visual readability fix contract before expanding gameplay scope.

Output:

```text
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__First_Day_UX_Readability_Fix_Requirements_v1.md
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__First_Day_Visible_Readability_Fix_v1.md
```

Focus:

- reduce dependency on UI text for understanding dog actions;
- make dog identity/action readability stronger;
- make postcard moment more embodied;
- make next-day hint visibly present and gentle;
- improve main-strip state cues for route, payload, van, postcard and reward;
- keep House of Curiosity as tease only.

### R-24 — First Day Art Director / UX Review Handoff v1

Статус: done / Art UX v3 accepted as prototype visual-language pass.

Цель:

- передать v2 capture pack and R-23 Game Designer review to Art Director / UX;
- решить, какие prototype readability cues оставить временно, какие требуют визуального/UX redesign, and whether a low-speed player-feel capture is needed before the next Codex pass.

Output:

```text
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Art_UX_Handoff__First_Day_MVP_v2.md
```

Focus:

- dog identity / action silhouette and motion language;
- driver/helper readability;
- postcard board / attention cue;
- slippers world marker;
- next-day hint presentation;
- 96px / compact strip readability;
- whether to run low-speed capture before next visual fix.

### R-25 — First Day MVP Lock / Next Scope Decision v1

Статус: done / First Day MVP locked, next scope A selected.

Цель:

- consolidate Game Designer, Runtime, Visible Review and Art/UX v3 results into a First Day MVP lock decision;
- decide whether the next slice should be First Week / longer retention, Workbench follow-up tooling, or one focused real-speed player-feel check.

Output candidate:

```text
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__First_Day_MVP_Lock_And_Next_Scope_Decision_v1.md
```

Decision inputs:

- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__First_Day_MVP_v1.md`
- `docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Runtime_Review__First_Day_MVP_Runtime_Polish_v1.md`
- `docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Visible_Review__First_Day_MVP_v2.md`
- `docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Art_UX_Review__First_Day_MVP_v3.md`
- `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v3/`

### R-26 — Workbench Follow-up Features

Статус: after R-25 decision.

Candidate briefs:

- Scenario Runner v0;
- State Diff v0;
- Why Explanation v0;
- Stress Dashboard v0;
- Capture + State Bundle v1 with optional PNG frames.

Priority should come from actual review pain, not from tooling ambition.

### R-27 — First Week / Long-Term Loop Direction

Статус: done / First Week direction v1 recorded.

Цель:

- design Day 2 / First Week direction after First Day MVP lock;
- answer why the player returns tomorrow after the first warm delivery.

Output:

```text
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__First_Week_Direction_v1.md
```

### R-28 — Day 2 Return And Second Warm Delivery Codex Brief v1

Статус: done / scope accepted and executable brief created.

Цель:

- prepare Codex implementation brief for the first Day 2 slice: return moment, second warm delivery variation, yesterday's postcard/slippers/memory, packing note and first curiosity question boundary.

Output:

```text
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Day_2_Return_And_Second_Warm_Delivery_v1.md
```

Deferred future topics — not part of R-28 or R-29:

- second production chain;
- comfort chain;
- inspiration tree first safe use;
- first non-food delivery;
- first room expansion;
- first meaningful dog friendship / mentorship moment;
- first longer-term route familiarity.

### R-29 — Day 2 Return And Second Warm Delivery implementation / evidence review

Статус: closed / PASS — 2026-07-12.

Цель:

- implement the D-022 same-chain Day 2 fixture/scenario;
- prove return continuity, full second delivery, careful-packing cue, player-confirmed dispatch, calm progress note and post-completion optional question;
- preserve First Day finals and all task/object causal boundaries;
- return runtime capture for Game Designer / Producer / Art readability review.

Outcome:

- canonical Day 2 fixture/scenario completed with exact order/chain/task/event evidence;
- 52/52 Day 2 assertions and the fresh First Day regression passed;
- prototype/product-language/runtime-evidence acceptance does not imply production art, final animation, save/calendar, platform or shipping readiness;
- no successor executable slice was accepted by this closeout.

Source:

```text
docs/drive/Shelter/00_START_HERE/02_DECISIONS.md#d-022--steamdesktop-day-2-executable-scope-lock
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Day_2_Return_And_Second_Warm_Delivery_v1.md
```

Stop boundary:

```text
No production save/calendar, new chain/route/resource/station, active habit/research/economy system,
production dog rig/tool/schema, window semantics or shipping-platform work.
```

---

## 5. Completed evidence-workflow reference

The workflow below records the already completed capture-harness review pattern. It is not the current active task or an instruction to rerun old First Day work by default.

### Step 1 — Codex implements capture harness

Use brief:

```text
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Workbench_Runtime_Capture_Harness_v0.md
```

Recommended Codex reasoning level:

```text
очень высокий
```

### Step 2 — Human runs capture command

Intended first scenario:

```text
first_day_empty_coop + start accepted route + sample every 10 game seconds
```

Preferred first run after Codex implements the script:

```sh
cd steam
./tools/dev-vertical-slice.sh workbench-capture \
  --scenario=first_delivery_from_empty \
  --fixture=first_day_empty_coop \
  --game-seconds=180 \
  --sample-every-game-seconds=10 \
  --speed=10 \
  --output-dir=.runtime/workbench_capture_runs/first_delivery_from_empty_v0
```

Exact command may change if Codex chooses a different script name, but this is the design contract for the desired workflow.

### Step 3 — Game Designer reviews generated files

Files to read:

```text
steam/.runtime/workbench_capture_runs/first_delivery_from_empty_v0/manifest.json
steam/.runtime/workbench_capture_runs/first_delivery_from_empty_v0/snapshots.jsonl
steam/.runtime/workbench_capture_runs/first_delivery_from_empty_v0/events.jsonl
steam/.runtime/workbench_capture_runs/first_delivery_from_empty_v0/final_state.json
```

### Step 4 — Game Designer produces review and next brief

Output:

- runtime acceptance verdict;
- missing state/control fields;
- First Day MVP v1 decisions;
- next Codex brief.

---

## 6. Guardrails

### 6.1 100x is for state analysis, not feel

Accelerated file capture can validate:

- state transitions;
- event causality;
- bottlenecks;
- dog assignments;
- chain completion;
- balance object rough cadence.

It cannot validate:

- calm desktop feel;
- visual readability;
- animation warmth;
- player comfort;
- always-on-top interruption level.

For feel/readability, Art Director and/or Game Designer still need 1x/2x visible capture.

### 6.2 No second simulation

Capture harness must drive the live Godot runtime through accepted control surfaces.

It must not duplicate game logic in shell/python or generate expected states independently.

### 6.3 No player-facing assumptions

Anything inside `.runtime/workbench_capture_runs/` is internal evidence, not player UI, not save format and not product telemetry.

### 6.4 Stress tests remain active

Every runtime review should check:

- Excel Test;
- Factory Test;
- The Sims / Tamagotchi Test;
- Dog Test;
- Production Core Test;
- Idle Test;
- Warmth Test;
- D-020 Test.

---

## 7. Changelog

### 2026-07-12 — R-29 closed / PASS

- Accepted canonical Day 2 at prototype/product-language/runtime-evidence level after full second-delivery and First Day regression proof.
- Closed the active roadmap task without inventing a successor executable slice.
- Kept production art/animation/world, rooms, save/calendar and platform work behind separate future decisions and briefs.

### 2026-07-11 — D-022 accepted, R-28 closed, R-29 activated

- Accepted the complete same-chain Day 2 scope and created its canonical Codex brief.
- Removed broad second-chain/room/friendship topics from the active slice and retained them as deferred future candidates.
- Activated implementation/evidence review without changing production art or platform scope.

### 2026-07-07 — roadmap cleanup / active roadmap marker

- Marked v2 as the active current Steam/Desktop game-design roadmap.
- Added current navigation block with R-28 as the current active task.
- Clarified that v1 is history, Game Systems Roadmap v1 is completed reference, and remaining snapshot is archive.

### 2026-07-06 — R-27 First Week direction recorded, R-28 activated

- R-27 direction recorded in `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__First_Week_Direction_v1.md`.
- Direction: Day 2 should show that yesterday mattered, not add a big new system immediately.
- Next active task: R-28 Codex brief for Day 2 Return And Second Warm Delivery.

### 2026-07-06 — R-25 locked First Day MVP, R-27 activated

- R-25 decision recorded in `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__First_Day_MVP_Lock_And_Next_Scope_Decision_v1.md`.
- Decision: First Day MVP locked at prototype/product-language level.
- Next scope selected by user and recorded: A — First Week / longer retention.
- R-27 activated as First Week / Long-Term Loop Direction.

### 2026-07-06 — R-24 Art/UX v3 accepted, R-25 activated

- Art Director / UX review recorded in `docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Art_UX_Review__First_Day_MVP_v3.md`.
- Verdict: PASS as First Day Art/UX Visual Language Pass; no blocking v4 required before the next roadmap step.
- v3 capture pack exists at `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v3/`.
- R-25 activated as First Day MVP Lock / Next Scope Decision v1.

### 2026-07-05 — R-23 visible readability fix reviewed, R-24 activated

- R-23 v2 visible review recorded in `docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Visible_Review__First_Day_MVP_v2.md`.
- v2 capture pack verified at `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v2/`.
- Verdict: PASS for Game Designer prototype readability; final Art Director / UX and real-speed player-feel acceptance remain pending.
- R-24 activated as First Day Art Director / UX Review Handoff v1.

### 2026-07-05 — R-23 requirements and Codex brief prepared

- R-23 requirements recorded in `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__First_Day_UX_Readability_Fix_Requirements_v1.md`.
- R-23 Codex brief prepared in `docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__First_Day_Visible_Readability_Fix_v1.md`.
- Scope kept narrow: dog/action readability, main-strip cues, postcard gesture, slippers visibility and gentle next-day hint. No First Week or full House of Curiosity expansion.

### 2026-07-05 — R-22 visible review recorded, R-23 activated

- R-22 visible review recorded in `docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Visible_Review__First_Day_MVP_v1.md`.
- Verdict: PASS with watchpoints; final visual/player-feel acceptance remains pending.
- R-23 activated as First Day UX / Visual Readability Fix Contract v1 before First Week / House of Curiosity expansion.

### 2026-07-05 — R-22 Codex brief prepared

- R-22 Codex brief created: `docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__First_Day_MVP_Visible_Review_Capture_Pack_v1.md`.
- Next action: run Codex with reasoning level `очень высокий` to produce persistent visible capture pack.

### 2026-07-05 — R-21 accepted, R-22 activated

- R-21 First Day MVP Runtime Polish accepted at runtime-evidence level in `docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Runtime_Review__First_Day_MVP_Runtime_Polish_v1.md`.
- R-22 changed to visible/player-feel review because 100x JSON proof cannot validate warmth, readability, animation feel or desktop calmness.
- Next active task: R-22 First Day Visible / Player-Feel Review Pack v1.

### 2026-07-05 — R-21 Codex brief prepared

- R-21 Codex implementation brief created: `docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__First_Day_MVP_Runtime_Polish_v1.md`.
- Next action: run Codex with reasoning level `очень высокий`.

### 2026-07-05 — R-20 closed, R-21 activated

- R-20 First Day MVP Contract completed in `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__First_Day_MVP_v1.md`.
- Next active task is R-21: prepare Codex implementation brief for First Day MVP Runtime Polish v1.

### 2026-07-05 — R-17..R-19 closed, R-20 activated

- R-17 Runtime Foundation Acceptance closed through file-based runtime evidence.
- R-18 Workbench Runtime Capture Harness implemented and accepted for Game Designer state-review.
- R-19 Snapshot-Based Design Review completed in `docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Runtime_Capture_Review__First_Delivery_Dispatch_v1.md`.
- Next active Game Designer task is R-20: `STEAM_DESKTOP__First_Day_MVP_v1.md`.

### 2026-07-01 — v2 created

- Created next Game Design roadmap after R-09..R-16 completion.
- Set R-17..R-23 critical path around runtime acceptance, file-based capture, snapshot review, First Day MVP v1 and future Workbench follow-ups.
- Added specific tooling direction for ChatGPT/local-file workflow when Atlas/browser live control is unavailable.
