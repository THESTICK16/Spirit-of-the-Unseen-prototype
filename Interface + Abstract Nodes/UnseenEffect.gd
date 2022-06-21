extends Node

onready var parent = get_parent()
## If ture, making the entity dissapear will also disable their collisions
export var disble_collision := false
## If true, the object is visible. if false, invisible
var visible := true setget set_visible

signal eyes_on
signal eyes_off

func _ready():
	assert(parent != null)
	if not is_in_group("Unseen"):
		add_to_group("Unseen")
	visible = not PlayerStats.eyes_active
	toggle_visibility(visible)
#	if PlayerStats.eyes_active:
#		parent.call_deferred("hide")

#func _unhandled_input(_event):
#	if Input.is_action_just_pressed("toggle_eyes"):
#		toggle_visibility(visible)

func toggle_visibility(is_visible : bool):
	if not is_visible:
		emit_signal("eyes_on")
		if parent != null and parent.has_method("hide"):
			parent.call_deferred("hide") #maybe should not use this in real implementation, make an inherited scene for unseen things that uses the signal instead
#			if disble_collision:
#				parent.set_deferred("monitorable", false)
	elif is_visible:
		emit_signal("eyes_off")
		if parent != null and parent.has_method("show"):
			parent.call_deferred("show")
#			if disble_collision:
#				parent.set_deferred("monitorable", true)
#	match parent.visible:
#	match visible:
#		true:
#			emit_signal("eyes_on")
#			if parent != null and parent.has_method("hide"):
#				parent.call_deferred("hide") #maybe should not use this in real implementation, make an inherited scene for unseen things that uses the signal instead
##			if disble_collision:
##				parent.set_deferred("monitorable", false)
#		false:
#			emit_signal("eyes_off")
#			if parent != null and parent.has_method("show"):
#				parent.call_deferred("show")
##			if disble_collision:
##				parent.set_deferred("monitorable", true)

func set_visible(is_visible : bool):
	visible = is_visible
	toggle_visibility(visible)
