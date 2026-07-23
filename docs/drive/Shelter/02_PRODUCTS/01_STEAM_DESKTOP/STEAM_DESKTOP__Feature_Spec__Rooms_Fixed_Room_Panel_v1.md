# STEAM_DESKTOP — Feature Specification — Rooms: Fixed Room Panel v1

Дата создания: 2026-07-23
Статус: `GRILLING`
Feature owner / единственный Князь: task `019f8f5d-dae5-7711-9248-7c20b449ed5a`
Root/King: task `019f8bac-0007-7962-ad8a-ca31fb95ac7f`
Root gate: `NOT REVIEWED / NOT ROOT-APPROVED`
Роль документа: единственная canonical feature specification текущего
`/grilling` lineage для первого fixed rooms panel.

---

## 0. Governance и activation boundary

Этот документ фиксирует только уже полученный результат текущей итерации
`/grilling`. Feature ещё не спроектирована полностью.

До одновременного выполнения всех условий ниже запрещены implementation
planning, Codex brief activation, implementation и production новых room assets:

1. `/grilling` завершён;
2. этот документ актуализирован и получает статус
   `GRILLED-READY-FOR-ROOT-REVIEW`;
3. Root/King читает результат и явно выдаёт `ROOT-APPROVED`.

Текущий статус `GRILLING` не является ни art-, ни implementation-, ни
acceptance-go.

## 1. Problem и user value

### 1.1 Problem

В текущей Steam/Desktop shell существует принятый общий UX-intent: клик по
зданию открывает fixed rooms panel над поляной. Но для первого доказательства
ещё не зафиксирован достаточно узкий и непротиворечивый feature contract:

- что именно показывает первая панель;
- к какому существующему объекту она привязана;
- какие действия внутри неё доступны;
- как она закрывается и как сосуществует с последующими building clicks;
- какие визуальные источники допустимы.

Без этого art production и implementation неизбежно начали бы сами принимать
game-design, product или art decisions.

### 1.2 User value

Первый proof должен дать игроку простой и понятный взгляд внутрь будущей жизни
Shelter: одним кликом увидеть три разных пространства будущей школы, не
перегружая поляну новым зданием и не добавляя преждевременную room-механику.

## 2. Принятые решения текущей grilling-итерации

### 2.1 Первый proof

- Первый proof — **одна fixed authored panel**.
- Текущая предпочтительная композиция — одновременно показать **ровно три
  комнаты**:
  1. classroom;
  2. library;
  3. laboratory.
- Формулировка «ровно три» пока является предпочтительным направлением proof,
  а не закрытым hard acceptance criterion: это должно быть подтверждено
  следующей grilling-итерацией.

### 2.2 Click anchor и смысл панели

- На поляне не создаётся новое здание, объект или отдельный school anchor.
- Текущий accepted `Kitchen` используется как click anchor первого proof.
- Открытая панель при этом представляет **будущую планируемую школу**, а не
  интерьер Kitchen.
- Такая временная привязка не переименовывает Kitchen в школу и не меняет её
  существующую роль.

### 2.3 Interaction внутри панели

- Внутри комнат нет player interaction или room action.
- Панель не вводит управление собаками, stations, upgrades, production,
  research, decoration, assignment или иной gameplay.
- Наличие или отсутствие purely ambient non-interactive motion пока не решено и
  не следует из этого решения.

### 2.4 Close intent пользователя

Текущий user intent:

- `X` закрывает панель;
- клик по **любому другому зданию** закрывает панель.

Этот intent ещё не превращён в окончательный transition contract, потому что он
конфликтует с действующей current authority. Точный reconciliation обязателен
до завершения `/grilling`; см. разделы 5 и 9.

### 2.5 Visual-source boundary

- Новые оригинальные Shelter room assets допустимы только после полного feature
  gate из раздела 0.
- CQ / Hero Town и уже принятые meadow assets не являются источниками room
  assets: нельзя копировать, вырезать, переиспользовать или производить из них
  финальные комнаты.
- Материалы в `room_window_references` можно использовать только как
  структурные/геометрические references для room grid, multi-room composition и
  detail-view organization.
