extends Node

# The URL we will connect to
export var level	: String = "test"
var token 			: String = "diverDash_" + level
var websocket_url 	: String = "wss://piper.sleepless.com/" + token
var authorize_url	: String = "https://piper.sleepless.com/v1.2.0/authorize_token:" + token

# Our WebSocketClient instance
var ws = WebSocketClient.new()
var http = HTTPClient.new()
var http_request = HTTPRequest.new()

var peer : WebSocketPeer

onready var globalSendTimer = Timer.new()
var canSend = false

onready var dummySpawner = $dummySpawner

func _globalSendTimer_timeout():
	canSend = true
	globalSendTimer.stop()

func _ready():
	ws.connect("connection_closed", self, "_closed")
	ws.connect("connection_error", self, "_closed")
	ws.connect("connection_established", self, "_connected")
	ws.connect("data_received", self, "_on_data")
	
	# Create an HTTP request node and connect its completion signal.
	http_request.connect("request_completed", self, "_http_request_completed")
	
	globalSendTimer.set_wait_time(0.1)
	globalSendTimer.one_shot = true
	globalSendTimer.connect("timeout", self, "_globalSendTimer_timeout")
	globalSendTimer.autostart = true
	add_child(globalSendTimer)
	add_child(http_request)
	
	_connect_to_server()
		
func _connect_to_server():
	# Perform a POST request. The URL below returns JSON as of writing.
	var error = http_request.request(authorize_url, ["User-Agent: Glamorious the Wise (Godot)"], true, HTTPClient.METHOD_POST)
	if error != OK:
		push_error("An error occurred in the HTTP request.")

# Called when the HTTP request is completed.
# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _http_request_completed(result, response_code, headers, body):
	if response_code == 200:
		_connect_to_websocket()
	else:
		push_error("HTTP ERROR: " + str(response_code))

var FATAL_ERROR = false
func _connect_to_websocket():
	# Initiate connection to the given URL.
	var err = ws.connect_to_url(websocket_url, [], false)
	if err != OK:
		FATAL_ERROR = err
		print("Unable to connect")
		set_process(false)

func _closed(was_clean = false):
	print("Closed, clean: ", was_clean)
	set_process(false)

# warning-ignore:unused_argument
func _connected(proto = ""):
	peer = ws.get_peer(1)
	peer.set_write_mode(WebSocketPeer.WRITE_MODE_TEXT)
	
func _send(msg):
	if peer:
		if canSend:
			canSend = false
			globalSendTimer.start()
			
			if peer.is_connected_to_host():
				var packet: PoolByteArray = JSON.print(msg).to_utf8()
# warning-ignore:return_value_discarded
				peer.put_packet(packet)
			else:
				if not FATAL_ERROR:
					_connect_to_server()
	else:
		pass
		
func _send_now(msg):
	if peer:
		if peer.is_connected_to_host():
			var packet: PoolByteArray = JSON.print(msg).to_utf8()
# warning-ignore:return_value_discarded
			peer.put_packet(packet)
		else:
			if not FATAL_ERROR:
				_connect_to_server()
	else:
		pass
		
func _on_data():
	var data :Dictionary = JSON.parse(ws.get_peer(1).get_packet().get_string_from_utf8()).result
	if data.sender_key != data.recipient_key:
		var dummies = get_tree().get_nodes_in_group("dummy")
		
		var dummy_found = false
		var dummy_pos : Vector2 = str2var("Vector2" + data.msg.pos)
		var dummy_rot : float = data.msg.rot
		
		for dummy in dummies:
			if dummy.dummy_id and (dummy.dummy_id == data.sender_key or dummy.data_id == data.msg.id):
				dummy_found = true
				
				if "dead" in data.msg.values():
					dummy.emit_signal("die")
					
				dummy.current_rot = dummy_rot
				dummy.current_pos = dummy_pos
				
		if not dummy_found:
			if data.msg.level == G.game_data.current_level:
				# next update send my color with pos and rotation
				dummySpawner.emit_signal("spawnDummy", data)

# warning-ignore:unused_argument
func _process(delta):
	if ws:
		ws.poll()
