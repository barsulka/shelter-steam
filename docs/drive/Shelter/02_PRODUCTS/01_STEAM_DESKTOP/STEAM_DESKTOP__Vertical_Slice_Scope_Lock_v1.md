# STEAM_DESKTOP — Vertical Slice Scope Lock v1

Дата: 2026-06-29
Роль документа: Game Design Scope Lock / Anti-Scope-Creep Contract
Статус: active scope lock for first playable Vertical Slice
Продукт: Steam/Desktop idle always-on-top strip
Основано на:

- `STEAM_DESKTOP__Vertical_Slice_Contract_v1.md`
- `STEAM_DESKTOP__Object_Contract_v1.md`
- `STEAM_DESKTOP__Task_Flow_Contract_v1.md`
- `STEAM_DESKTOP__Codex_Implementation_Brief__Vertical_Slice_v1.md`
- `STEAM_DESKTOP__Game_Design_Roadmap_v1.md`

## 0. Назначение

Этот документ коротко фиксирует границы первого playable Vertical Slice перед реализацией Codex.

Подробные правила уже описаны в Vertical Slice Contract, Object Contract и Task Flow Contract. Этот scope lock нужен не для замены этих документов, а для защиты первого playable slice от расширения.

Главный принцип:

> Сначала доказываем один живой loop. Только потом расширяем игру.

## 1. Что именно должен доказать первый Vertical Slice

Первый Vertical Slice должен доказать, что Steam/Desktop Shelter работает как маленький живой собачий кооператив в нижней полоске экрана.

Обязательный loop:

```text
игрок открывает Road Sign
-> отправляет таксу на Овсяную ферму
-> такса уезжает на велосипеде с корзинкой
-> транспорт возвращается с овсом и тыквой
-> груз виден в мире
-> собаки физически выгружают груз в Storage
-> собаки несут ингредиенты на Kitchen
-> Kitchen делает Food Mix
-> Food Mix переносится на Packing Table
-> Packing Table делает Food Bag
-> Food Bag загружается в Delivery Van Endpoint
-> игрок подтверждает отправку
-> появляется тёплая открытка
-> появляется награда Comfortable Slippers
-> игрок экипирует Comfortable Slippers таксе
-> Dog Card показывает innate trait и equipment отдельно
```

Если этот loop не ощущается живым, дальнейшее расширение запрещено.

## 2. Locked scope — что входит

В первый Vertical Slice входит только следующий состав.

### 2.1 Маршрут

Только один маршрут:

- `Овсяная ферма` / `route.oat_farm_intro`.

Маршрут даёт:

- `Oat Crate` x1;
- `Pumpkin Crate` x1.

Редкая приятная находка для первого playable Vertical Slice должна быть отключена или оставлена dev-only, чтобы tutorial loop был детерминированным.

### 2.2 Транспорт

Только один транспорт:

- `велосипед с корзинкой` / `transport.basket_bicycle`.

Транспорт должен физически уехать за край strip и физически вернуться с видимым грузом.

### 2.3 Собаки

Только две собаки:

1. Такса / `dog.dachshund_intro`
   - роль: первый водитель;
   - innate trait: `Быстрые лапки`.

2. Лабрадор / `dog.labrador_intro`
   - роль: спокойный помощник для выгрузки, переноски и production support;
   - innate trait: `Аккуратный помощник`.

### 2.4 World anchors

Только следующие объекты:

- Road Sign / Road Edge;
- Storage;
- Kitchen;
- Packing Table;
- Delivery Van Endpoint.

### 2.5 Resources

Только следующие ресурсы:

- Oat Crate;
- Pumpkin Crate;
- Protein Packet;
- Packaging Bag;
- Food Mix;
- Food Bag.

### 2.6 Order

Только один заказ:

- `Первая тёплая поставка` / `order.first_warm_delivery`.

Тон заказа должен быть спокойным, без срочности и guilt pressure.

### 2.7 Reward

Только одна награда:

- `Удобные тапочки` / `equipment.comfortable_slippers`.

Цель награды — показать D-010: врождённая особенность и экипировка являются разными слоями.

## 3. Locked player actions

Игрок в первом Vertical Slice может делать только следующее:

1. Открыть Order Card.
2. Открыть Road Sign / Route Card.
3. Отправить таксу на Овсяную ферму.
4. Открыть Dog Card.
5. Подтвердить отправку поставки, когда Van готов.
6. Получить открытку.
7. Экипировать Comfortable Slippers таксе.
8. Скрыть UI.
9. Показать UI.

