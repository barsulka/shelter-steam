package sheltermcp

import (
	"crypto/sha256"
	"encoding/hex"
	"fmt"
	"os"
	"path/filepath"
	"regexp"
	"sort"
	"strings"
)

const (
	docProjectRules       = "PROJECTS_RULES.md"
	docAgents             = "AGENTS.md"
	docRepoReadme         = "README.md"
	docRoleProducer       = "docs/drive/Shelter/00_START_HERE/000_ROLE_PRODUCER.md"
	docRoleProjectManager = "docs/drive/Shelter/00_START_HERE/000_ROLE_PROJECT_MANAGER.md"
	docRoleGameDesigner   = "docs/drive/Shelter/00_START_HERE/000_ROLE_GAME_DESIGNER.md"
	docRoleArtDirector    = "docs/drive/Shelter/00_START_HERE/000_ROLE_ART_DIRECTOR.md"
	docRoleCodex          = "docs/drive/Shelter/00_START_HERE/000_ROLE_CODEX.md"
)

var (
	sourceDecisionHeadingRE     = regexp.MustCompile(`(?m)^### (D-[0-9]{3}) — (.+)$`)
	sourceDecisionIndexRowRE    = regexp.MustCompile(`(?m)^\| (D-[0-9]{3}) \|`)
	sourceOpenQuestionHeadingRE = regexp.MustCompile(`(?m)^#### (OQ-[A-Za-z]+-[0-9]{3}) — (.+)$`)
	sourceMarkdownHeadingRE     = regexp.MustCompile(`^(#{1,6})\s+(.+?)\s*$`)
)

type KnowledgeSource struct {
	Path       string `json:"path"`
	FileSHA256 string `json:"file_sha256"`
	Bytes      int    `json:"bytes"`
	data       []byte
}

type KnowledgeBlockHash struct {
	Key    string `json:"key"`
	Path   string `json:"path"`
	SHA256 string `json:"sha256"`
}

type KnowledgeSourceSection struct {
	Path    string
	Heading string
	Level   int
	Text    string
	SHA256  string
}

type KnowledgeSourceSnapshot struct {
	Sources             []KnowledgeSource
	Documents           []KnowledgeDoc
	Decisions           []KnowledgeDecision
	ActiveOpenQuestions []OpenQuestion
	Roadmaps            []KnowledgeRoadmap
	Handoffs            []KnowledgeHandoff
	BlockHashes         []KnowledgeBlockHash
	sections            map[string][]KnowledgeSourceSection
	sourceByPath        map[string]KnowledgeSource
	blockByKey          map[string]KnowledgeBlockHash
}

type knowledgeSnapshotOptions struct {
	AfterFirstRead func(path string)
}

type knowledgeDocumentRoute struct {
	Path  string
	Areas []string
}

type knowledgeRoadmapRoute struct {
	ID    string
	Path  string
	Areas []string
}

var knowledgeDocumentRoutes = []knowledgeDocumentRoute{
	{Path: docBootstrapContext, Areas: []string{"all"}},
	{Path: docCurrentStatus, Areas: []string{"all"}},
	{Path: docSteamCurrent, Areas: []string{"steam"}},
	{Path: docGameDesignCurrent, Areas: []string{"steam"}},
	{Path: docArtDirectionCurrent, Areas: []string{"steam"}},
	{Path: docCodexCurrentStatus, Areas: []string{"mcp", "docs", "generic"}},
	{Path: docCodexImplementation, Areas: []string{"mcp", "docs"}},
	{Path: docDecisions, Areas: []string{"all"}},
	{Path: docPhilosophy, Areas: []string{"all"}},
	{Path: docOpenQuestions, Areas: []string{"all"}},
	{Path: docStressTests, Areas: []string{"steam", "docs", "generic"}},
	{Path: docGovernance, Areas: []string{"docs", "mcp", "generic"}},
	{Path: docEvidenceReadPolicy, Areas: []string{"docs", "steam", "mcp", "generic"}},
	{Path: docSupersededMap, Areas: []string{"docs", "mcp", "generic"}},
	{Path: docKnowledgeBaseRoadmap, Areas: []string{"docs", "mcp", "generic"}},
	{Path: docKnowledgeBasePolishRoadmap, Areas: []string{"docs", "mcp", "generic"}},
	{Path: docADRIndex, Areas: []string{"steam", "mcp"}},
}

