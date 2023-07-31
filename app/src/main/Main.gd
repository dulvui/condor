# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.com>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

@onready var timer:Timer = $Timer
@onready var time_label:Label = $VBoxContainer/Time
@onready var start_button:TextureButton = $VBoxContainer/TimeControl/Start


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
	finished = false
	timer.stop()
	timer.paused = false
	start_button.set_pressed_no_signal(false)


func _on_restart_pressed() -> void:
	if not finished:
		timer.stop()
		timer.start()




func _on_timer_timeout() -> void:
	start_button.set_pressed_no_signal(false)
	finished = true
