# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name PlayerBox

extends HBoxContainer

signal player_removed

@onready var player_label: PlayerLabel = $PlayerLabel
@onready var price_edit: LineEdit = $RemoveDialog/HBoxContainer/Price
@onready var remove_dialog: ConfirmationDialog = $RemoveDialog

var player: Player 


func set_player(p_player: Player) -> void:
	player = p_player
	player_label.set_up(player)


func _on_remove_dialog_confirmed() -> void:
	var price: int = int(price_edit.text)
	player.price = price
	player_removed.emit()


func _on_player_label_action() -> void:
	price_edit.text = str(player.price)
	remove_dialog.popup_centered()
