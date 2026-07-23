#!/usr/bin/env python3
"""Fail-closed validator for the versioned D-032 current presentation profile."""

from __future__ import annotations

import argparse
import copy
import hashlib
import json
import math
import os
import struct
import sys
import tempfile
import zlib
from pathlib import Path
from typing import Any


SCHEMA = "shelter.d030-selected-h-current-presentation.v1"
GATE_PRE_CP2 = "pre-checkpoint-2"
PROFILE = "d030-selected-h-current-presentation"
EXPECTED_VERSION = "4.7.1.stable.steam.a13da4feb"
EXPECTED_GODOT_SHA256 = "475402f3792ce3e95e86c72cbe4c03a1da749760b7c691cfa6a01cefb3609dc6"
OBSERVER_FLAG = "--shelter-observer-control-v1"
WORLD_WIDTH = 1740.0
SOURCE_WIDTH = 2992.0
SOURCE_TO_WORLD = WORLD_WIDTH / SOURCE_WIDTH
ZOOMS = (50, 100, 150, 200)
PROFILES = ("min", "default", "max")
CURRENT_HOST_NATIVE_HEIGHT_Q = 2
MEADOW_RESOURCE = (
    "res://assets/prototypes/vertical_slice/authored/world/responsive/"
    "meadow_pattern_26_cells_1664x941.png"
)

SOURCE_HASHES = {
    "steam/assets/prototypes/vertical_slice/authored/world/responsive/meadow_pattern_26_cells_1664x941.png":
        "3816aa11aa7cd0b8e6f46d857d0ec89badd08597122439150403de39f4298203",
    "docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Art_Source_Reconciliation_Wave_v1/exports/labrador/poses/idle_neutral_right/composite_with_shadow_rgba.png":
        "099fdf27606cc3d64bd923775627e7dff6fd0f04c0791e20618c874fc06cd8e2",
    "docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Art_Source_Reconciliation_Wave_v1/exports/world/assets/road_sign.png":
        "dee133ecea707cb0d4b93948b6685410ea3715e8ea822b2149fcb51ec2413015",
    "docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Art_Source_Reconciliation_Wave_v1/exports/world/assets/bicycle.png":
        "211b6c12774bf1170bf16c108e6dbada2d35a8da69fecb8656508e85695756c5",
    "docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Art_Source_Reconciliation_Wave_v1/exports/world/assets/storage.png":
        "e86d627be61379dd0312b2ad033ea70baaf70798067222b39ae9a21f2d4fc20b",
    "docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Art_Source_Reconciliation_Wave_v1/exports/world/assets/mill_static.png":
        "a1063aaa1f44c414fb52268f5c727e0d4b777b24ebbe9e075e180bf5ab936570",
    "docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Art_Source_Reconciliation_Wave_v1/exports/world/assets/kitchen.png":
        "954cb90139c49f2390c5d5aae6190935936b513e3bd71c94011c10047d89e688",
    "docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Art_Source_Reconciliation_Wave_v1/exports/world/assets/packing_utility.png":
        "5b20dbb82ec37ee151e941c72075c7c7aec7abb04c8f177e29f167f9122ad625",
    "docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Art_Source_Reconciliation_Wave_v1/exports/world/assets/van_endpoint.png":
        "f7b79ae3d70b0d45ff10009cf1547f6d56cdbeb9beb1ebe91fe736c8915125d7",
}

RUNTIME_CONTRACT = {
    "logical_cell_world": 32.0,
    "period_cells": 26,
    "period_world": 832.0,
    "source_period_px": 1664,
    "source_period_zoom_percent": 200,
    "horizontal_fit_or_stretch": False,
    "world_width": 1740.0,
    "source_design_width": 2992.0,
    "source_world_to_runtime": SOURCE_TO_WORLD,
    "zoom_ladder_percent": [50, 100, 150, 200],
    "default_zoom_percent": 100,
    "companion_height_mode": "dynamic-bounded-by-usable-rect",
    "fixed_height_px": None,
    "artificial_exterior_reserve_fraction": 0.0,
    "presentation_persisted": False,
    "drag_threshold_screen_px": 8.0,
    "release_no_click": True,
}

SELECTED_H_CONTRACT = {
    "design_canvas": [2992, 480],
    "canonical_design_x_interval": [0, 2992],
    "render_pointer_domain": "projected-canonical-canvas",
    "viewport_exterior": "transparent-click-through",
    "pointer_boundary_sample_step_px": 1,
    "semantic_bands": {
        "trees": [216, 346],
        "back_lawn": [346, 367],
        "path": [367, 405],
        "foreground_lawn": [405, 416],
        "earth": [416, 480],
    },
    "background_pixel_sha256": "840bbc58cf4205835e6498c0eb4b29ff0dccedba944d0d470081f35fad6db5bc",
    "tree_layer_pixel_sha256": "1bb781811215eb409b20c39e90ce467de264b5e83548679f82d9bc191a6c9620",
    "lower_layer_pixel_sha256": "ff5564e4188fcc8b0662140a0139d519068ff4f42e1145e12b06b5bd771e273a",
    "grid_overlay_pixel_sha256": "b5ecdbcc3793fef6acd7b2d9929583a1454fbbc58eeb3f897d28f9ca325ef7dc",
    "grid_band": [441, 473],
    "grid_boundaries": [
        0, 115, 230, 345, 460, 575, 690, 805, 920, 1035, 1150, 1265,
        1380, 1496, 1611, 1726, 1841, 1956, 2071, 2186, 2301, 2416,
        2531, 2646, 2761, 2876, 2992,
    ],
    "grid_occupied": [4, 5, 6, 7, 9, 10, 13, 14, 15, 16, 17, 18, 19],
    "grid_inset": 2.0,
    "grid_empty_fill_rgba8": [117, 117, 117, 204],
    "grid_empty_stroke_rgba8": [158, 158, 158, 204],
    "grid_empty_stroke_width": 2,
    "grid_occupied_fill_rgba8": [107, 235, 61, 209],
    "grid_occupied_stroke_rgba8": [151, 241, 119, 209],
    "grid_occupied_stroke_width": 3,
    "render_order": [
        "storage", "mill_static", "kitchen", "packing_utility",
        "road_sign", "bicycle", "van_endpoint", "labrador",
    ],
    "depth_exclusive_alpha_bottom": {
        "rear": 367,
        "middle": 386,
        "front": 402,
        "rear_to_middle_gap": 19,
        "middle_to_front_gap": 16,
    },
    "building_integer_pivot_x": {
        "storage": 690,
        "mill_static": 1150,
        "kitchen": 1726,
        "packing_utility": 2128,
    },
    "y_authority": "exclusive-visible-alpha-bottom",
    "positive_design_integer_snap": "floor-footprint-midpoint",
}


class ValidationError(RuntimeError):
    pass


def fail(message: str) -> None:
    raise ValidationError(message)


def exact_keys(value: Any, keys: set[str], path: str) -> dict[str, Any]:
    if not isinstance(value, dict):
        fail(f"{path}: expected object")
    actual = set(value)
    if actual != keys:
        fail(f"{path}: fields mismatch missing={sorted(keys-actual)} unknown={sorted(actual-keys)}")
    return value


def exact_value(actual: Any, expected: Any, path: str) -> None:
    if isinstance(expected, float):
        if not isinstance(actual, (int, float)) or not math.isclose(float(actual), expected, abs_tol=1e-9):
            fail(f"{path}: expected {expected!r}, got {actual!r}")
        return
    if actual != expected:
        fail(f"{path}: expected {expected!r}, got {actual!r}")


def close_value(actual: Any, expected: float, path: str, tolerance: float = 1e-5) -> None:
    if not isinstance(actual, (int, float)) or not math.isclose(float(actual), expected, abs_tol=tolerance):
        fail(f"{path}: expected approximately {expected}, got {actual!r}")


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def load_json(path: Path) -> dict[str, Any]:
    try:
        value = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, UnicodeDecodeError, json.JSONDecodeError) as exc:
        fail(f"{path}: unreadable JSON: {exc}")
    if not isinstance(value, dict):
        fail(f"{path}: top-level JSON must be an object")
    return value


def validate_runtime_contract(value: Any) -> None:
    contract = exact_keys(value, set(RUNTIME_CONTRACT), "runtime_contract")
    for key, expected in RUNTIME_CONTRACT.items():
        exact_value(contract[key], expected, f"runtime_contract.{key}")


