#!/usr/bin/env python3

from collections import OrderedDict

fname = 'tileset.tscn'
fname_out = 'tileset_out.tscn'
f = open(fname)
g = open(fname_out, 'w')

lines = f.readlines()

def iter_nodes(lines=lines):
	node_lines = []
	for l in lines:
		if node_lines and '[' in l.strip():
			yield node_lines
			node_lines = [l]
		else:
			node_lines.append(l)
	if node_lines:
		yield node_lines

def get_tag_info(line):
	tag, *parts = line.strip()[1:-1].split()
	fields = [p.split("=", 1) for p in parts]
	fields = [(k,eval(v)) for k,v in fields]
	fields = OrderedDict(fields)
	return tag, fields

fix_nodes = 'boxes', 'floor', 'floor_dark'

ex_add = '[ext_resource path="res://tileset/block_shape.tres" type="Shape2D" id=2]'

template = '''\
[node name="Area2D" type="Area2D" parent="{parent}"]

editor/display_folded = true
input/pickable = true
shapes/0/shape = ExtResource( 2 )
shapes/0/transform = Matrix32( 1, 0, 0, 1, 8, 8 )

[node name="CollisionShape2D" type="CollisionShape2D" parent="{parent}/Area2D"]

transform/pos = Vector2( 8, 8 )
shape = ExtResource( 2 )
trigger = false
_update_shape_index = 0

'''

def fix(lines):
	tag, fields = get_tag_info(lines[0])
	if tag == 'node' and 'parent'in fields and fields['parent'] in fix_nodes:
		parent = fields['parent'] + '/' + fields['name']
		s = template.format(parent=parent)
		lines.append(s)

from pprint import pprint as pp
if __name__ == '__main__':

	for n in iter_nodes():
		pp(n)
		r = None
		# r = input()
		if r:
			tag, fields = get_tag_info(n[0])
			print('TAG:', tag)
			pp(fields)
		print()
		fix(n)
		g.writelines(n)