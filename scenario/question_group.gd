tool
extends Node2D

signal update_score

export (bool) var disable_on_result = true
export (int) var a = 1
export (int) var b = 2
export (String, "+", "-", "x") var operator = "+"

var result = -1
var enabled = true

onready var game = get_node("/root/game")
onready var boxes = get_node("boxes")
onready var question = get_node("question")
onready var display = get_node("value_display")

func _ready():
	print("Boxes: ", boxes)
	for box in boxes.get_children():
		box.connect("value_change", self, "_on_value_change")
	update_question()

func _on_value_change(value):
	print("Change: ", value)
	if not enabled: return
	display.value += value

func _on_result():
	print("Calculating result")
	if not enabled: return
	if disable_on_result: enabled = false
	if display.value == result:
		right()
	else:
		wrong()

func right():
	display.right()
	game.operation_right()

func wrong():
	display.wrong()
	game.operation_wrong()
	
func update_question(reset_display=true):
	question.question = str(a)+" "+operator+" "+str(b)
	result = calc_result()
	enabled = true
	if reset_display:
		display.value = 0

func calc_result():
	if operator == "+":
		return a + b
	if operator == "-":
		return a - b
	if operator == "*":
		return a * b
	if operator == "x":
		return a * b
	if operator == "/":
		return a / b
	if operator == ":":
		return a / b
	printerr("Unknown operator: ", operator)
	assert(false)
