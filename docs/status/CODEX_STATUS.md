# Codex Status

## 2026-06-24 - Companion Performance HUD

- Branch: `codex/dev-bootstrap-godot`
- Summary: Добавлен dev performance HUD для companion field demo: он показывает FPS, frame/physics time, память, VRAM/texture memory, draw calls, object/node count прямо поверх игры; в настройки добавлен toggle `Performance HUD`, а launcher получил режим `perf` с Godot `--print-fps`.
- Changed files:
  - `scripts/tech_demos/companion_field_demo.gd`
  - `tools/run-companion-field-demo.sh`
  - `README.md`
  - `docs/dev/companion-field-tech-demo.md`
  - `docs/dev/performance-observability.md`
  - `docs/status/CODEX_STATUS.md`
- Checks:
  - Passed: `tools/run-companion-field-demo.sh smoke`
  - Passed: `tools/check-godot.sh`
  - Passed: direct headless perf override check:
    `Godot --headless --path . --scene res://scenes/tech_demos/companion_field_demo.tscn -- --demo-auto-quit --demo-seconds=0.8 --demo-zoom=100 --demo-controls-scale=150 --demo-perf`
  - Passed: `git diff --check`
  - Passed: visible macOS companion launch with `tools/run-companion-field-demo.sh perf` and Computer Use visual check: the in-game HUD appears in the top-right corner and stdout prints live `Project FPS: ...` lines.
- Assumptions:
  - Godot `Performance` counters enough for the текущий dev HUD; full CPU%, battery, and platform power profiling remain separate Windows/macOS tasks.
  - HUD updates on a timer every `0.5s`, not in `_process()`, чтобы сам мониторинг не стал заметной нагрузкой.
- Blockers:
  - Windows behavior remains untested.
- Next recommended step:
  - Прогнать visible `tools/run-companion-field-demo.sh perf`, смотреть HUD во время zoom/pan/animals, и зафиксировать первые baseline-цифры для сравнения будущих визуальных задач.

## 2026-06-24 - Companion Visual Cleanup And Hide Button

- Branch: `codex/dev-bootstrap-godot`
- Summary: Улучшена читаемость companion demo относительно CQ-референса: procedural урны/фонтан/башни убраны из текущих объектов, building types переключены на asset-based `TX Village Props`, животные получили x2 tight non-empty frame lists для безопасной анимации без пустых кадров, кадросмена ускорена, добавлена правая кнопка `Hide` / `Show`.
- Changed files:
  - `resources/tech_demos/companion_field_layout.json`
  - `scripts/tech_demos/companion_field_demo.gd`
  - `docs/dev/companion-field-tech-demo.md`
  - `docs/status/CODEX_STATUS.md`
- Checks:
  - Passed: `tools/run-companion-field-demo.sh smoke`
  - Passed: `tools/check-godot.sh`
  - Passed: direct headless override check:
    `Godot --headless --path . --scene res://scenes/tech_demos/companion_field_demo.tscn -- --demo-auto-quit --demo-zoom=100 --demo-controls-scale=150`
  - Passed: `git diff --check`
  - Passed: visible macOS companion launch and Computer Use visual check: procedural tower/fountain/bin objects are gone, asset-prop objects render without broken atlas cuts, x2 animals animate through explicit tight frames, and `Hide` / `Show` leaves only the right-side button visible.
- Assumptions:
  - `TX Village Props` остаются временными placeholder-ассетами; финальные Shelter-объекты будут заказаны у художников.
  - Для текущего прототипа безопаснее анимировать животных явными tight-списками кадров, чем пытаться автоматически угадывать ряды и длину клипов из разрозненных spritesheet PNG.
  - `Hide` / `Show` пока скрывает визуальное поле внутри того же companion window; отдельную production-модель collapse/window resize ещё нужно спроектировать после UX-проверки.
- Blockers:
  - Windows behavior remains untested.
- Next recommended step:
  - Проверить глазами новые object silhouettes при zoom `100` и `150`, затем решить, какие placeholder buildings оставить до прихода финального арта.

