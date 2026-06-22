# STEAM_DESKTOP — Dog Identity & Progression Model v1

Дата: 2026-06-30
Роль документа: Game Design / Systems Design Contract
Статус: draft v1
Продукт: Steam/Desktop idle always-on-top strip
Roadmap task: R-09 — Dog Progression Model
Роль-владелец: Game Designer / Systems Designer

Основано на:

- `docs/drive/Shelter/00_START_HERE/02_DECISIONS.md` — D-010, D-018, D-019
- `STEAM_DESKTOP__Game_Systems_Roadmap_v1.md`
- `STEAM_DESKTOP__Vertical_Slice_Contract_v1.md`
- `STEAM_DESKTOP__Object_Contract_v1.md`
- `STEAM_DESKTOP__Task_Flow_Contract_v1.md`
- `docs/repo/dev/godot-state-connector.md`
- `docs/repo/api/godot-state-connector.openapi.yaml`

---

## 0. Назначение

Этот документ задаёт системную модель собаки для Steam/Desktop Shelter.

Главная цель — определить, что у собаки является личностью, что является развитием, что можно менять, что нельзя менять, и какие слои должны быть видимы в будущих системах и в `/state.dogs[]`.

Документ не является финальным каталогом всех особенностей, предметов, еды или способностей. Каталоги будут отдельными документами:

- `STEAM_DESKTOP__Ability_Source_Loop_v1.md`
- `STEAM_DESKTOP__Ability_Catalog_v1.md`
- future equipment / food / activity catalogs

Ключевой принцип:

> Собака развивается, но не превращается в generic stat unit.

Игрок должен чувствовать, что он помогает собаке раскрыться, найти любимые занятия, получить удобные инструменты и стать увереннее в кооперативе. Игрок не должен чувствовать, что он перековывает собаку в оптимальный билд.

---

## 1. Design pillars

### 1.1 Identity first

У каждой собаки есть постоянная идентичность.

Идентичность нельзя удалить, заменить, reroll-нуть или “починить”.

Игрок может усиливать, поддерживать и направлять собаку, но не стирать её индивидуальность.

### 1.2 Progression as care

Прогрессия собаки должна ощущаться как забота, обучение и совместная работа.

Допустимые чувства:

- собака освоилась;
- собаке стало удобнее;
- собака нашла любимую работу;
- собака научилась новому;
- кооператив стал лучше учитывать её характер.

Недопустимые чувства:

- собаку оптимизировали как ресурс;
- плохую собаку заменили хорошей;
- игрок обязан выбивать идеальный набор;
- редкость важнее личности;
- paid reroll / gacha / FOMO давят на выбор.

### 1.3 Separate permanent, learned, equipped and temporary layers

D-010 обязателен.

Слои собаки должны быть разделены:

- врождённое не заменяется;
- приобретённое добавляется через жизнь и работу;
- экипировка надевается и снимается;
- временные эффекты проходят;
- текущая деятельность меняется постоянно.

### 1.4 Mechanics must create visible dog behavior

Любая важная особенность должна по возможности выражаться не только числом, но и поведением:

- собака выбирает любимую задачу;
- быстрее берёт знакомую работу;
- аккуратнее переносит хрупкий ресурс;
- приносит маленькую дополнительную находку;
- помогает другой собаке;
- меньше простаивает рядом с любимым зданием;
- лучше справляется после отдыха.

Если особенность невозможно показать поведением, она всё ещё может существовать, но должна быть второстепенной.

---

## 2. Dog model layers

Собака состоит из следующих системных слоёв.

```text
Dog
├─ Identity
├─ Innate traits
├─ Preferences
├─ Activity experience
├─ Learned abilities
├─ Equipment
├─ Food / care effects
├─ Mood / energy / comfort
├─ Relationship / trust
└─ Current activity state
```

Для MVP / early systems не все слои обязаны быть реализованы сразу. Но модель должна заранее отличать их друг от друга.

---

## 3. Identity layer

Identity — неизменяемый слой собаки.

### 3.1 Contains

Identity содержит:

