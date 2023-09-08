# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name  PlayerLabel

extends Control

signal action

@onready var active_label:Label = $HBoxContainer/Active
@onready var position_label:Label = $HBoxContainer/Position
@onready var name_label:Label = $HBoxContainer/Name
@onready var team_name_label:Label = $HBoxContainer/TeamName
@onready var price_label:Label = $HBoxContainer/Price
@onready var action_button:Button = $HBoxContainer/Action
@onready var color_rect:ColorRect = $ColorRect


var player:Player 

func _ready() -> void:
	set_process(false)
	
	if not Config.is_admin:
		action_button.disabled = true
	else:
		action_button.text = "A"
	


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
		price_label.text = "%d M"%[player.price_current]

	
	# set position label color
	var label_settings = LabelSettings.new()
	label_settings.font_size = get_theme_default_font_size()

	match player.position:
		Player.Position.P:
			color_rect.color = Color.DARK_BLUE
			label_settings.font_color = Color.YELLOW
		Player.Position.D:
			color_rect.color = Color.DARK_GREEN
			label_settings.font_color = Color.GREEN
		Player.Position.C:
			color_rect.color = Color.DARK_BLUE
			label_settings.font_color = Color.BLUE
		Player.Position.A:
			color_rect.color = Color.DARK_GREEN
			label_settings.font_color = Color.RED
	
	position_label.label_settings = label_settings

func disable_player() -> void:
	# set position label color
	var label_settings = LabelSettings.new()
	label_settings.font_size = get_theme_default_font_size()
	
	label_settings.font_color = Color.GRAY
	name_label.label_settings = label_settings
	team_name_label.label_settings = label_settings
	price_label.label_settings = label_settings
	position_label.label_settings = label_settings

	action_button.disabled = true
	


func set_button_text(text:String) -> void:
	action_button.text = text
	
func activate() -> void:
	color_rect.color = Color.MEDIUM_AQUAMARINE
	
func deactivate() -> void:
	color_rect.color = Color.DARK_BLUE
	
func _on_action_pressed() -> void:
	action.emit()


func _on_link_pressed():
	OS.shell_open(Utils.get_player_link(player))
