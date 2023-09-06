# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name AuctionControl

extends VBoxContainer

signal auction
signal assign
signal next
signal previous

const AuctionTimer:PackedScene = preload("res://src/ui-components/timer/Timer.tscn")

@onready var player_lablel:Label = $Labels/Player
@onready var team_lablel:Label = $Labels/Team
@onready var buttons:HBoxContainer = $Buttons


func _ready() -> void:
	if not Config.is_admin:
		$Buttons/Previous.hide()
		$Buttons/Assign.hide()
		$Buttons/Next.hide()

func set_player(player:Player) -> void:
	player_lablel.text = player.name
	team_lablel.text = player.real_team

func _on_previous_pressed() -> void:
	previous.emit()

func _on_auction_pressed() -> void:
	auction.emit()

func _on_assign_pressed() -> void:
	assign.emit()

func _on_next_pressed() -> void:
	next.emit()
