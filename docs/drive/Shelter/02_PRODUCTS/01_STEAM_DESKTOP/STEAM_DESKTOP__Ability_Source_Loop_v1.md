# STEAM_DESKTOP — Ability Source Loop v1

Дата: 2026-06-30
Роль документа: Game Design / Systems Design Contract
Статус: draft v1
Продукт: Steam/Desktop idle always-on-top strip
Roadmap task: R-10 — Ability Source Loop
Роль-владелец: Game Designer / Systems Designer

Основано на:

- `STEAM_DESKTOP__Dog_Progression_Model_v1.md`
- `STEAM_DESKTOP__Game_Systems_Roadmap_v1.md`
- `docs/drive/Shelter/00_START_HERE/02_DECISIONS.md` — D-010, D-018, D-019

---

## 0. Назначение

Этот документ описывает, как собаки в Shelter получают приобретённые умения без ощущения лута, гачи, reroll-давления или generic RPG-билда.

Документ намеренно использует слово **умения** как основной термин для player-facing слоя.

Слово “способности” можно использовать в технических документах как `abilities`, но в дизайне и тоне Shelter предпочтительнее:

- умение;
- привычка;
- талант;
- любимый приём;
- сильная сторона;
- маленький секрет;
- освоенный способ работы.

Главный принцип:

> Умение — это следствие истории собаки, а не предмет.

Предметы, плоды, исследования и события не “выдают способность” напрямую. Они создают условия, опыт, вдохновение или возможность, из которых у конкретной собаки со временем формируется новое умение.

---

## 1. Core philosophy

### 1.1 Dog story before loot

Игрок не должен думать:

```text
Какой источник дропает нужную способность?
```

Игрок должен думать:

```text
Интересно, чему ещё может научиться эта собака?
```

Это меняет всю систему.

Shelter не строит ability loop как loot table. Shelter строит progression loop как историю собаки в кооперативе.

### 1.2 Ability source is not ability grant

Источники не дают умения напрямую.

```text
Источник
-> условие / вдохновение / практика / возможность
-> опыт конкретной собаки
-> момент освоения
-> новое умение
```

Примеры:

```text
Собака много ездила по коротким маршрутам
-> накопила travel activity experience
-> получила возможность освоить привычку “Проверяет корзинку перед дорогой”
```

```text
Кооператив исследовал мягкую упаковку
-> Packing Table получил новый training option
-> собака, которая часто фасует поставки, может освоить “Аккуратный узелок”
```

```text
Собака ухаживала за деревом вдохновения
-> вырос плод терпения
-> после совместной работы с этим плодом появилась возможность освоить спокойное long-task умение
```

### 1.3 No single acquisition channel

Умения не должны приходить из одного универсального источника.

Допустимые каналы:

- труд;
- активность и практика;
- исследования;
- находки;
- вдохновляющие плоды;
- наставничество;
- дружба / совместная работа;
- забота / комфорт;
- маршруты;
- поставки;
- building-specific experience.

Разные умения могут требовать разные комбинации источников.

---

## 2. Source categories

### 2.1 Work / труд

Труд — базовый источник формирования умений.

Собака становится лучше, потому что делает настоящие дела в кооперативе:

- ездит по маршрутам;
- разгружает ящики;
- носит ресурсы;
- помогает на кухне;
- фасует мешки;
- загружает фургон;
- ухаживает за деревьями;
- помогает в лаборатории;
- поддерживает других собак.

Труд создаёт activity experience.

Труд SHOULD NOT мгновенно выдавать умение после каждого действия.

Труд SHOULD накапливать историю:

```text
dog.completed_activity(type=packing)
-> packing_experience + small amount
-> maybe unlock training opportunity / habit event later
```

### 2.2 Research / исследования

Исследования открывают новые способы работы, но не делают всех собак автоматически обученными.

Правильная цепочка:

```text
research unlocked
-> new method available
-> relevant dog can practice it
-> learned ability may form
```

Примеры:

- исследование “мягкая фасовка” открывает возможность освоить упаковочные умения;
- исследование “спокойные дальние маршруты” открывает travel-related training opportunities;
- исследование “бережная сушка корма” открывает kitchen/production quality умения.

