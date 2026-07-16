# CODEX_CURRENT_STATUS

Дата создания: 2026-07-07
Обновлено: 2026-07-16
Статус: current-summary
Владелец: Codex / Project Manager
Назначение: короткий текущий dev-status entry point. Не является историческим журналом.

---

## 0. Read policy

Читать этот документ для быстрого dev/Codex входа вместо полного чтения `CODEX_STATUS.md`.

Для детальной истории использовать:

```text
docs/repo/status/CODEX_STATUS.md
```

Для compressed implementation context использовать:

```text
docs/drive/Shelter/04_DEVELOPMENT/CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md
```

---

## 1. Current dev focus

Current primary implementation area:

```text
Shelter Steam/Desktop + Shelter MCP tooling
```

Current product state:

```text
First Day MVP locked at prototype/product-language level.
D-022 Day 2 same-chain Warm Food Delivery variation is implemented and verified at prototype/product-language/runtime-evidence level.
R-29 is closed / PASS after PM/Producer review.
D-023 First Day + Day 2 player journey scope lock is accepted; R48-01A, R48-02A, R48-02B and R48-03 are completed/PASS. The source-reconciled R48-05A integration is local Technical/Mechanical PASS: exact 41 PNG + 41 imports, one source-reconciled world lane and one Labrador A–H lane are active. D-024 exact 43+43 responsive-presentation integration/regressions pass, and the D-029/D-024 observability, graceful-stop and atomic-runner remediation is implemented plus independently no-Godot reviewed PASS with P0=0/P1=0/P2=0. Capture remains BLOCKED/HOLD/UNSEALED; real Steam Godot 4.7.1, Continue runtime, actual PlayerBoot control ACK, GUI/capture/manifest/seal/promotion and final runtime Art/user acceptance remain not run. Parent R48-A/R48-05 stays PARTIAL/WARN, later R48-05B remains separate, and R48-04A remains deferred.
D-024 current status: D029_D024_OBSERVABILITY_ATOMIC_RUNNER_REMEDIATION_IMPLEMENTED / INDEPENDENT_NO_GODOT_REVIEW_PASS / P0=0 / P1=0 / P2=0 / CAPTURE_BLOCKED / EVIDENCE_HOLD / UNSEALED / BOUNDED_REAL_RUN_REQUIRES_NEW_USER_COORDINATOR_DECISION_AND_LITERAL_ACK.
```

Current tooling state:

```text
ChatGPT Work/Codex reads this checkout directly.
Accepted D-026 is implemented and independently reviewed `PASS`; a healthy source-derived `shelter_context_bundle` is the active routine bootstrap/context-routing default. Local source docs remain project authority and exact fallback under the documented conditions.
The Source-Derived MCP Context Bridge v1 publishes a 4 KiB schema minimum, 24 KiB default and 64 KiB hard cap; under-min input fails without StructuredContent, while valid knowledge errors use a bounded envelope with fixed-point actual encoded-byte accounting.
Fixed implementation/decision/handoff/context-routing task categories now deterministically prioritize authored source paths/headings without AI/free search/arbitrary paths; canonical compound decision kinds project only to the accepted legacy enum or explicit-fail.
All enabled legacy knowledge projections use the same source snapshot; static current-fact mirrors/fingerprints and the global startup knowledge gate are removed.
Knowledge failure is capability-local, so server registration and runtime/capture/control tools remain available in the same session.
Project-scoped local STDIO setup is complete.
GitHub Actions CI for the MCP is defined; its first remote run is pending.
Direct checkout reads remain authority and the exact fallback for non-current/truncated bundles, exact briefs/ADRs/contracts, conflicts/parser failures and source editing.
```

---

## 2. Current implemented capabilities

Steam/Desktop / Godot:

