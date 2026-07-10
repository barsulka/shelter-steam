package sheltermcp

import (
	"bytes"
	"context"
	"encoding/base64"
	"encoding/json"
	"fmt"
	"io"
	"net"
	"net/http"
	"net/url"
	"os"
	"sort"
	"strconv"
	"strings"
	"time"

	"github.com/modelcontextprotocol/go-sdk/mcp"
)

type ControlAction struct {
	Name        string `json:"name"`
	Method      string `json:"method"`
	Path        string `json:"path"`
	NeedsToken  bool   `json:"needs_token"`
	Description string `json:"description"`
}

type controlSpec struct {
	method      string
	path        string
	needsToken  bool
	description string
	binary      bool
}

var controlActions = map[string]controlSpec{
	"health":               {"GET", "/health", false, "Read connector health.", false},
	"schema":               {"GET", "/schema", false, "Read connector schema.", false},
	"state":                {"GET", "/state", false, "Read live Godot state.", false},
	"ui_hide":              {"POST", "/control/ui/hide", true, "Hide/minimize the game UI/window through the dev connector.", false},
	"ui_show":              {"POST", "/control/ui/show", true, "Show the game UI/window through the dev connector.", false},
	"ui_toggle":            {"POST", "/control/ui/toggle", true, "Toggle game UI/window visibility.", false},
	"capture_screenshot":   {"POST", "/control/capture/screenshot", true, "Ask Godot to capture one viewport PNG and return capture metadata.", false},
	"capture_video_start":  {"POST", "/control/capture/video/start", true, "Start the bounded 10s PNG-frame capture.", false},
	"capture_video_status": {"GET", "/control/capture/video/status", true, "Read capture progress and frame URLs.", false},
	"capture_file":         {"GET", "/control/capture/files/{file_id}", true, "Download a captured file by file_id.", true},
	"runtime_fixtures":     {"GET", "/control/runtime/fixtures", true, "List accepted runtime fixtures.", false},
	"runtime_fixture_load": {"POST", "/control/runtime/fixture/load", true, "Load an accepted runtime fixture.", false},
	"runtime_speed":        {"POST", "/control/runtime/speed", true, "Set accepted dev speed multiplier.", false},
	"runtime_state_export": {"POST", "/control/runtime/state/export", true, "Export current runtime state.", false},
	"runtime_state_import": {"POST", "/control/runtime/state/import", true, "Import a provided runtime state object.", false},
	"runtime_state_clear":  {"POST", "/control/runtime/state/clear", true, "Clear runtime state.", false},
	"runtime_save_write":   {"POST", "/control/runtime/save/write", true, "Write local prototype save.", false},
	"runtime_save_load":    {"POST", "/control/runtime/save/load", true, "Load local prototype save.", false},
	"runtime_save_erase":   {"POST", "/control/runtime/save/erase", true, "Erase local prototype save.", false},
	"runtime_route_start":  {"POST", "/control/runtime/route/start", true, "Start accepted test route.", false},
	"runtime_delivery_confirm": {"POST", "/control/runtime/delivery/confirm", true,
		"Confirm the accepted first Warm Food Delivery dispatch when runtime is already ready_to_dispatch.", false},
	"runtime_dog_assign":     {"POST", "/control/runtime/dog/assign", true, "Assign a dog to a room/activity.", false},
	"runtime_research_start": {"POST", "/control/runtime/research/start", true, "Start House of Curiosity research.", false},
	"runtime_debug_tick":     {"POST", "/control/runtime/debug/tick", true, "Advance bounded prototype debug time.", false},
	"connector_http_stop":    {"POST", "/control/connector/http/stop", true, "Stop the local HTTP connector after returning its response.", false},
}

func sortedControlActions() []ControlAction {
	keys := make([]string, 0, len(controlActions))
	for key := range controlActions {
		keys = append(keys, key)
	}
	sort.Strings(keys)
	actions := make([]ControlAction, 0, len(keys))
	for _, key := range keys {
		spec := controlActions[key]
		actions = append(actions, ControlAction{
			Name:        key,
			Method:      spec.method,
			Path:        spec.path,
			NeedsToken:  spec.needsToken,
			Description: spec.description,
		})
	}
	return actions
}

