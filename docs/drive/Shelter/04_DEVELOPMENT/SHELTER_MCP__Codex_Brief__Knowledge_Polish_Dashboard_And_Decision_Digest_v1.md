# SHELTER MCP — Codex Brief — Knowledge Polish: Dashboard And Decision Digest v1

Дата: 2026-07-09
Статус: active Codex brief
Владелец: Producer / Project Manager / Codex
Режим Codex: `/goal`
Reasoning: высокий
Implementation repo: `/Users/barsulka/GolandProjects/shelter/mcp`
Shelter repo: `/Users/barsulka/GolandProjects/shelter/shelter`
Roadmap source: `docs/drive/Shelter/00_START_HERE/KNOWLEDGE_BASE_POLISH_ROADMAP.md`

---

## 0. Goal

Improve Shelter MCP fresh-session entry by adding compact, deterministic project knowledge tools on top of existing Knowledge API v2.

This brief addresses the remaining friction after documentation Phase 2 cleanup:

1. `02_DECISIONS.md` is structured but still long.
2. Fresh Producer sessions need one compact “where are we now?” view.
3. MCP should increasingly behave as Shelter project knowledge operating layer, not only as file/docs routing.

This is still read-only, deterministic and bounded.

---

## 1. Mandatory sources

Read before implementation:

```text
PROJECTS_RULES.md
AGENTS.md
README.md
docs/drive/Shelter/00_START_HERE/KNOWLEDGE_BASE_POLISH_ROADMAP.md
docs/drive/Shelter/00_START_HERE/KNOWLEDGE_BASE_ROADMAP.md
docs/drive/Shelter/00_START_HERE/BOOTSTRAP_CONTEXT.md
docs/drive/Shelter/00_START_HERE/01_CURRENT_STATUS.md
docs/drive/Shelter/00_START_HERE/02_DECISIONS.md
docs/drive/Shelter/00_START_HERE/03_OPEN_QUESTIONS.md
docs/drive/Shelter/00_START_HERE/05_DOCUMENTATION_GOVERNANCE.md
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__CURRENT_CONTEXT.md
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/GAME_DESIGN__CURRENT_CONTEXT.md
docs/drive/Shelter/03_DESIGN/ART_DIRECTION__CURRENT_CONTEXT.md
docs/drive/Shelter/06_SESSIONS_AND_HANDOFFS/HANDOFF_INDEX.md
docs/repo/status/CODEX_CURRENT_STATUS.md
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

## 2. Boundaries

Do not add broad command execution, broad repo search, semantic AI summaries, embeddings, vector DB, network calls, write behavior, expanded filesystem scope, or product/game/art decisions.

All new outputs must be bounded, read-only and deterministic.

Use existing static catalog / simple-rule style.

---

## 3. Required tools

### P0 — `decision_digest`

Purpose:

Return compact active decision summaries for an area. This should be shorter and more dashboard-like than `list_decisions`.

Suggested input:

```json
{"area":"steam|browser|docs|mcp|mobile|shared|all|generic","max_items":20}
```

Suggested output:

```json
{
  "ok": true,
  "area": "steam",
  "digest": [
    {"id":"D-007","title":"Godot engine","summary":"Steam/Desktop uses Godot 4.x."},
    {"id":"D-009","title":"Horizontal dog co-op","summary":"Steam is cozy production strip + dog community sim."}
  ],
  "source_path":"docs/drive/Shelter/00_START_HERE/02_DECISIONS.md",
  "read_full_policy":"Open full 02_DECISIONS.md only when exact decision wording is needed."
}
```

This may internally reuse existing decision catalog.

Acceptance examples:

- `decision_digest(steam)` includes D-007, D-009, D-013, D-020.
- `decision_digest(browser)` includes D-008, D-012, D-020.
- `decision_digest(docs)` includes documentation/process decisions.

---

### P0 — `shelter_status`

Purpose:

Return one compact project/area dashboard.

Suggested input:

```json
{"area":"steam|docs|mcp|browser|mobile|generic"}
```

Suggested output fields:

```text
area
current_focus
current_scope
current_phase
current_roadmap
current_task
active_decisions
active_open_questions
blocked_by_or_risks
latest_handoff
read_first
next_best_step
notes
```

For `area=steam`, it should include:

```text
current focus: Steam/Desktop
current scope: First Week / Day 2 / longer retention
current task: R-28 / Day 2 Return And Second Warm Delivery
active roadmap: STEAM_DESKTOP__Game_Design_Roadmap_v2.md
active decisions: D-007, D-009, D-010, D-013, D-020 at minimum
open questions: OQ-Steam-001..003
next best step: prepare/approve Day 2 Codex brief
```

For `area=docs`, it should include:

```text
current phase: Knowledge Base Polish Roadmap
current tasks: Decision digest / dashboard + current-context template / current-status guardrail
read first: BOOTSTRAP_CONTEXT, 01_CURRENT_STATUS, KNOWLEDGE_BASE_POLISH_ROADMAP
latest handoff: knowledge base phase 2 cleanup handoff
```

---

### P1 — `open_questions_digest`

Purpose:

Return compact open question summaries by area/status, shorter than `list_open_questions`.

Input:

```json
{"area":"steam|docs|browser|mobile|shared|charity|platform|generic","status":"open|needs_research|all"}
```

Acceptance:

- `open_questions_digest(steam, all)` returns OQ-Steam-001..003.
- `open_questions_digest(browser, all)` returns Browser/platform/charity related questions where relevant.

---

### P1 — `current_entry_digest`

Purpose:

Return the minimal fresh-session entry docs for a role/area without full content.

Input:

```json
{"role":"producer|project_manager|game_designer|art_director|codex|generic","area":"steam|docs|mcp|browser|mobile|generic"}
```

Output:

```text
read_first
read_next_by_task
avoid_by_default
why
```

This overlaps with `knowledge_task_context`, but should be a shorter entry digest for fresh sessions.

---

## 4. Out of scope

Do not create or edit markdown docs except README/status updates.

Do not split `02_DECISIONS.md`.

Do not create `DECISION_CATALOG.md` unless absolutely necessary; prefer MCP static catalog.

Do not add auto-cleanup/write tools.

---

## 5. Acceptance criteria

Accepted when:

1. `decision_digest` exists.
2. `shelter_status` exists.
3. `open_questions_digest` exists or is explicitly deferred after P0 is complete.
4. `current_entry_digest` exists or is explicitly deferred after P0 is complete.
5. All tools are read-only, bounded and deterministic.
6. Existing Knowledge API v1/v2 tools continue to work.
7. README documents new tools and example calls.
8. Tests cover:
   - `decision_digest(steam)` includes D-007, D-009, D-013, D-020.
   - `decision_digest(browser)` includes D-008, D-012, D-020.
   - `shelter_status(steam)` includes First Week / Day 2 and R-28.
   - `shelter_status(docs)` includes Knowledge Base Polish Roadmap.
   - `open_questions_digest(steam, all)` includes OQ-Steam-001.
   - `current_entry_digest(game_designer, steam)` includes GAME_DESIGN__CURRENT_CONTEXT.md.
   - unknown areas return structured safe errors.
9. `gofmt` run.
10. `go test ./...` passes.
11. `go build -o .runtime/bin/shelter-mcp ./cmd/shelter-mcp` passes.
12. `git diff --check` passes.
13. Shelter status docs are updated carefully if safe.

---

## 6. Suggested order

1. Check git status in `mcp` and `shelter` repos.
2. Read mandatory sources.
3. Reuse existing decision/open-question catalogs.
4. Implement `decision_digest`.
5. Implement `shelter_status`.
6. Implement or defer P1 tools.
7. Add tests.
8. Update README.
9. Run checks.
10. Update Shelter status docs if safe.

---

## 7. Notes for final response

Report:

- tools added;
- files changed;
- checks run;
- whether P1 was completed or deferred;
- any static catalog follow-ups.
