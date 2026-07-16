# CODEX — Current Implementation Context

Дата создания: 2026-07-07
Обновлено: 2026-07-16
Статус: active current-summary
Владелец: Codex / Project Manager
Назначение: короткий актуальный dev/Codex вход без перечитывания всего `CODEX_STATUS.md` и старых brief-файлов.

---

## 0. Read policy

Codex / dev-oriented sessions read this after:

```text
PROJECTS_RULES.md
AGENTS.md
README.md
steam/AGENTS.md
steam/README.md
docs/repo/adr/README.md
docs/repo/status/CODEX_CURRENT_STATUS.md
```

Then read relevant accepted ADRs and the active task brief.

This file is a compressed implementation context map. It does not replace implementation briefs, ADRs, `steam/README.md` or detailed history in `CODEX_STATUS.md`.

Important status split:

```text
docs/repo/status/CODEX_CURRENT_STATUS.md — current dev status, read on bootstrap.
docs/repo/status/CODEX_STATUS.md — detailed chronological history, do not read in full by default.
```

---

## Standard navigation

Current truth:

```text
Godot runtime is source of truth.
Local source docs are project/document authority and exact fallback.
Under D-026, a healthy source-derived Shelter MCP bundle is the active default routine bootstrap/context-routing path.
The D-026 bridge and four-finding remediation are implemented and independently reviewed `PASS`; direct source remains permanent authority/exact fallback under the documented conditions.
Shelter MCP remains a local domain-specific runtime/inspection adapter; knowledge failure must not disable runtime/capture/control.
GitHub Actions CI validates the MCP without starting Godot/runtime.
First Day MVP is locked at prototype/product-language level.
D-022 Day 2 same-chain Warm Food Delivery is implemented and verified at prototype/product-language/runtime-evidence level.
D-029/D-024 observability, graceful-stop and atomic-runner remediation is implemented and independently no-Godot reviewed PASS with P0=0/P1=0/P2=0.
D-024 current status: D029_D024_OBSERVABILITY_ATOMIC_RUNNER_REMEDIATION_IMPLEMENTED / INDEPENDENT_NO_GODOT_REVIEW_PASS / CAPTURE_BLOCKED / EVIDENCE_HOLD / UNSEALED / NEW USER_COORDINATOR DECISION AND LITERAL BOUNDED REAL-RUN ACK REQUIRED.
```

Active roadmap / current task:

```text
Product roadmap: STEAM_DESKTOP__First_48_Hours_Playable_Roadmap_v1.md
Current product task: source-reconciled R48-05A integration is local Technical/Mechanical PASS; independent runtime Art and explicit user review are pending
Current D-024 gate: Contract A 4f956a… / brief K ccb81f8a… / exact final eight implementation hashes / pinned 32-file tree 4ca49b1d…; no writer is active and PM sync authorizes no real run
Completed workflow/MCP task: ChatGPT Work And Local MCP Migration v1
Completed workflow/MCP task: Source-Derived MCP Context Bridge v1 — independent review PASS / daily default active
```

Current decisions:

```text
D-007, D-016, D-017, D-018, D-019, D-020, D-021, D-022, D-023, D-024, D-025, D-026, D-027, D-028, D-029
```

Active open questions:

```text
OQ-Steam-003, OQ-Docs-001
```

Read next by task:

```text
Product implementation: GAME_DESIGN__CURRENT_CONTEXT.md + active Codex brief
D-024 capture completion: STEAM_DESKTOP__Codex_Brief__D024_Responsive_Meadow_Marker_And_Player_Presentation_Cleanup_v1.md
MCP implementation: SHELTER_WORKFLOW__Codex_Brief__Source_Derived_MCP_Context_Bridge_v1.md
Architecture: docs/repo/adr/README.md
Detailed history: CODEX_STATUS.md latest entry only by default
```

Do not read by default:

```text
old completed briefs, full CODEX_STATUS.md, old runtime captures, superseded simulator docs
```

Next best step:

```text
Wait for a new user/coordinator decision. Only a new literal bounded real-run ACK naming A/K, all final eight hashes, the pinned 32-file evidence tree and exact writer/scope may authorize Steam Godot/runtime/control/capture. This PM sync activates nothing; no later MCP slice is assigned, and R48-05B/parent closure remain out of scope.
```

