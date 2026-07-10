package sheltermcp

import (
	"bytes"
	"context"
	"crypto/sha256"
	"encoding/hex"
	"errors"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
	"sort"
	"strconv"
	"strings"

	"github.com/modelcontextprotocol/go-sdk/mcp"
)

const (
	defaultDiffMaxBytes      = 60000
	defaultReviewMaxBytes    = 80000
	defaultBootstrapMaxBytes = 120000
	maxRepoToolBytes         = 250000
)

var changelogHeadingRE = regexp.MustCompile(`(?i)^##\s+(?:\d+\.\s+)?changelog\s*$`)

type RepoID string

type RepoInfo struct {
	ID   string `json:"id"`
	Root string `json:"root"`
}

type ChangedFile struct {
	Path       string `json:"path"`
	Status     string `json:"status"`
	RawStatus  string `json:"raw_status,omitempty"`
	OldPath    string `json:"old_path,omitempty"`
	DeniedDiff bool   `json:"denied_diff,omitempty"`
}

type RiskFlag struct {
	Severity string `json:"severity"`
	Path     string `json:"path,omitempty"`
	Message  string `json:"message"`
}

type GitStatusInput struct {
	Repo string `json:"repo" jsonschema:"repo id: shelter or mcp"`
}

type GitStatusOutput struct {
	OK           bool          `json:"ok"`
	Repo         string        `json:"repo"`
	Root         string        `json:"root"`
	Branch       string        `json:"branch"`
	Head         string        `json:"head"`
	IsClean      bool          `json:"is_clean"`
	ChangedFiles []ChangedFile `json:"changed_files"`
	Summary      string        `json:"summary"`
	Error        string        `json:"error,omitempty"`
}

func (a *App) GitStatus(ctx context.Context, _ *mcp.CallToolRequest, input GitStatusInput) (*mcp.CallToolResult, GitStatusOutput, error) {
	out, err := a.gitStatus(ctx, input.Repo)
	if err != nil {
		out.OK = false
		out.Error = err.Error()
		return structuredToolError(out), out, nil
	}
	return structuredResult(out), out, nil
}

type GitDiffInput struct {
	Repo     string   `json:"repo" jsonschema:"repo id: shelter or mcp"`
	Paths    []string `json:"paths,omitempty" jsonschema:"optional relative paths to include"`
	Staged   bool     `json:"staged,omitempty" jsonschema:"if true, return staged diff via git diff --cached"`
	MaxBytes int      `json:"max_bytes,omitempty" jsonschema:"maximum diff bytes to return; default 60000, hard cap 250000"`
}

type GitDiffOutput struct {
	OK           bool          `json:"ok"`
	Repo         string        `json:"repo"`
	Root         string        `json:"root"`
	Paths        []string      `json:"paths"`
	Staged       bool          `json:"staged"`
	Truncated    bool          `json:"truncated"`
	Diff         string        `json:"diff"`
	ChangedFiles []ChangedFile `json:"changed_files"`
	Warnings     []string      `json:"warnings,omitempty"`
	Error        string        `json:"error,omitempty"`
}

func (a *App) GitDiff(ctx context.Context, _ *mcp.CallToolRequest, input GitDiffInput) (*mcp.CallToolResult, GitDiffOutput, error) {
	out, err := a.gitDiff(ctx, input)
	if err != nil {
		out.OK = false
		out.Error = err.Error()
		return structuredToolError(out), out, nil
	}
	return structuredResult(out), out, nil
}

type GitDiffForReviewInput struct {
	Repo             string   `json:"repo" jsonschema:"repo id: shelter or mcp"`
	Paths            []string `json:"paths,omitempty" jsonschema:"optional relative paths to include"`
	MaxBytes         int      `json:"max_bytes,omitempty" jsonschema:"maximum diff bytes to return; default 80000, hard cap 250000"`
	IncludeRiskFlags bool     `json:"include_risk_flags,omitempty" jsonschema:"include simple path/status risk heuristics"`
	Focus            string   `json:"focus,omitempty" jsonschema:"review focus: all, docs, code, or mixed; omitted means all"`
}

type ReviewStats struct {
	FilesChanged  int    `json:"files_changed"`
	MarkdownFiles int    `json:"markdown_files"`
	GoFiles       int    `json:"go_files"`
	DocsFiles     int    `json:"docs_files"`
	TestFiles     int    `json:"test_files"`
	Insertions    int    `json:"insertions"`
	Deletions     int    `json:"deletions"`
	Focus         string `json:"focus"`
	DiffFiles     int    `json:"diff_files"`
	OmittedFiles  int    `json:"omitted_files"`
}

type GitDiffForReviewOutput struct {
	OK            bool          `json:"ok"`
	Repo          string        `json:"repo"`
	Root          string        `json:"root"`
	IsClean       bool          `json:"is_clean"`
	ChangedFiles  []ChangedFile `json:"changed_files"`
	Diff          string        `json:"diff"`
	Truncated     bool          `json:"truncated"`
	RiskFlags     []RiskFlag    `json:"risk_flags,omitempty"`
	ReviewSummary string        `json:"review_summary"`
	ReviewStats   ReviewStats   `json:"review_stats"`
	DiffPaths     []string      `json:"diff_paths,omitempty"`
	OmittedPaths  []string      `json:"omitted_paths,omitempty"`
	Warnings      []string      `json:"warnings,omitempty"`
	Error         string        `json:"error,omitempty"`
}

func (a *App) GitDiffForReview(ctx context.Context, _ *mcp.CallToolRequest, input GitDiffForReviewInput) (*mcp.CallToolResult, GitDiffForReviewOutput, error) {
	repo, err := a.resolveRepo(input.Repo)
	out := GitDiffForReviewOutput{Repo: input.Repo}
	if err != nil {
		out.Error = err.Error()
		return structuredToolError(out), out, nil
	}
	status, err := a.gitStatus(ctx, repo.ID)
	if err != nil {
		out.Repo = repo.ID
		out.Root = repo.Root
		out.Error = err.Error()
		return structuredToolError(out), out, nil
	}
	focus, err := normalizeReviewFocus(input.Focus)
	if err != nil {
		out.Repo = repo.ID
		out.Root = repo.Root
		out.Error = err.Error()
		return structuredToolError(out), out, nil
	}
	diffPaths := input.Paths
	var omittedPaths []string
	if len(input.Paths) == 0 {
		diffPaths, omittedPaths = reviewFocusPaths(status.ChangedFiles, focus)
		if focus == "all" {
			diffPaths = nil
		}
	}
	var diffOut GitDiffOutput
	if len(input.Paths) == 0 && focus != "all" && len(diffPaths) == 0 {
		diffOut = GitDiffOutput{
			OK:           true,
			Repo:         repo.ID,
			Root:         repo.Root,
			ChangedFiles: status.ChangedFiles,
			Warnings:     []string{fmt.Sprintf("focus %q matched no diffable files", focus)},
		}
	} else {
		diffOut, err = a.gitDiff(ctx, GitDiffInput{
			Repo:     repo.ID,
			Paths:    diffPaths,
			MaxBytes: defaultIfZero(input.MaxBytes, defaultReviewMaxBytes),
		})
		if err != nil {
			out.Repo = repo.ID
			out.Root = repo.Root
			out.Error = err.Error()
			return structuredToolError(out), out, nil
		}
	}
	out = GitDiffForReviewOutput{
		OK:            true,
		Repo:          repo.ID,
		Root:          repo.Root,
		IsClean:       status.IsClean,
		ChangedFiles:  status.ChangedFiles,
		Diff:          diffOut.Diff,
		Truncated:     diffOut.Truncated,
		Warnings:      diffOut.Warnings,
		ReviewSummary: reviewSummary(status.ChangedFiles, diffOut.Truncated, diffOut.Warnings),
		DiffPaths:     diffOut.Paths,
		OmittedPaths:  omittedPaths,
	}
	out.ReviewStats = a.reviewStats(ctx, repo.Root, status.ChangedFiles, diffOut.Paths, focus, len(omittedPaths))
	if input.IncludeRiskFlags {
		out.RiskFlags = riskFlagsForChanges(status.ChangedFiles, diffOut.Truncated)
	}
	return structuredResult(out), out, nil
}

