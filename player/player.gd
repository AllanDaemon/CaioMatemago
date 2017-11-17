extends KinematicBody2D

# Based on
# https://github.com/kidscancode/godot_tutorials/blob/master/Godot101/Part%2012/player.gd


onready var ground_ray = get_node("ground_rays/ray_2")
onready var ground_rays = get_node("ground_rays")
onready var ground_detector = get_node("ground_detector")
onready var sprite = get_node("sprite")
onready var animation = get_node("anim")

const ACCEL = 600
const MAX_SPEED = 100
const FRICTION = -500
const GRAVITY = 1000
const JUMP_SPEED = -420
const MIN_JUMP = -100

var acc = Vector2()
var vel = Vector2()
var anim = "idle"

func _ready():
	for ray in ground_rays.get_children():
		ray.add_exception(self)

	set_fixed_process(true)
#	set_process_input(true)

func _input(event):

	if event.is_action_pressed("jump") and ground_ray.is_colliding():
		vel.y = JUMP_SPEED
	if event.is_action_released("jump"):
		vel.y = clamp(vel.y, MIN_JUMP, vel.y)


func _fixed_process(delta):
	move( Vector2(
		Input.is_action_pressed("ui_right") - Input.is_action_pressed("ui_left"),
		Input.is_action_pressed("ui_down") - Input.is_action_pressed("ui_up")) * 0.2)

func _fixed_process2(delta):
	acc.y = GRAVITY
	acc.x = Input.is_action_pressed("move_right") - Input.is_action_pressed("move_left")
	acc.x *= ACCEL
	if acc.x == 0:
		acc.x = vel.x * FRICTION * delta

	vel += acc * delta
	vel.x = clamp(vel.x, -MAX_SPEED, MAX_SPEED)

	var motion = move(vel * delta)
	if is_colliding():
		var n = get_collision_normal()
		motion = n.slide(motion)
		vel = n.slide(vel)
		move(motion)
	if abs(vel.x) < 20:
		vel.x = 0

	# set animation
	if vel.x == 0:
		anim = "idle"
	else:
		anim = "walking"
	if vel.x > 0:
		sprite.set_flip_h(false)
	elif vel.x < 0:
		sprite.set_flip_h(true)
	animation.play(anim)
