package sheltermcp

import (
	"reflect"
	"strings"
	"testing"
)

func newKnowledgeTestApp(t *testing.T) App {
	t.Helper()
	return App{cfg: Config{RepoRoot: repositoryRootForKnowledgeTest(t)}}
}

func TestLegacyDecisionProjectionsAreSourceDerived(t *testing.T) {
	app := newKnowledgeTestApp(t)
	out, err := app.listDecisions(ListDecisionsInput{Area: "all", Kind: "all"})
	if err != nil {
		t.Fatal(err)
	}
	for _, id := range []string{"D-022", "D-023", "D-024", "D-025", "D-026"} {
		if !decisionListContains(out.Decisions, id) {
			t.Fatalf("source-derived legacy decision projection missing %s: %+v", id, out.Decisions)
		}
	}
	d026, err := app.getDecision(GetDecisionInput{ID: "D-026"})
	if err != nil {
		t.Fatal(err)
	}
	if !d026.OK || d026.Decision == nil || !strings.Contains(d026.Decision.Title, "source-derived context bridge") {
		t.Fatalf("get_decision did not return current D-026 source block: %+v", d026)
	}
	digest, err := app.decisionDigest(DecisionDigestInput{Area: "mcp", MaxItems: maxDigestItems})
	if err != nil {
		t.Fatal(err)
	}
	if !decisionDigestContains(digest.Digest, "D-026") {
		t.Fatalf("decision digest missing D-026: %+v", digest)
	}
	for _, decision := range out.Decisions {
		if !validDecisionKinds[decision.Kind] || decision.Kind == "all" {
			t.Fatalf("legacy decision %s returned unsupported kind %q", decision.ID, decision.Kind)
		}
	}
	steamProduct, err := app.listDecisions(ListDecisionsInput{Area: "steam", Kind: "product"})
	if err != nil {
		t.Fatal(err)
	}
	if !decisionListContains(steamProduct.Decisions, "D-010") {
		t.Fatalf("canonical game-design decision D-010 must remain queryable through legacy kind=product: %+v", steamProduct.Decisions)
	}
}

func TestLegacyOpenQuestionProjectionsExcludeResolvedSteamQuestions(t *testing.T) {
	app := newKnowledgeTestApp(t)
	out, err := app.listOpenQuestions(ListOpenQuestionsInput{Area: "steam", Status: "all"})
	if err != nil {
		t.Fatal(err)
	}
	for _, resolved := range []string{"OQ-Steam-001", "OQ-Steam-002"} {
		if openQuestionListContains(out.Questions, resolved) {
			t.Fatalf("resolved %s leaked into active source projection: %+v", resolved, out.Questions)
		}
	}
	if !openQuestionListContains(out.Questions, "OQ-Steam-003") {
		t.Fatalf("active OQ-Steam-003 missing: %+v", out.Questions)
	}
	digest, err := app.openQuestionsDigest(OpenQuestionsDigestInput{Area: "steam", Status: "all"})
	if err != nil {
		t.Fatal(err)
	}
	if !openQuestionDigestContains(digest.Digest, "OQ-Steam-003") || openQuestionDigestContains(digest.Digest, "OQ-Steam-001") {
		t.Fatalf("open-question digest is not source-current: %+v", digest)
	}
}

func TestLegacyRoadmapProjectionMatchesSnapshot(t *testing.T) {
	app := newKnowledgeTestApp(t)
	out, err := app.listRoadmaps(ListRoadmapsInput{Area: "docs"})
	if err != nil {
		t.Fatal(err)
	}
	snapshot, err := app.knowledgeSnapshot()
	if err != nil {
		t.Fatal(err)
	}
	want := roadmapsFor(snapshot, "docs")
	if !reflect.DeepEqual(out.Roadmaps, want) {
		t.Fatalf("legacy roadmap projection diverged from snapshot:\n got=%+v\nwant=%+v", out.Roadmaps, want)
	}
	for _, roadmap := range out.Roadmaps {
		if strings.Contains(roadmap.CurrentPhase, "First Week") || strings.Contains(roadmap.NextStep, "R-28") {
			t.Fatalf("stale roadmap fact returned: %+v", roadmap)
		}
	}
}

func TestLegacyDocumentRoutingUsesSourceMetadata(t *testing.T) {
	app := newKnowledgeTestApp(t)
	current, err := app.findCurrentContext(FindCurrentContextInput{Area: "mcp"})
	if err != nil {
		t.Fatal(err)
	}
	for _, path := range []string{docBootstrapContext, docCodexCurrentStatus, docCodexImplementation} {
		if !containsString(current.CurrentMemoryPaths, path) {
			t.Fatalf("MCP current routing missing %s: %+v", path, current)
		}
	}
	docs, err := app.listActiveDocs(ListActiveDocsInput{Area: "docs", Layer: "knowledge"})
	if err != nil {
		t.Fatal(err)
	}
	for _, path := range []string{docGovernance, docEvidenceReadPolicy} {
		if !docListContains(docs.Docs, path) {
			t.Fatalf("source metadata projection missing %s: %+v", path, docs.Docs)
		}
	}
	currentDocs, err := app.listActiveDocs(ListActiveDocsInput{Area: "docs", Layer: "current"})
	if err != nil {
		t.Fatal(err)
	}
	if !docListContains(currentDocs.Docs, docSupersededMap) {
		t.Fatalf("source status must classify SUPERSEDED_MAP current-summary as Current Memory: %+v", currentDocs.Docs)
	}
	classification, err := app.classifyDocPath(ClassifyDocPathInput{Path: docBootstrapContext})
	if err != nil {
		t.Fatal(err)
	}
	if classification.Layer != knowledgeLayerCurrent || classification.Confidence != "high" {
		t.Fatalf("source document classification mismatch: %+v", classification)
	}
}

