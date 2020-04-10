extends Node
class_name Shaker

var shake_tween : Tween

var priority = 0

func _ready():
	shake_tween = Tween.new()
	add_child(shake_tween)

func start(object : Object, property : String, priority = 0, duration = 0.2, frequency := 15.0, amplitude = 16):
	if priority >= self.priority:
		self.priority = priority
		
		shake_tween.stop_all()
		var shake_duration = (1 / float(frequency))
		var initial = Vector2.ZERO
		var prev = polar2cartesian(amplitude, rand_range(-PI, PI))
		for i in floor(duration / shake_duration):
			var delay = i * shake_duration
			var rand = prev.rotated(PI + rand_range(-PI / 2.0, PI / 2.0))
#			rand.x = rand_range(-amplitude, amplitude)
#			rand.y = rand_range(-amplitude, amplitude)
			shake_tween.interpolate_property(object, property, prev, \
					rand, shake_duration, Tween.TRANS_SINE, Tween.EASE_IN_OUT, delay)
			prev = rand
		
		shake_tween.interpolate_property(object, property, prev, initial, \
				shake_duration, Tween.TRANS_SINE, Tween.EASE_IN_OUT, duration)
		shake_tween.interpolate_callback(self, duration, "set", "priority", 0)
		shake_tween.start()
