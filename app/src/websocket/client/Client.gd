# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node

# client signals
signal connected_to_server()
signal connection_closed()
#signal message_received(message: Variant)

# gameplay signals
signal timer_toggle()
signal auction_start()
signal timer_start(delta:float)
signal timer_change(time:int)
signal timer_pause()
signal timer_reset()
signal player_assign(player:Player, team:Team, price:int)
signal player_remove(player:Player, team:Team)
signal player_next()
signal player_previous()
signal player_active(player_id:int)

signal reset_state


#const HOST:String = "ws://localhost:8000/"
const HOST:String = "ws://sandbox.s9i.org:8000/"


@export var handshake_headers: PackedStringArray
@export var supported_protocols: PackedStringArray
var tls_options: TLSOptions = null


var socket = WebSocketPeer.new()
var last_state = WebSocketPeer.STATE_CLOSED

func _process(delta):
	poll()

func send(message) -> int:
	if typeof(message) == TYPE_STRING:
		return socket.send_text(message)
	return socket.send(var_to_bytes(message))


func get_message() -> Variant:
	if socket.get_available_packet_count() < 1:
		return null
	var pkt = socket.get_packet()
	if socket.was_string_packet():
		return pkt.get_string_from_utf8()
	return bytes_to_var(pkt)

func connect_to_server() -> int:
	socket.supported_protocols = supported_protocols
	socket.handshake_headers = handshake_headers
	var err = socket.connect_to_url(HOST, tls_options)
	if err != OK:
		return err
	last_state = socket.get_ready_state()
	return OK

func close(code := 1000, reason := "") -> void:
	socket.close(code, reason)
	last_state = socket.get_ready_state()


func clear() -> void:
	socket = WebSocketPeer.new()
	last_state = socket.get_ready_state()


func get_socket() -> WebSocketPeer:
	return socket


func poll() -> void:
	if socket.get_ready_state() != socket.STATE_CLOSED:
		socket.poll()
	var state = socket.get_ready_state()
	if last_state != state:
		last_state = state
		if state == socket.STATE_OPEN:
			connected_to_server.emit()
		elif state == socket.STATE_CLOSED:
			connection_closed.emit()
	while socket.get_ready_state() == socket.STATE_OPEN and socket.get_available_packet_count():
		_on_client_message_received(get_message())
#		message_received.emit(get_message())

func _on_client_message_received(message:String) -> void:
	if message == auction_start.get_name():
		auction_start.emit()
	elif timer_start.get_name() in message:
		var timestamp:int  = int(message.split(":")[1])
		var current_timestamp:int = Time.get_unix_time_from_system()
		var delta:float = current_timestamp - timestamp + 100
		timer_start.emit(delta)
	elif timer_toggle.get_name() in message:
		# todo: add delta also to toggle
		timer_toggle.emit()
	elif timer_change.get_name() in message:
		var time:int = int(message.split(":")[1])
		timer_change.emit(time)
	elif message == timer_pause.get_name():
		timer_pause.emit()
	elif message == timer_reset.get_name() :
		timer_reset.emit()
	elif message == timer_reset.get_name() :
		timer_reset.emit()
	elif player_assign.get_name() in message:
		var player_id:int = int(message.split(":")[1])
		var team_id:int = int(message.split(":")[2])
		var price:int = int(message.split(":")[3])

		var player:Player = Config.get_player_by_id(player_id)
		var team:Team = Config.get_team_by_id(team_id)
		player.price = price
		player_assign.emit(player, team, price)
	elif player_remove.get_name() in message:
		var player_id:int = int(message.split(":")[1])
		var team_id:int = int(message.split(":")[2])

		var player:Player = Config.get_player_by_id(player_id)
		var team:Team = Config.get_team_by_id(team_id)
		
		player_remove.emit(player, team)
	elif message == player_next.get_name():
		player_next.emit()
	elif message == player_previous.get_name():
		player_previous.emit()
	elif player_active.get_name() in message:
		var player_id:int = int(message.split(":")[1])
		player_active.emit(player_id)
#	elif reset_state.get_name() in message:
#		if Config.is_admin:
#			var data:Dictionary = {}
#			data.players = JSON.stringify(Config.players)
#			data.teams = JSON.stringify(str(Config.teams))
#			data.history = JSON.stringify(Config.history)
#			data.active_player_index = Config.active_player_index
#			data.active_time = Config.active_time
#			send(reset_state.get_name() + ":" + JSON.stringify(data))
#		else:
#			var data:Dictionary = JSON.parse_string(message.split(":")[1])
#
#			var players:Array = data.players
#			var teams:Array = data.teams
#			var history:Array = data.history
#			var active_player_index:int = data.active_player_index
#			var active_time:int = data.active_time
#
#			Config.reset_state(teams, players,history, active_player_index, active_time)
#			reset_state.emit()
	print(message)
