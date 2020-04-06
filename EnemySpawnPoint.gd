extends Position2D

enum Enemies {
	GRUNT,
}

export (Enemies) var enemy_type = 0

func _ready():
	call_deferred("_spawn")

func _spawn():
	var enemy = get_enemy(enemy_type)
	enemy.global_position = global_position
	Globals.map.add_entity(enemy)

func get_enemy(enemy_type = self.enemy_type):
	match enemy_type:
		Enemies.GRUNT, _:
			return preload("res://character/Grunt.tscn").instance()
