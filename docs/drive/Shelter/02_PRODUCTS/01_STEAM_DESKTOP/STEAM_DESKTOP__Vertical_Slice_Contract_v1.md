# STEAM_DESKTOP — Vertical Slice Contract v1

Дата: 2026-06-28  
Роль документа: Product Contract / Game Design Contract / Dev-facing Scope Contract  
Статус: draft v1  
Продукт: Steam/Desktop idle always-on-top strip  
Обязателен для: Producer, Game Designer, Art Director, Codex  
Основано на: D-009, D-010, D-011, D-012, D-013; `STEAM_DESKTOP__MVP_Gameplay_Slice_v0`; `STEAM_DESKTOP__MVP_State_Machine_and_UX_Flow_v0`; `STEAM_DESKTOP__First_Day_MVP_v0`; `STEAM_DESKTOP__Prototype_Data_and_Task_Backlog_v0`

## 0. Purpose

Этот документ определяет единственный допустимый состав первого Vertical Slice Steam/Desktop-версии Shelter.

Vertical Slice — не бизнес-MVP, не полная первая игровая версия и не техническое демо окна.

Vertical Slice — это первый кусок игры, после которого человек должен понять:

> “Это маленький живой собачий кооператив внизу экрана. Я хочу оставить его жить рядом с рабочим столом.”

Этот документ является контрактом между продуктом, геймдизайном, арт-дирекшеном и разработкой.

Он определяет:

- что MUST существовать;
- что MUST происходить;
- что игрок MUST увидеть;
- что MUST NOT быть реализовано до завершения Vertical Slice;
- какие решения разработчик MUST NOT принимать самостоятельно.

Любая механика, сущность, UI-flow или art-scope, отсутствующие в этом документе, считаются out of scope для Vertical Slice.

## 1. Contract Language

В этом документе используются RFC-style ключевые слова:

- **MUST** — обязательно для Vertical Slice.
- **MUST NOT** — запрещено для Vertical Slice.
- **SHOULD** — желательно, если не ломает scope и UX.
- **MAY** — допустимо, но не требуется.

Если возникает конфликт между “быстрее реализовать” и этим контрактом, приоритет у контракта.

Если для продолжения разработки нужно принять новое игровое решение, Codex / developer MUST остановиться и вернуть вопрос Game Designer / Producer. Разработка MUST NOT расширять Vertical Slice по собственной инициативе.

## 2. Design Pillars

### 2.1 Living World

Vertical Slice MUST ощущаться как живой маленький мир, а не как таблица ресурсов.

Игрок SHOULD видеть, что кооператив существует и без постоянных кликов.

Если мир перестаёт выглядеть живым, решение считается неверным даже при технически корректной реализации.

### 2.2 Physical Actions

Работа MUST существовать физически.

Если задача занимает заметное время, игрок SHOULD видеть физическое действие собаки или объекта.

Vertical Slice MUST NOT использовать абстрактные мгновенные изменения там, где по дизайну должна быть видимая работа.

### 2.3 Dogs First

Главные герои Vertical Slice — собаки.

Не здания.  
Не интерфейс.  
Не ресурсы.  
Не транспорт.

Каждая важная сцена SHOULD быть читаема через действие собаки.

Если игрок перестаёт смотреть на собак, дизайн ошибся.

### 2.4 Calm Idle

Steam/Desktop игра MUST жить рядом с рабочим столом пользователя.

Vertical Slice MUST NOT требовать постоянного внимания.

Игра не должна кричать, давить, торопить или наказывать за отсутствие внимания.

### 2.5 Small Decisions, Autonomous Work

Игрок MUST принимать мягкие решения.

Собаки MUST выполнять физическую работу сами.

Игрок MUST NOT вручную переносить каждый ресурс, каждый мешок или каждый ящик.

## 3. Player Fantasy

Игрок работает за компьютером, а внизу экрана живёт маленький собачий кооператив.

Собаки ездят за ресурсами, возвращаются, помогают друг другу, выгружают ящики, готовят корм, фасуют мешки и отправляют помощь в приют.

Игрок иногда вмешивается:

- выбирает маршрут;
- отправляет собаку;
- подтверждает поставку;
- вручает маленькую награду.

Игрок помогает не потому, что обязан, а потому что хочется.

Если убрать игрока на несколько минут, кооператив SHOULD продолжать выглядеть живым.

Если убрать собак, игры больше нет.

