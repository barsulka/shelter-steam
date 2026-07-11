# 03_OPEN_QUESTIONS — Shelter

Обновлено: 2026-07-11
Статус: active knowledge / open questions register
Владелец: Project Manager / Producer
Назначение: хранить вопросы, которые ещё не превращены в решения, specs или current-context docs.

---

## 0. Правило ведения

Этот документ — living register, а не история всех обсуждений.

После решения вопрос должен быть перенесён или отражён в:

```text
00_START_HERE/02_DECISIONS.md
00_START_HERE/01_CURRENT_STATUS.md
релевантном product/design/dev doc
релевантном current-context doc
handoff, если нужна история рассуждения
```

Не удалять важную историю без необходимости. Но новые сессии должны видеть в первую очередь **активные** вопросы, а не давно закрытые.

Статусы:

- `open` — вопрос действительно открыт;
- `partially_resolved` — часть решения принята, часть ещё требует работы;
- `resolved` — вопрос закрыт и должен жить в decisions/spec/current-context;
- `deferred` — вопрос сознательно отложен;
- `needs_research` — нужен web/legal/platform/market research.

---

## 1. Active open questions — сейчас важны

### 1.1 Steam/Desktop — ближайший продуктовый scope

#### OQ-Steam-003 — Что считается production art gate после prototype visual-language pass?

Статус: `open`
Владелец: Art Director / Producer

Текущий статус:

```text
STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v3: PASS as First Day Art/UX Visual Language Pass.
NOT production art. NOT final visual style. NOT shipping UX. NOT final animation polish.
```

Открыто:

- когда нужен отдельный production visual style pass;
- какие критерии отличают prototype readability от production readability;
- какие дополнительные production-art sections понадобятся в существующем `ART_DIRECTION__CURRENT_CONTEXT.md` перед следующей большой art-сессией;
- какие old capture packs остаются evidence-only.

Sources:

```text
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Art_UX_Review__First_Day_MVP_v3.md
docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v3/
docs/drive/Shelter/00_START_HERE/SUPERSEDED_MAP.md
```

---

### 1.2 Documentation / Knowledge Base

#### OQ-Docs-001 — Какие старые docs нужно пометить metadata/read_policy?

Статус: `open`
Владелец: Project Manager / Knowledge Base Maintainer

После принятия `05_DOCUMENTATION_GOVERNANCE.md` нужно постепенно размечать старые документы.

Открыто:

- какие capture pack README помечать первыми как `evidence`;
- какие old briefs помечать как `handoff-history` или `superseded`;
- нужно ли физически переносить что-то в `99_ARCHIVE`, или достаточно `SUPERSEDED_MAP.md`;
- нужно ли делать это вручную или через будущий MCP `knowledge_gc_report`.

Source:

```text
docs/drive/Shelter/00_START_HERE/05_DOCUMENTATION_GOVERNANCE.md
docs/drive/Shelter/00_START_HERE/SUPERSEDED_MAP.md
```

---

#### OQ-Docs-003 — Нужно ли split/архивирование `CODEX_STATUS.md` по месяцам?

Статус: `deferred`
Владелец: Project Manager / Codex

Текущий статус:

```text
CODEX_CURRENT_STATUS.md — current dev status.
CODEX_STATUS.md — detailed chronological history.
```

Открыто позже:

- когда `CODEX_STATUS.md` станет технически слишком тяжёлым;
- нужен ли `CODEX_HISTORY_2026_07.md` и monthly split;
- как не потерять ссылочность старых handoff и briefs.

---

### 1.3 Browser Extension / Mobile / Shared Platform

#### OQ-Browser-001 — Browser Extension MVP scope

Статус: `open`
Владелец: Producer / Game Designer / future Tech Lead

Принято:

```text
D-008 — Browser Extension core loop.
D-012 — Browser Farm and Steam Co-op are different parts of one world; MVP link is narrative-only.
```

Открыто:

- какой минимальный Browser Extension MVP scope;
- какой стек расширения;
- какой UX допустим в Chrome Web Store;
- какие данные собираются и зачем;
- какие sponsor/ad mechanics допустимы без давления;
- как формулируется связь “посмотрел рекламу — помог собакам” юридически и этически безопасно.

Requires:

```text
web/platform/legal research before implementation
```

---

#### OQ-Mobile-001 — Mobile product scope and stack

