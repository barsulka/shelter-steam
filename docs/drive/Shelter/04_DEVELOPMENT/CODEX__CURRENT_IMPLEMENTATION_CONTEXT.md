# CODEX — Current Implementation Context

Дата создания: 2026-07-07
Статус: active current-summary
Владелец: Codex / Project Manager
Назначение: короткий актуальный dev/Codex вход без перечитывания всего `CODEX_STATUS.md` и старых brief-файлов.

---

## 0. Read policy

Codex / dev-oriented sessions read this after:

```text
PROJECTS_RULES.md
AGENTS.md
README.md
steam/AGENTS.md
steam/README.md
docs/repo/adr/README.md
docs/repo/status/CODEX_CURRENT_STATUS.md
```

Then read relevant accepted ADRs and the active task brief.

This file is a compressed implementation context map. It does not replace implementation briefs, ADRs, `steam/README.md` or detailed history in `CODEX_STATUS.md`.

Important status split:

```text
docs/repo/status/CODEX_CURRENT_STATUS.md — current dev status, read on bootstrap.
docs/repo/status/CODEX_STATUS.md — detailed chronological history, do not read in full by default.
```

---

## 1. Current repo / tooling shape

Repository root:

```text
/Users/barsulka/GolandProjects/shelter/shelter
```

Steam/Godot project:

```text
steam/
```

Preferred local ChatGPT/dev bridge:

```text
/Users/barsulka/GolandProjects/shelter/mcp
```

Shelter MCP is the preferred bridge for ChatGPT inspection/dev workflows. It exposes whitelisted Shelter tools and proxied `fs_*` filesystem access. It is not a generic shell.

---

## 2. Core technical decisions

Read ADR index before technical work:

```text
docs/repo/adr/README.md
```

Active ADRs:

```text
0001 — Use Godot For Steam/Desktop
0002 — Game State As Source Of Truth
```

Key rule:

```text
Godot runtime is the source of truth.
Workbench observes and controls accepted dev surfaces; it does not simulate Shelter independently.
```

Do not revive standalone simulator direction. It was superseded by Godot State Connector / Workbench-over-live-Godot decisions.

---

## 3. Current product implementation state

Current Steam/Desktop product state:

```text
First Day MVP locked at prototype/product-language level.
Next scope selected: First Week / Day 2 / longer retention.
```

Current visual-language evidence:

```text
STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v3: PASS as prototype First Day Art/UX Visual Language Pass.
```

Caveat:

```text
Not production art. Not final visual style. Not shipping UX. Not final animation polish.
```

Product context source:

```text
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__CURRENT_CONTEXT.md
```

---

## 4. Implemented dev capabilities

Implemented across completed Codex tasks:

- Godot 4.x Steam/Desktop project skeleton.
- Desktop window / companion strip tech demos.
- Companion field demo.
- Dog rig spike v0..v3.
- Dog runtime integration slice.
- Steam Vertical Slice prototype.
- Visual launcher.
- Semantic asset import for prototype placeholders.
- Art QA capture packs.
- Godot State Connector v0.
- Godot Control Connector v0.
- Viewport screenshot / frame capture endpoints.
- Game Systems Runtime Foundation v1.
- Workbench Runtime Capture Harness v0.
- Dispatch confirmation capture path.
- Shelter MCP whitelist for dispatch scenario/control action.
- First Day MVP runtime polish.
- First Day visible review capture pack v1/v2/v3.
- First Day Art/UX visual-language pass v1.
- Shelter MCP repo/document tooling v1/v2.
- Shelter MCP Knowledge API v2 for decisions, open questions, roadmaps, latest handoff and task context.

Current short dev status:

```text
docs/repo/status/CODEX_CURRENT_STATUS.md
```

Detailed chronological dev history:

```text
docs/repo/status/CODEX_STATUS.md
```

Use current status first. Do not read the whole history log by default.

---

## 5. Current important commands

Common Steam commands from `steam/`:

```sh
./launch.sh
./launch.sh --exit
tools/check-godot.sh
tools/dev-vertical-slice.sh smoke
tools/dev-vertical-slice.sh capture-smoke
tools/dev-vertical-slice.sh connector-control-smoke
tools/dev-vertical-slice.sh first-day-art-ux-capture
```

Workbench/capture commands and options are documented in:

```text
steam/README.md
docs/repo/dev/godot-state-connector.md
docs/repo/dev/steam-vertical-slice-prototype.md
```

Do not run broad or new dev controls unless they are explicitly whitelisted/accepted by a brief or ADR.

---

## 6. Current proof / artifact location

Latest First Day visual proof pack:

```text
docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v3/
```

Important files:

```text
README.md
CAPTURE_MANIFEST_v3.md
captures/state/manifest.json
captures/state/final_state.json
captures/state/events.jsonl
captures/state/stress_signals.jsonl
captures/screenshots/*.png
captures/video/first_day_mvp_visible_loop_frames_1x/*.png
captures/video/postcard_slippers_moment_1x/*.png
```

Read pack docs and state proof first. Do not load PNG/frame directories unless visual inspection is required.

---

## 7. Completed briefs are historical by default

Old brief files in:

```text
docs/drive/Shelter/04_DEVELOPMENT/
```

are historical once implemented unless explicitly marked as active/prepared.

For current implementation planning, use:

1. Product/design current context.
2. Latest accepted product/design doc.
3. New task brief.
4. ADRs.
5. Latest `CODEX_STATUS.md` top entry.

Do not reconstruct current state by reading every old brief.

---

## 8. Known limitations / recurring cautions

- Windows behavior remains broadly less tested than macOS visible checks.
- Prototype visual-language evidence is not production art.
- 100x Workbench capture validates state/causality, not player feel or visual warmth.
- Generated runtime bundles under `steam/.runtime/` are ignored and should not be committed.
- Capture packs under docs are evidence; they are not default bootstrap context.
- Codex must not change product scope, gameplay contracts, visual direction, charity/monetization claims or ethical boundaries.
- Steam/Desktop must not absorb Browser Extension UX: no Chrome new-tab layout, search bar, sponsorship/ad block, rewarded ads, or extension-specific mechanics in Godot game.

---

## 9. Next likely implementation direction

Potential next implementation slice if Producer accepts the First Week / Day 2 direction:

```text
STEAM_DESKTOP__Codex_Brief__Second_Day_Return_And_Second_Order_v1.md
```

Expected scope from current design direction:

- `second_day_after_first_delivery` fixture;
- `second_warm_delivery_after_first_day` Workbench scenario;
- return moment state;
- second order availability;
- persistence of yesterday’s postcard, slippers and memory;
- packing note / curiosity question as visible but non-full-system;
- optional narrow second delivery completion if explicitly scoped.

Out of scope unless separately accepted:

- full First Week calendar;
- full House of Curiosity research tree;
- new dog recruitment;
- many orders/routes;
- mood/energy penalties;
- daily streaks;
- monetization;
- charity prompts;
- Browser Extension mechanics;
- production art pass;
- Steam platform integration.

Suggested reasoning level for Codex if assigned:

```text
очень высокий
```

---

## 10. Changelog

### 2026-07-07 — Shelter MCP Knowledge API v2

- Added current-context note that Shelter MCP now exposes deterministic Knowledge API v2 tools for decisions, open questions, roadmaps, latest handoff and task-specific reading context.

### 2026-07-07 — v1 created

- Created compressed Codex/dev current context.
- Marked completed briefs and old status history as do-not-read-by-default.
- Pointed to current First Day v3 evidence and First Week / Day 2 next implementation direction.
