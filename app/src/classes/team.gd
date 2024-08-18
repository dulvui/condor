# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Team

var slots: Dictionary = {
	"P" : 3,
	"D" : 8,
	"C" : 8,
	"A" : 6,
	"total" : 25
}

var name: String
var id:int
var budget:int


func set_up(name: String, id:int) -> Team:
	self.name = name
	self.id = Config.get_next_team_id()
	self.budget = Config.BUDGET
	return self


func add_player(player: Player, price:int) -> String:
	if slots[player.get_position_string()] - 1  < 0:
		return "NO SLOTS AVBAILABLE"
		
	if budget - price < slots.total - 1:
		return "OUT OF BUDGET"
	
	budget -= price
	slots[player.get_position_string()] -= 1
	slots.total -= 1
	return ""


func remove_player(player: Player) -> void:
	slots[player.get_position_string()] += 1
	slots.total += 1
	budget += player.price


func to_dict() -> Dictionary:
	var dict: Dictionary = {}
	dict.name = name
	dict.id = id
	dict.budget = budget
	return dict


func from_dict(dict: Dictionary) -> void:
	if dict.id != id:
		print("trying to assign wrong team")
		return
	dict.name = dict.name
	dict.budget = dict.budget
