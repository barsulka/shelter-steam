# STEAM_DESKTOP — Codex Implementation Brief — Vertical Slice v1

Дата: 2026-06-29  
Роль документа: Codex Implementation Brief / Dev Task Contract  
Статус: draft v1, synced with cross-role RFC 2026-06-29  
Продукт: Steam/Desktop idle always-on-top strip  
Обязателен для: Codex / Development Agent  
Основано на:

- `STEAM_DESKTOP__Vertical_Slice_Contract_v1.md`
- `STEAM_DESKTOP__Object_Contract_v1.md`
- `STEAM_DESKTOP__Task_Flow_Contract_v1.md`
- `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Semantic_Asset_Pack_v1/README.md`
- asset cards in `STEAM_DESKTOP__Semantic_Asset_Pack_v1/cards/`

## 0. Purpose

Этот brief переводит Steam/Desktop Vertical Slice design contracts в прямую задачу для Codex.

Codex должен реализовать первый игровой loop поверх существующей Godot companion strip / tech demo foundation.

Цель реализации:

> Игрок открывает нижнюю strip-сцену, отправляет таксу на велосипеде за овсом и тыквой, видит возвращение груза, физическую выгрузку в Storage, перенос ингредиентов на Kitchen, приготовление Food Mix, фасовку Food Bag на Packing Table, погрузку в Delivery Van Endpoint, отправку первой поставки, открытку и награду Comfortable Slippers.

## 1. Non-Negotiable Rules

Codex MUST preserve these rules:

1. Player chooses intention; dogs do physical work.
2. Resources MUST NOT teleport into Storage.
3. Storage inventory updates only after visible unload/place action.
4. Kitchen MUST NOT create Food Bag directly.
5. Packing Table MUST exist as Utility Prop and MUST create Food Bag.
6. Delivery MUST NOT complete until Food Bag is visibly loaded.
7. Dog Card MUST separate innate trait and equipment.
8. UI MUST remain compact and non-dominant.
9. No guilt language, monetization, ads, Browser Extension UI, crop farming, combat, gacha or FOMO.
10. Utility Props MUST NOT be treated as houses/buildings.

## 2. Scope

### Must implement

World anchors:

- Road Sign / Road Edge
- Storage
- Kitchen
- Packing Table
- Delivery Van Endpoint

Characters:

- Dachshund
- Labrador

Transport:

- Basket Bicycle

Resources:

- Oat Crate
- Pumpkin Crate
- Protein Packet
- Packaging Bag
- Food Mix
- Food Bag

Order:

- First Warm Delivery

Tasks:

- TripTask
- UnloadTask
- CarryTask
- CookTask
- PackTask
- LoadVanTask
- DeliveryTask
- IdleTask
- reward/equip flow for Comfortable Slippers

UI:

- Order Card
- Route Card
- Dog Card
- Postcard Card
- Hide / Show UI
- optional dev/debug state overlay

### Must not implement

- additional routes;
- third dog;
- rooms;
- decor;
- economy balancing;
- research tree;
- Steamworks;
- Browser sync;
- donations;
- ads;
- production art dependency;
- real shelter data;
- crop farming in Steam.

## 3. Existing Foundation To Preserve

Codex should reuse or preserve the existing Steam companion tech demo foundation where possible:

- Godot project under `steam/`;
- companion strip mode;
- bottom-of-screen placement;
- always-on-top behavior;
- transparency / click-through empty space where already supported;
- Hide / Show button behavior;
- zoom / pan controls where already supported;
- performance HUD / performance-awareness practices;
- existing smoke checks.

Do not destroy the current tech demo unless a separate dev decision says so.

Recommended approach: create a new prototype scene/script layer for the Vertical Slice, or clearly isolate vertical-slice logic inside current demo files.

## 4. Semantic Assets

Codex MUST use only approved semantic placeholders from:

`docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Semantic_Asset_Pack_v1/approved/`

Current approved placeholders for Codex prototype use:

- `approved/utility_props/road_sign.png` — Road Sign / Notice Board, Utility Prop.
- `approved/utility_props/basket_bicycle.png` — Basket Bicycle, Utility Prop / Transport.
- `approved/buildings/storage.png` — Storage, Building.
- `approved/buildings/kitchen.png` — Kitchen, Building; temporary and replaceable if readability suffers.
- `approved/utility_props/delivery_van_endpoint.png` — Delivery Van Endpoint, Utility Prop / Endpoint.
- `approved/resources/food_mix_and_food_bag_composite.png` — temporary combined Food Mix / Food Bag resource bridge.

Known missing assets for this Vertical Slice:

- Packing Table;
- separate Oat Crate;
- separate Pumpkin Crate;
- Protein Packet;
- Packaging Bag;
- separate Food Mix;
- separate Food Bag;
- Comfortable Slippers icon;
- First Postcard frame;
- Dachshund / Labrador action sprites.

Important correction:

- `approved/utility_props/packing_table.png` is **not** currently available. Packing Table remains required by gameplay scope, but Codex must use a labeled Utility Prop placeholder until Art Direction provides an approved semantic asset.
- Because Food Mix and Food Bag currently share one composite image, Codex should use separate labeled semantic tokens whenever the chain needs to show Food Mix -> Food Bag transformation.

Codex may create debug-only / semantic placeholders for missing Vertical Slice assets if all conditions are met:

1. the placeholder maps to an object/resource/action already present in the Vertical Slice contracts;
2. it has explicit taxonomy in code/data/docs;
3. it does not add a new mechanic, object responsibility or visual direction;
4. it does not hide a required physical step;
5. it is documented in status/dev notes.

Codex MUST NOT use assets from `rejected/`, random screenshots from chat, Browser Extension assets or assets marked only as visual direction unless they are separately approved for Codex prototype use.

Codex SHOULD copy/import approved semantic assets into a Steam-local prototype asset folder if needed, for example:

`steam/assets/prototypes/vertical_slice/semantic/`

If copying assets into `steam/` is required, preserve filenames and document source path, taxonomy and source -> Steam-local mapping in a README or manifest. Steam-local copies are implementation mirrors, not new art approvals.

## 4.1 Cross-role implementation boundaries

This brief is synced with:

`docs/drive/Shelter/06_SESSIONS_AND_HANDOFFS/cross_role_sessions/2026-06-29__cross_role_rfc__codex_task_boundaries_steam_vertical_slice.md`

Accepted Producer rule:

> Codex implements contracts and may use technical judgement for prototype implementation, debug tooling and neutral placeholders. Codex must not silently change gameplay contracts, visible physical steps, object taxonomy, visual direction, player-facing UI meaning, product scope or ethical boundaries.

Codex may independently:

- choose internal Godot structure, scene/script split and data representation;
- implement deterministic prototype scheduler / state machine;
- add dev-only debug overlay, state log, semantic labels and smoke commands;
- compress timings for debug / smoke / prototype review if visible steps remain readable;
- use approved semantic placeholders and neutral labeled placeholders for missing assets;
- create Steam-local implementation mirrors of approved semantic assets with a source mapping manifest;
- fix bugs where implementation diverges from written contracts.

Codex must ask Game Designer before:

- adding/removing route, dog, transport, object, resource, order, reward, task type or player action;
- removing any visible step from the locked chain;
- changing resource flow, task ownership, Dog Card meaning, player confirmation or UI flow meaning;
- turning physical resources into UI-only counters;
- changing acceptance criteria or playtest meaning.

Codex must ask Art Director before:

- choosing final visual style, palette, UI look, dog look, icon language or production asset style;
- changing asset taxonomy;
- using unclear/unapproved assets;
- making a Utility Prop read as a Building;
- proceeding when placeholder/readability problems hide gameplay meaning.

