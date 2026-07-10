# SHELTER MCP — Codex Brief — Knowledge API v2

Дата: 2026-07-07
Статус: active Codex brief
Владелец: Producer / Project Manager / Codex
Режим Codex: `/goal`
Reasoning: высокий
Implementation repo: `mcp`
Shelter repo: `/Users/barsulka/GolandProjects/shelter/shelter`
Roadmap: `docs/drive/Shelter/00_START_HERE/KNOWLEDGE_BASE_ROADMAP.md`

---

## 0. Goal

Extend Shelter MCP Knowledge Layer from “which documents should I read?” to a deterministic Knowledge API v2 for decisions, open questions, roadmaps, latest handoff and task context.

This is not summarization, not semantic search, not vector search, and not a general repo search. New tools must be read-only, deterministic, bounded and based on known Shelter documentation, static catalogs or simple bounded parsing.

Example questions the tools should support:

```text
Which decisions define Steam/Desktop?
Which open questions block Browser Extension?
What roadmap is active for docs cleanup?
What is the latest relevant handoff for Producer/docs?
Which docs should I read for project_manager/docs/cleanup?
```

---

## 1. Mandatory sources

Read before implementation:

```text
PROJECTS_RULES.md
AGENTS.md
README.md
docs/drive/Shelter/00_START_HERE/KNOWLEDGE_BASE_ROADMAP.md
docs/drive/Shelter/00_START_HERE/05_DOCUMENTATION_GOVERNANCE.md
docs/drive/Shelter/00_START_HERE/EVIDENCE_READ_POLICY.md
docs/drive/Shelter/00_START_HERE/02_DECISIONS.md
docs/drive/Shelter/00_START_HERE/03_OPEN_QUESTIONS.md
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__CURRENT_CONTEXT.md
docs/repo/status/CODEX_CURRENT_STATUS.md
docs/drive/Shelter/04_DEVELOPMENT/CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md
```

Also inspect MCP source:

```text
README.md
internal/sheltermcp/knowledge_catalog.go
internal/sheltermcp/knowledge_tools.go
internal/sheltermcp/knowledge_tools_test.go
internal/sheltermcp/server.go
```

---

## 2. Safety / boundaries

Do not add broad command execution, network calls, semantic AI summaries, embeddings, vector database, write behavior in new knowledge tools, or expanded filesystem scope.

Do not change product/game/art decisions.

Do not modify runtime/game code.

All new outputs must be bounded and structured.

---

## 3. Current state

Knowledge Service v1 already provides:

```text
find_current_context
list_active_docs
classify_doc_path
explain_superseded
knowledge_gc_report
```

Build v2 on the existing catalog and tool style.

---

## 4. Required tools

### P0 — list_decisions

Input:

```json
{"area":"steam|mcp|docs|browser|mobile|shared|generic","kind":"all|product|technical|process|documentation|ethics"}
```

Return accepted decisions relevant to the area.

At minimum map:

```text
steam: D-007, D-009, D-010, D-011, D-012, D-013, D-014, D-017, D-018, D-019, D-020
browser: D-008, D-012, D-020
docs/mcp/process: D-001, D-002, D-003, D-004, D-014, D-015, D-017, D-018, D-019, D-020
```

Each decision should include id, title, kind, status, short summary and source path.

### P0 — get_decision

Input:

```json
{"id":"D-020"}
```

Return one decision by id. If missing, return structured not-found and available ids.

### P0 — list_open_questions

Input:

```json
{"area":"steam|docs|browser|mobile|shared|charity|platform|generic","status":"open|partially_resolved|deferred|needs_research|all"}
```

Return current questions from `03_OPEN_QUESTIONS.md` model.

Must include at least:

```text
OQ-Steam-001
OQ-Steam-002
OQ-Steam-003
OQ-Docs-001
OQ-Docs-002
OQ-Docs-003
OQ-Browser-001
OQ-Mobile-001
OQ-Shared-001
OQ-Charity-001
OQ-Platform-001
```

