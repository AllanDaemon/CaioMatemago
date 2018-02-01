extends RigidBody2D

enum states {IDLE, WALKING, FALLING, DYING}
export (int, "IDLE", "WALKING", "FALLING", "DYING") \
				var default_state = WALKING
var state = default_state
export (bool) var can_fall = false
enum directions {LEFT, RIGHT}
const opposite= {LEFT: RIGHT, RIGHT: LEFT}
var direction = LEFT setget set_direction
var default_velocity = Vector2(-50, 0)
onready var raycasts_floor = get_node("raycasts_floor")
onready var raycasts_wall = get_node("raycasts_wall")
onready var sprite = get_node("sprite_anim")

func _ready():
	set_linear_velocity(default_velocity)
	set_fixed_process(true)

func _integrate_forces(s):
	pass

func _should_change_direction():
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
		change_direction()

func change_direction(to=LEFT):
	set_direction(opposite[direction])

func set_direction(to=LEFT):
	if to == direction:
		return
	direction = to
	sprite.set_flip_h(not sprite.is_flipped_h())
	set_linear_velocity(get_linear_velocity() * -1)

func hit():
	state = DYING