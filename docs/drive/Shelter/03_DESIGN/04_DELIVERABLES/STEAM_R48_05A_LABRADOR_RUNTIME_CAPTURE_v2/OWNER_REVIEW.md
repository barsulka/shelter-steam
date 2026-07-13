# R48-05A Labrador Runtime Capture v2 — Art Owner Review

- Reviewer: Art Director owner
- Review date: `2026-07-13T12:53:54Z`
- Evidence pack: `STEAM_R48_05A_LABRADOR_RUNTIME_CAPTURE_v2`
- Accepted scope: bounded R48-05A / P0-B + P0-D; no object transfer and no
  authored Packing Table replacement
- Final owner verdict: **CHANGES_REQUIRED**
- Source-package status: **SOURCE-READY remains unchanged**
- Runtime Art PASS: **not granted**

## Exact decision

The v2 correction is a real technical improvement over v1: the Labrador is
now legible at native and declared review sizes, the four normal-speed motion
strips have even root intervals, both physical turns exist without a
negative-scale shortcut, cancellation/recovery is represented, the authored
world fills the synthetic `1120x224` player capture, and legacy transfer lanes
remain unbound.

It is nevertheless not an acceptable bounded runtime Art result. At runtime
scale `1.0`, the Labrador is approximately `143 px` high in a `224 px` strip
(`63.8%` of the full strip height) and is visually much larger than the van,
Kitchen and Packing Table. The dog overwhelms the task props and makes the
temporary station rectangles more conspicuous. Muzzle/paw contact, front-lip
occlusion and the distinction between work/focus states cease to read as a
coherent Labrador working in this world.

The actual desktop composite is a second blocking failure. The
`1120x224` image in `captures/desktop/macos_desktop_window.png` is a
pixel-identical crop of
`captures/desktop/macos_desktop_full_display.png` at `(x=0, y=100)` on the
`2992x1934` display capture. It therefore occupies only `37.43%` of display
width and is located near the upper-left edge, not in the declared
bottom-hugging companion region. The checker capture proves transparency, but
the actual desktop capture does not prove the intended coverage or placement.

Mechanical and numerical PASS claims do not override these Art failures.

## Evidence reviewed

The review inspected the actual full-layout captures, not only normalized
previews:

- First Day `A`, `B`, Cook/Pack `C` start/walk/stop, `D`, Kitchen `E`,
  Packing `F`;
- Day 2 `G` with `E` continuity, Quiet Cooperative and EXIT context;
- both synthetic station sides for Cook and Pack, clean and silhouette;
- both `right -> turn_mid -> left` and `left -> turn_mid -> right`, clean and
  silhouette;
- all four `1x_even` motion strips plus a representative underlying
  seven-frame sequence;
- clean and silhouette review material at declared `216/144/96` heights;
- cancellation-before-contact, stale-frame suppression, recovery,
  loop-boundary focus, save-failure suppression and retry recovery;
- alpha checker, actual desktop window and full-display composites;
- First Day and Day 2 `legacy_unbound` Unload/LoadVan/Carry negatives;
- manifest, selector snapshots and complete v2 hash ledger.

## Gate readback

### 1. Labrador identity, silhouette and current scale

- **PASS** for Labrador identity and basic silhouette recognition.
- **PASS** for the declared changed-pixel subject heights: native `143 px`,
  `216 -> 137 px`, `144 -> 92 px`, `96 -> 61 px`, above the declared minima
  `80/52/35 px`.
- **CHANGES_REQUIRED** for scale and hierarchy. The `1.0` result reads as a
  giant Labrador over a miniature world and is not the accepted current-
  Labrador envelope in context.
- No crop/root-drift or negative-scale shortcut was accepted as a substitute
  for the correction.

### 2. Idle/wait/start/walk/stop/turn readability

- Start, at least two walk supports and stop settle exist in each of the four
  ordinary-speed sequences. The six visible root intervals are even and the
  normal-speed evidence is materially better than v1.
- At the current scale the short `0.324 s` traversal still reads partly as a
  very large figure sliding through a small environment; stop settle is
  subtle. This is **WARN**, to be rechecked after the scale correction rather
  than treated as a new source-animation request.
- Both physical turn directions and a distinct `turn_mid` are present with a
  locked root. Turn coverage is **PASS**, subject to the same scale/composition
  recapture.

### 3. Right-to-mid-to-left continuity

**PASS** for source identity, directional coverage, asymmetry policy and the
absence of a negative-scale mirror shortcut. The large apparent mass change
through `turn_mid` is visually loud at scale `1.0`, but does not require a new
turn source wave before the bounded scale correction is tested.

### 4. World coverage, seam, front fence and z-order

- The synthetic `1120x224` full-layout captures show continuous authored
  strip coverage through the declared authored `0..1536` span and honest
  non-authored tail to `1740`; no new seam failure was found there.
- Front fence/ground layering is readable in ordinary clean captures.
- **CHANGES_REQUIRED** for actual PlayerBoot desktop composition: the full-
  display evidence does not match the declared window extent or bottom edge.
  A synthetic `1120x224` capture is not sufficient proof of the actual
  desktop layout.

### 5. Kitchen/Packing contact and temporary anchors

**CHANGES_REQUIRED.** Both approach sides and allowed facings are present, but
at `1.0` the Labrador dwarfs the stations. Kitchen `E` reads mostly as standing
beside a small stove; Packing `F` reads as a large dog overlapping a small
brown rectangle. The silhouette passes conceal too much of the action object,
and Pack-from-right approaches the right crop edge. Muzzle/paw contact and
front-lip ownership are not yet visually trustworthy.

