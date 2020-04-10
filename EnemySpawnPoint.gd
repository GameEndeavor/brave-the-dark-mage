extends Position2D
class_name Spawner

const ENEMY_SCENES = [
	preload("res://character/enemies/Grunt.tscn"),
	preload("res://character/enemies/Spitter.tscn"),
	preload("res://character/enemies/Darter.tscn"),
	preload("res://character/enemies/DarkWizard.tscn"),
]

enum Enemies {
	GRUNT, SPITTER, DARTER, DARK_WIZARD
}

export (Enemies) var enemy_type = 0
export var delay := 0.0

func spawn():
	var enemy = get_enemy(enemy_type)
	enemy.global_position = global_position
	Globals.map.add_entity(enemy)
	enemy.reaction_delay.start()
	
	$AnimationPlayer.play("spawn")
	
	return enemy

func get_enemy(enemy_type = self.enemy_type):
	match enemy_type:
		Enemies.GRUNT, _:
			return ENEMY_SCENES[enemy_type].instance()