Research MUST NOT become cold sci-fi upgrade tree that overwrites dog personality.

Research SHOULD be framed as co-op learning, notes, recipes, better tools and safer routines.

### 2.3 Finds / находки

Находки — источник радости и возможностей.

Находка MAY be:

- необычный плод;
- старый инструмент;
- мягкая книга с заметками;
- семечко;
- рецепт;
- ленточка;
- добрая записка;
- карта короткой тропинки;
- редкий материал.

Находка MUST NOT feel like paid loot drop.

Находка SHOULD open:

- training opportunity;
- recipe;
- research clue;
- cozy event;
- equipment crafting option;
- inspiration for a dog.

Находка SHOULD NOT directly overwrite learned abilities.

### 2.4 Mentorship / наставничество

Опытная собака может помочь другой собаке освоиться.

Цепочка:

```text
experienced dog + learning dog
-> shared activity
-> mentorship progress
-> learned dog gains confidence / practice
-> possible new learned ability
```

Наставничество хорошо подходит Shelter, потому что оно подчёркивает кооператив и заботу.

Примеры:

- лабрадор учит новичка аккуратно переносить ящики;
- быстрая такса показывает короткую дорожку к Road Sign;
- спокойная собака помогает тревожной собаке не бросать долгую задачу.

Mentorship MUST NOT create disposable “trainer units”.

Mentorship SHOULD create small relationship/story moments.

### 2.5 Friendship / дружба и совместная работа

Некоторые умения появляются из совместной работы.

Не потому что “combo +15%”, а потому что собаки привыкли друг к другу.

Примеры:

- две собаки быстрее разгружают транспорт, потому что понимают порядок;
- одна собака приносит упаковку заранее, когда видит, что другая заканчивает Food Mix;
- спокойная собака помогает другой меньше теряться в long task.

Friendship MAY unlock cooperative abilities.

Friendship MUST NOT become romance/gacha/social pressure system.

Friendship SHOULD remain soft, optional and warm.

### 2.6 Care / забота и комфорт

Не все умения рождаются из труда.

Некоторые появляются потому, что собаке хорошо:

- любимое место;
- уютная лежанка;
- привычный уголок;
- любимая игрушка;
- мягкий ритуал перед дорогой;
- спокойный отдых после длинной работы.

Care source SHOULD support:

- confidence;
- patience;
- teamwork;
- recovery;
- preference discovery;
- optional story moments.

Care MUST NOT become guilt mechanic.

Forbidden framing:

```text
Собака грустит, потому что вы давно не заходили.
```

Allowed framing:

```text
После отдыха у любимого коврика собака спокойнее берётся за долгие дела.
```

### 2.7 Routes / маршруты

Маршруты могут давать опыт и возможности.

Route source MAY provide:

- route familiarity;
- scouting notes;
- travel confidence;
- rare gentle finds;
- location-specific inspiration;
- materials for equipment or research.

Route source MUST NOT become paid drop farming.

The player SHOULD roughly understand possible categories, but exact special moments can remain pleasant surprises.

### 2.8 Trees / деревья вдохновения

Деревья — потенциально сильный source loop, but must not become gacha disguised as gardening.

Recommended framing:

> Деревья не выращивают способности. Деревья выращивают вдохновение.

Tree produces fruits that carry experience flavor / inspiration theme.

Example fruit themes:

- терпение;
- аккуратность;
- любопытство;
- забота;
- наблюдательность;
- смелость;
- спокойствие;
- находчивость;
- щедрость;
- командность.

Fruit does not directly install ability.

Better chain:

```text
dog cares for tree
-> fruit grows with theme and quality
-> fruit is used in tea/treat/training moment
-> dog with matching history may form a learned habit
```

---

## 3. Fruit quality and generosity model

This section is a design direction for R-10/R-11/R-15, not final balance.

### 3.1 Fruit rarity / quality

User-proposed quality levels are accepted as a promising structure:

1. обычный;
2. продвинутый;
3. редкий;
4. эпический;
5. легендарный.

But these levels must be handled ethically.

Quality SHOULD affect:

- strength of inspiration;
- chance to offer better training opportunity;
- number of possible themes to choose from;
- quality of non-critical bonus;
- beauty/story value;
- event richness.

Quality MUST NOT imply:

- low-quality fruit is useless;
- legendary fruit is required for core progress;
- player should pay/reroll for higher rarity;
- dog is bad without rare fruit.

### 3.2 Generosity / щедрость

Fruit generosity is accepted as a strong concept.

Possible generosity levels:

- single — supports one theme / one dog / one training opportunity;
- double — supports two themes, two dogs or one stronger cooperative moment;
- triple — supports a small group/co-op moment or richer choice.

Preferred interpretation:

```text
Generosity = how many opportunities or participants the fruit can support.
```

Not preferred:

```text
Generosity = raw power multiplier.
```

### 3.3 Fruit payload

Fruit payload SHOULD be transparent enough to avoid manipulative randomness.

Possible payload fields:

```text
fruit_theme
quality_tier
generosity
source_tree
grown_by_dog_ids
care_history
suggested_training_contexts
```

Example:

```json
{
  "theme": "patience",
  "quality": "rare",
  "generosity": "double",
  "grown_by": ["dog.labrador_intro"],
  "suggested_contexts": ["long_task", "packing", "mentorship"]
}
```

### 3.4 Tree loop boundaries

Tree loop MUST NOT:

- be visible crop farming replacement for Steam core resources;
- dominate the production co-op fantasy;
- become paid gacha;
- become mandatory for all dog progression;
- require constant checking;
- punish absence.

Tree loop MAY:

- live as a cozy side system;
- support ability source loop;
- create gentle surprises;
- connect dogs to care/comfort;
- produce training inspiration;
- support cooperative dog moments.

---

## 4. Ability formation model

### 4.1 Basic formation chain

Recommended chain:

```text
source event
-> experience / inspiration / opportunity
-> matching dog history check
-> player-facing choice or soft reveal
-> learned ability formed
-> Dog Card / Workbench update
```

### 4.2 Matching dog history

A new learned ability should feel connected to the dog.

Possible matching signals:

- innate trait tags;
- activity experience;
- preferences;
- recent activity history;
- equipment used;
- friendship/mentorship context;
- tree/fruit care history;
- research unlocks;
- route familiarity;
- comfort state.

### 4.3 Player choice vs automatic reveal

Both are allowed.

Automatic reveal works when the story is obvious:

```text
После многих аккуратных упаковок Лабрадор освоил “Ровный узелок”.
```

Player choice works when multiple gentle options appear:

```text
После редкого плода заботы можно поддержать одно из умений:
- спокойнее помогать в долгих задачах;
- чаще подсказывать другой собаке;
- бережнее обращаться с хрупкими ресурсами.
```

Player choice SHOULD be meaningful but not punishing.

### 4.4 Training opportunities

A training opportunity is not a task-grind command. It is a gentle moment where the player chooses what to encourage.

Examples:

- “Потренироваться завязывать мешочки.”
- “Проверить корзинку перед дорогой.”
- “Показать новичку, где лежат тыквы.”
- “Спокойно доделать длинную фасовку.”

Training opportunity SHOULD use dogs, objects and activities that already exist.

It SHOULD NOT create a separate grind minigame.

---

## 5. Learned ability types

This document does not create the full Ability Catalog, but defines source-driven categories.

### 5.1 Activity habits

Formed by repeated work.

Examples:

- checks basket before route;
- keeps packing table tidy;
- brings labels early;
- rests near Storage before unload rush.

### 5.2 Craft / production methods

Formed by building work + research.

Examples:

- softer mixing;
- careful bag tying;
- keeps dry ingredients separate;
- spots when packaging is missing.

### 5.3 Route habits

Formed by travel + route familiarity.

Examples:

- remembers short path;
- returns with fewer delays;
- notices extra safe find;
- prepares bicycle calmly.

### 5.4 Teamwork habits

Formed by dogs working together.

Examples:

- waits for partner before heavy unload;
- brings next resource to friend's station;
- helps another dog finish long task.

### 5.5 Care-based strengths

Formed by comfort and rhythm.

Examples:

- calmer after rest;
- more patient at long tasks;
- notices when another dog is tired;
- keeps working without hurry.

