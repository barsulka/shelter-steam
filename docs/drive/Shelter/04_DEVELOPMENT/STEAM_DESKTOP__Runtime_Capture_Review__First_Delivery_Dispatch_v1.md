# STEAM_DESKTOP — Runtime Capture Review — First Delivery Dispatch v1

Дата: 2026-07-05
Роль: Game Designer / Systems Designer
Статус: зафиксировано

## 0. Контекст

Этот документ закрывает roadmap step R-19: snapshot-based design review по полному runtime capture первой тёплой поставки.

Проверяем не визуальную приёмку и не player feel. Проверяем live Godot state, causality, event density, dog/system evidence и готовность переходить к `First Day MVP v1`.

Источник runtime truth:

```text
steam/.runtime/workbench_capture_runs/first_delivery_with_dispatch_confirmation_mcp_check_v0/
```

Важно: `.runtime` — ignored local evidence, не production data и не player telemetry.

## 1. Проверенный run

Параметры:

```text
run_id: first_delivery_with_dispatch_confirmation_mcp_check_v0
scenario: first_delivery_with_dispatch_confirmation
fixture: first_day_empty_coop
game_seconds: 420
sample_every_game_seconds: 10
speed: 100
snapshot_count: 42
events_written: 79
stress_signal_sample_count: 42
exit_status: success
```

Harness дошёл до `ready_to_dispatch` на sample `20`, затем выполнил accepted dev-only action:

```text
runtime.delivery.confirm
```

Manifest proof:

```text
order.delivery_confirmed: true
order.postcard_visible: true
order.reward_available: true
game.chain_complete: true
production_chain.state: completed
production_chain.completed: true
event.player_confirmed_delivery: true
event.postcard_created: true
event.reward_created: true
```

## 2. High-level verdict

```text
Workbench capture workflow: PASS
First Delivery full runtime loop: PASS
First Day MVP readiness: PASS with design follow-ups
Visual / feel / warmth acceptance: NOT TESTED by this run
```

Первый production loop технически доказан полностью: от маршрута до доставки, открытки, награды и завершения цепочки.

Но как первый день игры run пока показывает скорее “правильную техническую цепочку”, чем полноценный момент жизни кооператива. Для First Day MVP нужна более явная эмоциональная и собачья развязка после доставки.

## 3. Подтверждённая цепочка

Runtime events подтверждают полный flow:

```text
fixture loaded
-> speed set to 100x
-> player confirmed trip
-> trip task created
-> transport left strip
-> trip timer started / complete
-> transport returned
-> payload visible
-> unload tasks created
-> resources added to storage
-> carry tasks to kitchen
-> resources delivered to kitchen
-> kitchen inputs ready
-> cook task created
-> food mix created
-> carry tasks to packing table
-> resources delivered to packing table
-> packing inputs ready
-> pack task created
-> food bag created
-> load van task created
-> van loaded
-> player confirmed delivery
-> delivery task created
-> delivery complete
-> postcard created
-> reward created
-> reward equipped
```

Это соответствует принятому направлению: производство не является мгновенным inventory conversion. Есть route, transport, unload, carry, stations, packing, dispatch и player confirmation.

## 4. What works

### 4.1 Production core доказан

Главный скелет Steam/Desktop работает:

```text
route -> materials -> kitchen -> packing -> delivery -> thanks/reward
```

Это уже не просто “склад стал богаче”. Цепочка создаёт физически объяснимую поставку.

### 4.2 Player agency присутствует в правильных местах

В run есть две точки подтверждения игроком:

```text
player_confirmed_trip
player_confirmed_delivery
```

Это хороший базовый паттерн для First Day: игрок не микроменеджит каждую лапу, но подтверждает намерение и отправку.

### 4.3 Dog identity поля есть

В финальном state у собак есть:

```text
identity
innate_traits
character_traits
preferences
activity_experience
equipment
helper_effects
learned_habits
current_activity
movement_state
```

Это поддерживает D-010: собака не только worker unit, а персонаж с врождённым слоем, опытом, привычками и экипировкой.

### 4.4 Первый reward работает как личное изменение

У Таксы после run:

```text
equipment: Удобные тапочки
helper_effects: Удобные тапочки
learned_habits: Помнит первую тёплую поставку
```

