# SHELTER MCP — Codex Brief — Repo Diff, Patch and Doc Editing Tools v1

Дата: 2026-07-07
Статус: active Codex brief
Роль-владелец: Producer / Codex
Рекомендуемый режим Codex: `/goal`
Рекомендуемый уровень рассуждений: высокий
Репозиторий для реализации: `mcp`
Связанный Shelter repo: `/Users/barsulka/GolandProjects/shelter/shelter`

---

## 0. Goal

Add safe, typed, review-friendly MCP tools to Shelter MCP so ChatGPT / other AI sessions can work with Shelter repo documentation more reliably, without generic shell access.

The tools should make it easier to:

1. inspect repo changes;
2. review diffs after Codex edits;
3. apply patches safely with dry-run;
4. edit markdown sections without fragile exact-string replacement;
5. read a bounded Shelter bootstrap/context bundle;
6. reduce token waste and accidental reading of historical/evidence docs.

This task is about **MCP developer tooling and documentation workflow**, not product gameplay.

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
mcp/README.md
```

Also inspect relevant MCP source files in `mcp` before editing.

---

## 2. Product / safety constraints

Shelter MCP must remain a safe, whitelisted bridge.

Do not add generic shell access.

Do not add tools that execute arbitrary commands, arbitrary scripts, arbitrary URLs or arbitrary shell text.

Do not expose secrets, `.env`, API keys, tunnel profiles, tokens or local credentials.

All repo operations must be limited to explicitly configured safe roots.

Default safe roots for this task:

```text
/Users/barsulka/GolandProjects/shelter/shelter
mcp
```

Implementation should preserve the existing Shelter MCP safety shape:

- commands by enum / typed tool args, not shell strings;
- bounded outputs;
- dry-run where changes are risky;
- clear errors;
- no accidental writes outside allowed roots;
- no deletion tools unless explicitly requested in a future brief.

---

## 3. Required tools

Implement as many of the following as is practical in one coherent pass. If implementation time is limited, prioritize in the order below.

### P0 — `git_status`

Purpose: show concise repo working-tree state.

Suggested input:

```json
{
  "repo": "shelter" | "mcp"
}
```

Suggested output:

```json
{
  "repo": "shelter",
  "root": "/absolute/path",
  "branch": "...",
  "head": "...",
  "is_clean": false,
  "changed_files": [
    {
      "path": "docs/.../file.md",
      "status": "modified|added|deleted|renamed|untracked"
    }
  ],
  "summary": "..."
}
```

Implementation notes:

- Use `git` executable with fixed args only, not shell.
- Prefer porcelain output for parsing.
- Bound output size.
- If repo root is not a git repo, return a typed error.

---

### P0 — `git_diff`

Purpose: provide bounded diff for review.

Suggested input:

```json
{
  "repo": "shelter" | "mcp",
  "paths": ["optional/relative/path.md"],
  "staged": false,
  "max_bytes": 60000
}
```

Suggested output:

```json
{
  "repo": "shelter",
  "root": "/absolute/path",
  "paths": [],
  "truncated": false,
  "diff": "...",
  "changed_files": [...]
}
```

Safety:

- Paths must be relative and must stay inside repo root.
- No arbitrary git args.
- Redact obvious secrets if feasible; at minimum do not read `.env` by default.

---

### P0 — `git_diff_for_review`

Purpose: make ChatGPT review after Codex changes easy.

Suggested input:

```json
{
  "repo": "shelter" | "mcp",
  "paths": [],
  "max_bytes": 80000,
  "include_risk_flags": true
}
```

Suggested output:

```json
{
  "repo": "shelter",
  "is_clean": false,
  "changed_files": [...],
  "diff": "...",
  "truncated": false,
  "risk_flags": [
    {
      "severity": "info|warning|danger",
      "path": "...",
      "message": "Touched PROJECTS_RULES.md"
    }
  ],
  "review_summary": "..."
}
```

Risk flags should be simple heuristics, for example:

- touched `PROJECTS_RULES.md`, `AGENTS.md`, role docs, ADRs, `02_DECISIONS.md`;
- deleted files;
- modified `.env`, secrets-looking files, or ignored runtime outputs;
- touched many files;
- diff was truncated;
- changed `99_ARCHIVE` or old evidence docs;
- changed Godot project files when task claims docs-only.

Do not overengineer. Simple path/status heuristics are enough.

---

### P1 — `apply_patch`

Purpose: apply unified diff patches safely.

Suggested input:

```json
{
  "repo": "shelter" | "mcp",
  "patch": "unified diff text",
  "dry_run": true
}
```

Behavior:

- `dry_run` defaults to true.
- In dry-run mode, verify that the patch applies cleanly and return affected files.
- In write mode, apply only if it applies cleanly.
- Fail if patch touches files outside repo root.
- Fail if patch touches denied files unless explicitly allowed by implementation rules.

Suggested output:

```json
{
  "repo": "shelter",
  "dry_run": true,
  "applies_cleanly": true,
  "changed_files": [...],
  "stdout": "...",
  "stderr": "..."
}
```

Implementation options:

- Prefer invoking `git apply --check` / `git apply` with fixed args and patch via stdin.
- Do not pass arbitrary git options from user input.

---

### P1 — Markdown section editing tools

Implement either a single tool with operation enum or separate tools. Separate tools are easier for AI sessions.

#### `insert_section_after_heading`

Suggested input:

```json
{
  "repo": "shelter" | "mcp",
  "path": "relative/file.md",
  "heading": "## Target Heading",
  "markdown": "## New Section\n...",
  "dry_run": true
}
```

Behavior:

- Find exact markdown heading line.
- Insert markdown after the heading's section, or immediately after heading line if `mode` is implemented that way.
- Prefer `after_section` behavior if straightforward.
- Return diff.
- Fail if heading not found or ambiguous.

#### `replace_section`

Suggested input:

```json
{
  "repo": "shelter" | "mcp",
  "path": "relative/file.md",
  "heading": "## Target Heading",
  "markdown": "## Target Heading\nnew body...",
  "dry_run": true
}
```

Behavior:

- Replace the section from the matched heading until the next heading of same or higher level.
- Return diff.
- Fail if heading not found or ambiguous.
- Preserve line endings reasonably.

#### `append_changelog_entry`

Suggested input:

```json
{
  "repo": "shelter" | "mcp",
  "path": "relative/file.md",
  "entry_heading": "### 2026-07-07 — change summary",
  "entry_markdown": "- bullet...",
  "dry_run": true
}
```

Behavior:

- Find a `## Changelog` or `## 10. Changelog` / similar heading.
- Insert new entry as first entry under changelog.
- Return diff.
- Fail clearly if changelog heading is missing.

