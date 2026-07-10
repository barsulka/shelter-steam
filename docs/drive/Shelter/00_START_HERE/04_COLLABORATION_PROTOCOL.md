# 04_COLLABORATION_PROTOCOL — Shelter cross-role collaboration

Дата создания: 2026-06-29
Статус: active process document
Владелец процесса: Producer / Project Manager

## 0. Назначение

Этот документ описывает, как в Shelter проводить коллегиальные обсуждения между AI-ролями без копирования длинных промтов между чатами.

Главная идея: роли не пересказывают друг друга и не притворяются друг другом. Вместо этого они работают через общий локальный документ — Quick Role Check, Cross-role RFC или Decision Council Packet.

Локальный документ является общей доской обсуждения. Чат — место работы роли. Долговременным результат становится только после записи в документы проекта.

## 1. Уровни коллегиального обсуждения

### 1.1 Quick Role Check

Использовать для маленьких вопросов, где нужен быстрый sanity-check одной или двух ролей.

Примеры:

- Codex предлагает shortcut в реализации, и нужно проверить, не ломает ли он game-design contract.
- Art Director видит проблему readability и хочет понять, меняет ли она механику.
- Game Designer хочет уточнить, можно ли оставить конкретный visual вопрос на Art Director.

Формат: короткий документ или секция в handoff / RFC с позициями ролей и финальным Producer / PM summary.

### 1.2 Cross-role RFC

Использовать для нормальных межролевых вопросов, где нужно собрать позиции Game Designer, Art Director, Codex, Producer или PM.

Примеры:

- границы задач Codex по Steam Vertical Slice;
- какие visual placeholders Codex может делать сам;
- где проходит граница между gameplay object contract и asset brief;
- какие implementation shortcuts допустимы без нарушения visible cause-and-effect.

Формат: отдельный файл в:

```text
Shelter/06_SESSIONS_AND_HANDOFFS/cross_role_sessions/
```

### 1.3 Decision Council

Использовать для решений, которые могут изменить product scope, Vertical Slice scope, art direction, technical direction, monetization, charity promises или relationship between products.

Decision Council требует:

- Producer as chair;
- PM / Knowledge Base Maintainer as scribe;
- отдельные role positions;
- финальный decision / rejection / deferral;
- обновление `02_DECISIONS`, product docs, role docs или open questions, если решение принято.

## 2. Принцип настоящих позиций ролей

AI-сессия может подготовить draft synthesis или предварительную карту аргументов, но это не считается настоящей позицией другой роли.

Нельзя считать, что Art Director, Game Designer или Codex согласились с решением, если соответствующая роль не заполнила свою секцию или Producer явно не принял решение как product/process decision.

Правильная формула:

> Draft synthesis допустим. Consensus считается достигнутым только после role review или Producer decision.

## 3. Общая структура Cross-role RFC

Рекомендуемый шаблон:

```md
# Cross-role RFC — <topic>

Дата:
Статус: draft / role review / producer synthesis / accepted / rejected / deferred
Chair: Producer
Scribe: Project Manager / Knowledge Base Maintainer
Участники: Game Designer, Art Director, Codex, Producer, PM

## 1. Повод

Почему обсуждаем.

## 2. Контекст и источники

Какие документы обязательны к чтению.

## 3. Вопросы на согласование

Нумерованный список вопросов.

## 4. Current assumptions

Что уже считается заданным контекстом, а не предметом спора.

## 5. Game Designer position

Заполняет только Game Designer.

## 6. Art Director position

Заполняет только Art Director.

## 7. Codex position

Заполняет только Codex.

## 8. Producer synthesis

Заполняет Producer.

## 9. Final decision / update

Что принято, отклонено или отложено.

## 10. Docs to update

Какие документы нужно обновить.

## 11. Changelog
```

## 4. Правила заполнения RFC

- Каждая роль заполняет только свою секцию.
- Роль не переписывает чужие позиции.
- Роль может добавлять вопросы к другой роли в `Open questions` или своей секции.
- Producer может свести позиции и принять решение.
- Project Manager может привести документ в порядок, но не должен менять смысл позиций ролей без явного решения.
- Если RFC меняет product/game/art/tech contract, результат нужно перенести в соответствующие долгоживущие документы.

## 5. Короткие стартовые промты для ролей

### 5.1 Game Designer

```text
Ты — Game Designer / Systems Designer проекта Shelter.

Открой в локальном проекте ChatGPT Work указанный Cross-role RFC-документ.
Прочитай его context/sources и релевантные role/product docs.
Заполни только секцию `Game Designer position`.
Твоя зона: mechanics, economy structures, resources, production chains, task flow, progression, dog traits, balance requirements, player goals, retention и UX-logic.
Визуал можно описывать только как gameplay constraints.
Не меняй секции Art Director, Codex, Producer или PM.
Если есть конфликт или вопрос — добавь его в свою секцию как open question.
```

### 5.2 Art Director

```text
Ты — Art Director / Visual Designer проекта Shelter.

Открой в локальном проекте ChatGPT Work указанный Cross-role RFC-документ.
Прочитай его context/sources и релевантные role/product/design docs.
Заполни только секцию `Art Director position`.
Твоя зона: visual direction, style board, art bible, UI look, asset style, palette, silhouette/readability, prompts, animation visual language и asset production rules.
Не меняй mechanics, economy, core loop, task flow или product scope.
Не меняй секции Game Designer, Codex, Producer или PM.
Если visual constraint влияет на механику/scope — оформи это как constraint/proposal.
```

### 5.3 Codex

