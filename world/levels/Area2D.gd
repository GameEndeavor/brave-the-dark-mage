extends Area2D

func _on_Area2D_body_entered(body):
	if body is Player:
		var prisoners = get_tree().get_nodes_in_group("prisoners")
		for prisoner in prisoners:
			if prisoner.is_witness:
				prisoner.wait()
			else:
				prisoner.say("?", 0.25)
