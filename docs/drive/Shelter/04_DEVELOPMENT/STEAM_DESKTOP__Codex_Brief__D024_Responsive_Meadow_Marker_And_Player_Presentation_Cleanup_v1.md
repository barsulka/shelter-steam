# STEAM_DESKTOP — Codex Brief — D-024 Responsive Meadow, Marker and Player Presentation Cleanup v1

Дата: 2026-07-14
Обновлено: 2026-07-16
Статус: `D029_D024_OBSERVABILITY_ATOMIC_RUNNER_REMEDIATION_IMPLEMENTED / INDEPENDENT_NO_GODOT_REVIEW_PASS / P0=0 / P1=0 / P2=0 / CAPTURE_BLOCKED / EVIDENCE_HOLD / UNSEALED / BOUNDED_REAL_RUN_REQUIRES_NEW_USER_COORDINATOR_DECISION_AND_LITERAL_ACK / FINAL_RUNTIME_ART_USER_ACCEPTANCE_PENDING`
Milestone: `R48-05A bounded responsive-presentation correction trial`
Владелец brief: Producer / Project Manager
Technical preflight owner: thread `019f57a6-da0c-7e00-a40e-a2e768247436`
Initial implementation owner: exactly one Codex writer, thread
`019f5ce4-e63c-7d33-a586-d2d3031c8610`.
The prior runner-only mechanical-gate/atomic-evidence correction is historical
in §0C. The D-029/D-024 implementation writer was exactly thread
`019f6604-8ac6-7871-85c8-2c858a2240f3`; the final exact eight-file no-Godot
result and independent review PASS are recorded in §0H. This PM factual-sync
wave activates no writer, Godot process, runtime check, capture or evidence
action. The prior GUI capture ACK is consumed; capture and canonical evidence
remain on HOLD pending a new user/coordinator decision and literal bounded
real-run ACK.
Рекомендуемый уровень рассуждений: **очень высокий**

---
## 0A. Immutable D-024 authority contract

Correction rationale:

- the active brief mixes stable D-024 authority with mutable ownership/status,
  results and §14 code-hash ledger;
- validator and runner captured different historical whole-file brief hashes,
  while validator also pinned a mutable PM Activation Status file;
- storing final tool hashes in a brief whose whole-file hash is compiled into
  those tools creates a circular dependency with no deterministic fixed point;
- this same brief remains the sole D-024 authority. No corrective/superseding
  brief is created.

Authority digest metadata, outside the immutable block:

```text
authority_contract_scheme=raw-bytes-between-markers-v1
authority_contract_sha256=4f956a077d0a93575ef7b518fd0aa9fb409392a08fd4a48190364795bc9b5cbf
```

For this scheme, the digest input is every exact raw UTF-8 byte after the LF
terminating the unique BEGIN marker line through the byte immediately before
the first byte of the unique END marker line. Marker lines are excluded. No
newline, whitespace, encoding or Unicode normalization is allowed. Missing,
duplicate, reversed or malformed markers are a hard failure.

Historical workflow provenance, not current compiled acceptance gates:

```text
72119140c079e780532873cce1ade75e676e02617ee673e6313b43b8db9b390c — mechanical-pass brief revision retained in immutable mechanical evidence/JSON provenance
00c89a573657a6b58cb139a4bd48a96395abbf205a5f67dea40ea7e3cb275b9b — post-capture-compliance, pre-current-owner-rebind brief revision retained only as historical workflow provenance
d94969b27ce34fd9af83a314b163b64618ef998309ec511274e613eb9c7a5c8a — current pre-amendment whole-file brief guard for this PM write
98e3ad38ebea5446d51c81c20690d9205333d63a5c0efbf09010c9ac4df1ce91 — historical mutable PM Activation Status pin retained in evidence provenance
```

These hashes must not be used by validator/runner as current authority. The
whole-file SHA of this amended brief is workflow provenance/atomic write guard,
not a compiled contract gate.

<!-- D024_AUTHORITY_CONTRACT_BEGIN -->
# D-024 Immutable Normative Authority Contract v1

## Goal and boundary

D-024 is a bounded responsive-presentation correction for the existing
Steam/Desktop First 48 Hours playable. It must:

1. render the accepted seam-safe tiled meadow and exactly one authored-positive
   exterior Fence Boundary Marker;
2. preserve gameplay/buildable field `[0,1740]`, current buildings, Bicycle,
   one Labrador and the accepted A–H/gameplay/save semantics;
3. provide the accepted responsive camera, right reserve and bounded
   horizontal mouse-drag presentation behavior;
4. remove prototype/debug primitives from ordinary player presentation without
   removing gameplay-required surfaces or Hide/Show behavior;
5. produce immutable macOS real-framebuffer Godot self-capture evidence for
   independent Art and user review.

This contract does not authorize R48-05B object transfer, a new mechanic,
entity, room, onboarding, background/minimize/performance work, Windows QA,
new UI/Art direction or final visual acceptance.

## Accepted source pins

Accepted source package root:

```text
docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Art_Source_Responsive_Meadow_Left_Cluster_Amendment_v1/
```

Pinned package authority:

```text
README.md                 e92e5ab61850b380e7db0317e7db469ae0ae9515eb16f208abfb85940c058487
PROVENANCE.md             5ccbfcac2bfa1c185a46721058ffe4e6961a84e7969fc932f98efec3d21a63f5
REFERENCE_READBACK.md     e60aba402c7c9b4ba2291ea85ec96bf50f6117a36a0e47ff202028bd460724db
ART_QA.md                 f8e2b983cbd8c8494e917c15aba97810c7659a85a0ed60160b66ad5fecf64e78
SOURCE_MANIFEST.json      66dba9bb18a7932fc079055b2bce7645484f3bc084ea3c1427169b2efa81bd89
QA_REPORT.json            82aa32d635b96f82cf52e101485d91cb374e24859d386696d4728b612b44ea2c
INVENTORY.txt             76da63d92b3011082a0c07ff424e3ad4d00465f899c9f735429bdb9b2bc6e293
HASHES.sha256             220a9532f54b8f8ae813f32ac02ef28e35a5d2bde6ded318ecb08a43319e43bf
tools/build_amendment.py  4cef60122de12cf2ae6de83ffc4fb4ed99d77ee24d6fa242aa92b6558a1de2f2
```

Required package readback is exactly `51` files, ledger `50/50`, QA `48/48`.
The accepted source approval document and Labrador action manifest remain:

```text
docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Art_Source_Responsive_Meadow_Left_Cluster_Amendment_v1__PM_User_Source_Acceptance.md
eab92cb51a84361ba48036fed760ebbcdbfac59afe8b3b7d824dd42e84856079
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Labrador_P0_Accepted_Action_Manifest_v1.md
d8f1a9fc9226588097eb7bdfc162b6eff520ef42605b369ba25f906daa52ae56
```

Runtime-copy inputs must remain byte-identical and must not be re-encoded:

```text
exports/meadow/meadow_tile_rgba_748x224.png
1cb5845141ad80beba303bc6e0805f10954310eb783a9dfb5ac5f1354e144d40
exports/boundary_marker/fence_boundary_marker_rgba.png
e0237a29119a318cb7b5acb431ed17e7b70d7da3d5386883b335d16ba7416036
```

ORA masters remain source-only authority and are not runtime imports:

```text
meadow_tile_master.ora fbd9e9a03a54836933bf912ade049a97d0eaf79c26272fe919c0e626ce8093ea
fence_boundary_marker_master.ora e04a73af66742472c293eb3bd5925c22d10933243f46f27500713839c08c4111
```

## Stable authorized surfaces

The bounded D-024 implementation/evidence surfaces are:

```text
steam/assets/prototypes/vertical_slice/authored/world/responsive/meadow_tile_rgba_748x224.png
steam/assets/prototypes/vertical_slice/authored/world/responsive/meadow_tile_rgba_748x224.png.import
steam/assets/prototypes/vertical_slice/authored/world/responsive/fence_boundary_marker_rgba.png
steam/assets/prototypes/vertical_slice/authored/world/responsive/fence_boundary_marker_rgba.png.import
steam/resources/prototypes/vertical_slice/d024_responsive_presentation_v1.json
steam/scripts/prototypes/vertical_slice/vertical_slice_demo.gd
steam/tests/vertical_slice_visual/d024_responsive_presentation_test_runner.tscn
steam/tests/vertical_slice_visual/test_d024_responsive_presentation.gd
steam/tools/validate-d024-responsive-presentation.py
steam/tools/capture-d024-responsive-presentation.sh
docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_R48_05A_D024_RESPONSIVE_PRESENTATION_RUNTIME_CAPTURE_v1/**
```

Writer/session assignment, current mutation subset, current result and next step
are intentionally outside this immutable contract.

## Behavioral invariants

### Meadow and marker

- Meadow is `748×224 RGBA`, `435` world units, phase origin `world x=0`, one
  texture loaded once, repeated on X only over the calculated visible range.
- Use positive uniform transform only; no Y repeat, atlas, non-uniform stretch,
  crop, gutter, black fill, transparent tail, re-encode or mipmaps.
- Fence Boundary Marker is `174×106 RGBA`, pivot `[0,105]`, placement
  `[1740,122.7072192513369]`, positive uniform scale
  `1740/2992=0.5815508021390374`, `runtime_mirror=false`.
- Marker has exactly one load/draw, no collision/input/entity/save authority,
  begins outside the field and renders after layer 16 before current cues.
- Static layers, buildings, Bicycle and Labrador render once and are never
  repeated with the meadow.

### Field, camera and input

- `WORLD_WIDTH=1740`; gameplay/buildable field is exactly `[0,1740]`.
- For viewport width `V`, positive zoom `z` and `p=0.15`:

```text
z_min(V)=0.85×V/1740
z_default=z_min(V)
camera_default_x=0
allowed z>=z_min(V)
camera_max=max(0,1740-0.85×(V/z))
```

- The right boundary maps to `0.85V` at the right/default clamp and the
  accepted empty reserve remains `13–17%` of viewport width.
- Runtime vertical fit uses
  `z_max=min(1.05×z_min,H/((224-20)×(1740/2992)))`; native material clipping at
  3840 is forbidden.
- Outside-field meadow is visual-only: non-buildable, no station/A–H/idle/dog
  activity, hidden input or UI.
- Camera/zoom/tile phase/marker/drag are non-persisted presentation state.
- Controls/player gates win before drag. Ground pan begins only inside the
  field when a pan range exists, after `8` screen px; release produces no click.
- Marker/exterior is click-through. Render/world/input transforms use the same
  camera/zoom values. Pan emits no gameplay/save/progression output.
- Passthrough captures only authorized controls and eligible in-field ground;
  no UI crosses the exterior reserve.

### Player presentation and gameplay non-regression

- Ordinary player mode contains no semantic/debug labels, state cards,
  prototype-only resource/cue cards, route/anchor/contact geometry, developer
  overlays or persistent prototype `Show UI` button.
- Exact D-023 confirmations and accepted Order/Route/Dog/Postcard surfaces,
  Hide/Show functionality and existing `KEY_H` two-way restore remain.
- Preserve exactly 12 Labrador rows and selectors A–H, one Labrador, one visual
  adapter, one authoritative gameplay runtime and all signed route/contact
  guards.
- Preserve D-023 `3 + 2`, `x2/x2 → x1/x1`, Quiet Cooperative, player profile,
  checkpoint/schema/save barriers and all `33` cursors.
- No pickup/attach/carry/place/detach, R48-05B transfer, new mechanic/entity,
  persistence output or gameplay authority is introduced.

### Authority enforcement and capture

- Validator hardcodes only the accepted immutable authority-contract digest
  published outside this block, plus stable source/package/Labrador pins. It
  must not current-gate mutable whole-file brief or PM status hashes.
- Marker extraction is strict and fail-closed. Missing, duplicate, reversed or
  malformed markers, or a digest mismatch, return failure.
- Validator provides no-write `--authority-only`: it performs the complete
  marker/digest check and prints the verified accepted digest. It has no
  `--trust-current`, dynamic-trust or bypass mode.
- Runner obtains the accepted digest only by invoking validator
  `--authority-only` before Godot lookup, `mkdir` or any evidence write. It
  repeats that check immediately before manifest/seal and requires the same
  digest; a mid-run change forbids sealing.
- Runner contains no independent brief/contract digest literal.
- Capture manifest records `authority_contract_scheme`,
  `authority_contract_sha256` and a separate
  `brief_file_sha256_at_capture` provenance value. `brief_sha256` must not be
  used as the contract digest.
- Game imagery uses existing Godot real-framebuffer self-capture. macOS
  Screenshot UI/Computer Use is allowed only for required desktop/native-window
  context. Headless/dummy imagery, external ad-hoc capture and any third path
  cannot close visual evidence.
- No new persistent test file is required by default. Authority parser/CLI
  behavior is proven by command-level mutation tests on temporary copies.

## Acceptance

- Stable source pins, `51` files, ledger `50/50` and QA `48/48` pass.
- Runtime corpus remains exactly `43 PNG + 43 .import`; source/runtime PNG bytes
  match; one meadow load and one marker load/draw are proven.
- D-024 responsive tests cover 2992/3456/3840 default/right clamp, reserve,
  marker, vertical fit, input precedence, exterior click-through and no UI in
  reserve.
