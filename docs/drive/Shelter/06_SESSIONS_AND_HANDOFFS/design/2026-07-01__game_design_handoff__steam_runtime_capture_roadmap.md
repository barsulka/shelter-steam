# Game Design Handoff — Steam Runtime Capture Roadmap

Дата: 2026-07-01  
Роль сессии: Game Designer / Systems Designer  
Продукт: Shelter Steam/Desktop

---

## Что делали

- Восстановили проектный контекст после перегрева предыдущей Game Designer сессии.
- Прочитали базовые правила проекта, Steam rules, current status, decisions, philosophy, stress tests, systems docs R-09..R-16, runtime foundation docs and current state snapshot.
- Проверили текущий Game Design статус Steam/Desktop.
- Составили новый roadmap после завершения R-09..R-16.
- Оценили проблему инструментов: Atlas agent/browser control недоступен; ChatGPT может читать local files, but cannot reliably drive live browser/HTTP control.
- Подготовили Codex brief для file-based Workbench Runtime Capture Harness.

---

## Ключевые выводы

1. Game Design systems contracts R-09..R-16 уже завершены на v1 level.
2. Следующий этап — не писать dog progression / buildings / economy заново, а проверять live Godot runtime and produce evidence-based First Day MVP decisions.
3. Runtime Foundation v1 уже реализован частично достаточно сильно:
   - `/state` v0.2;
   - dogs/routes/production_chains/buildings/rooms/house_of_curiosity/economy/events/debug;
   - fixtures;
   - export/import;
   - debug tick;
   - speed `1/2/3/5/10`.
4. Полная live customer acceptance пока не закрыта из-за workflow/tooling gap, not because design model is missing.
5. Правильная альтернатива Atlas/browser agent — bounded file-based capture over live Godot runtime, writing JSONL bundles into `steam/.runtime`.
6. 100x-style capture should be treated as state-analysis acceleration, not visual/feel acceptance.

---

## Принятые рабочие решения

- Создан новый working roadmap:
  - `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Game_Design_Roadmap_v2.md`
- Создан Codex brief:
  - `docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Workbench_Runtime_Capture_Harness_v0.md`
- First recommended scenario for capture:
  - `first_delivery_from_empty`
  - fixture: `first_day_empty_coop`
  - setup: start accepted route
  - sample every 10 game seconds
  - use speed `10` and/or debug tick, not necessarily runtime speed `100`

---

## Открытые вопросы

1. Примет ли Producer R-17..R-23 roadmap direction as current Game Design critical path?
2. Реализует ли Codex capture harness через `dev-vertical-slice.sh workbench-capture` or separate helper script?
3. Достаточно ли existing debug tick + speed 10 for practical 100x-style capture, or is dev-only 100x multiplier still needed?
4. Какие runtime fields окажутся missing после первого JSONL review?
5. После first capture review, какой scope войдёт в `First Day MVP v1`?

---

## Ссылки / источники

Base / process:

- `PROJECTS_RULES.md`
- `AGENTS.md`
- `README.md`
- `steam/AGENTS.md`
- `steam/README.md`
- `docs/repo/status/CODEX_STATUS.md`

Core project docs:

- `docs/drive/Shelter/00_START_HERE/000_ROLE_GAME_DESIGNER.md`
- `docs/drive/Shelter/00_START_HERE/01_CURRENT_STATUS.md`
- `docs/drive/Shelter/00_START_HERE/02_DECISIONS.md`
- `docs/drive/Shelter/00_START_HERE/03_PROJECT_PHILOSOPHY.md`
- `docs/drive/Shelter/00_START_HERE/04_SHELTER_STRESS_TESTS.md`

Steam systems docs:

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

Runtime / dev docs:

- `docs/repo/dev/godot-state-connector.md`
- `docs/repo/api/godot-state-connector.openapi.yaml`
- `docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Acceptance_Report__Game_Systems_Runtime_Foundation_v1.md`
- `steam/.runtime/godot_state_connector/state_snapshot.json`

---

## Что обновлено в документах

Created:

- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Game_Design_Roadmap_v2.md`
- `docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Workbench_Runtime_Capture_Harness_v0.md`
- `docs/drive/Shelter/06_SESSIONS_AND_HANDOFFS/design/2026-07-01__game_design_handoff__steam_runtime_capture_roadmap.md`

---

## Следующий лучший шаг

Передать Codex задачу:

```text
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Workbench_Runtime_Capture_Harness_v0.md
```

Recommended Codex reasoning level:

```text
очень высокий
```

После выполнения Codex задачи запустить first capture scenario and let Game Designer review generated `.runtime/workbench_capture_runs/...` files.