- Godot 4.x project under `steam/`.
- Clean PlayerBoot route shared by F5, `steam/play.sh` and the macOS internal export.
- Separate bounded `steam/dev.sh` dispatcher for prototype/dev tooling.
- Strict player-profile envelope/store/recovery foundation under `user://player/default`.
- Exact seventeen-cursor First Day safe-checkpoint autosave/Continue with durable acknowledgement barriers and restart-safe recovery.
- Exact thirty-three-cursor First Day + Day 2 player journey, including fixture-free persisted return and restart-stable Quiet Cooperative.
- Desktop window / companion strip tech demos.
- Vertical Slice prototype.
- Dog rig spikes and dog runtime integration slice.
- Godot State Connector.
- Godot Control Connector.
- Workbench Runtime Capture Harness.
- First Day MVP runtime proof.
- First Day visible review capture packs v1/v2/v3.
- First Day Art/UX visual-language pass v1 accepted as prototype pass.
- Day 2 deterministic continuation fixture and complete second warm-delivery scenario.
- Day 2 exact order/chain/event assertions plus six native 1x product-language moments.
- Source-reconciled R48-05A world: 16 static full-canvas layers `00–09,11–16`, no runtime layer 10, one standalone Bicycle in the existing transport slot and 24 Labrador identity composites; exact runtime topology is `41 PNG + 41 .import`.
- Derived/non-persisted Labrador A–H presentation at positive scale `0.24`, exact H route/cadence, both station sides and physical turns, one runtime/render lane, zero new mechanics/transfer/output and honest `legacy_unbound` for existing Unload/Carry/LoadVan phases.
- Immutable source-reconciled runtime evidence with actual macOS desktop, native `2992x224`, `216/144/96`, checker/black alpha, First Day/Day 2/Quiet Cooperative, A–H, both turns/sides and H cancellation/recovery traces.
- D-024 responsive presentation: seam-safe tiled meadow, independent `[0,1740]` field/viewport, bounded drag pan, right reserve, authored-positive boundary marker and exact `43 PNG + 43 .import` mechanical/regression PASS.
- D-024 immutable authority Contract A `4f956a077d0a93575ef7b518fd0aa9fb409392a08fd4a48190364795bc9b5cbf`; current whole brief SHA K is `ccb81f8a7f881ad078dad54bcd811dad2616aa36f843b2bee0ca67c2487d26ed`.
- D-029/D-024 narrow supervisor, append-only raw stdout/stderr, project-owned graceful quit/control ACK, bounded SIGTERM fallback, no-hard-kill/no-CA-allowlist policy, fail-loud expected-persistence seam and atomic staged runner are implemented. Independent no-Godot re-review reproduced authority-only/normal validator PASS, observer `22/22`, shell syntax, exact eight-path/pin, `17 -> 18` and isolation gates with `P0=0 / P1=0 / P2=0`.

Shelter MCP:

- whitelisted Shelter dev commands;
- workbench capture management;
- local Godot connector/control runtime management;
- whitelisted runtime control actions;
- safe repo tools: `git_status`, `git_diff`, `git_diff_for_review`;
- safe patch/edit tools: `apply_patch`, markdown section editing, marker replacement, sha256 guarded writes;
- source-derived routine bootstrap/context routing via `shelter_context_bundle`;
- legacy full-source bootstrap fallback via `read_shelter_bootstrap_context`; it is not the D-026 daily default.
- source-derived knowledge access tools: `find_current_context`, `list_decisions`, `decision_digest`, `get_decision`, `list_open_questions`, `open_questions_digest`, `list_roadmaps`, `latest_handoff`, `knowledge_task_context`, `shelter_status`, `current_entry_digest`, `list_active_docs`, `classify_doc_path`, `explain_superseded`, `knowledge_gc_report`.
- GitHub Actions CI runs MCP unit/race tests, vet, build and launcher syntax checks on every push and pull request.

---

## 3. Current active docs for dev sessions

Read first for dev/Codex tasks:

