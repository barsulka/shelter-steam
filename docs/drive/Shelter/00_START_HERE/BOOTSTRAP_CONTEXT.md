# BOOTSTRAP_CONTEXT — Shelter compressed entry point

Обновлено: 2026-07-22
Статус: active current-summary
Владелец: Producer / Project Manager
Назначение: дать новой сессии одну короткую актуальную карту Shelter.

---

## 0. Read route

При `health=current` routine entry начинается с
`shelter_context_bundle(role, area, task, max_bytes)`. Source documents всегда
остаются authority; direct read обязателен для exact brief/ADR/contract,
конфликта, fallback/omission и перед source editing.

Порядок exact read:

1. `PROJECTS_RULES.md`
2. `AGENTS.md`
3. `README.md`
4. relevant role doc
5. relevant current-context
6. task-specific Knowledge

Superseded/history ищется через Git только при evidence/regression/archaeology.

## 1. Project identity

Shelter — семейство тёплых, спокойных и этичных приложений/игр о собаках и
приютах. Активный продукт — Steam/Desktop. Browser, Mobile, новый MCP и новая
инфраструктура заморожены до приятного playable shell.

Формула Steam/Desktop:

```text
cozy idle production strip + dog community sim
```

Производство остаётся ядром; жизнь собак делает его живым. Запрещены бои,
гильт-прессинг, paid gacha, агрессивный FOMO и манипулятивная
благотворительность.

## 2. Current priority

Текущая программа состоит из двух последовательных milestone:

1. **Visual Shell Lock** — весь текущий roster поляны плюс Labrador, единая
   гармоничная композиция, масштабы/расположение/подземная часть/default camera,
   четыре zoom и min/default/max window sizes. CQ Hero Town — референс гармонии,
   но используются только принятые Shelter assets. Selected H GRID32 уже имеет
   static `USER_ACCEPTED / PASS`, а runtime Checkpoint 1 получил отдельный user
   `PASS`. Checkpoint 2 ждёт implementation и independent mechanical `PASS`
   активного D-032 current regression profile; затем продолжаются faithful
   integration и user live-matrix gate.
2. **Interactive Shelter Shell** — living dogs, entity cards, одна room panel и
   физическое перемещение здания, но без производящего gameplay результата.

Day 1/Day 2 убраны из текущей очереди в будущее. Их runtime/persistence
реализация остаётся regression baseline, а не активным player plan.

Canonical roadmap:

```text
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Game_Design_Roadmap_v2.md
```

## 3. Current runtime baseline

- D-024 ordinary-Terminal pack sealed и проверяет pre-D-030 mechanical state;
  это не текущий visual proof.
- D-030 implemented: fixed 26-cell meadow period, no stretch, whole-game zoom,
  dynamic strip height и alpha-aware click surface.
- Selected H GRID32 static contract принят пользователем 2026-07-22; его final
  grid band — `y[441,473)`, height `32`, earth margins `25/7`.
- D-030 остаётся механической стартовой точкой; selected H заменяет его как
  статическую visual target, но live runtime ещё не получил user lock.

## 4. Acceptance authority

Static exploration завершён пользовательским выбором selected H GRID32. Теперь
пользователь проверяет faithful live scene на min/default/max windows и всех
четырёх zoom; каждый checkpoint содержит обе пары `GRID` и `CLEAN`. Automatic
checks дают только technical/diagnostic result и не могут выдать финальный
visual `PASS`.

После lock любое видимое изменение требует нового user approval.

Manual cadence:

```text
selected H static PASS → chosen live scene → cards → move → rooms → integrated shell
```

## 5. Current entry points

```text
docs/drive/Shelter/00_START_HERE/01_CURRENT_STATUS.md
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__CURRENT_CONTEXT.md
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/GAME_DESIGN__CURRENT_CONTEXT.md
docs/drive/Shelter/03_DESIGN/ART_DIRECTION__CURRENT_CONTEXT.md
docs/drive/Shelter/04_DEVELOPMENT/CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md
docs/repo/status/CODEX_CURRENT_STATUS.md
```

Active independently verified bounded Codex briefs:

```text
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Selected_H_Visual_Shell_Runtime_Integration_And_Live_Matrix_v1.md
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__D030_Selected_H_Current_Presentation_Regression_Profile_v1.md
```

## 6. Active decision / philosophy docs

Текущая milestone/acceptance authority — D-031 в `02_DECISIONS.md`. Этические и
продуктовые границы читаются в `03_PROJECT_PHILOSOPHY.md` и соответствующих role
docs; они не заменяются historical briefs.

### Active boundaries

- Gameplay/economy may continue under the hood only without visible-scene or
  locked-UX changes.
- Legacy fences, polygon dogs and visual artifacts are removed from active
  runtime by the selected-H implementation brief; pinned evidence bytes remain.
- Windows remains a later pre-release wave; current work/acceptance is macOS.
- Every significant Codex implementation requires a separate accepted brief.

## 7. Documentation rule

Current truth and active Knowledge stay in checkout. Completed/superseded
Markdown is deleted after dependency/link audit and remains recoverable through
Git history. Accepted ADR and exact validator/hash/seal dependencies remain.
