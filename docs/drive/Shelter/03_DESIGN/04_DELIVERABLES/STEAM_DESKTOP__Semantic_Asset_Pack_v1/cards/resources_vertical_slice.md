# Vertical Slice Resource Set

## Status

APPROVED_SEMANTIC_PLACEHOLDER for combined Food Mix + Food Bag only

NEEDED for separate Vertical Slice resources

## Category

Resource

## Used By

- Vertical Slice Contract: yes
- Object Contract object/action: Resources
- Task Flow task/event: UnloadTask, CarryTask, CookTask, PackTask, LoadVanTask

## Owners

- Design Owner: Game Designer
- Visual Owner: Art Director
- Implementation Owner: Codex

## Purpose

Physical resource placeholders for the first complete production loop. They prevent resource flow from becoming abstract inventory math.

## Must

- Each resource must have a distinct semantic silhouette.
- Crates must read as carryable world objects.
- Food Mix and Food Bag must read as production outputs.
- Resource state changes must be visible in world.

## Must Not

- Exist only as UI numbers.
- Use realistic meat, blood, knives, carcasses or slaughter imagery.
- Look like currency or monetization tokens.

## Required Readability

- 216 px: unchecked
- 144 px: unchecked
- 96 px: unchecked

## Current Approved Asset

Composite source: `source_files/a_collection_of_eight_hand_drawn_digital_transpa.png`

Approved temporary composite:

- `approved/resources/food_mix_and_food_bag_composite.png`

Separate resource PNGs do not exist yet.

## File Location

Targets:

- `approved/resources/oat_crate.png`
- `approved/resources/pumpkin_crate.png`
- `approved/resources/protein_packet.png`
- `approved/resources/packaging_bag.png`
- `approved/resources/food_mix.png`
- `approved/resources/food_bag.png`

Temporary bridge:

- `approved/resources/food_mix_and_food_bag_composite.png`

## Notes

Level 0 semantic placeholders can be simple labeled or color-coded icons as long as filenames and silhouettes are unambiguous.

Food Mix and Food Bag are currently combined in one temporary resource composite. Do not treat this as the final resource taxonomy.

## History

- 2026-06-28: Card created.
- 2026-06-29: Composite source imported into repo and cropped to `approved/resources/food_mix_and_food_bag_composite.png`; separate resource assets remain missing.
