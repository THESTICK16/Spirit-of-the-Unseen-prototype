extends Node

## A dictionary containg the levels' names as the key referencing their filepaths 
const levels := {}

const directory_path := "res://Levels/"

func _ready():
	pass
	
func load_level_paths():
	var levels_dict : Dictionary = {}
	var levels_directory = Directory.new()
	if levels_directory.open(directory_path) == OK:
		levels_directory.list_dir_begin()
		
		var file_name : String = levels_directory.get_next()
		while file_name != "":
			pass
