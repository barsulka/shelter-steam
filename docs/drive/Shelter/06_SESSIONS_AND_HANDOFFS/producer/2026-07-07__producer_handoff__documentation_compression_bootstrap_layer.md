# Producer Handoff — Documentation Compression / Bootstrap Layer

Дата: 2026-07-07
Роль сессии: Producer / Knowledge Base compression
Статус: handoff-history

---

## Что делали

Сессия была посвящена сжатию локальной документации Shelter без потери ключевого контекста.

Проблема: документов, brief-файлов, capture packs, handoff и Codex status entries стало очень много. Новые сессии рискуют тратить контекст на исторические/устаревшие материалы: старые capture packs, уже выполненные Codex briefs, superseded simulator direction, длинный `CODEX_STATUS.md` и промежуточные proof-документы.

Был создан новый слой compressed/current context.

---

## Прочитанные источники

- `PROJECTS_RULES.md`
- `AGENTS.md`
- `README.md`
- `docs/repo/status/CODEX_STATUS.md`
- `docs/drive/Shelter/00_START_HERE/000_ROLE_PRODUCER.md`
- `docs/drive/Shelter/00_START_HERE/00_PROJECT_INDEX.md`
- `docs/drive/Shelter/00_START_HERE/01_CURRENT_STATUS.md`
- `docs/drive/Shelter/00_START_HERE/02_DECISIONS.md`
- `docs/drive/Shelter/00_START_HERE/03_PROJECT_PHILOSOPHY.md`
- `docs/drive/Shelter/00_START_HERE/03_OPEN_QUESTIONS.md`
- `docs/repo/adr/README.md`
- актуальные First Day / First Week docs:
  - `STEAM_DESKTOP__First_Day_MVP_Lock_And_Next_Scope_Decision_v1.md`
  - `STEAM_DESKTOP__First_Week_Direction_v1.md`
  - `STEAM_DESKTOP__Art_UX_Review__First_Day_MVP_v3.md`
- filesystem listings for `docs/**/*.md` and visual deliverables/capture packs.

---

## Ключевые выводы

1. Documentation volume is now high enough that reading all docs is harmful for context recovery.
2. The main problem is not the number of docs, but equal treatment of different document types:
   - active decisions;
   - current status;
   - current summaries;
   - briefs;
   - evidence/captures;
   - handoff history;
   - superseded work;
   - long implementation logs.
3. `01_CURRENT_STATUS.md` had drifted: it still described an early project-setup phase while Steam/Desktop had already reached First Day MVP lock and First Week direction.
4. First Day MVP is now locked at prototype/product-language level; next selected scope is First Week / Day 2 / longer retention.
5. First Day Art/UX v3 is accepted as prototype visual-language pass, not production art or shipping UX.

---

## Принятые решения / подход

No new product gameplay decision was made.

Documentation governance approach accepted by this session:

```text
Shelter documentation becomes layered.
New sessions read Bootstrap + Current Context + relevant role/product docs.
Historical briefs, capture packs, Codex logs and superseded docs remain available as evidence/history, but are explicitly excluded from default context recovery.
```

Introduced document status vocabulary:

- `active`
- `current-summary`
- `reference`
- `evidence`
- `handoff-history`
- `superseded`
- `archive`

---

## Изменённые документы

Created:

```text
docs/drive/Shelter/00_START_HERE/BOOTSTRAP_CONTEXT.md
docs/drive/Shelter/00_START_HERE/SUPERSEDED_MAP.md
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__CURRENT_CONTEXT.md
docs/drive/Shelter/04_DEVELOPMENT/CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md
docs/drive/Shelter/06_SESSIONS_AND_HANDOFFS/producer/2026-07-07__producer_handoff__documentation_compression_bootstrap_layer.md
```

Updated:

```text
docs/drive/Shelter/00_START_HERE/01_CURRENT_STATUS.md
```

`00_PROJECT_INDEX.md` was observed as already updated to reference the new bootstrap/current-context layer during this session's verification pass.

---

## Что теперь читать новым сессиям

Default order:

1. `PROJECTS_RULES.md`
2. `AGENTS.md`
3. `README.md`
4. `docs/drive/Shelter/00_START_HERE/BOOTSTRAP_CONTEXT.md`
5. role-doc from `00_START_HERE/000_ROLE_*.md`
6. relevant current-context doc:
   - Steam: `STEAM_DESKTOP__CURRENT_CONTEXT.md`
   - Codex: `CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md`
7. deep docs only for the concrete task.

Use `SUPERSEDED_MAP.md` before reading old evidence/history.

---

## Открытые вопросы

1. Нужно ли физически переносить старые completed briefs / capture packs в `99_ARCHIVE`, или достаточно read-policy через `SUPERSEDED_MAP.md`?
2. Нужно ли разбить `docs/repo/status/CODEX_STATUS.md` на current + historical monthly files?
3. Нужно ли добавить metadata status blocks в существующие old docs массово, или делать это постепенно при касании документов?
4. Нужно ли создать отдельный `ART_DIRECTION__CURRENT_CONTEXT.md` для Art Director, если следующая большая сессия будет визуальной?
5. Нужно ли создать `GAME_DESIGN__CURRENT_CONTEXT.md`, или Steam current-context достаточно для ближайшего Day 2 scope?

---

## Что обновить в документах дальше

Recommended follow-up cleanup:

1. Update `00_PROJECT_INDEX.md` if future verification shows it does not reference `BOOTSTRAP_CONTEXT.md` and `SUPERSEDED_MAP.md`.
2. Optionally add status/read-policy metadata to old capture pack README files.
3. Optionally split `CODEX_STATUS.md` into shorter current file + archive history.
4. Update `03_OPEN_QUESTIONS.md`, because it still contains some questions that are now partially/fully addressed by First Day lock and First Week direction.

---

## Следующий лучший шаг

Product:

```text
Producer decides whether `STEAM_DESKTOP__First_Week_Direction_v1.md` is ready to become the next narrow Codex implementation brief.
```

Potential next brief:

```text
docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Second_Day_Return_And_Second_Order_v1.md
```

Recommended Codex reasoning level:

```text
очень высокий
```

Documentation:

```text
Keep the new current-context layer fresh after every major product/design/dev status change.
```
