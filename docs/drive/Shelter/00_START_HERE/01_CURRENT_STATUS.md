# 01_CURRENT_STATUS

Обновлено: 2026-07-22
Статус: active current-summary
Владелец: Producer / Project Manager
Назначение: ответить только на вопрос «где Shelter находится сейчас?».

---

## Текущий фокус

Активный продукт — Steam/Desktop на macOS. Текущий приоритет:

```text
Visual Shell Lock → Interactive Shelter Shell
```

Day 1/Day 2, Browser, Mobile, новый MCP и инфраструктура не входят в текущую
очередь. Реализованные Day 1/Day 2 persistence/causality остаются техническим
regression baseline.

## Visual Shell Lock

Статическая фаза закрыта: 2026-07-22 пользователь полностью принял selected H
GRID32 как `USER_ACCEPTED / PASS`. Приняты весь текущий roster поляны плюс
Labrador, композиция, масштабы, placement, depth, default framing и grid
`y[441,473)`; точный воспроизводимый contract зафиксирован в следующем Codex
brief. Это static PASS, а не live-runtime lock.

Checkpoint 1 runtime принят пользователем. Checkpoint 2 остаётся `HOLD` до
implementation и independent mechanical `PASS` активного current
D-030/Selected-H regression profile по D-032. После этого active visual brief
продолжает paired `GRID + CLEAN` checkpoints и
`min/default/max × 50/100/150/200` matrix. Финальный live visual `PASS` выдаёт
только пользователь.

## Runtime baseline

- D-024 sealed pack: `PASS / TECHNICAL_MECHANICAL_ONLY`, pre-D-030 evidence,
  Contract A `4f956a077d0a93575ef7b518fd0aa9fb409392a08fd4a48190364795bc9b5cbf`.
- D-030 implemented: 26-cell meadow period, whole-game zoom, dynamic height,
  alpha-aware click surface. Это стартовая mechanical baseline, не art lock.
- Selected H GRID32 static composition: `USER_ACCEPTED / PASS`; live matrix ещё
  не реализована и не принята.

## Interactive Shelter Shell

Следующий milestone после visual lock: собаки idle/walk/react; entity
micro-cards; одна fixed room panel над интерактивной поляной; горизонтальное
перемещение зданий в среднем слое с foundations/boxes/dog carriers;
save/reload mid-move. Production/gameplay ничего не производят на этом этапе.

Exact contract и очередь:

```text
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Game_Design_Roadmap_v2.md
```

## Next step

Реализовать активный prerequisite brief:

```text
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__D030_Selected_H_Current_Presentation_Regression_Profile_v1.md
```

После его реализации и independent mechanical `PASS` продолжить Checkpoint 2
по активному visual brief:

```text
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Selected_H_Visual_Shell_Runtime_Integration_And_Live_Matrix_v1.md
```

Visual brief активен, но Checkpoint 2 пока `HOLD`; live visual gate остаётся
открытым. Cards, move, rooms и gameplay остаются вне этой implementation-wave.

## Current documentation

Use `BOOTSTRAP_CONTEXT.md`, relevant current-context и task-specific Knowledge.
Superseded/history — Git history. `CODEX_CURRENT_STATUS.md` — текущий dev-status;
`CODEX_STATUS.md` существует только как fixed-path no-write compatibility exception.
