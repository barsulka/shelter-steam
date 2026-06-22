# STEAM_OVERLAY — Asset Brief Template v0

Дата: 2026-06-25  
Роль документа: Fill-in template for any Steam overlay asset

Use this template when asking for a new Shelter Steam overlay asset.

## Short request

Asset name:

`[e.g. mill / greenhouse / dog house / kitchen / storage / van / water pump]`

Asset mode:

- [ ] Main overlay module  
- [ ] Main overlay dog/action sprite  
- [ ] Inspect/detail view  
- [ ] Windowed scenic mode  
- [ ] UI card

## Asset class

Choose exactly one:

- [ ] Building / здание — rare anchor module: dog house, kitchen, storage, van endpoint.  
- [ ] Utility Prop / функциональный объект — support object or pause: mill, water station, pump, tank, cart, signpost, lantern. Must not become a house.  
- [ ] Dog Action Sprite / действие собаки — dog + readable object/action: carries bag, pulls cart, waters plants, paints board, labels package.

Hard rule:

`Utility Props must not become houses. Buildings are rare anchors. Dog actions are a separate meaning layer, not background decor.`

## Functional brief

Function:

`[What does this object do in the dog cooperative?]`

Readable silhouette:

`[One sentence: what shape should be recognizable at 96–144 px?]`

Icon / sign:

`[One simple symbol. No readable text required.]`

Dog action:

`[Which dog type does what near this asset?]`

Readable object:

`[What must be large and clear: bag, watering can, cart, box, bowl, tool, roll, crate?]`

Placement:

`[Where in the strip: left, middle, between modules, endpoint, pause object?]`

Scale:

`[Low / mediuAsset class: [BUILDING / UTILITY PROP / DOG ACTION SPRITE].  
Class rule: [If Utility Prop, it must not become a house. If Building, it must be a rare low-profile anchor. If Dog Action Sprite, the dog and object must be the main readable unit.]

m / endpoint. Must it be lower than greenhouse? narrower than kitchen?]`

## Style constraints

Keep:

- bottom-hugging overlay strip;  
- huge empty / transparent / black top;  
- functional silhouette;  
- big readable dog action;  
- warm wood;  
- muted green accents;  
- cream highlights;  
- peaceful dog food cooperative tone.

Avoid:

- interior cutaway in main overlay;  
- art nouveau / fantasy village details;  
- tall decorative buildings;  
- dense shelves;  
- tiny unreadable props;  
- aggressive UI;  
- combat / horror / meat processing / guilt imagery.

## Generated prompt

```text  
Create one [ASSET NAME] for Shelter Steam overlay main strip.

Function: [FUNCTION].  
Silhouette: [READABLE SILHOUETTE].  
Scale: [SCALE RULE], bottom-hugging, readable at 96–144 px.  
Placement: [PLACEMENT], on the same l  
Class-specific hard rule:  
- If Utility Prop: no full roof-and-door building, no cottage, no shed-like house, no decorative village module.  
- If Building: must remain low-profile and functional, not a fantasy house.  
- If Dog Action Sprite: dog and object must read before any background.  
ower ground 

Asset class correct:

`[yes/no/partial]`

If Utility Prop, did it become a house?

`[yes/no] — if yes, reject or regenerate`  
baseline as other overlay modules, with huge empty/transparent/black space above.  
Visual sign: one small [ICON] icon plaque, no readable text required.  
Dog action: [DOG TYPE] [ACTION] near the asset with a large readable [OBJECT].  
Materials: warm wood, muted green accents, cream highlights, soft fabric/paper details.  
Mood: cozy, calm, functional, friendly, dog-centered.

Style lock: Shelter Steam overlay main strip, tiny cozy dog cooperative along the bottom edge, simplified 2D illustrated modular diorama, clear functional silhouette, big readable dog action, huge empty top space.

Avoid: large interior cutaway, art nouveau ornament overload, fantasy village tower, dense tiny details, shelves full of props, aggressive UI, combat, horror, meat processing, guilt imagery, sad starving dogs.  
```

## Pass/fail notes after generation

Dog readable at 96–144 px:

`[yes/no/partial]`

Action readable:

`[yes/no/partial]`

Object readable:

`[yes/no/partial]`

Module silhouette readable:

`[yes/no/partial]`

Too tall / too decorative:

`[yes/no/partial]`

Needs revision:

`[What to change next]`
