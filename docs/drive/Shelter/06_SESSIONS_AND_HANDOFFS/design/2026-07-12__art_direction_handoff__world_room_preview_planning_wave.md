# Art Direction Handoff — World / Ground / Building / Room Preview Planning Wave

Дата: 2026-07-12
Роль: Art Director / Project Manager consolidation
Статус: handoff-history
Область: Steam/Desktop world, ground, Building and room-window preview R&D

---

## 1. Что делали

- сверили фактический world/room asset inventory, Semantic Asset Pack, Vertical Slice placeholders и room scaffold;
- создали два proposed planning documents для visual production coverage;
- провели Sheet A — exterior ground / fence / bicycle-yard preview;
- провели Sheet B — Dog House / Kitchen exterior-to-room preview;
- проверили deterministic assembly, alpha/bounds/provenance и 216/144/96 evidence;
- получили формальный Art Director sign-off по обоим sheets.

Никакие product/game mechanics, runtime contracts, room states, taxonomy decisions, production assets или final style не принимались.

---

## 2. Knowledge documents

```text
docs/drive/Shelter/03_DESIGN/00_VISUAL_DIRECTION/STEAM_DESKTOP__Visual_Production_Roadmap_v1.md
docs/drive/Shelter/03_DESIGN/00_VISUAL_DIRECTION/STEAM_DESKTOP__World_And_Room_Asset_Vocabulary_v1.md
```

Оба документа имеют статус:

```text
proposed / preview-R&D planning, not production art approval
```

Coverage vocabulary не является заказом на производство всех перечисленных assets, rooms или transitions.

---

## 3. Sheet A result

Статус:

```text
PREVIEW_RESEARCH_ONLY — NOT PRODUCTION ART — NO STYLE LOCK
Formal Art verdict: WARN
Root contract FAIL: none
```

Доказано:

- low continuous world band и empty-top desktop coexistence;
- rear/front fence depth;
- parked Basket Bicycle relation без dog choreography;
- broad yard/fence/Bicycle readability at 96 px;
- bounded A1 ground / A2 fence-yard / A3 contact-decor / deterministic assembly process.

Не доказано:

- production terrain kit, material grammar или final palette;
- authored broad transition masks;
- production pivots/import/adjacency;
- live-strip composition/performance.

Перед production-candidate terrain нужны quieter texture, stronger path-versus-sand distinction, authored broad transitions и softer service-pad perimeter.

Frozen evidence root:

```text
/Users/barsulka/.codex/visualizations/2026/07/11/019f50cf-d2b5-7d62-b31f-abdf5e42f15c/shelter_world_room_rnd_2026-07-11/
```

---

## 4. Sheet B result

Статус:

```text
PREVIEW_RESEARCH_ONLY — NOT PRODUCTION ART — NO STYLE LOCK
Formal Art verdict: WARN
Root contract FAIL: none
```

Доказано:

- bounded B1/B2 pair-runs plus deterministic B3 assembly are a workable preview process;
- Dog House и Kitchen различимы под согласованными camera/baseline/dog-scale conventions;
- room-window composition читается отдельно от strip exterior;
- Dog House остаётся occupancy/rest only;
- Kitchen-only EMPTY/IDLE/BUSY/OUTPUT comparison переиспользует один визуальный shell и не создаёт runtime states;
- at 144 px bed/station focus reads; at 96 px broad occupancy/room function survives.

Не доказано:

- exact reconstruction двух комнат из одного authored modular shell;
- production layers, pivots, occlusion masks, import bounds и foreground trim;
- short_long / large_sturdy clearance, identity, poses, weight или contact choreography;
- accepted Food Mix output asset/state;
- room runtime, window topology, performance или connector parity;
- Building/Utility taxonomy для Packing / Van / Dispatch / Garden;
- final style/palette/material grammar.

Frozen evidence root:

```text
/Users/barsulka/.codex/visualizations/2026/07/11/019f50cf-d2b5-7d62-b31f-abdf5e42f15c/shelter_world_room_rnd_2026-07-11/sheet_b/
```

Frozen Sheet B manifest SHA-256:

```text
e40815d329fd6d69b4e1dd318fe06d4e5b888fd5e273a60288788876d17560f3
```

No Sheet C, image repair, import, runtime binding, room implementation or production wave is authorized by this result.

---

## 5. Current boundaries and open gates

- R-29 / Day 2 remains closed and is not reopened by this visual R&D.
- No successor executable product/game scope is selected.
- Kitchen Live Detail remains an evidence-backed candidate only.
- An authored identical-layer modular-shell spike is an Art prerequisite before any production-candidate room step.
- A separate world composition tech spike, dog Stage A proof or Kitchen runtime slice each requires its own explicit decision and Codex brief where implementation is involved.
- Packing / Van / Dispatch / Garden taxonomy remains unresolved.
- Production rights, source/import contracts, final visual style and family-specific contact remain open.

---

## 6. Knowledge GC

Current Memory:

- record that Sheet A and Sheet B are closed as preview-only Art `WARN`, without root contract failure;
- keep the next executable scope unselected.

Knowledge:

- the two proposed Art planning documents above;
- existing D-011, Building System, Dog Life, Dog Visual Language and task/object contracts remain authority by their own statuses.

History / evidence:

- this handoff;
- frozen external Sheet A / Sheet B bundles and manifests.

Superseded:

- none.

---

## 7. Repository boundary

The visual generation wave changed no tracked scenes, runtime, Semantic Asset Pack or production files.

The separate `.gitignore` entry for `tmp/` was explicitly authorized directly by the user in the Visual Prototype session and is user-owned; it is not an Art decision or production-pipeline approval.

No stage, commit or push was performed by the Art planning / preview wave.
