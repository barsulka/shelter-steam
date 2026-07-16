# Steam/Desktop Art Source Reconciliation Wave v1

- Статус: **SOURCE_RECONCILED / ART_WARN_PENDING_USER_SOURCE_REVIEW**
- Тип: **source-only / not runtime executable / no runtime Art PASS**
- Владелец: Art Director + Visual Production owner
- Дата: 2026-07-13

## Результат

Пакет содержит новый исходный визуальный набор для базовой сцены Shelter, собранный по канонической грамматике D-011 и approved visual library. Это не planning-only документ: внутри находятся 34 редактируемых OpenRaster-мастера, 24 Labrador pose-family, lossless RGBA-экспорты, полный мир 2992×224, source-level contact/anchor data и визуальные QA-доски.

Формальный source-QA зелёный: `157/157 PASS`, `0 FAIL`. Большие белые cell backgrounds, sky matte, speckled alpha и неавторский хвост мира отсутствуют. Верхний desktop reserve остаётся прозрачным; faint-tree depth ограничен по яркости и альфе.

Итог остаётся с Art WARN до явного user/PM source-review по трём визуальным advisory:

1. Labrador местами читается чуть более пушистым/Golden-like, чем user-owner three-view, хотя пользователь уже положительно оценил полученное направление.
2. Kitchen следует подробной approved Kitchen v2.1 direction; D-011 допускает более тихий фасад, поэтому выбор детализации нельзя делать без пользователя/PM.
3. Approved Mill при review-высоте 188 px обладает заметной массой; его точный масштаб должен быть подтверждён пользователем/PM.

Эти пункты не отменяют source reconciliation и не разрешают дальнейший самовольный pixel-loop. Они также не являются runtime-блокерами до выбора канонического варианта владельцем.

## Состав

- `source/labrador/poses/` — 24 ORA-мастера с семантическими raster layers, локальной тенью и положительными координатами.
- `exports/labrador/poses/` — identity RGBA и composite-with-shadow RGBA.
- `source/world/world_master.ora` — полный layered world master 2992×224.
- `source/world/assets/` — Storage, Kitchen, first Packing Utility Prop, Van, Road sign, Bicycle, static Mill, fence и faint shrub/tree depth.
- `exports/world/` — lossless RGBA semantic exports.
- `evidence/` — full-layout black/checker, D-011/v5/new comparison, A–H, silhouettes, native 216/144/96 и обе стороны Kitchen/Packing contacts.
- `SOURCE_MANIFEST.json` — canvas, bounds, baselines, pivots, z/contact ownership, placements, H presentation proposal и source/runtime envelope.
- `QA_REPORT.json` — машинные source-level gates.
- `PROVENANCE.md`, `REFERENCE_READBACK.md`, `ART_QA.md` — происхождение, authority и Art verdict.
- `tools/build_package.py` — package-local deterministic builder; пишет только внутрь этого каталога.
- `INVENTORY.json`, `HASHES.sha256` — полный readback ledger.

## Зафиксированный scope

World order: **Road/Bicycle → Storage → Kitchen → Packing → Van**. Approved Mill добавлен между Storage и Kitchen только как статичный декоративный Utility Prop: без input, task, resource, output, progression или interaction.

Labrador остаётся первой живой собакой. Исходники покрывают A–H: idle/wait, start, два walk support, stop, оба physical turn, approach/contact, Kitchen work, Packing work/focus и спокойный ambient H. H имеет `SIGNED_GD_PM_TECHNICAL` authority только на bounded presentation coverage; этот пакет не выполняет selector или runtime binding.

Dog canvas: 512×320; root/baseline: `[256, 280]`; non-shadow identity envelope: 225 px. Review mapping: positive uniform scale `0.24`, full-width zoom `2992/1740`, projected non-shadow height `92.8551724137931 px`. Negative-scale mirror запрещён; обе стороны и оба physical-turn направления authored отдельно.

World canvas: 2992×224; shared baseline: `y=211`; фактические bounds, station contact planes, approach/contact/work/exit anchors и z/occlusion ownership находятся в `SOURCE_MANIFEST.json`.

## Не входит

Runtime/code/import/captures, transfer/pickup/carry/place/detach, новые mechanics/tasks/resources/rooms, Dachshund/cart behavior, bicycle choreography, future dog-life catalogue, station taxonomy rewrite, PlayerBoot/platform changes и глобальный style/palette lock.

Sheet A не использовался ни как reference, ни как principle, ни как source. Текущий v5 используется только как technical regression/visual anti-target.

## Promotion boundary

Никакой файл пока не переносится в `approved_art_files/`. Точные generated originals и их layered derivatives сохранены здесь как source-review candidates. Promotion разрешается только после явного PM/User source acceptance. После него требуется отдельный принятый Codex brief в `04_DEVELOPMENT`, runtime integration, immutable captures, независимый Art review и explicit user acceptance.
