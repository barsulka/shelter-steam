# STEAM_DESKTOP — Playable World + Labrador Source Package v1

Дата: 2026-07-13

Milestone: `R48-05A-S`

Вердикт: **SOURCE-READY — только source-level**

Владелец волны: delegated Art Director + Visual Production owner

`SOURCE-READY` здесь не является runtime Art PASS, не разрешает импорт в Godot и не делает следующий Codex brief executable автоматически.

## 1. Bounded-контракт

Пакет закрывает ровно разрешённый source-only scope:

- authored world semantic source set без decor atlas, room art и building replacement;
- layered editable side-view source для `dog.labrador_intro` в right/left facing и отдельный physical-turn midpoint;
- технические anchor/contact/clearance source planes для `object.kitchen` и `object.packing_table`;
- provenance, SHA-256, воспроизводимые lossless RGBA exports и source-level evidence 216/144/96;
- точные 12 строк принятого Labrador P0 manifest.

Пакет не содержит pickup / attach / carry / place / detach, новых mechanics/tasks/resources/stations/roles/rewards, runtime binding, Godot import, bicycle choreography или глобального style/palette lock.

## 2. Структура пакета

| Зона | Авторитетный источник | Экспорт / evidence | Контракт |
| --- | --- | --- | --- |
| World | `source/world/world_master.svg` + 15 named layer SVG | `exports/world/`, `evidence/world/` | `manifests/world_source_manifest.json` |
| Labrador | `source/labrador/{right,left,turn_mid}/` | `exports/labrador/`, `evidence/labrador/` | `manifests/labrador_source_manifest.json` |
| Kitchen anchors | `source/stations/kitchen/kitchen_anchor_plane.svg` | `exports/stations/kitchen/`, `evidence/stations/` | `manifests/station_anchors.json` |
| Packing Table anchors | `source/stations/packing_table/packing_table_anchor_plane.svg` | `exports/stations/packing_table/`, `evidence/stations/` | `manifests/station_anchors.json` |
| Accepted action scope | `manifests/accepted_action_scope.json` | validator input: `manifests/source_preflight_manifest.json` | ровно 12 accepted rows |
| Provenance / hashes | `PROVENANCE.json` | `HASHES.sha256` | tool/version/date/AI/source/export SHA-256 |
| QA | `ART_QA.md` | `QA_REPORT.json` | Art judgement + 39 automated checks |

SVG masters используют named Inkscape-compatible groups. Каждый semantic layer также имеет отдельный SVG и соответствующий lossless RGBA PNG. Bitmap reference никогда не является layered master.

## 3. World semantic source set

В master входят ровно:

- `world.ground.base`, `world.ground.grass_mass`, `world.ground.dirt_worn`, `world.ground.sand_soft`;
- `world.path.main`, один используемый `world.path.used_taper_end`;
- `world.transition.grass_dirt`, `world.transition.grass_sand`, `world.transition.ground_path`;
- `world.fence.back_span`, `world.fence.front_span`, `world.fence.post_end_open_gap`;
- `world.yard.bicycle_pad`, `world.anchor.bicycle_parking`, `world.shadow.local_prop`.

Canvas: `1536×216`, baseline `y=211`. Fence corner помечен `OMITTED_NOT_USED`; parking anchor неинтерактивен. Bicycle mechanics/choreography отсутствуют.

## 4. Labrador source contract

Actor: `dog.labrador_intro`. Canvas: `512×320`; actor root `[256,280]`; ground baseline `y=280`.

Текущий bounded envelope для side-facing source:

- identity alpha без local shadow: `461×225`;
- torso alpha: `302×147`;
- head alpha width: `127`;
- muzzle contact pivot reach: `207 px`; muzzle alpha reach: `217 px`;
- tail alpha reach: `244 px`;
- paw-pivot span: `235 px`;
- local shadow заканчивается на `15 px` ниже actor root.

Точные alpha bounds, pivots, correction limits и z-order находятся в `manifests/labrador_source_manifest.json`.

Facing policy: `authored_both`. Right и left имеют самостоятельные positive-coordinate SVG masters и facing-specific near/far anatomy/z-order. Negative scale не используется и не разрешён. Physical turn представлен отдельным `turn_mid` master; он не подменён mirror/flip.

Identity, optional chest-fur detail, blink swap, collar/equipment и local shadow разделены по контрактным слоям. Collar не baked в innate identity.

