extends Enemy

const DART_RAND = PI / 4.0

onready var dart_timer = $Timers/DartTimer
onready var recover_timer = $Timers/RecoverTimer

var dart_velocity = 12 * 16

func apply_dart_velocity():
	velocity = velocity.linear_interpolate(Vector2.ZERO, 0.005)

func _on_dart():
	var target = get_target()
	if target != null:
		var angle = (target.global_position - global_position).angle()
		angle += rand_range(-DART_RAND, DART_RAND)
		velocity = polar2cartesian(dart_velocity, angle)
		dart_timer.start()

func _on_recover():
	recover_timer.start()

func _on_telegraph():
	animation_player.play("telegraph")