Статус: `deferred`
Владелец: Producer / future Tech Lead

Открыто:

- нужен ли mobile раньше Steam validation;
- является ли mobile отдельной idle/farm game или downstream-адаптацией общей идеи;
- какой стек выбирать;
- какие shared assets/content/contracts нужны.

Пока не блокирует Steam/Desktop.

---

#### OQ-Shared-001 — Общая экономика, аккаунт и синхронизация между продуктами

Статус: `partially_resolved`
Владелец: Producer / future Tech Lead

Принято:

```text
D-012 закрывает MVP-уровень: обязательной технической синхронизации между Browser и Steam нет, связь narrative-only.
```

Открыто:

- когда и при каких условиях переходить от narrative-only связи к soft connection;
- нужен ли общий аккаунт;
- какие части можно шарить: контент, экономика, API, отчётность, ассеты;
- когда появляется общий backend;
- какие риски у charity reporting / trust layer.

---

### 1.4 Charity / Legal / Trust

#### OQ-Charity-001 — Благотворительная отчётность и real-world claims

Статус: `needs_research`
Владелец: Producer / Legal-Finance / specialist review

Открыто:

- точная модель благотворительной отчётности;
- точная модель отношений с реальными приютами;
- нужны ли партнёрские приюты на старте или сначала делаем прототип без реальных переводов;
- как формулировать charity claims честно, проверяемо и юридически безопасно;
- какие disclaimers нужны для ads/sponsorship/donations/subscriptions.

Правило:

```text
Не выдумывать юридические, финансовые и благотворительные утверждения. Нужны web research and specialist review.
```

---

#### OQ-Platform-001 — Browser Extension platform/legal checks

Статус: `needs_research`
Владелец: Producer / future Tech Lead / specialist review

Открыто:

- privacy, consent and personal data;
- advertising SDK and ad formats;
- Chrome Web Store policies;
- sponsorship / product placement disclosure;
- charity reporting and claims.

Блокирует Browser Extension implementation brief.

---

## 2. Partially resolved questions — не читать как blockers

### PRQ-001 — Steam MVP scope

Статус: `partially_resolved`

Было открыто:

> Какой MVP-scope у Steam/Desktop с учётом D-012/D-013?

Текущее состояние:

```text
First Day MVP закрыт на уровне prototype/product-language proof.
Next scope: First Week / Day 2.
```

Не блокирует текущий вход. Остаток вопроса перенесён в OQ-Steam-001 / OQ-Steam-002.

---

### PRQ-002 — Визуальная база проекта

Статус: `partially_resolved`

Принято:

- D-011 — Cozy Modular Diorama as candidate;
- Steam/Desktop — sidescroll production strip;
- Browser Extension — top-down new-tab idle farm direction;
- First Day v3 visual-language pass accepted as prototype proof.

Открыто:

- final art bible;
- production visual style;
- cross-product visual language;
- exact split between Steam sidescroll and Browser top-down farm.

Остаток вопроса перенесён в OQ-Steam-003 and future Art Direction current context.

---

### PRQ-003 — Реальная связь продукта и помощи собакам

Статус: `partially_resolved`

Принято:

```text
D-008 defines Browser loop principle.
D-020 defines ethical project philosophy.
```

Открыто:

- legal/financial reporting;
- public transparency;
- partner shelters;
- exact claims and disclosures.

Остаток вопроса перенесён в OQ-Charity-001 and OQ-Platform-001.

---

## 3. Resolved questions — retained for traceability

### RQ-001 — Какой продукт прототипируем первым?

Статус: `resolved`

Решение:

```text
Active product focus: Steam/Desktop.
```

Sources:

```text
docs/drive/Shelter/00_START_HERE/01_CURRENT_STATUS.md
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__CURRENT_CONTEXT.md
```

---

### RQ-002 — Steam/Desktop engine

Статус: `resolved`

Решение:

```text
D-007 — Godot.
```

---

### RQ-003 — Browser Extension core loop

Статус: `resolved at product-loop level`

Решение:

```text
D-008 — sponsorship/ad block helps accumulate sending resource without guilt pressure.
```

Details of platform/legal/reporting remain open in OQ-Browser-001 / OQ-Platform-001 / OQ-Charity-001.

---

### RQ-004 — Steam/Desktop core structure

Статус: `resolved`

Решение:

```text
D-009 — horizontal dog production co-op, not a classical farm compressed into a strip.
```

