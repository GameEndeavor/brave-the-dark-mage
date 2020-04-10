extends Node2D

const LEVELS = {
	"tutorial" : "res://world/levels/TutorialLevel.tscn",
	"clockwise" : "res://world/levels/Clockwise.tscn",
	"watching" : "res://world/levels/EyemWatchingYou.tscn",
	"showdown" : "res://world/levels/Showdown.tscn",
	"victory" : "res://Victory.tscn",
}

export (String, "tutorial", "clockwise", "watching", "showdown") var starting_level = "tutorial"

onready var hud = $HUDCanvas
onready var scene_animator = $SceneChanger/AnimationPlayer

var level
var level_id = 0

func _ready():
	Globals.game = self
	load_level(LEVELS[starting_level])
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func start_next_level():
	level_id += 1
	load_level(LEVELS.values()[level_id])

func load_level(path):
	scene_animator.play("fade_out")
	yield(scene_animator, "animation_finished")
	
	if level != null:
		level.queue_free()
		yield(level, "tree_exited")
	
	level = load(path).instance()
	add_child(level)
	
	scene_animator.play("fade_in")

func end_game():
	yield(get_tree().create_timer(1.2), "timeout")
	start_next_level()

func restart_level():
	yield(get_tree().create_timer(0.8), "timeout")
	load_level(LEVELS.values()[level_id])
