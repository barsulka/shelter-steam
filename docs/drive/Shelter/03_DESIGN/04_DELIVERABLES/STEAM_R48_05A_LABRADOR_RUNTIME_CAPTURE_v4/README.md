# STEAM R48-05A — Labrador Runtime Capture v4

Статус pack: **Technical BLOCKED / runtime Art owner review pending**.

Этот pack проверяет exact Art-owner decision
`A) ACCEPT_BOUNDED_SCALE_ENVELOPE` внутри существующего R48-05A brief:

- uniform positive Labrador scale `0.24` для right/left/turn_mid;
- реальный `2992x224` full-width bottom-hugging PlayerBoot window без изменения
  PlayerBoot/platform/root/baseline;
- Kitchen starting anchors `104.16 / 62.88 / 54.24`, Packing
  `104.16 / 60.00 / 50.88` и только bounded contact-registration readback;
- native и `216/144/96` complete-bbox, height и edge-margin measurements;
- First Day A–F, Day 2 G, Quiet, обе стороны станций, оба turn, четыре
  normal-speed strips, cancellation/recovery, legacy negatives и zero transfer;
- full-display/window-region transparency proof и proportional
  Labrador+Kitchen+Packing+van frame.

`capture_manifest.json` является источником фактических измерений и Technical
verdict. Предсказанные `92.855172 px` не считаются measured acceptance.

Exact scale `0.24` оставляет idle A полностью внутри frame: native bbox
`91 px` с top/bottom margins `98/35 px`, declared full-layout resamples
`89/59/39 px` при `216/144/96`. Но hard height gate должен выполняться и для
work/focus evidence. Он не выполняется:

- synthetic Kitchen E: `74/49/33 px`;
- First Day Kitchen E: `76/52/35 px`;
- Day 2 focus G: `73/49/32 px`;
- требование: не меньше `80/52/35 px`.

Обе стороны station contact механически зарегистрированы: Kitchen muzzle gap
`3.714207 px`, Packing `2.063448 px`; muzzle и working paw находятся внутри
accepted contact plane. Дополнительно from-right Packing имеет запрещённое
перекрытие torso с `world.fence.front_span`: `167` native screen pixels / `890`
source-alpha samples. На ближайшем разрешённом registration boundary
`-2.88 world` остаётся `124/653`; первый source-alpha clear probe требует
`-15.95 world` и разрушает contact до muzzle gap `29.490115 px`.

Поэтому pack fail-closed фиксирует `STOP_UNSUPPORTED_ACTOR_ENVELOPE`. Scale,
root/baseline, PlayerBoot/window, authored z-owner и animation/gameplay timing
не менялись и не подгонялись повторно. Mechanical PASS не является runtime Art
PASS; `OWNER_REVIEW.md` остаётся `PENDING_OWNER_REVIEW`.

## Воспроизводимость

```sh
steam/tools/capture-labrador-r48-05a.sh capture
steam/tools/capture-labrador-r48-05a.sh validate
```

Packs v1/v2/v3 и source package immutable.
