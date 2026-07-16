# Provenance — D-024 Responsive Meadow Amendment v1

## Production record

- Дата: 2026-07-14.
- Production owner: Art Director + Visual Production session, выполнено через Codex.
- Метод: детерминированная package-local raster derivation; новой ImageGen-генерации или редактирования bitmap-моделью не было.
- Builder: `tools/build_amendment.py`.
- Runtime: bundled Python `3.12.13`, Pillow `12.2.0`, NumPy `2.3.5`.
- AI declaration: AI использовался для постановки правил, написания детерминированного builder и визуального QA. Идентификатор underlying model в файловый production runtime не передан; он не выдуман.
- Seed/prompts/settings: неприменимо — generative bitmap call не выполнялся.

## Meadow source lineage

Новый layered ORA создан из четырёх semantic RGBA layers hash-locked frozen package `STEAM_DESKTOP__Art_Source_Reconciliation_Wave_v1`, HASHES SHA-256 `7abc64cc21025a08312a63a8cfd7486652854f4fdf30d12179fd072161f9600b`:

- `00__world_depth_faint_trees_shrubs.png` — `2bb3600102c666bb410ae1647c166697ad3645dfb4b0310e1e9470bbac81788d`
- `01__world_ground_grass_mass.png` — `9ef3e77a921ebb3d1a8b460f462651092e73a1e5a00e4a01482d4b40262c3a8c`
- `02__world_path_dirt_worn.png` — `f2752e10b3ea13783d692f1e11983a69d69f1de5c7e7e1a696dc90853bb43169`
- `03__world_ground_soil_base.png` — `1f0775c8c13fed69897b2d9e2c1a790fbd0165e7c314c50b6cd785f19f82906e`

Каждый 2992×224 layer разделён на четыре 748-px периода, свёрнут в premultiplied-alpha average, после чего только 40-px edge region согласован до 8-px exact identity. Semantic layers сохранены раздельно в новом ORA; flattened direction sheet не объявляется editable master.

Meadow direction original `world_meadow_plate__flattened_original.png`, SHA-256 `0b206080265c405bb59a00a16491b3cabe596500def0de4dab38cb9f5dfe9924`, остаётся только accepted visual-direction lineage. Новый master опирается на уже извлечённые layered source pixels.

## Fence marker source lineage

Источник: frozen layered master `source/world/assets/fence_segments/fence_segments_master.ora`, SHA-256 `f1b8905b7566a2e62bafcddea7e87f629e5e762be9fbc1d0a402192ce4138e00`.

Один принятый fence span вырезан по semantic alpha bounds, все четыре слоя развёрнуты по горизонтали и записаны как новый положительно-координатный layered source. Это authored derivative в package; никакого runtime mirror/negative scale нет.

## CQ user reference

- Package copy: `references/user_owner/CQ_Hero_Town__Full_Width_Living_Lane__User_Owner_Layout_Reference.png`.
- SHA-256: `23582b529a32db016a51a19ce9e9743eb5077edb1ebc9ba24bbd54aed54c41c1`.
- Dimensions/mode: `3456×302 RGBA`.
- Source: user-provided CQ Hero Town screenshot.
- Creator, license и отдельные rights сведения: не предоставлены/неизвестны; никаких прав не выдумано.
- Роль: только layout principle — непрерывная полоса земли, объекты над общей поверхностью и reserve за границей игрового поля.
- Pixel/style/character/building/UI reuse: `ZERO`. Файл не production master и не derivative input.

## Rights boundary

Право использования новых derivatives наследуется только в пределах уже принятого project-local Shelter source и user/PM authority. Отдельная внешняя лицензия в локальной документации не заявлена; пакет не создаёт новой rights claim. Sheet A не читался builder и не использовался: `ZERO REUSE`.