---

### P2 — `read_shelter_bootstrap_context`

Purpose: give AI sessions one bounded context bundle rather than manually reading many docs.

Suggested input:

```json
{
  "role": "producer|project_manager|game_designer|art_director|codex|generic",
  "area": "steam|mcp|docs|browser|mobile|generic",
  "max_bytes": 120000
}
```

Suggested behavior:

- Read fixed known docs from Shelter repo according to role/area.
- Always include `PROJECTS_RULES.md`, `AGENTS.md`, `README.md`, `BOOTSTRAP_CONTEXT.md` if within budget.
- Include relevant role doc if role is known.
- Include `STEAM_DESKTOP__CURRENT_CONTEXT.md` for `area=steam`.
- Include `CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md` for `role=codex` or `area=mcp`.
- Include `SUPERSEDED_MAP.md` for docs cleanup / PM contexts.
- Return list of paths included, skipped paths, truncation status, and concatenated content.

Suggested output:

```json
{
  "role": "producer",
  "area": "steam",
  "included_paths": [...],
  "skipped_paths": [...],
  "truncated": false,
  "content": "..."
}
```

Do not use AI summarization inside MCP. This is deterministic file bundling only.

---

### P2 — `write_file_if_unchanged`

Purpose: prevent lost updates during long ChatGPT sessions.

