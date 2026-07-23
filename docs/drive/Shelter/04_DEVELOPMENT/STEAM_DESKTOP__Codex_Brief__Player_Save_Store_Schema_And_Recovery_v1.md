# STEAM_DESKTOP — Codex Brief — Player Save Store Schema And Recovery v1

Дата: 2026-07-12

Статус: completed / PASS / integer-only v1 foundation

Роль-владелец постановки: Producer / Game Designer / Project Manager

Roadmap task: R48-02A

Decision: D-023

Рекомендуемый уровень рассуждений Codex: **очень высокий**

---

## 0. Цель

Создать безопасный player-facing persistence store под `user://`, который умеет:

- read-only определить наличие envelope-valid candidates без заявления, что checkpoint уже playable;
- загрузить строгий versioned envelope;
- транзакционно сохранить immutable player checkpoint payload;
- восстановиться из last-known-good backup;
- quarantine повреждённый файл и fail-closed сохранить incompatible файл без silent downgrade;
- не смешивать player state с dev fixtures, `.runtime` или connector snapshots.

Эта волна реализует storage/schema/recovery foundation. Она не подключает autosave к gameplay checkpoints и не реализует Day 2 transition; это R48-02B и R48-03.

---

## 1. Обязательные источники

### Rules / role / current state

```text
PROJECTS_RULES.md
AGENTS.md
README.md
steam/AGENTS.md
steam/README.md
docs/drive/Shelter/00_START_HERE/000_ROLE_CODEX.md
docs/repo/status/CODEX_CURRENT_STATUS.md
docs/drive/Shelter/04_DEVELOPMENT/CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md
```

### Architecture

```text
docs/repo/adr/README.md
docs/repo/adr/0001-use-godot-for-steam-desktop.md
docs/repo/adr/0002-game-state-as-source-of-truth.md
docs/repo/adr/0003-player-profile-persistence-boundary-and-recovery.md
```

Read every other Accepted ADR relevant to save/snapshot/runtime contracts. If a new enduring save rule is needed, stop and prepare the ADR decision path before coding it silently.

### Product/game scope

```text
docs/drive/Shelter/00_START_HERE/02_DECISIONS.md
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Game_Design_Roadmap_v2.md
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Task_Flow_Contract_v1.md
docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Object_Contract_v1.md
```

D-022/D-023 persistence behavior remains the regression baseline; superseded
First 48 Hours planning detail is available through Git history.

### Existing implementation

Inspect current equivalents of:

```text
steam/project.godot
steam/scripts/game_systems/game_systems_runtime.gd
steam/scripts/prototypes/vertical_slice/vertical_slice_demo.gd
steam/resources/game_systems/fixtures/**
steam/.runtime/**                              # history/evidence only; never player source
steam/scripts/dev_tools/**
steam/tools/**
```

---

## 2. Accepted authority boundary

### PlayerProfileStore

The persistence component owns only:

- player file paths under `user://`;
- envelope encode/decode;
- strict schema validation;
- transactional store;
- primary/temporary/backup recovery;
- quarantine and diagnostics;
- `inspect_profile_candidates`, `has_valid_envelope`, `load_profile_candidate`, explicit `recover_profile_candidate`, `store_profile` and bounded profile-management results.

It MUST NOT own:

- `_process` simulation;
- tasks, resources, dogs, orders or journey transitions;
- fixture loading;
- wall-clock day advancement;
- UI state as gameplay truth;
- offline progression.

Vertical Slice runtime remains the only gameplay authority. R48-02B will provide/consume immutable safe-checkpoint payloads.

---

## 3. Player envelope requirements

Define a new player schema; do not rename the current permissive dev/runtime payload into a player save.

