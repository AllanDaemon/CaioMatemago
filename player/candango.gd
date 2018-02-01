extends Area2D

signal npc_action

export (String) var lines_id = ""

onready var dialog = get_node("dialog")
onready var lines_load = get_node("/root/lines")
onready var lines = lines_load.lines_map[lines_id]

func _ready():
	connect("npc_action", self, "_on_npc_action")

func _on_player_near(body):
	printt("Player near", body)
	emit_signal("npc_action")

func _on_player_out(body):
	printt("Player far", body)
	dialog.hide()
	
func _on_npc_action():
	dialog.show()
	dialog.show_text(lines)