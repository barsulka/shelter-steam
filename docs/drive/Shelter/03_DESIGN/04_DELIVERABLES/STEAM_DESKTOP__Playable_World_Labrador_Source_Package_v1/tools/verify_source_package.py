#!/usr/bin/env python3
"""Verify the bounded R48-05A-S source package without runtime claims."""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import sys
from pathlib import Path
from typing import Any

from PIL import Image, __version__ as PILLOW_VERSION


PACKAGE = Path(__file__).resolve().parents[1]
BUILD_DATE = "2026-07-13"
HASH_FILE = PACKAGE / "HASHES.sha256"
QA_FILE = PACKAGE / "QA_REPORT.json"


def load_json(relative: str) -> dict[str, Any]:
    return json.loads((PACKAGE / relative).read_text(encoding="utf-8"))


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def rgba_bbox(path: Path) -> tuple[int, int, int, int] | None:
    with Image.open(path) as image:
        if image.mode != "RGBA":
            raise ValueError(f"{path.relative_to(PACKAGE)} mode={image.mode}, expected RGBA")
        return image.getchannel("A").getbbox()


class Audit:
    def __init__(self) -> None:
        self.checks: list[dict[str, Any]] = []
        self.errors: list[str] = []
        self.warnings: list[str] = []

    def check(self, check_id: str, condition: bool, detail: str) -> None:
        self.checks.append({"id": check_id, "result": "PASS" if condition else "FAIL", "detail": detail})
        if not condition:
            self.errors.append(f"{check_id}: {detail}")

    def warn(self, warning_id: str, detail: str) -> None:
        self.warnings.append(f"{warning_id}: {detail}")


def verify_png_set(audit: Audit) -> None:
    pngs = sorted((PACKAGE / "exports").rglob("*.png"))
    audit.check("exports.present", bool(pngs), f"lossless export PNG count={len(pngs)}")
    all_rgba = True
    all_canvas = True
    all_nonempty = True
    bad: list[str] = []
    for path in pngs:
        relative = path.relative_to(PACKAGE).as_posix()
        if relative.startswith("exports/labrador/"):
            expected = (512, 320)
        elif relative.startswith("exports/world/"):
            expected = (1536, 216)
        elif relative.startswith("exports/stations/"):
            expected = (1024, 360)
        else:
            expected = None
        with Image.open(path) as image:
            if image.mode != "RGBA":
                all_rgba = False
                bad.append(f"{relative}:mode={image.mode}")
            if expected and image.size != expected:
                all_canvas = False
                bad.append(f"{relative}:size={image.size}")
            if image.convert("RGBA").getchannel("A").getbbox() is None:
                all_nonempty = False
                bad.append(f"{relative}:empty_alpha")
    audit.check("exports.rgba", all_rgba, "all exports are RGBA" if all_rgba else "; ".join(bad[:12]))
    audit.check("exports.canvas", all_canvas, "dog=512x320, world=1536x216, stations=1024x360")
    audit.check("exports.nonempty_alpha", all_nonempty, "every semantic export contains non-zero alpha")


def verify_layer_records(audit: Audit, manifest: dict[str, Any], groups: list[dict[str, Any]]) -> None:
    all_paths = True
    all_bounds = True
    details: list[str] = []
    for layers in groups:
        for layer_id, record in layers.items():
            source = PACKAGE / record["source"]
            export = PACKAGE / record["export"]
            if not source.is_file() or not export.is_file():
                all_paths = False
                details.append(f"{layer_id}:missing")
                continue
            actual = rgba_bbox(export)
            expected = tuple(record["bounds"]) if record["bounds"] else None
            if actual != expected:
                all_bounds = False
                details.append(f"{layer_id}:manifest={expected},actual={actual}")
    audit.check("layers.source_export_paths", all_paths, "every layer source/export path resolves")
    audit.check("layers.alpha_bounds", all_bounds, "recorded layer bounds equal RGBA alpha getbbox" if all_bounds else "; ".join(details[:12]))


