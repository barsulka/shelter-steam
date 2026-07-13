# R48-05A Labrador Runtime Capture v5 — Art Owner Split Review

- Reviewer: independent Art Director runtime owner
- Review time (UTC): `2026-07-13T15:16:33Z`
- Evidence pack: `STEAM_R48_05A_LABRADOR_RUNTIME_CAPTURE_v5`
- Pipeline QA profile: `shelter-dog-animation-pipeline`, `hybrid`, evidence-only, fail-closed
- Art v4 authority: `db6e3027c2d6a1d341dcf51ecb00c494c841548f712841116e7c9a5551a3db7d`
- Source-package status: **SOURCE-READY remains unchanged**
- Technical/Codex result: **PASS**
- Bounded v5 Technical Art gate: **PASS**
- Overall player-facing visual coherence: **CHANGES_REQUIRED / USER_OWNER_REJECTED_CURRENT_LOOK**
- Overall runtime Art PASS: **not granted**

## Mandatory split verdict

### 1) Bounded v5 Technical Art gate — PASS

The exact local Packing mask/contact/scale correction passes its bounded Art
gate. This verdict covers only the accepted v4 resolutions
`A) ACCEPT_STATE_SPECIFIC_WORK_ENVELOPE` and
`C) ACCEPT_BOUNDED_OCCLUSION_POLICY` in the existing R48-05A brief.

It does not approve the overall dog design, building placement, meadow
composition, station art, production style or user-facing visual result.

### 2) Overall player-facing R48-05A visual coherence — CHANGES_REQUIRED / USER_OWNER_REJECTED_CURRENT_LOOK

PASS is prohibited by the direct user/owner verdict. The current dogs do not
match the expected previously fixed art, building placement is not accepted,
and the clearing/meadow does not match the accepted view.

Therefore v5 does **not** grant any of the following:

- claim `prototype look resolved`;
- user acceptance;
- overall runtime Art PASS;
- production-art, station-art or final-style approval.

The bounded mask PASS cannot be promoted into any of those claims.

## Authority and immutable input readback

Pre-review fingerprints matched the delegated expected values:

- `HASHES.sha256`: `0f83134e4f27aa5599a27a3789dfdfad0136aec23c70e6a7f3c6dcb11fc6e3b8`;
- `capture_manifest.json`: `9041c812a82cf233658532b29b865bd4c9cfd49a5098adaa7ca69cfdc5422447`;
- pending `OWNER_REVIEW.md`: `c9a962255dce44defa644d6ac498461f83871533c4fcd345343a81e79fef1ce6`;
- v4 Art authority: `db6e3027c2d6a1d341dcf51ecb00c494c841548f712841116e7c9a5551a3db7d`.

The accepted actor/action boundary remains `dog.labrador_intro`, selectors A–G,
with no pickup/attach/carry/place/detach and no R48-05B transfer acceptance.

## Evidence inspected

The owner review inspected actual existing evidence, not metrics alone:

- First Day A/B, both C start/walk/stop lanes, D/E/F and EXIT;
- Day 2 A/B, both C lanes, D/E/G and EXIT;
- Quiet Cooperative;
- both physical-turn directions in clean and silhouette views;
- both Packing sides for D/F/G/contact-held EXIT in clean and silhouette views;
- positive Packing mask cells and negative C/released/Kitchen controls;
- complete changed-pixel and readability evidence at 216/144/96;
- four `1x_normal` motion strips plus their start/walk/support/stop frames;
- cancellation before contact, loop-boundary G, save failure/retry and stale suppression;
- all six `legacy_unbound` First Day/Day 2 captures;
- actual full-layout, proportional frame, full desktop placement, exact window crop
  and alpha-over-checker evidence.

## Bounded gate readback

### Scale, crop, root and baseline — PASS

- exact uniform positive scale: `0.24`;
- negative scale: absent;
- non-uniform or state-specific scale: absent;
- PlayerBoot: `2992x224`, full-width, bottom delta `0`;
- every reviewed Labrador bbox is complete and uncropped;
- root/baseline/pivots remain unchanged;
- minimum native top/bottom margins are `89/31 px`, above the accepted floor.

No PlayerBoot, camera-fit, source-pose or root compensation is used.

### State-specific 216/144/96 envelope — PASS

| State family | Accepted minimum | v5 minimum | Result |
| --- | --- | --- | --- |
| general A/B/C/D/turn/EXIT/non-work recovery | `80/52/35` | `80/54/36` | PASS |
| Kitchen E | `74/49/33` | `74/49/33` | PASS |
| Packing F | `79/53/35` | `79/53/35` | PASS |
| care/focus G | `73/49/32` | `73/49/32` | PASS |

At the actual sizes, current-source identity and action-category continuity are
preserved. At 216, muzzle/paw/focus detail remains visible; at 144, morphology,
work pose and station relation remain legible; at 96, dog, broad action category
and main station context remain separable. This is a bounded current-source
readability finding, not reconciliation with the earlier expected dog art.

### Both-side contact — PASS

| Station | Side | Muzzle gap | Muzzle in plane | Working paw in plane |
| --- | --- | ---: | --- | --- |
| Kitchen | from-left | `3.714207 px` | yes | yes |
| Kitchen | from-right | `3.714207 px` | yes | yes |
| Packing | from-left | `2.063448 px` | yes | yes |
| Packing | from-right | `2.063448 px` | yes | yes |

