# STEAM_VERTICAL_SLICE_ART_QA_FIX_PASS v1 — Brief

Дата: 2026-06-29  
Роль документа: Codex implementation brief for Art QA fixes  
Статус: ready for Codex

Связано с:

- `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_VERTICAL_SLICE_ART_QA_REVIEW_v1.md`
- `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_VERTICAL_SLICE_ART_QA_CAPTURE_v1/`
- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Vertical_Slice_Scope_Lock_v1.md`
- `docs/drive/Shelter/06_SESSIONS_AND_HANDOFFS/cross_role_sessions/2026-06-29__cross_role_rfc__codex_task_boundaries_steam_vertical_slice.md`

## 1. Context

Art QA review v1 verdict:

> Current Vertical Slice is approved for internal prototype continuation, but not approved as player-facing visual/readability slice.

Main issues:

- UI/debug cards dominate the world;
- dog/action readability is too weak;
- prototype depends too much on semantic labels;
- Level 0 semantic placeholders are incomplete;
- Food Mix / Food Bag combined composite is only a temporary bridge;
- full Vertical Slice 216 / 144 / 96 readability pass is still needed.

## 2. Goal

Implement a small visual/readability fix pass for the current Steam Vertical Slice prototype.

Do not change gameplay, economy, product scope or final art direction.

This is not production art. This is Level 0 semantic prototype cleanup.

## 3. Required Level 0 placeholders

Add or improve semantic placeholders for:

1. Packing Table — Utility Prop / work surface.
2. Oat Crate — Resource.
3. Pumpkin Crate — Resource.
4. Protein Packet — Resource.
5. Packaging Bag — Resource.
6. Food Mix — Resource / intermediate product.
7. Food Bag — Resource / final packed product.
8. Comfortable Slippers — Equipment icon / reward placeholder.
9. First Postcard — Reward/card placeholder.
10. Dog action placeholder(s): generic dog-action silhouette or separate Dachshund/Labrador action proxies.

Rules:

- placeholders may be simple labeled geometric tokens;
- no final style decision;
- no new gameplay object;
- each placeholder must map to an existing Vertical Slice contract object/resource/action;
- Utility Props must not become Buildings;
- labels can exist in QA mode, but silhouette/shape should also help readability.

## 4. Resource separation

Separate the visual identity of:

```text
Oat Crate
Pumpkin Crate
Protein Packet
Packaging Bag
Food Mix
Food Bag
```

The chain must visually support:

```text
Storage resources -> Kitchen -> Food Mix -> Packing Table + Packaging Bag -> Food Bag -> Delivery Van Endpoint
```

The combined Food Mix / Food Bag composite may remain only as an internal bridge if still needed, but the visible transformation must use separate semantic tokens.

## 5. Dog/action readability

Improve prototype dog/action readability.

At minimum:

- dog action placeholder should be larger or clearer than before;
- carried item must remain attached/readable;
- dog/action should be visible before building decoration;
- action should not be understandable only from long text label;
- dog should not become a decorative dot.

No final dog art required.

## 6. UI / labels modes

Add or improve view modes/toggles for Art QA:

### QA mode

- semantic labels on;
- debug cards allowed;
- contract/debug info allowed.

### Player-prototype mode

- semantic labels off or minimal;
- debug cards hidden or compact;
- core world/action loop still visible;
- UI should not dominate the strip.

Acceptable launcher modes or debug toggles:

```sh
tools/dev-vertical-slice.sh qa
tools/dev-vertical-slice.sh player-prototype
```

or equivalent if existing script architecture suggests better names.

Do not remove existing debug mode.

## 7. Capture after fix

Produce a follow-up capture pack:

```text
docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_VERTICAL_SLICE_ART_QA_CAPTURE_v2/
```

Required screenshots:

1. initial strip — QA labels on;
2. initial strip — player-prototype labels off/compact UI;
3. bicycle return payload;
4. unload to Storage;
5. Storage -> Kitchen carry;
6. Kitchen / Food Mix;
7. Food Mix -> Packing Table;
8. Packing Table -> Food Bag;
9. Food Bag -> Van;
10. Postcard reward;
11. Dog Card / Slippers;
12. UI hidden world visible;
13. readability preview 216;
14. readability preview 144;
15. readability preview 96.

If exact automated screenshots are hard, document missing captures clearly.

## 8. Acceptance criteria

Task is done if:

- all required Level 0 placeholders exist or missing ones are documented with reason;
- separate resources are visually distinguishable in QA mode;
- Food Mix and Food Bag are visually separate when the transformation is shown;
- Packing Table remains Utility Prop, not Building;
- Van Endpoint remains endpoint/vehicle, not garage/building;
- dog/action placeholder is more readable than in capture v1;
- QA mode and player-prototype mode/toggle exist or are documented through equivalent controls;
- UI/debug cards can be reduced enough that world/action becomes the visual priority;
- follow-up capture pack v2 exists with manifest;
- existing vertical slice smoke passes;
- `steam/tools/check-godot.sh` passes if code changed;
- docs updated:
  - `docs/repo/dev/steam-vertical-slice-prototype.md`
  - `docs/repo/status/CODEX_STATUS.md`.

## 9. Failure criteria

Stop and document if:

- adding placeholders requires gameplay scope change;
- separate resources break the chain logic;
- dog/action remains unreadable at strip scale;
- player-prototype labels-off mode makes loop impossible to follow;
- UI cannot be compacted without large refactor;
- Utility Prop starts reading as Building;
- Van Endpoint starts reading as garage;
- capture v2 cannot be produced.

## 10. Out of scope

Do not:

- change gameplay loop;
- add new mechanics;
- change economy;
- make production art;
- choose final palette/style;
- implement Dog Shape Pack;
- implement real shelter dog intake;
- redesign UI fully;
- add Browser Extension concepts.

## 11. Documentation update

Update `docs/repo/dev/steam-vertical-slice-prototype.md` with:

- new placeholders;
- new view modes/toggles;
- how to run QA/player-prototype/capture modes;
- known limitations.

Update `docs/repo/status/CODEX_STATUS.md` with:

```md
## 2026-06-29 - Steam Vertical Slice Art QA Fix Pass v1

- Branch:
- Summary:
- Changed files:
- Checks:
- Captures:
- Observations:
- Assumptions:
- Blockers:
- Next recommended step:
```

## 12. Next after this task

If this pass succeeds:

1. Art Director reviews capture v2.
2. If v2 passes, start Dog Shape Pack v1.
3. If v2 still fails, do one focused readability pass before Dog Shape Pack.
