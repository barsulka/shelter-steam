# STEAM_DESKTOP — Codex Brief — Playable Main Scene And Launch Surfaces v1

Дата: 2026-07-12

Статус: completed / PASS

Роль-владелец постановки: Producer / Project Manager

Roadmap task: R48-01A

Decision: D-023

Рекомендуемый уровень рассуждений Codex: **очень высокий**

---

## 0. Цель

Сделать обычный запуск Shelter настоящим player entry:

```text
F5 / Godot Project Run
steam/play.sh
internal export
→ one clean player boot contract
→ fresh profile enters First Day
```

Одновременно отделить developer launch surface:

```text
steam/dev.sh
→ existing fixtures / connector-control / captures / diagnostics
```

Задача не реализует player save. Existing-profile `Continue` становится совместным acceptance gate с R48-02B.

В этой wave `fresh profile` означает ephemeral default First Day runtime session. R48-01A не создаёт, не читает и не перезаписывает durable player profile; durable profile semantics and Continue появляются только в R48-02B.

---

## 1. Обязательные источники

### Rules / role / current state

```text
PROJECTS_RULES.md
AGENTS.md
README.md
steam/AGENTS.md
steam/README.md
docs/drive/Shelter/00_START_HERE/000_ROLE_CODEX.md
docs/repo/status/CODEX_CURRENT_STATUS.md
docs/drive/Shelter/04_DEVELOPMENT/CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md
```

### Architecture

```text
docs/repo/adr/README.md
docs/repo/adr/0001-use-godot-for-steam-desktop.md
docs/repo/adr/0002-game-state-as-source-of-truth.md
```

Read every other Accepted ADR relevant to launch/window/runtime boundaries.

### Product / game contract

```text
docs/drive/Shelter/00_START_HERE/02_DECISIONS.md
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__First_48_Hours_Playable_Scope_Lock_v1.md
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__First_48_Hours_Playable_Roadmap_v1.md
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__First_Day_MVP_v1.md
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Task_Flow_Contract_v1.md
```

### Existing implementation

Inspect current equivalents of:

```text
steam/project.godot
steam/export_presets.cfg
steam/scenes/main.tscn
steam/scripts/main.gd
steam/scenes/prototypes/vertical_slice/vertical_slice_demo.tscn
steam/scripts/prototypes/vertical_slice/vertical_slice_demo.gd
steam/launch.sh
steam/tools/dev-vertical-slice.sh
steam/scenes/launcher.tscn
```

---

## 2. Accepted scope

### 2.1 One player main route

Replace the placeholder main contract with a dedicated player boot scene/script.

PlayerBoot MUST:

- own startup intent/navigation only;
- choose the fresh-profile path for this wave;
- instantiate exactly one existing Vertical Slice runtime;
- configure player mode through an explicit API before the child runtime starts;
- force clean player presentation;
- never copy task/order/resource simulation;
- expose a stable seam for later R48-02B Continue integration.

`Fresh profile` in this section is the ephemeral default First Day runtime session only. PlayerBoot MUST perform no profile I/O in R48-01A.

F5, `steam/play.sh` and internal export MUST enter the same semantic PlayerBoot route.

### 2.2 `steam/play.sh`

Create a minimal player launcher that:

- resolves/validates `GODOT_BIN` consistently with current project conventions;
- executes Godot with the Steam project path and no explicit dev scene;
- passes no fixture, control, connector, capture, debug-view or time-acceleration semantics;
- depends on no local HTTP server or token;
- exits with the Godot process result.

`play.sh` is the human-facing way to run the game from the repository. Exported `.app` is tested directly and does not depend on this shell wrapper.

### 2.3 `steam/dev.sh`

Create a thin developer dispatcher that routes to existing specialized scripts without duplicating their behavior.

Minimum documented routes MUST retain access to:

- player-prototype dev run;
- QA/interactive Vertical Slice;
- Day 2 fixture run;
- connector/control launch;
- capture/smoke paths already supported by project tooling.

