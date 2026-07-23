# STEAM_DESKTOP — Codex Brief — D-030 / Selected-H Current Presentation Regression Profile v1

Дата: 2026-07-22  
Статус: **ACTIVE — D-034 D-030-ONLY 15.0s READINESS-BUDGET AMENDMENT READY FOR INDEPENDENT DOCS VERIFICATION; IMPLEMENTATION / RUNTIME HOLD; CHECKPOINT 2 HOLD**  
Владелец: Project Manager → Codex  
Платформа: **macOS only**  
Рекомендуемый уровень рассуждений Codex: **очень высокий**

## 0. Activation boundary

Этот brief активирован для bounded implementation одобренного пользователем
D-032 Route 1.

Activation provenance:

- direct user approval `«Одобряю, поехали»` в coordinator thread
  `019f856b-060d-7791-8265-a91cd2de4171`;
- independent docs/brief `PASS` — verifier thread
  `019f8669-6a2b-7ba3-931e-be4569a29e9e`;
- coordinator activation — thread `019f856b-060d-7791-8265-a91cd2de4171`.

D-033 amendment provenance: direct user approval in coordinator thread
`019f856b-060d-7791-8265-a91cd2de4171`:
`«Одобряю Route 1: на macOS округлять требуемую высоту вверх до целого шага
максимального Godot backing scale, затем требовать точного actual readback;
оформить D-033/поправку D-032 и продолжить только после независимой проверки
документов»`.

D-033 amendment получил independent docs/brief `PASS` в verifier thread
`019f8669-6a2b-7ba3-931e-be4569a29e9e` на freeze
`79cea50502aff44e0dd17265cdb85fb2347ec1d9c5cba855edb714e8622b1fe6`.
Coordinator thread `019f856b-060d-7791-8265-a91cd2de4171` после этого
re-authorized ту же implementation session
`019f8a55-019b-7690-b624-b860b136ff3c` продолжить только поправку D-032
seam + validator под этим brief. Runner, observer, protected D-024 bytes,
tooling, assets, gameplay и Checkpoint 2 остаются без изменений и вне
разрешённого continuation scope.

D-034 amendment provenance: direct user approval in coordinator thread
`019f856b-060d-7791-8265-a91cd2de4171` требует считать projected canonical
canvas единственным Selected-H render/pointer domain, clip whole-tile overdraw,
оставлять true exterior transparent/click-through и валидировать exact
visible-alpha/pointer equivalence без global viewport-fill assertion. Обе
active-brief amendments получили independent docs/brief `PASS` на freeze
`9cd3ac289c90e2c3a4f8dd605b82229118e9f9743ca9c346c5e8cd379dca5e8b`.
Новый coordinator/Root/King thread `019f8bac-0007-7962-ad8a-ca31fb95ac7f`
прочитал accepted D-034 contract и выдал `ROOT-APPROVED` только для bounded
continuation внутри него. Эта status/provenance-запись прошла отдельную
read-only verification, после чего implementation author был dispatch, но
остановился `BLOCKED BEFORE SPAWN`: неизменяемый observer требует system-temp
`HOME`/output, а прежний recovery route разрешал только repo-local `tmp/`.

Пользователь прямо одобрил Route A: system temp допустим как transient working
area unchanged observer, если complete raw/evidence tree до independent
verification атомарно продвигается в unique repo-local `tmp/` с hash/readback
verification. Exact evidence contract записан в section 4.2A. Отдельный
least-privilege config/profile experiment был реализован и независимо получил
`PASS CONFIG ONLY`, но два governed named-profile GUI запуска воспроизвели
pre-project AppKit/HIServices `SIGABRT`; эти результаты остаются реальным
историческим evidence и не являются D-034 code verdict.

Direct user decision затем остановил permission/private-tmp диагностику на
critical path, изолировал её в отдельную non-blocking background task и
разрешил текущей D-034 production wave работать «по-старинке» под effective
`:danger-full-access` / Full Access. `/private/tmp` разрешён unchanged runner;
named-profile, Seatbelt, network-disabled, config/UI/profile precondition для
этой production wave отсутствует. Это узко supersede только permission-route
ограничения, не меняет observer/runner/profile/argv, Steam Godot, D-034
render/pointer contract, frozen demo/validator bytes, file ownership или
acceptance gates.

Full Access route-reset запись получила independent `PASS DOCS ONLY`.
Последующий governed production run под этим route остановился real
`FAIL`/ineligible на spawn-anchored `6.0s` readiness budget во время
продолжающегося capture progress (`19/24`). Bounded performance bugfix сохранил
точные D-034 metrics и общие PNG bytes, увеличил progress до `23/24`, но второй
и единственный re-authorized run также завершился real `FAIL`/ineligible на том
же `6.0s` budget до последнего CLEAN capture, atomic matrix и readiness token.
Оба `rc74` остаются историческими FAIL и не переинтерпретируются.