- dog id;
- display name;
- dog type / shape archetype;
- visual identity reference;
- base personality direction;
- core story note, если есть;
- adoption / arrival context, если есть;
- baseline role fantasy.

Примеры baseline role fantasy:

- маленькая быстрая водительница;
- спокойный помощник склада;
- осторожный упаковщик;
- любопытный исследователь;
- общительный курьер.

### 3.2 Rules

Identity MUST NOT be rerolled, deleted or optimized away.

Identity SHOULD influence which innate traits and preferences feel natural, but must not hard-lock the dog into one job forever.

Identity MAY affect narrative, visual behavior and default idle patterns.

### 3.3 Not responsible for

Identity is not responsible for:

- temporary buffs;
- equipment bonuses;
- learned skills;
- random production outcomes;
- full balance math.

---

## 4. Innate traits layer

Innate traits — врождённые / неизменяемые особенности.

### 4.1 Definition

Innate trait is a permanent dog feature that expresses natural style.

Игрок не может удалить innate trait, заменить его, reroll-нуть или превратить собаку в другую собаку.

### 4.2 Design role

Innate traits должны:

- задавать характерный стиль собаки;
- делать собак различимыми системно;
- создавать мягкие предпочтения задач;
- помогать игроку запоминать собаку;
- быть достаточно полезными, но не превращаться в обязательный min-max.

### 4.3 Allowed mechanical influence

Innate traits MAY influence:

- task duration;
- task reliability;
- chance of extra gentle finds;
- activity preference growth;
- comfort gain/loss;
- teamwork behavior;
- idle assistance;
- mistake recovery;
- route suitability;
- production quality.

Innate traits SHOULD NOT be only “+X% speed”. Some traits may affect speed, but the catalog must include non-speed axes.

### 4.4 Examples for future catalog

These examples are not final catalog approval, but establish intended direction:

- `Быстрые лапки` — better at travel, short carry routes, courier-like activities.
- `Аккуратный помощник` — better at fragile resources, packing, fewer mishaps.
- `Счастливчик` — slightly higher chance of pleasant extra finds in non-paid systems.
- `Тёплый нос` — improves comfort / teamwork / calming blocked states.
- `Любопытные уши` — better at research discovery or route scouting.
- `Верный маршрутчик` — more consistent travel outcomes.
- `Золотое терпение` — better at long tasks without mood loss.

### 4.5 Forbidden patterns

Innate traits MUST NOT:

- be paid-rerolled;
- be removed because they are suboptimal;
- create “bad dogs”;
- directly map to combat or PvP;
- create aggressive tier lists where low-rarity dogs are trash;
- be required to complete charity deliveries.

---

## 5. Preferences layer

Preferences — склонности и любимые занятия собаки.

### 5.1 Definition

Preference describes what a dog enjoys or naturally gravitates toward.

Preference is softer than innate trait. It can grow, shift slightly, or be discovered through play.

### 5.2 Examples

Possible preference categories:

- travel;
- unloading;
- carrying;
- cooking;
- packing;
- gardening / tree care;
- research assistance;
- social help;
- rest / comfort activities;
- delivery preparation.

### 5.3 Rules

Preferences SHOULD:

- guide assignment suggestions;
- affect mood/comfort gently;
- grow through repeated positive activity;
- help dogs feel alive.

Preferences SHOULD NOT:

- hard-lock a dog out of other activities;
- punish the player for using a dog differently;
- become a hidden spreadsheet that overrides visible personality.

---

## 6. Activity experience layer

Activity experience tracks what a dog has practiced.

### 6.1 Definition

Activity experience is not generic XP. It is experience by activity family.

Example:

```text
activity_experience:
  travel: 12
  unloading: 4
  cooking: 1
  packing: 0
  tree_care: 0
```

### 6.2 Purpose

Activity experience should support:

- unlocking learned abilities;
- showing that dogs learn by doing;
- making repeated work feel meaningful;
- enabling gentle specialization without hard min-max.

### 6.3 Rules

Activity experience MAY grow when dog completes tasks.

Growth SHOULD be calm and slow enough to feel earned.