## 2026-06-24 - Placeholder Art From Local Tilesets

- Branch: `codex/dev-bootstrap-godot`
- Summary: `tilesets/` добавлен в `.gitignore` как локальная сырьевая директория; для companion field demo создан curated placeholder-art набор в `assets/tech_demos/placeholder_art/`, подключены `TX Tileset Ground`, `TX Village Props` и все outlined `MinifolksForestAnimals` species с лёгким движением по таймеру.
- Changed files:
  - `.gitignore`
  - `tilesets/.gdignore`
  - `assets/tech_demos/placeholder_art/README.md`
  - `assets/tech_demos/placeholder_art/tx_tileset_ground.png`
  - `assets/tech_demos/placeholder_art/tx_village_props.png`
  - `assets/tech_demos/placeholder_art/animals/*.png`
  - `scripts/tech_demos/companion_field_demo.gd`
  - `docs/dev/companion-field-tech-demo.md`
  - `docs/status/CODEX_STATUS.md`
- Checks:
  - Passed: `tools/run-companion-field-demo.sh smoke`
  - Passed: `tools/check-godot.sh`
  - Passed: direct headless override check:
    `Godot --headless --path . --scene res://scenes/tech_demos/companion_field_demo.tscn -- --demo-auto-quit --demo-zoom=100 --demo-controls-scale=150`
  - Passed: `git diff --check`
  - Passed: visible macOS companion launch and Computer Use visual check: textured ground, placeholder props, and Minifolks animals render in the strip; timer-driven animal movement is visible.
- Assumptions:
  - Placeholder sprites are for development feel only and will be replaced by commissioned Shelter art.
  - Runtime texture loading first uses `ResourceLoader`, then falls back to PNG bytes so raw PNGs work in headless checks even before Godot import metadata exists.
  - `tilesets/.gdignore` is intentionally tracked while the rest of `tilesets/` is ignored, because Git ignore rules do not stop Godot from scanning local raw assets.
  - Placeholder animals use short timer-driven routes and atlas-frame sampling only to make the demo livelier; this is not the final Shelter NPC/animal behavior architecture.
- Blockers:
  - Windows behavior remains untested.
- Next recommended step:
  - Visually tune sprite atlas regions and scale after looking at the live companion strip.

## 2026-06-23 - Move Mode Captures Placement Clicks

- Branch: `codex/dev-bootstrap-godot`
- Summary: Исправлен баг click-through в режиме перемещения: пока здание двигается белым ghost-объектом, главное companion-окно временно ловит всю область окна, чтобы клик по ghost-объекту или выше него не уходил в приложение позади игры.
- Changed files:
  - `scripts/tech_demos/companion_field_demo.gd`
  - `docs/dev/companion-field-tech-demo.md`
  - `docs/status/CODEX_STATUS.md`
- Checks:
  - Passed: `tools/run-companion-field-demo.sh smoke`
  - Passed: `tools/check-godot.sh`
  - Passed: direct headless override check:
    `Godot --headless --path . --scene res://scenes/tech_demos/companion_field_demo.tscn -- --demo-auto-quit --demo-zoom=100 --demo-controls-scale=150`
  - Passed: `git diff --check`
  - Passed: Computer Use visual check of live macOS Godot window: click `Ратуша` to enter move mode, then click above the white ghost building; the click is handled by Godot as placement instead of passing through to the app underneath.
- Assumptions:
  - В move mode важнее не потерять placement click, чем сохранять empty-space click-through; после placement/cancel обычный skyline passthrough возвращается.
- Blockers:
  - Windows behavior remains untested.
- Next recommended step:
  - Вручную проверить: войти в move mode, кликнуть по белому ghost-зданию и выше него, убедиться что placement обрабатывается игрой, а не окном снизу.

## 2026-06-23 - Companion Ground Layer And Click-Through Skyline

