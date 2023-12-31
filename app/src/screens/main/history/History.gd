# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

@onready var trasfer_list:VBoxContainer = $ScrollContainer/TransferList

func _ready() -> void:
	set_up()

func set_up(list:Array = Config.history):
	for transfer in list:
		var label:Label = Label.new()
		if transfer.price <= 0:
			label.text =  "- %s (%d) %s"%[transfer.player.name, transfer.price, transfer.team.name]
		else:
			label.text = "+ %s (%d) %s"%[transfer.player.name, transfer.price, transfer.team.name]
		trasfer_list.add_child(label)
		trasfer_list.move_child(label, 0)


func update() -> void:
	set_up(Config.history.slice(trasfer_list.get_child_count()))
