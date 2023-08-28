# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

@onready var auction_control:AuctionControl = $MarginContainer/HSplitContainer/VBoxContainer/AuctionControl
@onready var assign_player:PopupPanel = $AssignPlayer
@onready var team_overview:Control = $MarginContainer/HSplitContainer/VBoxContainer/TeamOverview
@onready var player_list:Control = $MarginContainer/HSplitContainer/VSplitContainer/PlayerList
@onready var history:Control = $MarginContainer/HSplitContainer/VSplitContainer/History
@onready var timer:AuctionTimer = $Timer

var active_player:Player

func _ready() -> void:
	active_player = Config.active_player()
	auction_control.set_player(active_player)

func _on_auction_control_auction() -> void:
	timer.set_player(active_player)
	timer.popup_centered()

func _on_auction_control_assign() -> void:
	assign_player.set_player(active_player)
	assign_player.popup_centered()

func _on_assign_player_assigned() -> void:
	_refresh_lists()
	var latest_transfer = Config.history[-1]
	team_overview.add_player(latest_transfer.player, latest_transfer.team)
	active_player = Config.next_player()
	auction_control.set_player(active_player)


func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://src/screens/menu/Menu.tscn")


func _on_auction_control_next() -> void:
	active_player = Config.next_player()
	auction_control.set_player(active_player)
	player_list.update()


func _on_auction_control_previous() -> void:
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

