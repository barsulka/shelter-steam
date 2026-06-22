# D-011 — Style Board and Readability Test v0

Дата: 2026-06-25  
Роль документа: Art Direction deliverable / implementation v0  
Связано с: D-011 Visual Direction Candidate A: Cozy Modular Diorama  
Статус: рабочая постановка для style board и первого readability test.

## 1. Цель

Проверить, выдерживает ли Cozy Modular Diorama три обязательных условия:

1. Читается ли стиль в Steam/Desktop полоске на 96 px, 144 px и 216 px.  
2. Можно ли переносить визуальную идентичность между Steam side/cutaway и Browser top-down / 3⁄4.  
3. Не становится ли стиль слишком дорогим для MVP asset scope.

Главная цель первого теста — не красота финального арта, а проверка читаемости, production cost и совместимости двух продуктов.

## 2. Style board v0 — обязательные слоты

Нужно собрать 12–20 референсов / слотов. В этом v0 документе слоты уже заданы как список поиска и проверки.

### A. Dogs / собаки

1. Corgi-like dog: низкий силуэт, большие уши, короткие лапы.  
2. Dachshund-like dog: длинное тело, короткие лапы, вытянутая морда.  
3. Spitz / pomeranian-like dog: маленькая пушистая форма, хвост-кольцо.  
4. Husky-like dog: острые уши, пушистый хвост, маска.  
5. Labrador-like dog: крупный мягкий силуэт, добрый спокойный характер.  
6. Mixed shelter dog: нестандартный силуэт, пятна, асимметричный окрас.

Проверка: породы отличаются не только цветом, но и силуэтом.

### B. Cutaway rooms / комнаты в разрезе

7. Маленькая комната собаки с ковриком, лежанкой, миской и personality object.  
8. Комната садовода: растения, лейка, садовые перчатки, маленькая полка.  
9. Комната фасовщика: бумажные ярлыки, аккуратные коробки, ленточки, мешочки.  
10. Комната игривой собаки: тапочки, мячик, мягкая игрушка, слегка хаотичный декор.

Проверка: комната показывает характер, но не выглядит как min-max билд.

### C. Production modules / производственные зоны

11. Теплица / сад.  
12. Кухня / кормоцех.  
13. Миксер / сушилка / пресс.  
14. Фасовка.  
15. Склад мешков.  
16. Фургонная площадка.

Проверка: здание читается за 1 секунду по силуэту и главному объекту.

### D. Browser top-down farm

17. Грядки + дорожки + домики собак.  
18. Кормоцех и склад в top-down / 3⁄4.  
19. Фургон рядом с фермой.  
20. New-tab layout: search bar, sponsor card, ферма.

Проверка: ферма не мешает функции новой вкладки.

## 3. Общий style prompt для тестовых сцен

Использовать как базовую часть для всех генераций / постановок:

Cozy modular diorama art direction for a warm dog shelter charity idle game. Small modular dog cooperative, soft 2D illustrated diorama, clear readable silhouettes, warm wood, fabric, paper labels, soft daylight, gentle cozy farm atmosphere, peaceful dog food production, no violence, no combat, no guilt, no dark horror mood. Dogs are residents and characters, not exploited workers. The scene must prioritize readability at very small sizes: large silhouettes, clear actions, simple shapes, uncluttered composition.

Negative / avoid:

No battles, no monsters, no PvP, no bosses, no gore, no slaughterhouse, no realistic meat processing, no knives as production symbols, no horror lighting, no occult mood, no aggressive mobile game UI, no guilt-pressure charity messaging, no sad starving dogs, no dark factory exploitation vibe.

## 4. Steam readability test matrix

Для каждой Steam-сцены делаем три версии:

- 96 px height: stress test. Должны читаться собака, направление движения, предмет, базовое действие.  
- 144 px height: вероятный рабочий минимум. Должны читаться действие, тип здания, ресурс, простая эмоция.  
- 216 px height: комфортный режим. Должны читаться комната, декор, индивидуальность, вторичные idle-детали.

Оценка для каждой версии:

- Dog readable? yes/no  
- Breed/type readable? yes/no/partial  
- Action readable in 1 sec? yes/no  
- Carried object readable? yes/no  
- Module readable? yes/no  
- UI noise acceptable? yes/no  
- Emotional tone correct? yes/no  
- Production cost acceptable? low/medium/high

## 5. Test Scene Steam 01 — Dog carries food bag

### Purpose

Проверить самый важный Steam-case: собака физически несёт ресурс между production modules.

### Scene brief

Горизонтальная side/cutaway production strip. Слева маленький модуль фасовки, справа склад мешков. Между ними тёплая деревянная дорожка. Небольшая корги-подобная собака несёт маленький мешок корма. Мешок должен быть крупным и читаемым. Сцена должна работать в высоте 96 px.

### Prompt v0

A tiny horizontal side-view cutaway module for a cozy dog cooperative idle game. On the left, a small packing station with paper labels and neatly filled food bags. On the right, a small storage room with stacked warm beige dog food sacks. A corgi-like dog with short legs and big ears walks between them carrying one clearly readable food bag. Cozy modular diorama, warm wood, soft fabric, simple shapes, clear silhouettes, peaceful dog food production, no factory harshness. Designed for a very small always-on-top desktop strip, must remain readable at 96 px height.

### Readability question

За 1 секунду видно ли: “собака несёт мешок со склада/в склад”?

## 6. Test Scene Steam 02 — Dog decorates room

### Purpose

Проверить комнату как носитель личности, не как min-max систему.

### Scene brief

Side/cutaway собачья комната. Собака переклеивает обои или вешает маленький мягкий декор. Комната уютная, но не перегруженная. Важны: собака, рулон обоев/декор, действие, личность комнаты.

### Prompt v0

A small side-view cutaway dog room inside a cozy modular diorama. A spitz-like fluffy dog is decorating its own room, gently applying a simple wallpaper strip or hanging a small cozy wall decoration. The room has a dog bed, bowl, soft rug, one favorite toy, and one personality object. Warm light, soft wood and fabric textures, readable silhouettes, no clutter. The action must be visible even at small desktop strip sizes. The room shows personality and affection, not min-max optimization.

### Readability question

За 1 секунду видно ли: “собака украшает свою комнату”?

## 7. Test Scene Steam 03 — Kitchen → mixer → packing chain

### Purpose

Проверить, работает ли Cozy Modular Diorama как горизонтальный production strip.

### Scene brief

Один горизонтальный фрагмент из трёх модулей: кухня, миксер, фасовка. 2–3 собаки выполняют разные мирные действия: одна несёт миску/коробку ингредиентов, вторая обслуживает миксер, третья фасует мешок. Никакой мясной визуальности.

### Prompt v0

A horizontal side-view cutaway production strip for a cozy dog cooperative. Three connected modules: a warm kitchen with vegetables, rice and vitamin jars; a friendly rounded mixer machine; a small packing station with paper labels and beige food bags. Two or three different dogs perform slow visible peaceful tasks: one carries a bowl of vegetables, one watches the mixer, one places a label on a food bag. Cozy modular diorama, readable silhouettes, warm wood, soft light, no meat processing, no knives, no gore, no harsh factory mood. Designed to be readable at 96, 144 and 216 px desktop strip heights.

### Readability question

Можно ли отличить кухню, миксер и фасовку без текста?

## 8. Browser Test 01 — Top-down farm

### Purpose

Проверить перенос визуальной идентичности в Browser Extension.

### Scene brief

Top-down / 3⁄4 idle farm: грядки, дорожки, домики собак, кормоцех, склад, фургон. 3–5 собак двигаются по ферме. Нужно сохранить тот же cozy modular diorama DNA, но в top-down форме.

### Prompt v0

A top-down / three-quarter cozy dog farm for a Chrome new-tab idle game. Warm modular dog cooperative farm with vegetable beds, small paths, dog houses, a peaceful food workshop, a tiny storage shed, and a friendly delivery van. Three to five dogs of different silhouettes walk slowly and do gentle farm tasks. Soft 2D illustrated diorama style, warm wood, fabric, paper labels, greenery, clean peaceful dog food production. The layout must leave room for a search bar and sponsor card, calm and uncluttered, no pressure, no aggressive mobile UI.

