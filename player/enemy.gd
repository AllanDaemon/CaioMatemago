extends RigidBody2D

export (int) var speed = 100
export (Vector2) var movement = Vector2(1, 1)	# Pixel / secs
export (bool) var enable_on_tool = false

onready var sprite = get_node("sprite_anim")

func _ready():
#	set_fixed_process(true)
	pass

func _fixed_process(delta):
	var remain = move(movement * speed * delta)
	if remain.x:
		movement.x *= -1
		sprite.set_flip_h( movement.x > 0)

#func _integrate_forces(state):
#	pass
	