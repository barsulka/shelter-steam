package sheltermcp

import (
	"os"
	"path/filepath"
	"strings"
	"testing"
)

func TestKnowledgeSourceSnapshotDerivesCurrentFacts(t *testing.T) {
	root := repositoryRootForKnowledgeTest(t)
	snapshot, err := loadKnowledgeSourceSnapshot(root, knowledgeSnapshotOptions{})
	if err != nil {
		t.Fatal(err)
	}

	for _, id := range []string{"D-022", "D-023", "D-024", "D-025", "D-026"} {
		if !snapshotDecisionExists(snapshot, id) {
			t.Fatalf("source snapshot is missing %s", id)
		}
	}
	for _, id := range []string{"OQ-Steam-001", "OQ-Steam-002"} {
		if snapshotOpenQuestionExists(snapshot, id) {
			t.Fatalf("resolved question %s must not be active", id)
		}
	}
	if !snapshotOpenQuestionExists(snapshot, "OQ-Steam-003") {
		t.Fatalf("OQ-Steam-003 must remain active")
	}

	foundCurrentRoadmap := false
	for _, roadmap := range snapshot.Roadmaps {
		if strings.Contains(roadmap.CurrentPhase, "D-026") || strings.Contains(roadmap.NextStep, "Source-Derived MCP Context Bridge") {
			foundCurrentRoadmap = true
		}
		if strings.Contains(roadmap.CurrentPhase, "First Week") || strings.Contains(roadmap.NextStep, "R-28") {
			t.Fatalf("roadmap returned stale current state: %+v", roadmap)
		}
	}
	if !foundCurrentRoadmap {
		t.Fatalf("source snapshot did not derive current D-026 roadmap state: %+v", snapshot.Roadmaps)
	}

	if len(snapshot.Sources) == 0 || len(snapshot.BlockHashes) == 0 {
		t.Fatalf("snapshot must expose file and block provenance")
	}
	for _, source := range snapshot.Sources {
		if source.Path == "" || source.FileSHA256 == "" || source.Bytes <= 0 {
			t.Fatalf("invalid source provenance: %+v", source)
		}
	}
}

func TestKnowledgeSourceSnapshotMissingRequiredSource(t *testing.T) {
	_, err := loadKnowledgeSourceSnapshot(t.TempDir(), knowledgeSnapshotOptions{})
	if err == nil || !strings.Contains(err.Error(), "missing_required_source AGENTS.md") {
		t.Fatalf("expected deterministic missing source error, got %v", err)
	}
}

func TestKnowledgeParserRejectsMalformedDecisionBlock(t *testing.T) {
	source := `# decisions

## 1. Decision index

| ID | Status |
| --- | --- |
| D-026 | Accepted |

## 2. Accepted decisions

### D-026 — Context bridge

Kind: technical
Area: MCP
Status: Accepted
`
	_, err := parseKnowledgeDecisions(source)
	if err == nil || !strings.Contains(err.Error(), "malformed decision block D-026") {
		t.Fatalf("expected malformed decision error, got %v", err)
	}
}

func TestKnowledgeParserRejectsMalformedDocumentMetadata(t *testing.T) {
	_, err := parseKnowledgeDocumentMetadata(knowledgeDocumentRoute{Path: "missing-status.md", Areas: []string{"docs"}}, "# Missing status\n\nPurpose without metadata.\n")
	if err == nil || err.Error() != "malformed metadata missing-status.md: status and purpose are required" {
		t.Fatalf("expected deterministic malformed metadata error, got %v", err)
	}
}

func TestKnowledgeParserRejectsDuplicateDecisionIDs(t *testing.T) {
	source := `# decisions

## 1. Decision index

| ID | Status |
| --- | --- |
| D-026 | Accepted |
| D-026 | Accepted |

## 2. Accepted decisions

### D-026 — Context bridge

Kind: technical
Area: MCP
Status: Accepted
Summary:

> source-derived bridge
`
	_, err := parseKnowledgeDecisions(source)
	if err == nil || err.Error() != "duplicate decision id D-026 in index" {
		t.Fatalf("expected deterministic duplicate id error, got %v", err)
	}
}

func TestSourceDecisionKindRejectsUnrepresentableCanonicalKind(t *testing.T) {
	if _, err := sourceDecisionKind("unclassified concern"); err == nil {
		t.Fatal("unrepresentable canonical decision kind must explicit-fail instead of leaking a non-legacy enum")
	}
}

func TestKnowledgeSourceChangedDuringRead(t *testing.T) {
	root := t.TempDir()
	path := "source.md"
	abs := filepath.Join(root, path)
	if err := os.WriteFile(abs, []byte("first\n"), 0o600); err != nil {
		t.Fatal(err)
	}
	_, err := readStableKnowledgeSource(root, path, knowledgeSnapshotOptions{AfterFirstRead: func(readPath string) {
		if readPath != path {
			t.Fatalf("unexpected source path %q", readPath)
		}
		if writeErr := os.WriteFile(abs, []byte("second\n"), 0o600); writeErr != nil {
			t.Fatal(writeErr)
		}
	}})
	if err == nil || err.Error() != "source_changed_during_read source.md" {
		t.Fatalf("expected deterministic source change error, got %v", err)
	}
}

func repositoryRootForKnowledgeTest(t *testing.T) string {
	t.Helper()
	wd, err := os.Getwd()
	if err != nil {
		t.Fatal(err)
	}
	for dir := wd; ; dir = filepath.Dir(dir) {
		if _, err := os.Stat(filepath.Join(dir, "PROJECTS_RULES.md")); err == nil {
			return dir
		}
		parent := filepath.Dir(dir)
		if parent == dir {
			t.Fatalf("could not find repository root from %s", wd)
		}
	}
}

func snapshotDecisionExists(snapshot KnowledgeSourceSnapshot, id string) bool {
	for _, decision := range snapshot.Decisions {
		if decision.ID == id {
			return true
		}
	}
	return false
}

func snapshotOpenQuestionExists(snapshot KnowledgeSourceSnapshot, id string) bool {
	for _, question := range snapshot.ActiveOpenQuestions {
		if question.ID == id {
			return true
		}
	}
	return false
}