All gaps are within the accepted `<=4 px` bound. Clean full-layout and silhouette
captures preserve a readable approach/contact/work direction on both sides.

### Packing selector-scoped mask — PASS

All `8/8` positive cells activate the local mask only for Packing D/F/G and
contact-held EXIT. All `6/6` negative controls keep it inactive.

Positive from-right cells prove that the correction removes a real collision:

| Cell | Raw before mask | Forbidden after mask | Hidden paw-tip after mask |
| --- | ---: | ---: | ---: |
| D | `404 / 2239` screen/source-alpha | `0 / 0` | `0 px` |
| F | `167 / 890` screen/source-alpha | `0 / 0` | `0 px` |
| G | `315 / 1771` screen/source-alpha | `0 / 0` | `0 px` |
| contact-held EXIT | `197 / 1097` screen/source-alpha | `0 / 0` | `0 px` |

The from-left positive cells also remain at `0 / 0` forbidden overlap. The
actual result uses none of the optional `<=5 px` distal-paw allowance.

Visual inspection confirms that the former rail cut through the torso is gone
in D/F/G/contact-held EXIT, with no head/muzzle/torso/tail/full-leg cut and no
new identity-silhouette notch. The local foreground interruption is covered by
the actor and does not form a visible rectangular seam in the contact states.

Negative contexts are interpreted correctly: Packing C, released A and Kitchen
D/E restore ordinary authored foreground ownership and intentionally do **not**
use the Packing-contact exception. Their raw world/actor overlap is not a failed
positive mask cell; it proves that the selector-scoped mask is not stuck or
globally reordering `world.fence.front_span`.

The evidence retains:

- source mutation: false;
- global z reorder: false;
- gameplay authority: false for the derived presentation mask;
- normal foreground ownership outside the exact Packing contact selectors;
- no task/effect/object overlay hiding or false transfer cue.

### Motion, turns and recovery — PASS for bounded regression

- four strips are captured at `1x_normal`;
- each strip has seven frames, six even visible root intervals and
  `max_interval_ratio=0.166667`;
- start, multiple walk supports and stop settle remain visually distinct;
- both right→mid→left and left→mid→right turns retain locked roots and positive scale;
- cancellation/recovery does not leave a stale mask, focus layer or duplicate dog;
- scale, cadence and baseline do not pop at mask activation or release.

### Desktop/transparency and no-transfer boundary — PASS for bounded regression

The actual desktop composite keeps the `2992x224` strip bottom-aligned and the
checker evidence confirms transparent exterior ownership. There remains exactly
one runtime and one Labrador.

All `legacy_unbound` Unload/Carry/LoadVan captures retain the primitive lane.
`transfer_acceptance_cells=0`; v5 makes no pickup, attach, carry, place, detach
or station-replacement claim.

Packing Table remains a temporary semantic placeholder/reference. This bounded
review does not grant Packing Table runtime Art PASS.

## Human Art gates versus Technical metrics

| Gate | Bounded v5 result | Boundary |
| --- | --- | --- |
| current-source identity continuity | PASS | not earlier-art reconciliation |
| silhouette continuity | PASS | not overall dog-design approval |
| action/station readability | PASS | only existing A–G scope |
| contact and weight | PASS | no transfer/object handling |
| calm motion continuity | PASS | no final animation-polish claim |
| mask visual integrity | PASS | only selector-scoped Packing correction |
| overall dog/building/meadow coherence | CHANGES_REQUIRED | direct user-owner rejection |

This separation follows the pipeline rule that validators may prove structure
and measurements but cannot self-approve aesthetics or overall visual quality.

## Remaining reconciliation need — separate next task

This review stops after v5. It does not open v6 and does not authorize source or
runtime edits.

The next task must be a separate **read-only** comparison of current v5 against
the earlier accepted art/captures/contracts, producing an exact matrix for:

1. dog identity — morphology, proportions, head/muzzle/ears/tail,
   coat/markings, silhouette, scale and character;
2. building placement — exact positions, baselines/perspective, relative scale,
   spacing, overlap/z and van/Kitchen/Packing/world hierarchy;
3. meadow composition — accepted clearing bounds, grass/ground/fence grammar,
   density, negative space, desktop crop/coverage and overall composition.

Each matrix row must name the accepted source path/hash/capture, the current v5
evidence path/hash, the visual delta, severity and source-versus-integration/
camera/scale/composition classification.

Only after that comparison may an Art-owned reconciliation brief define the
selected references, non-negotiables and a separate source/runtime/evidence
sequence. No correction is chosen in this document.

## Final owner verdict

- **Bounded v5 Technical Art gate: PASS.** The exact Packing mask/contact/scale
  correction satisfies the v4 A+C contract without crop, forbidden overlap,
  global z change, source mutation or transfer expansion.
- **Overall player-facing R48-05A visual coherence: CHANGES_REQUIRED /
  USER_OWNER_REJECTED_CURRENT_LOOK.** Prototype-look-resolved, user acceptance
  and overall runtime Art PASS are not granted.

Next owner: the same Art Director under a separately delegated read-only
reconciliation comparison task. This review recommends no v6 iteration.
