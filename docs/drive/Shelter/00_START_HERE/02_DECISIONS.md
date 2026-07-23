# 02_DECISIONS — Shelter Decision Log

Обновлено: 2026-07-22
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
For current implementation state, use CODEX_CURRENT_STATUS.md. Older history is in Git.
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
| D-022 | Steam/Desktop Day 2 executable scope lock | product/game design | Steam | accepted prior scope / future reference |
| D-023 | Steam/Desktop First Day + Day 2 player journey scope lock | product/game design | Steam | future reference / current priority superseded by D-031 |
| D-024 | Steam/Desktop responsive meadow, field and viewport contract | product/game design/technical boundary | Steam | accepted / implemented / sealed pre-D-030 evidence |
| D-025 | macOS-first development sequence and visual-capture authority | product/process/technical boundary | Steam | accepted |
| D-026 | MCP-first source-derived context bridge | process/dev tooling | docs/Codex/MCP | accepted / implemented / independent review PASS / daily default active |
| D-027 | Blocker revalidation and user approval for material workaround routes | process/governance | all roles/Codex | accepted |
| D-028 | Steam-managed Godot installation and version authority | process/dev environment | Steam/Desktop/Codex | accepted |
| D-029 | Observable and graceful Godot subprocess lifecycle | process/dev tooling | Steam/Desktop/Codex | accepted |
| D-030 | Fixed 26-cell meadow period, whole-game zoom and alpha click surface | product/art/technical boundary | Steam/Desktop | accepted |
| D-031 | Visual Shell Lock → Interactive Shelter Shell | product/art/game-design boundary | Steam/Desktop | accepted / current sequence / static selected-H PASS |
| D-032 | Versioned current presentation regression profile after D-030 | technical/QA authority boundary | Steam/Desktop | accepted / checkpoint-2 prerequisite |
| D-033 | macOS native-quantized dynamic height and exact client-area readback | technical/QA authority boundary | Steam/Desktop | accepted / amendment pending independent verification |
| D-034 | Selected-H finite projected canvas and exact render/pointer equivalence | product/art/technical/QA boundary | Steam/Desktop | accepted / active-brief amendments pending independent verification |

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

Clarified by: `D-028 — Steam-managed Godot installation and version authority`

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

Prior RFC detail is retained in Git history after its accepted rule was folded
into this decision and the role documents.

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

Prior Vertical Slice brief/RFC detail is retained in Git history. The active
implementation rule is D-017 plus `PROJECTS_RULES.md` / `AGENTS.md`.

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

The superseded simulator brief is available through Git history. Current
implementation authority is the live Godot runtime plus the accepted brief
required for each new Codex task.

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

Clarified by: `D-026 — MCP-first source-derived context bridge`

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
+
Дата: 2026-07-11
Kind: `product/game design`
Area: `Steam/Desktop`
Status: `accepted prior scope / future reference`
+
Summary:
+
> Day 2 was defined as a causally continuous second warm-delivery session with
> persisted Day 1 consequences, no hidden refill and no fixture shortcut.
+
Current relationship:
+
D-022 remains a regression/future contract for the already implemented
causality and persistence baseline. It is not an active milestone or routing
source. D-031 controls current sequencing; detailed prior scope is available in
Git history.
+
---
+
### D-023 — Steam/Desktop First Day + Day 2 player journey scope lock
+
Дата: 2026-07-12
Kind: `product/game design`
Area: `Steam/Desktop`
Status: `accepted prior scope / current priority superseded by D-031`
+
Summary:
+
> First Day and Day 2 established the two-session runtime/persistence baseline.
+
Current relationship:
+
The implemented state/save/causality behavior remains regression coverage and
future product material. It does not define current visuals, active scope or
next step. The current sequence is Visual Shell Lock → Interactive Shelter
Shell under D-031; detailed D-023 history is recovered from Git.
+
---
### D-024 — Steam/Desktop responsive meadow, field and viewport contract

Дата: 2026-07-14
Kind: `product/game design/technical boundary`
Area: `Steam/Desktop`
Status: `accepted / implemented / sealed technical-mechanical pre-D-030 evidence`

Summary:

> PlayerBoot сохраняет 100% usable-width viewport, а Shelter meadow покрывает
> видимую и игровую ширину бесшовным горизонтальным tile-модулем без stretch,
> crop или tails. Gameplay field и viewport независимы; справа всегда остаётся
> спокойный небилдабельный резерв.

Decision:

1. Четыре показанных пользователю Labrador/building/meadow visual принимаются
   как положительное visual direction. Это не runtime Art PASS, shipping approval
   или разрешение на broad pixel loop; exact byte-level mapping/promotion остаётся
   отдельной Art-owned записью.
2. Meadow нельзя неравномерно растягивать. Оно должно быть seam-safe горизонтально
   tileable Shelter pattern/module, повторяемым до полного покрытия visible/world
   width без seam, black tail или transparent tail.
3. `gameplay field bounds`, `buildable bounds` и `viewport bounds` — независимые
   контракты. Если field уже viewport, meadow продолжается до края viewport, но
   внешняя область небилдабельна и исключена из dog idle/selector-H activity.
4. Если viewport уже gameplay field, включается горизонтальный mouse-drag pan.
   Это presentation/navigation surface с нулевым progression output; точные
   input/zoom/coordinate правила требуют подписей Game Design и Technical.
