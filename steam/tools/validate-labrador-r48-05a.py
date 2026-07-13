#!/usr/bin/env python3
"""Read-only mechanical validator for bounded Shelter R48-05A."""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import subprocess
import sys
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[2]
STEAM = ROOT / "steam"
PACKAGE = ROOT / "docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Playable_World_Labrador_Source_Package_v1"
BINDING_PATH = STEAM / "resources/prototypes/vertical_slice/labrador_r48_05a_binding_v1.json"
STATIONS_PATH = STEAM / "resources/prototypes/vertical_slice/labrador_r48_05a_station_anchors_v1.json"
ADAPTER_PATH = STEAM / "scripts/prototypes/vertical_slice/labrador_visual_adapter.gd"
ADAPTER_SCENE = STEAM / "scenes/prototypes/vertical_slice/labrador_visual_adapter.tscn"
DEMO_PATH = STEAM / "scripts/prototypes/vertical_slice/vertical_slice_demo.gd"
DEMO_SCENE = STEAM / "scenes/prototypes/vertical_slice/vertical_slice_demo.tscn"
ANIMATION_PATH = STEAM / "resources/prototypes/vertical_slice/labrador_r48_05a_animation_library.tres"
AUTHORITY_PATH = ROOT / "docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Labrador_P0_Accepted_Action_Manifest_v1.md"
AUTHORITY_SHA256 = "afedb0185cff0c56963e566ff846a479437bf37950d8b38bc84380781015b3b8"

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
]


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def load_json(path: Path) -> dict[str, Any]:
    with path.open("r", encoding="utf-8") as handle:
        value = json.load(handle)
    if not isinstance(value, dict):
        raise ValueError(f"top-level JSON is not an object: {path}")
    return value


def function_body(text: str, function_name: str) -> str:
    match = re.search(rf"(?m)^func {re.escape(function_name)}\([^\n]*\) -> [^\n]+:\n", text)
    if match is None:
        return ""
    rest = text[match.end():]
    end = re.search(r"(?m)^func ", rest)
    return rest[: end.start()] if end else rest


