# STEAM_DESKTOP — Codex Brief — Accepted Art Source And Labrador H Runtime Integration v1

Дата: `2026-07-13`  
Статус: `ACCEPTED / EXECUTABLE`  
Milestone: `R48-05A source-reconciled runtime integration trial`  
Владелец исполнения: `Codex write integrator — thread 019f5ce4-e63c-7d33-a586-d2d3031c8610`  
Владельцы входов: `user-owner / Producer / PM / Art Director / Game Designer / Technical-Codex`  
Рекомендуемый уровень рассуждений: **очень высокий**

---

## 0. Цель

Заменить user-rejected v5 visual anti-target в обычном First Day + Day 2
PlayerBoot journey на точный принятый Art source input: continuous D-011-like
world, current semantic anchors, static Mill и identity-correct living Labrador
с selectors A–H.

Результат должен работать через обычные F5 / `steam/play.sh`, сохранять одну
gameplay authority и не добавлять механику. Art promotion и exact-file
Technical/Codex preflight приняты; Producer/PM перевёл этот brief в
`ACCEPTED / EXECUTABLE`. Mutation authority принадлежит только указанному выше
Codex writer и только в exact scope этого brief.

## 1. Обязательные источники

Перед preflight и ещё раз перед execution прочитать полностью:

- `PROJECTS_RULES.md`, `AGENTS.md`, `steam/AGENTS.md`, `steam/README.md`;
- `docs/repo/adr/README.md` и все релевантные Accepted ADR;
- D-023 decisions/current status/Steam context/First 48 Hours roadmap;
- `STEAM_DESKTOP__Art_Source_Reconciliation_Wave_v1__PM_User_Source_Acceptance.md`;
- `STEAM_DESKTOP__Art_Source_Reconciliation_Wave_v1__PM_Activation.md`;
- final source package `README.md`, `PROVENANCE.md`, `REFERENCE_READBACK.md`,
  `ART_QA.md`, `SOURCE_MANIFEST.json`, `QA_REPORT.json`, `INVENTORY.json`,
  `HASHES.sha256`;
- `STEAM_DESKTOP__Art_Source_Reconciliation_Wave_v1__Approved_Promotion_Record.md`
  и exact promoted-file ledger;
- `STEAM_DESKTOP__Labrador_P0_Accepted_Action_Manifest_v1.md`;
- `STEAM_DESKTOP__R48_05A_Technical_Activation_Record_v1.md` and completed v5
  brief/evidence only as regression/seam authority, never as visual target;
- applicable dog visual/runtime contracts and
  `shelter-dog-animation-pipeline` skill with all profile-required references.

## 2. Exact accepted source authority

Final package root:

```text
docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Art_Source_Reconciliation_Wave_v1/
```

Pinned authority hashes:

| File | SHA-256 |
| --- | --- |
| `README.md` | `8b0c2c7672315453900e062ca65b551e22abcffe8094a62783c53744a2cb76b5` |
| `PROVENANCE.md` | `8253e955def0c1766f21f1db1a71cb18556be57d1341bea0846cdfbbb4c85f80` |
| `REFERENCE_READBACK.md` | `e5a2dfa3d488a361be3b61a4893c9372e29070f797879e9cac85e8d3a32f9cc9` |
| `ART_QA.md` | `3405df1466d8bc821f54eae4874f43bedb384aab011315532ade32d660c88fbe` |
| `SOURCE_MANIFEST.json` | `c825bac41a7721553eb725fb00d14c4e7aba94832ae8ab605db68624e135616b` |
| `QA_REPORT.json` | `a772bf513be1cb251344a902d4303fa61e4805a8aa2660e96b14e4644705654d` |
| `INVENTORY.json` | `e43ec9562333e1ad30ead7be7f83c3484214221b06a4c4f360d84037952c66c3` |
| `HASHES.sha256` | `7abc64cc21025a08312a63a8cfd7486652854f4fdf30d12179fd072161f9600b` |

