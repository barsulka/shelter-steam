# STEAM_DESKTOP — Codex Brief — First Day MVP Runtime Polish v1

Дата: 2026-07-05
Статус: draft for Codex
Роль-владелец постановки: Game Designer / Systems Designer
Roadmap task: R-21 — First Systems Implementation Slice v1
Рекомендуемый уровень рассуждений Codex: очень высокий

---

## 0. Цель

Довести уже доказанный full-dispatch First Delivery runtime loop до уровня First Day MVP evidence.

Текущий runtime уже проходит:

```text
route
-> unload
-> carry
-> kitchen
-> packing
-> van loaded
-> player dispatch confirmation
-> delivery complete
-> postcard
-> reward
-> slippers equipped
-> chain complete
```

Но R-19/R-20 показали, что для First Day MVP не хватает:

1. чистого designer-facing event log без debug tick noise;
2. явных high-level dog action events;
3. post-delivery dog/life moment после открытки;
4. чистой семантики Food Bag после доставки;
5. согласованности legacy `production_chain` view с основным `production_chains[]`;
6. Workbench/capture proof не только `chain_complete=true`, но и emotional completion first-day flags/events.

Задача — implementation polish текущего First Day slice, а не расширение product scope.

---

## 1. Обязательные источники

Перед началом Codex обязан прочитать:

### Project rules / repo context

- `PROJECTS_RULES.md`
- `AGENTS.md`
- `README.md`
- `steam/AGENTS.md`
- `steam/README.md`
- `docs/repo/status/CODEX_STATUS.md`
- `docs/repo/adr/README.md`
- все релевантные Accepted ADR, особенно:
  - `docs/repo/adr/0001-use-godot-for-steam-desktop.md`
  - `docs/repo/adr/0002-game-state-as-source-of-truth.md`

### Product / design contracts

