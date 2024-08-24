# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

@onready var admin_section: VBoxContainer = $VBoxContainer/AdminSection
@onready var reset_dialog: ConfirmationDialog = $ResetDialog
@onready var teams: VBoxContainer = $VBoxContainer/Teams

@onready var budget_spinner: SpinBox = $VBoxContainer/AdminSection/BudgetSpinner
@onready var goalkeeper_spinner: SpinBox = $VBoxContainer/AdminSection/PlayerOptions/GoalkeeperSpinner
@onready var defender_spinner: SpinBox = $VBoxContainer/AdminSection/PlayerOptions/DefenderSpinner
@onready var middlefield_spinner: SpinBox = $VBoxContainer/AdminSection/PlayerOptions/MiddlefieldSpinner
@onready var attacker_spinner: SpinBox = $VBoxContainer/AdminSection/PlayerOptions/AttackerSpinner

@onready var theme_options: OptionButton = $VBoxContainer/ThemeOptionButton

func _ready() -> void:
	theme = ThemeUtil.get_active_theme()
	
	theme = ThemeUtil.get_active_theme()
	for theme_name: String in ThemeUtil.get_theme_names():
		theme_options.add_item(theme_name)
	theme_options.selected = Config.theme_index
	
	Config.ready_for_player_messages = false
	admin_section.visible = Config.is_admin
	# always close server connection in menu
	if Client.last_state != WebSocketPeer.STATE_OPEN:
		Client.connect_to_server()
	else:
		_sync_teams()
	
	Client.get_teams.connect(func() -> void: teams.update_list())
	Client.connected_to_server.connect(_sync_teams)
	
	budget_spinner.value = Config.budget
	
	goalkeeper_spinner.value = Config.p_amount
	defender_spinner.value = Config.d_amount
	middlefield_spinner.value = Config.c_amount
	attacker_spinner.value = Config.a_amount
	
	$Players.text = str(Config.players.size())


func _sync_teams() -> void:
	# fetch teams on first start
	if Config.teams.size() == 0:
		Client.send(Client.get_teams.get_name())


func _on_export_pressed() -> void:
	var timestamp: float = Time.get_unix_time_from_system()
	var file: FileAccess = FileAccess.open("user://players-%d.csv"%timestamp, FileAccess.WRITE)
	
	var content: String = "";
	
	var export_teams: Dictionary = {}
	for team in Config.teams:
		export_teams[team.id] = {
			"name": team.name,
			"players": [],
		}
	
	for player in Config.players:
		if player.team_id >= 0:
			export_teams[player.team_id].players.append(player)
	
	for team in export_teams.values():
		var team_line: PackedStringArray = PackedStringArray()
		team_line.append_array(["$", "$", "$"])
		file.store_csv_line(team_line)
		for player in team.players:
			var player_line: PackedStringArray = PackedStringArray()
			player_line.append_array([team.name, player.id, player.price])
			file.store_csv_line(player_line)


func _on_reset_pressed() -> void:
	reset_dialog.popup_centered()


func _on_reset_dialog_confirmed() -> void:
	Config.reset_data()
	Client.send(Client.get_teams.get_name())
	teams.update_list()
	admin_section.visible = Config.is_admin


func _on_admin_button_pressed() -> void:
	Config.is_admin = not Config.is_admin 
	admin_section.visible = Config.is_admin
	# update list again, to show new fetched teams
	teams.update_list()


func _on_budget_spinner_value_changed(value: float) -> void:
	Config.budget = value


func _on_goalkeeper_spinner_value_changed(value: float) -> void:
	Config.p_amount = value


func _on_defender_spinner_value_changed(value: float) -> void:
	Config.d_amount = value


func _on_middlefield_spinner_value_changed(value: float) -> void:
	Config.c_amount = value


func _on_attacker_spinner_value_changed(value: float) -> void:
	Config.a_amount = value


func _on_theme_option_button_item_selected(index: int) -> void:
	theme = ThemeUtil.set_active_theme(index)
	teams.theme = ThemeUtil.get_active_theme()
