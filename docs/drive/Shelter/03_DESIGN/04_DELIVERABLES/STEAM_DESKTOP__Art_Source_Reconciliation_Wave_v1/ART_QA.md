# Art QA

- Owner verdict: **SOURCE_RECONCILED / ART_WARN_PENDING_USER_SOURCE_REVIEW**
- Runtime Art PASS: **NO**
- Approved-library promotion: **NO — pending explicit PM/User source acceptance**

## Машинный readback

`QA_REPORT.json`: 157 checks, 157 PASS, 0 FAIL.

Проверено:

- 24/24 pose families; non-shadow alpha height ровно 225 px;
- положительные canvas bounds, root `[256,280]`, shared baseline и no-crop envelope;
- authored right/left и оба physical-turn направления; negative-scale shortcut отсутствует;
- transparent RGB zero; четыре угла alpha=0; border transparent ratio ≥0.95;
- opaque bbox не совпадает с crop rectangle; нет длинных neutral-white rows/columns;
- bounded low-alpha neutral fringe;
- 2992×224 full authored corridor и прозрачный upper reserve;
- faint-tree layer max RGB ≤120 и max alpha ≤88;
- D-011 rhythm max gap ≤300 px;
- Sheet A отсутствует;
- projected dog height `92.8551724137931 px < 224` при declared mapping.

## Визуальный self-readback

PASS:

- `evidence/full_layout/full_layout_native_2992x224_rgba.png` на transparent/checker;
- `evidence/full_layout/full_layout_desktop_composite_2992x224.png` на реальном тёмном desktop;
- `evidence/world/world_assets_black_board.png` и `world_assets_checker_board.png` для всех anchors;
- обе стороны Kitchen и Packing в `evidence/stations/`;
- `evidence/labrador/labrador_A_H_action_coverage_board.png`;
- `evidence/labrador/labrador_silhouette_board.png`;
- все 24 identity/action poses и silhouettes на 216/144/96;
- `evidence/comparisons/labrador_identity_reference_comparison.png`;
- `evidence/comparisons/world_D011_v5_new_comparison.png`.

Фактический результат: белые прямоугольные cell backgrounds, speckled alpha, sky matte и неавторский brown tail устранены. Meadow непрерывен; faint trees читаются как нижняя глубина, а не облака; building rhythm, baseline и тёплая иерархия заметно ближе к D-011. Storage, Packing, Van, Bicycle, meadow, contacts, A–H, facing/turn и silhouette gates приняты source owner.

## Station/source truth

Kitchen и Packing имеют обе стороны approach/contact/work/exit, allowed facing, head/paw contact planes и source-level anchors в `SOURCE_MANIFEST.json`. Contact registration использует bounded 2 px source overlap. Front fence исключён из station corridors. Station front lip может скрывать только distal contacting paw tips; muzzle/head/chest/torso скрывать нельзя.

Это source mapping, не runtime evidence. Никакой object transfer не заявлен.

## Advisory P1 — explicit user/PM review

1. **Dog identity:** часть corpus может читаться чуть более пушистой/Golden-like из-за воротника и coat texture относительно user three-view. Competing evidence: пользователь прямо сообщил, что получившееся направление ему нравится. Решение — accept as-is либо отдельный bounded identity grade после user/PM pin; не новый action/pose wave.
2. **Kitchen detail:** current derivative верно следует detailed approved Kitchen v2.1, но D-011 at-strip read допускает более тихий service facade. Нужен user/PM выбор authority; source owner не перепроектирует approved direction молча.
3. **Mill mass:** static Mill faithful approved direction при review-height 188 px заметен в 224 px strip. Нужен user/PM accept-as-is или точный bounded scale instruction; baseline и static zero-mechanic role менять нельзя.

P0: 0. Эти advisory не ослабляют alpha/layout/source package PASS, но удерживают promotion и overall user-facing acceptance.

## Следующие ворота

1. PM/User source-review по visual boards и трём advisory.
2. При acceptance — точечное promotion решение для `approved_art_files/`; текущая wave сама туда не пишет.
3. Отдельный accepted Codex brief в `04_DEVELOPMENT`.
4. Runtime integration без новых mechanics/entities.
5. Immutable actual captures, независимый runtime Art review и explicit user acceptance.
