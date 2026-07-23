# Dog Rig Spike v0

## Goal

This spike checks whether Shelter can assemble one dog as modular Godot runtime parts, replay shared motion grammar, attach an object to a socket, and make small personality offsets visible without drawing a full frame-by-frame animation set.

The completed spike briefs are retained in Git history. This file records the
technical prototype surface still present in the checkout.

## Current Implementation

Files:

- `steam/scenes/tech_demos/dog_rig_spike.tscn`
- `steam/scripts/tech_demos/dog_rig_spike.gd`
- `steam/resources/tech_demos/dog_dna_examples.json`
- `steam/tools/dev-dog-rig.sh`

Run:

```sh
cd steam
tools/dev-dog-rig.sh
tools/dev-dog-rig.sh smoke
tools/dev-dog-rig.sh stress
tools/dev-dog-rig.sh stress-smoke
tools/dev-dog-rig.sh pipeline
tools/dev-dog-rig.sh pipeline-smoke
tools/dev-dog-rig.sh hybrid
tools/dev-dog-rig.sh hybrid-smoke
tools/dev-dog-rig.sh hybrid-companion-perf
tools/dev-dog-rig.sh hybrid-companion-smoke
```

Optional manual presets:

```sh
tools/dev-dog-rig.sh bublik
tools/dev-dog-rig.sh knopka
tools/dev-dog-rig.sh mishka
```

## Runtime Shape

The v0 approach intentionally uses Godot nodes plus manual part transforms:

- body;
- white chest marking;
- head;
- muzzle;
- simplified front upper/lower leg;
- simplified back upper/lower leg;
- left/right ears;
- tail;
- collar;
- `MouthHarnessSocket`;
- carried food bag.

The scene loads `dog_dna_examples.json`, defaults to `DOG-PROT-001 / Bublik`, and can also launch `DOG-PROT-002 / Knopka` or `DOG-PROT-003 / Mishka` for early morphology checks.

## v1 Morphology Stress

The v1 stress pass adds a side-by-side mode inside the same scene and script:

```sh
cd steam
tools/dev-dog-rig.sh stress
tools/dev-dog-rig.sh stress-smoke
```

Stress mode shows three lanes at once:

- `DOG-PROT-001 / Bublik` - `standard_medium`, `curious_helper`;
- `DOG-PROT-002 / Knopka` - `short_long`, `happy_bouncy`;
- `DOG-PROT-003 / Mishka` - `large_sturdy`, `calm_worker`.

All three dogs are assembled from `dog_dna_examples.json` and use the same `_update_rig(...)` action-phrase runtime. The implementation intentionally refactors the v0 hardcoded single dog into reusable rig dictionaries instead of copying animation logic per morphology.

Stress mode keeps the same phrase:

```text
idle -> head look -> walk to bag -> pickup -> walk carrying bag -> deliver -> happy tail wag
```

Each lane has a label with dog id, name, skeleton family, motion preset, current clip, and bag socket state. Phase offsets are slightly staggered so attachment and motion differences are easier to inspect.

## Clips And Layers

The scene runs a fixed phrase:

```text
idle -> head look -> walk to bag -> pickup -> walk carrying bag -> deliver -> happy tail wag
```

Named clip states:

- `idle_neutral`
- `head_look`
- `walk_empty`
- `pickup_pose`
- `walk_carry_medium`
- `deliver_pose`
- `tail_wag`

Simulated additive layers:

- `tail_wag`;
- `head_look`;
- `ear_bounce`;
- carried object swing.

This is not a final `AnimationPlayer` or `AnimationTree` architecture. It is a cheap native proof that verifies sockets, modular parts, shared motion math, and DNA-driven offsets before choosing heavier animation tooling.

## v1 Readability Preview

Stress mode draws a simple black-silhouette preview row for each prototype dog at approximate `216 / 144 / 96` px checks.

Early readability observations:

