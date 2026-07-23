# STEAM_DESKTOP — Current Context

Обновлено: 2026-07-22
Статус: active current-summary
Владелец: Producer / Game Designer / Project Manager
Назначение: короткий актуальный вход в Steam/Desktop без исторических roadmap, briefs и capture logs.

---

## Standard navigation

```text
Product: cozy idle production strip + dog community sim.
Platform now: macOS only; Windows is a later pre-release wave.
Priority: Visual Shell Lock → Interactive Shelter Shell.
Static visual verdict: selected H GRID32 USER_ACCEPTED / PASS.
Live visual verdict: NOT YET LOCKED.
```

Day 1/Day 2 убраны из текущего плана в будущее. Их уже реализованные
causality/persistence contracts остаются regression baseline и не определяют
видимую текущую очередь.

## 3. Current Steam status

Lock покрывает весь текущий roster поляны плюс Labrador и проверяет:

- гармонию только принятых Shelter assets;
- масштабы зданий, поляны и подземной части;
- расположение, default camera и usable composition;
- min/default/max window sizes;
- все zoom: `50% / 100% / 150% / 200%`;
- полное отсутствие legacy fences, polygon dogs и visual artifacts в будущем
  implementation result.

CQ Hero Town — reference for harmony/readability, не источник копируемых assets
или новой механики. Static exploration завершён по правилу 3–5 существенно
разных композиций за batch. Technical/visual automation не заменяет user
verdict. После live lock любое видимое изменение требует повторного approval.

Static selection завершён 2026-07-22: selected H GRID32 принят пользователем.
Final grid — `y[441,473)`, visible rows `441..472`, height `32`, earth margins
`25/7`. Exact source hashes, background/object geometry, depth, X/Y anchors and
accepted output hashes живут только в active independently verified selected-H
brief.

## Interactive Shelter Shell summary

- Dogs idle/walk/react.
- Building click opens one fixed rooms panel above meadow; meadow remains
  interactive. Only one panel; another building replaces it; same-building
  click is no-op; close by `X` or empty click; no minimize.
- Начать с одного выбранного существующего дома; здания без room visual не
  реагируют.
- Building click also shows anchored micro-card with only working `Move`.
- Dog click shows near-dog badge: portrait + name, no `X`; empty click closes;
  next entity replaces.
- Three render/occupancy layers only: back environment/decor, middle horizontal
  building-cell row, front dogs/routes.
- Move is one-at-a-time cursor-follow ghost; left confirm, right/Escape cancel
  before confirm; invalid cells pulse red/less transparent about 300 ms; zoom,
  manual pan and edge auto-pan stay active.
- After confirm cancellation is forbidden; source+destination reserved until
  final delivery. Occupants exit about every 100 ms; internal jobs freeze and
  persist. All free dogs carry; later-freed dogs join the oldest/current move.
- Empty run = `2×` base speed, loaded = `0.5×`; base speed follows traits and
  modifiers. One dog atomically reserves/carries one box.
- Box count by footprint cells: `1→3, 2→5, 3→8, 4→10, 5→12, 6→15`; `7+` forbidden.
- Both foundations persist until final box. Destination smoke reveals house;
  source disappears without smoke. No numeric progress UI.
- Assigned workers re-enter and resume; others idle. Eye-hide keeps simulation;
  closing app freezes it. Save/reload mid-move is required; restore may choose
  nearest foundation and nearest stable state.

Full sequence and acceptance gates:

```text
STEAM_DESKTOP__Game_Design_Roadmap_v2.md
```

## 6. Completed Day 2 scope and retained boundary

D-030 provides the implemented 26-cell/no-stretch/whole-game-zoom/dynamic-height/
alpha-click baseline. D-024 sealed pack is immutable pre-D-030 mechanical
evidence, not the current visual target. Selected-H runtime brief независимо
проверен и активирован для bounded implementation; Checkpoint 1 принят
пользователем. По D-032 Checkpoint 2 остаётся `HOLD` до implementation и
independent mechanical `PASS` активного current D-030/Selected-H regression
profile. Live user gate остаётся открыт.

Implemented Day 1/Day 2 causality and persistence remain regression contracts
only. Their player-facing milestones are future work and do not replace the
current `Visual Shell Lock → Interactive Shelter Shell` sequence.

## Read next

```text
Game Design: GAME_DESIGN__CURRENT_CONTEXT.md
Art: ../../03_DESIGN/ART_DIRECTION__CURRENT_CONTEXT.md
Dev: ../../04_DEVELOPMENT/CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md
Decisions: ../../00_START_HERE/02_DECISIONS.md (D-031)
```

## Next best step

Implement and independently mechanically verify the active D-030/Selected-H
current regression-profile brief. Only then resume Checkpoint 2 of the active
visual brief and its `min/default/max × four zoom` matrix.
