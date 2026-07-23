# STEAM_DESKTOP — Character Traits & Helper Effects Catalog v1

Дата: 2026-06-30
Роль документа: Game Design / Systems Design Catalog
Статус: draft v1
Продукт: Steam/Desktop idle always-on-top strip
Roadmap task: R-11 — Ability Catalog
Роль-владелец: Game Designer / Systems Designer

Основано на:

- `STEAM_DESKTOP__Dog_Progression_Model_v1.md`
- `STEAM_DESKTOP__Ability_Source_Loop_v1.md`
- `STEAM_DESKTOP__Game_Design_Roadmap_v2.md` for current activation boundaries
- `docs/drive/Shelter/00_START_HERE/02_DECISIONS.md` — D-010, D-018, D-019

---

## 0. Назначение

Этот документ задаёт первый каталог **черт характера** и связанных с ними игровых проявлений для собак Shelter.

Это не таблица RPG-способностей и не список статов.

Главный принцип:

> В Shelter игровые механики рождаются из характера собаки, а не наоборот.

Мы не придумываем бонус и ищем ему милое название. Мы сначала придумываем живую собаку и спрашиваем:

> Если бы такая собака действительно жила в нашем кооперативе, что бы у неё получалось чуть лучше, иначе или теплее остальных?

---

## 1. Термины

### 1.1 Черты характера

**Черты характера** — основной player-facing термин для устойчивых особенностей собаки.

Черта характера описывает, какая собака по своей природе или по раскрытому поведению:

- заботливая;
- любопытная;
- терпеливая;
- аккуратная;
- надёжная;
- весёлая;
- находчивая;
- спокойная;
- щедрая;
- внимательная.

Черты характера могут быть:

- врождёнными;
- раскрытыми через жизнь в кооперативе;
- усиленными опытом;
- проявленными через привычки и умения.

Черты характера MUST NOT be rerolled, deleted, replaced by equipment or treated as low-tier / high-tier stats.

### 1.2 Умения / привычки / таланты

**Умения**, **привычки**, **таланты**, **любимые приёмы** — конкретные gameplay manifestations of character traits.

Пример:

```text
Черта характера: Аккуратная + Терпеливая
Проявление: Ровный узелок
```

Умение может быть приобретённым, но оно должно выглядеть как следствие истории собаки.

### 1.3 Вспомогалки

**Вспомогалки** — рабочий системный термин для вещей, которые не меняют черты характера, но усиливают их проявление в конкретном контексте.

Вспомогалки включают:

- шмот;
- инструменты;
- еду;
- плоды;
- уютные предметы;
- временные эффекты;
- building/context boosts;
- research-enabled routines.

Пример:

```text
Легендарные ботиночки не делают собаку непоседливой.
Они усиливают проявление уже существующей любви к дальним прогулкам / непоседливости в travel activities.
```

Вспомогалка MAY:

- усилить черту в конкретной activity;
- открыть training opportunity;
- добавить временный акцент;
- повысить шанс проявления привычки;
- сделать действие удобнее.

Вспомогалка MUST NOT:

- заменить характер;
- удалить врождённую черту;
- превратить собаку в другой archetype;
- стать mandatory paid power;
- быть главным источником личности.

---

## 2. Three-level design model

Каждая механика собаки должна проектироваться через три уровня.

### 2.1 Level 1 — Кто эта собака?

Сначала описываем собаку языком характера:

```text
любопытная
терпеливая
аккуратная
заботливая
надёжная
непоседливая
щедрая
спокойная
```

### 2.2 Level 2 — Как это проявляется?

Потом описываем поведение:

```text
замечает необычное
проверяет корзинку перед дорогой
аккуратно завязывает мешочки
ждёт напарника перед тяжёлой разгрузкой
любит новые маршруты
```

### 2.3 Level 3 — Что это даёт системе?

И только потом формулируем механику:

```text
меньше blocked time
лучше long-task consistency
выше шанс extra non-critical find
лучше handoff между задачами
меньше waste/mishap
```

Игроку в первую очередь показываем Level 1/2. Workbench может видеть Level 3.

---

## 3. Character trait axes

Первый каталог строится вокруг десяти осей хорошести собаки.

Каждое конкретное умение SHOULD combine at least two axes.

Это защищает систему от плоских бонусов вроде `+10% speed`.

### 3.1 Скорость

Собака быстро собирается, бежит, возвращается или закрывает короткие задачи.

Speed is allowed but must not dominate.

Potential mechanics:

- shorter short-task duration;
- faster route preparation;
- faster short carry;
- quicker response to available task.

