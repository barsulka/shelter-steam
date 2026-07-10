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

var (
	decisionHeadingRE     = regexp.MustCompile(`(?m)^### (D-[0-9]{3}) — .*$`)
	decisionStatusRE      = regexp.MustCompile("(?ms)^### (D-[0-9]{3}) — .*?^Status: `([^`]+)`")
	openQuestionHeadingRE = regexp.MustCompile(`(?m)^#{3,4} (OQ-[A-Za-z0-9-]+) — .*$`)
	openQuestionBlockRE   = regexp.MustCompile("(?ms)^#{3,4} (OQ-[A-Za-z0-9-]+) — .*?^Статус: `([^`]+)`")
)

// These fingerprints deliberately lock both authoritative source blocks and
// every catalog field returned by knowledge tools. Updating either side alone
// is drift; an intentional source+catalog update must refresh the lock here.
var expectedDecisionSourceDigests = map[string]string{
	"D-001": "3b5c165dd4816fe449a2956bf9432a0781b18ea322eb25b7488e28bd2186159e",
	"D-002": "b172c2799c477a2ea10d63cb752fa0da08bc3ad9e1ddebfb96f73e7318d201f1",
	"D-003": "a856e8a52c9a3c941a8da1bc0ac5f7a3fb7c481cbe1c5ca5b71f63a00a164816",
	"D-004": "e505545a1d3d512e554311b9927f8844fac7888f0bcc3adbf34b51ef72b365ff",
	"D-005": "8241882f73bd1508e01ed68e58ee414c46a04dba82b6033b1cefcf42643b92ec",
	"D-006": "3e173a596ab190ec76cfd6362ba39ca25725d0b724ccc81427a2b5109037224b",
	"D-007": "4a1fc35128005689e7e07c6526fc4430c6b5e015ddc3223379275753631d2e1c",
	"D-008": "093fcf09d5db2675af537cd0b2f9c8e28875d62b3ad389aa4e518d1831bf2ef5",
	"D-009": "9b5e9e5aeef3bbebf6563807cf8fea53c46ca09956ab970222d89deb33f67f76",
	"D-010": "c9dfdb7110eb83f4c69144d4787fab2e1ce5ced661a21fbf52d5c51411002a86",
	"D-011": "55c9538bb785cf391a18b1758d2456135bbf4dd3df3261dcda2aa3839ed90844",
	"D-012": "fba24b0007ba8c86668b55b55b13047934f821bf8f69834c0335e3ce14842555",
	"D-013": "3cfd0f89c99d409e031f34542dbb19aeb214eb246d747b7e5ae7211d124a84cb",
	"D-014": "960043445d239719bb6221f95a3165df57fe4e0f675ee9b6afa26e155c441483",
	"D-015": "5cb1e0eea9cdb6fc07f37a6a0771454fd8ae8a34175cae8b5d85f89350b2bf6c",
	"D-016": "702ac6a4e39f0accea9aed0be4cd7d814266f6b9d66eebd40cfbb3b165d89cd3",
	"D-017": "e402ab70ec4756044cc537a3a9838ccc6615a24792603a8e9d327c067680fa58",
	"D-018": "c914212cfcbd27127b6750879276cf882dcbb73f6e70a3dfdbf4fab92c732c62",
	"D-019": "dbaf8f17063f51fff13661bf698ce67b439a98692aa60fb3f62216ac1c1b8f0e",
	"D-020": "af23de78a68d161050b53c6f91279d39e2a28eb891261d0e35e7f8a6285d9c9d",
	"D-021": "36805263f7e9a494cfacc798004a25c087832def9dd7d15479d6c021dc88ca95",
}