## 4. Screen Composition Contract

Vertical Slice MUST использовать Steam Overlay Main Strip direction:

- нижняя живая кромка экрана;
- пустота сверху;
- жизнь внизу;
- низкие функциональные модули;
- крупные собаки и действия;
- минимум UI;
- inspect/detail views только по клику.

Vertical Slice MUST NOT превращать основной overlay в интерьерную cutaway-сцену.

Vertical Slice MUST NOT строить плотный ряд домиков.

Базовая читаемая схема мира:

```text
Left edge / Road Sign
        ↓
Storage
        ↓
Kitchen
        ↓
Packing Table
        ↓
Delivery Van Endpoint / Right side
```

Положение объектов MAY меняться для удобства сцены, но смысловая цепочка MUST оставаться читаемой.

## 5. World Entity Contract

В Vertical Slice MUST существовать только следующие игровые сущности.

### 5.1 Buildings

Buildings — редкие крупные якоря полоски.

Vertical Slice Buildings:

- Storage;
- Kitchen.

### 5.2 Utility Props

Utility Props — рабочие объекты. Они MUST NOT становиться домиками.

Vertical Slice Utility Props:

- Road Sign / Road Edge;
- Packing Table;
- Delivery Van Endpoint.

Road Sign MUST быть физическим объектом мира, из которого начинается маршрут.

Packing Table MUST быть рабочим объектом фасовки, а не отдельным домиком.

Delivery Van Endpoint MUST быть точкой отправки, а не полноценным гаражом/зданием.

### 5.3 Characters

Vertical Slice MUST иметь двух собак:

- Dachshund;
- Labrador.

Dachshund MUST быть первой собакой-водителем.

Labrador MUST быть спокойным помощником для выгрузки, переноски и производственной цепочки.

### 5.4 Transport

Vertical Slice MUST иметь один транспорт:

- Basket Bicycle.

Transport MUST физически покидать strip и физически возвращаться с грузом.

### 5.5 Resources

Vertical Slice MUST иметь следующие ресурсы:

- Oat Crate;
- Pumpkin Crate;
- Protein Packet;
- Packaging Bag;
- Food Mix;
- Food Bag.

Oat Crate и Pumpkin Crate MUST приехать из поездки.

Protein Packet и Packaging Bag MAY лежать в Storage на старте.

### 5.6 Order

Vertical Slice MUST иметь один заказ:

- First Warm Delivery.

First Warm Delivery MUST быть спокойной плановой поставкой без guilt pressure.

## 6. Player Action Contract

Игрок MUST иметь только следующие обязательные действия:

1. Open Order Card.
2. Open Road Sign / Route Card.
3. Start route with Dachshund and Basket Bicycle.
4. Open Dog Card.
5. Confirm Delivery when Van is ready.
6. Claim Postcard reward.
7. Equip Comfortable Slippers to Dachshund.
8. Hide UI.
9. Show UI.

Любое другое действие считается out of scope для Vertical Slice.

Игрок MUST NOT:

- вручную переносить ресурсы;
- вручную запускать каждую микрозадачу;
- вручную выбирать каждую собаку для каждого carry/unload/cook/pack действия;
- управлять транспортом напрямую;
- видеть магазин, донаты, рекламу или Steam monetization flow.

## 7. Automatic World Behaviour Contract

После запуска маршрута мир MUST самостоятельно выполнить следующую цепочку:

```text
Dachshund walks to Basket Bicycle
↓
Dachshund prepares / reaches transport
↓
Basket Bicycle leaves strip
↓
Road Sign shows calm trip state
↓
Basket Bicycle returns from off-screen route
↓
Visible cargo appears on / near transport
↓
Dogs unload cargo
↓
Cargo physically enters Storage
↓
Dogs carry ingredients from Storage to Kitchen
↓
Kitchen produces Food Mix
↓
Food Mix appears as world object / visible state
↓
Dogs carry Food Mix to Packing Table
↓
Packing Table produces Food Bag
↓
Food Bag appears as world object / visible state
↓
Dog carries Food Bag to Delivery Van Endpoint
↓
Delivery Van Endpoint becomes ready
↓
Player confirms delivery
↓
Delivery resolves
↓
Postcard appears
↓
Comfortable Slippers reward appears
↓
Player equips Comfortable Slippers to Dachshund
```

Ни один этап этой цепочки MUST NOT быть удалён без отдельного design decision.

