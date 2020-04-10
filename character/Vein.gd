extends Node2D

const LENGTH = 48
const N_SEGMENTS = LENGTH / 3
const SEGMENT_LENGTH = LENGTH / N_SEGMENTS

onready var line = $Line2D

export (NodePath) var shadow_path

var segments = []

func _ready():
	for i in N_SEGMENTS:
		var point = global_position
		line.add_point(point)
		segments.append(Segment.new(point))

func _physics_process(delta):
	simulate()
	apply_constraints()
	update_line()

func simulate():
	for i in range(1, segments.size()):
		var segment : Segment = segments[i]
		var velocity = (segment.current_position - segment.previous_position)
		segment.previous_position = segment.current_position
		var damp = 0.65 + (0.35 * (i / float(N_SEGMENTS)))
		segment.current_position += velocity * damp

func apply_constraints():
	for i in 10:
		var segment : Segment = segments[0]
		segment.current_position = global_position
		
		for i in segments.size() - 1:
			var segment_a : Segment = segments[i]
			var segment_b : Segment = segments[i + 1]
			
			var distance = (segment_a.current_position - segment_b.current_position).length()
			var offset = abs(distance - SEGMENT_LENGTH)
			var change = Vector2.ZERO
			
			if distance > SEGMENT_LENGTH:
				change = (segment_a.current_position - segment_b.current_position).normalized()
			elif distance < SEGMENT_LENGTH:
				change = (segment_b.current_position - segment_a.current_position).normalized()
			
			var change_amount = change * offset
			
			if i == 0:
				segment_b.current_position += change_amount
			else:
				segment_a.current_position -= change_amount * 0.5
				segment_b.current_position += change_amount * 0.5

func update_line():
	for i in segments.size():
		line.set_point_position(i, to_local(segments[i].current_position))
	var shadow = get_node_or_null(shadow_path)
	if shadow != null:
		shadow.points = line.points

class Segment extends Reference:
	var previous_position : Vector2
	var current_position : Vector2
	
	func _init(pos):
		previous_position = pos
		current_position = pos
