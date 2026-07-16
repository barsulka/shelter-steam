package sheltermcp

import (
	"context"
	"encoding/json"
	"os"
	"path/filepath"
	"strings"
	"testing"
	"time"

	"github.com/modelcontextprotocol/go-sdk/mcp"
)

func TestServerListsExpectedTools(t *testing.T) {
	root := t.TempDir()
	cfg := Config{
		SteamRoot:       root,
		RepoRoot:        filepath.Dir(root),
		DevScript:       filepath.Join(root, "tools", "dev-vertical-slice.sh"),
		LaunchScript:    filepath.Join(root, "launch.sh"),
		WorkbenchRoot:   filepath.Join(root, ".runtime", "workbench_capture_runs"),
		MCPRuntimeRoot:  filepath.Join(root, ".runtime", "shelter_mcp"),
		DefaultPort:     8765,
		DefaultBaseURL:  "http://127.0.0.1:8765",
		DefaultTimeout:  1,
		MaxTimeout:      1,
		MaxArtifactSize: 1024,
	}

	ctx := context.Background()
	clientTransport, serverTransport := mcp.NewInMemoryTransports()
	server := NewServer(cfg)
	serverSession, err := server.Connect(ctx, serverTransport, nil)
	if err != nil {
		t.Fatal(err)
	}
	defer serverSession.Close()

	client := mcp.NewClient(&mcp.Implementation{Name: "test-client", Version: "test"}, nil)
	clientSession, err := client.Connect(ctx, clientTransport, nil)
	if err != nil {
		t.Fatal(err)
	}
	defer clientSession.Close()

	result, err := clientSession.ListTools(ctx, nil)
	if err != nil {
		t.Fatal(err)
	}
	tools := map[string]*mcp.Tool{}
	for _, tool := range result.Tools {
		tools[tool.Name] = tool
	}
	for _, name := range []string{
		"list_shelter_dev_commands",
		"run_shelter_dev_command",
		"list_workbench_runs",
		"clear_workbench_runs",
		"control_shelter_game",
		"start_shelter_control_connector",
		"stop_shelter_control_connector",
		"get_workbench_run_artifacts",
		"git_status",
		"git_diff",
		"git_diff_for_review",
		"apply_patch",
		"insert_section_after_heading",
		"replace_section",
		"append_changelog_entry",
		"replace_between_markers",
		"read_shelter_bootstrap_context",
		"shelter_context_bundle",
		"find_current_context",
		"list_active_docs",
		"classify_doc_path",
		"explain_superseded",
		"knowledge_gc_report",
		"write_file_if_unchanged",
	} {
		tool := tools[name]
		if tool == nil {
			t.Fatalf("tool %q was not listed", name)
		}
		assertObjectSchema(t, name, "output", tool.OutputSchema)
	}
	contextSchema, err := json.Marshal(tools["shelter_context_bundle"].InputSchema)
	if err != nil {
		t.Fatal(err)
	}
	var decodedContextSchema struct {
		Properties map[string]struct {
			Minimum float64 `json:"minimum"`
		} `json:"properties"`
	}
	if err := json.Unmarshal(contextSchema, &decodedContextSchema); err != nil {
		t.Fatal(err)
	}
	if decodedContextSchema.Properties["max_bytes"].Minimum != minimumContextBundleBytes {
		t.Fatalf("shelter_context_bundle schema must publish max_bytes minimum=%d: %s", minimumContextBundleBytes, contextSchema)
	}
	for _, name := range []string{
		"list_shelter_dev_commands",
		"list_workbench_runs",
		"get_workbench_run_artifacts",
		"git_status",
		"git_diff",
		"git_diff_for_review",
		"read_shelter_bootstrap_context",
		"shelter_context_bundle",
		"find_current_context",
		"list_decisions",
		"decision_digest",
		"get_decision",
		"list_open_questions",
		"open_questions_digest",
		"list_roadmaps",
		"latest_handoff",
		"knowledge_task_context",
		"shelter_status",
		"current_entry_digest",
		"list_active_docs",
		"classify_doc_path",
		"explain_superseded",
		"knowledge_gc_report",
	} {
		tool := tools[name]
		if tool == nil || tool.Annotations == nil || !tool.Annotations.ReadOnlyHint {
			t.Fatalf("read-only tool %q must advertise readOnlyHint", name)
		}
		if tool.Annotations.DestructiveHint == nil || *tool.Annotations.DestructiveHint {
			t.Fatalf("read-only tool %q must advertise destructiveHint=false", name)
		}
	}
	for _, name := range []string{
		"run_shelter_dev_command",
		"clear_workbench_runs",
		"start_shelter_control_connector",
		"stop_shelter_control_connector",
		"control_shelter_game",
		"apply_patch",
		"insert_section_after_heading",
		"replace_section",
		"append_changelog_entry",
		"replace_between_markers",
		"write_file_if_unchanged",
	} {
		tool := tools[name]
		if tool == nil || tool.Annotations == nil || tool.Annotations.ReadOnlyHint {
			t.Fatalf("state-changing tool %q must advertise readOnlyHint=false", name)
		}
	}

	call, err := clientSession.CallTool(ctx, &mcp.CallToolParams{
		Name:      "list_shelter_dev_commands",
		Arguments: map[string]any{},
	})
	if err != nil {
		t.Fatal(err)
	}
	if call.IsError {
		t.Fatalf("list_shelter_dev_commands returned tool error")
	}
	if call.StructuredContent == nil {
		t.Fatalf("list_shelter_dev_commands did not return structured content")
	}
	text := call.Content[0].(*mcp.TextContent).Text
	for _, want := range []string{
		"workbench_capture",
		"first_delivery_with_dispatch_confirmation",
		"runtime_state_import",
		"runtime_delivery_confirm",
		"/control/runtime/delivery/confirm",
	} {
		if !strings.Contains(text, want) {
			t.Fatalf("command listing did not include %q: %s", want, text)
		}
	}
}

