extends Control

func transition_to_new_scene(next_scene):
	var transition_to = "res://TestResources/TestRoom.tscn" #Fix to not equal anything
	
	if next_scene is String and next_scene.ends_with("tscn"):
		transition_to = load(next_scene)
	
	elif next_scene is PackedScene:
		transition_to = next_scene
		
	if transition_to != null:
		get_tree().transition_to(transition_to)
