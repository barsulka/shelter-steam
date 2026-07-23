# GAME_DESIGN__CURRENT_CONTEXT — Shelter Steam/Desktop

Обновлено: 2026-07-22
Статус: active current-summary
Владелец: Game Designer / Producer / Project Manager
Назначение: текущий gameplay/UX contract для двух shell milestone без истории Day 1/Day 2.

---

## Current truth

Game Design не меняет Visual Shell composition: selected H GRID32 уже получил
static `USER_ACCEPTED / PASS`, а faithful live-runtime matrix остаётся текущим
gate. Gameplay milestone после live lock — **Interactive Shelter Shell**, в
котором всё работает, но production/gameplay пока ничего не производят.

Day 1/Day 2 отложены; их implemented state/save contracts остаются regression
baseline. Gameplay/economy может развиваться параллельно только under the hood,
не меняя visible scene или locked UX.

## Interaction contract

### Selection and panels

- One selected entity at a time; next selection replaces the previous.
- Building: anchored micro-card above it with sole working `Move` button.
- Dog: CQ-like badge near dog, portrait + name only, no `X`.
- Empty click closes entity card/badge.
- Building click immediately opens one fixed rooms panel above the meadow while
  meadow stays interactive; one panel only; other building replaces; same
  building click no-op; close by `X` or empty click; no minimize.
- First room proof uses one user-selected existing house. Buildings without a
  room visual do nothing.

### Placement

Exactly three render/occupancy layers:

1. back environment/decor;
2. middle building cell row;
3. front dogs/routes.

Buildings move only horizontally in the middle layer. No player layer changes.
Move immediately attaches a ghost to cursor; left click confirms, right click
or Escape cancels only before confirmation. Occupied/invalid ghost and cells
pulse red and less transparent for about 300 ms. Zoom, manual pan and edge
auto-pan remain available.

### Move transaction

- One move at a time.
- On confirm, source and destination remain reserved through completion;
  cancellation is forbidden.
- Existing occupants exit at roughly 100 ms intervals at the entrance. Their
  jobs/internal state freeze and persist.
- Move starts even with zero free dogs: occupants exit, packing smoke plays,
  old building becomes source foundation with boxes, destination becomes empty
  foundation.
- All free dogs participate automatically; dogs freed later join the
  oldest/current move.
- Empty dog run is `2×` base speed; loaded state `0.5×`; base speed derives from
  traits/modifiers.
- One dog atomically reserves and carries one box.
- v1 has no special carry animation/icon: box disappears at pickup and appears
  at destination on delivery. Later breed-specific animation may include
  upright Labrador and rope/tail-first Dachshund.

Box count:

| Footprint cells | Boxes |
| ---: | ---: |
| 1 | 3 |
| 2 | 5 |
| 3 | 8 |
| 4 | 10 |
| 5 | 12 |
| 6 | 15 |

Buildings of 7+ cells are forbidden for now.

Both foundations remain until final delivery. Multiple dogs may overlap; no
artificial spreading. Final box at destination triggers short smoke and house
appearance; source disappears without smoke. Visual stacks only, no numeric
progress UI.

After completion assigned workers re-enter and resume frozen work; other dogs
idle outside. Eye-hide keeps simulation running. Closing the app freezes all.
Save/reload mid-move is mandatory; restoration may place dogs at nearest
foundation and nearest stable state.

## Acceptance order

```text
static selected H PASS → chosen live scene → cards → move → rooms → integrated shell
```

User is the sole final visual gate and reviews frequently. Game Design owns
mechanical/UX contract; Art owns visual execution; Codex implements only an
accepted brief.

## Active roadmap

```text
STEAM_DESKTOP__Game_Design_Roadmap_v2.md
```

## Open inputs

- user final live-matrix Visual Shell Lock after selected-H integration;
- user choice of first existing house for room proof;
- accepted room visual for that house;
- separate implementation briefs after each gate.

## Next best step

No new mechanic/design expansion. Preserve the accepted static contract while
the bounded Codex brief implements and verifies only its live matrix.
