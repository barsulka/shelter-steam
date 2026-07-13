# Steam/Desktop — Art Reconciliation: Dog, Buildings, Meadow v1

- Дата: `2026-07-13`
- Owner: `Art Director`
- Product: `Shelter Steam/Desktop`
- Статус: **PREPARED_FOR_PM_ACCEPTANCE**
- Вердикт подготовки: **PREPARED**
- Исполнимость: **NOT EXECUTABLE**
- Тип: Art-owned reconciliation brief + reference package
- Write scope этой волны: только этот package

## 1. Назначение и граница

Этот package фиксирует прямое решение user-owner после визуального отклонения
текущего runtime v5 и подготавливает точную базу для отдельной Art source wave.
Он не является production-артом, Codex brief, runtime implementation authority,
разрешением на импорт ассетов или Art PASS текущей игры.

Текущий общий визуальный статус остаётся:
**CHANGES_REQUIRED / USER_OWNER_REJECTED_CURRENT_LOOK**. Отдельный bounded v5
Technical Art gate по масштабу `0.24`, контакту, Packing mask, A–G, turns,
recovery и zero transfer остаётся **PASS**, но используется только как
регрессионная база поведения.

## 2. Authority и reconciliation статуса

Прямое решение user-owner от `2026-07-13` фиксирует:

1. D-011 — канонический target всей Steam/Desktop main-strip сцены.
2. Весь каталог `approved_art_files/` — каноническая approved visual library.
3. Approved Labrador Watering direction верен.
4. Пользовательский three-view Labrador — канонический identity reference.
5. Sheet A с SHA-256 `c0dd9f6aded7b06ba1fd4e551edda76315a5307c5ced02058a62d1fa689cbc42`
   полностью отвергнут и не может использоваться ни целиком, ни частями.

Старые документы называли D-011 и Approved Library «approved as direction,
not final production exports». Новое решение не делает PNG-файлы готовыми
runtime/source masters, но повышает их визуальные цели до **канонических для
reconciliation**. PM acceptance этого package должна зафиксировать именно эту
иерархию статусов; откат к mood-only трактовке запрещён.

Точные пути, SHA-256, размеры, статус и роль каждого reference находятся в
[`REFERENCE_MANIFEST.json`](REFERENCE_MANIFEST.json). Происхождение
пользовательского PNG и неизвестные поля честно зафиксированы в
[`PROVENANCE.md`](PROVENANCE.md).

## 3. Канонический target сцены: D-011 целиком

Канонический target:
`approved_art_files/D-011_steam_overlay_main_strip_v1_reference.png`, SHA-256
`bde69388b337f1b7b158f35958a3a740953d58816bffd4d51fff5920d54ae508`.

D-011 принимается не как абстрактное правило spacing, а как полный visual
target main strip:

- связная тёплая поляна вдоль нижней кромки;
- едва заметные деревья и кустарниковый дальний слой внутри нижней сцены;
- низкая базовая линия, органические контактные островки, земля и трава;
- правильный ритм `module → pause → dog action → module → pause → van`;
- спокойная плотность без пустой платформы и без декоративной деревни;
- крупные читаемые собаки относительно низких функциональных модулей;
- взаимный масштаб и пропорции построек, собак, предметов и фургона;
- собаки и действия важнее фасадной детализации;
- верхний desktop reserve остаётся прозрачным/пустым: едва заметные деревья
  являются частью нижней полосы, а не непрозрачным полноэкранным background.

D-011 HUD не является частью production art и не должен вшиваться в сцену.
Этот package не вводит новый глобальный style/palette lock: он восстанавливает
fidelity к уже одобренным target-ам.

## 4. Approved visual library — вся, без неоднозначных файлов

Все 11 файлов каталога `approved_art_files/` перечислены в manifest и считаются
каноническими references visual language, масштаба и качества. В частности:

- Mill v2 — Utility Prop;
- Storage v2 — Building;
- Kitchen v2.1 — Building;
- Water Station v2 — Utility Prop;
- Decor Workshop v2 — Utility Workbench;
- Dachshund Cart, Labrador Watering и Husky Painting — Dog Action Sprites;
- readability sheet — evidence поведения библиотеки на `216/144/96`;
- D-011 — full-scene composition target;
- `image.png`, SHA-256
  `f63159790080725ecbf2537b72432f1ca0ea782366935c63cfc8112351a891cc`,
  — **approved Mill + Dachshund scene evidence**: мельница как тонкий
  функциональный вертикальный акцент, такса с тележкой, мешки, контактная
  поляна и корректная взаимная шкала. Имя файла не снижает и не скрывает его
  роль.

