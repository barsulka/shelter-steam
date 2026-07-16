# STEAM_DESKTOP — D-024 Responsive Meadow Amendment v1 — PM/User Source Acceptance

Дата: 2026-07-14
Статус: `ACCEPTED_SOURCE_INPUT / BOUNDED_RUNTIME_TRIAL_ONLY / RUNTIME_NOT_YET_EXECUTABLE`
Владелец решения: User Owner / Producer / Project Manager
Источник:
`STEAM_DESKTOP__Art_Source_Responsive_Meadow_Left_Cluster_Amendment_v1/`

---

## 1. Verdict

Точный D-024 Art source amendment принят как вход для одного bounded runtime
integration trial. Пользователь уже выбрал tile/marker/layout behavior и принял
текущую Labrador/building/meadow visual direction. Эта приёмка не является
финальной пользовательской приёмкой runtime-вида, runtime Art PASS, shipping
approval или разрешением на broad pixel loop.

Следующая задача остаётся `PREPARED_FOR_TECHNICAL_PREFLIGHT /
NOT_EXECUTABLE`. Код, runtime assets/imports и evidence не активированы этим
документом.

## 2. Exact accepted package

Package root:

```text
docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Art_Source_Responsive_Meadow_Left_Cluster_Amendment_v1/
```

| File | SHA-256 |
| --- | --- |
| `README.md` | `e92e5ab61850b380e7db0317e7db469ae0ae9515eb16f208abfb85940c058487` |
| `PROVENANCE.md` | `5ccbfcac2bfa1c185a46721058ffe4e6961a84e7969fc932f98efec3d21a63f5` |
| `REFERENCE_READBACK.md` | `e60aba402c7c9b4ba2291ea85ec96bf50f6117a36a0e47ff202028bd460724db` |
| `ART_QA.md` | `f8e2b983cbd8c8494e917c15aba97810c7659a85a0ed60160b66ad5fecf64e78` |
| `SOURCE_MANIFEST.json` | `66dba9bb18a7932fc079055b2bce7645484f3bc084ea3c1427169b2efa81bd89` |
| `QA_REPORT.json` | `82aa32d635b96f82cf52e101485d91cb374e24859d386696d4728b612b44ea2c` |
| `INVENTORY.txt` | `76da63d92b3011082a0c07ff424e3ad4d00465f899c9f735429bdb9b2bc6e293` |
| `HASHES.sha256` | `220a9532f54b8f8ae813f32ac02ef28e35a5d2bde6ded318ecb08a43319e43bf` |
| `tools/build_amendment.py` | `4cef60122de12cf2ae6de83ffc4fb4ed99d77ee24d6fa242aa92b6558a1de2f2` |

Readback: `51` files total, ledger `50/50 PASS`, inventory `51/51`, QA
`48/48 PASS`, deterministic core rebuild byte-identical.

## 3. Accepted exact source inputs

### Meadow tile

- master `source/meadow_tile/meadow_tile_master.ora` —
  `fbd9e9a03a54836933bf912ade049a97d0eaf79c26272fe919c0e626ce8093ea`;
- export `exports/meadow/meadow_tile_rgba_748x224.png` —
  `1cb5845141ad80beba303bc6e0805f10954310eb783a9dfb5ac5f1354e144d40`;
- `748×224 RGBA`, alpha bbox `[0,92,748,224]`, baseline `y=211 px` =
  `122.7072192513369 world units`;
- `tile_world_width=435`, world phase `x=0`; four periods equal
  `2992 source px / 1740 world units`;
- exact seam identity region `8 px`, RGBA/alpha/immediate-boundary delta `0`;
- one texture, X repeat/visible-range only, uniform scale, no Y repeat,
  non-uniform stretch, source crop, gutter, black tail or transparent tail;
- import recommendation: lossless RGBA outside atlases, linear filter, mipmaps
  off, X repeat or explicit repeated quads.

### Fence Boundary Marker

- master `source/fence_boundary_marker/fence_boundary_marker_master.ora` —
  `e04a73af66742472c293eb3bd5925c22d10933243f46f27500713839c08c4111`;
- export `exports/boundary_marker/fence_boundary_marker_rgba.png` —
  `e0237a29119a318cb7b5acb431ed17e7b70d7da3d5386883b335d16ba7416036`;
- `174×106 RGBA`, pivot `[0,105]`, placement
  `[1740,122.7072192513369]`, positive uniform scale
  `0.5815508021390374`, `runtime_mirror=false`;
- opaque body begins at world `x=1745.2339572192514`, fully exterior to the
  field boundary `x=1740`;
- draw slot: after accepted layer 16 and before current resources/cues;
- static decoration only: no input, collision, entity, task, resource,
  progression or persistence authority.

## 4. PM visual and forensic readback

Read directly:

- responsive default/right-end RGBA, checker and black boards at
  `2992×224`, `3456×224` and `3840×224`;
- three-period seam evidence;
- marker checker/black board;
- `216/144/96` readability evidence.

Measured right reserve is `15.006684%`, `14.988426%` and `15.000000%` for
the three widths, in both declared modes. Buildings and Labrador occur once;
the exterior non-meadow/marker delta bbox is `null`.

The initially suspicious dark region in a resized `right_end` preview is not
an opaque black source tail. Raw original sampling confirms:

- checker evidence is fully opaque across the complete top row;
- source RGBA upper reserve remains intentionally transparent;
- every X column of the lower meadow band has occupied alpha at all six
  width/mode combinations;
- missing lower-band X columns: `0`; no black/transparent meadow tail exists.

## 5. Accepted WARN and remaining gates

At `3840` the width-derived zoom may vertically clip the top of existing
accepted static art inside the `224 px` viewport. This is accepted only as a
nonblocking source observation. It must be resolved or honestly retained by
Technical planning and actual runtime capture without regenerating source or
silently changing the D-024 formulas. Final runtime acceptance remains open.

The current runtime also remains `CHANGES_REQUIRED` for ordinary player-facing
presentation until it proves:

- no debug-only cards, labels, lines, circles or geometry in ordinary player mode;
- no persistent prototype `Show UI` control over the scene;
- all contract-required player cues remain usable in a compact,
  non-overlapping envelope and do not cross the exterior reserve;
- complete A–H/contact/true-turn/H-motion and `216/144/96` evidence;
- actual desktop/window/passthrough and responsive runtime evidence.

If an already-authorized gameplay cue cannot be retained without a new UI/Art
decision, implementation stops with `STOP_CUE_PRESENTATION_UNRESOLVED`.

## 6. Scope boundary and sequence

Still unchanged:

- `WORLD_WIDTH` and gameplay/buildable field `[0,1740]`;
- D-023 exact `3 + 2`, `x2/x2 → x1/x1`, Quiet Cooperative and all `33`
  cursors;
- one Labrador, exact 12-row A–H manifest and selector-H fail-closed guards;
- `offscreen_left=-160` only as hidden D-013 absence sentinel;
- no R48-05B/object transfer, rooms, onboarding, background/minimize/
  performance, new mechanic/entity or platform expansion.

Required sequence:

```text
source acceptance — DONE
→ new Codex brief — PREPARED / NOT_EXECUTABLE
→ exact-file Technical preflight
→ separate PM executable activation + exactly one writer
→ runtime integration and immutable evidence
→ independent Art review
→ explicit final user runtime acceptance
```

