# Steam Vertical Slice Prototype

Дата: 2026-06-30
Статус: first playable prototype pass + Art QA fix pass v1 + game systems runtime foundation scaffold

## Goal

This prototype implements the locked Steam/Desktop Vertical Slice loop as an isolated Godot scene, without replacing the existing companion field tech demo.

Scene:

```sh
steam/scenes/prototypes/vertical_slice/vertical_slice_demo.tscn
```

Human-facing launch with local connector/control server:

```sh
cd steam
./launch.sh
```

Dev helper launch:

```sh
cd steam
tools/dev-vertical-slice.sh
```

Smoke launch:

```sh
cd steam
tools/dev-vertical-slice.sh smoke
```

Dev-only state connector:

```sh
cd steam
tools/dev-vertical-slice.sh connector
tools/dev-vertical-slice.sh connector-smoke
STATE_CONNECTOR_TOKEN="$(uuidgen)" tools/dev-vertical-slice.sh connector-control
tools/dev-vertical-slice.sh connector-control-smoke
tools/dev-vertical-slice.sh runtime-foundation-smoke
```

The connector exposes read-only live state from this running Godot scene through
`/health`, `/schema`, `/state`, plus a conservative fallback JSON snapshot file.
It is documented in `docs/repo/dev/godot-state-connector.md` and does not create
a standalone simulator.

`connector-control` is explicit dev-only control mode. It keeps the existing
state endpoints and adds `/control?token=...` plus whitelisted Hide / Show /
Toggle window visibility commands, viewport capture and accepted runtime
foundation test actions. Missing or invalid token on `/control*` returns masked
`404 not_found`.

Runtime foundation startup flags:

```sh
cd steam
tools/dev-vertical-slice.sh connector-control --runtime-load-fixture=warm_food_delivery_mid_chain
tools/dev-vertical-slice.sh connector-control --runtime-load-save
```

Art QA capture:

```sh
cd steam
tools/dev-vertical-slice.sh capture
tools/dev-vertical-slice.sh capture-smoke
tools/dev-vertical-slice.sh first-day-visible-capture
tools/dev-vertical-slice.sh first-day-art-ux-capture
```

Capture output:

```text
docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_VERTICAL_SLICE_ART_QA_CAPTURE_v2/
```

`capture` runs the visible macOS Godot window with deterministic autoplay and fast timings, then saves named viewport screenshots and a PNG-frame sequence fallback under the capture output directory. `capture-smoke` verifies that capture path creation and PNG writing work in a temporary `_capture_smoke_tmp/` directory, then removes that temporary directory so the delivered capture pack is not overwritten.

`first-day-visible-capture` creates the persistent First Day MVP visible review
pack under:

```text
docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v2/
```

It runs a visible macOS capture pass for named screenshots and
`first_day_mvp_visible_loop_frames/`, then runs a matching Workbench
`first_delivery_with_dispatch_confirmation` state-proof pass and copies
`manifest.json`, `final_state.json`, `events.jsonl` and `stress_signals.jsonl`
into `captures/state/`. The command is review evidence only; it does not claim
final visual or player-feel acceptance.

`first-day-art-ux-capture` creates the current Art / UX visual-language pass
pack under:

```text
docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v3/
```

It runs the visible macOS capture at normal prototype speed, writes named
screenshots, `first_day_mvp_visible_loop_frames_1x/`,
`postcard_slippers_moment_1x/`, `README.md`, `CAPTURE_MANIFEST_v3.md`, and the
same Workbench `first_delivery_with_dispatch_confirmation` state proof under
`captures/state/`. The command is still prototype evidence only: it does not
claim final visual acceptance, final palette/style/UI look, or production art
quality.

The v2 capture pass is a focused First Day readability iteration. It keeps the
same gameplay scope and adds only prototype-level main-strip cues: Такса as the
first driver, Лабрадор as the helper, route/payload/van/postcard/reward/next-day
markers, an embodied postcard-board attention cue, a personal slippers marker
for Такса, and review-only marker events in Workbench proof.

The v1 capture pack remains available as the pre-fix Art QA baseline:

```text
docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_VERTICAL_SLICE_ART_QA_CAPTURE_v1/
```

Headless Godot is still used for normal smoke/check commands, but not for screenshot capture in this environment: the headless dummy renderer does not expose a viewport texture for PNG capture.

## Implemented Chain

The scene implements the required first loop:

```text
player_confirmed_trip
-> TripTask
-> Dachshund walks to Basket Bicycle
-> Basket Bicycle leaves the strip
-> calm trip state
-> Basket Bicycle returns
-> visible Oat Crate + Pumpkin Crate payload
-> UnloadTask into Storage
-> Storage inventory updates after visible placement
-> CarryTasks to Kitchen
-> CookTask creates Food Mix
-> CarryTasks to Packing Table
-> PackTask creates Food Bag
-> LoadVanTask loads Food Bag into Delivery Van Endpoint
-> player_confirmed_delivery
-> DeliveryTask
-> Postcard Card
-> Comfortable Slippers reward
-> EquipItemTask
-> Dog Card separates innate trait and equipment
```

The debug log prints contract events such as `payload_visible`, `resource_added_to_storage`, `food_mix_created`, `van_loaded`, `delivery_complete`, and `reward_equipped`.

