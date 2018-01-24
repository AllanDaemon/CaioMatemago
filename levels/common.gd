extends Node2D


export (bool) var debug = true setget set_debug

onready var game = get_node("/root/game")
onready var player = get_node("player")


# For debug
onready var volume_dbg = get_node("HUD/volume_dbg")
onready var bg_music = get_node("bg_music")
var vol
var vol_db

func set_debug(value):
	debug = value
	if player and "debug" in player: player.debug = debug
	if has_node("background/background") and \
	   get_node("background/background"):
		get_node("background/background").set_hidden(debug)
	if has_node("HUD/volume_dbg") and \
	   get_node("HUD/volume_dbg"):
		get_node("HUD/volume_dbg").set_hidden(not debug)