- First Day/Day 2, `3 + 2`, `x2/x2 → x1/x1`, A–H, both stations/approaches,
  turn-mid directions, H trace, profile/checkpoint/restart/Retry and all 33
  cursors pass with zero new gameplay/persistence output.
- `--authority-only` and normal validator pass; one-byte inside-block mutation,
  missing/duplicate/reversed markers fail; outside-block-only mutation preserves
  the accepted contract digest.
- Runner syntax/compile checks pass. Authority check precedes every filesystem,
  evidence and Godot action and is repeated before sealing.
- A normal GUI-capable macOS Godot session produces the existing full 27-PNG
  real-framebuffer matrix, native/mechanical evidence, manifest and first final
  immutable seal without mutating previous sealed packs.
- Manifest authority scheme/digest matches validator output; whole-file brief
  hash is capture provenance only.
- Repository diff checks pass, staged paths are empty and every no-touch hash is
  unchanged.
- Mechanical/capture PASS makes the pack ready for independent Art/user review;
  it does not itself grant final runtime Art or user acceptance.

## Stop and no-touch

Hard-stop without bypass or scope expansion on:

- source/package/runtime-copy drift;
- authority marker ambiguity/order/digest failure or any dynamic-trust bypass;
- whole-file mutable brief/status hash used as a current compiled gate;
- meadow seam/tail/stretch/hole/gutter, duplicate/interior/interactive/mirrored
  marker, coordinate divergence, input precedence failure, exterior input/UI;
- 3840 material clip, unresolved required cue/Hide-Show behavior, native
  passthrough requiring platform mutation;
- A–H, D-023, save/profile/checkpoint/33-cursor regression;
- runner reaching an external/ad-hoc/third capture path or writing obsolete
  Windows capture fields;
- evidence baseline/seal/ledger drift before authorized capture, unexpected
  no-touch change, parallel writer or required scope expansion.

No-touch unless a later separately accepted authority explicitly changes it:

```text
steam/scenes/prototypes/vertical_slice/vertical_slice_demo.tscn
steam/project.godot
steam/scripts/player/player_boot.gd
steam/scripts/prototypes/vertical_slice/labrador_visual_adapter.gd
steam/resources/prototypes/vertical_slice/labrador_r48_05a_binding_v1.json
steam/tests/vertical_slice_visual/test_labrador_visual_binding.gd
all existing pre-D-024 authored PNG/imports
Godot/gameplay/assets/imports outside the bounded D-024 surfaces
PlayerBoot/platform/window/project/connectors/profile/checkpoint/schema/A–H systems
accepted source/approved packages
previous sealed evidence packs
```
<!-- D024_AUTHORITY_CONTRACT_END -->

## 0B. Authority-pin correction execution order

Current factual result after the bounded tool correction:

```text
tool_correction_status=PASS
capture_status=CAPTURE_REACTIVATION_PENDING_COORDINATOR_ACK / EVIDENCE_HOLD / UNSEALED
evidence_root_files=31
evidence_seal=absent
unsealed_ledger=30/30
authority_contract_sha256=4f956a077d0a93575ef7b518fd0aa9fb409392a08fd4a48190364795bc9b5cbf
validator_sha256=a0b4c0da2679118083409f306a77db4be6952e8d268fc3bcff38f90975c09f0f
runner_sha256=add7777692d0f1eefbf0e2e4ce5b8984722b1433fb735835e58ad0137ab5d949
labrador_test_sha256=14a37141f418cc38e998d47a2ae678b5ade1c5ebf1a3d3022b4ffd577d1744b8
```

Temporary correction ownership was assigned to the same writer
`019f6604-8ac6-7871-85c8-2c858a2240f3` and was limited to:

```text
steam/tools/validate-d024-responsive-presentation.py
steam/tools/capture-d024-responsive-presentation.sh
```

That tool correction is complete and its write window is closed. No new test
file was needed. The required authority mutation matrix used temporary copies.
`steam/resources/prototypes/vertical_slice/
d024_responsive_presentation_v1.json` and existing evidence carrying
`721191…` remain immutable historical mechanical provenance.

Deterministic order:

1. **Complete:** PM finalized immutable block bytes, published digest `A`
   outside the block, returned amended whole-file SHA `B` and stopped writing.
2. **Complete:** coordinator sent the same writer a literal tool-correction
   activation for the two paths above while evidence remained HOLD.
3. **Complete / PASS:** writer guard-checked `B`, `A` and the baseline
   code/no-touch hashes, corrected validator and runner, ran only no-GUI checks
   and returned final tool hashes `V`/`R`.
4. **Current PM Phase 2:** PM updates §14/result ledger outside the immutable
   block and the separately authorized factual Current Memory/status documents,
   returns whole-file SHA `C`, and proves the contract digest is still `A`.
5. **Historical pending route, now superseded:** only after Phase 2 handback
   could the coordinator send the same writer a literal capture reactivation
   ACK naming `A` and `C`. The former visible-GoLand-Terminal host restriction
   is not current authority; D-027 and §0C below govern the later launch route.

Tool-correction acceptance result: `PASS`.

- validator `--authority-only` prints verified `A`; normal validator passes;
- temporary one-byte inside-block mutation and missing/duplicate/reversed
  markers fail; outside-block-only mutation keeps `A` and passes authority-only;
- validator/runner contain no current whole-file `721191…`, `00c89…` or
  `d94969…` literal and no mutable PM Activation Status current gate;
- runner obtains `A` only from validator before Godot lookup, `mkdir` or any
  evidence write and rechecks the same `A` before manifest/seal;
- manifest uses `authority_contract_scheme`, `authority_contract_sha256` and
  `brief_file_sha256_at_capture`, not `brief_sha256` as contract digest;
- Python compile, runner `bash -n`, full/scoped diff checks and staged-empty pass;
- evidence remains exactly 31 files/no seal/ledger 30/30 and every no-touch hash
  remains unchanged.

Final corrected tool pins are validator
`a0b4c0da2679118083409f306a77db4be6952e8d268fc3bcff38f90975c09f0f`
and runner
`add7777692d0f1eefbf0e2e4ce5b8984722b1433fb735835e58ad0137ab5d949`.

Any precondition drift, ambiguous digest, dynamic trust/bypass, evidence change,
parallel writer, no-touch change or need for runtime/gameplay/asset scope is
`STOP` and requires handback. This §0B correction scope temporarily supersedes
only the tool no-edit wording in historical §9.4; it does not reactivate capture
or change any product/game/art contract.

## 0C. Mechanical-gate and atomic-evidence correction — PM Phase 1

Classification: bounded D-024 execution-tooling correction. This same brief
remains the sole authority. No new decision or corrective brief is created; no
product, game, art or runtime meaning changes. This section supersedes only the
active status/next-step statements in historical §0B and §14; their completed
authority-tool and capture-attempt history remains intact.

Current guarded state:

```text
phase_1_status=ACCEPTED / EXECUTABLE
capture_status=BLOCKED / UNSEALED / MECHANICAL_GATE_FAILED_PRE_NATIVE / CORRECTION_REQUIRED / CAPTURE_HOLD
prior_gui_capture_ack=CONSUMED
authority_contract_sha256_A=4f956a077d0a93575ef7b518fd0aa9fb409392a08fd4a48190364795bc9b5cbf
expected_old_whole_brief_sha256_C=86c5a7a99f3d9ca4ef5874eb1ebde958749564398993a5572534da4323a2876a
validator_sha256_V=a0b4c0da2679118083409f306a77db4be6952e8d268fc3bcff38f90975c09f0f
pre_correction_runner_sha256_R=add7777692d0f1eefbf0e2e4ce5b8984722b1433fb735835e58ad0137ab5d949
checkpoint_wrapper_sha256=ded26c747dfb40af8a71432ce5916b11096c5f3df6f7b18530ba675a2a564bd3
labrador_no_touch_sha256=14a37141f418cc38e998d47a2ae678b5ade1c5ebf1a3d3022b4ffd577d1744b8
partial_evidence_files=32
partial_evidence_seal=absent
partial_old_ledger=26/30
partial_old_ledger_sha256=3c4a58cdebfa1244cd6e432627c10e3e085568996f83894bacee18c1f0ad7828
partial_tree_digest=4ca49b1d9cd0616d434eb534464087c75cebcd4972122356ad9197ec59cdd378
staged_paths=0
```

### Observed mechanical boundary

The one authorized normal-GUI runner launch passed authority, validator,
Godot import/check, D-024 and Labrador gates, then stopped before native
capture at the checkpoint wrapper:

- checkpoint assertions passed and Godot exited `0`;
- Terminal printed `player_checkpoint_test=passed cursors=17`;
- the post-run forbidden-log predicate matched
  `SCRIPT ERROR|Parse Error|ERROR:` and returned `1`;
- `set -o pipefail` correctly propagated the left-side failure through the
  current `script | tee` callsite;
- the original matched diagnostic line was lost because the current script
  trap removed its temporary raw log and the runner tee captured stdout only;
  its specific engine/runtime cause remains an unresolved residual;
- no error allowlist, bypass, suppression or `benign` classification is
  authorized. A recurring matched diagnostic remains fail-loud and requires
  its exact retained evidence.

This proves a wrapper/callsite observability boundary, not a checkpoint
assertion defect and not a proven gameplay, checkpoint or Godot defect.

### Exact exclusive correction ownership and no-touch

The same sole writer `019f6604-8ac6-7871-85c8-2c858a2240f3` may modify exactly:

```text
steam/tools/capture-d024-responsive-presentation.sh
```

All canonical in-place evidence writes before full success are defective and
must be replaced by the atomic contract below. No other code or document is in
the implementation write scope.

No-touch includes:

```text
steam/tools/test-player-checkpoints.sh
  ded26c747dfb40af8a71432ce5916b11096c5f3df6f7b18530ba675a2a564bd3
steam/tools/validate-d024-responsive-presentation.py
  a0b4c0da2679118083409f306a77db4be6952e8d268fc3bcff38f90975c09f0f
steam/tests/vertical_slice_visual/test_labrador_visual_binding.gd
  14a37141f418cc38e998d47a2ae678b5ade1c5ebf1a3d3022b4ffd577d1744b8
checkpoint GDScript and scene
Godot/runtime/gameplay/profile/checkpoint/schema/A-H systems
all assets/imports and source/approved packages
all governing/current/status docs during the correction code phase
the canonical partial evidence root
```

### Atomic correction contract

1. At the checkpoint callsite, capture combined stderr/stdout into the staged
   checkpoint evidence with
   `test-player-checkpoints.sh 2>&1 | tee "$stage/tests/player_checkpoints.txt"`.
   Retain `set -o pipefail`; do not suppress or allowlist forbidden diagnostics.
2. Capture mode must create a unique same-parent hidden stage and hard-stop if
   the chosen stage or rollback sibling already exists. It starts by copying
   the exact pinned 32-file partial baseline with tree digest
   `4ca49b1d9cd0616d434eb534464087c75cebcd4972122356ad9197ec59cdd378`
   into the stage.
3. Every mechanical, native, ordinary-smoke, manifest and seal write goes only
   to the stage. Capture mode must never pass the canonical evidence root to
   any mechanical or native writer.
4. On any pre-promotion failure, the canonical 32-file root remains
   byte-identical with the pinned tree digest and without a seal. The failed
   stage may be retained at the explicitly announced transient sibling for
   handback or moved to an announced `/tmp` diagnostics path, but it must never
   be represented as evidence PASS.
5. Promotion is allowed only after the stage contains the full 27-PNG matrix,
   manifest, complete `HASHES.sha256`, current `A`/whole-brief provenance and a
   successful self-ledger verification. Rename the canonical root to a unique
   rollback sibling, rename the sealed stage to canonical, then reverify the
   canonical seal/tree/no-touch state. Delete rollback only after that
   post-promotion verification succeeds. A trap must restore rollback on any
   failure between the renames or during post-promotion verification.
6. Stale stage or rollback siblings are a hard stop. No new dependency,
   evidence root, capture path, error allowlist or dynamic bypass is authorized.

Unique same-parent hidden stage/rollback siblings are explicitly authorized as
transient paths during command-level temporary/failure-injection checks and a
later separately authorized capture. They are never canonical evidence, never
represented as PASS and must not survive a successful promotion. This PM Phase
1 writes no Steam tool, canonical evidence or transient sibling itself.

### Correction implementation mode

The correction code phase performs no GUI launch, Godot capture, native
evidence generation or canonical evidence mutation. It may run only no-GUI
validation, isolated `/tmp` checkpoint checks, deterministic replay,
command-level temporary-copy/failure-injection harnesses and static checks.

### Historical launch blocker and approved later route

D-027 supersedes the former active inference that a broad class of direct GUI
launches must not be repeated. The exact historical evidence is narrower:

```text
historical_binary=Godot 4.5.1
historical_path=/Users/barsulka/Downloads/Godot.app
historical_parent=Codex/ChatGPT
historical_failure=HIServices/AppKit abort before Godot project initialization
historical_classification=VERSION/ENVIRONMENT EVIDENCE, NOT CURRENT BLOCKER
```

That record remains valid History, but it is not proof against the current
Steam Godot `4.7`, a current binary/environment check or ordinary shell launch.
A historical/environment/version blocker may become current only after the
smallest safe bounded revalidation in the then-current checkout, binary and
execution environment. The old broad `same direct GUI launch must not be
repeated` wording is superseded.

The user-approved route after correction implementation and independent review
PASS, PM Phase 2 and a new literal capture ACK is:

1. invoke the existing runner directly through Codex shell/sh in the logged-in
   macOS GUI session;
2. the runner invokes the current Steam Godot `4.7` binary without
   `--headless`;
3. the existing Godot real-framebuffer self-capture produces the required
   27-PNG game-evidence matrix.

GoLand and Terminal.app are not launch requirements. The shell host is not a
third capture path. macOS Screenshot UI / Computer Use remains the separate
second visual path only for explicitly required desktop/native-window context;
it is not a prerequisite for launching Godot and is not required for current
D-024 game-frame acceptance.

This approval changes only the future launch surface after all gates. Current
state remains `CAPTURE_HOLD / UNSEALED`; this documentation wave authorizes no
Godot launch, capture or evidence mutation. Runner-only correction ownership
and the atomic stage/promote-or-restore contract remain unchanged.

### Acceptance before any new capture ACK

All guards must remain exact:

- Contract `A` =
  `4f956a077d0a93575ef7b518fd0aa9fb409392a08fd4a48190364795bc9b5cbf`;
- expected-old brief `C` =
  `86c5a7a99f3d9ca4ef5874eb1ebde958749564398993a5572534da4323a2876a`
  for this PM amendment only; the amended whole-file SHA becomes the next
  workflow guard, never a compiled contract gate;
- validator `V` =
  `a0b4c0da2679118083409f306a77db4be6952e8d268fc3bcff38f90975c09f0f`;
- old runner `R` =
  `add7777692d0f1eefbf0e2e4ce5b8984722b1433fb735835e58ad0137ab5d949`
  before the correction writer starts;
- Labrador =
  `14a37141f418cc38e998d47a2ae678b5ade1c5ebf1a3d3022b4ffd577d1744b8`;
- checkpoint wrapper =
  `ded26c747dfb40af8a71432ce5916b11096c5f3df6f7b18530ba675a2a564bd3`;
- partial root = 32 files, no seal, tree
  `4ca49b1d9cd0616d434eb534464087c75cebcd4972122356ad9197ec59cdd378`;
- staged paths = `0`.

Required correction checks:

- `bash -n steam/tools/capture-d024-responsive-presentation.sh`;
- validator `--authority-only` and normal validator PASS;
- focused checkpoint direct and exact pipeline PASS under isolated `/tmp` HOME;
- deterministic failure replay proves the combined staged checkpoint log is
  non-empty, contains both the matched diagnostic and PASS marker, and the
  pipeline remains non-zero;
- no-GUI runner `validate` PASS under isolated HOME while the canonical tree
  remains exactly `4ca49…`;
- temporary-copy failure injection after at least one staged write proves the
  canonical sentinel/tree unchanged and no seal;
- temporary-copy promotion failure proves rollback restores exact canonical
  bytes;
- success-path temporary harness proves rollback is deleted only after promoted
  seal verification;
- `git diff --check`, staged paths `0`, and exactly one implementation file
  changed;
- independent read-only review of the corrected runner returns PASS before any
  new GUI ACK.

After the eventual separately authorized GUI run, acceptance additionally
requires full mechanical PASS before native capture, exactly 27 PNG, manifest
with `A` plus current whole-brief provenance, complete `HASHES.sha256`
verification, no transient stage/rollback sibling, all no-touch hashes
unchanged, and only then Art/user review readiness.

### Stop conditions

`STOP` on any:

- `A`, validator, Labrador, checkpoint-wrapper or pinned partial-tree drift;
- new seal or canonical evidence file before a new capture ACK;
- stale stage or rollback sibling;
- missing exact stderr diagnostic on a failure;
- error allowlist, suppression or dynamic bypass;
- native capture before full mechanical PASS;
- inability to restore rollback or verify the promoted canonical root;
- runtime, gameplay, profile, checkpoint, schema, asset/import or product/art
  meaning change;
- parallel writer, wrong writer, implementation change outside the single
  runner path or change to Contract A;
- recurring matched diagnostic that indicates a real engine/runtime problem.

For a recurring matched diagnostic, retain exact diagnostics and open a new
bounded diagnosis. Do not retry capture.

### Deterministic PM → Codex → PM → capture order

1. **Current PM Phase 1:** amend only this brief outside Contract A, return the
   amended whole-file SHA and prove `A` plus the pinned partial tree unchanged.
2. **Correction code phase:** coordinator activates the same sole writer for
   exactly the runner path. The writer guard-checks the new brief SHA and all
   pins, implements the correction and runs only the no-GUI/temp matrix above.
3. **Independent review:** a read-only reviewer reproduces the correction
   matrix and returns PASS. Capture remains HOLD.
4. **PM Phase 2:** update §14/result ledger and separately activated factual
   Current Memory/status documents, publish the next whole-file brief SHA and
   preserve Contract `A`.
5. **New literal capture ACK:** only after Phase 2 may the coordinator name the
   unchanged `A`, new whole-file brief SHA, new runner SHA and pinned 32-file
   partial-tree digest and authorize one direct Codex shell/sh runner launch in
   the logged-in macOS GUI session.
6. **Capture/review:** the runner invokes Steam Godot `4.7` without
   `--headless`, stages, verifies and promotes-or-restores the corpus. Only a
   sealed verified canonical corpus proceeds to independent Art/user review.

Recommended Codex reasoning: **очень высокий**.

## 0D. D-029 observable and graceful Godot subprocess correction — PM Phase 1

Classification: accepted D-029 process/dev-tooling correction applied to the
exact D-024 called chain. D-029 clarifies D-027/D-028 and is governed
technically by Accepted ADR-0004. This same brief remains the sole D-024
implementation authority. No new D-024 brief, product/game/art/runtime/capture
meaning or capture path is created.

This section supersedes only the active/current execution status, writer scope,
acceptance/stop matrix and next-step wording in §0B, §0C, §0, §9.4, §13 and
§14. Those sections remain intact as completed workflow/history, including the
atomic-evidence correction and its consumed GUI attempt. Immutable Contract A
remains byte-identical and continues to govern stable D-024 meaning.

Current guarded state:

```text
d029_decision_status=ACCEPTED
adr_0004_status=ACCEPTED
phase_1_docs_status=ACCEPTED / EXECUTABLE AUTHORITY
implementation_status=PENDING SEPARATE LITERAL COORDINATOR ACTIVATION
reserved_future_writer=019f6604-8ac6-7871-85c8-2c858a2240f3
capture_status=BLOCKED / UNSEALED / D029_OBSERVABILITY_CORRECTION_REQUIRED / CAPTURE_HOLD
prior_gui_capture_ack=CONSUMED
authority_contract_sha256_A=4f956a077d0a93575ef7b518fd0aa9fb409392a08fd4a48190364795bc9b5cbf
expected_old_whole_brief_sha256_E=412c0081e74061cf3eea7c2ab2894ce46303ca50d0c36a7807b8a7dea7508f30
steam_godot_version=4.7.1.stable.steam.a13da4feb
partial_evidence_files=32
partial_evidence_seal=absent
partial_tree_digest=4ca49b1d9cd0616d434eb534464087c75cebcd4972122356ad9197ec59cdd378
current_ca_error=REAL / UNRESOLVED / NOT ALLOWLISTED
```

### User-selected non-crashing route

The user explicitly selected the normal non-crashing route:

- retain and show complete raw Godot stdout/stderr;
- wrappers/diagnostics never induce Godot crash or abort;
- finite tests continue to natural exit after an error;
- process outcome and diagnostic outcome remain separate;
- long-lived stop is graceful and bounded, with a surviving PID reported as
  blocked rather than hard-killed;
- errors are repaired, never hidden, suppressed or blanket-allowlisted;
- historical `kill -9` / `OS.kill` recovery proof gets no exception and is
  replaced by nonfatal authored intermediate snapshots/failpoints plus a fresh
  clean verifier process.

The current CA/certificate error is real and unresolved. It must be retained
exactly and remains a hard diagnostic failure. This brief does not authorize a
CA allowlist, alternate trust store, network/dependency change or environment
masking.

### Exact future implementation ownership

After a separate literal coordinator code activation, exactly one writer may
implement this section:

```text
019f6604-8ac6-7871-85c8-2c858a2240f3
```

No other writer may change an implementation file in this wave. The current PM
docs activation does not activate the implementation writer or any Godot run.

### Exact implementation scope

Add:

```text
steam/tools/observe-godot-process.py
steam/tests/tools/test_observe_godot_process.py
```

Modify only the exact D-024 called chain:

```text
steam/tools/capture-d024-responsive-presentation.sh
steam/tools/test-player-checkpoints.sh
steam/tools/test-player-day2-return.sh
steam/tests/launch_surfaces/run.sh
steam/tools/test-player-profile-store.sh
steam/tools/test-player-continue.sh
```

The user selected the non-crashing recovery-proof route, so these test surfaces
are also inside the bounded scope:

```text
steam/tests/persistence/test_player_profile_store.gd
steam/tests/player_continue/test_player_continue.gd
```

This runtime file is conditional and may change only if a test-only nonfatal
snapshot hook is technically required:

```text
steam/scripts/persistence/player_profile_store.gd
```

If that conditional file is touched, the writer must prove the hook is
test-only and that runtime behavior, save semantics, schema, canonical bytes,
production profile paths and ordinary gameplay remain unchanged. Otherwise it
is no-touch.

### No-touch

Before a later literal capture ACK, no mutation is allowed to:

```text
docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_R48_05A_D024_RESPONSIVE_PRESENTATION_RUNTIME_CAPTURE_v1/**
steam/tools/validate-d024-responsive-presentation.py
steam/tests/vertical_slice_visual/test_labrador_visual_binding.gd
Godot gameplay/runtime semantics
player save/profile/checkpoint schema or canonical format
scenes, assets, imports and source/approved packages
alternate Godot binaries or installations
dependencies, network behavior or trust stores
current/status/governance docs during the implementation code phase
```

Contract A, its markers and digest are no-touch. The D-024 unique
stage/promote-or-restore contract, exact pinned 32-file canonical partial tree
and absent seal remain in force.

### Narrow stdlib-only supervisor

Implement `steam/tools/observe-godot-process.py` using only the Python standard
library. Its public CLI exposes exactly:

```text
version
import
script-check
scene-test
scene-capture
ordinary-player
```

No arbitrary executable, argv or shell is accepted. A fake child is available
only through an imported unit-test seam, not a public CLI profile.

Before child creation, fail closed unless all are exact:

1. D-028 Steam binary:
   `$HOME/Library/Application Support/Steam/steamapps/common/Godot Engine/Godot.app/Contents/MacOS/Godot`;
2. version `4.7.1.stable.steam.a13da4feb`;
3. canonical repository `steam/` project containing `project.godot`;
4. profile-owned cwd/HOME/project/output stage;
5. profile-built fixed argv.

Reject `--editor`, foreign or duplicate `--path`, arbitrary trailing argv,
non-project invocation and headless substitution for GUI/capture profiles.
Invalid input fails before any child is spawned. The malformed PID `33937`
probe class (`--headless --editor` without the canonical project) must be
impossible through the public supervisor surface.

### Raw logs, events and result

Direct child stdout and stderr to separate append-only stage files and mirror
both streams live without changing retained bytes. Matching occurs only after
retention. The stage also contains ordered `events.jsonl`.

`process-result.json` must record at least:

```text
binary and exact version
argv, cwd and HOME
canonical project identity and project.godot SHA-256
child PID and start/end timestamps
normal exit code OR terminating signal number/name
requested stop method, ACK/timing data and final exact-PID liveness
stdout/stderr byte counts and SHA-256 hashes
process_verdict
diagnostic_verdict and exact matches
capture/manifest/seal eligibility
```

The supervisor's return code is separate from the original child outcome.
Allowed supervisor rc values are `0` and reserved `70..75`; rc `73` is
diagnostic failure and rc `75` is `BLOCKED_CHILD_STILL_RUNNING`. The remaining
reserved codes must be stable named constants with focused tests and must not
leak/reuse an arbitrary child exit code.

### Finite child contract

`ERROR` never terminates a finite child. The process continues to natural exit
so every late byte and late PASS marker remains visible and retained. Only then
are independent verdicts computed.

Required example:

```text
child output: ERROR, then late PASS
child exit: 0
process_verdict: PASS
diagnostic_verdict: FAIL
supervisor rc: 73
capture/manifest/seal eligible: false
```

Exit `23` and child self-`SIGTERM` remain process failures with their original
exit/signal metadata in JSON. A wrapper/predicate result must not overwrite or
masquerade as the child result.

### Long-lived stop contract

For a long-lived child, stop only in this order:

1. project/control quit request with required ACK;
2. bounded grace;
3. if the exact PID remains alive, exact-PID `SIGTERM`;
4. second bounded grace;
5. if the PID remains alive, rc `75`,
   `BLOCKED_CHILD_STILL_RUNNING`, PID/log/result retention and workflow stop.

The supervisor/wrappers contain no `SIGKILL`, `SIGABRT`, `kill -9`, hard
process-group kill or hidden escalation. The TERM-resistant unit path uses
cooperative fixture cleanup outside the supervisor and may not introduce a hard
kill escape.

### Nonfatal persistence/recovery proof

Replace the old fatal process-interruption proof in the called D-024 chain:

1. use a bounded authored intermediate snapshot or failpoint representing the
   exact interrupted storage state;
2. let the producing test exit normally;
3. launch a fresh clean verifier process;
4. prove deterministic recovery/preservation from that authored state.

