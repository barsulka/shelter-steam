# CODEX_CURRENT_STATUS

Обновлено: 2026-07-23
Статус: current-summary
Владелец: Codex / Project Manager
Назначение: единственный текущий dev-status entry point.

---

## 1. Current dev focus

```text
Priority: Visual Shell Lock → Interactive Shelter Shell.
Current implementation authority: active D-032 current-profile brief + active selected-H brief, both surgically amended by accepted D-034.
Current prerequisite: direct user-approved D-030-only 15.0s spawn-anchored readiness-budget amendment is being recorded in both active briefs/current docs; independent docs verification remains a HOLD gate before narrow route wiring and one production run.
Static visual acceptance: USER_ACCEPTED / PASS (selected H GRID32).
Live checkpoint 1 acceptance: USER_ACCEPTED / PASS (background + earth + GRID32, default / 100% / camera 0).
Full live Visual Shell Lock: OPEN / NOT GRANTED.
Platform gate: macOS only.
```

## 2. Current implemented capabilities

D-030 is implemented and is the mechanical runtime baseline: 26-cell meadow,
no stretch, whole-game `50/100/150/200` zoom, dynamic height and alpha-aware
pointer surface.

D-034 now narrowly defines Selected-H low-zoom exterior: canonical `[0,2992)`
projects to the sole render/pointer domain; output outside it is clipped and
true exterior is transparent/click-through. The bounded correction plus
performance bugfix exists at pending bytes:
`vertical_slice_demo.gd=959660edfdace6a6325cc68c3240464e7099ba2c5eb0a97e13e51676cf02e974`
and current validator
`a1e17b2de75090bf66513c457e08b702d2988b18c8fa16495817593eca59e74c`.
Static differential proof passed, but complete governed current-profile and
independent mechanical verification have not passed.

The prior D-034 re-authorization record passed read-only verification and the
same author first stopped `BLOCKED BEFORE SPAWN` on the repo-temp/system-temp
conflict. User-approved Route A retained system temp as transient only:
complete raw/evidence must be copied into unique repo-local `tmp/` and pass
deterministic inventory, SHA-256 and byte/readback equivalence before the
repo-local copy becomes verifier-eligible.

The separate least-privilege config/profile experiment later received
independent `PASS CONFIG ONLY`. Named-profile GUI attempts nevertheless
reproduced the same pre-project AppKit/HIServices `SIGABRT`; these failures and
the config PASS remain real historical evidence, not current D-034 code verdict
or production blocker. By direct user decision, permission/private-tmp
diagnosis is now isolated in a separate non-blocking background task. Current
D-034 production resumes «по-старинке» under effective
`:danger-full-access` / Full Access with unchanged runner `/private/tmp`
behavior and no named-profile/Seatbelt/network-disabled/config/UI prerequisite.

Full Access route-reset docs received independent `PASS DOCS ONLY`. The first
governed production run then stopped real `rc74`/ineligible at `19/24`
captures; the performance bugfix preserved all 19 common PNG bytes and advanced
the next one-shot run to `23/24`, but it also stopped `rc74` before the final
CLEAN capture, atomic matrix and readiness token. Both runs used the active
spawn-anchored `6.0s` maximum, remained in healthy forward progress and are
historical FAIL, not retryable PASS.

The user directly approved exact `15.0s` only for the governed D-030 Selected-H
current-presentation route. It remains spawn-anchored and returns immediately
on readiness; it does not impose a fixed wait. All `12/12`, `24/24`, matrix,
validator, process/diagnostic/supervisor, suites, protected, evidence/promotion
and independent mechanical gates remain exact.

Selected-H checkpoint 1 is implemented in the ordinary player path: accepted
background bands, earth and exact GRID32 are active at the existing
`1740/2992` source-to-runtime bridge. Its permanent route hides gameplay cards,
loads only the accepted meadow source, uses a selected-H alpha-aware pointer
profile and has no active legacy world/marker/dog bindings. The checkpoint-2
roster is not active.

D-024 capture completed successfully from ordinary macOS Terminal and is sealed
as `PASS / TECHNICAL_MECHANICAL_ONLY` for pre-D-030 runtime. Contract A is
`4f956a077d0a93575ef7b518fd0aa9fb409392a08fd4a48190364795bc9b5cbf`;
sealed whole-brief SHA is
`cc6d7fa778b85eebd6d6307dba33efa52518aa62911287dd15ee0d9c7dd5c669`.
The 2066-entry ledger verified clean on 2026-07-21. Its fixed runner/test/normal
validator/capture workflow is immutable pre-D-030 evidence, not a current
D-030/Selected-H applicability gate. Any actual governed legacy run that fails
remains FAIL/ineligible and is never suppressed or counted as PASS.

## 3. Current implementation gate

