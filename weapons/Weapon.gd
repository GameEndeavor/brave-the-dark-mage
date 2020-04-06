extends Node2D

onready var damage_area = $DamageArea
onready var damage_collision = $DamageArea/CollisionShape2D

func init(attacker):
	damage_area.attacker = attacker

func _on_attacked():
	damage_collision.disabled = false

func _on_attack_finished():
	damage_collision.disabled = true
