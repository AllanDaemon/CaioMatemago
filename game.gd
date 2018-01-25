extends Node

# GAME GLOBAL SINGLETON

var score = 0
signal update_score

signal update_level

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
var current_scene_name
var playing
var paused = false setget _set_pause_state
var on_menu = false setget _set_menu_state

var menu_scene
var game_scene


const scenes_name = [
	"intro",
	"options",
	"splash",
	"credits",
	"test",
	"level_A1",
	"level_A2",
	"level_A3",
	"level_A4",
	"level_A5"
]

export (String) var main_scene_name = "level_A1"

var levels_scenes_pack = {
	"intro":	preload("res://menus/initial_screen.tscn"),
	"options":	preload("res://menus/options_screen.tscn"),
	"splash":	preload("res://menus/splash_screen.tscn"),
	"credits":	preload("res://menus/credits_screen.tscn"),
	"test":		preload("res://game_test.tscn"),
	"level_A1":	preload("res://levels/level_A1.tscn"),
	"level_A2":	preload("res://levels/level_A2.tscn"),
	"level_A3":	preload("res://levels/level_A3.tscn"),
	"level_A4":	preload("res://levels/level_A4.tscn"),
	"level_A5":	preload("res://levels/level_A5.tscn"),
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
	update_volume()

func _input(ev):
	if ev.is_action_pressed("menu") or ev.is_action_pressed("ui_cancel") \
		and not ev.is_echo():
		_set_menu_state(not on_menu)
	if ev.is_action_pressed("debug") and not ev.is_echo():
		_set_debug(not debug)
	if ev.is_action_pressed("pause") and not ev.is_echo():
		_set_pause_state(not paused)
	if ev.is_action_pressed("quit") and not ev.is_echo():
		quit()
	
	if ev.type == InputEvent.KEY:
		var key2level = {
			KEY_QUOTELEFT: "intro",
			KEY_1: "level_A1",
			KEY_2: "level_A2",
			KEY_3: "level_A3",
			KEY_4: "level_A4",
			KEY_5: "level_A5",
			KEY_6: "credits",
			KEY_7: "options",
			KEY_8: "splash",
			KEY_0: "test" }
		if ev.scancode in key2level:
			prints("Debug level changing to", key2level[ev.scancode], ":", ev.scancode)
			change_level(key2level[ev.scancode])

############## INTERNAL STATES ##############

func _set_pause_state(value):
	prints("PAUSE:", value)
	paused = value
	tree.set_pause(paused)
#	if current_level.has_node("HUD/pause_overlay"):
#		current_level.get_node("HUD/pause_overlay").set_hidden(
#			paused and not debug and not on_menu)

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
	var debug_objs = tree.get_nodes_in_group("debug")
	debug = value
	for obj in debug_objs:
		if obj and "debug" in obj:
			obj.debug = value

func update_volume():
	var bgs = tree.get_nodes_in_group("bg_sound")
	for node in bgs:
		var vol = volume_bg
		if "max_volume" in node:
			vol *= node.max_volume
		node.set_volume(vol)

func change_level(level):
	prints("Change level:", level)
	current_scene_name = level
	tree.change_scene_to(levels_scenes_pack[current_scene_name])
	current_scene = tree.get_current_scene()
	current_level = current_scene
	set_process_input(level!="intro")
	emit_signal("update_level", level)

func change_level_smooth(level, transition_duration=0.5):
	change_level(level)

func quit():
	tree.quit()

############## GAME LOGIC ##############

func coin_up(value):
	score += score_value_coin * value
	emit_signal("update_score")
