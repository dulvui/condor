# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

func _ready() -> void:
	$VBoxContainer/Teams.visible = Config.is_admin
	$AdminActive.visible = Config.is_admin
	

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://src/screens/teams/teams.tscn")

func _on_credits_pressed() -> void:
	pass # Replace with function body.

func _on_teams_pressed() -> void:
	get_tree().change_scene_to_file("res://src/screens/teams/teams.tscn")


func _on_export_pressed() -> void:
	var timestamp:float = Time.get_unix_time_from_system()
	var file:FileAccess = FileAccess.open("user://players-%d.csv"%timestamp, FileAccess.WRITE)
	
	var content:String = "";
	
	var export_teams:Dictionary = {}
	for team in Config.teams:
		export_teams[team.id] = {
			"name": team.name,
			"players": [],
		}
	
	for player in Config.players:
		if player.team_id >= 0:
			export_teams[player.team_id].players.append(player)
	
	for team in export_teams.values():
		var team_line:PackedStringArray = PackedStringArray()
		team_line.append_array(["$", "$", "$"])
		file.store_csv_line(team_line)
		for player in team.players:
			var player_line:PackedStringArray = PackedStringArray()
			player_line.append_array([team.name, player.id, player.price])
			file.store_csv_line(player_line)


func _on_admin_pressed() -> void:
	Config.is_admin = not Config.is_admin 
	$VBoxContainer/Teams.visible = Config.is_admin
	$AdminActive.visible = Config.is_admin
