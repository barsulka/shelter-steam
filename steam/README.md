# Shelter Steam/Desktop

Shelter Steam/Desktop is the Windows/macOS Godot version of Shelter: a calm idle production strip about dogs, shelters, care, and transparent charity-oriented product design.

The current product direction is D-009: a horizontal dog production cooperative, or `cozy idle production strip + dog community sim`, where dogs grow or receive peaceful ingredients, prepare food, pack bags, store them, and send a van to partner shelters.

This directory is intentionally scoped to the Steam/Desktop product inside the Shelter monorepo. Mobile and browser-extension ideas may share product research, content, economy concepts, or backend contracts later, but they are not part of this Godot project by default.

## Current Stage

The project is at the initial Godot bootstrap, desktop-window tech-demo, and first playable Vertical Slice prototype stage. The repository contains a minimal loadable Godot project, local development notes, companion-window probes, dog-runtime spikes, and an isolated prototype scene for the first Steam/Desktop loop.

No final gameplay architecture, production art, charity flow, Steam integration, or production desktop window behavior has been implemented yet.

## Technology

- Engine: Godot 4.x.
- Verified local engine: `4.7.stable.steam.5b4e0cb0f`.
- Initial gameplay language: GDScript.
- C# or GDExtension should be introduced only for a concrete need such as Steamworks, native desktop window APIs, or performance-critical subsystems.

Default Steam Godot binary on this machine:

```sh
$HOME/Library/Application\ Support/Steam/steamapps/common/Godot\ Engine/Godot.app/Contents/MacOS/Godot
```

For scripts, prefer:

```sh
export GODOT_BIN="$HOME/Library/Application Support/Steam/steamapps/common/Godot Engine/Godot.app/Contents/MacOS/Godot"
tools/check-godot.sh
```

## Play

Use the ordinary player route for day-to-day play:

```sh
./play.sh
```

Godot Project Run / F5, `./play.sh`, and internal exports all enter the same
`PlayerBoot` main scene. This route creates one existing Vertical Slice runtime
in clean player presentation. A fresh run creates a strict player profile at the
first durable First Day checkpoint; later launches offer calm `Продолжить` or
`Вернуться в кооператив` lifecycle actions before the runtime is instantiated.

`play.sh` accepts no arguments. It never loads fixtures or dev saves, starts no
connector/control server, enables no capture/debug mode, and applies no speed
override. Set `GODOT_BIN` when Godot is not installed at the default path.

## Develop

Use the bounded developer dispatcher for prototype inspection and diagnostics:

```sh
./dev.sh                         # player-prototype dev scene
./dev.sh qa                      # QA/interactive Vertical Slice
./dev.sh day2                    # accepted Day 2 fixture
./dev.sh connector               # legacy connector/control launcher
./dev.sh capture --scenario=first_delivery_from_empty
./dev.sh smoke
./dev.sh --help
```

`dev.sh` delegates to existing specialized scripts; it does not duplicate their
fixture, connector, capture, or smoke implementations. Direct scripts under
`tools/` remain valid for specialized workflows.

`launch.sh` remains a deprecated compatibility surface for existing local
connector, tunnel, MCP, and documentation workflows. It is developer tooling,
not the ordinary player entry:

```sh
./dev.sh connector --url
./dev.sh connector --barsulka --start
./dev.sh connector --cloudflared --start
./dev.sh connector --exit
```

Arguments passed to `dev.sh` are developer-only and never alter the F5/`play.sh`
player route.

## Player profile and First Day Continue

R48-02A provides the isolated profile store under `user://player/default/`.
R48-02B connects it to PlayerBoot and the single Vertical Slice runtime through
the strict `PlayerCheckpointV1` contract. The runtime persists exactly seventeen
semantic First Day cursors; it never stores task steps, timers, positions,
floats, dev fixtures or connector state.

Fresh First Day now begins with `Protein Packet x2` and `Packaging Bag x2`.
One of each is physically consumed, leaving the accepted Day 2 remainder
`x1/x1`. Delivery makes the slippers immediately available, so the ordinary
First Day still has exactly three gameplay confirmations: trip, dispatch and
equip. There is no separate player-facing `Получить тапочки` progression click.