func TestKnowledgeFailureIsCapabilityLocal(t *testing.T) {
	root := t.TempDir()
	cfg := Config{SteamRoot: root, RepoRoot: root, DevScript: filepath.Join(root, "dev.sh"), LaunchScript: filepath.Join(root, "launch.sh"), WorkbenchRoot: filepath.Join(root, "workbench"), MCPRuntimeRoot: filepath.Join(root, "runtime"), DefaultPort: 8765, DefaultBaseURL: "http://127.0.0.1:8765", DefaultTimeout: time.Second, MaxTimeout: time.Second, MaxArtifactSize: 1024}
	ctx := context.Background()
	clientTransport, serverTransport := mcp.NewInMemoryTransports()
	serverSession, err := NewServer(cfg).Connect(ctx, serverTransport, nil)
	if err != nil {
		t.Fatal(err)
	}
	defer serverSession.Close()
	clientSession, err := mcp.NewClient(&mcp.Implementation{Name: "test-client", Version: "test"}, nil).Connect(ctx, clientTransport, nil)
	if err != nil {
		t.Fatal(err)
	}
	defer clientSession.Close()

	listed, err := clientSession.ListTools(ctx, nil)
	if err != nil {
		t.Fatal(err)
	}
	names := map[string]bool{}
	for _, tool := range listed.Tools {
		names[tool.Name] = true
	}
	for _, name := range []string{"shelter_context_bundle", "list_shelter_dev_commands", "list_workbench_runs", "control_shelter_game"} {
		if !names[name] {
			t.Fatalf("knowledge failure must not prevent registration of %s", name)
		}
	}
	failed, err := clientSession.CallTool(ctx, &mcp.CallToolParams{Name: "shelter_context_bundle", Arguments: map[string]any{"role": "codex", "area": "mcp"}})
	if err != nil {
		t.Fatal(err)
	}
	if !failed.IsError || !strings.Contains(failed.Content[0].(*mcp.TextContent).Text, "health=error") {
		t.Fatalf("expected explicit knowledge error, got %+v", failed)
	}
	runtimeList, err := clientSession.CallTool(ctx, &mcp.CallToolParams{Name: "list_shelter_dev_commands", Arguments: map[string]any{}})
	if err != nil {
		t.Fatal(err)
	}
	if runtimeList.IsError || runtimeList.StructuredContent == nil {
		t.Fatalf("runtime capability failed after knowledge error: %+v", runtimeList)
	}
}

