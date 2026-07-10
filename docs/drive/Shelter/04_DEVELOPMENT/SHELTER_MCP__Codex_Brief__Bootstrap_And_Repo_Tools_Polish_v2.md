# SHELTER MCP — Codex Brief — Bootstrap And Repo Tools Polish v2

Дата: 2026-07-07
Статус: active Codex brief
Роль-владелец: Producer / Codex
Рекомендуемый режим Codex: `/goal`
Рекомендуемый уровень рассуждений: высокий
Репозиторий для реализации: `mcp`
Связанный Shelter repo: `/Users/barsulka/GolandProjects/shelter/shelter`

---

## 0. Goal

Polish the v1 Shelter MCP repo/document tools so they are more useful in daily ChatGPT / Codex / PM work.

This is a usability and reliability pass after v1 implementation, not a new product feature and not a permission expansion.

Primary goals:

1. Make `read_shelter_bootstrap_context` prioritize the most useful current-context docs under small byte budgets.
2. Add output diagnostics so AI sessions can see what was included, skipped, and why.
3. Improve review ergonomics for `git_diff_for_review`.
4. Improve markdown editing errors and marker-based replacement.
5. Keep all safety constraints from v1: no generic shell, no arbitrary git, no expanded filesystem permissions.

---

## 1. Mandatory sources

Codex must read these before implementation:

```text
/Users/barsulka/GolandProjects/shelter/shelter/PROJECTS_RULES.md
/Users/barsulka/GolandProjects/shelter/shelter/AGENTS.md
/Users/barsulka/GolandProjects/shelter/shelter/README.md
/Users/barsulka/GolandProjects/shelter/shelter/docs/drive/Shelter/00_START_HERE/BOOTSTRAP_CONTEXT.md
/Users/barsulka/GolandProjects/shelter/shelter/docs/drive/Shelter/00_START_HERE/SUPERSEDED_MAP.md
/Users/barsulka/GolandProjects/shelter/shelter/docs/drive/Shelter/04_DEVELOPMENT/CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md
/Users/barsulka/GolandProjects/shelter/shelter/docs/drive/Shelter/04_DEVELOPMENT/SHELTER_MCP__Codex_Brief__Repo_Diff_Patch_And_Doc_Editing_Tools_v1.md
mcp/README.md
mcp/internal/sheltermcp/repo_tools.go
mcp/internal/sheltermcp/repo_tools_test.go
```

Also inspect relevant MCP source files before editing.

---

## 2. Context

v1 added these tools successfully:

```text
git_status
git_diff
git_diff_for_review
apply_patch
insert_section_after_heading
replace_section
append_changelog_entry
read_shelter_bootstrap_context
write_file_if_unchanged
```

ChatGPT review accepted v1 as functional. The only nitpick found during live use:

```text
read_shelter_bootstrap_context with low max_bytes can spend its budget on long root docs before reaching BOOTSTRAP_CONTEXT / CURRENT_CONTEXT.
```

Example observed behavior:

```text
role=codex, area=mcp, max_bytes=40000
included: PROJECTS_RULES.md, AGENTS.md, README.md, role doc, ADR index
skipped: BOOTSTRAP_CONTEXT.md and CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md because budget exceeded
```

This defeats the purpose of the compression layer under small budgets.

---

## 3. Non-negotiable safety constraints

Do not add generic shell access.

Do not add arbitrary git commands.

Do not broaden filesystem roots.

Do not read or expose secrets, `.env`, API keys, tunnel profiles, tokens, private credentials, key/cert files or local private configs.

Do not modify product/gameplay code.

All new behavior must stay typed, bounded and deterministic.

Risky write operations must keep dry-run defaults.

---

## 4. Required changes

### P0 — Prioritize `read_shelter_bootstrap_context`

Change the deterministic file selection order so current-context docs are included before long foundational docs.

New priority order should be approximately:

1. `docs/drive/Shelter/00_START_HERE/BOOTSTRAP_CONTEXT.md`
2. relevant role doc, for example `000_ROLE_PRODUCER.md` or `000_ROLE_CODEX.md`
3. relevant current-context doc:
   - `STEAM_DESKTOP__CURRENT_CONTEXT.md` for `area=steam`
   - `CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md` for `role=codex` or `area=mcp`
   - `SUPERSEDED_MAP.md` for `role=project_manager` or `area=docs`
4. relevant subproject docs, for example `steam/AGENTS.md`, `steam/README.md` when area is Steam
5. `PROJECTS_RULES.md`
6. `AGENTS.md`
7. `README.md`
8. `docs/repo/adr/README.md` for Codex/dev/MCP contexts
9. optional remaining docs if budget remains

The exact order can be adjusted, but the acceptance requirement below must pass.

---

### P0 — Add priority mode / compact mode behavior

Add an input option if useful:

```json
{
  "priority_mode": true
}
```

Alternative acceptable implementation: make the new prioritized order the default and document it. If no explicit option is added, document that the tool is priority-first by design.

Desired behavior:

```text
At low budgets, include BOOTSTRAP_CONTEXT + role doc + relevant CURRENT_CONTEXT before long root docs.
```

Do not force inclusion by ignoring `max_bytes`. The tool must still respect bounded output.

If a required high-priority file itself cannot fit, include a clear skipped reason.

---

### P1 — Add bundle diagnostics

Enhance `read_shelter_bootstrap_context` output with diagnostics.

Suggested fields:

```json
{
  "included_bytes": 12345,
  "remaining_budget": 4567,
  "per_file_sizes": [
    { "path": "...", "bytes": 1234, "included": true, "reason": "included" },
    { "path": "...", "bytes": 99999, "included": false, "reason": "budget exceeded" }
  ],
  "bootstrap_summary": "included: ...; skipped: ..."
}
```

Exact field names may differ, but the output should make it easy for ChatGPT/Codex to understand:

- what was included;
- what was skipped;
- whether budget was exhausted;
- how many bytes were used;
- why important files were skipped.

Keep the existing `included_paths`, `skipped_paths`, `truncated`, and `content` behavior unless there is a strong reason to adjust it.

---

### P1 — Improve `git_diff_for_review` summary stats

Add lightweight review stats.

Suggested output field:

```json
{
  "review_stats": {
    "files_changed": 3,
    "markdown_files": 2,
    "go_files": 1,
    "docs_files": 2,
    "test_files": 1,
    "insertions": 120,
    "deletions": 24
  }
}
```

Implementation can parse `git diff --numstat` using fixed git args. If parsing exact insertions/deletions is inconvenient, still add file-category counts.

Do not expose arbitrary git args.

---

### P1 — Add `focus` to `git_diff_for_review`

Add optional input:

```json
{
  "focus": "docs|code|mixed|all"
}
```

Behavior:

- `all` / omitted: current behavior.
- `docs`: prefer markdown/docs files and omit binary/runtime/capture noise where possible.
- `code`: prefer Go/GDScript/scripts/config files; omit generated capture artifacts where possible.
- `mixed`: include docs + code but omit obvious generated/runtime/media artifacts.

This can be implemented by filtering changed paths before calling diff.

Do not overengineer. Simple extension/path heuristics are enough.

Suggested docs focus includes:

```text
*.md
*.txt
docs/**
README.md
AGENTS.md
PROJECTS_RULES.md
```

Suggested code focus includes:

```text
*.go
*.gd
*.sh
*.yaml
*.yml
*.json
*.toml
*.mod
*.sum
```

Generated/runtime/media paths should be omitted in focused review unless explicitly requested through paths.

---

### P2 — Add marker-based markdown replacement

Add tool:

```text
replace_between_markers
```

Suggested input:

```json
{
  "repo": "shelter|mcp",
  "path": "relative/file.md",
  "start_marker": "<!-- START: section -->",
  "end_marker": "<!-- END: section -->",
  "content": "new markdown between markers",
  "dry_run": true
}
```

Behavior:

- Find unique start and end markers.
- Replace content between markers only; keep markers unless an explicit option says otherwise.
- Dry-run defaults to true.
- Return diff.
- Fail if markers are missing, duplicated, reversed or ambiguous.

