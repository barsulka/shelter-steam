# DOG_RIG_SPIKE v3 — Hybrid Runtime Brief

Дата: 2026-06-29
Роль документа: Development / Technical Art Spike Brief
Статус: ready for Codex

Связано с:

- `docs/drive/Shelter/04_DEVELOPMENT/DOG_RIG_SPIKE_v0_BRIEF.md`
- `docs/drive/Shelter/04_DEVELOPMENT/DOG_RIG_SPIKE_v1_MORPHOLOGY_STRESS_BRIEF.md`
- `docs/drive/Shelter/04_DEVELOPMENT/DOG_RIG_SPIKE_v2_ANIMATION_PIPELINE_COMPARISON_BRIEF.md`
- `docs/repo/dev/dog-rig-spike.md`
- `docs/drive/Shelter/03_DESIGN/00_VISUAL_DIRECTION/DOG_RUNTIME_AND_ANIMATION_GRAMMAR_v1.md`
- `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/DOG_DNA_SCHEMA_v0.md`

## 1. Контекст

Dog Rig Spike v2 сравнил procedural runtime и минимальный `AnimationPlayer` authored lane.

Вывод v2:

- procedural node transforms сильнее для Dog DNA, morphology offsets, personality offsets и socket runtime;
- `AnimationPlayer` полезен для authored base poses/clips;
- authored clips alone не заменяют Dog Runtime;
- лучший следующий технический путь — hybrid:

```text
Authored base clips + procedural Dog DNA / personality / socket / object layers
```

## 2. Цель

Сделать `Dog Rig Spike v3 — Hybrid Runtime`.

Главная цель:

> Проверить, можно ли использовать authored `AnimationPlayer` base clips как основу движения, а поверх них применять procedural Dog DNA offsets, personality motion, socket handling и object swing.

Это не production pipeline decision и не ADR. Это proof, что hybrid model реалистичен.

## 3. Required result

Нужен visible launch mode:

```sh
cd steam
tools/dev-dog-rig.sh hybrid
tools/dev-dog-rig.sh hybrid-smoke
```

`hybrid` должен показать минимум два lane/режима сравнения:

1. Procedural Bublik — current procedural runtime baseline.
2. Hybrid Bublik — authored base clips + procedural overlay layers.

Если дешево, добавить third lane:

3. Hybrid Knopka или Hybrid Mishka — чтобы проверить, не ломается ли hybrid на первой morphology variation.

Но third lane optional. Не раздувать задачу.

## 4. Hybrid model requirements

Hybrid lane должен разделять ответственность:

### Authored / AnimationPlayer owns

- base pose keys;
- basic idle pose;
- basic walk pose cycle;
- basic carry pose;
- pickup/deliver pose intent;
- coarse body/head/leg timing.

### Procedural runtime owns

- Dog DNA load from `dog_dna_examples.json`;
- morphology dimensions / part scaling;
- phrase timing and state transitions;
- socket visibility and bag attachment;
- object swing;
- tail/head/ear personality offsets;
- motion profile parameters;
- per-dog labels/debug state.

Важно: authored clip не должен превращаться в полностью hand-made per-dog animation, которая ломает Dog DNA approach.

## 5. Action phrase

Hybrid lane должен пройти ту же смысловую фразу:

```text
idle -> look -> walk -> pickup -> carry -> deliver -> wag
```

Допустимо, если authored base clips грубые и placeholder-like. Цель — architecture feel, не красота.

## 6. Companion overlay performance check

В v0/v1/v2 dog runtime измерялся только в отдельной debug scene.

В v3 нужно добавить минимальный companion-overlay context check.

Допустимые варианты:

### Option A — integrate one dog runtime into companion field demo as debug-only toggle

Добавить временный dev/debug режим в companion field demo:

```sh
tools/dev-companion-field.sh dog-perf
```

Он должен показать companion strip с performance HUD и 1–3 dog runtimes.

### Option B — launch dog rig spike with companion-like window settings

Если интеграция в companion demo слишком широкая, добавить dog-rig launcher mode, который имитирует companion-strip constraints:

- short window height;
- bottom strip composition;
- performance print/HUD;
- 1–3 dogs visible.

Например:

```sh
tools/dev-dog-rig.sh hybrid-companion-perf
```

Предпочтение: минимальный локальный change. Не ломать companion demo ради spike.

## 7. What to observe

В `docs/repo/dev/dog-rig-spike.md` зафиксировать:

- readable ли hybrid lane по сравнению с procedural;
- удобнее ли authored base clips для base poses;
- можно ли поверх authored clips применять Dog DNA offsets;
- не ломается ли socket/object layer;
- остаётся ли personality motion visible;
- не появляется ли сильный performance red flag;
- стоит ли дальше идти в hybrid или отложить authored clips до появления реальных art parts.

## 8. Acceptance criteria

Задача выполнена, если:

- старые режимы `smoke`, `stress-smoke`, `pipeline-smoke` проходят;
- есть `hybrid` visible mode;
- есть `hybrid-smoke` headless mode;
- hybrid lane использует `AnimationPlayer` base clips или явно documented authored base clip equivalent;
- procedural overlay layers работают поверх authored base;
- bag socket / visibility / swing остаются runtime-owned;
- Dog DNA продолжает управлять хотя бы частью visual/motion parameters;
- есть минимальный companion-overlay context performance check или companion-like mode;
- `steam/tools/check-godot.sh` проходит;
- обновлены `docs/repo/dev/dog-rig-spike.md` и `docs/repo/status/CODEX_STATUS.md`.

## 9. Failure criteria

Считать v3 проблемным и честно зафиксировать, если:

- authored base clips не дают преимуществ по сравнению с procedural;
- Dog DNA offsets плохо сочетаются с authored clips;
- socket/object layer начинает ломаться;
- hybrid требует слишком много glue code;
- companion-like perf mode показывает очевидный red flag;
- старые режимы ломаются.

## 10. Out of scope

Не делать в v3:

- финальный арт;
- Spine / external tool integration;
- production `Skeleton2D` pipeline;
- ADR о финальном pipeline;
- real shelter dog intake;
- pathfinding;
- AI behaviour tree;
- Dog Shape Pack implementation;
- gameplay economy.

## 11. Documentation update

Обновить `docs/repo/dev/dog-rig-spike.md` секцией:

```md
## v3 Hybrid Runtime
```

Включить:

- как запускать;
- что implemented;
- hybrid responsibility split;
- observations;
- companion/perf observations;
- limitations;
- recommendation.

Обновить `docs/repo/status/CODEX_STATUS.md` блоком:

```md
## 2026-06-29 - Dog Rig Hybrid Runtime v3

- Branch:
- Summary:
- Changed files:
- Checks:
- Observations:
- Assumptions:
- Blockers:
- Next recommended step:
```

## 12. Next after v3

Если hybrid проходит:

1. Подготовить brief для `Dog Shape Pack v1` как art task.
2. Подготовить отдельный brief для `Dog Runtime Integration Slice`: один dog runtime внутри production-strip prototype.
3. Отложить `Skeleton2D` / external tool decision до появления настоящих dog art parts.

Если hybrid не проходит:

1. Зафиксировать, где именно конфликт: clips vs Dog DNA, sockets, personality, performance.
2. Решить: pure procedural prototype дальше или отдельный `Skeleton2D` feasibility spike.
