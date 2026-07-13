# R48-05A Labrador Runtime Capture v3 — Art Owner Review

- Reviewer: same independent Art Director owner
- Review date: `2026-07-13T13:32:33Z`
- Evidence pack: `STEAM_R48_05A_LABRADOR_RUNTIME_CAPTURE_v3`
- Accepted scope: bounded R48-05A / P0-B + P0-D; no object transfer and no
  authored Packing Table replacement
- Final v3 owner verdict: **BLOCKED**
- Technical stop code confirmed: `STOP_UNSUPPORTED_ACTOR_ENVELOPE`
- Source-package status: **SOURCE-READY remains unchanged**
- Runtime Art PASS: **not granted**
- Owner scale decision: **A) ACCEPT_BOUNDED_SCALE_ENVELOPE**

## Exact owner decision

The immutable v3 result is **BLOCKED**. The current `0.60` runtime capture is
not visually acceptable and cannot receive `PASS` or `WARN`: the Labrador's
head and upper silhouette are clipped by the top edge in ordinary A–G,
station, turn, motion and review-size evidence. Art does not accept this crop
as part of the current Labrador contract.

The Art owner selects:

> **A) ACCEPT_BOUNDED_SCALE_ENVELOPE.** A smaller uniform positive runtime
> scale is accepted under the same brief, without a PlayerBoot/window change.
> The exact next trial value is **`0.24`**.

This decision withdraws `0.60` as the next-trial Art requirement after the
real `2992x224` full-width transform proved it invalid. It does not grant a
blanket Art PASS to every value below `0.579`, and it does not pre-approve the
next executable. `0.24` must be captured and measured against the conditions
below.

No PlayerBoot height, platform/window policy, root, baseline, horizontal-fit
or non-uniform-scale decision is made by Art. With the accepted `0.24` trial,
Technical can continue inside the same accepted R48-05A brief while preserving
all of those authorities.

## Independent evidence readback

The review inspected actual full-layout evidence, not only normalized
previews:

- First Day `A`, `B`, both Cook/Pack `C` start/walk/stop, `D`, Kitchen `E`,
  Packing `F` and EXIT context;
- Day 2 `A/B/E/G`, Quiet Cooperative and the proportional context frame;
- both synthetic station sides for Cook and Pack, clean and silhouette;
- both physical `right -> turn_mid -> left` and reverse sequences, clean and
  silhouette;
- all four normal-speed `1x_even` strips and representative underlying frames;
- clean and black-silhouette evidence at native and declared `216/144/96`;
- cancellation/recovery and stale/save-failure suppression;
- actual desktop full-display, exact window-region and alpha-checker captures;
- all six First Day/Day 2 `legacy_unbound` transfer negatives;
- manifest, selector snapshots and the complete v3 hash ledger.

Independent pixel readback confirms:

- `macos_desktop_full_display.png`: `2992x1934`;
- `macos_desktop_window.png`: `2992x224` and a pixel-identical RGB crop of the
  full display at `(x=0, y=1710)`, so the window is now honestly full-width and
  bottom-hugging;
- First Day `A` clean-vs-silhouette changed bbox is approximately
  `(365, 0)..(843, 192)`;
- First Day `F` is approximately `(1402, 0)..(1879, 195)`;
- Day 2 `G` is approximately `(1402, 0)..(1878, 195)`;
- every representative Labrador bbox therefore touches `y=0`; this is a real
  crop, not a measurement-only warning.

The stored v3 manifest reports the same hard truth with its deterministic
method: native changed bbox `x=367, y=0, w=474, h=190`, resample heights
`184/123/82`, and `native_bbox_touches_top_edge=true`.

## Envelope mathematics and v2/v3 comparison

The Technical blocker is correct and must remain fail-closed:

```text
full-width zoom = 2992 / 1740 = 1.71954022988506
source non-shadow height = 225 px
v3 full identity at 0.60 = 225 * 0.60 * zoom = 232.137931 px
locked viewport height = 224 px
minimum overflow = 8.137931 px
viewport-only no-crop scale ceiling = 0.578966131907
```

The actual crop is visually stronger than the minimum overflow comparison
because the accepted root/baseline is not at the viewport's bottom edge.
Choosing a value immediately under `0.579` would therefore solve only the
total-height inequality, not the scene hierarchy or demonstrated top-edge
margin.

