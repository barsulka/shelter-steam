# STEAM_DESKTOP — Codex Brief — Selected H Visual Shell Runtime Integration And Live Matrix v1

Дата: 2026-07-22  
Статус: **ACTIVE — CHECKPOINT 1 USER_ACCEPTED / PASS; D-034 D-030-ONLY 15.0s READINESS-BUDGET AMENDMENT READY FOR INDEPENDENT DOCS VERIFICATION; IMPLEMENTATION / RUNTIME HOLD; CHECKPOINT 2 HOLD**  
Владелец: Project Manager → Codex  
Платформа текущего gate: **macOS only**  
Рекомендуемый уровень рассуждений Codex: **очень высокий**

## 0. Activation boundary

Этот brief является текущей implementation authority. Активирован 2026-07-22
на основании прямого user static PASS, независимого docs/brief `PASS` verifier
thread `019f8669-6a2b-7ba3-931e-be4569a29e9e` и явной coordinator activation
thread `019f856b-060d-7791-8265-a91cd2de4171`. Активация разрешает только
bounded scope этого brief и не отменяет его preflight, stop или user gates.

Static visual authority уже выдана пользователем прямым verdict:

```text
“ШИКАРНО. Принято.”
selected H GRID32 — USER_ACCEPTED / PASS
```

Independent critic перед этим вернул `READY`: финальная grid revision является
точным переносом принятого GRID32 overlay на `+5 px` по Y без других изменений.
Static PASS не является live-runtime Visual Shell Lock. Финальный live visual
verdict после implementation/matrix принадлежит только пользователю.

После retained current-profile matrix пользователь отдельно одобрил D-034:
projected canonical canvas является единственным Selected-H render/pointer
domain; whole-tile overdraw clips at its exact boundary; true viewport exterior
остаётся transparent/click-through; validator проверяет per-column/per-alpha
equivalence без global opaque-fill requirement. Обе active-brief amendments
получили independent docs/brief `PASS` на freeze
`9cd3ac289c90e2c3a4f8dd605b82229118e9f9743ca9c346c5e8cd379dca5e8b`.
Coordinator/Root/King thread `019f8bac-0007-7962-ad8a-ca31fb95ac7f` прочитал
accepted D-034 contract и выдал `ROOT-APPROVED` только для bounded continuation
внутри него. Re-authorization record затем получил independent read-only
`PASS`, но implementation author остановился `BLOCKED BEFORE SPAWN`: unchanged
observer требует system-temp `HOME`/output, тогда как прежний recovery route
разрешал только repo-local temp. Пользователь прямо одобрил Route A evidence
promotion в section 12.1. Последующий least-privilege config/profile experiment
получил independent `PASS CONFIG ONLY`, но named-profile GUI запуски
воспроизвели pre-project AppKit/HIServices `SIGABRT`; это реальное historical
evidence, не D-034 code verdict.

Direct user decision затем изолировал permission/private-tmp diagnosis в
отдельную non-blocking background task и разрешил текущую production wave
«по-старинке» под effective `:danger-full-access` / Full Access. Unchanged
runner может использовать `/private/tmp`; named-profile, Seatbelt,
network-disabled, config/UI/profile precondition отсутствует. D-034 acceptance
contract остаётся controlling. Full Access route-reset docs получили
independent `PASS DOCS ONLY`. Два последующих one-shot production runs
остановились real `rc74`/ineligible на spawn-anchored `6.0s` readiness budget
во время здорового capture progress: сначала `19/24`, затем `23/24` после
bounded performance bugfix. Оба результата сохраняются как history, не PASS.

Пользователь прямо одобрил exact `15.0s` D-030-only readiness maximum:
`«Одобряю. Я бы даже 15 секунд сделал — чего нам жалеть-то? 5 секунд погоды не
сделают»`. Budget действует только для governed Selected-H
current-presentation route/profile, остаётся spawn-anchored и возвращает
успешную readiness немедленно. Implementation/runtime остаются `HOLD` до
independent docs `PASS` и bounded Root re-dispatch той же production-author
task `019f8ee0-1cd9-76e0-846d-58184b4d945a`. Checkpoint 2 остаётся `HOLD`.

## 1. Goal

В bounded wave:

1. воспроизвести в обычном Steam/Desktop Godot runtime ровно принятый selected H
   static contract;
2. полностью убрать legacy fence/boundary, polygon Dachshund и debug/artifact
   visuals из active runtime, не ломая hash-pinned historical evidence bytes;
3. сохранить D-030 zoom/window mechanics и существующие gameplay/persistence
   regressions без нового видимого gameplay;
4. показать пользователю частые парные checkpoints `GRID + CLEAN`;
5. после mechanical verification и отдельного visual critic провести полный
   live `min/default/max window × 50/100/150/200% zoom` user gate.

Результат этой волны — только faithful live Visual Shell. Cards, rooms, move и
Interactive Shelter Shell здесь не начинаются.

## 2. Read first

Читать полностью в указанном порядке:

```text
PROJECTS_RULES.md
AGENTS.md
steam/AGENTS.md
steam/README.md
docs/drive/Shelter/00_START_HERE/000_ROLE_CODEX.md
docs/drive/Shelter/00_START_HERE/01_CURRENT_STATUS.md
docs/drive/Shelter/00_START_HERE/02_DECISIONS.md (D-027..D-034)
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__CURRENT_CONTEXT.md
docs/drive/Shelter/03_DESIGN/ART_DIRECTION__CURRENT_CONTEXT.md
docs/drive/Shelter/03_DESIGN/00_VISUAL_DIRECTION/STEAM_DESKTOP__Visual_Production_Roadmap_v1.md
docs/drive/Shelter/04_DEVELOPMENT/CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md
docs/repo/status/CODEX_CURRENT_STATUS.md
docs/repo/adr/README.md
docs/repo/adr/0001-use-godot-for-steam-desktop.md
docs/repo/adr/0002-game-state-as-source-of-truth.md
docs/repo/adr/0004-godot-child-observability-and-graceful-termination.md
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__D030_Fixed_26_Cell_Meadow_Zoom_And_Click_Surface_v1.md
this brief
```

При конфликте brief с authority/Accepted ADR остановиться. Accepted ADR,
D-024 sealed brief/packs и Labrador/R48 protected evidence не менять.

## 3. Canonicality and non-canonical acceptance trace

`tmp/` не является canonical evidence и не является runtime dependency. Ни один
runtime path не должен читать перечисленные ниже файлы. Их hashes фиксируют
прямой user-review trace; воспроизводимая норма находится в разделах 4–9 этого
brief и в tracked source assets.

| Trace artifact | SHA-256 |
| --- | --- |
| `tmp/visual-shell-lock-selected-H-grid32-shift-down-5-opW7LX/art_selected_H_grid32_shift_down_5_y441_472_2992x480.png` | `50f03e09dc7095c909262b8a092be0f7f6feefdb88a6b9eaf367eb25f928182d` |
| `tmp/visual-shell-lock-selected-H-grid32-shift-down-5-opW7LX/clean_selected_H_no_grid_2992x480.png` | `00d744288a87b3b850629de66e1afa4801e9cf40389e83c929c04cddf8946fce` |
| `tmp/visual-shell-lock-selected-H-grid32-shift-down-5-opW7LX/comparison_selected_H_grid32_shift_down_5_and_clean_3200px.png` | `2b266497727d8384776e8706f94993c82375cc73e9e2b1d4fc48d85818e33935` |
| `tmp/visual-shell-lock-selected-H-grid32-shift-down-5-opW7LX/selected_H_grid32_shift_down_5_manifest.json` | `82ffe0ced14ac584ff439130edc870e9d6bb24fa1701a7791b0b39569d57b9f0` |
| `tmp/visual-shell-lock-selected-H-grid32-shift-down-5-opW7LX/build_selected_H_grid32_shift_down_5.py` | `aa110fa71267d62a487535368b289b4a1ae28e2e3f7f5430f24db96eca620009` |

Binary promotion не требуется: все принятые source pixels уже tracked и
hash-пинятся ниже. Если faithful implementation неожиданно требует копирования
PNG/compositor/manifest из `tmp`, остановиться и предложить пользователю точный
минимальный promoted package; самостоятельно ничего не копировать.

## 4. Accepted tracked sources

До и после implementation вычислить SHA-256. Любой mismatch — `STOP`, не
самостоятельная замена или redraw.

| Runtime/art source | Required SHA-256 |
| --- | --- |
| `steam/assets/prototypes/vertical_slice/authored/world/responsive/meadow_pattern_26_cells_1664x941.png` | `3816aa11aa7cd0b8e6f46d857d0ec89badd08597122439150403de39f4298203` |
| `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Art_Source_Reconciliation_Wave_v1/exports/labrador/poses/idle_neutral_right/composite_with_shadow_rgba.png` | `099fdf27606cc3d64bd923775627e7dff6fd0f04c0791e20618c874fc06cd8e2` |
| `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Art_Source_Reconciliation_Wave_v1/exports/world/assets/road_sign.png` | `dee133ecea707cb0d4b93948b6685410ea3715e8ea822b2149fcb51ec2413015` |
| `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Art_Source_Reconciliation_Wave_v1/exports/world/assets/bicycle.png` | `211b6c12774bf1170bf16c108e6dbada2d35a8da69fecb8656508e85695756c5` |
| `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Art_Source_Reconciliation_Wave_v1/exports/world/assets/storage.png` | `e86d627be61379dd0312b2ad033ea70baaf70798067222b39ae9a21f2d4fc20b` |
| `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Art_Source_Reconciliation_Wave_v1/exports/world/assets/mill_static.png` | `a1063aaa1f44c414fb52268f5c727e0d4b777b24ebbe9e075e180bf5ab936570` |
| `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Art_Source_Reconciliation_Wave_v1/exports/world/assets/kitchen.png` | `954cb90139c49f2390c5d5aae6190935936b513e3bd71c94011c10047d89e688` |
| `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Art_Source_Reconciliation_Wave_v1/exports/world/assets/packing_utility.png` | `5b20dbb82ec37ee151e941c72075c7c7aec7abb04c8f177e29f167f9122ad625` |
| `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Art_Source_Reconciliation_Wave_v1/exports/world/assets/van_endpoint.png` | `f7b79ae3d70b0d45ff10009cf1547f6d56cdbeb9beb1ebe91fe736c8915125d7` |

Новые art assets, generation, redraw, fill, inpainting, palette correction,
non-uniform squash/stretch и substitute pixels запрещены.

## 5. Coordinate and background contract

Canonical design canvas: `2992 × 480`, origin top-left, X rightward, Y downward.
Все ranges/bboxes ниже half-open, если явно не сказано `visible rows`.

