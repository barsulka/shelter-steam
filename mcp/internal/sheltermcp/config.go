package sheltermcp

import (
	"fmt"
	"os"
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
	DevScript       string
	LaunchScript    string
	WorkbenchRoot   string
	MCPRuntimeRoot  string
	DefaultPort     int
	DefaultBaseURL  string
	DefaultTimeout  time.Duration
	MaxTimeout      time.Duration
	MaxArtifactSize int64
}

func NewConfig(steamRootFlag string) (Config, error) {
	repoRoot, err := resolveMonorepoRoot(steamRootFlag)
	if err != nil {
		return Config{}, err
	}

	steamRoot := strings.TrimSpace(steamRootFlag)
	if steamRoot == "" {
		steamRoot = strings.TrimSpace(os.Getenv("SHELTER_STEAM_ROOT"))
	}
	if steamRoot == "" {
		steamRoot = filepath.Join(repoRoot, "steam")
	}
	absSteamRoot, err := cleanExistingDir(steamRoot, "steam root")
	if err != nil {
		return Config{}, err
	}
	if !pathWithin(absSteamRoot, repoRoot) {
		return Config{}, fmt.Errorf("steam root %q must stay inside monorepo root %q", absSteamRoot, repoRoot)
	}

	cfg := Config{
		SteamRoot:       absSteamRoot,
		RepoRoot:        repoRoot,
		DevScript:       filepath.Join(absSteamRoot, "tools", "dev-vertical-slice.sh"),
		LaunchScript:    filepath.Join(absSteamRoot, "launch.sh"),
		WorkbenchRoot:   filepath.Join(absSteamRoot, ".runtime", "workbench_capture_runs"),
		MCPRuntimeRoot:  filepath.Join(absSteamRoot, ".runtime", "shelter_mcp"),
		DefaultPort:     8765,
		DefaultBaseURL:  "http://127.0.0.1:8765",
		DefaultTimeout:  10 * time.Minute,
		MaxTimeout:      60 * time.Minute,
		MaxArtifactSize: 256 * 1024,
	}

	for _, script := range []string{cfg.DevScript, cfg.LaunchScript} {
		if err := requireExecutable(script); err != nil {
			return Config{}, err
		}
	}
	return cfg, nil
}

func resolveMonorepoRoot(steamRootFlag string) (string, error) {
	if override := strings.TrimSpace(os.Getenv("SHELTER_MCP_REPO_ROOT")); override != "" {
		return validateMonorepoRoot(override)
	}

	steamRoot := strings.TrimSpace(steamRootFlag)
	if steamRoot == "" {
		steamRoot = strings.TrimSpace(os.Getenv("SHELTER_STEAM_ROOT"))
	}
	if steamRoot != "" {
		absSteamRoot, err := cleanExistingDir(steamRoot, "steam root")
		if err != nil {
			return "", err
		}
		return validateMonorepoRoot(filepath.Dir(absSteamRoot))
	}

	for _, start := range selfRootCandidates() {
		if root, ok := findMonorepoAncestor(start); ok {
			return root, nil
		}
	}
	return "", fmt.Errorf("could not resolve Shelter monorepo root; run inside the checkout or set SHELTER_MCP_REPO_ROOT")
}

func validateMonorepoRoot(path string) (string, error) {
	root, err := cleanExistingDir(path, "shelter monorepo root")
	if err != nil {
		return "", err
	}
	if !isMonorepoRoot(root) {
		return "", fmt.Errorf("shelter monorepo root %q must contain mcp/go.mod and steam/", root)
	}
	return root, nil
}

func findMonorepoAncestor(start string) (string, bool) {
	dir, err := filepath.Abs(start)
	if err != nil {
		return "", false
	}
	for {
		if isMonorepoRoot(dir) {
			return dir, true
		}
		parent := filepath.Dir(dir)
		if parent == dir {
			return "", false
		}
		dir = parent
	}
}

func isMonorepoRoot(root string) bool {
	data, err := os.ReadFile(filepath.Join(root, "mcp", "go.mod"))
	if err != nil || !strings.Contains(string(data), "module shelter-mcp") {
		return false
	}
	info, err := os.Stat(filepath.Join(root, "steam"))
	return err == nil && info.IsDir()
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
