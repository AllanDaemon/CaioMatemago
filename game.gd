extends Node

# GAME GLOBAL SINGLETON

var score = 0

## SETTINGS

var sound_bg = 1.0
var sound_fx = 1.0

## States

onready var tree = get_tree()
onready var root = get_tree().get_root()
var current_level
var current_scene
var playing
var paused = false setget _set_pause_state
var on_menu = false setget _set_menu_state

var menu_scene
var game_scene

onready var option_scene_pkg = preload("res://menus/options_screen.tscn")
onready var option_scene = option_scene_pkg.instance()

func _ready():
	current_level = tree.get_current_scene()	#game test
	current_scene = current_level

func _set_pause_state(value):
	prints("PAUSE:", value)
	paused = value
	tree.set_pause(paused)

func _set_menu_state(value):
	if value != on_menu:
		on_menu = value
		if value == true:
			_open_options_menu()
		else:
			_close_options_menu()

func toogle_options_menu():
	_set_menu_state(not on_menu)
#	on_menu = not on_menu

func _open_options_menu():
	print("Opening menu")
	_set_pause_state(true)
#	paused = true
#	tree.set_pause(paused)
	root.add_child(option_scene)
	

func _close_options_menu():
	print("Closing menu")
	root.remove_child(option_scene)
	_set_pause_state(false)
#	paused = false
#	tree.set_pause(paused)
