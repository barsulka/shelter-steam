# STEAM_DESKTOP — Semantic Asset Pack v1 — Approved Asset Import Manifest

Дата: 2026-06-29
Статус: composite source imported and cropped into temporary semantic placeholders
Роль: local repo asset import manifest for Codex prototype use

## Important

The composite semantic source PNG is now present in the local repository:

```text
docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Semantic_Asset_Pack_v1/source_files/a_collection_of_eight_hand_drawn_digital_transpa.png
```

Codex cropped this composite into 6 temporary semantic placeholder PNG files under `approved/`.

The generated source image produced 6 usable objects, not 8 separate assets. This is acceptable as a temporary bridge for prototype implementation, not as final production art.

Background cleanup status: near-black composite background was removed from each crop and output PNGs contain transparency (`alpha=(0, 255)`). The cleanup is good enough for Codex prototype use, but final transparent-background polish is still incomplete.

## Approved for Codex prototype use

### 1. Road Sign / Notice Board

- Status: APPROVED_SEMANTIC_PLACEHOLDER
- Category: Utility Prop
- Composite source: `source_files/a_collection_of_eight_hand_drawn_digital_transpa.png`
- Crop output: `approved/utility_props/road_sign.png`
- Crop size: `464 x 435`
- Transparency/background status: near-black background removed; transparent PNG produced.
- Notes: good Utility Prop, not a house.

### 2. Basket Bicycle

- Status: APPROVED_SEMANTIC_PLACEHOLDER
- Category: Utility Prop / Transport
- Composite source: `source_files/a_collection_of_eight_hand_drawn_digital_transpa.png`
- Crop output: `approved/utility_props/basket_bicycle.png`
- Crop size: `455 x 385`
- Transparency/background status: near-black background removed; transparent PNG produced.
- Notes: readable transport. Later may need an empty basket variant, but current loaded basket is enough for Codex prototype.

### 3. Storage

- Status: APPROVED_SEMANTIC_PLACEHOLDER
- Category: Building
- Composite source: `source_files/a_collection_of_eight_hand_drawn_digital_transpa.png`
- Crop output: `approved/buildings/storage.png`
- Crop size: `570 x 385`
- Transparency/background status: near-black background removed; transparent PNG produced.
- Notes: readable open-front storage. Slightly large, but acceptable for prototype.

### 4. Kitchen

- Status: APPROVED_SEMANTIC_PLACEHOLDER
- Category: Building
- Composite source: `source_files/a_collection_of_eight_hand_drawn_digital_transpa.png`
- Crop output: `approved/buildings/kitchen.png`
- Crop size: `422 x 342`
- Transparency/background status: near-black background removed; transparent PNG produced.
- Notes: acceptable for Codex as temporary semantic placeholder. Still too cabinet/station-like and should be replaced later if readability suffers.

### 5. Delivery Van Endpoint

- Status: APPROVED_SEMANTIC_PLACEHOLDER
- Category: Utility Prop / Endpoint
- Composite source: `source_files/a_collection_of_eight_hand_drawn_digital_transpa.png`
- Crop output: `approved/utility_props/delivery_van_endpoint.png`
- Crop size: `486 x 308`
- Transparency/background status: near-black background removed; transparent PNG produced.
- Notes: readable delivery endpoint / van placeholder. Prototype must still make the visible Food Bag loading step explicit in gameplay.

### 6. Food Mix + Food Bag composite resource

- Status: APPROVED_SEMANTIC_PLACEHOLDER
- Category: Resource
- Composite source: `source_files/a_collection_of_eight_hand_drawn_digital_transpa.png`
- Crop output: `approved/resources/food_mix_and_food_bag_composite.png`
- Crop size: `604 x 290`
- Transparency/background status: near-black background removed; transparent PNG produced.
- Notes: Food Mix and Food Bag remain combined in one temporary resource composite. Use only as a bridge until separate resource PNGs exist.

## Missing or incomplete assets after this import

The semantic pack is still incomplete. Known missing or incomplete items:

- Packing Table;
- separate Oat Crate;
- separate Pumpkin Crate;
- Protein Packet;
- Packaging Bag;
- separate Food Mix;
- separate Food Bag;
- Comfortable Slippers icon;
- First Postcard frame;
- dog action sprites;
- final transparent-background cleanup/polish for cropped images.

If a gameplay prototype needs one of these missing assets before Art Direction provides a final placeholder, Codex may use a simple temporary placeholder and must document it in status/dev notes.

## Rejected / not for Codex

### Old kitchen attempt

- Status: REJECTED_FOR_CODEX / direction only
- Sandbox source: `/mnt/data/уютная_кухня_в_деревянном_домике.png`
- Reason: too interior/cutaway-like for main overlay.

### Old storage attempt

- Status: direction only
- Sandbox source: `/mnt/data/уютный_складик_с_деревянным_фасадом.png`
- Reason: too cozy house-like; replaced by open-front storage direction.

### Old delivery van attempt

- Status: direction only
- Sandbox source: `/mnt/data/kultainen_pakettiauto_ja_laatikko.png`
- Reason: more van hero asset than endpoint.
