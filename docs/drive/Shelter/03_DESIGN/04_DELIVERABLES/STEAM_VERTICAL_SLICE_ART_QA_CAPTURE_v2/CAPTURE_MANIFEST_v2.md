# CAPTURE_MANIFEST v2

Дата: 2026-06-29
Capture pack: `STEAM_VERTICAL_SLICE_ART_QA_CAPTURE_v2`
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
- Initial QA capture: semantic labels/debug cards on
- Loop captures: player-prototype mode with semantic labels off, debug card hidden, compact UI
- Screencast fallback: `captures/video/vertical_slice_full_loop_short_frames/frame_0001.png` through `frame_0027.png`
- Missing required captures: none

## Screenshot Manifest

| File | Moment | Why it matters | Notes / known issues |
|---|---|---|---|
| `captures/screenshots/01_initial_strip_qa_labels_on.png` | Initial strip, QA labels on | Confirms semantic labels/debug info remain available for Codex/Art QA | UI/debug cards are intentionally visible |
| `captures/screenshots/02_initial_strip_player_prototype.png` | Initial strip, player-prototype mode | Checks compact UI and labels-off baseline | Debug card/status bar hidden |
| `captures/screenshots/03_bicycle_return_payload.png` | Bicycle return payload | Checks visible returned Oat/Pumpkin payload before Storage update | Player-prototype mode |
| `captures/screenshots/04_unload_to_storage.png` | Unload to Storage | Checks visible unload before inventory update | Simple dog/action placeholder |
| `captures/screenshots/05_storage_to_kitchen_carry.png` | Storage -> Kitchen carry | Checks dog carry action and attached resource readability | Compact UI remains visible |
| `captures/screenshots/06_kitchen_food_mix.png` | Kitchen / Food Mix | Checks Food Mix creation state | Food Mix uses separate geometric token |
| `captures/screenshots/07_food_mix_to_packing_table.png` | Food Mix -> Packing Table | Checks Food Mix remains physical before packing | Food Mix is not the Food Bag token |
| `captures/screenshots/08_packing_table_food_bag.png` | Packing Table -> Food Bag | Checks visible transformation and separate Food Bag token | Packing Table remains Utility Prop placeholder |
| `captures/screenshots/09_food_bag_to_van.png` | Food Bag -> Van | Checks visible load path to Delivery Van Endpoint | Van remains endpoint/vehicle |
| `captures/screenshots/09b_van_ready_confirm_delivery.png` | Van ready confirmation gate | Extra capture for player-confirmed delivery | Not part of the 15 required screenshots |
| `captures/screenshots/10_postcard_reward.png` | Postcard reward | Checks calm reward tone | Postcard remains placeholder UI card |
| `captures/screenshots/11_dog_card_slippers.png` | Dog Card / Slippers | Checks D-010 innate trait and equipment separation | Slippers are simple equipment marker |
| `captures/screenshots/12_ui_hidden_world_visible.png` | UI hidden world visible | Checks world strip remains visible without UI dominance | Only Show UI control remains |
| `captures/screenshots/13_readability_preview_216.png` | Readability preview 216 | Downscaled world visibility check | Height is 216 px |
| `captures/screenshots/14_readability_preview_144.png` | Readability preview 144 | Downscaled world visibility check | Height is 144 px |
| `captures/screenshots/15_readability_preview_96.png` | Readability preview 96 | Downscaled world visibility check | Height is 96 px |

## Video / Sequence Manifest

`captures/video/vertical_slice_full_loop_short_frames/` contains 27 PNG frames:

```text
frame_0001.png ... frame_0027.png
```

This is the accepted fallback for `captures/video/vertical_slice_full_loop_short.mp4`. The sequence was captured during the same full loop run as the screenshots.

## Known Visual Limitations

- All new placeholders are Level 0 semantic prototype shapes, not final art.
- The Food Mix / Food Bag composite PNG remains available internally as a bridge, but visible tokens are separate.
- The dog/action readability improvement is a placeholder pass, not Dog Shape Pack v1.
- Player-prototype mode reduces UI dominance but does not represent final player UI style.
