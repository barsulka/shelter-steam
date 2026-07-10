# Shelter — индекс проекта

Стартовый индекс проекта. Любой новый чат, дизайн-сессия, продюсерская сессия или dev/Codex-сессия должна восстанавливать контекст через локальные документы, а не по памяти.

---

## Читать в первую очередь

Базовый порядок для новой серьёзной сессии:

1. Repo root: `PROJECTS_RULES.md` — правила проекта.
2. Repo root: `AGENTS.md` — правила агентов.
3. Repo root: `README.md` — карта монорепозитория.
4. `00_START_HERE/BOOTSTRAP_CONTEXT.md` — сжатый актуальный вход.
5. `00_START_HERE/01_CURRENT_STATUS.md` — текущая картина проекта.
6. `00_START_HERE/02_DECISIONS.md` — принятые решения.
7. `00_START_HERE/03_PROJECT_PHILOSOPHY.md` — философия / constitution Shelter.
8. Role-doc: `00_START_HERE/000_ROLE_*.md`.
9. Релевантный current-context документ по зоне задачи.
10. Только после этого — deep docs по конкретной задаче.

Документация уже стала большой. Не восстанавливай проект через все старые briefs, capture packs, handoff и длинный Codex-log. Используй:

```text
00_START_HERE/BOOTSTRAP_CONTEXT.md
00_START_HERE/SUPERSEDED_MAP.md
```

---

## Current-context documents

Для быстрого входа:

```text
00_START_HERE/BOOTSTRAP_CONTEXT.md
00_START_HERE/SUPERSEDED_MAP.md
00_START_HERE/05_DOCUMENTATION_GOVERNANCE.md
02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__CURRENT_CONTEXT.md
04_DEVELOPMENT/CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md
docs/repo/status/CODEX_CURRENT_STATUS.md
```

Эти документы говорят, что сейчас актуально, а что является Knowledge, History, evidence или superseded.

Главное правило документации:

```text
Current Memory читается на входе.
Knowledge читается по задаче.
History читается только для evidence/regression/archaeology.
```

---

## Продукты

- Desktop/Steam idle-игра для Windows/macOS: `02_PRODUCTS/01_STEAM_DESKTOP/`.
- Мобильная idle/farm-игра: `02_PRODUCTS/02_MOBILE/`.
- Браузерное расширение: «посмотри рекламу — накорми собак»: `02_PRODUCTS/03_BROWSER_EXTENSION/`.
- Общие механики и принципы: `02_PRODUCTS/00_SHARED/`.

---

## Текущий фокус

Текущий активный фокус: **Steam/Desktop**.

Актуальный статус:

```text
First Day MVP закрыт на уровне prototype/product-language proof.
Следующий выбранный scope: First Week / Day 2 / longer retention.
```

Главный текущий Steam-context:

```text
02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__CURRENT_CONTEXT.md
```

---

## Ключевые ограничения проекта

- Проект про собак, приюты, заботу, помощь и регулярное возвращение пользователя.
- Project Philosophy: Shelter делает богаче жизнь, а не склад.
- Shelter — производственный кооператив, в котором живут собаки.
- Производство остаётся ядром; жизнь собак делает это ядро живым.
- Любая система должна сначала объяснять, как делает жизнь кооператива интереснее, и только потом — какие игровые бонусы создаёт.
- Для крупных систем и релизных этапов использовать `04_SHELTER_STRESS_TESTS`: Excel Test, Factory Test, The Sims / Tamagotchi Test, Dog Test, D-020 Test and related identity checks.
- Игра должна быть простой, тёплой, спокойной, но затягивающей.
- Не использовать бои, PvP, арены, боссов, монстров, paid gacha и агрессивный FOMO.
- Благотворительная механика должна быть добровольной, прозрачной и не манипулятивной.
- Steam/Desktop может использовать минималистичную always-on-top полоску/поле.
- Важны медленные физически видимые действия собак/персонажей: идти, строить, переносить, поливать, собирать, обслуживать, кормить, чинить, ухаживать.

---

## Где что хранится

