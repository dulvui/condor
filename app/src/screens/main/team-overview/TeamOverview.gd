# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

signal player_removed(player:Player, team:Team)

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
	
func _add_team(team:Team) -> void:
	
	var vbox:VBoxContainer = VBoxContainer.new()
	vbox.custom_minimum_size = Vector2(300, 800)
	
	var name_label:Label = Label.new()
	name_label.text = "%s\nBudget %d\n"%[team.name, team.budget]
	
	vbox.add_child(name_label)
	team_list.add_child(vbox)

	for player in Config.players:
		if player.team_id == team.id:
			var player_box = PlayerBox.instantiate()
			vbox.add_child(player_box)
			player_box.set_player(player)
			player_box.player_removed.connect(_on_player_removed.bind(player, team))
	
	
func _on_player_removed(player:Player, team:Team):
	player_removed.emit(player, team)
	
