# CODEX_CURRENT_STATUS

Дата создания: 2026-07-07
Обновлено: 2026-07-10
Статус: current-summary
Владелец: Codex / Project Manager
Назначение: короткий текущий dev-status entry point. Не является историческим журналом.

---

## 0. Read policy

Читать этот документ для быстрого dev/Codex входа вместо полного чтения `CODEX_STATUS.md`.

Для детальной истории использовать:

```text
docs/repo/status/CODEX_STATUS.md
```

Для compressed implementation context использовать:

```text
docs/drive/Shelter/04_DEVELOPMENT/CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md
```

---

## 1. Current dev focus

Current primary implementation area:

```text
Shelter Steam/Desktop + Shelter MCP tooling
```

Current product state:

```text
First Day MVP locked at prototype/product-language level.
Next selected product scope: First Week / Day 2 / longer retention.
```

Current tooling state:

```text
ChatGPT Work/Codex reads this checkout directly.
Shelter MCP under mcp/ is an optional local domain-specific runtime/inspection adapter.
Project-scoped local STDIO setup is complete.
```

---

## 2. Current implemented capabilities

Steam/Desktop / Godot:

- Godot 4.x project under `steam/`.
- Desktop window / companion strip tech demos.
- Vertical Slice prototype.
- Dog rig spikes and dog runtime integration slice.
- Godot State Connector.
- Godot Control Connector.
- Workbench Runtime Capture Harness.
- First Day MVP runtime proof.
- First Day visible review capture packs v1/v2/v3.
- First Day Art/UX visual-language pass v1 accepted as prototype pass.

Shelter MCP:

- whitelisted Shelter dev commands;
- workbench capture management;
- local Godot connector/control runtime management;
- whitelisted runtime control actions;
- safe repo tools: `git_status`, `git_diff`, `git_diff_for_review`;
- safe patch/edit tools: `apply_patch`, markdown section editing, marker replacement, sha256 guarded writes;
- deterministic bootstrap/context bundling via `read_shelter_bootstrap_context` with priority-first order and diagnostics.
- deterministic knowledge access tools: `find_current_context`, `list_decisions`, `decision_digest`, `get_decision`, `list_open_questions`, `open_questions_digest`, `list_roadmaps`, `latest_handoff`, `knowledge_task_context`, `shelter_status`, `current_entry_digest`, `list_active_docs`, `classify_doc_path`, `explain_superseded`, `knowledge_gc_report`.

---

## 3. Current active docs for dev sessions

Read first for dev/Codex tasks:

```text
PROJECTS_RULES.md
AGENTS.md
README.md
steam/AGENTS.md
steam/README.md
docs/repo/adr/README.md
docs/repo/status/CODEX_CURRENT_STATUS.md
docs/drive/Shelter/04_DEVELOPMENT/CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md
```

For task execution, read the active brief in:

```text
docs/drive/Shelter/04_DEVELOPMENT/
```

---

## 4. Current known limitations

- Windows behavior remains less tested than macOS visible checks.
- Prototype visual-language evidence is not production art or shipping UX.
- 100x Workbench capture validates state/causality, not player feel or visual warmth.
- Capture packs are evidence/history, not default bootstrap context.
- `CODEX_STATUS.md` is a historical log and should not be read in full by default.
- MCP repo/document tools are safe helpers, not a generic shell.
- Static MCP knowledge summaries are guarded by startup/test validation; source documents win.
- Read-only MCP knowledge/inspection tools run non-interactively through explicit per-tool approval; runtime-changing tools still require prompt approval.

---

## 5. Current next likely dev step

Completed workflow/tooling brief:

```text
docs/drive/Shelter/04_DEVELOPMENT/SHELTER_WORKFLOW__Codex_Brief__ChatGPT_Work_And_Local_MCP_Migration_v1.md
```

This brief completed workflow, MCP/config and dev documentation. No Godot/runtime behavior changed.

Current product follow-up:

If Producer accepts First Week / Day 2 as implementation-ready, next likely brief:

```text
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Second_Day_Return_And_Second_Order_v1.md
```

Expected reasoning level:

```text
очень высокий
```

---

## 6. Changelog

### 2026-07-10 — D-021 workflow migration

- Switched current access truth from MCP bridge to direct local Work/Codex checkout.
- Reclassified Shelter MCP as a local domain-specific adapter and completed project-scoped STDIO setup.
- Completed the dedicated migration brief and project-scoped local STDIO setup.
- Corrective audit added full source/catalog content locks, exact roadmap-state validation, safe per-tool approvals and a nested-cwd `codex exec` smoke.

### 2026-07-09 — Shelter MCP knowledge polish dashboard

- Added deterministic Shelter MCP polish tools for fresh-session entry: `decision_digest`, `shelter_status`, `open_questions_digest`, and `current_entry_digest`.
- Kept the polish tools read-only, bounded and static-catalog/simple-rule based.

### 2026-07-07 — Shelter MCP Knowledge API v2

- Added deterministic Shelter MCP Knowledge API v2 tools for decisions, open questions, roadmaps, latest handoff and task-specific reading context.
- Kept the v2 knowledge tools read-only, bounded and static-catalog/simple-rule based: no generic shell, broad repo search, network calls, AI summarization, embeddings or vector DB.

### 2026-07-07 — Shelter MCP knowledge service v1

- Added deterministic Shelter MCP knowledge access tools for Current Memory / Knowledge / History routing.
- PM/docs bootstrap now treats `05_DOCUMENTATION_GOVERNANCE.md` as a first-class docs bootstrap document.

### 2026-07-07 — v1 created

- Created short current dev-status entry point.
- Clarified that `CODEX_STATUS.md` remains detailed history log and should not be used as default bootstrap document.
- Pointed Codex/dev sessions to current context docs and active briefs.
