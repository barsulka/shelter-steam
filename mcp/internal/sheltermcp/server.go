package sheltermcp

import (
	"github.com/modelcontextprotocol/go-sdk/mcp"
)

func NewServer(cfg Config) *mcp.Server {
	server := mcp.NewServer(&mcp.Implementation{
		Name:    serverName,
		Version: serverVersion,
	}, &mcp.ServerOptions{
		Instructions: "Expose only whitelisted Shelter Steam/Desktop local development tools. Do not use it as a generic shell.",
	})

	app := &App{cfg: cfg}
	mcp.AddTool(server, &mcp.Tool{
		Name:        "list_shelter_dev_commands",
		Description: "List the whitelisted Shelter dev commands and runtime-control actions exposed by this MCP server.",
		Annotations: readOnlyAnnotations(),
	}, app.ListDevCommands)
	mcp.AddTool(server, &mcp.Tool{
		Name:        "run_shelter_dev_command",
		Description: "Run one whitelisted Shelter Steam/Desktop dev command. This is not a generic shell.",
		Annotations: stateChangingAnnotations(true),
	}, app.RunDevCommand)
	mcp.AddTool(server, &mcp.Tool{
		Name:        "list_workbench_runs",
		Description: "List local Shelter workbench capture bundles under steam/.runtime/workbench_capture_runs.",
		Annotations: readOnlyAnnotations(),
	}, app.ListWorkbenchRuns)
	mcp.AddTool(server, &mcp.Tool{
		Name:        "get_workbench_run_artifacts",
		Description: "Return selected text artifacts from a local Shelter workbench capture bundle.",
		Annotations: readOnlyAnnotations(),
	}, app.GetWorkbenchRunArtifacts)
	mcp.AddTool(server, &mcp.Tool{
		Name:        "clear_workbench_runs",
		Description: "Delete selected local workbench capture bundles. Requires confirm=true unless dry_run=true.",
		Annotations: stateChangingAnnotations(true),
	}, app.ClearWorkbenchRuns)
	mcp.AddTool(server, &mcp.Tool{
		Name:        "start_shelter_control_connector",
		Description: "Start the Shelter Vertical Slice local connector/control runtime as a managed background process.",
		Annotations: stateChangingAnnotations(false),
	}, app.StartControlConnector)
	mcp.AddTool(server, &mcp.Tool{
		Name:        "stop_shelter_control_connector",
		Description: "Stop a Shelter control connector started by this MCP server.",
		Annotations: stateChangingAnnotations(true),
	}, app.StopControlConnector)
	mcp.AddTool(server, &mcp.Tool{
		Name:        "control_shelter_game",
		Description: "Call a whitelisted local Shelter Godot State Connector HTTP action.",
		Annotations: stateChangingAnnotations(false),
	}, app.ControlShelterGame)
	mcp.AddTool(server, &mcp.Tool{
		Name:        "git_status",
		Description: "Show concise git working-tree state for the Shelter monorepo.",
		Annotations: readOnlyAnnotations(),
	}, app.GitStatus)
	mcp.AddTool(server, &mcp.Tool{
		Name:        "git_diff",
		Description: "Return a bounded git diff for safe relative paths in the Shelter monorepo; use paths under mcp/ for MCP-only scope.",
		Annotations: readOnlyAnnotations(),
	}, app.GitDiff)
	mcp.AddTool(server, &mcp.Tool{
		Name:        "git_diff_for_review",
		Description: "Return changed files, bounded diff, and simple risk flags for review.",
		Annotations: readOnlyAnnotations(),
	}, app.GitDiffForReview)
	mcp.AddTool(server, &mcp.Tool{
		Name:        "apply_patch",
		Description: "Check or apply a unified diff patch inside an allowed repo root. Dry-run defaults to true.",
		Annotations: stateChangingAnnotations(true),
	}, app.ApplyPatch)
	mcp.AddTool(server, &mcp.Tool{
		Name:        "insert_section_after_heading",
		Description: "Insert markdown after a unique heading section in a repo markdown file. Dry-run defaults to true.",
		Annotations: stateChangingAnnotations(true),
	}, app.InsertSectionAfterHeading)
	mcp.AddTool(server, &mcp.Tool{
		Name:        "replace_section",
		Description: "Replace a unique markdown heading section in a repo markdown file. Dry-run defaults to true.",
		Annotations: stateChangingAnnotations(true),
	}, app.ReplaceSection)
	mcp.AddTool(server, &mcp.Tool{
		Name:        "append_changelog_entry",
		Description: "Append a new first entry under a markdown Changelog heading. Dry-run defaults to true.",
		Annotations: stateChangingAnnotations(true),
	}, app.AppendChangelogEntry)
	mcp.AddTool(server, &mcp.Tool{
		Name:        "replace_between_markers",
		Description: "Replace markdown content between unique start/end marker lines while preserving the markers. Dry-run defaults to true.",
		Annotations: stateChangingAnnotations(true),
	}, app.ReplaceBetweenMarkers)
	mcp.AddTool(server, &mcp.Tool{
		Name:        "read_shelter_bootstrap_context",
		Description: "Read a bounded deterministic Shelter context bundle from fixed local docs for a role and area.",
		Annotations: readOnlyAnnotations(),
	}, app.ReadShelterBootstrapContext)
	mcp.AddTool(server, &mcp.Tool{
		Name:        "find_current_context",
		Description: "Return deterministic current-context and task-knowledge document paths for a Shelter area.",
		Annotations: readOnlyAnnotations(),
	}, app.FindCurrentContext)
	mcp.AddTool(server, &mcp.Tool{
		Name:        "list_decisions",
		Description: "List accepted Shelter decisions for an area and kind from a deterministic static catalog.",
		Annotations: readOnlyAnnotations(),
	}, app.ListDecisions)
	mcp.AddTool(server, &mcp.Tool{
		Name:        "decision_digest",
		Description: "Return compact accepted decision summaries for a Shelter area from a deterministic static catalog.",
		Annotations: readOnlyAnnotations(),
	}, app.DecisionDigest)
	mcp.AddTool(server, &mcp.Tool{
		Name:        "get_decision",
		Description: "Return one accepted Shelter decision by id from a deterministic static catalog.",
		Annotations: readOnlyAnnotations(),
	}, app.GetDecision)
	mcp.AddTool(server, &mcp.Tool{
		Name:        "list_open_questions",
		Description: "List current Shelter open questions for an area and status from a deterministic static catalog.",
		Annotations: readOnlyAnnotations(),
	}, app.ListOpenQuestions)
	mcp.AddTool(server, &mcp.Tool{
		Name:        "open_questions_digest",
		Description: "Return compact open-question summaries for a Shelter area and status from a deterministic static catalog.",
		Annotations: readOnlyAnnotations(),
	}, app.OpenQuestionsDigest)
	mcp.AddTool(server, &mcp.Tool{
		Name:        "list_roadmaps",
		Description: "List known Shelter roadmap docs, status, phase, owner, and next step from a deterministic static catalog.",
		Annotations: readOnlyAnnotations(),
	}, app.ListRoadmaps)
	mcp.AddTool(server, &mcp.Tool{
		Name:        "latest_handoff",
		Description: "Return the latest known relevant Shelter handoff for a role and area from a bounded static catalog.",
		Annotations: readOnlyAnnotations(),
	}, app.LatestHandoff)
	mcp.AddTool(server, &mcp.Tool{
		Name:        "knowledge_task_context",
		Description: "Return deterministic Shelter docs to read for a role, area, and task in reading order.",
		Annotations: readOnlyAnnotations(),
	}, app.KnowledgeTaskContext)
	mcp.AddTool(server, &mcp.Tool{
		Name:        "shelter_status",
		Description: "Return a compact deterministic Shelter project or area dashboard for fresh-session entry.",
		Annotations: readOnlyAnnotations(),
	}, app.ShelterStatus)
	mcp.AddTool(server, &mcp.Tool{
		Name:        "current_entry_digest",
		Description: "Return minimal fresh-session entry docs for a Shelter role and area without reading file contents.",
		Annotations: readOnlyAnnotations(),
	}, app.CurrentEntryDigest)
	mcp.AddTool(server, &mcp.Tool{
		Name:        "list_active_docs",
		Description: "List active/current/relevant Shelter docs for an area and documentation layer without reading file contents.",
		Annotations: readOnlyAnnotations(),
	}, app.ListActiveDocs)
	mcp.AddTool(server, &mcp.Tool{
		Name:        "classify_doc_path",
		Description: "Classify one Shelter documentation path as Current Memory, Knowledge, History, or unknown using static rules.",
		Annotations: readOnlyAnnotations(),
	}, app.ClassifyDocPath)
	mcp.AddTool(server, &mcp.Tool{
		Name:        "explain_superseded",
		Description: "Explain whether a Shelter documentation path is superseded, evidence, archive, history, or unknown.",
		Annotations: readOnlyAnnotations(),
	}, app.ExplainSuperseded)
	mcp.AddTool(server, &mcp.Tool{
		Name:        "knowledge_gc_report",
		Description: "Generate a deterministic read-only PM cleanup report from static catalog and bounded local docs path rules.",
		Annotations: readOnlyAnnotations(),
	}, app.KnowledgeGCReport)
	mcp.AddTool(server, &mcp.Tool{
		Name:        "write_file_if_unchanged",
		Description: "Write a repo file only when its current sha256 matches the expected hash. Dry-run defaults to true.",
		Annotations: stateChangingAnnotations(true),
	}, app.WriteFileIfUnchanged)

	return server
}

type App struct {
	cfg Config
}

func readOnlyAnnotations() *mcp.ToolAnnotations {
	destructive := false
	openWorld := false
	return &mcp.ToolAnnotations{
		ReadOnlyHint:    true,
		DestructiveHint: &destructive,
		IdempotentHint:  true,
		OpenWorldHint:   &openWorld,
	}
}

func stateChangingAnnotations(destructive bool) *mcp.ToolAnnotations {
	openWorld := false
	return &mcp.ToolAnnotations{
		ReadOnlyHint:    false,
		DestructiveHint: &destructive,
		IdempotentHint:  false,
		OpenWorldHint:   &openWorld,
	}
}
