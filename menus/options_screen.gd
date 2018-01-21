extends CanvasLayer

var game

func _enter_tree():
	game = get_node("/root/game")

func _ready():
	set_process_input(true)

func _input(ev):
#	print ("action")
	if ev.is_action_pressed("menu") and not ev.is_echo():
#		prints("MENUUUUU", ev)
		get_tree().set_input_as_handled()
		_on_resume()

func _on_resume():
	game.on_menu = false

func _on_debug( pressed ):
	prints("DEBUG Pressed:", pressed)
	game.DEBUG = pressed

func _on_bg_slider( value ):
	game.volume_bg = value/100
	update_values()

func _on_fx_slider( value ):
	game.volume_fx = value/100
	update_values()

func update_values():
	get_node("screen_panel/debug_control/debug_btn").set_pressed(game.DEBUG)
	var bg = int(game.volume_bg*100)
	var fx = int(game.volume_fx*100)
	get_node("screen_panel/volume_control/bg/bg_volume").set_text(str(bg))
	get_node("screen_panel/volume_control/bg_slider").set_value(bg)
	get_node("screen_panel/volume_control/fx/fx_volume").set_text(str(fx))
	get_node("screen_panel/volume_control/fx_slider").set_value(fx)
	game.volume_update()