package sheltermcp

import (
	"context"
	"fmt"
	"path/filepath"
	"strings"

	"github.com/modelcontextprotocol/go-sdk/mcp"
)

type FindCurrentContextInput struct {
	Area string `json:"area,omitempty" jsonschema:"steam|mcp|docs|browser|mobile|generic; default generic"`
}

type FindCurrentContextOutput struct {
	OK                 bool     `json:"ok"`
	Area               string   `json:"area"`
	CurrentMemoryPaths []string `json:"current_memory_paths"`
	KnowledgePaths     []string `json:"knowledge_paths"`
	HistoryPolicy      string   `json:"history_policy"`
	Notes              []string `json:"notes,omitempty"`
	Error              string   `json:"error,omitempty"`
}

func (a *App) FindCurrentContext(_ context.Context, _ *mcp.CallToolRequest, input FindCurrentContextInput) (*mcp.CallToolResult, FindCurrentContextOutput, error) {
	out, err := a.findCurrentContext(input)
	if err != nil {
		out.OK = false
		out.Error = err.Error()
		return structuredToolError(out), out, nil
	}
	return structuredResult(out), out, nil
}

type ListDecisionsInput struct {
	Area string `json:"area,omitempty" jsonschema:"steam|mcp|docs|browser|mobile|shared|generic; default generic"`
	Kind string `json:"kind,omitempty" jsonschema:"all|product|technical|process|documentation|ethics; default all"`
}

type ListDecisionsOutput struct {
	OK        bool                `json:"ok"`
	Area      string              `json:"area"`
	Kind      string              `json:"kind"`
	Decisions []KnowledgeDecision `json:"decisions"`
	Error     string              `json:"error,omitempty"`
}

func (a *App) ListDecisions(_ context.Context, _ *mcp.CallToolRequest, input ListDecisionsInput) (*mcp.CallToolResult, ListDecisionsOutput, error) {
	out, err := a.listDecisions(input)
	if err != nil {
		out.OK = false
		out.Error = err.Error()
		return structuredToolError(out), out, nil
	}
	return structuredResult(out), out, nil
}

func (a *App) listDecisions(input ListDecisionsInput) (ListDecisionsOutput, error) {
	area, err := normalizeDecisionArea(input.Area)
	out := ListDecisionsOutput{Area: input.Area, Kind: input.Kind}
	if err != nil {
		return out, err
	}
	kind, err := normalizeDecisionKind(input.Kind)
	if err != nil {
		out.Area = area
		return out, err
	}
	out = ListDecisionsOutput{
		OK:        true,
		Area:      area,
		Kind:      kind,
		Decisions: decisionsFor(area, kind),
	}
	return out, nil
}

type DecisionDigestInput struct {
	Area     string `json:"area,omitempty" jsonschema:"steam|browser|docs|mcp|mobile|shared|all|generic; default generic"`
	MaxItems int    `json:"max_items,omitempty" jsonschema:"maximum digest items; default 20, hard cap 50"`
}

type DecisionDigestOutput struct {
	OK             bool                 `json:"ok"`
	Area           string               `json:"area"`
	MaxItems       int                  `json:"max_items"`
	Digest         []DecisionDigestItem `json:"digest"`
	SourcePath     string               `json:"source_path"`
	ReadFullPolicy string               `json:"read_full_policy"`
	Error          string               `json:"error,omitempty"`
}

func (a *App) DecisionDigest(_ context.Context, _ *mcp.CallToolRequest, input DecisionDigestInput) (*mcp.CallToolResult, DecisionDigestOutput, error) {
	out, err := a.decisionDigest(input)
	if err != nil {
		out.OK = false
		out.Error = err.Error()
		return structuredToolError(out), out, nil
	}
	return structuredResult(out), out, nil
}

