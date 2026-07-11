# Codex Brief — Shelter MCP GitHub Actions CI v1

Дата: 2026-07-11
Статус: ready for implementation
Владелец: Project Manager / Codex
Рекомендуемый уровень рассуждений: **средний**

## 1. Цель

Добавить минимальный, воспроизводимый GitHub Actions CI для локального Shelter MCP внутри монорепозитория, чтобы push и pull request автоматически проверяли Go-код, source/catalog drift guardrail и shell launcher без запуска Godot/runtime.

## 2. Обязательные источники

```text
PROJECTS_RULES.md
AGENTS.md
README.md
docs/drive/Shelter/00_START_HERE/000_ROLE_CODEX.md
docs/repo/adr/README.md
docs/repo/status/CODEX_CURRENT_STATUS.md
docs/drive/Shelter/04_DEVELOPMENT/CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md
mcp/README.md
mcp/go.mod
mcp/run.sh
mcp/internal/sheltermcp/knowledge_validation.go
mcp/internal/sheltermcp/knowledge_tools_test.go
```

ADR-0001 и ADR-0002 не требуют runtime-изменений в этой задаче, но их границы нельзя нарушать.

## 3. Scope

- создать GitHub Actions workflow для `push` и `pull_request`;
- использовать официальный поддерживаемый Go setup и версию Go из `mcp/go.mod`;
- запускать команды из `mcp/`:

```text
go test -count=1 ./...
go test -race -count=1 ./...
go vet ./...
go build ./cmd/shelter-mcp
```

- проверить launcher без запуска server/runtime:

```text
sh -n mcp/run.sh
```

- убедиться, что source/catalog drift tests выполняются внутри обычного `go test` и видят корень монорепозитория;
- задать least-privilege permissions, разумный timeout и отмену устаревшего запуска для той же ветки/PR;
- выбрать понятные path filters или обосновать запуск на всех изменениях; filters не должны пропускать изменения source docs, от которых зависит knowledge validator;
- обновить `mcp/README.md`, `docs/repo/status/CODEX_CURRENT_STATUS.md`, `docs/repo/status/CODEX_STATUS.md` и implementation context только в объёме, необходимом для фиксации CI.

Ожидаемая основная зона:

```text
.github/workflows/
mcp/README.md
docs/repo/status/
docs/drive/Shelter/04_DEVELOPMENT/CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md
```

## 4. Out of scope

- Godot/runtime, Steam gameplay, connector/control behavior, saves и snapshots;
- product/game/art decisions;
- deployment, releases, packaging и публикация binary;
- secrets, credentials, tunnel/network setup;
- изменение Shelter MCP tool surface или approval policy;
- новые production dependencies;
- generic filesystem или generic shell capabilities;
- автоматический commit/push из workflow.

## 5. Acceptance criteria

- [ ] Workflow валиден и находится в `.github/workflows/`.
- [ ] CI запускается на push и pull request для релевантных MCP/source-doc изменений.
- [ ] Go version берётся из `mcp/go.mod` или эквивалентно синхронизирована без ручного дублирования версии.
- [ ] Unit tests, race tests, vet и build выполняются успешно.
- [ ] Knowledge source/catalog drift tests реально входят в CI.
- [ ] `mcp/run.sh` проходит shell syntax check, но CI не запускает Godot/runtime/MCP control operations.
- [ ] Workflow использует read-only repository permissions и не требует secrets.
- [ ] Нет изменений под `steam/`, кроме случай, когда задача останавливается и возвращается PM как конфликт scope.
- [ ] Локальные проверки и `git diff --check` проходят.
- [ ] Dev status/docs обновлены кратко и без раздувания Current Memory.

## 6. Обязательные проверки

```text
cd mcp && go test -count=1 ./...
cd mcp && go test -race -count=1 ./...
cd mcp && go vet ./...
cd mcp && go build ./cmd/shelter-mcp
sh -n mcp/run.sh
git diff --check
git diff --name-only -- steam/
```

Если доступно безопасное локальное средство проверки синтаксиса/структуры GitHub Actions workflow без добавления production dependency, используй его. Не устанавливай глобальные инструменты только ради этого brief.

## 7. Stop conditions

Остановиться и вернуть вопрос Project Manager, если:

- CI требует секрет, write permission или внешний deployment service;
- для прохождения CI нужно менять Godot/runtime или product/game/art contract;
- выбранные path filters не могут надёжно охватить source docs knowledge validator;
- требуется новая production dependency;
- в целевой зоне обнаружены параллельные незавершённые изменения другого сеанса.

## 8. Handback

После выполнения отправить результат в исходный сеанс через `source_thread_id` и перечислить:

- созданный workflow и triggers;
- точные команды CI;
- изменённые документы;
- локальные проверки;
- ограничения, которые нельзя проверить до первого GitHub run;
- ссылку/статус первого run, если он появился без дополнительных внешних действий.