Required readback: `606` files, ledger `605/605 PASS`, QA `157/157 PASS`,
no `__pycache__/.pyc` and no Sheet A. Any drift returns `STOP_SOURCE_HASH_DRIFT`.

Exact source inputs:

- `exports/world/world_full_corridor_rgba.png` plus only the semantic world
  assets/layers required by accepted z/contact ownership;
- all 24 accepted `exports/labrador/poses/*/identity_rgba.png` and only their
  required semantic layers/masters from `SOURCE_MANIFEST.json`;
- source world canvas `2992×224`, baseline `y=211`;
- Labrador canvas `512×320`, root `[256,280]`, identity height `225 px`;
- Kitchen/Packing source mappings, both-side contacts and selector H
  route/cadence are accepted only through the exact source-to-runtime
  conversion in §6; source pixels never replace authoritative gameplay state.

## 3. Activation checklist

- [x] final Art package integrity PASS;
- [x] PM/User source acceptance: `ACCEPTED_SOURCE_INPUT`;
- [x] P1 Labrador/Kitchen/Mill advisories accepted as-is for bounded trial;
- [x] selector H owner authority:
  `SIGNED_GD_PM_TECHNICAL / NOT_RUNTIME_EXECUTABLE`;
- [x] Art-owned approved promotion mapping/ledger completed and exact promoted
  hashes read back;
- [x] Technical/Codex exact-file preflight signs import topology, runtime file
  list, A–H adapter/snapshot boundary, source-anchor conversion, captures and
  regression commands;
- [x] PM reads both handbacks and changes this brief to
  `accepted / executable`.

Activation readback:

- pre-activation brief SHA:
  `89e29473c762835c76213a56b06f755cbc087dbd2dec3b15d4f40004cebec1cc`;
- Technical verdict: `SIGNED_TECHNICAL_PREFLIGHT`; no discrepancy outside the
  superseding 2992-source-to-1740-runtime coordinate correction now fixed in §6;
- promotion record SHA:
  `72d46ee230def6028e6986943dc88e942cc8c2023813864e5c784c13caddbab5`;
- promoted full-scene SHA:
  `5f3ea55c54ac12e9460816bf60911c3905eec238c90fb9b9ac1aa30a895e2357`;
- promoted Labrador A–H board SHA:
  `f36a24927e037338bf40e06a2577bced2ddd124aab8940bda23bc1046db4ad4e`;
- both promoted PNGs are direction references only; runtime imports use the
  frozen source package, not these flattened boards.

## 4. Exact gameplay/presentation scope

Actor: `dog.labrador_intro`. Existing 12-row manifest remains exact:

1. `dog.action.idle.neutral`
2. `dog.action.wait.calm`
3. `dog.action.locomotion.start`
4. `dog.action.locomotion.walk_empty`
5. `dog.action.locomotion.stop`
6. `dog.action.locomotion.turn`
7. `dog.action.interaction.approach_target`
8. `dog.action.interaction.contact_align`
9. `dog.action.station.work_loop`
10. `dog.activity.delivery.help_kitchen`
11. `dog.activity.delivery.pack_food_bag`
12. `dog.activity.delivery.pack_carefully_labrador`

Manifest SHA:
`d8f1a9fc9226588097eb7bdfc162b6eff520ef42605b369ba25f906daa52ae56`.

Selectors:

- A — idle;
- B — `ready_to_send` calm wait;
- C — existing Kitchen/Packing station locomotion;
- D — contact-align;
- E — Kitchen work;
- F — ordinary Packing work;
- G — exact Day 2 careful/focus;
- H — task-free calm reposition only pre-TripTask while offered start gate
  waits, or in restart-stable Quiet Cooperative.

H must yield to B, fail closed to A and be forbidden during authoritative
trip/task/delivery, incomplete restore, save failure/Retry/recovery and stale
predicate. Player-gate input cancels H before the authoritative transition.
H creates zero event/task/resource/order/save/reward/progression/output/input.
Any route/facing/timing cache is derived, presentation-only and non-persisted.
Start/stop/physical turn remain presentation transitions, not gameplay states.

