# STEAM_VERTICAL_SLICE_ART_QA_CAPTURE v1

Дата capture: 2026-06-29
Роль: Codex capture pack для Art Director QA
Статус: captured

## Purpose

Этот пакет содержит screenshots и PNG-frame sequence текущего Steam Vertical Slice prototype, чтобы Art Director мог проверить readability, visual hierarchy, placeholder acceptability, dog/action visibility, UI dominance and main-strip composition без повторного запуска через Codex.

Пакет не фиксирует art decisions и не является Art Director conclusion.

## Contents

- `captures/screenshots/` - 19 named screenshots ключевых состояний loop.
- `captures/video/vertical_slice_full_loop_short_frames/` - fallback video sequence, 27 PNG frames.
- `captures/logs/capture_run_log.txt` - события runtime и список файлов, сохранённых capture mode.
- `CAPTURE_MANIFEST_v1.md` - таблица файлов, моментов и known issues.

## Capture Commands

Полный capture:

```sh
cd steam
tools/dev-vertical-slice.sh capture
```

Smoke-check capture path:

```sh
cd steam
tools/dev-vertical-slice.sh capture-smoke
```

The capture mode is dev-only. It runs the existing Vertical Slice scene with deterministic autoplay and fast timings, saves viewport PNGs on key states, then exits automatically.

`capture-smoke` writes to a temporary `_capture_smoke_tmp/` folder and removes it after validation, so it does not overwrite this delivered capture pack.

## Capture Environment

- Godot: `4.7.stable.steam.5b4e0cb0f`
- Display server: `macOS`
- Renderer: Metal 4.0 Forward+
- Device reported by Godot: Apple M3 Pro
- Window mode: visible macOS companion strip, borderless, transparent, always-on-top
- Captured window size: `3456 x 224`
- Timing: fast capture timing, not normal player-facing timing
- Labels: semantic/debug labels are on for most captures; `19_debug_labels_off.png` intentionally hides semantic labels
- Video: MP4 was not generated; accepted fallback is PNG-frame sequence

## Known Limitations

- These are prototype semantic/debug placeholders, not production art.
- Capture uses fast timings to keep the run deterministic and short.
- Frame sequence is not a real-time recording and should be reviewed as a visual sequence fallback.
- Headless Godot cannot capture viewport PNGs in this environment because the dummy renderer does not provide a viewport texture. Capture modes therefore use visible macOS Godot.
- Human Art Director review is still required for readability, visual hierarchy, dog/action visibility and placeholder acceptability.
