# Project Rules — Shelter

## 0. ChatGPT Work / Codex local-project bootstrap

Основная рабочая поверхность Shelter — локальный проект ChatGPT desktop, открытый на корне этого репозитория. Ролевые сессии работают в ChatGPT Work, технические задачи — в Codex; обе поверхности используют один checkout и локальные документы проекта.

Интерфейсные настройки проекта не должны дублировать правила репозитория.

The canonical detailed rules live in the local repository:

```text
PROJECTS_RULES.md
AGENTS.md
docs/drive/Shelter/00_START_HERE/BOOTSTRAP_CONTEXT.md
docs/drive/Shelter/00_START_HERE/05_DOCUMENTATION_GOVERNANCE.md
docs/drive/Shelter/00_START_HERE/CURRENT_CONTEXT_TEMPLATE.md
```

Ты работаешь внутри проекта `Группа приложений "Shelter"`.

## 1. Главное правило контекста

Никогда не делай вид, что знаешь проект по памяти.

Любой AI обязан использовать доступный ему механизм доступа к локальной документации проекта. Если такого механизма нет, он обязан остановиться и запросить у пользователя доступ.

Конкретные правила доступа:

- ChatGPT Work и Codex в локальном проекте ChatGPT desktop читают и изменяют документы напрямую через файловую систему текущего checkout репозитория Shelter.
- Codex CLI / IDE также работают с файлами текущего checkout напрямую.
- Когда Shelter MCP доступен и его source-derived context health равен `current`, routine bootstrap и первичная context routing начинаются с компактного `shelter_context_bundle(role, area, task, max_bytes)`. Это дешёвый детерминированный мост к каноническим локальным документам, а не отдельная память проекта.
- Прямой файловый доступ к локальным source documents остаётся обязательной точной проверкой/fallback: при недоступном или non-current MCP, `fallback`, omission/truncation, конфликте или parser failure, для exact brief / Accepted ADR / normative contract, а также при чтении документа, который сессия собирается изменять.
- Shelter MCP не является generic файловым bridge. Помимо source-derived bounded context routing он используется как локальный domain-specific runtime / inspection adapter для Workbench и Godot connector/control.
- Hosted/web-сессия без доступа к локальному checkout не должна делать вид, что видит проект. Если локальный доступ недоступен, она останавливается и просит открыть Shelter как local project в ChatGPT desktop или предоставить другой явный механизм доступа.
- Другие AI-инструменты используют свой доступ к локальным файлам проекта. Если инструмент не может открыть локальные документы, он обязан остановиться и попросить пользователя дать доступ.

Документы проекта — источник фактов. Чат — место обсуждения. Решение становится долговременным только после записи в документы.

## 2. Суть проекта

Shelter — группа добрых приложений и игр вокруг темы помощи собакам и приютам. Цель проекта — сделать простые, приятные и затягивающие продукты, в которые пользователям хочется регулярно возвращаться, а благотворительная механика, донаты, подписки и рекламная польза воспринимаются как естественная часть заботы о собаках, а не как навязчивая просьба о деньгах.

В проекте предполагаются три продукта:

1. Desktop/Steam idle game для Windows/macOS.
2. Mobile idle/farm game.
3. Browser extension: “посмотри рекламу — накорми собак”.

Проект добрый, спокойный и тёплый. Не предлагать бои, PvP, арены, боссов, гачу, монстров, агрессивный FOMO, манипулятивные dark patterns и механики “выжима денег”. Монетизация должна быть честной, прозрачной и этически совместимой с благотворительностью.

## 3. Источники истины

Основной рабочий источник правды — локальный Git-репозиторий Shelter.

Перед серьёзным ответом, новой большой задачей, восстановлением после перегрева контекста или сменой роли восстанавливай состояние через локальные документы текущего checkout.

Когда source-derived Shelter MCP context bridge реализован, подключён и сообщает `health=current`, routine bootstrap/context routing по умолчанию начинается с:

```text
shelter_context_bundle(role, area, task, max_bytes)
```

Локальные source documents остаются authority. MCP bundle должен быть детерминированной source-derived проекцией и не может содержать вручную поддерживаемую вторую память текущих фактов.

Прямое чтение source docs обязательно, если:

- MCP недоступен, `health` не `current` или bundle требует `fallback`;
- нужный блок omitted/truncated;
- нужен exact brief, Accepted ADR или normative contract;
- обнаружен конфликт, malformed source или parser failure;
- сессия изменяет сам source document.

Для bounded verification/fallback используй порядок:

1. `PROJECTS_RULES.md` — правила проекта для ChatGPT-сессий и других AI-ролей.
2. `AGENTS.md` — правила работы агентов внутри репозитория.
3. `README.md` — карта монорепозитория.
4. `docs/drive/Shelter/00_START_HERE/BOOTSTRAP_CONTEXT.md` — compressed entry point.
5. Relevant role doc из `docs/drive/Shelter/00_START_HERE/000_ROLE_*.md`.
6. Relevant current-context document.
7. Deep Knowledge docs только по задаче.
8. History / evidence только если нужны evidence, regression или archaeology.

Для разработки:

```text
docs/repo/status/CODEX_CURRENT_STATUS.md — короткий текущий dev-status.
docs/drive/Shelter/04_DEVELOPMENT/CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md — compressed implementation context.
docs/repo/status/CODEX_STATUS.md — fixed-path no-write compatibility stub; current state lives only in CODEX_CURRENT_STATUS.md.
docs/repo/adr/README.md — индекс действующих архитектурных решений.
```

Для технической реализации Codex обязан проверить `docs/repo/adr/README.md` и прочитать все релевантные `Accepted` ADR перед изменением кода, архитектуры, runtime-контрактов, save/snapshot/connector-схем, платформенного поведения или dev tooling. Если непонятно, релевантен ли ADR, считай его релевантным и прочитай.

Если документы противоречат друг другу, не угадывай. Сообщи о конфликте и предложи, какой документ нужно обновить. Если чатовый контекст противоречит документам, по умолчанию доверяй документам.

Для защиты от раздувания документации используй:

```text
docs/drive/Shelter/00_START_HERE/05_DOCUMENTATION_GOVERNANCE.md
docs/drive/Shelter/00_START_HERE/CURRENT_CONTEXT_TEMPLATE.md
docs/drive/Shelter/00_START_HERE/SUPERSEDED_MAP.md
docs/drive/Shelter/00_START_HERE/EVIDENCE_READ_POLICY.md
docs/drive/Shelter/06_SESSIONS_AND_HANDOFFS/HANDOFF_INDEX.md
```

Default reading model:

```text
Current Memory first.
Knowledge by task.
History only for evidence / regression / archaeology.
```

Superseded/history Markdown по умолчанию удаляется из checkout и остаётся в Git
history. В checkout сохраняются только Accepted ADR, обязательный authority/routing,
validator/hash-required immutable evidence и действительно используемые regression
contracts. Не восстанавливай проект через старые briefs, capture packs, handoff или
long logs, если exact evidence/regression task не требует сохранённого исключения.

Не говори, что документ прочитан, если ты не открывал его через доступный тебе механизм доступа к локальным файлам проекта и пользователь не предоставлял его содержимое в чате.
## 4. Роли и зоны ответственности

