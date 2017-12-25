extends KinematicBody2D

# Based on
# https://github.com/kidscancode/godot_tutorials/blob/master/Godot101/Part%2012/player.gd


onready var ground_ray = get_node("ground_ray")
onready var sprite = get_node("sprite")
onready var animation = get_node("anim")

const ACCEL = 1200
const MAX_SPEED = 100
const FRICTION = -500
const GRAVITY = 1000
const JUMP_SPEED = -420
const MIN_JUMP = -100
const VEL_X_EPSILON = 20
const VEL_Y_EPSILON = 0.001
const FLOOR_NORMAL = Vector2(0,-1)
const SLOPE_SLIDE_STOP = 25.0

var acc = Vector2()
var vel = Vector2()
var anim = "idle"
#@TODO Use enums
var on_floor = false
var on_air = true
var jumping = false
var falling = true

func _ready():
	ground_ray.add_exception(self)	# Avoid cast collide with player
	set_fixed_process(true)
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("jump") and ground_ray.is_colliding():
		vel.y = JUMP_SPEED
	if event.is_action_released("jump"):
		vel.y = clamp(vel.y, MIN_JUMP, vel.y)

func _fixed_process(delta):
	acc.y = GRAVITY
	acc.x = Input.is_action_pressed("move_right") - Input.is_action_pressed("move_left")
	acc.x *= ACCEL
	if acc.x == 0:
		acc.x = vel.x * FRICTION * delta

	vel += acc * delta
	vel.x = clamp(vel.x, -MAX_SPEED, MAX_SPEED)

#	var motion = move(vel * delta)
#	if is_colliding():
#		var n = get_collision_normal()
#		motion = n.slide(motion)
#		vel = n.slide(vel)
#		move(motion)
	
	var motion = move_and_slide(vel, FLOOR_NORMAL, SLOPE_SLIDE_STOP)

	if abs(vel.x) < VEL_X_EPSILON:
		#print("Still needs it XXX")
		vel.x = 0
	if abs(vel.y) < VEL_Y_EPSILON:
		#print("Still needs it YYY")
		vel.y = 0

	# set animation
	if vel.x >= 0:
		sprite.set_flip_h(false)
	elif vel.x < 0:
		sprite.set_flip_h(true)

	if vel.x == 0:
		anim = "idle"
	else:
		anim = "walking"

	if abs(vel.y) < VEL_Y_EPSILON:
		#print("Still needs it YYY")
		vel.y = 0

	if vel.y < 0:
		anim = "jumping"
	#elif vel.y > 0 and not ground_ray.is_colliding():
	elif vel.y > 0 and not is_move_and_slide_on_floor():
		anim = "falling"

	change_anim(anim)
	
	# DBG
	var raycast_dbg_color
	if ground_ray.is_colliding():	raycast_dbg_color = Color(.5,1,.5)
	else: 							raycast_dbg_color = Color(.5,.5,1)
	#get_node("DBG/anim_label").add_color_override("font_color", raycast_dbg_color)
	get_node("DBG/left_square").set_color(raycast_dbg_color)
	get_node("DBG/right_square").set_color(
		Color(.5,1,.5)
		if is_move_and_slide_on_floor()
		else Color(.5,.5,1) )
	get_node("DBG/right_middle_square").set_color(
		Color(0,0,0,0)
		if ground_ray.is_colliding() == is_move_and_slide_on_floor()
		else Color(1,0,0,1) )

	get_node("DBG/anim_label").set_text(anim)
	get_node("DBG/vel_label").set_text(str(vel))
	get_node("DBG/acc_label").set_text(str(acc))

func change_anim(anim):
	var current = animation.get_current_animation()
	if anim != current:
		print("Changing anim: ", current, " -> ", anim)
		print("Vel: ", vel)
		animation.play(anim)