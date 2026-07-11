# STEAM_DESKTOP — Dog Animation Clip And Binding Contract v1

Дата: 2026-07-11
Последнее обновление: 2026-07-12
Статус: **proposed technical contract / no implementation authorization**
Владелец: Codex / Technical Animation
Продукт: Shelter Steam/Desktop, Godot 4
Назначение: связать game-first dog action/activity vocabulary с переиспользуемыми clip, layer, choreography, prop/room anchor и runtime-state binding без выбора production pipeline.

---

## 0. Technical verdict

Полный player-visible dog vocabulary технически можно покрывать без модели `dog × action = unique clip`, если сохраняются четыре уровня:

```text
accepted gameplay meaning and runtime state
-> logical action/activity choreography
-> reusable base clips + bounded layers + interaction binding
-> family/envelope implementation and per-dog identity offsets
```

Но repository evidence пока доказывает только узкий prototype baseline:

- `Node2D` с runtime-created `Polygon2D` / `Line2D` parts;
- base-pose clips, созданные в коде для `AnimationPlayer`;
- runtime Dog DNA / morphology / personality modifiers;
- один prototype `MouthHarnessSocket`, object visibility/swing и fixed debug phrase;
- три placeholder morphology examples и короткие 216/144/96 stress observations.

Не доказаны как production pipeline:

- authored `Sprite2D` cutout import и долговечный part/pivot workflow;
- `Skeleton2D` / `Bone2D`, weighted deformation и retargeting;
- `AnimationTree`, IK, external animation tool или пять production rig families;
- approved current Dachshund/Labrador dog action assets;
- production foot locking, station/room anchor system или full action library.

Количественная реальность proposed vocabulary:

| Scope | Count | Technical meaning |
| --- | ---: | --- |
| Catalog IDs | 67 | 25 actions, 28 activities, 14 layers. Это semantic coverage, не clip count. |
| Priority | P0 29 / P1 27 / P2 11 | Priority задаёт порядок coverage, но не принимает scope. |
| Source status | accepted current 21 / existing proposal 33 / user candidate 10 / future-only 3 | Каждая строка сохраняет свой status; общий proposed документ не повышает его. |
| Support IDs | 22 | 5 motion presets, 6 sockets, 11 anchors. |
| Total vocabulary IDs | 89 | Нельзя преобразовать в 89 animation assets. |
| Production-bound P0 | **0 / 29** | Ни одна P0 row пока не имеет одновременно approved current-dog art, production clip/import binding, runtime evidence и Art/Technical sign-off. |
| P0 debug analogs | **7 / 29** | Семь runtime-created spike clips дают только приблизительные debug analogs; они не являются bindings. |
| P0 without any clip analog | **22 / 29** | Для остальных P0 rows в stable HEAD нет даже debug clip analog. |

Существующие семь debug `AnimationPlayer` clip names не меняют `0/29`: они являются qualified prototype evidence, а не current-dog production bindings. В stable HEAD нет authored dog animation library в `.tres`, `.anim` или `.res`. `0/29` означает отсутствие visual production bindings, а не отсутствие gameplay: semantic task/runtime causality и V3 prototype evidence существуют.

---

## 1. Authority, scope and non-authorization

### 1.1 Authority order

Этот contract читается только вместе со следующими источниками и не заменяет их:

1. `PROJECTS_RULES.md`, `AGENTS.md`, `steam/AGENTS.md`, `steam/README.md`.
2. Accepted ADR, прежде всего ADR-0001 и ADR-0002.
3. Current technical status/context.
4. Accepted Task Flow / Object / Vertical Slice contracts и D-022.
5. `STEAM_DESKTOP__Dog_Action_And_Activity_Vocabulary_v1.md` с status каждой конкретной row.
6. Dog Life Model, Building System, Dog Visual Language и Runtime/Animation Grammar как draft/proposal sources там, где они именно так помечены.
7. Current code/spike files только как implementation evidence, не как gameplay authority.

`STEAM_DESKTOP__Dog_Action_And_Activity_Vocabulary_v1.md` имеет статус `proposed v1 / Game Design vocabulary, not accepted production asset list`. Его semantic IDs canonical только внутри proposed v1. Для executable binding требуется одновременно:

- row со статусом `accepted current` **или** отдельное принятое решение для выбранной proposed row;
- accepted actor/task/object/room authority из первичного contract;
- approved Art input и Technical binding evidence;
- отдельный accepted Codex brief перед implementation.

### 1.2 Runtime authority

По ADR-0002 Godot runtime остаётся единственным authority для task, object, resource, order, save/snapshot и connector state.

Animation system может:

- наблюдать authoritative state;
- выбрать visual composition;
- сообщить marker `ready` / `ack` в ожидаемой phase;
- показать attach, contact, loop, detach и completion;
- дать runtime trace для QA.

Animation system не может:

- самостоятельно создать resource или prop;
- сменить task/status/order;
- начислить reward, quality, habit, research или relationship;
- выбрать dog role/activity без accepted runtime decision;
- вести вторую simulation в manifest, skill или animation graph.

### 1.3 Out of scope

Этот документ не:

- принимает art style, final silhouettes, palette или asset prompts;
- выбирает production rig, skeleton families, authoring tool или import path;
- принимает P1/P2 rooms, needs, social systems или mechanics;
- разрешает coding, runtime/schema change, asset generation или broad Vertical Slice replacement;
- создаёт ADR или implementation brief;
- утверждает performance budget без target hardware и measured captures.

---

## 2. Terms and separation of concerns

| Term | Contract meaning | Must not be confused with |
| --- | --- | --- |
| `activity` | Player-facing meaning: что собака делает и зачем. | Один authored clip. |
| `action` | Минимальная visible phrase: walk, align, pickup, carry, sit. | Task или reward. |
| `task` | Authoritative runtime work unit: `TripTask`, `PackTask` и т. п. | Activity library. |
| `state/status` | Current runtime condition, например `moving_to_source`, `in_progress`. | Clip filename. |
| `phase` | Ordered sub-step одной choreography. | Новый task/status. |
| `logical clip` | Reusable motion intent, independent of dog/family/file path. | Production asset acceptance. |
| `implementation clip` | Godot animation resource/path for one compatible envelope/facing. | Gameplay authority. |
| `layer` | Bounded modifier: effort, look, ears, tail, object, intent, micro. | Independent mechanic. |
| `marker` | Timed visual synchronization point. | Direct task/resource mutation. |
| `socket` | Dog-relative attachment/contact point. | World placement anchor. |
| `anchor` | World/prop/room-relative placement/occupancy/contact contract. | Dog bone or body part. |
| `family/envelope` | Technical compatibility range proven by captures. | Breed label, role or personality. |
| `binding` | Explicit mapping from accepted runtime selector to composition/clip/interaction. | Второй state machine. |

---

## 3. Current repository inventory and evidence boundary

### 3.1 Current dog rig/runtime

| Evidence | What exists | What it proves | What it does not prove |
| --- | --- | --- | --- |
| `steam/scripts/tech_demos/dog_rig_spike.gd` | Runtime-created modular `Node2D` hierarchy with `Polygon2D`/`Line2D`, `AnimationPlayer`, Dog DNA dimensions, overlays and `MouthHarnessSocket`. | A staged hybrid split is mechanically possible in a bounded debug scene. | Production art import, current dog assets, foot lock, rooms, station anchors or shipping performance. |
| Actual spike clips | Seven animations are created at runtime in GDScript: `idle_neutral`, `head_look`, `walk_empty`, `walk_carry_medium`, `pickup_pose`, `deliver_pose`, `tail_wag`. | Seven reusable debug intents can coexist with runtime morphology/personality/socket layers. | Authored `.tres`/`.anim`/`.res` library, seven accepted actions or seven production bindings. |
| `steam/scripts/tech_demos/companion_field_demo.gd` | Drawn bridge with hard-coded phrase/clip/socket labels and food-bag visualization. | A state-to-visible-pose debug bridge is understandable. | Actual reusable `AnimationPlayer` library or production binding. |
| Stable-HEAD `steam/scripts/prototypes/vertical_slice/vertical_slice_demo.gd` | Authoritative task statuses and `dog_state` phrases plus x-coordinate `lerpf`, primitive draw/bob/tail/object-token presentation. | Current semantic runtime selectors and task causality exist. | Any `AnimationPlayer`/`AnimationTree`, action manifest, generic socket binding, authored clip library or production animation architecture. |
| `steam/resources/tech_demos/dog_dna_examples.json` | Three working prototype morphology/personality presets. | A small technical stress corpus. | Canonical production Dog DNA schema, real-dog likeness or production families. |

