extends Node2D

signal interaction_end

onready var dialog = get_node("dialog")
onready var lines_load = get_node("/root/lines")
onready var line = lines_load.bossA5a

func _ready():
	first_interaction()

func first_interaction():
	dialog.show()
	dialog.show_text(line, "Rei Belingerante")
	print("Before yield")
	yield(dialog, "lines_end")
	print("After yield")
	emit_signal("interaction_end")
	return