Approved library показывает канонический visual language, но сама по себе не
даёт права добавлять новые mechanics, tasks, actions, buildings или roster.
Прямой follow-up user-owner делает одно точное исключение: **Approved Mill
входит в current scene как статичный декоративный Utility Prop**. Он не является
interactive station, task/resource/output/progression owner, не имеет input,
selectors или contact mechanic. Dachshund Cart, Husky Painting, Water Station и
Decor Workshop не входят в current literal roster/behavior только потому, что
находятся в библиотеке.

## 5. Канонический Labrador identity

Identity target образуют два обязательных и совместных reference:

1. `STEAM_OVERLAY__dog_action_labrador_watering_can__approved_direction.png`,
   SHA-256
   `b7f116605d27bf551fb0b4319c579671b9a0f696fa0d097fe221cf1b439e04d7`;
2. [`references/user_owner/STEAM_DESKTOP__Labrador_Identity_Three_View__User_Owner_Reference.png`](references/user_owner/STEAM_DESKTOP__Labrador_Identity_Three_View__User_Owner_Reference.png),
   SHA-256
   `5cfffc7a32717346183b035feb00b4d429f7197381513758c831c4e69a3db1c6`.

Three-view задаёт устойчивую identity в левом, правом и фронтальном чтении;
Watering direction задаёт действие, материал, дружелюбный характер и
совместимость с approved library.

Непереговорные признаки:

- естественная мягкая анатомия и ощущение шерсти, не геометрическая сборка;
- крупный спокойный Labrador с крепким корпусом и широкой грудью;
- умеренно широкая округлая голова, мягкий незаострённый muzzle;
- естественные висячие уши;
- правдоподобные длина и масса лап, крупные устойчивые paws;
- прямой/мягко опущенный выразительный хвост с живым меховым краем;
- тёплый кремово-золотистый coat, мягкая светлая грудь без жёсткой наклейки;
- спокойный, добрый, собранный character;
- identity сохраняется в обоих facing, physical turn, idle/wait,
  start/walk/stop, contact, Kitchen/Packing work и focus.

Ни Watering PNG, ни пользовательский RGB PNG нельзя объявлять layered editable
master. Будущая source wave должна создать честный редактируемый layered source
с прозрачными lossless exports, pivot/baseline/contact truth и физическим turn;
negative-scale shortcut запрещён.

## 6. Текущий v5 — только regression evidence

Current v5 geometric Labrador, текущий world strip и видимые semantic/code-drawn
placeholder buildings/stations **не являются каноническими визуальными
target-ами**. Это относится к плоскому геометрическому силуэту Labrador,
разреженной длинной платформе, текущей fence/ground композиции и
прямоугольному Packing placeholder.

Из v5 сохраняются только проверяемые регрессии:

- A–G selectors и ordinary-speed motion;
- оба facing и оба physical-turn направления;
- root/baseline/no-crop truth при принятом bounded scale;
- Kitchen/Packing approach/contact/work/exit;
- muzzle + working paw contact и Packing selector-local mask;
- cancellation/recovery;
- legacy-unbound negatives;
- zero transfer acceptance.

Эти факты не доказывают natural Labrador identity, D-011 fidelity,
production-building Art PASS, `prototype look resolved` или user acceptance.

### 6.1 Current vs later user-owner scope lock

Сейчас восстанавливаются базовая графика и уже заложенные mechanics; расширение
идёт позже отдельными волнами.

**Current / in scope:**

- Approved Mill буквально присутствует в сцене только как статичный
  декоративный Utility Prop без interaction/station/task/resource/output/
  progression/input authority;
- Labrador остаётся первой и единственной живой собакой;
- базовый спокойный read: Labrador неторопливо ходит туда-сюда по living strip,
  сохраняет естественный масштаб, читаемый силуэт и физически разворачивается;
- Art фиксирует внешний вид, маршрутный ритм, масштаб и читаемость, но не
  изобретает selectors/states; до executable wave Game Design обязан дать
  bounded selector/guardrails, а затем требуется отдельный Codex brief;
