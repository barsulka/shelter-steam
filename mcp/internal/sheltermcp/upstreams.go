package sheltermcp

import (
	"context"
	"encoding/json"
	"fmt"
	"os"
	"os/exec"
	"strings"
	"time"

	"github.com/modelcontextprotocol/go-sdk/mcp"
)

type UpstreamStatus struct {
	Name      string   `json:"name"`
	Enabled   bool     `json:"enabled"`
	Connected bool     `json:"connected"`
	Prefix    string   `json:"prefix,omitempty"`
	Command   string   `json:"command,omitempty"`
	Args      []string `json:"args,omitempty"`
	ToolCount int      `json:"tool_count,omitempty"`
	ToolNames []string `json:"tool_names,omitempty"`
	Error     string   `json:"error,omitempty"`
}

type ListUpstreamsInput struct{}

type ListUpstreamsOutput struct {
	OK        bool             `json:"ok"`
	Upstreams []UpstreamStatus `json:"upstreams"`
}

func (a *App) ListUpstreams(_ context.Context, _ *mcp.CallToolRequest, _ ListUpstreamsInput) (*mcp.CallToolResult, ListUpstreamsOutput, error) {
	statuses := []UpstreamStatus{{
		Name:    "filesystem",
		Enabled: a.cfg.FilesystemProxyEnabled,
		Prefix:  a.cfg.FilesystemToolPrefix,
		Command: a.cfg.FilesystemCommand,
		Args:    a.cfg.FilesystemRoots,
	}}
	if a.filesystemProxy != nil {
		statuses[0].Connected = true
		statuses[0].ToolCount = len(a.filesystemProxy.tools)
		statuses[0].ToolNames = a.filesystemProxy.proxyToolNames()
	}
	if a.filesystemProxyError != "" {
		statuses[0].Error = a.filesystemProxyError
	}
	out := ListUpstreamsOutput{OK: true, Upstreams: statuses}
	return structuredResult(out), out, nil
}

type ToolProxy struct {
	name        string
	prefix      string
	command     string
	args        []string
	session     *mcp.ClientSession
	tools       map[string]string
	toolDisplay []string
}

func NewFilesystemToolProxy(ctx context.Context, cfg Config) (*ToolProxy, error) {
	if !cfg.FilesystemProxyEnabled {
		return nil, fmt.Errorf("filesystem proxy is disabled")
	}
	if cfg.FilesystemCommand == "" {
		return nil, fmt.Errorf("filesystem command is not configured")
	}
	if len(cfg.FilesystemRoots) == 0 {
		return nil, fmt.Errorf("filesystem roots are not configured")
	}

	cmd := exec.Command(cfg.FilesystemCommand, cfg.FilesystemRoots...)
	cmd.Stderr = os.Stderr

	client := mcp.NewClient(&mcp.Implementation{
		Name:    serverName + "-filesystem-upstream",
		Version: serverVersion,
	}, nil)
	transport := &mcp.CommandTransport{
		Command:           cmd,
		TerminateDuration: 2 * time.Second,
	}
	session, err := client.Connect(ctx, transport, nil)
	if err != nil {
		return nil, err
	}

	proxy := &ToolProxy{
		name:    "filesystem",
		prefix:  cfg.FilesystemToolPrefix,
		command: cfg.FilesystemCommand,
		args:    cfg.FilesystemRoots,
		session: session,
		tools:   map[string]string{},
	}
	if err := proxy.loadTools(ctx); err != nil {
		_ = session.Close()
		return nil, err
	}
	return proxy, nil
}

func (p *ToolProxy) loadTools(ctx context.Context) error {
	var cursor string
	for {
		result, err := p.session.ListTools(ctx, &mcp.ListToolsParams{Cursor: cursor})
		if err != nil {
			return err
		}
		for _, upstreamTool := range result.Tools {
			proxyName := p.prefix + upstreamTool.Name
			p.tools[proxyName] = upstreamTool.Name
			p.toolDisplay = append(p.toolDisplay, proxyName)
		}
		if result.NextCursor == "" {
			break
		}
		cursor = result.NextCursor
	}
	return nil
}

func (p *ToolProxy) Register(server *mcp.Server) error {
	var cursor string
	for {
		result, err := p.session.ListTools(context.Background(), &mcp.ListToolsParams{Cursor: cursor})
		if err != nil {
			return err
		}
		for _, upstreamTool := range result.Tools {
			p.registerTool(server, upstreamTool)
		}
		if result.NextCursor == "" {
			return nil
		}
		cursor = result.NextCursor
	}
}

func (p *ToolProxy) registerTool(server *mcp.Server, upstreamTool *mcp.Tool) {
	upstreamName := upstreamTool.Name
	proxyName := p.prefix + upstreamName
	inputSchema := upstreamTool.InputSchema
	if inputSchema == nil {
		inputSchema = json.RawMessage(`{"type":"object"}`)
	}

	tool := &mcp.Tool{
		Name:         proxyName,
		Title:        proxyTitle(upstreamTool),
		Description:  proxyDescription(p.name, upstreamTool.Description),
		InputSchema:  inputSchema,
		OutputSchema: upstreamTool.OutputSchema,
		Annotations:  upstreamTool.Annotations,
		Icons:        upstreamTool.Icons,
	}

	server.AddTool(tool, func(ctx context.Context, req *mcp.CallToolRequest) (*mcp.CallToolResult, error) {
		args := req.Params.Arguments
		if len(args) == 0 {
			args = json.RawMessage(`{}`)
		}
		result, err := p.session.CallTool(ctx, &mcp.CallToolParams{
			Name:      upstreamName,
			Arguments: args,
		})
		if err != nil {
			return &mcp.CallToolResult{
				Content: []mcp.Content{
					&mcp.TextContent{Text: fmt.Sprintf("upstream %s tool %s failed: %v", p.name, upstreamName, err)},
				},
				IsError: true,
			}, nil
		}
		return result, nil
	})
}

func (p *ToolProxy) proxyToolNames() []string {
	out := append([]string(nil), p.toolDisplay...)
	return out
}

func proxyTitle(tool *mcp.Tool) string {
	title := tool.Title
	if title == "" {
		title = tool.Name
	}
	return "Filesystem: " + title
}

func proxyDescription(upstream, description string) string {
	description = strings.TrimSpace(description)
	if description == "" {
		return "Proxied " + upstream + " MCP tool."
	}
	return "Proxied " + upstream + " MCP tool. " + description
}
