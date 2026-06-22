# Road Sign / Notice Board

## Status

APPROVED_FOR_CODEX

## Category

Utility Prop

## Used By

- Vertical Slice Contract: yes
- Object Contract object/action: Road Sign / Road Edge
- Task Flow task/event: TripTask, player_confirmed_trip, transport_returned

## Owners

- Design Owner: Game Designer
- Visual Owner: Art Director
- Implementation Owner: Codex

## Purpose

Physical route entry point for off-screen resource trips. It tells the player where trips start and where transport returns.

## Must

- Be a Utility Prop, not a building.
- Read as route / notice / road edge.
- Support Basket Bicycle departure and return staging.
- Leave upper strip area visually empty.

## Must Not

- Become a house, shop, depot building or full map.
- Look like Browser Extension UI.
- Include ads, sponsor card or search bar.

## Required Readability

- 216 px: unchecked
- 144 px: unchecked
- 96 px: unchecked

## Current Approved Asset

Composite source: `source_files/a_collection_of_eight_hand_drawn_digital_transpa.png`

## File Location

Target: `approved/utility_props/road_sign.png`

Background: near-black composite background removed; transparent PNG produced.

## Notes

High priority for Codex. This is the first player interaction anchor.

## History

- 2026-06-28: Card created.
- 2026-06-29: Visual asset approved for Codex as semantic placeholder before local PNG import.
- 2026-06-29: Composite source imported into repo and cropped to `approved/utility_props/road_sign.png`; status remains temporary semantic placeholder for Codex prototype use.
