# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.com>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends HBoxContainer

class_name  PlayerLabel

signal action(player:Dictionary, team_id:int)

@onready var position_label:Label = $Position
@onready var name_label:Label = $Name
@onready var price_label:Label = $Price
@onready var action_button:Button = $Action


var player:Dictionary 
var team_id:int

func _ready() -> void:
	set_process(false)

	
func set_up(_player:Dictionary, _team_id:int, button_text:String="-") -> void:
	player = _player
	team_id = _team_id
	action_button.text = button_text
	
	position_label.text = player.position
	name_label.text = player.name
	price_label.text = "%d M"%player.price
	
	# set position label color
	var position_label_settings = LabelSettings.new()
	position_label_settings.font_size = get_theme_default_font_size()
	
	match player.position:
		Config.POSITIONS[0]:
			position_label_settings.font_color = Color.YELLOW
		Config.POSITIONS[1]:
			position_label_settings.font_color = Color.GREEN
		Config.POSITIONS[2]:
			position_label_settings.font_color = Color.BLUE
		Config.POSITIONS[3]:
			position_label_settings.font_color = Color.RED
	
	position_label.label_settings = position_label_settings


func _on_action_pressed() -> void:
	action.emit(player,team_id)
