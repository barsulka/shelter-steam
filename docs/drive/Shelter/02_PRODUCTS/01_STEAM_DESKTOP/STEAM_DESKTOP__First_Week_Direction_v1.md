# STEAM_DESKTOP — First Week Direction v1

Дата: 2026-07-06
Обновлено: 2026-07-12
Роль документа: Game Design / Product Direction
Статус: accepted direction v1 / D-022 Day 2 proof + D-023 player-journey synchronization
Продукт: Steam/Desktop idle always-on-top strip
Roadmap task: R-27 — First Week / Long-Term Loop Direction
Роль-владелец: Game Designer / Systems Designer

---

## 0. Назначение

Этот документ определяет направление Day 2 / First Week после зафиксированного First Day MVP lock.

Принятая executable-граница 2026-07-11:

```text
Day 2 Return + одна полностью завершаемая вариация существующей Warm Food Delivery.
Та же route.oat_farm_intro, та же resource family, Basket Bicycle и те же станции.
Fixture/capture доказывает continuity; production save/calendar в scope не входит.
```

Источник R-25:

```text
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__First_Day_MVP_Lock_And_Next_Scope_Decision_v1.md
```

R-25 выбрал следующий scope:

```text
A — First Week / longer retention
```

Главный вопрос:

> Зачем игрок возвращается в следующую сессию после первой тёплой поставки?

---

## 1. Core thesis

```text
Day 2 should not add a big new system immediately.
Day 2 should show that the previous session mattered.
```

Первый день доказал:

```text
кооператив может сделать тёплую поставку
собаки могут работать как персонажи
игрок может получить благодарность
у собаки может появиться личная память и мягкая награда
```

Вторая сессия должна показать:

```text
это не одноразовый tutorial — мир запомнил доброе дело, а собаки чуть-чуть изменились
```

---

## 2. First Week product promise

First Week должен дать игроку простое ощущение:

> “Мой маленький собачий кооператив начинает жить. Прошлая поставка оставила след, в этот раз собаки делают что-то чуть лучше, и у меня появляется спокойная причина заглянуть снова.”

Ключевые ощущения:

- прошлый визит имел значение;
- собаки помнят и меняются мягко;
- кооператив растёт через заботу, не через давление;
- новые цели понятны без spreadsheet overwhelm;
- игрок возвращается из любопытства и тепла, а не из страха потерять награду.

---

## 3. First Week scope shape

First Week — это не календарная неделя с семью полностью разными днями.

Для текущего design slice First Week означает:

```text
Day 2 + first repeatable direction + first longer-retention promise
```

То есть нужно спроектировать:

1. Первый return moment.
2. Первый повтор после успешной поставки.
3. Первую небольшую вариацию заказа.
4. Первую мягкую improvement opportunity.
5. Первый момент, где память/награда собаки влияет на поведение.
6. Первую границу активации House of Curiosity.
7. Первый намёк на дальнейшую неделю без открытия больших систем.

---

## 4. Day 2 opening

### 4.1 Player-facing start

Когда игрок возвращается после First Day:

```text
postcard remains on board
Такса has slippers visible
Dog Card still shows first memory
packing note remains near packing area
Лабрадор is near packing / kitchen area
new calm order card is available
```

Player fantasy:

> “Они помнят прошлый раз. В этот раз можно сделать следующую поставку чуть аккуратнее.”

### 4.2 What changed since the previous visit

Required visible changes:

- открытка не исчезла;
- тапочки остались у Таксы;
- `Помнит первую тёплую поставку` remains inspectable;
- появилась заметка / мысль о более аккуратной упаковке;
- второй заказ feels related to the previous session, not random.

### 4.3 What must NOT happen immediately

Day 2 should not begin with:

- many new systems;
- urgent alerts;
- new dog recruitment;
- full research tree;
- multiple queues;
- monetization or donation ask;
- guilt pressure;
- “come back daily or lose reward”.

---

## 5. Day 2 loop direction

Recommended Day 2 loop:

```text
return to co-op
-> notice the previous-session memory
-> notice the offered second warm delivery variation
-> confirm the familiar route; this begins the offered order
-> dogs repeat familiar production flow
-> one step is slightly more careful / personal
-> receive a second gentle response or progress note
-> House of Curiosity becomes an optional question, not a full system
```

### 5.1 Second order direction

Accepted Day 2 title:

```text
Аккуратная тёплая поставка
```

Purpose:

- reuse First Day loop;
- show that repetition is not empty;
- introduce a gentle improvement axis: packing quality / care / neatness;
- create a reason for House of Curiosity later.

Do not make it a hard difficulty spike.

### 5.2 Difference from first order

First order:

```text
Can the co-op make and send a warm food bag?
```

