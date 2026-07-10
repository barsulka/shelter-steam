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
)

var validKnowledgeAreas = map[string]bool{
	"steam":   true,
	"mcp":     true,
	"docs":    true,
	"browser": true,
	"mobile":  true,
	"generic": true,
}

var validDecisionAreas = map[string]bool{
	"steam":   true,
	"mcp":     true,
	"docs":    true,
	"browser": true,
	"mobile":  true,
	"shared":  true,
	"all":     true,
	"generic": true,
}

var validStatusAreas = map[string]bool{
	"steam":   true,
	"docs":    true,
	"mcp":     true,
	"browser": true,
	"mobile":  true,
	"generic": true,
}

var validDecisionKinds = map[string]bool{
	"all":           true,
	"product":       true,
	"technical":     true,
	"process":       true,
	"documentation": true,
	"ethics":        true,
}

var validOpenQuestionAreas = map[string]bool{
	"steam":    true,
	"docs":     true,
	"browser":  true,
	"mobile":   true,
	"shared":   true,
	"charity":  true,
	"platform": true,
	"generic":  true,
}

var validOpenQuestionStatuses = map[string]bool{
	"open":               true,
	"partially_resolved": true,
	"deferred":           true,
	"needs_research":     true,
	"all":                true,
}

var validRoadmapAreas = map[string]bool{
	"steam":         true,
	"docs":          true,
	"mcp":           true,
	"game_design":   true,
	"art_direction": true,
	"generic":       true,
}

var validKnowledgeRoles = map[string]bool{
	"producer":        true,
	"project_manager": true,
	"game_designer":   true,
	"art_director":    true,
	"codex":           true,
	"generic":         true,
}

var validHandoffAreas = map[string]bool{
	"steam":   true,
	"docs":    true,
	"mcp":     true,
	"generic": true,
}

var validTaskAreas = map[string]bool{
	"steam":   true,
	"docs":    true,
	"mcp":     true,
	"browser": true,
	"mobile":  true,
	"generic": true,
}

var validTaskKinds = map[string]bool{
	"decision":       true,
	"implementation": true,
	"cleanup":        true,
	"art_review":     true,
	"game_design":    true,
	"research":       true,
	"handoff":        true,
	"generic":        true,
}

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

func knowledgeCatalog() []KnowledgeDoc {
	return []KnowledgeDoc{
		{
			Path:       docBootstrapContext,
			Areas:      []string{"all"},
			Status:     "current-summary",
			Layer:      knowledgeLayerCurrent,
			Purpose:    "compressed entry point for new Shelter sessions",
			ReadPolicy: "bootstrap",
		},
		{
			Path:       docCurrentStatus,
			Areas:      []string{"all"},
			Status:     "active",
			Layer:      knowledgeLayerCurrent,
			Purpose:    "current project picture",
			ReadPolicy: "bootstrap",
		},
		{
			Path:       docSteamCurrent,
			Areas:      []string{"steam"},
			Status:     "current-summary",
			Layer:      knowledgeLayerCurrent,
			Purpose:    "Steam/Desktop current context",
			ReadPolicy: "area-bootstrap",
		},
		{
			Path:       docGameDesignCurrent,
			Areas:      []string{"steam"},
			Status:     "current-summary",
			Layer:      knowledgeLayerCurrent,
			Purpose:    "Steam/Desktop game design current context",
			ReadPolicy: "role-bootstrap for game design work",
		},
		{
			Path:       docArtDirectionCurrent,
			Areas:      []string{"steam"},
			Status:     "current-summary",
			Layer:      knowledgeLayerCurrent,
			Purpose:    "Steam/Desktop art direction current context",
			ReadPolicy: "role-bootstrap for art direction work",
		},
		{
			Path:       docCodexCurrentStatus,
			Areas:      []string{"mcp", "docs", "generic"},
			Status:     "current-summary",
			Layer:      knowledgeLayerCurrent,
			Purpose:    "short current dev status",
			ReadPolicy: "dev-bootstrap",
		},
		{
			Path:       docCodexImplementation,
			Areas:      []string{"mcp", "docs"},
			Status:     "current-summary",
			Layer:      knowledgeLayerCurrent,
			Purpose:    "current Codex and implementation context",
			ReadPolicy: "dev-bootstrap",
		},
		{
			Path:       docDecisions,
			Areas:      []string{"all"},
			Status:     "active",
			Layer:      knowledgeLayerActive,
			Purpose:    "accepted project decisions",
			ReadPolicy: "read by task",
		},
		{
			Path:       docPhilosophy,
			Areas:      []string{"all"},
			Status:     "active",
			Layer:      knowledgeLayerActive,
			Purpose:    "project philosophy and constitution",
			ReadPolicy: "read for product-level decisions",
		},
		{
			Path:       docOpenQuestions,
			Areas:      []string{"docs", "generic"},
			Status:     "active",
			Layer:      knowledgeLayerActive,
			Purpose:    "live unresolved project questions",
			ReadPolicy: "read by task",
		},
		{
			Path:       docStressTests,
			Areas:      []string{"steam", "docs", "generic"},
			Status:     "active",
			Layer:      knowledgeLayerActive,
			Purpose:    "Shelter product stress tests",
			ReadPolicy: "read for product validation",
		},
		{
			Path:       docGovernance,
			Areas:      []string{"docs", "mcp", "generic"},
			Status:     "active",
			Layer:      knowledgeLayerActive,
			Purpose:    "documentation governance and Knowledge GC rules",
			ReadPolicy: "read for docs/PM/bootstrap work",
		},
		{
			Path:       docEvidenceReadPolicy,
			Areas:      []string{"docs", "steam", "mcp", "generic"},
			Status:     "active",
			Layer:      knowledgeLayerActive,
			Purpose:    "documentation governance evidence read policy",
			ReadPolicy: "read before opening evidence, capture, archive, or completed-brief history",
		},
		{
			Path:       docSupersededMap,
			Areas:      []string{"docs", "mcp", "generic"},
			Status:     "active current-summary",
			Layer:      knowledgeLayerActive,
			Purpose:    "compression map for superseded/history documents",
			ReadPolicy: "read before archaeology or PM cleanup",
		},
		{
			Path:       docKnowledgeBasePolishRoadmap,
			Areas:      []string{"docs", "mcp", "generic"},
			Status:     "active short roadmap",
			Layer:      knowledgeLayerActive,
			Purpose:    "short roadmap for fresh-session entry polish",
			ReadPolicy: "read for documentation polish and MCP dashboard work",
		},
		{
			Path:       docADRIndex,
			Areas:      []string{"steam", "mcp"},
			Status:     "active",
			Layer:      knowledgeLayerActive,
			Purpose:    "accepted technical decision index",
			ReadPolicy: "read before technical implementation",
		},
		{
			Path:       docCodexStatus,
			Areas:      []string{"mcp", "docs", "generic"},
			Status:     "history",
			Layer:      knowledgeLayerHistory,
			Purpose:    "detailed chronological Codex development log",
			ReadPolicy: "read latest entry or use for implementation archaeology",
		},
		{
			Path:       "docs/drive/Shelter/06_SESSIONS_AND_HANDOFFS/**",
			Areas:      []string{"all"},
			Status:     "handoff-history",
			Layer:      knowledgeLayerHistory,
			Purpose:    "session handoffs and historical transfer notes",
			ReadPolicy: "read only latest relevant handoff when needed",
		},
		{
			Path:       "docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/**",
			Areas:      []string{"steam", "docs"},
			Status:     "evidence",
			Layer:      knowledgeLayerHistory,
			Purpose:    "capture packs and review evidence",
			ReadPolicy: "read only for proof, review, regression, or archaeology",
		},
		{
			Path:       "docs/drive/Shelter/99_ARCHIVE/**",
			Areas:      []string{"all"},
			Status:     "archive",
			Layer:      knowledgeLayerHistory,
			Purpose:    "archived historical material",
			ReadPolicy: "do not read on bootstrap",
		},
	}
}

