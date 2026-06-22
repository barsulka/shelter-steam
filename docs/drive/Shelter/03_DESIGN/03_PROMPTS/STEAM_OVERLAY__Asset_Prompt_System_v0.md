# STEAM_OVERLAY — Asset Prompt System v0

Дата: 2026-06-25  
Роль документа: Prompt system / reusable art generation rules  
Связано с: D-011 Steam Overlay Main Strip v1 Rules

## 1. Purpose

Этот документ нужен, чтобы не объяснять каждый раз заново, что такое Shelter, какой стиль нужен, почему нельзя делать арт-нуво, почему главный overlay не должен превращаться в интерьер и почему собаки должны читаться раньше декора.

Задача системы: пользователь может сказать коротко:

> Сделай мельницу для Steam overlay.

А арт-директор / AI-оператор разворачивает это в полный asset brief по правилам ниже.

## 2. Global style lock

Добавлять в каждый prompt для Steam overlay assets:

> Shelter Steam overlay main strip. A tiny cozy dog cooperative living along the bottom edge of the screen. Warm 2D illustrated modular diorama style, but simplified for game readability. Functional low-profile silhouettes, clear readable dog actions, soft warm wood, muted greens, cream highlights, paper icon plaques, peaceful dog food production. Big readable dogs and carried objects. Huge empty / transparent / black space above. The asset must not interfere with the user's desktop.

## 3. Global negative lock

Добавлять в каждый prompt как avoid / negative constraints:

> No large interior cutaway for main overlay, no shelves full of tiny details, no art nouveau ornament overload, no fantasy village towers, no gothic mood, no horror, no combat, no monsters, no PvP, no bosses, no slaughterhouse, no meat processing visuals, no gore, no knives as production symbols, no aggressive UI, no guilt pressure, no sad starving dogs, no dense decorative village, no tall buildings dominating the strip, no text-heavy signs.

## 3.1 Asset taxonomy lock

Перед любым prompt нужно классифицировать ассет:

- **Building** — редкий крупный якорь полоски: dog house, kitchen, storage, delivery van endpoint.  
- **Utility Prop** — standalone equipment / support object / pause: pump, tank, barrel, valve, pipe, wheel, wind rotor, cart, compost bin, signpost, lantern. Utility Props must not become houses. Avoid words that imply buildings: station, workshop, shed, hut, cottage, house, room, shop, module-house.  
- **Dog Action Sprite** — отдельная читаемая собака с крупным предметом: carries bag, pulls cart, waters plants, paints board, labels package.

Главное правило: в main overlay здания — редкие якоря. Всё остальное — functional props и dog actions. Если каждая функция превращается в домик, результат rejected.

## 4. Overlay module prompt skeleton

```text  
Create one [ASSET TYPE] for Shelter Steam overlay main strip.

Function: [FUNCTION].  
Silhouette: [ONE-SENTENCE SHAPE DESCRIPTION].  
Scale: low-profile bottom-hugging module, designed for 96–144 px readability.  
Placement: sits on the same lower ground baseline as other overlay modules, with empty/transparent/black space above.  
Visual sign: one 

## 4.1 Utility prop prompt skeleton

```text  
Create one standalone equipment prop [UTILITY PROP] for Shelter Steam overlay main strip.

Asset class: Utility Prop, not a Building, not a house, not a shed, not a workshop, not a station building.  
Function: [FUNCTION].  
Silhouette: [ONE CLEAR PROP SHAPE], readable at 96–144 px.  
Scale: smaller or narrower than building modules, used as a pause or support object in the bottom strip.  
Placement: sits on the same lower ground baseline as other overlay elements, with huge empty/transparent/black space above.  
Visual sign: one small [ICON] icon plaque only if needed, no readable text.  
Dog action: [DOG TYPE] [ACTION] near the prop with one large readable [OBJECT].  
Materials: warm wood, muted green accents, cream highlights, simple readable forms.  
Mood: cozy, calm, functional, friendly, dog-centered.

