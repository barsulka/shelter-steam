# KNOWLEDGE_BASE_ROADMAP — Shelter

Дата создания: 2026-07-07
Статус: active roadmap
Владелец: Project Manager / Producer
Назначение: рабочий roadmap эволюции базы знаний Shelter и MCP knowledge layer.

---

## 0. Purpose

Этот roadmap нужен, чтобы не спрашивать на каждом шаге “что дальше?”.

Он не является immutable plan. Его можно менять, если появляется более правильная последовательность, но изменения должны быть осознанными и фиксироваться в changelog.

Главное направление:

```text
Документация Shelter перестаёт быть набором Markdown-файлов и становится управляемой базой знаний с Current Memory, Knowledge, History и MCP knowledge access layer.
```

---

## 1. Operating model

Работа разделена на две параллельные ветки:

### Branch A — Codex / MCP Knowledge API

Codex развивает Shelter MCP как deterministic knowledge access service:

- без generic shell;
- без arbitrary git commands;
- без network calls;
- без AI summarization;
- без vector DB / embeddings;
- без write-поведения в knowledge tools;
- только bounded deterministic tools по локальным документам.

### Branch B — PM / Producer Knowledge Base Cleanup

PM / Producer приводит в порядок ядра знаний:

- decisions;
- roadmaps;
- handoff;
- current-context docs;
- open questions;
- evidence/history policies.

---

## 2. Phase 1 — Foundation

Статус: `done`

Цель:

Создать базовый слой Current Memory / Knowledge / History и первый MCP knowledge layer.

Done:

- `BOOTSTRAP_CONTEXT.md` created.
- `SUPERSEDED_MAP.md` created.
- `05_DOCUMENTATION_GOVERNANCE.md` created.
- `EVIDENCE_READ_POLICY.md` created.
- `STEAM_DESKTOP__CURRENT_CONTEXT.md` created.
- `CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md` created.
- `CODEX_CURRENT_STATUS.md` created.
- `03_OPEN_QUESTIONS.md` refreshed into living register.
- Shelter MCP repo tools v1/v2 implemented.
- Shelter MCP knowledge service v1 implemented:
  - `find_current_context`
  - `list_active_docs`
  - `classify_doc_path`
  - `explain_superseded`
  - `knowledge_gc_report`

Definition of Done:

```text
New Shelter sessions can enter through Current Memory instead of reading old briefs, captures, handoff and full Codex logs.
```

---

## 3. Phase 2 — Core Knowledge Cleanup

Статус: `active`

Цель:

Привести в порядок основные источники истины, чтобы MCP Knowledge API возвращал не просто список файлов, а качественные ответы по чистым docs.

### 2.1 Decisions cleanup

Статус: `next`

Target:

```text
docs/drive/Shelter/00_START_HERE/02_DECISIONS.md
```

Задачи:

- отделить actual decisions от history/context;
- проверить, что D-001..D-020 имеют короткие stable summaries;
- добавить links to current-context docs where useful;
- отметить decisions that are implementation/process-oriented vs product-oriented;
- не менять смысл принятых решений без явного product decision.

Definition of Done:

```text
02_DECISIONS.md можно быстро читать как source of truth, а не как историю обсуждений.
```

---

### 2.2 Roadmaps cleanup

Статус: `planned`

Target candidates:

```text
STEAM_DESKTOP__Game_Design_Roadmap_v2.md
other active roadmap docs found by Knowledge GC
```

Задачи:

- оставить roadmaps как рабочие очереди;
- вынести/отметить history;
- проверить, что next step совпадает с current status;
- не превращать roadmap в archive.

Definition of Done:

```text
Active roadmap docs answer: what next, why, and what is out of scope.
```

---

### 2.3 Handoff cleanup

Статус: `planned`

Target:

```text
docs/drive/Shelter/06_SESSIONS_AND_HANDOFFS/**
```

Задачи:

- не переписывать историю;
- определить latest relevant handoff per role/area;
- update indexes/current docs to point to latest useful handoff;
- rely on history policy instead of reading all handoff.

Definition of Done:

```text
New sessions know which handoff to read, and old handoff are treated as History.
```

---

### 2.4 Current Context expansion

Статус: `planned`

Candidate docs:

```text
ART_DIRECTION__CURRENT_CONTEXT.md
GAME_DESIGN__CURRENT_CONTEXT.md
BROWSER_EXTENSION__CURRENT_CONTEXT.md
MOBILE__CURRENT_CONTEXT.md
```

Задачи:

- create only when needed;
- avoid empty bureaucracy;
- start with Art Direction and Game Design if next sessions require deep history.

Definition of Done:

```text
Each active domain can be entered through one short current-context document instead of many historical docs.
```

---

## 4. Phase 3 — MCP Knowledge API v2

Статус: `ready for Codex brief`

Цель:

Перейти от “какие документы читать?” к “какие знания относятся к задаче?”.

Candidate tools:

```text
list_decisions(area, kind)
get_decision(decision_id)
list_open_questions(area, status)
list_roadmaps(area)
roadmap_status(area)
latest_handoff(role, area)
knowledge_task_context(role, area, task)
```

Important constraints:

- deterministic;
- bounded;
- static catalog / simple parsing;
- no AI summarization;
- no broad arbitrary repo search;
- no writes;
- no network.

Definition of Done:

```text
A session can ask MCP for decisions/open questions/roadmaps/handoff relevant to an area without manually opening many files.
```

---

## 5. Phase 4 — Knowledge GC v2

Статус: `future`

Цель:

Сделать Knowledge GC более actionable.

Candidate tools:

```text
knowledge_gc_plan(area)
missing_metadata_report(area)
current_context_drift_report(area)
completed_brief_candidates(area)
```

Definition of Done:

```text
PM can run a deterministic report that suggests what to update next without modifying files automatically.
```

---

## 6. Phase 5 — Producer Dashboard

Статус: `future`

Цель:

Получать агрегированную картину проекта без ручного чтения многих docs.

Candidate tool:

```text
shelter_status(area)
```

Example output:

```text
current scope
current roadmap
active decisions
active open questions
current Codex task
risks / blocked by
latest relevant handoff
```

Definition of Done:

```text
Producer can get a compact project status from MCP and then open only relevant source docs.
```

---

## 7. Current next steps

### Codex next

Implement MCP Knowledge API v2 from brief:

```text
docs/drive/Shelter/04_DEVELOPMENT/SHELTER_MCP__Codex_Brief__Knowledge_API_v2.md
```

### PM / Producer next

Start Phase 2.1:

```text
Clean up docs/drive/Shelter/00_START_HERE/02_DECISIONS.md
```

Focus:

- improve readability;
- preserve decisions;
- remove/relocate history only if clearly safe;
- update changelog.

---

## 8. Changelog

### 2026-07-07 — Phase 2 cleanup handoff completed

- Created final handoff `producer/2026-07-07__producer_pm_handoff__knowledge_base_phase_2_cleanup.md`.
- Updated `HANDOFF_INDEX.md` to point to the latest Phase 2 cleanup handoff.
- Phase 2 is complete enough to stop documentation cleanup and return to product work unless new problems appear.

### 2026-07-07 — Phase 2.4 current-context expansion started

- Created `GAME_DESIGN__CURRENT_CONTEXT.md` for Steam/Desktop Game Design sessions.
- Created `ART_DIRECTION__CURRENT_CONTEXT.md` for Steam/Desktop Art Direction / UX sessions.
- Added both current-context docs to `BOOTSTRAP_CONTEXT.md`, `01_CURRENT_STATUS.md` and `05_DOCUMENTATION_GOVERNANCE.md`.
- Browser Extension and Mobile current-context docs remain future candidates.

### 2026-07-07 — Phase 2.3 handoff cleanup started

- Created `06_SESSIONS_AND_HANDOFFS/HANDOFF_INDEX.md` as the current entry point for handoff history.
- Added handoff read-policy to `05_DOCUMENTATION_GOVERNANCE.md` and `01_CURRENT_STATUS.md`.
- Preserved existing handoff files without moving or rewriting them.
- Next PM step: Phase 2.4 Current Context expansion, starting with deciding whether Game Design / Art Direction current-context docs are needed now.

### 2026-07-07 — Phase 2.2 roadmap cleanup started

- Classified Steam/Desktop roadmap docs by current role: v2 active, v1 history, systems v1 completed reference, remaining snapshot archive.
- Added current navigation to `STEAM_DESKTOP__Game_Design_Roadmap_v2.md`.
- Next PM step: decide whether Phase 2.2 needs additional roadmap cleanup or move to Phase 2.3 handoff cleanup.

### 2026-07-07 — Phase 2.1 decision log cleanup started

- Cleaned up `02_DECISIONS.md` into a structured decision log.
- Preserved D-001..D-020 while reducing historical narrative and correcting document structure.
- Next PM step: review roadmap docs under Phase 2.2 after decision-log diff is accepted.

### 2026-07-07 — v1 created

- Created roadmap for Shelter knowledge base evolution.
- Split work into Codex/MCP branch and PM/Producer documentation branch.
- Marked Phase 1 as done, Phase 2 as active, Phase 3 as ready for Codex brief.