func decisionCatalog() []KnowledgeDecision {
	return []KnowledgeDecision{
		{ID: "D-001", Title: "Google Drive - project knowledge base", Kind: "documentation", Status: "accepted", Summary: "Product docs, research, design, session logs, finance and charity planning live in Google Drive under Shelter/.", SourcePath: docDecisions, Areas: []string{"docs", "mcp", "generic"}},
		{ID: "D-002", Title: "GitHub repo is the development source", Kind: "technical", Status: "accepted", Summary: "Code, dev documentation, ADRs, build/test instructions and Codex working status live in the GitHub repository; Codex treats repo docs as primary.", SourcePath: docDecisions, Areas: []string{"docs", "mcp", "generic"}},
		{ID: "D-003", Title: "Serious sessions start from project index", Kind: "process", Status: "accepted", Summary: "Serious sessions begin from the project index, current status, decisions, role/product docs and latest relevant handoff.", SourcePath: docDecisions, Areas: []string{"docs", "mcp", "generic"}},
		{ID: "D-004", Title: "Codex needs AGENTS.md", Kind: "process", Status: "accepted", Summary: "The repo must provide AGENTS.md with project constraints, source rules, dev process, test expectations and documentation duties.", SourcePath: docDecisions, Areas: []string{"docs", "mcp", "generic"}},
		{ID: "D-005", Title: "Product tone and ethics", Kind: "ethics", Status: "accepted", Summary: "Shelter stays warm, calm and respectful; no user pressure, exploitative mechanics or aggressive game patterns.", SourcePath: docDecisions, Areas: []string{"steam", "browser", "mobile", "shared", "generic"}},
		{ID: "D-006", Title: "Initial product set", Kind: "product", Status: "accepted", Summary: "Shelter starts from three possible products: Desktop/Steam idle game, mobile idle/farm game and browser extension.", SourcePath: docDecisions, Areas: []string{"steam", "browser", "mobile", "shared", "generic"}},
		{ID: "D-007", Title: "Steam/Desktop engine is Godot", Kind: "technical", Status: "accepted", Summary: "Steam/Desktop uses Godot 4.x as the main engine, with GDScript first and native/C# only where a real need appears.", SourcePath: docDecisions, Areas: []string{"steam"}},
		{ID: "D-008", Title: "Browser Extension core loop", Kind: "product", Status: "accepted", Summary: "Browser Extension loop is sponsor farm to food production to shelter van, with ethical sponsorship that never blocks core play.", SourcePath: docDecisions, Areas: []string{"browser"}},
		{ID: "D-009", Title: "Steam/Desktop horizontal dog production co-op", Kind: "product", Status: "accepted", Summary: "Steam/Desktop is a cozy idle production strip plus dog community sim, not a classical farm or cold factory.", SourcePath: docDecisions, Areas: []string{"steam"}},
		{ID: "D-010", Title: "Dogs have innate and changeable traits", Kind: "product", Status: "accepted", Summary: "Innate dog traits are identity and cannot be erased; equipment, rooms, training and habits can modify without replacing personality.", SourcePath: docDecisions, Areas: []string{"steam", "shared"}},
		{ID: "D-011", Title: "Cozy Modular Diorama visual candidate", Kind: "product", Status: "accepted", Summary: "Cozy Modular Diorama is the main visual direction candidate pending style board, readability and production-cost checks.", SourcePath: docDecisions, Areas: []string{"steam", "browser", "shared"}},
		{ID: "D-012", Title: "Shared World: Browser Farm supplies Steam Co-op", Kind: "product", Status: "accepted", Summary: "Steam/Desktop and Browser Extension are separate parts of one dog world; MVP linkage is narrative-only, not mandatory sync.", SourcePath: docDecisions, Areas: []string{"steam", "browser", "shared"}},
		{ID: "D-013", Title: "Steam resource trips replace visible crop farming", Kind: "product", Status: "accepted", Summary: "Steam/Desktop does not use classical visible crop farming as core; raw materials come from off-screen dog trips with physical unloading.", SourcePath: docDecisions, Areas: []string{"steam"}},
		{ID: "D-014", Title: "Role boundaries and working roadmaps", Kind: "process", Status: "accepted", Summary: "AI roles have explicit boundaries, and executor roles use working roadmaps as living plans rather than decisions.", SourcePath: docDecisions, Areas: []string{"steam", "browser", "mobile", "docs", "mcp", "shared", "generic"}},
		{ID: "D-015", Title: "Cross-role collaboration via RFC documents", Kind: "process", Status: "accepted", Summary: "Cross-role discussion uses local RFC docs; role positions count only when filled by that role or accepted by Producer synthesis.", SourcePath: docDecisions, Areas: []string{"docs", "mcp", "shared", "generic"}},
		{ID: "D-016", Title: "Steam Vertical Slice Codex boundaries", Kind: "process", Status: "accepted", Summary: "Codex implements accepted contracts and tooling but must not silently change gameplay, visual, product or ethical scope.", SourcePath: docDecisions, Areas: []string{"steam", "mcp", "docs"}},
		{ID: "D-017", Title: "Codex tasks require 04_DEVELOPMENT briefs", Kind: "process", Status: "accepted", Summary: "Significant Codex tasks must be assigned through dedicated brief files under docs/drive/Shelter/04_DEVELOPMENT/.", SourcePath: docDecisions, Areas: []string{"docs", "mcp", "generic"}},
		{ID: "D-018", Title: "Vertical Slice gameplay proof unlocks systems branch", Kind: "process", Status: "accepted", Summary: "Steam Vertical Slice gameplay proof is enough for Game Designer systems work; visual proof remains separate and Art Director-owned.", SourcePath: docDecisions, Areas: []string{"steam", "mcp", "docs"}},
		{ID: "D-019", Title: "Game Design Systems Workbench over live Godot", Kind: "technical", Status: "accepted", Summary: "Game Design Systems Workbench observes and controls accepted surfaces of the live Godot runtime; it must not become a standalone simulator.", SourcePath: docDecisions, Areas: []string{"steam", "mcp", "docs"}},
		{ID: "D-020", Title: "Project Philosophy / Shelter Constitution", Kind: "ethics", Status: "accepted", Summary: "Project Philosophy / Constitution: Shelter makes life richer, not the warehouse; every system must first enrich the dogs' cooperative life.", SourcePath: docDecisions, Areas: []string{"all"}},
	}
}