```text
PROJECTS_RULES.md
AGENTS.md
README.md
steam/AGENTS.md
steam/README.md
docs/repo/adr/README.md
docs/repo/status/CODEX_CURRENT_STATUS.md
docs/drive/Shelter/04_DEVELOPMENT/CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md
docs/drive/Shelter/04_DEVELOPMENT/SHELTER_WORKFLOW__Codex_Brief__Source_Derived_MCP_Context_Bridge_v1.md
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__D024_Responsive_Meadow_Marker_And_Player_Presentation_Cleanup_v1.md
```

For task execution, read the active brief in:

```text
docs/drive/Shelter/04_DEVELOPMENT/
```

---

## 4. Current known limitations

- Windows behavior remains less tested than macOS visible checks.
- Prototype visual-language evidence is not production art or shipping UX.
- 100x Workbench capture validates state/causality, not player feel or visual warmth.
- Capture packs are evidence/history, not default bootstrap context.
- `CODEX_STATUS.md` is a historical log and should not be read in full by default.
- MCP repo/document tools are safe helpers, not a generic shell.
- MCP knowledge has no static current-fact mirror or manually maintained content fingerprints; source documents win and each request reparses them.
- Read-only MCP knowledge/inspection tools run non-interactively through explicit per-tool approval; runtime-changing tools still require prompt approval.
- The first GitHub Actions run must still verify hosted-runner/action availability; CI never starts Godot/runtime or MCP control operations.
- D-026 is final independent-review `PASS` with no remaining blocker and active daily-default rollout. Non-blocking residuals are the first remote CI run, the accepted boundary that semantic governance conflicts require canonical source synchronization/direct verification rather than an automatic detector, and honest fallback/omissions when 4 KiB cannot carry the requested context.
- Day 2 native evidence uses existing semantic placeholders; it is not production dog art, final animation or final world readability acceptance.
- R48-05A v1–v5 history, the frozen source package and the new source-reconciled evidence pack are immutable. The new integration is Technical/Mechanical PASS only: runtime Art PASS and general user acceptance are not granted. Independent review must use the source-reconciled pack; parent R48-A/R48-05 remains PARTIAL/WARN and R48-05B remains separate.
- D-024 capture is not active. The D-029/D-024 no-Godot remediation/review is PASS, but the canonical evidence root remains exactly 32 files/no `HASHES.sha256`/tree `4ca49b1d9cd0616d434eb534464087c75cebcd4972122356ad9197ec59cdd378`. Real Steam Godot/runtime/control/capture/manifest/seal/promotion is not run. The CA diagnostic is real/unresolved/not allowlisted; recurrence is diagnostic FAIL/rc73 and STOP before capture/seal.

---

## 5. Current next likely dev step

Completed D-026 implementation/review authority:

```text
docs/drive/Shelter/04_DEVELOPMENT/SHELTER_WORKFLOW__Codex_Brief__Source_Derived_MCP_Context_Bridge_v1.md
```

The source-derived implementation and its four-finding remediation are complete and independently reviewed `PASS`; daily-default MCP-first routing is active, direct source remains authority/exact fallback, and no later MCP implementation slice is assigned.

Completed previous workflow/tooling brief:

```text
docs/drive/Shelter/04_DEVELOPMENT/SHELTER_WORKFLOW__Codex_Brief__ChatGPT_Work_And_Local_MCP_Migration_v1.md
```

This brief completed workflow, MCP/config and dev documentation. No Godot/runtime behavior changed.

Completed product implementation brief:

```text
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Day_2_Return_And_Second_Warm_Delivery_v1.md
```

Expected reasoning level:

```text
очень высокий
```

Current next step:

```text
Wait for a new user/coordinator decision. Only a new literal bounded real-run ACK naming unchanged Contract A, current brief K, all final eight implementation hashes, the pinned 32-file evidence tree and exact writer/scope may authorize the next Steam Godot/runtime/control/capture action. PM docs sync activates nothing. Do not mix this with later R48-05B work or claim parent R48-A/R48-05 closure.
```

