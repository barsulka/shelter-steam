# STEAM_DESKTOP — MVP State Machine and UX Flow v0

Дата: 2026-06-25  
Роль документа: Game Design / Systems Design / Prototype Spec  
Статус: working draft v0  
Продукт: Steam/Desktop idle always-on-top strip  
Связанный документ: STEAM_DESKTOP__MVP_Gameplay_Slice_v0  
Связанные решения: D-009, D-010, D-012, D-013

## 1. Зачем нужен этот документ

Этот документ переводит MVP gameplay slice в состояние, пригодное для прототипирования.

Он описывает:

- какие игровые объекты существуют в первом slice;  
- какие у них состояния;  
- какие события переводят одно состояние в другое;  
- какие задачи выполняют собаки;  
- какие UX-карточки нужны игроку;  
- какие переходы между карточками и миром должны быть в прототипе.

Это не финальная архитектура и не технический дизайн Godot. Это геймдизайнерская спецификация поведения.

## 2. Основной принцип

Игрок управляет намерениями, а не лапами.

Игрок выбирает:

- цель поставки;  
- маршрут;  
- транспорт;  
- собаку;  
- иногда приоритет.

Дальше мир должен сам раскладывать это на физические задачи:

- подойти;  
- взять;  
- уехать;  
- вернуться;  
- выгрузить;  
- перенести;  
- приготовить;  
- упаковать;  
- загрузить;  
- отправить.

Главное правило Steam-полоски:

Ресурсы должны быть физическими. Если ресурс приехал, игрок должен увидеть, как он появился в мире и как собаки с ним работают.

## 3. MVP objects

В первом прототипе нужны следующие объектные типы.

### 3.1 Co-op Strip

Главная горизонтальная сцена.

Содержит:

- list of modules / props;  
- list of dogs;  
- task queue;  
- active order;  
- active route/trip;  
- hidden/visible UI state.

Минимальные состояния:

- empty_boot;  
- first_order_intro;  
- active_play;  
- ui_hidden;  
- postcard_overlay.

### 3.2 Dog

Собака — житель и исполнитель задач.

Данные:

- id;  
- name;  
- breed/type;  
- innate traits;  
- equipped traits/items;  
- current task;  
- current target;  
- mood/idle state, пока без численного значения;  
- home/room reference, можно null в первом slice.

Минимальные состояния:

- idle;  
- moving_to_target;  
- performing_task;  
- carrying_item;  
- driving_transport;  
- away_on_trip;  
- returning_from_trip;  
- resting;  
- celebrating.

Важно: собака не должна выглядеть как “юнит”. У неё должны быть idle-паузы, хвост, взгляд, ожидание, маленькие живые движения.

### 3.3 Route

Off-screen направление за ресурсами.

Данные:

- id;  
- name;  
- description;  
- expected reward categories;  
- required transport class;  
- optional recommended dog traits;  
- duration tier, пока без точных чисел;  
- rare pleasant find table, optional.

MVP route:

- id: oat_farm_intro;  
- name: Овсяная ферма;  
- expected rewards: ящик овса, маленький ящик тыквы;  
- rare pleasant find: полевой цветок.

### 3.4 Transport

Средство поездки.

MVP transport:

- велосипед с корзинкой.

Данные:

- id;  
- display name;  
- capacity class;  
- speed class;  
- compatible dogs;  
- visual state;  
- loaded resources on return.

Состояния:

- parked;  
- preparing;  
- leaving;  
- away;  
- returning;  
- waiting_for_unload;  
- unloaded.

### 3.5 Road Sign / Road Edge

Utility Prop для запуска поездок и показа возвращения.

Состояния:

- idle;  
- route_available;  
- trip_preparing;  
- trip_active;  
- trip_returning;  
- unload_available.

Показывает:

- маленький маршрутный значок;  
- мягкий таймер поездки;  
- индикатор возвращения;  
- точку появления транспорта.

### 3.6 Storage

Кладовая.

Данные:

- stored resources;  
- incoming unload queue;  
- outgoing carry queue;  
- visible crates/boxes;  
- capacity class, пока без точных лимитов.

Состояния:

- empty;  
- has_starting_supplies;  
- receiving_resources;  
- ready_for_production;  
- waiting_for_output_tasks.

### 3.7 Kitchen

Кухня / производственный модуль.

Данные:

- recipe;  
- required inputs;  
- delivered inputs;  
- current production task;  
- output.

