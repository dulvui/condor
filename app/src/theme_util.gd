# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node

const THEMES: Dictionary = {
	"MOBILE": "res://fanta_theme_mobile.tres",
	"DESKTOP": "res://fanta_theme.tres",
}

var active_theme: Theme


func _ready() -> void:
	set_active_theme(Config.theme_index)


func set_active_theme(index: int) -> Theme:
	Config.theme_index = index
	active_theme = ResourceLoader.load(THEMES.values()[Config.theme_index], "Theme")
	return active_theme


func get_active_theme() -> Theme:
	return active_theme


func get_theme_names() -> Array:
	return THEMES.keys()


func default_theme_index() -> int:
	if OS.get_name() in ["Android", "iOS"]:
		return 0
	return 1
