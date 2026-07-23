# AGENTS.md — Shelter Monorepo

## Язык общения

Все общение с пользователем — строго по-русски, если пользователь явно не попросил другой язык.

## Главный порядок работы

Перед любой значимой задачей сначала прочитай `PROJECTS_RULES.md`.

`PROJECTS_RULES.md` — главный документ проекта. Если между ним и другими документами возникает конфликт, приоритет всегда у `PROJECTS_RULES.md`.

## Доступ к документации

Единственный источник проектной информации — локальная документация репозитория Shelter.

Конкретные правила доступа:

- ChatGPT Work и Codex в local project: читай и изменяй локальные документы напрямую через файловую систему текущего checkout репозитория.
- Codex CLI / IDE: работай с файлами текущего checkout напрямую.
- Shelter MCP: когда source-derived context bridge доступен и сообщает `health=current`, используй `shelter_context_bundle(role, area, task, max_bytes)` как default routine bootstrap/context-routing path. MCP также остаётся domain-specific adapter для Workbench / Godot runtime / inspection tools и не даёт generic filesystem/shell.
- Local source docs остаются authority и exact fallback. Читай их напрямую при unavailable/non-current MCP, fallback, omission/truncation, conflict/parser failure, для exact brief / Accepted ADR / normative contract и всегда перед изменением самого source document.
- Другие AI-инструменты: используй доступный им механизм чтения и записи локальных файлов проекта.

Если доступ к локальным документам недоступен, остановись и попроси пользователя восстановить local-project/filesystem access. Не используй память предыдущих чатов как источник истины. Не делай вид, что документ был прочитан, если он не был открыт через доступный механизм доступа к локальным файлам.

## Структура репозитория

Монорепозиторий состоит из нескольких подпроектов.

### `steam/`

Desktop / Steam Godot-игра для Windows и macOS.

Перед изменениями в Steam обязательно прочитать:

- `PROJECTS_RULES.md`
- этот файл
- `steam/AGENTS.md`
- `steam/README.md`
- релевантные документы в `docs/`

Steam нельзя смешивать с Browser Extension. Никаких Chrome new-tab layout, browser search bar, sponsorship/ad block, rewarded ads или extension-specific механик в Godot-игре.

Текущая последовательность платформенной разработки Steam/Desktop:

- всю игру разрабатываем, собираем, проверяем и принимаем на macOS вплоть до отдельного предрелизного этапа;
- Windows остаётся будущей целевой платформой, но до явного предрелизного решения не входит в текущие implementation-, QA-, evidence- или acceptance-гейты;
- отсутствие Windows-проверки до такого решения не является предупреждением, блокером или причиной не выдать текущий macOS-результат;
- Windows compatibility / port / smoke / certification открываются только отдельной явно активированной предрелизной волной.

### `chrome/`

Рабочая зона будущего Browser Extension.

До появления отдельного технического задания запрещается:

- добавлять `manifest.json`;
- писать extension runtime;
- реализовывать UX браузерного расширения;
- менять `steam/`, если задача явно не требует shared-контракта.

### `docs/`

Общая документация проекта и долговременная память Shelter.

Все долгоживущие решения должны попадать в локальные документы проекта.

### Локальные временные файлы

Для временных рабочих, диагностических и промежуточных артефактов по умолчанию
используй уникальную подпапку внутри корневого `tmp/` репозитория. Этот каталог
специально добавлен в `.gitignore`, остаётся видимым и управляемым пользователем
и не должен подменять canonical evidence или tracked-документы.

Системные `/tmp` и `/private/tmp` на macOS не являются default: `/tmp` указывает
на `/private/tmp`, а его содержимое может удаляться системной очисткой. Используй
уникальный путь там только если repo-local `tmp/` действительно недоступен,
конкретный системный API требует system temp или active brief / пользователь
явно разрешил такой fallback. Сначала проверь repo-local путь без мутации
исходных данных; если перенос туда уже начался или его readback не совпал,
остановись и не каскадируй автоматически в другой temp-root.

### `mcp/`

Локальный Go MCP-сервер внутри монорепозитория для Shelter Steam/Desktop dev workflows.

Он не является частью Godot runtime и не даёт generic shell. Его целевая роль — whitelisted Workbench Runtime Capture, capture management, local Godot connector/control и bounded knowledge navigation.

Shelter MCP запускается локально по STDIO из того же монорепозитория через project-scoped `.codex/config.toml`. После реализации D-026 его здоровый source-derived context bundle является default routine bootstrap/context-routing path; прямое чтение checkout остаётся authority, exact verification и fallback. Knowledge failure не должен отключать runtime/capture/control capabilities в той же сессии.

