extends Node2D

onready var plus_btn = get_node("+1")

var result = 0


func _ready():
	pass
	#plus_btn.connect("value_change", self, "_on_value_change")

func _on_value_change(value):
	print("Change: ", value)
	result += value
	_update_label()
	
func _update_label():
	get_node("result").set_text(str(result))