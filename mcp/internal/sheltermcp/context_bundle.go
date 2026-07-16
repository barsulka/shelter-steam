package sheltermcp

import (
	"context"
	"encoding/json"
	"fmt"
	"sort"
	"strings"
	"unicode"
	"unicode/utf8"

	"github.com/modelcontextprotocol/go-sdk/mcp"
)

const (
	defaultContextBundleBytes = 24 * 1024
	hardContextBundleBytes    = 64 * 1024
	minimumContextBundleBytes = 4 * 1024
	maximumContextTaskBytes   = 512
	maximumContextErrorBytes  = 512
	contextBundleSchema       = "shelter.context_bundle.v1"
)

type ContextBundleInput struct {
	Role     string `json:"role,omitempty" jsonschema:"producer|project_manager|game_designer|art_director|codex|generic; default generic"`
	Area     string `json:"area,omitempty" jsonschema:"steam|mcp|docs|browser|mobile|generic; default generic"`
	Task     string `json:"task,omitempty" jsonschema:"short task description or routing hint"`
	MaxBytes int    `json:"max_bytes,omitempty" jsonschema:"encoded StructuredContent byte budget; default 24576, minimum 4096, hard cap 65536"`
}

type ContextTruthExcerpt struct {
	Path        string `json:"path"`
	Heading     string `json:"heading"`
	Excerpt     string `json:"excerpt"`
	BlockSHA256 string `json:"block_sha256"`
}

type ContextOwnershipStatus struct {
	Path    string `json:"path"`
	Status  string `json:"status"`
	Owner   string `json:"owner"`
	Purpose string `json:"purpose"`
}

type ContextBudget struct {
	RequestedBytes int      `json:"requested_bytes"`
	HardCapBytes   int      `json:"hard_cap_bytes"`
	EncodedBytes   int      `json:"encoded_bytes"`
	Truncated      bool     `json:"truncated"`
	Omitted        []string `json:"omitted"`
}

type ContextFallback struct {
	Required bool     `json:"required"`
	Reasons  []string `json:"reasons"`
}

type ContextBundleOutput struct {
	SchemaVersion       string                   `json:"schema_version"`
	Health              string                   `json:"health"`
	Role                string                   `json:"role"`
	Area                string                   `json:"area"`
	Task                string                   `json:"task"`
	CurrentTruth        []ContextTruthExcerpt    `json:"current_truth"`
	Decisions           []KnowledgeDecision      `json:"decisions"`
	ActiveOpenQuestions []OpenQuestion           `json:"active_open_questions"`
	Roadmaps            []KnowledgeRoadmap       `json:"roadmaps"`
	OwnershipStatus     []ContextOwnershipStatus `json:"ownership_status"`
	ReadNext            []string                 `json:"read_next"`
	Sources             []KnowledgeSource        `json:"sources"`
	BlockHashes         []KnowledgeBlockHash     `json:"block_hashes"`
	Budget              ContextBudget            `json:"budget"`
	Fallback            ContextFallback          `json:"fallback"`
	Errors              []string                 `json:"errors"`
}

type contextTaskRoute string

const (
	contextTaskGeneric        contextTaskRoute = "generic"
	contextTaskImplementation contextTaskRoute = "implementation"
	contextTaskDecision       contextTaskRoute = "decision"
	contextTaskHandoff        contextTaskRoute = "handoff"
	contextTaskRouting        contextTaskRoute = "context_routing"
)

func (a *App) ShelterContextBundle(_ context.Context, _ *mcp.CallToolRequest, input ContextBundleInput) (*mcp.CallToolResult, ContextBundleOutput, error) {
	requested, err := contextBundleRequestedBytes(input.MaxBytes)
	if err != nil {
		return nil, ContextBundleOutput{}, err
	}
	snapshot, err := a.knowledgeSnapshot()
	if err != nil {
		out := contextBundleError(input, requested, err)
		return shortStructuredResult(out, "Shelter context bundle: knowledge health=error; direct source fallback required.", true), out, nil
	}
	out, err := buildContextBundle(snapshot, input)
	if err != nil {
		failed := contextBundleError(input, requested, err)
		return shortStructuredResult(failed, "Shelter context bundle: request error; direct source fallback required.", true), failed, nil
	}
	text := fmt.Sprintf("Shelter context bundle: health=%s, encoded=%d/%d bytes, fallback=%t.", out.Health, out.Budget.EncodedBytes, out.Budget.RequestedBytes, out.Fallback.Required)
	return shortStructuredResult(out, text, false), out, nil
}

