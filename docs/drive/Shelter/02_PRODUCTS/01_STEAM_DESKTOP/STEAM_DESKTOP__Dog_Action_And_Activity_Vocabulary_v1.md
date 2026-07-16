# STEAM_DESKTOP — Dog Action And Activity Vocabulary v1

Дата: 2026-07-11
Роль документа: Game Design / Dog Action & Activity Vocabulary
Статус: **proposed v1 / Game Design vocabulary, not accepted production asset list**
Продукт: Steam/Desktop idle always-on-top strip
Владелец смысла: Game Designer / Systems Designer
Получатели: Producer, Art Director, Technical Animation, Codex

---

## 0. Назначение и граница документа

Этот документ вводит единый game-first словарь действий и активностей собак Shelter.

Он нужен, чтобы разные роли одинаково понимали:

- что игрок должен увидеть;
- какую игровую задачу или фрагмент жизни выражает движение;
- какая собака имеет право выполнять действие;
- какой объект, station, socket или room anchor обязателен;
- что можно собрать из общего base clip и layers;
- где нужен family/role/object-specific variant;
- какое evidence доказывает действие.

Главная формула:

```text
Activity meaning
-> role / task / world state
-> semantic action phrase
-> reusable base clip + effort + intent + object/room interaction + additive layers
-> player-visible evidence
```

Это **не** hatch-pet-style одинаковый frame-atlas для каждой собаки. Одна собака не обязана иметь все действия. Новая собака получает shared core и только те capability/role/room variants, для которых есть eligibility и authority.

Этот документ:

- не принимает art style, palette, rig, animation tool или asset pipeline;
- не утверждает production asset count;
- не добавляет rooms, needs, hunger, energy, research, friendship или другие mechanics;
- не превращает proposed/future activities в current implementation scope;
- не заменяет Task Flow, Object Contract, Dog Life Model, Building System или animation grammar;
- не является Codex implementation brief или runtime schema request.

Semantic IDs ниже являются canonical cross-role names **внутри proposed v1**. Статус каждой строки определяет, можно ли считать её current gameplay authority. Само наличие ID не делает действие accepted или implementation-ready.

---

## 1. Источники, authority и provenance

| Код | Источник | Текущий статус источника | Что он авторизует здесь |
| --- | --- | --- | --- |
| `TF` | `STEAM_DESKTOP__Task_Flow_Contract_v1.md` | active v1 / accepted D-022 addendum | Current task causality, dog assignment, order-bound physical actions, idle restrictions. |
| `DL` | `STEAM_DESKTOP__Dog_Life_Model_v1.md` | draft v1 | Existing proposal for player-facing life meanings and later activity/task mappings. |
| `BS` | `STEAM_DESKTOP__Building_System_v1.md` | draft v1 | Existing proposal for anchor + room window, stations and room activities. |
| `DVL` | `DOG_VISUAL_LANGUAGE_v1.md` | working draft | Existing proposal for shared clip families, sockets, family eligibility and readability. |
| `RAG` | `DOG_RUNTIME_AND_ANIMATION_GRAMMAR_v1.md` | working draft / proposal | Existing proposal for layered grammar, intents, effort and personality motion. |
| `SPIKE` | `docs/repo/dev/dog-rig-spike.md` | qualified technical prototype evidence | What the current debug spike actually demonstrated; not production or art acceptance. |
| `SAP-D` | Semantic Asset Pack `cards/dachshund.md` | `NEEDED`; no approved dog asset | Current semantic need for Dachshund, not visual evidence. |
| `SAP-L` | Semantic Asset Pack `cards/labrador.md` | `NEEDED`; no approved dog asset | Current semantic need for Labrador, not visual evidence. |
| `D-022` | `02_DECISIONS.md` D-022 | accepted | Current Day 2 Labrador PackTask cue and same-chain completion boundary. |
| `USER` | Current delegated user request | user-requested candidate | Requested coverage that still needs product/art/technical acceptance where no source already authorizes it. |

### 1.1 Status values

| Status | Meaning |
| --- | --- |
| `accepted current` | Player/game meaning is required by an accepted current contract. It still may lack approved art or technical binding. |
| `existing proposal` | Already appears in a draft/working source, but is not accepted implementation or production scope. |
| `user-requested candidate` | Added to this proposed vocabulary by the current request; requires role acceptance before implementation. |
| `future-only` | Source explicitly places it later, or it depends on a future system/room/role not currently accepted. |

### 1.2 Priority values

Priority is a coverage order, not product approval.

| Priority | Meaning |
| --- | --- |
| `P0` | Required to express the current shared foundation or current First Day / Day 2 delivery proof. |
| `P1` | Next useful dog-life / room vocabulary candidate after explicit scope acceptance. |
| `P2` | Future expansion, specialist role or optional personality coverage. |

An `existing proposal / P1` row does not become accepted because it has P1. A `P0` row with no approved clip still fails its visual/technical evidence gate.

---

## 2. Термины: что не следует смешивать

| Term | Definition | Example | Not the same as |
| --- | --- | --- | --- |
| `action` | Минимальное player-visible движение или контактная фраза собаки. | approach target, pickup, carry, sit. | Activity, technical task or clip filename. |
| `activity` | Player-facing meaning: что собака делает и зачем в жизни кооператива. | помочь разгрузить велосипед. | Один animation clip. |
| `task` | Runtime work unit с owner, status, source, target and completion event. | UnloadTask, PackTask. | Вся жизнь собаки или эмоциональная реакция. |
| `role` | Разрешённая ответственность собаки в текущем контексте. | driver, helper, learner. | Skeleton family или personality preset. |
| `state` | Наблюдаемое состояние dog/object/task/world. | moving_to_source, carrying_item, resting. | Причина действия или готовый clip. |
| `clip` | Переиспользуемый animation/base-pose asset или runtime motion primitive. | walk_empty, pickup_pose. | Gameplay authority: clip сам не создаёт mechanic. |
| `layer` | Additive/modifier поверх base: effort, look, tail, ear, personality, object swing. | heavy_carry effort + focused tail. | Отдельная activity или обязательный unique clip. |
| `interaction` | Контракт dog execution с world object/prop/room anchor. | approach seat -> align -> sit. | Геометрия/арт самого chair, bowl или station. |

### 2.1 Composition rule

```text
dog.activity.delivery.help_unload_bicycle
  task: UnloadTask
  role: helper
  actions:
    approach_target
    contact_align
    pickup_attach
    carry.medium
    place_detach
  object interaction:
    returned crate -> Storage placement anchor
  layers:
    task_intent.delivering_to_storage
    effort.medium_carry
    personality offsets allowed by intent
```

Нельзя создавать по одному монолитному unique clip на каждую комбинацию dog + task + prop. Unique choreography допустима только там, где общая action phrase не сохраняет смысл или физический контакт.

### 2.2 Eligibility grammar

Eligibility может ограничиваться независимо:

```text
all_dogs
skeleton_family:<family>
capability:<carry_light|carry_medium|carry_heavy|pull|push|station_work|room_use>
role:<driver|helper|learner|mentor|resident>
task:<TaskType>
object:<object_id or class>
room:<room_type>
interaction:<socket/anchor compatibility>
```

Действие разрешено только если **все** заявленные ограничения совпали. Отсутствующая eligibility не означает `all_dogs`.

---

## 3. Readability и evidence shorthand

Каждая catalog row ссылается на один readability profile и один или несколько evidence gates.

### 3.1 Readability profiles

