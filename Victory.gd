extends CanvasLayer

func _input(event):
	if event.is_action_pressed("ui_accept"):
		$Control/CenterContainer/Label.text = \
		"Music: Demilitarized Zone - Ethan Meixsell\n" + \
		"Font: m5x7 - Daniel Linssen"
