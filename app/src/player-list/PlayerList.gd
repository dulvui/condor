# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.com>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

@onready var goalkeepers = $TabContainer/POR
@onready var defenders = $TabContainer/DIF
@onready var midfielders = $TabContainer/CEN
@onready var attackers = $TabContainer/ATT


var list_path:String = "res://assets/players/players_05082023.csv"


func _ready() -> void:
	if Config.players.is_empty():
		Config.players = {
			"P" : [], 
			"D" : [],
			"C" : [],
			"A" : [],
		}
		var file:FileAccess = FileAccess.open(list_path, FileAccess.READ)
		_init_players(file)
	
	for player in Config.players["P"]:
		goalkeepers.add_text(player_to_string(player) + "\n")
		
	for player in Config.players["D"]:
		defenders.add_text(player_to_string(player) + "\n")
		
	for player in Config.players["C"]:
		midfielders.add_text(player_to_string(player) + "\n")
		
	for player in Config.players["A"]:
		attackers.add_text(player_to_string(player) + "\n")
	

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
		Config.players[line[1]].append(_get_player(line))
		
func _get_player(line:Array) -> Dictionary:
	return {
		"id" : line[0],
		"position" : line[1],
		"name" : line[2],
		"team" : line[3],
		"mfv" : line[4],
		"price_initial" : line[5],
		"price_current" : line[6],
	}
	
func player_to_string(player:Dictionary) -> String:
	return "%s %s %s"%[player["name"],player["team"],player["price_initial"]]
	

  
func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://src/menu/Menu.tscn")
