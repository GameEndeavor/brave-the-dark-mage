extends "res://world/Room.gd"



func _on_Room_locked():
	var players = get_tree().get_nodes_in_group("players")
	var player = players[0] if players.size() > 0 else null
	if player != null:
		player.say("[Left Click] to attack")
