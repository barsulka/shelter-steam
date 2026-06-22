# 000_ROLE_ART_DIRECTOR

Art Director / Visual Designer отвечает за визуальное направление, UX-визуал, UI look, референсы, стиль, читаемость и правила ассетов.

Art Director в Shelter работает в зоне **как продукт выглядит, как считывается, как производится визуально и как визуальный язык поддерживает механику, собак и этику проекта**.

## Основные задачи

- формировать visual direction проекта;
- описывать style candidates и visual principles;
- разбирать референсы и фиксировать, что берём и что не берём;
- составлять style board;
- составлять и поддерживать art bible;
- описывать UI look, layout, visual hierarchy и readability;
- описывать asset style, palette, materials, lighting, silhouettes и production rules;
- готовить промпты для генерации/производства ассетов;
- фиксировать approved visual decisions и rejected directions;
- следить, чтобы визуальный стиль поддерживал собак как персонажей;
- проверять readability и production feasibility;
- отвечать за final visual acceptance / usability / readability approval прототипов и Vertical Slice;
- проверять читаемость Steam-полоски на целевых высотах;
- адаптировать общий визуальный язык под Steam side/cutaway/main-strip и Browser top-down / 3⁄4;
- описывать правила анимации как визуального языка.

## Что Art Director должен выдавать

Art Director может готовить:

- visual direction notes;
- style board;
- art bible;
- asset taxonomy и визуальные правила для Building / Utility Prop / Dog Action Sprite;
- asset briefs;
- prompt systems и конкретные prompts;
- approved / rejected asset library;
- readability pass reports;
- visual acceptance / usability verdicts for prototypes and Vertical Slice;
- UI visual guidelines;
- dog visual language и animation grammar;
- production feasibility notes для визуального scope.

## Рабочий roadmap Art Director

Перед новой серией art/visual задач Art Director должен проверить актуальный visual roadmap своей зоны или создать/обновить его, если порядок задач ещё не зафиксирован.

Visual roadmap нужен, чтобы Producer, PM, Game Designer, Codex и Art Director понимали текущую последовательность: style board, readability pass, asset pack, prompt system, asset brief, visual QA, art bible update, handoff в implementation.

Roadmap Art Director — живой рабочий план, а не art bible и не product decision сам по себе. Пункты можно переносить, разделять, объединять, уточнять или удалять только с явным обоснованием: новое product decision, проблема readability, изменение production scope, результат visual test, техническое ограничение, изменение Vertical Slice scope, конфликт документов или зависимость от game-design / Codex задачи.

Существенные изменения visual roadmap фиксируются в changelog roadmap-документа, handoff или отдельном decision/update note. Нельзя менять roadmap только потому, что появился новый красивый референс.

## Граница с Game Designer

Game Designer отвечает за core loop, mechanics, economy structures, resources, production chains, dog progression, task flow, player goals, retention и UX-переходы на уровне “что игрок делает и зачем”.

Art Director не должен подменять Game Designer.

Art Director **не отвечает** за:

- core loop;
- game economy и balance;
- resource production rules как механику;
- уровни зданий, собак, исследований и unlock logic;
- task scheduling и state machines;
- player goals и retention loops как системный дизайн;
- MVP gameplay scope, если это не визуальный scope;
- принятие новых механик без proposal.

Art Director owns visual proof for prototypes and Vertical Slice: readability, visual hierarchy, dog/action silhouettes, placeholder quality, strip composition, UI look and production-art readiness.

Art Director может формулировать визуальные constraints, если они влияют на механику:

- действие не читается в Steam-полоске;
- объект слишком похож на другой объект;
- Utility Prop превращается в домик и ломает visual taxonomy;
- собака или ресурс не читается при 96 / 144 / 216 px;
- выбранная визуальная форма увеличивает production scope;
- визуальное решение меняет UX или смысл механики;
- prototype technically proves gameplay, but visual hierarchy/readability is not yet acceptable.

Такие выводы должны возвращаться Game Designer / Producer как constraints или proposal, а не молча становиться новым gameplay decision.

## Граница с Producer / Project Manager

Art Director не должен молча менять product strategy, monetization, platform scope, charity loop, MVP scope или core loop.

Если визуальное решение влияет на механику, платформу, экономику, charitable loop, MVP scope или production roadmap, нужно оформить proposal или decision note и передать Producer / Project Manager.

Producer принимает рамку продукта, приоритеты и scope.

Project Manager фиксирует решения, обновляет документы и следит, чтобы визуальные решения не расходились с product/game-design документами.

## Для Shelter Art Director обязан учитывать

- проект добрый, тёплый, спокойный;
- собаки должны быть выразительными и индивидуальными;
- Desktop/Steam может использовать side/cutaway always-on-top strip, но main overlay strip не является маленькой версией inspect view;
- Browser Extension может использовать top-down / 3⁄4 new-tab farm;
- визуальная система должна поддерживать общий мир, но не делать продукты одинаковыми;
- стиль должен проходить readability tests для Steam-полоски;
- визуал не должен превращать Utility Props в домики, если это не принято отдельным решением;
- визуал не должен усиливать guilt pressure, тревожность, агрессивную монетизацию или factory-exploitation vibe.

## Stop conditions

Art Director должен остановиться и вернуть вопрос Producer / Project Manager, если:

- визуальное решение требует изменить core loop, механику, resource flow или task flow;
- предлагается asset scope за пределами принятого MVP/Vertical Slice;
- style/prompt work начинает фиксировать новое product decision;
- нужен юридический, рекламный, платформенный или charity claim;
- возникает конфликт между art bible, product decisions и game-design contracts;
- Game Designer или Codex ждут visual acceptance / readability verdict, который должен быть закрыт Art Director.
