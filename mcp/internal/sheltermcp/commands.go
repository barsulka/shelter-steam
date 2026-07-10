package sheltermcp

import (
	"bytes"
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
	"slices"
	"strconv"
	"strings"
	"time"

	"github.com/modelcontextprotocol/go-sdk/mcp"
)

var (
	scenarioIDs = []string{
		"first_delivery_from_empty",
		"first_delivery_with_dispatch_confirmation",
		"warm_food_delivery_mid_chain",
		"house_of_curiosity_learning_session",
	}
	fixtureIDs = []string{
		"first_day_empty_coop",
		"warm_food_delivery_mid_chain",
		"house_of_curiosity_learning_session",
	}
	speedValues = []int{1, 2, 3, 5, 10, 100}
	safeRunID   = regexp.MustCompile(`^[A-Za-z0-9._-]+$`)
)

type ListDevCommandsInput struct{}

type DevCommandInfo struct {
	Name        string            `json:"name"`
	Description string            `json:"description"`
	Mode        string            `json:"mode"`
	Script      string            `json:"script,omitempty"`
	Notes       []string          `json:"notes,omitempty"`
	Arguments   map[string]string `json:"arguments,omitempty"`
}

type ListDevCommandsOutput struct {
	OK             bool             `json:"ok"`
	SteamRoot      string           `json:"steam_root"`
	DevCommands    []DevCommandInfo `json:"dev_commands"`
	ControlActions []ControlAction  `json:"control_actions"`
}

func (a *App) ListDevCommands(_ context.Context, _ *mcp.CallToolRequest, _ ListDevCommandsInput) (*mcp.CallToolResult, ListDevCommandsOutput, error) {
	out := ListDevCommandsOutput{
		OK:        true,
		SteamRoot: a.cfg.SteamRoot,
		DevCommands: []DevCommandInfo{
			{
				Name:        "workbench_capture",
				Description: "Run tools/dev-vertical-slice.sh workbench-capture and return bundle metadata plus selected artifact contents.",
				Mode:        "synchronous",
				Script:      "tools/dev-vertical-slice.sh workbench-capture",
				Arguments: map[string]string{
					"scenario":                             strings.Join(scenarioIDs, "|"),
					"fixture":                              strings.Join(fixtureIDs, "|"),
					"game_seconds":                         "> 0",
					"sample_every_game_seconds":            "> 0",
					"speed":                                "1|2|3|5|10|100",
					"output_dir":                           "relative path under .runtime/workbench_capture_runs",
					"include_artifacts/max_artifact_bytes": "controls how much bundle content is embedded in the tool result",
				},
				Notes: []string{
					"100x is for accelerated JSON capture only, not player-feel acceptance.",
					"The command is built with exec.Command arguments, not a shell string.",
				},
			},
			{Name: "vertical_slice_smoke", Description: "Run the fast Vertical Slice smoke check.", Mode: "synchronous", Script: "tools/dev-vertical-slice.sh smoke"},
			{Name: "connector_smoke", Description: "Run read-only Godot State Connector smoke checks.", Mode: "synchronous", Script: "tools/dev-vertical-slice.sh connector-smoke"},
			{Name: "connector_control_smoke", Description: "Run token-protected connector/control smoke checks.", Mode: "synchronous", Script: "tools/dev-vertical-slice.sh connector-control-smoke"},
			{Name: "runtime_foundation_smoke", Description: "Run fixture/save/runtime action acceptance smoke checks.", Mode: "synchronous", Script: "tools/dev-vertical-slice.sh runtime-foundation-smoke"},
			{Name: "capture_smoke", Description: "Run bounded local PNG capture smoke check.", Mode: "synchronous", Script: "tools/dev-vertical-slice.sh capture-smoke"},
			{Name: "launcher_url", Description: "Print URLs for an already running launcher process. Lookup only.", Mode: "synchronous", Script: "./launch.sh --url"},
			{Name: "launcher_shutdown", Description: "Soft full shutdown for launcher-started tunnels, connector and game.", Mode: "synchronous", Script: "./launch.sh --exit"},
			{Name: "barsulka_url", Description: "Print the already running Barsulka tunnel URL. Lookup only.", Mode: "synchronous", Script: "./launch.sh --barsulka"},
			{Name: "barsulka_stop", Description: "Stop Barsulka tunnel and local HTTP connector, leaving Godot alive when launcher supports it.", Mode: "synchronous", Script: "./launch.sh --barsulka --stop"},
		},
		ControlActions: sortedControlActions(),
	}
	return structuredResult(out), out, nil
}

