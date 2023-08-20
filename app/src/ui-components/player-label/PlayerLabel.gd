# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.com>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name  PlayerLabel
extends HBoxContainer

signal action(player:Player)

@onready var position_label:Label = $Position
@onready var name_label:Label = $Name
@onready var team_name_label:Label = $TeamName
@onready var price_label:Label = $Price
@onready var action_button:Button = $Action


var player:Player 

func _ready() -> void:
	set_process(false)


func set_up(_player:Player) -> void:
	player = _player
	
	position_label.text = player.get_position_string()
	name_label.text = player.name
	team_name_label.text = player.real_team
	price_label.text = "%d M"%player.price
	
	# set position label color
	var position_label_settings = LabelSettings.new()
	position_label_settings.font_size = get_theme_default_font_size()
	
	match player.position:
		Player.Position.P:
			position_label_settings.font_color = Color.YELLOW
		Player.Position.D:
			position_label_settings.font_color = Color.GREEN
		Player.Position.C:
			position_label_settings.font_color = Color.BLUE
		Player.Position.A:
			position_label_settings.font_color = Color.RED
	
	position_label.label_settings = position_label_settings


func set_button_text(text:String):
	action_button.text = text


func _on_action_pressed() -> void:
	action.emit(player)
