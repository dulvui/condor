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
			label.text =  "- %s (%d) %s"%[transfer.player, transfer.price, transfer.team]
		else:
			label.text = "+ %s (%d) %s"%[transfer.player, transfer.price, transfer.team]
		trasfer_list.add_child(label)

func update() -> void:
	set_up(Config.history.slice(trasfer_list.get_child_count()))
