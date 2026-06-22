# DOG_VISUAL_LANGUAGE v1

Дата: 2026-06-28  
Роль документа: Art Direction / Character System / Animation Direction  
Статус: working draft, базовая постановка для Shelter dog visual system

## 1. Зачем нужен этот документ

Shelter — проект не про здания, мельницы и интерфейс. Shelter — проект про собак.

Поэтому после D-011 Steam Overlay Main Strip и Approved Library v1 следующий обязательный шаг арт-дирекции — описать визуальную систему собак: как собаки выглядят, как отличаются друг от друга, как анимируются, как поддерживают реальные приютские истории и как остаются production-feasible.

Главная задача v1:

> Создать такую систему собак, которая позволяет делать выразительных индивидуальных приютских собак, но не требует рисовать уникальный полный набор анимаций для каждой собаки с нуля.

## 2. Product constraints

### 2.1 Реальные собаки будут важнее породных архетипов

На старте можно использовать понятные архетипы:

- такса;
- шпиц / померанский тип;
- лабрадор;
- хаски;
- корги;
- сенбернар / крупный спокойный тип;
- мопсовый / короткомордый тип;
- дворняга.

Но в долгую игра должна поддерживать реальных приютских собак. Большинство таких собак не будут чистыми породами. Они будут дворнягами, метисами, смешанными типами, с неидеальными пропорциями, разными ушами, хвостами, пятнами, шерстью и мордами.

Вывод:

> Породные архетипы нужны только как учебные крайние точки формы. Основная production-система должна быть системой дворняг / mixed shelter dogs.

### 2.2 Нельзя делать отдельный полный animation set для каждой собаки

Если каждая собака требует отдельные walk / carry / idle / work / rest / emotion clips, production scope быстро станет невозможным.

Вывод:

> Нужна переиспользуемая skeletal / rig-based animation system, где разные собаки натягиваются на общий или вариативный скелет и используют общие клипы с минимальными правками.

### 2.3 Анимация должна быть качественной

Простого набора статичных ассетов недостаточно. В Steam overlay вся ценность в медленных физических действиях: собака идёт, несёт, тащит, нюхает, поливает, толкает ящик, грузит мешок.

Если движение будет деревянным или слайдовым, игра потеряет живость.

Вывод:

> Dog system должна проектироваться сразу как animation-first, а не как набор красивых PNG.

### 2.4 Масштаб собак пока держим близким

На раннем этапе не проектируем огромный диапазон размеров. Все собаки живут в плюс-минус одном игровом масштабе, чтобы не ломать overlay readability, клипы и interaction spots.

Различия допускаются через:

- длину лап;
- длину тела;
- форму головы;
- морду;
- уши;
- хвост;
- пушистость;
- корпус;
- осанку;
- походку;
- пятна и окрас.

Не делаем пока систему, где чихуахуа в 4 раза меньше сенбернара, а сенбернар требует отдельной физики зданий и дверей.

## 3. Core art direction statement

Dog Visual Language v1:

> Shelter dogs are modular animated characters built from readable mixed-breed silhouettes, reusable skeletal animation clips, and dog-specific visual overlays. Each dog should feel individual and emotionally real, but production must remain scalable enough to support many shelter dogs.

На русском:

> Собака Shelter — это модульный анимированный персонаж: читаемый силуэт дворняги/метиса, общий или вариативный скелет, переиспользуемые клипы и индивидуальные визуальные детали. Собака должна ощущаться живой и конкретной, но не требовать ручной полной перерисовки всего набора анимаций.

## 4. Dog identity stack

Каждая собака собирается из нескольких слоёв.

### 4.1 Skeleton family

Скелетная база, определяющая пропорции и движение.

MVP skeleton families:

1. **Standard medium dog** — базовая дворняга, универсальный средний корпус.  
2. **Short-legged long body** — такса / корги / коротколапые метисы.  
3. **Compact fluffy small dog** — шпиц / маленькая пушистая дворняга.  
4. **Large calm dog** — лабрадор / сенбернар / крупный метис, но в игровом масштабе без сильного увеличения.  
5. **Short-muzzle compact dog** — мопсовый / бульдожий / короткомордый тип.