Accepted default framing is the full source canvas `[0,2992) × [0,480)` with
horizontal center `x=1496`. Runtime использует существующий D-030 uniform zoom
и camera/pan contracts; window resize меняет crop/visible extent, но не scale,
asset positions, layer phase или relative geometry. Не добавлять fit-to-window,
per-window relayout или optical compensation. Если существующий source→runtime
bridge не может однозначно воспроизвести этот design-space contract, STOP и
вернуть точный конфликт вместо нового transform assumption.

### 5.1 Background Wave03 H hybrid

Derived accepted background pixel SHA-256:
`840bbc58cf4205835e6498c0eb4b29ff0dccedba944d0d470081f35fad6db5bc`.

| Semantic band | Inclusive visible Y | Height |
| --- | ---: | ---: |
| unsquashed trees/back environment | `216..345` | `130` |
| back lawn | `346..366` | `21` |
| irregular path envelope | `367..404` | `38` |
| foreground lawn | `405..415` | `11` |
| visible earth/underground | `416..479` | `64` |

Tree layer:

- uniform scale `0.78`; non-uniform resize forbidden;
- scaled tile `1298 × 734`;
- horizontal phase `-210`, tile origins `[-210,1088,2386]`;
- projected source crop Y `[179,309)` → destination Y `[216,346)`, vertical
  translation `+37`;
- derived tree-layer pixel SHA-256
  `1bb781811215eb409b20c39e90ce467de264b5e83548679f82d9bc191a6c9620`.

Lower layer:

- uniform scale `0.62`, horizontal phase `-167`;
- preserve Y `[346,480)` with no exception mask;
- derived lower-layer pixel SHA-256
  `ff5564e4188fcc8b0662140a0139d519068ff4f42e1145e12b06b5bd771e273a`.

### 5.2 Projected-canvas render/pointer boundary — D-034

Canonical design X-domain is exactly half-open `[0,2992)`. For every actual
viewport, `projected_canvas_interval` is the exact projection of that domain
intersected with the viewport. Selected-H render and pointer domains both equal
that interval.

Background, earth, grid and roster output must be clipped at the exact projected
canonical boundary. Whole background tiles may implement the accepted pixels
inside the canvas, but no whole-tile overdraw or other render output may escape
the canvas. Arbitrary composition extension is forbidden.

Viewport exterior outside `projected_canvas_interval` remains actually
transparent and click-through. Inside the interval every actual visible-alpha
pixel/column is covered by pointer; transparent sky above the local alpha top
passes through. No visible alpha may lack pointer, and no true-exterior pixel or
column may be clickable. The common boundary is exact, not a `4 px`
sampled-lattice approximation or tapered edge.

For `default × 50%` the exact contract is:

```text
projected/render/pointer interval = [0,870)
transparent exterior             = [870,1280)
```

D-030 full-width tiling is narrowly superseded only for this Selected-H
low-zoom exterior rule. This does not change accepted source pixels, hashes,
bands, grid, roster, geometry, depth, pivots or default/100% Checkpoint-1 PASS.

## 6. Roster, depth, scale and placement

Exact render order:

```text
storage → mill_static → kitchen → packing_utility
→ road_sign → bicycle → van_endpoint → labrador
```

| ID | Depth plane | Scale | Authored center X | Full-canvas bbox | Exclusive visible alpha-bottom |
| --- | --- | ---: | ---: | --- | ---: |
| `storage` | rear building | `1.0208` | `690` | `[482,94,897,367)` | `367` |
| `mill_static` | rear building | `0.86` | `1150` | `[1048,35,1252,367)` | `367` |
| `kitchen` | rear building | `0.88` | `1726` | `[1534,81,1918,367)` | `367` |
| `packing_utility` | rear building | `0.946` | `2128` | `[1986,144,2270,367)` | `367` |
| `road_sign` | middle static | `0.7392` | `145` | `[99,245,191,386)` | `386` |
| `bicycle` | middle static | `0.8064` | `420` | `[326,255,514,386)` | `386` |
| `van_endpoint` | middle static | `0.9632` | `2670` | `[2486,193,2853,386)` | `386` |
| `labrador` | front | `0.46` | `1390` | `[1318,291,1461,402)` | `402` |

Rear→middle exclusive-bottom gap is `19 px`; middle→front gap is `16 px`.
Overlap of Storage/Bicycle is an accepted depth cue, not a collision error.

### 6.1 Y authority

Y placement derives only from each resized object's last nonzero-alpha row:

```text
top_y = target_exclusive_alpha_bottom - local_exclusive_alpha_bottom
```

Targets are exactly `367 / 386 / 402` by plane. Canvas bounds, node origins,
texture padding and opaque-top rows may differ; none replaces exclusive visible
alpha-bottom as Y authority.

### 6.2 Horizontal authored pivot authority

Building X is anchored by stable authored/full-canvas placement pivot at the
footprint midpoint. Visible-alpha bbox center is forbidden as runtime X
authority. Painted optical asymmetry must not be compensated.

For positive design coordinates the accepted deterministic raster snap is:

```text
footprint_center_x = (left_boundary + right_boundary) / 2
integer_pivot_x = floor(footprint_center_x)
```

