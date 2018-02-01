extends RigidBody2D

enum states {IDLE, WALKING, DYING}
var state = WALKING

func _ready():
	pass

func _integrate_forces(s):
	pass