The D-032 current-profile brief is independently verified and
coordinator-activated as the current prerequisite implementation authority:

```text
selected H GRID32 static USER_ACCEPTED / PASS
→ active bounded Visual Shell runtime integration
→ checkpoint 1 USER_ACCEPTED / PASS
→ D-033 amendment independent docs/brief PASS + coordinator re-authorization
→ retained full governed 12-state run; strict validator FAIL remains ineligible
→ D-034 active-brief amendments → independent docs/brief PASS
→ Root/King bounded re-authorization recorded
→ independent read-only PASS of the re-authorization record
→ author BLOCKED BEFORE SPAWN on repo-temp/system-temp conflict
→ user approves Route A evidence promotion
→ independent config/profile PASS; named-profile GUI SIGABRT reproduced
→ direct user route reset: diagnosis moves to non-blocking background
→ current D-034 production uses effective Full Access + unchanged system temp
→ Full Access route-reset docs PASS
→ production rc74 at 19/24 under 6.0s; performance bugfix static PASS
→ production rc74 at 23/24 under unchanged 6.0s; both runs remain FAIL/ineligible
→ direct user approval: exact D-030-only spawn-anchored maximum = 15.0s
→ independent docs verification of the 15.0s route amendment
→ production author wires the smallest D-030-only budget mechanism; no global broadening
→ static/protected/differential PASS
→ production author runs the exact governed runner once
→ complete system-temp raw tree promoted and byte/hash verified in repo-local tmp
→ fresh full governed 12-state run + relevant suites
→ independent mechanical PASS of the current pre-checkpoint-2 gate
→ release checkpoint 2 from HOLD
→ only after explicit release, live min/default/max × four zoom review
→ user lock
→ separate cards/move/rooms/integrated-shell briefs
```

Day 1/Day 2 are future product work. Existing runtime/persistence tests remain
regressions only. Gameplay/economy may change under the hood only when a
separate brief guarantees no visible-scene or locked-UX change.

## 4. Current required docs

```text
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Game_Design_Roadmap_v2.md
docs/drive/Shelter/04_DEVELOPMENT/CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Selected_H_Visual_Shell_Runtime_Integration_And_Live_Matrix_v1.md
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__D030_Selected_H_Current_Presentation_Regression_Profile_v1.md
docs/repo/adr/README.md
```

### Fixed-path exception

`CODEX_STATUS.md` is not a log anymore. It remains a minimal stub only because
the current D-024 capture runner references the exact path. New status is written
here; history is recovered from Git.

## 5. Current next likely dev step

Next step is independent docs verification of the direct user-approved exact
`15.0s` D-030-only readiness amendment in both active briefs and these current
routes.
Route A evidence handling remains exact: unique system-temp working roots are
allowed for unchanged observer/runner, but only a complete, deterministically
inventoried and byte/hash-verified repo-local copy may reach the verifier.

The independently passed named-profile config remains unchanged as background
evidence and is not a production prerequisite. Permission/private-tmp diagnosis
continues separately. After docs `PASS`, the same production-author task
`019f8ee0-1cd9-76e0-846d-58184b4d945a` may make only the smallest
route-specific runner/observer/profile wiring needed to express exact `15.0s`
for this D-030 profile. Shared/global timeout broadening or another-profile
change is `STOP` before write. Pending demo/validator bugfix bytes above remain;
all other code, D-024, tooling, assets, gameplay/save, roster and Checkpoint 2
stay protected.

Then static/protected/differential gates must pass before exactly one governed
Full Access production run. First actual runner/process/validator/suite/
protected failure stops once with no retry. Fresh `12/12` / `24/24`, atomic
matrix/readiness, relevant suites, evidence integrity/promotion and independent
mechanical `PASS` remain required. No tolerance, suppression, allowlist,
workload reduction or reinterpretation of the historical `rc74` failures is
allowed.

## 6. Selected-H checkpoint 1 A/B remediation handback — 2026-07-22

Implementation file:

```text
steam/scripts/prototypes/vertical_slice/vertical_slice_demo.gd
```

The first independent mechanical verifier returned `FAIL`: the original capture
setter hid UI only for evidence, while permanent player showed cards; legacy
resources and the D-024 pointer surface remained active behind the early draw
return. The same implementation session remediated only those findings.

Fresh direct macOS internal-viewport captures from permanent ordinary-player
state, default width / 100% zoom / camera 0:

```text
GRID  tmp/selected-h-live-checkpoint-1-remediation-0CS3mk/checkpoint1_remediation_default_100_grid.png
      1280×280 RGBA
      SHA-256 ffe37df57f6cb04ad8bbb27ba105c01db7fef26ea77ba81e62604447fb892385
CLEAN tmp/selected-h-live-checkpoint-1-remediation-0CS3mk/checkpoint1_remediation_default_100_clean.png
      1280×280 RGBA
      SHA-256 4b0a98b19cd2dd60710523d5319c789cf2d044e3ad5dfaad35aa9d6b53b2f456
```

