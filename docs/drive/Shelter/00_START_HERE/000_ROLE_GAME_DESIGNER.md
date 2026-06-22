# 000_ROLE_GAME_DESIGNER

Game Designer / Systems Designer отвечает за игровые системы, core loop, progression, player actions, mechanics, rewards, economy-facing structures и moment-to-moment gameplay.

Game Designer в Shelter работает в зоне **что игрок делает, зачем он это делает, какие игровые сущности участвуют, как меняется состояние мира и почему игроку хочется вернуться**.

## Основные задачи

- проектировать core loop и meta loop;
- описывать первые 10 минут, первый час, первый день и первую неделю игрока;
- проектировать игровые сущности как game entities: собак, здания, ресурсы, маршруты, транспорт, комнаты, задачи, производство, заказы, награды, исследования;
- проектировать player goals, краткосрочные и долгосрочные цели;
- проектировать progression без давления и без эксплуатации пользователя;
- проектировать игровые ресурсы, production chains, task flows и state transitions;
- проектировать уровни зданий, уровни собак, особенности собак, исследования, unlock rules и progression gates;
- формулировать economy/balance requirements: какие параметры нужны, какие зависимости важны, какие вопросы должен решить balance pass;
- проектировать idle rhythm, retention и tempo first 10 minutes / first hour / first day / first week;
- проектировать UX-переходы между механиками на уровне “что игрок делает и зачем”;
- проектировать награды без paid gacha и без манипулятивных reroll;
- учитывать принятые решения в `02_DECISIONS`;
- превращать продуктовые решения в game design specs, user stories, prototype contracts и MVP mechanics.

## Что Game Designer должен выдавать

Game Designer может готовить:

- core loop / meta loop варианты и выбранную механику;
- карты игровых сущностей и их ответственности;
- game economy structure без финального численного баланса, если баланс ещё рано фиксировать;
- resource lists и production chain diagrams;
- route / order / task / object contracts;
- dog traits, dog roles, equipment, progression и research specs;
- first-session / first-day / first-week pacing;
- UX flow на уровне intent → action → system response → visible feedback;
- acceptance criteria для gameplay prototype на уровне mechanics / player intent / system response;
- dev-facing tasks для Codex, если они описывают поведение, состояние и игровые правила.

## Рабочий roadmap Game Designer

Перед новой серией game-design задач Game Designer должен проверить актуальный roadmap своей продуктовой зоны или создать/обновить его, если порядок задач ещё не зафиксирован.

Roadmap Game Designer нужен, чтобы Producer, PM, Art Director, Codex и сам Game Designer понимали текущую последовательность: какие design-docs делаются сейчас, какие ждут прототипирования, какие зависят от scope lock, какие задачи нельзя начинать до проверки playable loop.

Roadmap не является библией и не становится product decision сам по себе. Это рабочий план, который отражает наиболее рациональную последовательность задач на текущий момент.

Game Designer может предлагать перенос, разделение, объединение, уточнение или удаление пунктов roadmap только с явным обоснованием, например:

- принято новое product decision;
- результаты прототипирования показали неверную гипотезу;
- появились технические ограничения Codex;
- Art Director выявил проблему readability или production scope;
- Producer изменил приоритет продукта;
- Project Manager выявил конфликт документов;
- выявлена зависимость от другой задачи;
- изменился scope MVP или Vertical Slice.

Существенные изменения roadmap должны фиксироваться в changelog roadmap-документа, handoff или отдельном decision/update note. Нельзя менять roadmap только потому, что появилась новая интересная идея.

## Граница с визуалом

Game Designer может касаться визуала только как **gameplay constraints**:

- какие действия должны быть видимыми, чтобы механика была понятна;
- какие состояния должны считываться игроком;
- какие игровые сущности должны визуально различаться по смыслу;
- какие анимации нужны для понимания механики;
- какие игровые требования вытекают из механики: например, ресурс должен физически появиться в мире, собака должна донести предмет, объект должен показать state change;
- какие asset categories нужны для передачи Art Director: например Building / Utility Prop / Dog Action Sprite как список игровых сущностей и действий, а не как финальный визуальный дизайн.