func contextBundleError(input ContextBundleInput, requested int, err error) ContextBundleOutput {
	out := ContextBundleOutput{
		SchemaVersion: contextBundleSchema,
		Health:        "error",
		Role:          normalizeEnum(input.Role, "generic"),
		Area:          normalizeEnum(input.Area, "generic"),
		Task:          boundedContextText(strings.TrimSpace(input.Task), maximumContextTaskBytes),
		CurrentTruth:  []ContextTruthExcerpt{}, Decisions: []KnowledgeDecision{}, ActiveOpenQuestions: []OpenQuestion{},
		Roadmaps: []KnowledgeRoadmap{}, OwnershipStatus: []ContextOwnershipStatus{}, ReadNext: []string{},
		Sources: []KnowledgeSource{}, BlockHashes: []KnowledgeBlockHash{},
		Budget:   ContextBudget{RequestedBytes: requested, HardCapBytes: hardContextBundleBytes, Omitted: []string{}},
		Fallback: ContextFallback{Required: true, Reasons: []string{"knowledge source snapshot is not current; read canonical local source documents directly"}},
		Errors:   []string{contextBundleErrorMessage(err)},
	}
	bundleEncodedBytes(&out)
	return out
}

func buildContextBundle(snapshot KnowledgeSourceSnapshot, input ContextBundleInput) (ContextBundleOutput, error) {
	role, err := normalizeKnowledgeRole(input.Role)
	if err != nil {
		return ContextBundleOutput{}, err
	}
	area, err := normalizeTaskArea(input.Area)
	if err != nil {
		return ContextBundleOutput{}, err
	}
	requested, err := contextBundleRequestedBytes(input.MaxBytes)
	if err != nil {
		return ContextBundleOutput{}, err
	}

	task := strings.TrimSpace(input.Task)
	taskRoute := classifyContextTask(task)
	bundle := ContextBundleOutput{
		SchemaVersion:       contextBundleSchema,
		Health:              "current",
		Role:                role,
		Area:                area,
		Task:                task,
		Decisions:           bundleDecisions(snapshot, area),
		ActiveOpenQuestions: bundleOpenQuestions(snapshot, area),
		Roadmaps:            bundleRoadmaps(snapshot, area),
		ReadNext:            bundleReadNext(snapshot, role, area, taskRoute),
		Budget:              ContextBudget{RequestedBytes: requested, HardCapBytes: hardContextBundleBytes, Omitted: []string{}},
		Fallback:            ContextFallback{Reasons: []string{}},
		Errors:              []string{},
	}
	bundle.CurrentTruth = bundleCurrentTruth(snapshot, role, area, taskRoute)
	bundle.OwnershipStatus = bundleOwnership(snapshot, role, area)
	refreshBundleProvenance(&bundle, snapshot)

	for bundleEncodedBytes(&bundle) > requested {
		if !dropLowestPriorityBundleItem(&bundle) {
			return ContextBundleOutput{}, fmt.Errorf("context bundle cannot fit max_bytes=%d", requested)
		}
		bundle.Budget.Truncated = true
		bundle.Fallback.Required = true
		bundle.Fallback.Reasons = []string{"bundle content omitted to satisfy max_bytes; read the omitted source directly if required"}
		refreshBundleProvenance(&bundle, snapshot)
	}
	bundleEncodedBytes(&bundle)
	return bundle, nil
}

func contextBundleInputSchema() map[string]any {
	return map[string]any{
		"type":                 "object",
		"additionalProperties": false,
		"properties": map[string]any{
			"role": map[string]any{
				"type":        "string",
				"description": "producer|project_manager|game_designer|art_director|codex|generic; default generic",
			},
			"area": map[string]any{
				"type":        "string",
				"description": "steam|mcp|docs|browser|mobile|generic; default generic",
			},
			"task": map[string]any{
				"type":        "string",
				"maxLength":   maximumContextTaskBytes,
				"description": "short task description used only as a fixed-category deterministic routing hint",
			},
			"max_bytes": map[string]any{
				"type":        "integer",
				"minimum":     minimumContextBundleBytes,
				"default":     defaultContextBundleBytes,
				"description": "encoded StructuredContent byte budget; minimum 4096; values above the 65536 hard cap are clamped",
			},
		},
	}
}

