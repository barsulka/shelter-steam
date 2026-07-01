# STEAM_DESKTOP — Codex Brief — Reliability, Performance & Modernization Refactor v1

Дата: 2026-07-01
Статус: draft for Codex
Роль-владелец постановки: Codex / Producer
Рекомендуемый уровень рассуждений: высокий

---

## 0. Цель задачи

Привести текущий Steam/Desktop Godot-проект в состояние, пригодное для долгосрочной работы: устранить архитектурные проблемы, снизить нагрузку на CPU/GPU при long-running сессиях, сделать код поддерживаемым и протестированным на обеих целевых платформах.

Это **не** про новые механики, не про player-facing контент и не про визуальный polish.

Это про:

- надёжность (reliability);
- оптимизацию ресурсов (CPU/GPU/memory);
- современные Godot-паттерны вместо устаревших;
- кросс-платформенную готовность;
- поддерживаемость кодовой базы.

---

## 1. Обязательные источники

Codex обязан прочитать перед началом:

- `PROJECTS_RULES.md`
- `AGENTS.md`
- `steam/AGENTS.md`
- `steam/README.md`
- `docs/repo/status/CODEX_STATUS.md`
- `docs/repo/adr/0001-use-godot-for-steam-desktop.md`
- `docs/repo/adr/0002-game-state-as-source-of-truth.md`
- `steam/.agents/skills/godot-gdscript-patterns/SKILL.md`
- `steam/.agents/skills/godot-gdscript-patterns/references/details.md`
- `steam/.agents/skills/godot-gdscript-patterns/references/advanced-patterns.md`
- все `.gd` файлы в `steam/scripts/`

---

## 2. Scope

Рефактор делится на 7 независимых подзадач. Каждая подзадача — отдельный коммит/ветка. Порядок выполнения: строго последовательный, от наименее рискованной к наиболее архитектурной.

---

### Подзадача 1: Оптимизация draw-call цикла

**Цель**: убрать лишнюю перерисовку, когда ничего не изменилось.

**Файл**: `steam/scripts/prototypes/vertical_slice/vertical_slice_demo.gd`

**Проблемы**:
- `_on_tick()` вызывает `queue_redraw()` каждый тик (20 раз/сек) безусловно.
- `_draw()` перерисовывает всё: землю, маршруты, якоря, транспорт, lane'и, ресурсы, лейблы — даже когда ни одна позиция не изменилась.
- `_apply_mouse_passthrough()` вызывается каждый тик и строит polygon из интервалов — дорого и бессмысленно, если UI не двигался.

**Что сделать**:
- Добавить флаг `_dirty: bool = false` и вызывать `queue_redraw()` только когда `_dirty == true`.
- Ставить `_dirty = true` при реальных изменениях: движение собак, смена состояния, изменение зума, resize, переключение UI.
- Вынести `_apply_mouse_passthrough()` из тика — вызывать только при resize, zoom, toggle UI.
- Добавить аналогичный флаг для `_update_ui()` — не обновлять лейблы, если ничего не изменилось.

**Acceptance criteria**:
- При idle-состоянии (собаки стоят, таймер тикает) CPU load на `_draw()` снижается.
- `queue_redraw()` вызывается только при реальном изменении визуального состояния.
- Все существующие smoke-тесты проходят.
- Видимое поведение игры не меняется.

**Stop conditions**:
- Если флаг `_dirty` начинает вызываться чаще 60 раз/сек — вернуть безусловный `queue_redraw()`.
- Не трогать логику задач — только отрисовку и UI-обновления.

---

### Подзадача 2: Оптимизация загрузки текстур

**Цель**: убрать ручной парсинг PNG через `FileAccess.get_file_as_bytes()`.

**Файл**: `steam/scripts/prototypes/vertical_slice/vertical_slice_demo.gd`

