class_name ShelterGodotStateConnector
extends Node

const SCHEMA_VERSION := "shelter.godot_state_connector.v0.2"
const DEFAULT_PORT := 8765
const DEFAULT_BIND_HOST := "127.0.0.1"
const DEFAULT_SNAPSHOT_INTERVAL_SECONDS := 5.0
const DEFAULT_SNAPSHOT_FILE := "res://.runtime/godot_state_connector/state_snapshot.json"

var _snapshot_provider: Callable
var _server := TCPServer.new()
var _clients: Array[Dictionary] = []
var _bind_host := DEFAULT_BIND_HOST
var _port := DEFAULT_PORT
var _http_enabled := true
var _file_enabled := true
var _snapshot_file := DEFAULT_SNAPSHOT_FILE
var _snapshot_interval_seconds := DEFAULT_SNAPSHOT_INTERVAL_SECONDS
var _snapshot_elapsed := 0.0
var _tunnel_mode := false
var _token := ""
var _token_required := false
var _control_enabled := false
var _control_handler: Callable
var _last_snapshot: Dictionary = {}
var _last_snapshot_written_at := ""
var _started := false


func configure(options: Dictionary) -> void:
    _snapshot_provider = options.get("snapshot_provider", Callable())
    _bind_host = str(options.get("bind_host", DEFAULT_BIND_HOST))
    _port = int(options.get("port", DEFAULT_PORT))
    _http_enabled = bool(options.get("http_enabled", true))
    _file_enabled = bool(options.get("file_enabled", true))
    _snapshot_file = str(options.get("snapshot_file", DEFAULT_SNAPSHOT_FILE))
    _snapshot_interval_seconds = maxf(float(options.get("snapshot_interval_seconds", DEFAULT_SNAPSHOT_INTERVAL_SECONDS)), 0.2)
    _tunnel_mode = bool(options.get("tunnel_mode", false))
    _token = str(options.get("token", ""))
    _control_enabled = bool(options.get("control_enabled", false))
    _control_handler = options.get("control_handler", Callable())
    _token_required = _tunnel_mode or _control_enabled or _token != ""

    if _tunnel_mode and _bind_host == DEFAULT_BIND_HOST:
        _bind_host = "0.0.0.0"

    if _token_required and _token == "":
        _token = _generate_ephemeral_token()


func start_connector() -> int:
    if _started:
        return OK

    if _http_enabled:
        var error := _server.listen(_port, _bind_host)
        if error != OK:
            push_error("Godot State Connector could not listen on %s:%d (%s)" % [_bind_host, _port, error])
            return error

    _started = true
    set_process(true)
    _write_snapshot_file()
    _print_start_report()
    return OK


func stop_connector() -> void:
    stop_http_server()
    _started = false
    set_process(false)


func stop_http_server() -> void:
    if _http_enabled:
        _server.stop()
    for client in _clients:
        var peer := client.get("peer", null) as StreamPeerTCP
        if peer != null:
            peer.disconnect_from_host()
    _clients.clear()
    _http_enabled = false


func get_public_status() -> Dictionary:
    return {
        "enabled": _started,
        "schema_version": SCHEMA_VERSION,
        "bind_host": _bind_host,
        "port": _port,
        "http_enabled": _http_enabled,
        "file_enabled": _file_enabled,
        "snapshot_file": _global_snapshot_file_path(),
        "snapshot_interval_seconds": _snapshot_interval_seconds,
        "tunnel_mode": _tunnel_mode,
        "token_required": _token_required,
        "control_enabled": _control_enabled,
        "control": _control_status_payload(),
        "last_snapshot_written_at": _last_snapshot_written_at,
    }


func _process(delta: float) -> void:
    if not _started:
        return

    if _http_enabled:
        _accept_http_clients()
        _poll_http_clients()

    if _file_enabled:
        _snapshot_elapsed += delta
        if _snapshot_elapsed >= _snapshot_interval_seconds:
            _snapshot_elapsed = 0.0
            _write_snapshot_file()


func _notification(what: int) -> void:
    if what == NOTIFICATION_PREDELETE:
        stop_connector()


func _accept_http_clients() -> void:
    while _server.is_connection_available():
        var peer := _server.take_connection()
        if peer == null:
            return
        _clients.append({
            "peer": peer,
            "buffer": "",
        })


func _poll_http_clients() -> void:
    for index in range(_clients.size() - 1, -1, -1):
        var client := _clients[index] as Dictionary
        var peer := client.get("peer", null) as StreamPeerTCP
        if peer == null or peer.get_status() != StreamPeerTCP.STATUS_CONNECTED:
            _clients.remove_at(index)
            continue

        var available := peer.get_available_bytes()
        if available <= 0:
            continue

        client["buffer"] = str(client.get("buffer", "")) + peer.get_utf8_string(available)
        if str(client["buffer"]).find("\r\n\r\n") == -1:
            continue
        if not _http_request_buffer_complete(str(client["buffer"])):
            continue

        _respond_to_http_request(peer, str(client["buffer"]))
        peer.disconnect_from_host()
        _clients.remove_at(index)