5. При каждом zoom справа сохраняется примерно 15% viewport-width пустого meadow:
   без зданий и dog activity. Это композиционный/future-controls reserve; текущим
   решением никакие будущие controls не создаются.
6. Сразу после крайней правой buildable-клетки ставится один static decorative
   `Fence Boundary Marker`; справа от него строить нельзя и продолжается только
   tiled meadow. Предпочтён зеркально ориентированный вариант, который Art обязан
   предоставить отдельным authored positive-coordinate mirrored source/export.
   Runtime negative scale запрещён. Marker не имеет input/task/resource/output/
   reward/progression/collision/gameplay authority и не является новой gameplay
   entity или mechanic.
7. CQ Hero Town screenshot служит только layout illustration границы buildable
   поля, продолжающегося meadow и viewport edge. Нельзя копировать CQ pixels,
   style, UI, buildings, characters, mechanics или density.
8. Scroll/buildable/dog-exclusion/zoom contracts подписывают Producer/PM, Game
   Design и Technical. Implementation возможна только по отдельному принятому
   Codex brief.
9. Additive Art amendment прошёл owner gates и source acceptance. Separate Codex
   integration завершил D-024, а sealed capture pack сохранил точное техническое
   evidence. D-030 позже заменил presentation baseline; D-024 brief и pack
   остаются неизменяемым hash/validator-required regression contract, а не
   current visual target.
10. R48-05B/object transfer, rooms, onboarding, background/minimize/performance,
    новые mechanics/entities и broad pixel regeneration остаются вне scope.

Supersedes:

- unique authored full-width meadow and the former `do not tile-copy` clause;
- fixed 2992×224 player window;
- centered or right-aligned 2992 lane with transparent gutters;
- any black/transparent side tail.

Repeated buildings/anchors are still forbidden: only the meadow pattern repeats.
No non-uniform stretch or crop is allowed.

Owner-gate closure 2026-07-14:

- Game Design contract SHA
  `e103d836427e3bb5054a183149dd97b095e91b5a4195c752ac5f4da19a00854c`
  and GD Current Memory SHA
  `d3c393df311e85bdd8f133c40f5be189bafc64db17de3f6dcd1b6230c096d563`
  are signed.
- Game Design additionally accepted `offscreen_left = -160` solely as the
  pre-existing hidden D-013 TripTask absence sentinel for Dachshund/Bicycle; it
  is not visible meadow/world/buildable/station/A–H/idle space.
- Technical/Codex returned `SIGNED_TECHNICAL_READBACK`: gameplay field remains
  `[0,1740]`, reserve target is `p=0.15`, tile and marker are source-only inputs,
  pan/zoom is non-persisted presentation, and no PlayerBoot/platform/checkpoint/
  profile/game-system change is required.
- The retained Art thread is explicitly resumed under the external PM record,
  still `SOURCE_ONLY / NOT_RUNTIME_EXECUTABLE`.

Activation/status record:

```text
03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Art_Source_Responsive_Meadow_Left_Cluster_Amendment_v1__PM_Activation_Status.md
```

---

### D-025 — macOS-first development sequence and visual-capture authority

Дата: 2026-07-14
Kind: `product/process/technical boundary`
Area: `Steam/Desktop`
Status: `accepted`

Clarified by: `D-027 — Blocker revalidation and user approval for material workaround routes`

Summary:

> Shelter Steam/Desktop разрабатывается, собирается, проверяется и принимается
> на macOS до отдельного предрелизного решения. Текущие визуальные доказательства
> получают только штатным self-capture Godot или, когда нужен системный контекст,
> через macOS Screenshot UI / Computer Use.

Decision:

1. Windows и macOS остаются будущими целевыми платформами продукта. Текущий
   active implementation/QA/evidence/acceptance target до pre-release — только
   macOS.
2. Windows полностью исключён из текущих implementation, QA, evidence, warning,
   blocker и acceptance queues. Отсутствие Windows hardware/parity не создаёт
   `WARN`, не блокирует PASS и не должно называться
   `CROSS_PLATFORM_WARN_WINDOWS_PENDING`.
3. Только отдельная явная Producer/PM pre-release activation может открыть
   Windows compatibility/port/smoke/certification wave. Это sequencing decision,
   а не отмена будущего Windows target.
4. Для визуального evidence разрешены ровно два штатных пути:
   - предпочтительный Godot self-capture через существующие
     `get_viewport().get_texture().get_image().save_png(...)`, State Connector
     `capture.screenshot`, 10-second / 2 FPS PNG sequence
     `capture.video.start` и профильный capture/test runner;
   - macOS Screenshot UI через Computer Use, только когда нужен весь desktop,
     native window frame или другой системный контекст вне Godot viewport.
5. Третьего/ad-hoc capture path нет. Headless/dummy output без настоящего
   framebuffer, механический log вместо изображения и новый capture subsystem
   запрещены. Shell/terminal surface, из которого запускается существующий
   runner, не является отдельным capture path. Исторический launch failure не
   считается текущим без bounded revalidation по D-027. Если оба разрешённых
   evidence path действительно недоступны в текущем environment, evidence
   остаётся честно `BLOCKED / UNSEALED`.
