# Godot State Connector

Дата: 2026-06-30
Статус: v0.2 dev-only observability/control bridge for Steam Vertical Slice prototype runtime foundation

## Purpose

Godot State Connector v0.2 lets external tools inspect the live state of the running Steam Vertical Slice prototype and perform narrow, accepted dev-only runtime test actions.

It is not a standalone simulator and not a second game model. Godot remains the source of truth for task flow, dog state, resources, queues, order progress, runtime fixtures, local prototype saves and events.

## Target Architecture Note

Long-term direction: Shelter gameplay should run as in-memory game/simulation state, while UI, save files, snapshots and external inspectors are state views.

Example: if a dog slowly walks from one world anchor to another, that movement should be owned by the game/simulation state and its timing rules. The rendered game UI, JSON snapshot, save file and ChatGPT inspector should only read or present that state.

This v0.2 connector now reads a first extracted runtime scaffold in `steam/scripts/game_systems/game_systems_runtime.gd`, while the current Vertical Slice task loop still lives in `vertical_slice_demo.gd`. UI, JSON exports, local saves and HTTP responses remain views over the running Godot state.

## Local Shelter MCP adapter

ChatGPT Work/Codex reads the monorepo checkout directly. Shelter MCP is an
optional local domain-specific adapter when external inspection/control tools
are useful:

```text
mcp/
```

Shelter MCP is a local Go MCP server for Shelter Steam/Desktop dev workflows. It
does not expose a generic shell. It exposes whitelisted MCP tools for:

- running Shelter dev commands, including Workbench Runtime Capture;
- listing, reading and clearing workbench capture runs;
- starting and stopping a local Godot State Connector control runtime;
- whitelisted runtime control actions through the connector HTTP API;
- bounded deterministic project-knowledge navigation where useful.

It is not a generic shell or source of gameplay
truth. Godot remains runtime truth; repository documents remain project truth.

Direct `steam/launch.sh`, `tools/dev-vertical-slice.sh`, Barsulka and Cloudflare
flows remain separate runtime/debug workflows.

The current local setup is project-scoped `.codex/config.toml` plus
`mcp/run.sh` over STDIO. Keep local env files, generated binaries, logs, tokens
and capture outputs out of Git.

## Launch

Recommended human-facing launch:

```sh
cd steam
./launch.sh
./launch.sh -- --runtime-load-fixture=warm_food_delivery_mid_chain
./launch.sh -- --runtime-load-save
./launch.sh --url
./launch.sh --exit
./launch.sh --shutdown             # alias for --exit
./launch.sh --barsulka --start
./launch.sh --barsulka              # optional lookup: reprint the running Barsulka URL
./launch.sh --cloudflared --start
./launch.sh --cloudflared           # optional lookup: reprint the running Cloudflare URL
```

`./launch.sh` starts the playable Vertical Slice with the local connector/control
server. Arguments after `--` are forwarded to the Godot scene, including
`--runtime-load-fixture=<id>` and `--runtime-load-save`. `--url` is lookup-only
and never starts a process. `--barsulka --start` starts the local game first
when needed, then starts the SSH reverse tunnel to `barsulka.eboshim.site`,
prints the public URL after health check, and keeps the game plus tunnel alive
in the same terminal. `--barsulka` is lookup-only and prints the already running
public URL again.

`--cloudflared --start` is the backup one-terminal public inspection command:
it starts the local game when needed, starts Cloudflare, prints the public URL
after the tunnel URL is published, and keeps the game plus tunnel alive in the
same terminal.

`./launch.sh --exit` is the soft full shutdown command: it stops launcher-started
Cloudflare and Barsulka tunnels if present, asks the local connector to stop
through the token-protected control API when possible, then stops the Godot game
process. `./launch.sh --shutdown` is an alias for the same behavior.

Cloudflared remains available as a backup:

```sh
cd steam
./launch.sh --cloudflared --start
./launch.sh --cloudflared
```

Run the Vertical Slice with the local read-only connector:

```sh
cd steam
tools/dev-vertical-slice.sh connector
```

Default local endpoint:

```text
http://127.0.0.1:8765/health
http://127.0.0.1:8765/schema
http://127.0.0.1:8765/state
```

Run the smoke check:

```sh
cd steam
tools/dev-vertical-slice.sh connector-smoke
tools/dev-vertical-slice.sh runtime-foundation-smoke
```

The connector smoke check starts headless Godot, verifies `/health`, `/schema`, `/state`, verifies the fallback snapshot file, then polls live `/state` until the Vertical Slice loop reaches `chain_complete=true` and confirms D-010 innate/equipment separation.

