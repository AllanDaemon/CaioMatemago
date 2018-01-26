extends Label

export (int) var value = 42 setget set_value

onready var anim = get_node("anim")
# signal_emiter.connect("right", this_obj, "right)

func set_value(_value):
	value = _value
	set_text(str(value))
#
#func update_value(value):
#	set_text(str(value))

func right():
	anim.play("right")

func wrong():
	anim.play("wrong")

# debug, test
func _on_test_btn_toggled( pressed ):
	if pressed: right()
	else: wrong()