---

## 6. Changelog

### 2026-07-16 — D-029/D-024 remediation implemented / independent no-Godot PASS

- Recorded the final exact eight-file observability, project-owned graceful-stop and atomic-runner remediation plus independent reviewer verdict `P0=0 / P1=0 / P2=0`.
- Preserved Contract A and advanced the active brief to SHA K `ccb81f8a…`; evidence remains 32 files/no seal/tree `4ca49b1d…`.
- Kept real Steam Godot/runtime/control/capture/manifest/seal/promotion not run, CA real/unresolved/not allowlisted and the next gate limited to a new user/coordinator decision plus literal bounded real-run ACK. PM sync activates nothing.

### 2026-07-15 — D-024 authority-tool correction PASS / evidence HOLD

- Recorded immutable Contract A, final Phase 2 brief SHA C and corrected validator/runner V/R after the bounded mutation matrix and no-GUI checks passed.
- Marked capture as inactive pending literal coordinator ACK; the evidence root remains 31 files, no seal, ledger 30/30.
- Set the only current dev step to ACK naming A/C, then one existing-runner GUI-capable macOS capture, seal and Art/user review by reserved writer `019f6604-8ac6-7871-85c8-2c858a2240f3`.

### 2026-07-15 — D-026 independent review PASS / daily default active

- Independent re-review reproduced and closed the prior two P1 and two P2 findings; no new P0/P1/P2 or compatibility regression was found, and remaining D-026 blockers are none.
- Activated healthy `shelter_context_bundle` as the routine bootstrap/context-routing default while preserving local source docs as authority/exact fallback.
- Retained first remote CI, the accepted semantic-governance conflict boundary and honest 4 KiB fallback/omissions as non-blocking residuals; returned the next project step to D-024 macOS self-capture, evidence seal and Art/user review.

### 2026-07-15 — D-026 independent-review remediation / local checks PASS / re-review pending

- Published the `4096` schema minimum: `1`/`4095` now fail input validation without StructuredContent; valid malformed-source errors are deterministic bounded envelopes with fixed-point actual byte counts and no silent omission.
- Restored legacy decision-kind compatibility including D-010 as `product`, and added deterministic implementation/decision/handoff/context-routing priority from fixed task keywords.
- Full local unit/race/vet/build, root+nested STDIO, 24 KiB/4 KiB/under-min/malformed-source and non-interactive Codex checks pass. Final D-026 acceptance/daily-default rollout still awaits independent reviewer PASS; semantic source conflicts require canonical sync/direct fallback.

### 2026-07-15 — D-026 source-derived MCP context bridge / local PASS

- Implemented parse-on-request source snapshots, exact current excerpts, file/block SHA-256 provenance and deterministic `shelter_context_bundle` budgets (`24576` default, `65536` hard cap).
- Migrated every enabled legacy knowledge projection from static facts to the same canonical Markdown snapshot and removed current-fact mirrors/fingerprints plus the global startup gate.
- Verified same-session capability isolation: a deterministic knowledge error leaves registration and runtime/capture/control tools available; local docs remain authority/exact fallback.

### 2026-07-14 — source-reconciled R48-05A integration / Technical-Mechanical PASS / Art pending

- Replaced the old 62-file authored runtime atomically with exact 16 world layers `00–09,11–16`, one standalone Bicycle and 24 Labrador composites: `41 PNG + 41` verified Godot sidecars, source-equal for all 41 files.
- Integrated the exact `1740` runtime world over `2992` source width, Labrador scale `0.24`, single render lane, exact Kitchen/Packing roots and derived/non-persisted selector H route/cadence with zero gameplay/transfer output.
- Passed the 64-check source/runtime validator, both animation-pipeline skill validators, Godot import/check/smoke, A–H/negative/cancellation/recovery, ordinary First Day/Day 2/Quiet Cooperative, profile-store/checkpoint/33-cursor Continue/SIGKILL/save-retry and isolated ordinary `play.sh`; production profile remained absent.
- Published immutable 41-file source-reconciled evidence pack (40 ledger entries plus `HASHES.sha256`) with actual desktop and `2992x224/216/144/96` readbacks. Runtime Art review and explicit user acceptance remain pending; no R48-05B or parent closure is claimed.

