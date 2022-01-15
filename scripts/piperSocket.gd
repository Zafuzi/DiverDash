extends Node

# The URL we will connect to
export var token 			: String = "diverDash_test"
export var websocket_url 	: String = "wss://piper.sleepless.com/" + token
export var authorize_url	: String = "https://piper.sleepless.com/authorize_token:" + token

# Our WebSocketClient instance
var ws = WebSocketClient.new()
var http = HTTPClient.new()
var http_request = HTTPRequest.new()

var peer : WebSocketPeer

onready var globalSendTimer = Timer.new()
var canSend = false

var Dummy = preload("res://nodes/Dummy.tscn")

func _globalSendTimer_timeout():
	canSend = true
	globalSendTimer.stop()

func _ready():
	
	ws.connect("connection_closed", self, "_closed")
	ws.connect("connection_error", self, "_closed")
	ws.connect("connection_established", self, "_connected")
	ws.connect("data_received", self, "_on_data")
	
	globalSendTimer.set_wait_time(0.1)
	globalSendTimer.one_shot = true
	globalSendTimer.connect("timeout", self, "_globalSendTimer_timeout")
	globalSendTimer.autostart = true
	add_child(globalSendTimer)
	add_child(http_request)
	
	_connect_to_server()
		
func _connect_to_server():
	# Create an HTTP request node and connect its completion signal.
	http_request.connect("request_completed", self, "_http_request_completed")
	# Perform a POST request. The URL below returns JSON as of writing.
	var error = http_request.request(authorize_url, ["User-Agent: Glamorious the Wise (Godot)"], true, HTTPClient.METHOD_POST)
	if error != OK:
		push_error("An error occurred in the HTTP request.")

# Called when the HTTP request is completed.
func _http_request_completed(result, response_code, headers, body):
	_connect_to_websocket()

func _connect_to_websocket():
	# Initiate connection to the given URL.
	var err = ws.connect_to_url(websocket_url, [], false)
	if err != OK:
		print("Unable to connect")
		set_process(false)

func _closed(was_clean = false):
	print("Closed, clean: ", was_clean)
	set_process(false)

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
				peer.put_packet(packet)
			else:
				_connect_to_server()
	else:
		pass
		
func _on_data():
	var data :Dictionary = JSON.parse(ws.get_peer(1).get_packet().get_string_from_utf8()).result
	if data.sender_key != data.recipient_key:
		var dummies = get_tree().get_nodes_in_group("dummy")
		
		var dummy_found = false
		var dummy_pos : Vector3 = str2var("Vector3" + data.msg.pos)
		for dummy in dummies:
			if dummy.dummy_id and dummy.dummy_id == data.sender_key:
				print(dummy.dummy_id)
				dummy_found = true
				if dummy.current_pos != dummy_pos:
					dummy.current_pos = dummy_pos
				
		if not dummy_found:
			var d = Dummy.instance()
			d.dummy_id = data.sender_key
			d.current_pos = dummy_pos
			get_tree().get_current_scene().add_child(d)

func _process(delta):
	if ws:
		ws.poll()