---

## 1. Current repo / tooling shape

Repository root:

```text
/Users/barsulka/GolandProjects/shelter/shelter
```

Steam/Godot project:

```text
steam/
```

Local Work/Codex source access:

```text
/Users/barsulka/GolandProjects/shelter/shelter
```

Shelter MCP source lives under `mcp/` in the monorepo. Its accepted role is a local domain-specific adapter for whitelisted dev commands, Godot runtime/capture inspection and control, plus D-026 source-derived bounded context routing. A healthy bundle is the routine bootstrap default; local docs remain authority/exact fallback. It is not a generic shell.

```text
Local setup: .codex/config.toml + mcp/run.sh over STDIO.
```

---

## 2. Core technical decisions

Read ADR index before technical work:

```text
docs/repo/adr/README.md
```

Active ADRs:

```text
0001 — Use Godot For Steam/Desktop
0002 — Game State As Source Of Truth
0003 — Player Profile Persistence Boundary And Recovery
0004 — Godot Child Observability And Graceful Termination
```

Key rule:

```text
Godot runtime is the source of truth.
Workbench observes and controls accepted dev surfaces; it does not simulate Shelter independently.
```

Do not revive standalone simulator direction. It was superseded by Godot State Connector / Workbench-over-live-Godot decisions.

---

## 3. Current product implementation state

Current Steam/Desktop product state:

```text
First Day MVP locked at prototype/product-language level.
D-022 complete same-chain Day 2 variation is implemented with green runtime/native evidence.
R48-01A clean PlayerBoot entry, R48-02A profile-store foundation, R48-02B First Day safe-checkpoint Continue and R48-03 organic persisted Day 2 return are implemented/PASS.
The strict player journey spans 33 restart-safe cursors through Quiet Cooperative. Source-reconciled R48-05A is local Technical/Mechanical PASS: runtime width `1740`, source width `2992`, exact `1740/2992` conversion, 16 static layers `00–09,11–16`, one Bicycle slot, 24 Labrador identity composites and exact `41 PNG + 41` imports. One positive-scale `0.24` Labrador lane provides exact A–H, both station sides/turns and derived/non-persisted H with zero mechanics/transfer/output. D-024 exact `43 PNG + 43 .import` responsive presentation passes, and the D-029/D-024 exact eight-file observability/atomic-runner remediation is implemented plus independently no-Godot reviewed PASS (`P0=0 / P1=0 / P2=0`). Contract A remains `4f956a077d0a93575ef7b518fd0aa9fb409392a08fd4a48190364795bc9b5cbf`, current brief SHA K is `ccb81f8a7f881ad078dad54bcd811dad2616aa36f843b2bee0ca67c2487d26ed`, while the 32-file evidence root remains HOLD/UNSEALED. Real Steam Godot/runtime/control/capture and independent Art/user acceptance are pending a new literal bounded real-run ACK; Codex granted no runtime Art PASS. v1-v5/source and the evidence pack are immutable, R48-05B stays separate, and R48-04A remains deferred.
```

Current visual-language evidence:

```text
STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v3: PASS as prototype First Day Art/UX Visual Language Pass.
```

Caveat:

```text
Not production art. Not final visual style. Not shipping UX. Not final animation polish.
```

Product context source:

```text
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__CURRENT_CONTEXT.md
```

---

## 4. Implemented dev capabilities

Implemented across completed Codex tasks:

- Godot 4.x Steam/Desktop project skeleton.
- Desktop window / companion strip tech demos.
- Companion field demo.
- Dog rig spike v0..v3.
- Dog runtime integration slice.
- Steam Vertical Slice prototype.
- Visual launcher.
- Semantic asset import for prototype placeholders.
- Art QA capture packs.
- Godot State Connector v0.
- Godot Control Connector v0.
- Viewport screenshot / frame capture endpoints.
- Game Systems Runtime Foundation v1.
- Workbench Runtime Capture Harness v0.
- Dispatch confirmation capture path.
- Shelter MCP whitelist for dispatch scenario/control action.
- First Day MVP runtime polish.
- First Day visible review capture pack v1/v2/v3.
- First Day Art/UX visual-language pass v1.
- Day 2 deterministic continuation fixture and full second warm-delivery scenario.
- Day 2 exact order/chain/event proof plus six native 1x return-to-quiet-end moments.
- Source-reconciled R48-05A world and Labrador runtime: exact 41-file source-equal asset topology, 41 verified Godot sidecars, no layer 10, one Bicycle, one Labrador render lane and exact A–H derived presentation.
- Source/runtime validator, both animation-pipeline skill validators and immutable evidence with actual macOS desktop, native `2992x224`, `216/144/96`, checker/black, First Day/Day 2/Quiet Cooperative, both turns/sides and H cancellation/recovery trace.
- D-024 responsive-presentation mechanical integration: seam-safe tiled meadow, independent field/viewport, bounded drag pan, right reserve, authored-positive boundary marker and exact `43 PNG + 43 .import` regression PASS.
- D-024 raw-bytes Contract A plus current whole brief K `ccb81f8a7f881ad078dad54bcd811dad2616aa36f843b2bee0ca67c2487d26ed`.
- D-029/D-024 narrow Steam-Godot observer, direct append-only raw stdout/stderr, project-owned graceful quit/control ACK, bounded exact-PID SIGTERM fallback, no-hard-kill/no-CA-allowlist policy, fail-loud expected-persistence seam and atomic staged runner. Independent no-Godot re-review reproduced authority-only/normal validator PASS, observer `22/22`, shell syntax and exact eight-path/pin/`17 -> 18` gates with `P0=0 / P1=0 / P2=0`.
- Shelter MCP repo/document tooling v1/v2.
- Shelter MCP source-derived context bridge: parse-on-request snapshots, exact current excerpts, file/block hashes, explicit 4 KiB minimum, deterministic 24 KiB default / 64 KiB hard-cap bundle, fixed-point bounded error envelopes and capability-local knowledge errors.
- Fixed-keyword implementation/decision/handoff/context-routing priority without AI/free search/arbitrary paths, plus fail-closed legacy decision-kind mapping to `product|technical|process|documentation|ethics`.
- Shelter MCP Knowledge API v2 legacy tools for decisions, open questions, roadmaps, latest handoff and task context, all projected from the same current source snapshot.
- Shelter MCP GitHub Actions CI: unit/race tests, vet, build and launcher syntax check on every push and pull request.

Global startup has no knowledge dependency. Static current-fact mirrors/fingerprints are removed; each knowledge request validates a fresh source snapshot. Source documents always win and remain exact fallback.

Current short dev status:

```text
docs/repo/status/CODEX_CURRENT_STATUS.md
```

Detailed chronological dev history:

```text
docs/repo/status/CODEX_STATUS.md
```

Use current status first. Do not read the whole history log by default.

---

## 5. Current important commands

Common Steam commands from `steam/`:

```sh
./launch.sh
./launch.sh --exit
tools/check-godot.sh
tools/dev-vertical-slice.sh smoke
tools/dev-vertical-slice.sh capture-smoke
tools/dev-vertical-slice.sh connector-control-smoke
tools/dev-vertical-slice.sh first-day-art-ux-capture
tools/dev-vertical-slice.sh day-2-visible-capture
```

Workbench/capture commands and options are documented in:

```text
steam/README.md
docs/repo/dev/godot-state-connector.md
docs/repo/dev/steam-vertical-slice-prototype.md
```

Do not run broad or new dev controls unless they are explicitly whitelisted/accepted by a brief or ADR.

---

## 6. Current proof / artifact location

Current R48-05A Labrador runtime evidence:

```text
docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_R48_05A_LABRADOR_RUNTIME_CAPTURE_v1/
docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_R48_05A_LABRADOR_RUNTIME_CAPTURE_v2/
docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_R48_05A_LABRADOR_RUNTIME_CAPTURE_v3/
docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_R48_05A_LABRADOR_RUNTIME_CAPTURE_v4/
docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_R48_05A_LABRADOR_RUNTIME_CAPTURE_v5/
docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_R48_05A_SOURCE_RECONCILED_RUNTIME_CAPTURE_v1/
```

