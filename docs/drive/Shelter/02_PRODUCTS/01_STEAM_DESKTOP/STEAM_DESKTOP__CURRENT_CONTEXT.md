# STEAM_DESKTOP — Current Context

Дата создания: 2026-07-07
Обновлено: 2026-07-13
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

## Standard navigation

Current truth:

```text
Steam/Desktop = cozy idle production strip + dog community sim.
First Day MVP locked at prototype/product-language level.
D-022 Day 2 same-chain Warm Food Delivery variation is complete at prototype/product-language/runtime-evidence level.
R-29 is closed / PASS.
D-023 First Day + Day 2 player journey scope lock is accepted.
```

Active roadmap / current task:

```text
Active roadmap: STEAM_DESKTOP__First_48_Hours_Playable_Roadmap_v1.md
Current task: R48-05A v5 Technical PASS is retained as regression evidence, but the overall current look is CHANGES_REQUIRED / USER_OWNER_REJECTED_CURRENT_LOOK. Accept the prepared Art reconciliation package, then run a bounded Art source wave before any new Codex integration brief.
```

Current decisions:

```text
D-007, D-009, D-010, D-011, D-012, D-013, D-018, D-019, D-020, D-022, D-023
```

Active open questions:

```text
OQ-Steam-003
```

Read next by task:

```text
Game Design: GAME_DESIGN__CURRENT_CONTEXT.md
Art/UX: ART_DIRECTION__CURRENT_CONTEXT.md
Implementation: CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md
Evidence/history: EVIDENCE_READ_POLICY.md and HANDOFF_INDEX.md first
```

Do not read by default:

```text
old captures, old completed briefs, old handoff, full CODEX_STATUS.md, superseded simulator docs
```

Next best step:

```text
PM/User accept the prepared Art reconciliation package; Art then restores the bounded D-011/approved-library/Labrador source foundation with existing mechanics only. A separate accepted/executable Codex brief is required before runtime integration. No v6 patch loop, R48-05B, room, onboarding or background work now.
```

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
- D-011 — canonical target for the current Steam main-strip reconciliation, not a new global palette/final-style lock.
- D-012 — Browser Farm supplies Steam Co-op as shared-world narrative; no mandatory MVP sync.
- D-013 — Steam resource trips replace visible crop farming.
- D-018 — Vertical Slice gameplay proof is enough for Game Designer systems branch; visual proof is separate.
- D-019 — Game Design Systems Workbench over live Godot runtime; no standalone simulator.
- D-020 — Shelter makes life richer, not the warehouse.
- D-022 — one complete same-chain Day 2 Warm Food Delivery variation was the accepted executable slice; it is now implemented and R-29 is closed.
- D-023 — session-based First Day + Day 2 player journey, exact `3 + 2` inputs, persisted reserve, Quiet Cooperative, Labrador P0 and Kitchen P1.

Read decision details in:

```text
docs/drive/Shelter/00_START_HERE/02_DECISIONS.md
```

---

## 3. Current Steam status

Current state as of 2026-07-13:

```text
First Day MVP is locked at prototype/product-language level.
Day 2 is complete at prototype/product-language/runtime-evidence level; R-29 is closed / PASS.
D-023 separately selects `First 48 Hours Playable`; R48-01A, accepted ADR-0003/R48-02A, R48-02B and R48-03 are complete/PASS. R48-05A v5 is Technical PASS evidence but its overall visible result is rejected. Current work is Art reconciliation acceptance and a new bounded source wave; parent R48-A/R48-05 stays open. R48-05B, rooms, onboarding and R48-04A are later, not current.
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
Beat 5 — Открытка, тапочки, память и намёк на следующий визит
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

Current reconciliation authority:

```text
D-011 full main-strip composition + the approved_art_files visual library + the accepted Labrador direction/identity pair are the canonical current targets. The approved Mill may be included literally only as static decoration, with no mechanic/task/resource/output/input. Current runtime v5 is regression evidence, not the visual target.
```

Current dog boundary:

```text
Labrador remains the first living dog. Calm back-and-forth walking is the minimum desired living read, but its exact selector requires Game Design acceptance and later implementation through a separate executable Codex brief. Dachshund/cart is not a current implementation requirement.
Exact status: NEEDS_MANIFEST_AMENDMENT. Existing start/walk/stop/turn rows are reused; no new vocabulary row is needed, but current A–G allows locomotion only under station selector C. A bounded selector amendment needs Game Design, Producer/PM and Technical/Codex re-sign before executable binding.
```

Ambient-walk fail-closed guardrails:

```text
No current/queued Labrador task. Allowed only pre-TripTask while an order is offered or post-Day-2 in Quiet Cooperative. ready_to_send calm wait wins. Forbidden during authoritative trip/task/delivery, restore and save failure/retry. A player gate cancels the presentation before transition. Zero gameplay/save/progression output.
```

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
- next-visit hint as physical note object;
- compact strip composition at 96 px.

Sources:

```text
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Art_UX_Review__First_Day_MVP_v3.md
docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v3/
```

Do not create blocking v4 readability pass unless a new concrete visual/product problem appears.

---

## 6. Completed Day 2 scope and retained boundary

Accepted Day 2 direction, now implemented:

```text
Day 2 should not add a big new system immediately.
Day 2 should show that the previous session mattered.
One complete second Warm Food Delivery on the existing route/resource/station chain is mandatory proof.
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

