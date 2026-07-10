# Cross-role RFC — Codex task boundaries for Steam Vertical Slice

Дата: 2026-06-29
Статус: accepted / docs update in progress
Chair: Producer
Scribe: Project Manager / Knowledge Base Maintainer
Участники: Game Designer, Art Director, Codex, Producer, PM

## 1. Повод

Game Designer запросил согласование с Art Director и Codex: какие задачи Codex может выполнять самостоятельно в Steam Vertical Slice, а какие должны возвращаться Game Designer, Art Director или Producer, чтобы роли не мешали друг другу и не ломали D-014.

Главная проблема: Codex при реализации может столкнуться с неописанными деталями. Нужно заранее определить, где допустим implementation judgement, а где начинается product/game/art decision.

## 2. Контекст и обязательные источники

Перед заполнением своей секции каждая роль должна прочитать:

- `PROJECTS_RULES.md`
- `AGENTS.md`
- `README.md`
- `docs/repo/status/CODEX_STATUS.md`
- `docs/drive/Shelter/00_START_HERE/04_COLLABORATION_PROTOCOL.md`
- `docs/drive/Shelter/00_START_HERE/02_DECISIONS.md`, особенно D-014
- релевантный role-document:
  - `000_ROLE_GAME_DESIGNER.md`
  - `000_ROLE_ART_DIRECTOR.md`
  - `000_ROLE_CODEX.md`
  - `000_ROLE_PRODUCER.md`
  - `000_ROLE_PROJECT_MANAGER.md`

Steam Vertical Slice sources:

- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Game_Design_Roadmap_v1.md`
- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Vertical_Slice_Scope_Lock_v1.md`
- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Vertical_Slice_Contract_v1.md`
- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Object_Contract_v1.md`
- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Task_Flow_Contract_v1.md`
- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Codex_Implementation_Brief__Vertical_Slice_v1.md`

## 3. Вопросы на согласование

1. Какие задачи Codex может делать самостоятельно в рамках Steam Vertical Slice?
2. Какие изменения Codex может делать как prototype / smoke-test shortcut?
3. Какие shortcuts запрещены, даже если они ускоряют реализацию?
4. Какие вопросы Codex должен возвращать Game Designer?
5. Какие вопросы Codex должен возвращать Art Director?
6. Какие вопросы Codex должен возвращать Producer?
7. Какие visual placeholders Codex может создавать без Art Director?
8. Где проходит граница между gameplay object contract, semantic placeholder и production asset?
9. Как фиксировать найденные Codex ambiguity / blocker / stop condition?
10. Что нужно обновить после финального решения: `AGENTS.md`, role-docs, Codex implementation brief, product contracts или status?

## 4. Current assumptions

- Steam/Desktop Vertical Slice уже имеет locked scope.
- Codex реализует контракты, а не придумывает новые механики.
- Game Designer отвечает за mechanics, task flow, resources, progression, UX-logic и visible cause-and-effect как gameplay requirement.
- Art Director отвечает за visual direction, art bible, prompts, asset style, readability и production asset rules.
- Codex отвечает за implementation, technical feasibility, checks, local repo changes and dev status.
- Producer отвечает за product scope, priorities, role boundaries and final decisions.
- Project Manager отвечает за documents, handoff, decision log and conflict tracking.
- Semantic placeholders допустимы для прототипа, если они не маскируют нарушение gameplay contract.
- Production art quality не является acceptance requirement первого playable Vertical Slice, если это не противоречит уже принятым visual/readability gates.

## 5. Draft boundary table

Эта таблица — стартовая гипотеза для role review, не финальное решение.

| Ситуация | Codex can decide | Ask Game Designer | Ask Art Director | Ask Producer |
|---|---:|---:|---:|---:|
| Реализовать уже описанный task flow | yes | no | no | no |
| Исправить баг в реализации контракта | yes | no | no | no |
| Сжать timing для smoke test / debug mode | yes, if documented | maybe | no | no |
| Сжать timing в player-facing loop | no | yes | maybe | maybe |
| Убрать видимую выгрузку ресурса | no | yes | maybe | maybe |
| Заменить physical object на UI number | no | yes | maybe | maybe |
| Использовать semantic placeholder shape/label | yes | no | maybe if readability matters | no |
| Выбрать финальный вид собаки | no | no | yes | no |
| Выбрать palette / art style | no | no | yes | no |
| Написать production asset prompt | no | no | yes | no |
| Создать debug-only placeholder asset | yes | no | no, unless it leaks into visual decision | no |
| Добавить новый ресурс | no | yes | maybe | maybe |
| Добавить новый object type | no | yes | maybe | maybe |
| Изменить object taxonomy | no | yes | yes | maybe |
| Добавить новую механику | no | yes | maybe | yes if scope changes |
| Удалить step из locked chain | no | yes | maybe | yes if scope changes |
| Изменить Vertical Slice scope | no | yes | maybe | yes |
| Выбрать technical implementation detail | yes | no | no | no, unless scope/risk |
| Добавить dev-only diagnostic UI | yes | no | no | no |
| Изменить player-facing UI flow | no | yes | maybe | maybe |
| Изменить UI look/style | no | no | yes | maybe |
| Изменить acceptance criteria | no | yes | maybe | yes |

