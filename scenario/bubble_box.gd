tool
extends KinematicBody2D

export (Texture) var texture
export (bool) var enabled = false setget _set_enabled

onready var sprite_on = get_node("sprite_enabled")
onready var sprite_off = get_node("sprite_disabled")
onready var anim = get_node("anim")
onready var _post_ready = true

func _get_item_rect():
    return get_node("sprite_enabled").get_item_rect()

func _ready():
	if texture and texture != null:
		_set_default_texture(texture)

func _set_default_texture(texture):
	sprite.set_texture(texture)
	print("\ttexture setted")

func _set_enabled(value):
	enabled = value
	if not _post_ready: return
	anim.play("enabled" if enabled else "disabled")