type ControlShelterGameInput struct {
	Action           string         `json:"action" jsonschema:"whitelisted control action id; call list_shelter_dev_commands to inspect actions"`
	BaseURL          string         `json:"base_url,omitempty" jsonschema:"local connector base URL; default http://127.0.0.1:8765"`
	Token            string         `json:"token,omitempty" jsonschema:"connector token; defaults to SHELTER_STATE_CONNECTOR_TOKEN or STATE_CONNECTOR_TOKEN"`
	Payload          map[string]any `json:"payload,omitempty" jsonschema:"JSON payload for POST actions"`
	FileID           string         `json:"file_id,omitempty" jsonschema:"capture file id for capture_file"`
	TimeoutSeconds   int            `json:"timeout_seconds,omitempty" jsonschema:"HTTP timeout; default 30"`
	MaxResponseBytes int64          `json:"max_response_bytes,omitempty" jsonschema:"max bytes to embed from response; default 1048576"`
}

type ControlShelterGameOutput struct {
	OK              bool              `json:"ok"`
	Action          string            `json:"action"`
	Method          string            `json:"method"`
	URL             string            `json:"url"`
	StatusCode      int               `json:"status_code"`
	ContentType     string            `json:"content_type,omitempty"`
	ResponseJSON    map[string]any    `json:"response_json,omitempty"`
	ResponseText    string            `json:"response_text,omitempty"`
	ResponseBase64  string            `json:"response_base64,omitempty"`
	Truncated       bool              `json:"truncated,omitempty"`
	Error           string            `json:"error,omitempty"`
	RedactedSecrets map[string]string `json:"redacted_secrets,omitempty"`
}

