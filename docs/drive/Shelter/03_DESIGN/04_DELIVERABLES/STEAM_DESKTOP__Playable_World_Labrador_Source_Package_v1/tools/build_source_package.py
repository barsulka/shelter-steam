#!/usr/bin/env python3
"""Build the bounded R48-05A-S source package.

The editable masters are SVG 1.1 files with named Inkscape-compatible layers.
Raster exports are deterministic, lossless RGBA PNGs rendered from the same
semantic geometry. The script never reads generated reference pixels while
building masters or exports.
"""

from __future__ import annotations

import hashlib
import json
import math
import os
import platform
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Iterable
from xml.sax.saxutils import escape

from PIL import Image, ImageColor, ImageDraw, ImageFont, __version__ as PILLOW_VERSION


PACKAGE = Path(__file__).resolve().parents[1]
REPO_ROOT = next((path for path in PACKAGE.parents if (path / "PROJECTS_RULES.md").is_file()), PACKAGE.parents[5])
SOURCE = PACKAGE / "source"
EXPORTS = PACKAGE / "exports"
EVIDENCE = PACKAGE / "evidence"
MANIFESTS = PACKAGE / "manifests"
BUILD_DATE = "2026-07-13"
CREATOR = "OpenAI Codex — delegated Art Director + Visual Production owner"
AA = 4


@dataclass(frozen=True)
class Shape:
    kind: str
    data: tuple
    fill: str = "#00000000"
    stroke: str = "#00000000"
    width: int = 1
    radius: int = 0


def rgba(value: str) -> tuple[int, int, int, int]:
    value = value.lstrip("#")
    if len(value) == 6:
        value += "ff"
    return tuple(int(value[i : i + 2], 16) for i in range(0, 8, 2))  # type: ignore[return-value]


def color_svg(value: str) -> tuple[str, float]:
    r, g, b, a = rgba(value)
    return f"#{r:02x}{g:02x}{b:02x}", a / 255.0


def _scale_data(data: Iterable[float], factor: int) -> tuple[int, ...]:
    return tuple(round(v * factor) for v in data)


def draw_shape(draw: ImageDraw.ImageDraw, shape: Shape, factor: int = AA) -> None:
    fill = rgba(shape.fill)
    stroke = rgba(shape.stroke)
    width = max(1, round(shape.width * factor))
    if shape.kind == "ellipse":
        box = _scale_data(shape.data, factor)
        draw.ellipse(box, fill=fill, outline=stroke if stroke[3] else None, width=width)
    elif shape.kind == "rect":
        box = _scale_data(shape.data, factor)
        draw.rectangle(box, fill=fill, outline=stroke if stroke[3] else None, width=width)
    elif shape.kind == "rounded_rect":
        box = _scale_data(shape.data, factor)
        draw.rounded_rectangle(
            box,
            radius=round(shape.radius * factor),
            fill=fill,
            outline=stroke if stroke[3] else None,
            width=width,
        )
    elif shape.kind == "polygon":
        pts = list(zip(_scale_data(shape.data[0::2], factor), _scale_data(shape.data[1::2], factor)))
        draw.polygon(pts, fill=fill)
        if stroke[3]:
            draw.line(pts + [pts[0]], fill=stroke, width=width, joint="curve")
    elif shape.kind == "line":
        pts = list(zip(_scale_data(shape.data[0::2], factor), _scale_data(shape.data[1::2], factor)))
        draw.line(pts, fill=stroke if stroke[3] else fill, width=width, joint="curve")
    else:
        raise ValueError(f"unsupported shape kind: {shape.kind}")


def render_layer(size: tuple[int, int], shapes: list[Shape]) -> Image.Image:
    hi = Image.new("RGBA", (size[0] * AA, size[1] * AA), (0, 0, 0, 0))
    draw = ImageDraw.Draw(hi)
    for shape in shapes:
        draw_shape(draw, shape)
    return hi.resize(size, Image.Resampling.LANCZOS)


def composite_layers(
    rendered: dict[str, Image.Image], order: list[str], visible: set[str] | None = None
) -> Image.Image:
    first = next(iter(rendered.values()))
    out = Image.new("RGBA", first.size, (0, 0, 0, 0))
    for layer_id in order:
        if visible is not None and layer_id not in visible:
            continue
        out.alpha_composite(rendered[layer_id])
    return out


def xml_shape(shape: Shape) -> str:
    fill, fill_opacity = color_svg(shape.fill)
    stroke, stroke_opacity = color_svg(shape.stroke)
    common = (
        f' fill="{fill}" fill-opacity="{fill_opacity:.6f}"'
        f' stroke="{stroke}" stroke-opacity="{stroke_opacity:.6f}"'
        f' stroke-width="{shape.width}" stroke-linejoin="round"'
    )
    if shape.kind == "ellipse":
        x0, y0, x1, y1 = shape.data
        return f'<ellipse cx="{(x0+x1)/2}" cy="{(y0+y1)/2}" rx="{(x1-x0)/2}" ry="{(y1-y0)/2}"{common}/>'
    if shape.kind == "rect":
        x0, y0, x1, y1 = shape.data
        return f'<rect x="{x0}" y="{y0}" width="{x1-x0}" height="{y1-y0}"{common}/>'
    if shape.kind == "rounded_rect":
        x0, y0, x1, y1 = shape.data
        return f'<rect x="{x0}" y="{y0}" width="{x1-x0}" height="{y1-y0}" rx="{shape.radius}" ry="{shape.radius}"{common}/>'
    if shape.kind == "polygon":
        pts = " ".join(f"{x},{y}" for x, y in zip(shape.data[0::2], shape.data[1::2]))
        return f'<polygon points="{pts}"{common}/>'
    if shape.kind == "line":
        pts = " ".join(f"{x},{y}" for x, y in zip(shape.data[0::2], shape.data[1::2]))
        return f'<polyline points="{pts}"{common} fill="none"/>'
    raise ValueError(shape.kind)


def write_svg(
    path: Path,
    size: tuple[int, int],
    layers: dict[str, list[Shape]],
    order: list[str],
    hidden: set[str] | None = None,
    metadata: dict[str, str] | None = None,
) -> None:
    hidden = hidden or set()
    metadata = metadata or {}
    path.parent.mkdir(parents=True, exist_ok=True)
    body: list[str] = [
        '<?xml version="1.0" encoding="UTF-8" standalone="no"?>',
        f'<svg xmlns="http://www.w3.org/2000/svg" xmlns:inkscape="http://www.inkscape.org/namespaces/inkscape" width="{size[0]}" height="{size[1]}" viewBox="0 0 {size[0]} {size[1]}">',
        "<metadata>",
        escape(json.dumps(metadata, ensure_ascii=False, sort_keys=True)),
        "</metadata>",
    ]
    for layer_id in order:
        style = ' style="display:none"' if layer_id in hidden else ""
        body.append(
            f'<g id="{escape(layer_id)}" inkscape:groupmode="layer" inkscape:label="{escape(layer_id)}" data-default-visible="{str(layer_id not in hidden).lower()}"{style}>'
        )
        body.extend(xml_shape(shape) for shape in layers[layer_id])
        body.append("</g>")
    body.append("</svg>")
    path.write_text("\n".join(body) + "\n", encoding="utf-8")


