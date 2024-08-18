# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Lobby

var players:Array
var teams:Array
var history:Array
var active_player:Player

var auction_time_left:float
var auction_winning_team:Team
var acution_bid_counter:int

func set_up(players:Array, teams: Array, history:Array, active_player:Player) -> void:
	self.players = players
	self.teams = teams
	self.history = history
	self.active_player = active_player