### 5.6 Inspiration habits

Formed by tree/fruit/find events plus dog history.

Examples:

- curious about new routes;
- careful with unusual ingredients;
- better at discovering non-critical cozy bonuses;
- more generous in team tasks.

---

## 6. Non-speed design requirement

At least half of the first Ability Catalog SHOULD be non-speed effects.

Allowed non-speed axes:

- reliability;
- quality;
- reduced waste/mishap;
- extra optional finds;
- better teamwork;
- better blocked-state recovery;
- earlier preparation of next input;
- comfort recovery;
- route familiarity;
- task handoff smoothness;
- preference discovery;
- unlocks new gentle action;
- improves clarity of planning;
- supports another dog.

Speed is allowed, but speed must not dominate the system.

---

## 7. Ethical and emotional boundaries

### 7.1 No paid randomness

Ability source loop MUST NOT include:

- paid gacha;
- paid reroll;
- paid fruit quality reroll;
- paid dog trait reroll;
- paid ability slot reroll;
- paid time pressure tied to dog improvement.

### 7.2 No bad dogs

The system MUST NOT create low-tier dogs.

Every dog can grow in directions that fit them.

### 7.3 No failure pressure

Ability acquisition SHOULD feel like opportunity, not failure.

Forbidden:

```text
You failed to get the rare ability.
```

Allowed:

```text
Сегодня получилось простое, но полезное умение.
```

### 7.4 No guilt

Dog progression MUST NOT punish absence or imply neglect.

### 7.5 No exploitative productivity tone

Avoid wording that treats dogs as labor machines.

Better:

- learned;
- got used to;
- found a comfortable way;
- helps more confidently;
- likes this task.

Avoid:

- optimized;
- output unit;
- efficiency dog;
- low-tier worker;
- productivity build.

---

## 8. Player-facing loop examples

### 8.1 Activity mastery loop

```text
Dog does activity repeatedly
-> activity experience grows
-> small story hint appears
-> training opportunity appears
-> player encourages one direction
-> learned ability appears
```

Example:

```text
Лабрадор часто фасовал мешки.
Он начал сам поправлять ленточки перед отправкой.
New learned habit: Ровный узелок.
```

### 8.2 Research-enabled loop

```text
Lab unlocks safer method
-> building exposes training opportunity
-> dog with relevant experience practices it
-> learned ability appears
```

Example:

```text
Исследование: Мягкая фасовка.
Собака с packing experience может освоить “Бережная упаковка”.
```

### 8.3 Tree inspiration loop

```text
Dog cares for inspiration tree
-> fruit grows with theme/quality/generosity
-> fruit creates training moment
-> dog history shapes options
-> learned ability appears
```

Example:

```text
Плод терпения, редкий, double generosity.
Можно поддержать лабрадора и таксу в совместной долгой задаче.
```

### 8.4 Mentorship loop

```text
Experienced dog works with newer dog
-> mentorship progress grows
-> new dog gains confidence in activity
-> cooperative or basic learned habit appears
```

Example:

```text
Лабрадор несколько раз помогал новичку разгружать ящики.
Новичок освоил “Сначала ставит тяжёлое”.
```

### 8.5 Route familiarity loop

```text
Dog repeats same route
-> route familiarity grows
-> route-specific event appears
-> learned travel habit appears
```

Example:

```text
Такса часто ездила на Овсяную ферму.
Она запомнила спокойную тропинку.
New learned habit: Знакомая дорога.
```

---

## 9. Data direction for Workbench

This is future R-16 schema direction, not an immediate Codex task.

Ability source events should eventually be observable in Workbench.

Possible `/state` additions:

```json
{
  "dogs": [
    {
      "id": "dog.labrador_intro",
      "activity_experience": {
        "packing": 8,
        "unloading": 14
      },
      "learned_abilities": [
        {
          "id": "ability.neat_knot",
          "name": "Ровный узелок",
          "source": {
            "type": "activity_mastery",
            "activity": "packing",
            "supporting_events": ["event.pack_042", "event.pack_057"]
          }
        }
      ],
      "ability_opportunities": [
        {
          "id": "opportunity.soft_packing_practice",
          "source_type": "research_enabled_training",
          "expires": null,
          "pressure_free": true
        }
      ]
    }
  ],
  "ability_source_events": [
    {
      "id": "event.fruit_001",
      "type": "tree_inspiration",
      "theme": "patience",
      "quality": "rare",
      "generosity": "double",
      "dog_ids": ["dog.labrador_intro"]
    }
  ]
}
```

