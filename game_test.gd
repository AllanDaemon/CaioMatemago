extends Node2D

signal right
signal wrong

onready var game = get_node("/root/game")
onready var boxes = get_node("boxes")
onready var question = get_node("question")
onready var result_anim = get_node("HUD/result_anim")
onready var player = get_node("player")

var result = 0
export (bool) var DEBUG = true setget set_debug

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
	get_node("result").set_text(str(result))
	
func _on_result():
	print("Calculating result")
	if result == question.result:
		emit_signal("right")
	else:
		emit_signal("wrong")

func right():
	result_anim.play("right")
	
func wrong():
	result_anim.play("wrong")
	
func set_debug(value):
	DEBUG = value
	if player and "DEBUG" in player: player.DEBUG = DEBUG
	if has_node("background/background") and \
	   get_node("background/background"):
		get_node("background/background").set_hidden(DEBUG)