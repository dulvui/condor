# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name  PlayerLabel

extends Control

signal action

@onready var position_label:Label = $MarginContainer/HBoxContainer/Position
@onready var name_label:Label = $MarginContainer/HBoxContainer/Name
@onready var team_name_label:Label = $MarginContainer/HBoxContainer/TeamName
@onready var price_label:Label = $MarginContainer/HBoxContainer/Price
@onready var action_button:Button = $MarginContainer/HBoxContainer/Action
@onready var link_button:Button = $MarginContainer/HBoxContainer/Link
@onready var color_rect:ColorRect = $ColorRect


var player: Player 

func _ready() -> void:
	set_process(false)
	action_button.visible = Config.is_admin
	#link_button.visible = OS.get_name() in ["Linux", "Windows", "Web"]
	link_button.visible = Config.is_admin


func set_up(_player: Player) -> void:
	player = _player
	
	position_label.text = player.get_position_string()
	name_label.text = player.name
	team_name_label.text = player.real_team_short
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
			label_settings.font_color = Color.AQUA
		Player.Position.A:
			color_rect.color = Color.DARK_GREEN
			label_settings.font_color = Color.RED
	
	position_label.label_settings = label_settings


func disable_player() -> void:
	color_rect.color = Color.DARK_SLATE_GRAY


func set_button_text(text: String) -> void:
	action_button.text = text


func activate() -> void:
	color_rect.color = Color.MEDIUM_AQUAMARINE


func deactivate() -> void:
	color_rect.color = Color.DARK_BLUE


func _on_action_pressed() -> void:
	action.emit()


func get_player_link(player: Player) -> String:
	var team: String = player.real_team.to_lower()
	var player_name: String = player.name.replace(".","").replace(" ","-")
	var id: int = player.id
	return "https://www.fantacalcio.it/serie-a/squadre/%s/%s/%s/2023-24"%[team,player_name, id]


func _on_link_pressed():
	OS.shell_open(get_player_link(player))