- Финальный detailed visual style должен быть оригинальным Shelter visual и
  соответствовать духу проекта. Конкретный style, layout, palette, materials,
  lighting, asset set и production rules остаются решением Art Director и
  пользователя после feature gate.

## 3. Scope

Текущий feature scope:

- одна fixed rooms panel;
- один временный click anchor — accepted Kitchen;
- одна панель визуально представляет будущую планируемую школу;
- preferred first-proof content — classroom + library + laboratory,
  одновременно в одной панели;
- отсутствие внутренних player actions;
- закрытие через `X`;
- проработка окончательной семантики building clicks и empty click;
- оригинальный Shelter room visual после feature gate;
- visual/readability и mechanical verification gates, которые будут уточнены
  до Root review.

## 4. Out of scope

В эту feature-итерацию не входят:

- новое school building или любой новый объект на поляне;
- изменение существующего Kitchen asset или его gameplay-роли;
- полноценная building-to-room система для всего roster;
- room gameplay, dogs assignment, research, production, queues, upgrades,
  decoration, progression или economy;
- переходы внутрь отдельных комнат и отдельные room detail screens;
- drag, pan, zoom, resize, minimize или pin самой панели;
- производство room assets до feature gate;
- копирование CQ или meadow assets;
- implementation plan, Codex brief, code, tests или runtime route;
- изменение текущего Visual Shell Lock, accepted meadow composition или
  Checkpoint 2.

## 5. User flow, states и transitions

Ниже описана только текущая provisional модель. Строки с `UNRESOLVED` нельзя
превращать в implementation contract.

| Current state | Player input | Provisional result | Status |
| --- | --- | --- | --- |
| `CLOSED` | клик по accepted Kitchen | открывается одна fixed panel будущей школы с preferred trio classroom/library/laboratory | accepted direction |
| `OPEN` | клик по `X` | панель закрывается | accepted |
| `OPEN` | клик по любому другому зданию | user intent: панель закрывается | `UNRESOLVED` against current authority |
| `OPEN` | клик по пустому месту поляны | current authority: панель закрывается; новая формула пользователя это явно не подтверждает и не отменяет | `UNRESOLVED` |
| `OPEN` | повторный клик по Kitchen | current authority: no-op; новая grilling-итерация пока не меняла это правило | requires confirmation |
| `OPEN` | действие внутри комнаты | ничего не происходит; интерактивных room actions нет | accepted |

В каждый момент существует не более одной rooms panel. Смысл поведения
последующих room-capable buildings пока не определён этой feature.

## 6. Edge cases и failure cases

- **Другое здание без room visual.** Current authority говорит `no-op`, а новый
  user intent — закрыть панель по клику любого другого здания. До reconciliation
  реализация запрещена.
- **Другое здание с room visual в будущем.** Current authority говорит
  `replace`; новый close intent говорит `close`. Нужен явный ответ: close,
  replace или phase-specific rule.
- **Empty click.** Current authority закрывает панель; новая формула закрытия
  перечисляет только `X` и другое здание. Нельзя угадывать, сохранено ли
  закрытие empty click.
- **Повторный Kitchen click.** Текущий inherited rule — no-op; требуется
  подтвердить его для первого proof.
- **Нет approved room visual.** Feature остаётся заблокированной; нельзя
  подменять комнаты CQ/meadow crops, placeholders, сгенерированным art или
  случайными repo assets.
- **Не помещаются три комнаты.** Нельзя самовольно уменьшать число комнат,
  превращать их в tabs/carousel или ухудшать readability. Вопрос возвращается в
  grilling/Art Director.
- **Viewport/zoom conflict.** Placement, size и responsive behavior панели ещё
  не приняты. Панель не может молча менять accepted meadow/camera/zoom contract.
- **Panel-open selection conflicts.** Отношение rooms panel к building
  micro-card, dog badge и правилу «one selected entity» пока не определено.
- **Ошибочная семантика Kitchen.** UI не должен сообщать, что Kitchen стало
  школой; точное labeling/affordance ещё требуется спроектировать.

## 7. Role impacts и ownership

### Князь feature

- продолжает тот же единственный `/grilling` lineage;
- задаёт пользователю вопросы из раздела 12;
- координирует Game Designer и Art Director без передачи им княжеского титула;
- обновляет только эту canonical specification;
- после завершения grilling возвращает её Root/King на review.

