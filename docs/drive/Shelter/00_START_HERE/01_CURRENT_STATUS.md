# 01_CURRENT_STATUS

Обновлено: 2026-07-16
Статус: active current status
Владелец: Producer / Project Manager

---

## Кратко о проекте

Shelter — группа добрых приложений/игр вокруг темы помощи собакам и приютам.

Планируемые продукты:

1. Desktop/Steam idle-игра для Windows/macOS.
2. Мобильная idle/farm-игра.
3. Браузерное расширение: «посмотри рекламу — накорми собак».

Главная философия D-020:

```text
Shelter делает богаче жизнь, а не склад.
Shelter — это производственный кооператив, в котором живут собаки.
```

---

## Текущий фокус

Активный продуктовый фокус: **Steam/Desktop**.

Текущий этап Steam/Desktop:

```text
First Day MVP закрыт на уровне prototype/product-language proof.
D-022 Day 2 same-chain Warm Food Delivery variation завершена на уровне prototype/product-language/runtime-evidence.
R-29 закрыт / PASS.
D-023 First Day + Day 2 player journey scope lock принят.
D-029/D-024 observability, graceful-stop and atomic-runner remediation implemented; independent no-Godot review PASS with P0=0/P1=0/P2=0. Capture remains BLOCKED / EVIDENCE_HOLD / UNSEALED until a new user/coordinator decision and literal bounded real-run ACK.
D-025 фиксирует macOS-only development/QA/acceptance до отдельной pre-release Windows activation и ровно два разрешённых visual-capture path.
```

Главная текущая задача:

```text
R48-00 accepted. R48-01A, R48-02A, R48-02B and R48-03 completed/PASS. Source-reconciled R48-05A integration is `TECHNICAL_MECHANICAL_PASS`; final runtime presentation/user acceptance remains open. D-029/D-024 is `D029_D024_OBSERVABILITY_ATOMIC_RUNNER_REMEDIATION_IMPLEMENTED / INDEPENDENT_NO_GODOT_REVIEW_PASS / P0=0 / P1=0 / P2=0 / CAPTURE_BLOCKED / EVIDENCE_HOLD / UNSEALED`: Contract A is `4f956a077d0a93575ef7b518fd0aa9fb409392a08fd4a48190364795bc9b5cbf`, current whole brief SHA K is `ccb81f8a7f881ad078dad54bcd811dad2616aa36f843b2bee0ca67c2487d26ed`, and the canonical evidence root is unchanged at 32 files/no seal/tree `4ca49b1d9cd0616d434eb534464087c75cebcd4972122356ad9197ec59cdd378`. PM sync activates nothing; a bounded real run requires a new user/coordinator decision and literal ACK. Windows is not a current gate, WARN or blocker.
```

Актуальный вход в Steam-контекст:

```text
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__CURRENT_CONTEXT.md
```

---

## Актуальный bootstrap / сжатие контекста

Документация проекта стала большой. Для новых сессий введён сжатый слой входа:

```text
docs/drive/Shelter/00_START_HERE/BOOTSTRAP_CONTEXT.md
docs/drive/Shelter/00_START_HERE/SUPERSEDED_MAP.md
docs/drive/Shelter/00_START_HERE/05_DOCUMENTATION_GOVERNANCE.md
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__CURRENT_CONTEXT.md
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/GAME_DESIGN__CURRENT_CONTEXT.md
docs/drive/Shelter/03_DESIGN/ART_DIRECTION__CURRENT_CONTEXT.md
docs/drive/Shelter/04_DEVELOPMENT/CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md
docs/repo/status/CODEX_CURRENT_STATUS.md
```

Новые сессии не должны восстанавливать проект через все старые briefs, capture packs, handoff и длинный `CODEX_STATUS.md`.

Документация теперь делится на три слоя:

```text
Current Memory — короткая текущая правда для bootstrap.
Knowledge — активные решения, specs, references and ADRs по задаче.
History — handoff, completed briefs, capture packs, evidence and long logs.
```

Когда D-026 bridge сообщает `health=current`, routine bootstrap/context routing начинается с `shelter_context_bundle(role, area, task, max_bytes)`. D-026 принят, реализован и независимо reviewed `PASS`; direct source reads остаются authority/exact fallback для documented conditions.

Порядок exact verification/fallback:

1. `PROJECTS_RULES.md`
2. `AGENTS.md`
3. `README.md`
4. `00_START_HERE/BOOTSTRAP_CONTEXT.md`
5. role-doc
6. релевантный current-context документ
7. deep Knowledge docs только по задаче
8. History только для evidence / regression / archaeology

---

## Рабочая среда ChatGPT Work / Codex

По D-021 и уточняющему D-026 активный рабочий путь Shelter:

```text
Healthy Shelter MCP source-derived bundle — default routine bootstrap/context routing.
Локальный checkout — authority, exact verification, editing path and fallback.
Shelter MCP в mcp/ — local domain-specific runtime/inspection adapter.
Shelter MCP подключается локально по STDIO через project-scoped config.
```

Отдельные задачи/роли синхронизируются через локальные документы, RFC, brief и handoff. Память соседней задачи не считается источником проектной правды.

Технический переход MCP/config D-021 завершён: актуальны `.codex/config.toml` и `mcp/run.sh`. D-026 source-derived implementation существует и независимо reviewed `PASS`; static current-fact mirror/fingerprints и global startup knowledge gate удалены, capability-local failure подтверждён. Прежние два P1 и два P2 finding закрыты без новых P0/P1/P2 или compatibility regressions; full local matrix/client smokes проходят, daily-default rollout активен.

---

## Boundary — this is not a full index

`01_CURRENT_STATUS.md` отвечает на вопрос:

```text
Где проект находится сейчас?
```

Он не должен становиться полным индексом всех документов.

Правило поддержки:

- добавлять сюда только project-wide current truth;
- не дублировать long decision details, roadmap history, capture evidence, handoff lists or completed Codex logs;
- для routine маршрутизации использовать healthy source-derived bundle; source docs и current-context docs всегда остаются authority/exact verification и применяются напрямую при documented fallback conditions;
- для history/evidence использовать `SUPERSEDED_MAP.md`, `EVIDENCE_READ_POLICY.md` and `HANDOFF_INDEX.md`.

---

## Steam/Desktop — актуальный статус

Steam/Desktop — Godot 4.x desktop game с будущими Windows/macOS targets в формате горизонтальной always-on-top sidescroll полоски. До отдельного pre-release решения вся разработка, сборка, QA, evidence и acceptance идут только на macOS; Windows отсутствует в текущей очереди гейтов.

Принятая формула D-009:

```text
cozy idle production strip + dog community sim
```

Сырьевые ресурсы в Steam не выращиваются через классический видимый crop farming. По D-013 они добываются через off-screen поездки собак на внешние фермерские локации, а Steam-полоска остаётся кооперативом/мастерской.

First Day MVP locked elements:

```text
Такса — первый водитель
Лабрадор — спокойный помощник
Route — Овсяная ферма / route.oat_farm_intro
Order — Первая тёплая поставка / order.first_warm_delivery
Reward — Удобные тапочки для Таксы
Memory — Помнит первую тёплую поставку
```

First Day visual-language status:

```text
STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v3: PASS as First Day Art/UX Visual Language Pass.
NOT production art. NOT final visual style. NOT shipping UX. NOT final animation polish.
```

Next scope:

```text
D-023 selects First 48 Hours Playable. Source-reconciled integration is mechanically complete but not runtime-Art/user accepted. D-024 exact tile/marker integration and regressions pass; D-029 observability/atomic-runner remediation is implemented and independently no-Godot reviewed PASS. The 32-file canonical evidence root remains HOLD/UNSEALED with no `HASHES.sha256`. Real Steam Godot 4.7.1, Continue runtime scenarios, actual PlayerBoot control ACK, GUI/capture/manifest/seal/promotion and final Art/user review remain not run. The next gate is a new user/coordinator decision and literal bounded real-run ACK naming A/K, final eight hashes, pinned evidence tree and exact writer/scope.
```

Current-versus-later boundary:

```text
No R48-05B/object transfer, rooms, onboarding or background/minimize/performance work now. Ambient Labrador walking reuses existing start/walk/stop/turn rows as presentation transitions only and has zero gameplay/save/progression authority. D-024 adds no mechanic: pan is pending navigation/presentation contract; outside-field meadow and the right reserve are non-buildable and forbidden to dog idle/H activity. The Fence Boundary Marker is static decoration only, requires a separate positive-coordinate mirrored Art export and may not use runtime negative scale.
```

