# HANDOFF_INDEX — active transfers and fixed routing

Обновлено: 2026-07-22
Статус: active handoff index
Владелец: Project Manager / Knowledge Base Maintainer
Назначение: перечислять только нужные сейчас handoff и exact MCP compatibility row.

---

## 1. Latest relevant handoff by role / area

| Role / area | Latest useful handoff | Read when |
| --- | --- | --- |
| Codex / selected-H runtime lock | `../04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Selected_H_Visual_Shell_Runtime_Integration_And_Live_Matrix_v1.md` | active; implement only accepted art and live matrix |
| Codex / local Shelter MCP compatibility | `codex/2026-07-10__codex_handoff__chatgpt_work_local_mcp_migration.md` | only when validating the existing fixed MCP routing/setup history |

## 2. Do not read by default

Consumed handoff are removed after their accepted facts enter current
docs/decisions. Recover them with Git history; do not keep or recreate a catalog
of old session files.

## 3. Retention rule

The consumed Art handoff is removed after its accepted facts enter current docs
and the exact Codex brief. The MCP handoff remains only because the current MCP
test/catalog expects that exact indexed path; remove it only in a separately
approved MCP code-migration.
