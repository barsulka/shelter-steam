# STEAM_DESKTOP — Dog Life Model / Life in the Co-op v1

Дата: 2026-06-30
Роль документа: Game Design / Systems Design Contract
Статус: draft v1
Продукт: Steam/Desktop idle always-on-top strip
Roadmap task: R-14 — Activities Catalog
Роль-владелец: Game Designer / Systems Designer

Основано на:

- `STEAM_DESKTOP__Dog_Progression_Model_v1.md`
- `STEAM_DESKTOP__Ability_Source_Loop_v1.md`
- `STEAM_DESKTOP__Ability_Catalog_v1.md`
- `STEAM_DESKTOP__Game_Design_Roadmap_v2.md` for current activation boundaries
- D-009, D-010, D-018, D-019

---

## 0. Назначение

Этот документ заменяет узкий подход “Activities Catalog” более правильной моделью:

> Мы проектируем не фабрику. Мы проектируем жизнь собачьего кооператива.

Activities Catalog остаётся частью документа, но не является главным смыслом. Главное — описать, как проходит хороший день собаки, какие виды жизни существуют в кооперативе, и как из этой жизни естественно рождаются работа, производство, умения, отношения, уют и прогресс.

Ключевой принцип:

> В Shelter игрок оптимизирует не производство. Игрок создаёт условия, в которых собакам хорошо жить, дружить, учиться и помогать друг другу. Производство — естественное следствие этой жизни.

---

## 1. Interface model: main strip + room windows

Dog life model MUST respect Steam/Desktop interface constraints.

Shelter uses two interface layers:

1. Main strip — compact always-on-top production/co-op layer.
2. Room window / detail window — inspectable interior layer opened by clicking a dog house, building or production anchor.

Idle in Shelter means that dog life continues on its own, while the player can observe it and gently guide it.

### 1.1 Main strip responsibility

Main strip SHOULD show:

- travel;
- unload;
- carry;
- production handoff;
- delivery readiness;
- small ambient gestures;
- visible dog movement;
- clear production anchors.

Main strip SHOULD NOT show full interior scenes, long conversations, deep room decoration, classroom scenes or complex multi-room life.

### 1.2 Room window responsibility

Room windows MAY show the richer life model:

- dog living rooms;
- production rooms;
- laboratory rooms;
- classroom / training room;
- library / self-learning room;
- room decoration;
- dogs sitting, learning, reading, working, helping and resting;
- several dogs contributing to the same building/system.

Examples:

- Dog House opens rooms where current dogs live and can decorate their spaces.
- Laboratory opens multiple rooms: lab, classroom, library.
- Production building opens one or more production rooms where assigned dogs work or train.

### 1.3 Production implication

In Shelter, a building does not produce by itself.

Correct framing:

```text
Dogs produce here.
Dogs learn here.
Dogs rest here.
Dogs help each other here.
```

Buildings and rooms create conditions for dog life and work.

### 1.4 Reference folder

Room-window references live here:

```text
docs/drive/Shelter/03_DESIGN/01_REFERENCES/screenshots/room_window_references/
```

These references are structural UI/UX references, not final art-style targets.

---

## 2. Why this matters

Если проектировать игру как список задач, получится холодная схема:

```text
UnloadTask
CarryTask
CookTask
PackTask
IdleTask
```

Это полезно для Codex и runtime, но недостаточно для Game Design.

Для игрока это должно ощущаться иначе:

```text
Помочь разгрузить велосипед
Отнести тыкву на кухню
Помочь приготовить тёплую смесь
Аккуратно завязать мешочек
Посидеть рядом с кухней
```

Техническая задача — это implementation layer.

Игровая активность — это фрагмент жизни собаки.

---

## 3. Design principle: day of a dog

Основной вопрос для проектирования активностей:

> Как проходит хороший день собаки?

Примерный день:

```text
проснулась
-> поздоровалась
-> посидела рядом
-> подошла к Road Sign
-> получила работу
-> съездила на ферму
-> вернулась
-> помогла разгрузить
-> отнесла ресурс
-> помогла на кухне
-> поиграла
-> посмотрела на дерево
-> помогла другой собаке
-> отдохнула
-> легла спать / ушла в спокойный idle
```