Это правильное направление для First Day MVP: награда должна быть не просто ресурсом, а маленьким изменением жизни собаки.

### 4.5 Stress signals не показывают spreadsheet/factory failure

Финальные stress signals:

```text
blocked_states_recent: 0
chains_with_invisible_conversion: 0
dogs_without_identity_fields: 0
dog_action_events_recent: 4
production_events_recent: 55
raw_inventory_growth_recent: 4
room_activity_events_recent: 0
rooms_visible_to_workbench: 9
story_events_recent: 3
```

Положительное:

- invisible conversion не обнаружен;
- dog identity присутствует;
- blocked noise отсутствует;
- story events появляются после доставки;
- rooms visible to workbench уже есть.

## 5. Watchpoints

### 5.1 Event log слишком технический для designer-facing review

Проблема: event stream всё ещё засорён событиями вида:

```text
debug_time_advanced:0.10
```

Они часто имеют tag `production_chain`, хотя для Game Designer review это debug tick, а не событие мира.

Риск: дизайнерский анализ будет считать техническое продвижение времени production activity.

Нужно в следующем Codex slice:

- вынести debug tick в `debug` tag;
- или исключить debug tick из `events.jsonl` by default;
- или писать его в отдельный stream.

### 5.2 Dog-action evidence слабее production evidence

Финал:

```text
dog_action_events_recent: 4
production_events_recent: 55
```

С точки зрения машинного proof это нормально. С точки зрения Shelter это watchpoint: производство видно лучше, чем собачья жизнь и собачьи действия.

Нужно усилить semantic dog events:

```text
dog picked up resource
dog carried resource
dog arrived at station
dog started mixing
dog packed bag
dog loaded van
dog noticed postcard
dog reacted to reward
```

### 5.3 Post-delivery life moment пока слишком тонкий

Есть:

```text
postcard_created
reward_created
reward_equipped
```

Но нет отдельного runtime evidence, что собаки прожили момент благодарности:

```text
dog reads/sniffs postcard
dog brings postcard to board
dog celebrates quietly
dog tries on slippers
dog remembers first delivery
another dog reacts/supports
```

Для First Day MVP это критично: первый день должен закончиться не только `chain_complete=true`, а маленьким тёплым событием.

### 5.4 House of Curiosity присутствует, но не участвует

В state House of Curiosity и комнаты видны, но в этом scenario:

```text
active_research: null
assigned_dogs: []
progress: 0.0
room_activity_events_recent: 0
```

Для First Delivery это нормально. Для First Day MVP нужно решить, появляется ли Дом любопытства в первый день или остаётся tease/unlock на следующий шаг.

### 5.5 Legacy compatibility state имеет расхождение

Основной `production_chains[chain.warm_food_delivery_intro].state` завершён:

```text
completed
```

Но legacy list `production_chain` всё ещё показывает:

```text
unload_to_storage: in_progress
```

Это не ломает основной proof, но может путать review tools и будущие checks. Нужен cleanup legacy compatibility view или явное правило: дизайнерские проверки смотрят на `production_chains`, не на legacy `production_chain`.

### 5.6 Physical inventory после delivery выглядит неоднозначно

В финале `delivery_van_endpoint` всё ещё содержит:

```text
food_bag: 1
```

При этом order уже delivered/reward_claimed. Для прототипа допустимо, но для First Day MVP нужно решить semantic state food bag после dispatch:

- остаётся как visible “loaded/delivered marker”;
- исчезает как sent item;
- превращается в delivery receipt / empty spot / dispatched state.

Сейчас это может выглядеть как “мешок доставлен, но всё ещё лежит в фургоне”.

## 6. Design interpretation

### 6.1 Что доказано

Доказано, что минимальный первый loop может быть таким:

```text
Игрок подтверждает первую поездку.
Такса едет на овсяную ферму.
Кооператив получает ящики.
Собаки разгружают и переносят ресурсы.
Лабрадор помогает на кухне/упаковке.
Игрок подтверждает отправку.
Приходит открытка и маленькая награда.
Такса получает тапочки и память первой поставки.
```

Это достаточно крепкий каркас для First Day MVP.

### 6.2 Что пока не доказано

Не доказано:

- что player-facing pacing будет спокойным и тёплым на 1x/2x;
- что визуально читаются собаки, ресурсы и станции;
- что игрок эмоционально понимает postcard/reward;
- что первый день создаёт желание вернуться;
- что House of Curiosity нужен в первый день, а не после него.

