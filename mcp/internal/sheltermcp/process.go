package sheltermcp

import (
	"context"
	"crypto/rand"
	"encoding/hex"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"net/http"
	"net/url"
	"os"
	"os/exec"
	"path/filepath"
	"strconv"
	"strings"
	"syscall"
	"time"

	"github.com/modelcontextprotocol/go-sdk/mcp"
)

type StartControlConnectorInput struct {
	Port           int    `json:"port,omitempty" jsonschema:"local connector port; default 8765"`
	Token          string `json:"token,omitempty" jsonschema:"connector token; generated when omitted"`
	RuntimeFixture string `json:"runtime_fixture,omitempty" jsonschema:"optional fixture id to load at startup"`
	LoadSave       bool   `json:"load_save,omitempty" jsonschema:"start with --runtime-load-save"`
	WaitSeconds    int    `json:"wait_seconds,omitempty" jsonschema:"how long to wait for /health and /control; default 20"`
}

type ManagedConnectorRecord struct {
	PID       int    `json:"pid"`
	Port      int    `json:"port"`
	BaseURL   string `json:"base_url"`
	Token     string `json:"token"`
	LogFile   string `json:"log_file"`
	StartedAt string `json:"started_at"`
	Command   string `json:"command"`
}

type StartControlConnectorOutput struct {
	OK              bool                    `json:"ok"`
	Reused          bool                    `json:"reused"`
	PID             int                     `json:"pid,omitempty"`
	Port            int                     `json:"port"`
	BaseURL         string                  `json:"base_url"`
	Token           string                  `json:"token,omitempty"`
	LogFile         string                  `json:"log_file,omitempty"`
	PidFile         string                  `json:"pid_file,omitempty"`
	Error           string                  `json:"error,omitempty"`
	RedactedSecrets map[string]string       `json:"redacted_secrets,omitempty"`
	Record          *ManagedConnectorRecord `json:"record,omitempty"`
}

func (a *App) StartControlConnector(ctx context.Context, _ *mcp.CallToolRequest, input StartControlConnectorInput) (*mcp.CallToolResult, StartControlConnectorOutput, error) {
	out, err := a.startControlConnector(ctx, input)
	if err != nil {
		out.OK = false
		out.Error = err.Error()
		return structuredToolError(out), out, nil
	}
	return structuredResult(out), out, nil
}

func (a *App) startControlConnector(ctx context.Context, input StartControlConnectorInput) (StartControlConnectorOutput, error) {
	port := input.Port
	if port == 0 {
		port = a.cfg.DefaultPort
	}
	if err := validatePort(port); err != nil {
		return StartControlConnectorOutput{}, err
	}

	token := input.Token
	if token == "" {
		token = os.Getenv("SHELTER_STATE_CONNECTOR_TOKEN")
	}
	if token == "" {
		token = os.Getenv("STATE_CONNECTOR_TOKEN")
	}
	if token == "" {
		token = randomToken()
	}
	if token == "" {
		return StartControlConnectorOutput{}, fmt.Errorf("could not generate connector token")
	}

	if input.RuntimeFixture != "" && !slicesContainsString(fixtureIDs, input.RuntimeFixture) {
		return StartControlConnectorOutput{}, fmt.Errorf("unsupported fixture %q", input.RuntimeFixture)
	}

	baseURL := "http://127.0.0.1:" + strconv.Itoa(port)
	pidFile := a.connectorPidFile(port)
	out := StartControlConnectorOutput{
		OK:              true,
		Port:            port,
		BaseURL:         baseURL,
		Token:           token,
		PidFile:         pidFile,
		RedactedSecrets: map[string]string{"token": redacted(token)},
	}

	if controlReachable(ctx, baseURL, token, 2*time.Second) {
		out.Reused = true
		if record, err := readConnectorRecord(pidFile); err == nil {
			out.PID = record.PID
			out.LogFile = record.LogFile
			out.Record = &record
		}
		return out, nil
	}

	if err := os.MkdirAll(a.cfg.MCPRuntimeRoot, 0755); err != nil {
		return out, err
	}
	logFile := filepath.Join(a.cfg.MCPRuntimeRoot, fmt.Sprintf("connector-control-%d-%s.log", port, time.Now().UTC().Format("20060102T150405Z")))
	logHandle, err := os.OpenFile(logFile, os.O_CREATE|os.O_WRONLY|os.O_APPEND, 0644)
	if err != nil {
		return out, err
	}
	defer logHandle.Close()

	args := []string{"connector-control"}
	if input.RuntimeFixture != "" {
		args = append(args, "--runtime-load-fixture="+input.RuntimeFixture)
	}
	if input.LoadSave {
		args = append(args, "--runtime-load-save")
	}

	cmd := exec.Command(a.cfg.DevScript, args...)
	cmd.Dir = a.cfg.SteamRoot
	cmd.Env = append(os.Environ(),
		"STATE_CONNECTOR_PORT="+strconv.Itoa(port),
		"STATE_CONNECTOR_TOKEN="+token,
	)
	cmd.Stdout = logHandle
	cmd.Stderr = logHandle
	if err := cmd.Start(); err != nil {
		return out, err
	}

	out.PID = cmd.Process.Pid
	out.LogFile = logFile

	go func() {
		_ = cmd.Wait()
	}()

	record := ManagedConnectorRecord{
		PID:       cmd.Process.Pid,
		Port:      port,
		BaseURL:   baseURL,
		Token:     token,
		LogFile:   logFile,
		StartedAt: time.Now().UTC().Format(time.RFC3339),
		Command:   strings.Join(append([]string{a.cfg.DevScript}, args...), " "),
	}
	if err := writeConnectorRecord(pidFile, record); err != nil {
		return out, err
	}
	out.Record = &record

	wait := 20 * time.Second
	if input.WaitSeconds > 0 {
		wait = time.Duration(input.WaitSeconds) * time.Second
	}
	if wait > 2*time.Minute {
		wait = 2 * time.Minute
	}
	waitCtx, cancel := context.WithTimeout(ctx, wait)
	defer cancel()
	for {
		if controlReachable(waitCtx, baseURL, token, 2*time.Second) {
			return out, nil
		}
		if !processAlive(cmd.Process.Pid) {
			return out, fmt.Errorf("connector process exited before becoming reachable; see %s", logFile)
		}
		select {
		case <-waitCtx.Done():
			return out, fmt.Errorf("connector did not become reachable within %s; see %s", wait, logFile)
		case <-time.After(200 * time.Millisecond):
		}
	}
}