Closing during automatic work restores the preceding durable semantic cursor
and replays at most that interrupted task. Every new cursor passes a synchronous
persistence acknowledgement barrier before the next task or gate can advance.
Store failure pauses the world calmly and offers one explicit
`Повторить сохранение` action; there is no periodic or wall-clock retry.

An incomplete First Day profile offers `Продолжить`. A fully complete profile
offers `Вернуться в кооператив` and restores a calm First Day complete hold.
R48-02B deliberately does not create Day 2; the organic one-time return
transition remains R48-03.

Run the isolated schema, transaction, recovery, ordinary restart and forced
kill/restart matrices with:

```sh
tools/test-player-profile-store.sh
tools/test-player-checkpoints.sh
tools/test-player-continue.sh
```

The test runner uses only one fresh `user://player-tests/<run-id>/` root, fails
fast on collisions or the production profile path, and removes that exact root
on success, failure, or interruption. The player store never
falls back to `.runtime`, fixtures or connector snapshots. Exact paths, the
integer-only canonical JSON contract, seventeen-cursor checkpoint matrix and
recovery/Continue precedence are documented in
`../docs/repo/dev/player-profile-persistence.md`.

Automated launch-surface and full-project checks instantiate PlayerBoot through
the same pre-tree API with an isolated `user://player-tests/<run-id>/` store.
They never run the default main scene against `user://player/default`; native
F5/`play.sh` evidence is a separately declared manual internal-profile check.

## Project Layout

- `project.godot` - Godot project configuration.
- `play.sh` - ordinary player entry, matching Godot Project Run and export.
- `dev.sh` - bounded dispatcher for developer fixtures, captures and diagnostics.
- `launch.sh` - deprecated connector/tunnel compatibility surface.
- `.agents/skills/` - repo-local Codex skills for this product.
- `scenes/` - Godot scenes.
- `scripts/` - GDScript files.
- `../docs/repo/adr/` - architecture decisions.
- `../docs/repo/dev/` - development notes and technical spikes.
- `../docs/repo/status/CODEX_STATUS.md` - Codex working status after meaningful tasks.

## Validation

Run the bootstrap checks with:

```sh
tools/check-godot.sh
```

Or run the core commands manually:

```sh
"$GODOT_BIN" --version
"$GODOT_BIN" --headless --path . --import
"$GODOT_BIN" --headless --path . --quit-after 2
"$GODOT_BIN" --headless --path . --check-only --script res://scripts/main.gd
git status --short
```

Run the desktop window spike with:

```sh
tools/dev-window-spike.sh visible
tools/dev-window-spike.sh companion
tools/dev-window-spike.sh smoke
```

Run the first companion field tech demo for manual testing with:

```sh
tools/dev-companion-field.sh
```

Run the first Steam/Desktop Vertical Slice prototype with:

```sh
tools/dev-vertical-slice.sh
tools/dev-vertical-slice.sh smoke
```

Run the dev-only Godot State Connector for the Vertical Slice with:

```sh
tools/dev-vertical-slice.sh connector
tools/dev-vertical-slice.sh connector-smoke
tools/dev-vertical-slice.sh runtime-foundation-smoke
```

Run a file-based Workbench runtime capture for Game Designer review:

```sh
tools/dev-vertical-slice.sh workbench-capture \
  --scenario=first_delivery_from_empty \
  --game-seconds=180 \
  --sample-every-game-seconds=10 \
  --speed=100 \
  --output-dir=.runtime/workbench_capture_runs/first_delivery_from_empty_v0
```

The capture bundle is written under `.runtime/workbench_capture_runs/<run_id>/`
and includes `manifest.json`, `snapshots.jsonl`, `events.jsonl`,
`stress_signals.jsonl`, `fixture_initial_state.json`, `return_state.json`,
`final_state.json`, and `run.log`.

Create the persistent First Day MVP visible/player-feel review pack:

```sh
tools/dev-vertical-slice.sh first-day-visible-capture
tools/dev-vertical-slice.sh first-day-art-ux-capture
```

Create the ignored local Day 2 prototype/product-language evidence pack:

```sh
tools/dev-vertical-slice.sh day-2-visible-capture
```