func _respond_to_http_request(peer: StreamPeerTCP, raw_request: String) -> void:
    var request := _parse_http_request(raw_request)
    var method := str(request.get("method", ""))
    var path := str(request.get("path", "/"))

    if method == "OPTIONS":
        _send_response(peer, 204, "No Content", "", "text/plain; charset=utf-8")
        return

    if method != "GET" and method != "POST":
        _send_json(peer, 405, {
            "ok": false,
            "error": "method_not_allowed",
        })
        return

    if method == "GET" and (path == "/" or path == "/health"):
        _send_json(peer, 200, _health_payload())
        return

    if method == "POST" and not path.begins_with("/control/"):
        _send_json(peer, 405, {
            "ok": false,
            "error": "method_not_allowed",
            "allowed_methods": ["GET"],
        })
        return

    if _path_requires_token(path) and not _request_has_valid_token(request):
        if _should_mask_auth_failure(path):
            _send_json(peer, 404, {
                "ok": false,
                "error": "not_found",
                "path": path,
            })
            return
        _send_json(peer, 401, _invalid_token_payload())
        return

    if method == "GET":
        if path.begins_with("/control/capture/files/"):
            if not _control_enabled:
                _send_json(peer, 404, {
                    "ok": false,
                    "error": "not_found",
                    "path": path,
                })
                return
            _send_control_capture_file(peer, path)
            return

        match path:
            "/schema":
                _send_json(peer, 200, _schema_payload())
            "/state":
                _send_json(peer, 200, _snapshot())
            "/control":
                if not _control_enabled:
                    _send_json(peer, 404, {
                        "ok": false,
                        "error": "not_found",
                        "path": path,
                    })
                    return
                _send_response(peer, 200, "OK", _control_page_html(), "text/html; charset=utf-8")
            "/control/capabilities":
                if not _control_enabled:
                    _send_json(peer, 404, {
                        "ok": false,
                        "error": "not_found",
                        "path": path,
                    })
                    return
                _send_json(peer, 200, _control_capabilities_payload())
            "/control/capture/video/status":
                if not _control_enabled:
                    _send_json(peer, 404, {
                        "ok": false,
                        "error": "not_found",
                        "path": path,
                    })
                    return
                _send_json(peer, 200, _run_control_command("capture.video.status"))
            "/control/runtime/fixtures":
                if not _control_enabled:
                    _send_json(peer, 404, {
                        "ok": false,
                        "error": "not_found",
                        "path": path,
                    })
                    return
                _send_json(peer, 200, _run_control_command("runtime.fixtures.list"))
            _:
                _send_json(peer, 404, {
                    "ok": false,
                    "error": "not_found",
                    "path": path,
                })
        return

    if path.begins_with("/control") and not _control_enabled:
        _send_json(peer, 404, {
            "ok": false,
            "error": "not_found",
            "path": path,
        })
        return

    match path:
        "/control/ui/hide":
            _send_json(peer, 200, _run_control_command("ui.hide"))
        "/control/ui/show":
            _send_json(peer, 200, _run_control_command("ui.show"))
        "/control/ui/toggle":
            _send_json(peer, 200, _run_control_command("ui.toggle"))
        "/control/connector/http/stop":
            _send_json(peer, 200, _run_control_command("connector.http.stop"))
        "/control/capture/screenshot":
            _send_json(peer, 200, _run_control_command("capture.screenshot"))
        "/control/capture/video/start":
            _send_json(peer, 200, _run_control_command("capture.video.start"))
        "/control/runtime/speed":
            _send_json(peer, 200, _run_control_command("runtime.speed.set", request))
        "/control/runtime/state/export":
            _send_json(peer, 200, _run_control_command("runtime.state.export", request))
        "/control/runtime/state/import":
            _send_json(peer, 200, _run_control_command("runtime.state.import", request))
        "/control/runtime/state/clear":
            _send_json(peer, 200, _run_control_command("runtime.state.clear", request))
        "/control/runtime/save/write":
            _send_json(peer, 200, _run_control_command("runtime.save.write", request))
        "/control/runtime/save/load":
            _send_json(peer, 200, _run_control_command("runtime.save.load", request))
        "/control/runtime/save/erase":
            _send_json(peer, 200, _run_control_command("runtime.save.erase", request))
        "/control/runtime/fixture/load":
            _send_json(peer, 200, _run_control_command("runtime.fixture.load", request))
        "/control/runtime/route/start":
            _send_json(peer, 200, _run_control_command("runtime.route.start", request))
        "/control/runtime/delivery/confirm":
            _send_json(peer, 200, _run_control_command("runtime.delivery.confirm", request))
        "/control/runtime/dog/assign":
            _send_json(peer, 200, _run_control_command("runtime.dog.assign", request))
        "/control/runtime/research/start":
            _send_json(peer, 200, _run_control_command("runtime.research.start", request))
        "/control/runtime/debug/tick":
            _send_json(peer, 200, _run_control_command("runtime.debug.tick", request))
        _:
            _send_json(peer, 404, {
                "ok": false,
                "error": "not_found",
                "path": path,
            })


