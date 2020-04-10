extends "res://world/Room.gd"


func _on_DodgeRoom_locked():
	var players = get_tree().get_nodes_in_group("players")
	var player = players[0] if players.size() > 0 else null
	if player != null:
		player.say("[SPACE] to dodge")
