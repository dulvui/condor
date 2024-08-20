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
signal timer_change(time: int)
signal timer_pause()
signal timer_reset()

signal player_assign(player: Player, team: Team, price: int)
signal player_remove(player: Player, team: Team)
signal player_next()
signal player_previous()
signal player_active(player_id: int)

signal get_teams()

signal reconnect()


#const HOST: String = "ws://localhost:8000/"
const HOST: String = "wss://playground.h11s.org/ws/"
const DATA_DELIMETER: String = ";"
const ID_DELIMETER: String = "|"

@export var handshake_headers: PackedStringArray
@export var supported_protocols: PackedStringArray
var tls_options: TLSOptions = null


var socket: WebSocketPeer = WebSocketPeer.new()
var last_state: int = WebSocketPeer.STATE_CLOSED


func _process(delta):
	poll()


func send(message: String, save_player_message: bool = true) -> int:
	# only save player messages
	if save_player_message and message.contains("player"):
		Config.player_messages.append(message)
	# always put player message id to message start
	message = str(Config.player_messages.size()) + ID_DELIMETER + message
	return socket.send_text(message)
	
	# to send also bytes, not only strings
	#if typeof(message) == TYPE_STRING:
		#return socket.send_text(message)
	#return socket.send(var_to_bytes(message))


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


func _on_client_message_received(message: String) -> void:
	# extract message id
	var message_id: int = -1
	var id_message_parts: Array = message.split(ID_DELIMETER)
	if id_message_parts.size() > 1:
		message_id = int(id_message_parts[0])
	
	# skip replay message, if not necessary 
	if not Config.is_admin and "player" in message  and message_id <= Config.player_messages.size():
		print("skip player message with id " + str(message_id))
		return
	
	# save player messages
	if "player" in message:
		Config.player_messages.append(message)
	
	if message == auction_start.get_name():
		auction_start.emit()
	elif timer_start.get_name() in message:
		var timestamp: int  = int(message.split(DATA_DELIMETER)[1])
		var current_timestamp: int = Time.get_unix_time_from_system()
		var delta:float = current_timestamp - timestamp + 100
		timer_start.emit(delta)
	elif timer_toggle.get_name() in message:
		# todo: add delta also to toggle
		timer_toggle.emit()
	elif timer_change.get_name() in message:
		var time: int = int(message.split(DATA_DELIMETER)[1])
		timer_change.emit(time)
	elif message == timer_pause.get_name():
		timer_pause.emit()
	elif message == timer_reset.get_name() :
		timer_reset.emit()
	elif message == timer_reset.get_name() :
		timer_reset.emit()
	elif player_assign.get_name() in message:
		var player_id: int = int(message.split(DATA_DELIMETER)[1])
		var team_id: int = int(message.split(DATA_DELIMETER)[2])
		var price: int = int(message.split(DATA_DELIMETER)[3])
		var player: Player = Config.get_player_by_id(player_id)
		var team: Team = Config.get_team_by_id(team_id)
		player.price = price
		player_assign.emit(player, team, price)
	elif player_remove.get_name() in message:
		var player_id: int = int(message.split(DATA_DELIMETER)[1])
		var team_id: int = int(message.split(DATA_DELIMETER)[2])
		var player: Player = Config.get_player_by_id(player_id)
		var team: Team = Config.get_team_by_id(team_id)
		player_remove.emit(player, team)
	elif player_next.get_name() in message:
		player_next.emit()
	elif player_previous.get_name() in message:
		player_previous.emit()
	elif player_active.get_name() in message:
		var player_id: int = int(message.split(DATA_DELIMETER)[1])
		player_active.emit(player_id)
	elif reconnect.get_name() in message:
		if Config.is_admin:
			print("ADMIN RECONNECT")
			if message_id < Config.player_messages.size():
				var missing_messages: Array = Config.player_messages.slice(message_id)
				print("replay missing player messages size " + str(missing_messages.size()))
				print("replay messages id " + str(message_id))
				for missing_message in missing_messages:
					Client.send(missing_message, false)
	elif get_teams.get_name() in message:
		if Config.is_admin:
			print("Sending teams...")
			var teams_message: String =  Client.get_teams.get_name()
			for team: Team in Config.teams:
				teams_message += Client.DATA_DELIMETER + team.name
			Client.send(teams_message)
		else:
			print("Receving teams...")
			var team_names: PackedStringArray = message.split(DATA_DELIMETER)
			if team_names.size() > 1:
				team_names.remove_at(0) # remove signal name
				Config.teams = []
				for team_name: String in team_names:
					var team: Team = Team.new()
					print(team_name)
					team.set_up(team_name)
					Config.teams.append(team)
				get_teams.emit()
			else:
				print("No teams...")
	print(message)
