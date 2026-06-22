# STEAM_DESKTOP — Prototype Data and Task Backlog v0

Дата: 2026-06-28  
Роль документа: Game Design → Dev-facing Prototype Spec  
Статус: working draft v0  
Продукт: Steam/Desktop idle always-on-top strip  
Основано на: `STEAM_DESKTOP__MVP_Gameplay_Slice_v0`, `STEAM_DESKTOP__MVP_State_Machine_and_UX_Flow_v0`, `STEAM_DESKTOP__First_Day_MVP_v0`  
Связанные решения: D-009, D-010, D-012, D-013

## 1. Зачем нужен этот документ

Этот документ переводит геймдизайн Steam/Desktop MVP в список данных, сущностей, задач и критериев приёмки, пригодный для следующего Godot prototype spike.

Цель не в том, чтобы описать финальную архитектуру. Цель — дать Codex/разработке достаточно конкретный контракт, чтобы собрать первый игровой вертикальный прототип поверх существующей companion strip tech demo.

## 2. Prototype goal

Собрать прототип, где игрок может пройти цепочку:

1. открыть первый заказ;
2. отправить собаку на маршрут;
3. увидеть отъезд и возвращение транспорта;
4. увидеть физическую выгрузку ресурсов;
5. увидеть перенос ресурсов на кухню;
6. увидеть производство смеси;
7. увидеть фасовку мешка;
8. загрузить фургон;
9. отправить поставку;
10. получить открытку и экипируемую награду;
11. открыть второй маршрут и следующий заказ.

Для первого dev-spike достаточно first-order loop. First Day MVP можно реализовывать вторым слоем после доказательства первого loop.

## 3. Strict out of scope

Не делать в этом прототипе:

- монетизацию;
- Steamworks;
- Browser Extension sync;
- реальные charity claims;
- реальные приюты;
- paid gacha / reroll;
- видимое crop farming в Steam;
- боевые/соревновательные системы;
- полноценные комнаты;
- сложный AI планировщик;
- финальный баланс времени/ресурсов;
- финальный арт.

## 4. Data keys

### 4.1 Routes

```text
route.oat_farm_intro
route.linen_fields_intro
route.flower_farm_intro
```

MVP dev-spike 1 requires only:

```text
route.oat_farm_intro
```

Route fields:

```text
id
name_ru
description_ru
required_transport_class
recommended_trait_tags
reward_payload
pleasant_find_payload_optional
duration_tier
unlock_state
```

Initial data:

```text
route.oat_farm_intro
name_ru: Овсяная ферма
description_ru: Фермерские друзья подготовили немного овса и тыквы для первой партии.
required_transport_class: small_bicycle
recommended_trait_tags: fast_short_trip
reward_payload: resource.oat_crate x1, resource.pumpkin_crate_small x1
pleasant_find_payload_optional: resource.field_flower x1
duration_tier: tutorial_short
unlock_state: unlocked_at_start
```

```text
route.linen_fields_intro
name_ru: Льняные поля
description_ru: На полях можно забрать мягкую ткань и рулон льна для уютных наборов.
required_transport_class: small_bicycle_or_trailer
recommended_trait_tags: careful_carry, small_craft
reward_payload: resource.linen_roll x1, resource.soft_cloth x1
pleasant_find_payload_optional: resource.colored_thread x1
unlock_state: after_first_delivery
```

```text
route.flower_farm_intro
name_ru: Цветочная ферма
description_ru: Тихое место, откуда собаки привозят травы, цветы и маленькие украшения для уголков.
required_transport_class: any_small_transport
recommended_trait_tags: friendly, cozy_decor
reward_payload: resource.field_flower x1, resource.calm_herbs x1
pleasant_find_payload_optional: resource.ribbon x1
unlock_state: first_day_optional
```

### 4.2 Transports

```text
transport.basket_bicycle
transport.bicycle_small_trailer
```

Transport fields:

```text
id
name_ru
transport_class
capacity_slots
visual_state
compatible_route_tags
unlock_state
```

Initial data:

```text
transport.basket_bicycle
name_ru: Велосипед с корзинкой
transport_class: small_bicycle
capacity_slots: 2
unlock_state: unlocked_at_start
```

```text
transport.bicycle_small_trailer
name_ru: Велосипед с маленьким прицепом
transport_class: small_bicycle_or_trailer
capacity_slots: 4
unlock_state: after_second_order_or_upgrade
```

### 4.3 Dogs

```text
dog.dachshund_intro
dog.labrador_intro
dog.small_helper_intro
```