- `docs/drive/Shelter/00_START_HERE/02_DECISIONS.md`
- `docs/drive/Shelter/00_START_HERE/03_PROJECT_PHILOSOPHY.md`
- `docs/drive/Shelter/00_START_HERE/04_SHELTER_STRESS_TESTS.md`
- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__First_Day_MVP_v1.md`
- `docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Runtime_Capture_Review__First_Delivery_Dispatch_v1.md`
- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Production_Chains_v1.md`
- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Dog_Progression_Model_v1.md`
- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Dog_Life_Model_v1.md`
- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Game_Design_Systems_Workbench_Requirements_v1.md`

### Runtime / connector contracts

- `docs/repo/dev/godot-state-connector.md`
- `docs/repo/api/godot-state-connector.openapi.yaml`
- `docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Dispatch_Confirmation_Capture_Path_v0.md`

### Relevant implementation surfaces

- `steam/tools/dev-vertical-slice.sh`
- `steam/scripts/prototypes/vertical_slice/vertical_slice_demo.gd`
- `steam/scripts/dev_tools/godot_state_connector.gd`
- `steam/scripts/game_systems/game_systems_runtime.gd`
- `steam/resources/game_systems/fixtures/first_day_empty_coop.json`
- other fixture/runtime files only if needed.

---

## 2. Required behavior

### 2.1 Preserve existing full-dispatch proof

The existing scenario must keep working:

```text
first_delivery_with_dispatch_confirmation
```

It must still prove:

```text
order.delivery_confirmed: true
order.postcard_visible: true
order.reward_available: true
game.chain_complete: true
production_chain.state: completed
production_chain.completed: true
event.player_confirmed_delivery: true
event.postcard_created: true
event.reward_created: true
```

Do not regress:

- `first_delivery_from_empty`
- `warm_food_delivery_mid_chain`
- `house_of_curiosity_learning_session`
- `runtime-foundation-smoke`
- `connector-control-smoke`
- `smoke`
- `check-godot`

### 2.2 Clean debug event noise

Current problem:

```text
debug_time_advanced:0.10
```

appears many times in `events.jsonl` and often has tag:

```text
production_chain
```

Required fix:

- debug tick events must not count as production events;
- use `tag: debug` for debug tick events, OR remove them from `events.jsonl` by default and keep them only in run/debug logs;
- `production_events_recent` should no longer grow primarily because of debug ticks.

Preferred minimal behavior:

```text
debug_time_advanced:* -> tag debug
```

and stress signals should exclude `tag=debug` from production/life/story counters.

### 2.3 Add high-level dog action events

Add designer-facing events for First Day dog-owned actions.

Required minimum set, names may differ if internally consistent:

```text
dog_departed_with_bicycle
dog_returned_with_payload
dog_started_unload
dog_picked_up_resource
dog_delivered_resource
dog_started_cooking
dog_created_food_mix
dog_started_packing
dog_created_food_bag
dog_loaded_van
dog_noticed_postcard
dog_received_reward
```

Each event should include, where applicable:

```text
dog_ids
building_ids / place_ids
chain_ids
resource id or payload
human-readable message
stable event type
appropriate tag: dog_action / movement / route / production_chain / helper_effect / story
```

Do not remove lower-level production events if they are useful, but high-level dog-action evidence must be visible in `events.jsonl` and final `/state.events`.

### 2.4 Add post-delivery dog/life moment

After delivery completion and postcard creation, add a small first-day emotional completion moment.

Design target from First Day MVP:

```text
Такса приносит/замечает открытку.
Лабрадор спокойно садится рядом / reacts as helper.
Такса получает Удобные тапочки.
Dog Card / state shows: “Помнит первую тёплую поставку”.
A soft next-day hint appears: “Завтра можно придумать, как паковать ещё аккуратнее.”
```

Implementation may be lightweight and runtime-scaffolded. It does not need final UI/art.

Required runtime evidence:

```text
first_day.postcard_life_moment_seen: true
first_day.first_reward_equipped: true
first_day.first_memory_added: true
first_day.next_day_hint_available: true
```

or equivalent fields under an accepted location.

Suggested state location:

```text
game.first_day
```

or:

```text
economy.life.first_day
```

Use the least invasive shape that fits the current runtime code, but document it.

Required event evidence:

```text
postcard_created
postcard_noticed_by_dog OR postcard_placed_on_board
reward_created
reward_equipped
dog_received_reward
first_day_memory_added
next_day_hint_available
```

### 2.5 Resolve delivered Food Bag semantic

Current final state ambiguity:

```text
order.delivered=true
order.status=reward_claimed
delivery_van_endpoint inventory still contains food_bag: 1
```

Required fix:

After delivery is confirmed/completed, Food Bag must no longer look like an undelivered item sitting in the van.

Preferred design:

```text
Food Bag moves to sent/offscreen_shelter; postcard/receipt becomes the visible completion artifact.
```

Acceptable implementation options:

1. Token state:

```text
food_bag.location: sent / delivered / offscreen_shelter
food_bag.visible: false
```

2. Inventory state:

```text
delivery_van_endpoint.food_bag: 0
sent_or_delivered.food_bag: 1
```

3. Explicit marker state:

```text
food_bag.location: delivery_van_endpoint
food_bag.semantic_state: dispatched
```

Option 1 is preferred. If Codex chooses another option, document why.

### 2.6 Clean legacy production_chain mismatch

Current issue:

- authoritative `production_chains[chain.warm_food_delivery_intro].state = completed`;
- legacy `production_chain` can still show `unload_to_storage: in_progress`.

Required behavior:

- legacy `production_chain` should match the completed flow after full first delivery; OR
- legacy `production_chain` should be explicitly marked as compatibility/non-authoritative so Workbench review does not misread it.

Preferred:

```text
legacy production_chain statuses align with completed chain after completion.
```

### 2.7 Update Workbench capture proof

`manifest.json` for `first_delivery_with_dispatch_confirmation` should include an expanded proof object.

Current proof:

```text
dispatch_confirmation_proof
```

Add or extend with first-day proof, for example:

```json
"first_day_mvp_proof": {
  "order.delivery_confirmed": true,
  "order.postcard_visible": true,
  "order.reward_available": true,
  "game.chain_complete": true,
  "production_chain.state": "completed",
  "event.player_confirmed_delivery": true,
  "event.postcard_created": true,
  "event.reward_created": true,
  "event.dog_noticed_postcard": true,
  "event.dog_received_reward": true,
  "event.first_day_memory_added": true,
  "first_day.postcard_life_moment_seen": true,
  "first_day.first_reward_equipped": true,
  "first_day.first_memory_added": true,
  "first_day.next_day_hint_available": true
}
```

Exact field names can differ, but the proof must assert emotional completion, not only technical chain completion.

---

## 3. Out of scope

Codex must NOT:

- add new dogs beyond Такса and Лабрадор;
- change first route/order meaning;
- add a second production chain;
- turn House of Curiosity into a full first-day research system;
- add active research tree, classroom flow, library flow or research balance;
- add mood/energy penalties;
- add friendship system;
- add monetization, donation prompts, ads, paid acceleration, gacha, paid reroll or FOMO;
- change final art style, palette, UI look, art pipeline or asset prompts;
- remove visible dog-owned production steps;
- replace dog/life events with pure inventory conversion;
- broaden dev controls beyond accepted first-day testing paths;
- add arbitrary state mutation, generic command execution or shell access;
- commit `.runtime` capture bundles.

This task is runtime/event/state polish for the accepted First Day MVP contract only.

---

## 4. Expected implementation shape

Likely touched areas:

```text
steam/scripts/prototypes/vertical_slice/vertical_slice_demo.gd
steam/scripts/game_systems/game_systems_runtime.gd
steam/scripts/dev_tools/godot_state_connector.gd
steam/tools/dev-vertical-slice.sh
steam/README.md
docs/repo/dev/godot-state-connector.md
docs/repo/api/godot-state-connector.openapi.yaml
docs/repo/status/CODEX_STATUS.md
```

Codex may touch fewer files if the implementation is simpler.

If OpenAPI changes, update `docs/repo/api/godot-state-connector.openapi.yaml`.

If `/state` shape changes, update connector docs.

If `workbench-capture` manifest proof changes, update Steam README and connector docs as needed.

---

## 5. Acceptance criteria

The task is accepted when all are true.

### 5.1 Full-dispatch scenario still passes

Command:

```sh
cd steam
./tools/dev-vertical-slice.sh workbench-capture \
  --scenario=first_delivery_with_dispatch_confirmation \
  --fixture=first_day_empty_coop \
  --game-seconds=420 \
  --sample-every-game-seconds=10 \
  --speed=100 \
  --output-dir=.runtime/workbench_capture_runs/_smoke_first_day_mvp_runtime_polish
