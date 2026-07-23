# STEAM_DESKTOP — Shell Roadmap (compatibility path: Game Design Roadmap v2)

Дата: 2026-07-22
Статус: active current roadmap
Владелец: Producer / Game Designer / Art Director / Project Manager
Назначение: каноническая последовательность Visual Shell Lock и Interactive Shelter Shell.

---

Current product status:

```text
D-030 mechanical baseline is implemented. Selected H GRID32 has static USER_ACCEPTED / PASS; faithful live runtime is not yet locked. Day 1/Day 2 are future. Current priority remains Visual Shell Lock followed by Interactive Shelter Shell.
```

Current active task:

```text
Execute the active selected-H runtime brief: implement only that accepted composition and its live window/zoom matrix.
```

## 0.1 Current navigation

This compatibility path is the single canonical shell roadmap. It replaces the
old active First 48 Hours/Day 1/Day 2 navigation without duplicating it.

## 0. Program outcome

Deliver a pleasant desktop shell in two milestones:

1. the whole visible world is visually coherent and user-locked;
2. it becomes interactable and alive without producing gameplay outputs.

This roadmap supersedes the active First 48 Hours/Day 1/Day 2 queue. Those
implemented contracts remain regressions and future content.

## 1. Milestone A — Visual Shell Lock

### Scope

- entire current meadow roster plus Labrador;
- all accepted assets read as one harmonious scene;
- building/meadow/underground scale;
- placement and default camera;
- min/default/max windows;
- zoom `50/100/150/200`;
- future runtime result removes legacy fences, polygon dogs and visual artifacts
  completely rather than covering them.

CQ Hero Town is the harmony/reference bar only. No external asset, mechanic or
layout is copied into Shelter.

### Sequence and gates

#### VSL-1 — Composition batches

Art Director produces 3–5 substantially different static compositions per
batch. A batch is invalid if variants differ only in tiny offsets, color or
crop. Each uses the same accepted Shelter roster and declares intended default
camera plus extreme-window/zoom risks.

Gate: user selects one static composition or requests another batch.

State: **complete — selected H GRID32 USER_ACCEPTED / PASS (2026-07-22)**.

#### VSL-2 — Chosen live scene

After selection, a separate Codex brief integrates only the chosen composition,
removes legacy runtime visuals and preserves current gameplay/persistence.

Active independently verified and coordinator-activated brief:

```text
../../04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Selected_H_Visual_Shell_Runtime_Integration_And_Live_Matrix_v1.md
```

Gate: exact Steam/Godot technical checks plus manual user review at:

```text
min window × 50/100/150/200
default window × 50/100/150/200
max window × 50/100/150/200
```

Automatic checks may return mechanical/diagnostic results only. User is sole
final visual gate. Any visible change after lock reopens this gate.

### DoD

- [x] User selected and accepted selected H GRID32 as the static composition.
- [ ] Same composition is implemented without substitute assets.
- [ ] Legacy fences, polygon dogs and artifacts are absent from runtime.
- [ ] Default camera and all 12 window/zoom combinations are reviewed.
- [ ] User explicitly grants Visual Shell Lock.

## 2. Milestone B — Interactive Shelter Shell

Milestone B begins only after VSL DoD. Production/gameplay must not produce
anything yet.

### ISS-1 — Dogs and selection cards

- Dogs idle, walk and react.
- Building click shows anchored micro-card above building with one working
  button: `Move`.
- Dog click shows CQ-like near-dog badge: portrait + name only, no `X`.
- Empty click closes; next entity replaces previous.

Gate: user manual review of cards in live locked scene.

### ISS-2 — Building placement and move

Exactly three render/occupancy layers:

1. back environment/decor;
2. middle building-cell row;
3. front dogs/routes.

Buildings move horizontally only within middle layer. Player cannot change
layer.

#### Pre-confirm

