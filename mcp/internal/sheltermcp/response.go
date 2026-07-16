package sheltermcp

import (
	"encoding/json"
	"fmt"
	"strings"

	"github.com/modelcontextprotocol/go-sdk/mcp"
)

func structuredResult(value any) *mcp.CallToolResult {
	return resultWithError(value, false)
}

func structuredToolError(value any) *mcp.CallToolResult {
	return resultWithError(value, true)
}

func shortStructuredResult(value any, text string, isError bool) *mcp.CallToolResult {
	return &mcp.CallToolResult{
		Content:           []mcp.Content{&mcp.TextContent{Text: text}},
		StructuredContent: value,
		IsError:           isError,
	}
}

func resultWithError(value any, isError bool) *mcp.CallToolResult {
	text := "null"
	if value != nil {
		if data, err := json.MarshalIndent(value, "", "  "); err == nil {
			text = string(data)
		} else {
			text = fmt.Sprintf("%+v", value)
		}
	}
	return &mcp.CallToolResult{
		Content:           []mcp.Content{&mcp.TextContent{Text: text}},
		StructuredContent: value,
		IsError:           isError,
	}
}

func redacted(value string) string {
	if value == "" {
		return ""
	}
	if len(value) <= 8 {
		return "<redacted>"
	}
	return value[:4] + strings.Repeat("*", len(value)-8) + value[len(value)-4:]
}
