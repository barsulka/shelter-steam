# STEAM_DESKTOP — Vertical Slice Playtest Report v1

Дата: 2026-06-29
Роль: Game Designer / Producer capture-based playtest review
Статус: capture-based review complete; final live timing review still required
Продукт: Steam/Desktop idle always-on-top strip

Основано на:

- `STEAM_DESKTOP__Vertical_Slice_Playtest_Checklist_v1.md`
- `STEAM_DESKTOP__Vertical_Slice_Scope_Lock_v1.md`
- `STEAM_DESKTOP__Vertical_Slice_Contract_v1.md`
- `STEAM_DESKTOP__Object_Contract_v1.md`
- `STEAM_DESKTOP__Task_Flow_Contract_v1.md`
- `docs/repo/dev/steam-vertical-slice-prototype.md`
- `docs/repo/status/CODEX_STATUS.md`
- `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_VERTICAL_SLICE_ART_QA_CAPTURE_v1/README.md`
- `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_VERTICAL_SLICE_ART_QA_CAPTURE_v1/CAPTURE_MANIFEST_v1.md`

Проверенный capture pack:

```text
docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_VERTICAL_SLICE_ART_QA_CAPTURE_v1/
```

Сборка / branch: `master`, по `docs/repo/status/CODEX_STATUS.md`
Кто проверял: Producer / Game Designer session
Формат проверки: review по named screenshots, PNG-frame sequence fallback, manifest и dev/status docs

## Общий verdict

**NEEDS LIVE TIMING REVIEW BEFORE FINAL ACCEPTANCE**

Capture-based review показывает, что Vertical Slice в основном соответствует locked scope и доказывает обязательную цепочку на уровне структуры, cause-and-effect и prototype implementation evidence.

Но финальный verdict `ACCEPTED FOR NEXT DESIGN STEP` пока ставить нельзя, потому что capture pack был снят в `fast deterministic capture timings`, а PNG-frame sequence не является real-time recording. Ключевое ощущение Steam/Desktop Shelter — “хочется оставить маленький живой собачий кооператив жить внизу экрана рядом с рабочим столом” — требует отдельного normal-speed visible review.

## 1. Scope compliance

Оценка: **PASS по capture/docs**

Наблюдения:

- Используется один маршрут: `Овсяная ферма` / `route.oat_farm_intro`.
- Используется один транспорт: Basket Bicycle.
- Используются две собаки: Dachshund / Такса и Labrador / Лабрадор.
- Используется один order: `Первая тёплая поставка`.
- Используется одна reward/equipment: `Удобные тапочки`.
- Capture manifest не показывает третью собаку, второй маршрут, room-lite, Decor Workshop, research tree, monetization, Browser Extension UI, crop farming, combat, PvP, bosses, monsters, gacha или FOMO.

Проблемы: нет.

Proposed fix: не требуется.

## 2. Первое понимание игрока

Оценка: **PARTIAL**

Наблюдения:

- Order Card и Route Card присутствуют и передают базовую цель: собрать поставку, отправить таксу на Овсяную ферму, получить овёс и тыкву.
- Route Card показывает маршрут, транспорт, собаку и expected result.
- Кнопка `Отправить` не выглядит как покупка, реклама или срочный таймер.
- По screenshot `01_initial_strip.png` видна проблема prototype layer: debug labels и developer overlay помогают понять сцену как reviewer, но могут мешать первому player-facing впечатлению.

Проблемы:

- По capture нельзя окончательно понять, насколько первый игрок без контекста считывает Road Sign как physical route anchor, а не как подпись/debug marker.
- UI и debug cards сейчас помогают comprehension, но рискуют сдвигать восприятие в сторону prototype-dashboard.

Proposed fix без расширения scope:

- В normal-speed review проверить сцену с semantic labels off.
- Уточнить текст Order/Route Card так, чтобы первый шаг был понятен без debug overlay.
- Не добавлять tutorial system, новый экран обучения или дополнительные сущности до финальной приёмки loop.

## 3. Route and trip feeling

Оценка: **PARTIAL**

Наблюдения:

- Capture set включает Dachshund moving to Basket Bicycle, bicycle departure, trip state и return payload.
- Транспорт физически уезжает за край strip и возвращается.
- Trip state описан как calm, без red-alert и urgency.

Проблемы:

- Из-за fast deterministic timings нельзя оценить реальное ожидание поездки.
- Нельзя окончательно оценить, выглядит ли мир живым, пока такса в поездке.
- Idle-поведение лабрадора и общая “жизнь” в паузах требуют live review.

Proposed fix без расширения scope:

- Провести visible normal-speed run.
- Проверить, есть ли у лабрадора и мира спокойное idle/waiting поведение во время поездки.
- Не чинить trip feeling добавлением второго маршрута или новых активностей.

