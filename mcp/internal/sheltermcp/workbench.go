package sheltermcp

import (
	"context"
	"fmt"
	"io"
	"os"
	"path/filepath"
	"sort"
	"strings"
	"time"

	"github.com/modelcontextprotocol/go-sdk/mcp"
)

type WorkbenchRunSummary struct {
	RunID       string         `json:"run_id"`
	Path        string         `json:"path"`
	CreatedAt   string         `json:"created_at,omitempty"`
	ModTime     string         `json:"mod_time"`
	SizeBytes   int64          `json:"size_bytes"`
	FileCount   int            `json:"file_count"`
	Manifest    map[string]any `json:"manifest,omitempty"`
	HasManifest bool           `json:"has_manifest"`
}

type ArtifactContent struct {
	Name        string `json:"name"`
	Path        string `json:"path"`
	MIMEType    string `json:"mime_type"`
	SizeBytes   int64  `json:"size_bytes"`
	Truncated   bool   `json:"truncated"`
	Content     string `json:"content,omitempty"`
	Missing     bool   `json:"missing,omitempty"`
	Error       string `json:"error,omitempty"`
	ResourceURI string `json:"resource_uri,omitempty"`
}

type ListWorkbenchRunsInput struct {
	IncludeManifest bool   `json:"include_manifest,omitempty" jsonschema:"include manifest.json content for each run"`
	Limit           int    `json:"limit,omitempty" jsonschema:"maximum number of runs to return; default 50"`
	Prefix          string `json:"prefix,omitempty" jsonschema:"optional run_id prefix filter"`
}

type ListWorkbenchRunsOutput struct {
	OK            bool                  `json:"ok"`
	WorkbenchRoot string                `json:"workbench_root"`
	Runs          []WorkbenchRunSummary `json:"runs"`
	Error         string                `json:"error,omitempty"`
}

func (a *App) ListWorkbenchRuns(_ context.Context, _ *mcp.CallToolRequest, input ListWorkbenchRunsInput) (*mcp.CallToolResult, ListWorkbenchRunsOutput, error) {
	limit := input.Limit
	if limit <= 0 {
		limit = 50
	}
	if limit > 500 {
		limit = 500
	}

	runs, err := a.listWorkbenchRuns(input.IncludeManifest, input.Prefix, limit)
	out := ListWorkbenchRunsOutput{
		OK:            err == nil,
		WorkbenchRoot: a.cfg.WorkbenchRoot,
		Runs:          runs,
	}
	if err != nil {
		out.Error = err.Error()
		return structuredToolError(out), out, nil
	}
	return structuredResult(out), out, nil
}

type GetWorkbenchRunArtifactsInput struct {
	RunID            string   `json:"run_id,omitempty" jsonschema:"workbench run id under .runtime/workbench_capture_runs"`
	OutputDir        string   `json:"output_dir,omitempty" jsonschema:"optional explicit workbench output dir under .runtime/workbench_capture_runs"`
	Files            []string `json:"files,omitempty" jsonschema:"artifact filenames to return; default manifest.json, final_state.json, events.jsonl, run.log"`
	MaxArtifactBytes int64    `json:"max_artifact_bytes,omitempty" jsonschema:"max bytes to embed per artifact; default 262144"`
}

type GetWorkbenchRunArtifactsOutput struct {
	OK        bool                `json:"ok"`
	Run       WorkbenchRunSummary `json:"run"`
	Manifest  map[string]any      `json:"manifest,omitempty"`
	Artifacts []ArtifactContent   `json:"artifacts"`
	Error     string              `json:"error,omitempty"`
}

func (a *App) GetWorkbenchRunArtifacts(_ context.Context, _ *mcp.CallToolRequest, input GetWorkbenchRunArtifactsInput) (*mcp.CallToolResult, GetWorkbenchRunArtifactsOutput, error) {
	path, err := a.resolveWorkbenchInput(input.RunID, input.OutputDir)
	if err != nil {
		out := GetWorkbenchRunArtifactsOutput{OK: false, Error: err.Error()}
		return structuredToolError(out), out, nil
	}
	files := input.Files
	if len(files) == 0 {
		files = []string{"manifest.json", "final_state.json", "events.jsonl", "run.log"}
	}
	maxBytes := input.MaxArtifactBytes
	if maxBytes == 0 {
		maxBytes = a.cfg.MaxArtifactSize
	}
	run, manifest, err := a.summarizeWorkbenchRun(path, true)
	if err != nil {
		out := GetWorkbenchRunArtifactsOutput{OK: false, Error: err.Error()}
		return structuredToolError(out), out, nil
	}
	artifacts, err := a.readWorkbenchArtifacts(path, files, maxBytes)
	if err != nil {
		out := GetWorkbenchRunArtifactsOutput{OK: false, Run: run, Manifest: manifest, Error: err.Error()}
		return structuredToolError(out), out, nil
	}
	out := GetWorkbenchRunArtifactsOutput{
		OK:        true,
		Run:       run,
		Manifest:  manifest,
		Artifacts: artifacts,
	}
	return structuredResult(out), out, nil
}