## 5. Station anchor records

Для Kitchen/CookTask и Packing Table/PackTask записаны:

- approach, contact-align body root, work, exit;
- allowed facing from left/right и обязательный physical turn до approach при смене направления;
- head/paw work plane, baseline, directional current-Labrador alpha clearance;
- station/dog shadow ownership и узкая front-lip occlusion ownership;
- entry/work/exit/cancel phase rules.

Эти SVG — **технические anchor/clearance art sources**, а не replacement station art. Kitchen использует approved temporary semantic placeholder только как reference. У Packing Table нет approved visual source; этот факт сохранён как warning и не скрыт технической геометрией.

## 6. Provenance и AI declaration

Built-in image generation использовалась один раз только как flattened reference для shape exploration:

- `references/ai/labrador_three_pose_reference__flattened_ai.png`;
- prompt/declaration: `references/ai/PROMPT.md`;
- SHA-256: `443ac9faff1dd4a0e6acff4a097cf65a41cf4cfd64c6580a4ea0041c63485307`.

Ни один AI-generated pixel не встроен в master или export. Masters независимо собраны детерминированным SVG/RGBA builder. Полные input-reference роли и SHA-256, toolchain (`Python 3.12.13`, `Pillow 12.2.0`), export policy и 211 artifact hashes записаны в `PROVENANCE.json`; полный hash readback всего пакета — в `HASHES.sha256`.

Ключевые master SHA-256:

| Master | SHA-256 |
| --- | --- |
| World | `a25385b8ea70ae47879811d01588879ddfda6ffd62392eb58f576a26d610e154` |
| Labrador right | `fc1888a4fcc38f06e54d6680d248e7f89787fdbd86676a27407a8b4204884a5f` |
| Labrador left | `19eb44e512026a41b2a4eb5ab7b18c64fc72cf0abebd833279bd95a51f7a6f06` |
| Labrador physical-turn midpoint | `fbef07ef5a3410d58445181eb8c2cbef6f453cdbf40e510faeb7efa56201be8a` |
| Kitchen anchor plane | `91c3984758a6374a0b87bc523fa7a65b6b8590fd2335fa695447624552bb1cf0` |
| Packing Table anchor plane | `304843ecce213f86215bf8d52765c9a8e4ed69144e31d02d598f011e9036f85c` |

## 7. Воспроизводимость и проверки

Из корня package:

```text
python3 tools/build_source_package.py
python3 tools/verify_source_package.py --write
python3 tools/verify_source_package.py
```

Builder воспроизводит named SVG layers, RGBA exports, manifests и evidence. Verifier проверяет точный action scope, alpha/bounds, canvas, baseline/pivots, positive-coordinate facing, near/far z-order, physical-turn master, 216/144/96 alpha heights, station clearance, provenance и SHA-256 readback.

`evidence/labrador/labrador_pipeline_qa_sheet.png` дополнительно собран официальным source-pipeline renderer с alpha/pivot overlays; renderer сообщил PASS для механической композиции и `visual_approval=NOT_EVALUATED`. Собственный Art readback находится в `ART_QA.md`.

## 8. Deliverables / signer table

| Package | Source status | Art verdict | Technical readback |
| --- | --- | --- | --- |
| World bounded set | authored, layered, hashed | SOURCE-READY | pending next owner |
| Labrador layered master | authored both facing + turn midpoint, layered, hashed | SOURCE-READY | pending native runtime integration |
| Packing Table anchor source | authored technical anchor/clearance only | SOURCE-READY WITH EXTERNAL VISUAL GATE | pending; station visual remains NEEDED |
| Kitchen anchor source | authored technical anchor/clearance only | SOURCE-READY | pending; placeholder remains temporary |

## 9. Нерешённые внешние gates и следующий owner

- Approved Packing Table visual source всё ещё `NEEDED`; anchor plane не подменяет его.
- Kitchen semantic placeholder остаётся temporary и не становится final building art.
- Production rig/pipeline selection, clip binding, motion timing, state-machine behavior, native Godot capture и runtime Art PASS не выполнялись.
- Global final style/palette остаётся unlocked.

Следующий owner: Technical/Codex readback под отдельным executable brief, затем PM activation gate. Никакая runtime implementation authority этим пакетом автоматически не создаётся.