func _parse_http_request(raw_request: String) -> Dictionary:
    var lines := raw_request.split("\r\n")
    var first_line := "" if lines.is_empty() else lines[0]
    var first_parts := first_line.split(" ")
    var method := first_parts[0] if first_parts.size() > 0 else ""
    var raw_path := first_parts[1] if first_parts.size() > 1 else "/"
    var path := raw_path
    var query := ""
    var query_index := raw_path.find("?")
    if query_index >= 0:
        path = raw_path.substr(0, query_index)
        query = raw_path.substr(query_index + 1)

    var headers: Dictionary = {}
    for i in range(1, lines.size()):
        var line := lines[i]
        if line == "":
            break
        var separator := line.find(":")
        if separator <= 0:
            continue
        var key := line.substr(0, separator).strip_edges().to_lower()
        var value := line.substr(separator + 1).strip_edges()
        headers[key] = value

    return {
        "method": method,
        "path": path,
        "raw_path": raw_path,
        "query": query,
        "headers": headers,
        "body": _request_body(raw_request),
        "json": _request_json_body(_request_body(raw_request)),
    }


func _http_request_buffer_complete(buffer: String) -> bool:
    var header_end := buffer.find("\r\n\r\n")
    if header_end == -1:
        return false

    var header_text := buffer.substr(0, header_end)
    var content_length := 0
    for line in header_text.split("\r\n"):
        var separator := line.find(":")
        if separator <= 0:
            continue
        var key := line.substr(0, separator).strip_edges().to_lower()
        if key == "content-length":
            content_length = maxi(line.substr(separator + 1).strip_edges().to_int(), 0)
            break

    if content_length <= 0:
        return true

    var body := buffer.substr(header_end + 4)
    return body.to_utf8_buffer().size() >= content_length


func _request_body(raw_request: String) -> String:
    var separator := raw_request.find("\r\n\r\n")
    if separator == -1:
        return ""
    return raw_request.substr(separator + 4)


func _request_json_body(body: String) -> Dictionary:
    var clean_body := body.strip_edges()
    if clean_body == "":
        return {}
    var json := JSON.new()
    var error := json.parse(clean_body)
    if error != OK or not (json.data is Dictionary):
        return {
            "_json_error": true,
            "error": "invalid_json_body",
            "message": json.get_error_message(),
            "line": json.get_error_line(),
        }
    return json.data as Dictionary


func _request_has_valid_token(request: Dictionary) -> bool:
    if _token == "":
        return false

    var headers := request.get("headers", {}) as Dictionary
    if str(headers.get("x-shelter-state-token", "")) == _token:
        return true

    var query := str(request.get("query", ""))
    for part in query.split("&", false):
        var separator := part.find("=")
        if separator <= 0:
            continue
        var key := part.substr(0, separator)
        var value := part.substr(separator + 1)
        if key == "token" and value == _token:
            return true

    return false


func _path_requires_token(path: String) -> bool:
    if path == "/" or path == "/health":
        return false
    if path == "/control" or path.begins_with("/control/"):
        return true
    return _token_required


func _should_mask_auth_failure(path: String) -> bool:
    return path == "/control" or path.begins_with("/control/")


func _invalid_token_payload() -> Dictionary:
    return {
        "ok": false,
        "error": "invalid_or_missing_dev_token",
        "token_required": true,
    }


func _send_json(peer: StreamPeerTCP, status_code: int, payload: Dictionary) -> void:
    _send_response(peer, status_code, _status_text(status_code), JSON.stringify(payload, "  "), "application/json; charset=utf-8")


func _send_response(peer: StreamPeerTCP, status_code: int, status_text: String, body: String, content_type: String) -> void:
    _send_bytes(peer, status_code, status_text, body.to_utf8_buffer(), content_type)


