extends "res://StateMachine.gd"

func _ready():
	add_state("idle")
	add_state("stunned")

func _on_stun():
	set_state(states.stunned)

func _on_stun_timeout():
	set_state(states.idle)
