# Producer handoff — Collaboration Protocol and Codex boundaries RFC

Дата: 2026-06-29

## Роль сессии

Producer проекта Shelter.

## Что делали

Организовали процесс межролевых обсуждений между Game Designer, Art Director, Codex, Producer и Project Manager без копирования длинных промтов между чатами.

Создали общий процессный документ `04_COLLABORATION_PROTOCOL.md` и первый Cross-role RFC по границам задач Codex для Steam Vertical Slice.

## Ключевые выводы

- Копирование длинных промтов между role-сессиями плохо масштабируется и создаёт риск испорченного телефона.
- Для Shelter лучше использовать локальные RFC-документы как общую доску обсуждения.
- Роли не должны притворяться друг другом: draft synthesis допустим, но настоящей позицией роли считается только заполненная секция RFC или явно принятое Producer decision.
- RFC сам по себе не является решением. Решением он становится только после Producer synthesis / user acceptance и записи в долгоживущие документы.

## Принятые решения

Принято process decision D-015:

- межролевые обсуждения ведутся через Quick Role Check / Cross-role RFC / Decision Council;
- общий протокол хранится в `00_START_HERE/04_COLLABORATION_PROTOCOL.md`;
- разовые RFC хранятся в `06_SESSIONS_AND_HANDOFFS/cross_role_sessions/`;
- роли заполняют только свои секции;
- Producer сводит позиции и принимает решение, если оно требуется;
- PM / Knowledge Base Maintainer переносит итог в decision log, role docs, product docs, `AGENTS.md`, status или handoff.

## Открытые вопросы

- Первый RFC `2026-06-29__cross_role_rfc__codex_task_boundaries_steam_vertical_slice.md` ещё не заполнен ролями. Нужны позиции Game Designer, Art Director и Codex.
- После заполнения секций Producer должен сделать synthesis и решить, какие boundaries переносить в Codex implementation brief / role docs / `AGENTS.md`.
- Если итоговый RFC окажется долгоживущим implementation-boundary rule, возможно потребуется отдельное D-016 или update к D-014/D-015.

## Ссылки / источники

Прочитаны и использованы:

- `PROJECTS_RULES.md`
- `AGENTS.md`
- `README.md`
- `docs/drive/Shelter/00_START_HERE/00_PROJECT_INDEX.md`
- `docs/drive/Shelter/00_START_HERE/01_CURRENT_STATUS.md`
- `docs/drive/Shelter/00_START_HERE/02_DECISIONS.md`
- `docs/drive/Shelter/00_START_HERE/000_ROLE_PRODUCER.md`
- `docs/drive/Shelter/00_START_HERE/000_ROLE_PROJECT_MANAGER.md`

Созданы / обновлены:

- `docs/drive/Shelter/00_START_HERE/04_COLLABORATION_PROTOCOL.md`
- `docs/drive/Shelter/06_SESSIONS_AND_HANDOFFS/cross_role_sessions/2026-06-29__cross_role_rfc__codex_task_boundaries_steam_vertical_slice.md`
- `docs/drive/Shelter/00_START_HERE/00_PROJECT_INDEX.md`
- `docs/drive/Shelter/00_START_HERE/01_CURRENT_STATUS.md`
- `docs/drive/Shelter/00_START_HERE/02_DECISIONS.md`
- этот handoff

## Что обновить в документах

На текущем шаге дополнительных обязательных обновлений нет.

После заполнения первого RFC ролями нужно будет обновить:

- `STEAM_DESKTOP__Codex_Implementation_Brief__Vertical_Slice_v1.md`, если будут приняты конкретные implementation boundaries;
- `AGENTS.md` или `000_ROLE_CODEX.md`, если появится общее правило для Codex beyond Steam Vertical Slice;
- `02_DECISIONS.md`, если будет принято новое долгоживущее process / implementation decision.

## Следующий лучший шаг

Запустить три короткие role-сессии по первому RFC:

1. Game Designer заполняет `Game Designer position`.
2. Art Director заполняет `Art Director position`.
3. Codex заполняет `Codex position`.

После этого Producer возвращается к RFC, делает `Producer synthesis`, принимает/отклоняет boundaries и передаёт PM обновить долгоживущие документы.