Workbench should help Game Designer inspect:

- why an ability appeared;
- what source contributed;
- whether randomness is too opaque;
- whether dogs are becoming stat units;
- whether non-speed abilities are common enough;
- whether the loop creates pressure.

---

## 10. Relationship to Ability Catalog

R-11 must create the first catalog using this source philosophy.

Catalog entries should include:

```text
id
player-facing name
term type: habit / skill / talent / favorite trick / small secret
source categories
matching dog history
mechanical effect
visible behavior expression
non-speed axis yes/no
ethical notes
```

Every catalog entry should answer:

> What story could explain why this dog learned this?

If no warm story exists, the ability probably does not belong in Shelter.

---

## 11. Relationship to Laboratory

Laboratory should not be a cold upgrade factory.

Better framing:

- notes table;
- recipe corner;
- co-op learning board;
- gentle experiments;
- safer tools;
- better routines.

Lab unlocks possibilities, not instant dog rewrites.

Example:

```text
Research node: Спокойная дальняя дорога
Unlocks route training opportunities for dogs with travel experience.
```

---

## 12. Relationship to buildings and activities

Buildings and activities are the places where dog stories happen.

Possible links:

- Kitchen creates cooking habits;
- Packing Table creates careful packaging habits;
- Road Sign creates route habits;
- Storage creates unloading/carrying habits;
- trees create inspiration/care habits;
- Lab creates research-enabled opportunities;
- comfort areas create care-based strengths.

Buildings should not directly print abilities.

Better:

```text
Building enables activity
-> activity creates experience
-> source event creates opportunity
-> dog forms learned ability
```

---

## 13. Out of scope

This document does not define:

- final ability list;
- exact probability math;
- exact fruit growth timings;
- exact tree types;
- final laboratory tree;
- full equipment catalog;
- numerical balance;
- Codex implementation task;
- State Connector schema change request;
- UI layout;
- art requirements.

---

## 14. Open questions for R-11

1. What are the first 20–30 learned abilities/habits?
2. What percentage of first catalog should be non-speed effects?
3. Which abilities come from work only?
4. Which require research unlock?
5. Which require tree/fruit inspiration?
6. Which require mentorship or friendship?
7. How many ability opportunities can be visible before the player feels overwhelmed?
8. Are learned abilities unlimited, slotted, grouped, or tiered?
9. Should fruit quality affect option quality, chance, or story richness?
10. How do we present rarity without making low-rarity outcomes feel bad?
11. Which ability source events must appear first in Workbench?

---

## 15. Acceptance criteria

R-10 is complete enough to move to R-11 when:

1. Ability acquisition is defined as story/history formation, not direct loot grant.
2. Source categories are defined.
3. Tree/fruit inspiration model is accepted as a promising direction with ethical boundaries.
4. Fruit quality and generosity are defined at concept level.
5. Mentorship, friendship and care are included as valid sources.
6. No paid gacha/reroll/pressure patterns are allowed.
7. At least half of future first catalog is required to be non-speed effects.
8. Workbench data direction is sketched without creating immediate Codex task.
9. R-11 has clear open questions and catalog field requirements.

## 16. Next recommended document

Next Game Designer task:

```text
STEAM_DESKTOP__Ability_Catalog_v1.md
```

R-11 should create the first catalog of dog learned abilities/habits using this source model.

---

## 17. Changelog

### 2026-06-30 — v1 created

- Created Ability Source Loop v1.
- Reframed abilities as learned habits / skills / talents formed through dog history.
- Defined work, research, finds, mentorship, friendship, care, routes and trees as source categories.
- Accepted tree/fruit idea as inspiration loop, not direct gacha-like ability drop.
- Added fruit quality and generosity concept boundaries.
- Added Workbench data direction and R-11 catalog requirements.
