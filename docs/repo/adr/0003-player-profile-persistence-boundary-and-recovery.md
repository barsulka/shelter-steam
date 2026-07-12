# ADR 0003: Player Profile Persistence Boundary And Recovery

Date: 2026-07-12

Status: Accepted

Amended: 2026-07-12 — v1 canonical JSON numbers restricted to safe-range integers after Godot 4.7 float/JCS feasibility proof.

Related product decision: D-023 — First 48 Hours Playable Scope Lock.

Related implementation brief: `docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Player_Save_Store_Schema_And_Recovery_v1.md`.

## Context

Shelter Steam/Desktop needs an ordinary player-facing Continue flow for the accepted First Day + Day 2 journey. The current repository also contains developer fixtures, connector snapshots and a permissive runtime save under `res://.runtime`; those artifacts are useful for tests and inspection but are not a safe player profile contract.

The game must remain calm and causally honest. Closing the app must not simulate elapsed time, create resources, complete work, apply penalties or silently advance the narrative day. A damaged or newer profile must not be repaired through guessed defaults or presented as a successful fresh start.

ADR 0002 already establishes the running simulation as the source of truth and saves as derived views. This ADR defines the durable persistence boundary, versioning and recovery policy needed to apply that rule to player profiles.

## Decision

### 1. Authority boundary

The running Godot gameplay runtime remains the sole gameplay authority.

`PlayerProfileStore` owns only:

- player-profile file paths;
- envelope encoding and decoding;
- schema, bounds and integrity validation;
- transactional storage;
- primary, temporary and backup inspection/recovery;
- bounded quarantine and non-secret diagnostics.

It does not own simulation, tasks, resources, dogs, orders, journey transitions, UI progression, wall-clock advancement or offline progression. It has no gameplay `_process` loop.

PlayerBoot and gameplay code may consume a profile only through a separately accepted checkpoint contract. The store never infers gameplay meaning from timestamps, filenames, UI state or partial payload contents.

### 2. Player and developer state are separate namespaces

Player profiles use a dedicated `user://player/` namespace. The v1 single-profile paths are:

```text
user://player/default/profile.json
user://player/default/profile.tmp
user://player/default/profile.bak
user://player/default/quarantine/
```

Player persistence never reads or writes developer fixtures, `res://.runtime`, `steam/.runtime`, connector snapshots or capture output. Developer save/fixture/control surfaces never become fallback player profiles. No migration from pre-release developer saves is implied.

### 3. Two independently versioned contracts

The stored document has two explicit identities:

1. a strictly validated outer `PlayerProfileEnvelopeV1`;
2. a separately identified and versioned gameplay checkpoint payload.

The envelope records at least its format/schema version, build/content version, profile id, journey/checkpoint descriptors, a runtime-supplied checkpoint sequence, payload format/schema version, payload, diagnostic write metadata and integrity metadata. The store never increments or derives the sequence; R48-02B defines monotonic/idempotency semantics when `PlayerCheckpointV1` is accepted.

The envelope and payload versions are not interchangeable. A storage implementation may validate the outer envelope before the complete gameplay checkpoint schema exists, but PlayerBoot must not treat that envelope as playable until the nested checkpoint contract is accepted and fully validated.

Unknown or future incompatible envelope versions are rejected explicitly. Migrations are explicit version-to-version operations. Missing fields, permissive default merging and speculative repair must not create a hybrid profile.

### 4. Safe checkpoints, not exact in-flight resume

Player persistence stores immutable snapshots emitted by the gameplay runtime only at accepted safe checkpoints.

The first playable persistence contract does not promise exact in-flight task resume. Closing or crashing during ongoing automatic work may restore the most recent safe checkpoint and replay a bounded piece of already-visible automatic work, provided the later checkpoint contract proves that no irreversible effect is duplicated, skipped or completed while the app was closed.

Elapsed closed-app time is not simulation input. Timestamps are diagnostic metadata only. There is no offline catch-up, resource production, reward, decay, penalty, absence event or calendar-day advancement.

### 5. Integrity and complete validation before promotion

An outgoing profile is fully validated before the primary file is touched. The v1 envelope uses SHA-256 over canonical JSON bytes for the envelope with only the top-level `integrity` field omitted.

