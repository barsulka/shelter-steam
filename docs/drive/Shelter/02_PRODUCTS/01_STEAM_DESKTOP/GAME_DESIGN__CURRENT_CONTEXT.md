# GAME_DESIGN__CURRENT_CONTEXT — Shelter Steam/Desktop

Дата создания: 2026-07-07
Обновлено: 2026-07-13
Статус: current-summary / game-design current context
Владелец: Game Designer / Producer / Project Manager
Продукт: Steam/Desktop idle always-on-top strip
Назначение: быстрый вход в актуальное состояние гейм-дизайна Steam/Desktop без чтения всей истории Vertical Slice, systems roadmap, First Day proof и handoff.

---

## 0. How to use

Read this before opening old Game Design roadmaps, runtime reviews, capture packs or handoff.

This file is a current context, not a full design bible.

Default reading order for Game Design work:

```text
PROJECTS_RULES.md
AGENTS.md
BOOTSTRAP_CONTEXT.md
000_ROLE_GAME_DESIGNER.md
STEAM_DESKTOP__CURRENT_CONTEXT.md
GAME_DESIGN__CURRENT_CONTEXT.md
then task-specific docs
```

---

## Standard navigation

Current truth:

```text
Game Design focus: accepted First Day + Day 2 player journey under D-023.
D-022 Day 2 proof is complete at prototype/product-language/runtime-evidence level.
R-29 is closed / PASS; R48-00 is accepted.
```

Active roadmap / current task:

```text
Active roadmap: STEAM_DESKTOP__First_48_Hours_Playable_Roadmap_v1.md
Current task: exact 12-row Labrador manifest plus selector H is `SIGNED_GD_PM_TECHNICAL` (manifest SHA `d8f1a9fc9226588097eb7bdfc162b6eff520ef42605b369ba25f906daa52ae56`). The bounded source-reconciled Codex integration brief is `ACCEPTED / EXECUTABLE` (SHA `9fcaab17580f23b7a3d884440b802aa9c38f9181b84739bd0ba9dffcfa0159b1`). P0-C object transfer remains deferred to R48-05B.
```

Current field/viewport boundary:

```text
Gameplay field is fixed at `[0.0, 1740.0]`, independent of viewport. A static non-interactive Fence Boundary Marker starts at its right boundary; only meadow may continue exterior-side. The bounded semantic contract is ready for Technical readback, but does not authorize runtime work or alter A–H/D-023.
```

Current ambient-walk boundary:

```text
User direction: quality visual base now; rich dog-life catalogue later.
Labrador calm back-and-forth is signed selector H and may be bound only inside the active accepted Codex integration brief; it is not general ambient-simulation authority.
Mill is static decorative-only; Dachshund/cart behavior is not current scope.
```

Current decisions:

```text
D-009, D-010, D-012, D-013, D-018, D-019, D-020, D-022, D-023
```

Active open questions:

```text
OQ-Steam-003
```

Read next by task:

```text
Current scope: STEAM_DESKTOP__First_48_Hours_Playable_Scope_Lock_v1.md
Current roadmap: STEAM_DESKTOP__First_48_Hours_Playable_Roadmap_v1.md
Field/viewport semantics: STEAM_DESKTOP__Gameplay_Field_And_Viewport_Semantic_Contract_v1.md
Completed implementation: 04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Playable_Main_Scene_And_Launch_Surfaces_v1.md
Completed persistence foundation: 04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Player_Save_Store_Schema_And_Recovery_v1.md
Completed checkpoint implementation: 04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Runtime_Safe_Checkpoints_And_Continue_v1.md
Active bounded integration: 04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Accepted_Art_Source_And_Labrador_H_Runtime_Integration_v1.md (`ACCEPTED / EXECUTABLE`)
Systems details: read R-09..R-16 docs only when needed
```

Do not read by default:

```text
old roadmaps, old capture packs, old handoff, full CODEX_STATUS.md
```

