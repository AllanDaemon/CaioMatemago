extends Node

# GAME GLOBAL SINGLETON

var score = 0

## SETTINGS

export (float, 0, 1) var volume_bg = 0.5
export (float, 0, 1) var volume_fx = 0.5
export (bool) var debug = false setget _set_debug

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
	set_process_input(true)
	current_level = tree.get_current_scene()	# it's game test by now
	current_scene = current_level
	_init_defaults()

func _init_defaults():
	_set_debug(debug)

func _input(ev):
	if ev.is_action_pressed("menu") and not ev.is_echo():
		_set_menu_state(not on_menu)
	if ev.is_action_pressed("debug") and not ev.is_echo():
		_set_debug(not debug)

func _set_pause_state(value):
#	prints("PAUSE:", value)
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

func _open_options_menu():
	print("Opening menu")
	_set_pause_state(true)
	root.add_child(option_scene)
	option_scene.update_values()

func _close_options_menu():
	print("Closing menu")
	root.remove_child(option_scene)
	_set_pause_state(false)

func _set_debug(value):
	var debug_objs = [current_level]
	debug = value
	for obj in debug_objs:
		if obj and "debug" in obj:
			obj.debug = value

func volume_update():
	var bgs = tree.get_nodes_in_group("bg_sound")
	for node in bgs:
		var vol = volume_bg
		if "max_volume" in node:
			vol *= node.max_volume
		node.set_volume(vol)