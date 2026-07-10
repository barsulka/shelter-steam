# Handoff — ChatGPT Work and local Shelter MCP

Дата: 2026-07-10
Статус: handoff-history
Владелец: Codex
Назначение: зафиксировать завершённый локальный MCP setup и его технические границы.

## Результат

ChatGPT Work/Codex работает с текущим checkout напрямую. Shelter MCP находится
в `mcp/`, подключается project-scoped конфигурацией `.codex/config.toml` и
запускается локально по STDIO через `mcp/run.sh`.

## Tool boundary

Work-facing allowlist содержит только:

- whitelisted Shelter dev commands;
- Workbench capture inspection/management;
- local Godot connector/control lifecycle and accepted actions;
- bounded deterministic knowledge navigation.

Generic filesystem tools отсутствуют. Repo inspection/edit helpers остаются в
коде для совместимости и локальных тестов, но не публикуются Work profile.

## Monorepo semantics

Canonical и единственный repo id — `shelter`. Input `repo: "mcp"` отклоняется;
MCP-only scope задаётся paths под `mcp/`.

## Knowledge guardrail

При старте MCP валидирует IDs/statuses и full-block fingerprints decisions
и active open questions, fingerprints всех returned catalog fields, а также
exact roadmap status/current phase/next step against source Markdown. При drift
запуск останавливается; source documents всегда имеют приоритет.

Negative fixture tests доказывают failure при изменении decision
title/area/summary, open-question title/owner/summary и roadmap
status/current phase/next step.

## Approval boundary

Read-only knowledge/inspection tools имеют `readOnlyHint=true` и точечный
project `approval_mode = "approve"`. Runtime-changing, lifecycle, clear и command
tools остаются на `prompt`. Actual non-interactive `codex exec` из `mcp/`
успешно вызывает `shelter/get_decision` без command-line override.

## Проверки

Пройденный обязательный набор:

```text
cd mcp && go test -count=1 ./...
cd mcp && go test -race -count=1 ./...
cd mcp && go vet ./...
sh -n mcp/run.sh
STDIO initialize/tools-list smoke
launcher smoke from repo root and mcp/
actual codex exec get_decision smoke without approval override
knowledge tool checks
negative source/catalog drift tests
git diff --check
legacy-reference scan
git diff --name-only -- steam/
```

## Scope safety

Godot/runtime behavior, connector contract, product, game-design и art contracts
не менялись. Изменения сосредоточены в MCP/config и dev/project документации.

## Следующий шаг

Вернуться к отдельно утверждённому Day 2 / First Week product follow-up.