| Code | 216 px | 144 px | 96 px |
| --- | --- | --- | --- |
| `R-F` foundation | Identity, pose and transition readable. | Body type + action readable without label. | Dog + movement/action category readable. |
| `R-O` object/force | Identity + contact mode + effort + object. | Dog type + action + object. | Dog + direction/effort + one large main object. |
| `R-S` station | Identity + station contact + work focus. | Dog action + station/prop. | Dog + station-work category; fine hand/paw detail not required. |
| `R-2D` two-dog/social | Both identities/roles and social direction. | Two dogs + gesture/relationship. | Two dogs + broad activity category; nuance may drop out. |
| `R-R` room/home | Pose + exact room prop/contact + calm intent. | Pose/action + main prop/anchor. | Occupancy + broad action category; room detail may carry context. |
| `R-L` additive | Layer reads as secondary personality, never primary task. | May read, but cannot compete with action/object. | Need not read; must not create noise or false action. |

Global order: dog -> body type/silhouette -> action -> object -> mood -> individual detail.

### 3.2 Evidence gates

| Code | Pass condition |
| --- | --- |
| `E-F` foundation | No sliding; ground contact; start/stop/turn/action category readable at native scale. |
| `E-A` approach/contact | Visible orient -> approach -> small adjust -> contact; target state does not change early. |
| `E-C` carry | Declared mode/socket/weight; object remains attached; effort changes motion; no task switch while carried. |
| `E-D` detach/place | Visible target contact and detach/place; object state changes only after completion. |
| `E-P` pull/push | Visible hitch/contact, tension/resistance and shared motion; prop never travels independently. |
| `E-S` station | Dog reaches declared station anchor; loop is tied to prop/station; output appears only after task completion. |
| `E-T` current task chain | Correct Task Flow statuses/events/order id and player-visible causality are captured. |
| `E-R` room interaction | Room/prop exists by authority; entry/occupancy/contact/exit are unambiguous; closed window does not invent simulation semantics. |
| `E-2D` social | Initiator/receiver and partner anchor are clear; no clipping/forced task interruption; no gameplay effect invented. |
| `E-L` additive | Layer is intent-compatible, bounded, calm and quiet at 96 px. |
| `E-O` onboarding | Silhouette trio + idle/walk/carry phrase + declared overrides pass without full per-dog redraw. |

Current `SPIKE` evidence covers a debug phrase `idle -> look -> walk -> pickup -> medium carry -> deliver -> wag`, one prototype socket, simulated head/tail/ear/object layers and approximate 216/144/96 checks. It does **not** prove production clips, foot locking, turn, room actions, all families or current Dachshund/Labrador assets.

---

## 4. Shared foundation action catalog

| Semantic action id | P | Player-visible meaning | Authority / status | Eligibility | Required object/station | Reusable base clip/layer | Special choreography | Readability | Evidence |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `dog.action.idle.neutral` | P0 | Собака спокойно живёт между задачами. | TF §10 + DVL §6.1 / `accepted current` | all_dogs | none; optional home/station vicinity | neutral stand + idle + calm head/tail layers | Must yield to required task; no resource/progression output. | R-F | E-F, E-L |
| `dog.action.wait.calm` | P0 | Собака понятно ждёт target, partner or player confirmation. | TF §§9–10 / `accepted current` | all_dogs | wait anchor or task target | idle or sit + focused intent | Must expose why it waits; never error/urgency pose. | R-F | E-F |
| `dog.action.locomotion.start` | P0 | Из покоя начинается направленное движение. | RAG §7.3 + USER / `user-requested candidate` | all_dogs after clip/family gate | movement target | start + going_to_task | No instant slide from idle. | R-F | E-F |
| `dog.action.locomotion.stop` | P0 | Собака физически завершает движение у target. | RAG §7.3 + USER / `user-requested candidate` | all_dogs after clip/family gate | target approach zone | stop + small_step_adjust | Precedes contact/attach when target is used. | R-F | E-F, E-A |
| `dog.action.locomotion.turn` | P0 | Собака меняет facing/direction как движение, а не телепорт/flip shortcut. | RAG §7.3 + USER / `user-requested candidate` | all_dogs after family gate | path direction | turn base; `turn_or_flip` is not sufficient evidence | Physical turn and rendering flip must remain distinguishable in evidence. | R-F | E-F |
| `dog.action.locomotion.walk_empty` | P0 | Обычная ходьба без переносимого предмета. | TF moving phases; DVL §6.1 / `accepted current` | all_dogs | path / destination | walk_empty + empty effort | Family/personality timing may vary; feet cannot slide. | R-F | E-F, E-O |
| `dog.action.interaction.approach_target` | P0 | Собака подходит к конкретному object/dog/station/room prop. | TF common statuses + RAG §9 / `accepted current` | all_dogs with target eligibility | target approach anchor | walk_empty/slow_walk + look_at_target | orient -> start -> locomotion -> arrive. | R-F or target profile | E-A |
| `dog.action.interaction.contact_align` | P0 | Собака делает последний шаг и занимает правильную contact pose. | TF completing boundary + RAG §9 / `accepted current` | all_dogs with compatible anchor | contact anchor | small_step_adjust + target look | Must precede attach, station work, sit/lie or partner contact. | target profile | E-A |

Shared core означает semantic capability, а не один и тот же authored clip на всех skeleton families. Каждая family/dog проходит свой compatibility gate.

---

## 5. Physical task action catalog

| Semantic action id | P | Player-visible meaning | Authority / status | Eligibility | Required object/station | Reusable base clip/layer | Special choreography | Readability | Evidence |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `dog.action.object.pickup_attach` | P0 | Собака берёт предмет, и он физически становится carried. | TF Unload/Carry/Load + SPIKE / `accepted current` | compatible carry capability + socket | pickup anchor + prop | pickup_pose + carry stance + object layer | approach -> align -> contact -> attach; no early inventory update. | R-O | E-A, E-C |
| `dog.action.carry.light` | P0 | Собака несёт лёгкий предмет без заметного strain. | DVL §6.1; RAG §7.4 / `existing proposal` | capability:carry_light | prop with declared light class/socket | walk + light_carry effort | Prop swing remains small; task intent suppresses play. | R-O | E-C |
| `dog.action.carry.medium` | P0 | Собака несёт обычный order object с читаемым весом. | RAG §§7.4,10 + SPIKE / `existing proposal` | capability:carry_medium | prop with medium class/socket | walk_carry_medium + focused intent | Current spike evidence is generic Food Bag, not current dog art. | R-O | E-C, E-O |
| `dog.action.carry.heavy` | P1 | Собака медленно несёт/поддерживает тяжёлый предмет. | DVL §6.1; RAG §7.4 / `existing proposal` | family/capability:carry_heavy | heavy prop + harness/front-paw solution | slow_walk + heavy_carry effort | Must not silently become drag/pull; second helper requires separate authority. | R-O | E-C |
| `dog.action.object.place_detach` | P0 | Собака ставит/передаёт предмет, затем object state changes. | TF §§2,8 / `accepted current` | current carrier + compatible target | placement anchor | deliver/place pose + detach | contact -> place -> detach -> completion event; never teleport. | R-O | E-D, E-T |
| `dog.action.force.pull_hitched` | P1 | Собака тянет связанный cart/transport. | DVL §6.1; RAG §§7.2,7.4 / `existing proposal` | capability:pull + compatible family | side hitch + wheeled prop | pull stance + pull_tension + slow locomotion | Hitch, tension and wheel/prop response read together. | R-O | E-P |
| `dog.action.force.push_contact` | P1 | Собака толкает object через устойчивый front contact. | DVL §6.1; RAG §9 / `existing proposal` | capability:push | push face/contact anchor | push stance + push_resistance | approach -> inspect -> contact -> resistance loop -> release. | R-O | E-P |
| `dog.action.task.unload` | P0 | Собака снимает returned cargo и начинает перенос к Storage. | TF §8.4; SAP-L / `accepted current` | UnloadTask assignee | returned cargo at Bicycle + Storage | pickup_attach + carry mode + place_detach | Payload must be visible before pickup; inventory only after place. | R-O | E-A, E-C, E-D, E-T |
| `dog.action.task.load` | P0 | Собака физически загружает carried object в target transport/endpoint. | TF §8.9; SAP-L / `accepted current` | LoadVanTask assignee | Food Bag + Van load anchor | carry + contact_align + place_detach | Van ready only after completed load. | R-O | E-C, E-D, E-T |
| `dog.action.station.work_loop` | P0 | Собака видимо работает у station; station не работает сама. | TF Cook/Pack; DVL work loop / `accepted current` | task/station eligibility | declared station work anchor + tool/inputs | work stance + station-specific intent + small work base | Generic base requires a station variant; output waits for task completion. | R-S | E-S, E-T |
| `dog.action.object.inspect` | P1 | Собака осторожно осматривает новый object/board before interaction. | RAG task intent + DL research examples / `existing proposal` | curious/assigned role or scripted activity | inspect target | approach + head look/sniff + pause | Must not create research/find reward by itself. | R-F or R-S | E-A, E-L |