func openQuestionCatalog() []OpenQuestion {
	return []OpenQuestion{
		{ID: "OQ-Steam-001", Title: "Is First Week / Day 2 direction ready for implementation?", Area: "steam", Status: "open", Owner: "Producer / Game Designer", Summary: "Decide whether First Week Direction v1 is ready to become the next executable Codex slice.", SourcePath: docOpenQuestions, Sources: []string{docSteamCurrent, "docs/drive/Shelter/02_PRODUCTS/01_STEAM_DESKTOP/STEAM_DESKTOP__First_Week_Direction_v1.md"}},
		{ID: "OQ-Steam-002", Title: "First Week scope boundary", Area: "steam", Status: "open", Owner: "Producer / Game Designer", Summary: "Hold the Day 2 / First Week boundary and decide what not to add to the next executable slice.", SourcePath: docOpenQuestions},
		{ID: "OQ-Steam-003", Title: "Production art gate after prototype visual-language pass", Area: "steam", Status: "open", Owner: "Art Director / Producer", Summary: "Define when prototype readability becomes production visual style work and which evidence remains history-only.", SourcePath: docOpenQuestions},
		{ID: "OQ-Docs-001", Title: "Which old docs need metadata/read_policy?", Area: "docs", Status: "open", Owner: "Project Manager / Knowledge Base Maintainer", Summary: "Choose which old capture packs, briefs and docs should be marked evidence, handoff-history or superseded first.", SourcePath: docOpenQuestions, Sources: []string{docGovernance, docSupersededMap}},
		{ID: "OQ-Docs-002", Title: "Need current-context docs for Art Direction and Game Design?", Area: "docs", Status: "open", Owner: "Project Manager / Art Director / Game Designer", Summary: "Decide whether Art Direction and Game Design need their own current-context documents or Steam current-context is enough for now.", SourcePath: docOpenQuestions},
		{ID: "OQ-Docs-003", Title: "Split or archive CODEX_STATUS.md by month?", Area: "docs", Status: "deferred", Owner: "Project Manager / Codex", Summary: "Deferred question about when the detailed Codex history log becomes too large and needs monthly splitting.", SourcePath: docOpenQuestions, Sources: []string{docCodexCurrentStatus, docCodexStatus}},
		{ID: "OQ-Browser-001", Title: "Browser Extension MVP scope", Area: "browser", Status: "open", Owner: "Producer / Game Designer / future Tech Lead", Summary: "Define minimal Browser Extension MVP scope, stack, UX, data handling, sponsorship mechanics and safe claims.", SourcePath: docOpenQuestions, Sources: []string{docDecisions}},
		{ID: "OQ-Mobile-001", Title: "Mobile product scope and stack", Area: "mobile", Status: "deferred", Owner: "Producer / future Tech Lead", Summary: "Decide whether mobile comes before Steam validation, how separate it is and which stack/shared contracts it needs.", SourcePath: docOpenQuestions},
		{ID: "OQ-Shared-001", Title: "Shared economy, account and sync", Area: "shared", Status: "partially_resolved", Owner: "Producer / future Tech Lead", Summary: "MVP has narrative-only connection, but shared account, backend, economy, content and trust layer remain open.", SourcePath: docOpenQuestions, Sources: []string{docDecisions}},
		{ID: "OQ-Charity-001", Title: "Charity reporting and real-world claims", Area: "charity", Status: "needs_research", Owner: "Producer / Legal-Finance / specialist review", Summary: "Define charity reporting, shelter relationships, legal claims and disclaimers through research and specialist review.", SourcePath: docOpenQuestions},
		{ID: "OQ-Platform-001", Title: "Browser Extension platform/legal checks", Area: "platform", Status: "needs_research", Owner: "Producer / future Tech Lead / specialist review", Summary: "Check privacy, consent, personal data, ads formats, Chrome Web Store policy, sponsorship disclosure and charity claims.", SourcePath: docOpenQuestions},
	}
}

func roadmapCatalog() []KnowledgeRoadmap {
	return []KnowledgeRoadmap{
		{ID: "knowledge_base_polish_roadmap", Title: "Knowledge Base Polish Roadmap", Path: docKnowledgeBasePolishRoadmap, Areas: []string{"docs", "mcp"}, Status: "active short roadmap", CurrentPhase: "Decision Catalog / dashboard entry polish, current-context template standardization, and current-status guardrails.", NextStep: "Implement decision digest and dashboard MCP tools, then continue PM current-context/status polish.", Owner: "Project Manager / Producer"},
		{ID: "knowledge_base_roadmap", Title: "Knowledge Base Roadmap", Path: docKnowledgeBaseRoadmap, Areas: []string{"docs", "mcp"}, Status: "active roadmap", CurrentPhase: "MCP Knowledge API v2 implemented; Knowledge polish roadmap now tracks remaining fresh-session entry friction.", NextStep: "Use Knowledge Base Polish Roadmap for immediate decision/dashboard/current-context polish.", Owner: "Project Manager / Producer"},
		{ID: "steam_game_design_roadmap_v2", Title: "Steam Desktop Game Design Roadmap v2", Path: docSteamGameRoadmapV2, Areas: []string{"steam", "game_design"}, Status: "active roadmap", CurrentPhase: "First Week / Day 2 and longer retention direction after First Day MVP prototype proof.", NextStep: "Prepare or approve R-28 Day 2 Return And Second Warm Delivery Codex brief v1.", Owner: "Game Designer / Producer"},
	}
}