func TestContextBundleWireRejectsUnderMinimumBudget(t *testing.T) {
	ctx := context.Background()
	clientTransport, serverTransport := mcp.NewInMemoryTransports()
	serverSession, err := NewServer(testServerConfig(repositoryRootForKnowledgeTest(t))).Connect(ctx, serverTransport, nil)
	if err != nil {
		t.Fatal(err)
	}
	defer serverSession.Close()
	clientSession, err := mcp.NewClient(&mcp.Implementation{Name: "test-client", Version: "test"}, nil).Connect(ctx, clientTransport, nil)
	if err != nil {
		t.Fatal(err)
	}
	defer clientSession.Close()

	for _, test := range []struct {
		name     string
		maxBytes int
	}{{name: "one", maxBytes: 1}, {name: "below_minimum", maxBytes: minimumContextBundleBytes - 1}} {
		t.Run(test.name, func(t *testing.T) {
			maxBytes := test.maxBytes
			result, callErr := clientSession.CallTool(ctx, &mcp.CallToolParams{
				Name:      "shelter_context_bundle",
				Arguments: map[string]any{"role": "codex", "area": "mcp", "max_bytes": maxBytes},
			})
			if callErr != nil {
				t.Fatal(callErr)
			}
			if !result.IsError || result.StructuredContent != nil {
				t.Fatalf("max_bytes=%d must be an argument error without structured content: %+v", maxBytes, result)
			}
			if len(result.Content) == 0 || !strings.Contains(result.Content[0].(*mcp.TextContent).Text, "minimum") {
				t.Fatalf("max_bytes=%d error must explain the schema minimum: %+v", maxBytes, result.Content)
			}
		})
	}
}

func TestContextBundleWireBoundsKnowledgeErrorEnvelope(t *testing.T) {
	ctx := context.Background()
	clientTransport, serverTransport := mcp.NewInMemoryTransports()
	serverSession, err := NewServer(testServerConfig(malformedKnowledgeRepo(t))).Connect(ctx, serverTransport, nil)
	if err != nil {
		t.Fatal(err)
	}
	defer serverSession.Close()
	clientSession, err := mcp.NewClient(&mcp.Implementation{Name: "test-client", Version: "test"}, nil).Connect(ctx, clientTransport, nil)
	if err != nil {
		t.Fatal(err)
	}
	defer clientSession.Close()

	for _, test := range []struct {
		name      string
		arguments map[string]any
		requested int
	}{
		{name: "default", arguments: map[string]any{"role": "codex", "area": "mcp"}, requested: defaultContextBundleBytes},
		{name: "minimum", arguments: map[string]any{"role": "codex", "area": "mcp", "max_bytes": minimumContextBundleBytes}, requested: minimumContextBundleBytes},
	} {
		t.Run(test.name, func(t *testing.T) {
			var previous string
			for attempt := 0; attempt < 2; attempt++ {
				result, callErr := clientSession.CallTool(ctx, &mcp.CallToolParams{Name: "shelter_context_bundle", Arguments: test.arguments})
				if callErr != nil {
					t.Fatal(callErr)
				}
				if !result.IsError || result.StructuredContent == nil {
					t.Fatalf("knowledge failure must return an explicit structured error envelope: %+v", result)
				}
				encoded, marshalErr := json.Marshal(result.StructuredContent)
				if marshalErr != nil {
					t.Fatal(marshalErr)
				}
				var bundle ContextBundleOutput
				if unmarshalErr := json.Unmarshal(encoded, &bundle); unmarshalErr != nil {
					t.Fatal(unmarshalErr)
				}
				if bundle.Health != "error" || len(bundle.Errors) == 0 || !strings.Contains(bundle.Errors[0], "malformed decision document") || len(bundle.Budget.Omitted) != 0 {
					t.Fatalf("malformed-source error must be explicit and must not silently omit data: %+v", bundle)
				}
				if bundle.Budget.RequestedBytes != test.requested || bundle.Budget.EncodedBytes != len(encoded) || len(encoded) > test.requested || len(encoded) > hardContextBundleBytes {
					t.Fatalf("wire error budget mismatch: budget=%+v actual=%d", bundle.Budget, len(encoded))
				}
				if previous != "" && previous != string(encoded) {
					t.Fatalf("same malformed source and input must produce an identical wire envelope\nfirst:  %s\nsecond: %s", previous, encoded)
				}
				previous = string(encoded)
			}
		})
	}
}

func malformedKnowledgeRepo(t *testing.T) string {
	t.Helper()
	sourceRoot := repositoryRootForKnowledgeTest(t)
	root := t.TempDir()
	for _, path := range requiredKnowledgeSourcePaths() {
		data, err := os.ReadFile(filepath.Join(sourceRoot, filepath.FromSlash(path)))
		if err != nil {
			t.Fatal(err)
		}
		if path == docDecisions {
			data = []byte("# Decisions\n\nmalformed canonical fixture\n")
		}
		target := filepath.Join(root, filepath.FromSlash(path))
		if err := os.MkdirAll(filepath.Dir(target), 0o755); err != nil {
			t.Fatal(err)
		}
		if err := os.WriteFile(target, data, 0o600); err != nil {
			t.Fatal(err)
		}
	}
	return root
}

