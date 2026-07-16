package sheltermcp

import (
	"fmt"
	"io/fs"
	"os"
	"path/filepath"
	"sort"
	"strings"
)

const (
	knowledgeLayerCurrent = "Current Memory"
	knowledgeLayerActive  = "Knowledge"
	knowledgeLayerHistory = "History"

	defaultKnowledgeGCMaxEntries = 100
	maxKnowledgeGCEntries        = 500
	defaultDigestMaxItems        = 20
	maxDigestItems               = 50
)

const (
	docBootstrapContext   = "docs/drive/Shelter/00_START_HERE/BOOTSTRAP_CONTEXT.md"
	docCurrentStatus      = "docs/drive/Shelter/00_START_HERE/01_CURRENT_STATUS.md"
	docDecisions          = "docs/drive/Shelter/00_START_HERE/02_DECISIONS.md"
	docPhilosophy         = "docs/drive/Shelter/00_START_HERE/03_PROJECT_PHILOSOPHY.md"
	docOpenQuestions      = "docs/drive/Shelter/00_START_HERE/03_OPEN_QUESTIONS.md"
	docStressTests        = "docs/drive/Shelter/00_START_HERE/04_SHELTER_STRESS_TESTS.md"
	docGovernance         = "docs/drive/Shelter/00_START_HERE/05_DOCUMENTATION_GOVERNANCE.md"
	docEvidenceReadPolicy = "docs/drive/Shelter/00_START_HERE/EVIDENCE_READ_POLICY.md"
	docSupersededMap      = "docs/drive/Shelter/00_START_HERE/SUPERSEDED_MAP.md"

	docHandoffIndex        = "docs/drive/Shelter/06_SESSIONS_AND_HANDOFFS/HANDOFF_INDEX.md"
	docSteamCurrent        = "docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__CURRENT_CONTEXT.md"
	docGameDesignCurrent   = "docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/GAME_DESIGN__CURRENT_CONTEXT.md"
	docArtDirectionCurrent = "docs/drive/Shelter/03_DESIGN/ART_DIRECTION__CURRENT_CONTEXT.md"

	docCodexImplementation = "docs/drive/Shelter/04_DEVELOPMENT/CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md"
	docADRIndex            = "docs/repo/adr/README.md"
	docCodexStatus         = "docs/repo/status/CODEX_STATUS.md"
	docCodexCurrentStatus  = "docs/repo/status/CODEX_CURRENT_STATUS.md"

	docKnowledgeBaseRoadmap       = "docs/drive/Shelter/00_START_HERE/KNOWLEDGE_BASE_ROADMAP.md"
	docKnowledgeBasePolishRoadmap = "docs/drive/Shelter/00_START_HERE/KNOWLEDGE_BASE_POLISH_ROADMAP.md"
	docSteamGameRoadmapV2         = "docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__Game_Design_Roadmap_v2.md"
	docWorkflowMigrationHandoff   = "docs/drive/Shelter/06_SESSIONS_AND_HANDOFFS/codex/2026-07-10__codex_handoff__chatgpt_work_local_mcp_migration.md"
)

var validKnowledgeAreas = map[string]bool{"steam": true, "mcp": true, "docs": true, "browser": true, "mobile": true, "generic": true}
var validDecisionAreas = map[string]bool{"steam": true, "mcp": true, "docs": true, "browser": true, "mobile": true, "shared": true, "all": true, "generic": true}
var validStatusAreas = map[string]bool{"steam": true, "docs": true, "mcp": true, "browser": true, "mobile": true, "generic": true}
var validDecisionKinds = map[string]bool{"all": true, "product": true, "technical": true, "process": true, "documentation": true, "ethics": true}
var validOpenQuestionAreas = map[string]bool{"steam": true, "docs": true, "browser": true, "mobile": true, "shared": true, "charity": true, "platform": true, "generic": true}
var validOpenQuestionStatuses = map[string]bool{"open": true, "partially_resolved": true, "deferred": true, "needs_research": true, "all": true}
var validRoadmapAreas = map[string]bool{"steam": true, "docs": true, "mcp": true, "game_design": true, "art_direction": true, "generic": true}
var validKnowledgeRoles = map[string]bool{"producer": true, "project_manager": true, "game_designer": true, "art_director": true, "codex": true, "generic": true}
var validHandoffAreas = map[string]bool{"steam": true, "docs": true, "mcp": true, "generic": true}
var validTaskAreas = map[string]bool{"steam": true, "docs": true, "mcp": true, "browser": true, "mobile": true, "generic": true}
var validTaskKinds = map[string]bool{"decision": true, "implementation": true, "cleanup": true, "art_review": true, "game_design": true, "research": true, "handoff": true, "generic": true}

