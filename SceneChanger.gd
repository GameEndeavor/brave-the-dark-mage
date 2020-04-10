extends CanvasLayer

signal scene_changed()

onready var animation_player = $AnimationPlayer

func load_scene(path, delay = 0.4):
	yield(get_tree().create_timer(delay), "timeout")
	animation_player.play("fade_out")
	yield(animation_player, "animation_finished")
	get_tree().change_scene(path)
	animation_player.play("fade_in")
	yield(animation_player, "animation_finished")
	emit_signal("scene_changed")