func testServerConfig(repoRoot string) Config {
	steamRoot := filepath.Join(repoRoot, "steam")
	return Config{
		SteamRoot: steamRoot, RepoRoot: repoRoot,
		DevScript: filepath.Join(steamRoot, "tools", "dev-vertical-slice.sh"), LaunchScript: filepath.Join(steamRoot, "launch.sh"),
		WorkbenchRoot: filepath.Join(steamRoot, ".runtime", "workbench_capture_runs"), MCPRuntimeRoot: filepath.Join(steamRoot, ".runtime", "shelter_mcp"),
		DefaultPort: 8765, DefaultBaseURL: "http://127.0.0.1:8765", DefaultTimeout: time.Second, MaxTimeout: time.Second, MaxArtifactSize: 1024,
	}
}

func TestRunWorkbenchCaptureAcceptsDispatchScenarioThroughMCP(t *testing.T) {
	root := t.TempDir()
	toolsDir := filepath.Join(root, "tools")
	if err := os.MkdirAll(toolsDir, 0755); err != nil {
		t.Fatal(err)
	}
	devScript := filepath.Join(toolsDir, "dev-vertical-slice.sh")
	script := `#!/bin/sh
set -eu
scenario=""
fixture=""
game_seconds=""
sample_every=""
speed=""
output_dir=""
for arg in "$@"; do
  case "$arg" in
    --scenario=*) scenario="${arg#--scenario=}" ;;
    --fixture=*) fixture="${arg#--fixture=}" ;;
    --game-seconds=*) game_seconds="${arg#--game-seconds=}" ;;
    --sample-every-game-seconds=*) sample_every="${arg#--sample-every-game-seconds=}" ;;
    --speed=*) speed="${arg#--speed=}" ;;
    --output-dir=*) output_dir="${arg#--output-dir=}" ;;
  esac
done
mkdir -p "$output_dir"
printf '{"scenario_id":"%s","fixture_id":"%s","requested_game_seconds":%s,"sample_every_game_seconds":%s,"speed_multiplier":%s,"dispatch_confirmation_proof":{"order.delivery_confirmed":true}}\n' \
  "$scenario" "$fixture" "$game_seconds" "$sample_every" "$speed" > "$output_dir/manifest.json"
printf '{"ok":true}\n' > "$output_dir/final_state.json"
printf 'ok\n' > "$output_dir/run.log"
printf 'workbench-capture output: %s\n' "$output_dir"
`
	if err := os.WriteFile(devScript, []byte(script), 0755); err != nil {
		t.Fatal(err)
	}

	cfg := Config{
		SteamRoot:       root,
		RepoRoot:        filepath.Dir(root),
		DevScript:       devScript,
		LaunchScript:    filepath.Join(root, "launch.sh"),
		WorkbenchRoot:   filepath.Join(root, ".runtime", "workbench_capture_runs"),
		MCPRuntimeRoot:  filepath.Join(root, ".runtime", "shelter_mcp"),
		DefaultPort:     8765,
		DefaultBaseURL:  "http://127.0.0.1:8765",
		DefaultTimeout:  5 * time.Second,
		MaxTimeout:      5 * time.Second,
		MaxArtifactSize: 1024,
	}

	ctx := context.Background()
	clientTransport, serverTransport := mcp.NewInMemoryTransports()
	server := NewServer(cfg)
	serverSession, err := server.Connect(ctx, serverTransport, nil)
	if err != nil {
		t.Fatal(err)
	}
	defer serverSession.Close()

	client := mcp.NewClient(&mcp.Implementation{Name: "test-client", Version: "test"}, nil)
	clientSession, err := client.Connect(ctx, clientTransport, nil)
	if err != nil {
		t.Fatal(err)
	}
	defer clientSession.Close()

	call, err := clientSession.CallTool(ctx, &mcp.CallToolParams{
		Name: "run_shelter_dev_command",
		Arguments: map[string]any{
			"command":                   "workbench_capture",
			"scenario":                  "first_delivery_with_dispatch_confirmation",
			"fixture":                   "first_day_empty_coop",
			"game_seconds":              420,
			"sample_every_game_seconds": 10,
			"speed":                     100,
			"output_dir":                ".runtime/workbench_capture_runs/first_delivery_with_dispatch_confirmation_v0",
		},
	})
	if err != nil {
		t.Fatal(err)
	}
	if call.IsError {
		t.Fatalf("run_shelter_dev_command returned tool error: %s", call.Content[0].(*mcp.TextContent).Text)
	}
	text := call.Content[0].(*mcp.TextContent).Text
	if !strings.Contains(text, `"scenario_id": "first_delivery_with_dispatch_confirmation"`) {
		t.Fatalf("MCP workbench result did not include dispatch scenario manifest: %s", text)
	}
}

