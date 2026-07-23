# Shelter Monorepo

Shelter — family of warm, ethical charity-oriented apps and games about helping dogs and shelters.

This repository is organized as a small monorepo:

- `steam/` — Windows/macOS Desktop/Steam Godot game.
- `chrome/` — placeholder workspace for the future Browser Extension.
- `mcp/` — local Shelter-specific MCP runtime/inspection adapter.
- `docs/` — shared project documentation and long-term local memory.

## Core Documents

- `PROJECTS_RULES.md` — project-level rules for ChatGPT sessions and other AI roles.
- `AGENTS.md` — repository-level rules for agents working in this repo.
- `steam/AGENTS.md` — Steam/Desktop-specific Godot rules.
- `steam/README.md` — Steam/Desktop project setup and validation.
- `docs/repo/status/CODEX_CURRENT_STATUS.md` — current shared development status.
- `docs/repo/adr/README.md` — index of accepted architecture decisions.

## Current Layout

- `steam/` — Godot desktop game workspace.
- `chrome/` — empty future Browser Extension workspace.
- `mcp/` — local Go MCP server for Workbench, Godot control and bounded knowledge navigation.
- `docs/` — product, design, development, API, ADR, status, and handoff documentation.
- `tilesets/` — shared or imported visual/game assets when relevant.

## Working With Documentation

The local repository is the source of truth for project documentation. When the source-derived MCP context bridge is available and reports current health, routine bootstrap and context routing start with its compact `shelter_context_bundle`; direct source reads remain the exact authority and bounded fallback.

Concrete access rules:

- ChatGPT Work and Codex in the desktop local project read and edit the current checkout directly.
- Codex CLI / IDE also use the current checkout directly.
- Other AI tools must use their available local-file access mechanism.

Shelter MCP is a local STDIO domain-specific adapter for whitelisted Workbench Runtime Capture, Godot connector/control, capture management and source-derived bounded knowledge navigation. The project-scoped setup lives in `.codex/config.toml`; `mcp/run.sh` is the portable local launcher. D-026 is accepted, implemented and independently reviewed `PASS`: the prior two P1 and two P2 findings are closed, the full local/client matrix passes, and healthy `shelter_context_bundle` is now the routine bootstrap default. Direct source reads remain authority and the exact documented fallback, not the routine path.

The implementation and acceptance authority is `docs/drive/Shelter/04_DEVELOPMENT/SHELTER_WORKFLOW__Codex_Brief__Source_Derived_MCP_Context_Bridge_v1.md`.

Start significant work by reading `PROJECTS_RULES.md`, then `AGENTS.md`, then the relevant documents in `docs/` or the target subproject. For technical implementation, check `docs/repo/adr/README.md` and read the relevant accepted ADRs before changing code or runtime contracts.

## Working In Steam/Desktop

Run Godot commands from `steam/`:

```sh
cd steam
./launch.sh
tools/check-godot.sh
tools/dev-companion-field.sh smoke
tools/dev-window-spike.sh smoke
```

Steam/Desktop must stay separate from Browser Extension UX. It is a Windows/macOS Godot game, not a Chrome new-tab product.

## Working In Chrome

`chrome/` is intentionally empty for now. Do not add extension code, `manifest.json`, or Chrome-specific UX until a dedicated Browser Extension task defines the technical direction.

## After Significant Work

Update the relevant local documentation. For development tasks, update `docs/repo/status/CODEX_CURRENT_STATUS.md` or provide a ready-to-paste status block. Superseded/history Markdown normally remains only in Git history; fixed-path or immutable evidence exceptions are documented in the repository governance files.
