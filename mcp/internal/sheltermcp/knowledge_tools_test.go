package sheltermcp

import (
	"path/filepath"
	"strings"
	"testing"
)

func TestFindCurrentContextForCoreAreas(t *testing.T) {
	app := App{cfg: Config{RepoRoot: t.TempDir(), SelfRepoRoot: t.TempDir()}}
	tests := []struct {
		area string
		want []string
	}{
		{
			area: "steam",
			want: []string{
				docBootstrapContext,
				docSteamCurrent,
			},
		},
		{
			area: "mcp",
			want: []string{
				docBootstrapContext,
				docCodexImplementation,
				docCodexCurrentStatus,
			},
		},
		{
			area: "docs",
			want: []string{
				docBootstrapContext,
				docCurrentStatus,
			},
		},
	}
	for _, tt := range tests {
		out, err := app.findCurrentContext(FindCurrentContextInput{Area: tt.area})
		if err != nil {
			t.Fatal(err)
		}
		if !out.OK || out.Area != tt.area {
			t.Fatalf("unexpected current context for %s: %+v", tt.area, out)
		}
		for _, want := range tt.want {
			if !containsString(out.CurrentMemoryPaths, want) {
				t.Fatalf("current context for %s missing %q: %+v", tt.area, want, out.CurrentMemoryPaths)
			}
		}
		if out.HistoryPolicy == "" {
			t.Fatalf("expected history policy for %s", tt.area)
		}
	}
}

func TestListActiveDocsByLayer(t *testing.T) {
	app := App{cfg: Config{RepoRoot: t.TempDir(), SelfRepoRoot: t.TempDir()}}

	current, err := app.listActiveDocs(ListActiveDocsInput{Area: "docs", Layer: "current"})
	if err != nil {
		t.Fatal(err)
	}
	if !docListContains(current.Docs, docBootstrapContext) {
		t.Fatalf("docs/current missing bootstrap context: %+v", current.Docs)
	}
	if docListContains(current.Docs, docGovernance) {
		t.Fatalf("docs/current should not include governance knowledge doc: %+v", current.Docs)
	}

	knowledge, err := app.listActiveDocs(ListActiveDocsInput{Area: "docs", Layer: "knowledge"})
	if err != nil {
		t.Fatal(err)
	}
	for _, want := range []string{docGovernance, docEvidenceReadPolicy, docSupersededMap} {
		if !docListContains(knowledge.Docs, want) {
			t.Fatalf("docs/knowledge missing %q: %+v", want, knowledge.Docs)
		}
	}
}

func TestClassifyDocPathKnownAndUnknown(t *testing.T) {
	app := App{cfg: Config{RepoRoot: t.TempDir(), SelfRepoRoot: t.TempDir()}}

	known, err := app.classifyDocPath(ClassifyDocPathInput{Path: docBootstrapContext})
	if err != nil {
		t.Fatal(err)
	}
	if known.Layer != knowledgeLayerCurrent || known.Status != "current-summary" || known.Confidence != "high" {
		t.Fatalf("unexpected known classification: %+v", known)
	}

	unknown, err := app.classifyDocPath(ClassifyDocPathInput{Path: "docs/drive/Shelter/02_PRODUCTS/unknown.md"})
	if err != nil {
		t.Fatal(err)
	}
	if unknown.Layer != "unknown" || unknown.Status != "unknown" || unknown.Confidence != "low" {
		t.Fatalf("unexpected unknown classification: %+v", unknown)
	}
}

