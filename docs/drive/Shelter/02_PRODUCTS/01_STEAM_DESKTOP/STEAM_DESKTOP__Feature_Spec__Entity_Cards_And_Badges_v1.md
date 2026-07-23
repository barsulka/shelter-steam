# STEAM_DESKTOP — Feature Specification — Entity Cards / Badges v1

Дата создания: 2026-07-23
Статус: `GRILLING`
Feature owner: единственный Князь feature `Entity Cards / Badges`
Root/King: `019f8bac-0007-7962-ad8a-ca31fb95ac7f`
Назначение: единственная canonical feature specification для entity selection,
building micro-card и dog badge в Interactive Shelter Shell.

---

## 0. Governance и текущий gate

Эта specification ведёт одну непрерывную `/grilling` lineage. Она не является
Codex brief и не разрешает implementation planning, implementation, production
art, prompts/assets или активацию dev-задачи.

Текущий gate:

```text
GRILLING
→ GRILLED-READY-FOR-ROOT-REVIEW
→ отдельный ROOT-APPROVED
→ только затем отдельные planning / art / implementation gates
```

До полного user Visual Shell Lock по D-031/D-034 feature может проходить
grilling и документироваться, но не может менять locked/live scene. Active
D-034 writer scope, `vertical_slice_demo.gd`, current briefs, evidence, runtime
и tests не входят в ownership этой specification.

## 1. Problem и user value

Interactive Shelter Shell требует лёгкого способа понять, какая собака или
здание выбраны, и получить ровно тот contextual action, который уже разрешён
для сущности.

Feature должна:

- давать ясное подтверждение выбора без постоянного HUD;
- позволять быстро заменить активную сущность;
- сохранять видимость мира и собак;
- не вводить production/economy output или новую gameplay-механику.

Точные visual look, размеры, материалы, palette, portrait treatment и
readability остаются предметом отдельного Art gate после завершения grilling,
Root review и полного live Visual Shell Lock.

## 2. Inherited authority

Следующие рамки уже приняты D-031 и canonical shell roadmap и не открываются
этой feature заново:

- одновременно выбрана не более чем одна entity;
- вне Rooms edit-mode выбор другой entity заменяет предыдущий;
- building показывает anchored micro-card над зданием;
- базовый working action building micro-card — `Move`;
- dog показывает near-dog CQ-like badge: portrait + name, без `X`;
- пустой клик закрывает открытую entity card/badge;
- production/gameplay на этом milestone ничего не производят;
- manual acceptance cadence:
  `chosen live scene → cards → move → rooms → integrated shell`;
- cards implementation и visual production не начинаются до полного live
  Visual Shell Lock и последующих обязательных gates.

`CQ-like` означает только reference intent для компактной near-entity
presentation. Это не разрешение копировать чужие assets, pixels или UX.

Rooms `/grilling` iteration 5 узко расширила base-action boundary для building
отдельной edit-mode кнопкой. Iterations 7–8 переработали transaction lifecycle,
а iteration 9 закрыла functional control composition и lifecycle. Exact icon
art и spatial layout остаются unresolved; все provenance-итерации сохранены
ниже без молчаливой подмены.

## 3. Scope

В scope текущего grilling:

- глобальный lifecycle выбора building/dog;
- открытие, сохранение, замена и закрытие card/badge;
- границы клика между entity, card/badge, игровым миром, UI и прозрачным
  exterior;
- обязательное содержимое и разрешённые действия;
- поведение при pan/zoom и базовые edge/failure cases;
- gameplay/readability constraints и user acceptance criteria.

## 4. Out of scope

- production/economy output, rewards, resources и task flow;
- building Move transaction, ghost, foundations, boxes, smoke и carriers;
- rooms panel content/layout и room art за пределами явно перечисленной
  Cards/Rooms integration boundary;
- новые dog actions, traits, progression или behavior systems;
- production art, prompts, generated assets, portrait production и palette;
- изменение selected-H composition, camera, roster или D-034 render/pointer
  contract;
- implementation architecture, data schema, save migration и Codex brief;
- Browser, Mobile и Windows acceptance.

## 5. Current interaction contract

### 5.1 Global selection

- Selection общая для buildings и dogs: одновременно открыта максимум одна
  entity card/badge.
- Вне Rooms edit-mode выбор другой entity немедленно заменяет предыдущую.
- Во время Rooms edit-mode whole game frozen: dogs и другие buildings
  non-clickable до commit через `Save` или restore через `Cancel`; все dogs
  исчезают с поля.
