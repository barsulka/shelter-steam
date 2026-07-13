# STEAM R48-05A — Labrador Runtime Capture v1

Статус pack: **mechanical PASS / runtime Art review pending / overall WARN**.

Этот persistent pack фиксирует bounded no-transfer R48-05A в обычном `PlayerBoot`-owned First Day и Day 2 runtime. Он не является Art PASS, production-art approval или object-transfer acceptance.

## Authority и воспроизводимость

- Godot: `4.7-stable (steam)`;
- native renderer: macOS / Metal / Apple M3 Pro;
- runtime authority: `godot_state`;
- captured build commit: `cecca23925b84685f927f56dbe78c90e50cd4e79` с ожидаемо dirty implementation worktree;
- accepted Labrador authority SHA-256: `afedb0185cff0c56963e566ff846a479437bf37950d8b38bc84380781015b3b8`;
- runtime binding SHA-256: `e816ea33f75d5079f7b81e6a8722989d49da5c35cffdc1b8b26594771786891e`;
- station binding SHA-256: `7ecce592238cce1f174a7fdf206aaea506e0e28ecf118f872a90a709b0c9823e`.

Повторный capture и mechanical validation:

```sh
steam/tools/capture-labrador-r48-05a.sh capture
steam/tools/capture-labrador-r48-05a.sh validate
```

## Состав evidence

- `capture_manifest.json` — exact build/authority/binding hashes, selector counts и явный `runtime_art_approval=PENDING_OWNER_REVIEW`;
- `runtime_selector_snapshots.jsonl` — 786 read-only runtime observations First Day и Day 2;
- `trace_excerpt.jsonl` — bounded presentation markers без gameplay output;
- `captures/first_day/`, `captures/day2/`, `captures/quiet/` — ordinary player journey evidence;
- `captures/synthetic_sides/` — read-only presentation fixtures для обоих направлений и обеих сторон Kitchen/Packing;
- `captures/cancellation_recovery/` — before-contact cancellation, stale suppression, loop-boundary G, save-failure suppression и clean retry;
- `captures/motion/` — 28 normal-speed phase-0 кадров;
- `captures/previews/{216,144,96}/` — ресемплы фактического player layout;
- `captures/silhouettes/` — native stills того же layout с чёрной модуляцией только imported Labrador layers;
- `HASHES.sha256` — хэши всех файлов pack, кроме самого списка.

Pack содержит 265 capture-файлов. Synthetic-side, silhouette и cancellation/recovery сценарии являются только read-only presentation evidence и не изменяют gameplay, task, checkpoint или persistence authority.

## Границы

- authored coverage ограничен exact A–G;
- `UnloadTask`, `CarryTask`, `LoadVanTask` остаются ровно в `legacy_unbound` primitive lane;
- object-transfer acceptance cells, sockets и pickup/attach/carry/place/detach claims отсутствуют;
- Packing Table и Kitchen остаются принятыми временными runtime anchors, а не финальным station Art;
- механические валидаторы не оценивают эстетику;
- владелец Art должен отдельно заполнить `OWNER_REVIEW.md`.