6. Screenshot production и native input/passthrough verification — разные
   требования. Mechanical/native macOS input/passthrough проверяется там, где это
   доступно, но не требует external desktop screenshot и не создаёт новый
   platform scope.
7. D-024 может закрыть текущую evidence/acceptance wave только на macOS. Старый
   AppKit/HIServices abort относится точно к Godot `4.5.1` из
   `/Users/barsulka/Downloads/Godot.app`, parent `Codex/ChatGPT`, до
   Godot/project initialization. Это historical version/environment evidence,
   а не runtime/product failure и не доказательство против текущего Steam Godot
   `4.7` или обычного shell launch.
8. После runner correction/review/PM/ACK пользователь разрешил D-024 direct
   shell launch. Он завершён и sealed как technical-mechanical evidence; новая
   capture system не создавалась. D-031 теперь задаёт отдельный user-owned visual
   acceptance route.

Supersedes for current sequencing:

- D-023 wording that tied the current readiness claim to a later Windows smoke;
- D-024 brief/evidence clauses requiring Windows parity or a Windows warning;
- roadmap/current-status items keeping Windows as a current open gate;
- universal external desktop/window screenshot requirements when Godot
  self-capture already proves the requested game image.

Related authority:

```text
AGENTS.md
steam/AGENTS.md
04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__D024_Responsive_Meadow_Marker_And_Player_Presentation_Cleanup_v1.md
```

---

### D-026 — MCP-first source-derived context bridge

Дата: 2026-07-15
Kind: `process/dev tooling`
Area: `docs/Codex/MCP`
Status: `accepted / implemented / independent review PASS / daily default active`

Clarifies: `D-021 — ChatGPT Work local project and Shelter MCP boundary`

Summary:

> MCP-first source-derived routine bootstrap; local source docs remain authority
> and exact fallback; knowledge failure is capability-local and must not disable
> runtime/capture/control.

Decision:

1. Когда локальный Shelter MCP доступен и его source-derived knowledge health
   равен `current`, routine bootstrap и первичная context routing по умолчанию
   идут через компактный детерминированный
   `shelter_context_bundle(role, area, task, max_bytes)`.
2. Bundle выводится из канонических Markdown source docs по запросу. Локальные
   source docs остаются project memory и authority; MCP не создаёт отдельную или
   вручную поддерживаемую вторую память текущих фактов.
3. Direct source read обязателен при unavailable/non-current MCP, явном
   `fallback`, omission/truncation, exact brief / Accepted ADR / normative
   contract, конфликте/parser failure и при редактировании самого source doc.
4. Source-derived snapshot должен быть детерминированным, иметь stable ordering,
   whole-file и block hashes и защищаться от изменения source во время чтения.
   Persistent/generated cache в первой версии не создаётся.
5. Default bundle budget — 24 KiB, hard cap — 64 KiB по фактическому encoded
   `StructuredContent`; text `Content` остаётся коротким и не дублирует большой
   payload.
6. Enabled legacy knowledge projections должны использовать тот же source
   snapshot. Неперенесённый knowledge tool обязан explicit-fail и не может
   возвращать static stale facts.
7. Knowledge parsing/health failure является capability-local. В той же MCP
   server session runtime, capture и control registration/listing остаются
   доступными.
8. `read_shelter_bootstrap_context` сохраняется как legacy full-source fallback,
   а не ежедневный default.
9. MCP остаётся domain-specific adapter: generic fs/shell/search, AI summary,
   embeddings/vector DB, network service и новые dependencies не добавляются.
10. Решение не меняет Godot/runtime/gameplay/art/capture contracts, Steam scope
    или product decisions.

Historical root cause resolved by the implementation:

```text
Decision: accepted and active.
Pre-D-026 MCP globally validated a drifted manually maintained static catalog before server/tool registration.
The implementation removed static current-fact mirrors/fingerprints and the global startup knowledge gate.
Enabled knowledge projections now use source-derived snapshots; same-session runtime/capture/control isolation passes.
```

Current rollout status:

```text
Implementation: complete; four-finding remediation independently verified.
Local checks: unit/race/vet/build, root+nested STDIO, Codex MCP list/get and non-interactive one-call smoke PASS.
Independent re-review: PASS; the prior two P1 acceptance failures and two P2 compatibility/routing defects were reproduced and closed, with no new P0/P1/P2 or compatibility regressions.
Remediated P1 scope: low-budget/error encoded-byte accounting; source-conflict health/fallback semantics.
Remediated P2 scope: legacy decision-kind compatibility; deterministic task routing semantics.
Final D-026 acceptance and daily-default rollout: active; healthy shelter_context_bundle is the routine bootstrap/context-routing default.
Direct source reads: authority and exact fallback under the documented unavailable/non-current, fallback, omission/truncation, exact-contract, conflict/parser-failure and source-editing conditions.
Non-blocking residuals: first remote CI run; no generic semantic conflict detector by accepted governance boundary; honest fallback/omissions when a 4 KiB budget cannot carry the requested context.
Remaining D-026 blockers: none.
Next project step: D-031 selected-H runtime integration and direct user live-matrix gate.
```

Related:

```text
PROJECTS_RULES.md
AGENTS.md
README.md
00_START_HERE/05_DOCUMENTATION_GOVERNANCE.md
04_DEVELOPMENT/SHELTER_WORKFLOW__Codex_Brief__Source_Derived_MCP_Context_Bridge_v1.md
```

