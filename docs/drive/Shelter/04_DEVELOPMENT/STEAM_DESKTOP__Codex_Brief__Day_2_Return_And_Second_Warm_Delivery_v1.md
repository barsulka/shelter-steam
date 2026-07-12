# STEAM_DESKTOP — Codex Brief — Day 2 Return And Second Warm Delivery v1

Дата: 2026-07-11
Статус: completed / R-29 PASS / historical implementation brief
Роль-владелец постановки: Producer / Game Designer / Project Manager
Roadmap task: R-29 — Day 2 Return And Second Warm Delivery implementation / evidence review
Decision: D-022 — Steam/Desktop Day 2 executable scope lock
Рекомендуемый уровень рассуждений Codex: **очень высокий**

---

## 0. Цель

Реализовать первый честный repeatable-loop proof после First Day MVP:

```text
Day 2 return
-> вчерашняя забота остаётся видимой
-> одна полностью завершаемая вариация существующей Warm Food Delivery
-> один readable careful-packing cue Лабрадора
-> visible Van load + player-confirmed dispatch
-> спокойная progress note
-> optional question “Как паковать мягче?”
-> quiet end state
```

Это narrow product-language/runtime-evidence slice. Он не является полной First Week, production save/calendar, production art pass, desktop-platform gate или retention KPI validation.

---

## 1. Обязательные источники

Codex обязан прочитать перед изменениями:

### Rules / role / current state

```text
PROJECTS_RULES.md
AGENTS.md
README.md
steam/AGENTS.md
steam/README.md
docs/drive/Shelter/00_START_HERE/000_ROLE_CODEX.md
docs/repo/status/CODEX_CURRENT_STATUS.md
docs/drive/Shelter/04_DEVELOPMENT/CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md
```

### Architecture

```text
docs/repo/adr/README.md
docs/repo/adr/0001-use-godot-for-steam-desktop.md
docs/repo/adr/0002-game-state-as-source-of-truth.md
```

Прочитать все другие Accepted ADR, которые окажутся релевантными выбранной реализации. Godot runtime state остаётся единственным source of truth; scenario/order/animation/evidence не создают вторую simulation.

### Product / Game Design contracts

```text
docs/drive/Shelter/00_START_HERE/02_DECISIONS.md
docs/drive/Shelter/00_START_HERE/03_PROJECT_PHILOSOPHY.md
docs/drive/Shelter/00_START_HERE/04_SHELTER_STRESS_TESTS.md
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__First_Week_Direction_v1.md
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__First_Day_MVP_Lock_And_Next_Scope_Decision_v1.md
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__First_Day_MVP_v1.md
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Vertical_Slice_Scope_Lock_v1.md
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Task_Flow_Contract_v1.md
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Object_Contract_v1.md
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Production_Chains_v1.md
```

### Visual/readability constraints — not a production-art brief

```text
docs/drive/Shelter/03_DESIGN/00_VISUAL_DIRECTION/DOG_VISUAL_LANGUAGE_v1.md
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Art_UX_Review__First_Day_MVP_v3.md
```

### Existing implementation/evidence surfaces

Locate and inspect the current equivalents of:

```text
steam/scripts/prototypes/vertical_slice/vertical_slice_demo.gd
steam/scripts/game_systems/game_systems_runtime.gd
steam/scripts/dev_tools/godot_state_connector.gd
steam/resources/game_systems/fixtures/
steam/tools/dev-vertical-slice.sh
docs/repo/dev/godot-state-connector.md
docs/repo/api/godot-state-connector.openapi.yaml
```

Do not assume paths or state names from this brief override current accepted implementation. If a current contract conflicts with D-022, stop and return the conflict before coding.

---

## 2. Accepted scope

### 2.1 Deterministic continuation, not production persistence

Create or normalize fixture:

```text
second_day_after_first_delivery
```

The fixture represents canonical continuation after completed First Day. It MUST separate immutable First Day history from the single active Day 2 order/chain.

Exact `first_day_history` surface:

```text
first_day_history.order_id: order.first_warm_delivery
first_day_history.delivery_confirmed: true
first_day_history.postcard_visible: true
first_day_history.reward_available: true
first_day_history.chain_complete: true
first_day_history.postcard_life_moment_seen: true
first_day_history.first_reward_equipped: true
first_day_history.first_memory_added: true
first_day_history.next_day_hint_available: true
first_day_history.dachshund.slippers_equipped: true
first_day_history.dachshund.memory_id: memory.first_warm_delivery
first_day_history.dachshund.memory_text: Помнит первую тёплую поставку
first_day_history.packing_note_visible: true
```

