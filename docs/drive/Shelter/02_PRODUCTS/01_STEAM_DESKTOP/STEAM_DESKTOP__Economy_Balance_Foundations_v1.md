# STEAM_DESKTOP — Economy & Balance Foundations v1

Дата: 2026-06-30
Роль документа: Game Design / Systems Design Contract
Статус: draft v1
Продукт: Steam/Desktop idle always-on-top strip
Roadmap task: R-15 — Economy & Balance Foundations
Роль-владелец: Game Designer / Systems Designer

Основано на:

- `docs/drive/Shelter/00_START_HERE/03_PROJECT_PHILOSOPHY.md`
- `STEAM_DESKTOP__Game_Systems_Roadmap_v1.md`
- `STEAM_DESKTOP__Dog_Progression_Model_v1.md`
- `STEAM_DESKTOP__Ability_Source_Loop_v1.md`
- `STEAM_DESKTOP__Ability_Catalog_v1.md`
- `STEAM_DESKTOP__Dog_Life_Model_v1.md`
- `STEAM_DESKTOP__Building_System_v1.md`
- `STEAM_DESKTOP__Production_Chains_v1.md`
- `STEAM_DESKTOP__Laboratory_Research_Tree_v1.md`
- D-009, D-010, D-013, D-018, D-019, D-020

---

## 0. D-020 filter

### 0.1 How this system enriches cooperative life

Economy & Balance in Shelter should make the co-op richer as a place for dogs to live, work, learn, rest and help each other.

Economy exists to answer:

> What can the co-op do now that it could not do before?

Not only:

> Which number became larger?

### 0.2 D-020 layer

R-15 belongs to **ядро**.

Without economy and balance, Shelter loses:

- pacing;
- production meaning;
- route value;
- delivery cadence;
- dog progression pacing;
- research pacing;
- building growth;
- player reasons to return.

### 0.3 Guardrail against tamagotchi drift

Economy must support the production co-op core.

It must not become a life-needs simulator where the player maintains hunger, thirst, toilet, daily chores, sickness or absence guilt.

### 0.4 Guardrail against factory spreadsheet drift

Economy must not become only:

```text
resource -> machine -> resource -> bigger number
```

Every major economic loop should explain how it creates richer cooperative life.

---

## 1. Core principle

> Большинство idle-игр делают богаче склад.
>
> Shelter делает богаче жизнь.

Economy in Shelter is not only a resource economy.

Shelter has two intertwined economies:

1. **Economy of things** — physical resources and production outputs.
2. **Economy of life** — time, attention, trust, curiosity, comfort, inspiration, stories and opportunities.

Economy of things powers production.

Economy of life gives production emotional meaning.

---

## 2. What counts as wealth in Shelter

Main question:

> What makes the co-op richer?

Valid forms of wealth:

- new route;
- new delivery chain;
- new dog habit;
- new room;
- new building station;
- new helper effect;
- new research method;
- new postcard;
- new story;
- new cooperative routine;
- new dog friendship/mentorship opportunity;
- warmer rest / comfort activity;
- more reliable production flow;
- clearer planning;
- less friction in dog work;
- a dog feeling more at home.

Plain stockpile can be useful, but stockpile alone is not the main fantasy.

`1000 units of resource` is not automatically wealth unless it enables richer cooperative life.

---

## 3. Economy of things

Economy of things includes physical resources.

### 3.1 Material resources

Early resource categories:

- route ingredients;
- packaging materials;
- production outputs;
- delivery bundles;
- helper/equipment materials;
- room/building materials later;
- inspiration/tree materials later.

Examples:

- Oat Crate;
- Pumpkin Crate;
- Packaging Bag;
- Food Mix;
- Food Bag;
- ribbons / labels later;
- soft cloth / blanket material later;
- route finds later.

### 3.2 Rules

Material resources SHOULD:

- exist physically when relevant to active chain;
- move through dog action;
- create visible cause-and-effect;
- feed production chains;
- unlock choices, not only stockpile growth.

Material resources MUST NOT:

- dominate player-facing UI as spreadsheet;
- teleport through core chain;
- become paid pressure;
- punish players for not optimizing perfectly.

---

## 4. Economy of life

Economy of life is the unusual part of Shelter.

It includes non-money/non-stockpile values that make the co-op richer.

### 4.1 Dog time

Dog time is the primary scarce resource.

A dog cannot simultaneously:

