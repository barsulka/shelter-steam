# AI reference prompt record

Дата: 2026-07-13
Инструмент: OpenAI built-in `image_gen`
Use case: `stylized-concept`
Статус: `FLATTENED_AI_REFERENCE_ONLY__NOT_SOURCE_MASTER__NOT_RUNTIME_ASSET`

Input references:

- `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/approved_art_files/D-011_steam_overlay_main_strip_v1_reference.png` — composition/tone reference only;
- `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/approved_art_files/STEAM_OVERLAY__dog_action_labrador_watering_can__approved_direction.png` — Labrador direction reference only.

Prompt:

```text
Use case: stylized-concept
Asset type: reference-only game character exploration; this output will NOT be the layered source master
Primary request: create an original side-view shape exploration for dog.labrador_intro, a calm large-but-strip-scaled Labrador helper for Shelter Steam/Desktop. Show exactly three clean pose panels of the same dog: canonical right-facing neutral stand, front/three-quarter physical-turn midpoint, canonical left-facing neutral stand. Keep the dog identity consistent across all three panels.
Input images: Image 1 is composition/tone reference only; Image 2 is a Labrador direction reference only. Do not reproduce their exact pixels, scene, props, clothing, or background.
Subject: broad soft torso, sturdy medium legs with clearly readable paws, friendly blocky-soft head, medium broad muzzle, both ears naturally floppy, straight medium tail with calm weight, warm golden coat with a subtle cream chest marking; no breed exaggeration and no giant mascot head.
Style/medium: warm 2D hand-painted character concept with simple clean shape masses suitable for later independent cutout reconstruction.
Composition/framing: three equally spaced full-body panels on one light neutral flat background, generous padding, baseline aligned, no cropping.
Lighting/mood: soft neutral studio light, calm and kind.
Constraints: no working prop, no watering can, no apron, no collar baked into identity, no text, no labels, no watermark. The physical-turn midpoint must be visibly different from merely mirroring a side pose. Near/far legs and ears must remain distinguishable. Preserve a low-noise silhouette that should still read when reduced.
Avoid: chibi proportions, photorealism, sad rescue-poster expression, human-like stance, aggressive pose, factory/exploitation tone, extra dogs, scenery, UI, harness, bag, crate, kitchen, packing table.
```

AI declaration:

- generated pixels are retained only as a traceable reference;
- no generated pixel is embedded into `source/`, `exports/` or `evidence/`;
- editable Labrador masters are independently reconstructed as named SVG layers by the deterministic package builder;
- this reference does not lock final Shelter style, palette, material treatment or runtime identity.