type ApplyPatchInput struct {
	Repo   string `json:"repo" jsonschema:"repo id: shelter or mcp"`
	Patch  string `json:"patch" jsonschema:"unified diff text to apply"`
	DryRun *bool  `json:"dry_run,omitempty" jsonschema:"defaults to true; when false applies the patch after git apply --check"`
}

type ApplyPatchOutput struct {
	OK             bool          `json:"ok"`
	Repo           string        `json:"repo"`
	Root           string        `json:"root"`
	DryRun         bool          `json:"dry_run"`
	AppliesCleanly bool          `json:"applies_cleanly"`
	ChangedFiles   []ChangedFile `json:"changed_files"`
	Stdout         string        `json:"stdout,omitempty"`
	Stderr         string        `json:"stderr,omitempty"`
	Error          string        `json:"error,omitempty"`
}

func (a *App) ApplyPatch(ctx context.Context, _ *mcp.CallToolRequest, input ApplyPatchInput) (*mcp.CallToolResult, ApplyPatchOutput, error) {
	out, err := a.applyPatch(ctx, input)
	if err != nil {
		out.OK = false
		out.Error = err.Error()
		return structuredToolError(out), out, nil
	}
	return structuredResult(out), out, nil
}

type InsertSectionAfterHeadingInput struct {
	Repo     string `json:"repo" jsonschema:"repo id: shelter or mcp"`
	Path     string `json:"path" jsonschema:"relative markdown file path"`
	Heading  string `json:"heading" jsonschema:"exact markdown heading line, for example ## Target"`
	Markdown string `json:"markdown" jsonschema:"markdown to insert after the matched section"`
	DryRun   *bool  `json:"dry_run,omitempty" jsonschema:"defaults to true"`
}

type ReplaceSectionInput struct {
	Repo     string `json:"repo" jsonschema:"repo id: shelter or mcp"`
	Path     string `json:"path" jsonschema:"relative markdown file path"`
	Heading  string `json:"heading" jsonschema:"exact markdown heading line to replace"`
	Markdown string `json:"markdown" jsonschema:"replacement markdown, normally including the same heading"`
	DryRun   *bool  `json:"dry_run,omitempty" jsonschema:"defaults to true"`
}

type AppendChangelogEntryInput struct {
	Repo          string `json:"repo" jsonschema:"repo id: shelter or mcp"`
	Path          string `json:"path" jsonschema:"relative markdown file path"`
	EntryHeading  string `json:"entry_heading" jsonschema:"new changelog entry heading"`
	EntryMarkdown string `json:"entry_markdown" jsonschema:"markdown body for the changelog entry"`
	DryRun        *bool  `json:"dry_run,omitempty" jsonschema:"defaults to true"`
}

type ReplaceBetweenMarkersInput struct {
	Repo        string `json:"repo" jsonschema:"repo id: shelter or mcp"`
	Path        string `json:"path" jsonschema:"relative markdown file path"`
	StartMarker string `json:"start_marker" jsonschema:"unique line marker that starts the editable block"`
	EndMarker   string `json:"end_marker" jsonschema:"unique line marker that ends the editable block"`
	Content     string `json:"content" jsonschema:"new markdown content between markers; markers are preserved"`
	DryRun      *bool  `json:"dry_run,omitempty" jsonschema:"defaults to true"`
}

type MarkdownEditOutput struct {
	OK              bool     `json:"ok"`
	Repo            string   `json:"repo"`
	Root            string   `json:"root"`
	Path            string   `json:"path"`
	DryRun          bool     `json:"dry_run"`
	Changed         bool     `json:"changed"`
	Diff            string   `json:"diff"`
	SHA256          string   `json:"sha256,omitempty"`
	NewSHA256       string   `json:"new_sha256,omitempty"`
	ClosestHeadings []string `json:"closest_headings,omitempty"`
	Error           string   `json:"error,omitempty"`
}

func (a *App) InsertSectionAfterHeading(_ context.Context, _ *mcp.CallToolRequest, input InsertSectionAfterHeadingInput) (*mcp.CallToolResult, MarkdownEditOutput, error) {
	out, err := a.editMarkdownSection(input.Repo, input.Path, input.DryRun, func(text string) (string, error) {
		return insertSectionAfterHeading(text, input.Heading, input.Markdown)
	})
	if err != nil {
		out.OK = false
		out.Error = err.Error()
		return structuredToolError(out), out, nil
	}
	return structuredResult(out), out, nil
}

func (a *App) ReplaceSection(_ context.Context, _ *mcp.CallToolRequest, input ReplaceSectionInput) (*mcp.CallToolResult, MarkdownEditOutput, error) {
	out, err := a.editMarkdownSection(input.Repo, input.Path, input.DryRun, func(text string) (string, error) {
		return replaceSection(text, input.Heading, input.Markdown)
	})
	if err != nil {
		out.OK = false
		out.Error = err.Error()
		return structuredToolError(out), out, nil
	}
	return structuredResult(out), out, nil
}

func (a *App) AppendChangelogEntry(_ context.Context, _ *mcp.CallToolRequest, input AppendChangelogEntryInput) (*mcp.CallToolResult, MarkdownEditOutput, error) {
	out, err := a.editMarkdownSection(input.Repo, input.Path, input.DryRun, func(text string) (string, error) {
		return appendChangelogEntry(text, input.EntryHeading, input.EntryMarkdown)
	})
	if err != nil {
		out.OK = false
		out.Error = err.Error()
		return structuredToolError(out), out, nil
	}
	return structuredResult(out), out, nil
}

func (a *App) ReplaceBetweenMarkers(_ context.Context, _ *mcp.CallToolRequest, input ReplaceBetweenMarkersInput) (*mcp.CallToolResult, MarkdownEditOutput, error) {
	out, err := a.editMarkdownSection(input.Repo, input.Path, input.DryRun, func(text string) (string, error) {
		return replaceBetweenMarkers(text, input.StartMarker, input.EndMarker, input.Content)
	})
	if err != nil {
		out.OK = false
		out.Error = err.Error()
		return structuredToolError(out), out, nil
	}
	return structuredResult(out), out, nil
}