---

### D-027 — Blocker revalidation and user approval for material workaround routes

Дата: 2026-07-16
Kind: `process/governance`
Area: `all roles/Codex`
Status: `accepted`

Clarified by: `D-029 — Observable and graceful Godot subprocess lifecycle`

Clarifies: `D-003`, `D-014`, `D-016` and the blocker-handling part of `D-025`.

Summary:

> Historical/environment/version blockers are evidence for bounded current
> revalidation, not automatically current truth. A material workaround may be
> investigated and proposed, but it cannot be adopted or operationalized
> without explicit user agreement.

Decision:

1. Исторический, environmental или version-specific blocker — это evidence /
   lead, а не автоматически активная истина текущего checkout.
2. Перед тем как считать его активным, агент обязан перепроверить текущий
   checkout, текущий binary/version и текущий execution environment самым
   маленьким безопасным bounded check.
3. Если blocker меняет согласованный execution path, acceptance route, tool
   surface, scope, owner или создаёт существенную/multi-session workaround-
   работу, точное evidence и варианты показываются пользователю до принятия
   нового пути.
4. Агент может безопасно/read-only исследовать и предложить workaround, но не
   может принять, активировать, реализовать или начать operational use этого
   workaround без явного пользовательского согласия. Coordinator, PM и Codex
   не могут изготовить или подменить такое согласие.
5. Если пользовательское согласие недоступно, изменённый route остаётся
   `HOLD`; разрешена только безопасная in-scope диагностика без commitment к
   workaround.
6. После согласия approval и chosen route фиксируются в active brief/current
   docs до implementation.

Boundary:

Это правило не применяется к тривиальному обратимому recovery, уже входящему в
явно разрешённый workflow и не меняющему route, scope или acceptance. Оно не
запрещает изобретать workaround; оно разделяет proposal и authority to adopt.

Current D-024 application:

- старый pre-project crash относится точно к Godot `4.5.1` из
  `/Users/barsulka/Downloads/Godot.app`, parent `Codex/ChatGPT`, с abort в
  HIServices/AppKit до Shelter project/runtime initialization;
- это historical version/environment evidence, не доказательство текущего
  blocker для Steam Godot `4.7` или ordinary shell launch;
- пользователь явно разрешил после runner atomicity correction, independent
  review, PM Phase 2 и literal capture ACK запускать существующий D-024 runner
  напрямую через Codex shell/sh в logged-in macOS GUI session; runner запускает
  Steam Godot `4.7` без `--headless`;
- GoLand/Terminal.app не являются requirement. Required game evidence остаётся
  внутренним Godot real-framebuffer self-capture; macOS Screenshot UI /
  Computer Use используется отдельно только для явно требуемого desktop/native
  window context и не является launch prerequisite;
- D-024 gates later completed and the pack is sealed technical-mechanical
  evidence; this decision does not grant current D-031 visual acceptance.

Non-effect:

Решение не меняет product/game/art/runtime meaning, D-024 Contract A, набор
разрешённых capture paths, runner-only correction ownership или его atomicity
contract.

Related:

```text
PROJECTS_RULES.md
AGENTS.md
00_START_HERE/05_DOCUMENTATION_GOVERNANCE.md
04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__D024_Responsive_Meadow_Marker_And_Player_Presentation_Cleanup_v1.md
```

---

### D-028 — Steam-managed Godot installation and version authority

Дата: 2026-07-16
Kind: `process/dev environment`
Area: `Steam/Desktop/Codex`
Status: `accepted`

Clarified by: `D-029 — Observable and graceful Godot subprocess lifecycle`

Clarifies: `D-007 — Steam/Desktop engine: Godot` and the engine-selection
boundary around `D-027`.

Summary:

> Shelter Steam/Desktop local development, QA and evidence use only the Godot
> installation managed by Steam at the repository-documented Steam path.
> Agents do not obtain, select, substitute or remove Godot installations on
> their own.

Decision:

1. Единственный разрешённый local Godot для Shelter Steam/Desktop development,
   QA и evidence — Steam-managed bundle с authoritative executable path:
   `$HOME/Library/Application Support/Steam/steamapps/common/Godot Engine/Godot.app/Contents/MacOS/Godot`.
2. Агент никогда самостоятельно не скачивает, не устанавливает, не обновляет,
   не распаковывает, не подменяет и не выбирает другой Godot build/version.
3. Если Steam-managed Godot отсутствует, недоступен, имеет неверную версию или
   требует update/repair, агент останавливается и просит пользователя выполнить
   install/update/repair через Steam.
4. Если найдена любая другая локальная копия, bundle или binary Godot, агент не
   использует, не удаляет, не перемещает и не помещает её в quarantine/Trash.
   Он сообщает пользователю точное расположение и просит пользователя удалить
   копию, чтобы исключить path/version ambiguity.
5. Нельзя молча fallback-нуться на `PATH`, `Downloads`, `/Applications`,
   Homebrew, GitHub release, mirror, archive, custom binary или editor-bundled
   Godot. Переменная `GODOT_BIN`, если разрешена существующим tooling, может
   разрешаться только в authoritative Steam path из пункта 1.
6. После выполненного пользователем cleanup, install, update или repair агент
   заново читает точный Steam binary path и version до продолжения работы.
