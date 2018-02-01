extends RigidBody2D

export (bool) var can_fall = false
enum states {IDLE, WALKING, FALLING, DYING}
export (int, "IDLE", "WALKING", "FALLING", "DYING") \
		var default_state = WALKING
var state = default_state
enum directions {LEFT, RIGHT}
const opposite = {LEFT: RIGHT, RIGHT: LEFT}
var default_direction = RIGHT # Exportig fails... 
var direction = -1 setget set_direction
const default_velocity = Vector2(50, 0)
const direction_x_vel = {
	LEFT: default_velocity.x *  1,
	RIGHT: default_velocity.x * -1}
const direction_flipped_h = {LEFT: true, RIGHT: false}

onready var raycasts_floor = get_node("raycasts_floor")
onready var raycasts_wall = get_node("raycasts_wall")
onready var sprite = get_node("sprite_anim")

const cooldown_value = 10
var cooldown = 0

func _ready():
	set_direction(opposite[default_direction])
	set_fixed_process(true)

func _integrate_forces(s):
	pass

func _should_change_direction():
	if cooldown:
		cooldown -= 1
		return false
	if not can_fall:
		var some_hit = false
		var none_hit = true
		for ray in raycasts_floor.get_children():
			if not ray.is_colliding():
				some_hit = true
			else:
				none_hit = false
		if none_hit:
			state = FALLING
			return false
		if some_hit or state==FALLING:
			state = default_state
			return true
	for ray in raycasts_wall.get_children():
		if ray.is_colliding():
			return true
	return false

func _fixed_process(delta):
	if _should_change_direction():
		cooldown = cooldown_value
		change_direction()	

func change_direction(to=LEFT):
	set_direction(opposite[direction])

func set_direction(to=LEFT):
	if to == direction:
		return
	direction = to
	sprite.set_flip_h(direction_flipped_h[to])
	var vel = Vector2(direction_x_vel[to], get_linear_velocity().y)
	set_linear_velocity(vel)

func hit():
	state = DYING