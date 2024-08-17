# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

signal active_player_change

const PlayerLabel:PackedScene = preload("res://src/ui-components/player-label/PlayerLabel.tscn")

@onready var list:VBoxContainer = $VBoxContainer/ScrollContainer/VBoxContainer
@onready var scroll:ScrollContainer = $VBoxContainer/ScrollContainer
@onready var positions:OptionButton = $VBoxContainer/Filter/Positions

var filters:Dictionary = {
	"name" : "",
	"position" : ""
}

func _ready() -> void:
	set_up_list()
	
	positions.add_item(tr("ALL"))
	for pos in Player.Position.keys():
		positions.add_item(pos)
	
	
func set_up_list():
	for child in list.get_children():
		child.queue_free()
	
	for player in Config.players:
		var player_label = PlayerLabel.instantiate()
		list.add_child(player_label)
		player_label.set_up(player)
		player_label.action.connect(_set_active_player.bind(player))
		if player.id == Config.active_player().id:
			player_label.activate()
		elif player.team_id < 0:
			player_label.deactivate()
		else:
			player_label.deactivate()
			player_label.disable_player()
		

func update() -> void:
	for player_label in list.get_children():
		if player_label.player.id == Config.active_player().id:
			player_label.activate()
			scroll.ensure_control_visible(player_label)
		elif player_label.player.team_id < 0:
			player_label.deactivate()
		else:
			player_label.deactivate()
			player_label.disable_player()
			

			

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://src/menu/Menu.tscn")

func _set_active_player(player:Player) -> void:
	Config.set_active_player(player)
	update()
	active_player_change.emit()

func _on_search_text_changed(new_text: String) -> void:
	filters.name = new_text.to_lower()
	_apply_filter()

func _on_positions_item_selected(index: int) -> void:
	if index == 0:
		filters.position = ""
	else:
		filters.position = str(index - 1)
	_apply_filter()

func _filter(player:Player) -> bool:
	for key in filters.keys():
		if not filters[key].is_empty():
			if not filters[key] in str(player[key]).to_lower():
				return false
	return true

func _apply_filter() -> void:
	for player_label in list.get_children():
		player_label.visible = _filter(player_label.player)
