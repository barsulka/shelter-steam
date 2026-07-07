# STEAM_DESKTOP — First Day UX / Visual Readability Fix Requirements v1

Дата: 2026-07-05
Роль документа: Game Design / UX-logic Requirements Contract
Статус: v1 для Codex brief
Продукт: Steam/Desktop idle always-on-top strip
Roadmap task: R-23 — First Day UX / Visual Readability Fix Contract v1
Роль-владелец: Game Designer / Systems Designer

---

## 0. Назначение

Этот документ превращает watchpoints из R-22 visible review в узкий gameplay/UX readability contract для следующего Codex-pass.

Источник R-22 review:

```text
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Visible_Review__First_Day_MVP_v1.md
```

Цель R-23:

> Первый день должен читаться как действие двух собак в маленьком кооперативе, а не как набор карточек и semantic labels.

Этот документ не утверждает final art direction. Он описывает, какие игровые сущности, действия и состояния должны лучше считываться в текущем prototype strip.

---

## 1. Current problem

R-22 подтвердил, что First Day loop виден и state proof валиден.

Но R-22 также выявил проблему:

```text
Слишком много смысла несёт UI text, а не сами собаки/действия/main strip.
```

Текущий prototype показывает правильный loop:

```text
route -> payload -> unload/carry -> kitchen -> packing -> van -> postcard -> reward
```

Но игрок всё ещё часто понимает происходящее через top cards / labels / Dog Card, а не через мир.

---

## 2. R-23 goals

R-23 должен усилить пять вещей:

1. Dog identity/action readability.
2. Main-strip state cues.
3. Postcard as embodied co-op moment.
4. First reward / memory visibility.
5. Gentle next-day hint visibility.

R-23 не должен расширять игровой scope.

---

## 3. UX principle

### 3.1 Strip first, cards second

Main strip must communicate broad state before text cards explain details.

Cards may still explain:

- exact order name;
- exact dog trait/equipment text;
- gratitude text;
- debug/test labels in QA mode.

But broad player understanding should come from visible world cues:

```text
who is acting
where the action happens
what object changed
what the next calm action is
```

### 3.2 Prototype readability beats final beauty

R-23 may use simple prototype visuals:

- small badges;
- state markers;
- simple pose changes;
- arrows / attention cues;
- visible object placement;
- non-final placeholder animations.

Do not make final art decisions.

### 3.3 No pressure

All hints and completion language must stay calm.

Forbidden tone:

```text
Срочно
Провал
Ты не успел
Собакам плохо из-за тебя
```

Allowed tone:

```text
Фургон готов.
Можно отправить первую тёплую поставку.
Завтра можно придумать, как паковать ещё аккуратнее.
```

---

## 4. Required improvements

### 4.1 Dog identity/action readability

Problem:

- Такса/Лабрадор as identities are mostly explained through UI text;
- action badges are useful but can read as semantic blocks;
- driver/helper roles are not strong enough without labels.

Requirement:

The player should distinguish the two dogs during First Day capture through at least two prototype-level cues each.

#### Такса cues

Такса must read as the first driver.

Acceptable prototype cues:

- positioned near Basket Bicycle before route;
- small driver/route badge near dog or bicycle;
- after route start, dog visually associated with bicycle lane;
- on return, dog is near bicycle/payload;
- reward slippers later attach to Такса cue/card/world marker.

#### Лабрадор cues

Лабрадор must read as calm helper.

Acceptable prototype cues:

- positioned near Storage/Kitchen/Packing during helper steps;
- helper/carry badge appears during unload/carry/packing;
- participates in postcard attention moment;
- not confused with driver dog.

Acceptance:

```text
In the new visible capture, a reviewer can tell which dog is driving and which dog helps without relying only on top card text.
```

### 4.2 Main-strip state cues

Problem:

- route, payload, van, postcard and reward states are understandable but still card-heavy.

Requirement:

Add or strengthen visible main-strip cues for these states:

```text
route_ready
payload_returned
van_ready_to_dispatch
postcard_available
reward_equipped_or_claimed
next_day_hint_available
```

Possible prototype implementation examples:

- route marker brightens or gains a small ready marker;
- returned payload has clear position near bicycle/Storage;
- loaded van gets a clear ready marker before dispatch;
- postcard appears physically on board or near van/co-op board;
- slippers appear as a small marker attached to Такса or her Dog Card/world position;
- next-day hint appears as a small curiosity note / board marker, not only state flag.

Acceptance:

```text
The main strip still reads at a coarse level when top cards are minimized or ignored.
```

### 4.3 Postcard embodied moment

Problem:

- postcard text is warm and acceptable;
- but the moment is too card-centric.

Requirement:

Add one small visible co-op gesture after delivery completion.

