# CAPTURE_MANIFEST v1

Дата: 2026-07-05
Capture pack: `STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v1`
Status: generated for review

## Command Used

```sh
cd steam
tools/dev-vertical-slice.sh first-day-visible-capture
```

## Environment

- Godot version: `4.7.stable.steam.5b4e0cb0f`
- Display/window mode: visible macOS companion strip, `3456 x 224`, borderless, transparent, always-on-top
- Timings: fast deterministic visible capture timings
- Initial QA capture: semantic labels/debug cards on
- Loop captures: player-prototype mode with semantic labels off, debug card hidden, compact UI
- Frame sequence: `captures/video/first_day_mvp_visible_loop_frames/frame_0001.png` onward
- State proof: matching deterministic Workbench run under `captures/state/`
- Missing required captures: none expected

## Screenshot Manifest

| File | Moment | Why it matters | Notes / known issues |
|---|---|---|---|
| `captures/screenshots/01_initial_strip_qa_labels_on.png` | Initial strip, QA labels on | Confirms semantic/debug labels are available for internal validation | QA view; labels/debug visible |
| `captures/screenshots/02_initial_strip_player_prototype.png` | Initial strip, player-prototype mode | Checks baseline compact UI with labels off | Player-prototype view; labels off |
| `captures/screenshots/03_first_route_ready.png` | First route ready before player confirms route | Shows initial player agency beat and first-day setup | Player-prototype view; deterministic capture |
| `captures/screenshots/04_dog_departure_bicycle.png` | Dog departure with Basket Bicycle | Checks whether route start/departure is visually readable | Player-prototype view; fast timing |
| `captures/screenshots/05_bicycle_return_payload.png` | Bicycle return payload | Checks Oat/Pumpkin payload before storage changes | Player-prototype view; payload should be visible |
| `captures/screenshots/06_unload_to_storage.png` | Unload to Storage | Checks physical unload/carry visibility before inventory state dominates | Player-prototype view; placeholder dog/action shapes |
| `captures/screenshots/07_storage_to_kitchen_carry.png` | Storage -> Kitchen carry | Checks resource carrying across the strip | Player-prototype view; compact UI remains present |
| `captures/screenshots/08_kitchen_food_mix.png` | Kitchen / Food Mix | Checks Kitchen step and Food Mix readability | Player-prototype view; prototype resource token |
| `captures/screenshots/09_food_mix_to_packing_table.png` | Food Mix -> Packing Table | Checks Food Mix remains physical before packing | Player-prototype view |
| `captures/screenshots/10_packing_table_food_bag.png` | Packing Table / Food Bag | Checks visible Food Bag output after packing | Player-prototype view; Packing Table is placeholder utility prop |
| `captures/screenshots/11_food_bag_to_van.png` | Food Bag -> Van | Checks Food Bag loading path to Delivery Van Endpoint | Player-prototype view |
| `captures/screenshots/12_van_ready_confirm_delivery.png` | Van ready, player confirms dispatch | Checks calm dispatch-confirmation gate | Player-prototype view; no urgency/failure pressure intended |
| `captures/screenshots/13_delivery_complete_postcard_moment.png` | Delivery complete / postcard appears | Checks first delivery closure cue after dispatch | Player-prototype view; runtime-scaffolded postcard placeholder |
| `captures/screenshots/14_dog_noticed_postcard.png` | Dog noticed postcard moment | Checks whether dog/life closure is visible enough for review | Player-prototype view; not final animation/art |
| `captures/screenshots/15_dog_card_memory_slippers.png` | Dog Card memory and slippers | Checks D-010 separation between innate trait, memory and equipment | Player-prototype view; equipment marker is placeholder |
| `captures/screenshots/16_next_day_hint.png` | Soft next-day hint | Checks gentle continuation cue, not pressure | Player-prototype view; state-backed hint |
| `captures/screenshots/17_ui_hidden_world_visible.png` | UI hidden, world visible | Checks whether strip remains readable without compact UI dominance | Player-prototype/world-focused view; Show UI control may remain |
| `captures/screenshots/18_readability_preview_216.png` | 216 px preview | Downscaled readability evidence | Generated from player-prototype/world-visible frame |
| `captures/screenshots/19_readability_preview_144.png` | 144 px preview | Downscaled readability evidence | Generated from player-prototype/world-visible frame |
| `captures/screenshots/20_readability_preview_96.png` | 96 px preview | Downscaled readability evidence | Generated from player-prototype/world-visible frame |

## Frame Sequence Manifest

`captures/video/first_day_mvp_visible_loop_frames/` contains PNG frames captured during the same visible fast deterministic loop as the screenshots.

The frame sequence is an inspection fallback, not a final video deliverable and not proof of real-speed player feel.

## State Artifact Manifest

| File | Purpose | Notes |
|---|---|---|
| `captures/state/manifest.json` | Matching Workbench run manifest | Must include `first_day_mvp_proof` |
| `captures/state/final_state.json` | Matching final `/state` snapshot | Confirms final First Day state |
| `captures/state/events.jsonl` | Matching event records | Confirms dog-action/story/debug event proof |
| `captures/state/stress_signals.jsonl` | Matching stress signals | Confirms designer-facing counters |

## Known Visual Limitations

- This is fast deterministic visible capture, not normal pacing acceptance.
- Placeholder art and labels are still Level 0 prototype semantics.
- Dog/postcard/reward warmth needs human review; Codex does not claim visual PASS.
- Windows behavior is not covered by this macOS visible capture.
- House of Curiosity remains a next-day tease, not a full visible/research loop in this pack.