- Branch: `codex/dev-bootstrap-godot`
- Summary: Уточнена CQ-like модель поля: земля стала постоянным визуальным слоем с травяной кромкой и грунтом, клетки теперь рисуются только как move-mode overlay поверх грунта, click-through empty space включён по умолчанию и строит интерактивный skyline-полигон по земле и зданиям, в Settings добавлена кнопка `Выход`.
- Changed files:
  - `README.md`
  - `scripts/tech_demos/companion_field_demo.gd`
  - `docs/dev/companion-field-tech-demo.md`
  - `docs/status/CODEX_STATUS.md`
- Checks:
  - Passed: `tools/run-companion-field-demo.sh smoke`
  - Passed: `tools/check-godot.sh`
  - Passed: direct headless override check:
    `Godot --headless --path . --scene res://scenes/tech_demos/companion_field_demo.tscn -- --demo-auto-quit --demo-zoom=100 --demo-controls-scale=150`
  - Passed: visible macOS companion launch with settings auto-open:
    `Godot --path . --scene res://scenes/tech_demos/companion_field_demo.tscn --quit-after 4 -- --demo-auto-quit --demo-seconds=0.6 --demo-companion --demo-transparent --demo-open-settings --demo-zoom=100 --demo-controls-scale=150`
  - Passed: `git diff --check`
  - Passed: Computer Use visual check of the live Godot window: move-mode off shows only persistent ground; clicking `Ратуша` opens move-mode overlay on the dirt area without changing the ground layer.
- Observed macOS demo result:
  - Display backend: `macOS`
  - Screen count: `2`
  - Companion window size/position: `(2992, 220)` at `(5120, 3050)`
  - Settings window size/position: `(660, 840)` at `(6286, 1912)`
  - Flags: always-on-top `true`, borderless `true`, transparent `true`
  - Click-through empty space default: `true`
- Assumptions:
  - The current procedural grass/dirt visual is a lightweight placeholder, not the final art direction.
  - Kenney `Pixel Platformer` (`https://kenney.nl/assets/pixel-platformer`) is the current CC0 candidate for a later placeholder-art import, but the full asset pack was not imported in this task.
  - Godot's one-polygon mouse passthrough can approximate CQ-like transparent empty-space clicks for a connected ground/building silhouette, but not exact per-pixel hit testing.
- Blockers:
  - Real click-through focus transfer still needs one more manual confirmation against a visible app underneath after this skyline-polygon change.
  - Windows behavior remains untested.
- Next recommended step:
  - Run `tools/run-companion-field-demo.sh`, confirm empty transparent clicks with always-on-top on/off, then continue toward the first real tech demo slice: placement UX plus early Shelter-specific object silhouettes.

## 2026-06-23 - Configurable Field Zones And Placement Grid

- Branch: `codex/dev-bootstrap-godot`
- Summary: Добавлена config-driven модель поля для companion field demo: зоны и клетки как в CQ, технические gate-клетки, типы зданий с footprint в клетках, allowed zones, move mode с подсветкой доступных/занятых/валидных footprint-клеток, zone ground colors и player-state unlocked cell counts.
- Changed files:
  - `resources/tech_demos/companion_field_layout.json`
  - `scripts/tech_demos/companion_field_demo.gd`
  - `docs/dev/companion-field-tech-demo.md`
  - `docs/status/CODEX_STATUS.md`
- Checks:
  - Passed: `tools/run-companion-field-demo.sh smoke`
  - Passed: direct headless override check:
    `Godot --headless --path . --scene res://scenes/tech_demos/companion_field_demo.tscn -- --demo-auto-quit --demo-zoom=100 --demo-controls-scale=150`
  - Passed: `tools/check-godot.sh`
  - Passed: visible macOS companion demo with settings auto-open argument:
    `Godot --path . --scene res://scenes/tech_demos/companion_field_demo.tscn --quit-after 4 -- --demo-auto-quit --demo-seconds=0.5 --demo-companion --demo-transparent --demo-open-settings --demo-zoom=100 --demo-controls-scale=150`
  - Passed: `git diff --check`