func TestExplainSupersededOldCaptureAndUnknown(t *testing.T) {
	app := App{cfg: Config{RepoRoot: t.TempDir(), SelfRepoRoot: t.TempDir()}}

	out, err := app.explainSuperseded(ExplainSupersededInput{
		Path: "docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v1/README.md",
	})
	if err != nil {
		t.Fatal(err)
	}
	if out.Classification != "evidence/superseded-by-v3" || out.ReadPolicy != "do_not_read_on_bootstrap" {
		t.Fatalf("unexpected superseded explanation: %+v", out)
	}
	if !strings.Contains(out.CurrentSource, "STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v3") {
		t.Fatalf("expected v3 current source: %+v", out)
	}

	unknown, err := app.explainSuperseded(ExplainSupersededInput{Path: "docs/drive/Shelter/00_START_HERE/02_DECISIONS.md"})
	if err != nil {
		t.Fatal(err)
	}
	if unknown.Classification != "unknown" {
		t.Fatalf("expected unknown classification, got %+v", unknown)
	}

	mapDoc, err := app.explainSuperseded(ExplainSupersededInput{Path: docSupersededMap})
	if err != nil {
		t.Fatal(err)
	}
	if mapDoc.Classification != "current/knowledge" {
		t.Fatalf("SUPERSEDED_MAP should stay current, got %+v", mapDoc)
	}
}

func TestKnowledgeGCReportReturnsHistoryEvidenceCandidates(t *testing.T) {
	root := t.TempDir()
	writeFile(t,
		filepath.Join(root, "docs/drive/Shelter/06_SESSIONS_AND_HANDOFFS/2026-07-07_HANDOFF.md"),
		"# Handoff\n",
	)
	writeFile(t,
		filepath.Join(root, "docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v1/README.md"),
		"# Evidence\n",
	)
	writeFile(t,
		filepath.Join(root, "docs/drive/Shelter/99_ARCHIVE/old.md"),
		"# Archive\n",
	)
	writeFile(t,
		filepath.Join(root, "docs/drive/Shelter/04_DEVELOPMENT/SHELTER_MCP__Codex_Brief__Old_v1.md"),
		"# Old brief\n",
	)
	app := App{cfg: Config{RepoRoot: root, SelfRepoRoot: root}}

	out, err := app.knowledgeGCReport(KnowledgeGCReportInput{Area: "docs", MaxEntries: 100})
	if err != nil {
		t.Fatal(err)
	}
	if !out.OK || out.Area != "docs" {
		t.Fatalf("unexpected GC report: %+v", out)
	}
	if !findingListContains(out.HistoryCandidates, "docs/drive/Shelter/06_SESSIONS_AND_HANDOFFS/2026-07-07_HANDOFF.md") {
		t.Fatalf("expected handoff history candidate: %+v", out.HistoryCandidates)
	}
	if !findingListContains(out.HistoryCandidates, "docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v1/README.md") {
		t.Fatalf("expected evidence history candidate: %+v", out.HistoryCandidates)
	}
	if !supersededListContains(out.SupersededCandidates, "steam_first_day_mvp_visible_review_v1") {
		t.Fatalf("expected superseded v1 candidate: %+v", out.SupersededCandidates)
	}
	if len(out.RecommendedNextActions) == 0 {
		t.Fatalf("expected recommended actions")
	}
}

func TestListDecisionsForSteamAndBrowser(t *testing.T) {
	app := App{cfg: Config{RepoRoot: t.TempDir(), SelfRepoRoot: t.TempDir()}}

	steam, err := app.listDecisions(ListDecisionsInput{Area: "steam", Kind: "all"})
	if err != nil {
		t.Fatal(err)
	}
	for _, want := range []string{"D-007", "D-009", "D-013", "D-020"} {
		if !decisionListContains(steam.Decisions, want) {
			t.Fatalf("steam decisions missing %s: %+v", want, steam.Decisions)
		}
	}

	browser, err := app.listDecisions(ListDecisionsInput{Area: "browser", Kind: "all"})
	if err != nil {
		t.Fatal(err)
	}
	for _, want := range []string{"D-008", "D-012", "D-020"} {
		if !decisionListContains(browser.Decisions, want) {
			t.Fatalf("browser decisions missing %s: %+v", want, browser.Decisions)
		}
	}

	unknown, err := app.listDecisions(ListDecisionsInput{Area: "unknown", Kind: "all"})
	if err == nil || unknown.OK {
		t.Fatalf("expected safe error for unknown area, got out=%+v err=%v", unknown, err)
	}
}

