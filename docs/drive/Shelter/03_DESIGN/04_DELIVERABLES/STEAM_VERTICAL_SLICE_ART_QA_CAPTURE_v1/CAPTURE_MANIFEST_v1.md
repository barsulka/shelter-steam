# CAPTURE_MANIFEST v1

Дата: 2026-06-29
Capture pack: `STEAM_VERTICAL_SLICE_ART_QA_CAPTURE_v1`
Status: captured

## Command Used

```sh
cd steam
tools/dev-vertical-slice.sh capture
```

Smoke check:

```sh
cd steam
tools/dev-vertical-slice.sh capture-smoke
```

## Environment

- Godot version: `4.7.stable.steam.5b4e0cb0f`
- Display/window mode: visible macOS companion strip, `3456 x 224`, borderless, transparent, always-on-top
- Timings: fast deterministic capture timings
- Labels: semantic/debug labels on for captures `01`-`18`; semantic labels off for `19_debug_labels_off.png`
- Screencast fallback: `captures/video/vertical_slice_full_loop_short_frames/frame_0001.png` through `frame_0027.png`
- Missing required captures: none

## Screenshot Manifest

| File | Moment | Why it matters | Notes / known issues |
|---|---|---|---|
| `captures/screenshots/01_initial_strip.png` | Initial strip with world anchors and UI visible | Shows baseline composition, bottom strip, object spacing and UI scale | Prototype placeholders and labels are visible |
| `captures/screenshots/02_order_or_route_card.png` | Order Card and Route Card before sending | Checks whether player intent and first route are readable before action starts | Same early state as initial, focused on cards |
| `captures/screenshots/03_dachshund_to_bicycle.png` | Dachshund starts toward Basket Bicycle | Checks dog/action visibility before transport departure | Uses simple dog silhouette and semantic label |
| `captures/screenshots/04_bicycle_departure.png` | Basket Bicycle leaves strip | Checks physical transport departure rather than instant route completion | Fast timing; capture is a mid-motion state |
| `captures/screenshots/05_trip_state.png` | Calm trip state near Road Sign | Checks non-urgent travel tone and empty upper space | Transport is away; route state is represented by UI/status |
| `captures/screenshots/06_bicycle_return_payload.png` | Bicycle returns with visible payload | Checks returned resources exist physically before Storage update | Payload uses simple resource tokens |
| `captures/screenshots/07_unload_to_storage.png` | Dogs unload cargo into Storage | Checks visible unload before inventory changes | Prototype straight-line motion |
| `captures/screenshots/08_storage_to_kitchen_carry.png` | Resource carry from Storage to Kitchen | Checks physical carry step and dog work readability | Labels help distinguish resource/action |
| `captures/screenshots/09_kitchen_work_or_food_mix.png` | Kitchen work / Food Mix creation state | Checks Kitchen production state before next carry | Placeholder cooking motion is minimal |
| `captures/screenshots/10_food_mix_to_packing.png` | Food Mix carried to Packing Table | Checks Food Mix remains physical and does not become UI-only | Food Mix uses temporary composite-backed token |
| `captures/screenshots/11_packing_table_food_bag.png` | Packing Table / Food Bag state | Checks Food Mix to Food Bag transformation readability | Packing Table is a debug Utility Prop placeholder |
| `captures/screenshots/12_food_bag_to_van.png` | Food Bag carried to Delivery Van Endpoint | Checks visible loading chain before van readiness | Fast mid-motion capture |
| `captures/screenshots/13_van_ready_confirm_delivery.png` | Van ready and waiting for player confirmation | Checks player-confirmed delivery gate and UI dominance | Capture mode pauses autoplay briefly for this state |
| `captures/screenshots/14_postcard_reward.png` | Postcard and reward moment | Checks reward tone and postcard UI | Placeholder postcard card; no art conclusion |
| `captures/screenshots/15_dog_card_slippers.png` | Dog Card with innate trait and equipment separated | Checks D-010 separation is visible | Comfortable Slippers are debug equipment placeholder |
| `captures/screenshots/16_hide_ui_world_visible.png` | UI hidden, world still visible | Checks world remains visible/alive with UI hidden | Only minimal show control remains |
| `captures/screenshots/17_show_ui_restored.png` | UI restored | Checks hide/show recovery state | Debug labels restored |
| `captures/screenshots/18_debug_labels_on.png` | Debug/semantic labels on | Checks label usefulness for prototype QA | Same restored state as 17, labels intentionally visible |
| `captures/screenshots/19_debug_labels_off.png` | Debug/semantic labels off | Checks prototype without semantic labels | UI debug card remains visible; semantic world labels are hidden |

## Video / Sequence Manifest

`captures/video/vertical_slice_full_loop_short_frames/` contains 27 PNG frames:

```text
frame_0001.png ... frame_0027.png
```

This is the accepted fallback for `captures/video/vertical_slice_full_loop_short.mp4`. The sequence was captured during the same full loop run as the screenshots.

## Known Visual Limitations

- Approved semantic PNGs and debug placeholders are temporary.
- Missing production art remains for dog action sprites, Packing Table, separate resource icons, postcard and Comfortable Slippers.
- The run is fast and deterministic for capture; it is not a normal feel/timing review.
- No Art Director conclusion is encoded in this manifest.