Игрок не обязан постоянно управлять этим днём.

Игрок мягко создаёт условия:

- выбирает маршрут;
- строит / улучшает места;
- открывает новые routines;
- поддерживает собак;
- выбирает, что поощрить;
- иногда вручает вспомогалку;
- отправляет поставку.

---

## 4. Life categories

Жизнь кооператива делится на большие категории.

### 3.1 Производство

Действия, которые создают вещи или двигают ресурсную цепочку.

Examples:

- съездить за ресурсами;
- разгрузить велосипед;
- отнести ресурс;
- помочь на кухне;
- смешать корм;
- фасовать мешочек;
- загрузить фургон;
- подготовить ленточку / ярлычок.

### 3.2 Забота

Действия, которые помогают другим собакам или делают работу мягче.

Examples:

- подождать напарника;
- помочь закончить длинную задачу;
- принести воды;
- проверить, не устала ли другая собака;
- поддержать новичка;
- побыть рядом во время сложной работы.

### 3.3 Исследование

Действия, которые открывают новое.

Examples:

- понюхать новый предмет;
- посмотреть на незнакомый маршрут;
- заметить необычный плод;
- проверить странную записку;
- принести идею к research board;
- попробовать новый способ упаковки.

### 3.4 Обучение

Действия, через которые собака осваивает умения.

Examples:

- повторить за опытной собакой;
- потренироваться завязывать мешочки;
- проверить корзинку перед дорогой;
- учиться спокойно завершать длинную задачу;
- попробовать новый research-enabled method.

### 3.5 Отдых

Действия, которые восстанавливают, создают ритм и убирают ощущение фабрики.

Examples:

- лежать на коврике;
- смотреть на дождь;
- греться у лампы;
- нюхать цветы;
- спать;
- сидеть рядом со Storage;
- отдыхать после длинной поездки.

### 3.6 Общение

Действия между собаками.

Examples:

- познакомиться;
- посидеть рядом;
- обменяться игрушкой;
- показать находку;
- вместе ждать фургон;
- встретить вернувшуюся собаку.

### 3.7 Уют

Действия, которые делают кооператив приятнее.

Examples:

- поправить коврик;
- поставить кружку;
- повесить ленточку;
- посадить цветок;
- зажечь фонарик;
- разложить инструменты;
- украсить Packing Table.

### 3.8 Особые события

Редкие красивые моменты, которые создают историю.

Examples:

- редкая привычка раскрылась после долгой работы;
- две собаки научились работать вместе;
- вырос необычный плод вдохновения;
- пришла особенно тёплая открытка;
- собака нашла маленький секрет маршрута.

---

## 5. Activity outcome model

Любая активность может иметь до четырёх типов результата.

### 4.1 Что произвели?

Материальный или системный output.

Examples:

- ресурс;
- Food Mix;
- Food Bag;
- research clue;
- prepared station;
- comfort object;
- delivery completion.

### 4.2 Кто стал лучше?

Dog progression output.

Examples:

- activity experience;
- learned habit opportunity;
- confidence;
- preference discovery;
- route familiarity;
- mentorship progress.

### 4.3 Что изменилось в отношениях?

Social/co-op output.

Examples:

- friendship progress;
- mentorship progress;
- cooperative habit opportunity;
- another dog receives support;
- smoother handoff.

### 4.4 Что изменилось в кооперативе?

World/co-op output.

Examples:

- more comfort;
- reduced local friction;
- station becomes familiar;
- work area looks cared for;
- future opportunity appears.

Важно: activity does not need all four outputs every time. But good Shelter activities should often touch more than one layer.

---

## 6. Activity card template

Каждая activity должна описываться человечески, а не только технически.

Template:

```text
Название:
Что делает собака?
Почему она это делает?
Что она чувствует / какое состояние выражает?
Что получает сама собака?
Что получает кооператив?
Что получают другие собаки?
Какие черты характера проявляются?
Какие вспомогалки помогают?
Какие игровые эффекты возможны?
Какие technical tasks могут это реализовать?
Что не должно произойти?
```