func TestGetDecisionD020AndUnknown(t *testing.T) {
	app := App{cfg: Config{RepoRoot: t.TempDir(), SelfRepoRoot: t.TempDir()}}

	out, err := app.getDecision(GetDecisionInput{ID: "D-020"})
	if err != nil {
		t.Fatal(err)
	}
	if !out.OK || !out.Found || out.Decision == nil {
		t.Fatalf("expected D-020 decision, got %+v", out)
	}
	if out.Decision.Title != "Project Philosophy / Shelter Constitution" {
		t.Fatalf("unexpected D-020 title: %+v", out.Decision)
	}
	if !strings.Contains(out.Decision.Summary, "Shelter makes life richer") {
		t.Fatalf("D-020 summary should mention Project Philosophy / Constitution: %+v", out.Decision)
	}

	missing, err := app.getDecision(GetDecisionInput{ID: "D-999"})
	if err != nil {
		t.Fatal(err)
	}
	if missing.OK || missing.Found || len(missing.AvailableIDs) == 0 {
		t.Fatalf("expected structured not-found with available ids, got %+v", missing)
	}
}

func TestListOpenQuestionsForSteamAndDocs(t *testing.T) {
	app := App{cfg: Config{RepoRoot: t.TempDir(), SelfRepoRoot: t.TempDir()}}

	steam, err := app.listOpenQuestions(ListOpenQuestionsInput{Area: "steam", Status: "open"})
	if err != nil {
		t.Fatal(err)
	}
	if !openQuestionListContains(steam.Questions, "OQ-Steam-001") {
		t.Fatalf("steam open questions missing OQ-Steam-001: %+v", steam.Questions)
	}

	docs, err := app.listOpenQuestions(ListOpenQuestionsInput{Area: "docs", Status: "all"})
	if err != nil {
		t.Fatal(err)
	}
	if !openQuestionListContains(docs.Questions, "OQ-Docs-001") {
		t.Fatalf("docs open questions missing OQ-Docs-001: %+v", docs.Questions)
	}
}

func TestListRoadmapsDocsIncludesKnowledgeBaseRoadmap(t *testing.T) {
	app := App{cfg: Config{RepoRoot: t.TempDir(), SelfRepoRoot: t.TempDir()}}

	out, err := app.listRoadmaps(ListRoadmapsInput{Area: "docs"})
	if err != nil {
		t.Fatal(err)
	}
	if !roadmapListContains(out.Roadmaps, docKnowledgeBaseRoadmap) {
		t.Fatalf("docs roadmaps missing KNOWLEDGE_BASE_ROADMAP.md: %+v", out.Roadmaps)
	}
}

func TestLatestHandoffProducerDocs(t *testing.T) {
	root := t.TempDir()
	writeFile(t,
		filepath.Join(root, "docs/drive/Shelter/06_SESSIONS_AND_HANDOFFS/producer/2026-07-07__producer_handoff__documentation_governance_and_gc.md"),
		"# Producer / PM Handoff\n",
	)
	app := App{cfg: Config{RepoRoot: root, SelfRepoRoot: t.TempDir()}}

	out, err := app.latestHandoff(LatestHandoffInput{Role: "producer", Area: "docs"})
	if err != nil {
		t.Fatal(err)
	}
	if !out.OK || out.Handoff == nil {
		t.Fatalf("expected latest handoff, got %+v", out)
	}
	if out.Handoff.Date != "2026-07-07" || !strings.Contains(out.Handoff.Path, "documentation_governance_and_gc") {
		t.Fatalf("expected 2026-07-07 docs/governance handoff, got %+v", out.Handoff)
	}
	if !out.Handoff.Available {
		t.Fatalf("expected handoff to be marked available: %+v", out.Handoff)
	}
}

