# SHELTER WORKFLOW — Codex Brief — Source-Derived MCP Context Bridge v1

Дата: 2026-07-15
Статус: `ACCEPTED / EXECUTABLE`
Владелец решения/brief: `Project Manager / Knowledge Base Maintainer`
Исполнитель: `Codex`
Рекомендуемый уровень рассуждений: `очень высокий`
Decision authority: `D-026 — MCP-first source-derived context bridge`
Relationship: `clarifies D-021 without rewriting D-021 history`
Technical handback source: Codex thread `019f6604-93cf-7313-ab63-abf0750ed60b`
Coordinator: Codex thread `019f654d-b532-7021-ab7d-9e1df10f79a0`

---

## 0. Goal

Сделать Shelter MCP дешёвым детерминированным source-derived мостом для routine
bootstrap/context routing новых AI-сессий:

```text
healthy MCP context bundle -> default routine bootstrap/context routing
local canonical Markdown -> authority and exact fallback
knowledge failure -> capability-local; runtime/capture/control stay available
```

Новый default tool:

```text
shelter_context_bundle(role, area, task, max_bytes)
```

Default budget: `24 KiB`. Hard cap: `64 KiB`.

Этот brief исправляет MCP/dev-tooling architecture. Он не меняет продукт, игру,
Godot runtime, gameplay, Art или capture contracts.

---

## 1. Authority and mandatory sources

Перед записью исполнитель обязан открыть напрямую из текущего checkout:

```text
PROJECTS_RULES.md
AGENTS.md
README.md
docs/repo/adr/README.md
docs/drive/Shelter/00_START_HERE/BOOTSTRAP_CONTEXT.md
docs/drive/Shelter/00_START_HERE/000_ROLE_CODEX.md
docs/drive/Shelter/00_START_HERE/02_DECISIONS.md — D-021 and D-026
docs/drive/Shelter/00_START_HERE/03_OPEN_QUESTIONS.md
docs/drive/Shelter/00_START_HERE/05_DOCUMENTATION_GOVERNANCE.md
docs/drive/Shelter/00_START_HERE/KNOWLEDGE_BASE_ROADMAP.md
docs/drive/Shelter/00_START_HERE/KNOWLEDGE_BASE_POLISH_ROADMAP.md
docs/repo/status/CODEX_CURRENT_STATUS.md
docs/drive/Shelter/04_DEVELOPMENT/CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md
docs/drive/Shelter/04_DEVELOPMENT/SHELTER_WORKFLOW__Codex_Brief__ChatGPT_Work_And_Local_MCP_Migration_v1.md
mcp/README.md
this brief
```

Также прочитать все релевантные `Accepted` ADR по dev tooling, MCP,
connector/runtime capability boundaries и подпроектным границам. При конфликте
brief с более высоким governing source остановиться, не угадывать и вернуть
точный конфликт Project Manager/Coordinator.

### Exact accepted decision

> MCP-first source-derived routine bootstrap; local source docs remain authority
> and exact fallback; knowledge failure is capability-local and must not disable
> runtime/capture/control.

Codex не принимает новую technical architecture: ниже уже зафиксирован exact
Technical/Codex handback. Любое отклонение требует отдельного решения.

---

## 2. Exact root cause to preserve in implementation/status handback

Read-only technical investigation установил:

1. `NewConfig()` глобально вызывает `validateKnowledgeCatalog()`; затем
   `main` завершает процесс через `log.Fatal` до server/tool registration.
2. Decision/open-question/roadmap/status/handoff/routing facts и SHA locks в Go
   являются вручную поддерживаемой второй памятью.
3. Current drift: D-022..D-025 отсутствуют; OQ-Steam-001/002 уже resolved в
   source, но active в catalog; Steam roadmap phase/next застыли на
   `First Week` / `R-28`.
4. `read_shelter_bootstrap_context` имеет default `120000` bytes; запрос
   `role=codex`, `area=mcp` пытается вернуть около `91955` bytes полных файлов.
