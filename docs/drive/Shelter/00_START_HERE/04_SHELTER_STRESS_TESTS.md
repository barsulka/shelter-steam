# 04_SHELTER_STRESS_TESTS — Project Identity Crash Tests

Дата создания: 2026-06-30
Статус: active project-wide stress-test checklist
Уровень: project-wide
Владелец: Producer / Game Designer
Связано с:

- `03_PROJECT_PHILOSOPHY.md`
- `02_DECISIONS.md` — D-020
- Steam/Desktop Game Systems Roadmap R-15.5

---

## 0. Назначение

Этот документ не добавляет новые механики.

Его задача — регулярно проверять, что Shelter не потерял свою идентичность.

Самая опасная ошибка Shelter — не плохой баланс.

Самая опасная ошибка Shelter — незаметно превратиться в другую игру:

- бездушную idle-фабрику;
- spreadsheet-first optimization game;
- бытовой симулятор / тамагочи;
- набор милых собак без production core;
- production game, где собаки являются только скинами worker units.

Этот документ — краш-тест души проекта.

Если `03_PROJECT_PHILOSOPHY.md` — Конституция Shelter, то этот документ — её stress-test suite.

---

## 1. Когда использовать

Shelter Stress Tests нужно проходить:

- перед принятием большой новой системы;
- перед Vertical Slice acceptance;
- перед First Day MVP;
- перед Alpha;
- перед Beta;
- перед Release;
- перед существенной монетизационной или благотворительной механикой;
- перед крупным изменением core loop, dog progression, buildings, research, economy or UI.

Для маленьких правок достаточно quick check по 2–3 релевантным тестам.

Для крупных этапов нужен полный проход.

---

## 2. How to read results

Каждый тест оценивается как:

- PASS — система сохраняет идентичность Shelter;
- PARTIAL — есть риск, нужен mitigation;
- FAIL — система противоречит философии Shelter or risks changing genre identity.

Правило release gate:

> Если хотя бы один критический тест получает FAIL, команда обязана понять причину до начала следующего этапа разработки.

FAIL не всегда означает “удалить систему”.

FAIL означает:

- переосмыслить;
- изменить framing;
- перенести систему в другой слой;
- уменьшить scope;
- вернуть вопрос Producer / relevant role.

---

## 3. Identity Tests

### 3.1 Excel Test

Question:

> Если заменить эту систему таблицей Excel, потеряется ли её смысл?

PASS if:

- physical dog actions matter;
- story and visible cause-and-effect matter;
- player observes processes, not only values;
- dog identity changes how the system feels;
- the system creates life, not only numbers.

FAIL if:

- nothing meaningful is lost after replacing the system with coefficients;
- dogs become row labels;
- buildings become formula cells;
- progress is only `+X%`;
- player-facing value is mostly spreadsheet optimization.

Example:

```text
Production Chain as Excel:
2 Oat + 1 Pumpkin = 1 Food Bag
```

This is insufficient.

Shelter version needs:

```text
dog travels
-> dog returns
-> dog unloads
-> dog carries
-> dog prepares
-> dog packs
-> dog loads
-> delivery is sent
```

### 3.2 Factory Test

Question:

> Если убрать уют, истории и характер собак, останется ли почти та же игра?

PASS if:

- removing dog life makes the game obviously worse and less itself;
- production remains tied to dogs and co-op life;
- buildings are places, not only machines.

FAIL if:

- game still works and feels almost identical without dogs as characters;
- stories, comfort and traits are only cosmetic garnish;
- the player mostly optimizes throughput.

### 3.3 The Sims / Tamagotchi Test

Question:

> Если убрать производство и оставить только жизнь собак, останется ли Shelter?

PASS if:

- production, routes, delivery, buildings and research remain necessary core;
- dog life enriches the production co-op instead of replacing it;
- the game does not turn into upkeep of daily needs.

FAIL if:

- main gameplay becomes hunger/thirst/toilet/sleep/sickness/chores;
- absence creates guilt;
- production becomes secondary;
- the game becomes a household life simulator.

### 3.4 Dog Test

Question:

> Можно ли заменить собак людьми, роботами или кубиками без разрушения механики?

PASS if:

- dogs are system-forming;
- dog character, habits, routes, rooms and actions matter;
- changing dogs into generic workers breaks emotional and mechanical meaning.

FAIL if:

- dogs are only skins;
- dogs can be replaced by generic units without design loss;
- dog card is just stat block;
- dog identity does not affect the system.

### 3.5 Charity Identity Test

Question:

> Если убрать тему помощи приютам, останется ли Shelter той же игрой?

Expected answer:

- Mechanically, some systems might still work.
- But Shelter loses purpose and identity.

PASS if:

- charity/help framing gives meaning to delivery and co-op life;
- delivery feels like help, not only order completion;
- no guilt pressure is used.

FAIL if:

- charity is only a marketing skin;
- delivery could be any generic commerce order;
- the system pressures player with guilt or suffering.

---

## 4. Philosophy Tests

### 4.1 D-020 Test

Question:

> Эта система делает жизнь кооператива богаче?

PASS if the answer explains:

- new dog activity;
- richer co-op life;
- stronger production core;
- better dog learning/care/help;
- warmer return reason;
- meaningful player decision.

FAIL if the first answer is only:

```text
+10% speed
+15% output
more resource
faster timer
```

### 4.2 Production Core Test

Question:

> Усиливает ли система производственный кооператив?

PASS if:

- routes, production, delivery, buildings, dogs or research become stronger;
- the system enriches the production co-op rather than replacing it;
- dogs still act as the visible agents of work.

