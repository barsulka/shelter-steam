# DOG_RUNTIME_AND_ANIMATION_GRAMMAR v1

Дата: 2026-06-28  
Роль документа: Character System Architecture / Art Direction / Animation Direction  
Статус: working draft  
Связано с: `DOG_VISUAL_LANGUAGE_v1.md`, D-010 Dogs, D-011 Cozy Modular Diorama

## 1. Главная идея

Shelter не должен производить собак как набор отдельных картинок.

Shelter должен производить собак как живую систему:

```text
Dog DNA -> Morphology -> Rig -> Animation Grammar -> Personality Motion -> Runtime Behaviour -> Rendered Dog
```

Собака в Shelter — это не один ассет. Это рецепт, который собирается из формы, рига, движения, поведения, визуальных деталей и истории.

Главная формула:

> Реальная приютская собака должна становиться игровым персонажем через Dog DNA, а не через полную ручную перерисовку всех анимаций.

## 2. Почему это важно

Проект будет встраивать реальных приютских собак. Большинство из них — дворняги и метисы, а не чистые породы.

Если pipeline требует уникальной frame-by-frame анимации для каждой собаки, система не масштабируется.

Если pipeline даёт только генератор одинаковых собак с разным окрасом, собаки теряют личность.

Нужна третья модель:

> modular character system + reusable animation grammar + индивидуальная morphology/personality layer.

## 3. Термины

### 3.1 Dog DNA

Техническое описание конкретной собаки: форма, части тела, окрас, риг, совместимость с клипами, поведенческий профиль, motion offsets, история и production metadata.

Dog DNA — это не биология. Это production-рецепт.

### 3.2 Morphology Space

Параметрическое пространство формы собаки:

- длина лап;
- длина корпуса;
- объём корпуса;
- форма головы;
- длина морды;
- тип ушей;
- тип хвоста;
- объём шерсти;
- паттерн окраса;
- асимметрия.

Реальная дворняга — не исключение из системы. Она точка внутри Morphology Space.

### 3.3 Skeleton Family

Семейство ригов, которое обслуживает группу похожих морфологий.

Skeleton Family — не порода. Это production compromise между разнообразием собак и переиспользованием клипов.

### 3.4 Animation Grammar

Не набор “готовых анимаций”, а система слоёв и модификаторов, из которых собирается движение:

```text
base locomotion + head look + tail motion + ear motion + object weight + task focus + personality offset
```

### 3.5 Personality Motion

Параметры, которые заставляют одну и ту же базовую анимацию ощущаться по-разному у разных собак.

Например: любопытная собака чаще смотрит по сторонам, осторожная делает больше пауз, радостная активнее виляет хвостом.

## 4. Dog Runtime object

На уровне концепции каждая собака должна описываться так:

```yaml
dog_id: DOG-000001
public_name: Бублик
source_type: shelter_real_dog | fictional_seed | prototype

morphology:
  skeleton_family: standard_medium
  body_length: medium
  body_volume: sturdy
  leg_length: medium_short
  head_shape: wedge_soft
  muzzle_length: medium
  ears: one_up_one_floppy
  tail: curled_medium
  fur: shaggy_medium
  markings: white_chest_left_eye_patch

rig:
  rig_version: dog_rig_standard_v0
  compatible_clip_sets:
    - locomotion_basic_v0
    - carry_basic_v0
    - work_basic_v0
  required_overrides:
    - ear_secondary_motion_asymmetric
    - tail_curl_socket

appearance:
  base_coat: warm_brown
  secondary_coat: cream
  accent_marks:
    - left_eye_patch
    - white_chest
    - white_paws
  accessories:
    - soft_green_collar

animation_profile:
  walk_speed_multiplier: 1.05
  step_frequency: 1.1
  head_bob_amount: 0.8
  tail_wag_amplitude: 1.2
  tail_wag_frequency: 1.1
  look_around_frequency: 1.4
  idle_fidget: curious_sniff
  carrying_effort: medium

personality:
  motion_preset: curious_helper
  behaviour_preset: gentle_worker
  social_preset: friendly_with_pauses

story:
  shelter_ref: TBD
  short_bio: TBD
  permissions_status: TBD

production:
  approval_status: draft
  first_added_version: TBD
  notes: TBD
```