func TestKnowledgeTaskContextProjectManagerDocsCleanup(t *testing.T) {
	app := App{cfg: Config{RepoRoot: t.TempDir(), SelfRepoRoot: t.TempDir()}}

	out, err := app.knowledgeTaskContext(KnowledgeTaskContextInput{
		Role: "project_manager",
		Area: "docs",
		Task: "cleanup",
	})
	if err != nil {
		t.Fatal(err)
	}
	if !out.OK {
		t.Fatalf("expected OK context, got %+v", out)
	}
	for _, want := range []string{docGovernance, docSupersededMap, docEvidenceReadPolicy, docCodexCurrentStatus, docOpenQuestions} {
		if !containsString(out.Context.ReadFirst, want) && !containsString(out.Context.ReadByTask, want) {
			t.Fatalf("cleanup context missing %q: %+v", want, out.Context)
		}
	}
}

func TestDecisionDigestSteamAndBrowser(t *testing.T) {
	app := App{cfg: Config{RepoRoot: t.TempDir(), SelfRepoRoot: t.TempDir()}}

	steam, err := app.decisionDigest(DecisionDigestInput{Area: "steam"})
	if err != nil {
		t.Fatal(err)
	}
	for _, want := range []string{"D-007", "D-009", "D-013", "D-020"} {
		if !decisionDigestContains(steam.Digest, want) {
			t.Fatalf("steam decision digest missing %s: %+v", want, steam.Digest)
		}
	}
	if steam.SourcePath != docDecisions || steam.ReadFullPolicy == "" {
		t.Fatalf("expected source path and read policy: %+v", steam)
	}

	browser, err := app.decisionDigest(DecisionDigestInput{Area: "browser"})
	if err != nil {
		t.Fatal(err)
	}
	for _, want := range []string{"D-008", "D-012", "D-020"} {
		if !decisionDigestContains(browser.Digest, want) {
			t.Fatalf("browser decision digest missing %s: %+v", want, browser.Digest)
		}
	}

	unknown, err := app.decisionDigest(DecisionDigestInput{Area: "unknown"})
	if err == nil || unknown.OK {
		t.Fatalf("expected safe error for unknown area, got out=%+v err=%v", unknown, err)
	}
}

func TestShelterStatusSteamAndDocs(t *testing.T) {
	root := t.TempDir()
	writeFile(t,
		filepath.Join(root, "docs/drive/Shelter/06_SESSIONS_AND_HANDOFFS/producer/2026-07-07__producer_pm_handoff__knowledge_base_phase_2_cleanup.md"),
		"# Phase 2 cleanup handoff\n",
	)
	app := App{cfg: Config{RepoRoot: root, SelfRepoRoot: t.TempDir()}}

	steam, err := app.shelterStatus(ShelterStatusInput{Area: "steam"})
	if err != nil {
		t.Fatal(err)
	}
	if !strings.Contains(steam.Dashboard.CurrentScope, "First Week / Day 2") {
		t.Fatalf("steam status should include First Week / Day 2: %+v", steam.Dashboard)
	}
	if !strings.Contains(steam.Dashboard.CurrentTask, "R-28") {
		t.Fatalf("steam status should include R-28: %+v", steam.Dashboard)
	}
	if !decisionDigestContains(steam.Dashboard.ActiveDecisions, "D-007") || !openQuestionDigestContains(steam.Dashboard.ActiveOpenQuestions, "OQ-Steam-001") {
		t.Fatalf("steam status missing expected decisions/questions: %+v", steam.Dashboard)
	}

	docs, err := app.shelterStatus(ShelterStatusInput{Area: "docs"})
	if err != nil {
		t.Fatal(err)
	}
	if !strings.Contains(docs.Dashboard.CurrentPhase, "Knowledge Base Polish Roadmap") {
		t.Fatalf("docs status should include Knowledge Base Polish Roadmap: %+v", docs.Dashboard)
	}
	if docs.Dashboard.CurrentRoadmap != docKnowledgeBasePolishRoadmap {
		t.Fatalf("docs status should point to polish roadmap: %+v", docs.Dashboard)
	}
	if docs.Dashboard.LatestHandoff == nil || !strings.Contains(docs.Dashboard.LatestHandoff.Path, "knowledge_base_phase_2_cleanup") {
		t.Fatalf("docs status should include phase 2 cleanup handoff: %+v", docs.Dashboard.LatestHandoff)
	}
}

