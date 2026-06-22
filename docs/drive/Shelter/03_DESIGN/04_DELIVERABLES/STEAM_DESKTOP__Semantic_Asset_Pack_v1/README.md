# STEAM_DESKTOP — Semantic Asset Pack v1

Дата создания: 2026-06-28  
Роль: Semantic Asset Registry / Approved Prototype Asset Library  
Статус: scaffold v1  
Продукт: Steam/Desktop idle always-on-top strip  
Связанные документы:

- `02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Vertical_Slice_Contract_v1.md`
- `02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Object_Contract_v1.md`
- `02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Task_Flow_Contract_v1.md`

## Purpose

Этот каталог хранит семантические ассеты для первого Steam/Desktop Vertical Slice.

Semantic Asset Pack — не production art pack.

Его задача:

- дать Codex однозначные визуальные placeholders;
- отделить разработку gameplay loop от ожидания финального арта;
- зафиксировать asset taxonomy;
- хранить решение, почему ассет approved или rejected;
- не позволять Codex использовать случайные картинки из чата.

## Core Rule

Codex MUST use only assets that are:

1. listed in `cards/`;
2. marked as `APPROVED_FOR_CODEX` or `APPROVED_SEMANTIC_PLACEHOLDER`;
3. placed under `approved/` or explicitly referenced as a temporary generated semantic placeholder.

Codex MUST NOT use:

- random screenshots from chat;
- rejected art;
- production art not approved for prototype use;
- Browser Extension assets;
- assets whose taxonomy is unclear.

## Directory Structure

```text
STEAM_DESKTOP__Semantic_Asset_Pack_v1/
  README.md
  TEMPLATE__Asset_Card.md
  approved/
    buildings/
    utility_props/
    dog_action_sprites/
    resources/
    ui/
  rejected/
  cards/
```

## Asset Taxonomy

Every asset MUST be classified before use.

### Building

Rare large anchor in the strip.

Vertical Slice Buildings:

- Storage
- Kitchen

### Utility Prop

Functional object. Not a house. Not a room. Not a decorative cottage.

Vertical Slice Utility Props:

- Road Sign / Notice Board
- Packing Table
- Delivery Van Endpoint
- Basket Bicycle

### Dog Action Sprite

Readable dog action. Dog and action must read before decoration.

Vertical Slice Dog Action Sprites:

- Dachshund idle / walk / bicycle
- Labrador idle / unload / carry
- dog carrying crate
- dog carrying Food Bag
- dog packing / labeling

### Resource

Physical item participating in the first order.

Vertical Slice Resources:

- Oat Crate
- Pumpkin Crate
- Protein Packet
- Packaging Bag
- Food Mix
- Food Bag

### UI

Small interface or reward element.

Vertical Slice UI:

- Comfortable Slippers icon
- First Postcard frame

## Approval Statuses

Use only these statuses:

- `NEEDED` — asset required but no approved visual exists yet.
- `APPROVED_SEMANTIC_PLACEHOLDER` — approved for Codex prototype use, not production art.
- `APPROVED_AS_DIRECTION` — approved visual direction, but may need simplification or redraw before Codex use.
- `APPROVED_FOR_CODEX` — asset can be used by Codex now.
- `REJECTED` — do not use.
- `ARCHIVED_REFERENCE_ONLY` — may inform future work, but not usable as asset.

## Review Criteria

An asset can be approved for Codex only if:

1. It has a clear taxonomy.
2. It maps to a Vertical Slice object or action.
3. Its purpose is unambiguous.
4. It does not expand scope.
5. It does not turn Utility Props into houses.
6. It supports the lower living strip composition.
7. It is readable enough for prototype use.
8. It has a card in `cards/`.

## Current State

This pack contains registry cards, directory structure, one composite source PNG, and 6 composite-derived temporary semantic placeholder PNG files under `approved/`.

Imported placeholders now available for Codex prototype use:

1. `approved/utility_props/road_sign.png`
2. `approved/utility_props/basket_bicycle.png`
3. `approved/buildings/storage.png`
4. `approved/buildings/kitchen.png`
5. `approved/utility_props/delivery_van_endpoint.png`
6. `approved/resources/food_mix_and_food_bag_composite.png`

The composite source produced 6 usable objects, not 8 separate assets. Food Mix and Food Bag are still combined in one temporary resource composite.

Existing Yog-Sothoth's Yard screenshots are useful as room/decor references only. They are not semantic assets for Codex and must not be placed into `approved/`.

## Missing Assets

The semantic pack is still incomplete. Missing or incomplete assets:

1. Packing Table
2. separate Oat Crate
3. separate Pumpkin Crate
4. Protein Packet
5. Packaging Bag
6. separate Food Mix
7. separate Food Bag
8. Comfortable Slippers icon
9. First Postcard frame
10. Dachshund basic action set
11. Labrador basic action set
12. final transparent-background cleanup/polish for cropped images

## Next Step

Generate or create the missing Level 0 semantic placeholders, then review each item and update the relevant card status.