Implementation MAY simplify animation quality, but MUST preserve visible cause-and-effect.

## 8. Visibility Contract

Игрок MUST видеть причину каждого важного изменения мира.

Vertical Slice MUST NOT использовать невидимые resource mutations как основной feedback.

Запрещённые паттерны:

```text
resource += 1
inventory.add(resource)
craft instantly complete
order instantly complete
delivery instantly complete
```

Разрешённая форма:

```text
transport returned
↓
cargo is visible
↓
dog walks to cargo
↓
dog takes cargo
↓
dog carries cargo
↓
dog places cargo
↓
target object state changes
```

Правило:

**Любой ресурс, влияющий на заказ, MUST хотя бы один раз физически существовать в мире.**

Storage inventory MUST update only after the visible unload/place action completes.

Kitchen output SHOULD appear as a visible object, token, dish, bowl, container or clear object-state change.

Packing output SHOULD appear as a visible Food Bag.

Delivery MUST NOT complete until Food Bag has been visibly loaded into Delivery Van Endpoint.

## 9. UI Contract

Vertical Slice UI MUST быть compact, contextual and non-dominant.

Required cards:

- Order Card;
- Route Card;
- Dog Card;
- Storage Card MAY exist if useful for debug/player clarity;
- Van Card or contextual Van button;
- Postcard Card;
- Hide / Show UI button.

UI MUST NOT dominate the strip.

UI MUST NOT use:

- full-screen menu during normal play;
- hard red warnings;
- guilt language;
- urgent countdown to failure;
- paid affordances;
- dense drop tables;
- complex balance numbers.

Order Card MUST gently suggest the next action.

Route Card MUST show:

- route name;
- selected transport;
- selected dog;
- expected resource categories;
- Send action.

Dog Card MUST show innate trait and equipment as separate layers.

## 10. Dog Trait Contract

Vertical Slice MUST demonstrate D-010.

Dachshund MUST have innate trait:

- Быстрые лапки.

After first delivery, Dachshund MUST receive equipment reward:

- Удобные тапочки.

Dog Card MUST show these as separate concepts:

```text
Innate trait: Быстрые лапки
Equipment: Удобные тапочки
```

Comfortable Slippers MAY provide no real numeric effect in Vertical Slice.

The important requirement is conceptual clarity:

- innate identity is permanent;
- equipment is added later;
- equipment enhances or decorates the dog without replacing identity.

## 11. Art Contract

Vertical Slice MUST follow accepted Steam Overlay Main Strip v1 direction.

### 11.1 Asset Taxonomy

Every visual asset MUST be classified before creation or implementation:

1. Building;
2. Utility Prop;
3. Dog Action Sprite.

If an asset cannot be classified, it MUST NOT enter the Vertical Slice until clarified.

### 11.2 Building Rule

Building = rare large anchor.

In Vertical Slice only Storage and Kitchen MAY be Buildings.

### 11.3 Utility Prop Rule

Utility Prop = functional object, not a house.

Road Sign, Packing Table and Delivery Van Endpoint MUST be Utility Props.

Utility Props MUST NOT become decorative houses, full rooms, shops, cottages or dense village modules.

### 11.4 Dog Action Sprite Rule

Dog Action Sprite = readable dog action.

Dog actions SHOULD read before object decoration.

Required dog action readability:

- dog walking;
- dog with bicycle / leaving / returning;
- dog unloading crate;
- dog carrying crate;
- dog cooking / helping at kitchen;
- dog packing / handling bag;
- dog carrying Food Bag;
- small celebration / reward moment.

### 11.5 Strip Readability

The main overlay MUST remain:

- low;
- light;
- readable at strip scale;
- empty above the action layer;
- focused on dog movement and object silhouettes.

Decor MAY support warmth, but MUST NOT obscure tasks.

Interior cutaway scenes MAY exist later as inspect/detail views, but MUST NOT be the main Vertical Slice overlay.

## 12. Emotional Contract

After 8–10 minutes, player SHOULD feel:

- dogs are alive;
- dogs help each other;
- the co-op did something kind;
- the world changed because of visible actions;
- the strip can keep living quietly near the desktop.

Player MUST NOT feel:

- they optimized a cold conveyor;
- they filled a spreadsheet;
- they were guilted into helping;
- they were pushed toward monetization;
- they are managing disposable worker units.

Postcard text MUST be warm and non-coercive.

Allowed tone:

> Спасибо за первую поставку. Кооператив только начинает путь, но уже сделал доброе дело.

Forbidden tone:

- “Если бы не вы…”
- “Срочно!”
- “Собаки голодают.”
- “Последний шанс помочь.”
- “Не подведите приют.”

## 13. Acceptance Contract

Vertical Slice is accepted only if a human tester can visibly observe all of the following:

1. The strip opens as a low desktop companion field.
2. Road Sign exists as a physical object.
3. Storage, Kitchen, Packing Table and Delivery Van Endpoint are visible and readable.
4. Dachshund and Labrador are visible as dogs, not abstract units.
5. Player can open Road Sign / Route Card.
6. Player can send Dachshund on Basket Bicycle.
7. Dachshund / transport visibly leaves the strip.
8. Trip state is visible without pressure.
9. Transport visibly returns.
10. Cargo is visible on or near transport.
11. Dogs unload cargo.
12. Cargo physically reaches Storage.
13. Storage updates only after visible unload/place action.
14. Dogs carry ingredients to Kitchen.
15. Kitchen visibly works.
16. Food Mix appears or Kitchen output state is clearly visible.
17. Dogs carry Food Mix to Packing Table.
18. Packing Table visibly works.
19. Food Bag appears.
20. Dog carries Food Bag to Delivery Van Endpoint.
21. Delivery Van Endpoint becomes ready.
22. Player confirms delivery.
23. Delivery resolves without guilt pressure.
24. Postcard appears.
25. Comfortable Slippers reward appears.
26. Player can equip Comfortable Slippers to Dachshund.
27. Dog Card separates innate trait and equipment.
28. Hide UI works.
29. Show UI works.
30. World state continues while UI is hidden.

If any required item is missing, Vertical Slice is not complete.

## 14. Out of Scope

Until Vertical Slice is accepted, the following MUST NOT be implemented as product scope:

- additional routes;
- additional transport types;
- third dog;
- dog rooms;
- room-lite rewards;
- decor systems;
- research tree;
- economy balancing;
- long-term progression;
- real shelter integrations;
- charity reporting;
- donations;
- subscriptions;
- Steam achievements;
- Steamworks integration;
- Browser Extension sync;
- shared account;
- paid cosmetics;
- ads;
- sponsorship block;
- Chrome new-tab UI;
- crop farming visible in Steam;
- combat;
- PvP;
- bosses;
- monsters;
- gacha;
- paid reroll;
- FOMO events.

Technical support code MAY exist if necessary for the prototype, but it MUST NOT expand player-facing scope.

## 15. Handoff to Codex

Codex task after this contract:

> Implement Steam/Desktop Vertical Slice first-order loop in the existing Godot companion strip: semantic objects, route card, dachshund trip, visible return payload, physical unload into storage, carry to kitchen, cook, pack, load van, send delivery, show postcard, assign comfortable slippers.

Codex MUST preserve existing companion strip functionality unless the task explicitly requires a change:

- window placement;
- always-on-top;
- transparency;
- click-through empty space;
- Hide / Show;
- zoom / pan;
- performance awareness.

Codex SHOULD implement the Vertical Slice as a prototype layer or scene without destroying the current tech demo unless a separate dev decision says otherwise.

Codex MUST update relevant dev/status docs after implementation.

## 16. Handoff to Art Direction

Art Direction task after this contract:

Prepare only the assets required by Vertical Slice, classified by taxonomy.

### Buildings

- Storage;
- Kitchen.

### Utility Props

- Road Sign / Notice Board;
- Packing Table;
- Delivery Van Endpoint;
- Basket Bicycle.

### Dog Action Sprites

- Dachshund with / near bicycle;
- Dachshund returning with cargo;
- Labrador unloading crate;
- dog carrying crate;
- dog carrying Food Bag;
- dog packing / labeling;
- small reward / slippers moment.

### Icons / UI

- Comfortable Slippers icon;
- First Postcard frame;
- simple resource tokens for oat, pumpkin, protein packet, packaging bag, food mix, food bag.

Art MUST NOT create extra houses, rooms, decorative buildings or non-contract assets as part of Vertical Slice production scope.

## 17. Document Status

This contract is draft v1.

Before implementation starts, Producer / Game Designer MAY revise wording, but SHOULD NOT expand scope.

Once accepted, this document becomes the source of truth for Steam/Desktop Vertical Slice until the slice is completed or formally replaced by a newer contract.