### P1 — list_roadmaps

Input:

```json
{"area":"steam|docs|mcp|game_design|art_direction|generic"}
```

Return known roadmap docs, status, current phase, next step and owner.

At minimum include:

```text
docs/drive/Shelter/00_START_HERE/KNOWLEDGE_BASE_ROADMAP.md
STEAM_DESKTOP__Game_Design_Roadmap_v2.md
```

### P1 — latest_handoff

Input:

```json
{"role":"producer|project_manager|game_designer|art_director|codex|generic","area":"steam|docs|mcp|generic"}
```

Return latest known relevant handoff for role/area. Static catalog is acceptable. Bounded directory scan in known handoff dirs is acceptable.

### P1 — knowledge_task_context

Input:

```json
{"role":"producer|project_manager|game_designer|art_director|codex|generic","area":"steam|docs|mcp|browser|mobile|generic","task":"decision|implementation|cleanup|art_review|game_design|research|handoff|generic"}
```

Return recommended docs in reading order:

```text
read_first
read_by_task
avoid_by_default
notes
```

For `project_manager/docs/cleanup`, must include governance, superseded map, evidence policy, current status and open questions.

---

## 5. Out of scope

Do not implement broad text search, semantic search, automatic summaries, automatic file edits, archiving/moving/deleting docs, product changes, art changes or game-design changes.

---

## 6. Acceptance criteria

Accepted when:

1. `list_decisions` exists.
2. `get_decision` exists.
3. `list_open_questions` exists.
4. `list_roadmaps` exists or is explicitly deferred with P0 complete.
5. `latest_handoff` exists or is explicitly deferred with P0 complete.
6. `knowledge_task_context` exists or is explicitly deferred with P0/P1 complete.
7. Tools are deterministic, bounded, read-only and static-catalog/simple-parse based.
8. README documents tools and example calls.
9. Tests cover:
   - Steam decisions include D-007, D-009, D-013, D-020.
   - Browser decisions include D-008, D-012, D-020.
   - `get_decision(D-020)` returns Project Philosophy / Constitution summary.
   - Steam open questions include OQ-Steam-001.
   - Docs open questions include OQ-Docs-001.
   - `list_roadmaps(docs)` includes `KNOWLEDGE_BASE_ROADMAP.md`.
   - `latest_handoff(producer, docs)` returns a 2026-07-07 docs/governance handoff if available.
   - `knowledge_task_context(project_manager, docs, cleanup)` includes governance/superseded/evidence policy docs.
   - unknown ids/areas return structured safe errors.
10. Existing knowledge service v1 tests still pass.
11. `gofmt` run.
12. `go test ./...` passes.
13. `go build -o .runtime/bin/shelter-mcp ./cmd/shelter-mcp` passes.
14. `git diff --check` passes.
15. Shelter status docs are updated carefully if no conflict.

---

## 7. Stop conditions

Stop and report if implementation requires broad search, semantic summary, expanded permissions, unbounded output, large architecture refactor, or if status docs have conflicting user edits.

---

## 8. Suggested order

1. Check git status in both repos.
2. Read mandatory sources.
3. Extend static catalog with decisions.
4. Implement `list_decisions` and `get_decision`.
5. Extend catalog with open questions.
6. Implement `list_open_questions`.
7. Add roadmap catalog and `list_roadmaps`.
8. Add handoff catalog/scanner and `latest_handoff`.
9. Add `knowledge_task_context`.
10. Add tests.
11. Update MCP README.
12. Run checks.
13. Update Shelter status docs carefully.

---

## 9. Minimum / strong / excellent delivery

Minimum:

```text
list_decisions + get_decision + list_open_questions + tests + README
```

Strong:

```text
minimum + list_roadmaps + latest_handoff
```

Excellent:

```text
strong + knowledge_task_context
```
