extends Area2D

signal locked()
signal lock_changed(is_locked)
signal cleared()

var doors = []
var spawners = []
var prisoners = []

var is_cleared = false
var is_open = true

var n_enemies = 0

func _ready():
	doors = find_type(Door)
	spawners = find_type(Spawner)
	prisoners = find_type(Prisoner)
	
	for door in doors:
		door.open()
	
	for prisoner in prisoners:
		prisoner.is_bound = true
	
	set_physics_process(false)
	
	call_deferred("_reparent_doors")

func _reparent_doors():
	for door in doors:
		var t = door.global_transform
		remove_child(door)
		Globals.map.add_entity(door)
		door.global_transform = t

func _physics_process(delta):
	if is_cleared || !is_open:
		set_physics_process(false)
		return
	
	var are_doors_blocked = false
	for door in doors:
		if door.check_is_blocked():
			are_doors_blocked = true
			break
	if !are_doors_blocked:
		lock()

func find_type(type):
	var found = []
	for child in get_children():
		if child is type:
			found.append(child)
	return found

func _on_Room_body_entered(body):
	if body is Player && !is_cleared && is_open:
		set_physics_process(true)

func _on_Room_body_exited(body):
	set_physics_process(false)

func clear():
	is_cleared = true
	set_physics_process(false)

func _on_enemy_death(enemy):
	pass

func lock():
	is_open = false
	for door in doors:
		door.close()
	
	var players = get_tree().get_nodes_in_group("players")
	var player = players[0] if players.size() > 0 else null
	n_enemies = spawners.size()
	for spawner in spawners:
		var enemy : Character = spawner.spawn()
		if enemy != null:
			enemy.connect("killed", self, "_on_enemy_killed")
			if player != null:
				enemy.set_target(player)
	
	get_tree().call_group("prisoners", "on_room_locked")
	
	set_physics_process(false)
	emit_signal("locked")

func open():
	is_open = true
	for door in doors:
		door.call_deferred("open")
	var players = get_tree().get_nodes_in_group("players")
	var player = players[0] if players.size() > 0 else null
	if player != null:
		for prisoner in prisoners:
			prisoner.set_target(player)
	get_tree().call_group("prisoners", "on_room_unlocked")

func _on_enemy_killed():
	n_enemies -= 1
	if n_enemies == 0:
		open()
		is_cleared = true
		emit_signal("cleared")
