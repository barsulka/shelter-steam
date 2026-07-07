# STEAM_DESKTOP — Current Context

Дата создания: 2026-07-07
Статус: active current-summary
Владелец: Producer / Game Designer / Project Manager
Назначение: короткий актуальный вход в Steam/Desktop контекст без перечитывания всей истории design, Codex, captures и handoff.

---

## 0. Read policy

Читать этот документ после:

```text
PROJECTS_RULES.md
AGENTS.md
README.md
00_START_HERE/BOOTSTRAP_CONTEXT.md
соответствующего role-doc
```

Этот документ не заменяет specs. Он показывает, какие Steam/Desktop документы сейчас актуальны и что уже не нужно перечитывать по умолчанию.

---

## 1. Product frame

Steam/Desktop — Windows/macOS Godot game в формате горизонтальной always-on-top sidescroll полоски.

Принятая формула D-009:

```text
cozy idle production strip + dog community sim
```

Shelter Steam — это не классическая ферма и не холодная фабрика. Это производственный кооператив, в котором живут собаки.

Основные product constraints:

- производство остаётся ядром;
- жизнь собак делает производство живым;
- игрок заботится о кооперативе, а не микроменеджит каждую лапу;
- все важные действия должны быть физически видимы: идти, нести, готовить, фасовать, грузить, возвращаться;
- благотворительность добровольная, прозрачная, без давления;
- никаких боёв, PvP, монстров, боссов, paid gacha, aggressive FOMO, guilt pressure.

---

## 2. Core accepted decisions for Steam

Active decisions:

- D-007 — Godot as Steam/Desktop engine.
- D-009 — horizontal dog production co-op.
- D-010 — innate traits vs equipment / acquired memory / learned habits.
- D-011 — Cozy Modular Diorama as visual candidate, not final art style.
- D-012 — Browser Farm supplies Steam Co-op as shared-world narrative; no mandatory MVP sync.
- D-013 — Steam resource trips replace visible crop farming.
- D-018 — Vertical Slice gameplay proof is enough for Game Designer systems branch; visual proof is separate.
- D-019 — Game Design Systems Workbench over live Godot runtime; no standalone simulator.
- D-020 — Shelter makes life richer, not the warehouse.

Read decision details in:

```text
docs/drive/Shelter/00_START_HERE/02_DECISIONS.md
```

---

## 3. Current Steam status

Current state as of 2026-07-07:

```text
First Day MVP is locked at prototype/product-language level.
Next selected scope: First Week / Day 2 / longer retention.
```

Important caveat:

```text
This is not production art lock, not shipping UX lock, not final balance lock, and not Steam release readiness.
```

---

## 4. First Day MVP locked shape

Accepted First Day beats:

```text
Beat 1 — В кооперативе первый рабочий день
Beat 2 — Первая поездка за ресурсами
Beat 3 — Собаки вместе готовят поставку
Beat 4 — Игрок отправляет первую поставку
Beat 5 — Открытка, тапочки, память и завтрашний намёк
```

Accepted entities:

```text
Такса — первый водитель
Лабрадор — спокойный помощник
Route — Овсяная ферма / route.oat_farm_intro
Order — Первая тёплая поставка / order.first_warm_delivery
Reward — Удобные тапочки для Таксы
Memory — Помнит первую тёплую поставку
```

First Day completion state:

```text
order.delivery_confirmed: true
order.postcard_visible: true
order.reward_available: true
game.chain_complete: true
first_day.postcard_life_moment_seen: true
first_day.first_reward_equipped: true
first_day.first_memory_added: true
first_day.next_day_hint_available: true
```

Source:

```text
STEAM_DESKTOP__First_Day_MVP_Lock_And_Next_Scope_Decision_v1.md
```

---

## 5. Current visual / UX status

Latest accepted visual-language evidence:

```text
STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v3
```

Art/UX verdict:

```text
PASS as First Day Art/UX Visual Language Pass.
NOT production art.
NOT final visual style.
NOT shipping UX.
NOT final animation polish.
```

Accepted at prototype level:

- hidden UI prototype readability;
- Dachshund first-driver cue;
- Labrador calm-helper cue;
- physical payload flow;
- packing table Food Bag object state;
- van ready object-state proof;
- postcard board attention cue;
- comfortable slippers as dachshund personal reward cue;
- next-day hint as physical note object;
- compact strip composition at 96 px.

