# Producer handoff — Game Systems Workbench

Дата: 2026-06-30

## Роль сессии

Producer проекта Shelter.

## Что делали

Рассмотрели сообщение Game Designer с предложением уточнить critical path роли:

- считать gameplay-часть Vertical Slice достаточно доказанной;
- оставить final visual acceptance в зоне Art Director;
- убрать visual review из critical path Game Designer;
- открыть новую ветку Game Systems;
- развивать не standalone simulator, а Game Design Systems Workbench поверх реально запущенного Godot runtime.

## Ключевые выводы

- Предложение принято.
- Это не меняет продукт и не отменяет visual review.
- Это уточняет рабочий путь Game Designer после Vertical Slice.
- Godot уже имеет State Connector, Control Connector and Viewport Capture API, поэтому отдельный simulator больше не нужен и даже вреден как риск второй независимой модели мира.
- Workbench должен быть inspector/control layer over live Godot runtime, not separate gameplay simulation.

## Принятые решения

Добавлено D-019 — Game Design Systems Workbench over live Godot runtime.

Принцип:

> Godot runtime is the source of truth. Workbench observes and controls accepted dev surfaces; it does not simulate Shelter independently.

Game Designer critical path:

1. R-09 — Dog Progression Model.
2. R-10 — Ability Source Loop.
3. R-11 — Ability Catalog.
4. R-12 — Buildings & Production Chains.
5. R-13 — Laboratory / Research Tree.
6. R-14 — Activities Catalog.
7. R-15 — Economy & Balance Foundations.
8. R-16 — Game Design Systems Workbench.

Workbench grows through future accepted Codex briefs and extends:

- State Connector `/state`;
- Control Connector / control page;
- Viewport Capture API;
- design-facing inspection views;
- strictly whitelisted dev controls where explicitly accepted.

## Открытые вопросы

- Какие поля Dog Progression Model должны первыми попасть в `/state.dogs[]`.
- Какой первый Workbench expansion brief понадобится после R-09 / R-10 / R-11.
- Какие control actions допустимы в будущем beyond current toggle/capture, если вообще допустимы.
- Нужен ли отдельный Art Director visual acceptance roadmap по Vertical Slice / Dog Shape Pack v1.

## Ссылки / источники

Прочитаны и использованы:

- `PROJECTS_RULES.md`
- `AGENTS.md`
- `README.md`
- `docs/repo/status/CODEX_STATUS.md`
- `docs/drive/Shelter/00_START_HERE/01_CURRENT_STATUS.md`
- `docs/drive/Shelter/00_START_HERE/02_DECISIONS.md`
- `docs/drive/Shelter/00_START_HERE/000_ROLE_PRODUCER.md`
- `docs/drive/Shelter/00_START_HERE/000_ROLE_GAME_DESIGNER.md`
- `docs/drive/Shelter/00_START_HERE/000_ROLE_ART_DIRECTOR.md`
- `docs/drive/Shelter/00_START_HERE/000_ROLE_CODEX.md`
- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Game_Systems_Roadmap_v1.md`
- `docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Godot_State_Connector_v0.md`
- `docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Godot_Control_Connector_v0.md`
- `docs/repo/api/godot-state-connector.openapi.yaml`

## Что обновлено в документах

Обновлено напрямую:

- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Game_Systems_Roadmap_v1.md`
- `docs/drive/Shelter/00_START_HERE/02_DECISIONS.md`
- `docs/drive/Shelter/00_START_HERE/01_CURRENT_STATUS.md`
- этот handoff.

## Следующий лучший шаг

Game Designer:

1. начать `R-09 — Dog Progression Model`;
2. затем `R-10 — Ability Source Loop`;
3. затем `R-11 — Ability Catalog`.

Codex:

- не начинать новый Workbench expansion без отдельного brief в `docs/drive/Shelter/04_DEVELOPMENT/`;
- будущие briefs должны расширять live Godot connectors, not implement a standalone simulator.

Art Director:

- продолжать закрывать visual proof Vertical Slice separately from Game Designer systems work.
