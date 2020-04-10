extends "res://StateMachine.gd"

export var can_be_stunned := true

func _ready():
	add_state("idle")
	add_state("stunned")

func _on_stun():
	if can_be_stunned:
		set_state(states.stunned)

func _on_stun_timeout():
	if state == states.stunned:
		set_state(states.idle)
