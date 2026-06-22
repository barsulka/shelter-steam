# STEAM_VERTICAL_SLICE_ART_QA_CAPTURE v2

Дата capture: 2026-06-29
Роль: Codex capture pack для Art Director QA после fix pass v1
Статус: captured

## Purpose

Этот пакет содержит screenshots и PNG-frame sequence Steam Vertical Slice prototype после Level 0 visual/readability cleanup.

Пакет не фиксирует production art decisions. Он нужен для проверки:

- UI dominance после player-prototype mode;
- dog/action readability;
- distinguishability of resource placeholders;
- Food Mix -> Food Bag transformation;
- 216 / 144 / 96 readability preview.

## Contents

- `captures/screenshots/` - 15 required named screenshots плюс `09b_van_ready_confirm_delivery.png` как дополнительный player confirmation gate.
- `captures/video/vertical_slice_full_loop_short_frames/` - fallback video sequence, 27 PNG frames.
- `captures/logs/capture_run_log.txt` - runtime events и список сохранённых файлов.
- `CAPTURE_MANIFEST_v2.md` - таблица файлов, моментов и known issues.

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

Manual view presets:

```sh
cd steam
tools/dev-vertical-slice.sh qa
tools/dev-vertical-slice.sh player-prototype
```

`capture` first saves QA labels-on initial strip, then switches to player-prototype mode for the loop screenshots so Art QA can inspect readability with compact UI and semantic labels off.

## Capture Environment

- Godot: `4.7.stable.steam.5b4e0cb0f`
- Display server: `macOS`
- Renderer: Metal 4.0 Forward+
- Device reported by Godot: Apple M3 Pro
- Window mode: visible macOS companion strip, borderless, transparent, always-on-top
- Captured window size: `3456 x 224`
- Timing: fast capture timing, not normal player-facing timing
- Video: MP4 was not generated; accepted fallback is PNG-frame sequence

## Known Limitations

- These are prototype semantic/debug placeholders, not production art.
- Dog/action placeholders are still simple geometric silhouettes with action badges.
- The run is fast and deterministic for capture; it is not a normal feel/timing review.
- Headless Godot cannot capture viewport PNGs in this environment because the dummy renderer does not provide a viewport texture. Capture modes therefore use visible macOS Godot.
- Human Art Director review is still required for final readability judgement.
