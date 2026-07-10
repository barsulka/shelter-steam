# Shelter MCP

Local MCP server for safe Shelter Steam/Desktop development operations.

This server intentionally does not expose a generic shell. It exposes a small
set of MCP tools that map typed JSON input onto whitelisted local Shelter dev
commands and the local Godot State Connector HTTP control API.

## Build

```sh
go test ./...
go build -o .runtime/bin/shelter-mcp ./cmd/shelter-mcp
```

## Run

STDIO, for local MCP clients:

```sh
go run ./cmd/shelter-mcp
```

Streamable HTTP, useful for a local tunnel or manual inspection:

```sh
go run ./cmd/shelter-mcp --http 127.0.0.1:8090
```

## Run Through OpenAI Secure MCP Tunnel

Create a local `.env` from `.env.example`:

```sh
cp .env.example .env
```

Fill:

- `CONTROL_PLANE_API_KEY`: runtime API key from
  `https://platform.openai.com/settings/organization/api-keys` with only
  Tunnels Read + Use.
- `CONTROL_PLANE_TUNNEL_ID`: tunnel id from
  `https://platform.openai.com/settings/organization/tunnels`.
- `SHELTER_STEAM_ROOT`: absolute path to the local Shelter Steam/Desktop Godot
  project.
- Optional safe repo root overrides for repo/document tools:
  `SHELTER_MCP_REPO_ROOT` for the Shelter monorepo checkout and
  `SHELTER_MCP_SELF_ROOT` for this MCP checkout. By default they are derived
  from `SHELTER_STEAM_ROOT` and this repo's `go.mod`.
- `SHELTER_MCP_FILESYSTEM_ROOTS`: comma-separated roots delegated to the
  proxied filesystem MCP server, or set `SHELTER_MCP_FILESYSTEM=0` to disable
  `fs_*` tools.

Then run:

```sh
./run.sh
```

The script builds `.runtime/bin/shelter-mcp`, creates or updates the local
`tunnel-client` profile named by `TUNNEL_PROFILE` (default `shelter-test`) with
`sample_mcp_stdio_local`, runs `doctor --explain`, then starts the tunnel. It
does not reuse values from an existing local profile; `.env` is the source of
truth.

Filesystem proxy is enabled automatically when `mcp-server-filesystem` is in
`PATH`. `./run.sh` installs it with
`npm install -g @modelcontextprotocol/server-filesystem` when it is missing,
then preflights it against the first configured filesystem root.

Configure it with:

```sh
export SHELTER_MCP_FILESYSTEM_ROOTS="/path/to/root1,/path/to/root2"
export SHELTER_MCP_FILESYSTEM_COMMAND="/opt/homebrew/bin/mcp-server-filesystem"
export SHELTER_MCP_FILESYSTEM_PREFIX="fs_"
export SHELTER_MCP_FILESYSTEM=0   # disable the upstream proxy
```

Example MCP client config for a stdio client:

```json
{
  "mcpServers": {
    "shelter": {
      "command": "go",
      "args": [
        "run",
        "/absolute/path/to/shelter-mcp/cmd/shelter-mcp"
      ]
    }
  }
}
```

## Tools

- `list_shelter_dev_commands` lists supported command and control action IDs.
- `list_shelter_upstreams` reports proxied MCP upstreams, including filesystem
  status, roots, prefix and tool count.
- `run_shelter_dev_command` runs a whitelisted command. Current commands include:
  `workbench_capture`, smoke checks, lookup-only launcher URL commands, and
  safe launcher shutdown helpers.
- `list_workbench_runs`, `get_workbench_run_artifacts`, and `clear_workbench_runs`
  manage local capture bundles under
  `steam/.runtime/workbench_capture_runs`.
- `start_shelter_control_connector` and `stop_shelter_control_connector`
  manage a local token-protected Godot connector/control runtime.
- `control_shelter_game` calls whitelisted local connector HTTP actions, including
  fixture load, state export/import, speed, debug tick, route start, dispatch
  confirmation, dog assign, research start, capture, and UI visibility commands.
- Proxied filesystem MCP tools are exposed with the configured prefix, for
  example `fs_read_text_file`, `fs_list_directory`, `fs_search_files`,
  `fs_write_file`, `fs_edit_file`, and `fs_list_allowed_directories`.
- `git_status`, `git_diff`, and `git_diff_for_review` inspect bounded git
  state for the `shelter` or `mcp` repo using fixed git arguments.
- `apply_patch` checks or applies unified diff patches inside an allowed repo
  root. `dry_run` defaults to `true`.
- `insert_section_after_heading`, `replace_section`, and
  `append_changelog_entry` edit markdown sections by heading and return a diff.
  `dry_run` defaults to `true`.
