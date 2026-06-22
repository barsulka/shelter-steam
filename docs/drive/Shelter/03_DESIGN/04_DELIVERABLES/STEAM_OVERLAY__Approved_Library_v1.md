# STEAM_OVERLAY — Approved Library v1

Дата: 2026-06-25  
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

Все ассеты из Approved Library v1 должны пройти readability pass:

- 216 px — comfort;  
- 144 px — working minimum;  
- 96 px — stress test.

Результат фиксируется в `STEAM_OVERLAY__Readability_Pass_216_144_96_v1`.
