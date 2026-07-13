# R48-05A Labrador Runtime Capture v4 — Art Owner Review

- Reviewer: independent Art Director runtime owner
- Review time (UTC): `2026-07-13T14:31:30Z`
- Evidence pack: `STEAM_R48_05A_LABRADOR_RUNTIME_CAPTURE_v4`
- Pipeline QA profile: `shelter-dog-animation-pipeline`, staged-hybrid evidence-only, fail-closed
- Accepted v3 lane retained: `A) ACCEPT_BOUNDED_SCALE_ENVELOPE`, exact positive uniform scale `0.24`
- Source-package status: **SOURCE-READY remains unchanged**
- Technical/Codex v4 result: **BLOCKED** / `STOP_UNSUPPORTED_ACTOR_ENVELOPE`
- Runtime Art owner verdict: **CHANGES_REQUIRED**
- Runtime Art PASS: **not granted**

## Exact owner decisions

### A) ACCEPT_STATE_SPECIFIC_WORK_ENVELOPE

Art accepts the current compact Kitchen/Packing/focus morphology at exact scale
`0.24`. The lower changed-pixel height is pose compression, not loss of actor
scale: the complete Labrador alpha remains inside the frame, root and baseline
are unchanged, and the dog identity, action vector, station relation and contact
still read in the inspected clean and silhouette evidence.

The following are the exact v4/v-next minimum complete changed-pixel heights.
They are local to the accepted R48-05A Labrador source, the current authored
poses and scale `0.24`; they are not a global breed, style or animation-pipeline
standard.

| State family | 216 review | 144 review | 96 review |
| --- | ---: | ---: | ---: |
| A/B/C/D, turn, EXIT and non-work recovery | `>=80 px` | `>=52 px` | `>=35 px` |
| Kitchen E, including synthetic and First Day | `>=74 px` | `>=49 px` | `>=33 px` |
| Packing F, including synthetic and First Day | `>=79 px` | `>=53 px` | `>=35 px` |
| care/focus G, including Day 2 and recovery | `>=73 px` | `>=49 px` | `>=32 px` |

Every reviewed state must additionally retain:

- a complete, uncropped alpha bbox at native, 216, 144 and 96 review sizes;
- clear top **and** bottom margins of `>=4 px` at native and 216, `>=3 px`
  at 144 and `>=2 px` at 96;
- exact uniform positive scale `0.24`, with no negative or non-uniform scale;
- the accepted root, baseline, pivots and right/left/physical-turn policy;
- no state-specific scale compensation.

At v4 the hard cases meet the accepted state-specific floors: synthetic Kitchen
E is `74/49/33`, First Day Kitchen E is `76/52/35`, synthetic Packing F is `79`
at 216, and Day 2 G is `73/49/32`. At 216, muzzle direction, working paw and
focus gesture remain readable; at 144, morphology, action category and station
relation remain readable; at 96, Labrador versus world, broad work/focus action
and the main station context remain readable. Fine muzzle or focus nuance is not
required to survive at 96.

This decision does **not** waive the no-crop requirement and does not authorize
another scale, PlayerBoot/window/root/fit change.

### C) ACCEPT_BOUNDED_OCCLUSION_POLICY

Art does not accept the current from-right Packing overlap. The measured
`167` native screen pixels / `890` source-alpha samples are entirely
`dog.torso`; visually they form a cut through the body. This is not a valid
contact-plane cue and is not intentional world depth.

The existing accepted source is sufficient. A same-brief implementation
correction may segment, clip or mask the existing `world.fence.front_span` only
while Packing contact ownership is active. The bounded policy is:

1. Apply the contact-local rule only to Packing D/F/G contact lock and its
   contact-held transition/recovery frames, for both approach sides and both
   allowed facings. Before contact lock, after contact release, at Kitchen and in
   all other world states, preserve the authored foreground-span ownership.
2. Do not redraw, translate, rescale or replace the authored span or Packing
   Table. The correction may only change local mask/segmentation/z ownership
   using the existing source alpha.
3. Permitted hiding is limited to the distal tip of the declared contacting
   forepaw from `dog.leg.fore.near` or `dog.leg.fore.far`: only the contiguous
   paw component's lowest `12` source pixels, projecting to no more than `5`
   native screen pixels at scale `0.24` and the accepted full-width zoom.
4. The span must never hide any alpha from `dog.torso`, `dog.head`,
   `dog.muzzle`, ears, collar, tail, non-contact legs, a full foreleg, or any
   task/effect/object overlay. Forbidden overlap is exactly `0` screen pixels
   and `0` source-alpha samples.
5. The permitted paw-tip overlap is optional. A zero-overlap contact result is
   valid if muzzle/paw contact and the station plane still read.
6. The result must not cut the identity silhouette at 216, 144 or 96 and must
   not introduce a global fence reorder, a station replacement or a false
   attach/carry/place/transfer cue.

The existing registration interval cannot solve this collision: the accepted
boundary probe `-2.88 world` still leaves `124/653` overlap, while the first
clear probe `-15.95 world` increases the contact gap to `29.490115 px`.
Therefore the bounded contact-local mask/segmentation is the minimal correct
implementation mechanism; station translation is not.

## Evidence reviewed

The review used actual full-layout captures, not only normalized previews:

- First Day A/B/C/D/E/F and Day 2 G;
- Quiet Cooperative;
- clean and silhouette evidence for both Kitchen and Packing sides;
- both physical-turn directions through right / turn-mid / left;
- four normal-speed motion strips with distinct start, at least two walk
  supports and stop settle;
