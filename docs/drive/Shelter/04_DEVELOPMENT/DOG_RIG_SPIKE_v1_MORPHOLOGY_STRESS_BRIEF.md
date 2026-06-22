# DOG_RIG_SPIKE v1 — Morphology Stress Test Brief

Дата: 2026-06-29
Роль документа: Development / Technical Art Spike Brief
Статус: ready for Codex

Связано с:

- `docs/drive/Shelter/04_DEVELOPMENT/DOG_RIG_SPIKE_v0_BRIEF.md`
- `docs/repo/dev/dog-rig-spike.md`
- `docs/drive/Shelter/03_DESIGN/00_VISUAL_DIRECTION/DOG_RUNTIME_AND_ANIMATION_GRAMMAR_v1.md`
- `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/DOG_DNA_SCHEMA_v0.md`

## 1. Контекст

Dog Rig Spike v0 прошёл как qualified native pass: одна собака собирается из модульных Godot node parts, держит food bag через socket, использует процедурные слои `tail_wag`, `head_look`, `ear_bounce` и читает Dog DNA из JSON.

Но v0 ещё не доказал главный риск:

> одна и та же animation grammar должна выдержать разные морфологии собак одновременно, а не только одного активного dog runtime за запуск.

## 2. Цель

Сделать side-by-side morphology stress scene для трёх prototype dogs:

1. `DOG-PROT-001 / Bublik` — `standard_medium`, curious helper.
2. `DOG-PROT-002 / Knopka` — `short_long`, happy bouncy.
3. `DOG-PROT-003 / Mishka` — `large_sturdy`, calm worker.

Все три собаки должны одновременно проигрывать одну смысловую фразу:

`idle -> look -> walk -> pickup -> carry -> deliver -> wag`

Цель — проверить, survives ли Dog Runtime grammar на трёх разных morphology profiles.

## 3. Scope

Можно выбрать один из вариантов реализации:

- добавить stress mode в существующий `dog_rig_spike.gd`;
- или создать отдельную сцену / скрипт:
  - `steam/scenes/tech_demos/dog_rig_morphology_stress.tscn`
  - `steam/scripts/tech_demos/dog_rig_morphology_stress.gd`

Предпочтение: минимальный локальный change без большого refactor.

Обновить launcher:

```sh
cd steam
tools/dev-dog-rig.sh stress
tools/dev-dog-rig.sh stress-smoke
```

`stress-smoke` должен запускаться headless и auto-quit.

## 4. Visual requirements

В visible stress scene должно быть видно:

- Бублик, Кнопка и Мишка одновременно;
- подпись для каждой собаки: dog id, name, skeleton family, motion preset;
- базовое различие morphology: standard / short-legged / large sturdy;
- базовое различие motion profile: curious / bouncy / calm;
- food bag остаётся привязанным к socket или attachment point у всех трёх;
- не создаётся ощущение, что под каждую собаку написали отдельную ручную систему.

Допустимы разные lanes или side-by-side layout. Можно сместить phase/timing между собаками, если так лучше читается.

## 5. Readability preview

Добавить простой debug preview для высот:

- 216 px;
- 144 px;
- 96 px.

Достаточно одного из вариантов:

- preview row с уменьшенными собаками;
- переключатель scale mode;
- debug silhouettes / approximate preview.

Проверяем не красоту, а читаемость:

- собака читается как собака;
- различие морфологий видно;
- лапы, мешок и хвост не исчезают;
- secondary motion не превращается в шум.

## 6. Performance observation

Добавить минимальный performance observation:

- FPS;
- node count;
- draw calls, если легко;
- или launcher mode с `--print-fps`.

Цель — увидеть, не даёт ли 3-dog runtime очевидный red flag уже в debug scene.

## 7. Acceptance criteria

Задача выполнена, если:

- есть visible stress launch;
- есть headless smoke launch;
- три собаки отображаются одновременно;
- все три используют данные из `steam/resources/tech_demos/dog_dna_examples.json`;
- все три проходят одну action phrase;
- carried food bag остаётся attached у всех трёх;
- видны morphology и motion differences;
- есть 216 / 144 / 96 readability preview или эквивалентный scale check;
- есть минимальный perf observation;
- `steam/tools/check-godot.sh` обновлён при добавлении новой сцены/скрипта и проходит;
- обновлены `docs/repo/dev/dog-rig-spike.md` и `docs/repo/status/CODEX_STATUS.md`.

## 8. Failure criteria

Считать spike проблемным и честно зафиксировать, если:

- под каждую собаку приходится копировать почти всю animation logic;
- short-legged dog ломает walk/carry;
- large sturdy dog требует отдельного масштаба мира уже на debug уровне;
- socket мешка не работает у одной из морфологий;
- лапы клипуют или отрываются слишком сильно;
- 96 px preview не читает собаку + предмет;
- три собаки дают performance red flag.

## 9. Out of scope

Не делать в этой задаче:

- финальный арт;
- Spine / external tool integration;
- Skeleton2D decision;
- ADR по финальному animation pipeline;
- pathfinding;
- AI behaviour tree;
- реальные приютские dog profiles;
- Dog Shape Pack implementation;
- gameplay economy.

## 10. Documentation update

Обновить `docs/repo/dev/dog-rig-spike.md`:

- что реализовано в v1;
- как запускать stress scene;
- observations по Бублику / Кнопке / Мишке;
- readability observations 216 / 144 / 96;
- performance observations;
- limitations;
- next recommendation.

Обновить `docs/repo/status/CODEX_STATUS.md` новым блоком:

```md
## 2026-06-29 - Dog Rig Morphology Stress v1

- Branch:
- Summary:
- Changed files:
- Checks:
- Observations:
- Assumptions:
- Blockers:
- Next recommended step:
```

## 11. Next after v1

Если v1 проходит:

1. Делать `Dog Rig Spike v2 — Animation Pipeline Comparison`:
   - current procedural node transforms;
   - small `AnimationPlayer` version;
   - optional `Skeleton2D` feasibility.
2. Параллельно начинать `Dog Shape Pack v1` как art task.

Если v1 не проходит:

1. Зафиксировать, какая морфология ломает grammar.
2. Сузить MVP skeleton families.
3. Решить, нужен ли отдельный rig для short-legged / large sturdy раньше, чем планировалось.