Это не финальная schema, а арт-директорский shape of data.

## 5. Dog DNA channels

Dog DNA лучше описывать независимыми каналами, а не породой.

### 5.1 Body channels

- `body_length`: short / medium / long  
- `body_volume`: slim / medium / sturdy / fluffy  
- `chest`: narrow / medium / broad / barrel  
- `back_line`: straight / soft_curve / slightly_sagging / proud  
- `belly_line`: tucked / neutral / soft

### 5.2 Leg channels

- `leg_length`: short / medium_short / medium / medium_long / long  
- `leg_thickness`: thin / medium / sturdy  
- `paw_size`: small / medium / large  
- `step_style`: quick / neutral / heavy / bouncy

### 5.3 Head channels

- `head_shape`: round / wedge / blocky / narrow / soft_square  
- `muzzle_length`: short / medium / long  
- `muzzle_width`: narrow / medium / broad  
- `forehead`: flat / soft / round  
- `cheeks`: none / soft / fluffy

### 5.4 Ear channels

Важно разделять форму уха, позу уха и физику уха.

- `ear_family`: upright / floppy / half_floppy / button / tiny / large  
- `ear_pose_left`: up / down / half / back / side  
- `ear_pose_right`: up / down / half / back / side  
- `ear_weight`: light / medium / heavy  
- `ear_motion`: stiff / bounce / soft_swing / asymmetric

### 5.5 Tail channels

- `tail_family`: straight / curled / fluffy / short / long / plume  
- `tail_default_pose`: high / neutral / low / curled_over_back  
- `tail_weight`: light / medium / heavy  
- `tail_motion`: small_wag / broad_wag / slow_sway / curl_wiggle

### 5.6 Fur channels

- `fur_length`: smooth / short / medium / shaggy / fluffy  
- `fur_volume`: low / medium / high  
- `fur_direction`: smooth_back / chest_tuft / cheek_fluff / leg_feathers / uneven  
- `fur_motion`: none / subtle / visible_secondary

### 5.7 Marking channels

- `base_coat`  
- `secondary_coat`  
- `mask`  
- `eye_patch_left` / `eye_patch_right`  
- `white_chest`  
- `socks`  
- `tail_tip`  
- `asymmetry_level`  
- `spots`  
- `brindle_simplified`

### 5.8 Accessory channels

- `collar`  
- `bandana`  
- `harness`  
- `work_vest`  
- `soft_booties`  
- `name_tag`  
- `favorite_toy`  
- `task_tool`

Accessory channels относятся к D-010 mutable/equippable traits. Они не должны заменять врождённую индивидуальность собаки.

## 6. Skeleton families v0

Для MVP не нужно сразу делать много ригов.

Рекомендация арт-дирекции:

### Phase 1 — one rig proof

Один базовый `standard_medium` rig.

Цель: доказать, что Dog Runtime + shared clips вообще работают.

### Phase 2 — three rig MVP

1. `standard_medium` — главный mixed shelter dog baseline.  
2. `short_long` — коротколапые / длиннокорпусные собаки.  
3. `large_sturdy` — крупные спокойные собаки в игровом масштабе.

### Phase 3 — five rig expansion

4. `compact_fluffy` — маленькие пушистые / шпицеобразные метисы.  
5. `short_muzzle` — короткомордые компактные собаки.

Важно: не делать 8–12 skeleton families до технической проверки. Чем больше ригов, тем выше стоимость клипов.

## 7. Animation Grammar v0

### 7.1 Base layers

Каждое движение собирается из слоёв.

```text
Base Pose
+ Locomotion
+ Body Effort
+ Head Layer
+ Ear Layer
+ Tail Layer
+ Object Layer
+ Personality Offsets
+ Task Intent
+ Micro Behaviours
```

### 7.2 Base Pose

Базовая стойка собаки:

- neutral stand;
- sit;
- lie;
- work stance;
- carry stance;
- pull stance;
- push stance.

### 7.3 Locomotion

Базовые движения:

- idle;
- walk;
- slow walk;
- hurry walk;
- turn;
- stop;
- start;
- small step adjust.

### 7.4 Body Effort

Модификаторы усилия:

- empty;
- light carry;
- medium carry;
- heavy carry;
- pull tension;
- push resistance;
- careful balance;
- relaxed.

Пример:

```text
walk + heavy carry = медленнее шаг, ниже голова, сильнее body bob, предмет качается тяжелее
```

### 7.5 Head Layer

- look forward;
- look at target;
- look up;
- look down;
- sniff ground;
- glance at other dog;
- blink;
- small head tilt.

### 7.6 Ear Layer

- neutral;
- bounce on step;
- perk up;
- soft droop;
- asymmetric bounce;
- alert twitch.

### 7.7 Tail Layer

- neutral sway;
- happy wag;
- slow calm wag;
- focused stillness;
- low cautious tail;
- curl wiggle.

### 7.8 Object Layer

Предметы должны влиять на движение.

Object properties:

```yaml
object_id: food_bag
weight_class: medium
carry_socket: mouth_or_harness
swing: soft
size_readability: high
affects_walk: true
```

Вместо отдельной анимации “нести мешок”:

```text
walk + carry_object(food_bag, medium_weight) + focused_task
```

### 7.9 Task Intent

Что собака сейчас делает:

- going_to_task;
- carrying_resource;
- delivering_to_storage;
- watering;
- painting;
- pushing_crate;
- pulling_cart;
- loading_van;
- resting;
- greeting;
- inspecting.

Task Intent выбирает набор допустимых micro behaviours. Например, собака с мешком не должна внезапно активно играть, если это ломает читаемость задачи.

### 7.10 Micro Behaviours

Маленькие вставки, которые делают собаку живой:

- sniff;
- blink;
- tail wag burst;
- ear twitch;
- look around;
- tiny pause;
- paw adjust;
- shake head;
- happy hop;
- stretch;
- look at player;
- look at another dog.

Micro behaviours должны быть редкими и спокойными. Игра не должна дёргаться как overloaded mobile idle.

## 8. Personality Motion System

Характер собаки должен влиять на движение.

### 8.1 Curious Helper

Визуально:

- чаще смотрит по сторонам;
- иногда нюхает;
- хвост живой;
- делает короткие паузы у новых объектов.

Parameters:

```yaml
look_around_frequency: high
sniff_frequency: medium_high
tail_wag_amplitude: medium_high
pause_probability: medium
step_energy: medium
```

### 8.2 Calm Worker

Визуально:

- двигается ровно;
- меньше суеты;
- хорошо несёт тяжёлые предметы;
- хвост медленно качается.

```yaml
walk_speed: medium_low
step_energy: low
head_bob: low
tail_wag_frequency: low
carrying_effort_stability: high
pause_probability: low
```

### 8.3 Happy Bouncy

Визуально:

- лёгкий подпрыгивающий шаг;
- частые happy tail bursts;
- иногда маленький hop после завершения задачи.

```yaml
step_energy: high
tail_wag_frequency: high
happy_reaction_intensity: high
head_bob: medium_high
pause_probability: medium_low
```

### 8.4 Careful Gentle

Визуально:

- осторожно подходит к объектам;
- мягко несёт предмет;
- чаще замедляется перед поворотами.

```yaml
walk_speed: low_medium
turn_speed: low
object_swing: low
look_at_target_frequency: high
pause_before_interaction: high
```

### 8.5 Sleepy Soft

Визуально:

- медленная походка;
- длинные blink;
- низкая энергия;
- часто отдыхает.

```yaml
walk_speed: low
blink_duration: high
idle_rest_probability: high
tail_wag_amplitude: low
head_bob: low
```

## 9. Runtime behaviour grammar

Собака не просто проигрывает клип. Она выполняет маленькую поведенческую фразу.

Пример: “идти за мешком”.

```text
receive_task
-> orient_to_target
-> head_look(target)
-> optional_tail_wag
-> start_walk
-> locomotion_to_pickup
-> micro_behaviour_allowed(sniff/look) if not urgent
-> arrive
-> small_step_adjust
-> pickup_object
-> carry_walk_to_destination
-> deliver
-> happy_reaction_or_calm_return
```

