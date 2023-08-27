# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name SingleTeam

extends VBoxContainer

signal player_removed

const PlayerBox:PackedScene = preload("res://src/ui-components/player-box/PlayerBox.tscn")

@onready var name_label:Label = $Name
@onready var budget_label:Label = $Budget
@onready var player_list:VBoxContainer = $PlayerList



func set_up(team:Team) -> void:
	name_label.text = team.name
	budget_label.text = " %d M"%team.budget
	
	for player in Config.players:
		if player.team_id == team.id:
			var player_box = PlayerBox.instantiate()
			player_list.add_child(player_box)
			player_box.set_player(player)
			player_box.player_removed.connect(_on_player_removed.bind(player, team))

func update() -> void:
	pass

func _on_player_removed(player:Player, team:Team):
	Config.add_to_history(player, team, player.price)
	Config.remove_player_from_team(player, team)
	player_removed.emit()
