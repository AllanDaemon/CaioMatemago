extends Node2D

signal right
signal wrong

onready var boxes = get_node("scenario/boxes")
onready var question = get_node("HUD/question")
onready var result_anim = get_node("HUD/result_anim")

var result = 0

func _ready():
	print("Boxes: ", boxes)
	connect("right", self, "right")
	connect("wrong", self, "wrong")
	for box in boxes.get_children():
		print("box: ", box)
		box.connect("value_change", self, "_on_value_change")
	pass

func _on_value_change(value):
	print("Change: ", value)
	result += value
	_update_label()
	
func _update_label():
	get_node("HUD/result").set_text(str(result))
	
func _on_result():
	print("Calculatin result")
	if result == question.result:
		emit_signal("right")
	else:
		emit_signal("wrong")

func right():
	result_anim.play("right")
	
func wrong():
	result_anim.play("wrong")