- travel;
- unload;
- cook;
- pack;
- study;
- rest;
- mentor;
- care for tree.

Dog time creates meaningful choices without turning the player into a micromanager.

### 4.2 Dog attention

Attention is the focus a dog gives to one activity or place.

Attention matters for:

- learning;
- careful work;
- research rooms;
- mentorship;
- quality routines;
- support actions.

Attention SHOULD be soft and inspectable, not a hard stamina bar.

### 4.3 Trust / feeling at home

Trust is how much a dog feels like part of the co-op.

Trust can support:

- preference reveal;
- story moments;
- willingness to try new activity;
- comfort-based habits.

Trust MUST NOT become guilt pressure.

### 4.4 Curiosity

Curiosity fuels discovery.

Sources:

- routes;
- books;
- House of Curiosity rooms;
- strange finds;
- trees;
- dog traits.

Curiosity unlocks opportunities, not just research points.

### 4.5 Comfort / уют

Comfort is the co-op feeling like a good place to live.

Comfort supports:

- rest quality;
- long-task patience;
- room identity;
- care-based strengths;
- warm idle rhythm.

Comfort MUST NOT become mandatory decor power treadmill.

### 4.6 Inspiration

Inspiration comes from:

- trees;
- books;
- routes;
- postcards;
- notes;
- dog cooperation;
- discoveries.

Inspiration creates:

- training opportunities;
- new habits;
- research ideas;
- story events;
- cooperative moments.

### 4.7 Stories / memory

Stories are accumulated meaningful events.

Examples:

- dog completed first long route;
- dog taught a novice;
- dog discovered a fruit theme;
- delivery got a warm postcard;
- packing habit appeared.

Stories can unlock:

- archive entries;
- research nodes;
- dog card details;
- cooperative habits;
- room decoration meaning.

Stories are not just collectibles. They make the co-op feel lived in.

---

## 5. Balance objects

Balance should not start from final numbers.

It should start from balance objects — things that need pacing.

### 5.1 Route cadence

How often dogs leave and return.

Needs balance because:

- route creates material inflow;
- dog is unavailable while away;
- return creates visible activity spike;
- route familiarity supports progression.

Risk if too fast:

- strip becomes chaotic;
- route feels like resource faucet.

Risk if too slow:

- idle feels dead;
- player cannot see cause-and-effect.

### 5.2 Production throughput

How quickly resources become deliveries.

Needs balance because:

- production is core;
- dogs must visibly work;
- bottlenecks create decisions.

Risk if too fast:

- dog actions unreadable;
- production becomes invisible.

Risk if too slow:

- co-op feels stuck.

### 5.3 Dog learning pace

How often dogs gain habits/opportunities.

Needs balance because:

- habits are emotional rewards;
- too many habits become noise;
- too slow progression feels inert.

### 5.4 Research pace

How quickly House of Curiosity opens new life.

Needs balance because:

- research should unlock activities/routines;
- room assignment should matter;
- empty rooms must not feel punishing.

### 5.5 Room/building growth

How often new rooms/stations/upgrades appear.

Needs balance because:

- room growth makes co-op richer;
- too much room content can become The Sims;
- too little room content makes buildings feel like machines.

### 5.6 Delivery cadence

How often the co-op sends help.

Needs balance because:

- delivery is the emotional loop closure;
- postcard/reward moments need breathing room;
- charity tone must stay non-pressure.

---

## 6. Bottleneck philosophy

Bottlenecks are allowed.

But Shelter bottlenecks should feel like:

```text
the co-op is waiting calmly for the next helpful step
```

Not:

```text
the player failed optimization
```

### 6.1 Good bottlenecks

Good bottlenecks create choices:

- send dog on route or keep them in co-op;
- improve Storage flow or Kitchen routine;
- assign dog to classroom or packing;
- use rare inspiration now or save for shared opportunity;
- upgrade comfort or capacity.

### 6.2 Bad bottlenecks

Bad bottlenecks create pressure:

- hard fail timers;
- guilt text;
- hidden efficiency traps;
- rare resource mandatory walls;
- paid skip temptation;
- constant micro-management.

### 6.3 Calm blocked states

Blocked states should use calm language:

```text
Ждём тыкву.
Такса ещё в дороге.
Мешочек скоро будет готов.
В классе пока никого нет.
```

Avoid:

```text
FAILED
URGENT
INSUFFICIENT EFFICIENCY
DOG IDLE WASTED
```

---

## 7. Quality vs quantity

