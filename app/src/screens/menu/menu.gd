# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

@onready var admin_section: VBoxContainer = $VBoxContainer/AdminSection
@onready var reset_dialog: ConfirmationDialog = $ResetDialog
@onready var teams: VBoxContainer = $VBoxContainer/Teams


func _ready() -> void:
	admin_section.visible = Config.is_admin
	# always close server connection in menu
	Client.connect_to_server()
	Client.get_teams.connect(func() -> void: teams.update_list())


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
	admin_section.visible = Config.is_admin


func _on_admin_button_pressed() -> void:
	Config.is_admin = not Config.is_admin 
	admin_section.visible = Config.is_admin
	teams.update_list()