| Building | Cells | Span | Mathematical center | Required integer pivot |
| --- | --- | --- | ---: | ---: |
| Storage | `4..7` | `[460,920)` | `690` | `690` |
| Mill | `9..10` | `[1035,1265)` | `1150` | `1150` |
| Kitchen | `13..16` | `[1496,1956)` | `1726` | `1726` |
| Packing | `17..19` | `[1956,2301)` | `2128.5` | `2128` |

Maximum `0.5 px` residual is accepted raster quantization and passed the narrow
centering audit; it is not drift.

## 7. Static GRID32 contract

This is the final contract. Do not derive or recover a prior candidate.

- earth band `[416,480)`, height `64`;
- grid band `[441,473)`, visible rows `441..472`, height `32`;
- top/bottom earth margins `25 / 7`;
- one row, N=`26`;
- cell inset `2 px`;
- empty fill/stroke RGBA `[117,117,117,204]` / `[158,158,158,204]`, stroke
  `2 px`;
- occupied fill/stroke RGBA `[107,235,61,209]` / `[151,241,119,209]`, stroke
  `3 px`;
- houses remain normal accepted pixels; occupied houses are not ghosts.

Exact horizontal boundaries:

```text
[0,115,230,345,460,575,690,805,920,1035,1150,1265,1380,
 1496,1611,1726,1841,1956,2071,2186,2301,2416,2531,2646,
 2761,2876,2992]
```

Occupied indexes:

```text
[4,5,6,7,9,10,13,14,15,16,17,18,19]
```

Footprints: Storage `4`, Mill `2`, Kitchen `4`, Packing `3`. Empty/occupied
cells not listed above must not be reclassified.

Derived accepted overlay pixel SHA-256:
`b5ecdbcc3793fef6acd7b2d9929583a1454fbbc58eeb3f897d28f9ca325ef7dc`.
`GRID` and `CLEAN` may differ only inside `[2,2990) × [441,473)`; expected
nonzero-difference pixel count is `92416`, and difference outside grid Y is `0`.

This 26-cell static placement row is its own accepted visual/occupancy contract.
Do not silently recompute its boundaries from D-030's separate 26×32 meadow
texture-period math.

## 8. Legacy exclusions

Active runtime must contain none of:

- legacy fence/boundary marker visuals;
- polygon/legacy Dachshund;
- debug overlays, old grid candidates or visual artifacts;
- hidden duplicate legacy nodes behind selected-H layers.

Removal means no active load, instance, draw, collision, hit or pointer-surface
effect. Do not merely cover or alpha-hide legacy visuals. Exact D-024/R48
evidence bytes and hash-required source paths remain untouched even when their
assets are no longer bound to the active runtime.

## 9. Window, zoom and camera review matrix

Use the current supported macOS width profiles:

| Profile | Required width authority | Height authority |
| --- | --- | --- |
| `min` | current `MIN_SIZE.x = 720` | dynamic content height, never below current min `180`; record actual readback |
| `default` | current design/default width `NORMAL_SIZE.x = 1280` | dynamic content height; record actual readback |
| `max` | current `DisplayServer.screen_get_usable_rect(...).size.x` | dynamic/clamped to usable rect; reference host expected width `2992`, record actual |

At every profile run zoom `50 / 100 / 150 / 200%`. The result is 12 live
states. Window resize must never rescale assets or change design coordinates;
only existing uniform zoom may change scale. Default camera/crop is derived from
the accepted full-canvas framing and stays deterministic. Manual pan remains
available and is returned to default before each capture.

At every state derive the exact `projected_canvas_interval` from the actual
viewport and design transform, then prove render/pointer equivalence under
section 5.2. A low-zoom state may contain true transparent exterior; it must not
be rejected merely because opaque content does not fill every viewport column.

For every live state produce both:

1. `GRID` — exact accepted grid visible;
2. `CLEAN` — only that grid layer disabled, all other pixels/state identical.

Thus the final matrix contains at least 24 direct runtime captures. No
player-facing grid toggle is added by this brief. Use a bounded existing
test/evidence state; if obtaining CLEAN requires new MCP, generic control,
gameplay state or infrastructure, STOP.

## 10. Mandatory frequent user checkpoints

Each checkpoint is a stop gate and must show **both GRID and CLEAN** captures:

1. background bands, earth and exact GRID32 at default width/100%;
2. full roster, scales, render order, X pivots and alpha-bottom Y anchors at
   default width/100%;
3. legacy exclusion and default camera at min/default/max width/100%;
4. complete 12-state window/zoom matrix.

Do not continue across a user-requested correction. Any requested pixel,
asset, footprint, scale, depth or framing change leaves this brief and returns
to Art/User decision before implementation resumes.

## 11. Verification and acceptance separation

The following verdicts are distinct and must be recorded independently:

1. implementation author mechanical result;
2. independent mechanical verifier result;
3. separate visual critic result;
4. final direct user live visual gate.

Mechanical automation may prove hashes, geometry, processes and regressions. A
visual critic may return readiness/critique. Neither may emit final visual
`PASS`. Project Manager, Art Director, Codex and coordinator also cannot replace
the user's verdict.

## 12. Allowed change zones

### Code/resources — only as needed

```text
steam/scripts/prototypes/vertical_slice/vertical_slice_demo.gd
steam/scenes/prototypes/vertical_slice/vertical_slice_demo.tscn
steam/scripts/prototypes/vertical_slice/labrador_visual_adapter.gd
steam/scenes/prototypes/vertical_slice/labrador_visual_adapter.tscn
steam/scripts/player/player_boot.gd
steam/scenes/player/player_boot.tscn
steam/resources/prototypes/vertical_slice/d024_responsive_presentation_v1.json
steam/tests/vertical_slice_visual/
steam/tests/launch_surfaces/
```