Exact active order at fixture load:

```text
active_order.id: order.second_warm_delivery_careful_pack
active_order.title: Аккуратная тёплая поставка
active_order.status: offered
active_order.delivery_state: idle
active_order.delivery_confirmed: false
active_order.completed: false
active_order.postcard_created: false
active_order.reward_created: false
active_order.equip_task_created: false
```

Exact active chain identity at fixture load:

```text
active_chain.template_id: chain.warm_food_delivery_intro
active_chain.run_id: run.day2.second_warm_delivery
active_chain.state: not_started
active_chain.current_step: none
active_chain.route_id: route.oat_farm_intro
active_chain.transport_id: transport.basket_bicycle
```

Allowed active-chain progression:

```text
not_started
-> route_selected
-> trip_active
-> payload_returned
-> unloading
-> stored
-> inputs_to_kitchen
-> cooking
-> food_mix_ready
-> moving_to_packing
-> packing_ready
-> packing
-> food_bag_ready
-> loading_van
-> ready_to_dispatch
-> dispatched
-> completed
```

`current_step` MUST expose the exact current step and start as `none`. `active_chain` reuses the existing template and is not a new chain family.

Exact Storage precondition:

```text
Protein Packet x1
Packaging Bag x1
no Oat Crate
no Pumpkin Crate
no Food Mix
no Food Bag
no pre-created cargo/token
```

These two units are deterministic existing stock supplied by the fixture after First Day consumption. They MUST NOT come from a refill event, generator, timer, route reward, hidden replenishment, economy or save logic.

Exact Day 2 initial state:

```text
day2.return_moment_seen: false
day2.yesterday_postcard_visible: true
day2.dachshund_slippers_visible: true
day2.dachshund_memory_inspectable: true
day2.packing_note_visible: true
day2.second_order_available: true
day2.return_has_no_urgent_prompt: true
day2.absence_penalty_applied: false
day2.labrador_packing_care_moment_seen: false
day2.second_delivery_completed: false
day2.second_feedback_visible: false
day2.curiosity_question_available: false
day2.curiosity_is_optional_hint: false
day2.quiet_end_state_reached: false
```

Legacy top-level order/chain flags MAY remain only as one-way compatibility projections of `active_order` / `active_chain`. They MUST NOT be the authority for `first_day_history`.

The names and values above are the exact fixture/state-connector/assertion surface. An internal equivalent is allowed only behind an explicit mapping that emits every exact canonical field/event without omission, merge or reordering.

No real day rollover, wall-clock logic, save migration or production persistence is authorized. Restart/fixture proof must leave `first_day_history` unchanged.

### 2.2 Return moment

Create or normalize scenario:

```text
second_warm_delivery_after_first_day
```

Before the second order starts, prove:

```text
day2.return_moment_seen: true
day2.return_has_no_urgent_prompt: true
day2.absence_penalty_applied: false
```

Player-visible return cues:

- first postcard remains on the board;
- Dachshund slippers remain visible/equipped in the world or existing inspectable equipment state;
- Dachshund memory remains separately inspectable in Dog Card;
- packing note is present near the existing packing area;
- Labrador is near the existing packing/kitchen work area;
- the second calm order is available without deadline, streak, loss or urgency.

### 2.3 Same route and same physical chain

Order id:

```text
order.second_warm_delivery_careful_pack
```

Player-facing name:

```text
Аккуратная тёплая поставка
```

Reuse without semantic substitution:

```text
route.oat_farm_intro
Basket Bicycle
existing Oat/Pumpkin/resource family
existing Storage
existing Kitchen / Food Mix
existing Packing Table / Packaging Bag / Food Bag
existing Delivery Van Endpoint
```

The order MUST move through this exact status order:

```text
offered
-> route_suggested
-> missing_resources
-> resources_available
-> production_in_progress
-> packed
-> loaded
-> sent
-> completed
```

`loaded` means Food Bag is visibly loaded and `delivery_state=ready_to_send`. `player_confirmed_delivery(order_id)` creates DeliveryTask, sets `delivery_confirmed=true`, `status=sent` and `delivery_state=sending`. `sent` is not completion and MUST NOT reveal feedback/question. Only `delivery_complete(order_id)` sets `status=completed`, `delivery_state=delivered`, `completed=true` and `day2.second_delivery_completed=true`.

Do not create a second production/comfort chain, route, resource family, station, recipe, queue or economy axis.

### 2.4 Mandatory end-to-end causality

The second order must complete fully. Availability-only is not acceptance.

Preserve these invariants:

1. Road Sign / player intent creates TripTask before departure.
2. Oat/Pumpkin payload exists as cargo before Storage inventory.
3. Storage receives cargo only after visible UnloadTask/place completion.
4. Resource carry to Kitchen remains dog/task-owned and visible.
5. Food Mix appears only after inputs and existing CookTask/work completion.
6. Food Bag appears only after Food Mix + Packaging Bag + existing PackTask completion.
7. Van ready state appears only after visible LoadVanTask/place completion.
8. Delivery completion requires visible load and explicit player-confirmed DeliveryTask/dispatch.
9. The order observes accepted events/state; it must not spawn resources, skip dog actions or complete itself.

Every Day 2 task and required capture event MUST carry:

```text
order_id: order.second_warm_delivery_careful_pack
```

Required event surface:

```text
player_confirmed_trip(order_id)
trip_task_created(order_id)
trip_returned_with_payload(route_id, payload, order_id)
resource_added_to_storage(resource_id, order_id)
resource_delivered_to_kitchen(resource_id, order_id)
food_mix_created(resource_id=food_mix, order_id)
resource_delivered_to_packing_table(resource_id, order_id)
labrador_packing_care_moment(order_id)
food_bag_created(resource_id=food_bag, order_id)
van_loaded(resource_id=food_bag, order_id)
player_confirmed_delivery(order_id)
delivery_task_created(order_id)
delivery_complete(order_id)
day2_progress_note_revealed(order_id)
day2_curiosity_question_revealed(order_id)
```

TripTask, LoadVanTask and DeliveryTask MUST use `active_order.id`, not a First-Day constant. Preserve First Day behavior and keep its regression events tagged `order.first_warm_delivery`.

Reuse the current accepted actor/task mapping for all other work. Do not silently reassign carry/cook/load work.

### 2.5 One careful-packing variation

Assign the existing Day 2 PackTask deterministically to `dog.labrador_intro` at the existing Packing Table. Show one readable Labrador attention/action cue only while this PackTask is `in_progress`.

Required meaning:

```text
Лабрадор помогает упаковать аккуратнее; это забота, не quality score или profit bonus.
```

Required evidence:

```text
PackTask.assigned_dog_id: dog.labrador_intro
labrador_packing_care_moment(order_id)
day2.labrador_packing_care_moment_seen: true
```

The cue must not:

- create a new task type, room, station or UI;
- create an overlay-only pseudo-task or second assignment;
- unlock a habit, quality tier or numerical bonus;
- change the existing material/object boundary;
- require production dog art, a new rig, Skeleton2D, atlas contract or asset-schema decision.

Existing semantic placeholders/runtime representations are acceptable. If the cue cannot read without a production-style or production-rig decision, stop and return the concrete readability blocker.

### 2.6 Completion and future promise

Player-confirmed dispatch produces `sent`, not completion. Only after `delivery_complete(order.second_warm_delivery_careful_pack)`:

```text
day2.second_delivery_completed: true
day2.second_feedback_visible: true
day2.curiosity_question_available: true
day2.curiosity_is_optional_hint: true
day2.quiet_end_state_reached: true
```

Feedback form:

- Active Order observes `delivery_complete` and owns the non-reward response state;
- publish `day2_progress_note_revealed(order_id)` and render a small progress note on the existing Van-side postcard-board world cue;
- only after that note is visible, publish `day2_curiosity_question_revealed(order_id)` and render `Как паковать мягче?` on the existing Packing Table note world cue;
- do not create a second full postcard, reward or daily reward cadence;
- preserve the weight of the First Day postcard/reward.

Limited completion exception:

- `order.first_warm_delivery` keeps the existing Postcard Card, Comfortable Slippers reward and EquipItemTask/equip flow unchanged;
- `order.second_warm_delivery_careful_pack` keeps the physical DeliveryTask and `delivery_complete` but MUST NOT emit `postcard_created`, `reward_created` or create EquipItemTask;
- the board and note cues only render Order-owned state; they do not become a new building, production responsibility, UI system, reward surface or research system.

Only after completion make this optional physical question available:

```text
Как паковать мягче?
```

It is a hint/future promise only. Do not create active research, selectable soft choice, a player-facing dog-assignment system, timer, House of Curiosity UI, habit opportunity or unlock.

---

## 3. Visual / UX evidence boundary

Use a mostly quiet strip and one foreground action beat. Avoid simultaneous competing dogs, FX, badges, alerts or panels.

Tiered readability expectations:

```text
216 px: identity + action + prop + secondary detail/equipment
144 px: morphology/type + action + prop without label
96 px: dog + movement/action category + one large main prop
```

