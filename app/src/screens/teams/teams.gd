# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends VBoxContainer

const TeamBox: PackedScene = preload("res://src/screens/teams/team_box/team_box.tscn")

@onready var add_player:HBoxContainer = $TeamAdd
@onready var add_button:Button = $TeamAdd/Add
@onready var name_edit:LineEdit = $TeamAdd/Name
@onready var team_list:VBoxContainer = $ScrollContainer/List

func _ready() -> void:
	for team in Config.teams:
		_add_team(team)
	add_player.visible = Config.is_admin


func update_list() -> void:
	for team_box in team_list.get_children():
		team_box.queue_free()
	
	for team in Config.teams:
		_add_team(team)


func _add_team(team: Team):
	var team_box: TeamBox = TeamBox.instantiate()
	team_list.add_child(team_box)
	team_box.set_up(team)
	team_box.deleted.connect(update_list)
	Config.save_all_data()


func _create_team(team_name: String) -> Team:
	var team: Team = Team.new()
	# todo use global incremetnal id
	team.set_up(team_name)
	return team


func _on_add_pressed() -> void:
	if name_edit.text.length() < 1:
		return
		
	var team = _create_team(name_edit.text)
	Config.teams.append(team)
	
	_add_team(team)
	
	name_edit.text = ""
	update_list()