Second order:

```text
Can the co-op make the same kind of help a little more carefully?
```

Suggested difference:

- same route or same resource base;
- same production stations;
- slightly more visible attention at Packing Table;
- Лабрадор’s helper role matters more;
- Такса’s slippers make travel/return feel a little more confident, but not numerically dominant.

---

## 6. First repeatable loop

The first repeatable loop should be:

```text
Warm Delivery Loop
```

Loop skeleton:

```text
notice offered calm order
-> confirm route; there is no separate order-accept action
-> dog returns with payload
-> unload/carry/cook/pack/load
-> confirm dispatch
-> receive gratitude/progress note
-> dog/co-op memory or small improvement opportunity appears
```

### 6.1 What repeats

- route confirmation;
- visible resource return;
- dog-owned production chain;
- player dispatch confirmation;
- gratitude/response.

### 6.2 What changes

- dog memory affects small behavior/cue;
- order phrasing changes;
- packing note/hint evolves;
- one dog can become better associated with a role;
- new improvement opportunity becomes visible.

### 6.3 What must not repeat as grind

Avoid:

```text
same task, same text, same reward, no dog change
```

Repetition should feel like:

```text
same caring routine, slightly richer life
```

---

## 7. Dog memory and behavior follow-up

### 7.1 Такса

Existing memory/reward:

```text
Memory: Помнит первую тёплую поставку
Equipment: Удобные тапочки
```

Day 2 behavior implication:

- Такса starts closer to the bicycle or route edge;
- route-prep animation/cue can be slightly more confident;
- player can see slippers on paws / marker;
- no hard speed/min-max requirement yet.

Accepted meaning:

```text
Такса remembers being the first driver and feels ready to help again.
```

### 7.2 Лабрадор

Existing role:

```text
calm helper / careful packing support
```

Day 2 behavior implication:

- Лабрадор pays more attention to Packing Table;
- helper cue can focus on neatness/care;
- possible future habit is foreshadowed:

```text
Ровный узелок
```

But Day 2 should not fully unlock complex habit mechanics unless explicitly scoped later.

Accepted meaning:

```text
Лабрадор notices how to make help more careful, not more profitable.
```

---

## 8. First soft choice

First Week direction может содержать будущий soft focus, но принятый Day 2 executable slice не создаёт active soft-choice state или branching system.

Recommended soft choice:

```text
What should the co-op pay attention to next?
```

Принятая Day 2 presentation после завершения второй поставки:

```text
Existing Packing Table note cue changes to the optional question: “Как паковать мягче?”
Игрок может открыть/заметить её, но не обязан выбирать ветку, запускать research или получать habit unlock.
```

Possible choices for later, not necessarily Day 2 implementation:

1. Pack more neatly.
2. Carry more calmly.
3. Prepare route earlier.

For current First Week direction, keep only the first as a future promise:

```text
Pack more neatly.
```

Reason:

- it follows from First Day hint;
- it belongs to Лабрадор;
- it improves warmth/care, not profit pressure;
- it does not require a new resource economy.

---

## 9. House of Curiosity boundary

House of Curiosity should move from tease to **first gentle question**, not full system.

### 9.1 Day 2 allowed state

Allowed:

```text
question appears only after the second delivery completes
question remains an optional physical hint
state says curiosity_question_available=true
state says curiosity_is_optional_hint=true
```

Example:

```text
Как паковать мягче?
```

### 9.2 Day 2 not allowed yet

Not allowed in this scope:

- full research tree;
- multiple research branches;
- research timers;
- assignment UI with several dogs;
- laboratory/classroom/library loop;
- upgrade economy;
- fail/success pressure.

### 9.3 First activation thesis

Recommended thesis:

```text
House of Curiosity starts as a board of questions born from dog experiences.
It should feel like “the dogs noticed something”, not like a tech tree menu.
```

---

## 10. First Week progression arc

First Week should be designed as a small emotional arc, not a grind calendar.

### Day 1

```text
First warm delivery.
Postcard.
Такса gets slippers and first memory.
Packing note appears.
```

### Day 2

```text
The previous session remains visible.
Second warm delivery variation completes end to end on the existing chain.
Лабрадор gives one readable careful-packing cue inside the existing PackTask.
A small progress note closes the delivery; no second full postcard/reward cadence is created.
Only then curiosity question appears: “Как паковать мягче?”
```

### Day 3 candidate

```text
First tiny improvement/habit proof.
Packing step gains a clearer careful-packing cue.
Maybe first named helper habit appears, but only if needed.
```

### Day 4–5 candidate

```text
A second order type or non-food comfort delivery can be teased.
No need to implement yet.
```

### End of First Week candidate