The runtime foundation smoke check runs a fuller localhost acceptance loop:
masked unauthorized `404`, fixture list/load, speed set, export/import, clear,
local save write, route start, dog assignment, House of Curiosity research,
bounded debug tick, restart from local save and save erase.

## Dev Control Mode

Control mode is an explicit dev-only extension. The human-facing `./launch.sh`
starts the playable Vertical Slice with local control enabled. The lower-level
`tools/dev-vertical-slice.sh connector` mode remains read-only for focused smoke
and diagnostic checks.

OpenAPI contract:

```text
docs/repo/api/godot-state-connector.openapi.yaml
```

Run the Vertical Slice with the token-protected control surface:

```sh
cd steam
STATE_CONNECTOR_TOKEN="$(uuidgen)" tools/dev-vertical-slice.sh connector-control
```

Control endpoints:

```text
GET  http://127.0.0.1:8765/control?token=...
GET  http://127.0.0.1:8765/control/capabilities?token=...
POST http://127.0.0.1:8765/control/ui/hide?token=...
POST http://127.0.0.1:8765/control/ui/show?token=...
POST http://127.0.0.1:8765/control/ui/toggle?token=...
POST http://127.0.0.1:8765/control/capture/screenshot?token=...
POST http://127.0.0.1:8765/control/capture/video/start?token=...
GET  http://127.0.0.1:8765/control/capture/video/status?token=...
GET  http://127.0.0.1:8765/control/capture/files/<file_id>?token=...
GET  http://127.0.0.1:8765/control/runtime/fixtures?token=...
POST http://127.0.0.1:8765/control/runtime/fixture/load?token=...
POST http://127.0.0.1:8765/control/runtime/speed?token=...
POST http://127.0.0.1:8765/control/runtime/state/export?token=...
POST http://127.0.0.1:8765/control/runtime/state/import?token=...
POST http://127.0.0.1:8765/control/runtime/state/clear?token=...
POST http://127.0.0.1:8765/control/runtime/save/write?token=...
POST http://127.0.0.1:8765/control/runtime/save/load?token=...
POST http://127.0.0.1:8765/control/runtime/save/erase?token=...
POST http://127.0.0.1:8765/control/runtime/route/start?token=...
POST http://127.0.0.1:8765/control/runtime/delivery/confirm?token=...
POST http://127.0.0.1:8765/control/runtime/dog/assign?token=...
POST http://127.0.0.1:8765/control/runtime/research/start?token=...
POST http://127.0.0.1:8765/control/runtime/debug/tick?token=...
POST http://127.0.0.1:8765/control/connector/http/stop?token=...
```

`/control` serves a small HTML dev page with a single Toggle button for window
visibility plus viewport capture buttons. `ui.hide`, `ui.show`, and runtime
actions remain API methods, but are not broad generic visible command controls
on the page. The page contains no gameplay simulation and only sends
whitelisted commands back to the running Godot scene.

The control page shows an explicit command status line such as
`Done: ui.hide; window_visible=false` and disables buttons while a command is in
flight, so remote agents can tell whether a click actually sent a command.

Security behavior:

- control mode is opt-in;
- control endpoints require a token;
- missing or invalid token on `/control*` returns masked `404 not_found`, not `401`;
- public `/health` does not include tokenized URLs or control details;
- v0.2 control commands are limited to window/interface visibility, dev-only
  viewport capture and accepted local prototype runtime test actions;
- runtime save actions write only the local prototype JSON save under
  `steam/.runtime/game_systems_runtime/local_save.json`;
- there is no generic command execution, shell access, arbitrary filesystem
  command, arbitrary task/resource edit or production save-file edit.

macOS note: the hide command does not rely only on Godot `Window.hide()`.
On the tested Steam Godot build, `Window.hide()` could update logical state
without removing the native window from the screen. The connector now applies a
minimized/offscreen fallback and repeats the hide operation even when the logical
state is already hidden.

`connector.http.stop` is used by `./launch.sh --barsulka --stop`. It stops the
local HTTP listener after returning its response, but leaves the Godot game
process and in-memory gameplay state running. It is token-protected and not
exposed as a visible button on the control page.

### Dev viewport capture

The running Godot scene can capture its own visible viewport through the control
contract:

- `capture.screenshot` saves one PNG and returns a tokenized `file_url`.
- `capture.video.start` starts a fixed 10 second PNG-frame sequence at 2 FPS
  (20 target frames).
- `capture.video.status` returns progress and tokenized frame URLs.
- `GET /control/capture/files/<file_id>` downloads a captured PNG.
- The control page has `Screenshot` and `Record 10s` buttons. A screenshot is
  displayed inline; a completed frame sequence is displayed as an inline preview
  animation plus a strip of frames.