The v3 full-width camera also explains why the dog became larger despite the
numeric change from `1.0` to `0.60`:

```text
v2 effective screen scale = 1.0 * (1120 / 1740) = 0.643678
v3 effective screen scale = 0.60 * (2992 / 1740) = 1.031724
v3 / v2 effective ratio = 1.602857
```

Thus v3 fixes actual desktop extent and placement, but makes the full Labrador
envelope about `1.60x` the v2 screen envelope. The v2 dog was already rejected
as too large relative to the van and stations; v3 is larger again and clipped.

## Art QA gates

### 1. Actual window, world coverage and transparency

- **PASS** for actual `2992x224` full usable width and zero-pixel bottom delta.
- **PASS** for the honest authored `0..1536` span, declared non-authored
  `1536..1740` tail, absence of non-uniform world stretch and continuous
  horizontal coverage.
- **PASS** for transparent desktop composition in the checker and full-display
  evidence.

This resolves the v2 partial-width upper-left-island failure. It does not
resolve the actor envelope.

### 2. Labrador identity, silhouette and proportions

- **PASS at source identity level:** morphology, markings, facing/asymmetry and
  equipment separation remain recognizable where visible.
- **FAIL at runtime visual-integrity level:** the top crop removes part of the
  head/ear silhouette and invalidates a whole-character read.
- **FAIL for world hierarchy:** at `0.60` the Labrador is much larger than the
  van, Kitchen and Packing Table and again reads as a giant actor in a miniature
  strip.

The numeric `216/144/96` heights pass the stored thresholds, but a bbox that
begins at `y=0` is already cropped. Threshold PASS cannot turn an incomplete
silhouette into Art PASS.

### 3. A–G, Kitchen E, Packing F and focus G

Selectors and effects exist, and `E/F/G` are technically distinguishable.
At `0.60`, however, the dog dominates the station and effect layers. Kitchen
and Packing objects read as small attachments to a clipped dog instead of the
main action objects. The temporary rectangular Packing composition is more
conspicuous, not less.

This gate is **BLOCKED by scale/crop**. It is not a request for new action art,
a station replacement or transfer imagery.

### 4. Station sides, muzzle/paw contact and front-lip ownership

Both approach sides and allowed facings are present. Contact intent is visible,
but current scale causes excessive object overlap; from-right Packing places a
large body across the table/front band. Muzzle and paw relationships cannot be
accepted while the full actor is clipped and the station is visually
subordinate.

This is an implementation registration/scale gate. The existing code-drawn
Packing Table remains an accepted temporary semantic placeholder.

### 5. Physical turns and continuity

Both physical turn directions, positive-coordinate authored facings,
`turn_mid` and locked roots are present. No negative-scale shortcut was found.
The turn source/coverage gate is **PASS**, but the runtime result remains
blocked because side views clip and the side-to-mid mass change is exaggerated
by scale.

### 6. Start/walk/stop and ordinary-speed motion

All four strips retain distinct start, at least two walk supports, stop settle,
seven even timestamp samples, six visible root intervals and maximum interval
ratio `0.1667`. Motion structure is **PASS/WARN** pending the accepted rescale.
No timing or gameplay change is requested. The next capture must show that the
same movement remains readable at ordinary speed after `0.24` registration.

### 7. Native 216/144/96 readability

- Stored changed-pixel heights `184/123/82` exceed `80/52/35`.
- Every representative review bbox still touches the top edge.
- Result: **FAIL for visual integrity despite numeric threshold PASS**.

### 8. Cancellation/recovery

Pre-contact, immediate stale suppression, recovered idle, loop-boundary state,
save-failure suppression and retry recovery are represented. This evidence
shape remains **PASS**, while recovered actor frames inherit the scale/crop
blocker.

### 9. Legacy negatives and zero transfer

**PASS.** First Day and Day 2 Unload, Carry and LoadVan remain
`legacy_unbound`; the authored adapter is not falsely used as transfer
coverage. `transfer_acceptance_cells=0` is preserved. There is no
pickup/attach/carry/place/detach Art claim.

### 10. User-visible rectangle-prototype problem

