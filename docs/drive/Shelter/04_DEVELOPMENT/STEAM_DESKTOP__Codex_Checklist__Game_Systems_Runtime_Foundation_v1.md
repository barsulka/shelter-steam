# STEAM_DESKTOP — Codex Checklist — Game Systems Runtime Foundation v1

Дата: 2026-06-30
Статус: completed Codex execution checklist
Связанный brief: `docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Game_Systems_Runtime_Foundation_v1.md`

## Правило работы

- [x] После каждого сжатия контекста сначала перечитать:
  - `PROJECTS_RULES.md`
  - `AGENTS.md`
  - brief Runtime Foundation v1
  - этот checklist
- [x] После завершения каждого шага отмечать его в этом checklist.
- [x] Если следующий шаг детализируется или меняется по фактам реализации, сначала обновить этот checklist, затем продолжить код.
- [x] После каждого значимого изменения запускать релевантную проверку, включая localhost-проверки connector/control, если изменение влияет на `/state`, `/control`, save/import/export или dev actions.

## Шаги

- [x] 1. Создать этот md-checklist и использовать его как рабочий контракт выполнения.
- [x] 2. Зафиксировать baseline текущего состояния:
  - [x] `cd steam && tools/check-godot.sh`
  - [x] `cd steam && tools/dev-vertical-slice.sh smoke`
  - [x] `cd steam && tools/dev-vertical-slice.sh connector-smoke`
  - [x] `cd steam && tools/dev-vertical-slice.sh connector-control-smoke`
  - [x] localhost `/health`, `/schema`, `/state`, `/control`
- [x] 3. Отрефакторить `vertical_slice_demo.gd` вокруг runtime-модуля без изменения player-facing loop.
- [x] 4. Добавить structured runtime state:
  - [x] `game`
  - [x] `dogs`
  - [x] `routes`
  - [x] `production_chains`
  - [x] `buildings`
  - [x] `rooms`
  - [x] `house_of_curiosity`
  - [x] `economy`
  - [x] `events`
  - [x] `debug`
  - [x] legacy compatibility: `order`, `tasks`, `resources`, `production_chain`
- [x] 5. Добавить structured event log с required tags.
- [x] 6. Добавить debug speed multiplier `1x / 2x / 3x / 5x / 10x`.
- [x] 7. Добавить JSON export/import, clear/reset local prototype save, fixture list/load и start-from-save workflow.
- [x] 8. Добавить fixtures:
  - [x] `steam/resources/game_systems/fixtures/first_day_empty_coop.json`
  - [x] `steam/resources/game_systems/fixtures/warm_food_delivery_mid_chain.json`
  - [x] `steam/resources/game_systems/fixtures/house_of_curiosity_learning_session.json`
- [x] 9. Расширить dev-only token-protected control API без generic command execution.
- [x] 10. Обновить OpenAPI, connector docs, Steam README и dev docs.
- [x] 11. Добавить/обновить smoke checks для runtime foundation.
- [x] 12. Провести финальную localhost acceptance:
  - [x] открыть `/control`
  - [x] проверить unauthorized masked `404`
  - [x] set speed и проверить `/state.debug`
  - [x] list fixtures
  - [x] load fixture
  - [x] export state
  - [x] clear/reset save
  - [x] import modified JSON
  - [x] перезапустить игру со state/fixture и проверить `/state`
  - [x] start accepted route
  - [x] assign dog to accepted activity/room
  - [x] start House of Curiosity research
  - [x] bounded debug tick
- [x] 13. Финальные проверки:
  - [x] `cd steam && tools/check-godot.sh`
  - [x] `cd steam && tools/dev-vertical-slice.sh smoke`
  - [x] `cd steam && tools/dev-vertical-slice.sh connector-smoke`
  - [x] `cd steam && tools/dev-vertical-slice.sh connector-control-smoke`
  - [x] `cd steam && tools/dev-vertical-slice.sh runtime-foundation-smoke`
  - [x] OpenAPI YAML parse
  - [x] `git diff --check`
