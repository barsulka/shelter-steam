# Shelter Steam/Desktop

Shelter Steam/Desktop is the Windows/macOS Godot version of Shelter: a calm idle game about dogs, shelters, care, and transparent charity-oriented product design.

This repository is intentionally scoped to the Steam/Desktop product. Mobile and browser-extension ideas may share product research, content, economy concepts, or backend contracts later, but they are not part of this codebase by default.

## Current Stage

The project is at the initial Godot bootstrap stage. The repository contains only a minimal loadable Godot project, local development notes, and the first architecture/status documents.

No final gameplay loop, art direction, charity flow, Steam integration, or desktop window behavior has been implemented yet.

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

## Project Layout

- `project.godot` - Godot project settings.
- `.agents/skills/` - repo-local Codex skills for this product.
- `scenes/` - Godot scenes.
- `scripts/` - GDScript files.
- `docs/adr/` - architecture decisions.
- `docs/dev/` - development notes and technical spikes.
- `docs/status/CODEX_STATUS.md` - Codex working status after meaningful tasks.

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
tools/run-window-spike.sh visible
tools/run-window-spike.sh companion
tools/run-window-spike.sh smoke
```

Run the first companion field tech demo for manual testing with:

```sh
tools/run-companion-field-demo.sh
```

The default launch opens the companion strip and its settings window so window mode,
display, transparency, click-through empty space, zoom, and pan speed can be checked
without restarting. Narrow diagnostic presets are still available:

```sh
tools/run-companion-field-demo.sh normal
tools/run-companion-field-demo.sh click-through
tools/run-companion-field-demo.sh perf
tools/run-companion-field-demo.sh smoke
```

## Product Boundaries

Shelter should stay warm, calm, ethical, and focused on dogs and shelters.

Do not add combat, PvP, bosses, monsters, aggressive gacha, manipulative dark patterns, or predatory monetization. Charity-related mechanics must remain voluntary, clear, and non-coercive.

Desktop-specific work should treat performance as a product requirement: avoid unnecessary `_process()` loops, constant redraws, heavy visual effects, memory leaks, and avoidable battery drain.
