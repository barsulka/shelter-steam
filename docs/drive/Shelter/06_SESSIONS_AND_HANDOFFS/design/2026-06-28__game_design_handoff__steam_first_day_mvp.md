# 2026-06-28 — Game Design Handoff — Steam First Day MVP

## Дата

2026-06-28

## Роль сессии

Game Designer / Systems Designer для Steam/Desktop ветки Shelter.

## Что делали

Восстановлен контекст по локальным документам проекта и продолжена Steam/Desktop геймдизайн-работа после перегрева предыдущего контекста.

Прочитаны доступные документы:

- `PROJECTS_RULES.md`
- `AGENTS.md`
- `README.md`
- `docs/repo/status/CODEX_STATUS.md`
- `docs/drive/Shelter/00_START_HERE/000_ROLE_GAME_DESIGNER.md`
- `steam/README.md`
- `docs/drive/Shelter/00_START_HERE/00_PROJECT_INDEX.md`
- `docs/drive/Shelter/00_START_HERE/01_CURRENT_STATUS.md`
- `docs/drive/Shelter/00_START_HERE/02_DECISIONS.md`
- `docs/drive/Shelter/00_START_HERE/03_OPEN_QUESTIONS.md`
- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Game_Designer_Session_Brief.md`
- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__MVP_Gameplay_Slice_v0.md`
- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__MVP_State_Machine_and_UX_Flow_v0.md`
- `docs/repo/dev/companion-field-tech-demo.md`

Не удалось прочитать в той сессии:

- `steam/AGENTS.md` — вызов был заблокирован системой безопасности инструмента.
- design handoff-файлы от 2026-06-25 — вызовы были заблокированы системой безопасности инструмента.

## Ключевые выводы

1. Steam/Desktop уже имеет принятый direction: горизонтальный собачий производственный кооператив в always-on-top strip.
2. D-012/D-013 важны для MVP: Steam не показывает crop farming как ядро, а использует off-screen поездки собак за ресурсами; связь с Browser Extension на MVP narrative-only.
3. Уже есть сильный 10-минутный MVP slice и state machine, но не хватало следующего слоя: что игрок делает после первой поставки и что именно отдавать разработке.
4. Текущая dev-база уже имеет companion field demo; следующий шаг должен быть не очередным window spike, а semantic gameplay loop поверх существующей полоски.

## Принятые решения в этой сессии

Новых project-level decisions не принималось. Сессия развивает уже принятые D-009, D-010, D-012, D-013.

На уровне working draft предложено:

- First Day MVP строится вокруг 3 поставок, 3 маршрутов, 3 собак, 2 транспортов, первого bottleneck и room-lite reward.
- Следующий dev-spike должен начинаться с first-order loop, а не сразу со всего первого дня.

## Что обновлено в документах

Созданы новые документы:

1. `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__First_Day_MVP_v0.md`
2. `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Prototype_Data_and_Task_Backlog_v0.md`
3. `docs/drive/Shelter/06_SESSIONS_AND_HANDOFFS/design/2026-06-28__game_design_handoff__steam_first_day_mvp.md`

Попытка обновить `docs/repo/product/steam_desktop_context.md` была заблокирована инструментом записи. Файл, вероятно, всё ещё требует ручной синхронизации с D-012/D-013 и новыми MVP-документами.

## Открытые вопросы

1. Третья собака First Day MVP: корги или mixed-breed helper?
2. Второй маршрут: `Льняные поля` как системный route или `Цветочная ферма` как более эмоциональный route?
3. Когда выдавать транспортное улучшение: после первой или второй поставки?
4. Когда выдавать room-lite reward: после второй или третьей поставки?
5. Нужна ли отдельная `Decor Workshop` в First Day MVP, или Packing Table временно покрывает уютные наборы?
6. Какой минимум текста нужен для shared-world связи с Browser Farm без ощущения зависимости от Browser Extension?

## Следующий лучший шаг

Для Codex/dev:

Build Steam/Desktop MVP first-order loop in the existing Godot companion strip: semantic objects, route card, dog trip, visible return payload, physical unload into storage, carry to kitchen, cook, pack, load van, send delivery, show postcard, assign comfortable slippers.

Для Game Design:

Перед стартом full First Day MVP решить только два малых вопроса: третья собака и порядок unlock-наград. Остальное уже можно прототипировать.
