# STEAM_DESKTOP — Codex Brief — Dispatch Confirmation Capture Path v0

Дата: 2026-07-03  
Статус: draft for Codex  
Роль-владелец постановки: Game Designer / Systems Designer  
Рекомендуемый уровень рассуждений Codex: очень высокий

---

## 0. Цель

Добавить accepted dev-only path для проверки полной первой доставки после точки `ready_to_dispatch`.

Текущий `workbench-capture` уже подтверждает `first_delivery_from_empty` до состояния:

```text
order.status: loaded
order.delivery_state: ready_to_send
order.van_loaded: true
order.next_expected_player_action: подтвердить отправку
production chain state: ready_to_dispatch
current_step: player_confirms_dispatch
blocked_reason: waiting_for_player_confirmation
```

Это корректная calm wait точка, но Game Designer review пока не может проверить:

```text
player confirms dispatch
-> delivery dispatched
-> postcard visible
-> reward available
-> chain complete
```

Нужно добавить узкий, безопасный, whitelisted dev-only способ пройти именно это игроковое подтверждение в capture-сценарии.

---

## 1. Обязательные источники

Перед началом Codex обязан прочитать:

- `PROJECTS_RULES.md`
- `AGENTS.md`
- `README.md`
- `steam/AGENTS.md`
- `steam/README.md`
- `docs/repo/status/CODEX_STATUS.md`
- `docs/repo/dev/godot-state-connector.md`
- `docs/repo/api/godot-state-connector.openapi.yaml`
- `docs/drive/Shelter/00_START_HERE/02_DECISIONS.md`
- `docs/drive/Shelter/00_START_HERE/03_PROJECT_PHILOSOPHY.md`
- `docs/drive/Shelter/00_START_HERE/04_SHELTER_STRESS_TESTS.md`
- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Production_Chains_v1.md`
- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Core_Gameplay_Loop_Validation_v1.md`
- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Game_Design_Systems_Workbench_Requirements_v1.md`
- `docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Workbench_Runtime_Capture_Harness_v0.md`
- `docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Runtime_Review__First_Delivery_Capture_v0.md`

Relevant implementation surfaces:

- `steam/tools/dev-vertical-slice.sh`
- `steam/scripts/dev_tools/godot_state_connector.gd`
- `steam/scripts/game_systems/game_systems_runtime.gd`
- `steam/scripts/prototypes/vertical_slice/vertical_slice_demo.gd`
- `steam/resources/game_systems/fixtures/*.json`

---

## 2. Required behavior

Add a new accepted workbench capture scenario:

```text
first_delivery_with_dispatch_confirmation
```

Scenario must:

1. load fixture `first_day_empty_coop`;
2. start the accepted first route exactly as `first_delivery_from_empty` does;
3. advance runtime until the first delivery reaches `ready_to_dispatch` / `waiting_for_player_confirmation`;
4. perform a narrow accepted dispatch confirmation action;
5. continue sampling until postcard/reward/chain completion is observable, or until requested game seconds expire;
6. write the same bundle shape as existing `workbench-capture`:

```text
manifest.json
snapshots.jsonl
events.jsonl
stress_signals.jsonl
final_state.json
run.log
```

---

## 3. Preferred implementation shape

Prefer a narrow runtime control action over any generic command system.

Recommended endpoint shape:

```text
POST /control/runtime/delivery/confirm
```

or another similarly narrow endpoint name if it fits existing code better.

The action must only confirm the accepted first delivery when the runtime is in the correct state.

Expected validation:

- route/order exists;
- `order.delivery_state == "ready_to_send"` or equivalent runtime state;
- `order.van_loaded == true`;
- production chain is waiting for player dispatch confirmation;
- no arbitrary order/task/resource mutation is accepted.

Invalid state should return a clear dev error object, not silently mutate runtime.

If an endpoint is added, update:

- `docs/repo/api/godot-state-connector.openapi.yaml`
- `docs/repo/dev/godot-state-connector.md`
- any relevant Steam README/control docs.

---

## 4. Out of scope

Codex must NOT:

- add generic shell/command execution;
- add arbitrary task/resource/order mutation;
- add broad cheat controls;
- make dispatch automatic in normal gameplay;
- remove the player confirmation step from the product loop;
- claim visual/readability/player-feel acceptance from 100x JSON capture;
- add monetization, charity, ads, gacha, reroll, paid acceleration or FOMO mechanics;
- commit `.runtime` capture output.

This task is only a dev-only accepted capture/testing path.

---

## 5. CLI contract

After implementation this command should work:

```sh
cd steam
./tools/dev-vertical-slice.sh workbench-capture \
  --scenario=first_delivery_with_dispatch_confirmation \
  --fixture=first_day_empty_coop \
  --game-seconds=420 \
  --sample-every-game-seconds=10 \
  --speed=100 \
  --output-dir=.runtime/workbench_capture_runs/first_delivery_with_dispatch_confirmation_v0
```

Codex may tune default `game-seconds` if a shorter reliable value is proven by smoke tests, but the scenario must robustly reach completion on normal local dev machines.

---

## 6. Acceptance criteria

The task is accepted when:

1. `workbench-capture` supports scenario `first_delivery_with_dispatch_confirmation`.
2. Scenario reaches `ready_to_dispatch` before confirming dispatch.
3. Dispatch confirmation is done through a whitelisted accepted runtime action, not generic mutation.
4. Final state of the smoke capture includes:

```text
order.delivery_confirmed: true
order.postcard_visible: true
order.reward_available: true
game.chain_complete: true
```

5. Production chain state is completed or equivalent accepted completed state.
6. Event log contains readable events for dispatch confirmation and postcard/reward availability.
7. Existing scenarios still work:

```text
first_delivery_from_empty
warm_food_delivery_mid_chain
house_of_curiosity_learning_session
```

8. Existing smoke checks still pass.
9. OpenAPI/docs are updated if a new endpoint/action is added.
10. `docs/repo/status/CODEX_STATUS.md` is updated with changed files, checks and limitations.
11. No `.runtime` files are committed.

---

## 7. Required checks

Minimum checks:

```sh
bash -n steam/tools/dev-vertical-slice.sh
bash -n steam/launch.sh
cd steam && tools/dev-vertical-slice.sh workbench-capture --help
cd steam && tools/dev-vertical-slice.sh workbench-capture --scenario=first_delivery_with_dispatch_confirmation --fixture=first_day_empty_coop --game-seconds=420 --sample-every-game-seconds=10 --speed=100 --output-dir=.runtime/workbench_capture_runs/_smoke_first_delivery_dispatch
python3 -m json.tool steam/.runtime/workbench_capture_runs/_smoke_first_delivery_dispatch/manifest.json >/dev/null
python3 -m json.tool steam/.runtime/workbench_capture_runs/_smoke_first_delivery_dispatch/final_state.json >/dev/null
cd steam && tools/dev-vertical-slice.sh workbench-capture --scenario=first_delivery_from_empty --game-seconds=30 --sample-every-game-seconds=10 --speed=100 --output-dir=.runtime/workbench_capture_runs/_smoke_first_delivery_regression
cd steam && tools/dev-vertical-slice.sh runtime-foundation-smoke
cd steam && tools/dev-vertical-slice.sh smoke
cd steam && tools/check-godot.sh
git diff --check
```

If the OpenAPI file changes, also parse/validate the YAML similarly to existing project checks.

---

## 8. Expected Codex final response

Codex should report:

- files changed;
- whether a new endpoint/action was added;
- exact command to run full dispatch capture;
- generated smoke output directory;
- final-state proof values;
- checks run;
- known limitations;
- docs updated.

---

## 9. Next Game Designer review after implementation

After Codex finishes, Game Designer should run through Shelter MCP or terminal:

```sh
cd steam
./tools/dev-vertical-slice.sh workbench-capture \
  --scenario=first_delivery_with_dispatch_confirmation \
  --fixture=first_day_empty_coop \
  --game-seconds=420 \
  --sample-every-game-seconds=10 \
  --speed=100 \
  --output-dir=.runtime/workbench_capture_runs/first_delivery_with_dispatch_confirmation_v0
```

Then inspect:

```text
manifest.json
snapshots.jsonl
events.jsonl
stress_signals.jsonl
final_state.json
run.log
```

Target verdict: First Delivery full production loop PASS through dispatch, postcard, reward and chain completion.
