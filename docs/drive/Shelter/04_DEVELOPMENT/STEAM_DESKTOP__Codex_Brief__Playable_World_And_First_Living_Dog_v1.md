# STEAM_DESKTOP — Codex Brief — Playable World And First Living Labrador v1

Дата: 2026-07-12
Статус: **implemented / mechanical PASS / overall WARN / runtime Art owner review pending**
Владелец исполнения: Codex, один write integrator
Владельцы входных контрактов: Producer / Game Designer / Art Director / Technical Animation / PM
Roadmap: `STEAM_DESKTOP__First_48_Hours_Playable_Roadmap_v1.md`, R48-05A / P0-B + P0-D
Рекомендуемый уровень рассуждений: **очень высокий**

---

## 0. Цель

Заменить ключевые прямоугольные placeholder-слои обычного First Day + Day 2 player journey на цельную authored/imported world foundation и впервые показать Labrador как живого current runtime character в том же runtime.

Результат должен быть виден через обычный F5 / `steam/play.sh`, а не только в отдельной demo scene.

## 1. Обязательные источники перед стартом

Прочитать полностью применимые части:

- `PROJECTS_RULES.md`, `AGENTS.md`, `steam/AGENTS.md`, `steam/README.md`;
- `docs/repo/adr/README.md`, ADR-0001, ADR-0002 и ADR-0003;
- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__First_48_Hours_Playable_Scope_Lock_v1.md` и active roadmap;
- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/GAME_DESIGN__CURRENT_CONTEXT.md`, `docs/drive/Shelter/03_DESIGN/ART_DIRECTION__CURRENT_CONTEXT.md`, `docs/drive/Shelter/04_DEVELOPMENT/CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md`;
- `docs/drive/Shelter/03_DESIGN/00_VISUAL_DIRECTION/DOG_VISUAL_LANGUAGE_v1.md`, `DOG_RUNTIME_AND_ANIMATION_GRAMMAR_v1.md`, `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/DOG_DNA_SCHEMA_v0.md` с сохранением их draft/proof статуса;
- `docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Dog_Animation_Clip_And_Binding_Contract_v1.md`;
- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Task_Flow_Contract_v1.md`, `STEAM_DESKTOP__Object_Contract_v1.md`, `STEAM_DESKTOP__Vertical_Slice_Contract_v1.md`, `STEAM_DESKTOP__Vertical_Slice_Scope_Lock_v1.md`;
- `docs/drive/Shelter/03_DESIGN/00_VISUAL_DIRECTION/STEAM_DESKTOP__World_And_Room_Asset_Vocabulary_v1.md` и `STEAM_DESKTOP__Visual_Production_Roadmap_v1.md` только как proposed planning sources;
- `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Playable_World_Labrador_Source_Package_v1/README.md`, `ART_QA.md`, provenance/manifests/hashes и exact source/export subset;
- `docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__R48_05A_Technical_Activation_Record_v1.md` как exact coordinate/property/z/file/test/no-touch record;
- skill `shelter-dog-animation-pipeline` и его обязательный source map; после выбора профиля — все обязательные references этого профиля.

## 2. Activation gate — всё обязательно до первой записи ассетов или runtime-кода

- [x] Game Designer сделал readback и подписал `STEAM_DESKTOP__Labrador_P0_Accepted_Action_Manifest_v1.md`.
- [x] Art Director принял source-level layered side-view Labrador package, provenance, pivots, baseline, z-order, authored facings/asymmetry и compatible envelope; runtime Art PASS не заявлен.
- [x] Art Director принял source-level bounded world set: только используемые ground/path/fence/yard layers, не flattened Sheet A.
- [x] Для Kitchen и Packing Table определены source-level approach/contact/work/exit anchors; Packing Table visual source остаётся отдельным честным warning до Technical/PM решения.
- [x] R48-05A explicitly excludes object transfer; P0-C moved to separate later R48-05B.
- [x] Technical/Codex зафиксировал exact runtime selectors, marker ordering, cancellation/recovery и одну animation authority на property; exact-file readback SIGNED.
- [x] PM зафиксировал output/evidence paths, retention, signer states и одного будущего Codex write owner в Technical Activation Record.
- [x] PM явно перевёл brief в `accepted / executable` после Game Design, Art и Technical signer handbacks.

Если любой пункт отсутствует, вернуть соответствующий `STOP_*` из Dog Animation Clip And Binding Contract; не генерировать placeholder «на глаз» и не начинать runtime mutation.

## 3. Scope

### 3.1 World foundation

- authored modular ground base;
- только реально используемые grass/dirt/sand/path transitions;
- fence rear/front occlusion bands;
- parked Bicycle yard как неинтерактивная композиционная связь;
- стабильные import bounds, pivots, alpha, hashes и provenance;
- тихая плотность композиции и сохранение desktop coexistence.

### 3.2 Labrador life kernel

- idle/wait: breathing, blink, bounded calm tail;
- start → walk → stop;
- physical turn отдельно от mirror/facing;
- approach → contact-align / paw adjust;
- station-work на существующем accepted task;
- bounded careful/focus layer в accepted Day 2 PackTask phase;
- no pickup/attach/carry/place/detach in R48-05A.
- authored coverage ограничена selectors A–G;
- existing Labrador `UnloadTask` / `CarryTask` / `LoadVanTask` остаются explicit `legacy_unbound`: current primitive lane, authored adapter suppressed, no fake idle/generic carry/dual dog; это regression-only и не 05A acceptance.

### 3.3 Runtime integration

- current Godot runtime остаётся единственным gameplay authority;
- visual adapter наблюдает existing dog/task/object state и не создаёт вторую gameplay/simulation authority;
- presentation sequencing/cache полностью derived, non-persisted и сбрасывается на restore/task change;
- ordinary player path использует authored world и authored Labrador только для exact A–G; transfer phases остаются честным `legacy_unbound` до R48-05B;
- coordinate mapping, uniform trial scale `0.25`, station-local transforms, property ownership, trace-only markers, cancellation/recovery и exact draw order берутся только из `STEAM_DESKTOP__R48_05A_Technical_Activation_Record_v1.md`;
- current parent `_draw` сохраняет dog slot; arbitrary child-node z refactor запрещён;
- trace пишется только в ignored `steam/.runtime/labrador_r48_05a/visual_trace.jsonl` и никогда не становится gameplay/profile state;
- dev/capture observability сохраняется, но player presentation не показывает debug geometry/labels.

### 3.4 Packing Table temporary boundary

- current code-drawn Packing Table остаётся temporary semantic placeholder/reference only;
- accepted anchor plane используется только как numeric contact/clearance authority и не рисуется как player art;
- 05A не заявляет authored/final Packing Table replacement или runtime station Art PASS;
- Technical contact evidence обязательно; native runtime Art review после integration может вернуть WARN/CHANGES_REQUIRED;
- Art owner принял эту границу как `ACCEPT_PLACEHOLDER_BOUNDARY`; отдельная pre-activation Art micro-wave не нужна.

## 4. Out of scope

- Dachshund как второй обязательный living character;
- полный 67-ID vocabulary, новые dog roles/mechanics/rewards;
- Bicycle ride/tow/hitch/propulsion choreography;
- новые задачи, ресурсы, станции, комнаты или Day 3;
- production pipeline/style lock по умолчанию;
- broad terrain atlas или generic asset-pipeline refactor;
- save/schema, MCP/security, background/minimize/performance work;
- Kitchen detail surface — отдельный следующий brief.
- object transfer — separate R48-05B/P0-C brief after one named prop contract.

## 5. Definition of Done — bounded R48-05A only

- [x] F5 и `steam/play.sh` показывают authored world foundation в First Day и Day 2.
- [x] Labrador представлен living runtime character, а не code rectangle/debug silhouette, во всех exact A–G states.
- [ ] Idle/wait/start/walk/stop/physical-turn/contact-align/Kitchen work/Packing work/focus читаются по authoritative selectors A–G.
- [x] Existing Unload/Carry/LoadVan states дают ровно один `legacy_unbound` primitive lane без authored transfer claim, fake idle или duplicate dog.
- [x] Facing/mirror/asymmetry и contact не ломаются в обе стороны.
- [x] Native 216/144/96 evidence сделано из одной master/source hierarchy в обычном player layout.
- [ ] Art Director отдельно дал visual WARN/PASS; validator не self-approve aesthetics.
- [x] First Day, Day 2, 33-cursor restart, save-failure и Quiet Cooperative regressions зелёные.
- [x] Player mode не показывает debug UI/geometry/state labels.
- [x] Ни один preview/draft asset не назван production-approved без отдельного gate.
- [x] `steam/README.md`, `CODEX_CURRENT_STATUS.md`, `CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md` и `CODEX_STATUS.md` обновлены по фактическому результату.

R48-05A PASS оставляет parent R48-A/R48-05 в статусе `PARTIAL / WARN`. Full parent PASS запрещён до отдельного R48-05B object-transfer PASS.

## 6. Exact зоны изменений после activation

- 14 world layer PNG under `steam/assets/prototypes/vertical_slice/authored/world/layers/`;
- 48 Labrador layer PNG under `steam/assets/prototypes/vertical_slice/authored/dogs/labrador_intro/{right,left,turn_mid}/layers/`;
- `steam/scripts/prototypes/vertical_slice/labrador_visual_adapter.gd`;
- `steam/scenes/prototypes/vertical_slice/labrador_visual_adapter.tscn`;
- exact binding/station/animation resources, visual tests, validator and capture helper listed in `STEAM_DESKTOP__R48_05A_Technical_Activation_Record_v1.md`;
- modifications only to `vertical_slice_demo.gd`, `vertical_slice_demo.tscn`, optional bounded capture entry in `dev-vertical-slice.sh`, `steam/README.md` and required status/result docs.

Source SVG/evidence/AI reference/station guides are not runtime assets. The Technical Activation Record is the authoritative exact file list; a new file outside it requires STOP and scope reconciliation.

Explicit no-touch без нового brief/ADR review:

- `steam/scripts/player/player_boot.gd`;
- `steam/scripts/player/player_checkpoint_codec.gd`;
- `steam/scripts/persistence/**`;
- `steam/scripts/game_systems/**`;
- player profile schema, 33-cursor semantics, fixtures and MCP/control schema.
- `project.godot` main scene, `steam/play.sh`, `steam/dev.sh`, production profiles and current source package masters/evidence.

## 7. Проверки

- manifest и runtime-binding validators из `shelter-dog-animation-pipeline`;
- source package verifier plus explicit build-snapshot/current-authority provenance readback;
- Godot import/check/smoke;
- ordinary PlayerBoot/F5/`play.sh` smoke;
- First Day + Day 2 causal regression;
- full 33-cursor checkpoint sweep, restart/SIGKILL/save-failure rollback/retry;
- exact A–G positive mapping, negative G, `legacy_unbound`, no-transfer and one-runtime assertions;
- both physical-turn directions; Kitchen/Packing approach/contact/work from both sides;
- deterministic binding/contact/cancellation/recovery capture;
- native player-layout 216/144/96 clean + silhouette stills and normal-speed motion;
- z/occlusion evidence without station guides, debug geometry or player labels;
- persistent capture pack: `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_R48_05A_LABRADOR_RUNTIME_CAPTURE_v1/`;
- финальный `git diff --check` и `git status --short`.

## 8. Stop conditions

Помимо project-wide stop conditions остановиться при missing/contradictory gameplay authority, selector outside A–G receiving authored binding, missing/changed source or binding hash, unsupported scale/world/station transform, unreadable current 0.324-second phase, root pop, child-node z seam, missing approved layered art, unaccepted prop/socket/station anchor, second simulation, unsafe mirror, unsupported Labrador envelope, hidden preview promotion, object-transfer expansion или необходимости менять accepted `3 + 2` input/runtime causality.

## 9. Codex implementation result and v5 correction — 2026-07-13

Раздельный вердикт:

- exact bounded v5 Packing occlusion / Technical correction: **PASS**;
- overall player-facing visual coherence: **CHANGES_REQUIRED / USER_OWNER_REJECTED_CURRENT_LOOK**;
- v5 local runtime Art mask review: **PENDING_OWNER_REVIEW**;
- Codex runtime Art PASS: **not granted**;
- stop code: none for the completed local v5 correction.

Factual Technical readback:

- source authority SHA-256: `afedb0185cff0c56963e566ff846a479437bf37950d8b38bc84380781015b3b8`;
- runtime binding SHA-256: `1837ae14a80ccf6b0a5ac9f8fffeac36d88e649bd3ccf3777e19c84b7bd3e68f`;
- station binding SHA-256: `8e221cb3e84f304f26f7ed6fd0c4ad531627823c5aef6b0f757e81ec67e12504`;
- persistent v5 evidence: `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_R48_05A_LABRADOR_RUNTIME_CAPTURE_v5/`;
- v5 ledger SHA-256: `0f83134e4f27aa5599a27a3789dfdfad0136aec23c70e6a7f3c6dcb11fc6e3b8`; capture manifest SHA-256: `9041c812a82cf233658532b29b865bd4c9cfd49a5098adaa7ca69cfdc5422447`;
- actual PlayerBoot `2992x224`, bottom delta `0`, full-width corridor x=`0..1740`, authored x=`0..1536` plus declared non-authored tail; PlayerBoot/window contract unchanged;
- uniform positive scale `0.24`; Kitchen offsets `104.16/62.88/54.24`, Packing `104.16/60.00/50.88`; root/baseline/pivots and animation timing/library unchanged;
- minimum complete bboxes at `216/144/96`: general `80/54/36`, Kitchen E `74/49/33`, Packing F `79/53/35`, focus G `73/49/32`; all state-specific height and margin gates pass;
- both-side contact passes: Kitchen muzzle gap `3.714207 px`, Packing `2.063448 px`, with muzzle and working paw inside the accepted plane;
- fail-closed derived Packing mask is active only for D/F/G/contact-held EXIT: `8/8` positive and `6/6` negative cells pass; actual allowed paw-tip overlap `0 px`, forbidden overlap `0` screen pixels / `0` source-alpha samples; source/global-z/gameplay/persistence ownership unchanged;
- four 1x strips keep six even visible intervals with maximum interval ratio `0.166667`; both turn directions stay root-locked without negative scale;
- exact A–G/negative G, one runtime/Labrador, cancellation/recovery, three `legacy_unbound` transfer tasks, all six negative lanes and `transfer_acceptance_cells=0` are preserved;
- source package `40 PASS / 1` declared Packing placeholder warning, project/skill/runtime validators, Godot import/check/smoke, profile-store restart/SIGKILL, checkpoint-17, Continue/Day2-33 forced-kill/save-retry and isolated ordinary `play.sh` are green;
- v1/v2/v3/v4 ledgers remain immutable; production profile absent, temporary profiles removed;
- R48-05B object transfer was not implemented.

Direct user/owner verdict rejects the overall visible result: current dogs do
not match the expected locked art, building placement is not accepted, and the
clearing does not match the accepted view. Therefore local v5 Technical PASS
does not claim that R48-05A solved the overall user-visible prototype problem.
The next step is a separate read-only Art comparison current v5 versus earlier
accepted dog/building/meadow references, followed by a new Art-owned brief
sequence. No v6, source mutation or composition rewrite is authorized by this
result.
