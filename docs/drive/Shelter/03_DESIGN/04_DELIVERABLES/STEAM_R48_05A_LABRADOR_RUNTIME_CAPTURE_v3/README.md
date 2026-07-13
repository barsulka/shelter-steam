# STEAM R48-05A — Labrador Runtime Capture v3

Статус pack: **BLOCKED technical correction evidence / runtime Art owner review pending**.

Этот pack исправляет только замечания независимого Art review v2 внутри принятого
R48-05A. Source package, gameplay timing, task outputs, persistence, PlayerBoot и
window/platform contract не меняются. Historical packs v1 и v2 immutable.

## Что проверяет v3

- uniform positive Labrador runtime scale `0.60`, без negative/non-uniform scale;
- Kitchen anchors `260.4 / 157.2 / 135.6` и Packing anchors
  `260.4 / 150.0 / 127.2` с фактическим contact/work readback;
- First Day `A/B/C_start/C_walk/C_stop/D/E/F`, Day 2 `G`, Quiet, обе стороны
  станций, оба физических root-locked turn, cancellation/recovery;
- четыре normal-speed motion strip с равными timestamp и root-интервалами;
- native и заявленные `216/144/96` review layouts с измеренными subject heights;
- неизменные `legacy_unbound=3` для First Day и Day 2 и
  `transfer_acceptance_cells=0`;
- реальный PlayerBoot desktop window: полная usable ширина текущего display,
  высота `224 px`, размещение по нижнему краю. Full-display composite является
  доказательством extent/placement; exact window-region frame — только честным
  pixel readback этого региона, а не самостоятельным full-width proof;
- один пропорциональный frame с Labrador, Kitchen, Packing Table и van.

На текущем macOS display ожидаемый runtime readback — `2992x224`; источником
истины остаётся `capture_manifest.json`, который записывает фактические window,
usable-rect и bottom-edge значения запуска.

## Technical stop

Фактическая source-envelope проверка дала `STOP_UNSUPPORTED_ACTOR_ENVELOPE`:
non-shadow identity height `225 px` при full-width zoom `2992/1740` и exact
uniform scale `0.60` проектируется в `232.14 px` внутри locked `224 px` window.
Native bbox касается верхнего края. Устранение crop требует хотя бы одного
запрещённого изменения: effective scale ниже `0.60`, PlayerBoot/window height
не менее `233 px`, неполный horizontal fit либо root/baseline drift. Pack
сохраняет этот дефект как evidence и не подменяет его скрытой регистрацией.

## Содержимое и воспроизводимость

`capture_manifest.json`, `runtime_selector_snapshots.jsonl`,
`trace_excerpt.jsonl`, каталоги `captures/`, логи и `HASHES.sha256` создаются
bounded capture helper:

```sh
steam/tools/capture-labrador-r48-05a.sh capture
steam/tools/capture-labrador-r48-05a.sh validate
```

Mechanical PASS не снимает Technical BLOCKED и не является runtime Art PASS.
