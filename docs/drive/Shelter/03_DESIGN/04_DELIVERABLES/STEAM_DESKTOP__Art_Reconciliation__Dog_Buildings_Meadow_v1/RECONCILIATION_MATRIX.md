# Reconciliation Matrix — Current v5 vs Canonical Targets

- Дата: `2026-07-13`
- Status: `PREPARED_FOR_PM_ACCEPTANCE`
- Overall current result: **CHANGES_REQUIRED / USER_OWNER_REJECTED_CURRENT_LOOK**
- Bounded v5 behavior regression: **PASS**, отдельно от visual result

## 1. Evidence keys

### Canonical targets

| Key | Exact path | SHA-256 | Role |
| --- | --- | --- | --- |
| `T-D011` | `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/approved_art_files/D-011_steam_overlay_main_strip_v1_reference.png` | `bde69388b337f1b7b158f35958a3a740953d58816bffd4d51fff5920d54ae508` | full-scene target |
| `T-LAB-ACTION` | `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/approved_art_files/STEAM_OVERLAY__dog_action_labrador_watering_can__approved_direction.png` | `b7f116605d27bf551fb0b4319c579671b9a0f696fa0d097fe221cf1b439e04d7` | Labrador material/action direction |
| `T-LAB-ID` | `references/user_owner/STEAM_DESKTOP__Labrador_Identity_Three_View__User_Owner_Reference.png` | `5cfffc7a32717346183b035feb00b4d429f7197381513758c831c4e69a3db1c6` | explicit user-owner three-view identity |
| `T-KITCHEN` | `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/approved_art_files/STEAM_OVERLAY__kitchen_v2_1_building__approved_with_minor_simplification.png` | `7b6703d65a2ab0f5af99769bbe5b025f6ffb85a83fb38e04f04d153e18b7b98a` | canonical Kitchen language |
| `T-STORAGE` | `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/approved_art_files/STEAM_OVERLAY__storage_v2_building__approved_direction.png` | `fb0bc903f15203923e5251a271ebf6dbaf2f9b2ccdb4a850cc48d6fcac1e741a` | canonical Storage language |
| `T-MILL` | `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/approved_art_files/STEAM_OVERLAY__mill_v2_utility_prop__approved_direction.png` | `70b193ddaf403ee8bb885278bb2ea8cfaecdc818486dfd3c33753436042cf1f5` | canonical Mill Utility Prop |
| `T-MILL-SCENE` | `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/approved_art_files/image.png` | `f63159790080725ecbf2537b72432f1ca0ea782366935c63cfc8112351a891cc` | approved Mill + Dachshund scene evidence |
| `T-DACHSHUND` | `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/approved_art_files/STEAM_OVERLAY__dog_action_dachshund_cart_grain_bag__approved_direction.png` | `4c6940ddcd83f442dfb169844a47143544d9a8dda1da53195aca505b3340a4d7` | canonical quality/scale/living-scene reference; not current roster |
| `T-READABILITY` | `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/approved_art_files/STEAM_OVERLAY__approved_library_v1_readability_216_144_96.png` | `e83fd4fdc6c1da1cddf3c9b73b1a8b60e55632a4945ef1c2615bb4186ac475f1` | canonical comparative scale/readability evidence |

Полный approved-library inventory находится в `REFERENCE_MANIFEST.json`; его
остальные entries также каноничны, даже когда не входят в literal current
roster.

### Current v5 evidence and sources

