# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.com>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

const MIN_TIME:int = 5
const MAX_TIME:int = 30
const DEFAULT_TIME:int = 10

@onready var timer:Timer = $Timer
@onready var time_label:Label = $VBoxContainer/Time
@onready var big_button:TextureButton = $VBoxContainer/BigButton
@onready var sound:Node2D = $Sound
@onready var name_label:Label = $VBoxContainer/Name


var finished:bool = false


func _ready() -> void:
	timer.wait_time = Config.active_time
	time_label.text = "%2.2f"%timer.time_left

func _process(delta: float) -> void:
	if timer.is_stopped() and not finished:
		time_label.text = "%2.2f"%timer.wait_time
	else:
		time_label.text = "%2.2f"%(timer.time_left)
		
	if not timer.is_stopped() and not finished:
		sound.countdown(timer.time_left)

func set_player(player:Dictionary):
	name_label.text = player.name

func _on_start_pressed() -> void:
	finished = false
	if timer.is_stopped():
		timer.start()
	else:
		timer.paused = not timer.paused


func _on_restart_pressed() -> void:
	_restart()

func _on_timer_timeout() -> void:
	finished = true
	sound.final()


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://src/menu/Menu.tscn")


func _on_bug_button_pressed() -> void:
	if timer.paused:
		timer.paused = false
	elif not finished:
		timer.stop()
		timer.start()
	else:
		_restart() 


func _on_pause_pressed() -> void:
	timer.paused = true

func _restart() ->void:
	finished = false
	timer.stop()
	timer.paused = false

func _set_time(time:float) -> void:
	if Config.active_time + time <= MIN_TIME:
		Config.active_time = MIN_TIME
	elif Config.active_time + time > MAX_TIME:
		Config.active_time = MAX_TIME
	else:
		Config.active_time += time

	Config.save_all_data()

	timer.wait_time = Config.active_time

func _on_minus_minutes_pressed() -> void:
	_set_time(-10)


func _on_minus_seconds_pressed() -> void:
	_set_time(-1)


func _on_plus_seconds_pressed() -> void:
	_set_time(+1)


func _on_plus_minutes_pressed() -> void:
	_set_time(+10)

func _on_reset_pressed() -> void:
	Config.active_time = DEFAULT_TIME
	Config.save_all_data()
	timer.wait_time = Config.active_time