## 6. Game Designer position

Статус: filled by Game Designer on 2026-06-29.

Game Designer position is limited to mechanics, resources, production chains, task flow, UX-logic, player intent, visible cause-and-effect and gameplay acceptance. Visual style, final asset quality, palette, prompts and art pipeline remain Art Director responsibility.

### 6.1 Codex can do

Codex can independently do the following inside the locked Steam Vertical Slice scope:

- implement the already described Vertical Slice task flow;
- choose internal code structure for prototype implementation;
- create or adjust simple data structures for routes, dogs, resources, tasks, objects and order state if keys remain aligned with contracts;
- create deterministic prototype timing values for debug / smoke testing;
- compress timing in debug or smoke modes if documented;
- implement simple task queue / scheduler rules from the Task Flow Contract;
- use simple movement, tweening, labels, state markers or placeholder poses to make required actions visible;
- add dev-only debug overlay / logs for task state, events, resource state and blocked reasons;
- fix bugs where implementation fails to match written contracts;
- preserve and reuse existing companion strip functionality if it does not change gameplay scope;
- use approved semantic placeholders or debug-only placeholders when an asset is missing, provided the placeholder does not hide a gameplay shortcut;
- document assumptions, blockers and missing assets in dev/status docs.

Codex does not need Game Designer approval for purely technical implementation details that do not change player-facing behavior, scope, visible steps, resource rules, task ownership, UI flow meaning or dog/system responsibilities.

### 6.2 Codex must not do without Game Designer

Codex must return to Game Designer before doing any of the following:

- adding a new route, resource, task type, object type, dog, order or reward;
- removing any step from the locked chain;
- changing player actions required by Vertical Slice;
- turning a physical resource into a UI-only number;
- changing when Storage, Kitchen, Packing Table or Delivery Van Endpoint update state;
- changing the task ownership model;
- changing dog assignment rules in a way that changes gameplay meaning;
- adding player confirmation for microtasks;
- changing Delivery from player-confirmed to auto-send in the first playable slice;
- changing the meaning of D-010 separation between innate trait and equipment;
- changing player-facing UI flow or next-action logic;
- changing acceptance criteria or playtest checklist meaning;
- using a failed playtest result as justification to add scope instead of fixing the existing loop.

### 6.3 Game-design stop conditions

Codex must stop and return a question to Game Designer if:

- implementation would require resource teleportation;
- a resource-changing event cannot be tied to a visible task completion;
- task flow deadlocks and the fix would change task ownership or player agency;
- the system needs a missing gameplay rule not covered by contracts;
- a shortcut would make the world feel like spreadsheet-first UI rather than physical dog work;
- a dog would need to abandon a carried item for another task in normal flow;
- player must manually approve unload / carry / cook / pack / load microtasks for the loop to continue;
- the first slice cannot run with only one route, one transport, two dogs, one order and one reward;
- fixing a problem appears to require First Day MVP systems;
- any text, UI state or mechanic risks urgency, guilt pressure, monetization pressure or charity overclaim.

### 6.4 Acceptable prototype shortcuts

The following shortcuts are acceptable for prototype / smoke-test use if documented:

- compressed trip / cook / pack timings;
- simplified straight-line movement instead of final pathfinding;
- simple deterministic scheduler instead of full AI;
- debug labels for objects, tasks, resources or dog states;
- one generic carry pose used for several resource types;
- simple visible tokens for Food Mix / Food Bag / crates;
- placeholder dogs without final dog art, if the dog role and action remain readable;
- debug-only event log;
- temporary placeholder resource art if missing assets are documented;
- simplified UI cards if the player still understands intent, next action and state;
- background or crop imperfections in temporary semantic assets if they do not obscure gameplay meaning.

These shortcuts must not remove visible cause-and-effect.

### 6.5 Forbidden shortcuts

The following shortcuts are forbidden even if they speed up implementation:

- TripTask directly adds Oat / Pumpkin to Storage;
- returned payload is invisible;
- Storage updates before visible unload / placement completes;
- Kitchen starts before inputs are physically delivered;
- Kitchen creates Food Bag directly;
- Packing Table is skipped;
- Food Mix is skipped without explicit Game Designer decision;
- Food Bag is invisible;
- Delivery Van Endpoint becomes ready before Food Bag is visibly loaded;
- Delivery completes without player confirmation;
- Postcard appears before delivery completion;
- Comfortable Slippers are added as a generic stat without Dog Card separation;
- innate trait and equipment are shown as one undifferentiated list;
- IdleTask blocks required production tasks;
- player must approve every microtask;
- a missing asset is used as justification to collapse an object, step or task;
- visual placeholder turns a Utility Prop into a new gameplay Building responsibility;
- any implementation adds ads, monetization, Browser Extension UX, visible crop farming, combat, gacha, paid reroll, FOMO or guilt pressure.