var knowledgeRoadmapRoutes = []knowledgeRoadmapRoute{
	{ID: "knowledge_base_roadmap", Path: docKnowledgeBaseRoadmap, Areas: []string{"docs", "mcp"}},
	{ID: "knowledge_base_polish_roadmap", Path: docKnowledgeBasePolishRoadmap, Areas: []string{"docs", "mcp"}},
	{ID: "steam_game_design_roadmap_v2", Path: docSteamGameRoadmapV2, Areas: []string{"steam", "game_design"}},
}

func requiredKnowledgeSourcePaths() []string {
	paths := []string{
		docProjectRules, docAgents, docRepoReadme,
		docRoleProducer, docRoleProjectManager, docRoleGameDesigner, docRoleArtDirector, docRoleCodex,
		docHandoffIndex, docSteamGameRoadmapV2,
	}
	for _, route := range knowledgeDocumentRoutes {
		paths = append(paths, route.Path)
	}
	sort.Strings(paths)
	return uniqueSortedStrings(paths)
}

func loadKnowledgeSourceSnapshot(root string, options knowledgeSnapshotOptions) (KnowledgeSourceSnapshot, error) {
	root = filepath.Clean(root)
	snapshot := KnowledgeSourceSnapshot{
		sections:     map[string][]KnowledgeSourceSection{},
		sourceByPath: map[string]KnowledgeSource{},
		blockByKey:   map[string]KnowledgeBlockHash{},
	}
	for _, path := range requiredKnowledgeSourcePaths() {
		source, err := readStableKnowledgeSource(root, path, options)
		if err != nil {
			return KnowledgeSourceSnapshot{}, err
		}
		snapshot.Sources = append(snapshot.Sources, source)
		snapshot.sourceByPath[path] = source
		snapshot.sections[path] = parseKnowledgeSections(path, string(source.data))
	}

	var err error
	snapshot.Decisions, err = parseKnowledgeDecisions(string(snapshot.sourceByPath[docDecisions].data))
	if err != nil {
		return KnowledgeSourceSnapshot{}, fmt.Errorf("knowledge_error decisions: %w", err)
	}
	snapshot.ActiveOpenQuestions, err = parseActiveOpenQuestions(string(snapshot.sourceByPath[docOpenQuestions].data))
	if err != nil {
		return KnowledgeSourceSnapshot{}, fmt.Errorf("knowledge_error open_questions: %w", err)
	}
	snapshot.Roadmaps, err = parseKnowledgeRoadmaps(snapshot)
	if err != nil {
		return KnowledgeSourceSnapshot{}, fmt.Errorf("knowledge_error roadmaps: %w", err)
	}
	snapshot.Handoffs, err = parseHandoffIndex(root, string(snapshot.sourceByPath[docHandoffIndex].data))
	if err != nil {
		return KnowledgeSourceSnapshot{}, fmt.Errorf("knowledge_error handoff_index: %w", err)
	}
	snapshot.Documents, err = parseKnowledgeDocuments(snapshot)
	if err != nil {
		return KnowledgeSourceSnapshot{}, fmt.Errorf("knowledge_error document_metadata: %w", err)
	}
	for _, document := range snapshot.Documents {
		if source, ok := snapshot.sourceByPath[document.Path]; ok {
			snapshot.addBlockHash("document_metadata:"+document.Path, document.Path, sourceHeaderBlock(string(source.data)))
		}
	}

	for _, decision := range snapshot.Decisions {
		block := exactHeadingBlock(string(snapshot.sourceByPath[docDecisions].data), "### "+decision.ID+" — ")
		snapshot.addBlockHash("decision:"+decision.ID, docDecisions, block)
	}
	for _, question := range snapshot.ActiveOpenQuestions {
		block := exactHeadingBlock(string(snapshot.sourceByPath[docOpenQuestions].data), "#### "+question.ID+" — ")
		snapshot.addBlockHash("open_question:"+question.ID, docOpenQuestions, block)
	}
	for _, roadmap := range snapshot.Roadmaps {
		block := roadmapAuthorityBlock(snapshot, roadmap.Path)
		snapshot.addBlockHash("roadmap:"+roadmap.ID, roadmap.Path, block)
	}
	if section, ok := snapshot.findSection(docHandoffIndex, "## 1. Latest relevant handoff by role / area"); ok {
		snapshot.addBlockHash("handoff_index:latest", docHandoffIndex, section.Text)
	}
	if section, ok := snapshot.findSection(docSupersededMap, "## 2. Superseded / do not read by default"); ok {
		snapshot.addBlockHash("superseded_map:entries", docSupersededMap, section.Text)
	}

	sort.Slice(snapshot.BlockHashes, func(i, j int) bool { return snapshot.BlockHashes[i].Key < snapshot.BlockHashes[j].Key })
	return snapshot, nil
}