The new PNG hashes equal the old PNG hashes because accepted pixels did not
change; provenance did. The grid setter now changes only grid visibility.
Permanent pre-capture and post-hook player readbacks independently report:

```text
ui_hidden=true; visible cards/controls=0
legacy active surfaces=0; roster draws=0; legacy draws=0
active resources=1 (accepted meadow only); tmp dependencies=0
selected alpha pointer samples=2992; legacy pointer records=0
transparent sky click-through=true; opaque content clickable=true
```

GRID/CLEAN diff remains bbox `[1,257,1280,276)`, `23427` pixels and `0`
outside projected runtime grid rows `[257,276)`. Full non-canonical readback:
`tmp/selected-h-live-checkpoint-1-remediation-0CS3mk/checkpoint1_remediation_mechanical.json`
(SHA-256 `ab65833e56e50bde1fcceca19f59d1c2f228a0fd83a11986c768ca8d25b20622`).

Exact Steam Godot `4.7.1.stable.steam.a13da4feb`: final import, script-check,
pre-capture permanent player, capture player and post-hook permanent player all
returned supervisor `0` / diagnostic `PASS`; long-lived players quit with ACK.
The deterministic A/B feedback loop was RED before remediation and GREEN after.

All nine section-4 source SHA-256 values still match and protected paths have
no diff. `tmp` is not a runtime dependency. A separately-run, untouched D-024
scene regression remains FAIL (`16` legacy framing/passthrough assertions,
supervisor `73`); it was neither changed nor allowlisted in this wave and is
retained as the exact pre-D-032 authority-conflict evidence. D-032 routing below
replaces its former current-gate applicability without changing that FAIL.

Final checkpoint-1 gate chain is intentionally recorded without collapsing its
independent stages:

```text
author A/B remediation: COMPLETE
independent mechanical verifier 019f8a6c-9ae0-7850-b193-9c093e92aff3: PASS
independent visual critic 019f8a6c-d059-73f3-9dde-a0ee66581c7c: READY
direct user verdict: “Принимаем”
checkpoint 1 background + earth + GRID32, default / 100% / camera 0: USER_ACCEPTED / PASS
```

The exact fresh evidence root is
`tmp/selected-h-live-checkpoint-1-remediation-0CS3mk/`; the authoritative fresh
GRID, CLEAN and mechanical hashes are the values recorded above. The user then
approved D-032 Route 1. The unchanged D-024 run remains FAIL/ineligible, but is
no longer the current applicability gate. Checkpoint 2 is still `NOT STARTED /
HOLD` until the active current-profile brief is implemented and independently
mechanically passed. Checkpoint-1 acceptance does not grant the full live lock.

## 7. D-032 author implementation — strict validator FAIL / D-034 HOLD — 2026-07-22

The active D-032 implementation owns only:

```text
steam/scripts/prototypes/vertical_slice/vertical_slice_demo.gd
steam/tests/vertical_slice_visual/test_d030_selected_h_current_presentation.py
steam/tests/vertical_slice_visual/run_d030_selected_h_current_presentation.sh
this status/result block
active D-032 brief status/result block
unique ignored tmp evidence
```

The additive seam and two versioned profile files were authored without
editing protected D-024 helpers/tests or observer/tooling. Schema
`shelter.d030-selected-h-current-presentation.v1`, gate
`pre-checkpoint-2`, explicitly keeps `roster_runtime_expected=false`.
Python stdlib parser/self-test passed with `GREEN=1 / RED=9`, including the
required old-reserve, fixed-224, passthrough, missing-state/pair,
checkpoint-2 roster-skip and process-PASS/diagnostic-FAIL rejections. Shell
syntax and `git diff --check` passed. The exact governed vertical-slice
script-check returned child `0`, process `PASS`, diagnostic `PASS`, supervisor
`0`, raw finalized and final PID dead; retained root:
`tmp/d032-script-check-fHTvLGDO/`.

The first full fixed `ordinary-player` run correctly stopped on a real
diagnostic failure:

```text
state: min × 150%
requested/expected size: 720×419
DisplayServer.window_get_size readback: 720×418
child exit: 0
process verdict: FAIL
diagnostic verdict: FAIL
supervisor rc: 73 (DIAGNOSTIC_FAILURE)
raw logs finalized: true
final exact PID alive: false
graceful project-control ACK: true
evidence eligible: false
```

