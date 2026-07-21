# STEAM_DESKTOP — Current Context

Дата создания: 2026-07-07
Обновлено: 2026-07-21
Статус: active current-summary
Владелец: Producer / Game Designer / Project Manager
Назначение: короткий актуальный вход в Steam/Desktop контекст без перечитывания всей истории design, Codex, captures и handoff.

---

## Current override — 2026-07-21

- D-024 full ordinary-Terminal capture завершён и sealed как pre-D-030 technical/mechanical evidence; он не является текущим D-030 visual proof и не выдаёт final Art/user acceptance.
- D-030 fixed 26-cell meadow/whole-game zoom/dynamic-height/alpha-click correction реализован и проверен на exact Steam Godot route. Старое растянутое поле больше не является runtime surface.
- Прямая пользовательская оценка текущего вида: «уже более-менее»; это не финальный art lock.
- Следующая отдельная правка после checkpoint: explicit 26→13 cell amendment и здания ×2 на каждом zoom-level. До отдельной реализации текущий зафиксированный D-030 контракт остаётся 26 клеток.

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
D-029/D-024 observability, graceful-stop and atomic-runner remediation is implemented and independently no-Godot reviewed PASS (P0=0/P1=0/P2=0). The player-profile pre-flush correction is implemented and its focused fresh-process gate is PASS with supervisor rc0/process PASS/diagnostic PASS; full capture remains NOT_ACTIVATED / EVIDENCE_HOLD / UNSEALED pending a new user/coordinator decision and literal full-capture ACK.
D-025 makes the active development/QA/evidence/acceptance phase macOS-only and limits visual capture to two approved paths.
```

Active roadmap / current task:

```text
Active roadmap: STEAM_DESKTOP__First_48_Hours_Playable_Roadmap_v1.md
Current task: source-reconciled R48-05A is `TECHNICAL_MECHANICAL_PASS`; final runtime Art/user acceptance remains open. D-024 is `PLAYER_PROFILE_PRE_FLUSH_CORRECTION_IMPLEMENTED / FOCUSED_FRESH_PROCESS_GATE_PASS / SUPERVISOR_RC0 / PROCESS_PASS / DIAGNOSTIC_PASS / FULL_CAPTURE_NOT_ACTIVATED / CAPTURE_HOLD / EVIDENCE_HOLD / UNSEALED`. Contract A is `4f956a077d0a93575ef7b518fd0aa9fb409392a08fd4a48190364795bc9b5cbf`, current brief SHA M is `f2d26ebde2f27dde1c75cd82304d30f850b015834ed780947fbb6972bb111130`, and evidence remains 32 files/no seal/tree `4ca49b1d9cd0616d434eb534464087c75cebcd4972122356ad9197ec59cdd378`. PM sync activates nothing; full capture requires a new user/coordinator decision and literal full-capture ACK.
```

Current decisions:

```text
D-007, D-009, D-010, D-011, D-012, D-013, D-018, D-019, D-020, D-022, D-023, D-024, D-025, D-027, D-028, D-029
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
Wait for a new user/coordinator decision. Only a new literal full-capture ACK naming unchanged Contract A, brief SHA M, final governed implementation pins, pinned 32-file evidence tree, exact writer/scope and authorized retained-stage disposition may authorize one full runner attempt. This docs sync activates nothing. CA/editor_data/AppKit are historical/not current blockers and remain not allowlisted; recurrence is diagnostic FAIL/rc73 and STOP before capture/seal.
```

---

## 1. Product frame

Steam/Desktop — Godot game с будущими Windows/macOS targets в формате горизонтальной always-on-top sidescroll полоски. Текущий active implementation/QA/evidence/acceptance target до отдельной pre-release activation — только macOS; отсутствие Windows проверки не является WARN, blocker или текущим gate.

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
- D-024 — 100%-usable-width viewport with seam-safe tiled meadow, independent gameplay/buildable/viewport bounds, horizontal drag pan when needed, about 15% empty right reserve at every zoom, and a static decorative positive-scale mirrored Fence Boundary Marker at the buildable edge.
- D-025 — macOS-only development/assembly/QA/acceptance until a separate pre-release Windows wave, with exactly Godot self-capture or macOS Screenshot UI / Computer Use as visual-capture paths.
- D-027 — historical blockers require current bounded revalidation; material workaround routes require explicit user approval.
- D-028 — local Steam/Desktop development/QA/evidence uses only the repo-documented Steam-managed Godot binary/version.
- D-029 — Godot child output remains fully observable, finite tests exit naturally, graceful project quit precedes bounded SIGTERM fallback, hard kill/diagnostic suppression are forbidden.

Read decision details in:

```text
docs/drive/Shelter/00_START_HERE/02_DECISIONS.md
```

---

## 3. Current Steam status

Current state as of 2026-07-18:

```text
First Day MVP is locked at prototype/product-language level.
Day 2 is complete at prototype/product-language/runtime-evidence level; R-29 is closed / PASS.
D-023 separately selects `First 48 Hours Playable`; R48-01A, accepted ADR-0003/R48-02A, R48-02B and R48-03 are complete/PASS. Source-reconciled R48-05A is Technical/Mechanical PASS. D-024 source amendment/integration is accepted for the bounded trial; D-029/D-024 observability/atomic-runner remediation and the player-profile pre-flush correction are implemented, and the focused fresh-process Steam-Godot gate is PASS. Full capture remains NOT_ACTIVATED/HOLD/UNSEALED; the full runner, Continue/full runtime, actual PlayerBoot control ACK, GUI/native capture, 27 PNG, manifest, seal, promotion and final runtime Art/user acceptance are not run. The next gate is a new user/coordinator decision and literal full-capture ACK with retained-stage disposition. Runtime/gameplay remains no-touch. Parent R48-A/R48-05 stays PARTIAL/WARN. R48-05B, rooms, onboarding and R48-04A are later, not current.
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
The final source and direction-only approved promotion are accepted; external authority is `STEAM_DESKTOP__Art_Source_Reconciliation_Wave_v1__PM_User_Source_Acceptance.md` plus its Approved Promotion Record. The executable integration preserves `Road/Bicycle → Storage → Kitchen → Packing → Van`, Labrador-only living roster, static Mill and hard-excluded Sheet A.
```

Current dog boundary:

```text
Labrador remains the first living dog. Calm back-and-forth walking is the minimum desired living read; Dachshund/cart is not a current implementation requirement.
Exact manifest authority: `SIGNED_GD_PM_TECHNICAL` at SHA `d8f1a9fc9226588097eb7bdfc162b6eff520ef42605b369ba25f906daa52ae56`. Selector H retains exactly 12 rows and presentation-only start/walk/stop/turn. Runtime binding is authorized only through the accepted executable integration brief and its named writer.
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
STEAM_DESKTOP__Art_Source_Responsive_Meadow_Left_Cluster_Amendment_v1__PM_Activation_Status.md
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
R-29 and R48-03 are closed/PASS. Source-reconciled R48-05A is Technical/Mechanical PASS; final player-facing Art/user verdict remains open. D-024 presentation is mechanically green, D-029/D-024 observability/atomic-runner remediation is independently no-Godot reviewed PASS, and the player-profile correction plus focused fresh-process gate are PASS. Full capture stays NOT_ACTIVATED/HOLD/UNSEALED. Current next is a new user/coordinator decision and literal full-capture ACK naming A/M, final governed pins, pinned 32-file evidence tree, exact writer/scope and authorized retained-stage disposition; PM sync activates no full runner/runtime/control/capture.
```

Completed/accepted and current prepared implementation briefs:

```text
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Playable_Main_Scene_And_Launch_Surfaces_v1.md
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Player_Save_Store_Schema_And_Recovery_v1.md
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Runtime_Safe_Checkpoints_And_Continue_v1.md
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Accepted_Art_Source_And_Labrador_H_Runtime_Integration_v1.md
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__D024_Responsive_Meadow_Marker_And_Player_Presentation_Cleanup_v1.md — PLAYER-PROFILE CORRECTION IMPLEMENTED / FOCUSED FRESH-PROCESS GATE PASS / rc0 / PROCESS PASS / DIAGNOSTIC PASS / FULL CAPTURE NOT ACTIVATED / EVIDENCE HOLD / UNSEALED — Contract A 4f956a… / brief M f2d26e… / new literal full-capture ACK required
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