type ReadShelterBootstrapContextInput struct {
	Role     string `json:"role,omitempty" jsonschema:"producer|project_manager|game_designer|art_director|codex|generic"`
	Area     string `json:"area,omitempty" jsonschema:"steam|mcp|docs|browser|mobile|generic"`
	MaxBytes int    `json:"max_bytes,omitempty" jsonschema:"maximum concatenated content bytes; default 120000, hard cap 250000"`
}

type BootstrapFileDiagnostic struct {
	Path        string `json:"path"`
	Bytes       int    `json:"bytes"`
	HeaderBytes int    `json:"header_bytes,omitempty"`
	Included    bool   `json:"included"`
	Reason      string `json:"reason"`
}

type ReadShelterBootstrapContextOutput struct {
	OK               bool                      `json:"ok"`
	Role             string                    `json:"role"`
	Area             string                    `json:"area"`
	Root             string                    `json:"root"`
	MaxBytes         int                       `json:"max_bytes"`
	IncludedBytes    int                       `json:"included_bytes"`
	RemainingBudget  int                       `json:"remaining_budget"`
	IncludedPaths    []string                  `json:"included_paths"`
	SkippedPaths     []string                  `json:"skipped_paths"`
	PerFileSizes     []BootstrapFileDiagnostic `json:"per_file_sizes"`
	BootstrapSummary string                    `json:"bootstrap_summary"`
	Truncated        bool                      `json:"truncated"`
	Content          string                    `json:"content"`
	Error            string                    `json:"error,omitempty"`
}

func (a *App) ReadShelterBootstrapContext(_ context.Context, _ *mcp.CallToolRequest, input ReadShelterBootstrapContextInput) (*mcp.CallToolResult, ReadShelterBootstrapContextOutput, error) {
	out, err := a.readShelterBootstrapContext(input)
	if err != nil {
		out.OK = false
		out.Error = err.Error()
		return structuredToolError(out), out, nil
	}
	return structuredResult(out), out, nil
}

type WriteFileIfUnchangedInput struct {
	Repo           string `json:"repo" jsonschema:"repo id: shelter or mcp"`
	Path           string `json:"path" jsonschema:"relative file path"`
	ExpectedSHA256 string `json:"expected_sha256" jsonschema:"sha256 of current file content"`
	Content        string `json:"content" jsonschema:"new file content"`
	DryRun         *bool  `json:"dry_run,omitempty" jsonschema:"defaults to true"`
}

type WriteFileIfUnchangedOutput struct {
	OK             bool   `json:"ok"`
	Repo           string `json:"repo"`
	Root           string `json:"root"`
	Path           string `json:"path"`
	DryRun         bool   `json:"dry_run"`
	Changed        bool   `json:"changed"`
	CurrentSHA256  string `json:"current_sha256,omitempty"`
	ExpectedSHA256 string `json:"expected_sha256"`
	NewSHA256      string `json:"new_sha256,omitempty"`
	Diff           string `json:"diff,omitempty"`
	Error          string `json:"error,omitempty"`
}

func (a *App) WriteFileIfUnchanged(_ context.Context, _ *mcp.CallToolRequest, input WriteFileIfUnchangedInput) (*mcp.CallToolResult, WriteFileIfUnchangedOutput, error) {
	out, err := a.writeFileIfUnchanged(input)
	if err != nil {
		out.OK = false
		out.Error = err.Error()
		return structuredToolError(out), out, nil
	}
	return structuredResult(out), out, nil
}

func (a *App) resolveRepo(repo string) (RepoInfo, error) {
	switch strings.ToLower(strings.TrimSpace(repo)) {
	case "shelter", "":
		return validateGitRepo("shelter", a.cfg.RepoRoot)
	case "mcp":
		return validateGitRepo("mcp", a.cfg.SelfRepoRoot)
	default:
		return RepoInfo{}, fmt.Errorf("unsupported repo %q; expected shelter or mcp", repo)
	}
}

func validateGitRepo(id, root string) (RepoInfo, error) {
	root = filepath.Clean(root)
	if root == "" || root == "." {
		return RepoInfo{}, fmt.Errorf("repo %q root is not configured", id)
	}
	info, err := os.Stat(root)
	if err != nil {
		return RepoInfo{}, fmt.Errorf("repo %q root %q is not available: %w", id, root, err)
	}
	if !info.IsDir() {
		return RepoInfo{}, fmt.Errorf("repo %q root %q is not a directory", id, root)
	}
	cmd := exec.Command("git", "rev-parse", "--show-toplevel")
	cmd.Dir = root
	data, err := cmd.Output()
	if err != nil {
		return RepoInfo{}, fmt.Errorf("repo %q root %q is not a git repo", id, root)
	}
	top := filepath.Clean(strings.TrimSpace(string(data)))
	if !samePath(top, root) {
		return RepoInfo{}, fmt.Errorf("repo %q resolved to git root %q, expected %q", id, top, root)
	}
	return RepoInfo{ID: id, Root: root}, nil
}

func samePath(a, b string) bool {
	a = filepath.Clean(a)
	b = filepath.Clean(b)
	if a == b {
		return true
	}
	aReal, aErr := filepath.EvalSymlinks(a)
	bReal, bErr := filepath.EvalSymlinks(b)
	return aErr == nil && bErr == nil && filepath.Clean(aReal) == filepath.Clean(bReal)
}

func (a *App) gitStatus(ctx context.Context, repoID string) (GitStatusOutput, error) {
	repo, err := a.resolveRepo(repoID)
	out := GitStatusOutput{Repo: repoID}
	if err != nil {
		return out, err
	}
	out.Repo = repo.ID
	out.Root = repo.Root

	branch, _ := runGitText(ctx, repo.Root, 4096, "rev-parse", "--abbrev-ref", "HEAD")
	head, _ := runGitText(ctx, repo.Root, 4096, "rev-parse", "--short", "HEAD")
	status, err := runGitText(ctx, repo.Root, 128*1024, "status", "--porcelain=v1", "--untracked-files=all")
	if err != nil {
		return out, err
	}
	out.Branch = strings.TrimSpace(branch)
	out.Head = strings.TrimSpace(head)
	out.ChangedFiles = parseGitPorcelain(status)
	out.IsClean = len(out.ChangedFiles) == 0
	out.OK = true
	out.Summary = fmt.Sprintf("%s at %s has %d changed file(s)", out.Branch, out.Head, len(out.ChangedFiles))
	if out.IsClean {
		out.Summary = fmt.Sprintf("%s at %s is clean", out.Branch, out.Head)
	}
	return out, nil
}