def save_layer_hierarchy(
    root: Path,
    export_root: Path,
    size: tuple[int, int],
    layers: dict[str, list[Shape]],
    order: list[str],
    master_name: str,
    hidden: set[str] | None = None,
) -> tuple[dict[str, Image.Image], dict[str, dict[str, Any]]]:
    hidden = hidden or set()
    master = root / f"{master_name}.svg"
    write_svg(
        master,
        size,
        layers,
        order,
        hidden=hidden,
        metadata={
            "creator": CREATOR,
            "date": BUILD_DATE,
            "status": "AUTHORED_EDITABLE_SOURCE",
            "master": master_name,
        },
    )
    rendered: dict[str, Image.Image] = {}
    records: dict[str, dict[str, Any]] = {}
    for z, layer_id in enumerate(order):
        svg_path = root / "layers" / f"{z:02d}__{layer_id}.svg"
        write_svg(
            svg_path,
            size,
            {layer_id: layers[layer_id]},
            [layer_id],
            metadata={
                "creator": CREATOR,
                "date": BUILD_DATE,
                "layer_id": layer_id,
                "status": "AUTHORED_EDITABLE_SOURCE_LAYER",
            },
        )
        image = render_layer(size, layers[layer_id])
        rendered[layer_id] = image
        png_path = export_root / "layers" / f"{z:02d}__{layer_id}.png"
        png_path.parent.mkdir(parents=True, exist_ok=True)
        image.save(png_path, format="PNG", optimize=False, compress_level=9)
        records[layer_id] = {
            "z": z,
            "source": png_rel(svg_path),
            "export": png_rel(png_path),
            "bounds": list(image.getbbox()) if image.getbbox() else None,
            "default_visible": layer_id not in hidden,
        }
    return rendered, records


def png_rel(path: Path) -> str:
    return path.relative_to(PACKAGE).as_posix()


def mirror_shape(shape: Shape, width: int) -> Shape:
    if shape.kind in {"ellipse", "rect", "rounded_rect"}:
        x0, y0, x1, y1 = shape.data
        data = (width - x1, y0, width - x0, y1)
    elif shape.kind in {"polygon", "line"}:
        values: list[float] = []
        for x, y in zip(shape.data[0::2], shape.data[1::2]):
            values.extend((width - x, y))
        data = tuple(values)
    else:
        raise ValueError(shape.kind)
    return Shape(shape.kind, data, shape.fill, shape.stroke, shape.width, shape.radius)


def side_dog_layers() -> tuple[dict[str, list[Shape]], list[str], dict[str, tuple[int, int]]]:
    outline = "#5b3c23ff"
    gold = "#d9a65aff"
    gold_dark = "#bd8440ff"
    gold_far = "#b97c3cff"
    cream = "#f0d39bff"
    green = "#426943ff"
    black = "#2a211aff"
    white = "#fff8eaff"
    layers = {
        "dog.shadow.local": [Shape("ellipse", (55, 257, 468, 292), "#2b21182f")],
        "dog.leg.hind.far": [
            Shape("polygon", (128, 183, 174, 185, 190, 236, 184, 269, 203, 272, 201, 280, 167, 280, 158, 241, 139, 211), gold_far, outline, 3),
        ],
        "dog.leg.fore.far": [
            Shape("polygon", (300, 178, 337, 181, 340, 267, 362, 270, 360, 280, 323, 280, 316, 231), gold_far, outline, 3),
        ],
        "dog.tail": [
            Shape("polygon", (94, 151, 66, 142, 34, 121, 16, 131, 43, 161, 78, 181, 111, 187), gold_dark, outline, 3),
            Shape("line", (28, 132, 49, 151, 77, 166), "#00000000", "#e8bf7cff", 5),
        ],
        "dog.torso": [
            Shape("ellipse", (72, 94, 360, 235), gold, outline, 4),
            Shape("ellipse", (276, 108, 368, 220), gold, outline, 3),
        ],
        "dog.marking.chest": [
            Shape("polygon", (319, 130, 343, 140, 353, 177, 337, 218, 312, 202, 304, 161), cream, "#c9954dff", 2),
        ],
        "dog.detail.chest_fur": [
            Shape("polygon", (324, 144, 338, 159, 328, 174, 342, 188, 325, 207, 312, 183), "#f4dbadcc", "#00000000", 1),
        ],
        "dog.leg.hind.near": [
            Shape("polygon", (112, 177, 156, 182, 153, 231, 137, 269, 158, 272, 156, 280, 118, 280, 112, 238, 92, 208), gold, outline, 3),
        ],
        "dog.leg.fore.near": [
            Shape("polygon", (331, 174, 368, 179, 371, 268, 393, 271, 391, 280, 353, 280, 345, 230), gold, outline, 3),
        ],
        "dog.head": [
            Shape("ellipse", (315, 62, 426, 168), gold, outline, 4),
            Shape("ellipse", (305, 96, 372, 176), gold, outline, 3),
        ],
        "dog.ear.far": [
            Shape("ellipse", (352, 72, 391, 144), gold_far, outline, 3),
        ],
        "dog.ear.near": [
            Shape("polygon", (327, 72, 358, 78, 365, 102, 351, 146, 325, 132, 318, 96), gold_dark, outline, 3),
        ],
        "dog.muzzle": [
            Shape("ellipse", (376, 112, 463, 171), cream, outline, 3),
            Shape("ellipse", (449, 132, 470, 153), black, outline, 2),
            Shape("line", (405, 157, 430, 163, 448, 158), "#00000000", "#7b4e2cff", 2),
        ],
        "dog.eye.open": [
            Shape("ellipse", (391, 96, 408, 113), white, outline, 2),
            Shape("ellipse", (398, 99, 407, 111), black),
        ],
        "dog.eye.blink": [
            Shape("line", (391, 105, 406, 106), "#00000000", outline, 3),
        ],
        "dog.equipment.collar": [
            Shape("polygon", (316, 132, 338, 128, 352, 145, 342, 153, 320, 151), green, "#29432bff", 2),
            Shape("ellipse", (332, 147, 341, 157), "#d4b554ff", "#6e5725ff", 1),
        ],
    }
    order = [
        "dog.shadow.local",
        "dog.leg.hind.far",
        "dog.leg.fore.far",
        "dog.tail",
        "dog.torso",
        "dog.marking.chest",
        "dog.detail.chest_fur",
        "dog.leg.hind.near",
        "dog.leg.fore.near",
        "dog.head",
        "dog.ear.far",
        "dog.ear.near",
        "dog.muzzle",
        "dog.eye.open",
        "dog.eye.blink",
        "dog.equipment.collar",
    ]
    pivots = {
        "actor_root_ground": (256, 280),
        "torso": (235, 166),
        "head_neck": (329, 132),
        "muzzle_contact": (463, 145),
        "ear_near": (338, 91),
        "ear_far": (369, 93),
        "tail": (94, 170),
        "hind_near_hip": (126, 194),
        "hind_near_paw": (136, 277),
        "hind_far_hip": (156, 198),
        "hind_far_paw": (183, 277),
        "fore_near_shoulder": (349, 190),
        "fore_near_paw": (371, 277),
        "fore_far_shoulder": (318, 193),
        "fore_far_paw": (341, 277),
        "collar_equipment": (334, 143),
    }
    return layers, order, pivots


