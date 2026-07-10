package main

import (
	"context"
	"flag"
	"log"
	"net/http"
	"os"

	"github.com/modelcontextprotocol/go-sdk/mcp"

	"shelter-mcp/internal/sheltermcp"
)

func main() {
	var httpAddr string
	var steamRoot string

	flag.StringVar(&httpAddr, "http", "", "serve MCP over streamable HTTP instead of stdio, for example 127.0.0.1:8090")
	flag.StringVar(&steamRoot, "steam-root", "", "path to the Shelter Steam project; defaults to SHELTER_STEAM_ROOT or the local monorepo path")
	flag.Parse()

	cfg, err := sheltermcp.NewConfig(steamRoot)
	if err != nil {
		log.Fatal(err)
	}

	server := sheltermcp.NewServer(cfg)
	ctx := context.Background()

	if httpAddr != "" {
		handler := mcp.NewStreamableHTTPHandler(func(*http.Request) *mcp.Server {
			return server
		}, nil)
		log.Printf("shelter-mcp listening at http://%s", httpAddr)
		log.Fatal(http.ListenAndServe(httpAddr, handler))
	}

	transport := &mcp.LoggingTransport{
		Transport: &mcp.StdioTransport{},
		Writer:    os.Stderr,
	}
	if err := server.Run(ctx, transport); err != nil {
		log.Fatal(err)
	}
}