Состояния:

- idle;  
- waiting_for_inputs;  
- inputs_ready;  
- cooking;  
- output_ready;  
- output_taken.

### 3.8 Packing Table

Фасовочный стол.

Данные:

- required input: базовая кормовая смесь;  
- required packaging: упаковочный мешок;  
- output: мешок базового корма.

Состояния:

- idle;  
- waiting_for_mix;  
- waiting_for_packaging;  
- packing;  
- output_ready;  
- output_taken.

### 3.9 Delivery Van Endpoint

Правая зона отправки помощи.

Данные:

- loaded items;  
- linked order;  
- delivery destination label;  
- postcard reward.

Состояния:

- idle;  
- waiting_for_food_bag;  
- loading;  
- ready_to_send;  
- leaving;  
- delivered;  
- postcard_ready.

### 3.10 Order

Мягкая цель поставки.

MVP order:

- name: Первая тёплая поставка;  
- needs: овёс, тыква, протеин-пакет, упаковочный мешок;  
- output needed: мешок базового корма;  
- reward: открытка, удобные тапочки.

Состояния:

- offered;  
- missing_resources;  
- resources_available;  
- production_in_progress;  
- packed;  
- loaded;  
- sent;  
- completed;  
- reward_claimed.

## 4. Core task types

### 4.1 Task common fields

У каждой задачи есть:

- id;  
- type;  
- assigned dog;  
- source object;  
- target object;  
- carried item, optional;  
- required animation tag;  
- status;  
- priority;  
- created by system / player action.

Общие состояния задачи:

- queued;  
- assigned;  
- dog_moving_to_source;  
- in_progress;  
- dog_moving_to_target;  
- completing;  
- complete;  
- failed_or_blocked.

Blocked task не должен выглядеть как ошибка для игрока. Это повод для мягкого UI: “ждём ресурс”, “нужна свободная собака”, “кладовая занята”.

### 4.2 TripTask

Назначение: отправить собаку за ресурсами.

Создаётся, когда игрок нажимает Отправить в Road Sign card.

Поля:

- route;  
- transport;  
- driver dog;  
- optional passengers;  
- outgoing visual cargo: none;  
- incoming reward payload.

Состояния:

1. queued;  
2. dog_moving_to_transport;  
3. preparing_transport;  
4. leaving_strip;  
5. away_timer_active;  
6. returning_to_strip;  
7. arrived_with_payload;  
8. creates_unload_tasks;  
9. complete.

Видимые моменты:

- собака подходит к транспорту;  
- транспорт уезжает;  
- road sign показывает таймер;  
- транспорт возвращается;  
- ресурсы видны как ящики/мешки.

### 4.3 UnloadTask

Назначение: физически выгрузить ресурс из транспорта в Storage.

Создаётся автоматически после TripTask.arrived_with_payload.

Поля:

- transport;  
- resource item;  
- target storage;  
- assigned dog.

Состояния:

1. queued;  
2. dog_moving_to_transport;  
3. taking_item;  
4. carrying_to_storage;  
5. placing_item;  
6. item_added_to_storage;  
7. complete.

Важное правило:

Inventory Storage увеличивается не в момент возвращения транспорта, а в момент item_added_to_storage.

### 4.4 CarryTask

Назначение: перенести ресурс между объектами.

Примеры:

- Storage → Kitchen;  
- Storage → Packing Table;  
- Kitchen → Packing Table;  
- Packing Table → Delivery Van.

Состояния:

1. queued;  
2. dog_moving_to_source;  
3. picking_up_item;  
4. carrying_item;  
5. placing_item;  
6. target_received_item;  
7. complete.

### 4.5 CookTask

Назначение: превратить входящие ингредиенты в базовую кормовую смесь.

Создаётся, когда Kitchen имеет все inputs.

Состояния:

1. waiting_for_inputs;  
2. inputs_ready;  
3. dog_moving_to_kitchen;  
4. cooking_animation;  
5. output_created;  
6. complete.

Видимые действия:

- помешать;  
- поставить миску;  
- принести воду;  
- проверить рецепт.

### 4.6 PackTask

Назначение: превратить кормовую смесь и упаковку в готовый мешок корма.

Состояния:

1. waiting_for_mix;  
2. waiting_for_packaging;  
3. inputs_ready;  
4. dog_moving_to_packing_table;  
5. packing_animation;  
6. label_or_tie_bag;  
7. food_bag_created;  
8. complete.

