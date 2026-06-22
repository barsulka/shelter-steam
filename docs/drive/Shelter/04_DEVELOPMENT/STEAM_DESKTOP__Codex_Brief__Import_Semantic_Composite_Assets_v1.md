# STEAM_DESKTOP — Codex Brief — Import Semantic Composite Assets v1

Дата: 2026-06-29
Роль документа: Codex Implementation Brief / Asset Import Bridge
Статус: completed by Codex on 2026-06-29; source PNG imported and cropped
Продукт: Steam/Desktop idle always-on-top strip
Обязателен для: Codex / Development Agent
Связанные документы:

- `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Semantic_Asset_Pack_v1/README.md`
- `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Semantic_Asset_Pack_v1/APPROVED_ASSET_IMPORT_MANIFEST_v1.md`
- `STEAM_DESKTOP__Codex_Implementation_Brief__Vertical_Slice_v1.md`
- `STEAM_DESKTOP__Vertical_Slice_Scope_Lock_v1.md`

---

## 0. Purpose

This brief gives Codex a concrete local-repo task for importing a generated composite PNG into the Steam/Desktop Semantic Asset Pack.

The user will manually place the image file into the repo. Codex must not download it from Google Drive or ChatGPT transfer.

Codex must split the composite into separate temporary semantic placeholder assets, update docs, and preserve gameplay contracts.

---

## 1. Source file expected from user

The user will manually save the composite PNG here:

```text
docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Semantic_Asset_Pack_v1/source_files/a_collection_of_eight_hand_drawn_digital_transpa.png
```

Expected exact filename:

```text
a_collection_of_eight_hand_drawn_digital_transpa.png
```

If this file is missing, Codex must stop and report the exact expected path to the user.

---

## 2. Source image reality

Despite the filename mentioning eight assets, the current image is one composite PNG with 6 usable objects, not 8 separate PNGs.

The visible objects are expected to be:

1. Road Sign / Notice Board
2. Basket Bicycle
3. Storage
4. Kitchen
5. Delivery Van / Delivery Van Endpoint
6. Food Mix + Food Bag combined in one resource area

This is acceptable as a temporary semantic bridge, not as final production art.

---

## 3. Required output files

Codex must crop the composite into separate PNG files and place them here:

### 3.1 Road Sign / Notice Board

```text
docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Semantic_Asset_Pack_v1/approved/utility_props/road_sign.png
```

### 3.2 Basket Bicycle

```text
docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Semantic_Asset_Pack_v1/approved/utility_props/basket_bicycle.png
```

### 3.3 Storage

```text
docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Semantic_Asset_Pack_v1/approved/buildings/storage.png
```

### 3.4 Kitchen

```text
docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Semantic_Asset_Pack_v1/approved/buildings/kitchen.png
```

### 3.5 Delivery Van Endpoint

```text
docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Semantic_Asset_Pack_v1/approved/utility_props/delivery_van_endpoint.png
```

### 3.6 Food Mix + Food Bag temporary composite resource

```text
docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Semantic_Asset_Pack_v1/approved/resources/food_mix_and_food_bag_composite.png
```

---

## 4. Cropping / processing instructions

The source file is a composite image laid out roughly as 3 objects on the top row and 3 objects on the bottom row.

Codex must:

1. crop each object with small padding;
2. save each crop as PNG;
3. preserve as much visual quality as possible;
4. remove background only if it can be done safely and quickly;
5. avoid overengineering background removal.

If transparent background cannot be produced safely, Codex may keep a cropped image with background and must document this limitation in the manifest/status.

This is a prototype semantic asset import, not production asset cleanup.

---

## 5. Optional Steam-local copy

If useful for Godot prototype implementation, Codex may also copy the cropped PNG files into:

```text
steam/assets/prototypes/vertical_slice/semantic/
```

Preserve filenames.

If this copy is made, document the source path and copied target path in status/docs.

---

## 6. Documentation updates required

Codex must update:

```text
docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Semantic_Asset_Pack_v1/APPROVED_ASSET_IMPORT_MANIFEST_v1.md
```

The manifest must state:

- the composite source file is now in repo;
- 6 cropped semantic placeholder PNG files were created;
- these 6 files are approved for Codex prototype use as temporary semantic placeholders;
- original generation produced 6 usable objects, not 8 separate objects;
- Food Mix and Food Bag are still combined in one temporary resource composite;
- transparency/background status for crops;
- which assets remain missing.

Codex must also update:

```text
docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Semantic_Asset_Pack_v1/README.md
```

If older documentation says PNG assets are not yet present in `approved/`, replace that with an accurate state:

- 6 composite-derived placeholders now exist in `approved/`;
- the semantic pack is still incomplete;
- missing assets are listed separately.

---

## 7. Documentation phrase corrected after import

The active documentation state after import must use this meaning:

```text
Важный практический момент: composite semantic source PNG уже импортирован в repo и разрезан на 6 временных semantic placeholder assets. Они доступны для Codex prototype use. Часть Vertical Slice ассетов всё ещё отсутствует или объединена временно: Packing Table, отдельные Oat/Pumpkin/Protein/Packaging/Food Mix/Food Bag resources, Comfortable Slippers icon, First Postcard frame и dog action sprites. Если для gameplay prototype нужен missing asset, использовать простой временный placeholder и зафиксировать это в status/dev note.
```

Older import-not-yet-done claims should be updated to match the new state after import.

---

## 8. Cards update

If relevant asset card files exist under:

```text
docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Semantic_Asset_Pack_v1/cards/
```

Codex must update cards for imported assets:

- Road Sign / Notice Board
- Basket Bicycle
- Storage
- Kitchen
- Delivery Van Endpoint
- Food Mix + Food Bag composite resource, if a card exists or if a new card is needed

Card status should be one of:

- `APPROVED_FOR_CODEX`
- `APPROVED_SEMANTIC_PLACEHOLDER`

Each card should include:

- source composite path;
- crop output path;
- notes about limitations;
- status as temporary semantic placeholder, not production art.

---

## 9. Missing assets to document

After import, Codex must clearly document that the semantic pack is still incomplete.

Known missing or incomplete items:

- Packing Table, unless the composite unexpectedly contains a usable one;
- separate Oat Crate;
- separate Pumpkin Crate;
- Protein Packet;
- Packaging Bag;
- separate Food Mix;
- separate Food Bag;
- Comfortable Slippers icon;
- First Postcard frame;
- dog action sprites;
- transparent-background cleanup may still be incomplete for the cropped images.

---

## 10. Status update required

Codex must update:

```text
docs/repo/status/CODEX_STATUS.md
```

Add a status entry with:

- date;
- branch if known;
- summary: import and crop semantic composite assets;
- created PNG files;
- updated documentation files;
- checks run;
- assumptions;
- blockers;
- missing assets;
- next recommended step.

Recommended checks:

```sh
find docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Semantic_Asset_Pack_v1/approved -type f | sort
rg -n "composite semantic source PNG уже импортирован|Food Mix and Food Bag are still combined" docs/drive/Shelter docs/repo/status || true
git diff --check
```

If Steam-local copies are created, also check that the files exist under:

```text
steam/assets/prototypes/vertical_slice/semantic/
```

---

## 11. Hard boundaries

Codex must not:

- change gameplay contracts;
- add new Vertical Slice gameplay objects;
- use rejected assets;
- treat the composite resource as final production art;
- claim the full Semantic Asset Pack is complete while missing assets remain;
- add Browser Extension UX;
- add monetization, ads, charity reporting, real shelter data, gacha, paid reroll, combat or crop farming.

If implementing the import requires changing gameplay scope or asset taxonomy, Codex must stop and ask Game Designer / Art Director / Producer.

---

## 12. Acceptance criteria

This task is complete when:

1. Source composite PNG exists at the expected path.
2. Six cropped PNG outputs exist at the target paths or Codex documents why a specific crop could not be created.
3. Manifest reflects the new import state.
4. README reflects that 6 placeholders now exist but the pack is incomplete.
5. Stale import-not-yet-done claims are removed or updated.
6. Relevant cards are updated or missing-card status is documented.
7. `CODEX_STATUS.md` is updated.
8. Checks are run and documented.