type KnowledgeDoc struct {
	Path       string   `json:"path"`
	Areas      []string `json:"areas"`
	Status     string   `json:"status"`
	Layer      string   `json:"layer"`
	Purpose    string   `json:"purpose"`
	ReadPolicy string   `json:"read_policy"`
}

type KnowledgePathFinding struct {
	Path       string `json:"path"`
	Layer      string `json:"layer"`
	Status     string `json:"status"`
	ReadPolicy string `json:"read_policy"`
	Reason     string `json:"reason"`
}

type SupersededExplanation struct {
	Path           string   `json:"path"`
	OK             bool     `json:"ok"`
	Classification string   `json:"classification"`
	ReadPolicy     string   `json:"read_policy"`
	CurrentSource  string   `json:"current_source,omitempty"`
	Reason         string   `json:"reason"`
	Notes          []string `json:"notes,omitempty"`
}

type KnowledgePathClassification struct {
	Path       string        `json:"path"`
	OK         bool          `json:"ok"`
	Layer      string        `json:"layer"`
	Status     string        `json:"status"`
	ReadPolicy string        `json:"read_policy"`
	Confidence string        `json:"confidence"`
	Reason     string        `json:"reason"`
	KnownDoc   *KnowledgeDoc `json:"known_doc,omitempty"`
	Notes      []string      `json:"notes,omitempty"`
}

type KnowledgeDecision struct {
	ID         string   `json:"id"`
	Title      string   `json:"title"`
	Kind       string   `json:"kind"`
	Status     string   `json:"status"`
	Summary    string   `json:"summary"`
	SourcePath string   `json:"source_path"`
	Areas      []string `json:"areas"`
}

type OpenQuestion struct {
	ID         string   `json:"id"`
	Title      string   `json:"title"`
	Area       string   `json:"area"`
	Status     string   `json:"status"`
	Owner      string   `json:"owner"`
	Summary    string   `json:"summary"`
	SourcePath string   `json:"source_path"`
	Sources    []string `json:"sources,omitempty"`
}

type KnowledgeRoadmap struct {
	ID           string   `json:"id"`
	Title        string   `json:"title"`
	Path         string   `json:"path"`
	Areas        []string `json:"areas"`
	Status       string   `json:"status"`
	CurrentPhase string   `json:"current_phase"`
	NextStep     string   `json:"next_step"`
	Owner        string   `json:"owner"`
}

type KnowledgeHandoff struct {
	Date       string   `json:"date"`
	Title      string   `json:"title"`
	Path       string   `json:"path"`
	Roles      []string `json:"roles"`
	Areas      []string `json:"areas"`
	Summary    string   `json:"summary"`
	SourceType string   `json:"source_type"`
	Available  bool     `json:"available"`
	priority   int
}

type KnowledgeTaskContext struct {
	Role           string   `json:"role"`
	Area           string   `json:"area"`
	Task           string   `json:"task"`
	ReadFirst      []string `json:"read_first"`
	ReadByTask     []string `json:"read_by_task"`
	AvoidByDefault []string `json:"avoid_by_default"`
	Notes          []string `json:"notes"`
}

type DecisionDigestItem struct {
	ID      string `json:"id"`
	Title   string `json:"title"`
	Summary string `json:"summary"`
}

type OpenQuestionDigestItem struct {
	ID      string `json:"id"`
	Title   string `json:"title"`
	Status  string `json:"status"`
	Summary string `json:"summary"`
}

type ShelterStatusDashboard struct {
	Area                string                   `json:"area"`
	CurrentFocus        string                   `json:"current_focus"`
	CurrentScope        string                   `json:"current_scope"`
	CurrentPhase        string                   `json:"current_phase"`
	CurrentRoadmap      string                   `json:"current_roadmap"`
	CurrentTask         string                   `json:"current_task"`
	ActiveDecisions     []DecisionDigestItem     `json:"active_decisions"`
	ActiveOpenQuestions []OpenQuestionDigestItem `json:"active_open_questions"`
	BlockedByOrRisks    []string                 `json:"blocked_by_or_risks"`
	LatestHandoff       *KnowledgeHandoff        `json:"latest_handoff,omitempty"`
	ReadFirst           []string                 `json:"read_first"`
	NextBestStep        string                   `json:"next_best_step"`
	Notes               []string                 `json:"notes"`
}

type CurrentEntryDigest struct {
	Role           string   `json:"role"`
	Area           string   `json:"area"`
	ReadFirst      []string `json:"read_first"`
	ReadNextByTask []string `json:"read_next_by_task"`
	AvoidByDefault []string `json:"avoid_by_default"`
	Why            []string `json:"why"`
}

type sourceSupersededEntry struct {
	OldMaterial   string
	CurrentSource string
	Status        string
	Action        string
}

func normalizeKnowledgeArea(area string) (string, error) {
	area = normalizeEnum(area, "generic")
	if !validKnowledgeAreas[area] {
		return "", fmt.Errorf("unsupported area %q; expected steam, mcp, docs, browser, mobile, or generic", area)
	}
	return area, nil
}