```text
Ты — Codex проекта Shelter.

Открой через локальную файловую систему указанный Cross-role RFC-документ.
Прочитай его context/sources и релевантные repo docs: PROJECTS_RULES.md, AGENTS.md, README.md, docs/repo/status/CODEX_CURRENT_STATUS.md, role Codex и product contracts.
Заполни только секцию `Codex position`.
Твоя зона: implementation, local repo changes, checks, dev docs/status и technical constraints.
Не принимай product/game/art решений.
Если реализация требует изменить механику, visible step, asset taxonomy, scope, visual direction или design contract — верни вопрос соответствующей роли.
```

### 5.4 Producer

```text
Ты — Producer проекта Shelter.

Открой в локальном проекте ChatGPT Work указанный Cross-role RFC-документ.
Прочитай заполненные позиции ролей и обязательные источники.
Заполни `Producer synthesis` и, если решение принято, `Final decision / update`.
Не добавляй новых продуктовых решений сверх темы RFC.
Если решение долгоживущее — обнови decision log / product docs / role docs / status / handoff.
```

### 5.5 Project Manager

```text
Ты — Project Manager / Knowledge Base Maintainer проекта Shelter.

Открой в локальном проекте ChatGPT Work указанный Cross-role RFC-документ.
Проверь полноту источников, структуру, конфликты и список docs to update.
Не меняй product/game/art/tech смысл без Producer decision.
После принятого решения обнови нужные документы и подготовь handoff.
```

## 6. Когда RFC становится решением

RFC сам по себе не является решением.

Результат становится решением только если:

1. Producer явно принял `Final decision / update`; или
2. пользователь явно попросил зафиксировать решение; и
3. решение записано в `02_DECISIONS`, product docs, role docs, `AGENTS.md`, status или другой релевантный долгоживущий документ.

Если роли дали позиции, но Producer не подвёл итог, статус RFC остаётся `role review` или `producer synthesis needed`.

## 7. Где хранить результаты

- Разовые cross-role обсуждения: `06_SESSIONS_AND_HANDOFFS/cross_role_sessions/`.
- Принятые долгоживущие решения: `00_START_HERE/02_DECISIONS.md`.
- Текущий проектный статус: `00_START_HERE/01_CURRENT_STATUS.md`.
- Role boundary updates: `000_ROLE_*.md`, `AGENTS.md`, `PROJECTS_RULES.md`.
- Product/game/art contracts: релевантные документы в `02_PRODUCTS/` и `03_DESIGN/`.
- Dev execution status: `docs/repo/status/CODEX_STATUS.md`.

## 8. Минимальное правило против копипасты

Не копировать длинный контекст между чатами, если можно дать роли путь к RFC и список источников.

В ChatGPT Work отдельная задача/сессия создаётся под конкретный результат, а не как постоянная ролевая память. Новая задача восстанавливает роль и состояние из role-doc, Current Memory и task document. Наличие или отсутствие заранее открытых соседних задач не влияет на источник истины.

Допустимый короткий промт:

```text
Открой RFC по пути <path>, прочитай sources и заполни только свою секцию.
```

## 9. Постановка задач Codex

Любая постановка задачи Codex в Shelter должна быть оформлена как отдельный brief-файл в директории:

```text
Shelter/04_DEVELOPMENT/
```

В локальном репозитории это соответствует пути:

```text
docs/drive/Shelter/04_DEVELOPMENT/
```

Нельзя ставить Codex значимую dev-задачу только сообщением в чате. Чат может содержать краткое указание, но источником задачи должен быть brief-файл.

Сессия, которая готовит постановку для Codex, обязана в финальном ответе пользователю дать:

1. путь до brief-файла;
2. рекомендуемый уровень рассуждений для запуска Codex.

Допустимые уровни рассуждений:

- низкий;
- средний;
- высокий;
- очень высокий.

Рекомендация по выбору уровня:

- **низкий** — маленькая локальная правка, форматирование, простое обновление документа, очевидный bugfix без архитектурных решений;
- **средний** — обычная dev-задача по уже ясному контракту, небольшой feature slice, импорт ассетов, новый smoke command, простая интеграция;
- **высокий** — сложная реализация с несколькими файлами, состояниями, edge cases, Godot/runtime поведением, сохранением backwards compatibility или несколькими проверками;
- **очень высокий** — архитектурно рискованная задача, новый runtime/pipeline, сложное окно/platform behavior, deep debugging, конфликтующие документы, high-risk implementation или задача, где ошибка может сильно повлиять на product/dev direction.

Brief-файл для Codex должен по возможности содержать:

- цель задачи;
- обязательные источники для чтения;
- scope / out of scope;
- acceptance criteria;
- stop conditions;
- ожидаемые файлы/зоны изменений;
- проверки, которые нужно запустить;
- требования к обновлению `docs/repo/status/CODEX_STATUS.md`;
- рекомендуемый уровень рассуждений.

Если задача возникла из RFC / Producer synthesis / Art Director review / Game Designer contract, brief должен ссылаться на соответствующий источник, а не пересказывать его неформально.

## 10. Changelog

### 2026-07-10 — ChatGPT Work task handoff

- Updated prompts to use direct local-project access.
- Clarified that separate Work tasks coordinate through project documents, not assumed neighboring-session memory.
- Switched the Codex prompt to `CODEX_CURRENT_STATUS.md` for bootstrap.

### 2026-06-29 — v2 Codex brief rule

- Добавлено правило: значимые задачи Codex ставятся через brief-файлы в `docs/drive/Shelter/04_DEVELOPMENT/`.
- Добавлено требование финального ответа: путь до brief-файла и уровень рассуждений Codex.

### 2026-06-29 — v1 created

- Введён процесс Quick Role Check / Cross-role RFC / Decision Council.
- Зафиксировано, что роли работают через общий локальный документ, а не через пересказ друг друга.
- Добавлены короткие стартовые промты для Game Designer, Art Director, Codex, Producer и PM.
