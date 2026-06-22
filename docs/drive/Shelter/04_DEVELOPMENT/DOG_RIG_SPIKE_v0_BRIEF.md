# DOG_RIG_SPIKE v0 — Brief

Дата: 2026-06-28  
Роль документа: Development / Technical Art Spike Brief  
Статус: proposal for Codex / CTO validation  
Связано с:

- `03_DESIGN/00_VISUAL_DIRECTION/DOG_RUNTIME_AND_ANIMATION_GRAMMAR_v1.md`
- `03_DESIGN/04_DELIVERABLES/DOG_DNA_SCHEMA_v0.md`
- `03_DESIGN/00_VISUAL_DIRECTION/DOG_VISUAL_LANGUAGE_v1.md`

## 1. Цель spike

Проверить, можно ли в Godot сделать минимальный Dog Runtime proof:

> одна собака как modular rig + shared clips + object socket + небольшие personality offsets.

Этот spike не должен делать production-quality арт. Он должен доказать или опровергнуть техническую гипотезу:

> Shelter может поддерживать разных собак через skeleton families и shared animation clips, а не через полную ручную перерисовку каждого набора анимаций.

## 2. Scope v0

### 2.1 Один базовый rig

Начать с `standard_medium` rig.

Не делать сразу все skeleton families.

### 2.2 Одна тестовая собака

Использовать DOG-PROT-001 / Бублик из `DOG_DNA_SCHEMA_v0.md`.

Если времени хватает, подготовить placeholders для DOG-PROT-002 / Кнопка и DOG-PROT-003 / Мишка, но не блокировать spike.

### 2.3 Минимальные части тела

Dog rig должен состоять из отдельных визуальных частей:

- body;
- head;
- muzzle optional;
- front upper/lower leg or simplified front leg;
- back upper/lower leg or simplified back leg;
- ear left;
- ear right;
- tail;
- optional collar;
- carried object socket.

Можно использовать примитивные placeholder shapes. Красота не важна.

### 2.4 Минимальные клипы

Нужны:

1. `idle_neutral`  
2. `walk_empty`  
3. `walk_carry_medium`  
4. `pickup_pose`  
5. `deliver_pose`  
6. additive / layered or simulated:
   - `tail_wag`
   - `head_look`
   - `ear_bounce`

Если additive layering в выбранном подходе сложен, можно имитировать через отдельные AnimationPlayer tracks или procedural updates, но обязательно описать ограничения.

### 2.5 Object socket

Проверить carried object:

- food bag attaches to mouth/harness socket;
- food bag remains visually connected during walk;
- object can be hidden/shown or swapped;
- object swing/offset can be adjusted.

## 3. Demo behaviour

Минимальная сцена:

```text
Dog idle -> looks at food bag -> walks to bag -> pickup -> walks carrying bag -> delivers bag -> happy tail wag -> idle
```

Можно сделать без pathfinding, по фиксированной траектории.

## 4. What to measure / observe

### 4.1 Visual feasibility

- Лапы не выглядят совсем сломанно.  
- Собака не скользит слишком очевидно.  
- Предмет привязан к собаке.  
- Хвост/уши оживляют движение, но не шумят.  
- На маленькой высоте сохраняется читаемость.

### 4.2 Technical feasibility

- Удобно ли собирать rig в Godot?  
- Удобно ли менять части тела?  
- Можно ли переключать клипы без визуального развала?  
- Можно ли держать object socket?  
- Можно ли позже сделать несколько собак на одном подходе?  
- Как это влияет на performance в companion overlay?

### 4.3 Pipeline risk

Оценить:

- Godot-only pipeline enough?  
- Нужен ли Spine-like tool?  
- Сколько ручной работы требуется на новую собаку?  
- Какие части будут ломаться при short legs / large body?  
- Можно ли хранить Dog DNA как JSON/resource?

## 5. Suggested implementation options

Этот документ не выбирает финальный стек, но предлагает проверить.

### Option A — Godot native Skeleton2D / Bone2D

Плюсы:

- без внешних платных зависимостей;
- ближе к runtime;
- проще для Codex/Godot проекта.

Риски:

- tooling может быть менее удобным для художников;
- cutout character workflow может быть болезненным;
- additive layering может потребовать аккуратной архитектуры.

### Option B — Godot nodes + manual part transforms

Плюсы:

- максимально просто для spike;
- быстро понять sockets/layers;
- не требует полноценного bone setup.

Риски:

- может не масштабироваться до production;
- слишком кастомная система;
- сложнее для аниматоров.

### Option C — external 2D skeletal tool later

Например Spine-like workflow.

Плюсы:

- сильный animation tooling;
- удобнее художникам/аниматорам.

Риски:

- лицензии / зависимости;
- runtime integration;
- production complexity;
- надо отдельно проверять Windows/macOS/Godot compatibility.

Recommendation for v0:

> Начать с Option B или A как дешёвого Godot proof. Не принимать Spine/external dependency до первого native spike.

## 6. Acceptance criteria

Spike считается успешным, если:

- собака собирается из отдельных частей;
- есть idle и walk;
- food bag крепится к socket и едет вместе с собакой;
- есть хотя бы хвостовой wag как отдельный слой/трек;
- можно изменить хотя бы 2 параметра personality motion и визуально увидеть разницу;
- сцена проходит headless/smoke check;
- visible demo можно запустить в Steam/Godot project;
- ограничения и выводы записаны в `docs/repo/status/CODEX_STATUS.md` или отдельный dev-doc.

Spike считается неуспешным, если:

- rig разваливается при простом walk;
- предмет невозможно нормально держать socket-ом;
- dog animation требует frame-by-frame redraw уже на v0;
- performance/complexity явно неприемлемы;
- native Godot approach оказывается слишком неудобным даже для proof.

## 7. Out of scope

Не делать в v0:

- финальный арт;
- все породы;
- все skeleton families;
- pathfinding;
- real shelter dog intake UI;
- production save format;
- полную animation library;
- room/personality system;
- AI behaviour tree.

## 8. Proposed file locations

If implemented in repo, suggested locations:

```text
steam/scenes/tech_demos/dog_rig_spike.tscn
steam/scripts/tech_demos/dog_rig_spike.gd
steam/resources/tech_demos/dog_dna_examples.json
steam/tools/dev-dog-rig.sh
```

Documentation:

```text
docs/repo/dev/dog-rig-spike.md
docs/repo/status/CODEX_STATUS.md
```

## 9. Next after successful spike

If v0 passes:

1. Add two more morphology variants: short-legged and large sturdy.  
2. Test whether same animation grammar survives different proportions.  
3. Decide whether to continue Godot-native or evaluate external skeletal animation tooling.  
4. Start real Dog Shape Pack v1 visual production.