Visual R&D boundary:

```text
Sheet A/B are PREVIEW_RESEARCH_ONLY — not production art, final style, asset approval, room runtime or a hidden successor slice.
Dog production animation bindings remain unapproved; debug clips and proposed vocabularies are coverage evidence only.
```

Source docs:

```text
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__First_Day_MVP_Lock_And_Next_Scope_Decision_v1.md
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__First_Week_Direction_v1.md
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Art_UX_Review__First_Day_MVP_v3.md
```

---

## Development / Codex status summary

Godot prototype and dev tooling exist.

Implemented / available:

- Godot Steam/Desktop project under `steam/`.
- Desktop window / companion strip tech demos.
- Vertical Slice prototype.
- Dog rig spikes and dog runtime integration slice.
- Godot State Connector.
- Godot Control Connector.
- Workbench Runtime Capture Harness.
- Shelter MCP source under `mcp/`; D-021 local STDIO domain-adapter migration complete.
- D-026 source-derived context bridge accepted, implemented and independently reviewed `PASS`; daily-default rollout active.
- First Day MVP runtime proof.
- First Day visible review capture packs v1/v2/v3.
- First Day Art/UX visual-language pass v1 implemented and accepted as prototype pass.

Latest detailed dev log:

```text
docs/repo/status/CODEX_STATUS.md
```

Compressed dev entry:

```text
docs/drive/Shelter/04_DEVELOPMENT/CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md
```

---

## Зафиксированные продуктовые решения — summary

Full source:

```text
docs/drive/Shelter/00_START_HERE/02_DECISIONS.md
```

Important active decisions:

- D-001 — Google Drive / local mirror as knowledge base.
- D-002 — GitHub/repo docs as development source of truth.
- D-003 — serious sessions start from project index / local docs.
- D-004 — Codex requires `AGENTS.md`.
- D-005 — kind, calm, ethical Shelter tone.
- D-006 — three-product family.
- D-007 — Steam/Desktop engine: Godot.
- D-008 — Browser Extension core loop.
- D-009 — Steam/Desktop horizontal dog production co-op.
- D-010 — innate vs acquired/equipment dog traits.
- D-011 — Cozy Modular Diorama visual candidate.
- D-012 — Browser Farm and Steam Co-op as two parts of one world; MVP narrative-only link.
- D-013 — Steam resource trips replace visible crop farming.
- D-014 — role boundaries and working roadmaps.
- D-015 — cross-role collaboration via RFC docs.
- D-016 — Codex implementation boundaries for Steam Vertical Slice.
- D-017 — significant Codex tasks through `04_DEVELOPMENT/` brief files.
- D-018 — gameplay proof / visual proof split; no standalone simulator.
- D-019 — Game Design Systems Workbench over live Godot runtime.
- D-020 — Project Philosophy / Shelter Constitution.
- D-021 — local ChatGPT Work/Codex checkout and Shelter MCP boundary.
- D-022 — complete same-chain Day 2 Warm Food Delivery executable scope lock.
- D-023 — First Day + Day 2 player journey scope lock.
- D-024 — responsive tiled meadow, independent gameplay field/viewport and right-reserve contract.
- D-025 — macOS-first development sequence and two-path visual-capture authority.
- D-026 — MCP-first source-derived context bridge; accepted, implemented, independently reviewed `PASS`, daily-default rollout active.
- D-027 — revalidate historical blockers and require explicit user approval before material workaround routes.
- D-028 — use only the repo-documented Steam-managed Godot installation/version.
- D-029 — observable Godot subprocess lifecycle, project-owned graceful quit, no hard kill or diagnostic suppression; exact D-024 remediation implemented and independently no-Godot reviewed `PASS`.

---

## Текущие ограничения

- Project Philosophy: Shelter делает богаче жизнь, а не склад.
- Shelter — производственный кооператив, в котором живут собаки.
- Производство — ядро; жизнь собак делает это ядро живым.
- Любая система должна сначала объяснять, как делает жизнь кооператива интереснее, и только потом — какие игровые бонусы создаёт.
- Никаких боёв, PvP, боссов, монстров, арен, paid gacha, агрессивной соревновательности.
- Благотворительность — добровольная, прозрачная, этически совместимая.
- Steam/Desktop не должен превращаться в Browser Extension: no search bar, sponsorship/ad block, rewarded ads or Chrome new-tab UX.
- Steam/Desktop First Day lock не означает production art / shipping UX / final balance / Steam release readiness.

