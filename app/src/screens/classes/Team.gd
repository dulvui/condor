# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Team

const SIZE:Dictionary = {
	"P" : 3,
	"D" : 8,
	"C" : 8,
	"A" : 6
}

var name:String
var id:int
var budget:int

func set_up(name:String, id:int) -> Team:
	self.name = name
	self.id = id
	self.budget = Config.BUDGET
	return self