Weight class и carry socket принадлежат prop interaction record, а не породе. Если prop не объявляет их, carry binding fail closed.

---

## 6. Current Warm Delivery and bicycle vocabulary

| Semantic action/activity id | P | Player-visible meaning | Authority / status | Eligibility | Required object/station | Reusable base clip/layer | Special choreography | Readability | Evidence |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `dog.activity.route.check_basket` | P1 | Собака проверяет корзинку перед дорогой. | DL §7.2; BS Road Sign / `existing proposal` | role:driver | Basket Bicycle basket-check anchor | approach + inspect + work_small | Must remain automatic visible prep, not player micro-confirmation. | R-S | E-A, E-S |
| `dog.action.vehicle.travel_with_bicycle` | P0 | Driver и Basket Bicycle вместе уходят и возвращаются; поездка принадлежит собаке. | TF §§5.1,8.2–8.3; SAP-D / `accepted current` | role:driver; current Dachshund | Road Sign, Basket Bicycle, route | walk/vehicle family variant + task intent | Current authority fixes departure/away/return/payload, but not mount/pedal/hitch pose. Exact propulsion choreography is open and must not be invented. | R-O | E-T; vehicle contact variant pending |
| `dog.activity.delivery.help_unload_bicycle` | P0 | Собака помогает разгрузить returned Oat/Pumpkin crates. | TF §8.4; DL §7.1 / `accepted current` | UnloadTask assignee; Labrador preferred | Bicycle cargo + Storage | unload phrase | approach -> attach -> carry -> place; two crates are separate tasks. | R-O | E-A, E-C, E-D, E-T |
| `dog.activity.delivery.carry_ingredient_to_kitchen` | P0 | Собака относит Oat/Pumpkin/Protein в Kitchen. | TF §8.5; DL §7.3 / `accepted current` | CarryTask assignee | Storage source + Kitchen input anchor | pickup + carry(mode) + place | One physical resource per task; Kitchen waits for all inputs. | R-O | E-C, E-D, E-T |
| `dog.activity.delivery.help_kitchen` | P0 | Собака помогает приготовить Food Mix. | TF §8.6; DL §7.4 / `accepted current` | CookTask assignee | Kitchen work anchor + delivered inputs | station.work_loop + kitchen intent | Output appears after work completes; never creates Food Bag. | R-S | E-S, E-T |
| `dog.activity.delivery.carry_to_packing` | P0 | Собака приносит Food Mix or Packaging Bag к Packing Table. | TF §8.7 / `accepted current` | CarryTask assignee | Kitchen/Storage source + Packing input anchor | pickup + carry(mode) + place | Both inputs must be present before PackTask. | R-O | E-C, E-D, E-T |
| `dog.activity.delivery.pack_food_bag` | P0 | Собака превращает delivered inputs в видимый Food Bag. | TF §8.8; DL §7.5 / `accepted current` | PackTask assignee | Packing Table + Food Mix + Packaging Bag | station.work_loop + pack/tie/label variant | Food Bag appears only on completing/complete boundary. | R-S | E-S, E-T |
| `dog.activity.delivery.pack_carefully_labrador` | P0 | Лабрадор в Day 2 помогает упаковать аккуратнее; это care cue, не bonus. | D-022; TF §§6.4,8.12 / `accepted current` | only `dog.labrador_intro` during Day 2 PackTask | same Packing Table and inputs | same PackTask work base + careful_balance/focus layer | Assigned existing PackTask; cue only in `in_progress`; no second task, habit, quality or overlay task. | R-S | E-S, E-T, E-L |
| `dog.activity.delivery.load_food_bag` | P0 | Собака несёт Food Bag и загружает Van. | TF §8.9; SAP-L / `accepted current` | LoadVanTask assignee | Packing Table -> Van load anchor | pickup + medium carry + load | Food Bag remains visible; Van ready after completed load only. | R-O | E-C, E-D, E-T |
| `dog.activity.delivery.wait_for_dispatch` | P0 | Собаки спокойно ждут meaningful player confirmation. | TF §§7,8.10 / `accepted current` | current available dogs; non-carrier | Van wait anchor | wait.calm + focused/calm tail | Cannot auto-send or show urgency. | R-F | E-F, E-T |
| `dog.activity.delivery.notice_feedback` | P0 | Собаки замечают First Day postcard or Day 2 progress note/question. | TF §§8.11–8.12; current visible proof / `accepted current` | scripted current dogs | existing Van-side board / Packing note anchor | approach/look + calm/happy reaction | Feedback must already be available; dog action does not create reward/research. | R-F or R-2D | E-A, E-L, E-T |

`dog.action.vehicle.travel_with_bicycle` authorizes the game-visible phrase, not a final animation solution. Mount, pedal, pull-hitch or combined dog+bicycle choreography remains a Technical Animation + Art decision after an object-contact test.

---

## 7. Social, care, rest and play vocabulary