Canonical bytes use a JCS-compatible integer-only JSON subset. Output is UTF-8 without BOM or trailing newline; objects sort raw property names recursively by unsigned UTF-16 code units and strings/literals use the exact [RFC 8785](https://www.rfc-editor.org/rfc/rfc8785.html) escaping rules; arrays preserve order. Numbers at every envelope/payload depth are restricted to lexical JSON integer `0` or `-?[1-9][0-9]*` in the exactly representable range `[-9007199254740991, 9007199254740991]`. `-0`, plus signs, leading zeros, fractions, decimal points, exponent forms, non-finite values and programmatic non-integral Godot values are rejected before normalization. Canonical output is base-10 without leading zeros and zero is only `0`.

This v1 format is not described as full RFC 8785/JCS because it intentionally excludes native JSON floating-point numbers. The complete stored file must round-trip to exactly the same subset-canonical bytes after strict schema validation, so lax parser acceptance, alternate numeric spelling, whitespace and trailing commas cannot pass validation. R48-02B represents any required fractional value as an explicitly named/versioned fixed-point integer (preferred) or a versioned decimal string when fixed-point cannot apply. Transient in-flight positions/timers are not persisted merely to preserve floats. Future native-float support requires a new schema version and ADR update.

Integrity metadata is exactly `algorithm = "sha256"` plus a 64-character lowercase hexadecimal digest. Bare `JSON.parse()` or `JSON.stringify()` is not sufficient evidence of strict validation; the implementation must prove the canonicalizer/parser boundary with deterministic tests.

Storage writes a temporary candidate in the same profile namespace, flushes it, reads it back, and validates its syntax, schema, bounds and integrity before promotion. The promotion strategy must preserve at least one previously valid primary or backup across every demonstrated failure point on the target operating system.

An implementation must not call a sequence atomic merely because it uses rename. The exact Godot/OS behavior and kill-point recovery matrix must be tested and documented.

### 6. Deterministic inspection and recovery

Inspection is read-only. `has_valid_envelope` and ordinary load/inspection do not promote, delete, quarantine or rewrite files; envelope validity never implies a playable checkpoint.

Read-only inspection returns candidate validity/source information and never claims that an envelope is a playable checkpoint. Loading a selected candidate is also read-only. Promotion, quarantine, deletion and repair are separate explicit mutation operations.

Recovery precedence is:

1. A valid primary is selected. Backup/temp validity may be reported as warnings, but neither overrides it.
2. If primary is absent, corrupt or truncated and backup is valid, backup is selected read-only as `backup_available`; only an explicit mutation may return `recovered_from_backup` after promotion succeeds.
3. A future or incompatible primary is terminal for automatic selection: it is preserved and yields `incompatible_primary`, plus backup/temp availability when applicable. It is never silently downgraded, overwritten or bypassed by temp.
4. If primary is absent/corrupt/truncated and backup is absent/corrupt/truncated, a fully valid temp may be selected read-only as `temp_available`; only an explicit mutation may return `recovered_from_temp` after promotion succeeds. An incompatible backup is preserved and blocks automatic temp selection.
5. If no selectable candidate exists, the result is explicit `no_valid_profile` or another bounded recoverable error. It is never reported as successful Continue or silent fresh-game success.

Ordinary `store_profile` rotates backup only from a fully valid primary and refuses to overwrite corrupt or incompatible primary state without an explicit recovery/reset authority. First-save, primary-to-backup and temp-to-primary failure points must each preserve a deterministic inspectable result and at least one previously valid copy. Promotion, quarantine and repair require explicit store/recovery operations. Quarantine retains at most three artifacts per source kind and contains no connector tokens, tokenized URLs or unrelated desktop data.

### 7. New Game protection

New Game never silently overwrites a valid player profile. The persistence layer may expose bounded status/results needed by a later confirmation UI, but this ADR does not choose that UI.

Tests use an isolated `user://` namespace and must never delete, overwrite or inspect the production-profile path as part of routine execution.

## Consequences

- The existing developer runtime save remains a dev-only surface and cannot be reused as the player profile schema.
- Player profile storage can be implemented and tested before gameplay autosave/import integration, while still failing closed on nested payload claims.
- R48-02B must define the exact `PlayerCheckpointV1`, accepted safe checkpoint set, import/export semantics and idempotency proofs before Continue becomes playable.
- R48-03 must implement the First Day → Day 2 transition inside the gameplay runtime, not inside persistence, and persist it immediately as an idempotent safe checkpoint.
- Save corruption and incompatible future versions remain visible, recoverable states rather than hidden resets.
- Closed-app behavior remains frozen and independent of wall clock, timezone and elapsed time.
- Cloud save, multiple profiles, Steam Cloud, encryption, anti-cheat and exact in-flight resume require separate decisions and briefs.

## Required validation

Any implementation governed by this ADR must demonstrate:

- strict envelope, bounds, forbidden-field and integrity validation;
- isolation from fixtures, `.runtime` and connector/capture artifacts;
- deterministic results for valid, absent, corrupt, truncated, incompatible, backup and temporary candidates;
- failure injection across validation, write, flush, readback, backup, promotion and quarantine phases;
- preservation of at least one previously valid copy at every demonstrated failure point;
- process-restart and target-macOS recovery evidence;
- no gameplay side effects during repeated inspection/load;
- no silent fresh-game fallback, offline advancement or New Game overwrite.

## Rejected alternatives

### Reuse the permissive developer save

Rejected because it mixes fixtures, debug fields and `res://.runtime` concerns with player behavior and allows permissive normalization that can create hybrid state.

### Save UI or connector snapshots as gameplay truth

Rejected by ADR 0002. Those surfaces are views and evidence, not independent simulations.

### Exact in-flight resume in the first player-save wave

Rejected for the First 48 Hours scope because current task-side-effect idempotency is not yet proven at every intermediate instruction boundary.

### Wall-clock or offline catch-up

Rejected by D-023. Closed-app time does not advance the game.

### Silent downgrade, repair or fresh-start fallback

Rejected because it can erase or misrepresent player progress and makes recovery behavior unauditable.
