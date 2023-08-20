# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.com>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

@onready var add_button:Button = $HBoxContainer/Add
@onready var name_edit:LineEdit = $HBoxContainer/Name
@onready var team_list:VBoxContainer = $VBoxContainer


func _ready() -> void:
	if Config.teams.is_empty():
		Config.teams = []
	
	for team in Config.teams:
		_add_team(team)


func _on_button_pressed() -> void:
	if name_edit.text.length() < 1:
		return
		
	var team = _create_team(name_edit.text)
	Config.teams.append(team)
	
	_add_team(team)
	
	name_edit.text = ""
	
func _add_team(team:Dictionary):
	
	var hbox:HBoxContainer = HBoxContainer.new()
	
	var label:Label = Label.new()
	label.text = team.name
	
	var edit_button:Button = Button.new()
	edit_button.text = "EDIT"
	
	var delete_button:Button = Button.new()
	delete_button.text = "DELETE"
	
	hbox.add_child(label)
	hbox.add_child(edit_button)
	hbox.add_child(delete_button)
	
	team_list.add_child(hbox)
	
	Config.save_all_data()
	

func _create_team(team_name:String) -> Dictionary:
	return {
		"name": team_name,
		"budget": Config.budget,
		"players": []
	}


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://src/screens/menu/Menu.tscn")