- cancellation and recovery sequences;
- declared native 216/144/96 resamples;
- real desktop composite, full display, window region and checker evidence;
- all `legacy_unbound` negatives and the zero-transfer readback.

The manifest and image evidence agree on the following facts:

- PlayerBoot is `2992x224`, full-width and bottom-aligned; root/baseline are
  unchanged;
- scale is uniform positive `0.24` for right, left and `turn_mid`;
- Idle A is `91 px` native with `98/35 px` top/bottom margins and
  `89/59/39 px` at 216/144/96;
- Kitchen contact gap is `3.714207 px` and Packing contact gap is `2.063448 px`;
- muzzle and working paw are inside their declared contact plane on both sides;
- all complete actor bboxes are uncropped with substantial top/bottom clearance;
- A–G selection, timing, turn, cancellation/recovery, desktop coverage,
  `legacy_unbound` rejection and zero transfer are preserved;
- the animation library, timing authority and source package are untouched.

## Art gate readback

### 1. Labrador identity, silhouette and scale — PASS

At `0.24`, the current Labrador reads as the same authored dog in clean,
silhouette and ordinary full-layout views. Head/muzzle/ear/tail relationships
survive the native 216/144/96 ladder. The dog no longer dominates or clips the
`224 px` PlayerBoot strip.

### 2. State and motion readability — PASS under decision A

Idle/wait, physical turn, start, walk supports, stop settle, contact, Kitchen E,
Packing F and care/focus G are distinct at ordinary speed. The compact E/F/G
poses reduce height by bending/compression while preserving the action line;
they do not require a scale or source-pose change.

### 3. Right-to-mid-to-left continuity — PASS

Both physical-turn directions preserve identity, root/baseline continuity and
asymmetry policy. There is no negative-scale shortcut.

### 4. World coverage, seam, front fence and z — CHANGES_REQUIRED

Full-width bottom coverage and the authored strip are coherent, and v4 is
materially better composed than v2/v3. The Packing from-right foreground-span
collision is nevertheless a hard visual-integrity failure until decision C is
implemented and evidenced.

### 5. Station contact — PASS mechanically; Art change required for Packing z

Both stations meet the `<=4 px` contact gap and plane-membership checks. Kitchen
contact reads. Packing contact reads only after the torso overlap is removed or
limited to the allowed distal paw-tip policy.

Packing Table remains a temporary semantic placeholder/reference. This review
does not grant station Art PASS and does not request an authored replacement.

### 6. No false transfer claim — PASS

No pickup, attach, carry, place, detach or object transfer is shown or accepted.
The zero-transfer and `legacy_unbound` negatives remain mandatory.

### 7. Rectangle-prototype problem — bounded improvement, not final Art PASS

Compared with the v2 giant hierarchy and the v3 cropped/oversized hierarchy,
v4 establishes a credible Labrador/van/Kitchen/Packing/world proportion and a
substantially more authored strip. The temporary rectangular Packing composition
is still visible by design and remains outside runtime station Art PASS. The
dog/world result addresses the bounded 05A prototype problem, but the torso-cut
foreground error prevents acceptance of this immutable capture pack.

## Source versus contract versus implementation classification

- **Source:** PASS for this bounded correction. The SOURCE-READY Labrador/world
  package remains unchanged; no Art source micro-wave is required.
- **Art contract:** resolved prospectively by owner decisions A and C. Decision A
  accepts pose-specific work/focus height floors; decision C defines exact local
  Packing foreground ownership. Neither decision retroactively passes v4.
- **Implementation/evidence:** CHANGES_REQUIRED. Current v4 violates decision C
  because `dog.torso` is occluded. Technical/Codex was correct to stop fail-closed
  rather than guess Art ownership.

## Minimal same-brief correction and acceptance evidence

A new immutable correction pack may remain entirely within the accepted 05A
brief. It must demonstrate all of the following:

1. exact positive uniform scale `0.24`, PlayerBoot `2992x224`, full-width bottom
   placement, root/baseline and existing source/timing unchanged;
2. the state-family height floors and top/bottom margin floors in decision A at
   native 216/144/96, with no cropped bbox;
3. Kitchen and Packing muzzle gaps `<=4 px` on both station sides, with muzzle
   and working paw inside the declared plane;
4. Packing contact-local occlusion on both sides: `0` overlap for every
   forbidden Labrador layer, and any remaining overlap confined to the lowest
   `12` source pixels / `<=5` native pixels of the contacting paw tip;
5. clean, silhouette and alpha/layer-diagnostic captures for Packing D/F/G and
   contact-held cancellation/recovery, plus an outside-contact control proving
   normal foreground ownership returns;
6. unchanged A–G selection, four motion strips, both turns, Kitchen E, Packing F,
   care/focus G, cancellation/recovery, desktop coverage, all negatives and zero
   transfer;
7. a complete reproducible hash ledger and another independent runtime Art
   owner review.

No PlayerBoot/platform decision, new mechanics, 05B transfer, station
replacement, global z reorder, source-pose wave or style/palette lock is needed.

## Final verdict and next owner

**CHANGES_REQUIRED.** Owner decisions are **A) ACCEPT_STATE_SPECIFIC_WORK_ENVELOPE**
and **C) ACCEPT_BOUNDED_OCCLUSION_POLICY**. The Technical
`STOP_UNSUPPORTED_ACTOR_ENVELOPE` remains an honest result for immutable v4, but
the contract ambiguity is now resolved for a same-brief implementation-only
correction.

Next owner: Technical/Codex for a new immutable evidence pack implementing the
bounded Packing contact mask/segmentation, followed by the same independent Art
owner for runtime review. Runtime Art PASS is not granted by this document.