### 3.2 Аккуратность

Собака бережно обращается с вещами.

Potential mechanics:

- less waste/mishap;
- better packaging quality;
- fragile resource handling;
- better presentation of delivery.

### 3.3 Забота

Собака поддерживает других и делает кооператив мягче.

Potential mechanics:

- helps another dog recover;
- improves teamwork;
- reduces blocked/friction states;
- helps long tasks feel calmer.

### 3.4 Любопытство

Собака замечает необычное и любит новое.

Potential mechanics:

- extra non-critical finds;
- route scouting insights;
- research inspiration;
- discovers preferences or opportunities.

### 3.5 Терпение

Собака спокойно доводит длинные дела до конца.

Potential mechanics:

- long-task consistency;
- less interruption sensitivity;
- better waiting states;
- steady production tasks.

### 3.6 Надёжность

Собака редко забывает, возвращается вовремя и хорошо завершает цепочки.

Potential mechanics:

- fewer soft delays;
- better task handoff;
- predictable route outcome;
- less blocked recovery time.

### 3.7 Щедрость

Собака делится, приносит другим и создаёт возможности для команды.

Potential mechanics:

- shares inspiration fruit effect;
- creates two-dog opportunity;
- brings optional extra for another dog;
- improves cooperative yield without pressure.

### 3.8 Находчивость

Собака иногда находит другой способ.

Potential mechanics:

- alternate route around blockage;
- converts minor blocked state into different task;
- finds substitute non-critical material;
- makes better use of existing resources.

### 3.9 Вдохновение

Собака помогает появляться новым идеям.

Potential mechanics:

- research insight events;
- unlocks training opportunity;
- makes tree/fruit outcomes more interesting;
- helps another dog learn.

### 3.10 Уют

Собака делает место спокойнее и приятнее.

Potential mechanics:

- improves rest quality;
- reduces mood/comfort drain if implemented;
- makes idle state feel warmer;
- improves comfort-based progression.

---

## 4. First character trait catalog

This section lists first trait archetypes. These are not final dog generation weights; they are design vocabulary.

### 4.1 Заботливая

Looks like:

- notices when another dog is stuck;
- waits nearby;
- brings small helpful things;
- creates calmer team moments.

Natural axes:

- Забота;
- Щедрость;
- Уют.

Natural mechanics:

- support another dog in long task;
- reduce blocked time for nearby task;
- create cooperative training opportunity.

### 4.2 Любопытная

Looks like:

- checks new objects;
- looks at road signs;
- notices unusual fruit / note / route clue.

Natural axes:

- Любопытство;
- Находчивость;
- Вдохновение.

Natural mechanics:

- extra non-critical find;
- route insight;
- research hint;
- discovers activity preference faster.

### 4.3 Терпеливая

Looks like:

- calmly finishes long tasks;
- waits near station without fuss;
- does careful repetitive work.

Natural axes:

- Терпение;
- Надёжность;
- Уют.

Natural mechanics:

- long-task consistency;
- lower interruption risk;
- better production chain stability.

### 4.4 Аккуратная

Looks like:

- ties bags neatly;
- places crates gently;
- keeps table tidy.

Natural axes:

- Аккуратность;
- Терпение;
- Надёжность.

Natural mechanics:

- less mishap/waste;
- better packaging quality;
- fragile resource handling.

### 4.5 Надёжная

Looks like:

- checks the route twice;
- returns to finish what started;
- rarely causes surprise delays.

Natural axes:

- Надёжность;
- Терпение;
- Аккуратность.

Natural mechanics:

- better route consistency;
- smoother task chain;
- lower blocked recovery time.

### 4.6 Весёлая

Looks like:

- brings energy to idle moments;
- makes other dogs react;
- turns routine into a small good moment.

Natural axes:

- Уют;
- Забота;
- Вдохновение.

Natural mechanics:

- improves rest/comfort moments;
- creates small morale event;
- helps other dogs recover from long work.

### 4.7 Находчивая

Looks like:

- finds another way when something is missing;
- notices substitute tools;
- uses route knowledge creatively.

Natural axes:

- Находчивость;
- Любопытство;
- Надёжность.

Natural mechanics:

- alternate soft solution to blocked state;
- non-critical substitute find;
- smoother recovery from missing optional input.

### 4.8 Смелая

Looks like:

- confidently tries new route;
- is first to approach unfamiliar prop;
- helps start new activity.

Natural axes:

- Любопытство;
- Надёжность;
- Скорость.

Natural mechanics:

- better first-time route handling;
- lower uncertainty for new activity;
- faster activity start in new context.

