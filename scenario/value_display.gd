extends Label

onready var anim = get_node("anim")
# signal_emiter.connect("right", this_obj, "right)

func update_value(value):
	set_text(str(value))

func right():
	anim.play("right")

func wrong():
	anim.play("wrong")

# debug, test
func _on_test_btn_toggled( pressed ):
	if pressed: right()
	else: wrong()