Touch the smallest subset. Do not edit unrelated gameplay/state/save files.
Existing D-024/Labrador protected evidence, sealed packs and validators are not
inside this allowed mutation scope. Before changing any old visual test, prove
it is not hash-pinned; otherwise add a current selected-H test or STOP.

The bounded D-034 correction and in-spec performance bugfix exist at pending
hashes:

```text
vertical_slice_demo.gd
  959660edfdace6a6325cc68c3240464e7099ba2c5eb0a97e13e51676cf02e974
test_d030_selected_h_current_presentation.py
  a1e17b2de75090bf66513c457e08b702d2988b18c8fa16495817593eca59e74c
```

The performance delta is limited to `_d034_image_profile_metrics` and its
deterministic differential fixtures. It proved exact D-034 field equivalence
and unchanged common PNG bytes, but remains pending complete runtime/mechanical
verification.

After docs `PASS`, the only additional tracked delta allowed is the smallest
route-specific runner/observer/profile wiring needed to pass exact `15.0s`
readiness budget to this D-030 current-presentation route. No shared/global
timeout broadening is authorized. If no narrower mechanism exists, `STOP`
before write and return options.

### Assets

No art asset bytes may change and no new art asset may be added. The nine paths
in section 4 are read-only inputs. Active runtime references to legacy assets
may be removed; hash-required legacy bytes remain on disk.

### Documentation/evidence

```text
docs/repo/status/CODEX_CURRENT_STATUS.md
this brief (status/result only)
unique system-temp working root only when unchanged observer requires it
verified repo-local tmp/<unique-selected-h-live-run>/ for verifier handoff
```

No new dashboard, evidence-pack graveyard, catalog, ADR or handoff is created.
Current production author has zero tracked write ownership and does not update
these docs; any status/result write is a separately assigned docs-owner wave
after runtime/mechanical handback.

### 12.1 D-034 Route A boundary

Direct user/Root authority разрешает unique system-temp `HOME`/output только как
transient unchanged-observer working area. До independent verification complete
raw/evidence tree обязан пройти section 4.2A active D-032 brief: source retained
→ full copy into unique repo-local `.partial` root → deterministic
path/kind/size/SHA-256 inventories → exact byte/readback match → final rename.
Только verified repo-local copy eligible для verifier. Любой
copy/hash/readback mismatch даёт `STOP`/ineligible; partial promotion,
evidence loss и retry-to-pass запрещены.

Project-scoped named profile из section 4.2A был реализован и independently
получил `PASS CONFIG ONLY`; его `:tmpdir`/`:slash_tmp`, network-disabled и
effective-profile evidence остаётся исторически действительным. Два
named-profile GUI запуска воспроизвели pre-project AppKit/HIServices `SIGABRT`.
Они не подавляются и не становятся retroactive D-034 code verdict.

Для current production wave direct user/Root authority узко supersede этот
permission prerequisite: effective `:danger-full-access` / Full Access
разрешён и требуется, `/private/tmp` разрешён unchanged runner, а
named-profile, Seatbelt, network-disabled, config reload, UI/profile selection
и effective-profile readback не являются preconditions. Это не расширяет
allowed tracked files кроме exact narrow readiness-wiring scope выше, не
меняет Steam binary, argv, network use, product/art/runtime contract или
acceptance.

Exact readiness amendment for this current-presentation route is `15.0s`
spawn-anchored maximum. Successful readiness returns immediately; this is not a
fixed wait. Exact `12/12`, `24/24`, atomic matrix finalization, readiness token,
strict validator, process/diagnostic/supervisor, suites, protected,
evidence/promotion and independent mechanical gates remain mandatory. The
amendment never permits tolerance, suppression, allowlist, reduced workload,
retry-to-pass or reinterpretation of either historical `rc74` run.

## 13. Explicit out of scope

- production/economy/gameplay output or mechanic changes;
- cards/badges, rooms panels or room art;
- building Move, ghost, foundations, boxes, smoke, carriers or placement logic;
- dog behavior/state expansion beyond preserving current Labrador presentation;
- new assets, asset generation, redraw, inpainting, palette or silhouette work;
- Browser, Mobile, Windows implementation/QA/evidence;
- new MCP, connector infrastructure, generic shell/control or capture route;
- save/schema/checkpoint/persistence changes;
- D-024 pack/brief/validator or Accepted ADR mutation;
- commit, push or PR unless separately requested.

Windows is a later pre-release target and is neither a warning nor a blocker for
this macOS-only gate.

## 14. Required implementation checks

Before any Godot spawn, follow D-028/D-029/ADR-0004 fail-closed preflight:
exact Steam-managed Godot path/version, canonical `steam/project.godot`, fixed
profile/argv, raw stdout/stderr retention, natural finite-test exit and graceful
ACK for long-lived player. No alternate binary, PATH fallback, headless visual
substitution, SIGABRT/SIGKILL or arbitrary argv.

Minimum author-side mechanical checks:

1. pre/post SHA audit for all section-4 sources and protected-path no-diff;
2. Godot import/script-check via the fixed project supervisor;
3. targeted selected-H contract test for canvas bands, all 27 grid boundaries,
   occupied indexes, colors/strokes/inset, scale/placement/depth and X/Y anchors;
