# STEAM_DESKTOP — Art Source Reconciliation Wave v1 — PM Activation

Дата: `2026-07-13`  
Статус: `ACCEPTED_SOURCE_INPUT / RUNTIME_NOT_YET_EXECUTABLE`  
Владелец активации: `Producer / Project Manager`  
Следующий owner: `Art approved promotion + Technical/Codex brief preflight`

---

## 1. Решение об активации

User-owner принял границу «каноническая базовая графика и существующие
mechanics сейчас; широкая жизнь собак позже» и дал явную команду продолжать.
Producer/PM выполнил exact-file readback пакета:

```text
docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Art_Reconciliation__Dog_Buildings_Meadow_v1/
```

Проверенные hashes:

| Файл | SHA-256 |
| --- | --- |
| `README.md` | `89becbabbbd19c6dd9e40747bc46e71a2dafdefdf921fea6022f86b08b9a468a` |
| `REFERENCE_MANIFEST.json` | `f07afd8e6617acd5b38ce488c678d7cb245a9b8a9915effd20484a2e75ebe66d` |
| `HASHES.sha256` | `07fd93e4ee27e190109f80e6b5e32bd66bdf6e3c68bbb806b06ac762db278991` |
| user-owner Labrador reference | `5cfffc7a32717346183b035feb00b4d429f7197381513758c831c4e69a3db1c6` |

`sha256sum -c HASHES.sha256` подтвердил все шесть package entries. Вердикт:
**`ACCEPTED_FOR_ART_SOURCE_WAVE`**. Hash-locked package не изменяется; его
подготовительный статус читается вместе с этой внешней PM-активацией.

Текущий runtime look остаётся
`CHANGES_REQUIRED / USER_OWNER_REJECTED_CURRENT_LOOK`. Активация source-only
волны не является runtime Art PASS и не даёт Codex implementation authority.

---

## 2. Точный видимый scope

1. `D-011` задаёт полную scene grammar нижней living strip, а все файлы
   `approved_art_files/` остаются каноническими visual-language, scale и
   quality targets. Flattened references не объявляются editable masters.
2. Labrador — первая и единственная current living dog. Identity должна быть
   верна совместно user-owner three-view reference и approved Labrador
   Watering direction.
3. Существующий семантический порядок сохраняется:
   `Road/Bicycle anchors → Storage → Kitchen → Packing → Van`. Art может
   восстановить форму, ритм, grounding и читаемость, но не меняет роли,
   gameplay order или runtime semantics этих anchors.
4. Approved Mill входит только как буквальный статичный декоративный
   `Utility Prop`. Его размещение и визуальное решение принадлежат Art, но он
   не получает interaction, station, task, input, resource, output, reward,
   progression, collision или selector authority.
5. Dachshund и cart не входят в current literal roster или behavior. Их
   approved imagery допустима только как quality/scale-language reference.
6. Sheet A SHA
   `c0dd9f6aded7b06ba1fd4e551edda76315a5307c5ced02058a62d1fa689cbc42`
   остаётся hard-excluded с нулевым reuse, включая palette, crop, source,
   principle или derivative input.

Никакая approved decorative imagery не создаёт новую механику, комнату,
vehicle choreography, task, resource, output или entity authority.

---

## 3. Selector H — bounded Producer/PM readback

Exact file:

```text
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Labrador_P0_Accepted_Action_Manifest_v1.md
SHA-256: d8f1a9fc9226588097eb7bdfc162b6eff520ef42605b369ba25f906daa52ae56
```

Readback подтверждает ровно прежние `12` semantic rows. Selector H только
переиспользует `idle.neutral`, `locomotion.start`, `walk_empty`, `stop` и
`turn`. `start`, `stop` и physical `turn` принимаются как bounded presentation
transitions, а не как новые gameplay states или тринадцатая строка.

H разрешает только task-free calm reposition:

- до TripTask, пока существующий offered order ждёт player start gate и нет
  current/queued TripTask;
- либо в restart-stable Quiet Cooperative с completed history и пустыми
  active order/chain;
- только при visible/idle Labrador без current, queued или assigned task;
- `ready_to_send` всегда выбирает selector B calm wait;
- H запрещён во время authoritative trip/task/delivery, incomplete restore,
  save failure, Retry или recovery;
