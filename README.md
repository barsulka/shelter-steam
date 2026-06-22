# Shelter Monorepo

Shelter — family of warm, ethical charity-oriented apps and games about helping dogs and shelters.

This repository is organized as a small monorepo:

- `steam/` — Windows/macOS Desktop/Steam Godot game.
- `chrome/` — placeholder workspace for the future Browser Extension.
- `docs/` — shared project documentation and long-term local memory.

## Core Documents

- `PROJECTS_RULES.md` — project-level rules for ChatGPT sessions and other AI roles.
- `AGENTS.md` — repository-level rules for agents working in this repo.
- `steam/AGENTS.md` — Steam/Desktop-specific Godot rules.
- `steam/README.md` — Steam/Desktop project setup and validation.
- `docs/repo/status/CODEX_STATUS.md` — shared development status and Codex working log.
- `docs/repo/adr/README.md` — index of accepted architecture decisions.

## Current Layout

- `steam/` — Godot desktop game workspace.
- `chrome/` — empty future Browser Extension workspace.
- `docs/` — product, design, development, API, ADR, status, and handoff documentation.
- `tilesets/` — shared or imported visual/game assets when relevant.

## Working With Documentation

The local repository is the source of truth for project documentation.

Concrete access rules:

- Codex reads and edits documentation directly through the local filesystem of the current checkout.
- ChatGPT reads and edits documentation through the connected `локальный файлсервер` tool.
- Other AI tools must use their available local-file access mechanism.

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

Update the relevant local documentation. For development tasks, update `docs/repo/status/CODEX_STATUS.md` or provide a ready-to-paste status block.