Activity experience MUST NOT become grind pressure.

Activity experience SHOULD NOT be reset by equipment changes.

---

## 7. Learned abilities layer

Learned abilities — приобретённые способности.

### 7.1 Definition

Learned ability is a semi-permanent capability gained through work, learning, events, research, mentoring, or special non-paid progression loops.

Learned abilities differ from innate traits:

- innate trait is part of who the dog is;
- learned ability is something the dog learned to do.

### 7.2 Sources

Learned abilities MAY come from:

- repeated activity experience;
- completing deliveries;
- cooperative tasks with another dog;
- laboratory / research unlocks;
- gentle training events;
- route discoveries;
- tree/fruit ability source loop, if accepted in R-10;
- cozy room / comfort milestones, later.

### 7.3 Allowed mechanical influence

Learned abilities MAY affect:

- task options;
- task quality;
- cooperative assistance;
- resource handling;
- production output categories;
- chance of extra non-critical finds;
- reduce blocked time;
- unlock new interactions;
- improve consistency.

### 7.4 Rules

Learned abilities SHOULD:

- be earned by dog activity;
- feel like skill growth, not stat replacement;
- have understandable source and effect;
- be inspectable in Dog Card / Workbench.

Learned abilities MUST NOT:

- replace innate traits;
- be monetized through paid random acquisition;
- be required in perfect combinations for basic progress;
- create disposable dog optimization.

---

## 8. Equipment layer

Equipment — предметы, инструменты, одежда, аксессуары.

### 8.1 Definition

Equipment is changeable and can be equipped/unequipped.

Equipment can enhance, support or redirect dog activity, but must not overwrite dog identity.

### 8.2 Examples

Equipment categories:

- clothing: slippers, vest, scarf;
- tools: small cart harness, packing ribbon tool, watering pouch;
- transport accessories: basket cushion, route bell, safety light;
- work accessories: careful gloves equivalent, label pouch;
- comfort accessories: favorite blanket, lucky bandana.

### 8.3 Rules

Equipment MAY provide bonuses, unlock actions or improve comfort.

Equipment SHOULD be visible or at least represented in Dog Card.

Equipment MUST be separate from innate traits and learned abilities.

Equipment MUST NOT:

- permanently alter innate identity;
- become paid power pressure;
- be required in rare/legendary form for basic deliveries;
- turn dog into generic stat stack.

---

## 9. Food / care effects layer

Food and care effects are temporary or medium-term modifiers.

### 9.1 Definition

Food/care effects represent how well the dog is supported right now.

They are not the same as learned abilities or equipment.

### 9.2 Possible effects

Food/care MAY influence:

- comfort;
- focus;
- willingness for long tasks;
- recovery after work;
- chance of gentle extra output;
- teamwork mood;
- idle behavior.

### 9.3 Rules

Food/care effects SHOULD feel like care, not doping.

They MUST NOT be framed as forcing performance from a dog.

They SHOULD NOT punish the player harshly when absent.

If food/care becomes a system, it should support warmth and rhythm, not pressure.

---

## 10. Mood / energy / comfort layer

Mood/energy/comfort is a possible later layer.

### 10.1 Current status

For early systems, this layer is conceptual. It is not required for first implementation unless a future contract accepts it.

### 10.2 Design intent

If implemented, it should support:

- calm idle rhythm;
- visible rest;
- comfort choices;
- non-punitive pacing;
- dog personality expression.

### 10.3 Forbidden patterns

Mood/energy MUST NOT become:

- punishment timer;
- guilt pressure;
- “dog is sad unless you log in” manipulation;
- paid energy refills;
- failure pressure on charity deliveries.

---

## 11. Relationship / trust layer

Relationship/trust is possible later progression.

### 11.1 Definition

Trust describes how comfortable a dog feels in the co-op and with the player.

### 11.2 Allowed use

Trust MAY unlock:

- small story moments;
- optional cozy animations;
- additional Dog Card details;
- gentle preferences reveal;
- non-critical cosmetic or emotional feedback.

### 11.3 Rules

Trust MUST NOT:

- be reduced aggressively for absence;
- become guilt mechanic;
- gate basic production in a harsh way;
- imply that the player is neglecting real animals.

---

## 12. Current activity state

Current activity state describes what the dog is doing right now.

### 12.1 Contains

Current activity state SHOULD include:

- activity id;
- task id;
- activity type;
- source object;
- target object;
- carried resource, if any;
- started_at / remaining time, if needed;
- current visible phase;
- blocked reason, if blocked;
- whether activity is player-assigned, system-assigned or idle.

### 12.2 Purpose

This layer is essential for Workbench and `/state.dogs[]`.

It allows Game Designer to inspect:

- who is working;
- who is idle;
- what tasks are blocking;
- whether dogs are overused;
- whether progression rules behave as intended.

---

## 13. Proposed `/state.dogs[]` schema direction

This is not an immediate Codex task. It is a future schema direction for R-16 after systems contracts are accepted.

Example shape:

```json
{
  "id": "dog.dachshund_intro",
  "display_name": "Такса",
  "identity": {
    "type": "dachshund",
    "shape_archetype": "long_small",
    "personality_direction": "quick_curious_driver",
    "baseline_role": "first_driver"
  },
  "innate_traits": [
    {
      "id": "trait.quick_paws",
      "name": "Быстрые лапки",
      "tags": ["travel", "short_carry", "movement"]
    }
  ],
  "preferences": {
    "travel": 0.8,
    "packing": 0.3,
    "tree_care": 0.2
  },
  "activity_experience": {
    "travel": 12,
    "unloading": 3,
    "cooking": 0,
    "packing": 1
  },
  "learned_abilities": [],
  "equipment": [
    {
      "id": "equipment.comfortable_slippers",
      "name": "Удобные тапочки",
      "slot": "paws"
    }
  ],
  "food_care_effects": [],
  "mood_energy_comfort": {
    "comfort_state": "ok"
  },
  "relationship_trust": {
    "known_to_player": true
  },
  "current_activity": {
    "type": "idle",
    "task_id": null,
    "carried_resource": null,
    "blocked_reason": null
  }
}
```

Implementation note:

- Early `/state` may expose only a subset.
- Schema should grow only when design contracts define fields.
- Codex should not invent dog progression semantics ahead of Game Designer documents.

---

## 14. Initial system rules

### 14.1 Layer interaction

Recommended order of dog modifiers:

```text
base activity rules
+ innate trait influence
+ learned ability influence
+ equipment influence
+ food/care temporary influence
+ building/activity context
= final task behavior/result
```

This order is conceptual, not final math.

### 14.2 No single best dog

System should avoid creating one universally best dog.

Different dogs should be better suited for different activities, moods, roles and situations.

### 14.3 No bad dog

A dog may be less suited for a specific task, but should never be framed as bad.

Bad wording:

```text
inefficient dog
wrong dog
low-tier dog
```

Better wording:

```text
prefers another activity
still learning this job
works more calmly with help
better suited for short routes
```

### 14.4 Ability stacking limits

Future ability/equipment stacking must avoid runaway optimization.

Possible safety rules for future design:

- diminishing returns;
- category caps;
- role-specific bonuses;
- comfort tradeoffs;
- non-speed effects;
- soft recommendations instead of hard requirements.

No exact balance values are defined in this document.

---

## 15. Relationship to ability source loop

R-10 should define how dogs acquire abilities.

This document defines where acquired abilities live and how they differ from other layers.

Potential R-10 directions to evaluate:

- activity mastery;
- cooperative learning;
- research-enabled training;
- tree/fruit ability source loop;
- route discoveries;
- delivery milestones;
- comfort/room moments;
- mentor dog interactions, later.

Tree/fruit idea must be handled carefully:

- no paid gacha;
- no pressure rerolls;
- rarity can create joy, not mandatory pain;
- fruit quality/generosity can exist, but should not define dog worth;
- ability payload must be transparent enough to avoid manipulative randomness.

---

## 16. Relationship to buildings and activities

Dog progression must connect to buildings and activities.

Examples:

- repeated Kitchen help may unlock cooking-related learned ability;
- repeated Packing Table work may unlock careful packaging ability;
- travel experience may unlock route scouting ability;
- tree care may affect fruit quality or growth consistency;
- lab assistance may affect research insight, not just research speed;
- comfort spaces may reveal preferences or reduce overwork risk.

These are examples for future R-11/R-12/R-14. They are not final content approvals.

---

## 17. UI / Dog Card requirements

Dog Card should eventually separate these sections:

```text
Identity
Innate traits
Learned abilities
Equipment
Preferences / favorite activities
Current activity
Temporary effects, if active
```

MVP Dog Card may show fewer sections, but it must preserve D-010:

```text
Innate trait != Equipment != Learned ability
```

Dog Card MUST NOT become a dense RPG sheet for the player.

Workbench may expose more detailed fields than player UI.

---

## 18. Workbench requirements from this model

Future Game Design Systems Workbench should support inspecting:

- dog identity;
- innate traits;
- acquired/learned abilities;
- equipment;
- preferences;
- activity experience;
- current activity;
- recent activity history;
- ability source events;
- task result modifiers;
- comfort/mood state if implemented;
- event log entries related to dog progression.

Workbench may show tables and JSON because it is an internal tool.

Player-facing UI should remain warm, compact and non-spreadsheet.

---

## 19. Out of scope

This document does not define:

- full ability catalog;
- full equipment catalog;
- exact numerical balance;
- tree/fruit ability source math;
- laboratory research tree;
- building upgrade chains;
- final Dog Card UI layout;
- art style;
- dog visual prompts;
- animation production list;
- monetization;
- charity reporting;
- Browser Extension sync.

---

## 20. Open questions for R-10 / R-11

1. How many learned abilities can a dog reasonably have before Dog Card becomes noisy?
2. Are learned abilities permanent, swappable, or grouped into active/passive slots?
3. Should ability acquisition be deterministic, semi-random, or choice-based?
4. If tree/fruit loop exists, what prevents it from feeling like gacha?
5. Should equipment grant abilities directly or modify existing traits/activities?
6. Should dogs have activity preferences visible from start or discovered through play?
7. Should “non-speed” abilities be at least half of the first catalog?
8. How should cooperative abilities work between two dogs?
9. Should activity experience unlock abilities automatically or create training opportunities?
10. Which fields must enter State Connector first for Workbench value?

---

## 21. Acceptance criteria

R-09 is complete enough to move to R-10 when:

1. Dog layers are clearly separated.
2. D-010 is preserved and expanded into a broader progression model.
3. Identity cannot be rerolled, removed or overwritten.
4. Learned abilities are distinct from innate traits and equipment.
5. Equipment is distinct from innate traits and learned abilities.
6. Temporary effects are distinct from permanent/semi-permanent progression.
7. Current activity state is defined for Workbench needs.
8. Future `/state.dogs[]` direction is sketched without creating an immediate Codex task.
9. Forbidden patterns protect against gacha, paid rerolls, bad dogs and spreadsheet-first min-max.
10. Open questions for Ability Source Loop and Ability Catalog are listed.

## 22. Next recommended documents

Next Game Designer tasks:

1. `STEAM_DESKTOP__Ability_Source_Loop_v1.md`
2. `STEAM_DESKTOP__Ability_Catalog_v1.md`
3. `STEAM_DESKTOP__Activities_Catalog_v1.md`

Recommended next step:

Start R-10 by deciding how dogs acquire learned abilities without gacha or pressure.

---

## 23. Changelog

### 2026-06-30 — v1 created

- Created the first Dog Identity & Progression Model for Steam/Desktop.
- Defined dog system layers: Identity, Innate traits, Preferences, Activity experience, Learned abilities, Equipment, Food/care effects, Mood/energy/comfort, Relationship/trust, Current activity.
- Preserved D-010 as a strict separation rule.
- Added future `/state.dogs[]` schema direction for Game Design Systems Workbench.
- Listed forbidden patterns and next questions for Ability Source Loop / Ability Catalog.
