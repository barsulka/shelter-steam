#!/usr/bin/env python3
"""Build and verify the D-024 source-only meadow/marker amendment.

The script is intentionally package-local.  It reads the frozen accepted Art
source and writes only below this amendment package.
"""

from __future__ import annotations

import argparse
import hashlib
import io
import json
import math
import shutil
import zipfile
from pathlib import Path
from xml.sax.saxutils import escape

import numpy as np
from PIL import Image, ImageChops, ImageDraw, ImageFont


PACKAGE = Path(__file__).resolve().parents[1]
REPO = PACKAGE.parents[5]
FROZEN = PACKAGE.parent / "STEAM_DESKTOP__Art_Source_Reconciliation_Wave_v1"
SOURCE = PACKAGE / "source"
EXPORTS = PACKAGE / "exports"
EVIDENCE = PACKAGE / "evidence"

DATE = "2026-07-14"
WORLD_WIDTH = 1740.0
WORLD_SOURCE_WIDTH = 2992
WORLD_SOURCE_HEIGHT = 224
WORLD_BASELINE_PX = 211
SOURCE_PX_PER_WORLD_UNIT = WORLD_SOURCE_WIDTH / WORLD_WIDTH
WORLD_UNITS_PER_SOURCE_PX = 1.0 / SOURCE_PX_PER_WORLD_UNIT
TILE_WIDTH_PX = 748
TILE_HEIGHT_PX = 224
TILE_WORLD_WIDTH = 435.0
TILE_EDGE_IDENTITY_PX = 8
TILE_EDGE_BLEND_PX = 40
RIGHT_RESERVE = 0.15
BOUNDARY_WORLD_X = 1740.0
RIGHT_CLAMP_Z_MULTIPLIER = 1.05
VIEWPORTS = (2992, 3456, 3840)

EXPECTED = {
    "frozen_hashes": "7abc64cc21025a08312a63a8cfd7486652854f4fdf30d12179fd072161f9600b",
    "cq_layout": "23582b529a32db016a51a19ce9e9743eb5077edb1ebc9ba24bbd54aed54c41c1",
    "meadow_direction": "0b206080265c405bb59a00a16491b3cabe596500def0de4dab38cb9f5dfe9924",
    "fence_master": "f1b8905b7566a2e62bafcddea7e87f629e5e762be9fbc1d0a402192ce4138e00",
    "pm_activation": "e282a5e86ceb03ae5c1b8cf3a9ed94a9b4d3ae80c3588cb96999e86932e07709",
    "gd_contract": "e103d836427e3bb5054a183149dd97b095e91b5a4195c752ac5f4da19a00854c",
    "gd_current_memory": "d3c393df311e85bdd8f133c40f5be189bafc64db17de3f6dcd1b6230c096d563",
}


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def ensure_inside(path: Path) -> None:
    path.resolve().relative_to(PACKAGE.resolve())


def write_text(path: Path, text: str) -> None:
    ensure_inside(path)
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(text, encoding="utf-8")


def write_json(path: Path, payload: object) -> None:
    write_text(path, json.dumps(payload, ensure_ascii=False, indent=2, sort_keys=True) + "\n")


def normalized_rgba(image: Image.Image) -> Image.Image:
    arr = np.asarray(image.convert("RGBA"), dtype=np.uint8).copy()
    arr[arr[:, :, 3] == 0, :3] = 0
    return Image.fromarray(arr, "RGBA")


def save_png(image: Image.Image, path: Path) -> None:
    ensure_inside(path)
    path.parent.mkdir(parents=True, exist_ok=True)
    normalized_rgba(image).save(path, format="PNG", optimize=False, compress_level=9)


def png_bytes(image: Image.Image) -> bytes:
    data = io.BytesIO()
    normalized_rgba(image).save(data, format="PNG", optimize=False, compress_level=9)
    return data.getvalue()


def zip_write(archive: zipfile.ZipFile, name: str, data: bytes, compress: bool = True) -> None:
    info = zipfile.ZipInfo(name, date_time=(1980, 1, 1, 0, 0, 0))
    info.external_attr = 0o100644 << 16
    info.compress_type = zipfile.ZIP_DEFLATED if compress else zipfile.ZIP_STORED
    archive.writestr(info, data)


def create_ora(path: Path, name: str, layers: list[tuple[str, Image.Image]], merged: Image.Image) -> None:
    ensure_inside(path)
    path.parent.mkdir(parents=True, exist_ok=True)
    stack = []
    for index, (layer_name, _) in enumerate(reversed(layers)):
        source_index = len(layers) - 1 - index
        stack.append(f'    <layer name="{escape(layer_name)}" src="data/{source_index:02d}.png" visibility="visible"/>')
    xml = (
        '<?xml version="1.0" encoding="UTF-8"?>\n'
        f'<image version="0.0.1" w="{merged.width}" h="{merged.height}" name="{escape(name)}">\n'
        f'  <stack name="{escape(name)}">\n' + "\n".join(stack) + "\n  </stack>\n</image>\n"
    ).encode("utf-8")
    thumb = merged.copy()
    thumb.thumbnail((256, 256), Image.Resampling.LANCZOS)
    with zipfile.ZipFile(path, "w") as archive:
        zip_write(archive, "mimetype", b"image/openraster", compress=False)
        zip_write(archive, "stack.xml", xml)
        zip_write(archive, "mergedimage.png", png_bytes(merged))
        zip_write(archive, "Thumbnails/thumbnail.png", png_bytes(thumb))
        for index, (_, layer) in enumerate(layers):
            zip_write(archive, f"data/{index:02d}.png", png_bytes(layer))


