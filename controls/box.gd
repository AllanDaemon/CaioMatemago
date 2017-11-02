tool
extends KinematicBody2D

onready var sprite = get_node("sprite")
onready var anim = get_node("anim")

signal value_change

export (int) var increment = 1
export (Texture) var texture

func _ready():
	get_node("hit_value").set_text(str(increment))

	print("Box ", self.get_name())
	print("\ttexture: ", texture)

	if texture and texture != null:
		_set_default_texture(texture)

#	if region_default != null:
#		sprite.set_region_rect(region_default)
#		print("\tdefault region setted")		
#		var hit = anim.get_animation("hit")
#		hit.track_set_key_value(0, 1, region_default)
		
#	if region_hit != null:
#		var hit = anim.get_animation("hit")
#		hit.track_set_key_value(0, 0, region_hit)
#		print("\thitregion setted")

func _set_default_texture(texture):
	sprite.set_texture(texture)
	print("\ttexture setted")

func _on_area_body_enter( body ):
	if body.is_in_group("player"):
		hit(body)

func hit(body):
	emit_signal("value_change", increment)
	#get_node("anim").play("hit")
	get_node("anim_label").play("hit")
	print(body)

func _xp():
	var anim = get_node("anim")
	var res = anim.get_animation_list()
	print ("res: ", res)
	var hit = anim.get_animation("hit")
	print ("res: ", hit)
	var res = hit.track_get_path(0)
	print ("res: ", res)
	var res = hit.track_get_key_value(0, 0)
	print ("res: ", res)
	var res = hit.track_get_key_value(0, 1)
	print ("res: ", res)
	hit.track_set_key_value(0, 0, res)
