extends KinematicBody2D

const ACCEL = 1500
const MAX_VEL = 500
const FRICTION = 500

var acc = Vector2()
var vel = Vector2()

func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	acc.x = Input.is_action_pressed("move_right") - Input.is_action_pressed("move_left")
	acc *= ACCEL
	vel.x += acc.x * delta
	vel.x = clamp(vel.x, -MAX_VEL, MAX_VEL)
	move(vel * delta)