## Prototype Structure

Files:

- `steam/scenes/prototypes/vertical_slice/vertical_slice_demo.tscn`
- `steam/scripts/prototypes/vertical_slice/vertical_slice_demo.gd`
- `steam/scripts/game_systems/game_systems_runtime.gd`
- `steam/tools/dev-vertical-slice.sh`
- `steam/assets/prototypes/vertical_slice/semantic/README.md`
- `steam/assets/prototypes/vertical_slice/semantic/**`

The implementation uses a small deterministic task/state-machine layer inside
the prototype script plus a first `GameSystemsRuntime` scaffold for structured
dogs, routes, production chains, buildings/rooms, House of Curiosity, economy,
event log, fixtures and local prototype save/export/import. This is
intentionally not a final production AI/task architecture.

Task types represented in prototype data:

- `TripTask`
- `UnloadTask`
- `CarryTask`
- `CookTask`
- `PackTask`
- `LoadVanTask`
- `DeliveryTask`
- `EquipItemTask`
- `IdleTask`

## Asset Handling

Approved semantic PNGs are mirrored from:

```text
docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Semantic_Asset_Pack_v1/approved/
```

to:

```text
steam/assets/prototypes/vertical_slice/semantic/
```

The mirror exists only to provide stable Godot `res://` paths. Source mapping is documented in `steam/assets/prototypes/vertical_slice/semantic/README.md`.

Missing assets are represented with neutral labeled placeholders:

- Packing Table as a Utility Prop work surface, not a Building.
- Oat Crate, Pumpkin Crate, Protein Packet, Packaging Bag, Food Mix, Food Bag as physical world tokens.
- First Postcard and Comfortable Slippers as compact UI/equipment placeholders.
- Dachshund and Labrador as simple labeled dog silhouettes with visible action states.

Art QA fix pass v1 improves these Level 0 placeholders without choosing production art:

- Oat Crate, Pumpkin Crate, Protein Packet, Packaging Bag, Food Mix and Food Bag now use larger, visually distinct geometric token shapes.
- Food Mix and Food Bag are separate visible tokens during the Kitchen -> Packing Table -> Van chain.
- The Packing Table placeholder has stronger work-surface/packing semantics while staying a Utility Prop.
- Dog silhouettes are larger and draw action badges/lanes for carry, unload, kitchen, packing, loading, route and reward states.
- Carried resources are drawn above the dog/action layer so the attached payload remains easier to read.
- First Day readability pass v2 adds non-final world badges and markers for
  driver/helper roles, route readiness, returned payload, van dispatch readiness,
  postcard board, Такса-owned slippers and the gentle next-day note. These are
  prototype cues only, not final UI/art direction.
- First Day Art / UX visual-language pass v3 keeps the same gameplay scope and
  moves more readability into object/state cues: Такса works near the bicycle as
  the first driver, Лабрадор has calmer helper poses, the Packing Table and Van
  visibly change object state, the postcard lives on a board, Такса's slippers
  are drawn on her paws, and the next-day hint is a small physical note. QA
  labels and cards remain available, but hidden-UI screenshots are required for
  review.

## UI / Controls

Compact cards:

- Order Card
- Route Card
- Dog Card
- Postcard Card
- optional debug overlay

Buttons:

- `Отправить`
- `Подтвердить отправку`
- `Получить тапочки`
- `Надеть тапочки`
- `Hide UI` / `Show UI`
- semantic label toggle

View presets:

```sh
cd steam
tools/dev-vertical-slice.sh qa
tools/dev-vertical-slice.sh player-prototype
```

`qa` keeps semantic labels, debug card and performance/status text visible.

`player-prototype` hides semantic labels, debug card, status/performance text, and uses compact top cards so the world/action strip becomes the visual priority. This is still a prototype view mode, not final UI style.

Keyboard:

- Left / Right: pan strip
- Up / Down: zoom
- H: hide / show UI
- D: toggle debug overlay
- L: toggle semantic labels

When UI is hidden, the world keeps running and only the show button remains.

## Prototype Assumptions

- Timings are compressed prototype timings, especially in smoke mode.
- Straight-line movement is acceptable for first playtest readability.
- The scene is isolated from the older companion field demo to preserve existing tech-demo behavior.
- Comfortable Slippers have no numeric effect in this slice; their job is to demonstrate D-010 separation between innate trait and equipment.
- The Food Mix + Food Bag approved composite is used only as a visual bridge behind distinct labeled Food Mix / Food Bag tokens.

## Known Gaps

- Human visual review is still needed for 216 / 144 / 96 px readability.
- Production art for Packing Table, separate resource icons, dog action sprites, postcard and slippers is still missing.
- Windows behavior remains untested.
- The task runner is prototype-local and should not be treated as final production architecture.
- Art QA capture mode is dev-only and should not be treated as player-facing behavior.
- Player-prototype mode is a readability preset only. It does not change gameplay, economy, task flow or the final UI/art direction.
- Capture v2 includes downscaled 216 / 144 / 96 previews, but final readability approval still requires Art Director review.
- Game systems runtime foundation is a dev/design inspection scaffold. It does
  not define final save format, final balance, final production data schema or
  player-facing cheat controls.