Игрок не должен подтверждать каждую микрозадачу.

Игрок не должен вручную переносить ресурсы, рулить транспортом, запускать каждую carry/cook/pack задачу или оптимизировать собак как stat units.

## 4. Locked automatic chain

После player intent мир должен сам выполнить цепочку:

1. Dachshund идёт к Basket Bicycle.
2. Basket Bicycle уезжает.
3. Road Sign показывает спокойное состояние поездки.
4. Basket Bicycle возвращается.
5. Oat Crate и Pumpkin Crate видны в мире.
6. Dogs unload cargo.
7. Storage обновляется только после видимой выгрузки.
8. Dogs carry resources to Kitchen.
9. Kitchen creates Food Mix.
10. Food Mix moves to Packing Table.
11. Packing Table creates Food Bag.
12. Food Bag moves to Delivery Van Endpoint.
13. Delivery waits for player confirmation.
14. Postcard appears after delivery completion.
15. Comfortable Slippers reward appears.
16. Dog Card separates innate trait and equipment.

Ни один этап этой цепочки нельзя удалить без отдельного design decision.

## 5. Explicit out of scope

До приёмки первого Vertical Slice loop запрещено добавлять:

- второй маршрут;
- `Льняные поля`;
- `Цветочную ферму`;
- третий dog;
- corgi / mixed-breed helper;
- второй транспорт;
- trailer upgrade;
- Dog Corner / room-lite;
- Decor Workshop;
- research tree;
- long-term progression;
- economy balancing;
- route reward tables;
- rare find progression;
- real shelter integrations;
- charity reporting;
- donations;
- subscriptions;
- Steamworks;
- Steam achievements;
- Browser Extension sync;
- shared account;
- ads;
- sponsorship block;
- Chrome new-tab UI;
- видимое crop farming в Steam;
- combat;
- PvP;
- bosses;
- monsters;
- gacha;
- paid reroll;
- FOMO events.

First Day MVP является следующим слоем, а не частью первого Vertical Slice.

## 6. Forbidden shortcuts

Запрещённые shortcuts:

1. TripTask напрямую добавляет Oat/Pumpkin в Storage.
2. Returned payload невидим.
3. Storage обновляется до того, как dog положила груз.
4. Kitchen стартует без доставленных inputs.
5. Kitchen создаёт Food Bag напрямую.
6. Packing Table пропущен.
7. Food Bag невидим.
8. Van готов до видимой загрузки Food Bag.
9. Delivery завершается без player confirmation.
10. Postcard появляется до DeliveryTask completion.
11. Comfortable Slippers добавляются как generic stat без разделения в Dog Card.
12. IdleTask блокирует required production tasks.
13. Player должен подтверждать каждую микрозадачу.
14. Любой task использует guilt, urgency или monetization pressure.

## 7. Допустимые компромиссы реализации

Production animation не обязательна.

Допустимо:

- использовать semantic placeholders;
- использовать простые tween movements;
- использовать labels / debug markers для прототипа;
- упростить качество анимации;
- сделать deterministic task queue;
- сжать timing для тестирования.

Недопустимо:

- убрать видимые cause-and-effect шаги;
- заменить физическое появление ресурсов числами в UI;
- сделать мир spreadsheet-first;
- добавить scope ради “интереснее”.

## 8. Acceptance для scope lock

Первый Vertical Slice можно считать готовым к playtest только если:

1. Состав объектов соответствует этому scope lock.
2. Нет систем из explicit out of scope.
3. Полная цепочка от route start до slippers equipped работает.
4. Ресурсы физически существуют в мире до попадания в Storage / Kitchen / Packing / Van.
5. Dogs выполняют работу автоматически после player intent.
6. Dog Card показывает innate trait и equipment как разные слои.
7. UI можно скрыть и показать, пока мир продолжает жить.
8. Тон заказа, поездки, доставки и открытки остаётся спокойным и не манипулятивным.

## 9. Следующий документ

Следующий документ roadmap:

`STEAM_DESKTOP__Vertical_Slice_Playtest_Checklist_v1.md`

Он должен определить, как проверять первую playable сборку на ощущение Shelter: dogs first, physical actions, calm idle, quiet UI, no guilt pressure, readable first loop.

## 10. Changelog

### 2026-06-29 — v1 created

- Создан короткий scope lock для первого playable Vertical Slice.
- Зафиксировано, что First Day MVP не входит в первый Vertical Slice.
- Зафиксированы обязательные объекты, собаки, маршрут, транспорт, ресурсы, order, reward и forbidden shortcuts.
