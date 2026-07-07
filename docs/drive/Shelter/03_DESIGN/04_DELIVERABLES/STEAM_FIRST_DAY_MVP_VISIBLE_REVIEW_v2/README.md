# STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW v2

Дата capture pack: 2026-07-06
Статус: generated for focused visible/readability review

## Purpose

Этот пакет содержит persistent visual evidence для First Day MVP после узкого R-23 readability pass.

Цель v2 — дать Game Designer / Art Director / UX review материал, чтобы глазами проверить, стали ли main strip и действия собак понятнее без опоры только на top cards:

- Такса как первый водитель;
- Лабрадор как спокойный помощник;
- route / payload / van / postcard / reward / next-day hint cues;
- embodied postcard-board moment;
- личные `Удобные тапочки` для Таксы;
- мягкий visible next-day hint.

Это не final production art acceptance и не финальный verdict по player feel. State proof подтверждает runtime causality, но visual/readability вывод остаётся человеческим review.

## Command

```sh
cd steam
tools/dev-vertical-slice.sh first-day-visible-capture
```

Команда теперь пишет v2 pack:

```text
docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v2/
```

Команда выполняет два deterministic pass:

1. visible macOS Godot capture pass для named screenshots и PNG-frame sequence;
2. matching Workbench state-proof pass для `first_delivery_with_dispatch_confirmation`, copied into `captures/state/`.

## Environment

- Godot: `4.7.stable.steam.5b4e0cb0f`
- Display server: `macOS`
- Renderer: Metal 4.0 Forward+
- Observed device in this run: Apple M3 Pro
- Window mode: visible macOS companion strip, borderless, transparent, always-on-top
- Captured window size in this run: `2992 x 224`
- Timing: fast deterministic visible capture, not normal player-facing timing
- Video format: PNG-frame sequence fallback, not MP4

## Contents

- `captures/screenshots/` — 20 required named screenshots.
- `captures/video/first_day_mvp_visible_loop_frames/` — 28 PNG frames for the visible loop.
- `captures/logs/capture_run_log.txt` — visible capture log and event list.
- `captures/state/manifest.json` — matching Workbench manifest with `first_day_mvp_proof`.
- `captures/state/final_state.json` — matching final `/state` snapshot.
- `captures/state/events.jsonl` — matching event records.
- `captures/state/stress_signals.jsonl` — matching stress signal records.
- `CAPTURE_MANIFEST_v2.md` — screenshot, frame sequence and state artifact manifest.

## Runtime Proof Summary

The matching Workbench manifest reports:

```text
exit_status: success
snapshot_count: 42
events_written: 109
```

Required proof remains true:

```text
order.delivery_confirmed: true
order.postcard_visible: true
order.reward_available: true
game.chain_complete: true
first_day.postcard_life_moment_seen: true
first_day.first_reward_equipped: true
first_day.first_memory_added: true
first_day.next_day_hint_available: true
food_bag.location: delivered_to_shelter
food_bag.hidden_after_delivery: true
food_bag.semantic_delivered: true
```

v2 also includes review-only marker proof:

```text
event.postcard_world_marker_shown: true
event.next_day_hint_world_marker_shown: true
event.first_reward_world_marker_shown: true
```

The final state exposes the gentle hint text:

```text
Завтра можно придумать, как паковать ещё аккуратнее.
```

## Known Limitations

- Fast deterministic capture is useful for review evidence, but it does not prove real-speed player feel.
- Placeholder dog/resource/postcard/slippers visuals are prototype semantics, not production art.
- The state proof is a matching deterministic Workbench run, not the same process as the visible viewport capture.
- Some post-delivery top-card UI can still overlap the world; `17_ui_hidden_world_visible.png` is included to review strip-only readability.
- Human Game Designer / Art Director / UX review is still required.
- No final visual acceptance is claimed by this pack.
