# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Player

# trasnform to enum
enum Position {
	P,
	D,
	C,
	A
}

var id: int
var position: int
var name: String
var team_id: int = -1
var real_team: String
var real_team_short: String
var mfv: float
var price: int
var price_initial: int
var price_current: int
var was_active: bool = false


func set_up(
		id: int,
		position: Position,
		name: String,
		real_team: String,
		mfv: float,
		price: int,
		price_initial: int,
		price_current: int
	) -> Player:
	self.id = id
	self.position = position
	self.name = name
	self.real_team = real_team
	self.real_team_short = real_team.substr(0, 3).to_upper()
	self.mfv = mfv
	self.price = price
	self.price_initial = price_initial
	self.price_current = price_current
	
	return self


func get_position_string() -> String:
	return Position.keys()[position]


func reset() -> void:
	price = price_current
	team_id = -1