```text
Co-op board has several warm notes.
Dogs have small personal traces.
Player understands: this is a place that grows through routines and care.
```

---

## 11. Accepted Day 2 second order

Accepted order:

```text
order.second_warm_delivery_careful_pack
```

Player-facing name:

```text
Аккуратная тёплая поставка
```

Player-facing text:

```text
В прошлый раз всё получилось. В этот раз можно собрать ещё один тёплый мешочек — чуть аккуратнее.
```

Tone constraints:

- no urgency;
- no failure framing;
- no “someone suffers if you do not act”; 
- no monetization;
- no daily streak pressure.

Accepted completion output:

```text
small progress note, not a second full postcard/reward
packing care question becomes available only after completion
no Labrador memory/reward/habit/power unlock in this slice
```

---

## 12. Candidate first habit / improvement

Candidate future habit:

```text
Ровный узелок
```

Owner:

```text
Лабрадор
```

Meaning:

```text
Лабрадор научился завязывать мешочек аккуратнее после нескольких тёплых поставок.
```

Important:

- not required to unlock immediately on Day 2;
- should emerge from repeated caring action;
- should not be random loot;
- should not be paid;
- should not create rarity tiers;
- should not override innate trait.

Not in the accepted Day 2 executable slice:

```text
habit_opportunity.visible: true
habit_unlocked: true
numeric packing bonus
```

`Ровный узелок` остаётся future-only до отдельного product/game decision.

---

## 13. First Week economy direction

Economy should stay very small.

Allowed in First Week direction:

- repeat same resource family;
- show small difference in quality/care;
- show order variation;
- show gratitude/progress note;
- show dog memory/habit opportunity.

Not yet:

- multiple currencies;
- price optimization;
- supply/demand;
- large storage balancing;
- automation upgrades;
- premium acceleration;
- stochastic reward system.

First Week economy thesis:

```text
The economy grows through meaningful routines and visible care, not through bigger numbers.
```

---

## 14. Accepted Day 2 fixture / runtime semantics

This section keeps the bounded product/game meaning. Exact canonical fields, chain-state inventory and event signatures live in `STEAM_DESKTOP__Task_Flow_Contract_v1.md`, `STEAM_DESKTOP__Object_Contract_v1.md` and the canonical Codex brief.

Accepted ids:

```text
scenario: second_warm_delivery_after_first_day
fixture: second_day_after_first_delivery
order: order.second_warm_delivery_careful_pack
chain template: chain.warm_food_delivery_intro
chain run: run.day2.second_warm_delivery
```

Required semantics:

1. Completed First Day facts remain immutable history; one fresh Day 2 order/chain is the only active execution state. Legacy flags may project active state one way but cannot replace history.
2. Fixture Storage starts with static existing stock `Protein Packet x1` and `Packaging Bag x1`, with no Oat/Pumpkin/Food Mix/Food Bag or pre-created cargo. Under D-023 this exact state is the dev/regression projection of the persisted remainder from the fresh First Day `x2/x2` reserve; the fixture itself still proves no replenishment, economy, route reward, save or calendar behavior.
3. Day 2 order status is exact:

```text
offered -> route_suggested -> missing_resources -> resources_available
-> production_in_progress -> packed -> loaded -> sent -> completed
```

4. `sent` follows player confirmation / DeliveryTask creation and reveals no feedback. `completed` follows only order-tagged `delivery_complete`.
5. Every task/capture event in the Day 2 chain carries the second order id; First Day regression remains tagged with `order.first_warm_delivery`.
6. The existing Day 2 PackTask is deterministically assigned to Labrador; the careful-packing cue exists only during PackTask `in_progress` and creates no second task/system/bonus.
7. Active Order owns the non-reward response: the existing Van-side postcard-board cue renders the small progress note, then the existing Packing Table note cue renders `Как паковать мягче?`.
8. Day 2 creates no Postcard Card, reward or EquipItemTask; First Day postcard/slippers/equip behavior remains unchanged.
9. D-022 fixture proof ends with the completed Day 2 order/chain and `quiet_end_state_reached`. Under D-023 the ordinary player journey then archives that completed result into immutable history, clears active-order/active-chain slots and enters Quiet Cooperative with only existing non-progression IdleTask behavior.

Required proof remains:

```text
day2.return_moment_seen: true
day2.yesterday_postcard_visible: true
day2.dachshund_slippers_visible: true
day2.dachshund_memory_inspectable: true
day2.packing_note_visible: true
day2.second_order_available: true
day2.return_has_no_urgent_prompt: true
day2.absence_penalty_applied: false
day2.labrador_packing_care_moment_seen: true
day2.second_delivery_completed: true
day2.second_feedback_visible: true
day2.curiosity_question_available: true
day2.curiosity_is_optional_hint: true
day2.quiet_end_state_reached: true
```

