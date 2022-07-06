extends Button

export var path_to_scene_to_load : String

var selected_sound = preload("res://Assets/Sound/SoundFX/Menu Selection Click.wav")

func _ready():
	connect("focus_entered", $FocusedAudioStreamPlayer, "play")
	connect("pressed", $SelectedAudioStreamPlayer, "play")
