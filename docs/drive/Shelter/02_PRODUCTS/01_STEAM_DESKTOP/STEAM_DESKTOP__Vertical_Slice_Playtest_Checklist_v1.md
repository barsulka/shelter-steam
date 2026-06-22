# STEAM_DESKTOP — Vertical Slice Playtest Checklist v1

Дата: 2026-06-29
Роль документа: Game Design Playtest Checklist
Статус: active checklist for first playable Vertical Slice
Продукт: Steam/Desktop idle always-on-top strip
Основано на:

- `STEAM_DESKTOP__Game_Design_Roadmap_v1.md`
- `STEAM_DESKTOP__Vertical_Slice_Scope_Lock_v1.md`
- `STEAM_DESKTOP__Vertical_Slice_Contract_v1.md`
- `STEAM_DESKTOP__Object_Contract_v1.md`
- `STEAM_DESKTOP__Task_Flow_Contract_v1.md`

## 0. Назначение

Этот чеклист нужен для проверки первой playable сборки Steam/Desktop Vertical Slice.

Он проверяет не только техническую работоспособность, но и главное ощущение:

> Внизу экрана живёт маленький спокойный собачий кооператив, который делает доброе дело, а игрок иногда мягко помогает.

Если сборка технически работает, но не проходит этот чеклист по ощущению, Vertical Slice нельзя считать принятым как game-design результат.

## 1. Формат оценки

Каждый пункт оценивается как:

- PASS — работает и ощущается правильно;
- PARTIAL — работает, но требует доработки;
- FAIL — не работает или ломает ощущение Shelter;
- N/A — не применимо к текущей сборке только если пункт ещё не должен быть реализован по scope lock.

Для каждого PARTIAL или FAIL нужно записывать причину и proposed fix.

Proposed fix не должен расширять scope без отдельного решения.

## 2. Scope compliance

- [ ] Есть только один маршрут: `Овсяная ферма`.
- [ ] Есть только один транспорт: `велосипед с корзинкой`.
- [ ] Есть только две собаки: такса и лабрадор.
- [ ] Есть только один заказ: `Первая тёплая поставка`.
- [ ] Есть только одна награда: `Удобные тапочки`.
- [ ] Нет третьей собаки.
- [ ] Нет второго маршрута.
- [ ] Нет комнат / room-lite.
- [ ] Нет Decor Workshop.
- [ ] Нет research tree.
- [ ] Нет монетизации, рекламы, донатов, Steamworks или real shelter data.
- [ ] Нет Browser Extension UI.
- [ ] Нет видимого crop farming в Steam.

Любое нарушение scope compliance = FAIL для Vertical Slice.

## 3. First player understanding

- [ ] Игрок видит нижнюю strip-сцену как живой маленький кооператив, а не как меню.
- [ ] Road Sign читается как место, откуда начинается поездка.
- [ ] Первый заказ мягко объясняет, что нужно собрать поставку.
- [ ] Игрок понимает, что не хватает овса и тыквы.
- [ ] Игрок понимает, что нужно открыть Road Sign / Route Card.
- [ ] Route Card понятно показывает маршрут, собаку, транспорт и ожидаемые ресурсы.
- [ ] Кнопка отправки не выглядит как покупка, реклама или срочный таймер.

## 4. Route and trip feeling

- [ ] Такса физически идёт к велосипеду.
- [ ] Велосипед физически уезжает за край strip.
- [ ] Во время поездки Road Sign показывает спокойное состояние.
- [ ] Пока такса в поездке, мир не кажется полностью мёртвым.
- [ ] Лабрадор имеет спокойное idle-поведение или ожидание.
- [ ] Велосипед физически возвращается.
- [ ] На велосипеде или рядом с ним виден груз.

## 5. Physical resources

- [ ] Oat Crate виден до попадания в Storage.
- [ ] Pumpkin Crate виден до попадания в Storage.
- [ ] Собака подходит к грузу перед выгрузкой.
- [ ] Собака берёт груз или явно выполняет unload action.
- [ ] Собака несёт груз к Storage.
- [ ] Storage обновляется только после видимого placement.
- [ ] Игрок понимает цепочку: транспорт вернулся -> груз выгружен -> ресурс доступен.

## 6. Production chain readability

- [ ] Dogs carry Oat Crate / Pumpkin Crate / Protein Packet to Kitchen.
- [ ] Kitchen явно ждёт inputs до старта.
- [ ] Kitchen visibly works после получения inputs.
- [ ] Food Mix появляется как объект или понятное output state.
- [ ] Food Mix переносится на Packing Table.
- [ ] Packaging Bag переносится на Packing Table.
- [ ] Packing Table visibly works.
- [ ] Food Bag появляется как видимый объект.
- [ ] Food Bag переносится к Delivery Van Endpoint.
- [ ] Delivery Van Endpoint становится ready только после загрузки Food Bag.

## 7. Dogs first

- [ ] Такса читается как первая собака-водитель.
- [ ] Лабрадор читается как спокойный помощник.
- [ ] Собаки физически идут к задачам.
- [ ] Собаки не телепортируются между объектами.
- [ ] Собаки не выглядят как abstract worker icons.
- [ ] У собак есть хотя бы минимальные idle-паузы или живые реакции.
- [ ] Игрок во время цикла чаще смотрит на собак, чем на карточки UI.
- [ ] После завершения цикла возникает чувство: “они правда сделали работу”.

