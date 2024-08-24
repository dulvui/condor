# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name SingleTeam

extends VBoxContainer

signal player_removed

const PlayerBox: PackedScene = preload("res://src/ui_components/player_box/player_box.tscn")

@onready var name_label: Label = $Name
@onready var budget_label: Label = $Budget
@onready var scrool: ScrollContainer = $ScrollContainer
@onready var player_list: VBoxContainer = $ScrollContainer/PlayerList

@onready var p_label: Label = $PlayerAmount/P
@onready var d_label: Label = $PlayerAmount/D
@onready var c_label: Label = $PlayerAmount/C
@onready var a_label: Label = $PlayerAmount/A

var team: Team


func set_up(team: Team) -> void:
	self.team = team
	name_label.text = team.name
	
	
	for player in Config.players:
		if player.team_id == team.id:
			_append_player_label(player)
	
	update_player_amount()
	update_budget()


func add_player(player: Player) -> void:
	_append_player_label(player)
	update_budget()
	update_player_amount()


func _append_player_label(player: Player) -> void:
	var player_box: PlayerBox = PlayerBox.instantiate()
	player_list.add_child(player_box)
	player_box.set_player(player)
	player_box.player_removed.connect(_on_player_removed.bind(player))
	scrool.ensure_control_visible(player_box)


func _on_player_removed(player: Player) -> void:
	if Config.is_admin:
		Client.send(Client.player_remove.get_name() + \
			Client.DATA_DELIMETER + str(player.id) + \
			Client.DATA_DELIMETER + str(player.team_id))
	Config.add_to_history(player, team, -player.price)
	Config.remove_player_from_team(player, team)
	remove_player(player)
	budget_label.text = "%d M"%team.budget
	update_player_amount()
	player_removed.emit()


func remove_player(player: Player) -> void:
	for player_label in player_list.get_children():
		if player_label.player.id == player.id:
			player_label.queue_free()


func update_budget() -> void:
	budget_label.text = "%d M - max %d M"%[team.budget, team.get_max_budget()]


func update_player_amount() -> void:
	p_label.text = "P %d/%d"%[Config.p_amount - team.slots["P"],Config.p_amount]
	d_label.text = "D %d/%d"%[Config.d_amount - team.slots["D"],Config.d_amount]
	c_label.text = "C %d/%d"%[Config.c_amount - team.slots["C"],Config.c_amount]
	a_label.text = "A %d/%d"%[Config.a_amount - team.slots["A"],Config.a_amount]
	