4. exact per-column/per-alpha proof that render and pointer equal the projected
   canonical domain, including default × 50% `[0,870)` plus transparent exterior
   `[870,1280)`, with no overdraw, uncovered alpha, exterior pointer or taper;
5. proof that GRID/CLEAN difference is confined to the accepted grid band;
6. proof that active scene has no legacy visual/node/pointer effect;
7. existing relevant PlayerBoot, zoom/window, Labrador route and
   gameplay/persistence regression tests without rewriting immutable evidence;
8. actual window-size/camera/zoom readback for all 12 states;
9. static proof that exact `15.0s` is wired only into the D-030
   current-presentation route and no shared/global or other-profile timeout
   changes;
10. `git diff --check` and exact changed-scope audit.

A governed diagnostic match, including any recurrence of the historical
CA/certificate error, produces diagnostic `FAIL` and blocks capture/evidence.
Do not allowlist or suppress it. Preserve raw process result separately from
diagnostic verdict.

Visual evidence uses only the approved internal Godot viewport/capture route;
system Screenshot UI is allowed only when the native window/system context is
actually required. No third capture route, generated frame or headless/dummy
visual evidence.

Known pre-existing protected-validator drift from before this brief must be
reported separately and not silently fixed or presented as selected-H
regression: D-024 PNG-count `44 != 43` and old Labrador pins/counts.

## 15. Stop conditions

Stop without workaround if any of the following occurs:

- any accepted source/output/contract hash or protected path differs;
- faithful runtime needs new/substitute/redrawn art or binary promotion;
- implementation needs to change accepted canvas bands, grid band/boundaries,
  occupancy, footprints, colors, scale, roster, render order, depth gaps,
  pivots, alpha-bottom anchors or default framing;
- optical silhouette asymmetry appears to require a visible-alpha X center or
  manual per-window offset;
- any render output escapes `projected_canvas_interval`, any visible alpha lacks
  pointer coverage, true exterior is clickable or the common boundary tapers;
- exact D-034 equivalence would require extending composition beyond the
  canonical canvas or changing accepted art/geometry;
- a required window/zoom cannot preserve the composition;
- legacy visuals can only be covered rather than removed from active runtime;
- CLEAN/GRID capture requires new MCP/infrastructure/player-facing toggle;
- gameplay, save/schema, cards, move or rooms work becomes necessary;
- a process/diagnostic gate fails or a child remains alive after governed stop;
- Route A promotion неполна либо source/copy inventory, SHA-256 или byte
  readback не совпадает;
- production author не работает под explicitly authorized effective
  `:danger-full-access`, появляется interactive approval либо требуется менять
  config/UI/profile или execution route;
- an Accepted ADR, D-024 sealed byte/path or Labrador/R48 pin would need change;
- concurrent/foreign changes appear in the allowed write scope;
- the user or visual critic requests a contract-changing art correction.

Return exact evidence and request the corresponding Art/Product/User decision.

## 16. Completion criteria

Implementation can be handed to independent verification only when:

- runtime faithfully matches sections 4–9 with no `tmp` dependency;
- every state proves exact projected-canvas render/pointer equivalence with no
  overdraw, uncovered alpha, exterior pointer or sampled/tapered boundary;
- all four paired user checkpoints were shown and no unresolved correction
  remains;
- author mechanical checks pass with raw outcomes;
- all 24 matrix captures exist as 12 exact GRID/CLEAN pairs with actual
  window/zoom/camera readback and SHA-256;
- protected bytes are unchanged and legacy visuals are absent from active
  runtime;
- gameplay/persistence behavior and scope remain unchanged;
- `docs/repo/status/CODEX_CURRENT_STATUS.md` is updated without claiming user
  live PASS.

Then run an independent mechanical verifier and a separate visual critic. Only
after both handbacks are available present the matrix to the user. The final
state remains `READY FOR USER LIVE VISUAL GATE` until the user directly accepts.

## 17. Required status handback

Update only `docs/repo/status/CODEX_CURRENT_STATUS.md` with:

- exact implementation files and scope rationale;
- source/protected SHA audit;
- commands, raw exits and separate process/diagnostic verdicts;
- checkpoint and 12-state GRID/CLEAN paths, SHA-256 and actual dimensions;
- legacy-removal evidence;
- independent mechanical verifier status;
- separate visual critic status;
- user verdict, only if directly received;
- blockers/open questions and frozen git fingerprint.

Never collapse `mechanical PASS`, `critic READY` and `USER_ACCEPTED` into one
status.

## 18. Checkpoint 1 implementation result — 2026-07-22

Evidence provenance in this section was rejected by the first independent
mechanical verifier and is superseded by section 19. The PNG bytes remain a
pixel reference only; they were not valid proof of permanent ordinary-player
state because their capture setter also hid UI.

Implementation is intentionally stopped at the first mandatory gate. The
ordinary macOS player now renders only the selected-H background bands, earth
and exact GRID32 in the checkpoint-1 world branch; checkpoint-2 roster work has
not started. The existing `SOURCE_WORLD_TO_RUNTIME = 1740/2992`, D-030 zoom and
camera state are preserved.

Paired direct internal-viewport evidence at `default / 100% / camera=0`:

```text
GRID  tmp/selected-h-live-checkpoint-1-EcYiSd/checkpoint1_default_100_grid.png
      1280×280 RGBA
      ffe37df57f6cb04ad8bbb27ba105c01db7fef26ea77ba81e62604447fb892385
CLEAN tmp/selected-h-live-checkpoint-1-EcYiSd/checkpoint1_default_100_clean.png
      1280×280 RGBA
      4b0a98b19cd2dd60710523d5319c789cf2d044e3ad5dfaad35aa9d6b53b2f456
```

Mechanical readback: actual window `1280×280`, design origin
`[0,0.8556149732620497]`, scale `0.5815508021390374`; pair diff bbox
`[1,257,1280,276)`, `23427` pixels and `0` pixels outside allowed projected
grid rows `[257,276)`. Non-canonical detail:
`tmp/selected-h-live-checkpoint-1-EcYiSd/checkpoint1_mechanical.json`, SHA-256
`98c5cb233c3399aeb9617356e5e04e1d7c696a511a33228a1bab8d941e249227`.

Exact Steam Godot version/import/final script-check/capture player/final player
passed governed process and diagnostic gates; long-lived player stopped by
project quit with ACK. All section-4 sources match and protected paths have no
diff. A separately-run unchanged D-024 scene regression failed 16 legacy
framing/passthrough assertions (`supervisor_rc=73`); no workaround, allowlist or
protected-evidence mutation was made.

This is `READY FOR USER VISUAL GATE`, not a visual PASS. No checkpoint-2 work,
matrix, independent mechanical verification, critic verdict or user live PASS
is claimed.

## 19. Checkpoint 1 A/B remediation result — 2026-07-22

Independent mechanical verifier `019f8a6c-9ae0-7850-b193-9c093e92aff3`
returned `FAIL` on two findings: the old capture setter mutated UI state, and
the permanent selected-H route hid legacy drawing without deactivating legacy
loads/pointer surfaces. No checkpoint-2 work followed.

Same-session bounded remediation:

- permanent selected-H ordinary player owns `_ui_hidden=true`; gameplay cards
  and controls have measured visible count `0`;
- grid evidence setter changes only grid visibility;
- selected-H load route binds only the accepted meadow texture; marker,
  semantic/world-layer and Labrador-pose binding counts are all `0`;
- selected-H pointer polygon is derived from a `2992`-sample alpha-top profile
  of the actual background mapping; legacy pointer records and old D-030 alpha
  profile samples are `0`;
- render bindings are measured after a real frame as
  `selected_h.background + selected_h.grid`; roster/legacy draws are `0`;
- active runtime resource count is `1`, with `0` tmp dependencies.

Fresh permanent-state evidence at `default / 100% / camera=0`:

```text
GRID  tmp/selected-h-live-checkpoint-1-remediation-0CS3mk/checkpoint1_remediation_default_100_grid.png
      1280×280 RGBA
      ffe37df57f6cb04ad8bbb27ba105c01db7fef26ea77ba81e62604447fb892385
CLEAN tmp/selected-h-live-checkpoint-1-remediation-0CS3mk/checkpoint1_remediation_default_100_clean.png
      1280×280 RGBA
      4b0a98b19cd2dd60710523d5319c789cf2d044e3ad5dfaad35aa9d6b53b2f456
```

The new hashes intentionally equal the old pair because the visual pixels did
not change; the permanent runtime state and evidence provenance did. Pair diff
is `[1,257,1280,276)`, `23427` pixels, `0` outside `[257,276)`.
Mechanical detail:
`tmp/selected-h-live-checkpoint-1-remediation-0CS3mk/checkpoint1_remediation_mechanical.json`,
SHA-256 `ab65833e56e50bde1fcceca19f59d1c2f228a0fd83a11986c768ca8d25b20622`.

Fresh exact-Steam supervisor version/import/script-check/capture-player/final
permanent-player processes are diagnostic `PASS`, supervisor `0`, with graceful
quit ACK for players. D-024's separate 16-assertion D-030↔D-024 authority
conflict remains unchanged and unallowlisted.

The author A/B remediation is complete. Independent mechanical verifier
`019f8a6c-9ae0-7850-b193-9c093e92aff3` reran against the permanent-state route
and returned `PASS`. Independent visual critic
`019f8a6c-d059-73f3-9dde-a0ee66581c7c` returned `READY` for direct checkpoint-1
comparison. These remain separate verdicts.

The user then directly answered `“Принимаем”`. Checkpoint 1 — selected-H
background + earth + GRID32 at `default / 100% / camera=0` — is therefore
`USER_ACCEPTED / PASS`.

Exact fresh evidence root and hashes:

```text
root   tmp/selected-h-live-checkpoint-1-remediation-0CS3mk/
GRID   checkpoint1_remediation_default_100_grid.png
       ffe37df57f6cb04ad8bbb27ba105c01db7fef26ea77ba81e62604447fb892385
CLEAN  checkpoint1_remediation_default_100_clean.png
       4b0a98b19cd2dd60710523d5319c789cf2d044e3ad5dfaad35aa9d6b53b2f456
MECH   checkpoint1_remediation_mechanical.json
       ab65833e56e50bde1fcceca19f59d1c2f228a0fd83a11986c768ca8d25b20622
```

