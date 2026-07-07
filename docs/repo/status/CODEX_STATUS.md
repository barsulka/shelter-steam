# Codex Status

## 2026-07-07 - Shelter MCP bootstrap and repo tools polish v2

- Branch: `master`
- Source brief: `docs/drive/Shelter/04_DEVELOPMENT/SHELTER_MCP__Codex_Brief__Bootstrap_And_Repo_Tools_Polish_v2.md`
- Sibling repo: `/Users/barsulka/GolandProjects/shelter/mcp`
- Summary: Polished the v1 Shelter MCP repo/document tools for daily ChatGPT, Codex and PM work without adding generic shell access or expanding MCP permissions. `read_shelter_bootstrap_context` now uses priority-first ordering so compressed/current-context docs and role docs are considered before long root docs, and it reports per-file diagnostics and byte budget usage. `git_diff_for_review` now supports `focus=all|docs|code|mixed`, returns diff/omitted paths, and includes lightweight review stats with file-category counts plus fixed-args `git diff --numstat` insertions/deletions. Markdown editing gained `replace_between_markers`, and missing-heading errors now return `closest_headings`.
- Tools changed:
  - `read_shelter_bootstrap_context`: priority-first bundle order, `included_bytes`, `remaining_budget`, `per_file_sizes`, `bootstrap_summary`.
  - `git_diff_for_review`: `focus`, `review_stats`, `diff_paths`, `omitted_paths`.
  - `insert_section_after_heading` / `replace_section`: actionable closest-heading suggestions when the requested heading is missing.
- Tool added:
  - `replace_between_markers`
- Safety notes:
  - No generic shell, arbitrary git command, commit/push/reset/checkout, or expanded filesystem permission was added.
  - Existing repo enum, relative-path containment, denied secrets-looking paths, bounded output, and dry-run defaults remain in place.
- Changed files in MCP repo:
  - `README.md`
  - `internal/sheltermcp/repo_tools.go`
  - `internal/sheltermcp/repo_tools_test.go`
  - `internal/sheltermcp/server.go`
  - `internal/sheltermcp/server_test.go`
- Changed files in Shelter repo:
  - `docs/repo/status/CODEX_STATUS.md`
- Checks:
  - Passed: `cd /Users/barsulka/GolandProjects/shelter/mcp && gofmt -w internal/sheltermcp/repo_tools.go internal/sheltermcp/repo_tools_test.go internal/sheltermcp/server.go internal/sheltermcp/server_test.go`
  - Passed: `cd /Users/barsulka/GolandProjects/shelter/mcp && go test ./...`
  - Passed: `cd /Users/barsulka/GolandProjects/shelter/mcp && go build -o .runtime/bin/shelter-mcp ./cmd/shelter-mcp`
  - Passed: `cd /Users/barsulka/GolandProjects/shelter/mcp && git diff --check`
- Known limitations:
  - Focus filters are intentionally simple extension/path heuristics, not semantic classification.
  - `git_diff_for_review` numstat covers tracked diff paths; untracked files remain visible through status metadata rather than embedded diff content.
  - `read_shelter_bootstrap_context` still performs deterministic file bundling only and does not summarize.

## 2026-07-07 - Shelter MCP repo diff, patch and markdown editing tools v1

- Branch: `master`
- Source brief: `docs/drive/Shelter/04_DEVELOPMENT/SHELTER_MCP__Codex_Brief__Repo_Diff_Patch_And_Doc_Editing_Tools_v1.md`
- Sibling repo: `/Users/barsulka/GolandProjects/shelter/mcp`
- Summary: Added safe typed Shelter MCP tools for repo/document review workflows without adding generic shell access. The new tools cover git status, bounded git diff, review diff with simple risk flags, patch dry-run/apply via fixed `git apply` args, markdown section editing by unique heading, deterministic Shelter bootstrap context bundling, and sha256-guarded file writes.
- Tools added:
  - `git_status`
  - `git_diff`
  - `git_diff_for_review`
  - `apply_patch`
  - `insert_section_after_heading`
  - `replace_section`
  - `append_changelog_entry`
  - `read_shelter_bootstrap_context`
  - `write_file_if_unchanged`
- Safety notes:
  - Repo selection is enum-only: `shelter` or `mcp`.
  - Paths must be relative and stay inside the selected git root.
  - Git execution uses fixed `git status`, `git diff`, and `git apply` argument lists, not shell text or arbitrary git options.
  - Risky write tools default to `dry_run=true`.
  - `.git`, `.env`, common key/certificate extensions, and obvious secrets-looking paths are denied for diff/patch/write content.
- Changed files in MCP repo:
  - `.env.example`
  - `README.md`
  - `internal/sheltermcp/config.go`
  - `internal/sheltermcp/server.go`
  - `internal/sheltermcp/server_test.go`
  - `internal/sheltermcp/repo_tools.go`
  - `internal/sheltermcp/repo_tools_test.go`
- Changed files in Shelter repo:
  - `docs/repo/status/CODEX_STATUS.md`
- Checks:
  - Passed: `cd /Users/barsulka/GolandProjects/shelter/mcp && gofmt -w internal/sheltermcp/config.go internal/sheltermcp/server.go internal/sheltermcp/repo_tools.go internal/sheltermcp/server_test.go internal/sheltermcp/repo_tools_test.go`
  - Passed: `cd /Users/barsulka/GolandProjects/shelter/mcp && go test ./...`
  - Passed: `cd /Users/barsulka/GolandProjects/shelter/mcp && go build -o .runtime/bin/shelter-mcp ./cmd/shelter-mcp`
  - Passed: `cd /Users/barsulka/GolandProjects/shelter/mcp && git diff --check`
- Known limitations:
  - `git_diff` does not embed untracked file contents; it reports untracked files through status and diff review metadata.
  - Patch path parsing is intentionally conservative and optimized for normal unified diffs.
  - `read_shelter_bootstrap_context` is deterministic file bundling only; it does not summarize or replace reading task-specific deep docs.

## 2026-07-06 - First Day Art / UX visual language pass v1 implemented

- Branch: `master`
- Source brief: `docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__First_Day_Art_UX_Visual_Language_Pass_v1.md`
- Summary: Implemented the narrow First Day Art / UX Visual Language Pass without changing gameplay, economy, balance, progression, dogs, routes, chains, House of Curiosity scope, monetization, timers, FOMO, D-010, or final art direction. The prototype now carries more meaning through object/state cues instead of cards/labels/badges/arrows: Такса reads more as the bicycle-side first driver, Лабрадор reads more as a calm helper, the packing table and van visibly change state, the postcard lives on a world board, the next-day hint is a small physical note, and Такса's slippers are visible on her paws.
- Output:
  - Pack: `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v3/`
  - Command: `cd steam && tools/dev-vertical-slice.sh first-day-art-ux-capture`
  - Screenshots: `20` required named PNGs under `captures/screenshots/`
  - Full loop normal-speed frame sequence: `86` PNG frames under `captures/video/first_day_mvp_visible_loop_frames_1x/`
  - Postcard/slippers normal-speed frame sequence: `41` PNG frames under `captures/video/postcard_slippers_moment_1x/`
  - State proof: `captures/state/manifest.json`, `final_state.json`, `events.jsonl`, `stress_signals.jsonl`
  - Pack docs: `README.md`, `CAPTURE_MANIFEST_v3.md`
- State proof:
  - `manifest.exit_status=success`
  - `snapshot_count=42`, `events_written=114`, `stress_signal_sample_count=42`
  - `first_day_mvp_proof` confirms dispatch completion, postcard/reward state, chain completion, first-day memory/reward/hint state, delivered Food Bag semantics, legacy chain consistency, clean debug tagging, high-level dog action events, and the v3 object/state evidence events.
  - New v3 review-only proof keys are true: `event.packing_table_food_bag_state_visible`, `event.van_ready_object_state_visible`, `event.postcard_board_state_visible`, `event.next_day_note_object_visible`, `event.slippers_equipped_world_state_visible`.
- Changed files:
  - `steam/scripts/prototypes/vertical_slice/vertical_slice_demo.gd`
  - `steam/tools/dev-vertical-slice.sh`
  - `steam/README.md`
  - `docs/repo/dev/steam-vertical-slice-prototype.md`
  - `docs/repo/dev/godot-state-connector.md`
  - `docs/repo/status/CODEX_STATUS.md`
  - `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v3/README.md`
  - `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v3/CAPTURE_MANIFEST_v3.md`
  - generated PNG/state/log artifacts under `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v3/captures/`
- Checks:
  - Passed: `bash -n steam/tools/dev-vertical-slice.sh`
  - Passed: `bash -n steam/launch.sh`
  - Passed: `cd steam && tools/dev-vertical-slice.sh capture-smoke`
  - Passed: `cd steam && tools/dev-vertical-slice.sh first-day-art-ux-capture`
  - Passed: `cd steam && tools/dev-vertical-slice.sh smoke`
  - Passed: `cd steam && tools/dev-vertical-slice.sh connector-control-smoke`
  - Passed: `cd steam && tools/check-godot.sh`
  - Passed: `python3 -m json.tool` for v3 `captures/state/manifest.json` and `captures/state/final_state.json`
  - Passed: v3 PNG/header/proof validation in `first-day-art-ux-capture` (`20` screenshots, `86` loop frames, `41` postcard/slippers frames)
  - Passed: `sips` dimension check for `20_readability_preview_96.png` (`1282x96`)
  - Passed: `git diff --check`
- Known limitations:
  - This is still prototype visual-language evidence, not production art or final visual acceptance.
  - QA cards/labels remain available for inspection; the new hidden-UI screenshots are the mandatory check surface for world-only readability.
  - `100x` Workbench state proof remains debug/state evidence only and must not be treated as visual warmth/readability/player-feel proof.
  - OpenAPI endpoints were not changed; only review-only event taxonomy and capture docs were updated.
  - Shelter MCP whitelist was not changed because this brief explicitly kept MCP whitelist changes out of scope unless separately requested.

## 2026-07-06 - First Day Art / UX visual language pass brief prepared

- Branch: `master`
- Source request: User asked Codex to prepare the next First Day Art / UX Visual Language Pass after R-23 Game Designer PASS and Art Director / UX handoff.
- Summary: Restored project context from local docs, read the R-23 visible review and temporary Art / UX handoff, and created the next Codex implementation brief. The prepared scope keeps First Day gameplay unchanged and focuses on moving meaning from UI/cards/labels/badges/arrows into object state, dog pose, simple movement and world moments.
- Output:
  - Brief: `docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__First_Day_Art_UX_Visual_Language_Pass_v1.md`
  - Status: prepared, awaiting explicit user confirmation before implementation.
- Prepared implementation direction:
  - Такса as first driver through silhouette, bicycle proximity, route-prep and return behavior.
  - Лабрадор as calm helper through slower grounded movement, idle/work poses and careful carry/packing cues.
  - Payload/resource flow through physical object movement and station states.
  - Van-ready as loaded/prepared object state.
  - Postcard moment as world board + dog attention/pause.
  - `Удобные тапочки` as physically attached to Такса.
  - Next-day hint as a gentle physical note, not a tutorial popup.
  - Mandatory hidden-UI and 96px composition/silhouette checks.
- Proposed capture output after implementation:
  - `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v3/`
  - Proposed command: `cd steam && tools/dev-vertical-slice.sh first-day-art-ux-capture`
  - Must include 1x/low-speed visible frames, postcard/slippers moment frames, hidden UI screenshots, compact previews and matching state proof.
- Checks:
  - Passed: `git diff --check`
- Known limitations:
  - Implementation has not started yet.
  - No code, gameplay, capture command, state contract or API behavior was changed in this preparation step.
  - Shelter MCP whitelist was not changed.

## 2026-07-06 - First Day visible readability capture pack v2

- Branch: `master`
- Source brief: `docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__First_Day_Visible_Readability_Fix_v1.md`
- Summary: Implemented a narrow prototype readability pass for the First Day MVP visible strip without expanding gameplay scope. The strip now has non-final world cues for Такса as first driver, Лабрадор as helper, route readiness, returned payload, van dispatch readiness, postcard board, Такса-owned slippers, and a gentle next-day note. Post-delivery proof now includes review-only marker events for postcard, next-day hint, and first reward world markers.
- Output:
  - Pack: `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v2/`
  - Command: `cd steam && tools/dev-vertical-slice.sh first-day-visible-capture`
  - Screenshots: `20` required named PNGs under `captures/screenshots/`
  - Frame sequence: `28` PNG frames under `captures/video/first_day_mvp_visible_loop_frames/`
  - State proof: `captures/state/manifest.json`, `final_state.json`, `events.jsonl`, `stress_signals.jsonl`
- State proof:
  - `manifest.exit_status=success`
  - `snapshot_count=42`, `events_written=109`
  - Existing `first_day_mvp_proof` still confirms dispatch completion, postcard/reward state, chain completion, D-010 reward/memory state, next-day hint state, delivered Food Bag semantics, clean debug tagging, and final legacy chain consistency.
  - New review-only proof keys are true: `event.postcard_world_marker_shown`, `event.next_day_hint_world_marker_shown`, `event.first_reward_world_marker_shown`.
  - Final `game.first_day.next_day_hint_text`: `Завтра можно придумать, как паковать ещё аккуратнее.`
- Changed files:
  - `steam/scripts/prototypes/vertical_slice/vertical_slice_demo.gd`
  - `steam/tools/dev-vertical-slice.sh`
  - `steam/README.md`
  - `docs/repo/dev/steam-vertical-slice-prototype.md`
  - `docs/repo/dev/godot-state-connector.md`
  - `docs/repo/api/godot-state-connector.openapi.yaml`
  - `docs/repo/status/CODEX_STATUS.md`
  - `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v2/README.md`
  - `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v2/CAPTURE_MANIFEST_v2.md`
  - generated PNG/state/log artifacts under `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v2/captures/`
- Checks:
  - Passed: `bash -n steam/tools/dev-vertical-slice.sh`
  - Passed: `bash -n steam/launch.sh`
  - Passed: `Godot --headless --path steam --check-only --script res://scripts/prototypes/vertical_slice/vertical_slice_demo.gd`
  - Passed: `cd steam && tools/dev-vertical-slice.sh capture-smoke`
  - Passed: `cd steam && tools/dev-vertical-slice.sh first-day-visible-capture`
  - Passed: `cd steam && tools/dev-vertical-slice.sh smoke`
  - Passed: `cd steam && tools/dev-vertical-slice.sh connector-control-smoke`
  - Passed: `cd steam && tools/check-godot.sh`
  - Passed: `python3 -m json.tool` for v2 `captures/state/manifest.json` and `captures/state/final_state.json`
  - Passed: PNG count/header/proof validation (`20` screenshots, `28` frames)
  - Passed: `sips` dimension check for full-size and 96 px preview PNGs
  - Passed: OpenAPI YAML parse and `FirstDayState.next_day_hint_text` example assertion
  - Passed: `git diff --check`
- Known limitations:
  - This is still fast deterministic visible capture, not real-speed player-feel proof.
  - The readability cues are prototype markers only; no final art direction, palette, UI look, production asset pipeline, new dog, route, chain or full House of Curiosity loop was added.
  - Some post-delivery top-card UI can overlap the world; `17_ui_hidden_world_visible.png` is included to review strip-only readability.
  - Human Game Designer / Art Director / UX review is still required; no final visual acceptance is claimed.
  - Shelter MCP whitelist was not changed.

## 2026-07-05 - First Day MVP visible review capture pack v1

