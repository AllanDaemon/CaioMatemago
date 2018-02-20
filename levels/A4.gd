extends Node2D

onready var common = get_node("common")
onready var question1 = common.get_node("questions/question_group1")
onready var question2 = common.get_node("questions/question_group2")
onready var wall = common.get_node("blocks/wall")
onready var bridge = common.get_node("blocks/bridge")

func _ready():
	question1.connect("right_operation", wall, "queue_free")
	question2.connect("right_operation", self, "activate_bridge")

func activate_bridge():
	printt("Activating bridge")
	for block in bridge.get_children():
		block.enabled = true