func _send_bytes(peer: StreamPeerTCP, status_code: int, status_text: String, body_bytes: PackedByteArray, content_type: String) -> void:
    var header := (
        "HTTP/1.1 %d %s\r\n"
        + "Content-Type: %s\r\n"
        + "Content-Length: %d\r\n"
        + "Cache-Control: no-store\r\n"
        + "Access-Control-Allow-Origin: *\r\n"
        + "Access-Control-Allow-Headers: X-Shelter-State-Token, Content-Type\r\n"
        + "Access-Control-Allow-Methods: GET, POST, OPTIONS\r\n"
        + "Connection: close\r\n"
        + "\r\n"
    ) % [status_code, status_text, content_type, body_bytes.size()]
    var response := header.to_utf8_buffer()
    response.append_array(body_bytes)
    peer.put_data(response)


func _status_text(status_code: int) -> String:
    match status_code:
        200:
            return "OK"
        204:
            return "No Content"
        401:
            return "Unauthorized"
        403:
            return "Forbidden"
        404:
            return "Not Found"
        405:
            return "Method Not Allowed"
        500:
            return "Internal Server Error"
        _:
            return "OK"


func _health_payload() -> Dictionary:
    var public_connector := get_public_status()
    public_connector.erase("control")
    public_connector.erase("control_enabled")
    return {
        "ok": true,
        "connector": public_connector,
        "endpoints": _endpoint_payload(false),
    }


func _schema_payload() -> Dictionary:
    return {
        "ok": true,
        "schema_version": SCHEMA_VERSION,
        "read_only": not _control_enabled,
        "control_enabled": _control_enabled,
        "control": _control_capabilities_payload(),
        "top_level": [
            "schema_version",
            "connector",
            "game",
            "first_day_history",
            "active_order",
            "active_chain",
            "day2",
            "order",
            "dogs",
            "tasks",
            "buildings",
            "rooms",
            "routes",
            "production_chains",
            "house_of_curiosity",
            "economy",
            "resources",
            "production_chain",
            "events",
            "stress_test_signals",
            "debug",
        ],
        "notes": [
            "Godot is the source of truth.",
            "Default connector mode exposes read-only snapshots and does not mutate game state.",
            "Control mode is dev-only, token-protected, and limited to whitelisted view/window commands.",
            "Missing future systems are exported as null, empty arrays, or not_available placeholders.",
        ],
    }


func _endpoint_payload(include_token := true) -> Dictionary:
    var base_url := "http://%s:%d" % [_bind_host, _port]
    var state_url := "%s/state" % base_url
    var schema_url := "%s/schema" % base_url
    if _token_required and include_token:
        state_url = "%s?token=%s" % [state_url, _token]
        schema_url = "%s?token=%s" % [schema_url, _token]
    var endpoints := {
        "health": "%s/health" % base_url,
        "schema": schema_url,
        "state": state_url,
    }
    if _control_enabled:
        var control_url := "%s/control" % base_url
        var capabilities_url := "%s/control/capabilities" % base_url
        if _token_required and include_token:
            control_url = "%s?token=%s" % [control_url, _token]
            capabilities_url = "%s?token=%s" % [capabilities_url, _token]
        endpoints["control"] = control_url
        endpoints["control_capabilities"] = capabilities_url
    return endpoints


func _snapshot() -> Dictionary:
    var payload: Dictionary = {}
    if _snapshot_provider.is_valid():
        var provided: Variant = _snapshot_provider.call()
        if provided is Dictionary:
            payload = (provided as Dictionary).duplicate(true)

    payload["schema_version"] = SCHEMA_VERSION
    payload["connector"] = get_public_status()
    payload["connector"]["timestamp"] = Time.get_datetime_string_from_system(true)
    payload["connector"]["read_only"] = true
    payload["connector"]["endpoints"] = _endpoint_payload()
    _last_snapshot = payload.duplicate(true)
    return payload


func _control_disabled_payload() -> Dictionary:
    return {
        "ok": false,
        "error": "control_disabled",
        "control_enabled": false,
    }