- Observed demo result:
  - Field cells: `192`
  - Field world width: `6144.0`
  - Current CQ-style split from `player_state.zone_unlocked_cells`: `26 + 3 + 80 + 3 + 80`
  - Visible macOS window size/position: `(2992, 220)` at `(5120, 3050)`
  - Game zoom / controls scale override: `100` / `150`
- Assumptions:
  - `base_cells` and `max_cells` describe design limits; `player_state.zone_unlocked_cells` describes current unlocked land and can later come from real save/player state.
  - Technical cells are represented as non-buildable sandy zones and occupied by fixed gate buildings.
  - Zone ground colors are placeholder colors for readability, not final art.
- Blockers:
  - Move-mode mouse interaction still needs manual visible confirmation: click a movable building, hover over allowed/forbidden/occupied cells, place or cancel with Escape.
  - Windows behavior remains untested.
- Next recommended step:
  - Manually test moving `Ратуша`, `Большой фонтан`, and `Урна` at several zoom levels, then decide whether drag-to-place or click-to-place feels better for the production interaction.

## 2026-06-23 - Full-Width Companion Strip And Screen-Centered Settings

- Branch: `codex/dev-bootstrap-godot`
- Summary: Companion field demo теперь занимает всю usable width выбранного display, а Settings открывается как native scrollable window по центру выбранного display, не внутри нижней полоски.
- Changed files:
  - `scripts/tech_demos/companion_field_demo.gd`
  - `docs/dev/companion-field-tech-demo.md`
  - `docs/status/CODEX_STATUS.md`
- Checks:
  - Passed: `tools/run-companion-field-demo.sh smoke`
  - Passed: `tools/check-godot.sh`
  - Passed: visible macOS companion demo с settings auto-open argument:
    `Godot --path . --scene res://scenes/tech_demos/companion_field_demo.tscn --quit-after 4 -- --demo-auto-quit --demo-seconds=0.5 --demo-companion --demo-transparent --demo-open-settings`
  - Passed: `git diff --check`
- Observed macOS demo result:
  - Screen usable rect: `[P: (5120, 1394), S: (2992, 1876)]`
  - Companion window size/position: `(2992, 220)` at `(5120, 3050)`
  - Content scale size: `(2992, 220)`
  - Settings window size/position: `(660, 840)` at `(6286, 1912)`
- Assumptions:
  - Companion mode должен использовать usable width выбранного display без боковых и нижних отступов.
  - Settings должен быть отдельным native window, чтобы жить вне короткой companion-полоски.
- Blockers:
  - Нужна ручная пользовательская проверка, что Settings визуально открывается по центру поверх других приложений на текущем desktop.
  - Windows behavior пока не проверен.
- Next recommended step:
  - Запустить `tools/run-companion-field-demo.sh` и подтвердить full-width strip плюс centered scrollable Settings на обоих подключенных мониторах.

## 2026-06-23 - Companion UI Scale Steps

- Branch: `codex/dev-bootstrap-godot`
- Summary: Реализованы отдельные ступени game zoom и controls scale для companion field demo: `50`, `100`, `150`, `200`, без режима `Auto`; первый запуск по умолчанию использует game zoom `100` и controls scale `150`.
- Changed files:
  - `scripts/tech_demos/companion_field_demo.gd`
  - `docs/dev/companion-field-tech-demo.md`
  - `docs/dev/ui-scaling-research.md`
  - `docs/status/CODEX_STATUS.md`
- Checks:
  - Passed: `tools/run-companion-field-demo.sh smoke`
  - Passed: direct headless override check:
    `Godot --headless --path . --scene res://scenes/tech_demos/companion_field_demo.tscn -- --demo-auto-quit --demo-zoom=50 --demo-controls-scale=200`
  - Passed: `tools/check-godot.sh`
  - Passed: visible macOS companion demo with settings auto-open argument:
    `Godot --path . --scene res://scenes/tech_demos/companion_field_demo.tscn --quit-after 4 -- --demo-auto-quit --demo-seconds=0.5 --demo-companion --demo-transparent --demo-open-settings`
  - Passed: `git diff --check`
