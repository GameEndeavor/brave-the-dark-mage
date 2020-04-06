extends "res://CharacterFSM.gd"

func _ready():
	add_state("idle")
	add_state("pursue")
	add_state("telegraph")
	add_state("attack")
	add_state("recover")
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
			elif parent.can_attack():
				return states.telegraph
		states.telegraph:
			if !parent.animation_player.is_playing():
				return states.attack
		states.attack:
			if !parent.is_attacking():
				return states.recover
		states.recover:
			if !parent.animation_player.is_playing():
				return states.idle

func _enter_state(new_state, old_state):
	match new_state:
		states.telegraph:
			parent.animation_player.play("telegraph")
		states.attack:
			parent._on_attack()
		states.recover:
			parent.animation_player.play("recover")

func _exit_state(old_state, new_state):
	pass
