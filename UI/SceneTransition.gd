extends CanvasLayer

onready var animation_player = $ColorRect/AnimationPlayer

func _ready():
	PauseController.pause()
	animation_player.play_backwards("Fade")

func transition_to_new_scene(next_scene):
	if animation_player.is_playing():
		yield(animation_player, "animation_finished")
#	animation_player.play("Fade")
#	yield(animation_player, "animation_finished")
#
#	PauseController.unpause()
	
	if next_scene is String and next_scene.ends_with("tscn"):
		get_tree().change_scene(next_scene)
	
	elif next_scene is PackedScene:
		get_tree().change_scene_to(next_scene)
		
	animation_player.play("Fade")
#	yield(animation_player, "animation_finished")
	
	PauseController.unpause()
	
	yield(animation_player, "animation_finished")
	queue_free()