`DOG_DNA_SCHEMA_v0.md` and `dog_dna_examples.json` remain `WORKING_DRAFT_TECHNICAL_PROOF`. Any production schema/version/compatibility policy requires a separate accepted technical decision; this contract does not promote them.

Inventory claims in this section are based on stable HEAD `b41db7af95167add893d20499a2ab5f02af9b6d3`. Incomplete/moving Day 2 working-tree files are excluded and must not be cited as finished animation, room or connector evidence. Accepted D-022 semantics remain authority, but their presence does not prove a finished visual binding.

`pickup_pose`, `deliver_pose` and `MouthHarnessSocket` are one fixed-timeline Food Bag visibility/attachment proof. They do not implement marker-driven generic contact/attach/detach, crate/heavy carry, placement causality or gameplay `DeliveryTask`.

Evidence classification must remain explicit:

| Evidence class | Meaning |
| --- | --- |
| `PRODUCTION_BINDING` | Accepted semantic row + approved current-dog/prop Art + actual runtime selection/playback/contact evidence + required sign-offs. Current count: `0/29`. |
| `RESEARCH_BINDING` | Bounded experimental binding with retained evidence; never production by implication. |
| `DEBUG_ANALOG_ONLY` | Similar debug motion/label exists but is not an action binding. Current P0 clip-evidence count: `7/29`. |
| `SEMANTIC_RUNTIME_ONLY` | Task/state causality exists without clip binding, as in stable-HEAD VS. This is a separate evidence dimension, not a fourth partition of the 29 P0 clip rows. |
| `ABSENT` | No production binding or debug clip analog. Current P0 clip-evidence count: `22/29`. |

### 3.2 Current dog and prop assets

| Asset area | Current truth | Consequence |
| --- | --- | --- |
| Dachshund action card | `NEEDED`; no approved current dog action asset. | No authored Stage A Dachshund clip may be called Art-approved. |
| Labrador action card | `NEEDED`; rejected SVGs are not evidence. | No authored Stage A Labrador clip may be called Art-approved. |
| Basket Bicycle | Approved semantic placeholder exists. | Vehicle phrase may be staged, but exact dog contact/propulsion remains unresolved. |
| Packing Table | Card is `NEEDED`; no local approved PNG. | Labrador PackTask Art-backed station proof is blocked on the station source/anchor contract. |
| Crates, Protein Packet, Packaging Bag, Food Mix, Food Bag | Gameplay meaning exists. | Exact weight, carry mode, socket and placement bindings are not yet accepted. |
| Comfortable Slippers | Existing equipment/reward meaning. | Must be four worn-foot overlays or an explicitly approved equivalent, never a mouth-held prop or separate unique locomotion library. |

### 3.3 Qualified baseline versus research lanes

| Lane | Current status | Permitted claim |
| --- | --- | --- |
| Debug hybrid: Node2D/Polygon2D/Line2D + AnimationPlayer + runtime modifiers | Qualified prototype baseline | Reference continuity and state/layer split. |
| Node2D/Sprite2D cutout + AnimationPlayer | `RESEARCH_ONLY / EXPERIMENTAL_NOT_APPROVED` | Bounded Art-backed Stage A candidate after prerequisites. |
| Skeleton2D/Bone2D | Research-only common-corpus comparison | A/B evidence only; no migration or production selection. |
| Frame atlas / placeholder stills | Prototype semantic evidence | May prove meaning, not modular production reuse. |

`AnimationTree`, IK, five rig families, Spine/external dependencies and a broad runtime rewrite remain outside this contract.

---

## 4. Composition contract

### 4.1 Layer stack

```text
Base Pose
+ Locomotion
+ Effort
+ Head / Ear / Tail
+ Object
+ Intent
+ Micro
= final visual pose
```

| Layer | Owns | Typical input | Suppression/override rule |
| --- | --- | --- | --- |
| Base Pose | Stand, sit, lie, carry stance, station stance, seated pose. | Logical action/phase. | One dominant base pose at a time. |
| Locomotion | Start, walk, stop, physical turn, slow/carry gait. | Target velocity/facing and action. | Disabled or station-local while locked to contact/seat. |
| Effort | Empty/light/medium/heavy/pull/push resistance. | Accepted prop mode/weight. | Cannot infer weight from breed or artwork. |
| Head/Ear/Tail | Gaze, blink, ear secondary motion, calm tail. | Intent, personality, family compatibility. | Contact precision and task intent win; quiet or absent at 96 when noisy. |
| Object | Attached prop transform, swing, worn equipment. | Runtime object state + prop binding. | Runtime owns object existence/state; no generic socket substitution. |
| Intent | Going to task, focused work, careful contact, relaxed/social. | Accepted activity/task/state. | Cannot grant role, quality, reward or mechanic. |
| Micro | Paw adjust, tiny pause, short allowed reaction. | Phase mask and free time. | Never interrupts protected attach/detach, carry, station work or player wait. |

### 4.2 Resolution order

Every selection must execute in this order:

1. Resolve accepted gameplay/runtime authority.
2. Resolve actor, role and capability eligibility.
3. Resolve task/status/state and exact activity/action phase.
4. Resolve prop or room/station interaction contract.
5. Resolve logical clip/choreography.
6. Resolve family/envelope implementation and facing policy.
7. Apply identity/personality offsets and allowed layers.
8. Validate marker order, interrupt policy and fallback.
9. Capture evidence; do not infer Art acceptance from mechanical PASS.

If steps 1–6 fail, required animation does not fall back to an unrelated generic clip.

### 4.3 Layer conflict rules

- Task/interaction intent outranks personality and ambient life layers.
- `carry` suppresses shake, play bow, happy hop and socket-breaking head motion.
- Precision contact suppresses look-away, large ear/tail accents and random paw movement.
- Heavy effort cannot be produced by increasing bob alone; the prop binding must authorize weight/contact.
- Worn equipment follows body/facing but remains separate from identity markings.
- A dog-specific offset may alter amplitude/timing within the compatibility envelope; it may not repair wrong topology, missing contact or an incompatible prop.

---

## 5. Stage A reusable unit hypothesis

Stage A is a cost/proof hypothesis, not an accepted asset list. The proposed 29 P0 IDs should initially reduce to ten reusable base units, four P0 additive tracks and four choreography templates.

### 5.1 Ten reusable base units

| Logical unit | Proposed technical clip ID | Vocabulary coverage | Notes |
| --- | --- | --- | --- |
| 1. Idle / wait | `dog.clip.base.idle_wait.v1` | `dog.action.idle.neutral`, `dog.action.wait.calm` | One base may expose focused/relaxed intent variants; waiting reason remains runtime data. |
| 2. Start | `dog.clip.transition.start.v1` | `dog.action.locomotion.start` | Candidate row; requires explicit gameplay acceptance before executable binding. |
| 3. Walk / approach | `dog.clip.locomotion.walk_approach.v1` | `walk_empty`, `approach_target` | Approach adds target gaze and speed curve, not a unique per-task clip. |
| 4. Stop | `dog.clip.transition.stop.v1` | `dog.action.locomotion.stop` | Candidate row; cannot be replaced by instant velocity zero for evidence. |
| 5. Physical turn | `dog.clip.transition.turn_physical.v1` | `dog.action.locomotion.turn` | Candidate row; distinct from render mirroring. |
| 6. Contact align | `dog.clip.interaction.contact_align.v1` | `dog.action.interaction.contact_align` | Uses target anchor + paw adjust; per-family contact correction may be required. |
| 7. Pickup | `dog.clip.interaction.pickup.v1` | `dog.action.object.pickup_attach`, unload/carry/load phrases | Parameterized by source height, mode and socket; protected contact window. |
| 8. Parameterized carry | `dog.clip.locomotion.carry.v1` | light/medium/heavy and current carry activities | Effort and socket are binding data; heavy/pull/push may require separate family override. |
| 9. Place | `dog.clip.interaction.place.v1` | `dog.action.object.place_detach`, load/place phrases | Parameterized by placement height and prop mode; protected detach window. |
| 10. Station work | `dog.clip.station.work.v1` | CookTask, PackTask, careful Labrador PackTask | Shared stance/loop with station-specific contact variant and intent layer. |

