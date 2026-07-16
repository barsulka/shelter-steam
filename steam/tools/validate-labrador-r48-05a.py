#!/usr/bin/env python3
"""Fail-loud mechanical validator for source-reconciled Shelter R48-05A."""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import struct
import subprocess
import sys
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[2]
STEAM = ROOT / "steam"
PACKAGE = ROOT / "docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Art_Source_Reconciliation_Wave_v1"
BRIEF = ROOT / "docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Accepted_Art_Source_And_Labrador_H_Runtime_Integration_v1.md"
AUTHORITY = ROOT / "docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Labrador_P0_Accepted_Action_Manifest_v1.md"
PROMOTION = ROOT / "docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Art_Source_Reconciliation_Wave_v1__Approved_Promotion_Record.md"
ACCEPTANCE = ROOT / "docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Art_Source_Reconciliation_Wave_v1__PM_User_Source_Acceptance.md"
BINDING_PATH = STEAM / "resources/prototypes/vertical_slice/labrador_r48_05a_binding_v1.json"
STATIONS_PATH = STEAM / "resources/prototypes/vertical_slice/labrador_r48_05a_station_anchors_v1.json"
ADAPTER_PATH = STEAM / "scripts/prototypes/vertical_slice/labrador_visual_adapter.gd"
ADAPTER_SCENE = STEAM / "scenes/prototypes/vertical_slice/labrador_visual_adapter.tscn"
DEMO_PATH = STEAM / "scripts/prototypes/vertical_slice/vertical_slice_demo.gd"
DEMO_SCENE = STEAM / "scenes/prototypes/vertical_slice/vertical_slice_demo.tscn"
ANIMATION_PATH = STEAM / "resources/prototypes/vertical_slice/labrador_r48_05a_animation_library.tres"
TEST_PATH = STEAM / "tests/vertical_slice_visual/test_labrador_visual_binding.gd"
CAPTURE_PATH = STEAM / "tools/capture-labrador-r48-05a.sh"
AUTHORED = STEAM / "assets/prototypes/vertical_slice/authored"

PINNED = {
    BRIEF: "9fcaab17580f23b7a3d884440b802aa9c38f9181b84739bd0ba9dffcfa0159b1",
    AUTHORITY: "d8f1a9fc9226588097eb7bdfc162b6eff520ef42605b369ba25f906daa52ae56",
    PROMOTION: "72d46ee230def6028e6986943dc88e942cc8c2023813864e5c784c13caddbab5",
    ACCEPTANCE: "b10726d34f027a4052f11cf1313aa987bc7640b3e5835c116d6d8e61cc172235",
    PACKAGE / "README.md": "8b0c2c7672315453900e062ca65b551e22abcffe8094a62783c53744a2cb76b5",
    PACKAGE / "PROVENANCE.md": "8253e955def0c1766f21f1db1a71cb18556be57d1341bea0846cdfbbb4c85f80",
    PACKAGE / "REFERENCE_READBACK.md": "e5a2dfa3d488a361be3b61a4893c9372e29070f797879e9cac85e8d3a32f9cc9",
    PACKAGE / "ART_QA.md": "3405df1466d8bc821f54eae4874f43bedb384aab011315532ade32d660c88fbe",
    PACKAGE / "SOURCE_MANIFEST.json": "c825bac41a7721553eb725fb00d14c4e7aba94832ae8ab605db68624e135616b",
    PACKAGE / "QA_REPORT.json": "a772bf513be1cb251344a902d4303fa61e4805a8aa2660e96b14e4644705654d",
    PACKAGE / "INVENTORY.json": "e43ec9562333e1ad30ead7be7f83c3484214221b06a4c4f360d84037952c66c3",
    PACKAGE / "HASHES.sha256": "7abc64cc21025a08312a63a8cfd7486652854f4fdf30d12179fd072161f9600b",
}
ACTION_IDS = [
    "dog.action.idle.neutral",
    "dog.action.wait.calm",
    "dog.action.locomotion.start",
    "dog.action.locomotion.walk_empty",
    "dog.action.locomotion.stop",
    "dog.action.locomotion.turn",
    "dog.action.interaction.approach_target",
    "dog.action.interaction.contact_align",
    "dog.action.station.work_loop",
    "dog.activity.delivery.help_kitchen",
    "dog.activity.delivery.pack_food_bag",
    "dog.activity.delivery.pack_carefully_labrador",
]
WORLD_INDICES = [*range(10), *range(11, 17)]
POSE_IDS = [
    "ambient_attentive_left", "ambient_attentive_right", "approach_left", "approach_right",
    "contact_align_left", "contact_align_right", "idle_neutral_right", "kitchen_work_left",
    "kitchen_work_right", "locomotion_start_left", "locomotion_start_right", "locomotion_stop_left",
    "locomotion_stop_right", "packing_focus_left", "packing_focus_right", "packing_work_left",
    "packing_work_right", "turn_left_to_right_mid", "turn_right_to_left_mid", "wait_calm_left",
    "walk_support_a_left", "walk_support_a_right", "walk_support_b_left", "walk_support_b_right",
]
NO_TOUCH = [
    "steam/scripts/player/player_boot.gd",
    "steam/scenes/player/player_boot.tscn",
    "steam/scripts/player/player_checkpoint_codec.gd",
    "steam/scripts/persistence",
    "steam/scripts/game_systems",
    "steam/resources/game_systems/fixtures",
    "steam/project.godot",
    "steam/play.sh",
    "steam/dev.sh",
    "steam/tools/dev-vertical-slice.sh",
]


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def load_json(path: Path) -> dict[str, Any]:
    value = json.loads(path.read_text(encoding="utf-8"))
    if not isinstance(value, dict):
        raise ValueError(f"top-level JSON is not an object: {path}")
    return value