func (a *App) ControlShelterGame(ctx context.Context, _ *mcp.CallToolRequest, input ControlShelterGameInput) (*mcp.CallToolResult, ControlShelterGameOutput, error) {
	out, err := a.controlShelterGame(ctx, input)
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

func (a *App) controlShelterGame(ctx context.Context, input ControlShelterGameInput) (ControlShelterGameOutput, error) {
	action := strings.TrimSpace(input.Action)
	spec, ok := controlActions[action]
	out := ControlShelterGameOutput{Action: action}
	if !ok {
		return out, fmt.Errorf("unsupported control action %q", action)
	}
	out.Method = spec.method

	baseURL := input.BaseURL
	if baseURL == "" {
		baseURL = a.cfg.DefaultBaseURL
	}
	parsed, err := validateLocalBaseURL(baseURL)
	if err != nil {
		return out, err
	}

	token := input.Token
	if token == "" {
		token = os.Getenv("SHELTER_STATE_CONNECTOR_TOKEN")
	}
	if token == "" {
		token = os.Getenv("STATE_CONNECTOR_TOKEN")
	}
	if spec.needsToken && token == "" {
		return out, fmt.Errorf("action %s requires token", action)
	}
	if token != "" {
		out.RedactedSecrets = map[string]string{"token": redacted(token)}
	}

	path := spec.path
	if strings.Contains(path, "{file_id}") {
		fileID := strings.TrimSpace(input.FileID)
		if fileID == "" {
			return out, fmt.Errorf("file_id is required for %s", action)
		}
		if !safeRunID.MatchString(fileID) {
			return out, fmt.Errorf("file_id %q is not safe", fileID)
		}
		path = strings.ReplaceAll(path, "{file_id}", url.PathEscape(fileID))
	}

	if err := validateControlPayload(action, input.Payload); err != nil {
		return out, err
	}

	endpoint := parsed.ResolveReference(&url.URL{Path: path})
	query := endpoint.Query()
	if token != "" {
		query.Set("token", token)
	}
	endpoint.RawQuery = query.Encode()
	out.URL = redactURLToken(endpoint.String())

	var body io.Reader
	if spec.method == "POST" {
		payload := input.Payload
		if payload == nil {
			payload = map[string]any{}
		}
		data, err := json.Marshal(payload)
		if err != nil {
			return out, err
		}
		body = bytes.NewReader(data)
	}

	timeout := 30 * time.Second
	if input.TimeoutSeconds > 0 {
		timeout = time.Duration(input.TimeoutSeconds) * time.Second
	}
	if timeout > 5*time.Minute {
		timeout = 5 * time.Minute
	}
	req, err := http.NewRequestWithContext(ctx, spec.method, endpoint.String(), body)
	if err != nil {
		return out, err
	}
	if spec.method == "POST" {
		req.Header.Set("Content-Type", "application/json")
	}
	client := &http.Client{Timeout: timeout}
	res, err := client.Do(req)
	if err != nil {
		return out, err
	}
	defer res.Body.Close()

	out.StatusCode = res.StatusCode
	out.ContentType = res.Header.Get("Content-Type")

	maxBytes := input.MaxResponseBytes
	if maxBytes <= 0 {
		maxBytes = 1024 * 1024
	}
	if maxBytes > 5*1024*1024 {
		maxBytes = 5 * 1024 * 1024
	}
	data, err := io.ReadAll(io.LimitReader(res.Body, maxBytes+1))
	if err != nil {
		return out, err
	}
	if int64(len(data)) > maxBytes {
		out.Truncated = true
		data = data[:maxBytes]
	}
	if res.StatusCode < 200 || res.StatusCode >= 300 {
		out.ResponseText = string(data)
		return out, fmt.Errorf("connector returned HTTP %d", res.StatusCode)
	}

	out.OK = true
	if spec.binary {
		out.ResponseBase64 = base64.StdEncoding.EncodeToString(data)
		return out, nil
	}
	var responseJSON map[string]any
	if err := json.Unmarshal(data, &responseJSON); err == nil {
		out.ResponseJSON = responseJSON
	} else {
		out.ResponseText = string(data)
	}
	return out, nil
}

func validateLocalBaseURL(raw string) (*url.URL, error) {
	parsed, err := url.Parse(raw)
	if err != nil {
		return nil, err
	}
	if parsed.Scheme != "http" {
		return nil, fmt.Errorf("base_url must use http")
	}
	host := parsed.Hostname()
	if host == "" {
		return nil, fmt.Errorf("base_url must include host")
	}
	if host != "localhost" {
		ip := net.ParseIP(host)
		if ip == nil || !(ip.IsLoopback() || ip.Equal(net.IPv4(127, 0, 0, 1))) {
			return nil, fmt.Errorf("base_url host must be localhost or loopback, got %q", host)
		}
	}
	return parsed, nil
}

func validateControlPayload(action string, payload map[string]any) error {
	switch action {
	case "runtime_fixture_load":
		fixture, _ := payload["fixture"].(string)
		if fixture == "" {
			return fmt.Errorf("payload.fixture is required")
		}
		if !slicesContainsString(fixtureIDs, fixture) {
			return fmt.Errorf("unsupported fixture %q", fixture)
		}
	case "runtime_speed":
		value, err := numberAsInt(payload["multiplier"])
		if err != nil {
			return fmt.Errorf("payload.multiplier is required: %w", err)
		}
		if !slicesContainsInt(speedValues, value) {
			return fmt.Errorf("unsupported speed multiplier %d", value)
		}
	case "runtime_debug_tick":
		value, err := numberAsFloat(payload["seconds"])
		if err != nil {
			return fmt.Errorf("payload.seconds is required: %w", err)
		}
		if value <= 0 || value > 30 {
			return fmt.Errorf("payload.seconds must be > 0 and <= 30")
		}
	case "runtime_state_import":
		if payload == nil || len(payload) == 0 {
			return fmt.Errorf("payload must contain the state object to import")
		}
	}
	return nil
}

func slicesContainsString(values []string, needle string) bool {
	for _, value := range values {
		if value == needle {
			return true
		}
	}
	return false
}

func slicesContainsInt(values []int, needle int) bool {
	for _, value := range values {
		if value == needle {
			return true
		}
	}
	return false
}

func numberAsInt(value any) (int, error) {
	switch typed := value.(type) {
	case int:
		return typed, nil
	case int64:
		return int(typed), nil
	case float64:
		if typed != float64(int(typed)) {
			return 0, fmt.Errorf("must be an integer")
		}
		return int(typed), nil
	case json.Number:
		return strconv.Atoi(typed.String())
	default:
		return 0, fmt.Errorf("missing or not numeric")
	}
}

func numberAsFloat(value any) (float64, error) {
	switch typed := value.(type) {
	case float64:
		return typed, nil
	case int:
		return float64(typed), nil
	case int64:
		return float64(typed), nil
	case json.Number:
		return strconv.ParseFloat(typed.String(), 64)
	default:
		return 0, fmt.Errorf("missing or not numeric")
	}
}

func redactURLToken(raw string) string {
	parsed, err := url.Parse(raw)
	if err != nil {
		return raw
	}
	query := parsed.Query()
	if query.Has("token") {
		query.Set("token", "<redacted>")
	}
	parsed.RawQuery = query.Encode()
	return parsed.String()
}
