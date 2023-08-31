# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node

const PORT = 8999
const PROTOCOL = "ludus"
const HOST = "localhost"

var lobbies:Array

var peer:WebSocketMultiplayerPeer = WebSocketMultiplayerPeer.new()

func _init():
	peer.supported_protocols = ["ludus"]

func _ready():
	multiplayer.peer_connected.connect(self._peer_connected)
	multiplayer.peer_disconnected.connect(self._peer_disconnected)
	multiplayer.server_disconnected.connect(self._close_network)
	multiplayer.connection_failed.connect(self._close_network)
	multiplayer.connected_to_server.connect(self._connected)


func start():
	pass


func stop():
	pass


func _close_network():
	multiplayer.multiplayer_peer = null
	peer.close()


func _connected():
	print("connected")


func _peer_connected(id):
	print("Peer connected %d" % id)


func _peer_disconnected(id):
	print("Peer disconnected %d" % id)


func _on_Host_pressed():
	multiplayer.multiplayer_peer = null
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer


func _on_Disconnect_pressed():
	_close_network()


func _on_Connect_pressed():
	multiplayer.multiplayer_peer = null
	peer.create_client("ws://" + HOST + ":" + str(PORT))
	multiplayer.multiplayer_peer = peer
