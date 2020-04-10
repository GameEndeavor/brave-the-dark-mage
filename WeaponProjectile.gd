extends KinematicBody2D

signal returned()

const MOVE_SPEED = 12 * 16

onready var body = $Body
onready var return_timer = $ReturnDelay
var velocity := Vector2()
var weapon_ref = null setget set_weapon_ref

func _physics_process(delta):
	if return_timer.is_stopped():
		var weapon = get_weapon()
		if weapon != null:
			var displacement = weapon.global_position - global_position
			if displacement.length() < 8:
				emit_signal("returned")
				destroy()
			var desired_velocity = displacement.normalized() * MOVE_SPEED
			velocity = velocity.linear_interpolate(desired_velocity, 0.2)
	
	body.rotation += 8 * PI * delta
	position += velocity * delta
	

func throw(angle):
	velocity = polar2cartesian(MOVE_SPEED, angle)

func set_weapon_ref(value):
	if value is WeakRef:
		weapon_ref = value
	else:
		weapon_ref = weakref(value)

func get_weapon():
	return weapon_ref.get_ref() if weapon_ref is WeakRef else null

func destroy():
	queue_free()


func _on_ReturnDelay_timeout():
	$Body/DamageArea.exceptions = []
