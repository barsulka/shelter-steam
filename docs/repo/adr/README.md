# Architecture Decision Records

`docs/repo/adr/` stores accepted technical decisions that should guide future implementation.

Before technical work, Codex must check this index and read all relevant `Accepted` ADRs. If an ADR may affect the task, treat it as relevant.

## Active Decisions

| ADR | Status | Scope | When To Read |
| --- | --- | --- | --- |
| [0001: Use Godot For Steam/Desktop](0001-use-godot-for-steam-desktop.md) | Accepted | Steam/Desktop engine and language direction | Read before Steam/Desktop implementation, engine/runtime decisions, platform behavior, or changes that could blur Steam/Desktop with other products. |
| [0002: Game State As Source Of Truth](0002-game-state-as-source-of-truth.md) | Accepted | Runtime state, UI, saves, snapshots, connectors, external inspectors | Read before changing gameplay state architecture, task/resource/dog/building runtime logic, save format, state snapshots, connector endpoints, or inspector/debug tooling. |

## Rules

- ADRs are not task briefs; they are long-lived constraints and rationale.
- A new technical rule should be captured as a new ADR or an update to an existing ADR.
- If an ADR conflicts with `PROJECTS_RULES.md`, `PROJECTS_RULES.md` wins and the conflict must be reported.
- If an ADR conflicts with an implementation brief, stop and ask which document should be updated.