def turn_mid_layers() -> tuple[dict[str, list[Shape]], list[str], dict[str, tuple[int, int]]]:
    outline = "#5b3c23ff"
    gold = "#d9a65aff"
    gold_dark = "#bd8440ff"
    gold_far = "#b97c3cff"
    cream = "#f0d39bff"
    green = "#426943ff"
    black = "#2a211aff"
    white = "#fff8eaff"
    layers = {
        "dog.shadow.local": [Shape("ellipse", (95, 258, 420, 292), "#2b21182f")],
        "dog.leg.hind.far": [Shape("polygon", (176, 186, 211, 184, 214, 268, 231, 272, 229, 280, 195, 280, 190, 231), gold_far, outline, 3)],
        "dog.leg.fore.far": [Shape("polygon", (283, 184, 319, 186, 315, 270, 333, 273, 330, 280, 296, 280, 294, 231), gold_far, outline, 3)],
        "dog.tail": [Shape("polygon", (359, 157, 393, 151, 433, 134, 450, 145, 421, 176, 383, 188, 352, 184), gold_dark, outline, 3)],
        "dog.torso": [Shape("ellipse", (134, 101, 382, 238), gold, outline, 4)],
        "dog.marking.chest": [Shape("polygon", (224, 131, 288, 131, 304, 200, 276, 226, 236, 224, 207, 194), cream, "#c9954dff", 2)],
        "dog.detail.chest_fur": [Shape("polygon", (236, 151, 258, 167, 279, 151, 286, 183, 270, 207, 246, 206, 224, 182), "#f4dbadcc")],
        "dog.leg.hind.near": [Shape("polygon", (139, 181, 178, 184, 167, 268, 184, 273, 181, 280, 148, 280, 146, 233), gold, outline, 3)],
        "dog.leg.fore.near": [Shape("polygon", (326, 181, 362, 185, 363, 270, 381, 273, 379, 280, 345, 280, 343, 232), gold, outline, 3)],
        "dog.head": [Shape("ellipse", (191, 55, 323, 171), gold, outline, 4)],
        "dog.ear.far": [Shape("ellipse", (282, 68, 326, 143), gold_far, outline, 3)],
        "dog.ear.near": [Shape("ellipse", (188, 68, 232, 143), gold_dark, outline, 3)],
        "dog.muzzle": [Shape("ellipse", (218, 113, 298, 177), cream, outline, 3), Shape("ellipse", (248, 129, 269, 149), black, outline, 2), Shape("line", (231, 161, 257, 168, 284, 161), "#00000000", "#7b4e2cff", 2)],
        "dog.eye.open": [Shape("ellipse", (222, 95, 239, 113), white, outline, 2), Shape("ellipse", (228, 99, 237, 111), black), Shape("ellipse", (274, 95, 291, 113), white, outline, 2), Shape("ellipse", (276, 99, 285, 111), black)],
        "dog.eye.blink": [Shape("line", (222, 105, 238, 106), "#00000000", outline, 3), Shape("line", (274, 106, 290, 105), "#00000000", outline, 3)],
        "dog.equipment.collar": [Shape("polygon", (208, 135, 256, 146, 304, 135, 300, 153, 256, 162, 212, 153), green, "#29432bff", 2)],
    }
    order = [
        "dog.shadow.local", "dog.leg.hind.far", "dog.leg.fore.far", "dog.tail",
        "dog.torso", "dog.marking.chest", "dog.detail.chest_fur",
        "dog.leg.hind.near", "dog.leg.fore.near", "dog.head", "dog.ear.far",
        "dog.ear.near", "dog.muzzle", "dog.eye.open", "dog.eye.blink",
        "dog.equipment.collar",
    ]
    pivots = {
        "actor_root_ground": (256, 280), "torso": (256, 168), "head_neck": (256, 137),
        "muzzle_contact": (256, 148), "ear_near": (210, 91), "ear_far": (303, 91),
        "tail": (363, 170), "hind_near_hip": (158, 194), "hind_near_paw": (165, 277),
        "hind_far_hip": (197, 194), "hind_far_paw": (212, 277),
        "fore_near_shoulder": (343, 194), "fore_near_paw": (362, 277),
        "fore_far_shoulder": (299, 194), "fore_far_paw": (314, 277),
        "collar_equipment": (256, 148),
    }
    return layers, order, pivots


def mirror_pivots(pivots: dict[str, tuple[int, int]], width: int) -> dict[str, tuple[int, int]]:
    mirrored = {key: (width - value[0], value[1]) for key, value in pivots.items()}
    # Near/far are anatomical visibility roles and swap after facing changes.
    swaps = [
        ("ear_near", "ear_far"),
        ("hind_near_hip", "hind_far_hip"),
        ("hind_near_paw", "hind_far_paw"),
        ("fore_near_shoulder", "fore_far_shoulder"),
        ("fore_near_paw", "fore_far_paw"),
    ]
    for a, b in swaps:
        mirrored[a], mirrored[b] = mirrored[b], mirrored[a]
    return mirrored


