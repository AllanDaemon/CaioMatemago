extends Node2D

onready var common = get_node("common")
onready var first_wall = common.get_node("blocks/first_wall")
onready var question1 = common.get_node("questions/question_group1")

func _ready():
	question1.connect("right_operation", first_wall, "queue_free")