extends Area2D

export (bool) var enabled = false
export (String) var goto_scene

onready var game = get_node("/root/game")

func _ready():
	pass

func _on_area_level_body_enter( body ):
	if enabled and goto_scene and body.is_in_group("player"):
		hit()

func hit():
	game.change_level_smooth(goto_scene)