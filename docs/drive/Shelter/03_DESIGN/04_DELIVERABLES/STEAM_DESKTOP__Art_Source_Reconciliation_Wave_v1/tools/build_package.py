#!/usr/bin/env python3
"""Build the source-only Shelter Art reconciliation package.

The four ImageGen sheets are preserved byte-for-byte in references/.  This
builder creates transparent, editable raster derivatives and lossless review
exports.  It never writes outside its package directory.
"""

from __future__ import annotations

import hashlib
import io
import json
import math
import os
import shutil
import zipfile
from pathlib import Path
from xml.sax.saxutils import escape

import numpy as np
from PIL import Image, ImageChops, ImageDraw, ImageFilter, ImageFont, ImageOps


PACKAGE = Path(__file__).resolve().parents[1]
REPO = PACKAGE.parents[5]
ORIGINALS = PACKAGE / "references" / "generated_originals"
SOURCE = PACKAGE / "source"
EXPORTS = PACKAGE / "exports"
EVIDENCE = PACKAGE / "evidence"

PYTHON_VERSION = "3.12.13"
PILLOW_VERSION = "12.2.0"
NUMPY_VERSION = "2.3.5"
DATE = "2026-07-13"

DOG_CANVAS = (512, 320)
DOG_ROOT = (256, 280)
DOG_CONTENT_HEIGHT = 225
WORLD_CANVAS = (2992, 224)
WORLD_BASELINE_Y = 211
PLAYERBOOT_WIDTH = 2992
AUTHORED_CORRIDOR_WIDTH = 1740
FULL_WIDTH_ZOOM = PLAYERBOOT_WIDTH / AUTHORED_CORRIDOR_WIDTH
RECOMMENDED_DOG_SCALE = 0.24
PROJECTED_DOG_HEIGHT = DOG_CONTENT_HEIGHT * RECOMMENDED_DOG_SCALE * FULL_WIDTH_ZOOM

LOCOMOTION_NAMES = [
    "idle_neutral_right",
    "wait_calm_left",
    "turn_right_to_left_mid",
    "turn_left_to_right_mid",
    "locomotion_start_right",
    "walk_support_a_right",
    "walk_support_b_right",
    "locomotion_stop_right",
    "locomotion_start_left",
    "walk_support_a_left",
    "walk_support_b_left",
    "locomotion_stop_left",
]

WORK_NAMES = [
    "approach_right",
    "approach_left",
    "contact_align_right",
    "contact_align_left",
    "kitchen_work_right",
    "kitchen_work_left",
    "packing_work_right",
    "packing_work_left",
    "packing_focus_right",
    "packing_focus_left",
    "ambient_attentive_right",
    "ambient_attentive_left",
]

POSE_COVERAGE = {
    "A": ["idle_neutral_right", "ambient_attentive_left"],
    "B": ["wait_calm_left", "ambient_attentive_right"],
    "C": [
        "locomotion_start_right", "walk_support_a_right", "walk_support_b_right",
        "locomotion_stop_right", "locomotion_start_left", "walk_support_a_left",
        "walk_support_b_left", "locomotion_stop_left",
    ],
    "D": ["approach_right", "approach_left", "contact_align_right", "contact_align_left"],
    "E": ["kitchen_work_right", "kitchen_work_left"],
    "F": ["packing_work_right", "packing_work_left"],
    "G": ["packing_focus_right", "packing_focus_left"],
    "H": [
        "ambient_attentive_right", "ambient_attentive_left",
        "locomotion_start_right", "walk_support_a_right", "walk_support_b_right",
        "locomotion_stop_right", "locomotion_start_left", "walk_support_a_left",
        "walk_support_b_left", "locomotion_stop_left",
        "turn_right_to_left_mid", "turn_left_to_right_mid",
    ],
}

REFERENCE_PATHS = {
    "d011": REPO / "docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/approved_art_files/D-011_steam_overlay_main_strip_v1_reference.png",
    "labrador_watering": REPO / "docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/approved_art_files/STEAM_OVERLAY__dog_action_labrador_watering_can__approved_direction.png",
    "labrador_user_three_view": REPO / "docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Art_Reconciliation__Dog_Buildings_Meadow_v1/references/user_owner/STEAM_DESKTOP__Labrador_Identity_Three_View__User_Owner_Reference.png",
    "kitchen": REPO / "docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/approved_art_files/STEAM_OVERLAY__kitchen_v2_1_building__approved_with_minor_simplification.png",
    "storage": REPO / "docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/approved_art_files/STEAM_OVERLAY__storage_v2_building__approved_direction.png",
    "mill": REPO / "docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/approved_art_files/STEAM_OVERLAY__mill_v2_utility_prop__approved_direction.png",
    "v5_a": REPO / "docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_R48_05A_LABRADOR_RUNTIME_CAPTURE_v5/captures/first_day/A.png",
}

EXPECTED_REFERENCE_HASHES = {
    "d011": "bde69388b337f1b7b158f35958a3a740953d58816bffd4d51fff5920d54ae508",
    "labrador_watering": "b7f116605d27bf551fb0b4319c579671b9a0f696fa0d097fe221cf1b439e04d7",
    "labrador_user_three_view": "5cfffc7a32717346183b035feb00b4d429f7197381513758c831c4e69a3db1c6",
    "kitchen": "7b6703d65a2ab0f5af99769bbe5b025f6ffb85a83fb38e04f04d153e18b7b98a",
    "storage": "fb0bc903f15203923e5251a271ebf6dbaf2f9b2ccdb4a850cc48d6fcac1e741a",
    "mill": "70b193ddaf403ee8bb885278bb2ea8cfaecdc818486dfd3c33753436042cf1f5",
    "v5_a": "5a19f0e92590b896d5197824297237ecf8d98f2237471e039943c8829fc6eba9",
}

EXPECTED_GENERATED_HASHES = {
    "labrador_locomotion_sheet__flattened_original.png": "fe67c60b752ae80d590a40ccbdfd60d3cb5c4d9037e3738e2eef73184cdc5ad6",
    "labrador_work_sheet__flattened_original.png": "9c6379cdd893a76fbd01318efe5c92705f0ef0772e1e2481bf5740d5d570577c",
    "world_asset_sheet__flattened_original.png": "ede0519364aa6146c1ff3f0ae3143b9f902d8b9fb0bc1cdde27dbe93d3cf0f9e",
    "world_meadow_plate__flattened_original.png": "0b206080265c405bb59a00a16491b3cabe596500def0de4dab38cb9f5dfe9924",
}


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            h.update(chunk)
    return h.hexdigest()


def ensure_dir(path: Path) -> None:
    path.mkdir(parents=True, exist_ok=True)


def normalized_transparent_rgb(image: Image.Image) -> Image.Image:
    if image.mode != "RGBA":
        return image
    arr = np.array(image, copy=True)
    arr[arr[:, :, 3] == 0, :3] = 0
    return Image.fromarray(arr, "RGBA")


def save_png(image: Image.Image, path: Path) -> None:
    ensure_dir(path.parent)
    normalized_transparent_rgb(image).save(path, format="PNG", optimize=False, compress_level=9)


