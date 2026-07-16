# STEAM_DESKTOP — Art Source Reconciliation Wave v1 — PM/User Source Acceptance

Дата: `2026-07-13`  
Статус: `ACCEPTED_SOURCE_INPUT / RUNTIME_NOT_YET_EXECUTABLE`  
Владелец решения: `user-owner + Producer / Project Manager`  
Source owner: `Art Director`  
Следующий implementation gate: отдельный `PREPARED` Codex brief и его Technical/PM activation

---

## 1. Принятое решение

Финальный source package:

```text
docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Art_Source_Reconciliation_Wave_v1/
```

принимается как точный Art source input для одной bounded runtime integration
trial. Его structural verdict `SOURCE_RECONCILED` подтверждён, а внешний
PM/User status становится:

```text
ACCEPTED_SOURCE_INPUT / RUNTIME_NOT_YET_EXECUTABLE
```

Это решение принимает source look и разрешает отдельную подготовку promotion
и integration brief. Оно **не** является runtime Art PASS, финальной
пользовательской приёмкой обычного player journey, shipping approval или
разрешением на runtime/code/import mutation.

## 2. Exact final readback

| Файл | SHA-256 |
| --- | --- |
| `README.md` | `8b0c2c7672315453900e062ca65b551e22abcffe8094a62783c53744a2cb76b5` |
| `PROVENANCE.md` | `8253e955def0c1766f21f1db1a71cb18556be57d1341bea0846cdfbbb4c85f80` |
| `REFERENCE_READBACK.md` | `e5a2dfa3d488a361be3b61a4893c9372e29070f797879e9cac85e8d3a32f9cc9` |
| `ART_QA.md` | `3405df1466d8bc821f54eae4874f43bedb384aab011315532ade32d660c88fbe` |
| `SOURCE_MANIFEST.json` | `c825bac41a7721553eb725fb00d14c4e7aba94832ae8ab605db68624e135616b` |
| `QA_REPORT.json` | `a772bf513be1cb251344a902d4303fa61e4805a8aa2660e96b14e4644705654d` |
| `INVENTORY.json` | `e43ec9562333e1ad30ead7be7f83c3484214221b06a4c4f360d84037952c66c3` |
| `HASHES.sha256` | `7abc64cc21025a08312a63a8cfd7486652854f4fdf30d12179fd072161f9600b` |

Final readback:

- total files: `606`;
- ledger: `605/605 PASS`;
- `QA_REPORT`: `157/157 PASS`, `0 FAIL`;
- `34` editable ORA masters;
- `24/24` Labrador pose families;
- `2992×224` authored world and `216/144/96` evidence;
- `__pycache__` / `.pyc`: absent;
- Sheet A: absent / zero reuse.

Финальный `sha256sum -c HASHES.sha256` проходит без missing/mismatch. Source
package после этого readback считается frozen input: PM/Codex не меняют его во
время promotion или runtime integration.

## 3. User-source acceptance и visual advisories

User-owner ранее прямо принял новое visual direction и попросил сохранить его
в approved route. Единственное заявленное опасение касалось визуально непрозрачных
белых cell backgrounds. Финальный readback закрывает эту проблему на source
уровне: белый cell matte, sky matte и speckled alpha удалены; accepted candidates
и full layout являются RGBA с прозрачным upper reserve.

Три Art advisory принимаются `AS_IS` для этой bounded integration trial:

1. **Labrador identity** — допустим чуть более shaggy/Golden-like coat read,
   чем user-owner three-view. Это не разрешение на дальнейший identity drift.
2. **Kitchen detail** — сохраняется detailed service facade, faithful approved
   Kitchen v2.1. Отдельная simplification wave сейчас не запускается.
3. **Mill mass** — сохраняется текущая source mass при declared review height
   `188 px`; Mill остаётся статичным декоративным Utility Prop.

Это `WARN / non-blocking for source integration`, а не молчаливая финальная
runtime acceptance. После actual player capture user-owner может принять
результат либо вернуть точечный `CHANGES_REQUIRED` по dog/Kitchen/Mill read.
Новый широкий pixel-loop без такого capture verdict запрещён.

## 4. Source promotion ownership

Promotion в `approved_art_files/` разрешён, но принадлежит **Art Director** в
отдельном bounded file scope. PM не копирует, не переименовывает и не выбирает
art pixels.

Art promotion owner обязан до записи объявить exact files и затем:

1. перенести только явно принятый source/export subset из frozen package в
   `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/approved_art_files/`;
2. не изменять существующие approved references молча и не удалять history;
3. обновить Art-owned approved-library inventory/provenance:
   `STEAM_OVERLAY__Approved_Library_v1.md`;
4. создать внешний promotion record:
   `STEAM_DESKTOP__Art_Source_Reconciliation_Wave_v1__Approved_Promotion_Record.md`;
5. записать exact source → promoted path mapping, creator/tool/AI/rights
   declaration и SHA-256 всех promoted files;
6. не менять source package, runtime/code/assets или gameplay contracts.

До Art promotion handback source acceptance остаётся действующим, но future
Codex brief не может стать executable.

## 5. Preserved gameplay/runtime boundary

- selector H authority: `SIGNED_GD_PM_TECHNICAL / NOT_RUNTIME_EXECUTABLE`;
- exact manifest SHA:
  `d8f1a9fc9226588097eb7bdfc162b6eff520ef42605b369ba25f906daa52ae56`;
- ровно 12 rows; start/stop/turn — presentation transitions only;
- existing semantic order:
  `Road/Bicycle → Storage → Kitchen → Packing → Van`;
- Mill: static decoration only;
- exact `3 + 2`, resource provenance `x2/x2 → x1/x1`, persisted Day 2
  remainder и Quiet Cooperative сохраняются;
- current runtime look остаётся `CHANGES_REQUIRED` до новой actual integration
  evidence и explicit user/runtime acceptance.

## 6. Hard exclusions

- Sheet A любой формы;
- v6 patch loop;
- R48-05B/P0-C pickup/attach/carry/place/detach/object transfer;
- rooms, onboarding, background/minimize/performance;
- Dachshund/cart behavior и Bicycle choreography;
- новые mechanics/entities/tasks/resources/outputs/inputs/rewards;
- PlayerBoot/save/persistence/33-cursor mutation;
- runtime/import/code mutation до отдельного brief со статусом
  `accepted / executable`.

## 7. Exact next sequence

1. `DONE` — final package integrity and PM/User source acceptance.
2. `PENDING ART` — bounded approved promotion + promotion mapping/ledger.
3. `PREPARED ONLY` — separate Codex integration brief проходит exact-file
   Technical/Codex preflight.
4. Producer/PM отдельно сверяет Art promotion + Technical handback и только
   затем может пометить brief `accepted / executable`.
5. Один Codex writer выполняет bounded integration.
6. Immutable actual runtime captures → independent Art review → explicit
   user-owner runtime acceptance.

