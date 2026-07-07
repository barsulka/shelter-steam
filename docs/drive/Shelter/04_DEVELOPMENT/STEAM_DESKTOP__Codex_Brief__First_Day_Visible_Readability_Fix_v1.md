# STEAM_DESKTOP — Codex Brief — First Day Visible Readability Fix v1

Дата: 2026-07-05
Статус: ready for Codex
Роль постановки: Game Designer / Systems Designer
Recommended Codex reasoning: очень высокий

---

## 0. Goal

Implement a narrow prototype readability pass for the current First Day MVP visible strip.

The current R-22 verdict is:

```text
R-22 capture pack: PASS
First Day visible readability: PASS with watchpoints
First Day player-feel / calm timing: NOT ACCEPTED YET
Art Director final visual acceptance: PENDING
```

Main problem:

```text
Too much meaning is carried by UI text/cards; the strip itself does not yet clearly show dog identity, dog-owned actions, postcard/reward moment and next-day hint.
```

This task must improve visible prototype readability without expanding gameplay scope or making final art decisions.

---

## 1. Required sources to read first

Read project rules and relevant docs before editing:

```text
PROJECTS_RULES.md
AGENTS.md
README.md
steam/AGENTS.md
steam/README.md
docs/repo/status/CODEX_STATUS.md
docs/repo/adr/README.md
```

Then read these product/design/runtime docs:

```text
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Game_Design_Roadmap_v2.md
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__First_Day_MVP_v1.md
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__First_Day_UX_Readability_Fix_Requirements_v1.md
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Visible_Review__First_Day_MVP_v1.md
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Runtime_Review__First_Day_MVP_Runtime_Polish_v1.md
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__First_Day_MVP_Visible_Review_Capture_Pack_v1.md
docs/repo/dev/steam-vertical-slice-prototype.md
docs/repo/dev/godot-state-connector.md
docs/repo/api/godot-state-connector.openapi.yaml
```

Relevant accepted architectural decisions must be checked via `docs/repo/adr/README.md`. If uncertain, read all accepted ADRs.

---

## 2. Current implementation context

Current visible capture command:

```sh
cd steam
tools/dev-vertical-slice.sh first-day-visible-capture
```

Current persistent capture pack:

```text
docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v1/
```

Current key implementation areas likely involved:

```text
steam/scripts/prototypes/vertical_slice/vertical_slice_demo.gd
steam/tools/dev-vertical-slice.sh
steam/README.md
docs/repo/dev/steam-vertical-slice-prototype.md
docs/repo/status/CODEX_STATUS.md
```

Do not assume these are the only files. Inspect existing implementation before changing.

---

## 3. Scope

Implement the smallest set of prototype-visible changes that satisfy the requirements document:

```text
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__First_Day_UX_Readability_Fix_Requirements_v1.md
```

### Required improvements

#### 3.1 Dog identity/action readability

Strengthen first-day visual cues for:

```text
dog.dachshund_intro — first driver / Такса
dog.labrador_intro — calm helper / Лабрадор
```

Use simple prototype cues only, for example:

- position/lane association;
- small badges;
- simple pose/attention markers;
- driver/helper marker;
- carry/action marker;
- dog-specific world marker after reward.

Do not create final dog art or final animation pipeline.

Acceptance:

```text
A reviewer can tell which dog drives and which dog helps without relying only on top card text.
```

#### 3.2 Main-strip state cues

Add or strengthen cues for:

```text
route_ready
payload_returned
van_ready_to_dispatch
postcard_available
reward_equipped_or_claimed
next_day_hint_available
```

The strip should communicate broad state even if top cards are ignored.

#### 3.3 Embodied postcard moment

After delivery completion, add one small visible co-op gesture:

```text
dog approaches postcard board
or dog places postcard marker
or both dogs pause/face postcard marker
or small attention marker above dog and postcard
```

Keep it simple. No cutscene, no dialogue system, no new room flow.

#### 3.4 Reward / memory visibility

Make `Удобные тапочки` visibly personal to Такса after completion.

Acceptable implementation:

- small slippers badge near Такса;
- marker on Такса world label;
- visible equipment marker in Dog Card plus world marker;
- other similarly narrow prototype cue.

Preserve D-010 separation:

```text
innate trait: Быстрые лапки
equipment: Удобные тапочки
memory: Помнит первую тёплую поставку
```

#### 3.5 Next-day hint visibility

Expose the next-day hint as visible and gentle in the capture.

Preferred player-facing direction:

```text
Завтра можно придумать, как паковать ещё аккуратнее.
```

or:

```text
На доске появилась заметка: “Как паковать мягче?”
```

Do not start a full House of Curiosity gameplay loop. Keep it a tease only.

---

## 4. Capture output requirement

After implementing, create a new persistent capture pack:

```text
docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v2/
```

You may add a new command if helpful, for example:

```sh
cd steam
tools/dev-vertical-slice.sh first-day-visible-capture-v2
```

or you may update the existing `first-day-visible-capture` command to produce v2 if this is cleaner. In either case, document the command clearly.

The v2 pack must include:

```text
README.md
CAPTURE_MANIFEST_v2.md
captures/screenshots/*.png
captures/video/first_day_mvp_visible_loop_frames/*.png
captures/logs/capture_run_log.txt
captures/state/manifest.json
captures/state/final_state.json
captures/state/events.jsonl
captures/state/stress_signals.jsonl
```

Required named screenshot moments must include at least:

```text
02_initial_strip_player_prototype.png
05_bicycle_return_payload.png
12_van_ready_confirm_delivery.png
13_delivery_complete_postcard_moment.png
14_dog_noticed_postcard.png
15_dog_card_memory_slippers.png
16_next_day_hint.png
17_ui_hidden_world_visible.png
20_readability_preview_96.png
```

If names change, document mapping in README and manifest.

---

## 5. State proof requirements

Do not regress current First Day MVP proof.

Still required:

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

If cheap and local to this task, add proof fields or events such as:

```text
first_day.postcard_world_marker_visible: true
first_day.next_day_hint_world_marker_visible: true
dog.dachshund_intro.first_reward_world_marker_visible: true
```

or event equivalents:

```text
postcard_world_marker_shown
next_day_hint_world_marker_shown
first_reward_world_marker_shown
```

These are prototype review evidence only. They are not new long-term systems.

---

## 6. Out of scope

Do not add:

- new dogs;
- new routes;
- second production chain;
- full House of Curiosity gameplay;
- research assignment;
- mood/energy pressure;
- penalties;
- monetization;
- charity claims;
- paid gacha/reroll/random reward;
- final art style;
- art bible / palette / prompt work;
- new production asset pipeline;
- final UI look;
- broad dev control surface;
- generic editor/cheat controls;
- Browser Extension mechanics.

Do not make final Art Director decisions. Use neutral prototype readability cues.

---

## 7. Stop conditions

Stop and return a question if implementation requires:

- changing First Day order/route meaning;
- removing player route confirmation or dispatch confirmation;
- replacing dog-owned visible steps with inventory-only state changes;
- adding a new room/window flow;
- adding final art/style/palette decisions;
- changing D-010 trait/equipment/memory separation;
- making next-day hint mandatory or pressure-like;
- expanding House of Curiosity beyond a tease;
- breaking existing R-21/R-22 proof;
- modifying Shelter MCP whitelist unless explicitly requested.

---

## 8. Required checks

Run at minimum:

```sh
bash -n steam/tools/dev-vertical-slice.sh
bash -n steam/launch.sh
cd steam && tools/dev-vertical-slice.sh capture-smoke
cd steam && tools/dev-vertical-slice.sh first-day-visible-capture
cd steam && tools/dev-vertical-slice.sh smoke
cd steam && tools/dev-vertical-slice.sh connector-control-smoke
cd steam && tools/check-godot.sh
python3 -m json.tool docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v2/captures/state/manifest.json >/dev/null
python3 -m json.tool docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v2/captures/state/final_state.json >/dev/null
git diff --check
```

If the command name changes, update checks accordingly.

Also validate:

- v2 pack exists;
- expected screenshot count is present;
- frame sequence exists;
- PNG dimensions are reasonable, including 96px preview;
- existing `first_day_mvp_proof` still passes;
- new readability proof fields/events, if added, are present.

---

## 9. Documentation updates required

Update:

```text
steam/README.md
docs/repo/dev/steam-vertical-slice-prototype.md
docs/repo/status/CODEX_STATUS.md
```

Create/update:

```text
docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v2/README.md
docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v2/CAPTURE_MANIFEST_v2.md
```

Do not update product scope documents unless the implementation reveals a conflict or blocker. If a conflict appears, stop and report it.

---

## 10. Acceptance criteria

Task is accepted when:

1. New or updated visible cues make first-day dog/action state easier to understand without top-card dependency.
2. Такса reads as first driver and Лабрадор reads as helper at prototype level.
3. Postcard moment has visible dog/co-op gesture.
4. `Удобные тапочки` are visibly personal to Такса.
5. Next-day hint is visible and gentle.
6. New v2 persistent capture pack exists.
7. Existing First Day MVP runtime proof still passes.
8. Checks pass.
9. Docs/status are updated.
10. No forbidden scope, tone, monetization or Browser Extension mechanics are introduced.

---

## 11. Final response expected from Codex

Report:

- files changed;
- exact capture command;
- v2 capture pack path;
- screenshot count;
- frame count;
- state proof summary;
- checks run and results;
- any limitations;
- whether Shelter MCP whitelist was changed. It should not be changed unless explicitly requested.

Do not claim final visual acceptance. State that Game Designer / Art Director / UX review is still required.
