extends Node2D

func _ready():
	scale = Vector2.ZERO
	$Tween.interpolate_property(self, "scale", Vector2.ZERO, Vector2.ONE, 0.4, Tween.TRANS_BACK, Tween.EASE_OUT)
	$Tween.start()

func set_text(text : String):
	$Label.text = text
