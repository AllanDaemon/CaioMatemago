extends KinematicBody2D

export (Vector2) var movement = Vector2(1, 0)	# Pixel / secs
export (bool) var enable_on_tool = false

onready var sprite = get_node("sprite_anim")

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	var remain = move(movement * delta)
	if remain:
		movement *= -1
		sprite.set_flip_h( movement.x > 0)

	