## 5. World and visible scope

Required semantic order remains:

```text
Road/Bicycle → Storage → Kitchen → Packing → Van
```

Approved Mill appears between Storage and Kitchen only as static decorative
Utility Prop. No interaction, collision, station, input, selector, task,
resource, output, reward or progression authority is added.

Runtime composition must preserve:

- full authored corridor without non-authored tail;
- transparent desktop-owned upper reserve;
- faint lower trees/shrubs, organic meadow, shared baseline and bounded fence
  front/back ownership;
- source assets for Road sign, Bicycle, Storage, Mill, Kitchen, Packing and Van;
- Kitchen and Packing both-side approach/contact/work/exit;
- only distal contacting paw tips may enter accepted station front occlusion;
  never muzzle/head/chest/torso.

## 6. Accepted import/file envelope

No parallel `v6` tree is allowed. The accepted import topology is one atomic
render lane:

- the 16 full-canvas static layers `source/world/layers/00..09,11..16` from the
  frozen package map one-to-one by exact basename into
  `steam/assets/prototypes/vertical_slice/authored/world/layers/`; layer 10 is
  deliberately omitted from runtime import;
- `exports/world/assets/bicycle.png` maps to
  `steam/assets/prototypes/vertical_slice/authored/world/assets/bicycle.png`;
  this is the only Bicycle texture and uses the existing transport slot/state
  for both exact parked source placement and movement. Its SHA is
  `211b6c12774bf1170bf16c108e6dbada2d35a8da69fecb8656508e85695756c5`;
  parked center is source `x=300.0` → runtime `x=174.465240641711`;
- all 24 `exports/labrador/poses/<pose>/identity_rgba.png` map by exact pose
  basename into
  `steam/assets/prototypes/vertical_slice/authored/dogs/labrador_intro/poses/<pose>/identity_rgba.png`;
- exact source hashes are the entries of pinned `SOURCE_MANIFEST.json` and
  `HASHES.sha256`; `world_full_corridor_rgba.png` is a validation oracle, not a
  runtime texture, and promoted flattened boards are not imported;
- the old 14 world PNG + 48 layered-dog PNG lane and their 62 tracked `.import`
  sidecars are retired in the same atomic wave; the replacement is exactly 41
  PNG and 41 verified `.import` sidecars. No layer 10 runtime texture, duplicate
  Bicycle or second world/dog lane survives.

### 6.1 Accepted source-to-runtime coordinate decision

- keep `WORLD_WIDTH = AUTHORED_WORLD_WIDTH = 1740`;
- set `SOURCE_WORLD_WIDTH = 2992` and
  `SOURCE_WORLD_TO_RUNTIME = 1740/2992 = 0.5815508021390374`;
- every 2992×224 world layer draws with effective
  `SOURCE_WORLD_TO_RUNTIME × player_zoom = 1 screen px/source px`;
- source baseline `y=211` reads at screen `y=211` in the native 2992×224 lane;
- Labrador root remains `[256,280]`, runtime scale remains positive `0.24`,
  screen scale is `0.412689655172414`, and negative scale is forbidden;
- checkpoint payload does not persist dog/transport `world_x` or `ANCHOR_DEFS`;
  restore rebuilds positions from symbolic anchors/pending intents. This is a
  presentation/layout conversion only: no codec/schema/33-cursor migration.

Exact converted anchor centers in runtime units:

```text
Road 75.310828877005
Bicycle 174.465240641711
Storage 355.036764705882
Kitchen 776.661096256684
Packing 1023.529411764706
Van 1395.431149732620
```

Exact Kitchen roots, in order approach/contact/work/exit:

```text
from-left/facing-right 624.004010695187 / 694.371657754011 / 696.697860962567 / 624.004010695187
from-right/facing-left 929.318181818182 / 857.787433155080 / 855.461229946524 / 929.318181818182
```

Exact Packing roots, in the same order:

```text
from-left/facing-right 885.120320855615 / 941.530748663102 / 943.856951871658 / 885.120320855615
from-right/facing-left 1161.938502673797 / 1104.946524064171 / 1102.620320855615 / 1161.938502673797
```

Binding/station JSON must store `source_px`, `runtime_units` and the exact
coefficient. Mill remains world layer 12 only and never enters anchors,
stations, inputs, collision or task authority.

### 6.2 Accepted A–H presentation plan

Safety precedence is: invalid/incomplete durable state → suppressed; exact
legacy transfer → `legacy_unbound`; Cook/Pack → C–G/EXIT; task-free
`ready_to_send` → B; exact task-free H gate → H; otherwise A/fail-closed.

H positive gates remain only durable offered cursors 1/18 before route start,
or durable Quiet Cooperative cursor 33 with completed Day 2 history and empty
active order/chain/task queue. Its cache is adapter-memory-only and is discarded
on selector/epoch/task/gate change.

Exact H route conversion:

```text
source_px [480,2380]
runtime_units [279.144385026738,1384.090909090909]
19 cycles; 58.155080213904 runtime units/cycle; 70.920829529151 units/s
dwell 4.5/8.0 s; turn 0.44 s; start 0.18 s; cycle 0.82 s; stop 0.24 s
```

The player route-gate cancels/traces H before existing authoritative mutation.
No H marker starts/completes gameplay or emits output. Parent custom draw owns
static 00–09, the single existing Bicycle transport slot between static 09 and
11, static 11–15, legacy Dachshund + exactly one Labrador slot, then layer 16
and existing resources/cues. Kitchen/Packing use zero station-front
occlusion in this trial; no un-authored mask is guessed. Validation must fail on
any imported/loaded layer 10, duplicate Bicycle or parked-placement mismatch.

Runtime asset target is limited to the existing area:

```text
steam/assets/prototypes/vertical_slice/authored/**
```

Allowed implementation files/areas after activation:

```text
steam/scripts/prototypes/vertical_slice/labrador_visual_adapter.gd
steam/scenes/prototypes/vertical_slice/labrador_visual_adapter.tscn
steam/resources/prototypes/vertical_slice/labrador_r48_05a_binding_v1.json
steam/resources/prototypes/vertical_slice/labrador_r48_05a_station_anchors_v1.json
steam/resources/prototypes/vertical_slice/labrador_r48_05a_animation_library.tres
steam/tests/vertical_slice_visual/labrador_visual_test_runner.tscn
steam/tests/vertical_slice_visual/test_labrador_visual_binding.gd
steam/tools/validate-labrador-r48-05a.py
steam/tools/capture-labrador-r48-05a.sh
steam/scripts/prototypes/vertical_slice/vertical_slice_demo.gd
steam/scenes/prototypes/vertical_slice/vertical_slice_demo.tscn
```

Technical preflight must state whether accepted pose composites or semantic
layers are imported, provide exact source → runtime paths/hashes, and prove one
render lane. A new path outside this envelope requires STOP and PM scope
reconciliation.

Required post-implementation status/result docs:

```text
docs/repo/status/CODEX_CURRENT_STATUS.md
docs/drive/Shelter/04_DEVELOPMENT/CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md
docs/repo/status/CODEX_STATUS.md
this brief — factual result section only
```

## 7. Explicit no-touch

- final Art source package and accepted/promotion records;
- `approved_art_files/` during Codex implementation;
- `steam/scripts/player/player_boot.gd` and `player_boot.tscn`;
- `steam/scripts/player/player_checkpoint_codec.gd`;
- `steam/scripts/persistence/**`;
- `steam/scripts/game_systems/**`;
- `steam/resources/game_systems/fixtures/**`;
- `project.godot`, F5 main scene and launch topology;
- `steam/play.sh`, `steam/dev.sh`;
- `steam/tools/dev-vertical-slice.sh`, `steam/README.md`;
- player profile/schema/namespace and 33-cursor graph/save barriers;
- connector/control/MCP schemas;
- pickup/attach/carry/place/detach assets/sockets/markers;
- existing immutable v1–v5 evidence packs.