Note: “смелая” must not be combat-coded.

### 4.9 Спокойная

Looks like:

- settles near busy stations;
- helps others not rush;
- waits without creating pressure.

Natural axes:

- Уют;
- Терпение;
- Забота.

Natural mechanics:

- improves long-task rhythm;
- reduces visual/behavioral chaos;
- supports another dog in blocked/waiting state.

### 4.10 Общительная

Looks like:

- likes working near others;
- checks on teammate;
- starts cooperative tasks naturally.

Natural axes:

- Забота;
- Щедрость;
- Вдохновение.

Natural mechanics:

- mentorship opportunities;
- friendship-based learned habits;
- better handoff between dogs.

### 4.11 Хозяйственная

Looks like:

- keeps Storage sensible;
- notices missing bag/label/tool;
- likes putting things in place.

Natural axes:

- Аккуратность;
- Надёжность;
- Находчивость.

Natural mechanics:

- fewer storage blocked states;
- earlier preparation of required resource;
- better queue readiness.

### 4.12 Внимательная

Looks like:

- notices small changes;
- catches mistakes before they matter;
- remembers what another dog needs.

Natural axes:

- Аккуратность;
- Любопытство;
- Забота.

Natural mechanics:

- reduces mishap;
- improves task handoff;
- discovers small hidden opportunities.

### 4.13 Щедрая

Looks like:

- shares finds;
- brings something for another dog;
- creates two-dog moments.

Natural axes:

- Щедрость;
- Забота;
- Уют.

Natural mechanics:

- increases generosity of inspiration moment;
- turns one opportunity into shared opportunity;
- improves cooperative effects.

### 4.14 Упрямая в хорошем смысле

Looks like:

- does not give up easily;
- returns to finish difficult task;
- keeps trying calmly.

Natural axes:

- Терпение;
- Надёжность;
- Находчивость.

Natural mechanics:

- better recovery from soft blockage;
- long-task completion stability;
- finds alternate simple path.

### 4.15 Мечтательная

Looks like:

- pauses near trees/window/notice board;
- notices patterns;
- brings surprising ideas.

Natural axes:

- Вдохновение;
- Любопытство;
- Уют.

Natural mechanics:

- research inspiration;
- tree/fruit thematic discovery;
- unlocks gentle story/training opportunity.

---

## 5. First learned habits / talents examples

These are first candidate entries for R-11 catalog. They are examples and starting content, not final balance.

### 5.1 Ровный узелок

Type: learned habit
Axes:

- Аккуратность;
- Терпение.

Story:

The dog spent many packing sessions at Packing Table and started tying bags neatly without being asked.

Source categories:

- work;
- activity experience;
- research-enabled training optional.

Mechanical direction:

- improves packaging quality;
- reduces small packing mishap;
- may make postcard/delivery presentation warmer.

Visible behavior:

- dog pauses briefly to tidy the bag ribbon.

### 5.2 Проверяет корзинку

Type: learned habit
Axes:

- Надёжность;
- Любопытство.

Story:

Before route departure, the dog learned to check the basket for missing small supplies.

Source categories:

- route familiarity;
- travel experience;
- mentorship optional.

Mechanical direction:

- reduces minor route delay;
- small chance to prevent forgotten optional item.

Visible behavior:

- dog sniffs/checks basket before leaving.

### 5.3 Знакомая тропинка

Type: learned route habit
Axes:

- Любопытство;
- Находчивость.

Story:

After many trips to the same place, the dog remembers a calm path.

Source categories:

- route repetition;
- route familiarity;
- dog curiosity.

Mechanical direction:

- smoother repeat route outcome;
- possible non-critical extra find.

Visible behavior:

- route card may show “знакомая дорога”.

### 5.4 Тёплый напарник

Type: cooperative habit
Axes:

- Забота;
- Уют.

Story:

The dog learned to stay near a teammate during longer work.

Source categories:

- friendship;
- mentorship;
- shared long tasks.

Mechanical direction:

- another dog handles long task more calmly;
- reduces waiting/block friction nearby.

Visible behavior:

- dog waits nearby or briefly checks on partner.

### 5.5 Сначала тяжёлое

Type: work habit
Axes:

- Надёжность;
- Аккуратность.

Story:

During unloads, the dog learned to place heavier crates first.

Source categories:

- unload activity experience;
- mentorship.

Mechanical direction:

- smoother unload sequence;
- less storage clutter/blocking.

Visible behavior:

- dog prioritizes crate placement order.

### 5.6 Маленькая находка

Type: curiosity talent
Axes:

- Любопытство;
- Щедрость.