func _control_capabilities_payload() -> Dictionary:
    return {
        "ok": true,
        "enabled": _control_enabled,
        "token_required": _token_required,
        "commands": [
            {
                "id": "ui.hide",
                "method": "POST",
                "path": "/control/ui/hide",
                "description": "Hide the visible Godot game window while keeping the process and connector alive.",
            },
            {
                "id": "ui.show",
                "method": "POST",
                "path": "/control/ui/show",
                "description": "Show the Godot game window again.",
            },
            {
                "id": "ui.toggle",
                "method": "POST",
                "path": "/control/ui/toggle",
                "description": "Toggle the Godot game window visibility.",
            },
            {
                "id": "connector.http.stop",
                "method": "POST",
                "path": "/control/connector/http/stop",
                "description": "Stop the local HTTP connector while leaving the Godot game process running.",
            },
            {
                "id": "capture.screenshot",
                "method": "POST",
                "path": "/control/capture/screenshot",
                "description": "Capture the current Godot viewport to a token-protected PNG file.",
            },
            {
                "id": "capture.video.start",
                "method": "POST",
                "path": "/control/capture/video/start",
                "description": "Start a fixed 10 second viewport frame-sequence capture.",
            },
            {
                "id": "capture.video.status",
                "method": "GET",
                "path": "/control/capture/video/status",
                "description": "Read progress and frame URLs for the current or last frame-sequence capture.",
            },
            {
                "id": "runtime.fixtures.list",
                "method": "GET",
                "path": "/control/runtime/fixtures",
                "description": "List accepted local prototype runtime fixtures.",
            },
            {
                "id": "runtime.fixture.load",
                "method": "POST",
                "path": "/control/runtime/fixture/load",
                "description": "Load a named accepted local prototype fixture.",
            },
            {
                "id": "runtime.speed.set",
                "method": "POST",
                "path": "/control/runtime/speed",
                "description": "Set dev-only runtime speed multiplier to 1, 2, 3, 5, 10, or 100.",
            },
            {
                "id": "runtime.state.export",
                "method": "POST",
                "path": "/control/runtime/state/export",
                "description": "Export current local prototype runtime state as JSON.",
            },
            {
                "id": "runtime.state.import",
                "method": "POST",
                "path": "/control/runtime/state/import",
                "description": "Import local prototype runtime JSON state.",
            },
            {
                "id": "runtime.state.clear",
                "method": "POST",
                "path": "/control/runtime/state/clear",
                "description": "Clear current local prototype runtime state back to default first-day state.",
            },
            {
                "id": "runtime.save.write",
                "method": "POST",
                "path": "/control/runtime/save/write",
                "description": "Write current local prototype runtime state to the dev local save file.",
            },
            {
                "id": "runtime.save.load",
                "method": "POST",
                "path": "/control/runtime/save/load",
                "description": "Load the dev local save file into the running prototype.",
            },
            {
                "id": "runtime.save.erase",
                "method": "POST",
                "path": "/control/runtime/save/erase",
                "description": "Erase the dev local save file.",
            },
            {
                "id": "runtime.route.start",
                "method": "POST",
                "path": "/control/runtime/route/start",
                "description": "Start an accepted test route.",
            },
            {
                "id": "runtime.delivery.confirm",
                "method": "POST",
                "path": "/control/runtime/delivery/confirm",
                "description": "Confirm the accepted first delivery dispatch only when the runtime is waiting at ready_to_dispatch.",
            },
            {
                "id": "runtime.dog.assign",
                "method": "POST",
                "path": "/control/runtime/dog/assign",
                "description": "Assign a dog to an accepted activity or room for design testing.",
            },
            {
                "id": "runtime.research.start",
                "method": "POST",
                "path": "/control/runtime/research/start",
                "description": "Start an accepted House of Curiosity research node.",
            },
            {
                "id": "runtime.debug.tick",
                "method": "POST",
                "path": "/control/runtime/debug/tick",
                "description": "Advance bounded debug simulation time through the accepted debug surface.",
            },
        ] if _control_enabled else [],
        "status": _control_status_payload(),
    }


func _control_status_payload() -> Dictionary:
    var status := {
        "enabled": _control_enabled,
        "handler_available": _control_handler.is_valid(),
    }
    if not _control_enabled or not _control_handler.is_valid():
        return status

    var provided: Variant = _control_handler.call("control.status", {})
    if provided is Dictionary:
        for key in (provided as Dictionary).keys():
            status[key] = (provided as Dictionary)[key]
    return status


func _run_control_command(command: String, request := {}) -> Dictionary:
    if not _control_enabled:
        return _control_disabled_payload()

    if not (command in [
        "ui.hide",
        "ui.show",
        "ui.toggle",
        "connector.http.stop",
        "capture.screenshot",
        "capture.video.start",
        "capture.video.status",
        "runtime.fixtures.list",
        "runtime.fixture.load",
        "runtime.speed.set",
        "runtime.state.export",
        "runtime.state.import",
        "runtime.state.clear",
        "runtime.save.write",
        "runtime.save.load",
        "runtime.save.erase",
        "runtime.route.start",
        "runtime.delivery.confirm",
        "runtime.dog.assign",
        "runtime.research.start",
        "runtime.debug.tick",
    ]):
        return {
            "ok": false,
            "error": "unsupported_control_command",
            "command": command,
        }

    if not _control_handler.is_valid():
        return {
            "ok": false,
            "error": "control_handler_unavailable",
            "command": command,
        }

    var payload := {}
    if request is Dictionary:
        payload = (request as Dictionary).get("json", {}) as Dictionary
        if payload.has("_json_error"):
            return {
                "ok": false,
                "error": "invalid_json_body",
                "details": payload,
                "command": command,
            }

    var result: Variant = _control_handler.call(command, payload)
    if result is Dictionary:
        var response_payload := (result as Dictionary).duplicate(true)
        response_payload["command"] = command
        if not response_payload.has("ok"):
            response_payload["ok"] = true
        _attach_control_capture_urls(response_payload)
        return response_payload

    return {
        "ok": false,
        "error": "invalid_control_handler_response",
        "command": command,
    }


