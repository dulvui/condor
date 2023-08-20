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
		if transfer.price <= 0:
			label.text = tr("SELL") + " %s (%d) %s"%[transfer.team, transfer.price, transfer.player]
		else:
			label.text = tr("BUY") + " %s (%d) %s"%[transfer.team, transfer.price, transfer.player]
		trasfer_list.add_child(label)
