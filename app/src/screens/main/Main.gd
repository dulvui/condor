# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

@onready var auction_control:AuctionControl = $MarginContainer/HSplitContainer/VBoxContainer/AuctionControl
@onready var assign_player:PopupPanel = $AssignPlayer
@onready var team_overview:Control = $MarginContainer/HSplitContainer/VBoxContainer/TeamOverview
@onready var player_list:Control = $MarginContainer/HSplitContainer/VSplitContainer/PlayerList
@onready var history:Control = $MarginContainer/HSplitContainer/VSplitContainer/History
@onready var timer:AuctionTimer = $Timer
@onready var client:Client = $Client
@onready var server_status:ColorRect = $Status/ServerStatus
@onready var connect_button:Button = $Status/Connect

var active_player:Player

func _ready() -> void:
	active_player = Config.active_player()
	auction_control.set_player(active_player)
	
	client.connect_to_server()

func _on_auction_control_auction() -> void:
	if Config.is_admin:
		client.send("start_auction")
	timer.set_player(active_player)
	timer.popup_centered()

func _on_auction_control_assign() -> void:
	assign_player.set_player(active_player)
	assign_player.popup_centered()

func _on_assign_player_assigned() -> void:
	_assign_player()
	if Config.is_admin:
		var latest_transfer = Config.history[-1]
		client.send("assign_player:" + str(latest_transfer.player.id) + ":" + str(latest_transfer.team.id) + ":" + str(latest_transfer.price))

func _assign_player() -> void:
	_refresh_lists()
	var latest_transfer = Config.history[-1]
	team_overview.add_player(latest_transfer.player, latest_transfer.team)
	active_player = Config.next_player()
	auction_control.set_player(active_player)

func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://src/screens/menu/Menu.tscn")


func _on_auction_control_next() -> void:
	client.send("next_player")
	_next_player()
	
func _next_player() -> void:
	active_player = Config.next_player()
	auction_control.set_player(active_player)
	player_list.update()


func _on_auction_control_previous() -> void:
	client.send("previous_player")
	_previous_player()
	
func _previous_player() -> void:
	active_player = Config.previous_player()
	auction_control.set_player(active_player)
	player_list.update()

func _on_player_list_active_player_change() -> void:
	active_player = Config.active_player()
	auction_control.set_player(active_player)
	player_list.update()

func _on_team_overview_player_removed() -> void:
	_refresh_lists()
	
func _refresh_lists() -> void:
	player_list.update()
	history.update()

func _on_client_message_received(message:String) -> void:
	if message == "start_auction":
		timer.set_player(active_player)
		timer.popup_centered()
	elif "start_timer" in message:
		var timestamp:int  = int(message.split(":")[1])
		var current_timestamp:int = Time.get_unix_time_from_system()
		timer.trigger_toggle(current_timestamp - timestamp + 100)
	elif "assign_player" in message:
		var player_id:int = int(message.split(":")[1])
		var team_id:int = int(message.split(":")[2])
		var price:int = int(message.split(":")[3])
		
		var player:Player = Config.get_player_by_id(player_id)
		var team:Team = Config.get_team_by_id(team_id)
		player.price = price
		Config.add_to_history(player, team, price)
		_assign_player()
	elif message == "next_player":
		_next_player()
	elif message == "previous_player":
		_previous_player()


func _on_timer_toggle() -> void:
	var timestamp:int = Time.get_unix_time_from_system()
	client.send("start_timer:" + str(timestamp))


func _on_client_connection_closed() -> void:
	server_status.color = Color.RED
	connect_button.visible = true
	

func _on_client_connected_to_server() -> void:
	server_status.color = Color.GREEN
	connect_button.visible = false

func _on_connect_pressed() -> void:
	client.connect_to_server()
