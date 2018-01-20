extends CanvasLayer

onready var game = get_node("/root/game")

func _ready():
	set_process_input(true)

func _input(ev):
	print ("action")
	if ev.is_action_pressed("menu") and not ev.is_echo():
		prints("MENUUUUU", ev)
		get_tree().set_input_as_handled()
		_on_resume()

func _on_resume():
	game.on_menu = false
#	game.close_options_menu()