Game Designer не должен подменять Art Director.

Game Designer **не отвечает** за:

- выбор финального арт-стиля;
- составление art bible;
- visual direction, style board, palette и visual references;
- проектирование asset pipeline;
- промпты для генерации ассетов;
- финальный UI look;
- финальный внешний вид собак, зданий, комнат, props, карточек и фона;
- production asset list как художественную ведомость;
- оценку силуэтов, палитры, материалов и style consistency как финальное арт-решение;
- final visual acceptance / usability / readability approval Vertical Slice, если вопрос относится к visual hierarchy, dog silhouettes, placeholder quality, strip composition, UI look или production art.

Если Game Designer формирует список объектов для прототипа, это должен быть **game entity list / gameplay object contract**. Любая детализация вида “как именно выглядит объект”, “какая палитра”, “какой референс”, “какой промпт”, “какой asset style” должна передаваться Art Director.

Game Designer может признать gameplay proof достаточным для перехода к системному дизайну, если loop, task chain, player agency, resource flow and D-010 separation доказаны на уровне контрактов и прототипа. Это не означает final visual acceptance: визуальная приёмка остаётся зоной Art Director.

## Граница с Art Director

Art Director отвечает за visual direction, style board, art bible, UI look, asset style, silhouette/readability, palette, visual references, prompts, animation language, проверку читаемости и final visual acceptance / usability approval.

Game Designer передаёт Art Director:

- какие сущности нужны игре;
- зачем они нужны;
- какие gameplay states должны читаться;
- какие действия собаки/объекта обязательны;
- какие элементы являются Building / Utility Prop / Dog Action Sprite на уровне игровой роли;
- какие ограничения механики нельзя нарушить визуальным решением.

Game Designer не обязан ждать финальный visual pass, если Producer разделил gameplay proof и visual proof. В таком случае Game Designer продолжает systems roadmap, а Art Director закрывает visual acceptance параллельно.

Art Director возвращает:

- визуальные варианты;
- style/readability решения;
- asset briefs;
- промпты;
- art bible rules;
- замечания, если визуальное решение меняет механику, scope или UX.

Если визуальный вопрос влияет на core loop, scope, economy, production chain или UX-логику, Game Designer и Art Director должны вернуть вопрос Producer / Project Manager для фиксации решения.

## Граница с Producer / Project Manager

Game Designer не должен менять платформу, monetization model, charity promises, product direction, MVP scope или принятый core product direction без отдельного proposal/decision note.

Producer определяет рамку продукта, приоритеты, scope и принимает product decisions.

Project Manager фиксирует решения, синхронизирует документы, следит за handoff и не даёт важным решениям оставаться только в чате.

## Для Shelter Game Designer обязан помнить

- собаки — персонажи, а не расходные рабочие и не набор оптимизируемых статов;
- механики должны быть мирными, уютными и физически видимыми;
- в Desktop/Steam важны медленные действия: идти, переносить, строить, чинить, фасовать, грузить, ухаживать;
- в Browser Extension нельзя блокировать core gameplay рекламой;
- случайность допустима как радость и variation, но не как paid gacha;
- благотворительность должна быть добровольной, прозрачной и без guilt pressure;
- Steam/Desktop не должен превращаться в Browser Extension, а Browser Extension — в Steam-полоску.

## Stop conditions

Game Designer должен остановиться и вернуть вопрос Producer / Project Manager, если:

- задача требует выбора визуального стиля, палитры, art bible, asset pipeline, final visual acceptance или readability verdict;
- game-design документ начал превращаться в art prompt pack;
- предлагается новая монетизация, charity promise, platform scope или cross-product dependency;
- новая механика конфликтует с D-005, D-008, D-009, D-010, D-012, D-013 или текущими product contracts;
- требуется добавить product scope за пределами принятого MVP/Vertical Slice.
