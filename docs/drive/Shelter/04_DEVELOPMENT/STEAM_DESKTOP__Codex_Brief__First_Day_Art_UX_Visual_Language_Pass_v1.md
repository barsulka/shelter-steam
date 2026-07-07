# STEAM_DESKTOP — Codex Brief — First Day Art / UX Visual Language Pass v1

Дата: 2026-07-06
Статус: prepared, awaiting user confirmation for implementation
Роль постановки: Art Director / UX + Codex preparation
Recommended Codex reasoning: очень высокий

---

## 0. Goal

Implement, after explicit user confirmation, a narrow Art / UX visual-language pass for the current First Day MVP strip.

The R-23 verdict is:

```text
R-23 First Day Visible Readability Fix v1: PASS
First Day prototype readability: PASS with minor watchpoints
First Day player-feel / calm timing: NOT ACCEPTED YET
Art Director / UX final visual acceptance: PENDING
```

The Art / UX handoff verdict is:

```text
PASS as prototype readability handoff.
NOT ACCEPTED as production art.
Meaning still depends too much on cards, labels, badges, arrows and marker text.
```

Main goal:

```text
Move first-day meaning from UI / marker language
to object / state / pose / simple animation language.
```

This is not a gameplay task. It must not expand First Day MVP. It must improve how the existing First Day explains itself through the world.

---

## 1. Required sources to read first

Read project rules and current implementation context before editing:

```text
PROJECTS_RULES.md
AGENTS.md
README.md
docs/repo/status/CODEX_STATUS.md
docs/repo/dev/godot-state-connector.md
steam/README.md
steam/AGENTS.md
docs/repo/adr/README.md
docs/repo/adr/0001-use-godot-for-steam-desktop.md
docs/repo/adr/0002-game-state-as-source-of-truth.md
```

Then read these product/design/review docs:

```text
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Game_Design_Roadmap_v2.md
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Visible_Review__First_Day_MVP_v2.md
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Visible_Review__First_Day_MVP_v1.md
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__First_Day_MVP_v1.md
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__First_Day_UX_Readability_Fix_Requirements_v1.md
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__First_Day_Visible_Readability_Fix_v1.md
docs/repo/status/STEAM_DESKTOP_ART_UX_HANDOFF_FIRST_DAY_MVP_V2.md
docs/repo/dev/steam-vertical-slice-prototype.md
docs/repo/api/godot-state-connector.openapi.yaml
```

Inspect current implementation before changing:

```text
steam/scripts/prototypes/vertical_slice/vertical_slice_demo.gd
steam/tools/dev-vertical-slice.sh
```

Do not rely on previous chat memory as source of truth.

---

## 2. Current implementation context

Current visible capture command:

```sh
cd steam
tools/dev-vertical-slice.sh first-day-visible-capture
```

Current R-23 persistent capture pack:

```text
docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v2/
```

R-23 intentionally added prototype markers:

```text
driver/helper badges
route / payload / van / postcard / reward / next-day markers
postcard_world_marker_shown
next_day_hint_world_marker_shown
first_reward_world_marker_shown
```

These markers are useful scaffolding. This pass should keep them available for review/debug, but make the world understandable without depending on marker text.

---

## 3. Scope

Implement the smallest set of visual/prototype changes that improves object/state/pose/simple-animation language for the existing First Day MVP.

### 3.1 Такса as first driver

Такса should read as the first driver through the world, not primarily through a badge.

Use prototype-level cues such as:

- lower / longer dachshund silhouette;
- quick small-step gait or more energetic route-prep bob;
- position and attention near Basket Bicycle before departure;
- short route-prep pose beside the bicycle;
- departure/return association with bicycle and payload;
- return posture near payload before unload starts.

Acceptance:

```text
With UI hidden, a reviewer can infer that Такса is the dog associated with the bicycle route.
```

Do not add a new dog, route, trait, stat or role system.

### 3.2 Лабрадор as calm helper

Лабрадор should read as a calm helper through movement and work poses, not primarily through a label.

Use prototype-level cues such as:

- larger / steadier silhouette;
- slower, grounded walk timing;
- calmer idle pose near Storage / Kitchen / Packing Table;
- careful carry pose;
- steady Kitchen / Packing pose;
- helper work posture near van loading.

Acceptance:

```text
With UI hidden, a reviewer can infer that Лабрадор is the helper/work-zone dog.
```

Do not add mood/energy systems, penalties, helper balance numbers or new progression.

### 3.3 Payload flow through physical objects

Reduce dependence on arrows/labels for resource flow.

Improve physical state readability:

- crates visibly lie near bicycle/payload before unload;
- dog visibly carries the actual resource token;
- token appears at source, attaches to dog, then appears at target;
- source/target station changes state after handoff;
- Packing Table visibly changes from inputs -> work surface -> Food Bag output.

Acceptance:

```text
The route -> payload -> storage -> kitchen -> packing -> van flow can be followed by object movement/state changes in screenshots and frame sequence.
```

Do not change inventory semantics, production-chain order, resource list or timings beyond local visual/capture needs.

### 3.4 Van ready as object state

Replace or reduce reliance on `фургон готов` marker.