func (a *App) gitDiff(ctx context.Context, input GitDiffInput) (GitDiffOutput, error) {
	repo, err := a.resolveRepo(input.Repo)
	out := GitDiffOutput{Repo: input.Repo, Staged: input.Staged}
	if err != nil {
		return out, err
	}
	out.Repo = repo.ID
	out.Root = repo.Root
	out.OK = true

	status, err := a.gitStatus(ctx, repo.ID)
	if err != nil {
		return out, err
	}
	out.ChangedFiles = status.ChangedFiles

	paths, warnings, err := a.safeDiffPaths(repo, input.Paths, status.ChangedFiles)
	if err != nil {
		return out, err
	}
	out.Paths = paths
	out.Warnings = warnings
	if len(paths) == 0 {
		return out, nil
	}

	maxBytes := boundedMaxBytes(defaultIfZero(input.MaxBytes, defaultDiffMaxBytes))
	args := []string{"diff", "--no-ext-diff"}
	if input.Staged {
		args = append(args, "--cached")
	}
	args = append(args, "--")
	args = append(args, paths...)
	diff, truncated, err := runGitTextBounded(ctx, repo.Root, maxBytes, args...)
	if err != nil {
		return out, err
	}
	out.Diff = redactDiff(diff)
	out.Truncated = truncated
	return out, nil
}

func (a *App) safeDiffPaths(repo RepoInfo, requested []string, changed []ChangedFile) ([]string, []string, error) {
	var warnings []string
	seen := map[string]bool{}
	var paths []string
	addPath := func(path string) error {
		clean, err := safeRepoRelPath(repo.Root, path)
		if err != nil {
			return err
		}
		if deniedRepoPath(clean) {
			return fmt.Errorf("path %q is denied for diff content", clean)
		}
		if !seen[clean] {
			seen[clean] = true
			paths = append(paths, clean)
		}
		return nil
	}
	if len(requested) > 0 {
		for _, path := range requested {
			if err := addPath(path); err != nil {
				return nil, warnings, err
			}
		}
		return paths, warnings, nil
	}
	for _, file := range changed {
		if file.Status == "untracked" {
			continue
		}
		if deniedRepoPath(file.Path) {
			warnings = append(warnings, fmt.Sprintf("omitted denied path from diff content: %s", file.Path))
			continue
		}
		if !seen[file.Path] {
			seen[file.Path] = true
			paths = append(paths, file.Path)
		}
	}
	sort.Strings(paths)
	return paths, warnings, nil
}

func normalizeReviewFocus(focus string) (string, error) {
	focus = normalizeEnum(focus, "all")
	switch focus {
	case "all", "docs", "code", "mixed":
		return focus, nil
	default:
		return "", fmt.Errorf("unsupported focus %q; expected all, docs, code, or mixed", focus)
	}
}

func reviewFocusPaths(files []ChangedFile, focus string) ([]string, []string) {
	seen := map[string]bool{}
	var included []string
	var omitted []string
	for _, file := range files {
		path := filepath.ToSlash(file.Path)
		if path == "" || file.Status == "untracked" || deniedRepoPath(path) {
			continue
		}
		if focus != "all" && generatedOrMediaPath(path) {
			omitted = append(omitted, path)
			continue
		}
		if focusMatchesPath(path, focus) {
			if !seen[path] {
				seen[path] = true
				included = append(included, path)
			}
			continue
		}
		if focus != "all" {
			omitted = append(omitted, path)
		}
	}
	sort.Strings(included)
	sort.Strings(omitted)
	return included, omitted
}

func focusMatchesPath(path, focus string) bool {
	switch focus {
	case "all":
		return true
	case "docs":
		return docsPath(path)
	case "code":
		return codePath(path)
	case "mixed":
		return docsPath(path) || codePath(path)
	default:
		return true
	}
}

func docsPath(path string) bool {
	base := filepath.Base(path)
	ext := strings.ToLower(filepath.Ext(base))
	return strings.HasPrefix(path, "docs/") ||
		ext == ".md" ||
		ext == ".txt" ||
		base == "README.md" ||
		base == "AGENTS.md" ||
		base == "PROJECTS_RULES.md"
}

func codePath(path string) bool {
	base := filepath.Base(path)
	ext := strings.ToLower(filepath.Ext(base))
	switch ext {
	case ".go", ".gd", ".sh", ".yaml", ".yml", ".json", ".toml":
		return true
	}
	switch base {
	case "go.mod", "go.sum":
		return true
	}
	return false
}

func generatedOrMediaPath(path string) bool {
	lower := strings.ToLower(filepath.ToSlash(path))
	if strings.Contains(lower, "/.runtime/") ||
		strings.HasPrefix(lower, ".runtime/") ||
		strings.Contains(lower, "/captures/") ||
		strings.Contains(lower, "capture_runs/") ||
		strings.Contains(lower, "steam_first_day_mvp_visible_review") {
		return true
	}
	switch strings.ToLower(filepath.Ext(path)) {
	case ".png", ".jpg", ".jpeg", ".gif", ".webp", ".mp4", ".mov", ".avi", ".wav", ".mp3", ".ogg", ".zip":
		return true
	}
	return false
}

func (a *App) reviewStats(ctx context.Context, root string, changed []ChangedFile, diffPaths []string, focus string, omitted int) ReviewStats {
	stats := ReviewStats{
		FilesChanged: len(changed),
		Focus:        focus,
		DiffFiles:    len(diffPaths),
		OmittedFiles: omitted,
	}
	for _, file := range changed {
		path := filepath.ToSlash(file.Path)
		if strings.ToLower(filepath.Ext(path)) == ".md" {
			stats.MarkdownFiles++
		}
		if strings.ToLower(filepath.Ext(path)) == ".go" {
			stats.GoFiles++
		}
		if strings.HasPrefix(path, "docs/") {
			stats.DocsFiles++
		}
		if testFilePath(path) {
			stats.TestFiles++
		}
	}
	insertions, deletions := gitNumstat(ctx, root, diffPaths)
	stats.Insertions = insertions
	stats.Deletions = deletions
	return stats
}

func testFilePath(path string) bool {
	base := filepath.Base(path)
	return strings.Contains(base, "_test.") || strings.HasSuffix(base, ".test")
}

func gitNumstat(ctx context.Context, root string, paths []string) (int, int) {
	if len(paths) == 0 {
		return 0, 0
	}
	args := []string{"diff", "--numstat", "--no-ext-diff", "--"}
	args = append(args, paths...)
	text, _, err := runGitTextBounded(ctx, root, 128*1024, args...)
	if err != nil {
		return 0, 0
	}
	var insertions, deletions int
	for _, line := range strings.Split(text, "\n") {
		fields := strings.Fields(line)
		if len(fields) < 3 {
			continue
		}
		if fields[0] != "-" {
			if value, err := strconv.Atoi(fields[0]); err == nil {
				insertions += value
			}
		}
		if fields[1] != "-" {
			if value, err := strconv.Atoi(fields[1]); err == nil {
				deletions += value
			}
		}
	}
	return insertions, deletions
}

func runGitText(ctx context.Context, dir string, maxBytes int64, args ...string) (string, error) {
	text, _, err := runGitTextBounded(ctx, dir, int(maxBytes), args...)
	return text, err
}

