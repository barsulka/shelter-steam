# STEAM_DESKTOP — R48-05A Technical Activation Record v1

Дата: 2026-07-13

Статус: accepted Technical input / PM activated / executable only through the linked bounded R48-05A brief

Milestone: R48-05A / P0-B + P0-D

Implementation brief: STEAM_DESKTOP__Codex_Brief__Playable_World_And_First_Living_Dog_v1.md

Этот record фиксирует только bounded runtime-binding authority для уже принятого Game Design manifest и SOURCE-READY Art package. Он не является runtime implementation authority, runtime Art PASS, production-pipeline lock или разрешением на R48-05B object transfer.

## 1. Принятая execution reconciliation

R48-05A authored Labrador coverage ограничена selectors A–G из STEAM_DESKTOP__Labrador_P0_Accepted_Action_Manifest_v1.md:

- A: idle;
- B: calm wait;
- C: Kitchen/Packing station locomotion;
- D: contact-align;
- E: Kitchen CookTask work;
- F: ordinary Packing Table PackTask work;
- G: exact Day 2 careful/focus layer.

Existing Labrador UnloadTask, CarryTask и LoadVanTask не получают authored binding в R48-05A. Для них current primitive presentation остаётся explicit legacy_unbound:

- authored adapter подавлен;
- current primitive Labrador presentation остаётся единственным visual lane;
- запрещены fake idle, generic carry, attach/detach, duplicate dog или второй task/runtime owner;
- legacy_unbound не засчитывается как R48-05A Art/animation coverage;
- accepted transfer coverage остаётся только будущим R48-05B/P0-C.

Это сохраняет ordinary First Day + Day 2 causality без скрытого расширения object-transfer scope. R48-05A PASS остаётся PARTIAL/WARN для parent R48-A/R48-05.

## 2. Packing Table boundary

Art owner decision ACCEPT_PLACEHOLDER_BOUNDARY:

- current code-drawn Packing Table остаётся temporary semantic placeholder/reference only;
- source/stations/packing_table/packing_table_anchor_plane.svg используется только как numeric binding, contact и current-Labrador clearance authority;
- R48-05A не заявляет authored Packing Table replacement, final station illustration или runtime station Art PASS;
- contact/work сначала подтверждается Technical evidence;
- native runtime Art review после integration может вернуть WARN/CHANGES_REQUIRED и открыть отдельную будущую Art wave;
- object transfer отсутствует.

Kitchen placeholder также остаётся temporary. Ни один station guide PNG/SVG не рисуется как player art.

## 3. Source package и provenance

Source package:

docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Playable_World_Labrador_Source_Package_v1/

Подтверждённый source-level readback:

- 225 files;
- 224 entries in HASHES.sha256;
- stored QA_REPORT records 39 source/content checks; bundled non-writing verifier adds the complete HASHES readback and reports 40 PASS / 0 FAIL / 1 declared Packing Table warning;
- exact 12-row skill manifest validator PASS;
- runtime validation NOT_RUN_OUT_OF_SCOPE;
- SOURCE-READY does not equal runtime Art PASS.

Durable external-authority reconciliation:

- built_from_sha256 / build_input_snapshot:
  e33873b035fdf7af2f4b672b1f73ba393d40d18208c79d418d3a0dfef20a5dbd;
- current_authority_sha256 at Art-signer recording:
  2df6fcf2198de2cf7a2456c96a76a6a073e06d4a4029309b0259aeb0ed9af3a2;
- activation_authority_sha256 after Technical signer + PM activation metadata:
  afedb0185cff0c56963e566ff846a479437bf37950d8b38bc84380781015b3b8;
- source of signer_metadata_only assertion:
  PM/coordinator applied only Art, Technical and PM signer/status metadata patches after package build;
- unchanged semantic projection:
  actor dog.labrador_intro, milestone R48-05A/P0-B+P0-D, exact 12 row IDs, selectors A–G and forbidden no-transfer boundaries;
- current package accepted_action_scope ledger equals the current 12-row manifest ledger and the skill validator passes.

The old hash remains the truthful build snapshot. It must not be replaced as if the package had been rebuilt. Future signer-only full-file hash changes require the same snapshot/current-authority distinction; they do not silently rewrite lineage.

Recommended validator hardening after this milestone: optional external-reference readback plus separate build snapshot, current authority and canonical semantic-projection hashes. This hardening is not required to rebuild the current source package.