type StopControlConnectorInput struct {
	Port                int    `json:"port,omitempty" jsonschema:"connector port; default 8765"`
	Token               string `json:"token,omitempty" jsonschema:"connector token; defaults to pidfile/env"`
	LeaveProcessRunning bool   `json:"leave_process_running,omitempty" jsonschema:"if true, stop only the HTTP connector and do not SIGTERM the managed Godot process"`
}

type StopControlConnectorOutput struct {
	OK          bool   `json:"ok"`
	Port        int    `json:"port"`
	BaseURL     string `json:"base_url"`
	PID         int    `json:"pid,omitempty"`
	PidFile     string `json:"pid_file,omitempty"`
	HTTPStopped bool   `json:"http_stopped"`
	Killed      bool   `json:"killed"`
	Error       string `json:"error,omitempty"`
}

func (a *App) StopControlConnector(ctx context.Context, _ *mcp.CallToolRequest, input StopControlConnectorInput) (*mcp.CallToolResult, StopControlConnectorOutput, error) {
	out, err := a.stopControlConnector(ctx, input)
	if err != nil {
		out.OK = false
		out.Error = err.Error()
		return structuredToolError(out), out, nil
	}
	return structuredResult(out), out, nil
}

func (a *App) stopControlConnector(ctx context.Context, input StopControlConnectorInput) (StopControlConnectorOutput, error) {
	port := input.Port
	if port == 0 {
		port = a.cfg.DefaultPort
	}
	if err := validatePort(port); err != nil {
		return StopControlConnectorOutput{}, err
	}

	baseURL := "http://127.0.0.1:" + strconv.Itoa(port)
	pidFile := a.connectorPidFile(port)
	out := StopControlConnectorOutput{
		OK:      true,
		Port:    port,
		BaseURL: baseURL,
		PidFile: pidFile,
	}

	record, _ := readConnectorRecord(pidFile)
	out.PID = record.PID
	token := input.Token
	if token == "" {
		token = record.Token
	}
	if token == "" {
		token = os.Getenv("SHELTER_STATE_CONNECTOR_TOKEN")
	}
	if token == "" {
		token = os.Getenv("STATE_CONNECTOR_TOKEN")
	}

	if token != "" {
		endpoint := baseURL + "/control/connector/http/stop?token=" + url.QueryEscape(token)
		req, err := http.NewRequestWithContext(ctx, "POST", endpoint, strings.NewReader("{}"))
		if err == nil {
			req.Header.Set("Content-Type", "application/json")
			client := &http.Client{Timeout: 5 * time.Second}
			if res, err := client.Do(req); err == nil {
				io.Copy(io.Discard, res.Body)
				res.Body.Close()
				out.HTTPStopped = res.StatusCode >= 200 && res.StatusCode < 300
			}
		}
	}

	if !input.LeaveProcessRunning && record.PID > 0 && processAlive(record.PID) {
		if err := syscall.Kill(record.PID, syscall.SIGTERM); err == nil {
			out.Killed = true
		}
	}
	_ = os.Remove(pidFile)
	return out, nil
}

func (a *App) connectorPidFile(port int) string {
	return filepath.Join(a.cfg.MCPRuntimeRoot, fmt.Sprintf("connector-control-%d.json", port))
}

func writeConnectorRecord(path string, record ManagedConnectorRecord) error {
	if err := os.MkdirAll(filepath.Dir(path), 0755); err != nil {
		return err
	}
	data, err := json.MarshalIndent(record, "", "  ")
	if err != nil {
		return err
	}
	return os.WriteFile(path, data, 0600)
}

func readConnectorRecord(path string) (ManagedConnectorRecord, error) {
	data, err := os.ReadFile(path)
	if err != nil {
		return ManagedConnectorRecord{}, err
	}
	var record ManagedConnectorRecord
	if err := json.Unmarshal(data, &record); err != nil {
		return ManagedConnectorRecord{}, err
	}
	return record, nil
}

func randomToken() string {
	var data [24]byte
	if _, err := rand.Read(data[:]); err != nil {
		return ""
	}
	return hex.EncodeToString(data[:])
}

func controlReachable(ctx context.Context, baseURL, token string, timeout time.Duration) bool {
	if token == "" {
		return false
	}
	client := &http.Client{Timeout: timeout}
	req, err := http.NewRequestWithContext(ctx, "GET", baseURL+"/control?token="+url.QueryEscape(token), nil)
	if err != nil {
		return false
	}
	res, err := client.Do(req)
	if err != nil {
		return false
	}
	defer res.Body.Close()
	io.Copy(io.Discard, res.Body)
	return res.StatusCode >= 200 && res.StatusCode < 300
}

func processAlive(pid int) bool {
	if pid <= 0 {
		return false
	}
	err := syscall.Kill(pid, 0)
	return err == nil || errors.Is(err, syscall.EPERM)
}