func normalizeDecisionArea(area string) (string, error) {
	area = normalizeEnum(area, "generic")
	if !validDecisionAreas[area] {
		return "", fmt.Errorf("unsupported decision area %q; expected steam, mcp, docs, browser, mobile, shared, all, or generic", area)
	}
	return area, nil
}

func normalizeStatusArea(area string) (string, error) {
	area = normalizeEnum(area, "generic")
	if !validStatusAreas[area] {
		return "", fmt.Errorf("unsupported status area %q; expected steam, docs, mcp, browser, mobile, or generic", area)
	}
	return area, nil
}

func normalizeDecisionKind(kind string) (string, error) {
	kind = normalizeEnum(kind, "all")
	if !validDecisionKinds[kind] {
		return "", fmt.Errorf("unsupported decision kind %q; expected all, product, technical, process, documentation, or ethics", kind)
	}
	return kind, nil
}

func normalizeOpenQuestionArea(area string) (string, error) {
	area = normalizeEnum(area, "generic")
	if !validOpenQuestionAreas[area] {
		return "", fmt.Errorf("unsupported open question area %q; expected steam, docs, browser, mobile, shared, charity, platform, or generic", area)
	}
	return area, nil
}

func normalizeOpenQuestionStatus(status string) (string, error) {
	status = normalizeEnum(status, "open")
	if !validOpenQuestionStatuses[status] {
		return "", fmt.Errorf("unsupported open question status %q; expected open, partially_resolved, deferred, needs_research, or all", status)
	}
	return status, nil
}

func normalizeRoadmapArea(area string) (string, error) {
	area = normalizeEnum(area, "generic")
	if !validRoadmapAreas[area] {
		return "", fmt.Errorf("unsupported roadmap area %q; expected steam, docs, mcp, game_design, art_direction, or generic", area)
	}
	return area, nil
}

func normalizeKnowledgeRole(role string) (string, error) {
	role = normalizeEnum(role, "generic")
	if !validKnowledgeRoles[role] {
		return "", fmt.Errorf("unsupported role %q; expected producer, project_manager, game_designer, art_director, codex, or generic", role)
	}
	return role, nil
}

func normalizeHandoffArea(area string) (string, error) {
	area = normalizeEnum(area, "generic")
	if !validHandoffAreas[area] {
		return "", fmt.Errorf("unsupported handoff area %q; expected steam, docs, mcp, or generic", area)
	}
	return area, nil
}

func normalizeTaskArea(area string) (string, error) {
	area = normalizeEnum(area, "generic")
	if !validTaskAreas[area] {
		return "", fmt.Errorf("unsupported task area %q; expected steam, docs, mcp, browser, mobile, or generic", area)
	}
	return area, nil
}

func normalizeTaskKind(task string) (string, error) {
	task = normalizeEnum(task, "generic")
	if !validTaskKinds[task] {
		return "", fmt.Errorf("unsupported task %q; expected decision, implementation, cleanup, art_review, game_design, research, handoff, or generic", task)
	}
	return task, nil
}

func normalizeKnowledgeLayer(layer string) (string, error) {
	layer = normalizeEnum(layer, "current")
	if layer != "current" && layer != "knowledge" && layer != "history" && layer != "all" {
		return "", fmt.Errorf("unsupported layer %q; expected current, knowledge, history, or all", layer)
	}
	return layer, nil
}

func layerMatches(doc KnowledgeDoc, layer string) bool {
	return layer == "all" || (layer == "current" && doc.Layer == knowledgeLayerCurrent) || (layer == "knowledge" && doc.Layer == knowledgeLayerActive) || (layer == "history" && doc.Layer == knowledgeLayerHistory)
}

func catalogDocsFor(snapshot KnowledgeSourceSnapshot, area, layer string) []KnowledgeDoc {
	var docs []KnowledgeDoc
	for _, doc := range snapshot.Documents {
		if docMatchesArea(doc, area) && layerMatches(doc, layer) {
			docs = append(docs, doc)
		}
	}
	return docs
}

func docMatchesArea(doc KnowledgeDoc, area string) bool { return knowledgeAreasMatch(doc.Areas, area) }

func knowledgeAreasMatch(areas []string, area string) bool {
	if area == "generic" || area == "all" {
		return true
	}
	for _, item := range areas {
		if item == "all" || item == area {
			return true
		}
	}
	return false
}

func decisionsFor(snapshot KnowledgeSourceSnapshot, area, kind string) []KnowledgeDecision {
	var decisions []KnowledgeDecision
	for _, decision := range snapshot.Decisions {
		if knowledgeAreasMatch(decision.Areas, area) && (kind == "all" || decision.Kind == kind) {
			decisions = append(decisions, decision)
		}
	}
	return decisions
}

