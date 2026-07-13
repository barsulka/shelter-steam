# STEAM_DESKTOP — Codex Brief — Background, Stall, Minimize Policy And macOS Evidence v1

Дата: 2026-07-12

Статус: accepted / ready for implementation

Владельцы постановки: Producer / Game Designer / Technical Architect / Project Manager

Владелец реализации: Codex

Roadmap task: R48-04A

Decision: D-023

Рекомендуемый уровень рассуждений Codex: **очень высокий**

---

## 0. Цель

Доказать на реальном macOS internal build принятую спокойную background policy:

```text
focused / visible-unfocused / occluded
→ уже подтверждённая dog-owned работа идёт safe 1x

minimized / OS-suspended
→ runtime может замедлиться или остановиться
→ restore ничего не догоняет

closed
→ gameplay frozen
```

Wave добавляет только bounded observability, deterministic contract tests и воспроизводимый native evidence protocol. Она не добавляет механику, offline progression, background daemon, onboarding или performance marketing claim.

Нового user/product decision не требуется: policy уже принята D-023 и First 48 Hours Scope Lock.

---

## 1. Mandatory sources

До первой записи прочитать:

```text
PROJECTS_RULES.md
AGENTS.md
steam/AGENTS.md
steam/README.md
docs/drive/Shelter/00_START_HERE/000_ROLE_CODEX.md
docs/repo/adr/README.md
docs/repo/adr/0001-use-godot-for-steam-desktop.md
docs/repo/adr/0002-game-state-as-source-of-truth.md
docs/repo/adr/0003-player-profile-persistence-boundary-and-recovery.md
docs/drive/Shelter/00_START_HERE/02_DECISIONS.md — D-023
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__First_48_Hours_Playable_Scope_Lock_v1.md
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__First_48_Hours_Playable_Roadmap_v1.md — R48-04
docs/repo/dev/performance-observability.md
docs/repo/status/CODEX_CURRENT_STATUS.md
docs/drive/Shelter/04_DEVELOPMENT/CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md
```

Relevant code: `steam/project.godot`, export presets, `play.sh`, `dev.sh`, PlayerBoot, Vertical Slice runtime, checkpoint codec and current test/check scripts.

Official engine facts may come only from matching Godot stable documentation. Exact local Godot `4.7.stable.steam.5b4e0cb0f` evidence wins over generic assumptions.

---

## 2. Accepted policy matrix

| State | Required policy | PASS meaning |
| --- | --- | --- |
| Focused + visible | safe 1x | confirmed work progresses; player gates wait |
| Visible-unfocused | same safe 1x | focus loss grants/cancels nothing and confirms nothing |
| Fully occluded, not minimized | same safe 1x | operator-labelled native case; no invented occlusion detector |
| Minimized | `0..1x` | pause/slow allowed; no state loss or restore catch-up |
| OS-suspended | paused | no wall-time replay, offline event or burst |
| Closed | frozen | profile/checkpoint/resources do not change while process is absent |
| Route/dispatch/equip gate | indefinite wait | lifecycle state never owns irreversible confirmation |

The accepted sequence-17 → Day-2 return remains an explicit next-session lifecycle transition, not elapsed-time progress. Closed equality tests use sequences 1, 30 and 33; sequence 17 is tested separately.

Allowed meaning: the game may stay beside or behind work windows; approved work continues; important decisions wait; minimize/system pause may slow or stop without loss; closed play produces and removes nothing.

Forbidden claims: guaranteed minimized/App Nap 1x, closed-app progress, all-Mac or Windows proof, zero battery cost, shipping optimization or release readiness.

---

## 3. Baseline and authority boundary

Current runtime already uses a 20 Hz logical tick (`0.05s`), at most four ticks per rendered frame, and discards excess accumulator. Maximum restore-frame simulation advance is therefore `0.20s`. It uses frame delta, while profile/checkpoint state contains no in-flight timers or elapsed closed-app time.

Missing proof: focus/window notifications, ticks/frame and discarded-stall counters, distinct native lifecycle evidence and a 30–60 minute exact exported-build report.

Godot gameplay runtime remains sole simulation authority. New observability may record only diagnostic timestamps, process frames, ticks, simulated seconds, max delta, saturation/discard counters, focus/window readback, checkpoint/order/task/event/resource digests and Godot performance counters.

`Time.get_ticks_usec()` is allowed only for evidence timestamps. It MUST NOT enter simulation delta, checkpoint, task duration, transition or persistence.