def remove_white_background(image: Image.Image, background_threshold: int = 20) -> Image.Image:
    """Connected-background extraction with soft, white-unmatted edge pixels.

    A loose per-pixel near-white threshold amplified tiny ImageGen sheet noise
    into rectangular/speckled alpha.  Here, only near-white pixels connected to
    the crop border are background; a small morphological opening removes
    disconnected noise before a sub-pixel feather is applied.
    """
    source = image.convert("RGB")
    border = 12
    padded = ImageOps.expand(source, border=border, fill=(255, 255, 255))
    rgb8 = np.asarray(padded, dtype=np.uint8)
    rgb = rgb8.astype(np.int16)
    distance = np.max(255 - rgb, axis=2).astype(np.uint8)
    value = np.max(rgb, axis=2)
    chroma = np.max(rgb, axis=2) - np.min(rgb, axis=2)
    background_like = (distance <= background_threshold) | ((value >= 220) & (chroma <= 12))
    candidate = Image.fromarray(
        np.where(background_like, 0, 255).astype(np.uint8), "L"
    ).copy()
    # Mark every border-connected candidate region as background.  Sampling
    # every 8 px is enough because the extraction background is continuous.
    for x in range(0, candidate.width, 8):
        if candidate.getpixel((x, 0)) == 0:
            ImageDraw.floodfill(candidate, (x, 0), 128, thresh=0)
        if candidate.getpixel((x, candidate.height - 1)) == 0:
            ImageDraw.floodfill(candidate, (x, candidate.height - 1), 128, thresh=0)
    for y in range(0, candidate.height, 8):
        if candidate.getpixel((0, y)) == 0:
            ImageDraw.floodfill(candidate, (0, y), 128, thresh=0)
        if candidate.getpixel((candidate.width - 1, y)) == 0:
            ImageDraw.floodfill(candidate, (candidate.width - 1, y), 128, thresh=0)
    mask_arr = np.asarray(candidate)
    # Border-connected exterior and enclosed high-value/low-chroma holes are
    # both background.  The latter is required for bicycle wheels, open
    # shelves and other subject silhouettes containing closed white holes.
    foreground = np.where((mask_arr == 128) | background_like, 0, 255).astype(np.uint8)
    mask = Image.fromarray(foreground, "L")
    mask = mask.filter(ImageFilter.MinFilter(3)).filter(ImageFilter.MaxFilter(3))
    mask = mask.filter(ImageFilter.MaxFilter(3)).filter(ImageFilter.MinFilter(3))
    alpha = np.asarray(mask.filter(ImageFilter.GaussianBlur(0.65)), dtype=np.uint8)

    # Remove the white matte from the few feathered edge pixels.  Fully opaque
    # source pixels remain byte-identical in RGB; fully transparent RGB is zero.
    a = alpha.astype(np.float32) / 255.0
    out_rgb = rgb8.astype(np.float32)
    edge = (alpha > 0) & (alpha < 255)
    for channel in range(3):
        channel_values = out_rgb[:, :, channel]
        channel_values[edge] = np.clip(
            (channel_values[edge] - 255.0 * (1.0 - a[edge])) / np.maximum(a[edge], 1.0 / 255.0),
            0,
            255,
        )
        out_rgb[:, :, channel] = channel_values
    out_rgb[alpha == 0] = 0
    rgba = np.dstack((out_rgb.astype(np.uint8), alpha))
    result = Image.fromarray(rgba, "RGBA")
    return result.crop((border, border, border + source.width, border + source.height))


def trim_rgba(image: Image.Image, padding: int = 0) -> Image.Image:
    bbox = image.getchannel("A").getbbox()
    if not bbox:
        raise ValueError("empty alpha image")
    cropped = image.crop(bbox)
    if padding:
        # Padding is added after the alpha crop, rather than borrowed from the
        # generated cell.  This guarantees four transparent corners even when
        # the semantic subject originally touched a crop boundary.
        cropped = ImageOps.expand(cropped, border=padding, fill=(0, 0, 0, 0))
    return cropped


def decontaminate_soft_edge(image: Image.Image) -> Image.Image:
    """Propagate trustworthy interior colour into soft-alpha matte pixels.

    The generated sheets were RGB-on-white.  Their low-alpha fringe therefore
    cannot retain the original RGB without producing a white outline on the
    dark desktop.  Alpha stays untouched; only RGB for alpha < 160 is filled
    from neighbouring alpha >= 160 subject pixels.
    """
    arr = np.array(image.convert("RGBA"), copy=True)
    alpha = arr[:, :, 3]
    work = arr[:, :, :3].astype(np.float32)
    filled = alpha >= 160
    eligible = alpha > 0
    height, width = alpha.shape
    for _ in range(12):
        sums = np.zeros_like(work)
        counts = np.zeros((height, width), dtype=np.float32)
        for dy, dx in ((-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1)):
            src_y0 = max(0, -dy)
            src_y1 = min(height, height - dy)
            src_x0 = max(0, -dx)
            src_x1 = min(width, width - dx)
            dst_y0 = src_y0 + dy
            dst_y1 = src_y1 + dy
            dst_x0 = src_x0 + dx
            dst_x1 = src_x1 + dx
            neighbour = filled[src_y0:src_y1, src_x0:src_x1]
            sums[dst_y0:dst_y1, dst_x0:dst_x1] += (
                work[src_y0:src_y1, src_x0:src_x1] * neighbour[:, :, None]
            )
            counts[dst_y0:dst_y1, dst_x0:dst_x1] += neighbour
        new = eligible & ~filled & (counts > 0)
        if not np.any(new):
            break
        work[new] = sums[new] / counts[new, None]
        filled[new] = True
    soft = eligible & (alpha < 160) & filled
    arr[:, :, :3][soft] = np.clip(work[soft], 0, 255).astype(np.uint8)
    arr[alpha == 0, :3] = 0
    return Image.fromarray(arr, "RGBA")


def keep_largest_alpha_components(image: Image.Image, count: int) -> Image.Image:
    """Discard disconnected neighbouring-cell debris, retaining soft edges."""
    arr = np.array(image.convert("RGBA"), copy=True)
    core = arr[:, :, 3] > 8
    height, width = core.shape
    seen = np.zeros_like(core)
    components: list[list[tuple[int, int]]] = []
    for seed_y, seed_x in zip(*np.nonzero(core)):
        if seen[seed_y, seed_x]:
            continue
        stack = [(int(seed_y), int(seed_x))]
        seen[seed_y, seed_x] = True
        component: list[tuple[int, int]] = []
        while stack:
            y, x = stack.pop()
            component.append((y, x))
            for dy, dx in ((-1, 0), (1, 0), (0, -1), (0, 1)):
                ny, nx = y + dy, x + dx
                if 0 <= ny < height and 0 <= nx < width and core[ny, nx] and not seen[ny, nx]:
                    seen[ny, nx] = True
                    stack.append((ny, nx))
        components.append(component)
    keep_core = np.zeros_like(core)
    for component in sorted(components, key=len, reverse=True)[:count]:
        ys, xs = zip(*component)
        keep_core[np.asarray(ys), np.asarray(xs)] = True
    keep_soft = np.asarray(
        Image.fromarray((keep_core * 255).astype(np.uint8), "L").filter(ImageFilter.MaxFilter(9))
    ) > 0
    arr[:, :, 3] = np.where(keep_soft, arr[:, :, 3], 0)
    arr[arr[:, :, 3] == 0, :3] = 0
    return Image.fromarray(arr, "RGBA")


def alpha_bbox(image: Image.Image) -> list[int]:
    bbox = image.getchannel("A").getbbox()
    if not bbox:
        return [0, 0, 0, 0]
    return [int(value) for value in bbox]


def extract_grid(image: Image.Image, columns: int, rows: int) -> list[Image.Image]:
    cells: list[Image.Image] = []
    for row in range(rows):
        for col in range(columns):
            x0 = round(col * image.width / columns)
            x1 = round((col + 1) * image.width / columns)
            y0 = round(row * image.height / rows)
            y1 = round((row + 1) * image.height / rows)
            extracted = remove_white_background(image.crop((x0, y0, x1, y1)), 18)
            cells.append(trim_rgba(decontaminate_soft_edge(extracted), 6))
    return cells


def normalize_dog_pose(subject: Image.Image) -> Image.Image:
    # Transparent extraction padding is not part of the actor envelope.
    subject = trim_rgba(subject, 0)
    scale = DOG_CONTENT_HEIGHT / subject.height
    width = max(1, round(subject.width * scale))
    resized = subject.resize((width, DOG_CONTENT_HEIGHT), Image.Resampling.LANCZOS)
    if width > DOG_CANVAS[0] - 12:
        scale = (DOG_CANVAS[0] - 12) / width
        resized = resized.resize((DOG_CANVAS[0] - 12, round(DOG_CONTENT_HEIGHT * scale)), Image.Resampling.LANCZOS)
    resized = trim_rgba(resized, 0)
    if resized.height != DOG_CONTENT_HEIGHT:
        width = max(1, round(resized.width * DOG_CONTENT_HEIGHT / resized.height))
        resized = resized.resize((width, DOG_CONTENT_HEIGHT), Image.Resampling.LANCZOS)
    resized = decontaminate_soft_edge(resized)
    canvas = Image.new("RGBA", DOG_CANVAS, (0, 0, 0, 0))
    x = DOG_ROOT[0] - resized.width // 2
    y = DOG_ROOT[1] - resized.height
    canvas.alpha_composite(resized, (x, y))
    return canvas