Важно: это не породы, а семейства скелетов. Реальная собака может быть смесью: стандартный скелет + короткая морда + пушистый хвост + асимметричные уши.

### 4.2 Body mesh / sprite parts

Визуальные части, которые крепятся к скелету:

- body / корпус;
- head / голова;
- muzzle / морда;
- front legs;
- back legs;
- ears;
- tail;
- fur outline / пушистый внешний контур;
- chest tuft / грудка;
- cheeks / щёки;
- optional belly / живот;
- paws.

Для production желательно, чтобы части были sprite-friendly и могли риггиться в Godot или внешнем animation tool.

### 4.3 Coat and markings

Окрас — не главный способ различать собак, но важный слой индивидуальности.

Поддерживаем:

- однотонный окрас;
- пятна;
- маска;
- носочки;
- белая грудка;
- пятно на глазу;
- асимметричные уши;
- кончик хвоста другого цвета;
- седина на морде;
- лёгкие шрамы / следы жизни только если они не делают образ жалостливым или травматичным.

Запрещено опираться только на перекраску. Если две собаки отличаются только цветом, система не работает.

### 4.4 Personality props

Небольшие визуальные признаки, которые не стирают собаку:

- ошейник;
- платочек;
- рабочая шлейка;
- удобные тапочки;
- мягкий жилет;
- любимая игрушка;
- маленький значок;
- рабочий аксессуар.

Это слой D-010: изменяемые / экипируемые / приобретённые особенности. Они должны усиливать индивидуальность, а не заменять врождённый силуэт.

### 4.5 Animation personality

Индивидуальность должна жить не только в картинке, но и в движении.

Примеры:

- аккуратная собака несёт мешок ровно и медленно;
- смешная собака подпрыгивает на шаге;
- коротколапая собака чуть чаще переставляет лапы;
- крупная спокойная собака идёт тяжеловато, но мягко;
- пушистая собака сильнее машет хвостом;
- осторожная собака делает паузу перед новым объектом;
- радостная собака виляет всем корпусом.

Важно: это не отдельные клипы для каждой собаки, а параметры / additive motion / timing offsets поверх базовых клипов.

## 5. Animation architecture direction

### 5.1 Базовая идея

Нужна система:

```text
Skeleton Family -> Shared Animation Clips -> Dog-Specific Mesh/Sprite Parts -> Personality Offsets -> In-game Action
```

То есть:

1. У собаки есть skeleton family.  
2. Skeleton family использует общий набор клипов.  
3. Визуальные части конкретной собаки натянуты на этот скелет.  
4. Поверх клипа добавляются небольшие индивидуальные параметры.  
5. В игре это выглядит как конкретная живая собака.

### 5.2 Почему не frame-by-frame per dog

Frame-by-frame может выглядеть прекрасно, но плохо масштабируется для реальных приютских собак.

Для 1 собаки даже минимальный набор может включать:

- idle;
- walk;
- trot / hurry;
- carry bag;
- pull cart;
- push crate;
- watering;
- painting;
- sniff;
- sit;
- lie;
- sleep;
- happy;
- tired;
- turn;
- interact.

Если каждую такую анимацию рисовать отдельно для каждой собаки, production становится неуправляемым.

### 5.3 Что нужно вместо этого

Базовый подход:

- skeletal / cutout animation;
- общий набор клипов на skeleton family;
- modular body parts;
- per-dog пропорции внутри допустимого диапазона;
- отдельные swap-parts для ушей, хвоста, морды, шерсти;
- additive / secondary motion для хвоста, ушей, шерсти;
- отдельные held-object layers для мешков, леек, коробок, инструментов.

## 6. Clip library v1

### 6.1 MVP essential clips

Для первого production-feel прототипа нужны не все клипы, а минимальный набор, который доказывает жизнь.

MVP clips:

1. **Idle neutral** — стоит, дышит, моргает, чуть двигает хвостом.  
2. **Walk empty** — обычная ходьба.  
3. **Walk carrying light object** — несёт лёгкий предмет в пасти / на шлейке.  
4. **Walk carrying heavy bag** — несёт / тащит мешок медленнее.  
5. **Pull cart** — тянет маленькую тележку.  
6. **Push crate** — толкает ящик.  
7. **Watering** — поливает лейкой.  
8. **Work loop small** — универсальный короткий рабочий цикл: клеит ярлык / красит / чинит / перемешивает.  
9. **Sit / rest** — садится или отдыхает рядом с модулем.  
10. **Happy reaction** — маленькая радостная реакция после завершения действия.

