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
- `shelter_context_bundle` as the routine source-derived bootstrap/context route;
- legacy full-source bootstrap fallback plus source-derived
  current-context/decision/open-question/roadmap/handoff/status tools.

Runtime commands выбираются по enum и фиксированным аргументам. Workbench paths
остаются внутри `steam/.runtime/workbench_capture_runs`; connector calls
ограничены loopback HTTP и whitelisted actions.

Read-only knowledge/inspection tools объявляют `readOnlyHint=true` и имеют
точечный project approval `approve`. Runtime-changing, lifecycle, clear и command
tools не auto-approved: для них сохранён `prompt`.

В коде также остаются bounded repo inspection/edit helpers для совместимости и
локальных тестов, но project Work profile их не включает: Codex работает с Git
и файлами checkout напрямую.

## Source-derived context bridge

При здоровых канонических Markdown routine entry начинается с:

```text
shelter_context_bundle(role, area, task, max_bytes)
```

Default budget — `24576` encoded bytes, schema minimum — `4096`, hard cap —
`65536`. Явный `max_bytes` ниже `4096` отклоняется MCP input validation как
invalid argument без `StructuredContent`; это не bundle с мнимым budget.
Значения выше hard cap детерминированно ограничиваются `65536`.

Bundle строится parse-on-request без generated/persistent cache, возвращает
exact current excerpts, source file SHA-256/byte counts и relevant block
SHA-256. Большой structured payload не дублируется в коротком text `Content`.
При missing/malformed/source-changed knowledge source и валидном budget tool
возвращает bounded deterministic error envelope с `health=error`, обязательным
direct-source fallback и фактическим fixed-point `budget.encoded_bytes` после
wire encoding. Error envelope не скрывает omission и не превышает requested
budget/hard cap.

`task` — только routing hint. Сервер без AI, free search и произвольных путей
классифицирует его по фиксированным keyword-категориям и меняет приоритет
конкретных source path/heading/item:

- implementation/remediation/code/test → текущий Codex status, implementation
  context и ADR index;
- decision/accepted/ADR/D-NNN → canonical decision index/blocks и ADR index;
- handoff/session/handback → HANDOFF_INDEX и доступный latest handoff;
- context/routing/bootstrap/knowledge → governance, bootstrap и KB roadmaps.

Полный маршрут всегда начинается mandatory bootstrap prefix:
`PROJECTS_RULES.md`, `AGENTS.md`, root `README.md`, `BOOTSTRAP_CONTEXT.md`.
При узком budget хвост prefix/route может быть явно удалён только вместе с
`budget.truncated`, `budget.omitted` и required fallback. Одинаковые source
bytes и input всегда дают одинаковый маршрут и bundle.

Legacy decision/OQ/roadmap/status/handoff/routing tools используют тот же
source snapshot. Статические current facts и вручную поддерживаемые knowledge
fingerprints отсутствуют. `read_shelter_bootstrap_context` сохранён только как
legacy full-source fallback, не как daily default.

Local source docs всегда остаются authority и exact fallback. Читать source
напрямую обязательно, когда bundle сообщает non-current/fallback, нужное
содержимое omitted/truncated, требуется exact brief / Accepted ADR / normative
contract, обнаружен conflict/parser failure или редактируется сам source.

Parser fail-closed отклоняет missing/malformed required sections, duplicate IDs,
непредставимый legacy decision kind и source changes during double-read. Он не
заявляет автоматическое распознавание смысловых governance-противоречий между
корректно оформленными authored fields: такие конфликты требуют синхронизации
канонических источников и прямой проверки source docs. До независимого D-026
reviewer PASS direct source остается активным routine fallback; daily-default
rollout bundle не считается принятым.

Canonical compound decision kinds детерминированно проецируются в совместимый
legacy enum `product|technical|process|documentation|ethics`; неотображаемый
kind explicit-fail, а не возвращается как новый неразрешённый enum.

Knowledge failure capability-local: knowledge tool возвращает явную ошибку,
но server startup, listing и runtime/capture/control tools той же сессии
остаются доступны.

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
