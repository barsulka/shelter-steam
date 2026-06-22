# D-011 — Steam Overlay Main Strip v1 Rules

Дата: 2026-06-25  
Роль документа: Visual Direction / Steam Overlay Rules  
Связано с: D-011 Visual Direction Candidate A — Cozy Modular Diorama

## 1. Approved reference

Основной reference для Steam/Desktop overlay: `D-011_steam_overlay_main_strip_v1_reference.png`.

Drive location: `03_DESIGN/04_DELIVERABLES/approved_art_files/D-011_steam_overlay_main_strip_v1_reference.png`.

Статус: approved composition direction, not final production asset.

Вердикт арт-дирекции:

> Steam Overlay Main Strip v1 passes as composition direction. It is the correct type of screen: a living lower edge that stays out of the user's way. It still needs production simplification, but the core principle is approved.

## 2. Ключевая поправка

Первый Cozy Modular Diorama pass дал правильный стиль, но неправильный тип главного Steam-экрана: большие cutaway-интерьеры и широкие полки с мешками не должны быть главным overlay.

Новая система Steam/Desktop:

1. **Main overlay strip** — главный режим, нижняя живая кромка экрана.  
2. **Inspect / detail views** — открываемые просмотры зданий и комнат: амбар внутри, комната собаки, кухня, фасовка.  
3. **Windowed / scenic mode** — полноценный режим окна с фоном, небом, горами, водой/отражением и более широкой атмосферной сценой.

## 3. Main overlay definition

Main overlay — это не сцена и не интерьер. Это **bottom-hugging living strip**.

Главные свойства:

- вся композиция прижата к нижней кромке экрана;  
- верх почти пустой, чёрный или прозрачный;  
- игра не мешает рабочему столу;  
- постройки маленькие, функциональные и читаемые по силуэту;  
- собаки и действия читаются раньше декора;  
- интерьерная детализация запрещена в главном overlay;  
- UI минимален или скрыт;  
- модульность важнее иллюстративной красоты.

Короткая формула:

> A tiny functional dog cooperative living along the bottom edge of the screen.

## 4. What the approved reference gets right

Approved reference v1 показывает правильные принципы:

- огромная пустота сверху;  
- вся жизнь внизу;  
- понятная нижняя базовая линия;  
- функциональные модули: dog house, greenhouse, kitchen, storage, crate storage, delivery van;  
- собаки стоят на переднем плане и эмоционально важнее зданий;  
- действия видны: отдых, полив, перенос мешка, перевозка ящиков, погрузка у фургона;  
- палитра тёплая и не агрессивная;  
- производство корма выглядит мирно;  
- нет хоррора, боёв, рекламы, guilt pressure и фабричной эксплуатации.

## 5. What still needs simplification for production

Reference v1 — concept mock, не финальный production asset.

Для production нужно:

- снизить вертикальную высоту некоторых зданий на 15–25%;  
- упростить фактуру стен, крыш, земли и листвы;  
- убрать лишние микро-детали;  
- сделать силуэты модулей ещё более разными;  
- подготовить отдельные sprite-friendly версии собак;  
- оставить HUD отдельным слоем, а не частью art reference;  
- проверить читаемость на 96 px, 144 px и 216 px.

## 6. Three visual modes

### 6.1 Main overlay strip

Назначение: always-on-top нижняя полоса, которая живёт на рабочем столе.

Разрешено:

- маленькие фасады зданий;  
- низкие функциональные силуэты;  
- крупные собаки относительно зданий;  
- крупные переносимые предметы;  
- простые sign plaques / icon plaques;  
- редкие деревья, кусты и фонари как паузы;  
- фургон как endpoint;  
- прозрачный или чёрный верх.

Запрещено:

- большие interior cutaway;  
- широкие полки с мешками как фон главного режима;  
- art nouveau домики;  
- башенки ради красоты;  
- плотный фэнтези-городок;  
- много текста на зданиях;  
- много UI-плашек;  
- декор, который важнее действия;  
- любые боевые или тревожные элементы.

### 6.2 Inspect / detail view

Назначение: открывается по клику на здание / комнату.

Разрешено:

- интерьер амбара;  
- полки, мешки, банки, коробки;  
- комната собаки;  
- обои, коврики, игрушки, миски;  
- кухня изнутри;  
- фасовочная станция изнутри;  
- больше света, деталей и personality.

Важно: сцена с корги и мешками из раннего pass — это хороший inspect view амбара, но не main overlay.

### 6.3 Windowed / scenic mode

Назначение: полноценное окно игры.

Разрешено:

- фон с горами, облаками, полями, водой;  
- отражения в воде;  
- шире сцена и больше атмосферы;  
- более красивые композиции;  
- расширенный UI.

Важно: этот режим не должен определять композицию main overlay.

## 7. Overlay module rules

Каждый overlay module обязан иметь:

1. **Function** — что это за здание и зачем оно нужно.  
2. **Silhouette** — узнаваемый контур без текста.  
3. **One icon sign** — маленькая табличка с символом функции, если нужно.  
4. **One main action nearby** — что собака делает рядом с модулем.  
5. **Low vertical mass** — здание не должно доминировать над полосой.  
6. **Clear spacing** — модуль отделён от соседей паузой.  
7. **No interior detail** — интерьер только в inspect view.

