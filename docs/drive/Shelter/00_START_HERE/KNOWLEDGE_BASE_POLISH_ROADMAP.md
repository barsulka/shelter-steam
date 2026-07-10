# KNOWLEDGE_BASE_POLISH_ROADMAP — Shelter

Дата создания: 2026-07-09
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
5. Дальше больше пользы даст не перекладывание Markdown, а MCP/Knowledge API, который отдаёт компактные рабочие ответы.

Этот roadmap фиксирует план, чтобы исправлять это постепенно и не уходить в бесконечную документационную полировку.

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
3. дать MCP компактные summary/dashboard tools;
4. вернуться к продуктовой работе Day 2.
```

---

## 2. Phase P1 — Decision Catalog / compact decision layer

Статус: `next for Codex + PM review`

Проблема:

`02_DECISIONS.md` теперь структурирован, но всё ещё длинный. Свежая сессия не должна читать его целиком, если нужен только список актуальных решений.

Цель:

Создать компактный decision entry layer.

Preferred implementation:

- Codex/MCP: расширить `get_decision` / `list_decisions` или добавить compact output mode.
- Docs: не дробить `02_DECISIONS.md` прямо сейчас, а создать/поддерживать короткий catalog-source только если MCP static catalog недостаточен.

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

Статус: `PM task`

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

Статус: `PM task`

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

Статус: `Codex candidate + PM docs candidate`

Проблема:

Top layer has multiple entry docs. Fresh sessions still need to know “where are we now?” quickly.

Goal:

Create one compact producer-facing status view.

Preferred MCP tool:

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

Definition of Done:

```text
A fresh Producer session can ask “where are we now?” and get a compact answer without reading multiple top docs.
```

---

## 6. Phase P5 — Knowledge API as project operating system

Статус: `future Codex`

Direction:

Shelter MCP becomes a project operating system layer, not just a file server.

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

---

## 7. Current immediate split

### Codex next

Create MCP/tooling support for compact decision/dashboard entry.

Brief:

```text
docs/drive/Shelter/04_DEVELOPMENT/SHELTER_MCP__Codex_Brief__Knowledge_Polish_Dashboard_And_Decision_Digest_v1.md
```

### PM / Producer next

Start with Phase P2/P3:

1. Standardize current-context docs shape where safe.
2. Add explicit anti-bloat boundary to `01_CURRENT_STATUS.md`.
3. Avoid major product/doc restructuring.

---

## 8. Changelog

### 2026-07-09 — P2/P3 started

- Added `CURRENT_CONTEXT_TEMPLATE.md`.
- Added Standard navigation blocks to Steam, Game Design, Art Direction and Codex current-context docs.
- Added anti-bloat boundary to `01_CURRENT_STATUS.md`.
- Codex is working in parallel on MCP decision digest / shelter status dashboard tools.

### 2026-07-09 — v1 created

- Created short roadmap for remaining documentation/knowledge-entry polish.
- Split remaining work into Decision Catalog, current-context standardization, Current Status guardrail, Producer Dashboard and future Knowledge OS direction.