var expectedOpenQuestionSourceDigests = map[string]string{
	"OQ-Steam-001":    "2a77ab4ddcd523c71f9768e1258aa91b925195a5134d2b99c87f9d0e5c98c363",
	"OQ-Steam-002":    "839761adab2767a09082975db6ab99e4653f9c4ed4b0a00b7efa1ed54a9d6a61",
	"OQ-Steam-003":    "b559760b812bf21df2837ecd35876ee021157975eef7e470f9857aaec08d9e7c",
	"OQ-Docs-001":     "6432d69c0e26cc221a8c71571785b5696b101ca179e16dd7b767631014c40e10",
	"OQ-Docs-003":     "361de4c61dc1428e02af4f544e3a1abe4e375c30d6882d18d399886efd183573",
	"OQ-Browser-001":  "bffad1cab1327ef6cc45e397dbf3a52ca9aa4ad97fa2f33ef0277eac007210eb",
	"OQ-Mobile-001":   "00b8172096cd7abe1f2716c174c93073669adb697afe1aa856d026ce3ce792d1",
	"OQ-Shared-001":   "faffb38df0e51ef516ef5f251c6880dcd65e17410fcc9f46907e06c4b1bbb103",
	"OQ-Charity-001":  "d23107be046cf7c8880129fe7d39bed3d07ca970d5b1651b8e24d59447703391",
	"OQ-Platform-001": "b937300fddb6b09b68944b4c41555a0eded8b187ad3ca6bcf01654d41bf3e6ca",
}

const (
	expectedDecisionCatalogDigest     = "2d33b02a6a5bb7d550752c54c3df34a8076090ec13dff291368847a69a04f0cc"
	expectedOpenQuestionCatalogDigest = "65b35610b2a987557a4185c30e04690b2fdd57e5d4c7aa14a0498a7d0227532f"
)

// validateKnowledgeCatalog keeps compact MCP output subordinate to the source
// Markdown. Startup and tests fail loudly when catalog IDs/statuses/current
// paths drift; callers must update the source docs first, then the mapping.
func validateKnowledgeCatalog(root string) error {
	var problems []string

	decisionsText, err := readKnowledgeSource(root, docDecisions)
	if err != nil {
		problems = append(problems, err.Error())
	} else {
		sourceStatuses := map[string]string{}
		for _, match := range decisionStatusRE.FindAllStringSubmatch(decisionsText, -1) {
			sourceStatuses[match[1]] = strings.TrimSpace(match[2])
		}
		if len(sourceStatuses) != len(decisionHeadingRE.FindAllStringSubmatch(decisionsText, -1)) {
			problems = append(problems, "not every D-xxx source heading has a parseable Status field")
		}
		catalogStatuses := map[string]string{}
		for _, decision := range decisionCatalog() {
			catalogStatuses[decision.ID] = decision.Status
		}
		problems = append(problems, compareCatalogStatuses("decision", sourceStatuses, catalogStatuses, func(status string) string {
			if strings.HasPrefix(status, "accepted") {
				return "accepted"
			}
			return status
		})...)
		problems = append(problems, compareContentDigests("decision source", sourceBlockDigests(decisionsText, decisionHeadingRE, "## 3. Open"), expectedDecisionSourceDigests)...)
		if actual := decisionCatalogDigest(decisionCatalog()); actual != expectedDecisionCatalogDigest {
			problems = append(problems, fmt.Sprintf("decision catalog content mismatch: expected sha256=%s actual=%s", expectedDecisionCatalogDigest, actual))
		}
	}

	questionsText, err := readKnowledgeSource(root, docOpenQuestions)
	if err != nil {
		problems = append(problems, err.Error())
	} else {
		activeText := questionsText
		if index := strings.Index(activeText, "## 3. Resolved questions"); index >= 0 {
			activeText = activeText[:index]
		}
		sourceStatuses := map[string]string{}
		for _, match := range openQuestionBlockRE.FindAllStringSubmatch(activeText, -1) {
			sourceStatuses[match[1]] = strings.TrimSpace(match[2])
		}
		catalogStatuses := map[string]string{}
		for _, question := range openQuestionCatalog() {
			catalogStatuses[question.ID] = question.Status
		}
		problems = append(problems, compareCatalogStatuses("open question", sourceStatuses, catalogStatuses, func(status string) string {
			return strings.ReplaceAll(status, "-", "_")
		})...)
		problems = append(problems, compareContentDigests("open question source", sourceBlockDigests(activeText, openQuestionHeadingRE, ""), expectedOpenQuestionSourceDigests)...)
		if actual := openQuestionCatalogDigest(openQuestionCatalog()); actual != expectedOpenQuestionCatalogDigest {
			problems = append(problems, fmt.Sprintf("open question catalog content mismatch: expected sha256=%s actual=%s", expectedOpenQuestionCatalogDigest, actual))
		}
	}

	problems = append(problems, validateRoadmapCatalog(root)...)

	handoffIndex, err := readKnowledgeSource(root, docHandoffIndex)
	if err != nil {
		problems = append(problems, err.Error())
	} else if !strings.Contains(handoffIndex, filepath.Base(docWorkflowMigrationHandoff)) {
		problems = append(problems, "HANDOFF_INDEX does not point to the latest Codex migration handoff")
	}
	if !fileExists(root, docWorkflowMigrationHandoff) {
		problems = append(problems, "latest Codex migration handoff is missing: "+docWorkflowMigrationHandoff)
	}
	for _, roadmap := range roadmapCatalog() {
		if !fileExists(root, roadmap.Path) {
			problems = append(problems, "cataloged roadmap is missing: "+roadmap.Path)
		}
	}

	if len(problems) > 0 {
		sort.Strings(problems)
		return fmt.Errorf("knowledge catalog drift (source documents win): %s", strings.Join(problems, "; "))
	}
	return nil
}

