# KNOWLEDGE_BASE_POLISH_ROADMAP — Shelter

Дата создания: 2026-07-09
Обновлено: 2026-07-15
Статус: active short roadmap
Владелец: Project Manager / Producer
Назначение: короткий roadmap по устранению оставшихся проблем входа в документацию после Phase 2 cleanup.

---

## 0. Why this exists

После Phase 2 fresh-session entry стало значительно легче, но остались верхнеуровневые риски:

1. `02_DECISIONS.md` стал лучше, но всё ещё длинный и со временем потребует компактного catalog/summary слоя.
2. Current-context docs нужно стандартизировать по единому шаблону.
3. `01_CURRENT_STATUS.md` может снова начать разрастаться в “второй README”.
4. Верхний слой уже включает несколько документов: `BOOTSTRAP_CONTEXT`, `01_CURRENT_STATUS`, current-context docs, `KNOWLEDGE_BASE_ROADMAP`.
5. Source-derived MCP bridge и four-finding remediation реализованы и независимо reviewed `PASS`; daily-default rollout активен. Неблокирующие residuals ограничены первым remote CI, принятой semantic-governance boundary и честным 4 KiB fallback при недостаточном budget.

Этот roadmap фиксирует план, чтобы исправлять это постепенно и не уходить в бесконечную документационную полировку.

Authoritative compact-catalog state:

```text
Catalog status: active short roadmap
Catalog current phase: D-026 accepted, implemented and independently reviewed PASS; healthy shelter_context_bundle is the active routine bootstrap/context-routing default.
Catalog next step: Return to the already-governed D-024 capture-only macOS self-capture, evidence seal and Art/user review wave; run Knowledge GC only on a concrete drift signal.
```

---

## 1. Operating principle

```text
Fix entry friction, not history.
```

Не делать массовых переносов файлов без необходимости.

Не превращать cleanup в отдельный бесконечный продукт.

Приоритет:

```text
1. сделать верхний вход коротким;
2. стандартизировать current-context;
3. использовать healthy source-derived MCP bundle как default routine bootstrap/context-routing path;
4. вернуться к продуктовой работе Day 2.
```

---

## 2. Phase P1 — Decision Catalog / compact decision layer

Статус: `source-derived implementation / independent review PASS / daily default active`

Проблема:

`02_DECISIONS.md` теперь структурирован, но всё ещё длинный. Свежая сессия не должна читать его целиком, если нужен только список актуальных решений.

Цель:

Создать компактный decision entry layer.

Implemented shape:

- MCP exposes compact decision/dashboard tools.
- `02_DECISIONS.md` remains the source document.
- Current facts are parsed from canonical source docs on request; static current-fact mirrors/fingerprints are removed.
- All four budget/error, conflict, legacy-kind and task-routing findings are independently verified closed; final rollout is active.

Possible docs artifact:

```text
docs/drive/Shelter/00_START_HERE/DECISION_CATALOG.md
```

Definition of Done:

```text
Fresh session can get all active decisions as compact summaries without opening full 02_DECISIONS.md.
```

---

## 3. Phase P2 — Current-context template standardization

Статус: `completed 2026-07-09`

Проблема:

Current-context docs уже полезны, но их структура должна быть одинаковой, чтобы новые сессии читали их почти автоматически.

Target docs:

```text
STEAM_DESKTOP__CURRENT_CONTEXT.md
GAME_DESIGN__CURRENT_CONTEXT.md
ART_DIRECTION__CURRENT_CONTEXT.md
CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md
```

Standard shape:

```text
0. How to use
1. Current truth
2. Active roadmap / current task
3. Current decisions
4. Active open questions
5. Read next by task
6. Do not read by default
7. Known caveats
8. Next best step
9. Changelog
```

Definition of Done:

```text
All active current-context docs share a recognizable structure and preserve existing content without changing product decisions.
```

---

## 4. Phase P3 — Current Status guardrail

Статус: `completed 2026-07-09`

Проблема:

`01_CURRENT_STATUS.md` risks becoming a second README/index if every new document is added there.

Goal:

Make it a short “where are we now?” status page with clear boundary.

Rules to add:

- `01_CURRENT_STATUS.md` is not a full index.
- It should link to dashboards/current-context docs, not duplicate all of them.
- Large lists should live in `BOOTSTRAP_CONTEXT`, `HANDOFF_INDEX`, `EVIDENCE_READ_POLICY`, MCP knowledge tools or product current-context docs.

Definition of Done:

```text
01_CURRENT_STATUS.md has explicit anti-bloat boundary and remains short enough for bootstrap.
```

---

## 5. Phase P4 — Producer Dashboard / top entry

Статус: `source-derived projection implemented / independent review PASS / daily default active`

Проблема:

Top layer has multiple entry docs. Fresh sessions still need to know “where are we now?” quickly.

Goal:

Create one compact producer-facing status view.

Focused source-derived projection (legacy schema compatibility retained):

```text
shelter_status(area)
```

Possible docs fallback:

```text
docs/drive/Shelter/00_START_HERE/PRODUCER_DASHBOARD.md
```

Dashboard should include:

```text
current focus
current scope
current roadmap/current task
active decisions
active open questions
blocked by / risks
latest handoff
next best step
```

Daily default — `shelter_context_bundle(...)`; focused
`shelter_status(area)` остаётся совместимой source-derived проекцией.

Definition of Done:

```text
A fresh Producer session can ask “where are we now?” and get a compact answer without reading multiple top docs.
```

---

## 6. Phase P5 — Bounded knowledge navigation inside local MCP

Статус: `implemented / independent review PASS / daily default active`

Direction:

Shelter MCP remains a local domain-specific runtime/inspection adapter. Under D-026, its healthy source-derived bundle becomes the default bounded deterministic routine bootstrap/context-routing path, while local repository documents remain project memory, authority and exact fallback.

Future candidates:

```text
shelter_status(area)
decision_digest(area)
open_questions_digest(area)
current_context_drift_report(area)
knowledge_gc_plan(area)
missing_metadata_report(area)
```

Constraints remain:

```text
read-only
bounded
deterministic
no broad search
no AI summarization inside MCP
no network
no generic shell
```

Additional D-026 constraints:

```text
No manually maintained current-fact mirror/fingerprint.
Current facts are parsed from canonical sources on request.
Source documents win on drift and remain exact fallback.
Knowledge failure does not disable runtime/capture/control.
```

---

## 7. Current immediate split

### Project next

Return to the already-governed D-024 capture-only macOS self-capture, evidence seal and Art/user review wave. No new D-026 implementation or review wave is active.

Brief:

```text
docs/drive/Shelter/04_DEVELOPMENT/SHELTER_WORKFLOW__Codex_Brief__Source_Derived_MCP_Context_Bridge_v1.md
```

### PM / Producer next

Ongoing maintenance:

1. Keep D-021, D-026 and Current Memory synchronized.
2. Preserve healthy MCP-first routine routing plus source authority/exact fallback; observe the first remote CI without treating it as a blocker.
3. Run Knowledge GC when a concrete drift signal appears; preserve product/game/art decisions.

---

## 8. Changelog

### 2026-07-15 — D-026 final reviewer PASS / daily default active

- Recorded independent re-review `PASS`, closure of all four prior findings and active healthy MCP-first routine routing.
- Closed D-026 remediation/re-review work while retaining first remote CI and the accepted semantic/4 KiB fallback boundaries as non-blocking residuals.
- Returned the next step to the already-governed D-024 macOS self-capture/seal/Art-user review wave without adding product scope.

### 2026-07-15 — D-026 remediation local PASS / independent re-review next

- Recorded all four independent-review findings as fixed locally and the full local matrix/client smokes as passing.
- Replaced active fix/resolve work with independent re-review as the sole current next step.
- Kept final acceptance and daily-default rollout pending reviewer PASS, with direct source fallback active until then.

### 2026-07-15 — D-026 implementation present / remediation and re-review active

- Recorded the source-derived implementation and passing happy path without granting final acceptance.
- Replaced obsolete static-catalog/migration-pending current state with the exact two-P1/two-P2 reviewer gate.
- Kept direct source fallback active until full-matrix remediation and reviewer PASS.

### 2026-07-15 — D-026 executable repair wave

- Accepted MCP-first source-derived routine bootstrap as the target state.
- Marked the legacy static catalog guardrail as drifted/non-current rather than project memory.
- Activated the source-derived context bridge brief and preserved direct local reads as authority/fallback.

### 2026-07-10 — D-021 roadmap correction

- Marked decision/dashboard tools and current-context guardrails as implemented.
- Fixed the MCP direction as optional bounded navigation over source documents.
- Completed static-catalog drift prevention and the ChatGPT Work/local MCP migration.
- Kept Day 2 as the unchanged product follow-up.

### 2026-07-09 — P2/P3 started

- Added `CURRENT_CONTEXT_TEMPLATE.md`.
- Added Standard navigation blocks to Steam, Game Design, Art Direction and Codex current-context docs.
- Added anti-bloat boundary to `01_CURRENT_STATUS.md`.
- Codex is working in parallel on MCP decision digest / shelter status dashboard tools.

### 2026-07-09 — v1 created

- Created short roadmap for remaining documentation/knowledge-entry polish.
- Split remaining work into Decision Catalog, current-context standardization, Current Status guardrail, Producer Dashboard and future Knowledge OS direction.