### 2026-07-18 — D-024 focused fresh-process gate PASS / full capture HOLD

- Recorded final player-profile correction hashes `cbc2eddf…` / `94cfed68…` and the fresh create/inspect result hashes `8442e0a2…` / `4784d87…` as rc0/process PASS/diagnostic PASS.
- Advanced current authority to unchanged Contract A plus brief M `f2d26e…`; focused diagnostics remain 18 files/PNG0/no seal/tree `39ea48e8…`, canonical evidence remains 32 files/no seal/tree `4ca49b1d…`, and the failed stage remains 144 files/no seal/tree `00116ac0…`.
- Full runner/runtime/control/native capture/27 PNG/manifest/seal/promotion and Art/user acceptance remain not run. CA/editor_data/AppKit are historical/not current blockers and remain not allowlisted. Only a new literal full-capture ACK with failed-stage disposition may continue.

### 2026-07-16 — D-029/D-024 remediation independent no-Godot PASS / capture HOLD

- Recorded the exact eight-file observability, graceful-stop and atomic-runner remediation as implemented and independently reproduced `PASS` with `P0=0 / P1=0 / P2=0`.
- Advanced current authority to Contract A plus whole brief SHA K `ccb81f8a…`; canonical evidence remains 32 files/no seal/tree `4ca49b1d…`.
- Kept real Steam Godot/runtime/control/capture/manifest/seal/promotion not run and final Art/user acceptance pending. A new user/coordinator decision and literal bounded real-run ACK is the sole next gate; CA remains real/unresolved/not allowlisted.