### Readability question

Ферма приятна за 5–20 секунд и не мешает new-tab layout?

## 9. Browser Test 02 — New-tab layout with sponsor card

### Purpose

Проверить, как sponsor card встраивается в экран без ощущения агрессивного баннера.

### Scene brief

Экран новой вкладки: сверху search bar, сбоку или сверху справа спокойная sponsor card / доска партнёра, основную часть занимает ферма. Sponsor card не блокирует игру и не использует guilt. Тон: благодарность и прозрачность.

### Prompt v0

A calm Chrome new-tab layout for a cozy dog charity idle farm. At the top, a clean search bar. On the side, a gentle sponsor card designed like a small wooden notice board with a simple partner message: “Спасибо, этот просмотр помогает отправлять корм.” The rest of the screen shows a small top-down dog farm with paths, vegetable beds, dog houses, food workshop and delivery van. Soft warm cozy modular diorama style, clear UI hierarchy, no aggressive banner feeling, no guilt pressure, no sad imagery, no blocking gameplay.

### Readability question

Sponsor card ощущается как спокойная часть layout, а не как вторжение рекламы?

## 10. First pass/fail gate

Candidate A может двигаться дальше, если:

- Steam 01 проходит 96 px хотя бы на уровне “собака + мешок + перенос”;  
- Steam 03 проходит 144 px на уровне “кухня / миксер / фасовка различимы”;  
- Browser 02 не выглядит как рекламный сайт;  
- собаки в тестах отличаются силуэтом, а не только цветом;  
- production modules не дают ощущения жёсткой фабрики;  
- комнаты выглядят личными, но не как обязательный stat-build.

Candidate A требует корректировки, если:

- на 96 px всё превращается в декоративную кашу;  
- собака и предмет не читаются отдельно;  
- стиль требует слишком много уникальной ручной прорисовки;  
- top-down Browser выглядит как другой проект;  
- sponsor card визуально доминирует над фермой;  
- комнаты выглядят дороже, чем весь остальной production scope.

## 11. Что делать после первого визуального прогона

1. Собрать изображения / mockups по 5 тестовым сценам.  
2. Сжать Steam-сцены до 96, 144 и 216 px.  
3. Составить таблицу pass/fail.  
4. Отметить, какие элементы теряются первыми: уши, предмет, действие, границы модуля, UI.  
5. Сформулировать корректировки:  
   - укрупнить силуэты;  
   - убрать мелкий декор из 96 px;  
   - усилить предметы в переноске;  
   - упростить контуры зданий;  
   - разделить color language комнат и production modules;  
   - снизить визуальный вес sponsor card.  
6. Вернуться к продюсеру с решением: Candidate A passes / needs adjustment / should be replaced.

## 12. Addendum — Asset Pack 1 v1 verdict

Дата: 2026-06-25.

Asset Pack 1 v1 проверил prompt system на трёх ассетах: мельница, водяная станция, мастерская декора.

Вердикт: useful exploration, not approved production pack.

Что прошло:  
- общий cozy tone;  
- палитра и материалы;  
- dog action direction;  
- icon plaque language;  
- интеграция с approved main strip.

Что не прошло:  
- модель склонна превращать любую функцию в отдельный домик;  
- мельница стала слишком похожа на дом-мельницу;  
- водяная станция стала слишком похожа на дом с баком;  
- мастерская декора стала inspect-view домиком, а не main overlay utility/workbench.

Новое правило для следующих прогонов:

> Перед генерацией ассет классифицируется как Building / Utility Prop / Dog Action Sprite. Utility Props запрещено превращать в домики.

Следующий прогон: Asset Pack 1 v2 должен делать не “ещё красивые домики”, а utility-prop версии: mill v2 = thin vertical prop, water station v2 = tank + pump, decor workshop v2 = open workbench + awning, плюс отдельные dog action sprites.