Accepted completion boundary:

```text
fixture return -> full visible production chain -> Labrador careful-pack cue -> visible Van load
-> player-confirmed DeliveryTask -> small progress note -> optional post-completion question -> quiet end state
-> archive completed Day 2 result into journey history -> clear active order/chain slots -> Quiet Cooperative
```

Production save/calendar, new route/chain/resources/stations, active habit/research/economy, production dog pipeline and platform semantics remain out of scope.

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
- Shelter MCP runtime/capture adapter capability; active local setup transition is tracked by D-021 and the dedicated workflow brief.
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
STEAM_DESKTOP__First_48_Hours_Playable_Scope_Lock_v1.md
STEAM_DESKTOP__First_48_Hours_Playable_Roadmap_v1.md
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
STEAM_DESKTOP__Art_Reconciliation__Dog_Buildings_Meadow_v1/README.md
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

Current product/design boundary:

```text
R-29 and R48-03 are closed/PASS. The prepared Art reconciliation package must be accepted by PM/User first. Then Art owns one bounded source-only wave for canonical base graphics and existing mechanics. Ambient Labrador walking remains NEEDS_MANIFEST_AMENDMENT and must receive the three owner re-signs before it can enter a later separate accepted/executable Codex integration brief. No v6 patch loop or R48-05B/room/onboarding/background work is current.
```

Completed and current accepted implementation briefs:

```text
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Playable_Main_Scene_And_Launch_Surfaces_v1.md
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Player_Save_Store_Schema_And_Recovery_v1.md
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Runtime_Safe_Checkpoints_And_Continue_v1.md
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

### 2026-07-13 — current base graphics / later dog-life direction

- Made D-011, approved_art_files and accepted Labrador direction the canonical current reconciliation targets.
- Allowed literal Mill inclusion only as static decoration; kept Labrador first and Dachshund/cart outside current requirements.
- Fixed the Art reconciliation → PM/User → Art source → separate Codex brief → runtime Art/user review sequence.
- Kept R48-05B, rooms, onboarding, background work and the wider dog-life catalogue later; no v6 patch loop is authorized.

### 2026-07-12 — 05A/05B owner convergence

- Recorded source-only Art Package next, bounded no-transfer 05A and later one-transfer 05B.
- Kept full parent and runtime activation claims honest.

### 2026-07-12 — game-first implementation order

- Made Playable World + First Living Labrador the next prepared wave, followed by calm onboarding, Kitchen and two-visit polish.
- Deferred background/minimize/performance evidence without marking its D-023 contract complete.
- Kept proposed Art/animation documents fail-closed until owner preflight accepts exact inputs.

### 2026-07-12 — R48-03 completed / persisted Day 2 return PASS

- Ordinary player return now advances a fully completed First Day profile into the accepted Day 2 journey exactly once, without fixture loading or wall-clock progression.
- The complete second delivery and restart-stable Quiet Cooperative are covered by the strict 33-cursor player checkpoint graph.
- First Day, D-022, persistence failure/restart and native journey regressions remain green; R48-04A is only the next unaccepted brief gate.

### 2026-07-12 — R48-02B completed / PASS

- Implemented and verified the exact First Day checkpoint/Continue brief after cross-role PASS.
- Passed the full cursor/restart/kill/failure matrix and retained R48-03 as the organic Day 2 return boundary.

### 2026-07-12 — R48-01A/R48-02A complete / R48-02B brief next

- Unified ordinary player launch and added the strict non-playable profile-store foundation.
- Preserved the one-runtime/no-offline/no-fixture boundary and advanced only to R48-02B brief preparation.
- Continue, autosave and Day 2 persisted transition are not yet implemented.

### 2026-07-12 — R-29 closed / Day 2 accepted

- Recorded the Producer closeout after canonical Day 2 and First Day regression evidence passed.
- Removed R-29 from the current-task slot and intentionally left the successor unselected.
- Preserved production art, room, save/calendar and platform work as separate gates.

### 2026-07-11 — D-022 Day 2 scope accepted

- Closed readiness/boundary questions and moved the current task from brief preparation to implementation/evidence review.
- Kept production art, dog-pipeline architecture and desktop-platform readiness as separate gates.

### 2026-07-09 — standard current-context navigation

- Added Standard navigation block following `CURRENT_CONTEXT_TEMPLATE.md`.
- Made current truth, active roadmap/task, decisions, open questions, read-next guidance and do-not-read defaults visible near the top.

### 2026-07-07 — v1 created

- Created compressed Steam/Desktop current context.
- Marked First Day MVP as locked at prototype/product-language level.
- Marked First Week / Day 2 as next scope.
- Pointed new sessions to latest v3 visual-language evidence and away from old capture packs.