| Key | Exact path | SHA-256 | Boundary |
| --- | --- | --- | --- |
| `C-A` | `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_R48_05A_LABRADOR_RUNTIME_CAPTURE_v5/captures/first_day/A.png` | `5a19f0e92590b896d5197824297237ecf8d98f2237471e039943c8829fc6eba9` | actual 2992x224 full-layout baseline |
| `C-E` | `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_R48_05A_LABRADOR_RUNTIME_CAPTURE_v5/captures/first_day/E.png` | `e38b48e2804cc3937adda0115526dbb3bde3cc796f2e580801a2af5ff123af7f` | Kitchen contact/work |
| `C-F` | `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_R48_05A_LABRADOR_RUNTIME_CAPTURE_v5/captures/first_day/F.png` | `d734bce45fea24323402c37cc2be3485d3751039b37ba4980f4e758bad7911f0` | Packing contact/mask |
| `C-G` | `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_R48_05A_LABRADOR_RUNTIME_CAPTURE_v5/captures/day2/G.png` | `6ed1ef4358a5e1491698314e8b85bbc229873c178604e5d9e5a6cc36b6c86ce0` | focus state |
| `C-QUIET` | `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_R48_05A_LABRADOR_RUNTIME_CAPTURE_v5/captures/quiet/A_quiet_cooperative.png` | `bff86f88e8d3d9515e182b689512ae9d297635a82f51e67eee3e910a82dcad8f` | quiet cooperative full layout |
| `C-DESKTOP` | `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_R48_05A_LABRADOR_RUNTIME_CAPTURE_v5/captures/desktop_composited/macos_desktop_window.png` | `adab18e9d12f0735e6f1369de1594609dfa905886bbd58bcf751038fa7be2cad` | actual desktop composite/window |
| `S-DOG-R` | `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Playable_World_Labrador_Source_Package_v1/source/labrador/right/labrador_master_right.svg` | `fc1888a4fcc38f06e54d6680d248e7f89787fdbd86676a27407a8b4204884a5f` | current noncanonical geometric source |
| `S-DOG-L` | `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Playable_World_Labrador_Source_Package_v1/source/labrador/left/labrador_master_left.svg` | `19eb44e512026a41b2a4eb5ab7b18c64fc72cf0abebd833279bd95a51f7a6f06` | current noncanonical geometric source |
| `S-DOG-TURN` | `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Playable_World_Labrador_Source_Package_v1/source/labrador/turn_mid/labrador_master_turn_mid.svg` | `fbef07ef5a3410d58445181eb8c2cbef6f453cdbf40e510faeb7efa56201be8a` | current physical-turn source pattern |
| `S-WORLD` | `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Playable_World_Labrador_Source_Package_v1/source/world/world_master.svg` | `a25385b8ea70ae47879811d01588879ddfda6ffd62392eb58f576a26d610e154` | current noncanonical world visual source |

## 2. Corrected reconciliation matrix