func (a *App) decisionDigest(input DecisionDigestInput) (DecisionDigestOutput, error) {
	area, err := normalizeDecisionArea(input.Area)
	out := DecisionDigestOutput{Area: input.Area, MaxItems: input.MaxItems}
	if err != nil {
		return out, err
	}
	maxItems := digestMaxItems(input.MaxItems)
	out = DecisionDigestOutput{
		OK:             true,
		Area:           area,
		MaxItems:       maxItems,
		Digest:         decisionDigestFor(area, maxItems),
		SourcePath:     docDecisions,
		ReadFullPolicy: "Open full 02_DECISIONS.md only when exact decision wording is needed.",
	}
	return out, nil
}

type GetDecisionInput struct {
	ID string `json:"id" jsonschema:"decision id such as D-020"`
}

type GetDecisionOutput struct {
	OK           bool               `json:"ok"`
	Found        bool               `json:"found"`
	ID           string             `json:"id"`
	Decision     *KnowledgeDecision `json:"decision,omitempty"`
	AvailableIDs []string           `json:"available_ids,omitempty"`
	Error        string             `json:"error,omitempty"`
}

func (a *App) GetDecision(_ context.Context, _ *mcp.CallToolRequest, input GetDecisionInput) (*mcp.CallToolResult, GetDecisionOutput, error) {
	out, err := a.getDecision(input)
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

func (a *App) getDecision(input GetDecisionInput) (GetDecisionOutput, error) {
	id := strings.ToUpper(strings.TrimSpace(input.ID))
	if id == "" {
		return GetDecisionOutput{}, fmt.Errorf("id is required")
	}
	decision, ok := decisionByID(id)
	if !ok {
		return GetDecisionOutput{
			OK:           false,
			Found:        false,
			ID:           id,
			AvailableIDs: decisionIDs(),
			Error:        fmt.Sprintf("decision %q was not found", id),
		}, nil
	}
	return GetDecisionOutput{
		OK:       true,
		Found:    true,
		ID:       id,
		Decision: &decision,
	}, nil
}

type ListOpenQuestionsInput struct {
	Area   string `json:"area,omitempty" jsonschema:"steam|docs|browser|mobile|shared|charity|platform|generic; default generic"`
	Status string `json:"status,omitempty" jsonschema:"open|partially_resolved|deferred|needs_research|all; default open"`
}

type ListOpenQuestionsOutput struct {
	OK        bool           `json:"ok"`
	Area      string         `json:"area"`
	Status    string         `json:"status"`
	Questions []OpenQuestion `json:"questions"`
	Error     string         `json:"error,omitempty"`
}

func (a *App) ListOpenQuestions(_ context.Context, _ *mcp.CallToolRequest, input ListOpenQuestionsInput) (*mcp.CallToolResult, ListOpenQuestionsOutput, error) {
	out, err := a.listOpenQuestions(input)
	if err != nil {
		out.OK = false
		out.Error = err.Error()
		return structuredToolError(out), out, nil
	}
	return structuredResult(out), out, nil
}

func (a *App) listOpenQuestions(input ListOpenQuestionsInput) (ListOpenQuestionsOutput, error) {
	area, err := normalizeOpenQuestionArea(input.Area)
	out := ListOpenQuestionsOutput{Area: input.Area, Status: input.Status}
	if err != nil {
		return out, err
	}
	status, err := normalizeOpenQuestionStatus(input.Status)
	if err != nil {
		out.Area = area
		return out, err
	}
	out = ListOpenQuestionsOutput{
		OK:        true,
		Area:      area,
		Status:    status,
		Questions: openQuestionsFor(area, status),
	}
	return out, nil
}

type OpenQuestionsDigestInput struct {
	Area   string `json:"area,omitempty" jsonschema:"steam|docs|browser|mobile|shared|charity|platform|generic; default generic"`
	Status string `json:"status,omitempty" jsonschema:"open|needs_research|all; default open"`
}

type OpenQuestionsDigestOutput struct {
	OK             bool                     `json:"ok"`
	Area           string                   `json:"area"`
	Status         string                   `json:"status"`
	Digest         []OpenQuestionDigestItem `json:"digest"`
	SourcePath     string                   `json:"source_path"`
	ReadFullPolicy string                   `json:"read_full_policy"`
	Error          string                   `json:"error,omitempty"`
}

func (a *App) OpenQuestionsDigest(_ context.Context, _ *mcp.CallToolRequest, input OpenQuestionsDigestInput) (*mcp.CallToolResult, OpenQuestionsDigestOutput, error) {
	out, err := a.openQuestionsDigest(input)
	if err != nil {
		out.OK = false
		out.Error = err.Error()
		return structuredToolError(out), out, nil
	}
	return structuredResult(out), out, nil
}

func (a *App) openQuestionsDigest(input OpenQuestionsDigestInput) (OpenQuestionsDigestOutput, error) {
	area, err := normalizeOpenQuestionArea(input.Area)
	out := OpenQuestionsDigestOutput{Area: input.Area, Status: input.Status}
	if err != nil {
		return out, err
	}
	status := normalizeEnum(input.Status, "open")
	if status != "open" && status != "needs_research" && status != "all" {
		return out, fmt.Errorf("unsupported open question digest status %q; expected open, needs_research, or all", status)
	}
	out = OpenQuestionsDigestOutput{
		OK:             true,
		Area:           area,
		Status:         status,
		Digest:         openQuestionsDigestFor(area, status),
		SourcePath:     docOpenQuestions,
		ReadFullPolicy: "Open full 03_OPEN_QUESTIONS.md only when exact question wording or sources are needed.",
	}
	return out, nil
}

type ListRoadmapsInput struct {
	Area string `json:"area,omitempty" jsonschema:"steam|docs|mcp|game_design|art_direction|generic; default generic"`
}

type ListRoadmapsOutput struct {
	OK       bool               `json:"ok"`
	Area     string             `json:"area"`
	Roadmaps []KnowledgeRoadmap `json:"roadmaps"`
	Error    string             `json:"error,omitempty"`
}

func (a *App) ListRoadmaps(_ context.Context, _ *mcp.CallToolRequest, input ListRoadmapsInput) (*mcp.CallToolResult, ListRoadmapsOutput, error) {
	out, err := a.listRoadmaps(input)
	if err != nil {
		out.OK = false
		out.Error = err.Error()
		return structuredToolError(out), out, nil
	}
	return structuredResult(out), out, nil
}

func (a *App) listRoadmaps(input ListRoadmapsInput) (ListRoadmapsOutput, error) {
	area, err := normalizeRoadmapArea(input.Area)
	out := ListRoadmapsOutput{Area: input.Area}
	if err != nil {
		return out, err
	}
	out = ListRoadmapsOutput{
		OK:       true,
		Area:     area,
		Roadmaps: roadmapsFor(area),
	}
	return out, nil
}

type LatestHandoffInput struct {
	Role string `json:"role,omitempty" jsonschema:"producer|project_manager|game_designer|art_director|codex|generic; default generic"`
	Area string `json:"area,omitempty" jsonschema:"steam|docs|mcp|generic; default generic"`
}

type LatestHandoffOutput struct {
	OK             bool               `json:"ok"`
	Role           string             `json:"role"`
	Area           string             `json:"area"`
	Handoff        *KnowledgeHandoff  `json:"handoff,omitempty"`
	MatchedHandoff []KnowledgeHandoff `json:"matched_handoffs,omitempty"`
	Error          string             `json:"error,omitempty"`
}

func (a *App) LatestHandoff(_ context.Context, _ *mcp.CallToolRequest, input LatestHandoffInput) (*mcp.CallToolResult, LatestHandoffOutput, error) {
	out, err := a.latestHandoff(input)
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

func (a *App) latestHandoff(input LatestHandoffInput) (LatestHandoffOutput, error) {
	role, err := normalizeKnowledgeRole(input.Role)
	out := LatestHandoffOutput{Role: input.Role, Area: input.Area}
	if err != nil {
		return out, err
	}
	area, err := normalizeHandoffArea(input.Area)
	if err != nil {
		out.Role = role
		return out, err
	}
	handoff, matches := latestHandoffFor(a.cfg.RepoRoot, role, area)
	if len(matches) == 0 {
		return LatestHandoffOutput{
			OK:    false,
			Role:  role,
			Area:  area,
			Error: "no handoff is cataloged for this role/area",
		}, nil
	}
	return LatestHandoffOutput{
		OK:             true,
		Role:           role,
		Area:           area,
		Handoff:        &handoff,
		MatchedHandoff: matches,
	}, nil
}

type ShelterStatusInput struct {
	Area string `json:"area,omitempty" jsonschema:"steam|docs|mcp|browser|mobile|generic; default generic"`
}

type ShelterStatusOutput struct {
	OK        bool                   `json:"ok"`
	Dashboard ShelterStatusDashboard `json:"dashboard"`
	Error     string                 `json:"error,omitempty"`
}

func (a *App) ShelterStatus(_ context.Context, _ *mcp.CallToolRequest, input ShelterStatusInput) (*mcp.CallToolResult, ShelterStatusOutput, error) {
	out, err := a.shelterStatus(input)
	if err != nil {
		out.OK = false
		out.Error = err.Error()
		return structuredToolError(out), out, nil
	}
	return structuredResult(out), out, nil
}

func (a *App) shelterStatus(input ShelterStatusInput) (ShelterStatusOutput, error) {
	area, err := normalizeStatusArea(input.Area)
	out := ShelterStatusOutput{}
	if err != nil {
		return out, err
	}
	return ShelterStatusOutput{
		OK:        true,
		Dashboard: statusDashboardFor(a.cfg.RepoRoot, area),
	}, nil
}

type KnowledgeTaskContextInput struct {
	Role string `json:"role,omitempty" jsonschema:"producer|project_manager|game_designer|art_director|codex|generic; default generic"`
	Area string `json:"area,omitempty" jsonschema:"steam|docs|mcp|browser|mobile|generic; default generic"`
	Task string `json:"task,omitempty" jsonschema:"decision|implementation|cleanup|art_review|game_design|research|handoff|generic; default generic"`
}

type KnowledgeTaskContextOutput struct {
	OK      bool                 `json:"ok"`
	Context KnowledgeTaskContext `json:"context"`
	Error   string               `json:"error,omitempty"`
}

func (a *App) KnowledgeTaskContext(_ context.Context, _ *mcp.CallToolRequest, input KnowledgeTaskContextInput) (*mcp.CallToolResult, KnowledgeTaskContextOutput, error) {
	out, err := a.knowledgeTaskContext(input)
	if err != nil {
		out.OK = false
		out.Error = err.Error()
		return structuredToolError(out), out, nil
	}
	return structuredResult(out), out, nil
}

func (a *App) knowledgeTaskContext(input KnowledgeTaskContextInput) (KnowledgeTaskContextOutput, error) {
	role, err := normalizeKnowledgeRole(input.Role)
	out := KnowledgeTaskContextOutput{}
	if err != nil {
		return out, err
	}
	area, err := normalizeTaskArea(input.Area)
	if err != nil {
		return out, err
	}
	task, err := normalizeTaskKind(input.Task)
	if err != nil {
		return out, err
	}
	return KnowledgeTaskContextOutput{
		OK:      true,
		Context: taskContextFor(role, area, task),
	}, nil
}

type CurrentEntryDigestInput struct {
	Role string `json:"role,omitempty" jsonschema:"producer|project_manager|game_designer|art_director|codex|generic; default generic"`
	Area string `json:"area,omitempty" jsonschema:"steam|docs|mcp|browser|mobile|generic; default generic"`
}

type CurrentEntryDigestOutput struct {
	OK     bool               `json:"ok"`
	Digest CurrentEntryDigest `json:"digest"`
	Error  string             `json:"error,omitempty"`
}

func (a *App) CurrentEntryDigest(_ context.Context, _ *mcp.CallToolRequest, input CurrentEntryDigestInput) (*mcp.CallToolResult, CurrentEntryDigestOutput, error) {
	out, err := a.currentEntryDigest(input)
	if err != nil {
		out.OK = false
		out.Error = err.Error()
		return structuredToolError(out), out, nil
	}
	return structuredResult(out), out, nil
}

func (a *App) currentEntryDigest(input CurrentEntryDigestInput) (CurrentEntryDigestOutput, error) {
	role, err := normalizeKnowledgeRole(input.Role)
	out := CurrentEntryDigestOutput{}
	if err != nil {
		return out, err
	}
	area, err := normalizeTaskArea(input.Area)
	if err != nil {
		return out, err
	}
	return CurrentEntryDigestOutput{
		OK:     true,
		Digest: currentEntryDigestFor(role, area),
	}, nil
}

func (a *App) findCurrentContext(input FindCurrentContextInput) (FindCurrentContextOutput, error) {
	area, err := normalizeKnowledgeArea(input.Area)
	out := FindCurrentContextOutput{Area: input.Area}
	if err != nil {
		return out, err
	}
	out = FindCurrentContextOutput{
		OK:                 true,
		Area:               area,
		CurrentMemoryPaths: knowledgeDocPaths(catalogDocsFor(area, "current")),
		KnowledgePaths:     knowledgeDocPaths(catalogDocsFor(area, "knowledge")),
		HistoryPolicy:      "Do not read history unless evidence/regression/archaeology is needed.",
		Notes:              knowledgeAreaNotes(area),
	}
	return out, nil
}

type ListActiveDocsInput struct {
	Area  string `json:"area,omitempty" jsonschema:"steam|mcp|docs|browser|mobile|generic; default generic"`
	Layer string `json:"layer,omitempty" jsonschema:"current|knowledge|history|all; default current"`
}

type ListActiveDocsOutput struct {
	OK    bool           `json:"ok"`
	Area  string         `json:"area"`
	Layer string         `json:"layer"`
	Docs  []KnowledgeDoc `json:"docs"`
	Notes []string       `json:"notes,omitempty"`
	Error string         `json:"error,omitempty"`
}

func (a *App) ListActiveDocs(_ context.Context, _ *mcp.CallToolRequest, input ListActiveDocsInput) (*mcp.CallToolResult, ListActiveDocsOutput, error) {
	out, err := a.listActiveDocs(input)
	if err != nil {
		out.OK = false
		out.Error = err.Error()
		return structuredToolError(out), out, nil
	}
	return structuredResult(out), out, nil
}

func (a *App) listActiveDocs(input ListActiveDocsInput) (ListActiveDocsOutput, error) {
	area, err := normalizeKnowledgeArea(input.Area)
	out := ListActiveDocsOutput{Area: input.Area, Layer: input.Layer}
	if err != nil {
		return out, err
	}
	layer, err := normalizeKnowledgeLayer(input.Layer)
	if err != nil {
		out.Area = area
		return out, err
	}
	out = ListActiveDocsOutput{
		OK:    true,
		Area:  area,
		Layer: layer,
		Docs:  catalogDocsFor(area, layer),
		Notes: knowledgeAreaNotes(area),
	}
	return out, nil
}

type ExplainSupersededInput struct {
	Path string `json:"path" jsonschema:"relative Shelter doc path or path fragment"`
}

type ExplainSupersededOutput struct {
	SupersededExplanation
	Error string `json:"error,omitempty"`
}

func (a *App) ExplainSuperseded(_ context.Context, _ *mcp.CallToolRequest, input ExplainSupersededInput) (*mcp.CallToolResult, ExplainSupersededOutput, error) {
	out, err := a.explainSuperseded(input)
	if err != nil {
		out.OK = false
		out.Error = err.Error()
		return structuredToolError(out), out, nil
	}
	return structuredResult(out), out, nil
}

func (a *App) explainSuperseded(input ExplainSupersededInput) (ExplainSupersededOutput, error) {
	if input.Path == "" {
		return ExplainSupersededOutput{}, fmt.Errorf("path is required")
	}
	explanation := explainSupersededPath(input.Path)
	return ExplainSupersededOutput{SupersededExplanation: explanation}, nil
}

type ClassifyDocPathInput struct {
	Path string `json:"path" jsonschema:"relative Shelter doc path or path fragment"`
}

type ClassifyDocPathOutput struct {
	KnowledgePathClassification
	Error string `json:"error,omitempty"`
}

func (a *App) ClassifyDocPath(_ context.Context, _ *mcp.CallToolRequest, input ClassifyDocPathInput) (*mcp.CallToolResult, ClassifyDocPathOutput, error) {
	out, err := a.classifyDocPath(input)
	if err != nil {
		out.OK = false
		out.Error = err.Error()
		return structuredToolError(out), out, nil
	}
	return structuredResult(out), out, nil
}

func (a *App) classifyDocPath(input ClassifyDocPathInput) (ClassifyDocPathOutput, error) {
	if input.Path == "" {
		return ClassifyDocPathOutput{}, fmt.Errorf("path is required")
	}
	classification := classifyKnowledgePath(input.Path)
	return ClassifyDocPathOutput{KnowledgePathClassification: classification}, nil
}

type KnowledgeGCReportInput struct {
	Area       string `json:"area,omitempty" jsonschema:"docs|steam|mcp|browser|mobile|generic; default generic"`
	MaxEntries int    `json:"max_entries,omitempty" jsonschema:"maximum entries per candidate category; default 100, hard cap 500"`
}

type KnowledgeGCReportOutput struct {
	OK                              bool                    `json:"ok"`
	Area                            string                  `json:"area"`
	MaxEntries                      int                     `json:"max_entries"`
	CurrentMemory                   []KnowledgeDoc          `json:"current_memory"`
	Knowledge                       []KnowledgeDoc          `json:"knowledge"`
	HistoryCandidates               []KnowledgePathFinding  `json:"history_candidates"`
	SupersededCandidates            []SupersededExplanation `json:"superseded_candidates"`
	MissingCurrentContextCandidates []string                `json:"missing_current_context_candidates,omitempty"`
	RecommendedNextActions          []string                `json:"recommended_next_actions"`
	Notes                           []string                `json:"notes,omitempty"`
	Error                           string                  `json:"error,omitempty"`
}

func (a *App) KnowledgeGCReport(_ context.Context, _ *mcp.CallToolRequest, input KnowledgeGCReportInput) (*mcp.CallToolResult, KnowledgeGCReportOutput, error) {
	out, err := a.knowledgeGCReport(input)
	if err != nil {
		out.OK = false
		out.Error = err.Error()
		return structuredToolError(out), out, nil
	}
	return structuredResult(out), out, nil
}

func (a *App) knowledgeGCReport(input KnowledgeGCReportInput) (KnowledgeGCReportOutput, error) {
	area, err := normalizeKnowledgeArea(input.Area)
	out := KnowledgeGCReportOutput{Area: input.Area}
	if err != nil {
		return out, err
	}
	maxEntries := gcMaxEntries(input.MaxEntries)
	root := filepath.Clean(a.cfg.RepoRoot)
	history, superseded, notes := collectKnowledgeGCCandidates(root, area, maxEntries)
	notes = append(notes, knowledgeAreaNotes(area)...)
	out = KnowledgeGCReportOutput{
		OK:                              true,
		Area:                            area,
		MaxEntries:                      maxEntries,
		CurrentMemory:                   catalogDocsFor(area, "current"),
		Knowledge:                       catalogDocsFor(area, "knowledge"),
		HistoryCandidates:               history,
		SupersededCandidates:            superseded,
		MissingCurrentContextCandidates: missingCurrentContextCandidates(area),
		RecommendedNextActions: []string{
			"Keep Current Memory short and update it after major product/design/dev changes.",
			"Use SUPERSEDED_MAP.md to mark old capture packs, completed briefs, and archive paths instead of deleting history.",
			"Do not read History on bootstrap; use it only for evidence, regression, or archaeology.",
		},
		Notes: notes,
	}
	return out, nil
}