It writes six named native 1x screenshots, a normal-speed PNG-frame sequence,
and an independent machine-readable state proof under
`.runtime/workbench_capture_runs/day2_return_and_second_delivery_v1/`. The pack
proves the calm return tableau, Labrador's existing PackTask care moment, van
readiness, player-confirmed dispatch, progress note, optional curiosity question
and quiet end. It is not production art, final animation, shipping UX or a
desktop-platform acceptance pack.

The current Art / UX visual-language pack is written under
`../docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v3/`
and includes named screenshots, a normal-speed PNG-frame sequence, a short
postcard/slippers PNG-frame sequence, README, `CAPTURE_MANIFEST_v3.md`, and
matching Workbench state proof artifacts. This v3 pass keeps First Day gameplay
unchanged and shifts prototype readability toward object/state cues for dog
roles, payload flow, van readiness, postcard board, Такса-owned slippers, and
the next-day note.

The previous readability pack remains available under
`../docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v2/`
and includes named screenshots, a PNG-frame sequence, README,
`CAPTURE_MANIFEST_v2.md`, and matching Workbench state proof artifacts. The
v2 pass adds prototype-level strip cues for first driver/helper roles,
route/payload/van/postcard/reward/next-day readability, and review-only marker
events. This is review evidence only, not final visual acceptance.

ChatGPT Work/Codex reads the monorepo checkout directly. Shelter MCP is useful
only when domain-specific Steam inspection/control is needed and its local
adapter is configured:

```text
../mcp/
```

Shelter MCP is a local Go MCP server inside the monorepo that wraps whitelisted
Steam/Desktop dev commands, including `workbench-capture`, capture-run listing/reading/cleanup,
local Godot State Connector control runtime start/stop, selected runtime control
actions, and bounded knowledge navigation. It is not the primary filesystem
path or a generic shell. Direct `launch.sh` and `tools/dev-vertical-slice.sh`
commands remain valid local dev workflows.

The project-scoped local setup is `.codex/config.toml` plus `mcp/run.sh` over
STDIO from the monorepo.

Run the explicit dev-only control connector with Hide / Show window controls:

```sh
STATE_CONNECTOR_TOKEN="$(uuidgen)" tools/dev-vertical-slice.sh connector-control
tools/dev-vertical-slice.sh connector-control-smoke
```

To expose the already running launcher process through the Barsulka SSH reverse
tunnel for ChatGPT inspection, run:

```sh
./launch.sh --barsulka --start
```

If the local game is not already running, this command starts it first. Then it
prints the public URL after the tunnel becomes healthy and keeps the game plus
tunnel alive in the same terminal. If you need to print the URL again from
another terminal, run:

```sh
./launch.sh --barsulka
```

To stop the Barsulka tunnel and shut down only the local HTTP connector while
leaving the Godot game process alive:

```sh
./launch.sh --barsulka --stop
```

To stop any launcher-started tunnels, the local HTTP connector, and the Godot
game together:

```sh
./launch.sh --exit
# or
./launch.sh --shutdown
```

Cloudflared remains available as a backup:

```sh
./launch.sh --cloudflared --start
./launch.sh --cloudflared
```

If the local game is not already running, `--cloudflared --start` starts it
first, then prints the Cloudflare URL after the tunnel URL is published.

Connector endpoints:

```text
http://127.0.0.1:8765/health
http://127.0.0.1:8765/schema
http://127.0.0.1:8765/state
http://127.0.0.1:8765/control?token=...
```

The control API also exposes dev-only viewport capture endpoints:

```text
POST /control/capture/screenshot
POST /control/capture/video/start
GET  /control/capture/video/status
GET  /control/capture/files/<file_id>
```

The control API also exposes token-protected dev-only runtime foundation
actions for accepted design testing:

```text
GET  /control/runtime/fixtures
POST /control/runtime/fixture/load
POST /control/runtime/speed
POST /control/runtime/state/export
POST /control/runtime/state/import
POST /control/runtime/state/clear
POST /control/runtime/save/write
POST /control/runtime/save/load
POST /control/runtime/save/erase
POST /control/runtime/route/start
POST /control/runtime/delivery/confirm
POST /control/runtime/dog/assign
POST /control/runtime/research/start
POST /control/runtime/debug/tick
```

Runtime fixtures live under:

```text
resources/game_systems/fixtures/
```

The dev local runtime save lives under ignored runtime storage:

```text
.runtime/game_systems_runtime/local_save.json
```

The short video capture is a bounded 10 second PNG-frame sequence at 2 FPS,
shown inline on the control page after recording. Captured PNG bytes live in
connector memory; temporary PNG files are deleted immediately after encoding.
This is not a default `--write-movie` recording of the whole game session.

Workbench runtime capture uses the same dev-only runtime control surface and can
set speed up to `100x` for local JSON capture/testing. `100x` is not a
player-facing speed and must not be used as visual/readability/feel acceptance.
The accepted full first-delivery capture scenario is:

```sh
tools/dev-vertical-slice.sh workbench-capture \
  --scenario=first_delivery_with_dispatch_confirmation \
  --fixture=first_day_empty_coop \
  --game-seconds=420 \
  --sample-every-game-seconds=10 \
  --speed=100 \
  --output-dir=.runtime/workbench_capture_runs/first_delivery_with_dispatch_confirmation_v0
```

That scenario confirms dispatch through the narrow
`POST /control/runtime/delivery/confirm` action only after the live runtime has
reached `ready_to_dispatch` / `waiting_for_player_confirmation`.
Its `manifest.json` includes `first_day_mvp_proof`, which checks high-level dog
action events, first-day postcard/memory/next-day-hint state, delivered Food Bag
semantics, legacy `production_chain` consistency and clean debug event tagging.

The accepted Day 2 continuation state proof is:

```sh
tools/dev-vertical-slice.sh workbench-capture \
  --scenario=second_warm_delivery_after_first_day \
  --fixture=second_day_after_first_delivery \
  --game-seconds=24 \
  --sample-every-game-seconds=0.2 \
  --speed=1 \
  --output-dir=.runtime/workbench_capture_runs/day2_state_evidence_v1
```

Its `day2_scenario_proof` verifies the immutable `first_day_history`, separate
`active_order` / `active_chain`, exact status/state sequences, existing physical
route and task causality, order-tagged events, Labrador PackTask ownership, the
absence of a second postcard/reward/equip flow, and the progress-note/question
ordering. `runtime.delivery.confirm` remains a narrow action: it can confirm only
the accepted active First Day or Day 2 warm-delivery order already waiting at
`ready_to_dispatch`; it cannot select or mutate an arbitrary order.

The fallback snapshot file is written to `.runtime/godot_state_connector/state_snapshot.json`.
Its default file write interval is 5 seconds and can be changed with
`STATE_CONNECTOR_INTERVAL=10 ./launch.sh`.

Narrow diagnostic presets are still available through dev helpers:

```sh
tools/dev-companion-field.sh normal
tools/dev-companion-field.sh click-through
tools/dev-companion-field.sh perf
tools/dev-companion-field.sh dog-runtime
tools/dev-companion-field.sh dog-runtime-smoke
tools/dev-companion-field.sh smoke
```

Run the Dog Rig Spike v0 proof with:

```sh
tools/dev-dog-rig.sh
tools/dev-dog-rig.sh smoke
tools/dev-dog-rig.sh stress
tools/dev-dog-rig.sh stress-smoke
tools/dev-dog-rig.sh pipeline
tools/dev-dog-rig.sh pipeline-smoke
tools/dev-dog-rig.sh hybrid
tools/dev-dog-rig.sh hybrid-smoke
tools/dev-dog-rig.sh hybrid-companion-perf
tools/dev-dog-rig.sh hybrid-companion-smoke
```

Optional prototype dog presets are available for manual morphology checks:

```sh
tools/dev-dog-rig.sh bublik
tools/dev-dog-rig.sh knopka
tools/dev-dog-rig.sh mishka
```

## Product Boundaries

Shelter should stay warm, calm, ethical, and focused on dogs and shelters.

Do not add combat, PvP, bosses, monsters, paid gacha, advertising monetization in Steam, manipulative dark patterns, or predatory monetization. Charity-related mechanics must remain voluntary, clear, and non-coercive.

Do not implement Browser Extension concepts in this repo: no Chrome new-tab layout, browser search bar, sponsorship/ad block, rewarded ads, or extension-specific UX.

Desktop-specific work should treat performance as a product requirement: avoid unnecessary `_process()` loops, constant redraws, heavy visual effects, memory leaks, and avoidable battery drain.
