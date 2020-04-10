tool extends "res://world/Level.gd"

const STARTING_ROOM_SIZE = 128
const MIN_LEAF_SIZE = STARTING_ROOM_SIZE / 6
const MIN_ROOM_SIZE = MIN_LEAF_SIZE / 2
const ROOM_MARGIN_SIZE = 12

var leafs = []
var rooms = []

export var gen := false setget generate_level

func generate_level(value = true):
	if value:
		generate_layout()
		generate_rooms()
		apply_generation()

func generate_layout():
	leafs = []
	leafs.append(Rect2(-Vector2.ONE * (STARTING_ROOM_SIZE / 2), Vector2.ONE * STARTING_ROOM_SIZE))
	
	for i in 12:
		for n in leafs.size():
			var rect : Rect2 = leafs.pop_front()
#			var axis = Vector2.RIGHT if rect.size.x > rect.size.y else Vector2.DOWN
			var axis = Vector2.RIGHT if randi() % 2 == 0 else Vector2.DOWN
			if (rect.size * axis).length() / 2 >= MIN_LEAF_SIZE:
				var rot = axis.rotated(PI / 2.0).abs()
				var split : int = (rect.size / 2 * axis).length()
				var wiggle_room = clamp(split - MIN_LEAF_SIZE, 0, split / 2)
				if wiggle_room > 0:
					split += rand_range(-wiggle_room, wiggle_room)
				rect.size = rect.size - (axis * split)
			
				var pos = rect.position + (rect.size * axis)
				var size = ((rect.size * rot) + (axis * split)).floor()
				var new_rect = Rect2(pos, size)
				leafs.push_back(new_rect)
			
			leafs.push_back(rect)

func generate_rooms():
	rooms = []
	for leaf in leafs:
		var base = Vector2(max(leaf.size.x - MIN_ROOM_SIZE - ROOM_MARGIN_SIZE, MIN_ROOM_SIZE), \
				max(leaf.size.y - MIN_ROOM_SIZE - ROOM_MARGIN_SIZE, MIN_ROOM_SIZE))
		var size = ((base / 2) * Vector2(randf(), randf()) + Vector2.ONE * MIN_ROOM_SIZE + base / 2).floor()
		var pos = (leaf.position + (leaf.size - size - Vector2.ONE * 6) * Vector2(randf(), randf())).floor() + Vector2.ONE * 3
#		var size = Vector2(max(leaf.size.x - MIN_ROOM_SIZE - ROOM_MARGIN_SIZE, MIN_ROOM_SIZE) * randf() + MIN_ROOM_SIZE, \
#				max(leaf.size.y - MIN_ROOM_SIZE - ROOM_MARGIN_SIZE, MIN_ROOM_SIZE) * randf() + MIN_ROOM_SIZE).floor()
		rooms.append(Rect2(pos, size))

func apply_generation():
	$Ground.clear()
	$WallBase.clear()
	$Sort/WallTop.clear()
	var ground_tile = 0
	for room in rooms:
		for y in range(room.position.y, room.end.y):
			for x in range(room.position.x, room.end.x):
				$Ground.set_cell(x, y, ground_tile)