- Branch: `master`
- Source brief: `docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__First_Day_MVP_Visible_Review_Capture_Pack_v1.md`
- Summary: Created a persistent visible/player-feel review capture pack for the current First Day MVP after Runtime Polish v1, without changing gameplay contracts. The new `first-day-visible-capture` command runs a visible macOS Godot capture pass for named screenshots and a PNG-frame sequence, then runs a matching Workbench state-proof pass and copies `manifest.json`, `final_state.json`, `events.jsonl`, and `stress_signals.jsonl` into the persistent pack.
- Output:
  - Pack: `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v1/`
  - Command: `cd steam && tools/dev-vertical-slice.sh first-day-visible-capture`
  - Screenshots: `20` required named PNGs under `captures/screenshots/`
  - Frame sequence: `27` PNG frames under `captures/video/first_day_mvp_visible_loop_frames/`
  - State proof: `captures/state/manifest.json`, `final_state.json`, `events.jsonl`, `stress_signals.jsonl`
- State proof:
  - `manifest.exit_status=success`
  - `snapshot_count=42`, `events_written=106`
  - `first_day_mvp_proof` is present and confirms dispatch completion, first-day postcard/memory/reward/hint state, delivered Food Bag semantics, clean debug tagging, and final legacy chain consistency.
- Changed files:
  - `steam/tools/dev-vertical-slice.sh`
  - `steam/scripts/prototypes/vertical_slice/vertical_slice_demo.gd`
  - `steam/README.md`
  - `docs/repo/dev/steam-vertical-slice-prototype.md`
  - `docs/repo/status/CODEX_STATUS.md`
  - `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v1/README.md`
  - `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v1/CAPTURE_MANIFEST_v1.md`
  - generated PNG/state/log artifacts under `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v1/captures/`
- Checks:
  - Passed: `bash -n steam/tools/dev-vertical-slice.sh`
  - Passed: `bash -n steam/launch.sh`
  - Passed: `cd steam && tools/dev-vertical-slice.sh capture-smoke`
  - Passed: `cd steam && tools/dev-vertical-slice.sh first-day-visible-capture`
  - Passed: `cd steam && tools/dev-vertical-slice.sh smoke`
  - Passed: `cd steam && tools/dev-vertical-slice.sh connector-control-smoke`
  - Passed: `cd steam && tools/check-godot.sh`
  - Passed: `python3 -m json.tool` for `captures/state/manifest.json` and `captures/state/final_state.json`
  - Passed: PNG listing/count validation (`20` screenshots, `27` frames)
  - Passed: `sips` dimension check for full-size and 96 px preview PNGs
  - Passed: `git diff --check`
- Known limitations:
  - This is fast deterministic visible capture and matching state proof, not real-speed player-feel proof.
  - Human Game Designer / Art Director / UX review is still required; no final visual acceptance is claimed.
  - Placeholder art remains prototype semantics; no new art direction or production art decision was made.
  - Shelter MCP whitelist was not updated in this Steam-only task. Follow-up is needed if `first-day-visible-capture` should be callable through MCP `run_shelter_dev_command`.

## 2026-07-05 - First Day MVP runtime polish v1

- Branch: `master`
- Source brief: `docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__First_Day_MVP_Runtime_Polish_v1.md`
- Summary: Polished First Day MVP runtime evidence without expanding design scope. Debug tick events now remain tagged as `debug`, high-level dog-action events are emitted through the warm-food chain, the post-delivery postcard/memory/next-day-hint moment is exposed under `game.first_day`, and the delivered Food Bag leaves the van inventory with `location=delivered_to_shelter`, `visible=false`, `semantic_state=delivered`.
- Legacy compatibility: Final legacy `production_chain` stages now stay `complete` after resources are transformed or delivered, matching authoritative `production_chains[chain.warm_food_delivery_intro]`.
- Workbench proof:
  - Output: `steam/.runtime/workbench_capture_runs/_smoke_first_day_mvp_runtime_polish/`
  - `snapshot_count=42`, `events_written=106`
  - `first_day_mvp_proof` confirms dispatch completion, postcard/reward state, `dog_noticed_postcard`, `dog_received_reward`, `first_day_memory_added`, `next_day_hint_available`, `dog_equipped_first_reward`, high-level dog-action count, delivered Food Bag semantics, clean debug tagging, and final legacy chain consistency.
  - Final signals: `dog_action_events_recent=28`, `story_events_recent=6`, `production_events_recent=13`, `chains_with_invisible_conversion=0`.
- Changed files:
  - `steam/scripts/prototypes/vertical_slice/vertical_slice_demo.gd`
  - `steam/scripts/game_systems/game_systems_runtime.gd`
  - `steam/tools/dev-vertical-slice.sh`
  - `steam/README.md`
  - `docs/repo/api/godot-state-connector.openapi.yaml`
  - `docs/repo/dev/godot-state-connector.md`
  - `docs/repo/status/CODEX_STATUS.md`
- Checks:
  - Passed: `bash -n steam/tools/dev-vertical-slice.sh`
  - Passed: `bash -n steam/launch.sh`
  - Passed: `cd steam && tools/dev-vertical-slice.sh workbench-capture --help`
  - Passed: `cd steam && tools/dev-vertical-slice.sh workbench-capture --scenario=first_delivery_with_dispatch_confirmation --fixture=first_day_empty_coop --game-seconds=420 --sample-every-game-seconds=10 --speed=100 --output-dir=.runtime/workbench_capture_runs/_smoke_first_day_mvp_runtime_polish`
  - Passed: JSON parse and proof assertions for `_smoke_first_day_mvp_runtime_polish/manifest.json`, `final_state.json`, `snapshots.jsonl`, `events.jsonl`, and `stress_signals.jsonl`
  - Passed: regression captures for `first_delivery_from_empty`, `warm_food_delivery_mid_chain`, and `house_of_curiosity_learning_session`
  - Passed: `cd steam && tools/dev-vertical-slice.sh runtime-foundation-smoke`
  - Passed: `cd steam && tools/dev-vertical-slice.sh connector-control-smoke`
  - Passed: `cd steam && tools/dev-vertical-slice.sh smoke`
  - Passed: `cd steam && tools/check-godot.sh`
  - Passed: OpenAPI YAML parse and `FirstDayState` schema assertion
  - Passed: `git diff --check`
- Known limitations:
  - Generated capture bundles remain ignored under `steam/.runtime/` and must not be committed.
  - Accelerated `100x` JSON capture validates state transitions and causality only; visual warmth/readability/player feel still require visual review.
  - No new dogs, production chains, House of Curiosity loop, mood/energy penalties, monetization, gacha, reroll, broad dev controls or visual-direction decisions were added.

## 2026-07-05 - Shelter MCP dispatch whitelist and output schemas v0

- Branch: `master`
- Source brief: `docs/drive/Shelter/04_DEVELOPMENT/SHELTER_MCP__Codex_Brief__Workbench_Dispatch_Whitelist_And_Output_Schemas_v0.md`
- Sibling repo: `/Users/barsulka/GolandProjects/shelter/mcp`
- Summary: Updated Shelter MCP so the already implemented Steam/Desktop dispatch-confirmation runtime path is available through the local MCP bridge. `workbench_capture` now accepts `first_delivery_with_dispatch_confirmation`, and `control_shelter_game` exposes the narrow `runtime_delivery_confirm` action for `POST /control/runtime/delivery/confirm`.
- Output schemas: Confirmed `github.com/modelcontextprotocol/go-sdk v1.6.1` supports `Tool.OutputSchema`. First-party Shelter MCP handlers now return concrete output structs instead of `any`, allowing `mcp.AddTool` to publish explicit output schemas for `list_shelter_dev_commands`, `run_shelter_dev_command`, `list_workbench_runs`, `get_workbench_run_artifacts`, `clear_workbench_runs`, `start_shelter_control_connector`, `stop_shelter_control_connector`, `control_shelter_game`, and `list_shelter_upstreams`.
- Runtime capture proof:
  - Output: `steam/.runtime/workbench_capture_runs/first_delivery_with_dispatch_confirmation_v0_mcp/`
  - Manifest `dispatch_confirmation_proof` confirms `order.delivery_confirmed=true`, `order.postcard_visible=true`, `order.reward_available=true`, `game.chain_complete=true`, `production_chain.state=completed`, `production_chain.completed=true`, `event.player_confirmed_delivery=true`, `event.postcard_created=true`, and `event.reward_created=true`.
- Changed files in MCP repo:
  - `README.md`
  - `internal/sheltermcp/commands.go`
  - `internal/sheltermcp/control.go`
  - `internal/sheltermcp/process.go`
  - `internal/sheltermcp/server_test.go`
  - `internal/sheltermcp/upstreams.go`
  - `internal/sheltermcp/workbench.go`
- Changed files in Shelter repo:
  - `docs/repo/status/CODEX_STATUS.md`
- Checks:
  - Passed: `cd /Users/barsulka/GolandProjects/shelter/mcp && go test ./...`
  - Passed: `cd /Users/barsulka/GolandProjects/shelter/mcp && go test ./... -run Test`
  - Passed: `cd /Users/barsulka/GolandProjects/shelter/mcp && SHELTER_MCP_REAL_WORKBENCH_CAPTURE=1 SHELTER_STEAM_ROOT=/Users/barsulka/GolandProjects/shelter/shelter/steam go test ./internal/sheltermcp -run TestRealWorkbenchCaptureDispatchScenarioThroughMCP -count=1 -v`
  - Passed: `cd /Users/barsulka/GolandProjects/shelter/mcp && go build -o .runtime/bin/shelter-mcp ./cmd/shelter-mcp`
  - Passed: manifest proof assertions for `dispatch_confirmation_proof`.
- Known limitations:
  - Generated capture bundles remain ignored under `steam/.runtime/` and must not be committed.
  - The capture validates state transitions and causality only; visual warmth/readability/player feel still require visual review.

## 2026-07-03 - Dispatch confirmation Workbench capture path v0

- Branch: `master`
- Source brief: `docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Dispatch_Confirmation_Capture_Path_v0.md`
- Summary: Added an accepted dev-only Workbench capture path for the full first Warm Food Delivery through player dispatch confirmation. `workbench-capture` now supports `first_delivery_with_dispatch_confirmation`, records a `ready_to_dispatch` / `waiting_for_player_confirmation` snapshot before confirming, calls the narrow token-protected `runtime.delivery.confirm` control action, then continues sampling until postcard, reward and chain completion are observable.
- New endpoint/action:
  - `POST /control/runtime/delivery/confirm`
  - Command id: `runtime.delivery.confirm`
  - Scope: only `order.first_warm_delivery` when `delivery_state=ready_to_send`, `van_loaded=true`, production chain state is `ready_to_dispatch`, current step is `player_confirms_dispatch`, and `blocked_reason=waiting_for_player_confirmation`.
  - Invalid state returns `ok:false` with validation details; no generic command execution, arbitrary order/task/resource mutation or broad cheat control was added.
- Smoke output:
  - `steam/.runtime/workbench_capture_runs/_smoke_first_delivery_dispatch/`
  - Generated files: `manifest.json`, `snapshots.jsonl`, `events.jsonl`, `stress_signals.jsonl`, `final_state.json`, `run.log`
- Dispatch smoke proof:
  - `snapshot_count=42`
  - ready snapshot before confirm: sample `20`, game time `200.0`, blocked reason `waiting_for_player_confirmation`
  - `order.delivery_confirmed=true`
  - `order.postcard_visible=true`
  - `order.reward_available=true`
  - `game.chain_complete=true`
  - `production_chain.state=completed`
  - event log contains `player_confirmed_delivery`, `postcard_created`, `reward_created`, and `reward_equipped`
- Changed files:
  - `steam/tools/dev-vertical-slice.sh`
  - `steam/scripts/dev_tools/godot_state_connector.gd`
  - `steam/scripts/prototypes/vertical_slice/vertical_slice_demo.gd`
  - `steam/README.md`
  - `docs/repo/api/godot-state-connector.openapi.yaml`
  - `docs/repo/dev/godot-state-connector.md`
  - `docs/repo/status/CODEX_STATUS.md`
- Checks:
  - Passed: `bash -n steam/tools/dev-vertical-slice.sh`
  - Passed: `bash -n steam/launch.sh`
  - Passed: `cd steam && tools/dev-vertical-slice.sh workbench-capture --help`
  - Passed: `cd steam && tools/dev-vertical-slice.sh workbench-capture --scenario=first_delivery_with_dispatch_confirmation --fixture=first_day_empty_coop --game-seconds=420 --sample-every-game-seconds=10 --speed=100 --output-dir=.runtime/workbench_capture_runs/_smoke_first_delivery_dispatch`
  - Passed: JSON parse for `_smoke_first_delivery_dispatch/manifest.json` and `_smoke_first_delivery_dispatch/final_state.json`
  - Passed: JSONL parse/proof assertions for `_smoke_first_delivery_dispatch`
  - Passed: `cd steam && tools/dev-vertical-slice.sh workbench-capture --scenario=first_delivery_from_empty --game-seconds=30 --sample-every-game-seconds=10 --speed=100 --output-dir=.runtime/workbench_capture_runs/_smoke_first_delivery_regression`
  - Passed: small regression captures for `warm_food_delivery_mid_chain` and `house_of_curiosity_learning_session`
  - Passed: `cd steam && tools/dev-vertical-slice.sh runtime-foundation-smoke`
  - Passed: `cd steam && tools/dev-vertical-slice.sh smoke`
  - Passed: `cd steam && tools/dev-vertical-slice.sh connector-control-smoke`
  - Passed: OpenAPI YAML parse and `/control/runtime/delivery/confirm` path assertion
  - Passed: `Godot --headless --path steam --check-only --script res://scripts/prototypes/vertical_slice/vertical_slice_demo.gd`
  - Passed: `Godot --headless --path steam --check-only --script res://scripts/dev_tools/godot_state_connector.gd`
  - Passed: `cd steam && tools/check-godot.sh`
  - Passed: `git diff --check`
- Known limitations:
  - Generated capture bundles remain ignored under `steam/.runtime/` and must not be committed.
  - Accelerated 100x JSON capture validates state transitions and causality only; visual warmth, readability, animation feel and desktop calmness still require real-speed/visual review.
  - The dispatch action intentionally enables only a narrow dev follow-up for the accepted capture path after valid dispatch confirmation; normal player UI flow remains unchanged.

## 2026-07-02 - Shelter MCP documentation bridge update

- Branch: `master`
- Summary: Documented the sibling Shelter MCP repo as the preferred local dev / ChatGPT inspection bridge for Steam/Desktop workflows. The docs now explain that Shelter MCP replaces the old split workflow of a separate filesystem MCP tunnel plus separate game launch/control commands with one local MCP endpoint, while direct `steam/launch.sh`, Barsulka/Cloudflare and `tools/dev-vertical-slice.sh` remain low-level fallback/debug workflows.
- Shelter MCP repo:
  - Local path: `/Users/barsulka/GolandProjects/shelter/mcp`
  - GitHub: `git@github.com:barsulka/shelter-mcp.git`
- Documented setup:
  - clone/open MCP repo;
  - copy `.env.example` to `.env`;
  - fill `.env`;
  - run `./run.sh`.
- Documented `run.sh` behavior:
  - creates/updates `tunnel-client` profile from `.env`;
  - does not reuse stale profile values;
  - builds Go MCP binary;
  - checks or installs `@modelcontextprotocol/server-filesystem`;
  - runs `doctor --explain`;
  - starts the tunnel.
- Documented prerequisites:
  - Go;
  - node/npm;
  - `tunnel-client`;
  - local Shelter checkout;
  - OpenAI tunnel/runtime API key.
- Changed files:
  - `PROJECTS_RULES.md`
  - `AGENTS.md`
  - `README.md`
  - `steam/README.md`
  - `docs/repo/dev/godot-state-connector.md`
  - `docs/drive/Shelter/00_START_HERE/01_CURRENT_STATUS.md`
  - `docs/repo/status/CODEX_STATUS.md`
