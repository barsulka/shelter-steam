# Godot Setup

This repository uses Godot 4.x for the Steam/Desktop product.

The verified local Steam installation on this machine is:

```sh
$HOME/Library/Application Support/Steam/steamapps/common/Godot Engine/Godot.app/Contents/MacOS/Godot
```

Verified version:

```text
4.7.stable.steam.5b4e0cb0f
```

## Recommended Environment

Set `GODOT_BIN` before running repo scripts:

```sh
export GODOT_BIN="$HOME/Library/Application Support/Steam/steamapps/common/Godot Engine/Godot.app/Contents/MacOS/Godot"
```

Then validate the project:

```sh
tools/check-godot.sh
```

## Manual Checks

```sh
"$GODOT_BIN" --version
"$GODOT_BIN" --headless --path . --import
"$GODOT_BIN" --headless --path . --quit-after 2
"$GODOT_BIN" --headless --path . --check-only --script res://scripts/main.gd
```

If Godot is installed through another channel, keep the repo scripts unchanged and override only `GODOT_BIN`.

## Notes

- The initial project is intentionally minimal.
- Do not add C#, GDExtension, Steamworks, export templates, or platform-specific window code until a concrete spike or feature requires them.
- Export presets are ignored for now because they may include local paths or signing details. Add sanitized presets later when the build process is defined.