Style lock: Shelter Steam overlay main strip, tiny cozy dog cooperative along the bottom edge, simplified 2D illustrated modular diorama, clear functional prop silhouette, big readable dog action, huge empty top space.

Hard rule: this utility prop must not become a house. No roof, no door, no windows, no room, no cottage, no shed, no workshop building, no station building, no decorative village module. It must look like standalone equipment on the ground line.

Avoid: large interior cutaway, dense shelves, tiny unreadable details, aggressive UI, combat, horror, meat processing, guilt imagery.  
```

small icon plaque showing [ICON], no readable text required.  
Dog action: [DOG TYPE] [ACTION] near the module with a large readable [OBJECT].  
Materials: warm wood, muted green accents, cream highlights, soft fabric/paper details.  
Mood: cozy, calm, functional, friendly, dog-centered.

Style lock: Shelter Steam overlay main strip, tiny cozy dog cooperative along the bottom edge, simplified 2D illustrated modular diorama, clear silhouette, big readable dog action, huge empty top space.

Avoid: large interior cutaway, art nouveau, fantasy tower, dense shelves, tiny unreadable details, aggressive UI, combat, horror, meat processing, guilt imagery.  
```

## 5. Overlay action prompt skeleton

```text  
Create a small side-view action sprite concept for Shelter Steam overlay main strip.

Dog: [BREED / TYPE], readable silhouette at 96–144 px.  
Action: [ACTION].  
Object: [OBJECT] must be large and readable.  
Pose: simple side-view, clear direction of movement.  
Mood: happy / focused / calm, never stressed.  
Scale: dog is visually important, not a tiny decorative dot.  
Style: warm simplified Cozy Modular Diorama, clean silhouette, minimal detail, suitable for a bottom overlay strip.

Avoid: tiny object, hidden paws, cluttered background, sad expression, worker-exploitation vibe, combat pose.  
```

## 6. Inspect view prompt skeleton

Использовать только для открытых окон зданий/комнат, не для main overlay.

```text  
Create an inspect/detail view for [BUILDING / ROOM] in Shelter.

This is an opened interior view, not the main overlay strip.  
Show cozy cutaway interior with [KEY PROPS].  
Dog personality / function: [DOG / ROLE / PERSONALITY].  
Mood: warm, calm, lived-in, dog-centered.  
Use more detail than main overlay, but keep peaceful production and no visual cruelty.

Allowed here: shelves, bags, jars, room decor, wallpapers, personal objects.  
Still avoid: combat, horror, meat processing, guilt, exploitation.  
```

## 7. Short user request → full brief rule

When user says:

> Сделай [asset]

Art Director should expand it into:

1. Is this Building, Utility Prop, Dog Action Sprite, inspect view, windowed scenic mode, or UI card?  
2. What function does it serve?  
3. What is the one readable silhouette?  
4. What is the one icon / sign?  
5. What dog action happens near it?  
6. What object must read at 96–144 px?  
7. What must be avoided?

## 8. Example: windmill / мельница

Short request:

> Сделай мельницу для Steam overlay.

Expanded brief:

Function: gentle grain/oats processing support module.  
Silhouette: thin windmill mast with small wooden base and readable blades; it should be a vertical accent, not a tall fantasy tower.  
Icon: small grain/oats symbol.  
Dog action: dachshund pulls a tiny cart with one grain sack.  
Scale: lower than kitchen chimney, narrow vertical pause between modules.  
Avoid: art nouveau windmill house, fantasy tower, giant mill dominating the strip.

Prompt:

