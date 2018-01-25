extends KinematicBody2D

# Based on
# https://github.com/kidscancode/godot_tutorials/blob/master/Godot101/Part%2012/player.gd

export (bool) var debug = true setget set_debug

onready var ground_ray = get_node("ground_ray")
onready var sprite = get_node("sprite")
onready var animation = get_node("anim")

const ACCEL = 1200
const MAX_SPEED = 100
const FRICTION = -500
const GRAVITY = 1000
const JUMP_SPEED = -420
const MAX_JUMP = 1000
const MIN_JUMP = -100
const VEL_X_EPSILON = 20
const VEL_Y_EPSILON = 0.001
const FLOOR_NORMAL = Vector2(0,-1)
const SLOPE_SLIDE_STOP = 25.0
const FALLING_ANIM_THRESHOLD = 200

enum states {JUMPING, FALLING, IDLE, WALKING}
const states_name = ["jumping", "falling", "idle", "walking"]

var acc = Vector2()
var vel = Vector2()
var anim = "idle"
var on_floor = false
var state = FALLING

var dbg_max = -MAX_JUMP * 10

func _ready():
	ground_ray.add_exception(self)	# Avoid raycast to collide with player
	set_debug(game.debug)
	set_fixed_process(true)
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("jump") and on_floor:
		vel.y = JUMP_SPEED
		state = JUMPING
	if event.is_action_released("jump"):
		vel.y = clamp(vel.y, MIN_JUMP, MAX_JUMP)
		state = FALLING

func _fixed_process(delta):
	acc.y = GRAVITY #if not on_floor else 0
	acc.x = Input.is_action_pressed("move_right") - Input.is_action_pressed("move_left")
	acc.x *= ACCEL
	if acc.x == 0:
		acc.x = vel.x * FRICTION * delta

	vel += acc * delta
	vel.x = clamp(vel.x, -MAX_SPEED, MAX_SPEED)
	#vel.y = clamp(vel.y, -MAX_JUMP, MAX_JUMP)

	var remain = move_and_slide(vel, FLOOR_NORMAL, SLOPE_SLIDE_STOP)
	var rdiff = remain - vel
	on_floor = is_move_and_slide_on_floor()

	if abs(vel.x) < VEL_X_EPSILON:
		vel.x = 0
	if abs(vel.y) < VEL_Y_EPSILON:
		vel.y = 0

	# Avoid sudden imediate falls when falling from a block due
	# high speed accumulated on velocity due the integration of acceleration
	if on_floor and (state==IDLE or state==WALKING):
		vel.y = 0

	# Avoid when hitting on the block the player stays still for a while
	# waiting the jump speed to get down
	if rdiff.y > 0:
		vel.y = 0

	if on_floor:
		if vel.x == 0:
			state = IDLE
			vel.y = 0
		else:
			state = WALKING
	else: # on_air
		if vel.y < 0:
			state = JUMPING
		else:
			state = FALLING

	# set animation
	if vel.x >= 0:
		sprite.set_flip_h(false)
	elif vel.x < 0:
		sprite.set_flip_h(true)

	anim = states_name[state]
	if state==FALLING: 
		if vel.y > FALLING_ANIM_THRESHOLD:
			anim = "falling"
		elif vel.x != 0:
			anim = "walking"
	change_anim(anim)
	

	# DBG
	if not debug: return
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
		if ground_ray.is_colliding() == on_floor
		else Color(1,0,0,1) )
	get_node("DBG/left_bottom_square").set_color(
		Color(1,0,0,1)
		if is_move_and_slide_on_wall()
		else Color(0,0,0,0) )
	get_node("DBG/right_bottom_square").set_color(
		Color(1,0,0,1)
		if is_move_and_slide_on_ceiling()
		else Color(0,0,0,0) )

	get_node("DBG/up1_label").set_text(anim + " / " + states_name[state])
	get_node("DBG/up2_label").set_text("A "+str(acc))
	get_node("DBG/up3_label").set_text("V "+str(vel))
	get_node("DBG/up4_label").set_text("R "+str(remain))
	get_node("DBG/up5_label").set_text("D "+str(rdiff))
	get_node("DBG/graph").add(vel.y)
	get_node("DBG/graph2").add(rdiff.y)
	if vel.y > dbg_max:
		dbg_max = vel.y
	if vel.y < dbg_max:
		print("VEL TURN: ", dbg_max)
		dbg_max = -MAX_JUMP*10

func change_anim(anim):
	var current = animation.get_current_animation()
	if anim != current:
		if debug:
			print("Changing anim: ", current, " -> ", anim)
			print("Vel: ", vel)
		animation.play(anim)

func set_debug(value):
	debug = value
	if has_node("DBG") and get_node("DBG"):
		get_node("DBG").set_hidden(not value)