These are logical units. One unit may have one or more implementation clips where an evidence-backed envelope or contact variant requires it.

### 5.2 Four P0 additive tracks

| Layer ID | Coverage | Rule |
| --- | --- | --- |
| `dog.layer.head.look_target` | Task/object/station focus. | Must not point away during contact. |
| `dog.layer.face.blink` | Quiet life. | May become visually negligible at 96. |
| `dog.layer.tail.calm_sway` | Calm baseline. | Reduced/frozen by effort and precision task intent. |
| `dog.layer.paw.adjust` | Final alignment. | Phase-owned, not random idle fidget. |

Other proposed layers remain later coverage or measured family/personality offsets; they do not multiply Stage A base units.

### 5.3 Four choreography templates

| Template | Ordered shape | Current uses | Special risk |
| --- | --- | --- | --- |
| `choreo.approach_contact.v1` | orient -> start -> walk -> stop -> align -> contact | station, prop, partner, room prop approach | Foot slide and early target-state change. |
| `choreo.object_transfer.v1` | approach/contact -> pickup/attach -> carry loop -> target contact -> place/detach -> exit | unload, ingredient carry, carry to Packing, load Van | Prop lifecycle, socket/mode and cancellation. |
| `choreo.station_work.v1` | approach/contact -> station lock -> work loop -> loop exit -> outcome acknowledgment -> release/exit | Kitchen, ordinary PackTask, Day 2 careful PackTask | Station anchor, output timing and task-event authority. |
| `choreo.bicycle_trip.v1` | approach/prep -> vehicle contact -> departure -> away -> return -> release/unload-or-wait | Dachshund TripTask | Exact mount/pedal/hitch/combined motion unresolved; separate high-risk spike. |

`read_book` and `rocking_chair_rest` are not new monolithic clip libraries:

- read = accepted sit/lie base + target look/page-focus + book prop layer + optional prop-owned page turn;
- rocking-chair rest = accepted sit/lie family variant + chair seat/contact anchor + relaxed layers; chair/world owns rocking motion.

---

## 6. Action classification

### 6.1 Reusable base/layer compositions

The following vocabulary families should normally resolve through reusable bases and bounded layers rather than unique dog-specific animation:

- idle, calm wait, start, stop, physical turn, walk empty;
- approach target, contact align, inspect;
- light/medium carry and effort variants within a proven envelope;
- sit, lie, sleep loop;
- head look, blink, calm tail, ear secondary motion, tiny pause and paw adjust;
- personality motion presets as timing/amplitude masks only;
- notice feedback, calm greet and support where accepted anchors exist.

### 6.2 Required choreographed multi-phase bindings

The following meanings require an ordered phase record even when phases reuse base clips:

| Semantic meaning | Minimum phases | Protected boundary |
| --- | --- | --- |
| `pickup_attach` | approach -> align -> contact -> attach acknowledgment -> carry-ready | contact start through confirmed attach. |
| `place_detach` | target approach -> align -> place contact -> detach acknowledgment -> release | place contact through confirmed detach. |
| unload/carry/load | source transfer -> carry loop -> target transfer -> exit | both attachment windows; no task switch while carried. |
| station work | approach -> station lock -> loop -> loop-exit -> outcome acknowledgment -> release | station lock through safe loop boundary; output stays runtime-owned. |
| bicycle travel | prep -> vehicle contact -> departure -> away -> return -> release | contact mode and departure/return synchronization. |
| room enter/exit | transition approach -> occupancy request/ack -> room locomotion; reverse for exit | occupancy transition. |
| seat/bed/read/chair | approach -> align -> seat/lie attach -> loop -> get-up/detach -> exit | seat/bed attach/detach. |

### 6.3 Family/envelope overrides

A family/envelope implementation override is required only when measured evidence shows the shared logical unit cannot preserve:

- paw/ground contact or step reach;
- body clearance at a seat, bed, station or prop;
- muzzle/chest/paw/hitch socket contact;
- readable silhouette and facing transition;
- object weight/contact at 216/144/96;
- stable correction cost inside the declared compatibility range.

An override must name the failed base, actor envelope, prop/station, facing and evidence. A breed label alone is not sufficient.

### 6.4 Dog-specific identity/personality offsets

Per-dog data may modify, within an approved envelope:

- stride amplitude and cadence;
- head/ear/tail timing and bounded amplitude;
- idle balance, look duration and allowed micro cadence;
- equipment visibility and identity markings;
- socket transforms explicitly proven for the dog.

Per-dog data must not create a unique full action library or grant task, role, carry capability, reward or mechanic.

---

## 7. Facing, mirroring and physical turn

### 7.1 Three independent concepts

| Concept | Meaning |
| --- | --- |
| `facing` | Current logical direction in runtime/world space. |
| `mirror policy` | Whether one authored facing may be rendered safely as the other. |
| `physical turn` | Visible transition that changes facing; it is an action, not a negative scale operation. |

`dog.action.locomotion.turn` must never be accepted merely because `scale.x` flips. Conversely, a physical turn clip does not require every locomotion frame to be authored twice if mirroring passes all gates.

Current stable-HEAD evidence has no runtime facing sign, mirror policy or physical-turn phrase. The dog-rig spike, companion bridge and Vertical Slice presentation are fixed right-facing. Because VS changes only x position while keeping the drawn head/muzzle on +x, a leftward departure can read as a backward slide. Stage A therefore needs three separate proofs: authoritative facing sign, mirror compatibility for identity/equipment/sockets, and a visible physical-turn transition.

### 7.2 Facing policy values

| Value | Use |
| --- | --- |
| `authored_both` | Separate left/right implementation because asymmetry/contact cannot mirror safely. |
| `mirror_safe` | One authored facing plus deterministic transform after all gates pass. |
| `mirror_with_overlay_override` | Base body may mirror; asymmetric markings/equipment/socket/prop layers use facing-specific overlay or transform. |
| `not_applicable` | Frontal/room-only pose with no directional equivalence, explicitly justified. |

### 7.3 Asymmetry gates

Mirroring is forbidden until all applicable checks pass:

- dog markings, ears, tail, scars/identity features;
- worn equipment such as four slippers and side-specific accessories;
- text, labels, tool handedness or bicycle/vehicle side;
- socket/contact geometry and prop z-order;
- station entry side, chair/book/board geometry and occlusion;
- lighting or narrative orientation baked into source art;
- animation curves whose rotation/translation signs do not transform mechanically.

Every Stage A action requires left/right evidence or an explicit `not_applicable` record. `STOP_UNSAFE_MIRROR` applies before integration when a gate is missing or fails.

---

## 8. Marker, transition, cancellation and fallback contract

### 8.1 Marker namespace

The following are proposed technical marker IDs, not gameplay events:

| Marker | Meaning |
| --- | --- |
| `visual.phase_enter` | Visual phase began under already-authoritative runtime selection. |
| `visual.contact_begin` | Dog reached the visible contact window. |
| `visual.attach_ready` | Animation is ready for runtime-validated attachment. |
| `visual.attach_ack` | Runtime attachment state is visible/confirmed. |
| `visual.loop_enter` | Stable loop pose reached. |
| `visual.loop_boundary` | Safe repeat/exit point. |
| `visual.loop_exit` | Authored exit from loop began. |
| `visual.detach_ready` | Animation is ready for runtime-validated detach/place. |
| `visual.detach_ack` | Runtime detach/place state is visible/confirmed. |
| `visual.contact_end` | Contact lock may be released. |
| `visual.cancel_safe` | Declared safe cancellation/recovery boundary. |
| `visual.phase_complete` | Visual phrase completed; it does not complete the task itself. |

The authoritative controller may validate a marker against expected `task_id`, `status`, `phase`, `actor_id`, `object_id` and `order_id`, then perform an already-authorized transition. A marker alone never mutates state.

### 8.2 Required marker order

