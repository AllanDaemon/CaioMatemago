tool
extends RigidBody2D

export (String, "green", "berigelante") var enemy_type = "green" setget _set_enemy_type

export (bool) var can_fall = false
enum states {IDLE, WALKING, FALLING, DYING}
export (int, "IDLE", "WALKING", "FALLING", "DYING") \
		var default_state = WALKING
const state_names = ["IDLE", "WALKING", "FALLING", "DYING"]
var state = -1 setget set_state
var state_name
enum directions {LEFT, RIGHT}
const opposite = {LEFT: RIGHT, RIGHT: LEFT}
const directions_name = {LEFT: "LEFT", RIGHT: "RIGHT"}
var default_direction = RIGHT # Exportig fails... 
var direction = -1 setget set_direction
const default_velocity = Vector2(50, 0)
const direction_x_vel = {
	LEFT: default_velocity.x *  1,
	RIGHT: default_velocity.x * -1}
const direction_flipped_h = {LEFT: true, RIGHT: false}

onready var raycasts_floor = get_node("raycasts_floor")
onready var raycasts_wall = get_node("raycasts_wall")
onready var anim = get_node("anim")
onready var fx_sounds = get_node("fx_sounds")
onready var sprite

const cooldown_value = 10
var cooldown = 0

func _ready():
	_setup_enemy_type()
	set_direction(opposite[default_direction])
	set_state()
	if not get_tree().is_editor_hint():
		set_fixed_process(true)

func _set_enemy_type(value):
	enemy_type = value
	_setup_enemy_type()

func _setup_enemy_type():
	if has_node("sprite_anim_" + enemy_type):
		get_node("sprite_anim_green").hide()
		get_node("sprite_anim_berigelante").hide()
		sprite = get_node("sprite_anim_" + enemy_type)
		if sprite: sprite.show()
		update()

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
			self.state = FALLING
			return false
		if some_hit or state==FALLING:
			self.state = default_state
			return true
	for ray in raycasts_wall.get_children():
		if ray.is_colliding():
			return true
	return false

func _fixed_process(delta):
	if _should_change_direction():
		cooldown = cooldown_value
		change_direction()
	if not cooldown:
		var vel = self.get_linear_velocity()
		if abs(vel.x / default_velocity.x) < 0.8:
			vel.x = direction_x_vel[direction]
			set_linear_velocity(vel)

func change_direction(to=LEFT):
	set_direction(opposite[direction])

func set_direction(to=LEFT):
	if to == direction: return
	direction = to
	sprite.set_flip_h(direction_flipped_h[to])
	var vel = Vector2(direction_x_vel[to], get_linear_velocity().y)
	set_linear_velocity(vel)
	var direction_name_lower = directions_name[direction].to_lower()
	for ray in raycasts_wall.get_children():
		ray.set_enabled(not ray.get_name().ends_with(direction_name_lower))


func set_state(value=default_state):
	if state == value: return
	if state == DYING: return
	state = value
	state_name = state_names[state]
	prints("Enemy", self, "\tState:", state_name)
	if fx_sounds.get_sample_library().has_sample(state_name):
		fx_sounds.play(state_name)
	if sprite.get_sprite_frames().has_animation(state_name):
		sprite.play(state_name)
	if anim.has_animation(state_name):
		anim.play(state_name)

func _on_body_hit(body):
	prints("Player hit test", body)
	if body and body.is_in_group("player"):
		prints("Player hitted")

func on_hit(body=null):
	print("Enemy hit", body)
	if body and body.is_in_group("player"):
		die()

func die():
	self.state = DYING
	clear_shapes()
	get_node("hit_area").clear_shapes()
	set_linear_damp(10)