### 4.7 LoadVanTask

Назначение: перенести готовый мешок к фургону.

Состояния:

1. queued;  
2. dog_moving_to_food_bag;  
3. picking_up_bag;  
4. carrying_to_van;  
5. loading_van;  
6. van_loaded;  
7. complete.

### 4.8 DeliveryTask

Назначение: отправить фургон с готовой поставкой.

Создаётся после Van.ready_to_send и подтверждения игрока либо после soft auto-send в будущих режимах.

Состояния:

1. ready;  
2. player_confirmed;  
3. van_leaving;  
4. delivery_resolved;  
5. postcard_created;  
6. order_completed;  
7. complete.

### 4.9 RestTask / IdleTask

Назначение: заполнить промежутки живым поведением собак.

Примеры:

- сидеть у кладовой;  
- смотреть на дорогу;  
- нюхать цветок;  
- лежать на коврике;  
- потянуться;  
- посмотреть на другую собаку;  
- повилять хвостом.

RestTask не должен мешать срочным queued задачам. Если появилась важная задача, собака может мягко завершить idle-анимацию и пойти работать.

## 5. First order flow as state chain

### 5.1 Initial state

Co-op Strip:

- state: first_order_intro.

Order:

- state: offered.  
- missing: oat crate, pumpkin crate.  
- already available: protein packet, packaging bag.

Dogs:

- Dachshund: idle near road/storage.  
- Labrador: idle near storage/kitchen.

Objects:

- Road Sign: route_available.  
- Storage: has_starting_supplies.  
- Kitchen: waiting_for_inputs.  
- Packing Table: idle.  
- Van: idle.

### 5.2 Player starts trip

Player action:

- click Road Sign;  
- open Route Card;  
- select Oat Farm;  
- confirm Dachshund + bicycle;  
- press Send.

System creates:

- TripTask.

State changes:

- Road Sign: trip_preparing → trip_active.  
- Transport: parked → preparing → leaving → away.  
- Dog: moving_to_target → driving_transport → away_on_trip.

### 5.3 Trip returns

Timer complete.

State changes:

- Transport: away → returning → waiting_for_unload.  
- Dog: returning_from_trip → performing_task or idle_near_transport.  
- Road Sign: trip_returning → unload_available.

System creates:

- UnloadTask for oat crate.  
- UnloadTask for pumpkin crate.

### 5.4 Resources enter storage

Each UnloadTask completes.

State changes:

- Storage receives oat crate.  
- Storage receives pumpkin crate.  
- Order missing_resources check passes.  
- Order: missing_resources → resources_available.

System creates:

- CarryTask: oat crate Storage → Kitchen.  
- CarryTask: pumpkin crate Storage → Kitchen.  
- CarryTask: protein packet Storage → Kitchen.

### 5.5 Kitchen starts production

When all Kitchen inputs delivered:

- Kitchen: waiting_for_inputs → inputs_ready.  
- System creates CookTask.  
- Dog performs CookTask.  
- Kitchen: cooking → output_ready.  
- Output: basic food mix.

System creates:

- CarryTask: basic food mix Kitchen → Packing Table.  
- CarryTask: packaging bag Storage → Packing Table.

### 5.6 Packing starts

When Packing Table has food mix and packaging:

- Packing Table: waiting_for_mix/waiting_for_packaging → inputs_ready.  
- System creates PackTask.  
- Dog performs packing.  
- Packing Table: output_ready.  
- Output: basic food bag.

System creates:

- LoadVanTask: food bag Packing Table → Van.

### 5.7 Delivery

When Van receives food bag:

- Van: waiting_for_food_bag → ready_to_send.  
- Order: packed → loaded.

Player action:

- click Van or Order Card;  
- press Send delivery.

System creates:

- DeliveryTask.

State changes:

- Van: leaving → delivered.  
- Order: sent → completed.  
- Postcard: created.

### 5.8 Reward

Player sees postcard.

Reward:

- comfortable slippers.

State changes:

- Order: completed → reward_claimed.  
- Dachshund gains equipped item slot: comfortable slippers, if player equips immediately.

Important:

- “Быстрые лапки” remains innate and unchanged.  
- “Удобные тапочки” is removable/equippable modifier.

## 6. UX cards

### 6.1 Global UI principles

UI must not dominate the strip.

Allowed:

- small contextual cards;  
- soft highlights;  
- hide UI button;  
- compact route/order/dog cards.

