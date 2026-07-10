package sheltermcp

import (
	"os"
	"path/filepath"
	"testing"
)

func TestNewConfigDerivesMonorepoRoots(t *testing.T) {
	t.Setenv("SHELTER_MCP_REPO_ROOT", "")
	t.Setenv("SHELTER_STEAM_ROOT", "")

	cfg, err := NewConfig("")
	if err != nil {
		t.Fatal(err)
	}
	if !samePath(cfg.SteamRoot, filepath.Join(cfg.RepoRoot, "steam")) {
		t.Fatalf("steam root %q was not derived from monorepo %q", cfg.SteamRoot, cfg.RepoRoot)
	}
}

func TestPathWithin(t *testing.T) {
	root := t.TempDir()
	inside := filepath.Join(root, "mcp")
	if err := os.Mkdir(inside, 0o755); err != nil {
		t.Fatal(err)
	}
	if !pathWithin(inside, root) || pathWithin(t.TempDir(), root) {
		t.Fatal("pathWithin did not preserve the monorepo boundary")
	}
}
