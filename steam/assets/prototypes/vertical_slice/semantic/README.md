# Steam Vertical Slice Semantic Asset Mirror

Дата: 2026-06-29
Статус: implementation mirror for Codex prototype use

This folder contains Steam-local copies of approved semantic placeholders from:

`docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Semantic_Asset_Pack_v1/approved/`

These files are implementation mirrors for stable `res://` paths in Godot. They are not new art approvals and do not replace the source registry in `docs/drive`.

## Source Mapping

| Taxonomy | Source | Steam-local mirror |
|---|---|---|
| Utility Prop | `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Semantic_Asset_Pack_v1/approved/utility_props/road_sign.png` | `steam/assets/prototypes/vertical_slice/semantic/utility_props/road_sign.png` |
| Utility Prop / Transport | `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Semantic_Asset_Pack_v1/approved/utility_props/basket_bicycle.png` | `steam/assets/prototypes/vertical_slice/semantic/utility_props/basket_bicycle.png` |
| Building | `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Semantic_Asset_Pack_v1/approved/buildings/storage.png` | `steam/assets/prototypes/vertical_slice/semantic/buildings/storage.png` |
| Building | `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Semantic_Asset_Pack_v1/approved/buildings/kitchen.png` | `steam/assets/prototypes/vertical_slice/semantic/buildings/kitchen.png` |
| Utility Prop / Endpoint | `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Semantic_Asset_Pack_v1/approved/utility_props/delivery_van_endpoint.png` | `steam/assets/prototypes/vertical_slice/semantic/utility_props/delivery_van_endpoint.png` |
| Resource bridge | `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Semantic_Asset_Pack_v1/approved/resources/food_mix_and_food_bag_composite.png` | `steam/assets/prototypes/vertical_slice/semantic/resources/food_mix_and_food_bag_composite.png` |

## Missing Assets Represented In Code

`steam/scripts/prototypes/vertical_slice/vertical_slice_demo.gd` draws neutral labeled placeholders for currently missing Vertical Slice assets:

- Packing Table: Utility Prop placeholder, not a Building.
- Oat Crate, Pumpkin Crate, Protein Packet, Packaging Bag, Food Mix, Food Bag: Resource tokens.
- Comfortable Slippers: UI/equipment placeholder in the Dog Card and small dog-state marker after equip.
- First Postcard frame: compact UI card placeholder.
- Dachshund and Labrador action sprites: simple labeled dog silhouettes.

These placeholders exist only to preserve readable physical steps in the first playable prototype.