## Источники истины

Routine entry при здоровом source-derived MCP начинается с `shelter_context_bundle(role, area, task, max_bytes)`. Следующий приоритет применяется для exact verification/fallback и source editing:

1. `PROJECTS_RULES.md`
2. `AGENTS.md`
3. `README.md`
4. `docs/repo/status/CODEX_CURRENT_STATUS.md`
5. `docs/repo/adr/README.md`
6. документы внутри `docs/`
7. README/AGENTS конкретного подпроекта

Перед технической реализацией Codex должен проверить `docs/repo/adr/README.md` и прочитать все релевантные `Accepted` ADR. Это особенно обязательно перед изменениями архитектуры, runtime-state, save/snapshot/connector-контрактов, платформенного поведения, dev tooling или подпроектных границ.

Если документы противоречат друг другу — не угадывай. Сообщи пользователю о конфликте и предложи, какой документ обновить.

## Блокеры и material workaround

Исторический, environment-specific или version-specific блокер — evidence /
lead, а не автоматически текущая истина. Перед тем как считать его активным,
перепроверь текущий checkout, binary/version и execution environment самым
маленьким безопасным bounded check.

Если блокер меняет согласованный execution path, acceptance route, tool
surface, scope, owner или ведёт к существенной/multi-session workaround-работе:

- покажи пользователю точное evidence и варианты до принятия нового пути;
- безопасно/read-only исследовать и предложить workaround можно;
- принять, активировать, реализовать или operationalize workaround без явного
  пользовательского согласия нельзя;
- Coordinator, Project Manager и Codex не могут выдать это согласие вместо
  пользователя;
- без согласия изменённый route остаётся `HOLD`; допустима только безопасная
  in-scope диагностика, не коммитящая проект к workaround;
- после согласия approval и chosen route должны попасть в active brief/current
  docs до реализации.

Это не относится к тривиальному обратимому recovery, уже входящему в явно
разрешённый workflow и не меняющему route/scope/acceptance.

## Steam Godot binary authority

Для локальной разработки, QA и evidence Steam/Desktop используй только
Steam-managed Godot по repo-documented path:

```text
$HOME/Library/Application Support/Steam/steamapps/common/Godot Engine/Godot.app/Contents/MacOS/Godot
```

Не скачивай, не устанавливай, не self-update, не распаковывай, не подменяй и не
выбирай другой Godot самостоятельно. Нет fallback на `PATH`, Downloads,
Applications, Homebrew, GitHub release, mirror/archive, custom binary или
editor-bundled Godot.

Если Steam binary отсутствует, недоступен, неверной версии или требует
update/repair, остановись и попроси пользователя исправить его через Steam.
Другую найденную копию не используй и не удаляй/перемещай/quarantine: сообщи
пользователю и попроси удалить её самостоятельно. После пользовательского
cleanup/update заново проверь exact Steam path и version.

Direct shell/sh launch Steam-managed binary остаётся допустимым, когда его
разрешают active brief и literal ACK. Это не меняет capture paths или
product/game/art/runtime contracts.

## Godot process observability and graceful stop

По D-029 Godot subprocess можно запускать только после fail-closed проверки
exact D-028 Steam binary/version, canonical Steam project с `project.godot` и
фиксированного разрешённого argv/profile. Произвольный executable, shell/eval,
foreign `--path` или fallback запрещены.

Сохраняй полный raw stdout и stderr раздельно до диагностики и одновременно
показывай их live. Явно разделяй child process result (exit code или signal) и
diagnostic verdict. `ERROR` не должен заставлять wrapper убить finite test:
дай процессу natural exit, затем верни diagnostic `FAIL` и запрети дальнейший
capture/manifest/seal/promotion.

Wrapper не вызывает `SIGABRT`/`SIGKILL` и не self-crash/abort Godot. Long-lived
процесс останавливается через project/control quit + ACK, затем после bounded
grace — exact-PID `SIGTERM`; если второй bounded grace истёк, остановись с
`BLOCKED_CHILD_STILL_RUNNING`, сохрани PID/логи и не применяй hard kill.

Не скрывай, не suppress и не blanket-allowlist ошибки. Текущая CA/certificate
error остаётся unresolved и блокирует capture/seal до исправления. Recovery
tests используют нефатальные authored snapshots/failpoints и свежий clean
verifier process; исключения для `kill -9` / `OS.kill` нет.

