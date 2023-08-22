# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node

const BUDGET:int = 500
const FILE_PATH:String = "res://assets/players/players_05082023.list"

var config:ConfigFile

var active_time:int

var teams:Array
var players:Array

var active_player_index:int
var history:Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	config = ConfigFile.new()
	config.load("user://settings.cfg")
	active_time = config.get_value("settings", "active_time", 30)
	# try saving teams and players as dictionary to save space
	# construct/deconstruct methods
	teams = config.get_value("data", "teams", _get_default_teams())
	players = config.get_value("data", "players", _init_players())
	active_player_index = config.get_value("data", "active_player_index", 0)
	history = config.get_value("data", "history", [])
	

func save_all_data() -> void:
	config.set_value("settings","active_time",active_time)
	config.set_value("data","players",players)
	config.set_value("data","teams",teams)
	config.set_value("data","active_player_index",active_player_index)
	config.set_value("data","history",history)
	config.save("user://settings.cfg")

func add_player_to_team(team:Team, player:Player, price:int) -> bool:
	if team.budget - price < 0:
		return false
		
	add_to_history(player, team, price)
	
	player.price = price
	player.team_id = team.id
	team.budget -= price
	Config.save_all_data()
	
	return true
	
func remove_player_from_team(player:Player, team:Team) -> void:
	add_to_history(player, team, -player.price)
	
	team.budget += player.price 
	
	player.price = 0
	player.team_id = -1
	
	Config.save_all_data()


func add_to_history(player:Player, team:Team, price:int):
	var transfer = {
		"player" : player.name,
		"team" : team.name,
		"price" : price,
	}
	history.append(transfer)

func active_player() -> Player:
	players[active_player_index].was_active = true
	return players[active_player_index]

func set_active_player(player:Player) -> Player:
	active_player_index = players.find(player)
	return active_player()
	
func next_player() -> Player:
	if active_player_index + 1 < players.size():
		active_player_index += 1
	return active_player()


func previous_player() -> Player:
	if active_player_index - 1 >= 0:
		active_player_index -= 1
	return active_player() 

func _get_default_teams() -> Array:
	var default_teams:Array = []
	const desp_league_names = [
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
	for name in desp_league_names:
		var team = Team.new()
		default_teams.append(team.set_up(name, id))
		id += 1
		
	return default_teams
	
func _init_players() -> Array:
	var list:Array = []
	var temp_list:Dictionary = {}
	
	for position in Player.Position.keys():
		temp_list[position] = []
	
	var file:FileAccess = FileAccess.open(FILE_PATH, FileAccess.READ)
	# skip header lines
	while not file.eof_reached():
		var line:Array = file.get_csv_line()
		if line[0] == "Id":
			break
	
	while not file.eof_reached():
		var line:Array = file.get_csv_line()
		# check if not empty
		if not line[0]:
			break
		var pos:String = line[1]
		temp_list[pos].append(_get_player(line))
	
	for position in Player.Position.keys():
		temp_list[position].sort_custom(func(a, b): return a.name < b.name)
		list.append_array(temp_list[position])
	
	return list
		
func _get_player(line:Array) -> Player:
	var id:int = int(line[0])
	var position:int = Player.Position.keys().find(line[1])
	var name:String = line[2]
	var real_team:String = line[3]
	var mfv:float = float(line[4])
	var price_initial:int = int(line[5])
	var price_current:int = int(line[6])
	var price:int = 0
	
	var player = Player.new()
	return player.set_up(id, position, name,real_team, mfv, price, price_initial, price_current)

# save on quit on mobile
func _notification(what) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_all_data()
		get_tree().quit() # default behavior
