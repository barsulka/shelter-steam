# STEAM_DESKTOP — Responsive Meadow + Left Cluster Amendment v1

Статус: `SOURCE_AMENDMENT_READY / SOURCE_ONLY / NOT_RUNTIME_EXECUTABLE`

Дата: 2026-07-14

Owner: Art Director + Visual Production

## Результат

Пакет добавляет ровно два новых source-входа D-024:

1. один world-anchored бесшовный meadow tile `748×224 RGBA`, равный `435 world units`; четыре периода покрывают игровое поле `[0, 1740]` без растяжения;
2. отдельный положительно authored зеркальный `Fence Boundary Marker`, который ставится pivot-плоскостью на `world x=1740` и целиком растёт вправо, во внешнюю неинтерактивную область.

Принятые Labrador A–H, здания, Road/Bicycle, Mill, Packing, Van, station contact roots, baseline, z/occlusion и их semantic order не перерисовывались и не перемещались. В runtime, frozen source package, `approved_art_files`, PM/GD/Technical/Codex документы и captures пакет не писал.

## Responsive rule

- Игровое поле: `WORLD_WIDTH=[0,1740]`.
- Meadow: один texture source, phase origin `x=0`, period `435`; повторяется только по X и только по видимому диапазону. Y-repeat, stretch, crop, gutter, black fill и повтор static cluster запрещены.
- `z_min = 0.85 × viewport_width / 1740`.
- Default: `camera_x=0`.
- Right clamp: `camera_max=max(0,1740 - 0.85 × viewport_width / zoom)`.
- Граница поля попадает примерно в `85%` ширины viewport; внешний reserve составляет `15%` и содержит только продолжение поляны плюс один marker.
- Для source QA right-end использован `zoom=1.05×z_min`, `camera_x=82.8571428571`.

Измеренный reserve:

| Viewport | Default | Right end |
|---|---:|---:|
| 2992×224 | 15.006684% | 15.006684% |
| 3456×224 | 14.988426% | 14.988426% |
| 3840×224 | 15.000000% | 15.000000% |

## Source и exports

- Meadow master: `source/meadow_tile/meadow_tile_master.ora`
- Meadow export: `exports/meadow/meadow_tile_rgba_748x224.png`
- Marker master: `source/fence_boundary_marker/fence_boundary_marker_master.ora`
- Marker export: `exports/boundary_marker/fence_boundary_marker_rgba.png`
- Numeric/source contract: `SOURCE_MANIFEST.json`
- Machine QA: `QA_REPORT.json`
- Art readback: `ART_QA.md`
- Provenance: `PROVENANCE.md`
- Reference maturity/readback: `REFERENCE_READBACK.md`
- Complete inventory/ledger: `INVENTORY.txt`, `HASHES.sha256`

## Meadow contract

- Dimensions/mode: `748×224 RGBA`.
- Alpha bounds: `[0,92,748,224]`; первые 92 строки полностью прозрачны и сохраняют upper reserve.
- Source scale: `2992/1740 = 1.7195402298850575 px/world unit`.
- Baseline: `source y=211` = `world y=122.7072192513369`.
- Exact edge identity: 8 px с обеих сторон; RGBA и alpha delta = `0`.
- Import recommendation для будущего Codex brief: lossless PNG вне atlas; linear filtering; mipmaps off; X-repeat или явные repeated quads по одному world phase; никакого Y-repeat.

## Boundary marker contract

- Dimensions/mode: `174×106 RGBA`.
- Alpha bbox: `[0,0,174,106]`.
- Opaque functional body bbox: `[9,25,150,77]`.
- Pivot/contact: `[0,105]`; placement `[1740,122.7072192513369]` world units.
- Positive uniform mapping: `1740/2992 = 0.5815508021390374`; runtime mirror/negative scale запрещены.
- Opaque body начинается с `world x=1745.2339572192514`, то есть целиком снаружи boundary plane.
- Draw slot: после принятого layer 16 и перед текущими resources/cues.
- Это только декоративный неинтерактивный marker: он не entity, collision, input, station или mechanic authority.

## Сохранённые gameplay/Art границы

- Единственный повторяемый класс — meadow tile.
- Buildings, Road/Bicycle, Mill, Packing, Van, Labrador и marker не повторяются.
- Frozen H route `[480,2380] source px` маппится в `[279.14438502673795,1384.090909090909] world units` и не меняется.
- Kitchen/Packing contact exclusion остаются frozen: `[714.144385026738,839.177807486631]` и `[975.2606951871658,1071.798128342246]` world units.
- За `x=1740` нет buildable/station/A–H/idle/dog-activity space.
- `offscreen_left=-160` остаётся только скрытым D-013 Dachshund/Bicycle absence sentinel и не является видимой поляной или игровым пространством.

## Maturity и следующие gates

Этот пакет не выдаёт runtime/import authority, runtime Art PASS или user acceptance. Следующий owner — PM/User source acceptance. После неё нужны отдельный accepted Codex brief, Technical preflight/activation, runtime integration, immutable captures и независимые Art/user verdicts.