### 2026-07-13 — R48-05A v5 local Technical PASS / overall current look rejected

- Implemented only the derived, fail-closed Packing D/F/G/contact-held EXIT segmentation of existing `world.fence.front_span`; source, global z, scale/root/window/anchors/timing/gameplay/persistence stayed unchanged.
- Passed exact state-specific bbox/margin gates, both-side contact, `8/8` positive and `6/6` negative mask cells with zero forbidden screen/source-alpha overlap, A–G/negative G, both turns, four even 1x strips, cancellation/recovery, `legacy_unbound=3`, all negatives and zero transfer.
- Published the 556-file v5 pack as local Technical PASS with independent owner review pending; Codex did not grant runtime Art PASS.
- Recorded the separate direct owner verdict: overall player-facing visual coherence is `CHANGES_REQUIRED / USER_OWNER_REJECTED_CURRENT_LOOK` because the current dogs, building placement and meadow/clearing do not match expected accepted references.
- No v6 or reconciliation mutation is authorized. Next is read-only Art comparison followed by a new Art-owned brief sequence.
- Source/project/skill, Godot, profile/checkpoint/Day2, 33-cursor Continue/SIGKILL/save-retry and isolated ordinary startup remain green; production profile absent and temporary profiles removed.

### 2026-07-13 — R48-05A v4 Technical BLOCKED / Art pending

- Applied exact uniform scale `0.24` and v4 station projections while preserving the actual `2992x224` PlayerBoot window, gameplay timing, A–G, both turns, full-width world, `legacy_unbound=3`, zero transfer and all no-touch contracts.
- Measured idle A at `89/59/39 px` for `216/144/96`, but synthetic Kitchen E at `74/49/33 px`, First Day E at `76/52/35 px`, and Day 2 G at `73/49/32 px`, below the universal `80/52/35 px` requirement.
- Confirmed both-side contact within `4 px`; from-right Packing still has forbidden torso overlap of `167/890` screen/source samples. The allowed registration boundary cannot clear it, while the first clear probe breaks contact.
- Published the 450-file v4 pack and returned `STOP_UNSUPPORTED_ACTOR_ENVELOPE`; v1/v2/v3 remain immutable, v4 Art is `PENDING_OWNER_REVIEW`, and Codex did not grant Art PASS.
- Source/project/skill, Godot, profile/checkpoint/Day2, 33-cursor Continue/SIGKILL/save-retry and isolated ordinary startup remain green; real profile absent and temporary profiles removed.

### 2026-07-13 — R48-05A v3 Technical BLOCKED / Art pending

- Applied exact uniform scale `0.60` and v3 station projections while preserving timing, A–G, both turns, full-width world, `legacy_unbound=3`, zero transfer and all no-touch contracts.
- Proved the real PlayerBoot truth: `2992x224`, full usable width, bottom delta `0`, no window-contract mutation. Native Labrador bbox touches `y=0`; projected identity height is `232.14 px` versus `224 px` available.
- Published the 450-file v3 pack and returned `STOP_UNSUPPORTED_ACTOR_ENVELOPE`; v1/v2 remain immutable, v3 Art is `PENDING_OWNER_REVIEW`, and Codex did not grant Art PASS.
- Source/project/skill, Godot, profile/checkpoint/Day2, 33-cursor Continue/SIGKILL/save-retry and isolated ordinary startup remain green; real profile absent and temporary profiles removed.

### 2026-07-13 — R48-05A v2 technical correction PASS / Art re-review pending

