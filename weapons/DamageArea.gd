extends Area2D
class_name DamageArea

signal hitteded()

export var damage_amount = 1
export var knockback_strength = 1
export var use_exceptions = false
var attacker

var exceptions = []

func on_hit(hitbox):
	if use_exceptions:
		exceptions.append(hitbox)
	emit_signal("hitteded")
	
