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

## Launch

Use the main launcher for day-to-day manual runs:

```sh
./launch.sh
./launch.sh -- --runtime-load-fixture=warm_food_delivery_mid_chain
./launch.sh -- --runtime-load-save
./launch.sh --exit
```

The main launcher starts the playable Vertical Slice and always enables the local
dev-only connector/control HTTP server. Lookup flags never start new processes:

```sh
./launch.sh --url                  # print local URLs for the already running game
./launch.sh --exit                 # stop tunnels, local HTTP connector, and Godot game
./launch.sh --shutdown             # alias for --exit
./launch.sh --barsulka --start     # start/reuse game, then start SSH reverse tunnel through barsulka.eboshim.site
./launch.sh --barsulka             # optional lookup: reprint the already running Barsulka URL
./launch.sh --barsulka --stop      # stop Barsulka tunnel and local HTTP connector, keep Godot running
./launch.sh --cloudflared --start  # backup: start/reuse game, then start cloudflared
./launch.sh --cloudflared          # backup: print the already running Cloudflare URL
./launch.sh --launcher             # open the legacy visual launcher without connector
```

Arguments after `--` are forwarded to the Vertical Slice scene. Runtime test
startup flags are dev-only:

```sh
./launch.sh -- --runtime-load-fixture=house_of_curiosity_learning_session
./launch.sh -- --runtime-load-save
```

For the one-terminal public inspection flow, run `./launch.sh --barsulka --start`.
It starts the local game when needed, prints the public URL, and keeps both the
game and tunnel alive in that terminal. `./launch.sh --cloudflared --start` does
the same through Cloudflare as a backup. Keep the terminal that starts
`./launch.sh`, `./launch.sh --barsulka --start`, or
`./launch.sh --cloudflared --start` open while that process is in use.
Use `./launch.sh --exit` from another terminal for a soft full shutdown of
launcher-started tunnels, the local connector, and the Godot game.
`./launch.sh --shutdown` is the same command with a more explicit name.

Scripts under `tools/` are dev helpers. They are named `dev-*` when they launch
prototype diagnostics, smoke checks, capture modes, or compatibility helpers.

## Project Layout

- `project.godot` - Godot project settings.
- `launch.sh` - main manual game entry point with local connector/control server.
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
