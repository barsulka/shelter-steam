# GAME_DESIGN__CURRENT_CONTEXT — Shelter Steam/Desktop

Дата создания: 2026-07-07
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

## 1. Current product state

Steam/Desktop current product formula:

```text
cozy idle production strip + dog community sim
```

Steam/Desktop is a Godot desktop game in a horizontal always-on-top sidescroll strip.

Current accepted product state:

```text
First Day MVP is locked at prototype/product-language proof level.
Next selected scope: First Week / Day 2 / longer retention.
```

The active question:

```text
Why does the player return tomorrow after the first warm delivery?
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
```

Main D-020 filter:

```text
Any system must first explain how it makes cooperative life richer, and only then what game bonuses it creates.
```

---

## 3. Current active roadmap

Active Steam/Desktop Game Design roadmap:

```text
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Game_Design_Roadmap_v2.md
```

Current active roadmap task:

```text
R-28 — Day 2 Return And Second Warm Delivery Codex Brief v1
```

Current direction source:

```text
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__First_Week_Direction_v1.md
```

Next likely output:

```text
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Day_2_Return_And_Second_Warm_Delivery_v1.md
```

---

## 4. First Day locked baseline

First Day accepted beats:

```text
Beat 1 — First work day in the cooperative.
Beat 2 — First trip for resources.
Beat 3 — Dogs prepare the delivery together.
Beat 4 — Player sends the first delivery.
Beat 5 — Postcard, slippers, memory and tomorrow hint.
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

Day 2 should show that yesterday mattered.

Do not jump immediately into a large new system. The next slice should be narrow and emotionally continuous.

Likely Day 2 ingredients:

```text
yesterday's postcard still visible
yesterday's slippers matter
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

## 9. Active open questions

Current Game Design / Steam questions:

```text
OQ-Steam-001 — Is First Week / Day 2 direction ready for implementation?
OQ-Steam-002 — Where is the boundary of First Week and what do we not add?
OQ-Steam-003 — What is the production art gate after prototype visual-language pass?
```

Source:

```text
docs/drive/Shelter/00_START_HERE/03_OPEN_QUESTIONS.md
```

---

## 10. Next best step

Prepare or approve the Day 2 implementation brief:

```text
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Day_2_Return_And_Second_Warm_Delivery_v1.md
```

The brief should be narrow:

```text
return moment
second warm delivery variation
yesterday's postcard/slippers/memory
first gentle packing note
first curiosity question boundary
no full new system
```

---

## 11. Changelog

### 2026-07-07 — v1 created

- Created Game Design current context for Steam/Desktop.
- Marked active roadmap and current R-28 task.
- Compressed First Day lock, Day 2 direction, systems foundation and do-not-read-by-default guidance.
