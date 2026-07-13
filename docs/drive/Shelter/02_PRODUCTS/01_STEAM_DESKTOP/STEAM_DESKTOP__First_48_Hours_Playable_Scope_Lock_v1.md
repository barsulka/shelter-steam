# STEAM_DESKTOP — First 48 Hours Playable Scope Lock v1

Дата: 2026-07-12

Статус: accepted / executable program scope lock

Владельцы: Producer / Game Designer / Art Director / Project Manager

Decision: D-023

Roadmap: `STEAM_DESKTOP__First_48_Hours_Playable_Roadmap_v1.md`

Продукт: Shelter Steam/Desktop

---

## 0. Цель

Превратить уже доказанные First Day и Day 2 runtime-сценарии в один честный player journey:

```text
ordinary F5 / steam/play.sh / internal export
→ clean player entry
→ First Day at normal 1x
→ few meaningful confirmations
→ dogs perform visible physical work
→ safe background coexistence
→ autosave / close
→ ordinary Continue
→ persisted First Day traces + Day 2
→ one living Labrador
→ one inspectable Kitchen
→ complete second delivery
→ Quiet Cooperative
→ restart preserves the same world
```

Этот scope lock не объявляет production art, shipping UX, Steam integration, external beta readiness, First Week completion или First Month implementation.

---

## 1. Product promise

> Я несколькими понятными решениями влияю на тёплый собачий кооператив. Собаки сами спокойно выполняют физически видимую работу. Я могу оставить игру рядом, заняться своими делами и вернуться без потерь, чувства вины или обязанности играть.

Mandatory qualities:

- influence without microtask management;
- dog-owned physical causality;
- quiet periods dominate;
- no urgency, loss, guilt or absence punishment;
- session history leaves visible personal traces;
- ordinary launch and restart are part of the experience.

---

## 2. Canonical readiness label

Internal program name:

```text
First 48 Hours Playable
```

Canonical build label before Windows smoke:

```text
macOS-only internal First Day + Day 2 playable
(session-based continuation, prototype visual level; not Steam/release ready)
```

`First 48 Hours` does not mean real elapsed calendar hours. After real Windows smoke the label may become `Windows/macOS internal First Day + Day 2 playable`; this still does not imply shipping readiness.

---

## 3. Player-owned input budget

### First Day — exactly three required gameplay confirmations

1. Start the accepted Oat Farm trip.
2. Confirm dispatch after the Food Bag is visibly loaded.
3. Equip Comfortable Slippers on Dachshund after the first delivery response.

There is no separate required order-accept click.

### Day 2 — exactly two required gameplay confirmations

1. Start the familiar Oat Farm trip for the Day 2 order.
2. Confirm dispatch after the second Food Bag is visibly loaded.

### Optional interactions

- inspect Postcard;
- inspect Dog Card memory;
- open/close Kitchen detail;
- inspect progress note;
- inspect the question `Как паковать мягче?`.

Optional interactions MUST NOT block completion, autosave or Quiet Cooperative.

Dogs/world own all accepted TripTask execution, unload, carry, cook, pack, load, DeliveryTask execution, Labrador careful-packing cue and non-reward Day 2 feedback sequence.

No carry/cook/pack/load microtask confirmation, assignment click, repeated work click or hold-to-work input is allowed. At most one primary progression cue exists at a time; every player gate waits indefinitely.

---

## 4. Calm onboarding

1. Fresh entry shows the living strip and one Road Sign/order cue with `Начать поездку`.
2. After confirmation the cue becomes quiet; physical dog actions explain the chain.
3. No required clicks occur while dog-owned work proceeds.
4. When the Van is visibly ready, one calm persistent `Отправить поставку` cue appears without pulsing urgency.
5. First Day delivery reveals the Postcard/life moment and the single required slippers-equip action.
6. After equip, the world shows a generic next-visit tease. The exact question `Как паковать мягче?` is reserved for after Day 2 completion.
7. Day 2 does not replay the tutorial; persisted traces and one familiar trip cue are enough.
8. After Day 2 the primary progression cue disappears and Quiet Cooperative begins.

Forbidden: modal tutorial wall, checklist, forced camera interruption, dismiss-to-proceed tooltip, multiple competing primary prompts, auto-dispatch and urgency language.

---

## 5. Narrative session-day semantics

`Day 2` means the next player session after a fully completed First Day, not the next calendar date.

First Day fully complete requires:

```text
delivery_complete
postcard life moment seen
Comfortable Slippers equipped
memory added
next-visit hint available
```

Rules:

- close/restart before that boundary resumes First Day;
- keeping the app open after completion stays in a calm First Day hold;
- the first ordinary Continue after a completed First Day creates Day 2 exactly once;
- immediate close/reopen is a valid return;
- restart during Day 2 resumes the same Day 2;
- restart after Day 2 returns to Quiet Cooperative;
- wall clock, timezone and elapsed closed-app duration never advance the journey.

Preferred copy uses `в следующий раз` / `в прошлый раз` instead of promising a literal calendar tomorrow/yesterday.

---

## 6. Honest consumable provenance

Fresh First Day Storage contains:

```text
Protein Packet x2
Packaging Bag x2
```

First Day physically consumes one unit of each. Day 2 consumes the persisted remainder:

```text
Protein Packet x1
Packaging Bag x1
```

The First Day → Day 2 transition MUST NOT create, refill, replenish, reward or teleport either resource. The existing Day 2 fixture `x1/x1` state remains a dev/regression projection of this honest remainder.

---

## 7. Focus, minimize and closed-app behavior

### Focused open

- normal safe 1x simulation;
- confirmed dog-owned work progresses;
- player gates wait indefinitely.

### Visible-unfocused / occluded

- same safe 1x gameplay policy;
- focus state does not grant or cancel progress;
- no confirmation occurs automatically.

### Minimized / OS-suspended

- runtime may pause or slow;
- no loss, penalty or auto-dispatch;
- restore produces no wall-clock catch-up or burst.

### Closed

- simulation is frozen;
- no tasks, trips, resources, rewards, decay or penalties progress;
- reopen resumes an accepted safe checkpoint;
- the one-time completed-First-Day → Day-2 transition is a session rule, not offline simulation.

---

## 8. Persistence contract boundary

Accepted persistence level:

- versioned player save under `user://`;
- strict schema validation;
- transactional replace plus last-known-good recovery;
- player/dev save namespaces separated;
- autosave at accepted stable checkpoints;
- idempotent process restart;
- corrupt/incompatible recovery path;
- New Game never silently overwrites an existing valid profile.

Accepted resume model: `safe-checkpoint restore`.

If the app closes during dog-owned work, Continue may replay a small amount of automatic work from the last stable checkpoint, but MUST NOT lose/duplicate resources, events, rewards or player decisions.

Exact in-flight task resume is out of scope unless a later brief adds a separate idempotency contract and tests.

---

## 9. Persisted Day 2 transition

Player path MUST NOT load `second_day_after_first_delivery` fixture.

The existing runtime remains the only gameplay authority and performs an idempotent same-runtime transition after accepted preconditions:

- fully completed First Day;
- no active/queued task at the transition boundary;
- accepted journey phase;
- persisted `Protein Packet x1` and `Packaging Bag x1` remainder.

The transition preserves immutable First Day history, creates exactly one accepted Day 2 order/chain, preserves Postcard/slippers/memory/packing note, records a persisted transition marker and saves immediately. Restart MUST NOT duplicate order, chain, stock or events.

The fixture remains a dev oracle for regression equivalence, not an implementation source.

---

## 10. Quiet Cooperative after Day 2

Accepted user choice: A.

After Day 2 progress note and optional question:

- completed Day 2 order/chain remain in immutable journey history;
- after the post-feedback transition the active-order/active-chain slots are empty;
- no Day 3 is created;
- persistent traces remain inspectable;
- dogs use only accepted non-progression idle/wait/rest/reposition presentation phrases;
- no resources, rewards, XP, memory, habit, quality, research or timer result is created;
- close/reopen returns to the same quiet state.

Suggested calm copy:

```text
На этот раз всё. Кооператив отдыхает. Можно вернуться, когда удобно.
```

Quiet Cooperative is not a repeatable order loop.

---

## 11. First living dog

Accepted first living runtime character: Labrador (`P0`).

Minimum life-kernel:

- quiet idle/wait;
- start → walk → stop;
- physical turn;
- approach/contact-align;
- station-work;
- bounded careful/focus layer only during accepted Day 2 PackTask `in_progress`.

Execution is split without weakening the full program:

- `R48-05A / P0-B + P0-D` — authored world, Labrador idle/wait/locomotion/physical-turn/contact-align and existing Kitchen/Packing station work, with no object transfer. R48-05A PASS leaves parent R48-A/R48-05 at `PARTIAL / WARN`.
- `R48-05B / P0-C` — later exactly one accepted named-prop pickup/attach/carry/place/detach choreography after a full weight/mode/socket/source/target/anchor contract. Only R48-05B PASS closes full R48-A/R48-05.

The source-only Art Package for world/Labrador/station anchors may precede R48-05A runtime work. `SOURCE-READY` is not runtime Art PASS and does not make the Codex brief executable by itself.

Runtime state remains sole gameplay authority. Animation observes task state and cannot create a second simulation. Dachshund does not become a mandatory second fully animated character in this program; existing First Day driver/reward semantics remain intact.

---

## 12. First inspectable room

Accepted user choice: A — Kitchen remains mandatory `P1` in Program DoD.

Product boundary:

- one same-window detail surface;
- same live Godot state;
- one actual dog presence and one existing Kitchen station;
- simulation continues while open;
- no duplicated dog between strip and room;
- close/reopen preserves parity;
- empty/idle/busy/output are visual presentations of existing state, not new runtime states.

Exact modal/side-panel composition is an Art/UX + Technical implementation choice inside an accepted brief. Native secondary-window scope is not accepted.

No new recipe, resource, task, assignment, need, decor economy, upgrade, research or room-management mechanic is added.

---

## 13. Visual maturity boundary

Required level is coherent authored prototype runtime foundation, not final production art.