## 7.1 Asset taxonomy before generation

Перед генерацией или постановкой любого overlay-ассета нужно сначала выбрать его тип.

### Type A — Building / здание

Редкий крупный якорь main strip: dog house, kitchen, storage, delivery van endpoint. Здания могут иметь фасад, крышу, дверь и маленькую sign plaque, но остаются низкими, функциональными и не доминируют над собаками.

### Type B — Utility Prop / функциональный объект

Вспомогательный объект, вертикальная или горизонтальная пауза: мельница, водяная станция, насос, бак, тележка, компост, указатель, фонарь. Utility Props запрещено превращать в домики. У них не должно появляться полноценной крыши, двери, жилой фасадной логики и ощущения отдельного здания, если это не было явно решено арт-директором.

### Type C — Dog Action Sprite / действие собаки

Отдельная читаемая собака с крупным объектом: несёт мешок, везёт тележку, поливает, красит доску, клеит ярлык. Это смысловой слой, а не декор.

Правило:

> В main overlay здания — редкие якоря. Всё остальное — маленькие функциональные объекты и действия собак. Если каждая функция превращается в домик, нижняя полоса снова становится плотной декоративной деревней.

Asset Pack 1 v1 verdict: useful exploration, not approved production pack. Prompt system уже держит тон и палитру, но требует жёсткой классификации Building / Utility Prop / Dog Action Sprite.

## 8. Functional silhouette map

### Dog house / собачий домик

Silhouette: маленький домик / будка с входом-аркой и лапкой.  
Action: собака отдыхает, выходит, приносит игрушку.  
Do not: делать высокий сказочный домик.

### Greenhouse / теплица

Silhouette: низкая стеклянная крыша, прозрачные секции.  
Action: собака поливает, несёт лейку, собирает корзинку овощей.  
Do not: превращать в большой дворец из стекла.

### Kitchen / food workshop

Silhouette: маленькая кухня с трубой и крупной иконой кастрюли.  
Action: собака несёт миску овощей, стоит у двери, дымок из трубы.  
Do not: показывать полный интерьер в main overlay.

### Packing station / фасовка

Silhouette: низкий рабочий сарайчик с иконой мешка / ярлыка.  
Action: собака несёт мешок, клеит ярлык, двигает тележку.  
Do not: забивать сцену десятками мешков.

### Storage / склад

Silhouette: простой деревянный склад с иконой ящика / коробки.  
Action: собака везёт тележку, складывает ящик, открывает дверь.  
Do not: делать склад слишком похожим на дом.

### Delivery van / фургон

Silhouette: маленький белый/кремовый фургон с лапкой.  
Action: собаки грузят мешок или стоят рядом.  
Do not: делать фургон слишком реалистичным и тяжёлым.

### Windmill / мельница

Silhouette: тонкая вертикальная пауза с лопастями, а не большой дом.  
Action: собака тащит мешок зерна, рядом маленький мешок овса/риса.  
Do not: делать высокую фэнтези-башню, арт-нуво или сказочный замок.

## 9. Scale and height rules

### 96 px

Stress test. Должны читаться: собака, движение, крупный предмет, базовый тип модуля. Декор не важен.

### 144 px

Вероятный рабочий минимум. Должны читаться: тип здания, 1 действие собаки, предмет в переноске, общая функция зоны.

### 216 px

Комфортный режим. Могут читаться: дополнительные idle-анимации, мягкий декор, таблички-иконки, небольшие personality details.

## 10. Composition recipe

Main overlay strip строится как ритм:

`module → pause → dog action → module → pause → resource cart → module → pause → van`

Хороший пример:

`dog house → empty grass → dog with toy → greenhouse → watering dog → kitchen → carrying dog → storage → cart dog → van`

Плохой пример:

`house-house-house-house-house-house with no pauses and many tiny decorative details`

## 11. Style constraints

Keep:

- warm wood;  
- muted greens;  
- soft cream highlights;  
- cozy handmade feeling;  
- friendly dog characters;  
- clean peaceful dog food production;  
- functional tiny cooperative;  
- one lower baseline.

Avoid:

- art nouveau ornament overload;  
- fantasy village towers;  
- gothic / horror mood;  
- heavy factory mood;  
- large interiors in main strip;  
- dense shelves and sacks as background;  
- aggressive UI;  
- sad/guilt imagery;  
- any meat-processing visuals.

## 12. Pass / fail criteria

PASS if:

- main strip does not visually invade the desktop;  
- upper 70–80% of screen is empty / transparent / black;  
- dog, action and carried object are readable before building decor;  
- modules are distinguishable by silhouette;  
- visual tone remains warm and non-exploitative;  
- no module looks like combat, factory exploitation or fantasy-town noise.

FAIL if:

- the image becomes a decorative village illustration;  
- the user cannot identify module types;  
- buildings dominate dogs;  
- rooms/interiors appear as the main background;  
- the strip becomes too tall;  
- UI cards float permanently above the work area;  
- dogs become tiny decorative dots.

## 13. Final art direction statement

Steam Overlay Main Strip is not a small version of the inspect view.

It is a dedicated low-profile layer:

> functional silhouettes + big readable dogs + peaceful actions + empty top space.

Cozy Modular Diorama remains the global style, but main overlay uses a simplified functional silhouette sub-style.
