# SUPERSEDED_MAP — Shelter document compression map

Дата создания: 2026-07-07
Статус: active current-summary / documentation governance
Владелец: Project Manager / Knowledge Base Maintainer
Назначение: явно отделить актуальные документы от исторических, superseded и evidence-документов, чтобы новые сессии не перечитывали устаревшие материалы.

---

## 0. Правило чтения

Документация Shelter делится на три слоя:

```text
Current Memory — короткая текущая правда для bootstrap.
Knowledge — активные решения, specs, references and ADRs по задаче.
History — handoff, completed briefs, capture packs, evidence and long logs.
```

Документы Shelter также получают статус:

| Статус | Слой | Значение | Читать на bootstrap? |
| --- | --- | --- | --- |
| `active` | Knowledge | живой источник истины | да, если релевантно |
| `current-summary` | Current Memory | сжатый входной контекст | да |
| `reference` | Knowledge | справочник / deep doc | только по задаче |
| `evidence` | History | proof, captures, manifests, logs | нет, только для проверки |
| `handoff-history` | History | история сессий | только последний релевантный |
| `superseded` | History | заменено новым документом / решением | нет |
| `archive` | History | исторический материал | нет |

Если документ не размечен явно, определяй его статус по этому map, `05_DOCUMENTATION_GOVERNANCE.md` и актуальному current-context документу.

---

## 1. Current entry points

Эти документы читать первыми вместо длинной истории:

| Документ | Статус | Слой | Роль |
| --- | --- | --- | --- |
| `00_START_HERE/BOOTSTRAP_CONTEXT.md` | current-summary | Current Memory | общий вход |
| `00_START_HERE/01_CURRENT_STATUS.md` | active | Current Memory | текущая картина проекта |
| `00_START_HERE/02_DECISIONS.md` | active | Knowledge | принятые решения |
| `00_START_HERE/03_PROJECT_PHILOSOPHY.md` | active | Knowledge | философия / constitution |
| `00_START_HERE/03_OPEN_QUESTIONS.md` | active | Knowledge | живые вопросы |
| `00_START_HERE/05_DOCUMENTATION_GOVERNANCE.md` | active | Knowledge | правила документации и GC |
| `02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__CURRENT_CONTEXT.md` | current-summary | Current Memory | Steam/Desktop текущий контекст |
| `04_DEVELOPMENT/CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md` | current-summary | Current Memory | текущий dev/Codex контекст |
| `docs/repo/status/CODEX_CURRENT_STATUS.md` | current-summary | Current Memory | короткий dev-status |

---

## 2. Superseded / do not read by default

| Старый / тяжёлый материал | Актуальный источник | Статус | Что делать |
| --- | --- | --- | --- |
| `99_ARCHIVE/STEAM_DESKTOP__Codex_Brief__Systems_Simulator_v0__SUPERSEDED_BY_GODOT_STATE_CONNECTOR.md` | D-018, D-019, `Godot_State_Connector_v0`, Workbench over live Godot | superseded | не читать, standalone simulator отменён |
| `STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v1/` | `STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v3/` + Art/UX Review v3 | evidence / superseded-by-v3 | не читать без regression-задачи |
| `STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v2/` | `STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v3/` + Art/UX Review v3 | evidence / superseded-by-v3 | не читать без regression-задачи |
| `STEAM_VERTICAL_SLICE_ART_QA_CAPTURE_v1/` | First Day MVP v3 evidence and reviews | evidence / historical | не читать при обычном входе |
| `STEAM_VERTICAL_SLICE_ART_QA_CAPTURE_v2/` | First Day MVP v3 evidence and reviews | evidence / historical | не читать при обычном входе |
| Старые Codex brief-файлы для уже выполненных dev tasks | `CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md` + latest `CODEX_STATUS.md` entry | handoff-history / evidence | читать только при расследовании реализации |
| Старые handoff’ы Producer/Game Designer/Art Director | latest relevant handoff + current-context docs | handoff-history | читать только последний релевантный |
| Длинные старые секции `CODEX_STATUS.md` | latest top entry + `CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md` | history | не использовать как bootstrap целиком |
| `STEAM_DESKTOP__Game_Design_Roadmap_v1.md` | `STEAM_DESKTOP__Game_Design_Roadmap_v2.md`, First Day lock, First Week direction | reference / partially superseded | читать только если нужна история roadmap |
| `STEAM_DESKTOP__Game_Systems_Roadmap_v1.remaining_snapshot.md` | актуальные roadmap / lock docs | archive/reference | не читать по умолчанию |
| `STEAM_DESKTOP__First_Day_MVP_v0.md` | `STEAM_DESKTOP__First_Day_MVP_v1.md` + First Day lock | superseded/reference | читать только для истории изменения MVP |

---

## 3. Latest evidence to use when evidence is needed

Для First Day MVP не собирать proof заново из v1/v2. Использовать:

```text
docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v3/README.md
docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v3/CAPTURE_MANIFEST_v3.md
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Art_UX_Review__First_Day_MVP_v3.md
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__First_Day_MVP_Lock_And_Next_Scope_Decision_v1.md
```

Для runtime/state доказательств использовать latest `CODEX_STATUS.md` entry и соответствующие runtime review docs, а не весь исторический лог.

---

## 4. How to mark future docs

Новые документы должны по возможности иметь вверху короткий metadata block:

```md
Дата: YYYY-MM-DD
Статус: active | current-summary | reference | evidence | handoff-history | superseded | archive
Владелец: Producer / Game Designer / Art Director / Codex / PM
Назначение: ...
```

Для evidence/capture docs добавлять:

```md
Read policy: do not read on bootstrap; use only for proof/review/regression.
Superseded by: <path or none>
```

Для superseded docs добавлять:

```md
Status: superseded
Superseded by: <path>
Do not use for new decisions.
```

---

## 5. Compression rule

Не удалять исторические документы без отдельного решения. Сжимать через:

1. current-summary docs;
2. explicit superseded map;
3. current status refresh;
4. latest relevant handoff;
5. archive/evidence read-policy.

Цель: новая сессия не должна восстанавливать проект через весь археологический слой Codex/captures/handoffs.

---

## 6. Changelog

### 2026-07-07 — documentation governance alignment

- Added Current Memory / Knowledge / History layer model.
- Added `05_DOCUMENTATION_GOVERNANCE.md` and `CODEX_CURRENT_STATUS.md` to current entry points.
- Clarified status-to-layer mapping.

### 2026-07-07 — v1 created

- Added first explicit document compression map.
- Marked old capture packs, simulator brief and historical Codex logs as do-not-read-by-default.
- Established document status vocabulary for future cleanup.
