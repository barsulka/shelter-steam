# STEAM_DESKTOP — Visible Review — First Day MVP v1

Дата: 2026-07-05
Роль: Game Designer / Systems Designer
Статус: зафиксировано
Roadmap task: R-22 — First Day Visible / Player-Feel Review Pack v1

---

## 0. Контекст

Этот review проверяет persistent visible capture pack после Codex-задачи:

```text
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__First_Day_MVP_Visible_Review_Capture_Pack_v1.md
```

Source capture pack:

```text
docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v1/
```

Этот review не является финальной Art Director приёмкой и не утверждает production art. Проверка ограничена Game Designer / Systems Designer вопросом:

> Достаточно ли текущий visible prototype показывает первый день как тёплый собачий кооператив, а не только как корректную state machine?

---

## 1. Проверенный capture pack

Пакет содержит:

```text
README.md
CAPTURE_MANIFEST_v1.md
captures/screenshots/*.png
captures/video/first_day_mvp_visible_loop_frames/frame_0001.png ... frame_0027.png
captures/logs/capture_run_log.txt
captures/state/manifest.json
captures/state/final_state.json
captures/state/events.jsonl
captures/state/stress_signals.jsonl
```

Структурная проверка:

```text
Screenshots: 20
Frame sequence: 27
Total PNG: 47
State proof: present
first_day_mvp_proof: present
exit_status: success
snapshot_count: 42
events_written: 106
```

State proof подтверждает R-21 runtime acceptance:

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

Capture mode:

```text
visible macOS Godot companion strip
3456 x 224
fast deterministic capture
not normal player-facing timing
```

## 2. Main verdict

```text
R-22 capture pack: PASS
First Day visible readability: PASS with watchpoints
First Day player-feel / calm timing: NOT ACCEPTED YET
Art Director final visual acceptance: PENDING
```

Текущий visible prototype уже достаточно показывает общий First Day loop и даёт материал для review. Но он ещё не доказывает, что первый день ощущается как тёплая игра: слишком много смысла несёт UI text, а не сами собаки/действия.

---

## 3. Reviewed screenshots

Просмотрены через MCP / media read:

```text
02_initial_strip_player_prototype.png
05_bicycle_return_payload.png
12_van_ready_confirm_delivery.png
13_delivery_complete_postcard_moment.png
15_dog_card_memory_slippers.png
16_next_day_hint.png
```

Также подтверждено наличие остальных named screenshots and frame sequence through README / CAPTURE_MANIFEST / directory structure.

Note:

```text
17_ui_hidden_world_visible.png
20_readability_preview_96.png
```

существуют в пакете по manifest, но media-read через текущий MCP был заблокирован safety layer. Поэтому в этом review по ним нет полного визуального verdict; они остаются для ручного/Art Director просмотра напрямую из filesystem.

---

## 4. Beat review

### Beat 1 — Initial strip / first workday

Screenshot:

```text
02_initial_strip_player_prototype.png
```

Что работает:

- main strip читается слева направо;
- видны основные anchors: Road Sign, Basket Bicycle, Storage, Kitchen, Packing Table, Delivery Van;
- compact top cards объясняют стартовую цель;
- player-prototype mode снижает debug dominance по сравнению с QA labels-on.

Watchpoints:

- Такса/Лабрадор как личности пока почти полностью объясняются UI text, не силуэтом и не поведением;
- placeholder dog/action shapes всё ещё похожи на semantic blocks;
- без карточек игроку трудно понять, кто именно что делает и почему.

Verdict:

```text
PASS with readability watchpoints
```

### Beat 2 — Route / payload return

Screenshot:

```text
05_bicycle_return_payload.png
```

Что работает:

- есть явная смена состояния после route: bicycle/payload появляется в strip;
- payload не телепортируется сразу в Storage;
- D-013 direction сохранён: ресурсы приходят через off-screen trip and visible return.

Watchpoints:

- dog / bicycle / payload / action marker separation can be ambiguous without labels;
- driver dog identity слабая визуально;
- route departure/return нуждается в более ясном dog-owned animation language later.

Verdict:

```text
PASS with visual clarity watchpoints
```

### Beat 3 — Production chain / dog-owned work

Reviewed through screenshots and frame sequence manifest:

```text
06_unload_to_storage.png
07_storage_to_kitchen_carry.png
08_kitchen_food_mix.png
09_food_mix_to_packing_table.png
10_packing_table_food_bag.png
11_food_bag_to_van.png
```

Что работает:

- chain states are represented as physical places;
- Food Mix and Food Bag are separate concepts;
- Packing Table reads as a work surface / utility prop, not a building;
- runtime proof and event log now back visible dog-owned actions.

Watchpoints:

- on screenshots, many dog actions still rely on action badges / semantic placeholders;
- resource icons are readable as different tokens but not yet emotionally warm;
- production still risks reading as “labeled prototype machinery” until dog animation/silhouette improves.

Verdict:

```text
PASS for prototype-level visible chain
not yet final player readability
```

### Beat 4 — Dispatch confirmation

Screenshot:

```text
12_van_ready_confirm_delivery.png
```

Что работает:

- van endpoint state is visible;
- dispatch gate concept is understandable;
- player confirmation remains calm, not guilt-driven.

Watchpoints:

- confirmation still appears mostly as UI/card state;
- dogs waiting near the van / co-op readiness are not yet visually expressive enough;
- player-facing wording and button hierarchy should get UX review before player test.

Verdict:

```text
PASS with UX follow-up
```

### Beat 5 — Postcard / reward / memory / next-day hint

Screenshots:

```text
13_delivery_complete_postcard_moment.png
14_dog_noticed_postcard.png
15_dog_card_memory_slippers.png
16_next_day_hint.png
```

Что работает:

- postcard card is visible and gentle;
- no guilt pressure detected in the shown text;
- first reward `Удобные тапочки` is clear in UI;
- Dog Card text separates innate trait from equipment;
- completion state is understandable through UI.

Strong point:

```text
“Спасибо за первую поставку. Кооператив только начинает путь, но уже сделал доброе дело.”
```

This is aligned with Shelter tone: warm, calm, no manipulation.

Watchpoints:

- dog noticing postcard is not visually strong enough; the moment reads mostly as a UI card;
- slippers are text-visible, but not yet visually meaningful on the dog;
- Dog Card proves D-010 textually, not visually;
- `next_day_hint_available` exists in state proof, but visible screenshot does not clearly show the intended next-day hint as a distinct player-facing moment;
- postcard/reward closure should become a small dog/co-op life moment, not only a card plus button.

Verdict:

```text
PASS for prototype-level emotional closure evidence
NEEDS focused UX/visual readability pass before calling it player-feel accepted
```

---

## 5. Stress-test interpretation

### Excel Test

Visible capture is better than JSON-only because the player can see places and movement. Still, many meanings are carried by UI labels and cards.

Verdict:

```text
PASS with watchpoint
```

### Factory Test

The loop has dogs, route, postcard, reward and memory. However, dog individuality is not yet strong enough visually.

Verdict:

```text
PASS with dog-identity watchpoint
```

### Dog Test

Runtime dog identity is correct. Visible dog identity is still weak.

Verdict:

```text
PASS in state, WATCH visually
```

### Warmth Test

Postcard tone is warm. Reward/memory direction is warm. But warmth is still mostly textual.

Verdict:

```text
PASS with visual/emotional execution watchpoint
```

### Idle / Desktop Calmness Test

Not validated because capture is fast deterministic, not a real-time / low-speed player-feel session.

Verdict:

```text
NOT TESTED
```

---

## 6. What is accepted now

Accepted at R-22 level:

- capture pack exists and is usable;
- screenshots and frame sequence exist;
- pack is tied to current First Day MVP runtime proof;
- general left-to-right production flow is visible;
- postcard/reward direction is gentle and aligned with Shelter tone;
- no forbidden mechanics or tone detected in visible capture;
- enough evidence exists to plan a focused UX/visual fix pass.

---

## 7. What is not accepted yet

Not accepted yet:

- final visual readability;
- final Art Director acceptance;
- real-speed calm desktop feel;
- dog/action animation warmth;
- player-facing UI layout;
- final Dog Card UX;
- final postcard/reward UX;
- final next-day hint UX.

---

## 8. Required follow-ups

### Priority 1 — Make dogs/actions less dependent on UI text

Need clearer visible dog identity/action language:

- Такса as driver should read as driver without relying only on Dog Card;
- Лабрадор as helper should read as helper;
- carried resources should be easier to distinguish from dog/action blocks;
- dog action moments should be readable in motion and still frames.

### Priority 2 — Make postcard moment more embodied

Current postcard closure is calm and good, but card-centric.

Need one visible dog/co-op gesture:

```text
dog approaches postcard
or dog brings postcard to board
or both dogs pause near postcard/van
or small non-final placeholder animation indicates shared attention
```

No complex cutscene required.

### Priority 3 — Make next-day hint visible and gentle

State proof contains next-day hint, but visible screenshot does not clearly expose it.

Need player-facing hint moment that is:

- visible;
- optional / gentle;
- not tutorial pressure;
- tied to “tomorrow / паковать аккуратнее / House of Curiosity tease”;
- not a full research unlock.

### Priority 4 — Reduce over-reliance on top UI cards

The UI is useful, but the strip should still communicate the broad state.

Need improved main-strip state cues for:

- route ready;
- payload returned;
- van ready;
- postcard available;
- reward equipped.

### Priority 5 — Real-speed / low-speed capture later

Before any player-feel claim, capture a 1x/2x or otherwise explicitly low-speed run.

Current fast capture validates visual states, not timing comfort.

---

## 9. R-22 verdict

```text
R-22 First Day Visible / Player-Feel Review Pack v1: PASS with watchpoints
```

Reason:

- Codex created the required persistent visible capture pack.
- Capture is tied to accepted runtime proof.
- First Day loop is visible enough to review.
- Major product direction holds.
- Watchpoints are focused and actionable.

R-22 should be considered closed at evidence/review level, but player-feel and final visual acceptance remain open.

---

## 10. Recommended next roadmap step

Next best step:

```text
R-23 — First Day UX / Visual Readability Fix Contract v1
```

Goal:

- define a focused fix pass before expanding to First Week, House of Curiosity, second chain, economy or long-term retention.

R-23 should produce either:

```text
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__First_Day_UX_Readability_Fix_Requirements_v1.md
```

or a Codex brief if scope is already obvious:

```text
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__First_Day_Visible_Readability_Fix_v1.md
```

Recommended order:

```text
UX/readability fix contract
-> Codex focused visible fix pass
-> new visible capture
-> Art Director / UX review
-> only then First Week / House of Curiosity expansion
```

---

## 11. Sources

Capture pack:

```text
docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v1/
```

Key files:

```text
README.md
CAPTURE_MANIFEST_v1.md
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
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Runtime_Review__First_Day_MVP_Runtime_Polish_v1.md
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__First_Day_MVP_Visible_Review_Capture_Pack_v1.md
docs/repo/status/CODEX_STATUS.md
```