func _send_control_capture_file(peer: StreamPeerTCP, path: String) -> void:
    var file_id := path.replace("/control/capture/files/", "").strip_edges()
    if file_id == "" or file_id.contains("/") or file_id.contains("\\") or file_id.contains(".."):
        _send_json(peer, 404, {
            "ok": false,
            "error": "not_found",
            "path": path,
        })
        return

    if not _control_handler.is_valid():
        _send_json(peer, 404, {
            "ok": false,
            "error": "not_found",
            "path": path,
        })
        return

    var result: Variant = _control_handler.call("capture.file", {"file_id": file_id})
    if not (result is Dictionary) or not bool((result as Dictionary).get("ok", false)):
        _send_json(peer, 404, {
            "ok": false,
            "error": "not_found",
            "path": path,
        })
        return

    var payload := result as Dictionary
    var bytes := payload.get("bytes", PackedByteArray()) as PackedByteArray
    if bytes.is_empty():
        _send_json(peer, 404, {
            "ok": false,
            "error": "not_found",
            "path": path,
        })
        return

    _send_bytes(peer, 200, "OK", bytes, str(payload.get("content_type", "application/octet-stream")))


func _attach_control_capture_urls(payload: Dictionary) -> void:
    if payload.has("file_id"):
        payload["file_url"] = _control_capture_file_url(str(payload.get("file_id", "")))

    if payload.has("frames") and payload["frames"] is Array:
        var frames := payload["frames"] as Array
        for index in range(frames.size()):
            if not (frames[index] is Dictionary):
                continue
            var frame := (frames[index] as Dictionary).duplicate(true)
            if frame.has("file_id"):
                frame["file_url"] = _control_capture_file_url(str(frame.get("file_id", "")))
            frames[index] = frame
        payload["frames"] = frames

    if payload.has("latest_screenshot") and payload["latest_screenshot"] is Dictionary:
        var latest := (payload["latest_screenshot"] as Dictionary).duplicate(true)
        if latest.has("file_id"):
            latest["file_url"] = _control_capture_file_url(str(latest.get("file_id", "")))
        payload["latest_screenshot"] = latest


func _control_capture_file_url(file_id: String) -> String:
    var url := "/control/capture/files/%s" % file_id
    if _token_required and _token != "":
        url = "%s?token=%s" % [url, _token]
    return url


