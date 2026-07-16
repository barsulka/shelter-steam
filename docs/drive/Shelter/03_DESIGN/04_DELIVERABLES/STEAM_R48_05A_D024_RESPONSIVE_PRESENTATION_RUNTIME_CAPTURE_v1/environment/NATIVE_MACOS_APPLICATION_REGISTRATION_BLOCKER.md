# Native macOS application-registration blocker

Classification: `ENVIRONMENT / PRE_GODOT`, not a Shelter runtime failure.

Coordinator readback of the user-provided crash report:

- Godot `4.5.1` arm64 was launched from
  `/Users/barsulka/Downloads/Godot.app` with Codex/ChatGPT as the responsible
  parent process;
- the main thread aborted during HIServices `_RegisterApplication` →
  `GetCurrentProcess` → AppKit `NSApplication` initialization;
- the process terminated with `SIGABRT` before Godot project/runtime
  initialization;
- there were no Shelter script/resource frames and no project-code stack.

After this classification, no further direct GUI-binary launch was attempted.
Computer-use access to Godot was unavailable, and the sandbox blocked the
LaunchServices path. Headless Godot remained available for all mechanical and
regression checks, but its dummy rendering backend cannot provide native
desktop or passthrough evidence.

The original user attachment was not copied into the repository.
