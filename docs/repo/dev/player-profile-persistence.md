# Player Profile Persistence And First Day Continue

Date: 2026-07-12

Status: R48-02A storage/schema/recovery and R48-02B First Day checkpoint/Continue implemented.

Authority:

- ADR-0002: the running Godot gameplay runtime is the source of truth.
- ADR-0003: player-profile persistence owns file I/O, validation and recovery only.
- D-023: closed-app time never advances gameplay and New Game never silently overwrites a valid profile.

## Responsibility boundary

`ShelterPlayerProfileStore` owns:

- the player-profile file paths;
- strict outer-envelope encoding and validation;
- integer-only subset-canonical JSON and SHA-256 integrity;
- primary, temporary and backup inspection;
- explicit storage and recovery mutations;
- bounded redacted quarantine diagnostics.

It has no `_process` loop and owns no tasks, resources, dogs, orders, journey transitions, UI progression, wall clock or offline simulation.

The store remains a boot-owned `RefCounted` service rather than an autoload.
`PlayerBoot` validates the selected envelope payload independently through
`ShelterPlayerCheckpointCodec` before it instantiates the single Vertical Slice
runtime. Envelope validity alone never makes a profile playable.

## Production paths

Single-profile v1 uses only:

```text
user://player/default/profile.json
user://player/default/profile.tmp
user://player/default/profile.bak
user://player/default/quarantine/
```

The store never reads or writes dev fixtures, `res://.runtime`, `steam/.runtime`, connector snapshots or capture bundles. Pre-release dev saves are not migrated.

Tests inject paths under:

```text
user://player-tests/<run-id>/
```

Test mode fails before filesystem inspection unless its simplified/globalized path is a strict descendant of the test root and does not overlap production. The shell runner first proves that its exact `user://player-tests/<run-id>/` root is absent, then claims only that fresh root. Normal completion removes the complete root (including hidden reach markers) and proves it absent in a fresh process; an EXIT/INT/TERM trap performs the same bounded cleanup after failure or interruption. An existing caller-selected run-id root is rejected and never deleted. Historical sibling runs and arbitrary user data are outside cleanup scope.

## PlayerProfileEnvelopeV1

The exact top-level allowlist is:

```text
format_id
schema_version
content_build_version
profile_id
journey_phase
checkpoint_kind
checkpoint_sequence
payload_format_id
payload_schema_version
payload
written_at_metadata
integrity
```

Exact identities:

```text
format_id = shelter.player-profile-envelope
schema_version = 1
profile_id = default
payload_format_id = shelter.player-checkpoint
payload_schema_version = 1
```

`journey_phase` and `checkpoint_kind` are nonempty opaque strings in this wave. The store never derives them. `checkpoint_sequence` is a caller-supplied integer in `0..9007199254740991`; the store neither increments nor compares it.

`written_at_metadata` is exactly:

```json
{"iso8601_utc":"<diagnostic string>","source":"system_utc_diagnostic_only"}
```

It is diagnostic only and never drives gameplay.

The storage API keeps these claims separate:

```text
envelope_valid
checkpoint_contract_valid = false   # storage does not interpret gameplay
playable_profile = false             # PlayerBoot + codec decide this
```

## Canonical JSON and integrity

V1 uses the ADR-0003 JCS-compatible integer-only JSON subset, not full RFC 8785 float support:

- UTF-8, no BOM and no trailing newline;
- object keys sorted recursively by unsigned UTF-16 code units;
- RFC 8785 / ECMAScript string escaping;
- array order preserved;
- only null, booleans, strings, integers, arrays and objects;
- integer tokens only: `0` or `-?[1-9][0-9]*`;
- safe range: `-9007199254740991..9007199254740991`;
- `-0`, fractions, decimals, exponent forms, plus signs, leading zeros and Godot floats are rejected;
- unknown fields, duplicate/noncanonical documents, whitespace variants and trailing commas fail closed.

The stored file is the compact canonical document. Integrity is:

```text
algorithm = sha256
digest = SHA-256(canonical envelope with only top-level integrity removed)
```

The parser must reproduce byte-identical canonical output before integrity can pass. Godot `JSON.stringify()` is not used as a JCS claim.

Any future fractional checkpoint value must use a versioned fixed-point integer/scale or a separately accepted versioned decimal-string field. Native float persistence requires a new schema version and ADR update.

