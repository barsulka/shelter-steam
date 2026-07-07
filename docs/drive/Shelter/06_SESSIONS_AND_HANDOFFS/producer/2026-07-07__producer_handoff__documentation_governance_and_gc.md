# Producer / PM Handoff — Documentation Governance And Knowledge GC

Дата: 2026-07-07
Роль сессии: Producer / Project Manager / Knowledge Base Maintainer
Статус: handoff-history

---

## Что делали

Продолжили задачу по защите Shelter от текущей и будущей раздутости документации.

Сначала была восстановлена договорённость из текущей переписки:

- проблема не в количестве документов, а в том, что новые сессии не видят разницы между текущей истиной, knowledge/specs и историей;
- документация должна делиться на Current Memory / Knowledge / History;
- `CODEX_STATUS.md` больше не должен быть default bootstrap document;
- нужна регулярная PM-процедура Knowledge Garbage Collector;
- MCP должен развиваться как knowledge access layer, а не просто как файловый сервер.

Затем эта договорённость была записана в локальные документы.

---

## Ключевые выводы

1. Current Memory должен быть маленьким и читаться на входе.
2. Knowledge должен оставаться источником решений/specs, но читаться по задаче.
3. History должен хранить evidence, handoff, completed briefs and logs, но не читаться по умолчанию.
4. Roadmap — рабочая очередь, а не архив выполненной работы.
5. `CODEX_STATUS.md` должен оставаться detailed chronological log, но быстрый dev вход должен идти через `CODEX_CURRENT_STATUS.md` and `CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md`.
6. Future bloat should be handled by Knowledge GC after major work waves.

---

## Принятые process decisions

### Documentation layering

```text
Current Memory — short current truth for bootstrap.
Knowledge — active decisions, specs, references and ADRs read by task.
History — handoff, completed briefs, capture packs, evidence and long logs.
```

### Default reading model

```text
Read Current Memory first.
Read Knowledge only for the concrete task.
Read History only for evidence, regression or archaeology.
```

### CODEX_STATUS split

```text
docs/repo/status/CODEX_CURRENT_STATUS.md — current dev status, read on bootstrap.
docs/repo/status/CODEX_STATUS.md — detailed chronological history, do not read in full by default.
```

### Knowledge GC

After each major product/design/dev wave, PM should ask:

```text
What became Current Memory?
What became Knowledge?
What became History?
What became superseded?
What should no longer be read by default?
Which current-context docs need updates?
Should SUPERSEDED_MAP / CURRENT_STATUS / handoff be updated?
```

---

## Изменённые документы

Created:

```text
docs/drive/Shelter/00_START_HERE/05_DOCUMENTATION_GOVERNANCE.md
docs/repo/status/CODEX_CURRENT_STATUS.md
docs/drive/Shelter/06_SESSIONS_AND_HANDOFFS/producer/2026-07-07__producer_handoff__documentation_governance_and_gc.md
```

Updated:

```text
docs/drive/Shelter/00_START_HERE/BOOTSTRAP_CONTEXT.md
docs/drive/Shelter/00_START_HERE/SUPERSEDED_MAP.md
docs/drive/Shelter/00_START_HERE/00_PROJECT_INDEX.md
docs/drive/Shelter/00_START_HERE/01_CURRENT_STATUS.md
docs/drive/Shelter/04_DEVELOPMENT/CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md
```

Attempted but not changed:

```text
PROJECTS_RULES.md
```

A write attempt to root project rules was blocked by the tool safety filter. The governance rules are still recorded in `05_DOCUMENTATION_GOVERNANCE.md` and referenced from entry docs.

---

## Открытые вопросы

1. Should `PROJECTS_RULES.md` later get a short, manually reviewed pointer to `05_DOCUMENTATION_GOVERNANCE.md`?
2. Should old capture pack README files receive explicit `status: evidence` / `read_policy` metadata gradually?
3. Should `CODEX_STATUS.md` eventually be split into monthly history files if it becomes technically heavy?
4. Should Art Direction and Game Design get separate current-context docs when their next major sessions begin?
5. Should Shelter MCP later add `classify_docs`, `list_active_docs`, `knowledge_gc_report` or `explain_superseded` tools?

---

## Что обновить дальше

Recommended next documentation cleanup steps:

1. Update `03_OPEN_QUESTIONS.md`, because some old questions are now answered/partially answered by First Day lock, First Week direction and documentation governance.
2. Add metadata/read-policy to old evidence/capture README docs when those docs are next touched.
3. Use `CODEX_CURRENT_STATUS.md` as the first dev-status entry point; keep `CODEX_STATUS.md` as detailed history.
4. Keep `05_DOCUMENTATION_GOVERNANCE.md` updated whenever document lifecycle rules change.

---

## Следующий лучший шаг

Use the new governance model immediately for all future sessions:

```text
Current Memory first.
Knowledge by task.
History only for evidence/regression/archaeology.
```

After the next major implementation or design wave, run Knowledge GC before starting another large branch.
