# DOG_SHAPE_PACK v1 — Brief

Дата: 2026-06-28  
Роль документа: Art Direction Deliverable Brief  
Связано с: `03_DESIGN/00_VISUAL_DIRECTION/DOG_VISUAL_LANGUAGE_v1.md`

## 1. Цель

Собрать первый визуальный пакет собак Shelter, который проверяет не породы как коллекцию, а систему mixed shelter dog morphology.

Главная цель:

> Найти читаемый animation-friendly язык собак, который подходит для реальных приютских дворняг и может работать со skeletal / cutout animation pipeline.

Этот pack не является финальным production set. Это shape-language и readability pass.

## 2. Что должно быть в pack

8 side-view dog shape concepts:

1. Standard mixed shelter dog.  
2. Short-legged long dog.  
3. Compact fluffy dog.  
4. Large calm dog.  
5. Short-muzzle compact dog.  
6. One-ear-up mixed dog.  
7. Slim long-legged mixed dog.  
8. Shaggy asymmetric mixed dog.

Для каждой собаки нужны:

- neutral side-view pose;
- black silhouette;
- morphology tags;
- likely skeleton family;
- tiny carrying-food-bag action pose;
- readability rows at 216 / 144 / 96 px.

## 3. Общие правила

### 3.1 Не делаем purebred mascot pack

Породы можно использовать как ориентиры формы, но результат должен ощущаться как реальные приютские собаки / метисы.

Запрещено:

- “8 породных иконок”;  
- собаки отличаются только цветом;  
- чрезмерно чиби-головы;  
- mascot vibe;  
- одинаковый корпус с разными ушами;  
- жалостливый rescue-poster tone.

### 3.2 Animation-first

Каждая собака должна выглядеть так, будто её можно риггить:

- понятный корпус;
- читаемые лапы;
- отдельная голова;
- читаемая морда;
- уши и хвост как возможные secondary-motion parts;
- шерсть не должна мешать лапам и силуэту;
- предмет в carry pose должен крепиться к mouth / harness / front-paws socket.

### 3.3 Scale discipline

Все собаки в близком игровом масштабе. Различия есть, но не ломают общую animation system.

Допускается:

- ниже / выше в пределах читаемого диапазона;
- длиннее / короче корпус;
- пушистее / худее;
- разная морда;
- разные хвосты и уши.

Не допускается:

- гигантская сенбернарская собака, требующая отдельного мира;
- микрособака, которую не видно в overlay;
- реалистичный масштаб пород как главная цель.

## 4. Dog concepts

### 4.1 Standard mixed shelter dog

Purpose: базовая дворняга, главный reference для production.

Morphology direction:

- medium body;
- medium legs;
- slightly wedge head;
- one soft floppy ear or half-floppy ears;
- medium tail;
- smooth / medium fur;
- asymmetrical chest marking.

Skeleton family: Standard medium dog.

Must prove:

- обычная дворняга может быть главным героем, а не generic default.

### 4.2 Short-legged long dog

Purpose: коротколапый метис / такса-корги край формы.

Morphology direction:

- long body;
- short legs;
- readable chest and belly line;
- longer muzzle or corgi-like ear option;
- tail medium / slightly raised.

Skeleton family: Short-legged long body.

Must prove:

- короткие лапы читаются, но собака всё ещё может анимироваться без микролап.

### 4.3 Compact fluffy dog

Purpose: маленькая пушистая собака без превращения в шарик.

Morphology direction:

- compact body;
- fluffy outline;
- visible short-to-medium legs;
- small pointed or half-fluffy ears;
- curled or fluffy tail;
- face remains readable.

Skeleton family: Compact fluffy small dog.

Must prove:

- пушистость даёт характер, но не убивает силуэт лап и движения.

### 4.4 Large calm dog

Purpose: крупный спокойный тип, лабрадор/сенбернар/крупный метис в игровом масштабе.

Morphology direction:

- sturdy body;
- broad chest;
- soft large head;
- kind posture;
- medium floppy ears;
- thick tail;
- not too tall for overlay.

Skeleton family: Large calm dog.

Must prove:

- ощущение большой доброй собаки возможно без real-size scale break.

### 4.5 Short-muzzle compact dog

Purpose: мопсовый / бульдожий / короткомордый mixed type без карикатуры.

Morphology direction:

- compact sturdy body;
- short muzzle;
- rounder head;
- small folded ears;
- curled or short tail;
- clear legs.

Skeleton family: Short-muzzle compact dog.

Must prove:

- короткомордый тип читается без превращения в мемного mascot.

### 4.6 One-ear-up mixed dog

Purpose: асимметрия как признак реальной приютской собаки.

Morphology direction:

- medium / slim body;
- one upright ear, one floppy ear;
- curious posture;
- medium muzzle;
- expressive tail;
- asymmetric markings.

Skeleton family: Standard medium dog.

Must prove:

- реальные “неидеальные” признаки дают индивидуальность лучше, чем чистая порода.

### 4.7 Slim long-legged mixed dog

Purpose: худой, длиннолапый, быстрый mixed type.

Morphology direction:

- slim body;
- longer legs;
- narrow chest;
- longer muzzle;
- upright or half-up ears;
- long tail.

Skeleton family: Standard medium dog or separate slim variant later.

Must prove:

- длинные лапы и лёгкость читаются без выхода из общего масштаба.

### 4.8 Shaggy asymmetric mixed dog

Purpose: лохматая дворняга с неровной шерстью и пятнами.

Morphology direction:

- medium body;
- shaggy outline;
- uneven fur tufts;
- one eye patch or asymmetrical face marking;
- tail fluffy / irregular;
- legs remain visible.

Skeleton family: Standard medium dog or compact fluffy variant.

Must prove:

- лохматость и асимметрия работают в small overlay readability.

## 5. Master prompt for board generation

```text
Create a character shape language board for Shelter Dog Visual Language v1.

Design 8 side-view mixed shelter dog concepts for a warm cozy charity idle game about dogs helping shelters. These are not purebred mascot icons; they are stylized real mixed shelter dogs with clear readable silhouettes and animation-friendly body parts.

For each dog, show:
1. neutral side-view pose,
2. black silhouette version,
3. tiny action pose carrying one readable beige food bag,
4. simple morphology tags,
5. likely skeleton family label.

Dog concepts:
- standard mixed shelter dog,
- short-legged long dog,
- compact fluffy dog,
- large calm dog,
- short-muzzle compact dog,
- one-ear-up mixed dog,
- slim long-legged mixed dog,
- shaggy asymmetric mixed dog.

Art direction: warm 2D illustrated modular diorama style, simple readable shapes, dog-centered, gentle, calm, animation-first, suitable for skeletal / cutout animation in a bottom desktop overlay strip. Clear body, head, muzzle, legs, ears and tail. Fur and markings should support the silhouette, not hide it.

Scale: all dogs live in roughly the same game scale, with proportion differences but no extreme realistic size range. Designed for readability at 216, 144 and 96 px heights.

Avoid: purebred collection, identical bodies with different colors, hyper-cute chibi giant heads, human-like dogs, fantasy costumes, sad rescue-poster guilt imagery, aggressive pose, photo-realistic rendering, tiny unreadable legs, over-detailed fur, dogs that cannot be rigged or animated.
```

## 6. Per-dog prompt skeleton

```text
Create one side-view mixed shelter dog concept for Shelter Dog Visual Language v1.

Dog type: [TYPE].
Morphology: [BODY], [LEGS], [HEAD], [MUZZLE], [EARS], [TAIL], [FUR], [MARKINGS].
Skeleton family: [SKELETON FAMILY].
Pose: neutral side-view standing pose, animation-friendly, readable legs and joints.
Action test: same dog carrying one large readable beige food bag.
Readability: must remain recognizable at 216, 144 and 96 px heights.
Style: warm 2D illustrated modular diorama, calm, kind, dog-centered, mixed shelter dog, not purebred mascot.
Avoid: chibi giant head, human-like pose, sad guilt expression, over-detailed fur, tiny legs, purebred show-dog perfection, aggressive or combat pose.
```

## 7. Readability matrix

For each dog:

Dog name / type:

- Dog readable at 216 px: yes / partial / no
- Dog readable at 144 px: yes / partial / no
- Dog readable at 96 px: yes / partial / no
- Silhouette distinct: yes / partial / no
- Morphology distinct without color: yes / partial / no
- Carrying object readable: yes / partial / no
- Animation-friendly parts: yes / partial / no
- Risk: low / medium / high
- Notes:

## 8. Pass criteria

Pack passes if:

- at least 6/8 dogs have distinct black silhouettes;
- at least 6/8 read as dogs at 96 px;
- at least 5/8 can plausibly share one of the MVP skeleton families;
- standard mixed shelter dog feels like a real protagonist, not placeholder default;
- no dog depends only on coat color for identity;
- carry food bag action is readable for at least 6/8;
- none of the dogs create guilt / pity / exploitation tone.

## 9. Fail criteria

Pack fails if:

- it becomes a purebred breed chart;
- all dogs share one generic body;
- dogs are too chibi / mascot-like;
- legs are too tiny for animation;
- fur hides all joints;
- scale differences are too extreme;
- real shelter dog translation feels impossible;
- each dog appears to require fully custom frame-by-frame clips.

## 10. Next step after pack

If Dog Shape Pack v1 passes, choose 3 dogs for Animation Test Pack v1:

1. Standard mixed shelter dog.  
2. Short-legged long dog.  
3. Large calm dog.

Test clips:

- idle;
- walk;
- carry food bag.

Goal:

> Prove that Shelter can make real-looking individual shelter dogs through shared skeletal clips and dog-specific visual parts, without creating a full custom animation set for every dog.