- player gate отменяет presentation phrase до authoritative transition;
- stale/missing predicate fail-closed возвращает selector A idle;
- H создаёт ноль task/event/resource/order/save/reward/progression/output/input;
  presentation-facing cache не сохраняется.

Producer/PM принимает этот bounded H amendment. Technical/Codex exact-file
readback того же manifest SHA завершён как `SIGNED_TECHNICAL`: gameplay и
persistence predicates полны; будущие изменения ограничены внутренним
presentation snapshot/adapter и сами по себе не дают implementation authority.
Exact status: `SIGNED_GD_PM_TECHNICAL / NOT_RUNTIME_EXECUTABLE`. Visual source
coverage walk/turn разрешено готовить сейчас, но runtime binding запрещён до
принятого Art source result и отдельного accepted/executable Codex brief.

Сохраняются D-023 `3 + 2`, resource provenance `x2/x2 → x1/x1`, persisted
Day 2 remainder и Quiet Cooperative без новой progression.

---

## 4. Source/provenance route

Art source wave создаёт новые оригинальные editable/layered production
sources, faithfully reproducing canonical targets. Нельзя молча копировать
flattened pixels из reference PNG в masters или объявлять неизвестные
creator/license/tool данные известными.

Для каждого нового source/export обязательны:

- creator;
- creation date;
- tool/model/version;
- полный AI-use declaration;
- source/reference route;
- license/copyright/right-to-use declaration;
- editable-source и export paths;
- SHA-256 source и exports.

Если faithful production нельзя выполнить законно, честно и с достаточной
provenance, Art возвращает `BLOCKED`; визуальный substitute без owner review
запрещён.

---

## 5. Art source wave DoD

Source wave считается `SOURCE_READY_FOR_ART_REVIEW`, только когда:

- создана editable/layered full-corridor world composition по D-011 с
  прозрачным desktop-owned upper reserve;
- подготовлен identity-stable Labrador для обеих сторон, physical turn и
  принятых 12-row presentation needs, включая визуальное покрытие H без его
  runtime binding;
- Storage, Kitchen, Packing, Van и Road/Bicycle anchors сохраняют текущие
  semantic roles/order и получают faithful production-form sources;
- Mill присутствует только как static decorative Utility Prop;
- pivots, baselines, z-ownership, action/contact anchors и source/export bounds
  задокументированы, но не изобретены из runtime pixels;
- представлены full-strip side-by-side evidence и readability readback на
  `216/144/96`;
- provenance/rights ledger полон, а source/export hashes воспроизводимы;
- Sheet A, Dachshund/cart behavior, новые mechanics/entities/rooms и runtime
  mutation отсутствуют.

Final source review закрыт внешним
`STEAM_DESKTOP__Art_Source_Reconciliation_Wave_v1__PM_User_Source_Acceptance.md`:
P1 приняты as-is для bounded integration trial. Art владеет approved promotion;
separate Codex brief только prepared/not executable. Runtime Art PASS возможен
лишь после integration, immutable captures, independent Art review и explicit
user review.

---

## 6. Stop conditions / out of scope

Art немедленно возвращает `BLOCKED`, если нужны:

- неподтверждённые права или скрытое копирование flattened pixels;
- замена канонического Labrador/мира на иной style target;
- новая gameplay entity, mechanic, room, task, resource, output или input;
- изменение current semantic order/roles или vehicle choreography;
- runtime/code/import mutation либо изменение GD/Technical contracts;
- reuse Sheet A;
- догадка о selector, route bounds, socket/contact или implementation method.

В этой волне запрещены v6 patch loop, R48-05B/P0-C object transfer, rooms,
onboarding, background/minimize/performance, broad dog-life catalogue,
Codex code/assets/evidence и любые commits.

---

## 7. Следующие owners и signer order

1. **Art Director** — следующий Art owner; владеет bounded approved promotion
   и source → promoted path/hash record.
2. **Technical/Codex — `DONE / SIGNED_TECHNICAL`** для exact selector H; это
   не разрешение на runtime mutation.
3. **Technical/Codex** — exact-file preflight prepared integration brief без
   runtime mutation.
4. **Producer/PM** — только после Art promotion и Technical handback может
   сделать brief accepted/executable.
5. **Codex → Art Director → user-owner** — отдельная интеграция, immutable
   runtime evidence, independent Art review и explicit user acceptance.

Producer/PM не выбирает palette, final style, prompts или technical
implementation за Art Director и Technical/Codex.
