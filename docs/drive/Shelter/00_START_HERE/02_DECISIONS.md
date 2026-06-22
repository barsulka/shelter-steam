# 02_DECISIONS

Обновлено: 2026-06-30

## Принятые решения

### D-001 — Google Drive — база знаний проекта

Продуктовые документы, исследования, дизайн, логи сессий, финансовые и благотворительные планы хранятся в Google Drive в папке `Shelter/`.

### D-002 — GitHub repo — главный источник для разработки

Код, dev-документация, архитектурные заметки, инструкции сборки/тестов и рабочий статус Codex должны храниться в GitHub-репозитории. Drive может хранить зеркало или ссылку на dev-статус, но для Codex главными остаются документы внутри repo.

### D-003 — Серьёзные сессии начинаются с `00_PROJECT_INDEX`

Любая новая серьёзная ChatGPT-сессия должна начинаться с чтения:

1. `00_PROJECT_INDEX`  
2. `01_CURRENT_STATUS`  
3. `02_DECISIONS`  
4. релевантные документы роли и продукта  
5. последнюю релевантную передачу контекста

### D-004 — Для Codex нужен `AGENTS.md`

В будущем repo должен быть `AGENTS.md` с ограничениями проекта, правилами источников, dev-процессом, ожиданиями по тестам и обязанностями по документации.

### D-005 — Тон и этика продукта

Shelter — добрый, спокойный проект вокруг собак и приютов. Не добавлять в проект давление на пользователя, эксплуатационные механики или агрессивные игровые приёмы. Монетизация и благотворительные сценарии должны быть прозрачными, добровольными и уважительными.

### D-006 — Начальный набор продуктов

Проект состоит из трёх возможных продуктов:

1. Desktop/Steam idle-игра.  
2. Мобильная idle/farm-игра.  
3. Браузерное расширение: «посмотри рекламу → накорми собак».

## Предложено, но ещё не зафиксировано

- Точный стек для мобильной версии и браузерного расширения.  
- Будут ли desktop/mobile/browser одной общей кодовой базой или тремя почти отдельными реализациями.  
- Точная модель отчётности по благотворительности.  
- Точная модель отношений с реальными приютами.

### D-007 — Steam/Desktop: основной движок — Godot

Для Desktop/Steam idle-игры принимаем Godot как основной движок разработки.

Причина решения: текущая продуктовая форма — простая тёплая idle/farm-игра для Windows/macOS, потенциально с минималистичной always-on-top полоской/полем, настоящей прозрачностью, кнопкой скрытия интерфейса и медленными видимыми действиями персонажей. Godot подходит как лёгкий, открытый и достаточно гибкий 2D/desktop-first стек без лишней сложности и без лицензионного риска Unity/Unreal для маленькой команды.

Базовая технологическая гипотеза:  
- Godot 4.x как игровой движок.  
- GDScript для основной игровой логики на старте.  
- C# или GDExtension только там, где появится реальная необходимость: Steamworks, системные window APIs, производительные подсистемы, нативная интеграция Windows/macOS.  
- Steam-версию развиваем отдельно от браузерного расширения; общий слой между продуктами возможен на уровне дизайна экономики, контента, API и отчётности, но не как обязательная единая кодовая база.

Статус: принято как CTO/product decision для Steam/Desktop-ветки. Требует дальнейшего технического spike: прозрачное окно, always-on-top, click-through/скрытие интерфейса, Steamworks, сохранения, сборки Windows/macOS.

### D-008 — Browser Extension: core loop “спонсорская ферма → производство корма → отправка фургона в приют”

Дата: 2026-06-24.

Для Chrome new-tab extension принимаем базовый core loop: пользователь открывает новую вкладку, видит search bar, крупный sponsorship/ad block и живую top-down idle-ферму. Ферма сама производит корм, собаки выполняют видимые мирные работы, спонсорский блок этично помогает копить ресурс отправки, а пользователь короткими визитами собирает результат, выбирает улучшения, помогает собаке или отправляет фургон в приют.

Композиция loop:  
- Основной скелет: спонсорская ферма → производство корма → отправка фургона в приют.  
- Целевой слой: мягкие заявки приютов.  
- Эмоциональный слой: собаки с ролями, характерами, домиками и навыками.  
- Долгосрочный слой: визуальный рост фермы, новые здания, декор, зоны.  
- Микро-визиты: одно необязательное доброе действие на 5–20 секунд.

