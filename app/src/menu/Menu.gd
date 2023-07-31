# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.com>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

const MIN_TIME:int = 5
const MAX_TIME:int = 600
const DEFAULT_TIME:int = 60

@onready var time_label:Label = $VBoxContainer/Time

func _ready() -> void:
	time_label.text = "%2.2f"%Config.active_time


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://src/main/Main.tscn")

func _on_homepage_pressed() -> void:
	OS.shell_open("https://simondalvai.com")

func _set_time(time:float) -> void:
	if Config.active_time + time <= MIN_TIME:
		Config.active_time = MIN_TIME
	elif Config.active_time + time > MAX_TIME:
		Config.active_time = MAX_TIME
	else:
		Config.active_time += time

	Config.save_all_data()

	time_label.text = "%2.2f"%Config.active_time

func _on_minus_minutes_pressed() -> void:
	_set_time(-60)


func _on_minus_seconds_pressed() -> void:
	_set_time(-1)


func _on_plus_seconds_pressed() -> void:
	_set_time(+1)


func _on_plus_minutes_pressed() -> void:
	_set_time(+60)
		


func _on_reset_pressed() -> void:
	pass # Replace with function body.
