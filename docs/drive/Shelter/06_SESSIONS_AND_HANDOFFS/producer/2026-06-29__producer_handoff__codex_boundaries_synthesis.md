# Producer handoff — Codex boundaries RFC synthesis

Дата: 2026-06-29

## Роль сессии

Producer проекта Shelter.

## Что делали

Вернулись к первому Cross-role RFC:

`06_SESSIONS_AND_HANDOFFS/cross_role_sessions/2026-06-29__cross_role_rfc__codex_task_boundaries_steam_vertical_slice.md`

Проверили, что секции Game Designer, Art Director и Codex заполнены, сделали Producer synthesis и приняли implementation-boundary решение для Steam Vertical Slice.

## Ключевые выводы

- Позиции Game Designer, Art Director и Codex совместимы.
- Все три роли сходятся на том, что Codex может владеть технической формой реализации, debug tooling и neutral placeholders.
- Все три роли сходятся на том, что Codex не должен менять locked gameplay loop, visible cause-and-effect, resource flow, object taxonomy, visual direction, player-facing UI meaning, product scope или ethical boundaries.
- Найден и исправлен важный конфликт: `STEAM_DESKTOP__Codex_Implementation_Brief__Vertical_Slice_v1.md` ранее считал `approved/utility_props/packing_table.png` доступным, но Semantic Asset Pack / Art Director / Codex status говорят, что Packing Table ещё missing. Brief синхронизирован: Packing Table остаётся обязательным Utility Prop, но Codex использует labeled placeholder до появления approved asset.
- Food Mix и Food Bag пока существуют как combined composite; для gameplay transformation Codex должен использовать separate labeled semantic tokens.

## Принятые решения

Принято D-016 — Steam Vertical Slice: Codex implementation boundaries.

Принятое operational rule:

> Codex implements contracts and may use technical judgement for prototype implementation, debug tooling and neutral placeholders. Codex must not silently change gameplay contracts, visible physical steps, object taxonomy, visual direction, player-facing UI meaning, product scope or ethical boundaries.

Codex может самостоятельно:

- выбирать внутреннюю Godot-структуру реализации, scene/script split и data representation;
- делать deterministic prototype scheduler / state machine;
- добавлять dev-only debug overlay, state log, semantic labels и smoke commands;
- сжимать timings для debug / smoke / prototype review, если visible steps остаются читаемыми;
- использовать approved semantic placeholders и neutral labeled placeholders для missing assets;
- создавать Steam-local mirrors approved semantic assets с source mapping manifest;
- исправлять баги, где implementation расходится с written contracts.

Codex должен вернуть вопрос:

- Game Designer — если требуется изменить mechanics, task flow, resources, player actions, visible cause-and-effect, Dog Card meaning или acceptance criteria;
- Art Director — если требуется выбрать final visual style, palette, UI look, dog look, production asset style, изменить asset taxonomy или продолжать при readability problem, скрывающей gameplay meaning;
- Producer — если требуется изменить Vertical Slice scope, product feature, monetization, charity claim, Browser Extension dependency, cross-product behavior или принять shortcut, меняющий intended player experience;
- PM — если найден conflict документов или нужна synchronization.

## Открытые вопросы

- В самом RFC Producer synthesis записан, но из-за блокировки локального файлсервера на одном точечном edit статусная строка вверху файла могла остаться `accepted / docs update in progress`, хотя фактически D-016 и implementation brief уже обновлены.
- Следующий Codex task должен обновить `docs/repo/status/CODEX_STATUS.md` после реализации или при старте dev-серии.
- После первой playable implementation нужен playtest checklist / readability review.

## Ссылки / источники

Прочитаны и использованы:

- `PROJECTS_RULES.md`
- `AGENTS.md`
- `README.md`
- `docs/repo/status/CODEX_STATUS.md`
- `docs/drive/Shelter/00_START_HERE/04_COLLABORATION_PROTOCOL.md`
- `docs/drive/Shelter/00_START_HERE/02_DECISIONS.md`
- `docs/drive/Shelter/06_SESSIONS_AND_HANDOFFS/cross_role_sessions/2026-06-29__cross_role_rfc__codex_task_boundaries_steam_vertical_slice.md`
- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Codex_Implementation_Brief__Vertical_Slice_v1.md`
- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Vertical_Slice_Scope_Lock_v1.md`
- `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Semantic_Asset_Pack_v1/README.md`
- `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Semantic_Asset_Pack_v1/APPROVED_ASSET_IMPORT_MANIFEST_v1.md`

## Что обновлено в документах

Обновлено напрямую:

- `docs/drive/Shelter/06_SESSIONS_AND_HANDOFFS/cross_role_sessions/2026-06-29__cross_role_rfc__codex_task_boundaries_steam_vertical_slice.md` — добавлен Producer synthesis и Final decision / update.
- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Codex_Implementation_Brief__Vertical_Slice_v1.md` — синхронизирован с RFC, исправлен Packing Table asset status, добавлены implementation boundaries.
- `docs/drive/Shelter/00_START_HERE/02_DECISIONS.md` — добавлено D-016.
- `docs/drive/Shelter/00_START_HERE/01_CURRENT_STATUS.md` — добавлено D-016 и следующий dev/Codex шаг.
- этот handoff создан.

Не удалось выполнить из-за блокировки инструмента:

- финальный микро-edit статуса RFC с `accepted / docs update in progress` на `accepted / docs updated`. Смысловая часть RFC и D-016 уже записаны.

## Следующий лучший шаг

Передать Codex задачу реализации Steam Vertical Slice по:

`docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Codex_Implementation_Brief__Vertical_Slice_v1.md`

Обязательные условия для Codex:

- учесть D-016;
- не менять locked scope;
- использовать labeled placeholders для missing assets;
- сохранить visible cause-and-effect;
- создать/описать Steam-local asset mirror, если нужны `res://` paths;
- обновить `docs/repo/status/CODEX_STATUS.md` после реализации.
