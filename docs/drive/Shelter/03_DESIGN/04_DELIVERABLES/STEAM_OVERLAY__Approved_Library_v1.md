# STEAM_OVERLAY — Approved Library v1

Дата: 2026-06-25  
Обновлено: 2026-07-14 — exact four user-approved generated originals; 2026-07-13 — bounded source-promotion subset
Роль документа: Art Direction approved asset library  
Связано с: D-011 Steam Overlay Main Strip v1 Rules

## 1. Status

Approved Library v1 фиксирует первый управляемый набор Steam overlay ассетов, которые прошли арт-директорский sanity check после введения asset taxonomy.

Статус библиотеки: **approved as direction**, не финальные production exports.

Цель библиотеки:

- закрепить, какие ассеты считаются хорошими direction references;  
- сохранить ссылки на approved art files;  
- отделить Building / Utility Prop / Dog Action Sprite;  
- дать базу для следующего production pass и readability test.

## 2. Library rules

Перед добавлением нового ассета в библиотеку он должен быть классифицирован:

1. **Building / здание** — редкий крупный якорь main strip.  
2. **Utility Prop / функциональный объект** — небольшой вспомогательный объект или пауза; не должен становиться домиком.  
3. **Dog Action Sprite / действие собаки** — собака + крупный читаемый предмет/действие.

Главное правило:

> Buildings are rare anchors. Utility Props must not become houses. Dog Action Sprites are a separate meaning layer, not background decor.

Отдельно разрешены **Composition Direction Board** и **Identity / Action
Direction Board**. Это не новые gameplay- или asset-taxonomy категории: такие
PNG фиксируют принятую композицию или корпус идентичности, а editable masters
остаются в hash-locked source package.

## 3. Approved / conditionally approved assets

### 3.1 Mill v2 — Utility Prop

Status: **approved as direction**.

Repo file: [STEAM_OVERLAY__mill_v2_utility_prop__approved_direction.png](approved_art_files/STEAM_OVERLAY__mill_v2_utility_prop__approved_direction.png)

Reason:  
- наконец работает как Utility Prop, а не дом-мельница;  
- тонкий вертикальный акцент / пауза;  
- такса с тележкой и мешком усиливает функцию;  
- читается как grain/oats support.

Optional polish:  
- можно сделать на 10–15% тоньше;  
- можно чуть усилить силуэт лопастей на 96 px.

### 3.2 Storage v2 — Building

Status: **approved as direction / conditionally approved**.

Repo file: [STEAM_OVERLAY__storage_v2_building__approved_direction.png](approved_art_files/STEAM_OVERLAY__storage_v2_building__approved_direction.png)

Reason:  
- хороший functional Building anchor;  
- не ушёл в сказочный домик;  
- ящик-иконка читается;  
- собака + коробка работают.

Optional polish:  
- слегка подсушить внутреннюю детализацию;  
- уменьшить ощущение полу-interior view для 96–144 px.

### 3.3 Kitchen v2.1 — Building

Status: **approved with minor optional simplification**.

Repo file: [STEAM_OVERLAY__kitchen_v2_1_building__approved_with_minor_simplification.png](approved_art_files/STEAM_OVERLAY__kitchen_v2_1_building__approved_with_minor_simplification.png)

Reason:  
- значительно лучше прошлого kitchen-pass;  
- ниже, спокойнее, больше overlay module, меньше “домик ради красоты”;  
- иконка кастрюли работает;  
- собака и овощной ящик поддерживают функцию.

Optional polish:  
- ещё на 10% упростить внутренние мелкие элементы;  
- чуть сильнее показать, что это функциональная кухня, а не уютный жилой дом.

### 3.4 Water Station v2 — Utility Prop

Status: **approved as direction**.

Repo file: [STEAM_OVERLAY__water_station_v2_utility_prop__approved_direction.png](approved_art_files/STEAM_OVERLAY__water_station_v2_utility_prop__approved_direction.png)

Reason:  
- отличный Utility Prop;  
- бак + труба + корыто читаются сразу;  
- не превратился в домик;  
- лабрадор с лейкой усиливает назначение.

### 3.5 Decor Workshop v2 — Utility Workbench

Status: **approved as direction**.

Repo file: [STEAM_OVERLAY__decor_workshop_v2_utility_workbench__approved_direction.png](approved_art_files/STEAM_OVERLAY__decor_workshop_v2_utility_workbench__approved_direction.png)

Reason:  
- работает как открытый workbench под навесом;  
- не стал комнатой/домиком;  
- табличка-кисточка считывает функцию;  
- хаски с доской поддерживает dog action.

### 3.6 Dog Action Sprite — Dachshund Cart

Status: **approved as direction**.

