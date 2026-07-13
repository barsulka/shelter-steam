# R48-05A Runtime Art Owner Review

Статус: **CHANGES_REQUIRED**

Codex self-approved runtime Art PASS: **нет**

## Решение владельца Art

- Reviewer: delegated Art Director / runtime Art owner reviewer
- Reviewed at: `2026-07-13T11:55:56Z`
- Verdict: **CHANGES_REQUIRED**
- Scope: bounded R48-05A, только runtime-result для принятого Labrador/world source package; это не source-production review и не расширение в 05B.

Механическая активация A–G, cancellation/recovery и `legacy_unbound` может оставаться Technical PASS, но фактический player-layout не проходит runtime Art gates. Главные причины: Labrador отрисован слишком мелко для identity/action reading, authored strip преждевременно заканчивается примерно на середине окна, а start/walk/stop/contact/work/focus не образуют достаточно ясную фразу на обычной скорости.

Это **не отменяет SOURCE-READY** для `STEAM_DESKTOP__Playable_World_Labrador_Source_Package_v1/`. Contract/source failure не найден; исправление нужно в integration/camera/scale/composition/animation presentation. Runtime Art PASS не заявлен.

## Прочитанное evidence

Проверены actual full player-layout captures, а не только normalized previews:

- First Day: `A`, `B`, Cook и Pack `C_start/C_walk/C_stop`, `D`, `E`, `F`, `EXIT`, все три `legacy_unbound` negative contexts;
- Day 2: `A`, `B`, Cook и Pack `C_start/C_walk/C_stop`, `D`, `E`, `G`, `EXIT` и negative contexts;
- Quiet Cooperative;
- все 12 synthetic-side captures: Kitchen/Packing, from-left/from-right, `C/D/E/F`;
- все 6 cancellation/recovery captures;
- все `216/144/96` previews, representative clean/silhouette comparisons и все 28 normal-speed motion frames;
- source `labrador_pipeline_qa_sheet`, facing/physical-turn evidence и station anchor/clearance contracts.

## Количественный readback

- Full layout: `1120 x 224`.
- Верхние `160 px` имеют нулевую alpha occupancy. Это корректный transparent desktop reserve по D-011, а не самостоятельный дефект.
- Основной world content в representative full-layout frames занимает приблизительно `x=2..603`, `y=165..213`. Справа остаётся около `46%` ширины без strip content; кроме dev UI toggle там видна прозрачность.
- Изменяемая Labrador-область в normal-speed frames имеет высоту около `22 px`. После нормализации это примерно `21 / 14 / 9 px` для `216 / 144 / 96`, поэтому морфология, лапы, взгляд и характер действия не могут быть надёжно прочитаны.
- Существующие `captures/previews/{216,144,96}` по README являются resample фактического layout, а не тремя независимыми native player runs. Они честно демонстрируют failure, но не могут сами закрыть новый native-scale PASS.
- В Cook motion-sequences значимая root-трансляция сосредоточена преимущественно в последних двух из семи samples; ранние samples отличаются только малой локальной деформацией. Координатный path непрерывен технически, но визуально воспринимается как hold с поздним рывком.

## Exact Art gates

| Gate | Verdict | Readback |
| --- | --- | --- |
| 1. Labrador identity / silhouette / current scale | **FAIL** | Source identity сохранена по форме и цвету, но runtime scale `0.25` сводит subject примерно к 22 px по высоте. Labrador уже не читается как принятая крупная, спокойная и крепкая собака; асимметрия теряется на 144/96. |
| 2. Idle/wait/turn/start/walk/stop/contact/Kitchen/Packing/focus | **FAIL** | Idle/wait ещё распознаются как наличие собаки, но start/walk/stop слишком близки, physical-turn midpoint слишком мал, а `D/E/F/G` визуально определяются скорее временными прямоугольниками, чем позой и контактом Labrador. `G` недостаточно отличается от Packing work. На обычной скорости фраза в `0.324 s` не читается уверенно. |
| 3. Right → midpoint → left continuity | **WARN / RE-REVIEW REQUIRED** | Отдельный physical-turn source присутствует, обе стороны и оба направления представлены, negative-scale shortcut не обнаружен. Technical root continuity проходит. При текущем масштабе Art continuity и сохранение асимметрии глазами подтвердить нельзя. |
| 4. World coverage / seam / front fence / z | **FAIL по coverage; WARN по z** | Внутри видимой authored части нет очевидного разрыва ground seam. Верхняя прозрачность корректна. Но strip заканчивается около `x=603` в окне шириной 1120. Front/back fence и station z не дают явного catastrophic clipping в stills, однако мелкий Labrador не позволяет дать финальный occlusion PASS. |
| 5. Station contact with temporary anchors | **FAIL визуального gate; numeric binding остаётся Technical PASS** | Accepted anchor planes могут оставаться numeric binding/clearance. Но при текущем масштабе muzzle/paw contact и weight не читаются; временные Kitchen/Packing rectangles местами перекрывают или визуально доминируют над собакой. Synthetic sides доказывают наличие обеих веток, но не убедительный contact. |
| 6. No false transfer claim | **PASS** | `UnloadTask`, `CarryTask`, `LoadVanTask` остаются явно `legacy_unbound`; в pack нет pickup/attach/carry/place/detach acceptance и нет ложного authored transfer claim. |
| 7. User-visible rectangle-prototype problem | **NOT RESOLVED for runtime Art PASS** | Authored ground/fence strip является реальным улучшением и не считается rectangle prototype. Но его runtime coverage слишком мала, а station-work по-прежнему читается как временная прямоугольная композиция. R48-05A не обещает authored station replacement, поэтому это не source-contract breach, но executable result пока нельзя предъявлять как решивший видимую prototype-проблему целиком. |

