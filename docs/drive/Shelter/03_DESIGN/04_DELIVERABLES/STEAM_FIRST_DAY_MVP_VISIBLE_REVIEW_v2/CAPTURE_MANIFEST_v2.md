# CAPTURE_MANIFEST v2

Дата: 2026-07-06
Capture pack: `STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v2`
Status: generated for focused readability review

## Command Used

```sh
cd steam
tools/dev-vertical-slice.sh first-day-visible-capture
```

## Environment

- Godot version: `4.7.stable.steam.5b4e0cb0f`
- Display/window mode: visible macOS companion strip, `2992 x 224`, borderless, transparent, always-on-top
- Timings: fast deterministic visible capture timings
- Initial QA capture: semantic labels/debug cards on
- Loop captures: player-prototype mode with semantic labels off, debug card hidden, compact UI
- Frame sequence: `captures/video/first_day_mvp_visible_loop_frames/frame_0001.png` through `frame_0028.png`
- State proof: matching deterministic Workbench run under `captures/state/`
- Missing required captures: none

## Screenshot Manifest

| File | Moment | Why it matters | Notes / known issues |
|---|---|---|---|
| `captures/screenshots/01_initial_strip_qa_labels_on.png` | Initial strip, QA labels on | Confirms semantic/debug labels are still available for internal validation | QA view; labels/debug visible |
| `captures/screenshots/02_initial_strip_player_prototype.png` | Initial strip, player-prototype mode | Checks baseline labels-off strip with stronger driver/helper cues | Player-prototype view; route marker and dog role badges visible |
| `captures/screenshots/03_first_route_ready.png` | First route ready before player confirms route | Shows first agency beat and Такса/bicycle association | Player-prototype view; route-ready cue visible |
| `captures/screenshots/04_dog_departure_bicycle.png` | Dog departure with Basket Bicycle | Checks route start/departure readability | Player-prototype view; fast timing |
| `captures/screenshots/05_bicycle_return_payload.png` | Bicycle return payload | Checks returned payload before storage changes | Player-prototype view; payload return marker and Storage arrow visible |
| `captures/screenshots/06_unload_to_storage.png` | Unload to Storage | Checks dog-owned unload/carry visibility | Player-prototype view; placeholder action shapes remain prototype-only |
| `captures/screenshots/07_storage_to_kitchen_carry.png` | Storage -> Kitchen carry | Checks resource carrying across the strip | Player-prototype view; helper role cue should support Лабрадор readability |
| `captures/screenshots/08_kitchen_food_mix.png` | Kitchen / Food Mix | Checks Kitchen step and Food Mix readability | Player-prototype view; prototype resource token |
| `captures/screenshots/09_food_mix_to_packing_table.png` | Food Mix -> Packing Table | Checks Food Mix remains physical before packing | Player-prototype view |
| `captures/screenshots/10_packing_table_food_bag.png` | Packing Table / Food Bag | Checks visible Food Bag output after packing | Player-prototype view; Packing Table is placeholder utility prop |
| `captures/screenshots/11_food_bag_to_van.png` | Food Bag -> Van | Checks Food Bag loading path to Delivery Van Endpoint | Player-prototype view |
| `captures/screenshots/12_van_ready_confirm_delivery.png` | Van ready, player confirms dispatch | Checks calm dispatch-confirmation gate | Van-ready main-strip marker visible; no urgency/failure pressure intended |
| `captures/screenshots/13_delivery_complete_postcard_moment.png` | Delivery complete / postcard appears | Checks first delivery closure cue after dispatch | Postcard card is visible; world marker begins the embodied cue |
| `captures/screenshots/14_dog_noticed_postcard.png` | Dog noticed postcard moment | Checks postcard-board and dog attention proof | Top postcard card can overlap part of the world; compare with screenshot 17 |
| `captures/screenshots/15_dog_card_memory_slippers.png` | Dog Card memory and slippers | Checks D-010 separation plus personal slippers cue | Такса-owned slippers marker is visible in the world and in Dog Card |
| `captures/screenshots/16_next_day_hint.png` | Soft next-day hint | Checks gentle continuation cue, not pressure | World note says “Завтра можно придумать, как паковать ещё аккуратнее.” |
| `captures/screenshots/17_ui_hidden_world_visible.png` | UI hidden, world visible | Checks strip readability without compact UI dominance | Main evidence for world-only postcard/reward/next-day readability |
| `captures/screenshots/18_readability_preview_216.png` | 216 px preview | Downscaled readability evidence | Generated from player-prototype/world-visible frame |
| `captures/screenshots/19_readability_preview_144.png` | 144 px preview | Downscaled readability evidence | Generated from player-prototype/world-visible frame |
| `captures/screenshots/20_readability_preview_96.png` | 96 px preview | Downscaled readability evidence | Size in this run: `1282 x 96` |

## Frame Sequence Manifest

`captures/video/first_day_mvp_visible_loop_frames/` contains 28 PNG frames captured during the same visible fast deterministic loop as the screenshots.

The frame sequence is an inspection fallback, not a final video deliverable and not proof of real-speed player feel.

## State Artifact Manifest

| File | Purpose | Notes |
|---|---|---|
| `captures/state/manifest.json` | Matching Workbench run manifest | Includes `first_day_mvp_proof`; `snapshot_count=42`; `events_written=109` |
| `captures/state/final_state.json` | Matching final `/state` snapshot | Confirms final First Day state and gentle hint text |
| `captures/state/events.jsonl` | Matching event records | Includes dog-action/story/debug proof and v2 marker events |
| `captures/state/stress_signals.jsonl` | Matching stress signals | Confirms designer-facing counters |

## v2 Readability Proof Additions

The v2 Workbench proof includes:

```text
event.postcard_world_marker_shown: true
event.next_day_hint_world_marker_shown: true
event.first_reward_world_marker_shown: true
```

These are review/prototype evidence only. They do not introduce a new gameplay system, new route, new dog, new production chain or full House of Curiosity loop.

## Known Visual Limitations

- This is fast deterministic visible capture, not normal pacing acceptance.
- Placeholder art and labels are still Level 0 prototype semantics.
- Post-delivery top-card UI can overlap the world in some screenshots.
- Dog/postcard/reward warmth needs human review; Codex does not claim visual PASS.
- Windows behavior is not covered by this macOS visible capture.
- House of Curiosity remains a next-day tease, not a full visible/research loop in this pack.