Repo file: [STEAM_OVERLAY__dog_action_dachshund_cart_grain_bag__approved_direction.png](approved_art_files/STEAM_OVERLAY__dog_action_dachshund_cart_grain_bag__approved_direction.png)

Reason:  
- сильный читаемый dog action sprite;  
- такса узнаётся;  
- тележка и мешок крупные;  
- действие понятно без контекста.

### 3.7 Dog Action Sprite — Labrador Watering

Status: **approved as direction**.

Repo file: [STEAM_OVERLAY__dog_action_labrador_watering_can__approved_direction.png](approved_art_files/STEAM_OVERLAY__dog_action_labrador_watering_can__approved_direction.png)

Reason:  
- простое и чистое действие;  
- лейка крупная;  
- собака читается;  
- подходит для greenhouse / garden / water station contexts.

### 3.8 Dog Action Sprite — Husky Painting

Status: **approved as direction**.

Repo file: [STEAM_OVERLAY__dog_action_husky_painting_board__approved_direction.png](approved_art_files/STEAM_OVERLAY__dog_action_husky_painting_board__approved_direction.png)

Reason:  
- читается как painting / decorating action;  
- доска и кисть достаточно крупные;  
- хаски узнаётся;  
- хорошо поддерживает Decor Workshop.

### 3.9 D-011 Reconciled Full Scene v1 — Composition Direction Board

Status: **approved source direction / not an editable master / not runtime art**.

Repo file: [STEAM_DESKTOP__full_scene_d011_reconciled_v1__approved_direction.png](approved_art_files/STEAM_DESKTOP__full_scene_d011_reconciled_v1__approved_direction.png)

Reason:

- фиксирует принятый authored corridor 2992×224 с прозрачным upper reserve;
- сохраняет D-011 meadow, barely-visible lower tree depth, semantic order,
  shared baseline и current anchors;
- показывает Mill только как static decorative Utility Prop;
- является byte-identical direction export из frozen layered source package.

Layered master authority остаётся в
`STEAM_DESKTOP__Art_Source_Reconciliation_Wave_v1/source/world/world_master.ora`.

### 3.10 dog.labrador_intro A–H — Identity / Action Direction Board

Status: **approved source direction / not an editable master / not runtime art**.

Repo file: [STEAM_OVERLAY__dog_labrador_intro_A_H__approved_direction_board.png](approved_art_files/STEAM_OVERLAY__dog_labrador_intro_A_H__approved_direction_board.png)

Reason:

- фиксирует одну принятую Labrador identity на 24 pose families A–H;
- показывает authored right/left, оба physical-turn направления,
  start/walk/stop, approach/contact, Kitchen/Packing work/focus и ambient H;
- сохраняет принятую `AS_IS` bounded-trial оговорку о slightly shaggy / Golden-like
  coat read без разрешения дальнейшего identity drift;
- является byte-identical direction board из frozen layered source package.

Editable pose masters остаются в
`STEAM_DESKTOP__Art_Source_Reconciliation_Wave_v1/source/labrador/poses/` и
проверяются через package `SOURCE_MANIFEST.json` + `HASHES.sha256`.

### 3.11 dog.labrador_intro Locomotion Source Sheet v1 — Flattened Generated Original

Status: **user-owner approved visual-direction source sheet / flattened generated original / opaque RGB / not runtime art**.

Repo file: [STEAM_OVERLAY__dog_labrador_intro_locomotion_source_sheet_v1__approved_direction.png](approved_art_files/STEAM_OVERLAY__dog_labrador_intro_locomotion_source_sheet_v1__approved_direction.png)

Reason:

- это точное изображение `exec-21d7f7a5-7076-4417-a5ee-749ab64f4f2a`,
  показанное пользователю в production-сеансе;
- фиксирует одобренные пользователем Labrador identity, calm character,
  locomotion poses и physical-turn visual direction;
- сохранено побайтно из frozen package без resize, crop, recompression или
  alpha edit.

Файл является непрозрачным RGB source sheet на белом presentation field. Это
не editable master, не actor background, не runtime asset и не alpha/import
contract. Layered pose authority остаётся в frozen package
`STEAM_DESKTOP__Art_Source_Reconciliation_Wave_v1/source/labrador/poses/`.

### 3.12 dog.labrador_intro Work Source Sheet v1 — Flattened Generated Original

Status: **user-owner approved visual-direction source sheet / flattened generated original / opaque RGB / not runtime art**.

Repo file: [STEAM_OVERLAY__dog_labrador_intro_work_source_sheet_v1__approved_direction.png](approved_art_files/STEAM_OVERLAY__dog_labrador_intro_work_source_sheet_v1__approved_direction.png)

Reason:

- это точное изображение `exec-54226c52-bf9a-4efc-881f-d4e6c1b6e8f6`,
  показанное пользователю в production-сеансе;
- фиксирует одобренные пользователем approach/contact, Kitchen/Packing work,
  focus и ambient visual direction той же Labrador identity;
- сохранено побайтно из frozen package без pixel mutation.

Белый фон является presentation field flattened RGB original и не задаёт
runtime alpha. Editable semantic derivatives и contact/pivot authority остаются
в hash-locked frozen source package.

### 3.13 World Anchor Asset Source Sheet v1 — Flattened Generated Original

Status: **user-owner approved visual-direction source sheet / flattened generated original / opaque RGB / not runtime art**.

Repo file: [STEAM_DESKTOP__world_anchor_asset_source_sheet_v1__approved_direction.png](approved_art_files/STEAM_DESKTOP__world_anchor_asset_source_sheet_v1__approved_direction.png)

Reason:

- это точное изображение `exec-ba777e69-f8e5-46e2-95f0-8dcda1882d15`,
  показанное пользователю;
- фиксирует понравившуюся пользователю visual direction текущих world anchors,
  static Mill, Packing Utility Prop, Van, fence family и quiet depth;
- является byte-identical flattened generated original из frozen package.

Sheet не добавляет показанным объектам mechanics, interaction, tasks или новую
taxonomy authority. Его белое RGB-поле не является runtime alpha/import
контрактом; editable world masters остаются в frozen package.

### 3.14 Meadow Source Plate v1 — Flattened Generated Original

Status: **user-owner approved visual-direction source sheet / flattened generated original / opaque RGB / not runtime art**.

Repo file: [STEAM_DESKTOP__meadow_source_plate_v1__approved_direction.png](approved_art_files/STEAM_DESKTOP__meadow_source_plate_v1__approved_direction.png)

Reason:

- это точное изображение `exec-7dbbf80e-e24b-4bc1-82b4-763e568f8ddb`,
  показанное пользователю;
- пользователь одобрил organic meadow, faint lower depth и общий illustrated
  material direction;
- изображение сохранено побайтно без re-encode или pixel edit.

Visual approval plate не разрешает растягивать его по ширине и не доказывает
готовый seamless tile. Явное user-owner правило требует отдельного seam-safe
horizontal tiling contract; paused responsive amendment остаётся отдельной
source-задачей. Белое opaque RGB-поле не является sky/background/alpha contract.

## 4. Library v1 summary

Approved as direction:

- Mill v2 — Utility Prop.  
- Water Station v2 — Utility Prop.  
- Decor Workshop v2 — Utility Workbench.  
- Dachshund Cart — Dog Action Sprite.  
- Labrador Watering — Dog Action Sprite.  
- Husky Painting — Dog Action Sprite.

Approved with minor optional simplification:

- Storage v2 — Building.  
- Kitchen v2.1 — Building.

Approved source-direction boards:

- D-011 Reconciled Full Scene v1 — Composition Direction Board.
- dog.labrador_intro A–H — Identity / Action Direction Board.

User-owner approved flattened generated visual-direction source sheets:

- dog.labrador_intro Locomotion Source Sheet v1.
- dog.labrador_intro Work Source Sheet v1.
- World Anchor Asset Source Sheet v1.
- Meadow Source Plate v1.

Promotion provenance and exact source-to-target hashes:

- `STEAM_DESKTOP__Art_Source_Reconciliation_Wave_v1__Approved_Promotion_Record.md`;
- `STEAM_DESKTOP__Art_Source_Reconciliation_Wave_v1__Approved_Generated_Originals_Promotion_Record_v1.md`.

## 5. What this proves

Asset taxonomy работает.

До taxonomy проблема была: “любая функция превращается в домик”. После taxonomy система начала разделять:

- building anchors;  
- utility props;  
- dog action sprites.

Это значит, что можно двигаться от случайного concept art к управляемой библиотеке ассетов.

## 6. Next recommended assets

Следующий пакет после readability pass:

1. Greenhouse v2 — Building или low-profile module.  
2. Packing Station v2 — Building / workbench hybrid.  
3. Signpost / Notice Board — Utility Prop.  
4. Dog Action Sprite: corgi carrying food bag.  
5. Dog Action Sprite: mixed-breed pushing crate.

## 7. Next required check

Все asset directions из Approved Library v1 должны пройти readability pass:

- 216 px — comfort;  
- 144 px — working minimum;  
- 96 px — stress test.

Результат фиксируется в `STEAM_OVERLAY__Readability_Pass_216_144_96_v1`.

Для promoted source-direction boards source-level 216/144/96 evidence уже
retained в frozen Art package; это не заменяет будущий native runtime capture,
independent Art review или explicit user runtime acceptance.