---

## Не читать по умолчанию

Use `SUPERSEDED_MAP.md` before historical digging.

Use `EVIDENCE_READ_POLICY.md` before reading capture packs, old review packs, archive docs or completed briefs.

Use `../06_SESSIONS_AND_HANDOFFS/HANDOFF_INDEX.md` before reading old handoff history.

Do not read by default:

- old capture PNG folders;
- First Day visible review v1/v2 when v3 is enough;
- old Vertical Slice Art QA capture packs;
- old completed Codex briefs;
- old handoff history except latest relevant one;
- superseded standalone simulator brief;
- long historical sections of `CODEX_STATUS.md`.

---

## Следующий лучший шаг

Workflow / Codex:

```text
D-021 local Work/Codex migration is complete. D-029/D-024 observability and atomic-runner remediation is implemented and independently no-Godot reviewed `PASS` (`P0=0 / P1=0 / P2=0`); evidence remains `CAPTURE_BLOCKED / HOLD / UNSEALED`. Contract A is `4f956a077d0a93575ef7b518fd0aa9fb409392a08fd4a48190364795bc9b5cbf`; current brief SHA K is `ccb81f8a7f881ad078dad54bcd811dad2616aa36f843b2bee0ca67c2487d26ed`. PM sync activates nothing. Wait for a new user/coordinator decision and literal bounded real-run ACK naming A/K, final eight hashes, pinned 32-file tree and exact writer/scope.
```

Current MCP note:

```text
D-026 accepted, implemented and independently reviewed PASS: MCP-first source-derived routine bootstrap is active when health=current.
The prior two P1 and two P2 findings are closed with no new P0/P1/P2 or compatibility regressions. Static current-fact mirrors/fingerprints and the global startup gate are removed; knowledge failure is capability-local.
Unit/race/vet/build, root+nested STDIO, Codex MCP list/get and non-interactive one-call smoke pass.
Direct source reads remain authority/exact fallback for unavailable/non-current MCP, fallback, omission/truncation, exact brief/ADR/normative contract, conflict/parser failure and source editing.
Non-blocking residuals: first remote CI observation; the accepted no-generic-semantic-detector boundary; honest fallback/omissions when a 4 KiB budget cannot carry the requested context.
Next project step: user/coordinator decision and new literal bounded real-run ACK under D-024 §0H. Real runtime/control/capture remains not run; CA stays real/unresolved/not allowlisted and any recurrence is rc73/STOP before capture/seal.
```

Product / Game Design:

```text
D-022 implemented and accepted; R-29 closed / PASS. R48-05A source-reconciled runtime is technical/mechanical PASS. D-029/D-024 remediation is implemented and independently no-Godot reviewed PASS; capture remains BLOCKED/HOLD/UNSEALED and final runtime Art/user acceptance remains pending. The only next gate is a new user/coordinator decision and literal bounded real-run ACK; no automatic run follows docs sync. Windows validation is deferred to a separate pre-release wave and is not current work. R48-05B, rooms, onboarding and background work stay later.
```

Completed/accepted and current prepared Codex briefs:

```text
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Playable_Main_Scene_And_Launch_Surfaces_v1.md
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Player_Save_Store_Schema_And_Recovery_v1.md
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Runtime_Safe_Checkpoints_And_Continue_v1.md
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Playable_World_And_First_Living_Dog_v1.md
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Accepted_Art_Source_And_Labrador_H_Runtime_Integration_v1.md
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__D024_Responsive_Meadow_Marker_And_Player_Presentation_Cleanup_v1.md — D029/D024 REMEDIATION IMPLEMENTED / INDEPENDENT NO-GODOT REVIEW PASS / P0=0 P1=0 P2=0 / CAPTURE BLOCKED / EVIDENCE HOLD / UNSEALED — Contract A 4f956a… / brief K ccb81f8a… / new literal bounded real-run ACK required
docs/drive/Shelter/04_DEVELOPMENT/SHELTER_WORKFLOW__Codex_Brief__Source_Derived_MCP_Context_Bridge_v1.md — ACCEPTED / IMPLEMENTED / INDEPENDENT REVIEW PASS / DAILY DEFAULT ACTIVE
```

