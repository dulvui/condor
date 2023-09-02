extends Control

@onready var server:Server = $Server

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_server_client_connected(peer_id) -> void:
	var peer: WebSocketPeer = server.peers[peer_id]
	info("Remote client connected: %d. Protocol: %s" % [peer_id, peer.get_selected_protocol()])
	server.send(-peer_id, "[%d] connected" % peer_id)


func _on_server_client_disconnected(peer_id) -> void:
	var peer: WebSocketPeer = server.peers[peer_id]
	info("Remote client disconnected: %d. Code: %d, Reason: %s" % [peer_id, peer.get_close_code(), peer.get_close_reason()])
	server.send(-peer_id, "[%d] disconnected" % peer_id)



func _on_server_message_received(peer_id, message) -> void:
	info("Server received data from peer %d: %s" % [peer_id, message])
	server.send(-peer_id, "[%d] Says: %s" % [peer_id, message])