### 6.6 Questions for Art Director

Game Designer asks Art Director to clarify:

1. For first playable Vertical Slice, what minimum visual readability standard should apply to debug / semantic placeholders before production art exists?
2. If a required gameplay object has no approved asset yet, what level of neutral placeholder is acceptable for Codex without creating a visual decision?
3. Can Codex use labeled geometric placeholders for missing resources and dog action sprites during the first gameplay prototype, if the labels are clearly dev-only?
4. Which assets are currently approved for Codex prototype use after binary import, and which are still only visual direction?
5. If the cropped composite assets have imperfect transparency/background, is that acceptable for first playable prototype or should Codex use simpler generated/debug placeholders?
6. What visual issue should be a hard stop for Art Director review: unreadable dog action, wrong taxonomy, Utility Prop becoming a house, or style mismatch?
7. Does Art Director want Codex to create Steam-local copies of approved semantic placeholders, or should implementation reference the docs/drive asset library until a production asset pipeline is chosen?

### 6.7 Questions for Codex

Game Designer asks Codex to clarify:

1. Can the first Vertical Slice be implemented as a separate prototype scene without damaging the existing companion field demo?
2. What is the smallest data model Codex needs to implement the locked chain cleanly?
3. Can Codex preserve all visible steps with simple movement and placeholder tokens, or is any step technically risky?
4. Is there any implementation blocker around Hide / Show UI while world state continues?
5. Can Codex log the required event chain so Game Designer can compare implementation against Playtest Checklist?
6. Is the approved semantic asset import blocker resolved before implementation, or will Codex need debug placeholders first?
7. Which checks will Codex run after implementation, and will there be a dedicated vertical-slice smoke launcher?

## 7. Art Director position

Статус: filled by Art Director on 2026-06-29.

Art Director position is limited to visual direction, readability, asset taxonomy, placeholder boundaries, visual QA and production-art responsibility. This position does not change the locked Vertical Slice mechanics, task flow, economy, player actions or product scope.

### 7.1 Codex can do with placeholders

Codex can independently use and create placeholders only inside the following boundaries.

Codex can use existing approved semantic placeholders from:

```text
docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Semantic_Asset_Pack_v1/approved/
```

Currently approved for Codex prototype use:

- `approved/utility_props/road_sign.png` — Road Sign / Notice Board, Utility Prop;
- `approved/utility_props/basket_bicycle.png` — Basket Bicycle, Utility Prop / Transport;
- `approved/buildings/storage.png` — Storage, Building;
- `approved/buildings/kitchen.png` — Kitchen, Building;
- `approved/utility_props/delivery_van_endpoint.png` — Delivery Van Endpoint, Utility Prop / Endpoint;
- `approved/resources/food_mix_and_food_bag_composite.png` — temporary combined Food Mix / Food Bag resource bridge.

Codex can create debug-only / semantic placeholders for missing Vertical Slice assets if all conditions are met:

- placeholder maps to an object/resource/action already present in the Vertical Slice contracts;
- placeholder has a clear dev-only purpose and is documented in status/dev notes;
- placeholder does not add a new object, resource, dog, building, route, UI flow or mechanic;
- placeholder keeps the required taxonomy: Building / Utility Prop / Dog Action Sprite / Resource / UI;
- placeholder does not make a Utility Prop look like a Building;
- placeholder makes the physical step more readable rather than hiding it;
- placeholder is visually neutral enough that no one can mistake it for approved production art.

Codex can use these neutral placeholder forms without Art Director approval:

- labeled simple geometric tokens for missing resources: Oat Crate, Pumpkin Crate, Protein Packet, Packaging Bag, separate Food Mix, separate Food Bag;
- labeled flat cards / panels for missing UI-only dev objects: Postcard frame, Comfortable Slippers icon, if clearly dev-only;
- simple colored rectangles/circles/silhouettes for missing dog action sprites, if the dog/action label is visible in dev mode;
- simple line / block / icon placeholders for path, payload, socket, carry target and task state;
- rough cropped temporary PNGs from the approved semantic pack, even with imperfect transparency, if they do not obscure gameplay meaning.

For prototype readability, Codex may add dev-only text labels directly on placeholders. These labels are not final UI look and must not be treated as visual style.

### 7.2 Codex must not decide visually

Codex must not independently decide or create:

- final art style;
- palette;
- lighting model;
- material language;
- production asset prompts;
- final dog look;
- final dog breed/mixed-breed visual system;
- final UI look;
- final icon language;
- final postcard look;
- final Comfortable Slippers design;
- final resource shapes if they imply long-term asset language;
- final building silhouettes beyond approved direction;
- new visual taxonomy;
- new asset categories;
- new decorative world elements outside the Vertical Slice contract.

Codex must not visually reinterpret:

- Packing Table as a house, shed, room, shop or decorative cottage;
- Delivery Van Endpoint as a full garage/building unless Art Director approves it;
- Road Sign as a large map building;
- Basket Bicycle as a shop, upgrade station or garage;
- resources as UI-only numbers;
- dog actions as invisible state changes;
- Storage/Kitchen as large interior cutaway scenes in the main strip.

Codex must not use:

- random screenshots from chat;
- rejected art;
- Yog-Sothoth's Yard screenshots as implementation assets;
- Browser Extension assets;
- asset-pack images marked `APPROVED_AS_DIRECTION` as production-ready Codex assets unless separately marked for prototype use;
- any asset whose taxonomy is unclear.

### 7.3 Visual / readability stop conditions

Codex must stop and return to Art Director if any of these happen:

- dog action is not readable at strip scale;
- carried object is not readable;
- resource payload is not visible during a required physical step;
- Food Mix and Food Bag cannot be distinguished when the gameplay step requires distinction;
- a Utility Prop visually becomes a Building;
- Packing Table becomes a room/workshop/house instead of a work surface;
- Delivery Van Endpoint becomes a garage/large building instead of an endpoint;
- buildings dominate dogs and actions;
- dogs become tiny decorative dots;
- main strip turns into dense village/cutaway/interior scene;
- placeholder hides a missing physical action;
- placeholder changes gameplay meaning;
- UI cards or labels visually dominate the lower strip;
- visual feedback uses urgency, guilt, red-alert language, sad starving-dog imagery or charity pressure;
- imported/cropped asset background or alpha artifact makes gameplay object unreadable;
- any object can only be understood through long text label rather than silhouette + simple label;
- object taxonomy is ambiguous;
- Codex needs to choose between two visual interpretations that imply different future art direction.

Readability baseline for the first playable Vertical Slice:

- **216 px:** object type, dog/action, carried resource and task state should be readable enough for manual playtest.
- **144 px:** dog/action, object category and carried item must remain readable.
- **96 px:** stress test; at minimum dog + movement + large carried object / resource token must read. Small decor may disappear.

A semantic placeholder passes for Codex prototype use if a tester can answer within roughly one second:

1. what object/resource this is;
2. what dog action is happening;
3. which physical step just completed or is in progress.

### 7.4 Placeholder rules for first playable Vertical Slice

For the first playable Vertical Slice, production art quality is not required, but semantic readability is required.

Rules:

1. Every visible placeholder must have an explicit semantic name and taxonomy in code/data/docs.
2. Buildings are rare anchors. In Vertical Slice only Storage and Kitchen may be Buildings.
3. Road Sign, Basket Bicycle, Packing Table and Delivery Van Endpoint are Utility Props.
4. Utility Props must not have visual house logic: no full roof-door-window cottage language, no inhabitable facade, no room/interior framing.
5. Resources should be physical world tokens, not inventory numbers.
6. Missing resources may be labeled geometric tokens until Art Direction creates proper semantic placeholders.
7. Missing dog action sprites may be labeled dog silhouettes or the current Dog Runtime placeholder, if the required action remains visible.
8. Imperfect transparency/background in cropped composite assets is acceptable for the first playable prototype if the object remains readable and does not visually pollute the strip enough to hide gameplay steps.
9. If cropped composite artifacts make an object harder to read than a simple labeled geometric token, Codex should use the simpler labeled token and document the reason.
10. Temporary labels are allowed in debug/prototype mode; they must not become final UI look.
11. Color may be used functionally for debug distinction, but Codex must not establish the final palette.
12. Placeholder scale may be adjusted for readability, but must not imply new object importance or gameplay scope.
13. If Food Mix and Food Bag remain a combined cropped composite, Codex may use it only as a temporary bridge. When the chain needs to show separate Food Mix -> Food Bag transformation, Codex should create separate labeled semantic tokens until separate assets exist.
14. Steam-local copies of approved semantic placeholders are allowed for implementation if Godot import/runtime needs stable `res://` paths. If copied, Codex must preserve source attribution/path in a README or manifest and must not rename them in a way that loses taxonomy.
15. Until a production asset pipeline is chosen, `docs/drive/.../Semantic_Asset_Pack_v1/approved/` remains the source registry; Steam-local copies are implementation mirrors, not new approvals.

Current status of assets:

- **Approved for Codex prototype use:** the 6 imported semantic placeholders listed in section 7.1.
- **Direction only / not direct Codex production use:** `STEAM_OVERLAY__Approved_Library_v1` assets unless a specific file is separately copied/marked for prototype use.
- **Missing and Codex may use labeled semantic placeholders:** Packing Table, separate Oat Crate, separate Pumpkin Crate, Protein Packet, Packaging Bag, separate Food Mix, separate Food Bag, Comfortable Slippers icon, First Postcard frame, Dachshund/Labrador action sprites.

### 7.5 Questions for Game Designer

Art Director asks Game Designer:

1. For the first Vertical Slice playtest, which resources absolutely must be visually distinct from each other: Oat Crate vs Pumpkin Crate, Protein Packet vs Packaging Bag, Food Mix vs Food Bag?
2. Is the combined Food Mix + Food Bag temporary composite acceptable for the first implementation if Codex also uses separate debug labels/tokens to preserve the transformation step?
3. Which dog actions are gameplay-critical for first review: bicycle departure/return, unload crate, carry crate, kitchen help, packing, Food Bag carry, slippers reward?
4. Can the first dog action placeholders use generic `dog carrying X` silhouette labels, or must Dachshund and Labrador be visually distinct already in the first playable prototype?
5. For Dog Card, what is the minimum player-facing distinction between innate trait and equipment: text-only separation, icon slots, or visible dog accessory state?
6. Which placeholder readability failure should block gameplay implementation versus merely create an Art Director follow-up task?

### 7.6 Questions for Codex

Art Director asks Codex:

1. Does Godot implementation need Steam-local copies of approved semantic placeholders for stable `res://` paths, or can it reference/import from `docs/drive` paths safely?
2. If Steam-local copies are needed, where should the implementation mirror live, and can Codex generate a manifest mapping source asset -> Steam-local path?
3. Can Codex attach taxonomy metadata to placeholder definitions in data/code so visual QA can audit Building / Utility Prop / Resource / Dog Action Sprite usage?
4. Can Codex provide a debug toggle that shows semantic labels and hides them, so we can test both gameplay clarity and visual clutter?
5. Can Codex keep the missing-resource placeholders as data-driven simple tokens instead of generating new visual files for every missing asset?
6. Will imperfect transparent PNG edges from the imported composite create Godot import artifacts in the companion strip, or are they acceptable for the first prototype?
7. Can Codex log or screenshot the 96 / 144 / 216 readability states for Vertical Slice objects after implementation, or should Art Director handle that manually?

## 8. Codex position

Статус: filled by Codex on 2026-06-29.

Codex position is limited to implementation, local repo changes, checks, dev docs/status and technical constraints. This position does not change the locked Steam Vertical Slice mechanics, task flow, art direction, asset taxonomy, product scope or acceptance criteria.

### 8.1 Implementation needs

To implement the locked Steam Vertical Slice cleanly, Codex needs:

- an isolated Vertical Slice prototype scene / launcher, or a clearly isolated layer inside the existing companion strip, so the current companion field demo remains usable;
- stable Godot `res://` paths for approved semantic placeholders, preferably via a Steam-local implementation mirror with a manifest mapping source asset -> local path;
- a small data-driven model with contract-aligned ids for route, transport, dogs, objects, resources, order, equipment and tasks;
- taxonomy metadata for every visible placeholder: Building, Utility Prop, Dog Action Sprite, Resource or UI;
- a deterministic task queue / state machine that preserves the Task Flow Contract statuses and emits the required debug events;
- world anchor positions and handoff points for Road Sign, Storage, Kitchen, Packing Table and Delivery Van Endpoint;
- simple dog runtime states for Dachshund and Labrador: idle, moving, carrying, unloading, helping production, loading and reward/equip moment;
- visible resource tokens for every required resource before it mutates object state;
- a compact UI layer for Order Card, Route Card, Dog Card, Postcard Card and Hide / Show;
- a dev-only debug overlay or log for task status, resource state, event chain, blocked reasons and semantic labels;
- a dedicated smoke command for the Vertical Slice, plus existing companion/Godot checks.

Codex can implement these as prototype data, dictionaries, Godot nodes, GDScript state machines or Resources. The technical form is Codex-owned if it does not change player-facing behavior, visible steps, object responsibilities, scope or taxonomy.

### 8.2 Ambiguities blocking implementation

Current ambiguities / conflicts to resolve before or during implementation:

- `STEAM_DESKTOP__Codex_Implementation_Brief__Vertical_Slice_v1.md` lists `approved/utility_props/packing_table.png` as available, but the current Semantic Asset Pack README, import manifest, Codex status and Art Director position say Packing Table is still missing. Codex will treat Packing Table as missing and use a labeled Utility Prop placeholder unless the brief is updated.
- Food Mix and Food Bag currently share one approved composite resource image, but the required chain must show Food Mix -> Food Bag as a visible transformation. Codex needs to use separate labeled resource tokens for these steps until separate approved assets exist.
- Oat Crate, Pumpkin Crate, Protein Packet, Packaging Bag, Comfortable Slippers icon, Postcard frame and dog action sprites are missing approved files. Codex can use labeled semantic placeholders, but the missing list should stay explicit.
- Exact first-playable timings are not final. Codex can choose compressed prototype timings for smoke/manual review, but not timings that skip readable actions.
- The exact player-facing copy for the first Order / Postcard may need final Producer or Game Designer review if implementation requires more than neutral placeholder text.
- If Godot import behavior makes docs/drive asset paths unreliable, Codex will need Steam-local copies and a source mapping manifest.
- If the existing companion field demo structure makes isolation unsafe, Codex needs a dev decision on whether to create a new prototype scene/script family under `steam/scenes/prototypes/vertical_slice/` and `steam/scripts/prototypes/vertical_slice/`.