- Bublik remains the clean baseline: standard body, medium legs, bag and tail stay readable.
- Knopka reads as lower and longer; the bag remains visible, but short legs are closest to the risk area for walk/carry readability.
- Mishka reads as taller/sturdier without requiring a different world scale in this debug scene.
- At the 96 px approximation, the silhouettes still read as dog + carried object, but secondary ear/tail motion should stay restrained in later art passes to avoid noise.

## Observations

Early pass:

- Modular parts are practical enough for a proof scene.
- A child-node socket keeps the food bag visually connected through walk and carry poses.
- `tail_wag`, `head_look`, `ear_bounce`, and object swing can be layered procedurally without visual collapse.
- Dog DNA can be represented as JSON for prototype data and used to change proportions and motion offsets.
- The same runtime can launch Bublik, Knopka, and Mishka placeholders, although only Bublik is the acceptance-critical v0 dog.

Validation run on 2026-06-28:

- `steam/tools/dev-dog-rig.sh smoke`
- `steam/tools/check-godot.sh`
- headless direct launches for `DOG-PROT-002` and `DOG-PROT-003`
- visible macOS auto-quit launch for `DOG-PROT-001`

Validation run on 2026-06-29:

- `steam/tools/dev-dog-rig.sh smoke`
- `steam/tools/dev-dog-rig.sh stress-smoke`
- `steam/tools/check-godot.sh`
- visible macOS stress launch with auto quit:
  `Godot --path steam --scene res://scenes/tech_demos/dog_rig_spike.tscn -- --dog-rig-stress --dog-rig-print-perf --dog-rig-auto-quit --dog-rig-seconds=2.2`
- `git diff --check`

Performance observation from the visible macOS stress run:

- FPS reported by the in-scene perf monitor reached roughly `80-108` during the short run.
- Node count: `77`.
- Draw calls: about `110`.
- This is a development observation on one Mac, not a production benchmark. There is no obvious 3-dog runtime red flag yet, but companion-overlay profiling is still required.

## v2 Animation Pipeline Comparison

The v2 pass adds a pipeline comparison mode inside the same scene and script:

```sh
cd steam
tools/dev-dog-rig.sh pipeline
tools/dev-dog-rig.sh pipeline-smoke
```

Visible pipeline mode shows two Bublik lanes:

- Target A: current procedural node-transform runtime.
- Target B: minimal `AnimationPlayer`-authored pose clips.

Both lanes use `DOG-PROT-001 / Bublik` from `dog_dna_examples.json` and run the same phrase:

```text
idle -> head look -> walk to bag -> pickup -> walk carrying bag -> deliver -> happy tail wag
```

The authored lane is intentionally small. It creates an `AnimationPlayer` at runtime and adds clips for:

- `idle_neutral`;
- `head_look`;
- `walk_empty`;
- `walk_carry_medium`;
- `pickup_pose`;
- `deliver_pose`;
- `tail_wag`.

The authored clips animate local driver nodes for body/head/legs/ears/tail/bag. The runtime still handles Dog DNA loading, phrase timing, lane movement, bag visibility, and socket placement. This is the important finding: authored clips help pose authoring, but they do not remove the need for a Dog Runtime layer.

### v2 Comparison Table

| Topic | Procedural node transforms | Minimal `AnimationPlayer` clips |
| --- | --- | --- |
| Authoring effort | Fast for Codex/dev iteration, but motion tuning lives in code. | More explicit clips and easier to inspect as animation data, but setup boilerplate appears immediately. |
| Code complexity | One phrase runner and math-driven pose layers; compact for prototypes, harder for artists. | Needs clip setup, driver nodes, clip switching, plus runtime glue; more moving pieces even in v2. |
| Animation readability | Good enough for proof; secondary motion is easy to parameterize. | Good enough for idle/walk/carry/pickup/deliver; pose intent is clearer clip-by-clip. |
| Object socket handling | Strong: bag remains a child of `MouthHarnessSocket` and procedural swing is simple. | Still works, but socket visibility/attachment remains runtime-owned, not solved by clips alone. |
| Dog DNA offsets | Natural fit: morphology and motion profile directly feed runtime math. | Possible, but authored clips need a modifier layer or post-processing to keep DNA offsets useful. |
| Different morphologies | v1 showed Bublik/Knopka/Mishka can share the runtime grammar. | Not validated yet; authored clips were only tested on Bublik. |
| Artist/animator suitability | Weak: too code-centric for production animation authoring. | More promising for authored base clips, especially if created in editor or imported later. |
| Performance risk | Low in current debug scene. | Low in current debug scene; pipeline mode had fewer dogs and no obvious red flag. |
| Scalability to many real dogs | Promising for procedural personality/morphology offsets. | Promising only if combined with runtime offsets; raw authored clips alone risk multiplying variants. |
| Maintainability | Fine for early spike; could become opaque if every task becomes code math. | Better separation of base poses, but needs a clear runtime/clip contract to avoid duplicate setup. |

