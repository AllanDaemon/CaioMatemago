tool
extends Control

var character = "Prof. Candango"
var lines = [
	"Ei, garoto! Cuidado com o buraco.\nO vale da soma é um lugar perigoso,",
	"não se esqueça de saltar obstáculos\ne inimigos se quiser sobreviver.",
]

var lines_alt = [
	["Ei, garoto! Cuidado com o buraco.",
	"O vale da soma é um lugar perigoso,"],
	["não se esqueça de saltar obstáculos",
	"e inimigos se quiser sobreviver."],
]

var curr_line = lines[1]

onready var char_label = get_node("char_label")
onready var text_label = get_node("frame/text_label")
onready var anim = get_node("anim")


func _ready():
#	_update()
#	show_text(lines)
	pass

func _update():
	_update_char()
	_update_text()
	
func _update_char():
	char_label.set_text(character)

func _update_text(play_anim=false):
	text_label.set_text(curr_line)
	get_node("anim").play("show_line")

func show_line(line, char=null):
	if char:
		character = char
		_update_char()

	curr_line = line
	_update_text(true)

func show_text(_lines, char=null):
	lines = _lines
	for line in lines:
		show_line(line, char)
		yield(anim, "finished")