def build_dog() -> dict[str, Any]:
    size = (512, 320)
    right_layers, right_order, right_pivots = side_dog_layers()
    hidden = {"dog.eye.blink", "dog.equipment.collar"}
    right_rendered, right_records = save_layer_hierarchy(
        SOURCE / "labrador" / "right",
        EXPORTS / "labrador" / "right",
        size,
        right_layers,
        right_order,
        "labrador_master_right",
        hidden,
    )
    canonical_visible = set(right_order) - hidden
    right = composite_layers(right_rendered, right_order, canonical_visible)
    right_equipped = composite_layers(right_rendered, right_order, canonical_visible | {"dog.equipment.collar"})
    (EXPORTS / "labrador" / "right").mkdir(parents=True, exist_ok=True)
    right.save(EXPORTS / "labrador" / "right" / "composite_identity.png", compress_level=9)
    right_equipped.save(EXPORTS / "labrador" / "right" / "composite_equipped_collar.png", compress_level=9)

    # Explicit positive-coordinate opposite-facing source; there is no negative SVG transform.
    left_layers = {layer_id: [mirror_shape(shape, size[0]) for shape in shapes] for layer_id, shapes in right_layers.items()}
    left_order = [
        "dog.shadow.local", "dog.leg.fore.far", "dog.leg.hind.far", "dog.tail",
        "dog.torso", "dog.marking.chest", "dog.detail.chest_fur",
        "dog.leg.fore.near", "dog.leg.hind.near", "dog.head", "dog.ear.far",
        "dog.ear.near", "dog.muzzle", "dog.eye.open", "dog.eye.blink",
        "dog.equipment.collar",
    ]
    left_pivots = mirror_pivots(right_pivots, size[0])
    left_rendered, left_records = save_layer_hierarchy(
        SOURCE / "labrador" / "left",
        EXPORTS / "labrador" / "left",
        size,
        left_layers,
        left_order,
        "labrador_master_left",
        hidden,
    )
    left_visible = set(left_order) - hidden
    left = composite_layers(left_rendered, left_order, left_visible)
    left_equipped = composite_layers(left_rendered, left_order, left_visible | {"dog.equipment.collar"})
    left.save(EXPORTS / "labrador" / "left" / "composite_identity.png", compress_level=9)
    left_equipped.save(EXPORTS / "labrador" / "left" / "composite_equipped_collar.png", compress_level=9)

    mid_layers, mid_order, mid_pivots = turn_mid_layers()
    mid_rendered, mid_records = save_layer_hierarchy(
        SOURCE / "labrador" / "turn_mid",
        EXPORTS / "labrador" / "turn_mid",
        size,
        mid_layers,
        mid_order,
        "labrador_master_turn_mid",
        hidden,
    )
    mid_visible = set(mid_order) - hidden
    mid = composite_layers(mid_rendered, mid_order, mid_visible)
    mid.save(EXPORTS / "labrador" / "turn_mid" / "composite_identity.png", compress_level=9)

    silhouette_paths: dict[str, str] = {}
    for name, image in {"right": right, "turn_mid": mid, "left": left}.items():
        alpha = image.getchannel("A")
        silhouette = Image.new("RGBA", image.size, (0, 0, 0, 0))
        silhouette.putalpha(alpha)
        black = Image.new("RGBA", image.size, (25, 21, 18, 255))
        black.putalpha(alpha)
        path = EXPORTS / "labrador" / name / "silhouette.png"
        black.save(path, compress_level=9)
        silhouette_paths[name] = png_rel(path)

    evidence_records = build_dog_evidence({"right": right, "turn_mid": mid, "left": left}, {"right": right_pivots, "turn_mid": mid_pivots, "left": left_pivots})
    manifest = {
        "schema_version": "shelter-labrador-source/v1",
        "status": "AUTHORED_VISUAL_SOURCE_FOUNDATION__SOURCE_READY",
        "actor_id": "dog.labrador_intro",
        "source_maturity": "SOURCE_READY_ONLY__NO_RUNTIME_ART_PASS",
        "dog_dna_status": "WORKING_DRAFT_TECHNICAL_PROOF",
        "canvas": {
            "width": 512,
            "height": 320,
            "ground_baseline_y": 280,
            "alpha_bounds_rgba": {
                "right_identity_with_shadow": [12, 59, 473, 295],
                "left_identity_with_shadow": [39, 59, 500, 295],
                "turn_mid_identity_with_shadow": [93, 52, 454, 295]
            },
            "alpha_bounds_identity_without_shadow": {
                "right": [12, 59, 473, 284],
                "left": [39, 59, 500, 284],
                "turn_mid": [131, 52, 454, 284]
            },
            "alpha_bounds_note": "Pillow getbbox convention: [left, top, right-exclusive, bottom-exclusive]. Paw strokes may extend 4 px below the authored root baseline; local shadow extends 15 px below it."
        },
        "identity_envelope": {
            "body_type": "current_labrador_large_sturdy_visual_envelope_only",
            "side_torso_alpha_width_px": 302,
            "side_torso_alpha_height_px": 147,
            "side_identity_alpha_width_px": 461,
            "side_identity_alpha_height_without_shadow_px": 225,
            "side_full_alpha_height_with_shadow_px": 236,
            "side_paw_pivot_span_px": 235,
            "side_head_alpha_width_px": 127,
            "muzzle_contact_pivot_reach_from_actor_root_px": 207,
            "muzzle_alpha_reach_from_actor_root_px": 217,
            "tail_alpha_reach_from_actor_root_px": 244,
            "identity_alpha_offsets_from_root": {
                "right": [-244, -221, 217, 4],
                "left": [-217, -221, 244, 4]
            },
            "local_shadow_bottom_offset_from_root_px": 15,
            "correction_limits": {
                "actor_uniform_scale": [0.94, 1.06],
                "limb_pivot_translation_px": 8,
                "head_neck_translation_px": 6,
                "muzzle_contact_translation_px": 5,
                "station_contact_root_translation_px": 12,
                "rule": "Limits are source-repair envelope only; exceeding them requires Art/Technical review, never silent non-uniform scaling."
            }
        },
        "facing_policy": {
            "value": "authored_both",
            "canonical_facing": "right",
            "opposite_facing": "left",
            "implementation": "Both masters contain positive coordinates and independent near/far z-order. No runtime negative scale is authorized.",
            "asymmetry": "Near/far legs and ears, collar transform and layer order are facing-specific. Coat chest mark is anatomical center and retained.",
            "physical_turn": "Separate authored front/three-quarter midpoint source; physical turn is right -> turn_mid -> left or reverse, never a flip-only event."
        },
        "masters": {
            "right": "source/labrador/right/labrador_master_right.svg",
            "left": "source/labrador/left/labrador_master_left.svg",
            "turn_mid": "source/labrador/turn_mid/labrador_master_turn_mid.svg"
        },
        "composites": {
            "right_identity": "exports/labrador/right/composite_identity.png",
            "right_equipped": "exports/labrador/right/composite_equipped_collar.png",
            "left_identity": "exports/labrador/left/composite_identity.png",
            "left_equipped": "exports/labrador/left/composite_equipped_collar.png",
            "turn_mid_identity": "exports/labrador/turn_mid/composite_identity.png"
        },
        "pivots": {"right": right_pivots, "left": left_pivots, "turn_mid": mid_pivots},
        "z_order": {"right": right_order, "left": left_order, "turn_mid": mid_order},
        "layers": {"right": right_records, "left": left_records, "turn_mid": mid_records},
        "silhouettes": silhouette_paths,
        "evidence": evidence_records,
        "layer_contract": {
            "innate_identity_layers": ["dog.torso", "dog.head", "dog.muzzle", "dog.ear.near", "dog.ear.far", "dog.tail", "dog.marking.chest"],
            "independently_registerable_limb_layers": ["dog.leg.fore.near", "dog.leg.fore.far", "dog.leg.hind.near", "dog.leg.hind.far"],
            "optional_nonessential_at_96": ["dog.detail.chest_fur"],
            "equipment_separate": ["dog.equipment.collar"],
            "local_shadow_separate": ["dog.shadow.local"],
            "blink_swap": {"open": "dog.eye.open", "closed": "dog.eye.blink"}
        },
        "excluded_claims": ["production rig selection", "runtime binding", "final animation", "object transfer", "global style lock", "real-dog likeness"]
    }
    write_json(MANIFESTS / "labrador_source_manifest.json", manifest)
    return manifest


