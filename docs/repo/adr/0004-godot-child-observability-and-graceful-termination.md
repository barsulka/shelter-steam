# ADR 0004: Godot Child Observability And Graceful Termination

Date: 2026-07-16

Status: Accepted

Related process decisions: D-027 — Blocker Revalidation And User Approval For
Material Workaround Routes; D-028 — Steam-Managed Godot Installation And
Version Authority; D-029 — Observable And Graceful Godot Subprocess Lifecycle.

Clarifies: ADR 0003 — Player Profile Persistence Boundary And Recovery, only
for the process-level method used to prove interruption/recovery. ADR 0003
persistence, save, schema, checkpoint and recovery semantics remain unchanged.

Related implementation authority:
`docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__D024_Responsive_Meadow_Marker_And_Player_Presentation_Cleanup_v1.md`.

Implementation status: the exact D-029/D-024 observability, project-owned
graceful-shutdown and atomic-runner remediation is implemented and independently
reviewed `PASS` without launching Godot (`P0=0 / P1=0 / P2=0`). Capture remains
`BLOCKED / EVIDENCE_HOLD / UNSEALED`: PM factual sync activates nothing, and a
bounded real run requires a new user/coordinator decision plus literal ACK under
the active brief. Real Steam Godot/runtime/control/capture/seal acceptance is
not implied by the no-Godot PASS. The CA diagnostic remains
`REAL / UNRESOLVED / NOT ALLOWLISTED`; recurrence is diagnostic FAIL/rc `73`
and stops before capture or seal.

## Context

Shelter's Godot test and capture chain has historically mixed several distinct
outcomes: the child process exit, wrapper/pipeline exit, post-run diagnostic
matching and evidence eligibility. A stdout-only callsite lost the exact line
that caused a forbidden-diagnostic predicate to fail. Historical recovery tests
also used fatal process interruption as proof, while the current user-approved
route explicitly forbids project wrappers from inducing Godot crashes or hard
kills.

The current Steam-managed Godot is
`4.7.1.stable.steam.a13da4feb`. A CA/certificate diagnostic has been observed
and remains real and unresolved. It cannot be hidden, suppressed or classified
as benign merely to continue capture.

The project needs one narrow, deterministic subprocess boundary that retains
complete evidence, keeps process and diagnostic results independent, allows
finite tests to finish naturally and stops long-lived processes gracefully.

## Decision

### 1. One narrow project supervisor

The standard project-owned supervisor is:

```text
steam/tools/observe-godot-process.py
```

It is Python standard-library only. Its public CLI accepts exactly these fixed
profiles:

```text
version
import
script-check
scene-test
scene-capture
ordinary-player
```

It does not expose an arbitrary executable, argv or shell command. A fake child
is available only as an imported unit-test seam and cannot become a public
arbitrary-process profile.

### 2. Fail-closed preflight

Before spawn, the supervisor validates all of the following:

- the executable is exactly the D-028 Steam-managed Godot binary at the
  repository-documented path;
- the version is exactly the currently accepted readback
  `4.7.1.stable.steam.a13da4feb`;
- the project is the canonical Shelter `steam/` directory and contains the
  expected `project.godot`;
- cwd, HOME and output/stage boundaries match the selected fixed profile;
- argv is constructed by the profile and contains no `--editor`, foreign or
  duplicate `--path`, arbitrary command tail, or headless GUI/capture
  substitution.

Invalid project, binary, version or argv fails before child creation. No PATH,
alternate installation, dependency, network, trust-store or shell fallback is
allowed.

### 3. Raw stream and event contract

The child writes directly to two separate append-only files:

```text
stdout.log
stderr.log
```

Both streams are mirrored live without replacing the retained raw bytes.
Diagnostic matching operates only after the bytes are retained. A deterministic
`events.jsonl` records ordered supervisor/process/diagnostic events without
becoming a substitute for the raw logs.

The only raw log must never be removed by a trap, truncated, redirected to
`/dev/null`, filtered before retention or collapsed into a stdout-only
pipeline.

### 4. Explicit result contract

`process-result.json` records at least:

- exact binary, version, argv, cwd, HOME and canonical project identity/hash;
- child PID and start/end timestamps;
- either normal exit code or terminating signal number/name;
- requested stop path, acknowledgement/timing data and whether the exact PID
  remains alive;
- raw stdout/stderr byte counts and SHA-256 hashes;
- diagnostic matches;
- separate `process_verdict` and `diagnostic_verdict`;
- evidence/seal eligibility.

The supervisor's own return code never overwrites or masquerades as the
original child exit/signal. Supervisor return codes use only `0` and the
reserved namespace `70..75`; `73` is diagnostic failure and `75` is
`BLOCKED_CHILD_STILL_RUNNING`. Rc `70` is fail-closed preflight/internal
failure; rc `74` is a completed bounded exact-PID SIGTERM fallback after a
failed/missing project ACK and is always evidence-ineligible, not normal PASS.
The remaining reserved codes and their stable constants are fixed by the
implementation and unit tests without reusing raw child exit codes.

### 5. Finite child behavior

A diagnostic match, including `ERROR`, never terminates a finite child. The
test runs to natural exit so that late output and a late PASS marker remain
observable.

After exit, process and diagnostic verdicts are computed independently. For
example, `ERROR` followed by late PASS and exit `0` yields process `PASS`,
diagnostic `FAIL`, supervisor rc `73` and evidence/seal ineligible.

A non-zero exit or self-termination signal remains an explicit process failure
with its original metadata retained in `process-result.json`.

### 6. Long-lived graceful stop

A long-lived child may be stopped only in this order:

1. request project/control quit and require its acknowledgement;
2. wait a bounded grace period;
3. if the exact child PID is still alive, send that PID `SIGTERM`;
4. wait a second bounded grace period;
5. if the PID is still alive, return rc `75`, report
   `BLOCKED_CHILD_STILL_RUNNING`, preserve PID/logs/results and stop the
   workflow.

There is no supervisor `SIGKILL`, `SIGABRT`, `kill -9`, process-group hard kill
or hidden escalation. Tests of the TERM-resistant path use cooperative fixture
cleanup outside the supervisor contract and must not add a hard-kill escape.

### 6A. User-approved project-owned graceful-shutdown route

This section clarifies the current implementation route for section 6 without
rewriting its accepted history.

D-024/D-029 do not add a native `SIGTERM` bridge, GDExtension or platform
signal handler. The production lifecycle has one shared project-owned
graceful-shutdown routine in the always-present `PlayerBoot` / lifecycle owner.
The real `NOTIFICATION_WM_CLOSE_REQUEST` entry calls that routine; the project
may set `auto_accept_quit=false` only where needed to route the notification
through this controlled boundary.

The shared routine:

1. stops accepting new actions;
2. uses the existing persistence boundary and completes only allowed pending
   persistence/flush work;
3. emits the exact acknowledgement line
   `shelter_project_quit_ack=true` plus retained diagnostics;
4. allows a bounded deferred/frame flush; and
5. calls `SceneTree.quit(0)` for natural exit `0`.

It does not change save/schema/checkpoint/gameplay semantics. Both the real
WM-close entry and the test-only entry call this same routine.

Automation does not synthesize `NOTIFICATION_WM_CLOSE_REQUEST` externally. The
only test transport is a fixed one-shot control file under validated isolated
HOME:

```text
user://d029-observer-control/quit.request
```

It is enabled only by exact fixed flag
`--shelter-observer-control-v1` and accepts only exact bytes:

```text
SHELTER_CONTROL_QUIT\n
```

A stale/colliding request fails preflight with rc `70` before child creation.
Malformed bytes produce diagnostic `FAIL` and no quit. Without the exact flag
there is no polling, request-file behavior or production behavior change.

After a failed or missing project ACK, exact-PID `SIGTERM` remains only a
bounded supervisor fallback. If that fallback ends the child, the supervisor
returns rc `74` and marks capture/manifest/seal ineligible; this is not the
normal graceful PASS route. If the child remains alive after the second bounded
grace, rc `75` and `BLOCKED_CHILD_STILL_RUNNING` preserve its PID/logs. No
native bridge, `SIGKILL` or `SIGABRT` is introduced.