## Documentation governance

Для защиты от раздувания документации используй `docs/drive/Shelter/00_START_HERE/05_DOCUMENTATION_GOVERNANCE.md`.

Default reading model: Current Memory first, Knowledge by task, retained evidence
only for exact evidence/regression work. Superseded/history Markdown по умолчанию
живёт только в Git history; в checkout остаются Accepted ADR, обязательный
authority/routing, validator/hash-required immutable evidence и действительно
используемые regression contracts. Не восстанавливай проект через старые briefs,
capture packs, handoff и long logs.

## Роли и границы решений

Перед работой в роли Producer, Project Manager, Game Designer, Art Director или Codex нужно читать соответствующий role-document в `docs/drive/Shelter/00_START_HERE/`.

Краткое разделение:

- Producer — продуктовая рамка, приоритеты, scope, product decisions, relationship between products, ethical boundaries.
- Project Manager — синхронизация документов, decision log, open questions, handoff и контроль границ ролей.
- Game Designer — mechanics, economy structures, resources, production chains, task flow, progression, dog traits, research, balance requirements, player goals, retention, UX-logic.
- Art Director — visual direction, style board, art bible, UI look, asset style, palette, silhouette/readability, prompts, animation visual language, asset production rules.
- Codex — implementation, local repo changes, checks, dev docs/status и technical constraints.

Game Designer может описывать визуальные требования только как gameplay constraints: какие действия, состояния и сущности должны считываться игроком. Game Designer не должен выбирать финальный art style, писать asset prompts, проектировать art bible, palette или asset pipeline.

Art Director может формулировать visual constraints, но не должен молча менять mechanics, economy, task flow, core loop или product scope.

Codex не должен принимать product/game/art решения вместо реализации контрактов. Если для реализации нужно добавить новую механику, удалить обязательный visible step, изменить asset taxonomy, расширить scope или нарушить design contract, Codex должен остановиться и вернуть вопрос соответствующей роли.

## Feature, обязательный `/grilling` и canonical specification

### Что считается feature

`Feature` — любая новая user-facing mechanic, system или workflow, а также
material change поведения, economy, art, runtime, platform, data contract,
product/technical contract или scope.

Pure bugfix, maintenance, verification и cleanup внутри уже принятой
specification не требуют нового полного grilling. Если такая работа начинает
менять contract, scope, acceptance, видимое поведение, обязательный workflow,
material security/risk profile или границу обязательных approvals, она
становится feature work: текущая сессия останавливается и проходит feature gate
ниже.

`Large chunk` / `material phase` — feature implementation, новая art-,
game-design- или system-wave либо любая задача, способная materially изменить
scope, contracts или acceptance. Маленькое исправление внутри принятого
контракта не требует нового Root/King approval, пока не возникла такая
эскалация.

### Обязательный `/grilling`

`/grilling` — обязательное имя проектного процесса глубокого интервью и
проработки feature. Оно действует независимо от того, существует ли в текущем
инструменте literal slash-command или специальный tool с таким именем.

Каждая feature без исключения проходит `/grilling`. Нет completed grilling и
canonical specification — feature недостаточно спроектирована и не должна
строиться.

До implementation planning и активации brief у feature должна быть ровно одна
canonical feature specification в релевантной docs authority. Все последующие
grilling-итерации обновляют ту же specification, а не создают параллельную
current truth. Chat-only grilling не считается завершённым.

Каждый проведённый `/grilling` и его результат записываются в canonical
specification, включая промежуточную или повторную итерацию. Specification
содержит:

- problem и user value;
- принятые решения;
- scope и out of scope;
- user flow, состояния и переходы;
- edge cases и failure cases;
- влияние на роли и зоны ответственности;
- constraints и dependencies;
- unresolved questions;
- acceptance criteria и gates;
- evidence/provenance, owner и current status.

Feature specification не заменяет обязательный Codex brief: specification
фиксирует спроектированную feature, а brief задаёт bounded execution contract.
Brief нельзя активировать до прохождения feature gate.

### Root/King feature gate

Для начала large chunk/material phase обязательны все три условия:

1. `/grilling` завершён;
2. canonical feature specification записана и актуальна;
3. Root/King session явно одобрил продолжение после чтения результата.

Отсутствие любого из условий запрещает implementation planning, implementation, art production,
game-design expansion, активацию Codex brief и начало другого large work chunk.

Feature использует статусы:

```text
GRILLING
GRILLED-READY-FOR-ROOT-REVIEW
ROOT-APPROVED
```

Root/King может отклонить результат и вернуть feature в `GRILLING`. Его
`ROOT-APPROVED` даёт cross-stream go-ahead, но не заменяет пользователя как
authority для product/art решений и других gates, где прямое user approval уже
обязательно.

## Root/King, sub-orchestration и event-driven control

«Царь», «Князь» и `/grilling` — внутренние governance-термины и политики
Shelter. Они концептуально используют manager/specialist/planning primitives,
но не объявляются официальной терминологией OpenAI или обязательной методологией
OpenAI. Там, где Shelter намеренно строже общих возможностей инструмента,
действует текущая governance Shelter.

Root/King — главный координирующий сеанс. В каждый момент у проекта ровно один
active Root/King («Царь»). Он владеет portfolio plan, cross-stream dependencies,
writer locks/conflicts, activation ordering, пользовательской коммуникацией и
финальным go/no-go между потоками.

В каждый момент у одной feature и её единственной canonical specification ровно
один active sub-orchestrator / lane controller («Князь»). Один и тот же
княжеский lineage ведёт feature от первой итерации `/grilling` через Root
review/gate, planning, implementation coordination и independent verification
до closure. Нельзя назначать отдельного «Князя прожарки» и отдельного
«implementation-Князя» одновременно или последовательно как независимые роли.

`Одна feature → один Князь → одна /grilling` означает один непрерывный grilling
lineage/process в одной canonical specification. Уточняющие и повторные
grilling-итерации допустимы, но обновляют ту же specification и не создают
вторую grilling, вторую specification или параллельную feature truth.

Root/King не обязан лично проводить `/grilling`. Он делегирует его тому же
единственному Князю feature, который:

- интервьюирует/grills пользователя;
- координирует нужных role specialists;
- записывает точные решения в единственную canonical feature specification;
- возвращает компактный handback: grilling завершён, specification готова,
  unresolved questions и requested Root decision;
- после Root gate продолжает координировать тот же feature lineage до closure.

Root/King читает specification/handback и только после этого сам выдаёт или
отклоняет cross-stream go-ahead. Князь не может сам присвоить
`ROOT-APPROVED`.

Для bounded самостоятельных feature-lanes Root/King предпочтительно и
проактивно назначает Князя. Совсем короткую, одноступенчатую или невыгодную по
coordination overhead задачу, которая не является отдельной feature /
large-material phase, Root/King может координировать напрямую; это узкое
исключение, а не отмена preferred default или правила «одна feature — один
Князь».

Authors, role specialists и independent verifiers не являются дополнительными
Князьями. Князь оркестрирует scoped authors и отдельного verifier, возвращает
события и handback Root/King, но не подменяет его final go/no-go, не принимает
молча role/product/art/user decisions, не выдаёт `ROOT-APPROVED`, не расширяет
scope и не пишет вне объявленного владения.

Количество sessions/subagents не является целью. Root/King и Князь используют
минимально достаточный набор scoped authors, verifiers и specialists:
делегирование оправдано отдельным ownership/context, специализацией,
independent verification или действительно разделимой работой. Это не ослабляет
правила одного active Root, одного Князя на feature и отдельного verifier.

Same Князь session остаётся coordinator, пока её context fitness здорова. Царь
и Князь обязаны следить за качеством собственного контекста и не удерживать
титул ценой ошибок, потери authority или degraded coordination. Одна только
длина transcript не требует succession и не имеет числового порога: если тот же
физический владелец/session здоров, сначала применяются доступные
compaction/summarization, обновление чтения canonical authority/current
artifacts и короткий progress/authority self-check. Succession обязательна,
когда этого недостаточно, качество context/coordination деградирует или
ownership действительно передаётся.

Shelter `session succession` — operational transfer между физическими Codex
tasks/sessions, а не `handoff` из Agents SDK. Repo governance не кодирует
vendor-specific API continuation identifiers или mechanics.

Succession проходит только так:

1. действующий владелец останавливается на safe boundary;
2. готовит точный canonical handoff: authority, feature/spec или portfolio,
   current goal, completed work, current status, decisions, ownership/locks,
   evidence/hashes, done/acceptance criteria, validation state, open work,
   blockers, next event и stop conditions;
3. ровно один successor session читает authority/source docs, fail-closed
   проверяет checkout и возвращает ACK;
4. только после ACK титул и тот же lineage переходят successor, который
   становится единственным active owner;
5. predecessor архивируется.