**Проблемы**:
- `_load_png_texture()` читает байты, парсит PNG вручную через `Image.load_png_from_buffer()`, создаёт `ImageTexture.create_from_image()`. Это дублирует то, что Godot делает сам через `ResourceLoader`.
- Нет fallback-цепочки: если ручной парсинг падает — `ResourceLoader.load()` используется как запасной вариант, но без кэширования.

**Что сделать**:
- Заменить `_load_png_texture()` на прямой `load(path)` или `ResourceLoader.load(path, "Texture2D")`.
- Убедиться, что текстуры кэшируются движком (по умолчанию Godot кэширует `load()`).
- Убрать дублирующий ручной парсинг.

**Acceptance criteria**:
- Все текстуры загружаются через штатный `ResourceLoader`.
- Файл `_load_png_texture()` удалён или заменён на одну строку `load()`.
- Smoke-тесты проходят.

---

### Подзадача 3: Оптимизация видео-захвата (память)

**Цель**: убрать хранение PNG-фреймов в RAM.

**Файлы**:
- `steam/scripts/prototypes/vertical_slice/vertical_slice_demo.gd`

**Проблемы**:
- `_control_capture_files` хранит `PackedByteArray` для каждого фрейма в памяти.
- 20 фреймов по ~300KB = ~6MB. При увеличении разрешения или длительности — проблема.
- `_clear_control_video_capture_memory()` чистит байты, но до этого они все лежали в Dictionary.

**Что сделать**:
- Записывать фреймы на диск сразу (в `_control_capture_root()`).
- Хранить в `_control_capture_files` только метаданные (file_id, content_type, путь), а не байты.
- Отдавать файлы по запросу через `FileAccess.get_file_as_bytes()` в `_send_control_capture_file()`.
- Очищать старые фреймы при завершении захвата или при начале нового.

**Acceptance criteria**:
- `_control_capture_files` не содержит `PackedByteArray` — только метаданные.
- Capture-файлы отдаются через HTTP корректно.
- Потребление памяти при видеозахвате снижается пропорционально количеству фреймов.
- `connector-control-smoke` проходит.

---

### Подзадача 4: Валидация импорта в game_systems_runtime

**Цель**: добавить проверку обязательных полей при импорте.

**Файл**: `steam/scripts/game_systems/game_systems_runtime.gd`

**Проблемы**:
- `import_runtime_metadata()` и `normalize_import_payload()` не проверяют обязательные поля.
- Если приходит кривой JSON без `runtime`, `state`, `schema_version` — runtime молча примет неполные данные.
- `_activity_experience_for_dog()` и `_events_by_tags()` вызывают `event_snapshots(500)` на каждый вызов — это O(n) проход по всем событиям, и вызывается многократно за один `build_state()`.

**Что сделать**:
- Добавить валидацию обязательных полей в `normalize_import_payload()`: `state` обязателен, `runtime` опционален.
- Кэшировать результат `event_snapshots()` на время одного `build_state()` вызова, чтобы не делать повторных проходов.
- Добавить guard в `_safe_fixture_file_name()` — возвращать пустую строку при пустом `raw_name` (уже есть, но проверить edge cases).

**Acceptance criteria**:
- Импорт кривого JSON возвращает ошибку с конкретным описанием недостающего поля.
- `build_state()` не вызывает `event_snapshots()` mehrmals.
- Все существующие smoke-тесты проходят.

---

### Подзадача 5: Экспорт-профили для Windows и macOS

**Цель**: добавить рабочие export presets.

**Файлы**:
- `steam/export_presets.cfg` (новый)

**Проблемы**:
- Нет export-профилей для Windows и macOS.
- Каждый CODEX_STATUS запись заканчивается "Windows behavior remains untested."
- Без export-профиля невозможно автоматизировать сборку.

**Что сделать**:
- Создать `export_presets.cfg` с двумя профилями:
  - Windows Desktop (x86_64, .exe)
  - macOS (universal, .app)
