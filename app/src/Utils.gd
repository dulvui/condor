# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node


const TEAM_MAPPING = {
	"ata" : "atalanta",
	"bol" : "bologna",
	"com" : "como",
	"cag" : "cagliari",
	"emp" : "empoli",
	"fio" : "fiorentina",
	"gen" : "genoa",
	"int" : "inter",
	"juv" : "juventus",
	"laz" : "lazio",
	"lec" : "lecce",
	"mil" : "milan",
	"mon" : "monza",
	"nap" : "napoli",
	"par" : "parma",
	"rom" : "roma",
	"tor" : "torino",
	"udi" : "udinese",
	"ven" : "venezia",
	"ver" : "verona",
}

func get_player_link(player:Player) -> String:
	#var team = TEAM_MAPPING[player.real_team.to_lower()]
	var team: String = player.real_team.to_lower()
	var player_name: String = player.name.replace(".","").replace(" ","-")
	var id: int = player.id
	return "https://www.fantacalcio.it/serie-a/squadre/%s/%s/%s/2023-24"%[team,player_name, id]