- Observed macOS demo result:
  - Display backend: `macOS`
  - Screen count: `2`
  - Screen index: `0`
  - Screen size: `(2992, 1934)`
  - Screen usable rect: `[P: (5120, 1394), S: (2992, 1876)]`
  - Screen scale/DPI: `2.0` / `220`
  - Window size/position: `(1120, 220)` at `(5152, 3018)`
  - Content scale size: `(1120, 220)`
  - Game zoom / controls scale: `100` / `150`
- Assumptions:
  - Game zoom and controls scale are safe to persist in `user://companion_field_demo.cfg`; click-through test mode is intentionally not persisted.
  - The first demo should use explicit user-selectable scale steps rather than automatic scale selection.
- Blockers:
  - Manual visual confirmation is still needed for the perceived size of controls at `150` on the user's display.
  - Windows DPI behavior remains untested.
- Next recommended step:
  - Run `tools/run-companion-field-demo.sh` visibly, confirm that Settings and controls are clickable at `150`, then tune the base control sizes or default step if needed.

## 2026-06-23 - UI Scaling Research

- Branch: `codex/dev-bootstrap-godot`
- Summary: Изучено, как UI scaling обычно решается в Godot, Unity, Unreal и GameMaker; добавлена Shelter-специфичная рекомендация для desktop companion-окна.
- Changed files:
  - `docs/dev/ui-scaling-research.md`
  - `docs/status/CODEX_STATUS.md`
- Checks:
  - Passed: `git diff --check`
- Assumptions:
  - Текущая проблема микроскопического UI связана и с hiDPI/large-screen контекстом, и с несовпадением project viewport base (`960x540`) и размера companion-полоски (`1120x220`).
  - Первая реализация должна быть настраиваемой scale curve для tech demo, а не финальной продуктовой политикой.
- Blockers:
  - Windows DPI behavior пока не проверен.
- Next recommended step:
  - Реализовать adaptive companion UI scaling в `scripts/tech_demos/companion_field_demo.gd`: читать display metrics на старте, явно задавать runtime content scale, масштабировать Control UI отдельно от game zoom и добавить UI scale override в Settings.

## 2026-06-23 - Unified Companion Demo Launch

- Branch: `codex/dev-bootstrap-godot`
- Summary: Made `tools/run-companion-field-demo.sh` the single default manual launch for checking the companion field, settings, display selection, transparency, click-through test mode, zoom, and pan in one session.
- Changed files:
  - `README.md`
  - `tools/run-companion-field-demo.sh`
  - `scripts/tech_demos/companion_field_demo.gd`
  - `docs/dev/companion-field-tech-demo.md`
  - `docs/status/CODEX_STATUS.md`
- Checks:
  - Passed: `tools/run-companion-field-demo.sh smoke`
  - Passed: `tools/check-godot.sh`
  - Passed: visible macOS companion demo with settings auto-open argument:
    `Godot --path . --scene res://scenes/tech_demos/companion_field_demo.tscn --quit-after 4 -- --demo-auto-quit --demo-seconds=0.3 --demo-companion --demo-transparent --demo-open-settings`
  - Passed: `git diff --check`
- Observed macOS demo result:
  - Display backend: `macOS`
  - Screen count: `2`
  - Screen index: `0`
  - Window size/position: `(1120, 220)` at `(5152, 3018)`
  - Applied flags: always-on-top `true`, borderless `true`, transparent `true`
- Assumptions:
  - The default launch should optimize for a human tester, while named presets remain available for narrower diagnostics.
- Blockers:
  - Real click-through behavior still needs manual confirmation against an app underneath the transparent areas.
- Next recommended step:
  - Run `tools/run-companion-field-demo.sh`, test zoom/pan/object clicks/click-through/display placement in one session, then decide whether the window behavior is good enough for the next gameplay slice.