This v0 video API deliberately records a low-FPS PNG sequence instead of a
movie file. It is meant for ChatGPT/Codex inspection and short screencast-like
diagnostics without putting sustained load on the always-running game.

Captured PNG bytes are kept in memory by the running Godot HTTP connector. The
implementation uses a temporary PNG file only as a Godot-native encoding bridge:
save viewport PNG, read bytes into memory, then delete the temporary file.
Starting a new frame-sequence capture clears the previous sequence from memory.

Godot Movie Maker / `--write-movie` is not enabled in `./launch.sh`: it starts
recording when the project starts and stops when the project exits, so using it
for every normal launcher session would record the whole session. If true MP4
output is needed later, add a separate bounded capture command or process, not
the default launcher path.

Run the control smoke check:

```sh
cd steam
tools/dev-vertical-slice.sh connector-control-smoke
```

The smoke check verifies token masking, `/control`, `/control/capabilities`,
that Hide / Show remain API commands without page buttons, and that `/health`
and `/state` stay available after hiding the window.

## Game Systems Runtime Foundation

Runtime scaffold code:

```text
steam/scripts/game_systems/game_systems_runtime.gd
```

Fixtures:

```text
steam/resources/game_systems/fixtures/first_day_empty_coop.json
steam/resources/game_systems/fixtures/warm_food_delivery_mid_chain.json
steam/resources/game_systems/fixtures/house_of_curiosity_learning_session.json
```

Local prototype save:

```text
steam/.runtime/game_systems_runtime/local_save.json
```

`steam/.runtime/` is ignored by Git. The local runtime save is for design/dev
testing only; it is not the final player save format.

Useful local commands:

```sh
cd steam
STATE_CONNECTOR_TOKEN="$(uuidgen)" tools/dev-vertical-slice.sh connector-control
STATE_CONNECTOR_TOKEN="$(uuidgen)" tools/dev-vertical-slice.sh connector-control --runtime-load-fixture=house_of_curiosity_learning_session
STATE_CONNECTOR_TOKEN="$(uuidgen)" tools/dev-vertical-slice.sh connector-control --runtime-load-save
tools/dev-vertical-slice.sh runtime-foundation-smoke
```

Runtime `/state` top-level groups:

- `game`
- `dogs`
- `routes`
- `production_chains`
- `buildings`
- `rooms`
- `house_of_curiosity`
- `economy`
- `events`
- `debug`

Legacy compatibility groups are still present for existing Vertical Slice tools:

- `order`
- `tasks`
- `resources`
- `production_chain`

`debug.speed_multiplier` exposes the dev speed multiplier. Accepted values are
`1`, `2`, `3`, `5`, `10`, and `100`; default is `1`. The `100x` preset is
reserved for local capture/testing workflows such as Workbench runtime capture;
it is not a player-facing speed and must not be used as visual/readability/feel
acceptance.

`game.first_day` exposes the accepted First Day MVP runtime proof fields for
Workbench review: `postcard_life_moment_seen`, `first_reward_available`,
`first_reward_equipped`, `first_memory_added`, `memory_text`,
`next_day_hint_available` and `next_day_hint_text`. These are state evidence for
the first delivery contract, not a new progression system.

The current visible-readability v2 capture also emits review-only story events
for main-strip prototype markers: `postcard_world_marker_shown`,
`next_day_hint_world_marker_shown`, and `first_reward_world_marker_shown`.
These events are evidence that the capture showed a postcard marker, a gentle
next-day note and Такса-owned slippers cue; they are not new gameplay systems.

The Art / UX visual-language v3 capture keeps those compatibility events and
adds review-only object/state evidence events:
`packing_table_food_bag_state_visible`, `van_ready_object_state_visible`,
`postcard_board_state_visible`, `next_day_note_object_visible`, and
`slippers_equipped_world_state_visible`. These are event-log proof for visual
review captures only; they do not add mechanics, progression, economy, or
production chains.

After the first delivery completes, the Food Bag token is no longer reported as
available in `resources.inventories.delivery_van_endpoint`. Its token remains in
the snapshot for review with `location=delivered_to_shelter`,
`visible=false` and `semantic_state=delivered`.

Event log tags include:

```text
dog_action
movement
route
production_chain
building
room
research
economy
habit_progression
helper_effect
blocked_state
story
debug
```

Dev-only `runtime.debug.tick` events must stay tagged as `debug`; they are not
production-chain evidence and should not inflate `production_events_recent`.

