# STEAM_DESKTOP — World And Room Asset Vocabulary v1

Дата: 2026-07-11
Роль документа: Art Direction / visual asset vocabulary
Статус: **proposed / preview-R&D planning, not production art approval**
Продукт: Shelter Steam/Desktop
Владелец визуального вердикта: Art Director
Связанный roadmap: `STEAM_DESKTOP__Visual_Production_Roadmap_v1.md`

---

## 0. Назначение

Этот документ задаёт общий словарь для визуального планирования:

- нижнего прозрачного main strip;
- земли, травы, утоптанной земли/песка, дорожек и переходов;
- забора и отдельной зоны за забором, где припаркован Basket Bicycle;
- редких Building exterior anchors и Utility Props;
- отдельного room/detail window;
- room shell, stations, furniture, state overlays и interaction anchors;
- 216 / 144 / 96 px QA;
- первых двух `PREVIEW_RESEARCH_ONLY` sheets.

Документ является **coverage map**, а не списком заказанных ассетов. Он не принимает механику, room scope, финальный стиль, production pipeline, runtime schema или asset approval.

---

## 1. Authority model: не смешивать четыре разных решения

Каждая строка должна иметь четыре независимых измерения.

| Измерение | Вопрос | Допустимые значения в этом документе |
| --- | --- | --- |
| `authority_status` | Кто и насколько разрешил саму сущность/функцию? | `accepted evidence`, `prototype placeholder`, `existing proposal`, `user-requested visual candidate`, `future-only` |
| `visual_maturity` | Что реально существует как визуальный материал? | `none`, `code-drawn placeholder`, `semantic PNG placeholder`, `flattened reference`, `preview research`, `production candidate`, `production approved` |
| `priority` | Когда это проверять? | `P0`, `P1`, `P2` |
| `owner` | Кто отвечает за эту часть контракта? | `Art/world`, `Dog animation`, `Runtime/technical`, `Game Design`, `Producer/PM` |

Правила:

1. `accepted evidence` не равно `production approved`.
2. `P0` не равно «разрешено производить».
3. Красивый preview не повышает `authority_status` автоматически.
4. Действие из dog vocabulary наследует статус своей внешней строки; room/prop vocabulary не может повысить его.
5. При отсутствующем или конфликтующем authority run останавливается до генерации/записи.

### 1.1 Literal status definitions

| Status | Значение |
| --- | --- |
| `accepted evidence` | Подтверждён композиционный/семантический принцип. Показанное изображение может оставаться placeholder. |
| `prototype placeholder` | Артефакт допустим только для текущего prototype evidence. |
| `existing proposal` | Сущность есть в working Design/Art source, но не является принятым implementation scope. |
| `user-requested visual candidate` | Пользователь прямо запросил визуальное исследование; production и mechanics всё ещё не приняты. |
| `future-only` | Покрытие словаря на будущее; исключено из текущей production wave. |

---

## 2. Source hierarchy и evidence boundary

### 2.1 Обязательные источники