No `kill -9`, `OS.kill` or separate crash-suite exception is approved. This is
a proof-method change only: ADR-0003 persistence/recovery meaning, save schema,
checkpoint authority and gameplay behavior remain exact.

### D-024 runner/evidence integration

Every Godot child in the exact D-024 called chain must use the fixed supervisor
profile appropriate to its existing operation. The runner consumes the
separate result/diagnostic artifacts and stops on either failure.

All diagnostics and process artifacts generated by a capture attempt are
written only under the unique D-024 stage. On any process/diagnostic/CA failure:

- no native capture continues;
- no manifest, seal or promotion occurs;
- the canonical 32-file partial tree remains byte-identical at
  `4ca49b1d9cd0616d434eb534464087c75cebcd4972122356ad9197ec59cdd378`;
- the canonical seal remains absent;
- exact logs/result/PID are retained for handback under the authorized
  transient diagnostics boundary and are never represented as evidence PASS.

The existing promote-or-restore and rollback verification order remains
unchanged for a later fully passing capture.

### Required implementation checks before independent review

Without launching the real Steam Godot or mutating canonical evidence, prove:

1. fake-child stdout/stderr are retained byte-exact, separately, append-only
   and mirrored live;
2. `ERROR` then late PASS reaches natural exit and yields process PASS,
   diagnostic FAIL, rc `73` and seal ineligible;
3. exit `23` and self-`SIGTERM` retain exact process metadata;
4. invalid binary/project/argv creates no child;
5. project/control quit ACK path passes;
6. exact-PID SIGTERM fallback passes;
7. TERM-resistant child yields rc `75`, retains live PID/logs and is cleaned up
   cooperatively by the test without SIGKILL;
8. static scan finds no SIGKILL/SIGABRT/`kill -9`/hard-kill path in the exact
   implementation scope;
9. exact retained CA diagnostic replay yields diagnostic FAIL and seal
   ineligible without killing the finite fake child;
10. authored nonfatal persistence snapshots/failpoints plus a fresh clean
    verifier prove the former crash/recovery outcomes without fatal signals;
11. temporary-copy D-024 stage failure after at least one write leaves the
    pinned 32-file canonical tree unchanged and seal absent;
12. existing authority-only/validator, syntax/static/unit checks and full/scoped
    diff checks pass; staged paths remain `0`.

An independent read-only reviewer must reproduce the matrix and return PASS.
Capture stays HOLD through review.

### Later bounded real checkpoint and capture gates

No real Steam Godot checkpoint, GUI launch, native capture or canonical
evidence write is authorized by this docs wave or by the later code-only wave.

After implementation PASS and independent review PASS:

1. PM Phase 2 updates the external §14/result ledger and separately activated
   factual Current Memory/status docs, publishes the next whole-file brief SHA
   and proves Contract A unchanged;
2. a new literal coordinator ACK must name A, the then-current whole brief SHA,
   supervisor/runner hashes and pinned 32-file tree;
3. only then may the reserved writer run one bounded real checkpoint/Godot
   attempt through the supervisor;
4. any recurrence of the current CA or any other process/diagnostic failure is
   `STOP`, with no capture/seal/retry;
5. only a completely passing supervised chain may proceed to the existing
   staged 27-PNG capture, manifest, seal, promotion and Art/user review.

### Stop conditions

`STOP` without bypass or scope expansion on:

- Contract A, marker, source/no-touch, validator/Labrador or pinned evidence
  drift;
- wrong/alternate Godot binary, version mismatch, invalid project/argv or
  arbitrary supervisor surface;
- lost/truncated/filtered stdout or stderr, missing result metadata or conflated
  process/diagnostic verdict;
- wrapper-induced abort, SIGABRT, SIGKILL, `kill -9`, hard-kill escalation or
  missing surviving PID/log handback;
- CA allowlist/suppression/masking or any CA recurrence in a real run;
- capture/manifest/seal/promotion after any process or diagnostic failure;
- fatal recovery-test exception or change to persistence/save/schema/gameplay
  meaning;
- canonical evidence mutation before literal ACK;
- change outside the exact implementation scope, parallel writer or wrong
  writer;
- broader wrapper migration, dependency/network/trust-store mutation or need
  for product/game/art/runtime/capture architecture change.

### Deterministic PM → Codex → review → PM → capture order

1. **This Phase 1:** PM records D-029, Accepted ADR-0004 and this §0D outside
   Contract A, then returns the new whole-file brief SHA and releases docs
   ownership.
2. **Separate code activation:** coordinator may activate only reserved writer
   `019f6604-8ac6-7871-85c8-2c858a2240f3` for the exact §0D implementation
   scope. No real Godot/capture/evidence action occurs.
3. **Independent review:** reproduce the fake-child/static/nonfatal recovery
   and atomic-stage matrix. Capture remains HOLD.
4. **PM Phase 2:** record factual result/current status, update §14 outside A,
   publish the next whole-file SHA and keep evidence HOLD.
5. **Literal bounded real-run ACK:** name unchanged A, current whole brief SHA,
   implementation hashes and pinned partial tree.
6. **Bounded real checkpoint/capture:** any CA/error stops without retry or
   seal; only a full PASS may stage, seal, promote and reach Art/user review.

Recommended Codex reasoning: **очень высокий**.

## 0E. User-approved shared graceful-shutdown remediation — current authority

Classification: bounded D-024/D-029 process/dev-tooling remediation under the
user-approved D-027 route. D-029 and Accepted ADR-0004 are clarified, not
replaced. This same brief remains the sole D-024 implementation authority.
Immutable Contract A remains byte-identical.

This section supersedes only the active/current implementation status, exact
remediation scope, long-lived stop route, acceptance matrix and next-step
wording in §0D and older workflow sections. §0D and all earlier sections remain
intact as history. Product/game/art/runtime/capture meaning, save schema,
gameplay semantics, evidence requirements and D-024 atomic
stage/promote-or-restore behavior do not change.

Current state:

```text
independent_review_verdict=BLOCKED
remediation_authority=ACCEPTED / PENDING SEPARATE LITERAL CODE ACTIVATION
reserved_implementation_writer=019f6604-8ac6-7871-85c8-2c858a2240f3
capture_status=BLOCKED / UNSEALED / CAPTURE_HOLD
real_godot_authority=NONE IN DOCS OR CODE REMEDIATION WAVE
expected_old_whole_brief_sha256_F=80449dd0de2721394f80b460af413f20cd0342a0ea8a7bb7d424c8097fed32b4
authority_contract_sha256_A=4f956a077d0a93575ef7b518fd0aa9fb409392a08fd4a48190364795bc9b5cbf
partial_evidence_files=32
partial_evidence_seal=absent
partial_tree_digest=4ca49b1d9cd0616d434eb534464087c75cebcd4972122356ad9197ec59cdd378
current_ca_error=REAL / UNRESOLVED / NOT ALLOWLISTED
```

### Independent-review BLOCKED findings

The first D-029 implementation result is not accepted. The exact remediation
must close all of these findings together:

1. Child stdout/stderr retention must not depend on supervisor-owned pipe
   readers that can disappear while an rc `75` child is still alive. The child
   needs direct append-only log file descriptors; separate live-tail observers
   mirror already-retained bytes. A separate-process rc `75` regression must
   prove that the surviving child can write late bytes without `BrokenPipe` and
   that those bytes remain in the raw logs.
2. Project/control quit must be implemented through a real project-owned
   lifecycle boundary, not a synthetic stdin-only fake-child convention. The
   same shared routine must serve real `NOTIFICATION_WM_CLOSE_REQUEST` and the
   approved flag-gated test-only trigger.
3. The Continue proof must traverse the real public checkpoint transition via
   `test_advance_player_to_next_checkpoint(5000)` and must not call private
   `_commit_player_checkpoint`.
4. CA replay must use the exact retained diagnostic bytes/hash, not a
   paraphrased or different synthetic error. The CA remains diagnostic FAIL and
   capture/seal ineligible.

No finding is waived. Independent review remains `BLOCKED` until the complete
remediation result is re-reviewed and upgraded to PASS.

### User-approved graceful-shutdown route

There is no native `SIGTERM` bridge, GDExtension, platform signal handler or
attempt to inject `NOTIFICATION_WM_CLOSE_REQUEST` externally in this scope.

The always-present `PlayerBoot` / lifecycle owner implements one shared
project-owned graceful-shutdown routine. Its production entry is the real
`NOTIFICATION_WM_CLOSE_REQUEST`; `auto_accept_quit=false` may be used only if
needed to ensure that this notification reaches the controlled routine.

The shared routine must:

1. reject new actions after shutdown begins;
2. use the existing persistence boundary without changing save/schema,
   checkpoint authority or gameplay meaning;
3. complete only allowed pending persistence/flush work;
4. emit retained diagnostics and the exact ACK line
   `shelter_project_quit_ack=true`;
5. allow a bounded deferred/frame flush; and
6. call `SceneTree.quit(0)` and reach natural exit `0`.

Automation calls the same routine only through this exact fixed test-only
transport under a validated isolated HOME:

```text
flag=--shelter-observer-control-v1
request_path=user://d029-observer-control/quit.request
request_bytes=SHELTER_CONTROL_QUIT\n
ack_line=shelter_project_quit_ack=true
```

The trigger is one-shot and disabled by default. Without the exact flag there
is no control-file polling, request-file interpretation or behavior change.
Stale/colliding control state is a fail-closed preflight rc `70` before child
spawn. Malformed request bytes produce diagnostic `FAIL`, do not call the
routine and do not quit the child.

The supervisor waits for the exact project ACK and bounded natural exit. Only
that path may be a normal process PASS, subject to all diagnostic gates. If the
ACK is failed or missing, exact-PID `SIGTERM` remains a bounded supervisor
fallback after the first grace period. A child that exits through this fallback
returns supervisor rc `74` and is always capture/manifest/seal ineligible; this
is not normal PASS. If the exact PID survives the second bounded grace, the
result is rc `75`, `BLOCKED_CHILD_STILL_RUNNING`, with PID/logs preserved and
no `SIGKILL`, `SIGABRT` or hidden escalation.

### Exact remediation ownership and scope

Only after a separate literal coordinator activation, exactly one writer may
change the six paths below:

```text
writer=019f6604-8ac6-7871-85c8-2c858a2240f3

steam/tools/observe-godot-process.py
steam/tests/tools/test_observe_godot_process.py
steam/tests/player_continue/test_player_continue.gd
steam/tools/capture-d024-responsive-presentation.sh
steam/scripts/player/player_boot.gd
steam/tests/launch_surfaces/test_player_boot.gd
```

The last two paths are added to the prior §0D scope solely for the common
graceful-shutdown routine and its static lifecycle wiring proof. Their
pre-remediation guards are:

```text
steam/scripts/player/player_boot.gd=aa071c5884be2ec6406322e538a1c150ca3cfce47f25ad6c670e6b1862e73fdc
steam/tests/launch_surfaces/test_player_boot.gd=260ad473e33ddfdd40b3288b3ac047696fceb04307b44bfcf39dec15fae3f42c
```

No other file from the broader historical §0D scope may change in this
remediation. The writer may not activate Godot, capture, evidence or status-doc
work. The current docs wave does not activate the implementation writer.

### Exact implementation requirements

1. `observe-godot-process.py` remains stdlib-only and retains the fixed D-028
   binary/version, canonical project and fixed-profile/argv preflight from §0D.
2. Spawn the child with stdout and stderr opened directly to separate
   append-only raw files. Live tail observers read/mirror retained bytes; they
   never become the child's output sink and never own the only copy.
3. Preserve byte-exact raw logs, ordered events and independent child
   process/diagnostic results. Supervisor exit never closes a pipe needed by a
   surviving rc `75` child.
4. Implement the shared PlayerBoot graceful-shutdown routine and both entries:
   real `NOTIFICATION_WM_CLOSE_REQUEST` and the exact flag-gated one-shot
   control file. Both entries must call the same routine.
5. Keep the project handler disabled by default. No flag means no polling and
   no production behavior change.
6. Use only the exact request path/bytes/ACK and rc `70`/`74`/`75` semantics in
   this section. No native signal bridge or alternate control transport is
   allowed.
7. Change `test_player_continue.gd` to exercise
   `test_advance_player_to_next_checkpoint(5000)`; no call or reflection access
   to private `_commit_player_checkpoint` is allowed.
8. Preserve the exact retained CA fixture as the following two raw UTF-8 lines
   with a final LF:

```text
ERROR: Condition "ret != noErr" is true. Returning: ""
   at: get_system_ca_certificates (platform/macos/os_macos.mm:1035)
```

Its exact fixture SHA-256 is
`b44d1484f324204d488884405aedead024c019bb75f70f0852bf5b1c19905174`.
The immutable source evidence file is
`tests/mechanical_snapshot_generation.txt` under the canonical D-024 evidence
root, whole-file SHA-256
`802f1519e91aa43b31c4153969b364e02a0eb6834e26fcd2ec3e54a4d246a3d0`.
The fixture remains diagnostic FAIL/not allowlisted; implementation must not
rewrite the evidence source.
9. Keep D-024 atomic stage/promote-or-restore unchanged. Any process,
   diagnostic, malformed-control or CA failure blocks native capture,
   manifest, seal and promotion.
10. Do not alter runtime/save schema/checkpoint/gameplay semantics. The new
    production routine only centralizes already-required graceful persistence
    and quit behavior.

### Required remediation checks