Codex must ask Producer before:

- changing Vertical Slice scope;
- adding product features, monetization, charity claims, Browser Extension dependency or cross-product behavior;
- accepting a shortcut that changes the intended player experience.

## 5. Data Model

Codex SHOULD implement a small data-driven model with keys matching the design contracts.

Suggested keys:

```text
route.oat_farm_intro
transport.basket_bicycle
dog.dachshund_intro
dog.labrador_intro
trait.fast_paws
trait.careful_helper
equipment.comfortable_slippers
resource.oat_crate
resource.pumpkin_crate
resource.protein_packet
resource.packaging_bag
resource.food_mix
resource.food_bag
order.first_warm_delivery
object.road_sign
object.storage
object.kitchen
object.packing_table
object.delivery_van_endpoint
```

Prototype data may be JSON, Godot Resource, dictionary constants or simple script data. Avoid premature architecture.

## 6. Required Task Chain

Codex MUST implement this chain:

```text
player_confirmed_trip
-> TripTask created
-> Dachshund walks to Basket Bicycle
-> Basket Bicycle leaves strip
-> calm trip state shown
-> Basket Bicycle returns
-> payload visible: Oat Crate + Pumpkin Crate
-> UnloadTask(Oat Crate)
-> UnloadTask(Pumpkin Crate)
-> Storage receives resources only after visible placement
-> CarryTask(Oat Crate, Storage -> Kitchen)
-> CarryTask(Pumpkin Crate, Storage -> Kitchen)
-> CarryTask(Protein Packet, Storage -> Kitchen)
-> CookTask creates Food Mix
-> CarryTask(Food Mix, Kitchen -> Packing Table)
-> CarryTask(Packaging Bag, Storage -> Packing Table)
-> PackTask creates Food Bag
-> LoadVanTask(Food Bag, Packing Table -> Delivery Van Endpoint)
-> player_confirmed_delivery
-> DeliveryTask completes
-> Postcard appears
-> Comfortable Slippers reward appears
-> player equips Comfortable Slippers to Dachshund
-> Dog Card shows innate trait and equipment separately
```

## 7. Dog Assignment Rules

- Dachshund MUST be first route driver.
- Labrador SHOULD be preferred for unload/carry tasks.
- Dachshund MAY help with carry/production after returning.
- Dogs MUST NOT drop carried items because a new task appeared.
- IdleTask MUST yield to required Vertical Slice tasks.

## 8. UI Requirements

UI should be minimal and contextual.

Required UI:

### Order Card

Shows:

- First Warm Delivery;
- friendly description;
- missing resources;
- next suggested action.

Must not use guilt language.

### Route Card

Shows:

- Oat Farm route;
- Dachshund driver;
- Basket Bicycle transport;
- expected resources: oat, pumpkin;
- Send button.

### Dog Card

Shows:

- Dachshund identity;
- innate trait: Быстрые лапки;
- equipment: empty, later Удобные тапочки.

### Postcard Card

Shows warm completion feedback and Comfortable Slippers reward.

### Hide / Show UI

Must hide interface clutter while world state continues.

## 9. Visual / Animation Minimum

Production animation is not required.

Codex MAY use simple movement, tweening, sprite swaps, labels in debug overlay or placeholder state markers.

However, the player must visibly understand:

- dog goes to transport;
- transport leaves;
- transport returns;
- cargo exists;
- dog unloads cargo;
- dog carries cargo;
- Kitchen works;
- Food Mix appears;
- Packing Table works;
- Food Bag appears;
- Food Bag is loaded;
- delivery resolves;
- postcard/reward appears.

## 10. Implementation Order

Recommended order:

1. Create / isolate Vertical Slice prototype scene.
2. Place semantic world anchors in strip order.
3. Add Dachshund, Labrador and Basket Bicycle placeholders.
4. Add first order state and simple UI cards.
5. Implement TripTask and return payload.
6. Implement UnloadTask into Storage.
7. Implement CarryTasks to Kitchen.
8. Implement CookTask and Food Mix output.
9. Implement CarryTasks to Packing Table.
10. Implement PackTask and Food Bag output.
11. Implement LoadVanTask and delivery confirmation.
12. Implement Postcard and Comfortable Slippers reward.
13. Implement Dog Card D-010 trait/equipment separation.
14. Ensure Hide / Show UI still works.
15. Add dev debug overlay/log for task chain if useful.
16. Run checks and update docs/status.

## 11. Acceptance Criteria

Implementation passes only if:

1. World anchors are visible and mapped to approved semantic assets.
2. Player can start the Oat Farm route from Road Sign.
3. Dachshund visibly leaves with Basket Bicycle.
4. Basket Bicycle visibly returns.
5. Oat/Pumpkin cargo is visible before entering Storage.
6. Dogs physically unload cargo into Storage.
7. Storage state updates after visible unload.
8. Dogs carry resources to Kitchen.
9. Kitchen produces Food Mix.
10. Food Mix moves to Packing Table.
11. Packing Table produces Food Bag.
12. Food Bag moves to Delivery Van Endpoint.
13. Delivery waits for player confirmation.
14. Postcard appears after delivery completion.
15. Comfortable Slippers reward can be equipped.
16. Dog Card separates innate trait and equipment.
17. UI can be hidden and shown.
18. World state continues while UI is hidden.
19. Existing smoke check still passes or replacement check is documented.
20. No forbidden scope is added.

## 12. Expected Files / Areas

Codex should inspect existing files before editing.

Likely areas:

- `steam/scenes/tech_demos/`
- `steam/scripts/tech_demos/`
- `steam/resources/tech_demos/`
- possible new `steam/scenes/prototypes/vertical_slice/`
- possible new `steam/scripts/prototypes/vertical_slice/`
- possible new `steam/resources/prototypes/vertical_slice/`
- possible new `steam/assets/prototypes/vertical_slice/semantic/`
- `docs/repo/dev/`
- `docs/repo/status/CODEX_STATUS.md`

Do not invent large architecture if a small prototype implementation is enough.

## 13. Checks

At minimum, after implementation run available project checks:

```sh
cd steam
tools/check-godot.sh
tools/dev-companion-field.sh smoke
```

If a new launcher is created, document and run it, for example:

```sh
tools/dev-vertical-slice.sh smoke
```

If a check cannot be run, document why in final report and `CODEX_STATUS.md`.

## 14. Documentation Updates Required

After implementation, Codex MUST update or create:

- `docs/repo/status/CODEX_STATUS.md`
- a dev note for the Vertical Slice prototype, for example `docs/repo/dev/steam-vertical-slice-prototype.md`
- relevant `steam/README.md` launch instructions if a new command is added

Status entry must include:

- date;
- branch if known;
- summary;
- changed files;
- checks run;
- assumptions;
- blockers;
- next recommended step.

## 15. Stop Conditions

Codex MUST stop and ask Game Designer / Producer if:

- it needs to add a new gameplay object not in the contracts;
- it needs to remove a required visible step;
- asset taxonomy is unclear;
- implementation would make Utility Prop into a Building;
- resource flow requires teleporting resources;
- current Godot/window tech cannot support the required UX without a design compromise.

## 16. Next Recommended Task After Implementation

After Codex completes the first playable Vertical Slice loop, the next design task should be:

`STEAM_DESKTOP__Vertical_Slice_Playtest_Checklist_v1`

Purpose:

Evaluate whether the implemented slice actually feels like Shelter:

- are dogs the focus;
- is physical work readable;
- does the strip feel alive;
- is UI quiet enough;
- does the player understand the first loop;
- does anything feel like cold factory, guilt pressure or spreadsheet gameplay.