Do not make fine slippers, markings, facial nuance or exact individual identity a 96 px hard gate. At 96 px, persistence may read through place, silhouette, pose/tempo, route-prep composition and inspectable markers.

Artifact requirement is exact:

- required: machine-readable state/event assertions and native 1x scenario captures at each proof point below;
- optional: the existing supported 2x review where useful;
- 216/144/96 are scale/readability review rubrics applied to supported review renders/captures, not three additional mandatory scenario runs.

Required proof points:

- return tableau;
- Labrador careful-packing cue;
- visible Food Bag / Van-ready state;
- player-confirmed dispatch;
- progress note + optional question + quiet end state.

Label captures as prototype/product-language evidence. Do not claim production art, final animation, shipping UX or production desktop readiness.

---

## 4. Hard out of scope

Codex must not add or change:

- production persistence, save migration, real-world clock, day rollover or calendar;
- new dog, route, transport, resource family, station, recipe, production/comfort chain;
- multiple orders/queues, quality tiers, economy or balance expansion;
- full House of Curiosity, research UI/tree/timer or research dog-assignment UI/system;
- habit opportunity/unlock/tree, `Ровный узелок`, numerical packing bonus;
- active branching soft choice;
- room/building expansion, non-food order, friendship/mentorship system;
- mood/energy penalties, failures, deadlines, streaks, expiry, missed rewards or guilt;
- monetization, donation/charity prompts or claims;
- Browser/Mobile/shared-account mechanics;
- production art/style lock, dog asset schema, new animation architecture or external animation dependency;
- Skeleton2D/Bone2D, AnimationTree, IK, Spine, five-family rig library or broad dog-rig replacement;
- window semantics, placement, click-through, DPI/monitor behavior, Steam integration, signing/notarization or release-platform work;
- dev connector/control capability expansion;
- generic shell/filesystem capability;
- tracked `.runtime` capture bundles.

This slice does not become “shipping desktop companion” or “retention validated”.

---

## 5. Expected implementation shape

Likely touched areas:

```text
steam/resources/game_systems/fixtures/
steam/scripts/prototypes/vertical_slice/vertical_slice_demo.gd
steam/scripts/game_systems/game_systems_runtime.gd
steam/scripts/dev_tools/godot_state_connector.gd
steam/tools/dev-vertical-slice.sh
steam/README.md
docs/repo/dev/godot-state-connector.md
docs/repo/api/godot-state-connector.openapi.yaml
docs/repo/status/CODEX_CURRENT_STATUS.md
docs/repo/status/CODEX_STATUS.md
docs/drive/Shelter/04_DEVELOPMENT/CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md
```

Touch fewer files if possible. Do not change `.github/`, `mcp/`, project rules, product decisions or art documents in this implementation task.

If the `/state` or connector schema changes, update its docs/OpenAPI in the same task. If no schema change is needed, do not churn them.

Before writing, inspect `git status`, declare exact write ownership back to the source session and preserve all concurrent PM/CI changes. Do not stage, commit or push unrelated files.

---

## 6. Acceptance criteria

All must pass.

### 6.1 Fixture continuity

- `second_day_after_first_delivery` loads deterministically.
- Every exact `first_day_history` field remains true/inspectable and is not used as active state.
- `active_order` / `active_chain` initialize separately with the exact ids and values in 2.1; legacy flags are one-way active-state projections only.
- Return postcard, visible/equipped slippers, separately inspectable Dog Card memory and packing note are present.
- Storage contains exactly Protein Packet x1 + Packaging Bag x1 and no Oat/Pumpkin/Food Mix/Food Bag/cargo; no replenishment mechanism exists.
- No production save/calendar/day-rollover behavior was introduced.

### 6.2 Full second delivery

- The second order starts from offered/available state and reaches completed.
- Its status order is exactly `offered → route_suggested → missing_resources → resources_available → production_in_progress → packed → loaded → sent → completed`.
- Its active-chain state follows the exact sequence in 2.1 without skipping/reordering a required physical step.
- Same route/resource family/transport/stations are reused.
- No task/object causal boundary can be skipped.
- Every material transition has a visible dog/task cause.
- Both Oat and Pumpkin `resource_added_to_storage` events carry the active order id and occur before `resources_available`.
- Van ready requires Food Bag load; dispatch requires player confirmation.
- `sent` follows confirmation/DeliveryTask creation and produces no feedback; only order-tagged `delivery_complete` produces `completed`.
- Every required task/event carries `order_id=order.second_warm_delivery_careful_pack`; First Day regression remains tagged with its own order id.

### 6.3 Careful-packing variation

