extends KinematicBody2D

const MAX_BOUNCES = 1

onready var head = $Body/Head
onready var body = $Body

export var move_speed = 8 * 16

var velocity := Vector2.ZERO
var times_bounced = 0

var previous_positions = []
var is_bound = true

func _ready():
	yield(get_tree(), "physics_frame")
	init_prev_positions()

func init_prev_positions():
	for i in body.get_child_count():
		previous_positions.append(global_position)

func _physics_process(delta):
	var prev_segment_pos = global_position
	head.global_position = prev_segment_pos
	for i in body.get_child_count():
		if i == 0:
			continue
		
		var segment = body.get_child(i)
		segment.global_position = previous_positions[i]
		var displacement = prev_segment_pos - segment.global_position
		segment.global_position += displacement / 4.0
		previous_positions[i] = segment.global_position
		prev_segment_pos = segment.global_position
	
	if !is_bound:
		update_velocity()
		var collision = move_and_collide(velocity * delta)
		if collision:
			velocity = velocity.bounce(collision.normal)
			times_bounced += 1
			if times_bounced > MAX_BOUNCES:
				destroy()

func update_velocity():
	pass

func launch(angle):
	velocity = polar2cartesian(move_speed, angle)
	is_bound = false

func destroy():
	var tween : Tween = $DestroyTween
	var fade_duration = 0.1
	
	for i in body.get_child_count():
		var segment = body.get_child(i)
		var delay = 0.075 * i
		tween.interpolate_property(segment, "scale", segment.scale, Vector2.ZERO, fade_duration, Tween.TRANS_BACK, Tween.EASE_IN, delay)
	
	tween.start()
	tween.connect("tween_all_completed", self, "queue_free")
	
	is_bound = true


func _on_DamageArea_hitteded():
	if !is_bound:
		destroy()
