extends Area2D



func _on_Area2D_body_entered(body):
	$CollisionShape2D.set_deferred("disabled", true)
	var prisoners = get_tree().get_nodes_in_group("prisoners")
	if prisoners.size() > 0:
		var prisoner = prisoners[randi() % prisoners.size()]
		prisoner.say("Odd. I expected there to be an exit")
		
