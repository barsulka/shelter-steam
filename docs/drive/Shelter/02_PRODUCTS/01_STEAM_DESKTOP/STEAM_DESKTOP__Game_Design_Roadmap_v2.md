# STEAM_DESKTOP — Game Design Roadmap v2

Дата: 2026-07-01  
Роль документа: Game Design Roadmap / Working Plan  
Статус: draft working roadmap  
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

ChatGPT can read local docs and runtime snapshot files through local file server.

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

Статус: active next.

Цель:

- завершить приёмку Runtime Foundation v1 без зависимости от Atlas/browser control;
- получить repeatable evidence pack из live Godot runtime через файлы в `.runtime`.

Нужный результат:

- `Acceptance_Report__Game_Systems_Runtime_Foundation_v1` updated или новая follow-up acceptance note;
- evidence bundle с manifest, JSONL snapshots, final state and event log;
- Game Designer verdict: accepted / accepted with follow-up / needs Codex fix.

### R-18 — Workbench Runtime Capture Harness v0

Статус: Codex brief prepared.

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

Статус: after R-18.

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

Статус: after first runtime review.

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

Статус: after R-20.

Цель:

- prepare Codex implementation brief for the smallest playable systems expansion after Runtime Foundation.

Likely scope candidates:

1. Warm Food Delivery loop from empty fixture to completed delivery with richer runtime events.
2. House of Curiosity minimal room assignment and one research unlock.
3. Dog habit opportunity proof: `Проверяет корзинку` or `Ровный узелок`.
4. Basic economy-of-life events: story/postcard/inspiration placeholder events.

No exact scope should be locked before R-19 review.

### R-22 — Workbench Follow-up Features

Статус: after R-19/R-20 priorities.

Candidate briefs:

- Scenario Runner v0;
- State Diff v0;
- Why Explanation v0;
- Stress Dashboard v0;
- Capture + State Bundle v1 with optional PNG frames.

Priority should come from actual review pain.

### R-23 — First Week / Long-Term Loop Direction

Статус: later.

Цель:

- after First Day MVP is playable and inspectable, design the first longer retention layer.

Candidate topics:

- second production chain;
- comfort chain;
- inspiration tree first safe use;
- first non-food delivery;
- first room expansion;
- first meaningful dog friendship / mentorship moment;
- first longer-term route familiarity.

---

## 5. Immediate execution plan

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

### 2026-07-01 — v2 created

- Created next Game Design roadmap after R-09..R-16 completion.
- Set R-17..R-23 critical path around runtime acceptance, file-based capture, snapshot review, First Day MVP v1 and future Workbench follow-ups.
- Added specific tooling direction for ChatGPT/local-file workflow when Atlas/browser live control is unavailable.
