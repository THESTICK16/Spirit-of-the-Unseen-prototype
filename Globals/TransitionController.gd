extends Node

const SceneTransition = preload("res://UI/SceneTransition.tscn")

func change_to_new_scene(change_to):
	var scene_transition = SceneTransition.instance()
	get_tree().root.add_child(scene_transition)
	scene_transition.transition_to_new_scene(change_to)