| Delta | Canonical reference | Current v5 evidence | Exact visual delta | Severity | Owner | Source correction needed? | Integration-only? | Contract/status conflict? | Acceptance evidence |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Labrador overall identity | `T-LAB-ID` + `T-LAB-ACTION` | `C-A`, `S-DOG-R/L/TURN` | v5 is flat/geometric with hard assembled parts; target is natural soft Labrador anatomy/fur, calmer mass and stable three-view identity | P0 | Art | yes: new layered editable identity source | no | current SOURCE-READY maturity is technical, not canonical identity | side-by-side both targets vs source/runtime for both facing + turn + A–G |
| Head/muzzle/ears | `T-LAB-ID` + `T-LAB-ACTION` | `C-A`, `C-E` | current long white muzzle/graphic head/ears read as a simplified mascot; target has moderate rounded muzzle, broad gentle head and natural floppy ears | P0 | Art | yes | no | none after this brief; current visual target is explicitly rejected | clean and silhouette read at actual `2992x224` plus `216/144/96` |
| Legs/paws/tail/coat | `T-LAB-ID` + `T-LAB-ACTION` | `C-A`, `C-F`, `C-G` | current thin geometric legs, flat tail and solid color blocks miss sturdy paws, living tail edge, soft cream/gold coat and chest integration | P0 | Art | yes | no | must preserve existing contact sockets without preserving rejected morphology | both-side contact plus natural anatomy, no source-layer collapse |
| Labrador scale and world hierarchy | `T-D011` + `T-READABILITY` + `T-LAB-ID` | `C-A`, `C-DESKTOP` | metrics pass, but actor/world mutual scale and visual mass do not reproduce the canonical living-scene hierarchy | P0 | Art + Codex | source envelope and scale target yes | runtime placement/scale yes, after source acceptance | no PlayerBoot decision in this brief | actual 2992x224 comparison with D-011 and pixel readback at 216/144/96 |
| Calm Labrador back-and-forth read | D-011 dog-first living-strip grammar + `T-LAB-ID` | `C-A`, `C-QUIET`; v5 A–G/turn/motion regression | first living dog remains Labrador, but current acceptance does not yet pin a calm visible back-and-forth route rhythm as user-facing baseline | P0 | Game Design for selector/guardrails; Art for look/rhythm/readability; Codex later | source walk/turn poses may need reconciliation | yes for route binding after GD contract | Art must not invent selector/state authority | accepted bounded GD selector/guardrails, then normal-speed full-strip motion with calm cadence, deliberate physical turns and no negative scale |
| Meadow/clearing | `T-D011` | `C-A`, `C-DESKTOP`, `S-WORLD` | current long banded platform has broad dead spans and rectangular materials; target is a connected organic meadow with grass/dirt variation and compact living density | P0 | Art | yes: full-corridor layered source | no | D-011 is now canonical full-scene target, not spacing abstraction | full-width side-by-side, alpha/bounds/baseline evidence, 216/144/96 |
| Faint trees and depth | `T-D011` | `C-A`, `C-DESKTOP` | current back span is mostly fence/black reserve with no coherent faint lower tree layer; target includes subtle trees/shrubs behind the living strip | P0 | Art | yes | placement/z integration also required | faint lower trees must not become opaque fullscreen background | alpha-over-desktop proof that depth stays inside lower strip |
| Contact islands and shadows | `T-D011`, full library | `C-A`, `C-E`, `C-F` | v5 assets sit on disconnected white/flat shadow marks and banded ground; approved library uses soft grounded islands shared with nearby props/actions | P1 | Art | yes | z/placement later | current numeric contact planes remain useful, visual form does not | muzzle/paw contact + ground/shadow ownership + no floating/cut feet |
| Fence and z ownership | `T-D011` + D-011 rules | `C-A`, `C-F`, `S-WORLD` | current fence spans dominate long empty areas and required a local Packing mask; target fence supports depth and never cuts primary dog anatomy | P1 | Art + Codex | source segmentation/ownership yes | selector-local integration later | v5 mask PASS must remain green, not be visually promoted | front/back fence layers, Packing contact clean, forbidden overlap classes `0` |
| Full-corridor coverage | `T-D011` | `C-A`, `C-DESKTOP`, `S-WORLD` | current authored visual mass is uneven and leaves a disconnected right tail; target reads as one intentional lower composition across the usable width | P0 | Art + Codex | yes | yes | no PlayerBoot/platform mutation | actual 2992x224 frame, no unauthored tail/seam, baseline continuous |
| Building rhythm and spacing | `T-D011` + full library | `C-A`, `C-QUIET` | current sparse semantic objects and one large rectangle do not form D-011 module/pause/dog-action rhythm | P0 | Art + Codex | building/prop sources yes | placement/density yes | gameplay order remains fixed unless separately decided | side-by-side D-011, readable hierarchy in ordinary play |
| Mill literal current presence | `T-MILL` + `T-MILL-SCENE` | `C-A`: Mill absent | user-owner now authorizes approved Mill as a literal **static decorative Utility Prop**; it must not become a station, task owner or mechanic | P0 | Art source, Codex later | yes: faithful production-form source if editable source is absent | yes: static placement only | no input/resource/output/progression/contact/interaction authority | visible thin mill pause in full layout, approved silhouette/scale, no interaction/selectors/collision claim |
| Storage | `T-STORAGE` + `T-D011` | `C-A`; semantic PNG SHA `cad82d119594f0a52c7230d70fa047be7eed16dd74c486bd5920299db219d5bd` | current shelf-like semantic block is not the approved low wooden Storage building form and is weakly grounded | P0 | Art + Codex | yes: faithful editable production source | placement later | no new Storage mechanic | approved silhouette/icon/density, current gameplay order preserved |
| Kitchen | `T-KITCHEN` + `T-D011` | `C-A`, `C-E`; semantic PNG SHA `cf55a38d2c7ea77fb22949574ec3b8a71e65652e549216897cea2bd8226f93a8` | current green rectangular cabinet/stove placeholder lacks canonical low building shape, warm hierarchy and shared meadow contact | P0 | Art + Codex | yes: faithful editable production source | contact binding later | A–E technical contract stays bounded | side-by-side `T-KITCHEN`, both-side contact `<=4 px`, action remains readable |
| Packing | D-011 building/utility taxonomy + full-library quality | `C-A`, `C-F` | large code-drawn rectangle has no accepted production-form source and is the strongest remaining prototype-shape | P0 | Art + Codex | yes: bounded editable Packing production form | contact/mask binding later | no transfer, output, station replacement or mechanic expansion | function readable in 1 sec; both sides; forbidden overlap `0`; no torso cut |
| Van endpoint | `T-D011` | `C-A`, `C-DESKTOP`; semantic PNG SHA `f527869695b499721fac7b547d3323838d6dd9567085eae92c12e2717bd76b0e` | current isolated cutout-style van sits on a white patch and is disconnected from common meadow scale/ground | P1 | Art + Codex | production-form source needed if current placeholder has no accepted editable source | placement/scale later | endpoint only; no driving/loading/transfer authority | grounded on common baseline/contact island; remains right endpoint; zero transfer |
| Road sign and bicycle | D-011 spacing/material grammar | `C-A`; Road SHA `0814d5e607941a6a102c09862f0aa8a5d0219ead33a7f2d97a59ce34eb52aa65`; Bicycle SHA `7c1818978b1c7a69416baae68ed77aa14aa540299dfcdd44001882c62df86682` | current props are visually disconnected; bicycle remains a static scene prop only | P1 | PM pins retention; Art/Codex if retained | yes if retained and no accepted production source exists | yes | dog riding bicycle is explicitly later/out of scope | retained props match meadow grounding; no choreography/vehicle mechanic |
| Transparent upper reserve | `T-D011` + D-011 rules | `C-DESKTOP` | transparency contract is directionally correct and must be preserved while lower composition is rebuilt | P0 preserve | Art + Codex | background source must keep alpha | integration proof yes | faint trees belong to lower strip only | desktop alpha/checker capture; upper 70–80% remains desktop-owned |
| V5 behavior regression | v5 owner review SHA `75b753e5fbb41d39b71da5ab495591e68a2809065a266ce5cda09e4d7c9c11d2` | `C-E`, `C-F`, `C-G` and immutable v5 pack | bounded A–G/turn/contact/mask/recovery/zero-transfer behavior is reusable; its visual forms are not targets | P0 preserve | Game Design + Codex + Art review | source must expose compatible pivots/sockets | yes | behavior PASS cannot grant overall Art PASS | all v5 regression cells green after visual replacement |