Этические ограничения: реклама не блокирует core gameplay, не использует guilt pressure, не формулируется как “посмотри рекламу, иначе собаки пострадают”. Правильный тон: “Спасибо, этот просмотр помогает отправлять корм.” Юридическая, privacy, ads SDK, Chrome Web Store и благотворительная отчётность остаются отдельной проверкой.

Статус: принято пользователем как основной core loop browser-extension ветки.

### D-009 — Steam/Desktop: core structure — горизонтальный собачий производственный кооператив

Дата: 2026-06-24.

Для Steam/Desktop-ветки принимаем базовую механическую структуру: не классическая ферма и не холодная фабрика, а горизонтальный собачий производственный кооператив в sidescroll always-on-top полоске для Windows/macOS.

Основная формула: cozy idle production strip + dog community sim.

Игровое ядро: собаки живут в уютном кооперативе, выращивают и получают мирные ингредиенты, готовят корм в маленьком заводике, фасуют его, складируют мешки и отправляют фургоном в партнёрские приюты. Игрок не микроменеджит каждое действие, а мягко организует систему: строит зоны, задаёт приоритеты, выбирает рецепты, назначает подходящих собак, улучшает процессы, украшает комнаты и наблюдает за медленной физической работой.

Скелет механик:  
- Производственная линия: сад/теплица → кладовая ингредиентов → кухня → миксер → сушилка/пресс → фасовка → склад мешков → погрузка/фургон.  
- Эмоциональный слой: собаки-жители с именами, характерами, любимыми работами, комнатами, idle-анимациями и историями.  
- Целевой слой: мягкие плановые поставки в приюты, письма, открытки и благодарности без guilt pressure.  
- Долгосрочный слой: новые здания, исследования, рецепты, маршруты, тележки, декор, комнаты и раскрытие собак.

Ферма остаётся важной частью игры как источник мирных ингредиентов, но не является единственным ядром. Заводик/кооператив — основная форма, потому что он лучше работает в горизонтальной полоске и даёт видимые процессы.

Запрещено: бои, PvP, монстры, боссы, paid gacha, рекламная монетизация в Steam, скотобойня, жестокие мясные цепочки, манипулятивная благотворительность, таймеры вины и эксплуатационный вайб “собак-рабочих”.

Статус: принято пользователем как основное product/game-design решение для Steam/Desktop-ветки.

### D-010 — Dogs: врождённые и изменяемые особенности

Дата: 2026-06-24.

Для всех продуктов Shelter, начиная со Steam/Desktop-ветки, принимаем разделение особенностей собак на два слоя:

1. Врождённые / неизменяемые особенности.  
Это свойства, с которыми собака появляется в игре. Они являются частью её личности и идентичности. Игрок не может их удалить, отобрать, заменить или “перековать”. Пример: собака родилась с особенностью “быстрые лапки” — эта особенность остаётся с ней навсегда.

2. Изменяемые / экипируемые / приобретённые особенности.  
Это внешние или заработанные модификаторы: предметы, уют комнаты, обучение, любимые инструменты, временные привычки, тапочки, ошейники, рабочие аксессуары, декорные эффекты. Их можно добавлять, менять, улучшать или снимать без разрушения личности собаки. Пример: собаке с “быстрыми лапками” можно дать “удобные тапочки”, и она станет ещё быстрее.

Дизайн-правило: изменяемые особенности должны усиливать, оттенять или временно направлять врождённую индивидуальность собаки, но не стирать её. Собака — не набор оптимизируемых статов, а персонаж.

Пример допустимой особенности: “счастливчик” — повышает шанс редкого/легендарного результата в мирных производственных процессах, например при выращивании редкого плода, создании особого декора или приготовлении необычной партии корма. Это не боевая удача и не paid gacha.

Статус: принято пользователем как системное правило для дизайна собак и прогрессии особенностей.

### D-011 — Visual Direction Candidate A: Cozy Modular Diorama

Дата: 2026-06-25.

Для Shelter принимаем Cozy Modular Diorama как основное визуальное направление-кандидат для проверки и разработки style board.

Формула направления: уютная модульная собачья диорама — маленький кооператив из комнат, теплиц, кухонь, складов, домиков и фургонов, где собаки-жители медленно и видимо делают доброе общее дело.