def verify_dog(audit: Audit) -> None:
    dog = load_json("manifests/labrador_source_manifest.json")
    audit.check("dog.actor_id", dog.get("actor_id") == "dog.labrador_intro", f"actor_id={dog.get('actor_id')}")
    audit.check("dog.maturity", dog.get("source_maturity") == "SOURCE_READY_ONLY__NO_RUNTIME_ART_PASS", f"source_maturity={dog.get('source_maturity')}")
    canvas = dog["canvas"]
    expected_with_shadow = {
        "right": tuple(canvas["alpha_bounds_rgba"]["right_identity_with_shadow"]),
        "left": tuple(canvas["alpha_bounds_rgba"]["left_identity_with_shadow"]),
        "turn_mid": tuple(canvas["alpha_bounds_rgba"]["turn_mid_identity_with_shadow"]),
    }
    expected_no_shadow = {
        face: tuple(bounds) for face, bounds in canvas["alpha_bounds_identity_without_shadow"].items()
    }
    bounds_ok = True
    no_shadow_ok = True
    for face in ("right", "left", "turn_mid"):
        actual = rgba_bbox(PACKAGE / f"exports/labrador/{face}/composite_identity.png")
        bounds_ok &= actual == expected_with_shadow[face]
        layers = dog["layers"][face]
        merged = Image.new("RGBA", (512, 320), (0, 0, 0, 0))
        for layer_id in dog["z_order"][face]:
            if layer_id in {"dog.shadow.local", "dog.eye.blink", "dog.equipment.collar"}:
                continue
            with Image.open(PACKAGE / layers[layer_id]["export"]) as layer:
                merged.alpha_composite(layer.convert("RGBA"))
        no_shadow_ok &= merged.getchannel("A").getbbox() == expected_no_shadow[face]
    audit.check("dog.composite_alpha_bounds", bounds_ok, f"with-shadow bounds={expected_with_shadow}")
    audit.check("dog.identity_alpha_bounds", no_shadow_ok, f"no-shadow bounds={expected_no_shadow}")

    right = dog["pivots"]["right"]
    left = dog["pivots"]["left"]
    mid = dog["pivots"]["turn_mid"]
    baseline = dog["canvas"]["ground_baseline_y"]
    roots_ok = all(pivots["actor_root_ground"] == [256, baseline] for pivots in (right, left, mid))
    paws_ok = all(abs(pivots[key][1] - baseline) <= 3 for pivots in (right, left, mid) for key in ("fore_near_paw", "fore_far_paw", "hind_near_paw", "hind_far_paw"))
    audit.check("dog.root_baseline", roots_ok, f"all actor roots=[256,{baseline}]")
    audit.check("dog.paw_baseline", paws_ok, "all paw pivots are within 3 px of ground baseline")

    mirror_pairs = (
        ("muzzle_contact", "muzzle_contact"),
        ("head_neck", "head_neck"),
        ("torso", "torso"),
        ("tail", "tail"),
        ("ear_near", "ear_far"),
        ("ear_far", "ear_near"),
        ("fore_near_paw", "fore_far_paw"),
        ("fore_far_paw", "fore_near_paw"),
        ("hind_near_paw", "hind_far_paw"),
        ("hind_far_paw", "hind_near_paw"),
    )
    mirror_ok = all(left[left_key][0] == 512 - right[right_key][0] and left[left_key][1] == right[right_key][1] for right_key, left_key in mirror_pairs)
    audit.check("dog.authored_facing_geometry", mirror_ok, "left/right pivots are positive-space counterparts; near/far anatomy swaps explicitly across facing")
    right_hash = sha256(PACKAGE / dog["masters"]["right"])
    left_hash = sha256(PACKAGE / dog["masters"]["left"])
    mid_hash = sha256(PACKAGE / dog["masters"]["turn_mid"])
    audit.check("dog.distinct_masters", len({right_hash, left_hash, mid_hash}) == 3, "right, left and physical-turn midpoint SVG hashes are distinct")

    svg_ok = True
    labels_ok = True
    for face, master_relative in dog["masters"].items():
        text = (PACKAGE / master_relative).read_text(encoding="utf-8")
        if re.search(r"scale\(\s*-|matrix\(\s*-", text):
            svg_ok = False
        for layer_id in dog["z_order"][face]:
            if f'inkscape:label="{layer_id}"' not in text:
                labels_ok = False
    audit.check("dog.no_negative_scale", svg_ok, "no negative scale/matrix exists in dog masters")
    audit.check("dog.named_editable_layers", labels_ok, "every declared semantic layer exists as a named SVG group")

    near_far = all(
        dog["z_order"][face].index("dog.ear.far") < dog["z_order"][face].index("dog.ear.near")
        and dog["z_order"][face].index("dog.leg.fore.far") < dog["z_order"][face].index("dog.leg.fore.near")
        and dog["z_order"][face].index("dog.leg.hind.far") < dog["z_order"][face].index("dog.leg.hind.near")
        for face in ("right", "left", "turn_mid")
    )
    audit.check("dog.near_far_z_order", near_far, "far ears/limbs are behind their near counterparts")

    evidence_ok = True
    for size_text, record in dog["evidence"]["sizes"].items():
        target = int(size_text)
        for face in ("right", "left", "turn_mid"):
            with Image.open(PACKAGE / record[face]) as image:
                bbox = image.convert("RGBA").getchannel("A").getbbox()
            evidence_ok &= bbox is not None and bbox[3] - bbox[1] == target
            silhouette_path = PACKAGE / f"evidence/labrador/{target}/{face}__silhouette.png"
            with Image.open(silhouette_path) as silhouette:
                sil_bbox = silhouette.convert("RGBA").getchannel("A").getbbox()
            evidence_ok &= sil_bbox is not None and sil_bbox[3] - sil_bbox[1] == target
    audit.check("dog.native_size_evidence", evidence_ok, "identity and silhouette alpha heights are exactly 216/144/96 px")
    verify_layer_records(audit, dog, list(dog["layers"].values()))