## 8. Player agency

- [ ] Игрок запускает маршрут одним осмысленным действием.
- [ ] После route start мир сам создаёт unload/carry/cook/pack/load tasks.
- [ ] Игрок не подтверждает каждую микрозадачу.
- [ ] Игрок подтверждает только meaningful moment: отправку готовой поставки.
- [ ] Игрок может открыть Dog Card для понимания, но это не обязательный микроменеджмент.
- [ ] Игрок может скрыть UI и наблюдать.

## 9. UI quietness

- [ ] Order Card компактная.
- [ ] Route Card компактная.
- [ ] Dog Card компактная и понятная.
- [ ] Postcard Card появляется как тёплый feedback, а не как агрессивный modal.
- [ ] Hide UI работает.
- [ ] Show UI работает.
- [ ] Мир продолжает жить, пока UI скрыт.
- [ ] UI не перекрывает ключевые dog actions.
- [ ] В UI нет dense drop tables, paid affordances, hard red warnings или urgent countdown.

## 10. D-010: innate trait vs equipment

- [ ] Dog Card таксы показывает innate trait: `Быстрые лапки`.
- [ ] До награды equipment slot пустой или ясно отделён.
- [ ] После открытки появляется reward: `Удобные тапочки`.
- [ ] Игрок может экипировать Comfortable Slippers таксе.
- [ ] Dog Card после экипировки показывает innate trait и equipment как разные слои.
- [ ] Экипировка не заменяет врождённую особенность.
- [ ] UI не превращает собаку в generic stat block.

## 11. Delivery and postcard tone

- [ ] Delivery ждёт player confirmation после загрузки Food Bag.
- [ ] Текст перед отправкой спокойный.
- [ ] Delivery не использует срочность.
- [ ] Postcard появляется только после completion.
- [ ] Postcard благодарит без давления на игрока.
- [ ] Текст не создаёт ощущение обязанности или вины.
- [ ] В delivery / postcard нет тревожной или манипулятивной риторики.

## 12. Calm idle and desktop companion feeling

- [ ] Strip не требует постоянного внимания.
- [ ] Во время ожиданий есть спокойная жизнь.
- [ ] Нет тревожных сигналов.
- [ ] Нет наказания за отсутствие внимания.
- [ ] Hide UI позволяет оставить мир жить визуально.
- [ ] Сцена не выглядит перегруженной.
- [ ] Возникает желание оставить игру открытой внизу экрана.

## 13. Readability at strip scale

- [ ] Road Sign читается как route anchor.
- [ ] Storage читается как место хранения.
- [ ] Kitchen читается как production object.
- [ ] Packing Table читается как Utility Prop, не домик.
- [ ] Delivery Van Endpoint читается как точка отправки, не гараж/домик.
- [ ] Basket Bicycle читается как транспорт.
- [ ] Crate / Food Mix / Food Bag читаются как разные смысловые объекты или состояния.
- [ ] Dog + carried item читается лучше, чем декоративные детали.

## 14. Overall verdict

### ACCEPTED FOR NEXT DESIGN STEP

Можно переходить к First Day MVP decisions / next expansion.

Условия:

- нет FAIL в Scope compliance;
- нет FAIL в Physical resources;
- нет FAIL в Production chain readability;
- нет FAIL в D-010;
- мир ощущается живым хотя бы на PARTIAL/PASS уровне.

### NEEDS DESIGN FIXES BEFORE EXPANSION

Технически loop есть, но ощущение Shelter ещё не собрано.

Допустимые fixes:

- уточнить UI text;
- усилить visible resource movement;
- улучшить dog idle / task readability;
- упростить cards;
- переставить акценты на собак.

Нельзя чинить через добавление второго маршрута, третьей собаки, комнат, upgrades или новых систем.

### REJECTED AS VERTICAL SLICE

Loop не доказывает core fantasy.

Причины reject:

- ресурсы телепортируются;
- собаки не являются центром;
- UI доминирует;
- delivery tone давит на игрока;
- scope расползся;
- мир не ощущается живым.

## 15. Playtest report template

После проверки создать или заполнить:

`STEAM_DESKTOP__Vertical_Slice_Playtest_Report_v1.md`

Минимальный формат:

```text
Дата:
Сборка / branch:
Кто проверял:
Общий verdict:

1. Scope compliance:
2. Первое понимание игрока:
3. Route and trip feeling:
4. Physical resources:
5. Production chain readability:
6. Dogs first:
7. Player agency:
8. UI quietness:
9. D-010:
10. Delivery tone:
11. Calm idle:
12. Readability:

Ключевые проблемы:
Design fixes без расширения scope:
Что нельзя добавлять как fix:
Следующий лучший шаг:
```

## 16. Changelog

### 2026-06-29 — v1 created

- Создан playtest checklist для первого playable Vertical Slice.
- Чеклист проверяет scope, физичность ресурсов, собак как центр игры, UI quietness, D-010, calm idle и tone safety.
- Зафиксировано, что failed slice нельзя чинить расширением scope.