- Настроить macOS-подпись: `codesign` с ad-hoc (для dev), а не production identity.
- Добавить в `project.godot` секцию `[export]` с 기본ными настройками.
- Настроить VSync и rendering в `project.godot` (а не только в коде).

**Acceptance criteria**:
- `export_presets.cfg` существует и Godot его видит.
- `--headless --export-release "Windows Desktop"` создаёт .exe без ошибок.
- `--headless --export-release "macOS"` создаёт .app без ошибок.
- VSync настроен в `project.godot`.

**Stop conditions**:
- Если export падает из-за отсутствия export templates — зафиксировать и остановиться, не чинить templates.
- Не настраивать кодирование/подпись для production — только ad-hoc для dev.

---

### Подзадача 6: Таймеры вместо Timer-нод

**Цель**: заменить ручное создание Timer-нод на более современные паттерны.

**Файлы**:
- `steam/scripts/prototypes/vertical_slice/vertical_slice_demo.gd`
- `steam/scripts/tech_demos/companion_field_demo.gd`

**Проблемы**:
- `_start_timers()` создаёт Timer-ноды вручную и добавляет их как children.
- Это рабочий, но устаревший подход. Godot 4 имеет更好的 `_process()` с собственным throttling.
- Timer-ноды занимают место в дереве сцен и добавляют overhead.

**Что сделать**:
- Заменить `_start_timers()` + `_on_tick()` на `_process(delta)` с собственным `_tick_accumulator`.
- Оставить `_start_performance_hud()` отдельно (performance-таймер может остаться как Timer для ясности).
- Не трогать `_start_auto_quit_timeout()` — `await` таймер для auto-quit адекватен.
- Проверить, что `companion_field_demo.gd` использует аналогичный подход.

**Acceptance criteria**:
- Вместо Timer-нод для игрового тика используется `_process()` с accumulator.
- Интервал тика (0.05с) сохраняется.
- Все smoke-тесты проходят.
- Количество нод в дереве снижается на 1-2 (убранные Timer-ноды).

---

### Подзадача 7: Архитектурное разделение vertical_slice_demo.gd

**Цель**: разбить монолит на логические модули.

**Файлы**:
- `steam/scripts/prototypes/vertical_slice/vertical_slice_demo.gd` — остаётся как orchestrator
- `steam/scripts/prototypes/vertical_slice/game_world.gd` (новый) — логика: задачи, ресурсы, собаки, инвентарь
- `steam/scripts/prototypes/vertical_slice/game_renderer.gd` (новый) — отрисовка: `_draw()` методы
- `steam/scripts/prototypes/vertical_slice/game_ui.gd` (новый) — UI: карты, кнопки, лейблы, layout
- `steam/scripts/prototypes/vertical_slice/capture_system.gd` (новый) — захват: screenshot, video, smoke

**Проблемы**:
- 2770 строк в одном файле.
- Отрисовка, логика, UI, capture, connector — всё в одном классе.
- Сложно тестировать, сложно понимать, сложно менять.

**Что сделать**:
1. **game_world.gd** — вынести:
   - `_dogs`, `_tokens`, `_storage_inventory`, `_kitchen_inputs`, `_packing_inputs`
   - `_task_queue`, `_current_task`, `_current_step_index`, `_step_time`
   - `_route_started`, `_trip_payload_visible`, все `_*_enqueued` флаги
   - `_transport_x`, `_transport_state`, `_delivery_state`, `_order_state`
   - Методы: `_reset_world_state()`, `_create_*_task()`, `_advance_current_task()`, `_handle_task_completed()`, `_create_resource_token()`, `_pickup_resource_for_task()`, `_place_resource_for_task()`, `_increment_inventory()`, `_decrement_inventory()`
   - Сигналы: `state_changed`, `task_completed`, `delivery_complete`

