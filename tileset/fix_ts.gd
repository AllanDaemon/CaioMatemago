tool
extends EditorScript

func _run():
	var scene = get_scene()
	print("scene: ", scene)
	print("scene name:", scene.get_name())
	var f = scene.get_node("floor")
	print("floor: ", f)
	var shape = RectangleShape2D.new()
	shape.set_extents(Vector2(8,8))
	
	for node in f.get_children():
		print(node, ": ", node.get_name())
		var collision = CollisionShape2D.new()
		collision.set_shape(shape)
		collision.set_pos(Vector2(8,8))
		var area = Area2D.new()
		area.add_child(collision)
		node.add_child(area)
		
		