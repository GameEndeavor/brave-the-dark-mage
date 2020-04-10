extends Enemy

const projectile_scene = preload("res://weapons/projectiles/Projectile.tscn")

const PROJECTILE_SPREAD = PI / 8.0
const PROJECTILE_VELOCITY = 7.0 * 16
const PROJECTILE_VELOCITY_OFFSET = 2.0 * 16
const PROJECTILE_Z_VELOCITY = -100
const PROJECTILE_z_VELOCITY_OFFSET = 20

onready var prepare_attack_timer = $Timers/PrepareAttackTimer
onready var recovery_timer = $Timers/RecoveryTimer

func _ready():
	max_health = 3
	health = max_health

func can_attack():
	# TODO: && can_see_target()
	return prepare_attack_timer.is_stopped() && get_distance_to_target() < attack_radius_units * 16

func _on_attack():
	var target = get_target()
	if target != null:
		$Spit.play()
		for i in 6:
			var angle = (target.global_position - global_position).angle()
			angle += rand_range(-PROJECTILE_SPREAD, PROJECTILE_SPREAD)
			var projectile = projectile_scene.instance()
			projectile.global_position = global_position
			Globals.map.add_entity(projectile)
			var z_velocity = PROJECTILE_Z_VELOCITY + \
					rand_range(-PROJECTILE_z_VELOCITY_OFFSET, PROJECTILE_z_VELOCITY_OFFSET)
			var projectile_velocity = PROJECTILE_VELOCITY + \
					rand_range(-PROJECTILE_VELOCITY_OFFSET, PROJECTILE_VELOCITY_OFFSET)
			projectile.launch(angle, projectile_velocity, z_velocity)

func is_attacking() -> bool:
	return false