2. **game_renderer.gd** — вынести:
   - Все методы `_draw_*()` (~15 штук)
   - `_resource_token_size()`, `_resource_*_offset()`, `_dog_action_color()`, `_dog_action_label()`
   - `_anchor_x()`, `_resolve_world_x()`, `_world_to_screen_x()`, `_viewport_size()`, `_zoom()`

3. **game_ui.gd** — вынести:
   - `_build_ui()`, `_layout_ui()`, `_update_ui()`, `_make_panel()`, `_make_label()`, `_make_button()`
   - `_order_state_text()`, `_next_action_text()`, `_dachshund_equipment_text()`, `_debug_text()`
   - Все `_order_card`, `_route_card`, `_dog_card` и т.д.

4. **capture_system.gd** — вынести:
   - `_prepare_capture_directories()`, `_begin_capture_initial_sequence()`, `_schedule_capture()`, `_process_next_capture()`
   - `_save_control_viewport_png()`, `_capture_state_connector_screenshot()`, `_start_state_connector_video_capture()`
   - `_write_capture_log()`

5. **vertical_slice_demo.gd** — остаётся как orchestrator:
   - `_ready()`, `_read_user_args()`, `_apply_window_settings()`, `_start_timers()`
   - Координация: game_world → renderer, game_world → UI, game_world → capture
   - Обработка input
   - State connector setup

**Acceptance criteria**:
- `vertical_slice_demo.gd` сокращается до ~400-600 строк.
- Каждый новый модуль — отдельный файл с清晰的 responsibilities.
- Все существующие smoke-тесты проходят.
- Видимое поведение игры не меняется.
- `class_name` сохранены для Godot-серийализации.

**Stop conditions**:
- Не менять формат .tscn-файлов — все новые скрипты attachаются к существующим нодам.
- Не менять логику задач — только перенос.
- Если при разделении ломается Godot-сериализация (UID, signal connections) — откатить и сделать менее агрессивное разделение.

---

## 3. Out of scope

- Новые игровые механики, ресурсы, собаки или здания.
- Визуальный polish или art assets.
- Steam-интеграция (Steamworks,成就, leaderboards).
- Browser Extension логика.
- Mobile-версия.
- Финальная production save format.
- Unit tests (pytest/gdunit) — можно добавить, если потребуется для валидации, но не в brief.

---

## 4. Порядок выполнения

1. Подзадача 1: draw-call оптимизация
2. Подзадача 2: оптимизация текстур
3. Подзадача 3: видео-захват (память)
4. Подзадача 4: валидация импорта
5. Подзадача 5: export-профили
6. Подзадача 6: таймеры → _process()
7. Подзадача 7: архитектурное разделение

Каждая подзадача — отдельный коммит. После каждой подзадачи:
- `bash -n steam/launch.sh` и `bash -n steam/tools/dev-vertical-slice.sh`
- `cd steam && tools/check-godot.sh`
- `cd steam && tools/dev-vertical-slice.sh smoke`
- При возможности: `cd steam && tools/dev-vertical-slice.sh connector-smoke`

---

## 5. Приёмка всего брифа

- Все 7 подзадач выполнены.
- Все smoke-тесты проходят.
- `CODEX_STATUS.md` обновлена с описанием всех изменений.
- Windows export проверен (если доступна Windows-машина).
- Потребление CPU при idle-состоянии снижено (измерить через Performance монитор).
- Количество строк в `vertical_slice_demo.gd` снижено до <600.

---

## 6. Risk

- **Подзадача 7 — самая рискованная**: разделение 2770-строчного файла может сломать Godot signal connections, UID-ссылки, или .tscn-сериализацию. Выполнять осторожно, с проверкой после каждого шага.
- **Подзадача 5 — может не работать без export templates**: если Godot не установлен с templates, export падает. Это не баг brief'а — зафиксировать и двигаться дальше.
- **Подзадача 1 — может пропустить edge case**: если `_dirty` флаг не ставится в какой-то редкой ситуации, UI не обновится. Тестировать визуально.
