# Codex Brief — ChatGPT Work and local Shelter MCP migration v1

Дата: 2026-07-10
Статус: implemented / verified
Владелец: Project Manager / Codex
Decision source: D-021
Рекомендуемый уровень рассуждений: **очень высокий**

## 1. Цель

Закрепить воспроизводимую локальную рабочую модель:

```text
ChatGPT Work / Codex
  -> direct local filesystem and Git access to this checkout

Shelter MCP in mcp/
  -> optional local STDIO domain-specific adapter
  -> whitelisted Shelter dev commands
  -> Godot runtime/capture inspection and explicit control
  -> bounded deterministic knowledge navigation
```

## 2. Обязательные источники

```text
PROJECTS_RULES.md
AGENTS.md
README.md
docs/drive/Shelter/00_START_HERE/BOOTSTRAP_CONTEXT.md
docs/drive/Shelter/00_START_HERE/02_DECISIONS.md — D-021
docs/drive/Shelter/00_START_HERE/05_DOCUMENTATION_GOVERNANCE.md
docs/drive/Shelter/04_DEVELOPMENT/CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md
docs/repo/status/CODEX_CURRENT_STATUS.md
docs/repo/adr/README.md
mcp/README.md
mcp/run.sh
mcp/internal/sheltermcp/**
```

ADR-0001/0002 запрещают менять Steam/runtime contracts в этой задаче.

## 3. Реализованный scope

### Local launcher and configuration

- `mcp/run.sh` выводит roots из checkout, собирает binary и запускает STDIO;
- optional loopback HTTP остаётся только для явной local debug команды;
- `.codex/config.toml` хранит переносимую trusted-project конфигурацию;
- global user config не меняется;
- tracked examples не требуют credentials;
- launcher не устанавливает global packages.

### Tool boundary

- сохранены whitelisted dev/runtime/capture/control tools;
- сохранена bounded knowledge navigation;
- generic filesystem tools отсутствуют;
- Work-facing `enabled_tools` не включает repo edit/git helpers;
- generic shell отсутствует.

### Monorepo semantics

- `mcp/` — подпапка того же Git repository;
- canonical repo id — `shelter`;
- input `repo: "mcp"` отклоняется с указанием использовать canonical repo и path `mcp/`;
- MCP-only diff задаётся paths под `mcp/`.

### Knowledge correctness

- D-021 присутствует в decision output;
- resolved `OQ-Docs-002` отсутствует в active output;
- latest handoff и Knowledge Base Polish Roadmap отражают текущую миграцию;
- startup/test validator защищает IDs/statuses и full-block fingerprints decisions/open questions, fingerprints всех returned catalog fields, а также exact roadmap status/current phase/next step;
- source documents всегда выигрывают при drift.

### Corrective audit pass

- read-only knowledge/inspection tools получили ToolAnnotations и explicit project `approval_mode = "approve"`;
- runtime-changing/destructive tools остались на default `prompt`;
- project launcher детерминированно находит monorepo root из root и `mcp/`;
- Current Memory и оба knowledge roadmap синхронизированы с completed D-021 state;
- obsolete setup references удалены из active и historical docs.

## 4. Out of scope

- gameplay/product/game-design/art decisions;
- изменения Godot/runtime behavior, state schema, connector/control contract,
  saves или snapshots;
- Browser/Mobile/shared-platform implementation;
- production deployment;
- global ChatGPT/Codex user config mutation;
- secrets и ignored local env content;
- новые production dependencies.

## 5. Acceptance criteria

- [x] Основная инструкция запуска — local STDIO from monorepo.
- [x] Local launcher не требует credentials или global package install.
- [x] Нет committed absolute user paths.
- [x] Project-scoped config использует официальный supported format.
- [x] Work-facing tool list domain-specific и lean.
- [x] Generic filesystem surface отсутствует.
- [x] Monorepo semantics explicit and tested.
- [x] D-021 visible; resolved OQ-Docs-002 absent.
- [x] Latest handoff and roadmap state corrected.
- [x] Source/catalog drift fails loudly.
- [x] Negative source-fixture tests cover decision/open-question content and all roadmap-state fields.
- [x] Non-interactive `codex exec` from `mcp/` calls `get_decision` without an approval override.
- [x] Read-only tools are auto-approved individually; state-changing tools are not globally auto-approved.
- [x] Active docs describe local Work/Codex + STDIO setup.
- [x] User-requested docs-only cleanup updated `steam/README.md`; no Steam code or runtime contract changed.
- [x] Required verification commands passed.
- [x] Steam diff confirms the task addition is documentation-only.

## 6. Required checks

```text
cd mcp && go test -count=1 ./...
cd mcp && go test -race -count=1 ./...
cd mcp && go vet ./...
sh -n mcp/run.sh
local STDIO MCP initialize/list-tools smoke
local launcher smoke from repository root and from mcp/
actual codex exec from mcp/ invoking get_decision without command-line approval override
knowledge checks for D-021, open questions, handoff and roadmap
negative source/catalog drift tests
git diff --check
legacy-reference scan
git diff -- steam/README.md
```

Не запускать Godot runtime/capture для доказательства этой задачи.

## 7. Stop conditions

Остановиться, если требуется изменить runtime/connector contract, добавить
production dependency/service, работать с secrets или менять product/game/art
meaning.

## 8. Changelog

### 2026-07-10 — corrective audit pass

- Closed P1 source/catalog content-drift gap and added negative fixtures.
- Closed P2 non-interactive approval and nested-cwd launcher gaps.
- Synchronized completed Current Memory/roadmap state.
- Removed remaining obsolete active and historical setup references.

### 2026-07-10 — implementation

- Added local launcher and project-scoped MCP config.
- Removed generic filesystem integration completely.
- Canonicalized monorepo semantics.
- Added source-catalog drift validation.
- Updated current docs/status and implementation handoff.
- Applied the user's explicit docs-only exception to remove obsolete setup text from `steam/README.md`.
