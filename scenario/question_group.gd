tool
extends Node2D

signal right_operation

export (bool) var disable_on_any_result = false
export (bool) var disable_on_wrong_result = false
export (bool) var disable_on_right_result = true
export (int) var a = 1
export (int) var b = 2
export (String, "+", "-", "x") var operator = "+"

enum stati {UNTOUCHED, UNANSWERED, WRONG, RIGHT}
var status = UNTOUCHED
var enabled = true setget _set_enabled
var result = -1


onready var game = get_node("/root/game")
onready var boxes = get_node("boxes")
onready var question = get_node("question")
onready var display = get_node("value_display")
onready var _pos_ready = true

func _ready():
	print("Boxes: ", boxes)
	for box in boxes.get_children():
		box.connect("value_change", self, "_on_value_change")
	update_question()

func _set_enabled(value):
	enabled = value
	var boxes = get_node("boxes")
	boxes.set_opacity( 1 if enabled else 0.5 )

func _on_value_change(value):
	print("Change: ", value)
	if not enabled: return
	display.value += value
	if status == UNTOUCHED: status = UNANSWERED

func _on_result():
	print("Calculating result")
	if not enabled: return
	if disable_on_any_result: self.enabled = false
	if display.value == result:
		right()
	else:
		wrong()

func right():
	if disable_on_right_result: self.enabled = false
	status = RIGHT
	display.right()
	game.operation_right()
	emit_signal("right_operation")

func wrong():
	if disable_on_wrong_result: self.enabled = false
	status = WRONG
	display.wrong()
	game.operation_wrong()
	
func update_question(reset_display=true):
	question.question = str(a)+" "+operator+" "+str(b)
	result = calc_result()
	self.enabled = true
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
