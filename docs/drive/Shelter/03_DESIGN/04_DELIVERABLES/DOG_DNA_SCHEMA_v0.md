# DOG_DNA_SCHEMA v0

Дата: 2026-06-28  
Роль документа: Character Production Schema Draft  
Статус: working draft  
Связано с: `DOG_RUNTIME_AND_ANIMATION_GRAMMAR_v1.md`

## 1. Назначение

Этот документ переводит идею Dog Runtime в первую практическую таблицу полей.

Цель:

> Описать собаку Shelter не как один ассет, а как production-рецепт, который можно использовать художнику, аниматору, геймдизайнеру и Codex.

Dog DNA schema v0 нужна для:

- генерации / постановки собак;
- intake реальных приютских собак;
- выбора skeleton family;
- проверки animation compatibility;
- сборки карточек собак;
- будущего Godot data model spike.

## 2. Schema principles

1. Порода не является главным полем.  
2. Реальная собака описывается morphology channels.  
3. Скелет выбирается по форме и клипам, а не по породе.  
4. Окрас и аксессуары не должны заменять силуэт.  
5. Характер влияет на движение через animation profile.  
6. История собаки и legal/permission status хранятся отдельно от визуальной формы.  
7. Schema должна поддерживать fictional prototype dogs и real shelter dogs.

## 3. Minimal Dog DNA object

```yaml
dog_id: DOG-000001
public_name: Бублик
source_type: prototype

morphology:
  skeleton_family: standard_medium
  body_length: medium
  body_volume: medium
  leg_length: medium
  head_shape: wedge_soft
  muzzle_length: medium
  ears: half_floppy
  tail: curled_medium
  fur: medium
  markings: white_chest

appearance:
  base_coat: warm_brown
  secondary_coat: cream
  accent_marks:
    - white_chest
  accessories:
    - soft_green_collar

animation_profile:
  motion_preset: curious_helper
  walk_speed_multiplier: 1.05
  step_frequency: 1.1
  tail_wag_amplitude: 1.2
  look_around_frequency: 1.4

production:
  approval_status: draft
  rig_version: dog_rig_standard_v0
  notes: first test dog
```

## 4. Required top-level fields

### 4.1 `dog_id`

Stable technical identifier.

Format proposal:

```text
DOG-000001
```

Required: yes.

### 4.2 `public_name`

User-facing dog name.

Required: yes for playable dogs, optional for pure internal test rigs.

### 4.3 `source_type`

Allowed values:

- `prototype` — тестовая fictional dog.  
- `fictional_seed` — вымышленная собака для production.  
- `shelter_real_dog` — реальная приютская собака.  
- `shelter_inspired` — вдохновлено реальной собакой, но не точный портрет.

Required: yes.

### 4.4 `shelter_ref`

Reference to shelter / partner / source.

Required only for `shelter_real_dog`.

### 4.5 `permissions_status`

Allowed values:

- `not_required_prototype`;
- `pending`;
- `approved`;
- `restricted`;
- `expired`;
- `do_not_use`.

Required for real dogs.

## 5. Morphology fields

### 5.1 `skeleton_family`

Allowed values v0:

- `standard_medium`;
- `short_long`;
- `large_sturdy`;
- `compact_fluffy`;
- `short_muzzle`.

MVP recommendation:

Start with `standard_medium`, then add `short_long` and `large_sturdy`.

### 5.2 `body_length`

Allowed values:

- `short`;
- `medium`;
- `long`.

### 5.3 `body_volume`

Allowed values:

- `slim`;
- `medium`;
- `sturdy`;
- `fluffy`;
- `barrel`.

### 5.4 `chest`

Allowed values:

- `narrow`;
- `medium`;
- `broad`;
- `barrel`.

### 5.5 `leg_length`

Allowed values:

- `short`;
- `medium_short`;
- `medium`;
- `medium_long`;
- `long`.

### 5.6 `leg_thickness`

Allowed values:

- `thin`;
- `medium`;
- `sturdy`.

### 5.7 `head_shape`

Allowed values:

- `round`;
- `wedge_soft`;
- `blocky_soft`;
- `narrow`;
- `soft_square`.

### 5.8 `muzzle_length`

Allowed values:

- `short`;
- `medium`;
- `long`.

### 5.9 `muzzle_width`

Allowed values:

- `narrow`;
- `medium`;
- `broad`.

### 5.10 `ears`

Allowed values:

- `both_upright`;
- `both_floppy`;
- `half_floppy`;
- `one_up_one_floppy`;
- `button`;
- `tiny_folded`;
- `large_soft`.

### 5.11 `ear_weight`

Allowed values:

- `light`;
- `medium`;
- `heavy`.

### 5.12 `tail`

Allowed values:

- `straight_short`;
- `straight_medium`;
- `straight_long`;
- `curled_medium`;
- `curled_high`;
- `fluffy_plume`;
- `low_soft`.

### 5.13 `fur`

Allowed values:

- `smooth`;
- `short`;
- `medium`;
- `shaggy`;
- `fluffy`;
- `wiry`.

### 5.14 `markings`

Allowed values can be list:

- `none`;
- `white_chest`;
- `white_paws`;
- `left_eye_patch`;
- `right_eye_patch`;
- `mask`;
- `tail_tip`;
- `spotted`;
- `asymmetric_face`;
- `brindle_simplified`.

## 6. Appearance fields

### 6.1 `base_coat`

Allowed value style:

- `warm_brown`;
- `dark_brown`;
- `cream`;
- `black_soft`;
- `grey_warm`;
- `golden`;
- `rust`;
- `white_warm`;
- `mixed_tricolor`.

Palette should remain Shelter-warm, not harsh.

### 6.2 `secondary_coat`

Same palette as base coat, optional.

### 6.3 `accent_marks`

List of marking layers.

### 6.4 `accessories`

Allowed examples:

- `none`;
- `soft_green_collar`;
- `cream_bandana`;
- `work_harness`;
- `tiny_name_tag`;
- `soft_booties`;
- `light_work_vest`.

Accessory must not become the whole identity.

## 7. Rig fields

### 7.1 `rig_version`

Example:

```text
dog_rig_standard_v0
```

### 7.2 `compatible_clip_sets`

Examples:

- `locomotion_basic_v0`;
- `carry_basic_v0`;
- `work_basic_v0`;
- `rest_basic_v0`.

### 7.3 `required_overrides`

Examples:

- `ear_secondary_motion_asymmetric`;
- `tail_curl_socket`;
- `short_muzzle_mouth_socket`;
- `shaggy_fur_visibility_guard`;
- `short_leg_step_frequency_adjust`.

## 8. Animation profile fields

### 8.1 `motion_preset`

Allowed values v0:

- `curious_helper`;
- `calm_worker`;
- `happy_bouncy`;
- `careful_gentle`;
- `sleepy_soft`.

### 8.2 Numeric / enum parameters

All optional at first. If omitted, preset defaults apply.

- `walk_speed_multiplier`: number, e.g. `0.85`–`1.2`.  
- `step_frequency`: number.  
- `head_bob_amount`: number.  
- `tail_wag_amplitude`: number.  
- `tail_wag_frequency`: number.  
- `ear_bounce_amount`: number.  
- `look_around_frequency`: number.  
- `sniff_frequency`: number.  
- `pause_probability`: number.  
- `carrying_effort`: `low` / `medium` / `high`.  
- `idle_fidget`: `none` / `sniff` / `look_around` / `paw_adjust` / `stretch`.

## 9. Gameplay-facing fields

These fields are placeholders for future game design. Art direction should not overdefine mechanics.

- `preferred_tasks`  
- `disliked_tasks`  
- `innate_traits`  
- `equippable_traits`  
- `room_personality_tags`

Must follow D-010:

- innate traits are not removable;
- equippable traits can modify but not erase personality.

## 10. Story fields

### 10.1 `short_bio`

Small internal/user-facing description.

### 10.2 `shelter_story`

For real dogs only if legally and ethically approved.

### 10.3 `tone_guard`

Allowed values:

- `normal`;
- `sensitive`;
- `no_sad_marketing`;
- `anonymous`.

Rule:

> Real dog stories must not become guilt pressure.

## 11. Production fields

- `approval_status`: `draft` / `art_review` / `animation_review` / `approved_direction` / `approved_production` / `rejected` / `archived`.  
- `source_files`  
- `reference_images`  
- `legal_notes`  
- `created_by`  
- `last_updated`  
- `notes`

## 12. Example dogs

### 12.1 DOG-PROT-001 — Bublik / standard mixed shelter dog

