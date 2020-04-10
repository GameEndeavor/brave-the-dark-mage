extends Node2D
class_name Door

var is_open = true setget set_is_open

func _ready():
	$BlockageDetector/CollisionShape2D.shape = $StaticBody2D/CollisionShape2D.shape
	$BlockageDetector/CollisionShape2D.transform = $StaticBody2D/CollisionShape2D.transform

func set_is_open(value):
	is_open = value
	$StaticBody2D/CollisionShape2D.disabled = value
	$Sprite.visible = !value

func open():
	set_is_open(true)

func close():
	set_is_open(false)

func check_is_blocked() -> bool:
	return $BlockageDetector.get_overlapping_bodies().size() != 0
