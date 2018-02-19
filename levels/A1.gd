extends Node2D

onready var common = get_node("common")
onready var questions = common.get_node("questions")
onready var door = common.get_node("math/door")

func _ready():
	for q in questions.get_children():
		q.connect("right_operation", self, "_on_wright_operation")

func _on_wright_operation():
	for q in questions.get_children():
		print("RESULT:")
		if q.status != q.RIGHT:
			prints("\tWRONG")
			return
	prints("ALL WRIGHT")
	level_done()
	
func level_done():
	door.open = true