# STEAM_DESKTOP — Labrador P0 Accepted Action Manifest v1

Дата: 2026-07-12
Обновлено: 2026-07-13
Статус: accepted R48-05A core scope; selector H amendment is Game Design accepted / Producer/PM and Technical/Codex readbacks pending / no ambient executable binding yet
Actor: `dog.labrador_intro`
Milestone: R48-05A / P0-B + P0-D

---

## 0. Authority and boundary

This bounded manifest accepts presentation coverage only for the existing calm-helper Labrador in authoritative CookTask/PackTask flows plus the separately guarded ambient selector H. It adds no gameplay state, role, task, reward, quality, habit, resource, input or progression.

R48-05A explicitly excludes object transfer. P0-C remains R48-05B and requires a separate named-prop contract.

## 1. Exact accepted rows

1. `dog.action.idle.neutral`
2. `dog.action.wait.calm`
3. `dog.action.locomotion.start`
4. `dog.action.locomotion.walk_empty`
5. `dog.action.locomotion.stop`
6. `dog.action.locomotion.turn`
7. `dog.action.interaction.approach_target`
8. `dog.action.interaction.contact_align`
9. `dog.action.station.work_loop`
10. `dog.activity.delivery.help_kitchen`
11. `dog.activity.delivery.pack_food_bag`
12. `dog.activity.delivery.pack_carefully_labrador`

No other vocabulary row is accepted by this manifest.

`start`, `stop` and `turn` are accepted only as bounded presentation transitions derived from existing runtime phase/target/facing data. They are not new gameplay states and are not globally promoted in the proposed vocabulary. Selector H reuses those same rows; it does not add a thirteenth row.

## 2. Actor and role

- Actor: `dog.labrador_intro`.
- Existing role: calm helper.
- Eligible in existing work flows only when authoritative runtime assigns Labrador to `CookTask` or `PackTask`; selector H is the separate task-free presentation exception below.
- Never inferred as TripTask driver.
- No overlay task, quality, habit, bonus, XP, reward or new role.

## 3. Authoritative selectors A–H

### A — idle

`dogs[dog.labrador_intro].current_task == ""` and `current_visible_state == "idle"`.

Quiet Cooperative additionally requires empty active order/chain and completed history. Phrase: breathing, blink and bounded calm tail; zero progression output.

### B — calm wait

Active order delivery state is `ready_to_send`, `delivery_confirmed == false`, Labrador has no current task. Phrase: calm wait oriented toward the Van/player gate; no urgency, blocked-task invention or auto-dispatch.

### C — station approach / locomotion corpus

- current task assignee is Labrador;
- task type is `CookTask` or `PackTask`;
- task status is `moving_to_source`;
- `current_phase.index == 0`, `dog_state == "walking"`;
- source/target station is Kitchen or Packing Table.

Start is phase entry; walk is the authoritative phase. Physical turn occurs only when requested direction changes from the last rendered facing and remains separate from mirror. Stop is the transition out of the phase. Velocity snap, sprite flip or arbitrary x-lerp is not evidence.

### D — contact-align

Same actor/task/station plus transition from phase `0` to `1`. Phrase: orient → approach → stop → one small contact/paw adjustment before station lock. Approach/contact/work/exit anchors come from accepted Art/Technical records and are never guessed from pixels.

### E — Kitchen station work

`CookTask`, Labrador assignee, Kitchen source/target, `status == "in_progress"`, phase `1`, `dog_state == "helping_kitchen"`, existing `start_cooking` intent.

Food Mix appears only through authoritative completing/on-complete behavior. Animation markers cannot create output.

### F — ordinary Packing Table work

`PackTask`, Labrador assignee, Packing Table source/target, `status == "in_progress"`, phase `1`, `dog_state == "packing"`, existing `start_packing` intent.

Food Bag appears only through authoritative completing/on-complete behavior.

### G — Day 2 careful/focus

All F predicates plus order `order.second_warm_delivery_careful_pack` and matching `labrador_packing_care_moment(order_id, task_id)`.

This is a bounded care/focus visual layer on the same PackTask. It is not quality, profit, XP, habit, reward or a second task and is absent outside the exact selector.

### H — ambient calm reposition / back-and-forth

**Amendment state:** Game Design accepted; Producer/PM and Technical/Codex readbacks pending. No Art/Technical executable binding is authorized until those readbacks are recorded.

All predicates below are required:

- actor is `dog.labrador_intro`, `visible == true`, `current_task == ""` and `current_visible_state == "idle"`;
- no queued or assigned task belongs to Labrador;
- journey condition is exactly one of:
  1. the existing active order is `offered`, its existing start-trip gate awaits player input, and no `TripTask` is current or queued; or
  2. restart-stable Quiet Cooperative: completed history exists and active order/active chain are empty;
- presentation phrase is `idle -> bounded start -> walk_empty -> optional physical turn on requested-direction change -> stop -> idle`.

`ready_to_send` always resolves to selector B calm wait; it never resolves to H. H is forbidden from authoritative TripTask/task/delivery creation through completion, while any task/order predicate mismatches, during restore until durable state readback is complete, and during save-barrier failure, Retry or recovery handling. A player action that starts the existing trip gate or changes an existing player gate cancels H before the authoritative transition.

H has no route endpoint, timing or cadence authority: those are Art/Technical inputs. It creates no task, event, resource movement, order/status change, save write, reward, progression, output or new player input. Facing/mirror is not evidence of physical turn; the turn remains a presentation transition. Any facing/direction cache is non-persisted presentation state and is never saved as gameplay state. On a missing/stale predicate, H fails closed to selector A idle.

## 4. Forbidden inference and fallback

- Proposed vocabulary or debug analog alone never authorizes a binding.
- Do not infer role, task ownership, weight, socket, station/prop anchor or facing from breed, pixels or current x-coordinate.
- No generic MouthHarness fallback.
- Sprite flip is not physical turn; velocity zero is not authored stop.
- No generic work loop without exact Kitchen/Packing selectors.
- No marker may advance task/status/order/resource/reward or create station output.
- No carry, pickup/attach, place/detach, Bicycle choreography, room/social action, Day 3 or extra player input.

## 5. Preserved contracts

- Gameplay input budget remains First Day `3`, Day 2 `2`.
- Resource provenance remains `x2/x2 → x1/x1` after First Day → persisted `x1/x1` Day 2.
- Quiet Cooperative has immutable history, empty active order/chain and no new progression.
- Godot runtime remains the only gameplay authority; presentation state is derived and non-persisted.

## 6. Signers

| Owner | State | Evidence |
| --- | --- | --- |
| Producer | accepted R48-05A core / selector H readback pending | Producer/PM convergence handback, 2026-07-12 |
| Game Designer | accepted selector H amendment | Game Design thread `019f57a6-d0c5-7aa0-a8ad-1b8bbb939938`, 2026-07-13 |
| Art Director | SOURCE-READY / source-level Art signed | R48-05A-S package; Art thread `019f5ad9-79c0-7b82-9964-3491f93bb7ff`, 2026-07-13; runtime Art PASS not claimed |
| Technical/Codex | accepted R48-05A core / selector H readback pending | Technical thread `019f57a6-da0c-7e00-a40e-a2e768247436`, 2026-07-13 |
| PM | accepted R48-05A core / selector H readback pending | implementation brief explicitly accepted/executable for core, 2026-07-13 |