| Semantic activity id | P | Player-visible meaning | Authority / status | Eligibility | Required object/station | Reusable base clip/layer | Special choreography | Readability | Evidence |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `dog.activity.social.greet_dog` | P1 | Одна собака спокойно приветствует другую. | DVL nice-to-have; RAG greeting / `existing proposal` | social-capable dogs, both task-free | partner approach/interaction anchors | approach + look + calm wag | Initiator/receiver explicit; no forced interruption. | R-2D | E-2D |
| `dog.activity.social.welcome_returning_dog` | P1 | Собака встречает вернувшегося driver. | DL day-of-dog/social examples / `existing proposal` | one returning dog + one free greeter | Road Sign return/welcome anchors | wait + approach + greet | Payload/unload priority cannot be blocked. | R-2D | E-2D, E-T |
| `dog.activity.care.wait_for_partner` | P1 | Собака ждёт напарника у shared work. | DL care examples; TF blocked tone / `existing proposal` | task-linked pair | partner/station wait anchors | wait.calm + glance_at_dog | No penalty or manual scheduling requirement. | R-2D | E-2D |
| `dog.activity.care.support_partner` | P1 | Собака остаётся рядом во время длинной работы. | DL §7.6 / `existing proposal` | helper/support eligibility; target task accepted separately | partner support anchor near station | idle/sit + support intent | Early form may only be IdleTask variant; no gameplay bonus unless separately accepted. | R-2D | E-2D, E-L |
| `dog.activity.care.bring_water` | P2 | Собака приносит воду другой собаке. | DL care example + USER / `user-requested candidate` | future care role + carry capability | water object + partner handoff anchor | light carry + place | Does not create thirst/need/recovery mechanic. | R-O / R-2D | E-C, E-D, E-2D |
| `dog.activity.care.check_companion` | P2 | Собака подходит и проверяет состояние напарника. | DL care example + USER / `user-requested candidate` | future care role; both free or scripted | partner inspect anchor | approach + look/sniff + pause | No hidden health/fatigue state may be inferred. | R-2D | E-2D, E-L |
| `dog.activity.social.sit_together` | P1 | Собаки спокойно сидят рядом. | DL social; BS Dog House / `existing proposal` | room/social eligibility | two seat/floor anchors | sit base + calm look/tail | Seats must preserve separation and facing. | R-2D | E-2D, E-R |
| `dog.activity.play.invite` | P2 | Собака приглашает другую собаку поиграть. | DL §7.9 / `future-only` | both task-free; play accepted separately | partner + optional toy | greet/look + tiny play bow candidate | Must not fire during carry, station work or required wait. | R-2D | E-2D, E-L |
| `dog.activity.play.with_toy` | P1 | Собака коротко играет с любимой игрушкой. | DL §7.9; DVL nice-to-have / `existing proposal` | task-free + toy compatibility | toy anchor/socket | approach + pickup/light object or paw interaction | Toy ownership does not create inventory/reward. | R-R | E-A, E-R |
| `dog.activity.social.show_find` | P2 | Собака показывает маленькую находку другой собаке/board. | DL §7.11 / `future-only` | future event authority + carry compatibility | find prop + partner/notice anchor | light carry + present/place | Must not create mandatory rare-loot loop. | R-O / R-2D | E-C, E-D, E-2D |
| `dog.activity.rest.favorite_place` | P1 | Собака отдыхает у выбранного спокойного места. | DL §7.10 / `existing proposal` | task-free; rest anchor eligible | mat/lamp/rest anchor | sit or lie + relaxed effort | No energy refill, absence punishment or paid comfort. | R-R | E-R, E-L |

---

## 8. Room and home interaction vocabulary

Rich room activities remain in room/detail windows. Their presence here does not authorize a room implementation.

| Semantic action/activity id | P | Player-visible meaning | Authority / status | Eligibility | Required object/station | Reusable base clip/layer | Special choreography | Readability | Evidence |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `dog.action.room.enter` | P1 | Собака входит в accepted room through its existing transition point. | BS §§1–2 + USER / `user-requested candidate` | room_use + room accepted | room entry anchor | walk + contact_align + enter transition | Must expose whether dog leaves main strip; no teleport without room state transition. | R-R | E-R |
| `dog.action.room.exit` | P1 | Собака выходит и возвращается к strip/parent space. | BS §§1–2 + USER / `user-requested candidate` | current room occupant | room exit + strip return anchor | exit transition + walk | Clears room occupancy before new task ownership. | R-R | E-R |
| `dog.action.rest.sit` | P1 | Собака садится у floor/seat anchor. | DVL base/nice-to-have; RAG base pose / `existing proposal` | family seat-compatible | floor/seat anchor | sit base + relaxed/focused layer | approach -> align -> sit; seat is not baked into clip. | R-R | E-A, E-R |
| `dog.action.rest.lie` | P1 | Собака ложится на bed/mat/floor anchor. | DVL nice-to-have; RAG base pose / `existing proposal` | family bed-compatible | bed/mat/floor anchor | lie base + relaxed effort | Needs body-length clearance and deterministic facing. | R-R | E-R |
| `dog.action.rest.sleep` | P1 | Собака спит в safe room/home state. | DVL nice-to-have; DL rest / `existing proposal` | task-free room resident | bed/mat sleep anchor | lie + sleep loop + quiet additive | Cannot coexist with assigned required task; no energy mechanic inferred. | R-R | E-R, E-L |
| `dog.activity.room.read_book` | P1 | Собака читает/рассматривает книгу в library/home. | DL/BS room prose / `existing proposal` | room/learner eligibility | book prop + reading cushion/desk anchor | sit/lie + head_look + page-focus work loop | Page turn can be prop/world layer; no literacy/research reward unless accepted. | R-R | E-R, E-S |
| `dog.activity.room.study_board` | P1 | Собака рассматривает board/lesson. | BS Laboratory proposal; DL §7.7 / `existing proposal` | future learner/research role | board view anchor | sit/stand + look_at_target + inspect | No research progress, assignment UI or choice implied. | R-R | E-R, E-S |
| `dog.activity.room.rocking_chair_rest` | P2 | Собака спокойно отдыхает в rocking chair. | USER / `user-requested candidate` | family/chair compatibility; task-free | rocking-chair seat + entry/exit anchors | sit/lie family variant + relaxed; chair motion world layer | Dog occupies seat; chair owns rocking motion. Requires body clearance/contact proof. | R-R | E-R |
| `dog.activity.room.toy_interaction` | P1 | Собака играет с toy at home without scheduling pressure. | DVL nice-to-have; DL/BS Dog House / `existing proposal` | task-free + toy compatibility | toy pickup/paw anchor | inspect + pickup_light or paw-contact variant | Mode declared per toy; no generic prop teleport. | R-R | E-A, E-R |
| `dog.activity.room.eat_from_bowl` | P2 | Собака ест у bowl как ambient home action. | DVL nice-to-have + USER / `user-requested candidate` | bowl/family compatibility; task-free | food bowl rim/head anchor | approach + head_down + bowl loop | Does not introduce hunger, food economy or penalty. | R-R | E-A, E-R |
| `dog.activity.room.drink_water` | P2 | Собака пьёт воду у bowl as ambient action. | DVL nice-to-have + USER / `user-requested candidate` | bowl/family compatibility; task-free | water bowl rim/head anchor | approach + head_down + drink loop | Separate semantic from eat; no thirst/recovery mechanic. | R-R | E-A, E-R |
| `dog.activity.room.tidy_place` | P2 | Собака поправляет маленький object у station/home. | DL §7.12; BS Storage/Packing / `future-only` | tidy role/prop compatibility | tidy prop + placement anchor | approach + light pickup/place or work_small | No decor power bonus or mandatory housekeeping. | R-R | E-A, E-D, E-R |

Room matrices may reference `dog.activity.social.greet_dog`, `dog.activity.care.support_partner` and `dog.activity.social.sit_together`; no duplicate room-only clips are required.

---

## 9. Micro-behaviour and additive-layer vocabulary

These IDs are layers/interrupts, not activities or independent mechanics.