### 7. Diagnostic failure and evidence eligibility

The current CA/certificate error is real and unresolved. It is not allowlisted,
suppressed, hidden, environment-masked, renamed benign or accepted as harmless.
Any recurrence is retained exactly, produces diagnostic failure and blocks
capture, manifest, seal and promotion.

The same rule applies to any governed error match. The source, environment or
tool cause must be repaired and the bounded gate rerun. Logging an error is not
itself permission to continue evidence production.

### 8. Nonfatal ADR-0003 recovery proof

ADR 0003 still requires deterministic recovery proof across intermediate
transaction states and a fresh-process readback. The approved proof method is:

1. author a bounded intermediate snapshot or failpoint representing the exact
   interrupted storage state without killing Godot;
2. exit the producing test normally;
3. start a fresh clean verifier process;
4. inspect and prove the required recovery/preservation outcome.

Historical `kill -9` / `OS.kill` process interruption is not retained as an
exception. A test-only nonfatal snapshot hook may be added only if it leaves
runtime/save/schema/gameplay semantics unchanged and remains inside the active
brief's conditional scope.

### 9. D-024 boundary

D-024 migrates only its exact called chain under the active brief. Its existing
unique stage, promote-or-restore and canonical evidence protections remain in
force. No native capture, manifest, seal or promotion occurs after process or
diagnostic failure.

A broader migration of unrelated wrappers requires a separate tooling brief.
This ADR does not itself activate implementation or capture.

## Consequences

- Raw Godot diagnostics survive wrapper and pipeline failures.
- A successful child exit no longer hides diagnostic failure, and a diagnostic
  failure no longer requires crashing a finite child.
- Long-lived process leaks remain visible and blocked with exact PID/logs
  instead of being erased by a hard kill.
- Recovery tests prove durable intermediate states without project-induced
  process crashes.
- Existing product, gameplay, save schema, runtime and two-path capture
  contracts remain unchanged.

## Required validation

Any implementation governed by this ADR must prove:

- byte-exact fake-child stdout/stderr retention and live mirroring;
- `ERROR` then late PASS with natural exit: process PASS, diagnostic FAIL,
  rc `73`, seal ineligible;
- exit `23` and self-`SIGTERM` retain their original outcome metadata;
- invalid project/argv fails before child creation;
- real `NOTIFICATION_WM_CLOSE_REQUEST` and exact flag-gated test trigger are
  statically wired to the same shared graceful-shutdown routine;
- no exact test flag means no control polling or behavior change; stale request
  preflight is rc `70`; malformed request bytes are diagnostic FAIL/no quit;
- exact project ACK, bounded deferred/frame flush and natural exit `0` form the
  normal long-lived PASS path;
- exact-PID SIGTERM fallback is rc `74` and seal-ineligible, while the
  TERM-resistant path is rc `75` with PID/log retention and cooperative test
  cleanup;
- static absence of SIGKILL/SIGABRT/hard-kill paths;
- exact replay/retention of the current CA diagnostic as failure;
- no capture/seal/promotion after any process or diagnostic failure;
- D-024 stage failure leaves the pinned canonical evidence tree and absent seal
  unchanged.

## Rejected alternatives

### Narrow CA-error allowlist

Rejected because the error is real and unresolved. Allowlisting would erase
the signal needed to repair the cause and would make sealed evidence dishonest.

### Crash or hard-kill as a diagnostic mechanism

Rejected because wrappers must observe Godot, not induce its crash. It also
destroys late output and can hide leaked or inconsistent child state.

### Keep `kill -9` / `OS.kill` only for recovery tests

Rejected by the user's explicit no-exception choice. Nonfatal authored
intermediate states plus a fresh verifier prove the same recovery boundary
without a project-induced crash.

### Generic executable/argv/shell supervisor

Rejected because it would bypass D-028 binary authority, expand the tool
surface and make project/GUI/headless/capture validation non-deterministic.

### Log filtering or suppression before retention

Rejected because it loses exact evidence and conflates diagnostic policy with
raw process observability.