FAIL if:

- production can be ignored;
- co-op becomes mostly lifestyle sandbox;
- production chain becomes invisible or irrelevant.

### 4.3 Idle Test

Question:

> Можно ли оставить игру открытой и получать удовольствие просто наблюдая?

PASS if:

- dogs continue meaningful visible life;
- strip or room windows show calm progress;
- player can observe without constant pressure;
- return after absence feels warm.

FAIL if:

- idle is only hidden timer;
- player must constantly click;
- nothing alive happens on screen;
- absence causes punishment/guilt.

### 4.4 Warmth Test

Question:

> Делает ли система кооператив теплее?

PASS if:

- the co-op feels more like a good place to live;
- interactions become more caring, readable or memorable;
- the system can create small stories.

FAIL if:

- it only increases efficiency;
- it adds pressure;
- it makes dogs feel like labor units.

---

## 5. Priority Tests

### 5.1 Layer Test

Question:

> К какому слою относится система?

Layers:

1. **Ядро** — without it Shelter stops being Shelter.
2. **Углубление** — without it game works, but becomes less alive.
3. **Атмосфера** — does not affect core loop, but makes world loved.

PASS if:

- the system has correct layer label;
- scope and development time match layer importance;
- atmosphere is not treated as core;
- core is not postponed for atmosphere.

FAIL if:

- atmospheric feature blocks core work;
- deep life-sim feature enters MVP before production loop;
- core system is treated as optional.

### 5.2 Time Allocation Test

Question:

> Мы точно тратим на эту систему правильное количество production time?

PASS if:

- core systems get most attention early;
- depth systems come after core proof;
- atmosphere is scoped carefully.

FAIL if:

- team spends weeks on window-looking while production chain is weak;
- room decor gets more design effort than routes/delivery;
- Workbench is built before systems contracts define fields.

---

## 6. Story Tests

### 6.1 Love Test

Question:

> Через неделю игрок скажет что?

Bad answer:

```text
У меня уже 1800 корма.
```

Good answer:

```text
Моя такса наконец научилась аккуратно проверять корзинку.
Лабрадор теперь сам поправляет ленточку перед отправкой.
В Доме любопытства две собаки вместе придумали мягкую фасовку.
```

PASS if the system creates memories about dogs and co-op life.

FAIL if the most memorable thing is only stockpile size.

### 6.2 Memory Test

Question:

> Через месяц игрок помнит ресурсы или истории собак?

PASS if:

- player can remember specific dog moments;
- deliveries have stories;
- rooms have meaning;
- dog habits feel personal.

FAIL if:

- player remembers only optimal build/order;
- dogs blur into stat bundles;
- stories are irrelevant.

### 6.3 Screenshot Test

Question:

> Если игрок делает скриншот, что он хочет показать другу?

PASS examples:

```text
Посмотри, лабрадор учит щенка в классе.
Такса опять сидит у дерева после дороги.
Смотри, они вместе читают открытку.
```

FAIL examples:

```text
Посмотри на мой +15% throughput.
Посмотри на таблицу склада.
```

---

## 7. Release Gate Checklist

Use this before large milestones.

| Test | PASS | PARTIAL | FAIL | Notes |
|---|---:|---:|---:|---|
| Excel Test | ☐ | ☐ | ☐ | |
| Factory Test | ☐ | ☐ | ☐ | |
| The Sims / Tamagotchi Test | ☐ | ☐ | ☐ | |
| Dog Test | ☐ | ☐ | ☐ | |
| Charity Identity Test | ☐ | ☐ | ☐ | |
| D-020 Test | ☐ | ☐ | ☐ | |
| Production Core Test | ☐ | ☐ | ☐ | |
| Idle Test | ☐ | ☐ | ☐ | |
| Warmth Test | ☐ | ☐ | ☐ | |
| Layer Test | ☐ | ☐ | ☐ | |
| Time Allocation Test | ☐ | ☐ | ☐ | |
| Love Test | ☐ | ☐ | ☐ | |
| Memory Test | ☐ | ☐ | ☐ | |
| Screenshot Test | ☐ | ☐ | ☐ | |

Gate rule:

> If any critical test fails, do not continue to next major milestone until the team understands why and decides whether to redesign, rescope or consciously accept risk.

---

## 8. Role usage

### Producer

Uses stress tests for product scope, milestone approval and roadmap priority.

### Game Designer

Uses stress tests before/after major systems docs and before assigning Codex briefs.

### Art Director

Uses stress tests to check whether visuals support living co-op identity, not factory UI or generic dog skins.

### Codex

Uses stress tests as guardrails when implementation shortcuts risk deleting dog actions, visible cause-and-effect or life context.

### Project Manager / Knowledge Base Maintainer

Uses stress tests to detect document drift and contradictions with `03_PROJECT_PHILOSOPHY.md`.

---

## 9. First known application: R-09..R-15

The first formal use is Steam/Desktop R-15.5:

```text
STEAM_DESKTOP__Core_Gameplay_Loop_Validation_v1.md
```

Purpose:

- validate R-09..R-15 under D-020;
- check for factory spreadsheet drift;
- check for tamagotchi/life-sim drift;
- confirm that production co-op core remains intact.

---

## 10. Changelog

### 2026-06-30 — v1 created

- Created project-wide Shelter Stress Tests.
- Added Excel, Factory, The Sims/Tamagotchi, Dog, Charity, D-020, Production Core, Idle, Warmth, Layer, Time Allocation, Love, Memory and Screenshot tests.
- Added release gate checklist.
- Positioned this document as crash-test suite for `03_PROJECT_PHILOSOPHY.md`.