If implementation needs any no-touch path, stop for a new brief/ADR review.

## 8. Definition of Done

- [ ] exact accepted Art/promotion hashes match before and after import;
- [ ] F5 and `steam/play.sh` show one coherent source-reconciled 2992×224 world
  in ordinary First Day, Day 2 and Quiet Cooperative;
- [ ] no white cell background, sky matte, speckled alpha or opaque upper
  reserve appears over actual desktop/checker/black;
- [ ] Road/Bicycle → Storage → Kitchen → Packing → Van order is preserved;
- [ ] Mill is visible, static and creates zero gameplay authority;
- [ ] one Labrador renders exact A–H coverage without negative-scale shortcut,
  duplicate dog or second simulation;
- [ ] both physical turns, start/walk/stop, approach/contact, Kitchen,
  Packing/focus and H read clearly at native `216/144/96`;
- [ ] Kitchen/Packing both-side contacts and allowed occlusion pass;
- [ ] A–G and legacy transfer regressions remain exact; object-transfer
  acceptance cells remain `0`;
- [ ] H positive/negative/cancellation/recovery matrix passes;
- [ ] exact First Day `3`, Day 2 `2`, resources `x2/x2 → x1/x1`, persisted
  remainder and Quiet Cooperative remain unchanged;
- [ ] player mode contains no debug geometry/labels;
- [ ] independent Art runtime review records P1 dog/Kitchen/Mill read;
- [ ] explicit user runtime review occurs after immutable actual captures;
- [ ] status/result docs are updated factually without claiming full
  R48-A/R48-05 or R48-05B PASS.

Successful bounded integration may be `PASS` for this integration trial but
remains `PARTIAL / WARN` for parent R48-A/R48-05. R48-05B/P0-C remains open.

## 9. Regression and capture matrix

### 9.1 Source/import integrity

- final package `605/605` ledger and `157/157` QA;
- promoted-file ledger and source → runtime hash mapping;
- Godot import/check/smoke;
- actual black/checker/desktop alpha readback;
- exact world bounds/baseline and 24-pose canvas/root/bounds.

### 9.2 A–H matrix

- positive A, B, C, D, E, F, G and H;
- negative G outside exact Day 2 order/moment;
- H positive pre-TripTask offered gate and Quiet Cooperative;
- H negative at `ready_to_send`, any assigned/queued/current Labrador task,
  TripTask/task/delivery, restore-before-readback, save failure, Retry/recovery
  and stale predicate;
- player gate cancels H before state transition;
- both authored facings and both physical turns; no negative scale;
- cancellation/recovery and one-runtime/one-Labrador assertions.

### 9.3 Gameplay/persistence regressions

- First Day ordinary path;
- Day 2 ordinary return and completion;
- full 33-cursor restore/advance sweep;
- restart/SIGKILL/save-failure Retry/recovery matrices;
- no production profile mutation from tests;
- exact `3 + 2`, resource provenance and Quiet Cooperative;
- existing `UnloadTask`, `CarryTask`, `LoadVanTask` remain honest
  `legacy_unbound`/current lane with zero R48-05B claim.

### 9.4 Persistent evidence

Create a new immutable pack; never overwrite v5:

```text
docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_R48_05A_SOURCE_RECONCILED_RUNTIME_CAPTURE_v1/
```

Required evidence:

- native 2992×224 First Day, Day 2, Quiet Cooperative and actual desktop;
- checker/black alpha and upper-reserve proof;
- full layout at 216/144/96;
- A–H state/cursor manifest and normal-speed H motion;
- both turn directions;
- Kitchen/Packing contacts from both sides and forbidden-overlap masks;
- Mill static/zero-interaction proof;
- H positive/negative/cancellation/recovery trace;
- no-transfer, one-runtime, one-Labrador and regression summaries;
- file hashes, capture environment and immutable ledger.