The current code-drawn Packing Table remains an allowed temporary semantic
placeholder. This verdict does **not** request a station-art replacement and
does not revoke the accepted placeholder boundary.

### 6. Kitchen E, Packing F and focus G

Selectors and technical state changes exist. In contextual motion/still
reading, however, `E/F/G` are not distinct enough as object-contact/work/focus
beats because the oversized dog dominates the object and effect layers.
This is an implementation registration/scale/composition failure, not a
request for new mechanics or transfer imagery.

### 7. Cancellation and recovery

**PASS** for the evidence shape: pre-contact, stale-frame suppression,
recovered idle, loop-boundary `G`, save-failure suppression and retry `F` are
all represented. The recovered `F/G` frames inherit the unresolved scale and
contact failure and must be included in correction evidence.

### 8. Desktop transparency and coverage

- **PASS** for transparent-background composition in the alpha checker.
- **CHANGES_REQUIRED** for actual desktop extent and placement. The real
  full-display image shows the content as a partial-width upper-left island,
  not the declared bottom companion strip.

### 9. Legacy negatives and zero transfer

**PASS.** All six First Day/Day 2 Unload, LoadVan and Carry negatives remain
`legacy_unbound`; no authored Labrador action is falsely bound to them. The
manifest declares `transfer_semantics: false` and zero transfer acceptance is
preserved. Pickup/attach/carry/place/detach remains 05B/out of scope.

### 10. User-visible rectangle-prototype problem

**Not resolved for R48-05A runtime Art.** The authored strip is a meaningful
improvement over the old empty rectangle in the synthetic player layout, but
the actual desktop composite still reads as a partial-width island and the
oversized dog amplifies the temporary rectangular station composition. A
Packing Table art replacement is not required; proportion, registration and
real window composition are.

## Failure classification

- **Source/contract: PASS for this correction.** The accepted Labrador/world
  source package remains SOURCE-READY; no missing source pose, facing, physical
  turn or R48-05A world layer blocks the next attempt.
- **Implementation/camera/scale/composition: CHANGES_REQUIRED.** Runtime scale,
  station registration/occlusion and actual desktop layout are the blockers.
- **New Art micro-wave: not required before the next executable.** The same
  accepted brief and source package can produce the bounded correction.
- This decision is not a global style/palette lock and grants no runtime Art
  PASS.

## Minimal bounded corrections

1. Set the Labrador to a uniform positive runtime scale of **`0.60`** for the
   next proof; do not use negative scale for facing. This predicts about
   `86 px` native subject height and about `82/55/37 px` at `216/144/96`, still
   above the declared `80/52/35 px` minima while restoring world hierarchy.
   The prediction is not acceptance: capture and measure it.
2. Reproject the existing numeric station offsets by the same `0.60` factor as
   the bounded starting registration: Kitchen approach/contact/work
   `260.4/157.2/135.6`; Packing `260.4/150.0/127.2`. Tune only as needed to
   land the muzzle and working paw on the accepted contact plane. The front
   lip may own paw-tip overlap; it must not hide the torso, head or task object.
3. Reconcile real PlayerBoot window extent with the declared desktop layout.
   If the runtime authority remains a `2992x224` bottom-hugging companion
   window, actual captured content must cover that intended window region and
   sit at the bottom edge without non-uniform stretching. If the accepted
   runtime window is instead `1120x224`, declare and capture that real window
   honestly at the bottom edge; do not present its crop as full-width proof.
   This is a Technical/window-composition correction under the same brief, not
   an Art-source expansion.
4. Preserve the even root timing, distinct start, two walk supports, stop
   settle, locked-root physical turns, accepted selectors and zero-transfer
   behavior. Do not add mechanics, rooms, station replacement or 05B imagery.
5. Produce a new immutable correction pack with actual full-layout
   `A/B/C/D/E/F/G`, Quiet, both station sides, both turn directions, clean and
   silhouette evidence, normal-speed motion, measured `216/144/96`,
   cancellation/recovery, all legacy negatives and an actual full-display
   desktop composite. Include one side-by-side proportional frame showing the
   Labrador, van, Kitchen and Packing Table together.

## Acceptance conditions for the next Art review

- Labrador identity remains readable at measured `216/144/96`, but the dog no
  longer visually exceeds the van/stations as the dominant scene-scale object.
- Muzzle/paw contact reads at ordinary speed from both allowed station sides;
  the Packing front lip owns only the intended local paw overlap.
- `E`, `F` and `G` read as Kitchen work, Packing work and Packing focus without
  relying on labels or a new transfer claim.
- Both physical turns, start/walk/stop, cancellation/recovery and zero-transfer
  negatives remain intact after rescaling.
- Actual desktop evidence matches the declared companion-window size and
  bottom placement; authored/non-authored world coverage is honest and no
  unintended right/top empty region is represented as game coverage.
- The temporary Packing Table may remain a semantic placeholder, but the whole
  scene must no longer read as a giant dog beside a tiny rectangle.

## Next owner

Technical/Codex integration owner: apply only the bounded runtime
scale/registration/window-composition correction under the accepted brief and
produce a new immutable evidence pack. Then return it to the same Art Director
owner for runtime Art re-review. No runtime implementation authority is
created by this review outside that accepted brief.
