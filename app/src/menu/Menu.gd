# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.com>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://src/main/Main.tscn")

func _on_credits_pressed() -> void:
	pass # Replace with function body.

func _on_teams_pressed() -> void:
	get_tree().change_scene_to_file("res://src/teams/Teams.tscn")
