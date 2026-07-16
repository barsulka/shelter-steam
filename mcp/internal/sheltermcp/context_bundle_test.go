package sheltermcp

import (
	"context"
	"encoding/json"
	"reflect"
	"strings"
	"testing"

	"github.com/modelcontextprotocol/go-sdk/mcp"
)

func TestContextBundleDefaultBudgetAndDeterminism(t *testing.T) {
	snapshot, err := loadKnowledgeSourceSnapshot(repositoryRootForKnowledgeTest(t), knowledgeSnapshotOptions{})
	if err != nil {
		t.Fatal(err)
	}
	input := ContextBundleInput{Role: "codex", Area: "mcp", Task: "implementation"}
	first, err := buildContextBundle(snapshot, input)
	if err != nil {
		t.Fatal(err)
	}
	second, err := buildContextBundle(snapshot, input)
	if err != nil {
		t.Fatal(err)
	}
	if !reflect.DeepEqual(first, second) {
		t.Fatalf("same sources and input must produce an identical bundle")
	}
	encoded, err := json.Marshal(first)
	if err != nil {
		t.Fatal(err)
	}
	if first.Budget.RequestedBytes != defaultContextBundleBytes || len(encoded) > defaultContextBundleBytes {
		t.Fatalf("default bundle budget mismatch: budget=%+v encoded=%d", first.Budget, len(encoded))
	}
	if first.Budget.EncodedBytes != len(encoded) {
		t.Fatalf("encoded byte accounting mismatch: reported=%d actual=%d", first.Budget.EncodedBytes, len(encoded))
	}
	if first.Health != "current" || len(first.CurrentTruth) == 0 || len(first.Decisions) == 0 {
		t.Fatalf("healthy bundle is missing current projections: %+v", first)
	}
	for index := 1; index < len(first.Sources); index++ {
		if first.Sources[index-1].Path > first.Sources[index].Path {
			t.Fatalf("sources are not stably ordered: %+v", first.Sources)
		}
	}
	for index := 1; index < len(first.BlockHashes); index++ {
		if first.BlockHashes[index-1].Key > first.BlockHashes[index].Key {
			t.Fatalf("block hashes are not stably ordered: %+v", first.BlockHashes)
		}
	}
}

func TestContextBundleToolUsesShortTextContent(t *testing.T) {
	app := App{cfg: Config{RepoRoot: repositoryRootForKnowledgeTest(t)}}
	result, out, err := app.ShelterContextBundle(context.Background(), &mcp.CallToolRequest{}, ContextBundleInput{Role: "codex", Area: "mcp", Task: "D-026"})
	if err != nil {
		t.Fatal(err)
	}
	if result.IsError || out.Health != "current" || result.StructuredContent == nil {
		t.Fatalf("healthy context bundle tool failed: result=%+v out=%+v", result, out)
	}
	content := result.Content[0].(*mcp.TextContent).Text
	if len(content) > 256 || strings.Contains(content, `"schema_version"`) || strings.Contains(content, out.CurrentTruth[0].Excerpt) {
		t.Fatalf("text Content must remain a short status without structured payload copy: %q", content)
	}
}

func TestContextBundleHardCap(t *testing.T) {
	snapshot, err := loadKnowledgeSourceSnapshot(repositoryRootForKnowledgeTest(t), knowledgeSnapshotOptions{})
	if err != nil {
		t.Fatal(err)
	}
	bundle, err := buildContextBundle(snapshot, ContextBundleInput{
		Role:     "project_manager",
		Area:     "docs",
		Task:     "D-026 context routing",
		MaxBytes: hardContextBundleBytes * 2,
	})
	if err != nil {
		t.Fatal(err)
	}
	encoded, err := json.Marshal(bundle)
	if err != nil {
		t.Fatal(err)
	}
	if bundle.Budget.RequestedBytes != hardContextBundleBytes || len(encoded) > hardContextBundleBytes {
		t.Fatalf("hard cap mismatch: budget=%+v encoded=%d", bundle.Budget, len(encoded))
	}
}