The user explicitly approved D-032 Route 1. The unchanged D-024 run remains a
real governed `FAIL`/ineligible result and is never allowlisted, suppressed or
counted as PASS; the active current profile replaces it as the current
applicability gate. Checkpoint 2 remains `NOT STARTED / HOLD` until the active
D-030/Selected-H regression-profile brief completes bounded implementation and
its current pre-checkpoint-2 gate receives independent mechanical `PASS`.
Checkpoint-1 user acceptance still does not grant the full live Visual Shell
Lock.

## 20. D-034 active-brief amendment — docs only — 2026-07-22

After D-033 re-authorization, the retained ordinary-player current-profile run
completed all `12/12` states and `24/24` GRID/CLEAN captures with governed
child/process/diagnostic/supervisor `0 / PASS / PASS / 0`. Root:
`tmp/d030-current-presentation-hHYpjj9z/`; process-result/matrix/25-entry
manifest SHA-256 values are respectively:

```text
2552fa49701d66ef63cb5312abf1ee9507f781e5e9851c8fb10359ffd39d9069
88e0112f9d0eb23ffd0b57ee05a1ff4c78cc485be4517270f844d9b0f1127e01
e0d45dc18cd365281604924c670f9b2a3eb89416e81e60001854f2e66c8b3745
```

The runner exited `1` on its strict validator at `default × 50%`. Actual window
was `[1280,180]`; projected canonical interval `[0,870)`; retained captures have
whole-tile visible alpha through `[0,1152)` and true transparent exterior
`[1152,1280)`, while pointer coverage ends at the canonical projection and has
a `4 px` sampled taper. This is both an invalid global viewport-fill assertion
and a real render/pointer mismatch. The executed validator result remains real
`FAIL`/ineligible and is never retroactive `PASS`.

The user approved D-034 and the exact section-5.2 contract. This amendment
preserves every accepted source/pixel hash, geometry, depth, GRID32 value and
Checkpoint-1 PASS. Both active-brief amendments independently passed docs/brief
verification at freeze
`9cd3ac289c90e2c3a4f8dd605b82229118e9f9743ca9c346c5e8cd379dca5e8b`.
Coordinator/Root/King thread `019f8bac-0007-7962-ad8a-ca31fb95ac7f` then read
the accepted contract and recorded `ROOT-APPROVED` bounded continuation for the
same implementation session `019f8a55-019b-7690-b624-b860b136ff3c`. That
future dispatch may change only bounded Selected-H render/pointer/seam in
`vertical_slice_demo.gd` plus the current D-032 validator; runner, observer,
protected D-024, tooling, assets, gameplay/save, roster and Checkpoint 2 remain
unchanged/forbidden. The re-authorization record passed independent read-only
verification, but the author then stopped `BLOCKED BEFORE SPAWN` on the
repo-temp/system-temp contract conflict. No Godot child was started and the
blocked attempt remains real evidence, never retroactive PASS.

The user approved Route A evidence promotion in section 12.1. The later
least-privilege config/profile `PASS CONFIG ONLY`, named-profile
AppKit/HIServices `SIGABRT` reproductions and all earlier failures remain real
historical evidence without reclassification.

The user's direct production route reset removes permission diagnosis from the
D-034 critical path, isolates it in a separate non-blocking background task and
authorizes effective `:danger-full-access` / Full Access with unchanged
`/private/tmp` runner behavior. This docs-only recording is `READY FOR
INDEPENDENT DOCS VERIFICATION`; runtime stays `HOLD` until that `PASS` and Root
re-dispatch of production-author task
`019f8ee0-1cd9-76e0-846d-58184b4d945a` with zero tracked write ownership.
Frozen demo/validator/runner/observer bytes remain controlling. The first actual
runner/process/validator/suite/protected failure remains a one-shot `STOP` with
no retry.
After bounded implementation, a fresh governed `12/12` state / `24/24` capture
run, relevant suites, Route-A evidence integrity/promotion and separate
independent mechanical verification are required. This is not implementation/
profile PASS or Checkpoint-2 authorization. Full live Visual Shell Lock remains
`OPEN / NOT GRANTED`; Checkpoint 2 remains `NOT STARTED / HOLD`.

Full Access route-reset docs later received independent `PASS DOCS ONLY`.
The first governed production run stopped `rc74`/ineligible at `19/24`
captures when the spawn-anchored `6.0s` readiness budget expired during
continued progress. A bounded in-spec performance bugfix retained exact D-034
metrics and byte-identical common PNGs at pending hashes:

```text
vertical_slice_demo.gd
  959660edfdace6a6325cc68c3240464e7099ba2c5eb0a97e13e51676cf02e974
test_d030_selected_h_current_presentation.py
  a1e17b2de75090bf66513c457e08b702d2988b18c8fa16495817593eca59e74c
```

Its one re-authorized run advanced to `23/24` but again stopped `rc74` before
the final CLEAN capture, atomic matrix and readiness token. Both timeout runs
remain historical FAIL/ineligible, unpromoted and unretried; neither is a
mechanical or visual verdict.

The user's direct amendment now makes exact `15.0s` the spawn-anchored maximum
only for the governed D-030 current-presentation route. After independent docs
`PASS`, the same implementation author may add only narrow route-specific
wiring, rerun static/protected gates and execute exactly one Full Access
production run. Global timeout broadening, reduced workload, tolerance,
suppression, allowlist and retry-to-pass remain forbidden. Checkpoint 1 stays
`USER_ACCEPTED / PASS`; full live Visual Shell Lock stays `OPEN / NOT GRANTED`;
Checkpoint 2 stays `NOT STARTED / HOLD`.