func handoffCatalog() []KnowledgeHandoff {
	return []KnowledgeHandoff{
		{Date: "2026-07-07", Title: "Knowledge Base Phase 2 Cleanup", Path: "docs/drive/Shelter/06_SESSIONS_AND_HANDOFFS/producer/2026-07-07__producer_pm_handoff__knowledge_base_phase_2_cleanup.md", Roles: []string{"producer", "project_manager"}, Areas: []string{"docs", "mcp"}, Summary: "Latest Producer/PM handoff for decisions, roadmaps, handoff index and current-context cleanup after Phase 2.", SourceType: "static-catalog", priority: 120},
		{Date: "2026-07-07", Title: "Documentation Governance And Knowledge GC", Path: "docs/drive/Shelter/06_SESSIONS_AND_HANDOFFS/producer/2026-07-07__producer_handoff__documentation_governance_and_gc.md", Roles: []string{"producer", "project_manager"}, Areas: []string{"docs", "mcp"}, Summary: "Background docs/governance handoff for documentation governance, Knowledge GC and PM cleanup rules.", SourceType: "static-catalog", priority: 100},
		{Date: "2026-07-07", Title: "Documentation Compression / Bootstrap Layer", Path: "docs/drive/Shelter/06_SESSIONS_AND_HANDOFFS/producer/2026-07-07__producer_handoff__documentation_compression_bootstrap_layer.md", Roles: []string{"producer", "project_manager"}, Areas: []string{"docs"}, Summary: "Producer handoff for Current Memory, Knowledge, History and bootstrap-layer compression.", SourceType: "static-catalog", priority: 90},
		{Date: "2026-07-01", Title: "Steam Runtime Capture Roadmap", Path: "docs/drive/Shelter/06_SESSIONS_AND_HANDOFFS/design/2026-07-01__game_design_handoff__steam_runtime_capture_roadmap.md", Roles: []string{"game_designer"}, Areas: []string{"steam"}, Summary: "Game Design handoff about runtime capture roadmap and design inspection path.", SourceType: "static-catalog", priority: 80},
		{Date: "2026-06-30", Title: "Game Systems Workbench", Path: "docs/drive/Shelter/06_SESSIONS_AND_HANDOFFS/producer/2026-06-30__producer_handoff__game_systems_workbench.md", Roles: []string{"producer", "game_designer", "codex"}, Areas: []string{"steam", "mcp"}, Summary: "Producer handoff for Workbench over live Godot runtime and systems roadmap direction.", SourceType: "static-catalog", priority: 70},
		{Date: "2026-06-29", Title: "Steam Vertical Slice Art QA", Path: "docs/drive/Shelter/06_SESSIONS_AND_HANDOFFS/design/2026-06-29__design_handoff__steam_vertical_slice_art_qa.md", Roles: []string{"art_director"}, Areas: []string{"steam"}, Summary: "Design handoff for Steam Vertical Slice art QA and visual review path.", SourceType: "static-catalog", priority: 60},
	}
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
	switch layer {
	case "current", "knowledge", "history", "all":
		return layer, nil
	default:
		return "", fmt.Errorf("unsupported layer %q; expected current, knowledge, history, or all", layer)
	}
}

func layerMatches(doc KnowledgeDoc, layer string) bool {
	switch layer {
	case "all":
		return true
	case "current":
		return doc.Layer == knowledgeLayerCurrent
	case "knowledge":
		return doc.Layer == knowledgeLayerActive
	case "history":
		return doc.Layer == knowledgeLayerHistory
	default:
		return false
	}
}

func catalogDocsFor(area, layer string) []KnowledgeDoc {
	var docs []KnowledgeDoc
	for _, doc := range knowledgeCatalog() {
		if docMatchesArea(doc, area) && layerMatches(doc, layer) {
			docs = append(docs, doc)
		}
	}
	return docs
}

func docMatchesArea(doc KnowledgeDoc, area string) bool {
	for _, item := range doc.Areas {
		if item == "all" || item == area {
			return true
		}
		if area == "generic" && item == "generic" {
			return true
		}
	}
	return false
}

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