```yaml
dog_id: DOG-PROT-001
public_name: Бублик
source_type: prototype
permissions_status: not_required_prototype

morphology:
  skeleton_family: standard_medium
  body_length: medium
  body_volume: medium
  chest: medium
  leg_length: medium
  leg_thickness: medium
  head_shape: wedge_soft
  muzzle_length: medium
  muzzle_width: medium
  ears: one_up_one_floppy
  ear_weight: medium
  tail: curled_medium
  fur: medium
  markings:
    - white_chest
    - left_eye_patch

appearance:
  base_coat: warm_brown
  secondary_coat: cream
  accent_marks:
    - white_chest
    - left_eye_patch
  accessories:
    - soft_green_collar

rig:
  rig_version: dog_rig_standard_v0
  compatible_clip_sets:
    - locomotion_basic_v0
    - carry_basic_v0
  required_overrides:
    - ear_secondary_motion_asymmetric
    - tail_curl_socket

animation_profile:
  motion_preset: curious_helper
  walk_speed_multiplier: 1.05
  step_frequency: 1.1
  tail_wag_amplitude: 1.2
  look_around_frequency: 1.4
  idle_fidget: sniff

production:
  approval_status: draft
  notes: baseline mixed shelter dog for Dog Shape Pack v1
```

### 12.2 DOG-PROT-002 — Knopka / short-legged long dog

```yaml
dog_id: DOG-PROT-002
public_name: Кнопка
source_type: prototype
permissions_status: not_required_prototype

morphology:
  skeleton_family: short_long
  body_length: long
  body_volume: medium
  chest: medium
  leg_length: short
  leg_thickness: sturdy
  head_shape: soft_square
  muzzle_length: medium
  muzzle_width: medium
  ears: both_floppy
  ear_weight: heavy
  tail: straight_medium
  fur: short
  markings:
    - white_paws
    - white_chest

appearance:
  base_coat: dark_brown
  secondary_coat: cream
  accent_marks:
    - white_paws
  accessories:
    - cream_bandana

rig:
  rig_version: dog_rig_short_long_v0
  compatible_clip_sets:
    - locomotion_basic_v0
    - carry_basic_v0
  required_overrides:
    - short_leg_step_frequency_adjust
    - low_mouth_socket

animation_profile:
  motion_preset: happy_bouncy
  walk_speed_multiplier: 0.95
  step_frequency: 1.25
  tail_wag_amplitude: 1.4
  carrying_effort: medium

production:
  approval_status: draft
  notes: short-legged test for clipping and carry readability
```

### 12.3 DOG-PROT-003 — Mishka / large calm dog

```yaml
dog_id: DOG-PROT-003
public_name: Мишка
source_type: prototype
permissions_status: not_required_prototype

morphology:
  skeleton_family: large_sturdy
  body_length: medium
  body_volume: sturdy
  chest: broad
  leg_length: medium_long
  leg_thickness: sturdy
  head_shape: blocky_soft
  muzzle_length: medium
  muzzle_width: broad
  ears: both_floppy
  ear_weight: heavy
  tail: fluffy_plume
  fur: medium
  markings:
    - white_chest
    - mask

appearance:
  base_coat: golden
  secondary_coat: white_warm
  accent_marks:
    - white_chest
  accessories:
    - work_harness

rig:
  rig_version: dog_rig_large_sturdy_v0
  compatible_clip_sets:
    - locomotion_basic_v0
    - carry_basic_v0
    - work_basic_v0
  required_overrides:
    - heavy_body_step_timing
    - broad_mouth_socket

animation_profile:
  motion_preset: calm_worker
  walk_speed_multiplier: 0.85
  step_frequency: 0.85
  head_bob_amount: 0.7
  tail_wag_frequency: 0.7
  carrying_effort: high

production:
  approval_status: draft
  notes: large calm dog test without extreme scale difference
```

## 13. Immediate next use

Use these 3 prototype dogs for first Dog Rig Spike v0:

1. Бублик — standard mixed.  
2. Кнопка — short-legged.  
3. Мишка — large calm.

Minimum clips:

- idle;
- walk;
- carry food bag.

Goal:

> Проверить, можно ли одной логикой Dog DNA + skeleton family + shared clips получить трёх разных собак без ручной полной перерисовки каждой анимации.