- Повторный клик по уже выбранной entity не закрывает presentation и не меняет
  состояние.

### 5.2 Card/badge surface

- Клик по неактивной области самой card/badge сохраняет текущий выбор.
- Building micro-card показывает название выбранного building и доступные
  action controls. Ресурсы, production, progress и характеристики не
  показываются.
- Базовый working action building micro-card — `Move`; отдельная Rooms
  edit-mode кнопка действует только по cross-feature contract ниже.
- Dog badge информационный: индивидуальный portrait именно выбранной dog и её
  игровое name, без `X` и без action. Breed icon/name не подменяют identity.

### 5.3 Empty click и non-world input

- Пустым считается только клик внутри интерактивной области игрового мира, если
  в точке нет entity и UI-control.
- Такой клик закрывает текущую card/badge.
- Пока Rooms panel открыт, прямое Rooms user decision узко заменяет это
  поведение: empty world click является no-op.
- Клики по zoom/pan/другому UI не считаются пустыми и не закрывают выбор.
- Прозрачный macOS exterior по D-034 click-through и не получает игровое
  действие закрытия.

### 5.4 Pan и zoom

- Ручной pan и zoom сохраняют выбранную entity и открытую card/badge.
- Presentation постоянно следует за выбранной entity и остаётся строго над
  ней: dog badge следует за собакой во время idle/walk/react, building
  micro-card привязана над building.
- Если entity частично или полностью уходит за viewport, card/badge уходит за
  viewport вместе с ней. Selection сохраняется; presentation не скрывается
  отдельно, не clamp к краю окна и не переносится ниже/сбоку.
- Если выбранная entity удалена или стала недействительной, selection и
  presentation немедленно закрываются.

### 5.5 Cards/Rooms integration boundary

- Normal building micro-card для eligible room panel содержит `Move` и
  textless `Edit` icon.
- Для one-room proxy panel эта кнопка скрыта.
- `Edit` входит в room edit-mode.
- Пока Rooms panel открыт, empty world click — no-op.
- Room edit-mode ведёт freeform transaction draft; object drop сам по себе не
  сохраняет изменения.
- В edit-mode normal `Move + Edit` controls заменяются ровно двумя icons:
  `Save + Cancel`. `Undo` отсутствует.
- `Save` всегда enabled и валидирует draft. Valid draft commit; invalid draft
  не commit, не выходит из mode и flash offenders.
- `Undo` полностью отсутствует: нет button, `Cmd+Z`, history/snapshots, redo
  или persistence-вопроса.
- `Cancel` восстанавливает layout на момент входа и выходит из edit-mode.
- Valid `Save` commit draft и выходит из edit-mode.
- Во время edit-mode whole game frozen; dogs и другие buildings non-clickable,
  все dogs исчезают с поля, а panel `X` заблокирован до завершения через
  `Save` или `Cancel`.
- Вне edit-mode клик по dog открывает её dog badge, но не закрывает уже
  открытую Rooms panel.
- Вне edit-mode panel `X` закрывает Rooms panel, но не закрывает current
  building micro-card/selection.
- Вне edit-mode клик по building без Rooms закрывает прежнюю Rooms panel,
  переводит selection на этот building и показывает его micro-card.
- Вне edit-mode при открытой Rooms panel клик по другому building с Rooms
  заменяет содержимое той же panel на Rooms этого building и синхронно
  переводит selection/micro-card на этот building.
- Exact icon art, spatial layout и неоговорённый disabled feedback не
  определены этой итерацией.

### 5.6 Entity selection hit-area

- Selection использует authored замкнутый geometric polygon по основной
  визуальной массе entity, а не pixel-perfect alpha test.
- Внутренние просветы основной формы входят в hit-area: клик между лапами dog
  или между основными лопастями windmill не должен промахиваться.
- Мельчайшие выступающие детали не обязаны расширять polygon. Одновременно
  запрещён blanket-подход «один прямоугольник вокруг любого объекта»: polygon
  должен осмысленно приближать основную форму конкретной entity.
- Для крупных buildings заднего плана дополнительный comfort padding не
  добавляется: authored polygon накрывает их основную форму и внутренние
  просветы.
- Для dogs authored polygon немного расширен относительно основной формы,
  чтобы маленькая moving entity уверенно выбиралась.
- Будущая windmill rotation не должна создавать кликабельные dead zones между
  лопастями или из-за текущей фазы animation.
