# D-024 Responsive Presentation Runtime Evidence v1

Status: `MECHANICAL_PASS_CANDIDATE / UNSEALED / NATIVE_GATE_BLOCKED_PRE_GODOT`.

This directory contains the completed non-GUI mechanical evidence for D-024.
It is intentionally **not** an immutable/final runtime capture pack and has no
`HASHES.sha256` seal.

## Mechanical result

- accepted source package: `51` files, ledger `50/50`, QA `48/48`;
- runtime corpus: exact `43 PNG + 43 .import`;
- both new PNGs are byte-identical to their accepted source exports;
- all previous `41` import sidecars are unchanged;
- D-024 validator: PASS;
- 2992/3456/3840 default/right framing, 3840 vertical-fit cap, marker,
  pan threshold, exterior and presentation cleanup contracts: PASS through the
  dedicated runtime test and JSON readbacks;
- A–H/12-row regression: PASS;
- profile full/restart and killed create/update matrices: PASS;
- checkpoint, Day 2, 33-cursor restart/advance, forced-kill,
  failed-barrier/retry and launch-surface regressions: PASS;
- shelter-dog-animation-pipeline manifest/runtime validators: PASS, mechanical
  only; visual approval was not evaluated.

The Godot test harness ran with an isolated temporary `HOME`; no production
player profile was mutated. The Codex sandbox emits a known pre-project macOS
CA-certificate diagnostic. For the existing shell harnesses only, their
error-line matcher ignored that exact environment line while retaining Godot
exit codes, SIGKILL behavior and every other `ERROR`, `SCRIPT ERROR` or parse
error.

## Remaining native gate

The attempted GUI application registration aborted in AppKit/HIServices before
Godot project/runtime initialization. The user crash report contains no Godot
project stack frame and no Shelter script/resource involvement. Direct GUI
launch was not repeated after coordinator/PM acknowledgement.

Therefore this directory contains no fabricated native desktop, checker,
passthrough or window-bound captures. The following remain pending:

- macOS native desktop/window/passthrough capture and ordinary `play.sh` GUI
  smoke in an environment where AppKit registration is available;
- Windows native parity (`CROSS_PLATFORM_WARN_WINDOWS_PENDING`);
- runtime Art review and final user acceptance.

Post-PASS status/current documents and the brief result section were not
changed.
