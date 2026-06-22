# ADR 0001: Use Godot For Steam/Desktop

Date: 2026-06-22

Status: Accepted

Related source decision: Google Drive `Shelter/00_START_HERE/02_DECISIONS`, D-007.

## Context

Shelter Steam/Desktop is planned as a light, warm idle game for Windows and macOS. The product may eventually use a minimal always-on-top desktop field, real transparent window areas, UI hiding, and visible slow physical actions such as walking, carrying, feeding, cleaning, repairing, and caring for dogs.

The project must stay small-team friendly, desktop-first, performant for long-running sessions, and free from avoidable licensing or production complexity.

## Decision

Use Godot 4.x as the primary engine for the Steam/Desktop version.

Use GDScript for the initial game logic.

Use C# or GDExtension only when there is a concrete need, such as Steamworks integration, native Windows/macOS window APIs, performance-critical subsystems, or other platform integration that Godot/GDScript cannot handle cleanly.

Develop the Steam/Desktop codebase separately from the mobile game and browser extension. Shared work can happen later at the product, content, backend, economy, or reporting-contract level, but a unified codebase is not required.

## Consequences

- The repo root is a Godot project.
- Godot scenes and GDScript should remain simple until the first playable slice requires more structure.
- Desktop window behavior must be validated with technical spikes instead of assumed.
- Performance and low background load are architectural constraints, not polish tasks.
- Any future deviation from Godot/GDScript-first requires a new or updated ADR and a `docs/repo/status/CODEX_STATUS.md` entry.