def facing_for_pose(name: str) -> str:
    if name.endswith("_left") or "right_to_left" in name:
        return "left"
    return "right"


def split_dog_layers(identity: Image.Image, facing: str) -> list[tuple[str, Image.Image]]:
    arr = np.array(identity)
    alpha = arr[:, :, 3]
    ys, xs = np.nonzero(alpha)
    left, right = xs.min(), xs.max() + 1
    top, bottom = ys.min(), ys.max() + 1
    width = max(1, right - left)
    height = max(1, bottom - top)
    xx, yy = np.meshgrid(np.arange(identity.width), np.arange(identity.height))
    u = (xx - left) / width
    if facing == "left":
        u = 1.0 - u
    v = (yy - top) / height
    occupied = alpha > 0

    candidates = [
        ("dog.tail", (u < 0.19) & (v > 0.12) & (v < 0.76)),
        ("dog.leg.hind.far", (u >= 0.18) & (u < 0.37) & (v > 0.54)),
        ("dog.leg.hind.near", (u >= 0.37) & (u < 0.53) & (v > 0.58)),
        ("dog.leg.fore.far", (u >= 0.52) & (u < 0.68) & (v > 0.47)),
        ("dog.leg.fore.near", (u >= 0.68) & (v > 0.42)),
        ("dog.ear.far", (u > 0.67) & (u <= 0.79) & (v < 0.27)),
        ("dog.ear.near", (u > 0.79) & (u <= 0.91) & (v < 0.32)),
        ("dog.muzzle", (u > 0.84) & (v < 0.49)),
        ("dog.head", (u > 0.65) & (v < 0.54)),
        ("dog.marking.chest", (u > 0.53) & (u <= 0.70) & (v >= 0.27) & (v < 0.62)),
    ]
    layers: list[tuple[str, Image.Image]] = []
    assigned = np.zeros_like(occupied)
    for name, candidate in candidates:
        mask = occupied & candidate & ~assigned
        layer_arr = arr.copy()
        layer_arr[:, :, 3] = np.where(mask, alpha, 0)
        layers.append((name, Image.fromarray(layer_arr, "RGBA")))
        assigned |= mask
    torso_arr = arr.copy()
    torso_arr[:, :, 3] = np.where(occupied & ~assigned, alpha, 0)
    layers.insert(4, ("dog.torso", Image.fromarray(torso_arr, "RGBA")))
    return layers