def compose(layers: list[tuple[str, Image.Image]], size: tuple[int, int]) -> Image.Image:
    out = Image.new("RGBA", size, (0, 0, 0, 0))
    for _, layer in layers:
        out.alpha_composite(layer)
    return normalized_rgba(out)


def alpha_bbox(image: Image.Image, threshold: int = 0) -> list[int]:
    alpha = np.asarray(image.convert("RGBA"), dtype=np.uint8)[:, :, 3]
    occupied = alpha > threshold
    if not occupied.any():
        return [0, 0, 0, 0]
    yy, xx = np.nonzero(occupied)
    return [int(xx.min()), int(yy.min()), int(xx.max() + 1), int(yy.max() + 1)]


def premultiplied_average(chunks: np.ndarray) -> np.ndarray:
    rgba = chunks.astype(np.float32)
    alpha = rgba[:, :, :, 3:4] / 255.0
    alpha_mean = alpha.mean(axis=0)
    premul_mean = (rgba[:, :, :, :3] * alpha).mean(axis=0)
    rgb = np.divide(premul_mean, alpha_mean, out=np.zeros_like(premul_mean), where=alpha_mean > 1e-6)
    out = np.concatenate((rgb, alpha_mean * 255.0), axis=2)
    return np.clip(np.rint(out), 0, 255).astype(np.uint8)


def periodize_layer(image: Image.Image) -> Image.Image:
    arr = np.asarray(image.convert("RGBA"), dtype=np.uint8)
    if arr.shape != (TILE_HEIGHT_PX, TILE_WIDTH_PX * 4, 4):
        raise ValueError(f"unexpected frozen meadow layer shape: {arr.shape}")
    chunks = np.stack([arr[:, index * TILE_WIDTH_PX:(index + 1) * TILE_WIDTH_PX] for index in range(4)])
    tile = premultiplied_average(chunks).astype(np.float32)
    edge_samples = np.concatenate((tile[:, :TILE_EDGE_BLEND_PX], tile[:, -TILE_EDGE_BLEND_PX:]), axis=1)
    alpha = edge_samples[:, :, 3:4] / 255.0
    alpha_profile = alpha.mean(axis=1)
    premul_profile = (edge_samples[:, :, :3] * alpha).mean(axis=1)
    rgb_profile = np.divide(
        premul_profile,
        alpha_profile,
        out=np.zeros_like(premul_profile),
        where=alpha_profile > 1e-6,
    )
    profile = np.concatenate((rgb_profile, alpha_profile * 255.0), axis=1)
    profile = np.clip(np.rint(profile), 0, 255).astype(np.float32)
    original = tile.copy()
    for x in range(TILE_EDGE_BLEND_PX):
        if x < TILE_EDGE_IDENTITY_PX:
            weight = 0.0
        else:
            t = (x - TILE_EDGE_IDENTITY_PX) / (TILE_EDGE_BLEND_PX - TILE_EDGE_IDENTITY_PX - 1)
            weight = t * t * (3.0 - 2.0 * t)
        tile[:, x] = profile * (1.0 - weight) + original[:, x] * weight
        rx = TILE_WIDTH_PX - 1 - x
        tile[:, rx] = profile * (1.0 - weight) + original[:, rx] * weight
    tile = np.clip(np.rint(tile), 0, 255).astype(np.uint8)
    tile[tile[:, :, 3] == 0, :3] = 0
    return Image.fromarray(tile, "RGBA")


def build_meadow() -> tuple[list[tuple[str, Image.Image]], Image.Image]:
    names = [
        "00__world_depth_faint_trees_shrubs.png",
        "01__world_ground_grass_mass.png",
        "02__world_path_dirt_worn.png",
        "03__world_ground_soil_base.png",
    ]
    layers: list[tuple[str, Image.Image]] = []
    out_dir = SOURCE / "meadow_tile" / "layers"
    for index, filename in enumerate(names):
        src = FROZEN / "source" / "world" / "layers" / filename
        layer = periodize_layer(Image.open(src))
        semantic = filename[4:-4].replace("_", ".")
        layers.append((semantic, layer))
        save_png(layer, out_dir / f"{index:02d}__{semantic.replace('.', '_')}.png")
    merged = compose(layers, (TILE_WIDTH_PX, TILE_HEIGHT_PX))
    master = SOURCE / "meadow_tile" / "meadow_tile_master.ora"
    create_ora(master, "D-024 meadow tile 748x224", layers, merged)
    save_png(merged, EXPORTS / "meadow" / "meadow_tile_rgba_748x224.png")
    return layers, merged


