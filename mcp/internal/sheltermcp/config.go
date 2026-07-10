package sheltermcp

import (
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"runtime"
	"strings"
	"time"
)

const (
	serverName    = "shelter-game-dev"
	serverVersion = "0.1.0"
)

type Config struct {
	SteamRoot       string
	RepoRoot        string
	SelfRepoRoot    string
	DevScript       string
	LaunchScript    string
	WorkbenchRoot   string
	MCPRuntimeRoot  string
	DefaultPort     int
	DefaultBaseURL  string
	DefaultTimeout  time.Duration
	MaxTimeout      time.Duration
	MaxArtifactSize int64

	FilesystemProxyEnabled bool
	FilesystemCommand      string
	FilesystemRoots        []string
	FilesystemToolPrefix   string
}

func NewConfig(steamRootFlag string) (Config, error) {
	steamRoot := steamRootFlag
	if steamRoot == "" {
		steamRoot = os.Getenv("SHELTER_STEAM_ROOT")
	}
	if steamRoot == "" {
		return Config{}, fmt.Errorf("SHELTER_STEAM_ROOT or --steam-root is required")
	}

	absSteamRoot, err := filepath.Abs(steamRoot)
	if err != nil {
		return Config{}, err
	}
	info, err := os.Stat(absSteamRoot)
	if err != nil {
		return Config{}, fmt.Errorf("steam root %q is not available: %w", absSteamRoot, err)
	}
	if !info.IsDir() {
		return Config{}, fmt.Errorf("steam root %q is not a directory", absSteamRoot)
	}

	repoRoot := filepath.Dir(absSteamRoot)
	if override := strings.TrimSpace(os.Getenv("SHELTER_MCP_REPO_ROOT")); override != "" {
		repoRoot, err = cleanExistingDir(override, "shelter repo root")
		if err != nil {
			return Config{}, err
		}
	}

	selfRepoRoot, err := resolveSelfRepoRoot()
	if err != nil {
		return Config{}, err
	}

	cfg := Config{
		SteamRoot:            absSteamRoot,
		RepoRoot:             repoRoot,
		SelfRepoRoot:         selfRepoRoot,
		DevScript:            filepath.Join(absSteamRoot, "tools", "dev-vertical-slice.sh"),
		LaunchScript:         filepath.Join(absSteamRoot, "launch.sh"),
		WorkbenchRoot:        filepath.Join(absSteamRoot, ".runtime", "workbench_capture_runs"),
		MCPRuntimeRoot:       filepath.Join(absSteamRoot, ".runtime", "shelter_mcp"),
		DefaultPort:          8765,
		DefaultBaseURL:       "http://127.0.0.1:8765",
		DefaultTimeout:       10 * time.Minute,
		MaxTimeout:           60 * time.Minute,
		MaxArtifactSize:      256 * 1024,
		FilesystemToolPrefix: "fs_",
	}
	cfg.configureFilesystemProxy()

	for _, script := range []string{cfg.DevScript, cfg.LaunchScript} {
		if err := requireExecutable(script); err != nil {
			return Config{}, err
		}
	}
	return cfg, nil
}

func cleanExistingDir(path, label string) (string, error) {
	abs, err := filepath.Abs(path)
	if err != nil {
		return "", err
	}
	info, err := os.Stat(abs)
	if err != nil {
		return "", fmt.Errorf("%s %q is not available: %w", label, abs, err)
	}
	if !info.IsDir() {
		return "", fmt.Errorf("%s %q is not a directory", label, abs)
	}
	return abs, nil
}

func resolveSelfRepoRoot() (string, error) {
	if override := strings.TrimSpace(os.Getenv("SHELTER_MCP_SELF_ROOT")); override != "" {
		return cleanExistingDir(override, "shelter MCP repo root")
	}
	for _, start := range selfRootCandidates() {
		if root, ok := findAncestorFile(start, "go.mod", "module shelter-mcp"); ok {
			return root, nil
		}
	}
	return "", fmt.Errorf("could not resolve Shelter MCP repo root; set SHELTER_MCP_SELF_ROOT")
}

func selfRootCandidates() []string {
	var candidates []string
	if wd, err := os.Getwd(); err == nil {
		candidates = append(candidates, wd)
	}
	if exe, err := os.Executable(); err == nil {
		candidates = append(candidates, filepath.Dir(exe))
	}
	if _, file, _, ok := runtime.Caller(0); ok {
		candidates = append(candidates, filepath.Dir(file))
	}
	return candidates
}

func findAncestorFile(start, name, requiredContent string) (string, bool) {
	dir, err := filepath.Abs(start)
	if err != nil {
		return "", false
	}
	for {
		path := filepath.Join(dir, name)
		if data, err := os.ReadFile(path); err == nil && strings.Contains(string(data), requiredContent) {
			return dir, true
		}
		parent := filepath.Dir(dir)
		if parent == dir {
			return "", false
		}
		dir = parent
	}
}

func (c *Config) configureFilesystemProxy() {
	switch strings.ToLower(strings.TrimSpace(os.Getenv("SHELTER_MCP_FILESYSTEM"))) {
	case "0", "false", "off", "no", "disabled":
		c.FilesystemProxyEnabled = false
		return
	}

	command := strings.TrimSpace(os.Getenv("SHELTER_MCP_FILESYSTEM_COMMAND"))
	if command == "" {
		if found, err := exec.LookPath("mcp-server-filesystem"); err == nil {
			command = found
		}
	}
	if command == "" {
		c.FilesystemProxyEnabled = false
		return
	}

	roots := parseFilesystemRoots(os.Getenv("SHELTER_MCP_FILESYSTEM_ROOTS"))

	c.FilesystemProxyEnabled = true
	c.FilesystemCommand = command
	c.FilesystemRoots = roots
	if prefix := strings.TrimSpace(os.Getenv("SHELTER_MCP_FILESYSTEM_PREFIX")); prefix != "" {
		c.FilesystemToolPrefix = prefix
	}
}

func parseFilesystemRoots(raw string) []string {
	var roots []string
	for _, item := range strings.Split(raw, ",") {
		item = strings.TrimSpace(item)
		if item == "" {
			continue
		}
		if abs, err := filepath.Abs(item); err == nil {
			roots = append(roots, abs)
		}
	}
	return roots
}

func requireExecutable(path string) error {
	info, err := os.Stat(path)
	if err != nil {
		return fmt.Errorf("required script %q is not available: %w", path, err)
	}
	if info.IsDir() {
		return fmt.Errorf("required script %q is a directory", path)
	}
	if info.Mode()&0111 == 0 {
		return fmt.Errorf("required script %q is not executable", path)
	}
	return nil
}
