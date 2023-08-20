# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.com>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Popup

signal assigned

@onready var teams:VBoxContainer = $VBoxContainer/Teams
@onready var price:LineEdit = $VBoxContainer/Price

var player:Dictionary

func _ready() -> void:
	for team in Config.teams:
		var button:Button = Button.new()
		button.text = team.name
		button.pressed.connect(_on_assign_pressed.bind(team.id))
		teams.add_child(button)

func set_player(_player:Dictionary) -> void:
	player = _player
	


func _on_assign_pressed(team_id:int) -> void:
	if Config.add_player_to_team(team_id, player, int(price.text)):
		hide()
		emit_signal("assigned")
