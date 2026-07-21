# D-030 — Fixed 26-cell meadow, whole-game zoom and clickable visible surface

Status: **IMPLEMENTED — ready for direct user play check**

## Goal

Make the ordinary macOS player build visibly usable:

- preserve the approved meadow artwork without horizontal stretching;
- make one meadow period cover exactly **26 cells**;
- tile that period to cover the visible game field;
- zoom the whole game (field, buildings, props and dogs) with Up/Down;
- accept clicks on visible game content and pass clicks through only where the window is visually transparent;
- keep the companion window inside the macOS usable screen rectangle.

## Locked visual/math contract

- Logical cell size: `32` world units.
- One meadow period: `26` cells = `832` world units.
- Zoom ladder: `50% / 100% / 150% / 200%`; default is `100%`.
- The approved source is authored for `200%`: `26 × 32 × 2 = 1664` source pixels.
- The 1672-pixel approved source may be cropped symmetrically by 4 pixels on each side. It must not be resized horizontally.
- At `200%`, one source pixel maps to one screen pixel. At `100%`, the whole scene is uniformly displayed at half that linear size.
- Window width changes only how many cells/tiles are visible. It never changes cell, object, dog or meadow scale.
- Companion-window height follows the zoomed meadow/content height; it is not fixed at `224 px`. At `200%` the full meadow height must fit inside the macOS usable screen rectangle.
- The number `26` changes only together with an explicitly approved redraw of the meadow period.

## Input authority

`docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/approved_art_files/STEAM_DESKTOP__meadow_source_plate_v1__approved_direction.png`

The only allowed art change is the symmetric 8-pixel crop plus a narrow local repair that makes the right and left edges continuous. Preserve resolution, composition, palette and detail outside that seam repair.

## Interaction contract

- The visible meadow/ground is clickable.
- Visible buildings, props, dogs and UI above the ground are clickable.
- Only visually transparent window regions pass the pointer through to macOS.
- The window remains positioned inside `DisplayServer.screen_get_usable_rect(...)` and therefore does not cover the Dock/menu-bar-reserved area.
- The approved meadow reaches the bottom edge without a transparent/white fringe.
- Authored terrain/background layers `00–08` are not drawn over the approved meadow. Buildings, props and dogs share the approved meadow ground baseline.

## Implementation scope

- new seamless meadow runtime asset under `steam/assets/prototypes/vertical_slice/authored/world/responsive/`;
- `steam/scripts/prototypes/vertical_slice/vertical_slice_demo.gd`;
- `steam/resources/prototypes/vertical_slice/d024_responsive_presentation_v1.json` (runtime material contract only);
- this brief and `docs/drive/Shelter/00_START_HERE/02_DECISIONS.md`.

Preserve unrelated dirty working-tree changes. No D-024 capture-pack rewrite, full capture matrix, manifest regeneration, commit or push belongs to this wave.

## Acceptance

1. One period is exactly 1664 source pixels / 26 cells and is drawn repeatedly without horizontal stretching.
2. A three-period preview has no visible vertical seam.
3. Up/Down selects 50/100/150/200 and scales meadow, buildings, props and dogs uniformly; resize does not change zoom.
4. The field and visible content accept clicks; transparent sky passes them through.
5. The Labrador continues its real route movement.
6. The old stretched terrain is absent and objects stand on the approved meadow.
7. One bounded parser smoke, one `200%` window smoke and one four-frame internal viewport smoke are sufficient for this correction; no full evidence/capture suite.

## Stop conditions

- changing the approved count of 26 cells;
- needing to stretch/resample the approved meadow horizontally;
- changing gameplay, save/schema, persistence or checkpoint meaning;
- overwriting unrelated working-tree changes;
- introducing a third screen-capture route or alternate Godot binary.

## Implementation result — 2026-07-20

- Runtime meadow: `1664 × 941`, one period = exactly `26` cells; repeated without horizontal scaling-to-fit.
- Old authored terrain layers `00–08` are absent from active rendering and pointer geometry.
- Meadow reaches below the viewport edge by a bounded 5-screen-pixel overscan, hiding the source alpha-tail without changing scale.
- Gameplay ground uses the approved meadow source row `803`; buildings, props and dogs share that baseline.
- Zoom `200%` produced a real macOS window size of `2992 × 404` inside a `2992 × 1876` usable screen rect; the previous fixed `224 px` height no longer limits high zoom.
- Exact Steam Godot `4.7.1.stable.steam.a13da4feb`: parser PASS, ordinary PlayerBoot PASS with diagnostic PASS and graceful ACK, four-frame internal viewport smoke PASS, accelerated Labrador route completed with `vertical_slice_complete=true`.
- Final internal player frame shows no bottom white stripe, no stretched legacy field, green translucent background trees and objects grounded on the approved meadow.