7. Это правило выбирает engine/tool authority, но не запрещает direct shell/sh
   launch. Прямой запуск authoritative Steam-managed binary или существующего
   runner разрешён, когда его допускают active brief и literal ACK.

Non-effect:

- решение не меняет product/game/art/runtime/capture semantics;
- оно не создаёт новый capture path и не изменяет D-024;
- оно не даёт агенту authority удалять или перемещать найденные установки;
- оно не переписывает D-027: revalidation и user-approval gate для material
  workaround routes продолжают действовать.

Related:

```text
PROJECTS_RULES.md
AGENTS.md
steam/AGENTS.md
steam/README.md
```

---

### D-029 — Observable and graceful Godot subprocess lifecycle

Дата: 2026-07-16
Kind: `process/dev tooling`
Area: `Steam/Desktop/Codex`
Status: `accepted`

Clarifies: `D-027 — Blocker revalidation and user approval for material
workaround routes` and `D-028 — Steam-managed Godot installation and version
authority`.

Technical authority: `ADR-0004 — Godot Child Observability And Graceful
Termination`.

Summary:

> Godot subprocesses are observable and fail loud without being crashed by
> their wrappers. Raw stdout/stderr and the exact child outcome are retained;
> finite tests reach natural exit, long-lived processes use bounded graceful
> termination, and errors are repaired rather than hidden or allowlisted.

Decision:

1. Перед spawn project-owned wrapper обязан fail-closed проверить exact
   D-028 Steam-managed binary and current version, canonical Shelter Steam
   project с `project.godot` и разрешённый fixed operation profile/argv.
   Arbitrary executable, argv, shell/eval, foreign/duplicate `--path` и binary
   fallback запрещены.
2. Project-wide narrow supervisor использует только profiles `version`,
   `import`, `script-check`, `scene-test`, `scene-capture` и
   `ordinary-player`. Test fake child доступен только как imported unit seam,
   не как public arbitrary-process CLI.
3. Raw stdout и stderr child сохраняются полностью, раздельно и append-only до
   matching/classification, зеркалируются live и сопровождаются ordered events.
   Удаление единственного raw log, stdout-only capture, silent truncation или
   redirect/suppression запрещены.
4. Child process verdict и diagnostic verdict независимы. Result явно хранит
   normal exit code либо terminating signal number/name, а также отдельные
   diagnostic matches и seal eligibility; wrapper result не подменяет исходный
   child outcome.
5. `ERROR` не убивает finite test. Child доходит до natural exit; после этого
   diagnostic `FAIL` блокирует capture, manifest, seal и promotion, даже если
   process verdict равен `PASS` и позднее появился PASS marker.
6. Long-lived child останавливается только в последовательности:
   project/control quit с ACK → bounded grace → exact-PID `SIGTERM` → bounded
   grace. Если PID всё ещё жив, результат — `BLOCKED_CHILD_STILL_RUNNING` с
   сохранёнными PID/logs; `SIGKILL`, `SIGABRT` и hard-kill escalation нет.
7. Ошибки нельзя hiding/suppress/relabel/blanket-allowlist или маскировать
   environment changes. Исправляется причина. Текущая CA/certificate error
   остаётся real/unresolved и блокирует capture/seal до технического fix.
8. ADR-0003 recovery proof не имеет исключения: historical `kill -9` /
   `OS.kill` заменяется нефатальными authored intermediate snapshots/failpoints
   и свежим clean verifier process. Persistence/save/schema/gameplay semantics
   не меняются.
9. D-024 внедряет этот contract только в свой exact called chain. Broad wrapper
   migration, если понадобится, требует отдельного tooling brief и не
   активируется этим решением.

Current implementation-route clarification, explicitly approved by the user on
2026-07-16 under D-027:

1. D-024/D-029 не реализуют native `SIGTERM` bridge, GDExtension или
   platform-specific signal handler. Отсутствие внешней доставки
   `NOTIFICATION_WM_CLOSE_REQUEST` не является основанием для такого scope.
2. Always-present `PlayerBoot` / lifecycle owner получает один общий
   project-owned graceful-shutdown routine. Реальное оконное/macOS событие
   `NOTIFICATION_WM_CLOSE_REQUEST` вызывает этот routine; при необходимости
   project может отключить `auto_accept_quit`, чтобы завершение прошло через
   тот же контролируемый boundary.
3. Общий routine прекращает приём новых действий, использует существующую
   persistence boundary, завершает только допустимый pending persistence/flush,
   выдаёт diagnostic/ACK и штатно вызывает `SceneTree.quit(0)`. Save/schema,
   checkpoint, gameplay и product meaning не меняются.
4. Automation не синтезирует `NOTIFICATION_WM_CLOSE_REQUEST` извне. Только при
   exact flag `--shelter-observer-control-v1` узкий test-only one-shot trigger
   читает `user://d029-observer-control/quit.request` под validated isolated
   HOME и вызывает тот же общий graceful-shutdown routine.
5. Exact request bytes — `SHELTER_CONTROL_QUIT\n`; stale/collision до spawn —
   preflight rc `70`; malformed bytes — diagnostic `FAIL` без quit. Без exact
   flag нет polling, control-file поведения или runtime change.
6. Project ACK — exact line `shelter_project_quit_ack=true`, после которой
   выполняется bounded deferred/frame flush и natural exit `0`.