func digestMaxItems(value int) int {
	if value <= 0 {
		return defaultDigestMaxItems
	}
	if value > maxDigestItems {
		return maxDigestItems
	}
	return value
}

func decisionDigestFor(snapshot KnowledgeSourceSnapshot, area string, maxItems int) []DecisionDigestItem {
	decisions := decisionsFor(snapshot, area, "all")
	if limit := digestMaxItems(maxItems); len(decisions) > limit {
		decisions = decisions[:limit]
	}
	items := make([]DecisionDigestItem, 0, len(decisions))
	for _, decision := range decisions {
		items = append(items, DecisionDigestItem{ID: decision.ID, Title: decision.Title, Summary: decision.Summary})
	}
	return items
}

func decisionByID(snapshot KnowledgeSourceSnapshot, id string) (KnowledgeDecision, bool) {
	id = strings.ToUpper(strings.TrimSpace(id))
	for _, decision := range snapshot.Decisions {
		if decision.ID == id {
			return decision, true
		}
	}
	return KnowledgeDecision{}, false
}

func decisionIDs(snapshot KnowledgeSourceSnapshot) []string {
	ids := make([]string, 0, len(snapshot.Decisions))
	for _, decision := range snapshot.Decisions {
		ids = append(ids, decision.ID)
	}
	return ids
}

func openQuestionsFor(snapshot KnowledgeSourceSnapshot, area, status string) []OpenQuestion {
	var questions []OpenQuestion
	for _, question := range snapshot.ActiveOpenQuestions {
		if area != "generic" && question.Area != area {
			continue
		}
		if status != "all" && question.Status != status {
			continue
		}
		questions = append(questions, question)
	}
	return questions
}

func openQuestionsDigestFor(snapshot KnowledgeSourceSnapshot, area, status string) []OpenQuestionDigestItem {
	var items []OpenQuestionDigestItem
	for _, question := range snapshot.ActiveOpenQuestions {
		if !openQuestionMatchesDigestArea(question, area) || (status != "all" && question.Status != status) {
			continue
		}
		items = append(items, OpenQuestionDigestItem{ID: question.ID, Title: question.Title, Status: question.Status, Summary: question.Summary})
	}
	return items
}

func openQuestionMatchesDigestArea(question OpenQuestion, area string) bool {
	if area == "generic" {
		return true
	}
	if area == "browser" {
		return question.Area == "browser" || question.Area == "platform" || question.Area == "charity" || question.Area == "shared"
	}
	return question.Area == area
}

func roadmapsFor(snapshot KnowledgeSourceSnapshot, area string) []KnowledgeRoadmap {
	var roadmaps []KnowledgeRoadmap
	for _, roadmap := range snapshot.Roadmaps {
		if knowledgeAreasMatch(roadmap.Areas, area) {
			roadmaps = append(roadmaps, roadmap)
		}
	}
	return roadmaps
}

func latestHandoffFor(snapshot KnowledgeSourceSnapshot, role, area string) (KnowledgeHandoff, []KnowledgeHandoff) {
	var matches []KnowledgeHandoff
	for _, handoff := range snapshot.Handoffs {
		if role != "generic" && !knowledgeAreasMatch(handoff.Roles, role) {
			continue
		}
		if area != "generic" && !knowledgeAreasMatch(handoff.Areas, area) {
			continue
		}
		matches = append(matches, handoff)
	}
	sort.SliceStable(matches, func(i, j int) bool {
		if matches[i].Available != matches[j].Available {
			return matches[i].Available
		}
		if matches[i].Date != matches[j].Date {
			return matches[i].Date > matches[j].Date
		}
		if matches[i].priority != matches[j].priority {
			return matches[i].priority > matches[j].priority
		}
		return matches[i].Path < matches[j].Path
	})
	if len(matches) == 0 {
		return KnowledgeHandoff{}, nil
	}
	return matches[0], matches
}

func statusDashboardFor(snapshot KnowledgeSourceSnapshot, area string) ShelterStatusDashboard {
	roadmaps := roadmapsFor(snapshot, area)
	var roadmap KnowledgeRoadmap
	if len(roadmaps) > 0 {
		roadmap = roadmaps[0]
	}
	handoff, _ := latestHandoffFor(snapshot, "generic", area)
	questions := openQuestionsDigestFor(snapshot, area, "all")
	var risks []string
	for _, question := range questions {
		risks = append(risks, question.Summary)
	}
	return ShelterStatusDashboard{
		Area:                area,
		CurrentFocus:        sourceDashboardSection(snapshot, area, true),
		CurrentScope:        sourceDashboardSection(snapshot, area, false),
		CurrentPhase:        roadmap.CurrentPhase,
		CurrentRoadmap:      roadmap.Path,
		CurrentTask:         roadmap.NextStep,
		ActiveDecisions:     newestDecisionDigestFor(snapshot, area, 12),
		ActiveOpenQuestions: questions,
		BlockedByOrRisks:    risks,
		LatestHandoff:       latestHandoffPtr(handoff),
		ReadFirst:           currentEntryDigestFor(snapshot, "generic", area).ReadFirst,
		NextBestStep:        roadmap.NextStep,
		Notes:               []string{"Exact current excerpts and roadmap fields are parsed from the source Markdown on this request."},
	}
}

