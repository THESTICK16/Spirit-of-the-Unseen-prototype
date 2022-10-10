extends Node2D

## The filepath of the object this spawner will spawn
export (String, FILE, "*.tscn") var object_to_spawn_filepath
## if true, the spawner will only spawn an object one time and then queue_free
export var single_use := false
## The number of objects the spawner will spawn on a single call to the spawn method
#export var num_to_spawn : int = 1
## The sound effect (if any) to play when an object spawns
export var sound_effect : AudioStream

onready var object_to_spawn = load(object_to_spawn_filepath)

func spawn():
	var new_object = object_to_spawn.instance()
	new_object.global_position = self.global_position
	get_tree().current_scene.call_deferred("add_child", new_object)# add_child(new_object)
	SFXController.play_sfx(sound_effect)
	if single_use:
		queue_free()