The code wave is no-GUI/no-Godot. It must use fake children, temp directories,
static inspection and existing non-Godot checks only:

1. byte-exact separate append-only stdout/stderr files and live mirroring;
2. finite `ERROR` then late PASS reaches natural exit, process PASS,
   diagnostic FAIL, rc `73`, seal ineligible;
3. exit `23` and self-`SIGTERM` preserve exact child metadata;
4. invalid binary/project/argv and stale/colliding control state create no
   child and return fail-closed rc `70`;
5. no flag proves no polling/control behavior; malformed exact-path request
   bytes prove diagnostic FAIL and no quit;
6. exact request/ACK through the shared project routine reaches bounded
   deferred/frame flush and natural exit `0` in the test seam;
7. missing/failed project ACK followed by exact-PID SIGTERM returns rc `74`
   and remains evidence-ineligible;
8. a separate-process TERM-resistant rc `75` case leaves the child alive with
   PID/logs/result retained; the child writes additional late stdout/stderr
   without `BrokenPipe`, then test-fixture cleanup is cooperative and contains
   no hard kill;
9. static real-handler wiring proves `NOTIFICATION_WM_CLOSE_REQUEST` and the
   flag-gated test trigger call the same shared routine; static scans prove no
   native SIGTERM bridge/GDExtension/platform signal handler;
10. Continue uses the real
    `test_advance_player_to_next_checkpoint(5000)` transition and contains no
    private `_commit_player_checkpoint` call;
11. exact two-line CA fixture bytes/hash replay as diagnostic FAIL with process
    outcome retained and seal ineligible;
12. static scans find no SIGKILL/SIGABRT/`kill -9`/hard-kill path, no CA
    suppression/allowlist and no alternate Godot/dependency/network/trust-store
    route;
13. authority-only/validator, Python/shell syntax, focused unit/static tests,
    full/scoped diff checks and staged-empty pass without launching Godot;
14. canonical evidence reads back exactly 32 files, no seal and tree digest
    `4ca49b1d9cd0616d434eb534464087c75cebcd4972122356ad9197ec59cdd378`.

An independent read-only reviewer must reproduce the complete remediation
matrix and return PASS. Until that verdict, implementation remains unaccepted
and capture remains HOLD.

### No-touch and stop conditions

`STOP` without bypass on any change outside the exact six-file remediation
scope, wrong/parallel writer, Contract A or marker drift, player-boot guard
drift before activation, validator/Labrador drift, canonical evidence mutation,
real Godot/capture attempt, status-doc mutation, native signal bridge, control
transport expansion, raw-log loss, private checkpoint commit, CA
suppression/allowlist, hard kill, or product/gameplay/save/schema/capture
meaning change.

All other docs, tools, tests, runtime, assets, dependencies, current/status
files, `CODEX_STATUS` and canonical evidence are no-touch during the remediation
code wave.

### Deterministic next gates

1. This PM amendment publishes current authority outside Contract A.
2. A separate literal coordinator ACK may activate only writer
   `019f6604-8ac6-7871-85c8-2c858a2240f3` for the exact six-file remediation.
3. The writer runs the no-Godot matrix and returns exact hashes/results.
4. Independent read-only re-review must return PASS.
5. Only then may a separately activated PM factual-sync wave update §14 and
   current/status docs and publish the next whole-file brief SHA.
6. Only a later literal bounded real-run ACK may authorize Godot. Any CA
   recurrence or process/diagnostic failure stops before capture/seal.

Recommended Codex reasoning: **очень высокий**.

## 0F. Validator-pin scope correction — current authority

Classification: narrow D-029/D-024 authority correction after the §0E
implementation writer stopped on a real scope contradiction. The same brief,
D-029 and Accepted ADR-0004 remain sufficient. Contract A is unchanged.

This section supersedes only these §0E statements:

- the exact-six-file implementation limit;
- the designation of `steam/tools/validate-d024-responsive-presentation.py` as
  no-touch during this remediation; and
- any acceptance wording that requires normal validator PASS while forbidding
  the validator's required PlayerBoot pin update.

Every other §0E requirement, no-touch boundary, review gate, evidence HOLD and
stop condition remains active. Earlier text remains intact as history of the
correct authority-conflict stop.

Current guarded state after the stopped implementation pass:

```text
fake_static_matrix=21/21 PASS
implementation_acceptance=BLOCKED / AUTHORITY_CONFLICT_CORRECTION RECORDED
code_reactivation=PENDING SEPARATE LITERAL COORDINATOR ACK
implementation_writer=019f6604-8ac6-7871-85c8-2c858a2240f3
capture_status=BLOCKED / UNSEALED / CAPTURE_HOLD
authority_contract_sha256_A=4f956a077d0a93575ef7b518fd0aa9fb409392a08fd4a48190364795bc9b5cbf
expected_old_whole_brief_sha256_H=aa342c2940c978c28b2e5714d00b7ac9c399745aa43d76c7b64249e29b10c030
partial_evidence_files=32
partial_evidence_seal=absent
partial_tree_digest=4ca49b1d9cd0616d434eb534464087c75cebcd4972122356ad9197ec59cdd378
```

### Exact seven-file wave scope

The complete remediation wave is limited to exactly these seven paths:

```text
steam/tools/observe-godot-process.py
steam/tests/tools/test_observe_godot_process.py
steam/tests/player_continue/test_player_continue.gd
steam/tools/capture-d024-responsive-presentation.sh
steam/scripts/player/player_boot.gd
steam/tests/launch_surfaces/test_player_boot.gd
steam/tools/validate-d024-responsive-presentation.py
```

The seventh path is added only because the normal D-024 validator pins
PlayerBoot and must recognize the exact authorized §0E result. No eighth path
is authorized. The same reserved writer remains the sole future implementation
writer:

```text
019f6604-8ac6-7871-85c8-2c858a2240f3
```

This PM docs wave does not activate that writer. A later literal coordinator
ACK must name the then-current whole brief SHA and the current guards below.

### Exact current code guards

```text
validator_current_sha256=a0b4c0da2679118083409f306a77db4be6952e8d268fc3bcff38f90975c09f0f
runner_current_sha256=31e4b68548a37aae8b584cdfde3c7c18fe88a8b793bfa1a0c233a86ea6000342
player_boot_current_sha256=dac832c2d861a16ad74ba4fb5bdaebaa045b5f63984b9a5be74d45f348fb60fd
player_boot_test_current_sha256=c09235f051a686fd358fb86baa697f3fb7ce80ef2781207bf55f3bded9cf8104
```

Any mismatch before code reactivation is `STOP_CONCURRENT_DRIFT`.

### Exactly two remaining mechanical edits

After a separate literal code ACK, perform only these substitutions:

1. In `steam/tools/validate-d024-responsive-presentation.py`, replace only the
   PlayerBoot pin
   `aa071c5884be2ec6406322e538a1c150ca3cfce47f25ad6c670e6b1862e73fdc`
   with
   `dac832c2d861a16ad74ba4fb5bdaebaa045b5f63984b9a5be74d45f348fb60fd`.
2. After proving the resulting validator hash, in
   `steam/tools/capture-d024-responsive-presentation.sh`, replace only the
   validator pin
   `a0b4c0da2679118083409f306a77db4be6952e8d268fc3bcff38f90975c09f0f`
   with
   `2620fdb6f2f57331e49859ab9530a7476ab6449a3a52cfb986a3d4f787cf17f2`.

The deterministic order is mandatory:

```text
1. verify the fixed PlayerBoot and PlayerBoot-test guards;
2. update the validator PlayerBoot pin;
3. prove validator SHA-256 = 2620fdb6f2f57331e49859ab9530a7476ab6449a3a52cfb986a3d4f787cf17f2;
4. update the runner validator pin;
5. prove runner SHA-256 = 578e271640174ba1299c4ee498c0747f4cf6700681f8c3f22f6212fa374c3667;
6. run the no-Godot acceptance matrix below.
```

No reformat, cleanup, adjacent refactor, pin redesign or additional code edit is
authorized by this correction. A predicted final hash mismatch is `STOP`, not
permission to adjust more bytes.

### Labrador boundary

`steam/tools/validate-labrador-r48-05a.py` is not in the D-024 called chain and
remains no-touch. It must not be added, edited or used to expand this wave.

The current D-024 Labrador regression boundary is exactly:

1. `steam/tools/validate-d024-responsive-presentation.py`; and
2. pinned GDScript regression test
   `steam/tests/vertical_slice_visual/test_labrador_visual_binding.gd`, SHA-256
   `14a37141f418cc38e998d47a2ae678b5ade1c5ebf1a3d3022b4ffd577d1744b8`.

The GDScript test, Labrador Python validator and all Labrador runtime/assets are
no-touch.

### Required no-Godot checks after the two substitutions

Without launching Godot, capture or any evidence writer, the implementation
writer must prove:

1. all four current guards above match before the first substitution;
2. the validator diff is exactly the one PlayerBoot-pin substitution and its
   final SHA is exactly
   `2620fdb6f2f57331e49859ab9530a7476ab6449a3a52cfb986a3d4f787cf17f2`;
3. the runner diff added by this correction is exactly the one validator-pin
   substitution and its final SHA is exactly
   `578e271640174ba1299c4ee498c0747f4cf6700681f8c3f22f6212fa374c3667`;
4. validator `--authority-only` returns exact Contract A and normal validator
   PASSes against the fixed PlayerBoot;
5. Python compile with cache redirected outside the repository and focused
   supervisor tests PASS;
6. the fake/static remediation matrix remains `21/21 PASS`, including raw
   FD/live-tail, rc `74`/`75`, real-handler wiring, Continue transition and
   exact CA fixture cases;
7. runner `bash -n` and static no-hard-kill/no-native-bridge scans PASS;
8. the pinned Labrador GDScript test hash remains exact and the separate
   Labrador Python validator is byte-identical;
9. full/scoped diff checks PASS and staged paths remain `0`;
10. canonical evidence remains exactly 32 files, no seal and tree digest
    `4ca49b1d9cd0616d434eb534464087c75cebcd4972122356ad9197ec59cdd378`.

No real checkpoint, Steam Godot, GUI, capture, manifest, seal, promotion,
evidence write or current/status update is authorized.

### Stop and next gates

`STOP` on any eighth changed file, guard/final-hash mismatch, extra validator or
runner diff, Contract A/marker drift, Labrador boundary drift, evidence change,
real Godot/capture attempt, hard-kill/native-bridge/CA-allowlist path, parallel
writer or scope expansion.

After the exact two edits and no-Godot matrix PASS, the writer returns a direct
handback. Independent read-only re-review is still mandatory. Only reviewer
PASS may lead to separately activated PM factual sync; only a later literal
bounded real-run ACK may authorize Godot. Capture/evidence/status remain HOLD
through all earlier gates.

Recommended Codex reasoning: **очень высокий**.

## 0G. Exact eight-file expected-persistence-failure remediation — current authority

Classification: narrow D-029/D-024 authority amendment after the seven-file
mechanical pin correction completed but the no-Godot review found one bounded
testability gap. The same brief, D-029 and Accepted ADR-0004 remain sufficient.
Contract A is unchanged.

This section supersedes only the §0F seven-file limit, its no-eighth-file stop
condition and the current implementation acceptance wording for this bounded
remediation. §0E and §0F remain byte-identical as history. Every other
observability, graceful-shutdown, no-hard-kill, CA, evidence, review, capture
HOLD and no-touch rule remains active.

Current guarded state:

```text
implementation_acceptance=BLOCKED / EIGHT-FILE REMEDIATION AUTHORITY RECORDED
code_activation=PENDING SEPARATE LITERAL COORDINATOR ACK
implementation_writer=019f6604-8ac6-7871-85c8-2c858a2240f3
real_godot_authority=NONE IN THIS DOCS OR FUTURE CODE WAVE
capture_status=BLOCKED / UNSEALED / CAPTURE_HOLD
expected_old_whole_brief_sha256_I=3a4ef5ee3f5ce1f11f85a6c07db4723c7a045b38853d979d4bda5b95e01521af
authority_contract_sha256_A=4f956a077d0a93575ef7b518fd0aa9fb409392a08fd4a48190364795bc9b5cbf
partial_evidence_files=32
partial_evidence_seal=absent
partial_tree_digest=4ca49b1d9cd0616d434eb534464087c75cebcd4972122356ad9197ec59cdd378
```

### Exact eight-file authority scope and current guards

The complete remediation authority is exactly these eight paths at these
pre-reactivation SHA-256 guards:

```text
1880d4fe829708d8aba3dbc2e7d9cc43c669e151fb94a1dd818e6ce505a91502  steam/tools/observe-godot-process.py
1eb4fb5c291ebde0b5629cfd799de3dfbc09dd45c35bc2b320c5dcc2a7dd3cb6  steam/tests/tools/test_observe_godot_process.py
6255bf916feffff1eac3627da7a71e097bf18667dbd7cf54c2efaff676f3917f  steam/tests/player_continue/test_player_continue.gd
578e271640174ba1299c4ee498c0747f4cf6700681f8c3f22f6212fa374c3667  steam/tools/capture-d024-responsive-presentation.sh
dac832c2d861a16ad74ba4fb5bdaebaa045b5f63984b9a5be74d45f348fb60fd  steam/scripts/player/player_boot.gd
c09235f051a686fd358fb86baa697f3fb7ce80ef2781207bf55f3bded9cf8104  steam/tests/launch_surfaces/test_player_boot.gd
2620fdb6f2f57331e49859ab9530a7476ab6449a3a52cfb986a3d4f787cf17f2  steam/tools/validate-d024-responsive-presentation.py
2b616890113bf75afd4b67ed95cb67a0b00b1834301d098f7afce573e3b103b9  steam/scripts/prototypes/vertical_slice/vertical_slice_demo.gd
```

