# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Popup

signal assigned

@onready var teams:VBoxContainer = $VBoxContainer/Teams
@onready var price:LineEdit = $VBoxContainer/Price
@onready var error_popup:AcceptDialog = $Error
@onready var error_label:Label = $Error/Label

var player:Player

func _ready() -> void:
	for team in Config.teams:
		var button:Button = Button.new()
		button.text = team.name
		button.pressed.connect(_on_assign_pressed.bind(team))
		teams.add_child(button)
	
func set_player(_player:Player) -> void:
	player = _player
	price.text = str(player.price_current)


func _on_assign_pressed(team:Team) -> void:
	var error_message:String =  Config.add_player_to_team(team, player, int(price.text))
	if error_message.is_empty():
		hide()
		Config.add_to_history(player, team, player.price)
		assigned.emit()
	else:
		error_label.text = error_message
		error_popup.popup_centered()