5. Большой payload может дублироваться в `Content` и `StructuredContent`.
6. Focused server/runtime registration tests проходят, когда global knowledge
   gate обходится.

Technical blockers: `none`.

Текущий результат до этой реализации: MCP knowledge startup `RED / non-current`;
direct source reads остаются активным fallback. Это не означает, что
runtime/capture/control должны быть отключены по новой архитектуре.

---

## 3. Accepted technical architecture — exact scope contract

### 3.1 Source snapshot

1. Реализовать deterministic parse-on-request `KnowledgeSourceSnapshot` из
   канонических Markdown.
2. Snapshot содержит whole-file SHA и block SHA, stable ordering и
   `source_changed_during_read` guard.
3. Persistent/generated cache в v1 запрещён.
4. Static code может хранить только source paths, role/area/task routing и
   enum/path conventions.
5. Static current titles/status/summaries/current phase/next step/active IDs и
   их вручную поддерживаемые fingerprints запрещены.

### 3.2 Source-derived projections

Source-derived parsers должны покрыть необходимые проекции:

- document metadata;
- decisions;
- active open questions;
- roadmaps;
- current sections/excerpts;
- ownership/status;
- `HANDOFF_INDEX` and `SUPERSEDED_MAP`, когда они нужны routing projection.

Enabled legacy current-fact knowledge tools должны проецироваться из того же
source snapshot. Неперенесённый legacy knowledge tool explicit-fails; он никогда
не возвращает static stale facts.

### 3.3 New default bundle

Добавить:

```text
shelter_context_bundle(role, area, task, max_bytes)
```

Rules:

- default `max_bytes = 24576`;
- hard cap `65536`;
- budget считается по фактически encoded `StructuredContent`;
- deterministic stable ordering;
- text `Content` — только короткое human-readable сообщение/status;
- большой payload не дублируется в `Content`;
- omission/truncation/fallback указываются явно.

Required output surface:

```text
schema_version
health
role
area
task
current_truth
decisions
active_open_questions
roadmaps
ownership_status
read_next
sources: path, file_sha256, bytes
block_hashes
budget
fallback
errors
```

`current_truth` содержит exact source excerpts, а не AI summary.

### 3.4 Direct-source fallback contract

Bundle должен требовать direct source read только в этих случаях:

1. `health != current` или другой explicit fallback;
2. нужный content omitted/truncated;
3. нужен exact brief / Accepted ADR / normative contract;
4. conflict, malformed source или parser failure;
5. сессия собирается редактировать сам source document.

### 3.5 Capability isolation and atomic migration

`validateKnowledgeCatalog` удаляется из global startup только атомарно с
миграцией каждого enabled current-fact knowledge tool на SourceSnapshot
projection.

Knowledge parse/health failure не должен мешать инициализации, регистрации,
listing и использованию runtime/capture/control tools в той же server session.

Существующие tool names и schemas сохраняются. Legacy
`read_shelter_bootstrap_context` остаётся full-source fallback wrapper и не
используется как daily default.

---

## 4. Exact implementation scope

Разрешены изменения только в следующих implementation/config/doc files:

```text
mcp/internal/sheltermcp/config.go
mcp/internal/sheltermcp/server.go
mcp/internal/sheltermcp/response.go
mcp/internal/sheltermcp/knowledge_catalog.go
mcp/internal/sheltermcp/knowledge_validation.go
mcp/internal/sheltermcp/knowledge_tools.go
mcp/internal/sheltermcp/repo_tools.go — legacy bootstrap wrapper only
mcp/internal/sheltermcp/knowledge_source.go — new
mcp/internal/sheltermcp/context_bundle.go — new
mcp/internal/sheltermcp/config_test.go
mcp/internal/sheltermcp/server_test.go
mcp/internal/sheltermcp/knowledge_tools_test.go
mcp/internal/sheltermcp/repo_tools_test.go
mcp/internal/sheltermcp/*parser*_test.go or *context_bundle*_test.go — new as needed
.codex/config.toml
mcp/README.md
docs/repo/status/CODEX_CURRENT_STATUS.md
docs/drive/Shelter/04_DEVELOPMENT/CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md
```