### Game Designer

- закрывает UX transitions и связь с selection/panel rules;
- не выбирает final art style, palette, prompts или asset pipeline.

### Art Director

- только после feature gate определяет оригинальный Shelter room visual,
  layout/readability, production feasibility и asset rules;
- не меняет building-click mechanics или product scope.

### Project Manager

- синхронизирует уже принятые решения и conflicts с current authority;
- не решает их вместо пользователя, Game Designer или Root.

### Codex

- не планирует и не реализует feature до отдельного принятого Codex brief после
  полного feature gate;
- не создаёт room assets и не принимает product/game/art decisions.

### User и Root/King

- пользователь остаётся authority для product/art и final visual decisions;
- Root/King после чтения завершённой specification выдаёт или отклоняет
  cross-stream `ROOT-APPROVED`.

## 8. Constraints и dependencies

- `PROJECTS_RULES.md` и `AGENTS.md` feature/grilling/root-gate governance.
- Текущий `Visual Shell Lock → Interactive Shelter Shell` порядок не меняется.
- Accepted Kitchen и accepted meadow используются только в их текущем
  утверждённом виде.
- Room panel является inspect/detail layer, а не interior main-strip background.
- Main meadow остаётся самостоятельным accepted visual surface; rooms feature не
  переписывает её assets или composition.
- CQ остаётся reference для harmony/readability, но не asset source.
- `room_window_references` ограничены structural/geometry use.
- Art production зависит от завершённого feature gate и отдельного visual
  ownership.
- Implementation зависит от последующего bounded Codex brief и independent
  verification.

## 9. Unresolved questions

Блокирующие завершение `/grilling`:

1. Является ли «ровно три комнаты одновременно» hard requirement или preferred
   target с допустимым fallback?
2. Должен ли клик по любому другому зданию закрывать панель, даже если у здания
   нет room visual?
3. Когда в будущем другое здание получит room visual, его клик закрывает текущую
   панель или сразу заменяет её?
4. Сохраняется ли закрытие по empty click?
5. Остаётся ли повторный клик по Kitchen no-op?
6. Как rooms panel сосуществует с anchored building micro-card, dog badge и
   правилом one selected entity?
7. Как игроку ясно сообщается, что Kitchen — только текущий click anchor, а
   панель показывает будущую школу?
8. Каковы accepted placement, geometry, size и responsive rules на
   min/default/max window sizes и zoom `50/100/150/200`?
9. Нужны ли в статическом proof собаки или purely ambient animation, либо панель
   полностью неподвижна?
10. Какой minimum визуального evidence нужен пользователю и Art Director для
    acceptance первого proof?

## 10. Acceptance criteria и gates

### 10.1 Grilling completion

Feature может получить `GRILLED-READY-FOR-ROOT-REVIEW`, только если:

- вопросы 1–7 из раздела 9 имеют явные ответы;
- room count и content contract перестают быть двусмысленными;
- close/replace/no-op/empty-click transitions непротиворечивы current authority;
- границы Game Design и Art Direction сохранены;
- acceptance criteria для visual proof и implementation proof записаны;
- все результаты остаются в этом же документе, без второй competing spec.

### 10.2 Root gate

После завершения grilling Root/King:

- читает эту specification;
- либо возвращает её в `GRILLING`;
- либо явно выдаёт `ROOT-APPROVED`.

Без этого art production, implementation planning, Codex brief и code остаются
запрещены.

### 10.3 Future visual gate

После Root approval потребуются:

- original Shelter room assets/layout от Art Director;
- structural use references without asset/style copying;
- readability proof на принятых target sizes/zoom;
- отдельный прямой user visual verdict.

Automatic/mechanical checks не заменяют этот verdict.

### 10.4 Future implementation gate

Только после принятых visual/game contracts:

- отдельный bounded Codex brief;
- scoped author;
- tests/runtime/evidence в объёме принятого brief;
- отдельный independent verifier;
- сохранение всех внешних Visual Shell/CP2 gates.

## 11. Evidence и provenance

### 11.1 Grilling provenance