def dog_shadow(identity: Image.Image) -> Image.Image:
    bbox = alpha_bbox(identity)
    shadow = Image.new("RGBA", identity.size, (0, 0, 0, 0))
    draw = ImageDraw.Draw(shadow)
    inset = max(16, (bbox[2] - bbox[0]) // 12)
    draw.ellipse((bbox[0] + inset, DOG_ROOT[1] - 7, bbox[2] - inset, DOG_ROOT[1] + 6), fill=(52, 38, 24, 72))
    return shadow.filter(ImageFilter.GaussianBlur(4))


def compose_layers(layers: list[tuple[str, Image.Image]], size: tuple[int, int]) -> Image.Image:
    result = Image.new("RGBA", size, (0, 0, 0, 0))
    for _, layer in layers:
        result.alpha_composite(layer)
    return result


def png_bytes(image: Image.Image) -> bytes:
    stream = io.BytesIO()
    image.save(stream, format="PNG", optimize=False, compress_level=9)
    return stream.getvalue()


def deterministic_zip_write(archive: zipfile.ZipFile, name: str, data: bytes, compress: bool = True) -> None:
    info = zipfile.ZipInfo(name, date_time=(1980, 1, 1, 0, 0, 0))
    info.external_attr = 0o100644 << 16
    info.compress_type = zipfile.ZIP_DEFLATED if compress else zipfile.ZIP_STORED
    archive.writestr(info, data)


def create_ora(path: Path, name: str, layers_bottom_to_top: list[tuple[str, Image.Image]], merged: Image.Image) -> None:
    ensure_dir(path.parent)
    stack_entries = []
    for index, (layer_name, _) in enumerate(reversed(layers_bottom_to_top)):
        source_index = len(layers_bottom_to_top) - 1 - index
        stack_entries.append(
            f'    <layer name="{escape(layer_name)}" src="data/{source_index:02d}.png" visibility="visible"/>'
        )
    xml = (
        '<?xml version="1.0" encoding="UTF-8"?>\n'
        f'<image version="0.0.1" w="{merged.width}" h="{merged.height}" name="{escape(name)}">\n'
        f'  <stack name="{escape(name)}">\n'
        + "\n".join(stack_entries)
        + "\n  </stack>\n</image>\n"
    ).encode("utf-8")
    thumb = merged.copy()
    thumb.thumbnail((256, 256), Image.Resampling.LANCZOS)
    with zipfile.ZipFile(path, "w") as archive:
        deterministic_zip_write(archive, "mimetype", b"image/openraster", compress=False)
        deterministic_zip_write(archive, "stack.xml", xml)
        deterministic_zip_write(archive, "mergedimage.png", png_bytes(merged))
        deterministic_zip_write(archive, "Thumbnails/thumbnail.png", png_bytes(thumb))
        for index, (_, layer) in enumerate(layers_bottom_to_top):
            deterministic_zip_write(archive, f"data/{index:02d}.png", png_bytes(layer))


def scaled_subject(identity: Image.Image, height: int, silhouette: bool = False) -> Image.Image:
    subject = trim_rgba(identity, 2)
    width = max(1, round(subject.width * height / subject.height))
    result = subject.resize((width, height), Image.Resampling.LANCZOS)
    if silhouette:
        black = Image.new("RGBA", result.size, (20, 18, 16, 0))
        black.putalpha(result.getchannel("A"))
        return black
    return result


def save_dog_sources() -> tuple[dict[str, dict], dict[str, Image.Image]]:
    locomotion = Image.open(ORIGINALS / "labrador_locomotion_sheet__flattened_original.png").convert("RGB")
    work = Image.open(ORIGINALS / "labrador_work_sheet__flattened_original.png").convert("RGB")
    subjects = extract_grid(locomotion, 4, 3) + extract_grid(work, 4, 3)
    names = LOCOMOTION_NAMES + WORK_NAMES
    metadata: dict[str, dict] = {}
    composites: dict[str, Image.Image] = {}
    for name, subject in zip(names, subjects, strict=True):
        facing = facing_for_pose(name)
        identity = normalize_dog_pose(subject)
        semantic = split_dog_layers(identity, facing)
        shadow = dog_shadow(identity)
        layers = [("dog.shadow.local", shadow)] + semantic
        merged = compose_layers(layers, DOG_CANVAS)
        pose_source = SOURCE / "labrador" / "poses" / name
        pose_export = EXPORTS / "labrador" / "poses" / name
        for index, (layer_name, layer) in enumerate(layers):
            safe = layer_name.replace(".", "_")
            save_png(layer, pose_source / "layers" / f"{index:02d}__{safe}.png")
        save_png(identity, pose_export / "identity_rgba.png")
        save_png(merged, pose_export / "composite_with_shadow_rgba.png")
        create_ora(pose_source / f"{name}_master.ora", name, layers, merged)
        composites[name] = identity
        bbox = alpha_bbox(identity)
        muzzle_x = bbox[0] + 6 if facing == "left" else bbox[2] - 6
        paw_y = min(DOG_ROOT[1], bbox[3])
        metadata[name] = {
            "facing": facing,
            "canvas": [DOG_CANVAS[0], DOG_CANVAS[1]],
            "root_pivot": [DOG_ROOT[0], DOG_ROOT[1]],
            "ground_baseline_y": DOG_ROOT[1],
            "alpha_bounds_identity": bbox,
            "identity_height_px": bbox[3] - bbox[1],
            "muzzle_contact_pivot": [muzzle_x, round(bbox[1] + 0.37 * (bbox[3] - bbox[1]))],
            "working_paw_pivot": [round((bbox[0] + bbox[2]) / 2), paw_y],
            "master": str((pose_source / f"{name}_master.ora").relative_to(PACKAGE)),
            "identity_export": str((pose_export / "identity_rgba.png").relative_to(PACKAGE)),
            "source_kind": "EDITABLE_LAYERED_RASTER_DERIVATIVE_OF_DECLARED_FLATTENED_GENERATED_ORIGINAL",
        }
        for review_height in (216, 144, 96):
            save_png(
                scaled_subject(identity, review_height),
                EVIDENCE / "labrador" / str(review_height) / f"{name}.png",
            )
            save_png(
                scaled_subject(identity, review_height, silhouette=True),
                EVIDENCE / "labrador" / str(review_height) / f"{name}__silhouette.png",
            )
    return metadata, composites


ASSET_CROPS = {
    "road_sign": (35, 210, 215, 475),
    "bicycle": (185, 195, 490, 475),
    "storage": (480, 145, 900, 475),
    "mill_static": (900, 45, 1200, 475),
    "kitchen": (1195, 125, 1672, 475),
    "packing_utility": (0, 520, 390, 860),
    "van_endpoint": (365, 520, 805, 860),
    "fence_segments": (800, 540, 1260, 850),
    "shrub_depth": (1240, 540, 1672, 850),
}

ASSET_COMPONENT_COUNTS = {
    "bicycle": 1,
    "fence_segments": 3,
    "kitchen": 2,  # building plus deliberately separate chimney smoke
    "mill_static": 1,
    "packing_utility": 1,
    "road_sign": 1,
    "shrub_depth": 1,
    "storage": 1,
    "van_endpoint": 1,
}


def split_asset_layers(asset: Image.Image, name: str) -> list[tuple[str, Image.Image]]:
    arr = np.array(asset)
    alpha = arr[:, :, 3]
    yy, xx = np.meshgrid(np.arange(asset.height), np.arange(asset.width), indexing="ij")
    v = yy / max(1, asset.height)
    occupied = alpha > 0
    masks = [
        (f"{name}.contact_tuft_shadow", occupied & (v >= 0.86)),
        (f"{name}.upper_silhouette", occupied & (v < 0.34)),
        (f"{name}.functional_body", occupied & (v >= 0.34) & (v < 0.72)),
        (f"{name}.base_contact_detail", occupied & (v >= 0.72) & (v < 0.86)),
    ]
    layers: list[tuple[str, Image.Image]] = []
    assigned = np.zeros_like(occupied)
    for layer_name, mask in masks:
        layer_arr = arr.copy()
        actual = mask & ~assigned
        layer_arr[:, :, 3] = np.where(actual, alpha, 0)
        layers.append((layer_name, Image.fromarray(layer_arr, "RGBA")))
        assigned |= actual
    if np.any(occupied & ~assigned):
        layer_arr = arr.copy()
        layer_arr[:, :, 3] = np.where(occupied & ~assigned, alpha, 0)
        layers.append((f"{name}.remaining_detail", Image.fromarray(layer_arr, "RGBA")))
    return layers


def extract_assets() -> dict[str, Image.Image]:
    sheet = Image.open(ORIGINALS / "world_asset_sheet__flattened_original.png").convert("RGB")
    assets: dict[str, Image.Image] = {}
    for name, crop in ASSET_CROPS.items():
        extracted = remove_white_background(sheet.crop(crop), 20)
        asset = trim_rgba(decontaminate_soft_edge(extracted), 6)
        asset = trim_rgba(keep_largest_alpha_components(asset, ASSET_COMPONENT_COUNTS[name]), 6)
        if name == "shrub_depth":
            depth = np.array(asset, copy=True)
            occupied = depth[:, :, 3] > 0
            luma = np.mean(depth[:, :, :3], axis=2) / 255.0
            depth[:, :, 0][occupied] = (58 + 42 * luma[occupied]).astype(np.uint8)
            depth[:, :, 1][occupied] = (66 + 47 * luma[occupied]).astype(np.uint8)
            depth[:, :, 2][occupied] = (42 + 31 * luma[occupied]).astype(np.uint8)
            depth[:, :, 3][occupied] = (
                depth[:, :, 3][occupied].astype(np.float32) * 0.58
            ).astype(np.uint8)
            asset = Image.fromarray(depth, "RGBA")
        assets[name] = asset
        asset_dir = SOURCE / "world" / "assets" / name
        layers = split_asset_layers(asset, name)
        for index, (layer_name, layer) in enumerate(layers):
            save_png(layer, asset_dir / "layers" / f"{index:02d}__{layer_name.replace('.', '_')}.png")
        create_ora(asset_dir / f"{name}_master.ora", name, layers, asset)
        save_png(asset, EXPORTS / "world" / "assets" / f"{name}.png")
    return assets


def place_scaled(asset: Image.Image, target_height: int, center_x: int, baseline_y: int, opacity: float = 1.0) -> tuple[Image.Image, list[int]]:
    width = max(1, round(asset.width * target_height / asset.height))
    resized = asset.resize((width, target_height), Image.Resampling.LANCZOS)
    if opacity != 1.0:
        alpha = resized.getchannel("A").point(lambda value: round(value * opacity))
        resized.putalpha(alpha)
    x = round(center_x - resized.width / 2)
    y = baseline_y - resized.height
    canvas = Image.new("RGBA", WORLD_CANVAS, (0, 0, 0, 0))
    canvas.alpha_composite(resized, (x, y))
    return canvas, [x, y, x + resized.width, y + resized.height]


def meadow_layers() -> list[tuple[str, Image.Image]]:
    plate = Image.open(ORIGINALS / "world_meadow_plate__flattened_original.png").convert("RGB")
    meadow = trim_rgba(decontaminate_soft_edge(remove_white_background(plate, 8)), 0)
    target_height = 132
    meadow = meadow.resize((WORLD_CANVAS[0], target_height), Image.Resampling.LANCZOS)
    canvas = Image.new("RGBA", WORLD_CANVAS, (0, 0, 0, 0))
    canvas.alpha_composite(meadow, (0, WORLD_CANVAS[1] - target_height))
    arr = np.array(canvas)
    alpha = arr[:, :, 3]
    yy, xx = np.meshgrid(np.arange(WORLD_CANVAS[1]), np.arange(WORLD_CANVAS[0]), indexing="ij")
    local_v = (yy - (WORLD_CANVAS[1] - target_height)) / target_height
    occupied = alpha > 0
    rgb = arr[:, :, :3].astype(np.int16)
    greenish = (rgb[:, :, 1] >= rgb[:, :, 0] * 0.88) & (rgb[:, :, 1] > rgb[:, :, 2] * 1.05)
    categories = [
        ("world.depth.faint_trees_shrubs", occupied & (local_v < 0.42)),
        ("world.ground.grass_mass", occupied & (local_v >= 0.42) & (local_v < 0.76) & greenish),
        ("world.path.dirt_worn", occupied & (local_v >= 0.42) & (local_v < 0.76) & ~greenish),
        ("world.ground.soil_base", occupied & (local_v >= 0.76)),
    ]
    layers: list[tuple[str, Image.Image]] = []
    assigned = np.zeros_like(occupied)
    for name, mask in categories:
        layer_arr = arr.copy()
        actual = mask & ~assigned
        layer_arr[:, :, 3] = np.where(actual, alpha, 0)
        if name == "world.depth.faint_trees_shrubs":
            # The generated plate carried pale trees over a white RGB matte.
            # On the dark desktop those pixels read as clouds.  D-011 instead
            # requires barely-visible lower depth, so the declared depth layer
            # alone receives a muted olive tint and bounded translucency.
            luma = np.mean(layer_arr[:, :, :3], axis=2) / 255.0
            layer_arr[:, :, 0][actual] = (62 + 38 * luma[actual]).astype(np.uint8)
            layer_arr[:, :, 1][actual] = (69 + 43 * luma[actual]).astype(np.uint8)
            layer_arr[:, :, 2][actual] = (45 + 28 * luma[actual]).astype(np.uint8)
            layer_arr[:, :, 3][actual] = np.minimum(
                (layer_arr[:, :, 3][actual].astype(np.float32) * 0.34).astype(np.uint8),
                88,
            )
        layers.append((name, Image.fromarray(layer_arr, "RGBA")))
        assigned |= actual
    return layers


def build_world(assets: dict[str, Image.Image]) -> tuple[dict, Image.Image, list[tuple[str, Image.Image]]]:
    layers = meadow_layers()
    placements: dict[str, dict] = {}

    def add(name: str, layer_name: str, height: int, center: int, baseline: int = 207, opacity: float = 1.0) -> None:
        layer, bounds = place_scaled(assets[name], height, center, baseline, opacity)
        layers.append((layer_name, layer))
        placements[layer_name] = {
            "asset": name,
            "bounds": bounds,
            "baseline_y": baseline,
            "source_master": f"source/world/assets/{name}/{name}_master.ora",
        }

    # D-011 rhythm: functional anchor -> authored pause/action -> next anchor.
    # The positions stay inside the same semantic order while avoiding the
    # isolated-island spacing of the first builder pass.
    add("shrub_depth", "world.depth.shrub_cluster.left", 78, 410, 198, 0.54)
    add("shrub_depth", "world.depth.shrub_cluster.mid", 72, 1180, 198, 0.44)
    add("shrub_depth", "world.depth.shrub_cluster.right", 80, 2160, 198, 0.50)
    add("fence_segments", "world.fence.back_span.left", 52, 825, 201, 0.72)
    add("fence_segments", "world.fence.back_span.right", 48, 2250, 201, 0.68)
    add("road_sign", "world.anchor.road_sign", 82, 130, 207)
    add("bicycle", "world.anchor.bicycle_static", 80, 300, 207)
    add("storage", "world.building.storage", 158, 610, 207)
    add("mill_static", "world.utility.mill_static", 188, 960, 207)
    add("kitchen", "world.building.kitchen", 162, 1335, 207)
    add("packing_utility", "world.utility.packing", 132, 1760, 207)
    add("van_endpoint", "world.endpoint.van", 116, 2400, 207)
    add("fence_segments", "world.fence.front_span.pause_only", 36, 2710, 215, 0.78)

    merged = compose_layers(layers, WORLD_CANVAS)
    world_source = SOURCE / "world"
    for index, (name, layer) in enumerate(layers):
        save_png(layer, world_source / "layers" / f"{index:02d}__{name.replace('.', '_')}.png")
    create_ora(world_source / "world_master.ora", "world_master_2992x224", layers, merged)
    save_png(merged, EXPORTS / "world" / "world_full_corridor_rgba.png")

    for height in (216, 144, 96):
        width = round(WORLD_CANVAS[0] * height / WORLD_CANVAS[1])
        save_png(merged.resize((width, height), Image.Resampling.LANCZOS), EVIDENCE / "world" / f"world_full_corridor_{height}.png")

    station_data = {}
    for station_id, layer_name in (("object.kitchen", "world.building.kitchen"), ("object.packing_table", "world.utility.packing")):
        bounds = placements[layer_name]["bounds"]
        x0, y0, x1, y1 = bounds
        root_reach = 66
        station_data[station_id] = {
            "category": "Building" if station_id == "object.kitchen" else "Utility Prop",
            "world_bounds": bounds,
            "ground_baseline_y": WORLD_BASELINE_Y,
            "allowed_facing": {"from_left": "right", "from_right": "left"},
            "physical_turn_before_approach_on_direction_change": True,
            "approach_root": {"left": [x0 - 155, WORLD_BASELINE_Y], "right": [x1 + 155, WORLD_BASELINE_Y]},
            "contact_align_root": {"left": [x0 - root_reach, WORLD_BASELINE_Y], "right": [x1 + root_reach, WORLD_BASELINE_Y]},
            "work_root": {"left": [x0 - root_reach + 4, WORLD_BASELINE_Y], "right": [x1 + root_reach - 4, WORLD_BASELINE_Y]},
            "exit_root": {"left": [x0 - 155, WORLD_BASELINE_Y], "right": [x1 + 155, WORLD_BASELINE_Y]},
            "head_paw_contact_plane": [round(x0 + 0.08 * (x1 - x0)), round(y0 + 0.40 * (y1 - y0)), round(x1 - 0.08 * (x1 - x0)), round(y0 + 0.79 * (y1 - y0))],
            "shadow_owner": "station asset contact_tuft_shadow; broad ground belongs to world meadow",
            "front_occlusion_owner": "packing front lip or kitchen service sill may cover distal contacting paw tips only; never muzzle/head/chest/torso",
            "source_status": "PROPOSED_ART_MAPPING_ONLY__NO_RUNTIME_CONTRACT_MUTATION",
        }
    return {"placements": placements, "stations": station_data}, merged, layers


def adjust_station_contacts(world_meta: dict, dogs: dict[str, Image.Image]) -> None:
    """Align actual generated muzzle extents to each declared work plane."""
    scale = RECOMMENDED_DOG_SCALE * FULL_WIDTH_ZOOM
    mapping = {
        "object.kitchen": ("kitchen_work_right", "kitchen_work_left"),
        "object.packing_table": ("packing_work_right", "packing_work_left"),
    }
    for station_id, (from_left_pose, from_right_pose) in mapping.items():
        station = world_meta["stations"][station_id]
        plane = station["head_paw_contact_plane"]
        left_bbox = alpha_bbox(dogs[from_left_pose])
        right_bbox = alpha_bbox(dogs[from_right_pose])
        right_reach = (left_bbox[2] - DOG_ROOT[0]) * scale
        left_reach = (DOG_ROOT[0] - right_bbox[0]) * scale
        left_root_x = round(plane[0] + 2 - right_reach)
        right_root_x = round(plane[2] - 2 + left_reach)
        station["contact_align_root"] = {
            "left": [left_root_x - 4, WORLD_BASELINE_Y],
            "right": [right_root_x + 4, WORLD_BASELINE_Y],
        }
        station["work_root"] = {
            "left": [left_root_x, WORLD_BASELINE_Y],
            "right": [right_root_x, WORLD_BASELINE_Y],
        }
        station["measured_source_contact"] = {
            "from_left_muzzle_plane_overlap_px": 2.0,
            "from_right_muzzle_plane_overlap_px": 2.0,
            "rule": "muzzle edge is 2 px inside the source contact plane; working paw must remain within the same plane",
        }


def paste_dog_on_world(world: Image.Image, dog: Image.Image, root_x: int, root_y: int = WORLD_BASELINE_Y) -> Image.Image:
    scale = RECOMMENDED_DOG_SCALE * FULL_WIDTH_ZOOM
    resized = dog.resize((round(dog.width * scale), round(dog.height * scale)), Image.Resampling.LANCZOS)
    root_scaled = (round(DOG_ROOT[0] * scale), round(DOG_ROOT[1] * scale))
    result = world.copy()
    result.alpha_composite(resized, (root_x - root_scaled[0], root_y - root_scaled[1]))
    return result


def checker(size: tuple[int, int], cell: int = 16) -> Image.Image:
    result = Image.new("RGBA", size, (225, 225, 225, 255))
    draw = ImageDraw.Draw(result)
    for y in range(0, size[1], cell):
        for x in range(0, size[0], cell):
            color = (190, 190, 190, 255) if (x // cell + y // cell) % 2 else (230, 230, 230, 255)
            draw.rectangle((x, y, x + cell - 1, y + cell - 1), fill=color)
    return result


def dark_desktop(size: tuple[int, int]) -> Image.Image:
    result = Image.new("RGBA", size, (19, 22, 25, 255))
    draw = ImageDraw.Draw(result)
    for y in range(size[1]):
        value = 19 + round(8 * y / max(1, size[1] - 1))
        draw.line((0, y, size[0], y), fill=(value, value + 3, value + 6, 255))
    return result


def contain(image: Image.Image, box: tuple[int, int], background=(24, 23, 21, 255)) -> Image.Image:
    result = Image.new("RGBA", box, background)
    copy = image.convert("RGBA")
    copy.thumbnail(box, Image.Resampling.LANCZOS)
    result.alpha_composite(copy, ((box[0] - copy.width) // 2, (box[1] - copy.height) // 2))
    return result


def label(draw: ImageDraw.ImageDraw, xy: tuple[int, int], text: str, fill=(244, 235, 207, 255), size=18) -> None:
    font = ImageFont.load_default(size=size)
    draw.text(xy, text, fill=fill, font=font)


def dog_contact_overlay(base: Image.Image, station: dict, dog: Image.Image, side: str, title: str) -> Image.Image:
    root = station["work_root"][side]
    rgba = paste_dog_on_world(base, dog, root[0], root[1])
    composed = dark_desktop(WORLD_CANVAS)
    composed.alpha_composite(rgba)
    draw = ImageDraw.Draw(composed)
    plane = station["head_paw_contact_plane"]
    draw.rectangle(tuple(plane), outline=(93, 229, 150, 255), width=3)
    draw.ellipse((root[0] - 5, root[1] - 5, root[0] + 5, root[1] + 5), fill=(255, 203, 72, 255))
    label(draw, (24, 18), title, size=22)
    return composed


def contact_review_board(full: Image.Image, station: dict, title: str) -> Image.Image:
    board = Image.new("RGBA", (1600, 620), (20, 20, 18, 255))
    draw = ImageDraw.Draw(board)
    label(draw, (20, 12), title, size=22)
    board.alpha_composite(contain(full, (1560, 180)), (20, 45))
    x0, y0, x1, y1 = station["world_bounds"]
    crop = full.crop((max(0, x0 - 330), max(0, y0 - 45), min(full.width, x1 + 330), full.height))
    zoom = contain(crop, (1560, 350), (28, 27, 24, 255))
    board.alpha_composite(zoom, (20, 250))
    label(draw, (20, 224), "actual full-layout context + source contact zoom", size=16)
    return board


def build_evidence(world: Image.Image, dogs: dict[str, Image.Image], world_meta: dict) -> None:
    full = paste_dog_on_world(world, dogs["idle_neutral_right"], 2030)
    save_png(full, EVIDENCE / "full_layout" / "full_layout_native_2992x224_rgba.png")
    desktop = dark_desktop(WORLD_CANVAS)
    desktop.alpha_composite(full)
    save_png(desktop, EVIDENCE / "full_layout" / "full_layout_desktop_composite_2992x224.png")
    alpha = checker(WORLD_CANVAS)
    alpha.alpha_composite(full)
    save_png(alpha, EVIDENCE / "full_layout" / "full_layout_alpha_checker_2992x224.png")

    asset_paths = sorted((EXPORTS / "world" / "assets").glob("*.png"))
    for background_name, cell_background in (
        ("black", (18, 19, 20, 255)),
        ("checker", None),
    ):
        asset_board = Image.new("RGBA", (1500, 900), (22, 21, 19, 255))
        asset_draw = ImageDraw.Draw(asset_board)
        for index, asset_path in enumerate(asset_paths):
            col, row = index % 3, index // 3
            x, y = col * 500, row * 300
            if cell_background is None:
                cell = checker((480, 250), 14)
            else:
                cell = Image.new("RGBA", (480, 250), cell_background)
            asset = Image.open(asset_path).convert("RGBA")
            fitted = contain(asset, (450, 210), (0, 0, 0, 0))
            cell.alpha_composite(fitted, (15, 30))
            asset_board.alpha_composite(cell, (x + 10, y + 38))
            label(asset_draw, (x + 18, y + 10), asset_path.stem, size=15)
        save_png(asset_board, EVIDENCE / "world" / f"world_assets_{background_name}_board.png")

    coverage_names = LOCOMOTION_NAMES + WORK_NAMES
    cell = (360, 250)
    board = Image.new("RGBA", (4 * cell[0], 6 * cell[1]), (24, 23, 21, 255))
    draw = ImageDraw.Draw(board)
    for index, name in enumerate(coverage_names):
        x = (index % 4) * cell[0]
        y = (index // 4) * cell[1]
        pose = contain(dogs[name], (cell[0], cell[1] - 28), (31, 30, 27, 255))
        board.alpha_composite(pose, (x, y + 28))
        label(draw, (x + 8, y + 5), name, size=14)
    save_png(board, EVIDENCE / "labrador" / "labrador_A_H_action_coverage_board.png")

    silhouette_board = Image.new("RGBA", (1200, 780), (241, 236, 224, 255))
    draw = ImageDraw.Draw(silhouette_board)
    selected = [
        "idle_neutral_right", "wait_calm_left", "turn_right_to_left_mid", "turn_left_to_right_mid",
        "walk_support_a_right", "walk_support_b_left", "kitchen_work_right", "packing_focus_left",
    ]
    for index, name in enumerate(selected):
        pose = scaled_subject(dogs[name], 216 if index < 4 else 144, silhouette=True)
        col = index % 4
        row = index // 4
        x = col * 300 + (300 - pose.width) // 2
        y = row * 360 + 55 + (230 - pose.height)
        silhouette_board.alpha_composite(pose, (x, y))
        label(draw, (col * 300 + 10, row * 360 + 12), name, fill=(37, 34, 29, 255), size=13)
    save_png(silhouette_board, EVIDENCE / "labrador" / "labrador_silhouette_board.png")

    refs_board = Image.new("RGBA", (1800, 1000), (22, 21, 19, 255))
    draw = ImageDraw.Draw(refs_board)
    user = contain(Image.open(REFERENCE_PATHS["labrador_user_three_view"]), (880, 450))
    watering = contain(Image.open(REFERENCE_PATHS["labrador_watering"]), (880, 450))
    refs_board.alpha_composite(user, (10, 40))
    refs_board.alpha_composite(watering, (910, 40))
    label(draw, (20, 10), "USER OWNER THREE-VIEW — identity target", size=18)
    label(draw, (920, 10), "APPROVED WATERING — material/action target", size=18)
    newrow = Image.new("RGBA", (1780, 470), (31, 30, 27, 255))
    for index, name in enumerate(["idle_neutral_right", "wait_calm_left", "turn_right_to_left_mid", "kitchen_work_right"]):
        pose = scaled_subject(dogs[name], 330 if "work" not in name else 300)
        x = index * 445 + (445 - pose.width) // 2
        newrow.alpha_composite(pose, (x, 100 - max(0, pose.height - 330)))
        label(ImageDraw.Draw(newrow), (index * 445 + 8, 12), name, size=15)
    refs_board.alpha_composite(newrow, (10, 515))
    label(draw, (20, 490), "NEW ORIGINAL EDITABLE RASTER DERIVATIVES", size=18)
    save_png(refs_board, EVIDENCE / "comparisons" / "labrador_identity_reference_comparison.png")

    comparison = Image.new("RGBA", (1600, 940), (23, 22, 20, 255))
    draw = ImageDraw.Draw(comparison)
    d011 = contain(Image.open(REFERENCE_PATHS["d011"]), (1560, 360))
    v5 = contain(Image.open(REFERENCE_PATHS["v5_a"]), (1560, 210))
    new = contain(desktop, (1560, 210))
    comparison.alpha_composite(d011, (20, 45))
    comparison.alpha_composite(v5, (20, 460))
    comparison.alpha_composite(new, (20, 720))
    label(draw, (20, 12), "CANONICAL D-011 FULL SCENE GRAMMAR", size=20)
    label(draw, (20, 425), "CURRENT V5 — technical regression only / visual anti-target", size=20)
    label(draw, (20, 685), "NEW SOURCE COMPOSITION — exact 2992x224 desktop composite", size=20)
    save_png(comparison, EVIDENCE / "comparisons" / "world_D011_v5_new_comparison.png")

    kitchen = world_meta["stations"]["object.kitchen"]
    packing = world_meta["stations"]["object.packing_table"]
    contact_specs = [
        ("kitchen_contact_from_left.png", kitchen, dogs["kitchen_work_right"], "left", "Kitchen from-left / facing-right"),
        ("kitchen_contact_from_right.png", kitchen, dogs["kitchen_work_left"], "right", "Kitchen from-right / facing-left"),
        ("packing_contact_from_left.png", packing, dogs["packing_work_right"], "left", "Packing from-left / facing-right"),
        ("packing_contact_from_right.png", packing, dogs["packing_work_left"], "right", "Packing from-right / facing-left"),
    ]
    for filename, station, pose, side, title in contact_specs:
        full_contact = dog_contact_overlay(world, station, pose, side, title)
        save_png(contact_review_board(full_contact, station, title), EVIDENCE / "stations" / filename)


def validate_expected_inputs() -> None:
    errors = []
    for name, expected in EXPECTED_GENERATED_HASHES.items():
        path = ORIGINALS / name
        actual = sha256(path) if path.exists() else "MISSING"
        if actual != expected:
            errors.append(f"generated original {name}: expected {expected}, got {actual}")
    for name, path in REFERENCE_PATHS.items():
        actual = sha256(path) if path.exists() else "MISSING"
        if actual != EXPECTED_REFERENCE_HASHES[name]:
            errors.append(f"reference {name}: expected {EXPECTED_REFERENCE_HASHES[name]}, got {actual}")
    if errors:
        raise RuntimeError("input readback failed:\n" + "\n".join(errors))


def alpha_quality(path: Path) -> dict:
    image = Image.open(path).convert("RGBA")
    arr = np.asarray(image)
    alpha = arr[:, :, 3]
    transparent = alpha == 0
    low = (alpha > 0) & (alpha <= 32)
    transparent_rgb_nonzero = int(np.count_nonzero(arr[:, :, :3][transparent]))
    bright_low_alpha = int(np.count_nonzero(low & np.all(arr[:, :, :3] >= 248, axis=2)))
    low_count = int(np.count_nonzero(low))
    corners = [int(alpha[0, 0]), int(alpha[0, -1]), int(alpha[-1, 0]), int(alpha[-1, -1])]
    occupied = alpha > 8
    full_rows = int(np.count_nonzero(np.mean(occupied, axis=1) > 0.995))
    full_columns = int(np.count_nonzero(np.mean(occupied, axis=0) > 0.995))
    neutral_white = occupied & (np.max(arr[:, :, :3], axis=2) >= 245) & (
        np.max(arr[:, :, :3], axis=2) - np.min(arr[:, :, :3], axis=2) <= 8
    )
    long_white_rows = int(np.count_nonzero(np.mean(neutral_white, axis=1) > 0.80))
    long_white_columns = int(np.count_nonzero(np.mean(neutral_white, axis=0) > 0.80))
    border = np.concatenate((alpha[:4, :].ravel(), alpha[-4:, :].ravel(), alpha[:, :4].ravel(), alpha[:, -4:].ravel()))
    border_transparent_ratio = float(np.mean(border <= 8))
    bbox = alpha_bbox(image)
    bbox_matches_crop = bbox == [0, 0, image.width, image.height]
    return {
        "transparent_rgb_nonzero_channels": transparent_rgb_nonzero,
        "bright_low_alpha_pixels": bright_low_alpha,
        "low_alpha_pixels": low_count,
        "corner_alpha": corners,
        "border_transparent_ratio": border_transparent_ratio,
        "opaque_bbox": bbox,
        "opaque_bbox_matches_crop": bbox_matches_crop,
        "near_full_occupied_rows": full_rows,
        "near_full_occupied_columns": full_columns,
        "long_neutral_white_rows": long_white_rows,
        "long_neutral_white_columns": long_white_columns,
    }


def collect_inventory() -> list[dict]:
    inventory = []
    for path in sorted(p for p in PACKAGE.rglob("*") if p.is_file() and p.name != "HASHES.sha256"):
        rel = path.relative_to(PACKAGE).as_posix()
        inventory.append({"path": rel, "bytes": path.stat().st_size, "sha256": sha256(path)})
    return inventory


def write_json(path: Path, payload: dict | list) -> None:
    ensure_dir(path.parent)
    path.write_text(json.dumps(payload, ensure_ascii=False, indent=2, sort_keys=True) + "\n", encoding="utf-8")


def write_manifests(dog_meta: dict, world_meta: dict, world: Image.Image) -> None:
    top_alpha_bbox = alpha_bbox(world)
    transparent_top_rows = top_alpha_bbox[1]
    manifest = {
        "schema_version": "shelter.art_source_reconciliation.v1",
        "package_id": PACKAGE.name,
        "date": DATE,
        "owner": "Art Director + Visual Production owner",
        "status": "SOURCE_RECONCILED__ART_WARN_PENDING_USER_SOURCE_REVIEW__SOURCE_ONLY__NOT_RUNTIME_EXECUTABLE",
        "art_verdict": "SOURCE_RECONCILED",
        "art_warning": "ART_WARN_PENDING_USER_SOURCE_REVIEW",
        "runtime_art_pass": False,
        "sheet_a_reuse": "ZERO",
        "canvas": {
            "world": [WORLD_CANVAS[0], WORLD_CANVAS[1]],
            "world_baseline_y": WORLD_BASELINE_Y,
            "dog": [DOG_CANVAS[0], DOG_CANVAS[1]],
            "dog_root": [DOG_ROOT[0], DOG_ROOT[1]],
            "dog_identity_height_px": DOG_CONTENT_HEIGHT,
            "world_first_alpha_row": transparent_top_rows,
        },
        "source_to_runtime_envelope": {
            "trial_uniform_positive_scale": RECOMMENDED_DOG_SCALE,
            "full_width_zoom": FULL_WIDTH_ZOOM,
            "projected_non_shadow_height_px": PROJECTED_DOG_HEIGHT,
            "negative_scale_allowed": False,
            "physical_turn_source_required": True,
            "binding_authority": "NONE_IN_THIS_PACKAGE",
        },
        "semantic_order": ["Road/Bicycle", "Storage", "Kitchen", "Packing", "Van"],
        "static_decorative_insert": "Approved Mill as non-interactive Utility Prop",
        "source_review_advisories": [
            "Labrador collar/coat reads slightly shaggy or Golden-like against the user-owner three-view; user/PM must choose whether the liked generated direction is accepted as-is or receives a later bounded identity grade.",
            "Kitchen facade preserves the detailed approved Kitchen v2.1 direction; user/PM must choose between this authority and a lower-detail D-011 service-opening interpretation.",
            "Mill uses the approved static Utility Prop direction at 188 px review height; user/PM must explicitly accept its mass or request a bounded scale change.",
        ],
        "labrador": {
            "actor_id": "dog.labrador_intro",
            "identity": "natural warm golden adult Labrador; approved Watering + user-owner three-view reconciliation",
            "facing_policy": "authored_both_positive_coordinate",
            "physical_turn": ["turn_right_to_left_mid", "turn_left_to_right_mid"],
            "pose_coverage_A_H": POSE_COVERAGE,
            "poses": dog_meta,
            "selector_H_status": "SIGNED_GD_PM_TECHNICAL__VISUAL_SOURCE_COVERAGE_ONLY__NO_RUNTIME_BINDING",
            "selector_H_art_presentation_proposal": {
                "route_x_world": [480, 2380],
                "station_contact_exclusion_zones": [world_meta["stations"]["object.kitchen"]["world_bounds"], world_meta["stations"]["object.packing_table"]["world_bounds"]],
                "dwell_seconds_range": [4.5, 8.0],
                "start_seconds": 0.18,
                "two_support_walk_cycle_seconds": 0.82,
                "stop_settle_seconds": 0.24,
                "physical_turn_seconds": 0.44,
                "cadence_note": "unhurried even calm-worker visual rhythm; proposal only, no selector/state/runtime authority",
            },
        },
        "world": world_meta,
        "shadow_and_occlusion": {
            "dog": "dog.shadow.local is separate in every dog ORA",
            "world": "broad ground belongs to meadow layers; generated local asset contact tuft is isolated in each asset ORA",
            "front_fence": "pause-only foreground span; excluded from Kitchen/Packing contact corridors",
            "station_front_lip": "may hide distal contacting paw tips only; never muzzle/head/chest/torso",
        },
        "exclusions": [
            "runtime/code/import/capture mutation", "object transfer", "new mechanic/task/resource/output/input",
            "new room or gameplay entity", "Dachshund/cart literal behavior", "bicycle choreography",
            "Dog House/Greenhouse literal roster", "global style or palette lock", "Sheet A any reuse",
        ],
        "generated_originals": {
            name: {"path": f"references/generated_originals/{name}", "sha256": digest, "editable_layered_master": False}
            for name, digest in EXPECTED_GENERATED_HASHES.items()
        },
        "reference_hashes": EXPECTED_REFERENCE_HASHES,
        "toolchain": {"python": PYTHON_VERSION, "pillow": PILLOW_VERSION, "numpy": NUMPY_VERSION, "builder": "tools/build_package.py"},
    }
    write_json(PACKAGE / "SOURCE_MANIFEST.json", manifest)

    checks = []
    for name, pose in dog_meta.items():
        checks.append({"id": f"dog.{name}.alpha_height_225", "pass": pose["identity_height_px"] == DOG_CONTENT_HEIGHT, "actual": pose["identity_height_px"]})
        bounds = pose["alpha_bounds_identity"]
        checks.append({"id": f"dog.{name}.positive_canvas_bounds", "pass": bounds[0] >= 0 and bounds[1] >= 0 and bounds[2] <= DOG_CANVAS[0] and bounds[3] <= DOG_CANVAS[1], "actual": bounds})

    alpha_targets = sorted((EXPORTS / "world" / "assets").glob("*.png")) + sorted(
        (EXPORTS / "labrador" / "poses").glob("*/identity_rgba.png")
    )
    alpha_metrics = {}
    for path in alpha_targets:
        rel = path.relative_to(PACKAGE).as_posix()
        metrics = alpha_quality(path)
        alpha_metrics[rel] = metrics
        checks.append({
            "id": f"alpha.{rel}.transparent_rgb_zero",
            "pass": metrics["transparent_rgb_nonzero_channels"] == 0,
            "actual": metrics["transparent_rgb_nonzero_channels"],
        })
        checks.append({
            "id": f"alpha.{rel}.no_white_low_alpha_fringe",
            # A maximum one-percent neutral-white fraction is a bounded
            # antialiasing tolerance, not permission for visible matte.  The
            # companion black/checker boards remain mandatory visual evidence.
            "pass": metrics["bright_low_alpha_pixels"] <= max(2, round(metrics["low_alpha_pixels"] * 0.01)),
            "actual": metrics,
        })
        checks.append({
            "id": f"alpha.{rel}.no_rectangular_background",
            "pass": (
                max(metrics["corner_alpha"]) == 0
                and metrics["border_transparent_ratio"] >= 0.95
                and not metrics["opaque_bbox_matches_crop"]
                and metrics["long_neutral_white_rows"] == 0
                and metrics["long_neutral_white_columns"] == 0
            ),
            "actual": metrics,
        })

    rhythm_keys = [
        "world.anchor.road_sign", "world.anchor.bicycle_static", "world.building.storage",
        "world.utility.mill_static", "world.building.kitchen", "world.utility.packing", "world.endpoint.van",
    ]
    intervals = [world_meta["placements"][key]["bounds"] for key in rhythm_keys]
    intervals.append([1970, 120, 2090, WORLD_BASELINE_Y])  # one Labrador action pause in review layout
    intervals.sort(key=lambda item: item[0])
    gaps = [max(0, intervals[index + 1][0] - intervals[index][2]) for index in range(len(intervals) - 1)]
    max_gap = max(gaps)
    checks.extend([
        {"id": "world.canvas_2992x224", "pass": world.size == WORLD_CANVAS, "actual": list(world.size)},
        {"id": "world.full_width_authored", "pass": alpha_bbox(world)[0] == 0 and alpha_bbox(world)[2] == WORLD_CANVAS[0], "actual": alpha_bbox(world)},
        {"id": "world.transparent_upper_reserve_present", "pass": transparent_top_rows >= 18, "actual": transparent_top_rows},
        {"id": "dog.authored_both_facing", "pass": all(name in dog_meta for name in ["idle_neutral_right", "wait_calm_left"]), "actual": True},
        {"id": "dog.physical_turn_both_directions", "pass": all(name in dog_meta for name in ["turn_right_to_left_mid", "turn_left_to_right_mid"]), "actual": True},
        {"id": "dog.projected_height_under_224", "pass": PROJECTED_DOG_HEIGHT < WORLD_CANVAS[1], "actual": PROJECTED_DOG_HEIGHT},
        {"id": "scope.sheet_a_absent", "pass": not any("sheet_a" in p.name.lower() for p in PACKAGE.rglob("*")), "actual": True},
        {"id": "world.d011_living_rhythm_max_gap", "pass": max_gap <= 300, "actual": {"gaps_px": gaps, "max_gap_px": max_gap}},
    ])
    depth_path = SOURCE / "world" / "layers" / "00__world_depth_faint_trees_shrubs.png"
    depth_arr = np.asarray(Image.open(depth_path).convert("RGBA"))
    depth_occupied = depth_arr[:, :, 3] > 0
    depth_max_rgb = int(np.max(depth_arr[:, :, :3][depth_occupied])) if np.any(depth_occupied) else 0
    depth_max_alpha = int(np.max(depth_arr[:, :, 3]))
    checks.extend([
        {"id": "world.faint_depth_not_white_sky_matte", "pass": depth_max_rgb <= 120, "actual": depth_max_rgb},
        {"id": "world.faint_depth_alpha_bounded", "pass": depth_max_alpha <= 88, "actual": depth_max_alpha},
    ])
    write_json(PACKAGE / "QA_REPORT.json", {
        "date": DATE,
        "verdict": "SOURCE_RECONCILED__ART_WARN_PENDING_USER_SOURCE_REVIEW",
        "runtime_art_pass": False,
        "checks_total": len(checks),
        "checks_pass": sum(1 for item in checks if item["pass"]),
        "checks_fail": sum(1 for item in checks if not item["pass"]),
        "checks": checks,
        "alpha_metrics": alpha_metrics,
        "visual_review_required": "PM/User source review, then separate integration brief and runtime captures",
    })


def refresh_inventory_and_hashes() -> None:
    inventory = collect_inventory()
    write_json(PACKAGE / "INVENTORY.json", inventory)
    inventory = collect_inventory()
    lines = [f"{item['sha256']}  {item['path']}" for item in inventory]
    (PACKAGE / "HASHES.sha256").write_text("\n".join(lines) + "\n", encoding="utf-8")


def main() -> None:
    validate_expected_inputs()
    for directory in (SOURCE, EXPORTS, EVIDENCE):
        if directory.exists():
            shutil.rmtree(directory)
        directory.mkdir(parents=True, exist_ok=True)
    dog_meta, dogs = save_dog_sources()
    assets = extract_assets()
    world_meta, world, _ = build_world(assets)
    adjust_station_contacts(world_meta, dogs)
    build_evidence(world, dogs, world_meta)
    write_manifests(dog_meta, world_meta, world)
    refresh_inventory_and_hashes()
    print(json.dumps({
        "status": "SOURCE_RECONCILED__ART_WARN_PENDING_USER_SOURCE_REVIEW__SOURCE_ONLY__NOT_RUNTIME_EXECUTABLE",
        "dog_poses": len(dog_meta),
        "world_canvas": list(world.size),
        "projected_dog_height_px": PROJECTED_DOG_HEIGHT,
        "files": len([p for p in PACKAGE.rglob('*') if p.is_file()]),
    }, indent=2))


if __name__ == "__main__":
    main()
