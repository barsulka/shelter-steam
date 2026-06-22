# STEAM_DESKTOP — House of Curiosity / Research Tree v1

Дата: 2026-06-30
Роль документа: Game Design / Systems Design Contract
Статус: draft v1
Продукт: Steam/Desktop idle always-on-top strip
Roadmap task: R-13 — Laboratory / Research Tree
Роль-владелец: Game Designer / Systems Designer

Основано на:

- `STEAM_DESKTOP__Building_System_v1.md`
- `STEAM_DESKTOP__Production_Chains_v1.md`
- `STEAM_DESKTOP__Dog_Life_Model_v1.md`
- `STEAM_DESKTOP__Dog_Progression_Model_v1.md`
- `STEAM_DESKTOP__Ability_Source_Loop_v1.md`
- `STEAM_DESKTOP__Ability_Catalog_v1.md`
- `STEAM_DESKTOP__Game_Systems_Roadmap_v1.md`
- D-009, D-010, D-018, D-019

---

## 0. Назначение

Этот документ описывает систему исследований Steam/Desktop Shelter.

Важно: это не классическая “лаборатория” и не холодное tech tree.

Рабочее название здания:

> **Дом любопытства**

Главный принцип:

> Исследование в Shelter открывает не бонус. Исследование открывает новую часть жизни кооператива.

Если исследование ничего не меняет в жизни собак, а только увеличивает число, это плохое исследование.

---

## 1. Core concept

### 1.1 One building, many rooms

В проекте НЕ создаём несколько отдельных зданий для разных research branches.

Есть одно здание:

```text
Дом любопытства
```

Внутри него несколько комнат. Эти комнаты и являются замаскированными ветками развития.

Пример комнат:

- учебный класс;
- библиотека;
- комната заметок;
- мастерская мягких методов;
- уголок наблюдений;
- маленькая опытная кухня / пробный стол;
- архив открыток и историй, позже.

### 1.2 Rooms are branches

Классическое дерево исследований заменяется room-based progression:

```text
не вкладка “Production II”
а комната “Мастерская мягких методов”
```

```text
не вкладка “Dog Skills”
а комната “Учебный класс”
```

```text
не вкладка “Discovery”
а комната “Библиотека / Комната заметок”
```

Игрок отправляет собак в разные комнаты. Это и создаёт развитие по направлениям.

### 1.3 Dogs learn here

Дом любопытства не исследует сам.

Собаки:

- читают;
- пробуют;
- смотрят;
- стоят у доски;
- показывают другим;
- записывают идеи;
- помогают друг другу;
- изучают мягкие routines.

Correct framing:

```text
Собака учится в классе.
Собака читает в библиотеке.
Собака помогает у доски.
Собаки вместе придумывают новый способ фасовки.
```

Avoid:

```text
Лаборатория производит research points.
Tech tree даёт +10%.
```

---

## 2. Naming and tone

Preferred names for the building:

- Дом любопытства;
- Дом знаний;
- Дом идей;
- Дом заметок;
- Учёный домик, if tone works later.

Avoid as player-facing primary name:

- Лаборатория;
- Research Lab;
- Tech Lab;
- Upgrade Factory.

Reason:

“Лаборатория” легко уводит в холодный sci-fi/optimization tone. Shelter needs a place of curiosity, learning and gentle routines.

Technical docs MAY still use `research` internally.

---

## 3. What research means in Shelter

Research means:

```text
кооператив научился делать что-то лучше, мягче, аккуратнее или интереснее
```

Research unlocks:

- new activities;
- new room stations;
- new helper effects;
- new training opportunities;
- new production routines;
- new comfort routines;
- new ways for dogs to help each other;
- new chain families;
- new story/postcard/archive features.

Research SHOULD NOT unlock only raw numeric bonuses.

---

## 4. Room branches

### 4.1 Учебный класс

Branch fantasy:

- собаки учатся новым привычкам и routines.

Dog activities:

- сидит за партой;
- смотрит на доску;
- повторяет за другой собакой;
- помогает новичку;
- тренирует привычку.

Unlocks:

- learned habit opportunities;
- mentorship routines;
- classroom assignments;
- dog training moments.

Traits expressed:

- Терпение;
- Внимательность;
- Забота;
- Вдохновение.

Example research:

- `Проверяем корзинку перед дорогой`;
- `Учимся завязывать ровный узелок`;
- `Как помогать новичкам`.

### 4.2 Библиотека

Branch fantasy:

- собаки читают, смотрят картинки, находят идеи и учатся самостоятельно.

Dog activities:

- читает книжку;
- лежит у полки;
- приносит книгу другой собаке;
- открывает новую заметку;
- self-learning when unassigned.

Unlocks:

- passive/self-learning opportunities;
- curiosity events;
- route hints;
- research prerequisites;
- story fragments.

Traits expressed:

- Любопытство;
- Вдохновение;
- Уют;
- Терпение.

Example research:

- `Книжка про спокойные маршруты`;
- `Заметки о деревьях вдохновения`;
- `Альбом тёплых поставок`.

### 4.3 Комната заметок

Branch fantasy:

- место, где кооператив собирает идеи, открытки, наблюдения и маленькие открытия.

Dog activities:

- приносит записку;
- смотрит на доску;
- прикрепляет маленький листок;
- показывает находку;
- сравнивает route notes.

Unlocks:

- better planning visibility;
- new route/card information;
- delivery history;
- clue-based research;
- cooperative idea events.

Traits expressed:

- Любопытство;
- Внимательность;
- Щедрость;
- Вдохновение.

Example research:

- `Доска дорожных заметок`;
- `Как не забывать ярлычки`;
- `Что пишут в открытках`.

### 4.4 Мастерская мягких методов

Branch fantasy:

- место, где собаки придумывают более удобные и бережные способы работы.

Dog activities:

- пробует мягкую фасовку;
- проверяет удобную тележку;
- настраивает рабочее место;
- учится не мять упаковку;
- делает работу спокойнее.

Unlocks:

- production routines;
- quality improvements;
- safer handoffs;
- less blocked friction;
- careful work opportunities.

Traits expressed:

- Аккуратность;
- Терпение;
- Надёжность;
- Забота.

Example research:

- `Мягкая фасовка`;
- `Спокойная разгрузка`;
- `Удобная тележка`;
- `Порядок на складе`.

### 4.5 Уголок наблюдений

Branch fantasy:

- место, где собаки смотрят на деревья, маршруты, погоду и поведение кооператива.

Dog activities:

- наблюдает за деревом;
- смотрит в окно;
- нюхает новый плод;
- замечает закономерность;
- делится идеей.

Unlocks:

- inspiration tree improvements;
- fruit/inspiration opportunities;
- route observation;
- non-critical discovery events;
- cozy curiosity actions.

Traits expressed:

- Любопытство;
- Вдохновение;
- Уют;
- Находчивость.

Example research:

- `Как растёт терпение`;
- `Заметить хороший плод`;
- `Спокойное место у окна`.

### 4.6 Пробный стол / маленькая опытная кухня

Branch fantasy:

- маленький безопасный стол, где собаки пробуют новые рецепты и routines до main Kitchen.

Dog activities:

- нюхает новый ингредиент;
- пробует смешать маленькую порцию;
- сравнивает мягкие рецепты;
- учится аккуратно готовить.

Unlocks:

- recipe variants;
- Food Mix quality routines;
- care-food effects;
- training snacks / fruit tea moments.

Traits expressed:

- Аккуратность;
- Любопытство;
- Уют;
- Забота.

Example research:

- `Чай после дороги`;
- `Мягкая смесь для долгой поставки`;
- `Тёплая пауза перед упаковкой`.

### 4.7 Архив открыток и историй, later

Branch fantasy:

- место памяти кооператива.

Dog activities:

- смотрит открытку;
- приносит альбом;
- сидит рядом с другой собакой;
- вспоминает поставку.

Unlocks:

- postcard archive;
- delivery memories;
- story-based traits;
- community traditions.

Traits expressed:

- Уют;
- Щедрость;
- Забота;
- Вдохновение.

Status:

- later, not first implementation priority.

---

## 5. Research node template

Every research node should answer:

```text
Name:
Room branch:
What new life does this unlock?
What dogs do during research:
Which dogs/traits fit naturally:
Inputs required:
Time / activity requirement:
Output unlocked:
Does it create an activity, helper, room station, method, chain or story?
What changes in main strip:
What changes in room window:
What appears in Dog Card / Workbench:
Forbidden framing:
```

Most important question:

```text
What new life does this unlock?
```

If answer is only `+X%`, node should be redesigned.

---

## 6. First research catalog

### 6.1 Проверяем корзинку перед дорогой

Room:

- Учебный класс / Комната заметок.

Unlocks:

- route preparation activity;
- learned habit opportunity `Проверяет корзинку`.

Dogs do:

- look at route checklist;
- practice before bicycle departure;
- experienced dog shows another dog.

Inputs:

- repeated route activity;
- Road Sign familiarity.

Main strip change:

- optional pre-departure basket-check gesture.

Room window change:

- classroom board has route checklist.

### 6.2 Мягкая фасовка

Room:

- Мастерская мягких методов.

Unlocks:

- careful packing routine;
- habit opportunity `Ровный узелок`;
- better delivery presentation.

Dogs do:

- practice tying bag;
- compare ribbons;
- help another dog at table.