The actual desktop strip now occupies the intended full-width bottom region,
which is a material improvement over v2. The result is still not acceptable as
the bounded 05A answer: the clipped giant Labrador overwhelms the authored
world and emphasizes the temporary rectangular station. The problem is
improved in window composition but not resolved in actor/world hierarchy.

## A) Accepted bounded scale lane

Art accepts the following exact next-trial authority:

1. Labrador runtime scale: **uniform positive `0.24`** in both authored
   facings and `turn_mid`; negative and non-uniform scale remain forbidden.
2. Preserve the actual `2992x224` PlayerBoot window, full-width fit, current
   world mapping, locked root/baseline and bottom placement. Art requests no
   PlayerBoot/platform mutation.
3. With the current transform, source-envelope projection predicts:

```text
native full identity height = 225 * 0.24 * (2992 / 1740) = 92.855172 px
216 review height = 89.538916 px
144 review height = 59.692611 px
96 review height  = 39.795074 px
```

These are predictions, not measured acceptance. The next immutable pack must
measure at least `80/52/35 px` at `216/144/96`, with the complete clean and
silhouette bbox strictly inside every image. Minimum edge margins:

- native and 216: at least `4 px` clear above the highest identity pixel;
- 144: at least `3 px`;
- 96: at least `2 px`;
- no lower-edge crop, root drift or baseline change at any size.

4. Linear anchor reprojection for the `0.24` trial may start at:

```text
Kitchen approach/exit = 104.16; contact = 62.88; work = 54.24
Packing approach/exit = 104.16; contact = 60.00; work = 50.88
```

Technical may tune only station-local registration within the already
accepted contact planes. It may not move the gameplay root or invent a new
station/art authority.

5. Contact acceptance at native ordinary speed requires, from both sides:

- muzzle and working paw reach the accepted object/contact plane with no
  visible floating gap greater than `4 px`;
- no penetration through the station body;
- Packing front lip may cover only the local paw tips, never head, torso,
  muzzle, full foreleg or task object;
- Kitchen `E`, Packing `F` and focus `G` remain distinguishable without labels;
- the dog, action direction and main station prop remain readable in black
  silhouette and at `216/144/96` under the skill's native-size meanings.

6. Preserve four even normal-speed strips, two physical turn directions,
locked roots, cancellation/recovery, one runtime/one Labrador and all six
legacy negatives. No new gameplay timing, mechanics, rooms, transfer cells or
station replacement is authorized.

## Failure classification

- **Current immutable v3 runtime result: BLOCKED.** Hard top crop and rejected
  actor/world proportions prevent runtime Art acceptance.
- **Source/contract: PASS for existing scope.** The layered Labrador/world
  package remains SOURCE-READY; no new source pose, facing, turn, station art
  or action vocabulary is required for the next attempt.
- **Implementation/camera-scale/registration: correction required.** The
  accepted `0.24` Art decision removes the scale-authority impasse for a
  same-brief Technical correction.
- **PlayerBoot/platform escalation: not required for this next attempt.** If
  the measured `0.24` result cannot meet the conditions without changing
  PlayerBoot/root/fit, Technical must stop again and route the exact conflict
  to Technical/PM; Art has not chosen that solution.
- **Runtime Art PASS: still open.** No validator, threshold or this scale
  decision self-promotes the next result.

## Required next evidence

Produce a new immutable correction pack under the same accepted brief with:

- actual full-display and exact bottom window-region proof;
- proportional Labrador + van + Kitchen + Packing Table frame;
- actual full-layout A–G and Quiet;
- both station sides and both physical turns, clean and silhouette;
- four ordinary-speed strips plus representative frame readback;
- measured native/216/144/96 complete bboxes and explicit edge margins;
- muzzle/paw/contact/front-lip evidence at the `0.24` trial;
- cancellation/recovery, all six `legacy_unbound` negatives and zero transfer.

## Next owner

Technical/Codex integration owner may perform the exact same-brief `0.24`
scale/anchor-registration correction and produce a new immutable evidence pack.
Then the same Art Director owner must review the actual result. This handback
does not authorize a PlayerBoot/platform change, station replacement, object
transfer, broader source wave, production style lock, stage, commit or push.