Required reasoning level:

```text
очень высокий
```

Documentation / PM:

```text
Keep BOOTSTRAP_CONTEXT, SUPERSEDED_MAP, STEAM_DESKTOP__CURRENT_CONTEXT and CODEX__CURRENT_IMPLEMENTATION_CONTEXT updated after major decisions, reviews and dev tasks.
```

---

## Changelog

### 2026-07-16 — D-029/D-024 remediation independently reviewed PASS / capture HOLD

- Recorded the exact eight-file observability, graceful-stop and atomic-runner remediation as implemented and independently no-Godot reviewed `PASS` with `P0=0 / P1=0 / P2=0`.
- Advanced authority to unchanged Contract A plus whole brief SHA K `ccb81f8a…`; canonical evidence remains 32 files, no seal, exact tree `4ca49b1d…`.
- Kept real Steam Godot/runtime/control/capture/manifest/seal/promotion not run, CA real/unresolved/not allowlisted and the next gate limited to a new user/coordinator decision plus literal bounded real-run ACK. This PM sync activates nothing.

### 2026-07-15 — D-024 authority-tool correction PASS / capture ACK pending

- Recorded immutable Contract A, final Phase 2 brief SHA C and corrected validator/runner V/R as the current authority/result ledger; historical mutable whole-file pins remain provenance only.
- Replaced stale active compliance-edit/capture-resume wording with `TOOL_CORRECTION_PASS / CAPTURE_REACTIVATION_PENDING_COORDINATOR_ACK / EVIDENCE_HOLD / UNSEALED`.
- Kept the 31-file evidence root untouched and made the sole next step a literal ACK naming A/C, followed by one existing-runner macOS capture, seal and Art/user review.

### 2026-07-15 — D-026 final reviewer PASS / daily default active

- Recorded final independent `PASS`: the prior two P1 and two P2 findings are closed and no new P0/P1/P2 or compatibility regressions were found.
- Activated healthy `shelter_context_bundle` as the routine default; direct source reads remain authority and exact fallback, not the routine path.
- Returned the current next step to the already-governed D-024 macOS self-capture/seal/Art-user review wave and retained first remote CI plus the accepted semantic/4 KiB fallback boundaries as non-blocking residuals.

### 2026-07-15 — D-026 remediation complete locally / re-review pending

- Recorded all four reviewer findings as fixed locally and the full local/client validation matrix as PASS.
- Replaced active fix/resolve wording with the sole next step: independent re-review of the complete remediation result.
- Kept final acceptance/daily-default rollout pending and direct source fallback active until reviewer PASS.

### 2026-07-15 — D-026 implementation present / independent review BLOCKED

- Reconciled Current Memory with the implemented source-derived bridge and passing happy-path local gates.
- Recorded the blocking two P1 and two P2 reviewer findings; final acceptance and daily-default rollout remain pending remediation/re-review.
- Removed obsolete static-catalog/global-startup/pre-implementation claims and kept direct source fallback active.

### 2026-07-15 — D-026 accepted / MCP bridge repair brief executable

- Recorded MCP-first source-derived routine bootstrap as an accepted clarification of D-021.
- Marked current knowledge startup red/non-current due static-catalog drift and global startup coupling; direct source reads remain active fallback.
- Added the separate executable MCP bridge brief without changing Steam/runtime/gameplay/art/capture status.

### 2026-07-14 — D-025 macOS-only sequence / D-024 self-capture gate

- Removed Windows from current implementation, QA, evidence, WARN, blocker and acceptance queues; a separate pre-release activation is required later.
- Accepted the D-024 mechanical handback as `MECHANICAL_PASS_CANDIDATE / UNSEALED` and reactivated the same sole writer only for bounded capture completion.
- Replaced universal external desktop capture with the existing Godot self-capture path; macOS Screenshot UI / Computer Use remains allowed only for desktop/native-window context.
- Activated a one-writer capture-only RESUME: remove/skip the forbidden legacy desktop capture and Windows manifest fields, then use the existing Godot self-capture in a normal GUI-capable macOS session. The AppKit/HIServices pre-Godot abort is an environment limitation, not a D-024 runtime blocker.

