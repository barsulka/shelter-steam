# STEAM_DESKTOP — Runtime Review — First Delivery Capture v0

Дата: 2026-07-03
Роль: Game Designer / Systems Designer
Статус: review зафиксирован

## Runs

Проверены workbench capture bundles:

- `steam/.runtime/workbench_capture_runs/first_delivery_from_empty_v0/`
- `steam/.runtime/workbench_capture_runs/first_delivery_from_empty_300_v1/`

Основной run для вывода: `first_delivery_from_empty_300_v1`.

Параметры:

```text
scenario: first_delivery_from_empty
fixture: first_day_empty_coop
game_seconds: 300
sample_every_game_seconds: 10
speed: 100
snapshots: 30
events: 61
status: success
```

## Result

Workbench Runtime Capture Harness v0: **PASS** для Game Designer state-review.

First Delivery runtime chain: **PASS до `ready_to_dispatch`**.

Финальная точка 300s run:

```text
order.status: loaded
order.delivery_state: ready_to_send
order.van_loaded: true
order.delivery_confirmed: false
order.postcard_visible: false
order.reward_available: false
order.next_expected_player_action: подтвердить отправку
production_chain state: ready_to_dispatch
current_step: player_confirms_dispatch
blocked_reason: waiting_for_player_confirmation
```

Это ожидаемая calm wait точка, а не ошибка: текущий scenario не делает игроковое подтверждение отправки.

## Confirmed flow

Runtime events подтверждают цепочку:

```text
route started
transport left/returned
payload visible
unload tasks created
resources added to storage
carry tasks to kitchen
kitchen inputs ready
food mix created
carry tasks to packing
packing inputs ready
food bag created
load van task created
van loaded
ready_to_dispatch
```

## Stress signals summary

Финальные сигналы:

```text
blocked_states_recent: 0
chains_with_invisible_conversion: 0
dogs_without_identity_fields: 0
dog_action_events_recent: 3
production_events_recent: 40
raw_inventory_growth_recent: 4
room_activity_events_recent: 0
story_events_recent: 0
```

PASS:

- invisible conversion не обнаружен;
- dog identity fields присутствуют;
- production flow физически представлен через route / unload / carry / cook / pack / load van;
- ready_to_dispatch корректно требует player confirmation.

WATCH:

- debug tick events шумят в event log;
- `dog_action_events_recent` низковат относительно production events;
- room/story/life evidence не проверяется этим scenario.

## Next follow-up

Нужен Codex follow-up: добавить accepted dispatch-confirmation path для capture.

Варианты:

1. Узкий whitelisted runtime action для подтверждения первой отправки.
2. Новый scenario `first_delivery_with_dispatch_confirmation`, который проходит до `ready_to_dispatch`, подтверждает отправку и доснимает postcard/reward/chain_complete.

Acceptance target для следующего review:

```text
order.delivery_confirmed: true
order.postcard_visible: true
order.reward_available: true
game.chain_complete: true
production chain state: completed
```