- При визуальном перекрытии entities клик выбирает верхнюю entity по текущему
  render/depth order. Repeated click не cycle сквозь перекрытые entities.
- Этот selection hit contract не расширяет D-034 projected canvas и не меняет
  transparent macOS exterior click-through.

### 5.7 Rooms field visibility и viewport dependencies

- Во время Rooms edit-mode с поля исчезают все dogs: и occupants выбранного
  building, и dogs во всех остальных местах.
- Eye-hide является только presentation action: скрывает всё поле, оставляя
  eye/show button, и не изменяет, не cancel, не save и не pause gameplay или
  edit state.
- Show восстанавливает exact same state/draft.
- Background work продолжает работать, если не остановлен другим contract;
  Rooms edit freeze действует независимо.
- Rooms использует третий независимый zoom domain с exact levels
  `50 / 100 / 150 / 200`, отдельно от UI zoom и meadow/world zoom.
- Rooms zoom manual, не auto-fit. Для overflow используется whole-hive pan.
- Whole-hive pan bounded так, чтобы минимум один полный room hex оставался
  видимым.
- Rooms zoom принимает dedicated `−/+` controls и mouse wheel input над hive.
- Эти решения не определяют card/panel visibility во время field hide.

## 6. States и transitions

Текущий минимальный state set:

```text
NONE
BUILDING_SELECTED(entity_id)
DOG_SELECTED(entity_id)
```

Принятые transitions:

```text
NONE + entity click
  → matching selected state

selected + different entity click outside Rooms edit-mode
  → replacement matching selected state

Rooms edit-mode + dog/other-building click
  → no selection event

Rooms panel open outside edit-mode + dog click
  → DOG_SELECTED; panel remains open

Rooms panel open outside edit-mode + building-with-Rooms click
  → BUILDING_SELECTED; same panel shows clicked building Rooms

Rooms panel open outside edit-mode + building-without-Rooms click
  → BUILDING_SELECTED; panel closes

Rooms panel open outside edit-mode + X
  → panel closes; current building selection/card remains

selected + same entity click
  → same state

selected + inactive card/badge body click
  → same state

selected + empty interactive-world click
  → NONE

selected + pan/zoom/UI input
  → same state

transparent exterior click
  → no game event

selected + entity removed/invalid
  → NONE

overlapping entity click
  → select topmost entity by render/depth order
```

## 7. Edge cases и failure cases

Принято:

- same-entity repeated click не toggle;
- card/badge body не является empty world;
- UI input не вызывает accidental deselection;
- pan/zoom не вызывает accidental deselection;
- true exterior не перехватывает pointer ради закрытия selection.
- anchored presentation всегда остаётся над entity и следует за ней, включая
  уход за viewport; edge clamp/reposition отсутствует.
- удалённая/недействительная entity не оставляет stale presentation.
- internal silhouette gaps не создают selection miss, но hit-area не
  деградирует в blanket rectangle.
- перекрытые entities не cycle по repeated click.

Остальные edge/failure cases остаются unresolved до следующих grilling-блоков.

## 8. Role boundaries

- User сохраняет product/art authority и выдаёт прямые visual verdicts.
- Game Designer owns selection lifecycle и gameplay/UX meaning.
- Art Director owns final visual hierarchy, look, portrait treatment,
  readability и visual acceptance.
- Codex реализует только отдельный accepted brief после всех gates и не
  принимает product/game/art решения.
- Root/King выдаёт или отклоняет cross-stream go-ahead после чтения завершённой
  specification; Князь не может присвоить `ROOT-APPROVED` самостоятельно.

## 9. Constraints и dependencies

- Полный live Visual Shell Lock должен быть выдан пользователем раньше cards
  implementation/art production.
- Selected-H composition и D-034 render/pointer equivalence сохраняются.
- Feature не добавляет четвёртый render/occupancy layer и не меняет three-layer
  world contract.
- Видимое изменение после live lock требует нового direct user approval.
- Для будущей реализации обязателен отдельный Codex brief и independent
  verification, отдельный от author.

## 10. Unresolved questions

- Exact icon art, spatial layout и неоговорённый disabled feedback для normal
  `Move + textless Edit` и edit-mode `Save + Cancel` остаются unresolved.
- Card/panel visibility во время Rooms edit dog-hide и eye-hide не определена.
- Rooms zoom control placement/art, persistence/default, wheel direction,
  focal point и edit-mode availability остаются unresolved.
