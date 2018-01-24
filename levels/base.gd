extends Node2D

export (bool) var debug = true setget set_debug

onready var common = get_node("common")

func set_debug(value):
	debug = value
	if common and "debug" in common: common.debug = value

