# 05_DOCUMENTATION_GOVERNANCE — Current / Knowledge / History

Дата создания: 2026-07-07
Статус: active documentation governance
Владелец: Project Manager / Knowledge Base Maintainer
Уровень: project-wide
Назначение: зафиксировать правила против текущей и будущей раздутости документации Shelter.

---

## 0. Причина документа

Документация Shelter уже стала большой: product docs, decisions, roadmaps, briefs, Codex status, capture packs, review docs, handoff и archive/evidence материалы начали выглядеть для новых AI-сессий одинаково важными.

Главная проблема:

> Документов много, но новая сессия не понимает, какие документы являются текущей истиной, какие — справочником, а какие — историей.

Решение:

> Документация Shelter делится на Current Memory, Knowledge и History. Новые сессии читают Current Memory; Knowledge читается по задаче; History не читается по умолчанию.

---

## 1. Три слоя памяти Shelter

### 1.1 Layer A — Current Memory

Current Memory отвечает на вопрос:

> Что сейчас правда и что новой сессии нужно знать первым?

Это самый маленький слой. Он должен оставаться коротким и быстрым для чтения.

Примеры:

```text
00_START_HERE/BOOTSTRAP_CONTEXT.md
00_START_HERE/01_CURRENT_STATUS.md
02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__CURRENT_CONTEXT.md
04_DEVELOPMENT/CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md
docs/repo/status/CODEX_CURRENT_STATUS.md
```

Правила Current Memory:

- не хранить длинную историю;
- не хранить все доказательства;
- не дублировать все решения полностью;
- ссылаться на источники глубже;
- обновляться после major product/design/dev changes;
- быть первым входом для AI-сессий.

### 1.2 Layer B — Knowledge

Knowledge отвечает на вопрос:

> Какие решения, спецификации, правила и справочники являются источником истины по задаче?

Примеры:

```text
00_START_HERE/02_DECISIONS.md
00_START_HERE/03_PROJECT_PHILOSOPHY.md
00_START_HERE/04_SHELTER_STRESS_TESTS.md
02_PRODUCTS/**
03_DESIGN/**
04_DEVELOPMENT/active briefs and review docs
docs/repo/adr/**
docs/repo/dev/**
```

Правила Knowledge:

- читать по задаче, а не на каждом bootstrap;
- держать в актуальном состоянии;
- явно помечать superseded docs;
- не превращать в журнал событий;
- если документ стал только историей, вынести его из Knowledge-пути через `SUPERSEDED_MAP` или archive/read-policy.

### 1.3 Layer C — History

History отвечает на вопрос:

> Как мы к этому пришли и какие доказательства/артефакты были получены?

Примеры:

```text
06_SESSIONS_AND_HANDOFFS/**
old Codex status entries
old completed briefs
capture packs
review evidence
superseded docs
99_ARCHIVE/**
```

Правила History:

- не читать по умолчанию;
- использовать для audit, regression, archaeology, dispute resolution;
- не считать текущей истиной без проверки Current Memory / Knowledge;
- хранить как журнал, а не как источник текущего направления.

---

## 2. Default read policy

Новая серьёзная сессия читает в таком порядке:

```text
1. PROJECTS_RULES.md
2. AGENTS.md
3. README.md
4. 00_START_HERE/BOOTSTRAP_CONTEXT.md
5. role-doc
6. relevant current-context document
7. deep Knowledge docs only for the task
8. History only if needed for evidence/regression/archaeology
```

Если доступен Shelter MCP, предпочтительно использовать:

```text
read_shelter_bootstrap_context(role=..., area=..., max_bytes=...)
```

Этот инструмент должен отдавать Current Memory первым и не заставлять AI-сессию читать весь архив.

---

## 3. Документные статусы

Все новые важные документы должны по возможности иметь явный статус:

| Статус | Слой | Значение |
| --- | --- | --- |
| `active` | Knowledge | живой источник истины |
| `current-summary` | Current Memory | короткий актуальный вход |
| `reference` | Knowledge | справочник/deep doc по задаче |
| `evidence` | History | proof/capture/review artifacts |
| `handoff-history` | History | история сессии / передача контекста |
| `superseded` | History | заменён новым документом/решением |
| `archive` | History | исторический материал |

Минимальный metadata block:

```md
Дата: YYYY-MM-DD
Статус: active | current-summary | reference | evidence | handoff-history | superseded | archive
Владелец: Producer / Game Designer / Art Director / Codex / PM
Назначение: ...
```

---

## 4. Current Context rule

Для каждого активного направления должен быть один короткий current-context документ.

Примеры:

```text
STEAM_DESKTOP__CURRENT_CONTEXT.md
GAME_DESIGN__CURRENT_CONTEXT.md
ART_DIRECTION__CURRENT_CONTEXT.md
CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md
```

Future candidates:

```text
BROWSER_EXTENSION__CURRENT_CONTEXT.md
MOBILE__CURRENT_CONTEXT.md
```

Правило:

> Если сессии регулярно читают больше 3–5 deep docs, чтобы понять текущее состояние направления, нужен current-context документ.

Current-context документ должен содержать:

- current truth;
- latest accepted decisions;
- current scope;
- next best step;
- active docs;
- do-not-read-by-default docs;
- known caveats.

---

## 5. Roadmap rule

Roadmap — это рабочая очередь, а не исторический документ.

Roadmap должен отвечать на вопрос:

> Что мы делаем дальше и почему именно в таком порядке?

Roadmap не должен хранить полную историю всех выполненных задач. После выполнения задачи:

1. результат фиксируется в current-context / status / decision / review doc;
2. исторические детали уходят в handoff / Codex history / archive;
3. roadmap остаётся коротким и рабочим.

Если roadmap начал раздуваться историей, PM должен вынести history в handoff/archive и оставить только актуальную очередь.

---

## 6. CODEX_STATUS rule

`docs/repo/status/CODEX_STATUS.md` больше не должен быть bootstrap-документом.

Он может оставаться detailed chronological development log, но текущий вход для dev/Codex должен быть коротким.

Текущий short entry point:

```text
docs/repo/status/CODEX_CURRENT_STATUS.md
```

Related compressed context:

```text
docs/drive/Shelter/04_DEVELOPMENT/CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md
```

Правило:

- `CODEX_CURRENT_STATUS.md` отвечает на вопрос “что сейчас важно для разработки?”;
- `CODEX_STATUS.md` отвечает на вопрос “какие dev-события были в истории?”;
- старые записи `CODEX_STATUS.md` не читаются на bootstrap;
- monthly/yearly history split допустим позже, если файл станет слишком тяжёлым технически.

---

## 5.5 Handoff rule

Handoff documents are History, not Current Memory.

Default rule:

```text
Do not read all handoff on bootstrap.
Read only the latest relevant handoff when current-context docs are insufficient.
```

Use the handoff index before opening old session history:

```text
docs/drive/Shelter/06_SESSIONS_AND_HANDOFFS/HANDOFF_INDEX.md
```

If a handoff contains an accepted decision, that decision must also be reflected in `02_DECISIONS.md`, current-context docs, product docs or status docs.

---

## 7. Knowledge Garbage Collector

После каждой большой волны задач PM / Knowledge Base Maintainer должен сделать Knowledge GC.

Большая волна — это:

- product decision;
- завершение roadmap slice;
- большой Codex implementation pass;
- visual review / capture pack;
- design branch completion;
- появление нового current-context;
- заметное увеличение docs/history/evidence.

Knowledge GC задаёт вопросы:

```text
Что стало Current Memory?
Что стало Knowledge?
Что стало History?
Что стало superseded?
Какие документы больше не читать на bootstrap?
Какой current-context нужно обновить?
Нужно ли обновить SUPERSEDED_MAP?
Нужно ли обновить 01_CURRENT_STATUS?
Нужно ли создать/обновить handoff?
```

Результат GC — маленький diff, а не массовая перестройка без причины.

---

## 8. Что не делать

Не нужно:

- удалять историю ради чистоты;
- массово переносить все старые файлы без явной пользы;
- делать один огромный master document;
- заставлять AI читать все decisions/history на каждую задачу;
- считать capture packs текущими specs;
- держать важные решения только в handoff;
- использовать `CODEX_STATUS.md` как единственный dev-status entry point.

---

## 9. MCP Knowledge Layer direction

С появлением Shelter MCP задача сжатия документации меняется.

Не нужно бесконечно ужимать все документы вручную. Нужно оптимизировать маршруты чтения.

MCP должен развиваться как safe knowledge access layer:

```text
read_shelter_bootstrap_context(role, area)
future: find_current_context(area)
future: explain_superseded(path)
future: list_active_docs(area)
future: classify_docs(root)
future: knowledge_gc_report(area)
```

Правило:

> Документация может расти как History/Knowledge, но AI-сессии должны получать маленький актуальный срез через Current Memory и MCP.

---

## 10. Changelog

### 2026-07-07 — role current contexts created

- Moved `GAME_DESIGN__CURRENT_CONTEXT.md` and `ART_DIRECTION__CURRENT_CONTEXT.md` from future candidates to current-context examples.
- Browser Extension and Mobile current-context docs remain future candidates.

### 2026-07-07 — handoff index rule

- Added handoff rule: handoff documents are History, not Current Memory.
- Added `06_SESSIONS_AND_HANDOFFS/HANDOFF_INDEX.md` as the entry point before opening old session history.
- Clarified that accepted decisions from handoff must be reflected in decision/current/product/status docs.

### 2026-07-07 — v1 created

- Зафиксирована модель Current Memory / Knowledge / History.
- Зафиксирован Knowledge GC как регулярная PM-процедура.
- Зафиксировано, что `CODEX_STATUS.md` — detailed history log, а не bootstrap entry point.
- Зафиксировано направление MCP Knowledge Layer.
