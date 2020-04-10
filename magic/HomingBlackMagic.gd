extends "res://magic/BlackMagic.gd"
class_name HomingBlackMagic

var target_ref = null setget set_target

func update_velocity():
	var target = get_target()
	if target != null:
		var delta = get_physics_process_delta_time()
		var displacement = target.global_position - global_position
		velocity = velocity.linear_interpolate(displacement.normalized() * move_speed, 0.025)

func set_target(value):
	if value is WeakRef:
		target_ref = value
	else:
		target_ref = weakref(value)

func get_target():
	return target_ref.get_ref() if target_ref is WeakRef else null

func launch(angle):
	.launch(angle)
	$Timer.start()

func _on_Timer_timeout():
	destroy()
