# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.com>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

const AuctionTimer:PackedScene = preload("res://src/timer/Timer.tscn")

@onready var player_label:Label = $MarginContainer/HSplitContainer/VBoxContainer/ActivePlayer
@onready var assign_player:PopupPanel = $AssignPlayer
@onready var team_overview:Control = $MarginContainer/HSplitContainer/VBoxContainer/TeamOverview
@onready var player_list:Control = $MarginContainer/HSplitContainer/VSplitContainer/PlayerList
@onready var history:Control = $MarginContainer/HSplitContainer/VSplitContainer/History


var active_player:Dictionary

func _ready() -> void:
	active_player = player_list.current_player()
	player_label.text = player_list.player_to_string(active_player)

func _next_player():
	active_player = player_list.next_player()
	player_label.text = player_list.player_to_string(active_player)

func _on_button_pressed() -> void:
	_next_player()
	player_list.set_up_list()


func _on_auction_pressed() -> void:
	var timer = AuctionTimer.instantiate()
	timer.set_player(active_player)
	add_child(timer)


func _on_assign_pressed() -> void:
	assign_player.set_player(active_player)
	assign_player.popup_centered()

func _on_assign_player_assigned() -> void:
	team_overview.set_up()
	player_list.set_up()
	history.set_up()
	active_player = player_list.current_player()
	player_label.text = player_list.player_to_string(active_player)
	



func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://src/menu/Menu.tscn")