7. Exact-PID `SIGTERM` остаётся только bounded supervisor fallback после
   failed/missing project ACK. Такой fallback возвращает rc `74`, делает
   evidence ineligible и не является штатным PASS. Если child пережил второй
   bounded grace, остаются rc `75`, `BLOCKED_CHILD_STILL_RUNNING`, PID и логи;
   `SIGKILL`/`SIGABRT` нет.
8. Текущая CA/certificate error остаётся real/unresolved/not allowlisted. Любое
   повторение блокирует capture/manifest/seal/promotion.

Non-effect:

- решение не меняет product/game/art/runtime/capture semantics;
- оно не создаёт новый capture path и не разрешает capture до active brief/ACK;
- оно не разрешает alternate Godot binary, dependency, network или trust-store
  mutation;
- atomic stage/promote-or-restore evidence contract D-024 сохраняется.

Related:

```text
PROJECTS_RULES.md
AGENTS.md
steam/AGENTS.md
steam/README.md
docs/repo/adr/0004-godot-child-observability-and-graceful-termination.md
04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__D024_Responsive_Meadow_Marker_And_Player_Presentation_Cleanup_v1.md
```

---

### D-030 — Fixed 26-cell meadow period, whole-game zoom and alpha click surface

Дата: 2026-07-20
Kind: `product/art/technical boundary`
Area: `Steam/Desktop`
Status: `accepted`

Summary:

> Один approved meadow-период навсегда покрывает ровно 26 логических клеток.
> Период замощает окно без растяжения, а Up/Down масштабирует всю игру вместе.

Decision:

1. Логическая клетка имеет размер `32` world units. Один approved meadow-период
   покрывает ровно `26` клеток, то есть `832` world units.
2. Approved source рассчитан на zoom `200%`: после симметричного crop по 4 px
   слева и справа его ширина равна `1664 px = 26 × 32 × 2`. Горизонтальное
   растяжение или fit-to-window запрещены.
3. Число `26` меняется только отдельным explicit решением и только вместе с
   новым approved redraw, нарисованным под новое число клеток.
4. Левый и правый края периода должны быть бесшовными. Поле покрывает видимую
   ширину повторением этого периода; resize меняет только видимый extent.
5. Zoom ladder фиксирован: `50% / 100% / 150% / 200%`, default `100%`.
   Up/Down масштабирует одновременно поле, клетки, здания, props и собак.
6. Высота companion window не фиксирована в пикселях: она следует высоте
   zoomed meadow/content, оставаясь внутри macOS usable screen rect. Поле
   примыкает к нижней границе окна и не закрывает зарезервированные Dock/menu
   bar области.
7. Старые растянутые terrain/background layers не рисуются поверх approved
   meadow. Gameplay-объекты и собаки используют поверхность approved meadow как
   общий ground baseline.
8. Непрозрачные пиксели meadow, зданий, props, собак и UI принимают pointer.
   Только фактически прозрачная часть borderless window пропускает pointer в
   macOS.

Related:

```text
04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__D030_Fixed_26_Cell_Meadow_Zoom_And_Click_Surface_v1.md
03_DESIGN/04_DELIVERABLES/approved_art_files/STEAM_DESKTOP__meadow_source_plate_v1__approved_direction.png
```

---

### D-031 — Visual Shell Lock → Interactive Shelter Shell

Дата: 2026-07-21
Kind: `product/art/game-design boundary`
Area: `Steam/Desktop`
Status: `accepted / current sequence / static selected-H USER_ACCEPTED`

Summary:

> Текущий milestone — Visual Shell Lock; следующий — Interactive Shelter Shell.
> Day 1 / Day 2 и производство остаются будущими слоями, а пользователь является
> единственным финальным visual gate.

Decision:

1. Visual Shell Lock охватывает весь текущий roster поляны плюс Labrador,
   совместную гармонию принятых Shelter assets, масштабы и расположение поляны,
   зданий и подземной части, default camera, все четыре zoom и min/default/max
   размеры окна. CQ Hero Town — референс гармонии, но не источник копируемых
   pixels/assets/UX. Legacy fences, polygon dogs и artifacts должны быть удалены
   из runtime отдельной implementation-wave.
2. Art exploration идёт пачками 3–5 существенно разных статических композиций.
   Пользователь лично выбирает вариант, затем лично принимает live scene на
   window/zoom matrix. Автоматические проверки дают только техническое evidence.
   Любое изменение после lock требует нового user approval.
3. Interactive Shelter Shell реализует живую, но ещё непроизводящую оболочку:
   idle/walk/react dogs; entity badges/cards; один fixed rooms panel над поляной;
   горизонтальное перемещение зданий в единственном middle building-cell layer;
   front dogs/routes и back environment/decor; сохранение manual pan, zoom и
   edge auto-pan. Полный interaction/move/rooms contract живёт в текущем roadmap.
4. Один move работает как необратимая после confirm транзакция: source и
   destination зарезервированы до завершения, occupants выходят примерно через
   100 ms, jobs/state freeze и восстанавливаются, все free dogs участвуют, один
   dog атомарно переносит один box. Box count по footprint cells:
   `1→3, 2→5, 3→8, 4→10, 5→12, 6→15`; footprint `7+` запрещён.