Inputs:

- packing activity experience;
- Packing Table unlocked.

Main strip change:

- dog pauses at Packing Table to finish bag neatly.

Room window change:

- packing practice station appears.

### 6.3 Спокойная разгрузка

Room:

- Мастерская мягких методов.

Unlocks:

- better unload sequence;
- storage blocked-state reduction opportunity;
- habit `Сначала тяжёлое`.

Dogs do:

- practice crate order;
- mentor dog shows novice.

Inputs:

- Storage;
- unload activity history.

Main strip change:

- unload order can become more readable and calm.

Room window change:

- small crate practice station.

### 6.4 Чай после дороги

Room:

- Пробный стол / маленькая опытная кухня.

Unlocks:

- rest/care activity after long route;
- care-based progression opportunity;
- comfort recovery, if mood/comfort exists later.

Dogs do:

- prepare simple tea/snack;
- sit together after route.

Inputs:

- route completion history;
- warm food/care resource later.

Main strip change:

- small rest gesture after long route, if space allows.

Room window change:

- rest/care station in Dog House or House of Curiosity.

### 6.5 Доска дорожных заметок

Room:

- Комната заметок.

Unlocks:

- route familiarity visibility;
- route clue events;
- better player understanding without spreadsheet.

Dogs do:

- pin note;
- show route find;
- compare small map.

Inputs:

- repeated route visits;
- route finds.

Main strip change:

- Road Sign may show “familiar route” hint.

Room window change:

- notes board fills with route memories.

### 6.6 Книжка про деревья вдохновения

Room:

- Библиотека / Уголок наблюдений.

Unlocks:

- tree care activity options;
- fruit theme discovery;
- inspiration opportunity clarity.

Dogs do:

- read near shelf;
- observe tree;
- bring note to garden corner.

Inputs:

- Inspiration Tree unlocked;
- curiosity event or route find.

Main strip change:

- tree care gesture becomes available.

Room window change:

- library shelf / observation note appears.

### 6.7 Как помогать новичкам

Room:

- Учебный класс.

Unlocks:

- mentorship activity;
- cooperative learning opportunities.

Dogs do:

- experienced dog stands near board;
- novice dog sits/tries;
- pair practices simple task.

Inputs:

- at least two dogs;
- one dog has relevant activity experience.

Main strip change:

- support/mentor gesture near station.

Room window change:

- classroom pair assignment.

### 6.8 Тёплая пауза перед упаковкой

Room:

- Пробный стол / Мастерская мягких методов.

Unlocks:

- short calm pause before long/quality packing;
- quality/story delivery variant.

Dogs do:

- pause near table;
- check bag and label;
- wait for helper.

Inputs:

- Packing Table;
- at least one completed delivery.

Main strip change:

- brief pre-pack pause gesture.

Room window change:

- packing room has warm routine.

### 6.9 Альбом тёплых поставок

Room:

- Архив открыток и историй.

Unlocks:

- postcard archive;
- delivery memories;
- possible story-based dog moments.

Dogs do:

- look at postcard;
- sit together;
- bring album.

Inputs:

- several deliveries completed.

Main strip change:

- no required change; optional postcard icon.

Room window change:

- archive shelf / album appears.

Status:

- later.

---

## 7. Progression model

### 7.1 Research is room work

Progress happens when dogs spend time in rooms or when co-op events create ideas.

Sources:

- dog assigned to a room;
- dog self-learning in a room;
- relevant production chain completed;
- route find;
- postcard/story event;
- tree/fruit inspiration;
- mentorship moment.

### 7.2 Dog assignment

Dogs can be sent to different rooms.

Assignment examples:

- curious dog -> Библиотека;
- careful dog -> Мастерская мягких методов;
- patient dog -> Учебный класс;
- cozy dog -> Пробный стол / чай routine;
- generous dog -> Архив / notes / mentorship.

Assignments can:

- speed up progress;
- improve output quality;
- unlock better opportunities;
- create dog-specific habits;
- generate relationship events.

Assignments MUST NOT:

- become mandatory worker slots for every research;
- punish player harshly for empty rooms;
- create min-max pressure;
- remove dogs from life completely.

### 7.3 Empty room behavior

If no dog works in a room:

- progress may pause calmly;
- or self-learning may continue slowly;
- or room waits until relevant event happens.

No guilt, no alarm.

---

## 8. Research graph model

The system may still have dependencies, but they should be presented as room growth, not abstract tech graph.

Internal model can be graph-like:

```text
node A unlocks node B
node B unlocks room station C
```

Player-facing presentation should be:

```text
В классе появилась новая доска.
В библиотеке нашли новую книжку.
В мастерской теперь можно попробовать мягкую фасовку.
```

### 8.1 Dependency types