func contextBundleRequestedBytes(raw int) (int, error) {
	if raw == 0 {
		return defaultContextBundleBytes, nil
	}
	if raw < minimumContextBundleBytes {
		return 0, fmt.Errorf("max_bytes must be at least the schema minimum %d", minimumContextBundleBytes)
	}
	if raw > hardContextBundleBytes {
		return hardContextBundleBytes, nil
	}
	return raw, nil
}

func contextBundleErrorMessage(err error) string {
	message := strings.TrimSpace(err.Error())
	if strings.HasPrefix(message, "missing_required_source ") || strings.HasPrefix(message, "source_changed_during_read ") {
		if separator := strings.Index(message, ": "); separator >= 0 {
			message = message[:separator]
		}
	}
	return boundedContextText(message, maximumContextErrorBytes)
}

func boundedContextText(value string, maxBytes int) string {
	if len(value) <= maxBytes {
		return value
	}
	for len(value) > maxBytes {
		_, size := utf8.DecodeLastRuneInString(value)
		value = value[:len(value)-size]
	}
	return value
}

func bundleCurrentTruth(snapshot KnowledgeSourceSnapshot, role, area string, taskRoute contextTaskRoute) []ContextTruthExcerpt {
	var routes [][2]string
	switch taskRoute {
	case contextTaskDecision:
		routes = [][2]string{
			{docDecisions, "## 1. Decision index"},
			{docBootstrapContext, "## 6. Active decision / philosophy docs"},
		}
	case contextTaskHandoff:
		routes = [][2]string{
			{docHandoffIndex, "## 1. Latest relevant handoff by role / area"},
			{docCodexCurrentStatus, "## 5. Current next likely dev step"},
		}
	case contextTaskRouting:
		routes = [][2]string{
			{docGovernance, "## 2. Default read policy"},
			{docGovernance, "## 9. Shelter MCP knowledge boundary"},
		}
	default:
		switch {
		case role == "codex" || area == "mcp":
			routes = [][2]string{
				{docCodexCurrentStatus, "## 1. Current dev focus"},
				{docCodexCurrentStatus, "## 5. Current next likely dev step"},
			}
		case role == "project_manager" || area == "docs":
			routes = [][2]string{
				[2]string{docGovernance, "## 2. Default read policy"},
				[2]string{docGovernance, "## 9. Shelter MCP knowledge boundary"},
			}
		case area == "steam" || role == "game_designer" || role == "art_director":
			routes = [][2]string{{docSteamCurrent, "## Standard navigation"}}
		default:
			routes = [][2]string{{docCurrentStatus, "## Текущий фокус"}}
		}
	}
	var excerpts []ContextTruthExcerpt
	for _, route := range routes {
		section, ok := snapshot.findSection(route[0], route[1])
		if !ok {
			continue
		}
		excerpts = append(excerpts, ContextTruthExcerpt{Path: section.Path, Heading: section.Heading, Excerpt: section.Text, BlockSHA256: section.SHA256})
	}
	return excerpts
}

func bundleDecisions(snapshot KnowledgeSourceSnapshot, area string) []KnowledgeDecision {
	var decisions []KnowledgeDecision
	for _, decision := range snapshot.Decisions {
		if sourceAreasMatch(decision.Areas, area) {
			decisions = append(decisions, decision)
		}
	}
	sort.Slice(decisions, func(i, j int) bool { return decisions[i].ID > decisions[j].ID })
	return decisions
}

func bundleOpenQuestions(snapshot KnowledgeSourceSnapshot, area string) []OpenQuestion {
	var questions []OpenQuestion
	for _, question := range snapshot.ActiveOpenQuestions {
		if area == "generic" || question.Area == area || (area == "mcp" && question.Area == "docs") {
			questions = append(questions, question)
		}
	}
	return questions
}

func bundleRoadmaps(snapshot KnowledgeSourceSnapshot, area string) []KnowledgeRoadmap {
	var roadmaps []KnowledgeRoadmap
	for _, roadmap := range snapshot.Roadmaps {
		if sourceAreasMatch(roadmap.Areas, area) {
			roadmaps = append(roadmaps, roadmap)
		}
	}
	return roadmaps
}

func bundleOwnership(snapshot KnowledgeSourceSnapshot, role, area string) []ContextOwnershipStatus {
	wanted := map[string]bool{docBootstrapContext: true}
	if role == "codex" || area == "mcp" {
		wanted[docCodexCurrentStatus] = true
		wanted[docCodexImplementation] = true
	} else if role == "project_manager" || area == "docs" {
		wanted[docGovernance] = true
		wanted[docKnowledgeBaseRoadmap] = true
	} else if area == "steam" {
		wanted[docSteamCurrent] = true
	}
	var ownership []ContextOwnershipStatus
	for _, document := range snapshot.Documents {
		if !wanted[document.Path] {
			continue
		}
		metadata := sourceHeaderMetadata(string(snapshot.sourceByPath[document.Path].data))
		ownership = append(ownership, ContextOwnershipStatus{Path: document.Path, Status: document.Status, Owner: metadata["owner"], Purpose: document.Purpose})
	}
	return ownership
}