Exact subcommand names should follow current script conventions and remain bounded to Shelter dev workflows.

### 2.4 Legacy `steam/launch.sh`

Do not delete or radically rewrite it in this wave.

It remains a deprecated compatibility surface for current connector/tunnel/MCP/docs references. `dev.sh` may delegate legacy connector/tunnel behavior to it.

Removal or alias replacement requires a later repository-wide reference migration and regression.

### 2.5 Player/dev isolation

PlayerBoot MUST NOT honor dev fixture/control/debug/time-acceleration arguments.

If arbitrary user arguments reach the process, player path must ignore or reject them before runtime configuration.

Direct dev scene launch may continue to use existing flags through `dev.sh` and specialized tools.

---

## 3. Explicit out of scope

- player save file I/O;
- functional Existing-profile Continue;
- New Game overwrite/recovery UI;
- First Day → Day 2 persisted transition;
- task/order/resource behavior changes;
- First Day content or input-budget changes;
- window/platform policy changes;
- production art, dog animation or Kitchen implementation;
- MCP/security refactor;
- deleting legacy launch/tunnel tooling;
- Steam integration or packaging readiness.

### D-023 intermediate honesty

R48-01A makes the existing First Day runtime reachable through a clean player route; it does not by itself prove full D-023 First Day semantics. Current runtime alignment still belongs to later waves:

- accepted `x2/x2` initial reserve enters the runtime/checkpoint alignment wave;
- exact three-confirmation onboarding alignment enters R48-04B;
- durable profile and Continue enter R48-02B.

R48-01A evidence MUST be labelled player-entry evidence, not full First Day + Day 2 playable proof.

---

## 4. Expected implementation shape

Preferred responsibility split:

```text
PlayerBoot
  startup intent + scene composition
  no gameplay simulation

VerticalSliceDemo
  existing single gameplay authority
  explicit configure_player_session(...) seam

play.sh
  player route only

dev.sh
  developer dispatcher only

launch.sh / tools/*
  retained specialized implementations
```

Do not add a third gameplay/runtime path.

---

## 5. Expected change areas

Exact initial write scope:

```text
steam/project.godot
steam/scenes/player/player_boot.tscn           # new
steam/scripts/player/player_boot.gd            # new
steam/play.sh                                  # new
steam/dev.sh                                   # new
steam/scripts/prototypes/vertical_slice/vertical_slice_demo.gd
steam/tests/launch_surfaces/**                  # new bounded tests
steam/README.md
docs/repo/status/CODEX_CURRENT_STATUS.md
docs/repo/status/CODEX_STATUS.md
docs/drive/Shelter/04_DEVELOPMENT/CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md
```

Excluded unless a concrete regression forces a separately declared scope expansion:

```text
steam/launch.sh
steam/tools/dev-vertical-slice.sh
steam/scenes/main.tscn
steam/scripts/main.gd
steam/export_presets.cfg
steam/scripts/game_systems/game_systems_runtime.gd
steam/resources/game_systems/fixtures/**
.codex/config.toml
```

`dev.sh` should delegate to existing routes without editing their implementations. If an excluded file becomes necessary, stop and report the exact need before writing it.

Before writing, Codex must inspect `git status` and declare exact ownership. Preserve unrelated `.codex/config.toml`, docs and parallel changes.

---

## 6. Acceptance criteria

### Normal entry

- [ ] F5 / Project Run no longer opens the `Shelter` placeholder.
- [ ] `steam/play.sh` enters the same clean PlayerBoot route.
- [ ] Internal export opens the same semantic player route.
- [ ] Ephemeral fresh-session startup enters default First Day without profile I/O or terminal fixture/control actions.
- [ ] Player presentation contains no debug labels, assertion panels, perf HUD or connector affordances.

### Developer entry

- [ ] `steam/dev.sh` documents and routes the required dev modes.
- [ ] Existing fixture/capture/connector workflows remain available.
- [ ] `steam/launch.sh` compatibility is preserved.