func TestRealWorkbenchCaptureDispatchScenarioThroughMCP(t *testing.T) {
	if os.Getenv("SHELTER_MCP_REAL_WORKBENCH_CAPTURE") != "1" {
		t.Skip("set SHELTER_MCP_REAL_WORKBENCH_CAPTURE=1 and SHELTER_STEAM_ROOT to run the real Godot workbench capture through MCP")
	}
	steamRoot := os.Getenv("SHELTER_STEAM_ROOT")
	if steamRoot == "" {
		t.Fatal("SHELTER_STEAM_ROOT is required")
	}
	cfg, err := NewConfig(steamRoot)
	if err != nil {
		t.Fatal(err)
	}

	ctx := context.Background()
	clientTransport, serverTransport := mcp.NewInMemoryTransports()
	server := NewServer(cfg)
	serverSession, err := server.Connect(ctx, serverTransport, nil)
	if err != nil {
		t.Fatal(err)
	}
	defer serverSession.Close()

	client := mcp.NewClient(&mcp.Implementation{Name: "test-client", Version: "test"}, nil)
	clientSession, err := client.Connect(ctx, clientTransport, nil)
	if err != nil {
		t.Fatal(err)
	}
	defer clientSession.Close()

	call, err := clientSession.CallTool(ctx, &mcp.CallToolParams{
		Name: "run_shelter_dev_command",
		Arguments: map[string]any{
			"command":                   "workbench_capture",
			"scenario":                  "first_delivery_with_dispatch_confirmation",
			"fixture":                   "first_day_empty_coop",
			"game_seconds":              420,
			"sample_every_game_seconds": 10,
			"speed":                     100,
			"output_dir":                ".runtime/workbench_capture_runs/first_delivery_with_dispatch_confirmation_v0_mcp",
			"include_artifacts":         []string{"manifest.json", "run.log"},
			"timeout_seconds":           600,
		},
	})
	if err != nil {
		t.Fatal(err)
	}
	if call.IsError {
		t.Fatalf("real workbench capture returned tool error: %s", call.Content[0].(*mcp.TextContent).Text)
	}
	text := call.Content[0].(*mcp.TextContent).Text
	for _, want := range []string{
		`"scenario_id": "first_delivery_with_dispatch_confirmation"`,
		`"order.delivery_confirmed": true`,
		`"game.chain_complete": true`,
		`"production_chain.state": "completed"`,
	} {
		if !strings.Contains(text, want) {
			t.Fatalf("real MCP workbench result did not include %q: %s", want, text)
		}
	}
}

func assertObjectSchema(t *testing.T, toolName, schemaName string, schema any) {
	t.Helper()
	if schema == nil {
		t.Fatalf("%s missing %s schema", toolName, schemaName)
	}
	data, err := json.Marshal(schema)
	if err != nil {
		t.Fatalf("%s %s schema did not marshal: %v", toolName, schemaName, err)
	}
	var decoded map[string]any
	if err := json.Unmarshal(data, &decoded); err != nil {
		t.Fatalf("%s %s schema did not decode as object: %v", toolName, schemaName, err)
	}
	if decoded["type"] != "object" {
		t.Fatalf("%s %s schema type = %v, want object", toolName, schemaName, decoded["type"])
	}
}

func TestWorkbenchOutputDirMustStayUnderRuntimeRoot(t *testing.T) {
	root := t.TempDir()
	app := App{cfg: Config{
		SteamRoot:     root,
		WorkbenchRoot: filepath.Join(root, ".runtime", "workbench_capture_runs"),
	}}

	if _, err := app.cleanWorkbenchOutputDir(".runtime/workbench_capture_runs/run_1"); err != nil {
		t.Fatalf("expected safe output dir to pass: %v", err)
	}
	if _, err := app.cleanWorkbenchOutputDir(".runtime/workbench_capture_runs"); err == nil {
		t.Fatalf("expected root workbench output dir to fail")
	}
	if _, err := app.cleanWorkbenchOutputDir("../outside"); err == nil {
		t.Fatalf("expected escaping output dir to fail")
	}
	if _, err := app.cleanWorkbenchOutputDir(".runtime/workbench_capture_runs/../outside"); err == nil {
		t.Fatalf("expected sibling output dir to fail")
	}
}