def subject_at_height(image: Image.Image, target: int) -> Image.Image:
    bbox = image.getbbox()
    if not bbox:
        raise ValueError("empty subject")
    crop = image.crop(bbox)
    scale = target / crop.height
    width = max(1, round(crop.width * scale))
    resized = crop.resize((width, target), Image.Resampling.LANCZOS)
    canvas = Image.new("RGBA", (width + 32, target + 24), (0, 0, 0, 0))
    canvas.alpha_composite(resized, (16, 8))
    return canvas


def black_silhouette(image: Image.Image) -> Image.Image:
    alpha = image.getchannel("A")
    out = Image.new("RGBA", image.size, (24, 21, 18, 255))
    out.putalpha(alpha)
    return out


def draw_label(draw: ImageDraw.ImageDraw, xy: tuple[int, int], label: str, fill=(58, 45, 35, 255)) -> None:
    draw.text(xy, label, fill=fill, font=ImageFont.load_default())


def build_dog_evidence(images: dict[str, Image.Image], pivots: dict[str, dict[str, tuple[int, int]]]) -> dict[str, Any]:
    records: dict[str, Any] = {"sizes": {}}
    order = ["right", "turn_mid", "left"]
    for target in (216, 144, 96):
        scaled = {name: subject_at_height(images[name], target) for name in order}
        for name, image in scaled.items():
            p = EVIDENCE / "labrador" / str(target) / f"{name}.png"
            p.parent.mkdir(parents=True, exist_ok=True)
            image.save(p, compress_level=9)
            sp = EVIDENCE / "labrador" / str(target) / f"{name}__silhouette.png"
            black_silhouette(image).save(sp, compress_level=9)
        panel_w = max(im.width for im in scaled.values())
        sheet = Image.new("RGBA", (panel_w * 3 + 64, target + 64), (246, 241, 229, 255))
        draw = ImageDraw.Draw(sheet)
        for i, name in enumerate(order):
            x = 16 + i * panel_w + (panel_w - scaled[name].width) // 2
            sheet.alpha_composite(scaled[name], (x, 24))
            draw_label(draw, (16 + i * panel_w, 8), name)
        draw_label(draw, (8, target + 45), f"native subject height: {target}px | source hierarchy: one master family")
        sheet_path = EVIDENCE / "labrador" / f"labrador_facing_turn_readability_{target}.png"
        sheet.save(sheet_path, compress_level=9)
        silhouette_sheet = Image.new("RGBA", (panel_w * 3 + 64, target + 64), (246, 241, 229, 255))
        silhouette_draw = ImageDraw.Draw(silhouette_sheet)
        for i, name in enumerate(order):
            silhouette = black_silhouette(scaled[name])
            x = 16 + i * panel_w + (panel_w - silhouette.width) // 2
            silhouette_sheet.alpha_composite(silhouette, (x, 24))
            draw_label(silhouette_draw, (16 + i * panel_w, 8), name)
        draw_label(silhouette_draw, (8, target + 45), f"silhouette alpha height: {target}px | right / physical-turn midpoint / left")
        silhouette_sheet_path = EVIDENCE / "labrador" / f"labrador_silhouette_readability_{target}.png"
        silhouette_sheet.save(silhouette_sheet_path, compress_level=9)
        records["sizes"][str(target)] = {
            "right": png_rel(EVIDENCE / "labrador" / str(target) / "right.png"),
            "turn_mid": png_rel(EVIDENCE / "labrador" / str(target) / "turn_mid.png"),
            "left": png_rel(EVIDENCE / "labrador" / str(target) / "left.png"),
            "sheet": png_rel(sheet_path),
            "silhouette_sheet": png_rel(silhouette_sheet_path),
            "subject_height_px": target,
        }

    overlay = images["right"].copy()
    draw = ImageDraw.Draw(overlay)
    bbox = overlay.getbbox()
    if bbox:
        draw.rectangle(bbox, outline=(41, 140, 180, 255), width=2)
    draw.line((0, 280, 511, 280), fill=(224, 75, 75, 255), width=2)
    for name, (x, y) in pivots["right"].items():
        draw.line((x - 4, y, x + 4, y), fill=(64, 210, 160, 255), width=1)
        draw.line((x, y - 4, x, y + 4), fill=(64, 210, 160, 255), width=1)
        draw_label(draw, (min(440, x + 5), max(0, y - 9)), name)
    overlay_path = EVIDENCE / "labrador" / "labrador_alpha_bounds_pivots_right.png"
    overlay.save(overlay_path, compress_level=9)
    records["pivot_overlay"] = png_rel(overlay_path)
    return records