Gameplay effects are intentionally late in the template. First comes dog life.

---

## 7. First activity catalog

### 6.1 Помочь разгрузить велосипед

Category: Производство / Забота

Что делает собака?

- Подходит к вернувшемуся велосипеду.
- Берёт ящик.
- Несёт его в Storage.

Почему?

- Помогает кооперативу начать поставку.

Что чувствует?

- Полезность, участие.

Что получает собака?

- unloading experience;
- carrying experience;
- шанс раскрыть аккуратность / надёжность.

Что получает кооператив?

- Oat / Pumpkin enter Storage.

Что получают другие собаки?

- Kitchen chain can start sooner.

Черты:

- Забота;
- Надёжность;
- Аккуратность.

Вспомогалки:

- маленькая тележка;
- удобная шлейка;
- знакомый Storage.

Technical tasks:

- UnloadTask;
- CarryTask.

Must not:

- teleport resources to Storage.

### 6.2 Проверить корзинку перед дорогой

Category: Производство / Обучение

Что делает собака?

- Перед выездом проверяет корзинку велосипеда.

Почему?

- Хочет вернуться без забытых мелочей.

Что получает собака?

- travel preparation experience;
- possible learned habit `Проверяет корзинку`.

Что получает кооператив?

- smoother route preparation;
- lower soft route mishap chance.

Черты:

- Надёжность;
- Любопытство.

Вспомогалки:

- дорожный колокольчик;
- удобные тапочки;
- route checklist from research.

Technical tasks:

- pre-TripTask visible phase;
- route preparation state.

Must not:

- become mandatory micro-confirmation.

### 6.3 Отнести ингредиент на кухню

Category: Производство

Что делает собака?

- Берёт ресурс из Storage и несёт к Kitchen.

Почему?

- Помогает приготовить поставку.

Что получает собака?

- carrying experience;
- station familiarity.

Что получает кооператив?

- Kitchen input delivered.

Черты:

- Надёжность;
- Аккуратность;
- Терпение.

Вспомогалки:

- тележка;
- tidy Storage;
- знакомый маршрут внутри кооператива.

Technical tasks:

- CarryTask.

Must not:

- exist only as inventory number.

### 6.4 Помочь на кухне

Category: Производство / Обучение

Что делает собака?

- Помогает Kitchen превратить ingredients в Food Mix.

Почему?

- Готовит тёплую основу поставки.

Что получает собака?

- cooking/helping experience;
- possible careful production habit.

Что получает кооператив?

- Food Mix.

Черты:

- Терпение;
- Аккуратность;
- Уют.

Вспомогалки:

- мягкий рецепт;
- удобное рабочее место;
- research routine.

Technical tasks:

- CookTask.

Must not:

- create Food Bag directly.

### 6.5 Аккуратно завязать мешочек

Category: Производство / Обучение

Что делает собака?

- На Packing Table превращает Food Mix + Packaging Bag в Food Bag.

Почему?

- Чтобы поставка была аккуратной и тёплой.

Что получает собака?

- packing experience;
- chance for `Ровный узелок` habit.

Что получает кооператив?

- Food Bag.

Черты:

- Аккуратность;
- Терпение;
- Внимательность.

Вспомогалки:

- ленточная сумочка;
- research “мягкая фасовка”;
- tidy Packing Table.

Technical tasks:

- PackTask.

Must not:

- skip Packing Table.

### 6.6 Поддержать напарника

Category: Забота / Общение

Что делает собака?

- Подходит к другой собаке и остаётся рядом во время длинной задачи.

Почему?

- Вместе спокойнее.

Что получает собака?

- care experience;
- relationship progress;
- teamwork habit opportunity.

Что получает другая собака?

- calmer long-task flow;
- reduced blocked/friction risk.

Что получает кооператив?

- steadier work rhythm.

Черты:

- Забота;
- Уют;
- Терпение.

Вспомогалки:

- cozy corner nearby;
- warm snack;
- familiar station.

Technical tasks:

- SupportTask later;
- IdleTask variant in early prototype.

Must not:

- become required micromanagement.

### 6.7 Посмотреть, что придумали в лаборатории

Category: Исследование / Обучение