## 4. Import and coordinate binding

### 4.1 Runtime asset subset

World runtime candidates:

- layers 00–13 only, total 14 lossless RGBA PNG;
- layer 14 world.anchor.bicycle_parking and world composite are excluded from player rendering/import scope;
- world source x maps 1:1 to world units at zoom 1;
- source baseline y=211 maps to current field baseline;
- current WORLD_WIDTH and authoritative anchor x values remain unchanged;
- source ends at x=1536; any existing 1536..1740 tail may remain current background but cannot be claimed authored.

Labrador runtime candidates:

- right, left and turn_mid;
- 16 semantic RGBA layers per facing, total 48 PNG;
- composites, silhouettes, evidence images, masters and flattened AI reference are excluded from runtime assets;
- right/left use positive-coordinate source sets; runtime negative scale is forbidden;
- common source actor root is [256,280], baseline y=280.

Station source:

- station anchor records are converted into a runtime JSON binding record;
- station SVG/PNG guides are not copied as player art;
- Kitchen/Packing placeholders retain their current semantic visual status.

### 4.2 Numeric trial mapping

- world source scale: 1.0 world unit per source pixel at zoom 1;
- Labrador technical starting scale: source_px_to_world_unit=0.25, uniform only;
- effective dog render scale: 0.25 * current zoom;
- starting side identity envelope: approximately 115.25 x 56.25 world pixels;
- station local offset:
  (station_source_anchor - [512,300]) * 0.25 * zoom, applied only under authoritative station/world root;
- Kitchen contact: plus/minus 65.5 world px; work: plus/minus 56.5;
- Packing contact: plus/minus 62.5 world px; work: plus/minus 53.0;
- approach/exit: plus/minus 108.5 world px.

These values are a Technical import candidate, not Art acceptance. Native runtime capture may reject the scale or continuity. Implementation must stop rather than guess another pixel scale or change gameplay timing.

## 5. Runtime observation and selectors

The current Godot runtime remains the only gameplay authority. A new internal read-only presentation snapshot may expose only:

- actor id/internal id, visible, current_task, current_visible_state, authoritative world_x;
- task id/type/status/order_id/assigned dog/source/target;
- current phase index/status/dog_state/elapsed/duration/on_start/on_complete;
- move_start_x and move_target_x for phase-0 presentation derivation;
- active order id/delivery_state/delivery_confirmed;
- active-chain run id, journey phase, checkpoint_sequence and barrier_failed;
- recent authoritative events sufficient to match the exact care event.

No new persisted field, cursor, checkpoint, order/task state, profile namespace, connector field or gameplay event is allowed.

Binding selectors:

- A: dog.labrador_intro, empty current_task, current_visible_state=idle; Quiet variant additionally requires empty active order/chain and completed history.
- B: empty current_task, ready_to_send, delivery_confirmed=false; requested facing derives from the accepted Van anchor relative to authoritative world_x.
- C: Labrador assignee, CookTask or PackTask, moving_to_source, phase 0, walking, exact Kitchen or Packing source/target; direction derives only from move_target_x-move_start_x at phase entry.
- D: same task/actor/station at exact phase 0 to 1 transition; local visual alignment uses accepted station anchors without writing world_x.
- E: CookTask, Kitchen/Kitchen, in_progress, phase 1, helping_kitchen, start_cooking.
- F: PackTask, Packing/Packing, in_progress, phase 1, packing, start_packing.
- G: all F predicates plus order.second_warm_delivery_careful_pack and a matching labrador_packing_care_moment payload for the current order/task.

Food Mix/Food Bag and all outputs remain owned by current authoritative on_complete behavior.

## 6. Property authority and presentation state

Runtime owns:

- task/status/phase/order/resource/output;
- actor visibility and world_x;
- station/target identity;
- save/restore and event emission.

Parent VerticalSliceDemo owns:

- world-to-screen transform;
- current draw slot and z ordering.

The adapter may own only:

- non-persisted requested/last-rendered facing;
- active logical clip and additive layers;
- station-local visual offset;
- trace-only marker sequence;
- current-task-local care-event latch.

Base locomotion/station clips own declared local torso/limb transforms. Turn owns facing-source visibility and local pose. Blink owns eye-open/blink visibility. Tail owns only tail local rotation. Focus owns only bounded head/gaze/paw micro offsets. No two tracks may own the same property.

All presentation caches are discarded on task mismatch, checkpoint restore, SIGKILL/restart reconstruction, save rollback/retry and runtime teardown.