```

Manifest/final state must confirm:

```text
order.delivery_confirmed: true
order.postcard_visible: true
order.reward_available: true
game.chain_complete: true
production_chains[chain.warm_food_delivery_intro].state: completed
```

### 5.2 First-day emotional proof exists

The same capture must show:

```text
postcard_life_moment_seen: true
first_reward_equipped: true
first_memory_added: true
next_day_hint_available: true
```

or equivalent documented fields.

Event log must contain equivalent event proof:

```text
dog_noticed_postcard OR postcard_placed_on_board
dog_received_reward
first_day_memory_added
next_day_hint_available
```

### 5.3 Debug tick noise fixed

`debug_time_advanced:*` must not be counted as production events.

Preferred assertion:

- debug tick events are `tag=debug`; and
- `production_events_recent` does not increment just because debug time advances after chain completion.

### 5.4 Dog action events visible

`events.jsonl` must contain high-level dog-owned events across the loop, enough to prove:

```text
dog travelled / returned
dog unloaded or picked up resource
dog carried/delivered resource
dog participated in cooking or packing
dog loaded van
dog noticed/received postcard/reward
```

### 5.5 Food Bag delivery semantic resolved

After delivery completion, final state must not imply an undelivered Food Bag remains in the van.

Preferred final proof:

```text
food_bag.location: sent/offscreen_shelter/delivered
food_bag.visible: false
```

or documented equivalent.

### 5.6 Legacy production_chain no longer contradicts authoritative state

After completion, legacy `production_chain` must either:

- show all completed statuses for First Delivery; OR
- be clearly marked legacy/non-authoritative in state/docs.

### 5.7 Regression scenarios still work

Existing scenarios must still run:

```text
first_delivery_from_empty
first_delivery_with_dispatch_confirmation
warm_food_delivery_mid_chain
house_of_curiosity_learning_session
```

---

## 6. Required checks

Minimum checks:

```sh
bash -n steam/tools/dev-vertical-slice.sh
bash -n steam/launch.sh
cd steam && tools/dev-vertical-slice.sh workbench-capture --help

cd steam && tools/dev-vertical-slice.sh workbench-capture \
  --scenario=first_delivery_with_dispatch_confirmation \
  --fixture=first_day_empty_coop \
  --game-seconds=420 \
  --sample-every-game-seconds=10 \
  --speed=100 \
  --output-dir=.runtime/workbench_capture_runs/_smoke_first_day_mvp_runtime_polish

