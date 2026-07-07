# STEAM_DESKTOP — Visible Review — First Day MVP v2

Дата: 2026-07-05
Роль: Game Designer / Systems Designer
Статус: зафиксировано
Roadmap task: R-23 — First Day UX / Visual Readability Fix Contract v1

---

## 0. Контекст

Этот review проверяет v2 persistent visible capture pack после Codex-задачи:

```text
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__First_Day_Visible_Readability_Fix_v1.md
```

Source capture pack:

```text
docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v2/
```

R-23 был узким prototype readability pass. Цель проверки:

> Понять, стал ли первый день лучше читаться как действие двух собак в маленьком кооперативе, а не как набор карточек и semantic labels.

Этот review не является финальной Art Director / UX приёмкой, не утверждает production art, final UI look, animation language или real-speed player feel.

---

## 1. Проверенный capture pack

Пакет содержит:

```text
README.md
CAPTURE_MANIFEST_v2.md
captures/screenshots/*.png
captures/video/first_day_mvp_visible_loop_frames/frame_0001.png ... frame_0028.png
captures/logs/capture_run_log.txt
captures/state/manifest.json
captures/state/final_state.json
captures/state/events.jsonl
captures/state/stress_signals.jsonl
```

Структурная проверка:

```text
Screenshots: 20
Frame sequence: 28
State proof: present
first_day_mvp_proof: present
exit_status: success
snapshot_count: 42
events_written: 109
```

State proof сохраняет R-21/R-22 условия:

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

New marker proof:

```text
postcard_world_marker_shown
next_day_hint_world_marker_shown
first_reward_world_marker_shown
```

Capture mode:

```text
visible macOS Godot companion strip
fast deterministic capture
not normal player-facing timing
```

---

## 2. Main verdict

```text
R-23 First Day Visible Readability Fix v1: PASS
First Day prototype readability: PASS with minor watchpoints
First Day player-feel / calm timing: NOT ACCEPTED YET
Art Director / UX final visual acceptance: PENDING
```

Codex выполнил узкий readability pass без расширения scope. Первый день теперь заметно лучше читается из main strip: появились более явные driver/helper markers, route/payload/van cues, embodied postcard/board cue, slippers marker and visible next-day hint.

---

## 3. Reviewed screenshots

Просмотрены через MCP / media read:

```text
02_initial_strip_player_prototype.png
05_bicycle_return_payload.png
12_van_ready_confirm_delivery.png
15_dog_card_memory_slippers.png
16_next_day_hint.png
20_readability_preview_96.png
```

Также подтверждены через directory tree / README / CAPTURE_MANIFEST:

```text
13_delivery_complete_postcard_moment.png
14_dog_noticed_postcard.png
17_ui_hidden_world_visible.png
```

Note:

```text
13_delivery_complete_postcard_moment.png
17_ui_hidden_world_visible.png
```

частично или полностью не отдались через media-read из-за safety layer текущего MCP/tooling. Они существуют в v2 pack и должны быть просмотрены напрямую Art Director / UX из filesystem.

---

## 4. Requirement review

### 4.1 Такса as first driver

R-23 requirement:

```text
A reviewer can tell which dog drives without relying only on top card text.
```

What improved:

- Такса visually associated with route/bicycle lane;
- route card says `Такса + велосипед`;
- world marker shows `водитель`;
- in reward/memory moments, Такса has visible `Удобные тапочки` marker;
- driver role remains consistent across the loop.

Verdict:

```text
PASS
```

Watchpoint:

- still prototype-marker based; final dog silhouette / animation language remains Art Director scope.

### 4.2 Лабрадор as calm helper

R-23 requirement:

```text
A reviewer can tell which dog helps without relying only on top card text.
```

What improved:

- helper marker is visible during production / van-ready states;
- helper state is no longer only hidden in event proof;
- helper/driver separation is clearer than v1.

Verdict:

```text
PASS at prototype level
```

Watchpoint:

- Лабрадор still needs stronger eventual body/action animation readability. Current pass proves role cue, not final personality readability.

### 4.3 Main-strip state cues

Required cues:

```text
route_ready
payload_returned
van_ready_to_dispatch
postcard_available
reward_equipped_or_claimed
next_day_hint_available
```

Observed improvements:

- route marker `маршрут пройден` is visible;
- payload/bicycle/storage relationship is more explicit;
- van-ready screenshot shows clear `фургон готов` cue;
- postcard/board area is visible as world state, not only top card;
- slippers marker is visible near Такса / Dog Card moment;
- next-day hint appears visibly in the world as a gentle note.

Verdict:

```text
PASS
```

### 4.4 Embodied postcard moment

R-23 requirement:

```text
Postcard moment is visible in the world, not only in top card text.
```

Observed improvements:

- postcard board / attention cue appears in the strip;
- postcard is no longer purely a top-card fact;
- next-day note and postcard area form a recognizable post-delivery cluster near the van/board area.

Verdict:

```text
PASS at prototype level
```

Watchpoint:

- this is still a marker/board cue, not a final embodied dog animation. Art Director / UX should decide whether the next pass needs dog approach / dog pause / dog places postcard animation.

### 4.5 Reward / memory visibility

R-23 requirement:

```text
Удобные тапочки are visibly personal to Такса.
```

Observed improvements:

- Dog Card shows:

```text
Такса
Trait: Быстрые лапки
Equip: Удобные тапочки
```

- world marker near Такса shows:

```text
Удобные тапочки
водитель
```

- this makes the reward personal, not generic loot.

Verdict:

```text
PASS
```

D-010 remains intact:

```text
innate trait: Быстрые лапки
equipment: Удобные тапочки
memory: Помнит первую тёплую поставку
```

### 4.6 Next-day hint visibility

R-23 requirement:

```text
A reviewer can identify the next-day hint in visible capture without inspecting JSON.
```

Observed screenshot:

```text
16_next_day_hint.png
```

Visible text:

```text
Завтра можно придумать,
как паковать ещё аккуратнее.
```

Interpretation:

- hint is now visibly present;
- tone is gentle;
- it does not start full House of Curiosity;
- it does not pressure the player;
- it works as a next-day tease.

Verdict:

```text
PASS
```

### 4.7 96px readability preview

Screenshot:

```text
20_readability_preview_96.png
```

Observed:

- coarse anchors remain visible: route/board, storage, kitchen, van/postcard cluster;
- colored markers survive at a glance;
- text is mostly unreadable at this height, which is expected.

Verdict:

```text
PASS for coarse prototype anchors
TEXT readability not accepted at 96px
```

---

## 5. What improved from v1 to v2

### Before v2

R-22 watchpoint:

```text
too much meaning carried by UI text/cards
```

### After v2

The loop now has stronger strip-level cues:

```text
route completed marker
payload/bicycle relationship
helper/driver markers
van ready marker
postcard board / attention cue
slippers world marker
visible next-day hint note
```

The First Day now reads less like pure state machine output and more like a prototype of dog/co-op activity.

---

## 6. Remaining watchpoints

### 6.1 Still prototype markers, not final visual language

The improvements are intentionally lightweight. They are good enough for Game Designer prototype readability, but not final Art Director acceptance.

Remaining Art/UX questions:

- how Такса should read as driver through silhouette/action;
- how Лабрадор should read as calm helper through motion;
- whether markers should remain, become animations, or become object states;
- how postcard board should look in final UI/world;
- how slippers should be visible without becoming visual clutter.

### 6.2 Postcard moment still needs final UX decision

The board/attention marker is an accepted prototype fix. It does not yet prove final emotional timing.

Need later UX/Art decision:

```text
dog approaches postcard
vs dog places postcard
vs both dogs pause near board
vs minimal board sparkle/attention cue
```

### 6.3 96px preview confirms anchors, not text

At 96px, the main world anchors survive, but text does not. This is acceptable for prototype capture, but final desktop companion UI needs explicit readability policy.

### 6.4 Real-speed player feel still untested

v2 is still fast deterministic evidence.

Not accepted yet:

- 1x/2x pacing;
- idle calmness;
- whether markers feel noisy during normal play;
- whether the next-day hint feels like a pleasant tease or tutorial clutter.

---

## 7. R-23 acceptance

R-23 acceptance criteria result:

```text
1. Dog/action readability improved: PASS
2. Main-strip cues improved: PASS
3. Postcard has visible co-op/world gesture: PASS
4. Удобные тапочки visibly personal to Такса: PASS
5. Next-day hint visible and gentle: PASS
6. Existing First Day runtime proof preserved: PASS
7. New v2 capture pack exists: PASS
8. No forbidden scope/tone introduced: PASS
```

Final R-23 verdict:

```text
R-23 First Day UX / Visual Readability Fix Contract v1: PASS
```

---

## 8. Recommended next roadmap step

Next best step:

```text
R-24 — First Day Art Director / UX Review Handoff v1
```

Purpose:

- hand off v2 pack and R-23 review to Art Director / UX;
- decide which prototype cues are acceptable as temporary implementation and which need visual/UX redesign;
- decide whether to do a focused Art/UX Codex pass or a low-speed capture first.

Do not start First Week, full House of Curiosity, second production chain or long-term retention before this Art/UX review is at least scoped.

Recommended handoff output:

```text
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Art_UX_Handoff__First_Day_MVP_v2.md
```

---

## 9. Sources

Capture pack:

```text
docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v2/
```

Key files:

```text
README.md
CAPTURE_MANIFEST_v2.md
captures/screenshots/*.png
captures/video/first_day_mvp_visible_loop_frames/*.png
captures/state/manifest.json
captures/state/final_state.json
captures/state/events.jsonl
captures/state/stress_signals.jsonl
```

Design/runtime sources:

```text
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__First_Day_MVP_v1.md
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__First_Day_UX_Readability_Fix_Requirements_v1.md
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Visible_Review__First_Day_MVP_v1.md
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__First_Day_Visible_Readability_Fix_v1.md
docs/repo/status/CODEX_STATUS.md
```