Направление должно поддерживать две проекции:  
1. Steam/Desktop: side/cutaway модули для горизонтальной always-on-top production strip.  
2. Browser Extension: top-down / 3⁄4 ферма для Chrome new-tab idle farm.

Статус решения: кандидат принят как основное направление для проверки, но не финализирован как окончательный визуальный стиль всей группы продуктов.

До финального утверждения обязательны:  
- style board;  
- readability test для Steam-полоски на высотах 96 px, 144 px и 216 px;  
- проверка стоимости производства ассетов;  
- проверка совместимости Steam + Browser;  
- проверка, что стиль поддерживает большое количество пород и индивидуальность собак.

Комната собаки принимается как главный визуальный носитель личности: характер, привязанность, визуальная радость, маленькие мягкие бонусы и поводы возвращаться. Комната не должна становиться обязательной min-max системой силы. Нельзя превращать её в модель “без редкого декора собака неэффективна”.

Для ключевых собак, зданий и материалов визуальная идентичность проектируется так, чтобы её можно было перевести в две проекции. На MVP допускаются упрощения: не все ассеты обязаны сразу иметь полноценные версии для обеих проекций.

Для Browser Extension sponsorship/ad block предварительно трактуется как спокойная “доска партнёра” / sponsor card, встроенная в new-tab layout без давления, guilt pressure и блокировки core gameplay. Это не относится к Steam/Desktop, где рекламная монетизация не проектируется как core loop.

Стиль нельзя финализировать, пока он не прошёл readability test в Steam-полоске на 96, 144 и 216 px.

Статус: принято пользователем как продюсерское решение-кандидат. Мяч передан Art Director / Visual Designer на реализацию style board и readability test.

### D-012 — Shared World: Browser Farm supplies Steam Co-op

Дата: 2026-06-25.

Steam/Desktop и Browser Extension принимаются как две разные части одного собачьего мира, а не как две версии одной и той же фермы.

Формула мира:  
- Browser Extension — настоящая top-down ферма в новой вкладке браузера, где выращиваются, собираются и подготавливаются ресурсы.  
- Steam/Desk

Дополнение от 2026-06-25: после Asset Pack 1 v1 принимается дополнительное правило для Steam Overlay Main Strip.

Перед генерацией или постановкой любого overlay-ассета он должен быть классифицирован как один из трёх типов:

1. **Building / здание** — редкий крупный якорь полоски: dog house, kitchen, storage, delivery van endpoint.  
2. **Utility Prop / функциональный объект** — вспомогательный объект или вертикальная/горизонтальная пауза: мельница, водяная станция, насос, бак, тележка, компост, указатель, фонарь. Utility Props запрещено превращать в домики.  
3. **Dog Action Sprite / действие собаки** — отдельная читаемая собака с объектом: несёт мешок, везёт тележку, поливает, красит доску, клеит ярлык.

Правило: в main overlay здания — редкие якоря. Всё остальное должно быть маленькими функциональными объектами и действиями собак. Если каждая функция превращается в домик, нижняя полоса снова становится плотной декоративной деревней и нарушает D-011.

Asset Pack 1 v1 получает статус: useful exploration, not approved production pack. Prompt system работает по тону, палитре и dog-centered направлению, но требует усиленного запрета “Utility Props must not become houses”.  
top — горизонтальный собачий кооператив/мастерская в sidescroll always-on-top полоске, куда ресурсы приезжают и где из них делают корм, аксессуары, одежду, лежанки, игрушки, наборы помощи и отправки в приюты.

Визуальная и смысловая связь: между фермерскими локациями, кооперативом и приютами ездят собачьи велосипеды, грузовые велосипеды, велосипеды с прицепом, маленькие фургоны и грузовички.

MVP-правило: на старте связь между Steam/Desktop и Browser Extension должна быть narrative-only. Steam не должен требовать установленного браузерного расширения, а Browser Extension не должен быть обязательным условием прогресса в Steam.

Возможная эволюция связи:  
1. MVP: narrative link — в Steam собаки ездят “на ферму”, в Browser игрок видит ту самую ферму, но технически продукты независимы.  
2. Позже: soft connection — открытки, косметические ящики, наклейки, имена фургончиков, общий альбом собак, мягкие отчёты вроде “сегодня твоя ферма отправила 12 ящиков в кооператив”.  
3. Только после доказанного интереса: real sync — общий аккаунт, реальные поставки ресурсов, cross-product events.