V1 bounds:

```text
complete file: <= 1,048,576 bytes
recursive depth: <= 32
total nodes: <= 50,000
entries per object/array: <= 4,096
one string/key: <= 262,144 UTF-8 bytes
```

Payload keys are recursively denied for fixtures, dev saves, debug speed, connector/control, captures, tokens and URLs. Any key ending `_token` or `_url` is rejected.

## Read-only inspection precedence

`inspect_profile_candidates()`, `has_valid_envelope()` and `load_profile_candidate()` do not write, promote, delete or quarantine files.

Selection order:

1. Valid primary -> `primary_available`.
2. Absent/corrupt primary plus valid backup -> `backup_available`.
3. Incompatible primary -> terminal `incompatible_primary`; backup/temp availability may be reported but never selected.
4. Absent/corrupt primary and absent/corrupt backup plus valid temp -> `temp_available`.
5. Incompatible backup blocks temp -> `incompatible_backup`.
6. Otherwise -> `no_valid_profile`.

`has_valid_envelope()` means only that the read-only precedence selected an envelope-valid candidate. It never means Continue is ready.

## Explicit mutations

Storage authorities:

```text
create_profile
update_profile
```

Recovery authority:

```text
recover_profile
```

New profile creation refuses to overwrite any valid primary or recoverable/incompatible temp. Updating refuses corrupt/incompatible primary state. Recovery is explicit and only accepts the currently selected backup/temp candidate.

Store transaction:

1. validate and seal the outgoing envelope;
2. write/flush/read back/fully validate `profile.tmp`;
3. when primary is valid, rewrite and validate `profile.bak` from that primary while primary remains intact;
4. only after a validated backup exists, remove the old primary and rename the validated temp;
5. validate the promoted primary.

This sequence is not described as universally atomic. Its demonstrated safety property on the tested macOS environment is that each injected failure leaves the previous valid primary/backup or a fully validated temp candidate available. Separate Godot processes are forcibly terminated at every create/update boundary (before validation; after temp write, flush and readback; after backup write; after primary removal; after promotion), then a fresh process checks the exact flushed reach marker and loads the deterministic surviving candidate. The harness requires SIGKILL status 137 and rejects script/parse/runtime errors, so an earlier crash cannot satisfy a named kill point. A normal real-process write/read restart is also covered.

Explicit recovery writes only redacted quarantine diagnostics containing source, classification, bounded error category, byte count and SHA-256. Error categories never reflect raw keys or number tokens. Raw invalid bytes, connector tokens and URLs are not copied into quarantine. Retention is at most three diagnostics per source kind.

## Validation command

From the repository root:

```sh
steam/tools/test-player-profile-store.sh
```

The runner performs:

- schema/canonical byte golden vectors;
- integer and parser-boundary negative vectors;
- primary/backup/temp precedence;
- corrupt and incompatible cases;
- explicit backup/temp recovery;
- transaction and quarantine failpoints;
- last-known-good preservation checks;
- repeated read-only inspection/load checks;
- bounded quarantine checks;
- a separate-process write/read restart check;
- forced process-termination/restart matrices across first-save and update transaction boundaries.

The command uses one isolated `user://player-tests/<run-id>/` namespace and removes that exact owned root on success or through its failure/interruption trap. It does not touch historical sibling runs or `user://player/default/`.

## PlayerCheckpointV1

The nested payload exact top-level allowlist is:

```text
format_id
schema_version
journey
first_day_history
active_order
active_chain
day2
resources
world
```

The codec accepts only the exact normative First Day graph below. Every row has
one exact order/history/chain/resource/world/history template; a nearest-state
repair, missing prefix or arbitrary combination fails closed.

