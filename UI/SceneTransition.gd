extends CanvasLayer

onready var animation_player = $ColorRect/AnimationPlayer

signal scene_changed
signal faded_in
signal faded_out

#func transition_to_new_scene(next_scene):
#	PauseController.pause()
##	animation_player.playback_speed = 2
#	animation_player.play_backwards("Fade")
#
#
#	if animation_player.is_playing():
#		yield(animation_player, "animation_finished")
##	animation_player.play("Fade")
##	yield(animation_player, "animation_finished")
##
##	PauseController.unpause()
#
#	if next_scene is String and next_scene.ends_with("tscn"):
#		get_tree().change_scene(next_scene)
#
#	elif next_scene is PackedScene:
#		get_tree().change_scene_to(next_scene)
#
#	emit_signal("scene_changed")
#
##	animation_player.playback_speed = 1
#	animation_player.play("Fade")
##	yield(animation_player, "animation_finished")
#
#	PauseController.unpause()
#
#	yield(animation_player, "animation_finished")
#
##	animation_player.playback_speed = 1
#	queue_free()
	
func fade_in():
	animation_player.play_backwards("Fade")
	yield(animation_player, "animation_finished")
	emit_signal("faded_in")

func fade_out():
	animation_player.play("Fade")
	yield(animation_player, "animation_finished")
	emit_signal("faded_out")
