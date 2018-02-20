tool
extends KinematicBody2D

export (bool) var enabled = false setget _set_enabled

#onready var sprite_on = get_node("sprite_enabled")
#onready var sprite_off = get_node("sprite_disabled")
onready var sprite = get_node("sprite")
onready var anim = get_node("anim")
onready var _post_ready = true

func _get_item_rect():
    return sprite.get_item_rect()

func _ready():
	_set_enabled(enabled)

func _set_enabled(value):
	if not _post_ready: return
	if get_tree().is_editor_hint(): return
	enabled = value
	anim.play("enabled" if enabled else "disabled")


