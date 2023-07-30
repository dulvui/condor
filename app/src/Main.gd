# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.com>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

@onready var timer:Timer = $Timer
@onready var time_label:Label = $VBoxContainer/Time
@onready var start_button:TextureButton = $VBoxContainer/TimeControl/Start

const MIN_TIME:int = 5
const MAX_TIME:int = 600
const DEFAULT_TIME:int = 60


func _ready() -> void:
	timer.wait_time = Config.active_time
	time_label.text = "%2.2f"%timer.time_left


func _process(delta: float) -> void:
	if timer.is_stopped():
		time_label.text = "%2.2f"%timer.wait_time
	else:
		time_label.text = "%2.2f"%timer.time_left


func _on_start_pressed() -> void:
	if timer.is_stopped():
		timer.start()
	else:
		timer.paused = not timer.paused


func _on_stop_pressed() -> void:
	timer.stop()
	timer.paused = false
	start_button.set_pressed_no_signal(false)


func _on_restart_pressed() -> void:
	timer.stop()
	timer.start()

func _set_time(time:float) -> void:
	if Config.active_time + time <= MIN_TIME:
		Config.active_time = MIN_TIME
	elif Config.active_time + time > MAX_TIME:
		Config.active_time = MAX_TIME
	else:
		Config.active_time += time
		
	timer.wait_time = Config.active_time
	Config.save_all_data()

func _on_minus_minutes_pressed() -> void:
	if timer.is_stopped():
		_set_time(-60)


func _on_minus_seconds_pressed() -> void:
	if timer.is_stopped():
		_set_time(-1)


func _on_plus_seconds_pressed() -> void:
	if timer.is_stopped():
		_set_time(+1)


func _on_plus_minutes_pressed() -> void:
	if timer.is_stopped():
		_set_time(+60)
		


func _on_reset_pressed() -> void:
	if timer.is_stopped():
		timer.wait_time = DEFAULT_TIME


func _on_timer_timeout() -> void:
	start_button.set_pressed_no_signal(false)