Пользователь прямо одобрил material route amendment:
`«Одобряю. Я бы даже 15 секунд сделал — чего нам жалеть-то? 5 секунд погоды не
сделают»`. Root зафиксировал exact value `15.0s` только для governed D-030
Selected-H current-presentation route/profile. Это spawn-anchored maximum:
successful readiness возвращается немедленно и не навязывает ожидание `15.0s`.
Implementation/runtime остаются `HOLD` до independent docs `PASS` и отдельного
bounded re-dispatch production-author task
`019f8ee0-1cd9-76e0-846d-58184b4d945a`.

Активация разрешает только exact scope этого brief. Перед implementation
обязателен fresh fail-closed checkout/scope check.

Checkpoint 1 active selected-H brief остаётся `USER_ACCEPTED / PASS`.
Checkpoint 2 остаётся `HOLD`, пока этот brief не реализован и его current
pre-checkpoint-2 gate не получил independent mechanical `PASS`.

## 1. Goal

Создать один durable, separately versioned mechanical regression profile для
current D-030/D-031/Selected-H presentation semantics, не переписывая D-024
history/evidence и не добавляя новый process, control или capture route.

Profile должен:

- проверять current geometry/window/zoom/camera/pan/pointer semantics;
- проверять accepted Selected-H mechanical contract и permanent player state;
- механически валидировать фактическую 12-state live matrix, когда она
  доступна на соответствующем checkpoint;
- сохранять действующие non-visual regressions и ADR-0004 process rules;
- явно отделять mechanical result от visual critic и user acceptance.

## 2. Read first

Читать полностью в указанном порядке:

```text
PROJECTS_RULES.md
AGENTS.md
steam/AGENTS.md
steam/README.md
docs/drive/Shelter/00_START_HERE/000_ROLE_CODEX.md
docs/drive/Shelter/00_START_HERE/01_CURRENT_STATUS.md
docs/drive/Shelter/00_START_HERE/02_DECISIONS.md (D-024, D-027..D-034)
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__CURRENT_CONTEXT.md
docs/drive/Shelter/04_DEVELOPMENT/CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md
docs/repo/status/CODEX_CURRENT_STATUS.md
docs/repo/adr/README.md
docs/repo/adr/0001-use-godot-for-steam-desktop.md
docs/repo/adr/0002-game-state-as-source-of-truth.md
docs/repo/adr/0004-godot-child-observability-and-graceful-termination.md
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__D024_Responsive_Meadow_Marker_And_Player_Presentation_Cleanup_v1.md
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__D030_Fixed_26_Cell_Meadow_Zoom_And_Click_Surface_v1.md
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Selected_H_Visual_Shell_Runtime_Integration_And_Live_Matrix_v1.md
this brief
```

При конфликте с higher authority или Accepted ADR — `STOP`, не workaround.

## 3. D-024 applicability boundary

D-024 fixed presentation runner/test/normal validator/capture workflow остаётся
immutable pre-D-030 evidence для sealed runtime at commit
`556c9cc561c87977b3a3d79b80ffc5f201551835`.

Не менять и не перегенерировать:

```text
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__D024_Responsive_Meadow_Marker_And_Player_Presentation_Cleanup_v1.md
docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_R48_05A_D024_RESPONSIVE_PRESENTATION_RUNTIME_CAPTURE_v1/**
steam/tests/vertical_slice_visual/d024_responsive_presentation_test_runner.tscn
steam/tests/vertical_slice_visual/test_d024_responsive_presentation.gd
steam/tools/validate-d024-responsive-presentation.py
steam/tools/capture-d024-responsive-presentation.sh
steam/tools/observe-godot-process.py
```

Сохранить exact evidence identity:

```text
D-024 authority digest  4f956a077d0a93575ef7b518fd0aa9fb409392a08fd4a48190364795bc9b5cbf
sealed whole brief      cc6d7fa778b85eebd6d6307dba33efa52518aa62911287dd15ee0d9c7dd5c669
fixed D-024 test        6dc93e9e7610d43a64a495637a3b0388ba6518408cf91e98142013707417abb8
fixed D-024 runner      e699c9a4a9c2039b895777481c4d8756708801b28f86a6b7386e9ea760aaf645
normal validator       2618815935c32349c2365b12267dd63b6138dc403ff85ea1dcddf54c4c281a4c
capture runner          2df209f50fe3a83d5b4ecd2375bd216245b79231d01e075e243d327df7e03cd0
```