```text
phase_enter
-> contact_begin
-> attach_ready -> attach_ack        # only when attaching
-> loop_enter -> loop_boundary* -> loop_exit
-> detach_ready -> detach_ack        # only when detaching/placing
-> contact_end
-> cancel_safe
-> phase_complete
```

Action-specific manifests may omit inapplicable marker pairs, but may not reorder attach/detach causality.

### 8.3 Interrupt matrix

| Current phase | Interrupt rule | Recovery requirement |
| --- | --- | --- |
| idle/wait | Immediate for required task. | Start/orient transition. |
| start/walk empty | At stable foot/turn boundary. | Stop or retarget; no slide/teleport. |
| contact before attach | Exit only before protected contact or via authored back-out. | Target remains unchanged. |
| contact -> attach ack | Protected; no arbitrary cancel. | Runtime-confirmed attach or deterministic return to pre-contact. |
| attached carry loop | Task switch forbidden. | Continue to accepted placement or explicit debug recovery owned by runtime. |
| place contact -> detach ack | Protected; no arbitrary cancel. | Complete place or restore attached state without duplication/loss. |
| station loop | Exit at `loop_boundary`. | `loop_exit` -> contact release; output remains runtime-owned. |
| seat/bed/chair loop | Exit through get-up/detach. | Occupancy ack clears before locomotion. |
| micro/additive | May suppress immediately unless it owns contact adjustment. | Restore underlying base pose only. |

### 8.4 Fallback policy

| Missing element | Allowed fallback |
| --- | --- |
| Optional compatible additive layer | Suppress the layer and record warning. |
| Non-authoritative ambient activity | Remain in accepted neutral idle/wait if runtime allows. |
| Required action clip/family binding | No semantic substitution; stop binding/integration. |
| Prop mode/socket/anchor | No generic carry; stop. |
| Room/seat/bed/book/chair contract | No approximate floating pose; stop. |
| Unsafe opposite facing | Authored/overlay override required; no silent mirror. |
| Invalid runtime event/phase | Keep runtime authoritative, fail evidence, do not advance state. |
| Unproven production profile | Keep evidence labeled research-only; no promotion. |

---

## 9. Prop carry modes and socket contract

### 9.1 Interaction record

Every carried/used prop binding must declare:

```text
object_id and accepted source
weight_class
carry_or_contact_mode
dog_socket_or_contact_set
source_anchor and target_anchor
attach/detach/place marker policy
facing/mirror policy
z-order and occlusion owner
swing/rotation limits
compatible actor envelope/capability
fallback and recovery
```

### 9.2 Mode classes

| Mode | Dog contact | Typical use boundary |
| --- | --- | --- |
| `mouth_light` | `interaction.socket.mouth` | Explicitly accepted light/soft object only. Prototype `MouthHarnessSocket` is evidence, not a universal contract. |
| `chest_harness` | `interaction.socket.chest_harness` | Stable carry/work attachment after Art/Technical proof. |
| `front_paw_support` | One or more `interaction.socket.front_paws` plus grounded stance | Crate/tool/support only if the exact prop choreography is accepted. |
| `side_hitch_pull` | `interaction.socket.side_hitch` | Bicycle/cart pull with visible tension and prop response. |
| `front_contact_push` | Paw/chest contact set, no attachment assumption | Push face/resistance; prop cannot move independently. |
| `back_saddlebag` | `interaction.socket.back_saddlebag` | Side/back cargo only when silhouette and equipment policy pass. |
| `station_tool` | `interaction.socket.tool` + station anchor | Tool use owned by station choreography, not generic carry. |
| `worn_feet` | Four facing-aware foot overlays/contacts | Comfortable Slippers; never mouth/chest carry. |

Current objects remain fail-closed where the vocabulary records unresolved choices:

- crate weight/socket not accepted;
- Protein Packet and Packaging Bag mode not accepted;
- Food Mix container and socket not accepted;
- Food Bag mouth vs harness not accepted;
- bicycle mount/pedal/hitch/combined mode not accepted.

`MouthHarnessSocket` must not be generalized to crate or heavy bag. Heavy carry requires an explicitly accepted harness/front-paw/other solution.

---

## 10. Station, room and interior ownership

### 10.1 Boundary

| Dog clip/binding owns | Godot runtime owns | Ground/building/interior/prop pipeline owns |
| --- | --- | --- |
| Orient, approach, stop, body alignment. | Choosing accepted activity/task/station and authoritative occupancy/object state. | World transform, approach/exit zone, allowed facing. |
| Pose, effort, intent and dog-relative contact. | Validating marker against actor/task/status/phase/order. | Prop geometry, station asset, contact anchors and object response. |
| Phase-correct attach/detach/occupancy request. | Applying already-authorized state transition. | Navigation, collision, z-order, occlusion and room/window representation. |
| Seat/bed/read/toy/bowl execution and recovery. | Cancelling/retargeting through declared boundaries. | Seat/bed/book/toy/bowl/chair assets and world animation. |

The handshake is typed `anchor + dog contact/socket + marker`. Neither side guesses the other side from pixels.

### 10.2 Required anchor fields

Every station/room interaction record requires:

```text
building_id / room_id / station_id / prop_id as applicable
authority_status and source_refs
detail_surface_ref and room_surface_status
approach_anchor
body_or_occupancy_anchor
contact_anchor(s)
exit_anchor
occupancy_authority
occupancy_request_marker and occupancy_ack_source
rendered_presence_source
allowed_facing and mirror/asymmetry policy
body_clearance envelope
z-order / occlusion owner
world_response owner
entry, loop, exit and cancellation policy
```

### 10.3 Interaction-specific requirements

| Interaction | Dog composition | World/prop contract |
| --- | --- | --- |
| Kitchen/Packing work | approach/contact + station stance/loop + tool/paw variant | Work anchor, facing, inputs/output boundary, prop response. |
| Seat/sit | approach + align + sit/get-up | Seat root, contact, clearance, occupancy. |
| Bed/mat/lie/sleep | approach + align + lie/get-up + quiet loop | Body-length clearance, head side, facing, occupancy. |
| Read book | sit/lie + look/page-focus + optional paw contact | Book root, reading seat/desk relation, page plane/response. Page turn is prop/world-owned unless explicitly split. |
| Study board | sit/stand + look/inspect | Board view anchor and readable distance/facing. |
| Rocking chair | seated family variant + relaxed layers + attach/detach | Chair owns rocking axis/motion, collision and seat response; dog never simulates the chair. |
| Toy | inspect + accepted pickup-light or paw-contact variant | Toy-specific mode, anchor and response. |
| Bowl food/water | approach + head-down loop | Separate rim/head anchors; no hunger/thirst mechanic. |
| Partner/social | approach + greet/support/sit pose | Initiator/receiver slots, safe separation and availability. |
| Room enter/exit | locomotion/transition clip | Room transition, occupancy and strip-return anchor. |

Room IDs remain proposed/candidate until Producer/Game Design accepts an executable room slice. A valid technical anchor cannot promote the gameplay scope.

### 10.4 Stable-HEAD room implementation inventory

The current room data is `runtime_scaffold`, not a player-facing room/detail feature:

- six broad place/building records are exposed through `buildings[]` (five current strip anchors plus House of Curiosity);
- nine room records are derived (Storage, Kitchen, Packing plus six House of Curiosity rooms);
- station and dog-assignment metadata can appear in snapshots;
- no room scene, interior renderer, click/open/close path, dog entry/exit, authoritative occupancy handshake or player-facing detail surface exists;
- `implemented=true` on visible strip anchors means the anchor record is available; House of Curiosity can simultaneously be hidden and `runtime_scaffold`. Neither case proves room/detail implementation;
- metadata assignment/current_room is not proof that a dog physically occupies, enters or animates inside a room.

The accepted main-strip versus detail separation does not select the surface topology. Modal, side panel and native child window remain undecided; a native OS window would add separate platform/window-management complexity and is not implied by this contract.

There is also an unresolved Packing taxonomy conflict:

```text
Building System proposal: Packing room
Object Contract: Packing Table is a Utility Prop
stable-HEAD runtime: synthetic room.packing.soft_packing_corner inside buildings[]
```

`buildings[]` currently conflates Buildings, strip anchors and Utility Props. Until the owning contracts resolve this, Packing/Dispatch/Route must not be selected as the first room proof and dog binding must fail closed under `STOP_CONFLICTING_AUTHORITY`.

