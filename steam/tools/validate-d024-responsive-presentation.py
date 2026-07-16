#!/usr/bin/env python3
"""Fail-loud mechanical validator for the accepted D-024 runtime correction."""

from __future__ import annotations

import argparse
import hashlib
import json
import struct
import sys
from pathlib import Path


REPO = Path(__file__).resolve().parents[2]
STEAM = REPO / "steam"
DOCS = REPO / "docs" / "drive" / "Shelter"
PACKAGE = DOCS / "03_DESIGN" / "04_DELIVERABLES" / "STEAM_DESKTOP__Art_Source_Responsive_Meadow_Left_Cluster_Amendment_v1"
AUTHORED = STEAM / "assets" / "prototypes" / "vertical_slice" / "authored"
RESPONSIVE = AUTHORED / "world" / "responsive"
DEMO = STEAM / "scripts" / "prototypes" / "vertical_slice" / "vertical_slice_demo.gd"
CONFIG = STEAM / "resources" / "prototypes" / "vertical_slice" / "d024_responsive_presentation_v1.json"
BRIEF = DOCS / "04_DEVELOPMENT" / "STEAM_DESKTOP__Codex_Brief__D024_Responsive_Meadow_Marker_And_Player_Presentation_Cleanup_v1.md"

AUTHORITY_CONTRACT_SCHEME = "raw-bytes-between-markers-v1"
AUTHORITY_CONTRACT_SHA256 = "4f956a077d0a93575ef7b518fd0aa9fb409392a08fd4a48190364795bc9b5cbf"
AUTHORITY_BEGIN_MARKER = b"D024_AUTHORITY_CONTRACT_BEGIN"
AUTHORITY_END_MARKER = b"D024_AUTHORITY_CONTRACT_END"

PINS = {
    DOCS / "03_DESIGN" / "04_DELIVERABLES" / "STEAM_DESKTOP__Art_Source_Responsive_Meadow_Left_Cluster_Amendment_v1__PM_User_Source_Acceptance.md": "eab92cb51a84361ba48036fed760ebbcdbfac59afe8b3b7d824dd42e84856079",
    PACKAGE / "HASHES.sha256": "220a9532f54b8f8ae813f32ac02ef28e35a5d2bde6ded318ecb08a43319e43bf",
    DOCS / "04_DEVELOPMENT" / "STEAM_DESKTOP__Labrador_P0_Accepted_Action_Manifest_v1.md": "d8f1a9fc9226588097eb7bdfc162b6eff520ef42605b369ba25f906daa52ae56",
}

SOURCE_COPIES = {
    PACKAGE / "exports" / "meadow" / "meadow_tile_rgba_748x224.png": (
        RESPONSIVE / "meadow_tile_rgba_748x224.png",
        "1cb5845141ad80beba303bc6e0805f10954310eb783a9dfb5ac5f1354e144d40",
        (748, 224, 6),
    ),
    PACKAGE / "exports" / "boundary_marker" / "fence_boundary_marker_rgba.png": (
        RESPONSIVE / "fence_boundary_marker_rgba.png",
        "e0237a29119a318cb7b5acb431ed17e7b70d7da3d5386883b335d16ba7416036",
        (174, 106, 6),
    ),
}


class ValidationError(RuntimeError):
    pass


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def require(condition: bool, message: str) -> None:
    if not condition:
        raise ValidationError(message)


def authority_marker_offsets(raw: bytes, marker: bytes) -> tuple[int, int]:
    require(raw.count(marker) == 1, f"authority marker count invalid: {marker.decode()}")
    marker_line = b"<!-- " + marker + b" -->"
    start = raw.find(marker_line)
    require(start >= 0, f"authority marker malformed: {marker.decode()}")
    require(start == 0 or raw[start - 1 : start] == b"\n", f"authority marker is not a line: {marker.decode()}")
    line_end = start + len(marker_line)
    require(raw[line_end : line_end + 1] == b"\n", f"authority marker line must end with LF: {marker.decode()}")
    return start, line_end + 1


def validate_authority_contract() -> str:
    require(BRIEF.is_file(), f"authority brief missing: {BRIEF}")
    raw = BRIEF.read_bytes()
    begin_start, payload_start = authority_marker_offsets(raw, AUTHORITY_BEGIN_MARKER)
    end_start, _end_after_lf = authority_marker_offsets(raw, AUTHORITY_END_MARKER)
    require(begin_start < end_start, "authority markers reversed")
    digest = hashlib.sha256(raw[payload_start:end_start]).hexdigest()
    require(digest == AUTHORITY_CONTRACT_SHA256, "authority contract digest mismatch")
    return digest


