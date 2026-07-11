# Producer / PM Handoff — Day 2 scope lock and work wave

Дата: 2026-07-11
Роли: Producer / Project Manager / cross-role coordinator
Статус: handoff-history

## Что делали

- восстановили Steam/Desktop First Week / Day 2 context;
- получили независимые Producer, Game Designer, Art Director, Technical Animation, desktop-platform и external-reference reviews;
- пользователь принял рекомендованный Day 2 package;
- зафиксировали D-022, закрыли OQ-Steam-001/002 и подготовили canonical Codex brief;
- отдельно исследовали dog-animation pipeline и Shelter MCP usefulness without changing their product/runtime scope.

## Принятое решение

Следующий executable slice:

```text
Day 2 Return + одна полностью завершаемая вариация существующей Warm Food Delivery.
```

Обязательная граница:

- same `route.oat_farm_intro`, Basket Bicycle, resource family and stations;
- First Day postcard/slippers/memory/packing note remain visible;
- deterministic fixture/capture, not production save/calendar;
- full payload → unload → carry → Kitchen/Food Mix → Packing Table/Food Bag → LoadVan → player-confirmed dispatch → completed;
- one Labrador careful-packing cue inside existing PackTask;
- small progress note, then optional question `Как паковать мягче?`;
- no active habit/research/economy/quality/soft-choice system.

Preflight закрыл implementation-level неоднозначности без расширения product scope:

- fixture-local immutable `first_day_history` отделён от единственных active `active_order` / `active_chain` Day 2;
- Storage начинает Day 2 с deterministic existing stock `Protein Packet x1` + `Packaging Bag x1`; это fixture precondition, не replenishment/economy;
- существующий Day 2 `PackTask` детерминированно назначается Лабрадору;
- Trip/Unload/Carry/Cook/Pack/LoadVan/Delivery evidence параметризуется active `order_id`, при этом First Day regression остаётся неизменным;
- Day 2 completion не создаёт вторую postcard/reward/equip cadence: active Order наблюдает `delivery_complete`, показывает progress note на существующей Van-side board и только затем question на существующей Packing Table note;
- `sent` наступает после player-confirmed DeliveryTask, а `completed` — только после `delivery_complete`.

Decision source:

```text
docs/drive/Shelter/00_START_HERE/02_DECISIONS.md — D-022
```

## Canonical implementation brief

```text
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Day_2_Return_And_Second_Warm_Delivery_v1.md
```

Recommended Codex reasoning: `очень высокий`.

## Cross-role constraints retained

### Art / dog pipeline

- AI dog artifacts are `PREVIEW_RESEARCH_ONLY` and remain outside the repository.
- They prove morphology/QA workflow only; not production style, animation, alpha/import, bicycle/slippers or packing choreography.
- Day 2 reuses current semantic placeholders and does not choose Sprite2D/Skeleton2D/atlas/rig/schema.

### Desktop platform

- Full Windows/macOS coexistence gate does not block the narrow Day 2 proof.
- Day 2 must not change window semantics or claim shipping desktop readiness.
- Placement/recovery, DPI/hot-plug, focus/click-through, transparency fallback, long-idle thermal and Steam release trust remain a later cross-platform spike/gate.

### MCP

- Direct checkout remains default project truth.
- MCP remains useful only as an optional narrow runtime/capture/inspection adapter.
- A read-only benchmark found knowledge catalog drift and P0 trust candidates; validate them through the separate Codex Security scan before remediation.
- Current doc evolution intentionally makes the fail-loud MCP validator red until catalogs are reconciled or knowledge/runtime coupling is redesigned.

## Knowledge GC

Current Memory updated:

```text
BOOTSTRAP_CONTEXT.md
01_CURRENT_STATUS.md
STEAM_DESKTOP__CURRENT_CONTEXT.md
GAME_DESIGN__CURRENT_CONTEXT.md
CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md
CODEX_CURRENT_STATUS.md
```

Knowledge updated:

```text
02_DECISIONS.md
03_OPEN_QUESTIONS.md
STEAM_DESKTOP__First_Week_Direction_v1.md
STEAM_DESKTOP__Game_Design_Roadmap_v2.md
STEAM_DESKTOP__Task_Flow_Contract_v1.md
STEAM_DESKTOP__Object_Contract_v1.md
Day 2 Codex brief
```

History:

```text
this handoff
preview dog R&D outside repo
role/thread handbacks in ChatGPT Work
```

No old evidence/capture packs were promoted into Current Memory.

## Следующий лучший шаг

1. Codex implements the preflight-synchronized accepted Day 2 brief and returns runtime/visible evidence.
2. Game Designer/Producer review causality and completion; Art reviews only the concrete prototype cue/readability.
3. Keep the desktop coexistence spike and production dog-pipeline spike separate.
4. Continue the durable MCP deep security scan in a fresh cap-9 session; do not treat benchmark candidates as validated findings before that scan.
