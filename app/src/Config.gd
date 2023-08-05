# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.com>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node

var config:ConfigFile

var active_time:int
var players:Dictionary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	config = ConfigFile.new()
	config.load("user://settings.cfg")
	active_time = config.get_value("settings", "active_time", 30)
	players = config.get_value("data", "players", {})
	
func save_all_data() -> void:
	config.set_value("settings","active_time",active_time)
	config.set_value("data","players",players)
	config.save("user://settings.cfg")
	
# save on quit on mobile
func _notification(what) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_all_data()
		get_tree().quit() # default behavior