func newestDecisionDigestFor(snapshot KnowledgeSourceSnapshot, area string, maxItems int) []DecisionDigestItem {
	decisions := decisionsFor(snapshot, area, "all")
	sort.Slice(decisions, func(i, j int) bool { return decisions[i].ID > decisions[j].ID })
	if limit := digestMaxItems(maxItems); len(decisions) > limit {
		decisions = decisions[:limit]
	}
	items := make([]DecisionDigestItem, 0, len(decisions))
	for _, decision := range decisions {
		items = append(items, DecisionDigestItem{ID: decision.ID, Title: decision.Title, Summary: decision.Summary})
	}
	return items
}

func sourceDashboardSection(snapshot KnowledgeSourceSnapshot, area string, focus bool) string {
	path, heading := docCurrentStatus, "## Текущий фокус"
	if area == "steam" {
		path, heading = docSteamCurrent, "## 3. Current Steam status"
	}
	if area == "mcp" {
		path, heading = docCodexCurrentStatus, "## 1. Current dev focus"
	}
	if area == "docs" && !focus {
		path, heading = docGovernance, "## 2. Default read policy"
	}
	if !focus && area != "docs" {
		heading = map[string]string{"steam": "## 6. Completed Day 2 scope and retained boundary", "mcp": "## 2. Current implemented capabilities"}[area]
	}
	if heading == "" {
		heading = "## Текущий фокус"
	}
	if section, ok := snapshot.findSection(path, heading); ok {
		return section.Text
	}
	return ""
}

func latestHandoffPtr(handoff KnowledgeHandoff) *KnowledgeHandoff {
	if handoff.Path == "" {
		return nil
	}
	return &handoff
}

func currentEntryDigestFor(snapshot KnowledgeSourceSnapshot, role, area string) CurrentEntryDigest {
	base := CurrentEntryDigest{
		Role: role, Area: area,
		ReadFirst:      []string{docBootstrapContext, docCurrentStatus},
		ReadNextByTask: []string{docDecisions, docOpenQuestions},
		AvoidByDefault: []string{docCodexStatus, "docs/drive/Shelter/06_SESSIONS_AND_HANDOFFS/**", "docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/**", "docs/drive/Shelter/99_ARCHIVE/**"},
		Why:            []string{"Current Memory first; task-specific Knowledge next; History only for evidence, regression, or archaeology."},
	}
	switch area {
	case "steam":
		base.ReadFirst = appendUniqueStrings(base.ReadFirst, docSteamCurrent)
		base.ReadNextByTask = appendUniqueStrings(base.ReadNextByTask, docSteamGameRoadmapV2)
	case "docs":
		base.ReadFirst = appendUniqueStrings(base.ReadFirst, docKnowledgeBasePolishRoadmap)
		base.ReadNextByTask = appendUniqueStrings(base.ReadNextByTask, docGovernance, docSupersededMap, docEvidenceReadPolicy, docHandoffIndex)
	case "mcp":
		base.ReadFirst = appendUniqueStrings(base.ReadFirst, docCodexCurrentStatus, docCodexImplementation)
		base.ReadNextByTask = appendUniqueStrings(base.ReadNextByTask, docKnowledgeBaseRoadmap, docADRIndex)
	case "browser", "mobile":
		base.ReadNextByTask = appendUniqueStrings(base.ReadNextByTask, docPhilosophy)
	}
	rolePath := map[string]string{"producer": docRoleProducer, "project_manager": docRoleProjectManager, "game_designer": docRoleGameDesigner, "art_director": docRoleArtDirector, "codex": docRoleCodex}[role]
	base.ReadFirst = appendUniqueStrings(base.ReadFirst, rolePath)
	if role == "game_designer" && area == "steam" {
		base.ReadFirst = appendUniqueStrings(base.ReadFirst, docGameDesignCurrent)
	}
	if role == "art_director" && area == "steam" {
		base.ReadFirst = appendUniqueStrings(base.ReadFirst, docArtDirectionCurrent)
	}
	if role == "codex" {
		base.ReadFirst = appendUniqueStrings(base.ReadFirst, docCodexCurrentStatus, docCodexImplementation)
		base.ReadNextByTask = appendUniqueStrings(base.ReadNextByTask, docADRIndex)
	}
	base.ReadFirst = onlySnapshotPaths(snapshot, base.ReadFirst)
	base.ReadNextByTask = onlySnapshotPathsOrPatterns(snapshot, base.ReadNextByTask)
	return base
}

