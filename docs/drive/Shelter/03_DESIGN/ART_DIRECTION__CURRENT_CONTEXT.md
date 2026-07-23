# ART_DIRECTION__CURRENT_CONTEXT — Shelter Steam/Desktop

Обновлено: 2026-07-22
Статус: active current-summary
Владелец: Art Director / Producer / Project Manager
Назначение: текущая visual authority и следующий Art Director gate.

---

## Current truth

Приоритет — **Visual Shell Lock**. Selected H GRID32 полностью принят
пользователем как static `USER_ACCEPTED / PASS` 2026-07-22. Это не заменяет
оставшийся live-runtime gate. First Day/Day 2 preview/review history не является
текущим art route.

Reference target: гармония и композиционная цельность CQ Hero Town, но только
на принятых Shelter assets. Нельзя копировать чужие assets, расширять roster или
менять mechanics.

## Lock scope

- весь текущий roster поляны плюс Labrador;
- гармония всех ассетов вместе;
- масштабы buildings/meadow/underground part;
- placement и default camera;
- min/default/max window sizes;
- zoom `50/100/150/200`;
- отсутствие legacy fences, polygon dogs и artifacts в целевом runtime.

## Exploration method

Exploration batch завершён. Runtime должен воспроизвести selected H без новых
assets, redraw или компенсирующих optical X-offset. Каждый user checkpoint
показывает обе версии `GRID + CLEAN`; затем вся сцена проверяется на
min/default/max windows × four zoom. Automatic technical/visual checks не имеют
права выдавать final visual `PASS`. После live lock любое visible change требует
повторного user approval.

## Accepted static key

- output canvas `2992×480`; clean SHA-256
  `00d744288a87b3b850629de66e1afa4801e9cf40389e83c929c04cddf8946fce`;
- accepted grid SHA-256
  `50f03e09dc7095c909262b8a092be0f7f6feefdb88a6b9eaf367eb25f928182d`;
- earth `y[416,480)`, grid `y[441,473)`, visible rows `441..472`, margins
  `25/7`, N=26, occupied `[4,5,6,7,9,10,13,14,15,16,17,18,19]`;
- exclusive visible alpha-bottom anchors: rear buildings `367`, middle
  Sign/Bike/Van `386`, front Labrador `402`;
- building X uses authored/full-canvas pivot at footprint midpoint with
  deterministic integer snap; visible-alpha center is forbidden as X authority.

Full source paths/hashes, background transforms, object table, grid boundaries
and exact capture contract are canonical in the active independently verified
selected-H Codex brief.

## Manual acceptance cadence

```text
selected H static PASS → chosen live scene → cards → move → rooms → integrated shell
```

Art Director не проектирует move mechanics, room state, economy или task flow.
Он выдаёт visual layouts/assets/readability constraints по уже принятому
contract.

## Active sources

```text
docs/drive/Shelter/03_DESIGN/00_VISUAL_DIRECTION/STEAM_DESKTOP__Visual_Production_Roadmap_v1.md
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Game_Design_Roadmap_v2.md
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Selected_H_Visual_Shell_Runtime_Integration_And_Live_Matrix_v1.md
docs/drive/Shelter/03_DESIGN/00_VISUAL_DIRECTION/D-011_Cozy_Modular_Diorama_Candidate_A.md
docs/drive/Shelter/03_DESIGN/00_VISUAL_DIRECTION/D-011_Steam_Overlay_Main_Strip_v1_Rules.md
```

Hash-pinned D-024/R48 source/evidence remains regression/provenance input only;
it is not a mandate to preserve rejected visible artifacts.

## Next best step

Review the paired live checkpoints produced under the active Codex brief. Do not
generate replacement art or room/card/move visuals.
