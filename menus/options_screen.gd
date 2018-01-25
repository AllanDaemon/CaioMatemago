extends CanvasLayer

var game

func _enter_tree():
	game = get_node("/root/game")

func _ready():
	set_process_input(true)
	_init_scene_ctl()

func _input(ev):
	if ev.is_action_pressed("menu") and not ev.is_echo():
		get_tree().set_input_as_handled()
		_on_resume()

func _init_scene_ctl(div=5):
	var scene_ctl = get_node("screen_panel/scene_ctl")
	var level_ctl = get_node("screen_panel/level_ctl")
	for n in range(game.scenes_name.size()):
		if n < div:
			scene_ctl.add_item(game.scenes_name[n], n)
		else:
			level_ctl.add_item(game.scenes_name[n], n)

func _on_scene_select(value, offset=0):
	printt("Debug scene selection:", value, offset, offset+value)
	game.change_level(game.scenes_name[offset+value])

func _on_quit_level():
	game.on_menu = false
	game.change_level_smooth("intro")

func _on_resume():
	game.on_menu = false

func _on_debug( pressed ):
	prints("DEBUG Pressed:", pressed)
	game.debug = pressed

func _on_bg_slider( value ):
	game.volume_bg = value/100
	update_values()

func _on_fx_slider( value ):
	game.volume_fx = value/100
	update_values()

func update_values():
	get_node("screen_panel/debug_btn").set_pressed(game.debug)
	var bg = int(game.volume_bg*100)
	var fx = int(game.volume_fx*100)
	get_node("screen_panel/volume_control/bg/bg_volume").set_text(str(bg))
	get_node("screen_panel/volume_control/bg_slider").set_value(bg)
	get_node("screen_panel/volume_control/fx/fx_volume").set_text(str(fx))
	get_node("screen_panel/volume_control/fx_slider").set_value(fx)
	game.volume_update()