func readKnowledgeSource(root, path string) (string, error) {
	data, err := os.ReadFile(filepath.Join(root, filepath.FromSlash(path)))
	if err != nil {
		return "", fmt.Errorf("read source %s: %w", path, err)
	}
	return string(data), nil
}

func compareCatalogStatuses(label string, source, catalog map[string]string, normalize func(string) string) []string {
	var problems []string
	for id, sourceStatus := range source {
		catalogStatus, ok := catalog[id]
		if !ok {
			problems = append(problems, fmt.Sprintf("%s %s exists in source but not catalog", label, id))
			continue
		}
		if normalize(sourceStatus) != normalize(catalogStatus) {
			problems = append(problems, fmt.Sprintf("%s %s status mismatch: source=%q catalog=%q", label, id, sourceStatus, catalogStatus))
		}
	}
	for id := range catalog {
		if _, ok := source[id]; !ok {
			problems = append(problems, fmt.Sprintf("%s %s exists in catalog but not active source", label, id))
		}
	}
	return problems
}

func sourceBlockDigests(text string, heading *regexp.Regexp, endMarker string) map[string]string {
	text = strings.ReplaceAll(text, "\r\n", "\n")
	if endMarker != "" {
		if index := strings.Index(text, endMarker); index >= 0 {
			text = text[:index]
		}
	}
	matches := heading.FindAllStringSubmatchIndex(text, -1)
	digests := make(map[string]string, len(matches))
	for i, match := range matches {
		end := len(text)
		if i+1 < len(matches) {
			end = matches[i+1][0]
		}
		id := text[match[2]:match[3]]
		digests[id] = digestText(strings.TrimSpace(text[match[0]:end]))
	}
	return digests
}

func compareContentDigests(label string, actual, expected map[string]string) []string {
	var problems []string
	for id, expectedDigest := range expected {
		actualDigest, ok := actual[id]
		if !ok {
			problems = append(problems, fmt.Sprintf("%s %s is missing", label, id))
			continue
		}
		if actualDigest != expectedDigest {
			problems = append(problems, fmt.Sprintf("%s %s content mismatch: expected sha256=%s actual=%s", label, id, expectedDigest, actualDigest))
		}
	}
	for id := range actual {
		if _, ok := expected[id]; !ok {
			problems = append(problems, fmt.Sprintf("%s %s has no authoritative content lock", label, id))
		}
	}
	return problems
}

func decisionCatalogDigest(catalog []KnowledgeDecision) string {
	rows := make([]string, 0, len(catalog))
	for _, item := range catalog {
		fields := []string{item.ID, item.Title, item.Kind, item.Status, item.Summary}
		fields = append(fields, item.Areas...)
		rows = append(rows, strings.Join(fields, "\x00"))
	}
	return digestText(strings.Join(rows, "\n"))
}

