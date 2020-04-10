extends Character
class_name Player

signal attacked()
signal attack_finished()
signal roll_finished()

onready var hand_pivot = $HandPivot
onready var hand = $HandPivot/Hand
onready var character_sprite = $Body/CharacterSprite
onready var hitbox_collision = $Hitbox/CollisionShape2D

onready var attack_tween = $Tweens/AttackTween
onready var jump_tween = $Tweens/JumpTween

onready var attack_buffer = $Timers/AttackBuffer

var weapon = null
var attack_modifier = -1
var attack_duration = 0.3 # TODO: Get from weapon
var attack_angle_range = PI / 2.0
var attack_direction = 1
var jump_height = -1 * 16
var jump_duration = 0.4
var move_input : Vector2
var facing := Vector2.RIGHT
var roll_velocity = 10 * 16
var is_weapon_thrown = false

func _ready():
	set_weapon(preload("res://weapons/Weapon.tscn").instance())
	call_deferred("make_connections")

func _input(event):
	if event.is_action_pressed("attack"):
		attack()
	elif event.is_action_pressed("secondary_attack"):
		secondary_attack()

func make_connections():
	var health_bar = Globals.game.hud.health_bar
	connect("health_changed", health_bar, "_on_value_changed")
	connect("max_health_changed", health_bar, "_on_max_value_changed")
	health_bar._on_value_changed(health)
	health_bar._on_max_value_changed(max_health)

func _update_move_input():
	move_input.x = -int(Input.is_action_pressed("move_left")) + int(Input.is_action_pressed("move_right"))
	move_input.y = -int(Input.is_action_pressed("move_up")) + int(Input.is_action_pressed("move_down"))
	move_input = move_input.normalized()

func _update_facing():
	if move_input != Vector2.ZERO:
		facing = move_input
	var mouse = get_global_mouse_position() - hand_pivot.global_position
	body.scale.x = -1 if mouse.x < 0 else 1
	hand_pivot.scale.y = body.scale.x

func apply_velocity():
	var desired_velocity = move_input * move_speed_units * 16
	velocity = velocity.linear_interpolate(desired_velocity, get_move_weight())

func apply_roll_velocity():
	velocity = velocity.linear_interpolate(Vector2.ZERO, 0.005)

func heal(amount):
	amount = max(amount, 0)
	set_health(health + amount)
	if !$Heal.playing:
		$Heal.play()

func aim_weapon():
	var mouse_angle = (get_global_mouse_position() - hand_pivot.global_position).angle()
	hand_pivot.rotation = mouse_angle
	if weapon != null:
		hand.transform = weapon.get_hand_transform(attack_modifier)
		hand_pivot.show_behind_parent = weapon.global_position.y < hand_pivot.global_position.y

func set_weapon(weapon):
	if self.weapon != null:
		self.weapon.queue_free()
	
	if weapon != null:
		hand.add_child(weapon)
		self.weapon = weapon
		weapon.init(self)
#		hitbox.add_exception(weapon.damage_area)
		weapon.damage_area.collision_layer = CollisionLayers.ENEMY_HAZARD
	
	connect("attacked", weapon, "_on_attacked")
	connect("attack_finished", weapon, "_on_attack_finished")

func attack():
	if !attack_tween.is_active() && state_machine.can_attack() && !is_weapon_thrown:
		emit_signal("attacked")
		attack_tween.interpolate_property(self, "attack_modifier", \
			attack_modifier, -attack_modifier, attack_duration, \
			Tween.TRANS_CUBIC, Tween.EASE_OUT)
		attack_tween.interpolate_callback(self, attack_duration, "_on_attack_finished")
		attack_tween.start()
	else:
		attack_buffer.start()


func secondary_attack():
	if !is_weapon_thrown:
		is_weapon_thrown = true
		weapon.hide()
		var projectile = preload("res://WeaponProjectile.tscn").instance()
		Globals.map.add_entity(projectile)
		projectile.global_transform = weapon.global_transform
		var displacement = get_global_mouse_position() - projectile.global_position
		projectile.set_weapon_ref(weapon)
		projectile.throw(displacement.angle())
		projectile.connect("returned", self, "_on_weapon_returned")

func _on_weapon_returned():
	weapon.show()
	is_weapon_thrown = false

func roll():
	jump_tween.interpolate_property(character_sprite, "position:y", 0, jump_height, \
			jump_duration / 2.0, Tween.TRANS_SINE, Tween.EASE_OUT)
	jump_tween.interpolate_property(character_sprite, "position:y", jump_height, 0, \
			jump_duration / 2.0, Tween.TRANS_SINE, Tween.EASE_IN, jump_duration / 2.0)
	jump_tween.interpolate_callback(self, jump_duration, "_on_roll_finished")
	jump_tween.start()
	
	hitbox_collision.disabled = true
	velocity = facing * roll_velocity

func _on_roll_finished():
	emit_signal("roll_finished")
	hitbox_collision.disabled = false

func _on_attack_finished():
	emit_signal("attack_finished")
	attack_tween.set_active(false)
	attack_direction = -attack_direction
	if !attack_buffer.is_stopped():
		attack_buffer.stop()
		attack()

func _on_PickupArea_area_entered(area):
	if area.has_method("pickup"):
		area.pickup(self)

func on_portal_enter(portal):
	Globals.game.start_next_level()

func _on_destroyed():
	Globals.game.restart_level()
