extends Enemy

const DART_RAND = PI / 4.0
const JUMP_HEIGHT = -16

onready var z_adjuster = $Body/ZAdjuster
onready var pupil = $Body/ZAdjuster/Character/Pupil

onready var dart_timer = $Timers/DartTimer
onready var recover_timer = $Timers/RecoverTimer

onready var gravity = -2 * JUMP_HEIGHT / pow(dart_timer.wait_time / 2.0, 2)
onready var jump_velocity = -sqrt(-2 * gravity * JUMP_HEIGHT)
onready var pupil_offset = pupil.position

var dart_velocity = 12 * 16
var y_velocity = 0

func _ready():
	max_health = 5
	health = max_health

func apply_movement():
	move_and_slide(velocity)
	
	if get_slide_count() > 0:
		var collision = get_slide_collision(0)
		velocity = velocity.bounce(collision.normal)
	
	var delta = get_physics_process_delta_time()
	y_velocity += gravity * delta
	z_adjuster.position.y += y_velocity * delta
	if z_adjuster.position.y > 0:
		y_velocity = 0
		z_adjuster.position.y = 0

func knockback(angle, knockback_modifier):
	.knockback(angle, knockback_modifier)
	y_velocity = jump_velocity

func update_gaze():
	var target = get_target()
	if target != null:
		var angle = (target.global_position - global_position).angle()
		pupil.position = pupil_offset + polar2cartesian(3, angle)

func apply_dart_velocity():
	velocity = velocity.linear_interpolate(Vector2.ZERO, 0.005)

func _on_dart():
	var target = get_target()
	if target != null:
		var angle = (target.global_position - global_position).angle()
		angle += rand_range(-DART_RAND, DART_RAND)
		velocity = polar2cartesian(dart_velocity, angle)
		dart_timer.start()
		y_velocity = jump_velocity

func _on_recover():
	recover_timer.start()

func _on_telegraph():
	animation_player.play("telegraph")

func check_is_grounded():
	return z_adjuster.position.y == 0

func get_move_weight() -> float:
	var weight = .get_move_weight()
	if !check_is_grounded():
		weight *= 0.25
	return weight
