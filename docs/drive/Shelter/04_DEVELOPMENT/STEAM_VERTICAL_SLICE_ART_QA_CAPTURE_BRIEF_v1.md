# STEAM_VERTICAL_SLICE_ART_QA_CAPTURE_BRIEF v1

Дата: 2026-06-29
Роль документа: Codex Capture Brief for Art Director QA
Статус: ready for Codex

Связано с:

- `docs/repo/status/CODEX_STATUS.md`
- `docs/repo/dev/steam-vertical-slice-prototype.md`
- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Vertical_Slice_Scope_Lock_v1.md`
- `docs/drive/Shelter/06_SESSIONS_AND_HANDOFFS/cross_role_sessions/2026-06-29__cross_role_rfc__codex_task_boundaries_steam_vertical_slice.md`

## 1. Цель

Подготовить capture pack для Art Director review текущего Steam Vertical Slice prototype.

Главная цель:

> Дать Art Director полный набор скриншотов и короткий screencast, чтобы оценить readability, visual hierarchy, placeholder acceptability, dog/action visibility, UI dominance and main-strip composition без повторного запуска через Codex.

Это не задача на изменение gameplay, art style или scope.

## 2. Output directory

Создать директорию:

```text
docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_VERTICAL_SLICE_ART_QA_CAPTURE_v1/
```

Внутри:

```text
captures/
README.md
CAPTURE_MANIFEST_v1.md
```

Если нужны поддиректории:

```text
captures/screenshots/
captures/video/
captures/logs/
```

## 3. Required captures

Нужны screenshots ключевых состояний Vertical Slice.

Минимальный набор:

1. `01_initial_strip.png` — стартовая сцена / нижняя полоса / все основные объекты.
2. `02_order_or_route_card.png` — Order Card или Route Card перед отправкой.
3. `03_dachshund_to_bicycle.png` — такса идёт / готовится к Basket Bicycle.
4. `04_bicycle_departure.png` — транспорт уезжает за край strip.
5. `05_trip_state.png` — спокойное состояние поездки у Road Sign.
6. `06_bicycle_return_payload.png` — транспорт возвращается с видимым грузом.
7. `07_unload_to_storage.png` — собаки выгружают cargo в Storage.
8. `08_storage_to_kitchen_carry.png` — перенос ингредиента из Storage в Kitchen.
9. `09_kitchen_work_or_food_mix.png` — Kitchen работает или Food Mix появился.
10. `10_food_mix_to_packing.png` — Food Mix переносится на Packing Table.
11. `11_packing_table_food_bag.png` — Packing Table / Food Bag state.
12. `12_food_bag_to_van.png` — Food Bag несут в Delivery Van Endpoint.
13. `13_van_ready_confirm_delivery.png` — Van готов, требуется player confirmation.
14. `14_postcard_reward.png` — Postcard + reward момент.
15. `15_dog_card_slippers.png` — Dog Card показывает innate trait и equipment отдельно.
16. `16_hide_ui_world_visible.png` — UI hidden, мир всё ещё виден/живёт.

Дополнительно желательно:

- `17_show_ui_restored.png` — UI снова показан.
- `18_debug_labels_on.png` — если есть режим semantic/debug labels.
- `19_debug_labels_off.png` — если можно скрыть labels.

## 4. Required video / screencast

Нужен короткий screencast полного цикла:

```text
captures/video/vertical_slice_full_loop_short.mp4
```

Если mp4 сложно получить в окружении Codex, допустим один из fallback вариантов:

- `.mov`;
- `.gif`;
- sequence of PNG frames with manifest;
- Godot-generated frame capture folder.

Важнее иметь reviewable visual sequence, чем конкретный формат.

## 5. Capture method

Предпочтительный порядок:

1. Если можно запустить visible macOS Godot and capture real screenshots/screen recording — сделать это.
2. Если real screen capture сложно/ненадёжно — добавить dev-only capture mode в Vertical Slice scene, который сохраняет viewport screenshots на ключевых событиях.
3. Если screenshot automation требует небольших code changes, они должны быть debug-only and documented.

Допустимые новые launcher modes:

```sh
cd steam
tools/dev-vertical-slice.sh capture
tools/dev-vertical-slice.sh capture-smoke
```

`capture-smoke` должен проверять, что capture path создаётся и хотя бы несколько expected PNG появляются.

## 6. Art Director review focus

Captures должны позволить проверить:

- main strip remains low and bottom-hugging;
- upper space remains empty / non-invasive;
- dogs remain visible and are not decorative dots;
- dog actions read before building decoration;
- Road Sign / Storage / Kitchen / Packing Table / Van are distinguishable;
- Utility Props do not turn into houses;
- resources physically exist in the world;
- Food Mix -> Food Bag transformation is visually understandable;
- UI cards do not dominate the strip;
- semantic/debug labels help prototype clarity but do not become final UI look;
- no guilt / urgency / red-alert emotional tone appears.

## 7. Manifest requirements

Create:

```text
CAPTURE_MANIFEST_v1.md
```

Include table:

| File | Moment | Why it matters | Notes / known issues |

Also include:

- command used to capture;
- Godot version if available;
- display/window mode if visible capture;
- whether labels were on/off;
- whether timings were normal or fast;
- missing captures if any;
- known visual limitations.

## 8. Docs update

Update:

- `docs/repo/status/CODEX_STATUS.md` with capture task block.
- `docs/repo/dev/steam-vertical-slice-prototype.md` with how to run capture mode if a mode is added.

Do not update product/art decisions. This is only a capture pack.

## 9. Acceptance criteria

Task is done if:

- capture output directory exists;
- screenshots for the required moments exist, or missing ones are explicitly documented;
- a short video/screencast or accepted fallback exists;
- manifest exists and maps files to review moments;
- commands used are documented;
- existing vertical slice smoke still passes;
- `steam/tools/check-godot.sh` passes if code changed;
- status docs updated.

## 10. Out of scope

Do not:

- change gameplay loop;
- change accepted Vertical Slice scope;
- change asset taxonomy;
- polish final art;
- replace placeholders unless required for capture labels/debug visibility;
- add new mechanics;
- create production art;
- make Art Director conclusions.

Codex should only produce captures and document what was captured.
