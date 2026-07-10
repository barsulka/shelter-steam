# SHELTER MCP — Codex Brief — Knowledge Service And PM Docs Bootstrap v1

Дата: 2026-07-07
Статус: active Codex brief
Роль-владелец: Producer / Project Manager / Codex
Рекомендуемый режим Codex: `/goal`
Рекомендуемый уровень рассуждений: высокий
Репозиторий для реализации: `mcp`
Связанный Shelter repo: `/Users/barsulka/GolandProjects/shelter/shelter`

---

## 0. Goal

Evolve Shelter MCP from a safe repo/file tool bridge into a small deterministic **knowledge access service** for Shelter documentation.

This is not AI summarization. This is not a vector database. This is not generic search.

The goal is to add safe typed MCP tools that help ChatGPT / Codex / PM sessions retrieve the right slice of Shelter documentation under the new documentation governance model:

```text
Current Memory first.
Knowledge by task.
History only for evidence / regression / archaeology.
```

This task also includes a small polish fix:

```text
read_shelter_bootstrap_context(role=project_manager, area=docs)
```

should include `05_DOCUMENTATION_GOVERNANCE.md` as a first-class PM/docs bootstrap document.

---

## 1. Important current repo state

Before starting, Codex must check status in both repos.

At the time this brief was created, Shelter repo may already have uncommitted documentation changes from a PM/Producer documentation governance pass, including:

```text
PROJECTS_RULES.md
AGENTS.md
docs/drive/Shelter/00_START_HERE/00_PROJECT_INDEX.md
docs/drive/Shelter/00_START_HERE/01_CURRENT_STATUS.md
docs/drive/Shelter/00_START_HERE/BOOTSTRAP_CONTEXT.md
docs/drive/Shelter/00_START_HERE/SUPERSEDED_MAP.md
docs/drive/Shelter/00_START_HERE/05_DOCUMENTATION_GOVERNANCE.md
docs/drive/Shelter/04_DEVELOPMENT/CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md
docs/repo/status/CODEX_CURRENT_STATUS.md
docs/repo/status/CODEX_STATUS.md
```

Do not overwrite or revert user/ChatGPT documentation work.

MCP repo is the implementation target. Shelter repo should only be updated for status/docs if needed.

---

## 2. Mandatory sources

Codex must read these before implementation:

```text
/Users/barsulka/GolandProjects/shelter/shelter/PROJECTS_RULES.md
/Users/barsulka/GolandProjects/shelter/shelter/AGENTS.md
/Users/barsulka/GolandProjects/shelter/shelter/README.md
/Users/barsulka/GolandProjects/shelter/shelter/docs/drive/Shelter/00_START_HERE/BOOTSTRAP_CONTEXT.md
/Users/barsulka/GolandProjects/shelter/shelter/docs/drive/Shelter/00_START_HERE/SUPERSEDED_MAP.md
/Users/barsulka/GolandProjects/shelter/shelter/docs/drive/Shelter/00_START_HERE/05_DOCUMENTATION_GOVERNANCE.md
/Users/barsulka/GolandProjects/shelter/shelter/docs/repo/status/CODEX_CURRENT_STATUS.md
/Users/barsulka/GolandProjects/shelter/shelter/docs/drive/Shelter/04_DEVELOPMENT/CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md
mcp/README.md
mcp/internal/sheltermcp/repo_tools.go
mcp/internal/sheltermcp/repo_tools_test.go
mcp/internal/sheltermcp/server.go
```

Also inspect relevant MCP source files before editing.

---

## 3. Non-negotiable safety constraints

Do not add generic shell access.

Do not add arbitrary git commands.

Do not broaden filesystem roots.

Do not read or expose secrets, `.env`, API keys, tunnel profiles, tokens, private credentials, key/cert files or local private configs.

Do not add external network calls.

Do not add AI summarization inside MCP.

Do not add vector DB / embeddings / third-party indexing dependencies.

All knowledge tools must be deterministic, bounded and based on local files under allowed repo roots.

Prefer simple path/status/metadata rules over clever inference.

---

## 4. Required changes

### P0 — PM/docs bootstrap polish

Update `read_shelter_bootstrap_context` so:

```text
role=project_manager, area=docs
```

includes this document early:

```text
docs/drive/Shelter/00_START_HERE/05_DOCUMENTATION_GOVERNANCE.md
```

It should be treated as a first-class PM/docs bootstrap document, alongside:

```text
BOOTSTRAP_CONTEXT.md
000_ROLE_PROJECT_MANAGER.md
SUPERSEDED_MAP.md
```

Acceptance examples:

```json
{
  "role": "project_manager",
  "area": "docs",
  "max_bytes": 50000
}
```

Expected included paths should include:

```text
BOOTSTRAP_CONTEXT.md
000_ROLE_PROJECT_MANAGER.md
SUPERSEDED_MAP.md
05_DOCUMENTATION_GOVERNANCE.md
```

If budget is too small, skipped reason must be explicit.

---

