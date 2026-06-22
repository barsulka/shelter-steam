# CQ Hero Town Window Behavior

## Current macOS Observations

- App name: `CQ Hero Town`.
- Bundle ID: `com.DefaultCompany.2D-URP`.
- The game renders as a mostly white/transparent desktop field with a narrow horizontal town strip along the bottom.
- The accessibility tree exposes the app window and menu bar, not individual game controls.
- The game is best inspected visually through screenshots.
- The game can be visually on top while another app is still frontmost; verify with:
  `osascript -e 'tell application "System Events" to name of first application process whose frontmost is true'`.
- Activate CQ explicitly before keyboard tests:
  `osascript -e 'tell application id "com.DefaultCompany.2D-URP" to activate'`.

## Click-Through / Transparency

- User-observed and treated as important: clicking blank/empty space sends focus/clicks to the application underneath the game.
- Therefore, blank white regions should be considered click-through or unsafe for casual interaction until proven otherwise.
- Only click blank regions when explicitly testing click-through with a harmless target app underneath.
- For Shelter, test intentional click-through separately from interactive-object clicks. A transparent field must not accidentally capture or leak clicks in ambiguous regions.

## UI Layering

- A right-side `Коллекция` panel can remain open over the field.
- When that panel is open, map navigation, zoom, and building clicks may not behave as expected.
- Clicking outside the panel did not close it in the observed state, likely because blank regions pass through to the app underneath.
- At low zoom, the whole field can fit on screen; horizontal panning may correctly do nothing even when keyboard input works.
- At a map edge, only the opposite pan direction should be expected to move the camera.
- In-game keyboard-scroll speed strongly affects whether panning is visually obvious.

## Shelter Lessons

- True or simulated transparent desktop space changes interaction safety: empty areas may not be safe click targets.
- Shelter should make interactive regions visually explicit if using click-through transparency.
- A companion-strip game needs a clear "input capture vs pass-through" model and a visible way to toggle it.
- Side panels should have reliable, easy-to-hit close controls and should not make focus state mysterious.
