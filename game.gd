extends Node

# GAME GLOBAL SINGLETON

var score = 0
signal score_changed

## SETTINGS
export (String) var initial_level = "teste"
export (float, 0, 1) var volume_bg = 0.5
export (float, 0, 1) var volume_fx = 0.5
export (bool) var debug = false setget _set_debug

export (int) var score_value_coin = 10
export (int) var score_value_right_op = 100
export (int) var score_value_wrong_op = 10
export (int) var score_value_enemy = 50
export (int) var score_value_boss = 1000


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


export (String) var main_scene_name = "test"

var levels_scenes_pack = {
	"intro":	preload("res://menus/initial_screen.tscn"),
	"options":	preload("res://menus/options_screen.tscn"),
	"splash":	preload("res://menus/splash_screen.tscn"),
	"credits":	preload("res://menus/credits_screen.tscn"),
	"test":		preload("res://game_test.tscn"),
#	"level_A1":	preload(""),
#	"level_A2":	preload(""),
#	"level_A3":	preload(""),
#	"level_Aboss":	preload(""),
}
var option_scene = levels_scenes_pack["options"].instance()


############## DEFAULT METHODS ##############

func _ready():
	levels_scenes_pack["main"] = levels_scenes_pack[main_scene_name]
	current_level = tree.get_current_scene()	# it's game test by now
	current_scene = current_level
	set_process_input(true)
	_init_defaults()

func _init_defaults():
	_set_debug(debug)

func _input(ev):
	if ev.is_action_pressed("menu") and not ev.is_echo():
		_set_menu_state(not on_menu)
	if ev.is_action_pressed("debug") and not ev.is_echo():
		_set_debug(not debug)
	if ev.is_action_pressed("pause") and not ev.is_echo():
		_set_pause_state(not paused)


############## INTERNAL STATES ##############

func _set_pause_state(value):
	prints("PAUSE:", value)
	paused = value
	tree.set_pause(paused)
	if current_level.has_node("HUD/pause_overlay"):
		current_level.get_node("HUD/pause_overlay").set_hidden(
			paused and not debug and not on_menu)

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
	var debug_objs = tree.get_nodes_in_group("debug")
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

func change_level(level):
	prints("Change level:", level)
	var new_scene = levels_scenes_pack[level]
	tree.change_scene_to(new_scene)

func change_level_smooth(level, transition_duration=0.5):
	prints("Change level smooth:", level)
	var new_scene = levels_scenes_pack[level]
	# Implement manual change with opacity transition
	tree.change_scene_to(new_scene)

############## GAME LOGIC ##############

func coin_up(value):
	score += score_value_coin * value
	emit_signal("score_changed")