В `vertical_slice_demo.gd` не менять существующие D-024 helper/test regions,
включая `test_d024_*`, `_d024_zoom_*`, `_d024_camera_max_for` и
`_d024_player_mouse_polygon`. Новый current seam получает только новые
D-030/Selected-H names и не переопределяет old helper behavior.

Если старый D-024 profile фактически запущен против current runtime, любой
`FAIL`/diagnostic остаётся ineligible. Нельзя suppress, allowlist, переименовать
его в expected PASS или включить его артефакты в current evidence. После
активации этого brief он не является current applicability gate.

## 4. Exact allowed implementation scope

### 4.1 Selected-H render/pointer correction + current seam — bounded only

```text
steam/scripts/prototypes/vertical_slice/vertical_slice_demo.gd
```

После independent PASS D-034 brief amendments и отдельной coordinator
re-authorization был разрешён только bounded Selected-H delta вне D-024
helper/test regions:

- clip background/earth/grid/roster render output к exact
  `projected_canvas_interval`;
- сделать общую render/pointer boundary точной, без sampled-lattice taper;
- синхронизировать Selected-H pointer domain с этой boundary;
- обновить deterministic read-only current snapshot/matrix seam.

Нельзя менять camera, zoom, gameplay, persistence, accepted art pixels/geometry
или любой input behavior вне exact D-034 render/pointer equivalence. Этот delta
плюс bounded in-spec performance bugfix сохранён в pending production bytes:

```text
vertical_slice_demo.gd
  959660edfdace6a6325cc68c3240464e7099ba2c5eb0a97e13e51676cf02e974
test_d030_selected_h_current_presentation.py
  a1e17b2de75090bf66513c457e08b702d2988b18c8fa16495817593eca59e74c
```

Performance delta ограничен `_d034_image_profile_metrics`; deterministic
differential fixtures доказали exact equality всех D-034 fields и неизменность
fixture/общих runtime PNG bytes. Это pending bugfix, не implementation или
mechanical `PASS`.

### 4.2 Current profile files and route-specific readiness wiring

Bounded implementation создал ровно:

```text
steam/tests/vertical_slice_visual/test_d030_selected_h_current_presentation.py
steam/tests/vertical_slice_visual/run_d030_selected_h_current_presentation.sh
```

Validator использует Python standard library only, читает bounded current
snapshot/process/matrix records и не запускает arbitrary executable. Runner
вызывает только существующий неизменённый
`steam/tools/observe-godot-process.py ordinary-player` fixed profile, сохраняет
его raw stdout/stderr/process-result и передаёт validator только exact retained
records. Когда unchanged observer contract требует system-temp `HOME`/output,
применяется только section 4.2A. Кроме exact section-4.2B route-specific
readiness wiring observer/profile semantics и argv не меняются. Никаких новых
Godot argv, scene target, generic shell/control или capture commands.

После independent docs `PASS` production author может изменить только smallest
route-specific runner/observer/profile wiring, необходимый для передачи
`15.0s` readiness budget именно этому D-030 current-presentation route. Global
observer default и другие profiles/routes не расширяются. Если current source
не даёт narrower route-specific mechanism и требует shared/global broadening,
`STOP` до write и вернуть Root/user варианты. Demo/validator performance bytes
выше сохраняются pending полной проверки.

Для live matrix runner/validator потребляет только readback/captures, созданные
разрешённым existing internal Godot route активного selected-H brief. Если для
получения matrix нужен новый control/capture/tooling route, `STOP`.

### 4.2A D-034 Route A — transient system temp and verified evidence promotion

Direct user/Root authority в thread
`019f8bac-0007-7962-ad8a-ca31fb95ac7f` разрешает неизменённому observer
использовать уникальные system-temp `HOME` и output root, когда этого требует
его current contract. `/private/tmp` сам по себе допустим; это не fallback,
новый route или permission на broad filesystem. Прежний repo-local default был
введён только из-за повторяющихся manual approval prompts, а не из-за запрета
system temp; пользователь прямо попросил устранить prompts и разрешил этот
bounded system-temp route.

До independent verification обязательна одна fail-closed promotion:

1. дождаться finalized raw output и завершения child/observer lifecycle;
2. сохранить complete system-temp source tree и не удалять его;
3. скопировать весь tree в новый unique repo-local `tmp/<run>.partial/`;
4. для source и copy построить deterministic `LC_ALL=C` inventory по
   относительному path, kind, byte count и SHA-256 каждого regular file;
5. отвергнуть missing/extra path, symlink/special file, size/hash mismatch или
   unreadable byte; после полного byte/readback match переименовать staging
   directory в final unique repo-local run root;
6. передавать independent verifier только final verified repo-local copy вместе
   с обоими inventories и promotion result.

