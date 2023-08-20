# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.com>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Player

# trasnform to enum
enum Position {
	P,
	D,
	C,
	A
}

var id:int
var position:int
var name:String
var team:Team
var real_team:String
var mfv:float
var price:int
var price_initial:int
var price_current:int

func set_up(id:int, position:Position, name:String, real_team:String, mfv:float, price:int, price_initial:int, price_current:int) -> Player:
	self.id = id
	self.position = position
	self.name = name
	self.real_team = real_team
	self.mfv = mfv
	self.price = price
	self.price_initial = price_initial
	self.price_current = price_current
	
	return self