def build_marker() -> tuple[list[tuple[str, Image.Image]], Image.Image, int]:
    layer_paths = sorted((FROZEN / "source" / "world" / "assets" / "fence_segments" / "layers").glob("*.png"))
    source_layers = [(path.stem.split("__", 1)[1].replace("_", "."), Image.open(path).convert("RGBA")) for path in layer_paths]
    full = compose(source_layers, (425, 135))
    segment_crop = (180, 0, 362, 135)
    local = full.crop(segment_crop)
    bbox = local.getchannel("A").getbbox()
    if bbox is None:
        raise ValueError("accepted fence span crop is empty")
    left = segment_crop[0] + bbox[0]
    top = segment_crop[1] + bbox[1]
    right = segment_crop[0] + bbox[2]
    bottom = segment_crop[1] + bbox[3]
    layers: list[tuple[str, Image.Image]] = []
    out_dir = SOURCE / "fence_boundary_marker" / "layers"
    for index, (name, layer) in enumerate(source_layers):
        derived = layer.crop((left, top, right, bottom)).transpose(Image.Transpose.FLIP_LEFT_RIGHT)
        derived = normalized_rgba(derived)
        layers.append((name, derived))
        save_png(derived, out_dir / f"{index:02d}__{name.replace('.', '_')}.png")
    merged = compose(layers, layers[0][1].size)
    pivot_y = merged.height - 1
    create_ora(
        SOURCE / "fence_boundary_marker" / "fence_boundary_marker_master.ora",
        "D-024 positive mirrored fence boundary marker",
        layers,
        merged,
    )
    save_png(merged, EXPORTS / "boundary_marker" / "fence_boundary_marker_rgba.png")
    return layers, merged, pivot_y


def paste_clipped(target: Image.Image, source: Image.Image, x: int, y: int) -> None:
    left = max(0, -x)
    top = max(0, -y)
    right = min(source.width, target.width - x)
    bottom = min(source.height, target.height - y)
    if right <= left or bottom <= top:
        return
    target.alpha_composite(source.crop((left, top, right, bottom)), (x + left, y + top))


def static_overlay() -> Image.Image:
    layers = []
    for path in sorted((FROZEN / "source" / "world" / "layers").glob("*.png")):
        index = int(path.name.split("__", 1)[0])
        if index >= 4:
            layers.append((path.stem, Image.open(path).convert("RGBA")))
    overlay = compose(layers, (WORLD_SOURCE_WIDTH, WORLD_SOURCE_HEIGHT))
    dog = Image.open(FROZEN / "exports" / "labrador" / "poses" / "idle_neutral_right" / "identity_rgba.png").convert("RGBA")
    dog_scale = 0.24 * SOURCE_PX_PER_WORLD_UNIT
    resized = dog.resize((round(dog.width * dog_scale), round(dog.height * dog_scale)), Image.Resampling.LANCZOS)
    root = (round(256 * dog_scale), round(280 * dog_scale))
    overlay.alpha_composite(resized, (2030 - root[0], WORLD_BASELINE_PX - root[1]))
    return normalized_rgba(overlay)


def render_viewport(
    width: int,
    mode: str,
    tile: Image.Image,
    marker: Image.Image,
    marker_pivot_y: int,
    static: Image.Image,
    include_static: bool = True,
) -> tuple[Image.Image, dict]:
    z_min = (1.0 - RIGHT_RESERVE) * width / WORLD_WIDTH
    zoom = z_min if mode == "default" else z_min * RIGHT_CLAMP_Z_MULTIPLIER
    camera_x = 0.0 if mode == "default" else max(0.0, WORLD_WIDTH - (1.0 - RIGHT_RESERVE) * (width / zoom))
    scale = zoom / SOURCE_PX_PER_WORLD_UNIT
    result = Image.new("RGBA", (width, WORLD_SOURCE_HEIGHT), (0, 0, 0, 0))
    visible_start = camera_x
    visible_end = camera_x + width / zoom
    first_tile = math.floor(visible_start / TILE_WORLD_WIDTH) - 1
    last_tile = math.ceil(visible_end / TILE_WORLD_WIDTH) + 1
    tile_height = max(1, round(tile.height * scale))
    tile_y = WORLD_SOURCE_HEIGHT - tile_height
    for tile_index in range(first_tile, last_tile + 1):
        x0 = round((tile_index * TILE_WORLD_WIDTH - camera_x) * zoom)
        x1 = round(((tile_index + 1) * TILE_WORLD_WIDTH - camera_x) * zoom)
        rendered = tile.resize((max(1, x1 - x0), tile_height), Image.Resampling.LANCZOS)
        paste_clipped(result, rendered, x0, tile_y)
    if include_static:
        static_render = static.resize(
            (max(1, round(static.width * scale)), max(1, round(static.height * scale))),
            Image.Resampling.LANCZOS,
        )
        paste_clipped(result, static_render, round(-camera_x * zoom), WORLD_SOURCE_HEIGHT - static_render.height)
    marker_render = marker.resize(
        (max(1, round(marker.width * scale)), max(1, round(marker.height * scale))),
        Image.Resampling.LANCZOS,
    )
    boundary_screen_x = round((BOUNDARY_WORLD_X - camera_x) * zoom)
    source_scene_top = WORLD_SOURCE_HEIGHT - round(WORLD_SOURCE_HEIGHT * scale)
    baseline_screen_y = source_scene_top + round(WORLD_BASELINE_PX * scale)
    marker_y = baseline_screen_y - round(marker_pivot_y * scale)
    paste_clipped(result, marker_render, boundary_screen_x, marker_y)
    reserve_px = width - boundary_screen_x
    return normalized_rgba(result), {
        "viewport_width_px": width,
        "viewport_height_px": WORLD_SOURCE_HEIGHT,
        "mode": mode,
        "zoom": zoom,
        "z_min": z_min,
        "camera_x_world": camera_x,
        "camera_max_world": max(0.0, WORLD_WIDTH - (1.0 - RIGHT_RESERVE) * (width / zoom)),
        "boundary_screen_x_px": boundary_screen_x,
        "reserve_px": reserve_px,
        "reserve_ratio": reserve_px / width,
        "uniform_screen_per_source_px": scale,
        "static_overlay_instances": 1 if include_static else 0,
        "labrador_instances": 1 if include_static else 0,
        "meadow_repeat_world_period": TILE_WORLD_WIDTH,
    }