Runtime action examples:

```sh
TOKEN="..."

curl -fsS "http://127.0.0.1:8765/control/runtime/fixtures?token=$TOKEN"

curl -fsS -X POST "http://127.0.0.1:8765/control/runtime/speed?token=$TOKEN" \
  -H 'Content-Type: application/json' \
  --data '{"multiplier":5}'

curl -fsS -X POST "http://127.0.0.1:8765/control/runtime/fixture/load?token=$TOKEN" \
  -H 'Content-Type: application/json' \
  --data '{"fixture":"house_of_curiosity_learning_session"}'

curl -fsS -X POST "http://127.0.0.1:8765/control/runtime/state/export?token=$TOKEN"

curl -fsS -X POST "http://127.0.0.1:8765/control/runtime/state/import?token=$TOKEN" \
  -H 'Content-Type: application/json' \
  --data-binary @state.json

curl -fsS -X POST "http://127.0.0.1:8765/control/runtime/save/write?token=$TOKEN"
curl -fsS -X POST "http://127.0.0.1:8765/control/runtime/save/load?token=$TOKEN"
curl -fsS -X POST "http://127.0.0.1:8765/control/runtime/save/erase?token=$TOKEN"

curl -fsS -X POST "http://127.0.0.1:8765/control/runtime/route/start?token=$TOKEN"

curl -fsS -X POST "http://127.0.0.1:8765/control/runtime/delivery/confirm?token=$TOKEN"

curl -fsS -X POST "http://127.0.0.1:8765/control/runtime/dog/assign?token=$TOKEN" \
  -H 'Content-Type: application/json' \
  --data '{"dog_id":"dog.labrador_intro","room_id":"room.house_of_curiosity.library","activity_group":"learning","activity_detail":"reading_book"}'

curl -fsS -X POST "http://127.0.0.1:8765/control/runtime/research/start?token=$TOKEN" \
  -H 'Content-Type: application/json' \
  --data '{"node_id":"research.basket_check","room_id":"room.house_of_curiosity.classroom","dog_ids":["dog.dachshund_intro"]}'

curl -fsS -X POST "http://127.0.0.1:8765/control/runtime/debug/tick?token=$TOKEN" \
  -H 'Content-Type: application/json' \
  --data '{"seconds":1.5}'
```

`runtime.debug.tick` clamps requested local prototype debug time to 0.05-30
seconds and applies the current dev speed multiplier.

## Workbench Runtime Capture

For Game Designer review through local files, use the dev-only capture harness:

```sh
cd steam
tools/dev-vertical-slice.sh workbench-capture \
  --scenario=first_delivery_from_empty \
  --fixture=first_day_empty_coop \
  --game-seconds=180 \
  --sample-every-game-seconds=10 \
  --speed=100 \
  --output-dir=.runtime/workbench_capture_runs/first_delivery_from_empty_v0
```

To capture the accepted full first delivery path through the player dispatch
confirmation, use:

```sh
cd steam
tools/dev-vertical-slice.sh workbench-capture \
  --scenario=first_delivery_with_dispatch_confirmation \
  --fixture=first_day_empty_coop \
  --game-seconds=420 \
  --sample-every-game-seconds=10 \
  --speed=100 \
  --output-dir=.runtime/workbench_capture_runs/first_delivery_with_dispatch_confirmation_v0
```

The harness starts or reuses a local control-enabled Godot runtime, loads the
accepted fixture, performs the scenario setup through whitelisted runtime
control endpoints, advances bounded debug time, samples live `/state`, then
writes a review bundle under:

```text
steam/.runtime/workbench_capture_runs/<run_id>/
```

Bundle files:

```text
manifest.json
snapshots.jsonl
events.jsonl
stress_signals.jsonl
final_state.json
run.log
```

`snapshots.jsonl` stores full live `/state` payloads for v0. `events.jsonl`
stores event-log deltas observed during the run with sample context.
`stress_signals.jsonl` stores one signal record per sample when the state
contains `stress_test_signals`.

For `first_delivery_with_dispatch_confirmation`, `manifest.json` contains both
`dispatch_confirmation_proof` and `first_day_mvp_proof`. The first proof covers
the accepted dispatch-confirmation path; the second additionally checks high
level dog-action events, first-day postcard/memory/next-day-hint state, delivered
Food Bag semantics, legacy `production_chain` consistency, review-only
marker/object-state evidence events, and debug event tagging.

The capture harness redacts reusable token values from `manifest.json` and
`run.log`. Generated bundles live under ignored `.runtime` storage and must not
be committed.

