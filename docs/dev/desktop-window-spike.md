# Desktop Window Spike

This is the recommended next technical step after the initial Godot bootstrap.

## Goal

Determine what Godot 4.x can do directly for Shelter's desktop companion-window concept, and where Windows/macOS native code, C#, GDExtension, or export-time platform configuration may be required.

## Questions

- Can the game run as a small, borderless, resizable desktop field on macOS and Windows?
- Can always-on-top be enabled reliably through Godot settings or runtime APIs?
- Can the window use real transparent areas without excessive redraw or GPU cost?
- Can click-through behavior work for transparent regions, and does it differ by platform?
- Can the interface be hidden or collapsed without breaking input, focus, or Steam behavior?
- How do multiple monitors, scaling, Retina displays, and Windows DPI scaling affect placement?
- What is the idle CPU/GPU/battery profile while the window is open for a long time?

## Spike Output

Record the result in `docs/dev/` and update `docs/status/CODEX_STATUS.md` with:

- Godot settings and APIs tested.
- macOS result.
- Windows result, once available.
- Performance notes.
- Known limitations.
- Whether native code, C#, or GDExtension is needed.

If the spike creates a technical commitment, add or update an ADR.

## Current Probe

The repo includes a small runtime probe:

```sh
tools/run-window-spike.sh visible
tools/run-window-spike.sh companion
tools/run-window-spike.sh smoke
```

Modes:

- `visible` opens a normal probe window and prints Godot/macOS window capability data.
- `companion` opens a small companion-style window, enables borderless mode, always-on-top, transparent background, and a mouse-interactive polygon over the probe panel.
- `smoke` runs the same scene headlessly for automated script/scene validation.

The probe uses only Godot 4.7 `DisplayServer` APIs:

- `window_set_flag(WINDOW_FLAG_ALWAYS_ON_TOP)`
- `window_set_flag(WINDOW_FLAG_BORDERLESS)`
- `window_set_flag(WINDOW_FLAG_TRANSPARENT)`
- `window_set_flag(WINDOW_FLAG_NO_FOCUS)`
- `window_set_flag(WINDOW_FLAG_MOUSE_PASSTHROUGH)`
- `window_set_mouse_passthrough(...)`
- screen scale, DPI, refresh-rate, usable-rect, and native-handle queries

## Current macOS Findings

- Godot 4.7 exposes direct APIs for always-on-top, borderless windows, transparent window flags, whole-window mouse passthrough, and polygon-limited mouse passthrough.
- The repo now enables `display/window/per_pixel_transparency/allowed`, `display/window/size/transparent`, and `rendering/viewport/transparent_background` so transparency can be tested.
- A short macOS companion-mode run succeeded through the real `macOS` display backend with Metal on Apple M3 Pro.
- In that run, Godot reported `window_transparency_feature=true`, `window_transparency_available=true`, `flag_always_on_top=true`, `flag_borderless=true`, `flag_transparent=true`, `window_can_draw=true`, and a 4-point interactive polygon.
- Screen metrics from the run: one screen, scale `2.0`, DPI `255`, refresh rate `120.0`, usable rect `[P: (0, 66), S: (3456, 2168)]`.
- Automated headless smoke tests can verify the scene and script, but they cannot prove visible macOS compositor behavior.
- Manual macOS validation is still required for real transparency, stacking above other apps, click-through behavior, focus behavior, external monitor placement, and battery/CPU profile.

## Open Validation

- Run `tools/run-window-spike.sh companion` next to Finder/Chrome/Steam and confirm whether transparent areas are visually transparent.
- Confirm whether the companion window stays above normal app windows without stealing focus too aggressively.
- Confirm whether clicks outside the probe panel pass through to the underlying app when the interactive polygon is enabled.
- Repeat on Windows before treating any behavior as cross-platform.
- Measure idle CPU/GPU after a 10-30 minute run with Activity Monitor on macOS and Task Manager on Windows.

## Reference Follow-Up

Repo-local CQ Hero Town reference notes now live in `.agents/skills/cq-hero-town-reference/`.

Use `docs/dev/companion-field-tech-demo.md` as the next implementation slice: build a small original Shelter companion field with zoom, pan, a few placeholder objects, click-through checks, multi-monitor placement, and a minimal settings window.
