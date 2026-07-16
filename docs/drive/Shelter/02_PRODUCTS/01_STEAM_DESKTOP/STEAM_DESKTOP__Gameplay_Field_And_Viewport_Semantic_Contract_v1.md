# STEAM_DESKTOP — Gameplay Field And Viewport Semantic Contract v1

Дата: 2026-07-14
Статус: accepted user-owner Game Design semantic contract / `READY_FOR_TECHNICAL_READBACK` / no runtime authorization
Владелец: Game Designer
Продукт: Shelter Steam/Desktop
Назначение: отделить неизменные игровые границы First Day + Day 2 от viewport, разрешить безопасное meadow-only продолжение и определить границы Labrador presentation без создания новой механики.

---

## 0. Authority, scope and supersession

Это bounded user-owner решение заменяет только прежнее требование к meadow как к уникальному full-authored corridor без lateral continuation: meadow теперь seam-safe горизонтальный tile module с uniform scale и обрезкой по viewport, а не non-uniform stretch.

Оно **не** заменяет D-023, exact `33` cursors, First Day `3` + Day 2 `2` inputs, `x2/x2 → x1/x1`, Quiet Cooperative, 12-row Labrador manifest A–H или R48-05B later. Оно не создаёт механику, сущность, комнату, task, transfer, resource, output, reward, progression, save field либо новый player input.

Current accepted Labrador/building/meadow visual direction сохраняется. Art wave не перезапускается этим контрактом. Текущий executable integration brief содержит противоречащее ему требование «full authored corridor without non-authored tail» и hash-locked source scope; его не менять в этой волне. До runtime work Producer/PM + Technical/Codex обязаны выдать отдельный readback/brief reconciliation.

---

## 1. Coordinate and ownership contract

В существующих runtime world units фиксируются следующие semantic planes:

```text
gameplay_field_min_x = 0.0
gameplay_field_max_x = 1740.0
gameplay_field = [0.0, 1740.0]
```

`gameplay_field` не зависит от ширины окна, zoom, camera/pan, display или source-canvas width. Это единственная область gameplay/buildable ownership:

- любой current или будущий buildable footprint, station/action anchor, physical task endpoint и gameplay-facing building boundary должен целиком лежать внутри `gameplay_field`;
- никаких buildable cells, stations, dog activity, collision/interaction ownership, task targets или resource/output authority при `x > 1740.0` не существует;
- эти bounds не добавляют строительство или клетки в текущий MVP: они только фиксируют границу для уже существующего и будущего принятого placement authority.

### 1.1 Right boundary marker

Непосредственно exterior от крайней правой buildable cell расположен единственный static decorative `Fence Boundary Marker`.

```text
buildable right edge / marker boundary plane = gameplay_field_max_x = 1740.0
marker is exterior-facing; visual-only meadow starts at x > 1740.0
```

Marker обозначает boundary plane, но не расширяет gameplay field. Его buildable-facing contact edge совпадает с `x = 1740.0`; его декоративный render body допускается только exterior-side этой плоскости. Marker не является gameplay entity и не даёт hit target, task, input, output, resource, reward, progression, collision, save field или cursor transition.

Пользователь выбрал зеркально ориентированный вариант marker. Art обязан дать отдельный authored mirrored-positive source/export; runtime не вправе получать эту ориентацию negative scale / mirror shortcut. Technical проверяет declared boundary plane и source placement, но не выводит gameplay authority из пикселей marker.

### 1.2 Exterior visual-only meadow

Интервал `x > 1740.0` — non-buildable visual-only meadow. Кроме статического marker на его boundary plane, там допускается только meadow presentation:

- meadow module повторяется/обрезается seam-safe и с uniform scale;
- никакого non-uniform stretch, нового authored world, building, dog, station, prop с gameplay meaning, interaction island или task/event marker;
- continuation рисуется лишь настолько, насколько нужно до правого edge текущего viewport; она не получает отдельный world/save extent.

---

## 2. Right-reserve and framing rule