func runGitTextBounded(ctx context.Context, dir string, maxBytes int, args ...string) (string, bool, error) {
	var stdout, stderr bytes.Buffer
	cmd := exec.CommandContext(ctx, "git", args...)
	cmd.Dir = dir
	cmd.Stdout = &stdout
	cmd.Stderr = &stderr
	err := cmd.Run()
	text := stdout.String()
	truncated := false
	if maxBytes > 0 && len(text) > maxBytes {
		text = text[:maxBytes] + "\n... <truncated> ..."
		truncated = true
	}
	if err != nil {
		msg := strings.TrimSpace(stderr.String())
		if msg == "" {
			msg = err.Error()
		}
		return text, truncated, fmt.Errorf("git %s failed: %s", strings.Join(args, " "), truncateMiddle(msg, 4096))
	}
	return text, truncated, nil
}

func parseGitPorcelain(text string) []ChangedFile {
	var files []ChangedFile
	for _, line := range strings.Split(text, "\n") {
		if len(line) < 4 {
			continue
		}
		raw := strings.TrimSpace(line[:2])
		pathText := strings.TrimSpace(line[3:])
		if pathText == "" {
			continue
		}
		file := ChangedFile{RawStatus: raw}
		if strings.HasPrefix(raw, "R") || strings.Contains(raw, "R") {
			parts := strings.SplitN(pathText, " -> ", 2)
			if len(parts) == 2 {
				file.OldPath = unquoteGitPath(parts[0])
				file.Path = unquoteGitPath(parts[1])
			} else {
				file.Path = unquoteGitPath(pathText)
			}
			file.Status = "renamed"
		} else {
			file.Path = unquoteGitPath(pathText)
			file.Status = statusName(raw)
		}
		file.DeniedDiff = deniedRepoPath(file.Path)
		files = append(files, file)
	}
	return files
}

func unquoteGitPath(path string) string {
	path = strings.TrimSpace(path)
	if len(path) >= 2 && path[0] == '"' && path[len(path)-1] == '"' {
		if unquoted, err := strconv.Unquote(path); err == nil {
			return unquoted
		}
	}
	return path
}

func statusName(raw string) string {
	if raw == "??" {
		return "untracked"
	}
	if strings.Contains(raw, "D") {
		return "deleted"
	}
	if strings.Contains(raw, "A") {
		return "added"
	}
	return "modified"
}

func (a *App) applyPatch(ctx context.Context, input ApplyPatchInput) (ApplyPatchOutput, error) {
	repo, err := a.resolveRepo(input.Repo)
	out := ApplyPatchOutput{Repo: input.Repo, DryRun: dryRunDefault(input.DryRun)}
	if err != nil {
		return out, err
	}
	out.Repo = repo.ID
	out.Root = repo.Root
	out.DryRun = dryRunDefault(input.DryRun)
	if strings.TrimSpace(input.Patch) == "" {
		return out, fmt.Errorf("patch cannot be empty")
	}
	files, err := parsePatchFiles(repo.Root, input.Patch)
	if err != nil {
		return out, err
	}
	out.ChangedFiles = files

	checkOut, checkErr, err := runGitApply(ctx, repo.Root, input.Patch, true)
	out.Stdout = truncateMiddle(checkOut, 8192)
	out.Stderr = truncateMiddle(checkErr, 8192)
	if err != nil {
		out.AppliesCleanly = false
		return out, fmt.Errorf("patch does not apply cleanly: %w", err)
	}
	out.AppliesCleanly = true
	if out.DryRun {
		out.OK = true
		return out, nil
	}
	applyOut, applyErr, err := runGitApply(ctx, repo.Root, input.Patch, false)
	out.Stdout = truncateMiddle(applyOut, 8192)
	out.Stderr = truncateMiddle(applyErr, 8192)
	if err != nil {
		out.OK = false
		return out, fmt.Errorf("patch apply failed after clean check: %w", err)
	}
	out.OK = true
	return out, nil
}

func runGitApply(ctx context.Context, dir, patch string, check bool) (string, string, error) {
	args := []string{"apply"}
	if check {
		args = append(args, "--check")
	}
	args = append(args, "--")
	cmd := exec.CommandContext(ctx, "git", args...)
	cmd.Dir = dir
	cmd.Stdin = strings.NewReader(patch)
	var stdout, stderr bytes.Buffer
	cmd.Stdout = &stdout
	cmd.Stderr = &stderr
	err := cmd.Run()
	return stdout.String(), stderr.String(), err
}

func parsePatchFiles(root, patch string) ([]ChangedFile, error) {
	seen := map[string]bool{}
	var files []ChangedFile
	add := func(path string) error {
		path = strings.TrimSpace(path)
		path = strings.TrimPrefix(path, "a/")
		path = strings.TrimPrefix(path, "b/")
		if path == "" || path == "/dev/null" {
			return nil
		}
		clean, err := safeRepoRelPath(root, path)
		if err != nil {
			return err
		}
		if deniedRepoPath(clean) {
			return fmt.Errorf("patch touches denied path %q", clean)
		}
		if !seen[clean] {
			seen[clean] = true
			files = append(files, ChangedFile{Path: clean, Status: "modified"})
		}
		return nil
	}
	for _, line := range strings.Split(patch, "\n") {
		switch {
		case strings.HasPrefix(line, "diff --git "):
			parts := strings.Fields(line)
			if len(parts) >= 4 {
				if err := add(parts[2]); err != nil {
					return nil, err
				}
				if err := add(parts[3]); err != nil {
					return nil, err
				}
			}
		case strings.HasPrefix(line, "+++ "):
			if err := add(strings.TrimSpace(strings.TrimPrefix(line, "+++ "))); err != nil {
				return nil, err
			}
		case strings.HasPrefix(line, "--- "):
			if err := add(strings.TrimSpace(strings.TrimPrefix(line, "--- "))); err != nil {
				return nil, err
			}
		}
	}
	if len(files) == 0 {
		return nil, fmt.Errorf("patch does not contain file paths")
	}
	return files, nil
}

func (a *App) editMarkdownSection(repoID, path string, dryRunInput *bool, edit func(string) (string, error)) (MarkdownEditOutput, error) {
	repo, err := a.resolveRepo(repoID)
	out := MarkdownEditOutput{Repo: repoID, DryRun: dryRunDefault(dryRunInput)}
	if err != nil {
		return out, err
	}
	clean, abs, err := safeRepoFile(repo.Root, path)
	if err != nil {
		return out, err
	}
	if filepath.Ext(clean) != ".md" {
		return out, fmt.Errorf("markdown section tools only edit .md files")
	}
	out.Repo = repo.ID
	out.Root = repo.Root
	out.Path = clean

	data, err := os.ReadFile(abs)
	if err != nil {
		return out, err
	}
	oldText := string(data)
	newText, err := edit(oldText)
	if err != nil {
		var headingErr *HeadingLookupError
		if errors.As(err, &headingErr) {
			out.ClosestHeadings = headingErr.ClosestHeadings
		}
		return out, err
	}
	out.SHA256 = sha256Hex(data)
	out.NewSHA256 = sha256Hex([]byte(newText))
	out.Changed = oldText != newText
	diff, _ := unifiedDiff(clean, oldText, newText)
	out.Diff = truncateMiddle(diff, 80000)
	if out.DryRun || !out.Changed {
		out.OK = true
		return out, nil
	}
	if err := os.WriteFile(abs, []byte(newText), 0644); err != nil {
		return out, err
	}
	out.OK = true
	return out, nil
}