func _control_page_html() -> String:
    var lines: Array[String] = [
        "<!doctype html>",
        "<html lang=\"en\">",
        "<head>",
        "  <meta charset=\"utf-8\">",
        "  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">",
        "  <title>Shelter Godot Control</title>",
        "  <style>",
        "    :root { color-scheme: light dark; font-family: -apple-system, BlinkMacSystemFont, \"Segoe UI\", sans-serif; }",
        "    body { margin: 0; padding: 24px; background: #101412; color: #edf4ec; }",
        "    main { max-width: 760px; margin: 0 auto; }",
        "    h1 { font-size: 22px; margin: 0 0 16px; }",
        "    .panel { border: 1px solid #415047; background: #18201c; border-radius: 8px; padding: 16px; margin: 12px 0; }",
        "    .row { display: flex; gap: 10px; flex-wrap: wrap; align-items: center; }",
        "    button { border: 1px solid #7ea46f; border-radius: 6px; background: #d8efc7; color: #102010; padding: 10px 14px; font-weight: 700; cursor: pointer; }",
        "    button.secondary { background: #26342d; color: #edf4ec; }",
        "    button:disabled { cursor: wait; opacity: 0.62; }",
        "    pre { white-space: pre-wrap; overflow-wrap: anywhere; background: #0b0f0d; border-radius: 6px; padding: 12px; }",
        "    .media { display: grid; gap: 12px; }",
        "    .media img { max-width: 100%; border: 1px solid #415047; border-radius: 6px; background: #0b0f0d; }",
        "    .frames { display: flex; gap: 6px; overflow-x: auto; padding-bottom: 4px; }",
        "    .frames img { width: 180px; flex: 0 0 auto; }",
        "    .muted { color: #aab8ae; }",
        "    .status-line { color: #d8efc7; font-weight: 700; margin: 12px 0 0; }",
        "    .error { color: #ffb3a8; }",
        "  </style>",
        "</head>",
        "<body>",
        "  <main>",
        "    <h1>Shelter Godot Control</h1>",
        "    <section class=\"panel\">",
        "      <div class=\"row\">",
        "        <button class=\"secondary\" data-command=\"/control/ui/toggle\">Toggle</button>",
        "        <button class=\"secondary\" data-command=\"/control/capture/screenshot\">Screenshot</button>",
        "        <button class=\"secondary\" data-command=\"/control/capture/video/start\">Record 10s</button>",
        "        <button class=\"secondary\" id=\"refresh\">Refresh</button>",
        "      </div>",
        "      <p id=\"command-status\" class=\"status-line\">Ready.</p>",
        "      <p class=\"muted\">Dev-only control page. Godot remains the source of truth; this page only sends whitelisted window visibility commands.</p>",
        "    </section>",
        "    <section class=\"panel\">",
        "      <h2>Status</h2>",
        "      <pre id=\"status\">Loading...</pre>",
        "    </section>",
        "    <section class=\"panel\">",
        "      <h2>Last Command</h2>",
        "      <pre id=\"result\">No command sent yet.</pre>",
        "    </section>",
        "    <section class=\"panel\">",
        "      <h2>Capture Preview</h2>",
        "      <div id=\"media\" class=\"media\"><p class=\"muted\">No capture yet.</p></div>",
        "    </section>",
        "  </main>",
        "  <script>",
        "    const token = new URLSearchParams(location.search).get('token') || '';",
        "    const statusEl = document.getElementById('status');",
        "    const resultEl = document.getElementById('result');",
        "    const commandStatusEl = document.getElementById('command-status');",
        "    const mediaEl = document.getElementById('media');",
        "    let animationTimer = 0;",
        "    function withToken(path) {",
        "      const separator = path.includes('?') ? '&' : '?';",
        "      return token ? `${path}${separator}token=${encodeURIComponent(token)}` : path;",
        "    }",
        "    function clearAnimationTimer() {",
        "      if (animationTimer) {",
        "        clearInterval(animationTimer);",
        "        animationTimer = 0;",
        "      }",
        "    }",
        "    function setButtonsDisabled(disabled) {",
        "      document.querySelectorAll('button').forEach((button) => {",
        "        button.disabled = disabled;",
        "      });",
        "    }",
        "    function renderScreenshot(data) {",
        "      clearAnimationTimer();",
        "      if (!data.file_url) return;",
        "      mediaEl.innerHTML = `<img alt=\"Shelter viewport screenshot\" src=\"${data.file_url}\">`;",
        "    }",
        "    function renderFrames(data) {",
        "      clearAnimationTimer();",
        "      const frames = data.frames || [];",
        "      if (!frames.length) {",
        "        mediaEl.innerHTML = '<p class=\"muted\">Recording...</p>';",
        "        return;",
        "      }",
        "      const fps = data.fps || 2;",
        "      const first = frames[0].file_url;",
        "      const strip = frames.map((frame) => `<img alt=\"Frame ${frame.index}\" src=\"${frame.file_url}\">`).join('');",
        "      mediaEl.innerHTML = `<img id=\"animation-preview\" alt=\"Shelter viewport animation\" src=\"${first}\"><div class=\"frames\">${strip}</div>`;",
        "      const preview = document.getElementById('animation-preview');",
        "      let index = 0;",
        "      animationTimer = setInterval(() => {",
        "        index = (index + 1) % frames.length;",
        "        preview.src = frames[index].file_url;",
        "      }, Math.max(120, Math.round(1000 / fps)));",
        "    }",
        "    function renderMedia(data) {",
        "      if (data.capture_type === 'screenshot') renderScreenshot(data);",
        "      if (data.capture_type === 'frame_sequence' && !data.running) renderFrames(data);",
        "    }",
        "    async function pollVideoStatus() {",
        "      try {",
        "        const response = await fetch(withToken('/control/capture/video/status'), { cache: 'no-store' });",
        "        const data = await response.json();",
        "        resultEl.className = response.ok && data.ok ? '' : 'error';",
        "        resultEl.textContent = JSON.stringify(data, null, 2);",
        "        commandStatusEl.className = response.ok && data.ok ? 'status-line' : 'status-line error';",
        "        commandStatusEl.textContent = data.running ? `Recording ${data.frame_count}/${data.target_frames} frames...` : `Recorded ${data.frame_count}/${data.target_frames} frames at ${data.fps} FPS`;",
        "        if (data.running) {",
        "          mediaEl.innerHTML = '<p class=\"muted\">Recording...</p>';",
        "          setTimeout(pollVideoStatus, 750);",
        "        } else {",
        "          renderFrames(data);",
        "        }",
        "      } catch (error) {",
        "        commandStatusEl.className = 'status-line error';",
        "        commandStatusEl.textContent = `Failed: ${error}`;",
        "      }",
        "    }",
        "    async function readState() {",
        "      try {",
        "        const response = await fetch(withToken('/state'), { cache: 'no-store' });",
        "        const data = await response.json();",
        "        statusEl.className = response.ok ? '' : 'error';",
        "        statusEl.textContent = JSON.stringify({",
        "          ok: response.ok,",
        "          schema_version: data.schema_version,",
        "          connector: data.connector,",
        "          game: data.game",
        "        }, null, 2);",
        "      } catch (error) {",
        "        statusEl.className = 'error';",
        "        statusEl.textContent = String(error);",
        "      }",
        "    }",
        "    async function sendCommand(path) {",
        "      commandStatusEl.className = 'status-line';",
        "      commandStatusEl.textContent = `Sending ${path}...`;",
        "      resultEl.textContent = 'Sending...';",
        "      setButtonsDisabled(true);",
        "      try {",
        "        const response = await fetch(withToken(path), {",
        "          method: 'POST',",
        "          headers: token ? { 'X-Shelter-State-Token': token } : {}",
        "        });",
        "        const data = await response.json();",
        "        const successful = response.ok && data.ok;",
        "        commandStatusEl.className = successful ? 'status-line' : 'status-line error';",
        "        if (successful && data.capture_type === 'screenshot') {",
        "          commandStatusEl.textContent = `Captured screenshot ${data.width}x${data.height}`;",
        "        } else if (successful && data.capture_type === 'frame_sequence') {",
        "          commandStatusEl.textContent = `Recording ${data.duration_seconds}s at ${data.fps} FPS...`;",
        "        } else {",
        "          const visibleLabel = data.window_visible === undefined ? 'unknown' : String(data.window_visible);",
        "          commandStatusEl.textContent = successful ? `Done: ${data.command || path}; window_visible=${visibleLabel}` : `Failed: ${data.error || response.status}`;",
        "        }",
        "        resultEl.className = successful ? '' : 'error';",
        "        resultEl.textContent = JSON.stringify(data, null, 2);",
        "        renderMedia(data);",
        "        if (successful && data.capture_type === 'frame_sequence') pollVideoStatus();",
        "        await readState();",
        "      } catch (error) {",
        "        commandStatusEl.className = 'status-line error';",
        "        commandStatusEl.textContent = `Failed: ${error}`;",
        "        resultEl.className = 'error';",
        "        resultEl.textContent = String(error);",
        "      } finally {",
        "        setButtonsDisabled(false);",
        "      }",
        "    }",
        "    document.querySelectorAll('button[data-command]').forEach((button) => {",
        "      button.addEventListener('click', () => sendCommand(button.dataset.command));",
        "    });",
        "    document.getElementById('refresh').addEventListener('click', readState);",
        "    readState();",
        "    setInterval(readState, 5000);",
        "  </script>",
        "</body>",
        "</html>",
    ]
    return "\n".join(lines)