- Checks:
  - Passed: read local MCP docs from `/Users/barsulka/GolandProjects/shelter/mcp/README.md`, `.env.example`, and `run.sh`.
  - Passed: `rg` verification for Shelter MCP mentions across project rules, root README, Steam README, Godot connector docs, current status and Codex status.
  - Passed: `git diff --check`.

## 2026-07-01 - Workbench Runtime Capture Harness v0

- Branch: `master`
- Source brief: `docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Workbench_Runtime_Capture_Harness_v0.md`
- Summary: Added a dev-only file-based Workbench runtime capture harness for Steam Vertical Slice. `tools/dev-vertical-slice.sh workbench-capture` now starts or reuses a local control-enabled Godot runtime, loads an accepted fixture, applies scenario setup, advances bounded debug time, samples live `/state`, and writes review bundles under ignored `steam/.runtime/workbench_capture_runs/<run_id>/`.
- Capture output files:
  - `manifest.json`
  - `snapshots.jsonl`
  - `events.jsonl`
  - `stress_signals.jsonl`
  - `final_state.json`
  - `run.log`
- Scenario ids supported:
  - `first_delivery_from_empty`
  - `warm_food_delivery_mid_chain`
  - `house_of_curiosity_learning_session`
- 100x update:
  - Added runtime speed preset `100` to `SPEED_PRESETS`.
  - Documented `100x` as dev-only capture/testing acceleration in the brief, OpenAPI, connector docs, and Steam README.
  - `100x` is not player-facing and must not be used as visual/readability/player-feel acceptance.
- Changed files:
  - `steam/tools/dev-vertical-slice.sh`
  - `steam/scripts/game_systems/game_systems_runtime.gd`
  - `steam/README.md`
  - `docs/repo/api/godot-state-connector.openapi.yaml`
  - `docs/repo/dev/godot-state-connector.md`
  - `docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Workbench_Runtime_Capture_Harness_v0.md`
  - `docs/repo/status/CODEX_STATUS.md`
- Checks:
  - Passed: `bash -n steam/tools/dev-vertical-slice.sh`
  - Passed: `bash -n steam/launch.sh`
  - Passed: `cd steam && tools/dev-vertical-slice.sh workbench-capture --help`
  - Passed: `cd steam && tools/dev-vertical-slice.sh workbench-capture --scenario=first_delivery_from_empty --game-seconds=30 --sample-every-game-seconds=10 --speed=100 --output-dir=.runtime/workbench_capture_runs/_smoke_first_delivery`
  - Passed: JSON parse for `_smoke_first_delivery/manifest.json` and `_smoke_first_delivery/final_state.json`
  - Passed: JSONL parse/count assertions for `_smoke_first_delivery` (`3` snapshots, `14` event records, `3` stress signal records)
  - Passed: small `workbench-capture` scenario checks for `warm_food_delivery_mid_chain` and `house_of_curiosity_learning_session`
  - Passed: `cd steam && tools/dev-vertical-slice.sh runtime-foundation-smoke`
  - Passed: `cd steam && tools/dev-vertical-slice.sh smoke`
  - Passed: OpenAPI YAML parse and `RuntimeSpeedRequest` enum assertion including `100`
  - Passed: `Godot --headless --path steam --check-only --script res://scripts/game_systems/game_systems_runtime.gd`
  - Passed: `Godot --headless --path steam --check-only --script res://scripts/prototypes/vertical_slice/vertical_slice_demo.gd`
  - Passed: `cd steam && tools/check-godot.sh`
- Known limitations:
  - Generated capture bundles are intentionally ignored under `.runtime` and must not be committed.
  - Accelerated JSON capture validates state transitions and causality only; visual warmth, readability, animation feel and desktop calmness still require real-speed/visual review.
  - Connector-backed capture commands should not be run in parallel on the same port unless each run gets a separate `--port`.

## 2026-07-01 - Review fixes: import validation, export presets, accumulator, whitespace

- Branch: `master`
- Summary: Fixed 4 issues from code review and follow-up review:
  1. `import_runtime_metadata()` result now checked in `_apply_runtime_import_payload()` — malformed runtime JSON returns error instead of silent success.
  2. Removed `steam/export_presets.cfg` from `.gitignore` — export presets now tracked in git (credentials rule kept).
  3. `_process()` accumulator now uses bounded `while` loop (max 4 ticks/frame) and drops only excess backlog beyond one tick interval when the budget is exhausted.
  4. Removed trailing blank line in `project.godot`, updated macOS export preset keys to the current Godot format, and excluded `build/**` / `builds/**` from packaged resources.
- Changed files:
  - `steam/scripts/prototypes/vertical_slice/vertical_slice_demo.gd`
  - `steam/project.godot`
  - `steam/export_presets.cfg`
  - `.gitignore`
  - `review.md`
- Checks:
  - Passed: `Godot --headless --path steam --check-only --script res://scripts/prototypes/vertical_slice/vertical_slice_demo.gd`
  - Passed: `cd steam && tools/dev-vertical-slice.sh smoke`
  - Passed: `cd steam && tools/dev-vertical-slice.sh runtime-foundation-smoke`
  - Passed: `cd steam && tools/dev-vertical-slice.sh connector-control-smoke`
  - Passed: live localhost malformed import rejected with `runtime_must_be_object`
  - Passed: `cd steam && tools/check-godot.sh`
  - Passed: `cd steam && Godot --headless --path . --export-release "Windows Desktop" build/review-windows/Shelter.exe` created `.exe` + `.pck`
  - Passed: `cd steam && Godot --headless --path . --export-release "macOS" build/review-macos/Shelter.app` created universal ad-hoc signed `.app` with `CFBundleIdentifier=site.shelter.game`
  - Passed: export logs did not include `res://build/` packaged resources after adding export excludes
  - Passed: `git diff --check`

## 2026-07-01 - Reliability, Performance & Modernization Refactor v1

- Branch: `master`
- Summary: Implemented 7 subtasks from `STEAM_DESKTOP__Codex_Brief__Reliability_Optimization_Refactor_v1.md`:
  1. **Draw-call optimization**: `_on_tick()` no longer calls `_update_ui()`, `_apply_mouse_passthrough()`, and `queue_redraw()` unconditionally. These are only called when there's active work (task in progress, auto-play, capture). `_apply_mouse_passthrough()` moved from tick to `_update_ui()`.
  2. **Texture loading**: Replaced manual `FileAccess.get_file_as_bytes()` + `Image.load_png_from_buffer()` with `load()` (ResourceLoader). Removed `_load_png_texture()` method.
  3. **Video capture memory**: `_control_capture_files` now stores `disk_path` metadata instead of `PackedByteArray`. PNG files are written to disk and read on-demand during HTTP serving. Cleanup deletes files from disk.
  4. **Import validation**: `normalize_import_payload()` validates `state` is Dictionary. `import_runtime_metadata()` validates `runtime` is Dictionary and returns `Dictionary` result. Added `_events_cache` to avoid ~14 redundant `event_snapshots(500)` calls per `build_state()`.
  5. **Export profiles**: Created `steam/export_presets.cfg` with Windows Desktop (x86_64) and macOS (universal) profiles. Added VSync, renderer, and ETC2/ASTC settings to `project.godot`.
  6. **Timer → _process()**: Replaced `Timer` nodes in `_start_timers()` with `_process()` accumulators (`_tick_accumulator`, `_perf_accumulator`).
  7. **Game world module**: Created `steam/scripts/prototypes/vertical_slice/game_world_ref.gd` (ShelterGameWorldRef) — RefCounted class with core game logic (dogs, tokens, tasks, inventories, routes). Full integration into main file deferred to separate task.
- Changed files:
  - `steam/scripts/prototypes/vertical_slice/vertical_slice_demo.gd`
  - `steam/scripts/game_systems/game_systems_runtime.gd`
  - `steam/project.godot`
  - `steam/scripts/prototypes/vertical_slice/game_world_ref.gd` (new)
  - `docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Reliability_Optimization_Refactor_v1.md` (new)
- Checks:
  - Passed: `Godot --headless --path steam --check-only --script res://scripts/prototypes/vertical_slice/vertical_slice_demo.gd`
  - Passed: `Godot --headless --path steam --check-only --script res://scripts/game_systems/game_systems_runtime.gd`
  - Passed: `Godot --headless --path steam --check-only --script res://scripts/prototypes/vertical_slice/game_world_ref.gd`
  - Passed: `cd steam && tools/dev-vertical-slice.sh smoke`
  - Passed: `cd steam && tools/dev-vertical-slice.sh connector-control-smoke`
  - Passed: `cd steam && tools/dev-vertical-slice.sh runtime-foundation-smoke`
  - Passed: `cd steam && tools/check-godot.sh`
  - Passed: `bash -n steam/launch.sh`
  - Passed: `bash -n steam/tools/dev-vertical-slice.sh`
- Known limitations:
  - `game_world_ref.gd` is a standalone module; full integration into `vertical_slice_demo.gd` requires replacing ~200+ direct state accesses.
  - `export_presets.cfg` was made trackable in the follow-up review fixes above; export credentials stay ignored.
  - Windows export now succeeds from macOS; runtime behavior on a real Windows machine remains untested.
- Next recommended step:
  - Integrate `game_world_ref.gd` into `vertical_slice_demo.gd` with careful testing of each code path.

## 2026-07-01 - Steam launcher `--exit` and Bash 3.2 empty-array fix

- Branch: `master`
- Summary: Fixed `./launch.sh` failing on macOS Bash 3.2 with `passthrough_args[@]: unbound variable` when launched without extra runtime arguments. Added `./launch.sh --exit` as a soft full shutdown command that stops launcher-started Cloudflare/Barsulka tunnels, asks the local connector to stop when possible, then stops the Godot game process. Added `./launch.sh --shutdown` as an alias for `--exit`. Changed `./launch.sh --barsulka --start` and `./launch.sh --cloudflared --start` into one-terminal public inspection commands: each now starts the local game first when no local connector is running, then starts/reuses its tunnel and prints the public URL. Kept `./launch.sh --barsulka --stop` semantics unchanged: it stops Barsulka plus local HTTP connector while leaving Godot alive.
- Changed files:
  - `steam/launch.sh`
  - `steam/tools/dev-vertical-slice.sh`
  - `steam/README.md`
  - `docs/repo/dev/godot-state-connector.md`
  - `docs/repo/status/CODEX_STATUS.md`
- Cause:
  - macOS `/bin/bash` 3.2 treats expansion of an empty declared array under `set -u` as an unbound variable in command arguments. `launch.sh` passed an empty `passthrough_args` array into `tools/dev-vertical-slice.sh connector-control`.
- Checks:
  - Passed: `bash -n steam/launch.sh`
  - Passed: `bash -n steam/tools/dev-vertical-slice.sh`
  - Passed: `STATE_CONNECTOR_PORT=18990 ./launch.sh --exit` with no running connector.
  - Passed: real localhost start/url/exit check on `STATE_CONNECTOR_PORT=18991`.
  - Passed: real localhost fixture passthrough check on `STATE_CONNECTOR_PORT=18992` with `./launch.sh -- --runtime-load-fixture=house_of_curiosity_learning_session`, then `./launch.sh --exit`.
  - Passed: `./launch.sh --barsulka --start -- --runtime-load-fixture=warm_food_delivery_mid_chain` autostart check on `STATE_CONNECTOR_PORT=18993` with `BARSULKA_TUNNEL_URL` pointed at the local connector for a no-SSH test; verified `/state`, fixture passthrough and `./launch.sh --exit`.
  - Passed: `./launch.sh --cloudflared --start -- --runtime-load-fixture=first_day_empty_coop` autostart check on `STATE_CONNECTOR_PORT=18994` with a fake `cloudflared` binary and `TUNNEL_SKIP_PUBLIC_CHECK=1`; verified `/state`, fixture passthrough, printed Cloudflare URL and `./launch.sh --exit`.
  - Passed: `STATE_CONNECTOR_PORT=18996 ./launch.sh --shutdown` with no running connector.
  - Passed: real localhost start/shutdown alias check on `STATE_CONNECTOR_PORT=18997`.
- Known limitations:
  - `--exit` can gracefully stop the local HTTP connector only when the launch token is available from the saved token file or `STATE_CONNECTOR_TOKEN`. If the token is unavailable, it still attempts to stop matching launcher Godot processes by pid file or exact command/port match.

## 2026-06-30 - Steam Game Systems Runtime Foundation v1

- Branch: `master`
- Summary: Refactored the Steam Vertical Slice prototype around a first `GameSystemsRuntime` scaffold while keeping Godot as the single source of truth. Expanded `/state` to expose structured game systems runtime groups for dogs, routes, production chains, buildings, rooms, House of Curiosity, economy, events and debug, while preserving legacy Vertical Slice compatibility groups. Added token-protected dev-only runtime controls for accepted design testing: speed multiplier, fixture list/load, JSON export/import/clear, local prototype save write/load/erase, accepted route start, dog room/activity assignment, House of Curiosity research start and bounded debug tick. Added three JSON fixtures and documented the v0.2 connector contract.
- Source brief:
  - `docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Game_Systems_Runtime_Foundation_v1.md`
- Working checklist:
  - `docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Checklist__Game_Systems_Runtime_Foundation_v1.md`
- Changed files:
  - `steam/scripts/game_systems/game_systems_runtime.gd`
  - `steam/scripts/game_systems/game_systems_runtime.gd.uid`
  - `steam/scripts/prototypes/vertical_slice/vertical_slice_demo.gd`
  - `steam/scripts/dev_tools/godot_state_connector.gd`
  - `steam/resources/game_systems/fixtures/first_day_empty_coop.json`
  - `steam/resources/game_systems/fixtures/warm_food_delivery_mid_chain.json`
  - `steam/resources/game_systems/fixtures/house_of_curiosity_learning_session.json`
  - `steam/tools/dev-vertical-slice.sh`
  - `steam/launch.sh`
  - `steam/README.md`
  - `docs/repo/api/godot-state-connector.openapi.yaml`
  - `docs/repo/dev/godot-state-connector.md`
  - `docs/repo/dev/steam-vertical-slice-prototype.md`
  - `docs/repo/status/CODEX_STATUS.md`
  - `docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Checklist__Game_Systems_Runtime_Foundation_v1.md`
- `/state` v0.2 top-level runtime groups:
  - `game`
  - `dogs`
  - `routes`
  - `production_chains`
  - `buildings`
  - `rooms`
  - `house_of_curiosity`
  - `economy`
  - `events`
  - `debug`
- Legacy compatibility groups kept:
  - `order`
  - `tasks`
  - `resources`
  - `production_chain`
- HTTP runtime endpoints added:
  - `GET /control/runtime/fixtures`
  - `POST /control/runtime/fixture/load`
  - `POST /control/runtime/speed`
  - `POST /control/runtime/state/export`
  - `POST /control/runtime/state/import`
  - `POST /control/runtime/state/clear`
  - `POST /control/runtime/save/write`
  - `POST /control/runtime/save/load`
  - `POST /control/runtime/save/erase`
  - `POST /control/runtime/route/start`
  - `POST /control/runtime/dog/assign`
  - `POST /control/runtime/research/start`
  - `POST /control/runtime/debug/tick`
- Launch/dev workflow:
  - `cd steam && tools/dev-vertical-slice.sh runtime-foundation-smoke`
  - `cd steam && STATE_CONNECTOR_TOKEN="$(uuidgen)" tools/dev-vertical-slice.sh connector-control --runtime-load-fixture=warm_food_delivery_mid_chain`
  - `cd steam && STATE_CONNECTOR_TOKEN="$(uuidgen)" tools/dev-vertical-slice.sh connector-control --runtime-load-save`
  - `cd steam && ./launch.sh -- --runtime-load-fixture=house_of_curiosity_learning_session`
  - `cd steam && ./launch.sh -- --runtime-load-save`