Focus/window observations MUST NOT emit gameplay events, mutate state, persist to the profile or become a second clock. Occlusion is an operator-declared label plus factual focus/window readback.

Do not enable low-processor mode or change FPS/VSync before baseline evidence. Any such experiment requires a measured before/after comparison and explicit scope expansion.

---

## 4. Functional thresholds

1. Focused, visible-unfocused and occluded eligible intervals: `simulation_seconds / eligible_wall_seconds = 0.95..1.05`.
2. Minimized/suspended interval: no minimum; ratio MUST NOT exceed `1.05`.
3. Any injected/native restore frame: at most four ticks and `0.20` simulated seconds.
4. First five real seconds after restore: at most `5.25` simulated seconds.
5. Focus/window notifications produce zero gameplay confirmation/resource/reward/order/task/progression events.
6. First Day and Day 2 ready-to-dispatch gates hold at least ten minutes without dispatch, expiry, urgency, penalty or resource/reward mutation.
7. Closed control holds at least ten minutes with semantic payload/sequence and profile SHA-256 equality, excluding external diagnostic timestamps.
8. Restored application accepts input within one second and does not crash/hang.
9. After ten-minute warm-up, the next thirty minutes have RSS net growth at most `32 MiB` and slope at most `1 MiB/min`; object/node counts do not grow monotonically.
10. Quiet/unfocused CPU samples: median at most `25%` of one logical core and p95 at most `50%` on the tested machine.

Semantic failure is `FAIL`. Missing/failing provisional CPU, memory, GPU or energy evidence is `WARN`/technical follow-up, never a hidden product PASS. Per-process GPU/power unavailable is recorded as `unavailable`; draw calls are not a substitute.

---

## 5. Implementation scope

Initial write scope:

```text
steam/scripts/prototypes/vertical_slice/vertical_slice_demo.gd
steam/tests/background_cadence/background_cadence_test_runner.tscn       # new
steam/tests/background_cadence/test_player_background_cadence.gd         # new
steam/tools/test-player-background-cadence.sh                             # new
steam/tools/capture-player-background-macos.sh                            # new only after safe isolation proof
steam/tools/check-godot.sh
steam/dev.sh                                                              # thin route only if needed
steam/README.md
docs/repo/dev/player-background-cadence.md                                # new
this brief
roadmap/current/status closeout docs
```

Conditional after baseline only: `steam/project.godot` and `steam/export_presets.cfg` for one evidence-backed setting/isolated evidence identity experiment.

Excluded initially: PlayerBoot, checkpoint/profile/store/game-system code, fixtures, connector/control/OpenAPI/MCP, art/animation/rooms, window topology/native extensions and Windows claims. Stop before expanding ownership.

---

## 6. Deterministic tests

Tests MUST NOT depend on wall clock:

- inject frame deltas `0.05`, `0.20`, `1`, `30` and `600` seconds;
- prove every stall executes at most four ticks, discards excess and starts no later catch-up loop;
- simulate focus-out/in and observed minimized/restored transitions as observability inputs only;
- prove observation changes no checkpoint/task/resource/order/gameplay-event digest;
- hold First Day/Day 2 route and dispatch gates through long synthetic intervals without auto-confirmation;
- prove Quiet Cooperative creates no order/chain/progression;
- preserve all 33-cursor, save/recovery, First Day and D-022 regressions.

Test injection is direct test code only. It is not exposed through player CLI, `play.sh`, connector/control or saves.

---

## 7. Native macOS protocol

Primary evidence uses an exact committed exported internal `.app`; a test runner alone cannot close R48-04A.

Required matrix:

1. focused visible;
2. another app focused while Shelter remains partly visible;
3. another app fully covers Shelter without minimizing;
4. Shelter minimized;
5. deliberate supplemental stall/suspend and resume;
6. restored interactive state;
7. process closed at least ten minutes;
8. reopen from accepted safe checkpoint.

One 30–60 minute report includes at least ten minutes focused, ten visible-unfocused, ten occluded and five minimized. The ten-minute closed control may be an adjacent linked interval.

Use sequence 30 for irreversible-gate hold, 33 for quiet resource sampling, and 1 or 18 for route wait. Never use fixture, connector, speed override or manual state edit as primary evidence. `SIGSTOP`/`SIGCONT` is supplemental and does not prove every App Nap/sleep case; unreproduced OS suspension is `not directly exercised`.

### Profile isolation