func insertSectionAfterHeading(text, heading, markdown string) (string, error) {
	lines, ending := splitMarkdown(text)
	start, end, err := findUniqueSection(lines, heading)
	if err != nil {
		return "", err
	}
	_ = start
	insert := normalizeMarkdownBlock(markdown)
	var next []string
	next = append(next, lines[:end]...)
	if len(next) > 0 && next[len(next)-1] != "" {
		next = append(next, "")
	}
	next = append(next, strings.Split(strings.TrimSuffix(insert, "\n"), "\n")...)
	if end < len(lines) && lines[end] != "" {
		next = append(next, "")
	}
	next = append(next, lines[end:]...)
	return joinMarkdown(next, ending), nil
}

func replaceSection(text, heading, markdown string) (string, error) {
	lines, ending := splitMarkdown(text)
	start, end, err := findUniqueSection(lines, heading)
	if err != nil {
		return "", err
	}
	block := strings.Split(strings.TrimSuffix(normalizeMarkdownBlock(markdown), "\n"), "\n")
	next := append([]string{}, lines[:start]...)
	next = append(next, block...)
	next = append(next, lines[end:]...)
	return joinMarkdown(next, ending), nil
}

func appendChangelogEntry(text, entryHeading, entryMarkdown string) (string, error) {
	lines, ending := splitMarkdown(text)
	var indexes []int
	for i, line := range lines {
		if changelogHeadingRE.MatchString(line) {
			indexes = append(indexes, i)
		}
	}
	if len(indexes) == 0 {
		return "", fmt.Errorf("changelog heading not found")
	}
	if len(indexes) > 1 {
		return "", fmt.Errorf("changelog heading is ambiguous: found %d matches", len(indexes))
	}
	insertAt := indexes[0] + 1
	for insertAt < len(lines) && strings.TrimSpace(lines[insertAt]) == "" {
		insertAt++
	}
	entry := normalizeMarkdownBlock(entryHeading + "\n\n" + entryMarkdown)
	block := strings.Split(strings.TrimSuffix(entry, "\n"), "\n")
	next := append([]string{}, lines[:insertAt]...)
	next = append(next, block...)
	if insertAt < len(lines) {
		next = append(next, "")
	}
	next = append(next, lines[insertAt:]...)
	return joinMarkdown(next, ending), nil
}

func replaceBetweenMarkers(text, startMarker, endMarker, content string) (string, error) {
	startMarker = strings.TrimRight(startMarker, "\r\n")
	endMarker = strings.TrimRight(endMarker, "\r\n")
	if strings.TrimSpace(startMarker) == "" || strings.TrimSpace(endMarker) == "" {
		return "", fmt.Errorf("start_marker and end_marker are required")
	}
	if startMarker == endMarker {
		return "", fmt.Errorf("start_marker and end_marker must be different")
	}
	lines, ending := splitMarkdown(text)
	startIndexes := matchingLineIndexes(lines, startMarker)
	endIndexes := matchingLineIndexes(lines, endMarker)
	if len(startIndexes) == 0 {
		return "", fmt.Errorf("start_marker not found: %s", startMarker)
	}
	if len(endIndexes) == 0 {
		return "", fmt.Errorf("end_marker not found: %s", endMarker)
	}
	if len(startIndexes) > 1 {
		return "", fmt.Errorf("start_marker is ambiguous: found %d matches", len(startIndexes))
	}
	if len(endIndexes) > 1 {
		return "", fmt.Errorf("end_marker is ambiguous: found %d matches", len(endIndexes))
	}
	start := startIndexes[0]
	end := endIndexes[0]
	if start >= end {
		return "", fmt.Errorf("markers are reversed: start_marker appears after end_marker")
	}
	block := []string{}
	normalized := strings.TrimSuffix(normalizeMarkdownBlock(content), "\n")
	if normalized != "" {
		block = strings.Split(normalized, "\n")
	}
	next := append([]string{}, lines[:start+1]...)
	next = append(next, block...)
	next = append(next, lines[end:]...)
	return joinMarkdown(next, ending), nil
}

func matchingLineIndexes(lines []string, marker string) []int {
	var indexes []int
	for i, line := range lines {
		if line == marker {
			indexes = append(indexes, i)
		}
	}
	return indexes
}

type HeadingLookupError struct {
	Message         string
	ClosestHeadings []string
}

func (e *HeadingLookupError) Error() string {
	if len(e.ClosestHeadings) == 0 {
		return e.Message
	}
	return e.Message + "; closest headings: " + strings.Join(e.ClosestHeadings, ", ")
}

func findUniqueSection(lines []string, heading string) (int, int, error) {
	heading = strings.TrimRight(heading, "\r\n")
	level := headingLevel(heading)
	if level == 0 {
		return 0, 0, fmt.Errorf("heading %q is not a markdown heading", heading)
	}
	var indexes []int
	for i, line := range lines {
		if line == heading {
			indexes = append(indexes, i)
		}
	}
	if len(indexes) == 0 {
		return 0, 0, &HeadingLookupError{
			Message:         fmt.Sprintf("heading not found: %s", heading),
			ClosestHeadings: closestHeadings(lines, heading, 5),
		}
	}
	if len(indexes) > 1 {
		return 0, 0, fmt.Errorf("heading %q is ambiguous: found %d matches", heading, len(indexes))
	}
	start := indexes[0]
	end := len(lines)
	for i := start + 1; i < len(lines); i++ {
		if nextLevel := headingLevel(lines[i]); nextLevel > 0 && nextLevel <= level {
			end = i
			break
		}
	}
	return start, end, nil
}

func closestHeadings(lines []string, target string, limit int) []string {
	type scoredHeading struct {
		heading string
		score   int
	}
	normalizedTarget := normalizeHeadingForScore(target)
	var scored []scoredHeading
	for _, line := range lines {
		if headingLevel(line) == 0 {
			continue
		}
		normalized := normalizeHeadingForScore(line)
		score := editDistance(normalizedTarget, normalized)
		if strings.Contains(normalized, normalizedTarget) || strings.Contains(normalizedTarget, normalized) {
			score -= 5
		}
		scored = append(scored, scoredHeading{heading: line, score: score})
	}
	sort.SliceStable(scored, func(i, j int) bool {
		if scored[i].score == scored[j].score {
			return scored[i].heading < scored[j].heading
		}
		return scored[i].score < scored[j].score
	})
	if limit > len(scored) {
		limit = len(scored)
	}
	out := make([]string, 0, limit)
	for i := 0; i < limit; i++ {
		out = append(out, scored[i].heading)
	}
	return out
}

func normalizeHeadingForScore(value string) string {
	value = strings.TrimSpace(value)
	value = strings.TrimLeft(value, "#")
	return strings.ToLower(strings.TrimSpace(value))
}