v1-v5 and their owner reviews are immutable historical evidence. The source-reconciled pack records the new local Technical/Mechanical PASS and must not be read as runtime Art PASS or overall user acceptance. Its existing resource/cue primitives and `Show UI` remain an explicit runtime Art/user-review risk outside this brief. One early H-turn frame has an evidence-local incomplete redraw; the separate full redraw turn captures and subsequent native frame are the mechanical reference.

Current D-024 evidence root:

```text
docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_R48_05A_D024_RESPONSIVE_PRESENTATION_RUNTIME_CAPTURE_v1/
```

It remains exactly 32 files, no `HASHES.sha256`, tree digest
`4ca49b1d9cd0616d434eb534464087c75cebcd4972122356ad9197ec59cdd378`
and `EVIDENCE_HOLD / UNSEALED`. PM sync activates nothing. Do not launch Godot,
the runner or mutate evidence before a new user/coordinator decision and
literal bounded real-run ACK naming A/K, final eight hashes, pinned evidence
and exact writer/scope.

Latest First Day visual proof pack:

```text
docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v3/
```

Important files:

```text
README.md
CAPTURE_MANIFEST_v3.md
captures/state/manifest.json
captures/state/final_state.json
captures/state/events.jsonl
captures/state/stress_signals.jsonl
captures/screenshots/*.png
captures/video/first_day_mvp_visible_loop_frames_1x/*.png
captures/video/postcard_slippers_moment_1x/*.png
```

Read pack docs and state proof first. Do not load PNG/frame directories unless visual inspection is required.

Current Day 2 local evidence (ignored, not committed):

```text
steam/.runtime/workbench_capture_runs/day2_return_and_second_delivery_v1/
steam/.runtime/workbench_capture_runs/20260711_day2_state_evidence_v1/
steam/.runtime/workbench_capture_runs/20260711_first_day_dispatch_regression_after_day2_v1/
```

The Day 2 pack contains six native 1x screenshots, a normal-speed frame sequence
and exact machine-readable fixture/order/chain/task/event assertions. It is
prototype/product-language evidence, not production art, final animation,
shipping UX or desktop-platform acceptance.

The First Day regression directory also contains a fresh post-correction
headless final state and proof confirming full completion, First Day order ids
and `player_confirmed_delivery -> DeliveryTask -> delivery_complete` causality.

---

## 7. Completed briefs are historical by default

Old brief files in:

```text
docs/drive/Shelter/04_DEVELOPMENT/
```

are historical once implemented unless explicitly marked as active/prepared.

For current implementation planning, use:

1. Product/design current context.
2. Latest accepted product/design doc.
3. New task brief.
4. ADRs.
5. Latest `CODEX_STATUS.md` top entry.

Do not reconstruct current state by reading every old brief.

---

## 8. Known limitations / recurring cautions

- Windows behavior remains broadly less tested than macOS visible checks.
- Prototype visual-language evidence is not production art.
- 100x Workbench capture validates state/causality, not player feel or visual warmth.
- Generated runtime bundles under `steam/.runtime/` are ignored and should not be committed.
- Capture packs under docs are evidence; they are not default bootstrap context.
- Codex must not change product scope, gameplay contracts, visual direction, charity/monetization claims or ethical boundaries.
- Steam/Desktop must not absorb Browser Extension UX: no Chrome new-tab layout, search bar, sponsorship/ad block, rewarded ads, or extension-specific mechanics in Godot game.
- First GitHub Actions run still needs to confirm hosted-runner/action availability; no runtime smoke belongs in this CI job.
- D-026 is final independent-review `PASS`, daily-default MCP-first routing is active and remaining blockers are none. Direct source remains authority/exact fallback for non-current/truncated output, exact briefs/Accepted ADRs/normative contracts, semantic conflicts/parser failures and source editing; non-blocking residuals are the first remote CI run, the accepted absence of an automatic semantic governance-conflict detector and honest 4 KiB fallback/omissions.
- R48-05A v1-v5/source and the new source-reconciled evidence pack are immutable. The new integration passes local Technical/Mechanical gates only; runtime Art and explicit user review remain pending. Existing resource/cue primitives plus `Show UI` are an explicit review risk, not a Technical failure or resolved prototype claim. One early H-turn frame carries an evidence-local redraw WARN; use the separate full turn frames and subsequent native frame for review.
- D-029/D-024 remediation and independent no-Godot review are PASS with no remaining P0/P1/P2, but capture is inactive. Real Steam Godot 4.7.1, Continue runtime, actual PlayerBoot control ACK, GUI/capture/manifest/seal/promotion remain not run; evidence stays 32 files/HOLD/UNSEALED. CA remains real/unresolved/not allowlisted and recurrence is diagnostic FAIL/rc73/STOP. The next gate is a new user/coordinator decision plus literal bounded real-run ACK, not automatic activation.

