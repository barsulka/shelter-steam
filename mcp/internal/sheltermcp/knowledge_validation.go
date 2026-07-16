package sheltermcp

// Knowledge validation is capability-local: each knowledge request builds and
// validates a fresh KnowledgeSourceSnapshot. Server startup has no knowledge
// dependency, so runtime/capture/control registration survives parser failure.