## 4. Physical resources

Оценка: **PASS / PARTIAL**

Наблюдения:

- Capture manifest показывает returned payload, unload to Storage, Storage to Kitchen carry, Food Mix to Packing, Food Bag to Van.
- Implementation doc фиксирует events `payload_visible`, `resource_added_to_storage`, `resource_delivered_to_kitchen`, `food_mix_created`, `food_bag_created`, `van_loaded`.
- Forbidden shortcut “TripTask directly adds Oat/Pumpkin to Storage” по документам не используется: Storage inventory updates after visible placement.

Проблемы:

- На capture уровне physicality подтверждена структурно, но качество читаемости отдельных resource tokens остаётся prototype-level.
- Food Mix и Food Bag используют temporary/composite-backed placeholder, что допустимо для прототипа, но не должно считаться final art/readability.

Proposed fix без расширения scope:

- Сохранить текущую cause-and-effect цепочку как обязательную.
- В Art QA отдельно усилить различимость Oat Crate, Pumpkin Crate, Food Mix и Food Bag.
- Не заменять ресурсы UI-числами.

## 5. Production chain readability

Оценка: **PASS / PARTIAL**

Наблюдения:

- Chain присутствует целиком: Storage -> Kitchen -> Food Mix -> Packing Table -> Food Bag -> Van.
- Kitchen не создаёт Food Bag напрямую.
- Packing Table не пропущен.
- Van становится ready после Food Bag load.
- Delivery ждёт player confirmation.

Проблемы:

- Kitchen work и Packing Table work визуально минимальны.
- Packing Table является debug Utility Prop placeholder; нужен Art Director verdict, чтобы не превратился в “домик” или слишком абстрактную доску.
- По still frames трудно оценить, насколько work-state читается как действие, а не как смена labels.

Proposed fix без расширения scope:

- Укрепить visual states Kitchen/Packing через короткие dog action poses или простые readable work frames.
- Не добавлять новые stations, recipes или production systems.

## 6. Dogs first

Оценка: **PARTIAL**

Наблюдения:

- Dogs физически участвуют в route, unload, carry, production support и delivery loading.
- Такса имеет driver role, лабрадор helper role.
- Actions are represented in capture moments, not only in UI.

Проблемы:

- По capture видно, что dog silhouettes and action sprites remain prototype placeholders.
- Есть риск, что игрок смотрит на labels/cards больше, чем на собак.
- Финальное “они правда сделали работу” нельзя надёжно оценить без live timing и readable dog animation.

Proposed fix без расширения scope:

- Приоритет следующего art/design pass: dog action readability before object decoration.
- Проверить labels off: читаются ли собаки и действия без semantic подпорок.
- Не чинить Dogs First через добавление третьей собаки или room-lite.

## 7. Player agency

Оценка: **PASS**

Наблюдения:

- Игрок запускает route одним meaningful action.
- После route start мир сам создаёт unload/carry/cook/pack/load tasks.
- Игрок не подтверждает каждую микрозадачу.
- Игрок подтверждает meaningful delivery moment.
- Dog Card и Hide/Show существуют.

Проблемы: нет по capture/docs.

Proposed fix: не требуется.

## 8. UI quietness

Оценка: **PARTIAL**

Наблюдения:

- Order Card, Route Card, Dog Card и Postcard присутствуют.
- Нет paid affordances, urgent countdown, guilt warnings или hard red pressure.
- Hide UI и Show UI присутствуют.
- `16_hide_ui_world_visible.png` проверяет, что мир остаётся видимым при скрытом UI.

Проблемы:

- В текущем capture UI/debug слой заметен и может доминировать над strip.
- Right debug/contract overlay полезен для QA, но player-facing сборка должна быть спокойнее.
- Нужна проверка labels off и debug overlay off.

Proposed fix без расширения scope:

- Для следующей human review использовать режим без semantic labels и без debug overlay, кроме отдельного QA-прогона.
- Не добавлять full-screen menu или tutorial overlay.

## 9. D-010: innate trait vs equipment

Оценка: **PASS**

Наблюдения:

- Dog Card показывает `Innate trait: Быстрые лапки`.
- Equipment до награды пустой или отдельный.
- Reward `Удобные тапочки` появляется после postcard/reward moment.
- После equip Dog Card показывает innate trait и equipment отдельно.
- Equipment не заменяет innate trait.

Проблемы:

- Comfortable Slippers визуально остаются placeholder icon/state, не production art.

Proposed fix без расширения scope:

- Сохранить D-010 separation как обязательный UX pattern.
- Арту подготовить readable slippers icon later; не превращать Dog Card в RPG stat sheet.

## 10. Delivery tone

Оценка: **PASS / PARTIAL**