см. блок [Project Roles](#project-roles)

## 5. Логи и handoff

После каждой длинной сессии, исследования, продуктового решения, дизайн-итерации или dev-задачи нужно подготовить краткий handoff.

Формат handoff:

- дата;
- роль сессии;
- что делали;
- ключевые выводы;
- принятые решения;
- открытые вопросы;
- ссылки/источники;
- что обновить в документах;
- следующий лучший шаг.

Если есть доступ к локальным файлам проекта и пользователь просит обновить документы — обнови документ напрямую. Если доступа нет — остановись и попроси пользователя дать доступ. Если пользователь просит только подготовить текст без записи — выдай готовый блок для вставки.

## 6. Старт новой сессии после перегрева контекста

Если пользователь говорит, что продолжает работу в новой сессии, потому что в старой перегрет контекст, сначала восстанови состояние проекта через source-derived Shelter MCP context bundle, когда он доступен и `health=current`.

Предпочтительно:

```text
shelter_context_bundle(role, area, task, max_bytes)
```

Затем открой только документы, которые нужны для exact authority, проверки, редактирования или объявленного fallback.

Если context bundle ещё не реализован, MCP недоступен/non-current, вернул fallback, omissions/truncation или parser/conflict error, читай вручную:

1. `PROJECTS_RULES.md`
2. `AGENTS.md`
3. `README.md`
4. `docs/drive/Shelter/00_START_HERE/BOOTSTRAP_CONTEXT.md`
5. `docs/repo/status/CODEX_CURRENT_STATUS.md`, если задача связана с разработкой
6. relevant role doc
7. relevant current-context document
8. `docs/drive/Shelter/06_SESSIONS_AND_HANDOFFS/HANDOFF_INDEX.md`, затем последний релевантный handoff только если current-context недостаточен
9. релевантные Knowledge docs в `docs/`, `steam/` или `chrome` по задаче

Затем кратко скажи, что восстановлено, какие документы или MCP tools были использованы, и продолжай работу.
## 7. Правила фактов и исследований

Для текущих фактов, рынка, цен, API, платформенных правил, Steam/App Store/Chrome Web Store, законодательства, благотворительности, рекламы, платежей и конкурентов нужно использовать web research и давать источники.

Не выдумывать юридические, финансовые и благотворительные утверждения. Если факт важен для запуска или денег, отмечать уровень уверенности и необходимость проверки специалистом.

## 8. Текущие продуктовые ограничения

- Проект про собак, приюты, заботу, помощь и регулярное возвращение пользователя.
- Игра должна быть простой, но затягивающей.
- Не использовать боевые механики, PvP, боссов, монстров, арены и агрессивную соревновательность.
- Desktop-версия может использовать идею минималистичной always-on-top полоски/поля.
- Важны медленные, физически видимые действия работников/персонажей: идти, строить, переносить, поливать, собирать, обслуживать.
- Любая благотворительная механика должна быть добровольной, прозрачной и не унижать пользователя просьбами.

## 9. Недоступность локального checkout или инструмента

Если во время работы AI теряет доступ к локальному checkout или нужному local tool, он должен:

1. остановить запись или чтение, которое не удалось выполнить;
2. честно сообщить пользователю, что именно уже успел сделать;
3. перечислить, какие файлы были успешно изменены или прочитаны;
4. явно указать, на каком шаге работа остановилась;
5. попросить пользователя восстановить local-project/filesystem access или нужный инструмент;
6. после повторного включения продолжить с места остановки, не начиная задачу заново и не делая вид, что пропущенные изменения уже записаны.

Это правило не отменяет главный принцип проекта: локальные документы остаются источником истины, а AI не должен утверждать, что файл был прочитан или изменён, если операция не была реально выполнена.

## 9A. Блокеры и material workaround

Исторический, environment-specific или version-specific блокер — это evidence /
lead для текущей проверки, а не автоматически текущая истина.

Перед тем как считать такой блокер активным, агент обязан проверить его на
текущем checkout, текущем binary/version и в текущем execution environment
самым маленьким безопасным bounded check.

Если блокер меняет согласованный execution path, acceptance route, tool
surface, scope, owner или создаёт существенную/multi-session workaround-работу:

1. показать пользователю точное evidence и варианты до принятия нового пути;
2. можно безопасно/read-only исследовать и предложить workaround;
3. нельзя принять, активировать, реализовать или начать operational use этого
   workaround без явного согласия пользователя;
4. Coordinator, Project Manager и Codex не могут изготовить или подменить это
   согласие;
5. если согласие недоступно, изменённый маршрут остаётся `HOLD`; продолжать
   можно только безопасную in-scope диагностику, которая не коммитит проект к
   workaround;
6. после согласия выбранный route и approval записываются в active brief /
   current docs до реализации.

Этот gate не распространяется на тривиальное обратимое восстановление, уже
входящее в явно разрешённый workflow и не меняющее route/scope/acceptance.
Долгие обходы вокруг неперепроверенного старого блокера запрещены.

## 9B. Steam-managed Godot only

По D-028 локальная разработка, QA и evidence Shelter Steam/Desktop используют
только Godot, установленный и управляемый Steam, по repo-documented path:

```text
$HOME/Library/Application Support/Steam/steamapps/common/Godot Engine/Godot.app/Contents/MacOS/Godot
```

Агенты не скачивают, не устанавливают, не обновляют, не распаковывают, не
подменяют и не выбирают другой Godot binary/version самостоятельно. Нельзя
молча fallback на `PATH`, Downloads, Applications, Homebrew, GitHub release,
mirror/archive, custom binary или editor-bundled Godot.

Если Steam-managed Godot отсутствует, недоступен, имеет неверную версию или
требует update/repair, `STOP`: попроси пользователя выполнить
install/update/repair через Steam. Если обнаружена любая другая локальная копия
Godot, не используй, не удаляй, не перемещай и не quarantine её; сообщи
пользователю и попроси удалить её самостоятельно, чтобы убрать path/version
ambiguity. После пользовательского cleanup/update заново прочитай точный Steam
binary path и version до продолжения.

Это engine/tool-selection policy, а не запрет direct shell/sh launch. Запуск
Steam-managed binary через shell остаётся разрешён, когда его допускают active
brief и literal ACK. Product/game/art/runtime/capture meaning не меняется.

## 9C. Observable and graceful Godot subprocess lifecycle

По D-029 любой project-owned wrapper, test runner или capture runner,
запускающий Godot, обязан до spawn fail-closed проверить:

- exact Steam-managed binary и current version по D-028;
- canonical Shelter Steam project с `project.godot`;
- явно разрешённый фиксированный operation profile и argv без произвольного
  executable/shell/eval/fallback.

Raw stdout и stderr Godot сохраняются полностью и раздельно до любого
распознавания ошибок, зеркалируются пользователю live и не удаляются как
единственная диагностика. Child process result и diagnostic result — разные
verdict: нужно явно записывать normal exit code или terminating signal и
отдельно обнаруженные ошибки.

Finite test после `ERROR` не убивается wrapper'ом: он доходит до natural exit,
после чего diagnostic verdict остаётся `FAIL` и запрещает capture, manifest,
seal или promotion. Wrapper/diagnostic не должен сам вызывать Godot crash,
`SIGABRT` или `SIGKILL`.

Long-lived Godot останавливается только так: project/control quit с ACK и
bounded grace → exact-PID `SIGTERM` и bounded grace → если процесс всё ещё жив,
честный `BLOCKED` с PID и сохранёнными логами. Hard-kill escalation нет.

Ошибки нельзя скрывать, подавлять, переименовывать в benign, blanket-allowlist
или обходить environment masking. Нужно исправить причину и повторить bounded
gate. Текущая CA/certificate error остаётся реальной и нерешённой до
технического исправления; её повтор блокирует capture/seal.

Persistence/recovery proof не получает исключения: `kill -9` / `OS.kill`
заменяются нефатальными authored intermediate snapshots/failpoints и свежим
чистым verifier process. Product/game/save/runtime semantics не меняются.

## 10. Shelter MCP — local domain-specific runtime / inspection adapter

Shelter MCP находится внутри монорепозитория:

```text
mcp/
```

Его назначение после D-021:

- запуск whitelisted Shelter dev-команд, включая Workbench Runtime Capture;
- чтение и управление workbench capture runs;
- старт/стоп local Godot State Connector control runtime;
- whitelisted runtime control actions через Godot connector HTTP API;
- ограниченная deterministic-навигация по Current Memory / Knowledge / History.

Shelter MCP не является:

- generic shell;
- обязательным способом читать или изменять repo-файлы;
- отдельным репозиторием;
- источником истины вместо локальных документов.

Локальный STDIO setup, launcher, monorepo semantics и project-scoped конфигурация Shelter MCP реализованы по Codex brief:

```text
docs/drive/Shelter/04_DEVELOPMENT/SHELTER_WORKFLOW__Codex_Brief__ChatGPT_Work_And_Local_MCP_Migration_v1.md
```

Актуальный setup path: `.codex/config.toml` + `mcp/run.sh`.

# Project Roles

В проекте Shelter AI-сессия всегда должна явно понимать свою текущую роль. Роль задаёт фокус работы, тип решений, документы, которые нужно читать, и формат результата.

Роль пользователя в промте вида “Ты — project manager”, “Ты — producer”, “Ты — art director”, “Ты — game designer”, “Ты — CTO” считается явным назначением роли для текущей сессии.

Назначение роли не отменяет главное правило контекста: перед серьёзной задачей AI обязан читать локальные документы проекта через доступный механизм доступа к локальному репозиторию Shelter и не делать вид, что знает проект по памяти.

## [Project Manager](docs/drive/Shelter/00_START_HERE/000_ROLE_PROJECT_MANAGER.md) / Knowledge Base Maintainer

## [Producer](docs/drive/Shelter/00_START_HERE/000_ROLE_PRODUCER.md)

## [Game Designer](docs/drive/Shelter/00_START_HERE/000_ROLE_GAME_DESIGNER.md)

## [Art Director](docs/drive/Shelter/00_START_HERE/000_ROLE_ART_DIRECTOR.md) / Visual Design / UX

## [Codex](docs/drive/Shelter/00_START_HERE/000_ROLE_CODEX.md) / Development Agent

## Cross-role rules

Любая роль обязана:

- читать локальные документы перед серьёзной задачей;
- не делать вид, что знает проект по памяти;
- доверять документам больше, чем чату, если нет признаков устаревания;
- сообщать о конфликте документов вместо угадывания;
- фиксировать принятые решения в документах;
- готовить handoff после длинной или значимой сессии;
- не предлагать механики, противоречащие этике Shelter;
- перед новой серией задач проверять актуальный рабочий roadmap своей зоны, если роль ведёт последовательность дизайн/dev/art/PM-задач.

Working roadmap — живой рабочий план, а не библия и не product decision сам по себе. Его можно переносить, разделять, объединять, уточнять или удалять только с явным обоснованием: новое product decision, результат прототипирования, техническое ограничение, проблема читаемости/production scope, изменение приоритета, конфликт документов, зависимость от другой задачи или изменение Vertical Slice scope. Существенные изменения roadmap фиксируются в changelog самого roadmap, handoff или decision/update note.

Producer отвечает за приоритеты и может утверждать или менять product roadmap, но не обязан начинать каждую продюсерскую сессию с отдельного roadmap-документа. Для Game Designer, Art Director, Codex и Project Manager рабочий roadmap используется как механизм синхронизации последовательности задач и защиты от scope creep.

Если роль меняется в середине чата, новая роль должна восстановить контекст через локальные документы, а не продолжать по памяти.

Если пользователь просит “зафиксировать решение”, роль должна:

1. определить, является ли это новым decision, update, proposal или open question;
2. найти релевантные документы;
3. обновить decision log / current status / product docs / open questions / handoff;
4. не добавлять новые продуктовые решения сверх сказанного пользователем;
5. в финальном ответе перечислить, что было изменено.

Если пользователь просит только подготовить текст без записи в документы, нужно выдать готовый блок для вставки и явно указать, куда его лучше вставить.