def png_ihdr(path: Path) -> tuple[int, int, int]:
    raw = path.read_bytes()
    require(raw[:8] == b"\x89PNG\r\n\x1a\n", f"not a PNG: {path}")
    require(raw[12:16] == b"IHDR", f"missing PNG IHDR: {path}")
    width, height, _depth, color_type = struct.unpack(">IIBB", raw[16:26])
    return width, height, color_type


def validate_pins() -> None:
    for path, expected in PINS.items():
        require(path.is_file(), f"authority missing: {path}")
        require(sha256(path) == expected, f"authority hash drift: {path}")

    package_files = [path for path in PACKAGE.rglob("*") if path.is_file()]
    require(len(package_files) == 51, f"source package count drift: {len(package_files)} != 51")
    ledger_lines = [line.strip() for line in (PACKAGE / "HASHES.sha256").read_text().splitlines() if line.strip()]
    require(len(ledger_lines) == 50, f"source ledger count drift: {len(ledger_lines)} != 50")
    for line in ledger_lines:
        expected, relative = line.split(maxsplit=1)
        target = PACKAGE / relative.lstrip("*")
        require(target.is_file(), f"source ledger target missing: {relative}")
        require(sha256(target) == expected, f"source ledger mismatch: {relative}")
    qa = json.loads((PACKAGE / "QA_REPORT.json").read_text())
    require(qa.get("status") == "PASS", "source QA status is not PASS")
    require(qa.get("checks_passed") == 48 and qa.get("checks_total") == 48, "source QA is not 48/48")


def validate_assets_and_imports() -> None:
    for source, (runtime, expected, ihdr) in SOURCE_COPIES.items():
        require(source.is_file() and runtime.is_file(), f"D-024 source/runtime copy missing: {runtime}")
        require(sha256(source) == expected, f"D-024 source PNG hash drift: {source}")
        require(sha256(runtime) == expected, f"D-024 runtime PNG is not byte-identical: {runtime}")
        require(source.read_bytes() == runtime.read_bytes(), f"D-024 runtime PNG bytes differ: {runtime}")
        require(png_ihdr(runtime) == ihdr, f"D-024 runtime PNG IHDR drift: {runtime}")
        sidecar = Path(f"{runtime}.import")
        require(sidecar.is_file(), f"D-024 import sidecar missing: {sidecar}")
        text = sidecar.read_text()
        require('importer="texture"' in text, f"D-024 importer drift: {sidecar}")
        require("compress/mode=0" in text, f"D-024 lossless import missing: {sidecar}")
        require("mipmaps/generate=false" in text, f"D-024 mipmaps must remain off: {sidecar}")
        require(f'source_file="res://{runtime.relative_to(STEAM).as_posix()}"' in text, f"D-024 sidecar source path drift: {sidecar}")

    pngs = sorted(AUTHORED.rglob("*.png"))
    imports = sorted(AUTHORED.rglob("*.png.import"))
    require(len(pngs) == 43, f"authored PNG corpus drift: {len(pngs)} != 43")
    require(len(imports) == 43, f"authored import corpus drift: {len(imports)} != 43")
    require({Path(f"{path}.import") for path in pngs} == set(imports), "authored PNG/import one-to-one mismatch")
    require(len(list((AUTHORED / "dogs" / "labrador_intro" / "poses").rglob("identity_rgba.png"))) == 24, "Labrador identity composite count drift")
    require(len(list((AUTHORED / "world" / "layers").glob("*.png"))) == 16, "static world layer count drift")
    require(not list((AUTHORED / "world" / "layers").glob("10__*.png")), "forbidden world layer 10 present")
    bicycle_hashes = [path for path in pngs if sha256(path) == "211b6c12774bf1170bf16c108e6dbada2d35a8da69fecb8656508e85695756c5"]
    require(bicycle_hashes == [AUTHORED / "world" / "assets" / "bicycle.png"], f"standalone Bicycle count/path drift: {bicycle_hashes}")


