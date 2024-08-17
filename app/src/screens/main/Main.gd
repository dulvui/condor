# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

@onready var auction_control: AuctionControl = $MarginContainer/HSplitContainer/VBoxContainer/AuctionControl
@onready var assign_player: PopupPanel = $AssignPlayer
@onready var team_overview: Control = $MarginContainer/HSplitContainer/VBoxContainer/TeamOverview
@onready var player_list: Control = $MarginContainer/HSplitContainer/VSplitContainer/PlayerList
@onready var history: Control = $MarginContainer/HSplitContainer/VSplitContainer/History
@onready var timer: AuctionTimer = $Timer
@onready var server_status: ColorRect = $Status/ServerStatus
@onready var connect_button: Button = $Status/Connect
@onready var connection_lost_alert: AcceptDialog = $ConnectionLost


var active_player:Player

func _ready() -> void:
	active_player = Config.active_player()
	auction_control.set_player(active_player)
	
	Client.connected_to_server.connect(_on_client_connected_to_server)
	Client.connection_closed.connect(_on_client_connection_closed)
	
	Client.timer_toggle.connect(_on_client_timer_toggle)
	Client.auction_start.connect(_on_client_auction_start)
	Client.timer_start.connect(_on_client_timer_start)
	Client.timer_change.connect(_on_client_timer_change)
	Client.timer_pause.connect(_on_client_timer_pause)
	Client.timer_reset.connect(_on_client_timer_reset)
	Client.player_assign.connect(_on_client_player_assign)
	Client.player_remove.connect(_on_client_player_remove)
	Client.player_next.connect(_on_client_player_next)
	Client.player_previous.connect(_on_client_player_previous)
	Client.player_active.connect(_on_client_player_active)
	Client.reset_state.connect(_on_client_reset_state)
	
	if Client.last_state == WebSocketPeer.STATE_OPEN:
		server_status.color = Color.GREEN
		connect_button.visible = false
	else:
		Client.connect_to_server()

	
func _on_auction_control_auction() -> void:
	if Config.is_admin:
		Client.send(Client.auction_start.get_name())
	timer.set_player(active_player)
	timer.show()

func _on_auction_control_assign() -> void:
	assign_player.set_player(active_player)
	assign_player.popup_centered()

func _on_assign_player_assigned() -> void:
	_assign_player()
	if Config.is_admin:
		var latest_transfer = Config.history[-1]
		Client.send(Client.player_assign.get_name() + ":" + str(latest_transfer.player.id) + ":" + str(latest_transfer.team.id) + ":" + str(latest_transfer.price))

func _assign_player() -> void:
	_refresh_lists()
	var latest_transfer = Config.history[-1]
	team_overview.add_player(latest_transfer.player, latest_transfer.team)

func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://src/screens/menu/Menu.tscn")


func _on_auction_control_next() -> void:
	Client.send(Client.player_next.get_name())
	_next_player()
	
func _next_player() -> void:
	active_player = Config.next_player()
	auction_control.set_player(active_player)
	player_list.update()


func _on_auction_control_previous() -> void:
	Client.send(Client.player_previous.get_name())
	_previous_player()
	
func _previous_player() -> void:
	active_player = Config.previous_player()
	auction_control.set_player(active_player)
	player_list.update()

func _on_player_list_active_player_change() -> void:
	active_player = Config.active_player()
	auction_control.set_player(active_player)
	player_list.update()
	Client.send(Client.player_active.get_name() + ":" + str(active_player.id))

func _on_team_overview_player_removed() -> void:
	_refresh_lists()
	
func _refresh_lists() -> void:
	player_list.update()
	history.update()

func _on_timer_toggle() -> void:
	var timestamp:int = Time.get_unix_time_from_system()
	Client.send(Client.timer_start.get_name() + ":" + str(timestamp))


func _on_client_connection_closed() -> void:
	server_status.color = Color.RED
	connect_button.visible = true
	connection_lost_alert.popup_centered()
	

func _on_client_connected_to_server() -> void:
	server_status.color = Color.GREEN
	connect_button.visible = false
	

func _on_connect_pressed() -> void:
	Client.connect_to_server()

func _on_timer_time_changed(time) -> void:
	Client.send(Client.timer_change.get_name() + ":" + str(time))


func _on_timer_paused() -> void:
	Client.send(Client.timer_pause.get_name())

func _on_timer_reseted() -> void:
	Client.send(Client.timer_reset.get_name())


func _on_client_timer_toggle() -> void:
	timer.trigger_toggle()

func _on_client_auction_start() -> void:
	timer.set_player(active_player)
	timer.show()

func _on_client_timer_start(delta:float) -> void:
	timer.trigger_toggle(delta)


func _on_client_timer_change(time:int) -> void:
	timer.set_time(time)

func _on_timer_time_change() -> void:
	Client.send(Client.timer_change.get_name() + ":" + str(Config.active_time))

func _on_client_timer_pause() -> void:
	timer.pause()

func _on_client_timer_reset() -> void:
	timer.restart()

func _on_client_player_assign(player:Player, team:Team, price:int) -> void:
	Config.add_to_history(player, team, price)
	Config.add_player_to_team(team, player, int(price))
	_assign_player()
	team_overview.update_teams_budget()

	
func _on_client_player_remove(player:Player, team:Team) -> void:
	Config.add_to_history(player, team, -player.price)
	history.update()
	Config.remove_player_from_team(player, team)
	team_overview.remove_player(player, team)
	team_overview.update_teams_budget()

func _on_client_player_next() -> void:
	_next_player()

func _on_client_player_previous() -> void:
	_previous_player()

func _on_client_player_active(player_id:int) -> void:
	var player:Player = Config.get_player_by_id(player_id)
	active_player = Config.set_active_player(player)
	auction_control.set_player(player)
	player_list.update()


func _on_client_reset_state() -> void:
	_refresh_lists()