Sources:

```text
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Art_UX_Review__First_Day_MVP_v3.md
docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v3/
```

Do not create blocking v4 readability pass unless a new concrete visual/product problem appears.

---

## 6. Current next scope: First Week / Day 2

Accepted next direction:

```text
Day 2 should not add a big new system immediately.
Day 2 should show that yesterday mattered.
```

First Week means:

```text
Day 2 + first repeatable direction + first longer-retention promise
```

Day 2 opening should show:

- postcard remains on board;
- Такса still has slippers visible;
- Dog Card still shows first memory;
- packing note remains near packing area;
- Лабрадор is near packing / kitchen area;
- new calm order card is available.

Preferred retention pattern:

```text
memory -> small behavior change -> new order variation -> gentle improvement opportunity -> optional curiosity note
```

Source:

```text
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__First_Week_Direction_v1.md
```

---

## 7. Current implementation / tooling context

Godot prototype and tooling exist. Use current implementation context:

```text
docs/drive/Shelter/04_DEVELOPMENT/CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md
```

High-level implemented capabilities:

- Godot project under `steam/`.
- Vertical Slice prototype.
- First Day MVP runtime/visual evidence.
- Godot State Connector.
- Godot Control Connector.
- Workbench Runtime Capture Harness.
- Shelter MCP preferred local bridge.
- Capture pack generation for visual review.

Codex tasks must be assigned through brief files in:

```text
docs/drive/Shelter/04_DEVELOPMENT/
```

---

## 8. Active documents for Steam work

For product / game design:

```text
STEAM_DESKTOP__First_Day_MVP_Lock_And_Next_Scope_Decision_v1.md
STEAM_DESKTOP__First_Week_Direction_v1.md
STEAM_DESKTOP__Game_Design_Roadmap_v2.md
STEAM_DESKTOP__First_Day_MVP_v1.md
STEAM_DESKTOP__Vertical_Slice_Scope_Lock_v1.md
STEAM_DESKTOP__Task_Flow_Contract_v1.md
STEAM_DESKTOP__Object_Contract_v1.md
```

For visual / UX:

```text
STEAM_DESKTOP__Art_UX_Review__First_Day_MVP_v3.md
D-011_Cozy_Modular_Diorama_Candidate_A.md
D-011_Steam_Overlay_Main_Strip_v1_Rules.md
DOG_VISUAL_LANGUAGE_v1.md
DOG_RUNTIME_AND_ANIMATION_GRAMMAR_v1.md
```

For development:

```text
CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md
docs/repo/status/CODEX_STATUS.md
docs/repo/adr/README.md
steam/AGENTS.md
steam/README.md
```

---

## 9. Do not read by default

Do not read by default:

- `STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v1/`
- `STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v2/`
- `STEAM_VERTICAL_SLICE_ART_QA_CAPTURE_v1/`
- `STEAM_VERTICAL_SLICE_ART_QA_CAPTURE_v2/`
- old completed Codex briefs;
- old Codex log history below latest relevant status entries;
- `Systems_Simulator_v0` archived/superseded brief;
- old roadmap snapshots unless investigating how the roadmap changed.

Use:

```text
docs/drive/Shelter/00_START_HERE/SUPERSEDED_MAP.md
```

---

## 10. Current next best step

Recommended next product/design step:

```text
Producer confirms whether First Week Direction v1 is ready to become the next implementation slice.
```

If accepted, prepare a narrow Codex brief, likely:

```text
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Second_Day_Return_And_Second_Order_v1.md
```

Suggested Codex reasoning level:

```text
очень высокий
```

Do not expand into:

- full First Week calendar;
- full House of Curiosity research tree;
- many new orders;
- new dog recruitment;
- full economy complexity;
- production art pass;
- monetization / charity prompts;
- Browser Extension mechanics.

---

## 11. Changelog

### 2026-07-07 — v1 created

- Created compressed Steam/Desktop current context.
- Marked First Day MVP as locked at prototype/product-language level.
- Marked First Week / Day 2 as next scope.
- Pointed new sessions to latest v3 visual-language evidence and away from old capture packs.
