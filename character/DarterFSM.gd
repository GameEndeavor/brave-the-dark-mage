extends "res://CharacterFSM.gd"

func _ready():
	add_state("idle")
	add_state("pursue")
	add_state("telegraph")
	add_state("dart")
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
		states.dart:
			parent.apply_dart_velocity()
			parent.apply_movement()
		_:
			parent.apply_stop_velocity()
			parent.apply_movement()

func _get_transition(delta):
	match state:
		states.idle:
			if parent.get_target() != null:
				return states.telegraph
		states.pursue:
			if parent.get_target() == null:
				return states.idle
			elif parent.can_dart():
				if parent.get_target() == null:
					return states.idle
				else:
					return states.dart
		states.telegraph:
			if !parent.animation_player.is_playing():
				return states.dart
		states.dart:
			if parent.dart_timer.is_stopped():
				return states.recover
		states.recover:
			if parent.recover_timer.is_stopped():
				if parent.get_target() == null:
					return states.idle
				else:
					return states.telegraph

func _enter_state(new_state, old_state):
	match new_state:
		states.telegraph:
			parent._on_telegraph()
		states.dart:
			parent._on_dart()
		states.recover:
			parent._on_recover()

func _exit_state(old_state, new_state):
	pass
