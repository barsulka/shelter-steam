# EVIDENCE_READ_POLICY — Shelter History / Capture Packs

Дата создания: 2026-07-07
Статус: active documentation governance
Владелец: Project Manager / Knowledge Base Maintainer
Назначение: центральная политика чтения evidence/capture/archive документов, если сами исторические файлы нельзя или нецелесообразно массово редактировать.

---

## 0. Main rule

Evidence, capture packs, old review packs, old completed briefs and archive docs are **History**, not Current Memory.

Default rule:

```text
Do not read evidence/history on bootstrap.
Read evidence/history only for proof, review, regression, audit, archaeology or dispute resolution.
```

For current project state use:

```text
docs/drive/Shelter/00_START_HERE/BOOTSTRAP_CONTEXT.md
docs/drive/Shelter/00_START_HERE/01_CURRENT_STATUS.md
docs/drive/Shelter/00_START_HERE/05_DOCUMENTATION_GOVERNANCE.md
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__CURRENT_CONTEXT.md
docs/drive/Shelter/04_DEVELOPMENT/CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md
docs/repo/status/CODEX_CURRENT_STATUS.md
```

---

## 1. Capture packs

All directories under:

```text
docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/
```

are evidence/history unless a current-context document explicitly says otherwise.

They can be used for:

- visual proof;
- state proof;
- regression comparison;
- Art Director / UX review;
- implementation acceptance evidence;
- historical reconstruction.

They should not be used as first-entry context for a new session.

---

## 2. Current First Day evidence

For First Day MVP visual-language evidence, use latest v3 first:

```text
docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v3/
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Art_UX_Review__First_Day_MVP_v3.md
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__First_Day_MVP_Lock_And_Next_Scope_Decision_v1.md
```

Older packs:

```text
STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v1/
STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v2/
```

are regression/history only.

---

## 3. Vertical Slice Art QA packs

These packs are evidence/history only:

```text
STEAM_VERTICAL_SLICE_ART_QA_CAPTURE_v1/
STEAM_VERTICAL_SLICE_ART_QA_CAPTURE_v2/
```

Use them only when investigating earlier visual QA, regression or historical implementation context.

They are not the current visual-language source for First Day.

---

## 4. Semantic asset packs

Semantic asset packs under deliverables are reference/evidence. They may inform implementation or taxonomy, but they are not current product state by themselves.

Before reading them, check:

```text
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__CURRENT_CONTEXT.md
docs/drive/Shelter/04_DEVELOPMENT/CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md
```

---

## 5. Archive docs

Files under:

```text
docs/drive/Shelter/99_ARCHIVE/
```

are archive/history by default.

They are not active specs unless a current-context or decision document explicitly revives them.

Known example:

```text
STEAM_DESKTOP__Codex_Brief__Systems_Simulator_v0__SUPERSEDED_BY_GODOT_STATE_CONNECTOR.md
```

This is superseded by D-018/D-019 and the Godot State Connector / Workbench-over-live-Godot direction.

---

## 6. Completed Codex briefs

Completed Codex briefs in:

```text
docs/drive/Shelter/04_DEVELOPMENT/
```

are History after completion unless explicitly marked active/prepared.

For current implementation state, prefer:

```text
docs/repo/status/CODEX_CURRENT_STATUS.md
docs/drive/Shelter/04_DEVELOPMENT/CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md
```

For detailed history, use:

```text
docs/repo/status/CODEX_STATUS.md
```

---

## 7. Changelog

### 2026-07-07 — v1 created

- Added central read policy for capture packs, evidence, old reviews, archive docs and completed briefs.
- Clarified that historical deliverables should not be read during bootstrap.
- Pointed First Day evidence to v3 as the latest current proof pack.