---

### RQ-005 — Dog traits model

Статус: `resolved`

Решение:

```text
D-010 — innate/unchangeable traits are separated from changeable/equippable/acquired traits.
```

---

### RQ-006 — Steam resource trips vs visible crop farming

Статус: `resolved`

Решение:

```text
D-013 — Steam/Desktop does not use classical visible crop farming as core; raw resources arrive through off-screen dog trips, transport, timers and physical unloading.
```

---

### RQ-007 — Steam technical spike for Godot window/runtime/tooling

Статус: `resolved at prototype/tooling level`

Решение:

Godot prototype and dev tooling exist:

- companion / transparent strip demos;
- Vertical Slice prototype;
- Godot State Connector;
- Godot Control Connector;
- Workbench Runtime Capture Harness;
- First Day MVP runtime proof;
- Shelter MCP runtime/capture adapter capability; active local boundary is D-021.

Sources:

```text
docs/repo/status/CODEX_CURRENT_STATUS.md
docs/drive/Shelter/04_DEVELOPMENT/CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md
```

---

### RQ-008 — Documentation bloat handling

Статус: `resolved as process`

Решение:

```text
Current Memory first.
Knowledge by task.
History only for evidence / regression / archaeology.
```

Sources:

```text
docs/drive/Shelter/00_START_HERE/05_DOCUMENTATION_GOVERNANCE.md
docs/drive/Shelter/00_START_HERE/BOOTSTRAP_CONTEXT.md
docs/drive/Shelter/00_START_HERE/SUPERSEDED_MAP.md
```

---

### RQ-009 — Нужны ли отдельные current-context docs для Art Direction и Game Design?

Статус: `resolved 2026-07-07; register corrected 2026-07-10`

Решение:

```text
GAME_DESIGN__CURRENT_CONTEXT.md and ART_DIRECTION__CURRENT_CONTEXT.md exist and are active current-summary entry points.
```

Sources:

```text
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/GAME_DESIGN__CURRENT_CONTEXT.md
docs/drive/Shelter/03_DESIGN/ART_DIRECTION__CURRENT_CONTEXT.md
docs/drive/Shelter/00_START_HERE/BOOTSTRAP_CONTEXT.md
```

---

### OQ-Steam-001 — Готов ли First Week / Day 2 direction к реализации?

Статус: `resolved 2026-07-11`

Решение:

```text
First Week Direction v1 принят как направление.
Следующий executable slice сужен до Day 2 Return + одной полностью завершаемой вариации существующей Warm Food Delivery.
```

Source of decision:

```text
D-022 — Steam/Desktop Day 2 executable scope lock
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__First_Week_Direction_v1.md
```

---

### OQ-Steam-002 — Где граница First Week и чего НЕ добавляем?

Статус: `resolved 2026-07-11`

Решение:

- full end-to-end completion обязательна;
- используются та же route/resource family/Basket Bicycle/stations;
- persistence доказывается fixture/capture, без production save/calendar;
- packing note видна на return; optional curiosity question появляется только после completion;
- завершение даёт небольшую progress note, не вторую полноценную postcard/reward cadence;
- active soft choice, habit/research/economy/quality system, новые route/chain/resource/station и production art/platform work не входят.

Canonical brief:

```text
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Day_2_Return_And_Second_Warm_Delivery_v1.md
```

---

## 4. Changelog

### 2026-07-11 — Day 2 scope questions resolved

- Closed OQ-Steam-001 and OQ-Steam-002 through D-022 and the accepted Day 2 scope package.
- Normalized the canonical brief filename and retained OQ-Steam-003 as the independent production-art question.

### 2026-07-10 — migration-wave GC

- Moved stale OQ-Docs-002 to resolved traceability because both role current-context docs already exist.
- Updated MCP wording to the D-021 local domain-adapter boundary.
- Removed the obsolete question about creating `ART_DIRECTION__CURRENT_CONTEXT.md` while preserving the real production-art follow-up.

### 2026-07-07 — PM cleanup / current open questions refresh

- Reorganized file into active open questions, partially resolved questions and resolved traceability items.
- Closed obsolete questions about first product focus, Steam engine and Godot technical spike.
- Reframed Steam MVP questions around First Week / Day 2 executable slice.
- Reframed documentation bloat work around governance, Knowledge GC and MCP Knowledge Layer.