### P0 — Add `find_current_context`

Purpose: given an area, return the current-context documents that should be read first.

Suggested input:

```json
{
  "area": "steam|mcp|docs|browser|mobile|generic"
}
```

Suggested output:

```json
{
  "area": "steam",
  "ok": true,
  "current_memory_paths": [
    "docs/drive/Shelter/00_START_HERE/BOOTSTRAP_CONTEXT.md",
    "docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__CURRENT_CONTEXT.md"
  ],
  "knowledge_paths": [
    "docs/drive/Shelter/00_START_HERE/02_DECISIONS.md",
    "docs/drive/Shelter/00_START_HERE/03_PROJECT_PHILOSOPHY.md"
  ],
  "history_policy": "Do not read history unless evidence/regression/archaeology is needed.",
  "notes": [...]
}
```

This should be deterministic and path-table driven.

At minimum support:

- `steam`
- `mcp`
- `docs`
- `generic`

Browser/mobile may return placeholders with clear notes if current-context docs do not exist yet.

---

### P0 — Add `list_active_docs`

Purpose: list active/current/relevant docs for an area without reading all content.

Suggested input:

```json
{
  "area": "steam|mcp|docs|browser|mobile|generic",
  "layer": "current|knowledge|history|all"
}
```

Suggested output:

```json
{
  "area": "docs",
  "layer": "current",
  "docs": [
    {
      "path": "docs/drive/Shelter/00_START_HERE/BOOTSTRAP_CONTEXT.md",
      "status": "current-summary",
      "layer": "Current Memory",
      "purpose": "compressed entry point",
      "read_policy": "bootstrap"
    }
  ],
  "notes": [...]
}
```

Implementation may use a static catalog first. Do not require perfect parsing of every file.

The catalog should include at least:

Current Memory:

```text
docs/drive/Shelter/00_START_HERE/BOOTSTRAP_CONTEXT.md
docs/drive/Shelter/00_START_HERE/01_CURRENT_STATUS.md
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__CURRENT_CONTEXT.md
docs/drive/Shelter/04_DEVELOPMENT/CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md
docs/repo/status/CODEX_CURRENT_STATUS.md
```

Knowledge / governance:

```text
docs/drive/Shelter/00_START_HERE/02_DECISIONS.md
docs/drive/Shelter/00_START_HERE/03_PROJECT_PHILOSOPHY.md
docs/drive/Shelter/00_START_HERE/03_OPEN_QUESTIONS.md
docs/drive/Shelter/00_START_HERE/04_SHELTER_STRESS_TESTS.md
docs/drive/Shelter/00_START_HERE/05_DOCUMENTATION_GOVERNANCE.md
docs/drive/Shelter/00_START_HERE/SUPERSEDED_MAP.md
docs/repo/adr/README.md
```

History examples:

```text
docs/repo/status/CODEX_STATUS.md
docs/drive/Shelter/06_SESSIONS_AND_HANDOFFS/**
docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/**
docs/drive/Shelter/99_ARCHIVE/**
```

---

### P1 — Add `explain_superseded`

Purpose: given a path or path fragment, explain whether it is superseded / evidence / do-not-read-by-default based on `SUPERSEDED_MAP.md` and static known rules.

Suggested input:

```json
{
  "path": "docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v1/README.md"
}
```

Suggested output:

```json
{
  "path": "...",
  "ok": true,
  "classification": "evidence/superseded-by-v3",
  "read_policy": "do_not_read_on_bootstrap",
  "current_source": "docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v3/README.md",
  "reason": "First Day visible review v1/v2 are superseded by v3 for normal context recovery."
}
```

Start with simple path/pattern rules from `SUPERSEDED_MAP.md`; do not implement fuzzy AI reasoning.

Should support at least these patterns:

```text
STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v1
STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v2
STEAM_VERTICAL_SLICE_ART_QA_CAPTURE_v1
STEAM_VERTICAL_SLICE_ART_QA_CAPTURE_v2
CODEX_STATUS.md
99_ARCHIVE
Systems_Simulator_v0
completed Codex briefs under 04_DEVELOPMENT
```

If unknown, return classification `unknown` with advice to inspect `SUPERSEDED_MAP.md`.

---

### P1 — Add `knowledge_gc_report`

Purpose: generate a deterministic report for PM cleanup without modifying files.

Suggested input:

```json
{
  "area": "docs|steam|mcp|generic",
  "max_entries": 100
}
```

Suggested output:

```json
{
  "area": "docs",
  "ok": true,
  "current_memory": [...],
  "knowledge": [...],
  "history_candidates": [...],
  "superseded_candidates": [...],
  "missing_current_context_candidates": [...],
  "recommended_next_actions": [...]
}
```

This report should use simple deterministic rules:

- files under `06_SESSIONS_AND_HANDOFFS` are history;
- files under `03_DESIGN/04_DELIVERABLES` are evidence/history;
- files under `99_ARCHIVE` are archive/history;
- files containing `SUPERSEDED` or known superseded patterns are superseded;
- active current-context docs are current memory;
- status/docs without metadata may be flagged as “needs review”.

