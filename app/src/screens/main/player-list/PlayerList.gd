# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.com>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

const PlayerLabel:PackedScene = preload("res://src/ui-components/player-label/PlayerLabel.tscn")

@onready var list:GridContainer = $VBoxContainer/ScrollContainer/GridContainer

var list_path:String = "res://assets/players/players_05082023.list"

var filters:Dictionary = {
	"name" : "",
	"positions" : ""
}

func _ready() -> void:
	if Config.players.is_empty():
		for pos in Config.POSITIONS:
			Config.players[pos] = []
			
		var file:FileAccess = FileAccess.open(list_path, FileAccess.READ)
		_init_players(file)
	set_up_list()
	
func set_up_list():
	for child in list.get_children():
		child.queue_free()
	
	for pos in Config.POSITIONS:
		for player in Config.players[pos]:
			if _filter(player):
				var player_label = PlayerLabel.instantiate()
				list.add_child(player_label)
				player_label.set_up(player)
				if player.id == current_player().id:
					player_label.set_button_text("<*>")
				else:
					player_label.set_button_text("<>")
#				player_box.player_removed.connect(func(): _on_player_removed(player, team.id))
				

func current_player() -> Dictionary:
	return Config.players[Config.POSITIONS[Config.active_position]][Config.active_player]

func next_player() -> Dictionary:
	if Config.active_player + 1 < Config.players[Config.POSITIONS[Config.active_position]].size():
		Config.active_player += 1
		return current_player()
	elif Config.active_position + 1  < Config.POSITIONS.size():
		Config.active_position += 1
		Config.active_player = 0
	return current_player() 
	
func previous_player() -> Dictionary:
	if Config.active_player -1 >= 0:
		Config.active_player -= 1
		return current_player()
	elif Config.active_position - 1  >= 0:
		Config.active_position -= 1
		Config.active_player = Config.players[Config.POSITIONS[Config.active_position]].size() - 1
	return current_player() 
	
func _on_file_dialog_file_selected(path: String) -> void:
	list_path = path


func _on_file_dialog_confirmed() -> void:
	var file:FileAccess = FileAccess.open(list_path, FileAccess.READ)
	_init_players(file)
	
func _init_players(file:FileAccess):
	# skip header lines
	while not file.eof_reached():
		var line:Array = file.get_csv_line()
		if line[0] == "Id":
			break
	
	while not file.eof_reached():
		var line:Array = file.get_csv_line()
		# check if not empty
		if not line[0]:
			break
		var pos = line[1]
		Config.players[pos].append(_get_player(line))
	
	for pos in Config.POSITIONS:
		Config.players[pos].sort_custom(func(a, b): return a.name < b.name)
		
func _get_player(line:Array) -> Dictionary:
	return {
		"id" : line[0],
		"position" : line[1],
		"name" : line[2],
		"team" : line[3],
		"mfv" : line[4],
		"price_initial" : line[5],
		"price_current" : line[6],
		"price" : 0,
	}

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://src/menu/Menu.tscn")


func _on_search_text_changed(new_text: String) -> void:
	filters.name = new_text.to_lower()
	set_up_list()

func _filter(player:Dictionary) -> bool:
	for key in filters.keys():
		if not filters[key].is_empty():
			if not filters[key] in player[key].to_lower():
				return false
	return true