Наблюдения:

- Delivery ждёт player confirmation после loading Food Bag.
- Нет visible urgency / guilt / red-alert tone in capture pack.
- Postcard/reward moment есть.

Проблемы:

- Точный текст postcard и эмоциональный тон требуют отдельного text review в player-facing режиме.
- Нужно убедиться, что благодарность не звучит как обязанность или pressure.

Proposed fix без расширения scope:

- Проверить postcard copy отдельно.
- Использовать спокойную благодарность без “если бы не вы”, “срочно”, “не подведите”.

## 11. Calm idle and desktop companion feeling

Оценка: **NOT FINAL / PARTIAL**

Наблюдения:

- Strip низкая, bottom-hugging, с большим empty upper space.
- Hide UI позволяет оставить мир видимым.
- Capture не показывает тревожных сигналов или punishment.

Проблемы:

- Это главный незакрытый пункт: capture uses fast deterministic timings.
- Нельзя окончательно проверить, хочется ли оставить игру открытой внизу экрана.
- Нельзя оценить нормальный rhythm: ожидание, idle, темп carry/cook/pack, частоту UI внимания.

Proposed fix без расширения scope:

- Провести visible normal-speed review через:

```sh
cd steam
tools/dev-vertical-slice.sh
```

- Проверить 8–10 минут ощущения без debug/capture speed.
- Не чинить calm idle добавлением progression systems, timers, rewards или FOMO.

## 12. Readability at strip scale

Оценка: **PARTIAL**

Наблюдения:

- Road Sign, Storage, Kitchen, Packing Table, Van и Basket Bicycle представлены в strip.
- Main strip remains low and bottom-hugging.
- UI hidden state сохраняет world visibility.

Проблемы:

- Debug labels сейчас существенная часть readability.
- Production art missing for Packing Table, separate resources, dog action sprites, postcard and slippers.
- Нужно отдельно подтвердить 216 / 144 / 96 px readability.

Proposed fix без расширения scope:

- Art Director review должен дать verdict по readability и placeholder acceptability.
- Game Designer live pass должен проверить labels off.
- Не увеличивать strip до полноценной интерьерной сцены.

## Ключевые проблемы

1. **No final timing verdict:** capture pack снят в fast deterministic timings.
2. **Dogs-first пока не доказан финально:** dog actions есть структурно, но silhouettes/action sprites остаются prototype placeholders.
3. **Readability depends on labels:** semantic/debug labels полезны для QA, но player-facing scene должна читаться без них.
4. **Kitchen/Packing work-state minimal:** chain exists, но work moments могут быть слишком условными.
5. **UI/debug dominance risk:** QA overlay и labels могут временно перетягивать внимание с собак.

## Design fixes без расширения scope

Разрешённые fixes:

- normal-speed visible review;
- выключить semantic/debug labels для player-facing pass;
- усилить dog action readability;
- уточнить compact UI copy;
- улучшить Kitchen/Packing readable work states;
- улучшить distinctness of physical resource tokens;
- проверить postcard tone;
- сохранить Hide/Show и world-alive state.

## Что нельзя добавлять как fix

Нельзя чинить текущие проблемы через:

- второй маршрут;
- третью собаку;
- room-lite / Dog Corner;
- Decor Workshop;
- research tree;
- route reward tables;
- long-term economy balancing;
- real shelter integrations;
- charity reporting;
- donations;
- subscriptions;
- ads;
- Browser Extension UI;
- visible crop farming in Steam;
- combat, PvP, bosses, monsters, gacha, FOMO.

## Следующий лучший шаг

1. Art Director completes capture-based Art QA using `STEAM_VERTICAL_SLICE_ART_QA_CAPTURE_v1`.
2. Codex or human tester runs visible normal-speed Vertical Slice without capture fast timing.
3. Game Designer performs final live timing pass against `STEAM_DESKTOP__Vertical_Slice_Playtest_Checklist_v1`.
4. Only after live timing pass decide between:
   - `ACCEPTED FOR NEXT DESIGN STEP`; or
   - `NEEDS DESIGN FIXES BEFORE EXPANSION`.

## Current acceptance state

| Area | Capture-based status |
|---|---|
| Scope compliance | PASS |
| First player understanding | PARTIAL |
| Route and trip feeling | PARTIAL |
| Physical resources | PASS / PARTIAL |
| Production chain readability | PASS / PARTIAL |
| Dogs first | PARTIAL |
| Player agency | PASS |
| UI quietness | PARTIAL |
| D-010 | PASS |
| Delivery tone | PASS / PARTIAL |
| Calm idle | NOT FINAL / PARTIAL |
| Readability | PARTIAL |

Final acceptance is blocked only by human visible timing/feeling review, not by known scope violation.
