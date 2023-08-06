# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.com>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Popup

signal assigned

@onready var teams:OptionButton = $VBoxContainer/Teams
@onready var price:LineEdit = $VBoxContainer/Price

var active_player:Dictionary
var active_team:int = 0

func set_player(player:Dictionary) -> void:
	active_player = player
	
	teams.clear()
	
	for team in Config.teams:
		teams.add_item(team.name)

func _on_teams_item_selected(index: int) -> void:
	active_team = index


func _on_assign_pressed() -> void:
	if Config.add_player_to_team(active_team, active_player, int(price.text)):
		hide()
		emit_signal("assigned")