def validate() -> dict[str, Any]:
    errors: list[str] = []
    warnings: list[str] = []
    checks: list[str] = []

    def expect(condition: bool, label: str) -> None:
        if condition:
            checks.append(label)
        else:
            errors.append(label)

    required_files = [BINDING_PATH, STATIONS_PATH, ADAPTER_PATH, ADAPTER_SCENE, DEMO_PATH, DEMO_SCENE, ANIMATION_PATH]
    required_files.extend([
        STEAM / "tests/vertical_slice_visual/labrador_visual_test_runner.tscn",
        STEAM / "tests/vertical_slice_visual/test_labrador_visual_binding.gd",
        STEAM / "tools/capture-labrador-r48-05a.sh",
    ])
    for path in required_files:
        expect(path.is_file(), f"required file exists: {path.relative_to(ROOT)}")

    world_source = PACKAGE / "exports/world/layers"
    world_runtime = STEAM / "assets/prototypes/vertical_slice/authored/world/layers"
    expected_world = sorted(path.name for path in world_source.glob("*.png") if not path.name.startswith("14__"))
    actual_world = sorted(path.name for path in world_runtime.glob("*.png"))
    expect(len(expected_world) == 14 and actual_world == expected_world, "exact 14 world PNG subset")
    source_runtime_pairs: list[tuple[Path, Path]] = [(world_source / name, world_runtime / name) for name in expected_world]

    lab_runtime_root = STEAM / "assets/prototypes/vertical_slice/authored/dogs/labrador_intro"
    expected_lab_count = 0
    for facing in ("right", "left", "turn_mid"):
        source_dir = PACKAGE / f"exports/labrador/{facing}/layers"
        runtime_dir = lab_runtime_root / f"{facing}/layers"
        expected = sorted(path.name for path in source_dir.glob("*.png"))
        actual = sorted(path.name for path in runtime_dir.glob("*.png"))
        expected_lab_count += len(expected)
        expect(len(expected) == 16 and actual == expected, f"exact 16 Labrador {facing} layers")
        source_runtime_pairs.extend((source_dir / name, runtime_dir / name) for name in expected)
    expect(expected_lab_count == 48, "exact 48 Labrador PNG subset")
    expect(all(sha256(source) == sha256(runtime) for source, runtime in source_runtime_pairs), "all 62 runtime PNG hashes equal source exports")

    runtime_pngs = sorted((STEAM / "assets/prototypes/vertical_slice/authored").rglob("*.png"))
    sidecars = sorted((STEAM / "assets/prototypes/vertical_slice/authored").rglob("*.png.import"))
    expect(len(runtime_pngs) == 62, "runtime authored tree contains exactly 62 PNG")
    expect(len(sidecars) == 62, "runtime authored tree contains exactly 62 Godot sidecars")
    expect(all('[remap]' in path.read_text(encoding="utf-8") and 'importer="texture"' in path.read_text(encoding="utf-8") for path in sidecars), "all sidecars are verified Godot texture imports")
    expect(not any("composite" in path.name or "silhouette" in path.name or "guide" in path.name for path in runtime_pngs), "no composite/silhouette/guide runtime imports")

    try:
        binding = load_json(BINDING_PATH)
        stations = load_json(STATIONS_PATH)
        accepted = load_json(PACKAGE / "manifests/accepted_action_scope.json")
    except (OSError, ValueError, json.JSONDecodeError) as exc:
        errors.append(f"JSON read: {exc}")
        binding, stations, accepted = {}, {}, {}

    binding_actions = [entry.get("id") for entry in binding.get("actions", []) if isinstance(entry, dict)]
    accepted_actions = [entry.get("id") for entry in accepted.get("actions", []) if isinstance(entry, dict)]
    expect(binding_actions == ACTION_IDS == accepted_actions, "binding and external ledger contain exact ordered 12 actions")
    expect(binding.get("runtime_authority") == "godot_state", "top-level runtime authority is godot_state")
    runtime = binding.get("runtime", {}) if isinstance(binding.get("runtime"), dict) else {}
    expect(runtime.get("runtime_authority") == "godot_state", "runtime block authority is godot_state")
    bindings = runtime.get("bindings", []) if isinstance(runtime.get("bindings"), list) else []
    expect(len(bindings) == 12 and {entry.get("action_id") for entry in bindings if isinstance(entry, dict)} == set(ACTION_IDS), "one runtime binding per accepted action")
    expect(not any(str(entry.get("action_id", "")).lower().find("carry") >= 0 for entry in bindings if isinstance(entry, dict)), "no transfer action binding")
    expect(stations.get("runtime_authority") == "godot_state", "station record is read-only godot_state binding")
    visual_anchors = stations.get("visual_anchors", {}) if isinstance(stations.get("visual_anchors"), dict) else {}
    expect(bool(visual_anchors) and all(not bool(value.get("transfer_semantics", True)) for value in visual_anchors.values() if isinstance(value, dict)), "all visual anchors declare no transfer semantics")
    expect(stations.get("forbidden_runtime_semantics") == ["pickup", "attach", "carry", "place", "detach"], "exact transfer forbidden list")

    authority_hash = sha256(AUTHORITY_PATH) if AUTHORITY_PATH.is_file() else ""
    expect(authority_hash == AUTHORITY_SHA256, "activation external-authority SHA-256 matches afedb018…")

    adapter_text = ADAPTER_PATH.read_text(encoding="utf-8") if ADAPTER_PATH.is_file() else ""
    scene_text = ADAPTER_SCENE.read_text(encoding="utf-8") if ADAPTER_SCENE.is_file() else ""
    demo_text = DEMO_PATH.read_text(encoding="utf-8") if DEMO_PATH.is_file() else ""
    demo_scene_text = DEMO_SCENE.read_text(encoding="utf-8") if DEMO_SCENE.is_file() else ""
    animation_text = ANIMATION_PATH.read_text(encoding="utf-8") if ANIMATION_PATH.is_file() else ""
    test_text = (STEAM / "tests/vertical_slice_visual/test_labrador_visual_binding.gd").read_text(encoding="utf-8")
    capture_tool_text = (STEAM / "tools/capture-labrador-r48-05a.sh").read_text(encoding="utf-8")

    expect(scene_text.count('type="AnimationPlayer"') == 4, "one base and three additive AnimationPlayers")
    expect(demo_scene_text.count('name="LabradorVisualAdapter"') == 1, "exactly one Labrador adapter instance")
    expect(demo_text.count('"labrador_intro": {') == 1, "exactly one Labrador runtime definition")
    expect("scale.x" not in adapter_text and "Vector2(-" not in scene_text, "no negative-scale facing path")
    expect("_emit_event(" not in adapter_text and "complete_cooking(" not in adapter_text and "complete_packing(" not in adapter_text, "adapter has no gameplay event/output calls")
    expect("LEGACY_UNBOUND_TASKS := [\"UnloadTask\", \"CarryTask\", \"LoadVanTask\"]" in adapter_text, "exact legacy_unbound task lane")
    expect("semantic_selector_outside_A_to_G" in adapter_text, "unknown selector fails closed")
    expect('"source_px_to_world_unit": 0.24' in adapter_text and "LABRADOR_SOURCE_TO_WORLD := 0.24" in demo_text, "uniform positive Labrador scale uses the Art-owner accepted 0.24 envelope")
    expect("smoothstep(0.55, 1.0, progress)" not in adapter_text and '_station_value(station_id, "approach")' in adapter_text and '_station_value(station_id, "contact")' in adapter_text, "approach root motion is distributed across the phrase")
    expect("TURN_MID_BEGIN_PROGRESS" in adapter_text and "TURN_MID_END_PROGRESS" in adapter_text and "_task_turn_had_required" in adapter_text, "physical turns hold authored midpoint with task-local root lock")
    expect(stations.get("source_px_to_world_unit") == 0.24, "station source projection uses uniform 0.24")
    kitchen_anchor = visual_anchors.get("visual_anchor.kitchen", {}) if isinstance(visual_anchors.get("visual_anchor.kitchen"), dict) else {}
    packing_anchor = visual_anchors.get("visual_anchor.packing_table", {}) if isinstance(visual_anchors.get("visual_anchor.packing_table"), dict) else {}
    expect([kitchen_anchor.get(key) for key in ("approach_world_offset", "contact_world_offset", "work_world_offset")] == [104.16, 62.88, 54.24], "Kitchen starts from exact 0.24 source-derived numeric anchors")
    expect([packing_anchor.get(key) for key in ("approach_world_offset", "contact_world_offset", "work_world_offset")] == [104.16, 60.0, 50.88], "Packing starts from exact 0.24 source-derived numeric anchors")
    qa = binding.get("qa", {}) if isinstance(binding.get("qa"), dict) else {}
    expect(str(qa.get("evidence_root", "")).endswith("STEAM_R48_05A_LABRADOR_RUNTIME_CAPTURE_v5"), "binding points to correction evidence v5")

    track_paths = set(re.findall(r'tracks/\d+/path = NodePath\("\.:(.*?)"\)', animation_text))
    expect(track_paths == {"base_pose", "blink_amount", "tail_rotation", "focus_pose"}, "animation tracks own only four declared presentation properties")
    expect(not any(term in animation_text for term in ["world_x", "task_status", "checkpoint", "attach", "detach"]), "animation library contains no gameplay/persistence/transfer tracks")

    draw_body = function_body(demo_text, "_draw")
    draw_order = [
        "_draw_authored_world_back",
        "_draw_non_authored_corridor_tail",
        "_draw_world_anchors",
        "_draw_transport",
        "_draw_dog_action_lanes",
        "_draw_packing_front_span_underlay",
        "_draw_dogs",
        "_draw_authored_world_front",
        "_draw_resource_tokens",
        "_draw_first_day_readability_cues",
        "_draw_world_state_labels",
    ]
    positions = [draw_body.find(name) for name in draw_order]
    expect(all(position >= 0 for position in positions) and positions == sorted(positions), "parent draw slot preserves exact R48-05A z order")
    expect("_draw_ground" not in draw_body and "_draw_route_path" not in draw_body, "player draw uses authored world instead of primitive ground/path")
    expect("AUTHORED_WORLD_WIDTH := 1536.0" in demo_text and 'if _view_mode == "player_prototype"' in demo_text and "_viewport_size().x / WORLD_WIDTH" in demo_text, "player layout fits corridor x=0..1740 across full width")
    expect("authored_tail_claim" in demo_text and "source canvas ends at x=1536" in demo_text, "non-authored 1536..1740 tail is explicit and unstretched")
    expect("max_interval_ratio <= 0.35" in test_text and '"general":{"216":80,"144":52,"96":35}' in test_text and '"kitchen_E":{"216":74,"144":49,"96":33}' in test_text and '"packing_F":{"216":79,"144":53,"96":35}' in test_text and '"focus_G":{"216":73,"144":49,"96":32}' in test_text, "tests enforce motion distribution and exact Art-owned state-specific height floors")
    expect('"minimum_top_bottom_margins_px"' in test_text and "_bounds_with_margins" in test_text and '"complete_bbox_inside_frame"' in test_text, "capture enforces complete native/216/144/96 bbox and exact top+bottom margins")
    expect("_front_span_overlap_readback" in test_text and "_capture_packing_mask_audit" in test_text and '"muzzle_gap_lte_4_px"' in test_text, "capture measures both-side contact and selector-scoped source-alpha mask ownership")
    expect("packing_front_span_mask_active" in adapter_text and "_draw_packing_front_span_underlay" in demo_text and "_front_span_regions_outside_mask" in demo_text, "derived Packing mask uses parent-owned local source segmentation")
    expect("PACKING_FRONT_SPAN_MASK_SELECTORS := [\"D\", \"F\", \"G\"]" in adapter_text and "PACKING_FRONT_SPAN_MASK_SELECTORS := [\"D\", \"F\", \"G\", \"EXIT\"]" in demo_text, "Packing mask fails closed to exact contact selectors and contact-held exit")
    expect("STEAM_R48_05A_LABRADOR_RUNTIME_CAPTURE_v5" in capture_tool_text and "v1/v2/v3/v4 capture packs are immutable" in capture_tool_text, "capture helper defaults to v5 and guards immutable v1/v2/v3/v4")
    portable_body = function_body(demo_text, "_runtime_portable_state")
    expect("labrador_visual" not in portable_body and "presentation" not in portable_body, "adapter presentation state is not persisted")

    status = subprocess.run(
        ["git", "status", "--porcelain", "--", *NO_TOUCH],
        cwd=ROOT,
        text=True,
        capture_output=True,
        check=False,
    )
    expect(status.returncode == 0 and not status.stdout.strip(), "all explicit no-touch implementation paths remain clean")

    if not errors:
        result_status = "PASS"
    else:
        result_status = "ERROR"
    return {
        "validator": "validate-labrador-r48-05a",
        "status": result_status,
        "stop_code": None if not errors else "INVALID_R48_05A_BINDING",
        "check_count": len(checks),
        "checks": checks,
        "errors": errors,
        "warnings": warnings,
        "source_authority_sha256": authority_hash,
        "binding_sha256": sha256(BINDING_PATH) if BINDING_PATH.is_file() else "",
        "station_binding_sha256": sha256(STATIONS_PATH) if STATIONS_PATH.is_file() else "",
        "runtime_png_count": len(runtime_pngs),
        "godot_sidecar_count": len(sidecars),
        "mutation_performed": False,
        "visual_approval": "NOT_EVALUATED",
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--json", action="store_true")
    args = parser.parse_args()
    report = validate()
    if args.json:
        print(json.dumps(report, ensure_ascii=False, indent=2, sort_keys=True))
    else:
        print(f"{report['status']}: {report['validator']} ({report['check_count']} checks)")
        for warning in report["warnings"]:
            print(f"WARN: {warning}")
        for error in report["errors"]:
            print(f"ERROR: {error}")
    return 0 if report["status"] == "PASS" else 3


if __name__ == "__main__":
    sys.exit(main())