Minimum envelope fields:

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
written_at_metadata          # exact diagnostic-only object below
integrity
```

Rules:

- the exact outer allowlist is the field list above; unknown top-level fields are rejected;
- unknown/future required schema is rejected, not silently defaulted;
- missing/invalid required fields are rejected;
- R48-02A strictly validates `PlayerProfileEnvelopeV1`, payload identity and payload container type;
- in this wave payload MUST be a JSON Dictionary, bounded by size/depth/type and recursively rejected when it contains explicitly forbidden dev keys;
- full nested gameplay payload allowlisting is NOT claimed in R48-02A; R48-02B must define `PlayerCheckpointV1` before PlayerBoot may treat an envelope as a playable profile;
- dev-only fields such as fixture id, debug speed, active dev save path, connector/control metadata and capture history are rejected;
- timestamps are diagnostics only and never advance gameplay;
- migration support is explicit; no speculative repair/default merge creates hybrid state.

Exact outer types:

```text
format_id: exact "shelter.player-profile-envelope"
schema_version: exact integer 1
profile_id: exact "default" for single-profile v1
content_build_version: nonempty string, max 256 UTF-8 bytes
journey_phase: nonempty opaque string; semantic enum deferred to R48-02B
checkpoint_kind: nonempty opaque string; semantic enum deferred to R48-02B
checkpoint_sequence: integer in 0..9007199254740991, supplied by runtime
payload_format_id: exact "shelter.player-checkpoint"
payload_schema_version: exact integer 1
payload: bounded JSON Dictionary
written_at_metadata: exact {"source":"system_utc_diagnostic_only","iso8601_utc":<nonempty String, max 64 UTF-8 bytes>}
integrity: exact {"algorithm":"sha256","digest":<64 lowercase hex characters>}
```

The store MUST NOT derive `journey_phase` or `checkpoint_kind` from time, files, UI or payload contents.

The store MUST NOT increment or derive `checkpoint_sequence`. R48-02A validates only its range. R48-02B defines its first accepted value, monotonic/conflict/idempotent-rewrite rules and comparison source together with `PlayerCheckpointV1`.

Envelope/payload bounds for v1:

```text
maximum complete file size: 1,048,576 UTF-8 bytes
maximum recursive JSON depth: 32
maximum total JSON nodes: 50,000
maximum entries in one Dictionary or Array: 4,096
maximum one String/key length: 262,144 UTF-8 bytes
Dictionary keys: String only
numbers: integers only; lexical/range rule below
```

Recursive forbidden dev keys are matched case-sensitively at any payload depth:

```text
active_fixture_id
active_save_file
debug_speed_multiplier
connector
connector_control
state_connector
state_connector_control
connector_token
connector_url
capture
capture_history
capture_dir
runtime_load_fixture
runtime_load_save
runtime_save_path
```

Additionally reject any payload key ending in `_token` or `_url`. This v1 player checkpoint carries neither credentials nor external URLs.

Integrity metadata:

```text
algorithm: sha256
digest: SHA-256 of canonical JSON bytes for the envelope excluding only the top-level integrity field
```

Canonical JSON contract:

- canonicalization is a JCS-compatible integer-only JSON subset, not full RFC 8785/JCS;
- bytes are UTF-8 without BOM or trailing newline;
- the complete saved file is compact canonical JSON with no insignificant whitespace;
- Dictionary keys are sorted recursively by unsigned UTF-16 code units exactly as RFC 8785; Array order is preserved;
- strings use RFC 8785/ECMAScript serialization: control escapes and lowercase `\u` forms are exact, `/` is not escaped, other valid Unicode is emitted as-is, and lone surrogates/invalid Unicode are rejected;
- only JSON null/boolean/string/integer/array/object types are accepted;
- every raw number token MUST be lexical `0` or `-?[1-9][0-9]*` and within `-9007199254740991..9007199254740991`;
- `-0`, `+1`, `01`, `1.0`, fractions, exponent forms, non-finite values and programmatic non-integral Godot values are rejected before normalization;
- canonical integer output is base-10 without leading zeros and zero is only `0`;
- after parse + schema validation + numeric normalization, re-encoding the complete envelope including `integrity` MUST be byte-identical to the stored file;
- the digest input is a second canonical encoding with only the top-level `integrity` field removed.

Godot's permissive JSON parser is not itself the strictness proof. Tests MUST cover RFC 8785 key-order/string examples plus project golden vectors for integer boundaries, `-0`, decimal/exponent/leading-zero rejection, solidus/control escaping, non-BMP property sorting, nested objects/arrays and top-level integrity omission. They MUST also prove lax/trailing-comma/invalid-Unicode rejection and round-trip stability. If the implementation cannot produce and verify this subset deterministically in the accepted scope, stop and return an ADR/brief correction; do not invent another integrity scheme.

R48-02B checkpoint rule:

- any necessary fractional semantic value uses an explicitly named/versioned fixed-point integer with its scale in the contract/field name, for example `*_milliseconds`, `*_millipixels` or basis points;
- a versioned decimal string is allowed only when fixed-point cannot represent the accepted meaning;
- transient in-flight positions/timers are not added to a safe checkpoint merely to preserve float state;
- future native-float support requires a new envelope/payload schema version and ADR update.

---

## 4. Storage paths and isolation

Player persistence MUST use a dedicated `user://` namespace.