def validate_selected_h_contract(value: Any) -> None:
    contract = exact_keys(value, set(SELECTED_H_CONTRACT), "selected_h_contract")
    for key, expected in SELECTED_H_CONTRACT.items():
        exact_value(contract[key], expected, f"selected_h_contract.{key}")


def validate_output_probe(value: Any) -> None:
    probe = exact_keys(value, {
        "checkpoint_before", "checkpoint_after", "event_count_before", "event_count_after",
        "checkpoint_unchanged", "events_unchanged", "checkpoint_contains_presentation_fields",
    }, "presentation_output_probe")
    if probe["checkpoint_before"] != probe["checkpoint_after"]:
        fail("presentation_output_probe: checkpoint changed")
    exact_value(probe["event_count_before"], probe["event_count_after"], "presentation_output_probe.event_count")
    exact_value(probe["checkpoint_unchanged"], True, "presentation_output_probe.checkpoint_unchanged")
    exact_value(probe["events_unchanged"], True, "presentation_output_probe.events_unchanged")
    exact_value(
        probe["checkpoint_contains_presentation_fields"],
        False,
        "presentation_output_probe.checkpoint_contains_presentation_fields",
    )


def expected_height_contract(zoom_percent: int, usable_height: int, q: int) -> dict[str, Any]:
    content = 480.0 * SOURCE_TO_WORLD * zoom_percent / 100.0
    required = max(180, math.ceil(content))
    usable_q = math.floor(usable_height / q) * q
    if usable_q < required:
        fail(
            f"height contract: usable_q {usable_q} is below required {required} "
            f"for zoom {zoom_percent}"
        )
    requested = min(math.ceil(required / q) * q, usable_q)
    return {
        "content": content,
        "required": required,
        "usable_q": usable_q,
        "requested": requested,
    }


def validate_display_topology(value: Any) -> dict[str, Any]:
    topology = exact_keys(value, {"screen_count", "scale_list", "q", "stable"}, "display_topology")
    scales = topology["scale_list"]
    if not isinstance(topology["screen_count"], int) or isinstance(topology["screen_count"], bool):
        fail("display_topology.screen_count: expected integer")
    if not isinstance(scales, list) or len(scales) != topology["screen_count"] or not scales:
        fail("display_topology.scale_list: must cover every launch display")
    normalized: list[int] = []
    for index, scale in enumerate(scales):
        if isinstance(scale, bool) or not isinstance(scale, (int, float)):
            fail(f"display_topology.scale_list[{index}]: expected number")
        numeric = float(scale)
        if not math.isfinite(numeric) or numeric <= 0.0 or not numeric.is_integer():
            fail(f"display_topology.scale_list[{index}]: non-integral scale {scale!r}")
        normalized.append(int(numeric))
    if not isinstance(topology["q"], int) or isinstance(topology["q"], bool):
        fail("display_topology.q: expected integer")
    exact_value(topology["q"], max(normalized), "display_topology.q")
    exact_value(topology["q"], CURRENT_HOST_NATIVE_HEIGHT_Q, "display_topology.q.current_host")
    exact_value(topology["stable"], True, "display_topology.stable")
    return topology


def validate_state_height_contract(
    value: Any,
    launch_topology: dict[str, Any],
    zoom_percent: int,
    usable_height: int,
    width: int,
    path: str,
) -> int:
    height = exact_keys(value, {
        "content", "required", "scale_list", "q", "usable_q", "requested", "actual",
    }, path)
    exact_value(height["scale_list"], launch_topology["scale_list"], f"{path}.scale_list")
    exact_value(height["q"], launch_topology["q"], f"{path}.q")
    expected = expected_height_contract(zoom_percent, usable_height, int(launch_topology["q"]))
    close_value(height["content"], expected["content"], f"{path}.content")
    exact_value(height["required"], expected["required"], f"{path}.required")
    exact_value(height["usable_q"], expected["usable_q"], f"{path}.usable_q")
    exact_value(height["requested"], expected["requested"], f"{path}.requested")
    exact_value(height["actual"], [width, expected["requested"]], f"{path}.actual")
    return int(expected["requested"])


def validate_pan_probe(value: Any, camera_max: float, zoom: float, path: str) -> None:
    probe = exact_keys(value, {
        "threshold_screen_px", "camera_max", "eligible", "below_threshold_consumed",
        "below_threshold_release_consumed", "above_threshold_consumed",
        "above_threshold_release_consumed", "camera_after_above_threshold",
        "negative_clamp", "overflow_clamp", "checkpoint_unchanged", "events_unchanged",
        "release_no_click",
    }, path)
    exact_value(probe["threshold_screen_px"], 8.0, f"{path}.threshold_screen_px")
    close_value(probe["camera_max"], camera_max, f"{path}.camera_max")
    exact_value(probe["negative_clamp"], 0.0, f"{path}.negative_clamp")
    close_value(probe["overflow_clamp"], camera_max, f"{path}.overflow_clamp")
    exact_value(probe["checkpoint_unchanged"], True, f"{path}.checkpoint_unchanged")
    exact_value(probe["events_unchanged"], True, f"{path}.events_unchanged")
    exact_value(probe["release_no_click"], True, f"{path}.release_no_click")
    if camera_max > 0.0:
        exact_value(probe["eligible"], True, f"{path}.eligible")
        exact_value(probe["below_threshold_consumed"], False, f"{path}.below_threshold_consumed")
        exact_value(probe["below_threshold_release_consumed"], False, f"{path}.below_threshold_release_consumed")
        exact_value(probe["above_threshold_consumed"], True, f"{path}.above_threshold_consumed")
        exact_value(probe["above_threshold_release_consumed"], True, f"{path}.above_threshold_release_consumed")
        close_value(
            probe["camera_after_above_threshold"],
            min(camera_max, 9.0 / zoom),
            f"{path}.camera_after_above_threshold",
        )
    else:
        exact_value(probe["eligible"], False, f"{path}.eligible")
        exact_value(probe["above_threshold_consumed"], False, f"{path}.above_threshold_consumed")
        exact_value(probe["above_threshold_release_consumed"], False, f"{path}.above_threshold_release_consumed")


def validate_capture_record(value: Any, kind: str, state_id: str, width: int, height: int, path: str) -> str:
    capture = exact_keys(value, {"file", "width", "height", "grid_visible", "draw_bindings"}, path)
    expected_file = f"{state_id}-{kind}.png"
    exact_value(capture["file"], expected_file, f"{path}.file")
    exact_value(capture["width"], width, f"{path}.width")
    exact_value(capture["height"], height, f"{path}.height")
    exact_value(capture["grid_visible"], kind == "grid", f"{path}.grid_visible")
    exact_value(
        capture["draw_bindings"],
        ["selected_h.background", "selected_h.grid"] if kind == "grid" else ["selected_h.background"],
        f"{path}.draw_bindings",
    )
    return expected_file


def exact_intervals(value: Any, expected: list[list[int]], path: str) -> None:
    if not isinstance(value, list):
        fail(f"{path}: expected interval list")
    previous_end = -1
    for index, interval in enumerate(value):
        if (
            not isinstance(interval, list)
            or len(interval) != 2
            or not all(isinstance(item, int) and not isinstance(item, bool) for item in interval)
            or interval[0] < 0
            or interval[1] <= interval[0]
            or interval[0] < previous_end
        ):
            fail(f"{path}[{index}]: malformed or unordered half-open interval")
        previous_end = interval[1]
    exact_value(value, expected, path)


