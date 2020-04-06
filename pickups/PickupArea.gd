extends Area2D

signal picked_up(picker_upper)

func pickup(picker_upper):
	emit_signal("picked_up", picker_upper)
