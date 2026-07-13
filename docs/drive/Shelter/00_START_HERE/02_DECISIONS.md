# 02_DECISIONS — Shelter Decision Log

Обновлено: 2026-07-13
Статус: active knowledge / decision log
Владелец: Producer / Project Manager
Назначение: хранить принятые долгоживущие решения Shelter. История обсуждений, handoff и evidence живут в History-документах.

---

## 0. Read policy

Этот документ — источник принятых решений, но не полный исторический журнал.

Default use:

```text
Read by task when decisions are needed.
For quick entry, use BOOTSTRAP_CONTEXT.md and current-context docs first.
For implementation history, use CODEX_CURRENT_STATUS.md / CODEX_STATUS.md and relevant handoff.
```

Правило cleanup:

- не менять смысл решений без нового explicit product/process decision;
- не добавлять новые решения из cleanup-сессии;
- если старое решение уточнено новым решением, не удалять его, а указывать relationship;
- если подробная история важна, ссылаться на source docs / handoff вместо раздувания decision entry.

---

## 1. Decision index

| ID | Title | Kind | Area | Status |
| --- | --- | --- | --- | --- |
| D-001 | Google Drive / local knowledge base | process | docs | accepted |
| D-002 | GitHub repo as development source of truth | process | dev/docs | accepted |
| D-003 | Serious sessions start from local project docs | process | docs | accepted / updated by governance |
| D-004 | Codex requires `AGENTS.md` | process | Codex | accepted |
| D-005 | Shelter tone and ethics | ethics/product | all | accepted |
| D-006 | Three-product family | product | all | accepted |
| D-007 | Steam/Desktop engine: Godot | technical/product | Steam | accepted |
| D-008 | Browser Extension core loop | product/game design | Browser | accepted |
| D-009 | Steam/Desktop horizontal dog production co-op | product/game design | Steam | accepted |
| D-010 | Dog traits: innate vs changeable | game design | all/Steam | accepted |
| D-011 | Visual Direction Candidate A: Cozy Modular Diorama | art/product | all/Steam/Browser | accepted as candidate |
| D-012 | Shared World: Browser Farm supplies Steam Co-op | product/world | Steam/Browser | accepted |
| D-013 | Steam resource trips replace visible crop farming | product/game design | Steam | accepted |
| D-014 | Role boundaries and working roadmaps | process | all roles | accepted |
| D-015 | Cross-role collaboration via RFC documents | process | all roles | accepted |
| D-016 | Steam Vertical Slice: Codex implementation boundaries | process/dev | Steam/Codex | accepted |
| D-017 | Codex tasks require brief files in `04_DEVELOPMENT/` | process/dev | Codex | accepted |
| D-018 | Vertical Slice gameplay proof is enough for Game Designer systems branch | product/process | Steam | accepted |
| D-019 | Game Design Systems Workbench over live Godot runtime | technical/process | Steam/Codex | accepted |
| D-020 | Project Philosophy / Shelter Constitution | philosophy/product | all | accepted |
| D-021 | ChatGPT Work local project and Shelter MCP boundary | process/dev tooling | docs/Codex/MCP | accepted |
| D-022 | Steam/Desktop Day 2 executable scope lock | product/game design | Steam | accepted |
| D-023 | Steam/Desktop First Day + Day 2 player journey scope lock | product/game design | Steam | accepted |

---

## 2. Accepted decisions

### D-001 — Google Drive / local knowledge base

Дата: early project setup
Kind: `process`
Area: `docs`
Status: `accepted`

Summary:

> Product documents, research, design, session logs, financial/charity plans and long-term project memory live in the Shelter knowledge base.

Decision:

Shelter keeps long-lived knowledge in local/project documentation. Google Drive was the original project knowledge-base metaphor, and the local repository mirror is now the operational source for AI sessions that can read/write project files.

Current relationship:

```text
Local Shelter repo is the working source of truth for this ChatGPT/Codex workflow.
```

Related:

```text
PROJECTS_RULES.md
AGENTS.md
00_START_HERE/05_DOCUMENTATION_GOVERNANCE.md
```

---

### D-002 — GitHub repo as development source of truth

Kind: `process`
Area: `dev/docs`
Status: `accepted`

Summary:

> Code, development docs, ADRs, build/test instructions and Codex working status live in the repository.

Decision:

Development truth lives in the Git repository. ChatGPT Work and Codex read and edit the current local checkout directly. Shelter MCP's local domain-specific boundary is defined by D-021.

Related:

```text
README.md
AGENTS.md
docs/repo/status/CODEX_CURRENT_STATUS.md
docs/repo/adr/README.md
```

---

### D-003 — Serious sessions start from local project docs

Kind: `process`
Area: `docs`
Status: `accepted / updated by documentation governance`

Summary:

> Serious Shelter sessions must restore context from local documents, not chat memory.

Decision:

A new serious session starts from local project docs and the relevant role/current-context docs.

Current reading model:

```text
Current Memory first.
Knowledge by task.
History only for evidence / regression / archaeology.
```

Current entry sources:

```text
PROJECTS_RULES.md
AGENTS.md
README.md
docs/drive/Shelter/00_START_HERE/BOOTSTRAP_CONTEXT.md
role doc
relevant current-context doc
```

Related:

```text
00_START_HERE/05_DOCUMENTATION_GOVERNANCE.md
00_START_HERE/SUPERSEDED_MAP.md
00_START_HERE/EVIDENCE_READ_POLICY.md
```

---

### D-004 — Codex requires `AGENTS.md`

Kind: `process`
Area: `Codex`
Status: `accepted`

Summary:

> Codex must work under repo-level agent rules, not just chat instructions.

Decision:

The repo must contain `AGENTS.md` with project constraints, source-of-truth rules, dev process, test/check expectations, documentation duties and role boundaries.

Related:

```text
AGENTS.md
000_ROLE_CODEX.md
```

---

### D-005 — Shelter tone and ethics

Kind: `ethics/product`
Area: `all`
Status: `accepted`

Summary:

> Shelter is kind, calm, ethical and dog-first. Monetization and charity must never pressure the user.

Decision:

Shelter must not use guilt pressure, manipulative charity prompts, exploitative mechanics, aggressive FOMO or hostile monetization. Charity/monetization scenarios must be transparent, voluntary and respectful.

Forbidden patterns:

```text
battles, PvP, bosses, monsters, paid gacha, aggressive FOMO, guilt pressure, forced donation framing, dark patterns
```

Related:

```text
03_PROJECT_PHILOSOPHY.md
04_SHELTER_STRESS_TESTS.md
```

---

### D-006 — Three-product family

Kind: `product`
Area: `all`
Status: `accepted`

Summary:

> Shelter is a family of three possible products: Steam/Desktop, Mobile and Browser Extension.

Decision:

Initial product family:

1. Desktop/Steam idle game for Windows/macOS.
2. Mobile idle/farm game.
3. Browser Extension: “посмотри рекламу → накорми собак”.

Current focus:

```text
Steam/Desktop is the active product focus.
```

Related:

```text
01_CURRENT_STATUS.md
STEAM_DESKTOP__CURRENT_CONTEXT.md
03_OPEN_QUESTIONS.md
```

---

### D-007 — Steam/Desktop engine: Godot

Kind: `technical/product`
Area: `Steam`
Status: `accepted`

Summary:

> Godot is the engine for the Steam/Desktop Windows/macOS game.

Decision:

Steam/Desktop uses Godot 4.x as the primary game engine. Start with GDScript for core gameplay logic. Use C# or GDExtension only where real need appears: Steamworks, native OS window APIs, performance-sensitive systems or platform integration.

Rationale:

Godot fits a small 2D desktop-first idle game with possible always-on-top strip/window behavior, transparency, UI hiding and slow visible character actions, without the licensing/production complexity of heavier engines.

Current relationship:

```text
Godot prototype and tooling already exist.
```

Related:

```text
docs/repo/adr/0001-use-godot-for-steam-desktop.md
CODEX_CURRENT_STATUS.md
CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md
```

---

### D-008 — Browser Extension core loop

Дата: 2026-06-24
Kind: `product/game design`
Area: `Browser`
Status: `accepted at product-loop level`

Summary:

> Browser Extension uses a calm new-tab farm loop where sponsorship/ad block helps accumulate sending resources without guilt pressure.

Decision:

Browser Extension core loop:

```text
sponsored farm → food production → van delivery to shelter
```

The user opens a new tab, sees search/new-tab utility, a calm sponsorship/ad block and a living top-down idle farm. The farm produces food; dogs perform peaceful visible work; sponsor/ad interactions help accumulate delivery resources; user can make short visits, collect results, choose improvements and send a van to a shelter.

Ethical constraints:

- ads do not block core gameplay;
- no guilt pressure;
- no “watch this or dogs suffer” framing;
- correct tone is gratitude and transparency.

Still open:

```text
privacy, ad SDKs, Chrome Web Store rules, charity reporting, claims and partner-shelter model
```

Related:

```text
03_OPEN_QUESTIONS.md
```

---

### D-009 — Steam/Desktop horizontal dog production co-op

Дата: 2026-06-24
Kind: `product/game design`
Area: `Steam`
Status: `accepted`

Summary:

> Steam/Desktop is a cozy idle production strip + dog community sim, not a classical farm or cold factory.

Decision:

Steam/Desktop is a horizontal sidescroll always-on-top dog production cooperative for Windows/macOS.

Core formula:

```text
cozy idle production strip + dog community sim
```

The player gently organizes a living cooperative: zones, priorities, recipes, dog assignments, process improvements, decorations and rooms. Dogs visibly live and work: moving, carrying, cooking, packing, loading, resting, interacting and returning from trips.

Main layers:

- production line / cooperative work;
- dogs as named residents with characters and preferences;
- planned gentle deliveries to shelters;
- letters, postcards and gratitude without guilt pressure;
- long-term growth through buildings, recipes, research, routes, transport, rooms and dog stories.

Forbidden:

```text
combat, PvP, monsters, bosses, paid gacha, Steam ad monetization, slaughter/meat-cruelty chains, manipulative charity, guilt timers, exploitative dog-worker framing
```

Related:

```text
STEAM_DESKTOP__CURRENT_CONTEXT.md
03_PROJECT_PHILOSOPHY.md
```

---

### D-010 — Dog traits: innate vs changeable

Дата: 2026-06-24
Kind: `game design`
Area: `all/Steam`
Status: `accepted`

Summary:

> A dog is a character, not a rerollable stat bundle. Innate traits are permanent; equipment/acquired traits are changeable.

Decision:

Dog characteristics are split into:

1. **Innate / unchangeable traits** — part of identity. The player cannot remove, reroll, replace or “reforge” them.
2. **Changeable / equippable / acquired traits** — items, room comfort, training, favorite tools, habits, slippers, collars, work accessories, decorative effects and learned memories.

Design rule:

Changeable traits can strengthen, tint or guide innate individuality, but must not erase it.

Example:

```text
A dog with “fast paws” remains fast-pawed; comfortable slippers can make that trait more expressive.
```

Related:

```text
STEAM_DESKTOP__CURRENT_CONTEXT.md
```

---

### D-011 — Visual Direction Candidate A: Cozy Modular Diorama

Дата: 2026-06-25
Kind: `art/product`
Area: `all/Steam/Browser`
Status: `accepted as candidate, not final art bible`

Summary:

> Cozy Modular Diorama is the main visual direction candidate, pending style board, readability and production-cost validation.

Decision:

Shelter uses Cozy Modular Diorama as the primary candidate direction: a small modular dog cooperative of rooms, greenhouses, kitchens, storage, dog houses and vans where dog residents visibly do kind shared work.

It must support two projections:

1. Steam/Desktop — side/cutaway modules for horizontal always-on-top production strip.
2. Browser Extension — top-down / 3⁄4 farm for Chrome new-tab idle farm.

Required before final visual lock:

- style board;
- readability tests at 96 px, 144 px and 216 px for Steam strip;
- production cost check;
- Steam + Browser compatibility check;
- support for many breeds and dog individuality.

Dog room rule:

Dog rooms are a key visual carrier of personality, affection, joy and small reasons to return. They must not become a hard min-max power system.

Overlay asset taxonomy update:

Before generating or assigning overlay assets, classify each as:

1. **Building** — rare large strip anchor.
2. **Utility Prop** — functional object / pause / support prop; must not become a house.
3. **Dog Action Sprite** — readable dog action with object.

Rule:

```text
Buildings are rare anchors. Most visible work should be utility props and dog actions, not a dense village of tiny houses.
```

Related:

```text
D-011_Cozy_Modular_Diorama_Candidate_A.md
D-011_Steam_Overlay_Main_Strip_v1_Rules.md
DOG_VISUAL_LANGUAGE_v1.md
```

---

### D-012 — Shared World: Browser Farm supplies Steam Co-op

Дата: 2026-06-25
Kind: `product/world`
Area: `Steam/Browser`
Status: `accepted`

Summary:

> Browser Extension and Steam/Desktop are two parts of one dog world, not two versions of the same game. MVP connection is narrative-only.

Decision:

Shelter products share a world:

- Browser Extension — real top-down farm in a new tab where resources are grown, gathered and prepared.
- Steam/Desktop — horizontal dog cooperative/workshop where resources arrive, are processed into food/help goods and sent to shelters.

Visual/world connection:

Dog bicycles, cargo bikes, trailers, small vans, trucks, crates, postcards and shared asset language connect farms, cooperative and shelters.

MVP rule:

```text
Connection is narrative-only.
Steam must not require the Browser Extension.
Browser Extension must not be required for Steam progress.
```

Possible evolution:

1. Narrative link — products are independent, but refer to the same world.
2. Soft connection — postcards, cosmetic crates, stickers, van names, dog album, light reports.
3. Real sync only after proven interest — shared account, resource deliveries, cross-product events.

Forbidden:

```text
mandatory cross-product funnel, punishment for using only one product, hard-gated progress across products
```

---

### D-013 — Steam resource trips replace visible crop farming

Дата: 2026-06-25
Kind: `product/game design`
Area: `Steam`
Status: `accepted`

Summary:

> Steam/Desktop does not use classical visible crop farming as core. Raw resources arrive through off-screen dog trips and physical unloading.

Decision:

Steam/Desktop is a cooperative/workshop, not a visible crop-farming strip.

Base trip loop:

1. At strip edge, there is a road sign and transport.
2. Player chooses route, driver, optional passengers and transport.
3. Transport leaves screen.
4. Timer appears near the road sign.
5. Dogs return and physically unload crates into storage.