### 2026-07-14 — D-024 Technical signed / one-writer runtime activation

- Accepted the exact Technical topology, including additive 43+43 corpus, 3840 vertical-fit cap, passthrough/input precedence and KEY_H Hide/Show resolution.
- Activated the correction brief for the sole writer `019f5ce4-e63c-7d33-a586-d2d3031c8610`.
- Kept final runtime Art/user acceptance and all later scopes open. The former Windows-evidence clause is superseded by D-025.

### 2026-07-14 — D-024 source accepted / correction brief prepared

- Rehashed and visually read the 51-file Art amendment: ledger 50/50 and QA 48/48 PASS.
- Accepted exact meadow/marker source only for a bounded runtime trial; kept 3840 vertical fit and final runtime Art/user verdicts open.
- Prepared a separate non-executable responsive/player-presentation correction brief; Technical exact-file preflight is next.

### 2026-07-14 — D-024 owner gates signed / Art source resumed

- Closed exact Game Design and Technical readbacks and reconciled `offscreen_left=-160` as the hidden D-013 absence sentinel only.
- Issued a separate PM `ART_RESUME` to the retained Art thread under fixed `[0,1740]`, tiled-meadow, marker and responsive-QA inputs.
- Kept source acceptance, runtime/Codex work and player-facing Art acceptance blocked behind later gates.

### 2026-07-14 — D-024 responsive meadow / field / viewport authority

- Accepted the shown Labrador/building/meadow direction without a broad pixel loop.
- Replaced unique full-width meadow with seam-safe horizontal tiling and separated gameplay/buildable/viewport bounds.
- Required pan when the field is wider, about 15% empty right reserve at every zoom and a static positive-scale mirrored Fence Boundary Marker.
- Kept the additive Art amendment paused until GD + Technical readbacks and a later explicit PM resume.

### 2026-07-13 — current base graphics / later dog-life scope lock

- Made canonical base-visual reconciliation with existing mechanics the only current content wave.
- Allowed the approved Mill solely as static decoration; kept Labrador first and Dachshund/cart non-critical.
- Fixed the sequence from Art reconciliation acceptance through source work and a separate Codex brief to runtime Art/user review.
- Prohibited a v6 patch loop and kept R48-05B, rooms, onboarding, background work and the broad dog-life catalogue later.

### 2026-07-13 — R48-05A v5 local Technical PASS / overall current look rejected

- Exact derived Packing mask passes local scale/contact/state-envelope and positive/negative overlap gates without source/runtime authority changes.
- Independent v5 evidence review remains pending; Codex did not grant runtime Art PASS or user acceptance.
- Direct owner verdict sets overall player-facing visual coherence to `CHANGES_REQUIRED / USER_OWNER_REJECTED_CURRENT_LOOK`.
- Next is read-only Art comparison against earlier accepted dog/building/meadow references, followed by a new Art-owned brief sequence; no v6 or reconciliation mutation is authorized.

### 2026-07-13 — R48-05A activated

- Accepted the SOURCE-READY world/Labrador package and Packing placeholder boundary.
- Recorded exact Technical binding/provenance/file/test authority.
- Changed only bounded no-transfer R48-05A to accepted/executable; runtime Art PASS and parent/full transfer closure remain open.

### 2026-07-12 — R48-05A/05B convergence

- Accepted the no-transfer visible foundation first and one named transfer later.
- Authorized source-only Art production while keeping R48-05A runtime blocked.

### 2026-07-12 — R48-02B completed / PASS

- Implemented and verified exact First Day checkpoint resume, autosave acknowledgement, restart/kill recovery and all seventeen safe cursors.
- Preserved exact `3 + 2`, reserve provenance and no-offline semantics.
- Kept organic Continue → Day 2 transition in R48-03.

### 2026-07-12 — D-023 / R48-00 accepted

- Accepted user choices A/A/A and selected the session-based First Day + Day 2 player journey.
- Activated R48-01A/R48-02A brief preflight while keeping code blocked until technical acceptance and write ownership.

### 2026-07-12 — R48-01A completed / R48-02A current

- Ordinary F5, `play.sh` and macOS export now enter one clean PlayerBoot route.
- `dev.sh` now separates bounded development workflows from the player route.
- Advanced current implementation to accepted ADR-0003/R48-02A; Continue remains a later R48-02B gate.

