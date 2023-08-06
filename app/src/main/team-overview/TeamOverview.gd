# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.com>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

@onready var team_list:HBoxContainer = $ScrollContainer/TeamList

func _ready() -> void:
	set_up()


func set_up() -> void:
	for child in team_list.get_children():
		child.queue_free()
	for team in Config.teams:
		_add_team(team)
	
func _add_team(team:Dictionary) -> void:
	
	var vbox:VBoxContainer = VBoxContainer.new()
	
	var name_label:Label = Label.new()
	name_label.text = team.name
	
	vbox.add_child(name_label)

	for player in team.players:
		var player_label:Label = Label.new()
		player_label.text = "%s %d"%[player.name, player.price]
	
		vbox.add_child(player_label)
	
	
	team_list.add_child(vbox)
