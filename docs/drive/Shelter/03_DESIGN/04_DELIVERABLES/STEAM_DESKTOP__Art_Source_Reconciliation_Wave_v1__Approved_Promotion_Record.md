# STEAM_DESKTOP — Art Source Reconciliation Wave v1 — Approved Promotion Record

Дата: 2026-07-13
Статус: **APPROVED_PROMOTION_COMPLETE / DIRECTION_ONLY / NOT_RUNTIME_EXECUTABLE**
Владелец promotion: Art Director
Authority: user-owner + Producer / Project Manager

## 1. Authority and frozen source

PM/User acceptance:

`STEAM_DESKTOP__Art_Source_Reconciliation_Wave_v1__PM_User_Source_Acceptance.md`

SHA-256:
`b10726d34f027a4052f11cf1313aa987bc7640b3e5835c116d6d8e61cc172235`

Frozen layered source package:

`STEAM_DESKTOP__Art_Source_Reconciliation_Wave_v1/`

| Frozen record | SHA-256 |
|---|---|
| `HASHES.sha256` | `7abc64cc21025a08312a63a8cfd7486652854f4fdf30d12179fd072161f9600b` |
| `SOURCE_MANIFEST.json` | `c825bac41a7721553eb725fb00d14c4e7aba94832ae8ab605db68624e135616b` |
| `INVENTORY.json` | `e43ec9562333e1ad30ead7be7f83c3484214221b06a4c4f360d84037952c66c3` |
| `PROVENANCE.md` | `8253e955def0c1766f21f1db1a71cb18556be57d1341bea0846cdfbbb4c85f80` |
| `ART_QA.md` | `3405df1466d8bc821f54eae4874f43bedb384aab011315532ade32d660c88fbe` |

Frozen package readback at acceptance: 606 files; ledger 605/605 PASS;
QA 157/157 PASS; 34 ORA masters; 24 Labrador pose families.

## 2. Exact promotion inventory

Promotion is a byte-for-byte copy. No crop, resize, recompression, alpha edit,
colour edit or other pixel mutation occurred.

| Source path in frozen package | Promoted target | SHA-256 source = target | Dimensions / mode | Approved role |
|---|---|---|---|---|
| `evidence/full_layout/full_layout_native_2992x224_rgba.png` | `approved_art_files/STEAM_DESKTOP__full_scene_d011_reconciled_v1__approved_direction.png` | `5f3ea55c54ac12e9460816bf60911c3905eec238c90fb9b9ac1aa30a895e2357` | 2992×224 RGBA | Composition Direction Board; transparent-upper-reserve source direction |
| `evidence/labrador/labrador_A_H_action_coverage_board.png` | `approved_art_files/STEAM_OVERLAY__dog_labrador_intro_A_H__approved_direction_board.png` | `f36a24927e037338bf40e06a2577bced2ddd124aab8940bda23bc1046db4ad4e` | 1440×1500 RGBA | Identity / Action Direction Board; 24 A–H pose families |

Both target names were absent before promotion. Existing approved files were
not overwritten, renamed or deleted.

## 3. Master/source boundary

The two promoted PNGs are flattened **direction references**, not editable
masters and not runtime exports.

Full-scene layered authority:

`STEAM_DESKTOP__Art_Source_Reconciliation_Wave_v1/source/world/world_master.ora`

SHA-256:
`61855b8a6ae27872d9c8daac32365e4bb2ff44a265e2834b866bb71f31aa5de6`

Labrador layered authority:

`STEAM_DESKTOP__Art_Source_Reconciliation_Wave_v1/source/labrador/poses/*/*_master.ora`

There are 24 pose masters. Their exact individual hashes are retained in the
frozen package `HASHES.sha256`; the exact set and paths are frozen by
`INVENTORY.json` and `SOURCE_MANIFEST.json` hashes above.

The opaque dark field of the Labrador board is intentional review-board
presentation. It is not an actor background or alpha/import contract. The
full-scene promoted PNG is the RGBA native export with transparent upper
reserve; the prior white cell/sky matte defect is absent.

## 4. Provenance / AI / rights declaration

- Production owner: Art Director + Visual Production owner.
- Production date: 2026-07-13.
- AI-use: declared; built-in OpenAI `imagegen` was used for the preserved
  flattened generation originals.
- Exact backend model version and seeds: UNKNOWN / NOT SURFACED BY TOOL.
- Editable derivatives: semantic OpenRaster masters plus lossless RGBA layers,
  built with Python 3.12.13, Pillow 12.2.0 and NumPy 2.3.5.
- Promoted PNGs were copied from the accepted package without pixel changes.
- User-owner authorized the source direction for project use. A separate
  distribution/platform licensing record was not found in local evidence and
  is not invented here; it remains a PM/release gate before external shipping.

Complete prompts, generated-original hashes, user-reference status and rights
caveats remain in the frozen package `PROVENANCE.md` and
`REFERENCE_READBACK.md`.

## 5. Accepted AS-IS advisories

For this bounded integration trial PM/User accepted:

1. Labrador may read slightly shaggy / Golden-like against the user three-view;
   this does not authorize further identity drift.
2. Kitchen retains the detailed approved Kitchen v2.1 service facade.
3. Mill retains source review height 188 px and remains a static decorative
   Utility Prop with zero interaction or mechanic authority.

These are non-blocking source-integration WARN items. Final runtime user
acceptance remains open after actual player captures.

## 6. Deliberately not promoted

- `world_assets_black_board.png`: redundant with full-scene direction and the
  hash-locked layered source package; not needed for the minimal approved set.
- checker/black diagnostic boards: evidence only.
- reference-comparison boards containing prior/user reference pixels: evidence
  only, not a promoted master or direction asset.
- generated flattened originals: provenance inputs only.
- individual ORA/PNG layers: remain in the frozen source package.
- Sheet A: zero reuse.

## 7. Scope boundary and next gate

This promotion does not create runtime/code/import authority, runtime Art PASS,
shipping approval, gameplay changes or permission to modify the frozen source.

The next executable gate remains a separate accepted Codex brief followed by
bounded integration, immutable native captures, independent Art review and
explicit user-owner runtime acceptance.
