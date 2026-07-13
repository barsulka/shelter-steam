# STEAM_DESKTOP — Codex Brief — First Day + Day 2 Player Journey Polish And Acceptance v1

Дата: 2026-07-12
Статус: prepared final game-first brief / blocked by Labrador, onboarding and Kitchen waves
Владелец исполнения: Codex, один write integrator
Владельцы acceptance: Producer / Game Designer / Art Director / Codex / PM
Roadmap: R48-07 game-first acceptance
Рекомендуемый уровень рассуждений: **очень высокий**

---

## 0. Цель

Отполировать ровно два принятых пользовательских визита как один честный normal-speed player journey и собрать единый acceptance pack. Не добавлять Day 3, новые системы или platform/background работу в критический путь.

## 1. Required journey

Перед исполнением прочитать `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__First_48_Hours_Playable_Scope_Lock_v1.md` и active roadmap, ADR-0001/0002/0003, current Game Design/Art/Codex contexts и accepted handbacks всех трёх предшествующих game-first briefs.

```text
fresh profile → ordinary F5/play.sh → First Day at 1x
→ exactly 3 gameplay confirmations → first delivery/traces → autosave/close
→ ordinary Continue → Day 2 with preserved traces
→ optional Kitchen inspect/open/close → exactly 2 gameplay confirmations
→ second delivery → progress note/optional question → Quiet Cooperative
→ close/reopen → same consistent world
```

## 2. Scope

- pacing/readability polish only inside accepted two visits;
- transition/cue/camera/animation timing fixes that do not change task semantics;
- consistency of authored world, Labrador identity, object contact, persistent traces and Kitchen parity;
- native 1x full-journey evidence and regression matrix;
- honest internal readiness label.

## 3. Out of scope

- Day 3+, First Week/Month expansion;
- new order/route/resource/station/dog recruitment;
- full dog vocabulary or second living dog requirement;
- monetization/charity prompts;
- Steam integration/release packaging;
- Windows certification;
- 30–60 minute background/minimize/performance acceptance — deferred separate wave after game-first critical path;
- MCP/security/tooling expansion unless it directly blocks this journey.

## 4. Definition of Done

- [ ] Весь journey пройден без terminal, fixture, connector action или manual state edit.
- [ ] First Day/Day 2 проходят at normal 1x with exact `3 + 2` gameplay confirmations.
- [ ] Authored world, living Labrador и optional Kitchen работают в одном runtime.
- [ ] Postcard/slippers/memory/packing note переживают return/restart.
- [ ] Kitchen detail сохраняет runtime parity и не дублирует dog identity.
- [ ] Quiet Cooperative restart-stable и не создаёт Day 3/resources/rewards/progression.
- [ ] Player capture не содержит debug UI/geometry/state labels.
- [ ] Full 33-cursor, restart/SIGKILL, failed-save Retry, corrupt/incompatible recovery, First Day and Day 2 regressions green.
- [ ] Native 216/144/96 still/motion evidence принято Art Director на заявленном prototype level.
- [ ] Producer/Game Designer приняли influence-without-obligation и два визита.
- [ ] macOS internal export smoke green.
- [ ] Build честно маркирован `macOS-only internal First Day + Day 2 playable (session-based continuation, prototype visual level; not Steam/release ready)`.
- [ ] Background/minimize/performance остаётся отдельным незакрытым gate и не маскируется acceptance claim.
- [ ] Current Memory, `steam/README.md`, `CODEX_STATUS.md` и handoff обновлены.

## 5. Ожидаемые зоны изменений

- только уже затронутые player/world/Labrador/onboarding/Kitchen presentation files;
- bounded tests/capture manifests/evidence docs;
- current/status/readme/handoff docs.

## 6. Stop conditions

Остановиться, если polish требует новой mechanic/content/art taxonomy, изменения `3 + 2`, нарушения persistence/runtime authority, production-art claim или возвращения background/minimize work в критический путь.
