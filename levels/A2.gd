extends Node2D

onready var common = get_node("common")
onready var bblocks = common.get_node("math/bubble_blocks")
onready var question1 = common.get_node("questions/question_group")

func _ready():
	question1.connect("right_operation", self, "activate_bridge")
	
func activate_bridge():
	printt("Activating bridge")
	for block in bblocks.get_children():
		block.enabled = true