### 8.3 Technical constraints

Technical constraints Codex will follow:

- preserve existing Steam/Desktop companion strip behavior unless the implementation task explicitly authorizes a change: bottom placement, transparency, always-on-top, Hide / Show, zoom / pan and existing smoke checks;
- do not couple Steam Vertical Slice to Browser Extension, ads, sponsorship block, Chrome new-tab UX, accounts, Steamworks, real shelter data or monetization systems;
- keep the first implementation small and prototype-oriented; avoid broad architecture, production economy systems, full AI, full pathfinding, research/progression systems or asset-pipeline decisions;
- resource state changes must be event-backed and occur only after visible task completion;
- tasks may be data/state-machine entries rather than a final production task framework, but their design meaning must remain intact;
- debug shortcuts may compress time and simplify movement, but must not remove physical steps, resource tokens, dog work or player delivery confirmation;
- labels and debug colors may be used for readability, but must remain dev/prototype aids and not final UI or palette decisions;
- if approved PNGs are copied into `steam/`, source paths and taxonomy must be preserved in a README or manifest;
- checks after implementation should include existing Godot/companion checks and a new Vertical Slice smoke path if a new launcher is added.

### 8.4 Safe implementation assumptions

Codex can safely assume the following unless Producer / Game Designer / Art Director changes the contracts:

- first implementation should prioritize a complete observable loop over production polish;
- Vertical Slice can be implemented as a separate prototype scene or isolated layer without changing product scope;
- a simple deterministic scheduler is acceptable for the first loop;
- straight-line movement, tweening, simple sockets and placeholder poses are acceptable if actions remain readable;
- Dachshund is the route driver; Labrador is preferred for unload/carry/support tasks when available;
- Protein Packet and Packaging Bag may start in Storage;
- Oat Crate and Pumpkin Crate must arrive through the trip payload and must not appear in Storage early;
- semantic placeholders may be data-driven simple tokens instead of generated files for every missing resource;
- temporary semantic labels may be shown by default in debug/prototype mode and hidden by a debug toggle if implemented;
- Steam-local copies of approved semantic assets are implementation mirrors, not new visual approvals;
- Comfortable Slippers may have no numeric effect in the Vertical Slice as long as Dog Card clearly separates innate trait and equipment.

### 8.5 Stop conditions Codex will return to roles

Codex will stop and return questions instead of silently deciding if:

- implementation requires adding a new route, dog, transport, object, resource, reward, player action, task type or gameplay system;
- a required visible step cannot be preserved without changing task flow, object responsibility or player agency;
- a resource would need to teleport between objects or mutate state without a visible dog/object action;
- Delivery cannot remain player-confirmed after visible Food Bag loading;
- Hide / Show UI or companion strip constraints force a change to player-facing UX meaning;
- a placeholder would make a Utility Prop read as a Building, make dogs/actions unreadable, hide a physical step or imply final art direction;
- Food Mix and Food Bag cannot be distinguished enough for the required transformation step;
- UI labels/cards dominate the strip enough that dogs and physical work stop being the focus;
- a missing asset, missing rule or technical convenience would collapse Storage, Kitchen, Packing Table or Delivery Van Endpoint responsibilities;
- wording, UI state or feedback risks urgency, guilt pressure, charity overclaim, monetization pressure or Browser Extension language;
- an existing contract/source conflict affects implementation behavior rather than documentation wording.

Return targets:

- Game Designer: mechanics, task ownership, resource flow, player actions, visible cause-and-effect, Dog Card gameplay meaning and acceptance checklist meaning;
- Art Director: asset taxonomy, readability, placeholder acceptability, dog/action silhouette, UI visual dominance and production asset boundaries;
- Producer: scope changes, priority tradeoffs, product boundary questions, accepted/rejected shortcuts and cross-product implications;
- Project Manager: document conflict tracking, decision-log updates and post-RFC documentation synchronization.

### 8.6 Docs / contracts Codex needs updated before implementation

Before implementation starts, Codex recommends updating or confirming:

- `STEAM_DESKTOP__Codex_Implementation_Brief__Vertical_Slice_v1.md`: align the Semantic Assets section with the current approved asset list and mark Packing Table as missing unless a real approved file is added;
- Semantic Asset Pack README / manifest / cards: keep the missing asset list explicit and, if Steam-local copies are created, add source -> implementation path mapping;
- Vertical Slice implementation brief or dev note: define the expected Vertical Slice smoke command name and whether the scene should live under `steam/scenes/prototypes/vertical_slice/`;
- `docs/repo/status/CODEX_STATUS.md`: update when implementation starts or after the first implementation pass, including assumptions, missing assets, checks and blockers;
- after Producer synthesis, role/process docs only if this RFC becomes an accepted long-lived boundary decision.

Codex does not need new game-design approval to start implementation if the above asset-list conflict is resolved by using labeled placeholders and documenting them. Codex does need role review if any implementation path would change the locked loop, taxonomy, visual direction, player-facing UI meaning or Vertical Slice scope.

## 9. Producer synthesis