- authored source/export and imported runtime evidence are separate maturity stages;
- Sheet A/B remain PREVIEW_RESEARCH_ONLY references and QA evidence;
- their pixels/palette/texture are not runtime production sources;
- standalone demo evidence cannot close this program;
- runtime readback must come from the ordinary First Day/Day 2 player layout;
- mechanical validators cannot self-approve aesthetics;
- native 216/144/96 evidence and Art WARN/PASS are required.

---

## 14. Implementation sequence

```text
R48-01A Playable Main Scene And Launch Surfaces
→ R48-02A Player Save Store Schema And Recovery
→ R48-02B Runtime Safe Checkpoints And Continue
→ R48-03 Persisted Day 1 To Day 2 Return
→ R48-05A-S Art Source Package: world + layered Labrador + station anchors
→ R48-05A Playable World And First Living Labrador foundation (no transfer; parent PARTIAL/WARN)
→ R48-04B Calm Non-Modal Onboarding And Quiet Cooperative
→ R48-06 First Inspectable Kitchen
→ R48-07 Game-First Two-Visit Polish
→ later R48-05B One Named Object Transfer (closes full R48-A/R48-05)
→ later R48-04A Background/Minimize/Performance Evidence
→ Full Program Acceptance
```

Entry and save may be designed in parallel, but their acceptance closes jointly. Shared-checkout implementation uses one sequential integrator.

---

## 15. Hard out of scope

- real calendar/day rollover;
- offline progression/reward/penalty;
- Day 3+ or seven implemented days;
- First Month;
- repeatable/infinite order generator;
- new route/resource/station/recipe/order family;
- active habit/research/quality/economy;
- full 67-ID dog vocabulary;
- second fully animated dog requirement;
- multiple rooms or room management;
- rocking chair/read/study/social activities;
- Bicycle ride/tow/hitch/sidecar choreography;
- final production style lock;
- Steam integration/release packaging;
- MCP/security work unless it directly blocks the player journey.

---

## 16. Program Definition of Done

- [ ] F5, `steam/play.sh` and internal export enter one clean player journey.
- [ ] `steam/dev.sh` cleanly owns developer routing; player path accepts no fixture/control/debug/time semantics.
- [ ] Fresh profile completes First Day at normal 1x with exactly three required gameplay confirmations.
- [ ] Autosave/Continue survives process restart without duplicate state.
- [ ] Ordinary Continue creates Day 2 exactly once without loading fixture.
- [ ] Day 2 uses persisted `x1/x1` remainder and completes with exactly two required confirmations.
- [ ] Visible-unfocused safe simulation and minimized pause/slow policy pass native evidence without catch-up burst.
- [ ] Labrador is a living authored current character in the same runtime.
- [ ] One inspectable Kitchen uses the same runtime and does not duplicate the dog.
- [ ] Day 2 ends in restart-stable Quiet Cooperative with no new order/progression.
- [ ] First Day/Day 2 causality regressions remain green.
- [ ] Save corruption/recovery and process-restart matrices pass.
- [ ] Native 216/144/96 Art evidence is accepted at prototype level.
- [ ] 30–60 minute macOS internal background/performance evidence is recorded.
- [ ] Build uses the honest readiness label and makes no First Week/Month/shipping claim.

---

## 17. Stop conditions

Stop and return to the owning role if implementation requires:

- another task/order/resource simulation;
- loading a dev fixture from player path;
- hidden resource refill;
- exact in-flight resume without accepted idempotency contract;
- calendar/offline progression;
- new mechanics, route, resource, task, room or reward;
- unknown dog action/prop/socket/station/anchor;
- PREVIEW_RESEARCH_ONLY pixels promoted to runtime source;
- native secondary-window scope;
- weakening exact `3 + 2` input budget;
- penalties, urgency, auto-dispatch, FOMO or guilt;
- broader platform/readiness claim than actual evidence.

---

## 18. Relationship to existing contracts

This scope lock requires narrow synchronization:

- First Day starting Protein/Packaging reserve becomes `x2/x2`;
- exact `Как паковать мягче?` question moves to post-Day2 only; First Day retains a generic next-visit tease;
- D-022 Day 2 fixture remains `x1/x1` and its causal contract remains unchanged;
- First Day completion continues to require slippers equip, memory and next-visit hint;
- OQ-Steam-003 remains a separate production-art gate.

No other First Day/Day 2 task, object, dog assignment, order or reward responsibility changes.

---

## 19. Changelog

### 2026-07-12 — game-first sequence and Labrador split

- Synchronized the user-selected game-first order and moved R48-04A after the visible-game critical path.
- Split Labrador/world work into no-transfer R48-05A and later one-transfer R48-05B.
- Preserved one object transfer as mandatory for full parent/program closure.

### 2026-07-12 — v1 accepted

- Recorded D-023 and user acceptance A/A/A.
- Locked the session-based First Day + Day 2 player journey, exact input budget, persisted reserve, safe background/closed behavior, Labrador P0, Kitchen P1 and Quiet Cooperative.
- Preserved existing D-022 causality and separated the new player journey from calendar/offline/First Week/Month/release scope.
