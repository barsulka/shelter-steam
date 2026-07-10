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
- Shelter MCP: используй только для domain-specific Workbench / Godot runtime / inspection tools и bounded knowledge navigation; он не нужен как файловый bridge.
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

### `mcp/`

Локальный Go MCP-сервер внутри монорепозитория для Shelter Steam/Desktop dev workflows.

Он не является частью Godot runtime и не даёт generic shell. Его целевая роль — whitelisted Workbench Runtime Capture, capture management, local Godot connector/control и bounded knowledge navigation.

ChatGPT Work/Codex читают файлы напрямую. Shelter MCP запускается локально по STDIO из того же монорепозитория через project-scoped `.codex/config.toml` и используется только как domain-specific adapter.

## Источники истины

Приоритет чтения документов:

1. `PROJECTS_RULES.md`
2. `AGENTS.md`
3. `README.md`
4. `docs/repo/status/CODEX_CURRENT_STATUS.md`
5. `docs/repo/adr/README.md`
6. документы внутри `docs/`
7. README/AGENTS конкретного подпроекта

Перед технической реализацией Codex должен проверить `docs/repo/adr/README.md` и прочитать все релевантные `Accepted` ADR. Это особенно обязательно перед изменениями архитектуры, runtime-state, save/snapshot/connector-контрактов, платформенного поведения, dev tooling или подпроектных границ.

Если документы противоречат друг другу — не угадывай. Сообщи пользователю о конфликте и предложи, какой документ обновить.

## Documentation governance

Для защиты от раздувания документации используй `docs/drive/Shelter/00_START_HERE/05_DOCUMENTATION_GOVERNANCE.md`.

Default reading model: Current Memory first, Knowledge by task, History only for evidence/regression/archaeology. Не восстанавливай проект через все старые briefs, capture packs, handoff и long logs.

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

Если нужного сеанса ещё нет или инструменты межсессионной связи недоступны, честно сообщи об этом пользователю. Не создавай новый пользовательский сеанс без явной просьбы пользователя.

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
