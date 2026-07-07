# STEAM_DESKTOP — First Day MVP Lock And Next Scope Decision v1

Дата: 2026-07-06
Роль документа: Game Design / Scope Lock Decision
Статус: accepted
Продукт: Steam/Desktop idle always-on-top strip
Roadmap task: R-25 — First Day MVP Lock / Next Scope Decision v1
Роль-владелец: Game Designer / Systems Designer

---

## 0. Назначение

Этот документ фиксирует результат R-25:

1. First Day MVP считается закрытым на уровне prototype/product-language proof.
2. Следующий scope выбран: **A — First Week / longer retention**.
3. Workbench follow-up tooling and blocking v4 visual/readability pass откладываются до появления конкретной боли.

Это не production art lock, не shipping UX lock, не final balance lock and not Steam release readiness.

---

## 1. Decision

```text
Decision: lock First Day MVP at prototype/product-language level.
Next scope: A — First Week / longer retention.
```

Следующий большой вопрос проекта:

> Зачем игрок возвращается завтра, после первой тёплой поставки?

---

## 2. What is locked

### 2.1 First Day structure

Accepted First Day structure remains:

```text
Beat 1 — В кооперативе первый рабочий день
Beat 2 — Первая поездка за ресурсами
Beat 3 — Собаки вместе готовят поставку
Beat 4 — Игрок отправляет первую поставку
Beat 5 — Открытка, тапочки, память и завтрашний намёк
```

### 2.2 First dogs

Accepted:

```text
Такса — первый водитель
Лабрадор — спокойный помощник
```

### 2.3 First route / order

Accepted:

```text
Route: Овсяная ферма / route.oat_farm_intro
Order: Первая тёплая поставка / order.first_warm_delivery
```

### 2.4 First reward / memory

Accepted:

```text
Reward: Удобные тапочки для Таксы
Memory: Помнит первую тёплую поставку
```

D-010 remains intact:

```text
innate trait != equipment != learned memory / habit
```

### 2.5 First Day completion

Accepted completion requires both technical and emotional closure:

```text
order.delivery_confirmed: true
order.postcard_visible: true
order.reward_available: true
game.chain_complete: true
first_day.postcard_life_moment_seen: true
first_day.first_reward_equipped: true
first_day.first_memory_added: true
first_day.next_day_hint_available: true
```

### 2.6 House of Curiosity scope

Accepted for First Day only as:

```text
post-delivery tease / next-day hint
```

Not accepted for First Day:

```text
full research loop
research tree
classroom/library flow
multi-branch unlock system
```

---

## 3. Evidence summary

### 3.1 Runtime evidence

Source:

```text
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Runtime_Review__First_Day_MVP_Runtime_Polish_v1.md
```

Verdict:

```text
First Day MVP Runtime Polish v1: PASS
First Day runtime evidence: PASS
Workbench proof quality: PASS
```

Important proof:

- full delivery chain passes;
- postcard/reward/memory/hint state exists;
- Food Bag delivered semantic fixed;
- legacy production_chain consistency fixed;
- dog-action event evidence exists;
- debug event noise cleaned.

### 3.2 Game Designer visible readability evidence

Source:

```text
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Visible_Review__First_Day_MVP_v2.md
```

Verdict:

```text
R-23 First Day Visible Readability Fix v1: PASS
First Day prototype readability: PASS with minor watchpoints
```

### 3.3 Art / UX visual-language evidence

Source:

```text
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Art_UX_Review__First_Day_MVP_v3.md
```

Verdict:

```text
PASS as First Day Art/UX Visual Language Pass
No blocking v4 required before the next roadmap step
```

Accepted at prototype level:

- hidden UI readability;
- Такса first-driver cue;
- Лабрадор calm-helper cue;
- physical payload flow;
- Packing Table Food Bag object state;
- Van ready object-state proof;
- postcard board attention cue;
- comfortable slippers as personal reward cue;
- next-day hint as physical note;
- compact strip composition at 96px.

---

## 4. What is explicitly NOT locked

Not locked yet:

- final production art;
- final visual style;
- final animation polish;
- final shipping UX;
- final real-time pacing;
- final economy numbers;
- Steam release readiness;
- Windows behavior;
- production save format;
- monetization / charity / ads;
- full House of Curiosity implementation;
- First Week structure.

These remain future tasks.

---

## 5. Chosen next scope — A: First Week / longer retention

R-25 chooses:

```text
A — First Week / longer retention
```

Meaning:

The next design phase should answer how the game develops after the first successful delivery.

Primary product question:

```text
What does the player want to see tomorrow?
```

Secondary product questions:

- What changes in the co-op after the first postcard?
- What is the second meaningful delivery or task?
- How does `Удобные тапочки` matter without becoming min-max equipment?
- How does `Помнит первую тёплую поставку` affect behavior, not just text?
- When does House of Curiosity become active?
- What is the first non-pressure reason to return?
- How do we avoid turning the game into either a spreadsheet or a pure life sim?

---

## 6. Rejected next scopes for now

### 6.1 Workbench follow-up tooling

Rejected as immediate next step.

Reason:

Current tooling is sufficient for the next design phase. Workbench follow-ups should be driven by concrete review pain, not tooling ambition.

Still valid later:

```text
Scenario Runner v0
State Diff v0
Why Explanation v0
Stress Dashboard v0
Capture + State Bundle v1
```

### 6.2 Blocking v4 visual/readability pass

Rejected as immediate next step.

Reason:

Art Director / UX review says no blocking v4 is required before the next roadmap step.

Future visual work should focus on production visual style and motion/personality polish after the next product language decision.

### 6.3 One-off real-speed player-feel check

Rejected as blocker.

Reason:

Real-speed player-feel remains important, but the current v3 capture already includes normal-speed frame sequences sufficient to move product design forward. A dedicated real-speed review can be scheduled when a concrete pacing question appears.

---

## 7. Constraints for First Week design

The next phase must preserve Shelter constraints:

- no combat;
- no PvP;
- no bosses;
- no monsters;
- no gacha;
- no paid reroll;
- no aggressive FOMO;
- no guilt pressure;
- no manipulative donation pressure;
- no full visible crop farming in Steam core;
- no sudden expansion to Browser Extension mechanics;
- no full House of Curiosity tree before its role is designed;
- production remains physical, visible and dog-owned;
- dogs remain characters, not worker units.

---

## 8. Recommended next document

Create R-27 design document:

```text
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__First_Week_Direction_v1.md
```

Suggested scope:

```text
Day 2 / First Week product direction
```

It should define:

1. First return moment after Day 1.
2. What the player sees changed tomorrow.
3. First repeatable loop after the first delivery.
4. Second order / task direction.
5. First soft choice.
6. First House of Curiosity activation boundary.
7. First dog behavior/habit follow-up.
8. First reason to care about improving the co-op.
9. What remains out of scope.
10. Candidate R-28 Codex implementation brief.

---

## 9. Initial recommendation for First Week direction

Recommended starting thesis:

```text
Day 2 should not add a new system immediately.
Day 2 should show that yesterday mattered.
```

Possible Day 2 opening:

```text
The postcard remains on the board.
Такса starts the day with slippers visible.
Лабрадор notices the packing note.
A second warm delivery appears, slightly different but not harder in a punitive way.
House of Curiosity becomes a gentle question: “Can we pack even more carefully?”
```

Preferred first longer-retention pattern:

```text
memory -> small behavior change -> new order variation -> gentle improvement opportunity -> optional curiosity note
```

Avoid:

```text
new complex economy immediately
full research tree immediately
second dog recruitment immediately
many routes immediately
multiple queues immediately
pressure timer immediately
```

---

## 10. Acceptance criteria for R-25

R-25 is accepted when:

1. First Day MVP lock decision is recorded.
2. Next scope is explicitly selected as First Week / longer retention.
3. Rejected alternatives are documented.
4. First Week design constraints are documented.
5. Next document path is defined.
6. Roadmap can move from R-25 to R-27.

Status: **accepted**.

---

## 11. Sources

```text
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__First_Day_MVP_v1.md
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Runtime_Review__First_Day_MVP_Runtime_Polish_v1.md
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Visible_Review__First_Day_MVP_v2.md
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Art_UX_Review__First_Day_MVP_v3.md
docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v3/
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Game_Design_Roadmap_v2.md
docs/repo/status/CODEX_STATUS.md
```

---

## 12. Changelog

### 2026-07-06 — v1 created

- Locked First Day MVP at prototype/product-language level.
- Selected next scope: A — First Week / longer retention.
- Rejected immediate Workbench tooling, blocking v4 readability pass and one-off real-speed player-feel check as blockers.
- Defined next document: `STEAM_DESKTOP__First_Week_Direction_v1.md`.