python3 -m json.tool steam/.runtime/workbench_capture_runs/_smoke_first_day_mvp_runtime_polish/manifest.json >/dev/null
python3 -m json.tool steam/.runtime/workbench_capture_runs/_smoke_first_day_mvp_runtime_polish/final_state.json >/dev/null

cd steam && tools/dev-vertical-slice.sh workbench-capture \
  --scenario=first_delivery_from_empty \
  --fixture=first_day_empty_coop \
  --game-seconds=60 \
  --sample-every-game-seconds=10 \
  --speed=100 \
  --output-dir=.runtime/workbench_capture_runs/_smoke_first_delivery_from_empty_regression

cd steam && tools/dev-vertical-slice.sh workbench-capture \
  --scenario=warm_food_delivery_mid_chain \
  --fixture=warm_food_delivery_mid_chain \
  --game-seconds=30 \
  --sample-every-game-seconds=10 \
  --speed=100 \
  --output-dir=.runtime/workbench_capture_runs/_smoke_mid_chain_regression

cd steam && tools/dev-vertical-slice.sh workbench-capture \
  --scenario=house_of_curiosity_learning_session \
  --fixture=house_of_curiosity_learning_session \
  --game-seconds=30 \
  --sample-every-game-seconds=10 \
  --speed=100 \
  --output-dir=.runtime/workbench_capture_runs/_smoke_house_curiosity_regression

cd steam && tools/dev-vertical-slice.sh runtime-foundation-smoke
cd steam && tools/dev-vertical-slice.sh connector-control-smoke
cd steam && tools/dev-vertical-slice.sh smoke
cd steam && tools/check-godot.sh
```

If OpenAPI changes:

```sh
python3 - <<'PY'
import yaml
with open('docs/repo/api/godot-state-connector.openapi.yaml', 'r', encoding='utf-8') as f:
    yaml.safe_load(f)
PY
```

Also run:

```sh
git diff --check
```

Do not commit `.runtime` capture bundles.

---

## 7. Proof assertions Codex should perform

Codex should add local proof assertions in shell/python as appropriate for the smoke capture.

Required proof values:

```text
manifest.exit_status == success
manifest.first_day_mvp_proof or equivalent exists
order.delivery_confirmed == true
order.postcard_visible == true
order.reward_available == true
game.chain_complete == true
first_day.postcard_life_moment_seen == true OR equivalent
first_day.first_reward_equipped == true OR equivalent
first_day.first_memory_added == true OR equivalent
first_day.next_day_hint_available == true OR equivalent
events contain dog_noticed_postcard/postcard_placed_on_board OR equivalent
events contain dog_received_reward OR equivalent
events contain first_day_memory_added OR equivalent
events contain next_day_hint_available OR equivalent
```

Debug/event proof:

```text
debug_time_advanced events are not tag=production_chain
```

Food Bag proof:

```text
final Food Bag semantic no longer implies undelivered item sitting in van
```

---

## 8. Expected Codex final response

Codex should report:

- files changed;
- exact fields/events added;
- exact Food Bag semantic chosen;
- whether legacy `production_chain` was aligned or marked non-authoritative;
- smoke output directory;
- final proof values;
- checks run;
- known limitations;
- docs updated;
- whether a follow-up Game Designer runtime review is needed.

---

## 9. Next Game Designer review after implementation

After Codex finishes, Game Designer should run through Shelter MCP:

```text
command: workbench_capture
scenario: first_delivery_with_dispatch_confirmation
fixture: first_day_empty_coop
game_seconds: 420
sample_every_game_seconds: 10
speed: 100
output_dir: .runtime/workbench_capture_runs/first_day_mvp_runtime_polish_review_v0
include_artifacts: manifest.json, run.log, events.jsonl, stress_signals.jsonl, final_state.json
```

Target review question:

> Does First Day now end as a small dog/co-op life moment, not just a technical chain completion?

Target verdict:

```text
First Day MVP runtime evidence: PASS / PASS with watchpoints / needs fix
```

---

## 10. Changelog

### 2026-07-05 — v1 created

- Created R-21 Codex brief after First Day MVP v1 contract.
- Scoped task to runtime/event/state polish for first-day evidence.
- Added acceptance criteria for emotional completion, dog action events, debug event cleanup, Food Bag semantic and legacy chain consistency.