func TestLegacyHandoffProjectionUsesCurrentIndex(t *testing.T) {
	app := newKnowledgeTestApp(t)
	out, err := app.latestHandoff(LatestHandoffInput{Role: "codex", Area: "mcp"})
	if err != nil {
		t.Fatal(err)
	}
	if !out.OK || out.Handoff == nil || out.Handoff.Path != docWorkflowMigrationHandoff || out.Handoff.SourceType != "handoff-index" {
		t.Fatalf("latest handoff did not come from HANDOFF_INDEX: %+v", out)
	}
}

func TestLegacyStatusUsesCurrentSourceFields(t *testing.T) {
	app := newKnowledgeTestApp(t)
	out, err := app.shelterStatus(ShelterStatusInput{Area: "docs"})
	if err != nil {
		t.Fatal(err)
	}
	if !out.OK || out.Dashboard.CurrentFocus == "" || out.Dashboard.CurrentPhase == "" || out.Dashboard.CurrentTask == "" {
		t.Fatalf("source-derived status is incomplete: %+v", out)
	}
	joined := out.Dashboard.CurrentFocus + out.Dashboard.CurrentScope + out.Dashboard.CurrentPhase + out.Dashboard.CurrentTask
	if strings.Contains(joined, "First Week") || strings.Contains(joined, "R-28") {
		t.Fatalf("legacy status returned stale current facts: %+v", out.Dashboard)
	}
	if !decisionDigestContains(out.Dashboard.ActiveDecisions, "D-026") {
		t.Fatalf("legacy status missing current D-026: %+v", out.Dashboard.ActiveDecisions)
	}
}

func TestLegacyRoleAndTaskRoutingRequiresHealthySnapshot(t *testing.T) {
	app := newKnowledgeTestApp(t)
	entry, err := app.currentEntryDigest(CurrentEntryDigestInput{Role: "game_designer", Area: "steam"})
	if err != nil {
		t.Fatal(err)
	}
	if !containsString(entry.Digest.ReadFirst, docGameDesignCurrent) {
		t.Fatalf("game designer route missing current context: %+v", entry.Digest)
	}
	context, err := app.knowledgeTaskContext(KnowledgeTaskContextInput{Role: "project_manager", Area: "docs", Task: "cleanup"})
	if err != nil {
		t.Fatal(err)
	}
	for _, path := range []string{docGovernance, docSupersededMap, docEvidenceReadPolicy, docOpenQuestions} {
		if !containsString(context.Context.ReadFirst, path) && !containsString(context.Context.ReadByTask, path) {
			t.Fatalf("PM cleanup route missing %s: %+v", path, context.Context)
		}
	}

	broken := App{cfg: Config{RepoRoot: t.TempDir()}}
	if _, err := broken.listDecisions(ListDecisionsInput{Area: "mcp", Kind: "all"}); err == nil || !strings.Contains(err.Error(), "missing_required_source") {
		t.Fatalf("unhealthy source must explicit-fail legacy projection, got %v", err)
	}
}

func TestSupersededAndGCProjectionsReadCurrentMap(t *testing.T) {
	app := newKnowledgeTestApp(t)
	out, err := app.explainSuperseded(ExplainSupersededInput{Path: "docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v1/README.md"})
	if err != nil {
		t.Fatal(err)
	}
	if !strings.Contains(out.Classification, "superseded-by-v3") || !strings.Contains(strings.ToLower(out.CurrentSource), "v3") {
		t.Fatalf("SUPERSEDED_MAP projection mismatch: %+v", out)
	}
	unknown, err := app.explainSuperseded(ExplainSupersededInput{Path: docDecisions})
	if err != nil {
		t.Fatal(err)
	}
	if unknown.Classification != "unknown" {
		t.Fatalf("active decision doc must not be marked superseded: %+v", unknown)
	}
	report, err := app.knowledgeGCReport(KnowledgeGCReportInput{Area: "docs", MaxEntries: 20})
	if err != nil {
		t.Fatal(err)
	}
	if !report.OK || len(report.CurrentMemory) == 0 || len(report.Knowledge) == 0 || len(report.RecommendedNextActions) == 0 {
		t.Fatalf("source-derived GC report incomplete: %+v", report)
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