Пример: “толкать ящик”.

```text
receive_task
-> orient_to_crate
-> walk_to_crate
-> inspect_crate
-> push_stance
-> push_loop + resistance
-> micro_pause_if_heavy
-> finish_push
-> shake_or_happy_reaction
```

Это позволяет делать собак живыми без уникальной длинной анимации на каждую задачу.

## 10. Clip set v0 for technical spike

Для первого технического spike не нужен полный набор.

Нужны клипы:

1. `idle_neutral`  
2. `walk_empty`  
3. `walk_carry_medium`  
4. `turn_or_flip`  
5. `pickup_pose`  
6. `deliver_pose`  
7. `tail_wag_additive`  
8. `head_look_additive`  
9. `ear_bounce_additive`

Минимальная демонстрация:

```text
dog stands -> looks at bag -> walks to bag -> picks up bag -> walks carrying bag -> delivers bag -> happy wag
```

Если это работает на одном rig, можно масштабировать.

## 11. Godot-facing implications

Этот документ не принимает финальное техническое решение, но задаёт требования к spike.

Нужно проверить:

- Godot Skeleton2D / Bone2D suitability;
- AnimationPlayer / AnimationTree suitability;
- layering / additive animation feasibility;
- sockets for carried objects;
- part swapping for ears/tails/heads;
- performance in always-on-top overlay;
- export compatibility Windows/macOS;
- whether external tool like Spine is worth the dependency/cost.

Важно: техническое решение должен фиксировать CTO/Codex через repo docs/ADR после spike, не только арт-директорским документом.

## 12. Production intake for real shelter dogs

Когда появится реальная собака из приюта, процесс должен быть таким:

1. Получить разрешённые фото и историю.  
2. Создать Dog DNA draft.  
3. Выбрать skeleton family.  
4. Заполнить morphology channels.  
5. Выбрать appearance/markings.  
6. Выбрать personality motion preset.  
7. Проверить на 3 mandatory clips: idle, walk, carry.  
8. Проверить, что собака узнаваема, но не фотореалистична.  
9. Проверить, что образ уважительный и не guilt-based.  
10. Утвердить dog profile для production.

## 13. Pass / fail для Dog Runtime идеи

### PASS, если:

- один rig может обслужить несколько визуально разных собак;
- одна walk-анимация ощущается по-разному через offsets;
- предметы могут подключаться через sockets;
- собака с предметом не выглядит скользящей картинкой;
- реальные mixed shelter dogs можно описать через morphology channels;
- pipeline не требует full custom animation per dog.

### FAIL, если:

- каждая форма ломает клипы;
- лапы/голова/хвост клипуют слишком сильно;
- secondary motion шумит на 96 px;
- personality offsets не заметны или выглядят дёргано;
- собаки всё равно выглядят одинаковыми;
- Godot runtime слишком тяжёлый для overlay;
- pipeline требует дорогого tooling, несовместимого с маленькой командой.

## 14. Next best tasks

### Art task A — Dog DNA schema v0

Подготовить первую таблицу Dog DNA fields:

- required fields;
- optional fields;
- allowed values;
- examples for 3 dogs.

### Art task B — Dog Shape Pack v1

Любая будущая mixed-shape production wave требует нового accepted brief;
completed Dog Shape Pack planning remains in Git history.

### Tech task C — Dog Rig Spike v0

В Godot проверить один standard medium rig:

- modular body parts;
- idle;
- walk;
- carry bag;
- tail/head additive;
- object socket.

### Producer / PM task D — Real dog intake policy

Позже нужно описать юридическую и этическую политику использования фото/историй реальных приютских собак.

## 15. Current decision proposal

Предлагаемая арт-директорская фиксация:

> Shelter dogs should be built through Dog Runtime: Dog DNA, Morphology Space, Skeleton Families, Animation Grammar and Personality Motion. Breed archetypes are allowed only as shape references. Real mixed shelter dogs are the primary long-term target. The pipeline must prioritize shared skeletal clips and modular visual parts over per-dog full animation redraws.

Статус: proposal / working direction, требует технического spike и production validation.
