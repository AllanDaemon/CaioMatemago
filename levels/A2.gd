extends Node2D

onready var common = get_node("common")
onready var boxp1 = common.get_node("boxes/box+1")
onready var boxm1 = common.get_node("boxes/box-1")

const bblock_max = 7
var bblock_count = 0

func _ready():
	boxp1.connect("value_change", self, "_on_value_change")
	boxm1.connect("value_change", self, "_on_value_change")
	
func _on_value_change(value):
	bblock_count += value
	update_blocks()

func update_blocks():
	printt("Bubble block count", bblock_count)