- Local prototype save:
  - `steam/.runtime/game_systems_runtime/local_save.json`
- Checks:
  - Passed: `bash -n steam/launch.sh`
  - Passed: `bash -n steam/tools/dev-vertical-slice.sh`
  - Passed: JSON parse for all three runtime fixtures.
  - Passed: OpenAPI YAML parse and v0.2 runtime path/schema assertions.
  - Passed: `Godot --headless --path steam --check-only --script res://scripts/game_systems/game_systems_runtime.gd`
  - Passed: `Godot --headless --path steam --check-only --script res://scripts/dev_tools/godot_state_connector.gd`
  - Passed: `Godot --headless --path steam --check-only --script res://scripts/prototypes/vertical_slice/vertical_slice_demo.gd`
  - Passed: `cd steam && tools/dev-vertical-slice.sh smoke`
  - Passed: `cd steam && tools/dev-vertical-slice.sh connector-smoke`
  - Passed: `cd steam && tools/dev-vertical-slice.sh connector-control-smoke`
  - Passed: `cd steam && tools/dev-vertical-slice.sh runtime-foundation-smoke`
  - Passed: localhost helper/launcher fixture-save acceptance: load fixture through `tools/dev-vertical-slice.sh connector-control --runtime-load-fixture=warm_food_delivery_mid_chain`, call `runtime.save.write`, start `./launch.sh -- --runtime-load-save`, verify `/state.debug.active_save_file` and `active_fixture_id`, then call `runtime.save.erase`.
  - Passed: `cd steam && tools/check-godot.sh`
  - Passed: `git diff --check`
- Security/contract notes:
  - `/control*` endpoints remain token-protected and return masked `404 not_found` without a valid token.
  - Runtime controls are explicit accepted dev actions; no generic command execution, shell command, arbitrary filesystem command or production save tooling was added.
  - Godot remains the source of truth; JSON exports, fixtures, local saves and connector responses are views/imports of the running Godot prototype state.
- Known limitations:
  - Runtime foundation is a scaffold for Game Designer inspection, not final game architecture, final balance, final save format or production data schema.
  - Runtime actions are dev-only local prototype controls and should not be treated as player-facing cheats.
  - Windows behavior remains untested.

## 2026-06-30 - Godot Control Page Toggle + Viewport Capture v0

- Branch: `master`
- Summary: Updated the dev-only Godot control page so the visible UI exposes only `Toggle`; `ui.hide` and `ui.show` remain token-protected API methods. Added token-protected viewport capture commands: one PNG screenshot and a bounded 10 second PNG-frame sequence at 2 FPS (20 target frames). Godot remains the source of truth; capture reads the live viewport, keeps PNG bytes in connector memory, and uses deleted temporary PNG files only as an encoding bridge.
- Changed files:
  - `steam/scripts/dev_tools/godot_state_connector.gd`
  - `steam/scripts/prototypes/vertical_slice/vertical_slice_demo.gd`
  - `steam/tools/dev-vertical-slice.sh`
  - `steam/README.md`
  - `docs/repo/api/godot-state-connector.openapi.yaml`
  - `docs/repo/dev/godot-state-connector.md`
  - `docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Godot_Control_Connector_v0.md`
  - `docs/repo/status/CODEX_STATUS.md`
- HTTP endpoints added:
  - `POST /control/capture/screenshot?token=...`
  - `POST /control/capture/video/start?token=...`
  - `GET /control/capture/video/status?token=...`
  - `GET /control/capture/files/<file_id>?token=...`
- Behavior:
  - `/control` HTML shows `Toggle`, `Screenshot`, `Record 10s`, and `Refresh`; it no longer shows Hide Game / Show Game buttons.
  - `capture.screenshot` captures one viewport PNG, stores the bytes in memory, returns a tokenized file URL, and shows the image inline on the page.
  - `capture.video.start` starts a fixed 10 second, 2 FPS PNG sequence; it does not block the HTTP response and clears the previous frame sequence from memory before starting.
  - `capture.video.status` returns progress and frame URLs; after completion the page shows an inline animated preview plus a frame strip.
  - Godot Movie Maker / `--write-movie` is not enabled by default because it records from project start until project exit and is not suitable for normal long-running launcher sessions.
- Checks:
  - Passed: `Godot --headless --path steam --check-only --script res://scripts/dev_tools/godot_state_connector.gd`
  - Passed: `Godot --headless --path steam --check-only --script res://scripts/prototypes/vertical_slice/vertical_slice_demo.gd`
  - Passed: `bash -n steam/launch.sh steam/tools/dev-vertical-slice.sh steam/tools/dev-start-cloudflared.sh`
  - Passed: OpenAPI YAML parse and capture path assertions.
  - Passed: `cd steam && tools/dev-vertical-slice.sh connector-control-smoke`
  - Passed: visible local browser page showed only `Toggle` and `Refresh`, with no Hide / Show buttons.
  - Passed: visible local `capture.screenshot` produced a 2992 x 224 PNG and the file endpoint downloaded valid PNG bytes.
  - Passed: visible local `capture.video.start` completed with 20 PNG frames at 2 FPS; first and last frame file endpoints downloaded valid PNG bytes.
  - Passed: Barsulka `/control/capabilities` exposes capture commands, and Barsulka `/control/capture/video/status` returned the completed 20-frame status.
  - Passed: `POST /control/capture/screenshot` without token returned masked `404`.
- Observations:
  - The current capture API is intentionally a lightweight inspection tool, not production recording.
  - Runtime capture PNGs are not retained as files; the temporary PNG path under `.runtime` is deleted after bytes are loaded into memory.
- Blockers:
  - Windows viewport capture behavior remains untested.

## 2026-06-30 - Godot Control Connector v0 + Barsulka launch cleanup

- Branch: `master`
- Summary: Implemented the accepted Godot Control Connector v0 as an explicit dev-only extension of the existing Godot State Connector, then simplified human launch around `steam/launch.sh`. `./launch.sh` now starts the playable Vertical Slice with a local connector/control server by default. `./launch.sh --url`, `./launch.sh --barsulka`, and `./launch.sh --cloudflared` are lookup-only commands that start no process. `./launch.sh --barsulka --start` starts only an SSH reverse tunnel to `barsulka.eboshim.site` for an already running local game. `./launch.sh --barsulka --stop` stops the Barsulka tunnel and local HTTP connector while keeping the Godot game process alive. Cloudflared remains available as a backup via `./launch.sh --cloudflared --start`. The first whitelisted commands hide, show, or toggle the visible Godot game window while the Godot process and HTTP connector keep running.
- Changed files:
  - `steam/scripts/dev_tools/godot_state_connector.gd`
  - `steam/scripts/prototypes/vertical_slice/vertical_slice_demo.gd`
  - `steam/launch.sh`
  - `docs/repo/api/godot-state-connector.openapi.yaml`
  - renamed `steam/tools/run-vertical-slice-demo.sh` -> `steam/tools/dev-vertical-slice.sh`
  - renamed `steam/tools/run-companion-field-demo.sh` -> `steam/tools/dev-companion-field.sh`
  - renamed `steam/tools/run-dog-rig-spike.sh` -> `steam/tools/dev-dog-rig.sh`
  - renamed `steam/tools/run-window-spike.sh` -> `steam/tools/dev-window-spike.sh`
  - added `steam/tools/dev-start-cloudflared.sh`
  - `steam/tools/dev-vertical-slice.sh`
  - `steam/tools/dev-start-cloudflared.sh`
  - `steam/README.md`
  - `docs/repo/dev/godot-state-connector.md`
  - `docs/repo/dev/steam-vertical-slice-prototype.md`
  - `docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Godot_Control_Connector_v0.md`
  - `docs/repo/status/CODEX_STATUS.md`
- Launch commands:
  - `cd steam && ./launch.sh`
  - `cd steam && ./launch.sh --url`
  - `cd steam && ./launch.sh --barsulka --start`
  - `cd steam && ./launch.sh --barsulka`
  - `cd steam && ./launch.sh --barsulka --stop`
  - `cd steam && ./launch.sh --cloudflared --start`
  - `cd steam && ./launch.sh --cloudflared`
  - `cd steam && tools/dev-vertical-slice.sh connector-control-smoke`
- HTTP endpoints in control mode:
  - `GET /control?token=...`
  - `GET /control/capabilities?token=...`
  - `POST /control/ui/hide?token=...`
  - `POST /control/ui/show?token=...`
  - `POST /control/ui/toggle?token=...`
  - `POST /control/connector/http/stop?token=...`
- OpenAPI schema:
  - `docs/repo/api/godot-state-connector.openapi.yaml`
- Security behavior:
  - `/control*` endpoints return masked `404 not_found` without a valid token.
  - Public `/health` does not expose tokenized URLs or control details.
  - No generic command endpoint, shell command, filesystem command, gameplay mutation, task/resource/dog/order edit, pause/step control or save-file edit was added.
  - `/control` serves a small self-contained HTML dev page with Hide Game / Show Game buttons and no external dependencies.
  - Hide / Show now reports command status visibly in the control page and disables buttons while a command is in flight.
- Checks:
  - Passed: `Godot --headless --path steam --check-only --script res://scripts/dev_tools/godot_state_connector.gd`
  - Passed: `Godot --headless --path steam --check-only --script res://scripts/prototypes/vertical_slice/vertical_slice_demo.gd`
  - Passed: `cd steam && tools/dev-vertical-slice.sh connector-smoke`
  - Passed: `cd steam && tools/dev-vertical-slice.sh connector-control-smoke`
  - Passed: `cd steam && tools/dev-vertical-slice.sh smoke`
  - Passed: `cd steam && tools/check-godot.sh`
  - Passed: visible macOS control smoke: launched the real Vertical Slice window, called `POST /control/ui/hide`, verified `/state.game.window_visible=false`, called `POST /control/ui/show`, verified `/state.game.window_visible=true`, and confirmed no Godot/cloudflared processes remained afterward.
  - Passed: lookup semantics while no game was running: `./launch.sh --url` and `./launch.sh --cloudflared` both failed without starting Godot/cloudflared.
  - Passed: visible launcher flow: `./launch.sh` started one Godot process and printed local URLs.
  - Passed: `./launch.sh --url` printed local URLs for the already running process and started no second Godot process.
  - Passed: `./launch.sh --cloudflared --start` started one cloudflared process against the already running local connector; `./launch.sh --cloudflared` printed the saved public URL and started no second cloudflared process.
  - Passed: browser control page click test after macOS hide fix: clicking Hide returned `Done: ui.hide; window_visible=false`, and `osascript` reported `count windows = 0` for process `Godot`; clicking Show restored one window at the previous visible position.
  - Passed: `./launch.sh --barsulka --start` started one SSH reverse tunnel to `barsulka.eboshim.site:28765` for an already running local connector and did not start Godot.
  - Passed: repeated `./launch.sh --barsulka --start` detected the existing tunnel and did not start a duplicate SSH process.
  - Passed: `./launch.sh --barsulka` printed the saved public URL and started no process.
  - Passed: `./launch.sh --barsulka --stop` stopped the Barsulka SSH tunnel and the local HTTP connector while the Godot process stayed alive.
  - Passed: public `/health` through `http://barsulka.eboshim.site:28765/health` after configuring remote sshd for client-specified reverse-tunnel bind addresses.
  - Passed: OpenAPI YAML parses and includes token security plus `/control/connector/http/stop`.
- Observations:
  - Running connector smoke tests in parallel is unsafe because both use the same `.runtime/godot_state_connector/state_snapshot.json`; run connector smoke checks sequentially.
  - Plain `Window.hide()` was not sufficient on the tested macOS/Godot window: the logical state changed, but the native window could remain on screen. Hide now applies a minimized/offscreen fallback and repeats the hide action even when the logical flag is already false.
  - `tools/dev-start-cloudflared.sh` is now a compatibility helper for `./launch.sh --cloudflared --start` and starts no Godot process.
  - Barsulka reverse tunnel required remote sshd config `GatewayPorts clientspecified` and `AllowTcpForwarding yes` in `/etc/ssh/sshd_config.d/99-shelter-reverse-tunnel.conf`.
- Assumptions:
  - Hide / Show is treated as view/window control, not gameplay mutation.
  - ADR 0002 already covers controlled dev actions through explicit debug contracts, so no new ADR was required for this narrow v0.
- Blockers:
  - Windows behavior remains untested.
  - Cloudflare quick tunnel DNS may still be flaky on local macOS resolver; `launch.sh --cloudflared --start` retains the DNS fallback for public `/health` checks.
- Next recommended step:
  - Use `cd steam && ./launch.sh`, then `./launch.sh --barsulka --start` / `./launch.sh --barsulka` from another terminal when ChatGPT needs a public control URL. Keep `./launch.sh --cloudflared --start` / `./launch.sh --cloudflared` as the backup public tunnel path.

## 2026-06-29 - Godot State Connector v0

- Branch: `master`
- Summary: Implemented the accepted Godot State Connector v0 for the Steam Vertical Slice prototype. The connector is dev-only and opt-in, reads live state from the running Godot scene, exposes read-only `/health`, `/schema`, and `/state` HTTP endpoints, writes a conservative fallback JSON snapshot file on a configurable cadence, and keeps Godot as the source of truth instead of creating a standalone simulator.
- Changed files:
  - `.gitignore`
  - `steam/scripts/dev_tools/godot_state_connector.gd`
  - `steam/scripts/prototypes/vertical_slice/vertical_slice_demo.gd`
  - `steam/tools/dev-vertical-slice.sh`
  - `steam/tools/check-godot.sh`
  - `steam/README.md`
  - `docs/repo/adr/0002-game-state-as-source-of-truth.md`
  - `docs/repo/dev/godot-state-connector.md`
  - `docs/repo/dev/steam-vertical-slice-prototype.md`
  - `docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Godot_State_Connector_v0.md`
  - `docs/repo/status/CODEX_STATUS.md`
- Launch command:
  - `cd steam && tools/dev-vertical-slice.sh connector`
  - `cd steam && tools/dev-vertical-slice.sh connector-smoke`
- HTTP endpoints:
  - `http://127.0.0.1:8765/health`
  - `http://127.0.0.1:8765/schema`
  - `http://127.0.0.1:8765/state`
- Snapshot file:
  - `steam/.runtime/godot_state_connector/state_snapshot.json`
  - Default file write interval: `5` seconds.
  - Override: `STATE_CONNECTOR_INTERVAL=10 tools/dev-vertical-slice.sh connector`
- Checks:
  - Passed: `Godot --headless --path steam --check-only --script res://scripts/dev_tools/godot_state_connector.gd`
  - Passed: `Godot --headless --path steam --check-only --script res://scripts/prototypes/vertical_slice/vertical_slice_demo.gd`
  - Passed: `cd steam && tools/dev-vertical-slice.sh connector-smoke`
  - Passed: `cd steam && tools/dev-vertical-slice.sh smoke`
  - Passed: `cd steam && tools/check-godot.sh`
  - Passed: `git diff --check`
- Observations:
  - Live `/state` is assembled on request from the current Vertical Slice Godot state.
  - File snapshot writes are periodic and configurable, defaulting to `5` seconds to avoid unnecessary filesystem churn.
  - Snapshot exports D-010 dog layers separately: `innate_traits`, `learned_abilities`, and `equipment`.
  - Tunnel-ready mode exists as explicit dev mode and requires a token; no tunnel service or dependency was added.