def validate_config_and_runtime_owner() -> None:
    config = json.loads(CONFIG.read_text())
    require(config.get("schema_version") == "shelter.d024-responsive-presentation.v1", "D-024 config schema drift")
    require(config["field"] == {
        "world_min_x": 0.0,
        "world_max_x": 1740.0,
        "gameplay_fraction": 0.85,
        "exterior_reserve_fraction": 0.15,
        "zoom_max_multiplier": 1.05,
        "drag_threshold_screen_px": 8.0,
    }, "D-024 field contract drift")
    require(config["material"]["repeat_axis"] == "x_only", "meadow repeat axis drift")
    require(config["material"]["load_count"] == 1 and config["material"]["mipmaps"] is False, "meadow import/load contract drift")
    marker = config["boundary_marker"]
    require(marker["draw_count"] == 1 and marker["load_count"] == 1, "marker single-instance contract drift")
    require(marker["runtime_mirror"] is False and marker["interactive"] is False and marker["persisted"] is False, "marker authority drift")

    code = DEMO.read_text()
    require("const WORLD_WIDTH := 1740.0" in code and "const SOURCE_WORLD_WIDTH := 2992.0" in code, "world/source width drift")
    require("const SOURCE_WORLD_TO_RUNTIME := WORLD_WIDTH / SOURCE_WORLD_WIDTH" in code, "source transform drift")
    require("D024_GAMEPLAY_FRACTION * viewport_width / WORLD_WIDTH" in code, "z_min formula drift")
    require("D024_GAMEPLAY_FRACTION * (viewport_width / zoom)" in code, "camera_max formula drift")
    require("D024_DRAG_THRESHOLD_SCREEN_PX := 8.0" in code, "drag threshold drift")
    require(code.count("load(D024_MEADOW_TEXTURE_PATH)") == 1, "meadow texture load count in runtime owner drift")
    require(code.count("load(D024_MARKER_TEXTURE_PATH)") == 1, "marker texture load count in runtime owner drift")
    require(code.count("draw_texture(_d024_marker_texture") == 1, "marker draw count in runtime owner drift")
    require("Vector2(render_scale, render_scale)" in code, "positive uniform marker scale missing")
    draw_start = code.index("func _draw() -> void:")
    draw_end = code.index("\n\nfunc ", draw_start + 1)
    draw_block = code[draw_start:draw_end]
    order = [
        "_draw_d024_meadow",
        "_draw_authored_world_back",
        "_draw_transport",
        "_draw_authored_world_middle",
        "_draw_dog_action_lanes",
        "_draw_dogs",
        "_draw_authored_world_front",
        "_draw_d024_boundary_marker",
        "_draw_resource_tokens",
        "_draw_first_day_readability_cues",
    ]
    positions = [draw_block.index(name) for name in order]
    require(positions == sorted(positions), "D-024 retained render order drift")
    require('_visibility_button.visible = _view_mode != "player_prototype"' in code, "ordinary persistent Show UI cleanup missing")
    require('if _view_mode != "player_prototype":\n                    _show_semantic_labels' in code, "ordinary semantic debug gate missing")
    require("func _d024_player_mouse_polygon()" in code and "minf(rect.end.x, field_right)" in code, "exterior passthrough clamp missing")
    require(sha256(STEAM / "scenes" / "prototypes" / "vertical_slice" / "vertical_slice_demo.tscn") == "a3c5d25df2f6a5e03b631f7ca31d59f1b2739a5c2d6352257b87f4f086a5baea", "no-touch demo scene drift")
    require(sha256(STEAM / "project.godot") == "475402f3792ce3e95e86c72cbe4c03a1da749760b7c691cfa6a01cefb3609dc6", "no-touch project.godot drift")
    require(sha256(STEAM / "scripts" / "player" / "player_boot.gd") == "dac832c2d861a16ad74ba4fb5bdaebaa045b5f63984b9a5be74d45f348fb60fd", "no-touch PlayerBoot drift")


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--authority-only",
        action="store_true",
        help="validate only the immutable D-024 authority contract without writing files",
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    try:
        authority_digest = validate_authority_contract()
        if args.authority_only:
            print(
                "d024_authority_contract=PASS "
                f"scheme={AUTHORITY_CONTRACT_SCHEME} sha256={authority_digest}"
            )
            return 0
        validate_pins()
        validate_assets_and_imports()
        validate_config_and_runtime_owner()
    except (OSError, ValueError, KeyError, ValidationError) as exc:
        label = "d024_authority_contract" if args.authority_only else "d024_responsive_presentation_validator"
        print(f"{label}=FAIL error={exc}", file=sys.stderr)
        return 1
    print(
        "d024_responsive_presentation_validator=PASS "
        f"authority_contract_sha256={authority_digest} "
        "source=51 ledger=50/50 qa=48/48 corpus=43+43 meadow_load=1 marker_load_draw=1"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