Transport progression:

```text
basket bicycle → cargo bicycle → bicycle with trailer → small van → truck
```

Route + transport + dog + passengers + traits affect duration, capacity, reward categories and possible extra finds.

Random rewards rule:

Randomness is allowed only as joy, not paid gacha or pain. No paid attempts, paid rerolls, pressure, or rare finds that become mandatory progression blockers.

D-010 applies to trips: equipment can enhance role expression but not erase dog identity.

---

### D-014 — Role boundaries and working roadmaps

Дата: 2026-06-29
Kind: `process`
Area: `all roles`
Status: `accepted`

Summary:

> Roles have explicit boundaries, and working roadmaps guide series of tasks without becoming product decisions by themselves.

Decision:

Role boundaries:

- Producer — product frame, priorities, scope, product decisions, ethical boundaries and cross-role alignment.
- Project Manager — docs sync, decision log, open questions, handoff, role-boundary control and roadmap hygiene.
- Game Designer — mechanics, economy structures, resources, production chains, progression, dog traits, balance, player goals, retention and UX logic.
- Art Director — visual direction, style board, art bible, UI look, asset style, palette, readability, prompts, animation visual language and visual QA.
- Codex — implementation, local repo changes, tests/checks, dev docs/status and technical constraints.

Roadmap rule:

Roadmap is a living work plan, not a bible and not a product decision by itself. Major roadmap changes need a reason and should be reflected in changelog, handoff or update note.

Related:

```text
000_ROLE_*.md
KNOWLEDGE_BASE_ROADMAP.md
```

---

### D-015 — Cross-role collaboration via RFC documents

Дата: 2026-06-29
Kind: `process`
Area: `all roles`
Status: `accepted`

Summary:

> Cross-role work should happen through local RFC documents, not copied long chat prompts.

Decision:

Shelter uses `04_COLLABORATION_PROTOCOL.md` with three collaboration levels:

1. Quick Role Check.
2. Cross-role RFC.
3. Decision Council.

A draft synthesis is not another role’s real position. A role has spoken only when it fills its section or Producer explicitly accepts a decision.

RFC is not a decision by itself. It becomes decision only after Producer synthesis / user acceptance and updates to long-lived docs.

First RFC:

```text
06_SESSIONS_AND_HANDOFFS/cross_role_sessions/2026-06-29__cross_role_rfc__codex_task_boundaries_steam_vertical_slice.md
```

---

### D-016 — Steam Vertical Slice: Codex implementation boundaries

Дата: 2026-06-29
Kind: `process/dev`
Area: `Steam/Codex`
Status: `accepted`

Summary:

> Codex implements contracts and may use technical judgement for prototype implementation, but must not silently change gameplay, product, visual or ethical meaning.

Decision:

Codex may independently choose internal Godot structure, scene/script split, data representation, deterministic prototype scheduler/state machine, dev-only debug tools, semantic labels, smoke commands, timing compression for debug/review, neutral placeholders and bug fixes where implementation diverges from written contracts.

Codex must return questions to:

- Game Designer — mechanics, task flow, resources, player actions, visible cause-and-effect, Dog Card meaning, acceptance criteria.
- Art Director — final style, palette, UI look, dog look, asset taxonomy, unapproved assets, readability problems hiding gameplay meaning.
- Producer — Vertical Slice scope, product features, monetization, charity claims, Browser Extension dependency, cross-product behavior or shortcuts affecting intended player experience.

This does not add scope. It clarifies implementation boundaries for locked Steam Vertical Slice.

Related:

```text
STEAM_DESKTOP__Codex_Implementation_Brief__Vertical_Slice_v1.md
cross-role RFC on Codex task boundaries
```

---

### D-017 — Codex tasks require brief files in `04_DEVELOPMENT/`

Дата: 2026-06-29
Kind: `process/dev`
Area: `Codex`
Status: `accepted`

Summary:

> Significant Codex tasks must be assigned through brief files, not chat-only instructions.

Decision:

All significant Codex tasks must be described in a brief file under:

```text
docs/drive/Shelter/04_DEVELOPMENT/
```

Chat may contain the short launch prompt, but the task source is the brief file.

A Codex brief should include:

- goal;
- mandatory sources;
- scope / out of scope;
- acceptance criteria;
- stop conditions;
- expected changed areas;
- checks;
- status-doc update requirements;
- recommended reasoning level.

Related:

```text
04_COLLABORATION_PROTOCOL.md
AGENTS.md
000_ROLE_CODEX.md
```

---

### D-018 — Vertical Slice gameplay proof is enough for Game Designer systems branch

Дата: 2026-06-29
Kind: `product/process`
Area: `Steam`
Status: `accepted`

Summary:

> Steam Vertical Slice gameplay proof is enough to unblock Game Designer systems work; visual proof remains Art Director critical path.

Decision:

Vertical Slice proof is split into:

1. Gameplay proof — loop, task chain, resource flow, player agency, D-010 trait/equipment separation and system contracts.
2. Visual proof — readability, visual hierarchy, dog silhouettes, placeholder quality, strip composition, UI look, production-art readiness and final visual/usability acceptance.

Producer decision:

Gameplay proof is sufficient for Game Designer to continue systems design. This does not mean final visual/product acceptance.

Update:

Standalone Systems Simulator direction is cancelled and replaced by Godot State Connector / Workbench over live Godot.

Superseded:

```text
docs/drive/Shelter/99_ARCHIVE/STEAM_DESKTOP__Codex_Brief__Systems_Simulator_v0__SUPERSEDED_BY_GODOT_STATE_CONNECTOR.md
```

Related:

```text
D-019
CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md
```

---

### D-019 — Game Design Systems Workbench over live Godot runtime

Дата: 2026-06-30
Kind: `technical/process`
Area: `Steam/Codex`
Status: `accepted`

Summary:

> Godot runtime is the source of truth. Workbench observes and controls accepted dev surfaces; it does not simulate Shelter independently.

Decision:

Game Design Systems Workbench develops on top of the live Godot game, using accepted dev surfaces such as State Connector, Control Connector, Viewport Capture API, inspection views and explicitly accepted whitelisted controls.

Rationale:

Existing Godot State Connector / Control Connector / capture tools are a safer foundation than a standalone simulator, which risks creating a second independent world model.

Future Workbench expansions may expose dogs, traits, abilities, equipment, activities, buildings, levels, queues, inputs/outputs, upgrades, research, economy and game event log only after Game Designer fixes the relevant systems contracts.

Related:

```text
docs/repo/adr/0002-game-state-as-source-of-truth.md
CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md
```

---

### D-020 — Project Philosophy / Shelter Constitution

Дата: 2026-06-30
Kind: `philosophy/product/ethics`
Area: `all`
Status: `accepted`

Summary:

> Most idle games make the warehouse richer. Shelter makes life richer.

Decision:

Project Philosophy / Shelter Constitution lives in:

```text
docs/drive/Shelter/00_START_HERE/03_PROJECT_PHILOSOPHY.md
```

Core principle:

> Shelter makes life richer, not the warehouse.

Expanded direction:

Shelter is not primarily about optimizing production. It is about creating a place where dogs can live well, make friends, learn, rest and help each other. Production, economy, research, progression and monetization exist only to make this life richer, warmer and more interesting.

Main filter:

> Any system must first explain how it makes cooperative life more interesting, and only then what game bonuses it creates.

Three-layer model:

1. **Core** — without this Shelter stops being Shelter: routes, production, delivery, dog progression, cooperative, research, buildings.
2. **Depth** — without this the game works, but is less alive: rooms, library, House of Curiosity, coziness, relationships, stories, postcards, tea after a trip, mentorship.
3. **Atmosphere** — small world gestures that add love without changing the main loop.

Test:

> If we remove this system completely, does the game remain a game?

If no — core. If yes, but less warm — depth. If almost nothing changes except feeling — atmosphere.

Related:

```text
03_PROJECT_PHILOSOPHY.md
04_SHELTER_STRESS_TESTS.md
```

---

### D-021 — ChatGPT Work local project and Shelter MCP boundary

Дата: 2026-07-10
Kind: `process/dev tooling`
Area: `docs/Codex/MCP`
Status: `accepted`

Summary:

> Shelter работает как локальный проект ChatGPT Work/Codex, открытый на checkout монорепозитория. Work/Codex работает с файлами напрямую; Shelter MCP остаётся локальным domain-specific runtime/inspection adapter.

Decision:

1. Локальный checkout Shelter — единая рабочая среда и источник проектной правды для ChatGPT Work и Codex.
2. ChatGPT Work используется для ролевых, продуктовых, исследовательских и документационных задач; Codex — для реализации, проверок и технических изменений. Обе поверхности обязаны восстанавливать контекст из одних и тех же локальных документов.
3. Передача долговременного результата между отдельными задачами/ролями происходит через Current Memory, Knowledge, RFC, Codex brief и handoff, а не через предположение о доступе к памяти соседней сессии.
4. Shelter MCP живёт внутри монорепозитория в `mcp/` и нужен только там, где полезен локальный domain-specific adapter: запуск разрешённых dev-команд, runtime/capture inspection и control, а также ограниченная навигация по знаниям.
5. Shelter MCP не является generic shell, основным файловым доступом или отдельным источником истины. При расхождении его digest/catalog с source documents приоритет у source documents.
6. Shelter MCP подключается через project-scoped `.codex/config.toml` и локальный STDIO launcher `mcp/run.sh`.
7. Если сессия запущена без доступа к локальному checkout, она не должна выполнять source-bound работу по Shelter и обязана запросить локальный доступ.

Transition status:

```text
Process decision: accepted and active.
Documentation migration: completed 2026-07-10.
Technical MCP/config setup: completed 2026-07-10.
```

Non-effect:

Это решение не меняет product, game design, art direction, Godot runtime contracts или Vertical Slice scope.

Related:

```text
PROJECTS_RULES.md
AGENTS.md
README.md
00_START_HERE/05_DOCUMENTATION_GOVERNANCE.md
04_DEVELOPMENT/SHELTER_WORKFLOW__Codex_Brief__ChatGPT_Work_And_Local_MCP_Migration_v1.md
```

---

### D-022 — Steam/Desktop Day 2 executable scope lock

Дата: 2026-07-11
Kind: `product/game design`
Area: `Steam/Desktop`
Status: `accepted`

Summary:

> Следующий executable slice — Day 2 Return и одна полностью завершаемая вариация существующей Warm Food Delivery. Вчерашняя забота остаётся видимой; знакомая физическая цепочка повторяется с одним careful-packing моментом Лабрадора и спокойным завершением.

Decision:

1. Вторая поставка проходит end to end, а не останавливается на availability: payload → unload → carry → Kitchen/Food Mix → Packing Table/Food Bag → LoadVan → player-confirmed DeliveryTask → completed.
2. Используются существующие `route.oat_farm_intro`, Basket Bicycle, resource family и станции; новый маршрут, chain, ресурс, station или recipe не добавляются.
3. Return сохраняет postcard, equipped slippers, Dachshund memory и packing note First Day; production save/calendar/day rollover не реализуются — continuity доказывается deterministic fixture/capture.
4. Единственная новая вариация — читаемый Labrador careful-packing cue внутри существующего PackTask. Он не создаёт quality system, habit unlock или числовой bonus.
5. После completion появляется небольшая progress note, а не вторая полноценная postcard/reward cadence. Только затем становится доступен optional question `Как паковать мягче?` как future promise, не active research/choice/habit state.
6. Slice не меняет production art/animation architecture, window semantics, desktop-platform integration, monetization, charity claims или ethics boundaries.
7. Результат является Day 2 product-language/repeatable-loop proof, но не доказывает production persistence, shipping desktop readiness или реальный retention KPI.

Accepted implementation-contract clarification:

1. `second_day_after_first_delivery` разделяет immutable `first_day_history` и единственные активные `active_order` / `active_chain`; legacy top-level flags допустимы только как one-way projections активного Day 2 state и не являются источником Day 1 history.
2. `first_day_history` сохраняет completed First Day order, postcard, reward, chain, life-moment, equipped slippers, Dachshund memory, next-day hint и packing-note facts. `active_order.id = order.second_warm_delivery_careful_pack`; `active_chain.template_id = chain.warm_food_delivery_intro`, `run_id = run.day2.second_warm_delivery`.
3. Fixture кладёт в Storage ровно `Protein Packet x1` и `Packaging Bag x1`, но не Oat/Pumpkin/Food Mix/Food Bag. Это deterministic existing-stock precondition только для fixture, не refill/replenishment, economy, save или route reward.
4. Day 2 order проходит строго `offered → route_suggested → missing_resources → resources_available → production_in_progress → packed → loaded → sent → completed`; `sent` наступает после player confirmation / создания DeliveryTask, `completed` — только после `delivery_complete`.
5. TripTask, downstream tasks and capture events получают `active_order.id`. Это узкая параметризация прежнего First-Day hardcoding; поведение `order.first_warm_delivery` не меняется.
6. Day 2 PackTask остаётся существующим task type и детерминированно назначается Лабрадору; careful-packing cue/event появляется только в `in_progress`.
7. Для `order.second_warm_delivery_careful_pack` completion не создаёт `postcard_created`, `reward_created` или `EquipItemTask`. Active Order наблюдает `delivery_complete`, владеет non-reward response state и последовательно раскрывает small progress note на существующем Van-side postcard-board cue, затем optional question на существующем Packing Table note cue. First Day Postcard/Slippers flow остаётся неизменным.

Exact fixture/state/event surface and object/task ownership are normative in the related First Week Direction, Task Flow Contract, Object Contract and canonical Codex brief.

Canonical brief:

```text
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Day_2_Return_And_Second_Warm_Delivery_v1.md
```

Related:

```text
02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__First_Week_Direction_v1.md
02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Game_Design_Roadmap_v2.md
00_START_HERE/03_OPEN_QUESTIONS.md
```

---

### D-023 — Steam/Desktop First Day + Day 2 player journey scope lock

Дата: 2026-07-12
Kind: `product/game design`
Area: `Steam/Desktop`
Status: `accepted`

Summary:

> Следующий executable program превращает уже доказанные First Day и Day 2 сценарии в один обычный player journey: clean launch, спокойное влияние без microtask duty, player save/Continue, одноразовый session-based return, первый living Labrador, одна inspectable Kitchen и тихое продолжение после Day 2.

Decision:

1. `First 48 Hours` — внутреннее имя программы. Canonical readiness claim до Windows smoke: `macOS-only internal First Day + Day 2 playable (session-based continuation, prototype visual level; not Steam/release ready)`.
2. Narrative Day 2 начинается ровно один раз при первом обычном `Continue` после fully-complete First Day; wall clock, timezone, real calendar и elapsed closed-app time не продвигают день.
3. Закрытая игра frozen: нет offline simulation, catch-up, resource/reward production, decay, loss, neglect, deadline или absence penalty. Visible-unfocused/occluded runtime продолжает safe 1x simulation; minimized/OS-suspended runtime может pause/slow без restore burst.
4. Fresh First Day Storage содержит `Protein Packet x2` и `Packaging Bag x2`. First Day расходует по одной единице; Day 2 получает persisted remainder `x1/x1`. Transition не создаёт refill/reward/resource event.
5. Exact required gameplay input budget: First Day — start trip, confirm dispatch, equip slippers; Day 2 — start trip, confirm dispatch. Dog-owned unload/carry/cook/pack/load microtasks требуют ноль подтверждений; irreversible gates ждут бессрочно.
6. First Day считается полностью завершённым только после delivery completion, postcard life moment, equipped slippers, added memory и next-visit hint. До этой границы restart продолжает First Day и не создаёт Day 2.
7. После Day 2 принимается вариант A — `Quiet Cooperative`: completed First Day/Day 2 history and persistent traces remain immutable, active order/chain slots are empty, safe idle/wait/rest ambience continues. Это не repeatable order, Day 3 или новая progression system.
8. Первый living runtime character — Labrador (`P0`). Первая inspectable room — Kitchen (`P1`) и остаётся обязательным Program DoD. Room uses one same-window detail surface over the same runtime, does not duplicate the dog and adds no mechanics.
9. Player persistence uses versioned `user://` save, strict validation, transactional replace plus recovery and safe checkpoints. Exact in-flight task resume не входит без отдельного idempotency contract.
10. `steam/play.sh` запускает только обычную игру тем же semantic route, что F5/internal export. `steam/dev.sh` — developer dispatcher для fixtures, connector/control, captures и diagnostics. Player path не принимает dev fixture/control/debug/time semantics.
11. Authored visual source и imported runtime evidence — разные maturity stages. PREVIEW_RESEARCH_ONLY Sheet A/B не являются runtime assets; standalone demo не закрывает playable Art DoD.
12. First Week остаётся направлением, а не семью реализованными днями. First Month, Day 3+, repeatable order generator, full dog vocabulary, multiple rooms, research/habits/economy, production style lock и Steam/release integration остаются out of scope.

Accepted user choices:

```text
A — Quiet Cooperative after Day 2.
A — Kitchen remains mandatory P1 in Program DoD.
A — First 48 Hours remains an internal roadmap name; readiness uses First Day + Day 2 / two-session language.
```

Implementation relationship:

- `R48-01` player entry and `R48-02` persistence may be designed in parallel but close as a joint acceptance gate; shared-checkout implementation is sequential under one integrator.
- D-022 task/order/resource causality remains authoritative. Player continuation must implement an idempotent same-runtime transition and MUST NOT load the Day 2 fixture from player path.
- Every Codex implementation wave requires a separate accepted brief.

Execution clarification accepted 2026-07-12 after cross-role owner preflight:

- `R48-05A` delivers the authored world plus living Labrador P0-B/P0-D foundation without object transfer. Its successful bounded result is `PASS` for R48-05A and only `PARTIAL / WARN` for parent R48-A/R48-05.
- `R48-05B / P0-C` later delivers exactly one named owner-approved object transfer. Only its PASS closes the remaining carry/contact/attach/detach gate and permits full R48-A/R48-05 PASS.
- Start, stop and physical turn are accepted only inside the bounded Labrador proof as presentation transitions derived from authoritative runtime phase/target/facing data; they are not new gameplay states and do not globally promote the proposed vocabulary.
- A separate source-only Art Package wave may prepare authored world, layered Labrador and Kitchen/Packing anchor inputs before runtime implementation. Source-ready Art maturity is not runtime Art PASS and does not activate Codex by itself.
- The split changes execution order, not D-023 scope. One accepted transfer remains mandatory for full Program DoD; exact `3 + 2`, resource provenance, Quiet Cooperative and later R48-04A remain unchanged.

User-owner current-versus-later scope clarification accepted 2026-07-13:

- **Current:** restore the Steam/Desktop base visual presentation to the canonical reconciliation targets: D-011 as the full main-strip scene target, the `approved_art_files/` library as the approved visual-language/scale/quality reference set, and the accepted Labrador direction/identity pair. This work may exercise only mechanics already present in the accepted runtime.
- The approved Mill may be included literally as a **static decorative object**. It does not become a gameplay entity and creates no mechanic, task, resource, output, reward, input or production responsibility. No approved decorative image may imply new gameplay authority by appearance alone.
- The first living dog remains Labrador. The minimum desired living read is a Labrador calmly walking back and forth. Exact current status: `NEEDS_MANIFEST_AMENDMENT`. No new vocabulary row is needed: reuse existing start/walk/stop/turn, but the signed A–G manifest currently allows locomotion only under station selector C. Before executable binding, a bounded selector amendment requires Game Design, Producer/PM and Technical/Codex re-sign, followed by a separate accepted/executable Codex brief.
- Ambient-walk guardrails are fail-closed: no current/queued Labrador task; allowed only before TripTask while an order is offered or after Day 2 in Quiet Cooperative; `ready_to_send` calm wait wins; forbidden during authoritative trip/task/delivery, restore and save failure/retry; a player gate cancels the presentation before transition; the presentation creates zero gameplay/save/progression output.
- Dachshund/cart is not critical and is not a current implementation requirement.
- The current sequence is: Art reconciliation brief/package → PM/User acceptance → bounded Art source wave without runtime/code mutation → separate Codex integration brief → runtime evidence, independent Art review and explicit user review.
- There is no v6 patch loop. R48-05B/object transfer, rooms, onboarding and background/minimize/performance work are not current work. They remain later/open gates and are neither cancelled nor activated by this clarification.
- **Later product direction/backlog:** cart; bicycle; small-truck driver; large-truck bed passenger; school desk; library reading; lab chemistry; blackboard teaching; rocking-chair reading; sleeping; playing with another dog; tail chasing; and a broader catalogue of dog-life states. This is not current scope or implementation authority. Game Design owns future detailed semantics/selectors/catalogue; PM records only the product direction and current-versus-later boundary.

Canonical sources:

```text
02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__First_48_Hours_Playable_Roadmap_v1.md
02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__First_48_Hours_Playable_Scope_Lock_v1.md
```

---

## 3. Open / proposed items not fixed here

These are not decisions in this file. Track them in:

```text
03_OPEN_QUESTIONS.md
```

Examples:

- exact stack for Browser Extension;
- exact stack for Mobile;
- common backend/account/economy timing;
- charity reporting and partner-shelter model;
- legal/platform checks for ads, privacy, Chrome Web Store and claims;
- production art gate and future production-style requirements;

---

## 4. Changelog

### 2026-07-13 — D-023 current graphics / later dog-life boundary

- Made canonical base-visual reconciliation plus existing mechanics the current priority.
- Allowed the approved Mill only as a static decorative object and kept Labrador as the first living dog.
- Moved the broad dog-life catalogue, R48-05B, rooms, onboarding and background work out of the current queue without cancelling them.
- Fixed the staged Art → PM/User → Art source → Codex brief → runtime review sequence and prohibited a v6 patch loop.

### 2026-07-12 — D-023 execution clarification / R48-05A + R48-05B

- Accepted the visible-progress split: no-transfer R48-05A first, one named transfer R48-05B later.
- Kept full R48-A/R48-05 and Program DoD open until R48-05B PASS.
- Authorized a separate source-only Art Package wave after document synchronization.

### 2026-07-12 — D-023 accepted

- Accepted the First Day + Day 2 player-journey program and user choices A/A/A.
- Locked session-based continuation, frozen closed-app state, exact `3 + 2` input budget, persisted `x2/x2 → x1/x1` reserve, Labrador P0, Kitchen P1 and Quiet Cooperative.
- Kept calendar/offline progression, Day 3+, First Month, full animation vocabulary, production art and Steam/release work outside the program.

### 2026-07-11 — D-022 accepted

- Locked the narrow Day 2 executable slice as one fully completable same-chain Warm Food Delivery variation.
- Added the fixture-only history/active-state split, static existing-stock precondition, active-order event parameterization, deterministic Labrador PackTask ownership and the non-reward Day 2 feedback exception.
- Kept save/calendar, new systems, active habit/research, production art/rig and platform semantics out of scope.

### 2026-07-10 — D-021 accepted

- Зафиксирован переход к локальному проекту ChatGPT Work/Codex поверх текущего checkout.
- Разделены прямой файловый доступ Work/Codex и локальный domain-specific Shelter MCP.
- Техническая очистка вынесена в отдельный Codex brief без изменения product/game/art решений.

### 2026-07-07 — decision log cleanup

- Converted `02_DECISIONS.md` into a structured decision log.
- Added metadata, read policy and decision index.
- Preserved D-001..D-020 meanings while reducing historical narrative.
- Moved open/proposed items to `03_OPEN_QUESTIONS.md` references.
- Normalized D-012 and moved the overlay asset taxonomy update into D-011 where it belongs.

### 2026-06-30 — D-020 accepted

- Project Philosophy / Shelter Constitution accepted.

### 2026-06-29 — process and implementation-boundary decisions

- Role boundaries, RFC workflow, Codex task briefs, Vertical Slice proof split and Workbench-over-Godot direction accepted.

### 2026-06-24/25 — initial product decisions

- Initial product family, Godot, Browser loop, Steam co-op, dog trait model, visual direction candidate, shared world and resource trips accepted.
