extends Node2D

signal right
signal wrong

onready var boxes = get_node("boxes")
onready var question = get_node("question")

var result = 0

func _ready():
	print("Boxes: ", boxes)
	for box in boxes.get_children():
		print("box: ", box)
		box.connect("value_change", self, "_on_value_change")
		box.connect("result", self, "_on_result")
	pass

func _on_value_change(value):
	print("Change: ", value)
	result += value
	_update_label()
	
func _update_label():
	get_node("result").set_text(str(result))
	
func _on_result():
	if result == question.result:
		emit_signal("right")
	else:
		emit_signal("wrong")

func right():
	pass
	
func wrong():
	pass