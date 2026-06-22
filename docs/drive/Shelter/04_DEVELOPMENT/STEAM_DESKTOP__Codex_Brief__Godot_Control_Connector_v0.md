# STEAM_DESKTOP — Codex Brief — Godot Control Connector v0

Дата: 2026-06-29
Роль документа: Codex Implementation Brief / Internal Game Control Tool
Статус: accepted / ready for Codex
Продукт: Steam/Desktop idle always-on-top strip
Recommended Codex reasoning level: **очень высокий**

## 0. Purpose

Расширить dev-only Godot State Connector до первого безопасного dev-only control surface, через который внешние инструменты и ChatGPT-сессии смогут не только читать live state Godot-прототипа, но и отправлять строго ограниченные команды управления.

v0 control goal:

- сохранить Godot единственным источником runtime-state;
- оставить внешний интерфейс только view/control shell, а не отдельной симуляцией;
- добавить маленькую HTTP-страницу с кнопками;
- добавить первую whitelisted command: **скрыть / показать игровое окно**.

Это продолжает направление “игра крутится в памяти, UI/save/snapshot/connector/page are state views”, но добавляет explicit debug control contract.

## 1. Context

Предыдущий accepted brief:

```text
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Godot_State_Connector_v0.md
```

State Connector v0 был намеренно read-only и явно запрещал write/control commands. Этот brief является отдельным scope expansion и не должен реализовываться как незаметная правка старого v0.

Причина расширения:

- Backend-oriented workflow хочет иметь “подводную часть игры” как live runtime-state.
- Разные интерфейсы, включая локальный Godot UI, JSON snapshot, HTTP inspector и ChatGPT-facing page, должны быть views/controllers над живой Godot-игрой.
- Remote agents должны получить возможность выполнять ограниченные dev actions через явный контракт, а не через отдельную модель мира.

## 2. Mandatory Sources

Codex must read before implementation:

- `PROJECTS_RULES.md`
- `AGENTS.md`
- `README.md`
- `steam/AGENTS.md`
- `steam/README.md`
- `docs/repo/status/CODEX_STATUS.md`
- `docs/repo/adr/README.md`
- `docs/repo/adr/0001-use-godot-for-steam-desktop.md`
- `docs/repo/adr/0002-game-state-as-source-of-truth.md`
- `docs/repo/dev/godot-state-connector.md`
- `docs/repo/dev/steam-vertical-slice-prototype.md`
- `docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Godot_State_Connector_v0.md`
- `docs/drive/Shelter/00_START_HERE/000_ROLE_CODEX.md`
- `docs/drive/Shelter/00_START_HERE/02_DECISIONS.md`
- relevant Steam/Desktop product docs if implementation touches UX beyond dev tooling.

If any path moved, find the current equivalent through local repository search.

## 3. Core Rule

Godot remains the source of truth.

The control connector may ask the running Godot scene to perform explicit dev actions. It must not:

- run a separate simulation outside Godot;
- own gameplay state outside Godot;
- implement a duplicate scheduler/resource economy/task model;
- mutate dogs/resources/tasks/orders unless a future accepted brief explicitly defines such commands.

For v0, the only allowed mutation is window/interface visibility:

- `hide game interface`;
- `show game interface`;
- optionally `toggle game interface`.

This is a view/window control command, not gameplay progression.

## 4. Scope

Implement dev-only HTTP control capability on top of the existing Godot State Connector.

Required capabilities:

- control commands are disabled by default;
- control commands require an explicit launch flag / script mode;
- control commands require the same ephemeral token guard as tunnel mode, even on local HTTP if control is enabled;
- `/state` exposes whether control is enabled and whether the game UI/window is currently visible;
- a small HTTP inspector/control page is served by the connector;
- the page has buttons for:
  - `Hide Game`;
  - `Show Game`;
  - optionally `Toggle`;
- the page can be opened through the same tunnel flow used for ChatGPT state inspection;
- the page contains no gameplay simulation and no separate state model.

Suggested launch modes:

```sh
cd steam
./launch.sh
./launch.sh --url
./launch.sh --barsulka --start
./launch.sh --barsulka
./launch.sh --barsulka --stop
./launch.sh --cloudflared --start
./launch.sh --cloudflared
tools/dev-vertical-slice.sh connector-control-smoke
```

2026-06-30 scope update:

- `./launch.sh` is the human-facing game launcher and intentionally starts the
  local connector/control server with the playable Vertical Slice.
- `./launch.sh --url` is lookup-only: it prints local URLs for an already running
  game and starts nothing.
- `./launch.sh --barsulka --start` starts only an SSH reverse tunnel from
  `barsulka.eboshim.site:<five-digit-port>` to the already running local game
  process.
- `./launch.sh --barsulka` is lookup-only: it prints the already running
  Barsulka public URL and starts nothing.