func readStableKnowledgeSource(root, path string, options knowledgeSnapshotOptions) (KnowledgeSource, error) {
	abs := filepath.Join(root, filepath.FromSlash(path))
	if !pathWithin(abs, root) {
		return KnowledgeSource{}, fmt.Errorf("missing_required_source %s: path escapes repository root", path)
	}
	first, err := os.ReadFile(abs)
	if err != nil {
		return KnowledgeSource{}, fmt.Errorf("missing_required_source %s: %w", path, err)
	}
	if options.AfterFirstRead != nil {
		options.AfterFirstRead(path)
	}
	second, err := os.ReadFile(abs)
	if err != nil {
		return KnowledgeSource{}, fmt.Errorf("source_changed_during_read %s: %w", path, err)
	}
	if string(first) != string(second) {
		return KnowledgeSource{}, fmt.Errorf("source_changed_during_read %s", path)
	}
	return KnowledgeSource{Path: path, FileSHA256: knowledgeSHA256(first), Bytes: len(first), data: first}, nil
}

func parseKnowledgeDecisions(text string) ([]KnowledgeDecision, error) {
	if !strings.Contains(text, "## 1. Decision index") || !strings.Contains(text, "## 2. Accepted decisions") {
		return nil, fmt.Errorf("malformed decision document: required sections are missing")
	}
	if duplicate := firstDuplicateMatch(text, sourceDecisionIndexRowRE); duplicate != "" {
		return nil, fmt.Errorf("duplicate decision id %s in index", duplicate)
	}
	matches := sourceDecisionHeadingRE.FindAllStringSubmatchIndex(text, -1)
	if len(matches) == 0 {
		return nil, fmt.Errorf("malformed decision document: no decision blocks")
	}
	seen := map[string]bool{}
	decisions := make([]KnowledgeDecision, 0, len(matches))
	for index, match := range matches {
		id := text[match[2]:match[3]]
		if seen[id] {
			return nil, fmt.Errorf("duplicate decision id %s", id)
		}
		seen[id] = true
		end := len(text)
		if index+1 < len(matches) {
			end = matches[index+1][0]
		} else if marker := strings.Index(text[match[0]:], "\n## 3."); marker >= 0 {
			end = match[0] + marker
		}
		block := text[match[0]:end]
		title := strings.TrimSpace(text[match[4]:match[5]])
		kindRaw := sourceField(block, "Kind")
		areaRaw := sourceField(block, "Area")
		status := strings.ToLower(sourceField(block, "Status"))
		summary := sourceSummary(block)
		if title == "" || kindRaw == "" || areaRaw == "" || status == "" || summary == "" {
			return nil, fmt.Errorf("malformed decision block %s: title/kind/area/status/summary are required", id)
		}
		kind, err := sourceDecisionKind(kindRaw)
		if err != nil {
			return nil, fmt.Errorf("malformed decision block %s: %w", id, err)
		}
		decisions = append(decisions, KnowledgeDecision{
			ID: id, Title: title, Kind: kind, Status: status,
			Summary: summary, SourcePath: docDecisions, Areas: sourceAreas(areaRaw),
		})
	}
	sort.Slice(decisions, func(i, j int) bool { return decisions[i].ID < decisions[j].ID })
	return decisions, nil
}