func taskContextFor(snapshot KnowledgeSourceSnapshot, role, area, task string) KnowledgeTaskContext {
	digest := currentEntryDigestFor(snapshot, role, area)
	out := KnowledgeTaskContext{Role: role, Area: area, Task: task, ReadFirst: digest.ReadFirst, ReadByTask: digest.ReadNextByTask, AvoidByDefault: digest.AvoidByDefault, Notes: append([]string(nil), digest.Why...)}
	if role == "codex" || task == "implementation" {
		out.ReadFirst = appendUniqueStrings(out.ReadFirst, docCodexCurrentStatus, docCodexImplementation)
		out.ReadByTask = appendUniqueStrings(out.ReadByTask, docADRIndex)
	}
	if role == "project_manager" && area == "docs" && task == "cleanup" {
		out.ReadFirst = appendUniqueStrings(out.ReadFirst, docGovernance, docSupersededMap, docEvidenceReadPolicy, docOpenQuestions)
		out.ReadByTask = appendUniqueStrings(out.ReadByTask, docKnowledgeBaseRoadmap, docDecisions)
	}
	if task == "handoff" {
		out.ReadByTask = appendUniqueStrings(out.ReadByTask, docHandoffIndex)
		out.Notes = append(out.Notes, "Read only the latest relevant handoff selected by HANDOFF_INDEX.")
	}
	return out
}

func onlySnapshotPaths(snapshot KnowledgeSourceSnapshot, paths []string) []string {
	var out []string
	for _, path := range paths {
		if _, ok := snapshot.sourceByPath[path]; ok {
			out = append(out, path)
		}
	}
	return out
}

func onlySnapshotPathsOrPatterns(snapshot KnowledgeSourceSnapshot, paths []string) []string {
	var out []string
	for _, path := range paths {
		if strings.HasSuffix(path, "/**") {
			out = append(out, path)
			continue
		}
		if _, ok := snapshot.sourceByPath[path]; ok {
			out = append(out, path)
		}
	}
	return out
}

func appendUniqueStrings(values []string, extra ...string) []string {
	seen := map[string]bool{}
	var out []string
	for _, value := range append(values, extra...) {
		if value != "" && !seen[value] {
			seen[value] = true
			out = append(out, value)
		}
	}
	return out
}

func knowledgeDocPaths(docs []KnowledgeDoc) []string {
	var paths []string
	for _, doc := range docs {
		paths = append(paths, doc.Path)
	}
	return appendUniqueStrings(nil, paths...)
}

func knowledgeAreaNotes(area string) []string {
	switch area {
	case "browser":
		return []string{"No dedicated Browser current-context source is registered; use generic Current Memory and task-specific decisions."}
	case "mobile":
		return []string{"No dedicated Mobile current-context source is registered; use generic Current Memory and task-specific decisions."}
	case "mcp":
		return []string{"MCP routing uses CODEX current status and current implementation context."}
	default:
		return nil
	}
}

func classifyKnowledgePath(snapshot KnowledgeSourceSnapshot, rawPath string) KnowledgePathClassification {
	path := normalizeKnowledgePath(rawPath)
	out := KnowledgePathClassification{Path: path, OK: true, Layer: "unknown", Status: "unknown", ReadPolicy: "inspect SUPERSEDED_MAP.md and the relevant current-context document", Confidence: "low", Reason: "Path is absent from the source-derived document projection and known path conventions."}
	for _, doc := range snapshot.Documents {
		if knowledgePathMatches(path, doc.Path) {
			copy := doc
			out.Layer, out.Status, out.ReadPolicy, out.Confidence, out.Reason, out.KnownDoc = doc.Layer, doc.Status, doc.ReadPolicy, "high", "Metadata parsed from the current source document.", &copy
			return out
		}
	}
	explanation := explainSupersededPath(snapshot, path)
	if explanation.Classification != "unknown" {
		out.Layer, out.Status, out.ReadPolicy, out.Confidence, out.Reason, out.Notes = knowledgeLayerHistory, statusForSupersededClassification(explanation.Classification), explanation.ReadPolicy, "high", explanation.Reason, explanation.Notes
		return out
	}
	switch {
	case strings.Contains(path, "/06_sessions_and_handoffs/") || strings.HasPrefix(path, "docs/drive/shelter/06_sessions_and_handoffs/"):
		out.Layer, out.Status, out.ReadPolicy, out.Confidence, out.Reason = knowledgeLayerHistory, "handoff-history", "read only the latest relevant handoff", "medium", "HANDOFF_INDEX path convention classifies this path as History."
	case strings.Contains(path, "/03_design/04_deliverables/"):
		out.Layer, out.Status, out.ReadPolicy, out.Confidence, out.Reason = knowledgeLayerHistory, "evidence", "read only for proof, review, regression, or archaeology", "medium", "Evidence path convention classifies this path as History."
	case strings.Contains(path, "/04_development/") && strings.Contains(path, "codex_brief"):
		out.Layer, out.Status, out.ReadPolicy, out.Confidence, out.Reason = knowledgeLayerHistory, "completed-brief-history-candidate", "read only when assigned or investigating implementation history", "medium", "Completed-brief path convention; an assigned active brief remains task context."
	}
	return out
}