### Authority and isolation

- [ ] Only one Vertical Slice gameplay runtime exists.
- [ ] PlayerBoot owns no tasks/resources/orders/dogs simulation.
- [ ] Player path starts no connector/control service.
- [ ] Fixture/control/debug/speed arguments cannot alter F5/`play.sh` behavior.
- [ ] First Day causal regression remains green.

### Joint gate note

- [ ] A stable Continue/profile-store integration seam exists.
- [ ] R48-01 is not marked fully closed until R48-02B proves functional Continue.

---

## 7. Required checks and evidence

At minimum:

```text
bash -n steam/play.sh
bash -n steam/dev.sh
bash -n steam/launch.sh
bash -n steam/tools/dev-vertical-slice.sh
```

Additionally:

- mocked `GODOT_BIN` argv/routing tests for `play.sh` and `dev.sh`;
- headless default-main smoke;
- native F5/Project Run first-moment capture;
- native `play.sh` smoke;
- real exported macOS `.app` first-moment smoke; this is mandatory to close R48-01A. If export templates/tooling are unavailable, code may be implemented but acceptance remains pending rather than waived;
- negative fixture/control/debug/speed leakage tests;
- existing Vertical Slice and First Day regressions;
- `git diff --check`;
- confirmation that evidence remains untracked/ignored.

---

## 8. Stop conditions

Stop before coding or during implementation if:

- PlayerBoot requires a copy of the task/order/resource loop;
- the current runtime cannot be configured before `_ready` without a broader architecture decision;
- player path must depend on connector/control or tokenized local URLs;
- required dev flags cannot be isolated from player path;
- preserving `launch.sh` compatibility conflicts with the clean player route;
- window semantics or native topology must change;
- Existing-profile Continue is being improvised without R48-02;
- an unexpected concurrent change appears in owned files;
- a new enduring architecture rule is required without ADR review.

Return the concrete conflict to the owning role; do not widen scope.

---

## 9. Documentation/status closeout

After implementation:

- update `steam/README.md` with `play.sh` vs `dev.sh`;
- update Codex current/detailed status and implementation current context;
- record the R48-01A result and remaining joint R48-02B gate;
- do not mark First Day + Day 2 playable complete;
- list exact checks, native evidence and known limitations.

---

## 10. Preflight outcome

Producer and Game Design preflight: PASS.

Technical/Codex preflight: PASS after the wording and scope corrections now incorporated.

Implementation is authorized only for the exact initial write scope above, under one assigned integrator. The implementation session MUST still:

- inspect `git status` before writing;
- declare ownership back to the coordinating session;
- stop on any excluded-file need or unexpected concurrent change;
- preserve all unrelated PM/docs and `.codex/config.toml` changes.

---

## 11. Implementation outcome

R48-01A completed / PASS on 2026-07-12.

Implemented:

- `project.godot` now opens one `PlayerBoot` main scene;
- PlayerBoot configures one existing Vertical Slice runtime before it enters the tree;
- F5, `steam/play.sh` and the macOS internal export use the same clean player route;
- `steam/dev.sh` delegates bounded fixture/connector/capture/smoke routes while legacy `launch.sh` remains compatible;
- hostile dev arguments cannot change the player runtime, start a connector or enable QA/debug/fast/capture state.

Verified:

- shell routing/syntax and exit-code behavior;
- headless default-main and pre-ready/one-runtime isolation tests;
- First Day, connector/control and Day 2 dev-route regressions;
- full Godot project checks;
- native `play.sh` 3456×224 player-window readback;
- real macOS `.app` export and exported-binary main-route smoke;
- no player profile file, fixture fallback or tracked evidence artifact.

R48-01 remains a joint gate: durable Continue is still pending R48-02B. Current visuals remain prototype placeholders, and D-023 initial-reserve/input alignment remains in later accepted waves.
