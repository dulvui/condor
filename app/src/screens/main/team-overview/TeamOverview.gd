# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

signal player_removed

const SingleTeam:PackedScene = preload("res://src/screens/main/team-overview/single-team/SingleTeam.tscn")

@onready var team_list:HBoxContainer = $HSplitContainer/ScrollContainer/TeamList
@onready var active_team:SingleTeam = $HSplitContainer/ActiveTeam

func _ready() -> void:
	set_process(false)
	set_up()


func set_up() -> void:
	for team in Config.teams:
		if team.id == Config.active_team_id:
			active_team.set_up(team)
		else:
			var single_team:SingleTeam = SingleTeam.instantiate()
			team_list.add_child(single_team)
			single_team.set_up(team)
			single_team.player_removed.connect(_on_player_removed)
		
func add_player(player:Player, team:Team) -> void:
	if team.id == Config.active_team_id:
		active_team.add_player(player)
	else:
		for single_team in team_list.get_children():
			if single_team.team.id == team.id:
				single_team.add_player(player)
				break
				
func remove_player(player:Player, team:Team) -> void:
	if team.id == Config.active_team_id:
		active_team.remove_player(player)
	else:
		for single_team in team_list.get_children():
			if single_team.team.id == team.id:
				single_team.remove_player(player)
				break
	
func _on_player_removed():
	player_removed.emit()
	
func update_teams_budget() -> void:
	active_team.update_budget()
	for single_team in team_list.get_children():
		single_team.update_budget()


func _on_active_team_player_removed() -> void:
	player_removed.emit()
