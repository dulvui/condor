# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.com>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends HBoxContainer

signal player_removed

@onready var position_label:Label = $Position
@onready var name_label:Label = $Name
@onready var price_label:Label = $Price
@onready var price_edit:LineEdit = $RemoveDialog/HBoxContainer/Price
@onready var remove_dialog:ConfirmationDialog = $RemoveDialog


var player:Dictionary 
var team_id:int

func _ready() -> void:
	set_process(false)
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
	
func set_player(_player:Dictionary, _team_id:int) -> void:
	player = _player
	team_id = _team_id

func _on_remove_pressed() -> void:
	price_edit.text = str(player.price)
	remove_dialog.popup_centered()


func _on_remove_dialog_confirmed() -> void:
	Config.remove_player_from_team(team_id, player, int(price_edit.text))
	emit_signal("player_removed")