Copy/hash/readback failure даёт `STOP`/ineligible: partial tree не
продвигается, source не удаляется, evidence не теряется, повтор ради получения
`PASS` запрещён. System-temp source никогда не является единственной или
canonical evidence. Observer, runner, argv, diagnostic/acceptance semantics и
process-result bytes остаются неизменными.

Approval-spam diagnosis был выполнен отдельно. На момент первоначальной
Route-A docs-wave read-only facts были:

```text
codex --version: codex-cli 0.145.0-alpha.30
.codex/config.toml: approval_policy = "never"
.codex/config.toml: no default_permissions, [permissions.*], sandbox_mode
                    or [sandbox_workspace_write]
```

Реализованный впоследствии project-scoped outcome, сохранённый как
configuration/background evidence, а не prerequisite текущей production wave:

```toml
default_permissions = "shelter-workspace-system-temp"

[permissions.shelter-workspace-system-temp]
description = "Shelter workspace plus macOS system temp; no network."
extends = ":workspace"

[permissions.shelter-workspace-system-temp.filesystem]
":tmpdir" = "write"
":slash_tmp" = "write"

[permissions.shelter-workspace-system-temp.network]
enabled = false
```

В отдельном least-privilege experiment exact `"/private/tmp" = "write"` не
потребовался: bounded effective-policy preflight доказал покрытие current macOS
canonical path через `:slash_tmp`. Этот config получил independent `PASS CONFIG
ONLY`, но не является production prerequisite и не изменяется этой wave.

Official current references:

- `https://learn.chatgpt.com/docs/permissions`;
- `https://learn.chatgpt.com/docs/config-file/config-basic#permission-profiles`;
- `https://learn.chatgpt.com/docs/config-file/config-reference#configtoml`;
- `https://learn.chatgpt.com/docs/sandboxing#how-permissions-work`.

Они подтверждают named `[permissions.<name>]`, `default_permissions`, built-in
`:workspace`, supported `:tmpdir`/`:slash_tmp`, project config только для
trusted project и desktop permission control. Эти сведения продолжают
регулировать отдельную background diagnosis, но не current production route.

Current production gate exact: та же bounded production-author task работает
под effective `:danger-full-access` / Full Access, без named-profile, Seatbelt,
network-disabled, config reload, UI selection или profile readback
precondition. Это direct user-approved execution posture только для текущей
D-034 production wave; оно не расширяет tracked write scope, observer/runner
route, argv, network use, project contract или acceptance. Любое требование
менять config/UI/profile либо использовать иной executable/route остаётся
`STOP`.

### 4.2B D-030-only readiness budget — direct user-approved

Для governed D-030 Selected-H current-presentation profile exact
spawn-anchored maximum readiness budget равен `15.0s`. Readiness success
немедленно завершает ожидание; это upper bound, а не обязательная задержка.

Budget не ослабляет и не заменяет ни одного downstream gate: обязательны exact
`12/12` states, `24/24` GRID/CLEAN PNG, atomic `matrix.json` finalization,
readiness token, strict validator, child/process/diagnostic/supervisor PASS,
relevant suites, protected checks, Route-A evidence integrity/promotion и
independent mechanical verification. Timeout extension не разрешает tolerance,
suppression, allowlist, workload reduction, retry-to-pass или reclassification
любого прежнего `rc74` FAIL/ineligible evidence.

### 4.3 Status/docs after runtime handback — separate docs owner

```text
docs/repo/status/CODEX_CURRENT_STATUS.md
this brief (status/result only)
```

Не создавать второй roadmap, dashboard, evidence pack, handoff или history doc.
Eligible verifier output — только final verified unique repo-local `tmp/` root
после section 4.2A; transient system-temp source остаётся non-canonical.
Production author имеет zero tracked write ownership и не обновляет эти docs;
любой status/result update выполняется отдельным явно назначенным docs owner
после runtime/mechanical handback.

## 5. Current profile contract

### 5.1 D-030 presentation semantics

Проверить exact current facts:

- logical cell `32`; one period `26` cells = `832` world units;
- tracked source period width `1664 px` at `200%`; horizontal stretch/fit absent;
- zoom ladder exactly `50 / 100 / 150 / 200%`, default `100%`;
- macOS companion height dynamic, not fixed `224 px`, bounded by usable rect;
- camera/pan use current visible extent without artificial D-024 `15%` reserve;
- deterministic default camera and bounded current pan at every supported state;
- visible-alpha content is clickable; transparent sky passes through.

### 5.1A D-033 macOS native-quantized dynamic height

Для stable launch display topology получить и записать полный список
`DisplayServer.screen_get_scale(i)`. Его максимум обязан быть целым; обозначить
его `q`. Non-integral scale и любое topology/scale изменение во время governed
run дают fail-closed `STOP`.