## 3. Current vs later scope lock

### Current / in scope for visual reconciliation

1. **Approved Mill is literal current scene content only as a static decorative
   Utility Prop.** It has no interaction, station role, task, resource, output,
   progression, input, selector, contact or mechanic. Source and runtime work
   remain gated by the staged accepted Art/Codex waves.
2. **Labrador remains the first and only living dog.** The required calm read is
   a Labrador walking back and forth along the living strip at an unhurried,
   even rhythm, with natural scale, clear silhouette and physical turns. Art
   owns appearance/rhythm/readability, not selector/state authority. Before an
   executable brief, Game Design must provide bounded selector/guardrails.
3. **Current gameplay entity order remains unchanged.** Static Mill is a visual
   pause layered into the scene, not a gameplay node in that order.
4. Existing A–G, Kitchen/Packing contacts, turns, recovery, negatives and zero
   transfer are the only behavior regression base.

### Canonical reference, but not current literal roster

`T-DACHSHUND` and the Dachshund shown in `T-MILL-SCENE` remain canonical
evidence of quality, breed specificity, scale, cart readability and a living
scene. They do **not** authorize a current Dachshund, cart, transfer,
choreography or mechanic.

### Later / explicitly out of current scope

- dog pulls or rides with cart;
- dog rides bicycle;
- dog drives small truck;
- dog sits in bed of large truck;
- dog sits at school desk;
- dog reads in library;
- dog mixes chemicals in lab;
- dog teaches at blackboard with pointer;
- dog relaxes in rocking chair with book;
- dog sleeps;
- dog plays with another dog;
- dog chases its tail;
- any other expanded dog-life catalogue states.

The governing boundary is: **first restore base graphics and already established
mechanics; expand later**. No current mechanics, tasks, resources, rooms,
vehicles, transfer or extra dogs are created by this package.

## 4. Smallest reconciliation plan

### Source correction required

- natural layered Labrador identity and source poses compatible with the
  accepted current action boundary;
- D-011-faithful full-corridor meadow, faint-tree depth, ground/contact islands,
  fence segmentation and shadows;
- faithful production-form sources for current visible semantic/code-drawn
  placeholders where accepted editable sources do not exist;
- static approved Mill production form;
- numeric pivots/baselines/contact/z ownership and `216/144/96` source QA.

### Integration-only after source acceptance

- composition, scale, placement, density, full-width coverage and z-order;
- static non-interactive Mill placement;
- binding of the accepted current A–G/contact/mask/recovery regressions;
- calm Labrador back-and-forth presentation only after Game Design supplies
  selector/guardrails and a separate Codex brief is accepted.

### Not solvable by integration-only

- rejected geometric Labrador identity;
- missing D-011-faithful meadow/background source;
- code-drawn Packing rectangle and semantic building placeholders where no
  faithful production-form editable source exists.

## 5. Acceptance boundary

No matrix row is closed by numerical validators alone. Final closure requires
immutable actual-runtime side-by-side evidence, independent Art review and
explicit user-owner visual acceptance. Until then overall status remains
**CHANGES_REQUIRED / USER_OWNER_REJECTED_CURRENT_LOOK**.
