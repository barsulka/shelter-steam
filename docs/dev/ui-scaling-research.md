# Исследование UI Scaling для desktop companion-окна

Дата: 2026-06-23

## Проблема

Первая tech-demo companion-поля открылась с микроскопическим интерфейсом на
большом hiDPI/macOS-сетапе: мелкий текст, маленькая кнопка Settings и окно
настроек, в которое трудно попасть мышью.

Это не только проблема размера шрифта. В `project.godot` базовый viewport сейчас
задан как `960x540`, а demo принудительно открывает companion-полоску
`1120x220`. При включённом stretch Godot может масштабировать сцену из базового
формата в низкую полоску, из-за чего UI визуально ужимается.

## Как это обычно делают в играх

### Reference resolution

Большинство игровых UI-систем начинается с reference/design resolution:
интерфейс верстается в условных координатах, а потом масштабируется или
адаптируется под реальный экран/окно.

- Unity Canvas Scaler в режиме `Scale With Screen Size` задаёт reference
  resolution: позиции и размеры UI считаются относительно него, а canvas
  масштабируется под текущий экран.
- Unreal UMG использует DPI scaling rules и curve: проект выбирает правило
  вроде shortest side / longest side / horizontal / vertical, а затем кривая
  переводит размер viewport в scale.
- GameMaker даёт отдельный GUI layer size: разработчик задаёт логический размер
  GUI, а слой растягивается в окно игры.
- Godot использует базовый размер окна как design size, stretch-настройки,
  anchors и containers для адаптации Control-нод.

Вывод для Shelter: companion-окну нужен собственный осознанный design size, а
не случайное наследование глобального `960x540`.

### DPI и OS scale — это входные данные, а не вся формула

Игры обычно не полагаются только на “разрешение экрана”. Ширина 3840 пикселей
может означать большой монитор, Retina-экран ноутбука или внешний дисплей с
другой дистанцией просмотра.

Полезные runtime-сигналы:

- usable rect экрана, чтобы не перекрывать menu bar/taskbar и понимать реальное
  доступное место;
- OS/display scale, особенно для Retina и Wayland fractional scale;
- DPI как дополнительная подсказка, если платформа сообщает его корректно;
- пользовательская настройка, потому что DPI/OS scale не всегда надёжны.

Вывод для Shelter: надо читать screen metrics для диагностики и placement, но
масштаб в первой tech demo лучше держать явным пользовательским выбором.

### Scale curve лучше одной “магической” формулы

Unreal здесь даёт хороший паттерн: не пытаться вывести идеальную формулу, а
описать curve/ступени для разных диапазонов viewport.

Практичная первая модель:

- `1.0` для обычного desktop/1080p;
- `1.25` или `1.5` для более крупных окон и плотных дисплеев;
- `1.75` или `2.0` для Retina/4K-сценариев, где дефолтный UI слишком мелкий.

Вывод для Shelter: сделать маленькую ступенчатую scale curve, зажать её в
разумный диапазон и дальше тюнить по реальным тестам.

### Layout всё равно важен

Масштаб решает размер, но не решает компоновку. Нужны anchors, containers,
минимальные размеры, safe/usable regions и отдельные решения для необычных
aspect ratio.

Для companion-полоски это особенно важно: окно специально широкое и низкое.
Поле — это игровой слой, а Settings — скорее маленькое desktop tool-window.

Вывод для Shelter: game zoom и UI scale должны быть разными понятиями.

## Godot-заметки

- `DisplayServer.screen_get_usable_rect(screen)` возвращает часть экрана, не
  занятую системными панелями; Godot реализует это на macOS, Windows и Linux/X11.
- `DisplayServer.screen_get_scale(screen)` возвращает display scale; на macOS
  Godot сообщает `2.0` для Retina и `1.0` для остальных случаев.
- `Window.content_scale_size` — виртуальный базовый размер контента. Если он
  больше реального окна при включённом stretch, в окно помещается больше
  контента, а UI выглядит меньше.
- Для desktop game UI Godot рекомендует `canvas_items`, `expand`, anchors и
  containers.
- Для application-like окон и hiDPI-кейсов Godot отдельно рекомендует дать
  пользователю настройку масштаба.

## Рекомендация для Shelter

### Ближайший фикс tech demo

1. На старте и при смене target display читать:
   - `DisplayServer.screen_get_usable_rect(screen)`;
   - `DisplayServer.screen_get_scale(screen)`;
   - `DisplayServer.screen_get_dpi(screen)`;
   - количество экранов и текущий screen index.
2. Выбирать размер companion-окна по реальному target display, а не только по
   фиксированным константам.
3. Для этой demo явно выставлять runtime content scale/root base size, чтобы
   глобальный `960x540` не ужимал companion-полоску `1120x220`.
4. Отдельно применять `controls_scale` к Control UI: размеры кнопок, font sizes,
   margins, spacing и размер Settings window.
5. Печатать выбранные screen metrics и итоговый `controls_scale` в startup
   report.
6. Добавить в Settings ручной controls scale: `50`, `100`, `150`, `200`.
7. Сохранить пользовательский game zoom и controls scale в `user://`, чтобы
   дефолты применялись только до первого изменения настроек.

### Первая шкала

Для первой demo не используем `Auto`. Обе шкалы одинаковые:

- game zoom: `50`, `100`, `150`, `200`;
- controls scale: `50`, `100`, `150`, `200`.

Стартовые значения, если пользователь ещё ничего не сохранял:

- game zoom: `100`;
- controls scale: `150`.

Это не финальная продуктовая политика, а первая проверяемая гипотеза. Screen
metrics всё равно печатаются в startup report, чтобы понимать поведение на
Retina, внешних мониторах и Windows DPI scaling.

## Минимальная матрица тестов

- macOS Retina internal display;
- macOS external monitor;
- два монитора с разными resolution/scale;
- 1080p-ish non-Retina desktop;
- позже Windows при `100%`, `125%`, `150%`, `200%` display scaling;
- companion mode и normal window mode;
- Settings window на старте и после переключения display.

## Открытые вопросы

- Нужен ли позже `Auto` как опциональный режим, если ручные ступени окажутся
  недостаточно удобными?
- Должна ли сама companion-полоска становиться физически больше на 4K/Retina,
  или должен расти только UI, а поле оставаться компактным?
- Должны ли объекты поля масштабироваться вместе с UI scale, game zoom или
  отдельным art scale?
- Нужен ли production Settings нативным macOS/Windows окном, если click-through
  потом уйдёт в platform-specific слой?

## Источники

- Godot Multiple Resolutions:
  https://docs.godotengine.org/en/stable/tutorials/rendering/multiple_resolutions.html
- Godot DisplayServer:
  https://docs.godotengine.org/en/stable/classes/class_displayserver.html
- Godot Window:
  https://docs.godotengine.org/en/stable/classes/class_window.html
- Unity Canvas Scaler:
  https://docs.unity3d.com/Packages/com.unity.ugui@1.0/manual/script-CanvasScaler.html
- Unreal DPI Scaling:
  https://dev.epicgames.com/documentation/unreal-engine/dpi-scaling-in-unreal-engine
- Unreal Scaling UI For Different Devices:
  https://dev.epicgames.com/documentation/unreal-engine/scaling-ui-for-different-devices-in-unreal-engine
- GameMaker GUI Layer Size:
  https://manual.gamemaker.io/beta/en/GameMaker_Language/GML_Reference/Cameras_And_Display/display_set_gui_size.htm
