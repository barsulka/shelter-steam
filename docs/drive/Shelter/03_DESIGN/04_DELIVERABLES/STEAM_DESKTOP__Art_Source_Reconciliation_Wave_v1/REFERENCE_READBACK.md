# Reference Readback

Все ссылки прочитаны локально. Ни один reference-файл вне package не менялся и не копировался в editable master.

## Activation and contracts

| Источник | SHA-256 | Роль |
|---|---|---|
| `../STEAM_DESKTOP__Art_Source_Reconciliation_Wave_v1__PM_Activation.md` | `33a3c4e136b576d661f53388db0413a3b98af0f00bc9b3db3f3c5cb4b3fcfe29` | PM source-only activation; not runtime executable |
| `../STEAM_DESKTOP__Art_Reconciliation__Dog_Buildings_Meadow_v1/REFERENCE_MANIFEST.json` | `f07afd8e6617acd5b38ce488c678d7cb245a9b8a9915effd20484a2e75ebe66d` | hash-locked canonical/reference/exclusion authority |
| `../../../04_DEVELOPMENT/STEAM_DESKTOP__Labrador_P0_Accepted_Action_Manifest_v1.md` | `d8f1a9fc9226588097eb7bdfc162b6eff520ef42605b369ba25f906daa52ae56` | accepted A–H presentation/action scope; H signed GD+PM+Technical |
| `../STEAM_DESKTOP__Playable_World_Labrador_Source_Package_v1/README.md` | `b984b112610d95e6c1780de9e5bc1d642d6e3d2aa0af66c9aee6424cf23980be` | prior numeric/contact regression source, visual anti-target |
| `../STEAM_DESKTOP__Playable_World_Labrador_Source_Package_v1/ART_QA.md` | `432d5b3da334ef5fffdec135100cd1accab9babe3812be6e0a13563f0a21e143` | prior source QA/regression only |
| `../STEAM_R48_05A_LABRADOR_RUNTIME_CAPTURE_v5/OWNER_REVIEW.md` | `75b753e5fbb41d39b71da5ab495591e68a2809065a266ce5cda09e4d7c9c11d2` | split historical verdict; bounded technical PASS, overall visual reject |
| `../STEAM_R48_05A_LABRADOR_RUNTIME_CAPTURE_v5/captures/first_day/A.png` | `5a19f0e92590b896d5197824297237ecf8d98f2237471e039943c8829fc6eba9` | current runtime visual anti-target/comparison only |

## User-owner Labrador

- Path: `../STEAM_DESKTOP__Art_Reconciliation__Dog_Buildings_Meadow_v1/references/user_owner/STEAM_DESKTOP__Labrador_Identity_Three_View__User_Owner_Reference.png`
- SHA-256: `5cfffc7a32717346183b035feb00b4d429f7197381513758c831c4e69a3db1c6`
- Format: 1773×887 RGB.

Explicit user-owner identity reference. Creator/tool/license metadata: unknown; user supplied and explicitly authorized its identity role.

## Complete approved_art_files inventory

| Файл | SHA-256 | Package role |
|---|---|---|
| `D-011_steam_overlay_main_strip_v1_reference.png` | `bde69388b337f1b7b158f35958a3a740953d58816bffd4d51fff5920d54ae508` | canonical full-scene/meadow/lower-strip grammar; direct target |
| `STEAM_OVERLAY__approved_library_v1_readability_216_144_96.png` | `e83fd4fdc6c1da1cddf3c9b73b1a8b60e55632a4945ef1c2615bb4186ac475f1` | approved readability library reference |
| `STEAM_OVERLAY__decor_workshop_v2_utility_workbench__approved_direction.png` | `ca48cd0c46be6e5b983981c14eca558a39d2ab65249009eb1b39e26f13b3cf66` | Utility Prop quality/language; Packing source guidance |
| `STEAM_OVERLAY__dog_action_dachshund_cart_grain_bag__approved_direction.png` | `4c6940ddcd83f442dfb169844a47143544d9a8dda1da53195aca505b3340a4d7` | quality/scale/living-language only; literal dog/cart excluded |
| `STEAM_OVERLAY__dog_action_husky_painting_board__approved_direction.png` | `0cb3c5de0db96ae067205ae3e35090dc91a149382ba301f4976477ce7d4a775f` | quality/living-language only; entity/action excluded |
| `STEAM_OVERLAY__dog_action_labrador_watering_can__approved_direction.png` | `b7f116605d27bf551fb0b4319c579671b9a0f696fa0d097fe221cf1b439e04d7` | direct Labrador material/action character target |
| `STEAM_OVERLAY__kitchen_v2_1_building__approved_with_minor_simplification.png` | `7b6703d65a2ab0f5af99769bbe5b025f6ffb85a83fb38e04f04d153e18b7b98a` | direct Kitchen facade target; detail advisory remains for user/PM |
| `STEAM_OVERLAY__mill_v2_utility_prop__approved_direction.png` | `70b193ddaf403ee8bb885278bb2ea8cfaecdc818486dfd3c33753436042cf1f5` | direct static Mill target; no mechanic |
| `STEAM_OVERLAY__storage_v2_building__approved_direction.png` | `fb0bc903f15203923e5251a271ebf6dbaf2f9b2ccdb4a850cc48d6fcac1e741a` | direct Storage target |
| `STEAM_OVERLAY__water_station_v2_utility_prop__approved_direction.png` | `3f19cdef4e7720d04d16d54c6a0f0d4a8fab766c4588b1b4a9801ff3286b67fe` | library language only; entity not added |
| `image.png` | `f63159790080725ecbf2537b72432f1ca0ea782366935c63cfc8112351a891cc` | approved Mill/Dachshund living-scene evidence; Mill language direct, Dachshund literal roster excluded |

Approved library files beyond current gameplay scope establish visual quality/language only. Они не дают authority на новые entities, mechanics, transfer, rooms или future catalogue.

## Hard exclusions

- Sheet A, включая отвергнутый hash `c0dd9f6…`: **USER_REJECTED_REFERENCE / ZERO REUSE**. Он не использовался даже как principles/supporting evidence.
- PREVIEW_RESEARCH_ONLY, direction-only материалы вне approved library, rejected SVG, stale captures и AI flattened references не promoted в accepted master authority.
- Current v5 geometry/world: technical regression only, not a canonical visual target.