## 2026-06-23 - Companion Field Tech Demo

- Branch: `codex/dev-bootstrap-godot`
- Summary: Added the first Godot companion field tech demo with placeholder objects, discrete zoom, pan, object selection, settings window, display placement, and click-through test mode.
- Changed files:
  - `README.md`
  - `tools/check-godot.sh`
  - `tools/run-companion-field-demo.sh`
  - `scenes/tech_demos/companion_field_demo.tscn`
  - `scripts/tech_demos/companion_field_demo.gd`
  - `scripts/tech_demos/companion_field_demo.gd.uid`
  - `docs/dev/companion-field-tech-demo.md`
  - `docs/status/CODEX_STATUS.md`
- Checks:
  - Passed: `"$GODOT_BIN" --headless --path . --check-only --script res://scripts/tech_demos/companion_field_demo.gd`
  - Passed: `tools/run-companion-field-demo.sh smoke`
  - Passed: `tools/check-godot.sh`
  - Passed: visible macOS companion demo with auto-quit:
    `Godot --path . --scene res://scenes/tech_demos/companion_field_demo.tscn --quit-after 4 -- --demo-auto-quit --demo-seconds=0.6 --demo-companion --demo-transparent`
- Observed macOS demo result:
  - Display backend: `macOS`
  - Rendering backend: Metal 4.0 Forward+
  - Screen count: `2`
  - Screen index: `0`
  - Screen usable rect: `[P: (5120, 1394), S: (2992, 1876)]`
  - Window size/position: `(1120, 220)` at `(5152, 3018)`
  - Applied flags: always-on-top `true`, borderless `true`, transparent `true`
- Assumptions:
  - This is a technical demo, not final gameplay, art direction, economy, or charity flow.
  - Godot's single mouse-passthrough polygon is enough for a first click-through feasibility test, but not enough to prove production-grade disjoint clickable object islands.
- Blockers:
  - Manual visible macOS testing is still required for real click-through, system panel/menu bar behavior, always-on-top stacking, focus transfer, and multi-monitor placement.
  - Windows behavior remains untested.
- Next recommended step:
  - Run `tools/run-companion-field-demo.sh companion` and `tools/run-companion-field-demo.sh click-through` visibly on the two-monitor macOS setup, record results, then decide whether click-through needs native code or a different window strategy.

## 2026-06-23 - Repo-Local CQ Reference Skill

- Branch: `codex/dev-bootstrap-godot`
- Summary: Added a repo-local `cq-hero-town-reference` skill and captured current CQ Hero Town input/window findings for Shelter desktop reference work.
- Changed files:
  - `.agents/skills/cq-hero-town-reference/SKILL.md`
  - `.agents/skills/cq-hero-town-reference/agents/openai.yaml`
  - `.agents/skills/cq-hero-town-reference/references/buildings.md`
  - `.agents/skills/cq-hero-town-reference/references/controls.md`
  - `.agents/skills/cq-hero-town-reference/references/window-behavior.md`
  - `README.md`
  - `docs/dev/companion-field-tech-demo.md`
  - `docs/dev/desktop-window-spike.md`
  - `docs/status/CODEX_STATUS.md`
- Checks:
  - Passed: `python3 /Users/barsulka/.codex/skills/.system/skill-creator/scripts/quick_validate.py .agents/skills/cq-hero-town-reference`
- Assumptions:
  - CQ reference knowledge should live in this repository because it directly informs Shelter Steam/Desktop window, input, and companion-field behavior.
  - The personal copy in `~/.codex/skills` may still exist, but the repository copy is now the project source of truth.
- Blockers:
  - Mouse-drag panning in CQ still needs a clean confirmed pass.
  - Windows behavior remains untested.
- Next recommended step:
  - Start `docs/dev/companion-field-tech-demo.md`: a small Godot tech demo with field pan/zoom, placeholder objects, click-through testing, multi-monitor placement, and a minimal settings window.