def png_size(path: Path) -> tuple[int, int]:
    with path.open("rb") as handle:
        header = handle.read(24)
    if header[:8] != b"\x89PNG\r\n\x1a\n" or header[12:16] != b"IHDR":
        raise ValueError(f"invalid PNG header: {path}")
    return struct.unpack(">II", header[16:24])


def function_body(text: str, name: str) -> str:
    match = re.search(rf"(?m)^func {re.escape(name)}\([^\n]*\) -> [^\n]+:\n", text)
    if not match:
        return ""
    rest = text[match.end():]
    end = re.search(r"(?m)^func ", rest)
    return rest[:end.start()] if end else rest


def close(actual: Any, expected: float, tolerance: float = 1e-12) -> bool:
    try:
        return abs(float(actual) - expected) <= tolerance
    except (TypeError, ValueError):
        return False


def validate() -> dict[str, Any]:
    checks: list[str] = []
    errors: list[str] = []
    warnings: list[str] = []

    def expect(condition: bool, label: str) -> None:
        (checks if condition else errors).append(label)

    for path, expected in PINNED.items():
        expect(path.is_file() and sha256(path) == expected, f"pinned SHA-256: {path.relative_to(ROOT)}")

    package_files = [path for path in PACKAGE.rglob("*") if path.is_file()]
    inventory = json.loads((PACKAGE / "INVENTORY.json").read_text(encoding="utf-8"))
    qa = load_json(PACKAGE / "QA_REPORT.json")
    expect(len(package_files) == 606, "frozen package contains exactly 606 files")
    expect(len(inventory) == 605, "frozen inventory contains exactly 605 ledger entries")
    expect(qa.get("checks_total") == 157 and qa.get("checks_pass") == 157 and qa.get("checks_fail") == 0, "frozen QA is exact 157/157 PASS")
    expect(not any(path.name == "__pycache__" or path.suffix == ".pyc" for path in PACKAGE.rglob("*")), "frozen package has no pycache/pyc")
    source_manifest = load_json(PACKAGE / "SOURCE_MANIFEST.json")
    expect(source_manifest.get("sheet_a_reuse") == "ZERO", "Sheet A reuse is ZERO")
    ledger = subprocess.run(["shasum", "-a", "256", "-c", "HASHES.sha256"], cwd=PACKAGE, text=True, capture_output=True, check=False)
    expect(ledger.returncode == 0 and ledger.stdout.count(": OK") == 605, "frozen HASHES ledger verifies 605/605")

    runtime_pngs = sorted(AUTHORED.rglob("*.png"))
    sidecars = sorted(AUTHORED.rglob("*.png.import"))
    expect(len(runtime_pngs) == 41, "authored runtime contains exactly 41 PNG")
    expect(len(sidecars) == 41, "authored runtime contains exactly 41 tracked import sidecars")
    expect(all('importer="texture"' in path.read_text(encoding="utf-8") and '[remap]' in path.read_text(encoding="utf-8") for path in sidecars), "all 41 sidecars are Godot texture imports")

    pairs: list[tuple[Path, Path]] = []
    expected_world: list[str] = []
    for source in sorted((PACKAGE / "source/world/layers").glob("*.png")):
        index = int(source.name.split("__", 1)[0])
        if index == 10:
            continue
        expected_world.append(source.name)
        pairs.append((source, AUTHORED / "world/layers" / source.name))
    actual_world = sorted(path.name for path in (AUTHORED / "world/layers").glob("*.png"))
    expect(len(expected_world) == 16 and actual_world == expected_world, "exact static world layers 00-09,11-16")
    expect(all(png_size(runtime) == (2992, 224) for _, runtime in pairs if runtime.is_file()), "all 16 world layers are 2992x224")
    bicycle_source = PACKAGE / "exports/world/assets/bicycle.png"
    bicycle_runtime = AUTHORED / "world/assets/bicycle.png"
    pairs.append((bicycle_source, bicycle_runtime))
    expect(bicycle_runtime.is_file() and sha256(bicycle_runtime) == "211b6c12774bf1170bf16c108e6dbada2d35a8da69fecb8656508e85695756c5", "standalone Bicycle exact SHA-256")
    for pose in POSE_IDS:
        source = PACKAGE / "exports/labrador/poses" / pose / "identity_rgba.png"
        runtime = AUTHORED / "dogs/labrador_intro/poses" / pose / "identity_rgba.png"
        pairs.append((source, runtime))
    actual_poses = sorted(path.parent.name for path in (AUTHORED / "dogs/labrador_intro/poses").glob("*/identity_rgba.png"))
    expect(actual_poses == sorted(POSE_IDS), "exact 24 Labrador identity composites")
    expect(all(png_size(runtime) == (512, 320) for _, runtime in pairs[17:] if runtime.is_file()), "all 24 Labrador composites are 512x320")
    expect(len(pairs) == 41 and all(source.is_file() and runtime.is_file() and sha256(source) == sha256(runtime) for source, runtime in pairs), "source-to-runtime equality is exact for all 41 PNG")
    mapping = [{"source": str(source.relative_to(ROOT)), "runtime": str(runtime.relative_to(ROOT)), "sha256": sha256(runtime) if runtime.is_file() else ""} for source, runtime in pairs]

    forbidden_layer_files = [path for path in AUTHORED.rglob("*") if re.match(r"10__.*\.png(?:\.import)?$", path.name)]
    expect(not forbidden_layer_files, "layer10 is not imported into authored runtime")
    bicycle_files = [path for path in AUTHORED.rglob("*.png") if "bicycle" in path.name.lower()]
    expect(bicycle_files == [bicycle_runtime], "authored runtime contains exactly one standalone Bicycle")

    binding = load_json(BINDING_PATH)
    stations = load_json(STATIONS_PATH)
    binding_actions = [item.get("id") for item in binding.get("actions", []) if isinstance(item, dict)]
    expect(binding_actions == ACTION_IDS, "binding retains exact ordered 12 semantic action rows")
    selector_h_authority = binding.get("current_selector_h_authority", {})
    expect(
        selector_h_authority.get("path") == str(AUTHORITY.relative_to(ROOT))
        and selector_h_authority.get("sha256") == PINNED[AUTHORITY]
        and selector_h_authority.get("exact_action_rows") == ACTION_IDS
        and selector_h_authority.get("selector_h_row_additions") == 0,
        "binding retains current selector-H authority path/SHA and exact 12-row overlay",
    )
    expect(binding.get("runtime_authority") == "godot_state" and binding.get("presentation_state") == "derived_non_persisted", "binding preserves Godot authority and derived presentation")
    coordinates = binding.get("coordinates", {})
    expect(coordinates.get("runtime_world_width") == 1740.0 and coordinates.get("authored_runtime_world_width") == 1740.0 and coordinates.get("source_world_width_px") == 2992.0, "binding records exact source/runtime widths")
    expect(close(coordinates.get("source_world_to_runtime"), 1740.0 / 2992.0), "binding records exact 1740/2992 coefficient")
    expect(coordinates.get("labrador_runtime_scale") == 0.24 and coordinates.get("negative_scale_allowed") is False, "binding records positive Labrador 0.24 and forbids mirroring")
    assets = binding.get("assets", {})
    expect(assets.get("runtime_png_count") == 41 and assets.get("runtime_import_sidecar_count") == 41, "binding records exact 41+41 topology")
    selector_h = binding.get("selector_plan", {}).get("H", {})
    expect(selector_h.get("semantic_action_rows_added") == 0 and selector_h.get("derived_non_persisted") is True and selector_h.get("gameplay_output_count") == 0, "selector H is derived, non-persisted and zero-output")
    expect(selector_h.get("positive_durable_cursors") == [1, 18, 33], "selector H exact durable cursors")
    expect(selector_h.get("route_runtime_units") == [279.144385026738, 1384.090909090909], "selector H exact converted route")
    expect(selector_h.get("walk_cycle_count_per_traverse") == 19 and close(selector_h.get("cycle_distance_runtime_units"), 58.155080213904) and close(selector_h.get("speed_runtime_units_per_second"), 70.920829529151), "selector H exact cadence")

    expect(stations.get("runtime_authority") == "godot_state" and close(stations.get("source_world_to_runtime"), 1740.0 / 2992.0), "station record preserves authority and exact coefficient")
    centers = stations.get("anchor_centers", {})
    expected_centers = {
        "object.road_sign": (129.5, 75.310828877005),
        "transport.basket_bicycle": (300.0, 174.465240641711),
        "object.storage": (610.5, 355.036764705882),
        "object.kitchen": (1335.5, 776.661096256684),
        "object.packing_table": (1760.0, 1023.529411764706),
        "object.delivery_van_endpoint": (2399.5, 1395.431149732620),
    }
    expect(all(close(centers.get(key, {}).get("source_px"), source) and close(centers.get(key, {}).get("runtime_units"), runtime) for key, (source, runtime) in expected_centers.items()), "all six anchor centers store source_px and exact runtime_units")
    expected_roots = {
        ("visual_anchor.kitchen", "from_left_facing_right"): [(1073.0,624.004010695187),(1194.0,694.371657754011),(1198.0,696.697860962567),(1073.0,624.004010695187)],
        ("visual_anchor.kitchen", "from_right_facing_left"): [(1598.0,929.318181818182),(1475.0,857.787433155080),(1471.0,855.461229946524),(1598.0,929.318181818182)],
        ("visual_anchor.packing_table", "from_left_facing_right"): [(1522.0,885.120320855615),(1619.0,941.530748663102),(1623.0,943.856951871658),(1522.0,885.120320855615)],
        ("visual_anchor.packing_table", "from_right_facing_left"): [(1998.0,1161.938502673797),(1900.0,1104.946524064171),(1896.0,1102.620320855615),(1998.0,1161.938502673797)],
    }
    visual = stations.get("visual_anchors", {})
    roots_ok = True
    for (anchor, side), values in expected_roots.items():
        record = visual.get(anchor, {}).get(side, {})
        for field, (source, runtime) in zip(("approach", "contact", "work", "exit"), values):
            roots_ok &= close(record.get(field, {}).get("source_px"), source) and close(record.get(field, {}).get("runtime_units"), runtime)
    expect(roots_ok, "Kitchen/Packing both-side approach/contact/work/exit roots are exact")
    expect(stations.get("static_decorative_only", {}).get("world_layer_index") == 12 and stations.get("static_decorative_only", {}).get("station_or_task_authority") is False, "Mill layer12 is static decorative with zero authority")
    expect(stations.get("forbidden_runtime_semantics") == ["pickup", "attach", "carry", "place", "detach"], "station record retains exact forbidden transfer list")

    adapter_text = ADAPTER_PATH.read_text(encoding="utf-8")
    scene_text = ADAPTER_SCENE.read_text(encoding="utf-8")
    demo_text = DEMO_PATH.read_text(encoding="utf-8")
    demo_scene_text = DEMO_SCENE.read_text(encoding="utf-8")
    animation_text = ANIMATION_PATH.read_text(encoding="utf-8")
    test_text = TEST_PATH.read_text(encoding="utf-8")
    capture_text = CAPTURE_PATH.read_text(encoding="utf-8")
    expect(scene_text.count('type="AnimationPlayer"') == 4, "adapter retains one base and three additive AnimationPlayers")
    expect(demo_scene_text.count('name="LabradorVisualAdapter"') == 1 and demo_text.count('"labrador_intro": {') == 1, "one runtime Labrador definition and one adapter instance")
    expect("scale.x" not in adapter_text and "Vector2(-" not in scene_text, "no negative-scale facing shortcut")
    expect("_emit_event(" not in adapter_text and "complete_cooking(" not in adapter_text and "complete_packing(" not in adapter_text, "adapter emits no gameplay output")
    expect('LEGACY_UNBOUND_TASKS := ["UnloadTask", "CarryTask", "LoadVanTask"]' in adapter_text, "exact legacy_unbound lane remains")
    expect("_exact_h_gate" in adapter_text and "cancel_h_for_player_gate" in adapter_text and "H_CYCLE_COUNT := 19" in adapter_text, "adapter contains exact H gate/cancel/cadence")
    expect("semantic_selector_outside_A_to_H" in adapter_text, "unknown selector fails closed outside A-H")
    expect('const WORLD_WIDTH := 1740.0' in demo_text and 'const AUTHORED_WORLD_WIDTH := 1740.0' in demo_text and 'const SOURCE_WORLD_WIDTH := 2992.0' in demo_text, "demo records exact runtime/source world widths")
    expect('"basket_bicycle": "res://assets/prototypes/vertical_slice/authored/world/assets/bicycle.png"' in demo_text and close(re.search(r"var _transport_x := ([0-9.]+)", demo_text).group(1) if re.search(r"var _transport_x := ([0-9.]+)", demo_text) else None, 174.465240641711), "single Bicycle slot uses authored texture and exact parked placement")
    expect("Forbidden authored world layer 10 present" in demo_text, "runtime loader fails loud on layer10")
    draw = function_body(demo_text, "_draw")
    draw_order = ["_draw_authored_world_back", "_draw_transport", "_draw_authored_world_middle", "_draw_dog_action_lanes", "_draw_dogs", "_draw_authored_world_front", "_draw_resource_tokens", "_draw_first_day_readability_cues", "_draw_world_state_labels"]
    positions = [draw.find(name) for name in draw_order]
    expect(all(position >= 0 for position in positions) and positions == sorted(positions), "parent custom draw preserves exact single-lane z order")
    expect("_draw_world_anchors" not in draw and "_draw_non_authored_corridor_tail" not in draw and "_draw_packing_front_span_underlay" not in draw, "old duplicate anchors/tail/mask lanes are not rendered")
    expect("_authored_labrador_poses" in demo_text and "identity_rgba.png" in demo_text and "_authored_labrador_layers" not in demo_text, "demo renders accepted identity composites only")
    expect("_draw_dog(\"labrador_intro\"" in demo_text and 'elif lane == "legacy_unbound"' in demo_text, "one Labrador slot remains visible in authored or legacy lane")
    portable = function_body(demo_text, "_runtime_portable_state")
    expect("labrador_visual" not in portable and "presentation" not in portable, "H/presentation state is not persisted")
    track_paths = set(re.findall(r'tracks/\d+/path = NodePath\("\.:(.*?)"\)', animation_text))
    expect(track_paths == {"base_pose", "blink_amount", "tail_rotation", "focus_pose"}, "animation library tracks presentation properties only")
    expect("_test_h_matrix" in test_text and "H retry/recovery" in test_text and "selectors=A-H cursors=33" in test_text, "Godot test contains exact H and 33-cursor normal-path matrix")
    expect("SOURCE_RECONCILED_RUNTIME_CAPTURE_v1" in capture_text and "v1/v2/v3/v4/v5 capture packs are immutable" in capture_text, "capture helper targets new immutable source-reconciled pack and guards history")

    no_touch = subprocess.run(["git", "status", "--porcelain", "--", *NO_TOUCH], cwd=ROOT, text=True, capture_output=True, check=False)
    expect(no_touch.returncode == 0 and not no_touch.stdout.strip(), "all explicit no-touch implementation paths remain clean")

    return {
        "validator": "validate-labrador-r48-05a",
        "status": "PASS" if not errors else "ERROR",
        "stop_code": None if not errors else "INVALID_R48_05A_SOURCE_RECONCILED_BINDING",
        "check_count": len(checks),
        "checks": checks,
        "errors": errors,
        "warnings": warnings,
        "source_to_runtime_count": len(mapping),
        "source_to_runtime": mapping,
        "runtime_png_count": len(runtime_pngs),
        "godot_sidecar_count": len(sidecars),
        "frozen_ledger_ok_count": ledger.stdout.count(": OK"),
        "mutation_performed": False,
        "visual_approval": "NOT_EVALUATED",
        "runtime_art_pass": False,
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--json", action="store_true")
    args = parser.parse_args()
    try:
        report = validate()
    except Exception as exc:  # fail loud with stable stop code
        report = {
            "validator": "validate-labrador-r48-05a",
            "status": "ERROR",
            "stop_code": "INVALID_R48_05A_VALIDATOR_EXCEPTION",
            "errors": [f"{type(exc).__name__}: {exc}"],
            "check_count": 0,
            "warnings": [],
            "mutation_performed": False,
            "visual_approval": "NOT_EVALUATED",
            "runtime_art_pass": False,
        }
    if args.json:
        print(json.dumps(report, ensure_ascii=False, indent=2, sort_keys=True))
    else:
        print(f"{report['status']}: {report['validator']} ({report.get('check_count', 0)} checks)")
        for warning in report.get("warnings", []):
            print(f"WARN: {warning}")
        for error in report.get("errors", []):
            print(f"ERROR: {error}")
    return 0 if report["status"] == "PASS" else 3


if __name__ == "__main__":
    sys.exit(main())
