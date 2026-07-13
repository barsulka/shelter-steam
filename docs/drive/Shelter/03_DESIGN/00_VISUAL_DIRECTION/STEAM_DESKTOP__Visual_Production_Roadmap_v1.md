# STEAM_DESKTOP — Visual Production Roadmap v1

Дата: 2026-07-11
Роль документа: Art Direction / Visual Production Planning
Статус: **proposed / preview-R&D planning, not production art approval**
Продукт: Steam/Desktop overlay / main-strip visual planning
Владелец: Art Director
Получатели: Producer, Project Manager, Game Designer, Codex, Visual Prototype Research

---

## 0. Назначение и граница

Этот roadmap задаёт порядок визуальной R&D- и production-planning работы для мира Shelter Steam/Desktop:

- main-strip ground / terrain / path system;
- fence и отдельная bicycle service area за забором;
- exterior anchors и дисциплина Building vs Utility Prop;
- room/detail kit и первые interior catalogs;
- interaction anchors между dog execution и world props;
- target-size QA для 216 / 144 / 96 px;
- две первые preview-only generation sheets.

Roadmap **не**:

- утверждает финальный visual style, palette, materials или lighting;
- принимает production assets;
- меняет mechanics, task flow, runtime state, building unlocks или room scope;
- разрешает room implementation;
- выбирает dog rig / animation tool;
- делает exhaustive vocabulary обещанием произвести все перечисленные ассеты;
- заменяет `STEAM_DESKTOP__Building_System_v1.md`, `STEAM_DESKTOP__Dog_Life_Model_v1.md` или dog-action authority.

Главная формула:

> Сначала доказать одну общую world-layer grammar и один отдельный room-window grammar; только после этого планировать production assets.

---

## 1. Обязательные источники

### Current Memory / role boundary