func parseActiveOpenQuestions(text string) ([]OpenQuestion, error) {
	if duplicate := firstDuplicateMatch(text, sourceOpenQuestionHeadingRE); duplicate != "" {
		return nil, fmt.Errorf("duplicate open question id %s", duplicate)
	}
	start := strings.Index(text, "## 1. Active open questions")
	end := strings.Index(text, "## 2. Partially resolved questions")
	if start < 0 || end <= start {
		return nil, fmt.Errorf("malformed open question document: active section is missing")
	}
	active := text[start:end]
	matches := sourceOpenQuestionHeadingRE.FindAllStringSubmatchIndex(active, -1)
	questions := make([]OpenQuestion, 0, len(matches))
	seen := map[string]bool{}
	for index, match := range matches {
		id := active[match[2]:match[3]]
		if seen[id] {
			return nil, fmt.Errorf("duplicate active open question id %s", id)
		}
		seen[id] = true
		blockEnd := len(active)
		if index+1 < len(matches) {
			blockEnd = matches[index+1][0]
		}
		block := active[match[0]:blockEnd]
		title := strings.TrimSpace(active[match[4]:match[5]])
		status := strings.ToLower(sourceField(block, "Статус"))
		owner := sourceField(block, "Владелец")
		if title == "" || status == "" || owner == "" {
			return nil, fmt.Errorf("malformed open question block %s: title/status/owner are required", id)
		}
		if status == "resolved" || strings.HasPrefix(status, "resolved ") {
			continue
		}
		questions = append(questions, OpenQuestion{
			ID: id, Title: title, Area: sourceOpenQuestionArea(id), Status: status,
			Owner: owner, Summary: sourceFirstExcerpt(block), SourcePath: docOpenQuestions,
			Sources: sourceBacktickPaths(block),
		})
	}
	sort.Slice(questions, func(i, j int) bool { return questions[i].ID < questions[j].ID })
	return questions, nil
}

func parseKnowledgeRoadmaps(snapshot KnowledgeSourceSnapshot) ([]KnowledgeRoadmap, error) {
	roadmaps := make([]KnowledgeRoadmap, 0, len(knowledgeRoadmapRoutes))
	for _, route := range knowledgeRoadmapRoutes {
		source := snapshot.sourceByPath[route.Path]
		text := string(source.data)
		metadata := sourceHeaderMetadata(text)
		title := sourceTitle(text)
		status := metadata["status"]
		owner := metadata["owner"]
		var currentPhase, nextStep string
		if route.Path == docSteamGameRoadmapV2 {
			currentPhase = sourceFencedValueAfter(text, "Current product status:")
			nextStep = sourceFencedValueAfter(text, "Current active task:")
		} else {
			status = sourceLineValue(text, "Catalog status:")
			currentPhase = sourceLineValue(text, "Catalog current phase:")
			nextStep = sourceLineValue(text, "Catalog next step:")
		}
		if title == "" || status == "" || owner == "" || currentPhase == "" || nextStep == "" {
			return nil, fmt.Errorf("malformed roadmap %s: title/status/owner/current phase/next step are required", route.Path)
		}
		roadmaps = append(roadmaps, KnowledgeRoadmap{
			ID: route.ID, Title: title, Path: route.Path, Areas: append([]string(nil), route.Areas...),
			Status: status, CurrentPhase: currentPhase, NextStep: nextStep, Owner: owner,
		})
	}
	sort.Slice(roadmaps, func(i, j int) bool { return roadmaps[i].ID < roadmaps[j].ID })
	return roadmaps, nil
}

