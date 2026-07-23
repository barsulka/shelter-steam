# Companion Field Tech Demo

This is the recommended next implementation slice after the Godot bootstrap and desktop window probe.

## Goal

Build a small Godot desktop companion-field demo that proves Shelter can behave like a lightweight strip beside the user's desktop without committing to final art, economy, charity flow, or full game logic.

## Scope

- A horizontal field similar in layout intent to CQ Hero Town, but with original placeholder Shelter objects.
- Two or three static placeholder objects on the field.
- Camera pan left/right.
- Zoom in/out with several discrete zoom levels.
- Transparent or pass-through space between interactive objects, where feasible.
- The app must not cover the macOS system panel/menu bar in companion mode.
- A minimal settings window for desktop behavior.
- Multi-monitor placement checks on machines with more than one display.

## Current Implementation

The repo includes the first Godot tech-demo scene:

```sh
tools/dev-companion-field.sh
```

The default launch is the intended manual test path: it opens the companion strip
and the settings window together, so display selection, normal/companion mode,
always-on-top, transparency, click-through empty space, zoom, and pan speed can be
checked in one session.

Optional diagnostic presets remain available when a specific failure needs to be
isolated:

```sh
tools/dev-companion-field.sh normal
tools/dev-companion-field.sh companion
tools/dev-companion-field.sh click-through
tools/dev-companion-field.sh perf
tools/dev-companion-field.sh dog-runtime
tools/dev-companion-field.sh dog-runtime-smoke
tools/dev-companion-field.sh smoke
```

Files:

- `steam/scenes/tech_demos/companion_field_demo.tscn`
- `steam/scripts/tech_demos/companion_field_demo.gd`
- `steam/resources/tech_demos/companion_field_layout.json`
- `steam/tools/dev-companion-field.sh`

Implemented behavior:

- Companion-sized bottom field.
- Config-driven field layout and building placement data.
- CQ-style zone split for the current demo state:
  - `26` cells: backyard;
  - `3` technical gate cells;
  - `80` cells: city;
  - `3` technical gate cells;
  - `80` cells: countryside.
- Zones support `base_cells` and `max_cells`; `player_state.zone_unlocked_cells` controls current unlocked land so future player progression can expand zones without changing code.
- Persistent CQ-style visual ground: a thin grass/surface line with colored dirt below it. The city dirt is grayer; backyard/countryside/technical dirt is sandier.
- Cell rectangles are not a separate gameplay layer. They are a pure move-mode overlay drawn by field coordinates over the dirt visual.
- Config-driven building types with cell footprints and allowed zones: fixed wooden post `3`, town hall placeholder `6`, notice board `3`, market bench `4`, garden tree `5`.
- Fixed technical gate buildings occupy the technical cells and cannot be moved.
- Movable buildings enter move mode when clicked.
- Move mode highlights only zones where the selected building type is allowed:
  - gray cells are allowed and empty;
  - red cells are allowed but occupied;
  - forbidden zones are not highlighted at all;
  - the moving footprint is green when it fits and red when it does not.
- Moving buildings are drawn as a white translucent ghost while moving.
- While move mode is active, the main companion window temporarily captures the whole window area so clicks on or above the white moving ghost cannot pass through to the app underneath before placement is handled.
- The demo uses curated placeholder sprites from `steam/assets/tech_demos/placeholder_art/`: `TX Tileset Ground`, `TX Village Props`, and all outlined `MinifolksForestAnimals` species. Current field objects use configured `TX Village Props` atlas regions instead of procedural tower/fountain/bin shapes. The animals move on short low-frequency timer paths and animate from explicit tight non-empty frame lists so the strip feels alive and the sprites stay readable without adding a permanent `_process()` loop. The local raw `steam/tilesets/` source drop is ignored by Git and has a tracked `.gdignore` so Godot does not import large source packs.
- Debug-only dog runtime integration mode:
  - `tools/dev-companion-field.sh dog-runtime` opens the normal companion strip with performance HUD and one embedded Bublik runtime.
  - `tools/dev-companion-field.sh dog-runtime-smoke` runs the same bridge headless with auto-quit.
  - The dog uses `DOG-PROT-001 / Bublik` from `steam/resources/tech_demos/dog_dna_examples.json`, with a fallback prototype record only if the JSON cannot be read.
  - The visible phrase is `idle -> walk -> pickup food bag -> carry -> deliver -> wag -> idle`.
  - The label shows dog id/name, current phrase, socket state, and the current base-clip/procedural bridge note.
  - This mode is an embedded debug bridge from the Dog Rig Spike v3 findings, not a shared production dog runtime module yet.
- Ground, cell overlays, highlights, and buildings scale with game zoom.
- Discrete zoom levels matching the CQ reference model: `50`, `100`, `150`, `200`.
- Separate controls scale levels: `50`, `100`, `150`, `200`.
- Default first-run scale values: game zoom `100`, controls scale `150`.
- Keyboard pan/zoom in Godot:
  - left/right arrows pan;
  - up/down arrows zoom;
  - mouse wheel zooms;
  - mouse drag pans when normal capture is enabled.