5. Move должен переживать save/reload. Hide-with-eye не останавливает simulation;
   закрытие приложения замораживает её. После финальной доставки дом появляется
   на destination, source исчезает, assigned workers возвращаются и продолжают
   frozen work, остальные остаются idle снаружи.
6. Gameplay/economy разрешены параллельно только under the hood и не могут менять
   locked visible scene или UX без отдельного approval. Browser, Mobile, новый
   MCP и инфраструктурное расширение заморожены до приятного playable shell.
7. Manual acceptance cadence:
   `composition batch → chosen live scene → cards → move → rooms → integrated shell`.

Current gate state (2026-07-22): selected H GRID32 received direct user
`USER_ACCEPTED / PASS` as the static composition. Faithful runtime integration,
the full live window/zoom matrix and the final user live lock remain open. Exact
implementation authority is the selected-H Codex brief; static acceptance does
not authorize cards, move, rooms or gameplay expansion.

Relationships:

- D-023 Day 1 / Day 2 не отменён как будущий product material, но больше не
  задаёт current routing.
- D-024 сохраняется как immutable hash/validator-bound regression evidence.
- D-030 задаёт реализованный technical presentation baseline, который должен
  preserve selected H in live Visual Shell Lock; D-030 сам по себе не является
  текущим visual approval.

Canonical current contract:

```text
02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Game_Design_Roadmap_v2.md
03_DESIGN/00_VISUAL_DIRECTION/STEAM_DESKTOP__Visual_Production_Roadmap_v1.md
```

---

### D-032 — Versioned current presentation regression profile after D-030

Дата: 2026-07-22
Kind: `technical/QA authority boundary`
Area: `Steam/Desktop`
Status: `accepted / checkpoint-2 prerequisite`

Summary:

> D-024 остаётся неизменяемым evidence старого pre-D-030 presentation
> contract. Текущие D-030/D-031 semantics проверяет отдельный versioned
> D-030/Selected-H mechanical regression profile.

Decision:

1. D-024 fixed runner, test, normal validator и capture workflow применимы как
   immutable pre-D-030 evidence для записанного sealed runtime. D-024 authority
   digest, brief, pack, hashes и protected runner/test/validator/capture bytes
   не меняются.
2. D-030 и D-031 задают current presentation semantics: `26 / 832 / 1664`,
   zoom `50/100/150/200`, dynamic macOS height, current camera/pan без
   искусственного `15%` reserve, visible-alpha pointer и selected-H contract.
3. Current acceptance использует один отдельно versioned mechanical regression
   profile под неизменённым governed `ordinary-player` supervisor. Existing
   `observe-godot-process.py`, его fixed profile/argv и D-024 helper/test regions
   не изменяются; новый generic tooling/control/capture route не создаётся.
4. Если старый D-024 profile фактически запускают против current runtime, его
   `FAIL`/diagnostics остаются ineligible, не suppress, не allowlist и не
   считаются `PASS`. Этот запуск не является current applicability gate.
5. Checkpoint 1 остаётся `USER_ACCEPTED / PASS`. Checkpoint 2 остаётся `HOLD`,
   пока новый brief не пройдёт independent docs/brief verification и activation,
   профиль не будет реализован, а его current pre-checkpoint-2 gate не получит
   independent mechanical `PASS`.
6. После Checkpoint 2 тот же current profile обязан быть повторно применён к
   полной `min/default/max × 50/100/150/200` live matrix. Mechanical verdict,
   visual critic и прямой user visual verdict остаются разными gates.

Implementation authority candidate:

```text
04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__D030_Selected_H_Current_Presentation_Regression_Profile_v1.md
```

---

### D-033 — macOS native-quantized dynamic height and exact client-area readback

Дата: 2026-07-22
Kind: `technical/QA authority boundary`
Area: `Steam/Desktop`
Status: `accepted / D-032 amendment pending independent verification`

Summary:

> D-032 сохраняет dynamic-height semantics, но округляет требуемую высоту вверх
> до native pixel quantum максимального macOS backing scale и требует точного
> client-area readback без допуска `±1`.

Decision:

1. Для stable launch display topology профиль записывает полный список
   `DisplayServer.screen_get_scale(i)`. `q` равен их целому максимуму; любой
   non-integral scale или topology/scale drift во время governed run означает
   fail-closed `STOP`.
2. Для каждого zoom высота вычисляется точно:

   ```text
   content   = 480 × 1740 / 2992 × zoom
   required  = max(180, ceil(content))
   usable_q  = floor(usable_height / q) × q
   requested = min(ceil(required / q) × q, usable_q)
   ```

   Если `usable_q < required`, accepted composition не помещается и профиль
   останавливается без crop, scale change или workaround.
3. Height component `content_scale_size` и native window request получают
   `requested`. После settle фактический client-area
   `DisplayServer.window_get_size` обязан точно равняться request. Viewport и
   capture dimensions, а также selected-H Y-origin выводятся из actual readback.
4. Каждый state записывает `content`, `required`, полный scale list, `q`,
   `usable_q`, `requested` и `actual`. Generic `±1`, retry-to-pass, suppression
   и allowlist запрещены.
5. На текущем host `q=2`, поэтому ladder height равен
   `180 / 280 / 420 / 560`; `min × 150%` использует exact `420` и сохраняет
   полный content extent.