- existing A–G, contacts, mask, turns, recovery, negatives и zero transfer
  остаются единственной текущей behavior regression base.

**Canonical quality reference, но не current literal roster:** approved
Dachshund with Cart. Он не создаёт текущую таксу, тележку, transfer,
choreography или mechanic.

**Later / explicitly out of current scope:** dog pulls/rides with cart, rides a
bicycle, drives a small truck, sits in a large-truck bed, sits at a school desk,
reads in a library, mixes chemicals in a lab, teaches at a blackboard with a
pointer, relaxes in a rocking chair with a book, sleeps, plays with another dog,
chases its tail и любые другие расширенные dog-life states. Никаких новых
mechanics/tasks/resources/rooms/vehicles/transfer сейчас.

## 7. Непереговорные visual targets и DoD пары

| Зона | Canonical target | Что нельзя принять | Side-by-side DoD |
| --- | --- | --- | --- |
| Labrador identity | Watering `b7f116…` + user three-view `5cfffc…` | текущий геометрический v5 dog, перекраска или mascot-like упрощение | source/runtime рядом с обоими references; head, muzzle, ears, tail, legs, coat, silhouette и character совпадают во всех facing/turn |
| Meadow/clearing | D-011 `bde693…` целиком | плоская длинная платформа, пустые провалы, прямоугольные цветовые полосы | full-width кадр рядом с D-011: органические grass/dirt/contact islands, faint trees, плотность, baseline и нижняя визуальная масса совпадают |
| Buildings | D-011 + вся approved library | semantic placeholder как финальный фасад, домики вместо utility props | текущие gameplay entities представлены production-form silhouettes языка библиотеки; mutual scale, spacing и focal hierarchy сверены side-by-side |
| Van endpoint | D-011 van grammar | отдельный фотореалистичный/вырезанный van, не связанный с поляной | van сидит на общем baseline/contact island, остаётся endpoint и не доминирует |
| Packing contact | D-011 taxonomy + approved-library quality + v5 technical mask regression | прямоугольная code-drawn композиция как Art target, torso cut | production-form source читается как Packing function; both-side contact и mask regressions зелёные |
| Upper reserve | D-011 transparent/empty upper 70–80% | непрозрачный fullscreen background | actual desktop composite показывает прозрачный reserve; faint trees не выходят из нижнего living strip |

Сохраняется текущий gameplay entity order:
`Road/Bicycle → Storage → Kitchen → Packing → Van`. Approved Mill добавляется
в визуальный ритм как статичная пауза, **не как gameplay node этого order**.
Изменение gameplay order, буквальное добавление Dog House/Greenhouse/Water
Station/Decor Workshop или новых dog actions требует отдельного PM/Game Design
решения.

## 8. Source wave и integration wave — разные authority

### 8.1 Bounded Art source reconciliation wave

После PM/User pin требуется отдельная Art-owned source wave:

- новый layered editable Labrador, faithfully reproducing Watering + three-view;
- walk/turn source coverage для спокойного back-and-forth read без изобретения
  selector/state contract;
- D-011-faithful full-corridor meadow source: ground, grass/dirt/path,
  contact islands, faint trees/bush depth, fence back/front ownership и
  прозрачный upper reserve;
- production-form editable sources для всех видимых placeholder entities в
  активированном roster, если для них отсутствует принятый editable source;
- Kitchen и Storage опираются на approved directions без молчаливого redesign;
- Packing получает ровно production-form source нужной функции и контакта, без
  новых mechanics/transfer;
- Van/Road/Bicycle остаются только если подтверждены текущим roster; если
  остаются и не имеют production-form source, они также требуют bounded source;
- Approved Mill получает faithful production-form source только как static
  decorative Utility Prop;
- exact pivots, baselines, contact planes, z/occlusion ownership, 216/144/96
  source QA и provenance.

Approved PNG directions используются как fidelity target, не как editable
masters. Flattened AI output запрещено объявлять layered source.

### 8.2 Separate runtime integration wave

Только после Art source review и отдельного принятого Codex brief разрешается:

- импорт approved source exports;
- восстановление D-011 composition, placement, scale, density и z-order;
- статичное размещение Approved Mill без interaction/collision/task authority;
- покрытие полного разрешённого corridor без неавторского tail;
- привязка существующих A–G/turn/contact/mask/recovery contracts;
- спокойный Labrador back-and-forth route только после принятого bounded Game
  Design selector/guardrails;
