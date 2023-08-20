# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.com>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Team

const SIZE:Dictionary = {
	"P" : 3,
	"D" : 8,
	"C" : 8,
	"A" : 6
}

var name:String
var budget:int

func set_up(name:String) -> Team:
	self.name = name
	self.budget = Config.BUDGET
	return self