Shelter should balance quality as story warmth, not punishment.

### 7.1 Quantity

Quantity answers:

- how many resources;
- how many bags;
- how many deliveries;
- how many rooms/stations.

Quantity is necessary but not enough.

### 7.2 Quality

Quality answers:

- how carefully prepared;
- how warm the delivery felt;
- which dog contributed;
- which habit appeared;
- what story happened;
- whether the co-op feels more alive.

### 7.3 Quality tiers

Quality may exist, but avoid harsh failure framing.

Allowed examples:

- simple good delivery;
- neatly packed delivery;
- extra warm delivery;
- thoughtful delivery;
- story-rich delivery.

Avoid:

- failed delivery;
- bad dog result;
- low-tier shame;
- inefficient pack.

---

## 8. Core resource families

### 8.1 Production resources

Layer: ядро.

Purpose:

- feed production chains;
- create delivery outputs;
- make dog work visible.

Examples:

- ingredients;
- packaging;
- Food Mix;
- Food Bag.

### 8.2 Progression resources

Layer: ядро -> углубление.

Purpose:

- unlock dog habits;
- unlock research rooms/routines;
- expand buildings and stations.

Examples:

- activity experience;
- route familiarity;
- research ideas;
- inspiration themes;
- story milestones.

### 8.3 Comfort resources

Layer: углубление.

Purpose:

- make co-op feel better to live in;
- support rest/care/long-task rhythm;
- support room identity.

Examples:

- cozy room state;
- favorite spot;
- soft decoration;
- warm routine.

### 8.4 Atmosphere resources

Layer: атмосфера.

Purpose:

- create love, memory and observation value.

Examples:

- postcard archive;
- tiny gestures;
- dog toy memory;
- looking out window.

Atmosphere resources should rarely block core progress.

---

## 9. Player decision model

Player should make strategic/gentle decisions, not micro-decisions.

### 9.1 Good player decisions

- Which route should the co-op prepare for?
- Which dog should drive or help?
- Which room should receive attention?
- Should the co-op improve production flow or comfort?
- Which habit/opportunity should be encouraged?
- When to send delivery?

### 9.2 Bad player decisions

- Click every carry step.
- Assign every dog every few seconds.
- Optimize exact stat efficiency for every room.
- Babysit hunger/thirst/toilet.
- Respond to urgent guilt timers.

---

## 10. Idle rhythm

Idle in Shelter means life continues calmly.

### 10.1 What should happen while player is passive

- dogs continue current tasks;
- routes progress;
- production progresses if inputs/dogs are available;
- rooms may show life;
- low-pressure opportunities may appear;
- no guilt for absence.

### 10.2 What should not happen

- harsh failure;
- dog suffering;
- lost delivery due to absence;
- decay pressure;
- FOMO events;
- manipulative “come back or dogs lose” framing.

### 10.3 Return moment

When player returns, good state is:

```text
the co-op has done something, and there is something kind to notice or decide
```

Not:

```text
everything broke while you were gone
```

---

## 11. Economy loops

### 11.1 Core production loop

Layer: ядро.

```text
route
-> physical resources
-> dog production
-> delivery
-> postcard/reward/story
-> new opportunity
```

### 11.2 Dog growth loop

Layer: ядро.

```text
dog activity
-> activity experience
-> habit opportunity
-> learned habit
-> better/cozier future activity
```

### 11.3 Research/life unlock loop

Layer: ядро -> углубление.

```text
co-op event / dog curiosity
-> House of Curiosity room work
-> new activity/routine/helper
-> richer production or dog life
```

### 11.4 Comfort loop

Layer: углубление.

```text
room/decor/rest routine
-> comfort
-> calmer dog life
-> better long-term rhythm
-> richer co-op identity
```

### 11.5 Story loop

Layer: углубление / атмосфера.

```text
meaningful event
-> memory/postcard/archive
-> identity of co-op grows
-> future story or research opportunity
```

---

## 12. Early balance priorities

Do not tune exact final values yet.

Tune for these qualitative targets first:

1. Player sees physical cause-and-effect.
2. Dogs are visibly responsible for work.
3. Routes create anticipation but not dead time.
4. Delivery feels meaningful but not pressured.
5. Dog habits appear rarely enough to feel special.
6. Research unlocks new life, not just numbers.
7. Rooms enrich co-op without turning into mandatory life sim.
8. Materials matter but do not dominate emotional reward.
9. Bottlenecks create gentle choices.
10. Returning after idle feels warm, not punitive.