Это минимум, который уже даст Steam overlay ощущение живого кооператива.

### 6.2 Nice-to-have clips

После MVP:

- lie down;
- sleep;
- sniff ground;
- play with toy;
- look at player;
- wag tail strong;
- stretch;
- shake fur;
- turn around;
- climb tiny step;
- load van;
- unload crate;
- decorate room;
- eat from bowl;
- drink water;
- greet another dog.

### 6.3 Action objects as separate layers

Предметы должны быть отдельными слоями / sockets, а не зашитыми в тело собаки.

Sockets:

- mouth socket;
- chest / harness socket;
- front paws socket;
- side cart hitch;
- back / saddlebag socket;
- tool socket.

Objects:

- food bag;
- crate;
- watering can;
- brush;
- label board;
- toy;
- bowl;
- small package;
- roll of cloth / wallpaper;
- leash / harness / cart connector.

Это позволит одной и той же собаке использовать разные action props без полной перерисовки.

## 7. Skeleton family requirements

### 7.1 Standard medium dog

Назначение: основная дворняга / mixed shelter dog.

Характеристики:

- нейтральная длина тела;
- средние лапы;
- умеренная голова;
- допускает разные уши и хвосты;
- главный production baseline.

Должен поддерживать все MVP clips.

### 7.2 Short-legged long body

Назначение: такса, корги, коротколапые метисы.

Характеристики:

- длиннее корпус;
- ниже лапы;
- чаще шаг;
- тяжелее читать предмет у земли, поэтому предметы нужно укрупнять.

Должен поддерживать:

- walk;
- carry;
- pull cart;
- push crate;
- idle;
- happy.

Watering / vertical work может требовать адаптаций.

### 7.3 Compact fluffy small dog

Назначение: шпиц, маленькая пушистая дворняга.

Характеристики:

- компактное тело;
- крупная шерстяная масса;
- хвост может быть кольцом;
- силуэт легко превращается в шар, поэтому нужны читаемые лапы и морда.

Должен поддерживать:

- walk;
- carry light object;
- idle;
- happy;
- work small;
- play/toy later.

### 7.4 Large calm dog

Назначение: лабрадор, сенбернар, крупный метис.

Характеристики:

- крупнее по ощущению, но не ломает игровой scale;
- медленнее шаг;
- более тяжёлый корпус;
- мягкий добрый силуэт.

Должен поддерживать:

- carry heavy bag;
- push crate;
- pull cart;
- watering;
- load/unload later.

### 7.5 Short-muzzle compact dog

Назначение: мопсовый / бульдожий / короткомордый метис.

Характеристики:

- короткая морда;
- круглее голова;
- компактный корпус;
- осторожно с экстремальными породными чертами, чтобы не делать карикатуру.

Должен поддерживать стандартные клипы, но mouth socket может требовать отдельной позиции.

## 8. Readability requirements

### 8.1 Order of readability

Собака должна читаться в таком порядке:

1. Это собака.  
2. Это конкретный тип тела / силуэт.  
3. Она делает действие.  
4. Видно, какой предмет участвует в действии.  
5. Читается настроение.  
6. Читаются индивидуальные детали.

Если цвет шерсти читается раньше действия, это нормально. Если декор ошейника читается раньше действия — плохо.

### 8.2 Heights

Проверяем на тех же высотах, что overlay assets:

- 216 px — комфорт, видны индивидуальные детали.  
- 144 px — рабочий минимум, должны читаться тип собаки + действие + предмет.  
- 96 px — stress test, должны читаться собака + движение + крупный предмет.

### 8.3 Silhouette test

Каждый dog archetype должен проходить black silhouette test:

- без цвета;
- без пятен;
- без выражения лица;
- без UI;
- в 96 / 144 / 216 px.

Pass если тип хотя бы частично узнаваем по форме.