| Semantic layer id | P | Player-visible meaning | Authority / status | Eligibility | Required target/prop | Reusable layer | Special rules | Readability | Evidence |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `dog.layer.head.look_target` | P0 | Focus on current object/station/dog. | RAG §7.5; SPIKE / `existing proposal` | action intent allows | current target | head_look additive | Cannot point away during precision contact. | R-L | E-L |
| `dog.layer.head.look_around` | P1 | Calm curiosity between tasks. | RAG §7.10 / `existing proposal` | idle/walk_empty only by mask | none | look-around additive | Suppress during heavy carry/precision work. | R-L | E-L |
| `dog.layer.head.sniff` | P1 | Dog-like inspection gesture. | RAG §§7.5,7.10 / `existing proposal` | inspect/idle; not socket-conflicting | ground/object target | sniff additive/short insert | Does not imply find/research result. | R-L | E-L |
| `dog.layer.face.blink` | P0 | Quiet life/attention. | RAG §7.10 / `existing proposal` | all_dogs | none | blink additive | Must remain subtle at 96. | R-L | E-L |
| `dog.layer.head.tilt` | P2 | Small curious/emotional accent. | RAG §7.5 / `existing proposal` | idle/greet/inspect | target optional | head tilt additive | Not during carry if it destabilizes socket/readability. | R-L | E-L |
| `dog.layer.ear.twitch` | P1 | Small alert/personality cue. | RAG §§7.6,7.10 / `existing proposal` | compatible ear family | none | ear twitch additive | Respect asymmetric/heavy-ear override. | R-L | E-L |
| `dog.layer.ear.step_bounce` | P1 | Ear secondary motion from locomotion. | RAG §7.6; SPIKE simulated / `existing proposal` | compatible ear family + locomotion | none | ear bounce additive | Must not noise at 96 or break silhouette. | R-L | E-L |
| `dog.layer.tail.calm_sway` | P0 | Calm living motion. | RAG §7.7 / `existing proposal` | compatible tail family | none | tail sway additive | Task intent may reduce/freeze it. | R-L | E-L |
| `dog.layer.tail.wag_burst` | P1 | Brief positive reaction. | RAG §7.10; SPIKE / `existing proposal` | completion/greet/idle masks | none | tail_wag additive | Not a reward; no constant mobile-game motion. | R-L | E-L |
| `dog.layer.pause.tiny` | P1 | Careful or curious rhythm. | RAG §7.10 / `existing proposal` | intent allows; never blocks chain | target optional | timing offset | No urgency/failure meaning. | R-L | E-L |
| `dog.layer.paw.adjust` | P0 | Final physical alignment at contact. | RAG §7.10 / `existing proposal` | contact actions | contact anchor | small_step/paw adjust | Part of E-A, not random fidget. | R-L | E-A |
| `dog.layer.body.stretch` | P1 | Calm idle/rest transition. | TF §10; RAG §7.10 / `accepted current` | task-free | rest space | stretch insert | Must yield immediately to required task after safe finish. | R-F | E-F, E-L |
| `dog.layer.body.shake` | P2 | Short fur/head reset gesture. | DVL nice-to-have; RAG §7.10 / `existing proposal` | no carried/attached prop | clear space | shake insert | Forbidden with object socket active. | R-L | E-L |
| `dog.layer.body.happy_hop` | P2 | Small celebratory accent. | RAG §7.10 / `existing proposal` | explicit completion/greet only | clear space | happy reaction insert | Forbidden during carry, wait-for-player and precise station work. | R-L | E-L |

### 9.1 Personality motion presets

Presets modify timing/layers; they do not grant actions, roles or mechanics.

| Preset id | Source / status | Typical allowed effects | Never grants |
| --- | --- | --- | --- |
| `dog.motion_preset.curious_helper` | RAG §8.1 / `existing proposal` | more look/sniff, small pauses, lively but bounded tail | research, find or helper role |
| `dog.motion_preset.calm_worker` | RAG §8.2 / `existing proposal` | even step, low head bob, slow tail, stable carry | heavy-carry eligibility or worker assignment |
| `dog.motion_preset.happy_bouncy` | RAG §8.3 / `existing proposal` | higher step energy, occasional allowed completion hop | play action during task |
| `dog.motion_preset.careful_gentle` | RAG §8.4 / `existing proposal` | slower turn, low object swing, pause before contact | careful-packing mechanic or quality bonus |
| `dog.motion_preset.sleepy_soft` | RAG §8.5 / `existing proposal` | slower walk, long blink, rest-biased idle | fatigue, sleep need or lower stats |

No current accepted contract assigns a production motion preset to Dachshund or Labrador. `calm_worker` / `careful_gentle` are compatible candidates for Labrador’s presentation, not accepted identity facts.

---

## 10. Interaction dependency vocabulary

### 10.1 Dog execution versus world/art responsibility

| Dog execution owns | World / prop / room vocabulary owns |
| --- | --- |
| orient, approach, start/stop/turn, final alignment | target position, approach radius, allowed facing |
| attach/pickup and detach/place request at the correct phase | object geometry, visible state, socket/anchor compatibility |
| carry/effort/contact pose and action intent | prop weight class, readability size, swing limits |
| enter/exit and occupancy request | room transition point, occupancy slot and window/world representation |
| sit/lie/read/eat/drink/toy execution | seat/bed/book/bowl/toy contact anchors and object response |
| partner approach/greet/support intent | partner slots, safe separation, initiator/receiver availability |

Neither side may invent the other side’s mechanic. Art cannot turn a prop into a new activity; dog execution cannot guess an anchor from artwork.

### 10.2 Socket / anchor classes

| Interaction id | Use | Eligibility note | Status |
| --- | --- | --- | --- |
| `interaction.socket.mouth` | light/medium held object | muzzle/family-specific position required | DVL proposal |
| `interaction.socket.chest_harness` | stable carry/work attachment | harness-compatible dog/prop | DVL proposal |
| `interaction.socket.front_paws` | push/support/paw-held tool | stance and ground support required | DVL proposal |
| `interaction.socket.side_hitch` | cart/bicycle pull connection | pull capability + readable tension | DVL proposal |
| `interaction.socket.back_saddlebag` | side/back cargo | must not erase silhouette | DVL proposal |
| `interaction.socket.tool` | watering/brush/label tool | station/tool choreography required | DVL proposal |
| `interaction.anchor.station_work` | Kitchen/Packing/other station contact | station declares facing/occupancy/output boundary | TF current meaning; concrete anchor per object |
| `interaction.anchor.placement` | Storage/Kitchen/Packing/Van handoff | target changes state only after detach/place | TF accepted current |
| `interaction.anchor.seat` | sit/read/rest | family/body clearance required | USER candidate |
| `interaction.anchor.bed` | lie/sleep/rest | body-length and facing clearance | USER candidate |
| `interaction.anchor.book` | read interaction | book + seat/desk relation required | USER candidate |
| `interaction.anchor.board_view` | study/inspect | readable viewing distance/facing | BS proposal |
| `interaction.anchor.rocking_chair` | chair occupancy/rest | chair owns rocking; dog owns seated pose | USER candidate |
| `interaction.anchor.toy` | pickup/paw/play | exact mode declared by toy | DVL/DL proposal |
| `interaction.anchor.bowl_food` | ambient eating | no hunger mechanic implied | USER candidate |
| `interaction.anchor.bowl_water` | ambient drinking | no thirst mechanic implied | USER candidate |
| `interaction.anchor.partner` | greet/support/social | two compatible slots + availability | DL/RAG proposal |

The current spike’s `MouthHarnessSocket` proves one prototype attachment path only. It does not collapse mouth and harness into one canonical production socket.

### 10.3 Current object dependency notes

| Object/station | Current game authority | Required dog semantics | Unresolved implementation choice |
| --- | --- | --- | --- |
| Oat/Pumpkin Crate | TF accepted | pickup -> declared carry mode -> Storage place | Exact socket/weight class not accepted. |
| Protein Packet | TF accepted | pickup -> carry -> Kitchen place | Exact socket/weight class not accepted. |
| Packaging Bag | TF accepted | pickup -> carry -> Packing place | Exact socket/weight class not accepted. |
| Food Mix container | TF accepted | pickup -> carry -> Packing place | Exact visual container/socket not accepted. |
| Food Bag | TF accepted; RAG example medium | pickup -> carry -> Van load | Mouth vs harness remains art/tech binding decision. |
| Basket Bicycle | TF accepted | driver approach/prep + shared departure/return phrase | Mount/pedal/hitch/combined motion unresolved. |
| Kitchen | TF accepted | approach + work anchor + CookTask loop | Exact tool/paw choreography unresolved. |
| Packing Table | TF accepted | approach + work anchor + PackTask loop | Exact tie/label prop choreography unresolved. |
| Van Endpoint | TF accepted | carry + load placement + wait | Exact load contact/facing unresolved. |

