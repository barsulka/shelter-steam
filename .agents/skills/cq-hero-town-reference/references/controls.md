# CQ Hero Town Controls

## Current State

Observed via Computer Use on macOS, 2026-06-23.

Because the game is a Unity window with a sparse accessibility tree, controls are operated by screenshot coordinates, key presses, and mouse drag. Computer Use is useful for screenshots and some visible clicks, but macOS `System Events` is the confirmed reliable path for keyboard controls.

## Confirmed / High Confidence

- `get_app_state(app="CQ Hero Town")` returns the live game screenshot and sparse window tree.
- Coordinate clicks work on the game window, but need visual confirmation after every action.
- Computer Use `type_text` and `press_key` were confirmed to work in TextEdit after Input Monitoring permission was granted, so failures in CQ should be treated as CQ/Steam/Unity/window-focus-specific until proven otherwise.
- Direct Computer Use `press_key`/`drag` did not reliably affect CQ controls in the observed session.
- macOS `System Events` key codes worked for CQ after explicitly activating the app:
  - activate: `osascript -e 'tell application id "com.DefaultCompany.2D-URP" to activate'`
  - left: `key code 123`
  - right: `key code 124`
  - down / zoom out: `key code 125`
  - up / zoom in: `key code 126`
- Blank white/transparent regions can pass clicks through to the application underneath the game.
- Avoid clicking empty white space as a generic focus action.
- `Escape` is not a reliable "close current panel" command. In one observed state, pressing `Escape` left/opened the `Коллекция` panel.
- Zoom steps are user-observed as `50`, `100`, `150`, and `200`.
- `Down` via `System Events` confirmed zooming out from `100` to the smaller whole-field view.
- `Up` via `System Events` confirmed zooming in from the smaller whole-field view to a larger field view.
- Left/right panning depends on the in-game keyboard-scroll speed setting. A low value such as `4` can look like no movement; `50` is much easier to observe.
- If panning does not move, check whether the camera is already at the left/right edge or whether the zoom is low enough that the whole field fits on screen.

## User-Observed, Needs Clean-State Verification

- Dragging the field with the mouse should pan the camera.
- Mouse drag panning still needs a clean confirmed pass.

## Attempted But Inconclusive

- Arrow key panning and zoom were attempted while the `Коллекция` panel was open; no obvious movement/zoom was visible.
- Mouse drag on the field/bottom strip was attempted while `Коллекция` was open; no obvious movement was visible.
- Clicking the visible close box on `Коллекция` once did not close it; the hitbox may be smaller than the visual mark or the click may have missed.
- Direct Computer Use `press_key("Up")`, `press_key("Down")`, and `drag(...)` did not reliably change CQ state, even when the game window appeared focused.
- Repeated left/right key taps may be hard to observe at low keyboard-scroll speed or when the camera is already at a map edge.

## Practical Operating Rules

- Before testing navigation or zoom, first get the game into a clean state with no modal/side panel open.
- Prefer clicking visible UI controls or building sprites, not transparent background.
- After a click/drag/key press, call `get_app_state` before the next input.
- For keyboard controls, activate CQ with `osascript`, send `System Events` key codes, then verify with Computer Use screenshot.
- Be bold about trying the opposite direction: if right does not move, try left; if up does not zoom, try down.
- If the field is fully visible at zoom `50`, first zoom in before testing horizontal panning.
- When testing click-through, deliberately place a harmless app behind the game and describe the risk before clicking blank regions.
