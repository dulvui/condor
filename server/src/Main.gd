extends Node

const PORT:int = 8000
@onready var server:Server = $Server

func _ready() -> void:
	server.listen(PORT)


func _process(delta: float) -> void:
	pass


func _on_server_client_connected(peer_id:int) -> void:
	print("peer %d connected"%[peer_id])


func _on_server_client_disconnected(peer_id:int) -> void:
	print("peer %d disconnected"%[peer_id])


func _on_server_message_received(peer_id:int, message) -> void:
	print("message received from peer %d : %s"%[peer_id, message])
	server.send_all(peer_id, message)
