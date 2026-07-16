#!/usr/bin/env python3
"""Fail-closed Godot child observation and graceful-stop boundary.

The public command line exposes only fixed Shelter Godot profiles.  The
``run_test_child`` function is intentionally import-only and exists solely for
the stdlib unit matrix in ``tests/tools``.
"""

from __future__ import annotations

import argparse
import base64
import dataclasses
import datetime as dt
import hashlib
import json
import os
import pwd
import re
import signal
import subprocess
import sys
import tempfile
import threading
import time
from pathlib import Path
from typing import BinaryIO, Callable, Iterable, Sequence


RC_OK = 0
RC_PREFLIGHT_OR_OBSERVER_INTERNAL = 70
RC_CHILD_NONZERO_EXIT = 71
RC_UNEXPECTED_SIGNAL = 72
RC_DIAGNOSTIC_FAILURE = 73
RC_TIMEOUT_GRACEFUL_STOP_COMPLETED = 74
RC_BLOCKED_CHILD_STILL_RUNNING = 75

EXPECTED_GODOT_VERSION = "4.7.1.stable.steam.a13da4feb"
STEAM_DIR = Path(__file__).resolve().parents[1]
REPO_DIR = STEAM_DIR.parent
PROJECT_FILE = STEAM_DIR / "project.godot"
EVIDENCE_ROOT = (
    REPO_DIR
    / "docs/drive/Shelter/03_DESIGN/04_DELIVERABLES"
    / "STEAM_R48_05A_D024_RESPONSIVE_PRESENTATION_RUNTIME_CAPTURE_v1"
)
STEAM_GODOT_BINARY = (
    Path(pwd.getpwuid(os.getuid()).pw_dir)
    / "Library/Application Support/Steam/steamapps/common/Godot Engine/Godot.app/Contents/MacOS/Godot"
)

PUBLIC_PROFILES = (
    "version",
    "import",
    "script-check",
    "scene-test",
    "scene-capture",
    "ordinary-player",
)
SCRIPT_TARGETS = {
    "vertical-slice": "res://scripts/prototypes/vertical_slice/vertical_slice_demo.gd",
    "d024-test": "res://tests/vertical_slice_visual/test_d024_responsive_presentation.gd",
}
SCENE_TARGETS = {
    "d024": "res://tests/vertical_slice_visual/d024_responsive_presentation_test_runner.tscn",
    "labrador": "res://tests/vertical_slice_visual/labrador_visual_test_runner.tscn",
    "player-checkpoints": "res://tests/player_checkpoints/player_checkpoint_test_runner.tscn",
    "player-day2-return": "res://tests/day2_return/player_day2_return_test_runner.tscn",
    "launch-surfaces": "res://tests/launch_surfaces/player_boot_test_runner.tscn",
    "profile-store": "res://tests/persistence/player_profile_store_test_runner.tscn",
    "player-continue": "res://tests/player_continue/player_continue_test_runner.tscn",
}
FINITE_REQUIRED_OUTPUT = {
    "d024": (b"d024_responsive_presentation_test=passed",),
    "labrador": (b"labrador_r48_05a_visual_test=passed",),
    "player-checkpoints": (b"player_checkpoint_test=passed cursors=17",),
    "player-day2-return": (b"player_day2_return_test=passed cursors=33",),
    "launch-surfaces": (b"launch_surfaces_test=passed",),
}
CAPTURE_REQUIRED_OUTPUT = {
    "d024": (b"d024_responsive_presentation_capture=passed",),
    "labrador": (b"labrador_r48_05a_capture=passed",),
}
PROFILE_STORE_PHASES = {
    "assert-absent",
    "cleanup",
    "full",
    "restart-read",
    "restart-write",
    "snapshot-baseline",
    "snapshot-create",
    "snapshot-inspect",
    "snapshot-update",
}
CONTINUE_PHASES = {
    "advance",
    "automatic-save-retry",
    "cleanup",
    "full",
    "read",
    "recovery",
    "retry-cursor",
    "save-retry",
    "sequence-rules",
    "snapshot-completion-beat",
    "snapshot-failed-barrier",
    "snapshot-inflight",
    "write",
}
FAILPOINTS = {
    "after_backup_write",
    "after_primary_promotion",
    "after_primary_remove",
    "after_temp_flush",
    "after_temp_readback",
    "after_temp_write",
    "before_validation",
}
EXPECTED_PROFILE_STATUSES = {"", "no_valid_profile", "primary_available", "temp_available"}
DIAGNOSTIC_PATTERN = re.compile(
    br"(?m)^(?:SCRIPT ERROR|Parse Error|ERROR:)[^\r\n]*"
    br"(?:\r?\n[ \t]+at:[^\r\n]*)?(?:\r?\n|$)"
)
CONTROL_FLAG = "--shelter-observer-control-v1"
CONTROL_REQUEST_USER_PATH = "user://d029-observer-control/quit.request"
CONTROL_REQUEST_RELATIVE_PATH = Path(
    "Library/Application Support/Godot/app_userdata/Shelter/d029-observer-control/quit.request"
)
CONTROL_REQUEST = b"SHELTER_CONTROL_QUIT\n"
CONTROL_ACK_LINE = b"shelter_project_quit_ack=true\n"


