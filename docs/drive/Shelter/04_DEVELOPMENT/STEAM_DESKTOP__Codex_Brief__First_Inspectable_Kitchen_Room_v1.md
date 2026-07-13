# STEAM_DESKTOP — Codex Brief — First Inspectable Kitchen Room v1

Дата: 2026-07-12
Статус: prepared sequence brief / blocked by Playable World + Labrador and accepted Kitchen Art/UX surface contract
Владелец исполнения: Codex, один write integrator
Владельцы входных контрактов: Producer / Game Designer / Art Director / Technical
Roadmap: R48-A3 + R48-06
Рекомендуемый уровень рассуждений: **очень высокий**

---

## 0. Цель

Добавить одну inspectable Kitchen detail surface в тот же Godot runtime: игрок открывает живое место, видит фактическую собаку и существующую Kitchen station/activity, закрывает detail и не создаёт дублированной simulation или dog identity.

## 1. Activation gate

До activation gate прочитать `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__First_48_Hours_Playable_Scope_Lock_v1.md` и active roadmap, ADR-0001/0002/0003, Task Flow/Object/Vertical Slice contracts из product-папки, current Game Design/Art/Codex contexts, `docs/drive/Shelter/03_DESIGN/00_VISUAL_DIRECTION/STEAM_DESKTOP__World_And_Room_Asset_Vocabulary_v1.md` и accepted handback предыдущих двух game-first briefs.

- [ ] Playable World + First Living Labrador принят в обычном player journey.
- [ ] Art Director + Technical приняли exact same-window surface composition.
- [ ] Принят separable/reconstructable Kitchen shell с provenance, layers, bounds, pivots, foreground occlusion и entry/work/exit anchors.
- [ ] Game Design подтвердил: используется только existing Kitchen/CookTask state, без новой mechanic.
- [ ] Определено представление одной dog identity между strip/detail; одновременное противоречивое дублирование запрещено.
- [ ] Brief переведён в `accepted / executable`.

## 2. Минимальный flow

```text
accepted Kitchen world cue
→ optional player open
→ same live runtime state observed
→ one actual dog + one existing Kitchen station represented
→ empty/idle/busy/output presentation follows existing state
→ simulation continues
→ close detail
→ reopen preserves parity
```

## 3. Out of scope

- новые recipe/resource/task/assignment/state;
- needs, decor economy, upgrades, research, roster management;
- multiple rooms или native-window topology expansion;
- rocking chair/read/study/toy/social activities;
- synthetic occupancy из metadata/runtime scaffold;
- output/reward cadence;
- background/minimize/performance acceptance.

## 4. Definition of Done

- [ ] Kitchen открывается/закрывается обычным optional player interaction.
- [ ] Detail читает тот же authoritative Godot runtime; room-local simulator отсутствует.
- [ ] One actual dog presence/activity и one Kitchen station показаны точно.
- [ ] Dog identity не дублируется вопреки принятому representation contract.
- [ ] Simulation продолжается, пока detail открыт.
- [ ] Empty/idle/busy/output — только presentations existing state.
- [ ] Close/reopen и process restart сохраняют parity.
- [ ] Connector/assertion evidence не показывает divergence.
- [ ] `short_long` и `large_sturdy` clearance checks проходят, даже если активен только Labrador.
- [ ] Native 216/144/96 captures показывают room function/action без labels как единственного объяснения.
- [ ] First Day/Day 2/save/restart regressions зелёные.
- [ ] Art Director и Producer/Game Designer дали соответствующие visual/scope verdicts.
- [ ] Текущие dev/status документы обновлены.

## 5. Ожидаемые зоны изменений

- bounded Kitchen authored/imported assets;
- one Kitchen scene/detail surface;
- current player presentation/open-close input;
- runtime read-only room adapter/representation handshake;
- parity/clearance/capture tests и docs.

После принятия exact file list фиксируется перед записью через новый `git status`.

## 6. Stop conditions

Остановиться при missing room surface/art/occupancy/anchor contract, необходимости изобрести room-local state, synthetic occupancy, новой mechanic или второго окна без отдельного решения.
