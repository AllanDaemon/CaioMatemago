tool
extends Control

var character = "Prof. Candango"
var lines = [
	"Ei, garoto! Cuidado com o buraco.\nO vale da soma é um lugar perigoso,",
	"não se esqueça de saltar obstáculos\ne inimigos se quiser sobreviver.",
]

var lines_alt = [
	["Ei, garoto! Cuidado com o buraco.", "O vale da soma é um lugar perigoso,"],
	["não se esqueça de saltar obstáculos", "e inimigos se quiser sobreviver."],
]

var curr_line = lines[1]

onready var char_label = get_node("char_label")
onready var text_label = get_node("frame/text_label")

func _ready():
	_update()

func _update():
	_update_char()
	_update_text()
	
func _update_char():
	char_label.set_text(character)

func _update_text(play_anim=false):
	text_label.set_text(curr_line)
	get_node("anim").play("show_line")

func show_text(line, char=null):
	if char:
		prints("Update char")
		character = char
		_update_char()
	else:
		prints("No update char")

	curr_line = line
	_update_text(true)