## 7. Facing, timing and markers

Facing transition:

- previous authored side -> turn_mid -> requested authored side;
- last_rendered_facing changes only through this physical sequence;
- scale.x never becomes negative;
- common actor root stays fixed across source sets.

Normalized phase-0 presentation:

- with turn: 0.00–0.28 turn, 0.28–0.40 start, 0.40–0.82 walk, 0.82–1.00 stop/contact approach;
- without turn: 0.00–0.12 start, 0.12–0.82 walk, 0.82–1.00 stop.

Current Cook/Pack moving_to_source may be only 0.324 seconds. If native motion does not read at normal speed, return STOP_MISSING_RUNTIME_BINDING. Do not change task timing, skip required steps or substitute a sprite flip.

Trace-only markers:

- locomotion:
  visual.phase_enter -> visual.loop_enter -> visual.loop_boundary* -> visual.loop_exit -> visual.cancel_safe -> visual.phase_complete;
- station:
  visual.phase_enter -> visual.contact_begin -> visual.loop_enter -> visual.loop_boundary* -> visual.loop_exit -> visual.contact_end -> visual.cancel_safe -> visual.phase_complete.

No attach/detach ready/ack markers exist in R48-05A. Turn/start/stop are presentation subphases, not gameplay events. Animation never calls start_cooking, start_packing, complete_cooking or complete_packing.

## 8. Cancellation and recovery

- idle/additive suppression: immediate;
- stale selector/task mismatch: immediate visual suppression;
- normal locomotion retarget: only at a stable turn/foot boundary;
- station exit: next loop boundary while the same authoritative task remains active;
- restore/SIGKILL/restart/save-failure: create a new presentation epoch from current restored selectors and discard all old caches;
- save rollback shows only the durable rolled-back selector;
- retry rebinds from authoritative state and never resumes a stale visual task.

## 9. Draw and occlusion ownership

Do not perform a broad scene refactor and do not move Labrador into an arbitrary child render slot.

The adapter/AnimationPlayer may animate non-rendering presentation properties. Current parent drawing reads those properties and renders imported layers in the existing dog slot.

Exact player draw order:

1. authored world layers 00–12;
2. existing world anchors/transport/action lanes;
3. dogs: legacy Dachshund; authored Labrador only for A–G; legacy Labrador only for legacy_unbound;
4. authored world.fence.front_span layer 13;
5. existing resource tokens;
6. current player cues;
7. debug/state labels only in QA mode.

Technical station guide/front-lip layers are never rendered as player art. Until layered station art exists, contact paws stay in front and runtime Art review retains WARN authority.

## 10. Exact implementation file scope after activation

Runtime imports:

- steam/assets/prototypes/vertical_slice/authored/world/layers/ — 14 PNG plus verified Godot import sidecars;
- steam/assets/prototypes/vertical_slice/authored/dogs/labrador_intro/{right,left,turn_mid}/layers/ — 48 PNG plus verified Godot import sidecars.

New files:

- steam/scripts/prototypes/vertical_slice/labrador_visual_adapter.gd;
- steam/scenes/prototypes/vertical_slice/labrador_visual_adapter.tscn;
- steam/resources/prototypes/vertical_slice/labrador_r48_05a_binding_v1.json;
- steam/resources/prototypes/vertical_slice/labrador_r48_05a_station_anchors_v1.json;
- steam/resources/prototypes/vertical_slice/labrador_r48_05a_animation_library.tres;
- steam/tests/vertical_slice_visual/labrador_visual_test_runner.tscn;
- steam/tests/vertical_slice_visual/test_labrador_visual_binding.gd;
- steam/tools/validate-labrador-r48-05a.py;
- steam/tools/capture-labrador-r48-05a.sh.

Modified implementation files only:

- steam/scripts/prototypes/vertical_slice/vertical_slice_demo.gd;
- steam/scenes/prototypes/vertical_slice/vertical_slice_demo.tscn;
- steam/tools/dev-vertical-slice.sh only if the bounded capture entry requires it;
- steam/README.md;
- required current status/context/brief files after verified implementation.

Explicit no-touch:

- steam/scripts/player/player_boot.gd and player_boot.tscn;
- steam/scripts/player/player_checkpoint_codec.gd;
- steam/scripts/persistence/**;
- steam/scripts/game_systems/**;
- steam/resources/game_systems/fixtures/**;
- player profile schema/namespace/files;
- project.godot main scene and player launch contract;
- 33-cursor graph/payload/save barriers;
- connector gameplay/control schemas and MCP;
- steam/play.sh, steam/dev.sh and production profiles;
- source package masters/evidence during runtime implementation;
- all pickup/attach/carry/place/detach assets, sockets, markers and acceptance cells.

If implementation requires any no-touch file, stop and request a new brief/ADR review.

## 11. Evidence, retention and writer

Ephemeral trace:

- steam/.runtime/labrador_r48_05a/visual_trace.jsonl;
- ignored local artifact;
- never imported as gameplay state;
- retained only until the persistent capture pack is verified.

Persistent capture pack:

- docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_R48_05A_LABRADOR_RUNTIME_CAPTURE_v1/;
- contains manifest, source/binding hashes, exact build/commit, runtime selector/state snapshots, clean and silhouette stills, normal-speed motion references, trace excerpt and owner review;
- excludes unrelated logs, profiles and user data;
- remains evidence/history until superseded by an explicitly indexed later capture pack.

Implementation write owner after activation:

- one Codex integrator in the shared checkout;
- all Art/Game Design/Technical reviewer sessions remain read-only;
- no stage/commit/push until scope/readback is complete and ownership is explicit.

## 12. Required regression and capture matrix

Mechanical:

- package verifier plus explicit external-reference snapshot/current-authority readback;
- skill action-manifest validator;
- runtime-binding validator against actual nodes/tracks/files and exact A–G;
- Godot import/check and project smoke;
- ordinary PlayerBoot F5 and play.sh smoke;
- existing First Day, Day 2, profile-store, checkpoint and Continue suites;
- exact 33 safe cursors unchanged.

Native player evidence:

1. First Day: A idle; C/D/E Kitchen; C/D/F ordinary Packing; B ready-to-send.
2. Day 2: A return idle; C/D/E; C/D/F; positive exact G; negative G absent outside exact task/order/event; B ready-to-send.
3. Quiet Cooperative: A only; empty active order/chain; completed history; restart-stable; no output.
4. Both turn directions and both station approach/contact/work directions.
5. Actual player layout at 216/144/96 for idle, wait, walk/turn/stop, contact, Kitchen work, Pack work and focus; clean color + silhouette stills and normal-speed motion.
6. World back/front fence seam, dog/anchor/resource z-order and absence of technical station guides/player debug labels.
7. Cancellation before contact, station loop-boundary cancellation and immediate stale suppression.
8. All 33 cursor restore sweep; SIGKILL during Cook/Pack phase 0/1 including G; save-failure rollback/retry; no duplicate/lost output or stale focus layer.
9. Exactly one PlayerBoot-owned runtime and no second Labrador/simulation.
10. legacy_unbound assertions for existing Unload/Carry/LoadVan transfer states.

Object-transfer acceptance cells are absent. Existing transfer causality remains regression-only and is never credited to R48-05A visual acceptance.

## 13. Stop conditions

Stop on:

- semantic selector outside A–G being mapped to authored Labrador;
- missing/changed source or binding hash;
- external-authority semantic drift;
- unsupported runtime scale/registration/anchor transform;
- visible root pop or unreadable 0.324-second turn/start/walk/stop/contact sequence;
- z/occlusion seam from child-node reordering;
- any animation write to gameplay/runtime/persistence authority;
- any need to change player/checkpoint/persistence/game-system/connector contracts;
- any pickup/attach/carry/place/detach scope;
- mechanical PASS being treated as runtime Art PASS.

## 14. Signers and activation state

| Owner | State | Evidence |
| --- | --- | --- |
| Producer/PM scope | accepted | R48-05A/05B convergence handback |
| Game Designer | accepted / SIGNED | exact 12-row manifest readback |
| Art Director | SOURCE-READY + ACCEPT_PLACEHOLDER_BOUNDARY | Art package and follow-up thread 019f5ad9-79c0-7b82-9964-3491f93bb7ff |
| Technical/Codex | accepted / WARN / exact-file readback SIGNED | activation handback thread 019f57a6-da0c-7e00-a40e-a2e768247436, 2026-07-13 |
| PM | accepted / R48-05A activated | this record plus linked implementation brief; one Codex write owner and evidence paths fixed |

R48-05A is accepted/executable only inside this exact bounded record and linked brief. Runtime Art review remains a post-integration gate.
