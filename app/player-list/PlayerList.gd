# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.com>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

var list_path:String
var players:Dictionary = {
	"P" : [],
	"D" : [],
	"C" : [],
	"A" : [],
}

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass


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
		players[line[1]].append(_get_player(line))
	
	print(players)
		
func _get_player(line:Array) -> Dictionary:
#	print(line)
	return {
		"id" : line[0],
		"name" : line[2],
		"team" : line[3],
		"mfv" : line[4],
		"price_initial" : line[5],
		"price_current" : line[6],
	}
	
