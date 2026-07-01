# STEAM_DESKTOP — Codex Brief — Workbench Runtime Capture Harness v0

Дата: 2026-07-01  
Статус: draft for Codex  
Роль-владелец постановки: Game Designer / Systems Designer  
Рекомендуемый уровень рассуждений Codex: очень высокий

---

## 0. Цель задачи

Добавить dev-only file-based capture harness для Shelter Steam/Desktop, чтобы Game Designer мог анализировать live Godot runtime через локальные файлы, даже когда Atlas agent/browser control page недоступны.

Главная проблема:

- Godot runtime foundation уже умеет отдавать `/state`, fixtures, export/import, debug tick and runtime controls;
- ChatGPT в текущем рабочем режиме может читать локальные файлы через local file server;
- ChatGPT не может надёжно нажимать browser control page и выполнять token-protected HTTP POST к live connector;
- значит нужен repeatable shell workflow, который запускается человеком локально and writes review bundles into ignored `.runtime` directory.

Главная формула:

> Use live Godot runtime as source of truth, advance accepted debug time, sample state into files, let Game Designer review files.

---

## 1. Обязательные источники

Codex обязан прочитать перед началом:

### Project / process

- `PROJECTS_RULES.md`
- `AGENTS.md`
- `README.md`
- `steam/AGENTS.md`
- `steam/README.md`
- `docs/repo/status/CODEX_STATUS.md`
- `docs/drive/Shelter/00_START_HERE/03_PROJECT_PHILOSOPHY.md`
- `docs/drive/Shelter/00_START_HERE/04_SHELTER_STRESS_TESTS.md`
- `docs/drive/Shelter/00_START_HERE/02_DECISIONS.md` — D-017, D-018, D-019, D-020

### Current Game Design roadmap and systems docs

- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Game_Design_Roadmap_v2.md`
- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Game_Design_Systems_Workbench_Requirements_v1.md`
- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Core_Gameplay_Loop_Validation_v1.md`
- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Economy_Balance_Foundations_v1.md`
- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Production_Chains_v1.md`
- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Building_System_v1.md`
- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Laboratory_Research_Tree_v1.md`

### Existing runtime / connector docs

- `docs/repo/dev/godot-state-connector.md`
- `docs/repo/api/godot-state-connector.openapi.yaml`
- `docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Game_Systems_Runtime_Foundation_v1.md`
- `docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Checklist__Game_Systems_Runtime_Foundation_v1.md`
- `docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Acceptance_Report__Game_Systems_Runtime_Foundation_v1.md`

### Existing implementation surfaces

- `steam/launch.sh`
- `steam/tools/dev-vertical-slice.sh`
- `steam/scripts/dev_tools/godot_state_connector.gd`
- `steam/scripts/game_systems/game_systems_runtime.gd`
- `steam/scripts/prototypes/vertical_slice/vertical_slice_demo.gd`
- `steam/resources/game_systems/fixtures/*.json`

---

## 2. Scope

### 2.1 Add file-based runtime capture command

Add a dev-only command available from the repo, preferably through the existing Steam dev script:

```sh
cd steam
./tools/dev-vertical-slice.sh workbench-capture ...
```

Codex may choose a different helper script if cleaner, but `dev-vertical-slice.sh` should expose a documented entry point.

The command must:

1. start or reuse the local Godot Vertical Slice runtime with control enabled;
2. load an accepted fixture or scenario;
3. optionally run accepted setup actions;
4. advance bounded debug game time;
5. sample `/state` repeatedly;
6. write a local review bundle under `steam/.runtime/workbench_capture_runs/<run_id>/`;
7. exit cleanly or keep running only when explicitly requested.

### 2.2 Output bundle

Default output directory:

```text
steam/.runtime/workbench_capture_runs/<run_id>/
```

`steam/.runtime/` is already gitignored and must remain the location for generated capture artifacts.

Required files:

```text
manifest.json
snapshots.jsonl
events.jsonl
final_state.json
```

Recommended optional files:

```text
state_diffs.jsonl
stress_signals.jsonl
run.log
```

### 2.3 Manifest content

`manifest.json` should include:

```text
run_id
created_at
script_version
repo_root
steam_root
fixture_id
scenario_id
requested_game_seconds
sample_every_game_seconds
speed_multiplier
debug_tick_seconds_per_sample
snapshot_count
state_schema_version
runtime_schema_version
output_files
command_line
exit_status
known_warnings
```

Do not write long-lived public tunnel URLs or reusable tokens into docs. Runtime bundles under `.runtime` may contain local ephemeral details if unavoidable, but prefer redacting token values in manifest/log when easy.

### 2.4 Snapshots JSONL

`snapshots.jsonl` should contain one JSON object per sample.

Each line should include:

```text
run_id
sample_index
sample_game_time
sample_wall_time
scenario_id
fixture_id
state
```

`state` can be the full `/state` payload for v0. Simpler full-state capture is better than a lossy partial capture.

### 2.5 Events JSONL

`events.jsonl` should contain event records observed during the run.

Acceptable v0 options:

- full `state.events` copied from each sample with `sample_index` attached;
- or event delta by event id, if simple and reliable.

Event output is critical for Game Designer review.

### 2.6 Stress signals JSONL

If state has `stress_test_signals`, write either:

- `stress_signals.jsonl`, one line per sample;
- or include stress signals inside each snapshot only.

Prefer separate file if quick.

---

## 3. Scenario support

### 3.1 Required built-in scenarios

Implement at least these scenario ids:

```text
first_delivery_from_empty
warm_food_delivery_mid_chain
house_of_curiosity_learning_session
```

### 3.2 Scenario: first_delivery_from_empty

Start from existing fixture:

```text
steam/resources/game_systems/fixtures/first_day_empty_coop.json
```

Setup actions:

1. load fixture `first_day_empty_coop`;
2. start accepted test route through existing runtime route action;
3. sample state until requested game seconds finish.

Purpose:

- validate the first Warm Food Delivery from an empty first-day state.

### 3.3 Scenario: warm_food_delivery_mid_chain

Start from existing fixture:

```text
steam/resources/game_systems/fixtures/warm_food_delivery_mid_chain.json
```

Setup actions:

1. load fixture `warm_food_delivery_mid_chain`;
2. sample state and continue chain where possible.

Purpose:

- validate production chain continuation from resource-ready state.

### 3.4 Scenario: house_of_curiosity_learning_session

Start from existing fixture:

```text
steam/resources/game_systems/fixtures/house_of_curiosity_learning_session.json
```

Setup actions:

1. load fixture `house_of_curiosity_learning_session`;
2. optionally start or preserve `research.soft_packing` state;
3. sample state.

Purpose:

- validate room assignment, research progress, dog activity detail, House of Curiosity visibility.

---

## 4. Time advancement model

### 4.1 Preferred model

Use accepted runtime controls to advance time.

Do not add standalone simulation in shell/python.

Preferred v0:

1. set accepted speed multiplier, default `10`;
2. for each sample interval, call bounded `runtime.debug.tick` enough to advance the desired game time;
3. fetch `/state`;
4. write JSONL line.

Existing accepted speed multipliers are:

```text
1 / 2 / 3 / 5 / 10
```

Do not expand speed multiplier to `100` unless the existing runtime architecture clearly supports it safely and docs are updated.

### 4.2 About “100x” capture

The design need is:

```text
sample every 10 game seconds without waiting 10 real seconds
```

This does not require final runtime speed `100x`.

It can be achieved by:

- speed `10x`;
- debug tick requests;
- immediate state sampling;
- no real-time sleep except minimal process/HTTP pacing.

If Codex does add `100x`, it must be dev-only, documented as capture/testing-only, visible in `/state.debug`, and must not become player-facing or normal feel-test speed.

### 4.3 Guardrail

Accelerated state capture validates state transitions and causality.

It does not validate:

- desktop calmness;
- animation warmth;
- visual readability;
- player comfort at real speed.

Do not present accelerated capture as visual/feel acceptance.

---

## 5. CLI contract

Desired first command after implementation:

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

Required args:

```text
--scenario
--game-seconds
--sample-every-game-seconds
--output-dir
```

Optional args:

```text
--fixture
--speed
--keep-running
--port
--token
--include-full-state=true/false, if implemented
```

Defaults:

```text
scenario=first_delivery_from_empty
fixture=derived from scenario
game-seconds=180
sample-every-game-seconds=10
speed=10
output-dir=.runtime/workbench_capture_runs/<timestamp>__<scenario>
keep-running=false
```

The script must print the final output directory clearly.

---

## 6. Out of scope

Codex must NOT:

- create standalone simulator;
- duplicate game logic outside Godot;
- create player-facing UI;
- add broad remote command execution;
- add arbitrary filesystem command endpoint;
- add production save tooling;
- add monetization, charity claims, gacha, reroll or paid acceleration;
- claim visual or feel acceptance from accelerated JSON capture;
- commit `.runtime` output files;
- require Atlas/browser UI for this workflow.

---

## 7. Acceptance criteria

Task is accepted when:

1. A documented `workbench-capture` command exists.
2. The command runs from `cd steam` on macOS Bash 3.2.
3. It uses live Godot runtime/connector as source of truth.
4. It supports the three required scenarios.
5. It writes `manifest.json`, `snapshots.jsonl`, `events.jsonl`, and `final_state.json` under `steam/.runtime/workbench_capture_runs/<run_id>/`.
6. Output JSON files parse successfully.
7. `snapshots.jsonl` has the expected number of samples for the requested game duration and sample interval.
8. `manifest.json` records run parameters and output paths.
9. Existing smoke checks still pass.
10. OpenAPI/docs are updated only if endpoint/schema changes are made.
11. `docs/repo/dev/godot-state-connector.md` or Steam dev docs document the new workflow.
12. `docs/repo/status/CODEX_STATUS.md` is updated with changed files, checks and known limitations.
13. No `.runtime` output files are committed.
14. No standalone simulation or new gameplay semantics are introduced.

---

## 8. Required checks

Minimum checks:

```sh
bash -n steam/tools/dev-vertical-slice.sh
bash -n steam/launch.sh
cd steam && tools/dev-vertical-slice.sh runtime-foundation-smoke
cd steam && tools/dev-vertical-slice.sh workbench-capture --scenario=first_delivery_from_empty --game-seconds=30 --sample-every-game-seconds=10 --speed=10 --output-dir=.runtime/workbench_capture_runs/_smoke_first_delivery
python3 -m json.tool .runtime/workbench_capture_runs/_smoke_first_delivery/manifest.json >/dev/null
python3 -m json.tool .runtime/workbench_capture_runs/_smoke_first_delivery/final_state.json >/dev/null
python3 - <<'PY'
import json, pathlib
path = pathlib.Path('.runtime/workbench_capture_runs/_smoke_first_delivery/snapshots.jsonl')
lines = path.read_text().splitlines()
assert lines, 'empty snapshots.jsonl'
for line in lines:
    json.loads(line)
print(len(lines))
PY
cd steam && tools/check-godot.sh
git diff --check
```

Codex may adjust paths if the script is run from repo root vs `steam`, but equivalent checks are required.

---

## 9. Final response expected from Codex

Codex should report:

- files changed;
- command to run first scenario;
- output directory shape;
- exact generated file names;
- how to run smoke capture;
- whether `100x` was implemented or intentionally avoided;
- tests run;
- known limitations;
- docs updated.

---

## 10. First Game Designer run after implementation

Once Codex finishes, Game Designer should ask the human to run:

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

Then Game Designer will read:

```text
steam/.runtime/workbench_capture_runs/first_delivery_from_empty_v0/manifest.json
steam/.runtime/workbench_capture_runs/first_delivery_from_empty_v0/snapshots.jsonl
steam/.runtime/workbench_capture_runs/first_delivery_from_empty_v0/events.jsonl
steam/.runtime/workbench_capture_runs/first_delivery_from_empty_v0/final_state.json
```

and produce a runtime design review.

---

## 11. Changelog

### 2026-07-01 — v0 brief created

- Created Codex brief for file-based Workbench Runtime Capture Harness.
- Scope solves ChatGPT/local-file review workflow without Atlas/browser control.
- Required live Godot source of truth, JSONL snapshots, event capture, manifest and three scenarios.