The eighth path is added only for a test-only scoped expected-persistence-
failure seam around the unchanged public checkpoint transition. No ninth path
is authorized. Any guard mismatch before code activation is
`STOP_CONCURRENT_DRIFT`.

Additional no-touch guards:

```text
ac20117305bc2daeb80626a6b0a70705d476635c3ce5d5c4d99af190bd7989c0  steam/tools/test-player-continue.sh
14a37141f418cc38e998d47a2ae678b5ade1c5ebf1a3d3022b4ffd577d1744b8  steam/tests/vertical_slice_visual/test_labrador_visual_binding.gd
```

The exact future code owner remains:

```text
019f6604-8ac6-7871-85c8-2c858a2240f3
```

This PM docs wave does not activate that owner or authorize any code write,
Godot process, capture or evidence action. A later literal coordinator ACK must
name the then-current whole brief SHA and all current guards above.

### Exact actual-byte change subset

Only these four paths may receive new bytes in the future implementation wave:

```text
steam/scripts/prototypes/vertical_slice/vertical_slice_demo.gd
steam/tests/player_continue/test_player_continue.gd
steam/tests/tools/test_observe_godot_process.py
steam/tools/capture-d024-responsive-presentation.sh
```

The other four authorized-scope paths are frozen exactly at their guards:

```text
steam/tools/observe-godot-process.py
steam/scripts/player/player_boot.gd
steam/tests/launch_surfaces/test_player_boot.gd
steam/tools/validate-d024-responsive-presentation.py
```

The distinction is deliberate: all eight belong to the governed/static-scan
scope, while only the exact four-file subset may change bytes. A change to a
frozen path or any ninth path is `STOP`.

### Test-only expected persistence-failure seam

Add exactly one test-only scoped method to
`steam/scripts/prototypes/vertical_slice/vertical_slice_demo.gd`:

```text
test_advance_player_to_next_checkpoint_expecting_persistence_failure(max_ticks=5000)
```

The method must:

1. derive and arm the exact next checkpoint kind, exact next sequence and full
   golden checkpoint for the current durable cursor;
2. call the existing public
   `test_advance_player_to_next_checkpoint(max_ticks)` unchanged;
3. consume at most the immediately armed matching persistence failure; and
4. clear the arm on the exact accepted match and on every completed/mismatched
   attempt so no expectation can leak into later production or test behavior.

The method is a test seam only. It does not directly commit, persist, stage,
retry or advance a checkpoint and does not bypass the public transition.

Immediately before the existing production `push_error` for checkpoint
persistence failure, add one narrow consumer. It may accept only a result that
simultaneously proves all of the following:

1. exact outer failure `checkpoint_persistence_failed`;
2. exact nested injected failure `injected_failure:before_validation` and its
   failpoint identity;
3. durable checkpoint sequence remains exactly the pre-transition sequence;
4. `barrier_failed` is true;
5. the staged checkpoint kind equals the armed exact next kind;
6. the staged checkpoint sequence equals the armed exact next sequence; and
7. the complete staged checkpoint equals the armed full golden checkpoint.

Only that exact armed match returns a structured result whose discriminator is
`expected_checkpoint_persistence_failure_observed`, omits the existing
`push_error` for that one expected test event and clears the arm. The structured
result must expose enough of the validated durable/barrier/staged state for the
Continue tests to assert the exact values above.

Any mismatch, partial match, wrong failpoint, wrong kind/sequence/golden,
unarmed call or ordinary production failure follows the existing production
path with the existing `push_error` text and behavior unchanged. There is no
observer allowlist, diagnostic suppression, rc `73` acceptance or general
expected-error policy.

Persistence/store/schema/save/gameplay meaning remains unchanged. The existing
public transition and all ordinary checkpoint outcomes remain unchanged,
including exact transition `17 -> 18`.

### Exact Continue test changes

In `steam/tests/player_continue/test_player_continue.gd`, change exactly the
three expected-persistence-failure callsites to invoke the new seam instead of
directly invoking the ordinary helper for an intentionally injected failure.

Each of those three callsites must assert:

1. the structured discriminator is exactly
   `expected_checkpoint_persistence_failure_observed`;
2. the staged checkpoint is the exact full golden next checkpoint with exact
   next kind and sequence;
3. the prior durable checkpoint/sequence remains exact;
4. `barrier_failed` remains true;
5. no ordinary production error was suppressed outside the armed exact match;
6. after the existing failpoint clear, the existing retry path succeeds; and
7. the committed result after retry equals the existing exact golden
   checkpoint.

Do not replace the existing clear/retry/readback assertions. The seam adds
structured observation of the intended failure; it does not weaken the proof.

### Observer static-regression and hard-stop scope

In `steam/tests/tools/test_observe_godot_process.py`:

1. expand the hard-stop/static scope list to all exact eight paths in this
   section, including the validator and `vertical_slice_demo.gd`;
2. add a focused static regression proving the seam is test-only, calls the
   unchanged public helper, validates the exact armed failure contract and
   leaves the unarmed/mismatch production `push_error` path intact;
3. preserve every existing raw-FD/live-tail, rc `74`/`75`, graceful shutdown,
   no-hard-kill/native-bridge and exact CA test; and
4. produce exactly `22/22 PASS` for the focused observer suite.

Adding the runtime path to this hard-stop list closes the prior P2 scope gap. It
does not authorize observer diagnostic-policy changes.

### Runner pin integration

In `steam/tools/capture-d024-responsive-presentation.sh`, change only the
mechanical pins needed by this four-file subset:

1. update the observer-test pin to its final implementation SHA;
2. update the Continue-test pin to its final implementation SHA;
3. add an exact no-touch pin for
   `steam/scripts/prototypes/vertical_slice/vertical_slice_demo.gd` at its
   final implementation SHA; and
4. compute and report the resulting final runner SHA.

The already-correct D-024 validator remains byte-identical at
`2620fdb6f2f57331e49859ab9530a7476ab6449a3a52cfb986a3d4f787cf17f2`
and normal validator must PASS. All unrelated runner behavior, pins,
stage/promote-or-restore logic and evidence rules remain unchanged.

### Required no-Godot acceptance matrix

The future implementation wave is no-Godot. It must prove, without launching a
real child or mutating canonical evidence:

1. all eight current guards and both additional no-touch guards match before
   write;
2. changed paths are exactly the four-file subset and no ninth/frozen path
   changed;
3. GDScript/Python/shell compile or syntax checks PASS with transient caches
   outside the repository;
4. focused observer suite reports exactly `22/22 PASS`;
5. static seam regression proves the exact armed match and unchanged
   unarmed/mismatch `push_error` path;
6. all three Continue callsites assert structured expected failure, exact staged
   golden, retained durable/barrier state and existing clear/retry/exact golden;
7. exact `17 -> 18` transition remains unchanged;
8. authority-only validator returns exact Contract A and normal validator
   PASSes without validator byte drift;
9. runner `bash -n`, exact final pin readback and final SHA readback PASS;
10. static scans over all eight paths find no SIGKILL/SIGABRT/hard kill, native
    signal bridge, CA allowlist/suppression or rc `73` acceptance;
11. full/scoped diff checks PASS and staged paths remain `0`; and
12. canonical evidence remains exactly 32 files, no seal and tree digest
    `4ca49b1d9cd0616d434eb534464087c75cebcd4972122356ad9197ec59cdd378`.

No real checkpoint, Steam Godot, GUI, capture, manifest, seal, promotion,
evidence write or current/status update is authorized by this docs wave or the
future code-only wave.

### Stop conditions and next gates

`STOP` on any need for a ninth file, any frozen-path change, guard mismatch,
ordinary production `push_error` change/removal, observer policy/allowlist
change, persistence/store/schema/save/gameplay meaning change, `17 -> 18`
transition change, Contract A/marker drift, evidence mutation, real
Godot/capture attempt, parallel writer or scope expansion.

After the exact four-file implementation subset and no-Godot matrix PASS, the
writer returns exact final hashes and releases ownership. Independent read-only
re-review remains mandatory. Only reviewer PASS may lead to separately
activated PM factual sync, and only a later literal bounded real-run ACK may
authorize Godot. Capture/evidence/status remain `BLOCKED / UNSEALED / HOLD`
through every earlier gate.

Recommended Codex reasoning: **очень высокий**.

## 0H. Phase 2 factual sync — independent no-Godot review PASS

Classification: factual D-029/D-024 Phase 2 result sync after completion of the
exact §0G remediation and independent strict read-only re-review. This section
supersedes only the active/current implementation and next-gate wording in §0G
and older mutable workflow sections. It does not rewrite their history, change
D-029 or Accepted ADR-0004, or alter product/game/art/runtime/save/schema/
capture meaning. Immutable Contract A remains byte-identical.

Current factual verdict:

```text
D029_D024_OBSERVABILITY_ATOMIC_RUNNER_REMEDIATION_IMPLEMENTED
INDEPENDENT_NO_GODOT_REVIEW_PASS
P0=0 / P1=0 / P2=0
CAPTURE_BLOCKED
EVIDENCE_HOLD
UNSEALED
BOUNDED_REAL_RUN_REQUIRES_NEW_USER_COORDINATOR_DECISION_AND_LITERAL_ACK
FINAL_RUNTIME_ART_USER_ACCEPTANCE_PENDING
expected_old_whole_brief_sha256_J=52833c0b4e6da4ed32aec8d14870d39666bf2b602b71663914433a345328c3bd
authority_contract_sha256_A=4f956a077d0a93575ef7b518fd0aa9fb409392a08fd4a48190364795bc9b5cbf
```

The previous Continue diagnostic conflict and static eight-path scope gap are
closed. The independent reviewer reproduced authority-only and normal
validator PASS, focused observer suite `22/22 PASS`, shell syntax PASS and the
exact eight-path scope/pins, fail-loud expected-persistence seam, unchanged
`17 -> 18` transition, no-hard-kill and no-CA-allowlist gates. The final review
verdict is `P0=0 / P1=0 / P2=0` with no remaining no-Godot remediation finding.

### Final exact eight-file result

```text
1880d4fe829708d8aba3dbc2e7d9cc43c669e151fb94a1dd818e6ce505a91502  steam/tools/observe-godot-process.py
ae242d6e90d9be5baa783a1836c1188370bcfc66580d19b6391232a1e47ef44f  steam/tests/tools/test_observe_godot_process.py
da8abbe8fcfe3c792235fba3eb71bf1a45f414c465f6972bb6c4486c10773f8f  steam/tests/player_continue/test_player_continue.gd
f2c59eb1c13f67d44f3b6803a0706a7ca8d9ad8994b05254b14b944bf0d2e01f  steam/tools/capture-d024-responsive-presentation.sh
dac832c2d861a16ad74ba4fb5bdaebaa045b5f63984b9a5be74d45f348fb60fd  steam/scripts/player/player_boot.gd
c09235f051a686fd358fb86baa697f3fb7ce80ef2781207bf55f3bded9cf8104  steam/tests/launch_surfaces/test_player_boot.gd
2620fdb6f2f57331e49859ab9530a7476ab6449a3a52cfb986a3d4f787cf17f2  steam/tools/validate-d024-responsive-presentation.py
025e4e55ecc39ca48ad89803e9ff5eaf857e80f20baa9a83a2218a8aab763051  steam/scripts/prototypes/vertical_slice/vertical_slice_demo.gd
```

Canonical evidence remains byte-for-byte on HOLD:

```text
partial_evidence_files=32
partial_evidence_seal=absent
partial_tree_digest=4ca49b1d9cd0616d434eb534464087c75cebcd4972122356ad9197ec59cdd378
transient_stage_or_rollback_siblings=0
staged_paths=0
```

### What remains explicitly not run

This Phase 2 docs sync activates nothing. No real Steam Godot `4.7.1`, Continue
runtime scenario, actual PlayerBoot control-file request/ACK, ordinary player,
GUI, native self-capture, manifest, seal, stage promotion or final Art/user
review has run under the corrected D-029 path. The no-Godot PASS is not runtime
or visual acceptance.

The CA diagnostic remains `REAL / UNRESOLVED / NOT ALLOWLISTED`. Any recurrence
in a later bounded real run is diagnostic `FAIL`, supervisor rc `73` and `STOP`
before capture, manifest, seal or promotion. No suppression, retry-as-PASS or
route substitution is authorized.

### Sole next gate

Wait for an explicit user/coordinator decision. Only a **new literal bounded
real-run ACK** may authorize the next action, and it must name unchanged
Contract A, the then-current whole-file SHA of this brief, all eight final
implementation hashes above, the pinned 32-file evidence tree and the exact
writer/scope. No automatic launch follows this PM sync.

Until that ACK, status remains `CAPTURE_BLOCKED / EVIDENCE_HOLD / UNSEALED` and
final runtime Art/user acceptance remains pending. A later authorized run must
stop on any CA recurrence or other process/diagnostic failure without capture,
manifest, seal or promotion.

Recommended Codex reasoning: **очень высокий**.

## 0. Activation boundary

