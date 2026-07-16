# KNOWLEDGE_BASE_ROADMAP — Shelter

Дата создания: 2026-07-07
Обновлено: 2026-07-15
Статус: active roadmap
Владелец: Project Manager / Producer
Назначение: рабочий roadmap эволюции базы знаний Shelter и source-derived MCP context routing.

---

## 0. Purpose

Этот roadmap нужен, чтобы не спрашивать на каждом шаге “что дальше?”.

Он не является immutable plan. Его можно менять, если появляется более правильная последовательность, но изменения должны быть осознанными и фиксироваться в changelog.

Главное направление:

```text
Локальные source documents образуют управляемую базу знаний с Current Memory, Knowledge и History. Здоровый MCP source-derived bundle является default routine bootstrap/context-routing path, но не становится отдельной проектной памятью; direct source reads остаются authority и exact fallback.
```

Authoritative compact-catalog state:

```text
Catalog status: active roadmap
Catalog current phase: D-026 accepted, implemented and independently reviewed PASS; healthy shelter_context_bundle is the active routine bootstrap/context-routing default.
Catalog next step: Return to the already-governed D-024 capture-only macOS self-capture, evidence seal and Art/user review wave. Keep Knowledge Base maintenance bounded to concrete drift or the first remote-CI signal.
```

---

## 1. Operating model

Работа разделена на две параллельные ветки:

### Branch A — Codex / MCP Knowledge API

Codex поддерживает bounded deterministic knowledge navigation внутри local domain-specific Shelter MCP:

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

Статус: `completed 2026-07-10; maintenance only`

Цель:

Привести в порядок основные источники истины, чтобы MCP Knowledge API возвращал не просто список файлов, а качественные ответы по чистым docs.

### 2.1 Decisions cleanup

Статус: `completed 2026-07-07; D-021 added 2026-07-10`

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

Статус: `completed initial pass 2026-07-07`

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

Статус: `completed initial pass 2026-07-07`

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

Статус: `Art/Game Design contexts completed; Browser/Mobile deferred until active`

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

Статус: `legacy v2 implemented historically / D-026 independent review PASS / daily default active`

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
- source-derived parse-on-request snapshot;
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

Статус: `future/optional after migration; no automatic writes`

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

Статус: `source-derived projection implemented / independent review PASS / daily default active`

Цель:

Получать агрегированную картину проекта без ручного чтения многих docs.

Focused source-derived projection (legacy schema compatibility retained):

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

Daily default — `shelter_context_bundle(...)`; focused
`shelter_status(area)` остаётся совместимой source-derived проекцией.

---

## 7. Current next steps

### Project next

Return to the already-governed D-024 capture-only completion; no new D-026 implementation wave is active:

```text
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__D024_Responsive_Meadow_Marker_And_Player_Presentation_Cleanup_v1.md
```

### PM / Producer next

Preserve the accepted D-026 routine-default/source-fallback boundary during normal project work:

```text
Healthy MCP bundle is the routine bootstrap route; direct source reads remain authority/exact verification and documented fallback.
```

Focus:

- keep Current Memory fresh;
- observe the first remote CI run without treating it as an acceptance blocker;
- preserve the accepted semantic-governance boundary and honest 4 KiB fallback behavior;
- avoid new documentation restructuring without a concrete friction signal.

---

## 8. Changelog

### 2026-07-15 — D-026 final reviewer PASS / return to governed project work

- Recorded independent re-review `PASS`, closure of all four prior findings and active daily-default MCP-first routing.
- Closed D-026 remediation/re-review work; retained first remote CI and the accepted semantic/4 KiB fallback boundaries as non-blocking residuals.
- Returned the next step to the already-governed D-024 macOS self-capture/seal/Art-user review wave without creating new product scope.

### 2026-07-15 — D-026 remediation local PASS / independent re-review next

- Recorded all four independent-review findings as fixed locally and the full local matrix/client smokes as passing.
- Replaced active fix/resolve work with independent re-review as the sole current next step.
- Kept final acceptance and daily-default rollout pending reviewer PASS, with direct source fallback active until then.

### 2026-07-15 — D-026 implementation present / re-review blocked

- Replaced the obsolete static-catalog-red/implement-next state with the implemented source-derived happy-path result.
- Recorded independent review `BLOCKED` and made P1/P2 remediation plus full-matrix re-review the current next step.
- Kept direct source reads as the active fallback until reviewer PASS enables daily-default rollout.

### 2026-07-15 — D-026 source-derived context bridge activated

- Replaced optional static-catalog navigation as the target state with MCP-first source-derived routine bootstrap.
- Recorded the current MCP knowledge path as non-current/red until the executable D-026 brief passes.
- Kept local source docs as authority and exact fallback without changing product/game/art work.

### 2026-07-10 — D-021 migration correction

- Made local source documents, not MCP, the project-memory source of truth.
- Updated completed Phase 2/3/Producer Dashboard statuses.
- Completed the local Work/Codex + MCP migration and activated source/catalog drift validation.
- Preserved bounded read-only knowledge navigation as an optional MCP capability.

### 2026-07-09 — polish roadmap created

- Added `KNOWLEDGE_BASE_POLISH_ROADMAP.md` for the remaining fresh-session entry friction.
- Next polish split: Codex works on MCP decision digest / dashboard tools; PM standardizes current-context docs and adds `01_CURRENT_STATUS.md` anti-bloat guardrails.

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
