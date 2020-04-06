extends Node2D

onready var sort = $Sort
onready var hud = $HUDCanvas

func _ready():
	Globals.map = self

func add_entity(entity):
	sort.add_child(entity)