Automated tests use only `user://player-tests/<run-id>`. Native automation MUST NOT read, overwrite, move or delete an existing `user://player/default` profile.

Before native automation, fail closed if a production profile exists. Prefer an isolated evidence identity/root if exact exported routing can support it without player/debug argument leakage. Otherwise perform only an operator-owned ordinary-app smoke plus isolated test-runner evidence. Never silently back up or replace a real profile.

### Evidence root and retention

Exact ignored root:

```text
steam/.runtime/background_evidence/<UTC-date>_<short-commit>_<run-id>/
```

The successful bundle remains local until R48-07 or explicit cleanup. Failed/transient runs may be removed after diagnosis. Nothing is committed/published without sanitization.

Required files:

```text
manifest.json
samples.jsonl
state_invariants.json
window_transitions.jsonl
profile_before.sha256
profile_after.sha256
native_observation.md
run.log
focused.png
unfocused_visible.png
occluded.png
minimized_or_dock_evidence.png
restored.png
```

Manifest records commit and dirty state, Godot version, app executable/PCK hashes, macOS version/build, model/chip/RAM without serial/UUID/UDID, renderer, display scale/refresh, duration, sample cadence, thresholds and verdicts. Dirty builds are diagnostic only.

OS samples record CPU/RSS. Godot counters remain separate. Energy Impact/Instruments may be used when available; privileged `powermetrics` is not mandatory. Missing GPU/power remains explicit.

---

## 8. Definition of Done

- [ ] Brief accepted before implementation writes.
- [ ] Observability never becomes gameplay authority or profile state.
- [ ] Focus/window notifications create zero gameplay events/confirmations.
- [ ] Focused/visible-unfocused/occluded cadence passes `0.95..1.05` on the exact run.
- [ ] Minimized may pause/slow but never exceeds 1x or catches up.
- [ ] Restore frame remains within four ticks / `0.20s`.
- [ ] Route, dispatch and equip gates wait indefinitely in every lifecycle state.
- [ ] Closed app is byte/semantic frozen; sequence 17 remains separately causal.
- [ ] No fixture, connector, speed or debug control enters primary player evidence.
- [ ] Exact 30–60 minute committed exported-macOS report exists or acceptance remains pending.
- [ ] Existing 33-cursor/restart/SIGKILL/profile-store/First Day/Day 2 regressions pass.
- [ ] No existing production profile is read, overwritten, moved or deleted.
- [ ] No input, copy, UI, onboarding, art, room or gameplay semantics are added.
- [ ] No Windows, Steam, all-Mac, battery-life or release-performance claim is made.
- [ ] Status docs preserve R48-04B as a separate brief.

---

## 9. Required checks

```text
bash -n changed/new shell scripts
deterministic background-cadence test
33-cursor Continue matrix
profile store/recovery kill matrix
launch-surface isolation tests
First Day causal regression
D-022 Day 2 assertion/native regression
tools/check-godot.sh
git diff --check
test-root cleanup
production-profile non-mutation
ignored evidence proof
```

Native closeout also validates manifest JSON/hashes, sample count/duration, thresholds and sanitized inventory.

---

## 10. Out of scope

- R48-04B onboarding/copy/Quiet Cooperative presentation polish;
- offline simulation/reward/loss/penalty/absence/calendar;
- exact in-flight resume;
- App Nap prevention/background daemon;
- sleep/wake/reboot certification;
- Windows/Steam/release evidence;
- production performance certification;
- task-duration/order/event/input-budget changes;
- player power settings UI;
- art/animation/room work;
- connector-driven primary evidence.

---

## 11. Stop conditions

Stop if visible-unfocused 1x needs wall-clock catch-up/new task timing; minimize changes gameplay or confirms an action; restore exceeds four ticks/`0.20s`; lifecycle creates gameplay events; a second simulation/clock is needed; evidence touches an existing production profile; player evidence requires fixture/connector/dev save/speed/debug; simulation is silently disabled to improve performance; settings change without baseline; GPU/power is inferred from unsuitable counters; result is generalized beyond exact Mac/build; or scope reaches onboarding/art/room/animation/content.

---

## 12. Closeout

After functional PASS and native evidence verdict:

- record functional and performance verdicts separately;
- mark R48-04A complete only when the mandatory native report exists;
- update roadmap/current/status docs;
- make R48-04B the next unaccepted brief gate;
- record changed files, checks, evidence path, tested machine/build and unavailable measures;
- commit/push only through the designated integrator.

