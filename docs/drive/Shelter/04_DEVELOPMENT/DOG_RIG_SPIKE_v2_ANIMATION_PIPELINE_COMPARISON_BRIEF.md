# DOG_RIG_SPIKE v2 — Animation Pipeline Comparison Brief

Дата: 2026-06-29
Роль документа: Development / Technical Art Spike Brief
Статус: ready for Codex

Связано с:

- `docs/drive/Shelter/04_DEVELOPMENT/DOG_RIG_SPIKE_v0_BRIEF.md`
- `docs/drive/Shelter/04_DEVELOPMENT/DOG_RIG_SPIKE_v1_MORPHOLOGY_STRESS_BRIEF.md`
- `docs/repo/dev/dog-rig-spike.md`
- `docs/drive/Shelter/03_DESIGN/00_VISUAL_DIRECTION/DOG_RUNTIME_AND_ANIMATION_GRAMMAR_v1.md`
- `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/DOG_DNA_SCHEMA_v0.md`

## 1. Контекст

Dog Rig Spike v1 показал qualified native pass:

- Бублик, Кнопка и Мишка одновременно отображаются в stress mode;
- все три читаются из `dog_dna_examples.json`;
- все три используют одну procedural action grammar;
- food bag attachment работает у всех трёх;
- 216/144/96 readability preview есть;
- явного 3-dog performance red flag в отдельной debug scene не найдено.

Но v0/v1 всё ещё используют Option B:

> Godot nodes + manual part transforms.

Это хорошо для proof, но ещё не ясно, подходит ли такой подход для production animation authoring. Следующий шаг — сравнить procedural runtime с минимальным authored animation pipeline внутри Godot.

## 2. Цель

Сделать `Dog Rig Spike v2 — Animation Pipeline Comparison`.

Главная цель:

> Сравнить текущий procedural node-transform подход с маленькой Godot-authored animation версией на `AnimationPlayer` или `AnimationTree`, чтобы понять, стоит ли продолжать pure procedural, переходить к authored Godot clips, или позже отдельно проверять `Skeleton2D` / external tooling.

Это не ADR и не финальное техническое решение. Это comparison spike.

## 3. Required comparison targets

### Target A — Current procedural runtime

Текущий подход из `dog_rig_spike.gd`:

- manual node transforms;
- procedural phrase;
- procedural tail/head/ear/object motion;
- Dog DNA offsets.

Не ломать существующий режим.

### Target B — Minimal authored Godot clip runtime

Добавить минимальную authored animation версию на одном prototype dog, preferably `DOG-PROT-001 / Bublik`.

Допустимые варианты:

- `AnimationPlayer` only;
- или `AnimationPlayer` + simple `AnimationTree`, если это остаётся маленьким spike.

Минимальные authored clips:

- `idle_neutral`;
- `walk_empty`;
- `walk_carry_medium`;
- `pickup_pose` или короткий pickup segment;
- `deliver_pose` или короткий deliver segment;
- simple tail/head/ear tracks, если быстро.

Цель — проверить authoring workflow, а не сделать красивую анимацию.

## 4. Out of scope

Не делать в v2:

- production art;
- external tools integration;
- Spine / DragonBones / Creature runtime;
- полноценный `Skeleton2D` pipeline, если это требует большой отдельной задачи;
- ADR о финальном pipeline;
- pathfinding;
- AI behaviour tree;
- новые реальные собаки;
- Dog Shape Pack implementation.

`Skeleton2D` можно только кратко оценить в документации как next possible spike, если Codex видит очевидные риски/плюсы. Не надо внедрять его в этой задаче.

## 5. Suggested implementation

Можно выбрать один из вариантов:

### Option 1 — same scene, comparison mode

Добавить режим:

```sh
tools/dev-dog-rig.sh pipeline
tools/dev-dog-rig.sh pipeline-smoke
```

Visible `pipeline` показывает рядом:

- procedural Bublik;
- authored AnimationPlayer Bublik.

### Option 2 — separate comparison scene

Создать новую сцену/скрипт:

- `steam/scenes/tech_demos/dog_animation_pipeline_comparison.tscn`
- `steam/scripts/tech_demos/dog_animation_pipeline_comparison.gd`

И добавить launcher modes:

```sh
tools/dev-dog-rig.sh pipeline
tools/dev-dog-rig.sh pipeline-smoke
```

Предпочтение: минимальный локальный change без большого refactor. Если `dog_rig_spike.gd` становится слишком большим, лучше отдельная comparison scene.

## 6. Visual/debug requirements

Visible comparison должна показывать:

- procedural Bublik;
- authored Bublik;
- labels for both approaches;
- current clip/state;
- whether food bag is attached;
- simple notes/debug label: what is driven procedurally vs authored.

Обе версии должны пройти одну смысловую фразу:

`idle -> look -> walk -> pickup -> carry -> deliver -> wag`

Допустимо, если authored version покрывает фразу более грубо, но должно быть видно, насколько удобно/неудобно собирать clips.

## 7. What to compare

В `docs/repo/dev/dog-rig-spike.md` зафиксировать comparison table:

- authoring effort;
- code complexity;
- animation readability;
- object socket handling;
- support for Dog DNA offsets;
- support for different morphology profiles;
- suitability for artists/animators;
- performance risk;
- scalability to many real shelter dogs;
- maintainability.

## 8. Acceptance criteria

Задача выполнена, если:

- существующие v0/v1 modes не сломаны;
- есть visible pipeline comparison launch;
- есть headless pipeline smoke launch;
- procedural and authored approaches can be compared in one scene/mode;
- authored version has at least idle + walk + carry segment;
- food bag attachment question is explicitly tested or documented;
- Codex documents whether AnimationPlayer/AnimationTree feels promising or awkward;
- `steam/tools/check-godot.sh` passes;
- `docs/repo/dev/dog-rig-spike.md` updated;
- `docs/repo/status/CODEX_STATUS.md` updated.

## 9. Failure criteria

Spike is problematic if:

- authored clips require too much duplicated setup for tiny gain;
- AnimationPlayer approach makes Dog DNA offsets hard/impossible;
- object socket becomes worse than procedural approach;
- comparison requires broad architecture refactor;
- existing stress mode breaks;
- performance or node count jumps unexpectedly.

If any of these happen, document clearly. Do not hide it.

## 10. Documentation update

Update `docs/repo/dev/dog-rig-spike.md` with section:

`## v2 Animation Pipeline Comparison`

Include:

- how to run;
- what was implemented;
- comparison table;
- recommendation;
- limitations;
- next step.

Update `docs/repo/status/CODEX_STATUS.md` with block:

```md
## 2026-06-29 - Dog Rig Animation Pipeline Comparison v2

- Branch:
- Summary:
- Changed files:
- Checks:
- Observations:
- Assumptions:
- Blockers:
- Next recommended step:
```

## 11. Next after v2

If authored Godot clips look promising:

1. Plan `Dog Rig Spike v3 — Hybrid Runtime`: authored base clips + procedural personality layers.
2. Then test the hybrid in the companion overlay performance context.

If procedural remains clearly better:

1. Keep procedural runtime for prototype.
2. Start Dog Shape Pack v1 in parallel.
3. Delay authored pipeline decision until real art parts exist.

If both are weak:

1. Prepare separate `Skeleton2D` feasibility brief.
2. Only after that consider external tools.