func decisionsFor(area, kind string) []KnowledgeDecision {
	var decisions []KnowledgeDecision
	for _, decision := range decisionCatalog() {
		if !knowledgeAreasMatch(decision.Areas, area) {
			continue
		}
		if kind != "all" && decision.Kind != kind {
			continue
		}
		decisions = append(decisions, decision)
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

func decisionDigestFor(area string, maxItems int) []DecisionDigestItem {
	decisions := decisionsFor(area, "all")
	limit := digestMaxItems(maxItems)
	if len(decisions) > limit {
		decisions = decisions[:limit]
	}
	items := make([]DecisionDigestItem, 0, len(decisions))
	for _, decision := range decisions {
		items = append(items, DecisionDigestItem{
			ID:      decision.ID,
			Title:   decision.Title,
			Summary: decision.Summary,
		})
	}
	return items
}

func decisionByID(id string) (KnowledgeDecision, bool) {
	id = strings.ToUpper(strings.TrimSpace(id))
	for _, decision := range decisionCatalog() {
		if decision.ID == id {
			return decision, true
		}
	}
	return KnowledgeDecision{}, false
}

func decisionIDs() []string {
	ids := make([]string, 0, len(decisionCatalog()))
	for _, decision := range decisionCatalog() {
		ids = append(ids, decision.ID)
	}
	return ids
}

func openQuestionsFor(area, status string) []OpenQuestion {
	var questions []OpenQuestion
	for _, question := range openQuestionCatalog() {
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

func openQuestionsDigestFor(area, status string) []OpenQuestionDigestItem {
	var questions []OpenQuestion
	for _, question := range openQuestionCatalog() {
		if !openQuestionMatchesDigestArea(question, area) {
			continue
		}
		if status != "all" && question.Status != status {
			continue
		}
		questions = append(questions, question)
	}
	items := make([]OpenQuestionDigestItem, 0, len(questions))
	for _, question := range questions {
		items = append(items, OpenQuestionDigestItem{
			ID:      question.ID,
			Title:   question.Title,
			Status:  question.Status,
			Summary: question.Summary,
		})
	}
	return items
}

func openQuestionMatchesDigestArea(question OpenQuestion, area string) bool {
	switch area {
	case "generic":
		return true
	case "browser":
		return question.Area == "browser" || question.Area == "platform" || question.Area == "charity" || question.Area == "shared"
	default:
		return question.Area == area
	}
}

func roadmapsFor(area string) []KnowledgeRoadmap {
	var roadmaps []KnowledgeRoadmap
	for _, roadmap := range roadmapCatalog() {
		if knowledgeAreasMatch(roadmap.Areas, area) {
			roadmaps = append(roadmaps, roadmap)
		}
	}
	return roadmaps
}

func latestHandoffFor(root, role, area string) (KnowledgeHandoff, []KnowledgeHandoff) {
	var matches []KnowledgeHandoff
	for _, handoff := range handoffCatalog() {
		if role != "generic" && !knowledgeAreasMatch(handoff.Roles, role) {
			continue
		}
		if area != "generic" && !knowledgeAreasMatch(handoff.Areas, area) {
			continue
		}
		handoff.Available = fileExists(root, handoff.Path)
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

func statusDashboardFor(root, area string) ShelterStatusDashboard {
	switch area {
	case "steam":
		handoff, _ := latestHandoffFor(root, "producer", "steam")
		return ShelterStatusDashboard{
			Area:           area,
			CurrentFocus:   "Steam/Desktop",
			CurrentScope:   "First Week / Day 2 / longer retention",
			CurrentPhase:   "First Day MVP is locked at prototype/product-language level; next selected scope is First Week / Day 2.",
			CurrentRoadmap: docSteamGameRoadmapV2,
			CurrentTask:    "R-28 — Day 2 Return And Second Warm Delivery Codex Brief v1",
			ActiveDecisions: pickDecisionDigestIDs([]string{
				"D-007", "D-009", "D-010", "D-013", "D-020",
			}),
			ActiveOpenQuestions: openQuestionsDigestFor("steam", "all"),
			BlockedByOrRisks: []string{
				"OQ-Steam-001: First Week / Day 2 direction needs Producer/Game Designer approval before implementation brief.",
				"OQ-Steam-002: First Week boundary must stay narrow.",
				"OQ-Steam-003: production art gate remains open after prototype visual-language pass.",
			},
			LatestHandoff: latestHandoffPtr(handoff),
			ReadFirst: []string{
				docBootstrapContext,
				docCurrentStatus,
				docSteamCurrent,
				docGameDesignCurrent,
			},
			NextBestStep: "Prepare/approve the Day 2 Return And Second Warm Delivery Codex brief.",
			Notes: []string{
				"Steam/Desktop must stay separate from Browser Extension UX.",
				"First Day lock is not production art, shipping UX, final balance or release readiness.",
			},
		}
	case "docs":
		handoff, _ := latestHandoffFor(root, "producer", "docs")
		return ShelterStatusDashboard{
			Area:           area,
			CurrentFocus:   "Documentation / Knowledge Base",
			CurrentScope:   "Fresh-session entry polish after Phase 2 cleanup",
			CurrentPhase:   "Knowledge Base Polish Roadmap",
			CurrentRoadmap: docKnowledgeBasePolishRoadmap,
			CurrentTask:    "Decision digest / dashboard plus current-context template and current-status guardrail",
			ActiveDecisions: pickDecisionDigestIDs([]string{
				"D-001", "D-002", "D-003", "D-014", "D-015", "D-017", "D-020",
			}),
			ActiveOpenQuestions: openQuestionsDigestFor("docs", "all"),
			BlockedByOrRisks: []string{
				"01_CURRENT_STATUS.md must not grow into a full index.",
				"History/evidence should stay behind SUPERSEDED_MAP, EVIDENCE_READ_POLICY and HANDOFF_INDEX.",
			},
			LatestHandoff: latestHandoffPtr(handoff),
			ReadFirst: []string{
				docBootstrapContext,
				docCurrentStatus,
				docKnowledgeBasePolishRoadmap,
			},
			NextBestStep: "Use MCP digest/dashboard tools for fresh sessions, then continue current-context template standardization.",
			Notes: []string{
				"Fix entry friction, not history.",
				"Do not split 02_DECISIONS.md unless static MCP catalog stops being enough.",
			},
		}
	case "mcp":
		handoff, _ := latestHandoffFor(root, "codex", "mcp")
		return ShelterStatusDashboard{
			Area:           area,
			CurrentFocus:   "Shelter MCP knowledge and safe dev bridge",
			CurrentScope:   "Knowledge polish tools over existing Knowledge API v2",
			CurrentPhase:   "MCP Knowledge API is evolving into compact fresh-session entry tools.",
			CurrentRoadmap: docKnowledgeBasePolishRoadmap,
			CurrentTask:    "decision_digest, shelter_status, open_questions_digest, current_entry_digest",
			ActiveDecisions: pickDecisionDigestIDs([]string{
				"D-002", "D-004", "D-017", "D-019", "D-020",
			}),
			ActiveOpenQuestions: openQuestionsDigestFor("docs", "all"),
			BlockedByOrRisks: []string{
				"Knowledge tools must remain read-only, deterministic, bounded and static-catalog/simple-rule based.",
			},
			LatestHandoff: latestHandoffPtr(handoff),
			ReadFirst: []string{
				docBootstrapContext,
				docCodexCurrentStatus,
				docCodexImplementation,
			},
			NextBestStep: "Keep MCP knowledge tools compact and avoid broad search or summarization.",
			Notes: []string{
				"Shelter MCP is not a generic shell.",
			},
		}
	case "browser":
		return ShelterStatusDashboard{
			Area:           area,
			CurrentFocus:   "Browser Extension",
			CurrentScope:   "Future product; product loop accepted, implementation not started.",
			CurrentPhase:   "MVP scope/platform/legal research pending",
			CurrentRoadmap: "",
			CurrentTask:    "Define MVP scope and platform/legal constraints before implementation brief.",
			ActiveDecisions: pickDecisionDigestIDs([]string{
				"D-008", "D-012", "D-020",
			}),
			ActiveOpenQuestions: openQuestionsDigestFor("browser", "all"),
			BlockedByOrRisks: []string{
				"Browser Extension MVP scope is open.",
				"Platform/legal/privacy/ads/charity claims require research before implementation.",
			},
			ReadFirst: []string{
				docBootstrapContext,
				docCurrentStatus,
				docDecisions,
				docOpenQuestions,
			},
			NextBestStep: "Do platform/legal and MVP-scope research before any Browser Extension implementation brief.",
			Notes: []string{
				"No Browser Extension current-context document is registered yet.",
			},
		}
	case "mobile":
		return ShelterStatusDashboard{
			Area:           area,
			CurrentFocus:   "Mobile",
			CurrentScope:   "Deferred future product",
			CurrentPhase:   "Scope and stack deferred until Steam validation gives clearer direction.",
			CurrentRoadmap: "",
			CurrentTask:    "No active implementation task.",
			ActiveDecisions: pickDecisionDigestIDs([]string{
				"D-006", "D-020",
			}),
			ActiveOpenQuestions: openQuestionsDigestFor("mobile", "all"),
			BlockedByOrRisks: []string{
				"Mobile product scope and stack are deferred.",
			},
			ReadFirst: []string{
				docBootstrapContext,
				docCurrentStatus,
				docDecisions,
				docOpenQuestions,
			},
			NextBestStep: "Do not start mobile implementation until product priority changes.",
			Notes: []string{
				"No Mobile current-context document is registered yet.",
			},
		}
	default:
		return ShelterStatusDashboard{
			Area:           area,
			CurrentFocus:   "Shelter project",
			CurrentScope:   "Steam/Desktop is active; docs/MCP polish supports fresh-session entry.",
			CurrentPhase:   "First Week / Day 2 product direction plus Knowledge Base Polish Roadmap.",
			CurrentRoadmap: docKnowledgeBasePolishRoadmap,
			CurrentTask:    "Use area-specific status for Steam, docs, MCP, Browser or Mobile.",
			ActiveDecisions: pickDecisionDigestIDs([]string{
				"D-005", "D-006", "D-020",
			}),
			ActiveOpenQuestions: openQuestionsDigestFor("generic", "open"),
			BlockedByOrRisks: []string{
				"Use area-specific dashboards for implementation decisions.",
			},
			ReadFirst: []string{
				docBootstrapContext,
				docCurrentStatus,
			},
			NextBestStep: "Choose an area-specific dashboard.",
			Notes: []string{
				"Generic status intentionally stays compact.",
			},
		}
	}
}

func latestHandoffPtr(handoff KnowledgeHandoff) *KnowledgeHandoff {
	if handoff.Path == "" {
		return nil
	}
	return &handoff
}

func pickDecisionDigestIDs(ids []string) []DecisionDigestItem {
	var items []DecisionDigestItem
	for _, id := range ids {
		decision, ok := decisionByID(id)
		if !ok {
			continue
		}
		items = append(items, DecisionDigestItem{
			ID:      decision.ID,
			Title:   decision.Title,
			Summary: decision.Summary,
		})
	}
	return items
}

func currentEntryDigestFor(role, area string) CurrentEntryDigest {
	base := CurrentEntryDigest{
		Role: role,
		Area: area,
		ReadFirst: []string{
			docBootstrapContext,
			docCurrentStatus,
		},
		ReadNextByTask: []string{
			docDecisions,
			docOpenQuestions,
		},
		AvoidByDefault: []string{
			docCodexStatus,
			"docs/drive/Shelter/06_SESSIONS_AND_HANDOFFS/**",
			"docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/**",
			"docs/drive/Shelter/99_ARCHIVE/**",
		},
		Why: []string{
			"Fresh sessions should start from Current Memory, then task-specific Knowledge.",
			"History stays out of the default path unless evidence/regression/archaeology is needed.",
		},
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
		base.ReadNextByTask = appendUniqueStrings(base.ReadNextByTask, docKnowledgeBasePolishRoadmap, docADRIndex)
	case "browser", "mobile":
		base.ReadNextByTask = appendUniqueStrings(base.ReadNextByTask, docPhilosophy)
	}
	switch role {
	case "game_designer":
		if area == "steam" {
			base.ReadFirst = appendUniqueStrings(base.ReadFirst, "docs/drive/Shelter/00_START_HERE/000_ROLE_GAME_DESIGNER.md", docGameDesignCurrent)
			base.Why = append(base.Why, "Game Designer needs the Steam game-design current context before old roadmap/history files.")
		}
	case "art_director":
		if area == "steam" {
			base.ReadFirst = appendUniqueStrings(base.ReadFirst, "docs/drive/Shelter/00_START_HERE/000_ROLE_ART_DIRECTOR.md", docArtDirectionCurrent)
			base.Why = append(base.Why, "Art Direction starts from current visual context and latest evidence policy, not old capture packs.")
		}
	case "producer":
		base.ReadFirst = appendUniqueStrings(base.ReadFirst, "docs/drive/Shelter/00_START_HERE/000_ROLE_PRODUCER.md")
	case "project_manager":
		base.ReadFirst = appendUniqueStrings(base.ReadFirst, "docs/drive/Shelter/00_START_HERE/000_ROLE_PROJECT_MANAGER.md")
	case "codex":
		base.ReadFirst = appendUniqueStrings(base.ReadFirst, "docs/drive/Shelter/00_START_HERE/000_ROLE_CODEX.md", docCodexCurrentStatus, docCodexImplementation)
		base.ReadNextByTask = appendUniqueStrings(base.ReadNextByTask, docADRIndex)
	}
	return base
}

func fileExists(root, relPath string) bool {
	if root == "" || relPath == "" {
		return false
	}
	info, err := os.Stat(filepath.Join(root, filepath.FromSlash(relPath)))
	return err == nil && !info.IsDir()
}

func taskContextFor(role, area, task string) KnowledgeTaskContext {
	out := KnowledgeTaskContext{
		Role: role,
		Area: area,
		Task: task,
		ReadFirst: []string{
			docBootstrapContext,
			docCurrentStatus,
		},
		ReadByTask: []string{
			docDecisions,
			docOpenQuestions,
		},
		AvoidByDefault: []string{
			docCodexStatus,
			"docs/drive/Shelter/06_SESSIONS_AND_HANDOFFS/**",
			"docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/**",
			"docs/drive/Shelter/99_ARCHIVE/**",
		},
		Notes: []string{
			"Read Current Memory first, Knowledge by task, and History only for evidence/regression/archaeology.",
			"This is a deterministic reading-order catalog, not a summary or search result.",
		},
	}
	switch area {
	case "steam":
		out.ReadFirst = appendUniqueStrings(out.ReadFirst, docSteamCurrent)
		out.ReadByTask = appendUniqueStrings(out.ReadByTask, docPhilosophy, docSteamGameRoadmapV2)
	case "docs":
		out.ReadFirst = appendUniqueStrings(out.ReadFirst, docCodexCurrentStatus)
		out.ReadByTask = appendUniqueStrings(out.ReadByTask, docGovernance, docSupersededMap, docEvidenceReadPolicy, docKnowledgeBaseRoadmap)
	case "mcp":
		out.ReadFirst = appendUniqueStrings(out.ReadFirst, docCodexCurrentStatus, docCodexImplementation)
		out.ReadByTask = appendUniqueStrings(out.ReadByTask, docADRIndex, docKnowledgeBaseRoadmap)
	case "browser":
		out.ReadByTask = appendUniqueStrings(out.ReadByTask, docPhilosophy)
		out.Notes = append(out.Notes, "Browser has accepted decisions and open questions, but no current-context document is registered yet.")
	case "mobile":
		out.ReadByTask = appendUniqueStrings(out.ReadByTask, docPhilosophy)
		out.Notes = append(out.Notes, "Mobile is deferred and has no current-context document registered yet.")
	}
	if role == "codex" || task == "implementation" {
		out.ReadFirst = appendUniqueStrings(out.ReadFirst, docCodexCurrentStatus, docCodexImplementation)
		out.ReadByTask = appendUniqueStrings(out.ReadByTask, docADRIndex)
	}
	if role == "project_manager" && area == "docs" && task == "cleanup" {
		out.ReadFirst = appendUniqueStrings([]string{docBootstrapContext, docCurrentStatus, docCodexCurrentStatus}, docGovernance, docSupersededMap, docEvidenceReadPolicy, docOpenQuestions)
		out.ReadByTask = appendUniqueStrings([]string{docKnowledgeBaseRoadmap, docDecisions}, docCodexImplementation)
		out.Notes = append(out.Notes, "For project_manager/docs/cleanup, governance, superseded map, evidence policy, current status and open questions are mandatory.")
	}
	if task == "handoff" {
		out.ReadByTask = appendUniqueStrings(out.ReadByTask, "docs/drive/Shelter/06_SESSIONS_AND_HANDOFFS/**")
		out.Notes = append(out.Notes, "Read only the latest relevant handoff, not the full handoff history.")
	}
	return out
}

func appendUniqueStrings(values []string, extra ...string) []string {
	seen := map[string]bool{}
	var out []string
	for _, value := range append(values, extra...) {
		if value == "" || seen[value] {
			continue
		}
		seen[value] = true
		out = append(out, value)
	}
	return out
}

func knowledgeDocPaths(docs []KnowledgeDoc) []string {
	seen := map[string]bool{}
	var paths []string
	for _, doc := range docs {
		if !seen[doc.Path] {
			seen[doc.Path] = true
			paths = append(paths, doc.Path)
		}
	}
	return paths
}

func knowledgeAreaNotes(area string) []string {
	switch area {
	case "browser":
		return []string{
			"Browser Extension has a product folder, but no dedicated current-context document is registered yet.",
			"Use generic Current Memory first; create docs/drive/Shelter/02_PRODUCTS/03_BROWSER_EXTENSION/BROWSER_EXTENSION__CURRENT_CONTEXT.md when browser work becomes active.",
		}
	case "mobile":
		return []string{
			"Mobile has a product folder, but no dedicated current-context document is registered yet.",
			"Use generic Current Memory first; create docs/drive/Shelter/02_PRODUCTS/02_MOBILE/MOBILE__CURRENT_CONTEXT.md when mobile work becomes active.",
		}
	case "mcp":
		return []string{
			"MCP context currently routes through CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md and CODEX_CURRENT_STATUS.md.",
		}
	default:
		return nil
	}
}

func classifyKnowledgePath(rawPath string) KnowledgePathClassification {
	path := normalizeKnowledgePath(rawPath)
	out := KnowledgePathClassification{
		Path:       path,
		OK:         true,
		Layer:      "unknown",
		Status:     "unknown",
		ReadPolicy: "inspect SUPERSEDED_MAP.md and the relevant current-context document before reading broadly",
		Confidence: "low",
		Reason:     "Path is not in the static knowledge catalog and did not match a known history/superseded rule.",
	}
	for _, doc := range knowledgeCatalog() {
		if knowledgePathMatches(path, doc.Path) {
			docCopy := doc
			out.Layer = doc.Layer
			out.Status = doc.Status
			out.ReadPolicy = doc.ReadPolicy
			out.Confidence = "high"
			out.Reason = "Known document in the static Shelter knowledge catalog."
			out.KnownDoc = &docCopy
			return out
		}
	}

	explanation := explainSupersededPath(path)
	if explanation.Classification != "unknown" {
		out.Layer = knowledgeLayerHistory
		out.Status = statusForSupersededClassification(explanation.Classification)
		out.ReadPolicy = explanation.ReadPolicy
		out.Confidence = "high"
		out.Reason = explanation.Reason
		out.Notes = explanation.Notes
		return out
	}

	switch {
	case strings.Contains(path, "/06_sessions_and_handoffs/") || strings.HasPrefix(path, "docs/drive/shelter/06_sessions_and_handoffs/"):
		out.Layer = knowledgeLayerHistory
		out.Status = "handoff-history"
		out.ReadPolicy = "read only the latest relevant handoff when needed"
		out.Confidence = "medium"
		out.Reason = "Path is under 06_SESSIONS_AND_HANDOFFS, which documentation governance treats as History."
	case strings.Contains(path, "/03_design/04_deliverables/") || strings.HasPrefix(path, "docs/drive/shelter/03_design/04_deliverables/"):
		out.Layer = knowledgeLayerHistory
		out.Status = "evidence"
		out.ReadPolicy = "read only for proof, review, regression, or archaeology"
		out.Confidence = "medium"
		out.Reason = "Path is under 03_DESIGN/04_DELIVERABLES, which is evidence/history by default."
	case strings.Contains(path, "/04_development/") && strings.Contains(path, "codex_brief"):
		out.Layer = knowledgeLayerHistory
		out.Status = "completed-brief-history-candidate"
		out.ReadPolicy = "read only when this is the active assigned brief or when investigating implementation history"
		out.Confidence = "medium"
		out.Reason = "Codex briefs under 04_DEVELOPMENT become historical by default after completion."
	}
	return out
}

func explainSupersededPath(rawPath string) SupersededExplanation {
	path := normalizeKnowledgePath(rawPath)
	out := SupersededExplanation{
		Path:           path,
		OK:             true,
		Classification: "unknown",
		ReadPolicy:     "inspect SUPERSEDED_MAP.md before treating this path as current",
		CurrentSource:  docSupersededMap,
		Reason:         "No static superseded/history rule matched this path.",
	}
	lower := strings.ToLower(path)
	switch {
	case knowledgePathMatches(lower, docSupersededMap):
		out.Classification = "current/knowledge"
		out.ReadPolicy = "read before archaeology or PM cleanup"
		out.CurrentSource = docSupersededMap
		out.Reason = "SUPERSEDED_MAP.md is the active compression map, not a superseded document."
	case strings.Contains(lower, "steam_first_day_mvp_visible_review_v1"):
		out.Classification = "evidence/superseded-by-v3"
		out.ReadPolicy = "do_not_read_on_bootstrap"
		out.CurrentSource = "docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v3/README.md"
		out.Reason = "First Day visible review v1 is superseded by v3 for normal context recovery."
	case strings.Contains(lower, "steam_first_day_mvp_visible_review_v2"):
		out.Classification = "evidence/superseded-by-v3"
		out.ReadPolicy = "do_not_read_on_bootstrap"
		out.CurrentSource = "docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v3/README.md"
		out.Reason = "First Day visible review v2 is superseded by v3 for normal context recovery."
	case strings.Contains(lower, "steam_vertical_slice_art_qa_capture_v1"):
		out.Classification = "evidence/historical"
		out.ReadPolicy = "do_not_read_on_bootstrap"
		out.CurrentSource = "docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v3/README.md"
		out.Reason = "Old Vertical Slice Art QA capture v1 is historical evidence; First Day v3 is the current visual proof entry point."
	case strings.Contains(lower, "steam_vertical_slice_art_qa_capture_v2"):
		out.Classification = "evidence/historical"
		out.ReadPolicy = "do_not_read_on_bootstrap"
		out.CurrentSource = "docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/STEAM_FIRST_DAY_MVP_VISIBLE_REVIEW_v3/README.md"
		out.Reason = "Old Vertical Slice Art QA capture v2 is historical evidence; First Day v3 is the current visual proof entry point."
	case strings.Contains(lower, "systems_simulator_v0"):
		out.Classification = "superseded"
		out.ReadPolicy = "do_not_read_on_bootstrap"
		out.CurrentSource = "D-018/D-019, Godot State Connector, and Workbench-over-live-Godot direction"
		out.Reason = "The standalone Systems Simulator direction was superseded by Godot State Connector / Workbench over live Godot."
	case strings.Contains(lower, "99_archive"):
		out.Classification = "archive/history"
		out.ReadPolicy = "do_not_read_on_bootstrap"
		out.CurrentSource = docBootstrapContext
		out.Reason = "Paths under 99_ARCHIVE are archive/history by documentation governance."
	case strings.HasSuffix(lower, "docs/repo/status/codex_status.md") || lower == "codex_status.md":
		out.Classification = "history"
		out.ReadPolicy = "read latest entry only by default; use full log only for implementation archaeology"
		out.CurrentSource = docCodexCurrentStatus + " and " + docCodexImplementation
		out.Reason = "CODEX_STATUS.md is a detailed chronological log, not a bootstrap document."
	case strings.Contains(lower, "superseded"):
		out.Classification = "superseded"
		out.ReadPolicy = "do_not_read_on_bootstrap"
		out.CurrentSource = docSupersededMap
		out.Reason = "Path contains SUPERSEDED and should be treated as historical unless SUPERSEDED_MAP says otherwise."
	case strings.Contains(lower, "/04_development/") && strings.Contains(lower, "codex_brief"):
		out.Classification = "completed-brief-history-candidate"
		out.ReadPolicy = "read only when this is the active assigned brief or when investigating implementation history"
		out.CurrentSource = docCodexImplementation + " and latest " + docCodexStatus + " entry"
		out.Reason = "Completed Codex briefs under 04_DEVELOPMENT are historical by default after implementation."
		out.Notes = []string{"This rule is intentionally conservative; an active assigned brief is still task context."}
	}
	return out
}

func statusForSupersededClassification(classification string) string {
	switch {
	case strings.Contains(classification, "superseded"):
		return "superseded"
	case strings.Contains(classification, "archive"):
		return "archive"
	case strings.Contains(classification, "handoff"):
		return "handoff-history"
	case strings.Contains(classification, "evidence"):
		return "evidence"
	case strings.Contains(classification, "history"):
		return "history"
	default:
		return classification
	}
}

func normalizeKnowledgePath(path string) string {
	path = strings.TrimSpace(path)
	path = filepath.ToSlash(path)
	path = strings.TrimPrefix(path, "./")
	lower := strings.ToLower(path)
	for _, marker := range []string{
		"docs/drive/shelter/",
		"docs/repo/",
		"steam/",
		"project_rules.md",
		"agents.md",
		"readme.md",
	} {
		if idx := strings.Index(lower, marker); idx >= 0 {
			return strings.ToLower(path[idx:])
		}
	}
	return strings.ToLower(path)
}

func knowledgePathMatches(path, catalogPath string) bool {
	catalog := strings.ToLower(filepath.ToSlash(catalogPath))
	if strings.HasSuffix(catalog, "/**") {
		prefix := strings.TrimSuffix(catalog, "**")
		return strings.HasPrefix(path, prefix)
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

func collectKnowledgeGCCandidates(root, area string, maxEntries int) ([]KnowledgePathFinding, []SupersededExplanation, []string) {
	var history []KnowledgePathFinding
	var superseded []SupersededExplanation
	var notes []string
	seenHistory := map[string]bool{}
	seenSuperseded := map[string]bool{}
	roots := []string{
		"docs/drive/Shelter/06_SESSIONS_AND_HANDOFFS",
		"docs/drive/Shelter/03_DESIGN/04_DELIVERABLES",
		"docs/drive/Shelter/99_ARCHIVE",
		"docs/drive/Shelter/04_DEVELOPMENT",
		"docs/repo/status",
	}
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
			rel, err := filepath.Rel(root, path)
			if err != nil {
				return nil
			}
			rel = filepath.ToSlash(rel)
			if !gcPathMatchesArea(rel, area) {
				return nil
			}
			classification := classifyKnowledgePath(rel)
			if classification.Layer == knowledgeLayerHistory && !seenHistory[classification.Path] && len(history) < maxEntries {
				seenHistory[classification.Path] = true
				history = append(history, KnowledgePathFinding{
					Path:       rel,
					Layer:      classification.Layer,
					Status:     classification.Status,
					ReadPolicy: classification.ReadPolicy,
					Reason:     classification.Reason,
				})
			}
			explanation := explainSupersededPath(rel)
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
		return strings.Contains(lower, "steam") ||
			strings.Contains(lower, "03_design/04_deliverables") ||
			strings.Contains(lower, "04_development/steam_desktop")
	case "mcp":
		return strings.Contains(lower, "shelter_mcp") ||
			strings.Contains(lower, "codex_status.md") ||
			strings.Contains(lower, "codex_current_status.md")
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
	case "mcp":
		return []string{"Optional future: docs/drive/Shelter/04_DEVELOPMENT/SHELTER_MCP__CURRENT_CONTEXT.md if MCP work outgrows CODEX__CURRENT_IMPLEMENTATION_CONTEXT.md"}
	default:
		return nil
	}
}
