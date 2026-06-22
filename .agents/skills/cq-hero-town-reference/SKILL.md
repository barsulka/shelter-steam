---
name: cq-hero-town-reference
description: "Reference workflow for inspecting Crusaders Quest: Hero Town through Computer Use. Use when Codex needs to study CQ Hero Town as a desktop idle/always-on-top/window-behavior reference, operate its live Mac window, document controls, click buildings, observe panels, or compare its UX to Shelter Steam/Desktop."
---

# CQ Hero Town Reference

Use this skill to inspect the live `Crusaders Quest: Hero Town` desktop reference through Computer Use and record reusable observations for Shelter Steam/Desktop.

## Start

Use Computer Use, not browser tools.

App identifiers:

- App name: `CQ Hero Town`
- Bundle ID: `com.DefaultCompany.2D-URP`
- Steam path: `/Users/barsulka/Library/Application Support/Steam/steamapps/common/Crusaders Quest Hero Town/CQ Hero Town.app/`

First action each turn:

```text
get_app_state(app="CQ Hero Town")
```

The accessibility tree is sparse because this is a Unity game window. Prefer screenshot interpretation plus coordinate clicks/drags/keys. On macOS, prefer `System Events` for keyboard controls after using Computer Use for screenshots.

## Safety

- Do not click blank white/transparent regions casually: clicks in empty space can pass through to the app underneath CQ.
- Do not use empty-space clicks to "return focus" unless the user explicitly wants to test click-through.
- Prefer clicks on visible in-game objects, UI panels, buttons, or the solid bottom strip.
- Re-query `get_app_state` after each UI-changing action before sending more actions.
- Do not press purchase, account, external-link, deletion, or irreversible actions without explicit user confirmation.
- Treat user observations as useful but mark them as "user observed" until rechecked by screenshot/action evidence.

## Controls

Read `references/controls.md` before operating the game.

Known/high-confidence controls:

- Activate the game before keyboard input:
  `osascript -e 'tell application id "com.DefaultCompany.2D-URP" to activate'`.
- Prefer macOS `System Events` for arrow keys:
  - left: `key code 123`;
  - right: `key code 124`;
  - down: `key code 125`;
  - up: `key code 126`.
- Use mouse drag on the visible game field or bottom strip to attempt horizontal camera movement.
- Use building clicks to select/center a building and open its action panel, when no blocking UI panel is active.
- Use coordinate clicks for UI because Computer Use does not expose game widgets as accessibility elements.

Confirmed/user-observed control model:

- Left/right arrow keys pan the field, but pan speed depends on the in-game keyboard-scroll speed setting.
- If left/right appears to do nothing, assume a map edge, minimum zoom, or low keyboard-scroll speed before assuming input failure.
- Up arrow zooms in.
- Down arrow zooms out.
- Zoom steps are `50`, `100`, `150`, and `200`.
- At the smallest zoom, the whole field may fit on screen, so horizontal panning may be impossible.

## Research Workflow

For each observation:

1. Capture current state with `get_app_state`.
2. Perform one small action.
3. Capture state again.
4. Record what changed and what did not.
5. Label the confidence:
   - `confirmed` when directly observed in this session.
   - `user-observed` when supplied by the user but not rechecked.
   - `needs-recheck` when attempted but blocked by panel/focus/click-through state.

Use references:

- `references/controls.md` for input and focus behavior.
- `references/buildings.md` for building types, panels, and actions.
- `references/window-behavior.md` for transparency, always-on-top, click-through, and UI layering observations.

## Shelter Lens

Extract design lessons, not clone mechanics.

Focus on:

- desktop strip composition;
- transparent/click-through behavior;
- always-on-top coexistence with other apps;
- readable small-scale building/UI silhouettes;
- slow visible worker/character actions;
- low-interruption idle rhythm.

Avoid copying:

- combat systems;
- hero progression;
- monetization pressure;
- exact building layout, art, or economy.
