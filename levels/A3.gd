extends Node2D

onready var common = get_node("common")
onready var first_wall = common.get_node("blocks/first_wall")
onready var question1 = common.get_node("questions/question_group1")
onready var enemies = common.get_node("enemies")
onready var spawner = common.get_node("enemies/spawner_enemy")
onready var spawn_timer = common.get_node("enemies/spawner_enemy/spawn_timer")
var enemy_fab = preload("res://enemies/base_enemy.tscn")

func _ready():
	question1.connect("right_operation", first_wall, "queue_free")
	spawn_timer.connect("timeout", self, "spawn_enemy")

func spawn_enemy():
	var new_enemy = enemy_fab.instance()
	new_enemy.set_pos(spawner.get_pos())
	#new_enemy.can_fall = true
	enemies.add_child(new_enemy)