type ClearWorkbenchRunsInput struct {
	Confirm        bool   `json:"confirm,omitempty" jsonschema:"must be true to delete when dry_run is false"`
	DryRun         bool   `json:"dry_run,omitempty" jsonschema:"if true, report what would be deleted without deleting"`
	Prefix         string `json:"prefix,omitempty" jsonschema:"delete only run ids with this prefix"`
	OlderThanHours int    `json:"older_than_hours,omitempty" jsonschema:"delete only runs older than this many hours"`
}

type ClearWorkbenchRunsOutput struct {
	OK            bool     `json:"ok"`
	DryRun        bool     `json:"dry_run"`
	WorkbenchRoot string   `json:"workbench_root"`
	Deleted       []string `json:"deleted"`
	Matched       []string `json:"matched"`
	Error         string   `json:"error,omitempty"`
}

func (a *App) ClearWorkbenchRuns(_ context.Context, _ *mcp.CallToolRequest, input ClearWorkbenchRunsInput) (*mcp.CallToolResult, ClearWorkbenchRunsOutput, error) {
	dryRun := input.DryRun
	if !dryRun && !input.Confirm {
		out := ClearWorkbenchRunsOutput{
			OK:            false,
			DryRun:        dryRun,
			WorkbenchRoot: a.cfg.WorkbenchRoot,
			Error:         "confirm=true is required when dry_run=false",
		}
		return structuredToolError(out), out, nil
	}

	runs, err := a.listWorkbenchRuns(false, input.Prefix, 10000)
	if err != nil {
		out := ClearWorkbenchRunsOutput{OK: false, DryRun: dryRun, WorkbenchRoot: a.cfg.WorkbenchRoot, Error: err.Error()}
		return structuredToolError(out), out, nil
	}

	cutoff := time.Time{}
	if input.OlderThanHours > 0 {
		cutoff = time.Now().Add(-time.Duration(input.OlderThanHours) * time.Hour)
	}

	out := ClearWorkbenchRunsOutput{
		OK:            true,
		DryRun:        dryRun,
		WorkbenchRoot: a.cfg.WorkbenchRoot,
	}
	for _, run := range runs {
		if !cutoff.IsZero() {
			mod, err := time.Parse(time.RFC3339, run.ModTime)
			if err == nil && mod.After(cutoff) {
				continue
			}
		}
		out.Matched = append(out.Matched, run.RunID)
		if dryRun {
			continue
		}
		if err := os.RemoveAll(run.Path); err != nil {
			out.OK = false
			out.Error = err.Error()
			return structuredToolError(out), out, nil
		}
		out.Deleted = append(out.Deleted, run.RunID)
	}
	return structuredResult(out), out, nil
}

func (a *App) listWorkbenchRuns(includeManifest bool, prefix string, limit int) ([]WorkbenchRunSummary, error) {
	if err := os.MkdirAll(a.cfg.WorkbenchRoot, 0755); err != nil {
		return nil, err
	}
	entries, err := os.ReadDir(a.cfg.WorkbenchRoot)
	if err != nil {
		return nil, err
	}

	var runs []WorkbenchRunSummary
	for _, entry := range entries {
		if !entry.IsDir() {
			continue
		}
		runID := entry.Name()
		if prefix != "" && !strings.HasPrefix(runID, prefix) {
			continue
		}
		if !safeRunID.MatchString(runID) {
			continue
		}
		path := filepath.Join(a.cfg.WorkbenchRoot, runID)
		summary, _, err := a.summarizeWorkbenchRun(path, includeManifest)
		if err != nil {
			continue
		}
		runs = append(runs, summary)
	}
	sort.Slice(runs, func(i, j int) bool {
		return runs[i].ModTime > runs[j].ModTime
	})
	if limit > 0 && len(runs) > limit {
		runs = runs[:limit]
	}
	return runs, nil
}

