extends KinematicBody2D

onready var sprite = $Body/ProjectileSprite

var velocity := Vector2.ZERO
var z_velocity = 0
var gravity = null

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		destroy()
	
	z_velocity += gravity * delta if gravity != null else Globals.gravity * delta
	sprite.position.y += z_velocity * delta
	if sprite.position.y >= 0:
		sprite.position.y = 0
		$DamageArea/CollisionShape2D.disabled = false
		set_physics_process(false)
		$AnimationPlayer.play("Splat")

func launch(angle, speed, z_velocity, initial_height = -8):
	velocity = polar2cartesian(speed, angle)
	self.z_velocity = z_velocity
	sprite.position.y = min(initial_height, 0)

func destroy():
	queue_free()