---

## 9. Next likely implementation direction

Completed D-026 implementation/review authority:

```text
SHELTER_WORKFLOW__Codex_Brief__Source_Derived_MCP_Context_Bridge_v1.md
```

The task removed manually maintained current-fact memory, added the budgeted source-derived bundle and isolated knowledge failures from runtime/capture/control. Its four-finding remediation is independently reviewed `PASS`, daily-default rollout is active and no later MCP implementation slice is assigned. D-029/D-024 remediation is also independently no-Godot reviewed PASS; the next project gate is a new user/coordinator decision and literal bounded real-run ACK naming A/K, final eight hashes, pinned evidence and exact writer/scope. PM sync activates no run.

Completed previous workflow/tooling slice:

```text
SHELTER_WORKFLOW__Codex_Brief__ChatGPT_Work_And_Local_MCP_Migration_v1.md
```

The task completed local MCP/config/docs boundaries without changing Godot/runtime behavior or product/game/art contracts.

Completed product implementation brief:

```text
STEAM_DESKTOP__Codex_Brief__Day_2_Return_And_Second_Warm_Delivery_v1.md
```

Implemented scope:

- `second_day_after_first_delivery` fixture;
- `second_warm_delivery_after_first_day` Workbench scenario;
- return moment state;
- full second order completion on the existing chain;
- persistence of the previous-session postcard, slippers and memory;
- one Labrador careful-packing cue inside PackTask;
- player-confirmed dispatch, small progress note and post-completion optional question;
- no save/calendar, new systems, production dog pipeline or window/platform changes.

Current handoff boundary:

```text
R-29 and R48-03 are closed/PASS. Source-reconciled R48-05A is Technical/Mechanical PASS, and D-029/D-024 observability/atomic-runner remediation is independently no-Godot reviewed PASS. D-024 evidence remains 32 files/HOLD/UNSEALED and final runtime Art/user review is pending. The only next gate is a new user/coordinator decision and literal bounded real-run ACK naming A/K, final eight hashes, pinned tree and exact writer/scope; PM sync activates nothing. Do not start R48-05B or close parent R48-A/R48-05 from this handoff.
Any production art/animation/world proof or later product slice requires its own accepted brief.
```

Out of scope unless separately accepted:

- full First Week calendar;
- full House of Curiosity research tree;
- new dog recruitment;
- many orders/routes;
- mood/energy penalties;
- daily streaks;
- monetization;
- charity prompts;
- Browser Extension mechanics;
- production art pass;
- Steam platform integration.

Suggested reasoning level for Codex if assigned:

```text
очень высокий
```

---

## 10. Changelog

### 2026-07-16 — D-029/D-024 remediation independently no-Godot reviewed PASS

- Recorded the exact eight-file observer/graceful-stop/atomic-runner result and independent verdict `P0=0 / P1=0 / P2=0`.
- Advanced current authority to unchanged Contract A and brief K `ccb81f8a…`; canonical evidence remains 32 files/no seal/tree `4ca49b1d…`.
- Kept real Godot/runtime/control/capture/manifest/seal/promotion not run, CA real/unresolved/not allowlisted and the next gate limited to a new user/coordinator decision plus literal bounded real-run ACK. PM sync activates nothing.

### 2026-07-15 — D-024 Contract A tool correction PASS / capture ACK pending

