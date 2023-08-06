# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.com>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Popup

signal assigned

@onready var teams:OptionButton = $VBoxContainer/Teams
@onready var price:LineEdit = $VBoxContainer/Price

var active_player:Dictionary
var active_team:int = 0

func _ready() -> void:
	for team in Config.teams:
		
		teams.add_item(team.name)
		
		var button:Button = Button.new()
		button.text = "ASSIGN"

func set_player(player:Dictionary) -> void:
	active_player = player


func _on_teams_item_selected(index: int) -> void:
	active_team = index


func _on_assign_pressed() -> void:
	active_player.price = int(price.text)
	Config.teams[active_team].players.append(active_player)
	Config.teams[active_team].budget -= active_player.price
	print(Config.teams[active_team])
	
	Config.save_all_data()
	hide()
	emit_signal("assigned")