### v2 Observations

- Existing v0 single-dog and v1 stress modes still run.
- The authored lane can represent the required phrase coarsely with `AnimationPlayer` clips.
- `AnimationPlayer` is promising for base clip authoring, but not as a full replacement for procedural runtime.
- The best next technical direction is likely hybrid: authored base clips plus procedural Dog DNA/personality/socket layers.
- `Skeleton2D` should remain a later feasibility spike; v2 does not justify jumping straight to external tooling.

Validation run on 2026-06-29:

- `steam/tools/dev-dog-rig.sh smoke`
- `steam/tools/dev-dog-rig.sh stress-smoke`
- `steam/tools/dev-dog-rig.sh pipeline-smoke`
- `steam/tools/check-godot.sh`
- visible macOS pipeline launch with perf print:
  `Godot --path steam --scene res://scenes/tech_demos/dog_rig_spike.tscn -- --dog-rig-pipeline --dog-rig-print-perf --dog-rig-auto-quit --dog-rig-seconds=2.2`
- `git diff --check`

Performance observation from the visible macOS pipeline run:

- FPS reported by the in-scene perf monitor reached roughly `65-120` during the short run.
- Node count: `64`.
- Draw calls: about `37`.
- This is a development observation on one Mac, not a production benchmark.

## v3 Hybrid Runtime

The v3 pass adds a hybrid runtime mode:

```sh
cd steam
tools/dev-dog-rig.sh hybrid
tools/dev-dog-rig.sh hybrid-smoke
```

Visible hybrid mode shows:

- Procedural Bublik baseline.
- Hybrid Bublik.

Hybrid Bublik uses the same runtime-created `AnimationPlayer` base clips from v2, but procedural runtime now overlays Dog DNA and personality layers on top of the authored driver pose.

### Hybrid Responsibility Split

Authored / `AnimationPlayer` owns:

- base pose keys;
- basic idle pose;
- basic walk pose cycle;
- basic carry pose;
- pickup/deliver pose intent;
- coarse body/head/leg timing.

Procedural runtime owns:

- Dog DNA load from `dog_dna_examples.json`;
- morphology dimensions and part sizing;
- phrase timing and state transitions;
- socket visibility and food bag attachment;
- object swing;
- tail/head/ear personality offsets;
- motion profile parameters;
- per-dog labels and debug state.

The important v3 result is that the authored clip no longer acts as a complete hand-made dog animation. It acts as a base pose layer, and the runtime still makes the dog a Dog DNA object.

### Hybrid Companion-Like Perf

v3 also adds a constrained companion-like performance mode:

```sh
tools/dev-dog-rig.sh hybrid-companion-perf
tools/dev-dog-rig.sh hybrid-companion-smoke
```

This mode is intentionally not integrated into the production companion demo. It opens a short strip-like window and runs three hybrid dogs:

- Bublik;
- Knopka;
- Mishka.

It exists to test dog runtime behavior under a smaller strip composition without disturbing the existing companion field demo.

### v3 Observations

- Hybrid Bublik remains readable compared with procedural Bublik.
- Authored clips are useful for base pose intent: idle/walk/carry/pickup/deliver are easier to reason about as clips than as pure math.
- Dog DNA still drives body length, body height, leg length, head/muzzle size, color, and motion profile overlays.
- Runtime-owned socket handling remains strong: the food bag stays attached to `MouthHarnessSocket`, while visibility and swing are controlled outside the clip.
- Personality motion remains visible through procedural head look, tail wag, ear bounce, object swing, and motion profile multipliers.
- Hybrid does add glue code: clip authoring alone is not enough, but the split is conceptually cleaner than pure procedural for future base animation authoring.