- `./launch.sh --barsulka --stop` stops the Barsulka SSH tunnel and stops the
  local HTTP connector without stopping the Godot game process.
- `./launch.sh --cloudflared --start` starts only cloudflared for an already
  running local game process and remains the backup public access option.
- `./launch.sh --cloudflared` is lookup-only: it prints the already running
  Cloudflare URL and starts nothing.
- `tools/dev-*` scripts are dev diagnostics/smoke/capture helpers, not the
  normal human-facing game launcher.

2026-06-30 control/capture scope update:

- The HTML control page should expose only one visible window-control button:
  `Toggle`.
- `ui.hide` and `ui.show` remain supported API methods, but are hidden from the
  page UI.
- Add dev-only viewport capture commands to the same token-protected whitelist:
  one screenshot method and one bounded short screencast-like method.
- Screenshot capture should use the running Godot viewport as source of truth
  and return a tokenized PNG file URL.
- Short video capture v0 should be a bounded 10 second PNG-frame sequence at a
  conservative FPS, not a separate simulator and not a long-running recording
  of the whole play session.
- Captured PNG bytes should be served from connector memory. A temporary file
  may be used only as an encoding bridge if Godot needs it; it should be read
  and deleted immediately.
- Starting a new short video capture should clear the previous frame sequence
  from memory.
- The control page should render the latest screenshot or completed frame
  sequence inline after capture.
- Do not enable Godot Movie Maker / `--write-movie` in the default launcher:
  it is treated as a separate capture-mode tool because it records from project
  start until project exit.

## 5. Suggested HTTP Contract

Suggested endpoints:

```text
GET  /health
GET  /schema
GET  /state
GET  /control
GET  /control/capabilities
POST /control/ui/hide
POST /control/ui/show
POST /control/ui/toggle
POST /control/capture/screenshot
POST /control/capture/video/start
GET  /control/capture/video/status
GET  /control/capture/files/<file_id>
```

Rules:

- `GET` endpoints may read state or serve the page.
- Mutating commands must use `POST`, not `GET`.
- No generic `POST /command` endpoint in v0 unless it is only a strict whitelist dispatcher with no arbitrary payload execution.
- Control endpoints must reject missing/invalid token by returning masked `404 not_found`, not `401`, so unauthenticated callers do not learn that a control surface exists behind the port.
- Token may be passed as:
  - `?token=...`;
  - `X-Shelter-State-Token: ...`;
  - same-origin page JavaScript may preserve token from URL query and send it with POST requests.

Example successful command response:

```json
{
  "ok": true,
  "command": "ui.hide",
  "ui_visible": false,
  "state_url": "/state"
}
```

Example rejected command response without a valid token:

```json
{
  "ok": false,
  "error": "not_found",
  "path": "/control/ui/hide"
}
```

## 6. Hide / Show Semantics

The first control command is about the visible Godot game interface/window.

Expected behavior:

- `hide` removes the game interface from the screen completely.
- The Godot process must keep running.
- The connector must keep answering `/health`, `/schema`, `/state` and control endpoints while hidden.
- `show` brings the game interface back.
- The restored window should preserve the previous size, position and relevant flags as much as feasible:
  - always-on-top;
  - borderless;
  - transparent;
  - click-through behavior;
  - current zoom/pan if already tracked.
- If hiding the window pauses processing or kills connector availability in current Godot/macOS behavior, stop and document the limitation before forcing a workaround.

Implementation may use Godot window APIs such as `get_window().hide()` / `get_window().show()` or another Godot-native approach, but must be verified visibly.

No local “show” button inside the hidden game is required in v0. Remote `/control/ui/show` is enough.

## 7. Control Page Requirements

The page is a dev tool, not player-facing UI.

Page requirements:

- served from the running Godot connector, for example `GET /control?token=...`;
- works through local HTTP and Cloudflare quick tunnel;
- shows connector status and current `ui_visible` state;
- has clear buttons for Hide / Show;
- uses `fetch()` POST calls to control endpoints;
- handles offline/401/error states plainly;
- optionally polls `/state` every few seconds while open;
- uses no external dependencies, no CDN, no separate web server;
- contains no gameplay simulation logic;
- does not persist token in repo, localStorage or generated committed files.

The page may be plain HTML/CSS/JS generated by the connector. It should be simple and robust.

## 8. Security / Access Boundaries

Default mode must remain conservative:

- normal game launch: no connector;
- `connector`: read-only connector only;
- `connector-control`: read/write dev control connector, token required;
- `connector-tunnel` without explicit control remains read-only unless Codex chooses and documents a clearly named control tunnel mode.

Control mode must:

- be dev-only;
- require explicit opt-in;
- require token for every control endpoint;
- return masked `404 not_found` for control endpoints without a valid token;
- expose only whitelisted commands;
- avoid arbitrary code execution;
- avoid filesystem write commands;
- avoid shell commands;
- avoid gameplay-state mutation in v0;
- avoid production auth/session/account systems;
- avoid committed secrets, tokens, generated tunnel URLs or runtime snapshots.

