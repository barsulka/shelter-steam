# Exclusions and Non-Authority Boundaries

- Дата: `2026-07-13`
- Status: `PREPARED_FOR_PM_ACCEPTANCE`

Этот документ различает три вещи: hard-rejected visual reference,
noncanonical regression evidence и future scope. Наличие в exclusions не
меняет канонический статус всех файлов `approved_art_files/`.

## 1. HARD EXCLUDE — Sheet A

- Path:
  `/Users/barsulka/.codex/visualizations/2026/07/11/019f50cf-d2b5-7d62-b31f-abdf5e42f15c/shelter_world_room_rnd_2026-07-11/assembled/sheet_a_assembled_scene_master_4x1.png`
- SHA-256:
  `c0dd9f6aded7b06ba1fd4e551edda76315a5307c5ced02058a62d1fa689cbc42`
- Status: **USER_REJECTED_REFERENCE**
- Reuse: **ZERO**

Sheet A запрещено использовать:

- как visual target;
- как principle, palette, proportion, meadow, dog, building, fence или layout
  evidence;
- как supporting reference;
- как crop, fragment, paint-over base, source material или derivative input;
- как основание для Art/PM/Codex решения.

Это исключение включает hash, файл целиком и любые его части. Sheet A не
должен появиться в source prompts, side-by-side approval sheets или runtime.

## 2. Другие неканонические visual inputs

Следующее не может подменять entries `REFERENCE_MANIFEST.json`:

- Sheet B и любые `PREVIEW_RESEARCH_ONLY` sheets/captures;
- rejected SVG previews или недоступные sandbox-only attempts;
- flattened AI output как layered/editable master;
- stale prototype captures без явного user-owner canonical status;
- любой внешний mood/reference, отсутствующий в manifest;
- автоматически собранный collage, если его отдельные sources/status не
  зафиксированы.

Если такой input нужен для production, работа останавливается и требует
отдельного Art/PM status decision; он не повышается молча.

## 3. Current v5 — visual target исключён, regression evidence сохранён

Current v5 overall look остаётся
**CHANGES_REQUIRED / USER_OWNER_REJECTED_CURRENT_LOOK**. Исключены из
канонического visual target:

- geometric Labrador morphology/material;
- текущая длинная banded platform/world composition;
- semantic Kitchen/Storage/Van visual placeholders;
- code-drawn rectangular Packing appearance;
- текущие building placement, density и focal hierarchy;
- claim `prototype look resolved`, overall runtime Art PASS и user acceptance.

Не исключены из regression suite:

- A–G;
- normal-speed start/walk/stop;
- both facing и physical turn;
- no-crop/root/baseline truth;
- Kitchen/Packing contact;
- selector-scoped Packing mask;
- cancellation/recovery;
- legacy negatives;
- zero transfer acceptance.

## 4. Current source package — maturity boundary

Текущий `STEAM_DESKTOP__Playable_World_Labrador_Source_Package_v1` остаётся
исторически SOURCE-READY в своём bounded technical scope. Это не делает его
geometric Labrador/world каноническим visual source после user-owner rejection.

Разрешено переносить в новую source постановку только явно проверенные
технические знания: layer taxonomy, pivots/baselines, physical-turn requirement,
contact planes, z/occlusion semantics и QA methodology. Rejected morphology,
world composition и placeholder visual forms не являются fidelity target.

Встроенный в source package flattened AI Labrador reference также не является
layered master и не заменяет user-owner three-view `5cfffc7…`.

## 5. Current scope exclusions

### Dachshund with cart

Approved Dachshund Cart PNG и Dachshund в approved `image.png` остаются
каноническими references качества, breed specificity, масштаба и языка живой
сцены. Но в current literal roster/behavior wave исключены:

- Dachshund actor;
- cart actor/vehicle;
- pull/ride choreography;
- transfer, resource attachment или delivery mechanic.

### Future dog-life catalogue

Явно later и вне текущей source/runtime acceptance:

- dog pulls or rides with cart;
- dog rides bicycle;
- dog drives small truck;
- dog sits in bed of large truck;
- dog sits at school desk;
- dog reads in library;
- dog mixes chemicals in lab;
- dog teaches at blackboard with pointer;
- dog relaxes in rocking chair with book;
- dog sleeps;
- dog plays with another dog;
- dog chases its tail;
- all other expanded dog-life states.

Эти пункты не создают current selectors, animation slots, rooms, vehicles,
tasks, resources, transfer, progression или acceptance cells.

## 6. Explicit inclusions, чтобы exclusion нельзя было прочитать шире

- D-011 full scene, включая meadow и faint lower trees, — canonical target.
- Весь `approved_art_files/` — canonical visual library.
- Approved Mill разрешён буквально в current scene **только как статичный
  декоративный Utility Prop** без interaction/station/task/resource/output/
  progression/input authority.
- Labrador — первая и единственная current living dog; требуется спокойное
  back-and-forth чтение после bounded Game Design selector/guardrails.
- User three-view Labrador `5cfffc7…` и approved Watering `b7f116…` — совместный
  identity target.

Главная граница: сейчас восстанавливаются базовая графика и уже заложенные
mechanics; расширение начинается только отдельной будущей волной.
