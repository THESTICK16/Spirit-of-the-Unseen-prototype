extends Node

## The purpose of this node is to dynamically set the scene that selecting "continue" will load in the game over screen while still inheriting from the menu scene

func _ready():
	if is_instance_valid(get_parent()):
		var parent = get_parent()
		if parent != null and parent.get("path_to_scene_to_load") != null:
			parent.path_to_scene_to_load = PlayerStats.last_scene_path