## Failure classification

### Contract / source

**PASS / no new source failure.** Layered Labrador left/right/physical-turn sources, morphology, pivots, asymmetry policy, authored world strip и station anchor planes достаточны для bounded 05A. Source package остаётся **SOURCE-READY**. Temporary Packing Table и Kitchen остаются semantic placeholder/reference only; это по-прежнему не station Art PASS.

### Implementation / camera / scale / composition / animation

**CHANGES_REQUIRED.** Нужны bounded corrections в существующей integration wave:

1. camera/world registration и горизонтальное coverage;
2. единый положительный Labrador scale и повторная anchor/occlusion проверка;
3. распределение pose/root motion внутри принятой `0.324 s` presentation phrase;
4. более ясный pose/contact/focus read без изменения mechanics или task outputs;
5. новый actual-layout evidence pack для owner re-review.

## Минимальные bounded corrections

1. **Camera/world coverage.** Показать текущий runtime corridor `x=0..1740` на полной ширине player capture. Authored `x=0..1536` плюс уже разрешённый, честно не-authored tail `x=1536..1740` должны доходить до правого края без прозрачного провала. Не растягивать source art неравномерно и не объявлять tail authored.
2. **Labrador scale.** Заменить trial scale `0.25` на единый положительный scale `1.0` как первый bounded integration value; сохранять общий root, baseline и отдельные left/right/turn-mid sources. Acceptance по фактическому layout: видимая subject-height не меньше `80 / 52 / 35 px` на `216 / 144 / 96`, без crop и без negative scale. Если `1.0` конфликтует с clearance, разрешена только bounded настройка `0.90..1.00` при сохранении этих пиксельных порогов.
3. **Start/walk/stop phrase.** Не менять gameplay duration/output. Распределить root travel и weight shift по phrase так, чтобы движение было видно минимум в пяти последовательных samples, а один interval не переносил более `35%` полного path. Start должен иметь отдельный anticipation/weight cue, walk — минимум две различимые опорные конфигурации лап, stop — отдельный settle с точным landing на anchor.
4. **Physical turn.** Оставить root locked и использовать authored `right → turn_mid → left` и обратную последовательность. На normal speed midpoint должен быть различим без знания selector label; никаких mirror/negative-scale shortcuts.
5. **Contact/work/focus.** Сохранить temporary station art и принятые numeric anchors, но подогнать runtime registration/occlusion: muzzle/paw cue достигает declared contact plane; station front lip перекрывает только допустимые lower-limb tips; torso/head Labrador не скрыты прямоугольником. Kitchen `E`, Packing `F` и focus `G` должны различаться позой на обычной скорости. Никакого object transfer.

Эти исправления допустимы по тому же accepted brief и **не требуют новой Art source wave**. Новый Art source нужен только если отдельно потребуется authored Kitchen/Packing replacement; это не условие bounded 05A и не разрешено данным review.

## Acceptance evidence для повторного owner review

Минимальный новый pack после corrections:

1. actual full player-layout First Day `A/B/C_start/C_walk/C_stop/D/E/F`, Day 2 `G` и Quiet;
2. обе стороны Kitchen/Packing и оба physical-turn направления в clean + black-silhouette вариантах;
3. четыре 1x normal-speed motion strips/recordings с равномерными timestamp samples и полным player context;
4. фактические native-height `216/144/96` captures без zoom/crop; если pipeline оставляет только resample, это должно быть явно названо и дополнено pixel readback фактического subject-height;
5. contact close read в полном layout для Kitchen `E`, Packing `F`, focus `G`, cancellation-before-contact и recovered `A/F`;
6. один actual desktop-composited frame, подтверждающий, что empty top действительно прозрачен, а world strip непрерывно занимает предназначенную ширину;
7. неизменный `legacy_unbound` negative evidence и `transfer_acceptance_cells=0`.

## Open gates и следующий owner

- Runtime Art approval: **OPEN / CHANGES_REQUIRED**.
- SOURCE-READY Labrador/world package: **не ослаблен**.
- Runtime station Art PASS: **не заявлен**.
- Transfer / 05B: **out of scope**.
- Следующий owner: Technical/Codex integration owner в пределах существующего accepted R48-05A brief; после нового evidence — повторный Art owner review.
