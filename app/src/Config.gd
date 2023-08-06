# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.com>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node

var config:ConfigFile

var active_time:int

var teams:Array
var budget:int = 500

var players:Dictionary
var active_position:int = 0
var active_player:int = 0



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	config = ConfigFile.new()
	config.load("user://settings.cfg")
	active_time = config.get_value("settings", "active_time", 30)
	players = config.get_value("data", "players", {})
	active_player = config.get_value("data", "active_player", 0)
	active_position = config.get_value("data", "active_position", 0)
	teams = config.get_value("data", "teams", _get_default_teams())
#	teams = config.get_value("data", "teams", [])
	
func save_all_data() -> void:
	config.set_value("settings","active_time",active_time)
	config.set_value("data","players",players)
	config.set_value("data","teams",teams)
	config.set_value("data","active_position",active_position)
	config.set_value("data","active_player",active_player)
	config.save("user://settings.cfg")

func _get_default_teams() -> Array:
	var default_teams = []
	const desp_league = [
		"Fc Messi Male",
		"ASD Obergoller",
		"Fc. MAINZ NA GIOIA",
		"Lokomotiv Loska",
		"Longobarda",
		"FC MANCHESTER SINTY",
		"TIRANA RAGLIA",
		"Oscugnizzzzz",
	]
	
	for team in desp_league:
		default_teams.append({
		"name": team,
		"budget": budget,
		"players": []
		})
	
	return default_teams

# save on quit on mobile
func _notification(what) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_all_data()
		get_tree().quit() # default behavior