Validation run on 2026-06-29:

- `steam/tools/dev-dog-rig.sh smoke`
- `steam/tools/dev-dog-rig.sh stress-smoke`
- `steam/tools/dev-dog-rig.sh pipeline-smoke`
- `steam/tools/dev-dog-rig.sh hybrid-smoke`
- `steam/tools/dev-dog-rig.sh hybrid-companion-smoke`
- `steam/tools/check-godot.sh`
- visible macOS hybrid launch with perf print:
  `Godot --path steam --scene res://scenes/tech_demos/dog_rig_spike.tscn -- --dog-rig-hybrid --dog-rig-print-perf --dog-rig-auto-quit --dog-rig-seconds=2.2`
- visible macOS companion-like launch with perf print:
  `Godot --path steam --scene res://scenes/tech_demos/dog_rig_spike.tscn -- --dog-rig-hybrid-companion --dog-rig-print-perf --dog-rig-auto-quit --dog-rig-seconds=2.2`
- `git diff --check`

Performance observations from the visible macOS runs:

- Hybrid Bublik comparison: roughly `51-120` FPS, `64` nodes, about `37` draw calls.
- Hybrid companion-like strip with three dogs: roughly `71-120` FPS, `110` nodes, about `50` draw calls.
- These are development observations on one Mac, not production benchmarks. No obvious red flag appeared in this isolated spike, but the real companion overlay still needs a later integration measurement.

## Dog Runtime Integration Slice v0

The next integration slice adds a debug-only embedded Bublik runtime to the real companion field demo:

```sh
cd steam
tools/dev-companion-field.sh dog-runtime
tools/dev-companion-field.sh dog-runtime-smoke
```

This is not a replacement for the Dog Rig Spike scene and does not yet extract a shared dog runtime module. It copies the v3 responsibility split into the companion context as a prototype bridge:

- Dog DNA still comes from `dog_dna_examples.json` and uses `DOG-PROT-001 / Bublik`.
- The companion strip draws one dog on the field baseline and keeps the dog in field world coordinates for camera pan/zoom.
- The visible phrase is `idle -> walk -> pickup food bag -> carry -> deliver -> wag -> idle`.
- The mouth socket owns food bag attachment/release during carry.
- The debug label exposes dog id/name, phrase, socket state, and the current base-clip/procedural bridge state.
- The implementation remains embedded inside `companion_field_demo.gd` to avoid moving spike-only scene code wholesale into the production-strip prototype.

The important result is that the v3 hybrid concept can be observed inside the actual companion field/window/HUD context, while the spike scene remains available for isolated animation comparisons.

Limitations:

- This is Option B from the brief, not a production skeletal pipeline.
- There is no authored `AnimationPlayer` clip library yet.
- Leg motion is readable but still rough; true foot locking is not solved.
- Short-legged and large-sturdy variants now run in the same stress scene, but still need human visual review before treating the shared grammar as art-approved.
- The integration slice measures only one debug dog inside the full companion overlay. It does not yet prove a shared multi-dog production runtime.
- The v3 companion-like mode is a constrained dog-rig strip; the new `dog-runtime` companion mode is the first real companion-field integration bridge.
- A future CTO/art decision is still needed before adopting Godot-only procedural rigs, native `Skeleton2D`, or an external Spine-like tool.

## Current Recommendation

Treat v3 as a qualified hybrid-runtime pass:

1. Prepare `Dog Shape Pack v1` as an art task so the next dog tests use real part shapes instead of primitive polygons.
2. Extract or design a shared dog runtime module only after the embedded companion bridge is reviewed in visible desktop context.
3. Keep hybrid as the preferred next prototype direction: authored base clips plus procedural Dog DNA/personality/socket layers.
4. Defer `Skeleton2D` and external tooling until real dog art parts reveal a concrete limitation.
