extends AI
class_name Prisoner

const PortalScene = preload("res://world/Portal.tscn")

export var is_witness = false

var follow_distance = 48
var arrival_distance = 16
var is_bound = false

func _ready():
	max_health = 1
	health = max_health

func update_target():
	var players = get_tree().get_nodes_in_group("players")
	if players.size() > 0:
		set_target(players[0])

func apply_follow_velocity():
	var desired_velocity = Vector2.ZERO
	var target = get_target()
	if target != null:
		var displacement = target.global_position - global_position
		var factor = get_deadzone_factor(target.global_position, follow_distance, arrival_distance)
		desired_velocity = displacement.normalized() * move_speed_units * 16 * factor
	velocity = velocity.linear_interpolate(desired_velocity, get_move_weight())

func get_deadzone_factor(target_position, follow_distance, arrival_distance):
	var displacement = target_position - global_position
	var factor = 1.0
	if displacement.length() < arrival_distance + follow_distance:
		factor = 0.0
		if displacement.length() > arrival_distance:
			factor = max((displacement.length() - follow_distance) / arrival_distance, 0)
	return factor

func _on_destroyed():
	if Globals.game.level_id == 0:
		get_tree().call_group("prisoners", "say", "OMG WTF!?!")
#	._on_destroyed()
#	spawn_portal()

func spawn_portal():
	var portal = PortalScene.instance()
	portal.global_position = global_position
	Globals.map.call_deferred("add_entity", portal)

func _on_Hitbox_damaged(amount, knockback_modifier, damage_source, attacker):
	var space_state = get_world_2d().direct_space_state
	
	var query = Physics2DShapeQueryParameters.new()
	var shape = CircleShape2D.new()
	shape.radius = 96
	query.set_shape(shape)
	query.transform = Transform2D(0, global_position)
	query.collision_layer = CollisionLayers.PORTAL
	query.collide_with_areas = true
	query.collide_with_bodies = false
	
	var results = space_state.intersect_shape(query, 1)
	var result = results[0] if results.size() != 0 else null
	if result != null:
		var portal = result.collider.get_parent()
		if !portal.is_lit:
			._on_Hitbox_damaged(amount, knockback_modifier, damage_source, attacker)
			if health == 0:
				portal.light(self)

func on_room_locked():
	wait()

func on_room_unlocked():
	state_machine.set_state(state_machine.states.idle)

func wait():
	state_machine.set_state(state_machine.states.wait)