Запрещено: жёстко связывать прогресс Steam с установкой Browser Extension, наказывать пользователя за игру только в один продукт или превращать cross-product связь в обязательную воронку.

Статус: принято как product/world-structure решение для связки Steam/Desktop и Browser Extension.

### D-013 — Steam resource trips replace visible crop farming

Дата: 2026-06-25.

В Steam/Desktop не реализуем классический фермерский цикл “посадил → полил → подождал → собрал” как видимое ядро игры. Для sidescroll idle-полоски сырьевые ресурсы добываются через off-screen поездки собак на внешние фермерские локации.

Steam/Desktop остаётся кооперативом/мастерской, а не грядочной фермой. Видимые зоны Steam могут включать парники, цветы, комнатные растения или декоративные мини-уголки, но основной сырьевой farming вынесен за пределы полоски.

Базовая механика поездок:  
- на краю Steam-полоски есть дорожный знак и транспорт;  
- игрок выбирает маршрут, водителя, возможных пассажиров и транспорт;  
- транспорт уезжает за край экрана;  
- у дорожного столба появляется таймер;  
- по возвращении собаки физически выгружают ящики в кладовую, а награда не падает в инвентарь мгновенно.

Прогрессия транспорта:  
велосипед с корзинкой → грузовой велосипед → велосипед с прицепом → маленький фургон → грузовичок.

Маршрут + транспорт + собака + пассажиры + особенности определяют длительность, вместимость, категории наград и шанс дополнительных находок. Примеры маршрутов: Цветочная ферма, Льняные поля, Овсяная ферма.

Рандомная награда допустима, если это не paid gacha: нельзя продавать попытки за деньги, делать платный reroll, давить на игрока или превращать редкую находку в обязательную боль. Игрок должен примерно понимать возможные категории наград; редкие находки — радость, а не обязательный прогресс.

D-010 обязательно применяется к поездкам: врождённые особенности собак задают личный стиль и склонности, а экипировка вроде шлемика, шлейки, корзинки, ошейника, жилета или удобных тапочек может усиливать роль собаки, но не стирать её характер.

Статус: принято как product/game-design решение для Steam/Desktop-ветки.

### D-014 — Role boundaries and working roadmaps

Дата: 2026-06-29.

Для AI-ролей Shelter принято уточнение границ ответственности и правило рабочих roadmaps.

Game Designer отвечает за mechanics, core loop, economy structures, resources, production chains, progression, dog traits, research, balance requirements, player goals, retention, pacing и UX-logic. Game Designer может касаться визуала только как gameplay constraints: какие действия и состояния должны быть видимы, какие сущности должны различаться и какие анимации нужны для понимания механики. Game Designer не выбирает финальный art style, не пишет prompts, не ведёт art bible, не выбирает palette и не проектирует asset pipeline.

Art Director отвечает за visual direction, style board, art bible, UI look, asset style, palette, silhouette/readability, visual references, prompts, animation visual language, asset production rules и visual QA. Art Director может возвращать gameplay constraints, если визуальное решение не читается или ломает production scope, но не меняет core loop, economy, task flow или product scope без proposal / decision.

Producer отвечает за продуктовую рамку, приоритеты, scope, role boundaries, product decisions и cross-role alignment. Project Manager отвечает за синхронизацию документов, decision log, open questions, handoff и контроль того, чтобы roadmaps не подменяли product decisions, art bible, game-design contracts или dev status.

Для Game Designer, Art Director, Codex и Project Manager новая серия задач должна начинаться с проверки актуального roadmap своей зоны или с создания/обновления roadmap, если последовательность задач ещё не зафиксирована. Producer может утверждать или менять roadmaps, если они затрагивают приоритеты, MVP / Vertical Slice scope, sequence of critical work или cross-role dependencies, но не обязан начинать каждую продюсерскую сессию с отдельного roadmap-документа.

Roadmap — живой рабочий план, а не библия и не самостоятельный product decision. Пункты roadmap можно переносить, разделять, объединять, уточнять или удалять только с явным обоснованием: новое product decision, результат прототипирования, техническое ограничение, проблема readability / production scope, изменение приоритета, конфликт документов, новая зависимость или изменение MVP / Vertical Slice scope. Существенные изменения фиксируются в changelog roadmap-документа, handoff или decision/update note.

