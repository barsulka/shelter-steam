# STEAM_OVERLAY — Readability Pass 216 / 144 / 96 v1

Дата: 2026-06-25  
Роль документа: Readability test result  
Связано с: `STEAM_OVERLAY__Approved_Library_v1`

## 1. Purpose

Проверить Approved Library v1 на трёх высотах:

- **216 px** — comfort mode;  
- **144 px** — working minimum;  
- **96 px** — stress test.

Важно: это не финальный технический export-size, а арт-директорская проверка читаемости.

Contact sheet generated locally:

`STEAM_OVERLAY__approved_library_v1_readability_216_144_96.png`

В Drive upload этого contact sheet пока не выполнен: Google Drive connector принимает image upload только для connector file references, а не для Python-generated local file. Файл доступен в текущей рабочей среде как sandbox artifact.

## 2. Pass / fail scale

- **PASS** — читается в текущем виде.  
- **PARTIAL** — читается, но требуется production simplification.  
- **FAIL** — для main overlay не проходит.

## 3. Results summary

### Mill v2 — Utility Prop

216 px: PASS.  
144 px: PASS.  
96 px: PARTIAL PASS.

Notes:  
- Силуэт мельницы читается даже на 96 px.  
- Такса и тележка на 96 px становятся мелкими, но общий dog action остаётся понятным.  
- Optional: усилить контраст лопастей и мешка; сделать проп чуть уже.

Verdict: **approved as direction**.

### Storage v2 — Building

216 px: PASS.  
144 px: PASS.  
96 px: PARTIAL PASS.

Notes:  
- Building silhouette читается.  
- Собака и ящик читаются, но на 96 px внутренние мешки становятся шумом.  
- Optional: упростить внутреннюю детализацию для production version.

Verdict: **approved as direction / simplify internals later**.

### Kitchen v2.1 — Building

216 px: PASS.  
144 px: PASS.  
96 px: PARTIAL PASS.

Notes:  
- Иконка кастрюли и общий kitchen silhouette читаются.  
- Собака на 96 px видна, но action почти теряется.  
- Optional: меньше interior detail, больше один главный action-object рядом с собакой.

Verdict: **approved with minor optional simplification**.

### Water Station v2 — Utility Prop

216 px: PASS.  
144 px: PASS.  
96 px: PASS / PARTIAL PASS.

Notes:  
- Очень хороший Utility Prop: бак, труба и собака с лейкой читаются.  
- На 96 px вода/струя почти теряется, но лейка и бак остаются понятны.

Verdict: **approved as direction**.

### Decor Workshop v2 — Utility Workbench

216 px: PASS.  
144 px: PASS.  
96 px: PARTIAL PASS.

Notes:  
- Workbench + dog painting читаются хорошо на 216/144.  
- На 96 px кисть уже мелкая, но доска и поза собаки всё ещё держат смысл.  
- Optional: увеличить кисть/доску или сократить мелкие предметы на столе.

Verdict: **approved as direction**.

### Dog Action — Dachshund Cart

216 px: PASS.  
144 px: PASS.  
96 px: PASS.

Notes:  
- Один из лучших readability assets.  
- Dog + cart + bag читаются даже на 96 px.

Verdict: **approved as dog action direction**.

### Dog Action — Labrador Watering

216 px: PASS.  
144 px: PASS.  
96 px: PASS / PARTIAL PASS.

Notes:  
- Dog + watering can читаются очень хорошо.  
- На 96 px вода/струя почти пропадает, но действие остаётся понятно.

Verdict: **approved as dog action direction**.

### Dog Action — Husky Painting

216 px: PASS.  
144 px: PASS.  
96 px: PASS / PARTIAL PASS.

Notes:  
- Dog + board читаются.  
- На 96 px кисть мелкая, но действие “работа с доской” всё ещё считывается.

Verdict: **approved as dog action direction**.

## 4. Overall result

Approved Library v1 проходит readability sanity check.

Общий статус:

- 216 px: PASS for all.  
- 144 px: PASS for all.  
- 96 px: PASS / PARTIAL PASS; no hard failures.

Критичных fail нет.

## 5. Production implications

Для production нужно помнить:

1. 144 px остаётся главным рабочим минимумом.  
2. 96 px использовать как stress test, не как режим, где обязан читаться весь декор.  
3. На 96 px должны читаться dog + action + object / module silhouette.  
4. Мелкий декор, таблички, кисти, струи воды, внутренние мешки и полки могут исчезать — это нормально.  
5. Если asset важен только за счёт мелкого декора, он не годится.

## 6. Required simplification notes

Перед production export:

- уменьшить внутренний шум Storage v2;  
- подсушить Kitchen v2.1;  
- усилить кисть/доску у Decor Workshop / Husky Painting;  
- убедиться, что dog action sprites имеют отдельные прозрачные версии;  
- подготовить sprite-friendly silhouettes для 144 px.

## 7. Next step

Собрать следующий пакет:

1. Greenhouse v2.  
2. Packing Station v2.  
3. Signpost / Notice Board Utility Prop.  
4. Corgi carrying food bag.  
5. Mixed-breed pushing crate.

Цель следующего пака: проверить, что approved library v1 масштабируется на новые сущности без возврата к “каждая функция = домик”.