def validate_state(
    value: Any,
    expected_profile: str,
    zoom_percent: int,
    launch_topology: dict[str, Any],
) -> tuple[str, str]:
    state_id = f"{expected_profile}-{zoom_percent}"
    path = f"states[{state_id}]"
    state = exact_keys(value, {
        "id", "window_profile", "zoom_percent", "profile_width", "dynamic_height_expected",
        "actual_window_size", "viewport_size", "usable_rect", "height_contract", "camera",
        "transform", "projected_canvas_interval", "visible_alpha_x_intervals",
        "pointer_content_x_intervals", "transparent_exterior_x_intervals",
        "render_exterior_alpha_pixels", "render_exterior_alpha_columns",
        "uncovered_visible_alpha_pixels", "uncovered_visible_alpha_columns",
        "exterior_clickable_pixels", "exterior_clickable_columns",
        "transparent_sky_pointer_pixels", "transparent_sky_pointer_columns",
        "pointer", "permanent_state", "captures",
    }, path)
    exact_value(state["id"], state_id, f"{path}.id")
    exact_value(state["window_profile"], expected_profile, f"{path}.window_profile")
    exact_value(state["zoom_percent"], zoom_percent, f"{path}.zoom_percent")
    usable = state["usable_rect"]
    if not isinstance(usable, list) or len(usable) != 4 or not all(isinstance(v, int) for v in usable):
        fail(f"{path}.usable_rect: expected four integers")
    expected_width = {"min": 720, "default": 1280, "max": usable[2]}[expected_profile]
    height = validate_state_height_contract(
        state["height_contract"],
        launch_topology,
        zoom_percent,
        usable[3],
        expected_width,
        f"{path}.height_contract",
    )
    exact_value(state["profile_width"], expected_width, f"{path}.profile_width")
    exact_value(state["dynamic_height_expected"], height, f"{path}.dynamic_height_expected")
    exact_value(state["actual_window_size"], [expected_width, height], f"{path}.actual_window_size")
    exact_value(state["viewport_size"], [expected_width, height], f"{path}.viewport_size")

    zoom = zoom_percent / 100.0
    camera_max = max(WORLD_WIDTH - expected_width / zoom, 0.0)
    camera = exact_keys(state["camera"], {
        "default_x", "actual_x", "max_x", "visible_world_width", "extent_mode",
        "default_reset", "pan_probe",
    }, f"{path}.camera")
    exact_value(camera["default_x"], 0.0, f"{path}.camera.default_x")
    exact_value(camera["actual_x"], 0.0, f"{path}.camera.actual_x")
    close_value(camera["max_x"], camera_max, f"{path}.camera.max_x")
    close_value(camera["visible_world_width"], expected_width / zoom, f"{path}.camera.visible_world_width")
    exact_value(camera["extent_mode"], "visible-extent-no-reserve", f"{path}.camera.extent_mode")
    exact_value(camera["default_reset"], True, f"{path}.camera.default_reset")
    validate_pan_probe(camera["pan_probe"], camera_max, zoom, f"{path}.camera.pan_probe")

    transform = exact_keys(state["transform"], {
        "design_canvas", "design_to_world", "screen_scale", "design_origin_screen",
    }, f"{path}.transform")
    exact_value(transform["design_canvas"], [2992, 480], f"{path}.transform.design_canvas")
    close_value(transform["design_to_world"], SOURCE_TO_WORLD, f"{path}.transform.design_to_world")
    scale = SOURCE_TO_WORLD * zoom
    close_value(transform["screen_scale"], scale, f"{path}.transform.screen_scale")
    origin = transform["design_origin_screen"]
    if not isinstance(origin, list) or len(origin) != 2:
        fail(f"{path}.transform.design_origin_screen: expected pair")
    close_value(origin[0], 0.0, f"{path}.transform.design_origin_screen[0]")
    close_value(origin[1], height - 480.0 * scale, f"{path}.transform.design_origin_screen[1]")

    projected_left = max(0.0, float(origin[0]))
    projected_right = min(float(expected_width), float(origin[0]) + SOURCE_WIDTH * scale)
    if not projected_left.is_integer() or not projected_right.is_integer():
        fail(f"{path}.projected_canvas_interval: matrix boundary must be integral")
    projected_pixels = [int(projected_left), int(projected_right)]
    exact_value(
        state["projected_canvas_interval"],
        [projected_left, projected_right],
        f"{path}.projected_canvas_interval",
    )
    content_intervals = [projected_pixels] if projected_pixels[1] > projected_pixels[0] else []
    exterior_intervals: list[list[int]] = []
    if projected_pixels[0] > 0:
        exterior_intervals.append([0, projected_pixels[0]])
    if projected_pixels[1] < expected_width:
        exterior_intervals.append([projected_pixels[1], expected_width])
    exact_intervals(state["visible_alpha_x_intervals"], content_intervals, f"{path}.visible_alpha_x_intervals")
    exact_intervals(state["pointer_content_x_intervals"], content_intervals, f"{path}.pointer_content_x_intervals")
    exact_intervals(
        state["transparent_exterior_x_intervals"],
        exterior_intervals,
        f"{path}.transparent_exterior_x_intervals",
    )
    for counter in (
        "render_exterior_alpha_pixels", "render_exterior_alpha_columns",
        "uncovered_visible_alpha_pixels", "uncovered_visible_alpha_columns",
        "exterior_clickable_pixels", "exterior_clickable_columns",
        "transparent_sky_pointer_pixels", "transparent_sky_pointer_columns",
    ):
        exact_value(state[counter], 0, f"{path}.{counter}")
    if state_id == "default-50":
        exact_value(state["projected_canvas_interval"], [0.0, 870.0], f"{path}.projected_canvas_interval")
        exact_value(state["pointer_content_x_intervals"], [[0, 870]], f"{path}.pointer_content_x_intervals")
        exact_value(
            state["transparent_exterior_x_intervals"],
            [[870, 1280]],
            f"{path}.transparent_exterior_x_intervals",
        )

    pointer = exact_keys(state["pointer"], {
        "mode", "surface_record_count", "legacy_surface_record_count", "selected_alpha_profile_samples",
        "old_d030_alpha_profile_samples", "polygon_point_count", "top_y_by_column",
        "boundary_sample_step_px", "boundary_taper_columns", "exact_projected_boundary",
    }, f"{path}.pointer")
    exact_value(pointer["mode"], "visible-alpha-content", f"{path}.pointer.mode")
    exact_value(pointer["surface_record_count"], 1, f"{path}.pointer.surface_record_count")
    exact_value(pointer["legacy_surface_record_count"], 0, f"{path}.pointer.legacy_surface_record_count")
    exact_value(pointer["selected_alpha_profile_samples"], 2992, f"{path}.pointer.selected_alpha_profile_samples")
    exact_value(pointer["old_d030_alpha_profile_samples"], 0, f"{path}.pointer.old_d030_alpha_profile_samples")
    if not isinstance(pointer["polygon_point_count"], int) or pointer["polygon_point_count"] < 3:
        fail(f"{path}.pointer.polygon_point_count: invalid polygon")
    tops = pointer["top_y_by_column"]
    if (
        not isinstance(tops, list)
        or len(tops) != expected_width
        or not all(isinstance(top, int) and not isinstance(top, bool) and 0 <= top <= height for top in tops)
    ):
        fail(f"{path}.pointer.top_y_by_column: expected one bounded integer per viewport column")
    for screen_x, top in enumerate(tops):
        inside = projected_pixels[0] <= screen_x < projected_pixels[1]
        if inside and top >= height:
            fail(f"{path}.pointer.top_y_by_column[{screen_x}]: projected content sentinel")
        if not inside and top != height:
            fail(f"{path}.pointer.top_y_by_column[{screen_x}]: exterior is clickable")
    exact_value(pointer["boundary_sample_step_px"], 1, f"{path}.pointer.boundary_sample_step_px")
    exact_value(pointer["boundary_taper_columns"], 0, f"{path}.pointer.boundary_taper_columns")
    exact_value(pointer["exact_projected_boundary"], True, f"{path}.pointer.exact_projected_boundary")

    permanent = exact_keys(state["permanent_state"], {
        "ui_hidden", "visible_control_count", "visible_card_count", "legacy_active_surfaces",
        "legacy_visual_draws_active", "roster_runtime_expected", "roster_draws_active",
        "active_resource_count", "active_resource_paths", "tmp_runtime_dependency", "tmp_dependency_count",
    }, f"{path}.permanent_state")
    for key in ("visible_control_count", "visible_card_count", "legacy_active_surfaces",
                "legacy_visual_draws_active", "roster_draws_active", "tmp_dependency_count"):
        exact_value(permanent[key], 0, f"{path}.permanent_state.{key}")
    exact_value(permanent["ui_hidden"], True, f"{path}.permanent_state.ui_hidden")
    exact_value(permanent["roster_runtime_expected"], False, f"{path}.permanent_state.roster_runtime_expected")
    exact_value(permanent["active_resource_count"], 1, f"{path}.permanent_state.active_resource_count")
    exact_value(permanent["active_resource_paths"], [MEADOW_RESOURCE], f"{path}.permanent_state.active_resource_paths")
    exact_value(permanent["tmp_runtime_dependency"], False, f"{path}.permanent_state.tmp_runtime_dependency")

    captures = exact_keys(state["captures"], {"grid", "clean"}, f"{path}.captures")
    grid_file = validate_capture_record(captures["grid"], "grid", state_id, expected_width, height, f"{path}.captures.grid")
    clean_file = validate_capture_record(captures["clean"], "clean", state_id, expected_width, height, f"{path}.captures.clean")
    return grid_file, clean_file