Статус: принято как process / role-boundary decision и отражено в role-documents, `PROJECTS_RULES.md` и `AGENTS.md`.

### D-015 — Cross-role collaboration via RFC documents

Дата: 2026-06-29.

Для Shelter принят процесс межролевых обсуждений через локальные документы, а не через копирование длинных промтов между чатами.

Введён `04_COLLABORATION_PROTOCOL`, который описывает три уровня коллегиальной работы:

1. **Quick Role Check** — короткая проверка одной или двух ролей по маленькому вопросу.
2. **Cross-role RFC** — отдельный общий документ для обсуждения между Game Designer, Art Director, Codex, Producer и PM.
3. **Decision Council** — более строгий формат для решений, которые могут менять product scope, Vertical Slice scope, art direction, technical direction, monetization, charity promises или relationship between products.

Главное правило: AI-сессия может подготовить draft synthesis, но не должна считать это настоящей позицией другой роли. Роль считается высказавшейся только если она заполнила свою секцию RFC или Producer явно принял решение.

RFC сам по себе не является решением. Результат становится решением только после Producer synthesis / user acceptance и записи в долгоживущие документы: `02_DECISIONS`, product docs, role docs, `AGENTS.md`, status или relevant handoff.

Первый созданный RFC: `06_SESSIONS_AND_HANDOFFS/cross_role_sessions/2026-06-29__cross_role_rfc__codex_task_boundaries_steam_vertical_slice.md`. Его цель — согласовать, какие задачи Codex может делать самостоятельно в Steam Vertical Slice, а какие должен возвращать Game Designer, Art Director или Producer.

Статус: принято как process decision. Первый RFC создан в статусе draft / role review needed.

### D-016 — Steam Vertical Slice: Codex implementation boundaries

Дата: 2026-06-29.

Для Steam/Desktop Vertical Slice принято implementation-boundary решение по первому Cross-role RFC:

`06_SESSIONS_AND_HANDOFFS/cross_role_sessions/2026-06-29__cross_role_rfc__codex_task_boundaries_steam_vertical_slice.md`

Роли Game Designer, Art Director и Codex заполнили свои секции. Producer synthesis принял их как совместимые.

Принятое правило:

> Codex implements contracts and may use technical judgement for prototype implementation, debug tooling and neutral placeholders. Codex must not silently change gameplay contracts, visible physical steps, object taxonomy, visual direction, player-facing UI meaning, product scope or ethical boundaries.

Codex может самостоятельно:

- выбирать внутреннюю Godot-структуру реализации, scene/script split и data representation;
- делать deterministic prototype scheduler / state machine;
- добавлять dev-only debug overlay, state log, semantic labels и smoke commands;
- сжимать timings для debug / smoke / prototype review, если visible steps остаются читаемыми;
- использовать approved semantic placeholders и neutral labeled placeholders для missing assets;
- создавать Steam-local mirrors approved semantic assets с source mapping manifest;
- исправлять баги, где implementation расходится с written contracts.

Codex должен вернуть вопрос Game Designer, если требуется изменить mechanics, task flow, resources, player actions, visible cause-and-effect, Dog Card meaning или acceptance criteria.

Codex должен вернуть вопрос Art Director, если требуется выбрать final visual style, palette, UI look, dog look, production asset style, изменить asset taxonomy, использовать unclear/unapproved assets или продолжать при readability problem, скрывающей gameplay meaning.

Codex должен вернуть вопрос Producer, если требуется изменить Vertical Slice scope, product feature, monetization, charity claim, Browser Extension dependency, cross-product behavior или принять shortcut, меняющий intended player experience.

Уточнение по ассетам: `approved/utility_props/packing_table.png` сейчас отсутствует. Packing Table остаётся обязательным Utility Prop в gameplay scope, но Codex должен использовать labeled Utility Prop placeholder до появления approved semantic asset. Food Mix и Food Bag сейчас имеют combined composite; если gameplay step требует различия Food Mix -> Food Bag, Codex должен использовать separate labeled semantic tokens.

Это решение не добавляет новый scope. Оно уточняет границы реализации уже locked Steam Vertical Slice.