- Exact polygon vertices и величина небольшого dog padding остаются будущим
  bounded Art/implementation derivation внутри принятого hit-area contract.
- Точная семантика доступности `Move` до и во время другой move transaction.
- Visual hierarchy, размеры, offsets, portrait crop, typography и responsive
  behavior — Art authority после gameplay grilling.
- Полный acceptance matrix и evidence для cards stage.

## 11. Acceptance criteria и gates

Черновые criteria будут уточняться в grilling. Уже обязательны:

- глобально открыта максимум одна entity card/badge;
- вне Rooms edit-mode cross-type replacement building ↔ dog работает без
  промежуточного stale presentation;
- в Rooms edit-mode whole game frozen, dog и другие buildings не создают
  selection event до `Save`/`Cancel`, а все dogs исчезают с поля;
- same-entity, card-body, UI, pan и zoom сохраняют выбор;
- card/badge следует за entity и остаётся строго над ней без edge clamp или
  reposition; при уходе entity за viewport presentation уходит вместе с ней;
- empty interactive-world click закрывает выбор, кроме узкого Rooms state:
  пока Rooms panel открыт, этот click является no-op;
- removed/invalid entity закрывает selection без stale presentation;
- transparent exterior остаётся click-through;
- building micro-card показывает building name и доступные actions без
  resource/production/progress/stat information;
- building micro-card имеет base action `Move`; eligible Rooms panel добавляет
  textless `Edit` icon, скрытый для one-room proxy;
- room edit-mode заменяет normal controls на `Save + Cancel` icons only;
- Rooms transaction остаётся draft до `Save`; имеет ровно `Save / Cancel`;
  valid Save commits/exits, invalid Save не commit/exit и flashes offenders,
  Cancel restores entry layout and exits; Undo/history/redo отсутствуют;
- panel `X`, dog и other-building selection блокируются в edit-mode до
  `Save`/`Cancel`;
- вне edit-mode dog selection открывает dog badge и сохраняет Rooms panel;
- вне edit-mode panel `X` закрывает panel без закрытия current building
  micro-card/selection;
- вне edit-mode building без Rooms закрывает старую panel и получает selection
  с собственной micro-card;
- вне edit-mode другая building с Rooms заменяет содержимое открытой Rooms
  panel и синхронно заменяет selection/micro-card;
- eye-hide сохраняет exact gameplay/edit state и show восстанавливает тот же
  state/draft;
- independent Rooms zoom использует exact `50/100/150/200`, manual `−/+` и
  wheel-over-hive input, не auto-fit; whole-hive pan сохраняет минимум один
  полный room hex видимым;
- вне edit-mode другая building с Rooms заменяет содержимое открытой Rooms
  panel на свои Rooms;
- dog badge содержит только portrait + name и не имеет `X`/actions;
- dog badge использует identity выбранной dog: её индивидуальный portrait и
  игровое name, а не breed substitute;
- selection polygons замкнуто накрывают основную форму и internal gaps,
  исключают dead zones между dog legs/windmill blades, не включают обязательным
  образом мельчайшие детали и не заменяются blanket rectangles;
- dogs получают небольшой hit padding, крупные rear buildings — без
  дополнительного padding;
- overlap выбирает topmost render/depth entity без cycling;
- feature не создаёт production/economy result;
- user вручную принимает cards в locked live scene;
- automatic checks не подменяют user visual verdict.

## 12. Evidence / provenance

Authority прочитана напрямую из current checkout:

- `PROJECTS_RULES.md`;
- `AGENTS.md`;
- role docs Game Designer, Art Director и Project Manager;
- `BOOTSTRAP_CONTEXT.md` и current product/game/art/dev status;
- D-031 и D-034 в `02_DECISIONS.md`;
- canonical Game Design и Visual Production roadmaps;
- active Selected-H brief boundaries.

Tracked write ownership:

- Root/King `019f8bac-0007-7962-ad8a-ca31fb95ac7f` подтвердил sole ownership
  единственного Князя только на этот новый canonical spec-файл;
- existing docs, roadmaps, decisions, briefs, D-034 scope, runtime и tests
  остаются read-only;
- ownership ACK не является `ROOT-APPROVED` feature gate или разрешением
  planning/production/implementation.

### `/grilling` iteration 1 — 2026-07-23

User decisions:

1. Повторный клик по уже выбранной entity оставляет presentation открытой.
2. Клик по неактивной области card/badge сохраняет выбор.
3. Empty click ограничен интерактивным миром без entity/UI; UI не закрывает, а
   D-034 exterior остаётся click-through.
4. Pan и zoom сохраняют выбор и presentation.

Текущий итог: iteration записана; feature остаётся `GRILLING`.

### `/grilling` iteration 2 — 2026-07-23

User decisions:

1. Dog badge постоянно следует за собакой во время idle/walk/react.
2. При уходе выбранной entity за viewport presentation уезжает за пределы окна
   вместе с entity; selection сохраняется.
3. Card/badge всегда остаётся над entity. Автоматический edge clamp, перенос
   ниже/сбоку или другая смена положения запрещены.
4. Если выбранная entity удалена или стала недействительной, selection и
   presentation немедленно закрываются.

Текущий итог: iteration записана; feature остаётся `GRILLING`.

### `/grilling` iteration 3 — 2026-07-23

User decisions:

1. Building micro-card показывает building name и доступные action controls,
   без resources, production, progress или stats.
2. Dog badge использует индивидуальный portrait и игровое name выбранной dog,
   а не breed icon/name.
3. Entity hit-area — authored closed polygon по основной форме. Internal gaps,
   включая пространство между dog legs и основные промежутки между windmill
   blades, не являются промахом; мельчайшие детали не обязаны входить в
   polygon; blanket rectangle запрещён. Dogs получают небольшое расширение,
   крупные rear buildings — нет.
4. При overlap выбирается topmost entity по render/depth order без cycling.

Текущий итог: iteration записана; feature остаётся `GRILLING`.

### Cross-feature Rooms dependency notice — iteration 4 — 2026-07-23

Root передал принятое в Rooms `/grilling` прямое user decision: Rooms v1
требует explicit room edit-mode, вход в который выполняется отдельной кнопкой
на building micro-card.

Это dependency/conflict input, а не готовое Cards decision. Текущий inherited
Cards contract (`Move` — sole working action) не отменён, Rooms decision не
отменено, а button presentation/availability, coexistence/disablement,
entry/exit и one-room proxy behavior намеренно оставлены unresolved до
согласованной Cards/Rooms grilling-итерации.

### Cross-feature Rooms resolution — iteration 5 — 2026-07-23

Root передал следующие прямые user decisions из Rooms `/grilling`:

1. Building micro-card получает отдельную textless honeycomb edit-mode кнопку.
2. Для one-room proxy panel эта кнопка скрыта.
3. Кнопка toggle room edit-mode.
4. Во время edit-mode `Move` disabled.
5. `X` закрывает panel и выходит из mode.
6. Выбор другого building отменяет unfinished drag, выходит из предыдущего
   edit-mode и открывает panel нового building.
7. Пока Rooms panel открыт, empty world click остаётся no-op.

Эта итерация узко разрешает перечисленные части прежнего конфликта. Icon art,
card layout, unavailable-state visuals, dog-selection interaction и другие
непереданные ответы остаются unresolved. Feature остаётся `GRILLING`.

### Cross-feature Rooms lifecycle — iteration 7 — 2026-07-23

Root передал следующие прямые user decisions из Rooms `/grilling`:

1. Room edit-mode — freeform transaction draft, не autosave-per-drop.
2. В edit-mode существуют ровно `Save / Undo / Cancel`.
3. `Save` всегда enabled; invalid draft не commit, не выходит и flash
   offenders.
4. `Undo` равен `Cmd+Z`, хранит 20 actions текущей runtime session; redo нет.
5. `Cancel` восстанавливает entry layout и выходит.

Iteration 7 оставила unresolved exact micro-card composition (replace/join
`Move`/edit controls), icon/text, unavailable `Undo`, exit после valid `Save`,
`X` и building-switch behavior. Эта запись сохраняет историческую provenance:
iteration-7 `Undo` dependency полностью superseded прямым user decision
iteration 8 ниже и не является optional/current behavior. Соответствующие
iteration-5 ответы по lifecycle также не считаются окончательным current
resolution без reconciled Cards/Rooms grilling. Другие Cards decisions не
изменены. Feature остаётся `GRILLING`.

### Cross-feature Rooms Undo revocation — iteration 8 — 2026-07-23

Прямое user supersession:

1. `Undo` полностью отозван: нет Undo button, `Cmd+Z`, history/20 snapshots,
   redo и persistence-вопроса.