def validate_matrix_structure(document: Any) -> list[tuple[str, str, dict[str, Any]]]:
    doc = exact_keys(document, {
        "schema", "gate", "profile", "roster_runtime_expected", "runtime_contract",
        "display_topology", "selected_h_contract", "presentation_output_probe", "states",
    }, "matrix")
    exact_value(doc["schema"], SCHEMA, "matrix.schema")
    if doc["gate"] not in (GATE_PRE_CP2, "checkpoint-2"):
        fail(f"matrix.gate: unsupported {doc['gate']!r}")
    exact_value(doc["profile"], PROFILE, "matrix.profile")
    if doc["gate"] == "checkpoint-2" and doc["roster_runtime_expected"] is not True:
        fail("matrix: checkpoint-2 cannot silently skip roster")
    if doc["gate"] == GATE_PRE_CP2:
        exact_value(doc["roster_runtime_expected"], False, "matrix.roster_runtime_expected")
    validate_runtime_contract(doc["runtime_contract"])
    launch_topology = validate_display_topology(doc["display_topology"])
    validate_selected_h_contract(doc["selected_h_contract"])
    validate_output_probe(doc["presentation_output_probe"])
    states = doc["states"]
    if not isinstance(states, list) or len(states) != 12:
        fail(f"matrix.states: expected exactly 12 states, got {len(states) if isinstance(states, list) else 'non-list'}")
    by_id: dict[str, dict[str, Any]] = {}
    for raw_state in states:
        if not isinstance(raw_state, dict) or not isinstance(raw_state.get("id"), str):
            fail("matrix.states: state without string id")
        state_id = raw_state["id"]
        if state_id in by_id:
            fail(f"matrix.states: duplicate {state_id}")
        by_id[state_id] = raw_state
    expected_ids = {f"{profile}-{zoom}" for profile in PROFILES for zoom in ZOOMS}
    if set(by_id) != expected_ids:
        fail(f"matrix.states: coverage mismatch missing={sorted(expected_ids-set(by_id))} unknown={sorted(set(by_id)-expected_ids)}")
    results: list[tuple[str, str, dict[str, Any]]] = []
    usable_rect: list[int] | None = None
    for profile in PROFILES:
        for zoom in ZOOMS:
            state = by_id[f"{profile}-{zoom}"]
            grid_file, clean_file = validate_state(state, profile, zoom, launch_topology)
            current_usable = state["usable_rect"]
            if usable_rect is None:
                usable_rect = current_usable
            elif current_usable != usable_rect:
                fail("matrix.states: usable rect drift within one run")
            results.append((grid_file, clean_file, state))
    return results


def paeth(left: int, up: int, upper_left: int) -> int:
    estimate = left + up - upper_left
    dl = abs(estimate - left)
    du = abs(estimate - up)
    dul = abs(estimate - upper_left)
    return left if dl <= du and dl <= dul else (up if du <= dul else upper_left)


