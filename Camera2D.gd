extends Camera2D

export (NodePath) var target = null
export var is_following := true

func _ready():
	if target != null:
		var target_inst = get_node_or_null(target)
		if target_inst != null:
			target = weakref(target_inst)

func _physics_process(delta):
	if is_following:
		call_deferred("follow_target")

func follow_target():
	var target = get_target()
	if target != null:
		global_position = target.global_position

func get_target():
	return target.get_ref() if target != null && target is WeakRef else null
