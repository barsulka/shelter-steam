# Shelter — Project Index

Обновлено: 2026-07-21
Статус: current routing
Владелец: Project Manager

## Вход в проект

1. Repo root: `PROJECTS_RULES.md`.
2. Repo root: `AGENTS.md`.
3. Repo root: `README.md`.
4. `BOOTSTRAP_CONTEXT.md`.
5. Ролевой документ `000_ROLE_*.md`.
6. Релевантный current-context и roadmap.
7. Task-specific Knowledge.
8. Required Evidence — только когда этого требует brief, validator, hash contract
   или regression task.

Если source-derived Shelter MCP сообщает `health=current`, его context bundle —
обычный компактный маршрут входа. Локальные source docs остаются authority,
exact fallback и единственным местом редактирования.

## Текущий фокус

```text
Visual Shell Lock
        ↓ user visual approval
Interactive Shelter Shell
```

Day 1 / Day 2 и производство отложены; они не являются current routing. Детали
текущего контракта:

- `01_CURRENT_STATUS.md`;
- `../02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__CURRENT_CONTEXT.md`;
- `../02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Game_Design_Roadmap_v2.md`;
- `../03_DESIGN/ART_DIRECTION__CURRENT_CONTEXT.md`;
- `../04_DEVELOPMENT/CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md`;
- repo-level `docs/repo/status/CODEX_CURRENT_STATUS.md`.

## Current Memory

- `BOOTSTRAP_CONTEXT.md` — минимальный вход;
- `01_CURRENT_STATUS.md` — единый текущий статус;
- `02_DECISIONS.md` — действующие решения и relationships;
- `03_OPEN_QUESTIONS.md` — только реальные открытые вопросы;
- `05_DOCUMENTATION_GOVERNANCE.md` — retention и cleanup;
- product/design/dev current-context docs выше.

## Knowledge по задаче

- `../01_PRODUCT_STRATEGY/` — стратегия;
- `../02_PRODUCTS/` — продуктовые и gameplay contracts;
- `../03_DESIGN/` — visual/art contracts и approved deliverables;
- `../04_DEVELOPMENT/` — только активные или неизменяемо требуемые briefs/contracts;
- `../04_SHELTER_STRESS_TESTS/` — identity/system stress tests;
- `../05_RESEARCH/` и `../07_LEGAL_FINANCE_CHARITY/` — только по релевантной задаче;
- `../06_SESSIONS_AND_HANDOFFS/HANDOFF_INDEX.md` — единственный handoff routing index.

## Evidence и история

В checkout сохраняются только evidence/regression artifacts, чьи exact bytes или
пути реально нужны текущему validator/hash/runtime contract. Остальная история,
включая superseded briefs, reviews, handoff и changelog, живёт в Git history.

Не восстанавливать контекст последовательным чтением старых capture packs,
handoff или `CODEX_STATUS.md`. Исключения и точные причины перечислены в
`SUPERSEDED_MAP.md` и `EVIDENCE_READ_POLICY.md`.

## Границы подпроектов

- `steam/` — текущий macOS-first Godot product; Windows — отдельная будущая
  pre-release wave.
- `chrome/` — замороженный placeholder; без отдельного brief не создавать
  extension runtime/manifest/UX.
- `mcp/` — локальный domain-specific adapter, не часть game runtime.
- Browser/Mobile/new MCP/infrastructure не активируются до приятного playable
  Steam shell.

Перед изменением Steam code/runtime/dev tooling дополнительно читать
`steam/AGENTS.md`, `steam/README.md`, ADR index и релевантные Accepted ADR.
