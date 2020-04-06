extends Character
class_name AI

var detection_radius := 6.0 * 16
export var attack_radius_units := 0.5
var target_ref = null setget set_target

export var target_group = ""


func get_nearest_target(target_group : String):
	var targets = get_tree().get_nodes_in_group(target_group)
	var minimum_distance = detection_radius
	var nearest_target = null
	
	for target in targets:
		var distance = (target.global_position - global_position).length()
		if distance < minimum_distance:
			minimum_distance = distance
			nearest_target = target
	
	return nearest_target

func _on_damage():
	._on_damage()
	stun()

func set_target(value):
	if value is WeakRef:
		target_ref = value
	else:
		target_ref = weakref(value)
	
	if target_ref != null:
		emit_signal("target_changed", target_ref.get_ref())

func get_target():
	return target_ref.get_ref() if target_ref != null && target_ref is WeakRef else null


signal target_changed(target)

var aggro_radius_units = 8

func update_target():
	var target = get_target()
	
	if target != null:
		var distance = (target.global_position - global_position).length()
		if distance > aggro_radius_units * 16:
			set_target(null)
	
	var nearest_target = get_nearest_target(target_group)
	
	if nearest_target != null && nearest_target != get_target():
		set_target(nearest_target)

func move_towards_target():
	var target = get_target()
	if target != null:
		move_towards(target.global_position)

func move_towards(to):
	var displacement = to - global_position
	var desired_velocity = displacement.normalized() * move_speed_units * 16
	var delta = get_physics_process_delta_time()
	
	if desired_velocity.length() * delta > displacement.length():
		desired_velocity = displacement / delta
	
	velocity = velocity.linear_interpolate(desired_velocity, 0.3)

func get_distance_to_target():
	var target = get_target()
	if target != null:
		return (target.global_position - global_position).length()
	else:
		return INF