func parseKnowledgeDocuments(snapshot KnowledgeSourceSnapshot) ([]KnowledgeDoc, error) {
	docs := make([]KnowledgeDoc, 0, len(knowledgeDocumentRoutes)+3)
	for _, route := range knowledgeDocumentRoutes {
		text := string(snapshot.sourceByPath[route.Path].data)
		document, err := parseKnowledgeDocumentMetadata(route, text)
		if err != nil {
			return nil, err
		}
		docs = append(docs, document)
	}
	docs = append(docs,
		KnowledgeDoc{Path: "docs/drive/Shelter/06_SESSIONS_AND_HANDOFFS/**", Areas: []string{"all"}, Status: "handoff-history", Layer: knowledgeLayerHistory, Purpose: "path convention from HANDOFF_INDEX", ReadPolicy: "read only latest relevant handoff when needed"},
		KnowledgeDoc{Path: "docs/drive/Shelter/03_DESIGN/04_DELIVERABLES/**", Areas: []string{"steam", "docs"}, Status: "evidence", Layer: knowledgeLayerHistory, Purpose: "evidence path convention", ReadPolicy: "read only for proof, review, regression, or archaeology"},
		KnowledgeDoc{Path: "docs/drive/Shelter/99_ARCHIVE/**", Areas: []string{"all"}, Status: "archive", Layer: knowledgeLayerHistory, Purpose: "archive path convention", ReadPolicy: "do not read on bootstrap"},
	)
	sort.Slice(docs, func(i, j int) bool { return docs[i].Path < docs[j].Path })
	return docs, nil
}

func parseKnowledgeDocumentMetadata(route knowledgeDocumentRoute, text string) (KnowledgeDoc, error) {
	metadata := sourceHeaderMetadata(text)
	status := metadata["status"]
	purpose := metadata["purpose"]
	readPolicy := metadata["read_policy"]
	if route.Path == docADRIndex {
		status = "active"
	}
	if purpose == "" {
		purpose = sourceDocumentPurpose(text)
	}
	if status == "" || purpose == "" {
		return KnowledgeDoc{}, fmt.Errorf("malformed metadata %s: status and purpose are required", route.Path)
	}
	layer := sourceLayerForStatus(status)
	if readPolicy == "" {
		readPolicy = sourceReadPolicy(layer)
	}
	return KnowledgeDoc{Path: route.Path, Areas: append([]string(nil), route.Areas...), Status: status, Layer: layer, Purpose: purpose, ReadPolicy: readPolicy}, nil
}

func parseHandoffIndex(root, text string) ([]KnowledgeHandoff, error) {
	sectionStart := strings.Index(text, "## 1. Latest relevant handoff by role / area")
	sectionEnd := strings.Index(text, "## 2. Do not read by default")
	if sectionStart < 0 || sectionEnd <= sectionStart {
		return nil, fmt.Errorf("malformed HANDOFF_INDEX: latest table is missing")
	}
	var handoffs []KnowledgeHandoff
	for _, line := range strings.Split(text[sectionStart:sectionEnd], "\n") {
		cells := markdownTableCells(line)
		if len(cells) != 3 || cells[0] == "Role / area" || strings.HasPrefix(cells[0], "---") {
			continue
		}
		path := strings.Trim(cells[1], "`")
		if path == "" || !strings.Contains(path, ".md") {
			return nil, fmt.Errorf("malformed HANDOFF_INDEX row: %s", line)
		}
		fullPath := "docs/drive/Shelter/06_SESSIONS_AND_HANDOFFS/" + path
		base := filepath.Base(path)
		date := ""
		if len(base) >= 10 {
			date = base[:10]
		}
		handoffs = append(handoffs, KnowledgeHandoff{
			Date: date, Title: cells[0], Path: fullPath,
			Roles: sourceHandoffRoles(cells[0]), Areas: sourceHandoffAreas(cells[0]),
			Summary: cells[2], SourceType: "handoff-index", Available: fileExists(root, fullPath),
			priority: 1000 - len(handoffs),
		})
	}
	if len(handoffs) == 0 {
		return nil, fmt.Errorf("malformed HANDOFF_INDEX: no handoff rows")
	}
	return handoffs, nil
}