Definitions for a viewport width `V` in screen pixels and a positive world-to-screen zoom `z`:

```text
visible_world_width W = V / z
target right reserve p = 0.15
accepted screen reserve R_screen = p × V, tolerance 0.13V..0.17V
equivalent world reserve R_world = p × W
```

«~15% right reserve» означает **field-end framing**, а не fixed UI overlay: в default framing и в крайнем правом pan при каждом allowed zoom последняя полоса шириной `R_screen` содержит только exterior visual-only meadow (и, на её левой границе, декоративный marker). В ней нет buildings или Labrador activity.

Semantic default is:

```text
z_default = z_min(V) = (1 - p) × V / (gameplay_field_max_x - gameplay_field_min_x)
camera_default_x = gameplay_field_min_x
```

Так default view показывает весь gameplay field в первых ~85% viewport и meadow-only reserve в последних ~15%, без растяжения мира.

For any allowed `z ≥ z_min(V)`, camera bounds are:

```text
camera_min_x = gameplay_field_min_x
camera_max_x = gameplay_field_max_x - (1 - p) × W
```

At `camera_max_x`, `gameplay_field_max_x` maps to `~85%` of screen width and the remaining `~15%` is exterior meadow. `camera_max_x` must never be less than `camera_min_x`; a zoom set that violates this is invalid.

`z_max` is deliberately not a new Game Design number: Technical must retain a finite supported maximum that preserves accepted Labrador/building readability and satisfies `z_max ≥ z_min(V)` for every supported viewport. If the existing zoom ladder cannot admit this inequality, Technical stops for a bounded readback rather than stretching the field, clipping the reserve, or changing gameplay bounds.

While panning between the clamps, the field-end reserve may be off-screen; it is not a screen-pinned empty band. Existing in-field buildings or the Labrador may therefore temporarily appear in the right 15% of a **mid-pan** viewport. The reserve is guaranteed at default and right-end framing at every zoom, while its world ownership remains exterior at all times.

---

## 3. Labrador A–H boundary rule

This contract adds no semantic action row and does not alter selectors A–H.

- All existing task-bound A–G station/action anchors remain valid only inside `gameplay_field`.
- Selector H keeps its exact accepted predicates, B precedence, zero output, non-persisted cache and existing route/timing authority. It receives no new route endpoint or cadence here.
- Every H candidate root — idle, start, walk endpoint, physical-turn point and stop — must satisfy `0.0 ≤ x ≤ 1740.0` before presentation starts or continues.
- The existing accepted H route remains unchanged; Technical validates that its declared points satisfy this interval. This contract does not replace those points from pixels or viewport calculations.

Any H candidate at `x > 1740.0`, any exterior marker/meadow target, an unavailable boundary/readback, or a stale conversion predicate fails closed: H is not selected and emits no movement, task, event, input, output, save, resource, order, reward or progression effect. The adapter may use selector A only at an already valid in-field presentation root; it must not invent an exterior idle point or extrapolate a replacement route.

No Labrador activity is allowed in the right-end reserve. That follows from the camera end clamp: its entire guaranteed reserve is exterior to `gameplay_field`. No selector may treat marker or meadow pixels as a station, target, facing proof or work surface.

---

## 4. Pan, zoom and input precedence

Horizontal mouse-drag pan is required whenever `visible_world_width < gameplay_field width`, subject to the camera clamps above. It is a presentation gesture, not a D-023 gameplay confirmation.

Precedence is exact:

1. An existing visible player gate/control (including the accepted route, dispatch or equip gate) receives its normal click first; a gesture beginning on it cannot become pan.
2. A drag beginning on non-interactive ground **inside** `gameplay_field` may pan horizontally only after Technical's ordinary drag threshold; release then creates no gameplay click.
3. `Fence Boundary Marker` and exterior visual-only meadow create no hit target. Existing click-through semantics apply there; an exterior click/drag cannot create pan, a player gate, a task or another interaction.
4. If no horizontal pan range exists, drag safely does nothing and existing click-through remains intact.

