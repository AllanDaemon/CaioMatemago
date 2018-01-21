tool
extends Area2D

signal coin

var testing = false

func _ready():
	testing = get_tree().get_root() == get_parent()
	if testing:
		get_node("test_camera").make_current()
		get_node("test_timer").start()

func _get_item_rect():
    return get_node("sprite").get_item_rect()
	
func _on_coin_body_enter( body ):
	if body.is_in_group("player"):
		hit()

func hit():
	get_node("anim").play("disapear")
	emit_signal("coin", 1)