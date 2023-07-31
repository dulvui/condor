# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.com>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

@onready var timer:Timer = $Timer
@onready var time_label:Label = $VBoxContainer/Time
@onready var big_button:TextureButton = $VBoxContainer/BigButton


var finished:bool = false

func _ready() -> void:
	timer.wait_time = Config.active_time
	time_label.text = "%2.2f"%timer.time_left


func _process(delta: float) -> void:
	if timer.is_stopped() and not finished:
		time_label.text = "%2.2f"%timer.wait_time
	else:
		time_label.text = "%2.2f"%(timer.time_left)


func _on_start_pressed() -> void:
	finished = false
	if timer.is_stopped():
		timer.start()
	else:
		timer.paused = not timer.paused


func _on_stop_pressed() -> void:
	_reset()


func _on_restart_pressed() -> void:
	if not finished:
		timer.stop()
		timer.start()

func _on_timer_timeout() -> void:
	finished = true


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://src/menu/Menu.tscn")


func _on_bug_button_pressed() -> void:
	if timer.paused:
		timer.paused = false
	elif not finished:
		timer.stop()
		timer.start()
	else:
		_reset() 


func _on_pause_pressed() -> void:
	timer.paused = true

func _reset() ->void:
	finished = false
	timer.stop()
	timer.paused = false
