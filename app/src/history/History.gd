# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.com>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

@onready var trasfer_list:VBoxContainer = $ScrollContainer/TransferList

func _ready() -> void:
	set_up()

func set_up():
	for child in trasfer_list.get_children():
		child.queue_free()
	
	for transfer in Config.history:
		var label:Label = Label.new()
		label.text = "%s -> %s %d"%[transfer.player, transfer.team, transfer.price]
		trasfer_list.add_child(label)