func parseKnowledgeSections(path, text string) []KnowledgeSourceSection {
	lines := strings.Split(strings.ReplaceAll(text, "\r\n", "\n"), "\n")
	type heading struct {
		index, level int
		title        string
	}
	var headings []heading
	for index, line := range lines {
		match := sourceMarkdownHeadingRE.FindStringSubmatch(line)
		if match != nil {
			headings = append(headings, heading{index: index, level: len(match[1]), title: strings.TrimSpace(line)})
		}
	}
	sections := make([]KnowledgeSourceSection, 0, len(headings))
	for index, item := range headings {
		end := len(lines)
		for next := index + 1; next < len(headings); next++ {
			if headings[next].level <= item.level {
				end = headings[next].index
				break
			}
		}
		block := strings.TrimRight(strings.Join(lines[item.index:end], "\n"), "\n") + "\n"
		sections = append(sections, KnowledgeSourceSection{Path: path, Heading: item.title, Level: item.level, Text: block, SHA256: knowledgeSHA256([]byte(block))})
	}
	return sections
}

func (snapshot KnowledgeSourceSnapshot) findSection(path, heading string) (KnowledgeSourceSection, bool) {
	for _, section := range snapshot.sections[path] {
		if section.Heading == heading {
			return section, true
		}
	}
	return KnowledgeSourceSection{}, false
}

func (snapshot *KnowledgeSourceSnapshot) addBlockHash(key, path, text string) {
	if text == "" {
		return
	}
	block := KnowledgeBlockHash{Key: key, Path: path, SHA256: knowledgeSHA256([]byte(text))}
	snapshot.BlockHashes = append(snapshot.BlockHashes, block)
	snapshot.blockByKey[key] = block
}

func roadmapAuthorityBlock(snapshot KnowledgeSourceSnapshot, path string) string {
	heading := "## 0. Purpose"
	if path == docKnowledgeBasePolishRoadmap {
		heading = "## 0. Why this exists"
	} else if path == docSteamGameRoadmapV2 {
		heading = "## 0.1 Current navigation"
	}
	section, _ := snapshot.findSection(path, heading)
	return section.Text
}

func exactHeadingBlock(text, prefix string) string {
	start := strings.Index(text, prefix)
	if start < 0 {
		return ""
	}
	lineStart := strings.LastIndex(text[:start], "\n") + 1
	lineEnd := strings.Index(text[lineStart:], "\n")
	if lineEnd < 0 {
		lineEnd = len(text) - lineStart
	}
	headingMatch := sourceMarkdownHeadingRE.FindStringSubmatch(text[lineStart : lineStart+lineEnd])
	if headingMatch == nil {
		return ""
	}
	level := len(headingMatch[1])
	lines := strings.Split(text[lineStart:], "\n")
	end := len(lines)
	for index := 1; index < len(lines); index++ {
		match := sourceMarkdownHeadingRE.FindStringSubmatch(lines[index])
		if match != nil && len(match[1]) <= level {
			end = index
			break
		}
	}
	return strings.TrimRight(strings.Join(lines[:end], "\n"), "\n") + "\n"
}

func sourceField(block, key string) string {
	prefix := key + ":"
	for _, line := range strings.Split(block, "\n") {
		trimmed := strings.TrimSpace(line)
		if strings.HasPrefix(trimmed, prefix) {
			return sourceCleanValue(strings.TrimSpace(strings.TrimPrefix(trimmed, prefix)))
		}
	}
	return ""
}

func sourceHeaderMetadata(text string) map[string]string {
	metadata := map[string]string{}
	lines := strings.Split(strings.ReplaceAll(text, "\r\n", "\n"), "\n")
	for index, line := range lines {
		if index > 0 && (strings.TrimSpace(line) == "---" || strings.HasPrefix(line, "## ")) {
			break
		}
		parts := strings.SplitN(strings.TrimSpace(line), ":", 2)
		if len(parts) != 2 {
			continue
		}
		key := strings.ToLower(strings.TrimSpace(parts[0]))
		value := sourceCleanValue(strings.TrimSpace(parts[1]))
		switch key {
		case "статус", "status":
			metadata["status"] = value
		case "владелец", "роль-владелец", "owner":
			metadata["owner"] = value
		case "назначение", "purpose":
			metadata["purpose"] = value
		case "read policy":
			metadata["read_policy"] = value
		}
	}
	return metadata
}