Dog fields:

```text
id
name_ru_placeholder
breed_or_type_ru
innate_traits
equipment_slots
preferred_task_tags
current_task
home_corner_ref_optional
unlock_state
```

Initial data:

```text
dog.dachshund_intro
breed_or_type_ru: такса
innate_traits: trait.fast_paws
preferred_task_tags: short_trip, bicycle_driver
unlock_state: unlocked_at_start
```

```text
dog.labrador_intro
breed_or_type_ru: лабрадор
innate_traits: trait.careful_helper
preferred_task_tags: unload, carry_crate, kitchen_help
unlock_state: unlocked_at_start
```

```text
dog.small_helper_intro
breed_or_type_ru: корги / небольшая смешанная собака
innate_traits: trait.small_craft_master
preferred_task_tags: packing, labeling, toy, room_lite
unlock_state: after_second_delivery
```

### 4.4 Traits and equipment

Innate traits:

```text
trait.fast_paws
trait.careful_helper
trait.small_craft_master
```

Equipment:

```text
equipment.comfortable_slippers
```

Trait fields:

```text
id
name_ru
type: innate | equipment | learned | room_effect
flavor_ru
behavior_tags
can_remove
```

Rules:

- innate traits use `can_remove: false`;
- equipment uses `can_remove: true`;
- equipment may enhance a dog's role, but must not replace innate identity.

Initial data:

```text
trait.fast_paws
name_ru: Быстрые лапки
type: innate
behavior_tags: fast_short_trip, bicycle_driver
can_remove: false
```

```text
trait.careful_helper
name_ru: Аккуратный помощник
type: innate
behavior_tags: careful_carry, unload, packing_support
can_remove: false
```

```text
trait.small_craft_master
name_ru: Мастер мелочей
type: innate
behavior_tags: labeling, packing, toy, room_lite
can_remove: false
```

```text
equipment.comfortable_slippers
name_ru: Удобные тапочки
type: equipment
behavior_tags: short_trip_comfort, happy_bounce
can_remove: true
```

### 4.5 Resources

Dev-spike 1 resources:

```text
resource.oat_crate
resource.pumpkin_crate_small
resource.protein_packet
resource.packaging_bag
resource.basic_food_mix
resource.basic_food_bag
```

First Day extension resources:

```text
resource.linen_roll
resource.soft_cloth
resource.field_flower
resource.colored_thread
resource.calm_herbs
resource.ribbon
resource.cozy_care_pack
resource.expanded_help_pack
```

Resource fields:

```text
id
name_ru
category
physical_form
can_be_carried
storage_visual_token
```

Categories:

```text
raw_food
raw_material
packaging
intermediate
final_delivery_item
pleasant_find
room_lite_decor
```

Important rule:

A resource should become available in Storage only after a visible unload/carry completion event, not instantly when the trip timer ends.

### 4.6 Orders

```text
order.first_warm_delivery
order.cozy_care_pack
order.expanded_help_pack
```

Order fields:

```text
id
name_ru
description_ru
required_resources
required_final_outputs
reward_payload
state
next_suggested_action
unlock_state
```

Initial order:

```text
order.first_warm_delivery
name_ru: Первая тёплая поставка
description_ru: Наши друзья из приюта будут рады небольшой партии базового корма. Давайте соберём первую тёплую поставку.
required_resources: oat_crate x1, pumpkin_crate_small x1, protein_packet x1, packaging_bag x1
required_final_outputs: basic_food_bag x1
reward_payload: postcard.first_delivery, equipment.comfortable_slippers
unlock_state: unlocked_at_start
```

First Day extension:

```text
order.cozy_care_pack
name_ru: Уютный набор
required_resources: soft_cloth x1, packaging_bag x1, optional field_flower x1
required_final_outputs: cozy_care_pack x1
reward_payload: postcard.cozy_pack, room_item.small_mat_or_flower_jar
unlock_state: after_first_delivery
```

```text
order.expanded_help_pack
name_ru: Расширенная помощь
required_resources: basic_food_bag x1, soft_cloth x1, calm_herbs or field_flower x1
required_final_outputs: expanded_help_pack x1
reward_payload: postcard.expanded_help, transport_upgrade_hint_or_token
unlock_state: after_second_delivery
```

## 5. World objects

Prototype object keys:

```text
object.road_sign
object.storage
object.kitchen
object.packing_table
object.delivery_van_endpoint
object.dog_corner_intro
```

### 5.1 Road Sign

Responsibilities:

- route list;
- trip start;
- trip timer display;
- transport departure/return anchor;
- unload trigger after return.

Required states:

```text
idle
route_available
trip_preparing
trip_active
trip_returning
unload_available
```

### 5.2 Storage

Responsibilities:

- starting supplies;
- incoming unload queue;
- visible resource tokens;
- outgoing carry tasks.

Required states:

```text
has_starting_supplies
receiving_resources
ready_for_production
waiting_for_output_tasks
```

Initial inventory:

```text
resource.protein_packet x1
resource.packaging_bag x1
```

### 5.3 Kitchen

Responsibilities:

- receive food inputs;
- run CookTask;
- output basic food mix.

Required states:

```text
idle
waiting_for_inputs
inputs_ready
cooking
output_ready
output_taken
```

### 5.4 Packing Table

Responsibilities:

- receive mix and packaging;
- run PackTask;
- output basic food bag;
- later: label/cozy pack tasks.

Required states:

```text
idle
waiting_for_mix
waiting_for_packaging
inputs_ready
packing
output_ready
output_taken
```

### 5.5 Delivery Van Endpoint

Responsibilities:

- receive finished delivery item;
- allow player-confirmed delivery;
- create postcard.

Required states:

```text
idle
waiting_for_food_bag
loading
ready_to_send
leaving
delivered
postcard_ready
```

### 5.6 Dog Corner / Room-lite

First Day extension only.

Responsibilities:

- display first small room-lite reward;
- let dog perform a cozy idle animation;
- introduce future room system without real min-max.

Required states:

```text
locked
available
placing_item
item_placed
dog_visiting
```

## 6. Task types

Dev-spike 1 required:

```text
task.trip
task.unload
task.carry
task.cook
task.pack
task.load_van
task.delivery
task.idle
```

First Day extension:

```text
task.equip_item
task.transport_upgrade
task.place_room_item
task.label_or_tie_pack
```

Common task fields:

```text
id
type
assigned_dog_id
source_object_id
target_object_id
carried_resource_id_optional
animation_tag
status
priority
created_by
```

Task statuses:

```text
queued
assigned
dog_moving_to_source
in_progress
dog_moving_to_target
completing
complete
blocked
```

Priority rules:

1. Finish current carry/unload if item is already in paws.
2. Complete unload tasks from returned transport.
3. Complete carry tasks required by active order.
4. Complete production tasks.
5. Complete packing/loading tasks.
6. Idle/rest tasks.

## 7. Prototype event chain — first order

```text
order_created(order.first_warm_delivery)
player_click_road_sign
player_confirm_trip(route.oat_farm_intro, transport.basket_bicycle, dog.dachshund_intro)
trip_task_created
transport_left_strip
trip_timer_complete
transport_returned(payload: oat_crate, pumpkin_crate_small)
unload_task_created(oat_crate)
unload_task_created(pumpkin_crate_small)
resource_added_to_storage(oat_crate)
resource_added_to_storage(pumpkin_crate_small)
order_requirements_met_for_inputs
carry_task_created(oat_crate -> kitchen)
carry_task_created(pumpkin_crate_small -> kitchen)
carry_task_created(protein_packet -> kitchen)
kitchen_inputs_ready
cook_task_created
cook_task_complete(output: basic_food_mix)
carry_task_created(basic_food_mix -> packing_table)
carry_task_created(packaging_bag -> packing_table)
packing_inputs_ready
pack_task_created
pack_task_complete(output: basic_food_bag)
load_van_task_created
van_loaded
player_confirm_delivery
delivery_complete
postcard_created(postcard.first_delivery)
reward_created(equipment.comfortable_slippers)
player_equip_item(dog.dachshund_intro, equipment.comfortable_slippers)
route_unlocked(route.linen_fields_intro)
order_unlocked(order.cozy_care_pack)
```

## 8. UI cards required

Dev-spike 1:

1. `Order Card`
2. `Route Card`
3. `Dog Card`
4. `Storage Card`
5. `Kitchen Card`
6. `Packing Card`
7. `Van Card`
8. `Postcard Card`
9. `Hide / Show UI Button`

First Day extension:

10. `Route List Card`
11. `Upgrade Card`
12. `New Dog Intro Card`
13. `Dog Corner Card`

UI principles:

- compact cards;
- no fullscreen menu during normal play;
- no hard red warnings;
- no guilt language;
- no dense percentage/drop tables in tutorial;
- no paid action affordances.

## 9. Placeholder animation tags

Required animation tags for prototyping:

```text
dog_idle
dog_walk
dog_carry_crate
dog_carry_bag
dog_prepare_transport
dog_drive_or_leave_with_bicycle
dog_return_with_bicycle
dog_unload_crate
dog_cook
dog_pack
dog_load_van
dog_celebrate_small
dog_rest
```

First Day extension:

```text
dog_carry_cloth
dog_label_package
dog_place_room_item
dog_visit_corner
dog_happy_bounce_slippers
```

Prototype can use placeholder sprites/poses, but actions must be distinguishable by position, carried item, object state, or small icon.

## 10. Acceptance criteria — dev-spike 1

The first implementation spike passes if:

1. The companion strip scene can start first order state.
2. Road Sign opens a route card.
3. Player can start `Овсяная ферма` with the dachshund and basket bicycle.
4. Dog visibly moves to transport.
5. Transport visibly leaves the strip.
6. Trip timer/travel state is visible without pressure language.
7. Transport returns with visible cargo.
8. Oat and pumpkin are not added to Storage until unload tasks complete.
9. Dogs physically carry at least one resource from transport to Storage.
10. Dogs carry resources from Storage to Kitchen.
11. Kitchen creates basic food mix.
12. Basic food mix moves to Packing Table.
13. Packing Table creates basic food bag.
14. Dog loads the bag into Van.
15. Player confirms delivery.
16. Postcard appears.
17. Comfortable slippers reward can be assigned to dachshund.
18. Innate trait and equipment are shown as separate layers in Dog Card.
19. UI can be hidden and shown while world state continues.
20. Headless smoke check still passes.

## 11. Acceptance criteria — first day extension

The first-day extension passes if:

1. After first delivery, `Льняные поля` unlocks.
2. Route list shows at least two routes.
3. Second route returns cloth/linen-shaped cargo, not just a renamed crate.
4. Third dog appears with a visible role.
5. Second order uses a non-food resource.
6. First bottleneck is shown softly.
7. Bicycle small trailer upgrade becomes available.
8. Trailer visibly increases return payload.
9. Third order mixes food and cozy item.
10. Room-lite item can be placed.
11. A dog can visit the room-lite corner.

## 12. Recommended implementation order

### Step A — replace generic demo objects with MVP semantic objects

Use current companion field demo as base. Keep window/zoom/click-through functionality. Replace or add semantic placeholder objects:

- Road Sign;
- Storage;
- Kitchen;
- Packing Table;
- Delivery Van Endpoint.

### Step B — add data-driven first order

Add temporary JSON/resource data for:

- first order;
- oat route;
- basket bicycle;
- two dogs;
- resources;
- simple object states.

### Step C — implement first route and return payload

Trip can be timer-based and simple. The important part is visible departure/return and payload creation.

### Step D — implement physical unload and carry

This is the heart of the prototype. Prioritize this before adding more UI.

### Step E — implement production chain

Kitchen → Packing → Van.

### Step F — implement postcard + slippers

Show D-010 clearly: innate trait remains; equipment is added separately.

### Step G — unlock second route only after first loop works

Do not expand to First Day MVP before Step A–F feel alive.

## 13. Design risks to watch during implementation

1. **Teleporting resources** — if resources appear as numbers only, the core fantasy fails.
2. **Too much UI** — if cards dominate the strip, the world stops feeling alive.
3. **Too much clicking** — player should not approve every micro-task.
4. **Factory without soul** — dogs need idle pauses, tiny reactions, and visible individuality.
5. **Unclear objects at strip height** — if Kitchen/Packing/Storage are unreadable at 144 px, simplify silhouettes.
6. **Browser leakage** — do not add search bar, ad block, extension UX, or sponsorship mechanics to Steam.
7. **Guilt language** — all delivery text must stay calm and non-coercive.

## 14. Next handoff target

After this document is accepted or revised, Codex can start a prototype task:

> Build Steam/Desktop MVP first-order loop in the existing Godot companion strip: semantic objects, route card, dog trip, visible return payload, physical unload into storage, carry to kitchen, cook, pack, load van, send delivery, show postcard, assign comfortable slippers.

Expected changed areas for Codex:

- `steam/resources/tech_demos/` or new `steam/resources/prototypes/` data;
- `steam/scenes/tech_demos/` or new `steam/scenes/prototypes/` scene;
- `steam/scripts/tech_demos/` or new `steam/scripts/prototypes/` scripts;
- `docs/repo/dev/companion-field-tech-demo.md` or a new prototype dev note;
- `docs/repo/status/CODEX_STATUS.md`.
