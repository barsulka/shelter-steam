# Design handoff — Steam Overlay v1 + Prompt System

Дата: 2026-06-25  
Роль сессии: Art Director / Visual Designer  
Продукт: Steam/Desktop

## Что делали

1. Пользователь уточнил реальный смысл референса Crusaders Quest Hero Town overlay: главный режим — это нижняя живая кромка, которая не мешает рабочему столу, а не подробная cutaway-сцена.  
2. Были пересмотрены видео и скриншоты CQ overlay.  
3. Первый Cozy Modular Diorama pass был разделён на правильные режимы:  
   - main overlay strip;  
   - inspect/detail views;  
   - windowed/scenic mode.  
4. Сгенерирован и принят reference `D-011_steam_overlay_main_strip_v1_reference.png`.  
5. Создана reusable prompt system для новых overlay assets.

## Ключевой вывод

Стиль Cozy Modular Diorama сохраняется, но для главного Steam overlay вводится отдельный simplified functional silhouette layer.

Главный overlay не должен быть интерьером. Он должен быть нижней живой кромкой:

- пустота сверху;  
- жизнь внизу;  
- низкие функциональные модули;  
- крупные собаки и действия;  
- минимум UI;  
- inspect-детали только по клику.

## Принято

### Steam Overlay Main Strip v1

Статус: approved composition direction, not final production asset.

Пользователь и Art Director согласились: текущий reference нравится и попадает в суть главного overlay. Он ещё требует production simplification, но направление утверждено как база.

## Созданные документы

1. `03_DESIGN/04_DELIVERABLES/approved_art_files/D-011_steam_overlay_main_strip_v1_reference.png`  
2. `03_DESIGN/00_VISUAL_DIRECTION/D-011_Steam_Overlay_Main_Strip_v1_Rules`  
3. `03_DESIGN/03_PROMPTS/STEAM_OVERLAY__Asset_Prompt_System_v0`  
4. `03_DESIGN/03_PROMPTS/STEAM_OVERLAY__Asset_Brief_Template_v0`  
5. `06_SESSIONS_AND_HANDOFFS/design/2026-06-25__design_handoff__steam_overlay_v1_prompt_system`

## Следующий лучший шаг

После Asset Pack 1 v1 prompt system получила важную корректировку. Следующий лучший шаг — сделать Asset Pack 1 v2, но уже с обязательной asset taxonomy:

1. Mill v2 — Utility Prop: thin vertical prop / pause, not a house.  
2. Water Station v2 — Utility Prop: tank + pump + bucket, not a house.  
3. Decor Workshop v2 — Utility Prop / open workbench: awning + bench + one tool,

## Addendum — Asset Pack 1 v1 verdict

Asset Pack 1 v1 был полезен как exploration, но не утверждён как production pack.

Принято: общий тон, палитра, материалы, dog action direction, icon plaque language.

Не принято: текущие версии мельницы, водяной станции и мастерской декора как main overlay production assets. Причина: модель превращает Utility Props в домики.

Новое обязательное правило:

> Before generation, classify asset as Building / Utility Prop / Dog Action Sprite. Utility Props must not become houses.  
 not a room.  
4. Dog Action Sprites — отдельные собаки: такса тянет мешок зерна, лабрадор несёт лейку, хаски красит доску.

Для каждого ассета:

- сначала классифицировать ассет как Building / Utility Prop / Dog Action Sprite;  
- Utility Props не должны становиться домиками;  
- проверить читаемость на 96 / 144 / 216 px;  
- убедиться, что собака и действие читаются раньше декора;  
- reject, если функция снова превратилась в красивый домик.

## Addendum — Approved Library v1 and Readability Pass

После Asset Pack 1 v2 создана `STEAM_OVERLAY__Approved_Library_v1`.

В Library v1 вошли:  
- Mill v2 — Utility Prop — approved as direction.  
- Storage v2 — Building — approved as direction / minor simplification later.  
- Kitchen v2.1 — Building — approved with minor optional simplification.  
- Water Station v2 — Utility Prop — approved as direction.  
- Decor Workshop v2 — Utility Workbench — approved as direction.  
- Dachshund Cart — Dog Action Sprite — approved as direction.  
- Labrador Watering — Dog Action Sprite — approved as direction.  
- Husky Painting — Dog Action Sprite — approved as direction.

Создан `STEAM_OVERLAY__Readability_Pass_216_144_96_v1`.

Readability result:  
- 216 px: PASS for all.  
- 144 px: PASS for all.  
- 96 px: PASS / PARTIAL PASS; hard failures нет.

Следующий лучший шаг:  
1. Greenhouse v2.  
2. Packing Station v2.  
3. Signpost / Notice Board Utility Prop.  
4. Corgi carrying food bag.  
5. Mixed-breed pushing crate.

## Addendum — Rejected board kept as template

Картинка Asset Pack 1 v1 не принята как production pack и не должна использоваться как approved asset reference.

Но её структура полезна: header, reference strip, asset cards, principles, palette, materials, key rules, scale check.

Создан архивный файл:  
`03_DESIGN/04_DELIVERABLES/archived_art_explorations/STEAM_OVERLAY__asset_pack_1_v1_rejected_but_useful_board_structure.png`

Создан template-документ:  
`03_DESIGN/03_PROMPTS/STEAM_OVERLAY__System_Board_Template_v0`

Правило: старую картинку использовать только как layout/structure reference, не как content reference. Новый board должен использовать Approved Library v1 и актуальную taxonomy Building / Utility Prop / Dog Action Sprite.