func bundleReadNext(snapshot KnowledgeSourceSnapshot, role, area string, taskRoute contextTaskRoute) []string {
	paths := []string{docProjectRules, docAgents, docRepoReadme, docBootstrapContext}
	switch role {
	case "codex":
		paths = append(paths, docRoleCodex)
	case "project_manager":
		paths = append(paths, docRoleProjectManager)
	case "producer":
		paths = append(paths, docRoleProducer)
	case "game_designer":
		paths = append(paths, docRoleGameDesigner)
	case "art_director":
		paths = append(paths, docRoleArtDirector)
	}
	switch taskRoute {
	case contextTaskImplementation:
		paths = append(paths, docCodexCurrentStatus, docCodexImplementation, docADRIndex)
	case contextTaskDecision:
		paths = append(paths, docDecisions, docADRIndex, docCurrentStatus)
	case contextTaskHandoff:
		paths = append(paths, docHandoffIndex)
		if handoff, _ := latestHandoffFor(snapshot, role, area); handoff.Available {
			paths = append(paths, handoff.Path)
		}
		paths = append(paths, docCodexCurrentStatus)
	case contextTaskRouting:
		paths = append(paths, docGovernance, docKnowledgeBaseRoadmap, docKnowledgeBasePolishRoadmap, docEvidenceReadPolicy)
	}
	switch area {
	case "mcp":
		paths = append(paths, docCodexCurrentStatus, docCodexImplementation, docADRIndex)
	case "docs":
		paths = append(paths, docGovernance, docKnowledgeBaseRoadmap)
	case "steam":
		paths = append(paths, docSteamCurrent, docADRIndex)
	}
	return appendUniqueStrings(nil, paths...)
}

func classifyContextTask(task string) contextTaskRoute {
	tokens := strings.FieldsFunc(strings.ToLower(task), func(value rune) bool {
		return !unicode.IsLetter(value) && !unicode.IsDigit(value)
	})
	for _, route := range []struct {
		kind     contextTaskRoute
		keywords []string
	}{
		{kind: contextTaskImplementation, keywords: []string{"implement", "implementation", "remediation", "code", "coding", "build", "fix", "test", "testing", "debug", "refactor", "migration", "migrate", "cleanup"}},
		{kind: contextTaskDecision, keywords: []string{"decision", "decisions", "decide", "accepted", "adr", "scope", "contract"}},
		{kind: contextTaskHandoff, keywords: []string{"handoff", "handback", "session", "transfer", "resume"}},
		{kind: contextTaskRouting, keywords: []string{"context", "routing", "route", "bootstrap", "knowledge"}},
	} {
		for _, token := range tokens {
			for _, keyword := range route.keywords {
				if token == keyword {
					return route.kind
				}
			}
		}
	}
	for index := 0; index+1 < len(tokens); index++ {
		if tokens[index] == "d" && len(tokens[index+1]) == 3 && strings.IndexFunc(tokens[index+1], func(value rune) bool { return !unicode.IsDigit(value) }) == -1 {
			return contextTaskDecision
		}
	}
	return contextTaskGeneric
}