Story:

The dog likes bringing home small useful extras for the co-op.

Source categories:

- route find;
- tree/fruit inspiration;
- curiosity trait.

Mechanical direction:

- occasional non-critical extra find;
- extra is cozy/helpful, not mandatory progression.

Visible behavior:

- dog returns with a small side item or note.

### 5.7 Спокойно доделывает

Type: long-task habit
Axes:

- Терпение;
- Надёжность.

Story:

The dog learned to finish long tasks without rushing.

Source categories:

- long activity experience;
- care/rest support;
- patience-themed fruit.

Mechanical direction:

- long tasks are more consistent;
- less interruption / blocked recovery.

Visible behavior:

- dog keeps a steady work pose instead of abrupt task shifts.

### 5.8 Делится вдохновением

Type: inspiration habit
Axes:

- Щедрость;
- Вдохновение.

Story:

After caring for inspiration trees, the dog started turning good finds into shared moments.

Source categories:

- tree inspiration;
- generosity fruit;
- friendship.

Mechanical direction:

- an inspiration opportunity can involve one more dog;
- supports cooperative ability formation.

Visible behavior:

- dog brings fruit/idea to another dog instead of using it alone.

### 5.9 Ласковый контроль

Type: support habit
Axes:

- Забота;
- Внимательность.

Story:

The dog quietly notices when a teammate is about to miss a step.

Source categories:

- teamwork;
- mentorship;
- care.

Mechanical direction:

- reduces small task handoff mistakes;
- improves nearby cooperative task reliability.

Visible behavior:

- dog turns toward teammate before handoff.

### 5.10 Всегда на месте

Type: reliability habit
Axes:

- Надёжность;
- Уют.

Story:

The dog likes staying near a familiar station and is easy to find when work starts.

Source categories:

- station familiarity;
- comfort;
- repeated activity.

Mechanical direction:

- faster assignment to familiar station;
- reduced idle-to-task friction.

Visible behavior:

- dog idles near favorite workplace.

### 5.11 Бережные лапы

Type: careful handling habit
Axes:

- Аккуратность;
- Забота.

Story:

The dog learned to handle fragile or special supplies gently.

Source categories:

- careful carrying;
- fragile resource events;
- mentorship.

Mechanical direction:

- fewer mishaps with special materials;
- better quality preservation.

Visible behavior:

- slower, careful carry pose.

### 5.12 Быстрый старт

Type: light speed habit
Axes:

- Скорость;
- Надёжность.

Story:

The dog likes being ready as soon as the route is chosen.

Source categories:

- travel experience;
- route preparation.

Mechanical direction:

- shorter preparation time;
- does not affect all task types.

Visible behavior:

- dog trots to transport immediately.

### 5.13 Не забывает ярлычок

Type: packing habit
Axes:

- Внимательность;
- Аккуратность.

Story:

The dog remembers to add small labels to finished help packages.

Source categories:

- packing experience;
- research-enabled routine.

Mechanical direction:

- improves delivery presentation;
- may unlock warmer postcard variant.

Visible behavior:

- dog taps/places a small label before load.

### 5.14 Чует хорошее место

Type: route / tree habit
Axes:

- Любопытство;
- Вдохновение.

Story:

The dog notices calm places where something good might grow or be found.

Source categories:

- routes;
- tree care;
- finds.

Mechanical direction:

- discovers optional tree/fruit opportunity;
- improves non-critical inspiration events.

Visible behavior:

- dog pauses and points/sniffs near route sign or garden corner.

### 5.15 Мягкий ритм

Type: comfort habit
Axes:

- Уют;
- Терпение.

Story:

The dog settles into a calm working rhythm that helps the whole station feel less rushed.

Source categories:

- care;
- long work;
- comfort area.

Mechanical direction:

- reduces perceived task chaos;
- improves station steady throughput without harsh speed framing.

Visible behavior:

- steadier animation/idle near station.

---

## 6. Helper effects / вспомогалки

Вспомогалки are not character traits. They modify contexts where traits express themselves.

### 6.1 Equipment helpers

Examples:

- `Удобные тапочки` — supports Скорость / Уют in short walking and route preparation.
- `Дорожный колокольчик` — supports Надёжность / Любопытство in travel preparation.
- `Мягкая шлейка` — supports Терпение / Уют in longer routes.
- `Ленточная сумочка` — supports Аккуратность / Внимательность in packing.
- `Тёплый жилет` — supports Уют / Терпение during long outdoor tasks.

Rule:

Equipment helps a dog express a trait; it does not grant that trait as identity.