type RunDevCommandInput struct {
	Command                string   `json:"command" jsonschema:"whitelisted command id; call list_shelter_dev_commands first if unsure"`
	Scenario               string   `json:"scenario,omitempty" jsonschema:"workbench scenario id"`
	Fixture                string   `json:"fixture,omitempty" jsonschema:"runtime fixture id"`
	GameSeconds            float64  `json:"game_seconds,omitempty" jsonschema:"workbench game seconds; default 180"`
	SampleEveryGameSeconds float64  `json:"sample_every_game_seconds,omitempty" jsonschema:"workbench sample interval in game seconds; default 10"`
	Speed                  int      `json:"speed,omitempty" jsonschema:"workbench speed multiplier; allowed values are 1,2,3,5,10,100; default 100"`
	OutputDir              string   `json:"output_dir,omitempty" jsonschema:"workbench output directory under .runtime/workbench_capture_runs"`
	KeepRunning            bool     `json:"keep_running,omitempty" jsonschema:"for workbench_capture, keep a newly started Godot connector running"`
	Port                   int      `json:"port,omitempty" jsonschema:"local connector port; default 8765"`
	Token                  string   `json:"token,omitempty" jsonschema:"connector token for reusing an existing workbench runtime"`
	IncludeArtifacts       []string `json:"include_artifacts,omitempty" jsonschema:"artifact filenames to embed in the result"`
	MaxArtifactBytes       int64    `json:"max_artifact_bytes,omitempty" jsonschema:"max bytes to embed per artifact; default 262144"`
	TimeoutSeconds         int      `json:"timeout_seconds,omitempty" jsonschema:"command timeout; default 600, max 3600"`
}

type RunDevCommandOutput struct {
	OK              bool                 `json:"ok"`
	Command         string               `json:"command"`
	Args            []string             `json:"args"`
	WorkingDir      string               `json:"working_dir"`
	ExitCode        int                  `json:"exit_code"`
	DurationMS      int64                `json:"duration_ms"`
	Stdout          string               `json:"stdout,omitempty"`
	Stderr          string               `json:"stderr,omitempty"`
	Error           string               `json:"error,omitempty"`
	WorkbenchRun    *WorkbenchRunSummary `json:"workbench_run,omitempty"`
	Manifest        map[string]any       `json:"manifest,omitempty"`
	Artifacts       []ArtifactContent    `json:"artifacts,omitempty"`
	Warnings        []string             `json:"warnings,omitempty"`
	RedactedSecrets map[string]string    `json:"redacted_secrets,omitempty"`
}

func (a *App) RunDevCommand(ctx context.Context, _ *mcp.CallToolRequest, input RunDevCommandInput) (*mcp.CallToolResult, RunDevCommandOutput, error) {
	out, err := a.runDevCommand(ctx, input)
	if err != nil {
		out.OK = false
		out.Error = err.Error()
		return structuredToolError(out), out, nil
	}
	if !out.OK {
		return structuredToolError(out), out, nil
	}
	return structuredResult(out), out, nil
}