Статус: accepted by Producer on 2026-06-29.

Producer reviewed the filled Game Designer, Art Director and Codex positions. The three role positions are compatible and can be accepted as a Steam Vertical Slice implementation-boundary decision.

Главный вывод:

> Codex может самостоятельно реализовывать уже принятые контракты, выбирать техническую форму, делать debug-only / semantic placeholders и фиксировать dev assumptions. Codex не может менять locked gameplay loop, visible cause-and-effect, resource flow, object taxonomy, player-facing UI meaning, visual direction, production asset style или Vertical Slice scope.

### 9.1 Accepted boundaries

Accepted:

1. **Codex owns implementation form.** Codex may choose internal Godot structure, data structures, scene/script split, deterministic scheduler, debug overlay/logs, smoke commands and Steam-local asset mirror if these do not change contracts.

2. **Codex may create prototype/debug placeholders.** Codex may use approved semantic placeholders and may create neutral labeled placeholders for missing Vertical Slice assets: Packing Table, Oat Crate, Pumpkin Crate, Protein Packet, Packaging Bag, separate Food Mix, separate Food Bag, Comfortable Slippers icon, Postcard frame and dog action placeholders.

3. **Steam-local mirrors are allowed.** If Godot needs stable `res://` paths, Codex may copy approved semantic placeholders into `steam/assets/prototypes/vertical_slice/semantic/` or an equivalent prototype folder, but must preserve source path and taxonomy in a README or manifest. Steam-local copies are implementation mirrors, not new art approvals.

4. **Debug labels are allowed.** Codex may use labels, state markers, debug colors and overlay logs for prototype readability. These are dev aids, not final UI look, palette or style.

5. **Compressed timings are allowed only for prototype/smoke/debug.** Codex may compress trip/cook/pack/carry timing for smoke tests and manual prototype review, but must not remove visible physical steps.

6. **Separate semantic tokens are required when gameplay needs distinction.** Because Food Mix and Food Bag currently share one composite image, Codex should use separate labeled semantic tokens when the chain needs to show Food Mix -> Food Bag transformation.

7. **Packing Table is missing.** The implementation brief must be corrected: `approved/utility_props/packing_table.png` is not currently available. Codex may use a labeled Utility Prop placeholder for Packing Table until an approved asset exists.

8. **Visible cause-and-effect is non-negotiable.** Storage, Kitchen, Packing Table and Delivery Van Endpoint state changes must happen only after visible task completion. Resources must physically exist in the world before object state updates.

9. **Vertical Slice should stay isolated.** Codex should implement the slice as a separate prototype scene/script layer or a clearly isolated layer inside the existing companion strip. Existing companion demo behavior should be preserved unless a specific dev decision says otherwise.

10. **Codex stop conditions are accepted.** Codex must stop and return questions if implementation requires new mechanics/scope, removing visible steps, resource teleportation, taxonomy changes, visual direction choices, player-facing UI meaning changes or charity/monetization/product boundary changes.

11. **Role return targets are accepted.** Codex returns mechanics/task/resource/player-action questions to Game Designer; placeholder/readability/taxonomy/style questions to Art Director; scope/priority/product boundary questions to Producer; doc conflicts and synchronization to Project Manager.

### 9.2 Rejected / deferred

Rejected:

- Codex may not collapse physical resource flow into UI counters.
- Codex may not skip Packing Table, Food Mix, Food Bag, unload/load steps or player delivery confirmation.
- Codex may not treat missing assets as permission to remove objects or steps.
- Codex may not choose final dog art, final UI look, palette, prompts or production asset style.
- Codex may not import random screenshots, rejected art, Browser Extension assets or unapproved visual direction assets as production/prototype assets.
- Codex may not add route/dog/resource/order/reward/systems beyond the locked Vertical Slice.

Deferred:

- Final art pipeline and production asset workflow remain Art Director / future pipeline work.
- Final dog visual system remains Art Director work.
- Full task architecture / production AI remains future technical design after the first playable loop proves value.
- 96 / 144 / 216 px formal readability report for the implemented Vertical Slice can happen after the first playable implementation.
- Whether to extract reusable production dog runtime is deferred until the Vertical Slice implementation and visual review expose a concrete need.

### 9.3 Final scope impact

This RFC does **not** change Steam Vertical Slice scope.

No new route, dog, object, resource, order, reward, mechanic, product feature, monetization, charity claim, Browser Extension dependency or visual direction is added.

This RFC only clarifies implementation boundaries:

- what Codex may decide independently;
- what requires Game Designer / Art Director / Producer review;
- how to handle missing semantic assets;
- how to preserve visible physical steps during prototype implementation.

### 9.4 Required docs update

Required now:

1. Update `STEAM_DESKTOP__Codex_Implementation_Brief__Vertical_Slice_v1.md`:
   - remove `approved/utility_props/packing_table.png` from current approved assets;
   - state that Packing Table is missing and should use a labeled Utility Prop placeholder;
   - add accepted boundary rules from this RFC;
   - add requirement for source -> Steam-local path manifest if assets are copied into `steam/`.