- `PROJECTS_RULES.md`
- `AGENTS.md`
- `docs/drive/Shelter/00_START_HERE/BOOTSTRAP_CONTEXT.md`
- `docs/drive/Shelter/00_START_HERE/000_ROLE_ART_DIRECTOR.md`
- `docs/drive/Shelter/03_DESIGN/ART_DIRECTION__CURRENT_CONTEXT.md`
- `docs/drive/Shelter/03_DESIGN/00_VISUAL_DIRECTION/D-011_Cozy_Modular_Diorama_Candidate_A.md`
- `docs/drive/Shelter/03_DESIGN/00_VISUAL_DIRECTION/D-011_Steam_Overlay_Main_Strip_v1_Rules.md`
- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Building_System_v1.md`
- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Dog_Life_Model_v1.md`
- `docs/drive/Shelter/03_DESIGN/00_VISUAL_DIRECTION/DOG_VISUAL_LANGUAGE_v1.md`
- `docs/drive/Shelter/03_DESIGN/00_VISUAL_DIRECTION/DOG_RUNTIME_AND_ANIMATION_GRAMMAR_v1.md`
- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Dog_Action_And_Activity_Vocabulary_v1.md`

### 2.2 Evidence-only sources

- `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Semantic_Asset_Pack_v1/`
- `docs/drive/Shelter/03_DESIGN/01_REFERENCES/screenshots/room_window_references/`
- `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v3/`
- `docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Art_UX_Review__First_Day_MVP_v3.md`
- flattened `D-011_steam_overlay_main_strip_v1_reference.png`

### 2.3 Rights-unverified local inventory

Ignored root `/Users/barsulka/GolandProjects/shelter/shelter/tilesets/` разрешён только как структурный reference inventory:

- topology `fill / edge / end / corner / connector`;
- принцип «сначала geometry family, затем material family»;
- иерархия whole-building silhouette;
- раздельные utility-prop footprints.

В inventory не найдено локального license grant. Запрещено копировать pixels, silhouettes, palette, textures, source files или выдавать эти packs за Shelter assets. Inventory не доказывает sand/path transitions, complete fence/yard, Bicycle, room shell или room props.

---

## 3. Ownership boundary

| Область | Владелец | Что входит | Что не входит |
| --- | --- | --- | --- |
| World composition | Art/world | ground, paths, fence/yard, building/prop staging, depth, visual hierarchy | mechanics, route causality |
| Building exterior | Art/world | silhouette, shell layers, footprint, entry cue, decoration slots | unlocks, production function |
| Room composition | Art/world | shell, station/furniture placement, occlusion, room LOD, lighting overlay | accepted room scope, task state |
| Interaction anchor | Art/world + technical contract | transform, facing, clearance, contact plane, occlusion allowance | dog clip, game event authority |
| Dog execution | Dog animation pipeline | family-compatible pose/clip, contact, dog-owned additive layers | ground/building/room ownership |
| Prop attachment | Prop/world + dog contract | prop pivot, contact class, z policy, allowed socket class | silently choosing a carry mechanic |
| Activity/mechanic | Game Design / Producer | accepted actor, purpose, conditions, result | visual invention by Art |
| State truth | Godot runtime | current task/activity/occupancy and transitions | images/manifests becoming a second simulation |
| Visual acceptance | Art Director | final silhouette/readability/contact judgment | automated validator self-approval |

Main-strip world and room props own **where and what contact is possible**. Dog animation owns **how the accepted dog family reaches and performs that contact**. Runtime remains the only authority for whether it actually happens.

---

## 4. Current asset truth

### 4.1 Playable Vertical Slice inventory

The playable Vertical Slice loads exactly six Semantic RGBA PNG placeholders:

1. Road Sign;
2. Basket Bicycle;
3. temporary Storage;
4. temporary Kitchen;
5. temporary Delivery Van Endpoint;
6. composite Food Mix / Food Bag.

Everything else relevant to this vocabulary—ground/path, Packing Table, dogs, separate resources and UI—is currently code-drawn or missing.

Companion Field atlases and forest animals are temporary technical-demo content only. They are not world/room or production-art evidence.

### 4.2 Proven vs absent

| Area | Current evidence | Exact limitation |
| --- | --- | --- |
| Transparent desktop coexistence | `accepted evidence` | Flattened/prototype composition, not modular export. |
| Current anchor sequence | `accepted evidence` | Semantics and screen grammar only. |
| Six Semantic PNG | `prototype placeholder` | Alpha cleanup, crops, pivots, states and 216/144/96 asset QA are incomplete/unrecorded. |
| Main-strip terrain | `code-drawn placeholder` | No approved standalone ground/grass/dirt/sand/path/transition assets. |
| Fence/bicycle yard | `none` | No approved kit or layout. |
| Building exteriors | `none` | Current Storage/Kitchen are semantic placeholders, not production facades. |
| Rooms/interiors | `none` | References are structural only. |
| Room furniture/props | `none` | Candidate vocabulary does not authorize production. |
| Packing Table | `code-drawn placeholder / missing semantic asset` | Classification and asset status unresolved. |
| Dog actions | `technical/prototype evidence only` | Separate dog pipeline owns them. |

### 4.3 Governance conflicts — fail closed

- cards use `APPROVED_FOR_CODEX`, while manifest uses `APPROVED_SEMANTIC_PLACEHOLDER` and other noncanonical statuses;
- Delivery Van Endpoint appears across Building/Utility interpretations;
- Packing Table / Packing Station / Workbench / possible Packing room are not one silently interchangeable class;
- draft Building System and current open-front Storage/Kitchen placeholders do not yet share an accepted interior rule;
- Garden can be read as zone, Utility cluster or Building candidate;
- Semantic crops have no completed 216/144/96 checklist;
- current alpha/contact patches are not production-clean.

This document records the conflicts and does not resolve them.

---

## 5. Main-strip world layer taxonomy

Canonical visual order for planning:

```text
00 transparent desktop boundary / empty-top reserve
10 distant/background accents (rare)
20 ground base / common contact plane
30 terrain material masks: grass, dirt, sand
40 paths, service pads and transition edges
50 local contact shadows
60 back fence / rear yard separators
70 Building exteriors and rear Utility Props
80 dogs, carried objects and active stations
90 front fence / foreground occluders
100 restrained effects and interaction cue
110 UI overlays (owned outside world art)
```

Rules:

- large transparent/empty region above remains part of the product composition;
- no opaque sky rectangle is baked into the main strip;
- base ground is continuous enough to prevent floating assets, but visually low;
- material masks must not become tall platformer cliffs;
- paths are authored broad shapes, not thin outlines;
- shadows are separate alpha layers, not white/gray baked rectangles;
- a front occluder may cover lower paws briefly, never the dog head, main action or object contact at 96 px;
- only one foreground action should dominate a local zone.

---

## 6. Ground, terrain and transition vocabulary

| ID | Asset/function | Authority | Maturity | Priority | Minimum variants |
| --- | --- | --- | --- | --- | --- |
| `world.ground.base` | Shared low contact base | `user-requested visual candidate` | `code-drawn placeholder` | P0 | fill, left/right soft end |
| `world.ground.grass_mass` | Broad grass material | `user-requested visual candidate` | `none` | P0 | fill, sparse edge |
| `world.ground.grass_tuft` | Optional accent | `user-requested visual candidate` | `none` | P1 | small/medium, mirrored |
| `world.ground.dirt_worn` | Worn work surface | `user-requested visual candidate` | `none` | P0 | fill, soft irregular edge |
| `world.ground.sand_soft` | Soft sand service material | `user-requested visual candidate` | `none` | P0 | fill, soft irregular edge |
| `world.path.main` | Primary work lane | `user-requested visual candidate` | `none` | P0 | straight, soft end, gentle bend candidate |
| `world.path.service_pad` | Local station/bicycle pad | `user-requested visual candidate` | `none` | P0 | small/medium footprint |
| `world.transition.grass_dirt` | Material transition | `user-requested visual candidate` | `none` | P0 | straight, inner/outer corner, end |
| `world.transition.grass_sand` | Material transition | `user-requested visual candidate` | `none` | P0 | straight, inner/outer corner, end |
| `world.transition.ground_path` | Path integration edge | `user-requested visual candidate` | `none` | P0 | straight, corner, soft end |
| `world.contact_shadow.local` | Grounding shadow | `user-requested visual candidate` | `none` | P0 | dog, prop/station, building footprint classes |
| `world.ground.decor_small` | Rocks/leaves/flowers | `future-only` | `none` | P2 | only after quiet-density gate |

### 6.1 Terrain rules

- At 96 px material identity comes from value/hue mass and edge rhythm, not texture.
- Transition family is designed around adjacency needs actually used by a proof scene; do not author an exhaustive blob atlas before evidence.
- Grass↔dirt↔sand are visual materials, not resources or gameplay tiles.
- No terrain cell may imply a grid, locked plot or crop mechanic.
- The dog baseline is stable across material transitions unless runtime explicitly owns elevation later.

---

## 7. Fence and behind-fence bicycle service area

| ID | Asset/function | Authority | Maturity | Priority | Notes |
| --- | --- | --- | --- | --- | --- |
| `world.fence.back_span` | Rear separator | `user-requested visual candidate` | `none` | P0 | sits behind dogs |
| `world.fence.front_span` | Foreground/occlusion span | `user-requested visual candidate` | `none` | P0 | restricted cover budget |
| `world.fence.post` | Rhythm/contact post | `user-requested visual candidate` | `none` | P0 | base pivot |
| `world.fence.end` | Clean termination | `user-requested visual candidate` | `none` | P0 | left/right |
| `world.fence.corner` | Depth turn | `user-requested visual candidate` | `none` | P0 | no perspective grid implied |
| `world.fence.gate_opening` | Neutral visual opening | `user-requested visual candidate` | `none` | P0 | not an interactive gate |
| `world.yard.bicycle_pad` | Behind-fence service footprint | `user-requested visual candidate` | `none` | P0 | separate ground mask |
| `world.yard.bicycle_parking_anchor` | Parked Bicycle transform | `user-requested visual candidate` | `none` | P0 | staging only |
| `prop.basket_bicycle` | Recognizable Bicycle prop | `prototype placeholder` | `semantic PNG placeholder` | P0 | current semantic reference only |
| `world.yard.service_clutter` | Crate/tool accents | `future-only` | `none` | P2 | must not obscure Bicycle |

The first proof shows Basket Bicycle **parked behind the fence**. It must not decide ride, sidecar, tow, platform, hitch, pushing, dog boarding or route behaviour.

---

## 8. Exterior anchors: Building vs Utility Prop discipline

### 8.1 Visual distinction

**Building**:

- rare, low, stable world anchor;
- identifiable roofline/body/entry hierarchy;
- can own a separate room/detail composition;
- must not dominate the transparent desktop region.

**Utility Prop**:

- small or medium actionable station/object;
- clear ground footprint and working side;
- no full cottage silhouette, roofline or implied interior;
- may live near/inside a Building without becoming that Building.

### 8.2 Anchor ledger

| Anchor | Proposed class | Authority | Current visual maturity | Priority | Governance note |
| --- | --- | --- | --- | --- | --- |
| Dog House | Building | `existing proposal` | `none` | P1 | Living/rest room candidate only. |
| Storage | Building anchor | `prototype placeholder` | `semantic PNG placeholder` | P1 | Current shelf-like art is not a production facade. |
| Kitchen | Building anchor | `prototype placeholder` | `semantic PNG placeholder` | P1 | Current open-front art does not settle interior policy. |
| Packing Table | Utility Prop | `existing proposal` | `code-drawn placeholder / semantic asset missing` | P1 | Packing shell/room remains a separate proposal. |
| Dispatch / archive | Building candidate | `existing proposal` | `none` | P1 | Do not merge with Van Endpoint silently. |
| Delivery Van Endpoint | Utility endpoint candidate | `prototype placeholder` | `semantic PNG placeholder` | P0 | Building-vs-Utility governance conflict remains open. |
| Learning House | Building | `existing proposal` | `none` | P2 | Classroom/library/lab are candidates, not accepted rooms. |
| Garden corner | Zone / Utility cluster candidate | `existing proposal` | `none` | P2 | Building classification remains open. |
| Road Sign | Utility / route landmark | `prototype placeholder` | `semantic PNG placeholder` | P0 | Read without English text at final scale. |
| Basket Bicycle | Utility / transport prop | `prototype placeholder` | `semantic PNG placeholder` | P0 | Choreography unresolved. |

No new exterior may be labelled `production candidate` until its class, role, rights, target LOD and Art review are explicit.

---

## 9. Room/detail kit

Room view is a separate composition, not a zoom of the strip exterior.

### 9.1 Shell layers

| ID | Layer | Owner | Authority | Priority |
| --- | --- | --- | --- | --- |
| `room.shell.floor` | Contact plane / floor finish | Art/world | `user-requested visual candidate` | P1 |
| `room.shell.back_wall` | Main room field | Art/world | `user-requested visual candidate` | P1 |
| `room.shell.side_trim_left/right` | Depth boundary | Art/world | `user-requested visual candidate` | P1 |
| `room.shell.door` | Entry cue and opening | Art/world | `existing proposal` | P1 |
| `room.shell.window` | Light/identity cue | Art/world | `user-requested visual candidate` | P1 |
| `room.shell.foreground_trim` | Controlled occluder | Art/world | `user-requested visual candidate` | P1 |
| `room.shell.light_overlay` | Calm light state | Art/world | `user-requested visual candidate` | P1 |
| `room.shell.contact_shadow` | Dog/prop grounding | Art/world | `user-requested visual candidate` | P1 |

### 9.2 Functional layers

| ID | Layer | Function | Rule |
| --- | --- | --- | --- |
| `room.station.primary` | Dominant room station | One visual task focus per room composition. |
| `room.station.input` | Input placement | Separate from decorative storage. |
| `room.station.output` | Output placement | Must read without counter/UI label. |
| `room.furniture.support` | Bed, chair, shelf, table | Supports accepted interaction; does not create one. |
| `room.anchor.entry/exit` | Dog ingress/egress | External runtime decides occupancy. |
| `room.anchor.interaction` | Contact/facing target | Data/evidence, not visible marker in final art. |
| `room.slot.decor_wall` | Optional wall identity | Cannot carry required meaning at 96 px. |
| `room.slot.decor_floor` | Optional ground accent | Must preserve clear dog lane. |
| `room.slot.personal` | Dog memory/personal object | Requires accepted object/activity scope. |

### 9.3 State overlays

| Visual state | Required visual delta | Forbidden inference |
| --- | --- | --- |
| `empty` | Shell and station available; no dog/action emphasis. | Room abandoned, neglect or penalty. |
| `idle` | Occupied/calm cue, restrained secondary motion. | New needs meter or timer. |
| `busy` | One dominant work/contact beat and relevant object. | New task state machine. |
| `output` | One readable completed/output object. | Reward economy or collect-now prompt. |

These labels are visual comparison overlays. They do not create runtime enums or mechanics.

---

## 10. First room catalog — coverage only

| Room ID | Proposed composition | Dominant anchor | Supporting candidates | Authority | Priority |
| --- | --- | --- | --- | --- | --- |
| `room.dog_house.living_rest` | Calm living/rest room | bed/mat or rest place | book cushion, toy spot; rocking-chair remains a separate later candidate | `existing proposal` plus user-requested candidates | P1 |
| `room.storage.sorting` | Storage/sorting room | shelf/sort station | crate placement, clear carry lane | `existing proposal` | P1 |
| `room.kitchen.prep` | Kitchen prep/mixing room | mixing station | ingredient input, output, calm wait corner | `existing proposal` | P1 |
| `room.packing.work` | Packing composition | Packing Table Utility Prop | bag/crate placement, label/board candidate | `existing proposal` | P1 |
| `room.dispatch.archive` | Dispatch/archive candidate | dispatch board/archive surface | postcard/note slots, Van relation outside room | `existing proposal` | P1 |
| `room.learning.classroom` | Shared learning room candidate | board/table | seat/partner anchors | `existing proposal` | P2 |
| `room.learning.library` | Quiet reading room candidate | shelf/book place | cushion/seat, partner | `existing proposal` | P2 |
| `room.learning.lab` | Curiosity/lab candidate | experiment/work surface | board/tool placement | `existing proposal` | P2 |
| `room.garden.corner` | Quiet garden corner/zone | Inspiration Tree or rest anchor | toy/bowl/partner candidate | `existing proposal` | P2 |

The catalog does not accept rooms, unlocks, activities, furniture production or navigation.

---

## 11. Interaction-anchor vocabulary

Room and prop interactions remain external action/activity rows. Their status must be read literally from `STEAM_DESKTOP__Dog_Action_And_Activity_Vocabulary_v1.md` for every run.

| Anchor class | World-owned data | Dog-owned requirement | Current authority note |
| --- | --- | --- | --- |
| `entry` / `exit` | transform, facing, clear lane, threshold | approach/leave compatible base | proposed dependency only |
| `approach` | staging transform and path clearance | walk/stop/turn | accepted row required |
| `stand_contact` | contact point, facing, footprint | contact-align / station work | external status required |
| `place` / `pickup` | object target pivot, z/occlusion | pickup/place + compatible socket | external prop/action authority required |
| `seat` | seat plane, body clearance, occlusion | family-compatible sit/lie | room/activity still proposal/candidate |
| `bed` | rest plane, bounds, entry side | lie/rest compatible base | room/activity still proposal/candidate |
| `book` | book pivot, viewing angle, page-focus zone | sit/lie + look/page-focus additive | reading proposal only |
| `board` | viewing/work side, height range | look/work base | learning-room proposal only |
| `rocking_chair` | chair pivot, seat plane, chair-owned motion | sit/lie contact; dog must not animate chair | user-requested visual candidate |
| `toy` | play/contact point and clearance | accepted play action if any | candidate; no new care loop |
| `bowl` | approach/contact plane | accepted sniff/eat/drink action if any | candidate; no needs mechanic |
| `partner` | two occupancy transforms and spacing | compatible social action | proposal; never assume universal compatibility |

### 11.1 Forbidden anchor combinations

- seat/bed anchor without room occupancy authority;
- book/board/rocking-chair prop without accepted corresponding activity row;
- bowl interpreted as hunger/thirst/neglect system;
- bicycle parking anchor reused as dog riding/hitch socket;
- room furniture pivot reused as carried-object socket;
- front occluder hiding the required dog-object contact;
- one universal anchor transform for every morphology family.

---

## 12. Exact dependencies a dog-action run may consume

A dog-action or dog-room choreography run may consume only an explicit external manifest containing:

1. accepted action/activity row ID, source path, version and literal status;
2. accepted dog ID / Dog DNA evidence status, family and facing;
3. room or world-zone ID, source status and version;
4. prop/station ID, taxonomy class, visual maturity and rights/provenance status;
5. anchor ID, transform, facing, contact plane, approach side and clearance bounds;
6. allowed dog family/capability list and forbidden combinations;
7. prop socket/contact class, weight class and attach/detach policy when relevant;
8. world-owned z/occlusion mask and local shadow/contact policy;
9. target view profile and native dog height: 216 / 144 / 96;
10. runtime-owned source fields/events to observe, without duplicate simulation;
11. deterministic capture seed/state and required evidence outputs;
12. named fallback or `STOP_SCOPE_EXPANSION`.

The run may not infer a missing room, activity, reward, mechanic, prop class, dog capability or final style from a picture.

---

## 13. Production-cost interpretation of the action/activity coverage

Independent planning evidence currently counts 67 priority/status catalog IDs—25 actions, 28 activities and 14 layers—plus 22 support IDs across presets, sockets and anchors. This is **not** a 67-clip or 89-asset order.

Stage A cost hypothesis, not acceptance:

- 10 reusable base units: idle/wait, start, walk/approach, stop, physical turn, contact-align, pickup, parameterized carry, place, station-work;
- 4 P0 additive tracks;
- 4 choreography templates: approach/contact, object transfer, station work, bicycle;
- two candidate families `short_long` and `large_sturdy` imply 20 family×base compatibility passes and 8 family×layer passes, not unique clip sets per row.

Cost multipliers belong to their owner:

| Multiplier | Owner |
| --- | --- |
| DNA, parts, equipment, personality, identity QA | per dog |
| gait, turn, contact, carry/work compatibility, socket transforms | per family |
| weight, socket, attach/swing policy | per prop |
| anchors, occupancy, world response | per station/room |
| composition and timing selection | usually per activity |

Examples: reading can reuse `sit/lie + look/page-focus + book layer`; rocking-chair motion is chair-owned; approximately twelve proposed room IDs may reduce to roughly six composition templates. These estimates help prevent scope multiplication but do not accept any activity or clip.

---

## 14. 216 / 144 / 96 visual gates

### 14.1 Main strip

| Native dog height | Must read | May simplify/disappear |
| --- | --- | --- |
| 216 | terrain family, path, depth, dog identity/action, contact, main prop, exterior type | tiny scatter detail |
| 144 | broad terrain/path relation, Building vs Utility, dog action and main prop | micro material texture, small decor |
| 96 | transparent strip boundary, landmark silhouette, dog movement/action category and one large object | text, micro markings, thin furniture details |

### 14.2 Room window

The number is dog subject height inside the room capture, not full window size.

| Native dog height | Must read | May simplify/disappear |
| --- | --- | --- |
| 216 | exact contact, room function, station/furniture, occlusion, calm intent | tiny decor |
| 144 | dog action, dominant station/furniture, room identity | book/page detail, small wall items |
| 96 | occupancy and broad action category | exact paw pose and nonessential props |

### 14.3 Mandatory evidence

- full-color native captures;
- clean silhouette pass;
- hidden-label/hidden-UI pass;
- alpha/content-bounds check;
- contact/pivot/occlusion overlay;
- one assembled scene and isolated parts;
- Art-owned PASS/WARN/FAIL notes.

Validators may prove conformance; they cannot approve aesthetics.

---

## 15. Modularity, naming, layer and pivot rules

### 15.1 Proposed naming

Asset IDs:

```text
world.<domain>.<semantic>[.<variant>]
building.<semantic>.<layer>[.<variant>]
room.<semantic>.<layer>[.<variant>]
prop.<semantic>[.<variant>]
anchor.<context>.<semantic>[.<index>]
```

File naming for a future approved brief:

```text
sd_world_<domain>_<semantic>_<variant>_<view>_vNN.png
sd_building_<semantic>_<layer>_<view>_vNN.png
sd_room_<semantic>_<layer>_<view>_vNN.png
sd_anchor_<context>_<semantic>_vNN.json
```

`strip`, `room` and `qa` are distinct view profiles. Preview-run naming/retention remains PM governance until accepted.

### 15.2 Modularity rules

- use one declared canvas/baseline convention per kit;
- keep transparent padding stable across variants;
- separate shell, material overlays, props, shadows, foreground occluders and state overlays;
- do not bake dog, carried prop, text label or UI into environment art;
- share semantic identity between exterior and room, not the same resized bitmap;
- author only adjacency variants required by reviewed compositions before expanding an atlas;
- decoration slots are optional and cannot carry required gameplay meaning.

### 15.3 Pivot and footprint rules

- ground/fence/building pivots sit on an explicit contact baseline;
- Building origin uses a stable ground-contact point, not image center;
- Utility Prop exposes footprint, working side and clearance;
- room shell uses one fixed local origin; furniture exposes floor-contact pivot;
- every interaction anchor is separate data/evidence, never painted into final pixels;
- mirrored variants must declare whether pivots/facing are mirrored or independently authored;
- content bounds must remain inside alpha-safe canvas without clipped shadows/foreground trims.

### 15.4 Occlusion and shadow rules

- front fence/trim owns an explicit occlusion mask and maximum dog coverage;
- dog head, silhouette-defining back/tail and main prop contact remain visible at critical beats;
- contact shadows are calm, local and consistent in direction/softness;
- large baked white patches, full-object gray halos and detached shadows fail;
- room foreground trim cannot make a required action readable only after hiding it.

---

## 16. Proposed manifest dimensions — planning only

A future world-art run manifest should carry:

```yaml
run_id: string
profile: world_preview_sheet | strip_environment_kit | building_exterior_kit | room_window_kit | interaction_anchor_qa
status: PREVIEW_RESEARCH_ONLY | PRODUCTION_CANDIDATE | PRODUCTION_APPROVED
authority_sources: [path + version + row id + literal status]
asset_id: stable semantic id
taxonomy_class: ground | transition | fence | zone | building | utility_prop | room_shell | furniture | anchor
visual_maturity: enum
source_provenance: creator/tool/reference/rights status
view_profile: strip | room | qa
canvas_px: [w, h]
content_bounds_px: [x, y, w, h]
baseline_px: number
pivot_px: [x, y]
footprint_px: [x, y, w, h]
layer_band: semantic layer id
occlusion_policy: mask/max coverage/critical exclusions
shadow_policy: class/direction/softness/separate layer
states: [empty, idle, busy, output] when authorized
anchors: [id/type/transform/facing/clearance/contact plane]
target_dog_heights_px: [216, 144, 96]
dependencies: [asset/room/prop/action ids]
forbidden_combinations: [ids/reasons]
source_hashes: [file/hash]
qa_outputs: [contact sheet/silhouette/alpha/scale/overlay]
signoff: mechanical validation + Art visual verdict, separate
```

This manifest is evidence metadata only. It cannot become game-state authority.

---

## 17. Preview generation briefs

All outputs are created outside the repository under:

`/Users/barsulka/.codex/preview_research/shelter_world_room_rnd_2026-07-11/`

Every output and manifest must say `PREVIEW_RESEARCH_ONLY — NOT PRODUCTION ART — NO STYLE LOCK`.

### 17.1 Sheet A — Exterior Ground + Fence + Bicycle-Yard Kit

#### Exact source set

- this vocabulary §§1–8, 14–17;
- `STEAM_DESKTOP__Visual_Production_Roadmap_v1.md` §§2–6, 9–12;
- D-011 Candidate A and Main Strip Rules;
- `DOG_VISUAL_LANGUAGE_v1.md` only for scale/readability hierarchy;
- Semantic Asset Pack README/cards for Road Sign and Basket Bicycle semantics only;
- First Day v3 screenshots as evidence under `EVIDENCE_READ_POLICY`;
- ignored `tilesets/` only as nonvisual topology checklist; no pixels/style/palette may be copied.

#### Exact prompt brief

The following is the semantic brief for the final sheet, **not one mega-prompt**. Execute it as bounded source generations:

1. `A1 ground-family master` — ground base, grass, dirt, sand, path and required transitions only;
2. `A2 fence/yard-family master` — back/front spans, post/end/corner/opening and service-yard/pad only;
3. `A3 contact/decor master` — separate local contact-shadow classes and only minimal quiet accents;
4. deterministically assemble the final contact sheet from separated masters.

Road Sign, Basket Bicycle and neutral dog are deterministic existing-reference overlays or neutral silhouette proxies, never regenerated/baked into the masters. Current Road Sign/Basket Bicycle PNGs are gate-exempt semantic references, not alpha-clean Sheet-A parts: both include broad partial-alpha/ground patches, and Road Sign includes English text. Use a blank-board/Bicycle silhouette proxy in no-text assembled evidence or keep each reference isolated with an explicit exemption; exclude them from the generated-parts alpha PASS denominator and never claim their existing alpha/text passed. Derive 216/144/96 from one assembled master, not three generations. Prefer true alpha; otherwise use one declared flat neutral matte across all sources, never fake checkerboard/black/off-white or mixed mattes.

> Create one preview-only visual R&D sheet for Shelter Steam/Desktop exterior world-layer system. This is not production art and not a final style lock. Use warm, calm, handmade 2D side-view language compatible with D-011, with large clean shapes and low detail. Show: (1) isolated kit row with alpha-safe ground base, grass mass/tufts, worn dirt, soft sand, simple work path, broad transition edges, fence back segment, fence front/occluder segment, post, end, corner, neutral gate-opening segment, bicycle service pad and separate contact-shadow layer; (2) assembled bottom-hugging scene with large empty/transparent space above, a clearly separated behind-fence yard and Basket Bicycle parked behind the fence; Road Sign and one neutral dog silhouette only as scale references; (3) three reductions labeled outside art: 216, 144, 96 px. Keep Bicycle parked—do not show riding, towing, sidecar, hitch or new mechanic. No buildings beyond scale silhouette, no UI, no readable text inside art, no ads, no horror, no fantasy village, no thick baked white ground patches, no copied third-party tiles, no final palette claim. Parts separated and unclipped.

#### Required outputs

- `sheet_a_exterior_ground_fence_bicycle_yard_attemptNN.png`;
- isolated alpha-safe parts sheet;
- assembled scene;
- 216/144/96 readability sheet;
- silhouette/occlusion sheet;
- prompt/source log and QA notes;
- explicit PASS/WARN/FAIL per gate.

#### Sheet A gates

1. Large empty/transparent desktop region remains credible.
2. Grass/dirt/sand/path read as broad distinct masses without text.
3. Required transition edges do not look like pasted rectangles or platformer cliffs.
4. Fence back/front order is unambiguous; front overlap stays within lower-body budget.
5. Basket Bicycle clearly sits behind the fence and implies only parking.
6. Dog and Road Sign are scale references, not new character/asset designs.
7. All generated masters/proxies are separated, baseline-aligned and unclipped, with either true clean alpha or one consistently declared neutral matte; isolated gate-exempt Semantic references make no alpha/text PASS claim.
8. At 96 px world boundary, path, fence/yard relation and Bicycle remain readable.
9. No source with unknown rights is reproduced.

#### Convergence rule

- `PASS` or reviewable `WARN`: record failures, then Sheet B may be requested as a separate run.
- Root `FAIL`: stop Sheet B and return evidence. Root failures include copied/derivative third-party art, inability to separate layers, bicycle choreography invention, unreadable yard at 96, or opaque world block that breaks desktop coexistence.

### 17.2 Sheet B — Building Exterior-to-Room Cutaway Kit

Sheet B is conditional on Sheet A reaching at least reviewable WARN/PASS. It compares Kitchen mixing room vs Dog House personal room at the same reusable shell logic, camera and dog scale. It does not select executable room scope; rocking chair stays outside this first room proof.

#### Exact source set

- this vocabulary §§1–5, 8–16;
- `STEAM_DESKTOP__Visual_Production_Roadmap_v1.md` §§7–12;
- `STEAM_DESKTOP__Building_System_v1.md` as draft/proposed structure;
- `STEAM_DESKTOP__Dog_Life_Model_v1.md` as proposed life-language boundary;
- `STEAM_DESKTOP__Dog_Action_And_Activity_Vocabulary_v1.md` with literal per-row statuses;
- `docs/drive/Shelter/03_DESIGN/01_REFERENCES/screenshots/room_window_references/README.md` and four current images for structure only;
- Semantic Asset Pack for temporary Storage/Kitchen/Packing/Van semantics only.

#### Exact prompt brief

The final semantic sheet is not one mega-generation. Generate Dog House and Kitchen as separate bounded pair-runs against the same declared camera/shell/dog-scale constraints; keep reusable shell parts separate; composite state overlays, neutral dog silhouettes and labels deterministically afterward.

> Create one preview-only visual R&D sheet for Shelter Steam/Desktop building exterior-to-room kit. Not production art/final style/room implementation. Show three coordinated rows: (1) low strip-scale Building exteriors for Dog House and Kitchen plus Utility Prop comparisons Packing Table and Delivery Van Endpoint; Buildings rare/low, props must not become houses; (2) separate room-window kit: reusable floor, back wall, side-wall trims, door, window, foreground trim, lighting overlay, station footprint, furniture/decoration slots, all separated; (3) two example cutaways at the same camera, shell logic and dog scale: Dog House living/rest room with bed/mat, reading cushion/book and toy spot; Kitchen room with ingredient input, mixing station, output and calm wait corner. For Kitchen only, show empty/idle/busy/output as overlay examples over unchanged shell. Dog House is structural occupancy/rest preview only and has no output semantics. Use neutral dog silhouettes only to demonstrate entry, occupancy, seat/bed/book/station/placement anchors. Keep rocking chair outside this first proof. Room view is a separate composition, not zoomed strip sprite. Labels outside art only. No hex grid, locked rooms, research/unlock UI, horror/gothic palette, human-like dog poses, needs/hunger/energy mechanics, crowded decor, production approval claim.

#### Required outputs

- `sheet_b_exterior_to_room_cutaway_attemptNN.png`;
- separated exterior/room kit;
- Building-vs-Utility comparison;
- two example cutaways;
- 216/144/96 dog-height readability sheet;
- anchor/contact/occlusion overlay;
- prompt/source log and QA notes.

#### Sheet B gates

1. Building exteriors stay low and distinguishable; Utility Props do not become cottages.
2. Room view reads as a separate composition, not enlarged strip art.
3. Shell layers can be reused while Dog House and Kitchen remain semantically distinct.
4. One dominant station/action focus survives at 144; occupancy/broad action survives at 96.
5. Dog lane, contact plane and entry/interaction anchors are physically plausible.
6. Rocking chair is excluded from the first proof; book/toy/bowl do not create mechanics.
7. Kitchen `empty/idle/busy/output` reuse the shell and remain visual overlays only; Dog House shows occupancy/rest structure and no invented output.
8. No borrowed horror/grid/unlock/UI language enters Shelter.

---

## 18. Deterministic validation vs visual QA

### Validators may check

- files, dimensions, hashes and source log existence;
- alpha channel, transparent padding and content bounds;
- stable IDs, duplicate names and manifest completeness;
- baseline/pivot/footprint presence;
- required layer/state/anchor entries;
- rights status not missing for production profiles;
- required 216/144/96 captures and overlays;
- unknown authority/status fails closed.

### Only Art review may decide

- whether material transitions feel coherent;
- whether a Building/Utility silhouette reads correctly;
- whether fence depth is calm rather than obstructive;
- whether dog/prop contact and weight look believable;
- whether room composition is dog-first;
- whether identity, warmth, restraint and visual continuity pass.

---

## 19. P0 / P1 / P2 production order

| Wave | Coverage | Dependency | Exit gate |
| --- | --- | --- | --- |
| P0 | status map, ground/transitions, path, fence/yard, parked Bicycle, Sheet A | current sources + preview authority | Sheet A Art review at least reviewable WARN/PASS; no root contract failure |
| P1 | Building-vs-Utility comparison, room shell, Dog House/Kitchen examples, interaction anchors, Sheet B | P0 scale/contact findings + governance routing | Sheet B review + measured reuse/correction cost; no mechanics inferred |
| P2 | production style/material lock, production kits, expanded rooms/decor, import/performance | Producer/User production decision + rights + technical brief | explicit production approval and platform validation |

Day 2 may proceed in parallel with documents, preview runs and QA. Production replacement, room implementation, taxonomy changes and bicycle choreography must wait.

---

## 20. What must not enter production yet

- any Sheet A/B output;
- ignored root tileset pixels/vectors/sources or their style/palette;
- Semantic PNGs re-labelled as production facades;
- final ground atlas before adjacency evidence;
- interactive fence/gate or permanent yard layout;
- ride/tow/sidecar/platform/hitch Bicycle decision;
- room-window runtime or navigation;
- room activities whose external rows are not accepted;
- all-room asset library or all-family dog interactions;
- final Building/Utility classification for Dispatch, Packing or Garden;
- readable English text as a small-scale visual channel;
- needs, hunger, energy, neglect, reward or unlock UI;
- final style/palette/material claim;
- any validator-generated aesthetic approval.

---

## 21. Open decisions and blockers

### Producer/User

- accept or reject Sheet A as first visual R&D proof;
- decide later whether any P1 room becomes executable scope;
- resolve whether Packing/Dispatch receive Building shells;
- resolve Garden product-facing class;
- choose timing of production-style lock.

### PM/governance

- reconcile card↔manifest statuses;
- define preview run naming/retention policy;
- preserve history/evidence vs Knowledge links;
- record owner of future production write scope.

### Art Director

- after evidence: ground projection, transition softness, fence height/occlusion budget;
- after evidence: exterior family, room-shell relation and shadow grammar;
- approve visual PASS/WARN/FAIL; previews cannot self-promote.

### Game Design

- accept exact room/activity rows and actor/capability eligibility;
- settle bicycle relationship only when product scope requires it;
- confirm which props/stations have gameplay authority.

### Technical

- only after brief: import/slicing, z implementation, manifest schema, room rendering and performance.

Current blockers to production: no style lock, no production-ready world/room assets, unresolved taxonomy/status conflicts, no rights for ignored packs, no reviewed Sheet A/B, no accepted room implementation scope.

---

## 22. Knowledge-GC and changelog

Classification:

- this document — proposed Knowledge / visual planning reference;
- future Sheet A/B — History/evidence until explicitly promoted;
- First Day v3 and Semantic Pack — evidence/prototype registry;
- ignored `tilesets/` — local rights-unverified reference inventory only.

No Current Memory, product contract, runtime, Semantic Asset Pack or Git governance file is changed by this wave.

### 2026-07-11 — proposed v1 created

- Added world/ground/fence/yard/exterior/room vocabulary.
- Separated authority, visual maturity, priority and ownership.
- Added exact Sheet A and conditional Sheet B briefs.
- Added dog/world interaction dependencies and fail-closed rules.
- Recorded actual asset inventory, cost interpretation and governance blockers.