When Shelter MCP is configured, prefer its `run_shelter_dev_command` tool with
`command="workbench_capture"` for ChatGPT/remote sessions. That MCP call maps to
the same `tools/dev-vertical-slice.sh workbench-capture` command and can return
selected artifacts such as `manifest.json`, `final_state.json` and `run.log`.

## Snapshot File

The connector writes an overwritten JSON snapshot file for local-file access:

```text
steam/.runtime/godot_state_connector/state_snapshot.json
```

`steam/.runtime/` is ignored by Git.

Default file snapshot interval: 5 seconds.

Override the interval through the launcher:

```sh
cd steam
STATE_CONNECTOR_INTERVAL=10 tools/dev-vertical-slice.sh connector
```

Or through Godot args:

```sh
--state-connector-interval=10
```

Live HTTP `/state` is built on request. The periodic interval is for file writes only, so the connector avoids aggressive disk churn while still allowing direct inspection when needed.

## Tunnel-Ready Mode

Direct tunnel-ready connector modes are retained for low-level local debugging.
For normal ChatGPT / remote local-tool access, prefer Shelter MCP above; it
combines filesystem access, Workbench capture and whitelisted connector control
behind one MCP endpoint.

Tunnel-ready mode is explicitly dev-only:

```sh
cd steam
STATE_CONNECTOR_TOKEN="$(uuidgen)" tools/dev-vertical-slice.sh connector-tunnel
```

It binds the HTTP endpoint for tunnel use and requires a token. The token may be passed as:

```text
?token=...
```

or as header:

```text
X-Shelter-State-Token: ...
```

Do not commit tunnel URLs, tokens, generated configs or snapshot outputs.

To start the game and expose the control page through the Barsulka SSH reverse
tunnel in one terminal:

```sh
cd steam
./launch.sh --barsulka --start
```

`--barsulka --start` starts the local game if needed, then prints the public URL
after the tunnel becomes healthy. Run `./launch.sh --barsulka` later from
another terminal only when you need to print the already running URL again.

To stop the Barsulka tunnel and shut down only the local HTTP connector while
leaving the Godot game process alive:

```sh
cd steam
./launch.sh --barsulka --stop
```

To shut down tunnels, the local HTTP connector and the Godot game together:

```sh
cd steam
./launch.sh --exit
# or
./launch.sh --shutdown
```

Cloudflared backup:

```sh
cd steam
./launch.sh --cloudflared --start
./launch.sh --cloudflared
```

If the local game is not already running, `--cloudflared --start` starts it
first. `./launch.sh --cloudflared` is lookup-only and prints the already running
Cloudflare URL again.

Tunnel starters print `/state?token=...` and `/control?token=...` URLs. Keep
the tunnel terminal open while the tunnel is in use.

## Snapshot Shape

`/state` includes:

- `schema_version`
- `connector`
- `game`
- `dogs`
- `routes`
- `production_chains`
- `buildings`
- `rooms`
- `house_of_curiosity`
- `economy`
- `events`
- `debug`

It also includes legacy compatibility views: `order`, `tasks`, `resources`, and
`production_chain`.

When control mode is enabled, `connector.control_enabled` is `true`, and `game` includes:

- `control_enabled`
- `ui_visible`
- `window_visible`

Dog state exports D-010 layers separately:

- `innate_traits`
- `learned_abilities`
- `equipment`

For the current Vertical Slice, learned abilities are exported as an empty placeholder because that system is not implemented yet.

## Current Limits

- v0.2 is attached only to the Steam Vertical Slice prototype.
- default connector mode is read-only.
- explicit control mode supports Hide / Show / Toggle window visibility and
  bounded dev-only viewport capture.
- runtime mutation commands are local prototype/dev-test commands only, not
  player-facing cheats and not final production save tooling.
- `runtime.delivery.confirm` is limited to `order.first_warm_delivery` at the
  accepted `ready_to_dispatch` / `waiting_for_player_confirmation` state and
  returns a validation error instead of mutating arbitrary order/task/resource
  state.
- the capture API stores PNG bytes in connector memory and uses only deleted
  temporary PNG files as an encoding bridge; it does not produce MP4 files and
  does not enable Godot Movie Maker in the normal launcher.
- there are no pause controls, generic step controls outside the accepted bounded
  debug tick, arbitrary task/resource/dog/order mutation commands or generic
  remote command execution.
- v0.2 does not define final save format, final game architecture, final dog
  progression, final balance or production data schema.
- v0.2 combines a first runtime scaffold with prototype-local task dictionaries
  and state flags. Future extraction should continue moving gameplay state into
  reusable runtime/core layers and keep UI as a view over that state.
