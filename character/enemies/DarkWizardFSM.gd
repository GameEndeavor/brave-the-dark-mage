extends "res://CharacterFSM.gd"

enum AttackPatterns {
	SHIELD,
	LESSER_SHIELD
	HOMING,
	HOMING_SHIELD,
	RECOVERY,
}

var pattern_state = 0

func _ready():
	add_state("idle")
	add_state("shield")
	add_state("lesser_shield")
	add_state("homing")
	add_state("homing_shield")
	add_state("recovery")
	add_state("dead")
	call_deferred("set_state", states.idle)

func _state_logic(delta):
	match state:
		states.idle:
			parent.update_target()
			parent.update_facing()
		states.shield, states.lesser_shield, states.homing_shield:
			parent.update_magic()
			parent.update_facing()
		states.homing:
			parent.update_homing_magic()
			parent.update_facing()
		states.dead:
			parent.apply_stop_velocity()
			parent.apply_movement()

func _get_transition(delta):
	match state:
		states.idle:
			if parent.transition_timer.is_stopped() && parent.get_target() != null:
				match pattern_state:
					AttackPatterns.SHIELD:
						return states.shield
					AttackPatterns.HOMING:
						return states.homing
					AttackPatterns.LESSER_SHIELD:
						return states.lesser_shield
					AttackPatterns.HOMING_SHIELD:
						return states.homing_shield
					AttackPatterns.RECOVERY:
						return states.recovery
		states.shield, states.lesser_shield, states.homing, states.homing_shield, states.recovery:
			if parent.transition_timer.is_stopped():
				return states.idle

func _enter_state(new_state, old_state):
	match new_state:
		states.idle:
			parent.transition_timer.start(0.1)
		states.shield:
			parent.summon_magic_shield()
			parent.transition_timer.start(1)
		states.lesser_shield:
			parent.summon_magic_shield(4)
			parent.transition_timer.start(2)
		states.homing:
			parent.summon_homing()
			parent.transition_timer.start(1)
		states.homing_shield:
			parent.summon_homing_shield()
			parent.transition_timer.start(1.5)
		states.recovery:
			parent.transition_timer.start(9)
			parent.hits = 0
			parent.is_vulnerable = true
			parent.shield.hide()

func _exit_state(old_state, new_state):
	match old_state:
		states.shield:
			parent.launch_magic()
			pattern_state = AttackPatterns.HOMING
		states.homing:
			parent.launch_magic()
			pattern_state = AttackPatterns.LESSER_SHIELD
		states.lesser_shield:
			parent.launch_magic()
			pattern_state = AttackPatterns.HOMING_SHIELD
		states.homing_shield:
			parent.launch_magic()
			pattern_state = AttackPatterns.RECOVERY
		states.recovery:
			pattern_state = AttackPatterns.SHIELD
			parent.is_vulnerable = false
			parent.shield.show()
			get_tree().call_group("black_magics", "destroy")


func _on_DarkWizard_uncle():
	if state == states.recovery:
		set_state(states.idle)
