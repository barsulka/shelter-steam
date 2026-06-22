# Performance Observability

Shelter Desktop should treat performance as a product feature. The companion strip may stay open for hours, so every new visual system should be easy to watch while it runs.

## Built-In Godot Tools

Godot has several official performance surfaces:

- Editor Debugger panel:
  - `Debugger > Profiler` for script and engine task timings.
  - `Debugger > Visual Profiler` for frame/render timing, including CPU/GPU frame cost.
  - `Debugger > Monitors` for live graphs such as FPS, memory, object counts, and render counters.
  - `Debugger > Video RAM` for texture/resource memory inspection.
- Console:
  - `--print-fps` prints live FPS to stdout.
  - Project setting `Debug > Settings > stdout > Print FPS` enables the same style of output from settings.
- Runtime API:
  - `Performance.get_monitor(...)` exposes live counters for in-game debug UI.
  - Useful monitors for this project include:
    - `Performance.TIME_FPS`
    - `Performance.TIME_PROCESS`
    - `Performance.TIME_PHYSICS_PROCESS`
    - `Performance.MEMORY_STATIC`
    - `Performance.OBJECT_COUNT`
    - `Performance.OBJECT_NODE_COUNT`
    - `Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME`
    - `Performance.RENDER_VIDEO_MEM_USED`
    - `Performance.RENDER_TEXTURE_MEM_USED`

Official references:

- `https://docs.godotengine.org/en/stable/classes/class_performance.html`
- `https://docs.godotengine.org/en/stable/tutorials/editor/debugger_panel.html`
- `https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html`
- `https://docs.godotengine.org/en/stable/tutorials/scripting/logging.html`

## Shelter Companion Demo

The companion field demo has a lightweight in-game performance HUD enabled by default. It updates on a `0.5s` timer instead of a permanent `_process()` loop.

It currently shows:

- FPS;
- frame time;
- physics frame time;
- static memory;
- reported video memory;
- texture memory;
- draw calls;
- object count;
- node count.

Use the settings window to toggle `Performance HUD`.

Use the console preset when watching stdout is useful:

```sh
tools/run-companion-field-demo.sh perf
```

That preset launches the same companion strip with `--print-fps` and the in-game HUD enabled.

## Caveats

- Some Godot monitors are intended for debug/editor builds or update with a short delay.
- `Performance` gives Godot-side counters, not full system-level CPU percentage, battery drain, or per-process GPU power.
- Production profiling still needs platform checks on both Windows and macOS.
