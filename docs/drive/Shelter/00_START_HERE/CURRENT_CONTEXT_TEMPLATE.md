# CURRENT_CONTEXT_TEMPLATE — Shelter

Дата создания: 2026-07-09
Статус: active documentation template
Владелец: Project Manager / Knowledge Base Maintainer
Назначение: единый шаблон для current-context документов Shelter.

---

## 0. Purpose

Current-context docs answer:

```text
What is currently true in this area, and what should a fresh session read next?
```

They are not:

```text
full specs
full indexes
full history
capture/evidence packs
detailed implementation logs
```

---

## 1. Standard shape

New or refreshed current-context docs should follow this recognizable shape:

```text
0. How to use / Read policy
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

Existing current-context docs do not need a disruptive rewrite if they already contain the same information. It is acceptable to add a short `Standard navigation` block instead.

---

## 2. Maintenance rules

- Keep current-context docs short.
- Do not copy full decision text; link to `02_DECISIONS.md` or MCP decision tools.
- Do not copy full roadmap history; link to active roadmap and current task.
- Do not copy evidence; link to latest evidence and evidence policy.
- Do not list every historical handoff; link to `HANDOFF_INDEX.md`.
- If a current-context doc grows beyond a quick read, split history/details back into Knowledge or History docs.

---

## 3. Minimal standard navigation block

When a full restructure would create too much churn, add this block near the top:

```md
## Standard navigation

Current truth:

```text
...
```

Active roadmap / current task:

```text
...
```

Current decisions:

```text
...
```

Active open questions:

```text
...
```

Read next by task:

```text
...
```

Do not read by default:

```text
...
```

Next best step:

```text
...
```
```

---

## 4. Changelog

### 2026-07-09 — v1 created

- Added standard current-context shape and maintenance rules.
- Allowed minimal standard navigation block for existing current-context docs to avoid disruptive rewrites.
