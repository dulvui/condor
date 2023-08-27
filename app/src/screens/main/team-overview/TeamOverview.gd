# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

signal player_removed

const SingleTeam:PackedScene = preload("res://src/screens/main/team-overview/single-team/SingleTeam.tscn")

@onready var team_list:HBoxContainer = $ScrollContainer/TeamList

func _ready() -> void:
	set_process(false)
	set_up()


func set_up() -> void:
	for team in Config.teams:
		var single_team:SingleTeam = SingleTeam.instantiate()
		team_list.add_child(single_team)
		single_team.set_up(team)
		single_team.player_removed.connect(_on_player_removed)
		
func update() -> void:
	for single_team in team_list.get_children():
		single_team.update()
	
func _on_player_removed():
	player_removed.emit()
	