- Corrected full-width x=0..1740 framing, Labrador uniform scale `0.25 -> 1.0`, 1:1 station-anchor projection, distributed start/walk/stop motion and root-locked two-direction turns without changing gameplay timing or output.
- Published a 443-file v2 pack with actual player states, four evenly sampled 1x strips, both turns/sides, cancellation/recovery, desktop composition and declared 216/144/96 resamples measuring `137/92/61 px`.
- Re-ran source/project/skill validators, full Godot, profile/checkpoint/Day 2, 33-cursor Continue/SIGKILL/save-failure and isolated ordinary player startup; the production profile remained absent.
- Preserved v1 as immutable `CHANGES_REQUIRED` history. v2 runtime Art remains `PENDING_OWNER_REVIEW`, so implemented R48-05A is still overall WARN and parent R48-05 remains PARTIAL/WARN.

### 2026-07-13 — bounded R48-05A implemented / mechanical PASS / Art pending

- Imported the exact 14 world and 48 Labrador runtime layers and integrated authored A–G presentation into the existing PlayerBoot-owned First Day/Day 2 runtime.
- Preserved current gameplay/persistence authority, exact 33 cursors and the primitive `legacy_unbound` lane for Unload/Carry/LoadVan; no transfer semantics or new mechanic was added.
- Passed source/binding validators, native capture, full Godot, profile-store, checkpoint, 33-cursor Continue/SIGKILL/save-retry and ordinary isolated `play.sh` smoke.
- Published the persistent native capture pack with runtime Art explicitly pending; overall R48-05A remains WARN until owner review, and parent R48-05 remains PARTIAL/WARN until 05B.

### 2026-07-12 — R48-05A/05B split recorded

- Authorized source-only Art input production and kept runtime activation blocked.
- Recorded bounded no-transfer 05A and later one-transfer 05B parent closure.

### 2026-07-12 — game-first coordination handoff recorded

- Confirmed R48-03 continuity at 33 safe cursors and shifted the next priority to authored world + living Labrador.
- Prepared four bounded game-first briefs with explicit DoD and stop conditions.
- Kept the untracked R48-04A draft untouched, deferred and non-authoritative.
- Made asset/runtime work fail closed on accepted Art/Game Design/Technical inputs; no code or art was changed.

### 2026-07-12 — R48-03 completed / PASS

- Implemented ordinary persisted First Day → Day 2 return without fixture loading, wall-clock progression or transition refill.
- Extended the player checkpoint graph from 17 to 33 through the complete second delivery and restart-stable Quiet Cooperative.
- Passed fresh-process restart/advance, automatic-task and completion-beat SIGKILL, failed-save Retry, fixture-oracle, First Day, profile-store, full Godot and native D-022 regressions.
- Advanced only to R48-04A brief preparation; no background-cadence claim is made.

### 2026-07-12 — R48-02B completed / PASS

- Implemented the exact seventeen-cursor First Day checkpoint codec, autosave/Continue and persistence acknowledgement barrier.
- Verified all cursor restores and advances, real in-flight forced-kill replay, save-failure rollback/retry, recovery/error routes, exact three-input First Day flow and `x2/x2 → x1/x1` conservation.
- Preserved First Day and D-022 Day 2 regressions; no production player profile remains after tests.
- Advanced only to R48-03 brief preparation; organic Continue → Day 2 is still pending.

### 2026-07-12 — R48-02A persistence foundation completed

- Added strict integer-only player envelope, exact production/test namespace boundaries and deterministic primary/backup/temp recovery.
- Passed normal restart, real SIGKILL transaction matrices, exact current test-root cleanup, full Godot checks and independent review.
- Kept every envelope non-playable; advanced the next gate to R48-02B brief preparation and retained R48-03 as the later persisted Day 2 transition.

### 2026-07-12 — R48-01A player entry completed

