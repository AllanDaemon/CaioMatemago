extends Node2D

#signal right
#signal wrong

onready var game = get_node("/root/game")
onready var boxes = get_node("boxes")
onready var question = get_node("question")
onready var display = get_node("value_display")

var current_result = 0

func _ready():
	print("Boxes: ", boxes)
	for box in boxes.get_children():
		box.connect("value_change", self, "_on_value_change")

func _on_value_change(value):
	print("Change: ", value)
	current_result += value
	display.update_value(current_result)

func _on_result():
	print("Calculating result")
	if current_result == question.result:
#		emit_signal("right")
		display.right()
	else:
#		emit_signal("wrong")
		display.wrong()
