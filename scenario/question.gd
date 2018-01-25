extends Control

signal right
signal wrong

export (String) var question = "1 + 2" setget _set_question
export (int) var result = 3

onready var label = get_node("Patch9Frame/Label")

func _ready():
	_set_question(question)
	
func _set_question(value):
	question = value
	if label:
		print("VALUE SET: ", value)
		label.set_text(value)