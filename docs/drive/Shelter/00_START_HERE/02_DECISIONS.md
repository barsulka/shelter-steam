# 02_DECISIONS — Shelter Decision Log

Обновлено: 2026-07-10
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
- First Week / Day 2 implementation readiness.

---

## 4. Changelog

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
