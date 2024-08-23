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
@onready var total_spinner: SpinBox = $VBoxContainer/AdminSection/PlayerOptions/TotalSpinner


func _ready() -> void:
	Config.ready_for_player_messages = false
	admin_section.visible = Config.is_admin
	# always close server connection in menu
	if Client.last_state != WebSocketPeer.STATE_OPEN:
		Client.connect_to_server()
	
	Client.get_teams.connect(func() -> void: teams.update_list())
	
	budget_spinner.value = Config.budget
	
	goalkeeper_spinner.value = Config.p_amount
	defender_spinner.value = Config.d_amount
	middlefield_spinner.value = Config.c_amount
	attacker_spinner.value = Config.a_amount
	total_spinner.value = Config.total_amount


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


func _on_total_spinner_value_changed(value: float) -> void:
	pass # Replace with function body.
