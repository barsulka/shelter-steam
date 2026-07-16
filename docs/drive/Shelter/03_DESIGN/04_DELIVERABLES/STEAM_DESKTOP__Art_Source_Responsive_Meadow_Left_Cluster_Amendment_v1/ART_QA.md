# Art QA — D-024 Responsive Meadow Amendment v1

Verdict: `SOURCE_AMENDMENT_READY / SOURCE_ONLY / NOT_RUNTIME_EXECUTABLE`.

Machine report: `QA_REPORT.json` — `48/48 PASS`.

## Actual visual readback

Проверены фактические RGBA, checker и black composites, не только JSON-метрики:

- `2992×224`, `3456×224`, `3840×224`: default и right-end;
- 3× repeat meadow на transparent/checker/black;
- marker на checker/black;
- resamples 216/144/96;
- frozen accepted layout vs D-024 comparison.

Результат:

- hard vertical seam, белых/чёрных matte rectangles, alpha fringe walls, прозрачных дыр и non-authored tail не видно;
- faint lower trees/shrubs сохраняются как слабый depth и не превращаются в opaque background;
- meadow остаётся continuous на всей ширине и повторяется, а не растягивается;
- buildings, Road/Bicycle, Mill, Packing, Van и Labrador появляются ровно по одному разу;
- справа от marker нет зданий, dog activity или другого exterior content; machine pixel-difference bbox = `null` для всех шести responsive cells;
- marker читается как внешний декоративный предел, не перекрывает игровое поле opaque body и не требует runtime mirror;
- на 216/144/96 сохраняются Labrador silhouette, semantic order и marker read; dog action corpus не менялся.

## Numeric gates

- Meadow tile: `748×224 RGBA`, alpha bbox `[0,92,748,224]`.
- Exact edge region: 8 px; `left/right RGBA max delta=0`, `alpha max delta=0`, immediate repeat boundary delta `0`.
- Four periods: `4×748=2992 px` и `4×435=1740 world units`.
- Reserve: `14.988426–15.006684%`, принятный диапазон `13–17%`.
- Right-end source proof: `camera_x=82.8571428571`, при этом boundary остаётся около 85% viewport.
- Marker: `174×106 RGBA`; alpha bbox `[0,0,174,106]`; opaque functional body bbox `[9,25,150,77]`.
- Marker exterior proof: opaque body world x starts at `1745.2339572192514 ≥ 1740`.
- Transform: positive uniform `0.5815508021390374`; runtime mirror=`false`, negative scale=`false`.

## Responsive boards

- `evidence/responsive/viewport_2992x224__default/right_end__{rgba,black,checker}.png`
- `evidence/responsive/viewport_3456x224__default/right_end__{rgba,black,checker}.png`
- `evidence/responsive/viewport_3840x224__default/right_end__{rgba,black,checker}.png`
- Полные измерения: `evidence/responsive/RESPONSIVE_MEASUREMENTS.json`.

На 3840 width-derived zoom обычным образом отсекает верх уже принятого static art в 224-px viewport. Это не hole/stretch/crop meadow source и не исправляется этим bounded amendment; runtime/vertical-fit acceptance остаётся последующему Technical + Art capture gate. Пакет не выдаёт runtime PASS на основании source boards.

## Stop-condition readback

- New entity/mechanic/room/transfer: нет.
- Labrador identity/action change: нет.
- CQ/Screenshot pixel or style reuse: нет.
- Sheet A: zero reuse.
- Runtime/frozen/approved/doc writes outside package: нет.
- Full-width meadow без stretch/crop/gutter: PASS.
- Marker positive/exterior/no-mirror: PASS.

## Remaining gates

1. PM/User source acceptance этого amendment.
2. Отдельный accepted Codex brief и Technical preflight/PM activation.
3. Runtime import/integration без изменения D-024 semantics.
4. Immutable responsive captures, независимый runtime Art review и explicit user acceptance.

