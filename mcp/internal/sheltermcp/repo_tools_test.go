package sheltermcp

import (
	"context"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"testing"
	"time"
)

func TestGitStatusDiffAndApplyPatchDryRun(t *testing.T) {
	root := newGitRepo(t)
	writeFile(t, filepath.Join(root, "docs", "note.md"), "# Note\n\nold\n")
	runGitTestCommand(t, root, "add", ".")
	runGitTestCommand(t, root, "commit", "-m", "initial")
	writeFile(t, filepath.Join(root, "docs", "note.md"), "# Note\n\nnew\n")

	app := App{cfg: Config{RepoRoot: root}}
	ctx := context.Background()

	status, err := app.gitStatus(ctx, "shelter")
	if err != nil {
		t.Fatal(err)
	}
	if status.IsClean {
		t.Fatalf("expected dirty repo")
	}
	if len(status.ChangedFiles) != 1 || status.ChangedFiles[0].Path != "docs/note.md" {
		t.Fatalf("unexpected changed files: %+v", status.ChangedFiles)
	}

	diff, err := app.gitDiff(ctx, GitDiffInput{Repo: "shelter", Paths: []string{"docs/note.md"}})
	if err != nil {
		t.Fatal(err)
	}
	if !strings.Contains(diff.Diff, "-old") || !strings.Contains(diff.Diff, "+new") {
		t.Fatalf("unexpected diff: %s", diff.Diff)
	}

	if _, err := app.gitDiff(ctx, GitDiffInput{Repo: "shelter", Paths: []string{"../escape.md"}}); err == nil {
		t.Fatalf("expected escaping path to fail")
	}

	patch := strings.Join([]string{
		"diff --git a/docs/note.md b/docs/note.md",
		"--- a/docs/note.md",
		"+++ b/docs/note.md",
		"@@ -1,3 +1,3 @@",
		" # Note",
		" ",
		"-new",
		"+patched",
		"",
	}, "\n")
	dryRun := true
	applied, err := app.applyPatch(ctx, ApplyPatchInput{Repo: "shelter", Patch: patch, DryRun: &dryRun})
	if err != nil {
		t.Fatal(err)
	}
	if !applied.AppliesCleanly || !applied.DryRun {
		t.Fatalf("unexpected apply output: %+v", applied)
	}
	data, err := os.ReadFile(filepath.Join(root, "docs", "note.md"))
	if err != nil {
		t.Fatal(err)
	}
	if strings.Contains(string(data), "patched") {
		t.Fatalf("dry-run patch modified file")
	}
}

func TestMCPRepoIDIsRejectedAsASeparateRepository(t *testing.T) {
	root := newGitRepo(t)
	app := App{cfg: Config{RepoRoot: root}}

	_, err := app.resolveRepo("mcp")
	if err == nil || !strings.Contains(err.Error(), "use repo shelter and paths under mcp/") {
		t.Fatalf("expected explicit monorepo-path error, got %v", err)
	}
}

func TestMarkdownSectionToolsWriteAndRejectAmbiguousHeading(t *testing.T) {
	root := newGitRepo(t)
	path := filepath.Join(root, "CHANGELOG.md")
	writeFile(t, path, "# Project\n\n## Changelog\n\n### Old\n\n- old\n\n## Notes\n\nx\n")

	write := false
	app := App{cfg: Config{RepoRoot: root}}
	out, err := app.editMarkdownSection("shelter", "CHANGELOG.md", &write, func(text string) (string, error) {
		return appendChangelogEntry(text, "### 2026-07-07 - Added repo tools", "- git diff helpers")
	})
	if err != nil {
		t.Fatal(err)
	}
	if !out.OK || !out.Changed || out.NewSHA256 == "" {
		t.Fatalf("unexpected markdown edit output: %+v", out)
	}
	data, err := os.ReadFile(path)
	if err != nil {
		t.Fatal(err)
	}
	text := string(data)
	if !strings.Contains(text, "### 2026-07-07 - Added repo tools") {
		t.Fatalf("changelog entry was not written: %s", text)
	}
	if strings.Index(text, "2026-07-07") > strings.Index(text, "### Old") {
		t.Fatalf("new changelog entry was not inserted first: %s", text)
	}

	_, err = replaceSection("# T\n\n## A\nx\n\n## A\ny\n", "## A", "## A\nz\n")
	if err == nil || !strings.Contains(err.Error(), "ambiguous") {
		t.Fatalf("expected ambiguous heading error, got %v", err)
	}
}