func _write_snapshot_file() -> void:
    if not _file_enabled:
        return

    var path := _global_snapshot_file_path()
    var dir := path.get_base_dir()
    var dir_error := DirAccess.make_dir_recursive_absolute(dir)
    if dir_error != OK:
        push_warning("Godot State Connector could not create snapshot directory %s (%s)" % [dir, dir_error])
        return

    var file := FileAccess.open(path, FileAccess.WRITE)
    if file == null:
        push_warning("Godot State Connector could not write snapshot file: %s" % path)
        return

    file.store_string(JSON.stringify(_snapshot(), "  ") + "\n")
    file.close()
    _last_snapshot_written_at = Time.get_datetime_string_from_system(true)


func _global_snapshot_file_path() -> String:
    if _snapshot_file.begins_with("res://") or _snapshot_file.begins_with("user://"):
        return ProjectSettings.globalize_path(_snapshot_file)
    return ProjectSettings.globalize_path("res://%s" % _snapshot_file)


func _print_start_report() -> void:
    print("godot_state_connector_enabled=true")
    print("godot_state_connector_schema=%s" % SCHEMA_VERSION)
    if _http_enabled:
        print("godot_state_connector_health=http://%s:%d/health" % [_bind_host, _port])
        print("godot_state_connector_state=%s" % str(_endpoint_payload()["state"]))
        if _control_enabled:
            print("godot_state_connector_control=%s" % str(_endpoint_payload()["control"]))
    if _file_enabled:
        print("godot_state_connector_snapshot_file=%s" % _global_snapshot_file_path())
    if _token_required:
        print("godot_state_connector_token=%s" % _token)


func _generate_ephemeral_token() -> String:
    var rng := RandomNumberGenerator.new()
    rng.randomize()
    return "%08x%08x%08x" % [
        rng.randi(),
        Time.get_ticks_usec() & 0xffffffff,
        OS.get_process_id() & 0xffffffff,
    ]