- Added final Phase 2 authority/result ledger: Contract A unchanged, brief C pinned, corrected validator/runner V/R and bounded no-GUI matrix PASS.
- Kept capture inactive and the 31-file root on HOLD/UNSEALED with ledger 30/30; no Steam/runtime/evidence action occurred in the PM sync.
- Made literal ACK naming A/C the sole next gate before one existing-runner GUI-capable macOS capture, seal and Art/user review by reserved writer `019f6604-8ac6-7871-85c8-2c858a2240f3`.

### 2026-07-15 — D-026 independent review PASS / daily default active

- Independent re-review reproduced and closed the prior two P1 and two P2 findings with no new P0/P1/P2 or compatibility regression; D-026 has no remaining blocker.
- Activated healthy `shelter_context_bundle` for routine bootstrap/context routing while retaining source docs as authority/exact fallback.
- Kept first remote CI, the accepted semantic-conflict boundary and honest 4 KiB fallback/omissions as non-blocking residuals; restored D-024 macOS self-capture/seal/Art-user review as the current next step.

### 2026-07-15 — D-026 independent-review remediation / local checks PASS / re-review pending

- Added the explicit `4096` input-schema minimum and bounded deterministic malformed-source error envelopes with fixed-point wire byte accounting; `1`/`4095` return no misleading StructuredContent.
- Mapped canonical compound decision kinds into the accepted legacy enum with explicit failure for unknown kinds; D-010 is queryable as Steam/product.
- Added fixed-keyword implementation/decision/handoff/context-routing priority over authored paths/headings and documented the parser-versus-semantic-conflict boundary. Local full matrix passes; independent reviewer PASS/daily-default rollout remain pending.

### 2026-07-15 — D-026 source-derived MCP context bridge / local PASS

- Implemented deterministic parse-on-request source snapshots and `shelter_context_bundle` with exact current excerpts, file/block SHA-256 provenance, `24576` default and `65536` hard cap.
- Migrated all enabled legacy knowledge tools to source-derived projections, removed static current facts/fingerprints and removed the global startup knowledge gate.
- Verified capability-local knowledge failure without touching runtime/gameplay/art/capture; source docs remain authority and exact fallback.

### 2026-07-14 — source-reconciled R48-05A integration / Technical-Mechanical PASS / Art pending

- Imported the exact source-reconciled runtime set: 16 static layers, one standalone Bicycle and 24 Labrador identity composites, for exact `41 PNG + 41` verified imports and no layer 10.
- Integrated `1740` runtime / `2992` source mapping, scale `0.24`, one render lane, exact station roots and selector H route/cadence without gameplay, persistence or transfer changes.
- Passed 64 local validator checks, both hybrid skill validators, full Godot, First Day/Day 2/Quiet Cooperative, profile/checkpoint/33-cursor SIGKILL/save-retry and isolated ordinary `play.sh` with production profile absent.
- Sealed `STEAM_R48_05A_SOURCE_RECONCILED_RUNTIME_CAPTURE_v1/`; runtime Art/user review is pending. Existing resource/cue primitives and `Show UI` are an explicit review risk; one early H-turn capture has an evidence-local redraw WARN while separate turn/native frames are complete.

### 2026-07-13 — R48-05A v5 local Technical PASS / current look rejected

- Added only derived fail-closed Packing D/F/G/contact-held EXIT segmentation of existing `world.fence.front_span`; no source/global-z/scale/root/window/anchor/timing/gameplay/persistence mutation.
- Passed exact state-specific 216/144/96 envelope/margin gates, both-side contact, `8/8` positive and `6/6` negative mask cells with zero forbidden screen/source-alpha overlap, A–G/negative G, both turns, four 1x strips, recovery, legacy negatives and zero transfer.
- Published the 556-file v5 evidence as local Technical PASS; independent evidence review remains pending and Codex did not grant runtime Art PASS.
- Recorded overall player-facing visual coherence as `CHANGES_REQUIRED / USER_OWNER_REJECTED_CURRENT_LOOK`; no prototype-resolved or user-acceptance claim is allowed.
- Next is read-only Art comparison current v5 against earlier accepted dog/building/meadow references, followed by a new Art-owned brief sequence. No v6 or reconciliation mutation is authorized.

