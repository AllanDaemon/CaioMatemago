extends Node2D

#export (int, 0, 100) var operations_max = 10
var operations_done = 0
var boss_defeated = false

const questions = [
	[1, 0],		# 01
	[1, 1],		# 02
#	[1, 2],		# 03
#	[1, 3],		# 04
#	[1, 4],		# 05
	[0, 0],		# 06
	[0, 1],		# 07
#	[0, 2],		# 08
#	[0, 3],		# 09
#	[0, 4],		# 10
]

onready var common = get_node("common")
onready var anim = get_node("anim")
onready var question = common.get_node("questions/question_group")
onready var question_timer = question.get_node("timer")
onready var enemies = common.get_node("enemies")
onready var boss = common.get_node("enemies/boss")
onready var spawner1 = common.get_node("enemies/enemy_spawner1")
onready var spawner2 = common.get_node("enemies/enemy_spawner2")
var enemy_fab = preload("res://enemies/base_enemy.tscn")

func _ready():
	boss.first_interaction()
	print("waiting boss interaction")
	yield(boss, "interaction_end")
	print("going next interaction")
	_setup_next_question()
	anim.play("begin_operations")

func _on_right_operation():
	print("VI PRAVAS")
	operations_done += 1
	question_timer.start()
	yield (question_timer, "timeout")
	if questions.empty():
		_boss_defeat()
	else:
		_setup_next_question()
	
func _setup_next_question():
	var next = questions[0]
	questions.pop_front()
	question.a = next[0]
	question.b = next[1]
	question.update_question()

func _boss_defeat():
	printt("Boss defeated!", operations_done)
	boss_defeated = true
	anim.play("boss_defeated")

func spawn_enemy1():
	var new_enemy = enemy_fab.instance()
	new_enemy.set_pos(spawner1.get_pos())
	new_enemy.enemy_type = "berigelante"
	new_enemy.can_fall = true
	enemies.add_child(new_enemy)

func spawn_enemy2():
	var new_enemy = enemy_fab.instance()
	new_enemy.set_pos(spawner2.get_pos())
	new_enemy.can_fall = true
	new_enemy.default_direction = new_enemy.LEFT
	enemies.add_child(new_enemy)