No AI summarization.

Do not modify files. This is a read/report tool.

---

### P2 — Add `classify_doc_path`

Purpose: classify one path into Current Memory / Knowledge / History / unknown.

Suggested input:

```json
{
  "path": "docs/drive/Shelter/00_START_HERE/BOOTSTRAP_CONTEXT.md"
}
```

Suggested output:

```json
{
  "path": "...",
  "layer": "Current Memory",
  "status": "current-summary",
  "read_policy": "bootstrap",
  "confidence": "high",
  "reason": "Known current-context document."
}
```

This can share the same catalog/rules as `list_active_docs` and `explain_superseded`.

---

## 5. Suggested implementation design

Keep it simple.

Recommended internal structure:

```text
internal/sheltermcp/knowledge_catalog.go
internal/sheltermcp/knowledge_tools.go
internal/sheltermcp/knowledge_tools_test.go
```

A static typed catalog is acceptable and preferred for v1.

Possible data structs:

```go
type KnowledgeDoc struct {
    Path string
    Area string
    Layer string
    Status string
    Purpose string
    ReadPolicy string
}
```

Pattern rules can be simple substring/glob-like checks.

Do not parse all Markdown unless needed for a simple metadata line. If metadata parsing is added, it must be best-effort and bounded.

---

## 6. Out of scope

Do not implement:

- generic search over arbitrary repo text;
- vector database / embeddings;
- AI summarization;
- filesystem writes from knowledge tools;
- deletion/archive/move tools;
- git commit/push/reset/checkout;
- product/gameplay changes;
- art/game design decisions;
- external network calls;
- broad MCP refactor unrelated to knowledge tools.

---

## 7. Acceptance criteria

Task is accepted when:

1. `read_shelter_bootstrap_context(role=project_manager, area=docs, max_bytes=50000)` includes `05_DOCUMENTATION_GOVERNANCE.md`, unless budget is explicitly too small.
2. MCP exposes `find_current_context` or equivalent named tool.
3. MCP exposes `list_active_docs` or equivalent named tool.
4. MCP exposes `explain_superseded` or equivalent named tool, or Codex clearly explains why deferred while completing all P0 work.
5. MCP exposes `knowledge_gc_report` or equivalent named tool, or Codex clearly explains why deferred while completing all P0 work.
6. New tools are deterministic, bounded and based on local docs/static catalog only.
7. No generic shell, arbitrary git, expanded roots, secrets access or network access is added.
8. README documents the new tools and example calls.
9. Tests cover:
   - PM/docs bootstrap includes governance doc;
   - current context lookup for `steam`, `mcp`, `docs`;
   - active docs listing by layer;
   - superseded explanation for at least one old capture pack;
   - GC report returns history/evidence candidates;
   - unknown path is handled clearly.
10. Existing v1/v2 repo tools still pass tests.
11. `gofmt` is run.
12. `go test ./...` passes in MCP repo.
13. `go build -o .runtime/bin/shelter-mcp ./cmd/shelter-mcp` passes in MCP repo.
14. `git diff --check` passes in MCP repo.
15. Shelter `docs/repo/status/CODEX_CURRENT_STATUS.md` and/or `docs/repo/status/CODEX_STATUS.md` is updated, or Codex provides a ready-to-paste block if Shelter repo has user changes that should not be touched.

---

## 8. Stop conditions

Stop and report clearly if:

- implementing this requires generic shell or broad repo search;
- safe output bounds cannot be preserved;
- tool schemas become too large or unstable;
- current MCP architecture cannot add these tools without a broad refactor;
- tests fail for unrelated pre-existing reasons;
- implementation would need to read secrets or local env files;
- Shelter repo has conflicting user changes in status docs.

---

## 9. Suggested implementation order

1. Check `git status` in both `mcp` and `shelter` repos.
2. Read mandatory sources.
3. Add/adjust bootstrap selection so PM/docs includes `05_DOCUMENTATION_GOVERNANCE.md`.
4. Add a static knowledge catalog.
5. Implement `find_current_context`.
6. Implement `list_active_docs`.
7. Implement `classify_doc_path` if useful as shared primitive.
8. Implement `explain_superseded`.
9. Implement `knowledge_gc_report`.
10. Add tests.
11. Update MCP README.
12. Run checks.
13. Update Shelter status docs carefully.
14. Final response: changed files, tools added, checks run, known limitations, follow-ups.

---

## 10. Notes for `/goal`

This is a parallelizable MCP tooling task. Keep it narrow and deterministic.

Minimum acceptable delivery:

```text
PM/docs bootstrap governance doc inclusion + find_current_context + list_active_docs + tests + README
```

Strong delivery:

```text
minimum + explain_superseded + classify_doc_path
```

Excellent delivery:

```text
strong + knowledge_gc_report
```

The purpose is to make future Shelter sessions cheaper and safer, not to make MCP “smart” in an AI sense.