### 2026-07-13 — R48-05A v4 correction / Technical BLOCKED / Art pending

- Applied the exact accepted uniform scale `0.24` and station anchors without changing PlayerBoot, root/baseline, z ownership, animation/gameplay timing or transfer semantics.
- Preserved actual `2992x224` full-width bottom-edge evidence, A–G, both locked-root turns, four even 1x strips, cancellation/recovery, `legacy_unbound=3` and zero transfer.
- Idle A passes at `89/59/39 px`, but synthetic Kitchen E `74/49/33 px`, First Day E `76/52/35 px`, and Day 2 G `73/49/32 px` fail the universal `80/52/35 px` thresholds. From-right Packing also retains forbidden torso overlap; bounded registration cannot satisfy both occlusion and ≤4 px contact.
- Published the immutable 450-file v4 pack, ledger `7645796b50db961622aada07b10902d3d4c296206dd61ab2135cf5c09571c658`, and stopped with `STOP_UNSUPPORTED_ACTOR_ENVELOPE`. Runtime Art remains `PENDING_OWNER_REVIEW`; Codex did not grant Art PASS.

### 2026-07-13 — R48-05A v3 correction / Technical BLOCKED / Art pending

- Applied exact scale `0.60`, Kitchen `260.4/157.2/135.6` and Packing `260.4/150.0/127.2`, preserved full-width world, even motion, both turns, A–G, `legacy_unbound=3` and zero transfer.
- Captured the actual `2992x224` bottom-hugging PlayerBoot window and a 450-file v3 pack, but measured native bbox `y=0`: the `225 px` source envelope projects to `232.14 px`, exceeding the locked height by `8.14 px`.
- Returned `STOP_UNSUPPORTED_ACTOR_ENVELOPE` instead of changing PlayerBoot/window, effective scale, horizontal fit or root/baseline. All mechanical/source/Godot/profile/checkpoint/33-cursor/SIGKILL/save-retry checks remain green; v1/v2 are immutable and v3 Art remains `PENDING_OWNER_REVIEW`.

### 2026-07-13 — R48-05A v2 correction / technical PASS / Art pending

- Corrected full-width corridor framing, uniform Labrador scale `0.25 -> 1.0`, 1:1 station-anchor projection, distributed motion and both root-locked physical turns without changing gameplay authority, timing or outputs.
- Published 443-file v2 evidence with declared 216/144/96 resamples measuring `137/92/61 px`, four even-timestamp 1x strips, both sides/turns, cancellation/recovery and desktop transparency proof.
- Passed the full source/binding/Godot/player/profile/checkpoint/33-cursor/SIGKILL/save-failure suite; real profile remained absent. v1 is immutable and v2 remains `PENDING_OWNER_REVIEW`.

### 2026-07-13 — R48-05A implemented / mechanical PASS / Art pending

- Added exact authored world/Labrador imports and one derived/non-persisted A–G visual adapter inside the ordinary PlayerBoot runtime.
- Kept transfer tasks in `legacy_unbound`, preserved all gameplay/persistence/no-touch contracts and passed the 33-cursor restart/SIGKILL/save-failure regression matrix.
- Published persistent native evidence; runtime Art remains a separate owner gate and parent R48-05 remains PARTIAL/WARN until 05B.

### 2026-07-12 — R48-05A source/runtime boundary

- Recorded source-only Art work as next and kept Codex/runtime blocked.
- Split parent closure into bounded 05A PARTIAL/WARN and later 05B transfer PASS.

### 2026-07-12 — game-first brief sequence prepared

- Replaced R48-04A as the next step with owner-gated Playable World + First Living Labrador.
- Prepared separate onboarding, Kitchen and two-visit acceptance briefs.
- Deferred background/minimize/performance work and preserved its unaccepted status.
- No Godot/runtime or asset changes were authorized by this documentation wave.

### 2026-07-12 — R48-03 completed / persisted Day 2 return PASS

- Added fixture-free ordinary return from completed First Day into the accepted Day 2 order and exact full second-delivery checkpoint graph.
- Persisted Quiet Cooperative with immutable Day 2 history and empty active slots; no Day 3, offline progression or repeatable order was added.
- Passed 33-cursor restart/advance, SIGKILL, save-failure Retry, fixture-oracle, profile-store, First Day, full Godot and native D-022 regressions.
- Advanced the next gate to separate R48-04A brief preparation only.

