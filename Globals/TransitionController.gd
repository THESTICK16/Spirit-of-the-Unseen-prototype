extends Node

const SceneTransition = preload("res://UI/SceneTransition.tscn")

## True while the scene is transitioning, else false
var transitioning := false

signal scene_changed

#func change_to_new_scene(change_to):
#	var scene_transition = SceneTransition.instance()
#	get_tree().root.add_child(scene_transition)
#
#	if is_instance_valid(PlayerStats.player):
#		if not PlayerStats.player.is_dead: 
#			PlayerStats.respawn_position = Vector2.ZERO
#	if PlayerStats.health <= 0:
#		PlayerStats.respawn()
#
#	scene_transition.transition_to_new_scene(change_to)
#	emit_signal("scene_changed")

func change_to_new_scene(change_to):
	var scene_transition = SceneTransition.instance()
	get_tree().root.add_child(scene_transition)
	
	PauseController.pause()
	scene_transition.fade_in()
	yield(scene_transition, "faded_in")
	
#	_setup_player()
		
	if change_to is String and change_to.ends_with("tscn"):
		get_tree().change_scene(change_to)
	
	elif change_to is PackedScene:
		get_tree().change_scene_to(change_to)
	
	call_deferred("emit_signal", "scene_changed")
#	emit_signal("scene_changed")
	_setup_player()
		
	PauseController.unpause()
	scene_transition.fade_out()
	
	yield(scene_transition, "faded_out")
	scene_transition.queue_free()
	
func change_to_new_scene_and_set_player_position(change_to, change_scene_area_entered: ChangeSceneArea):
	var next_door_name = change_scene_area_entered.door_to_exit_from_name
	
	var scene_transition = SceneTransition.instance()
	get_tree().root.add_child(scene_transition)
	
	PauseController.pause()
	scene_transition.fade_in()
	yield(scene_transition, "faded_in")
	
#	_setup_player()
		
	if change_to is String and change_to.ends_with("tscn"):
		get_tree().change_scene(change_to)
	
	elif change_to is PackedScene:
		get_tree().change_scene_to(change_to)
	
	call_deferred("emit_signal", "scene_changed")
#	emit_signal("scene_changed")
	_setup_player()
	
#	for door in get_tree().get_nodes_in_group("ChangeSceneAreas"):
#		if door is ChangeSceneArea:
#			if door.name == next_door_name:
#				if is_instance_valid(PlayerStats.player):
#					if not PlayerStats.player.is_dead: 
#						PlayerStats.respawn_position = door.get_player_exit_position()
#	set_player_at_door(change_scene_area_entered, next_door_name)

	call_deferred("set_player_at_door", change_scene_area_entered, next_door_name)
		
	PauseController.call_deferred("unpause")
	scene_transition.call_deferred("fade_out")
	
	yield(scene_transition, "faded_out")
	scene_transition.queue_free()
	
	
	
#	change_to_new_scene(change_to)
	
func _setup_player():
	if is_instance_valid(PlayerStats.player):
		if not PlayerStats.player.is_dead: 
			PlayerStats.respawn_position = Vector2.ZERO
	if PlayerStats.health <= 0:
		PlayerStats.respawn()

func set_player_at_door(change_scene_area_entered: ChangeSceneArea, next_door_name: String):	
	for door in get_tree().get_nodes_in_group("ChangeSceneAreas"):
		if door is ChangeSceneArea:
			if door.name == next_door_name:
				if is_instance_valid(PlayerStats.player):
					if not PlayerStats.player.is_dead: 
						PlayerStats.player.global_position = door.get_player_exit_position()
						PlayerStats.player.camera.reset_smoothing() #FIXME This is not a good system and should be reworked so the player calls this method
						push_warning("The call being used here to reset camera smoothing is poor design practice. fix before progressing further")
						PlayerStats.player.direction = door.exit_direction
						PlayerStats.player.update_animation_tree_blend_positions()
#						PlayerStats.player.animation_tree.set("parameters/Idle/blend_position", PlayerStats.player.direction)
#						PlayerStats.player.animation_tree.set("parameters/Move/blend_position", PlayerStats.player.direction)
#						PlayerStats.player.animation_tree.set("parameters/Attack/blend_position", PlayerStats.player.direction)