Next best step:

```text
Review implementation evidence only after the active accepted R48-05A integration. Preserve exact A–H, `3 + 2`, persisted reserve, Quiet Cooperative and Day 2 semantics; H is executable only under its exact bounded brief, and no transfer row enters R48-05A.
```

---

## 1. Current product state

Steam/Desktop current product formula:

```text
cozy idle production strip + dog community sim
```

Steam/Desktop is a Godot desktop game in a horizontal always-on-top sidescroll strip.

Current accepted product state:

```text
First Day MVP is locked at prototype/product-language proof level.
Day 2 same-chain continuation is complete at prototype/product-language/runtime-evidence level.
D-023 First Day + Day 2 player journey scope is accepted; R48-01A, R48-02A, R48-02B and R48-03 are complete/PASS. Current game-first order is Labrador/world → non-modal onboarding → Kitchen → two-visit polish; R48-04A is later.
```

The active execution question:

```text
How do the accepted implementation waves deliver the session-based return without expanding the exact D-023 game semantics?
```

---

## 2. Core decisions that matter for game design

Use `02_DECISIONS.md` for full decision text. For current game-design work, the most relevant decisions are:

```text
D-009 — Steam/Desktop horizontal dog production co-op.
D-010 — Dog traits: innate vs changeable.
D-012 — Shared World: Browser Farm supplies Steam Co-op, MVP narrative-only.
D-013 — Steam resource trips replace visible crop farming.
D-018 — Vertical Slice gameplay proof unlocks systems branch.
D-019 — Game Design Systems Workbench over live Godot runtime.
D-020 — Project Philosophy / Shelter Constitution.
D-022 — complete same-chain Day 2 Warm Food Delivery executable scope lock.
D-023 — session-based First Day + Day 2 player journey, exact `3 + 2` inputs, persisted `x2/x2 → x1/x1` reserve, Quiet Cooperative with completed history preserved and active order/chain slots empty, Labrador P0 and Kitchen P1.
```

Main D-020 filter:

```text
Any system must first explain how it makes cooperative life richer, and only then what game bonuses it creates.
```

---

## 3. Current active roadmap

Active Steam/Desktop execution roadmap:

```text
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__First_48_Hours_Playable_Roadmap_v1.md
```

Current active roadmap task:

```text
R48-00 and ADR-0003 are accepted; R48-01A, R48-02A, R48-02B and R48-03 are complete/PASS. The exact Labrador manifest is SIGNED and bounded R48-05A is accepted/executable. Background evidence and R48-05B remain deferred.
```

Current direction sources:

```text
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__First_48_Hours_Playable_Scope_Lock_v1.md
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__First_48_Hours_Playable_Roadmap_v1.md
```

Current implementation source:

```text
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Playable_Main_Scene_And_Launch_Surfaces_v1.md
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Player_Save_Store_Schema_And_Recovery_v1.md
```

---

## 4. First Day locked baseline

First Day accepted beats:

```text
Beat 1 — First work day in the cooperative.
Beat 2 — First trip for resources.
Beat 3 — Dogs prepare the delivery together.
Beat 4 — Player sends the first delivery.
Beat 5 — Postcard, slippers, memory and next-visit hint.
```

Locked First Day elements:

```text
Dachshund — first driver.
Labrador — calm helper.
Route — Oat Farm / route.oat_farm_intro.
Order — First Warm Delivery / order.first_warm_delivery.
Reward — Comfortable slippers for Dachshund.
Memory — Remembers the first warm delivery.
```

First Day lock does **not** mean:

```text
production art
shipping UX
final balance
final visual style
Steam release readiness
```

---

## 5. Day 2 / First Week direction

Day 2 should show that the previous session mattered.

Do not jump immediately into a large new system. The next slice should be narrow and emotionally continuous.

Likely Day 2 ingredients:

```text
previous-session postcard still visible
previous-session slippers matter
Dachshund remembers the first warm delivery
second warm delivery variation appears
first gentle packing note / comfort detail
first curiosity question as a hint, not full House of Curiosity system
```

Scope guardrail:

```text
Day 2 is not First Month.
Day 2 is not full House of Curiosity.
Day 2 is not full economy expansion.
Day 2 is not production art pass.
```

---

## 6. Systems foundation already done

The following systems contracts exist as v1 docs and should be read only when the task needs them:

```text
STEAM_DESKTOP__Dog_Progression_Model_v1.md
STEAM_DESKTOP__Ability_Source_Loop_v1.md
STEAM_DESKTOP__Ability_Catalog_v1.md
STEAM_DESKTOP__Dog_Life_Model_v1.md
STEAM_DESKTOP__Building_System_v1.md
STEAM_DESKTOP__Production_Chains_v1.md
STEAM_DESKTOP__Laboratory_Research_Tree_v1.md
STEAM_DESKTOP__Economy_Balance_Foundations_v1.md
STEAM_DESKTOP__Core_Gameplay_Loop_Validation_v1.md
STEAM_DESKTOP__Game_Design_Systems_Workbench_Requirements_v1.md
```

Status:

```text
R-09..R-16 are complete at v1 systems-contract level.
```

Use `STEAM_DESKTOP__Game_Systems_Roadmap_v1.md` as completed reference, not as active roadmap.

---

## 7. Workbench / runtime evidence status

Godot runtime is the source of truth.

Accepted direction:

```text
Game Design Systems Workbench observes and controls accepted dev surfaces of live Godot runtime.
It must not become a standalone simulator.
```

Runtime capture / evidence has already been used for First Day proof. Use runtime review docs only when investigating implementation/state evidence.

---

## 8. Do not read by default

Do not read by default:

```text
STEAM_DESKTOP__Game_Design_Roadmap_v1.md — history.
STEAM_DESKTOP__Game_Systems_Roadmap_v1.md — completed systems-contract reference.
STEAM_DESKTOP__Game_Systems_Roadmap_v1.remaining_snapshot.md — archive snapshot.
old First Day visible review v1/v2 packs — evidence/history.
old Vertical Slice Art QA capture packs — evidence/history.
old handoff — use HANDOFF_INDEX.md first.
full CODEX_STATUS.md — use CODEX_CURRENT_STATUS.md first.
```

---

## 9. Active open question

Current Game Design / Steam questions:

```text
OQ-Steam-003 — What is the production art gate after prototype visual-language pass?
```

OQ-Steam-001 and OQ-Steam-002 were resolved by D-022 on 2026-07-11.

Source:

```text
docs/drive/Shelter/00_START_HERE/03_OPEN_QUESTIONS.md
```

---

## 10. Next best step

Day 2 implementation/evidence is accepted and R-29 is closed. Use it as baseline evidence; the active successor authority is:

```text
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__First_48_Hours_Playable_Scope_Lock_v1.md
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Playable_Main_Scene_And_Launch_Surfaces_v1.md
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Player_Save_Store_Schema_And_Recovery_v1.md
```

The completed brief boundary was narrow:

```text
return moment
second warm delivery variation
previous-session postcard/slippers/memory
first gentle packing note
full player-confirmed second delivery
one Labrador careful-packing cue
small progress note followed by an optional curiosity question
no active habit/research/economy/save/platform or production-art scope
no full new system
```

---

## 11. Changelog

### 2026-07-14 — field/viewport semantic boundary

- Fixed gameplay/buildable field to `[0.0, 1740.0]`, independent of viewport; exterior-side meadow is presentation-only and tile-safe without non-uniform stretch.
- Added the static, non-interactive right `Fence Boundary Marker`, authored mirrored-positive only; Labrador activity remains fail-closed outside the field/right-end reserve.
- Recorded default/right-end 15% reserve semantics and pan/click-through precedence for Technical readback without adding gameplay input, save state or runtime authorization.