- `PROJECTS_RULES.md`
- `AGENTS.md`
- `docs/drive/Shelter/00_START_HERE/BOOTSTRAP_CONTEXT.md`
- `docs/drive/Shelter/00_START_HERE/000_ROLE_ART_DIRECTOR.md`
- `docs/drive/Shelter/00_START_HERE/05_DOCUMENTATION_GOVERNANCE.md`
- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__CURRENT_CONTEXT.md`
- `docs/drive/Shelter/03_DESIGN/ART_DIRECTION__CURRENT_CONTEXT.md`
- `docs/drive/Shelter/00_START_HERE/EVIDENCE_READ_POLICY.md`

### Active / proposed Knowledge

- `D-011_Cozy_Modular_Diorama_Candidate_A.md`
- `D-011_Steam_Overlay_Main_Strip_v1_Rules.md`
- `STEAM_DESKTOP__Building_System_v1.md`
- `STEAM_DESKTOP__Dog_Life_Model_v1.md`
- `DOG_VISUAL_LANGUAGE_v1.md`
- `DOG_RUNTIME_AND_ANIMATION_GRAMMAR_v1.md`
- `STEAM_DESKTOP__Dog_Action_And_Activity_Vocabulary_v1.md`
- `STEAM_DESKTOP__World_And_Room_Asset_Vocabulary_v1.md`

### Reference / evidence, not production authority

- `STEAM_DESKTOP__Semantic_Asset_Pack_v1/`
- `docs/drive/Shelter/03_DESIGN/01_REFERENCES/screenshots/room_window_references/README.md` and four current Yog-Sothoth's Yard screenshots
- `STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v3/`
- `docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Art_UX_Review__First_Day_MVP_v3.md`
- `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/approved_art_files/D-011_steam_overlay_main_strip_v1_reference.png`

Evidence policy:

- First Day v3 is the current prototype visual-language evidence;
- Semantic Asset Pack is a semantic registry / prototype placeholder library;
- room screenshots are structural references, not style targets;
- ignored root `tilesets/` may be inspected only as local structural reference inventory until rights are proven; it is not approved art and nothing from it may be copied into production.

---

## 2. Current truth

### 2.1 What is already proven

- Main overlay is a bottom-hugging living strip with a large transparent desktop region above.
- Dogs, physical actions and carried objects must read before building decor.
- Current First Day sequence uses semantic anchors for Road Sign / route, Storage, Kitchen, Packing Table and Van Endpoint.
- First Day v3 contains 216 / 144 / 96 prototype captures and is accepted only as visual-language evidence; asset crops, alpha edges, dog/action identity and production readability remain unapproved.
- Main strip is proven as the current composition. A separate room/detail view is a draft Building System proposal and is not yet visually proven.
- Building System proposes `main strip anchor + room/detail window`.
- Dog action vocabulary explicitly separates dog execution from world / prop / room ownership.

Playable inventory is narrower than the visual vocabulary: exactly six Semantic RGBA PNG placeholders are loaded—Road Sign, Basket Bicycle, temporary Storage, temporary Kitchen, temporary Delivery Van Endpoint and composite Food Mix / Food Bag. Ground/path, Packing Table, dogs, separate resources and UI are code-drawn or absent. Companion Field atlases/forest animals are temporary tech-demo content only. There is no production-ready world/room candidate.

### 2.2 What is not proven

- production ground, grass, dirt/sand, path or transition assets;
- fence, gate, yard depth or behind-fence bicycle staging;
- shared footprint, shadow, occlusion and contact grammar;
- exterior Building shells for the current anchors;
- any room-window production composition;
- wall/floor/window/door kit, furniture kit or decoration slots;
- dog-to-room-prop contact at seat, bed, book, board, rocking chair, toy or bowl;
- production style, palette, material detail or import pipeline.

### 2.3 Current visual bottleneck

The next world-art bottleneck is **world cohesion**, not another label/card pass:

```text
transparent desktop boundary
-> shared ground/contact system
-> terrain/path transitions
-> Building vs Utility silhouette discipline
-> controlled fence/yard depth
-> separate room-window composition
```

---

## 3. Status language

Roadmap tasks and vocabulary rows use these authority statuses literally:

| Status | Meaning |
| --- | --- |
| `accepted evidence` | A function/composition principle is evidenced by accepted current review. It does not mean the shown art is production-ready. |
| `prototype placeholder` | Usable only for prototype continuity/evidence; not a production asset or style precedent. |
| `existing proposal` | Appears in a draft/working Art or Game Design source; not accepted implementation scope. |
| `user-requested visual candidate` | Explicitly requested for visual planning/R&D; needs role acceptance before production/implementation. |
| `future-only` | Coverage for later planning; excluded from current production commitment. |

Priority is separate from authority:

- `P0` — minimum visual foundation or first proof;
- `P1` — next useful modular kit after P0 review;
- `P2` — future expansion / production lock work.

An exhaustive vocabulary is a **coverage map**, not an asset-count commitment.

---

## 4. Recommended first proof

### R48-05A-S — authorized source-only game-first wave

После cross-role owner preflight и Producer/PM convergence разрешена отдельная source-only wave:

```text
bounded authored world source set
+ layered dog.labrador_intro master
+ Packing Table / Kitchen station-anchor records
→ source-level Art review
→ SOURCE-READY only
```

Canonical package record:

```text
docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Playable_World_Labrador_Source_Package_v1/README.md
```

Граница:

- no Godot/runtime/code mutation;
- no object transfer/socket/attach/detach;
- Sheet A/B and preview Labrador remain reference-only;
- source Art PASS/WARN does not activate Codex or prove runtime Art PASS;
- final palette/style/prompt remains Art-owned and is not selected by this roadmap update.

### Proof A — Exterior Ground + Fence + Bicycle-Yard Kit

This is the first recommended art/world proof because it has the highest immediate player-visible value:

- it affects the full width of the main strip;
- it tests a replacement grammar for the current flat green-line/brown-bar placeholder;
- it introduces depth without interior clutter;
- it makes the user-requested bicycle area visible without defining new bicycle mechanics;
- it can be previewed in parallel with Day 2 implementation;
- it does not require production dog animation or room runtime.

Minimum proof scene:

```text
transparent desktop above
-> shared low ground base
-> grass + dirt/sand + path masks
-> broad transition edges
-> fence back layer + gate opening + fence front/occlusion layer
-> separate behind-fence bicycle service pad
-> Basket Bicycle parked behind fence
-> Road Sign / one current anchor as scale reference
-> one neutral dog silhouette as scale/contact reference only
```

The proof does **not** decide:

- whether the dog rides, pulls, pushes or uses a sidecar;
- whether the fence is a gameplay gate;
- permanent world layout;
- final terrain materials or palette;
- production asset slicing/import.

Exact generation brief and QA gates live in `STEAM_DESKTOP__World_And_Room_Asset_Vocabulary_v1.md` §17.

---

## 5. Dependency graph

```text
Authority/status map
        |
        v
World + room vocabulary ----------------------+
        |                                     |
        v                                     v
Sheet A: ground/fence/yard              Sheet B brief only
        |                                     |
        v                                     |
