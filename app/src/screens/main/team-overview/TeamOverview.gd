# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.com>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

signal player_removed(player:Dictionary, team_id:int)

const PlayerBox:PackedScene = preload("res://src/ui-components/player-box/PlayerBox.tscn")

@onready var team_list:HBoxContainer = $ScrollContainer/TeamList

func _ready() -> void:
	set_process(false)
	set_up()


func set_up() -> void:
	for child in team_list.get_children():
		child.queue_free()
	for team in Config.teams:
		_add_team(team)
	
func _add_team(team:Dictionary) -> void:
	
	var vbox:VBoxContainer = VBoxContainer.new()
	vbox.custom_minimum_size = Vector2(300, 800)
	
	var name_label:Label = Label.new()
	name_label.text = "%s\nBudget %d\n"%[team.name, team.budget]
	
	vbox.add_child(name_label)
	team_list.add_child(vbox)

	for pos in Config.POSITIONS:
		for player in team.players[pos]:
			var player_box = PlayerBox.instantiate()
			vbox.add_child(player_box)
			player_box.set_player(player, team.id)
			player_box.player_removed.connect(func(): _on_player_removed(player, team.id))
#			player_box.player_removed.connect(_on_player_removed)
	
	
func _on_player_removed(player:Dictionary, team_id:int):
	player_removed.emit(player, team_id)
	