Новый test filename можно выбрать в указанной папке, но production scope нельзя
расширять без stop/handback.

### Required ownership procedure

До первой записи:

1. выполнить `git status --short`;
2. объявить coordinator точный write scope;
3. сохранить все чужие/shared dirty changes;
4. остановиться при неожиданном concurrent drift в scope;
5. не stage/commit/push без отдельной явной команды интегратора.

---

## 5. Exact out of scope / no-touch

Запрещены:

```text
steam/**
Godot runtime/gameplay/capture/connectors
mcp/run.sh
CI workflows, unless a separately proven need is approved
go.mod
go.sum
new dependencies
global user config
secrets/credentials/env files
product/game/art/Steam implementation
generic filesystem tools
generic shell/search tools
AI summarization
embeddings/vector DB
network service/API
persistent/generated knowledge cache
```

Не запускать Godot. Не создавать gameplay/capture evidence.

---

## 6. Required implementation sequence

1. Зафиксировать parser/snapshot/bundle expectations тестами, включая negative
   source cases и exact current source assertions.
2. Реализовать parse-on-request `KnowledgeSourceSnapshot`, hashing, stable
   ordering и source-change guard.
3. Перенести все enabled legacy current-fact projections на SourceSnapshot.
4. Реализовать budgeted `shelter_context_bundle` и короткий text response.
5. Изолировать knowledge failures от server/runtime/capture/control
   registration в одной сессии.
6. Только после полной migration удалить global static-catalog startup gate и
   stale current-fact mirrors/fingerprints.
7. Синхронизировать project-scoped config, MCP README и current/status docs.
8. Выполнить весь acceptance/check matrix и вернуть exact handback.

Нельзя временно сделать server permissive, оставив enabled tools способными
вернуть stale static facts.

---

## 7. Acceptance criteria

### 7.1 Source truth

- D-022, D-023, D-024 и D-025 автоматически выводятся из current
  `02_DECISIONS.md`, без static Go mirror.
- OQ-Steam-001 и OQ-Steam-002 исключены как resolved; OQ-Steam-003 остаётся
  active.
- Roadmap phase/next и другие roadmap facts точно совпадают с каноническим
  Markdown на момент запроса; `First Week` / `R-28` не возвращаются как stale
  current state.
- Enabled legacy decision/OQ/roadmap/status/handoff/routing tools используют
  source snapshot projections.
- В Go не остаётся static current-fact mirror или manually maintained current
  fingerprint/SHA lock.

### 7.2 Determinism, provenance and budget

- Одинаковые sources и inputs дают byte-stable encoded bundle.
- Encoded `StructuredContent` не превышает requested budget и hard cap.
- Default 24 KiB и hard cap 64 KiB проверены тестами.
- Stable source/block ordering проверен.
- Каждый использованный source имеет path, file SHA-256 и byte count; relevant
  blocks имеют SHA-256.
- Text `Content` короткий и не содержит копию structured payload.
- Omission, truncation, fallback и errors явные и детерминированные.

### 7.3 Failure behavior

- Missing required source, malformed metadata/block, duplicate IDs и
  `source_changed_during_read` дают явный deterministic knowledge error.
- После knowledge error listing/registration runtime и capture/control tools
  успешно выполняется в той же server session.
- Legacy unmigrated knowledge projection explicit-fails и не возвращает stale
  data.
- Global process startup не зависит от current knowledge parse success.

### 7.4 Compatibility

- Existing enabled tool names/schemas сохранены.
- `read_shelter_bootstrap_context` остаётся legacy full-source fallback.
- `.codex/config.toml` остаётся project-scoped; generic fs/shell/network surface
  не появляется.
- Runtime/gameplay/capture/control implementation не изменён.

### 7.5 Documentation/status

- `mcp/README.md` описывает healthy bundle как daily default и direct-source
  exact fallback conditions.
