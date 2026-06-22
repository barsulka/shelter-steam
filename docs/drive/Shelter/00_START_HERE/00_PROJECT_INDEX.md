# Shelter — индекс проекта

Стартовый индекс проекта. Любой новый чат, дизайн-сессия, продюсерская сессия или dev/Codex-сессия должна начинать восстановление контекста отсюда.

## Читать в первую очередь

1. `00_START_HERE/01_CURRENT_STATUS` — текущее состояние проекта.  
2. `00_START_HERE/02_DECISIONS` — принятые решения.  
3. `00_START_HERE/03_PROJECT_PHILOSOPHY` — философия / constitution Shelter.  
4. `00_START_HERE/04_SHELTER_STRESS_TESTS` — project identity crash tests / проверка, что Shelter не превратился в фабрику или тамагочи.  
5. `00_START_HERE/03_OPEN_QUESTIONS` — открытые вопросы.  
6. `00_START_HERE/04_COLLABORATION_PROTOCOL` — правила межролевых RFC / коллегиальных обсуждений.  
7. Релевантная зона по роли:  
   - Продюсер / гейм-дизайн / исследование рынка → `01_PRODUCT_STRATEGY/`, `02_PRODUCTS/`, `05_RESEARCH/`.  
   - Визуальный дизайн / UX / арт-дирекшен → `03_DESIGN/`, `02_PRODUCTS/`.  
   - Разработка / Codex → `04_DEVELOPMENT/`, GitHub repo, `AGENTS.md`, `docs/status/CODEX_STATUS.md`.

## Продукты

- Desktop/Steam idle-игра для Windows/macOS: `02_PRODUCTS/01_STEAM_DESKTOP/`.  
- Мобильная idle/farm-игра: `02_PRODUCTS/02_MOBILE/`.  
- Браузерное расширение: «посмотри рекламу — накорми собак»: `02_PRODUCTS/03_BROWSER_EXTENSION/`.  
- Общие механики и принципы: `02_PRODUCTS/00_SHARED/`.

## Ключевые ограничения проекта

- Проект про собак, приюты, заботу, помощь и регулярное возвращение пользователя.  
- Project Philosophy: Shelter делает богаче жизнь, а не склад.  
- Любая система должна сначала объяснять, как делает жизнь кооператива интереснее, и только потом — какие игровые бонусы создаёт.  
- Для крупных систем и релизных этапов использовать `04_SHELTER_STRESS_TESTS`: Excel Test, Factory Test, The Sims / Tamagotchi Test, Dog Test, D-020 Test and related identity checks.  
- Игра должна быть простой, тёплой, спокойной, но затягивающей.  
- Не использовать бои, PvP, арены, боссов, монстров, гачу и агрессивный FOMO.  
- Благотворительная механика должна быть добровольной, прозрачной и не манипулятивной.  
- Desktop-версия может использовать минималистичную always-on-top полоску/поле.  
- Важны медленные физически видимые действия работников/персонажей: идти, строить, переносить, поливать, собирать, обслуживать, кормить, чинить, ухаживать.

## Где что хранится

- `01_PRODUCT_STRATEGY/` — видение, аудитория, благотворительная модель, retention, roadmap.  
- `02_PRODUCTS/` — PRD и продуктовые документы по трём продуктам.  
- `03_DESIGN/` — арт-дирекшен, референсы, UI/UX, промпты, ассеты.  
- `04_DEVELOPMENT/` — dev-brief, Codex status, ссылки на repo, архитектурные заметки, QA.  
- `05_RESEARCH/` — рынок, благотворительные приложения/игры, донаты, rewarded ads, платформы, конкуренты.  
- `06_SESSIONS_AND_HANDOFFS/` — логи длинных сессий, handoff и cross-role RFC для восстановления после перегрева контекста.  
- `07_LEGAL_FINANCE_CHARITY/` — юридические, финансовые и благотворительные вопросы, требующие проверки специалистом.  
- `90_INBOX_RAW/` — сырые загруженные материалы до разбора.  
- `99_ARCHIVE/` — архив устаревших материалов.

## GitHub и Codex

Когда появится/доиндексируется репозиторий, добавить сюда ссылку. Для Desktop/Steam-ветки принято решение D-007: основной движок — Godot. Для продуктовой структуры Steam/Browser учитывать D-012 и D-013: общий мир без обязательной MVP-синхронизации, Browser Farm supplies Steam Co-op, Steam resource trips вместо видимого crop farming.

Правило: Codex должен читать `AGENTS.md`, repo `README.md`, `docs/status/CODEX_STATUS.md` и релевантные документы Drive. После значимой dev-задачи Codex обновляет `CODEX_STATUS.md` или выдаёт готовый блок для обновления.

## Последняя передача контекста

2026-06-30: `06_SESSIONS_AND_HANDOFFS/producer/2026-06-30__producer_handoff__project_philosophy` — producer-handoff по D-020: Project Philosophy / Constitution Shelter.

2026-06-29: `06_SESSIONS_AND_HANDOFFS/producer/2026-06-29__producer_handoff__collaboration_protocol_and_codex_rfc` — producer-handoff по D-015: межролевой Collaboration Protocol и первый Cross-role RFC по границам задач Codex для Steam Vertical Slice.

2026-06-25: `06_SESSIONS_AND_HANDOFFS/producer/2026-06-25__producer_handoff__shared_world_resource_trips` — producer-handoff по D-012/D-013: общий мир Browser Farm ↔ Steam Co-op и Steam resource trips вместо видимого crop farming.

Предыдущий дизайн-handoff: `06_SESSIONS_AND_HANDOFFS/design/2026-06-25__design_handoff__steam_overlay_v1_prompt_system` — Steam Overlay Main Strip v1, approved reference и reusable prompt system.