def world_layers() -> tuple[dict[str, list[Shape]], list[str], set[str]]:
    layers = {
        "world.ground.base": [
            Shape("polygon", (18, 164, 55, 151, 1480, 151, 1518, 165, 1530, 189, 1504, 211, 42, 211, 6, 190), "#604b32ff", "#3b3126ff", 2),
        ],
        "world.ground.grass_mass": [
            Shape("polygon", (30, 159, 86, 145, 180, 151, 278, 142, 384, 151, 506, 143, 636, 151, 756, 144, 884, 150, 1010, 142, 1144, 151, 1260, 144, 1386, 151, 1504, 148, 1516, 173, 22, 173), "#667548ff", "#435335ff", 2),
            Shape("line", (70, 151, 78, 137, 84, 151, 93, 132, 101, 151), "#00000000", "#86945dff", 3),
            Shape("line", (1180, 151, 1188, 135, 1195, 151, 1204, 138, 1212, 151), "#00000000", "#86945dff", 3),
        ],
        "world.ground.dirt_worn": [
            Shape("ellipse", (470, 154, 1010, 205), "#8a6946b8"),
            Shape("ellipse", (900, 163, 1280, 205), "#7b5b3da8"),
        ],
        "world.ground.sand_soft": [
            Shape("ellipse", (150, 151, 450, 207), "#b99a65d9", "#8f754eff", 2),
        ],
        "world.path.main": [
            Shape("polygon", (472, 158, 1320, 158, 1388, 173, 1324, 197, 472, 197, 420, 177), "#a98559d9", "#765c3dff", 2),
        ],
        "world.path.used_taper_end": [
            Shape("polygon", (420, 177, 472, 158, 472, 197), "#a98559d9", "#765c3dff", 2),
            Shape("polygon", (1320, 158, 1388, 173, 1324, 197), "#a98559d9", "#765c3dff", 2),
        ],
        "world.transition.grass_dirt": [
            Shape("ellipse", (450, 146, 1035, 177), "#77805872"),
        ],
        "world.transition.grass_sand": [
            Shape("ellipse", (135, 144, 465, 177), "#8d8a5f72"),
        ],
        "world.transition.ground_path": [
            Shape("line", (475, 160, 700, 164, 950, 161, 1180, 165, 1325, 161), "#00000000", "#c3a47788", 6),
        ],
        "world.fence.back_span": [
            Shape("line", (112, 115, 410, 115), "#00000000", "#725334ff", 7),
            Shape("line", (1070, 116, 1390, 116), "#00000000", "#725334ff", 7),
            Shape("line", (112, 139, 410, 139), "#00000000", "#7d5b39ff", 6),
            Shape("line", (1070, 140, 1390, 140), "#00000000", "#7d5b39ff", 6),
        ],
        "world.fence.front_span": [
            Shape("line", (170, 174, 370, 174), "#00000000", "#5e432dff", 8),
            Shape("line", (1160, 174, 1344, 174), "#00000000", "#5e432dff", 8),
        ],
        "world.fence.post_end_open_gap": [
            Shape("rounded_rect", (102, 91, 120, 177), "#755537ff", "#4e3927ff", 3, 3),
            Shape("rounded_rect", (402, 91, 420, 177), "#755537ff", "#4e3927ff", 3, 3),
            Shape("rounded_rect", (1060, 92, 1078, 178), "#755537ff", "#4e3927ff", 3, 3),
            Shape("rounded_rect", (1382, 92, 1400, 178), "#755537ff", "#4e3927ff", 3, 3),
        ],
        "world.yard.bicycle_pad": [
            Shape("rounded_rect", (205, 153, 402, 202), "#9a8057aa", "#6d583cff", 2, 12),
        ],
        "world.shadow.local_prop": [
            Shape("ellipse", (650, 178, 855, 207), "#241c152b"),
            Shape("ellipse", (1030, 181, 1220, 207), "#241c152b"),
        ],
        "world.anchor.bicycle_parking": [
            Shape("ellipse", (278, 158, 336, 190), "#00b5d200", "#00b5d2ff", 2),
            Shape("line", (307, 151, 307, 198), "#00000000", "#00b5d2ff", 2),
            Shape("line", (270, 174, 344, 174), "#00000000", "#00b5d2ff", 2),
        ],
    }
    order = [
        "world.ground.base", "world.ground.grass_mass", "world.ground.dirt_worn",
        "world.ground.sand_soft", "world.path.main", "world.path.used_taper_end",
        "world.transition.grass_dirt", "world.transition.grass_sand",
        "world.transition.ground_path", "world.fence.back_span",
        "world.fence.post_end_open_gap", "world.yard.bicycle_pad",
        "world.shadow.local_prop", "world.fence.front_span",
        "world.anchor.bicycle_parking",
    ]
    hidden = {"world.anchor.bicycle_parking"}
    return layers, order, hidden


def build_world() -> dict[str, Any]:
    size = (1536, 216)
    layers, order, hidden = world_layers()
    rendered, records = save_layer_hierarchy(
        SOURCE / "world", EXPORTS / "world", size, layers, order, "world_master", hidden
    )
    visible = set(order) - hidden
    composite = composite_layers(rendered, order, visible)
    composite_path = EXPORTS / "world" / "world_composite_216.png"
    composite.save(composite_path, compress_level=9)
    guide = composite_layers(rendered, order, set(order))
    guide_path = EVIDENCE / "world" / "world_bicycle_parking_anchor_overlay_216.png"
    guide_path.parent.mkdir(parents=True, exist_ok=True)
    guide.save(guide_path, compress_level=9)
    size_records: dict[str, Any] = {}
    for target in (216, 144, 96):
        width = round(size[0] * target / size[1])
        image = composite if target == 216 else composite.resize((width, target), Image.Resampling.LANCZOS)
        path = EVIDENCE / "world" / f"world_native_{target}.png"
        image.save(path, compress_level=9)
        size_records[str(target)] = {"path": png_rel(path), "width": width, "height": target}
    manifest = {
        "schema_version": "shelter-world-source/v1",
        "status": "AUTHORED_VISUAL_SOURCE_FOUNDATION__SOURCE_READY",
        "source_maturity": "SOURCE_READY_ONLY__NO_RUNTIME_ART_PASS",
        "canvas": {"width": 1536, "height": 216, "baseline_y": 211, "transparent_exterior": True},
        "master": "source/world/world_master.svg",
        "composite": png_rel(composite_path),
        "layers": records,
        "z_order": order,
        "bounded_scope": {
            "soft_ends": "used ends embedded only in world.ground.base",
            "path": "one main path with two used taper/end pieces",
            "transitions": ["grass_dirt", "grass_sand", "ground_path"],
            "fence": ["back_span", "front_span", "post_end_open_gap"],
            "fence_corner": "OMITTED_NOT_USED",
            "sand": "bicycle service pad/yard relation only",
            "bicycle": "parking anchor only; no vehicle choreography or interaction",
            "decor_atlas": "NOT_CREATED"
        },
        "anchor_records": {
            "bicycle_parking": {"x": 307, "y": 174, "facing": "left_or_right_not_bound", "interactive": False, "owner": "world_staging_only"}
        },
        "shadow_ownership": {
            "world_prop": "world.shadow.local_prop",
            "dog": "dog.shadow.local in Labrador hierarchy",
            "rule": "No shadow is baked into ground/base or dog identity layers."
        },
        "evidence": {"sizes": size_records, "parking_anchor_overlay": png_rel(guide_path)},
        "excluded_claims": ["final terrain atlas", "global world layout", "interactive fence/gate", "bicycle mechanics", "final palette/style lock"]
    }
    write_json(MANIFESTS / "world_source_manifest.json", manifest)
    return manifest


def anchor_cross(x: int, y: int, color: str) -> list[Shape]:
    return [
        Shape("line", (x - 8, y, x + 8, y), "#00000000", color, 2),
        Shape("line", (x, y - 8, x, y + 8), "#00000000", color, 2),
    ]


