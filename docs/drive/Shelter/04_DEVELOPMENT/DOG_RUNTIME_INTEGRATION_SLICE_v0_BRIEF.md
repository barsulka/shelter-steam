# DOG_RUNTIME_INTEGRATION_SLICE v0 — Brief

Дата: 2026-06-29
Роль документа: Development / Technical Art Integration Brief
Статус: ready for Codex

Связано с:

- `docs/repo/dev/dog-rig-spike.md`
- `docs/repo/dev/companion-field-tech-demo.md`
- `docs/drive/Shelter/04_DEVELOPMENT/DOG_RIG_SPIKE_v3_HYBRID_RUNTIME_BRIEF.md`
- `docs/drive/Shelter/03_DESIGN/00_VISUAL_DIRECTION/DOG_RUNTIME_AND_ANIMATION_GRAMMAR_v1.md`
- `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/DOG_DNA_SCHEMA_v0.md`

## 1. Контекст

Dog Rig Spike v3 прошёл как qualified hybrid-runtime pass:

- authored `AnimationPlayer` base clips полезны для base pose intent;
- Dog DNA, morphology, personality, sockets, object swing и phrase timing должны оставаться runtime layers;
- companion-like dog strip с тремя hybrid dogs не показал явного isolated performance red flag;
- но dog runtime всё ещё живёт в отдельной debug scene, а не в реальном companion / production strip контексте.

Следующий шаг:

> проверить один hybrid dog runtime внутри существующей companion field / production strip tech demo без превращения этой задачи в полноценный gameplay refactor.

## 2. Цель

Сделать `Dog Runtime Integration Slice v0`.

Главная цель:

> Добавить одного debug-only hybrid dog agent в существующий companion field tech demo / production strip context, чтобы проверить, как Dog Runtime живёт рядом с полем, зданиями, performance HUD, zoom/pan и нижней полосой.

Это не задача на финальный gameplay, не AI behaviour tree и не production art.

## 3. Required result

Добавить новый launcher mode:

```sh
cd steam
tools/dev-companion-field.sh dog-runtime
tools/dev-companion-field.sh dog-runtime-smoke
```

Visible `dog-runtime` должен запускать companion field demo с:

- обычной нижней полосой / field context;
- performance HUD available;
- одним hybrid dog runtime, preferably `DOG-PROT-001 / Bublik`;
- debug label: dog id, current phrase state, socket state;
- dog выполняет короткую readable phrase на полосе:

```text
idle -> walk -> pickup food bag/crate -> carry -> deliver -> wag -> idle
```

`dog-runtime-smoke` должен запускаться headless и auto-quit.

## 4. Scope

### 4.1 Use existing dog work, do not rebuild it

Использовать выводы и/или код из `dog_rig_spike.gd`, но не делать большой перенос всей spike scene внутрь companion demo.

Допустимые варианты:

- локально вынести минимальный reusable dog runtime helper, если это маленькое изменение;
- или временно embedded debug implementation внутри companion demo, если extraction слишком широкая;
- или создать отдельный companion-style dog runtime scene, если это безопаснее.

Предпочтение: минимальный локальный change и отсутствие большого архитектурного refactor.

### 4.2 One dog only

В v0 достаточно одного hybrid dog.

Не добавлять сразу Бублика + Кнопку + Мишку в companion field. Это уже проверялось в изолированном spike.

### 4.3 Debug-only

Dog runtime integration должна быть явно dev/debug feature.

Не делать:

- save/load integration;
- production dog roster;
- UI карточку собаки;
- assignment system;
- economy connection;
- final task system.

## 5. Visual / UX requirements

Dog must:

- live on the lower ground baseline;
- remain readable at current companion strip scale;
- not float above the field;
- not be hidden by debug UI;
- not interfere with existing controls/settings more than necessary;
- keep bag/crate attached via socket during carry;
- show at least tail/head/ear/personality motion.

If zoom/pan exists in this mode, dog should behave predictably with it or limitations must be documented.

## 6. Performance requirements

Use existing performance HUD where possible.

Document at least:

- FPS observation from visible macOS run;
- node count;
- draw calls if available;
- whether dog runtime increases obvious load compared with baseline companion demo.

This is not a production benchmark, but any obvious red flag must be documented.

## 7. Acceptance criteria

Задача выполнена, если:

- `tools/dev-companion-field.sh dog-runtime` exists and launches visibly;
- `tools/dev-companion-field.sh dog-runtime-smoke` exists and passes headless auto-quit;
- existing companion modes still work;
- existing dog rig modes still work;
- one hybrid dog is visible in companion/production-strip context;
- dog uses Dog DNA data or clearly documented prototype bridge;
- dog performs readable idle/walk/pickup/carry/deliver/wag phrase;
- object socket attachment remains visible;
- performance HUD or equivalent observation is available;
- `steam/tools/check-godot.sh` passes;
- docs updated:
  - `docs/repo/dev/companion-field-tech-demo.md`
  - `docs/repo/dev/dog-rig-spike.md` if dog runtime code/contract changes
  - `docs/repo/status/CODEX_STATUS.md`.

## 8. Failure criteria

Считать slice проблемным и честно зафиксировать, если:

- dog runtime cannot be added without large companion demo refactor;
- dog is unreadable at companion strip scale;
- dog breaks zoom/pan/input/click-through assumptions;
- socket/carry action becomes visually broken in strip context;
- performance HUD shows obvious red flag;
- debug code becomes tangled with production field logic;
- existing modes break.

## 9. Out of scope

Не делать в v0:

- final dog art;
- real shelter dog profiles;
- Dog Shape Pack implementation;
- pathfinding;
- AI behaviour tree;
- production task system;
- dog assignment UI;
- economy integration;
- van delivery system;
- room/personal space integration;
- `Skeleton2D` / external tool decision;
- ADR.

## 10. Documentation update

Update `docs/repo/dev/companion-field-tech-demo.md` with section:

```md
## Dog Runtime Integration Slice v0
```

Include:

- how to run;
- what is integrated;
- what remains debug-only;
- visual observations;
- performance observations;
- limitations;
- next step.

Update `docs/repo/dev/dog-rig-spike.md` only if code extraction or dog runtime contract changed.

Update `docs/repo/status/CODEX_STATUS.md` with:

```md
## 2026-06-29 - Dog Runtime Integration Slice v0

- Branch:
- Summary:
- Changed files:
- Checks:
- Observations:
- Assumptions:
- Blockers:
- Next recommended step:
```

## 11. Next after successful v0

If v0 passes:

1. Start `Dog Shape Pack v1` as art task, because runtime can now be tested in strip context.
2. Prepare `Dog Runtime Integration Slice v1`: 2–3 dogs, one real production module interaction, no full economy.
3. Keep hybrid runtime direction: authored base clips + procedural Dog DNA/personality/socket layers.
4. Keep `Skeleton2D` / external tooling deferred until real dog art parts expose a concrete limitation.

If v0 fails:

1. Document whether the failure is scale/readability, integration complexity, performance, or input/window behaviour.
2. Decide whether dog runtime needs a separate reusable scene/component before touching companion demo again.
