# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name AuctionControl

extends VBoxContainer

signal auction
signal assign
signal next
signal previous

const AuctionTimer: PackedScene = preload("res://src/ui_components/timer/timer.tscn")

@onready var player_lablel: Label = $Labels/Player
@onready var team_lablel: Label = $Labels/Team
@onready var buttons: HBoxContainer = $Buttons

@onready var assign_button: Button = $Buttons/Assign
@onready var auction_button: Button = $Buttons/Auction
@onready var next_button: Button = $Buttons/Next
@onready var previous_button: Button = $Buttons/Previous

func _ready() -> void:
	if not Config.is_admin:
		assign_button.hide()
		next_button.hide()
		previous_button.hide()


func set_player(player: Player) -> void:
	player_lablel.text = player.name
	team_lablel.text = player.real_team
	
	auction_button.disabled = player.team_id > -1
	assign_button.disabled = player.team_id > -1


func _on_previous_pressed() -> void:
	previous.emit()


func _on_auction_pressed() -> void:
	auction.emit()


func _on_assign_pressed() -> void:
	assign.emit()


func _on_next_pressed() -> void:
	next.emit()