- The existing Day 2 PackTask is assigned to `dog.labrador_intro`; Labrador cue/event occurs only during its `in_progress` phase at the existing Packing Table.
- Cue is readable as careful action/attention, not a new room/UI/system.
- No overlay/second task, habit, quality, economy or numerical state is created/unlocked.

### 6.4 Calm completion

- Active Order observes order-tagged `delivery_complete` and reveals the progress note on the existing Van-side board cue.
- No second full postcard/reward cadence, `postcard_created`, `reward_created` or EquipItemTask is created.
- Optional question appears on the existing Packing Table note cue only after the progress note is visible.
- First Day postcard/slippers/equip behavior remains unchanged.
- No urgency, absence penalty, streak, loss or guilt appears.
- Quiet end state is reachable.

### 6.5 Evidence

Capture/assertions prove at least:

```text
native 1x return moment
native 1x packing care moment
native 1x van ready
native 1x player-confirmed dispatch
native 1x second delivery completed / progress note visible
native 1x optional curiosity question / quiet end state
machine-readable exact fixture fields, status order and required order-tagged events
```

Existing supported 2x review is optional. 216/144/96 remain a scale/readability rubric, not three separate mandatory scenario captures. Keep 100x state analysis separate from player-feel judgement.

### 6.6 Regression

- Existing First Day full-dispatch scenario remains green.
- Existing Vertical Slice/runtime/connector smoke paths remain green.
- D-010 identity/equipment/memory separation remains intact.
- ADR-0002 runtime authority remains intact.

---

## 7. Required checks

Adapt exact arguments to the existing CLI, but run the current equivalents of:

```sh
bash -n steam/tools/dev-vertical-slice.sh
bash -n steam/launch.sh
cd steam && tools/dev-vertical-slice.sh workbench-capture --help
cd steam && tools/dev-vertical-slice.sh smoke
cd steam && tools/dev-vertical-slice.sh runtime-foundation-smoke
cd steam && tools/dev-vertical-slice.sh connector-control-smoke
cd steam && tools/check-godot.sh
```

Run a Day 2 capture using:

```text
scenario=second_warm_delivery_after_first_day
fixture=second_day_after_first_delivery
```

Choose game time/sampling/speed from measured current scenario needs; record exact values. Produce machine-readable assertions for every required field/event and object/task invariant.

Run the current First Day full-dispatch capture as regression.

Validate generated JSON:

```sh
python3 -m json.tool <day2-run>/manifest.json >/dev/null
python3 -m json.tool <day2-run>/final_state.json >/dev/null
```

If OpenAPI changes, parse it with an available safe YAML parser. Do not add a production dependency solely for validation.

Always run:

```sh
git diff --check
git status --short
git diff --name-only -- mcp/ .github/
test -z "$(git ls-files -- 'steam/.runtime/**')"  # fail the check if any runtime descendant is tracked
```

Do not delete or overwrite unrelated capture/history evidence.

---

## 8. Stop conditions

Stop implementation and return the exact question to the owning role if:

- real save/calendar/day rollover becomes necessary;
- the existing chain cannot be reused without a new route/resource/station/production model;
- scope starts including House/research/habit/economy/quality/soft-choice systems;
- a deadline, streak, expiry, loss, guilt, donation or monetization framing appears;
- implementation requires a production dog asset schema, atlas, new rig/tool or production-art decision;
- actor ownership or an action is not fixed by accepted contracts/current runtime;
- the careful-packing cue is unreadable without production-style work;
- window/platform semantics must change;
- First Day finals, D-010 separation, ADR-0002 authority or physical cause/effect would regress;
- concurrent unexpected changes appear inside the declared write scope.

Do not solve a stop condition by inventing product/game/art decisions.

---

## 9. Required status / handback

After implementation:

1. update `docs/repo/status/CODEX_CURRENT_STATUS.md` with current truth only;
2. prepend a dated entry to `docs/repo/status/CODEX_STATUS.md` with exact implementation/checks;
3. update `docs/drive/Shelter/04_DEVELOPMENT/CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md` only if bootstrap truth changed;
4. return handback directly to the source PM session.

Handback must include:

- exact write scope and files changed;
- fixture/scenario/order/state/event names chosen;
- how First Day continuity is preserved;
- how every object/task boundary is proved;
- careful-packing cue implementation and limitations;
- progress-note/question timing;
- capture paths and assertion results;
- regression/check commands and outcomes;
- any remaining visual, game-design, platform or production blockers;
- explicit confirmation that save/calendar, new systems, production dog pipeline, MCP/CI and window semantics were not changed.

Do not commit or push unless the integrating PM/user explicitly requests it after review.
