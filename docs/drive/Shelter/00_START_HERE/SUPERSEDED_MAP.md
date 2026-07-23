# SUPERSEDED_MAP — current replacements and Git-history lookup

Обновлено: 2026-07-21
Статус: active current-summary
Владелец: Project Manager / Knowledge Base Maintainer
Назначение: указывать канонический текущий источник без хранения списка удалённой истории.

---

## 1. Current entry points

```text
BOOTSTRAP_CONTEXT.md
01_CURRENT_STATUS.md
02_DECISIONS.md
05_DOCUMENTATION_GOVERNANCE.md
../02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__CURRENT_CONTEXT.md
../02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Game_Design_Roadmap_v2.md
../03_DESIGN/ART_DIRECTION__CURRENT_CONTEXT.md
../04_DEVELOPMENT/CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md
docs/repo/status/CODEX_CURRENT_STATUS.md
```

## 2. Superseded / do not read by default

| Старый / тяжёлый материал | Current source | Status | Action |
| --- | --- | --- | --- |
| First 48 Hours / Day 1 / Day 2 active roadmaps and briefs | `STEAM_DESKTOP__Game_Design_Roadmap_v2.md` | future/regression only | use Git history only |
| completed Codex briefs/reviews without validator consumer | current implementation/status + Git | history | removed from checkout |
| old role handoff | current-context/decision docs | history | removed after incorporation |
| long `CODEX_STATUS.md` chronology | `CODEX_CURRENT_STATUS.md` | history | Git history; exact-path no-write stub only |
| preview/R&D docs without current authority | current Art roadmap | history | removed from checkout |
| `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v1/README.md` | `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v3/README.md` | superseded-by-v3 / MCP fixed regression projection | retain only v3 README/manifest until MCP test migration |

This table stays categorical. Do not grow it into a deleted-file catalog: Git is
the catalog.

## 3. Latest evidence

Current evidence routes are not historical dashboards. Use the exact retained
classes in `EVIDENCE_READ_POLICY.md`; the current visual gate is the user-reviewed
Visual Shell Lock sequence, not an older capture pack.

## 4. Historical lookup

```sh
git log --all -- <path>
git show <revision>:<path>
```

History must not be restored into checkout unless a current task proves a new
authority/validator/regression need.

## 5. Retained exceptions

See `EVIDENCE_READ_POLICY.md` for exact retained hash/validator/ADR/routing
classes. Their presence does not make them current product direction.