Unresolved contact implementation is not permission to skip the visible action. Binding must fail closed and return the missing socket/anchor decision.

---

## 11. Forbidden combinations and fail-closed rules

| Invalid combination | Required behavior |
| --- | --- |
| action without actor eligibility/role authority | Do not bind or play; report missing actor/action authority. |
| object action without declared object, socket/mode and target anchor | Do not substitute a generic carry/work clip; report missing object interaction authority. |
| room action without accepted room/prop and occupancy contract | Keep future-only; do not spawn room, chair, book, bowl or mechanic. |
| carry + play/happy-hop/shake or task-incompatible micro layer | Suppress layer; task intent wins. |
| heavy carry using an unvalidated light mouth socket | Fail compatibility; require harness/front-paw/other accepted solution. |
| pull without hitch/tension or push without contact/resistance | Fail evidence; prop cannot move independently. |
| pickup/place/load that changes object state before visible contact completion | Fail causality; no teleport or early inventory/state update. |
| dog switches task while carrying an item | Finish current carry/place or use debug recovery only. |
| idle/rest/sleep while a required owned task is active | Required task wins after safe transition; no broken progression. |
| sit/lie/read/eat/drink/rocking-chair without body-clearance/contact anchor | Do not approximate with floating/overlapping pose. |
| eat/drink/rest/play implying hunger, thirst, fatigue, recovery or penalty | Remove system implication; these remain ambient unless separately accepted. |
| social action interrupts another dog’s carry/station task | Delay/skip social action; no forced micromanagement. |
| personality preset grants role/action/bonus | Reject binding; presets only modify allowed motion. |
| secondary motion creates 96 px noise or false action | Reduce/suppress additive layer. |
| complete unique atlas required for every dog | Reject production approach; use shared base + declared family/role/object variants. |
| clip name exists but semantic source/status is missing | Clip is unavailable to gameplay; asset existence is not authority. |

---

## 12. Coverage matrix 1 — shared core every dog

`Required` here means vocabulary/onboarding coverage, not one identical production clip file.

| Semantic coverage | P | Every dog | Status/gate |
| --- | --- | --- | --- |
| idle + calm wait | P0 | required | `dog.action.idle.neutral`, `dog.action.wait.calm`; E-F |
| start + stop + physical turn | P0 | required | candidate semantics; family evidence required |
| walk empty | P0 | required | E-F + 216/144/96 |
| approach target + contact align | P0 | required | E-A with generic target and at least one real target |
| one safe completion reaction | P1 | required before production onboarding | allowed calm wag/look; no unique full clip required |
| sit or lie rest base | P1 | at least one required for life coverage | family + anchor proof; room scope separate |
| blink + bounded head/tail life layers | P1 | required before production feel lock | E-L; may be suppressed at 96 |
| pickup/carry/place | conditional | required only if dog receives compatible role/task | mode/socket/prop gates; not all dogs carry every weight |
| room/social actions | conditional | only when room/role accepted | E-R/E-2D; never inferred from shared core |

---

## 13. Coverage matrix 2 — current Dachshund driver

Current semantic card status remains `NEEDED`; none of these rows claims an approved dog asset.

| Required coverage | P | Current authority | Eligibility / dependency | Evidence note |
| --- | --- | --- | --- | --- |
| shared core foundation | P0 | TF moving/idle phases; SAP-D | short-long candidate family must adapt all required bases | E-F; native 216/144/96 |
| route approach and basket/bicycle prep | P0 | TF accepted; basket-check is P1 proposal | Road Sign + Basket Bicycle | current trip proof; basket-check separate proposal |
| bicycle departure/away/return phrase | P0 | TF TripTask accepted | role:driver, `dog.dachshund_intro` | E-T; exact mount/pedal/hitch is open |
| simple wait by Road Sign/Van | P0 | TF accepted | wait anchor; no urgency | E-F/E-T |
| fallback unload/carry | P0 conditional | TF §§6.2–6.3 | only when Labrador unavailable/busy and task assigns Dachshund | E-A/E-C/E-D |
| eligible CookTask / ordinary PackTask / LoadVanTask | P0 conditional | TF §§6.4,14 | only when current scheduler assigns; Day 2 PackTask is excluded | E-S/E-T |
| Comfortable Slippers visible equipment state | P0 First Day continuity | First Day/D-010; SAP-D | equipment layer, not separate locomotion atlas | visual/Dog Card evidence; no innate-trait merge |
| first-driver memory/readiness cue | P0 Day 2 return | D-022 continuity | route-prep composition + inspectable memory | does not create speed bonus |
| room/home actions | P1/P2 candidate | BS/DL only | no Dachshund-specific room assignment accepted | do not specialize without authority |

Forbidden for current Dachshund: alternative-driver selection system, passenger choreography, Labrador-only Day 2 careful PackTask cue, or a unique slippers clip set for every action without art/tech acceptance.

---

## 14. Coverage matrix 3 — current Labrador helper

Current semantic card status remains `NEEDED`; rejected SVGs are not evidence.

| Required coverage | P | Current authority | Eligibility / dependency | Evidence note |
| --- | --- | --- | --- | --- |
| shared core foundation | P0 | TF + SAP-L | large-sturdy candidate family; actual family not production-accepted | E-F; native 216/144/96 |
| preferred bicycle unload | P0 | TF §6.2 | returned cargo + Storage | full approach/pickup/carry/place, not monolithic still |
| preferred crate/Food Bag carry | P0 | TF §6.3 | declared prop mode/socket | E-C/E-D |
| Kitchen station help | P0 | TF CookTask | Kitchen work anchor | E-S/E-T |
| ordinary PackTask eligibility | P0 conditional | TF §6.4 | Packing Table | generic PackTask phrase |
| Day 2 careful PackTask | P0 mandatory for scenario | D-022 + TF §8.12 | deterministic Labrador assignee; same PackTask | event only in `in_progress`; no second task/bonus |
| LoadVanTask eligibility | P0 conditional | TF scheduler | Food Bag + Van load anchor | E-C/E-D/E-T |
| calm helper presentation | P1 motion candidate | SAP-L meaning; RAG presets proposed | no preset grants helper role | E-L; no new mechanic |
| support/rest/social | P1 candidate | DL/BS draft | task-free + accepted partner/room anchor | E-2D/E-R; no current bonus |

Forbidden for current Labrador: TripTask driver, independent Day 2 overlay task, automatic quality/habit state, or room role assignment not accepted elsewhere.

### 14.1 Current bounded ambient Labrador walk — user decision recorded

**Status:** `AMENDMENT_RECORDED / GAME_DESIGN_ACCEPTED / PM_TECH_PENDING` — selector H is now recorded in the exact manifest, but is not executable until Producer/PM and Technical/Codex complete their readbacks.

Current world boundary:

- the Mill may appear now only as a static decorative object;
- it creates no mechanic, task, resource, input, output, route, reward or progression authority;
- Labrador remains the only first living dog; Dachshund/cart behavior is not current critical scope.

The user requests a calm back-and-forth Labrador walk as base living-scene presentation. This reuses only existing shared rows `dog.action.idle.neutral`, `dog.action.locomotion.start`, `dog.action.locomotion.walk_empty`, `dog.action.locomotion.stop` and `dog.action.locomotion.turn`; it creates no new semantic row, task or world-state authority.

The current accepted Labrador manifest bound locomotion to station selector C (`CookTask` / `PackTask`, `moving_to_source`). Selector H now records the following bounded amendment, retaining the same 12 semantic rows:

```text
actor: dog.labrador_intro
precondition: current_task == "" and current_visible_state == "idle"
queue guard: no queued/assigned task belongs to Labrador
journey guard: either an offered order before TripTask creation, or post-Day-2 Quiet Cooperative
presentation phrase: idle -> bounded start/walk/(physical turn if direction changes)/stop -> idle
authority: presentation-only; Godot runtime remains the sole authority
```

Guardrails for selector H:

- an active order alone never grants progression; the phrase is allowed only in the two states above and must yield before any required task;
- it is forbidden from TripTask creation through delivery resolution, and while `ready_to_send` it yields to the accepted calm-wait selector rather than wandering;
- it is forbidden while Labrador has a current/queued task, during any protected task phase, restore until the safe checkpoint state is fully restored, or save-failure/retry/recovery handling;
- a player input that starts a task or changes a player gate cancels the phrase before the authoritative transition; the phrase never captures input, delays a gate or creates a competing cue;
- it creates no event, resource movement, task/order/status change, save write, reward, memory, habit, quality, timer result or Day 3/repeatable loop.

Game Design has accepted the exact manifest amendment. Before any Art/Technical executable binding, Producer/PM and Technical/Codex must complete their readbacks; Art/Technical still own the actual world bounds, facing and binding evidence. The amendment retains exactly the same 12 rows and does not silently expand any gameplay authority.

---

## 15. Coverage matrix 4 — room/interior candidate set

This matrix is a design coverage list only. It does not authorize room implementation.

| Candidate coverage | Semantic IDs | P | Authority/status | Required dependency | Gate |
| --- | --- | --- | --- | --- | --- |
| enter / exit | `dog.action.room.enter`, `dog.action.room.exit` | P1 | USER candidate on BS model | room transition + occupancy anchors | E-R |
| sit / lie / sleep | `dog.action.rest.sit`, `.lie`, `.sleep` | P1 | DVL/RAG/DL proposal | seat/bed/floor clearance | E-R |
| read | `dog.activity.room.read_book` | P1 | DL/BS proposal | book + reading seat/desk | E-R/E-S |
| study / board | `dog.activity.room.study_board` | P1 | BS/DL proposal | board view anchor | E-R/E-S |
| rocking-chair rest | `dog.activity.room.rocking_chair_rest` | P2 | USER candidate | chair seat/entry/exit; chair owns rocking | E-R |
| toy | `dog.activity.room.toy_interaction` | P1 | DVL/DL/BS proposal | toy mode + anchor/socket | E-R |
| bowl / water | `.eat_from_bowl`, `.drink_water` | P2 | USER candidate from DVL list | distinct food/water anchors | E-R |
| greet / sit together | `dog.activity.social.greet_dog`, `.sit_together` | P1 | DL/RAG proposal | two partner/seat slots | E-2D/E-R |
| support | `dog.activity.care.support_partner` | P1 | DL proposal | partner support anchor; no task interruption | E-2D |
| tidy place | `dog.activity.room.tidy_place` | P2 | DL future | declared movable prop + placement | E-D/E-R |

Room action cannot move from this matrix into a manifest unless the room, prop, occupancy and gameplay status are all cited.

### 15.1 USER_REQUESTED_FUTURE_DIRECTION — rich dog-life backlog vocabulary

**Status:** `USER_REQUESTED_FUTURE_DIRECTION / NOT_ACCEPTED_CURRENT`.

The user direction is: build a quality visual base and already accepted gameplay now; expand to a richer dog-life catalogue later. The following are future vocabulary/backlog meanings only. They grant **no** current mechanic, task, role, room, vehicle, resource, input, output, reward, progression, asset or runtime authority:

1. Dog pulls or rides with a cart.
2. Dog rides a bicycle.
3. Dog drives a small truck.
4. Dog sits in the bed of a large truck.
5. Dog sits at a school desk.
6. Dog reads in a library.
7. Dog mixes chemicals in a laboratory.
8. Dog teaches at a blackboard with a pointer.
9. Dog relaxes in a rocking chair with a book.
10. Dog sleeps.
11. Dog plays with another dog.
12. Dog chases its tail.
13. Further everyday dog-life states are intentionally an open future catalogue, not an implicit universal atlas.

Every item requires a later separately accepted product/game slice with its actor/role, task-or-ambient authority, object/vehicle/room/partner anchors, safety/readability evidence and manifest entry. In particular, no cart/bicycle/truck phrase is authorized by the current first-driver route, and no school/library/lab/chair/play/sleep phrase authorizes a room, research, social, need or reward system.

---

## 16. Coverage matrix 5 — future dog onboarding template

A future dog action manifest should be generated from capabilities/tags and authority, not from a hardcoded universal action list.

| Audit dimension | Required manifest content | Pass condition | Fail closed when |
| --- | --- | --- | --- |
| identity provenance | dog id, source type, approval/permission reference | dog identity is authorized and respectful | identity/source authority missing |
| morphology/family | proposed/accepted family, morphology tags, required overrides | silhouette works at 216/144/96 | family chosen by breed label only or clip breaks form |
| shared foundation | eligible IDs tagged `foundation` from this vocabulary | idle/wait/start/stop/turn/walk/approach/contact coverage mapped | a foundation action has no compatible base/evidence |
| role coverage | accepted role ids and source refs | every assigned task has an eligible action phrase | role inferred from body type/personality |
| object modes | capabilities + prop class + weight/socket/anchor | every object action declares attach/contact/detach | generic carry substituted without prop authority |
| room/social coverage | only accepted room/role interactions | room/partner anchors and occupancy declared | room/prop mechanic missing or future-only |
| base clips/layers | semantic action -> reusable base + allowed layers | reuse is visible; variants are bounded | full unique per-dog atlas required |
| forbidden mask | incompatible intents/layers/props/family overrides | task intent suppresses invalid layers | carry/play, sleep/task or socket conflict possible |
| readability | per-action R profile at native 216/144/96 | required meaning survives target scale | only labeled/debug view reads |
| evidence | E gates + capture/test references | idle/walk/carry minimum and role-specific phrases pass | planned clip treated as implemented evidence |
| status provenance | vocabulary path/version, row status, source refs | manifest distinguishes accepted/proposed/future | proposal silently promoted to accepted |

### 16.1 Suggested future manifest fields

This is a documentation shape, not an accepted runtime schema:

```text
dog_id
vocabulary_path
vocabulary_version
skeleton_family
role_ids[]
capability_tags[]
actions[]
  semantic_id
  priority
  authority_status
  source_refs[]
  eligibility_match
  base_clip_ref optional
  allowed_layers[]
  forbidden_layers[]
  object_interaction optional
    object_class
    weight_class
    socket
    target_anchor
  room_interaction optional
    room_type
    prop_id
    occupancy_anchor
  readability_profile
  evidence_gate
  evidence_refs[]
```

The manifest cites this document as vocabulary authority but must retain each row’s source/status. It must never cite the proposed file as proof that every row is accepted.

---

## 17. Gap analysis — three partial lists

### 17.1 Dog Visual clip library

Provenance: `DOG_VISUAL_LANGUAGE_v1.md` §§6–8, working draft.

It contains:

- 10 broad MVP clip candidates;
- nice-to-have room/social clips;
- sockets and object layers;
- family eligibility and 216/144/96 requirements.

Gaps:

- broad visual `MVP` is not current gameplay scope or every-dog shared core;
- pickup, attach, place and detach are not separated;
- `sit / rest`, carry/drag and some work actions merge different meanings;
- no task/role/state provenance per clip;
- no accepted current Dachshund/Labrador evidence;
- five proposed families conflict in naming/scope with runtime’s staged one -> three -> five family hypothesis.