### 2026-07-12 — R48-02B completed / checkpoint resume PASS

- Implemented the exact seventeen-cursor First Day checkpoint/Continue contract after Producer, Game Design and Technical PASS.
- Added restart-safe recovery, durable save acknowledgement, failure rollback/retry and exact three-input/resource-conservation alignment.
- Passed the full cursor/restart/kill/failure matrix plus First Day and Day 2 regressions.
- Kept organic ordinary Continue → Day 2 transition outside this wave in R48-03.

### 2026-07-12 — R48-02A completed / R48-02B brief next

- Added the strict integer-only player-profile store/recovery foundation without PlayerBoot or gameplay wiring.
- Verified restart/SIGKILL recovery, namespace isolation, exact current test-root cleanup and full Godot regression.
- Kept envelopes explicitly non-playable; R48-02B must define `PlayerCheckpointV1`, autosave and Continue before integration.

### 2026-07-12 — R48-01A completed / R48-02A current

- Unified F5, `play.sh` and macOS export through one clean PlayerBoot over the existing Vertical Slice runtime.
- Added bounded `dev.sh` while preserving legacy launch/tooling compatibility.
- Passed player/dev isolation, First Day, connector, Day 2 dev-route, full Godot and real macOS export checks.
- Advanced current work to ADR-0003/R48-02A; durable Continue remains R48-02B.

### 2026-07-12 — R48 entry/save preflight accepted

- Accepted R48-01A as the current implementation wave.
- Accepted ADR-0003 and queued R48-02A after R48-01A under one sequential integrator.
- Kept gameplay checkpoints, Continue wiring and Day 2 transition in their later bounded waves.

### 2026-07-12 — R-29 closeout recorded

- Replaced pending PM/Producer closeout wording with closed / PASS.
- Kept the completed Day 2 brief as baseline evidence and did not invent a successor implementation task.
- Preserved separate future gates for art/animation/world, rooms, save/calendar and platform work.

### 2026-07-11 — D-022 Day 2 implementation/evidence complete

- Implemented the deterministic Day 2 fixture, complete existing-chain second
  delivery, Labrador in-progress care cue and non-reward quiet completion.
- Added exact live state/event assertions and six native 1x review moments; full
  First Day dispatch and runtime/connector regressions remain green.
- Kept `.runtime` evidence ignored and left save/calendar, production art/rig,
  window/platform, MCP and CI implementation out of scope.

### 2026-07-11 — D-022 Day 2 brief activated

- Replaced the old candidate filename/readiness wording with the accepted canonical Day 2 brief.
- Made same-chain completion mandatory and kept production art/platform work out of scope.

### 2026-07-11 — Shelter MCP GitHub Actions CI

- Added a least-privilege MCP CI workflow with no path filters, so source-only knowledge catalog drift is covered.
- The workflow reads Go version from `mcp/go.mod` and does not start Godot/runtime or MCP control operations.

### 2026-07-10 — ChatGPT Work and local MCP migration context

- Made direct local checkout access the current Work/Codex path.
- Reclassified `mcp/` as an optional local domain-specific adapter under D-021.
- Completed the dedicated workflow migration brief without changing the Day 2 product direction.
- Corrective audit closed content-drift and non-interactive approval gaps without touching Godot/runtime or product contracts.

### 2026-07-09 — standard current-context navigation

- Added Standard navigation block following `CURRENT_CONTEXT_TEMPLATE.md`.
- Made implementation truth, active product/MCP tasks, decisions, open questions and read-next guidance visible near the top.

### 2026-07-07 — Shelter MCP Knowledge API v2

- Added current-context note that Shelter MCP now exposes deterministic Knowledge API v2 tools for decisions, open questions, roadmaps, latest handoff and task-specific reading context.

### 2026-07-07 — v1 created

- Created compressed Codex/dev current context.
- Marked completed briefs and old status history as do-not-read-by-default.
- Pointed to current First Day v3 evidence and First Week / Day 2 next implementation direction.