### 6.2 Food / fruit helpers

Examples:

- patience fruit tea — supports Терпение-themed training moment;
- curiosity berry treat — supports Любопытство-themed discovery opportunity;
- generous fruit bowl — supports Щедрость / cooperative opportunity;
- cozy warm snack — supports Уют / rest recovery.

Rule:

Fruit creates inspiration or opportunity; it does not directly install personality.

### 6.3 Building helpers

Examples:

- tidy Packing Table supports Аккуратность expressions;
- familiar Road Sign supports Надёжность / travel habits;
- cozy rest corner supports Уют / care-based strengths;
- research board supports Вдохновение / curiosity opportunities.

Rule:

Buildings create contexts for traits and habits to appear.

### 6.4 Research helpers

Examples:

- “Мягкая фасовка” enables careful packing opportunities;
- “Спокойная дальняя дорога” enables travel patience habits;
- “Добрые заметки” enables inspiration/research sharing opportunities.

Rule:

Research unlocks methods and opportunities, not instant dog rewrites.

---

## 7. Rarity language

Avoid:

```text
legendary ability
epic stat
rare power
```

Prefer:

```text
редкая привычка
особенная сильная сторона
редкий талант
тёплая история
необычный приём
```

Rarity should describe story uncommonness, not power hierarchy.

Low-rarity outcomes must still feel useful and warm.

---

## 8. Catalog rules

1. Every habit should map to at least two trait axes.
2. At least half of first catalog should be non-speed.
3. Every habit needs a warm story.
4. Every helper must modify expression, not identity.
5. No paid randomness.
6. No bad dogs.
7. No hard requirement for rare/legendary outcomes.
8. Player-facing names should be warm and behavior-first.
9. Workbench may expose mechanic tags; player UI should not become spreadsheet.
10. A habit without visible/behavioral expression is lower priority.

---

## 9. Suggested first implementation slice for Workbench later

This is not an immediate Codex task.

When Codex eventually expands `/state.dogs[]`, first useful fields for R-11 would be:

```text
character_traits
learned_habits
helper_effects
trait_axes
habit_sources
current_activity
recent_progression_events
```

Example:

```json
{
  "id": "dog.labrador_intro",
  "character_traits": ["Аккуратная", "Заботливая"],
  "learned_habits": [
    {
      "id": "habit.neat_knot",
      "name": "Ровный узелок",
      "axes": ["Аккуратность", "Терпение"],
      "source": "packing_activity_experience"
    }
  ],
  "helper_effects": [
    {
      "id": "helper.ribbon_pouch",
      "affects_axes": ["Аккуратность", "Внимательность"],
      "context": "packing"
    }
  ]
}
```

---

## 10. Out of scope

This document does not define:

- exact numeric values;
- final rarity math;
- final equipment catalog;
- final food/fruit catalog;
- dog generation system;
- UI layout;
- Codex implementation brief;
- State Connector schema change;
- art requirements.

---

## 11. Next questions

1. Should each dog start with 1–3 visible character traits?
2. Should learned habits be unlimited or softly grouped?
3. Should helpers have visible rarity, or only quality/story descriptors?
4. How many helper effects can modify one habit before it feels like min-max?
5. Which 5–7 habits should be in the first playable systems expansion?
6. Which trait axes should be represented by the first 3 dogs?
7. Should “черты характера” include only positive/neutral traits, or also warm imperfections like “упрямая”? 
8. How should Dog Card show character without becoming a stat sheet?
9. Which terms should be player-facing Russian canon: умения, привычки, таланты, сильные стороны?
10. Should Workbench preserve English technical ids while player-facing docs use Russian terms?

---

## 12. Acceptance criteria

R-11 is complete enough to move forward when:

1. “Черты характера” is established as the main design term.
2. Helper effects / “вспомогалки” are clearly separated from character traits.
3. Character trait axes are defined.
4. First trait archetype catalog exists.
5. First learned habit examples exist.
6. Equipment/food/building/research helpers have clear boundaries.
7. Rarity language avoids “legendary ability” framing.
8. Catalog rules protect against stat-only design.
9. Workbench direction is sketched without immediate Codex task.
10. Next questions are listed for later systems work.

---

## 13. Changelog

### 2026-06-30 — v1 created

- Created first Character Traits & Helper Effects Catalog.
- Accepted `черты характера` as core player-facing design term.
- Added `вспомогалки` as separate layer for equipment/food/fruit/building/research helpers.
- Defined 10 trait axes and 15 first trait archetypes.
- Added 15 first learned habit examples.
- Added helper-effect boundaries and rarity language rules.
