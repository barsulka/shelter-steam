package sheltermcp

import (
	"context"
	"os/exec"
	"testing"
	"time"

	"github.com/modelcontextprotocol/go-sdk/mcp"
)

func TestFilesystemProxyListsToolsWhenBinaryAvailable(t *testing.T) {
	command, err := exec.LookPath("mcp-server-filesystem")
	if err != nil {
		t.Skip("mcp-server-filesystem is not installed")
	}

	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	proxy, err := NewFilesystemToolProxy(ctx, Config{
		FilesystemProxyEnabled: true,
		FilesystemCommand:      command,
		FilesystemRoots:        []string{t.TempDir()},
		FilesystemToolPrefix:   "fs_",
	})
	if err != nil {
		t.Fatal(err)
	}
	defer proxy.session.Close()

	if proxy.tools["fs_read_text_file"] != "read_text_file" {
		t.Fatalf("expected fs_read_text_file to proxy read_text_file, got %q", proxy.tools["fs_read_text_file"])
	}

	server := mcp.NewServer(&mcp.Implementation{Name: "test-server", Version: "test"}, nil)
	if err := proxy.Register(server); err != nil {
		t.Fatal(err)
	}

	clientTransport, serverTransport := mcp.NewInMemoryTransports()
	serverSession, err := server.Connect(ctx, serverTransport, nil)
	if err != nil {
		t.Fatal(err)
	}
	defer serverSession.Close()

	client := mcp.NewClient(&mcp.Implementation{Name: "test-client", Version: "test"}, nil)
	clientSession, err := client.Connect(ctx, clientTransport, nil)
	if err != nil {
		t.Fatal(err)
	}
	defer clientSession.Close()

	result, err := clientSession.ListTools(ctx, nil)
	if err != nil {
		t.Fatal(err)
	}
	for _, tool := range result.Tools {
		if tool.Name == "fs_read_text_file" {
			return
		}
	}
	t.Fatalf("expected registered server tools to include fs_read_text_file")
}