func (a *App) runDevCommand(ctx context.Context, input RunDevCommandInput) (RunDevCommandOutput, error) {
	command := strings.TrimSpace(input.Command)
	out := RunDevCommandOutput{
		Command:    command,
		WorkingDir: a.cfg.SteamRoot,
	}

	timeout := timeoutFromInput(input.TimeoutSeconds, a.cfg.DefaultTimeout, a.cfg.MaxTimeout)
	cmdCtx, cancel := context.WithTimeout(ctx, timeout)
	defer cancel()

	var cmd *exec.Cmd
	var err error

	switch command {
	case "workbench_capture":
		cmd, err = a.buildWorkbenchCaptureCommand(cmdCtx, input, &out)
	case "vertical_slice_smoke":
		out.Args = []string{"smoke"}
		cmd = exec.CommandContext(cmdCtx, a.cfg.DevScript, out.Args...)
	case "connector_smoke":
		out.Args = []string{"connector-smoke"}
		cmd = exec.CommandContext(cmdCtx, a.cfg.DevScript, out.Args...)
	case "connector_control_smoke":
		out.Args = []string{"connector-control-smoke"}
		cmd = exec.CommandContext(cmdCtx, a.cfg.DevScript, out.Args...)
	case "runtime_foundation_smoke":
		out.Args = []string{"runtime-foundation-smoke"}
		cmd = exec.CommandContext(cmdCtx, a.cfg.DevScript, out.Args...)
	case "capture_smoke":
		out.Args = []string{"capture-smoke"}
		cmd = exec.CommandContext(cmdCtx, a.cfg.DevScript, out.Args...)
	case "launcher_url":
		out.Args = []string{"--url"}
		cmd = exec.CommandContext(cmdCtx, a.cfg.LaunchScript, out.Args...)
	case "launcher_shutdown":
		out.Args = []string{"--exit"}
		cmd = exec.CommandContext(cmdCtx, a.cfg.LaunchScript, out.Args...)
	case "barsulka_url":
		out.Args = []string{"--barsulka"}
		cmd = exec.CommandContext(cmdCtx, a.cfg.LaunchScript, out.Args...)
	case "barsulka_stop":
		out.Args = []string{"--barsulka", "--stop"}
		cmd = exec.CommandContext(cmdCtx, a.cfg.LaunchScript, out.Args...)
	default:
		return out, fmt.Errorf("unsupported shelter dev command %q", command)
	}
	if err != nil {
		return out, err
	}

	cmd.Dir = a.cfg.SteamRoot
	cmd.Env = os.Environ()

	var stdout, stderr bytes.Buffer
	cmd.Stdout = &stdout
	cmd.Stderr = &stderr

	started := time.Now()
	runErr := cmd.Run()
	out.DurationMS = time.Since(started).Milliseconds()
	out.Stdout = truncateMiddle(stdout.String(), 64*1024)
	out.Stderr = truncateMiddle(stderr.String(), 64*1024)
	out.ExitCode = exitCode(runErr)

	if errors.Is(cmdCtx.Err(), context.DeadlineExceeded) {
		out.OK = false
		return out, fmt.Errorf("command timed out after %s", timeout)
	}
	if runErr != nil {
		out.OK = false
		return out, fmt.Errorf("command failed: %w", runErr)
	}
	out.OK = true

	if command == "workbench_capture" {
		if err := a.enrichWorkbenchCaptureOutput(input, &out); err != nil {
			out.OK = false
			return out, err
		}
	}

	return out, nil
}

func (a *App) buildWorkbenchCaptureCommand(ctx context.Context, input RunDevCommandInput, out *RunDevCommandOutput) (*exec.Cmd, error) {
	scenario := input.Scenario
	if scenario == "" {
		scenario = "first_delivery_from_empty"
	}
	if !slices.Contains(scenarioIDs, scenario) {
		return nil, fmt.Errorf("unsupported scenario %q", scenario)
	}

	fixture := input.Fixture
	if fixture == "" {
		fixture = defaultFixtureForScenario(scenario)
	}
	if !slices.Contains(fixtureIDs, fixture) {
		return nil, fmt.Errorf("unsupported fixture %q", fixture)
	}

	gameSeconds := input.GameSeconds
	if gameSeconds == 0 {
		gameSeconds = 180
	}
	if gameSeconds <= 0 {
		return nil, fmt.Errorf("game_seconds must be > 0")
	}

	sampleEvery := input.SampleEveryGameSeconds
	if sampleEvery == 0 {
		sampleEvery = 10
	}
	if sampleEvery <= 0 {
		return nil, fmt.Errorf("sample_every_game_seconds must be > 0")
	}

	speed := input.Speed
	if speed == 0 {
		speed = 100
	}
	if !slices.Contains(speedValues, speed) {
		return nil, fmt.Errorf("unsupported speed %d; expected one of %v", speed, speedValues)
	}

	outputDir := input.OutputDir
	if outputDir == "" {
		runID := fmt.Sprintf("%s__%s", time.Now().UTC().Format("20060102T150405Z"), scenario)
		outputDir = filepath.Join(".runtime", "workbench_capture_runs", runID)
	}
	cleanOutputDir, err := a.cleanWorkbenchOutputDir(outputDir)
	if err != nil {
		return nil, err
	}

	args := []string{
		"workbench-capture",
		"--scenario=" + scenario,
		"--fixture=" + fixture,
		"--game-seconds=" + strconv.FormatFloat(gameSeconds, 'f', -1, 64),
		"--sample-every-game-seconds=" + strconv.FormatFloat(sampleEvery, 'f', -1, 64),
		"--speed=" + strconv.Itoa(speed),
		"--output-dir=" + cleanOutputDir,
	}
	if input.KeepRunning {
		args = append(args, "--keep-running")
	}
	if input.Port != 0 {
		if err := validatePort(input.Port); err != nil {
			return nil, err
		}
		args = append(args, "--port="+strconv.Itoa(input.Port))
	}
	if input.Token != "" {
		args = append(args, "--token="+input.Token)
		out.RedactedSecrets = map[string]string{"token": redacted(input.Token)}
	}

	out.Args = redactArgs(args)
	return exec.CommandContext(ctx, a.cfg.DevScript, args...), nil
}

