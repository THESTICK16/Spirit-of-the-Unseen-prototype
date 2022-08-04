extends Area2D

onready var parent = get_parent()

func _ready():
	connect("area_entered", self, "broken")
	yield()
	assert(parent != null)
	
func broken(_area):
	if parent.has_method("broken"):
		parent.broken()
	else: parent.queue_free()