Neutral first-slice options remain alternatives, not a Technical decision:

| Option | Reuse/cost | Main technical risk |
| --- | --- | --- |
| A. Storage read-only/live detail | Smallest implementation/reuse gap. | Can collapse into an inventory panel instead of dog-first room evidence. |
| B. Kitchen live production room | Stronger dog-first value; medium cost; reuses accepted Kitchen/CookTask/inputs/Food Mix. | Requires a real surface, station anchor, occupancy and continuity evidence. |
| C. One House of Curiosity room | Medium/high cost. | Prematurely activates unaccepted research/product scope. |
| D. Dog House personal room | Strongest attachment potential; highest missing foundation. | Almost all shell, occupancy, props and activity bindings are net-new. |

Any later accepted one-room proof must demonstrate exactly:

```text
click one accepted main-strip anchor
-> open/close one detail surface
-> read live Godot state only
-> show one accurate dog presence/activity + one station
-> keep simulation running
-> prove connector evidence has no divergence
```

It may not add rooms, states, assignments, recipes, upgrades, decor, needs or window-topology policy. Preview comparisons are not runtime/occupancy authority.

---

## 11. Runtime state-to-animation mapping

### 11.1 Generic task-status adapter

| Authoritative runtime selector | Visual phrase | Constraints |
| --- | --- | --- |
| `queued` | Existing neutral/idle presentation. | No task prop or false progress. |
| `assigned` | Orient/intent, then start when runtime supplies target. | Role/capability already accepted. |
| `moving_to_source` | start -> walk/approach -> stop/contact align. | Target anchor required. |
| `in_progress` | Action-specific attach/work/vehicle/interaction phases. | Runtime task/object state remains authority. |
| `moving_to_target` | Attached carry/pull/other accepted locomotion. | No task switch while attached. |
| `completing` | Place/detach, station loop exit or contact release. | Completion event only through authoritative controller. |
| `complete` | Return to neutral or explicitly accepted short reaction. | Clip does not award reward or start next task. |
| `blocked` | Calm reason-readable wait. | No urgency/error pose or fake work. |

Current stable-HEAD `dog_state` strings in `vertical_slice_demo.gd` are adapter inputs/evidence, not a second canonical animation vocabulary. The VS visual lane is x lerp plus procedural primitive draw/bob/tail/object-token cues; it has no animation manifest, socket binding or authored clip selection. Consequently a semantic task/status match is necessary but never sufficient evidence for a clip binding.

### 11.2 Current chain mappings

| Task/runtime phrase | Proposed semantic binding | Choreography |
| --- | --- | --- |
| `TripTask`: moving to/preparing transport | `approach_target` + `contact_align` | approach/contact Bicycle/Road Sign. |
| `TripTask`: leaving/away/returning | `dog.action.vehicle.travel_with_bicycle` | `choreo.bicycle_trip.v1`; exact vehicle contact blocked. |
| `TripTask`: completing | wait or accepted release/unload handoff | No implied cargo transfer before runtime payload event. |
| `UnloadTask` | `dog.activity.delivery.help_unload_bicycle` | object-transfer per crate. |
| `CarryTask` to Kitchen/Packing | corresponding accepted delivery activity | object-transfer, one physical resource per task. |
| `CookTask` | `dog.activity.delivery.help_kitchen` | station-work at Kitchen. |
| ordinary `PackTask` | `dog.activity.delivery.pack_food_bag` | station-work at Packing Table. |
| Day 2 `PackTask` with Labrador | `dog.activity.delivery.pack_carefully_labrador` | Same PackTask/base loop + careful/focus offset only while `in_progress`. |
| `LoadVanTask` | `dog.activity.delivery.load_food_bag` | object-transfer to Van load anchor. |
| `DeliveryTask` / player confirmation | calm wait/dispatch presentation | Dog animation cannot auto-send or complete order. |
| First Day/Day 2 feedback available | `dog.activity.delivery.notice_feedback` | Approach/look after feedback exists; never creates it. |
| Equipment completion | worn-foot Slippers overlay + accepted reaction | Equipment state stays separate from identity and locomotion clips. |

The D-022 cue `labrador_packing_care_moment(order_id)` is valid only for `dog.labrador_intro`, the existing Day 2 `PackTask`, and `in_progress`. It does not create another task, overlay task, quality/habit state or bonus. The animation binding observes the authoritative cue/state and records visual evidence; it does not own the event's gameplay causality.

`labrador_packing_care_moment(order_id)` is absent from stable HEAD. It remains an accepted D-022 future binding constraint, not current implementation evidence; moving Day 2 files are excluded from this claim.

---

## 12. Proposed clip/binding manifest shape

This is an audit/contract shape, not an accepted runtime schema. It must remain external per run; the dog skill must not hardcode Shelter action rows.

### 12.1 Required collections

```text
schema_version
package_status / run_mode / profile
repo_root / runtime_authority
authority
actors[]
activities[]
actions[]
clips[]
state_bindings[]
events[]
props[]
rooms[] / stations[]
runtime
qa / evidence
```

### 12.2 Exact mapping dimensions

| Dimension | Required fields |
| --- | --- |
| Authority | `vocabulary_path`, version/date, file hash, document status, row ID/status/priority, primary accepted source refs + hashes, approval reference. |
| Activity/action | `activity_id`, ordered `action_ids`, player-visible meaning reference, eligibility, allowed/forbidden layers, readability profile, evidence gates. |
| Runtime selector | scene/script, task type/id, task status, dog/object/world state, phase, transition/preconditions, dynamic context such as `order_id`. |
| Actor | `actor_id`, role IDs, capabilities, Dog DNA ref/status/version, morphology tags, envelope/family binding, compatibility range, identity/personality offsets, override ID. |
| Composition | logical clip ID/version, base pose, locomotion, effort, head, ears, tail, object, intent and micro layers. |
| Facing | requested facing, authored facing, policy, asymmetry flags, overlay/socket/prop/station override. |
| Temporal | one-shot/loop, ordered phases, marker list/order/window, transition/blend rule, interrupt/cancel boundary, recovery/fallback. |
| Prop | object ID/class, weight, carry mode, socket/contact set, source/target anchors, attach/place/detach markers, swing and z/occlusion policy. |
| Room/station | building/room/station/prop IDs, `detail_surface_ref`, `room_surface_status`, entry/exit, occupancy authority/request/ack, rendered-presence source, contact anchors, allowed facing, clearance, world-response owner. |
| Clip binding | logical clip, implementation resource/path, source kind, profile, actor envelope, family variant/override, node/track refs, evidence class/status. |
| Evidence | actor/action/phase/facing/prop/room/size, native capture/trace refs, source/artifact hashes, perf observation, retention location, signer owner/state. |

### 12.3 Binding key and cardinality

A binding must be addressable by at least:

```text
semantic action + phase + actor envelope + facing policy + prop/station variant + layer slot
```

It is incorrect to require exactly one clip and one socket per semantic action:

- objectless idle/walk needs no socket;
- one action may have multiple phases and layer bindings;
- crate/front-paw contact may require multiple sockets;
- one logical clip may serve multiple activities;
- a family override is an implementation variant, not a new semantic action.

### 12.4 Authority status behavior

| Source status | Allowed run |
| --- | --- |
| `accepted current` plus primary accepted refs | Prepare/integrate only under accepted brief and complete Art/Technical inputs. |
| `existing proposal` | Read-only coverage/feasibility; implementation only after explicit acceptance. |
| `user-requested candidate` | Read-only coverage/feasibility only. |
| `future-only` | Audit only; fail any current runtime mutation request. |
| proposed document supplied as `accepted_action_manifest` | `STOP_MISSING_GAMEPLAY_AUTHORITY`; filename or wrapper cannot elevate status. |

---

## 13. Import, naming and source metadata contract

No permanent repo location or production asset taxonomy is selected here. An accepted spike brief must choose a bounded output/evidence location before files are produced.

### 13.1 Naming

- Keep gameplay IDs exactly as vocabulary IDs.
- Use logical technical IDs such as `dog.clip.<layer>.<motion>.<variant>.vN`.
- Keep actor/family/facing/prop implementation variants in binding metadata, not baked into gameplay IDs.
- Use stable marker IDs from the visual namespace; do not reuse task completion event names for animation-only markers.
- Never encode reward, mechanic or inferred role in a clip filename.

