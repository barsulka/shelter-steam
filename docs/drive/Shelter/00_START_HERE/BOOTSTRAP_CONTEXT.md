# BOOTSTRAP_CONTEXT — Shelter compressed entry point

Дата создания: 2026-07-07
Обновлено: 2026-07-12
Статус: active bootstrap / current-summary
Владелец: Producer / Project Manager
Назначение: быстрый вход новой AI-сессии в актуальный контекст Shelter без чтения всей истории.

---

## 0. Как пользоваться

Новая серьёзная сессия Shelter читает:

1. `PROJECTS_RULES.md`
2. `AGENTS.md`
3. `README.md`
4. этот файл — `docs/drive/Shelter/00_START_HERE/BOOTSTRAP_CONTEXT.md`
5. role-doc из `docs/drive/Shelter/00_START_HERE/000_ROLE_*.md`
6. один релевантный current-context документ по зоне задачи
7. только потом deep docs по конкретной задаче

Этот файл не заменяет решения и specs. Он говорит, что сейчас является актуальным и куда идти дальше.

---

## 1. Project identity

Shelter — группа тёплых, спокойных, этичных приложений и игр вокруг помощи собакам и приютам.

Планируемые продукты:

1. Steam/Desktop idle game для Windows/macOS.
2. Mobile idle/farm game.
3. Browser Extension: “посмотри рекламу — накорми собак”.

Ключевой принцип D-020:

> Shelter делает богаче жизнь, а не склад.

Уточнение D-020:

> Shelter — это производственный кооператив, в котором живут собаки. Производство остаётся ядром, а жизнь собак делает это ядро живым.

Запрещено: бои, PvP, боссы, монстры, paid gacha, агрессивный FOMO, guilt pressure, манипулятивная благотворительность, forced donations, dark patterns.

---

## 2. Current priority

Текущий активный продуктовый фокус: **Steam/Desktop**.

Текущий Steam/Desktop этап:

```text
First Day MVP закрыт на уровне prototype/product-language proof.
D-022 Day 2 same-chain Warm Food Delivery variation завершена на уровне prototype/product-language/runtime-evidence.
R-29 закрыт / PASS.
D-023 First Day + Day 2 player journey scope lock принят.
```

Текущая граница следующей работы:

> R-29 не создаёт автоматический successor из preview R&D. Новый scope выбран отдельно через D-023: `First 48 Hours Playable`.

Актуализация D-023:

> Successor scope теперь выбран: `First 48 Hours Playable` как session-based First Day + Day 2 player journey. R48-01A, R48-02A и R48-02B завершены/PASS; R48-03 persisted First Day → Day 2 transition brief является следующим gate.

Источник:

```text
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__First_Day_MVP_Lock_And_Next_Scope_Decision_v1.md
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__First_Week_Direction_v1.md
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__First_48_Hours_Playable_Scope_Lock_v1.md
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__First_48_Hours_Playable_Roadmap_v1.md
```

### Current working environment

По D-021 проект работает как локальный ChatGPT Work/Codex project поверх текущего checkout монорепозитория:

```text
Work/Codex -> direct local filesystem access to this checkout.
Shelter MCP -> optional local domain-specific runtime/inspection adapter in mcp/.
Shelter MCP setup -> project-scoped `.codex/config.toml` + `mcp/run.sh` over STDIO.
```

Отдельные ролевые задачи не считаются общей памятью. Их долговременная синхронизация идёт через Current Memory, Knowledge, RFC, brief и handoff.

---

## 3. Steam/Desktop current state

Steam/Desktop — Godot 4.x desktop game, Windows/macOS target, horizontal always-on-top sidescroll strip.

Core structure D-009:

```text
cozy idle production strip + dog community sim
```

Steam/Desktop — не классическая ферма. По D-013 сырьевые ресурсы добываются через off-screen поездки собак на внешние фермерские локации, а Steam-полоска остаётся кооперативом/мастерской.

First Day accepted structure:

```text
Beat 1 — В кооперативе первый рабочий день
Beat 2 — Первая поездка за ресурсами
Beat 3 — Собаки вместе готовят поставку
Beat 4 — Игрок отправляет первую поставку
Beat 5 — Открытка, тапочки, память и намёк на следующий визит
```