Preferred low-scope options:

```text
Option A — dog approaches postcard board
Option B — dog brings/places postcard marker on co-op board
Option C — both dogs pause/face postcard marker near van/board
Option D — small attention marker above dog and postcard
```

Do not add a cutscene.
Do not add dialogue system.
Do not add new room window.
Do not expand House of Curiosity.

Acceptance:

```text
Postcard moment is visible in the world, not only in top card text.
```

### 4.4 Reward / memory visibility

Problem:

- `Удобные тапочки` is clear in UI;
- D-010 is textually proven by Dog Card;
- but reward is not visually meaningful enough.

Requirement:

Add a simple prototype cue that `Удобные тапочки` belong to Такса after completion.

Acceptable cues:

- small slippers icon/badge near Такса;
- small slippers marker in Такса card plus world marker;
- dog label includes equipment marker only after reward;
- reward marker appears only after postcard/reward event.

Memory requirement:

`Помнит первую тёплую поставку` should remain visible in Dog Card/state, but R-23 may add a small non-final memory marker if cheap.

Acceptance:

```text
After reward, reviewer can see that first reward is personal and attached to Такса, not generic loot.
```

### 4.5 Next-day hint visibility

Problem:

- state proof says `next_day_hint_available=true`;
- visible screenshot does not clearly expose it as a distinct moment.

Requirement:

Add a gentle visible next-day hint after postcard/reward.

Constraints:

- must be optional/gentle;
- must not look like tutorial pressure;
- must not unlock full research tree;
- must not start active House of Curiosity loop;
- must not add second production chain.

Preferred text direction:

```text
Завтра можно придумать, как паковать ещё аккуратнее.
```

or:

```text
На доске появилась заметка: “Как паковать мягче?”
```

Acceptance:

```text
A reviewer can identify the next-day hint in visible capture without inspecting JSON.
```

---

## 5. Capture requirements after fix

After implementation, Codex should regenerate a persistent capture pack or a v2 pack.

Preferred output:

```text
docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v2/
```

Minimum expected capture artifacts:

```text
README.md
CAPTURE_MANIFEST_v2.md
captures/screenshots/*.png
captures/video/first_day_mvp_visible_loop_frames/*.png
captures/state/manifest.json
captures/state/final_state.json
captures/state/events.jsonl
captures/state/stress_signals.jsonl
captures/logs/capture_run_log.txt
```

Required named screenshots should include at least:

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

If names change, README and manifest must map old-to-new review moments.

---

## 6. State proof requirements

R-23 must preserve existing runtime proof.

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

Additional desired proof fields/events if cheap:

```text
first_day.postcard_world_marker_visible: true
first_day.next_day_hint_world_marker_visible: true
dog.dachshund_intro.first_reward_world_marker_visible: true
```

or equivalent event records:

```text
postcard_world_marker_shown
next_day_hint_world_marker_shown
first_reward_world_marker_shown
```

These are not new product systems; they are review/prototype readability evidence.

---

## 7. Out of scope

R-23 must not add:

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
- new production asset pipeline;
- final UI look;
- broad dev control surface;
- generic editor/cheat controls;
- Browser Extension mechanics.

---

## 8. Stop conditions

Codex or any implementation agent must stop and return a question if the fix requires:

- changing First Day order/route meaning;
- removing player dispatch confirmation;
- replacing dog-owned steps with inventory-only changes;
- introducing a new room/window flow;
- adding final art decisions;
- changing D-010 trait/equipment/memory separation;
- making next-day hint mandatory or pressure-like;
- expanding House of Curiosity beyond tease;
- breaking existing R-21/R-22 proof.

---

## 9. Acceptance criteria

R-23 is accepted when:

1. A focused implementation pass improves visible dog/action readability.
2. Main strip has stronger route/payload/van/postcard/reward/next-day cues.
3. Postcard moment has at least one visible dog/co-op gesture.
4. `Удобные тапочки` are visibly personal to Такса.
5. Next-day hint is visible and gentle.
6. Existing First Day MVP runtime proof remains passing.
7. A new persistent capture pack exists for review.
8. No forbidden scope or tone is introduced.

---

## 10. Recommended Codex task

Create Codex brief:

```text
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__First_Day_Visible_Readability_Fix_v1.md
```

Recommended Codex reasoning:

```text
очень высокий
```

Reason:

The task looks visual, but it touches accepted First Day MVP meaning, dog identity, player-facing cues, runtime proof and capture artifacts. Codex must not invent new product scope or final art direction.

---

## 11. Sources

```text
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__First_Day_MVP_v1.md
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Visible_Review__First_Day_MVP_v1.md
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Game_Design_Roadmap_v2.md
docs/repo/status/CODEX_STATUS.md
```