6. Выполненный запрос `419` с readback `418` остаётся реальным governed
   `FAIL`/ineligible evidence и никогда не становится retroactive `PASS`.
   D-024 current-run boundary D-032 не меняется.
7. Поправка к active D-032 brief сначала получает independent docs/brief
   verification и отдельную coordinator re-authorization. До этого
   implementation continuation и Checkpoint 2 остаются `HOLD`. После
   re-authorization прежняя implementation session может менять только D-032
   seam и validator; runner, observer, protected D-024 bytes, tooling и assets
   остаются неизменными.
8. Checkpoint 1 остаётся `USER_ACCEPTED / PASS`; full live Visual Shell Lock
   остаётся open; Checkpoint 2 остаётся `NOT STARTED / HOLD` до полного current
   profile implementation и independent mechanical `PASS`.

Related:

```text
04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__D030_Selected_H_Current_Presentation_Regression_Profile_v1.md
docs/repo/status/CODEX_CURRENT_STATUS.md
```

---

### D-034 — Selected-H finite projected canvas and exact render/pointer equivalence

Дата: 2026-07-22
Kind: `product/art/technical/QA boundary`
Area: `Steam/Desktop`
Status: `accepted / active-brief amendments pending independent verification`

Summary:

> Для Selected-H projected canonical canvas является единственным render/pointer
> domain. Внешний viewport остаётся прозрачным и click-through, а validator
> доказывает точное visible-alpha/pointer coverage без требования заполнить окно.

Decision:

1. Canonical design X-domain остаётся half-open `[0,2992)`. Для каждого actual
   viewport `projected_canvas_interval` равен точной проекции этого domain,
   пересечённой с viewport. Для `default × 50%` это `[0,870)`.
2. Selected-H render и pointer domains точно равны
   `projected_canvas_interval`. Background, earth, grid и roster clipping не
   позволяет whole-tile или любому другому render output выйти за projected
   canonical canvas. Arbitrary composition extension запрещён.
3. Viewport exterior вне projected canvas остаётся фактически прозрачным и
   click-through. Внутри domain каждый фактически visible-alpha pixel/column
   покрыт pointer surface, а прозрачное небо выше local alpha top пропускает
   pointer. Visible alpha без pointer и pointer в true exterior запрещены.
4. Общая render/pointer boundary точная: sampled-lattice approximation и
   `4 px` tapered edge недопустимы.
5. Current validator проверяет per-column/per-alpha equivalence, а не глобальное
   `sampled_top_max < viewport_height`, `opaque_content_clickable=true` для
   каждого viewport column или требование заполнить viewport opaque content.
   Каждый state записывает:

   ```text
   projected_canvas_interval
   visible_alpha_x_intervals
   pointer_content_x_intervals
   transparent_exterior_x_intervals
   uncovered_visible_alpha_pixels = 0
   uncovered_visible_alpha_columns = 0
   exterior_clickable_pixels = 0
   exterior_clickable_columns = 0
   ```

6. Negative fixtures обязаны отвергать current whole-tile overdraw, visible
   alpha без pointer, pointer в exterior и tapered boundary. Legitimate exterior
   sentinel равный viewport height обязан приниматься.
7. D-030 full-width tiling narrowly superseded только для Selected-H low-zoom
   exterior. Для `default × 50%` exact render/pointer interval равен `[0,870)`,
   transparent exterior — `[870,1280)`. D-030 visible-alpha pointer rule,
   D-033 height contract и D-024 applicability boundary не меняются.
8. Retained complete 12-state ordinary-player process/matrix остаётся evidence,
   но executed strict-validator `FAIL` реален, ineligible и никогда не становится
   retroactive `PASS`. Checkpoint 1 остаётся `USER_ACCEPTED / PASS`; default ×
   `50%` ранее не принимался; full live Visual Shell Lock остаётся open;
   Checkpoint 2 остаётся `NOT STARTED / HOLD`.
9. До independent verification поправок active D-032/Selected-H briefs и
   отдельной coordinator re-authorization implementation continuation запрещён.
   После неё та же implementation session может менять только bounded
   Selected-H render/pointer/seam в `vertical_slice_demo.gd` и current D-032
   validator. Runner, observer, protected D-024 bytes, tooling, assets,
   gameplay/save и Checkpoint 2 остаются неизменными.

Approval provenance:

> “Одобряю Route 1: для Selected‑H считать projected canonical canvas
> единственным render/pointer domain, клиповать whole‑tile overdraw за его
> границей, оставлять внешний transparent interval click‑through и валидировать
> точное совпадение visible alpha с pointer без глобального требования заполнить
> viewport; оформить D‑034 и поправки active D‑032/Selected‑H briefs, продолжить
> только после независимой проверки документов и coordinator re‑authorization”

Related:

```text
04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__D030_Selected_H_Current_Presentation_Regression_Profile_v1.md
04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Selected_H_Visual_Shell_Runtime_Integration_And_Live_Matrix_v1.md
docs/repo/status/CODEX_CURRENT_STATUS.md
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

## 4. Current update

### 2026-07-22 — selected H static Visual Shell Lock

- User issued full static acceptance for selected H GRID32.
- Current gate advanced from composition exploration to bounded runtime
  integration and live matrix; Interactive Shelter Shell remains next.
- Exact source/geometry/depth/grid/pivot contract is routed through one Codex
  brief; no gameplay or later-shell scope was activated.
