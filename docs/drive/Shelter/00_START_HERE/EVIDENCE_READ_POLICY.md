# EVIDENCE_READ_POLICY — retained exact evidence only

Обновлено: 2026-07-21
Статус: active documentation governance
Владелец: Project Manager / Knowledge Base Maintainer
Назначение: ограничить evidence в checkout только действующими exact consumers.

---

## Main rule

Evidence/history не читается на bootstrap и обычно живёт только в Git history.
В checkout остаётся evidence, если удаление/изменение ломает exact validator,
hash ledger, sealed pack, runtime reference или реально используемый regression
route.

## Retained exact classes

1. D-024 immutable brief Contract A and sealed runtime pack.
   - consumers: `steam/tools/validate-d024-responsive-presentation.py`,
     `steam/tools/capture-d024-responsive-presentation.sh`, runtime config;
   - Contract A: `4f956a077d0a93575ef7b518fd0aa9fb409392a08fd4a48190364795bc9b5cbf`;
   - sealed brief SHA: `cc6d7fa778b85eebd6d6307dba33efa52518aa62911287dd15ee0d9c7dd5c669`;
   - sealed ledger: 2066 entries, verified 2026-07-21.
2. Labrador/R48 source reconciliation Markdown and manifests pinned by
   `validate-labrador-r48-05a.py`, runtime JSON or package `HASHES.sha256`.
3. Responsive meadow source/acceptance Markdown pinned by D-024 validator and
   package ledger.
4. Accepted ADR under `docs/repo/adr/`.
5. Evidence/readme paths still directly consumed by current runtime/regression
   scripts or immutable manifests.
6. Fixed source routes required by current MCP parser until a separate MCP
   code-migration wave.
7. `STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v3` README/manifest only: current
   `TestSupersededAndGCProjectionsReadCurrentMap` requires the exact v1→v3
   supersession projection. This is regression compatibility, not current Art
   evidence; v1/v2 Markdown is removed.
8. `STEAM_DESKTOP__Codex_Brief__Player_Save_Store_Schema_And_Recovery_v1.md`:
   retained as the normative save/recovery regression contract directly linked
   from Accepted ADR-0003; its mutable product routing now points to D-031/current
   roadmap rather than deleted First 48 Hours plans.

Do not edit retained bytes for clarity. Put current interpretation in current
docs.

## Immutable inbound-reference exceptions

No redirect stubs are kept for deleted history. Some retained exact bytes still
name deleted paths, and those references must not be rewritten:

- the hash-manifested Playable World brief names prior First 48 Hours, Vertical
  Slice and World/Room planning docs;
- D-024 sealed readback and responsive amendment activation record contain
  historical First 48 Hours path/hash observations;
- the hash-pinned accepted Art integration brief and package readback name the
  completed Art-source PM activation record;
- the manifest-hashed Approved Library names the completed generated-originals
  promotion record;
- the MCP regression test uses the absent v1 visible-review path as lookup input
  and requires the retained v3 README/manifest as its current projection.

The deleted targets are recovered from Git. Their names inside immutable evidence
do not make them current routes and do not justify stubs.

Any retained instruction to read, write or update `CODEX_STATUS.md` inside an
Accepted ADR or hash-pinned historical brief/evidence is immutable chronology,
not an actionable route. Current actors use `CODEX_CURRENT_STATUS.md`; the stub
accepts no new entries.

## Current interpretation

D-024/R48 evidence proves historical mechanical/provenance facts. It does not
grant current Art/user acceptance and does not override Visual Shell Lock.
`PENDING`, `HOLD` and `UNSEALED` inside the retained D-024 brief, ADR or activation
record describe pre-seal chronology; current D-024 truth is the sealed pre-D-030
technical-mechanical pack and the post-D-030 user-owned visual route.

## Reading

Open retained evidence only for exact validation, regression, provenance,
audit or archaeology. Use current-context for project direction.
