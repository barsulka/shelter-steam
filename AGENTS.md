# AGENTS.md — Shelter Monorepo

## Язык общения

Все общение с пользователем — строго по-русски, если пользователь явно не попросил другой язык.

## Главный порядок работы

Перед любой значимой задачей сначала прочитай `PROJECTS_RULES.md`.

`PROJECTS_RULES.md` — главный документ проекта. Если между ним и другими документами возникает конфликт, приоритет всегда у `PROJECTS_RULES.md`.

## Доступ к документации

Единственный источник проектной информации — локальная документация репозитория Shelter.

Конкретные правила доступа:

- Codex: читай и изменяй локальные документы напрямую через файловую систему текущего checkout репозитория.
- ChatGPT: читай и изменяй локальные документы через подключённый локальный bridge. Предпочтительно использовать Shelter MCP endpoint, если он настроен; его `fs_*` tools проксируют official filesystem MCP. Старый `локальный файлсервер` остаётся fallback.
- Другие AI-инструменты: используй доступный им механизм чтения и записи локальных файлов проекта.

Если доступ к локальным документам недоступен, остановись и попроси пользователя восстановить доступ через Shelter MCP или fallback `локальный файлсервер`. Не используй память предыдущих чатов как источник истины. Не делай вид, что документ был прочитан, если он не был открыт через доступный механизм доступа к локальным файлам.

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

### Sibling repo: Shelter MCP

`/Users/barsulka/GolandProjects/shelter/mcp` (`git@github.com:barsulka/shelter-mcp.git`) — отдельный локальный Go MCP-сервер для Shelter Steam/Desktop dev workflows.

Он не является частью Godot-проекта и не даёт generic shell. Он exposes whitelisted MCP tools для запуска Shelter dev-команд, Workbench Runtime Capture, чтения/очистки capture runs, старта/стопа local Godot State Connector control runtime, whitelisted runtime control actions через connector HTTP API и `fs_*` proxy к official `@modelcontextprotocol/server-filesystem`.

Для remote/local AI tool access Shelter MCP — preferred bridge вместо старой схемы “отдельный filesystem MCP tunnel + отдельные игровые запускалки”. Настройка выполняется в MCP repo через clone, `.env` по `.env.example` и `./run.sh`.

## Источники истины

Приоритет чтения документов:

1. `PROJECTS_RULES.md`
2. `AGENTS.md`
3. `README.md`
4. `docs/repo/status/CODEX_STATUS.md`
5. `docs/repo/adr/README.md`
6. документы внутри `docs/`
7. README/AGENTS конкретного подпроекта

Перед технической реализацией Codex должен проверить `docs/repo/adr/README.md` и прочитать все релевантные `Accepted` ADR. Это особенно обязательно перед изменениями архитектуры, runtime-state, save/snapshot/connector-контрактов, платформенного поведения, dev tooling или подпроектных границ.

Если документы противоречат друг другу — не угадывай. Сообщи пользователю о конфликте и предложи, какой документ обновить.

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

Brief должен содержать цель, обязательные источники, scope / out of scope, acceptance criteria, stop conditions, ожидаемые зоны изменений, проверки и требования к обновлению `docs/repo/status/CODEX_STATUS.md`.

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
