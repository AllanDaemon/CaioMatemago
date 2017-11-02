extends KinematicBody2D

onready var sprite = get_node("sprite")

signal value_change

export (int) var increment = 1
export (Texture) var _texture
export (Rect2) var _region

func _ready():
	if _texture and _region:
		sprite.set_texture(_texture)
		sprite.set_region_rect(_region)


func _on_area_body_enter( body ):
	if body.is_in_group("player"):
		emit_signal("value_change", increment)
		get_node("anim").play("hit")
	print(body)
	