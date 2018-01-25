extends Area2D

func _ready():
	pass

func _on_player_near(body):
	printt("Player near.". body)