Zoom and pan never start/cancel/complete an order, task, delivery, resource operation, save barrier or H selector. A player gate continues to cancel H before its own authoritative transition under the signed manifest; a pan/zoom gesture by itself does not change H authority.

---

## 5. Restore and presentation-state boundary

Camera position, zoom index/value, drag state, tile repetition/crop and marker visibility are non-persisted presentation/layout state. They are excluded from PlayerCheckpoint, save barriers and all 33 cursors.

On fresh launch or successful durable restore, default semantic framing is recomputed from the current viewport (`z_default`, `camera_default_x`). On resize, the same formulas are recomputed and camera is clamped; no checkpoint write occurs. Before durable state readback completes, existing H restore guards remain in force. Save failure/Retry/recovery never derives a gameplay change from viewport state.

---

## 6. Acceptance and negative cases

### Required semantic acceptance

- At default framing, all gameplay anchors/buildings remain within `[0, 1740]`; the rightmost `13–17%` of viewport is meadow-only and ends at the viewport edge without non-uniform stretch.
- At every supported zoom, maximum right pan places `x = 1740` at `83–87%` of viewport width; the remainder is exterior meadow-only with no building or dog activity.
- If viewport width is smaller than gameplay field at the active zoom, horizontal drag pans only inside the calculated range and leaves existing player gates/click-through behavior authoritative.
- `Fence Boundary Marker` is immediately exterior to the right buildable edge, reads as the boundary, is non-interactive, uses an authored mirrored-positive source/export and never uses negative scale.
- H positive cases remain bounded by its existing selectors inside the field; H negative cases reject exterior/meadow/marker targets and preserve zero output/non-persistence.
- D-023 `3 + 2`, `x2/x2 → x1/x1`, exact 33 cursors, Day 2 careful/focus semantics, Quiet Cooperative and R48-05B later remain unchanged.

### Must fail / reject

- stretching a meadow tile non-uniformly, adding a new unique world tail, or treating the tile count as gameplay extent;
- building/placing/anchoring a station or dog activity beyond `x = 1740.0`;
- treating marker pixels as collision, an interaction, a route target, a task/object entity or proof of ownership;
- negative-scale/mirror shortcut instead of the separate authored mirrored-positive marker export;
- a pointer drag on an accepted player gate stealing that confirmation, or an exterior meadow click creating pan/gameplay input;
- persisting camera/zoom/tile/marker/H route presentation state, changing a cursor, or generating resource/output/progression;
- changing A–H vocabulary, adding object transfer, rooms, rewards or a second simulation.

---

## 7. Technical readback and stop questions

This contract is ready for Technical readback, not implementation. Technical must stop and return a bounded answer if any item below is unresolved:

1. Reconcile the active hash-locked integration brief's contrary no-tail requirement and exact source scope through Producer/PM before importing or generating a meadow tile/marker.
2. Declare supported viewport range and verify a finite `z_max` with `z_max ≥ z_min(V)`; otherwise do not clip the required right reserve or alter field bounds.
3. Provide a safe drag/click-through implementation plan that preserves player-gate precedence and does not capture exterior meadow as a hidden interaction surface.
4. Obtain Art's exact seam-safe meadow module and separate mirrored-positive Fence Boundary Marker source/export with boundary plane metadata; no placeholder, inferred mirror or negative-scale substitute is accepted.
5. Validate existing building/station/H roots against `[0.0, 1740.0]` and prove that camera/zoom/marker/tile state stays outside checkpoint and gameplay authority.

No PM/Art/Codex/runtime mutation is authorized by this Game Design contract alone.

## 8. Signer state

| Owner | State |
| --- | --- |
| User-owner / Game Designer | accepted semantic boundary and presentation guardrails |
| Technical/Codex | readback pending |
| Producer/PM | brief/roadmap reconciliation pending before runtime authorization |
| Art Director | paused; future exact meadow/marker source only |
