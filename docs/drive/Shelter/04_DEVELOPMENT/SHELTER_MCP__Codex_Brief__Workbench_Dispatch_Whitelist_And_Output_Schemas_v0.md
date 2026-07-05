# SHELTER MCP — Codex Brief — Workbench Dispatch Whitelist And Output Schemas v0

Дата: 2026-07-05
Статус: draft for Codex
Роль-владелец постановки: Game Designer / Systems Designer
Рекомендуемый уровень рассуждений Codex: высокий

---

## 0. Цель

Довести локальный Shelter MCP до состояния, соответствующего уже реализованному Steam/Desktop runtime contract после Codex-задачи `Dispatch confirmation Workbench capture path v0`.

Сейчас ChatGPT видит обновлённый набор MCP tools, включая:

```text
control_shelter_game
start_shelter_control_connector
stop_shelter_control_connector
list_shelter_upstreams
```

Но whitelist внутри `list_shelter_dev_commands` и `run_shelter_dev_command(workbench_capture)` всё ещё не знает новый scenario:

```text
first_delivery_with_dispatch_confirmation
```

и `control_shelter_game` всё ещё не знает action:

```text
runtime_delivery_confirm
```

или аналогичное MCP action id для endpoint:

```text
POST /control/runtime/delivery/confirm
```

Из-за этого новый Steam runtime path существует и smoke bundle валиден, но через MCP новый capture сейчас не запускается.

---

## 1. Репозитории и обязательные источники

Основной MCP repo:

```text
/Users/barsulka/GolandProjects/shelter/mcp
```

Основной Shelter repo:

```text
/Users/barsulka/GolandProjects/shelter/shelter
```

Перед началом прочитать:

- `/Users/barsulka/GolandProjects/shelter/mcp/README.md`
- `/Users/barsulka/GolandProjects/shelter/mcp/internal/sheltermcp/commands.go`
- `/Users/barsulka/GolandProjects/shelter/mcp/internal/sheltermcp/control.go`
- `/Users/barsulka/GolandProjects/shelter/mcp/internal/sheltermcp/server.go`
- `/Users/barsulka/GolandProjects/shelter/mcp/internal/sheltermcp/server_test.go`
- `/Users/barsulka/GolandProjects/shelter/mcp/internal/sheltermcp/workbench.go`
- `/Users/barsulka/GolandProjects/shelter/shelter/docs/repo/status/CODEX_STATUS.md`
- `/Users/barsulka/GolandProjects/shelter/shelter/docs/repo/dev/godot-state-connector.md`
- `/Users/barsulka/GolandProjects/shelter/shelter/docs/repo/api/godot-state-connector.openapi.yaml`

---

## 2. Required changes

### 2.1 Workbench scenario whitelist

Update MCP workbench scenario whitelist in:

```text
/Users/barsulka/GolandProjects/shelter/mcp/internal/sheltermcp/commands.go
```

Add:

```text
first_delivery_with_dispatch_confirmation
```

Expected behavior:

```sh
run_shelter_dev_command(
  command=workbench_capture,
  scenario=first_delivery_with_dispatch_confirmation,
  fixture=first_day_empty_coop,
  game_seconds=420,
  sample_every_game_seconds=10,
  speed=100,
  output_dir=.runtime/workbench_capture_runs/first_delivery_with_dispatch_confirmation_v0
)
```

should call:

```sh
cd /Users/barsulka/GolandProjects/shelter/shelter/steam
./tools/dev-vertical-slice.sh workbench-capture \
  --scenario=first_delivery_with_dispatch_confirmation \
  --fixture=first_day_empty_coop \
  --game-seconds=420 \
  --sample-every-game-seconds=10 \
  --speed=100 \
  --output-dir=.runtime/workbench_capture_runs/first_delivery_with_dispatch_confirmation_v0
```

and return success metadata.

### 2.2 Runtime control action whitelist

Update MCP control actions in:

```text
/Users/barsulka/GolandProjects/shelter/mcp/internal/sheltermcp/control.go
```

Add a narrow whitelisted action for:

```text
POST /control/runtime/delivery/confirm
```

Suggested MCP action id:

```text
runtime_delivery_confirm
```

Description:

```text
Confirm the accepted first Warm Food Delivery dispatch when runtime is already ready_to_dispatch.
```