func openQuestionCatalogDigest(catalog []OpenQuestion) string {
	rows := make([]string, 0, len(catalog))
	for _, item := range catalog {
		rows = append(rows, strings.Join([]string{item.ID, item.Title, item.Area, item.Status, item.Owner, item.Summary}, "\x00"))
	}
	return digestText(strings.Join(rows, "\n"))
}

func digestText(text string) string {
	sum := sha256.Sum256([]byte(text))
	return hex.EncodeToString(sum[:])
}

type roadmapSourceState struct {
	Status       string
	CurrentPhase string
	NextStep     string
}

func validateRoadmapCatalog(root string) []string {
	var problems []string
	sourceStates := map[string]roadmapSourceState{}

	for _, path := range []string{docKnowledgeBasePolishRoadmap, docKnowledgeBaseRoadmap} {
		text, err := readKnowledgeSource(root, path)
		if err != nil {
			problems = append(problems, err.Error())
			continue
		}
		state, err := parseCatalogRoadmapState(text)
		if err != nil {
			problems = append(problems, fmt.Sprintf("%s: %v", path, err))
			continue
		}
		sourceStates[path] = state
	}

	steamText, err := readKnowledgeSource(root, docSteamGameRoadmapV2)
	if err != nil {
		problems = append(problems, err.Error())
	} else {
		state, parseErr := parseSteamRoadmapState(steamText)
		if parseErr != nil {
			problems = append(problems, fmt.Sprintf("%s: %v", docSteamGameRoadmapV2, parseErr))
		} else {
			sourceStates[docSteamGameRoadmapV2] = state
		}
	}

	for _, roadmap := range roadmapCatalog() {
		source, ok := sourceStates[roadmap.Path]
		if !ok {
			problems = append(problems, "cataloged roadmap has no parseable authoritative state: "+roadmap.Path)
			continue
		}
		for field, values := range map[string][2]string{
			"status":        {source.Status, roadmap.Status},
			"current phase": {source.CurrentPhase, roadmap.CurrentPhase},
			"next step":     {source.NextStep, roadmap.NextStep},
		} {
			if values[0] != values[1] {
				problems = append(problems, fmt.Sprintf("roadmap %s %s mismatch: source=%q catalog=%q", roadmap.ID, field, values[0], values[1]))
			}
		}
	}
	return problems
}

func parseCatalogRoadmapState(text string) (roadmapSourceState, error) {
	state := roadmapSourceState{
		Status:       lineValue(text, "Catalog status:"),
		CurrentPhase: lineValue(text, "Catalog current phase:"),
		NextStep:     lineValue(text, "Catalog next step:"),
	}
	if state.Status == "" || state.CurrentPhase == "" || state.NextStep == "" {
		return roadmapSourceState{}, fmt.Errorf("authoritative Catalog status/current phase/next step block is incomplete")
	}
	return state, nil
}

func parseSteamRoadmapState(text string) (roadmapSourceState, error) {
	status := lineValue(text, "Статус:")
	nextStep := fencedValueAfter(text, "Current active task:")
	currentPhase := strings.Join(strings.Fields(fencedValueAfter(text, "Current product status:")), " ")
	if status == "" || currentPhase == "" || nextStep == "" {
		return roadmapSourceState{}, fmt.Errorf("status/current active task/current product status is incomplete")
	}
	return roadmapSourceState{Status: status, CurrentPhase: currentPhase, NextStep: nextStep}, nil
}

func lineValue(text, prefix string) string {
	for _, line := range strings.Split(strings.ReplaceAll(text, "\r\n", "\n"), "\n") {
		line = strings.TrimSpace(line)
		if strings.HasPrefix(line, prefix) {
			return strings.Trim(strings.TrimSpace(strings.TrimPrefix(line, prefix)), "`")
		}
	}
	return ""
}

func fencedValueAfter(text, marker string) string {
	index := strings.Index(text, marker)
	if index < 0 {
		return ""
	}
	tail := text[index+len(marker):]
	start := strings.Index(tail, "```text")
	if start < 0 {
		return ""
	}
	tail = tail[start+len("```text"):]
	end := strings.Index(tail, "```")
	if end < 0 {
		return ""
	}
	return strings.TrimSpace(tail[:end])
}