Текущие решения получены как compact handoff единственного Князя feature
`019f8f5d-dae5-7711-9248-7c20b449ed5a` в Root/King task
`019f8bac-0007-7962-ad8a-ca31fb95ac7f` 2026-07-23.

Зафиксированы только переданные решения: one fixed panel, preferred simultaneous
three-room proof, Kitchen anchor/future-school meaning, no internal action,
current close intent и visual-source boundary.

### 11.2 Existing local authority

- `STEAM_DESKTOP__CURRENT_CONTEXT.md` — current Interactive Shelter Shell panel
  summary.
- `GAME_DESIGN__CURRENT_CONTEXT.md` — current selection, replace/no-op,
  empty-click close и no-room-visual rules.
- `ART_DIRECTION__CURRENT_CONTEXT.md` — visual ownership и запрет room/card/move
  art до соответствующего gate.
- `03_OPEN_QUESTIONS.md`, `OQ-Steam-004` — deferred first-house choice и
  no-room-visual no-op.
- `STEAM_DESKTOP__Building_System_v1.md`, sections 1, 5.7, 9 — anchor + room
  window model, Laboratory/Learning House room set и structural reference use.
- `STEAM_DESKTOP__Dog_Life_Model_v1.md`, section 1 — main strip/detail split и
  lab/classroom/library example.
- `D-011_Steam_Overlay_Main_Strip_v1_Rules.md`, sections 2 and 6.2 — inspect
  views separated from the main overlay.

### 11.3 Structural room references

Все четыре файла ниже являются только structural/geometry references:

| File | Dimensions | SHA-256 |
| --- | ---: | --- |
| `01_yog_sothoth_yard_room_grid_overview.jpeg` | `1280×800` | `0ce285f86a9a2979d4700e9d5eb732d82aa1640d0960072363aa03d117ac300d` |
| `02_yog_sothoth_yard_full_hotel_grid.jpg` | `1920×1077` | `eeb97934bf728153d46ba5c67f8e624edb0dbff2d24f0ab5ff9500788d6b5571` |
| `03_yog_sothoth_yard_room_detail.jpeg` | `1920×1080` | `84c9f2785649b9ece8ae0fa28963b43ba03d1bbe4238438f4e020e1748ffbf27` |
| `04_yog_sothoth_yard_floor_unlock_grid.jpg` | `3840×2160` | `75a261c43ae1bfe119d3580e9d5b098dcc15775f94b0d5d10407a4fcbb3e486c` |

Reference root:

```text
docs/drive/Shelter/03_DESIGN/01_REFERENCES/screenshots/room_window_references/
```

Их содержание не является final tone, style, UI, mechanics или production
asset authority.

## 12. Iterative `/grilling` log и next questions

### Iteration 1 — 2026-07-23 — initial bounded proof

Owner: единственный Князь feature
`019f8f5d-dae5-7711-9248-7c20b449ed5a`.

Записано:

- one fixed authored panel;
- preferred simultaneous trio: classroom, library, laboratory;
- accepted Kitchen как временный click anchor без нового meadow object;
- future-school meaning панели;
- отсутствие room interaction/action;
- user close intent: `X` или любое другое здание;
- original-Shelter-only future asset boundary;
- явный conflict register against current replace/no-op/empty-click authority.

Результат: `GRILLING` продолжается. Root review пока не запрашивается.

### Next grilling questions для того же Князя

Задать пользователю в таком порядке:

1. «Ровно три комнаты одновременно — это обязательное правило первого proof
   или желаемый вариант, который можно менять ради читаемости?»
2. «Клик по любому другому зданию всегда только закрывает панель — даже если у
   здания нет своей комнаты?»
3. «Когда у другого здания появится room visual: один клик закрывает текущую
   панель или сразу заменяет её новой?»
4. «Пустой клик по поляне всё ещё закрывает панель?»
5. «Повторный клик по Kitchen оставляет открытую панель без изменений?»
6. «Что происходит с building micro-card и dog badge, пока room panel открыта?»
7. «Как визуально объяснить временную связь Kitchen → future school, не выдавая
   Kitchen за школу?»
8. После UX-ответов передать Art Director вопросы geometry/readability и
   visual-proof acceptance, не начиная asset production.
