# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

@onready var server:Server = $Server
@onready var client:Client = $Client

@onready var log_dest = $RichTextLabel
@onready var line_edit = $Panel/VBoxContainer/Send/LineEdit

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass

func info(msg):
	print(msg)
	log_dest.add_text(str(msg) + "\n")

func _on_client_connected_to_server() -> void:
	pass # Replace with function body.


func _on_client_connection_closed() -> void:
	pass # Replace with function body.


func _on_client_message_received(message) -> void:
	pass # Replace with function body.


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


func _on_listen_toggled(button_pressed: bool) -> void:
	if not button_pressed:
		server.stop()
		info("Server stopped")
		return
	var port = int(8000)
	var err = server.listen(port)
	if err != OK:
		info("Error listing on port %s" % port)
		return
	info("Listing on port %s, supported protocols: %s" % [port, server.supported_protocols])


func _on_connect_toggled(button_pressed: bool) -> void:
	var host = Label.new()
	host.text = "ws://localhost:8000/test/"
	if not button_pressed:
		client.close()
		return
	if host.text == "":
		return
	info("Connecting to host: %s." % [host.text])
	var err = client.connect_to_url(host.text)
	if err != OK:
		info("Error connecting to host: %s" % [host.text])
		return