### 2026-07-15 — D-024 tool correction PASS / capture reactivation pending

- Pinned current immutable Contract A, final Phase 2 brief SHA C and corrected validator/runner result while preserving earlier activation and capture-path findings as history.
- Moved active state to `TOOL_CORRECTION_PASS / CAPTURE_REACTIVATION_PENDING_COORDINATOR_ACK / EVIDENCE_HOLD / UNSEALED`; capture is not active.
- Set the sole current next action to literal ACK naming A/C, then one existing-runner macOS capture, seal and independent Art/user review by reserved writer `019f6604-8ac6-7871-85c8-2c858a2240f3`.

### 2026-07-14 — D-025 macOS-first sequence / D-024 evidence resume

- Removed Windows parity from the current implementation, QA, evidence, warning, blocker and acceptance queues; long-term Windows targeting remains for a separately activated pre-release wave.
- Accepted the D-024 mechanical result as an unsealed candidate and reactivated the same sole writer only for capture completion.
- Made existing Godot self-capture the normal visual-evidence path; macOS Screenshot UI / Computer Use is reserved for desktop/native-window context, with no third/ad-hoc path.
- Classified the current AppKit/HIServices pre-Godot abort as a Codex-host limitation; the capture-only writer must first remove the forbidden legacy desktop path and stale Windows fields before using the existing runner.

### 2026-07-14 — D-024 Technical signed / one-writer runtime activation

- Accepted the additive two-asset/one-JSON topology, single runtime owner, 3840 fit cap, passthrough rules and existing KEY_H resolution.
- Activated the exact brief for the sole writer `019f5ce4-e63c-7d33-a586-d2d3031c8610`.
- Kept final runtime Art/user acceptance as a post-capture gate. D-025 later removed Windows native evidence from the current queue.

### 2026-07-14 — D-024 source accepted / correction brief prepared

- Accepted the exact 51-file amendment source for one bounded runtime trial after ledger, QA and visual/alpha readback.
- Kept 3840 vertical fit, clean player presentation and final runtime Art/user verdict as later capture gates.
- Prepared a separate non-executable brief; Technical exact-file preflight is the next owner step.

### 2026-07-14 — D-024 owner gates signed / explicit Art resume

- Closed exact GD and Technical contracts while keeping runtime authority blocked.
- Accepted the pre-existing `offscreen_left=-160` only as hidden D-013 external-trip absence state.
- Resumed the retained Art owner for the responsive meadow + authored-positive mirrored marker package source-only.

### 2026-07-14 — D-024 responsive meadow / field / viewport authority

- Accepted the four shown Labrador/building/meadow visuals as direction without reopening a broad pixel loop.
- Required seam-safe horizontal meadow tiling, independent gameplay/buildable/viewport bounds, drag pan when necessary and about 15% empty right reserve at every zoom.
- Added the static decorative Fence Boundary Marker immediately after the rightmost buildable cell; Art must supply a dedicated positive-coordinate mirrored export and runtime negative scale is forbidden.
- Kept the additive Art package paused pending GD, Technical and a separate PM resume activation.

### 2026-07-13 — source-reconciled integration activated

- Closed exact Art promotion and Technical preflight gates.
- Accepted the 2992-source-to-1740-runtime coordinate mapping without checkpoint/schema/cursor mutation.
- Assigned the executable atomic brief to the single Codex writer thread `019f5ce4-e63c-7d33-a586-d2d3031c8610`; runtime Art/user acceptance remains after captures.

### 2026-07-13 — Art source accepted / integration brief prepared

- Recorded exact final source acceptance and P1 accept-as-is boundary for one integration trial.
- Pinned current anchor order, static decorative Mill, Labrador-only living roster, provenance route and Sheet A exclusion through the external PM activation record.
- Kept selector H non-runtime-executable and prepared the separate Technical-preflight brief without activating it.

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