def verify_world(audit: Audit) -> None:
    world = load_json("manifests/world_source_manifest.json")
    exact = {
        "world.ground.base", "world.ground.grass_mass", "world.ground.dirt_worn", "world.ground.sand_soft",
        "world.path.main", "world.path.used_taper_end", "world.transition.grass_dirt",
        "world.transition.grass_sand", "world.transition.ground_path", "world.fence.back_span",
        "world.fence.front_span", "world.fence.post_end_open_gap", "world.yard.bicycle_pad",
        "world.shadow.local_prop", "world.anchor.bicycle_parking",
    }
    actual = set(world["layers"])
    audit.check("world.exact_layer_scope", actual == exact, f"exact semantic layer set count={len(actual)}")
    audit.check("world.no_corner", world["bounded_scope"].get("fence_corner") == "OMITTED_NOT_USED", "fence corner is omitted as not used")
    audit.check("world.no_decor_atlas", world["bounded_scope"].get("decor_atlas") == "NOT_CREATED", "broad decor atlas not created")
    master = (PACKAGE / world["master"]).read_text(encoding="utf-8")
    labels_ok = all(f'inkscape:label="{layer_id}"' in master for layer_id in world["z_order"])
    audit.check("world.named_editable_layers", labels_ok, "every world layer exists as a named SVG group")
    anchor = world["anchor_records"]["bicycle_parking"]
    audit.check("world.bicycle_noninteractive", anchor.get("interactive") is False, "bicycle anchor is staging-only and noninteractive")
    verify_layer_records(audit, world, [world["layers"]])


def verify_stations(audit: Audit) -> None:
    stations = load_json("manifests/station_anchors.json")
    expected_ids = {"object.kitchen", "object.packing_table"}
    audit.check("stations.exact_ids", set(stations["stations"]) == expected_ids, f"station ids={sorted(stations['stations'])}")
    groups: list[dict[str, Any]] = []
    station_ok = True
    clearance_ok = True
    for station_id, station in stations["stations"].items():
        groups.append(station["layers"])
        station_ok &= station["anchor_plane_source_status"].startswith("AUTHORED_TECHNICAL_ART_SOURCE")
        station_ok &= station["allowed_facing"]["cross_station_flip"] == "forbidden"
        station_ok &= "before approach" in station["allowed_facing"]["physical_turn"]
        envelope = station["clearance_envelope"]
        clearance_ok &= envelope["identity_width_px"] == 461 and envelope["identity_height_px"] == 225
        for key in ("approach_anchors", "contact_align_body_root_anchors", "work_body_root_anchors", "exit_anchors"):
            for point in station[key].values():
                clearance_ok &= 0 <= point[0] < 1024 and point[1] == 300
    audit.check("stations.contact_policy", station_ok, "anchor planes declare facing, physical-turn, contact and no-flip policy")
    audit.check("stations.current_labrador_clearance", clearance_ok, "directional 461x225 identity envelopes and all root anchors are canvas-valid")
    verify_layer_records(audit, stations, groups)
    packing = stations["stations"]["object.packing_table"]
    if packing["source_reference_status"].startswith("NEEDED"):
        audit.warn("stations.packing_table_visual", "no approved Packing Table visual source exists; authored technical anchor plane is intentionally not replacement art")


def verify_actions_and_boundaries(audit: Audit) -> None:
    accepted = load_json("manifests/accepted_action_scope.json")
    preflight = load_json("manifests/source_preflight_manifest.json")
    package = load_json("manifests/package_manifest.json")
    expected = {
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
    }
    ids = set(accepted["actions"] if isinstance(accepted["actions"][0], str) else [row["id"] for row in accepted["actions"]])
    audit.check("scope.accepted_actions", ids == expected and len(ids) == 12, f"accepted exact action ids={sorted(ids)}")
    preflight_ids = {row["id"] for row in preflight["actions"]}
    audit.check("scope.preflight_actions", preflight_ids == expected, "preflight reproduces exactly the accepted 12-row manifest")
    forbidden = {"pickup", "attach", "carry", "place", "detach"}
    has_forbidden = any(token in action_id for action_id in ids for token in forbidden)
    audit.check("scope.no_transfer", not has_forbidden and package["source_only_boundaries"]["object_transfer"] is False, "no pickup/attach/carry/place/detach authority")
    audit.check("scope.source_only", package["verdict_scope"] == "SOURCE_LEVEL_ONLY" and package["source_only_boundaries"]["runtime_binding"] is False and package["source_only_boundaries"]["godot_import"] is False, "no runtime binding/import claim")