def decode_rgba_png(path: Path) -> tuple[int, int, bytes]:
    data = path.read_bytes()
    if not data.startswith(b"\x89PNG\r\n\x1a\n"):
        fail(f"{path}: not PNG")
    offset = 8
    width = height = 0
    compressed = bytearray()
    seen_ihdr = False
    while offset < len(data):
        if offset + 12 > len(data):
            fail(f"{path}: truncated PNG chunk")
        length = struct.unpack(">I", data[offset:offset + 4])[0]
        kind = data[offset + 4:offset + 8]
        payload = data[offset + 8:offset + 8 + length]
        crc = data[offset + 8 + length:offset + 12 + length]
        if len(payload) != length or len(crc) != 4:
            fail(f"{path}: truncated PNG payload")
        if zlib.crc32(kind + payload) & 0xFFFFFFFF != struct.unpack(">I", crc)[0]:
            fail(f"{path}: PNG CRC mismatch")
        offset += 12 + length
        if kind == b"IHDR":
            if length != 13 or seen_ihdr:
                fail(f"{path}: invalid IHDR")
            width, height, depth, color, compression, filtering, interlace = struct.unpack(">IIBBBBB", payload)
            if depth != 8 or color != 6 or compression != 0 or filtering != 0 or interlace != 0:
                fail(f"{path}: expected non-interlaced RGBA8 PNG")
            seen_ihdr = True
        elif kind == b"IDAT":
            compressed.extend(payload)
        elif kind == b"IEND":
            break
    if not seen_ihdr or width < 1 or height < 1:
        fail(f"{path}: missing dimensions")
    try:
        raw = zlib.decompress(bytes(compressed))
    except zlib.error as exc:
        fail(f"{path}: corrupt IDAT: {exc}")
    stride = width * 4
    if len(raw) != height * (stride + 1):
        fail(f"{path}: unexpected decoded length")
    result = bytearray(height * stride)
    previous = bytearray(stride)
    source_offset = 0
    for y in range(height):
        filter_type = raw[source_offset]
        source_offset += 1
        scanline = bytearray(raw[source_offset:source_offset + stride])
        source_offset += stride
        for x in range(stride):
            left = scanline[x - 4] if x >= 4 else 0
            up = previous[x]
            upper_left = previous[x - 4] if x >= 4 else 0
            if filter_type == 1:
                scanline[x] = (scanline[x] + left) & 0xFF
            elif filter_type == 2:
                scanline[x] = (scanline[x] + up) & 0xFF
            elif filter_type == 3:
                scanline[x] = (scanline[x] + ((left + up) // 2)) & 0xFF
            elif filter_type == 4:
                scanline[x] = (scanline[x] + paeth(left, up, upper_left)) & 0xFF
            elif filter_type != 0:
                fail(f"{path}: unsupported PNG filter {filter_type}")
        result[y * stride:(y + 1) * stride] = scanline
        previous = scanline
    return width, height, bytes(result)


def alpha_top_by_column(rgba: bytes, width: int, height: int) -> list[int]:
    tops = [height] * width
    for y in range(height):
        row_offset = y * width * 4
        for x in range(width):
            if tops[x] == height and rgba[row_offset + x * 4 + 3] > 0:
                tops[x] = y
    return tops


def columns_to_intervals(columns: list[int]) -> list[list[int]]:
    if not columns:
        return []
    intervals: list[list[int]] = []
    start = previous = columns[0]
    for value in columns[1:]:
        if value != previous + 1:
            intervals.append([start, previous + 1])
            start = value
        previous = value
    intervals.append([start, previous + 1])
    return intervals


def d034_image_profile_metrics_reference(
    alpha_bytes: bytes,
    width: int,
    height: int,
    projected_pixels: tuple[int, int],
) -> tuple[dict[str, Any], int]:
    alpha_top_by_column: list[int] = []
    visible_columns: list[int] = []
    exterior_alpha_pixels = 0
    exterior_alpha_columns = 0
    pixel_reads = 0
    for screen_x in range(width):
        alpha_top = height
        exterior_column_alpha_pixels = 0
        for screen_y in range(height):
            pixel_reads += 1
            if alpha_bytes[screen_y * width + screen_x] <= 0:
                continue
            if alpha_top == height:
                alpha_top = screen_y
            if screen_x < projected_pixels[0] or screen_x >= projected_pixels[1]:
                exterior_column_alpha_pixels += 1
        alpha_top_by_column.append(alpha_top)
        if alpha_top < height:
            visible_columns.append(screen_x)
        if exterior_column_alpha_pixels > 0:
            exterior_alpha_pixels += exterior_column_alpha_pixels
            exterior_alpha_columns += 1
    return {
        "ok": True,
        "alpha_top_by_column": alpha_top_by_column,
        "visible_alpha_x_intervals": columns_to_intervals(visible_columns),
        "render_exterior_alpha_pixels": exterior_alpha_pixels,
        "render_exterior_alpha_columns": exterior_alpha_columns,
    }, pixel_reads


def d034_image_profile_metrics_optimized(
    alpha_bytes: bytes,
    width: int,
    height: int,
    projected_pixels: tuple[int, int],
) -> tuple[dict[str, Any], int]:
    alpha_top_by_column: list[int] = []
    visible_columns: list[int] = []
    exterior_alpha_pixels = 0
    exterior_alpha_columns = 0
    pixel_reads = 0
    for screen_x in range(width):
        alpha_top = height
        exterior_column_alpha_pixels = 0
        is_exterior = screen_x < projected_pixels[0] or screen_x >= projected_pixels[1]
        for screen_y in range(height):
            pixel_reads += 1
            if alpha_bytes[screen_y * width + screen_x] <= 0:
                continue
            if alpha_top == height:
                alpha_top = screen_y
            if not is_exterior:
                break
            exterior_column_alpha_pixels += 1
        alpha_top_by_column.append(alpha_top)
        if alpha_top < height:
            visible_columns.append(screen_x)
        if exterior_column_alpha_pixels > 0:
            exterior_alpha_pixels += exterior_column_alpha_pixels
            exterior_alpha_columns += 1
    return {
        "ok": True,
        "alpha_top_by_column": alpha_top_by_column,
        "visible_alpha_x_intervals": columns_to_intervals(visible_columns),
        "render_exterior_alpha_pixels": exterior_alpha_pixels,
        "render_exterior_alpha_columns": exterior_alpha_columns,
    }, pixel_reads


def validate_d034_metric_optimization_source(repo_root: Path) -> None:
    demo_path = repo_root / "steam/scripts/prototypes/vertical_slice/vertical_slice_demo.gd"
    source = demo_path.read_text(encoding="utf-8")
    function_start = source.find("func _d034_image_profile_metrics(image: Image) -> Dictionary:")
    if function_start < 0:
        fail("d034 metric optimization: function missing")
    function_end = source.find("\n\nfunc ", function_start + 1)
    if function_end < 0:
        fail("d034 metric optimization: function boundary missing")
    function_body = source[function_start:function_end]
    is_exterior = (
        "var is_exterior := "
        "screen_x < projected_pixels.x or screen_x >= projected_pixels.y"
    )
    if is_exterior not in function_body:
        fail("d034 metric optimization: per-column exterior classification missing")
    shortcut_index = function_body.find("if not is_exterior:")
    break_index = function_body.find("break", shortcut_index)
    counter_index = function_body.find("exterior_column_alpha_pixels += 1", break_index)
    if shortcut_index < 0 or break_index < 0 or counter_index < 0:
        fail("d034 metric optimization: interior break/exterior full-scan ordering missing")
    for mutation in ("set_pixel(", "fill(", "blit_rect(", "resize(", "convert("):
        if mutation in function_body:
            fail(f"d034 metric optimization: image mutation forbidden: {mutation}")


def validate_d034_metric_optimization_differential(repo_root: Path) -> dict[str, Any]:
    fixtures = [
        (
            "interior-exterior-mixed-top-offset-boundary",
            8,
            6,
            (2, 6),
            bytes([
                0, 0, 0, 255, 0, 64, 0, 255,
                0, 32, 0, 0, 0, 0, 0, 0,
                255, 0, 128, 0, 0, 255, 16, 0,
                0, 96, 0, 0, 0, 0, 0, 0,
                128, 0, 255, 0, 0, 32, 8, 255,
                0, 48, 0, 255, 0, 0, 0, 0,
            ]),
        ),
        (
            "empty-transparent",
            5,
            4,
            (0, 5),
            bytes(20),
        ),
        (
            "all-exterior-mixed-alpha",
            4,
            5,
            (2, 2),
            bytes([
                0, 1, 0, 255,
                2, 0, 0, 0,
                0, 3, 4, 0,
                5, 0, 0, 6,
                0, 7, 8, 9,
            ]),
        ),
        (
            "projected-boundaries",
            6,
            5,
            (1, 5),
            bytes([
                255, 0, 0, 0, 0, 1,
                0, 2, 0, 0, 3, 0,
                4, 0, 0, 0, 0, 5,
                0, 6, 0, 0, 7, 0,
                8, 0, 9, 0, 0, 10,
            ]),
        ),
    ]
    expected_field_order = [
        "ok",
        "alpha_top_by_column",
        "visible_alpha_x_intervals",
        "render_exterior_alpha_pixels",
        "render_exterior_alpha_columns",
    ]
    expected_fields = set(expected_field_order)
    reference_reads = 0
    optimized_reads = 0
    fixture_hashes: list[str] = []
    for name, width, height, projected_pixels, alpha_bytes in fixtures:
        projected_before = projected_pixels
        before_bytes = bytes(alpha_bytes)
        before_hash = hashlib.sha256(before_bytes).hexdigest()
        reference, fixture_reference_reads = d034_image_profile_metrics_reference(
            alpha_bytes, width, height, projected_pixels
        )
        optimized, fixture_optimized_reads = d034_image_profile_metrics_optimized(
            alpha_bytes, width, height, projected_pixels
        )
        exact_value(set(reference), expected_fields, f"d034_differential.{name}.reference_fields")
        exact_value(set(optimized), expected_fields, f"d034_differential.{name}.optimized_fields")
        exact_value(
            list(reference),
            expected_field_order,
            f"d034_differential.{name}.reference_field_order",
        )
        exact_value(
            list(optimized),
            expected_field_order,
            f"d034_differential.{name}.optimized_field_order",
        )
        exact_value(optimized, reference, f"d034_differential.{name}.metrics")
        exact_value(projected_pixels, projected_before, f"d034_differential.{name}.projected")
        exact_value(alpha_bytes, before_bytes, f"d034_differential.{name}.bytes")
        exact_value(
            hashlib.sha256(alpha_bytes).hexdigest(),
            before_hash,
            f"d034_differential.{name}.sha256",
        )
        reference_reads += fixture_reference_reads
        optimized_reads += fixture_optimized_reads
        fixture_hashes.append(before_hash)
    if optimized_reads >= reference_reads:
        fail(
            "d034 metric optimization: fixtures did not prove fewer reads "
            f"reference={reference_reads} optimized={optimized_reads}"
        )
    validate_d034_metric_optimization_source(repo_root)
    return {
        "case_count": len(fixtures),
        "field_count": len(expected_fields),
        "reference_reads": reference_reads,
        "optimized_reads": optimized_reads,
        "fixture_digest": hashlib.sha256("".join(fixture_hashes).encode("ascii")).hexdigest(),
    }


def exterior_alpha_counts(
    rgba: bytes,
    width: int,
    height: int,
    projected_left: int,
    projected_right: int,
) -> tuple[int, int]:
    pixels = 0
    columns = 0
    for x in list(range(0, projected_left)) + list(range(projected_right, width)):
        column_pixels = 0
        for y in range(height):
            if rgba[(y * width + x) * 4 + 3] > 0:
                column_pixels += 1
        if column_pixels:
            pixels += column_pixels
            columns += 1
    return pixels, columns


def validate_pair(capture_root: Path, grid_name: str, clean_name: str, state: dict[str, Any]) -> dict[str, Any]:
    grid_path = capture_root / grid_name
    clean_path = capture_root / clean_name
    if not grid_path.is_file() or not clean_path.is_file():
        fail(f"capture pair missing: {grid_name} / {clean_name}")
    gw, gh, grid = decode_rgba_png(grid_path)
    cw, ch, clean = decode_rgba_png(clean_path)
    if (gw, gh) != (cw, ch) or [gw, gh] != state["actual_window_size"]:
        fail(f"{state['id']}: capture dimensions mismatch")
    origin_x, origin_y = state["transform"]["design_origin_screen"]
    scale = state["transform"]["screen_scale"]
    projected_left_f = max(0.0, float(origin_x))
    projected_right_f = min(float(gw), float(origin_x) + SOURCE_WIDTH * float(scale))
    if not projected_left_f.is_integer() or not projected_right_f.is_integer():
        fail(f"{state['id']}: non-integral governed projected canvas boundary")
    projected_left = int(projected_left_f)
    projected_right = int(projected_right_f)
    exact_value(
        state["projected_canvas_interval"],
        [projected_left_f, projected_right_f],
        f"{state['id']}.projected_canvas_interval",
    )

    grid_tops = alpha_top_by_column(grid, gw, gh)
    clean_tops = alpha_top_by_column(clean, cw, ch)
    if grid_tops != clean_tops:
        fail(f"{state['id']}: GRID/CLEAN visible-alpha top profiles differ")
    actual_visible_intervals = columns_to_intervals([x for x, top in enumerate(clean_tops) if top < ch])
    exact_value(
        state["visible_alpha_x_intervals"],
        actual_visible_intervals,
        f"{state['id']}.visible_alpha_x_intervals",
    )
    expected_content_intervals = [[projected_left, projected_right]] if projected_right > projected_left else []
    exact_value(actual_visible_intervals, expected_content_intervals, f"{state['id']}.render_domain")

    grid_exterior_pixels, grid_exterior_columns = exterior_alpha_counts(
        grid, gw, gh, projected_left, projected_right
    )
    clean_exterior_pixels, clean_exterior_columns = exterior_alpha_counts(
        clean, cw, ch, projected_left, projected_right
    )
    exact_value(
        state["render_exterior_alpha_pixels"],
        grid_exterior_pixels + clean_exterior_pixels,
        f"{state['id']}.render_exterior_alpha_pixels",
    )
    exact_value(
        state["render_exterior_alpha_columns"],
        max(grid_exterior_columns, clean_exterior_columns),
        f"{state['id']}.render_exterior_alpha_columns",
    )
    if grid_exterior_pixels or clean_exterior_pixels:
        fail(f"{state['id']}: whole-tile render overdraw escaped projected canvas")

    pointer_tops = state["pointer"]["top_y_by_column"]
    if pointer_tops != clean_tops:
        fail(f"{state['id']}: pointer top is not exact actual visible-alpha top")
    pointer_intervals = columns_to_intervals([x for x, top in enumerate(pointer_tops) if top < ch])
    exact_value(
        state["pointer_content_x_intervals"],
        pointer_intervals,
        f"{state['id']}.pointer_content_x_intervals",
    )
    exact_value(pointer_intervals, expected_content_intervals, f"{state['id']}.pointer_domain")

    uncovered_pixels = uncovered_columns = 0
    sky_pointer_pixels = sky_pointer_columns = 0
    exterior_clickable_pixels = exterior_clickable_columns = 0
    for x, (visible_top, pointer_top) in enumerate(zip(clean_tops, pointer_tops)):
        if visible_top < pointer_top:
            uncovered_columns += 1
            for y in range(visible_top, pointer_top):
                if clean[(y * cw + x) * 4 + 3] > 0:
                    uncovered_pixels += 1
        elif pointer_top < visible_top:
            sky_pointer_columns += 1
            sky_pointer_pixels += visible_top - pointer_top
        if not projected_left <= x < projected_right and pointer_top < ch:
            exterior_clickable_columns += 1
            exterior_clickable_pixels += ch - pointer_top
    exact_value(
        state["uncovered_visible_alpha_pixels"],
        uncovered_pixels,
        f"{state['id']}.uncovered_visible_alpha_pixels",
    )
    exact_value(
        state["uncovered_visible_alpha_columns"],
        uncovered_columns,
        f"{state['id']}.uncovered_visible_alpha_columns",
    )
    exact_value(
        state["exterior_clickable_pixels"],
        exterior_clickable_pixels,
        f"{state['id']}.exterior_clickable_pixels",
    )
    exact_value(
        state["exterior_clickable_columns"],
        exterior_clickable_columns,
        f"{state['id']}.exterior_clickable_columns",
    )
    exact_value(
        state["transparent_sky_pointer_pixels"],
        sky_pointer_pixels,
        f"{state['id']}.transparent_sky_pointer_pixels",
    )
    exact_value(
        state["transparent_sky_pointer_columns"],
        sky_pointer_columns,
        f"{state['id']}.transparent_sky_pointer_columns",
    )
    if any((uncovered_pixels, uncovered_columns, exterior_clickable_pixels,
            exterior_clickable_columns, sky_pointer_pixels, sky_pointer_columns)):
        fail(f"{state['id']}: render/pointer per-column/per-alpha equivalence failed")

    allowed_x0 = max(0, math.floor(origin_x + 2.0 * scale))
    allowed_x1 = min(gw, math.ceil(origin_x + 2990.0 * scale))
    allowed_y0 = max(0, math.floor(origin_y + 441.0 * scale))
    allowed_y1 = min(gh, math.ceil(origin_y + 473.0 * scale))
    diff_count = 0
    outside = 0
    alpha_diff = 0
    min_x, min_y, max_x, max_y = gw, gh, -1, -1
    for pixel_index in range(gw * gh):
        offset = pixel_index * 4
        if grid[offset:offset + 4] == clean[offset:offset + 4]:
            continue
        x = pixel_index % gw
        y = pixel_index // gw
        diff_count += 1
        if not (allowed_x0 <= x < allowed_x1 and allowed_y0 <= y < allowed_y1):
            outside += 1
        if grid[offset + 3] != clean[offset + 3]:
            alpha_diff += 1
        min_x, min_y = min(min_x, x), min(min_y, y)
        max_x, max_y = max(max_x, x), max(max_y, y)
    if diff_count == 0:
        fail(f"{state['id']}: GRID/CLEAN are identical")
    if outside != 0:
        fail(f"{state['id']}: {outside} differing pixels outside projected GRID32 band")
    if alpha_diff != 0:
        fail(f"{state['id']}: GRID/CLEAN changed window alpha")
    return {
        "id": state["id"],
        "grid_file": grid_name,
        "grid_sha256": sha256_file(grid_path),
        "clean_file": clean_name,
        "clean_sha256": sha256_file(clean_path),
        "dimensions": [gw, gh],
        "difference_pixels": diff_count,
        "difference_bbox_half_open": [min_x, min_y, max_x + 1, max_y + 1],
        "allowed_bbox_half_open": [allowed_x0, allowed_y0, allowed_x1, allowed_y1],
        "difference_outside_allowed": outside,
        "alpha_difference_pixels": alpha_diff,
        "projected_canvas_interval": [projected_left_f, projected_right_f],
        "visible_alpha_x_intervals": actual_visible_intervals,
        "pointer_content_x_intervals": pointer_intervals,
        "transparent_exterior_x_intervals": state["transparent_exterior_x_intervals"],
        "render_exterior_alpha_pixels": grid_exterior_pixels + clean_exterior_pixels,
        "uncovered_visible_alpha_pixels": uncovered_pixels,
        "exterior_clickable_pixels": exterior_clickable_pixels,
        "transparent_sky_pointer_pixels": sky_pointer_pixels,
    }


PROCESS_RESULT_KEYS = {
    "HOME", "argv", "binary", "capture_manifest_seal_eligible", "cwd", "diagnostic_matches",
    "diagnostic_verdict", "elapsed_seconds", "end_timestamp", "exact_pid_sigterm_sent_at",
    "exit_code", "expected_version", "final_exact_pid_alive", "imported_test_seam", "pid",
    "process_verdict", "profile", "project", "project_control_quit_acknowledged",
    "project_control_quit_acknowledged_at", "project_control_quit_request_path",
    "project_control_quit_request_sha256", "project_control_quit_requested_at", "project_godot_sha256",
    "raw_logs_finalized", "ready_observed", "requested_stop_method", "schema", "start_timestamp",
    "stderr", "stdout", "supervisor_rc", "supervisor_rc_name", "terminating_signal_name",
    "terminating_signal_number", "version", "version_verified",
}


def validate_process_outcome_values(process_verdict: Any, diagnostic_verdict: Any) -> None:
    exact_value(process_verdict, "PASS", "process_result.process_verdict")
    exact_value(diagnostic_verdict, "PASS", "process_result.diagnostic_verdict")


def validate_stream_record(value: Any, raw_path: Path, path: str) -> None:
    stream = exact_keys(value, {"byte_count", "sha256"}, path)
    data = raw_path.read_bytes()
    exact_value(stream["byte_count"], len(data), f"{path}.byte_count")
    exact_value(stream["sha256"], hashlib.sha256(data).hexdigest(), f"{path}.sha256")


def validate_process_result(
    value: Any,
    repo_root: Path,
    observer_home: Path,
    stdout_path: Path,
    stderr_path: Path,
) -> None:
    result = exact_keys(value, PROCESS_RESULT_KEYS, "process_result")
    binary = str(Path.home() / "Library/Application Support/Steam/steamapps/common/Godot Engine/Godot.app/Contents/MacOS/Godot")
    project = str(repo_root / "steam")
    expected_argv = [binary, "--path", project, "--", OBSERVER_FLAG]
    exact_value(result["schema"], "shelter.godot-process-result.v1", "process_result.schema")
    exact_value(result["profile"], "ordinary-player", "process_result.profile")
    exact_value(result["binary"], binary, "process_result.binary")
    exact_value(result["project"], project, "process_result.project")
    exact_value(result["cwd"], project, "process_result.cwd")
    exact_value(result["HOME"], str(observer_home), "process_result.HOME")
    exact_value(result["argv"], expected_argv, "process_result.argv")
    exact_value(result["expected_version"], EXPECTED_VERSION, "process_result.expected_version")
    exact_value(result["version"], EXPECTED_VERSION, "process_result.version")
    exact_value(result["version_verified"], True, "process_result.version_verified")
    exact_value(result["project_godot_sha256"], EXPECTED_GODOT_SHA256, "process_result.project_godot_sha256")
    validate_process_outcome_values(result["process_verdict"], result["diagnostic_verdict"])
    exact_value(result["diagnostic_matches"], [], "process_result.diagnostic_matches")
    exact_value(result["exit_code"], 0, "process_result.exit_code")
    exact_value(result["supervisor_rc"], 0, "process_result.supervisor_rc")
    exact_value(result["supervisor_rc_name"], "PASS", "process_result.supervisor_rc_name")
    exact_value(result["capture_manifest_seal_eligible"], True, "process_result.capture_manifest_seal_eligible")
    exact_value(result["raw_logs_finalized"], True, "process_result.raw_logs_finalized")
    exact_value(result["ready_observed"], True, "process_result.ready_observed")
    exact_value(result["final_exact_pid_alive"], False, "process_result.final_exact_pid_alive")
    exact_value(result["imported_test_seam"], False, "process_result.imported_test_seam")
    exact_value(result["requested_stop_method"], "project_control_quit", "process_result.requested_stop_method")
    exact_value(result["project_control_quit_acknowledged"], True, "process_result.project_control_quit_acknowledged")
    exact_value(result["project_control_quit_request_path"], "user://d029-observer-control/quit.request", "process_result.project_control_quit_request_path")
    exact_value(result["terminating_signal_name"], None, "process_result.terminating_signal_name")
    exact_value(result["terminating_signal_number"], None, "process_result.terminating_signal_number")
    exact_value(result["exact_pid_sigterm_sent_at"], None, "process_result.exact_pid_sigterm_sent_at")
    validate_stream_record(result["stdout"], stdout_path, "process_result.stdout")
    validate_stream_record(result["stderr"], stderr_path, "process_result.stderr")
    stdout_text = stdout_path.read_text(encoding="utf-8")
    marker = (
        "d030_selected_h_current_presentation=ready_for_independent_verification "
        f"schema={SCHEMA} gate={GATE_PRE_CP2} states=12 captures=24"
    )
    if marker not in stdout_text:
        fail("process stdout: D-032 completion marker missing")


def validate_sources(repo_root: Path) -> dict[str, str]:
    observed: dict[str, str] = {}
    for relative, expected in SOURCE_HASHES.items():
        path = repo_root / relative
        if not path.is_file():
            fail(f"source missing: {relative}")
        actual = sha256_file(path)
        exact_value(actual, expected, f"source[{relative}]")
        observed[relative] = actual
    return observed


def atomic_write_json(path: Path, value: Any) -> None:
    part = path.with_name(path.name + ".part")
    part.write_text(json.dumps(value, ensure_ascii=False, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    os.replace(part, path)


def validate_command(args: argparse.Namespace) -> int:
    repo_root = Path(__file__).resolve().parents[3]
    matrix_path = args.matrix.resolve()
    capture_root = matrix_path.parent
    document = load_json(matrix_path)
    pairs = validate_matrix_structure(document)
    if document["gate"] != GATE_PRE_CP2:
        fail(f"author runner requires gate {GATE_PRE_CP2}")
    pair_results = [validate_pair(capture_root, grid, clean, state) for grid, clean, state in pairs]
    process_result = load_json(args.process_result.resolve())
    validate_process_result(
        process_result,
        repo_root,
        args.observer_home.resolve(),
        args.stdout.resolve(),
        args.stderr.resolve(),
    )
    source_results = validate_sources(repo_root)
    result = {
        "schema": "shelter.d030-selected-h-current-presentation-validation.v1",
        "author_result": "READY FOR INDEPENDENT MECHANICAL VERIFICATION",
        "profile_pass_claimed": False,
        "checkpoint_2_authorized": False,
        "gate": GATE_PRE_CP2,
        "matrix_sha256": sha256_file(matrix_path),
        "process_result_sha256": sha256_file(args.process_result.resolve()),
        "state_count": len(pair_results),
        "capture_count": len(pair_results) * 2,
        "sources": source_results,
        "pairs": pair_results,
    }
    atomic_write_json(args.output.resolve(), result)
    print(
        "d030_current_profile_validator=PASS "
        "states=12 captures=24 gate=pre-checkpoint-2 "
        "author_result=READY_FOR_INDEPENDENT_MECHANICAL_VERIFICATION"
    )
    return 0


def fixture_state(profile: str, zoom_percent: int) -> dict[str, Any]:
    usable = [0, 38, 2992, 1800]
    width = {"min": 720, "default": 1280, "max": 2992}[profile]
    height_values = expected_height_contract(zoom_percent, usable[3], CURRENT_HOST_NATIVE_HEIGHT_Q)
    height = int(height_values["requested"])
    zoom = zoom_percent / 100.0
    scale = SOURCE_TO_WORLD * zoom
    camera_max = max(WORLD_WIDTH - width / zoom, 0.0)
    pan = {
        "threshold_screen_px": 8.0,
        "camera_max": camera_max,
        "eligible": camera_max > 0,
        "below_threshold_consumed": False,
        "below_threshold_release_consumed": False,
        "above_threshold_consumed": camera_max > 0,
        "above_threshold_release_consumed": camera_max > 0,
        "camera_after_above_threshold": min(camera_max, 9.0 / zoom) if camera_max > 0 else 0.0,
        "negative_clamp": 0.0,
        "overflow_clamp": camera_max,
        "checkpoint_unchanged": True,
        "events_unchanged": True,
        "release_no_click": True,
    }
    state_id = f"{profile}-{zoom_percent}"
    pointer_top = min(height - 1.0, max(1.0, height * 0.5))
    projected_right = min(width, int(round(SOURCE_WIDTH * scale)))
    content_intervals = [[0, projected_right]] if projected_right > 0 else []
    exterior_intervals = [[projected_right, width]] if projected_right < width else []
    pointer_tops = [int(pointer_top) if x < projected_right else height for x in range(width)]
    capture = lambda kind: {
        "file": f"{state_id}-{kind}.png",
        "width": width,
        "height": height,
        "grid_visible": kind == "grid",
        "draw_bindings": ["selected_h.background", "selected_h.grid"] if kind == "grid" else ["selected_h.background"],
    }
    return {
        "id": state_id,
        "window_profile": profile,
        "zoom_percent": zoom_percent,
        "profile_width": width,
        "dynamic_height_expected": height,
        "actual_window_size": [width, height],
        "viewport_size": [width, height],
        "usable_rect": usable,
        "height_contract": {
            "content": height_values["content"],
            "required": height_values["required"],
            "scale_list": [2.0],
            "q": CURRENT_HOST_NATIVE_HEIGHT_Q,
            "usable_q": height_values["usable_q"],
            "requested": height,
            "actual": [width, height],
        },
        "camera": {
            "default_x": 0.0,
            "actual_x": 0.0,
            "max_x": camera_max,
            "visible_world_width": width / zoom,
            "extent_mode": "visible-extent-no-reserve",
            "default_reset": True,
            "pan_probe": pan,
        },
        "transform": {
            "design_canvas": [2992, 480],
            "design_to_world": SOURCE_TO_WORLD,
            "screen_scale": scale,
            "design_origin_screen": [0.0, height - 480.0 * scale],
        },
        "projected_canvas_interval": [0.0, float(projected_right)],
        "visible_alpha_x_intervals": copy.deepcopy(content_intervals),
        "pointer_content_x_intervals": copy.deepcopy(content_intervals),
        "transparent_exterior_x_intervals": exterior_intervals,
        "render_exterior_alpha_pixels": 0,
        "render_exterior_alpha_columns": 0,
        "uncovered_visible_alpha_pixels": 0,
        "uncovered_visible_alpha_columns": 0,
        "exterior_clickable_pixels": 0,
        "exterior_clickable_columns": 0,
        "transparent_sky_pointer_pixels": 0,
        "transparent_sky_pointer_columns": 0,
        "pointer": {
            "mode": "visible-alpha-content",
            "surface_record_count": 1,
            "legacy_surface_record_count": 0,
            "selected_alpha_profile_samples": 2992,
            "old_d030_alpha_profile_samples": 0,
            "polygon_point_count": 100,
            "top_y_by_column": pointer_tops,
            "boundary_sample_step_px": 1,
            "boundary_taper_columns": 0,
            "exact_projected_boundary": True,
        },
        "permanent_state": {
            "ui_hidden": True,
            "visible_control_count": 0,
            "visible_card_count": 0,
            "legacy_active_surfaces": 0,
            "legacy_visual_draws_active": 0,
            "roster_runtime_expected": False,
            "roster_draws_active": 0,
            "active_resource_count": 1,
            "active_resource_paths": [MEADOW_RESOURCE],
            "tmp_runtime_dependency": False,
            "tmp_dependency_count": 0,
        },
        "captures": {"grid": capture("grid"), "clean": capture("clean")},
    }


def valid_fixture() -> dict[str, Any]:
    checkpoint = {"checkpoint_kind": "first_day_offered", "checkpoint_sequence": 1}
    return {
        "schema": SCHEMA,
        "gate": GATE_PRE_CP2,
        "profile": PROFILE,
        "roster_runtime_expected": False,
        "runtime_contract": copy.deepcopy(RUNTIME_CONTRACT),
        "display_topology": {
            "screen_count": 1,
            "scale_list": [2.0],
            "q": CURRENT_HOST_NATIVE_HEIGHT_Q,
            "stable": True,
        },
        "selected_h_contract": copy.deepcopy(SELECTED_H_CONTRACT),
        "presentation_output_probe": {
            "checkpoint_before": checkpoint,
            "checkpoint_after": copy.deepcopy(checkpoint),
            "event_count_before": 1,
            "event_count_after": 1,
            "checkpoint_unchanged": True,
            "events_unchanged": True,
            "checkpoint_contains_presentation_fields": False,
        },
        "states": [fixture_state(profile, zoom) for profile in PROFILES for zoom in ZOOMS],
    }


def expect_rejected(name: str, mutator: Any) -> None:
    fixture = valid_fixture()
    mutator(fixture)
    try:
        validate_matrix_structure(fixture)
    except ValidationError:
        return
    fail(f"self-test {name}: invalid fixture was accepted")


def fixture_state_by_id(document: dict[str, Any], state_id: str) -> dict[str, Any]:
    for state in document["states"]:
        if state["id"] == state_id:
            return state
    fail(f"fixture state missing: {state_id}")


def mutate_unquantized_419(document: dict[str, Any]) -> None:
    state = fixture_state_by_id(document, "min-150")
    state["height_contract"]["requested"] = 419


def mutate_wrong_q(document: dict[str, Any]) -> None:
    document["display_topology"]["q"] = 1


def mutate_non_integral_scale(document: dict[str, Any]) -> None:
    document["display_topology"]["scale_list"] = [1.5]


def mutate_request_readback_mismatch(document: dict[str, Any]) -> None:
    state = fixture_state_by_id(document, "min-150")
    state["height_contract"]["actual"] = [720, 419]


def mutate_topology_drift(document: dict[str, Any]) -> None:
    state = fixture_state_by_id(document, "max-200")
    state["height_contract"]["scale_list"] = [2.0, 1.0]


def mutate_whole_tile_overdraw(document: dict[str, Any]) -> None:
    state = fixture_state_by_id(document, "default-50")
    state["render_exterior_alpha_pixels"] = 1


def mutate_visible_alpha_without_pointer(document: dict[str, Any]) -> None:
    state = fixture_state_by_id(document, "default-50")
    state["uncovered_visible_alpha_pixels"] = 1
    state["uncovered_visible_alpha_columns"] = 1


def mutate_pointer_in_exterior(document: dict[str, Any]) -> None:
    state = fixture_state_by_id(document, "default-50")
    state["pointer"]["top_y_by_column"][870] = state["actual_window_size"][1] - 1


def mutate_four_pixel_taper(document: dict[str, Any]) -> None:
    state = fixture_state_by_id(document, "default-50")
    state["pointer"]["boundary_sample_step_px"] = 4
    state["pointer"]["boundary_taper_columns"] = 4
    state["pointer"]["exact_projected_boundary"] = False


def self_test_command(_: argparse.Namespace) -> int:
    differential = validate_d034_metric_optimization_differential(
        Path(__file__).resolve().parents[3]
    )
    green_fixture = valid_fixture()
    validate_matrix_structure(green_fixture)
    exterior_state = fixture_state_by_id(green_fixture, "default-50")
    exterior_height = exterior_state["actual_window_size"][1]
    exact_value(
        exterior_state["pointer"]["top_y_by_column"][870:],
        [exterior_height] * (1280 - 870),
        "self_test.legitimate_exterior_sentinel",
    )
    cases = [
        ("old-15-percent-reserve", lambda d: d["runtime_contract"].__setitem__("artificial_exterior_reserve_fraction", 0.15)),
        ("fixed-224-height", lambda d: (d["runtime_contract"].__setitem__("companion_height_mode", "fixed"), d["runtime_contract"].__setitem__("fixed_height_px", 224))),
        ("controls-only-passthrough", lambda d: d["states"][0]["pointer"].__setitem__("mode", "controls-only")),
        ("whole-window-passthrough", lambda d: d["states"][0]["pointer"].__setitem__("mode", "whole-window-through")),
        ("missing-state", lambda d: d["states"].pop()),
        ("missing-clean-partner", lambda d: d["states"][0]["captures"].pop("clean")),
        ("checkpoint-2-roster-skip", lambda d: d.__setitem__("gate", "checkpoint-2")),
        ("unknown-field", lambda d: d.__setitem__("unexpected", True)),
        ("unquantized-419", mutate_unquantized_419),
        ("wrong-q", mutate_wrong_q),
        ("non-integral-scale", mutate_non_integral_scale),
        ("request-readback-mismatch", mutate_request_readback_mismatch),
        ("topology-drift", mutate_topology_drift),
        ("whole-tile-overdraw", mutate_whole_tile_overdraw),
        ("visible-alpha-without-pointer", mutate_visible_alpha_without_pointer),
        ("pointer-in-true-exterior", mutate_pointer_in_exterior),
        ("four-pixel-taper", mutate_four_pixel_taper),
    ]
    for name, mutator in cases:
        expect_rejected(name, mutator)
    try:
        validate_process_outcome_values("PASS", "FAIL")
    except ValidationError:
        pass
    else:
        fail("self-test process-pass-diagnostic-fail: invalid outcome accepted")
    print(f"d030_current_profile_self_test=PASS green=2 red={len(cases)+1}")
    print(
        "d034_image_profile_metrics_differential=PASS "
        f"cases={differential['case_count']} fields={differential['field_count']} "
        f"reads={differential['reference_reads']}->{differential['optimized_reads']} "
        f"fixture_digest={differential['fixture_digest']}"
    )
    return 0


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description=__doc__)
    subparsers = parser.add_subparsers(dest="command", required=True)
    self_test = subparsers.add_parser("self-test")
    self_test.set_defaults(handler=self_test_command)
    validate = subparsers.add_parser("validate")
    validate.add_argument("--matrix", type=Path, required=True)
    validate.add_argument("--process-result", type=Path, required=True)
    validate.add_argument("--stdout", type=Path, required=True)
    validate.add_argument("--stderr", type=Path, required=True)
    validate.add_argument("--observer-home", type=Path, required=True)
    validate.add_argument("--output", type=Path, required=True)
    validate.set_defaults(handler=validate_command)
    return parser


def main() -> int:
    args = build_parser().parse_args()
    try:
        return int(args.handler(args))
    except ValidationError as exc:
        print(f"d030_current_profile_validator=FAIL detail={exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
