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
		"list_shelter_upstreams",
		"git_status",
		"git_diff",
		"git_diff_for_review",
		"apply_patch",
		"insert_section_after_heading",
		"replace_section",
		"append_changelog_entry",
		"replace_between_markers",
		"read_shelter_bootstrap_context",
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
	cfg.FilesystemProxyEnabled = false

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
