# 05_DOCUMENTATION_GOVERNANCE — Current truth in checkout, history in Git

Дата создания: 2026-07-07
Обновлено: 2026-07-22
Статус: active documentation governance
Владелец: Project Manager / Knowledge Base Maintainer
Назначение: держать checkout Shelter коротким, актуальным и непротиворечивым; superseded/history восстанавливать через Git history.

---

## 0. Главный принцип

В рабочем checkout остаётся только то, что нужно агенту сейчас:

```text
Current Memory — короткая текущая правда и маршрутизация.
Knowledge — действующие решения, contracts, references и roadmaps по задаче.
Required Evidence — только байты/пути, которые реально нужны validator/hash/regression contract.
Git history — superseded, completed и обычная история проекта.
```

Исторический Markdown не хранится «на всякий случай». Если текущие факты уже
перенесены в канонический документ, ссылки обновлены, а validator/runtime не
зависит от файла, superseded/history-файл удаляется из checkout. Его версия
остаётся восстановимой через Git.

## 1. Что обязано остаться

### 1.1 Authority и routing

- `PROJECTS_RULES.md`, `AGENTS.md`, relevant subproject `AGENTS.md`/`README.md`;
- role docs, bootstrap/current-context, decision/open-question/governance docs;
- MCP-required source-derived routes, пока код MCP требует точные пути;
- current roadmap и active handoff/brief, необходимые следующей сессии.

### 1.2 Действующая Knowledge

Остаются документы, которые задают текущий product/game/art/technical contract
или действительно используются текущей/ближайшей работой. Completed roadmap и
brief не становятся Knowledge только из-за подробности.

### 1.3 Узкие исключения evidence

Исторический материал может остаться только при доказанной зависимости:

- Accepted ADR;
- immutable contract с byte/hash pin;
- source/evidence path, который проверяет текущий validator;
- sealed pack и его hash ledger;
- regression contract, который реально вызывается действующим кодом/QA route;
- compatibility path, который нельзя удалить без отдельной code-migration wave.

Для каждого исключения должны быть известны конкретный consumer и причина.
`EVIDENCE_READ_POLICY.md` перечисляет активные классы исключений.

## 2. Default read policy

Routine-чтение идёт в порядке `Current Memory → task-specific Knowledge →
Required Evidence только для exact evidence/regression work`. Superseded/history
не является default read surface и восстанавливается из Git только по доказанной
необходимости.

### Что удаляется

Удаляется после inbound-reference/dependency audit:

- superseded product/design docs;
- completed Codex briefs и reviews без текущего consumer;
- старые roadmaps, snapshots и session briefs;
- handoff, уже отражённые в current docs/decisions;
- длинные chronological status logs;
- duplicate dashboards/catalogs;
- preview/R&D notes, которые не являются принятой authority или regression input.

Нельзя заменять удаление новым archive-файлом или огромным `SUPERSEDED_MAP`.
Исторический поиск начинается с `git log -- <path>` и `git show <rev>:<path>`.

## 3. Current Memory

Current Memory обязана быть короткой и атомарно синхронизированной:

```text
BOOTSTRAP_CONTEXT.md
01_CURRENT_STATUS.md
STEAM_DESKTOP__CURRENT_CONTEXT.md
GAME_DESIGN__CURRENT_CONTEXT.md
ART_DIRECTION__CURRENT_CONTEXT.md
CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md
docs/repo/status/CODEX_CURRENT_STATUS.md
```

Правила:

- один current truth без override сверху и stale блока снизу;
- никаких длинных changelog;
- completed milestone — одна строка baseline, не активный маршрут;
- next step, active roadmap и acceptance owner совпадают во всех current docs;
- human visual acceptance нельзя выводить из automatic checks.

Если healthy `shelter_context_bundle(...)` доступен, он остаётся routine
source-derived route. Direct source read остаётся authority/exact fallback и
обязателен перед изменением source.

## 4. Roadmap и handoff

Roadmap содержит только текущую очередь, зависимости, gates и out-of-scope.
Completed task удаляется из подробной очереди после переноса результата в
current status/decision/contract.

Handoff — временный маршрут между активными сессиями. После потребления и
переноса результата в канонические документы он удаляется; Git сохраняет
историю. `HANDOFF_INDEX.md` перечисляет только реально нужные текущие передачи и
compatibility rows, требуемые source-derived MCP.

## 5. Status и changelog

`CODEX_CURRENT_STATUS.md` — единственный текущий dev-status.

`CODEX_STATUS.md` сохраняется коротким compatibility stub, потому что действующий
D-024 capture runner читает exact path. Steam authority упоминает его только как
запрет на новые записи; детальная dev-история читается через Git history текущего
status-файла и удалённых briefs.

Changelog в живом документе хранит только последнее существенное изменение,
если без него непонятна текущая authority. Остальная история — Git.

## 6. Knowledge GC — обязательная процедура

После крупного decision/design/dev pass PM:

1. определяет канонический current truth;
2. обновляет решения/current-context/roadmap;
3. находит inbound Markdown и non-Markdown references;
4. проверяет validator/hash/seal dependencies;
5. удаляет superseded/history без consumer;
6. обновляет оставшиеся ссылки и MCP-required metadata;
7. запускает link scan, contradiction scan, parser/tests при затронутых routes,
   `git diff --check` и counts before/after;
8. передаёт diff независимому verifier; автор не выдаёт себе acceptance.

При неожиданной параллельной записи в своём scope PM останавливается и не
перетирает изменения.

## 7. Запрещено

- хранить историю только потому, что она может когда-нибудь пригодиться;
- создавать статические duplicate dashboard/catalog;
- переписывать hash-pinned bytes ради косметической чистоты;
- удалять Accepted ADR;
- объявлять visual `PASS` без прямого решения пользователя;
- использовать History как current authority;
- оставлять broken links на удалённые файлы вместо обновления consumer.

## 9. Shelter MCP knowledge boundary

До отдельной MCP code-migration wave сохраняются точные source paths:

```text
KNOWLEDGE_BASE_ROADMAP.md
KNOWLEDGE_BASE_POLISH_ROADMAP.md
STEAM_DESKTOP__Game_Design_Roadmap_v2.md
HANDOFF_INDEX.md
codex/2026-07-10__codex_handoff__chatgpt_work_local_mcp_migration.md
```

Их наличие — routing compatibility, не разрешение снова раздувать документы.

## 10. Changelog

### 2026-07-21 — Git-history retention model

- Superseded/history Markdown переведён из checkout-retention в Git history.
- Зафиксированы узкие исключения для authority, Accepted ADR,
  validator/hash/seal-required evidence и реально используемых regressions.
- Запрещены duplicate dashboards и безусловное сохранение completed briefs,
  handoff и chronological status logs.