First Day locked elements:

```text
Такса — первый водитель
Лабрадор — спокойный помощник
Route — Овсяная ферма / route.oat_farm_intro
Order — Первая тёплая поставка / order.first_warm_delivery
Reward — Удобные тапочки для Таксы
Memory — Помнит первую тёплую поставку
```

First Day visual-language status:

```text
STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v3: PASS as First Day Art/UX Visual Language Pass.
NOT production art. NOT shipping UX. NOT final animation polish.
```

---

## 4. Current implementation state

Godot prototype exists under `steam/`.

Implemented / available:

- Steam/Desktop Godot project skeleton.
- Companion / transparent strip window tech demos.
- Vertical Slice prototype.
- Dog rig spikes and dog runtime integration slice.
- Godot State Connector.
- Godot Control Connector.
- Workbench Runtime Capture Harness.
- Shelter MCP source under `mcp/`; project-scoped local STDIO setup is complete.
- First Day MVP runtime proof.
- First Day visible review capture packs v1/v2/v3.
- First Day Art/UX visual-language pass v1 implemented and accepted as prototype pass.
- Day 2 return + complete second warm delivery runtime/evidence proof implemented and accepted; R-29 closed / PASS.
- R48-01A clean ordinary PlayerBoot route implemented for F5/`play.sh`/internal export; bounded `dev.sh` separates developer workflows.
- R48-02A strict player-profile envelope/store/recovery foundation implemented and verified; it is not yet wired to Continue or gameplay checkpoints.

Latest dev status source:

```text
docs/repo/status/CODEX_STATUS.md
```

For new work, do not treat all old Codex log entries as current. Use current-context docs and latest status entry first.

---

## 5. Active current-context documents

Read these instead of reconstructing context from many old docs:

```text
docs/drive/Shelter/00_START_HERE/BOOTSTRAP_CONTEXT.md
docs/drive/Shelter/00_START_HERE/SUPERSEDED_MAP.md
docs/drive/Shelter/00_START_HERE/05_DOCUMENTATION_GOVERNANCE.md
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__CURRENT_CONTEXT.md
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/GAME_DESIGN__CURRENT_CONTEXT.md
docs/drive/Shelter/03_DESIGN/ART_DIRECTION__CURRENT_CONTEXT.md
docs/drive/Shelter/04_DEVELOPMENT/CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md
docs/repo/status/CODEX_CURRENT_STATUS.md
```

Documentation memory is layered:

```text
Current Memory — short current truth for bootstrap.
Knowledge — active decisions, specs, references and ADRs read by task.
History — handoff, completed briefs, capture packs, evidence and long logs.
```

Default rule:

```text
Read Current Memory first. Read Knowledge only for the concrete task. Read History only for evidence, regression or archaeology.
```

Role docs:

```text
docs/drive/Shelter/00_START_HERE/000_ROLE_PRODUCER.md
docs/drive/Shelter/00_START_HERE/000_ROLE_GAME_DESIGNER.md
docs/drive/Shelter/00_START_HERE/000_ROLE_ART_DIRECTOR.md
docs/drive/Shelter/00_START_HERE/000_ROLE_PROJECT_MANAGER.md
docs/drive/Shelter/00_START_HERE/000_ROLE_CODEX.md
```

---

## 6. Active decision / philosophy docs

Read when making or checking product-level decisions:

```text
docs/drive/Shelter/00_START_HERE/02_DECISIONS.md
docs/drive/Shelter/00_START_HERE/03_PROJECT_PHILOSOPHY.md
docs/drive/Shelter/00_START_HERE/04_SHELTER_STRESS_TESTS.md
docs/drive/Shelter/00_START_HERE/04_COLLABORATION_PROTOCOL.md
```

Important accepted decisions:

- D-007 — Godot for Steam/Desktop.
- D-008 — Browser Extension core loop.
- D-009 — Steam/Desktop horizontal dog production co-op.
- D-010 — innate vs acquired/equipment dog traits.
- D-011 — Cozy Modular Diorama as visual candidate, not final art style.
- D-012 — Browser Farm and Steam Co-op are different parts of one world; MVP link is narrative-only.
- D-013 — Steam resource trips replace visible crop farming.
- D-014..D-017 — role boundaries, collaboration protocol, Codex brief rule.
- D-018..D-019 — gameplay proof / visual proof split; Workbench over live Godot runtime.
- D-020 — Project Philosophy / Shelter Constitution.
- D-021 — local ChatGPT Work/Codex checkout and Shelter MCP boundary.
- D-022 — complete same-chain Day 2 Warm Food Delivery executable scope lock.
- D-023 — session-based First Day + Day 2 player journey, exact input budget, persisted reserve, Quiet Cooperative, Labrador P0 and Kitchen P1.

---

## 7. Do not read by default

Do not load these during normal bootstrap unless the task is specifically about evidence, regression, art review, or historical reconstruction:

- old capture PNG folders;
- old visible review capture packs v1/v2 when v3 is enough;
- old Vertical Slice Art QA capture packs when First Day v3 is enough;
- old Codex brief files for completed tasks;
- old handoff files except the latest relevant one;
- superseded standalone simulator brief;
- long historical sections of `CODEX_STATUS.md` unless investigating implementation history.

Use:

```text
docs/drive/Shelter/00_START_HERE/SUPERSEDED_MAP.md
```

---

## 8. Role-specific entry points

### Producer

Read:

```text
000_ROLE_PRODUCER.md
BOOTSTRAP_CONTEXT.md
STEAM_DESKTOP__CURRENT_CONTEXT.md
03_PROJECT_PHILOSOPHY.md
02_DECISIONS.md
```

Producer focus now: keep D-023 scope locked while R48-03 transition brief is prepared and protect the exact player-journey/no-obligation boundary.

### Game Designer

Read:

```text
000_ROLE_GAME_DESIGNER.md
STEAM_DESKTOP__CURRENT_CONTEXT.md
GAME_DESIGN__CURRENT_CONTEXT.md
STEAM_DESKTOP__First_Day_MVP_Lock_And_Next_Scope_Decision_v1.md
STEAM_DESKTOP__First_Week_Direction_v1.md
```

Game Designer focus now: preserve D-022 causality plus the D-023 `3 + 2` input budget, persisted reserve and Quiet Cooperative boundary.

### Art Director / UX

Read:

```text
000_ROLE_ART_DIRECTOR.md
STEAM_DESKTOP__CURRENT_CONTEXT.md
ART_DIRECTION__CURRENT_CONTEXT.md
STEAM_DESKTOP__Art_UX_Review__First_Day_MVP_v3.md
D-011_Cozy_Modular_Diorama_Candidate_A.md
```

Art/UX focus now: evaluate current world/room/dog preview R&D without promoting it to production art, final style, runtime scope or asset approval.

### Codex / Development

Read:

```text
000_ROLE_CODEX.md
CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md
docs/repo/adr/README.md
steam/AGENTS.md
steam/README.md
```

Codex work must be assigned through a brief file in:

```text
docs/drive/Shelter/04_DEVELOPMENT/
```

Current workflow migration brief:

```text
docs/drive/Shelter/04_DEVELOPMENT/SHELTER_WORKFLOW__Codex_Brief__ChatGPT_Work_And_Local_MCP_Migration_v1.md
```

### Project Manager / Knowledge Base Maintainer

Read:

```text
000_ROLE_PROJECT_MANAGER.md
BOOTSTRAP_CONTEXT.md
SUPERSEDED_MAP.md
01_CURRENT_STATUS.md
02_DECISIONS.md
```

PM focus now: preserve D-021/R-29 history, keep D-023 Current Memory synchronized and coordinate R48-03 brief preparation without scope drift.

---

## 9. Current best next steps

Workflow / Codex:

```text
D-021 local Work/Codex migration is complete. Use the checkout directly for files and the optional local Shelter MCP only for bounded knowledge/runtime/inspection tools.
```

Product / Game Design:

```text
D-022 is implemented and R-29 is closed / PASS. D-023 now selects the First Day + Day 2 player journey; use the accepted Scope Lock and R48 roadmap, not preview R&D, as authority.
```

