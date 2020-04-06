tool extends TileMap

#export var populate := false setget on_populate

#func on_populate(value = true):
#	if value:
#		var ground = get_node_or_null("../Ground")
#		if ground != null:
#			var used_rect = 
