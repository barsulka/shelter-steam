package sheltermcp

import (
	"os"
	"path/filepath"
	"strings"
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

func TestNewConfigDoesNotDependOnKnowledgeSources(t *testing.T) {
	root := t.TempDir()
	for path, data := range map[string]string{
		"mcp/go.mod":                        "module shelter-mcp\n",
		"steam/tools/dev-vertical-slice.sh": "#!/bin/sh\n",
		"steam/launch.sh":                   "#!/bin/sh\n",
	} {
		abs := filepath.Join(root, filepath.FromSlash(path))
		if err := os.MkdirAll(filepath.Dir(abs), 0o755); err != nil {
			t.Fatal(err)
		}
		mode := os.FileMode(0o644)
		if strings.HasSuffix(path, ".sh") {
			mode = 0o755
		}
		if err := os.WriteFile(abs, []byte(data), mode); err != nil {
			t.Fatal(err)
		}
	}
	t.Setenv("SHELTER_MCP_REPO_ROOT", root)
	t.Setenv("SHELTER_STEAM_ROOT", "")
	if _, err := NewConfig(""); err != nil {
		t.Fatalf("startup must not depend on missing knowledge sources: %v", err)
	}
}