Exact v1 paths:

```text
user://player/default/profile.json
user://player/default/profile.tmp
user://player/default/profile.bak
user://player/default/quarantine/
```

It MUST NOT read or write:

```text
res://.runtime/game_systems_runtime/local_save.json
steam/.runtime/**
fixture JSON as player state
connector snapshots/final_state
```

Dev fixture/save/control behavior remains unchanged and separate.

Tests must prove player loading cannot fall back to `.runtime` or fixture paths.

---

## 5. Transaction and recovery contract

Required behavior:

1. Validate the complete outgoing envelope before touching the primary file.
2. Write and flush a temporary candidate in the same player-save namespace.
3. Read/parse/validate the candidate before promotion.
4. Rotate backup only from a fully validated primary; preserve a last-known-good backup according to an OS-validated replace strategy.
5. Promote without a delete-then-write window that destroys both valid copies.
6. Ordinary store refuses to overwrite corrupt or incompatible primary state without explicit recovery/reset authority.
7. On load/inspection apply the deterministic precedence below.
8. Quarantine invalid files only through explicit recovery with bounded, non-secret diagnostics.
9. Never silently return a fresh game while claiming Continue succeeded.

The implementation must prove its replace semantics on the target macOS internal environment. Do not label a sequence atomic merely because it uses rename; document the actual Godot/OS behavior and recovery matrix.

Exact API mutation split:

```text
inspect_profile_candidates()  # read-only validity/source/warnings for primary/backup/temp
has_valid_envelope()          # read-only convenience; never means playable checkpoint
load_profile_candidate(source)# read-only envelope load; no promotion/quarantine/delete
recover_profile_candidate(source, explicit_authority) # explicit promotion/quarantine mutation
store_profile(envelope, explicit_authority)            # explicit transaction mutation
```

Every result exposes separate booleans/statuses for `envelope_valid`, `checkpoint_contract_valid` and `playable_profile`. In R48-02A only `envelope_valid` may be true; the other two are false/not-evaluated until R48-02B. PlayerBoot MUST NOT use `has_valid_envelope()` as Continue readiness.

Deterministic inspection/recovery precedence:

1. Valid primary is selected. Invalid/stale backup or temp is warning-only and never overrides it.
2. Primary absent/corrupt/truncated + valid backup selects backup read-only with `backup_available`; only successful explicit promotion returns `recovered_from_backup`.
3. Future/incompatible primary is preserved and returns terminal `incompatible_primary` plus `backup_available`/`temp_available` metadata. It MUST NOT silently downgrade, overwrite or select temp.
4. Primary absent/corrupt/truncated + backup absent/corrupt/truncated + valid temp selects temp read-only with `temp_available`; only successful explicit promotion returns `recovered_from_temp`.
5. An incompatible backup is preserved and blocks automatic temp selection; explicit later recovery/reset authority is required.
6. No selectable candidates returns explicit `no_valid_profile`/recoverable error, never fresh-game success.
7. Plain inspection/load is read-only. Promotion, quarantine, cleanup or repair occurs only through explicit store/recovery mutation.
8. Quarantine retention is bounded to at most three artifacts per source kind. Diagnostics/quarantine MUST NOT contain connector tokens/URLs or unrelated desktop data.

Transaction preconditions:

- first save with primary/backup absent may promote validated temp to primary;
- when primary is valid, backup may be refreshed only from that validated primary before candidate promotion;
- when primary is absent and backup valid, a new validated candidate may promote to primary while the valid backup remains untouched;
- corrupt or incompatible primary causes ordinary `store_profile` to fail closed; explicit recovery/reset authority is required;
- no transaction step may destroy the last valid primary/backup candidate;
- tests must cover process termination before/after temp flush, primary-to-backup, candidate-to-primary and post-promotion readback.