Для каждого state использовать exact contract:

```text
content   = 480 × 1740 / 2992 × zoom
required  = max(180, ceil(content))
usable_q  = floor(usable_height / q) × q
requested = min(ceil(required / q) × q, usable_q)
```

Если `usable_q < required`, accepted composition не помещается: `STOP` без
crop, scale change или workaround. Height component `content_scale_size` и
window request получают `requested`. После settle фактический client-area
`DisplayServer.window_get_size` обязан точно равняться request. Viewport/capture
dimensions и selected-H Y-origin выводятся из actual readback.

Каждый state записывает `content`, `required`, полный scale list, `q`,
`usable_q`, `requested` и `actual`. Generic `±1`, retry-to-pass, suppression и
allowlist запрещены. На текущем host `q=2`, поэтому ladder height равен
`180 / 280 / 420 / 560`; `min × 150%` обязан получить exact `420`.

### 5.1B D-034 projected-canvas render/pointer equivalence

Canonical design X-domain half-open: `[0,2992)`. Для каждого actual viewport:

```text
projected_canvas_interval = exact projection([0,2992)) ∩ actual viewport
Selected-H render domain  = projected_canvas_interval
Selected-H pointer domain = projected_canvas_interval
```

Background, earth, grid и roster должны быть clipped к этому interval; whole-tile
overdraw не может выйти за canonical canvas. Viewport exterior вне interval
остаётся фактически прозрачным и click-through. Внутри interval каждый actual
visible-alpha pixel/column покрывается pointer, а transparent sky выше local
alpha top пропускает pointer. Pointer в true exterior и visible alpha без
pointer запрещены.

Render/pointer boundary должна быть exact, а не `4 px` sampled-lattice
approximation или tapered edge. Для `default × 50%`:

```text
projected/render/pointer interval = [0,870)
transparent exterior             = [870,1280)
```

Validator не требует opaque content в каждом viewport column и не использует
global `sampled_top_max < viewport_height` / `opaque_content_clickable=true` как
эквивалент D-030 pointer semantics. D-030 full-width tiling narrowly superseded
только для Selected-H low-zoom exterior; arbitrary composition extension
запрещён.

### 5.2 Retained non-obsolete D-024-family invariants

Проверить только still-current successors:

- `WORLD_WIDTH=1740`, source design width `2992` and cited mapping `1740/2992`;
- presentation camera/zoom/pan state is non-persisted;
- pan emits no gameplay/save/progression/checkpoint output;
- `8` screen-px threshold and release-no-click remain exact unless a later
  accepted authority explicitly supersedes them;
- PlayerBoot, Labrador, gameplay and persistence use their dedicated current
  suites, not the obsolete D-024 framing profile;
- ADR-0004 preserves exact process/diagnostic separation and evidence atomicity.

Do not resurrect marker, exterior reserve, fixed-224 fit, controls-only
passthrough or whole-window-through expectations.

### 5.3 Selected-H mechanical contract

Read canonical values from the active selected-H brief and assert:

- all nine tracked source SHA-256 values;
- design canvas/bands, GRID32 band/boundaries/colors/inset/occupancy;
- accepted scale, authored X pivot, deterministic integer snap, alpha-bottom Y,
  render order and depth gaps;
- active legacy visual/node/load/draw/hit/pointer bindings = `0`;
- permanent ordinary-player state, no capture-only UI mutation and no `tmp`
  runtime dependency;
- render/pointer domains exact to projected canonical canvas, with no overdraw,
  uncovered visible alpha, exterior pointer or tapered boundary;
- GRID/CLEAN difference confined to the accepted grid band;
- live roster/depth assertions activate only when checkpoint state declares the
  roster implemented; before Checkpoint 2 the profile must explicitly assert
  `roster_runtime_expected=false`, never silently skip or report it present.

### 5.4 Matrix

Current matrix is exactly:

```text
min / default / max × 50 / 100 / 150 / 200 = 12 states
```

For each state validate actual window size, zoom, camera/default-reset, dynamic
height, full D-033 scale list/`q`/height derivation, design transform, pointer
bounds and paired `GRID + CLEAN` record. Requested size, actual client-area
readback, viewport/capture dimensions and Y-origin must be mutually exact under
section 5.1A; actual readback is the downstream geometry authority.
Each state must also record and validate, in stable order:

```text
projected_canvas_interval
visible_alpha_x_intervals
pointer_content_x_intervals
transparent_exterior_x_intervals
uncovered_visible_alpha_pixels = 0
uncovered_visible_alpha_columns = 0
exterior_clickable_pixels = 0
exterior_clickable_columns = 0
```

Validation is per-column/per-alpha equivalence. A legitimate exterior sentinel
equal to viewport height is valid and must not be treated as an opaque-fill
failure.
The 12-state current profile must support two explicit gates:

1. `pre-checkpoint-2`: current background/GRID32/permanent-state matrix with
   `roster_runtime_expected=false`; independent PASS releases Checkpoint 2;
2. `checkpoint-2`: the same matrix with live roster/placement/depth assertions;
   required before Checkpoint 2 can advance to its user gate.

Neither gate may infer visual quality or user acceptance.

## 6. Determinism and negative tests

Validator output must use one versioned schema and stable ordering. It must fail
closed on malformed/missing/duplicate states, wrong profile/zoom, non-paired
capture, unknown field, source/hash drift, legacy binding, gameplay output,
process/diagnostic non-PASS or coverage mismatch.

Provide bounded RED/GREEN fixtures inside test code or ephemeral repo-local
`tmp`; do not retain fixture/evidence graveyards. At minimum prove rejection of:

- one old `15% reserve` snapshot;
- fixed-224/vertical-fit semantics;
- controls-only or whole-window passthrough;
- missing one of 12 states or a missing GRID/CLEAN partner;
- roster silently skipped under `checkpoint-2` gate;
- process PASS with diagnostic FAIL;
- unquantized `419` instead of current-host `q=2` request `420`;
- wrong `q` or a non-integral scale;
- requested/actual client-area mismatch;
- display topology or scale drift during the governed run;
- whole-tile render output outside `projected_canvas_interval`;
- any visible-alpha pixel/column without pointer coverage;
- any clickable pixel/column in true exterior;
- a `4 px` sampled/tapered render-pointer boundary;
- a validator that rejects a legitimate exterior height sentinel merely because
  opaque content does not fill every viewport column.

## 7. Required execution and acceptance

Implementation author must report exact commands and raw exits for:

1. protected-path pre/post SHA no-diff;
2. D-024 `--authority-only` PASS and sealed 2066-entry ledger integrity;
3. parser/script checks for additive seam and both new profile files;
4. exact D-033 height derivation, stable full display-scale list and negative
   rejection of unquantized `419`, wrong `q`, request/readback mismatch and
   topology drift;
5. exact D-034 per-column/per-alpha equivalence, including the default × 50%
   `[0,870)` domain / `[870,1280)` exterior and all required negative fixtures;
6. new pre-checkpoint-2 profile under unchanged governed ordinary-player:
   child exit `0`, process `PASS`, diagnostic `PASS`, supervisor `0`, final PID
   dead, raw logs finalized and evidence eligible;
7. deterministic positive/negative validator tests;
8. actual 12-state readback/capture consistency at the applicable gate;
9. Route A source/copy inventories, SHA-256/byte readback and final verified
   repo-local promotion result;
10. relevant PlayerBoot, Labrador and gameplay/persistence regression suites;
11. static proof that exact `15.0s` is wired only into this D-030 route while
    global/default observer behavior and every other profile remain unchanged;
12. `git diff --check`, exact scope and frozen fingerprint.

Then obtain an independent mechanical verifier verdict. Mechanical PASS only
releases the corresponding implementation gate; it is not visual readiness,
critic READY or user PASS.

## 8. Explicit out of scope

- editing D-024 protected/evidence bytes or rewriting its history;
- changing observer/runner/profile/argv/diagnostic rules except the exact
  smallest D-030-only `15.0s` readiness-budget wiring in section 4.2B;
- new MCP, connector, dispatcher, process supervisor, generic shell/control or
  capture infrastructure;
- implementing Checkpoint 2 roster, art placement or live captures in this
  brief; this brief builds the current profile and validates available state;
- changing selected-H art, hashes, geometry, grid, scale, depth, pivots or
  accepted user-visible pixels;
- gameplay/economy/production/cards/rooms/move/save/schema changes;
- new assets, generation, redraw, binary promotion, Browser, Mobile or Windows;
- commit, push or PR unless separately requested.

## 9. Stop conditions

`STOP` without workaround if:

- any D-024/Labrador/R48/Accepted-ADR protected byte or pin differs;
- implementation needs to edit old D-024 helper/test regions or observer;
- current profile cannot run through the fixed `ordinary-player` route with
  only the exact D-030-only `15.0s` readiness-budget wiring;
- implementing `15.0s` requires broadening a shared/global timeout or changing
  any other route/profile;
- arbitrary/new argv, target, control, capture or infrastructure is required;
- mechanical assertions require changing product/art/Selected-H/D-030 outside
  the exact narrow D-034 supersession;
- any display scale is non-integral or launch topology/scale drifts during run;
- `usable_q < required`, so the accepted full composition cannot fit;
- settled actual client-area readback differs from requested quantized size;
- a governed process/diagnostic gate fails, including CA/certificate recurrence;
- Route A source tree неполон либо promotion inventory/hash/byte readback не
  совпадает;