func TestApplyPatchRejectsDeniedPath(t *testing.T) {
	root := newGitRepo(t)
	app := App{cfg: Config{RepoRoot: root}}
	patch := strings.Join([]string{
		"diff --git a/.env b/.env",
		"new file mode 100644",
		"--- /dev/null",
		"+++ b/.env",
		"@@ -0,0 +1 @@",
		"+TOKEN=secret",
		"",
	}, "\n")
	_, err := app.applyPatch(context.Background(), ApplyPatchInput{Repo: "shelter", Patch: patch})
	if err == nil || !strings.Contains(err.Error(), "denied") {
		t.Fatalf("expected denied path error, got %v", err)
	}
}

func TestBootstrapContextPrioritizesCurrentDocsUnderLowBudgets(t *testing.T) {
	root := t.TempDir()
	createBootstrapFixture(t, root)
	writeFile(t, filepath.Join(root, "PROJECTS_RULES.md"), "# Rules\n\n"+strings.Repeat("rules\n", 9000))
	writeFile(t, filepath.Join(root, "AGENTS.md"), "# Agents\n\n"+strings.Repeat("agents\n", 9000))
	writeFile(t, filepath.Join(root, "README.md"), "# Readme\n\n"+strings.Repeat("readme\n", 9000))

	app := App{cfg: Config{RepoRoot: root}}

	codex, err := app.readShelterBootstrapContext(ReadShelterBootstrapContextInput{
		Role:     "codex",
		Area:     "mcp",
		MaxBytes: 40000,
	})
	if err != nil {
		t.Fatal(err)
	}
	assertIncludedPaths(t, codex.IncludedPaths,
		"docs/drive/Shelter/00_START_HERE/BOOTSTRAP_CONTEXT.md",
		"docs/drive/Shelter/00_START_HERE/000_ROLE_CODEX.md",
		"docs/drive/Shelter/04_DEVELOPMENT/CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md",
	)
	assertOrderedBefore(t, codex.PerFileSizes, "docs/drive/Shelter/00_START_HERE/BOOTSTRAP_CONTEXT.md", "PROJECTS_RULES.md")
	if codex.IncludedBytes == 0 || codex.RemainingBudget < 0 || codex.BootstrapSummary == "" {
		t.Fatalf("expected useful diagnostics: %+v", codex)
	}
	if len(codex.PerFileSizes) == 0 {
		t.Fatalf("expected per-file diagnostics")
	}

	producer, err := app.readShelterBootstrapContext(ReadShelterBootstrapContextInput{
		Role:     "producer",
		Area:     "steam",
		MaxBytes: 30000,
	})
	if err != nil {
		t.Fatal(err)
	}
	assertIncludedPaths(t, producer.IncludedPaths,
		"docs/drive/Shelter/00_START_HERE/BOOTSTRAP_CONTEXT.md",
		"docs/drive/Shelter/00_START_HERE/000_ROLE_PRODUCER.md",
		"docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__CURRENT_CONTEXT.md",
	)
}