func sourceHeaderBlock(text string) string {
	lines := strings.Split(strings.ReplaceAll(text, "\r\n", "\n"), "\n")
	end := len(lines)
	for index, line := range lines {
		if index > 0 && (strings.TrimSpace(line) == "---" || strings.HasPrefix(line, "## ")) {
			end = index
			break
		}
	}
	return strings.TrimRight(strings.Join(lines[:end], "\n"), "\n") + "\n"
}

func sourceSummary(block string) string {
	lines := strings.Split(block, "\n")
	for index, line := range lines {
		if strings.TrimSpace(line) != "Summary:" {
			continue
		}
		var values []string
		for _, candidate := range lines[index+1:] {
			trimmed := strings.TrimSpace(candidate)
			if trimmed == "" && len(values) == 0 {
				continue
			}
			if trimmed == "" {
				break
			}
			if strings.HasPrefix(trimmed, ">") {
				values = append(values, strings.TrimSpace(strings.TrimPrefix(trimmed, ">")))
			}
		}
		return strings.Join(values, "\n")
	}
	return ""
}

func sourceFirstExcerpt(block string) string {
	for _, line := range strings.Split(block, "\n") {
		trimmed := strings.TrimSpace(line)
		if trimmed == "" || strings.HasPrefix(trimmed, "#") || strings.HasPrefix(trimmed, "Статус:") || strings.HasPrefix(trimmed, "Владелец:") || trimmed == "```text" || trimmed == "```" || strings.HasSuffix(trimmed, ":") {
			continue
		}
		trimmed = strings.TrimSpace(strings.TrimLeft(trimmed, "->*0123456789. "))
		if trimmed != "" {
			return trimmed
		}
	}
	return ""
}

func sourceDocumentPurpose(text string) string {
	lines := strings.Split(strings.ReplaceAll(text, "\r\n", "\n"), "\n")
	metadataEnded := false
	for _, line := range lines {
		trimmed := strings.TrimSpace(line)
		if trimmed == "---" {
			metadataEnded = true
			continue
		}
		if !metadataEnded && strings.HasPrefix(trimmed, "## ") {
			metadataEnded = true
		}
		if !metadataEnded || trimmed == "" || strings.HasPrefix(trimmed, "#") || strings.HasPrefix(trimmed, "|") || strings.HasPrefix(trimmed, "`") {
			continue
		}
		return sourceCleanValue(trimmed)
	}
	return sourceTitle(text)
}

func sourceTitle(text string) string {
	for _, line := range strings.Split(text, "\n") {
		if strings.HasPrefix(line, "# ") {
			return strings.TrimSpace(strings.TrimPrefix(line, "# "))
		}
	}
	return ""
}

func sourceCleanValue(value string) string {
	return strings.Trim(strings.TrimSpace(strings.TrimSuffix(value, "  ")), "`")
}

func sourceLineValue(text, prefix string) string {
	for _, line := range strings.Split(text, "\n") {
		if strings.HasPrefix(strings.TrimSpace(line), prefix) {
			return sourceCleanValue(strings.TrimSpace(strings.TrimPrefix(strings.TrimSpace(line), prefix)))
		}
	}
	return ""
}

func sourceFencedValueAfter(text, marker string) string {
	index := strings.Index(text, marker)
	if index < 0 {
		return ""
	}
	rest := text[index+len(marker):]
	open := strings.Index(rest, "```text")
	if open < 0 {
		return ""
	}
	rest = rest[open+len("```text"):]
	close := strings.Index(rest, "```")
	if close < 0 {
		return ""
	}
	return strings.TrimSpace(rest[:close])
}

func sourceDecisionKind(raw string) (string, error) {
	value := strings.ToLower(raw)
	for _, kind := range []string{"ethics", "technical", "process", "product", "documentation"} {
		if strings.Contains(value, kind) {
			return kind, nil
		}
	}
	if strings.Contains(value, "dev tooling") {
		return "technical", nil
	}
	for _, productKind := range []string{"game design", "art", "world", "philosophy"} {
		if strings.Contains(value, productKind) {
			return "product", nil
		}
	}
	return "", fmt.Errorf("unsupported decision kind %q; expected a canonical mapping to product, technical, process, documentation, or ethics", raw)
}

