# Producer handoff — Godot State Connector replaces Systems Simulator

Дата: 2026-06-29

## Роль сессии

Producer / Project Manager проекта Shelter.

## Что делали

Проверили новый Codex brief:

`docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Godot_State_Connector_v0.md`

Сравнили его с ранее созданным Systems Simulator brief.

## Ключевые выводы

- Новый brief принят.
- Standalone Systems Simulator — плохое направление, потому что создаёт риск второй независимой модели мира рядом с Godot.
- Правильное направление: dev-only интерфейс к реально запущенной Godot-игре.
- Godot должен оставаться source of truth для dogs, tasks, queues, resources, buildings, order state, production chain and events.
- Connector должен быть observability bridge, а не отдельный simulator.

## Принятые решения

Godot State Connector v0 принят как активная задача Codex.

Active Codex brief:

`docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Godot_State_Connector_v0.md`

Recommended Codex reasoning level: **очень высокий**.

Old Systems Simulator brief archived as superseded:

`docs/drive/Shelter/99_ARCHIVE/STEAM_DESKTOP__Codex_Brief__Systems_Simulator_v0__SUPERSEDED_BY_GODOT_STATE_CONNECTOR.md`

## Открытые вопросы

- Нужен ли tunnel-ready mode в v0, или достаточно localhost + snapshot JSON.
- Насколько текущий Vertical Slice prototype удобно экспортирует state без рефакторинга.
- Нужно ли сразу делать маленький read-only inspector page или достаточно `/state` + snapshot file.

## Ссылки / источники

Прочитаны и использованы:

- `PROJECTS_RULES.md`
- `AGENTS.md`
- `docs/drive/Shelter/00_START_HERE/01_CURRENT_STATUS.md`
- `docs/drive/Shelter/00_START_HERE/02_DECISIONS.md`
- `docs/drive/Shelter/00_START_HERE/000_ROLE_PRODUCER.md`
- `docs/drive/Shelter/00_START_HERE/000_ROLE_CODEX.md`
- `docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Godot_State_Connector_v0.md`
- old `STEAM_DESKTOP__Codex_Brief__Systems_Simulator_v0.md`

## Что обновлено в документах

Обновлено напрямую:

- `docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Godot_State_Connector_v0.md`
- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Game_Systems_Roadmap_v1.md`
- `docs/drive/Shelter/00_START_HERE/02_DECISIONS.md`
- `docs/drive/Shelter/00_START_HERE/01_CURRENT_STATUS.md`
- этот handoff.

Перемещено в архив:

- from `docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Systems_Simulator_v0.md`
- to `docs/drive/Shelter/99_ARCHIVE/STEAM_DESKTOP__Codex_Brief__Systems_Simulator_v0__SUPERSEDED_BY_GODOT_STATE_CONNECTOR.md`

## Следующий лучший шаг

Запускать Codex по новому brief:

```text
Codex brief:
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Godot_State_Connector_v0.md

Уровень рассуждений:
очень высокий
```
