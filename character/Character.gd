extends KinematicBody2D
class_name Character

signal damaged()
signal health_changed(health)
signal max_health_changed(max_health)
signal stunned()

onready var body = $Body
onready var damage_animator = $DamageAnimator
onready var state_machine = $StateMachine
onready var hitbox = $Hitbox
onready var animation_player = $AnimationPlayer

onready var stun_timer = $Timers/StunTimer

export var move_speed_units = 8
export var max_health = 8 setget set_max_health
export var knockback_velocity = 500

onready var health = max_health setget set_health

var velocity : Vector2

func apply_stop_velocity():
	velocity = velocity.linear_interpolate(Vector2.ZERO, get_move_weight())

func apply_movement():
	velocity = move_and_slide(velocity)

func get_move_weight():
	var move_weight = 0.3
	if !stun_timer.is_stopped():
		move_weight = 0.3
	return move_weight

func _on_damage():
	damage_animator.play("damage")

func destroy():
	_on_destroyed()
	queue_free()

func _on_destroyed():
	pass

func _on_Hitbox_damaged(amount, knockback_modifier, damage_source, attacker):
	var health_modified = set_health(health - amount)
	if health_modified < 0:
		var from = attacker.global_position if attacker != null else damage_source.global_position
		var displacement = global_position - from
		if knockback_modifier > 0:
			velocity = displacement.normalized() * knockback_velocity * knockback_modifier

func set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	if health < prev_health:
		_on_damage()
		emit_signal("damaged")
	if health != prev_health:
		emit_signal("health_changed", health)
	if health == 0:
		destroy()
	return health - prev_health

func set_max_health(value):
	max_health = max(max_health, 1)
	emit_signal("max_health_changed", max_health)

func is_moving():
	return velocity.length() > 8

func stun():
	stun_timer.start()
	emit_signal("stunned")
