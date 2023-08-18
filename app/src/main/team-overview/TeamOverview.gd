# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.com>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

signal player_removed

const PlayerBox:PackedScene = preload("res://src/main/team-overview/player-box/PlayerBox.tscn")

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

	for pos in Config.POSITIONS:
		for player in team.players[pos]:
			var player_box = PlayerBox.instantiate()
			player_box.set_player(player, team.id)
			player_box.player_removed.connect(func(): _on_player_removed())
			vbox.add_child(player_box)
	
	team_list.add_child(vbox)
	
func _on_player_removed():
	emit_signal("player_removed")
	
