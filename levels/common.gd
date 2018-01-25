extends Node2D


export (bool) var debug = true setget set_debug

onready var game = get_node("/root/game")
onready var player = get_node("player")


# For debug
onready var volume_dbg = get_node("HUD/volume_dbg")
onready var bg_music = get_node("bg_music")
var vol
var vol_db

func _ready():
	set_process(debug)
	game.update_volume()

func _process(delta):
	_update_dbg_info()

func _update_dbg_info():
	vol = bg_music.get_volume()
	vol_db = bg_music.get_volume_db()
	volume_dbg.set_text(str(vol)+"\n"+str(vol_db)+"db")

func set_debug(value):
	debug = value
	if player and "debug" in player: player.debug = debug
	if has_node("background/background") and \
	   get_node("background/background"):
		get_node("background/background").set_hidden(debug)
	if has_node("HUD/volume_dbg") and \
	   get_node("HUD/volume_dbg"):
		get_node("HUD/volume_dbg").set_hidden(not debug)
	if has_node("HUD/level_dbg") and \
	   get_node("HUD/level_dbg"):
		get_node("HUD/level_dbg").set_hidden(not debug)
	set_process(debug)