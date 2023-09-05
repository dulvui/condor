# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node

const PORT:int = 8000
@onready var server:Server = $Client

func _ready() -> void:
	server.listen(PORT)


func _process(delta: float) -> void:
	pass


func _on_client_client_connected(peer_id) -> void:
	print("peer %d connected"%[peer_id])


func _on_client_client_disconnected(peer_id) -> void:
	print("peer %d disconnected"%[peer_id])


func _on_client_message_received(peer_id, message) -> void:
	print("message received from peer %d : %s"%[peer_id, message])
	server.send_all(peer_id, message)
