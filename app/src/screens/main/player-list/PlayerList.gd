# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

const PlayerLabel:PackedScene = preload("res://src/ui-components/player-label/PlayerLabel.tscn")

@onready var list:GridContainer = $VBoxContainer/ScrollContainer/GridContainer

var filters:Dictionary = {
	"name" : "",
	"positions" : ""
}

func _ready() -> void:
	set_up_list()
	
func set_up_list():
	for child in list.get_children():
		child.queue_free()
	
	for player in Config.players:
		if _filter(player):
			var player_label = PlayerLabel.instantiate()
			list.add_child(player_label)
			player_label.set_up(player)
			if player.id == Config.active_player().id:
				player_label.set_button_text("<*>")
			else:
				player_label.set_button_text("<>")
				# todo make active player on click
				player_label.action.connect(_set_active_player.bind(player))

func update() -> void:
	for player_label in list.get_children():
		if player_label.player.id == Config.active_player().id:
			player_label.set_button_text("<*>")
		else:
			player_label.set_button_text("<>")

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://src/menu/Menu.tscn")

func _set_active_player(player:Player) -> void:
	Config.set_active_player(player)
	update()

func _on_search_text_changed(new_text: String) -> void:
	filters.name = new_text.to_lower()
	set_up_list()

func _filter(player:Player) -> bool:
	for key in filters.keys():
		if not filters[key].is_empty():
			if not filters[key] in player[key].to_lower():
				return false
	return true