### 13.2 Required Art/source metadata

Before an authored cutout/skeleton clip, the input package must provide:

- source path, immutable hash, provenance/permission and Art status;
- layered side-view parts, transparent canvas/padding and native baseline;
- part names, pivots, z/draw order and occlusion behavior;
- canonical facing plus asymmetry/mirror policy;
- body-contact points and all required socket transforms;
- compatibility envelope and failure cases;
- prop/station source, contact/anchor policy and scale relationship;
- clip timing/loop/event manifest;
- Dog DNA source/status and identity/equipment separation;
- import/export settings sufficient to reproduce the Godot asset.

### 13.3 Deterministic validation

Mechanical tooling may check:

- schema, allowed fields, statuses, hashes, path containment and cross-references;
- ID uniqueness and authority-subset rules;
- complete action/activity/task/phase/actor/prop/room mappings;
- pivot/baseline/socket/anchor bounds, alpha and declared dimensions;
- phase/marker order, facing decision, interrupt/fallback declarations;
- existence of Godot scenes/resources/nodes/tracks as a presence check;
- evidence completeness and signer states.

Mechanical tooling may not check or approve:

- visual identity, silhouette quality, calmness, contact believability or appeal;
- gameplay scope, role assignment or reward meaning;
- production architecture selection;
- runtime correctness merely from literal substring anchors.

---

## 14. Native 216/144/96 evidence and capture QA

### 14.1 Readability targets

| Size | Required reading |
| --- | --- |
| 216 px | Dog identity, exact action/contact mode, main prop/station and relevant secondary detail/equipment. |
| 144 px | Morphology/type, action and main prop/station without text label. |
| 96 px | Dog, direction/action category and one dominant prop/context; fine markings or micro layers need not read. |

### 14.2 Required evidence per binding

- three actual native Godot renders/captures at 216/144/96; resizing one capture is preview evidence only;
- fixed camera, fixture/seed, scale, background and baseline;
- requested facing(s), including mirror/overlay evidence;
- clean view and black-silhouette view where applicable;
- alpha/pivot/socket/anchor overlay contact sheet;
- motion capture or frame sequence, not only one still;
- runtime trace: task/status/state/phase -> logical clip/layers -> markers -> socket/anchor state -> outcome;
- source and artifact hashes;
- separate mechanical, Art and Technical signer states.

### 14.3 Phase capture matrix

| Type | Minimum frames/moments |
| --- | --- |
| Foundation | idle, start, mid-walk, stop, physical turn midpoint/end. |
| Object transfer | pre-contact, contact, attach ack, carry loop, target contact, detach ack, post-release. |
| Station | approach, aligned lock, loop, loop exit, outcome acknowledgment, release. |
| Bicycle | prep/contact, departure, away representation, return, release/unload handoff. |
| Seat/bed/read/chair | approach, attach/occupy, loop/contact, detach/get-up, exit. |
| Cancellation | before contact, protected window, safe loop boundary, after detach/recovery. |

### 14.4 Sign-off split

| Owner | Decision |
| --- | --- |
| Art Director | Identity, silhouette, motion, contact/weight, readability and visual acceptance. |
| Codex/Technical | Runtime binding, marker/attachment trace, deterministic capture and performance evidence. |
| Producer/Game Designer | Action/activity/actor/object/room/reward scope. |
| Project Manager | Source-map, retention/location, status and signer governance. |

A validator `PASS` always means mechanical conformance only. An unsigned or `PENDING` Art result is not visual acceptance.

### 14.5 Deterministic ideas adaptable from hatch-pet QA

Applicable ideas:

- immutable input fingerprints;
- deterministic coverage matrix and missing/duplicate detection;
- alpha/bounds/contact-sheet checks;
- fixed native-size evidence and explicit per-row/per-phase labels;
- reproducible packaging/reporting with separate human review.

Not applicable:

- fixed `8x11` atlas;
- nine universal animation rows;
- sixteen look directions;
- `pet.json`, `spriteVersionNumber 2` or generic Codex-pet runtime semantics.

Shelter remains external-manifest-driven and activity/eligibility-based.

---

## 15. Production multiplication and cost model

### 15.1 Naive model to avoid

```text
unique assets ~= dogs × actions × facings × prop variants × room variants
```

For 67 catalog IDs this would immediately create false expectations and duplicate activity meanings as clips.

### 15.2 Layered model

```text
production work ~=
  family/envelope compatibility for reusable bases
  + family-compatible additive tracks
  + choreography templates
  + per-prop interaction bindings
  + per-station/room anchor bindings
  + per-dog parts/DNA/equipment/personality/QA
  + measured exceptions
```

For the two current candidate envelopes `short_long` and `large_sturdy`, Stage A estimates:

- `2 × 10 = 20` family/envelope × base compatibility passes;
- `2 × 4 = 8` family/envelope × additive compatibility passes;
- four choreography templates;
- current prop/station binding passes;
- per-dog identity/equipment/QA passes.

These are compatibility/evidence passes, not 28 unique authored clip sets. `short_long` and `large_sturdy` are candidate proof labels, not accepted production skeleton families.

### 15.3 Multiplication owner

| Multiplies per | What legitimately varies |
| --- | --- |
| Dog | Parts/DNA, identity markings, equipment, bounded personality offsets, QA. |
| Family/envelope | Gait/turn/contact/carry/work compatibility and socket transforms. |
| Prop | Weight, mode, socket/contact, attach/detach, swing and z/occlusion. |
| Station/room | Anchors, occupancy, clearance and world response. |
| Activity | Usually ordered composition and intent only. |

The 12 room IDs should initially reduce to roughly six reusable interaction templates: enter/exit, sit/seat, lie/sleep/bed, read/study focus, toy/bowl contact, partner/social; rocking chair reuses seat/rest while the chair owns rocking. This is a production estimate hypothesis, not scope acceptance.

### 15.4 Roster-scaling hypothesis

Do not calculate `89 vocabulary IDs × dogs`. A Stage A authoring estimate, excluding prop/room production, is:

```text
authoring units ~= 18 shared blocks + 10 per active family/envelope + 5 per dog identity pack
```

| Roster hypothesis | Active family hypothesis | Approx. authoring units | Approx. QA cells, including correction factor |
| ---: | ---: | ---: | ---: |
| 2 dogs | 2 | 48 | 270 |
| 5 dogs | 3 | 73 | 513 |
| 10 dogs | 4 | 108 | 864 |
| 25 dogs | 5 | 193 | 1755 |

These values are estimation evidence, not an accepted roster/family plan. QA grows faster than authoring and must be batched into deterministic sheets/runs.

Feasibility review gates:

- more than five simultaneously active families is a pipeline-break warning;
- a 25-dog high lane with ten families or unique-side redraws is technically unacceptable without a different proven model;
- left/right motion mirroring may preserve authoring reuse but still doubles facing QA;
- side-aware identity/equipment/prop overlays are required for asymmetry;
- if full clips must be redrawn per side, family motion cost rises approximately `1.7–2×` and the lane is not viable;
- a new family should amortize across roughly three dogs unless Producer/Art explicitly accepts a flagship exception;
- if more than two of ten Stage A bases require topology/per-dog redraw, or more than two correction cycles persist, stop that dog/wave and review the envelope/new-family choice.

Reading and rocking chair remain shared family/world interfaces; the room shell must not multiply by dog count.

---

## 16. Performance, complexity and tooling risks