2. Current edit transaction имеет только `Save` и `Cancel`.
3. `Cancel` восстанавливает edit-entry layout.
4. `Save` валидирует и commit valid draft; invalid draft не commit.

На момент iteration 8 exact micro-card composition, exit после valid `Save`,
`X` и building-switch behavior оставались unresolved; iteration 9 ниже
закрывает эти functional lifecycle вопросы. Feature остаётся `GRILLING`.

### Cross-feature Rooms lifecycle closure — iteration 9 — 2026-07-23

Root передал следующие прямые user decisions из Rooms `/grilling`:

1. Normal building micro-card: `Move + textless Edit` icon.
2. Rooms edit-mode: только `Save + Cancel` icons; `Undo` отсутствует.
3. Valid `Save` commit и выходит; invalid `Save` остаётся в mode.
4. Во время edit-mode panel `X` и выбор другого building заблокированы до
   `Save`/`Cancel`.
5. Empty world click — no-op.

Iteration 9 явно закрывает прежние lifecycle-unresolved вопросы. Exact icon
art, spatial layout и неоговорённый disabled feedback остаются unresolved.
Feature остаётся `GRILLING`.

### Cards `/grilling` block 4 — partial direct answer — 2026-07-23

Прямые user decisions:

1. Во время Rooms edit-mode whole game frozen; dogs и другие buildings
   non-clickable до полного `Save` commit или `Cancel` restore.
2. Вне edit-mode при открытой Rooms panel клик по другому building с Rooms
   показывает Rooms этого building в той же panel.

Отдельный ответ пользователя `2. Да` не имеет однозначного соответствия
уточнённому четырёхпунктному блоку и намеренно не назначен ни одному contract
decision. Normal-mode dog selection, panel `X`, building без Rooms и
selection/micro-card synchronization при panel replacement остаются
unresolved. Feature остаётся `GRILLING`.

### Cross-feature Rooms field/eye lifecycle — iteration 11 — 2026-07-23

Root передал следующие прямые user decisions из Rooms `/grilling`:

1. Во время Rooms edit-mode whole game frozen и с поля исчезают все dogs:
   selected-building occupants и dogs во всех остальных местах.
2. Eye-hide — presentation-only: скрывает всё поле, оставляя eye/show button,
   и не меняет/cancel/save/pause gameplay или edit state.
3. Show восстанавливает exact same state/draft.
4. Background work продолжается, если иначе разрешён; Rooms edit остаётся
   независимо frozen.

Card/panel visibility сверх exact field-hide contract не определена. Feature
остаётся `GRILLING`.

### Cross-feature Rooms zoom dependency — iteration 13 — 2026-07-23

Root передал следующие прямые user decisions из Rooms `/grilling`:

1. Rooms получает третий independent zoom domain с exact levels
   `50/100/150/200`, независимо от UI и meadow/world zoom.
2. Rooms zoom manual, не auto-fit.
3. Overflow обслуживает whole-hive pan.

Control location/input, default/persistence, edit-mode behavior, focal point и
pan bounds на этой итерации оставались unresolved. Feature остаётся
`GRILLING`.

### Cross-feature Rooms zoom/pan controls — iteration 14 — 2026-07-23

Root передал следующие прямые user decisions из Rooms `/grilling`:

1. Whole-hive pan bounded так, чтобы минимум один full room hex оставался
   visible.
2. Rooms zoom поддерживает dedicated `−/+` controls и mouse wheel над hive.
3. Levels остаются exact `50/100/150/200` и независимы от UI/meadow zoom.

Control placement/art, persistence/default, wheel direction/focal point и
edit-mode availability остаются unresolved. Feature остаётся `GRILLING`.

### Cards `/grilling` block 4 — normal-mode resolution — 2026-07-23

Прямые user decisions:

1. Вне edit-mode клик по dog открывает dog badge, но не закрывает Rooms panel.
2. Вне edit-mode panel `X` закрывает Rooms panel, оставляя current building
   micro-card/selection.
3. Вне edit-mode клик по building без Rooms закрывает прежнюю panel, переводит
   selection на новый building и показывает его micro-card.
4. Вне edit-mode клик по другому building с Rooms синхронно переводит
   selection/micro-card на этот building и показывает его Rooms в той же
   panel.

Эти ответы разрешают normal-mode вопросы, оставленные partial block-4
итерацией. Edit-mode блокировка сохраняется без изменений. Feature остаётся
`GRILLING`.
