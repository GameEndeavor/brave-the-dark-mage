extends AI
class_name Enemy

onready var contact_damage = $ContactDamage

func _on_destroyed():
	if randf() < 0.2:
		var pickup = preload("res://pickups/Pickup.tscn").instance()
		pickup.global_position = global_position
		Globals.map.call_deferred("add_entity", pickup)
		pickup.call_deferred("spawn")
	$ContactDamage.queue_free()