Completion is mandatory. Availability-only proves the return tableau but not the first repeatable direction or emotional closure.

---

## 15. Canonical next Codex implementation slice

Do not implement from this document directly. Use the accepted separate Codex brief below as the implementation source.

Canonical brief:

```text
STEAM_DESKTOP__Codex_Brief__Day_2_Return_And_Second_Warm_Delivery_v1.md
```

Recommended reasoning level:

```text
очень высокий
```

Reason:

The task touches progression meaning, Day 2 state, curiosity boundary, dog memory behavior, new fixture/scenario and runtime proof. Codex must not expand into full First Week, full House of Curiosity, economy complexity or new art direction.

Accepted implementation scope:

- create `second_day_after_first_delivery` fixture;
- create `second_warm_delivery_after_first_day` workbench scenario;
- preserve First Day loop;
- show return moment state;
- offer and fully complete the second order;
- show the previous-session postcard still present;
- show Dachshund slippers separately visible/equipped;
- show the First Day memory separately inspectable in Dog Card;
- reuse `route.oat_farm_intro`, Basket Bicycle, the existing resource family and stations;
- preserve visible payload -> unload -> carry -> Kitchen/Food Mix -> Packing Table/Food Bag -> LoadVan causality;
- show one Labrador careful-packing cue only inside the existing PackTask;
- require visible Van load and player-confirmed DeliveryTask before completion;
- show a small progress note, then the optional curiosity question;
- create runtime capture/proof at return, packing, van-ready, confirmed delivery and quiet post-completion.
- provide machine-readable state/event assertions plus native 1x scenario captures at those proof points; 216/144/96 are scale/readability review rubrics, not three additional mandatory scenario runs, and existing supported 2x review remains optional.

---

## 16. Out of scope for next implementation slice

Do not add:

- production persistence/save migration;
- real-world clock, day rollover or calendar;
- new dog recruitment;
- new route family;
- new resource family, station, recipe or production/comfort chain;
- many orders;
- active soft-choice state;
- full research tree;
- active laboratory/classroom/library loop;
- complex habit tree;
- mood/energy penalties;
- daily streaks;
- timed failure;
- monetization;
- charity prompts;
- Browser Extension mechanics;
- production art pass;
- production dog rig/tool/schema decision;
- window semantics or desktop-platform/release integration;
- Steam platform integration.

---

## 17. R-27 acceptance criteria

R-27 direction is accepted when:

1. First Week is defined as Day 2 + first repeatable direction + first longer-retention promise.
2. Day 2 opening is defined.
3. Second order direction is defined.
4. Memory/reward follow-up is defined.
5. House of Curiosity boundary is defined.
6. First habit/improvement opportunity is defined as optional/future-safe.
7. Next Codex brief direction can be derived without inventing product decisions.

Status: **accepted direction v1; Day 2 executable scope locked 2026-07-11**.

---

## 18. Sources

```text
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__First_Day_MVP_Lock_And_Next_Scope_Decision_v1.md
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__First_Day_MVP_v1.md
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Runtime_Review__First_Day_MVP_Runtime_Polish_v1.md
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Visible_Review__First_Day_MVP_v2.md
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Art_UX_Review__First_Day_MVP_v3.md
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Game_Design_Roadmap_v2.md
docs/repo/status/CODEX_STATUS.md
```

---

## 19. Changelog

### 2026-07-12 — D-023 player-journey synchronization

- Removed a separate Day 2 order-accept action: route confirmation begins the offered order, preserving the exact two-confirmation Day 2 budget.
- Reframed calendar-like copy as session-based `в прошлый раз / в этот раз` language.
- Added the post-proof transition from completed D-022 evidence state to history-backed Quiet Cooperative with no active order/chain.

### 2026-07-11 — Day 2 executable scope accepted

- Locked one fully completable second Warm Food Delivery on the existing route/resource/station chain.
- Made end-to-end completion, player-confirmed dispatch, calm progress note and post-completion optional question mandatory proof.
- Added bounded fixture-only history/active-state semantics, static existing-stock precondition, order-tagged-event requirement, deterministic Labrador PackTask assignment and limited non-reward completion exception; routed the exact schema to Task Flow/Object contracts and the Codex brief.
- Kept persistence fixture-only and excluded save/calendar, new systems, habit unlock, production art/rig decisions and platform semantics.

### 2026-07-06 — v1 created

- Created First Week direction after R-25 selected option A.
- Defined Day 2 as “yesterday mattered”, not a big new system.
- Defined second warm delivery variation, dog memory follow-up, House of Curiosity boundary and candidate next Codex implementation slice.