- F5, `steam/play.sh` and the macOS export now enter one clean PlayerBoot route over the existing Vertical Slice runtime.
- Added bounded `steam/dev.sh`; preserved legacy `launch.sh` and specialized tools.
- Shell, Godot, First Day, connector, Day 2 dev-route and macOS export checks passed.
- Made accepted ADR-0003/R48-02A the current implementation wave; functional Continue remains R48-02B.

### 2026-07-12 — R48 entry/save preflight accepted

- Accepted R48-01A as the current implementation wave for the unified F5/`play.sh` player route and bounded `dev.sh` dispatcher.
- Accepted ADR-0003 player-profile persistence boundary and queued R48-02A after R48-01A.
- Preserved one gameplay runtime, player/dev isolation, safe-checkpoint semantics and the exact D-023 no-obligation boundary.

### 2026-07-12 — R-29 PM/Producer closeout

- Recorded R-29 closed / PASS after Day 2 owner GREEN and fresh First Day regression.
- Removed the pending closeout wording and left the next implementation brief intentionally unselected.
- Preserved the separate MCP knowledge-drift note and all future production/platform gates.

### 2026-07-11 — D-022 Day 2 implementation/evidence complete

- Added `second_day_after_first_delivery` and `second_warm_delivery_after_first_day` with immutable First Day history separated from the active Day 2 order/chain.
- Verified the exact order and physical-chain sequences, order-tagged tasks/events, Labrador in-progress packing-care cue, player-confirmed dispatch and non-reward quiet completion.
- Generated six native 1x moments plus 80 normal-speed frames under ignored `.runtime`; full First Day dispatch and connector/runtime regressions remain green.
- Kept save/calendar, new systems, production dog pipeline, window/platform, MCP and CI outside the implementation change.

### 2026-07-11 — D-022 Day 2 implementation activated

- Accepted the complete same-chain Day 2 scope and normalized the canonical brief path.
- Kept save/calendar, new systems, production dog pipeline and window/platform work outside the implementation brief.

### 2026-07-11 — Shelter MCP GitHub Actions CI

- Added least-privilege CI for every push and pull request, without path filters so source-only knowledge drift is covered.
- CI uses the Go version in `mcp/go.mod` and runs unit/race tests, vet, build and `sh -n mcp/run.sh`.
- First remote GitHub run remains pending.

### 2026-07-10 — D-021 workflow migration

- Switched current access truth from MCP bridge to direct local Work/Codex checkout.
- Reclassified Shelter MCP as a local domain-specific adapter and completed project-scoped STDIO setup.
- Completed the dedicated migration brief and project-scoped local STDIO setup.
- Corrective audit added full source/catalog content locks, exact roadmap-state validation, safe per-tool approvals and a nested-cwd `codex exec` smoke.

### 2026-07-09 — Shelter MCP knowledge polish dashboard

- Added deterministic Shelter MCP polish tools for fresh-session entry: `decision_digest`, `shelter_status`, `open_questions_digest`, and `current_entry_digest`.
- Kept the polish tools read-only, bounded and static-catalog/simple-rule based.

### 2026-07-07 — Shelter MCP Knowledge API v2

- Added deterministic Shelter MCP Knowledge API v2 tools for decisions, open questions, roadmaps, latest handoff and task-specific reading context.
- Kept the v2 knowledge tools read-only, bounded and static-catalog/simple-rule based: no generic shell, broad repo search, network calls, AI summarization, embeddings or vector DB.

### 2026-07-07 — Shelter MCP knowledge service v1

- Added deterministic Shelter MCP knowledge access tools for Current Memory / Knowledge / History routing.
- PM/docs bootstrap now treats `05_DOCUMENTATION_GOVERNANCE.md` as a first-class docs bootstrap document.

### 2026-07-07 — v1 created

- Created short current dev-status entry point.
- Clarified that `CODEX_STATUS.md` remains detailed history log and should not be used as default bootstrap document.
- Pointed Codex/dev sessions to current context docs and active briefs.
