# STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW v1

Дата capture pack: 2026-07-05
Статус: generated for visible/player-feel review

## Purpose

Этот пакет содержит persistent visual evidence для актуального First Day MVP после `First Day MVP Runtime Polish v1`.

Пакет нужен Game Designer / Art Director / UX review, чтобы глазами проверить:

- calm desktop feel;
- visual readability of dogs, resources, van and postcard moments;
- whether the first day reads as warm dog co-op work, not only as a correct state machine;
- 216 / 144 / 96 px readability previews.

Это не final production art acceptance. Это also не автоматический visual verdict: state proof подтверждает runtime causality, но visual/player-feel вывод остаётся человеческим review.

## Command

```sh
cd steam
tools/dev-vertical-slice.sh first-day-visible-capture
```

The command runs two deterministic passes:

1. a visible macOS Godot capture pass for screenshots and PNG frame sequence;
2. a matching Workbench state-proof pass for `first_delivery_with_dispatch_confirmation`, copied into `captures/state/`.

Both passes use the same current First Day MVP implementation. The state proof is intentionally generated through the existing Workbench/control path so `first_day_mvp_proof` stays tied to the accepted runtime contract.

## Environment

- Godot: `4.7.stable.steam.5b4e0cb0f`
- Display server: `macOS`
- Renderer: Metal 4.0 Forward+
- Window mode: visible macOS companion strip, borderless, transparent, always-on-top
- Captured window size observed in this environment: `3456 x 224`
- Timing: fast deterministic visible capture, not normal player-facing timing
- Video format: PNG-frame sequence fallback, not MP4

## Contents

- `captures/screenshots/` - 20 required named screenshots.
- `captures/video/first_day_mvp_visible_loop_frames/` - PNG-frame sequence for the full visible loop.
- `captures/logs/capture_run_log.txt` - visible capture log and event list.
- `captures/state/manifest.json` - matching Workbench manifest with `first_day_mvp_proof`.
- `captures/state/final_state.json` - matching final `/state` snapshot.
- `captures/state/events.jsonl` - matching event records.
- `captures/state/stress_signals.jsonl` - matching stress signal records.
- `CAPTURE_MANIFEST_v1.md` - screenshot, frame sequence and state artifact manifest.

## Runtime Proof Link

This pack follows the accepted R-21 runtime review:

```text
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Runtime_Review__First_Day_MVP_Runtime_Polish_v1.md
```

Expected state proof includes:

```text
first_day_mvp_proof exists
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

## Known Limitations

- Fast deterministic capture is useful for review evidence, but it does not prove real-speed player feel.
- Placeholder dog/resource/postcard/slippers visuals are prototype semantics, not production art.
- The state proof is a matching deterministic Workbench run, not the same process as the visible viewport capture.
- Human review is still required for warmth, readability, emotional closure and whether the compact UI supports the strip.
- No final visual acceptance is claimed by this pack.
