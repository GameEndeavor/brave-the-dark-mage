extends Node2D

onready var damage_area = $DamageArea
onready var damage_collision = $DamageArea/CollisionShape2D

export var radius := 8.0

func init(attacker):
	damage_area.attacker = attacker

func get_hand_transform(attack_modifier) -> Transform2D:
#	return get_stab_transform(attack_modifier)
	return get_swing_transform(attack_modifier)

func get_stab_transform(attack_modifier, stab_range = 32, offset = 8) -> Transform2D:
	var pos = (1 - abs(attack_modifier)) * stab_range + offset
	return Transform2D(0, Vector2.RIGHT * pos)

func get_swing_transform(attack_modifier) -> Transform2D:
	var attack_angle = PI / 2.0 * attack_modifier
	var pos = polar2cartesian(radius, attack_angle)
	var hand_angle = PI * attack_modifier
	return Transform2D(hand_angle, pos)

func _on_attacked():
	damage_collision.disabled = false

func _on_attack_finished():
	damage_collision.disabled = true
