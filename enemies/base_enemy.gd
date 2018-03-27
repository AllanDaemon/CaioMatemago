tool
extends RigidBody2D
signal enemy_died

export (String, "green", "berigelante") var enemy_type = "green" setget _set_enemy_type

export (bool) var can_fall = false

enum states {IDLE, WALKING, FALLING, DYING}
export (int, "IDLE", "WALKING", "FALLING", "DYING") \
		var default_state = WALKING
const state_names = ["IDLE", "WALKING", "FALLING", "DYING"]
var state = -1 setget _set_state
var state_name

enum directions {RIGHT, LEFT}
const opposite = {RIGHT: LEFT, LEFT: RIGHT}
const directions_name = {RIGHT: "RIGHT", LEFT: "LEFT"}
#var default_direction = LEFT # Exportig fails...
export (int, "RIGHT", "LEFT") var default_direction = LEFT
var direction = -1 setget _set_direction
const default_velocity = Vector2(50, 0)
const direction_x_vel = {
	RIGHT: default_velocity.x *  1,
	LEFT: default_velocity.x * -1}
const direction_flipped_h = {RIGHT: true, LEFT: false}

onready var game = get_node("/root/game")
onready var raycasts_floor = get_node("raycasts_floor")
onready var raycasts_wall = get_node("raycasts_wall")
onready var anim = get_node("anim")
onready var fx_sounds = get_node("fx_sounds")
onready var sprite
onready var _post_ready = true

const cooldown_value = 10
var cooldown = 0

func _ready():
	if get_tree().is_editor_hint():
		print("Hello from script")
		_setup_enemy_type()
		return
	_init_defaults()
	set_fixed_process(true)

func _init_defaults():
	_setup_enemy_type()
	_set_direction(opposite[default_direction])
	_set_state(default_state)

func _set_enemy_type(value):
	enemy_type = value
	if not _post_ready: return
	_setup_enemy_type()

func _setup_enemy_type():
	if has_node("sprite_anim_" + enemy_type):
		get_node("sprite_anim_green").hide()
		get_node("sprite_anim_berigelante").hide()
		sprite = get_node("sprite_anim_" + enemy_type)
		if sprite: sprite.show()
		update()

func is_hitting_player():
	for ray in raycasts_wall.get_children():
		if ray.is_colliding():
		   _on_body_hit(ray.get_collider())

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
	if get_tree().is_editor_hint():
		breakpoint
		return
	if _should_change_direction():
		cooldown = cooldown_value
		#is_hitting_player()
		change_direction()
	if not cooldown:
		var vel = self.get_linear_velocity()
		if abs(vel.x / default_velocity.x) < 0.8:
			vel.x = direction_x_vel[direction]
			set_linear_velocity(vel)

func change_direction(to=default_direction):
	self.direction = (opposite[direction])

func _set_direction(to=default_direction):
	if not _post_ready: return
	if to == direction: return
	direction = to
	sprite.set_flip_h(direction_flipped_h[to])
	var vel = Vector2(direction_x_vel[to], get_linear_velocity().y)
	set_linear_velocity(vel)
	var direction_name_lower = directions_name[direction].to_lower()
	for ray in raycasts_wall.get_children():
		ray.set_enabled(ray.get_name().ends_with(direction_name_lower))


func _set_state(value=default_state):
	if not _post_ready: return
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
	#prints("enemy_type:", enemy_type)
	#prints("Player hit test", body)
	if body and body.is_in_group("player"):
		prints("Player hitted")
		game.player_hit(enemy_type, body)

func on_hit(body=null):
	#prints("Enemy hit:", body)
	if body and body.is_in_group("player"):
		die()

func die():
	self.state = DYING
	clear_shapes()
	get_node("hit_area").clear_shapes()
	get_node("attack_area").clear_shapes()
	set_linear_damp(10)
	emit_signal("enemy_died")