Use prototype-level object state such as:

- van hatch/door visibly open while ready;
- Food Bag visibly placed in or beside the van before dispatch;
- van visually shifts from waiting -> loaded -> sent/delivered;
- marker may remain as debug scaffolding, but should not be the only cue.

Acceptance:

```text
With UI hidden, the van-ready moment reads as a prepared loaded van, not only as text.
```

Do not remove player dispatch confirmation.

### 3.5 Postcard moment as world emotion

This is the most important visual/UX beat.

The postcard card must stop being the primary carrier of emotion. The world should carry the moment.

Use a low-scope sequence such as:

```text
postcard appears on board
dogs notice it
dogs briefly face/pause near it
postcard remains as a persistent board/world state
top card only mirrors the moment
```

Acceptable implementation:

- physical postcard board/card placement;
- simple dog facing/attention pause;
- subtle non-text highlight;
- short capture-only or prototype-local timing hold around the moment.

Acceptance:

```text
Hidden-UI screenshots and low-speed frames show a world-level postcard moment.
```

Do not add a cutscene, dialogue system, new room/window flow or final art direction.

### 3.6 Удобные тапочки as physical Такса reward

`Удобные тапочки` must read as personal to Такса through physical attachment, not as random UI text.

Use prototype-level cues such as:

- small visible slippers/paw accent on Такса;
- slippers object moves/appears near Такса;
- short equip/comfort beat;
- post-reward idle cue for Такса.

Preserve D-010:

```text
innate trait: Быстрые лапки
equipment: Удобные тапочки
memory: Помнит первую тёплую поставку
```

Acceptance:

```text
With UI hidden, reward ownership is visibly attached to Такса.
```

Do not create rarity, random reward, paid reroll, stat optimization or new equipment UI.

### 3.7 Next-day hint as physical note

The next-day hint must not look like a tutorial popup.

Use a soft physical cue:

```text
small note / paper / sticker near Packing Table or co-op board
```

Text can exist in review mode or card mirror, but the primary cue should be object placement.

Tone remains:

```text
Завтра можно придумать, как паковать ещё аккуратнее.
```

Acceptance:

```text
The hint is visible as a gentle world note, with no timer, pressure, FOMO or mandatory action.
```

Do not start House of Curiosity gameplay, research assignment or second chain.

### 3.8 Hidden UI and 96px readability

Hidden UI remains mandatory.

The pass must improve:

- hidden UI screenshots after key beats;
- coarse silhouettes and landmarks at 96px;
- action composition without relying on readable text.

At 96px, do not optimize for text readability. Validate:

```text
composition
silhouettes
landmarks
visible action/state clusters
```

---

## 4. Out of scope

Do not add:

- First Week;
- new dogs;
- new routes;
- new production chains;
- full House of Curiosity;
- research assignment;
- mood/energy pressure;
- penalties;
- economy or balance changes;
- progression changes;
- monetization;
- charity claims;
- paid gacha/reroll/random reward;
- FOMO;
- timers or urgency pressure;
- punishment;
- final art style;
- final palette;
- final UI look;
- art bible;
- prompt work;
- production asset pipeline;
- broad dev control surface;
- generic editor/cheat controls;
- Browser Extension mechanics.

Do not claim production art acceptance or final Art Director acceptance.

---

## 5. Stop conditions

Stop and return a question if implementation requires:

- changing First Day route/order meaning;
- adding new First Day beats;
- removing player route confirmation;
- removing player dispatch confirmation;
- replacing dog-owned visible steps with inventory-only changes;
- changing D-010 trait/equipment/memory separation;
- expanding House of Curiosity beyond a tease;
- adding a new room/window flow;
- adding a new production asset pipeline;
- making next-day hint mandatory or pressure-like;
- adding final style/palette/art decisions;
- breaking existing R-21/R-22/R-23 proof;
- modifying Shelter MCP whitelist unless explicitly requested.

---

## 6. Expected implementation areas

Likely areas:

```text
steam/scripts/prototypes/vertical_slice/vertical_slice_demo.gd
steam/tools/dev-vertical-slice.sh
steam/README.md
docs/repo/dev/steam-vertical-slice-prototype.md
docs/repo/status/CODEX_STATUS.md
docs/repo/api/godot-state-connector.openapi.yaml
docs/repo/dev/godot-state-connector.md
```

Do not assume these are the only files. Inspect before editing.

Prefer local procedural prototype drawing/animation in the existing Godot scene. Do not add production dependencies.

If state/API/manifest contract changes, update connector/OpenAPI/docs. If only visuals/capture docs change, do not churn API docs.

---

## 7. Capture output requirement

After implementation, create a new persistent capture pack.

Recommended output:

```text
docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v3/
```

Recommended command:

```sh
cd steam
tools/dev-vertical-slice.sh first-day-art-ux-capture
```

Acceptable alternative:

```sh
cd steam
tools/dev-vertical-slice.sh first-day-visible-capture-v3
```

Do not overwrite the v2 pack.

The pack must include:

```text
README.md
CAPTURE_MANIFEST_v3.md
captures/screenshots/*.png
captures/video/first_day_mvp_visible_loop_frames_1x/*.png
captures/video/postcard_slippers_moment_1x/*.png
captures/logs/capture_run_log.txt
captures/state/manifest.json
captures/state/final_state.json
captures/state/events.jsonl
captures/state/stress_signals.jsonl
```

100x Workbench state proof may be included under `captures/state/`, but visual acceptance must rely on 1x/low-speed visible capture, not 100x.

Required named screenshots should include at least:

```text
02_initial_strip_player_prototype.png
03_route_prep_dachshund_bicycle.png
05_bicycle_return_payload_objects.png
07_storage_to_kitchen_carry_object.png
10_packing_table_food_bag_state.png
12_van_ready_object_state.png
13_delivery_complete_postcard_board.png
14_dogs_notice_postcard_hidden_ui.png
15_slippers_equip_dachshund_hidden_ui.png
16_next_day_note_hidden_ui.png
17_ui_hidden_world_visible.png
20_readability_preview_96.png
```

If names change, document mapping in README and manifest.

---

## 8. State proof requirements

Do not regress current First Day MVP proof:

```text
order.delivery_confirmed: true
order.postcard_visible: true
order.reward_available: true
game.chain_complete: true
first_day.postcard_life_moment_seen: true
first_day.first_reward_equipped: true
first_day.first_memory_added: true
first_day.next_day_hint_available: true
food_bag.location: delivered_to_shelter
food_bag.visible: false
food_bag.semantic_state: delivered
```

Preserve or update review evidence for the world moments if local to the task:

```text
postcard_world_marker_shown
next_day_hint_world_marker_shown
first_reward_world_marker_shown
```

If marker events become object-state events, document the mapping clearly, for example:

```text
postcard_board_state_visible
next_day_note_object_visible
slippers_equipped_world_visible
```

These are review/prototype evidence only, not a new progression system.

---

## 9. Required checks

Run at minimum:

```sh
bash -n steam/tools/dev-vertical-slice.sh
bash -n steam/launch.sh
cd steam && tools/dev-vertical-slice.sh capture-smoke
cd steam && tools/dev-vertical-slice.sh first-day-art-ux-capture
cd steam && tools/dev-vertical-slice.sh smoke
cd steam && tools/dev-vertical-slice.sh connector-control-smoke
cd steam && tools/check-godot.sh
python3 -m json.tool docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v3/captures/state/manifest.json >/dev/null
python3 -m json.tool docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v3/captures/state/final_state.json >/dev/null
git diff --check
```

If the command or output path changes, update checks accordingly.

Also validate:

- v3 pack exists;
- 1x/low-speed frame sequence exists;
- postcard/slippers 1x moment frames exist;
- hidden UI screenshots exist;
- compact previews exist;
- PNG dimensions are reasonable, including 96px preview;
- existing `first_day_mvp_proof` still passes;
- world/object evidence events or mapped replacements are present;
- no 100x visual/player-feel claim is made.

---

## 10. Documentation updates required after implementation

Update:

```text
steam/README.md
docs/repo/dev/steam-vertical-slice-prototype.md
docs/repo/status/CODEX_STATUS.md
```

Create/update:

```text
docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v3/README.md
docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v3/CAPTURE_MANIFEST_v3.md
docs/repo/status/STEAM_DESKTOP_CODEX_HANDOFF_FIRST_DAY_ART_UX_VISUAL_LANGUAGE_PASS_V1.md
```

Update connector/OpenAPI docs only if state/API/manifest contract changes.

Do not update product scope documents unless implementation reveals a conflict or blocker.

---

## 11. Acceptance criteria

Task is accepted when:

1. The existing First Day flow explains more through object/state/pose/simple-animation language and less through marker text.
2. Такса reads as first driver through silhouette, bicycle proximity/use, route prep and return behavior.
3. Лабрадор reads as calm helper through movement, idle and work poses.
4. Payload/resource flow is legible through physical object movement/state changes.
5. Van-ready state reads as loaded/prepared object state.
6. Postcard moment is visible in the world with dog attention/pause/board state.
7. `Удобные тапочки` are physically attached to Такса after reward.
8. Next-day hint reads as a gentle physical note, not tutorial popup.
9. Hidden UI screenshots remain understandable at coarse level.
10. 96px preview preserves landmarks/silhouettes/action clusters.
11. Existing runtime proof remains passing.
12. New persistent capture pack exists with 1x/low-speed visual evidence and state proof.
13. Checks pass.
14. Docs/status/handoff are updated.
15. No forbidden gameplay, economy, progression, monetization, FOMO, punishment, timer, Browser Extension or final art-scope change is introduced.

---

## 12. Final response expected from Codex after implementation

Report:

- files changed;
- exact capture command;
- v3 capture pack path;
- screenshot count;
- 1x frame count;
- postcard/slippers moment frame count;
- state proof summary;
- checks run and results;
- limitations;
- whether Shelter MCP whitelist was changed.

Do not claim final visual acceptance. State that Art Director / UX review is still required.

---

## 13. Preparation note

This brief was prepared from the Art / UX handoff and local project docs. Implementation must not begin until the user explicitly confirms this brief/scope.