## 2026-06-22 - Russian-Only Communication Rule

- Branch: `codex/dev-bootstrap-godot`
- Summary: Added an explicit `AGENTS.md` instruction that all communication must be strictly in Russian.
- Changed files:
  - `AGENTS.md`
  - `docs/status/CODEX_STATUS.md`
- Checks:
  - Passed: `git diff --check`
- Assumptions:
  - The rule applies to assistant/user-facing communication in this repository context.
- Blockers:
  - None.
- Next recommended step:
  - Continue using Russian-only communication in all future Shelter Steam/Desktop work.

## 2026-06-22 - Desktop Window Spike Probe

- Branch: `codex/dev-bootstrap-godot`
- Summary: Added a Godot runtime probe for desktop window behavior: always-on-top, borderless mode, transparency flags, mouse passthrough modes, screen metrics, and native window handles.
- Changed files:
  - `README.md`
  - `project.godot`
  - `tools/check-godot.sh`
  - `tools/run-window-spike.sh`
  - `scenes/spikes/desktop_window_probe.tscn`
  - `scripts/spikes/desktop_window_probe.gd`
  - `scripts/spikes/desktop_window_probe.gd.uid`
  - `docs/dev/desktop-window-spike.md`
  - `docs/status/CODEX_STATUS.md`
- Checks:
  - Passed: `tools/check-godot.sh`
  - Passed: `tools/run-window-spike.sh smoke`
  - Passed: visible macOS companion probe with auto-quit:
    `Godot --path . --scene res://scenes/spikes/desktop_window_probe.tscn --quit-after 4 -- --spike-auto-quit --spike-seconds=0.5 --spike-companion --spike-borderless --spike-interactive-polygon`
- Observed macOS probe result:
  - Display backend: `macOS`
  - Rendering backend: Metal 4.0 Forward+
  - Window transparency feature/availability: `true` / `true`
  - Applied flags: always-on-top `true`, borderless `true`, transparent `true`
  - Interactive polygon requested: `true`, 4 points
  - Window size/position: `(960, 160)` at `(48, 2010)`
  - Screen metrics: scale `2.0`, DPI `255`, refresh `120.0`
- Assumptions:
  - The probe may enable project-level transparent-window settings, while the normal main scene remains visually opaque.
  - The probe is development-only and is not a commitment to final companion-window behavior.
  - Headless checks validate API/script compatibility but not macOS compositor behavior.
- Blockers:
  - Windows behavior is not validated yet.
  - Real click-through, always-on-top stacking, and battery profile still require manual visible testing.
- Next recommended step:
  - Run `tools/run-window-spike.sh companion` manually beside other apps and record the observed transparency/focus/click-through behavior.

## 2026-06-22 - Godot Dev Bootstrap

- Branch: `codex/dev-bootstrap-godot`
- Summary: Created the initial Godot 4.x project skeleton for Shelter Steam/Desktop and mirrored the accepted Godot decision into local repo docs.
- Changed files:
  - `.editorconfig`
  - `.gitignore`
  - `README.md`
  - `project.godot`
  - `scenes/main.tscn`
  - `scripts/main.gd`
  - `scripts/main.gd.uid`
  - `tools/check-godot.sh`
  - `docs/adr/0001-use-godot-for-steam-desktop.md`
  - `docs/dev/godot-setup.md`
  - `docs/dev/desktop-window-spike.md`
  - `docs/status/CODEX_STATUS.md`
- Checks:
  - Passed: `tools/check-godot.sh`
  - Passed: `git status --short --branch`
- Assumptions:
  - The Steam/Desktop repo root is the Godot project root.
  - Godot from Steam is the local editor binary for now.
  - No gameplay, art direction, charity flow, Steamworks, export presets, or native window APIs are part of this bootstrap.
- Blockers:
  - None known at bootstrap time.
- Next recommended step:
  - Run the desktop window spike for transparency, always-on-top behavior, click-through feasibility, UI hiding, and idle performance.
