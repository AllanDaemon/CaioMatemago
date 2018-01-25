extends Node2D

signal right
signal wrong

onready var game = get_node("/root/game")
onready var common = get_node("common")

onready var boxes = get_node("boxes")

onready var question = get_node("question")
onready var result_label = get_node("result")

var current_result = 0

func _ready():
	question.connect("right", result_label, "right")
	question.connect("wrong", result_label, "wrong")

	print("Boxes: ", boxes)
	for box in boxes.get_children():
		print("box: ", box)
		box.connect("value_change", self, "_on_value_change")
	pass

func _on_value_change(value):
	print("Change: ", value)
	current_result += value
	_update_label()
	
func _update_label():
	result_label.set_text(str(current_result))
	
func _on_result():
	print("Calculating result")
	if current_result == question.result:
		emit_signal("right")
	else:
		emit_signal("wrong")