- one move at a time;
- `Move` immediately enables cursor-follow ghost like CQ;
- left click confirms;
- right click/Escape cancels;
- invalid/occupied ghost+cells pulse red and less transparent for ~300 ms;
- zoom, manual pan and edge auto-pan remain active.

#### Post-confirm transaction

- cancellation is forbidden;
- source and destination stay reserved until completion;
- occupants exit at entrance at ~100 ms intervals;
- jobs and internal state freeze and persist;
- move starts even with zero free dogs;
- packing smoke, source foundation with boxes, empty destination foundation;
- all free dogs participate; newly free dogs join oldest/current move;
- empty run `2×` base speed; loaded `0.5×`; base speed derives from dog
  traits/modifiers;
- one dog atomically reserves/carries one box;
- v1 has no carry animation/icon: box disappears at pickup and appears at
  destination delivery;
- later breed-specific option: Labrador upright, Dachshund rope/tail-first.

Box table:

| Building footprint | Boxes |
| ---: | ---: |
| 1 cell | 3 |
| 2 cells | 5 |
| 3 cells | 8 |
| 4 cells | 10 |
| 5 cells | 12 |
| 6 cells | 15 |

`7+` cells are forbidden.

Both foundations remain until final delivery. Multiple dogs may overlap; no
artificial spread. Progress is stacks only, no number. Final box causes short
smoke and house appearance at destination; source disappears without smoke.

On completion assigned workers re-enter and resume frozen work; others idle.
Eye-hide keeps simulation running; app close freezes it. Save/reload mid-move is
required. Restore may place dogs at nearest foundation and nearest stable state.

Gate: user manual move review in live locked scene.

### ISS-3 — One room surface

- click building immediately opens one fixed panel above meadow;
- meadow remains interactive;
- only one room panel;
- other building replaces; same building click is no-op;
- close by `X` or empty click; no minimize;
- begin with one user-selected existing house;
- buildings without room visual do not react.

Gate: user manual room review.

### ISS-4 — Integrated shell

Cards, move, rooms, dogs, pan/zoom, hide and save/reload work together without
changing the locked visible scene or producing gameplay results.

Gate: user integrated-shell acceptance.

### DoD

- [ ] Dogs idle/walk/react in the locked scene.
- [ ] Entity card/badge replacement and empty-click behavior match contract.
- [ ] One move transaction passes pre-confirm, post-confirm, reservation,
      occupant, late-dog, box and completion rules.
- [ ] Mid-move save/reload returns nearest stable state without duplication.
- [ ] One selected existing house has the fixed rooms panel contract.
- [ ] Eye-hide continues simulation; app close freezes it.
- [ ] No production/gameplay output or visible under-hood expansion leaks in.
- [ ] User accepts integrated shell.

## 3. Manual acceptance cadence

```text
composition batch
→ chosen live scene
→ cards
→ move
→ rooms
→ integrated shell
```

Each arrow is a stop gate. PM, Art Director, Game Designer, Codex and automatic
checks cannot manufacture the user's visual acceptance.

## 4. Parallel work boundary

Gameplay/economy may be designed or implemented under the hood only when a
separate accepted brief proves it cannot change:

- visible scene;
- locked composition/assets/camera;
- entity cards;
- move UX/transaction;
- room behavior;
- current acceptance cadence.

Browser, Mobile, new MCP and infrastructure stay frozen until this shell is
pleasant and playable.

## 5. Stop conditions

Stop and return to the owner if:

- a new asset/roster/mechanic is needed to make a composition work;
- an automatic result is being treated as final visual PASS;
- legacy visuals are only hidden rather than removed;
- move needs a fourth layer, post-confirm cancel or numeric progress UI;
- room work starts before user selects the house/visual;
- visible gameplay/economy behavior leaks into the shell;
- any locked visible element changes without renewed user approval;
- a significant Codex task lacks a separate accepted brief.

## 6. Current next step

Execute the active selected-H Codex brief: implement only the accepted runtime
composition and stop at the paired `GRID + CLEAN` checkpoints before the full
live matrix/user gate.
