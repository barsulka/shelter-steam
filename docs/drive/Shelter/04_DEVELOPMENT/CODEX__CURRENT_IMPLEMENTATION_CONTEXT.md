# CODEX — Current Implementation Context

Дата создания: 2026-07-07
Обновлено: 2026-07-12
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
ChatGPT Work/Codex reads the local checkout directly.
Shelter MCP is an optional local domain-specific runtime/inspection adapter.
GitHub Actions CI validates the MCP without starting Godot/runtime.
D-022 source evolution currently makes MCP startup fail loud on knowledge catalog drift; direct checkout remains the active path.
First Day MVP is locked at prototype/product-language level.
D-022 Day 2 same-chain Warm Food Delivery is implemented and verified at prototype/product-language/runtime-evidence level.
```

Active roadmap / current task:

```text
Product roadmap: STEAM_DESKTOP__First_48_Hours_Playable_Roadmap_v1.md
Current product task: R48-01A + R48-02A + R48-02B completed/PASS; prepare R48-03 persisted First Day → Day 2 transition brief
Completed workflow/MCP task: ChatGPT Work And Local MCP Migration v1
```

Current decisions:

```text
D-007, D-016, D-017, D-018, D-019, D-020, D-021, D-022, D-023
```

Active open questions:

```text
OQ-Steam-003, OQ-Docs-001
```

Read next by task:

```text
Product implementation: GAME_DESIGN__CURRENT_CONTEXT.md + active Codex brief
MCP implementation: relevant Shelter MCP brief in 04_DEVELOPMENT
Architecture: docs/repo/adr/README.md
Detailed history: CODEX_STATUS.md latest entry only by default
```

Do not read by default:

```text
old completed briefs, full CODEX_STATUS.md, old runtime captures, superseded simulator docs
```

Next best step:

```text
Run Codex only from a current brief and update current/status docs after completion.
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

Shelter MCP source now lives under `mcp/` in the monorepo. Its accepted role is a local domain-specific adapter for whitelisted dev commands, Godot runtime/capture inspection and control, plus bounded knowledge navigation. It is not a generic shell.

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
R48-01A clean PlayerBoot entry, R48-02A profile-store foundation and R48-02B First Day safe-checkpoint Continue are implemented/PASS.
Organic ordinary Continue → Day 2 remains R48-03 and is not implemented yet.
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
- Shelter MCP repo/document tooling v1/v2.
- Shelter MCP Knowledge API v2 for decisions, open questions, roadmaps, latest handoff and task context.
- Shelter MCP GitHub Actions CI: unit/race tests, vet, build and launcher syntax check on every push and pull request.

MCP knowledge output is validated against source documents at startup; source documents always win.

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
- D-022/OQ/R-29 source changes require catalog reconciliation or a later decoupling design before MCP runtime tools are available again.

---

## 9. Next likely implementation direction

Completed workflow/tooling slice:

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
R-29 is closed / PASS. D-023 selects the First Day + Day 2 player journey. R48-01A, ADR-0003/R48-02A and R48-02B completed/PASS; R48-03 brief preparation is next.
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
