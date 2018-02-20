extends Node2D

const coins_total = 41

onready var common = get_node("common")
onready var coins = common.get_node("coins")
onready var display = common.get_node("questions/question1_display")
#onready var question1 = common.get_node("questions/question_group1")
onready var question2 = common.get_node("questions/question_group2")
onready var wall = common.get_node("blocks/wall")
onready var bridge = common.get_node("blocks/bridge")
onready var door = common.get_node("math/door")

func _ready():
	_setup_coins()
	question2.connect("right_operation", self, "activate_bridge")
	question2.connect("right_operation", door, "open")

func activate_bridge():
	printt("Activating bridge")
	for block in bridge.get_children():
		block.enabled = true

func _setup_coins():
	assert(coins.get_child_count() == coins_total)
	for coin in coins.get_children():
		coin.connect("coin", self, "coin_up")

func coin_up(up=1):
	display.value += up
	if display.value == coins_total:
		question1_right()
	var brick = wall.get_children()[-1]
	printt("Brick:", brick)
	wall.remove_child(brick)
	brick.queue_free()

func question1_right():
	display.right()
	wall.queue_free()