Do not add generic mutation or broad cheat actions.

### 2.3 Output schemas for MCP tools

The ChatGPT interface reports that some Shelter MCP commands recommend adding output schemas.

Please add explicit output schemas for first-party Shelter MCP tools where supported by the Go MCP SDK version used in `/Users/barsulka/GolandProjects/shelter/mcp`.

Priority tools:

- `list_shelter_dev_commands` -> `ListDevCommandsOutput`
- `run_shelter_dev_command` -> `RunDevCommandOutput`
- `list_workbench_runs` -> `ListWorkbenchRunsOutput`
- `get_workbench_run_artifacts` -> `GetWorkbenchRunArtifactsOutput`
- `clear_workbench_runs` -> `ClearWorkbenchRunsOutput`
- `start_shelter_control_connector` -> existing output struct
- `stop_shelter_control_connector` -> existing output struct
- `control_shelter_game` -> `ControlShelterGameOutput`
- `list_shelter_upstreams` -> existing output struct

If the current SDK does not support explicit output schema on `mcp.Tool`, document that clearly in README/status and do not hack around it.

The task is accepted if the ChatGPT interface no longer warns about missing output schemas for the first-party Shelter MCP tools, or if Codex documents exactly why this cannot be implemented with the current SDK.

---

## 3. Out of scope

Codex must not:

- expose arbitrary shell execution;
- expose arbitrary Godot state mutation;
- broaden the dispatch action beyond the accepted first delivery confirmation;
- commit `.runtime` workbench bundles;
- change Steam gameplay/product design;
- claim visual/readability/player-feel acceptance from 100x JSON captures.

---

## 4. Acceptance criteria

### MCP command list

After restart/rebuild, ChatGPT `list_shelter_dev_commands` should show:

```text
scenario includes first_delivery_with_dispatch_confirmation
control_actions includes runtime_delivery_confirm or equivalent id
```

### MCP workbench run

This must succeed through MCP:

```text
command: workbench_capture
scenario: first_delivery_with_dispatch_confirmation
fixture: first_day_empty_coop
game_seconds: 420
sample_every_game_seconds: 10
speed: 100
output_dir: .runtime/workbench_capture_runs/first_delivery_with_dispatch_confirmation_v0
```

Expected proof in manifest:

```text
order.delivery_confirmed: true
order.postcard_visible: true
order.reward_available: true
game.chain_complete: true
production_chain.state: completed
production_chain.completed: true
event.player_confirmed_delivery: true
event.postcard_created: true
event.reward_created: true
```

### Control action

If a local connector is running, this should be accepted by MCP only in valid runtime state:

```text
control_shelter_game(action=runtime_delivery_confirm)
```

Invalid state should return a safe structured error from the runtime/connector, not mutate state.

### Existing scenarios still work

Regression scenarios must still be accepted:

```text
first_delivery_from_empty
warm_food_delivery_mid_chain
house_of_curiosity_learning_session
```

---

## 5. Checks

Run in MCP repo:

```sh
cd /Users/barsulka/GolandProjects/shelter/mcp
go test ./...
go test ./... -run Test
```

Run MCP manually as project docs describe, then from ChatGPT/MCP verify:

```text
list_shelter_dev_commands
run_shelter_dev_command workbench_capture first_delivery_with_dispatch_confirmation
get_workbench_run_artifacts first_delivery_with_dispatch_confirmation_v0 manifest.json run.log
```

Also run in Shelter repo if needed:

```sh
cd /Users/barsulka/GolandProjects/shelter/shelter/steam
./tools/dev-vertical-slice.sh workbench-capture \
  --scenario=first_delivery_with_dispatch_confirmation \
  --fixture=first_day_empty_coop \
  --game-seconds=420 \
  --sample-every-game-seconds=10 \
  --speed=100 \
  --output-dir=.runtime/workbench_capture_runs/_mcp_regression_first_delivery_dispatch
```

Do not commit `.runtime`.

---

## 6. Expected Codex final response

Codex should report:

- files changed in `/Users/barsulka/GolandProjects/shelter/mcp`;
- whether output schemas were added or why not;
- updated whitelist values;
- tests run;
- exact command/user steps to restart MCP;
- whether `first_delivery_with_dispatch_confirmation` can be run through ChatGPT MCP after restart.