func (a *App) summarizeWorkbenchRun(path string, includeManifest bool) (WorkbenchRunSummary, map[string]any, error) {
	path = filepath.Clean(path)
	if !pathWithin(path, a.cfg.WorkbenchRoot) {
		return WorkbenchRunSummary{}, nil, fmt.Errorf("workbench run path must be under %s", a.cfg.WorkbenchRoot)
	}
	info, err := os.Stat(path)
	if err != nil {
		return WorkbenchRunSummary{}, nil, err
	}
	if !info.IsDir() {
		return WorkbenchRunSummary{}, nil, fmt.Errorf("%s is not a directory", path)
	}

	summary := WorkbenchRunSummary{
		RunID:   filepath.Base(path),
		Path:    path,
		ModTime: info.ModTime().UTC().Format(time.RFC3339),
	}

	var manifest map[string]any
	manifestPath := filepath.Join(path, "manifest.json")
	if _, err := os.Stat(manifestPath); err == nil {
		summary.HasManifest = true
		if includeManifest {
			manifest, _ = decodeJSONFile(manifestPath)
			summary.Manifest = manifest
		}
		if manifest != nil {
			if createdAt, ok := manifest["created_at"].(string); ok {
				summary.CreatedAt = createdAt
			}
		}
	}

	filepath.WalkDir(path, func(child string, entry os.DirEntry, walkErr error) error {
		if walkErr != nil || entry.IsDir() {
			return nil
		}
		if info, err := entry.Info(); err == nil {
			summary.FileCount++
			summary.SizeBytes += info.Size()
		}
		return nil
	})
	return summary, manifest, nil
}

func (a *App) readWorkbenchArtifacts(runPath string, files []string, maxBytes int64) ([]ArtifactContent, error) {
	if maxBytes <= 0 {
		maxBytes = a.cfg.MaxArtifactSize
	}
	if maxBytes > 2*1024*1024 {
		maxBytes = 2 * 1024 * 1024
	}

	artifacts := make([]ArtifactContent, 0, len(files))
	for _, file := range files {
		name := filepath.Clean(strings.TrimSpace(file))
		if name == "." || filepath.IsAbs(name) || strings.HasPrefix(name, ".."+string(filepath.Separator)) || strings.Contains(name, "\x00") {
			return nil, fmt.Errorf("artifact filename %q is not allowed", file)
		}
		path := filepath.Join(runPath, name)
		if !pathWithin(path, runPath) {
			return nil, fmt.Errorf("artifact path %q escapes run directory", file)
		}
		artifact := ArtifactContent{
			Name:        name,
			Path:        path,
			MIMEType:    mimeTypeForArtifact(name),
			ResourceURI: "file://" + path,
		}
		info, err := os.Stat(path)
		if err != nil {
			artifact.Missing = true
			artifact.Error = err.Error()
			artifacts = append(artifacts, artifact)
			continue
		}
		if info.IsDir() {
			artifact.Error = "artifact is a directory"
			artifacts = append(artifacts, artifact)
			continue
		}
		artifact.SizeBytes = info.Size()
		content, truncated, err := readTextPrefix(path, maxBytes)
		if err != nil {
			artifact.Error = err.Error()
		} else {
			artifact.Content = content
			artifact.Truncated = truncated
		}
		artifacts = append(artifacts, artifact)
	}
	return artifacts, nil
}

func readTextPrefix(path string, maxBytes int64) (string, bool, error) {
	file, err := os.Open(path)
	if err != nil {
		return "", false, err
	}
	defer file.Close()

	var builder strings.Builder
	_, err = io.Copy(&builder, io.LimitReader(file, maxBytes+1))
	if err != nil {
		return "", false, err
	}
	text := builder.String()
	if int64(len(text)) > maxBytes {
		return text[:maxBytes] + "\n... <truncated> ...", true, nil
	}
	return text, false, nil
}

func (a *App) resolveWorkbenchInput(runID, outputDir string) (string, error) {
	if outputDir != "" {
		return a.resolveWorkbenchRunPath(outputDir)
	}
	runID = strings.TrimSpace(runID)
	if runID == "" {
		return "", fmt.Errorf("run_id or output_dir is required")
	}
	if !safeRunID.MatchString(runID) {
		return "", fmt.Errorf("run_id %q is not safe", runID)
	}
	return a.resolveWorkbenchRunPath(filepath.Join(a.cfg.WorkbenchRoot, runID))
}

func (a *App) resolveWorkbenchRunPath(path string) (string, error) {
	var abs string
	if filepath.IsAbs(path) {
		abs = filepath.Clean(path)
	} else {
		abs = filepath.Clean(filepath.Join(a.cfg.SteamRoot, path))
	}
	if !pathWithin(abs, a.cfg.WorkbenchRoot) {
		return "", fmt.Errorf("workbench path %q must be under %s", abs, a.cfg.WorkbenchRoot)
	}
	return abs, nil
}

func pathWithin(path, root string) bool {
	path = filepath.Clean(path)
	root = filepath.Clean(root)
	if path == root {
		return true
	}
	rel, err := filepath.Rel(root, path)
	if err != nil {
		return false
	}
	return rel != "." && !strings.HasPrefix(rel, ".."+string(filepath.Separator)) && rel != ".."
}

func mimeTypeForArtifact(name string) string {
	switch filepath.Ext(name) {
	case ".json":
		return "application/json"
	case ".jsonl", ".log", ".txt":
		return "text/plain"
	default:
		return "application/octet-stream"
	}
}