| Risk | Why it matters | Required evidence before production claim |
| --- | --- | --- |
| Node/track multiplication | Layered parts and many `AnimationPlayer` tracks can scale per visible dog. | Node count, active tracks, draw calls and frame-time trace at representative dog count. |
| Draw-call/texture fragmentation | Per-part textures and overlays may prevent batching. | Import/atlas observation on actual Art assets and both facings. |
| Runtime property contention | Animation tracks and procedural modifiers may write the same transform. | Explicit property ownership table and conflict test. |
| Track-path fragility | Renamed/reparented parts can silently break clips. | Binding/path validator plus Godot runtime playback evidence. |
| Pivot/socket drift | Reimport or mirror may break contact. | Hash/pivot/socket overlays and attach/detach captures. |
| Morphology envelope failure | Dachshund/Labrador proportions may not share contact/gait. | Same logical corpus, measured correction/reuse cost and exception log. |
| Skeleton deformation artifacts | Weighted cutout may fold/stretch at small scale. | Equal-corpus A/B captures; no theoretical promotion. |
| Room cross-pipeline coupling | Chair/book/station/world response can become a second dog system. | Typed anchor handshake and owner-specific traces. |
| Capture false confidence | Debug geometry, zoomed sheets or resized images can hide failure. | Art-backed native renders and signer split. |
| Tool/dependency lock-in | External authoring tool can change source format and team workflow. | Separate brief/ADR with export reproducibility and dependency governance. |

No production performance threshold is set because target hardware, visible dog count and final Art assets are not yet fixed. A bounded spike records observations only: CPU/GPU frame time, draw calls, node/track count, texture memory, allocations and deterministic capture stability.

---

## 17. Proposed implementation waves

Priority labels below preserve the proposed vocabulary and do not authorize coding.

### 17.1 Stage A / P0 maturity sequence

Stage A uses the 10-base / 4-layer / 4-choreography hypothesis, but evidence should mature in this technical order:

| Sub-wave | Minimum proof | Blocker before entry |
| --- | --- | --- |
| P0-A — inventory/binding maturity | External accepted-row ledger, `0 production / 7 debug analog / 22 absent`, source kind/evidence class, runtime facing sign, mirror/asymmetry declaration and physical-turn manifest. | Accepted manifest/brief, stable source hash and no moving Day 2 evidence. |
| P0-B — shared foundation | Idle/wait, walk/approach, stop, physical turn and contact-align on both current candidate envelopes; both facings or accepted overlay policy; native 216/144/96. | Approved current-dog layered Art, pivots/baseline/envelopes and P0-A. |
| P0-C — one object transfer | One already-accepted source -> pickup/attach -> carry -> place/detach -> target flow, with runtime marker/socket trace. | Exact prop weight/mode/socket/contact/placement authority. |
| P0-D — one station work | One already-accepted station approach/lock/work-loop/exit using the actual assignee and authoritative output timing. | Approved station source, approach/work/exit anchors and runtime task binding. |

The earlier player-visible role corpus remains useful after those gates:

- Dachshund TripTask/Bicycle approach-contact-depart-return is a separate high-risk comparison because exact Bicycle contact/propulsion is unresolved;
- Labrador Packing Table station-work + Day 2 careful/focus layer is admissible only after P0-D inputs, and the D-022 cue is not stable-HEAD implementation evidence.

Bicycle is not counted as a reusable Stage A maturity pass, and room/detail work is outside Stage A. P0 continuation later covers the rest of the accepted current delivery chain: unload, ingredient delivery, Kitchen work, carry to Packing, ordinary PackTask, LoadVan and feedback notice.

### 17.2 Wave B / P1-A life and onboarding

After explicit acceptance, the first technical P1 group proves role-compatible physical expansion and bounded life/personality reuse. It contains exactly:

- `dog.action.carry.heavy`;
- `dog.action.force.pull_hitched`;
- `dog.action.force.push_contact`;
- `dog.action.object.inspect`;
- `dog.activity.route.check_basket`;
- `dog.activity.rest.favorite_place`;
- `dog.layer.head.look_around`;
- `dog.layer.head.sniff`;
- `dog.layer.ear.twitch`;
- `dog.layer.ear.step_bounce`;
- `dog.layer.tail.wag_burst`;
- `dog.layer.pause.tiny`;
- `dog.layer.body.stretch`.

This is a 13-ID coverage grouping, not acceptance of heavy carry, pull/push, rest or route-prep scope. Do not require a universal full atlas.

### 17.3 Wave C / P1-B room and social subset

Only after Producer/Game Design chooses an executable subset and world/Art contracts exist, the second technical P1 group contains exactly:

- `dog.activity.social.greet_dog`;
- `dog.activity.social.welcome_returning_dog`;
- `dog.activity.care.wait_for_partner`;
- `dog.activity.care.support_partner`;
- `dog.activity.social.sit_together`;
- `dog.activity.play.with_toy`;
- `dog.action.room.enter`;
- `dog.action.room.exit`;
- `dog.action.rest.sit`;
- `dog.action.rest.lie`;
- `dog.action.rest.sleep`;
- `dog.activity.room.read_book`;
- `dog.activity.room.study_board`;
- `dog.activity.room.toy_interaction`.

This is a 14-ID coverage grouping, not acceptance of any room/social mechanic. Read reuses seat/lie + focus/book; it is not a unique dog-wide clip family. Together P1-A and P1-B account for all 27 proposed P1 catalog IDs.

An independent room-slice handback recommends a later **Kitchen Live Detail / One-Room Continuity Proof** as the stronger dog-first medium-cost candidate because it can reuse the accepted Kitchen building, existing `CookTask`, current inputs/Food Mix and current asset. The final room audit identifies Storage as the smallest technical option, so no option is selected by this contract. If Producer/Game Design accepts Kitchen later, the minimal technical evidence is:

```text
existing pre-Cook state
-> click existing Kitchen anchor
-> one room + one station + actual current assignee
-> live inputs and station-work binding
-> Food Mix only after existing CookTask completion
-> close/reopen with simulation/state continuity
-> connector parity
```

It may not add states, assignments, recipes, upgrades, decor, needs or a window-topology decision. A same-camera/shell/dog-scale preview may compare Kitchen mixing room with Dog House personal room for production clarity versus attachment, but neither preview authorizes implementation. Storage remains the cheaper alternative with inventory-panel risk; House of Curiosity would require unaccepted research scope. Packing/Dispatch/Route remain blocked by taxonomy/Utility Prop conflicts. Rocking chair stays outside the first room proof.

Runtime metadata assignment is never occupancy evidence, and acceptance of main-strip/detail separation does not imply a native OS window or any other surface topology.

### 17.4 Wave D / P2

Future-only/user-candidate coverage such as rocking-chair rest, bowl/water, bring water, check companion, play invite, show find, tidy place and optional larger micro reactions. Every row retains its source/status and may remain unimplemented indefinitely.

---

## 18. Recommended bounded technical spike

### 18.1 Question

Can one shared logical corpus and bounded runtime modifier model preserve current Dachshund/Labrador identity, facing, contact and task causality with acceptable correction/reuse cost at 216/144/96?

### 18.2 Preconditions

- accepted Stage A manifest/brief and exact selected rows;
- approved layered side-view current-dog parts with pivots/z-order/asymmetry;
- declared candidate envelope(s) and Dog DNA source/status;
- Bicycle and Packing Table source/anchor/contact contracts;
- chosen prop modes/sockets for the tested corpus;
- clip/marker/interrupt manifest;
- evidence location, retention lifecycle and signer states.

### 18.3 Lanes

1. Preserve current Node2D/Polygon2D/Line2D proof only as the qualified continuity reference.
2. Build an Art-backed `Node2D`/`Sprite2D` cutout + `AnimationPlayer` lane as `RESEARCH_ONLY`, not production.
3. Add `Skeleton2D`/`Bone2D` only as an optional common-corpus A/B lane using identical source parts, timing, actions, props and captures.

One bounded envelope may be proven first; the second actor is then applied to the same logical corpus to measure reuse and correction cost. Neither step creates five families or a production migration.

### 18.4 Pass/reject evidence

- both actor identities and required action meaning pass Art review at native sizes;
- contact/marker/object trace is deterministic and runtime-authoritative;
- left/right/mirror policy survives asymmetry and sockets;
- cancel/recovery produces no duplicate/lost/teleported prop or occupancy;
- correction/reuse/authoring time is measured per base/layer/interaction;
- performance observations are recorded, with no unsupported shipping claim;
- failed envelope cases and required overrides are explicit.

If real approved Art inputs are absent, the spike may only exercise mechanics and must not decide production visual feasibility.

---

## 19. Stop conditions

These stop codes are proposed Technical contract vocabulary. They apply before output/runtime mutation unless the row explicitly concerns evidence review.

