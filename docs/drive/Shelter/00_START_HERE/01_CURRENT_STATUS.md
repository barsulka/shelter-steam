# 01_CURRENT_STATUS

Обновлено: 2026-06-30

## Кратко о проекте

Shelter — группа добрых приложений/игр вокруг темы помощи собакам и приютам.

Планируемые продукты:

1. Desktop/Steam idle-игра для Windows/macOS.  
2. Мобильная idle/farm-игра.  
3. Браузерное расширение: «посмотри рекламу — накорми собак».

## Текущий этап

Проект находится на этапе организации базы знаний, ролей, источников и рабочего процесса между ChatGPT-сессиями, Google Drive и будущим GitHub/Codex.

## Текущие приоритеты

1. Зафиксировать структуру Google Drive.  
2. Настроить правила проекта для ChatGPT.  
3. Подготовить GitHub repo и `AGENTS.md` для Codex.  
4. Перенести/разобрать текущие референсы и образцы.  
5. Сформировать первые продуктовые документы по трём продуктам.

## Уже обсуждённые референсы

- Desktop-референс: минималистичная always-on-top полоска/поле, настоящая прозрачность, Windows/macOS, кнопка скрытия интерфейса.  
- Idle/farm-референс: медленные физические действия работников/персонажей, которые ногами идут к задачам и выполняют их видимо для игрока.

## Зафиксированные продуктовые решения

- 2026-06-24: для Browser Extension принят core loop D-008 — “спонсорская ферма → производство корма → отправка фургона в приют”. Формат: Chrome new-tab top-down idle farm со строкой поиска, крупным sponsorship/ad block и этичной связью рекламного просмотра с отправками корма. Эмоциональный центр — собаки с ролями, характерами, домиками и навыками.

- 2026-06-24: для Steam/Desktop принят core structure D-009 — “горизонтальный собачий производственный кооператив”. Формат: sidescroll always-on-top полоска для Windows/macOS, cozy idle production strip + dog community sim. Собаки выращивают/получают мирные ингредиенты, готовят корм, фасуют, складируют и отправляют фургоном в партнёрские приюты.

- 2026-06-24: для собак принято системное правило D-010 — врождённые/неизменяемые особенности отделяются от изменяемых/экипируемых/приобретённых особенностей. Изменяемые особенности могут усиливать индивидуальность собаки, но не стирать её. Собака — персонаж, а не набор оптимизируемых статов.

- 2026-06-25: для визуального направления принят D-011 — Visual Direction Candidate A: Cozy Modular Diorama. Это основное направление-кандидат для проверки: уютная модульная собачья диорама с двумя проекциями, side/cutaway для Steam/Desktop и top-down / 3⁄4 для Browser Extension. До финального утверждения обязательны style board, readability test на 96 / 144 / 216 px, оценка production scope и проверка совместимости Steam + Browser.

- 2026-06-25: по D-011 / Steam Overlay Main Strip зафиксирован результат Asset Pack 1 v1: exploration полезен, но production pack не утверждён. Введено правило asset taxonomy: каждый overlay-ассет сначала классифицируется как Building / Utility Prop / Dog Action Sprite. Utility Props запрещено превращать в домики; здания должны быть редкими якорями, а не основой каждого функционального объекта.

- 2026-06-25: по D-011 сформирована `STEAM_OVERLAY__Approved_Library_v1` и проведён `STEAM_OVERLAY__Readability_Pass_216_144_96_v1`. Library v1 включает Mill v2, Storage v2, Kitchen v2.1, Water Station v2, Decor Workshop v2 и три dog action sprites. Readability result: 216 px — PASS for all, 144 px — PASS for all, 96 px — PASS/PARTIAL PASS без hard failures.

- 2026-06-25: принято product/world-structure решение D-012 — Steam/Desktop и Browser Extension являются двумя разными частями одного собачьего мира. Browser Extension — настоящая top-down ферма, откуда ресурсы уходят в большой мир; Steam/Desktop — кооператив/мастерская, куда ресурсы приезжают и где из них делают корм, аксессуары, одежду, игрушки, лежанки, наборы помощи и отправки в приюты. На MVP связь narrative-only, без обязательной технической синхронизации и без наказания за игру только в один продукт.

- 2026-06-25: принято product/game-design решение D-013 — в Steam/Desktop не делаем классический видимый фермерский цикл “посадил → полил → собрал”. Сырьевые ресурсы добываются через off-screen поездки собак на внешние фермерские локации: маршрут + транспорт + собака + пассажиры + особенности определяют длительность, вместимость и шанс дополнительных находок; награды физически приезжают и выгружаются в кладовую.  