Что делает собака?

- Подходит к research board / lab corner and observes or tries a new routine.

Почему?

- Любопытно и полезно для кооператива.

Что получает собака?

- research familiarity;
- possible training opportunity.

Что получает кооператив?

- research insight / method progress.

Черты:

- Любопытство;
- Вдохновение;
- Внимательность.

Вспомогалки:

- notes board;
- gentle experiment tools;
- curious fruit inspiration.

Technical tasks:

- ResearchAssistTask later.

Must not:

- feel like cold sci-fi lab grind.

### 6.8 Ухаживать за деревом вдохновения

Category: Уют / Исследование / Забота

Что делает собака?

- Поливает, нюхает, сидит рядом, поправляет ленточку у дерева.

Почему?

- Дерево — часть спокойной жизни кооператива.

Что получает собака?

- tree care experience;
- comfort;
- possible inspiration relation.

Что получает кооператив?

- future fruit / inspiration opportunity.

Черты:

- Уют;
- Забота;
- Любопытство;
- Терпение.

Вспомогалки:

- лейка;
- мягкая лампа;
- любимое место.

Technical tasks:

- TreeCareTask later;
- IdleTask variant early.

Must not:

- become visible crop farming core loop for Steam resources;
- become gacha tree.

### 6.9 Поиграть с другой собакой

Category: Общение / Отдых

Что делает собака?

- Коротко играет, носит игрушку, приглашает другую собаку.

Почему?

- Собаки живут, а не только работают.

Что получает собака?

- comfort;
- relationship progress;
- possible cheerful/cooperative habit.

Что получает кооператив?

- warmer idle life;
- future friendship source.

Черты:

- Весёлость;
- Общительность;
- Уют.

Вспомогалки:

- игрушка;
- коврик;
- свободное время.

Technical tasks:

- SocialTask later;
- IdleTask variant early.

Must not:

- punish player for not scheduling play.

### 6.10 Отдохнуть у любимого места

Category: Отдых / Уют

Что делает собака?

- Лежит, сидит, смотрит на дождь, греется у лампы.

Почему?

- Хороший день включает отдых.

Что получает собака?

- comfort/recovery if system exists;
- preference expression;
- possible care-based strength.

Что получает кооператив?

- calmer rhythm;
- visible life between work tasks.

Черты:

- Уют;
- Терпение;
- Спокойствие.

Вспомогалки:

- лежанка;
- тёплая лампа;
- любимый коврик.

Technical tasks:

- RestTask later;
- IdleTask variant early.

Must not:

- become paid energy refill or absence punishment.

### 6.11 Показать находку

Category: Общение / Исследование / Щедрость

Что делает собака?

- Приносит маленькую находку другой собаке или к notice board.

Почему?

- Хочется поделиться.

Что получает собака?

- generosity expression;
- relationship progress;
- inspiration event.

Что получает кооператив?

- optional opportunity;
- story moment.

Черты:

- Щедрость;
- Любопытство;
- Вдохновение.

Вспомогалки:

- generous fruit;
- route familiarity;
- cozy board.

Technical tasks:

- ShareFindTask later;
- event-driven moment.

Must not:

- become mandatory rare loot loop.

### 6.12 Поправить рабочее место

Category: Уют / Производство

Что делает собака?

- Поправляет коврик, ленточку, tools, labels or small object near station.

Почему?

- Так приятнее работать.

Что получает собака?

- station familiarity;
- tidy habit opportunity.

Что получает кооператив?

- reduced local friction;
- warmer station identity.

Черты:

- Аккуратность;
- Уют;
- Хозяйственность.

Вспомогалки:

- station decor;
- tidy tool pouch;
- research routine.

Technical tasks:

- TidyStationTask later;
- IdleTask variant early.

Must not:

- turn decor into mandatory min-max power.

---

## 8. Relationship to technical tasks

Technical tasks remain useful, but they are not the player-facing design language.

Mapping example:

```text
Помочь разгрузить велосипед -> UnloadTask + CarryTask
Аккуратно завязать мешочек -> PackTask
Поддержать напарника -> SupportTask / IdleTask variant
Отдохнуть у любимого места -> RestTask / IdleTask variant
Показать находку -> ShareFindTask / event moment
```

