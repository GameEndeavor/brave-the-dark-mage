extends Enemy

signal uncle()

const MAX_MAGIC_RADIUS = 28

onready var magic_container = $MagicContainer
onready var shield = $Body/Shield

onready var transition_timer = $Timers/TransitionTimer
onready var magic_tween = $Tweens/MagicTween

var magic_angle_offset = 0
var magic_radius = 0
var magic_angle_speed = PI
var hits = 0
var is_vulnerable = false

func _ready():
	max_health = 15
	health = max_health

func update_target():
	if get_target() == null:
		var players = get_tree().get_nodes_in_group("players")
		if players.size() > 0:
			set_target(players[0])

func update_magic():
	var count = magic_container.get_child_count()
	var angle_spacing = 2 * PI / count
	magic_angle_offset += magic_angle_speed * get_physics_process_delta_time()
	for i in count:
		var angle = angle_spacing * i + magic_angle_offset
		magic_container.get_child(i).position = polar2cartesian(magic_radius, angle)

func update_homing_magic():
	var target = get_target()
	if target != null && magic_container.get_child_count() > 0:
		var displacement = target.global_position - global_position
		var rt = magic_container.get_child(0)
		rt.position = polar2cartesian(MAX_MAGIC_RADIUS, displacement.angle())

func summon_homing_shield():
	summon_magic_shield(6, preload("res://magic/HomingBlackMagic.tscn"))

func summon_magic_shield(amount = 6, scene = preload("res://magic/BlackMagic.tscn")):
	for i in amount:
		var magic = scene.instance()
		Globals.map.add_entity(magic)
		var rt = RemoteTransform2D.new()
		rt.remote_path = magic.get_path()
		magic_container.add_child(rt)
	magic_tween.interpolate_property(self, "magic_radius", 0, MAX_MAGIC_RADIUS, 0.8, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	magic_tween.start()
	magic_angle_offset = randf() * 2 * PI

func summon_homing():
	var magic = preload("res://magic/HomingBlackMagic.tscn").instance()
	Globals.map.add_entity(magic)
	var rt = RemoteTransform2D.new()
	rt.remote_path = magic.get_path()
	magic_container.add_child(rt)

func launch_magic():
	for rt in magic_container.get_children():
		var magic = get_node(rt.remote_path)
		magic.launch(rt.position.angle())
		if magic is HomingBlackMagic:
			magic.set_target(target_ref)
		rt.queue_free()

func _on_destroyed():
	get_tree().call_group("black_magics", "destroy")
	Globals.game.end_game()

func _on_damaged():
	._on_damaged()
	hits += 1
	if hits >= 5:
		emit_signal("uncle")

func _on_Hitbox_damaged(amount, knockback_modifier, damage_source, attacker):
	if is_vulnerable:
		._on_Hitbox_damaged(amount, knockback_modifier, damage_source, attacker)
