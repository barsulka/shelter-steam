# STEAM_DESKTOP — Game Design Roadmap v1

Дата: 2026-06-29
Роль документа: Game Design Roadmap / Working Plan
Статус: redirected to systems branch
Продукт: Steam/Desktop idle always-on-top strip
Роль-владелец: Game Designer / Systems Designer

## 0. Назначение

Документ фиксирует порядок ближайших задач Game Designer для Steam/Desktop ветки Shelter.

Этот roadmap остаётся историческим и рабочим индексом первой Vertical Slice ветки. После Producer decision от 2026-06-29 critical path Game Designer переведён в отдельный systems roadmap:

`STEAM_DESKTOP__Game_Systems_Roadmap_v1.md`

## 1. Roadmap не является библией

Этот roadmap — рабочий план, а не неизменная библия проекта.

Roadmap может смещаться: задачи можно переносить, разделять, объединять, уточнять или убирать только с явным обоснованием.

Текущее обоснование смещения:

- Vertical Slice доказал gameplay proof на уровне locked loop, resource flow, task chain, player agency and D-010 separation.
- Visual proof / readability / placeholder quality / dog silhouettes / strip composition остаются открытыми, но относятся к Art Director critical path.
- Producer решил не блокировать Game Designer systems work ожиданием финального visual acceptance.

## 2. Текущее состояние

Steam/Desktop направление принято: горизонтальный собачий производственный кооператив в always-on-top strip, то есть cozy idle production strip + dog community sim.

Ключевые рамки:

- Steam/Desktop — не Browser Extension.
- Steam/Desktop — не классическая видимая ферма с crop farming.
- Ресурсы приезжают через off-screen поездки собак.
- Игрок задаёт намерение, собаки делают физическую работу.
- Собаки — персонажи, а не worker units и не набор оптимизируемых статов.
- Благотворительность спокойная, добровольная и без guilt pressure.

Vertical Slice status:

- Scope Lock создан.
- Playtest Checklist создан.
- Codex implementation выполнен.
- Capture pack v1/v2 создан.
- Capture-based playtest review завершён.
- Gameplay proof считается достаточным для перехода Game Designer к systems design.
- Final visual/readability acceptance передана Art Director и не блокирует Game Designer critical path.

## 3. Roadmap задач

### R-00 — Зафиксировать roadmap в документах

Статус: done.

Результат: `STEAM_DESKTOP__Game_Design_Roadmap_v1.md`.

### R-01 — Vertical Slice Scope Lock v1

Статус: done.

Результат: `STEAM_DESKTOP__Vertical_Slice_Scope_Lock_v1.md`.

### R-02 — Vertical Slice Playtest Checklist v1

Статус: done.

Результат: `STEAM_DESKTOP__Vertical_Slice_Playtest_Checklist_v1.md`.

### R-03 — Сопровождение Codex implementation

Статус: done / no longer active critical path.

Результат:

- `STEAM_DESKTOP__Codex_Implementation_Brief__Vertical_Slice_v1.md`
- `D-016 — Steam Vertical Slice: Codex implementation boundaries`
- `docs/repo/status/CODEX_STATUS.md` entries for Vertical Slice prototype and Art QA capture/fix passes.

### R-04 — Vertical Slice Playtest Report v1

Статус: capture-based review complete; final visual/live-feel review transferred to Art Director.

Результат:

`STEAM_DESKTOP__Vertical_Slice_Playtest_Report_v1.md`

Producer interpretation:

- Gameplay proof: sufficient for next Game Designer step.
- Visual proof: still open, Art Director-owned.

### R-05 — First Day MVP small decisions

Статус: deferred into systems roadmap.

Решение: эти вопросы лучше не решать изолированно. Они должны выйти из Dog Progression Model, Activity Catalog, Building System, Production Chains and Long-term Progression.

### R-06 — First Day MVP Contract v1

Статус: deferred.

Будет выполняться после первых systems documents.

### R-07 — Dog Traits and Roles v1

Статус: moved to systems roadmap.

Новый путь:

`STEAM_DESKTOP__Game_Systems_Roadmap_v1.md`, GS-01 / GS-02.

### R-08 — Early Balance Requirements v0

Статус: moved to systems roadmap.

Новый путь:

`STEAM_DESKTOP__Game_Systems_Roadmap_v1.md`, GS-09.

## 4. Новый текущий порядок выполнения

Game Designer больше не ждёт финальный visual pass Vertical Slice.

Новый active roadmap:

`STEAM_DESKTOP__Game_Systems_Roadmap_v1.md`

Текущий первый шаг:

1. `GS-01 — Dog Progression Model v1`.
2. Затем `GS-02 — Dog Traits / Abilities / Equipment Taxonomy v1`.
3. Затем `GS-03 — Activity Catalog v1`.

Art Director параллельно ведёт visual acceptance/readability of Vertical Slice.

## 5. Changelog

### 2026-06-29 — systems pivot accepted

- Producer accepted Game Designer proposal to split gameplay proof and visual proof.
- Visual acceptance/readability of Vertical Slice moved out of Game Designer critical path.
- Art Director owns visual proof, readability, dog silhouettes, placeholder quality and strip composition.
- Game Designer critical path moved to `STEAM_DESKTOP__Game_Systems_Roadmap_v1.md`.
- Systems Simulator opened as a Codex brief in `04_DEVELOPMENT`.

### 2026-06-29 — R-01 / R-02 completed

- Создан `STEAM_DESKTOP__Vertical_Slice_Scope_Lock_v1.md`.
- Создан `STEAM_DESKTOP__Vertical_Slice_Playtest_Checklist_v1.md`.
- Roadmap обновлён: R-00, R-01 и R-02 считаются выполненными.

### 2026-06-29 — v1 created

- Создан первый Game Design Roadmap для Steam/Desktop.
- Зафиксировано, что roadmap не является библией.
- Ближайший порядок задач был установлен: Scope Lock -> Playtest Checklist -> Codex support -> Playtest Report -> First Day decisions.