| Seq | Cursor | Resume behavior |
| ---: | --- | --- |
| 1 | `first_day_offered` | wait for trip confirmation |
| 2 | `first_day_route_confirmed` | replay TripTask |
| 3 | `first_day_payload_returned` | replay Oat then Pumpkin unload |
| 4 | `first_day_oat_stored` | replay Pumpkin unload |
| 5 | `first_day_resources_available` | replay Oat/Pumpkin/Protein carries |
| 6 | `first_day_oat_in_kitchen` | replay Pumpkin/Protein carries |
| 7 | `first_day_pumpkin_in_kitchen` | replay Protein carry |
| 8 | `first_day_inputs_in_kitchen` | replay CookTask |
| 9 | `first_day_food_mix_ready` | replay Food Mix/Packaging carries |
| 10 | `first_day_food_mix_at_packing` | replay Packaging carry |
| 11 | `first_day_inputs_at_packing` | replay PackTask |
| 12 | `first_day_food_bag_ready` | replay LoadVanTask |
| 13 | `first_day_ready_to_dispatch` | wait for dispatch confirmation |
| 14 | `first_day_dispatch_confirmed` | replay DeliveryTask |
| 15 | `first_day_delivery_response` | wait for slippers equip |
| 16 | `first_day_equip_confirmed` | replay EquipItemTask |
| 17 | `first_day_complete` | calm First Day complete hold |

The ordinal is the checkpoint sequence. Imported envelope mirror fields must
match `journey.phase`, cursor and sequence exactly. Every payload number is an
ADR-0003 safe-range integer; task queues/steps, timers, positions, events,
fixtures, dev saves and connector/capture fields are recursively forbidden.

Fresh semantic inventory is `Protein Packet x2` and `Packaging Bag x2`. The
exact resource templates prove visible Oat/Pumpkin cargo and movement, consume
one Protein/Packaging unit, and preserve the remaining `x1/x1`. Food Mix and
Food Bag exist only between their accepted production/movement boundaries.

## Runtime commit and replay

The Vertical Slice runtime remains the only gameplay authority. After each
complete semantic transaction it builds and validates the next checkpoint, then
calls a synchronous boot-owned commit sink. The scheduler, next gate and success
presentation do not advance until storage acknowledges the checkpoint.

On failure the runtime returns to the previous committed semantic scene, keeps
the candidate staged and exposes one explicit Retry action. Successful retry of
the same sequence/payload commits it once. There is no per-frame, focus or
wall-clock retry.

Continue imports into one clean runtime before `_ready`, materializes semantic
state without historical gameplay events and reconstructs only the ordered
pending intents for that cursor. No task step, timer or coordinate is imported.
Export always returns the last durable checkpoint, even while its replayed task
is currently running.

## PlayerBoot lifecycle

- no candidates: start one fresh runtime; trip action stays blocked until cursor 1 persists;
- valid incomplete primary: show `Продолжить`, with no gameplay ticking behind it;
- valid complete primary: show `Вернуться в кооператив` and restore First Day complete hold;
- selected backup/temp: show `Восстановить и продолжить`, mutate only after the action, then re-inspect/revalidate;
- invalid checkpoint: `Не удалось безопасно открыть сохранение. Оно осталось без изменений.`;
- future profile: `Эта версия игры не может безопасно открыть сохранение. Оно осталось без изменений.`;
- failed store: `Не удалось сохранить. Мир остановлен на безопасном месте.` plus `Повторить сохранение`.

No destructive New Game path is exposed in this wave. Player CLI arguments
cannot select fixtures, test roots or persistence failpoints.

The automated launch-surface regression injects its isolated store before
PlayerBoot `_ready` and removes only that exact test root. `check-godot.sh`
delegates its player-main regression to this test instead of launching the
ordinary main scene against `user://player/default`. Native `play.sh`/F5 proof
may create only one explicitly declared manual internal profile, which is read
back and removed by its owner after evidence collection.

## R48-02B validation

From the repository root:

```sh
steam/tools/test-player-checkpoints.sh
steam/tools/test-player-continue.sh
```

The first command validates all seventeen golden cursors, strict negative
vectors, natural runtime traversal, immediate import/export identity, pending
intent reconstruction and failed-ACK rollback/retry. The second uses isolated
`user://player-tests/<run-id>/` profiles and fresh Godot processes for every
cursor, backup/temp recovery, invalid/future startup, explicit save retry and
forced termination during every automatic task family. Its trap deletes only
the exact owned test root.

## Still deferred

- organic fully-complete First Day -> Day 2 transition (R48-03);
- Day 2 checkpoints and restart-stable Quiet Cooperative;
- destructive New Game confirmation/reset UI;
- exact in-flight task/timer/position resume;
- offline/calendar progression;
- multiple profiles, Steam Cloud, encryption or anti-cheat.
