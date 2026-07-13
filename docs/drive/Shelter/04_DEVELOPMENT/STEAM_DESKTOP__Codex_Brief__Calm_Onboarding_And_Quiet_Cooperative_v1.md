# STEAM_DESKTOP — Codex Brief — Calm Non-Modal Onboarding And Quiet Cooperative v1

Дата: 2026-07-12
Статус: prepared sequence brief / blocked by accepted Playable World + Labrador runtime foundation
Владелец исполнения: Codex, один write integrator
Владельцы контракта: Producer / Game Designer / Art Director / Technical
Roadmap: R48-04B, game-first order after R48-05
Рекомендуемый уровень рассуждений: **высокий**

---

## 0. Цель

Сделать первые действия First Day понятными через сам живой мир и Labrador/Dachshund activity, без modal tutorial wall, новых кликов или urgency; после Day 2 сохранить restart-stable Quiet Cooperative как спокойное наблюдаемое состояние.

## 1. Обязательные источники

- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__First_48_Hours_Playable_Scope_Lock_v1.md` и active roadmap;
- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__First_Day_MVP_v1.md`, `STEAM_DESKTOP__Task_Flow_Contract_v1.md`, `STEAM_DESKTOP__Object_Contract_v1.md` и `STEAM_DESKTOP__First_Week_Direction_v1.md` из той же product-папки;
- accepted result/evidence `docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Playable_World_And_First_Living_Dog_v1.md`;
- `docs/drive/Shelter/03_DESIGN/00_VISUAL_DIRECTION/D-011_Steam_Overlay_Main_Strip_v1_Rules.md`, `docs/drive/Shelter/03_DESIGN/00_VISUAL_DIRECTION/DOG_VISUAL_LANGUAGE_v1.md` и current Game Design/Art/Codex contexts;
- `docs/repo/adr/0002-game-state-as-source-of-truth.md` и `0003-player-profile-persistence-boundary-and-recovery.md`.

## 2. Scope

- one primary progression cue at a time;
- fresh entry: living strip + Road Sign/order cue + `Начать поездку`;
- dog-owned work объясняется action/object/world response, без required clicks;
- Van-ready состояние вызывает спокойный persistent `Отправить поставку` cue;
- First Day: Postcard/life moment и единственный required slippers-equip action;
- Day 2 не переигрывает tutorial;
- post-Day2 primary cue исчезает, остаются accepted persistent traces и bounded safe idle/wait/rest ambience;
- onboarding presentation читает existing runtime gates и ничего не auto-confirms.

## 3. Hard constraints / out of scope

- ровно First Day `3`, Day 2 `2` gameplay confirmations;
- no order-accept click, microtask clicks, auto-dispatch, deadline, streak, guilt, loss, flashing/pulsing urgency;
- no new mechanic, tutorial state machine, reward, content or Day 3;
- no background/minimize/performance acceptance in this wave;
- no modal wall, checklist или dismiss-to-proceed tooltip.

## 4. Definition of Done

- [ ] Новый игрок без текста-инструкции понимает первое meaningful action в живом runtime.
- [ ] В каждый момент максимум один primary progression cue.
- [ ] Dogs физически объясняют automatic chain; routine work требует ноль confirmations.
- [ ] Irreversible dispatch ждёт бессрочно и никогда не auto-confirms.
- [ ] First Day input budget остаётся `3`, Day 2 — `2`.
- [ ] Day 2 не повторяет First Day tutorial.
- [ ] Quiet Cooperative после Day 2 показывает calm bounded life и persistent traces без новых resources/rewards/progression.
- [ ] Restart возвращает тот же quiet state.
- [ ] Native 216/144/96 capture подтверждает cue hierarchy и action/object readability.
- [ ] Producer/Game Designer принимают no-obligation flow; Art Director принимает cue/motion hierarchy.
- [ ] First Day, Day 2, save/restart и Quiet Cooperative regressions зелёные.
- [ ] Текущие dev/status документы обновлены.

## 5. Ожидаемые зоны изменений

- current player presentation/UI composition;
- existing Vertical Slice visual cue/adaptor code;
- bounded player-journey tests/captures;
- Steam README и dev/status docs.

## 6. Stop conditions

Остановиться, если для читаемости нужно добавить новый required click, изменить task/order semantics, сделать cue обязательным modal gate, придумать новую ambient mechanic или затронуть platform/background policy.
