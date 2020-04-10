tool extends TileMap

#func set_cell(x, y, tile, flip_x = false, flip_y = false, transpose = false, autotile_coord = Vector2(0, 0)):
#	var top = get_node_or_null("../Sort/WallTop")
#	if top != null:
#		var bitmask = tile_set.autotile_get_bitmask(tile, autotile_coord)
#		if top.get_cell(x - 1, y) != -1:
#			bitmask |= TileSet.BIND_LEFT
#		if top.get_cell(x + 1, y) != -1:
#			bitmask |= TileSet.BIND_RIGHT
#		bitmask == 16
#		autotile_coord = get_coord_from_bitmask(tile, bitmask)
#
#	.set_cell(x, y, tile, flip_x, flip_y, transpose, autotile_coord)
#
#func get_coord_from_bitmask(tile, bitmask):
#	var size = tile_set.autotile_get_size(tile)
#	for x in size.x:
#		for y in size.y:
#			var coord = Vector2(x, y)
#			if bitmask == tile_set.autotile_get_bitmask(tile, coord):
#				return coord
#	return 0