func refreshBundleProvenance(bundle *ContextBundleOutput, snapshot KnowledgeSourceSnapshot) {
	paths := map[string]bool{}
	blockKeys := map[string]bool{}
	for _, truth := range bundle.CurrentTruth {
		paths[truth.Path] = true
		blockKeys["section:"+truth.Path+":"+truth.Heading] = true
	}
	for _, decision := range bundle.Decisions {
		paths[decision.SourcePath] = true
		blockKeys["decision:"+decision.ID] = true
	}
	for _, question := range bundle.ActiveOpenQuestions {
		paths[question.SourcePath] = true
		blockKeys["open_question:"+question.ID] = true
	}
	for _, roadmap := range bundle.Roadmaps {
		paths[roadmap.Path] = true
		blockKeys["roadmap:"+roadmap.ID] = true
	}
	for _, ownership := range bundle.OwnershipStatus {
		paths[ownership.Path] = true
		blockKeys["document_metadata:"+ownership.Path] = true
	}
	for _, path := range bundle.ReadNext {
		paths[path] = true
	}
	bundle.Sources = bundle.Sources[:0]
	for path := range paths {
		if source, ok := snapshot.sourceByPath[path]; ok {
			source.data = nil
			bundle.Sources = append(bundle.Sources, source)
		}
	}
	sort.Slice(bundle.Sources, func(i, j int) bool { return bundle.Sources[i].Path < bundle.Sources[j].Path })
	bundle.BlockHashes = bundle.BlockHashes[:0]
	for key := range blockKeys {
		if strings.HasPrefix(key, "section:") {
			parts := strings.SplitN(strings.TrimPrefix(key, "section:"), ":", 2)
			if len(parts) == 2 {
				for _, truth := range bundle.CurrentTruth {
					if truth.Path == parts[0] && truth.Heading == parts[1] {
						bundle.BlockHashes = append(bundle.BlockHashes, KnowledgeBlockHash{Key: key, Path: truth.Path, SHA256: truth.BlockSHA256})
					}
				}
			}
			continue
		}
		if block, ok := snapshot.blockByKey[key]; ok {
			bundle.BlockHashes = append(bundle.BlockHashes, block)
		}
	}
	sort.Slice(bundle.BlockHashes, func(i, j int) bool { return bundle.BlockHashes[i].Key < bundle.BlockHashes[j].Key })
}

func dropLowestPriorityBundleItem(bundle *ContextBundleOutput) bool {
	var label string
	switch {
	case len(bundle.ReadNext) > 4:
		label = "read_next"
		bundle.ReadNext = bundle.ReadNext[:len(bundle.ReadNext)-1]
	case len(bundle.OwnershipStatus) > 1:
		label = "ownership_status"
		bundle.OwnershipStatus = bundle.OwnershipStatus[:len(bundle.OwnershipStatus)-1]
	case len(bundle.ActiveOpenQuestions) > 0:
		label = "active_open_questions"
		bundle.ActiveOpenQuestions = bundle.ActiveOpenQuestions[:len(bundle.ActiveOpenQuestions)-1]
	case len(bundle.Roadmaps) > 1:
		label = "roadmaps"
		bundle.Roadmaps = bundle.Roadmaps[:len(bundle.Roadmaps)-1]
	case len(bundle.Decisions) > 3:
		label = "decisions"
		bundle.Decisions = bundle.Decisions[:len(bundle.Decisions)-1]
	case len(bundle.CurrentTruth) > 1:
		label = "current_truth"
		bundle.CurrentTruth = bundle.CurrentTruth[:len(bundle.CurrentTruth)-1]
	case len(bundle.Decisions) > 1:
		label = "decisions"
		bundle.Decisions = bundle.Decisions[:len(bundle.Decisions)-1]
	case len(bundle.Roadmaps) > 0:
		label = "roadmaps"
		bundle.Roadmaps = bundle.Roadmaps[:len(bundle.Roadmaps)-1]
	case len(bundle.OwnershipStatus) > 0:
		label = "ownership_status"
		bundle.OwnershipStatus = bundle.OwnershipStatus[:len(bundle.OwnershipStatus)-1]
	case len(bundle.ReadNext) > 0:
		label = "read_next"
		bundle.ReadNext = bundle.ReadNext[:len(bundle.ReadNext)-1]
	case len(bundle.Decisions) > 0:
		label = "decisions"
		bundle.Decisions = bundle.Decisions[:len(bundle.Decisions)-1]
	case len(bundle.CurrentTruth) > 0:
		label = "current_truth"
		bundle.CurrentTruth = bundle.CurrentTruth[:len(bundle.CurrentTruth)-1]
	default:
		return false
	}
	bundle.Budget.Omitted = appendUniqueStrings(bundle.Budget.Omitted, label)
	return true
}

func bundleEncodedBytes(bundle *ContextBundleOutput) int {
	for attempts := 0; attempts < 8; attempts++ {
		data, _ := json.Marshal(bundle)
		if len(data) == bundle.Budget.EncodedBytes {
			return len(data)
		}
		bundle.Budget.EncodedBytes = len(data)
	}
	data, _ := json.Marshal(bundle)
	return len(data)
}

func sourceAreasMatch(areas []string, area string) bool {
	if area == "generic" {
		return true
	}
	for _, candidate := range areas {
		if candidate == area || candidate == "all" {
			return true
		}
		if area == "mcp" && candidate == "docs" {
			return true
		}
	}
	return false
}