2. Update `02_DECISIONS.md` with D-016 or D-015 update for the accepted Codex Vertical Slice implementation boundaries.

3. Update `01_CURRENT_STATUS.md` to say first RFC was accepted and next step is implementation brief sync / Codex implementation.

4. Update / create handoff for this Producer synthesis.

Optional later:

- Update `AGENTS.md` only if these Steam-specific Codex boundaries need to become repo-wide rules. For now, existing D-014 / `AGENTS.md` already covers the general rule.
- Update role-documents only if future sessions repeatedly miss the boundary. Current role-documents already contain the general separation.

## 10. Final decision / update

Статус: accepted by Producer on 2026-06-29.

Accepted as a Steam Vertical Slice implementation-boundary decision.

Codex is authorized to start from this RFC after the implementation brief is synced, using the accepted boundaries in section 9.

The accepted operational rule:

> Codex implements contracts and may use technical judgement for prototype implementation, debug tooling and neutral placeholders. Codex must not silently change gameplay contracts, visible physical steps, object taxonomy, visual direction, player-facing UI meaning, product scope or ethical boundaries.

This decision does not add product scope. It clarifies how to implement the already locked Vertical Slice without Game Designer, Art Director and Codex interfering with one another.

## 11. Docs to update after decision

Кандидаты на обновление:

- `AGENTS.md`
- `docs/drive/Shelter/00_START_HERE/000_ROLE_CODEX.md`
- `docs/drive/Shelter/00_START_HERE/000_ROLE_GAME_DESIGNER.md`
- `docs/drive/Shelter/00_START_HERE/000_ROLE_ART_DIRECTOR.md`
- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Codex_Implementation_Brief__Vertical_Slice_v1.md`
- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Vertical_Slice_Scope_Lock_v1.md`, если найдены scope-level уточнения
- `docs/repo/status/CODEX_STATUS.md`, если Codex начинает dev-серию после принятого решения
- `docs/drive/Shelter/00_START_HERE/02_DECISIONS.md`, если решение становится долгоживущим process / implementation boundary decision

## 12. Short prompts for role sessions

### 12.1 Game Designer

```text
Ты — Game Designer / Systems Designer проекта Shelter.

Открой напрямую из локального checkout:
docs/drive/Shelter/06_SESSIONS_AND_HANDOFFS/cross_role_sessions/2026-06-29__cross_role_rfc__codex_task_boundaries_steam_vertical_slice.md

Прочитай sources из раздела 2 и заполни только секцию `Game Designer position`.
Не меняй секции Art Director, Codex, Producer или PM.
Фокус: mechanics, resources, production chains, task flow, visible cause-and-effect, UX-logic, forbidden shortcuts.
```

### 12.2 Art Director

```text
Ты — Art Director / Visual Designer проекта Shelter.

Открой напрямую из локального checkout:
docs/drive/Shelter/06_SESSIONS_AND_HANDOFFS/cross_role_sessions/2026-06-29__cross_role_rfc__codex_task_boundaries_steam_vertical_slice.md

Прочитай sources из раздела 2 и заполни только секцию `Art Director position`.
Не меняй секции Game Designer, Codex, Producer или PM.
Фокус: visual placeholders, readability, asset style boundaries, что Codex не должен решать визуально.
```

### 12.3 Codex

```text
Ты — Codex проекта Shelter.

Открой через filesystem:
docs/drive/Shelter/06_SESSIONS_AND_HANDOFFS/cross_role_sessions/2026-06-29__cross_role_rfc__codex_task_boundaries_steam_vertical_slice.md

Прочитай sources из раздела 2 и заполни только секцию `Codex position`.
Не меняй секции Game Designer, Art Director, Producer или PM.
Фокус: implementation needs, technical constraints, ambiguities, safe assumptions, stop conditions.
```

### 12.4 Producer

```text
Ты — Producer проекта Shelter.

Открой напрямую из локального checkout:
docs/drive/Shelter/06_SESSIONS_AND_HANDOFFS/cross_role_sessions/2026-06-29__cross_role_rfc__codex_task_boundaries_steam_vertical_slice.md

После заполнения секций Game Designer, Art Director и Codex прочитай их позиции, заполни `Producer synthesis` и реши, какие документы обновлять.
Не добавляй новых продуктовых решений сверх темы RFC.
```

## 13. Changelog

### 2026-06-29 — accepted by Producer

- Game Designer, Art Director and Codex positions were reviewed.
- Producer synthesis accepted the role-compatible boundaries.
- RFC status changed to accepted / docs update in progress.
- Final decision clarifies Codex implementation authority and stop conditions for Steam Vertical Slice.

### 2026-06-29 — draft created

- Создан первый Cross-role RFC для согласования границ задач Codex по Steam Vertical Slice.
- Добавлена draft boundary table как стартовая гипотеза, не финальное решение.
- Добавлены секции для Game Designer, Art Director, Codex и Producer synthesis.