```text  
Create one windmill module for Shelter Steam overlay main strip.

Function: gentle grain/oats processing support for a cozy dog food cooperative.  
Silhouette: a thin low-profile wooden windmill mast with simple readable blades and a small base, used as a vertical pause in the bottom strip, not a big building.  
Scale: bottom-hugging overlay asset, readable at 96–144 px, much narrower than a house module.  
Placement: sits on the same lower ground baseline as other modules, with huge empty/transparent/black space above.  
Visual sign: one tiny grain/oats icon plaque, no readable text.  
Dog action: a dachshund pulls a small cart with one large readable grain sack near the windmill.  
Materials: warm wood, muted green accent cloth, cream highlights, simple paper icon plaque.  
Mood: cozy, calm, functional, friendly, dog-centered.

Style lock: Shelter Steam overlay main strip, tiny cozy dog cooperative along the bottom edge, simplified 2D illustrated modular diorama, clear silhouette, big readable dog action, huge empty top space.

Avoid: large interior cutaway, art nouveau windmill house, fantasy tower, dense detail, tiny unreadable props, aggressive UI, combat, horror, meat processing, guilt imagery.  
```

## 9. Example: greenhouse / теплица

```text  
Create one greenhouse module for Shelter Steam overlay main strip.

Function: grows peaceful vegetables and herbs for dog food.  
Silhouette: low rectangular glass greenhouse with a simple slanted transparent roof, readable at 96–144 px.  
Scale: bottom-hugging module, not tall, not a palace.  
Placement: on the lower ground baseline with large empty top space.  
Visual sign: one small leaf/sprout icon plaque, no readable text.  
Dog action: a friendly labrador waters a simple plant bed with a large readable watering can.  
Materials: warm wood frame, muted green plants, pale glass, cream highlights.  
Mood: cozy, calm, functional, gentle farming.

Style lock: Shelter Steam overlay main strip, tiny cozy dog cooperative along the bottom edge, simplified 2D illustrated modular diorama, clear silhouette, big readable dog action, huge empty top space.

Avoid: large interior cutaway, dense tiny plants, art nouveau greenhouse, fantasy building, aggressive UI, combat, horror, meat processing.  
```

## 10. Example: packing station / фасовка

```text  
Create one packing station module for Shelter Steam overlay main strip.

Function: packs finished dog food into simple bags.  
Silhouette: low wooden shed with a single large bag icon plaque and one open work counter silhouette, no detailed interior.  
Scale: bottom-hugging module, readable at 96–144 px.  
Placement: on the same lower ground baseline as other overlay modules, with huge empty/transparent/black space above.  
Dog action: a corgi carries one large readable beige food bag in front of the station.  
Materials: warm wood, cream paper labels, muted green accents, simple fabric sacks.  
Mood: cozy, calm, clean, peaceful production.

Style lock: Shelter Steam overlay main strip, tiny cozy dog cooperative along the bottom edge, simplified 2D illustrated modular diorama, clear silhouette, big readable dog action, huge empty top space.

Avoid: detailed shelves, many tiny bags, interior cutaway, art nouveau, factory harshness, aggressive UI, combat, horror, meat processing.  
```

## 11. Example: dog house / домик собаки

```text  
Create one dog house module for Shelter Steam overlay main strip.

Function: cozy residence and rest point for one dog.  
Silhouette: small low wooden dog house with a rounded arch entrance and a simple paw mark, clearly readable at 96–144 px.  
Scale: lower than production buildings, bottom-hugging, compact.  
Placement: on the lower baseline with empty/transparent/black space above.  
Dog action: a corgi rests beside the entrance with a small bowl nearby.  
Materials: warm wood, muted red/brown roof, cream highlights, tiny soft rug.  
Mood: safe, calm, personal, dog-centered.

Style lock: Shelter Steam overlay main strip, tiny cozy dog cooperative along the bottom edge, simplified 2D illustrated modular diorama, clear silhouette, big readable dog action, huge empty top space.

Avoid: tall fantasy cottage, art nouveau details, dense decor, interior cutaway, sad shelter cage vib

## 15. Addendum — Asset Pack 1 v1 verdict and prompt correction

Asset Pack 1 v1 status: useful exploration, not approved production pack.

Принято:  
- общий cozy tone;  
- палитра и материалы;  
- dog action direction;  
- icon plaque language;  
- интеграция с approved main strip.

Не принято как production:  
- mill v1: слишком дом-мельница, нужно utility prop / vertical pause;  
- water station v1: слишком дом с баком, нужно tank + pump + dog;  
- decor workshop v1: слишком inspect-view домик, для main overlay нужен open workbench + awning + dog action.

New hard rule:

> Before generation, classify asset as Building / Utility Prop / Dog Action Sprite. Utility Props must not become houses.

Update to rejection checklist:  
- reject if a Utility Prop becomes a cottage, shed, room, or decorative building;  
- reject if a Dog Action Sprite becomes background decor;  
- reject if Buildings become too frequent and the strip turns into a village.  
e, guilt imagery.  
```

