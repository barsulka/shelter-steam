# Capture Manifest v3

- Capture profile: `first_day_art_ux_visual_language_pass_v1`
- Scenario: `first_delivery_with_dispatch_confirmation`
- Fixture: `first_day_empty_coop`
- State proof speed: `100x`
- Visual frame sequence: `captures/video/first_day_mvp_visible_loop_frames_1x/`
- Postcard/slippers frame sequence: `captures/video/postcard_slippers_moment_1x/`
- Named screenshots: `20`
- Full-loop frames: `86`
- Postcard/slippers frames: `41`
- State manifest: `captures/state/manifest.json`
- Final state: `captures/state/final_state.json`
- Events: `captures/state/events.jsonl`
- Stress signals: `captures/state/stress_signals.jsonl`

## Required Named Screenshots

- `01_initial_strip_qa_labels_on.png`
- `02_initial_strip_player_prototype.png`
- `03_route_prep_dachshund_bicycle.png`
- `04_dog_departure_bicycle.png`
- `05_bicycle_return_payload_objects.png`
- `06_unload_to_storage.png`
- `07_storage_to_kitchen_carry_object.png`
- `08_kitchen_food_mix.png`
- `09_food_mix_to_packing_table.png`
- `10_packing_table_food_bag_state.png`
- `11_food_bag_to_van.png`
- `12_van_ready_object_state.png`
- `13_delivery_complete_postcard_board.png`
- `14_dogs_notice_postcard_hidden_ui.png`
- `15_slippers_equip_dachshund_hidden_ui.png`
- `16_next_day_note_hidden_ui.png`
- `17_ui_hidden_world_visible.png`
- `18_readability_preview_216.png`
- `19_readability_preview_144.png`
- `20_readability_preview_96.png`

## Object / State Proof Keys

- `order.delivery_confirmed`
- `order.postcard_visible`
- `order.reward_available`
- `game.chain_complete`
- `first_day.postcard_life_moment_seen`
- `first_day.first_reward_equipped`
- `first_day.first_memory_added`
- `first_day.next_day_hint_available`
- `food_bag.hidden_after_delivery`
- `food_bag.semantic_delivered`
- `event.postcard_world_marker_shown`
- `event.next_day_hint_world_marker_shown`
- `event.first_reward_world_marker_shown`
- `event.packing_table_food_bag_state_visible`
- `event.van_ready_object_state_visible`
- `event.postcard_board_state_visible`
- `event.next_day_note_object_visible`
- `event.slippers_equipped_world_state_visible`

## Notes

- The 100x Workbench run is debug/state proof only.
- This capture does not claim final visual acceptance, final palette, final style, or production art quality.
- Hidden UI screenshots are included to check that the world remains legible without cards.