Эти вопросы не должны блокировать R-20, но должны быть явно отражены в First Day MVP contract.

## 7. First Day MVP implications

### 7.1 First Day должен иметь не только chain completion, но и emotional completion

Техническое завершение:

```text
game.chain_complete = true
```

Недостаточно как финал первого дня.

Для First Day MVP нужен финал:

```text
postcard read/placed
small gratitude moment
one dog receives personal memory/equipment
co-op gets a new reason to continue tomorrow
```

### 7.2 Первый reward должен быть личным, не абстрактным

`Удобные тапочки` — хороший proof direction. В MVP нужно закрепить, что первая награда:

- привязана к конкретной собаке;
- не стирает innate trait;
- слегка усиливает роль;
- даёт визуальный/эмоциональный повод наблюдать;
- объясняется благодарностью, а не loot chest.

### 7.3 Первый bottleneck должен быть мягким и физическим

Текущий flow не показывает осознанный bottleneck для игрока. Для First Day MVP нужен один мягкий bottleneck, например:

```text
слишком далеко носить руками/лапами
не хватает аккуратной упаковки
нужно дождаться подтверждения отправки
надо понять, кто лучше повезёт первую поставку
```

Bottleneck должен объяснять, зачем игрок заботится о кооперативе, а не просто ждёт таймер.

### 7.4 Дом любопытства лучше сделать post-delivery tease, а не полноценную систему первого loop

По текущему runtime House of Curiosity уже есть как scaffold, но не участвует. Для First Day MVP лучше использовать его аккуратно:

- после первой открытки появляется hint/tease;
- Такса “помнит первую тёплую поставку”;
- Лабрадор может предложить “надо научиться паковать ровнее”;
- полноценный research start может быть вторым шагом, не обязательной частью первой поставки.

Так мы не превращаем первый день в перегруженный tutorial.

## 8. R-19 verdict

```text
R-19 Snapshot-Based Design Review Pack v1: PASS
```

Причина:

- bundle читается через Shelter MCP;
- full first delivery path доказан;
- stress signals достаточны для designer review;
- найден понятный набор follow-ups для First Day MVP;
- можно переходить к R-20.

## 9. Recommended next step — R-20

Создать:

```text
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__First_Day_MVP_v1.md
```

R-20 должен зафиксировать:

- first day player fantasy;
- first 2 dogs and their roles;
- first route and first delivery;
- first player actions;
- first dog-owned visible actions;
- first postcard / gratitude moment;
- first personal reward / memory;
- first soft bottleneck;
- what is in MVP vs explicitly out of MVP;
- what Codex should implement next in R-21.

## 10. Candidate R-21 implementation brief after R-20

Не писать Codex brief до R-20. Но вероятный implementation slice:

```text
First Day MVP Runtime Polish v1
```

Likely scope:

- clean debug event noise;
- add high-level dog action events;
- add post-delivery dog/life moment;
- resolve food_bag delivered/visible semantic;
- fix legacy production_chain mismatch;
- optionally add first-day postcard/reward state fields for designer review.

## 11. Sources

Runtime evidence:

```text
steam/.runtime/workbench_capture_runs/first_delivery_with_dispatch_confirmation_mcp_check_v0/manifest.json
steam/.runtime/workbench_capture_runs/first_delivery_with_dispatch_confirmation_mcp_check_v0/events.jsonl
steam/.runtime/workbench_capture_runs/first_delivery_with_dispatch_confirmation_mcp_check_v0/stress_signals.jsonl
steam/.runtime/workbench_capture_runs/first_delivery_with_dispatch_confirmation_mcp_check_v0/final_state.json
steam/.runtime/workbench_capture_runs/first_delivery_with_dispatch_confirmation_mcp_check_v0/run.log
```

Project context:

```text
PROJECTS_RULES.md
AGENTS.md
README.md
docs/repo/status/CODEX_STATUS.md
docs/drive/Shelter/00_START_HERE/01_CURRENT_STATUS.md
docs/drive/Shelter/00_START_HERE/02_DECISIONS.md
docs/drive/Shelter/00_START_HERE/03_PROJECT_PHILOSOPHY.md
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Game_Design_Roadmap_v2.md
```
