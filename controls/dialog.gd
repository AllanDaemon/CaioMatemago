tool
extends Control

var character = "Prof. Candango"
var lines = [
	"Ei, garoto! Cuidado com o buraco.\nO vale da soma é um lugar perigoso,",
	"não se esqueça de saltar obstáculos\ne inimigos se quiser sobreviver.",
]
var curr_line = "Unitialized"

onready var char_label = get_node("char_label")
onready var text_label = get_node("frame/text_label")
onready var anim = get_node("anim")


func _ready():
#	_update()
#	show_text(lines)
#	set_process_input(true)
	pass

func _input(ev):
	if ev.is_action_pressed("jump") and not ev.is_echo():
		get_tree().set_input_as_handled()
		next_line()

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
	set_process_input(true)
	next_line(char)
#	for line in lines:
#		show_line(line, char)
#		yield(anim, "finished")

func next_line(char=null):
	print("Next line")
	if lines.size()==0:
		set_process_input(false)
		print("Text finished")
		return
	print("goto next line")
	var line = lines[0]
	lines.pop_front()
	show_line(line, char)
	