If Codex needs a broader auth model, persistent service, database, account system, or production web dashboard, stop and ask for a new brief.

## 9. Out Of Scope

Do not implement in v0:

- standalone simulator outside Godot;
- production backend service;
- database;
- account/auth system beyond ephemeral dev token;
- arbitrary remote command execution;
- generic gameplay mutation commands;
- task/resource/dog/order editing;
- pause/step/time-scale controls unless separately approved;
- save-file editing;
- local hidden-window restore button inside the game UI;
- player-facing settings UI;
- Browser Extension UX;
- Chrome extension runtime;
- monetization or charity reporting.

## 10. Expected Implementation Zones

Likely zones:

```text
steam/scripts/dev_tools/godot_state_connector.gd
steam/scripts/prototypes/vertical_slice/vertical_slice_demo.gd
steam/launch.sh
steam/tools/dev-vertical-slice.sh
steam/tools/dev-start-cloudflared.sh
steam/tools/check-godot.sh
steam/README.md
docs/repo/dev/godot-state-connector.md
docs/repo/status/CODEX_STATUS.md
```

Potential docs/ADR update:

- Update `docs/repo/dev/godot-state-connector.md` with control mode docs.
- Update `docs/repo/status/CODEX_STATUS.md`.
- Update or add ADR if implementation establishes a durable rule for dev control surfaces beyond this v0.

## 11. Acceptance Criteria

Implementation is acceptable if:

1. `./launch.sh` starts the playable Vertical Slice with local connector/control enabled.
2. `./launch.sh --url` prints local URLs for an already running game and starts no process.
3. `./launch.sh --barsulka --start` starts an SSH reverse tunnel only for an already running local game process and starts no Godot process.
4. `./launch.sh --barsulka` prints the already running Barsulka public URL and starts no process.
5. `./launch.sh --barsulka --stop` stops the Barsulka tunnel and stops only the local HTTP connector, not the Godot game process.
6. `./launch.sh --cloudflared --start` starts cloudflared only for an already running local game process and starts no Godot process.
7. `./launch.sh --cloudflared` prints the already running Cloudflare URL and starts no process.
8. Existing read-only `connector` mode remains read-only in `tools/dev-vertical-slice.sh`.
9. Control endpoints require token and reject missing/invalid token as masked `404 not_found`.
10. `GET /control?token=...` serves a small page with Hide / Show buttons.
11. Pressing Hide through HTTP hides the visible game interface/window while Godot keeps running.
12. While hidden, `/health` and `/state` still answer.
13. Pressing Show through HTTP brings the visible game interface/window back.
14. `/state` reports current UI/window visibility and control capability status.
15. Smoke tests verify command responses and state changes.
16. Docs explain local and tunneled usage.
17. `tools/dev-start-cloudflared.sh` remains a compatibility helper for `./launch.sh --cloudflared --start` and starts no Godot process.
18. No Browser Extension UX, production service, gameplay mutation, separate simulator or arbitrary command execution is introduced.

## 12. Suggested Checks

Required checks:

```sh
cd steam
tools/dev-vertical-slice.sh connector-smoke
tools/dev-vertical-slice.sh connector-control-smoke
tools/dev-vertical-slice.sh smoke
tools/check-godot.sh
```

Also run:

```sh
git diff --check
```

Manual visible check:

1. Start visible control mode.
2. Open `/control?token=...`.
3. Click Hide.
4. Confirm the game window disappears while `/health` still works.
5. Click Show.
6. Confirm the game window returns.

Tunnel check if network is available:

1. Start tunnel mode with control enabled.
2. Open the public `/control?token=...` URL.
3. Use Hide / Show.
4. Confirm `/state` remains readable.

If Cloudflare quick tunnel DNS is flaky on the local machine, document that external ChatGPT may still resolve the URL even when local macOS `curl` needs DNS fallback.

## 13. Stop Conditions

Stop and report instead of guessing if:

- Godot cannot keep processing connector requests while the window is hidden;
- hide/show requires platform-specific native APIs outside current scope;
- hiding breaks always-on-top/transparent/borderless state in a way that cannot be restored;
- implementation would expose arbitrary commands or shell/filesystem access;
- implementing the page requires a separate backend/service;
- control mode conflicts with accepted product/design constraints;
- Codex needs to add gameplay mutations not listed in this brief.

## 14. Notes For Future Work

Future briefs may add other dev-only controls:

- pause/resume;
- step one tick;
- speed multiplier;
- focus a dog/task/building;
- inject controlled test orders;
- advance deterministic test scenario.

Those are intentionally not part of this v0. The first v0 command is only Hide / Show game interface.
