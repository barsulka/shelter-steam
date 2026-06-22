# Producer handoff — Codex brief assignment rule

Дата: 2026-06-29

## Роль сессии

Producer / Project Manager проекта Shelter.

## Что делали

Зафиксировали обязательное правило постановки задач Codex: значимые dev-задачи ставятся только через brief-файлы в `docs/drive/Shelter/04_DEVELOPMENT/`.

Также зафиксировали, что сессия, которая готовит постановку для Codex, должна в финальном ответе пользователю указать путь до brief-файла и рекомендуемый уровень рассуждений Codex.

## Ключевые выводы

- Основной подходящий документ для правила — `00_START_HERE/04_COLLABORATION_PROTOCOL.md`, потому что правило относится к межролевому процессу и передаче задач между сессиями.
- Чтобы правило увидели агенты и Codex, короткие операционные формулировки также нужны в `AGENTS.md` и `000_ROLE_CODEX.md`.
- Для долговременной фиксации добавлено решение D-017 в `02_DECISIONS.md` и строка в `01_CURRENT_STATUS.md`.

## Принятые решения

D-017 — Codex tasks must be assigned through 04_DEVELOPMENT brief files.

Правило:

- вся постановка значимых задач Codex — строго через brief-файлы в `docs/drive/Shelter/04_DEVELOPMENT/`;
- нельзя ставить Codex dev-задачу только чатом, устным пересказом или ссылкой на обсуждение;
- сессия, которая готовит задачу, обязана выдать пользователю путь до brief-файла;
- сессия обязана указать уровень рассуждений Codex: низкий, средний, высокий или очень высокий.

## Открытые вопросы

- Нужно ли позже добавить шаблон `TEMPLATE__CODEX_BRIEF.md` в `04_DEVELOPMENT/`. Сейчас правило зафиксировано, но отдельный template не создавался.

## Ссылки / источники

Прочитаны и использованы:

- `PROJECTS_RULES.md`
- `AGENTS.md`
- `docs/drive/Shelter/00_START_HERE/04_COLLABORATION_PROTOCOL.md`
- `docs/drive/Shelter/00_START_HERE/000_ROLE_CODEX.md`
- `docs/drive/Shelter/00_START_HERE/02_DECISIONS.md`
- `docs/drive/Shelter/00_START_HERE/01_CURRENT_STATUS.md`
- директория `docs/drive/Shelter/04_DEVELOPMENT/`

## Что обновлено в документах

Обновлено напрямую:

- `docs/drive/Shelter/00_START_HERE/04_COLLABORATION_PROTOCOL.md`
- `AGENTS.md`
- `docs/drive/Shelter/00_START_HERE/000_ROLE_CODEX.md`
- `docs/drive/Shelter/00_START_HERE/02_DECISIONS.md`
- `docs/drive/Shelter/00_START_HERE/01_CURRENT_STATUS.md`
- этот handoff

## Следующий лучший шаг

При следующей постановке задачи Codex создать или обновить brief в `docs/drive/Shelter/04_DEVELOPMENT/` и в финальном ответе пользователю явно указать:

```text
Codex brief: <path>
Уровень рассуждений: <низкий|средний|высокий|очень высокий>
```
