extends Node

@export var server_url: String = "http://localhost:5000/ai_npc"

func trigger_event(event_name: String, event_data: Dictionary):
	# Send to AI server asynchronously
	await send_event_to_server(event_name, event_data)

func send_event_to_server(event_name: String, event_data: Dictionary) -> void:
	var payload = {
		"npc_id": get_parent().name,
		"event": event_name,
		"data": event_data
	}

	var http = HTTPRequest.new()
	add_child(http)

	var err = http.request(
		server_url,
		[],
		HTTPClient.METHOD_POST,
		JSON.stringify(payload)
	)
	if err != OK:
		push_error("HTTP request failed")
		return

	http.request_completed.connect(_on_response)
	
func _on_response(result, response_code, headers, body):
	if response_code != 200:
		print("AI server error:", response_code)
		return

	var json = JSON.parse_string(body.get_string_from_utf8())
	if json is Dictionary:
		process_ai_response(json)

func process_ai_response(response: Dictionary):
	match response.get("action"):
		"speak":
			get_parent().dialogue_component.say(response.get("text"))
		"move_to":
			get_parent().move_to_position(response.get("target_position"))
		"emote":
			get_parent().play_animation(response.get("animation"))
		_:
			print("Unknown action:", response)
