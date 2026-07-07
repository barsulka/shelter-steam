# 01_CURRENT_STATUS

Обновлено: 2026-07-07
Статус: active current status
Владелец: Producer / Project Manager

---

## Кратко о проекте

Shelter — группа добрых приложений/игр вокруг темы помощи собакам и приютам.

Планируемые продукты:

1. Desktop/Steam idle-игра для Windows/macOS.
2. Мобильная idle/farm-игра.
3. Браузерное расширение: «посмотри рекламу — накорми собак».

Главная философия D-020:

```text
Shelter делает богаче жизнь, а не склад.
Shelter — это производственный кооператив, в котором живут собаки.
```

---

## Текущий фокус

Активный продуктовый фокус: **Steam/Desktop**.

Текущий этап Steam/Desktop:

```text
First Day MVP закрыт на уровне prototype/product-language proof.
Следующий выбранный scope: First Week / Day 2 / longer retention.
```

Главный текущий вопрос:

```text
Зачем игрок возвращается завтра после первой тёплой поставки?
```

Актуальный вход в Steam-контекст:

```text
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__CURRENT_CONTEXT.md
```

---

## Актуальный bootstrap / сжатие контекста

Документация проекта стала большой. Для новых сессий введён сжатый слой входа:

```text
docs/drive/Shelter/00_START_HERE/BOOTSTRAP_CONTEXT.md
docs/drive/Shelter/00_START_HERE/SUPERSEDED_MAP.md
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__CURRENT_CONTEXT.md
docs/drive/Shelter/04_DEVELOPMENT/CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md
```

Новые сессии не должны восстанавливать проект через все старые briefs, capture packs, handoff и длинный `CODEX_STATUS.md`.

Стандартный порядок входа:

1. `PROJECTS_RULES.md`
2. `AGENTS.md`
3. `README.md`
4. `00_START_HERE/BOOTSTRAP_CONTEXT.md`
5. role-doc
6. релевантный current-context документ
7. deep docs только по задаче

---

## Steam/Desktop — актуальный статус

Steam/Desktop — Godot 4.x desktop game для Windows/macOS в формате горизонтальной always-on-top sidescroll полоски.

Принятая формула D-009:

```text
cozy idle production strip + dog community sim
```

Сырьевые ресурсы в Steam не выращиваются через классический видимый crop farming. По D-013 они добываются через off-screen поездки собак на внешние фермерские локации, а Steam-полоска остаётся кооперативом/мастерской.

First Day MVP locked elements:

```text
Такса — первый водитель
Лабрадор — спокойный помощник
Route — Овсяная ферма / route.oat_farm_intro
Order — Первая тёплая поставка / order.first_warm_delivery
Reward — Удобные тапочки для Таксы
Memory — Помнит первую тёплую поставку
```

First Day visual-language status:

```text
STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v3: PASS as First Day Art/UX Visual Language Pass.
NOT production art. NOT final visual style. NOT shipping UX. NOT final animation polish.
```

Next scope:

```text
First Week / Day 2 should show that yesterday mattered.
```

Source docs:

```text
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__First_Day_MVP_Lock_And_Next_Scope_Decision_v1.md
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__First_Week_Direction_v1.md
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Art_UX_Review__First_Day_MVP_v3.md
```

---

## Development / Codex status summary

Godot prototype and dev tooling exist.

Implemented / available:

- Godot Steam/Desktop project under `steam/`.
- Desktop window / companion strip tech demos.
- Vertical Slice prototype.
- Dog rig spikes and dog runtime integration slice.
- Godot State Connector.
- Godot Control Connector.
- Workbench Runtime Capture Harness.
- Shelter MCP preferred local bridge.
- First Day MVP runtime proof.
- First Day visible review capture packs v1/v2/v3.
- First Day Art/UX visual-language pass v1 implemented and accepted as prototype pass.

Latest detailed dev log:

```text
docs/repo/status/CODEX_STATUS.md
```

Compressed dev entry:

```text
docs/drive/Shelter/04_DEVELOPMENT/CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md
```

---

## Зафиксированные продуктовые решения — summary

Full source:

```text
docs/drive/Shelter/00_START_HERE/02_DECISIONS.md
```

Important active decisions:

- D-001 — Google Drive / local mirror as knowledge base.
- D-002 — GitHub/repo docs as development source of truth.
- D-003 — serious sessions start from project index / local docs.
- D-004 — Codex requires `AGENTS.md`.
- D-005 — kind, calm, ethical Shelter tone.
- D-006 — three-product family.
- D-007 — Steam/Desktop engine: Godot.
- D-008 — Browser Extension core loop.
- D-009 — Steam/Desktop horizontal dog production co-op.
- D-010 — innate vs acquired/equipment dog traits.
- D-011 — Cozy Modular Diorama visual candidate.
- D-012 — Browser Farm and Steam Co-op as two parts of one world; MVP narrative-only link.
- D-013 — Steam resource trips replace visible crop farming.
- D-014 — role boundaries and working roadmaps.
- D-015 — cross-role collaboration via RFC docs.
- D-016 — Codex implementation boundaries for Steam Vertical Slice.
- D-017 — significant Codex tasks through `04_DEVELOPMENT/` brief files.
- D-018 — gameplay proof / visual proof split; no standalone simulator.
- D-019 — Game Design Systems Workbench over live Godot runtime.
- D-020 — Project Philosophy / Shelter Constitution.

---

## Текущие ограничения

- Project Philosophy: Shelter делает богаче жизнь, а не склад.
- Shelter — производственный кооператив, в котором живут собаки.
- Производство — ядро; жизнь собак делает это ядро живым.
- Любая система должна сначала объяснять, как делает жизнь кооператива интереснее, и только потом — какие игровые бонусы создаёт.
- Никаких боёв, PvP, боссов, монстров, арен, paid gacha, агрессивной соревновательности.
- Благотворительность — добровольная, прозрачная, этически совместимая.
- Steam/Desktop не должен превращаться в Browser Extension: no search bar, sponsorship/ad block, rewarded ads or Chrome new-tab UX.
- Steam/Desktop First Day lock не означает production art / shipping UX / final balance / Steam release readiness.

---

## Не читать по умолчанию

Use `SUPERSEDED_MAP.md` before historical digging.

Do not read by default:

- old capture PNG folders;
- First Day visible review v1/v2 when v3 is enough;
- old Vertical Slice Art QA capture packs;
- old completed Codex briefs;
- old handoff history except latest relevant one;
- superseded standalone simulator brief;
- long historical sections of `CODEX_STATUS.md`.

---

## Следующий лучший шаг

Product / Game Design:

```text
Producer confirms whether First Week Direction v1 is ready to become a narrow next implementation slice.
```

Potential next Codex brief:

```text
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Second_Day_Return_And_Second_Order_v1.md
```

Suggested Codex reasoning level if assigned:

```text
очень высокий
```

Documentation / PM:

```text
Keep BOOTSTRAP_CONTEXT, SUPERSEDED_MAP, STEAM_DESKTOP__CURRENT_CONTEXT and CODEX__CURRENT_IMPLEMENTATION_CONTEXT updated after major decisions, reviews and dev tasks.
```

---

## Changelog

### 2026-07-07 — documentation compression / current status refresh

- Updated current status from old project-setup phase to actual Steam/Desktop First Day / First Week state.
- Added bootstrap/current-context layer as default entry route.
- Added evidence/history do-not-read-by-default policy.
- Pointed new sessions to current Steam and Codex context docs.

### 2026-07-02 — Shelter MCP update

- Shelter MCP documented as preferred local dev / ChatGPT inspection bridge.