Technical thread `019f57a6-da0c-7e00-a40e-a2e768247436` returned
`SIGNED_TECHNICAL_PREFLIGHT` against prepared brief SHA-256
`d184601d3844163eecc63bb3a9cb33ae9a61e260e704ac2f371ada7ffb8d22db`.
Producer/PM accepted that plan and activates this brief for exactly one writer:
thread `019f5ce4-e63c-7d33-a586-d2d3031c8610`.

Mutation authority is limited to §9. Any other writer, parallel writer or path
outside that exact scope is `STOP_WRITER_OWNERSHIP` or
`STOP_SCOPE_EXPANSION`.

Initial implementation is complete at mechanical level and the first ownership
window was released. Producer/PM accepts the signed macOS-only Technical
reconciliation and, after the previous capture-only owner was released, assigns
new sole writer `019f6604-8ac6-7871-85c8-2c858a2240f3` for the bounded
capture-only completion in §9.4. The two compliance edits in §9.4 are already
complete; their pinned hashes are recorded in §14. No unchanged legacy runner
may be restored or invoked.

The authority-tool correction is now complete and PASS. Capture remains
inactive and evidence remains on HOLD until the coordinator issues the later
literal capture-reactivation ACK naming the unchanged contract digest `A` and
the final Phase 2 whole-file brief SHA `C`.

## 1. Goal

В одном bounded correction trial:

1. заменить текущий one-shot meadow presentation на принятый D-024
   seam-safe tiled meadow и добавить один authored-positive exterior
   `Fence Boundary Marker`;
2. сохранить gameplay field `[0,1740]`, текущие buildings/Bicycle/Labrador и
   A–H semantics без повторения и без новой gameplay authority;
3. реализовать D-024 responsive camera/right-reserve and bounded horizontal
   mouse-drag presentation contract;
4. очистить ordinary player presentation от prototype/debug primitives;
5. получить новый macOS-only immutable runtime corpus для независимой Art и
   user review штатным Godot self-capture.

Это не R48-05B, не новая механика, не room/onboarding/background wave и не
финальная визуальная приёмка.

## 2. Mandatory authority

Перед Technical preflight и ещё раз перед execution прочитать полностью:

- `PROJECTS_RULES.md`, `AGENTS.md`, `steam/AGENTS.md`, `steam/README.md`;
- `docs/repo/adr/README.md` и все релевантные Accepted ADR;
- D-023/D-024 в `02_DECISIONS.md`, Current Status, Steam Current Context и
  First 48 Hours Roadmap;
- `STEAM_DESKTOP__Gameplay_Field_And_Viewport_Semantic_Contract_v1.md`;
- `STEAM_DESKTOP__Labrador_P0_Accepted_Action_Manifest_v1.md`;
- `STEAM_DESKTOP__Art_Source_Responsive_Meadow_Left_Cluster_Amendment_v1__PM_Activation_Status.md`;
- `STEAM_DESKTOP__Art_Source_Responsive_Meadow_Left_Cluster_Amendment_v1__PM_User_Source_Acceptance.md`;
- final amendment package `README.md`, `PROVENANCE.md`,
  `REFERENCE_READBACK.md`, `ART_QA.md`, `SOURCE_MANIFEST.json`,
  `QA_REPORT.json`, `INVENTORY.txt`, `HASHES.sha256`;
- completed prior integration brief
  `STEAM_DESKTOP__Codex_Brief__Accepted_Art_Source_And_Labrador_H_Runtime_Integration_v1.md`
  and immutable runtime pack only as current baseline/regression evidence;
- current Object Contract sections for gameplay-required UI cards and
  Hide/Show UI behavior.

## 3. Exact accepted source authority

Package root:

```text
docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Art_Source_Responsive_Meadow_Left_Cluster_Amendment_v1/
```

Pinned root hashes:

```text
README.md                 e92e5ab61850b380e7db0317e7db469ae0ae9515eb16f208abfb85940c058487
PROVENANCE.md             5ccbfcac2bfa1c185a46721058ffe4e6961a84e7969fc932f98efec3d21a63f5
REFERENCE_READBACK.md     e60aba402c7c9b4ba2291ea85ec96bf50f6117a36a0e47ff202028bd460724db
ART_QA.md                 f8e2b983cbd8c8494e917c15aba97810c7659a85a0ed60160b66ad5fecf64e78
SOURCE_MANIFEST.json      66dba9bb18a7932fc079055b2bce7645484f3bc084ea3c1427169b2efa81bd89
QA_REPORT.json            82aa32d635b96f82cf52e101485d91cb374e24859d386696d4728b612b44ea2c
INVENTORY.txt             76da63d92b3011082a0c07ff424e3ad4d00465f899c9f735429bdb9b2bc6e293
HASHES.sha256             220a9532f54b8f8ae813f32ac02ef28e35a5d2bde6ded318ecb08a43319e43bf
tools/build_amendment.py  4cef60122de12cf2ae6de83ffc4fb4ed99d77ee24d6fa242aa92b6558a1de2f2
```

Required preflight readback: package `51`, ledger `50/50`, QA `48/48`.
Any drift is `STOP_SOURCE_HASH_DRIFT`.

Exact runtime-copy inputs, byte-identical and without re-encode:

```text
exports/meadow/meadow_tile_rgba_748x224.png
SHA-256 1cb5845141ad80beba303bc6e0805f10954310eb783a9dfb5ac5f1354e144d40

exports/boundary_marker/fence_boundary_marker_rgba.png
SHA-256 e0237a29119a318cb7b5acb431ed17e7b70d7da3d5386883b335d16ba7416036
```

ORA masters remain source authority and are not runtime imports:

```text
meadow_tile_master.ora          fbd9e9a03a54836933bf912ade049a97d0eaf79c26272fe919c0e626ce8093ea
fence_boundary_marker_master.ora e04a73af66742472c293eb3bd5925c22d10933243f46f27500713839c08c4111
```

## 4. Import and render contract

### 4.1 Meadow

- `748×224 RGBA`, `435 world units`, phase origin `world x=0`;
- `source_px_per_world_unit=2992/1740=1.7195402298850575`;
- alpha bbox `[0,92,748,224]`, baseline `211 px` =
  `122.7072192513369 world units`;
- one runtime texture loaded once; X repeat only over calculated visible range;
- uniform transform only; no Y repeat, atlas, non-uniform stretch, source crop,
  gutter, black fill or transparent tail;
- lossless RGBA, linear filter, mipmaps off; exact Godot import settings and
  implementation topology must be pinned by Technical preflight;
- current buildings/static layers/Bicycle/Labrador/marker render once and do
  not become children of a repeating texture pattern.

### 4.2 Fence Boundary Marker

- `174×106 RGBA`, pivot `[0,105]`;
- placement `[1740,122.7072192513369]`;
- positive uniform scale `1740/2992=0.5815508021390374`;
- `runtime_mirror=false`; no negative scale, collision, input, entity or save
  representation;
- opaque body begins at `x=1745.2339572192514`, fully exterior;
- exactly one draw, after layer 16 and before current resources/cues.

### 4.3 Retained render order

```text
meadow tile
→ static 00–09
→ standalone Bicycle
→ static 11–15
→ actors
→ layer 16
→ Fence Boundary Marker
→ current gameplay-required cues
```

Layer 10 remains omitted from runtime; parked and moving Bicycle use the same
single standalone texture. The existing accepted world/Labrador corpus is not
re-imported or regenerated by this correction.

## 5. Field, viewport and camera contract

- `WORLD_WIDTH=1740`; gameplay/buildable field `[0,1740]`;
- viewport/window remains 100% usable width; no PlayerBoot/platform mutation;
- `p=0.15` and, for viewport width `V` and positive zoom `z`:

```text
z_min(V) = 0.85 × V / 1740
z_default = z_min(V)
camera_default_x = 0
allowed z >= z_min(V)
camera_max = max(0, 1740 - 0.85 × (V / z))
```

- at default/right clamp, boundary `x=1740` maps to `0.85V`; accepted reserve
  is `13–17%` viewport width;
- outside-field meadow is visual only: non-buildable, no station, A–H, idle,
  dog activity or hidden input target;
- camera/zoom/tile phase/marker/drag state are non-persisted presentation;
  launch/restore/resize recomputes framing and clamps without checkpoint write;
- existing one-shot asset mapping `1740/2992` remains unchanged;
- normal viewport clipping is allowed; source crop/stretch is not.

Technical preflight pins accepted static material rows `[20,224)` and the
runtime vertical-fit cap:

```text
s = (1740 / 2992) × z
z_fit_max(H) = H / ((224 - 20) × (1740 / 2992))
z_max = min(1.05 × z_min, z_fit_max)
baseline = clamp(H - 36, (211 - 20) × s, H - (224 - 211) × s)
```

For `3840×224`, `z_fit_max=1.888122605364`; default fits
`y=[0,222.545…]`, capped right end fits `y=[0,224]` and
`camera_max=11.2987`. `2992/3456` retain `1.05×z_min` and
`camera_max=82.8571`. The source-board `1.05×z_min` sample at 3840 is a
source-QA diagnostic, not the runtime `z_max`. Any native material clip or
source-bound drift is `STOP_D024_VERTICAL_FIT_3840`.

## 6. Input, passthrough and precedence

Mouse-drag pan is presentation navigation, not a D-023 input:

1. Control and existing player-gate hit targets win before drag detection.
2. A candidate begins only on non-interactive ground inside `[0,1740]`, only
   when `camera_max>0`.
3. Movement becomes pan only after `8 screen px`; release produces no click.
4. Marker/exterior `x>1740` is click-through and cannot start pan or gameplay.
5. Screen/world/input transforms use the same camera/zoom values; invalid or
   exterior roots fail closed.
6. Pan/zoom emits no task, selector-H, save, resource, reward, progression or
   cursor output.

The passthrough polygon captures only non-interactive in-field ground while a
pan range exists, plus existing authorized controls. With no pan range it
captures controls only. Exterior/marker space remains click-through. No UI may
cross the exterior reserve. Native passthrough failure is
`STOP_D024_PLATFORM_PASSTHROUGH`, not permission to edit PlayerBoot/platform
code.

Native macOS input/window/passthrough verification is a mechanical gate where
testable; it is not a screenshot-production method. External desktop imagery is
not required for current D-024 acceptance.

## 7. Ordinary player presentation cleanup

Debug-only primitives must be absent in ordinary player mode:

- semantic/debug labels and state cards;
- prototype resource/cue cards that are not contract-required player surfaces;
- route/anchor/contact lines, circles, bounds, pivots and hit-test geometry;
- developer overlays and persistent prototype `Show UI` button.

They may remain behind an explicit dev/capture mode which cannot be entered by
normal F5/player startup and is separately captured for diagnostics.

Gameplay-required surfaces must not be silently removed:

- exact D-023 player confirmations and accepted Order/Route/Dog/Postcard state;
- Hide/Show UI functionality and world continuation while UI is hidden;
- accepted Packing note and Van-side progress/postcard cues only in their
  already-authorized states.

In ordinary player mode these use the existing compact, non-overlapping
presentation and stay outside the 15% exterior reserve without obscuring
Labrador/action contact. Technical preflight resolves Hide/Show without a new
look: the prototype visibility button is hidden completely in ordinary player
mode and existing `KEY_H` remains the two-way Hide/Show control. Failure to
recover UI with `KEY_H` in native player mode is
`STOP_CUE_PRESENTATION_UNRESOLVED`.

Physical tokens, Van state, Postcard/progress board, Packing note/question and
slippers remain visible only in their already-authorized states. Dev/capture
mode retains diagnostics separately.

Storage/Kitchen/Packing/Van cards are optional under the Object Contract and
must not be kept as large overlays merely for debug clarity.

## 8. A–H and gameplay non-regression

- keep exactly 12 accepted Labrador rows and selectors A–H;
- start/stop/turn remain presentation transitions, not gameplay states;
- H route remains source `[480,2380]` → world
  `[279.14438502673795,1384.090909090909]` with signed fail-closed guards;
- Kitchen/Packing contact exclusions remain
  `[714.144385026738,839.177807486631]` and
  `[975.2606951871658,1071.798128342246]`;
- `offscreen_left=-160` remains only the hidden D-013 Dachshund/Bicycle absence
  sentinel, not visible field or A–H space;
- one Labrador, one visual adapter and one authoritative gameplay runtime;
- no pickup/attach/carry/place/detach or R48-05B object transfer;
- preserve D-023 `3 + 2`, `x2/x2 → x1/x1`, Quiet Cooperative, player profile,
  checkpoint codec/schema/save barriers and all `33` cursors.

## 9. Exact exclusive implementation scope

Only writer `019f5ce4-e63c-7d33-a586-d2d3031c8610` may write the following.

### 9.1 Additive runtime inputs

```text
steam/assets/prototypes/vertical_slice/authored/world/responsive/meadow_tile_rgba_748x224.png
steam/assets/prototypes/vertical_slice/authored/world/responsive/meadow_tile_rgba_748x224.png.import
steam/assets/prototypes/vertical_slice/authored/world/responsive/fence_boundary_marker_rgba.png
steam/assets/prototypes/vertical_slice/authored/world/responsive/fence_boundary_marker_rgba.png.import
steam/resources/prototypes/vertical_slice/d024_responsive_presentation_v1.json
```

Both PNGs are byte-identical copies of the pinned source exports. The two
sidecars are new. Existing `41 PNG + 41 .import` are untouched; final authored
runtime corpus is exactly `43 PNG + 43 .import`.