func editDistance(a, b string) int {
	if a == b {
		return 0
	}
	if a == "" {
		return len([]rune(b))
	}
	if b == "" {
		return len([]rune(a))
	}
	ar := []rune(a)
	br := []rune(b)
	prev := make([]int, len(br)+1)
	curr := make([]int, len(br)+1)
	for j := range prev {
		prev[j] = j
	}
	for i := 1; i <= len(ar); i++ {
		curr[0] = i
		for j := 1; j <= len(br); j++ {
			cost := 0
			if ar[i-1] != br[j-1] {
				cost = 1
			}
			curr[j] = minInt(curr[j-1]+1, prev[j]+1, prev[j-1]+cost)
		}
		prev, curr = curr, prev
	}
	return prev[len(br)]
}

func minInt(values ...int) int {
	minimum := values[0]
	for _, value := range values[1:] {
		if value < minimum {
			minimum = value
		}
	}
	return minimum
}

func headingLevel(line string) int {
	count := 0
	for count < len(line) && line[count] == '#' {
		count++
	}
	if count == 0 || count > 6 || count >= len(line) || line[count] != ' ' {
		return 0
	}
	return count
}

func splitMarkdown(text string) ([]string, string) {
	ending := "\n"
	if strings.Contains(text, "\r\n") {
		ending = "\r\n"
		text = strings.ReplaceAll(text, "\r\n", "\n")
	}
	return strings.Split(strings.TrimSuffix(text, "\n"), "\n"), ending
}

func joinMarkdown(lines []string, ending string) string {
	return strings.Join(lines, ending) + ending
}

func normalizeMarkdownBlock(markdown string) string {
	markdown = strings.ReplaceAll(markdown, "\r\n", "\n")
	return strings.Trim(markdown, "\n") + "\n"
}

func (a *App) readShelterBootstrapContext(input ReadShelterBootstrapContextInput) (ReadShelterBootstrapContextOutput, error) {
	root := filepath.Clean(a.cfg.RepoRoot)
	maxBytes := boundedMaxBytes(defaultIfZero(input.MaxBytes, defaultBootstrapMaxBytes))
	out := ReadShelterBootstrapContextOutput{
		OK:              true,
		Role:            normalizeEnum(input.Role, "generic"),
		Area:            normalizeEnum(input.Area, "generic"),
		Root:            root,
		MaxBytes:        maxBytes,
		RemainingBudget: maxBytes,
	}
	paths := bootstrapPaths(out.Role, out.Area)
	var builder strings.Builder
	for _, path := range paths {
		clean, abs, err := safeRepoFile(root, path)
		if err != nil {
			out.SkippedPaths = append(out.SkippedPaths, path+": "+err.Error())
			out.PerFileSizes = append(out.PerFileSizes, BootstrapFileDiagnostic{
				Path:     path,
				Included: false,
				Reason:   err.Error(),
			})
			continue
		}
		data, err := os.ReadFile(abs)
		if err != nil {
			out.SkippedPaths = append(out.SkippedPaths, clean+": "+err.Error())
			out.PerFileSizes = append(out.PerFileSizes, BootstrapFileDiagnostic{
				Path:     clean,
				Included: false,
				Reason:   err.Error(),
			})
			continue
		}
		header := "\n\n<!-- " + clean + " -->\n\n"
		diag := BootstrapFileDiagnostic{
			Path:        clean,
			Bytes:       len(data),
			HeaderBytes: len(header),
		}
		if builder.Len()+len(header)+len(data) > maxBytes {
			out.SkippedPaths = append(out.SkippedPaths, clean+": budget exceeded")
			out.Truncated = true
			diag.Included = false
			diag.Reason = "budget exceeded"
			out.PerFileSizes = append(out.PerFileSizes, diag)
			continue
		}
		builder.WriteString(header)
		builder.Write(data)
		out.IncludedPaths = append(out.IncludedPaths, clean)
		diag.Included = true
		diag.Reason = "included"
		out.PerFileSizes = append(out.PerFileSizes, diag)
	}
	out.Content = strings.TrimLeft(builder.String(), "\n")
	out.IncludedBytes = len(out.Content)
	out.RemainingBudget = maxBytes - out.IncludedBytes
	if out.RemainingBudget < 0 {
		out.RemainingBudget = 0
	}
	out.BootstrapSummary = bootstrapSummary(out.IncludedPaths, out.SkippedPaths, out.IncludedBytes, out.RemainingBudget)
	return out, nil
}

func bootstrapPaths(role, area string) []string {
	seen := map[string]bool{}
	var paths []string
	add := func(path string) {
		if !seen[path] {
			seen[path] = true
			paths = append(paths, path)
		}
	}
	add("docs/drive/Shelter/00_START_HERE/BOOTSTRAP_CONTEXT.md")
	switch role {
	case "producer":
		add("docs/drive/Shelter/00_START_HERE/000_ROLE_PRODUCER.md")
	case "project_manager":
		add("docs/drive/Shelter/00_START_HERE/000_ROLE_PROJECT_MANAGER.md")
	case "game_designer":
		add("docs/drive/Shelter/00_START_HERE/000_ROLE_GAME_DESIGNER.md")
	case "art_director":
		add("docs/drive/Shelter/00_START_HERE/000_ROLE_ART_DIRECTOR.md")
	case "codex":
		add("docs/drive/Shelter/00_START_HERE/000_ROLE_CODEX.md")
	}
	if area == "steam" {
		add("docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__CURRENT_CONTEXT.md")
	}
	if role == "codex" || area == "mcp" {
		add("docs/drive/Shelter/04_DEVELOPMENT/CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md")
	}
	if role == "project_manager" || area == "docs" {
		add("docs/drive/Shelter/00_START_HERE/SUPERSEDED_MAP.md")
		add("docs/drive/Shelter/00_START_HERE/05_DOCUMENTATION_GOVERNANCE.md")
	}
	if area == "steam" {
		add("steam/AGENTS.md")
		add("steam/README.md")
	}
	add("PROJECTS_RULES.md")
	add("AGENTS.md")
	add("README.md")
	if role == "codex" || area == "mcp" {
		add("docs/repo/adr/README.md")
	}
	return paths
}

func bootstrapSummary(included, skipped []string, includedBytes, remainingBudget int) string {
	return fmt.Sprintf(
		"included %d file(s), skipped %d file(s), used %d bytes, remaining budget %d bytes",
		len(included),
		len(skipped),
		includedBytes,
		remainingBudget,
	)
}