Art review: layer/contact/readability          |
        |                                     |
        +-----------> shared scale rules ------+
                                              |
                                              v
                              Sheet B: exterior-to-room kit
                                              |
                                              v
                               Art review: room composition
                                              |
                     +------------------------+-------------------+
                     |                                            |
                     v                                            v
          future production asset brief                 future dog-room action brief
          (requires style/rights/tech)                   (requires GD scope acceptance)
```

Production work remains blocked until the relevant preview gate and ownership decision pass.

---

## 6. P0 — world grammar and first preview proof

### P0 goal

Prove that Shelter can have a coherent, readable lower world edge before producing buildings or rooms.

### P0 tasks

| ID | Task | Output | Dependencies | Gate |
| --- | --- | --- | --- | --- |
| `VP-P0-01` | Publish status-safe world/room vocabulary | `STEAM_DESKTOP__World_And_Room_Asset_Vocabulary_v1.md` | Current docs and evidence | No mechanics/style promoted silently. |
| `VP-P0-02` | Prepare Sheet A generation run | Preview-only run outside repo | Vocabulary + exact brief A | Sources, rights and output status declared. |
| `VP-P0-03` | Generate Sheet A | Kit row + assembled scene + 216/144/96 sheet | `VP-P0-02` | No baked UI/text; bicycle remains parked reference. |
| `VP-P0-04` | Art review Sheet A | PASS/WARN/FAIL report | `VP-P0-03` | World boundary, transitions, contact, occlusion, readability. |
| `VP-P0-05` | Reconcile anchor taxonomy blockers | Decision request, not silent edit | Semantic Pack + Building System | Packing/Dispatch/Garden and status drift returned to Producer/PM. |
| `VP-P0-06` | Propose and version preview naming/manifest shape | Proposed manifest for later brief | Vocabulary | Governance/retention remain pending; manifest does not become runtime schema. |

### P0 minimum asset coverage

- transparent desktop boundary / empty-top composition;
- common ground base;
- grass mass + sparse tuft accent;
- worn dirt and soft sand masks;
- main path / work lane;
- grass↔dirt, grass↔sand and ground↔path transitions;
- fence back segment, front occluder segment, post/end/corner and gate-opening segment;
- bicycle service pad / yard mask;
- local contact shadow layer;
- Basket Bicycle as semantic reference only;
- scale silhouettes for one dog and one current anchor.

### P0 acceptance

P0 passes when:

1. The strip still reads as a transparent desktop companion.
2. Ground materials read as broad masses at 96 px without texture noise.
3. Path and transition edges do not look like hard pasted rectangles.
4. Fence back/front layers create depth but do not hide the dog/action focal area.
5. Bicycle is unmistakably behind the fence while no ride/tow mechanic is implied.
6. Contact shadows and asset baselines are consistent.
7. No source with unknown rights is promoted or copied.
8. Alpha edges are clean, bounds are unclipped and no baked white/gray ground patches remain.

Any PASS here means `PREVIEW_RESEARCH_ONLY` R&D proof pass, never production approval.

---

## 7. P1 — exterior anchors, room kit and second preview proof

### P1 goal

Prove that one visual system can distinguish:

- low strip-scale Building exterior;
- Utility Prop / station;
- separate room-window cutaway composition;
- dog interaction anchors inside a room without inventing room mechanics.

### P1 tasks

| ID | Task | Output | Dependencies | Gate |
| --- | --- | --- | --- | --- |
| `VP-P1-01` | Prepare Sheet B generation run | Exact exterior-to-room brief | P0 scale/contact review | Building vs Utility pairing explicit. |
| `VP-P1-02` | Generate Sheet B | Exterior kit + room shell + example cutaways | `VP-P1-01` | Separate strip and room LODs; no zoomed exterior shortcut. |
| `VP-P1-03` | Art review Sheet B | PASS/WARN/FAIL report | `VP-P1-02` | Shell, station, dog contact, occlusion, state overlays. |
| `VP-P1-04` | Test first room catalog as coverage | Catalog contact sheet, not asset pack | P1 room shell | All rows retain proposal/candidate status. |
| `VP-P1-05` | Validate neutral interaction-anchor geometry | Native-scale annotated `RESEARCH_ONLY` evidence | GD vocabulary row statuses | Choreography, animation, runtime binding and production room art fail closed without accepted external authority. |
| `VP-P1-06` | Estimate preview reuse/correction proxy | Art planning note | One reviewed exterior + room | Production cost remains unproven until an authored modular-source/import spike. |

### P1 first room catalog coverage

1. Dog House — living/rest room.
2. Storage — shelf/sorting room.
3. Kitchen — prep/mixing room.
4. Packing — Packing Table room candidate; the current Semantic Pack Utility-Prop interpretation conflicts with Packing Table/Workbench/Building proposals and remains a governance blocker.
5. Dispatch — dispatch board/postcard archive candidate; the current Van Endpoint Utility-Prop interpretation conflicts with Dispatch Building proposals and remains a governance blocker.
6. Learning House — classroom, library and lab candidates.
7. Garden corner — Inspiration Tree / quiet garden zone, not visible crop-farming core.

This catalog is based on draft/proposed Building/Dog Life sources. It does not authorize implementation or building unlocks.

Current cross-role planning evidence recommends, **if Producer/User later authorizes one executable room after Day 2**, a narrow Kitchen Live Detail / One-Room Continuity Proof because it can reuse the accepted Kitchen/CookTask/input/Food Mix chain. That is not accepted scope here. Sheet B remains an earlier visual comparison of Kitchen mixing room vs Dog House personal room at the same shell, camera and dog scale. Storage is only a low-cost fallback; House of Curiosity/research remains out of the first proof; rocking chair remains separate from it.

### P1 acceptance

P1 passes when:

1. The same semantic function has distinct strip and room compositions.
2. A Utility Prop remains visually a prop even when placed inside a room.
3. Room shell is reusable without every room becoming the same reskin.
4. Door/window/station/furniture layers have explicit pivots and occlusion order.
5. Neutral anchor/clearance evidence for one bed/seat/book or station is physically readable at room scale; dog choreography requires separately accepted authority.
6. `empty / idle / busy / output` are visual layers over one shell, not an invented runtime state machine.
7. The room remains dog-first, not furniture- or UI-first.

---

## 8. P2 — production candidate expansion

P2 is future-only until Producer/User accepts a production wave and the preceding R&D passes.

Potential P2 work:

- final style board and material/palette lock;
- production ground atlas / modular terrain kit;
- production exterior family and variant rules;
- first approved room shell and furniture family;
- expanded dog-room interaction set;
- decoration slot library;
- multi-room overview LOD if product scope later requires it;
- scenic/windowed mode environment;
- platform/import/performance validation;
- production asset registry migration from semantic placeholders.

P2 must not begin merely because a P1 preview is attractive.

---

## 9. Strip-scale and room-window gates

### 9.1 Main strip

| Target | Required reading |
| --- | --- |
| `216 px` | Material family, depth, contact footprint, anchor silhouette, dog action and main prop; secondary accents may survive. |
| `144 px` | Building/Utility type, dog action, large prop and broad path/fence relation without labels. |
| `96 px` | Landmark silhouette, dog + movement/action category and one large task object; text and microdecor are invalid channels. |

All three targets require hidden-UI review and a large transparent/empty region above.

### 9.2 Room window

The same numbers describe **dog subject height inside the room preview**, not the room-window pixel dimensions:

| Dog subject height | Required reading |
| --- | --- |
| `216 px` | Exact room prop/contact, pose, main station, occlusion and calm intent. |
| `144 px` | Dog action + dominant furniture/station + room function. |
| `96 px` | Occupancy + broad action category; fine paw/book/fabric detail may disappear and must not be a hard gate. |

Room-window review is separate from strip review. A room is not accepted by shrinking its exterior sprite or enlarging the strip asset.

---

## 10. Day 2 parallelism

### May run in parallel with Day 2

- read-only reference and evidence review;
- these two planning documents;
- preview-only Sheet A and Sheet B generation outside repo;
- contact-sheet / silhouette / 216-144-96 QA;
- naming, layer and manifest proposals;
- cost/reuse measurements;
- Art/UX review notes that do not change Day 2 assets/runtime.

### Must wait

- replacing Day 2 semantic placeholders with production art;
- changing anchor positions or world causality;
- adding fence/gate interaction or route blocking;
- committing bicycle ride/tow/hitch choreography;
- implementing room windows or room activities;
- changing Building vs Utility classifications;
- selecting final style/palette/materials;
- importing ignored/local tileset content;
- creating production asset files or runtime manifests.

Day 2 remains an executable prototype/product-language slice. World/room R&D is a separate visual branch.

---

## 11. Cost and scope risks

| Risk | Why it grows | Control |
| --- | --- | --- |
| Strip + room duplication | Every building can become two unrelated illustrations. | Share semantic identity and modular source rules, not one resized asset. |
| Building proliferation | Every station can become a cottage. | Rare Building anchors; Utility Props remain props. |
| Terrain combinatorics | Corners, edges, transitions and states multiply quickly. | Prove broad masks and minimum transitions before variants. |
| Fence complexity | Front/back/gate/occlusion can become a level system. | First proof is visual separation only; no fence mechanics. |
| Room prop explosion | Every activity suggests furniture and animation. | External accepted action manifest + fail-closed room/prop authority. |
| Dog animation dependency | A room can appear ready while interaction clips do not exist. | Approve room shell separately from dog-action production. |
| State explosion | `empty/idle/busy/output` can multiply every asset. | State overlays reuse base shell; do not redraw full rooms by default. |
| Style lock too early | Attractive previews can masquerade as production approval. | All preview outputs retain `RESEARCH_ONLY`. |
| Rights uncertainty | Local packs may lack license evidence. | Structural inspection only; no copy/import until rights are verified. |
| Status drift | Card and manifest mix permission with maturity. | Track authority and visual maturity separately. |

---

## 12. Stop conditions

Stop visual generation or production planning and return to the named owner when:

- a Building/Utility/Zone classification conflicts across current sources;
- a room action lacks accepted room, prop, occupancy or dog-action authority; preview-only neutral anchor/clearance evidence is allowed only when explicitly marked `RESEARCH_ONLY` and contains no choreography/runtime binding;
- a fence, gate, room or prop would introduce a mechanic;
- a bicycle visual would decide ride/tow/sidecar/hitch behaviour;
- an asset source lacks rights/provenance for production use;
- a preview is being promoted to production without Art review;
- 96 px readability depends on text, fine decor or labels;
- a Utility Prop becomes a house or interior module in main strip;
- room UI/grid/unlock assumptions are copied from a reference;
- dog scale, contact or action must change to fit the environment;
- work would require files outside the explicitly approved write scope.

Owner routing:

- Producer / Game Designer — mechanics, scope, actor/activity/room acceptance;
- Art Director — visual taxonomy proposal, style, layers, readability and final visual acceptance;
- Codex / Technical — import/runtime schema, rendering/performance and event binding after a brief;
- Project Manager — status governance, path/retention and conflict resolution.

---

## 13. Open decisions

### Producer/User decisions required before production

1. Which one R&D proof is approved to generate first. Recommendation: Sheet A.
2. Whether any P1 room/activity candidate becomes a future executable slice.
3. Whether Packing/Dispatch receive separate Building shells or remain prop-led anchors.
4. Whether Garden is a zone/Utility cluster or a player-facing Building.
5. When production style lock becomes a priority relative to Day 2 evidence.

Separate governance decisions are required for:

- Delivery Van Endpoint vs Dispatch Building classification;
- Packing Table / Workbench / Packing Building classification;
- D-011 no-interior main-strip rule vs temporary open-front Storage/Kitchen placeholders;
- card↔manifest status drift, noncanonical manifest statuses, unchecked semantic crops and incomplete alpha cleanup.

### Art decisions after preview evidence

1. Ground projection/material simplification.
2. Fence height, occlusion budget and silhouette family.
3. Building exterior family and room-shell visual relation.
4. Shadow/contact grammar.
5. Room decoration density and one-dominant-anchor rule.

### Technical decisions after an accepted brief

1. Asset slicing/import/atlas format.
2. Runtime layer/z/occlusion implementation.
3. Pivot/socket data format.
4. Room-window rendering and performance.

---

## 14. Knowledge-GC classification

This wave should be classified as follows:

- this roadmap — proposed Knowledge;
- `STEAM_DESKTOP__World_And_Room_Asset_Vocabulary_v1.md` — proposed Knowledge/reference;
- First Day v3 captures — History/evidence;
- Semantic Asset Pack — reference/evidence and prototype registry;
- room screenshots — reference evidence;
- ignored root `tilesets/` — local rights-unverified structural reference inventory, not project authority;
- future preview sheets — History/evidence until explicitly promoted by Art/Producer review.

No Current Memory update is made in this task because the user constrained writes to two files and no product/production decision is accepted. PM should link/promote these documents only after cross-role review.

---

## 15. Changelog

### 2026-07-12 — R48-05A-S source-only wave authorized

- Added the bounded world + layered Labrador + station-anchor source package before runtime integration.
- Preserved preview/source/runtime maturity separation and Art ownership.

### 2026-07-11 — proposed v1 created

- Added staged P0/P1/P2 visual production plan.
- Recommended exterior ground/fence/bicycle-yard as the first player-visible proof.
- Separated strip-scale and room-window-scale QA.
- Added Day 2 parallelism boundary, cost risks and stop conditions.
- Kept production style, mechanics and asset approval open.