func parseSupersededEntries(snapshot KnowledgeSourceSnapshot) ([]sourceSupersededEntry, error) {
	source, ok := snapshot.sourceByPath[docSupersededMap]
	if !ok {
		return nil, fmt.Errorf("missing_required_source %s", docSupersededMap)
	}
	start := strings.Index(string(source.data), "## 2. Superseded / do not read by default")
	end := strings.Index(string(source.data), "## 3. Latest evidence")
	if start < 0 || end <= start {
		return nil, fmt.Errorf("malformed superseded map: section 2 table is missing")
	}
	var entries []sourceSupersededEntry
	for _, line := range strings.Split(string(source.data)[start:end], "\n") {
		cells := markdownTableCells(line)
		if len(cells) != 4 || cells[0] == "Старый / тяжёлый материал" || strings.HasPrefix(cells[0], "---") {
			continue
		}
		entries = append(entries, sourceSupersededEntry{OldMaterial: cells[0], CurrentSource: cells[1], Status: cells[2], Action: cells[3]})
	}
	if len(entries) == 0 {
		return nil, fmt.Errorf("malformed superseded map: no entries")
	}
	return entries, nil
}

func explainSupersededPath(snapshot KnowledgeSourceSnapshot, rawPath string) SupersededExplanation {
	path := normalizeKnowledgePath(rawPath)
	out := SupersededExplanation{Path: path, OK: true, Classification: "unknown", ReadPolicy: "inspect SUPERSEDED_MAP.md", CurrentSource: docSupersededMap, Reason: "No current SUPERSEDED_MAP entry or history path convention matched this path."}
	if knowledgePathMatches(path, docSupersededMap) {
		out.Classification, out.ReadPolicy, out.Reason = "current/knowledge", "read before archaeology or PM cleanup", "SUPERSEDED_MAP metadata identifies it as the active compression map."
		return out
	}
	entries, err := parseSupersededEntries(snapshot)
	if err != nil {
		out.OK = false
		out.Reason = err.Error()
		return out
	}
	for _, entry := range entries {
		if supersededEntryMatches(path, entry.OldMaterial) {
			out.Classification, out.ReadPolicy, out.CurrentSource, out.Reason = sourceCleanValue(entry.Status), sourceCleanValue(entry.Action), sourceCleanValue(entry.CurrentSource), "Classification parsed from the current SUPERSEDED_MAP entry: "+sourceCleanValue(entry.OldMaterial)
			return out
		}
	}
	if strings.Contains(path, "99_archive") {
		out.Classification, out.ReadPolicy, out.CurrentSource, out.Reason = "archive/history", "do_not_read_on_bootstrap", docBootstrapContext, "Archive path convention from documentation governance."
	}
	return out
}

func supersededEntryMatches(path, oldMaterial string) bool {
	lower := strings.ToLower(oldMaterial)
	for _, token := range strings.Split(oldMaterial, "`") {
		token = normalizeKnowledgePath(token)
		if strings.Contains(token, "/") && strings.Contains(path, strings.TrimSuffix(token, "/")) {
			return true
		}
	}
	switch {
	case strings.Contains(lower, "codex brief"):
		return strings.Contains(path, "/04_development/") && strings.Contains(path, "codex_brief")
	case strings.Contains(lower, "handoff"):
		return strings.Contains(path, "/06_sessions_and_handoffs/")
	case strings.Contains(lower, "codex_status.md"):
		return strings.HasSuffix(path, "docs/repo/status/codex_status.md")
	}
	return false
}

func statusForSupersededClassification(classification string) string {
	value := strings.ToLower(classification)
	for _, pair := range []struct{ needle, status string }{{"superseded", "superseded"}, {"archive", "archive"}, {"handoff", "handoff-history"}, {"evidence", "evidence"}, {"history", "history"}} {
		if strings.Contains(value, pair.needle) {
			return pair.status
		}
	}
	return classification
}

func normalizeKnowledgePath(path string) string {
	path = filepath.ToSlash(strings.TrimPrefix(strings.TrimSpace(path), "./"))
	lower := strings.ToLower(path)
	for _, marker := range []string{"docs/drive/shelter/", "docs/repo/", "steam/", "project_rules.md", "agents.md", "readme.md"} {
		if index := strings.Index(lower, marker); index >= 0 {
			return lower[index:]
		}
	}
	return lower
}