Suggested input:

```json
{
  "repo": "shelter" | "mcp",
  "path": "relative/file.md",
  "expected_sha256": "...",
  "content": "...",
  "dry_run": true
}
```

Behavior:

- Read current file, compute sha256.
- If it differs from expected, fail and return current hash.
- If equal, write content in write mode.
- Return diff.

This is optional but valuable.

---

## 4. Out of scope

Do not implement:

- generic shell command execution;
- generic `git commit`, `git push`, `git reset`, `git checkout`;
- destructive delete/archive/move workflows;
- AI summarization inside MCP;
- product/gameplay changes in Shelter Steam;
- changes to Chrome/Mobile product code;
- broad refactor unrelated to MCP tools;
- web research tools;
- external network access beyond existing local connector/tunnel behavior.

---

## 5. Expected implementation areas

Likely MCP repo areas to inspect/edit:

```text
mcp/cmd/shelter-mcp
mcp/internal/...
mcp/README.md
```

Actual layout may differ; inspect before editing.

If new configuration is needed, prefer explicit environment variables with safe defaults, for example:

```text
SHELTER_MCP_REPO_ROOT=/Users/barsulka/GolandProjects/shelter/shelter
```

But do not break existing `.env` / `run.sh` behavior.

---

## 6. Acceptance criteria

Task is accepted when:

1. MCP exposes `git_status`, `git_diff`, and `git_diff_for_review` or equivalent named tools.
2. At least one safe patch/edit path exists:
   - preferred: `apply_patch`; and/or
   - markdown section editing tools.
3. Tools operate only on allowed repo roots and relative paths.
4. Tool outputs are bounded and typed.
5. Dry-run exists for risky write operations.
6. Tests or smoke checks cover happy path and at least one safety failure.
7. `README.md` documents the new tools and examples.
8. `go test ./...` passes in MCP repo.
9. Relevant Shelter docs are updated if needed:
   - `docs/repo/status/CODEX_STATUS.md` in Shelter repo, or a ready-to-paste status block if direct edit is not practical.
10. Final Codex response includes:
   - changed files;
   - tests run;
   - tools added;
   - known limitations;
   - any follow-up recommendations.

---

## 7. Stop conditions

Stop and ask the user / return a clear note if:

- implementing this requires generic shell exposure;
- repo root safety cannot be enforced;
- existing MCP architecture makes tool registration unclear and would require a large rewrite;
- `go test ./...` fails for unrelated pre-existing reasons;
- patch tooling would require writing outside allowed repo roots;
- secrets or `.env` files would need to be read or modified.

---

## 8. Suggested implementation order

1. Inspect MCP tool registration and config patterns.
2. Add repo root resolver for enum repo ids: `shelter`, `mcp`.
3. Add path safety helper for relative paths.
4. Implement `git_status`.
5. Implement `git_diff`.
6. Implement `git_diff_for_review` using status + diff + simple risk flags.
7. Implement `apply_patch` with dry-run default.
8. Implement markdown section editing tools if time permits.
9. Implement `read_shelter_bootstrap_context` if time permits.
10. Add tests/smoke coverage.
11. Update MCP README.
12. Update Shelter `CODEX_STATUS.md` or provide status block.

---

## 9. Notes for `/goal`

This is a goal-mode task. Codex should work autonomously inside the MCP repo, but keep changes narrow and safe.

Prefer shipping fewer solid tools over many half-working tools.

Minimum useful delivery:

```text
git_status + git_diff + git_diff_for_review + README + tests
```

Strong delivery:

```text
minimum + apply_patch + markdown section editing tools
```

Excellent delivery:

```text
strong + read_shelter_bootstrap_context + write_file_if_unchanged
```

Do not invent new product decisions. This task is only about making file/doc workflows easier and safer for AI sessions.