- `CODEX_CURRENT_STATUS.md` и `CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md`
  показывают фактический PASS/RED, а не план как завершённый результат.
- Final handback сохраняет root cause, exact changes, tests/smokes, bundle byte
  counts/hashes, capability isolation result, files changed и remaining
  limitations; current status остаётся краткой текущей правдой.

---

## 8. Required checks — exact handback matrix

Все команды запускать из указанного cwd; записать exact command/result в final
handback и обновить current status только при изменении текущей правды.

### Go

Из `mcp/`:

```sh
go test ./...
go test -race ./...
go vet ./...
go build ./...
```

### Launcher/config/static checks

Из repo root:

```sh
sh -n mcp/run.sh
git diff --check
git diff -- steam/
```

`git diff -- steam/` должен быть пустым относительно pre-wave state. Наличие
чужих pre-existing changes не исправлять и не включать в handback как свои.

### Parser/bundle tests

Обязательны automated checks для:

```text
D-022..D-025 derived
OQ-Steam-001/002 excluded
OQ-Steam-003 active
roadmap exact
stable ordering
file and block hashes
default 24 KiB
hard cap 64 KiB
short text Content
no Content/StructuredContent payload duplication
missing/malformed/duplicate/source-changed failures
knowledge error followed by runtime/capture/control listing in same session
legacy projections source-derived
```

### STDIO and Codex smokes

1. STDIO initialize + tools/list from repo root through project launcher.
2. STDIO initialize + tools/list with `mcp/` as cwd.
3. Two real `shelter_context_bundle` smokes at `max_bytes=24576`:
   - `role=codex`, `area=mcp`, implementation task;
   - `role=project_manager`, `area=docs`, D-026/context-routing task.
4. Для каждого smoke записать encoded structured bytes, health, omissions,
   fallback, source file hashes и selected block hashes.
5. `codex mcp list`.
6. `codex mcp get shelter` (или exact configured Shelter server name, который
   должен быть записан в handback).
7. Actual non-interactive Codex call, который использует Shelter MCP bundle и
   подтверждает короткий text `Content` без дублирования payload.

No Godot launch.

---

## 9. Stop conditions

Немедленно остановиться и вернуть coordinator exact blocker, если:

1. требуется изменить файл вне exact scope;
2. требуется новый dependency, `go.mod/go.sum`, CI или `mcp/run.sh` change;
3. обнаружен конфликт D-026/brief с governing docs или Accepted ADR;
4. canonical Markdown нельзя разобрать детерминированно без нового authoring
   contract/product/process decision;
5. сохранить existing tool schemas невозможно без несовместимого breaking
   change;
6. capability isolation требует runtime/gameplay/capture/connector mutation;
7. обнаружен unexpected concurrent drift в owned files;
8. тест может пройти только через weakening/удаление acceptance или возврат
   stale static facts;
9. direct source truth противоречива и нельзя выбрать authority по governing
   order.

Не расширять scope самостоятельно. Не маскировать blocker новым fallback,
generic filesystem/search tool или generated cache.

---

## 10. Required final handback

Codex возвращает coordinator напрямую:

1. status: `PASS`, `PARTIAL` или `BLOCKED`;
2. exact changed files;
3. root cause и implemented architecture mapping к §3;
4. D-022..D-025, OQ и roadmap derivation evidence;
5. exact unit/race/vet/build/parser/STDIO/Codex smoke results;
6. два bundle byte-count/hash summaries;
7. same-session knowledge-failure/capability-isolation result;
8. confirmation: no static current-fact mirror/fingerprint remains;
9. confirmation: `git diff --check` PASS and Steam implementation diff empty
   relative to pre-wave state;
10. remaining blockers/limitations/open questions;
11. final SHA-256 of this brief as executed;
12. explicit note that no Godot launch and no stage/commit/push were performed,
    unless a later separate instruction changed Git ownership.

Implementation нельзя объявлять complete, пока весь §7 и §8 не пройден и
current/status docs не отражают фактический результат.
