extends Node2D

onready var common = get_node("common")
onready var boxp1 = common.get_node("boxes/box+1")
onready var boxm1 = common.get_node("boxes/box-1")
onready var bblocks = common.get_node("math/bubble_blocks")
onready var value_display = common.get_node("math/value_display")

const bblock_max = 7
var bblock_count = 0

func _ready():
	boxp1.connect("value_change", self, "_on_value_change")
	boxm1.connect("value_change", self, "_on_value_change")
	_on_value_change(0)
	
func _on_value_change(value):
	bblock_count += value
	value_display.value = bblock_count
	if bblock_count == bblock_max:
		activate_bridge()

func activate_bridge():
	printt("Activating bridge", bblock_count)
	for block in bblocks.get_children():
		block.enabled = true