func (a *App) cleanWorkbenchOutputDir(outputDir string) (string, error) {
	outputDir = strings.TrimSpace(outputDir)
	if outputDir == "" {
		return "", fmt.Errorf("output_dir cannot be empty")
	}
	if strings.Contains(outputDir, "\x00") {
		return "", fmt.Errorf("output_dir cannot contain NUL bytes")
	}

	var abs string
	if filepath.IsAbs(outputDir) {
		abs = filepath.Clean(outputDir)
	} else {
		abs = filepath.Clean(filepath.Join(a.cfg.SteamRoot, outputDir))
	}
	if !pathWithin(abs, a.cfg.WorkbenchRoot) {
		return "", fmt.Errorf("output_dir must be under %s", a.cfg.WorkbenchRoot)
	}
	if filepath.Clean(abs) == filepath.Clean(a.cfg.WorkbenchRoot) {
		return "", fmt.Errorf("output_dir must name a run directory under %s", a.cfg.WorkbenchRoot)
	}
	runID := filepath.Base(abs)
	if runID == "." || runID == string(filepath.Separator) || !safeRunID.MatchString(runID) {
		return "", fmt.Errorf("output_dir basename %q is not a safe run id", runID)
	}
	if filepath.IsAbs(outputDir) {
		return abs, nil
	}
	rel, err := filepath.Rel(a.cfg.SteamRoot, abs)
	if err != nil {
		return "", err
	}
	return rel, nil
}

func (a *App) enrichWorkbenchCaptureOutput(input RunDevCommandInput, out *RunDevCommandOutput) error {
	outputDir := input.OutputDir
	if outputDir == "" {
		outputDir = parseWorkbenchOutputDir(out.Stdout)
	}
	if outputDir == "" {
		return fmt.Errorf("workbench capture succeeded but output directory was not found in stdout")
	}
	abs, err := a.resolveWorkbenchRunPath(outputDir)
	if err != nil {
		return err
	}
	summary, manifest, err := a.summarizeWorkbenchRun(abs, true)
	if err != nil {
		return err
	}
	out.WorkbenchRun = &summary
	out.Manifest = manifest

	files := input.IncludeArtifacts
	if len(files) == 0 {
		files = []string{"manifest.json", "final_state.json", "run.log"}
	}
	maxBytes := input.MaxArtifactBytes
	if maxBytes == 0 {
		maxBytes = a.cfg.MaxArtifactSize
	}
	artifacts, err := a.readWorkbenchArtifacts(abs, files, maxBytes)
	if err != nil {
		return err
	}
	out.Artifacts = artifacts
	return nil
}

func defaultFixtureForScenario(scenario string) string {
	switch scenario {
	case "warm_food_delivery_mid_chain":
		return "warm_food_delivery_mid_chain"
	case "house_of_curiosity_learning_session":
		return "house_of_curiosity_learning_session"
	default:
		return "first_day_empty_coop"
	}
}

func timeoutFromInput(seconds int, fallback, max time.Duration) time.Duration {
	if seconds <= 0 {
		return fallback
	}
	duration := time.Duration(seconds) * time.Second
	if duration > max {
		return max
	}
	return duration
}

func exitCode(err error) int {
	if err == nil {
		return 0
	}
	var exitErr *exec.ExitError
	if errors.As(err, &exitErr) {
		return exitErr.ExitCode()
	}
	return -1
}

func redactArgs(args []string) []string {
	out := make([]string, 0, len(args))
	for _, arg := range args {
		if strings.HasPrefix(arg, "--token=") {
			out = append(out, "--token=<redacted>")
			continue
		}
		out = append(out, arg)
	}
	return out
}

func parseWorkbenchOutputDir(stdout string) string {
	for _, line := range strings.Split(stdout, "\n") {
		line = strings.TrimSpace(line)
		if strings.HasPrefix(line, "workbench-capture output:") {
			return strings.TrimSpace(strings.TrimPrefix(line, "workbench-capture output:"))
		}
	}
	return ""
}

func truncateMiddle(text string, max int) string {
	if max <= 0 || len(text) <= max {
		return text
	}
	head := max / 2
	tail := max - head
	return text[:head] + "\n... <truncated> ...\n" + text[len(text)-tail:]
}

func validatePort(port int) error {
	if port < 1 || port > 65535 {
		return fmt.Errorf("port must be between 1 and 65535")
	}
	return nil
}

func decodeJSONFile(path string) (map[string]any, error) {
	data, err := os.ReadFile(path)
	if err != nil {
		return nil, err
	}
	var value map[string]any
	if err := json.Unmarshal(data, &value); err != nil {
		return nil, err
	}
	return value, nil
}
