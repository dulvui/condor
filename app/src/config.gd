# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node

# change to ship admin client
var is_admin: bool = true

const FILE_PATH: String = "res://assets/players/players.csv"

# default values
var p_amount: int = 3
var d_amount: int = 8
var c_amount: int = 8
var a_amount: int = 6

var budget: int = 500


var theme_index: int

var follow_auction_in_player_list: bool

var config: ConfigFile

var active_time: int

var active_team_id: int
var next_team_id: int
var players: Array

var teams: Array
var active_player_index: int
var history: Array

var ready_for_player_messages: bool = false

var player_messages: Array


func _ready() -> void:
	config = ConfigFile.new()
	config.load("user://settings.cfg")
	active_time = config.get_value("settings", "active_time", 30)
	theme_index = config.get_value("settings", "theme_index", ThemeUtil.default_theme_index())
	is_admin = config.get_value("settings", "is_admin", false)
	follow_auction_in_player_list = config.get_value("settings", "follow_auction_in_player_list", true)
	# try saving teams and players as dictionary to save space
	# construct/deconstruct methods
	teams = config.get_value("data", "teams", [])
	active_team_id = config.get_value("data", "active_team_id", -1)
	next_team_id = config.get_value("data", "next_team_id", 0)
	players = config.get_value("data", "players", _init_players())
	active_player_index = config.get_value("data", "active_player_index", 0)
	history = config.get_value("data", "history", [])
	player_messages = config.get_value("data", "player_messages", [])


func save_all_data() -> void:
	config.set_value("settings","active_time",active_time)
	config.set_value("settings","theme_index",theme_index)
	config.set_value("settings","is_admin",is_admin)
	config.set_value("settings","follow_auction_in_player_list",follow_auction_in_player_list)
	config.set_value("data","players",players)
	config.set_value("data","teams",teams)
	config.set_value("data","active_team_id",active_team_id)
	config.set_value("data", "next_team_id", next_team_id)
	config.set_value("data","active_player_index",active_player_index)
	config.set_value("data","history",history)
	config.set_value("data","player_messages",player_messages)
	config.save("user://settings.cfg")


func reset_data() -> void:
	active_time = 30
	teams = []
	active_team_id = -1
	next_team_id = 0
	active_player_index = 0
	history = []
	player_messages = []
	
	for player: Player in Config.players:
		player.reset()


func add_player_to_team(team: Team, player: Player, price:int) -> String:
	var error_message: String = team.add_player(player, price)
	if not error_message.is_empty():
		return error_message
	player.price = price
	player.team_id = team.id
	return ""


func remove_player_from_team(player: Player, team: Team) -> void:
	team.remove_player(player)
	player.price = 0
	player.team_id = -1


func add_to_history(player: Player, team: Team, price:int):
	var transfer = {
		"player" : player,
		"team" : team,
		"price" : price,
	}
	history.append(transfer)
	save_all_data()


func active_player() -> Player:
	return players[active_player_index]


func set_active_player(player: Player) -> Player:
	active_player_index = players.find(player)
	save_all_data()
	return active_player()


func next_player() -> Player:
	var next_player_index:int = active_player_index
	while next_player_index + 1  < players.size():
		next_player_index += 1
		if players[next_player_index].team_id == -1:
			active_player_index = next_player_index
			save_all_data()
			return active_player()
	save_all_data()
	return active_player()


func previous_player() -> Player:
	var next_player_index:int = active_player_index
	while next_player_index - 1  >= 0:
		next_player_index -= 1
		if players[next_player_index].team_id == -1:
			active_player_index = next_player_index
			save_all_data()
			return active_player()
	save_all_data()
	return active_player()


func get_next_team_id():
	next_team_id += 1
	return next_team_id
	

func get_player_by_id(id:int) -> Player:
	for player in players:
		if player.id == id:
			return player
	return


func get_team_by_id(id:int) -> Team:
	for team in teams:
		if team.id == id:
			return team
	return


func delete_team(team: Team) -> void:
	teams.erase(team)
	for player in players:
		if player.team_id == team.id:
			player.team_id = -1


func _init_players() -> Array:
	var list:Array = []
	var temp_list:Dictionary = {}
	
	for position in Player.Position.keys():
		temp_list[position] = []
		
	var file:FileAccess = FileAccess.open(FILE_PATH, FileAccess.READ)
	
	if file == null:
		print("error readin file: %s"%str(FileAccess.get_open_error()))
		return []
	# skip header lines
	while not file.eof_reached():
		var line:Array = file.get_csv_line()
		if line[0] == "Id":
			break
	
	while not file.eof_reached():
		var line:Array = file.get_csv_line()
		# check if not empty
		if str(line[0]).is_empty():
			break
		var pos: String = line[1]
		var player: Player =  _get_player(line)
		if player:
			temp_list[pos].append(player)
	
	for position in Player.Position.keys():
		temp_list[position].sort_custom(func(a, b): return a.name < b.name)
		list.append_array(temp_list[position])
	
	file.close()
	return list


func _get_player(line:Array) -> Player:
	var id:int = int(line[0])
	var position:int = Player.Position.keys().find(line[1])
	var player_name: String = line[3]
	var real_team: String = line[4]
	var mfv:float = float(line[11])
	var price_initial:int = int(line[6])
	var price_current:int = int(line[5])
	var price:int = 0
	
	if "*" in player_name:
		return
	
	var player = Player.new()
	return player.set_up(id, position, player_name,real_team, mfv, price, price_initial, price_current)


func toogle_admin() -> bool:
	is_admin = not is_admin
	return is_admin


# save on quit on mobile
func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_all_data()
		get_tree().quit() # default behavior
	elif what == NOTIFICATION_PAUSED:
		Client.close()
	elif what == NOTIFICATION_UNPAUSED:
		Client.connect_to_server()