- immutable runtime captures и независимый Art review.

Integration не может молча менять PlayerBoot/platform behavior, gameplay,
entity taxonomy, task flow, transfer или station function.

## 9. Обязательная staged sequence

1. **PM/User reference pin + scope activation.** PM принимает этот not-executable
   package, фиксирует canonical references, статичный Mill, единственного
   Labrador, текущий gameplay roster/order и ответы на owner questions ниже.
2. **Bounded Art source reconciliation wave.** Отдельный write ownership и
   source brief; никаких runtime/code изменений.
3. **Art source review.** Проверка identity, editable hierarchy, provenance,
   silhouette, contact, D-011 scene grammar и `216/144/96`.
4. **Separate Codex brief в `04_DEVELOPMENT`.** Только принятый executable brief
   создаёт runtime implementation authority.
5. **Immutable captures + independent Art + explicit user acceptance.** Нужны
   actual `2992x224`, native `216/144/96`, motion/contact/negative evidence и
   прямое user-owner visual acceptance.

До принятия шага 4 код, runtime, PlayerBoot, imports и assets не меняются.

## 10. Definition of Done следующей полной reconciliation

- Есть side-by-side sheet: D-011, вся релевантная approved library,
  user three-view Labrador, editable sources и actual runtime.
- Natural Labrador identity совпадает по head/muzzle/ears/tail/legs/coat,
  silhouette, character, обоим facing и physical turn.
- Normal-speed evidence показывает спокойный Labrador back-and-forth read с
  ровным ритмом и физическим turn в рамках принятого Game Design guardrail.
- D-011 meadow, faint trees, building rhythm, scale, proportions, density,
  lower-strip hierarchy и transparent upper reserve воспроизведены.
- Все видимые сущности текущего gameplay order имеют честную production-form
  source основу либо явно исключены PM/Game Design решением.
- Approved Mill видим как тонкий статичный декоративный Utility Prop и не имеет
  station/input/task/resource/output/progression behavior.
- Actual desktop evidence включает `2992x224`; source/runtime readability
  проверена на `216/144/96` с фактическим pixel readback.
- V5 technical regressions остаются зелёными: A–G, motion, turns, contact,
  Packing mask, recovery, legacy negatives, zero transfer.
- Нет новых mechanics/entities/tasks/transfer/rooms/onboarding и нет скрытого
  station replacement claim.
- Независимый Art review пройден.
- **Прямое user-owner visual acceptance получено.** Без него overall Art PASS
  и `prototype look resolved` запрещены.

## 11. Stop conditions

Работа останавливается с точным blocker, если:

- пользовательский temp attachment нельзя побайтно перенести в долговременный
  package или сохранить SHA-256 `5cfffc7…`;
- кто-либо пытается использовать Sheet A `c0dd9f6…` полностью, частично,
  как principle, supporting evidence или target;
- approved direction невозможно честно воспроизвести без отсутствующих
  editable sources, прав или provenance;
- требуется добавить mechanics, entities, actions, taxonomy или изменить
  gameplay roster/order без PM/Game Design решения;
- начинается Codex/runtime/source mutation до Art/PM acceptance и отдельной
  write-authority волны;
- предлагается скрыть несоответствие camera/scale crop, отрицательным scale,
  плоским AI output или ложным Art PASS.

## 12. Unresolved activation questions для PM/Game Design

Решения по static Mill, единственному Labrador и later Dachshund/cart уже
приняты user-owner и не являются открытыми вопросами.

1. Подтвердить, какие из текущих Road/Bicycle endpoints остаются видимыми в
   reconciliation и потому требуют production-form source.
2. Зафиксировать source-rights/provenance route для faithful production of
   approved directions. User approval визуального target не изобретает
   creator, tool, license или editable-source права.
3. Game Design должен до executable brief определить bounded selector/guardrails
   для спокойного Labrador back-and-forth route, не добавляя новые mechanics,
   tasks, resources или life-state catalogue.

## 13. Handoff boundary

Package готов к PM acceptance, но не к исполнению. Следующий owner:
**Project Manager**, затем Art Director под отдельной bounded source wave.
Codex не получает runtime authority автоматически.
