extends Node2D

export var level_music : AudioStream

func _ready():
	if level_music != null:
		if MusicController.get_current_music() != level_music or not MusicController.is_playing():
			MusicController.play_music(level_music)
