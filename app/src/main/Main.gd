# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.com>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

const AuctionTimer:PackedScene = preload("res://src/timer/Timer.tscn")

@onready var player_list:Control = $PlayerList
@onready var player_label:Label = $ActivePlayer

var current_player:Dictionary

func _ready() -> void:
	current_player = player_list.current_player()
	player_label.text = player_list.player_to_string(current_player)

func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	current_player = player_list.next_player()
	player_label.text = player_list.player_to_string(current_player)



func _on_auction_pressed() -> void:
	var timer = AuctionTimer.instantiate()
	timer.set_player(current_player)
	add_child(timer)