Fail если все собаки превращаются в одинаковые овалы с разными хвостами.

## 9. Mixed shelter dog system

### 9.1 Главный принцип

Дворняга — не “порода по умолчанию”. Дворняга — главный герой системы.

Для реальных приютских собак нужно уметь описывать собаку не породой, а набором визуальных признаков:

```text
medium body + slightly short legs + one floppy ear + one half-up ear + narrow muzzle + curled tail + white chest + brown eye patch
```

То есть собака создаётся как комбинация признаков, а не как выбор из породного списка.

### 9.2 Morphology tags

Для описания реальной собаки использовать теги.

Body:

- compact;
- medium;
- long;
- sturdy;
- slim;
- fluffy;
- barrel-chested;
- narrow-chested.

Legs:

- short;
- medium;
- long;
- thin;
- sturdy.

Head:

- round;
- wedge;
- blocky;
- narrow;
- short-muzzle;
- long-muzzle.

Ears:

- both upright;
- both floppy;
- one up one down;
- half-floppy;
- tiny;
- large.

Tail:

- straight;
- curled;
- fluffy;
- short;
- long;
- raised;
- low.

Fur:

- smooth;
- medium;
- shaggy;
- fluffy;
- wiry.

Markings:

- mask;
- eye patch;
- socks;
- white chest;
- spotted;
- brindle-like simplified;
- asymmetric.

### 9.3 Real dog intake workflow

Когда в игру добавляется реальная приютская собака, art intake должен быть таким:

1. Получить фото / описание собаки.  
2. Определить skeleton family.  
3. Разобрать morphology tags.  
4. Выбрать body parts / shape variants.  
5. Назначить coat / markings.  
6. Добавить 1–2 personality props только если они соответствуют истории собаки.  
7. Выбрать animation personality offsets.  
8. Проверить silhouette + readability.  
9. Проверить, что собака не стала жалостливой карикатурой или породным стереотипом.  
10. Прогнать 3–5 ключевых клипов.

## 10. Personality offsets

Чтобы собаки не были одинаковыми даже на одном скелете, вводим параметры движения.

Возможные параметры:

- walk speed multiplier;
- step frequency;
- head bob amount;
- tail wag amplitude;
- tail wag frequency;
- ear bounce amount;
- body squash/stretch subtle amount;
- pause probability;
- look-around frequency;
- happy reaction intensity;
- carrying effort amount;
- idle fidget type.

Важно: offsets должны быть тонкими. Нельзя превращать собак в мультяшных резиновых клоунов, если это не отдельный осознанный стиль.

## 11. Animation quality rules

### 11.1 Движение должно быть физически понятным

Если собака несёт мешок, мешок должен иметь вес. Если тянет тележку, должна быть видна связь, усилие и инерция. Если поливает, лейка должна быть связана с позой.

Запрещено:

- собака скользит без работы лап;
- предмет телепортируется;
- лапы не касаются земли;
- тележка едет отдельно от собаки;
- carry object слишком мелкий;
- действие понятно только по подписи.

### 11.2 Secondary motion важен

Для живости нужны:

- хвост;
- уши;
- шерсть;
- шлейка / аксессуар;
- лёгкое качание предмета;
- тележка / колесо;
- мешок с небольшим весом.

Но secondary motion не должен шуметь в 96 px.

### 11.3 Animation loops должны быть спокойными

Shelter не должен выглядеть как hyperactive mobile game.

Темп:

- медленный;
- наблюдательный;
- уютный;
- без постоянного дерганья;
- без overacting в каждом кадре.

## 12. Dog scale rules v1

На v1 все собаки живут в близком игровом масштабе.

Допустимые различия:

- коротколапая собака ниже, но не в два раза;
- крупная собака шире и тяжелее, но не ломает двери/объекты;
- пушистая собака визуально больше за счёт шерсти;
- длинная собака занимает больше горизонтального места;
- мопсовый тип имеет другую голову, но не требует отдельной сцены.

Нельзя пока:

- делать реалистичный масштаб пород 1:1;
- проектировать отдельные двери/станции под каждый размер;
- требовать unique clip set для giant/tiny dogs.

## 13. Art production pipeline hypothesis

На уровне арт-дирекции предлагается проверить такой pipeline:

1. Нарисовать 5 skeleton family concepts.  
2. Для каждого сделать black silhouette sheet.  
3. Выбрать 1 базовый skeleton family для технического spike.  
4. Сделать modular sprite parts для 3 собак на одном skeleton family.  
5. Сделать 3 shared clips: idle, walk, carry bag.  
6. Проверить в Godot: scale, clipping, readability, performance.  
7. После pass расширить clip library и skeleton families.

## 14. First test pack

### 14.1 Dog shape pack v1

Собрать 8 dog shape concepts:

1. Standard mixed shelter dog.  
2. Short-legged long dog.  
3. Compact fluffy dog.  
4. Large calm dog.  
5. Short-muzzle compact dog.  
6. One-ear-up mixed dog.  
7. Slim long-legged mixed dog.  
8. Shaggy asymmetric mixed dog.

Для каждого:

- side-view neutral pose;
- black silhouette version;
- 96 / 144 / 216 px readability row;
- morphology tags;
- likely skeleton family.

### 14.2 Animation test pack v1

Выбрать 3 собаки:

1. Standard mixed shelter dog.  
2. Short-legged long dog.  
3. Large calm dog.

Для них проверить на shared / adapted skeleton:

- idle;
- walk;
- carry food bag.

Цель: доказать, что одна animation system может поддерживать разных собак без полной ручной перерисовки.

## 15. Prompt direction for dog shape concepts

Для первых визуальных прогонов не просить “породы”. Просить mixed shelter dog morphology.

Пример base prompt:

```text
Create a side-view character design sheet for Shelter dog visual language.

A warm 2D illustrated modular dog character for a cozy charity idle game. The dog should feel like a real mixed shelter dog, not a purebred mascot. Clear readable silhouette, simple animation-friendly body parts, side-view pose for a bottom desktop overlay strip, suitable for skeletal / cutout animation. Focus on body shape, head shape, ears, tail, leg length, fur outline and markings. Warm, kind, calm, dog-centered. Designed to remain readable at 96, 144 and 216 px heights.

Show: neutral side pose, black silhouette, simple morphology labels, and one tiny action pose carrying a readable food bag.

Avoid: hyper-cute chibi proportions, human-like dog, cartoon mascot with giant head, realistic photo rendering, sad rescue-poster expression, aggressive pose, fantasy costume, combat, horror, tiny unreadable legs, over-detailed fur.
```

## 16. Rejection rules

Reject dog visual direction if:

- все собаки отличаются только окрасом;
- собака выглядит как mascot, а не житель Shelter;
- голова слишком огромная и ломает body mechanics;
- лапы слишком маленькие для читаемой ходьбы;
- морда/уши/хвост не дают силуэт;
- объект в действии не читается;
- собака выглядит жалостливо и эксплуатирует guilt;
- собака выглядит как человек в костюме;
- clip невозможно переиспользовать на похожих собаках;
- animation requires full redraw per dog for every action.

## 17. Open questions

1. Какой animation tool выбираем для production: Godot Skeleton2D / AnimationPlayer, Spine, DragonBones-like workflow, Creature-like workflow или кастомный pipeline?  
2. Насколько Godot 4.x удобен для runtime cutout animation собак в overlay performance budget?  
3. Нужны ли portrait/card версии собак отдельно от in-strip rigged dog?  
4. Сколько skeleton families реально нужно в MVP: 1, 3 или 5?  
5. Можно ли first MVP сделать на одном standard skeleton + scale/shape variants, а остальные skeleton families добавить позже?  
6. Как хранить реальные приютские dog profiles: morphology tags, source photos, approval status, legal/photo permissions?  
7. Какой уровень similarity допустим при переводе реальной собаки в stylized Shelter dog, чтобы собака была узнаваема, но не требовала фотореализма?

## 18. Next best step

Следующий арт-директорский шаг:

> Сделать Dog Shape Pack v1: 8 side-view mixed shelter dog silhouettes + morphology tags + 96/144/216 readability rows.

Следующий technical / Codex-adjacent шаг после shape pack:

> Проверить skeletal animation pipeline на 3 собаках и 3 клипах: idle, walk, carry food bag.

