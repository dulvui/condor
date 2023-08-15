# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.com>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node

# trasnform to enum
const POSITIONS = ["P", "D", "C", "A"]

var config:ConfigFile

var active_time:int

var teams:Array
var budget:int = 500

var players:Dictionary
var active_position:int = 0
var active_player:int = 0
var history:Array

var team_size:Dictionary = {
	"P" : 3,
	"D" : 8,
	"C" : 8,
	"A" : 6
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	config = ConfigFile.new()
	config.load("user://settings.cfg")
	active_time = config.get_value("settings", "active_time", 30)
	players = config.get_value("data", "players", {})
	active_player = config.get_value("data", "active_player", 0)
	active_position = config.get_value("data", "active_position", 0)
	teams = config.get_value("data", "teams", _get_default_teams())
	history = config.get_value("data", "history", [])
#	teams = config.get_value("data", "teams", [])

	team_size["total"] = 0
	for size in team_size.values():
		team_size["total"] += size
	print(team_size["total"])
	

func save_all_data() -> void:
	config.set_value("settings","active_time",active_time)
	config.set_value("data","players",players)
	config.set_value("data","teams",teams)
	config.set_value("data","active_position",active_position)
	config.set_value("data","active_player",active_player)
	config.set_value("data","history",history)
	config.save("user://settings.cfg")

func add_player_to_team(active_team:int, active_player:Dictionary, price:int) -> bool:
	var team = Config.teams[active_team]
	var pos = active_player.position
	if  team.players[pos].size() + 1 > team_size[pos]:
		return false
	
	if team.budget - price < 0:
		return false
		
	add_to_history(active_player.name, Config.teams[active_team].name, price)
	
	active_player.price = price
	Config.teams[active_team].players[pos].append(active_player)
	Config.teams[active_team].budget -= price
	Config.save_all_data()
	
	players[pos].erase(active_player)
	return true
	
func add_to_history(player:String, team: String, price:int):
	var transfer = {
		"player" : player,
		"team" : team,
		"price" : price,
	}
	history.append(transfer)

func get_teams_with_empty_slots_for_pos(pos:String) -> Array:
	var teams_with_slots = []
	for team in teams:
		if team.players[pos].size() < team_size[pos]:
			teams_with_slots.append(team)
	return teams_with_slots

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
	
	var id:int = 0
	for team in desp_league:
		default_teams.append({
		"id": id,
		"name": team,
		"budget": budget,
		"players": {},
		})
		id += 1
		
		for pos in Config.POSITIONS:
			default_teams[-1]["players"][pos] = []
	
	return default_teams

# save on quit on mobile
func _notification(what) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_all_data()
		get_tree().quit() # default behavior
