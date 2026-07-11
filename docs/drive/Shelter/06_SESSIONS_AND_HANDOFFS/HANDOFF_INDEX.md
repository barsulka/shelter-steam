# HANDOFF_INDEX — Shelter

Дата создания: 2026-07-07
Обновлено: 2026-07-12
Статус: active handoff index / current-summary for history layer
Владелец: Project Manager / Knowledge Base Maintainer
Назначение: указывать, какие handoff/RFC документы читать последними по роли/области, не заставляя новые сессии перечитывать всю историю.

---

## 0. Read policy

Handoff documents are History.

Default rule:

```text
Do not read all handoff on bootstrap.
Read only the latest relevant handoff when current-context docs are insufficient.
```

Before opening old handoff, read:

```text
docs/drive/Shelter/00_START_HERE/BOOTSTRAP_CONTEXT.md
docs/drive/Shelter/00_START_HERE/01_CURRENT_STATUS.md
docs/drive/Shelter/00_START_HERE/05_DOCUMENTATION_GOVERNANCE.md
docs/drive/Shelter/00_START_HERE/EVIDENCE_READ_POLICY.md
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__CURRENT_CONTEXT.md
```

---

## 1. Latest relevant handoff by role / area

| Role / area | Latest useful handoff | Read when |
| --- | --- | --- |
| Art Direction / world and room preview R&D | `design/2026-07-12__art_direction_handoff__world_room_preview_planning_wave.md` | reviewing Sheet A/B evidence boundaries, planning a world/room proof or checking why preview assets are not production-approved |
| Producer / PM / Day 2 scope lock | `producer/2026-07-11__producer_pm_handoff__day_2_scope_lock_and_work_wave.md` | continuing D-022 implementation/review or reconstructing the cross-role scope decision |
| Codex / local Shelter MCP | `codex/2026-07-10__codex_handoff__chatgpt_work_local_mcp_migration.md` | continuing local MCP implementation or validating project-scoped setup |
| Producer / PM / Knowledge Base Phase 2 cleanup | `producer/2026-07-07__producer_pm_handoff__knowledge_base_phase_2_cleanup.md` | continuing after decisions/roadmaps/handoff/current-context cleanup |
| Producer / PM / docs governance | `producer/2026-07-07__producer_handoff__documentation_governance_and_gc.md` | reviewing original documentation governance / Knowledge GC decision |
| Producer / PM / documentation compression | `producer/2026-07-07__producer_handoff__documentation_compression_bootstrap_layer.md` | investigating how bootstrap/current-context layer was created |
| Producer / project philosophy | `producer/2026-06-30__producer_handoff__project_philosophy.md` | reviewing D-020 origin / philosophy decision history |
| Producer / Game Systems Workbench | `producer/2026-06-30__producer_handoff__game_systems_workbench.md` | reviewing Workbench-over-Godot transition history |
| Game Design / Steam runtime capture roadmap | `design/2026-07-01__game_design_handoff__steam_runtime_capture_roadmap.md` | reconstructing the path into runtime capture / First Day evidence |
| Design / Steam Vertical Slice Art QA | `design/2026-06-29__design_handoff__steam_vertical_slice_art_qa.md` | investigating early visual QA before First Day v3 |
| Design / First Day MVP | `design/2026-06-28__game_design_handoff__steam_first_day_mvp.md` | reconstructing early First Day MVP design history |
| Cross-role / Codex boundaries | `cross_role_sessions/2026-06-29__cross_role_rfc__codex_task_boundaries_steam_vertical_slice.md` | checking the original RFC behind D-016 |

---

## 2. Do not read by default

These are useful history, but should not be read during normal bootstrap:

```text
design/2026-06-25__design_handoff__d011_cozy_modular_diorama.md
design/2026-06-25__design_handoff__steam_overlay_v1_prompt_system.md
producer/2026-06-24__producer_handoff__steam_browser_core_loops.md
producer/2026-06-25__producer_handoff__shared_world_resource_trips.md
producer/2026-06-29__producer_handoff__codex_boundaries_synthesis.md
producer/2026-06-29__producer_handoff__codex_brief_assignment_rule.md
producer/2026-06-29__producer_handoff__collaboration_protocol_and_codex_rfc.md
producer/2026-06-29__producer_handoff__godot_state_connector_replaces_simulator.md
producer/2026-06-29__producer_handoff__systems_roadmap_pivot.md
producer/2026-06-29__producer_pm_handoff__role_boundaries.md
```

Use them only for evidence, archaeology, dispute resolution or when a current doc explicitly points to them.

---

## 3. Handoff classification

| Path | Layer | Status |
| --- | --- | --- |
| `cross_role_sessions/**` | History | RFC / cross-role history |
| `design/**` | History | design handoff history |
| `producer/**` | History | producer/PM handoff history |

No handoff is Current Memory by itself.

If a handoff contains an important accepted decision, the decision must also exist in:

```text
00_START_HERE/02_DECISIONS.md
product docs
current-context docs
status docs
```

---

## 4. Changelog

### 2026-07-12 — world/room preview R&D handoff

- Added the closed Sheet A/B Art planning and preview wave as the latest Art Direction world/room handoff.
- Kept its external bundles in History/evidence rather than Current Memory or production Knowledge.

### 2026-07-11 — Day 2 scope-lock handoff

- Added the D-022 cross-role handoff as the latest Producer/PM entry for Day 2 implementation and review.

### 2026-07-10 — ChatGPT Work migration handoff

- Added the D-021 workflow/PM migration handoff as the latest entry for local Work/Codex and MCP transition work.

### 2026-07-07 — Phase 2 cleanup handoff added

- Added `producer/2026-07-07__producer_pm_handoff__knowledge_base_phase_2_cleanup.md` as the latest Producer/PM handoff for Knowledge Base cleanup.
- Kept original documentation governance handoff as background history.

### 2026-07-07 — v1 created

- Added latest-handoff map for Producer/PM, Game Design, Art/UX and cross-role contexts.
- Clarified that handoff is History and should not be read on bootstrap by default.
- Preserved all handoff files without moving or rewriting them.