---

## 13. What to inspect in Workbench later

Future Workbench should expose economy/balance without becoming player UI.

Useful fields:

```text
resources
  physical_inventory
  active_chain_inputs
  active_chain_outputs

dogs
  current_activity
  time_allocation
  activity_experience
  habit_opportunities

production_chains
  state
  bottleneck
  current_step
  quality_state
  dogs_involved

buildings_rooms
  assigned_dogs
  queue_state
  comfort_state
  unlocked_routines

research
  room_progress
  active_unlocks
  dog_contributors

economy_life
  recent_stories
  inspiration_events
  comfort_events
  relationship_events

telemetry
  route_cadence
  delivery_cadence
  idle_duration
  blocked_state_frequency
  dog_idle_vs_work_time
```

This is not an immediate Codex task.

---

## 14. Anti-patterns

### 14.1 Factory spreadsheet anti-pattern

Symptoms:

- player mostly watches resource numbers;
- dog identity stops mattering;
- buildings feel like machines;
- research gives only stat bonuses;
- delivery is just output conversion.

### 14.2 Tamagotchi anti-pattern

Symptoms:

- player maintains hunger/thirst/toilet/sickness;
- absence creates guilt;
- dog needs become chores;
- production core becomes secondary;
- game becomes routine care simulator.

### 14.3 Gacha/rarity pressure anti-pattern

Symptoms:

- rare outcome required for progress;
- paid reroll temptation;
- low-rarity outcomes feel bad;
- dog worth depends on roll.

### 14.4 Over-micromanagement anti-pattern

Symptoms:

- every task needs click;
- every room slot needs exact assignment;
- player cannot let co-op live;
- idle is only fake.

---

## 15. Balance vocabulary

Prefer:

- rhythm;
- cadence;
- flow;
- opportunity;
- warmth;
- reliability;
- readiness;
- comfort;
- story richness;
- co-op depth.

Use carefully:

- efficiency;
- throughput;
- output;
- optimization;
- conversion.

Avoid player-facing:

- productivity unit;
- worker efficiency;
- low-tier dog;
- failed dog;
- wasted idle;
- mandatory upkeep.

---

## 16. Out of scope

This document does not define:

- exact numeric balance;
- final timers;
- final economy tables;
- monetization prices;
- real charity accounting;
- production implementation;
- Workbench Codex brief;
- State Connector schema changes;
- UI art/layout.

---

## 17. Open questions

1. What are the first 5 material resource families after Vertical Slice?
2. What is the first non-food delivery chain?
3. How often should deliveries complete in early game?
4. How often should dog habits appear?
5. Should comfort be a visible meter, hidden state, or qualitative room state?
6. Should trust be tracked numerically or through story milestones?
7. How many bottlenecks can exist before the game feels blocked?
8. Which economy-of-life values need Workbench inspection first?
9. How do we balance room assignments without creating worker-slot spreadsheets?
10. What should offline/away progress mean ethically and emotionally?
11. Which systems are core enough for First Day MVP?
12. Which systems should remain atmosphere until after core validation?

---

## 18. Acceptance criteria

R-15 is complete enough to move to Core Gameplay Loop Validation when:

1. Economy is framed as economy of things + economy of life.
2. Wealth in Shelter is defined as richer co-op life, not only stockpile.
3. Core balance objects are defined.
4. Bottleneck philosophy is calm and non-punitive.
5. Quality vs quantity is defined.
6. Core resource families are separated by D-020 layer.
7. Player decision model avoids micromanagement.
8. Idle rhythm avoids guilt/FOMO/tamagotchi patterns.
9. Economy loops are listed.
10. Workbench inspection needs are sketched without immediate Codex task.
11. Anti-patterns are documented.
12. Open questions are listed.

---

## 19. Next recommended document

Next Game Designer task:

```text
STEAM_DESKTOP__Core_Gameplay_Loop_Validation_v1.md
```

Purpose:

Validate that R-09..R-15 form a coherent production co-op core under D-020 and do not drift into factory spreadsheet or tamagotchi/life-sim.

---

## 20. Changelog

### 2026-06-30 — v1 created

- Created Economy & Balance Foundations v1.
- Defined economy of things and economy of life.
- Defined Shelter wealth as richer co-op life, not only stockpile.
- Added balance objects, bottleneck philosophy, quality model, economy loops and anti-patterns.
- Added Workbench inspection direction for economy/balance.
