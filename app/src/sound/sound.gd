# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node2D

@onready var bip_sound:AudioStreamPlayer = $Bip
#@onready var final_sound:AudioStreamPlayer = $Final

var counter:int = 3
var playing:bool = false

func countdown(time_left:float) -> void:
	if not playing:
		if time_left < counter:
			counter -= 1
			playing = true
			#bip_sound.play()
		elif time_left > 4:
			counter = 3

func final() -> void:
	pass
	#final_sound.play()

func _on_bip_finished() -> void:
	playing = false
