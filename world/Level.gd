tool extends Node2D

const MARGIN = 12

onready var sort = $Sort

export var generate_switch := false setget generate

func _ready():
	Globals.map = self

func generate(will_generate = true):
	if will_generate:
		var ground : TileMap = $Ground
		var wall_top : TileMap = $Sort/WallTop
		var wall_base : TileMap = $WallBase
		var dungeon_rect : Rect2 = ground.get_used_rect()
		dungeon_rect = dungeon_rect.grow_individual(MARGIN, MARGIN, MARGIN, MARGIN)
		
		wall_top.clear()
		wall_base.clear()
		
		for x in range(dungeon_rect.position.x, dungeon_rect.end.x):
			for y in range(dungeon_rect.position.y - 1, dungeon_rect.end.y - 1):
				if ground.get_cell(x, y + 1) == -1:
					wall_top.set_cell(x, y, 1)
		
		wall_top.update_bitmask_region(dungeon_rect.position, dungeon_rect.end)
		
		var wall_top_cells = wall_top.get_used_cells()
		
		for cell in wall_top_cells:
			var tile = wall_top.get_cellv(cell)
			if tile != -1:
				var coord = wall_top.get_cell_autotile_coord(cell.x, cell.y)
				var bitmask = wall_top.tile_set.autotile_get_bitmask(tile, coord)
				if !(bitmask & TileSet.BIND_BOTTOM):
					wall_base.set_cell(cell.x, cell.y + 1, 0)
		
		var wall_base_rect = wall_base.get_used_rect()
		wall_base.update_bitmask_region(wall_base_rect.position, wall_base_rect.end)

func add_entity(entity):
	sort.add_child(entity)
