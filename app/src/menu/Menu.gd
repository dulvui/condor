# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.com>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://src/main/Main.tscn")

func _on_credits_pressed() -> void:
	pass # Replace with function body.

func _on_teams_pressed() -> void:
	get_tree().change_scene_to_file("res://src/teams/Teams.tscn")


func _on_export_pressed() -> void:
	var timestamp:float = Time.get_unix_time_from_system()
	var file:FileAccess = FileAccess.open("user://players-%d.csv"%timestamp, FileAccess.WRITE)
	
	var content:String = "";
	
	for team in Config.teams:
		var team_line:PackedStringArray = PackedStringArray()
		team_line.append_array(["$", "$", "$"])
		file.store_csv_line(team_line)
		for pos in Config.POSITIONS:
			for player in team.players[pos]:
				var player_line:PackedStringArray = PackedStringArray()
				player_line.append_array([team.name, player.id, player.price])
				file.store_csv_line(player_line)
		
		
