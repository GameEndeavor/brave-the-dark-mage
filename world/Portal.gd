extends Node2D

var is_lit = false

func _on_Area2D_body_entered(body):
	if body is Player && is_lit:
		body.on_portal_enter(self)

func light(sacrifice):
	is_lit = true
	$Portal.show()
