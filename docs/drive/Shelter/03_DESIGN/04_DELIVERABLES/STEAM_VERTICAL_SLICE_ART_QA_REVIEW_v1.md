# STEAM_VERTICAL_SLICE_ART_QA_REVIEW v1

Дата: 2026-06-29  
Роль: Art Director / Visual Design / UX  
Статус: Art QA complete for current prototype capture  
Основано на:

- `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_VERTICAL_SLICE_ART_QA_CAPTURE_v1/README.md`
- `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_VERTICAL_SLICE_ART_QA_CAPTURE_v1/CAPTURE_MANIFEST_v1.md`
- `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_VERTICAL_SLICE_ART_QA_CAPTURE_v1/captures/logs/capture_run_log.txt`
- screenshot review: `captures/screenshots/01_initial_strip.png`

## 1. Scope

Этот review оценивает текущий Steam Vertical Slice prototype как визуально-семантический prototype, а не как production art.

Проверялись:

- readability;
- visual hierarchy;
- placeholder acceptability;
- dog/action visibility;
- UI dominance;
- main-strip composition;
- preservation of Shelter visual direction and ethics.

Не проверялись:

- normal player-facing timing;
- final art quality;
- final UI style;
- production animation quality;
- economy/gameplay balance.

Capture использует fast deterministic timing, поэтому feel/timing review отложен.

## 2. Overall verdict

Current state:

> PASS for internal prototype / Codex continuation.  
> NOT YET PASS for player-facing Vertical Slice readability without labels.

Главная оценка:

- core visual loop is reviewable;
- lower strip direction works;
- physical chain exists;
- asset taxonomy mostly survives;
- no ethical/tone hard stop found;
- but current prototype depends heavily on debug labels and large UI/debug cards;
- dogs/actions are not yet visually dominant enough for Shelter's main promise.

This should not block Codex continuing implementation, but it should block any claim that the slice is visually/player-facing ready.

## 3. What passes

### 3.1 Main strip composition

PASS for prototype.

The world sits as a low bottom strip. Upper space remains mostly empty and non-invasive, which supports the Steam/Desktop overlay direction.

### 3.2 Physical production chain

PASS for prototype.

The capture log confirms the physical chain exists:

```text
order -> trip -> bicycle leaves -> trip state -> bicycle returns -> payload visible -> unload -> storage -> kitchen -> food_mix -> packing -> food_bag -> van -> delivery confirmation -> postcard -> reward -> slippers equipped
```

This is important: Codex did not reduce the chain to pure inventory updates.

### 3.3 Taxonomy preservation

PASS / PARTIAL PASS.

Current taxonomy is mostly preserved:

- Storage / Kitchen read as Building anchors;
- Road Sign / Basket Bicycle / Packing Table / Delivery Van Endpoint remain Utility Prop / endpoint concepts;
- Packing Table does not become a house;
- Delivery Van Endpoint does not become a garage;
- resources remain physical tokens in the chain.

Need continued guardrail: Utility Props must not acquire building language during future polish.

### 3.4 Shelter tone

PASS.

No visible guilt pressure, sad starving-dog imagery, red-alert emotional manipulation, combat, urgency panic, or dark-pattern visual tone appears in the reviewed materials.

### 3.5 D-010 separation

PASS for prototype.

The capture includes Dog Card state with innate trait and equipment separated. This supports D-010 direction: dog identity is not replaced by equipment.

### 3.6 UI hide mode

PASS for prototype.

Capture includes UI hidden / restored states. This is important for the always-on-top Steam/Desktop strip direction.

## 4. Main problems

### 4.1 UI/debug cards dominate the world

Severity: HARD before player-facing review.

The current visible scene is dominated by:

- order card;
- route card;
- dog card;
- contract/debug card;
- bottom debug status bar;
- semantic labels.

For Codex QA this is acceptable. For Shelter visual direction, it is too strong: dogs and actions should read before UI cards.

Required direction:

- keep QA labels/debug UI available;
- add or improve a player-prototype view where UI is compact/collapsed and semantic labels can be hidden;
- preserve enough semantic clarity without drowning the strip.

### 4.2 Dogs/actions are weaker than buildings and UI

Severity: HARD before player-facing review.

Shelter is a dog-first project. In the current capture, buildings and UI read more strongly than dogs/actions.

For prototype continuation this is okay, but the next visual pass must increase dog/action readability.

Required direction:

- dog/action silhouettes must be bigger or clearer;
- carried resource must remain attached and readable;
- action state should be understood without relying only on text labels;
- dogs should not become decorative dots.

### 4.3 Label dependency

Severity: HARD before player-facing review.

Labels are useful for Art QA and Codex debugging, but the slice cannot rely on labels as the primary way to understand the world.

Current status:

- labels-on: acceptable for internal review;
- labels-off: requires dedicated re-check after semantic placeholder cleanup.

Required direction:

- keep debug labels toggle;
- test with labels off;
- use silhouettes, scale, spacing and simple shapes to carry meaning.

### 4.4 Missing Level 0 semantic placeholders

Severity: HARD before next readability pass.

The current pack still needs separate semantic placeholders for the required Vertical Slice chain.

Missing or insufficient:

- improved Packing Table placeholder;
- separate Oat Crate;
- separate Pumpkin Crate;
- Protein Packet;
- Packaging Bag;
- separate Food Mix;
- separate Food Bag;
- Comfortable Slippers icon;
- First Postcard frame;
- dog action placeholders / silhouettes for Dachshund and Labrador or generic dog-action proxy.

### 4.5 Food Mix / Food Bag bridge is temporary

Severity: HARD if transformation must be visually reviewed.

The combined Food Mix / Food Bag composite can remain as a temporary implementation bridge, but the transformation step requires separate visible tokens.

Required direction:

```text
Food Mix -> Packing Table + Packaging Bag -> Food Bag
```

This should be visually understandable even in prototype mode.

### 4.6 216 / 144 / 96 readability pass not yet complete for Vertical Slice

Severity: HARD before player-facing approval.

Dog rig had readability previews, but the full Vertical Slice needs its own pass.

Required states:

- labels on;
- labels off;
- UI visible;
- UI compact/hidden;
- key chain states.

## 5. Per-object review

### 5.1 Road Sign / Basket Bicycle

Status: PASS for prototype.

They read as route/transport-related Utility Props. They are small, but acceptable for the current internal slice.

Watch item:

- do not let Road Sign become a map building;
- do not let Basket Bicycle become a shop/garage/station.

### 5.2 Storage

Status: PASS for prototype.

Storage reads as a Building anchor. It is acceptable as a larger strip landmark.

Watch item:

- keep it subordinate to dogs/actions in future passes;
- avoid turning main strip into inspect/interior view.

### 5.3 Kitchen

Status: PASS / PARTIAL PASS.

Kitchen as a Building anchor is acceptable, but future production direction should keep it functional and not over-detailed in the main strip.

### 5.4 Packing Table

Status: PASS as Utility Prop placeholder, needs semantic improvement.

Good:

- it reads as a table/work surface;
- it does not become a building.

Needs:

- stronger packing semantics;
- clear relation to Food Mix + Packaging Bag -> Food Bag.

### 5.5 Delivery Van Endpoint

Status: PASS for prototype.

It reads as a van/endpoint, not as a garage.

Hard rule remains:

> Do not turn Van Endpoint into a garage, building or room.

### 5.6 Resources

Status: PARTIAL PASS.

Resources exist physically in the chain, which is good.

Problem:

- separate resource identities are not yet strong enough;
- combined Food Mix/Food Bag is only a temporary bridge.

Required:

- clear tokens for Oat, Pumpkin, Protein, Packaging, Food Mix, Food Bag.

### 5.7 Dogs / dog actions

Status: PARTIAL PASS for internal prototype, FAIL for player-facing readability.

Current dogs/actions are acceptable for proving the flow, but not enough for Shelter visual promise.

Required:

- stronger dog silhouettes;
- clearer carried-object attachment;
- action readability before labels;
- enough scale/contrast that dog actions compete with buildings and UI.

### 5.8 UI / cards

Status: PASS for QA, FAIL for player-facing visual hierarchy.

Current cards are useful for debugging and contract verification. They are too dominant for a player-facing slice.

Required:

- QA/debug view;
- player-prototype compact view;
- labels on/off toggle;
- UI should support the strip, not cover its priority.

### 5.9 Postcard / Slippers

Status: PASS as debug proof, needs semantic placeholder art.

The reward sequence exists. Visual identity is not ready.

Required:

- First Postcard frame placeholder;
- Comfortable Slippers icon placeholder;
- Dog Card should keep innate trait and equipment visually separated.

## 6. Readability baseline assessment

### 216 px

Likely PASS for internal prototype with labels.

Needs re-check after placeholders are separated and UI compact mode exists.

### 144 px

PARTIAL PASS risk.

Dog/action and separate resource identities need strengthening.

### 96 px

FAIL risk for player-facing readability.

At this size, semantic labels and debug UI likely become noise. Large action silhouettes and clear resource tokens are required.

## 7. Hard stop conditions for next pass

Stop and return to Art Director if any of these remain after the fix pass:

- dog action cannot be understood without a long text label;
- carried object disappears at strip scale;
- Food Mix and Food Bag are visually indistinguishable at the transformation step;
- Utility Prop starts reading as a Building;
- UI/debug cards dominate over the dog/action layer;
- labels-off mode makes the loop impossible to follow;
- 96 px check loses dog + carried object entirely;
- reward tone becomes guilt/charity pressure;
- production chain becomes inventory-only or instant-state-only.

## 8. Art Director decision

Decision:

> Current Vertical Slice capture is approved for internal prototype continuation, but not approved as player-facing visual/readability slice.

Codex may continue, but the next task should be a visual/readability fix pass, not new mechanics and not Dog Shape Pack yet.

## 9. Next recommended task

Next Codex task:

`STEAM_VERTICAL_SLICE_ART_QA_FIX_PASS_v1`

Goal:

- add Level 0 semantic placeholders;
- separate resource identities;
- strengthen dog/action readability;
- add QA/player prototype view modes;
- re-capture key states with labels on/off and scale checks.

After that:

1. run Vertical Slice readability pass v2;
2. then start Dog Shape Pack v1.