Codex may implement technical tasks, but Game Designer should define life activity meaning first.

---

## 9. Workbench direction

Future Workbench should inspect both technical tasks and life activities.

Useful future fields:

```text
current_technical_task
current_life_activity
activity_category
activity_reason
activity_outputs
affected_dog_ids
trait_axes_expressed
helper_effects_active
progression_events
relationship_events
co_op_state_changes
```

Example:

```json
{
  "dog_id": "dog.labrador_intro",
  "current_life_activity": {
    "id": "activity.help_unload_bicycle",
    "name": "Помочь разгрузить велосипед",
    "category": ["production", "care"],
    "technical_task": "UnloadTask",
    "trait_axes_expressed": ["Забота", "Надёжность", "Аккуратность"],
    "outputs": {
      "produced": ["resource_added_to_storage"],
      "dog_growth": ["unloading_experience"],
      "relationship": [],
      "co_op": ["production_chain_can_start"]
    }
  }
}
```

This is not an immediate Codex task.

---

## 10. Design rules

1. Activity is a piece of dog life, not only task execution.
2. Work is only one part of life.
3. Every activity should answer why the dog does it.
4. Good activities can create resource, growth, relationship and co-op outputs.
5. Player should not micromanage every life activity.
6. Rest, play, care and social actions are real systems, not decoration.
7. No activity should punish the player with guilt.
8. No activity should require paid acceleration or paid reroll.
9. Technical task names should stay mostly internal.
10. If an activity only increases a number and tells no dog story, it is weak Shelter design.

---

## 11. Out of scope

This document does not define:

- final activity timing;
- exact balance values;
- all possible activities;
- final building system;
- final research tree;
- full economy;
- animation production list;
- visual art requirements;
- Codex implementation brief;
- State Connector schema change request.

---

## 12. Open questions

1. How many life activities should be visible in first systems expansion?
2. Which activities are automatic idle-life actions vs player-triggered meaningful choices?
3. How often should non-production activities occur without distracting from delivery loop?
4. Should support/social/rest actions ever block production, or only enrich it?
5. Which activity outputs should be inspectable in Workbench first?
6. How should Activities Catalog connect to Building System: does each building host life activities?
7. How should Laboratory unlock new activities without becoming cold upgrade tree?
8. Should every learned habit require at least one life activity source?
9. Should activity names be canonically Russian-first for player docs?
10. What is the minimal set of activity categories for first long-term loop?

---

## 13. Acceptance criteria

R-14 is complete enough to move forward when:

1. Activities are reframed as dog life activities, not only technical tasks.
2. The “day of a dog” principle is documented.
3. Life categories are defined.
4. Activity output model is defined.
5. Activity card template exists.
6. First activity catalog examples exist.
7. Relationship to technical tasks is clarified.
8. Workbench direction is sketched without immediate Codex task.
9. Design rules protect against factory/spreadsheet-first thinking.
10. Open questions for Buildings / Lab / Economy are listed.

---

## 14. Next recommended documents

Recommended next Game Designer tasks:

1. `STEAM_DESKTOP__Building_System_v1.md`
2. `STEAM_DESKTOP__Production_Chains_v1.md`
3. `STEAM_DESKTOP__Laboratory_Research_Tree_v1.md`

Reason:

Now that dog life activities exist, buildings should be designed as places where life happens, not only as production machines.

---

## 15. Changelog

### 2026-06-30 — room-window interface layer added

- Added main strip + room windows interface model.
- Fixed that rich dog-life theatre belongs in inspectable room/detail windows, not in the always-on-top main strip.
- Added Shelter idle formulation: dog life continues on its own, while player observes and gently guides it.
- Added room-window reference folder path.

### 2026-06-30 — v1 created

- Created Dog Life Model / Life in the Co-op v1.
- Reframed R-14 from narrow Activities Catalog into dog life model.
- Added design principle: player creates conditions for dogs to live, learn, befriend and help; production follows from that life.
- Added life categories, activity outcome model, activity card template and first activity examples.
- Added Workbench direction for life activity inspection.
