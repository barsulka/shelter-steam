# 03_OPEN_QUESTIONS — Shelter

Обновлено: 2026-07-22
Статус: active current register
Владелец: Project Manager / Producer

Этот файл содержит только вопросы, способные изменить текущий или следующий
milestone. Закрытые обсуждения остаются в Git history; принятые ответы переходят
в `02_DECISIONS.md` и соответствующий current contract.

Допустимые статусы: `open`, `partially_resolved`, `deferred`, `needs_research`.

## 1. Active open questions

#### OQ-Steam-003 — Пройдёт ли selected H финальный live Visual Shell Lock?

Статус: `open`
Владелец: `User / Codex / Art Director / Project Manager`

Selected H GRID32 уже имеет static `USER_ACCEPTED / PASS`. Открыт только live
gate: faithful runtime на min/default/max размерах окна и всех четырёх zoom,
каждый checkpoint в парах `GRID + CLEAN`; финальный verdict выдаёт пользователь.

#### OQ-Steam-004 — Какой существующий дом первым получает rooms panel?

Статус: `deferred`
Владелец: `User / Game Designer / Art Director`

Выбор нужен после Visual Shell Lock и до реализации rooms step. До выбора прочие
здания без room visual не реагируют на click; новая механика или новый asset из
этого вопроса не следуют.

#### OQ-Browser-001 — Каков будущий Browser Extension scope?

Статус: `deferred`
Владелец: `Producer / future technical owner`

Browser Extension, новый MCP и инфраструктурные расширения заморожены до
приятного playable Steam shell. Перед активацией потребуются отдельные product,
privacy, platform и ethical decisions.

#### OQ-Mobile-001 — Каков будущий Mobile scope?

Статус: `deferred`
Владелец: `Producer / future technical owner`

Mobile не входит в текущую последовательность Visual Shell Lock → Interactive
Shelter Shell и не блокирует её.

## 2. Partially resolved questions

Нет. Частично решённый вопрос нужно либо сузить до конкретного активного остатка
в разделе 1, либо перенести принятые части в decisions/current contracts.

## 3. Resolved questions

В checkout не ведётся архив закрытых вопросов. Он доступен через Git history.