- `replace_between_markers` edits a markdown block between unique marker lines
  while preserving those markers. `dry_run` defaults to `true`.
- `read_shelter_bootstrap_context` reads a bounded deterministic context bundle
  from fixed Shelter docs for a role and area. It uses a priority-first order:
  compressed/current-context docs and role docs are considered before long root
  docs, and the result includes per-file byte diagnostics. It does not
  summarize.
- `find_current_context` returns the Current Memory and Knowledge document paths
  that should be read first for a Shelter area.
- `list_decisions` lists accepted Shelter decisions for an area and kind from a
  static catalog. It returns decision id, title, kind, status, short summary,
  source path and mapped areas.
- `decision_digest` returns compact accepted decision summaries for an area.
  It is shorter than `list_decisions` and points to `02_DECISIONS.md` only when
  exact wording is needed.
- `get_decision` returns one accepted decision by id, or a structured not-found
  response with available ids.
- `list_open_questions` lists current questions from the
  `03_OPEN_QUESTIONS.md` model by area and status.
- `open_questions_digest` returns compact open-question summaries by area and
  status. Browser digest includes related platform, charity and shared questions.
- `list_roadmaps` lists known roadmap docs with status, current phase, next
  step and owner.
- `latest_handoff` returns the latest known relevant handoff for a role and
  area from a bounded static catalog, with an `available` flag for the local
  file.
- `knowledge_task_context` returns deterministic reading-order docs for a role,
  area and task, split into `read_first`, `read_by_task`,
  `avoid_by_default`, and `notes`.
- `shelter_status` returns a compact deterministic project/area dashboard for
  fresh-session entry.
- `current_entry_digest` returns the minimal fresh-session entry docs for a role
  and area without reading file contents.
- `list_active_docs` lists cataloged active/current/relevant docs for an area
  and layer (`current`, `knowledge`, `history`, or `all`) without reading file
  contents.
- `classify_doc_path` classifies one Shelter documentation path as Current
  Memory, Knowledge, History, or unknown using static catalog and path rules.
- `explain_superseded` explains whether a doc path is superseded, evidence,
  archive/history, or unknown, and points to the current source when known.
- `knowledge_gc_report` generates a deterministic read-only PM cleanup report
  from the static catalog and bounded local docs path rules. It does not modify
  files.
- `write_file_if_unchanged` writes a safe repo file only when the current
  `sha256` matches the caller's `expected_sha256`.

First-party Shelter MCP tools publish explicit output schemas through typed Go
output structs and the `github.com/modelcontextprotocol/go-sdk` `mcp.AddTool`
schema inference. Proxied `fs_*` tools keep the upstream filesystem server's
schemas.

The `fs_*` tools are not reimplemented here. The server starts the official
`@modelcontextprotocol/server-filesystem` stdio MCP as an upstream, copies its
tool schemas into this server, and forwards tool calls to the upstream runtime.

Example workbench capture:

```json
{
  "command": "workbench_capture",
  "scenario": "first_delivery_with_dispatch_confirmation",
  "fixture": "first_day_empty_coop",
  "game_seconds": 420,
  "sample_every_game_seconds": 10,
  "speed": 100,
  "output_dir": ".runtime/workbench_capture_runs/first_delivery_with_dispatch_confirmation_v0",
  "include_artifacts": ["manifest.json", "final_state.json", "run.log"]
}
```

This maps to:

```sh
cd "$SHELTER_STEAM_ROOT"
tools/dev-vertical-slice.sh workbench-capture \
  --scenario=first_delivery_with_dispatch_confirmation \
  --fixture=first_day_empty_coop \
  --game-seconds=420 \
  --sample-every-game-seconds=10 \
  --speed=100 \
  --output-dir=.runtime/workbench_capture_runs/first_delivery_with_dispatch_confirmation_v0
```

The tool result includes the command result, parsed `manifest.json`, a run
summary, and selected artifact contents up to `max_artifact_bytes`.

Example direct runtime state import:

```json
{
  "action": "runtime_state_import",
  "token": "connector-token",
  "payload": {
    "schema_version": "shelter.game_systems_runtime.v0",
    "dogs": [],
    "routes": []
  }
}
```

Example repo status:

```json
{
  "repo": "shelter"
}
```

Example bounded review diff:

```json
{
  "repo": "mcp",
  "focus": "code",
  "max_bytes": 80000,
  "include_risk_flags": true
}
```

`git_diff_for_review` returns `review_stats` with lightweight file category
counts and `git diff --numstat` insertions/deletions. The optional `focus`
filter accepts `all`, `docs`, `code`, or `mixed`; focused reviews omit obvious
runtime/capture/media noise unless explicit `paths` are supplied.

Example patch dry run:

```json
{
  "repo": "shelter",
  "patch": "diff --git a/docs/example.md b/docs/example.md\n--- a/docs/example.md\n+++ b/docs/example.md\n@@ -1 +1 @@\n-old\n+new\n",
  "dry_run": true
}
```

Example markdown section replacement:

```json
{
  "repo": "shelter",
  "path": "docs/repo/status/CODEX_STATUS.md",
  "heading": "## 2026-07-07 - Example",
  "markdown": "## 2026-07-07 - Example\n\n- Updated text.\n",
  "dry_run": true
}
```

Example marker replacement:

```json
{
  "repo": "shelter",
  "path": "docs/example.md",
  "start_marker": "<!-- START: daily-note -->",
  "end_marker": "<!-- END: daily-note -->",
  "content": "Updated markdown between the markers.",
  "dry_run": true
}
```

When a markdown heading is missing, section tools return nearby headings in
`closest_headings` so callers can recover without reading the whole file.

Example bootstrap bundle:

```json
{
  "role": "codex",
  "area": "mcp",
  "max_bytes": 40000
}
```

The bootstrap result includes `included_bytes`, `remaining_budget`,
`per_file_sizes`, and `bootstrap_summary`, plus the existing `included_paths`,
`skipped_paths`, `truncated`, and `content` fields.

Example PM/docs bootstrap bundle:

```json
{
  "role": "project_manager",
  "area": "docs",
  "max_bytes": 50000
}
```

The expected early docs include `BOOTSTRAP_CONTEXT.md`,
`000_ROLE_PROJECT_MANAGER.md`, `SUPERSEDED_MAP.md`, and
`05_DOCUMENTATION_GOVERNANCE.md`. If the byte budget is too small, the
per-file diagnostics say `budget exceeded` for skipped files.

Example current-context lookup:

```json
{
  "area": "steam"
}
```

Example decision lookup:

```json
{
  "area": "steam",
  "kind": "all"
}
```

Example decision digest:

```json
{
  "area": "steam",
  "max_items": 20
}
```

Example single decision:

```json
{
  "id": "D-020"
}
```

Example open questions:

```json
{
  "area": "browser",
  "status": "open"
}
```

Example open questions digest:

```json
{
  "area": "browser",
  "status": "all"
}
```

Example roadmap listing:

```json
{
  "area": "docs"
}
```

Example latest handoff:

```json
{
  "role": "producer",
  "area": "docs"
}
```

Example task context:

```json
{
  "role": "project_manager",
  "area": "docs",
  "task": "cleanup"
}
```

Example Shelter status dashboard:

```json
{
  "area": "steam"
}
```

Example fresh-session entry digest:

```json
{
  "role": "game_designer",
  "area": "steam"
}
```

Example active docs listing:

```json
{
  "area": "docs",
  "layer": "knowledge"
}
```

Example superseded explanation:

```json
{
  "path": "docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v1/README.md"
}
```

Example Knowledge GC report:

```json
{
  "area": "docs",
  "max_entries": 100
}
```

## Safety Shape

- Commands are selected by enum, not by passing shell text.
- Process execution uses `exec.Command` with fixed script paths and argument
  arrays.
- Repo tools accept only `repo: "shelter"` or `repo: "mcp"` and validate that
  paths are relative and stay inside the selected git root.
- Git tools use fixed `git status`, `git diff`, and `git apply` argument lists;
  callers cannot pass arbitrary git or shell options.
- Diff, patch, and write helpers deny `.git`, `.env`, common key/certificate
  extensions, and obvious secrets-looking paths. Secret-looking added diff
  lines are redacted as an extra guard.
- Risky write tools default to dry-run and return a diff before writing.
- Workbench output paths must stay inside
  `.runtime/workbench_capture_runs`.
- HTTP control calls are limited to `http://localhost` or loopback addresses.
- Connector tokens are redacted in command echoes and URLs.
- `clear_workbench_runs` requires `confirm=true` unless it is a dry run.
- Filesystem access control remains owned by upstream
  `@modelcontextprotocol/server-filesystem`; this server only chooses the
  allowed roots and prefixes delegated tool names.
- Knowledge tools are deterministic local catalog/path tools. They do not add
  shell access, arbitrary git commands, network calls, AI summarization, vector
  search, embeddings, filesystem writes, or broader filesystem roots.

## Agent Skills Note

The MCP docs page "Build with Agent Skills" points to the `mcp-server-dev`
agent-skill/plugin set. It is useful when designing a new MCP server from a
blank use case, adding MCP apps/widgets, or packaging a local server as MCPB.

This repo currently keeps the server as a direct local Go stdio/HTTP prototype.
When we are ready to package it for easier install, the likely next step is to
use that skill/plugin path for MCPB guidance.
