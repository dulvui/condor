# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.com>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

const PlayerLabel:PackedScene = preload("res://src/ui-components/player-label/PlayerLabel.tscn")

@onready var list:GridContainer = $VBoxContainer/ScrollContainer/GridContainer

var filters:Dictionary = {
	"name" : "",
	"positions" : ""
}

var active_player:Player

func _ready() -> void:
	set_up_list()
	
func set_up_list():
	for child in list.get_children():
		child.queue_free()
	
	active_player = Config.players[0]
	
	for player in Config.players:
		if _filter(player):
			var player_label = PlayerLabel.instantiate()
			list.add_child(player_label)
			player_label.set_up(player)
			if player.id == active_player.id:
				player_label.set_button_text("<*>")
			else:
				player_label.set_button_text("<>")
#				player_box.player_removed.connect(func(): _on_player_removed(player, team.id))
				

func current_player() -> Player:
	return active_player

func next_player() -> Player:
#	if Config.active_player + 1 < Config.players[Config.POSITIONS[Config.active_position]].size():
#		Config.active_player += 1
#		return current_player()
#	elif Config.active_position + 1  < Config.POSITIONS.size():
#		Config.active_position += 1
#		Config.active_player = 0
	return active_player
	
func previous_player() -> Player:
#	if Config.active_player -1 >= 0:
#		Config.active_player -= 1
#		return current_player()
#	elif Config.active_position - 1  >= 0:
#		Config.active_position -= 1
#		Config.active_player = Config.players[Config.POSITIONS[Config.active_position]].size() - 1
	return active_player
	

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://src/menu/Menu.tscn")


func _on_search_text_changed(new_text: String) -> void:
	filters.name = new_text.to_lower()
	set_up_list()

func _filter(player:Player) -> bool:
	for key in filters.keys():
		if not filters[key].is_empty():
			if not filters[key] in player[key].to_lower():
				return false
	return true