- Assumptions:
  - Reading live `/state` on request is acceptable for ChatGPT / Codex inspection, while file snapshot mode is a fallback for local-file access.
  - The current connector is intentionally attached to the prototype-local Vertical Slice state machine; a future extraction pass should move gameplay state into a reusable core/runtime layer with UI as a state view.
- Blockers:
  - Windows behavior remains untested.
  - No external tunnel workflow has been validated yet.
  - Connector v0 is read-only; pause/step/control commands remain out of scope.
- Next recommended step:
  - Run `tools/dev-vertical-slice.sh connector` visibly, give ChatGPT/Codex either `/state` or the snapshot file path, and evaluate whether local HTTP, tunnel URL, or local-file access is the best review workflow.

## 2026-06-29 - Steam Vertical Slice Art QA Fix Pass v1

- Branch: `master`
- Summary: Implemented a Level 0 visual/readability cleanup for the Steam Vertical Slice prototype. Added explicit QA and player-prototype view presets, reduced UI/debug dominance in player-prototype mode, improved semantic resource placeholders, separated visible Food Mix and Food Bag tokens, strengthened Packing Table as a Utility Prop work surface, and added dog/action lanes plus compact action badges.
- Changed files:
  - `steam/scripts/prototypes/vertical_slice/vertical_slice_demo.gd`
  - `steam/tools/dev-vertical-slice.sh`
  - `docs/repo/dev/steam-vertical-slice-prototype.md`
  - `docs/repo/status/CODEX_STATUS.md`
  - `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_VERTICAL_SLICE_ART_QA_CAPTURE_v2/README.md`
  - `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_VERTICAL_SLICE_ART_QA_CAPTURE_v2/CAPTURE_MANIFEST_v2.md`
  - generated capture PNG/log outputs under `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_VERTICAL_SLICE_ART_QA_CAPTURE_v2/captures/`
- Checks:
  - Passed: `Godot --headless --path steam --check-only --script res://scripts/prototypes/vertical_slice/vertical_slice_demo.gd`
  - Passed: `cd steam && tools/dev-vertical-slice.sh smoke`
  - Passed: `cd steam && tools/dev-vertical-slice.sh capture`
  - Passed: `cd steam && tools/dev-vertical-slice.sh capture-smoke`
  - Passed: `cd steam && tools/check-godot.sh`
  - Passed: `git diff --check`
  - Passed: capture file count check by filesystem listing: 16 named screenshots including 15 required screenshots plus `09b_van_ready_confirm_delivery.png`, and 27 PNG sequence frames.
  - Passed: preview size check via `sips`: readability preview heights are 216, 144, and 96 px.
  - Passed: spot visual inspection of `02_initial_strip_player_prototype.png`, `05_storage_to_kitchen_carry.png`, `08_packing_table_food_bag.png`, and `15_readability_preview_96.png`.
- Captures:
  - `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_VERTICAL_SLICE_ART_QA_CAPTURE_v2/`
  - `captures/screenshots/01_initial_strip_qa_labels_on.png` through `15_readability_preview_96.png`, plus extra `09b_van_ready_confirm_delivery.png`.
  - `captures/video/vertical_slice_full_loop_short_frames/frame_0001.png` through `frame_0027.png`.
  - `captures/logs/capture_run_log.txt`
- Observations:
  - QA mode keeps labels/debug cards available for internal review.
  - Player-prototype mode hides semantic labels, debug card, status/performance text, and uses compact top cards so the world/action strip becomes the visual priority.
  - Food Mix and Food Bag are visible as separate semantic tokens during transformation; the old composite remains only an internal bridge.
  - Packing Table still reads as Utility Prop / work surface, not a Building.
  - Delivery Van Endpoint remains an endpoint/vehicle, not a garage/building.
- Assumptions:
  - Simple geometric tokens, action lanes, and action badges are acceptable Level 0 semantic placeholders under the accepted cross-role RFC.
  - Capturing the main loop in player-prototype mode is the right follow-up to Art QA v1 because it tests labels-off readability and UI dominance more directly.
- Blockers:
  - Human Art Director review is still required for capture v2 before claiming player-facing visual/readability approval.
  - Production art, Dog Shape Pack v1, final UI style, and normal-feel timing remain out of scope.
  - Windows behavior remains untested.
- Next recommended step:
  - Art Director reviews `STEAM_VERTICAL_SLICE_ART_QA_CAPTURE_v2`; if v2 passes, start Dog Shape Pack v1, otherwise run one focused readability pass on the failing states only.

## 2026-06-29 - Steam Vertical Slice Art QA Capture Pack v1

- Branch: `master`
- Summary: Created the Art Director QA capture pack for the current Steam Vertical Slice prototype. Added a dev-only capture mode to the prototype scene and launcher script, captured the required named screenshots, and produced a PNG-frame sequence fallback for the full loop screencast.
- Output directory:
  - `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_VERTICAL_SLICE_ART_QA_CAPTURE_v1/`
- Capture outputs:
  - `captures/screenshots/01_initial_strip.png` through `captures/screenshots/19_debug_labels_off.png` - 19 screenshots, including all required and optional brief moments.
  - `captures/video/vertical_slice_full_loop_short_frames/frame_0001.png` through `frame_0027.png` - accepted fallback for `vertical_slice_full_loop_short.mp4`.
  - `captures/logs/capture_run_log.txt`
  - `README.md`
  - `CAPTURE_MANIFEST_v1.md`
- Changed files:
  - `steam/scripts/prototypes/vertical_slice/vertical_slice_demo.gd`
  - `steam/tools/dev-vertical-slice.sh`
  - `docs/repo/dev/steam-vertical-slice-prototype.md`
  - `docs/repo/status/CODEX_STATUS.md`
- Checks:
  - Passed: `Godot --headless --path steam --check-only --script res://scripts/prototypes/vertical_slice/vertical_slice_demo.gd`
  - Passed: `cd steam && tools/dev-vertical-slice.sh capture-smoke` using a temporary capture directory
  - Passed: `cd steam && tools/dev-vertical-slice.sh capture`
  - Passed: `cd steam && tools/dev-vertical-slice.sh smoke`
  - Passed: `cd steam && tools/check-godot.sh`
  - Passed: capture file count check: 19 named screenshots and 27 PNG sequence frames exist.
  - Passed: `capture-smoke` cleanup check: `_capture_smoke_tmp` is absent after the smoke run and the delivered capture pack still contains 19 screenshots and 27 sequence frames.
  - Passed: spot visual inspection of `01_initial_strip.png`, `13_van_ready_confirm_delivery.png`, and `16_hide_ui_world_visible.png`.
  - Passed: `git diff --check`
- Capture environment:
  - Godot `4.7.stable.steam.5b4e0cb0f`
  - macOS visible window capture, Metal Forward+, `3456 x 224`, borderless transparent always-on-top companion strip.
  - Fast deterministic timings; semantic/debug labels on except `19_debug_labels_off.png`.
- Assumptions:
  - PNG-frame sequence is acceptable as the brief's screencast fallback.
  - Capture mode is dev-only and does not change gameplay scope or player-facing loop behavior.
- Known limitations:
  - No `.mp4` was generated.
  - Headless Godot cannot capture viewport screenshots in this environment because the dummy renderer does not expose a viewport texture.
  - Captures use prototype placeholders and require Art Director review before any visual conclusion.
- Next recommended step:
  - Art Director reviews the capture pack for readability, visual hierarchy, placeholder acceptability, dog/action visibility, UI dominance and main-strip composition.

## 2026-06-29 - Steam Vertical Slice Prototype v1

- Branch: `master`
- Summary: Implemented the first isolated Steam/Desktop Vertical Slice prototype scene. The loop covers Road Sign route start, Dachshund + Basket Bicycle trip, visible Oat/Pumpkin payload return, dog unload into Storage, carry to Kitchen, Food Mix, carry to Packing Table, Food Bag, visible load into Delivery Van Endpoint, player-confirmed delivery, Postcard, Comfortable Slippers reward, and Dog Card innate/equipment separation.
- Added files:
  - `steam/scenes/prototypes/vertical_slice/vertical_slice_demo.tscn`
  - `steam/scripts/prototypes/vertical_slice/vertical_slice_demo.gd`
  - `steam/tools/dev-vertical-slice.sh`
  - `steam/assets/prototypes/vertical_slice/semantic/README.md`
  - Steam-local semantic asset mirrors under `steam/assets/prototypes/vertical_slice/semantic/`
  - `docs/repo/dev/steam-vertical-slice-prototype.md`
- Updated files:
  - `steam/scripts/launcher.gd`
  - `steam/tools/check-godot.sh`
  - `steam/README.md`
  - `docs/repo/status/CODEX_STATUS.md`
- Checks:
  - Passed: `Godot --headless --path steam --check-only --script res://scripts/prototypes/vertical_slice/vertical_slice_demo.gd`
  - Passed: direct headless Vertical Slice auto-play smoke:
    `Godot --headless --path steam --scene res://scenes/prototypes/vertical_slice/vertical_slice_demo.tscn -- --vertical-auto-play --vertical-fast --vertical-auto-quit --vertical-seconds=10`
  - Passed: `steam/tools/dev-vertical-slice.sh smoke`
  - Passed: launcher direct target start check:
    `Godot --headless --path steam --scene res://scenes/launcher.tscn -- --launcher-direct=vertical_slice_smoke`
  - Passed: `steam/tools/check-godot.sh`
  - Passed: `steam/tools/dev-companion-field.sh smoke`
  - Passed: visible macOS Vertical Slice auto-play smoke:
    `Godot --path steam --scene res://scenes/prototypes/vertical_slice/vertical_slice_demo.tscn -- --vertical-auto-play --vertical-fast --vertical-auto-quit --vertical-seconds=10`
  - The smoke log reached `vertical_slice_complete=true` after `reward_equipped`.
- Assumptions:
  - The scene is prototype-local and intentionally does not replace the existing companion field demo.
  - Neutral labeled placeholders are allowed for missing Packing Table, resources, dog action sprites, postcard and slippers, per D-016/RFC boundaries.
  - Comfortable Slippers have no numeric effect in the first slice; their purpose is D-010 trait/equipment separation.
  - Timings are compressed prototype timings and smoke timings are further compressed.
- Blockers:
  - Human visible review is still needed for readability and feeling.
  - Production assets remain missing for Packing Table, separate resource icons, dog actions, postcard and slippers.
  - Windows behavior remains untested.
- Next recommended step:
  - Run `tools/dev-vertical-slice.sh` visibly, then evaluate the implementation with `STEAM_DESKTOP__Vertical_Slice_Playtest_Checklist_v1`.

## 2026-06-29 - Semantic Composite Asset Import

- Branch: `master`
- Summary: Imported the manually placed Steam/Desktop semantic composite PNG and cropped it into 6 temporary semantic placeholder assets for Codex prototype use. The original image produced 6 usable objects, not 8 separate assets; Food Mix and Food Bag remain combined in one temporary resource composite.
- Created PNG files:
  - `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Semantic_Asset_Pack_v1/approved/utility_props/road_sign.png`
  - `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Semantic_Asset_Pack_v1/approved/utility_props/basket_bicycle.png`
  - `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Semantic_Asset_Pack_v1/approved/buildings/storage.png`
  - `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Semantic_Asset_Pack_v1/approved/buildings/kitchen.png`
  - `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Semantic_Asset_Pack_v1/approved/utility_props/delivery_van_endpoint.png`
  - `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Semantic_Asset_Pack_v1/approved/resources/food_mix_and_food_bag_composite.png`
- Updated documentation files:
  - `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Semantic_Asset_Pack_v1/APPROVED_ASSET_IMPORT_MANIFEST_v1.md`
  - `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Semantic_Asset_Pack_v1/README.md`
  - `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Semantic_Asset_Pack_v1/cards/road_sign.md`
  - `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Semantic_Asset_Pack_v1/cards/basket_bicycle.md`
  - `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Semantic_Asset_Pack_v1/cards/storage.md`
  - `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Semantic_Asset_Pack_v1/cards/kitchen.md`
  - `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Semantic_Asset_Pack_v1/cards/delivery_van_endpoint.md`
  - `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Semantic_Asset_Pack_v1/cards/resources_vertical_slice.md`
  - `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_DESKTOP__Semantic_Asset_Pack_v1/cards/packing_table.md`
  - `docs/drive/Shelter/04_DEVELOPMENT/STEAM_DESKTOP__Codex_Brief__Import_Semantic_Composite_Assets_v1.md`
  - `docs/repo/status/CODEX_STATUS.md`
- Checks:
  - Passed: source PNG exists at expected path and is `1536 x 1024` RGBA.
  - Passed: all 6 target PNG files exist under `approved/`.
  - Passed: alpha check for all 6 crops reported `alpha=(0, 255)`.
  - Passed: legacy import-not-yet-done wording search returned no live matches in `docs` or `steam`.
  - Passed: scoped `git diff --check` for files changed by this semantic import task.
  - Not passed for whole worktree: `git diff --check` still reports trailing whitespace in unrelated pre-existing/user-edited docs under `docs/drive/Shelter/00_START_HERE/00_PROJECT_INDEX.md`, `STEAM_DESKTOP__Game_Designer_Session_Brief.md`, and `BROWSER_EXTENSION__Game_Designer_Session_Brief.md`.
- Assumptions:
  - Crops are temporary semantic placeholders and not final production art.
  - Near-black background removal is acceptable for prototype use, but final art cleanup/polish remains an Art Direction task.
  - Steam-local copies were not created because the current brief only required the semantic pack outputs.
- Blockers:
  - The full Semantic Asset Pack is still incomplete.
- Missing assets:
  - Packing Table, separate Oat Crate, separate Pumpkin Crate, Protein Packet, Packaging Bag, separate Food Mix, separate Food Bag, Comfortable Slippers icon, First Postcard frame, and dog action sprites.
- Next recommended step:
  - Generate or place the remaining Level 0 semantic placeholders, then wire the approved asset paths into the Vertical Slice prototype when that implementation task starts.

## 2026-06-29 - Visual Game Launcher

- Branch: `codex/reorganize-monorepo`
- Summary: Added a human-facing visual launcher for Steam/Godot work. `steam/launch.sh` now opens `res://scenes/launcher.tscn`, a simple Godot launcher window with large buttons for the companion strip, dog runtime strip, dog rig lab and window probe. Existing `steam/tools/*.sh` scripts remain as development diagnostics and smoke-check entry points rather than the primary manual entry point.
- Changed files:
  - `README.md`
  - `steam/README.md`
  - `steam/launch.sh`
  - `steam/scenes/launcher.tscn`
  - `steam/scripts/launcher.gd`
  - `steam/tools/check-godot.sh`
  - `docs/repo/dev/godot-setup.md`
  - `docs/repo/status/CODEX_STATUS.md`
- Checks:
  - Passed: `Godot --headless --path steam --check-only --script res://scripts/launcher.gd`
  - Passed: `steam/launch.sh --launcher-auto-quit`
  - Passed: `steam/launch.sh --launcher-direct=dog_runtime_smoke`
  - Passed: `steam/tools/check-godot.sh`
- Assumptions:
  - `tools/*.sh` should stay in the repo for automation, checks and targeted debugging, even though day-to-day manual usage should start from `./launch.sh`.
  - Hidden launcher parameters are for Codex/dev automation only and are intentionally not documented as normal user workflow.
- Blockers:
  - Launcher visuals are intentionally simple dev UI, not final product UI.
  - Windows behavior remains untested.
- Next recommended step:
  - Use `cd steam && ./launch.sh` for manual runs, then fold the future Vertical Slice prototype into this launcher when that scene exists.

## 2026-06-29 - Dog Runtime Integration Slice v0