func TestProjectManagerDocsBootstrapIncludesGovernanceDoc(t *testing.T) {
	root := t.TempDir()
	createBootstrapFixture(t, root)
	app := App{cfg: Config{RepoRoot: root}}

	out, err := app.readShelterBootstrapContext(ReadShelterBootstrapContextInput{
		Role:     "project_manager",
		Area:     "docs",
		MaxBytes: 50000,
	})
	if err != nil {
		t.Fatal(err)
	}
	assertIncludedPaths(t, out.IncludedPaths,
		"docs/drive/Shelter/00_START_HERE/BOOTSTRAP_CONTEXT.md",
		"docs/drive/Shelter/00_START_HERE/000_ROLE_PROJECT_MANAGER.md",
		"docs/drive/Shelter/00_START_HERE/SUPERSEDED_MAP.md",
		"docs/drive/Shelter/00_START_HERE/05_DOCUMENTATION_GOVERNANCE.md",
	)
	assertOrderedBefore(t, out.PerFileSizes,
		"docs/drive/Shelter/00_START_HERE/SUPERSEDED_MAP.md",
		"docs/drive/Shelter/00_START_HERE/05_DOCUMENTATION_GOVERNANCE.md",
	)

	tiny, err := app.readShelterBootstrapContext(ReadShelterBootstrapContextInput{
		Role:     "project_manager",
		Area:     "docs",
		MaxBytes: 80,
	})
	if err != nil {
		t.Fatal(err)
	}
	foundBudgetReason := false
	for _, item := range tiny.PerFileSizes {
		if item.Path == "docs/drive/Shelter/00_START_HERE/05_DOCUMENTATION_GOVERNANCE.md" && item.Reason == "budget exceeded" {
			foundBudgetReason = true
			break
		}
	}
	if !foundBudgetReason {
		t.Fatalf("expected explicit budget exceeded diagnostic for governance doc: %+v", tiny.PerFileSizes)
	}
}

func TestGitDiffForReviewFocusAndStats(t *testing.T) {
	root := newGitRepo(t)
	writeFile(t, filepath.Join(root, "docs", "note.md"), "# Note\n\nold\n")
	writeFile(t, filepath.Join(root, "internal", "main.go"), "package main\n\nfunc main() {}\n")
	writeFile(t, filepath.Join(root, "captures", "frame.png"), "old-image\n")
	runGitTestCommand(t, root, "add", ".")
	runGitTestCommand(t, root, "commit", "-m", "initial")

	writeFile(t, filepath.Join(root, "docs", "note.md"), "# Note\n\nnew\n")
	writeFile(t, filepath.Join(root, "internal", "main.go"), "package main\n\nfunc main() { println(\"hi\") }\n")
	writeFile(t, filepath.Join(root, "captures", "frame.png"), "new-image\n")

	app := App{cfg: Config{RepoRoot: root}}
	_, out, err := app.GitDiffForReview(context.Background(), nil, GitDiffForReviewInput{
		Repo:  "shelter",
		Focus: "docs",
	})
	if err != nil {
		t.Fatal(err)
	}
	if !slicesEqual(out.DiffPaths, []string{"docs/note.md"}) {
		t.Fatalf("expected docs-only diff paths, got %+v", out.DiffPaths)
	}
	if !strings.Contains(out.Diff, "+new") || strings.Contains(out.Diff, "println") {
		t.Fatalf("unexpected focused diff: %s", out.Diff)
	}
	if out.ReviewStats.FilesChanged != 3 || out.ReviewStats.MarkdownFiles != 1 || out.ReviewStats.GoFiles != 1 || out.ReviewStats.DiffFiles != 1 {
		t.Fatalf("unexpected review stats: %+v", out.ReviewStats)
	}
	if out.ReviewStats.Insertions == 0 || out.ReviewStats.Deletions == 0 {
		t.Fatalf("expected numstat insertions/deletions: %+v", out.ReviewStats)
	}
	if len(out.OmittedPaths) == 0 {
		t.Fatalf("expected omitted paths for docs focus")
	}
}

func TestReplaceBetweenMarkersAndClosestHeadingErrors(t *testing.T) {
	root := newGitRepo(t)
	path := filepath.Join(root, "README.md")
	writeFile(t, path, "# Project\n\n## Follow-up\n\nold\n\n<!-- START: daily -->\nold body\n<!-- END: daily -->\n")

	write := false
	app := App{cfg: Config{RepoRoot: root}}
	out, err := app.editMarkdownSection("shelter", "README.md", &write, func(text string) (string, error) {
		return replaceBetweenMarkers(text, "<!-- START: daily -->", "<!-- END: daily -->", "new body\n- item")
	})
	if err != nil {
		t.Fatal(err)
	}
	if !out.OK || !out.Changed || !strings.Contains(out.Diff, "+new body") {
		t.Fatalf("unexpected marker replacement output: %+v", out)
	}
	data, err := os.ReadFile(path)
	if err != nil {
		t.Fatal(err)
	}
	text := string(data)
	if !strings.Contains(text, "<!-- START: daily -->\nnew body\n- item\n<!-- END: daily -->") {
		t.Fatalf("markers were not preserved with replaced content: %s", text)
	}

	out, err = app.editMarkdownSection("shelter", "README.md", nil, func(text string) (string, error) {
		return replaceSection(text, "## Followup", "## Followup\nnew\n")
	})
	if err == nil {
		t.Fatalf("expected missing heading error")
	}
	if len(out.ClosestHeadings) == 0 || out.ClosestHeadings[0] != "## Follow-up" {
		t.Fatalf("expected closest heading suggestion, got %+v; err=%v", out.ClosestHeadings, err)
	}
}

