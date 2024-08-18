# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

const TeamBox: PackedScene = preload("res://src/screens/teams/team_box/team_box.tscn")

@onready var add_player:HBoxContainer = $HBoxContainer
@onready var add_button:Button = $HBoxContainer/Add
@onready var name_edit:LineEdit = $HBoxContainer/Name
@onready var team_list:VBoxContainer = $ScrollContainer/List

var team_to_delte:Team

func _ready() -> void:
	for team in Config.teams:
		_add_team(team)
	add_player.visible = Config.is_admin

	
func _add_team(team: Team):
	var team_box:TeamBox = TeamBox.instantiate()
	team_list.add_child(team_box)
	team_box.set_up(team)
	team_box.deleted.connect(_update_list)
	Config.save_all_data()


func _create_team(team_name: String) -> Team:
	var team: Team = Team.new()
	# todo use global incremetnal id
	team.set_up(team_name, 0)
	return team

func _update_list() -> void:
	for team_box in team_list.get_children():
		team_box.queue_free()
	
	for team in Config.teams:
		_add_team(team)

func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://src/screens/menu/menu.tscn")


func _on_add_pressed() -> void:
	if name_edit.text.length() < 1:
		return
		
	var team = _create_team(name_edit.text)
	Config.teams.append(team)
	
	_add_team(team)
	
	name_edit.text = ""
	_update_list()