- 2026-06-29: принято process / role-boundary решение D-014 — уточнены границы Game Designer vs Art Director vs Producer / PM и введено правило рабочих roadmaps для Game Designer, Art Director, Codex и PM. Game Designer остаётся в зоне mechanics/economy/progression/UX-logic и может касаться визуала только как gameplay constraints; Art Director отвечает за visual direction, art bible, prompts, readability и asset production rules.

- 2026-06-29: принято process решение D-015 — введён `04_COLLABORATION_PROTOCOL` для межролевых обсуждений через Quick Role Check / Cross-role RFC / Decision Council. Создан первый Cross-role RFC: `2026-06-29__cross_role_rfc__codex_task_boundaries_steam_vertical_slice.md` для согласования границ задач Codex с Game Designer и Art Director.

- 2026-06-29: принято implementation-boundary решение D-016 — Producer synthesis первого Cross-role RFC принял границы задач Codex для Steam Vertical Slice. Codex может самостоятельно выбирать техническую форму, debug tooling и neutral placeholders, но не может менять gameplay contracts, visible physical steps, object taxonomy, visual direction, player-facing UI meaning, product scope или ethical boundaries. `STEAM_DESKTOP__Codex_Implementation_Brief__Vertical_Slice_v1.md` синхронизирован с D-016.

- 2026-06-29: принято process решение D-017 — все значимые задачи Codex должны ставиться только через brief-файлы в `docs/drive/Shelter/04_DEVELOPMENT/`; сессия, которая готовит постановку, обязана дать пользователю путь до brief-файла и рекомендуемый уровень рассуждений Codex: низкий, средний, высокий или очень высокий.

- 2026-06-29: принято product/process решение D-018 — Steam Vertical Slice разделён на gameplay proof и visual proof. Gameplay proof считается достаточным, чтобы Game Designer перешёл к systems branch; visual proof / readability / visual acceptance остаются открытыми и переданы Art Director. Создан `STEAM_DESKTOP__Game_Systems_Roadmap_v1.md`. Первоначальный Systems Simulator brief заменён на active Codex brief `STEAM_DESKTOP__Codex_Brief__Godot_State_Connector_v0.md`, потому что Godot должен оставаться source of truth для live game state.

- 2026-06-30: принято product/process решение D-019 — Game Systems ветка Game Designer уточнена как R-09..R-16, а Game Design Systems Workbench должен развиваться поверх live Godot runtime, State Connector, Control Connector and Viewport Capture API. Отдельный standalone simulator не строим; Godot остаётся source of truth.

- 2026-06-30: принято project philosophy решение D-020 — создан `03_PROJECT_PHILOSOPHY.md` / Shelter Constitution. Главный принцип: Shelter делает богаче жизнь, а не склад; любая система должна сначала объяснять, как делает жизнь кооператива интереснее, и только потом — какие игровые бонусы создаёт. D-020 дополнено вторым guardrail: Shelter — это производственный кооператив, в котором живут собаки; производство остаётся ядром, а жизнь собак делает это ядро живым, но не заменяет его.

## Текущие ограничения

- Project Philosophy: Shelter делает богаче жизнь, а не склад.
- Shelter — это производственный кооператив, в котором живут собаки; производство — ядро, жизнь собак делает это ядро живым.
- Любая система должна сначала объяснять, как делает жизнь кооператива интереснее, и только потом — какие игровые бонусы создаёт.
- Никаких боёв, PvP, боссов, монстров, арен, агрессивной соревновательности.  
- Благотворительность — добровольная, прозрачная, этически совместимая.  
- Проект должен оставаться тёплым, спокойным и добрым.

## Следующий лучший шаг

Следующий Game Designer шаг: Game Systems roadmap R-09..R-16 завершён на уровне v1 design contracts. Следующее действие — согласовать с Producer, нужно ли готовить первый Codex brief для Workbench state schema expansion или перейти к новой Game Designer roadmap-ветке.

Следующий Art Director шаг: закрывать visual proof Steam Vertical Slice — capture review, readability 216 / 144 / 96, dog/action silhouettes, placeholder quality, UI visual hierarchy, strip composition and Dog Shape Pack v1.

Следующий dev/Codex шаг: не создавать standalone simulator. Будущие Workbench expansions должны идти через отдельные Codex briefs в `docs/drive/Shelter/04_DEVELOPMENT/` and extend the live Godot State Connector / Control Connector / Viewport Capture API only after Game Designer defines the relevant systems contracts.
