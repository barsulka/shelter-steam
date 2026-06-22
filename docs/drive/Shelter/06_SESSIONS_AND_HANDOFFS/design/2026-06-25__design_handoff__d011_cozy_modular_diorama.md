# Design handoff — D-011 Cozy Modular Diorama

Дата: 2026-06-25  
Роль сессии: Art Director / Visual Designer  
Продукты: Steam/Desktop + Browser Extension

## Что делали

1. Восстановили проектный контекст по Drive:  
   - 00_PROJECT_INDEX  
   - 01_CURRENT_STATUS  
   - 02_DECISIONS  
   - STEAM_DESKTOP__Game_Designer_Session_Brief  
   - BROWSER_EXTENSION__Game_Designer_Session_Brief  
   - 03_DESIGN structure

2. Сравнили 5 визуальных направлений для Shelter:  
   - Cozy Modular Diorama  
   - Readable Cozy Pixel  
   - Soft Storybook Farm  
   - Toybox / Felt & Wood  
   - Clean Vector Cozy

3. Рекомендовали Cozy Modular Diorama как основной кандидат.

4. Получили продюсерское принятие направления как Candidate A, не как финальный визуал навсегда.

5. Зафиксировали D-011 в decision log и вынесли рабочие документы в дизайн-зону.

## Ключевые выводы

Cozy Modular Diorama лучше всего соединяет Steam/Desktop и Browser Extension:

- Steam/Desktop получает side/cutaway production strip: горизонтальные модули, комнаты, производственные зоны, видимые действия собак.  
- Browser Extension получает top-down / 3⁄4 ферму: грядки, дорожки, домики, sponsor card, кормоцех, фургон.  
- Собаки остаются эмоциональным центром: жители, персонажи, носители характера.  
- Комнаты могут стать главным визуальным носителем личности, но не должны превращаться в обязательную min-max систему.

## Принятые решения

### D-011 — Visual Direction Candidate A: Cozy Modular Diorama

Для Shelter принят Cozy Modular Diorama как основное визуальное направление-кандидат для проверки и разработки style board.

Формула: уютная модульная собачья диорама — маленький кооператив из комнат, теплиц, кухонь, складов, домиков и фургонов, где собаки-жители медленно и видимо делают доброе общее дело.

Статус: кандидат принят для проверки. Это не финальный стиль навсегда.

До финального утверждения обязательны:

- style board;  
- readability test на 96 px, 144 px и 216 px;  
- проверка production scope;  
- проверка совместимости Steam + Browser;  
- проверка поддержки большого количества пород собак.

## Открытые вопросы

1. Является ли 96 px обязательной минимальной высотой Steam-полоски или только stress test?  
2. Насколько Browser farm должна быть строго top-down, а насколько 3⁄4 top-down?  
3. Нужны ли отдельные portrait/card версии собак для UI?  
4. Сколько пород нужно проверить до финального утверждения style direction?  
5. Какой минимальный animation set нужен для MVP: walk / carry / work / idle / rest?  
6. Какой объём комнатного декора допустим на MVP, чтобы не утонуть в ассетах?

## Созданные / обновлённые документы

1. `00_START_HERE/02_DECISIONS` — добавлен D-011.  
2. `00_START_HERE/01_CURRENT_STATUS` — добавлен D-011 и обновлён следующий лучший шаг.  
3. `03_DESIGN/00_VISUAL_DIRECTION/D-011_Cozy_Modular_Diorama_Candidate_A` — создан рабочий visual direction документ.  
4. `03_DESIGN/04_DELIVERABLES/D-011_Style_Board_and_Readability_Test_v0` — создан implementation v0 с тестовыми сценами и промптами.  
5. `06_SESSIONS_AND_HANDOFFS/design/2026-06-25__design_handoff__d011_cozy_modular_diorama` — этот handoff.

## Что обновить дальше

После получения первых визуальных прогонов:

1. Обновить `D-011_Style_Board_and_Readability_Test_v0` фактическими результатами.  
2. Создать или обновить `readability_test_96_144_216_results`.  
3. Вернуться в продюсерский штаб с pass/fail по Candidate A.  
4. Если Candidate A проходит — подготовить более строгий style guide.  
5. Если Candidate A не проходит — сузить стиль или вернуться к альтернативам.

## Следующий лучший шаг

Сделать первый визуальный прогон по 5 тестовым сценам:

1. Steam 01: dog carries food bag.  
2. Steam 02: dog decorates room.  
3. Steam 03: kitchen → mixer → packing chain.  
4. Browser 01: top-down farm.  
5. Browser 02: new-tab layout with sponsor card.

Затем сжать Steam-сцены до 96 / 144 / 216 px и оценить читаемость по pass/fail matrix.
