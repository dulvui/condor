# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node


const TEAM_MAPPING = {
	"ata" : "atalanta",
	"bol" : "bologna",
	"cag" : "cagliari",
	"emp" : "empoli",
	"fio" : "fiorentina",
	"fro" : "frosinone",
	"gen" : "genoa",
	"int" : "inter",
	"juv" : "juventus",
	"laz" : "lazio",
	"lec" : "lecce",
	"mil" : "milan",
	"mon" : "monza",
	"nap" : "napoli",
	"rom" : "roma",
	"sal" : "salernitana",
	"sas" : "sassuolo",
	"tor" : "torino",
	"udi" : "udinese",
	"ver" : "verona",
}

func get_player_link(player:Player) -> String:
	var team = TEAM_MAPPING[player.real_team.to_lower()]
	var player_name = player.name.replace(".","").replace(" ","-")
	var id = player.id
	return "https://www.fantacalcio.it/serie-a/squadre/%s/%s/%s/2023-24"%[team,player_name, id]