def verify_provenance(audit: Audit) -> None:
    provenance = load_json("PROVENANCE.json")
    ai = provenance["ai_use"]
    audit.check("provenance.ai_declared", ai["declared"] is True and ai["embedded_ai_pixels_in_master_or_exports"] is False, "AI reference declared; no AI pixels embedded in master/export")
    audit.check("provenance.toolchain", provenance["toolchain"]["pillow"] == PILLOW_VERSION and provenance["date"] == BUILD_DATE, f"date={BUILD_DATE}, Pillow={PILLOW_VERSION}")
    inputs_ok = all(len(record["sha256"]) == 64 for record in provenance["input_references"].values())
    audit.check("provenance.input_hashes", inputs_ok and len(provenance["input_references"]) == 5, "five local input references have SHA-256 provenance")
    artifacts = provenance["artifact_hashes_sha256"]
    bad: list[str] = []
    for relative, expected in artifacts.items():
        path = PACKAGE / relative
        if not path.is_file() or sha256(path) != expected:
            bad.append(relative)
    audit.check("provenance.artifact_hashes", not bad, f"verified artifact SHA-256 count={len(artifacts)}" if not bad else f"bad={bad[:12]}")


def relevant_files() -> list[Path]:
    return sorted(
        path for path in PACKAGE.rglob("*")
        if path.is_file() and path != HASH_FILE and "__pycache__" not in path.parts and path.suffix != ".pyc"
    )


def write_hashes() -> None:
    lines = [f"{sha256(path)}  {path.relative_to(PACKAGE).as_posix()}" for path in relevant_files()]
    HASH_FILE.write_text("\n".join(lines) + "\n", encoding="utf-8")


def verify_hash_file(audit: Audit) -> None:
    if not HASH_FILE.is_file():
        audit.check("package.hash_file", False, "HASHES.sha256 missing")
        return
    expected: dict[str, str] = {}
    for line in HASH_FILE.read_text(encoding="utf-8").splitlines():
        digest, relative = line.split("  ", 1)
        expected[relative] = digest
    actual_paths = {path.relative_to(PACKAGE).as_posix() for path in relevant_files()}
    bad = [relative for relative, digest in expected.items() if not (PACKAGE / relative).is_file() or sha256(PACKAGE / relative) != digest]
    missing = sorted(actual_paths - set(expected))
    stale = sorted(set(expected) - actual_paths)
    audit.check("package.hash_readback", not bad and not missing and not stale, f"verified complete package hashes={len(expected)}" if not bad and not missing and not stale else f"bad={bad[:8]},missing={missing[:8]},stale={stale[:8]}")


def run(write: bool) -> tuple[Audit, dict[str, Any]]:
    audit = Audit()
    verify_actions_and_boundaries(audit)
    verify_png_set(audit)
    verify_dog(audit)
    verify_world(audit)
    verify_stations(audit)
    verify_provenance(audit)
    hidden_cache = [path.relative_to(PACKAGE).as_posix() for path in PACKAGE.rglob("*") if path.is_file() and ("__pycache__" in path.parts or path.suffix == ".pyc")]
    audit.check("package.no_build_cache", not hidden_cache, "no __pycache__/.pyc files" if not hidden_cache else f"cache={hidden_cache}")
    report = {
        "schema_version": "shelter-source-package-qa/v1",
        "package": PACKAGE.name,
        "date": BUILD_DATE,
        "scope": "SOURCE_LEVEL_ONLY",
        "automated_result": "PASS" if not audit.errors else "FAIL",
        "checks": audit.checks,
        "warnings": audit.warnings,
        "errors": audit.errors,
        "runtime_validation": "NOT_RUN_OUT_OF_SCOPE",
        "visual_review": "see ART_QA.md; automated script does not self-certify Art judgement",
    }
    if write:
        QA_FILE.write_text(json.dumps(report, ensure_ascii=False, indent=2, sort_keys=True) + "\n", encoding="utf-8")
        write_hashes()
    else:
        verify_hash_file(audit)
        report["checks"] = audit.checks
        report["errors"] = audit.errors
        report["automated_result"] = "PASS" if not audit.errors else "FAIL"
    return audit, report


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true", help="write QA_REPORT.json and HASHES.sha256")
    args = parser.parse_args()
    audit, report = run(args.write)
    print(json.dumps({
        "status": report["automated_result"],
        "check_count": len(audit.checks),
        "warning_count": len(audit.warnings),
        "error_count": len(audit.errors),
        "warnings": audit.warnings,
        "errors": audit.errors,
        "pillow": PILLOW_VERSION,
    }, ensure_ascii=False, indent=2))
    return 0 if not audit.errors else 1


if __name__ == "__main__":
    raise SystemExit(main())