### 9.2 Runtime owner and dedicated checks

```text
steam/scripts/prototypes/vertical_slice/vertical_slice_demo.gd
steam/tests/vertical_slice_visual/d024_responsive_presentation_test_runner.tscn
steam/tests/vertical_slice_visual/test_d024_responsive_presentation.gd
steam/tools/validate-d024-responsive-presentation.py
steam/tools/capture-d024-responsive-presentation.sh
docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_R48_05A_D024_RESPONSIVE_PRESENTATION_RUNTIME_CAPTURE_v1/**
```

No scene file changes. Rendering, camera, input and passthrough remain in the
existing parent custom-draw/runtime owner `vertical_slice_demo.gd`.

### 9.3 Factual post-PASS status only

```text
docs/repo/status/CODEX_CURRENT_STATUS.md
docs/repo/status/CODEX_STATUS.md
docs/drive/Shelter/04_DEVELOPMENT/CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md
this brief — factual result section only
```

No-touch: existing scene, all current 41 PNG/imports, PlayerBoot/window/platform/
project, profile/checkpoint/schema/33 cursors, game systems/connectors, Labrador
adapter/bindings, source/approved packages and previous evidence.

### 9.4 Capture-only completion resume — 2026-07-14

After the mechanical handback, D-025 platform/capture authority and the completed
compliance edits, new sole writer `019f6604-8ac6-7871-85c8-2c858a2240f3` is
activated only for:

```text
steam/tests/vertical_slice_visual/test_labrador_visual_binding.gd
steam/tools/capture-d024-responsive-presentation.sh
docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_R48_05A_D024_RESPONSIVE_PRESENTATION_RUNTIME_CAPTURE_v1/**
```

The two code-side compliance edits are complete. Their §14 hashes must remain
exact; any drift is `STOP_CAPTURE_PATH_NONCOMPLIANT` rather than authority for
another edit. The only expected mutation is:

- regenerate the existing unsealed D-024 evidence root with compliant
  real-framebuffer Godot self-captures, macOS native/mechanical logs and the final
  immutable seal.

No new capture subsystem is authorized. `vertical_slice_demo.gd`, State/Control
Connector, PlayerBoot/platform/project, gameplay runtime, assets/imports,
profile/checkpoint/A–H, source/approved packages and prior sealed evidence are
no-touch. No additional writer may participate.

## 10. Required checks

### 10.1 Source/import

- package hashes/ledger/QA exact;
- byte equality for both runtime PNG copies;
- exactly one meadow texture loaded and repeated only for visible X range;
- marker loaded/drawn once, positive scale, exterior bbox proof;
- no repeated static layer/building/Bicycle/Labrador;
- seam/alpha/import checks at runtime scale and fractional camera positions.

### 10.2 Responsive/input

- 2992, 3456 and 3840 default/right clamp;
- reserve `13–17%`, field boundary and marker placement exact;
- resize/default/zoom/pan clamps and common render/input transform;
- player-gate precedence, `8 px` drag threshold and release-no-click;
- exterior/marker click-through and no UI crossing reserve;
- native macOS window/input/passthrough behavior where testable, without
  platform mutation and without conflating the probe with screenshot creation;
- 3840 vertical-fit review.

### 10.3 Gameplay/regression

- First Day and Day 2 normal path;
- exact `3 + 2` confirmations and `x2/x2 → x1/x1`;
- full `33`-cursor restore/advance sweep;
- save success, save failure/Retry, recovery and restore;
- A–H, both stations/both approaches, both true physical turn-mid directions;
- normal-speed complete H cycle and all fail-closed guards;
- zero new transfer/mechanic/entity/persistence output.

## 11. Immutable evidence matrix

Evidence root must be new and immutable:

```text
docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_R48_05A_D024_RESPONSIVE_PRESENTATION_RUNTIME_CAPTURE_v1/
```

Required:

- current game imagery through existing Godot self-capture only: viewport
  `save_png`, State Connector `capture.screenshot`, 10-second / 2 FPS PNG
  `capture.video.start` or the dedicated D-024 SubViewport runner;
- the runner's full 27-PNG matrix from a normal GUI-capable macOS Godot session
  with a real framebuffer; headless/dummy output is diagnostic only and cannot
  close visual evidence;
- macOS native PlayerBoot/window/input/passthrough mechanical evidence where
  testable; external desktop/window screenshots are not required for current
  acceptance;
- 2992/3456/3840 default/right-end RGBA, checker and black diagnostics;
- clean player presentation with debug primitives and persistent `Show UI`
  absent;
- separate dev-mode diagnostic capture proving observability remains;
- A–H, Kitchen/Packing both sides, contact-align and true turn-mid both ways;
- one complete normal-speed H motion trace/video and fail-closed journeys;
- native `216/144/96` clean and silhouette boards from the same runtime;
- actual 3840 vertical-fit capture;
- First Day, Day 2 offered, Day 2 completion and Quiet Cooperative;
- manifest, hashes, validator output, cursor/checkpoint regression and no-touch
  readback.

If desktop/native-window context outside the Godot viewport is specifically
needed, the only second visual path is macOS Screenshot UI through Computer Use.
There is no third/ad-hoc path. If both allowed paths are unavailable, the pack
stays `BLOCKED / UNSEALED`.

No previous sealed evidence pack may be mutated. The current 31-file D-024 root
is explicitly unsealed and may be regenerated only by the §9.4 capture owner
before its first final seal.

## 12. Stop conditions

Return without scope expansion on:

- `STOP_NOT_EXECUTABLE` — no PM activation/exact writer;
- `STOP_SOURCE_HASH_DRIFT` — any pinned source mismatch;
- `STOP_D024_SEAM_OR_TAIL` — seam, stretch, hole, gutter or black/alpha tail;
- `STOP_D024_MARKER_AUTHORITY` — duplicate, interactive, in-field or mirrored marker;
- `STOP_D024_COORDINATE_TRANSFORM` — render/input/station/H transforms diverge;
- `STOP_D024_INPUT_PRECEDENCE` — pan steals gates/clicks or exterior input;
- `STOP_D024_PLATFORM_PASSTHROUGH` — native passthrough requires platform scope;
- `STOP_CAPTURE_PATH_NONCOMPLIANT` — unchanged runner reaches
  `/usr/sbin/screencapture`, writes Windows fields or proposes a third/ad-hoc
  capture path;
- `STOP_D024_VERTICAL_FIT_3840` — material static-art clipping unresolved;
- `STOP_CUE_PRESENTATION_UNRESOLVED` — required cue/Hide-Show behavior needs a
  new UI/Art decision;
- `STOP_AH_OR_GAMEPLAY_REGRESSION` — A–H, D-023, cursor/checkpoint/save drift;
- `STOP_WRITER_OWNERSHIP` — more than one writer or wrong thread;
- `STOP_SCOPE_EXPANSION` — PlayerBoot, platform, profile, checkpoint, game
  systems, source regeneration, new mechanic/entity/room/transfer required.

## 13. Technical preflight and PM activation

Technical verdict: `SIGNED_TECHNICAL_PREFLIGHT` with no remaining blocker.

Accepted plan:

- additive `2 PNG + 2 .import + 1 presentation JSON`;
- modify only `vertical_slice_demo.gd` as runtime owner;
- dedicated D-024 test runner/test/validator/capture;
- exact tile/marker/field/camera/input/passthrough contracts above;
- `3840` vertical-fit cap and native stop boundary;
- ordinary-mode prototype visibility button absent; existing `KEY_H` restores
  two-way Hide/Show;
- D-025 supersedes the prior Windows-evidence clause: Windows is outside the
  current implementation/QA/evidence/WARN/blocker/acceptance queue;
- all stated no-touch and gameplay/A–H/33-cursor boundaries retained.

Historical implementation-activation verdict: `ACCEPTED / EXECUTABLE`.

Initial implementation writer: `019f5ce4-e63c-7d33-a586-d2d3031c8610`.

Active capture-only completion writer: `019f6604-8ac6-7871-85c8-2c858a2240f3`.

## 14. Historical mechanical handback and initial macOS-only capture resume

Initial implementation handback:

```text
MECHANICAL_PASS_CANDIDATE
UNSEALED
NATIVE_CODEX_HOST_BLOCKED_PRE_GODOT
```

Verified pre-compliance implementation pins:

```text
vertical_slice_demo.gd 2b616890113bf75afd4b67ed95cb67a0b00b1834301d098f7afce573e3b103b9
d024_responsive_presentation_v1.json 99054d11b2168ec93fee3c80ba9c57b16d4e45ca5862ea68d12224ba74976f0c
test_d024_responsive_presentation.gd 6dc93e9e7610d43a64a495637a3b0388ba6518408cf91e98142013707417abb8
validate-d024-responsive-presentation.py 55ce0aea5141cbda2d368f0452a289254c44ec8f05de47e1659b89549e4a04c9
capture-d024-responsive-presentation.sh 2a37ecae5caff8f358da7da69e5fdaddc0dd20b83ddc3c3c9b3aecd3070677f6 (superseded for the active resume)
```

Completed capture-compliance pins:

```text
test_labrador_visual_binding.gd 14a37141f418cc38e998d47a2ae678b5ade1c5ebf1a3d3022b4ffd577d1744b8
capture-d024-responsive-presentation.sh 7cbedb8582e79d044ec0550f0f7391ef4abd286be02b482f43d907f4b9f4f25f
```

The exact `43 PNG + 43 .import` corpus, D-024 validator, Godot import/check,
2992/3456/3840 responsive tests, A–H/12 rows/33 cursors and safe
profile/checkpoint/restart/SIGKILL/Retry regressions pass. The evidence root has
31 files and no final `HASHES.sha256`; its unsealed ledger SHA is
`3c4a58cdebfa1244cd6e432627c10e3e085568996f83894bacee18c1f0ad7828`.

The historical AppKit/HIServices abort occurred before Godot/project
initialization with Godot `4.5.1` at
`/Users/barsulka/Downloads/Godot.app` and parent `Codex/ChatGPT`. At that time
no repeat was attempted. D-027 now classifies this narrowly as historical
version/environment evidence, not a current D-024 runtime failure and not proof
against Steam Godot `4.7` or ordinary shell launch; the former broad no-repeat
inference is superseded.

Technical reconciliation verdict:

```text
SIGNED_TECHNICAL_RECONCILIATION
MACOS_ONLY
GODOT_SELF_CAPTURE_READY
```

Producer/PM verdict:

```text
CAPTURE_ONLY_RESUME_ACCEPTED
EXECUTABLE
ONE_WRITER_ONLY
MACOS_ONLY
FINAL_RUNTIME_ART_USER_ACCEPTANCE_PENDING
```

The existing D-024 test runner already produces the full 27-PNG visual matrix;
State Connector already provides screenshot and 10-second / 2 FPS PNG capture.
No new capture implementation is needed. The two compliance edits in §9.4 are
complete and pinned above. At that historical activation, capture-only writer
`019f6604-8ac6-7871-85c8-2c858a2240f3` was directed to run the existing
self-capture/mechanical surfaces from a normal GUI-capable macOS session, seal
the existing evidence root and return it for independent Art/user review.
That instruction is not the current launch authority; the current HOLD and
reactivation gate are stated below. Windows is not part of this gate.

### Authority-contract tool correction result — 2026-07-15

The current authority/compiler gate is the immutable contract digest, not a
mutable whole-file brief or PM-status hash:

```text
tool_correction_status=PASS
authority_contract_scheme=raw-bytes-between-markers-v1
authority_contract_sha256=4f956a077d0a93575ef7b518fd0aa9fb409392a08fd4a48190364795bc9b5cbf
pre_code_brief_sha256_B=eb32b3d791e32d0abbcb1a790cac9acc8588058ac452f4b1dee810be22f43d7b
validator_sha256_V=a0b4c0da2679118083409f306a77db4be6952e8d268fc3bcff38f90975c09f0f
runner_sha256_R=add7777692d0f1eefbf0e2e4ce5b8984722b1433fb735835e58ad0137ab5d949
labrador_no_touch_sha256=14a37141f418cc38e998d47a2ae678b5ade1c5ebf1a3d3022b4ffd577d1744b8
evidence_root_files=31
evidence_seal=absent
unsealed_ledger=30/30
```

The validator `--authority-only` and normal validator paths pass; strict marker
and mutation matrix passes `6/6`; Python compilation, runner syntax and diff
checks pass. The historical whole-file/status hashes `721191…`, `00c89…`,
`d94969…` and `98e3…` remain provenance only and are not current compiled gates.

Current Producer/PM verdict:

```text
TOOL_CORRECTION_PASS
CAPTURE_REACTIVATION_PENDING_COORDINATOR_ACK
EVIDENCE_HOLD
UNSEALED
ONE_WRITER_ONLY
MACOS_ONLY
```

This paragraph is historical pre-mechanical-gate status. Current authority is
§0C: capture remains HOLD through runner atomicity correction, independent
review PASS and PM Phase 2. Only a later literal ACK naming unchanged `A`, the
new whole-file brief SHA, new runner SHA and pinned partial tree may authorize
sole writer `019f6604-8ac6-7871-85c8-2c858a2240f3` to invoke the existing
runner once through direct Codex shell/sh in the logged-in macOS GUI session.
The runner then launches Steam Godot `4.7` without `--headless`; no GoLand or
Terminal.app requirement applies.