class PreflightError(RuntimeError):
    """A fail-closed error that occurs before the governed target is spawned."""


@dataclasses.dataclass(frozen=True)
class ProcessSpec:
    profile: str
    binary: Path
    version: str
    argv: tuple[str, ...]
    cwd: Path
    home: Path
    output_dir: Path
    project_dir: Path
    required_stdout_all: tuple[bytes, ...] = ()
    required_stdout_any: tuple[bytes, ...] = ()
    long_lived: bool = False
    ready_stdout_any: tuple[bytes, ...] = ()
    ready_timeout: float = 6.0
    control_ack_timeout: float = 0.4
    first_grace: float = 0.5
    term_grace: float = 0.5
    control_request_bytes: bytes = CONTROL_REQUEST
    imported_test_seam: bool = False


@dataclasses.dataclass
class RunOutcome:
    rc: int
    result: dict[str, object]
    result_path: Path
    process: subprocess.Popen[bytes] | None = None


def _utc_now() -> str:
    return dt.datetime.now(dt.timezone.utc).isoformat().replace("+00:00", "Z")


def _sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def _sha256_file(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def _git_head_sha(repo: Path) -> str:
    git_entry = repo / ".git"
    git_dir = git_entry
    if git_entry.is_file():
        line = git_entry.read_text().strip()
        if not line.startswith("gitdir: "):
            raise PreflightError("repository gitdir pointer is malformed")
        git_dir = (repo / line.removeprefix("gitdir: ")).resolve()
    head = (git_dir / "HEAD").read_text().strip()
    if re.fullmatch(r"[0-9a-f]{40}", head):
        return head
    if not head.startswith("ref: "):
        raise PreflightError("repository HEAD is malformed")
    reference = head.removeprefix("ref: ")
    loose = git_dir / reference
    if loose.is_file():
        commit = loose.read_text().strip()
        if re.fullmatch(r"[0-9a-f]{40}", commit):
            return commit
    packed = git_dir / "packed-refs"
    if packed.is_file():
        for line in packed.read_text().splitlines():
            if line.startswith(("#", "^")) or " " not in line:
                continue
            commit, candidate = line.split(" ", 1)
            if candidate == reference and re.fullmatch(r"[0-9a-f]{40}", commit):
                return commit
    raise PreflightError("repository HEAD ref cannot be resolved")


def _is_within(path: Path, parent: Path) -> bool:
    try:
        path.relative_to(parent)
    except ValueError:
        return False
    return True


def _is_stage_path(path: Path) -> bool:
    expected_parent = EVIDENCE_ROOT.parent.resolve()
    expected_prefix = f".{EVIDENCE_ROOT.name}.stage."
    for candidate in (path, *path.parents):
        if candidate.parent.resolve() == expected_parent and candidate.name.startswith(expected_prefix):
            return True
    return False


def _is_temp_path(path: Path) -> bool:
    roots = {
        Path(tempfile.gettempdir()).resolve(),
        Path("/tmp").resolve(),
        Path("/private/tmp").resolve(),
    }
    return any(_is_within(path, root) for root in roots)


def _validate_boundary(path: Path, label: str, *, allow_stage: bool) -> Path:
    if not path.is_absolute():
        raise PreflightError(f"{label} must be absolute")
    if path.exists() and path.is_symlink():
        raise PreflightError(f"{label} must not be a symlink")
    resolved_parent = path.parent.resolve()
    resolved = resolved_parent / path.name
    if resolved == EVIDENCE_ROOT.resolve() or _is_within(resolved, EVIDENCE_ROOT.resolve()):
        raise PreflightError(f"{label} must not target canonical D-024 evidence")
    if not _is_temp_path(resolved) and not (allow_stage and _is_stage_path(resolved)):
        raise PreflightError(f"{label} is outside the fixed temporary/staged boundary")
    return resolved


def _validate_test_base(value: str) -> str:
    if not re.fullmatch(r"user://player-tests/[A-Za-z0-9][A-Za-z0-9._/-]*", value):
        raise PreflightError("test base is outside the isolated player-tests namespace")
    if ".." in value.split("/"):
        raise PreflightError("test base contains traversal")
    return value.rstrip("/")


def _control_request_path(home: Path) -> Path:
    return home / CONTROL_REQUEST_RELATIVE_PATH


def _validate_control_request_pre_spawn(home: Path) -> Path:
    request_path = _control_request_path(home)
    if not _is_within(request_path, home):
        raise PreflightError("control request escaped the isolated HOME")
    if request_path.exists() or request_path.is_symlink():
        raise PreflightError("stale or colliding observer control request")
    relative_parent = request_path.parent.relative_to(home)
    current = home
    for part in relative_parent.parts:
        current /= part
        if current.is_symlink():
            raise PreflightError("observer control request parent must not be a symlink")
    return request_path


def _write_control_request(path: Path, payload: bytes) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    if path.exists() or path.is_symlink():
        raise PreflightError("observer control request collided after child spawn")
    descriptor = os.open(path, os.O_WRONLY | os.O_CREAT | os.O_EXCL, 0o600)
    try:
        with os.fdopen(descriptor, "wb", buffering=0, closefd=False) as handle:
            handle.write(payload)
            handle.flush()
            os.fsync(handle.fileno())
    finally:
        os.close(descriptor)


def _validate_public_spec(spec: ProcessSpec) -> None:
    if spec.profile not in PUBLIC_PROFILES:
        raise PreflightError("unknown public profile")
    if spec.binary != STEAM_GODOT_BINARY or spec.binary.is_symlink():
        raise PreflightError("binary is not the exact D-028 Steam Godot path")
    if not spec.binary.is_file() or not os.access(spec.binary, os.X_OK):
        raise PreflightError("Steam-managed Godot binary is missing or not executable")
    if spec.project_dir.resolve() != STEAM_DIR.resolve() or not PROJECT_FILE.is_file():
        raise PreflightError("canonical Steam project is missing or mismatched")
    if spec.cwd.resolve() != STEAM_DIR.resolve():
        raise PreflightError("profile cwd is not canonical steam/")
    if spec.version != EXPECTED_GODOT_VERSION:
        raise PreflightError("Godot version preflight was not exact")
    _validate_boundary(spec.home, "HOME", allow_stage=False)
    _validate_boundary(spec.output_dir, "output", allow_stage=True)
    if spec.output_dir.exists():
        raise PreflightError("output directory already exists")
    argv = list(spec.argv)
    if not argv or Path(argv[0]) != spec.binary:
        raise PreflightError("argv executable mismatch")
    if "--editor" in argv:
        raise PreflightError("editor mode is forbidden")
    path_indexes = [index for index, value in enumerate(argv) if value == "--path"]
    if spec.profile == "version":
        if argv != [str(spec.binary), "--version"]:
            raise PreflightError("version argv drift")
        return
    if len(path_indexes) != 1:
        raise PreflightError("argv must contain exactly one --path")
    path_index = path_indexes[0]
    if path_index + 1 >= len(argv) or Path(argv[path_index + 1]).resolve() != STEAM_DIR.resolve():
        raise PreflightError("argv project path is not canonical steam/")
    if spec.profile in {"scene-capture", "ordinary-player"} and "--headless" in argv:
        raise PreflightError("GUI/capture profile cannot be substituted with headless")
    if spec.profile == "ordinary-player":
        expected = [str(spec.binary), "--path", str(STEAM_DIR), "--", CONTROL_FLAG]
        if argv != expected or spec.control_request_bytes != CONTROL_REQUEST:
            raise PreflightError("ordinary-player control argv drift")
        _validate_control_request_pre_spawn(spec.home)


class _EventWriter:
    def __init__(self, path: Path) -> None:
        self._path = path
        self._lock = threading.Lock()
        self._sequence = 0
        if path.exists():
            self._sequence = len(path.read_bytes().splitlines())

    def write(self, kind: str, **fields: object) -> None:
        with self._lock:
            self._sequence += 1
            payload = {"sequence": self._sequence, "timestamp": _utc_now(), "event": kind, **fields}
            with self._path.open("ab") as handle:
                handle.write(json.dumps(payload, ensure_ascii=False, sort_keys=True).encode("utf-8") + b"\n")
                handle.flush()


def _diagnostic_matches(stdout: bytes, stderr: bytes) -> list[dict[str, object]]:
    matches: list[dict[str, object]] = []
    for stream, data in (("stdout", stdout), ("stderr", stderr)):
        for match in DIAGNOSTIC_PATTERN.finditer(data):
            raw = match.group(0)
            matches.append(
                {
                    "stream": stream,
                    "byte_start": match.start(),
                    "byte_end": match.end(),
                    "raw_base64": base64.b64encode(raw).decode("ascii"),
                    "text": raw.decode("utf-8", errors="replace").rstrip("\r\n"),
                }
            )
    return matches


def _write_result(path: Path, result: dict[str, object]) -> None:
    temporary = path.with_name(f".{path.name}.tmp.{os.getpid()}")
    temporary.write_text(json.dumps(result, ensure_ascii=False, indent=2, sort_keys=True) + "\n")
    os.replace(temporary, path)


def _wait_until(predicate: Callable[[], bool], process: subprocess.Popen[bytes], timeout: float) -> bool:
    deadline = time.monotonic() + timeout
    while time.monotonic() < deadline:
        if predicate():
            return True
        if process.poll() is not None:
            return predicate()
        time.sleep(0.01)
    return predicate()


def _run_process(
    spec: ProcessSpec,
    *,
    popen_factory: Callable[..., subprocess.Popen[bytes]] = subprocess.Popen,
    stdout_mirror: BinaryIO | None = None,
    stderr_mirror: BinaryIO | None = None,
    allow_existing_output: bool = False,
) -> RunOutcome:
    if spec.output_dir.exists() and not allow_existing_output:
        raise PreflightError("process output directory already exists")
    control_request_path = _validate_control_request_pre_spawn(spec.home) if spec.long_lived else None
    spec.output_dir.mkdir(parents=True, exist_ok=allow_existing_output)
    stdout_path = spec.output_dir / "stdout.log"
    stderr_path = spec.output_dir / "stderr.log"
    stdout_tail_offset = stdout_path.stat().st_size if stdout_path.exists() else 0
    stderr_tail_offset = stderr_path.stat().st_size if stderr_path.exists() else 0
    events = _EventWriter(spec.output_dir / "events.jsonl")
    result_path = spec.output_dir / "process-result.json"
    stdout_mirror = stdout_mirror or sys.stdout.buffer
    stderr_mirror = stderr_mirror or sys.stderr.buffer
    started_at = _utc_now()
    started_monotonic = time.monotonic()
    events.write("spawn_requested", profile=spec.profile, argv=list(spec.argv))
    environment = os.environ.copy()
    environment["HOME"] = str(spec.home)
    stdout_child = stdout_path.open("ab", buffering=0)
    stderr_child = stderr_path.open("ab", buffering=0)
    try:
        process = popen_factory(
            list(spec.argv),
            cwd=str(spec.cwd),
            env=environment,
            stdin=subprocess.DEVNULL,
            stdout=stdout_child,
            stderr=stderr_child,
            bufsize=0,
        )
    except OSError as error:
        events.write("spawn_failed", error=str(error))
        result = {
            "schema": "shelter.godot-process-result.v1",
            "supervisor_rc": RC_PREFLIGHT_OR_OBSERVER_INTERNAL,
            "profile": spec.profile,
            "binary": str(spec.binary),
            "version": spec.version,
            "expected_version": EXPECTED_GODOT_VERSION,
            "version_verified": False,
            "argv": list(spec.argv),
            "cwd": str(spec.cwd),
            "HOME": str(spec.home),
            "project": str(spec.project_dir),
            "project_godot_sha256": _sha256_file(PROJECT_FILE),
            "pid": None,
            "start_timestamp": started_at,
            "end_timestamp": _utc_now(),
            "exit_code": None,
            "terminating_signal_number": None,
            "terminating_signal_name": None,
            "process_verdict": "FAIL",
            "diagnostic_verdict": "NOT_RUN",
            "diagnostic_matches": [],
            "capture_manifest_seal_eligible": False,
            "spawn_error": str(error),
        }
        _write_result(result_path, result)
        return RunOutcome(RC_PREFLIGHT_OR_OBSERVER_INTERNAL, result, result_path)
    finally:
        stdout_child.close()
        stderr_child.close()

    events.write("child_started", pid=process.pid)
    stdout_buffer = bytearray()
    stderr_buffer = bytearray()
    buffer_lock = threading.Lock()

    tail_stop = threading.Event()

    def tail(path: Path, offset: int, mirror: BinaryIO, buffer: bytearray, stream: str) -> None:
        with path.open("rb", buffering=0) as retained:
            retained.seek(offset)
            while True:
                chunk = retained.read(4096)
                if chunk:
                    with buffer_lock:
                        buffer.extend(chunk)
                    mirror.write(chunk)
                    mirror.flush()
                    events.write("stream_bytes", stream=stream, byte_count=len(chunk))
                    continue
                if tail_stop.is_set():
                    break
                time.sleep(0.01)
        events.write("stream_tail_stopped", stream=stream)

    stdout_thread = threading.Thread(
        target=tail,
        args=(stdout_path, stdout_tail_offset, stdout_mirror, stdout_buffer, "stdout"),
        daemon=True,
    )
    stderr_thread = threading.Thread(
        target=tail,
        args=(stderr_path, stderr_tail_offset, stderr_mirror, stderr_buffer, "stderr"),
        daemon=True,
    )
    stdout_thread.start()
    stderr_thread.start()

    requested_stop_method = "none"
    control_acknowledged = False
    control_request_timestamp: str | None = None
    control_request_sha256: str | None = None
    control_ack_timestamp: str | None = None
    term_timestamp: str | None = None
    ready_observed = not spec.long_lived
    stop_contract_failure = False

    if spec.long_lived:
        def stdout_has_any(patterns: Iterable[bytes]) -> bool:
            with buffer_lock:
                snapshot = bytes(stdout_buffer)
            return any(pattern in snapshot for pattern in patterns)

        ready_observed = _wait_until(lambda: stdout_has_any(spec.ready_stdout_any), process, spec.ready_timeout)
        events.write("readiness_result", observed=ready_observed)
        if not ready_observed:
            stop_contract_failure = True
        if process.poll() is None:
            requested_stop_method = "project_control_quit"
            control_request_timestamp = _utc_now()
            assert control_request_path is not None
            try:
                _write_control_request(control_request_path, spec.control_request_bytes)
                control_request_sha256 = _sha256_bytes(spec.control_request_bytes)
                events.write(
                    "project_control_quit_requested",
                    pid=process.pid,
                    request_path=CONTROL_REQUEST_USER_PATH,
                    request_sha256=control_request_sha256,
                )
            except (OSError, PreflightError) as error:
                stop_contract_failure = True
                events.write("project_control_quit_write_failed", error=str(error))
            control_acknowledged = _wait_until(
                lambda: stdout_has_any((CONTROL_ACK_LINE,)), process, spec.control_ack_timeout
            )
            if control_acknowledged:
                control_ack_timestamp = _utc_now()
                events.write("project_control_quit_acknowledged", pid=process.pid)
            else:
                events.write("project_control_quit_not_acknowledged", pid=process.pid)
            _wait_until(lambda: process.poll() is not None, process, spec.first_grace)
        if process.poll() is None:
            requested_stop_method = "exact_pid_sigterm"
            term_timestamp = _utc_now()
            events.write("exact_pid_sigterm_sent", pid=process.pid)
            try:
                os.kill(process.pid, signal.SIGTERM)
            except ProcessLookupError:
                events.write("exact_pid_already_exited", pid=process.pid)
            _wait_until(lambda: process.poll() is not None, process, spec.term_grace)
    else:
        process.wait()

    final_alive = process.poll() is None
    tail_stop.set()
    stdout_thread.join(timeout=2.0)
    stderr_thread.join(timeout=2.0)
    if stdout_thread.is_alive() or stderr_thread.is_alive():
        events.write("stream_tail_join_failed")
        stop_contract_failure = True
    retained_stdout = stdout_path.read_bytes()
    retained_stderr = stderr_path.read_bytes()
    matches = _diagnostic_matches(retained_stdout, retained_stderr)
    missing_required: list[str] = []
    for pattern in spec.required_stdout_all:
        if pattern not in retained_stdout:
            missing_required.append(pattern.decode("utf-8", errors="replace"))
    if spec.required_stdout_any and not any(pattern in retained_stdout for pattern in spec.required_stdout_any):
        missing_required.append("ANY:" + "|".join(p.decode("utf-8", errors="replace") for p in spec.required_stdout_any))
    for pattern in missing_required:
        matches.append({"stream": "stdout", "kind": "missing_required_output", "text": pattern})

    return_code = process.poll()
    exit_code: int | None = None
    signal_number: int | None = None
    signal_name: str | None = None
    if return_code is not None and return_code >= 0:
        exit_code = return_code
    elif return_code is not None:
        signal_number = -return_code
        try:
            signal_name = signal.Signals(signal_number).name
        except ValueError:
            signal_name = f"SIGNAL_{signal_number}"

    if final_alive:
        process_verdict = "BLOCKED_CHILD_STILL_RUNNING"
    elif spec.long_lived:
        process_verdict = (
            "PASS"
            if ready_observed
            and requested_stop_method == "project_control_quit"
            and control_acknowledged
            and exit_code == 0
            else "FAIL"
        )
    else:
        process_verdict = "PASS" if exit_code == 0 else "FAIL"
    diagnostic_verdict = "PASS" if not matches else "FAIL"

    expected_long_lived_signal = spec.long_lived and requested_stop_method == "exact_pid_sigterm"
    fallback_completed = spec.long_lived and term_timestamp is not None and not final_alive
    timed_out_but_stopped = spec.long_lived and (
        fallback_completed
        or stop_contract_failure
        or (requested_stop_method == "project_control_quit" and not control_acknowledged and exit_code == 0)
    )
    if final_alive:
        supervisor_rc = RC_BLOCKED_CHILD_STILL_RUNNING
    elif diagnostic_verdict != "PASS":
        supervisor_rc = RC_DIAGNOSTIC_FAILURE
    elif fallback_completed:
        supervisor_rc = RC_TIMEOUT_GRACEFUL_STOP_COMPLETED
    elif signal_number is not None and not expected_long_lived_signal:
        supervisor_rc = RC_UNEXPECTED_SIGNAL
    elif exit_code not in (None, 0):
        supervisor_rc = RC_CHILD_NONZERO_EXIT
    elif timed_out_but_stopped:
        supervisor_rc = RC_TIMEOUT_GRACEFUL_STOP_COMPLETED
    elif process_verdict != "PASS":
        supervisor_rc = RC_PREFLIGHT_OR_OBSERVER_INTERNAL
    else:
        supervisor_rc = RC_OK
    eligible = supervisor_rc == RC_OK and process_verdict == "PASS" and diagnostic_verdict == "PASS"
    ended_at = _utc_now()
    events.write(
        "child_complete" if not final_alive else "child_still_running",
        pid=process.pid,
        supervisor_rc=supervisor_rc,
        process_verdict=process_verdict,
        diagnostic_verdict=diagnostic_verdict,
    )
    result: dict[str, object] = {
        "schema": "shelter.godot-process-result.v1",
        "supervisor_rc": supervisor_rc,
        "supervisor_rc_name": {
            RC_OK: "PASS",
            RC_CHILD_NONZERO_EXIT: "CHILD_NONZERO_EXIT",
            RC_UNEXPECTED_SIGNAL: "UNEXPECTED_SIGNAL",
            RC_DIAGNOSTIC_FAILURE: "DIAGNOSTIC_FAILURE",
            RC_TIMEOUT_GRACEFUL_STOP_COMPLETED: "TIMEOUT_GRACEFUL_STOP_COMPLETED",
            RC_BLOCKED_CHILD_STILL_RUNNING: "BLOCKED_CHILD_STILL_RUNNING",
        }.get(supervisor_rc, "SUPERVISOR_FAILURE"),
        "profile": spec.profile,
        "binary": str(spec.binary),
        "version": spec.version,
        "expected_version": EXPECTED_GODOT_VERSION,
        "version_verified": not spec.imported_test_seam and spec.version == EXPECTED_GODOT_VERSION,
        "argv": list(spec.argv),
        "cwd": str(spec.cwd),
        "HOME": str(spec.home),
        "project": str(spec.project_dir),
        "project_godot_sha256": _sha256_file(PROJECT_FILE),
        "pid": process.pid,
        "start_timestamp": started_at,
        "end_timestamp": ended_at,
        "elapsed_seconds": round(time.monotonic() - started_monotonic, 6),
        "exit_code": exit_code,
        "terminating_signal_number": signal_number,
        "terminating_signal_name": signal_name,
        "requested_stop_method": requested_stop_method,
        "project_control_quit_requested_at": control_request_timestamp,
        "project_control_quit_request_path": CONTROL_REQUEST_USER_PATH if spec.long_lived else None,
        "project_control_quit_request_sha256": control_request_sha256,
        "project_control_quit_acknowledged": control_acknowledged,
        "project_control_quit_acknowledged_at": control_ack_timestamp,
        "exact_pid_sigterm_sent_at": term_timestamp,
        "ready_observed": ready_observed,
        "final_exact_pid_alive": final_alive,
        "raw_logs_finalized": not final_alive,
        "stdout": {"byte_count": len(retained_stdout), "sha256": _sha256_bytes(retained_stdout)},
        "stderr": {"byte_count": len(retained_stderr), "sha256": _sha256_bytes(retained_stderr)},
        "process_verdict": process_verdict,
        "diagnostic_verdict": diagnostic_verdict,
        "diagnostic_matches": matches,
        "capture_manifest_seal_eligible": eligible,
        "imported_test_seam": spec.imported_test_seam,
    }
    _write_result(result_path, result)
    return RunOutcome(supervisor_rc, result, result_path, process if final_alive else None)


def run_test_child(
    argv: Sequence[str],
    output_dir: Path,
    *,
    long_lived: bool = False,
    ready_stdout_any: tuple[bytes, ...] = (),
    required_stdout_all: tuple[bytes, ...] = (),
    stdout_mirror: BinaryIO | None = None,
    stderr_mirror: BinaryIO | None = None,
    allow_existing_output: bool = False,
    ready_timeout: float = 0.5,
    control_ack_timeout: float = 0.15,
    first_grace: float = 0.15,
    term_grace: float = 0.15,
    control_request_bytes: bytes = CONTROL_REQUEST,
) -> RunOutcome:
    """Imported fake-child seam; deliberately unreachable from the public CLI."""

    home = output_dir.parent / "home"
    home.mkdir(parents=True, exist_ok=True)
    spec = ProcessSpec(
        profile="unit-fake-child",
        binary=Path(argv[0]),
        version="imported-test-seam",
        argv=tuple(argv),
        cwd=STEAM_DIR,
        home=home,
        output_dir=output_dir,
        project_dir=STEAM_DIR,
        required_stdout_all=required_stdout_all,
        long_lived=long_lived,
        ready_stdout_any=ready_stdout_any,
        ready_timeout=ready_timeout,
        control_ack_timeout=control_ack_timeout,
        first_grace=first_grace,
        term_grace=term_grace,
        control_request_bytes=control_request_bytes,
        imported_test_seam=True,
    )
    return _run_process(
        spec,
        stdout_mirror=stdout_mirror,
        stderr_mirror=stderr_mirror,
        allow_existing_output=allow_existing_output,
    )


class _FailClosedArgumentParser(argparse.ArgumentParser):
    def error(self, message: str) -> None:
        raise PreflightError(message)


def _build_parser() -> argparse.ArgumentParser:
    parser = _FailClosedArgumentParser(description=__doc__)
    parser.add_argument("profile", choices=PUBLIC_PROFILES)
    parser.add_argument("--output-dir", required=True, type=Path)
    parser.add_argument("--home", required=True, type=Path)
    parser.add_argument("--target", choices=sorted(set(SCRIPT_TARGETS) | set(SCENE_TARGETS)))
    parser.add_argument("--phase")
    parser.add_argument("--test-base")
    parser.add_argument("--sequence", type=int)
    parser.add_argument("--failpoint", choices=sorted(FAILPOINTS))
    parser.add_argument("--expected-status", choices=sorted(EXPECTED_PROFILE_STATUSES))
    parser.add_argument("--capture-dir", type=Path)
    return parser


def _require_none(namespace: argparse.Namespace, names: Iterable[str]) -> None:
    for name in names:
        if getattr(namespace, name) not in (None, ""):
            raise PreflightError(f"{name.replace('_', '-')} is not accepted by profile {namespace.profile}")


def _profile_spec(namespace: argparse.Namespace, output_dir: Path, version: str) -> ProcessSpec:
    binary = STEAM_GODOT_BINARY
    base = [str(binary)]
    required_all: tuple[bytes, ...] = ()
    if namespace.profile == "version":
        _require_none(namespace, ("target", "phase", "test_base", "sequence", "failpoint", "expected_status", "capture_dir"))
        argv = base + ["--version"]
        required_all = (EXPECTED_GODOT_VERSION.encode("ascii"),)
    elif namespace.profile == "import":
        _require_none(namespace, ("target", "phase", "test_base", "sequence", "failpoint", "expected_status", "capture_dir"))
        argv = base + ["--headless", "--path", str(STEAM_DIR), "--import"]
    elif namespace.profile == "script-check":
        if namespace.target not in SCRIPT_TARGETS:
            raise PreflightError("script-check requires a fixed script target")
        _require_none(namespace, ("phase", "test_base", "sequence", "failpoint", "expected_status", "capture_dir"))
        argv = base + [
            "--headless", "--path", str(STEAM_DIR), "--check-only", "--script", SCRIPT_TARGETS[namespace.target]
        ]
    elif namespace.profile == "scene-test":
        if namespace.target not in SCENE_TARGETS:
            raise PreflightError("scene-test requires a fixed scene target")
        argv = base + ["--headless", "--path", str(STEAM_DIR), "--scene", SCENE_TARGETS[namespace.target]]
        user_args: list[str] = []
        if namespace.target == "profile-store":
            if namespace.phase not in PROFILE_STORE_PHASES or namespace.test_base is None:
                raise PreflightError("profile-store requires fixed phase and isolated test base")
            _require_none(namespace, ("sequence", "capture_dir"))
            base_dir = _validate_test_base(namespace.test_base)
            user_args = [f"--persistence-test-phase={namespace.phase}", f"--persistence-test-base={base_dir}"]
            if namespace.failpoint:
                user_args.append(f"--persistence-test-failpoint={namespace.failpoint}")
            if namespace.expected_status:
                user_args.append(f"--persistence-test-expected-status={namespace.expected_status}")
            required_all = (f"player_profile_store_test=passed phase={namespace.phase}".encode(),)
        elif namespace.target == "player-continue":
            if namespace.phase not in CONTINUE_PHASES or namespace.test_base is None or namespace.sequence is None:
                raise PreflightError("player-continue requires fixed phase, base and sequence")
            _require_none(namespace, ("failpoint", "expected_status", "capture_dir"))
            if not 1 <= namespace.sequence <= 33:
                raise PreflightError("player-continue sequence is outside 1..33")
            base_dir = _validate_test_base(namespace.test_base)
            user_args = [
                f"--continue-test-phase={namespace.phase}",
                f"--continue-test-base={base_dir}",
                f"--continue-test-sequence={namespace.sequence}",
            ]
            required_all = (
                f"player_continue_test=passed phase={namespace.phase} sequence={namespace.sequence}".encode(),
            )
        elif namespace.target == "launch-surfaces":
            _require_none(namespace, ("phase", "test_base", "sequence", "failpoint", "expected_status", "capture_dir"))
            run_id = hashlib.sha256(str(output_dir).encode()).hexdigest()[:12]
            user_args = [
                f"--launch-test-base=user://player-tests/r48-launch-{run_id}",
                "--runtime-load-fixture=second_day_after_first_delivery",
                "--runtime-load-save",
                "--state-connector-control",
                "--state-connector-token=must-not-be-read",
                "--vertical-qa",
                "--vertical-fast",
                "--vertical-auto-play",
                "--vertical-capture",
            ]
            required_all = FINITE_REQUIRED_OUTPUT[namespace.target]
        else:
            _require_none(namespace, ("phase", "test_base", "sequence", "failpoint", "expected_status", "capture_dir"))
            required_all = FINITE_REQUIRED_OUTPUT[namespace.target]
        if user_args:
            argv += ["--", *user_args]
    elif namespace.profile == "scene-capture":
        if namespace.target not in CAPTURE_REQUIRED_OUTPUT or namespace.capture_dir is None:
            raise PreflightError("scene-capture requires d024/labrador and a staged capture directory")
        _require_none(namespace, ("phase", "test_base", "sequence", "failpoint", "expected_status"))
        capture_dir = _validate_boundary(namespace.capture_dir, "capture-dir", allow_stage=True)
        if not _is_stage_path(capture_dir):
            raise PreflightError("capture-dir must be inside the unique D-024 stage")
        argv = base + ["--path", str(STEAM_DIR), "--scene", SCENE_TARGETS[namespace.target], "--"]
        if namespace.target == "d024":
            argv.append(f"--d024-capture-dir={capture_dir}")
        else:
            commit = _git_head_sha(REPO_DIR)
            argv += [f"--r48-05a-capture-dir={capture_dir / 'ah_runtime'}", f"--r48-05a-git-commit={commit}"]
        required_all = CAPTURE_REQUIRED_OUTPUT[namespace.target]
    else:
        _require_none(namespace, ("target", "phase", "test_base", "sequence", "failpoint", "expected_status", "capture_dir"))
        argv = base + ["--path", str(STEAM_DIR), "--", CONTROL_FLAG]
    return ProcessSpec(
        profile=namespace.profile,
        binary=binary,
        version=version,
        argv=tuple(argv),
        cwd=STEAM_DIR,
        home=namespace.home,
        output_dir=output_dir,
        project_dir=STEAM_DIR,
        required_stdout_all=required_all,
        long_lived=namespace.profile == "ordinary-player",
        ready_stdout_any=(b"player_boot", b"demo=steam_vertical_slice", b"active_order_id="),
    )


def _run_public(namespace: argparse.Namespace) -> RunOutcome:
    output_root = _validate_boundary(namespace.output_dir, "output", allow_stage=True)
    home = _validate_boundary(namespace.home, "HOME", allow_stage=False)
    if not home.is_dir() or home.is_symlink():
        raise PreflightError("HOME must be an existing non-symlink temporary directory")
    if output_root.exists():
        raise PreflightError("output directory already exists")
    # All public input is validated before the fixed version probe is spawned.
    tentative = _profile_spec(namespace, output_root / "target", EXPECTED_GODOT_VERSION)
    _validate_public_spec(tentative)
    output_root.mkdir(parents=True)
    if namespace.profile != "version":
        version_namespace = argparse.Namespace(
            profile="version", output_dir=output_root, home=home, target=None, phase=None,
            test_base=None, sequence=None, failpoint=None, expected_status=None, capture_dir=None,
        )
        version_spec = _profile_spec(version_namespace, output_root / "preflight-version", EXPECTED_GODOT_VERSION)
        _validate_public_spec(version_spec)
        version_outcome = _run_process(version_spec)
        actual_version = (version_spec.output_dir / "stdout.log").read_text(errors="replace").strip()
        _record_version_readback(version_outcome, actual_version)
        if version_outcome.rc != RC_OK or actual_version != EXPECTED_GODOT_VERSION:
            return version_outcome
    spec = _profile_spec(namespace, output_root / "target", EXPECTED_GODOT_VERSION)
    _validate_public_spec(spec)
    outcome = _run_process(spec)
    if namespace.profile == "version":
        actual_version = (spec.output_dir / "stdout.log").read_text(errors="replace").strip()
        _record_version_readback(outcome, actual_version)
    return outcome


def _record_version_readback(outcome: RunOutcome, actual_version: str) -> None:
    outcome.result["version"] = actual_version
    outcome.result["expected_version"] = EXPECTED_GODOT_VERSION
    outcome.result["version_verified"] = actual_version == EXPECTED_GODOT_VERSION
    if actual_version != EXPECTED_GODOT_VERSION and outcome.rc == RC_OK:
        outcome.result["diagnostic_verdict"] = "FAIL"
        outcome.result["diagnostic_matches"] = [
            {"stream": "stdout", "kind": "version_mismatch", "text": actual_version}
        ]
        outcome.result["capture_manifest_seal_eligible"] = False
        outcome.result["supervisor_rc"] = RC_DIAGNOSTIC_FAILURE
        outcome.result["supervisor_rc_name"] = "DIAGNOSTIC_FAILURE"
        outcome.rc = RC_DIAGNOSTIC_FAILURE
    _write_result(outcome.result_path, outcome.result)


def main(argv: Sequence[str] | None = None) -> int:
    parser = _build_parser()
    try:
        namespace = parser.parse_args(argv)
        outcome = _run_public(namespace)
    except PreflightError as error:
        print(f"godot_process_preflight=FAIL reason={error}", file=sys.stderr)
        return RC_PREFLIGHT_OR_OBSERVER_INTERNAL
    except (OSError, subprocess.SubprocessError) as error:
        print(f"godot_process_supervisor=FAIL reason={error}", file=sys.stderr)
        return RC_PREFLIGHT_OR_OBSERVER_INTERNAL
    print(f"godot_process_result={outcome.result_path}")
    print(f"godot_process_supervisor_rc={outcome.rc}")
    return outcome.rc


if __name__ == "__main__":
    raise SystemExit(main())
