extends KinematicBody2D

onready var sprite = $Body/Pickup

var velocity := Vector2.ZERO
var z_velocity = 0
var gravity = null

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.normal)
	
	z_velocity += gravity * delta if gravity != null else Globals.gravity * delta
	sprite.position.y += z_velocity * delta
	if sprite.position.y >= 0:
		sprite.position.y = 0
		set_physics_process(false)
		$Area2D/CollisionShape2D.disabled = false

func spawn(angle = rand_range(-PI, PI), speed = 2.0 * 16, z_velocity = -50, initial_height = -8):
	velocity = polar2cartesian(speed, angle)
	self.z_velocity = z_velocity
	sprite.position.y = min(initial_height, 0)

func destroy():
	queue_free()

func _on_pickup(picker_upper):
	if picker_upper.has_method("heal"):
		picker_upper.heal(3)
	destroy()