Exact retained root:
`tmp/d030-current-presentation-xFxgWutF/`. Process-result SHA-256 is
`a2d7d266221a82f1badbbe13dcc3ed9fefa8ce0964617bb5b20c4247a0041409`;
stdout/stderr SHA-256 are respectively
`b7e7089b567bb951bdd2f26bf59c387026d217d193fef45c2c4f38caf8720520` and
`af25cc94058bf157f793ecaa371b37b88b116db2dca613d56aad23577d35397b`.
The atomic matrix record was not finalized. Only `min × 50%` and
`min × 100%` produced paired GRID/CLEAN files (`2/12` states, `4/24`
captures); they are partial, process-ineligible diagnostics, not current-profile
evidence or PASS.

D-024 authority-only remained PASS at digest
`4f956a077d0a93575ef7b518fd0aa9fb409392a08fd4a48190364795bc9b5cbf`;
the sealed ledger passed all `2066` entries and protected pins did not change.
The old D-024 scene regression was not run. Relevant PlayerBoot/Labrador/
gameplay/persistence suites were not started after the mandatory STOP.

No tolerance, allowlist, retry or semantic workaround was applied. The executed
`419 → 418` run remains real `FAIL`/ineligible evidence. D-033 now requires
upward quantization to the integral maximum Godot backing-scale step followed by
exact settled actual client-area readback; current host `q=2` yields
`180 / 280 / 420 / 560`, including exact `420` at `min × 150%`.

This authoring wave changes documentation only. The D-033 amendment received
independent docs/brief `PASS` in verifier thread
`019f8669-6a2b-7ba3-931e-be4569a29e9e` at freeze
`79cea50502aff44e0dd17265cdb85fb2347ec1d9c5cba855edb714e8622b1fe6`;
coordinator thread `019f856b-060d-7791-8265-a91cd2de4171` re-authorized only the
D-032 seam + validator continuation in the same implementation session.

That continuation retained a complete `12/12` state / `24/24` capture run at
`tmp/d030-current-presentation-hHYpjj9z/`. Governed ordinary-player
child/process/diagnostic/supervisor were `0 / PASS / PASS / 0`; process-result,
matrix and 25-entry manifest SHA-256 values are:

```text
2552fa49701d66ef63cb5312abf1ee9507f781e5e9851c8fb10359ffd39d9069
88e0112f9d0eb23ffd0b57ee05a1ff4c78cc485be4517270f844d9b0f1127e01
e0d45dc18cd365281604924c670f9b2a3eb89416e81e60001854f2e66c8b3745
```

Runner exit remained `1`: at `default × 50%` its global opaque-fill assertion
rejected a legitimate exterior sentinel, while captures also proved a real
whole-tile overdraw/pointer mismatch. Actual window is `[1280,180]`; projected
canonical interval `[0,870)`; current visible alpha reaches `[0,1152)`; true
transparent exterior is `[1152,1280)`; pointer ends at the canonical projection
with a `4 px` sampled taper. This validator result is real `FAIL`/ineligible and
never retroactive `PASS`.

The user approved D-034: exact render/pointer domain `[0,870)` and transparent
exterior `[870,1280)` for default × 50%, generalized as projected canonical
canvas intersected with actual viewport. Both active-brief amendments received
independent docs/brief `PASS` at freeze
`9cd3ac289c90e2c3a4f8dd605b82229118e9f9743ca9c346c5e8cd379dca5e8b`.
Coordinator/Root/King thread `019f8bac-0007-7962-ad8a-ca31fb95ac7f` read the
accepted contract and recorded `ROOT-APPROVED` bounded continuation for the same
implementation session. That record passed independent read-only verification.
The next author attempt stopped `BLOCKED BEFORE SPAWN` because unchanged
observer requires system-temp `HOME`/output while the prior recovery required
repo-local temp; no Godot child, matrix or suites started.

The user then approved Route A evidence promotion. A later project-scoped named
permission config received independent `PASS CONFIG ONLY`, while two
named-profile GUI attempts reproduced pre-project AppKit/HIServices `SIGABRT`.
All remain real historical evidence and are never retroactive D-034 code
verdicts.

The user's direct production route reset isolated permission diagnosis and
received independent `PASS DOCS ONLY`. Under the accepted Full Access route,
the first production run stopped `rc74` at `19/24`; a bounded performance
bugfix passed differential/static checks and preserved all common PNG bytes,
but its one run also stopped `rc74` at `23/24`. Both `6.0s` timeout runs remain
real FAIL/ineligible, unpromoted and unretried.

Direct user approval now sets the governed D-030 current-presentation
spawn-anchored maximum to exact `15.0s`; readiness still returns immediately.
This docs amendment is `READY FOR INDEPENDENT DOCS VERIFICATION`. Production
remains `HOLD` until docs `PASS`, narrow route-only budget wiring,
static/protected PASS and one new governed run. Independent current-profile PASS
is absent. Full live Visual Shell Lock remains open; Checkpoint 2 remains
`NOT STARTED / HOLD`, and roster work remains forbidden.