def station_plane(station: str) -> tuple[dict[str, list[Shape]], list[str], dict[str, Any]]:
    size = (1024, 360)
    if station == "kitchen":
        bounds = (410, 92, 650, 300)
        roots = {"left": 250, "right": 774}
        contact_plane = (400, 188, 660, 255)
        work_roots = {"left": (286, 300), "right": (738, 300)}
        shape = [
            Shape("rounded_rect", bounds, "#d9a65a20", "#8b6643ff", 3, 12),
            Shape("rect", (430, 190, 630, 264), "#6b83532a", "#6b8353ff", 2),
            Shape("line", (410, 300, 650, 300), "#00000000", "#d85b54ff", 3),
        ]
        category = "Building"
        authority = "object.kitchen / CookTask"
        source_ref = "docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Semantic_Asset_Pack_v1/approved/buildings/kitchen.png"
        source_status = "APPROVED_FOR_CODEX__TEMPORARY_SEMANTIC_PLACEHOLDER__REFERENCE_ONLY_FOR_ANCHOR_PLANE"
    else:
        bounds = (420, 188, 620, 300)
        roots = {"left": 262, "right": 762}
        contact_plane = (405, 176, 636, 252)
        work_roots = {"left": (300, 300), "right": (724, 300)}
        shape = [
            Shape("rounded_rect", bounds, "#b78a4b20", "#8b6643ff", 3, 8),
            Shape("rect", (438, 208, 602, 252), "#6b83532a", "#6b8353ff", 2),
            Shape("line", (420, 300, 620, 300), "#00000000", "#d85b54ff", 3),
        ]
        category = "Utility Prop"
        authority = "object.packing_table / PackTask"
        source_ref = "docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Semantic_Asset_Pack_v1/cards/packing_table.md"
        source_status = "NEEDED__NO_APPROVED_VISUAL__ANCHOR_PLANE_IS_NOT_REPLACEMENT_ART"
    approach = {"left": (78, 300), "right": (946, 300)}
    contact = {"left": (roots["left"], 300), "right": (roots["right"], 300)}
    exit_anchor = approach.copy()
    identity_top = 79
    identity_bottom = 304
    # Exact directional alpha envelopes relative to actor root, excluding the
    # separately owned local shadow: right-facing [-244, +217], left-facing
    # [-217, +244]. These are not symmetric placeholder rectangles.
    from_left_clearance = (roots["left"] - 244, identity_top, roots["left"] + 217, identity_bottom)
    from_right_clearance = (roots["right"] - 217, identity_top, roots["right"] + 244, identity_bottom)
    layers = {
        "station.guide.bounds": shape,
        "station.guide.contact_plane": [Shape("rect", contact_plane, "#4ab3c924", "#2f9eb7ff", 2)],
        "station.guide.clearance": [
            Shape("rect", from_left_clearance, "#5ac89012", "#44a778aa", 2),
            Shape("rect", from_right_clearance, "#5ac89012", "#44a778aa", 2),
        ],
        "station.anchor.approach": anchor_cross(*approach["left"], "#4a87d4ff") + anchor_cross(*approach["right"], "#4a87d4ff"),
        "station.anchor.contact_align": anchor_cross(*contact["left"], "#d46f4aff") + anchor_cross(*contact["right"], "#d46f4aff"),
        "station.anchor.work": anchor_cross(*work_roots["left"], "#52b765ff") + anchor_cross(*work_roots["right"], "#52b765ff"),
        "station.anchor.exit": anchor_cross(*exit_anchor["left"], "#9f69c9ff") + anchor_cross(*exit_anchor["right"], "#9f69c9ff"),
        "station.shadow.local": [Shape("ellipse", (bounds[0] - 20, 284, bounds[2] + 20, 318), "#241c152f")],
        "station.occlusion.front_owner": [Shape("rect", (bounds[0], bounds[3] - 26, bounds[2], bounds[3]), "#b05d3526", "#b05d35aa", 1)],
    }
    order = list(layers)
    record = {
        "station_id": f"object.{station if station == 'kitchen' else 'packing_table'}",
        "category": category,
        "authority": authority,
        "source_reference": source_ref,
        "source_reference_status": source_status,
        "anchor_plane_source_status": "AUTHORED_TECHNICAL_ART_SOURCE__ANCHOR_AND_CLEARANCE_ONLY__NOT_STATION_REPLACEMENT_ART",
        "canvas": {"width": size[0], "height": size[1], "baseline_y": 300},
        "station_bounds": list(bounds),
        "approach_anchors": approach,
        "contact_align_body_root_anchors": contact,
        "work_body_root_anchors": work_roots,
        "exit_anchors": exit_anchor,
        "contact_planes": {
            "head_paw_work_plane": list(contact_plane),
            "ground_plane_y": 300
        },
        "allowed_facing": {
            "from_left": "right",
            "from_right": "left",
            "cross_station_flip": "forbidden",
            "physical_turn": "must happen before approach when requested facing changes"
        },
        "clearance_envelope": {
            "actor": "dog.labrador_intro",
            "identity_width_px": 461,
            "identity_height_px": 225,
            "from_left_facing_right_bounds": list(from_left_clearance),
            "from_right_facing_left_bounds": list(from_right_clearance),
            "root_to_muzzle_contact_pivot_reach_px": 207,
            "root_to_muzzle_alpha_reach_px": 217,
            "root_to_tail_alpha_reach_px": 244,
            "local_shadow_bottom_offset_px": 15,
            "validation": "both directional identity alpha envelopes are included in source overlay; local shadow remains separately owned"
        },
        "z_order_and_occlusion": {
            "dog_shadow_owner": "dog.shadow.local",
            "station_shadow_owner": "station.shadow.local",
            "station_base": "behind dog",
            "foreground_contact_lip": "station.occlusion.front_owner may occlude only contacting forepaws/lower limb tips",
            "dog_identity": "never flattened into station source"
        },
        "phase_rules": {
            "entry": "approach anchor -> authored start/walk/stop -> contact-align; station state remains runtime-owned",
            "work": "lock only after contact-align; work head/paw pose stays inside declared plane",
            "exit": "work loop exit -> contact release -> exit anchor",
            "cancel": "before contact lock, back out to approach; during work, wait for safe loop boundary; no task/resource mutation from Art source"
        }
    }
    return layers, order, record


def build_stations() -> dict[str, Any]:
    all_records: dict[str, Any] = {
        "schema_version": "shelter-station-anchor-source/v1",
        "status": "SOURCE_READY_ANCHOR_PLANES__NO_RUNTIME_BINDING",
        "actor_envelope": "dog.labrador_intro current source envelope only",
        "stations": {}
    }
    for name in ("kitchen", "packing_table"):
        layers, order, record = station_plane(name)
        rendered, layer_records = save_layer_hierarchy(
            SOURCE / "stations" / name,
            EXPORTS / "stations" / name,
            (1024, 360),
            layers,
            order,
            f"{name}_anchor_plane",
            set(),
        )
        composite = composite_layers(rendered, order)
        out = EVIDENCE / "stations" / f"{name}_anchor_clearance_overlay.png"
        out.parent.mkdir(parents=True, exist_ok=True)
        composite.save(out, compress_level=9)
        record["master"] = f"source/stations/{name}/{name}_anchor_plane.svg"
        record["evidence_overlay"] = png_rel(out)
        record["layers"] = layer_records
        all_records["stations"][record["station_id"]] = record
    write_json(MANIFESTS / "station_anchors.json", all_records)
    return all_records


