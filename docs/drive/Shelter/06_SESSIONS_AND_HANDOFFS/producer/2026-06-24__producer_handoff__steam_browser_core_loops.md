# Producer handoff — Steam/Desktop + Browser Extension core loops

Дата: 2026-06-24

## Роль сессии

Project Manager / Knowledge Base Maintainer проекта Shelter.

## Что делали

Синхронизировали Google Drive knowledge base после двух гейм-дизайн сессий по Steam/Desktop и Browser Extension. Задача была не придумывать новые продуктовые решения, а привести стартовые документы, open questions и session briefs в соответствие с уже принятыми решениями D-008, D-009 и D-010.

## Ключевые выводы

- `02_DECISIONS` уже содержал D-008, D-009 и D-010 в достаточно полной форме.  
- `01_CURRENT_STATUS` отражал D-008, но ещё не отражал D-009 и D-010.  
- `03_OPEN_QUESTIONS` был в старом формате и не разделял закрытые, частично закрытые и открытые вопросы.  
- Steam brief не содержал финального approved outcome по D-009/D-010.  
- Browser Extension brief уже содержал `Approved core loop / D-008` и не противоречил `02_DECISIONS`.

## Принятые решения, которые синхронизированы

### D-008 — Browser Extension core loop

Core loop: “спонсорская ферма → производство корма → отправка фургона в приют”.

Browser Extension — это Chrome new-tab top-down idle farm со строкой поиска, крупным sponsorship/ad block и этичной связью рекламного просмотра с отправками корма. Реклама не блокирует core gameplay и не использует guilt pressure.

### D-009 — Steam/Desktop core structure

Steam/Desktop — не классическая ферма, ужатая в полоску, а горизонтальный собачий производственный кооператив.

Формат: sidescroll always-on-top полоска для Windows/macOS, cozy idle production strip + dog community sim.

Производственная линия: сад/теплица → кладовая ингредиентов → кухня → миксер → сушилка/пресс → фасовка → склад мешков → погрузка/фургон.

### D-010 — Dogs: врождённые и изменяемые особенности

Для собак принято системное правило: есть врождённые/неизменяемые особенности и изменяемые/экипируемые/приобретённые особенности. Изменяемые особенности могут усиливать индивидуальность собаки, но не стирать её. Собака — персонаж, а не набор оптимизируемых статов.

## Обновлённые документы

- `Shelter/00_START_HERE/02_DECISIONS`  
- `Shelter/00_START_HERE/01_CURRENT_STATUS`  
- `Shelter/00_START_HERE/03_OPEN_QUESTIONS`  
- `Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Game_Designer_Session_Brief`

Проверен без необходимости правок:

- `Shelter/02_PRODUCTS/03_BROWSER_EXTENSION/BROWSER_EXTENSION__Game_Designer_Session_Brief`

## Открытые вопросы

- Какой продукт прототипируем первым: Steam/Desktop, Browser Extension или оба параллельно?  
- Какой MVP-scope нужен для Steam/Desktop?  
- Какой MVP-scope нужен для Browser Extension?  
- Будет ли общий backend, общий контент или общая экономика между продуктами?  
- Какая точная модель благотворительной отчётности?  
- Какая точная модель отношений с реальными приютами?  
- Какой стек выбираем для Browser Extension?  
- Для Browser Extension нужна отдельная проверка privacy, ads SDK, Chrome Web Store policies, product placement/sponsorship disclosure и charity claims.

## Следующий лучший шаг

1. Подготовить MVP-scope документы отдельно для Steam/Desktop и Browser Extension.  
2. Синхронизировать dev/Codex repo и `AGENTS.md` с D-009 и D-010.  
3. Для Steam/Desktop запланировать technical spike по Godot: прозрачное окно, always-on-top, click-through/скрытие интерфейса, горизонтальная лента, зоны/блоки.  
4. Для Browser Extension вынести privacy/ads SDK/Chrome Web Store/charity reporting в отдельную research/legal/technical проверку.

## Что нужно передать Codex

Codex/Dev должен учитывать:

- Steam/Desktop делается на Godot 4.x, GDScript на старте; C# или GDExtension только при реальной необходимости.  
- Steam/Desktop core structure — D-009: горизонтальный собачий производственный кооператив, production strip, зоны/блоки, видимые физические действия собак.  
- Системы собак и прогрессии должны учитывать D-010: врождённые особенности нельзя заменять/стирать, изменяемые особенности только усиливают индивидуальность.  
- Steam/Desktop не должен использовать рекламную монетизацию в текущем дизайне.  
- Для Steam/Desktop нужен technical spike по desktop window behavior в Godot: прозрачность, always-on-top, click-through/скрытие интерфейса, производительность.  
- Browser Extension — отдельный продукт с D-008: top-down new-tab idle farm, sponsorship/ad block, производство корма и отправка фургона в приют.  
- Browser Extension требует отдельной privacy/ads/Chrome Web Store/charity claims проверки до реализации рекламной механики.