Allowed dependencies:

- room level / room station;
- dog activity experience;
- completed production chain;
- route familiarity;
- previous research;
- tree/fruit inspiration;
- postcard/story milestone;
- dog trait/habit presence, used softly.

Avoid hard requirements that force perfect dog builds.

---

## 9. Output types

Research can unlock:

### 9.1 New activity

Example:

- `Выпить чай после дороги`.

### 9.2 New helper effect

Example:

- `Удобная шлейка supports long routes`.

### 9.3 New room station

Example:

- classroom board;
- library shelf;
- packing practice table.

### 9.4 New production method

Example:

- soft packing;
- calm unloading;
- tidy storage routine.

### 9.5 New learned habit opportunity

Example:

- `Ровный узелок`;
- `Проверяет корзинку`.

### 9.6 New visibility / planning

Example:

- route notes show familiarity;
- Workbench/player card has clearer state.

### 9.7 New story/memory layer

Example:

- postcard archive;
- delivery album;
- dog memory moment.

---

## 10. UI principles

### 10.1 Main strip

Main strip should show only compact results of research:

- new gesture;
- new station state;
- new ready indicator;
- improved visible routine;
- small room/building activity hint.

### 10.2 Room window

Room window can show:

- rooms;
- dogs assigned;
- progress;
- notes;
- learning animation;
- unlocked routines;
- room upgrades;
- next opportunities.

### 10.3 Player language

Prefer:

```text
Собаки придумали новый мягкий способ фасовки.
В библиотеке появилась книжка про спокойные маршруты.
Такса может потренироваться проверять корзинку.
```

Avoid:

```text
Research complete: Packing Speed +10%.
Unlock node 3B.
Upgrade lab tier.
```

---

## 11. Workbench direction

Future Workbench should inspect research as room-based learning.

Possible fields:

```text
curiosity_house
  rooms[]
    id
    type
    assigned_dogs[]
    current_research
    self_learning_state
    stations[]
    unlocked_routines[]
    progress_state
    recent_events[]
research_nodes[]
  id
  room_id
  state
  dependencies[]
  unlocks[]
  dog_contributors[]
  source_events[]
```

This is not an immediate Codex brief.

---

## 12. Design rules

1. One building: House of Curiosity.
2. Multiple rooms inside it act as disguised research branches.
3. Research unlocks life, not only numbers.
4. Dogs do research/learning; building does not do it alone.
5. Empty rooms are calm, not failures.
6. Dog assignment helps, but should not be harshly mandatory.
7. Research should create activities, routines, helpers, rooms, habits, stories or visibility.
8. Avoid sci-fi/cold lab tone.
9. Avoid `+X% only` nodes.
10. Avoid min-max research slots and paid acceleration pressure.

---

## 13. Out of scope

This document does not define:

- exact research costs;
- final timings;
- final room UI;
- full research graph;
- art style;
- Codex implementation brief;
- State Connector schema change;
- economy balance.

---

## 14. Open questions

1. What is the final player-facing name: Дом любопытства, Дом знаний, Дом идей or another?
2. Which rooms are available at first unlock?
3. Should Library allow self-learning while dogs are not assigned?
4. Should each dog have preferred learning rooms based on character traits?
5. How many simultaneous dog assignments are comfortable?
6. Should research completion create player choice or automatic unlock?
7. Which first 3 research nodes should enter playable systems expansion?
8. How should room progress be shown without becoming spreadsheet?
9. How much of research graph is visible to player?
10. Which research outputs feed R-15 economy/balance first?

---

## 15. Acceptance criteria

R-13 is complete enough to move to R-15 when:

1. Research is reframed from tech tree into House of Curiosity.
2. It is one building with multiple rooms, not several research buildings.
3. Rooms act as disguised research branches.
4. Dogs can be assigned to different rooms.
5. Research unlocks new life/routines/activities/helpers/stories, not only numbers.
6. First room catalog exists.
7. First research node catalog exists.
8. Assignment and empty-room rules are non-punitive.
9. Workbench direction is sketched without immediate Codex task.
10. Open questions are listed.

---

## 16. Next recommended document

Next Game Designer task:

```text
STEAM_DESKTOP__Economy_Balance_Foundations_v1.md
```

Reason:

Now that dog identity, ability sources, character traits, dog life, buildings, production chains and research are defined, the next step is to describe economy and balance without losing Shelter’s non-factory philosophy.

---

## 17. Changelog

### 2026-06-30 — v1 created

- Created House of Curiosity / Research Tree v1.
- Reframed Laboratory into one building with multiple rooms.
- Defined rooms as disguised research branches.
- Added first room catalog and first research node catalog.
- Added room assignment, non-punitive empty room behavior, output types and Workbench direction.