- Branch: `codex/reorganize-monorepo`
- Summary: Added a debug-only embedded Bublik dog runtime to the real companion field demo. `tools/dev-companion-field.sh dog-runtime` opens the normal companion strip with performance HUD and one `DOG-PROT-001 / Bublik` bridge runtime; `dog-runtime-smoke` runs the same path headless with auto-quit. The dog uses Dog DNA from `dog_dna_examples.json`, stays on the field baseline, follows field world coordinates for pan/zoom, and plays `idle -> walk -> pickup food bag -> carry -> deliver -> wag -> idle` with mouth-socket food bag attachment/release and a debug phrase/socket label.
- Changed files:
  - `steam/scripts/tech_demos/companion_field_demo.gd`
  - `steam/tools/dev-companion-field.sh`
  - `steam/tools/check-godot.sh`
  - `steam/README.md`
  - `docs/repo/dev/companion-field-tech-demo.md`
  - `docs/repo/dev/dog-rig-spike.md`
  - `docs/repo/status/CODEX_STATUS.md`
- Checks:
  - Passed: `Godot --headless --path steam --check-only --script res://scripts/tech_demos/companion_field_demo.gd`
  - Passed: `steam/tools/dev-companion-field.sh dog-runtime-smoke`
  - Passed: visible macOS companion dog runtime auto-quit:
    `Godot --path steam --scene res://scenes/tech_demos/companion_field_demo.tscn -- --demo-auto-quit --demo-seconds=1.2 --demo-companion --demo-transparent --demo-dog-runtime --demo-perf`
  - Passed: visible macOS companion dog runtime perf auto-quit:
    `Godot --print-fps --path steam --scene res://scenes/tech_demos/companion_field_demo.tscn -- --demo-auto-quit --demo-seconds=3.2 --demo-companion --demo-transparent --demo-dog-runtime --demo-perf`
  - Passed: `steam/tools/check-godot.sh`
- Observations:
  - Short visible macOS run used Metal 4.0 Forward+, full-width companion strip `(3456, 220)` at bottom of usable rect, transparent/borderless/always-on-top enabled.
  - The `--print-fps` short run reported `Project FPS: 120` with VSync enabled. This is a development observation, not a production benchmark.
  - Existing companion smoke, dog rig smoke/stress/pipeline/hybrid/hybrid-companion smoke checks still pass through `steam/tools/check-godot.sh`.
- Assumptions:
  - The implementation is intentionally an embedded prototype bridge inside `companion_field_demo.gd`, not a shared production dog runtime module.
  - The bridge uses authored-base-equivalent phrase names plus procedural Dog DNA/personality/socket overlays from the v3 direction, but it does not move the full spike scene into the companion demo.
- Blockers:
  - Human visible review is still needed for phrase readability, dog scale, and object/socket readability on the target desktop setup.
  - Windows behavior remains untested.
  - A future extraction pass is needed before multi-dog production runtime work.
- Next recommended step:
  - Review `tools/dev-companion-field.sh dog-runtime` visibly, then decide whether to extract a reusable dog runtime scene/resource or wait for `Dog Shape Pack v1`.

## 2026-06-29 - Dog Rig Hybrid Runtime v3

- Branch: `codex/reorganize-monorepo`
- Summary: Dog Rig Spike extended with v3 hybrid runtime modes. `tools/dev-dog-rig.sh hybrid` compares procedural Bublik with Hybrid Bublik, where `AnimationPlayer` owns base clips and procedural runtime overlays Dog DNA dimensions, phrase timing, socket visibility, food bag attachment/swing, and personality head/tail/ear motion. Added `hybrid-companion-perf` as a companion-like short-strip dog runtime performance context with Bublik, Knopka, and Mishka.
- Changed files:
  - `steam/scripts/tech_demos/dog_rig_spike.gd`
  - `steam/tools/dev-dog-rig.sh`
  - `steam/tools/check-godot.sh`
  - `steam/README.md`
  - `docs/repo/dev/dog-rig-spike.md`
  - `docs/repo/status/CODEX_STATUS.md`
- Checks:
  - Passed: `steam/tools/dev-dog-rig.sh smoke`
  - Passed: `steam/tools/dev-dog-rig.sh stress-smoke`
  - Passed: `steam/tools/dev-dog-rig.sh pipeline-smoke`
  - Passed: `steam/tools/dev-dog-rig.sh hybrid-smoke`
  - Passed: `steam/tools/dev-dog-rig.sh hybrid-companion-smoke`
  - Passed: `steam/tools/check-godot.sh`
  - Passed: visible macOS hybrid launch with perf print:
    `Godot --path steam --scene res://scenes/tech_demos/dog_rig_spike.tscn -- --dog-rig-hybrid --dog-rig-print-perf --dog-rig-auto-quit --dog-rig-seconds=2.2`
  - Passed: visible macOS companion-like launch with perf print:
    `Godot --path steam --scene res://scenes/tech_demos/dog_rig_spike.tscn -- --dog-rig-hybrid-companion --dog-rig-print-perf --dog-rig-auto-quit --dog-rig-seconds=2.2`
  - Passed: `git diff --check`
- Observations:
  - Hybrid Bublik remains readable compared with procedural Bublik.
  - `AnimationPlayer` base clips are useful for base pose intent, while Dog DNA dimensions and personality motion remain better as runtime overlays.
  - Food bag socket/visibility/swing remains runtime-owned and did not regress in hybrid mode.
  - Companion-like short strip with three hybrid dogs showed no obvious isolated red flag on the visible macOS run.
  - Short visible macOS observations: hybrid comparison roughly `51-120` FPS, `64` nodes, about `37` draw calls; hybrid companion-like strip roughly `71-120` FPS, `110` nodes, about `50` draw calls. These are not production benchmarks.
- Assumptions:
  - v3 is still a technical-art spike, not an ADR or final animation pipeline decision.
  - Companion-like mode is a constrained dog-rig strip and not the real companion field demo.
  - Runtime-created authored clips are enough to test the hybrid split before real dog art parts exist.
- Blockers:
  - Real companion field integration is still not measured.
  - Windows behavior remains untested.
  - Real dog art parts are needed before deciding whether node-based hybrid is enough or `Skeleton2D` needs a separate feasibility spike.
- Next recommended step:
  - Prepare `Dog Shape Pack v1` as the next art task and a separate `Dog Runtime Integration Slice` for one hybrid dog inside the production-strip prototype; keep `Skeleton2D`/external tooling deferred until real art exposes a concrete limitation.

## 2026-06-29 - Dog Rig Animation Pipeline Comparison v2

- Branch: `codex/reorganize-monorepo`
- Summary: Dog Rig Spike extended with a v2 `pipeline` mode comparing current procedural Bublik against a minimal `AnimationPlayer`-authored Bublik in the same scene. The authored lane creates runtime clips for `idle_neutral`, `head_look`, `walk_empty`, `walk_carry_medium`, `pickup_pose`, `deliver_pose`, and `tail_wag`, then maps authored driver tracks back to the same modular body/head/legs/ears/tail/bag parts and socket model.
- Changed files:
  - `steam/scripts/tech_demos/dog_rig_spike.gd`
  - `steam/tools/dev-dog-rig.sh`
  - `steam/tools/check-godot.sh`
  - `steam/README.md`
  - `docs/repo/dev/dog-rig-spike.md`
  - `docs/repo/status/CODEX_STATUS.md`
- Checks:
  - Passed: `steam/tools/dev-dog-rig.sh smoke`
  - Passed: `steam/tools/dev-dog-rig.sh stress-smoke`
  - Passed: `steam/tools/dev-dog-rig.sh pipeline-smoke`
  - Passed: `steam/tools/check-godot.sh`
  - Passed: visible macOS pipeline launch with perf print:
    `Godot --path steam --scene res://scenes/tech_demos/dog_rig_spike.tscn -- --dog-rig-pipeline --dog-rig-print-perf --dog-rig-auto-quit --dog-rig-seconds=2.2`
  - Passed: `git diff --check`
- Observations:
  - Existing v0 single-dog and v1 stress modes remain functional.
  - `AnimationPlayer` can author coarse idle/walk/carry/pickup/deliver/tail-wag pose clips for Bublik without external tooling.
  - Authored clips help with base pose readability, but Dog DNA loading, phrase timing, lane movement, bag visibility, socket handling, and personality offsets still need a runtime layer.
  - Procedural remains stronger for Dog DNA and morphology offsets; authored clips look promising as base clips in a hybrid model.
  - Short visible macOS pipeline observation: roughly `65-120` FPS, `64` nodes, about `37` draw calls; not a production benchmark.
- Assumptions:
  - v2 is a comparison spike, not an ADR or final pipeline selection.
  - Runtime-created AnimationPlayer clips are enough to test workflow friction before investing in editor-authored clips or imported art.
  - `Skeleton2D` and external tools remain out of scope for this task.
- Blockers:
  - Authored clips were tested only on Bublik, not on Knopka/Mishka morphology variants.
  - Companion-overlay performance is still not measured.
  - Windows behavior remains untested.
- Next recommended step:
  - Plan `Dog Rig Spike v3 - Hybrid Runtime`: authored base clips plus procedural Dog DNA/personality/socket layers, then test that hybrid in the companion overlay performance context.

## 2026-06-29 - Dog Rig Morphology Stress v1

- Branch: `codex/reorganize-monorepo`
- Summary: Dog Rig Spike extended with a v1 morphology stress mode: `tools/dev-dog-rig.sh stress` shows Bublik, Knopka, and Mishka simultaneously in three lanes, all loaded from `dog_dna_examples.json`, all using the same reusable `_update_rig(...)` runtime phrase `idle -> look -> walk -> pickup -> carry -> deliver -> wag`, with socket-attached food bags, staggered phases, per-dog labels, 216/144/96 silhouette readability previews, and a minimal perf HUD/print.
- Changed files:
  - `steam/scripts/tech_demos/dog_rig_spike.gd`
  - `steam/tools/dev-dog-rig.sh`
  - `steam/tools/check-godot.sh`
  - `steam/README.md`
  - `docs/repo/dev/dog-rig-spike.md`
  - `docs/repo/status/CODEX_STATUS.md`
- Checks:
  - Passed: `steam/tools/dev-dog-rig.sh smoke`
  - Passed: `steam/tools/dev-dog-rig.sh stress-smoke`
  - Passed: `steam/tools/check-godot.sh`
  - Passed: visible macOS stress launch with perf print:
    `Godot --path steam --scene res://scenes/tech_demos/dog_rig_spike.tscn -- --dog-rig-stress --dog-rig-print-perf --dog-rig-auto-quit --dog-rig-seconds=2.2`
  - Passed: `git diff --check`
- Observations:
  - The three prototype morphologies can share one procedural action grammar without copying per-dog animation logic.
  - Bublik is the stable baseline; Knopka shows the expected short/long silhouette and is the main future foot-readability risk; Mishka reads as sturdier/larger without requiring separate world scale in this debug scene.
  - The carried food bag remains attached through the mouth/harness socket for all three dogs.
  - Approximate 216/144/96 silhouette previews keep dog + carried object readable, but 96 px secondary motion should remain subtle in later art.
  - Short visible macOS perf observation: roughly `80-108` FPS, `77` nodes, about `110` draw calls; headless FPS remains not meaningful.
- Assumptions:
  - v1 remains a technical-art spike using Godot nodes + manual transforms, not a final animation pipeline decision.
  - The silhouette preview is approximate and intended for debug readability only.
  - Current placeholder shapes are enough to test runtime grammar, sockets, and morphology differences.
- Blockers:
  - Companion-overlay performance is still not measured.
  - Windows behavior remains untested.
  - Human art-direction review is still needed before calling the morphology pass visually accepted.
- Next recommended step:
  - Start `Dog Rig Spike v2 - Animation Pipeline Comparison`: compare current procedural node transforms with a small `AnimationPlayer`/`AnimationTree` version, then decide whether `Skeleton2D` or external tooling needs a separate feasibility spike.

## 2026-06-28 - Dog Rig Spike v0

- Branch: `codex/reorganize-monorepo`
- Summary: Реализован первый Godot Dog Runtime proof для `standard_medium`: отдельная tech demo-сцена собирает собаку из модульных частей, проигрывает фиксированную фразу `idle -> look -> walk -> pickup -> carry -> deliver -> wag`, держит food bag через socket на голове/шлейке и использует процедурные слои `tail_wag`, `head_look`, `ear_bounce` плюс object swing. Dog DNA examples добавлены для Бублика, Кнопки и Мишки; acceptance-critical default — `DOG-PROT-001 / Bublik`.
- Changed files:
  - `steam/scenes/tech_demos/dog_rig_spike.tscn`
  - `steam/scripts/tech_demos/dog_rig_spike.gd`
  - `steam/scripts/tech_demos/dog_rig_spike.gd.uid`
  - `steam/resources/tech_demos/dog_dna_examples.json`
  - `steam/tools/dev-dog-rig.sh`
  - `steam/tools/check-godot.sh`
  - `steam/README.md`
  - `docs/repo/dev/dog-rig-spike.md`
  - `docs/repo/status/CODEX_STATUS.md`
- Checks:
  - Passed: `steam/tools/dev-dog-rig.sh smoke`
  - Passed: `steam/tools/check-godot.sh`
  - Passed: direct headless DOG-PROT-002 launch:
    `Godot --headless --path steam --scene res://scenes/tech_demos/dog_rig_spike.tscn -- --dog-rig-auto-quit --dog-id=DOG-PROT-002`
  - Passed: direct headless DOG-PROT-003 launch:
    `Godot --headless --path steam --scene res://scenes/tech_demos/dog_rig_spike.tscn -- --dog-rig-auto-quit --dog-id=DOG-PROT-003`
  - Passed: visible macOS auto-quit launch:
    `Godot --path steam --scene res://scenes/tech_demos/dog_rig_spike.tscn --quit-after 2 -- --dog-id=DOG-PROT-001`
  - Passed: `git diff --check`
- Assumptions:
  - v0 intentionally uses brief Option B: Godot nodes + manual part transforms, not a final production animation architecture.
  - Placeholder geometry is enough for tech-art feasibility; visual quality is out of scope.
  - JSON is acceptable for prototype Dog DNA examples before a Resource/save-format decision.
- Blockers:
  - Companion-overlay performance is not measured yet.
  - Windows behavior remains untested.
- Next recommended step:
  - Run the visible dog spike for Bublik/Knopka/Mishka, then test whether the same grammar survives a side-by-side morphology stress scene before choosing Godot `AnimationPlayer`/`Skeleton2D`/external-tool direction.

## 2026-06-28 - Drive Mirror Local Link Cleanup

- Branch: `codex/reorganize-monorepo`
- Summary: `docs/drive` переведён в repository-first состояние после восстановления Drive mirror: ссылки на Drive для уже скачанных PNG заменены на локальные repo-ссылки, а `docs/drive/MANIFEST.md` переписан как локальный manifest без устаревших Google Docs/image-stub URL.
- Changed files:
  - `docs/drive/MANIFEST.md`
  - `docs/drive/Shelter/03_DESIGN/03_PROMPTS/STEAM_OVERLAY__System_Board_Template_v0.md`
  - `docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_OVERLAY__Approved_Library_v1.md`
  - `docs/repo/status/CODEX_STATUS.md`
- Checks:
  - Passed: `rg -n "https://(drive|docs)\\.google\\.com/" docs/drive --glob '*.md'` returned no matches.
  - Passed: all newly referenced local PNG paths exist in the repository.
- Notes:
  - Drive-source URLs were intentionally removed from the mirror docs because the corresponding documents/assets now exist locally in `docs/drive`.

## 2026-06-27 - Monorepo Reorganization