func (a *App) writeFileIfUnchanged(input WriteFileIfUnchangedInput) (WriteFileIfUnchangedOutput, error) {
	repo, err := a.resolveRepo(input.Repo)
	out := WriteFileIfUnchangedOutput{Repo: input.Repo, DryRun: dryRunDefault(input.DryRun), ExpectedSHA256: input.ExpectedSHA256}
	if err != nil {
		return out, err
	}
	clean, abs, err := safeRepoFile(repo.Root, input.Path)
	if err != nil {
		return out, err
	}
	out.Repo = repo.ID
	out.Root = repo.Root
	out.Path = clean
	current, err := os.ReadFile(abs)
	if err != nil {
		return out, err
	}
	out.CurrentSHA256 = sha256Hex(current)
	expected := strings.ToLower(strings.TrimSpace(input.ExpectedSHA256))
	if expected == "" {
		return out, fmt.Errorf("expected_sha256 is required")
	}
	if out.CurrentSHA256 != expected {
		return out, fmt.Errorf("current sha256 differs from expected")
	}
	out.NewSHA256 = sha256Hex([]byte(input.Content))
	out.Changed = string(current) != input.Content
	diff, _ := unifiedDiff(clean, string(current), input.Content)
	out.Diff = truncateMiddle(diff, 80000)
	if out.DryRun || !out.Changed {
		out.OK = true
		return out, nil
	}
	if err := os.WriteFile(abs, []byte(input.Content), 0644); err != nil {
		return out, err
	}
	out.OK = true
	return out, nil
}

func safeRepoFile(root, rel string) (string, string, error) {
	clean, err := safeRepoRelPath(root, rel)
	if err != nil {
		return "", "", err
	}
	if deniedRepoPath(clean) {
		return "", "", fmt.Errorf("path %q is denied", clean)
	}
	return clean, filepath.Join(root, clean), nil
}

func safeRepoRelPath(root, rel string) (string, error) {
	rel = strings.TrimSpace(rel)
	if rel == "" {
		return "", fmt.Errorf("path cannot be empty")
	}
	if strings.Contains(rel, "\x00") {
		return "", fmt.Errorf("path cannot contain NUL bytes")
	}
	if filepath.IsAbs(rel) {
		return "", fmt.Errorf("path %q must be relative", rel)
	}
	clean := filepath.Clean(rel)
	if clean == "." || clean == ".." || strings.HasPrefix(clean, ".."+string(filepath.Separator)) {
		return "", fmt.Errorf("path %q escapes repo root", rel)
	}
	abs := filepath.Join(root, clean)
	if !pathWithin(abs, root) {
		return "", fmt.Errorf("path %q escapes repo root", rel)
	}
	return filepath.ToSlash(clean), nil
}

func deniedRepoPath(path string) bool {
	path = filepath.ToSlash(strings.TrimSpace(path))
	base := filepath.Base(path)
	lower := strings.ToLower(path)
	if path == "" || strings.HasPrefix(path, ".git/") || path == ".git" {
		return true
	}
	if base == ".env" || strings.HasPrefix(base, ".env.") {
		return true
	}
	if strings.Contains(lower, "secret") || strings.Contains(lower, "token") || strings.Contains(lower, "credential") {
		return true
	}
	switch strings.ToLower(filepath.Ext(base)) {
	case ".pem", ".key", ".p12", ".pfx":
		return true
	}
	return false
}

func dryRunDefault(value *bool) bool {
	if value == nil {
		return true
	}
	return *value
}

func defaultIfZero(value, fallback int) int {
	if value <= 0 {
		return fallback
	}
	return value
}

func boundedMaxBytes(value int) int {
	if value <= 0 {
		return defaultDiffMaxBytes
	}
	if value > maxRepoToolBytes {
		return maxRepoToolBytes
	}
	return value
}

func sha256Hex(data []byte) string {
	sum := sha256.Sum256(data)
	return hex.EncodeToString(sum[:])
}

func normalizeEnum(value, fallback string) string {
	value = strings.ToLower(strings.TrimSpace(value))
	if value == "" {
		return fallback
	}
	return value
}

func unifiedDiff(path, oldText, newText string) (string, error) {
	if oldText == newText {
		return "", nil
	}
	dir, err := os.MkdirTemp("", "shelter-mcp-diff-*")
	if err != nil {
		return "", err
	}
	defer os.RemoveAll(dir)
	oldPath := filepath.Join(dir, "old")
	newPath := filepath.Join(dir, "new")
	if err := os.WriteFile(oldPath, []byte(oldText), 0600); err != nil {
		return "", err
	}
	if err := os.WriteFile(newPath, []byte(newText), 0600); err != nil {
		return "", err
	}
	cmd := exec.Command("diff", "-u", "--label", "a/"+path, "--label", "b/"+path, oldPath, newPath)
	var stdout bytes.Buffer
	cmd.Stdout = &stdout
	err = cmd.Run()
	if err != nil {
		if exit, ok := err.(*exec.ExitError); ok && exit.ExitCode() == 1 {
			return stdout.String(), nil
		}
		return "", err
	}
	return stdout.String(), nil
}

func redactDiff(diff string) string {
	lines := strings.Split(diff, "\n")
	for i, line := range lines {
		lower := strings.ToLower(line)
		if strings.HasPrefix(line, "+") && !strings.HasPrefix(line, "+++") &&
			(strings.Contains(lower, "token") || strings.Contains(lower, "secret") || strings.Contains(lower, "api_key") || strings.Contains(lower, "apikey")) {
			lines[i] = "+<redacted possible secret line>"
		}
	}
	return strings.Join(lines, "\n")
}

func riskFlagsForChanges(files []ChangedFile, truncated bool) []RiskFlag {
	var flags []RiskFlag
	add := func(severity, path, message string) {
		flags = append(flags, RiskFlag{Severity: severity, Path: path, Message: message})
	}
	if truncated {
		add("warning", "", "Diff was truncated")
	}
	if len(files) > 20 {
		add("warning", "", fmt.Sprintf("Touched many files: %d", len(files)))
	}
	for _, file := range files {
		path := filepath.ToSlash(file.Path)
		lower := strings.ToLower(path)
		switch {
		case path == "PROJECTS_RULES.md" || path == "AGENTS.md":
			add("danger", path, "Touched top-level agent/project rules")
		case strings.Contains(path, "/00_START_HERE/000_ROLE_"):
			add("warning", path, "Touched a role document")
		case strings.Contains(path, "/docs/repo/adr/") || strings.Contains(path, "02_DECISIONS.md"):
			add("warning", path, "Touched long-lived decision/ADR material")
		case strings.Contains(path, "99_ARCHIVE") || strings.Contains(lower, "evidence"):
			add("info", path, "Touched archive/evidence material")
		case deniedRepoPath(path):
			add("danger", path, "Touched denied or secrets-looking path")
		case strings.HasSuffix(path, "project.godot") || strings.HasSuffix(path, ".tscn") || strings.HasSuffix(path, ".gd"):
			add("info", path, "Touched Godot/runtime project files")
		}
		if file.Status == "deleted" {
			add("warning", path, "Deleted file")
		}
	}
	return flags
}

func reviewSummary(files []ChangedFile, truncated bool, warnings []string) string {
	if len(files) == 0 {
		return "Working tree is clean."
	}
	parts := []string{fmt.Sprintf("%d changed file(s)", len(files))}
	if truncated {
		parts = append(parts, "diff truncated")
	}
	if len(warnings) > 0 {
		parts = append(parts, fmt.Sprintf("%d warning(s)", len(warnings)))
	}
	return strings.Join(parts, "; ") + "."
}