---

## 6. New Game protection boundary

Accepted product rule:

> New Game never silently overwrites an existing valid profile.

This storage wave must expose safe primitives/results for later UI confirmation, but MUST NOT invent final UI copy/layout.

If the current scope needs deletion/reset for tests, it must use an isolated test namespace and explicit confirmation parameter. No production profile deletion API may be exposed through player startup accidentally.

---

## 7. Explicit out of scope

- wiring gameplay autosave triggers;
- choosing exact safe checkpoints;
- importing/restoring live Vertical Slice state;
- exact in-flight task resume;
- First Day → Day 2 transition;
- offline simulation or elapsed-time logic;
- New Game/Continue final UI;
- multiple profiles or cloud save;
- Steam Cloud;
- save encryption/anti-cheat;
- migration from pre-release dev `.runtime` saves;
- connector/MCP save operations;
- production telemetry.
- autoload registration or PlayerBoot integration; `project.godot` wiring is deferred to R48-02B.

---

## 8. Expected change areas

Exact initial write scope after ADR-0003 acceptance:

```text
steam/scripts/persistence/player_profile_store.gd      # new
steam/scripts/persistence/player_profile_schema.gd     # new
steam/scripts/persistence/*.gd.uid                     # generated sidecars if Godot creates them
steam/tests/persistence/player_profile_store_test_runner.tscn # new
steam/tests/persistence/test_player_profile_store.gd   # new
steam/tests/persistence/*.gd.uid                       # generated sidecars if Godot creates them
steam/tools/test-player-profile-store.sh               # optional thin runner only if needed
steam/README.md
docs/repo/dev/player-profile-persistence.md             # new
docs/repo/status/CODEX_CURRENT_STATUS.md
docs/drive/Shelter/04_DEVELOPMENT/CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md
```

Explicitly excluded:

```text
steam/project.godot
steam/scenes/player/**
steam/scripts/player/**
steam/scripts/prototypes/vertical_slice/vertical_slice_demo.gd
steam/scripts/game_systems/game_systems_runtime.gd
steam/resources/game_systems/fixtures/**
steam/scripts/dev_tools/**
steam/play.sh
steam/dev.sh
steam/launch.sh
steam/.runtime/**
.codex/config.toml
```

R48-02A starts after R48-01A under the same sequential integrator, but owns only the disjoint persistence/test files above plus bounded documentation closeout.

---

## 9. Acceptance criteria

### Schema

- [x] New player envelope has explicit `format_id` and `schema_version`.
- [x] Complete outer allowlist, constants, bounds, denylist and canonical byte contract are enforced.
- [x] All envelope/payload number tokens are safe-range lexical integers; decimal/exponent/non-integral forms are rejected.
- [x] Required envelope fields, payload identity/type, size/depth bounds and forbidden-dev-key recursion are strictly validated.
- [x] Full nested gameplay payload validation is explicitly pending `PlayerCheckpointV1` in R48-02B.
- [x] Unknown/future incompatible schema is rejected.
- [x] Dev fixture/debug/connector/capture fields are rejected.
- [x] Timestamp metadata cannot affect gameplay.

### Isolation

- [x] Player profile lives only under the dedicated `user://` namespace.
- [x] No `.runtime`, fixture or connector snapshot is read as player state.
- [x] Dev save behavior remains separate and unchanged.

### Transaction/recovery

- [x] Valid save survives normal store/load.
- [x] Failed candidate validation preserves last-known-good primary.
- [x] Interrupted/failed promotion has a deterministic recoverable result.
- [x] Corrupt/truncated or absent primary selects a valid backup read-only; explicit promotion alone returns `recovered_from_backup`.
- [x] Future/incompatible primary is preserved and never silently downgraded to backup.
- [x] Temp is selected only in the exact absent/corrupt/truncated primary and backup case; explicit promotion alone returns `recovered_from_temp`.
- [x] Invalid primary plus invalid backup returns an explicit recoverable error, not silent fresh success.
- [x] Quarantine diagnostics contain no tokenized connector URLs or unrelated desktop data.

### Authority

- [x] PlayerProfileStore owns no simulation or journey transition.
- [x] Repeated inspect/load has no file mutation or runtime side effects in this wave.
- [x] Envelope-valid, checkpoint-valid and playable-profile statuses cannot be conflated.
- [x] API is ready for R48-02B immutable checkpoint integration.

