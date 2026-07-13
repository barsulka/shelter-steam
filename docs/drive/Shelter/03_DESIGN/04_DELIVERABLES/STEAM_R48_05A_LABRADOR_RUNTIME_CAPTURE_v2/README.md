# STEAM R48-05A — Labrador Runtime Capture v2

Статус pack: **technical correction evidence / runtime Art review pending**.

Этот pack является bounded correction к immutable historical capture v1 после
`CHANGES_REQUIRED` владельца runtime Art. Он не меняет accepted source wave,
gameplay timing, tasks, outputs, persistence или object-transfer boundary.

## Что доказывает v2

- полный player framing коридора `x=0..1740`: authored source `0..1536` без
  растяжения и явно non-authored runtime tail `1536..1740`;
- uniform positive Labrador scale `1.0` вместо отклонённого trial `0.25`;
- exact pixel-height readback после заявленного ресемпла player layout в
  `216/144/96`;
- равномерные 1x start/walk/stop strips, обе стороны станций и оба физические
  root-locked поворота через authored `turn_mid`;
- Kitchen `E`, Packing `F`, Day-2 focus `G`, contact/cancellation/recovery;
- неизменные `legacy_unbound` negatives и `transfer_acceptance_cells=0`.

`capture_manifest.json`, `runtime_selector_snapshots.jsonl`,
`trace_excerpt.jsonl`, каталоги `captures/` и `HASHES.sha256` генерируются
bounded capture helper. Механический PASS не является runtime Art PASS.

## Воспроизводимость

```sh
steam/tools/capture-labrador-r48-05a.sh capture
steam/tools/capture-labrador-r48-05a.sh validate
```

Pack v1 и его `OWNER_REVIEW.md`/`HASHES.sha256` не перезаписываются.