- Branch: `codex/reorganize-monorepo`
- Summary: Репозиторий реорганизован в монорепо: Steam/Godot-проект перенесён в `steam/`, создана пустая зона `chrome/`, локальные repo-доки перенесены в `docs/repo/`, а Google Drive `Shelter/` зеркалирован в `docs/drive/Shelter/` с manifest и markdown/text-friendly stub-файлами для Drive-документов и бинарных ассетов.
- Changed files:
  - `AGENTS.md`
  - `README.md`
  - `.gitignore`
  - `steam/**`
  - `chrome/.gitkeep`
  - `docs/repo/**`
  - `docs/drive/**`
- Checks:
  - Passed: `rg "docs/status|docs/adr|docs/dev|project.godot|tools/check-godot.sh"` found no stale `docs/status`, `docs/adr`, or `docs/dev` references; remaining `project.godot` / `tools/check-godot.sh` matches are expected new `steam/` project references or historical status entries.
  - Passed: `cd steam && tools/check-godot.sh`
  - Passed: `cd steam && tools/dev-companion-field.sh smoke`
  - Passed: `cd steam && tools/dev-window-spike.sh smoke`
  - Passed: `find docs/drive/Shelter -type f | sort`
  - Passed: `git diff --check`
- Assumptions:
  - `steam/` является новым корнем Godot-проекта, поэтому внутренние `res://` ссылки не переписывались.
  - `chrome/` пока остаётся пустой рабочей зоной без extension-кода и без `chrome/AGENTS.md`.
  - Google Docs представлены markdown stub-файлами с Drive URL и метаданными: connector показал интерактивный `text/markdown` export, но не предоставил стабильный локальный путь для bulk filesystem export в этой сессии.
- Blockers:
  - Для полного текстового содержимого Google Docs нужен отдельный refresh-проход с filesystem-capable Drive export или локальным Drive CLI/API-токеном.
- Next recommended step:
  - Настроить воспроизводимый Drive-to-filesystem exporter, который заменит Google Docs stub-файлы в `docs/drive/Shelter/` полным `text/markdown` содержимым.

## 2026-06-24 - Dev Context Sync With D-009/D-010

- Branch: `master`
- Summary: Синхронизирован dev-контекст Steam/Desktop-репозитория с Drive-решениями D-009 и D-010: Steam/Desktop зафиксирован как отдельная Windows/macOS Godot-игра, ядро описано как горизонтальный собачий производственный кооператив (`cozy idle production strip + dog community sim`), а системы собак должны разделять врождённые/неизменяемые и изменяемые/экипируемые/приобретённые особенности.
- Changed files:
  - `steam/AGENTS.md`
  - `steam/README.md`
  - `docs/repo/product/steam_desktop_context.md`
  - `docs/repo/status/CODEX_STATUS.md`
- Checks:
  - Passed: Drive context read through Google Drive connector: `00_PROJECT_INDEX.md`, `01_CURRENT_STATUS`, `02_DECISIONS`, `STEAM_DESKTOP__Game_Designer_Session_Brief`.
  - Passed: `git diff --check`
  - Passed: `git diff --no-index --check /dev/null docs/repo/product/steam_desktop_context.md` produced no whitespace diagnostics for the new untracked file.
- Assumptions:
  - Google Drive product decisions are the source of truth when they conflict with older repo wording.
  - This task is documentation/context sync only; no gameplay, Godot scene, economy, or window behavior was implemented.
- Blockers:
  - No direct edits were made to Google Drive documents; repo docs now mirror the accepted D-009/D-010 context.
  - Windows behavior remains untested.
- Next recommended step:
  - Start the first D-009-aligned Godot spike: keep the existing companion-window groundwork, then prototype a lower horizontal production strip with zones/blocks, horizontal scroll, a placeholder dog agent walking, and a tiny production loop `ingredient crate -> mixer -> food bag -> van`.

## 2026-06-24 - Companion Performance HUD

- Branch: `codex/dev-bootstrap-godot`
- Summary: Добавлен dev performance HUD для companion field demo: он показывает FPS, frame/physics time, память, VRAM/texture memory, draw calls, object/node count прямо поверх игры; в настройки добавлен toggle `Performance HUD`, а launcher получил режим `perf` с Godot `--print-fps`.
- Changed files:
  - `steam/scripts/tech_demos/companion_field_demo.gd`
  - `steam/tools/dev-companion-field.sh`
  - `steam/README.md`
  - `docs/repo/dev/companion-field-tech-demo.md`
  - `docs/repo/dev/performance-observability.md`
  - `docs/repo/status/CODEX_STATUS.md`
- Checks:
  - Passed: `steam/tools/dev-companion-field.sh smoke`
  - Passed: `steam/tools/check-godot.sh`
  - Passed: direct headless perf override check:
    `Godot --headless --path steam --scene res://scenes/tech_demos/companion_field_demo.tscn -- --demo-auto-quit --demo-seconds=0.8 --demo-zoom=100 --demo-controls-scale=150 --demo-perf`
  - Passed: `git diff --check`
  - Passed: visible macOS companion launch with `steam/tools/dev-companion-field.sh perf` and Computer Use visual check: the in-game HUD appears in the top-right corner and stdout prints live `Project FPS: ...` lines.
- Assumptions:
  - Godot `Performance` counters enough for the текущий dev HUD; full CPU%, battery, and platform power profiling remain separate Windows/macOS tasks.
  - HUD updates on a timer every `0.5s`, not in `_process()`, чтобы сам мониторинг не стал заметной нагрузкой.
- Blockers:
  - Windows behavior remains untested.
- Next recommended step:
  - Прогнать visible `steam/tools/dev-companion-field.sh perf`, смотреть HUD во время zoom/pan/animals, и зафиксировать первые baseline-цифры для сравнения будущих визуальных задач.

## 2026-06-24 - Companion Visual Cleanup And Hide Button

- Branch: `codex/dev-bootstrap-godot`
- Summary: Улучшена читаемость companion demo относительно CQ-референса: procedural урны/фонтан/башни убраны из текущих объектов, building types переключены на asset-based `TX Village Props`, животные получили x2 tight non-empty frame lists для безопасной анимации без пустых кадров, кадросмена ускорена, добавлена правая кнопка `Hide` / `Show`.
- Changed files:
  - `steam/resources/tech_demos/companion_field_layout.json`
  - `steam/scripts/tech_demos/companion_field_demo.gd`
  - `docs/repo/dev/companion-field-tech-demo.md`
  - `docs/repo/status/CODEX_STATUS.md`
- Checks:
  - Passed: `steam/tools/dev-companion-field.sh smoke`
  - Passed: `steam/tools/check-godot.sh`
  - Passed: direct headless override check:
    `Godot --headless --path steam --scene res://scenes/tech_demos/companion_field_demo.tscn -- --demo-auto-quit --demo-zoom=100 --demo-controls-scale=150`
  - Passed: `git diff --check`
  - Passed: visible macOS companion launch and Computer Use visual check: procedural tower/fountain/bin objects are gone, asset-prop objects render without broken atlas cuts, x2 animals animate through explicit tight frames, and `Hide` / `Show` leaves only the right-side button visible.
- Assumptions:
  - `TX Village Props` остаются временными placeholder-ассетами; финальные Shelter-объекты будут заказаны у художников.
  - Для текущего прототипа безопаснее анимировать животных явными tight-списками кадров, чем пытаться автоматически угадывать ряды и длину клипов из разрозненных spritesheet PNG.
  - `Hide` / `Show` пока скрывает визуальное поле внутри того же companion window; отдельную production-модель collapse/window resize ещё нужно спроектировать после UX-проверки.
- Blockers:
  - Windows behavior remains untested.
- Next recommended step:
  - Проверить глазами новые object silhouettes при zoom `100` и `150`, затем решить, какие placeholder buildings оставить до прихода финального арта.

## 2026-06-24 - Placeholder Art From Local Tilesets

- Branch: `codex/dev-bootstrap-godot`
- Summary: `steam/tilesets/` добавлен в `.gitignore` как локальная сырьевая директория; для companion field demo создан curated placeholder-art набор в `steam/assets/tech_demos/placeholder_art/`, подключены `TX Tileset Ground`, `TX Village Props` и все outlined `MinifolksForestAnimals` species с лёгким движением по таймеру.
- Changed files:
  - `.gitignore`
  - `steam/tilesets/.gdignore`
  - `steam/assets/tech_demos/placeholder_art/README.md`
  - `steam/assets/tech_demos/placeholder_art/tx_tileset_ground.png`
  - `steam/assets/tech_demos/placeholder_art/tx_village_props.png`
  - `steam/assets/tech_demos/placeholder_art/animals/*.png`
  - `steam/scripts/tech_demos/companion_field_demo.gd`
  - `docs/repo/dev/companion-field-tech-demo.md`
  - `docs/repo/status/CODEX_STATUS.md`
- Checks:
  - Passed: `steam/tools/dev-companion-field.sh smoke`
  - Passed: `steam/tools/check-godot.sh`
  - Passed: direct headless override check:
    `Godot --headless --path steam --scene res://scenes/tech_demos/companion_field_demo.tscn -- --demo-auto-quit --demo-zoom=100 --demo-controls-scale=150`
  - Passed: `git diff --check`
  - Passed: visible macOS companion launch and Computer Use visual check: textured ground, placeholder props, and Minifolks animals render in the strip; timer-driven animal movement is visible.
- Assumptions:
  - Placeholder sprites are for development feel only and will be replaced by commissioned Shelter art.
  - Runtime texture loading first uses `ResourceLoader`, then falls back to PNG bytes so raw PNGs work in headless checks even before Godot import metadata exists.
  - `steam/tilesets/.gdignore` is intentionally tracked while the rest of `steam/tilesets/` is ignored, because Git ignore rules do not stop Godot from scanning local raw assets.
  - Placeholder animals use short timer-driven routes and atlas-frame sampling only to make the demo livelier; this is not the final Shelter NPC/animal behavior architecture.
- Blockers:
  - Windows behavior remains untested.
- Next recommended step:
  - Visually tune sprite atlas regions and scale after looking at the live companion strip.

## 2026-06-23 - Move Mode Captures Placement Clicks

- Branch: `codex/dev-bootstrap-godot`
- Summary: Исправлен баг click-through в режиме перемещения: пока здание двигается белым ghost-объектом, главное companion-окно временно ловит всю область окна, чтобы клик по ghost-объекту или выше него не уходил в приложение позади игры.
- Changed files:
  - `steam/scripts/tech_demos/companion_field_demo.gd`
  - `docs/repo/dev/companion-field-tech-demo.md`
  - `docs/repo/status/CODEX_STATUS.md`
- Checks:
  - Passed: `steam/tools/dev-companion-field.sh smoke`
  - Passed: `steam/tools/check-godot.sh`
  - Passed: direct headless override check:
    `Godot --headless --path steam --scene res://scenes/tech_demos/companion_field_demo.tscn -- --demo-auto-quit --demo-zoom=100 --demo-controls-scale=150`
  - Passed: `git diff --check`
  - Passed: Computer Use visual check of live macOS Godot window: click `Ратуша` to enter move mode, then click above the white ghost building; the click is handled by Godot as placement instead of passing through to the app underneath.
- Assumptions:
  - В move mode важнее не потерять placement click, чем сохранять empty-space click-through; после placement/cancel обычный skyline passthrough возвращается.
- Blockers:
  - Windows behavior remains untested.
- Next recommended step:
  - Вручную проверить: войти в move mode, кликнуть по белому ghost-зданию и выше него, убедиться что placement обрабатывается игрой, а не окном снизу.

## 2026-06-23 - Companion Ground Layer And Click-Through Skyline

- Branch: `codex/dev-bootstrap-godot`
- Summary: Уточнена CQ-like модель поля: земля стала постоянным визуальным слоем с травяной кромкой и грунтом, клетки теперь рисуются только как move-mode overlay поверх грунта, click-through empty space включён по умолчанию и строит интерактивный skyline-полигон по земле и зданиям, в Settings добавлена кнопка `Выход`.
- Changed files:
  - `steam/README.md`
  - `steam/scripts/tech_demos/companion_field_demo.gd`
  - `docs/repo/dev/companion-field-tech-demo.md`
  - `docs/repo/status/CODEX_STATUS.md`
- Checks:
  - Passed: `steam/tools/dev-companion-field.sh smoke`
  - Passed: `steam/tools/check-godot.sh`
  - Passed: direct headless override check:
    `Godot --headless --path steam --scene res://scenes/tech_demos/companion_field_demo.tscn -- --demo-auto-quit --demo-zoom=100 --demo-controls-scale=150`
  - Passed: visible macOS companion launch with settings auto-open:
    `Godot --path steam --scene res://scenes/tech_demos/companion_field_demo.tscn --quit-after 4 -- --demo-auto-quit --demo-seconds=0.6 --demo-companion --demo-transparent --demo-open-settings --demo-zoom=100 --demo-controls-scale=150`
  - Passed: `git diff --check`
  - Passed: Computer Use visual check of the live Godot window: move-mode off shows only persistent ground; clicking `Ратуша` opens move-mode overlay on the dirt area without changing the ground layer.
- Observed macOS demo result:
  - Display backend: `macOS`
  - Screen count: `2`
  - Companion window size/position: `(2992, 220)` at `(5120, 3050)`
  - Settings window size/position: `(660, 840)` at `(6286, 1912)`
  - Flags: always-on-top `true`, borderless `true`, transparent `true`
  - Click-through empty space default: `true`
- Assumptions:
  - The current procedural grass/dirt visual is a lightweight placeholder, not the final art direction.
  - Kenney `Pixel Platformer` (`https://kenney.nl/assets/pixel-platformer`) is the current CC0 candidate for a later placeholder-art import, but the full asset pack was not imported in this task.
  - Godot's one-polygon mouse passthrough can approximate CQ-like transparent empty-space clicks for a connected ground/building silhouette, but not exact per-pixel hit testing.
- Blockers:
  - Real click-through focus transfer still needs one more manual confirmation against a visible app underneath after this skyline-polygon change.
  - Windows behavior remains untested.
- Next recommended step:
  - Run `steam/tools/dev-companion-field.sh`, confirm empty transparent clicks with always-on-top on/off, then continue toward the first real tech demo slice: placement UX plus early Shelter-specific object silhouettes.

## 2026-06-23 - Configurable Field Zones And Placement Grid

- Branch: `codex/dev-bootstrap-godot`
- Summary: Добавлена config-driven модель поля для companion field demo: зоны и клетки как в CQ, технические gate-клетки, типы зданий с footprint в клетках, allowed zones, move mode с подсветкой доступных/занятых/валидных footprint-клеток, zone ground colors и player-state unlocked cell counts.
- Changed files:
  - `steam/resources/tech_demos/companion_field_layout.json`
  - `steam/scripts/tech_demos/companion_field_demo.gd`
  - `docs/repo/dev/companion-field-tech-demo.md`
  - `docs/repo/status/CODEX_STATUS.md`
- Checks:
  - Passed: `steam/tools/dev-companion-field.sh smoke`
  - Passed: direct headless override check:
    `Godot --headless --path steam --scene res://scenes/tech_demos/companion_field_demo.tscn -- --demo-auto-quit --demo-zoom=100 --demo-controls-scale=150`
  - Passed: `steam/tools/check-godot.sh`
  - Passed: visible macOS companion demo with settings auto-open argument:
    `Godot --path steam --scene res://scenes/tech_demos/companion_field_demo.tscn --quit-after 4 -- --demo-auto-quit --demo-seconds=0.5 --demo-companion --demo-transparent --demo-open-settings --demo-zoom=100 --demo-controls-scale=150`
  - Passed: `git diff --check`
- Observed demo result:
  - Field cells: `192`
  - Field world width: `6144.0`
  - Current CQ-style split from `player_state.zone_unlocked_cells`: `26 + 3 + 80 + 3 + 80`
  - Visible macOS window size/position: `(2992, 220)` at `(5120, 3050)`
  - Game zoom / controls scale override: `100` / `150`
