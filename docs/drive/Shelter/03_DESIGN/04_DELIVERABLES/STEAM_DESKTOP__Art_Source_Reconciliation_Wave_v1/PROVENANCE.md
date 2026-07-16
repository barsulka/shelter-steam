# Provenance

- Дата производства: 2026-07-13
- Владелец сессии: Art Director + Visual Production owner
- AI-use: **да, declared**

## Toolchain

- Генерация: встроенный OpenAI `imagegen` / `image_gen__imagegen`.
- Точное backend model name/version: **UNKNOWN / NOT SURFACED BY TOOL**.
- Seed: **UNKNOWN / NOT SURFACED BY TOOL**.
- Generation settings beyond prompt/reference images: **NOT SURFACED BY TOOL**.
- Package builder: Python 3.12.13, Pillow 12.2.0, NumPy 2.3.5.
- Editable derivative format: OpenRaster (`.ora`) + lossless semantic RGBA PNG layers.

Права не выдумываются: изображения сгенерированы для этого проекта в пользовательской сессии и разрешены user-owner для внутреннего source review. Отдельный документ о distribution/platform licensing в локальной документации не найден; его отсутствие явно остаётся PM/release gate до внешней публикации. User-owner three-view был предоставлен пользователем как identity reference; исходный автор, tool и отдельная license запись неизвестны.

## Сохранённые flattened originals

| Файл | SHA-256 | Размер / mode | Роль |
|---|---|---|---|
| `references/generated_originals/labrador_locomotion_sheet__flattened_original.png` | `fe67c60b752ae80d590a40ccbdfd60d3cb5c4d9037e3738e2eef73184cdc5ad6` | 1536×1024 RGB | A–D/H locomotion и physical-turn generation original |
| `references/generated_originals/labrador_work_sheet__flattened_original.png` | `9c6379cdd893a76fbd01318efe5c92705f0ef0772e1e2481bf5740d5d570577c` | 1536×1024 RGB | approach/contact/Kitchen/Packing/G/H generation original |
| `references/generated_originals/world_asset_sheet__flattened_original.png` | `ede0519364aa6146c1ff3f0ae3143b9f902d8b9fb0bc1cdde27dbe93d3cf0f9e` | 1672×941 RGB | generated world anchors original |
| `references/generated_originals/world_meadow_plate__flattened_original.png` | `0b206080265c405bb59a00a16491b3cabe596500def0de4dab38cb9f5dfe9924` | 1672×941 RGB | generated meadow/faint-tree/ground original |

Эти четыре файла — **flattened RGB originals**, не layered editable masters. Layered ORA-файлы — честные семантически разделённые raster derivatives с извлечённой альфой; они не объявляются нативными layered outputs модели и не копируют flattened approved pixels в master.

## Prompts recorded from the production session

### Labrador locomotion

Создать чистый 4×3 character pose sheet одного и того же взрослого тёпло-золотого Labrador на белом фоне, согласованного с user-owner three-view и approved Watering direction. Ряды: idle right, idle/wait left, physical turn right-to-front, physical turn left-to-front; затем start/walk support A/walk support B/stop facing right; затем те же четыре состояния facing left. Натуральная мягкая анатомия, широкая грудь, округлая голова и muzzle, висячие уши, средние ноги и крупные лапы, низкий спокойный хвост, тёплая шерсть; без props и без текста.

### Labrador work/focus

Создать того же Labrador в чистом 4×3 sheet на белом фоне: approach right/left, contact-align right/left; Kitchen work right/left с поднятыми рабочими лапами; Packing work right/left с аккуратно вытянутой лапой; Packing focus right/left; ambient attentive right/left. Сохранить одну identity, натуральную анатомию, спокойный характер и читаемые контакты; без station pixels и без текста.

### World asset sheet

По D-011 и approved Kitchen/Storage/Mill directions создать 4×2 чистый asset sheet на белом фоне: Road sign + static Bicycle, Storage, static Mill, Kitchen; Packing workbench Utility Prop, Van endpoint, quiet fence segments, faint shrub/tree depth. Сохранить Shelter taxonomy и тёплый живой illustrated language; без собак, UI и новых gameplay entities.

### Meadow plate

По D-011 и approved decor/world references создать широкий plate: верхние примерно 65% белые/пустые, нижние примерно 35% — непрерывная органическая поляна с grass mass, worn dirt/path, soil edge, contact islands и едва заметными нижними деревьями/кустарником. Без зданий, собак и UI.

Формулировки выше — production-session record. Отдельный machine-generated prompt receipt/tool log не был выдан инструментом; это явно отмечено, а не восстановлено как несуществующий exact API payload.

## Derivative process

`tools/build_package.py` выполняет cell crops, гарантированный padding, connected exterior-background flood fill, low-chroma/high-value matte extraction, edge-aware soft matte/unmatte, RGB decontamination soft edges, connected-component cleanup, transparent padding, semantic raster partition, deterministic ORA/PNG export, 2992×224 composition и QA boards.

World faint-tree depth — единственный слой с намеренным bounded tint/alpha grade, чтобы удалить белый sky matte и сохранить D-011 barely-visible depth. Generated originals остаются byte-identical.

Source paths, export paths, per-pose bounds/pivots and every file hash находятся в `SOURCE_MANIFEST.json`, `INVENTORY.json` и `HASHES.sha256`.
