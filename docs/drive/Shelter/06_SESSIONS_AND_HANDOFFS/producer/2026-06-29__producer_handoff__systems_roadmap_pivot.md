# Producer handoff — Systems Roadmap pivot

Дата: 2026-06-29

## Роль сессии

Producer проекта Shelter.

## Что делали

Рассмотрели предложение Game Designer: вывести final visual acceptance Steam Vertical Slice из critical path Game Designer и передать визуальную приёмку Art Director, чтобы Game Designer мог перейти к системному дизайну.

Producer принял предложение с уточнением: Vertical Slice не считается полностью завершённым как visual/product slice, но считается достаточно доказанным на уровне gameplay proof.

## Ключевые выводы

- Steam Vertical Slice уже доказал gameplay proof на уровне locked loop, task chain, resource flow, player agency and D-010 trait/equipment separation.
- Visual proof остаётся открытым: readability, dog silhouettes, placeholder quality, visual hierarchy, strip composition, production art and final visual/usability acceptance.
- Эти visual questions являются critical path Art Director, а не Game Designer.
- Game Designer не должен блокироваться visual pass и может перейти к systems design.
- Systems Simulator полезен как internal Game Designer laboratory, но должен быть оформлен через Codex brief в `04_DEVELOPMENT` по D-017.

## Принятые решения

Принято D-018 — Steam Vertical Slice gameplay proof is enough for Game Designer systems branch.

Game Designer critical path перенесён в:

`docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Game_Systems_Roadmap_v1.md`

Art Director продолжает вести:

- final visual acceptance / usability / readability approval Vertical Slice;
- Capture Pack v2 review;
- readability 216 / 144 / 96;
- dog/action silhouettes;
- placeholder quality;
- UI visual hierarchy;
- strip composition;
- Dog Shape Pack v1;
- production art pipeline.

Codex Systems Simulator branch открыта через brief:

`docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Systems_Simulator_v0.md`

Recommended Codex reasoning level: **очень высокий**.

## Открытые вопросы

- Нужно ли создавать отдельный Art Director visual acceptance roadmap для Steam Vertical Slice / Dog Shape Pack v1.
- Нужно ли делать отдельный `STEAM_DESKTOP__Dog_Progression_Model_v1.md` сразу следующим шагом Game Designer.
- Нужно ли до запуска Codex Systems Simulator сначала дать Game Designer более подробный systems spec, или v0 simulator может стартовать с текущих источников и Vertical Slice model.

## Ссылки / источники

Прочитаны и использованы:

- `PROJECTS_RULES.md`
- `AGENTS.md`
- `README.md`
- `docs/repo/status/CODEX_STATUS.md`
- `docs/drive/Shelter/00_START_HERE/01_CURRENT_STATUS.md`
- `docs/drive/Shelter/00_START_HERE/02_DECISIONS.md`
- `docs/drive/Shelter/00_START_HERE/000_ROLE_PRODUCER.md`
- `docs/drive/Shelter/00_START_HERE/000_ROLE_GAME_DESIGNER.md`
- `docs/drive/Shelter/00_START_HERE/000_ROLE_ART_DIRECTOR.md`
- `docs/drive/Shelter/00_START_HERE/000_ROLE_CODEX.md`
- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Game_Design_Roadmap_v1.md`
- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Vertical_Slice_Playtest_Report_v1.md`
- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Vertical_Slice_Playtest_Checklist_v1.md`
- `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_VERTICAL_SLICE_ART_QA_CAPTURE_v2/README.md`
- `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_VERTICAL_SLICE_ART_QA_CAPTURE_v2/CAPTURE_MANIFEST_v2.md`

## Что обновлено в документах

Обновлено напрямую:

- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Game_Design_Roadmap_v1.md`
- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Game_Systems_Roadmap_v1.md`
- `docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Systems_Simulator_v0.md`
- `docs/drive/Shelter/00_START_HERE/000_ROLE_GAME_DESIGNER.md`
- `docs/drive/Shelter/00_START_HERE/000_ROLE_ART_DIRECTOR.md`
- `docs/drive/Shelter/00_START_HERE/02_DECISIONS.md`
- `docs/drive/Shelter/00_START_HERE/01_CURRENT_STATUS.md`
- этот handoff.

## Следующий лучший шаг

Game Designer:

1. начать `GS-01 — Dog Progression Model v1`;
2. затем `GS-02 — Dog Traits / Abilities / Equipment Taxonomy v1`;
3. затем `GS-03 — Activity Catalog v1`.

Art Director:

- закрывать visual proof Steam Vertical Slice по Capture Pack v2 and readability review.

Codex:

- при запуске Systems Simulator использовать brief:

`docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Systems_Simulator_v0.md`

- уровень рассуждений: **очень высокий**.
