# STEAM R48-05A — Labrador Runtime Capture v5

Статус pack: **local Technical PASS / bounded runtime Art mask review pending / overall player-facing visual coherence CHANGES_REQUIRED / USER_OWNER_REJECTED_CURRENT_LOOK**.

Этот immutable correction pack относится только к Art resolutions
`A) ACCEPT_STATE_SPECIFIC_WORK_ENVELOPE` и
`C) ACCEPT_BOUNDED_OCCLUSION_POLICY` для существующего R48-05A brief.

Locked inputs: uniform positive scale `0.24`, PlayerBoot `2992x224`, current
root/baseline/pivots, Kitchen `104.16/62.88/54.24`, Packing
`104.16/60.00/50.88`, existing source and animation timing/library.

Единственная visual mutation — derived/non-persisted selector-scoped local
segmentation существующего `world.fence.front_span` для Packing D/F/G и
contact-held EXIT/recovery. Она не создаёт gameplay authority, не меняет source,
station, global z, object transfer или persistence.

`capture_manifest.json` — источник фактических измерений и Technical verdict:

- реальный PlayerBoot `2992x224`, full usable width, bottom delta `0`, window
  contract не менялся;
- uniform positive scale `0.24`, один runtime и один Labrador, no crop;
- минимумы complete bbox по state family при `216/144/96`: general
  `80/54/36`, Kitchen E `74/49/33`, Packing F `79/53/35`, focus G
  `73/49/32`; минимальные native top/bottom margins — `89/31 px`;
- Kitchen muzzle gap `3.714207 px`, Packing `2.063448 px`; muzzle и working paw
  находятся внутри accepted plane на обеих сторонах;
- Packing mask: `8/8` positive и `6/6` negative cells; фактическое допустимое
  paw-tip hiding `0 px`, запрещённое перекрытие `0` screen pixels / `0`
  source-alpha samples. До локальной сегментации worst raw overlap был
  `404/2239`, поэтому доказательство проверяет реальное устранение overlap;
- четыре normal-speed strip имеют шесть видимых равных root intervals и
  `max_interval_ratio=0.166667`; оба turn root-locked и не используют negative
  scale;
- A–G/negative G, cancellation/recovery, `legacy_unbound=3`, all six negative
  lanes и `transfer_acceptance_cells=0` сохранены.

D contact-lock evidence снимается в последней разрешённой точке D-интервала
(`0.99 * 0.18` normalized work phase), где неизменённый `base_contact` clip уже
достиг contact lock. Это изменение только capture-helper; runtime/gameplay
timing и animation library не менялись.

Pack содержит 556 capture files: First Day, Day 2, Quiet, обе стороны, обе
физические смены направления, D/F/G/EXIT mask cells, отрицательные controls,
clean/silhouette и alpha-class audit, declared `216/144/96` resamples,
cancellation/recovery, четыре 1x strip, actual desktop full-display/window
proof и proportional Labrador+van+Kitchen+Packing frame.

Mechanical PASS не является runtime Art PASS. `OWNER_REVIEW.md` остаётся
`PENDING_OWNER_REVIEW` для локального bounded mask result; Codex не выдавал Art
PASS. Прямой owner verdict отдельно фиксирует общую player-facing визуальную
связность как `CHANGES_REQUIRED / USER_OWNER_REJECTED_CURRENT_LOOK`: текущие собаки, расстановка зданий и поляна не
соответствуют ожидаемым зафиксированным артам. v5 не утверждает, что решил эту
общую визуальную проблему. Source/composition correction требует отдельного
Art-owned reconciliation brief после отдельного read-only Art comparison current
v5 versus earlier accepted dog/building/meadow references; v6 из этого pack не
начинается.