| Stop code | Exact trigger | Owner |
| --- | --- | --- |
| `STOP_MISSING_GAMEPLAY_AUTHORITY` | Vocabulary/row is only proposed/candidate/future, accepted primary action/activity/task/actor/object/room authority is missing, or proposed file is passed as accepted manifest. | Producer / Game Designer / PM. |
| `STOP_SCOPE_EXPANSION` | Request adds unknown action, role, reward, mechanic, need, resource, room or progression meaning. | Producer / Game Designer. |
| `STOP_CONFLICTING_AUTHORITY` | Sources disagree on actor, status, object causality, room scope/taxonomy or runtime owner, including Packing room versus Utility Prop versus synthetic runtime room. | PM + owning roles. |
| `STOP_SECOND_SIMULATION` | Manifest/skill/animation graph owns task/resource/order/save/activity state instead of observing Godot. | Codex / Technical. |
| `STOP_MISSING_RUNTIME_BINDING` | No exact scene/script/task/status/state/phase/node/clip/event binding for required action. | Codex / Technical. |
| `STOP_INVALID_EVENT_AUTHORITY` | Animation marker directly advances task/resource/order/reward or fires outside allowed authoritative phase/context. | Codex / Technical + Game Design. |
| `STOP_EVENT_ORDER_VIOLATION` | Contact/attach/loop/detach/place markers are missing, reordered or unrecoverable. | Codex / Technical. |
| `STOP_MISSING_ART_CONTRACT` | Approved layered source, pivots, z-order, facing/asymmetry, sockets, envelope or prop/station contact data is absent. | Art Director. |
| `STOP_UNPROVEN_PIPELINE` | Cutout/Skeleton/external tool is presented as production-approved without bounded evidence/decision. | Codex / Technical + PM. |
| `STOP_UNSUPPORTED_ACTOR_ENVELOPE` | Actor proportions/contact lie outside the proven envelope and no explicit override exists. | Art Director + Technical Animation. |
| `STOP_UNSAFE_MIRROR` | Any identity/equipment/text/tool/socket/prop/station asymmetry gate is unresolved or fails. | Art Director + Technical Animation. |
| `STOP_INVALID_PROP_SOCKET` | Prop mode/weight/socket/contact/target anchor is missing/incompatible, including crate/heavy via unvalidated mouth or Slippers as held prop. | Game Design/Object owner + Art + Technical. |
| `STOP_MISSING_ROOM_CONTRACT` | Room/seat/bed/book/chair/toy/bowl/partner activity lacks accepted room/prop/surface/occupancy/anchor authority, or cites runtime_scaffold/metadata assignment as physical occupancy. | Producer / Game Designer + Art/world owner. |
| `STOP_PIPELINE_MULTIPLICATION` | More than five active families, full side redraws, more than two of ten bases needing topology/per-dog redraw, or more than two persistent correction cycles makes the declared lane non-viable without explicit review/exception. | Technical Animation + Art Director + Producer. |
| `STOP_MISSING_EVIDENCE` | Required native phase/facing/size/runtime trace or source hash is absent. | Technical Animation / Codex. |
| `STOP_INVALID_APPROVAL_STATE` | Mechanical PASS is treated as Art acceptance, signer state is absent/ambiguous, or retention location is unapproved. | Art Director / PM / Codex. |

---

## 20. Decisions required before the first authored Stage A clip

No authored Stage A implementation should begin until these are explicit:

1. **Producer / Game Designer:** which exact Stage A semantic rows are accepted for executable proof; P0 priority alone is insufficient.
2. **Producer / Game Designer:** confirm Dachshund TripTask and Labrador Day 2 PackTask as the bounded first player-visible pair, without expanding game scope.
3. **Art Director:** approved current Dachshund/Labrador layered side-view source and identity references.
4. **Art Director + Technical Animation:** pivots, z-order, baseline, facing/asymmetry and compatibility envelope.
5. **Game Design/Object owner + Art + Technical:** exact Bicycle contact/propulsion mode.
6. **Art/world owner:** approved Packing Table source plus work/approach/exit/facing anchors.
7. **Game Design/Object owner + Art + Technical:** prop weight/mode/socket/placement for every tested carried object.
8. **Technical Animation/Codex:** logical clip, phase, marker, transition, cancellation and recovery records.
9. **Technical Animation/Codex:** exact runtime scene/script/task/status/event binding that preserves ADR-0002.
10. **Project Manager:** run artifact path, retention lifecycle, source-map update owner and signer-state policy.
11. **PM/Codex:** accepted implementation brief as required by project rules.
12. **Later architecture decision:** production pipeline/family choice only after the bounded evidence; not before the first clip.

### Work that may proceed in parallel with Day 2

Without touching current Day 2 runtime scope:

- Game Design/Producer may accept or reject the bounded Stage A rows and current prop meanings;
- Art Director may prepare/review layered dog parts, Bicycle/Packing anchors and asymmetry policy;
- Technical Animation may prepare a read-only manifest/capture plan and common-corpus metrics;
- PM may choose evidence retention/sign-off governance;
- Codex may prepare a later implementation brief after those decisions.

No current runtime, skill, status or production asset mutation is implied by this parallel preparation.

---

## 21. Technical-role versus Producer/user decisions

### Technical Animation / Codex may decide within an accepted brief

- logical clip ID syntax and binding key;
- property/layer ownership and conflict masks;
- marker ordering, safe interrupt/recovery protocol and validator checks;
- how to measure compatibility, correction/reuse cost and performance observations;
- deterministic capture/trace mechanics;
- whether evidence proves or rejects the declared technical hypothesis.

### Producer/user or owning roles must decide

- which proposed actions/activities/rooms enter executable scope;
- actor/role/reward/mechanic and object meaning;
- final Art direction, identity/readability acceptance and approved source assets;
- whether a permanent production pipeline/external dependency is adopted after evidence;
- acceptable scope, schedule and investment for additional families/rooms;
- governance location/lifecycle where project rules assign it outside Technical Animation.

Technical evidence may recommend; it must not silently fix art/game/product scope.

---

## 22. Proposed acceptance evidence for this contract

This document is ready for cross-role review when reviewers can verify that it:

1. preserves `0/29` production-binding truth, `7/29` debug analogs, `22/29` without analog and the narrow qualified baseline;
2. maps 67 semantic IDs to layers/choreographies rather than 67 clips;
3. separates physical turn from facing/mirroring and provides asymmetry gates;
4. defines ordered markers, protected phases, fallback and cancellation;
5. keeps MouthHarnessSocket bounded and Slippers as worn overlays;
6. keeps station/room/world ownership outside the dog clip and treats stable-HEAD room records as `runtime_scaffold`, not occupancy/UI evidence;
7. composes read and rocking-chair actions from shared units;
8. preserves runtime task/save/resource authority and D-022 causality;
9. requires native Art-backed 216/144/96 captures and signer separation;
10. keeps cutout/Skeleton lanes research-only;
11. states exact blockers and owners before the first authored clip;
12. grants no implementation authorization.

---

## 23. Changelog

### 2026-07-12 — stable-HEAD inventory and room audit clarification

- Recorded the only seven runtime-created debug clips, absence of authored dog animation resources and `22/29` P0 rows without analog.
- Recorded stable-HEAD VS as semantic state + lerp/procedural drawing, without manifest/socket/AnimationPlayer binding.
- Recorded fixed-right-facing evidence and the missing facing-sign/mirror/physical-turn split.
- Added exact stable-HEAD room-scaffold inventory, missing player-facing detail surface and Packing taxonomy conflict.
- Added production/research/debug/semantic/absent evidence classes and explicit room-surface/occupancy fields.
- Split Stage A into P0-A binding maturity, P0-B foundation, P0-C object transfer and P0-D station work; Bicycle stays a separate risk lane and rooms stay outside Stage A.
- Kept moving Day 2 files out of completed evidence and preserved proposed/no-implementation status.

### 2026-07-11 — proposed v1 created

- Added current repo evidence and `0/29` production-binding boundary.
- Added 10-base / 4-layer / 4-choreography Stage A hypothesis.
- Added facing/mirror/physical-turn, marker, interrupt, fallback and prop/socket contracts.
- Added state/task/activity binding and room/station ownership rules.
- Added manifest dimensions, deterministic QA, cost model, performance risks and exact stop conditions.
- Kept all art/game/product/pipeline decisions and implementation authorization open.