func sourceAreas(raw string) []string {
	value := strings.ToLower(raw)
	var areas []string
	for _, pair := range []struct{ needle, area string }{
		{"steam", "steam"}, {"browser", "browser"}, {"mobile", "mobile"}, {"shared", "shared"},
		{"docs", "docs"}, {"codex", "docs"}, {"mcp", "mcp"}, {"all", "all"},
	} {
		if strings.Contains(value, pair.needle) {
			areas = append(areas, pair.area)
		}
	}
	if len(areas) == 0 {
		areas = append(areas, "generic")
	}
	return uniqueSortedStrings(areas)
}

func sourceOpenQuestionArea(id string) string {
	parts := strings.Split(id, "-")
	if len(parts) < 3 {
		return "generic"
	}
	return strings.ToLower(parts[1])
}

func sourceBacktickPaths(block string) []string {
	var paths []string
	for _, part := range strings.Split(block, "`") {
		candidate := strings.TrimSpace(part)
		lower := strings.ToLower(candidate)
		if !strings.Contains(candidate, "\n") && (strings.HasPrefix(lower, "docs/") || strings.HasSuffix(lower, ".md")) {
			paths = append(paths, candidate)
		}
	}
	return uniqueSortedStrings(paths)
}

func sourceLayerForStatus(status string) string {
	value := strings.ToLower(status)
	if strings.Contains(value, "current-summary") || strings.Contains(value, "current status") {
		return knowledgeLayerCurrent
	}
	for _, history := range []string{"history", "evidence", "handoff", "superseded", "archive"} {
		if strings.Contains(value, history) {
			return knowledgeLayerHistory
		}
	}
	return knowledgeLayerActive
}

func sourceReadPolicy(layer string) string {
	switch layer {
	case knowledgeLayerCurrent:
		return "bootstrap/current entry"
	case knowledgeLayerHistory:
		return "history only for evidence, regression, or archaeology"
	default:
		return "read by task"
	}
}

func sourceHandoffRoles(text string) []string {
	value := strings.ToLower(text)
	var roles []string
	for _, pair := range []struct{ needle, role string }{
		{"producer", "producer"}, {"pm", "project_manager"}, {"project manager", "project_manager"},
		{"codex", "codex"}, {"game design", "game_designer"}, {"art direction", "art_director"},
	} {
		if strings.Contains(value, pair.needle) {
			roles = append(roles, pair.role)
		}
	}
	if len(roles) == 0 {
		roles = append(roles, "generic")
	}
	return uniqueSortedStrings(roles)
}

func sourceHandoffAreas(text string) []string {
	value := strings.ToLower(text)
	var areas []string
	for _, pair := range []struct{ needle, area string }{
		{"steam", "steam"}, {"mcp", "mcp"}, {"documentation", "docs"}, {"docs", "docs"}, {"knowledge", "docs"},
	} {
		if strings.Contains(value, pair.needle) {
			areas = append(areas, pair.area)
		}
	}
	if len(areas) == 0 {
		areas = append(areas, "generic")
	}
	return uniqueSortedStrings(areas)
}

func markdownTableCells(line string) []string {
	trimmed := strings.TrimSpace(line)
	if !strings.HasPrefix(trimmed, "|") || !strings.HasSuffix(trimmed, "|") {
		return nil
	}
	parts := strings.Split(strings.Trim(trimmed, "|"), "|")
	for index := range parts {
		parts[index] = strings.TrimSpace(parts[index])
	}
	return parts
}

func firstDuplicateMatch(text string, expression *regexp.Regexp) string {
	seen := map[string]bool{}
	for _, match := range expression.FindAllStringSubmatch(text, -1) {
		if seen[match[1]] {
			return match[1]
		}
		seen[match[1]] = true
	}
	return ""
}

func uniqueSortedStrings(values []string) []string {
	seen := map[string]bool{}
	var unique []string
	for _, value := range values {
		if value != "" && !seen[value] {
			seen[value] = true
			unique = append(unique, value)
		}
	}
	sort.Strings(unique)
	return unique
}

func knowledgeSHA256(data []byte) string {
	sum := sha256.Sum256(data)
	return hex.EncodeToString(sum[:])
}