### 2026-07-13 — ambient selector H, signer readbacks closed

- Added selector H to the unchanged 12-row Labrador manifest: task-free, fail-closed ambient reposition only before the offered start gate or in Quiet Cooperative.
- Kept it presentation-only, non-persisted and cancelable before any authoritative player-gate transition.
- Producer/PM and Technical/Codex readbacks are closed as `SIGNED_GD_PM_TECHNICAL`; its sole executable binding is the separate accepted source-reconciled Codex integration brief.

### 2026-07-13 — user direction and ambient-walk boundary recorded

- Recorded “quality base now, rich dog life later” as future-only backlog direction.
- Kept Mill static decorative-only and Labrador as the sole current living-dog priority.
- Classified calm Labrador back-and-forth as `NEEDS_MANIFEST_AMENDMENT`, preserving the exact station-bound A–G scope until a re-signed external manifest exists.

### 2026-07-12 — bounded Labrador manifest recorded

- Recorded the exact 12-row no-transfer R48-05A scope for owner readback.
- Kept P0-C and every prop/socket decision in later R48-05B.

### 2026-07-12 — game-first sequence synchronized

- Made exact Labrador action-manifest review the next Game Design gate.
- Preserved existing mechanics, `3 + 2`, resource provenance and Quiet Cooperative.
- Deferred R48-04A without accepting new game semantics.

### 2026-07-12 — R48-03 completed / game contract preserved

- The real player journey now performs the accepted session-based First Day → Day 2 transition without calendar time, refill, extra confirmations or fixture loading.
- Day 2 keeps exactly route + dispatch player inputs and ends in restart-stable Quiet Cooperative with no Day 3 or repeatable order.
- R48-04A remains a separate technical evidence gate; no new game-design decision was introduced.

### 2026-07-12 — R48-02B completed / game contract preserved

- Verified the exact seventeen-cursor First Day checkpoint matrix, three-input reward alignment and resource conservation in implementation.
- Preserved Day 2, offline and Quiet Cooperative semantics; ordinary Continue → Day 2 remains R48-03.

### 2026-07-12 — R48-02A complete / D-023 semantics preserved

- The strict player-profile envelope/store foundation completed without owning gameplay, offline time or journey transitions.
- `PlayerCheckpointV1`, autosave and First Day Continue are now complete/PASS.
- The exact `3 + 2`, persisted reserve and Quiet Cooperative contracts remain unchanged.

### 2026-07-12 — D-023 / R48-00 accepted

- Selected the session-based First Day + Day 2 player journey as the active executable program.
- Locked exact `3 + 2` player input, persisted `x2/x2 → x1/x1` reserve, Quiet Cooperative, Labrador P0 and Kitchen P1.
- Activated R48-01A/R48-02A brief preflight without authorizing implementation early.

### 2026-07-12 — R-29 closed / PASS

- Recorded Day 2 acceptance after full runtime/native evidence and fresh First Day regression.
- Removed R-29 from current work and intentionally left the next executable slice unselected.
- Kept dog production bindings, world/room work and OQ-Steam-003 as independent future gates.

### 2026-07-11 — D-022 accepted, R-29 activated

- Closed OQ-Steam-001/002 and moved from brief preparation to implementation/evidence review.
- Made full same-chain completion mandatory and kept the remaining production-art question independent.

### 2026-07-09 — standard current-context navigation

- Added Standard navigation block following `CURRENT_CONTEXT_TEMPLATE.md`.
- Made Day 2 current truth, R-28, decisions, open questions and read-next guidance visible near the top.

### 2026-07-07 — v1 created

- Created Game Design current context for Steam/Desktop.
- Marked active roadmap and current R-28 task.
- Compressed First Day lock, Day 2 direction, systems foundation and do-not-read-by-default guidance.