- Object clicks select a placeholder object and show a small local panel.
- A right-side `Hide` / `Show` button keeps fixed screen-relative coordinates with controls scale applied. Hiding removes the field, objects, animals, status, and settings button while leaving only the show button interactive.
- Settings window controls companion mode, display, always-on-top, transparency, click-through empty space, game zoom, controls scale, pan speed, placement, camera reset, and exit.
- A lightweight performance HUD is enabled by default and can be toggled in settings. It uses Godot `Performance.get_monitor(...)` on a `0.5s` timer to show FPS, frame/physics time, memory, video/texture memory, draw calls, object count, and node count. The `perf` launcher also passes Godot's `--print-fps` for stdout monitoring.
- Click-through empty space is enabled by default for the transparent companion window. If always-on-top is turned off, a click through transparent empty space should let the clicked app become frontmost in the normal desktop way.
- Game zoom and controls scale are saved to `user://companion_field_demo.cfg`; click-through empty-space mode is intentionally not saved.
- The demo sets the root window content scale size to the actual demo window size so the global `960x540` project viewport does not shrink the companion strip UI.
- Companion mode uses the selected display's full usable width and sits at the bottom of the usable rect.
- The settings window is a native scrollable window centered on the selected display's usable rect, not inside the companion strip.
- Default manual launch opens the settings window immediately, while diagnostic presets can start with it closed.
- Companion placement uses the selected display's usable rect so the macOS system panel/menu bar is not intentionally covered.

## Controls To Prototype

- Keyboard zoom:
  - zoom out;
  - zoom in;
  - clamp at minimum/maximum zoom.
- Keyboard pan:
  - pan left;
  - pan right;
  - do nothing safely at map edges.
- Mouse:
  - click visible objects;
  - drag or scroll/pan if technically feasible;
  - click in transparent space and verify whether focus passes to the app underneath.

## Window Behavior To Validate

- Companion window position and size on primary display.
- Companion window position and size on secondary display.
- Companion window spans the selected display's usable width.
- Settings window opens centered on the selected display, outside the companion strip, and scrolls when content does not fit.
- Always-on-top behavior.
- Real transparent background behavior.
- Click-through behavior in empty space.
- Input capture on visible/interactable objects.
- System menu bar/panel visibility.
- Focus behavior when another app is active below the game.

## Known Limitation

Godot's `DisplayServer.window_set_mouse_passthrough(...)` takes one polygon for the main window. The current demo builds one connected skyline polygon from the ground strip plus visible building rectangles, so empty transparent space above the ground/building silhouette can pass clicks to the app underneath while the field remains interactive. During move mode, passthrough is temporarily disabled so placement clicks are never lost to a background app.

This is still not production-grade per-pixel or disjoint-object hit testing. If Shelter needs perfectly clickable separate object islands with transparent gaps at arbitrary heights, that may require a later native window layer, multiple child windows, or another platform-specific strategy.

The `dog-runtime` mode intentionally keeps the dog in the same world coordinate system as the field. Camera pan moves the dog with the field. Game zoom scales the dog along with field objects; at extreme zoom values the dog is still predictable but can become a debug-sized object rather than a final readable production scale. A future production runtime should replace this embedded bridge with a reusable dog scene/runtime and art-approved scale constraints.

## Settings Window

The first settings window can be minimal and development-facing:

- target display;
- window mode: normal / companion;
- always-on-top toggle;
- transparent background toggle;
- click-through empty-space toggle;
- performance HUD toggle;
- game zoom level;
- controls scale;
- pan speed;
- exit.

## Asset Direction

The current demo uses a small curated placeholder-art subset from `steam/assets/tech_demos/placeholder_art/` instead of committing the whole raw `steam/tilesets/` source directory. The raw source directory is intentionally ignored by Git because it can contain large packs, editor files, and alternate styles that the demo does not need. Keep `steam/tilesets/.gdignore` tracked so Godot skips local raw packs during import/check commands.

Useful starting points for placeholder art searches:

- Kenney (`https://kenney.nl/assets`): safest first stop because many packs are CC0. Look at `Pixel Platformer`, `Tiny Town`, `Animal Pack`, `Animal Pack Redux`, `Pixel Platformer Farm Expansion`, `Pixel Platformer Industrial Expansion`, and building/town packs.
- itch.io (`https://itch.io/game-assets`): good for dog sprites and cozy pixel packs. Use filters such as `free`, `pixel art`, `dogs`, `cc0`, `top-down`, `farm`, `town`; check each asset page license before importing.
- OpenGameArt (`https://opengameart.org`): broad free/open repository with useful dog sprites, buildings, props, and tiles. Licenses vary per asset, so prefer CC0 or clearly compatible attribution terms.
- CraftPix / Free Game Assets (`https://free-game-assets.itch.io/`): large free/premium catalog for prototype props and tiles. License needs explicit per-pack review before using in-repo.

## Reference Notes

CQ Hero Town reference notes now live in `steam/.agents/skills/cq-hero-town-reference/`.

Important CQ findings for this demo:

- A field can be visually always-on-top while another app is actually frontmost.
- Empty/transparent regions may pass clicks to the app underneath.
- Low zoom can make horizontal pan impossible because the whole field fits on screen.
- Camera pan can look broken if already at a map edge or if keyboard-scroll speed is too low.
- On macOS, Computer Use screenshots are reliable, while CQ keyboard control was more reliable through `System Events`.

## Done Criteria

- The demo runs from the repo with the documented Godot binary.
- A user can zoom in/out and pan at least when zoomed in enough for panning to matter.
- Clicking an object visibly selects it or opens a tiny placeholder panel.
- Clicking intentionally empty pass-through space is tested and documented.
- Companion mode avoids covering the macOS system panel/menu bar.
- At least one multi-monitor placement test is recorded in `docs/repo/status/CODEX_CURRENT_STATUS.md`.
