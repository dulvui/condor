# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.com>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name  PlayerLabel
extends HBoxContainer

signal action

@onready var active_label:Label = $Active
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
	
	if player.was_active:
		active_label.text = "+"
	
	position_label.text = player.get_position_string()
	name_label.text = player.name
	team_name_label.text = player.real_team
	if player.price != 0:
		price_label.text = "%d M"%player.price
	else:
		price_label.text = "%d M|%d M"%[player.price_initial, player.price_current]

	
	# set position label color
	var label_settings = LabelSettings.new()
	label_settings.font_size = get_theme_default_font_size()
	
	if player.team_id >= 0:
		label_settings.font_color = Color.GRAY
		name_label.label_settings = label_settings
		team_name_label.label_settings = label_settings
		price_label.label_settings = label_settings
	else:
		match player.position:
			Player.Position.P:
				label_settings.font_color = Color.YELLOW
			Player.Position.D:
				label_settings.font_color = Color.GREEN
			Player.Position.C:
				label_settings.font_color = Color.BLUE
			Player.Position.A:
				label_settings.font_color = Color.RED
	
	position_label.label_settings = label_settings


func set_button_text(text:String):
	action_button.text = text


func _on_action_pressed() -> void:
	action.emit()
