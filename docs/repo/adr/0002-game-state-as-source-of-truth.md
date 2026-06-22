# ADR 0002: Game State As Source Of Truth

Date: 2026-06-29

Status: Accepted

Related source: Godot State Connector v0 brief and implementation discussion.

## Context

Shelter Steam/Desktop needs visible slow physical actions, long-running idle behavior, external state inspection, save files, and future tools for Game Designer / Producer / ChatGPT review.

If gameplay logic lives inside UI cards, button handlers, rendered positions, snapshots, or external tools, the project risks multiple competing truths about what dogs, tasks, resources, queues and buildings are doing.

## Decision

The running game/simulation state is the source of truth.

UI, save files, JSON snapshots, connector endpoints and external inspectors are state views. They may read, display, persist, compare or analyze the state, but they must not become separate gameplay simulations.

For example, if a dog walks from one world anchor to another because the distance is large, that movement belongs to the gameplay/simulation state and timing rules. The rendered game interface, connector snapshot and save data should present that state rather than independently inventing it.

## Consequences

- Godot State Connector v0 is read-only observability, not a second simulator.
- Future extraction should move prototype-local state machines toward reusable gameplay/core runtime state, with UI as a view over it.
- Save format and connector schema should be derived from gameplay state, not from UI layout.
- External tools may inspect and eventually request controlled dev actions only through explicit debug contracts, not by owning core simulation.
- Snapshot file writes should be conservative and configurable to avoid unnecessary background load.