Current accepted Codex sequence:

```text
STEAM_DESKTOP__Codex_Brief__Playable_Main_Scene_And_Launch_Surfaces_v1.md
STEAM_DESKTOP__Codex_Brief__Player_Save_Store_Schema_And_Recovery_v1.md
```

R48-01A, R48-02A and R48-02B are completed/PASS. First Day autosave/Continue is implemented; organic Continue → Day 2 remains R48-03.

Reasoning level if assigned to Codex:

```text
очень высокий
```

Documentation / PM:

```text
Keep BOOTSTRAP_CONTEXT, SUPERSEDED_MAP, STEAM_DESKTOP__CURRENT_CONTEXT and CODEX__CURRENT_IMPLEMENTATION_CONTEXT up to date after major sessions.
```

---

## 10. Changelog

### 2026-07-12 — R48-02B completed / PASS

- Implemented and verified the exact First Day checkpoint/Continue contract, including durable save acknowledgement, restart/kill recovery and the seventeen-cursor matrix.
- Preserved the exact three-input flow and honest reserve arithmetic.
- Kept organic ordinary Continue → Day 2 in R48-03.

### 2026-07-12 — R48-02A completed

- Added the strict non-playable player-profile store/recovery foundation and verified restart/SIGKILL behavior.
- Kept gameplay authority and offline/session semantics unchanged.
- Advanced only to R48-02B brief preparation; Continue and persisted Day 2 remain pending.

### 2026-07-12 — R48-01A completed

- Replaced the ordinary placeholder launch with one clean PlayerBoot route shared by F5, `play.sh` and macOS export.
- Added bounded `dev.sh` without replacing legacy specialized tools.
- Advanced the sequential program to current R48-02A; functional Continue remains R48-02B.

### 2026-07-12 — R48 implementation preflight accepted

- Accepted R48-01A for immediate sequential implementation.
- Accepted ADR-0003 and queued R48-02A after R48-01A.
- Kept R48-02B checkpoint integration and R48-03 Day 2 transition outside the first two code waves.

### 2026-07-12 — D-023 / First 48 Hours selected

- Recorded user acceptance A/A/A and D-023.
- Made the First 48 Hours roadmap and Scope Lock the active player-journey authority.
- Routed current work to R48-01A/R48-02A preflight while preserving R-29 as completed evidence.

### 2026-07-12 — R-29 closed / Day 2 accepted

- Recorded the accepted Day 2 runtime/evidence result and R-29 closeout.
- Removed the completed Day 2 brief as the current implementation task.
- Kept world/room/dog visual work as separate preview R&D and intentionally left the next executable scope unselected.

### 2026-07-11 — D-022 Day 2 scope lock

- Accepted the complete same-chain Day 2 slice and made its canonical brief the next implementation entry point.
- Closed the Day 2 readiness/boundary questions while leaving production art and platform readiness separate.

### 2026-07-10 — ChatGPT Work migration wave

- Added D-021 local Work/Codex working environment and explicit Shelter MCP boundary.
- Linked the completed local Work/Codex and Shelter MCP migration brief.
- Kept Steam product priority and all product/game/art decisions unchanged.

### 2026-07-07 — Game Design and Art Direction current contexts

- Added `GAME_DESIGN__CURRENT_CONTEXT.md` and `ART_DIRECTION__CURRENT_CONTEXT.md` to active current-context entry points.
- Updated role-specific entry points for Game Designer and Art Director.

### 2026-07-07 — documentation governance layer

- Added `05_DOCUMENTATION_GOVERNANCE.md` and `CODEX_CURRENT_STATUS.md` to current-context entry points.
- Added Current Memory / Knowledge / History reading rule.
- Clarified that History should only be read for evidence, regression or archaeology.

### 2026-07-07 — v1 created

- Created compressed bootstrap entry point.
- Established layered reading model: bootstrap -> current context -> role/product docs -> deep docs.
- Marked First Day MVP as current locked prototype/product-language proof.
- Marked First Week / Day 2 as current next scope.
- Added explicit do-not-read-by-default guidance for old captures, completed briefs and historical logs.