- Assumptions:
  - `base_cells` and `max_cells` describe design limits; `player_state.zone_unlocked_cells` describes current unlocked land and can later come from real save/player state.
  - Technical cells are represented as non-buildable sandy zones and occupied by fixed gate buildings.
  - Zone ground colors are placeholder colors for readability, not final art.
- Blockers:
  - Move-mode mouse interaction still needs manual visible confirmation: click a movable building, hover over allowed/forbidden/occupied cells, place or cancel with Escape.
  - Windows behavior remains untested.
- Next recommended step:
  - Manually test moving `Ратуша`, `Большой фонтан`, and `Урна` at several zoom levels, then decide whether drag-to-place or click-to-place feels better for the production interaction.

## 2026-06-23 - Full-Width Companion Strip And Screen-Centered Settings

- Branch: `codex/dev-bootstrap-godot`
- Summary: Companion field demo теперь занимает всю usable width выбранного display, а Settings открывается как native scrollable window по центру выбранного display, не внутри нижней полоски.
- Changed files:
  - `steam/scripts/tech_demos/companion_field_demo.gd`
  - `docs/repo/dev/companion-field-tech-demo.md`
  - `docs/repo/status/CODEX_STATUS.md`
- Checks:
  - Passed: `steam/tools/dev-companion-field.sh smoke`
  - Passed: `steam/tools/check-godot.sh`
  - Passed: visible macOS companion demo с settings auto-open argument:
    `Godot --path steam --scene res://scenes/tech_demos/companion_field_demo.tscn --quit-after 4 -- --demo-auto-quit --demo-seconds=0.5 --demo-companion --demo-transparent --demo-open-settings`
  - Passed: `git diff --check`
- Observed macOS demo result:
  - Screen usable rect: `[P: (5120, 1394), S: (2992, 1876)]`
  - Companion window size/position: `(2992, 220)` at `(5120, 3050)`
  - Content scale size: `(2992, 220)`
  - Settings window size/position: `(660, 840)` at `(6286, 1912)`
- Assumptions:
  - Companion mode должен использовать usable width выбранного display без боковых и нижних отступов.
  - Settings должен быть отдельным native window, чтобы жить вне короткой companion-полоски.
- Blockers:
  - Нужна ручная пользовательская проверка, что Settings визуально открывается по центру поверх других приложений на текущем desktop.
  - Windows behavior пока не проверен.
- Next recommended step:
  - Запустить `steam/tools/dev-companion-field.sh` и подтвердить full-width strip плюс centered scrollable Settings на обоих подключенных мониторах.

## 2026-06-23 - Companion UI Scale Steps

- Branch: `codex/dev-bootstrap-godot`
- Summary: Реализованы отдельные ступени game zoom и controls scale для companion field demo: `50`, `100`, `150`, `200`, без режима `Auto`; первый запуск по умолчанию использует game zoom `100` и controls scale `150`.
- Changed files:
  - `steam/scripts/tech_demos/companion_field_demo.gd`
  - `docs/repo/dev/companion-field-tech-demo.md`
  - `docs/repo/dev/ui-scaling-research.md`
  - `docs/repo/status/CODEX_STATUS.md`
- Checks:
  - Passed: `steam/tools/dev-companion-field.sh smoke`
  - Passed: direct headless override check:
    `Godot --headless --path steam --scene res://scenes/tech_demos/companion_field_demo.tscn -- --demo-auto-quit --demo-zoom=50 --demo-controls-scale=200`
  - Passed: `steam/tools/check-godot.sh`
  - Passed: visible macOS companion demo with settings auto-open argument:
    `Godot --path steam --scene res://scenes/tech_demos/companion_field_demo.tscn --quit-after 4 -- --demo-auto-quit --demo-seconds=0.5 --demo-companion --demo-transparent --demo-open-settings`
  - Passed: `git diff --check`
- Observed macOS demo result:
  - Display backend: `macOS`
  - Screen count: `2`
  - Screen index: `0`
  - Screen size: `(2992, 1934)`
  - Screen usable rect: `[P: (5120, 1394), S: (2992, 1876)]`
  - Screen scale/DPI: `2.0` / `220`
  - Window size/position: `(1120, 220)` at `(5152, 3018)`
  - Content scale size: `(1120, 220)`
  - Game zoom / controls scale: `100` / `150`
- Assumptions:
  - Game zoom and controls scale are safe to persist in `user://companion_field_demo.cfg`; click-through test mode is intentionally not persisted.
  - The first demo should use explicit user-selectable scale steps rather than automatic scale selection.
- Blockers:
  - Manual visual confirmation is still needed for the perceived size of controls at `150` on the user's display.
  - Windows DPI behavior remains untested.
- Next recommended step:
  - Run `steam/tools/dev-companion-field.sh` visibly, confirm that Settings and controls are clickable at `150`, then tune the base control sizes or default step if needed.

## 2026-06-23 - UI Scaling Research

- Branch: `codex/dev-bootstrap-godot`
- Summary: Изучено, как UI scaling обычно решается в Godot, Unity, Unreal и GameMaker; добавлена Shelter-специфичная рекомендация для desktop companion-окна.
- Changed files:
  - `docs/repo/dev/ui-scaling-research.md`
  - `docs/repo/status/CODEX_STATUS.md`
- Checks:
  - Passed: `git diff --check`
- Assumptions:
  - Текущая проблема микроскопического UI связана и с hiDPI/large-screen контекстом, и с несовпадением project viewport base (`960x540`) и размера companion-полоски (`1120x220`).
  - Первая реализация должна быть настраиваемой scale curve для tech demo, а не финальной продуктовой политикой.
- Blockers:
  - Windows DPI behavior пока не проверен.
- Next recommended step:
  - Реализовать adaptive companion UI scaling в `steam/scripts/tech_demos/companion_field_demo.gd`: читать display metrics на старте, явно задавать runtime content scale, масштабировать Control UI отдельно от game zoom и добавить UI scale override в Settings.

## 2026-06-23 - Unified Companion Demo Launch

- Branch: `codex/dev-bootstrap-godot`
- Summary: Made `steam/tools/dev-companion-field.sh` the single default manual launch for checking the companion field, settings, display selection, transparency, click-through test mode, zoom, and pan in one session.
- Changed files:
  - `steam/README.md`
  - `steam/tools/dev-companion-field.sh`
  - `steam/scripts/tech_demos/companion_field_demo.gd`
  - `docs/repo/dev/companion-field-tech-demo.md`
  - `docs/repo/status/CODEX_STATUS.md`
- Checks:
  - Passed: `steam/tools/dev-companion-field.sh smoke`
  - Passed: `steam/tools/check-godot.sh`
  - Passed: visible macOS companion demo with settings auto-open argument:
    `Godot --path steam --scene res://scenes/tech_demos/companion_field_demo.tscn --quit-after 4 -- --demo-auto-quit --demo-seconds=0.3 --demo-companion --demo-transparent --demo-open-settings`
  - Passed: `git diff --check`
- Observed macOS demo result:
  - Display backend: `macOS`
  - Screen count: `2`
  - Screen index: `0`
  - Window size/position: `(1120, 220)` at `(5152, 3018)`
  - Applied flags: always-on-top `true`, borderless `true`, transparent `true`
- Assumptions:
  - The default launch should optimize for a human tester, while named presets remain available for narrower diagnostics.
- Blockers:
  - Real click-through behavior still needs manual confirmation against an app underneath the transparent areas.
- Next recommended step:
  - Run `steam/tools/dev-companion-field.sh`, test zoom/pan/object clicks/click-through/display placement in one session, then decide whether the window behavior is good enough for the next gameplay slice.

## 2026-06-23 - Companion Field Tech Demo

- Branch: `codex/dev-bootstrap-godot`
- Summary: Added the first Godot companion field tech demo with placeholder objects, discrete zoom, pan, object selection, settings window, display placement, and click-through test mode.
- Changed files:
  - `steam/README.md`
  - `steam/tools/check-godot.sh`
  - `steam/tools/dev-companion-field.sh`
  - `steam/scenes/tech_demos/companion_field_demo.tscn`
  - `steam/scripts/tech_demos/companion_field_demo.gd`
  - `steam/scripts/tech_demos/companion_field_demo.gd.uid`
  - `docs/repo/dev/companion-field-tech-demo.md`
  - `docs/repo/status/CODEX_STATUS.md`
- Checks:
  - Passed: `"$GODOT_BIN" --headless --path steam --check-only --script res://scripts/tech_demos/companion_field_demo.gd`
  - Passed: `steam/tools/dev-companion-field.sh smoke`
  - Passed: `steam/tools/check-godot.sh`
  - Passed: visible macOS companion demo with auto-quit:
    `Godot --path steam --scene res://scenes/tech_demos/companion_field_demo.tscn --quit-after 4 -- --demo-auto-quit --demo-seconds=0.6 --demo-companion --demo-transparent`
- Observed macOS demo result:
  - Display backend: `macOS`
  - Rendering backend: Metal 4.0 Forward+
  - Screen count: `2`
  - Screen index: `0`
  - Screen usable rect: `[P: (5120, 1394), S: (2992, 1876)]`
  - Window size/position: `(1120, 220)` at `(5152, 3018)`
  - Applied flags: always-on-top `true`, borderless `true`, transparent `true`
- Assumptions:
  - This is a technical demo, not final gameplay, art direction, economy, or charity flow.
  - Godot's single mouse-passthrough polygon is enough for a first click-through feasibility test, but not enough to prove production-grade disjoint clickable object islands.
- Blockers:
  - Manual visible macOS testing is still required for real click-through, system panel/menu bar behavior, always-on-top stacking, focus transfer, and multi-monitor placement.
  - Windows behavior remains untested.
- Next recommended step:
  - Run `steam/tools/dev-companion-field.sh companion` and `steam/tools/dev-companion-field.sh click-through` visibly on the two-monitor macOS setup, record results, then decide whether click-through needs native code or a different window strategy.

## 2026-06-23 - Repo-Local CQ Reference Skill

- Branch: `codex/dev-bootstrap-godot`
- Summary: Added a repo-local `cq-hero-town-reference` skill and captured current CQ Hero Town input/window findings for Shelter desktop reference work.
- Changed files:
  - `steam/.agents/skills/cq-hero-town-reference/SKILL.md`
  - `steam/.agents/skills/cq-hero-town-reference/agents/openai.yaml`
  - `steam/.agents/skills/cq-hero-town-reference/references/buildings.md`
  - `steam/.agents/skills/cq-hero-town-reference/references/controls.md`
  - `steam/.agents/skills/cq-hero-town-reference/references/window-behavior.md`
  - `steam/README.md`
  - `docs/repo/dev/companion-field-tech-demo.md`
  - `docs/repo/dev/desktop-window-spike.md`
  - `docs/repo/status/CODEX_STATUS.md`
- Checks:
  - Passed: `python3 /Users/barsulka/.codex/skills/.system/skill-creator/scripts/quick_validate.py steam/.agents/skills/cq-hero-town-reference`
- Assumptions:
  - CQ reference knowledge should live in this repository because it directly informs Shelter Steam/Desktop window, input, and companion-field behavior.
  - The personal copy in `~/.codex/skills` may still exist, but the repository copy is now the project source of truth.
- Blockers:
  - Mouse-drag panning in CQ still needs a clean confirmed pass.
  - Windows behavior remains untested.
- Next recommended step:
  - Start `docs/repo/dev/companion-field-tech-demo.md`: a small Godot tech demo with field pan/zoom, placeholder objects, click-through testing, multi-monitor placement, and a minimal settings window.

## 2026-06-22 - Russian-Only Communication Rule

- Branch: `codex/dev-bootstrap-godot`
- Summary: Added an explicit `steam/AGENTS.md` instruction that all communication must be strictly in Russian.
- Changed files:
  - `steam/AGENTS.md`
  - `docs/repo/status/CODEX_STATUS.md`
- Checks:
  - Passed: `git diff --check`
- Assumptions:
  - The rule applies to assistant/user-facing communication in this repository context.
- Blockers:
  - None.
- Next recommended step:
  - Continue using Russian-only communication in all future Shelter Steam/Desktop work.

## 2026-06-22 - Desktop Window Spike Probe

- Branch: `codex/dev-bootstrap-godot`
- Summary: Added a Godot runtime probe for desktop window behavior: always-on-top, borderless mode, transparency flags, mouse passthrough modes, screen metrics, and native window handles.
- Changed files:
  - `steam/README.md`
  - `steam/project.godot`
  - `steam/tools/check-godot.sh`
  - `steam/tools/dev-window-spike.sh`
  - `steam/scenes/spikes/desktop_window_probe.tscn`
  - `steam/scripts/spikes/desktop_window_probe.gd`
  - `steam/scripts/spikes/desktop_window_probe.gd.uid`
  - `docs/repo/dev/desktop-window-spike.md`
  - `docs/repo/status/CODEX_STATUS.md`
- Checks:
  - Passed: `steam/tools/check-godot.sh`
  - Passed: `steam/tools/dev-window-spike.sh smoke`
  - Passed: visible macOS companion probe with auto-quit:
    `Godot --path steam --scene res://scenes/spikes/desktop_window_probe.tscn --quit-after 4 -- --spike-auto-quit --spike-seconds=0.5 --spike-companion --spike-borderless --spike-interactive-polygon`
- Observed macOS probe result:
  - Display backend: `macOS`
  - Rendering backend: Metal 4.0 Forward+
  - Window transparency feature/availability: `true` / `true`
  - Applied flags: always-on-top `true`, borderless `true`, transparent `true`
  - Interactive polygon requested: `true`, 4 points
  - Window size/position: `(960, 160)` at `(48, 2010)`
  - Screen metrics: scale `2.0`, DPI `255`, refresh `120.0`
- Assumptions:
  - The probe may enable project-level transparent-window settings, while the normal main scene remains visually opaque.
  - The probe is development-only and is not a commitment to final companion-window behavior.
  - Headless checks validate API/script compatibility but not macOS compositor behavior.
- Blockers:
  - Windows behavior is not validated yet.
  - Real click-through, always-on-top stacking, and battery profile still require manual visible testing.
- Next recommended step:
  - Run `steam/tools/dev-window-spike.sh companion` manually beside other apps and record the observed transparency/focus/click-through behavior.

## 2026-06-22 - Godot Dev Bootstrap

- Branch: `codex/dev-bootstrap-godot`
- Summary: Created the initial Godot 4.x project skeleton for Shelter Steam/Desktop and mirrored the accepted Godot decision into local repo docs.
- Changed files:
  - `.editorconfig`
  - `.gitignore`
  - `steam/README.md`
  - `steam/project.godot`
  - `steam/scenes/main.tscn`
  - `steam/scripts/main.gd`
  - `steam/scripts/main.gd.uid`
  - `steam/tools/check-godot.sh`
  - `docs/repo/adr/0001-use-godot-for-steam-desktop.md`
  - `docs/repo/dev/godot-setup.md`
  - `docs/repo/dev/desktop-window-spike.md`
  - `docs/repo/status/CODEX_STATUS.md`
- Checks:
  - Passed: `steam/tools/check-godot.sh`
  - Passed: `git status --short --branch`
- Assumptions:
  - The Steam/Desktop repo root is the Godot project root.
  - Godot from Steam is the local editor binary for now.
  - No gameplay, art direction, charity flow, Steamworks, export presets, or native window APIs are part of this bootstrap.
- Blockers:
  - None known at bootstrap time.
- Next recommended step:
  - Run the desktop window spike for transparency, always-on-top behavior, click-through feasibility, UI hiding, and idle performance.