### 2026-07-12 — R48-02A completed / R48-02B brief next

- Recorded the strict player-profile envelope/store/recovery foundation as PASS.
- Preserved gameplay authority and no-offline semantics; no envelope is playable yet.
- Advanced Current Memory only to bounded R48-02B brief preparation.
- Preserved Sheet A/B as PREVIEW_RESEARCH_ONLY evidence rather than runtime source.

### 2026-07-12 — R-29 closed / Day 2 accepted

- Recorded canonical Day 2 completion and Producer closeout at prototype/product-language/runtime-evidence level.
- Removed Day 2 implementation as the current task and intentionally left the next executable scope unselected.
- Kept world/room/dog work as non-production R&D rather than a hidden successor slice.

### 2026-07-12 — world/room preview R&D closed

- Recorded Sheet A and Sheet B formal Art `WARN` outcomes with no root contract failure.
- Kept production terrain, reusable room shell, dog-family contact, runtime, taxonomy and final style as separate future gates.

### 2026-07-11 — D-022 Day 2 executable scope accepted

- Replaced the readiness question with the accepted complete same-chain Day 2 implementation/evidence task.
- Normalized the canonical brief path and kept production art/platform readiness outside this slice.

### 2026-07-10 — ChatGPT Work migration wave

- Recorded D-021 as current process truth: direct local checkout for Work/Codex and local domain-specific MCP.
- Completed the dedicated technical migration and activated local STDIO validation.
- Preserved the existing Steam product focus and Day 2 direction.

### 2026-07-09 — current status anti-bloat boundary

- Added explicit boundary that `01_CURRENT_STATUS.md` is not a full document index.
- Clarified that routing should live in `BOOTSTRAP_CONTEXT.md`, current-context docs and MCP knowledge tools.
- Clarified that history/evidence should be reached through `SUPERSEDED_MAP.md`, `EVIDENCE_READ_POLICY.md` and `HANDOFF_INDEX.md`.

### 2026-07-09 — knowledge polish roadmap

- Added `KNOWLEDGE_BASE_POLISH_ROADMAP.md` as the short roadmap for remaining fresh-session entry friction.
- Codex next: MCP decision digest / project dashboard tools.
- PM next: current-context template standardization and `01_CURRENT_STATUS.md` anti-bloat guardrails.

### 2026-07-07 — role current contexts

- Added `GAME_DESIGN__CURRENT_CONTEXT.md` and `ART_DIRECTION__CURRENT_CONTEXT.md` to the compressed context layer.
- These role current contexts reduce the need to read old roadmaps, capture packs and handoff for Game Design / Art Direction sessions.

### 2026-07-07 — handoff index

- Added `06_SESSIONS_AND_HANDOFFS/HANDOFF_INDEX.md` as the current entry point before reading old handoff history.
- Reinforced that handoff is History and should not be read on bootstrap by default.

### 2026-07-07 — evidence read policy

- Added `EVIDENCE_READ_POLICY.md` as central policy for capture packs, old review packs, archive docs and completed briefs.
- Clarified that evidence/history should not be read during bootstrap.
- Avoided editing blocked historical pack files directly.

### 2026-07-07 — open questions refresh

- Updated `03_OPEN_QUESTIONS.md` into an active living register.
- Moved obsolete first-product, Steam engine and Godot technical-spike questions to resolved traceability.
- Reframed current active questions around First Week / Day 2, documentation governance, Browser/Mobile/Shared Platform and Charity/Legal/Trust.

### 2026-07-07 — documentation governance update

- Added `05_DOCUMENTATION_GOVERNANCE.md` and `CODEX_CURRENT_STATUS.md` to the compressed context layer.
- Recorded Current Memory / Knowledge / History as the default reading model.
- Clarified that History is not read by default.

### 2026-07-07 — documentation compression / current status refresh

- Updated current status from old project-setup phase to actual Steam/Desktop First Day / First Week state.
- Added bootstrap/current-context layer as default entry route.
- Added evidence/history do-not-read-by-default policy.
- Pointed new sessions to current Steam and Codex context docs.

### 2026-07-02 — Shelter MCP update

- Shelter MCP documented as a local domain-specific adapter.
