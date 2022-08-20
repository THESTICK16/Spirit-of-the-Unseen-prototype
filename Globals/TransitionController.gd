extends Node

const SceneTransition = preload("res://UI/SceneTransition.tscn")

signal scene_changed

func change_to_new_scene(change_to):
	var scene_transition = SceneTransition.instance()
	get_tree().root.add_child(scene_transition)
	
	PlayerStats.respawn_position = Vector2.ZERO
	if PlayerStats.health <= 0:
		PlayerStats.respawn()
	
	scene_transition.transition_to_new_scene(change_to)
	emit_signal("scene_changed")