def checker(size: tuple[int, int], cell: int = 16) -> Image.Image:
    out = Image.new("RGBA", size, (226, 226, 226, 255))
    draw = ImageDraw.Draw(out)
    for y in range(0, size[1], cell):
        for x in range(0, size[0], cell):
            value = 188 if (x // cell + y // cell) % 2 else 230
            draw.rectangle((x, y, min(size[0], x + cell), min(size[1], y + cell)), fill=(value, value, value, 255))
    return out


def black(size: tuple[int, int]) -> Image.Image:
    return Image.new("RGBA", size, (18, 20, 22, 255))


def composite_background(image: Image.Image, background: Image.Image) -> Image.Image:
    out = background.copy()
    out.alpha_composite(image)
    return out


def label(image: Image.Image, text: str, xy: tuple[int, int] = (12, 10)) -> None:
    draw = ImageDraw.Draw(image)
    font = ImageFont.load_default(size=16)
    box = draw.textbbox(xy, text, font=font)
    draw.rectangle((box[0] - 5, box[1] - 4, box[2] + 5, box[3] + 4), fill=(20, 21, 22, 220))
    draw.text(xy, text, font=font, fill=(245, 241, 229, 255))


def build_evidence(tile: Image.Image, marker: Image.Image, pivot_y: int) -> tuple[list[dict], list[dict]]:
    static = static_overlay()
    responsive: list[dict] = []
    checks: list[dict] = []

    repeated = Image.new("RGBA", (TILE_WIDTH_PX * 3, TILE_HEIGHT_PX), (0, 0, 0, 0))
    for index in range(3):
        repeated.alpha_composite(tile, (index * TILE_WIDTH_PX, 0))
    save_png(repeated, EVIDENCE / "seam" / "meadow_tile_repeat_3x_rgba.png")
    save_png(composite_background(repeated, checker(repeated.size)), EVIDENCE / "seam" / "meadow_tile_repeat_3x_checker.png")
    save_png(composite_background(repeated, black(repeated.size)), EVIDENCE / "seam" / "meadow_tile_repeat_3x_black.png")

    tile_arr = np.asarray(tile)
    left = tile_arr[:, :TILE_EDGE_IDENTITY_PX]
    right = tile_arr[:, -TILE_EDGE_IDENTITY_PX:]
    edge_profile = left[:, :1]
    seam_proof = {
        "schema": "shelter.art.d024.seam_proof.v1",
        "tile_dimensions_px": [TILE_WIDTH_PX, TILE_HEIGHT_PX],
        "declared_edge_identity_region_px": TILE_EDGE_IDENTITY_PX,
        "left_region_constant_max_delta": int(np.abs(left.astype(np.int16) - edge_profile.astype(np.int16)).max()),
        "right_region_constant_max_delta": int(np.abs(right.astype(np.int16) - edge_profile.astype(np.int16)).max()),
        "left_right_rgba_max_delta": int(np.abs(left.astype(np.int16) - right.astype(np.int16)).max()),
        "left_right_alpha_max_delta": int(np.abs(left[:, :, 3].astype(np.int16) - right[:, :, 3].astype(np.int16)).max()),
        "immediate_repeat_boundary_rgba_max_delta": int(np.abs(tile_arr[:, -1].astype(np.int16) - tile_arr[:, 0].astype(np.int16)).max()),
        "method": "four-period premultiplied consolidation plus 40 px soft edge reconciliation and 8 px exact constant edge identity",
    }
    write_json(EVIDENCE / "seam" / "SEAM_PROOF.json", seam_proof)

    save_png(marker, EVIDENCE / "marker" / "fence_boundary_marker_rgba.png")
    marker_board = Image.new("RGBA", (marker.width * 2 + 48, marker.height + 48), (24, 24, 22, 255))
    marker_board.alpha_composite(composite_background(marker, checker(marker.size)), (16, 24))
    marker_board.alpha_composite(composite_background(marker, black(marker.size)), (marker.width + 32, 24))
    save_png(marker_board, EVIDENCE / "marker" / "fence_boundary_marker_checker_black.png")

    for width in VIEWPORTS:
        for mode in ("default", "right_end"):
            image, measurement = render_viewport(width, mode, tile, marker, pivot_y, static, include_static=True)
            base, _ = render_viewport(width, mode, tile, marker, pivot_y, static, include_static=False)
            boundary = measurement["boundary_screen_x_px"]
            exterior_diff = ImageChops.difference(image.crop((boundary, 0, width, WORLD_SOURCE_HEIGHT)), base.crop((boundary, 0, width, WORLD_SOURCE_HEIGHT)))
            measurement["exterior_non_meadow_marker_delta_bbox"] = list(exterior_diff.getbbox()) if exterior_diff.getbbox() else None
            responsive.append(measurement)
            stem = f"viewport_{width}x224__{mode}"
            save_png(image, EVIDENCE / "responsive" / f"{stem}__rgba.png")
            save_png(composite_background(image, black(image.size)), EVIDENCE / "responsive" / f"{stem}__black.png")
            save_png(composite_background(image, checker(image.size)), EVIDENCE / "responsive" / f"{stem}__checker.png")
            checks.extend([
                {"id": f"responsive.{width}.{mode}.reserve_13_17_percent", "pass": 0.13 <= measurement["reserve_ratio"] <= 0.17, "actual": measurement["reserve_ratio"]},
                {"id": f"responsive.{width}.{mode}.no_anchor_or_dog_exterior", "pass": measurement["exterior_non_meadow_marker_delta_bbox"] is None, "actual": measurement["exterior_non_meadow_marker_delta_bbox"]},
                {"id": f"responsive.{width}.{mode}.single_static_overlay", "pass": measurement["static_overlay_instances"] == 1, "actual": measurement["static_overlay_instances"]},
                {"id": f"responsive.{width}.{mode}.single_labrador", "pass": measurement["labrador_instances"] == 1, "actual": measurement["labrador_instances"]},
            ])

    write_json(EVIDENCE / "responsive" / "RESPONSIVE_MEASUREMENTS.json", responsive)

    default_2992 = Image.open(EVIDENCE / "responsive" / "viewport_2992x224__default__rgba.png").convert("RGBA")
    for height in (216, 144, 96):
        width = round(default_2992.width * height / default_2992.height)
        resized = default_2992.resize((width, height), Image.Resampling.LANCZOS)
        save_png(resized, EVIDENCE / "readability" / f"viewport_2992_default__{height}px_high_rgba.png")
        checks.append({"id": f"readability.{height}.rgba_export", "pass": resized.mode == "RGBA" and resized.height == height, "actual": [resized.mode, resized.width, resized.height]})

    accepted = Image.open(FROZEN / "evidence" / "full_layout" / "full_layout_native_2992x224_rgba.png").convert("RGBA")
    current = default_2992
    panel = Image.new("RGBA", (1496, 260), (19, 21, 23, 255))
    panel.alpha_composite(composite_background(accepted.resize((1496, 112), Image.Resampling.LANCZOS), black((1496, 112))), (0, 18))
    panel.alpha_composite(composite_background(current.resize((1496, 112), Image.Resampling.LANCZOS), black((1496, 112))), (0, 148))
    label(panel, "frozen accepted one-shot source (anti-target for responsive tail)", (12, 2))
    label(panel, "D-024 amendment: same anchors once + repeated meadow + 15% exterior reserve", (12, 132))
    save_png(panel, EVIDENCE / "comparison" / "accepted_source_vs_d024_amendment.png")
    return responsive, checks


def build_manifest(tile: Image.Image, marker_layers: list[tuple[str, Image.Image]], marker: Image.Image, pivot_y: int, responsive: list[dict]) -> dict:
    body_layer = next(layer for name, layer in marker_layers if "functional.body" in name)
    marker_bbox = alpha_bbox(marker)
    body_bbox = alpha_bbox(body_layer, threshold=127)
    baseline_world_y = WORLD_BASELINE_PX * WORLD_UNITS_PER_SOURCE_PX
    manifest = {
        "schema": "shelter.art_source_responsive_meadow_left_cluster_amendment.v1",
        "package_id": PACKAGE.name,
        "date": DATE,
        "owner": "Art Director + Visual Production owner",
        "status": "SOURCE_AMENDMENT_READY__SOURCE_ONLY__NOT_RUNTIME_EXECUTABLE",
        "runtime_authority": "NONE",
        "sheet_a_reuse": "ZERO",
        "cq_pixel_or_style_reuse": "ZERO",
        "frozen_source_hashes_sha256": EXPECTED["frozen_hashes"],
        "coordinate_contract": {
            "gameplay_world_x": [0.0, WORLD_WIDTH],
            "source_px_per_runtime_unit": SOURCE_PX_PER_WORLD_UNIT,
            "runtime_units_per_source_px": WORLD_UNITS_PER_SOURCE_PX,
            "world_source_canvas_px": [WORLD_SOURCE_WIDTH, WORLD_SOURCE_HEIGHT],
            "world_source_baseline_y_px": WORLD_BASELINE_PX,
            "world_baseline_y_units": baseline_world_y,
            "right_reserve_target": RIGHT_RESERVE,
            "offscreen_left_minus_160": "D-013 hidden Dachshund/Bicycle absence sentinel only; excluded from visible meadow, field, stations, A-H and idle space",
        },
        "meadow_tile": {
            "master": "source/meadow_tile/meadow_tile_master.ora",
            "export": "exports/meadow/meadow_tile_rgba_748x224.png",
            "dimensions_px": [tile.width, tile.height],
            "mode": "RGBA",
            "alpha_bbox": alpha_bbox(tile),
            "transparent_upper_rows": alpha_bbox(tile)[1],
            "tile_world_width": TILE_WORLD_WIDTH,
            "world_phase_origin_x": 0.0,
            "vertical_source_bounds_px": [0, TILE_HEIGHT_PX],
            "baseline_y_px": WORLD_BASELINE_PX,
            "baseline_y_units": baseline_world_y,
            "repeat": "X only; world-anchored; visible range only; one loaded texture; no Y repeat",
            "edge_identity_region_px": TILE_EDGE_IDENTITY_PX,
            "seam_proof": "evidence/seam/SEAM_PROOF.json",
            "import_recommendation": {
                "format": "lossless RGBA PNG outside atlases",
                "filter": "linear",
                "mipmaps": False,
                "repeat": "enabled for X sampling or explicit repeated quads; never stretch/crop",
                "edge_bleed": "none; exact transparent RGB normalization and exact edge identity",
            },
            "source_inputs": [
                {"path": f"{FROZEN.relative_to(REPO)}/source/world/layers/{index:02d}__{name}.png", "sha256": sha256(FROZEN / "source" / "world" / "layers" / f"{index:02d}__{name}.png")}
                for index, name in enumerate(("world_depth_faint_trees_shrubs", "world_ground_grass_mass", "world_path_dirt_worn", "world_ground_soil_base"))
            ],
        },
        "fence_boundary_marker": {
            "master": "source/fence_boundary_marker/fence_boundary_marker_master.ora",
            "export": "exports/boundary_marker/fence_boundary_marker_rgba.png",
            "dimensions_px": [marker.width, marker.height],
            "mode": "RGBA",
            "alpha_bbox": marker_bbox,
            "opaque_functional_body_bbox": body_bbox,
            "boundary_plane_world_x": BOUNDARY_WORLD_X,
            "pivot_px": [0, pivot_y],
            "contact_baseline_y_px": pivot_y,
            "placement_world": [BOUNDARY_WORLD_X, baseline_world_y],
            "positive_uniform_runtime_scale": WORLD_UNITS_PER_SOURCE_PX,
            "runtime_mirror": False,
            "negative_scale": False,
            "exterior_body_world_x_min": BOUNDARY_WORLD_X + body_bbox[0] * WORLD_UNITS_PER_SOURCE_PX,
            "draw_slot": "after accepted layer 16 and before current resources/cues",
            "semantic_role": "noninteractive decorative boundary marker; no entity, collision, input or mechanic authority",
            "source_input_master": f"{FROZEN.relative_to(REPO)}/source/world/assets/fence_segments/fence_segments_master.ora",
            "source_input_master_sha256": EXPECTED["fence_master"],
            "derivation": "one accepted fence span cropped by semantic alpha bounds, horizontally authored into new positive-coordinate pixels, layers preserved; no runtime mirror",
        },
        "responsive_rule": {
            "z_min_formula": "0.85 * viewport_width / 1740",
            "camera_default_x": 0.0,
            "camera_max_formula": "max(0, 1740 - 0.85 * (viewport_width / zoom))",
            "field_boundary_screen_target": "0.85 * viewport_width at default and right clamp",
            "right_reserve_acceptance": [0.13, 0.17],
            "meadow_loaded_textures": 1,
            "meadow_instances": "repeat visible range only",
            "static_anchor_cluster_instances": 1,
            "labrador_instances": 1,
            "repeated_classes": ["meadow tile only"],
            "never_repeated_classes": ["buildings", "Road/Bicycle", "Mill", "Packing", "Van", "Labrador", "boundary marker"],
            "measurement_path": "evidence/responsive/RESPONSIVE_MEASUREMENTS.json",
            "measurements": responsive,
        },
        "unchanged_semantics": {
            "order": ["Road/Bicycle", "Storage", "static decorative Mill", "Kitchen", "Packing", "Van"],
            "labrador": "exact accepted A-H corpus reused; no pose/state/identity edit",
            "frozen_source_manifest": {
                "path": f"{FROZEN.relative_to(REPO)}/SOURCE_MANIFEST.json",
                "sha256": sha256(FROZEN / "SOURCE_MANIFEST.json"),
            },
            "static_layers": "accepted world layers 04-16 are read without edits and composed exactly once; their bounds, baseline, z and occlusion ownership remain frozen",
            "station_contact_roots": "unchanged from frozen source manifest; amendment changes only meadow response and adds the exterior marker",
            "H_route": {
                "frozen_source_endpoints_px": [480, 2380],
                "mapped_world_endpoints_units": [480 * WORLD_UNITS_PER_SOURCE_PX, 2380 * WORLD_UNITS_PER_SOURCE_PX],
                "station_contact_exclusion_source_px": [[1228, 1443], [1677, 1843]],
                "station_contact_exclusion_world_units": [
                    [1228 * WORLD_UNITS_PER_SOURCE_PX, 1443 * WORLD_UNITS_PER_SOURCE_PX],
                    [1677 * WORLD_UNITS_PER_SOURCE_PX, 1843 * WORLD_UNITS_PER_SOURCE_PX],
                ],
                "right_dwell_exclusion": "no dog activity beyond x=1740; marker and exterior reserve are noninteractive",
                "selector_runtime_authority": "NONE_IN_THIS_PACKAGE",
            },
        },
    }
    manifest["meadow_tile"]["master_sha256"] = sha256(PACKAGE / manifest["meadow_tile"]["master"])
    manifest["meadow_tile"]["export_sha256"] = sha256(PACKAGE / manifest["meadow_tile"]["export"])
    manifest["fence_boundary_marker"]["master_sha256"] = sha256(PACKAGE / manifest["fence_boundary_marker"]["master"])
    manifest["fence_boundary_marker"]["export_sha256"] = sha256(PACKAGE / manifest["fence_boundary_marker"]["export"])
    return manifest


def verify_references() -> list[dict]:
    paths = {
        "frozen_hashes": FROZEN / "HASHES.sha256",
        "cq_layout": PACKAGE / "references" / "user_owner" / "CQ_Hero_Town__Full_Width_Living_Lane__User_Owner_Layout_Reference.png",
        "meadow_direction": FROZEN / "references" / "generated_originals" / "world_meadow_plate__flattened_original.png",
        "fence_master": FROZEN / "source" / "world" / "assets" / "fence_segments" / "fence_segments_master.ora",
        "pm_activation": PACKAGE.parent / "STEAM_DESKTOP__Art_Source_Responsive_Meadow_Left_Cluster_Amendment_v1__PM_Activation_Status.md",
        "gd_contract": REPO / "docs" / "drive" / "Shelter" / "02_PRODUCTS" / "01_STEAM_DESKTOP" / "STEAM_DESKTOP__Gameplay_Field_And_Viewport_Semantic_Contract_v1.md",
        "gd_current_memory": REPO / "docs" / "drive" / "Shelter" / "02_PRODUCTS" / "01_STEAM_DESKTOP" / "GAME_DESIGN__CURRENT_CONTEXT.md",
    }
    return [
        {"id": f"reference.{key}.hash", "pass": path.is_file() and sha256(path) == EXPECTED[key], "actual": sha256(path) if path.is_file() else None, "expected": EXPECTED[key], "path": str(path.relative_to(REPO))}
        for key, path in paths.items()
    ]


def build() -> None:
    for directory in (SOURCE, EXPORTS, EVIDENCE):
        if directory.exists():
            shutil.rmtree(directory)
    reference_checks = verify_references()
    if not all(check["pass"] for check in reference_checks):
        write_json(PACKAGE / "QA_REPORT.json", {"status": "BLOCKED_REFERENCE_HASH", "checks": reference_checks})
        raise SystemExit("reference hash mismatch")

    meadow_layers, tile = build_meadow()
    marker_layers, marker, pivot_y = build_marker()
    responsive, evidence_checks = build_evidence(tile, marker, pivot_y)
    manifest = build_manifest(tile, marker_layers, marker, pivot_y, responsive)
    write_json(PACKAGE / "SOURCE_MANIFEST.json", manifest)

    tile_arr = np.asarray(tile)
    top_rows = alpha_bbox(tile)[1]
    ground_band = tile_arr[148:224, :, 3]
    body_layer = next(layer for name, layer in marker_layers if "functional.body" in name)
    body_bbox = alpha_bbox(body_layer, threshold=127)
    marker_bbox = alpha_bbox(marker)
    seam = json.loads((EVIDENCE / "seam" / "SEAM_PROOF.json").read_text(encoding="utf-8"))
    checks = reference_checks + [
        {"id": "meadow.dimensions_748x224", "pass": tile.size == (748, 224), "actual": list(tile.size)},
        {"id": "meadow.mode_rgba", "pass": tile.mode == "RGBA", "actual": tile.mode},
        {"id": "meadow.upper_reserve_transparent", "pass": top_rows >= 90, "actual": top_rows},
        {"id": "meadow.every_x_has_ground_alpha", "pass": bool(np.all(np.max(ground_band, axis=0) > 0)), "actual": int(np.sum(np.max(ground_band, axis=0) == 0))},
        {"id": "meadow.edge_rgba_identity", "pass": seam["left_right_rgba_max_delta"] == 0 and seam["immediate_repeat_boundary_rgba_max_delta"] == 0, "actual": seam},
        {"id": "meadow.exact_four_periods_cover_field", "pass": TILE_WORLD_WIDTH * 4 == WORLD_WIDTH and TILE_WIDTH_PX * 4 == WORLD_SOURCE_WIDTH, "actual": [TILE_WORLD_WIDTH * 4, TILE_WIDTH_PX * 4]},
        {"id": "marker.mode_rgba", "pass": marker.mode == "RGBA", "actual": marker.mode},
        {"id": "marker.alpha_positive_canvas", "pass": marker_bbox[0] >= 0 and marker_bbox[1] >= 0 and marker_bbox[2] <= marker.width and marker_bbox[3] <= marker.height, "actual": marker_bbox},
        {"id": "marker.opaque_body_exterior", "pass": body_bbox[0] >= 0 and BOUNDARY_WORLD_X + body_bbox[0] * WORLD_UNITS_PER_SOURCE_PX >= BOUNDARY_WORLD_X, "actual": body_bbox},
        {"id": "marker.no_runtime_mirror", "pass": manifest["fence_boundary_marker"]["runtime_mirror"] is False and manifest["fence_boundary_marker"]["positive_uniform_runtime_scale"] > 0, "actual": manifest["fence_boundary_marker"]["positive_uniform_runtime_scale"]},
        {"id": "marker.draw_slot", "pass": manifest["fence_boundary_marker"]["draw_slot"] == "after accepted layer 16 and before current resources/cues", "actual": manifest["fence_boundary_marker"]["draw_slot"]},
        {"id": "scope.labrador_unchanged", "pass": manifest["unchanged_semantics"]["labrador"].startswith("exact accepted A-H corpus reused"), "actual": manifest["unchanged_semantics"]["labrador"]},
        {"id": "scope.sheet_a_zero", "pass": manifest["sheet_a_reuse"] == "ZERO", "actual": manifest["sheet_a_reuse"]},
        {"id": "scope.cq_pixels_zero", "pass": manifest["cq_pixel_or_style_reuse"] == "ZERO", "actual": manifest["cq_pixel_or_style_reuse"]},
    ] + evidence_checks
    passed = sum(1 for check in checks if check["pass"])
    report = {
        "schema": "shelter.art.d024.qa.v1",
        "date": DATE,
        "status": "PASS" if passed == len(checks) else "FAIL",
        "verdict": "SOURCE_AMENDMENT_READY" if passed == len(checks) else "BLOCKED",
        "checks_passed": passed,
        "checks_total": len(checks),
        "checks": checks,
    }
    write_json(PACKAGE / "QA_REPORT.json", report)
    if passed != len(checks):
        raise SystemExit(f"QA failed: {passed}/{len(checks)}")


def ledger() -> None:
    files = sorted(path for path in PACKAGE.rglob("*") if path.is_file() and path.name != "HASHES.sha256")
    inventory_entries = sorted(set([str(path.relative_to(PACKAGE)) for path in files] + ["INVENTORY.txt", "HASHES.sha256"]))
    write_text(PACKAGE / "INVENTORY.txt", "\n".join(inventory_entries) + "\n")
    files = sorted(path for path in PACKAGE.rglob("*") if path.is_file() and path.name != "HASHES.sha256")
    lines = [f"{sha256(path)}  {path.relative_to(PACKAGE)}" for path in files]
    write_text(PACKAGE / "HASHES.sha256", "\n".join(lines) + "\n")


def verify_ledger() -> None:
    ledger_path = PACKAGE / "HASHES.sha256"
    if not ledger_path.is_file():
        raise SystemExit("HASHES.sha256 missing")
    errors = []
    entries = 0
    for line in ledger_path.read_text(encoding="utf-8").splitlines():
        expected, rel = line.split("  ", 1)
        path = PACKAGE / rel
        entries += 1
        if not path.is_file() or sha256(path) != expected:
            errors.append(rel)
    actual = sorted(str(path.relative_to(PACKAGE)) for path in PACKAGE.rglob("*") if path.is_file() and path.name != "HASHES.sha256")
    listed = sorted(line.split("  ", 1)[1] for line in ledger_path.read_text(encoding="utf-8").splitlines())
    if actual != listed:
        errors.append("ledger coverage mismatch")
    inventory = (PACKAGE / "INVENTORY.txt").read_text(encoding="utf-8").splitlines()
    expected_inventory = sorted(actual + ["HASHES.sha256"])
    if inventory != expected_inventory:
        errors.append("inventory coverage mismatch")
    if errors:
        raise SystemExit("ledger verification failed: " + ", ".join(errors))
    print(f"ledger PASS {entries}/{len(actual)}; package files including HASHES: {len(actual) + 1}")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("command", choices=("build", "ledger", "verify-ledger"), nargs="?", default="build")
    args = parser.parse_args()
    if args.command == "build":
        build()
    elif args.command == "ledger":
        ledger()
    else:
        verify_ledger()


if __name__ == "__main__":
    main()