## 10. Stop conditions

Stop without substitution on:

- any accepted source/promotion/manifest hash drift;
- missing Art promotion mapping or Technical preflight;
- any writer other than thread `019f5ce4-e63c-7d33-a586-d2d3031c8610`
  mutating the accepted atomic scope;
- any Sheet A reuse or v6 patch loop;
- new mechanic/entity/task/resource/output/input/reward/room;
- R48-05B transfer/pickup/attach/carry/place/detach;
- background/minimize/performance or onboarding expansion;
- need to mutate PlayerBoot/save/persistence/33 cursors/game systems;
- second runtime/simulation or persisted presentation state;
- unsafe mirror/negative scale or fake physical turn;
- guessed station/route/timing conversion where Technical signoff is missing;
- opaque cell/sky matte/speckled alpha recurrence;
- inability to retain one visible Labrador during legacy transfer phases;
- need for broad scene/asset/pipeline refactor.

Return the exact stop code/evidence to PM. Do not make the brief executable by
editing its status yourself.

## 11. Execution ownership and handback

Technical preflight is `SIGNED_TECHNICAL_PREFLIGHT`. The single writer is
thread `019f5ce4-e63c-7d33-a586-d2d3031c8610`; no concurrent asset/code/status
writer is allowed.

The writer handback must report exact modified/new/deleted files and hashes,
source→runtime 41-file equality, all regression/capture commands and results,
new immutable evidence ledger, factual updates to the four result/status docs,
and any stop code. It must not claim runtime Art PASS, final user acceptance,
parent R48-A/R48-05 closure or R48-05B credit. No commit/push is authorized by
this brief.
## 12. Factual implementation result — 2026-07-14

Result: `PASS / TECHNICAL_MECHANICAL_ONLY`. Runtime Art review and explicit user
acceptance are `PENDING`; parent R48-A/R48-05 remains `PARTIAL / WARN`, and
R48-05B remains open. Activation authority before this result append was exact
SHA-256 `9fcaab17580f23b7a3d884440b802aa9c38f9181b84739bd0ba9dffcfa0159b1`.

Implemented the exact accepted topology: runtime/authored width `1740`, source
width `2992`, coefficient `1740/2992`, Labrador scale `0.24`, 16 static layers
`00–09,11–16`, one standalone Bicycle, 24 Labrador composites and exactly
`41 PNG + 41 .png.import`. Layer 10 is absent. Selector H is derived and
non-persisted, uses the exact converted route/timing/cadence, yields to B,
fails closed and produces zero gameplay/transfer output. Existing
Unload/Carry/LoadVan phases remain `legacy_unbound`.

Mechanical evidence passed frozen source `605/605`, Art QA `157/157`, the
64-check source/runtime validator, both hybrid animation-pipeline validators,
Godot import/check/smoke, A–H and H cancellation/recovery, ordinary First Day,
Day 2 and Quiet Cooperative, profile/checkpoint/33-cursor
Continue/SIGKILL/save-retry, and ordinary `play.sh` under a temporary HOME.
The production profile remained absent.

Immutable evidence:

```text
docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_R48_05A_SOURCE_RECONCILED_RUNTIME_CAPTURE_v1/
HASHES.sha256 SHA-256 7666f8fe5280d6ea79c4828e57aa67131d1031f3e040e893d82f11ead3d54de3
capture_manifest.json SHA-256 8c9cd0c02cc25542a43eda0330bf7f748e194ad86d64e9c32741e864cc60cab1
```

Runtime Art/user-review risk remains explicit: accepted existing resource/cue
primitives and `Show UI` remain visible and were not changed outside scope.
One early H-turn capture has an evidence-local incomplete redraw; the separate
full both-direction turn captures and subsequent native frame are complete.
This is a `WARN`, not a Technical failure or a `prototype resolved` claim.

No no-touch implementation path, source/promotion/approved file or immutable
v1–v5 evidence pack was changed. No stage, commit or push was performed.