func knowledgePathMatches(path, catalogPath string) bool {
	catalog := strings.ToLower(filepath.ToSlash(catalogPath))
	if strings.HasSuffix(catalog, "/**") {
		return strings.HasPrefix(path, strings.TrimSuffix(catalog, "**"))
	}
	return path == catalog || strings.HasSuffix(path, "/"+catalog)
}

func gcMaxEntries(value int) int {
	if value <= 0 {
		return defaultKnowledgeGCMaxEntries
	}
	if value > maxKnowledgeGCEntries {
		return maxKnowledgeGCEntries
	}
	return value
}

func collectKnowledgeGCCandidates(snapshot KnowledgeSourceSnapshot, root, area string, maxEntries int) ([]KnowledgePathFinding, []SupersededExplanation, []string) {
	var history []KnowledgePathFinding
	var superseded []SupersededExplanation
	var notes []string
	seenHistory, seenSuperseded := map[string]bool{}, map[string]bool{}
	roots := []string{"docs/drive/Shelter/06_SESSIONS_AND_HANDOFFS", "docs/drive/Shelter/03_DESIGN/04_DELIVERABLES", "docs/drive/Shelter/99_ARCHIVE", "docs/drive/Shelter/04_DEVELOPMENT", "docs/repo/status"}
	for _, relRoot := range roots {
		absRoot := filepath.Join(root, relRoot)
		if _, err := os.Stat(absRoot); err != nil {
			continue
		}
		err := filepath.WalkDir(absRoot, func(path string, entry fs.DirEntry, err error) error {
			if err != nil {
				notes = append(notes, fmt.Sprintf("skipped %s: %v", filepath.ToSlash(path), err))
				return nil
			}
			if entry.IsDir() {
				if entry.Name() == ".git" || entry.Name() == ".runtime" {
					return filepath.SkipDir
				}
				return nil
			}
			if strings.ToLower(filepath.Ext(entry.Name())) != ".md" {
				return nil
			}
			rel, relErr := filepath.Rel(root, path)
			if relErr != nil {
				return nil
			}
			rel = filepath.ToSlash(rel)
			if !gcPathMatchesArea(rel, area) {
				return nil
			}
			classification := classifyKnowledgePath(snapshot, rel)
			if classification.Layer == knowledgeLayerHistory && !seenHistory[classification.Path] && len(history) < maxEntries {
				seenHistory[classification.Path] = true
				history = append(history, KnowledgePathFinding{Path: rel, Layer: classification.Layer, Status: classification.Status, ReadPolicy: classification.ReadPolicy, Reason: classification.Reason})
			}
			explanation := explainSupersededPath(snapshot, rel)
			if explanation.Classification != "unknown" && !seenSuperseded[explanation.Path] && len(superseded) < maxEntries {
				seenSuperseded[explanation.Path] = true
				superseded = append(superseded, explanation)
			}
			if len(history) >= maxEntries && len(superseded) >= maxEntries {
				return filepath.SkipAll
			}
			return nil
		})
		if err != nil {
			notes = append(notes, fmt.Sprintf("walk failed for %s: %v", relRoot, err))
		}
	}
	sort.Slice(history, func(i, j int) bool { return history[i].Path < history[j].Path })
	sort.Slice(superseded, func(i, j int) bool { return superseded[i].Path < superseded[j].Path })
	return history, superseded, notes
}

func gcPathMatchesArea(path, area string) bool {
	lower := strings.ToLower(filepath.ToSlash(path))
	switch area {
	case "steam":
		return strings.Contains(lower, "steam") || strings.Contains(lower, "03_design/04_deliverables") || strings.Contains(lower, "04_development/steam_desktop")
	case "mcp":
		return strings.Contains(lower, "shelter_mcp") || strings.Contains(lower, "codex_status.md") || strings.Contains(lower, "codex_current_status.md")
	case "docs":
		return true
	case "browser":
		return strings.Contains(lower, "browser") || strings.Contains(lower, "03_browser_extension")
	case "mobile":
		return strings.Contains(lower, "mobile") || strings.Contains(lower, "02_mobile")
	default:
		return true
	}
}

func missingCurrentContextCandidates(area string) []string {
	switch area {
	case "browser":
		return []string{"docs/drive/Shelter/02_PRODUCTS/03_BROWSER_EXTENSION/BROWSER_EXTENSION__CURRENT_CONTEXT.md"}
	case "mobile":
		return []string{"docs/drive/Shelter/02_PRODUCTS/02_MOBILE/MOBILE__CURRENT_CONTEXT.md"}
	default:
		return nil
	}
}

func fileExists(root, relPath string) bool {
	if root == "" || relPath == "" {
		return false
	}
	info, err := os.Stat(filepath.Join(root, filepath.FromSlash(relPath)))
	return err == nil && !info.IsDir()
}