func TestContextBundleMinimumBudgetUsesExplicitOmission(t *testing.T) {
	snapshot, err := loadKnowledgeSourceSnapshot(repositoryRootForKnowledgeTest(t), knowledgeSnapshotOptions{})
	if err != nil {
		t.Fatal(err)
	}
	bundle, err := buildContextBundle(snapshot, ContextBundleInput{Role: "codex", Area: "mcp", Task: "bounded", MaxBytes: minimumContextBundleBytes})
	if err != nil {
		t.Fatal(err)
	}
	encoded, err := json.Marshal(bundle)
	if err != nil {
		t.Fatal(err)
	}
	if len(encoded) > minimumContextBundleBytes {
		t.Fatalf("minimum budget exceeded: %d", len(encoded))
	}
	if !bundle.Budget.Truncated || len(bundle.Budget.Omitted) == 0 || !bundle.Fallback.Required {
		t.Fatalf("minimum budget omission must be explicit: %+v", bundle.Budget)
	}
}

func TestContextBundleHashSummaries(t *testing.T) {
	snapshot, err := loadKnowledgeSourceSnapshot(repositoryRootForKnowledgeTest(t), knowledgeSnapshotOptions{})
	if err != nil {
		t.Fatal(err)
	}
	for _, test := range []struct {
		name  string
		input ContextBundleInput
	}{
		{name: "codex_mcp", input: ContextBundleInput{Role: "codex", Area: "mcp", Task: "D-026 implementation", MaxBytes: defaultContextBundleBytes}},
		{name: "project_manager_docs", input: ContextBundleInput{Role: "project_manager", Area: "docs", Task: "D-026 context routing", MaxBytes: defaultContextBundleBytes}},
	} {
		t.Run(test.name, func(t *testing.T) {
			bundle, buildErr := buildContextBundle(snapshot, test.input)
			if buildErr != nil {
				t.Fatal(buildErr)
			}
			encoded, marshalErr := json.Marshal(bundle)
			if marshalErr != nil {
				t.Fatal(marshalErr)
			}
			t.Logf("encoded_bytes=%d sha256=%s health=%s omitted=%v fallback=%t", len(encoded), knowledgeSHA256(encoded), bundle.Health, bundle.Budget.Omitted, bundle.Fallback.Required)
		})
	}
}

func TestContextBundleTaskChangesDeterministicRouting(t *testing.T) {
	snapshot, err := loadKnowledgeSourceSnapshot(repositoryRootForKnowledgeTest(t), knowledgeSnapshotOptions{})
	if err != nil {
		t.Fatal(err)
	}
	tasks := []string{
		"implement MCP remediation",
		"review accepted decision",
		"prepare session handoff",
		"verify source-derived context routing",
	}
	routes := make([][]string, 0, len(tasks))
	for _, task := range tasks {
		bundle, buildErr := buildContextBundle(snapshot, ContextBundleInput{Role: "codex", Area: "mcp", Task: task})
		if buildErr != nil {
			t.Fatal(buildErr)
		}
		routes = append(routes, bundle.ReadNext)
	}
	for index := 0; index < len(routes); index++ {
		for other := index + 1; other < len(routes); other++ {
			if reflect.DeepEqual(routes[index], routes[other]) {
				t.Fatalf("task categories %q and %q must produce distinct deterministic routes: %v", tasks[index], tasks[other], routes[index])
			}
		}
	}
	wantPriorities := []string{docCodexCurrentStatus, docDecisions, docHandoffIndex, docGovernance}
	for index, want := range wantPriorities {
		if len(routes[index]) < 6 || routes[index][5] != want {
			t.Fatalf("task %q must prioritize %s after mandatory bootstrap/role sources: %v", tasks[index], want, routes[index])
		}
	}
}