func newGitRepo(t *testing.T) string {
	t.Helper()
	root := t.TempDir()
	runGitTestCommand(t, root, "init")
	runGitTestCommand(t, root, "config", "user.email", "codex@example.invalid")
	runGitTestCommand(t, root, "config", "user.name", "Codex Test")
	return root
}

func createBootstrapFixture(t *testing.T, root string) {
	t.Helper()
	files := map[string]string{
		"docs/drive/Shelter/00_START_HERE/BOOTSTRAP_CONTEXT.md":                             "# Bootstrap\n\ncurrent summary\n",
		"docs/drive/Shelter/00_START_HERE/000_ROLE_CODEX.md":                                "# Codex role\n",
		"docs/drive/Shelter/00_START_HERE/000_ROLE_PROJECT_MANAGER.md":                      "# Project manager role\n",
		"docs/drive/Shelter/00_START_HERE/000_ROLE_PRODUCER.md":                             "# Producer role\n",
		"docs/drive/Shelter/00_START_HERE/SUPERSEDED_MAP.md":                                "# Superseded map\n",
		"docs/drive/Shelter/00_START_HERE/05_DOCUMENTATION_GOVERNANCE.md":                   "# Documentation governance\n",
		"docs/drive/Shelter/04_DEVELOPMENT/CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md":        "# Codex current\n",
		"docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__CURRENT_CONTEXT.md": "# Steam current\n",
		"docs/repo/adr/README.md":                                                           "# ADR index\n",
		"steam/AGENTS.md":                                                                   "# Steam agents\n",
		"steam/README.md":                                                                   "# Steam readme\n",
	}
	for path, content := range files {
		writeFile(t, filepath.Join(root, path), content)
	}
}

func assertIncludedPaths(t *testing.T, actual []string, expected ...string) {
	t.Helper()
	for _, path := range expected {
		found := false
		for _, item := range actual {
			if item == path {
				found = true
				break
			}
		}
		if !found {
			t.Fatalf("expected included path %q in %+v", path, actual)
		}
	}
}

func assertOrderedBefore(t *testing.T, diagnostics []BootstrapFileDiagnostic, before, after string) {
	t.Helper()
	beforeIndex := -1
	afterIndex := -1
	for i, item := range diagnostics {
		if item.Path == before {
			beforeIndex = i
		}
		if item.Path == after {
			afterIndex = i
		}
	}
	if beforeIndex == -1 || afterIndex == -1 || beforeIndex >= afterIndex {
		t.Fatalf("expected %q before %q in diagnostics: %+v", before, after, diagnostics)
	}
}

func slicesEqual(a, b []string) bool {
	if len(a) != len(b) {
		return false
	}
	for i := range a {
		if a[i] != b[i] {
			return false
		}
	}
	return true
}

func runGitTestCommand(t *testing.T, dir string, args ...string) {
	t.Helper()
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()
	cmd := exec.CommandContext(ctx, "git", args...)
	cmd.Dir = dir
	output, err := cmd.CombinedOutput()
	if err != nil {
		t.Fatalf("git %s failed: %v\n%s", strings.Join(args, " "), err, string(output))
	}
}

func writeFile(t *testing.T, path, content string) {
	t.Helper()
	if err := os.MkdirAll(filepath.Dir(path), 0755); err != nil {
		t.Fatal(err)
	}
	if err := os.WriteFile(path, []byte(content), 0644); err != nil {
		t.Fatal(err)
	}
}
