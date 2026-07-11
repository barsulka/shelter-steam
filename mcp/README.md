# Shelter MCP

Локальный STDIO MCP-сервер для domain-specific Shelter Steam/Desktop dev
workflows. ChatGPT Work/Codex читает и изменяет checkout напрямую; MCP нужен
для whitelisted runtime/capture/control операций и bounded knowledge navigation.

Сервер не предоставляет generic shell или generic filesystem tools.

## Recommended setup

Repository-scoped конфигурация уже хранится в:

```text
.codex/config.toml
```

Для trusted checkout её совместно используют ChatGPT desktop, Codex CLI и IDE
extension. Глобальный `~/.codex/config.toml` менять не нужно.

Config находит monorepo root через Git, поэтому одинаково работает при
запуске Codex из корня и из `mcp/`.

Проверка конфигурации:

```sh
codex mcp get shelter
codex mcp list --json
```

После первого подключения/изменения MCP-конфигурации перезапустите клиент или
extension. В ChatGPT desktop/Codex список подключённых серверов доступен через
MCP settings или `/mcp`.

## Local launcher

Из корня монорепозитория:

```sh
./mcp/run.sh
```

Из `mcp/`:

```sh
./run.sh
```

Launcher выводит корни из текущего checkout, собирает локальный бинарник в
`mcp/.runtime/bin/` и запускает STDIO transport. Credentials и внешние процессы
для обычного запуска не требуются.

Optional local HTTP debug mode:

```sh
./mcp/run.sh --http 127.0.0.1:8090
```

## Build and test

```sh
cd mcp
go test ./...
go vet ./...
go build -o .runtime/bin/shelter-mcp ./cmd/shelter-mcp
```

## GitHub Actions CI

`.github/workflows/shelter-mcp-ci.yml` runs on every `push` and
`pull_request`. It intentionally has no path filters: source Markdown used by
the knowledge source/catalog validator lives outside `mcp/`, and CI must not
miss source-only drift.

The workflow uses the Go version declared in `mcp/go.mod` and runs:

```text
go test -count=1 ./...
go test -race -count=1 ./...
go vet ./...
go build ./cmd/shelter-mcp
sh -n mcp/run.sh
```

It has read-only repository permissions, does not require secrets and does not
start the launcher, Godot runtime or MCP control operations. The first GitHub
run remains the remote verification point for runner/action availability.

## Root resolution

По умолчанию server находит checkout по структуре:

```text
<repo>/mcp/go.mod
<repo>/steam/
```

Локальные overrides нужны только для нестандартного запуска:

```sh
export SHELTER_MCP_REPO_ROOT=/path/to/shelter
export SHELTER_STEAM_ROOT=/path/to/shelter/steam
```

Оба root должны оставаться внутри одного checkout.

`repo: "shelter"` — единственный repo id. Для MCP-only diff передавайте paths
под `mcp/`. Input `repo: "mcp"` отклоняется с явной подсказкой, потому что
отдельного MCP repository semantics нет.

## Work-facing tools

Project config публикует только domain-specific инструменты:

- `list_shelter_dev_commands`, `run_shelter_dev_command`;
- `list_workbench_runs`, `get_workbench_run_artifacts`,
  `clear_workbench_runs`;
- `start_shelter_control_connector`, `stop_shelter_control_connector`,
  `control_shelter_game`;
- bounded bootstrap/current-context/decision/open-question/roadmap/handoff/status
  knowledge tools.

Runtime commands выбираются по enum и фиксированным аргументам. Workbench paths
остаются внутри `steam/.runtime/workbench_capture_runs`; connector calls
ограничены loopback HTTP и whitelisted actions.

Read-only knowledge/inspection tools объявляют `readOnlyHint=true` и имеют
точечный project approval `approve`. Runtime-changing, lifecycle, clear и command
tools не auto-approved: для них сохранён `prompt`.

В коде также остаются bounded repo inspection/edit helpers для совместимости и
локальных тестов, но project Work profile их не включает: Codex работает с Git
и файлами checkout напрямую.

## Knowledge source guardrail

Source Markdown всегда имеет приоритет над compact MCP output.

При запуске server валидирует:

- D-xxx IDs/statuses и fingerprints полных source-блоков against `02_DECISIONS.md`;
- active OQ IDs/statuses и fingerprints полных source-блоков against `03_OPEN_QUESTIONS.md`;
- fingerprints всех возвращаемых decision/open-question catalog fields;
- exact roadmap `status`, `current phase` и `next step` against authoritative source blocks;
- current handoff path;
- наличие cataloged roadmap/handoff sources.

При расхождении запуск завершается с `knowledge catalog drift` вместо выдачи
тихо устаревшего digest. Те же проверки покрыты unit tests.
Отрицательные fixtures меняют title/area/summary, owner и каждое roadmap-state
поле и требуют loud failure.

## Manual STDIO smoke

```sh
{
  printf '%s\n' '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-06-18","capabilities":{},"clientInfo":{"name":"shelter-smoke","version":"1.0"}}}'
  sleep 1
  printf '%s\n' '{"jsonrpc":"2.0","method":"notifications/initialized"}' '{"jsonrpc":"2.0","id":2,"method":"tools/list","params":{}}'
  sleep 2
} | ./mcp/run.sh
```

Ожидаются успешные `initialize` и `tools/list`; в списке не должно быть generic
filesystem tools.