- [x] 14. Обновить `docs/repo/status/CODEX_STATUS.md` с changed files, checks, localhost acceptance и known limitations.

## Журнал Выполнения

### 2026-06-30

- Создан checklist перед реализацией, как первый обязательный шаг плана.
- Выполнен шаг 1: checklist создан и отмечен.
- Выполнен шаг 2 baseline:
  - `cd steam && tools/check-godot.sh` — passed.
  - `cd steam && tools/dev-vertical-slice.sh smoke` — passed.
  - `cd steam && tools/dev-vertical-slice.sh connector-smoke` — passed on `http://127.0.0.1:18765/state`.
  - `cd steam && tools/dev-vertical-slice.sh connector-control-smoke` — passed on `http://127.0.0.1:18766/control`.
  - temporary headless localhost control check — passed on `http://127.0.0.1:18767`.
- Выполнены шаги 3-5:
  - Добавлен `steam/scripts/game_systems/game_systems_runtime.gd`.
  - `vertical_slice_demo.gd` подключён к runtime для structured `/state`, event log и debug speed core.
  - Passed: Godot check-only для runtime и Vertical Slice scripts.
  - Passed: `cd steam && tools/dev-vertical-slice.sh smoke`.
  - Passed: `cd steam && tools/dev-vertical-slice.sh connector-smoke`.
  - Passed: `cd steam && tools/dev-vertical-slice.sh connector-control-smoke`.
  - Passed: localhost structured state groups check on `http://127.0.0.1:18768/state`.
- Выполнены шаги 6-9 и 11:
  - Debug speed multiplier поддерживает `1x / 2x / 3x / 5x / 10x` и виден в `/state.debug`.
  - Добавлены JSON export/import, clear/reset, local prototype save write/load/erase, fixture list/load и `--runtime-load-save`.
  - Добавлены 3 fixture JSON-файла в `steam/resources/game_systems/fixtures/`.
  - Расширен token-protected `/control/runtime/*` API без generic command execution.
  - Passed: `cd steam && tools/dev-vertical-slice.sh runtime-foundation-smoke` on `http://127.0.0.1:18767/control`.
- Выполнен шаг 10:
  - Обновлены OpenAPI v0.2, connector dev docs, Steam README и Vertical Slice prototype dev docs.
  - Passed: OpenAPI YAML parse and runtime v0.2 path/schema assertions.
- Выполнен шаг 12:
  - Passed: `cd steam && tools/dev-vertical-slice.sh runtime-foundation-smoke`.
  - Passed: localhost helper/launcher fixture-save acceptance:
    `tools/dev-vertical-slice.sh connector-control --runtime-load-fixture=warm_food_delivery_mid_chain` -> `runtime.save.write` -> `./launch.sh -- --runtime-load-save` -> `/state` -> `runtime.save.erase`.
- Выполнены шаги 13-14:
  - Passed: `bash -n steam/launch.sh`.
  - Passed: `bash -n steam/tools/dev-vertical-slice.sh`.
  - Passed: JSON parse for all three runtime fixtures.
  - Passed: OpenAPI YAML parse and v0.2 assertions.
  - Passed: Godot check-only for runtime, connector and Vertical Slice scripts.
  - Passed: `cd steam && tools/dev-vertical-slice.sh smoke`.
  - Passed: `cd steam && tools/dev-vertical-slice.sh connector-smoke`.
  - Passed: `cd steam && tools/dev-vertical-slice.sh connector-control-smoke`.
  - Passed: `cd steam && tools/dev-vertical-slice.sh runtime-foundation-smoke`.
  - Passed: `cd steam && tools/check-godot.sh`.
  - Passed: `git diff --check`.
  - Updated: `docs/repo/status/CODEX_STATUS.md`.