Dual-active overlap, split-brain и параллельные successors запрещены. Succession
Князя не создаёт новую feature, новую `/grilling` или новую specification и не
обходит Root/user/verification gates.

Для Root succession действует тот же протокол на уровне всего проекта:
successor принимает portfolio, dependencies, locks, user communication и
final go/no-go; только после его ACK предыдущий Царь передаёт титул и
архивируется.

Это current/experimental governance. Изменить модель «одна feature — один
Князь — одна /grilling» или succession-протокол можно только новым прямым
решением пользователя.

Verification выполняет отдельная от author сессия. Для узких повторных revisions
по возможности переиспользуются те же author и verifier sessions, чтобы не
терять контекст и ownership. Завершённые idle sessions без ожидаемых revisions
архивируются; активные lanes с pending handback не архивируются.
Отдельный verifier дополняет, но не заменяет tests, runtime/evidence checks,
branch protections и обязательные Root/user/product/art approvals.

Sub-orchestration не обходит правила общего checkout: один write-owner на файл
или тесно связанный scope, обязательный pre-write `git status`, fail-closed stop
при неожиданных изменениях и согласованный integrator остаются authoritative.

### Event-driven coordination

Default coordination loop:

```text
dispatch task → one ACK/start snapshot → stop polling
→ child/sub-orchestrator pings on PASS / FAIL / blocker / decision
```

После подтверждения старта Root/King, lane controller и другие координирующие
сессии не опрашивают исполнителя без необходимости. Polling допустим только для:

- явно запрошенного continuous monitoring;
- suspected hang или пропущенного handback;
- time-critical dependency;
- инструмента, у которого нет callback/event-driven handback.

Не narrate неизменившиеся poll snapshots. Исполнитель обязан сам отправить
event-driven handback при `PASS`, `FAIL`, blocker или необходимости решения.

## Working roadmaps

Перед новой серией задач исполнительная роль должна проверить актуальный roadmap своей зоны или создать/обновить его, если последовательность задач ещё не зафиксирована.

Это правило особенно важно для:

- Game Designer — game design roadmap, scope lock, economy/balance/design-doc sequence.
- Art Director — visual roadmap, style board/readability/asset-pack/prompt sequence.
- Codex — implementation roadmap/status или dev task sequence, если работа идёт серией.
- Project Manager — roadmap синхронизации документов при больших cleanup / migration / handoff задачах.

Roadmap — живой рабочий план, а не библия и не самостоятельный product decision. Пункты можно переносить, разделять, объединять, уточнять или удалять, но каждое существенное изменение должно иметь явное обоснование: новое product decision, результат прототипирования, техническое ограничение, проблема читаемости или production scope, изменение приоритета, конфликт документов, новая зависимость или изменение Vertical Slice scope.

Существенные изменения roadmap фиксируются в changelog документа, handoff или decision/update note. Нельзя менять roadmap только потому, что появилась новая интересная идея.

## Постановка задач Codex

Любая значимая задача для Codex должна быть поставлена через отдельный brief-файл в:

```text
docs/drive/Shelter/04_DEVELOPMENT/
```

Нельзя ставить Codex dev-задачу только чатом или пересказом. Чат может содержать короткую команду, но источник задачи — brief-файл.

Сессия, которая готовит задачу для Codex, обязана в финальном ответе пользователю указать:

1. путь до brief-файла;
2. рекомендуемый уровень рассуждений для запуска Codex: `низкий`, `средний`, `высокий` или `очень высокий`.

Brief должен содержать цель, обязательные источники, scope / out of scope, acceptance criteria, stop conditions, ожидаемые зоны изменений, проверки и требования к обновлению `docs/repo/status/CODEX_CURRENT_STATUS.md`.

## Диалог между сеансами

Если для продолжения работы нужна задача другому уже существующему сеансу Shelter, не используй пользователя как курьера и не ограничивайся текстом «передай это Codex / Producer / Game Designer».

Если в текущей среде доступны инструменты управления соседними сеансами:

1. найди нужный сеанс;
2. отправь задачу прямо в него;
3. укажи source docs / brief, scope, ожидаемый результат и stop conditions;
4. после отправки проверь, что задача действительно появилась в целевом сеансе.

Если задача пришла из другого сеанса через delegation / handoff:

1. сохрани `source_thread_id` как адрес обратной связи;
2. выполни задачу и необходимые проверки;
3. по окончании обязательно отправь результат обратно именно в исходный сеанс;
4. в handback перечисли результат, изменённые файлы, проверки и оставшиеся blockers / open questions;
5. не считай межсессионную задачу завершённой, пока handback не отправлен.

