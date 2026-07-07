# Steam First Day MVP Visible Review v3

Persistent capture pack for the First Day Art / UX Visual Language Pass prototype evidence.

This pack is not final art acceptance. It records the current prototype after the pass that moves meaning from cards, labels, badges, arrows and marker text toward object, state and animation language.

## Contents

- `captures/screenshots/` - named PNG screenshots for the main First Day beats, hidden UI checks and compact previews.
- `captures/video/first_day_mvp_visible_loop_frames_1x/` - PNG frame sequence captured at normal player-facing prototype speed.
- `captures/video/postcard_slippers_moment_1x/` - short PNG frame sequence around the postcard, next-day note and slippers moment.
- `captures/state/manifest.json` - Workbench 100x state proof manifest. This is debug/state proof only, not visual feel evidence.
- `captures/state/final_state.json` - final connector state.
- `captures/state/events.jsonl` - event proof.
- `captures/state/stress_signals.jsonl` - stress signal samples.
- `captures/logs/capture_run_log.txt` - visual capture run log.

## Counts

- Named screenshots: 20
- Full loop 1x frames: 86
- Postcard/slippers 1x frames: 41
- Workbench snapshots: 42
- Workbench events: 114
- Stress signal samples: 42

## Command

```bash
cd steam
tools/dev-vertical-slice.sh first-day-art-ux-capture
```