Статус: принято как Steam Vertical Slice implementation-boundary decision. `STEAM_DESKTOP__Codex_Implementation_Brief__Vertical_Slice_v1.md` синхронизирован с этим решением.

### D-017 — Codex tasks must be assigned through 04_DEVELOPMENT brief files

Дата: 2026-06-29.

Для Shelter принято обязательное process rule: вся постановка значимых задач Codex должна оформляться через отдельные brief-файлы в директории:

```text
docs/drive/Shelter/04_DEVELOPMENT/
```

Нельзя ставить Codex dev-задачу только сообщением в чате, устным пересказом или ссылкой на обсуждение. Чат может содержать короткую команду запуска, но источником задачи должен быть brief-файл.

Любая AI-сессия, которая готовит задачу для Codex, обязана в финальном ответе пользователю указать:

1. путь до brief-файла;
2. рекомендуемый уровень рассуждений для запуска Codex.

Допустимые уровни рассуждений:

- низкий;
- средний;
- высокий;
- очень высокий.

Brief-файл для Codex должен по возможности содержать: цель задачи, обязательные источники, scope / out of scope, acceptance criteria, stop conditions, ожидаемые зоны изменений, проверки и требования к обновлению `docs/repo/status/CODEX_STATUS.md`.

Статус: принято как process decision. Правило отражено в `04_COLLABORATION_PROTOCOL.md`, `AGENTS.md` и `000_ROLE_CODEX.md`.

### D-018 — Steam Vertical Slice gameplay proof is enough for Game Designer systems branch

Дата: 2026-06-29.

Для Steam/Desktop принято разделение Vertical Slice proof на два слоя:

1. **Gameplay proof** — loop, task chain, resource flow, player agency, D-010 trait/equipment separation and game-system contract.
2. **Visual proof** — readability, visual hierarchy, dog silhouettes, placeholder quality, strip composition, UI look, production-art readiness and final visual/usability acceptance.

Producer decision: текущий Vertical Slice считается достаточно доказанным на уровне gameplay proof, чтобы Game Designer не блокировался ожиданием финального visual pass и мог перейти к новой ветке systems design.

Это не означает, что Vertical Slice полностью принят как финальный visual/product slice. Visual proof остаётся открытым и передаётся Art Director как его critical path.

Game Designer critical path переносится в:

```text
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Game_Systems_Roadmap_v1.md
```

Art Director продолжает вести:

- final visual acceptance / usability / readability approval Vertical Slice;
- Capture Pack v2 review;
- readability 216 / 144 / 96;
- dog/action silhouettes;
- placeholder quality;
- UI visual hierarchy;
- strip composition;
- Dog Shape Pack v1 and production art pipeline.

Update от 2026-06-29: направление standalone Systems Simulator отменено и заменено на Godot State Connector v0.

Причина: standalone simulator создаёт риск второй независимой модели мира. Для Shelter правильнее сделать интерфейс к реально запущенной Godot-игре, где Godot остаётся source of truth для task flow, dogs, resources, queues and events.

Active Codex brief:

```text
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Godot_State_Connector_v0.md
```

Archived superseded brief:

```text
docs/drive/Shelter/99_ARCHIVE/STEAM_DESKTOP__Codex_Brief__Systems_Simulator_v0__SUPERSEDED_BY_GODOT_STATE_CONNECTOR.md
```

Recommended Codex reasoning level: очень высокий.

Статус: принято как product/process decision. `STEAM_DESKTOP__Game_Design_Roadmap_v1.md`, `STEAM_DESKTOP__Game_Systems_Roadmap_v1.md`, role-documents Game Designer / Art Director and current status updated. Godot State Connector v0 accepted as replacement for Systems Simulator v0.

### D-019 — Game Design Systems Workbench over live Godot runtime

Дата: 2026-06-30.

Для Steam/Desktop принято уточнение systems-direction: Game Designer открывает новую ветку Game Systems, а internal design laboratory развивается как **Game Design Systems Workbench поверх реально запущенной Godot-игры**, а не как standalone simulator.

Принцип:

> Godot runtime is the source of truth. Workbench observes and controls accepted dev surfaces; it does not simulate Shelter independently.

Основание решения:

- Vertical Slice уже имеет product/game contracts, scope lock, task flow, object contract, playtest checklist and playable prototype.
- Codex уже реализовал Godot State Connector, Godot Control Connector and Viewport Capture API.
- Эти инструменты дают более правильную основу для design inspection, чем отдельный HTML/backend simulator.
- Standalone simulator создаёт риск второй независимой модели мира.

Game Designer critical path теперь фиксируется как:

1. R-09 — Dog Progression Model.
2. R-10 — Ability Source Loop.
3. R-11 — Ability Catalog.
4. R-12 — Buildings & Production Chains.
5. R-13 — Laboratory / Research Tree.
6. R-14 — Activities Catalog.
7. R-15 — Economy & Balance Foundations.
8. R-16 — Game Design Systems Workbench.

Game Design Systems Workbench должен развиваться через accepted Codex briefs и расширять:

- State Connector `/state`;
- Control Connector / control page;
- Viewport Capture API;
- design-facing inspection views;
- strictly whitelisted dev controls where explicitly accepted.

Будущие Workbench expansions могут добавлять в `/state` dogs, innate traits, acquired abilities, equipment, current activities, buildings, levels, queues, inputs, outputs, upgrades, activities, research, economy and game event log — но только после того, как Game Designer зафиксирует соответствующие systems contracts.

Visual acceptance Vertical Slice остаётся задачей Art Director and is not a blocker for Game Designer systems work.

Статус: принято как product/process decision. `STEAM_DESKTOP__Game_Systems_Roadmap_v1.md` обновлён под R-09..R-16 and Workbench-over-Godot direction.

### D-020 — Project Philosophy / Shelter Constitution

Дата: 2026-06-30.

Для Shelter принят верхнеуровневый мировоззренческий документ:

```text
docs/drive/Shelter/00_START_HERE/03_PROJECT_PHILOSOPHY.md
```

Это не game-design spec, не механика, не art bible и не balance document. Это project-wide philosophy / constitution, применимая ко всем продуктовым, дизайнерским, техническим, визуальным, монетизационным и благотворительным решениям Shelter.

Главный принцип:

> Большинство idle-игр делают богаче склад.
>
> Shelter делает богаче жизнь.

Расширенная формулировка:

> Shelter — это не игра про оптимизацию производства.
>
> Shelter — это игра про создание места, где собакам хорошо жить, дружить, учиться, отдыхать и помогать друг другу.
>
> Производство, экономика, исследования, развитие, прогрессия и даже монетизация существуют только затем, чтобы эта жизнь становилась богаче, интереснее и уютнее.

Главный фильтр:

> Любая система должна сначала объяснять, как она делает жизнь кооператива интереснее, и только потом — какие игровые бонусы она создаёт. Не наоборот.

Ключевые принципы:

- Shelter — это производственный кооператив, в котором живут собаки.
- Производство — ядро; жизнь собак делает это ядро живым, а не заменяет его.
- Игрок не управляет каждой собакой. Игрок заботится о кооперативе, а собаки живут своей жизнью внутри него.
- Здания ничего не делают сами. Они создают места, где собаки могут жить, работать, учиться, отдыхать и помогать друг другу.
- Idle в Shelter означает: это жизнь собачек, которая течёт своим чередом, а мы можем за ней наблюдать и чуть-чуть ей управлять.

D-020 update от 2026-06-30:

Project Philosophy дополнена guardrail против превращения Shelter в бытовой симулятор / тамагочи.

Принята трёхслойная модель:

1. **Ядро игры** — без этого Shelter перестаёт быть Shelter: маршруты, производство, доставка, развитие собак, кооператив, исследования, здания.
2. **Углубление** — без этого игра остаётся рабочей, но менее живой: комнаты, библиотека, Дом любопытства, уют, отношения, истории, открытки, чай после дороги, наставничество.
3. **Атмосфера** — не влияет на основной игровой цикл, но делает мир любимым: посмотреть в окно, поправить коврик, понюхать дерево, принести игрушку, посидеть рядом, небольшие жесты между собаками.

Тест новой идеи:

> Если мы полностью уберём эту систему, игра останется игрой?

Если нет — это ядро. Если да, но станет менее тёплой — это углубление. Если почти ничего не изменится, кроме атмосферы — это атмосферная система.

Статус: принято как project philosophy / constitution. Документ добавлен в `00_PROJECT_INDEX` and current status.