- production author не работает под explicitly authorized effective
  `:danger-full-access`, появляется interactive approval либо требуется менять
  config/UI/profile или execution route;
- 12 states cannot be distinguished or paired without invented evidence;
- render escapes `projected_canvas_interval`, visible alpha lacks pointer,
  true exterior is clickable or the common boundary is sampled/tapered;
- test seam changes runtime behavior outside exact D-034 or writes
  gameplay/save/progression state;
- concurrent/foreign changes appear in allowed write scope.

Return exact evidence and request the corresponding authority decision. Do not
continue by weakening coverage, adding generic `±1`, retrying to obtain PASS,
excluding a failure or editing protected bytes.

## 10. Rollback

Before implementation record exact baseline hashes. Bounded rollback removes
only the two new current-profile files and reverts the exact Selected-H
render/pointer/seam delta plus status/result lines for this brief. It must leave
Checkpoint 1 accepted evidence, D-024 evidence and all unrelated dirty changes
untouched.

## 11. Required handback

Update `docs/repo/status/CODEX_CURRENT_STATUS.md` with:

- exact changed files and rationale;
- protected/authority hashes and ledger result;
- current-profile schema and gate used;
- positive/negative tests and raw outcomes;
- governed process/diagnostic results;
- matrix coverage actually available, without claiming unavailable roster;
- independent verifier verdict;
- Checkpoint 2 release/HOLD state;
- blockers and final frozen fingerprint.

After re-authorized implementation, its result before independent mechanical
verification must be only `READY FOR INDEPENDENT MECHANICAL VERIFICATION`.
Never claim visual PASS.

## 12. Author result — BLOCKED at governed current-profile run — 2026-07-22

Bounded author changes were made only in the declared scope: additive D-032
seam in `vertical_slice_demo.gd`, the two exact new profile files and these
status/result blocks. Protected D-024 helpers/tests, observer, art, gameplay,
persistence and checkpoint-2 roster were not changed.

Static result: Python stdlib compile plus deterministic validator self-test
`GREEN=1 / RED=9` passed; shell syntax and diff checks passed. Governed
vertical-slice script-check passed with child `0`, process/diagnostic `PASS`,
supervisor `0`, finalized raw logs and dead final PID. D-024 authority-only
digest remained
`4f956a077d0a93575ef7b518fd0aa9fb409392a08fd4a48190364795bc9b5cbf`;
the sealed ledger passed `2066/2066`.

The first full unchanged fixed `ordinary-player` run stopped exactly as this
brief requires. At matrix state `min × 150%`, the seam requested the computed
dynamic height `419`, but macOS `DisplayServer.window_get_size` returned
`720×418`. The seam emitted an exact failure instead of accepting drift.
Observer result: child `0`; process `FAIL`; diagnostic `FAIL`; supervisor `73`
(`DIAGNOSTIC_FAILURE`); raw logs finalized; graceful ACK true; final PID dead;
evidence ineligible. Retained root:
`tmp/d030-current-presentation-xFxgWutF/`; process-result SHA-256
`a2d7d266221a82f1badbbe13dcc3ed9fefa8ce0964617bb5b20c4247a0041409`.

The atomic `matrix.json` was not finalized. Only two complete partial states
exist (`min × 50%`, `min × 100%`; four captures); they are diagnostic only and
must not be promoted as profile evidence. Dedicated regressions and independent
mechanical verification were not started after the mandatory STOP.

No tolerance, allowlist, retry or workaround was introduced. The executed
`419 → 418` run remains real `FAIL`/ineligible evidence and is not retroactively
reclassified.

The user approved D-033: round required height upward to the integral maximum
Godot backing-scale quantum, then require exact settled actual client-area
readback. For the current host `q=2`, the expected ladder becomes
`180 / 280 / 420 / 560`; `min × 150%` is exact `420`. This amendment changes
documentation only: the seam, validator, runner and retained evidence bytes are
unchanged in this authoring wave.

D-033 amendment received independent docs/brief `PASS` in verifier thread
`019f8669-6a2b-7ba3-931e-be4569a29e9e` at freeze
`79cea50502aff44e0dd17265cdb85fb2347ec1d9c5cba855edb714e8622b1fe6`.
Coordinator then re-authorized implementation session
`019f8a55-019b-7690-b624-b860b136ff3c` for the former seam + validator scope.