def write_json(path: Path, data: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2, sort_keys=True) + "\n", encoding="utf-8")


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1024 * 1024), b""):
            h.update(chunk)
    return h.hexdigest()


def artifact_paths() -> list[Path]:
    roots = [SOURCE, EXPORTS, EVIDENCE, PACKAGE / "references"]
    paths: list[Path] = []
    for root in roots:
        if root.exists():
            paths.extend(path for path in root.rglob("*") if path.is_file())
    return sorted(paths)


def build_provenance() -> dict[str, Any]:
    input_refs = {
        "docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Labrador_P0_Accepted_Action_Manifest_v1.md": "exact accepted 12-row action authority",
        "docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/approved_art_files/D-011_steam_overlay_main_strip_v1_reference.png": "Main Strip world/readability direction only",
        "docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/approved_art_files/STEAM_OVERLAY__dog_action_labrador_watering_can__approved_direction.png": "current Labrador identity direction only; not copied into source",
        "docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Semantic_Asset_Pack_v1/approved/buildings/kitchen.png": "temporary Kitchen semantic placeholder, anchor relation only",
        "docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Semantic_Asset_Pack_v1/cards/packing_table.md": "Packing Table semantic/category record; no approved visual reference"
    }
    missing_refs = [path for path in input_refs if not (REPO_ROOT / path).is_file()]
    if missing_refs:
        raise FileNotFoundError(f"Missing required provenance input references: {missing_refs}")
    data = {
        "schema_version": "shelter-art-provenance/v1",
        "package": PACKAGE.name,
        "creator": CREATOR,
        "date": BUILD_DATE,
        "toolchain": {
            "builder": "tools/build_source_package.py",
            "python": platform.python_version(),
            "pillow": PILLOW_VERSION,
            "svg": "SVG 1.1 with named Inkscape-compatible layers",
            "png": "lossless RGBA, compression_level=9, no palette quantization"
        },
        "rights_permission": {
            "authored_sources": "project-original source geometry created for Shelter under delegated package ownership",
            "repo_references": "local project references used only within their documented direction/evidence status",
            "external_copy": "none",
            "real_dog_likeness": "none claimed"
        },
        "ai_use": {
            "declared": True,
            "mode": "one built-in image generation used as flattened reference-only shape exploration",
            "reference_path": "references/ai/labrador_three_pose_reference__flattened_ai.png",
            "reference_prompt": "references/ai/PROMPT.md",
            "embedded_ai_pixels_in_master_or_exports": False,
            "master_method": "independent named SVG geometry authored by deterministic builder"
        },
        "input_references": {
            path: {"role": role, "sha256": sha256(REPO_ROOT / path)}
            for path, role in sorted(input_refs.items())
        },
        "source_export_policy": {
            "editable_master": "SVG 1.1 named layers plus one SVG per semantic layer",
            "lossless_exports": "RGBA PNG",
            "single_hierarchy_for_sizes": True,
            "negative_scale": False,
            "runtime_import": False,
            "final_style_palette_lock": False
        },
        "maturity": {
            "world": "AUTHORED_VISUAL_SOURCE_FOUNDATION__SOURCE_READY",
            "labrador": "AUTHORED_VISUAL_SOURCE_FOUNDATION__SOURCE_READY",
            "stations": "SOURCE_READY_ANCHOR_PLANES__NOT_REPLACEMENT_ART",
            "runtime": "NOT_STARTED_OUT_OF_SCOPE"
        },
        "artifact_hashes_sha256": {png_rel(path): sha256(path) for path in artifact_paths()},
        "allowed_use": ["R48-05A Technical readback", "source-level Art QA", "future lossless import under accepted executable brief"],
        "excluded_claims": ["runtime Art PASS", "production pipeline selection", "object transfer", "final style lock", "shipping art", "real dog portrait"]
    }
    write_json(PACKAGE / "PROVENANCE.json", data)
    return data


def build_package_manifest(dog: dict[str, Any], world: dict[str, Any], stations: dict[str, Any]) -> None:
    manifest = {
        "schema_version": "shelter-playable-world-labrador-source-package/v1",
        "package_id": "STEAM_DESKTOP__Playable_World_Labrador_Source_Package_v1",
        "milestone": "R48-05A-S",
        "date": BUILD_DATE,
        "owner": CREATOR,
        "profile": "hybrid",
        "verdict_scope": "SOURCE_LEVEL_ONLY",
        "runtime_authority": "godot_state",
        "accepted_action_manifest": "docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Labrador_P0_Accepted_Action_Manifest_v1.md",
        "accepted_action_ledger": "manifests/accepted_action_scope.json",
        "accepted_rows": 12,
        "components": {
            "world": {"manifest": "manifests/world_source_manifest.json", "status": world["status"]},
            "labrador": {"manifest": "manifests/labrador_source_manifest.json", "status": dog["status"]},
            "stations": {"manifest": "manifests/station_anchors.json", "status": stations["status"]}
        },
        "source_level_sizes": [216, 144, 96],
        "source_only_boundaries": {
            "object_transfer": False,
            "runtime_binding": False,
            "godot_import": False,
            "negative_scale_shortcut": False,
            "bicycle_choreography": False,
            "building_replacement": False,
            "room_art": False,
            "broad_decor_atlas": False,
            "final_style_palette_lock": False
        },
        "next_owner": "Technical/Codex readback, then PM activation gate; no runtime authority is implied"
    }
    write_json(MANIFESTS / "package_manifest.json", manifest)


def main() -> int:
    for directory in (SOURCE, EXPORTS, EVIDENCE, MANIFESTS):
        directory.mkdir(parents=True, exist_ok=True)
    dog = build_dog()
    world = build_world()
    stations = build_stations()
    build_package_manifest(dog, world, stations)
    build_provenance()
    print(json.dumps({
        "status": "BUILT",
        "package": str(PACKAGE),
        "source_files": len([p for p in SOURCE.rglob('*') if p.is_file()]),
        "export_files": len([p for p in EXPORTS.rglob('*') if p.is_file()]),
        "evidence_files": len([p for p in EVIDENCE.rglob('*') if p.is_file()]),
        "python": sys.executable,
        "pillow": PILLOW_VERSION,
    }, ensure_ascii=False, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