This enables future docs to define safe AI-editable blocks.

---

### P2 — Better markdown section errors

Improve `replace_section` and `insert_section_after_heading` errors.

If heading is not found, return closest available headings.

Suggested output/error content:

```json
{
  "error": "heading not found: ## Foo",
  "closest_headings": ["## Food", "## Follow-up", "### Foo notes"]
}
```

Exact output shape may vary, but the tool response should help the caller recover without manually reading the whole file.

Do not add AI/fuzzy rewriting. Simple string similarity / prefix / contains / Levenshtein-lite / nearest headings is enough.

---

## 5. Out of scope

Do not implement:

- generic shell;
- arbitrary git command execution;
- git commit / push / reset / checkout;
- destructive delete/archive/move workflows;
- AI summarization inside MCP;
- product/gameplay changes;
- browser/mobile work;
- broad MCP refactor unrelated to these tools;
- network access or external research;
- changes to tunnel credentials / profile behavior unless necessary for tests.

---

## 6. Acceptance criteria

The task is accepted when:

1. `read_shelter_bootstrap_context(role=codex, area=mcp, max_bytes=40000)` includes:
   - `BOOTSTRAP_CONTEXT.md`
   - `000_ROLE_CODEX.md`
   - `CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md`
   before long root docs consume the budget.
2. `read_shelter_bootstrap_context(role=producer, area=steam, max_bytes=30000)` includes:
   - `BOOTSTRAP_CONTEXT.md`
   - `000_ROLE_PRODUCER.md`
   - `STEAM_DESKTOP__CURRENT_CONTEXT.md`
   unless a single file is too large to fit; if skipped, the reason is explicit.
3. Bootstrap output includes useful diagnostics: included/skipped files, byte counts or equivalent summary.
4. `git_diff_for_review` exposes review stats or equivalent summary.
5. `git_diff_for_review` supports `focus` or an equivalent review filter.
6. Existing v1 tools still work.
7. `replace_between_markers` is implemented, or Codex clearly explains why it was deferred and all P0/P1 work is complete.
8. Markdown section errors are more actionable, or Codex clearly explains why deferred.
9. README documents the new behavior and examples.
10. Tests cover:
    - low-budget bootstrap priority behavior;
    - diagnostics output;
    - focus filtering or review stats;
    - marker replacement if implemented;
    - at least one safety failure still passes, for example denied `.env` patch.
11. `go test ./...` passes in MCP repo.
12. `go build -o .runtime/bin/shelter-mcp ./cmd/shelter-mcp` passes in MCP repo.
13. `git diff --check` passes in MCP repo.
14. Shelter `docs/repo/status/CODEX_STATUS.md` is updated, or Codex provides a ready-to-paste status block if direct edit is not practical.

---

## 7. Stop conditions

Stop and report clearly if:

- satisfying the task requires generic shell;
- bounded output cannot be preserved;
- repo-root/path safety would be weakened;
- current MCP tool schema approach cannot support new fields without a larger refactor;
- tests fail for unrelated pre-existing reasons;
- implementation would touch secrets or local env files.

---

## 8. Suggested implementation order

1. Inspect current `read_shelter_bootstrap_context` implementation and tests.
2. Reorder deterministic document selection by priority.
3. Add diagnostics fields and tests.
4. Add low-budget tests for `codex/mcp` and `producer/steam`.
5. Add `git_diff_for_review` stats.
6. Add `focus` filtering.
7. Add marker replacement tool.
8. Improve heading-not-found errors.
9. Update README examples.
10. Run gofmt, tests, build, diff check.
11. Update Shelter `CODEX_STATUS.md`.

---

## 9. Notes for `/goal`

This is a focused polish task. Prefer small robust improvements over broad rewrites.

Minimum acceptable delivery:

```text
bootstrap priority fix + diagnostics + tests + README
```

Strong delivery:

```text
minimum + git_diff_for_review stats/focus
```

Excellent delivery:

```text
strong + replace_between_markers + closest heading errors
```

Do not change the core safety model. Do not add product decisions.