That continuation produced a complete retained ordinary-player run at
`tmp/d030-current-presentation-hHYpjj9z/`: all `12/12` states and `24/24`
GRID/CLEAN captures were finalized; child/process/diagnostic/supervisor were
`0 / PASS / PASS / 0`. Process-result SHA-256 is
`2552fa49701d66ef63cb5312abf1ee9507f781e5e9851c8fb10359ffd39d9069`,
matrix SHA-256 is
`88e0112f9d0eb23ffd0b57ee05a1ff4c78cc485be4517270f844d9b0f1127e01`,
and the 25-entry manifest SHA-256 is
`e0d45dc18cd365281604924c670f9b2a3eb89416e81e60001854f2e66c8b3745`.

The runner still exited `1` because the strict validator failed at
`default × 50%`: actual window `[1280,180]`, projected canonical interval
`[0,870)`, sampled pointer top min/max
`97.81684428740313 / 180.0`, `transparent_sky_click_through=true` and global
`opaque_content_clickable=false`. Retained captures prove whole-tile visible
alpha through `[0,1152)` with true transparent exterior `[1152,1280)`, while
the pointer profile ends at `[0,870)` and tapers on the `4 px` sample lattice.
This executed validator result remains real `FAIL`/ineligible and is never
retroactive `PASS`.

The user approved D-034 to clip Selected-H render/pointer to the projected
canonical canvas and replace the global viewport-fill assertion with exact
per-column/per-alpha equivalence. The amendments independently passed docs/brief
verification at freeze
`9cd3ac289c90e2c3a4f8dd605b82229118e9f9743ca9c346c5e8cd379dca5e8b`.
Coordinator/Root/King thread `019f8bac-0007-7962-ad8a-ca31fb95ac7f` then read
the accepted contract and recorded `ROOT-APPROVED` bounded continuation for the
same implementation session `019f8a55-019b-7690-b624-b860b136ff3c` to revise
only the Selected-H render/pointer/seam plus current validator. That
re-authorization record passed independent read-only verification, but the
author's latest attempt stopped `BLOCKED BEFORE SPAWN`: unchanged observer
requires system-temp `HOME`/output while the then-active recovery route required
repo-local temp.

The user approved section-4.2A Route A evidence promotion. The independently
verified least-privilege config/profile experiment and both named-profile
pre-project AppKit/HIServices `SIGABRT` runs remain real historical evidence;
neither result is reclassified or used as D-034 code PASS/FAIL.

The user's later direct route-reset decision removes that permission experiment
from the D-034 critical path and authorizes this production wave under effective
`:danger-full-access` / Full Access with unchanged `/private/tmp` runner
behavior. Permission/profile diagnosis continues only in a separate
non-blocking background task. This docs-only recording is `READY FOR
INDEPENDENT DOCS VERIFICATION`; after its `PASS`, Root may re-dispatch the same
production-author task `019f8ee0-1cd9-76e0-846d-58184b4d945a` with zero
tracked write ownership for an exact unchanged-runner production rerun. Frozen
demo/validator bytes, runner, observer, protected D-024 bytes, tooling, assets,
gameplay/save, roster and Checkpoint 2 remain unchanged/forbidden. The first
actual runner/process/validator/suite/protected failure remains a one-shot
`STOP` with no retry.
A fresh governed `12/12` state / `24/24` capture run, relevant suites, Route-A
evidence integrity/promotion and separate independent mechanical verification
remain required. Full live Visual Shell Lock remains `OPEN / NOT GRANTED`;
Checkpoint 2 remains `NOT STARTED / HOLD`.

Full Access route-reset docs later received independent `PASS DOCS ONLY`.
The unchanged governed production run then stopped `rc74` after `19/24`
captures because the spawn-anchored `6.0s` readiness budget expired during
healthy progress; child quit through project-control ACK and evidence remained
ineligible/unpromoted. The authorized two-file performance bugfix changed only
`_d034_image_profile_metrics` plus deterministic differential fixtures:

```text
vertical_slice_demo.gd
  959660edfdace6a6325cc68c3240464e7099ba2c5eb0a97e13e51676cf02e974
test_d030_selected_h_current_presentation.py
  a1e17b2de75090bf66513c457e08b702d2988b18c8fa16495817593eca59e74c
```

Its static semantic proof passed and all 19 common PNGs were byte-identical,
but its one governed run again stopped `rc74` during live progress at `23/24`
captures. No matrix, promotion, suites or independent mechanical PASS exists;
both timeout runs remain real historical FAIL/ineligible evidence.

Direct user approval now sets this route's readiness maximum to exact `15.0s`.
After this amendment receives independent docs `PASS`, the same implementation
author may add only narrow D-030 route-specific readiness wiring, rerun static
and protected gates, then execute exactly one governed Full Access production
run. Global timeout broadening, reduced workload, tolerance and retry-to-pass
remain forbidden. Full live Visual Shell Lock stays `OPEN / NOT GRANTED`;
Checkpoint 2 stays `NOT STARTED / HOLD`.
