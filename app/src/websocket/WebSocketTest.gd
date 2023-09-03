# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

const HOST:String = "ws://localhost:8000/"

@onready var client:Client = $Client
@onready var log_dest = $RichTextLabel
@onready var line_edit = $Panel/VBoxContainer/Send/LineEdit

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass

func info(msg):
	print(msg)
	log_dest.add_text(str(msg) + "\n")

func _on_client_connected_to_server() -> void:
	print("connected to server")


func _on_client_connection_closed() -> void:
	print("connection to server closed")


func _on_client_message_received(message) -> void:
	print("message recieved %s"%message)


func _on_connect_toggled(button_pressed: bool) -> void:
	if not button_pressed:
		client.close()
		return
	if HOST == "":
		return
	info("Connecting to host: %s." % [HOST])
	var err = client.connect_to_url(HOST)
	if err != OK:
		info("Error connecting to host: %s" % [HOST])
		return


func _on_send_pressed() -> void:
	var err:int = client.send("test")
	
	if err != OK:
		print("error sending message")
	print("message sent")
