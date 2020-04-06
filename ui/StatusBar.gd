extends Control

onready var top_bar = $TopBar

func _on_max_value_changed(value):
	top_bar.max_value = value

func _on_value_changed(value):
	top_bar.value = value
