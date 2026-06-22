# 2026-06-29 — Producer handoff — role boundaries and working roadmaps

## Дата

2026-06-29

## Роль сессии

Producer проекта Shelter.

## Что делали

Восстановили контекст через локальные документы репозитория Shelter, проверили границы Game Designer / Art Director / Producer / Project Manager и внесли process-уточнение о рабочих roadmaps.

Основной повод: Steam Game Designer session начала уходить в сторону графики, ассетов и visual production, что должно оставаться зоной Art Director / Visual Designer.

## Ключевые выводы

- Роль Game Designer уже была частично ограничена от art direction, но нуждалась в более явном рабочем правиле по roadmap и в подтверждении, что visual work допустим только как gameplay constraints.
- Роль Art Director корректно содержит visual direction, style board, art bible, prompts, readability и asset production rules; добавлено симметричное правило visual roadmap.
- Роль Producer корректно отвечает за рамку, приоритеты, scope и role boundaries; добавлено явное roadmap governance.
- Роль Project Manager корректно отвечает за документы и контроль границ ролей; добавлено roadmap coordination.
- Предложение Game Designer про roadmap принято, но расширено до Game Designer, Art Director, Codex и Project Manager. Producer не обязан начинать каждую сессию с отдельного roadmap-документа, но управляет roadmaps, если они затрагивают priority/scope/Vertical Slice/cross-role dependencies.

## Принятые решения

Новых продуктовых решений по играм не принималось.

Принято process / role-boundary решение D-014:

- Game Designer отвечает за mechanics, core loop, economy structures, resources, production chains, progression, dog traits, research, balance requirements, player goals, retention, pacing и UX-logic.
- Game Designer может касаться визуала только как gameplay constraints: что должно быть видно, какие состояния должны считываться, какие сущности должны различаться, какие анимации нужны для понимания механики.
- Game Designer не выбирает финальный art style, не пишет prompts, не ведёт art bible, не выбирает palette и не проектирует asset pipeline.
- Art Director отвечает за visual direction, style board, art bible, UI look, asset style, palette, silhouette/readability, visual references, prompts, animation visual language, asset production rules и visual QA.
- Для Game Designer, Art Director, Codex и Project Manager новая серия задач должна начинаться с проверки актуального roadmap своей зоны или создания/обновления roadmap, если последовательность задач ещё не зафиксирована.
- Roadmap — живой рабочий план, а не библия и не самостоятельный product decision. Существенные изменения roadmap требуют явного обоснования и changelog / handoff / decision-update note.

## Открытые вопросы

- Для Codex не требуется отдельный срочный follow-up, потому что `AGENTS.md` и `000_ROLE_CODEX.md` обновлены. При следующей Codex-сессии достаточно перечитать `PROJECTS_RULES.md`, `AGENTS.md`, `000_ROLE_CODEX.md` и учитывать D-014.
- Можно позже добавить отдельный Browser Extension game-design roadmap, если начнётся новая серия задач по Browser Extension.
- Можно позже добавить отдельный Art Director visual roadmap, если начнётся новая серия style board / asset pack / readability задач.

## Ссылки / источники

Прочитаны и использованы:

- `PROJECTS_RULES.md`
- `AGENTS.md`
- `README.md`
- `docs/repo/status/CODEX_STATUS.md`
- `docs/drive/Shelter/00_START_HERE/00_PROJECT_INDEX.md`
- `docs/drive/Shelter/00_START_HERE/01_CURRENT_STATUS.md`
- `docs/drive/Shelter/00_START_HERE/02_DECISIONS.md`
- `docs/drive/Shelter/00_START_HERE/03_OPEN_QUESTIONS.md`
- `docs/drive/Shelter/00_START_HERE/000_ROLE_PRODUCER.md`
- `docs/drive/Shelter/00_START_HERE/000_ROLE_PROJECT_MANAGER.md`
- `docs/drive/Shelter/00_START_HERE/000_ROLE_GAME_DESIGNER.md`
- `docs/drive/Shelter/00_START_HERE/000_ROLE_ART_DIRECTOR.md`
- `docs/drive/Shelter/00_START_HERE/000_ROLE_CODEX.md`
- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Game_Designer_Session_Brief.md`
- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Game_Design_Roadmap_v1.md`
- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Vertical_Slice_Scope_Lock_v1.md`
- `docs/drive/Shelter/02_PRODUCTS/03_BROWSER_EXTENSION/BROWSER_EXTENSION__Game_Designer_Session_Brief.md`

## Что обновлено в документах

Обновлены напрямую:

- `PROJECTS_RULES.md` — добавлено общее cross-role правило working roadmap.
- `AGENTS.md` — добавлен раздел `Working roadmaps` для Game Designer, Art Director, Codex и Project Manager.
- `docs/drive/Shelter/00_START_HERE/000_ROLE_GAME_DESIGNER.md` — добавлен раздел `Рабочий roadmap Game Designer` и усилена граница с визуалом через D-014.
- `docs/drive/Shelter/00_START_HERE/000_ROLE_ART_DIRECTOR.md` — добавлен раздел `Рабочий roadmap Art Director`.
- `docs/drive/Shelter/00_START_HERE/000_ROLE_CODEX.md` — добавлено правило implementation roadmap/status и stop-condition против product/game/art решений.
- `docs/drive/Shelter/00_START_HERE/000_ROLE_PROJECT_MANAGER.md` — добавлен раздел `Roadmap coordination`.
- `docs/drive/Shelter/00_START_HERE/000_ROLE_PRODUCER.md` — добавлен roadmap governance.
- `docs/drive/Shelter/00_START_HERE/02_DECISIONS.md` — добавлено D-014.
- `docs/drive/Shelter/00_START_HERE/01_CURRENT_STATUS.md` — обновлена дата и добавлена строка про D-014.
- `docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Game_Designer_Session_Brief.md` — добавлена обязанность читать game-design roadmap / scope docs перед новой серией задач.
- `docs/drive/Shelter/02_PRODUCTS/03_BROWSER_EXTENSION/BROWSER_EXTENSION__Game_Designer_Session_Brief.md` — добавлена обязанность сверяться с Browser Extension roadmap, если он существует, или создать его перед новой серией задач.
- Этот handoff обновлён.

## Следующий лучший шаг

Role boundary cleanup завершён.

Следующий рабочий шаг для Steam Game Designer: продолжать по `STEAM_DESKTOP__Game_Design_Roadmap_v1.md` и не начинать новые визуальные/asset задачи. Если нужна визуальная детализация, Game Designer формулирует gameplay constraints и передаёт их Art Director.

Следующий рабочий шаг для Art Director: при новой visual-серии создать или обновить visual roadmap, чтобы style board / readability / asset pack / prompt system не смешивались с game-design roadmap.