func TestOpenQuestionsDigestSteamAndBrowser(t *testing.T) {
	app := App{cfg: Config{RepoRoot: t.TempDir(), SelfRepoRoot: t.TempDir()}}

	steam, err := app.openQuestionsDigest(OpenQuestionsDigestInput{Area: "steam", Status: "all"})
	if err != nil {
		t.Fatal(err)
	}
	for _, want := range []string{"OQ-Steam-001", "OQ-Steam-002", "OQ-Steam-003"} {
		if !openQuestionDigestContains(steam.Digest, want) {
			t.Fatalf("steam open questions digest missing %s: %+v", want, steam.Digest)
		}
	}

	browser, err := app.openQuestionsDigest(OpenQuestionsDigestInput{Area: "browser", Status: "all"})
	if err != nil {
		t.Fatal(err)
	}
	for _, want := range []string{"OQ-Browser-001", "OQ-Platform-001", "OQ-Charity-001"} {
		if !openQuestionDigestContains(browser.Digest, want) {
			t.Fatalf("browser open questions digest missing related %s: %+v", want, browser.Digest)
		}
	}
}

func TestCurrentEntryDigestGameDesignerSteam(t *testing.T) {
	app := App{cfg: Config{RepoRoot: t.TempDir(), SelfRepoRoot: t.TempDir()}}

	out, err := app.currentEntryDigest(CurrentEntryDigestInput{Role: "game_designer", Area: "steam"})
	if err != nil {
		t.Fatal(err)
	}
	if !out.OK {
		t.Fatalf("expected OK digest, got %+v", out)
	}
	if !containsString(out.Digest.ReadFirst, docGameDesignCurrent) {
		t.Fatalf("game designer steam entry should include GAME_DESIGN__CURRENT_CONTEXT.md: %+v", out.Digest)
	}
}

func containsString(values []string, want string) bool {
	for _, value := range values {
		if value == want {
			return true
		}
	}
	return false
}

func docListContains(docs []KnowledgeDoc, want string) bool {
	for _, doc := range docs {
		if doc.Path == want {
			return true
		}
	}
	return false
}

func findingListContains(findings []KnowledgePathFinding, want string) bool {
	for _, finding := range findings {
		if finding.Path == want {
			return true
		}
	}
	return false
}

func supersededListContains(findings []SupersededExplanation, pattern string) bool {
	for _, finding := range findings {
		if strings.Contains(finding.Path, pattern) {
			return true
		}
	}
	return false
}

func decisionListContains(decisions []KnowledgeDecision, want string) bool {
	for _, decision := range decisions {
		if decision.ID == want {
			return true
		}
	}
	return false
}

func openQuestionListContains(questions []OpenQuestion, want string) bool {
	for _, question := range questions {
		if question.ID == want {
			return true
		}
	}
	return false
}

func roadmapListContains(roadmaps []KnowledgeRoadmap, want string) bool {
	for _, roadmap := range roadmaps {
		if roadmap.Path == want {
			return true
		}
	}
	return false
}

func decisionDigestContains(decisions []DecisionDigestItem, want string) bool {
	for _, decision := range decisions {
		if decision.ID == want {
			return true
		}
	}
	return false
}

func openQuestionDigestContains(questions []OpenQuestionDigestItem, want string) bool {
	for _, question := range questions {
		if question.ID == want {
			return true
		}
	}
	return false
}