Avoid:

- full-screen menus during normal play;  
- dense tables;  
- hard red warnings;  
- guilt language;  
- timer pressure;  
- modal spam.

### 6.2 Order Card

Opened by:

- initial tutorial prompt;  
- click on active order chip;  
- click on Van when order is relevant.

Shows:

- order name;  
- friendly description;  
- required items;  
- current progress;  
- next suggested action;  
- reward preview, vague if needed.

MVP text:

Title: Первая тёплая поставка.  
Description: Наши друзья из приюта будут рады небольшой партии базового корма.  
Progress:  
- овёс: missing;  
- тыква: missing;  
- протеин-пакет: ready;  
- упаковочный мешок: ready.  
Suggested action: Отправить собаку на Овсяную ферму.

Buttons:

- Show route.  
- Hide.

Not shown:

- guilt pressure;  
- “urgent” labels;  
- countdown to failure.

### 6.3 Road Sign / Route Card

Opened by:

- click on Road Sign;  
- Order Card → Show route.

Shows:

- route name;  
- route description;  
- selected transport;  
- selected driver;  
- expected reward categories;  
- soft duration hint;  
- Send button.

MVP route:

Title: Овсяная ферма.  
Description: Фермерские друзья подготовили немного овса и тыквы для первой партии.  
Transport: велосипед с корзинкой.  
Driver: такса.  
Expected: овёс, тыква.  
Possible nice find: маленький декор.

Buttons:

- Send.  
- Change dog, disabled in tutorial if needed.  
- Close.

Avoid:

- exact drop table in first MVP;  
- paid reroll;  
- rare reward pressure.

### 6.4 Dog Card

Opened by:

- click dog;  
- click dog portrait in Route Card.

Shows:

- name;  
- breed/type;  
- current action;  
- innate traits;  
- equipped items;  
- simple preference line.

MVP Dachshund card:

Breed: такса.  
Innate trait: Быстрые лапки.  
Current action: собирается на Овсяную ферму / едет / отдыхает.  
Equipment: none, later Удобные тапочки.  
Flavor: любит короткие быстрые поручения.

MVP Labrador card:

Breed: лабрадор.  
Innate trait: Аккуратный помощник.  
Current action: ждёт у кладовой / несёт ящик / помогает на кухне.  
Flavor: спокойно и бережно работает с припасами.

### 6.5 Storage Card

Opened by:

- click Storage.

Shows:

- stored resources;  
- incoming resources, if unloading;  
- outgoing tasks;  
- linked order.

MVP states:

Before trip:  
- протеин-пакет: 1;  
- упаковочный мешок: 1;  
- овёс: 0;  
- тыква: 0.

After unload:  
- протеин-пакет: 1;  
- упаковочный мешок: 1;  
- овёс: 1;  
- тыква: 1.

Card should show resources as small visual tokens, not spreadsheet rows.

### 6.6 Kitchen Card

Opened by:

- click Kitchen.

Shows:

- current recipe;  
- inputs delivered / missing;  
- current helper dog;  
- current state.

MVP recipe:

Базовая кормовая смесь.  
Needs:  
- овёс;  
- тыква;  
- протеин-пакет.  
Output:  
- базовая кормовая смесь.

States shown:

- ждёт ингредиенты;  
- ингредиенты принесены;  
- готовит;  
- смесь готова.

### 6.7 Packing Card

Opened by:

- click Packing Table.

Shows:

- input: базовая кормовая смесь;  
- packaging: упаковочный мешок;  
- output: мешок базового корма.

States shown:

- ждёт смесь;  
- ждёт упаковку;  
- фасует;  
- мешок готов.

### 6.8 Van Card

Opened by:

- click Delivery Van;  
- Order Card when packed.

Shows:

- loaded item;  
- destination label;  
- Send button;  
- soft message.

MVP text:

“Партия готова. Можно отправлять.”

Button:

- Отправить поставку.

Avoid:

- “срочно”;   
- “они ждут только тебя”;  
- any guilt language.

### 6.9 Postcard Card

Opened automatically after delivery.

Shows:

- postcard illustration placeholder;  
- thank-you text;  
- what was sent;  
- reward.

MVP text:

“Спасибо за первую поставку! Собаки в приюте получили базовый корм. Ваш кооператив только начинает путь, но уже сделал доброе дело.”

Reward:

- Удобные тапочки.

Buttons:

- Give to Dachshund.  
- Later.

If Give to Dachshund:

- opens Dog Card with equipment slot highlighted.

## 7. Event list for prototype

### 7.1 Player events

- player_click_order_chip;  
- player_click_road_sign;  
- player_select_route;  
- player_confirm_trip;  
- player_click_dog;  
- player_click_storage;  
- player_click_kitchen;  
- player_click_packing;  
- player_click_van;  
- player_confirm_delivery;  
- player_claim_postcard_reward;  
- player_equip_item;  
- player_hide_ui;  
- player_show_ui.

### 7.2 System events

- order_created;  
- route_available;  
- trip_task_created;  
- transport_left_strip;  
- trip_timer_complete;  
- transport_returned;  
- unload_task_created;  
- resource_added_to_storage;  
- order_requirements_met;  
- carry_task_created;  
- kitchen_inputs_ready;  
- cook_task_complete;  
- packing_inputs_ready;  
- pack_task_complete;  
- van_loaded;  
- delivery_complete;  
- postcard_created;  
- reward_created.

## 8. Priority rules

MVP task priority should be simple.

Priority order:

1. Finish current carry/unload if item is already in paws.  
2. Complete unload tasks from returned transport.  
3. Complete carry tasks required by active order.  
4. Complete production tasks.  
5. Complete packing/loading tasks.  
6. Do idle/rest tasks.

Important:

A dog carrying an item should not abandon it mid-route unless there is a debug/system failure. Physical continuity matters more than perfect optimization.

## 9. Dog assignment rules for MVP

For prototype v0, assignment can be simple:

- trip driver is player-selected;  
- unload tasks prefer dog closest to transport;  
- carry tasks prefer idle dog closest to source;  
- cook/pack tasks prefer dog near target station;  
- if no dog is free, task waits.

No complex scheduling needed.

Later improvements:

- preferences;  
- traits;  
- fatigue/rest;  
- rooms;  
- equipment bonuses;  
- multi-dog tasks.

## 10. Minimal state debug view

For dev/prototype, a hidden debug overlay can show:

- active order state;  
- active trip state;  
- dog current task;  
- task queue;  
- storage inventory;  
- object states.

This is dev-only and not part of player UI.

## 11. Prototype acceptance criteria

Prototype v0 passes if:

1. Player can start the first route from the Road Sign card.  
2. Dog visibly leaves the strip with transport.  
3. Timer or travel state is visible without pressure.  
4. Dog returns with visible cargo.  
5. Resources are unloaded physically into Storage.  
6. Order detects that resources are now available.  
7. Dogs carry resources to Kitchen.  
8. Kitchen produces food mix.  
9. Food mix goes to Packing Table.  
10. Packing produces food bag.  
11. Dog loads food bag into Van.  
12. Player sends delivery.  
13. Postcard appears.  
14. Reward can be claimed.  
15. UI can be hidden while world continues.

Prototype v0 fails if:

- resources teleport invisibly from route to inventory;  
- dogs feel like abstract icons rather than actors;  
- route/delivery feels like a spreadsheet;  
- the player must click every micro-action;  
- the first cycle requires too many cards;  
- any text uses guilt pressure;  
- the strip is visually unreadable at 144 px.

## 12. Open design questions

1. Should first delivery be player-confirmed or auto-send after tutorial?  
2. Do we need Packing Table as separate object in MVP, or can Kitchen output the first bag directly and Packing arrives in day-one expansion?  
3. Should comfortable slippers be equipped immediately or shown as a reward with player choice?  
4. How much route duration is enough to feel idle, but not boring, in the first 10 minutes?  
5. Should the first rare pleasant find be disabled for deterministic tutorial, or allowed as a tiny surprise?  
6. How visible should Browser Extension connection be in Steam text? Example: “фермерские друзья” vs explicit “наша ферма из новой вкладки”.  
7. Should Road Sign be left edge only, or can transport leave from right edge depending on route?  
8. Do we need a single shared “task bubble” above dogs, or only object state changes?

## 13. Next gdd step

Next document should be:

STEAM_DESKTOP__First_Day_MVP_v0

It should extend this slice into:

- 3 routes;  
- 3 dogs;  
- 2 transport types;  
- 5–6 objects;  
- 3 order types;  
- first upgrade choice;  
- first room/decor reward;  
- first bottleneck;  
- first route trait interaction.

But do not start First Day MVP until this state machine and UX flow are accepted as direction.
