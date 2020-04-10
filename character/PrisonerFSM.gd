extends "res://CharacterFSM.gd"

func _ready():
	add_state("idle")
	add_state("follow")
	add_state("wait")
	add_state("dead")
	call_deferred("set_state", states.idle)

func _state_logic(delta):
	match state:
		states.idle:
			if !parent.is_bound:
				parent.update_target()
			parent.apply_stop_velocity()
			parent.apply_movement()
		states.follow:
			parent.apply_follow_velocity()
			parent.apply_movement()
		states.dead:
			parent.apply_stop_velocity()
			parent.apply_movement()
		_:
			parent.apply_stop_velocity()
			parent.apply_movement()

func _get_transition(delta):
	match state:
		states.idle:
			if parent.get_target() != null:
				return states.follow

func _enter_state(new_state, old_state):
	pass

func _exit_state(old_state, new_state):
	pass