## 12. Example: delivery van / фургон

```text  
Create one delivery van endpoint module for Shelter Steam overlay main strip.

Function: sends packed dog food to partner shelters.  
Silhouette: small friendly cream delivery van with a simple paw icon, readable at 96–144 px.  
Scale: endpoint object on the lower baseline, slightly larger than a dog but not visually dominating the strip.  
Placement: right edge endpoint, with huge empty/transparent/black space above.  
Dog action: a husky and a mixed-breed dog load one large readable food sack into the back.  
Materials: cream vehicle body, warm wood crates, muted green accent, soft highlights.  
Mood: calm, helpful, transparent charity delivery, no pressure.

Style lock: Shelter Steam overlay main strip, tiny cozy dog cooperative along the bottom edge, simplified 2D illustrated modular diorama, clear silhouette, big readable dog action, huge empty top space.

Avoid: aggressive truck, corporate ad banner, guilt messaging, sad dogs, combat, horror, meat processing.  
```

## 13. Checklist before generating

- Is this asset for main overlay or inspect view?  
- Is the top empty / transparent / black?  
- Is the building low-profile?  
- Does it have one clear function?  
- Can it be identified by silhouette?  
- Is there a dog action nearby?  
- Is the carried object large enough?  
- Are we avoiding interior detail in main overlay?  
- Are we avoiding art nouveau / fantasy village noise?  
- Would this still read at 144 px?

## 14. Checklist after generation

Reject or revise if:

- it looks like a pretty fantasy house instead of a functional module;  
- the building is too tall;  
- dog is too small;  
- action is unclear;  
- object in paws/cart is unreadable;  
- the result requires text to understand;  
- there is too much interior detail;  
- style becomes darker, more dramatic or more realistic than the approved reference;  
- it would visually interfere with desktop work.

## 16. System board template

Для структурированных presentation boards использовать отдельный документ:

`03_DESIGN/03_PROMPTS/STEAM_OVERLAY__System_Board_Template_v0`

Этот template появился после анализа rejected Asset Pack 1 v1 board.

Правило:

- старый board не approved как ассеты;  
- старый board approved только как структура подачи: hea

## 17. Anti-house correction after Asset Pack 2 regression

Asset Pack 2 board regression showed that the artist/model still interprets words like “mill”, “water station” and “decor workshop” as buildings.

Correction:

- Do not prompt Utility Props as “station”, “workshop”, “shed”, “hut”, “house”, “shop”, “room”, or “building”.  
- Use equipment language instead: “standalone pump and barrel”, “tank on wooden legs”, “wind rotor on a mast”, “open workbench frame”, “tool rack”, “cart”, “pipe”, “valve”, “notice board”.  
- For Utility Props, explicitly forbid roof, door, windows, enclosed walls, living facade, interior, shopfront, room, cottage, shed.  
- If a Utility Prop has a roof, door, windows, enclosed walls, or looks inhabitable, it is rejected.  
- Board layouts must not put Utility Props under a visual category that makes them look like Buildings.

Rejected examples archived:  
- `STEAM_OVERLAY__asset_pack_2_regression__utility_props_became_houses_v1.png`  
- `STEAM_OVERLAY__asset_pack_2_regression__utility_props_became_houses_v2.png`

Use these only as negative examples of taxonomy regression.  
der, asset cards, reference strip, principles, palette, materials, key rules, scale check;  
- текущий board-content должен брать ассеты из Approved Library v1 и последующих approved packs;  
- каждый asset card обязан показывать asset class: Building / Utility Prop / Dog Action Sprite;  
- Utility Props must not become houses.