---

## 10. Required test matrix

At minimum:

- absent profile;
- valid primary;
- valid primary + stale backup;
- valid primary + invalid backup/temp warnings;
- absent primary + valid backup;
- corrupt/truncated primary + valid backup;
- incompatible/future primary + valid backup;
- incompatible/future primary + valid temp;
- absent/corrupt primary + incompatible backup + valid temp;
- valid temp candidate before promotion;
- corrupt temp candidate;
- invalid primary + invalid backup;
- unknown required field/schema variants;
- unknown top-level fields, bounds, integer boundaries, forbidden numeric spellings and canonical-byte variants;
- dev-only forbidden fields;
- repeated store/load;
- path isolation from `.runtime` and fixtures;
- simulated failure at each transaction phase with exact expected result/source/file outcome;
- real process restart around successful store;
- target macOS replace/recovery smoke.

All persistence tests MUST inject an isolated base directory and fail fast if its globalized path equals or contains the production `user://player/default/` directory. Test cleanup is limited to that injected directory.

Also run:

- relevant Godot parse/headless tests;
- existing runtime/connector regressions proportionate to touched project settings;
- `git diff --check`;
- confirmation that test save artifacts are isolated and untracked.

---

## 11. Stop conditions

Stop before or during coding if:

- accepted safe-checkpoint payload fields are required to finish the storage core but remain undefined;
- implementation must reuse permissive dev schema or `.runtime` path;
- transaction strategy cannot preserve a last-known-good copy on target OS;
- player store needs gameplay `_process` or journey logic;
- exact in-flight resume is introduced;
- wall clock/offline progression appears;
- a migration promise for unknown future saves is required;
- multiple-profile/cloud/Steam scope appears;
- `project.godot` or player boot has unexpected concurrent edits;
- a lasting save architecture rule needs an ADR not yet accepted.

Return the concrete issue; do not repair invalid state through silent defaults.

---

## 12. Documentation/status closeout

After implementation:

- document player profile path, schema, recovery behavior and explicit non-goals;
- update Codex current/detailed status and implementation current context;
- record R48-02A complete but R48-02B/Continue still pending;
- do not claim Day 2 persistence or full playable journey;
- list exact recovery/kill-point checks and target OS evidence.

---

## 13. Preflight outcome and implementation order

Producer and Game Design preflight: PASS.

Technical/Codex preflight: PASS after acceptance of:

```text
docs/repo/adr/0003-player-profile-persistence-boundary-and-recovery.md
```

ADR-0003 is accepted. The payload-validation and deterministic recovery-precedence corrections requested by preflight are incorporated in this brief. No new product/user decision remains. Implementation is queued after R48-01A and may start when:

- one sequential integrator is assigned after R48-01A;
- exact initial write scope above remains uncontested;
- tests use an isolated `user://` namespace and never touch a production profile;
- no unexpected concurrent changes exist in owned files.

---

## 14. Implementation outcome

R48-02A completed / PASS on 2026-07-12.

Implemented:

- strict `PlayerProfileEnvelopeV1` schema and integer-only JCS-compatible canonical byte contract;
- exact production namespace `user://player/default` with canonicalized isolated test namespaces;
- SHA-256 integrity over the envelope without the top-level `integrity` field;
- deterministic primary → backup → temp inspection and explicit recovery authorities;
- preservation of future/incompatible profiles without silent downgrade;
- bounded redacted quarantine diagnostics for corrupt candidates;
- validated temp-write/readback, last-known-good backup and promotion flow;
- full schema/store/recovery matrix, normal process restart and real SIGKILL create/update matrices;
- one exact owned test root per invocation with fail-closed collision handling and cleanup on success, failure, `INT` and `TERM`.

Verified:

- the production profile path remained absent;
- every new test invocation removed its exact owned test root, including hidden failpoint markers;
- shell syntax, dedicated persistence runner, full Godot project checks, whitespace and independent corrective review passed.

R48-02A deliberately does **not** make any envelope playable. `PlayerCheckpointV1`, autosave, Continue/Restart wiring and runtime import/export remain R48-02B. Day 1 → Day 2 persisted transition remains R48-03.