Иными словами: задача между существующими сеансами ставится напрямую, а результат возвращается напрямую. Пользователь не должен вручную копировать сообщения между сеансами, если приложение позволяет сделать это самим агентам.

Если нужного сеанса ещё нет или инструменты межсессионной связи недоступны,
честно сообщи об этом пользователю. По общему правилу не создавай новый
пользовательский сеанс без явной просьбы пользователя. Узкое прямое исключение:
при реальной context succession единственного Царя или Князя, если подходящей
существующей сессии нет, текущий владелец титула может создать ровно одну
successor user session только для canonical handoff и передачи того же lineage
по протоколу выше. Это не даёт general session-creation authority.

## Конкурентная запись в общий checkout

Все локальные Shelter-сеансы по умолчанию видят один и тот же checkout и одну рабочую копию. Поэтому параллельное чтение и анализ разрешены, а параллельная запись требует явного владения областью изменений.

Правила:

1. В каждый момент времени у файла или тесно связанного набора файлов должен быть только один активный сеанс-владелец записи.
2. Перед записью сеанс обязан проверить `git status` и определить точный scope файлов, которые он собирается менять.
3. Если задачу ставит другой сеанс, scope записи нужно сообщить исходному сеансу в начале работы или получить из brief / delegation.
4. Остальные сеансы могут параллельно читать эти файлы, проводить аудит и готовить предложения, но не должны менять их до handback владельца.
5. Если обнаружены неожиданные или параллельные изменения в своём scope, нужно остановить запись, не перетирать и не откатывать чужую работу, а связаться с исходным сеансом / Project Manager.
6. Коммит и push волны делает заранее понятный интегратор. Нельзя включать в свой коммит незавершённые чужие изменения без прямого согласования.
7. Для действительно параллельной записи использовать отдельные Git worktree / branches с явно разделённым scope. Самостоятельно создавать их без необходимости или согласования не нужно.

Project Manager / главный координирующий сеанс разрешает конфликты владения и определяет порядок интеграции. Codex владеет implementation-файлами только в пределах принятого brief; ролевые сеансы владеют своими product/game/art/PM-документами только в пределах поставленной задачи.

## Работа с изменениями

После значимой задачи нужно:

- обновить релевантную документацию;
- обновить статус разработки при необходимости;
- оформить ADR, если принято новое техническое правило;
- подготовить handoff, если работа была большой.

## Workflow

Предпочитай:

- небольшие изменения;
- понятную структуру;
- локальные исправления;
- минимальный объём изменений.

Не допускается:

- переписывать несвязанный код;
- коммитить секреты, credentials, API keys, private tokens или локальные env-файлы;
- добавлять production-зависимости без необходимости и согласования.

## Захват изображений и экрана

Для визуальных доказательств Shelter разрешены ровно два штатных пути:

1. **Внутренний захват Godot** — основной и предпочтительный путь для содержимого игры. Используй уже существующие viewport/self-capture механизмы проекта: `get_viewport().get_texture().get_image().save_png(...)`, State Connector `capture.screenshot`, штатную PNG-последовательность `capture.video.start` или профильный capture runner.
2. **Системный захват macOS через Screenshot UI / Computer Use** — только когда действительно нужен весь рабочий стол, нативное окно или системное окружение, которое не попадает во viewport Godot.

Третьего пути нет. Запрещено придумывать ad-hoc screen-capture обходы, подменять штатный viewport-захват внешними хаками, использовать headless/dummy-кадр как визуальное доказательство при отсутствии настоящего framebuffer, фабриковать кадры или объявлять механический лог скриншотом. Исторический Codex/AppKit-host failure сам по себе не запрещает запуск текущего Godot binary в текущем environment: сначала перепроверь его по правилу выше. Если bounded check снова подтверждает pre-project abort в той же конфигурации, не повторяй именно её ради снимка и не переходи молча на другой route без пользовательского approval.

Если оба разрешённых пути недоступны, результат честно помечается `BLOCKED` / `UNSEALED`; требования к доказательствам не обходятся третьим способом.

## Этические ограничения

Shelter — благотворительный проект.

Нельзя:

- использовать агрессивный FOMO;
- манипулировать чувством вины;
- заставлять пользователя донатить;
- использовать неэтичную монетизацию.

Нужно:

- сохранять спокойный тон;
- уважать пользователя;
- делать благотворительность добровольной и прозрачной.
