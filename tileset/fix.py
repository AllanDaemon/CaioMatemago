#!/usr/bin/env python3


fname = 'tileset.tscn'
fname_out = 'tileset_out.tscn'
f = open(fname)
g = open(fname_out, 'w')

lines = f.readlines()

def iter_nodes(lines=lines):
	node_lines = []
	for l in lines:
		if '[' in l.strip():
			yield node_lines
			node_lines = [l]
		else:
			node_lines.append(l)

from pprint import pprint as pp
if __name__ == '__main__':

	for n in iter_nodes():
		input()
		pp(n)
		print()