Resolution here: preserve its clip/layer/family proposals as eligibility and base vocabulary, while current Task Flow decides current gameplay meaning.

### 17.2 Runtime spike clip set

Provenance: `DOG_RUNTIME_AND_ANIMATION_GRAMMAR_v1.md` §10 plus actual `dog-rig-spike.md` evidence.

Planned set: idle, walk, medium carry, turn_or_flip, pickup, deliver, tail/head/ear layers. Actual qualified spike reports idle, head look, walk, pickup, medium carry, deliver and tail wag, with simulated ear/head/tail/object layers and one `MouthHarnessSocket`.

Gaps:

- `turn_or_flip` is planned but not demonstrated and conflates two semantics;
- pickup/deliver poses do not prove full contact/attach/detach contract;
- generic `deliver` is not gameplay DeliveryTask completion;
- debug prototypes are not current Dachshund/Labrador assets;
- foot locking and shared production runtime remain unresolved;
- no room, social, station, bicycle, push/pull or heavy mode proof.

Resolution here: treat SPIKE only as evidence refs for reusable grammar; never as gameplay authority or production acceptance.

### 17.3 Dog Life activity catalog

Provenance: `STEAM_DESKTOP__Dog_Life_Model_v1.md` §7, draft v1.

It contains 12 meaningful life cards: unload, basket check, ingredient carry, kitchen help, careful packing, support, laboratory observation, tree care, play, rest, share find and tidy station.

Gaps:

- only one example semantic id is present;
- technical action decomposition, family eligibility, sockets/anchors, readability and evidence are absent;
- most non-production mappings are `later` or early IdleTask variants;
- room prose does not authorize room actions or object choreography;
- it explicitly excludes final animation production list and visual requirements.

Resolution here: give the meanings canonical proposed IDs and retain their draft/future status rather than silently promoting them.

### 17.4 Combined gaps now closed by this proposal

- shared foundation separated from specialist capabilities;
- action vs activity vs task vs clip distinctions;
- parameterized carry/contact modes;
- room/prop dependency vocabulary;
- current Dachshund/Labrador coverage;
- additive intent masks and forbidden combinations;
- per-row readability/evidence gates;
- onboarding audit that does not hardcode one flat action atlas.

Still open: production clips/assets, exact current object sockets/weights, bicycle propulsion choreography, room acceptance and production pipeline.

---

## 18. Representative manifest validity examples

These examples test authority; they do not request new mechanics.

### Valid A — current Labrador Day 2 PackTask

```text
actor: dog.labrador_intro
role/task authority: TF §6.4 + D-022
semantic activity: dog.activity.delivery.pack_carefully_labrador
base: dog.action.station.work_loop
station: Packing Table work anchor
event: labrador_packing_care_moment during PackTask in_progress
status: accepted current
```

Pass only if it remains the existing PackTask and creates no quality/habit/bonus.

### Valid B — future dog with light toy activity

```text
actor: future authorized dog
semantic activity: dog.activity.room.toy_interaction
status: existing proposal
requirements: task-free + accepted Dog House room + toy mode/socket/anchor + E-R
```

Valid as a proposed manifest row; invalid as a current implementation request until room/toy scope is accepted.

### Invalid A — personality grants mechanic

```text
motion preset: calm_worker
inferred roles: helper, heavy_carrier
```

Reject: motion preset changes presentation only and cannot grant role/capability.

### Invalid B — generic room fallback

```text
semantic activity: dog.activity.room.rocking_chair_rest
room/prop authority: missing
fallback: play sit clip at approximate chair position
```

Reject: no accepted room/prop/anchor; fail closed instead of floating/overlap.

### Invalid C — clip name treated as authority

```text
clip: watering
actor: dog.dachshund_intro
reason: clip exists in visual MVP list
```

Reject: visual working proposal does not establish current task, role, object or short-long vertical-work compatibility.

---

## 19. Stop conditions and open decisions

Stop and return the question to the owning role when:

- a requested action lacks accepted/proposed actor, action, object, station or room authority;
- a physical object lacks weight, socket/contact mode or placement anchor;
- a room activity lacks accepted room/prop/occupancy semantics;
- a clip would invent a mechanic, role, state change, resource, need or reward;
- an Art/Technical choice would determine product/game meaning;
- current Task Flow causality would be hidden, skipped or replaced by a label;
- eligibility would require every dog to receive the same full atlas;
- a skeleton family cannot perform the action without changing object/building scale or gameplay responsibility;
- readability requires production style/pipeline decisions not yet accepted;
- future-only life activity is about to enter current Day 1/Day 2 scope;
- evidence exists only as rejected asset, planned clip or debug label.

Open decisions remain with the named owners:

1. **Producer / Game Designer:** which P1 room/social/rest/play candidates enter a future executable slice, if any.
2. **Art Director / Technical Animation:** production skeleton families, actual current dog family binding, base clips, variants, exact socket positions and bicycle choreography.
3. **Art Director:** final readability/art acceptance and prop/room visual vocabulary.
4. **Technical Animation / Codex:** clip/binding/pipeline implementation after accepted art/technical contract; no pipeline is selected here.
5. **Game Designer / Object owner:** weight/mode bindings for current crates, packets, Food Mix and Food Bag if implementation needs canonical values.

Current known blockers:

- Semantic Asset Pack Dachshund/Labrador action cards remain `NEEDED`; no approved action assets exist.
- Current runtime spike is debug-only and does not prove production current-dog clips.
- Exact Basket Bicycle driver contact/propulsion choreography is not fixed.
- Room/interior actions remain proposals/candidates and cannot enter runtime without separate product/game scope acceptance.

---

## 20. Acceptance criteria for this proposed vocabulary

This document is ready for cross-role review when:

1. Shared core is separated from family/role/object/room-specific actions.
2. Every catalog row has semantic ID, meaning, provenance/status, priority, eligibility, dependency, reusable base/layer, choreography, readability and evidence gate.
3. Current Dachshund and Labrador coverage follows accepted Task Flow and Semantic Asset Card needs without claiming assets exist.
4. Room/home coverage remains candidate/future-safe.
5. Micro/personality layers cannot grant mechanics or obscure task intent.
6. Object/socket/anchor dependencies and invalid combinations fail closed.
7. All three partial source lists are compared by provenance, not duplicated as accepted truth.
8. Future dog onboarding uses dimensions/capabilities rather than a universal hardcoded atlas.
9. No art style, production pipeline or new product/game system is selected.

---

## 21. Changelog

### 2026-07-13 — selector H amendment, Game Design accepted

- Synchronized the vocabulary record with the exact 12-row manifest amendment for task-free ambient Labrador reposition.
- Left Producer/PM and Technical/Codex readbacks pending; no runtime binding or new mechanics were authorized.

### 2026-07-13 — user direction: quality base now, rich dog life later

- Recorded the Mill as static decorative-only and Labrador as the only current living-dog priority; no new gameplay authority was added.
- Recorded the requested future dog-life catalogue as `USER_REQUESTED_FUTURE_DIRECTION / NOT_ACCEPTED_CURRENT` backlog vocabulary.
- Classified calm Labrador back-and-forth as `NEEDS_MANIFEST_AMENDMENT`: it may reuse existing rows later, but cannot extend the exact station-bound A–G manifest silently.

### 2026-07-11 — proposed v1 created

- Added layered game-first action/activity vocabulary with provenance and per-row status.
- Added P0/P1/P2, eligibility, object/room interaction and readability/evidence gates.
- Added shared, Dachshund, Labrador, room and future-onboarding coverage matrices.
- Added gap analysis for Dog Visual clip library, runtime spike set and Dog Life activity catalog.
- Kept all production art/pipeline and future room/system decisions open.