- `00_START_HERE/` — индекс, bootstrap, current status, decisions, philosophy, open questions, role docs, collaboration protocol.
- `01_PRODUCT_STRATEGY/` — видение, аудитория, благотворительная модель, retention, roadmap.
- `02_PRODUCTS/` — PRD и продуктовые документы по трём продуктам.
- `03_DESIGN/` — арт-дирекшен, референсы, UI/UX, промпты, ассеты, visual deliverables.
- `04_DEVELOPMENT/` — dev briefs, acceptance/review docs, current implementation context.
- `05_RESEARCH/` — рынок, благотворительные приложения/игры, донаты, rewarded ads, платформы, конкуренты.
- `06_SESSIONS_AND_HANDOFFS/` — логи длинных сессий, handoff и cross-role RFC.
- `07_LEGAL_FINANCE_CHARITY/` — юридические, финансовые и благотворительные вопросы, требующие проверки специалистом.
- `90_INBOX_RAW/` — сырые загруженные материалы до разбора.
- `99_ARCHIVE/` — архив устаревших материалов.

---

## GitHub / repo / Codex

Repo source of truth:

```text
/Users/barsulka/GolandProjects/shelter/shelter
```

Steam project:

```text
steam/
```

Active local working model (D-021):

```text
ChatGPT Work / Codex -> direct access to the current checkout.
mcp/ -> optional local domain-specific runtime/inspection adapter.
MCP setup -> `.codex/config.toml` + `mcp/run.sh` over local STDIO.
```

The D-021 MCP/config migration is complete.

Codex / dev sessions should read:

```text
PROJECTS_RULES.md
AGENTS.md
README.md
steam/AGENTS.md
steam/README.md
docs/repo/adr/README.md
04_DEVELOPMENT/CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md
```

For technical implementation, read relevant accepted ADRs before changing code, runtime contracts, connector APIs, saves, snapshots, platform behavior or dev tooling.

Significant Codex tasks must be assigned through brief files in:

```text
docs/drive/Shelter/04_DEVELOPMENT/
```

---

## Evidence / history policy

Do not read by default:

- old capture PNG folders;
- old visible review capture packs v1/v2 when v3 is enough;
- old Vertical Slice Art QA capture packs when First Day v3 is enough;
- old completed Codex briefs;
- old handoff history except latest relevant one;
- superseded standalone simulator brief;
- long historical sections of `docs/repo/status/CODEX_STATUS.md`.

Use:

```text
00_START_HERE/SUPERSEDED_MAP.md
```

---

## Последняя передача контекста

2026-07-10: `06_SESSIONS_AND_HANDOFFS/codex/2026-07-10__codex_handoff__chatgpt_work_local_mcp_migration.md` — implementation handoff по локальному ChatGPT Work/Codex и Shelter MCP.

2026-07-07: `06_SESSIONS_AND_HANDOFFS/producer/2026-07-07__producer_handoff__documentation_governance_and_gc.md` — producer/PM handoff по Documentation Governance, Current / Knowledge / History and Knowledge GC.

2026-07-07: `06_SESSIONS_AND_HANDOFFS/producer/2026-07-07__producer_handoff__documentation_compression_bootstrap_layer.md` — producer-handoff по сжатию документации, Bootstrap Context, Superseded Map и current-context layer.

2026-06-30: `06_SESSIONS_AND_HANDOFFS/producer/2026-06-30__producer_handoff__project_philosophy` — producer-handoff по D-020: Project Philosophy / Constitution Shelter.

2026-06-29: `06_SESSIONS_AND_HANDOFFS/producer/2026-06-29__producer_handoff__collaboration_protocol_and_codex_rfc` — producer-handoff по D-015: межролевой Collaboration Protocol и первый Cross-role RFC по границам задач Codex для Steam Vertical Slice.

2026-06-25: `06_SESSIONS_AND_HANDOFFS/producer/2026-06-25__producer_handoff__shared_world_resource_trips` — producer-handoff по D-012/D-013: общий мир Browser Farm ↔ Steam Co-op и Steam resource trips вместо видимого crop farming.

Предыдущий дизайн-handoff: `06_SESSIONS_AND_HANDOFFS/design/2026-06-25__design_handoff__steam_overlay_v1_prompt_system` — Steam Overlay Main Strip v1, approved reference и reusable prompt system.

---

## Changelog

### 2026-07-10 — ChatGPT Work migration wave

- Recorded the D-021 local Work/Codex access model.
- Classified `mcp/` as an optional domain-specific adapter and linked the migration handoff.
- Kept product scope unchanged.

### 2026-07-07 — bootstrap/current-context update

- Added `BOOTSTRAP_CONTEXT.md` as primary compressed entry point.
- Added `SUPERSEDED_MAP.md` as do-not-read-by-default / evidence / superseded map.
- Added current-context pointers for Steam/Desktop and Codex.
- Updated current focus to First Day MVP lock and First Week / Day 2 next scope.
