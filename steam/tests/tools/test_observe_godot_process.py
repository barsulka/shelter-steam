#!/usr/bin/env python3
"""Stdlib-only acceptance matrix for observe-godot-process.py."""

from __future__ import annotations

import base64
import hashlib
import importlib.util
import io
import json
import os
import re
import signal
import subprocess
import sys
import tempfile
import time
import unittest
from pathlib import Path
from unittest import mock


TOOL = Path(__file__).resolve().parents[2] / "tools/observe-godot-process.py"
SPEC = importlib.util.spec_from_file_location("shelter_observe_godot_process", TOOL)
assert SPEC is not None and SPEC.loader is not None
observer = importlib.util.module_from_spec(SPEC)
sys.modules[SPEC.name] = observer
SPEC.loader.exec_module(observer)


def child(code: str, *args: str) -> list[str]:
    return [sys.executable, "-u", "-c", code, *args]


def wait_until(predicate, timeout: float = 3.0) -> bool:
    deadline = time.monotonic() + timeout
    while time.monotonic() < deadline:
        if predicate():
            return True
        time.sleep(0.01)
    return predicate()


def pid_is_alive(pid: int) -> bool:
    try:
        os.kill(pid, 0)
    except ProcessLookupError:
        return False
    return True


class ObserveGodotProcessTests(unittest.TestCase):
    def setUp(self) -> None:
        self.temporary = tempfile.TemporaryDirectory(prefix="shelter-observer-unit.")
        self.root = Path(self.temporary.name)

    def tearDown(self) -> None:
        self.temporary.cleanup()

    def run_fake(self, code: str, name: str, **kwargs: object):
        stdout_mirror = io.BytesIO()
        stderr_mirror = io.BytesIO()
        outcome = observer.run_test_child(
            child(code), self.root / name,
            stdout_mirror=stdout_mirror, stderr_mirror=stderr_mirror, **kwargs,
        )
        return outcome, stdout_mirror.getvalue(), stderr_mirror.getvalue()

    def test_raw_streams_are_separate_byte_exact_append_only_and_mirrored(self) -> None:
        output = self.root / "raw"
        output.mkdir()
        prefix_out = b"existing-out\x00"
        prefix_err = b"existing-err\xff"
        (output / "stdout.log").write_bytes(prefix_out)
        (output / "stderr.log").write_bytes(prefix_err)
        payload_out = b"out-1\x00out-2\n"
        payload_err = b"err-1\xfferr-2\n"
        code = (
            "import os;"
            f"os.write(1,{payload_out!r});"
            f"os.write(2,{payload_err!r})"
        )
        outcome, mirrored_out, mirrored_err = self.run_fake(
            code, "raw", allow_existing_output=True
        )
        self.assertEqual(outcome.rc, observer.RC_OK)
        self.assertEqual((output / "stdout.log").read_bytes(), prefix_out + payload_out)
        self.assertEqual((output / "stderr.log").read_bytes(), prefix_err + payload_err)
        self.assertEqual(mirrored_out, payload_out)
        self.assertEqual(mirrored_err, payload_err)
        result = json.loads((output / "process-result.json").read_text())
        self.assertEqual(result["stdout"]["sha256"], hashlib.sha256(prefix_out + payload_out).hexdigest())
        self.assertEqual(result["stderr"]["sha256"], hashlib.sha256(prefix_err + payload_err).hexdigest())
        sequences = [json.loads(line)["sequence"] for line in (output / "events.jsonl").read_text().splitlines()]
        self.assertEqual(sequences, list(range(1, len(sequences) + 1)))

    def test_error_then_late_pass_finishes_naturally_and_is_diagnostic_failure(self) -> None:
        code = (
            "import sys,time;"
            "print('ERROR: first diagnostic',flush=True);"
            "time.sleep(0.05);"
            "print('late PASS',flush=True)"
        )
        outcome, mirrored_out, _ = self.run_fake(
            code, "late-pass", required_stdout_all=(b"late PASS",)
        )
        self.assertEqual(outcome.rc, observer.RC_DIAGNOSTIC_FAILURE)
        self.assertIn(b"ERROR: first diagnostic", mirrored_out)
        self.assertIn(b"late PASS", mirrored_out)
        self.assertEqual(outcome.result["exit_code"], 0)
        self.assertEqual(outcome.result["process_verdict"], "PASS")
        self.assertEqual(outcome.result["diagnostic_verdict"], "FAIL")
        self.assertFalse(outcome.result["capture_manifest_seal_eligible"])

    def test_exit_23_retains_original_process_result(self) -> None:
        outcome, _, _ = self.run_fake("raise SystemExit(23)", "exit-23")
        self.assertEqual(outcome.rc, observer.RC_CHILD_NONZERO_EXIT)
        self.assertEqual(outcome.result["exit_code"], 23)
        self.assertIsNone(outcome.result["terminating_signal_number"])

    def test_self_sigterm_retains_original_signal_result(self) -> None:
        outcome, _, _ = self.run_fake(
            "import signal;signal.raise_signal(signal.SIGTERM)", "self-term"
        )
        self.assertEqual(outcome.rc, observer.RC_UNEXPECTED_SIGNAL)
        self.assertIsNone(outcome.result["exit_code"])
        self.assertEqual(outcome.result["terminating_signal_number"], signal.SIGTERM)
        self.assertEqual(outcome.result["terminating_signal_name"], "SIGTERM")

    def test_invalid_public_binary_project_and_argv_fail_before_spawn(self) -> None:
        base = observer.ProcessSpec(
            profile="import",
            binary=observer.STEAM_GODOT_BINARY.resolve(strict=False),
            version=observer.EXPECTED_GODOT_VERSION,
            argv=(str(observer.STEAM_GODOT_BINARY), "--headless", "--path", str(observer.STEAM_DIR), "--import"),
            cwd=observer.STEAM_DIR,
            home=self.root / "home",
            output_dir=self.root / "out",
            project_dir=observer.STEAM_DIR,
        )
        (self.root / "home").mkdir()
        malformed = (
            dataclass_replace(base, binary=Path("/tmp/foreign-godot")),
            dataclass_replace(base, project_dir=Path("/tmp/foreign-project")),
            dataclass_replace(base, argv=base.argv + ("--editor",)),
            dataclass_replace(base, argv=base.argv + ("--path", str(observer.STEAM_DIR))),
        )
        with mock.patch.object(observer, "_run_process") as spawn:
            for spec in malformed:
                with self.assertRaises(observer.PreflightError):
                    observer._validate_public_spec(spec)
            spawn.assert_not_called()

    def test_public_cli_has_no_fake_or_arbitrary_process_profile(self) -> None:
        parser = observer._build_parser()
        with self.assertRaises(observer.PreflightError):
            parser.parse_args(["fake-child", "--output-dir", "/tmp/x", "--home", "/tmp/y"])
        with self.assertRaises(observer.PreflightError):
            parser.parse_args(["import", "--output-dir", "/tmp/x", "--home", "/tmp/y", "--argv", "x"])
        self.assertEqual(
            observer.main(["fake-child", "--output-dir", "/tmp/x", "--home", "/tmp/y"]),
            observer.RC_PREFLIGHT_OR_OBSERVER_INTERNAL,
        )

    def test_ordinary_player_profile_owns_exact_control_flag_and_no_public_tail(self) -> None:
        namespace = observer.argparse.Namespace(
            profile="ordinary-player",
            output_dir=self.root / "ordinary-output",
            home=self.root / "ordinary-home",
            target=None,
            phase=None,
            test_base=None,
            sequence=None,
            failpoint=None,
            expected_status=None,
            capture_dir=None,
        )
        spec = observer._profile_spec(namespace, namespace.output_dir, observer.EXPECTED_GODOT_VERSION)
        self.assertEqual(
            spec.argv,
            (
                str(observer.STEAM_GODOT_BINARY),
                "--path",
                str(observer.STEAM_DIR),
                "--",
                observer.CONTROL_FLAG,
            ),
        )
        parser = observer._build_parser()
        with self.assertRaises(observer.PreflightError):
            parser.parse_args(
                [
                    "ordinary-player",
                    "--output-dir",
                    str(namespace.output_dir),
                    "--home",
                    str(namespace.home),
                    "--control-path",
                    "/tmp/foreign",
                ]
            )

    def test_observer_spawn_failure_uses_rc_70_not_a_child_outcome(self) -> None:
        outcome = observer.run_test_child(
            [str(self.root / "missing-child")],
            self.root / "spawn-failure",
            stdout_mirror=io.BytesIO(),
            stderr_mirror=io.BytesIO(),
        )
        self.assertEqual(outcome.rc, observer.RC_PREFLIGHT_OR_OBSERVER_INTERNAL)
        self.assertIsNone(outcome.result["pid"])
        self.assertEqual(outcome.result["process_verdict"], "FAIL")
        self.assertEqual(outcome.result["diagnostic_verdict"], "NOT_RUN")

    def test_version_result_records_actual_mismatch_and_blocks_target_eligibility(self) -> None:
        result_path = self.root / "version-result.json"
        outcome = observer.RunOutcome(
            observer.RC_OK,
            {
                "version": observer.EXPECTED_GODOT_VERSION,
                "diagnostic_verdict": "PASS",
                "diagnostic_matches": [],
                "capture_manifest_seal_eligible": True,
                "supervisor_rc": observer.RC_OK,
            },
            result_path,
        )
        observer._record_version_readback(outcome, "4.7.0.foreign")
        self.assertEqual(outcome.rc, observer.RC_DIAGNOSTIC_FAILURE)
        stored = json.loads(result_path.read_text())
        self.assertEqual(stored["version"], "4.7.0.foreign")
        self.assertEqual(stored["expected_version"], observer.EXPECTED_GODOT_VERSION)
        self.assertFalse(stored["version_verified"])
        self.assertFalse(stored["capture_manifest_seal_eligible"])

    def test_project_control_quit_ack_path_passes(self) -> None:
        code = (
            "import os,pathlib,sys,time;"
            "print('READY',flush=True);"
            f"p=pathlib.Path(os.environ['HOME'])/{str(observer.CONTROL_REQUEST_RELATIVE_PATH)!r};"
            "deadline=time.monotonic()+2;"
            "\nwhile not p.exists() and time.monotonic()<deadline: time.sleep(0.01)\n"
            "payload=p.read_bytes() if p.exists() else b'';"
            "p.unlink() if p.exists() else None;"
            "print('shelter_project_quit_ack=true',flush=True);"
            "time.sleep(0.02);"
            "raise SystemExit(0 if payload==b'SHELTER_CONTROL_QUIT\\n' else 4)"
        )
        outcome, _, _ = self.run_fake(
            code, "control-ack", long_lived=True, ready_stdout_any=(b"READY",)
        )
        self.assertEqual(outcome.rc, observer.RC_OK)
        self.assertTrue(outcome.result["project_control_quit_acknowledged"])
        self.assertEqual(outcome.result["requested_stop_method"], "project_control_quit")
        self.assertFalse(outcome.result["final_exact_pid_alive"])
        self.assertTrue(outcome.result["raw_logs_finalized"])
        self.assertEqual(
            outcome.result["project_control_quit_request_sha256"],
            hashlib.sha256(observer.CONTROL_REQUEST).hexdigest(),
        )

    def test_stale_control_request_is_rc70_pre_spawn_and_creates_no_child(self) -> None:
        output = self.root / "stale-control"
        home = output.parent / "home"
        request = observer._control_request_path(home)
        request.parent.mkdir(parents=True)
        request.write_bytes(observer.CONTROL_REQUEST)
        with mock.patch.object(observer.subprocess, "Popen") as spawn:
            with self.assertRaises(observer.PreflightError):
                observer.run_test_child(
                    child("raise SystemExit(0)"),
                    output,
                    long_lived=True,
                    ready_stdout_any=(b"READY",),
                    stdout_mirror=io.BytesIO(),
                    stderr_mirror=io.BytesIO(),
                )
            spawn.assert_not_called()
        self.assertFalse(output.exists())

    def test_malformed_control_request_is_diagnostic_failure_and_does_not_quit(self) -> None:
        code = (
            "import os,pathlib,signal,sys,time;"
            "signal.signal(signal.SIGTERM,lambda *_:sys.exit(0));"
            "print('READY',flush=True);"
            f"p=pathlib.Path(os.environ['HOME'])/{str(observer.CONTROL_REQUEST_RELATIVE_PATH)!r};"
            "deadline=time.monotonic()+2;"
            "\nwhile not p.exists() and time.monotonic()<deadline: time.sleep(0.01)\n"
            "payload=p.read_bytes() if p.exists() else b'';"
            "p.unlink() if p.exists() else None;"
            "print('ERROR: shelter_observer_control=FAIL reason=malformed_request',flush=True) "
            "if payload!=b'SHELTER_CONTROL_QUIT\\n' else None;"
            "time.sleep(10)"
        )
        outcome, mirrored, _ = self.run_fake(
            code,
            "malformed-control",
            long_lived=True,
            ready_stdout_any=(b"READY",),
            control_request_bytes=b"NOT_THE_COMMAND\n",
        )
        self.assertEqual(outcome.rc, observer.RC_DIAGNOSTIC_FAILURE)
        self.assertFalse(outcome.result["project_control_quit_acknowledged"])
        self.assertEqual(outcome.result["requested_stop_method"], "exact_pid_sigterm")
        self.assertIn(b"malformed_request", mirrored)
        self.assertFalse(outcome.result["capture_manifest_seal_eligible"])

    def test_exact_pid_sigterm_fallback_passes(self) -> None:
        code = (
            "import signal,sys,time;"
            "signal.signal(signal.SIGTERM,lambda *_:sys.exit(0));"
            "print('READY',flush=True);"
            "time.sleep(10)"
        )
        outcome, _, _ = self.run_fake(
            code, "term-fallback", long_lived=True, ready_stdout_any=(b"READY",)
        )
        self.assertEqual(outcome.rc, observer.RC_TIMEOUT_GRACEFUL_STOP_COMPLETED)
        self.assertFalse(outcome.result["project_control_quit_acknowledged"])
        self.assertEqual(outcome.result["requested_stop_method"], "exact_pid_sigterm")
        self.assertFalse(outcome.result["final_exact_pid_alive"])
        self.assertFalse(outcome.result["capture_manifest_seal_eligible"])

    def test_long_lived_nonzero_exit_is_rc_71_not_timeout(self) -> None:
        outcome, _, _ = self.run_fake(
            "import time;print('READY',flush=True);time.sleep(0.03);raise SystemExit(23)",
            "long-exit-23",
            long_lived=True,
            ready_stdout_any=(b"READY",),
            control_ack_timeout=0.1,
            first_grace=0.1,
        )
        self.assertEqual(outcome.rc, observer.RC_CHILD_NONZERO_EXIT)
        self.assertEqual(outcome.result["exit_code"], 23)

    def test_long_lived_diagnostic_failure_is_rc_73_not_timeout(self) -> None:
        code = (
            "import signal,sys,time;"
            "signal.signal(signal.SIGTERM,lambda *_:sys.exit(0));"
            "print('READY',flush=True);"
            "print('ERROR: retained long-lived diagnostic',flush=True);"
            "time.sleep(10)"
        )
        outcome, _, _ = self.run_fake(
            code, "long-diagnostic", long_lived=True, ready_stdout_any=(b"READY",)
        )
        self.assertEqual(outcome.rc, observer.RC_DIAGNOSTIC_FAILURE)
        self.assertEqual(outcome.result["process_verdict"], "FAIL")
        self.assertEqual(outcome.result["diagnostic_verdict"], "FAIL")
        self.assertEqual(outcome.result["requested_stop_method"], "exact_pid_sigterm")

    def test_separate_supervisor_rc75_preserves_late_child_writes_without_broken_pipe(self) -> None:
        output = self.root / "separate-rc75"
        supervisor_exited = self.root / "supervisor-exited"
        cooperative_stop = self.root / "cooperative-stop"
        late_stdout = b"late-stdout-after-supervisor-exit\n"
        late_stderr = b"late-stderr-after-supervisor-exit\n"
        fake_code = (
            "import os,pathlib,signal,sys,time;"
            "signal.signal(signal.SIGTERM,lambda *_:None);"
            "release=pathlib.Path(sys.argv[1]);"
            "stop=pathlib.Path(sys.argv[2]);"
            "print('READY',flush=True);"
            "\nwhile not release.exists(): time.sleep(0.01)\n"
            f"os.write(1,{late_stdout!r});"
            f"os.write(2,{late_stderr!r});"
            "\nwhile not stop.exists(): time.sleep(0.01)"
        )
        fake_argv = child(fake_code, str(supervisor_exited), str(cooperative_stop))
        driver = (
            "import importlib.util,pathlib,sys;"
            f"tool=pathlib.Path({str(TOOL)!r});"
            "spec=importlib.util.spec_from_file_location('separate_observer',tool);"
            "module=importlib.util.module_from_spec(spec);"
            "sys.modules[spec.name]=module;"
            "spec.loader.exec_module(module);"
            f"outcome=module.run_test_child({fake_argv!r},pathlib.Path({str(output)!r}),"
            "long_lived=True,ready_stdout_any=(b'READY',),control_ack_timeout=0.05,"
            "first_grace=0.05,term_grace=0.05);"
            "raise SystemExit(outcome.rc)"
        )
        completed = subprocess.run(child(driver), capture_output=True, timeout=5, check=False)
        self.assertEqual(completed.returncode, observer.RC_BLOCKED_CHILD_STILL_RUNNING, completed.stderr)
        result = json.loads((output / "process-result.json").read_text())
        pid = int(result["pid"])
        self.assertTrue(result["final_exact_pid_alive"])
        self.assertFalse(result["raw_logs_finalized"])
        self.assertTrue(pid_is_alive(pid))
        try:
            supervisor_exited.write_text("released\n")
            self.assertTrue(
                wait_until(
                    lambda: late_stdout in (output / "stdout.log").read_bytes()
                    and late_stderr in (output / "stderr.log").read_bytes()
                ),
                "surviving child did not retain late raw bytes after supervisor exit",
            )
            self.assertNotIn(b"BrokenPipe", (output / "stderr.log").read_bytes())
        finally:
            supervisor_exited.touch(exist_ok=True)
            cooperative_stop.write_text("stop\n")
        self.assertTrue(wait_until(lambda: not pid_is_alive(pid)), "cooperative fixture cleanup did not exit")

    def test_exact_ca_replay_is_retained_and_ineligible(self) -> None:
        ca = (
            b'ERROR: Condition "ret != noErr" is true. Returning: ""\n'
            b"   at: get_system_ca_certificates (platform/macos/os_macos.mm:1035)\n"
        )
        self.assertEqual(
            hashlib.sha256(ca).hexdigest(),
            "b44d1484f324204d488884405aedead024c019bb75f70f0852bf5b1c19905174",
        )
        incident = observer.EVIDENCE_ROOT / "tests/mechanical_snapshot_generation.txt"
        incident_bytes = incident.read_bytes()
        self.assertEqual(
            hashlib.sha256(incident_bytes).hexdigest(),
            "802f1519e91aa43b31c4153969b364e02a0eb6834e26fcd2ec3e54a4d246a3d0",
        )
        self.assertIn(ca, incident_bytes)
        code = f"import os;os.write(1,{ca!r});os.write(1,b'late PASS\\n')"
        outcome, mirrored, _ = self.run_fake(
            code, "ca-replay", required_stdout_all=(b"late PASS",)
        )
        self.assertEqual(outcome.rc, observer.RC_DIAGNOSTIC_FAILURE)
        self.assertIn(ca, mirrored)
        self.assertTrue((self.root / "ca-replay/stdout.log").read_bytes().startswith(ca))
        self.assertEqual(outcome.result["process_verdict"], "PASS")
        self.assertEqual(outcome.result["diagnostic_verdict"], "FAIL")
        self.assertFalse(outcome.result["capture_manifest_seal_eligible"])
        raw_matches = [
            match.get("raw_base64", "") for match in outcome.result["diagnostic_matches"]
        ]
        self.assertIn(
            base64.b64encode(ca).decode("ascii"),
            raw_matches,
        )

    def test_reserved_return_code_namespace_is_stable(self) -> None:
        self.assertEqual(
            [
                observer.RC_PREFLIGHT_OR_OBSERVER_INTERNAL,
                observer.RC_CHILD_NONZERO_EXIT,
                observer.RC_UNEXPECTED_SIGNAL,
                observer.RC_DIAGNOSTIC_FAILURE,
                observer.RC_TIMEOUT_GRACEFUL_STOP_COMPLETED,
                observer.RC_BLOCKED_CHILD_STILL_RUNNING,
            ],
            list(range(70, 76)),
        )

    def test_player_boot_control_is_fixed_default_disabled_and_shared_with_wm_close(self) -> None:
        player_boot = (observer.STEAM_DIR / "scripts/player/player_boot.gd").read_text()
        launch_test = (observer.STEAM_DIR / "tests/launch_surfaces/test_player_boot.gd").read_text()
        self.assertIn(observer.CONTROL_FLAG, player_boot)
        self.assertIn(observer.CONTROL_REQUEST_USER_PATH, player_boot)
        self.assertIn("SHELTER_CONTROL_QUIT\\n", player_boot)
        self.assertIn("shelter_project_quit_ack=true", player_boot)
        self.assertIn('NOTIFICATION_WM_CLOSE_REQUEST', player_boot)
        self.assertIn('_begin_graceful_shutdown("wm_close")', player_boot)
        self.assertIn('_begin_graceful_shutdown("observer_control")', player_boot)
        self.assertIn("graceful_shutdown_snapshot", launch_test)
        self.assertIn("control_enabled", launch_test)
        self.assertNotIn("GDExtension", player_boot)
        self.assertNotIn("SIG" + "TERM", player_boot)
        continue_test = (observer.STEAM_DIR / "tests/player_continue/test_player_continue.gd").read_text()
        self.assertNotIn("_commit_player_checkpoint", continue_test)
        self.assertGreaterEqual(continue_test.count("test_advance_player_to_next_checkpoint"), 3)

    def test_player_profile_failpoint_forwarding_arity_matches_store(self) -> None:
        store = (observer.STEAM_DIR / "scripts/persistence/player_profile_store.gd").read_text()
        player_boot = (observer.STEAM_DIR / "scripts/player/player_boot.gd").read_text()
        continue_test = (observer.STEAM_DIR / "tests/player_continue/test_player_continue.gd").read_text()

        signature = re.search(
            r"^func configure_test_failpoint\(([^)]*)\) -> Dictionary:",
            store,
            re.MULTILINE,
        )
        self.assertIsNotNone(signature)
        store_parameters = [
            parameter.strip()
            for parameter in signature.group(1).split(",")
            if parameter.strip()
        ]
        self.assertEqual(store_parameters, ["failpoint: String"])

        forwarded = re.findall(
            r'_store\.call\("configure_test_failpoint",\s*([^\n]+?)\) as Dictionary',
            player_boot,
        )
        self.assertEqual(len(forwarded), 3)
        self.assertTrue(all("," not in arguments for arguments in forwarded), forwarded)

        public_calls = re.findall(
            r'boot\.call\("configure_test_store_failpoint",\s*([^\n]+?)\) as Dictionary',
            continue_test,
        )
        self.assertEqual(len(public_calls), 5)
        self.assertTrue(all("," not in arguments for arguments in public_calls), public_calls)

    def test_expected_persistence_failure_seam_is_scoped_exact_and_fail_loud_by_default(self) -> None:
        runtime = (observer.STEAM_DIR / "scripts/prototypes/vertical_slice/vertical_slice_demo.gd").read_text()
        continue_test = (observer.STEAM_DIR / "tests/player_continue/test_player_continue.gd").read_text()
        seam_signature = "func test_advance_player_to_next_checkpoint_expecting_persistence_failure(max_ticks: int = 5000)"
        self.assertEqual(runtime.count(seam_signature), 1)
        seam_start = runtime.index(seam_signature)
        seam_end = runtime.index("\n\nfunc ", seam_start + len(seam_signature))
        seam = runtime[seam_start:seam_end]
        self.assertIn("test_advance_player_to_next_checkpoint(max_ticks)", seam)
        self.assertNotIn("_commit_player_checkpoint", seam)
        self.assertNotIn("_persist_staged_player_checkpoint", seam)
        self.assertIn("expected_checkpoint_persistence_failure_not_observed", seam)
        self.assertIn('observation["status"] = "expected_checkpoint_persistence_failure_observed"', seam)
        self.assertIn('observation["expectation_cleared"]', seam)
        self.assertIn("not _test_last_checkpoint_persistence_result.is_empty()", seam)
        self.assertIn("_consume_expected_test_checkpoint_persistence_failure", seam)

        commit_signature = "func _commit_player_checkpoint"
        commit_start = runtime.index(commit_signature)
        commit_end = runtime.index("\n\nfunc ", commit_start + len(commit_signature))
        commit = runtime[commit_start:commit_end]
        self.assertIn("var persistence_result := _persist_staged_player_checkpoint()", commit)
        self.assertIn("if not _test_expected_checkpoint_persistence_failure.is_empty():", commit)
        self.assertIn("_test_last_checkpoint_persistence_result = persistence_result.duplicate(true)", commit)
        self.assertIn("return persistence_result", commit)

        consumer_signature = "func _consume_expected_test_checkpoint_persistence_failure"
        consumer_start = runtime.index(consumer_signature)
        consumer_end = runtime.index("\n\nfunc ", consumer_start + len(consumer_signature))
        consumer = runtime[consumer_start:consumer_end]
        retained_result_line = "var retained_commit_result: Dictionary = commit_result.duplicate(true)"
        last_result_clear = "_test_last_checkpoint_persistence_result.clear()"
        self.assertIn(retained_result_line, consumer)
        self.assertLess(consumer.index(retained_result_line), consumer.index(last_result_clear))
        self.assertIn('retained_commit_result.get("error", "")', consumer)
        self.assertIn('retained_commit_result.get("store_result", {})', consumer)
        self.assertIn('"failure_result": retained_commit_result', consumer)
        self.assertNotRegex(consumer, r"(?<!retained_)commit_result\.get\(\"error\", \"\"\)")
        self.assertNotIn("[DEBUG-" + "d024-persistence-consumer]", runtime)
        for token in (
            '"checkpoint_persistence_failed"',
            '"injected_failure:before_validation"',
            '"before_validation"',
            '_player_checkpoint_sequence == int(armed["starting_sequence"])',
            '_player_checkpoint_barrier_failed',
            'checkpoint_kind == str(armed["expected_kind"])',
            'staged_checkpoint == (armed["expected_golden"] as Dictionary)',
            'durable_checkpoint == (armed["durable_checkpoint"] as Dictionary)',
            '_test_expected_checkpoint_persistence_failure.clear()',
        ):
            self.assertIn(token, consumer)

        handler_signature = "func _handle_player_task_completed"
        handler_start = runtime.index(handler_signature)
        handler_end = runtime.index("\n\nfunc ", handler_start + len(handler_signature))
        handler = runtime[handler_start:handler_end]
        self.assertIn(
            "if not _consume_expected_test_checkpoint_persistence_failure(checkpoint_kind, commit_result):",
            handler,
        )
        self.assertIn(
            'push_error("Player checkpoint commit failed after task: %s" % str(commit_result))',
            handler,
        )
        self.assertEqual(
            continue_test.count(
                'runtime.call("test_advance_player_to_next_checkpoint_expecting_persistence_failure", 5000)'
            ),
            3,
        )
        self.assertNotIn("_commit_player_checkpoint", continue_test)

    def test_exact_implementation_scope_has_no_hard_stop_path(self) -> None:
        scope = [
            observer.STEAM_DIR / "tools/observe-godot-process.py",
            observer.STEAM_DIR / "tests/tools/test_observe_godot_process.py",
            observer.STEAM_DIR / "tests/player_continue/test_player_continue.gd",
            observer.STEAM_DIR / "tools/capture-d024-responsive-presentation.sh",
            observer.STEAM_DIR / "scripts/player/player_boot.gd",
            observer.STEAM_DIR / "tests/launch_surfaces/test_player_boot.gd",
            observer.STEAM_DIR / "tools/validate-d024-responsive-presentation.py",
            observer.STEAM_DIR / "scripts/prototypes/vertical_slice/vertical_slice_demo.gd",
        ]
        forbidden = (
            "SIG" + "KILL",
            "SIG" + "ABRT",
            "kill " + "-9",
            "OS." + "kill(",
            "kill" + "pg(",
            "start_new_" + "session=True",
        )
        for path in scope:
            text = path.read_text()
            for token in forbidden:
                self.assertNotIn(token, text, f"forbidden hard-stop token in {path}: {token}")

    def test_nonfatal_recovery_producers_precede_fresh_verifiers(self) -> None:
        profile_wrapper = (observer.STEAM_DIR / "tools/test-player-profile-store.sh").read_text()
        self.assertLess(
            profile_wrapper.index('run_phase snapshot-create "$base" "$failpoint"'),
            profile_wrapper.index('run_phase snapshot-inspect "$base" "$failpoint" "$expected_status"'),
        )
        self.assertLess(
            profile_wrapper.index('run_phase snapshot-update "$base" "$failpoint"'),
            profile_wrapper.index('run_phase snapshot-inspect "$base" "$failpoint"'),
        )
        continue_wrapper = (observer.STEAM_DIR / "tools/test-player-continue.sh").read_text()
        for producer, verifier in (
            ('run_phase snapshot-inflight "$base" "$sequence"', 'run_phase advance "$base" "$sequence"'),
            ('run_phase snapshot-completion-beat "$base" 32', 'run_phase advance "$base" 32'),
            ('run_phase snapshot-failed-barrier "$base" "$sequence"', 'run_phase read "$base" "$sequence"'),
        ):
            producer_index = continue_wrapper.index(producer)
            self.assertIn(verifier, continue_wrapper[producer_index:])
        continue_test = (observer.STEAM_DIR / "tests/player_continue/test_player_continue.gd").read_text()
        self.assertNotIn("while " + "true", continue_test)


def dataclass_replace(value, **changes):
    import dataclasses
    return dataclasses.replace(value, **changes)


if __name__ == "__main__":
    unittest.main(verbosity=2)
