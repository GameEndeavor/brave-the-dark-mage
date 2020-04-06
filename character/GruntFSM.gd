extends "res://CharacterFSM.gd"

func _ready():
	add_state("idle")
	add_state("pursue")
	call_deferred("set_state", states.idle)

func _state_logic(delta):
	match state:
		states.idle:
			parent.update_target()
			parent.apply_stop_velocity()
			parent.apply_movement()
		states.pursue:
			parent.update_target()
			parent.move_towards_target()
			parent.apply_movement()
		_:
			parent.apply_stop_velocity()
			parent.apply_movement()

func _get_transition(delta):
	match state:
		states.idle:
			if parent.get_target() != null:
				return states.pursue
		states.pursue:
			if parent.get_target() == null:
				return states.idle

func _enter_state(new_state, old_state):
	pass

func _exit_state(old_state, new_state):
	pass
